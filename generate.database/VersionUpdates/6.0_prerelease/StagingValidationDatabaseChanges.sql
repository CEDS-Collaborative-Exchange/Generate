-- Database Changes for Staging Validation --

-- Add StagingValidationRuleId column to staging.STagingValidationResults table
alter table staging.StagingValidationResults
add StagingValidationRuleId int

-- Add Additional DataMigrationTypes
insert into App.DataMigrationTypes	select 'StagingValidation', 'Staging Data Validation'
insert into App.DataMigrationTypes	select 'RDSValidation', 'RDS Data Validation'

