-- Staging Data Migration Tasks
----------------------------------
set nocount on
begin try
	begin transaction

	-- Remove any existing ODS migration tasks
	
	delete from App.DataMigrationTasks where DataMigrationTypeId = 1 and (StoredProcedureName like '%_adhoc @SchoolYear' or StoredProcedureName like '%_EncapsulatedCode @SchoolYear')

	-- Add staging tasks

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_PRELIMINARY_STEP01_CompletelyClearDataFromODS', 1, 1, 'Staging Migration - Preliminary Step 01 - Completely Clear Data From ODS', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP01_Organization_EncapsulatedCode', 2, 1, 'Staging Migration - Implementation Step 01 - Organization', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP02_CharterSchoolManagementOrganization_EncapsulatedCode', 3, 1, 'Staging Migration - Implementation Step 02 - Charter School Management Organization', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP03_Person_EncapsulatedCode', 4, 1, 'Staging Migration - Implementation Step 03 - Person', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP04_PersonRace_EncapsulatedCode', 5, 1, 'Staging Migration - Implementation Step 04 - Person Race', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP05_PersonStatus_EncapsulatedCode', 6, 1, 'Staging Migration - Implementation Step 05 - Person Status', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP06_Enrollment_EncapsulatedCode', 7, 1, 'Staging Migration - Implementation Step 06 - Enrollment', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP07_ProgramParticipationSpecialEducation_EncapsulatedCode', 8, 1, 'Staging Migration - Implementation Step 07 - Program Participation - Special Education', null)

	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP08_Migrant_EncapsulatedCode', 9, 1, 'Staging Migration - Implementation Step 08 - Migrant', null)
  
	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP09_ProgramParticipationTitleI_EncapsulatedCode', 10, 1, 'Staging Migration - Implementation Step 09 - Program Participation - Title I', null)
  
	insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP10_ProgramParticipationCTE_EncapsulatedCode', 11, 1, 'Staging Migration - Implementation Step 10 - Program Participation - CTE', null)
   
    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP11_ProgramParticipationNorD_EncapsulatedCode', 12, 1, 'Staging Migration - Implementation Step 11 - Program Participation - N or D', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP12_ProgramParticipationTitleIII_EncapsulatedCode', 13, 1, 'Staging Migration - Implementation Step 12 - Program Participation - Title III', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP13_Discipline_EncapsulatedCode', 14, 1, 'Staging Migration - Implementation Step 13 - Disicipline', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP14_StudentCourse_EncapsulatedCode', 15, 1, 'Staging Migration - Implementation Step 14 - Student Course', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP15_Assessment_EncapsulatedCode', 16, 1, 'Staging Migration - Implementation Step 15 - Assessment', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP16_StaffAssignment_EncapsulatedCode', 17, 1, 'Staging Migration - Implementation Step 16 - Staff Assignment', null)

    insert into App.DataMigrationTasks
	(DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, [Description], TaskName)
	values
	(1, 1, 0, 0, 'App.Migrate_Data_ETL_IMPLEMENTATION_STEP17_StateDefinedCustomIndicator_EncapsulatedCode', 18, 1, 'Staging Migration - Implementation Step 17 - State Defined Custom Indicator', null)

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