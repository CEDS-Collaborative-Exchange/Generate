IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'discipline')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('discipline', 'Discipline Data')
END

IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'assessment')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('assessment', 'Assessment Data')
END

IF NOT EXISTS(SELECT 1 FROM RDS.DimFactTypes where FactTypeCode = 'staff')
BEGIN
	INSERT INTO [RDS].[DimFactTypes]([FactTypeCode],[FactTypeDescription])
	VALUES('staff', 'Staff Data')
END

update rds.DimFactTypes
set FactTypeCode = 'graduatescompleters'
where FactTypeCode = 'grad'
 
update rds.DimFactTypes
set FactTypeCode = 'graduationrate'
where FactTypeCode = 'gradrate'
 
update rds.DimFactTypes
set FactTypeCode = 'hsgradpsenroll'
where FactTypeCode = 'hsgradenroll'
 
update rds.DimFactTypes
set FactTypeCode = 'migranteducationprogram'
where FactTypeCode = 'mep'
 
update rds.DimFactTypes
set FactTypeCode = 'neglectedordelinquent'
where FactTypeCode = 'nord'
 
update rds.DimFactTypes
set FactTypeCode = 'exiting'
where FactTypeCode = 'specedexit'


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

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and StoredProcedureName like '%datapopulation%' and StoredProcedureName like '%studentcounts%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and StoredProcedureName like '%datapopulation%' and StoredProcedureName like '%studentassessments%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%studentcounts%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%studentassessments%'

  delete from app.DataMigrationTasks
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and StoredProcedureName like '%submission%' and StoredProcedureName like '%personnelcounts%'

  Update app.DataMigrationTasks
  set StoredProcedureName = LEFT(StoredProcedureName, (LEN(StoredProcedureName) - CHARINDEX(',', REVERSE(StoredProcedureName)) + 1) - 1)
  where DataMigrationTypeId = 3 and StoredProcedureName like '%create_reports%'
  and (LEN(StoredProcedureName) - LEN(REPLACE(StoredProcedureName, ',', ''))) = 2

  Update app.DataMigrationTasks
  set StoredProcedureName = LEFT(StoredProcedureName, (LEN(StoredProcedureName) - CHARINDEX(',', REVERSE(StoredProcedureName)) + 1) - 1)
  where DataMigrationTypeId = 3 and StoredProcedureName like '%Empty_Reports%'
  and (LEN(StoredProcedureName) - LEN(REPLACE(StoredProcedureName, ',', ''))) = 1

  Update app.DataMigrationTasks
  set StoredProcedureName = 'App.Wrapper_Migrate_Staff_to_RDS'
  where DataMigrationTypeId = 2 and StoredProcedureName like 'App.Wrapper_Migrate_Personnel_to_RDS'

  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%Empty_Reports%' and StoredProcedureName like '%discipline%')
  BEGIN
      INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.Empty_Reports ''discipline''',55,1,'')
  END
  
  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%create_reports%' and StoredProcedureName like '%discipline%')
  BEGIN
    INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.create_reports ''discipline'',0',56,1,'')
  END

  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%Empty_Reports%' and StoredProcedureName like '%assessment%')
  BEGIN
    INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.Empty_Reports ''assessment''',57,1,'')
  END
  
  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%create_reports%' and StoredProcedureName like '%assessment%')
  BEGIN
    INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.create_reports ''assessment'',0',58,1,'')
  END

  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%Empty_Reports%' and StoredProcedureName like '%staff%')
  BEGIN
    INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.Empty_Reports ''staff''',59,1,'')
  END
  
  IF NOT EXISTS(SELECT 1 FROM app.DataMigrationTasks where DataMigrationTypeId = 3
  and StoredProcedureName like '%create_reports%' and StoredProcedureName like '%staff%')
  BEGIN
    INSERT INTO [App].[DataMigrationTasks]
            ([DataMigrationTypeId]
            ,[IsActive]
            ,[RunAfterGenerateMigration]
            ,[RunBeforeGenerateMigration]
            ,[StoredProcedureName]
            ,[TaskSequence]
            ,[IsSelected]
            ,[Description])
    VALUES (3,1,0,0,'rds.create_reports ''staff'',0',60,1,'')
  END



declare @submissionFactTypeId as int, @newFactTypeId as int

select @submissionFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'submission'
select @newFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'discipline'
Update rds.FactK12StudentDisciplines set FactTypeId = @newFactTypeId where FactTypeId = @submissionFactTypeId

select @newFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'assessment'
Update rds.FactK12StudentAssessments set FactTypeId = @newFactTypeId where FactTypeId = @submissionFactTypeId

select @newFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'staff'
Update rds.FactK12StaffCounts set FactTypeId = @newFactTypeId where FactTypeId = @submissionFactTypeId