--Update DataMigrationTasks for the NorD Fact Type
update app.DataMigrationTasks
set facttypeid = 15
where StoredProcedureName like '%neglec%'

