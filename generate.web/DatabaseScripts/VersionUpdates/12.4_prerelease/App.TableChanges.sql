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

--add toggle question for 033 reporting
if not exists (SELECT * FROM app.ToggleQuestions WHERE EmapsQuestionAbbrv = 'LUNCHCOUNTS')
begin
	insert into app.ToggleQuestions
	values ('LUNCHCOUNTS',NULL,1402,'How do you report your Free and Reduced Lunch counts?',10,35)
end

declare @ToggleQuestionId int
select @ToggleQuestionId = ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'LUNCHCOUNTS'

insert into app.ToggleQuestionOptions
values (1, 'Free and Reduced Only', @ToggleQuestionId),
	(2, 'Direct Certification Only', @ToggleQuestionId),
	(3, 'Both', @ToggleQuestionId)
