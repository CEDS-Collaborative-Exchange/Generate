--update the StoredProcedureName for the Exiting 
update app.DataMigrationTasks
set storedprocedurename = replace(StoredProcedureName, 'specedexit', 'exiting')
where storedprocedurename like '%specedexit%'

