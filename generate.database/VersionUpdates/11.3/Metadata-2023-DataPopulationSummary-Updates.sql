
-------------------------------- Script to rollover datapopulation and state reports from last year-----------------------------------------------------


declare @latestSubmissionYear as varchar(10), @lastSubmissionYear as varchar(10), @CategorySetCode as varchar(50), @GenerateReportId as int, @CategorySetId as int, @LevelId as int

select @latestSubmissionYear = 2023
select @lastSubmissionYear = 2022

DECLARE report_cursor CURSOR FOR 
select r.GenerateReportId from app.GenerateReports r
inner join app.GenerateReportTypes rt on r.GenerateReportTypeId = rt.GenerateReportTypeId
where rt.ReportTypeCode in ('datapopulation', 'statereport')

OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @GenerateReportId

WHILE @@FETCH_STATUS = 0
BEGIN

	if not exists(select 1 from app.CategorySets where GenerateReportId = @GenerateReportId and SubmissionYear = @latestSubmissionYear)
	BEGIN
		INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[ExcludeOnFilter],[GenerateReportId]
										,[IncludeOnFilter],[OrganizationLevelId],[SubmissionYear])
		select [CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[ExcludeOnFilter],cs.GenerateReportId
										,[IncludeOnFilter],[OrganizationLevelId],@latestSubmissionYear
		from app.CategorySets cs where cs.SubmissionYear = @lastSubmissionYear and cs.GenerateReportId = @GenerateReportId
	END

	DECLARE cs_cursor CURSOR FOR 
	select CategorySetCode, cs.CategorySetId, cs.OrganizationLevelId
	from app.CategorySets cs
	where cs.SubmissionYear = @latestSubmissionYear and cs.GenerateReportId = @GenerateReportId

	OPEN cs_cursor
	FETCH NEXT FROM cs_cursor INTO @CategorySetCode, @CategorySetId, @LevelId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF NOT EXISTS(Select 1 from app.CategorySet_Categories where CategorySetId = @CategorySetId)
		BEGIN
			INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId],[GenerateReportDisplayTypeID])
			Select @CategorySetId, csc.CategoryId, csc.GenerateReportDisplayTypeID 
			from app.CategorySets cs 
			inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
			where SubmissionYear = @lastSubmissionYear and cs.GenerateReportId = @GenerateReportId 
			and cs.CategorySetCode = @CategorySetCode and OrganizationLevelId =  @LevelId
		END

		IF NOT EXISTS(Select 1 from app.CategoryOptions where CategorySetId = @CategorySetId)
		BEGIN
			INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId])
			Select c.CategoryId, co.CategoryOptionCode, co.CategoryOptionName, co.CategoryOptionSequence, @CategorySetId, co.EdFactsCategoryCodeId
			from app.CategorySets cs 
			inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
			inner join app.Categories c on csc.CategoryId = c.CategoryId
			inner join app.CategoryOptions co on cs.CategorySetId = co.CategorySetId and co.CategoryId = c.CategoryId
			where SubmissionYear = @lastSubmissionYear and cs.GenerateReportId = @GenerateReportId 
			and cs.CategorySetCode = @CategorySetCode and OrganizationLevelId =  @LevelId
		END

		FETCH NEXT FROM cs_cursor INTO @CategorySetCode, @CategorySetId, @LevelId
	END

	CLOSE cs_cursor
	DEALLOCATE cs_cursor

	FETCH NEXT FROM report_cursor INTO @GenerateReportId
END

CLOSE report_cursor
DEALLOCATE report_cursor