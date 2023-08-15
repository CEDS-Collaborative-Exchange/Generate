set nocount on
begin try
 
begin transaction
If NOT exists (select distinct 1 from app.DataMigrationTasks where DataMigrationTypeId=(Select distinct DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode='ods' )) 
	BEGIN
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,1,0,0,'ods.Migrate_DimStudents_adhoc',1,1,'ODS migration 1 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,2,0,0,'ods.Migrate_DimPersonnel_adhoc',2,1,'ODS migration 2 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,3,0,0,'ods.Migrate_StudentRace_adhoc',3,1,'ODS migration 3 test stored procedure')
	insert into app.DataMigrationTasks (DataMigrationTypeId, IsActive,RunAfterGenerateMigration,RunBeforeGenerateMigration,StoredProcedureName,TaskSequence,IsSelected, Description)
								values(1,4,0,0,'ods.Migrate_Organization_adhoc',4,1,'ODS migration 4 test stored procedure')
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
