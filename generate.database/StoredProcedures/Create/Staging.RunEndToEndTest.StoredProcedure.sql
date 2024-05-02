CREATE PROCEDURE [Staging].[RunEndToEndTest]
	@ReportCode varchar(10),
	@SchoolYear VARCHAR(10), 
	@ReportTableName VARCHAR(50),
	@IdentifierToCount VARCHAR(100),
	@CountColumn VARCHAR(100),
	@IsDistinctCount bit
AS 

	DECLARE @SqlUnitTestId INT = 0, @expectedResult INT, @actualResult INT

	IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS' + RIGHT(@ReportCode, 3) + '_UnitTestCase') 
	BEGIN
		SET @expectedResult = 1
		INSERT INTO App.SqlUnitTest (
			UnitTestName,
			StoredProcedureName,
			TestScope,
			IsActive
		) VALUES (
			'FS' + RIGHT(@ReportCode, 3) + '_UnitTestCase',
			'FS' + RIGHT(@ReportCode, 3) + '_TestCase',
			'FS' + RIGHT(@ReportCode, 3),
			1
		)
		SET @SqlUnitTestId = @@IDENTITY
	END 
	ELSE 
	BEGIN
		SELECT 
			@SqlUnitTestId = SqlUnitTestId
		FROM App.SqlUnitTest 
		WHERE UnitTestName = 'FS' + RIGHT(@ReportCode, 3) + '_UnitTestCase'
	END
	
	-- Clear out last run
	DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

	DECLARE @SQLStatement NVARCHAR(MAX);

	SET @SQLStatement = 
	'SELECT *
	INTO ##' + @ReportCode + 'Staging
	FROM Staging.vw' + rds.Get_FactTypeByReport(@ReportCode) + '_StagingTable_' + @ReportCode 

	EXEC sp_executesql @SQLStatement;

	DECLARE cursor_name CURSOR FOR
    SELECT N'
		;WITH StagingData AS (
			SELECT
				COUNT(' + CASE WHEN @IsDistinctCount = 1 THEN 'DISTINCT' ELSE '' END + ' ' + @IdentifierToCount + ') AS ' + @CountColumn + 
				CASE aol.LevelCode 
					WHEN 'LEA' THEN ', LEAIdentifierSeaAccountability AS LeaIdentifierSea'
					WHEN 'SCH' THEN ', SchoolIdentifierSea'
					ELSE ''
				END + '
				' + ISNULL(STRING_AGG(', ' + d.DimensionFieldName, CHAR(10) + '				'), '') + '
			FROM ##' + @ReportCode + 'Staging
			GROUP BY 
			' + 
				CASE aol.LevelCode 
					WHEN 'LEA' THEN 'LEAIdentifierSeaAccountability'
					WHEN 'SCH' THEN 'SchoolIdentifierSea'
					ELSE ''
				END 
			+ ISNULL(STRING_AGG(', ' + d.DimensionFieldName, CHAR(10) + '				'), '') + '
		)

		INSERT INTO App.SqlUnitTestCaseResult (
			[SqlUnitTestId]
			,[TestCaseName]
			,[TestCaseDetails]
			,[ExpectedResult]
			,[ActualResult]
			,[Passed]
			,[TestDateTime]
		)
		SELECT 
			' + CAST(@SqlUnitTestId AS VARCHAR(100)) + '
			,''' + cs.CategorySetCode + ' ' + aol.LevelCode + '''
			,' + 
			CASE aol.LevelCode 
				WHEN 'LEA' THEN '''LEA: '' + rt.OrganizationIdentifierSea + '  
				WHEN 'SCH' THEN '''SCH: '' + rt.OrganizationIdentifierSea + ' 
			END 
			+ ISNULL(STRING_AGG('''  ' + c.CategoryCode + ': ''+ convert(varchar, s.' + d.DimensionFieldName + ')', ' + ' + CHAR(10) + '				'), '''TOT''') + '
			,s.' + @CountColumn + '
			,rt.' + @CountColumn + '
			,CASE WHEN s.' + @CountColumn + ' = ISNULL(rt.' + @CountColumn + ', -1) THEN 1 ELSE 0 END
			,GETDATE()
		FROM StagingData s
		INNER JOIN RDS.' + @ReportTableName + ' rt
			ON rt.ReportCode = ''' + @ReportCode + ''' 
			AND rt.ReportYear = ' + @SchoolYear + '
			AND rt.ReportLevel = ''' + aol.LevelCode + '''
			AND rt.CategorySetCode = ''' + cs.CategorySetCode + '''
			' + 
			CASE aol.LevelCode 
				WHEN 'LEA' THEN 'AND rt.OrganizationIdentifierSea = s.LeaIdentifierSea'
				WHEN 'SCH' THEN 'AND rt.OrganizationIdentifierSea = s.SchoolIdentifierSea'
				ELSE ''
			END
			+ ISNULL(STRING_AGG(' AND convert(varchar, s.' + d.DimensionFieldName + ') = rt.' + d.DimensionFieldName, CHAR(10) + '			'), '')
	FROM app.GenerateReports gr
	JOIN app.CategorySets cs
		on cs.GenerateReportId = gr.GenerateReportId
	LEFT JOIN app.CategorySet_Categories csc
		on csc.CategorySetId = cs.CategorySetId
	LEFT JOIN app.Categories c 
		on c.CategoryId = csc.CategoryId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
	JOIN app.TableTypes att
		ON cs.TableTypeId = att.TableTypeId
	LEFT JOIN app.Category_Dimensions cd
		ON c.CategoryId = cd.CategoryId
	LEFT JOIN app.Dimensions d
		ON cd.DimensionId = d.DimensionId
	WHERE cs.SubmissionYear = @SchoolYear
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
		EXEC sp_executesql @SQLStatement;
		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END

	CLOSE cursor_name;
	DEALLOCATE cursor_name;

	SET @SQLStatement =	'DROP TABLE ##' + @ReportCode + 'Staging'
	EXEC sp_executesql @SQLStatement