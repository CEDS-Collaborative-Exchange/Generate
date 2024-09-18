-- Metadata changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction

		  declare @datamigrationtypeId as int
 
		  --RDS Migration ---
	select @datamigrationtypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'
	delete from app.DataMigrationTasks where DataMigrationTypeId = @datamigrationtypeId
	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimStudents',1,'Load the base student population to DimStudents.',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimPersonnel',2,'Load the base personnel population into DimPersonnel',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationCounts ''directory'', 0',3,'Load organization data into FactOrganizationCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationStatusCounts ''organizationstatus'', 0',4,'Load organization rate data into FactOrganizationIndicatorStatusReports',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''studentcounts''',5,'Delete student count data from FactStudentCounts (datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''datapopulation'', 0',6,'Load student count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation'', ''disciplinecounts''',7,'Delete student discipline count data from FactStudentDiscipline (datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''datapopulation'', 0',8,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts''',9,'Delete student count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''submission'', 0',10,'Load student count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts''',11,'Delete student discipline count data from FactStudentDiscipline (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''submission'', 0',12,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments''',13,'Delete student assessment data from FactStudentAssessment (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''submission'', 0',14,'Load student discipline data into FactStudentAssessment',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts''',15,'Delete personnel data from FactPersonnelCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''submission'', 0',16,'Load personnel data into FactPersonnelCounts',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount''',17,'Delete child count data from FactStudentCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''childcount'', 0',18,'Load child count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit''',19,'Delete students specedexit  count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_SpecialEdStudentCounts ''specedexit'', 0',20,'Load Students specedexit count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte''',21,'Delete CTE students count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''cte'', 0',22,'Load CTE Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''membership''',23,'Delete Membership students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''membership'', 0',24,'Load Membership Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''dropout''',25,'Delete dropout students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''dropout'', 0',26,'Load dropout Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''grad''',27,'Delete Graduaters or Completers students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''grad'', 0',28,'Load  Graduaters or Completers Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleIIIELOct''',29,'Delete Title III EL October students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleIIIELOct'', 0',30,'Load  Title III EL October Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleIIIELSY''',31,'Delete Title III EL SY students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleIIIELSY'', 0',32,'Load  Title III EL SY Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''titleI''',33,'Delete TitleI students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''titleI'', 0',34,'Load  TitleI Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''mep''',35,'Delete MEP students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''mep'', 0',36,'Load  MEP Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''immigrant''',37,'Delete Immigrant students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''immigrant'', 0',38,'Load  Immigrant Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''nord''',39,'Delete N or D students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''nord'', 0',40,'Load N or D Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''homeless''',41,'Delete Homeless students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''homeless'', 0',42,'Load Homeless Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''chronic''',43,'Delete Chronic Absenteeism students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''chronic'', 0',44,'Load Chronic Absenteeism Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''gradrate''',45,'Delete Grad Rate students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''gradrate'', 0',46,'Load Grad Rate Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''hsgradenroll''',47,'Delete HS Grad PS Enrollment students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''hsgradenroll'', 0',48,'Load HS Grad PS Enrollment Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''other''',49,'Delete Other students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''other'', 0',50,'Load Other Students count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''sppapr''',51,'Delete SPP/APR students count data from FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''sppapr'', 0',52,'Load SPP/APR Students count data into FactStudentCounts',1)




		  
		  -- Change TestData config values

		  delete from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData'

		  if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData' and GenerateConfigurationKey = 'Seed')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('TestData', 'Seed', '1000')
          end

		  if not exists (select 'c' from app.GenerateConfigurations where GenerateConfigurationCategory = 'TestData' and GenerateConfigurationKey = 'StudentCount')
          begin
            insert into app.GenerateConfigurations
            (GenerateConfigurationCategory, GenerateConfigurationKey, GenerateConfigurationValue)
            values
            ('TestData', 'StudentCount', '20000')
          end

			delete from app.CategoryOptions where CategorySetId in (select cs.CategorySetId from app.CategorySets cs
			inner join app.GenerateReports r on r.GenerateReportId = cs.GenerateReportId
			where SubmissionYear = '2018-19' and EdFactsTableTypeGroupId < 18036 and ReportCode = 'c006')

			delete from app.CategorySet_Categories where CategorySetId in (select cs.CategorySetId from app.CategorySets cs
			inner join app.GenerateReports r on r.GenerateReportId = cs.GenerateReportId
			where SubmissionYear = '2018-19' and EdFactsTableTypeGroupId < 18036 and ReportCode = 'c006')

			delete cs from app.CategorySets cs
			inner join app.GenerateReports r on r.GenerateReportId = cs.GenerateReportId
			where SubmissionYear = '2018-19' and EdFactsTableTypeGroupId < 18036 and ReportCode = 'c006'


			-- Enable .Net-based report migration

			update App.GenerateReports set UseLegacyReportMigration = 0 where ReportCode = 'c005'

			-- Disable for now (not fully working yet)
			update App.GenerateReports set UseLegacyReportMigration = 1 where ReportCode = 'c005'


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
