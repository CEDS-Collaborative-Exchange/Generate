CREATE PROCEDURE [App].[Rollover_Previous_Year_Metadata]
@reportCode as varchar(50) = null,
@fromSY as varchar(10),
@toSY as varchar(10)
AS
BEGIN

	declare @CategorySetCode as varchar(50), @GenerateReportId as int, @CategorySetId as int, @LevelId as int, @fileSubmissionId int, @TableTypeId int

	declare @reportTable as table (
		GenerateReportId int
	)

	IF NOT EXISTS(select 1 from rds.DimSchoolYears where SchoolYear = @fromSY)
	BEGIN
		print 'Previous Year not found'
		return
	END

	IF NOT EXISTS(select 1 from rds.DimSchoolYears where SchoolYear = @toSY)
	BEGIN
		print 'Current Year not found'
		return
	END

	IF @reportCode = null
	BEGIN

		INSERT INTO @reportTable(GenerateReportId)
		select GenerateReportId from app.GenerateReports where IsActive = 1
	END
	ELSE
		INSERT INTO @reportTable(GenerateReportId)
		select GenerateReportId from app.GenerateReports where ReportCode = @reportCode
	END

	IF EXISTS(select 1 from @reportTable)
	BEGIN

		DECLARE report_cursor CURSOR FOR 
		select GenerateReportId from @reportTable

		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @GenerateReportId

		WHILE @@FETCH_STATUS = 0
		BEGIN

			if not exists(select 1 from app.CategorySets where GenerateReportId = @GenerateReportId and SubmissionYear = @toSY)
			BEGIN
				INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],
				[ExcludeOnFilter],[GenerateReportId],[IncludeOnFilter],[OrganizationLevelId],[SubmissionYear], TableTypeId, EdFactsTableTypeId)
				select [CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[ExcludeOnFilter],cs.GenerateReportId
				,[IncludeOnFilter],[OrganizationLevelId],@toSY, cs.TableTypeId, cs.EdFactsTableTypeId
				from app.CategorySets cs where cs.SubmissionYear = @fromSY and cs.GenerateReportId = @GenerateReportId
			END

			if not exists(select 1 from app.FileSubmissions where GenerateReportId = @GenerateReportId and SubmissionYear = @toSY)
			BEGIN
				INSERT INTO app.FileSubmissions([FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
				select [FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],@toSY
				from app.FileSubmissions cs where cs.SubmissionYear = @fromSY and cs.GenerateReportId = @GenerateReportId
			END

			DECLARE cs_cursor CURSOR FOR 
			select TableTypeId, CategorySetCode, cs.CategorySetId, cs.OrganizationLevelId
			from app.CategorySets cs
			where cs.SubmissionYear = @toSY and cs.GenerateReportId = @GenerateReportId

			OPEN cs_cursor
			FETCH NEXT FROM cs_cursor INTO @TableTypeId,@CategorySetCode, @CategorySetId, @LevelId

			WHILE @@FETCH_STATUS = 0
			BEGIN

				IF NOT EXISTS(Select 1 from app.CategorySet_Categories where CategorySetId = @CategorySetId)
				BEGIN
					INSERT INTO [App].[CategorySet_Categories]([CategorySetId],[CategoryId],[GenerateReportDisplayTypeID])
					Select @CategorySetId, csc.CategoryId, csc.GenerateReportDisplayTypeID 
					from app.CategorySets cs 
					inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
					where SubmissionYear = @fromSY and cs.GenerateReportId = @GenerateReportId 
					and cs.CategorySetCode = @CategorySetCode and OrganizationLevelId =  @LevelId
					and isnull(cs.TableTypeId, -1) = ISNULL(@TableTypeId, -1)
				END

				IF NOT EXISTS(Select 1 from app.CategoryOptions where CategorySetId = @CategorySetId)
				BEGIN
					INSERT INTO [App].[CategoryOptions]([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],
					[CategorySetId],[EdFactsCategoryCodeId])
					Select c.CategoryId, co.CategoryOptionCode, co.CategoryOptionName, co.CategoryOptionSequence, @CategorySetId,
						co.EdFactsCategoryCodeId
					from app.CategorySets cs 
					inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
					inner join app.Categories c on csc.CategoryId = c.CategoryId
					inner join app.CategoryOptions co on cs.CategorySetId = co.CategorySetId and co.CategoryId = c.CategoryId
					where SubmissionYear = @fromSY and cs.GenerateReportId = @GenerateReportId 
					and cs.CategorySetCode = @CategorySetCode and OrganizationLevelId =  @LevelId
					and isnull(cs.TableTypeId, -1) = ISNULL(@TableTypeId, -1)
				END

				FETCH NEXT FROM cs_cursor INTO @TableTypeId,@CategorySetCode, @CategorySetId, @LevelId
			END

			CLOSE cs_cursor
			DEALLOCATE cs_cursor


			DECLARE fs_cursor CURSOR FOR 
			select fs.FileSubmissionId, fs.OrganizationLevelId
			from app.FileSubmissions fs
			where fs.SubmissionYear = @toSY and fs.GenerateReportId = @GenerateReportId

			OPEN fs_cursor
			FETCH NEXT FROM fs_cursor INTO @fileSubmissionId, @LevelId

			WHILE @@FETCH_STATUS = 0
			BEGIN

				IF NOT EXISTS(Select 1 from app.FileSubmission_FileColumns where FileSubmissionId = @fileSubmissionId)
				BEGIN
					INSERT INTO [App].[FileSubmission_FileColumns]([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],
								[SequenceNumber],[StartPosition])
					Select @fileSubmissionId, fsfc.FileColumnId, fsfc.EndPosition, fsfc.IsOptional, fsfc.SequenceNumber, 
								fsfc.StartPosition
					from app.FileSubmissions fs 
					inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
					where SubmissionYear = @fromSY and fs.GenerateReportId = @GenerateReportId 
							and OrganizationLevelId =  @LevelId
				END
				
				FETCH NEXT FROM fs_cursor INTO @fileSubmissionId, @LevelId
			END

			CLOSE fs_cursor
			DEALLOCATE fs_cursor

			FETCH NEXT FROM report_cursor INTO @GenerateReportId
		END

		CLOSE report_cursor
		DEALLOCATE report_cursor

END


