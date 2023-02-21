-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction	

		set nocount on;

		declare @GenerateReportId as int
		declare @reportYear as varchar(50), @reportCode as varchar(50),  @latestSubmissionYear as varchar(10), @lastSubmissionYear as varchar(10)
		declare @level as int, @fileSubmissionId int, @LevelId as int



		DECLARE @fileSpecs TABLE
		(
			fileSpec nvarchar(10)
		)


		insert into @fileSpecs (fileSpec) values ('c029')
		insert into @fileSpecs (fileSpec) values ('c039')

		select @latestSubmissionYear = '2020-21'
		select @lastSubmissionYear = '2019-20'


		DECLARE report_cursor CURSOR FOR 
		select r.GenerateReportId, r.reportCode from @fileSpecs f
		inner join app.GenerateReports r on f.fileSpec = r.ReportCode
		order by fileSpec


		OPEN report_cursor
		FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			DECLARE level_cursor CURSOR FOR 
			select OrganizationLevelId from app.GenerateReport_OrganizationLevels
			where GenerateReportId = @GenerateReportId
	
			OPEN level_cursor
			FETCH NEXT FROM level_cursor INTO @level 

			WHILE @@FETCH_STATUS = 0
			BEGIN
	

				DECLARE submissionYear_cursor CURSOR FOR 
				select DISTINCT TOP 2  SubmissionYear from rds.DimDates where SubmissionYear is not null order by SubmissionYear desc

				OPEN submissionYear_cursor
				FETCH NEXT FROM submissionYear_cursor INTO @reportYear

				WHILE @@FETCH_STATUS = 0
				BEGIN
							IF Not exists (Select 1 from [App].[CategorySets] where CategorySetCode = 'CSA' and GenerateReportId = @GenerateReportId 
							and OrganizationLevelId = @level and SubmissionYear = @reportYear)
							BEGIN
								INSERT INTO [App].[CategorySets]([CategorySetCode],[CategorySetName],[EdFactsTableTypeGroupId],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
								VALUES('CSA','Category Set A',0,@GenerateReportId,@level,@reportYear)

							END	

				FETCH NEXT FROM submissionYear_cursor INTO @reportYear
				END

				CLOSE submissionYear_cursor
				DEALLOCATE submissionYear_cursor

			FETCH NEXT FROM level_cursor INTO @level
			END

			CLOSE level_cursor
			DEALLOCATE level_cursor

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

	

		FETCH NEXT FROM report_cursor INTO @GenerateReportId, @reportCode
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