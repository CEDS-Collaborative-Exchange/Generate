-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction	

	  
			declare @latestSubmissionYear as varchar(10), @lastSubmissionYear as varchar(10), @CategorySetCode as varchar(50), 
			@GenerateReportId as int, @CategorySetId as int, @LevelId as int, @fileSubmissionId int

			select @latestSubmissionYear = '2019-20'
			select @lastSubmissionYear = '2018-19'

			DECLARE report_cursor CURSOR FOR 
			select GenerateReportId from app.GenerateReports where ReportCode in ('c005', 'c006', 'c007', 'c009', 'c045', 'c070', 'c088', 'c099', 
																				'c112', 'c118', 'c143', 'c144')

			OPEN report_cursor
			FETCH NEXT FROM report_cursor INTO @GenerateReportId

			WHILE @@FETCH_STATUS = 0
			BEGIN

				if not exists(select 1 from app.CategorySets where GenerateReportId = @GenerateReportId and SubmissionYear = @latestSubmissionYear)
				BEGIN
					INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[ExcludeOnFilter],[GenerateReportId]
													,[IncludeOnFilter],[OrganizationLevelId],[SubmissionYear], TableTypeId, EdFactsTableTypeId)
					select [CategorySetCode],[CategorySetName],[CategorySetSequence],[EdFactsTableTypeGroupId],[ExcludeOnFilter],cs.GenerateReportId
													,[IncludeOnFilter],[OrganizationLevelId],@latestSubmissionYear, cs.TableTypeId, cs.EdFactsTableTypeId
					from app.CategorySets cs where cs.SubmissionYear = @lastSubmissionYear and cs.GenerateReportId = @GenerateReportId
				END

				if not exists(select 1 from app.FileSubmissions where GenerateReportId = @GenerateReportId and SubmissionYear = @latestSubmissionYear)
				BEGIN
					INSERT INTO app.FileSubmissions([FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
					select [FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],@latestSubmissionYear
					from app.FileSubmissions cs where cs.SubmissionYear = @lastSubmissionYear and cs.GenerateReportId = @GenerateReportId
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


				DECLARE fs_cursor CURSOR FOR 
				select fs.FileSubmissionId, fs.OrganizationLevelId
				from app.FileSubmissions fs
				where fs.SubmissionYear = @latestSubmissionYear and fs.GenerateReportId = @GenerateReportId

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
						where SubmissionYear = @lastSubmissionYear and fs.GenerateReportId = @GenerateReportId 
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


	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off