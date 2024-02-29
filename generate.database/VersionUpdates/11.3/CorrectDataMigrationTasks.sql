--wrap the SP name in brackets [] to avoid issues with the dashes in the name
update app.DataMigrationTasks
set StoredProcedureName = replace(StoredProcedureName,'Source.S', '[Source].[S')
where DataMigrationTypeId = 1
and StoredProcedureName not like '%[%'

update app.DataMigrationTasks
set StoredProcedureName = replace(StoredProcedureName,' @SchoolYear', '] @SchoolYear')
where DataMigrationTypeId = 1
and StoredProcedureName not like '%] @SchoolYear%'
 
--update the StoredProcedureName for the wrappers to use the changed names
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_GraduatesCompleters_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_Grad_to_RDS'
 
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_GraduationRate_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_GradRate_to_RDS'
 
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_HsGradPSEnroll_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_HsGradEnroll_to_RDS'
 
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_MigrantEducationProgram_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_Mep_to_RDS'
 
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_NeglectedOrDelinquent_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_NorD_to_RDS'
 
update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_Staff_to_RDS'
where DataMigrationTypeId = 2
and StoredProcedureName = 'App.Wrapper_Migrate_Personnel_to_RDS'