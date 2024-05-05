CREATE PROCEDURE [RDS].[Insert_CountsIntoReportTable]
	@ReportCode varchar(10),
	@SubmissionYear VARCHAR(10), 
	@ReportTableName VARCHAR(50),
	@IdentifierToCount VARCHAR(100),
	@CountColumn VARCHAR(100),
	@IsDistinctCount bit
AS 

	DECLARE @FactTypeCode VARCHAR(50)
	select @FactTypeCode = RDS.Get_FactTypeByReport(@ReportCode)

	DECLARE @SchoolYearId INT
	SELECT @SchoolYearId = DimSchoolYearId
	FROM RDS.DimSchoolYears 
	WHERE SchoolYear = @SubmissionYear
	
	DECLARE @SQLStatement NVARCHAR(MAX);

	DECLARE cursor_name CURSOR FOR
    SELECT N'
		DELETE FROM rds.' + @ReportTableName + ' WHERE ReportCode = ''' + @ReportCode + ''' AND ReportYear = ''' + @SubmissionYear + ''' AND CategorySetCode = ''' + CategorySetCode + ''' AND ReportLevel = ''' + aol.LevelCode + '''

		-- insert ' + aol.LevelCode + ' sql
		;WITH PermittedValues AS (
			SELECT DISTINCT 
			' + STRING_AGG('pv' + c.CategoryCode + '.CategoryOptionCode AS ' + c.CategoryCode, CHAR(10) + '		, ') + '
			FROM ' + STRING_AGG('app.CategoryCodeOptionsByReportAndYear pv' + c.CategoryCode, CHAR(10) + '		CROSS JOIN ') + '
			WHERE ' + STRING_AGG('pv' + c.CategoryCode + '.ReportCode = ''' + @ReportCode + ''' AND pv' + c.CategoryCode + '.SubmissionYear = ' + @SubmissionYear + ' AND pv' + c.CategoryCode + '.CategorySetCode = ''' + cs.CategorySetCode + ''' AND pv' + c.CategoryCode + '.CategoryCode = ''' + c.CategoryCode + ''' AND pv' + c.CategoryCode + '.TableTypeAbbrv = ''' + att.TableTypeAbbrv + '''', ' AND ') + '
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
			' + CASE WHEN CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(d.DimensionFieldName, ','), '') + ',' END + '
			' + @CountColumn + '
				
		)
		select 
			''' + ReportCode + ''',
			''' + SubmissionYear + ''',
			''' + LevelCode + ''',
			''' + CategorySetCode + ''',
			' + CASE WHEN CategorySetCode = 'TOT' THEN 'NULL,' ELSE '''' + ISNULL(STRING_AGG('|' + CategoryCode + '|', ','), '') + ''',' END + '
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
					WHEN cs.CategorySetCode = 'TOT'
						OR cs.CategorySetCode LIKE 'ST%' THEN 'Y'
					ELSE 'N'
				  END + ''' as TotalIndicator, ' 
				  + CASE WHEN CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(DimensionFieldName + 'EDFactsCode', ','), '') + ',' END + '
			count(' + CASE @IsDistinctCount WHEN 1 THEN 'DISTINCT' ELSE '' END + ' cs.' + @IdentifierToCount + ')
		FROM rds.vw' + @FactTypeCode + '_FactTable_' + @ReportCode + ' cs 
		' + CASE 
				WHEN cs.CategorySetCode <> 'TOT' 
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
			'  + CASE WHEN CategorySetCode = 'TOT' THEN '' ELSE ',' + ISNULL(STRING_AGG(DimensionFieldName + 'EdFactsCode', ','), '')  END + '
			
			'
	FROM app.GenerateReports gr
	JOIN app.CategorySets cs
		on cs.GenerateReportId = gr.GenerateReportId
	LEFT JOIN app.CategorySet_Categories csc
		on csc.CategorySetId = cs.CategorySetId
	LEFT JOIN app.Categories c 
		on c.CategoryId = csc.CategoryId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
	LEFT JOIN app.GenerateReport_TableType grtt
		on gr.GenerateReportId = grtt.GenerateReportId
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
		--select @SQLStatement
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
			WHERE ' + STRING_AGG('pv' + c.CategoryCode + '.ReportCode = ''' + @ReportCode + ''' AND pv' + c.CategoryCode + '.SubmissionYear = ' + @SubmissionYear + ' AND pv' + c.CategoryCode + '.CategorySetCode = ''' + cs.CategorySetCode + ''' AND pv' + c.CategoryCode + '.CategoryCode = ''' + c.CategoryCode + ''' AND pv' + c.CategoryCode + '.TableTypeAbbrv = ''' + att.TableTypeAbbrv + '''', ' AND ') + '

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
			' + CASE WHEN CategorySetCode = 'TOT' THEN '' ELSE '' + ISNULL(STRING_AGG(d.DimensionFieldName, ','), '') + ',' END + '
			' + @CountColumn + '
				
		)
		select 
			''' + ReportCode + ''',
			''' + SubmissionYear + ''',
			''' + LevelCode + ''',
			''' + CategorySetCode + ''',
			' + CASE WHEN CategorySetCode = 'TOT' THEN 'NULL,' ELSE '''' + ISNULL(STRING_AGG('|' + CategoryCode + '|', ','), '') + ''',' END + '
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
					WHEN cs.CategorySetCode = 'TOT'
						OR cs.CategorySetCode LIKE 'ST%' THEN 'Y'
					ELSE 'N'
				  END + ''' as TotalIndicator, ' 
				  + STRING_AGG('pv.' + CategoryCode, ',') + ',
			0
		FROM PermittedValues pv
			 ' + CASE WHEN aol.LevelCode <> 'SEA' THEN 'CROSS JOIN (SELECT LeaId, K12SchoolId FROM RDS.FactOrganizationCounts WHERE SchoolYearId = ' + CAST(@SchoolYearId AS VARCHAR(100))  END + ') rfoc
			 ' + CASE 
			 		WHEN aol.LevelCode = 'LEA' THEN 'JOIN RDS.DimLeas org ON rfoc.LeaId = org.DimLeaId AND org.DimLeaId <> -1' 
			 		WHEN aol.LevelCode = 'SCH' THEN 'JOIN RDS.DimK12Schools org ON rfoc.K12SchoolId = org.DimK12SchoolId AND org.DimK12SchoolId <> -1' 
				END + '
		LEFT JOIN RDS.' + @ReportTableName + ' rt
			ON rt.CategorySetCode = ''' + cs.CategorySetCode + ''' AND rt.TableTypeAbbrv = ''' + att.TableTypeAbbrv + ''' AND rt.ReportYear = 2023 and rt.ReportLevel = ''' + aol.LevelCode + ''' AND ' + 
			STRING_AGG('rt.' + d.DimensionFieldName + ' = pv.' + c.CategoryCode, ' AND ') +
			CASE 
				WHEN aol.LevelCode = 'LEA' THEN ' AND rt.OrganizationIdentifierSea = org.LeaIdentifierSea'
				WHEN aol.LevelCode = 'SCH' THEN ' AND rt.OrganizationIdentifierSea = org.SchoolIdentifierSea'
			END + '
		WHERE rt.' + @CountColumn + ' IS NULL'

	FROM app.GenerateReports gr
	JOIN app.CategorySets cs
		on cs.GenerateReportId = gr.GenerateReportId
	LEFT JOIN app.CategorySet_Categories csc
		on csc.CategorySetId = cs.CategorySetId
	LEFT JOIN app.Categories c 
		on c.CategoryId = csc.CategoryId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
	LEFT JOIN app.GenerateReport_TableType grtt
		on gr.GenerateReportId = grtt.GenerateReportId
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
		--select @SQLStatement
		EXEC sp_executesql @SQLStatement;
		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END

	CLOSE cursor_name;
	DEALLOCATE cursor_name;

