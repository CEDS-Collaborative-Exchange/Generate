-- Release-Specific table changes for the App schema
-- e.g. FactTables, Dimensions, DimensionTables
----------------------------------

set nocount on
begin try
 
	begin transaction

	-----VARIABLES DECLARATION------------------------------------------------------------------------------------------------
	declare @generateReportControlTypeId as int, @factTableId as int, @dimensionTableId as int, @CedsConnectionId as int
	declare @categoryId as int, @dimensionId as int, @edfactsSubmissionReportTypeId as int
	declare @seaId as int, @leaId as int, @schId as int

	declare @reportId as int, @datamigrationtypeId AS INT 
	-----VARIABLE DECLARATION END ---------------------------------------------------------------------------------------------
	select @seaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sea'
	select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'	
	select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'	
	select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'

	
	-- ------------------------- DimAssessmentStatuses dimension ------------------------------

	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimAssessmentStatuses'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'AssessmentProgressLevel' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('AssessmentProgressLevel',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AssessmentProgressLevel'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'PROGRESSLEVEL'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	-- ------------------------- DimEnrollment dimension ------------------------------

	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimEnrollment'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'AcademicOrVocationalOutcome' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('AcademicOrVocationalOutcome',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ACADVOCOUTCOME'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	-- ------------------------- DimNorDProgramStatuses dimension ------------------------------

	IF NOT exists(Select 1 FROM app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses')
	 BEGIN
		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimNorDProgramStatuses',1)
		
	 END
	
	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'NeglectedProgramType' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('NeglectedProgramType',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'NeglectedProgramType'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'NEGDELPROGTYPE'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'LongTermStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('LongTermStatus',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'LongTermStatus'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'NORDLONGTERM'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	-- populate app.DataMigrationTasks
	truncate table app.DataMigrationTasks
	--RDS Migration ---
	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation''',1,'Delete RDS data',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimStudents',2,'Load the base student population to DimStudents.',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimPersonnel',3,'Load the base personnel population into DimPersonnel',1)
    insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Seed_BridgeStudentRaces',4,'Load Student races',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationCounts ''datapopulation'', 0',5,'Load organization data into FactOrganizationCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationStatusCounts ''datapopulation'', 0',6,'Load organization rate data into FactOrganizationIndicatorStatusReports',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''datapopulation'', 0',7,'Load student count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''datapopulation'', 0',8,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''datapopulation'', 0',9,'Load student discipline data into FactStudentAssessment',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''datapopulation'', 0',10,'Load personnel data into FactPersonnelCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts'',''rds''',11,'Delete student count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''submission'', 0',12,'Load student count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts'',''rds''',13,'Delete student discipline count data from FactStudentDiscipline (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''submission'', 0',14,'Load student discipline data into FactStudentDiscipline',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments'',''rds''',15,'Delete student assessment data from FactStudentAssessment (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''submission'', 0',16,'Load student discipline data into FactStudentAssessment',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts'',''rds''',17,'Delete personnel data from FactPersonnelCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''submission'', 0',18,'Load personnel data into FactPersonnelCounts',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount'','''',''rds''',19,'Delete child count data from FactStudentCounts (submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''childcount'', 0',20,'Load child count data into FactStudentCounts',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit'','''',''rds''',21,'Delete students specedexit  count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_SpecialEdStudentCounts ''specedexit'', 0',22,'Load Students specedexit count data into FactStudentCounts',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte'','''',''rds''',23,'Delete CTE students count data from FactStudentCounts (submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''cte'', 0',24,'Load CTE Students count data into FactStudentCounts',1)
	
---Report Migration ------	
	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='report'
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''organizationcounts''',1,'Create Organization Reports and Load FactorganizationReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentcounts''',2,'Create Student Count Reports and Load FactStudentCountReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''disciplinecounts''',3,'Create Student Discipline Reports and Load FactStudentDisciplineReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentassessments''',4,'Create Student Assessment Reports and Load FactStudentAssessmentReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''personnelcounts''',5,'Create Personnel Reports and Load FactPersonnelCountReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''organizationstatuscounts''',6,'Create Organization Status Reports and Load FactOrganizationStatusCountReports table(datapopulation)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts'',''report''',7,'Delete Student Count Reports (unlocked) from FactStudentCountReports table(submission) ',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentcounts''',8,'Create Student Count Reports (unlocked) and Load FactStudentCountReports table(submission)',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts'',''report''',9,'Delete Student Discipline Reports (unlocked) from FactStudentDisciplineReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''disciplinecounts''',10,'Create Student Discipline Reports (unlocked) and Load FactStudentDisciplineReports table(submission)',1)		
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments'',''report''',11,'Delete Student Assessment Reports (unlocked) from FactStudentAssessmentReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentassessments''',12,'Create Student Assessment Reports (unlocked) and Load FactStudentAssessmentReports table(submission)',1)	
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts'',''report''',13,'Delete Personnel Count Reports (unlocked) from FactPersonnelCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''personnelcounts''',14,'Create Personnel Count Reports (unlocked) and Load FactPersonnelCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit'', '''',''report''',15,'Delete Students specedexit Reports (unlocked) from FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''specedexit'',0,''studentcounts''',16,'Create Students specedexit Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte'', '''',''report''',17,'Delete CTE Students Reports (unlocked) from FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''cte'',0,''studentcounts''',18,'Create CTE Students Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount'', '''',''report''',19,'',1)
	insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''childcount'',0,''studentcounts''',10,'',1)

	select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='ods'

	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,1,0,0,'ods.Migrate_DimStudents_adhoc',1,1,'ODS migration 1 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,2,0,0,'ods.Migrate_DimPersonnel_adhoc',2,1,'ODS migration 2 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,3,0,0,'ods.Migrate_StudentRace_adhoc',3,1,'ODS migration 3 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,4,0,0,'ods.Migrate_Organization_adhoc',4,1,'ODS migration 4 test stored procedure')


	-- [App].[FactTables]
	if not exists (select 1 from [App].[FactTables] where FactFieldName = 'OrganizationStatusCount')
		insert into [App].[FactTables] (
			 [FactFieldName]
			,[FactReportDtoIdName]
			,[FactReportDtoName]
			,[FactReportTableIdName]
			,[FactReportTableName]
			,[FactTableIdName]
			,[FactTableName]
		) values (
			'OrganizationStatusCount', 
			'FactOrganizationStatusCountReportDtoId',
			'FactOrganizationStatusCountReportDto',
			'FactOrganizationStatusCountReportId',
			'FactOrganizationStatusCountReports',
			'FactOrganizationStatusCountId',
			'FactOrganizationStatusCounts'
		)

	if not exists(select 1 from app.GenerateReportControlType where ControlTypeName = 'c199')
	begin
		INSERT INTO [App].[GenerateReportControlType]([ControlTypeName]) VALUES('c199')
	end
	
	select @GenerateReportControlTypeId = GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName = 'c199'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactOrganizationStatusCounts'
    Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'GRADRSTAT',  GenerateReportControlTypeId = @GenerateReportControlTypeId Where ReportCode = 'c199'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'ACHIVSTAT'  Where ReportCode = 'c200'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'OTHESTAT'  Where ReportCode = 'c201'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'QUALSTAT'  Where ReportCode = 'c202'


	------------------------------------------c127 Metadata-----------------------------------------------------------------------------------------------------------------------------

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'NeglectedProgramType'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'NEGDELPROGTYPE2'
	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'Age'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'AGEALL'
	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'NDPARTLEA' Where ReportCode = 'c127'

		------------------------------------------c119 Metadata-----------------------------------------------------------------------------------------------------------------------------

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'NeglectedProgramType'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'NEGDELPROGTYPE'
	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'NDPARTSEA' Where ReportCode = 'c119'




	------------------------------------------c180 & c181 Metadata-----------------------------------------------------------------------------------------------------------------------------

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ACADVOCOUTCOME' and edfactsCategoryId = 240
	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END

	select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'AcademicOrVocationalOutcome'
	select @categoryId = CategoryId from app.Categories Where CategoryCode = 'ACADVOCOUTCOME' and edfactsCategoryId = 579
	IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
	BEGIN
		INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
	END


	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'NDINPROGR' Where ReportCode = 'c180'
	Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'NDEXITEDP' Where ReportCode = 'c181'
	   
	-- c125 metadata
	select @CedsConnectionId = CedsConnectionId from [App].[CedsConnections]
	where CedsConnectionName like '%c125%'

	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentAssessments'
	Update app.GenerateReports set CedsConnectionId=@CedsConnectionId, FactTableId = @factTableId, ReportTypeAbbreviation = 'ACDOCMLEA'
	Where ReportCode = 'c125'

	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimNorDProgramStatuses'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentAssessments'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END

  	Update r 
	set FactTableId = (	select FactTableId from  app.FactTables ft where ft.FactFieldName = 'AssessmentCount'), ReportTypeAbbreviation = 'ACDOCMSEA'
	from app.GenerateReports r 
	where r.ReportCode = 'c113'

	
	-- ------------------------- DimPersonnelStatuses dimension ------------------------------

	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimPersonnelStatuses'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactPersonnelCounts'

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'UnexperiencedStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('UnexperiencedStatus',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'UnexperiencedStatus'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'INEXPSTATUS'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'OutOfFieldStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('OutOfFieldStatus',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'OutOfFieldStatus'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'OOFIELDSTATUS'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'EmergencyOrProvisionalCredentialStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('EmergencyOrProvisionalCredentialStatus',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'EmergencyOrProvisionalCredentialStatus'

		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'EMGCREDSTATUS'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

		select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactPersonnelCounts'
		 Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'TEACHER' Where ReportCode = 'c203'

		 ------------------------------------- c201 metadata

	select @factTableId = factTableId from [App].[FactTables] where [FactFieldName] = 'OrganizationStatusCount'
	-- c201 is using c199 report control
	SELECT @GenerateReportControlTypeId = [GenerateReportControlTypeId] FROM [App].[GenerateReportControlType] where [ControlTypeName] = 'c199'

	update app.GenerateReports
	set FactTableId = @factTableId, GenerateReportControlTypeId = @GenerateReportControlTypeId
	where reportcode = 'c201'

	update app.GenerateReports
	set FactTableId = @factTableId, GenerateReportControlTypeId = @GenerateReportControlTypeId
	where reportcode = 'c202'

	update app.GenerateReports
	set FactTableId = @factTableId, GenerateReportControlTypeId = @GenerateReportControlTypeId
	where reportcode = 'c200'

	select @DimensionTableId = dt.DimensionTableId
	from app.Dimensions d
	inner join app.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
	where d.DimensionFieldName = 'Disability'

	if not exists(select 1 from App.FactTable_DimensionTables where FactTableId = @FactTableId and DimensionTableId  = @DimensionTableId)
	begin
		INSERT INTO [App].[FactTable_DimensionTables] ([FactTableId] ,[DimensionTableId])
			select @FactTableId, @DimensionTableId
	end

	--EcoDisStatus
		select @DimensionTableId = dt.DimensionTableId
	from app.Dimensions d
	inner join app.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
	where d.DimensionFieldName = 'EcoDisStatus'

	if not exists(select 1 from App.FactTable_DimensionTables where FactTableId = @FactTableId and DimensionTableId  = @DimensionTableId)
	begin
		INSERT INTO [App].[FactTable_DimensionTables] ([FactTableId] ,[DimensionTableId])
			select @FactTableId, @DimensionTableId
	end

--LepStatus
		select @DimensionTableId = dt.DimensionTableId
	from app.Dimensions d
	inner join app.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
	where d.DimensionFieldName = 'LepStatus'

	if not exists(select 1 from App.FactTable_DimensionTables where FactTableId = @FactTableId and DimensionTableId  = @DimensionTableId)
	begin
		INSERT INTO [App].[FactTable_DimensionTables] ([FactTableId] ,[DimensionTableId])
			select @FactTableId, @DimensionTableId
	end
--Race
		select @DimensionTableId = dt.DimensionTableId
	from app.Dimensions d
	inner join app.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
	where d.DimensionFieldName = 'Race'

	if not exists(select 1 from App.FactTable_DimensionTables where FactTableId = @FactTableId and DimensionTableId  = @DimensionTableId)
	begin
		INSERT INTO [App].[FactTable_DimensionTables] ([FactTableId] ,[DimensionTableId])
			select @FactTableId, @DimensionTableId
	end

	delete
	  FROM [App].[Dimensions]
	  where [DimensionFieldName] = 'Year'


--------------------------------C035

	If not exists (select 1 from app.GenerateReportControlType where ControlTypeName='c035')
	begin
		insert into app.GenerateReportControlType (ControlTypeName) values('c035')
	end

	select @generateReportControlTypeId = GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName = 'c035'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactOrganizationCounts'
    Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'FEDPROOFF', GenerateReportControlTypeId=@generateReportControlTypeId  Where ReportCode = 'c035'

---------------------------------------------------------

	--c206
	select @FactTableId = FactTableId from app.FactTables where FactTableName = 'FactOrganizationCounts'
	update app.GenerateReports
	set FactTableId = @FactTableId,  ReportTypeAbbreviation = 'CSITSISCH'
	where reportcode = 'c206'



	SELECT @DimensionTableId = [DimensionTableId] FROM [App].[DimensionTables] where [DimensionTableName] = 'DimSchoolStatuses'

	if not exists (select 1 from [App].[Dimensions] where DimensionFieldName = 'ComprehensiveAndTargetedSupport')
	INSERT INTO [App].[Dimensions]
			   ([DimensionFieldName]
			   ,[DimensionTableId]
			   ,[IsCalculated]
			   ,[IsOrganizationLevelSpecific])
		SELECT 'ComprehensiveAndTargetedSupport', @DimensionTableId, 0, 0

	if not exists (select 1 from [App].[Dimensions] where DimensionFieldName = 'ComprehensiveSupport')
	INSERT INTO [App].[Dimensions]
			   ([DimensionFieldName]
			   ,[DimensionTableId]
			   ,[IsCalculated]
			   ,[IsOrganizationLevelSpecific])
		SELECT 'ComprehensiveSupport', @DimensionTableId, 0, 0


	if not exists (select 1 from [App].[Dimensions] where DimensionFieldName = 'TargetedSupport')
	INSERT INTO [App].[Dimensions]
			   ([DimensionFieldName]
			   ,[DimensionTableId]
			   ,[IsCalculated]
			   ,[IsOrganizationLevelSpecific])
		SELECT 'TargetedSupport', @DimensionTableId, 0, 0



	SELECT @dimensionId = [DimensionId] FROM [App].[Dimensions] where [DimensionFieldName] = 'ComprehensiveAndTargetedSupport'
	SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'ComprehensiveTargetedSupportSchTypeID'
	if not exists (select 1 from [App].[Category_Dimensions] where CategoryId = @CategoryId and DimensionId = @dimensionId)
		INSERT INTO [App].[Category_Dimensions] ([CategoryId] ,[DimensionId])
			SELECT @CategoryId, @dimensionId

	SELECT @dimensionId = [DimensionId] FROM [App].[Dimensions] where [DimensionFieldName] = 'ComprehensiveSupport'
	SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'ComprehensiveSupportIdentificationTypeID'
	if not exists (select 1 from [App].[Category_Dimensions] where CategoryId = @CategoryId and DimensionId = @dimensionId)
		INSERT INTO [App].[Category_Dimensions] ([CategoryId] ,[DimensionId])
			SELECT @CategoryId, @dimensionId

	SELECT @dimensionId = [DimensionId] FROM [App].[Dimensions] where [DimensionFieldName] = 'TargetedSupport'
	SELECT @CategoryId = CategoryId FROM App.Categories Where CategoryCode = 'TargetedSupportIdentificationTypeID'
	if not exists (select 1 from [App].[Category_Dimensions] where CategoryId = @CategoryId and DimensionId = @dimensionId)
		INSERT INTO [App].[Category_Dimensions] ([CategoryId] ,[DimensionId])
			SELECT @CategoryId, @dimensionId

	IF NOT EXISTS (select 1 from [App].[GenerateReportControlType] where [ControlTypeName] = 'c206')
	INSERT INTO [App].[GenerateReportControlType]
           ([ControlTypeName])
    VALUES
           ('c206')

	select @GenerateReportControlTypeId = GenerateReportControlTypeId from [App].[GenerateReportControlType] where [ControlTypeName] = 'c206'

	update r
	  set [GenerateReportControlTypeId] = @GenerateReportControlTypeId
	  FROM app.GenerateReports r
	  where reportcode ='c206'

	  delete from app.FileSubmissions where FileSubmissionDescription = 'SCHOOL SUPPORT AND IMPROVE' and SubmissionYear = '2018-19'

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
