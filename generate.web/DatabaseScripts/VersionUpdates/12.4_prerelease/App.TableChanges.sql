IF COL_LENGTH('App.FileColumns', 'ReportColumn') IS NULL
BEGIN
    ALTER TABLE App.FileColumns ADD ReportColumn varchar(100) null
END

update app.DataMigrationTasks
set StoredProcedureName = 'rds.Empty_Reports ''chronicabsenteeism'''
where datamigrationtypeid = 3
and facttypeId = 17
and StoredProcedureName = 'rds.Empty_Reports ''chronic'''

update app.DataMigrationTasks
set StoredProcedureName = 'rds.create_Reports ''chronicabsenteeism'',0'
where datamigrationtypeid = 3
and facttypeId = 17
and StoredProcedureName = 'rds.create_Reports ''chronic'',0'

update app.DataMigrationTasks
set Description = '141'
	, StoredProcedureName = 'App.Wrapper_Migrate_TitleIIIELOct_to_RDS'
where datamigrationtypeid = 2
and facttypeId = 9

update app.DataMigrationTasks
set Description = '045,116,210,211'
	, StoredProcedureName = 'App.Wrapper_Migrate_TitleIIIELSY_to_RDS'
where datamigrationtypeid = 2
and facttypeId = 10

update app.DataMigrationTasks
set Description = '050,113,125,126,137,138,139,175,178,179,185,188,189,224,225'
	, StoredProcedureName = 'App.Wrapper_Migrate_Assessment_to_RDS'
where datamigrationtypeid = 2
and facttypeId = 25

update app.DataMigrationTasks
set Description = '045,116,210,211,222'
where datamigrationtypeid = 2
and facttypeId = 10

update app.DataMigrationTasks
set StoredProcedureName = 'App.Wrapper_Migrate_ChronicAbsenteeism_to_RDS'
where datamigrationtypeid = 2
and facttypeId = 17

update app.DataMigrationTasks
set StoredProcedureName = '[Source].[Source-to-Staging_MigrantEducationProgram] @SchoolYear'
	, FactTypeId = 13
where datamigrationtypeid = 1
and StoredProcedureName = '[Source].[Source-to-Staging_MigrantEdProgram] @SchoolYear'

update app.DataMigrationTasks
set Description = 'Staging Validation for chronicabsenteeism'
where datamigrationtypeid = 5
and FactTypeId = 17

--update all the description data for MigrationTypeId = 1 from MigrationTypeId = 2
update a
set a.Description = b.Description
from App.DataMigrationTasks a
	inner join app.DataMigrationTasks b
		on a.DataMigrationTypeId = 1 
		and b.DataMigrationTypeId = 2
		and a.FactTypeId = b.FactTypeId
where a.DataMigrationTypeId = 1

--fix the metadata for 070
UPDATE app.FileColumns
SET DimensionId = 4
WHERE DisplayName = 'Qualification Status (Special Education Teacher)'
