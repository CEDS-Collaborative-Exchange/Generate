set nocount on
begin try
	begin transaction

		--Check for the existance of the Source to Staging scripts in the new name format
		--	remove them so they can all be added in the correct order later in this process
		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Directory%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Directory%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_ChildCount%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_ChildCount%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Exiting%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Exiting%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Discipline%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Discipline%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Assessments%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Assessments%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Staff%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Staff%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_ChronicAbsenteeism%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_ChronicAbsenteeism%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Dropout%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Dropout%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_GraduatesCompleters%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_GraduatesCompleters%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_GraduationRate%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_GraduationRate%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Homeless%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Homeless%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_HSGradPSEnroll%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_HSGradPSEnroll%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Immigrant%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Immigrant%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Membership%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_Membership%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_MigrantEdProgram%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_MigrantEdProgram%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_NeglectedOrDelinquent%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_NeglectedOrDelinquent%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleI%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleI%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleIIIELOct%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleIIIELOct%'
		END

		IF EXISTS (SELECT 1 FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleIIIELSY%')
		BEGIN
			DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like '%Source-to-Staging_TitleIIIELSY%'
		END

		--Clear the old IDS migration scripts
		DELETE FROM app.DataMigrationTasks WHERE StoredProcedureName like 'Staging.Wrapper_Migrate_%_to_IDS%'

		--Create space in the table for the new procdures 
		update app.DataMigrationTasks
		set TaskSequence = TaskSequence + 20
		where DataMigrationTypeId = 1 

		--Add the new stored procedures
		insert into app.DataMigrationTasks
		values
		(1,1,0,0,'Staging.Source-to-Staging_Directory',				1,	0,'029, 035, 039, 103, 129, 130, 131, 163, 170, 190, 193, 196, 197, 198, 205, 206',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_ChildCount',			2,	0,'002, 089',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Exiting',				3,	0,'009',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Discipline',			4,	0,'005, 006, 007, 086, 088, 143, 144',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Staff',					5,	0,'059, 065, 067, 070, 099, 112, 203',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Assessment',			6,	0,'113, 125, 126, 137, 138, 139, 142, 175, 178, 179, 185, 188, 189',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_ChronicAbsenteeism',	7,	0,'195',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Dropout',				8,	0,'032',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_GraduatesCompleters',	9,	0,'040',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_GraduationRate',		10,	0,'150, 151',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Homeless',				11,	0,'118, 194',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_HsGradPsEnroll',		12,	0,'160',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Immigrant',				13,	0,'165',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_Membership',			14,	0,'033, 052',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_MigrantEdProgram',		15,	0,'054, 121, 145',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_NeglectedOrDelinquent',	16,	0,'119, 127',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_TitleI',				17,	0,'037, 134',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_TitleIIIELOct',			18,	0,'141',NULL),
		(1,1,0,0,'Staging.Source-to-Staging_TitleIIIELSY',			19,	0,'045, 116',NULL)


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