-- Release-Specific table changes for the App schema
-- e.g. FactTables, Dimensions, DimensionTables
----------------------------------

set nocount on
begin try
 
	begin transaction

	-----VARIABLES DECLARATION------------------------------------------------------------------------------------------------
	declare @generateReportControlTypeId as int, @factTableId as int, @dimensionTableId as int
	declare @categoryId as int, @dimensionId as int, @edfactsSubmissionReportTypeId as int
	declare @leaId as int, @CategorySetId as int, @GenerateReportId as int, @schId as int

	declare @reportId as int, @datamigrationtypeId AS INT 
	-----VARIABLE DECLARATION END ---------------------------------------------------------------------------------------------
	select @leaId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'lea'	
	select @schId = OrganizationLevelId from app.OrganizationLevels where LevelCode = 'sch'	
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentDisciplines'
     Update app.GenerateReports set FactTableId = @factTableId Where ReportCode = 'c086'

	 Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimGradeLevels'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END

	 IF NOT exists(Select 1 FROM app.DimensionTables where DimensionTableName = 'DimFirearms')
	 BEGIN
		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimFirearms',1)
		
	 END
	
	Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimFirearms'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'Firearms' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('Firearms',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'Firearms'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'WEAPONTYPE'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END

	 IF NOT exists(Select 1 FROM app.DimensionTables where DimensionTableName = 'DimFirearmsDiscipline')
	 BEGIN
		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimFirearmsDiscipline',1)
	 END

	
	Select @dimensionTableId = DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimFirearmsDiscipline'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'FirearmsDiscipline' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
		VALUES('FirearmsDiscipline',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'FirearmsDiscipline'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'FAINCNOTIDEA'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'IDEAFirearmsDiscipline' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
		VALUES('IDEAFirearmsDiscipline',@dimensionTableId,0,0)

		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'IDEAFirearmsDiscipline'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'FAINCIDEA'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END


	If NOT exists (select 1 from app.DataMigrationTypes where DataMigrationTypeCode='report' ) 
	BEGIN
	insert into app.DataMigrationTypes (DataMigrationTypeCode, DataMigrationTypeName) values('report','Report Warehouse')
	set @datamigrationtypeId=SCOPE_IDENTITY()
	insert into app.DataMigrations(DataMigrationStatusId, DataMigrationTypeId) values(1,@datamigrationtypeId)
	END

	If NOT exists (select distinct 1 from app.DataMigrationTasks where DataMigrationTypeId=(Select distinct DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='report' )) 
	BEGIN
		truncate table app.DataMigrationTasks
		--RDS Migration ---
		select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='rds'
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''datapopulation''',1,'Delete RDS data',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimStudents',2,'Load the base student population to DimStudents.',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_DimPersonnel',3,'Load the base personnel population into DimPersonnel',1)
        insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Seed_BridgeStudentRaces',4,'Load Student races',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_OrganizationCounts ''datapopulation'', 0',5,'Load organization data into FactOrganizationCounts',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''datapopulation'', 0',6,'Load student count data into FactStudentCounts',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''datapopulation'', 0',7,'Load student discipline data into FactStudentDiscipline',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''datapopulation'', 0',8,'Load student discipline data into FactStudentAssessment',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''datapopulation'', 0',9,'Load personnel data into FactPersonnelCounts',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts'',''rds''',10,'Delete student count data from FactStudentCounts (submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''submission'', 0',11,'Load student count data into FactStudentCounts',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts'',''rds''',12,'Delete student discipline count data from FactStudentDiscipline (submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentDisciplines ''submission'', 0',13,'Load student discipline data into FactStudentDiscipline',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments'',''rds''',14,'Delete student assessment data from FactStudentAssessment (submission)',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentAssessments ''submission'', 0',15,'Load student discipline data into FactStudentAssessment',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts'',''rds''',16,'Delete personnel data from FactPersonnelCounts (submission)',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_PersonnelCounts ''submission'', 0',17,'Load personnel data into FactPersonnelCounts',1)		
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount'','''',''rds''',18,'Delete child count data from FactStudentCounts (submission)',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''childcount'', 0',19,'Load child count data into FactStudentCounts',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit'','''',''rds''',20,'Delete students specedexit  count data from FactStudentCounts (submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''specedexit'', 0',21,'Load Students specedexit count data into FactStudentCounts',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description,  IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte'','''',''rds''',22,'Delete CTE students count data from FactStudentCounts (submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Migrate_StudentCounts ''cte'', 0',23,'Load CTE Students count data into FactStudentCounts',1)
	
	---Report Migration ------	
		select @datamigrationtypeId=DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='report'
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''organizationcounts''',1,'Create Organization Reports and Load FactorganizationReports table(datapopulation)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentcounts''',2,'Create Student Count Reports and Load FactStudentCountReports table(datapopulation)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''disciplinecounts''',3,'Create Student Discipline Reports and Load FactStudentDisciplineReports table(datapopulation)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''studentassessments''',4,'Create Student Assessment Reports and Load FactStudentAssessmentReports table(datapopulation)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''datapopulation'',0,''personnelcounts''',5,'Create Personnel Reports and Load FactPersonnelCountReports table(datapopulation)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentcounts'',''report''',6,'Delete Student Count Reports (unlocked) from FactStudentCountReports table(submission) ',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentcounts''',7,'Create Student Count Reports (unlocked) and Load FactStudentCountReports table(submission)',1)		
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''disciplinecounts'',''report''',8,'Delete Student Discipline Reports (unlocked) from FactStudentDisciplineReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''disciplinecounts''',9,'Create Student Discipline Reports (unlocked) and Load FactStudentDisciplineReports table(submission)',1)		
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''studentassessments'',''report''',10,'Delete Student Assessment Reports (unlocked) from FactStudentAssessmentReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''studentassessments''',11,'Create Student Assessment Reports (unlocked) and Load FactStudentAssessmentReports table(submission)',1)	
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''submission'', ''personnelcounts'',''report''',12,'Delete Personnel Count Reports (unlocked) from FactPersonnelCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''submission'',0,''personnelcounts''',13,'Create Personnel Count Reports (unlocked) and Load FactPersonnelCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''specedexit'', '''',''report''',14,'Delete Students specedexit Reports (unlocked) from FactStudentCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''specedexit'',0,''studentcounts''',15,'Create Students specedexit Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''cte'', '''',''report''',16,'Delete CTE Students Reports (unlocked) from FactStudentCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''cte'',0,''studentcounts''',17,'Create CTE Students Reports (unlocked) and Load FactStudentCountReports table(submission)',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.Empty_RDS ''childcount'', '''',''report''',18,'',1)
		insert into app.DataMigrationTasks(DataMigrationTypeId, IsActive, RunAfterGenerateMigration,RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, Description, IsSelected) values(@datamigrationtypeId,1,0,0,'rds.create_reports ''childcount'',0,''studentcounts''',19,'',1)
	END
-----------------------C160 METADATA BEGIN------------------------------------------------------------------------------------------------------------

	IF NOT EXISTS(select 1 from app.DimensionTables where DimensionTableName = 'DimEnrollment')
	BEGIN

		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])  VALUES('DimEnrollment',1)

		select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
		Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimEnrollment'
			
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
		VALUES('PostSecondaryEnrollmentStatus',@dimensionTableId, 0, 0)
	END
	
	Select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimEnrollment'

	IF NOT EXISTS (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'PostSecondaryEnrollmentStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) VALUES('PostSecondaryEnrollmentStatus',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'PostSecondaryEnrollmentStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'PSECENRACTION'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END
	ELSE
	BEGIN
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'PostSecondaryEnrollmentStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'PSECENRACTION'

		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END	

	IF NOT EXISTS (select 1 from app.GenerateReports where GenerateReportControlTypeId = (select distinct GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c160' ))
	begin
		select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'
		Update app.GenerateReports set FactTableId = @factTableId, ReportTypeAbbreviation = 'SFSFHSGRD' Where ReportCode = 'c160'
	end
	----------------------C160 METADATA END--------------------------------------------------------------------------------------------------------------

	----------------------C131 METADATA BEGIN------------------------------------------------------------------------------------------------------------
	select @edfactsSubmissionReportTypeId = GenerateReportTypeId from app.GenerateReportTypes where ReportTypeCode = 'edfactsreport'
	select @GenerateReportId = GenerateReportId FROM App.GenerateReports Where ReportCode = 'c131'
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c131') and OrganizationLevelId = 2 )
	BEGIN
	INSERT into App.GenerateReport_OrganizationLevels
	(GenerateReportId,OrganizationLevelId) 
	( SELECT generatereportid, 2 from app.GenerateReports where ReportCode ='c131' )
	END

	IF NOT EXISTS (select 1 from app.GenerateReportControlType where ControlTypeName = 'c131')
	begin
		insert into app.GenerateReportControlType (ControlTypeName) values ('c131')

	end 
	
	IF NOT EXISTS (select 1 from app.GenerateReports where GenerateReportControlTypeId = (select distinct GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c131' ))
	begin
		select @factTableId=FactTableId from app.FactTables where FactFieldName='OrganizationCount' 
		select @generateReportControlTypeId=GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c131'
		update app.GenerateReports set GenerateReportControlTypeId=@generateReportControlTypeId, FactTableId=@factTableId where ReportCode='c131'
	END

	--If NOT EXISTS (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c131' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
	--																			and OrganizationLevelId = @leaId and CategorySetCode = 'CSA' 
	--																			 and SubmissionYear = '2017-18' ) 
	--BEGIN
	--		INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	--		VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c131' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
	--				,@leaId, 17338, '2017-18', 'CSA', 'Category Set A' )

 
	--		SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)


	--END

	If NOT EXISTS (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c131' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @leaId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2016-17' ) 
	BEGIN
			INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
			VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c131' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
					,@leaId, 17338, '2016-17', 'CSA', 'Category Set A' )

 
			SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END
	-------------------------------C131 METADATA END--------------------------------------------------------------------------------------------------------------
	-------------------------------c163 metadata-------------------------------------------------------------------------------------------------------------------
	
	---------------------------------------FS 163 ---------------------------------------------------------------------------

	IF NOT EXISTS(Select 1 from app.GenerateReportControlType where ControlTypeName = 'c163')
	BEGIN
		INSERT INTO [App].[GenerateReportControlType]([ControlTypeName]) values('c163')
	END

	select @generateReportControlTypeId=GenerateReportControlTypeId from app.GenerateReportControlType where ControlTypeName='c163'
	select @factTableId=FactTableId from app.FactTables where FactTableName='FactOrganizationCounts' 
	update app.GenerateReports set GenerateReportControlTypeId=@generateReportControlTypeId, FactTableId=@factTableId,  ReportTypeAbbreviation = 'DISCDATA',
								ShowCategorySetControl = 0 
	where ReportCode='c163'


	If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @schId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
	BEGIN
	 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
			,@schId, 0, '2017-18', 'CSA', 'Category Set A' )
 
	SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c163') and OrganizationLevelId = 3 )
	BEGIN
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId) 
		( SELECT GenerateReportId, 3 from app.GenerateReports where ReportCode ='c163' )
	END

	
	If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = 2 and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2017-18' ) 
	BEGIN
	 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
			,2, 0, '2017-18', 'CSA', 'Category Set A' )
 
	SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c163') and OrganizationLevelId = 2 )
	BEGIN
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId) 
		( SELECT GenerateReportId, 2 from app.GenerateReports where ReportCode ='c163' )
	END	

	
	If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = @schId and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2018-19' ) 
	BEGIN
	 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
			,@schId, 0, '2018-19', 'CSA', 'Category Set A' )
 
	SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c163') and OrganizationLevelId = 3 )
	BEGIN
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId) 
		( SELECT GenerateReportId, 3 from app.GenerateReports where ReportCode ='c163' )
	END

	
	If NOT exists (SELECT 1 from app.Categorysets where GenerateReportId = (select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId )
																				and OrganizationLevelId = 2 and CategorySetCode = 'CSA' 
																				 and SubmissionYear = '2018-19' ) 
	BEGIN
	 INSERT INTO app.CategorySets 	(GenerateReportId, OrganizationLevelId, EdFactsTableTypeGroupId, SubmissionYear, CategorySetCode, CategorySetName)
	 VALUES 	((select GenerateReportId from app.GenerateReports where ReportCode = 'c163' and GenerateReportTypeId = @edfactsSubmissionReportTypeId)
			,2, 0, '2018-19', 'CSA', 'Category Set A' )
 
	SET @CategorySetId = CAST(SCOPE_IDENTITY() AS INT)
	END
	IF NOT EXISTS (select 1 from app.GenerateReport_OrganizationLevels where [GenerateReportId] = (select GenerateReportId from app.GenerateReports where ReportCode ='c163') and OrganizationLevelId = 2 )
	BEGIN
		INSERT into App.GenerateReport_OrganizationLevels
		(GenerateReportId,OrganizationLevelId) 
		( SELECT GenerateReportId, 2 from app.GenerateReports where ReportCode ='c163' )
	END	

	 IF NOT exists(Select 1 FROM app.DimensionTables where DimensionTableName = 'DimOrganizationStatuses')
	 BEGIN
		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimOrganizationStatuses',1)
	 END

	
	Select @dimensionTableId = DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimOrganizationStatuses'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'GunFreeStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
		VALUES('GunFreeStatus',@dimensionTableId,0,0)

	END

	update App.FileColumns set DimensionId = (select DimensionId from app.Dimensions where DimensionFieldName = 'GunFreeStatus') 
	where ColumnName = 'GFSAReportStatus'

  
	      -----File Spec FS150 ------------------

    Update app.GenerateReports 
    set CedsConnectionId = (select CedsConnectionId from app.CedsConnections where CedsUseCaseId = 3140),
        FactTableId = 1,
        GenerateReportControlTypeId = 2
    where ReportCode = 'c150'

	-----File Spec FS151 ------------------
    Update app.GenerateReports 
    set CedsConnectionId = (select CedsConnectionId from app.CedsConnections where CedsUseCaseId = 3146),
        FactTableId = 1,
        GenerateReportControlTypeId = 2
    where ReportCode = 'c151'

	IF exists (Select 1 from app.[GenerateReports] where [ReportCode] = 'c036' and IsActive=1)
	BEGIN
		update app.GenerateReports set IsActive=0 where ReportCode='c036'

	END 
	
	
	IF exists (Select 1 from app.[GenerateReports] where [ReportCode] = 'c065' and IsActive=1)
	BEGIN
		update app.GenerateReports set IsActive=0 where ReportCode='c065'

	END 



	-- ------------------------- Cohort Status dimension ------------------------------

	IF NOT exists(Select 1 FROM app.DimensionTables where DimensionTableName = 'DimCohortStatuses')
	 BEGIN
		INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension]) VALUES('DimCohortStatuses',1)
		
	 END
	
	select @dimensionTableId= DimensionTableId FROM app.DimensionTables where DimensionTableName = 'DimCohortStatuses'
	select @factTableId = FactTableId from app.FactTables Where FactTableName = 'FactStudentCounts'

	IF NOT EXISTS(select 1 from app.FactTable_DimensionTables where FactTableId = @factTableId and DimensionTableId = @dimensionTableId)
	BEGIN
		INSERT INTO [App].[FactTable_DimensionTables]([FactTableId],[DimensionTableId]) VALUES(@factTableId, @dimensionTableId)
	END


	IF not exists (Select 1 from app.[Dimensions] where [DimensionFieldName] = 'CohortStatus' and [DimensionTableId] = @dimensionTableId)
	BEGIN

		INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific]) 
			VALUES('CohortStatus',@dimensionTableId,0,0)
		select @dimensionId = dimensionId from app.Dimensions where DimensionFieldName = 'CohortStatus'
		select @categoryId = CategoryId from app.Categories Where CategoryCode = 'COHSTATUS'
		IF NOT EXISTS(SELECT 1 FROM app.Category_Dimensions where DimensionId = @dimensionId and CategoryId = @categoryId)
		BEGIN
			INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId]) VALUES(@categoryId,@dimensionId)
		END
	END


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
