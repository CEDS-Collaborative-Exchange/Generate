set nocount on

IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name = N'debug' )
EXEC('CREATE SCHEMA [debug] AUTHORIZATION [dbo]');

begin try
	begin transaction

		declare @dimensionId as int, @reportId as int

		select @reportId = GenerateReportId from app.GenerateReports where reportcode = 'c037'
		
		Update co set co.CategoryOptionName = 'Home'
		from app.CategorySets cs
		inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
		inner join app.Categories c on c.CategoryId = csc.CategoryId
		inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r on r.GenerateReportId = cs.GenerateReportId
		where r.ReportCode = 'c089' and CategoryCode = 'EDENVIDEAEC' and co.CategoryOptionCode = 'H'

		Update app.Dimensions set DimensionFieldName = 'HomelessPrimaryNightTimeResidence' where DimensionFieldName = 'HOMELESSNIGHTTIMERESIDENCE'

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'HomelessnessStatus'

		Update fc set DimensionId =  @dimensionId
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		where GenerateReportId = @reportId and fc.ColumnName = 'HomelessStatusID'

		select @dimensionId = DimensionId from app.Dimensions where DimensionFieldName = 'IdeaIndicator'

		Update fc set DimensionId =  @dimensionId
		from app.FileSubmissions fs
		inner join app.FileSubmission_FileColumns fsfc on fs.FileSubmissionId = fsfc.FileSubmissionId
		inner join app.FileColumns fc on fsfc.FileColumnId = fc.FileColumnId
		where GenerateReportId = @reportId and fc.ColumnName = 'DisabilityStatusID'

		IF NOT EXISTS(SELECT 1 from app.DataMigrationTasks where StoredProcedureName like '%Wrapper_Migrate_TitleI_to_IDS%')
		INSERT [App].[DataMigrationTasks] ( [DataMigrationTypeId], [IsActive], [RunAfterGenerateMigration], [RunBeforeGenerateMigration], [StoredProcedureName], [TaskSequence], [IsSelected], 
		[Description], [TaskName]) VALUES (1, 1, 0, 0, N'Staging.Wrapper_Migrate_TitleI_to_IDS @SchoolYear', 7, 1, N'Complete IDS Migration - TitleI', NULL)
			
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