CREATE PROCEDURE RDS.CreateDebugTables
	@ReportCode varchar(10), 
	@SubmissionYear VARCHAR(10), 
	@SelectColumns VARCHAR(MAX)
AS
	
	DECLARE @SQLStatement NVARCHAR(MAX);

	DECLARE cursor_name CURSOR FOR
    SELECT N'
        IF OBJECT_ID(N''[debug].[' + ReportCode + N'_' +
            LevelCode + N'_' +
            CategorySetCode + N'_' +
            SubmissionYear + N'_' +
            STRING_AGG(c.CategoryCode, '_') + N']' + ''', N''U'') IS NOT NULL
            DROP TABLE [debug].[' + ReportCode + N'_' +
            LevelCode + N'_' +
            CategorySetCode + N'_' +
            SubmissionYear + N'_' +
            STRING_AGG(c.CategoryCode, '_') + N']' + '

        SELECT ' + @SelectColumns + ',' + 
		STRING_AGG(c.CategoryCode, ',') + '
        INTO [debug].[' + ReportCode + N'_' +
            LevelCode + N'_' +
            CategorySetCode + N'_' +
            SubmissionYear + N'_' +
            STRING_AGG(c.CategoryCode, '_') + N']
        FROM #categorySet c
        ORDER BY ' + @SelectColumns + ';'
	FROM app.Categories c 
	join app.CategorySet_Categories csc
		on c.CategoryId = csc.CategoryId
	join app.CategorySets cs
		on csc.CategorySetId = cs.CategorySetId
	join app.GenerateReports gr
		on cs.GenerateReportId = gr.GenerateReportId
	JOIN app.OrganizationLevels aol
		ON cs.OrganizationLevelId = aol.OrganizationLevelId
	WHERE cs.SubmissionYear = @SubmissionYear
		AND gr.ReportCode = @ReportCode
	GROUP BY 
		  gr.ReportCode
		, aol.LevelCode
		, cs.CategorySetCode
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