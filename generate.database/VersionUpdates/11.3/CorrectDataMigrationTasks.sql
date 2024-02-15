--wrap the SP name in brackets [] to avoid issues with the dashes in the name
update app.DataMigrationTasks
set StoredProcedureName = replace(StoredProcedureName,'Source.S', '[Source].[S')
where DataMigrationTypeId = 1
and StoredProcedureName not like '%[%'

update app.DataMigrationTasks
set StoredProcedureName = replace(StoredProcedureName,' @SchoolYear', '] @SchoolYear')
where DataMigrationTypeId = 1
and StoredProcedureName not like '%] @SchoolYear%'