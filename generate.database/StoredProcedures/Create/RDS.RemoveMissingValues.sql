CREATE PROCEDURE RDS.RemoveMissingValues
	@ReportCode varchar(10), 
	@SubmissionYear VARCHAR(10), 
	@SelectColumns VARCHAR(MAX)
AS
	
	DECLARE @SQLStatement NVARCHAR(MAX);

	DECLARE cursor_name CURSOR FOR
    SELECT N'
	if exists (select 1 from #categorySet
		where ' + c.CategoryCode + ' <> ''MISSING'' and StudentCount > 0)
	begin
		delete from #categorySet where ' + c.CategoryCode + ' = ''MISSING''
	end
	else
	begin
		delete from #categorySet where ' + c.CategoryCode + ' <> ''MISSING''					
	end'
	FROM app.Categories c 
	join app.CategorySet_Categories csc
		on c.CategoryId = csc.CategoryId
	join app.CategorySets cs
		on csc.CategorySetId = cs.CategorySetId
	join app.GenerateReports gr
		on cs.GenerateReportId = gr.GenerateReportId
	WHERE cs.SubmissionYear = @SubmissionYear
		AND gr.ReportCode = @ReportCode
		AND c.CategoryCode <> 'NOCATS'
	GROUP BY 
		  gr.ReportCode
		, cs.SubmissionYear
		, c.CategoryCode
	OPEN cursor_name;

	FETCH NEXT FROM cursor_name INTO @SQLStatement;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC sp_executesql @SQLStatement;
		FETCH NEXT FROM cursor_name INTO @SQLStatement;
	END

	CLOSE cursor_name;
	DEALLOCATE cursor_name;