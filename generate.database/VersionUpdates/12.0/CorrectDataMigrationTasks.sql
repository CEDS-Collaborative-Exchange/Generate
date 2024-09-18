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

update app.DataMigrationTasks
set Description = concat(Description, ', 226')
where StoredProcedureName like '%Membership%'
and DataMigrationTypeId = 2

update app.DataMigrationTasks
set Description = concat(Description, ', 218, 219, 220, 221')
where StoredProcedureName like '%Neglected%'
and DataMigrationTypeId = 2

update app.DataMigrationTasks
set Description = concat(Description, ', 222')
where StoredProcedureName like '%TitleI_%'
and DataMigrationTypeId = 2

update app.DataMigrationTasks
set Description = concat(Description, ', 224, 225')
where StoredProcedureName like '%Assessment%'
and DataMigrationTypeId = 2

update app.DataMigrationTasks
set Description = concat(Description, ', 210, 211')
where StoredProcedureName like '%TitleIIIELSY%'
and DataMigrationTypeId = 2

update app.DataMigrationTasks
set Description = concat(Description, ', 199')
where StoredProcedureName like '%Graduation%'
and DataMigrationTypeId = 2
