


declare @latestSubmissionYear as int, @lastSubmissionYear as int, @CategorySetCode as varchar(50), @GenerateReportId as int, @CategorySetId as int, @LevelId as int, @CategoryId as int

set @latestSubmissionYear = 2021
set @lastSubmissionYear = 2020

select @CategoryId = CategoryId from app.Categories where CategoryCode = 'MEPFUNDSSTATUS'

DECLARE report_cursor CURSOR FOR 
select r.GenerateReportId from app.GenerateReports r
inner join app.GenerateReportTypes rt on r.GenerateReportTypeId = rt.GenerateReportTypeId
where r.ReportCode = 'c165'

OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReportId

WHILE @@FETCH_STATUS = 0
BEGIN


	DECLARE cs_cursor CURSOR FOR 
	select CategorySetCode, cs.CategorySetId, cs.OrganizationLevelId
	from app.CategorySets cs
	where cs.SubmissionYear in (@latestSubmissionYear,@lastSubmissionYear)  and cs.GenerateReportId = @GenerateReportId

	OPEN cs_cursor
	FETCH NEXT FROM cs_cursor INTO @CategorySetCode, @CategorySetId, @LevelId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF NOT EXISTS(Select 1 from app.CategorySet_Categories where CategorySetId = @CategorySetId and CategoryId = @CategoryId)
		BEGIN
			INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId])
			Select @CategorySetId, @CategoryId
		END

		IF NOT EXISTS(Select 1 from app.CategoryOptions where CategorySetId = @CategorySetId and CategoryId = @CategoryId)
		BEGIN
			INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId])
			select distinct CategoryId, CategoryOptionCode, CategoryOptionName,CategoryOptionSequence, @CategorySetId, EdFactsCategoryCodeId 
			from app.CategoryOptions where CategoryId = @CategoryId
		END

		FETCH NEXT FROM cs_cursor INTO @CategorySetCode, @CategorySetId, @LevelId
	END

	CLOSE cs_cursor
	DEALLOCATE cs_cursor

	FETCH NEXT FROM report_cursor INTO @GenerateReportId
END

CLOSE report_cursor
DEALLOCATE report_cursor