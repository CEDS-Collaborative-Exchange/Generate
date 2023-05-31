if not exists (select * from App.DataMigrationTypes where DataMigrationTypeCode = 'StagingValidation')
BEGIN
    insert into App.DataMigrationTypes	select 'StagingValidation', 'Staging Data Validation'
END

if not exists (select * from App.DataMigrationTypes where DataMigrationTypeCode = 'RDSValidation')
BEGIN
    insert into App.DataMigrationTypes	select 'RDSValidation', 'RDS Data Validation'
END