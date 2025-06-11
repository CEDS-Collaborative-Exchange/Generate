CREATE PROCEDURE [RDS].[Insert_CountsIntoReportTable]
	@ReportCode varchar(10),
	@SubmissionYear VARCHAR(10), 
	@IdentifierToCount VARCHAR(100),
	@IsDistinctCount bit,
	@RunAsTest bit
AS 

	--Error message variable
	DECLARE @ErrorMessage nvarchar(4000)

	--Get the Column to count and the Report table name from the metadata
	DECLARE @CountColumn VARCHAR(100), @ReportTableName VARCHAR(100)

	SELECT
		@CountColumn = aft.FactFieldName,
		@ReportTableName = aft.FactReportTableName
	FROM app.generatereports agr
	INNER JOIN app.FactTables aft
		ON agr.FactTableId = aft.FactTableId
	WHERE agr.ReportCode = @ReportCode

		--handle invalid return
		IF @CountColumn IS NULL OR @ReportTableName IS NULL
		BEGIN
			SET @ErrorMessage = concat(@reportCode, ' - Could not get Count Column or Report Table Name for selected Report Code, migration stopped.')
			INSERT INTO app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 3, @ErrorMessage)

			RAISERROR(@ErrorMessage, 16, 1)

			RETURN
		END		

	--Get the Fact Type associated with the File Specification
	DECLARE @FactTypeCode VARCHAR(50)
	SELECT @FactTypeCode = RDS.Get_FactTypeByReport(@ReportCode)

		--handle invalid return
		IF @FactTypeCode IS NULL
		BEGIN
			SET @ErrorMessage = concat(@reportCode, ' - Could not get the associated Fact Type code for selected Report Code, migration stopped.')
			INSERT INTO app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 3, @ErrorMessage)

			RAISERROR(@ErrorMessage, 16, 1)

			RETURN
		END		

	DECLARE @SchoolYearId INT
	SELECT @SchoolYearId = DimSchoolYearId
	FROM RDS.DimSchoolYears 
	WHERE SchoolYear = @SubmissionYear
	
	--Remove the existing report rows and repopulate the report data 
	DECLARE @SQLStatement NVARCHAR(MAX);

	DECLARE cursor_name CURSOR FOR
    SELECT N'
		DELETE FROM rds.' + @ReportTableName + ' WHERE ReportCode = ''' + @ReportCode + ''' AND ReportYear = ''' + @SubmissionYear + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' THEN '' ELSE ''' AND CategorySetCode = ''' + CategorySetCode END + ''' AND ReportLevel = ''' + aol.LevelCode + '''

		-- insert ' + aol.LevelCode + ' sql
		' + CASE WHEN ISNULL(STRING_AGG(c.CategoryCode, ''),'') = '' THEN '' ELSE '
		;WITH PermittedValues AS (
			SELECT DISTINCT 
			' + STRING_AGG('pv' + c.CategoryCode + '.CategoryOptionCode AS ' + c.CategoryCode, CHAR(10) + '		, ') + '
			FROM ' + STRING_AGG('app.CategoryCodeOptionsByReportAndYear pv' + c.CategoryCode, CHAR(10) + '		CROSS JOIN ') + '
			WHERE ' + STRING_AGG('pv' + c.CategoryCode + '.ReportCode = ' + @ReportCode + ' AND pv' + c.CategoryCode + '.SubmissionYear = ' + @SubmissionYear + ' AND pv' + c.CategoryCode + '.CategorySetCode = ''' + cs.CategorySetCode + ''' AND pv' + c.CategoryCode + '.CategoryCode = ''' + c.CategoryCode + ''' AND pv' + c.CategoryCode + '.TableTypeAbbrv = ''' + att.TableTypeAbbrv + '''', ' AND ') + '
		)' END + '
		insert into rds.' + @ReportTableName + '
		(
			ReportCode,
			ReportYear,
			ReportLevel,
			CategorySetCode,
			Categories,
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			TableTypeAbbrv,
			TotalIndicator,
			' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(d.DimensionFieldName, ','), '') + ',' END + '
			' + @CountColumn + '
		)
		select 
			''' + ReportCode + ''',
			''' + SubmissionYear + ''',
			''' + LevelCode + ''',
			''' + CategorySetCode + ''',
			' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN 'NULL,' ELSE '''' + ISNULL(STRING_AGG('|' + CategoryCode + '|', ','), '') + ''',' END + '
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			isnull(StateANSICode,''''),' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationIdentifierSea'
				WHEN 'LEA' THEN 'LeaIdentifierSea' 
				WHEN 'SCH' THEN 'SchoolIdentifierSea'			
			END  + ',
			' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationName'
				WHEN 'LEA' THEN 'LeaOrganizationName' 
				WHEN 'SCH' THEN 'NameOfInstitution'			
			END  + ',
			' + 
			CASE aol.LevelCode
				WHEN 'SCH' THEN 'LeaIdentifierSea'			
				ELSE 'NULL'
			END  + ',
			''' + att.TableTypeAbbrv + ''' as TableTypeAbbrv,
			''' + CASE 
					WHEN STRING_AGG(c.CategoryCode, '') = ''
						OR cs.CategorySetCode = 'TOT'
						OR cs.CategorySetCode LIKE 'ST%' THEN 'Y'
					ELSE 'N'
				  END + ''' as TotalIndicator, ' 
				  + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(DimensionFieldName + 'EDFactsCode', ','), '') + ',' END + '
			count(' + CASE @IsDistinctCount WHEN 1 THEN 'DISTINCT' ELSE '' END + ' cs.' + @IdentifierToCount + ')
		FROM rds.vw' + @FactTypeCode + '_FactTable_' + @ReportCode + ' cs 
		' + CASE 
				WHEN CategorySetCode IS NOT NULL AND cs.CategorySetCode <> 'TOT' 
					THEN 'JOIN PermittedValues pv ON ' + STRING_AGG('cs.' + D.DimensionFieldName + 'EdFactsCode = pv.' + c.CategoryCode, ' AND ')
				ELSE ''
			END + '
		' + CASE aol.LevelCode 
				WHEN 'LEA' THEN 'WHERE LeaIdentifierSea IS NOT NULL'
				WHEN 'SCH' THEN 'WHERE SchoolIdentifierSea IS NOT NULL'
				ELSE ''
			END + '
		group by 
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationIdentifierSea'
				WHEN 'LEA' THEN 'LeaIdentifierSea' 
				WHEN 'SCH' THEN 'LeaIdentifierSea,SchoolIdentifierSea'			
			END  + ',
			' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationName'
				WHEN 'LEA' THEN 'LeaOrganizationName' 
				WHEN 'SCH' THEN 'NameOfInstitution'			
			END  + '
			'  + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN '' ELSE ',' + ISNULL(STRING_AGG(DimensionFieldName + 'EdFactsCode', ','), '')  END + '
			
			'
	FROM app.GenerateReports gr
	LEFT JOIN app.CategorySets cs
		ON cs.GenerateReportId = gr.GenerateReportId
	LEFT JOIN app.CategorySet_Categories csc
		ON csc.CategorySetId = cs.CategorySetId
	LEFT JOIN app.Categories c 
		ON c.CategoryId = csc.CategoryId
	LEFT JOIN app.GenerateReport_OrganizationLevels grol
		ON grol.GenerateReportId = gr.GenerateReportId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
			OR grol.OrganizationLevelId = aol.OrganizationLevelId
	LEFT JOIN app.GenerateReport_TableType grtt
		ON gr.GenerateReportId = grtt.GenerateReportId
	JOIN app.TableTypes att
		ON cs.TableTypeId = att.TableTypeId
			OR grtt.TableTypeId = att.TableTypeId
	LEFT JOIN app.Category_Dimensions cd
		ON c.CategoryId = cd.CategoryId
	LEFT JOIN app.Dimensions d
		ON cd.DimensionId = d.DimensionId
	
	WHERE cs.SubmissionYear = @SubmissionYear
		AND gr.ReportCode = @ReportCode
	GROUP BY 
		  gr.ReportCode
		, aol.LevelCode
		, cs.CategorySetCode
		, att.TableTypeAbbrv
		, cs.SubmissionYear
	OPEN cursor_name;

	FETCH NEXT FROM cursor_name INTO @SQLStatement;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQLStatement = REPLACE(REPLACE(@SQLStatement, ',NOCATS', ''), '_NOCATS', '')

		--Either execute the created SQL or output it for debugging
		IF @RunAsTest = 1 
			PRINT @SQLStatement;
		ELSE
			EXEC sp_executesql @SQLStatement;
		
		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END

	CLOSE cursor_name;
	DEALLOCATE cursor_name;

	--Remove the rows with CategoryOption values = 'MISSING' and insert zero counts
	DECLARE cursor_name CURSOR FOR
	SELECT N'
		-- delete rows with CategoryOption values = ''MISSING''
		IF (SELECT COUNT(DISTINCT ' + d.DimensionFieldName + ') 
			FROM rds.' + @ReportTableName + '
			WHERE ' + d.DimensionFieldName + ' <> ''MISSING''
				AND ReportCode = ' + @ReportCode + '
				AND ReportYear = ''' + @SubmissionYear + ''' 
				AND CategorySetCode = ''' + CategorySetCode + ''' 
				AND ReportLevel = ''' + aol.LevelCode + ''' 
				) > 0
		BEGIN
			DELETE FROM rds.' + @ReportTableName + '
			WHERE ReportCode = ' + @ReportCode + ' 
				AND ReportYear = ''' + @SubmissionYear + ''' 
				AND CategorySetCode = ''' + CategorySetCode + ''' 
				AND ReportLevel = ''' + aol.LevelCode + ''' 
				AND ' + d.DimensionFieldName + ' = ''MISSING''
		END
		'
	FROM app.GenerateReports gr
	JOIN app.CategorySets cs
		ON cs.GenerateReportId = gr.GenerateReportId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
	JOIN app.CategorySet_Categories csc
		ON cs.CategorySetId = csc.CategorySetId
	JOIN app.Categories c 
		on c.CategoryId = csc.CategoryId
	JOIN app.Category_Dimensions cd
		ON c.CategoryId = cd.CategoryId
	JOIN app.Dimensions d
		ON cd.DimensionId = d.DimensionId
	WHERE cs.SubmissionYear = @SubmissionYear
		AND gr.ReportCode = @ReportCode
	
	OPEN cursor_name;
	FETCH NEXT FROM cursor_name INTO @SQLStatement;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Either execute the created SQL or output it for debugging
		IF @RunAsTest = 1 
			PRINT @SQLStatement;
		ELSE
			EXEC sp_executesql @SQLStatement;

		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END
	
	CLOSE cursor_name;
	DEALLOCATE cursor_name;

	DECLARE cursor_name CURSOR FOR
    SELECT N'
		-- insert ' + aol.LevelCode + ' zero counts
		;WITH PermittedValues AS (
			SELECT DISTINCT 
			' + STRING_AGG('pv' + c.CategoryCode + '.CategoryOptionCode AS ' + c.CategoryCode, CHAR(10) + '		, ') + '
			FROM ' + STRING_AGG('app.CategoryCodeOptionsByReportAndYear pv' + c.CategoryCode, CHAR(10) + '		CROSS JOIN ') + '
			WHERE ' + STRING_AGG('pv' + c.CategoryCode + '.ReportCode = ' + @ReportCode + ' AND pv' + c.CategoryCode + '.SubmissionYear = ' + @SubmissionYear + ' AND pv' + c.CategoryCode + '.CategorySetCode = ''' + cs.CategorySetCode + ''' AND pv' + c.CategoryCode + '.CategoryCode = ''' + c.CategoryCode + ''' AND pv' + c.CategoryCode + '.TableTypeAbbrv = ''' + att.TableTypeAbbrv + '''', ' AND ') + '
				AND ' + STRING_AGG('pv' + c.CategoryCode + '.CategoryOptionCode <> ''MISSING''' , ' AND ') + '
		)
		insert into rds.' + @ReportTableName + '
		(
			ReportCode,
			ReportYear,
			ReportLevel,
			CategorySetCode,
			Categories,
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			TableTypeAbbrv,
			TotalIndicator,
			' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(d.DimensionFieldName, ','), '') + ',' END + '
			' + @CountColumn + '
				
		)
		select 
			''' + ReportCode + ''',
			''' + SubmissionYear + ''',
			''' + LevelCode + ''',
			''' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' THEN '' ELSE CategorySetCode END + ''',
			' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' OR CategorySetCode = 'TOT' THEN 'NULL,' ELSE '''' + ISNULL(STRING_AGG('|' + CategoryCode + '|', ','), '') + ''',' END + '
			org.StateANSICode,
			org.StateAbbreviationCode,
			org.StateAbbreviationDescription,
			isnull(org.StateANSICode,''''),' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationIdentifierSea'
				WHEN 'LEA' THEN 'LeaIdentifierSea' 
				WHEN 'SCH' THEN 'SchoolIdentifierSea'			
			END  + ',
			' + 
			CASE aol.LevelCode
				WHEN 'SEA' THEN 'SeaOrganizationName'
				WHEN 'LEA' THEN 'LeaOrganizationName' 
				WHEN 'SCH' THEN 'NameOfInstitution'			
			END  + ',
			' + 
			CASE aol.LevelCode
				WHEN 'SCH' THEN 'LeaIdentifierSea'			
				ELSE 'NULL'
			END  + ',
			''' + att.TableTypeAbbrv + ''' as TableTypeAbbrv,
			''' + CASE 
					WHEN STRING_AGG(c.CategoryCode, '') = ''
						OR cs.CategorySetCode = 'TOT'
						OR cs.CategorySetCode LIKE 'ST%' THEN 'Y'
					ELSE 'N'
				  END + ''' as TotalIndicator, ' 
				  + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' THEN '' ELSE STRING_AGG('pv.' + CategoryCode, ',') END + ',
			0
		FROM PermittedValues pv
			 ' + CASE WHEN aol.LevelCode <> 'SEA' THEN 'CROSS JOIN (SELECT LeaId, K12SchoolId FROM RDS.FactOrganizationCounts WHERE SchoolYearId = ' + CAST(@SchoolYearId AS VARCHAR(100))  END + ') rfoc
			 ' + CASE 
			 		WHEN aol.LevelCode = 'LEA' THEN 'JOIN RDS.DimLeas org ON rfoc.LeaId = org.DimLeaId AND org.DimLeaId <> -1' 
			 		WHEN aol.LevelCode = 'SCH' THEN 'JOIN RDS.DimK12Schools org ON rfoc.K12SchoolId = org.DimK12SchoolId AND org.DimK12SchoolId <> -1' 
				END + '
		LEFT JOIN RDS.' + @ReportTableName + ' rt
			ON 
			' + CASE WHEN STRING_AGG(c.CategoryCode, '') = '' THEN '' ELSE 'rt.CategorySetCode  = ''' + cs.CategorySetCode + ''' AND ' END + '
			rt.TableTypeAbbrv = ''' + att.TableTypeAbbrv + ''' AND rt.ReportYear = ' + @SubmissionYear + ' and rt.ReportLevel = ''' + aol.LevelCode + ''' AND ' + 
			STRING_AGG('rt.' + d.DimensionFieldName + ' = pv.' + c.CategoryCode, ' AND ') +
			CASE 
				WHEN aol.LevelCode = 'LEA' THEN ' AND rt.OrganizationIdentifierSea = org.LeaIdentifierSea'
				WHEN aol.LevelCode = 'SCH' THEN ' AND rt.OrganizationIdentifierSea = org.SchoolIdentifierSea'
			END + '
		WHERE rt.' + @CountColumn + ' IS NULL'

	FROM app.GenerateReports gr
	LEFT JOIN app.CategorySets cs
		ON cs.GenerateReportId = gr.GenerateReportId
	LEFT JOIN app.CategorySet_Categories csc
		ON csc.CategorySetId = cs.CategorySetId
	LEFT JOIN app.Categories c 
		ON c.CategoryId = csc.CategoryId
	LEFT JOIN app.GenerateReport_OrganizationLevels grol
		ON grol.GenerateReportId = gr.GenerateReportId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
			OR grol.OrganizationLevelId = aol.OrganizationLevelId
	LEFT JOIN app.GenerateReport_TableType grtt
		ON gr.GenerateReportId = grtt.GenerateReportId
	JOIN app.TableTypes att
		ON cs.TableTypeId = att.TableTypeId
			OR grtt.TableTypeId = att.TableTypeId
	LEFT JOIN app.Category_Dimensions cd
		ON c.CategoryId = cd.CategoryId
	LEFT JOIN app.Dimensions d
		ON cd.DimensionId = d.DimensionId
	WHERE cs.SubmissionYear = @SubmissionYear
		AND gr.ReportCode = @ReportCode
	GROUP BY 
		  gr.ReportCode
		, aol.LevelCode
		, cs.CategorySetCode
		, att.TableTypeAbbrv
		, cs.SubmissionYear
	OPEN cursor_name;

	FETCH NEXT FROM cursor_name INTO @SQLStatement;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQLStatement = REPLACE(REPLACE(@SQLStatement, ',NOCATS', ''), '_NOCATS', '')

		--Either execute the created SQL or output it for debugging
		IF @RunAsTest = 1 
			PRINT @SQLStatement;
		ELSE
			EXEC sp_executesql @SQLStatement;

		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END

	CLOSE cursor_name;
	DEALLOCATE cursor_name;
