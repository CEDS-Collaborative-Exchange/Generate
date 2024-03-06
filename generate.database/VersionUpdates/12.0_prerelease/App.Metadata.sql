IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'Discipline')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('discipline', 'Discipline Data')
END

IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'Assessment')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('assessment', 'Assessment Data')
END

IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'Staff')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('staff', 'Staff Data')
END


  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and StoredProcedureName like '%datapopulation%' and StoredProcedureName like '%studentassessments%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and StoredProcedureName like '%datapopulation%' and StoredProcedureName like '%studentcounts%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%studentassessments%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%studentcounts%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%personnelcounts%'

  Update app.DataMigrationTasks
  set StoredProcedureName = LEFT(StoredProcedureName, (LEN(StoredProcedureName) - CHARINDEX(',', REVERSE(StoredProcedureName)) + 1) - 1)
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and (LEN(StoredProcedureName) - LEN(REPLACE(StoredProcedureName, ',', ''))) = 2