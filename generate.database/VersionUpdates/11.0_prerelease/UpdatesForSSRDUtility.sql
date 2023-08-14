--update the staff name in the table
update app.generatereportgroups
set ReportGroup = 'Staff'
where ReportGroup = 'Personnel'

--add the remaining domains to the table
delete from app.generatereportgroups
where ReportGroupId in (8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

insert into app.generatereportgroups
values 
(8,'ChronicAbsenteeism'),
(9,'Dropout'),
(10,'GraduatesCompleters'),
(11,'GraduationRate'),
(12,'Homeless'),
(13,'HSGraduatePSEnrollment'),
(14,'Immigrant'),
(15,'MigrantEducationProgram'),
(16,'NeglectedOrDelinquent'),
(17,'TitleI'),
(18,'TitleIIIELOct'),
(19,'TitleIIIELSY')


--reset GenerateStagingTables with the latest
if OBJECT_ID('app.GenerateStagingTables', 'U') is not null
	drop table app.GenerateStagingTables; 

create table app.GenerateStagingTables (
	StagingTableId int identity(1,1)
	, StagingTableName varchar(100)
)

insert into app.GenerateStagingTables (
	StagingTableName
)
select distinct table_name
from INFORMATION_SCHEMA.tables
where table_schema = 'staging'
and table_name not like '%validation%'
and table_name <> 'datacollection'
and table_name <> 'sourcesystemreferencedata'
order by table_name

--update the xref table with the new staging table ids
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 51 where StagingTableId = 16
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 39 where StagingTableId = 15
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 36 where StagingTableId = 14
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 33 where StagingTableId = 12
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 32 where StagingTableId = 11
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 31 where StagingTableId = 10
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 30 where StagingTableId = 9
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 27 where StagingTableId = 8
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 22 where StagingTableId = 17
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 19 where StagingTableId = 13
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 18 where StagingTableId = 7
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 17 where StagingTableId = 6
update [App].[GenerateReport_GenerateStagingTablesXREF]
set StagingTableId = 6 where StagingTableId = 5


--create the new table
if OBJECT_ID('app.SourceSystemReferenceMapping_DomainFile_XREF', 'U') is not null
	drop table app.SourceSystemReferenceMapping_DomainFile_XREF; 

create table app.SourceSystemReferenceMapping_DomainFile_XREF(
	ID int identity(1,1)
	, GenerateReportGroup varchar(500) NOT NULL
	, GenerateReportId varchar(200) NULL
	, StagingTableId int 
	, CEDSReferenceTable varchar(100) NULL
	, SSRDTableFilter varchar(25) NULL
	, Notes varchar(250) NULL
)

--populate the new table
insert into app.SourceSystemReferenceMapping_DomainFile_XREF
values 
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',18,	'RefOrganizationType','001156', 'Used for Directory Lite if the full Dircetory ETL is not complete yet'),	
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',18,	'RefOperationalStatus',	'000174', 'LEA Table Filter, also used for Directory Lite if the full Dircetory ETL is not complete yet'),
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',18,	'RefOperationalStatus','000533', 'School Table Filter, also used for Directory Lite if the full Dircetory ETL is not complete yet'),
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',18,	'RefLeaType',NULL, 'Used for Directory Lite if the full Dircetory ETL is not complete yet'),		
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',18,	'RefSchoolType',NULL,'Used for Directory Lite if the full Dircetory ETL is not complete yet'),
('Directory,ChildCount,Discipline,Exiting,Assessments,Membership,Homeless','39,19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100',33,	'RefProgramType',NULL, 'populated by Generate, Used for Directory Lite if the full Dircetory ETL is not complete yet'),
('Directory','39',18,	'RefInstitutionTelephoneType',NULL, NULL),		
('Directory','39',18,	'RefCharterSchoolAuthorizerType',NULL, NULL),
('Directory','39',18,	'RefCharterLeaStatus',NULL, NULL),		
('Directory','39',18,	'RefSchoolType',NULL, NULL),
('Directory','39',18,	'RefReconstitutedStatus',NULL, NULL),		
('Directory','39',27,	'RefOrganizationLocationType',NULL, NULL),		
('Directory','39',32,	'RefInstitutionTelephoneType',NULL, NULL),		
('Directory','44',31,	'RefGradeLevel','000100',NULL),
('ChildCount,Discipline,Exiting,Assessments,Membership,Homeless', '19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100', 17,'RefSex',NULL,		NULL),
('ChildCount,Discipline,Exiting,Assessments,Membership,Homeless', '19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100', 17,'RefGradeLevel','000100',	NULL),
('ChildCount,Discipline,Exiting,Assessments,Membership,Homeless', '19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100', 19,'RefRace',NULL,		NULL),
('ChildCount,Discipline,Exiting,Assessments', '19,12,18,17,16,14,9,8,15,7,6,81,5,4,84', 13,'RefIdeaDisabilityType',	NULL, 'For loading the IdeaDisabilityType table, load as many Disabilities as you have available but mark the one needed for reporting by setting the IsPrimaryDisability flag'),
('ChildCount,Discipline,', '19,18,17,16,14,9,8', 39,'RefIDEAEducationalEnvironmentSchoolAge',NULL,'used by Child Count categories and by Discipline to exclude PPPS Education Environment from reports'),
('ChildCount', '12', 39,'RefIDEAEducationalEnvironmentEC',NULL,NULL),
('Discipline', '18,17,16,14,9,8', 6,	'RefDisciplinaryActionTaken',				NULL,		NULL),
('Discipline', '18,17,16,14,9,8', 6,	'RefDisciplineMethodOfCwd',					NULL,		NULL),
('Discipline', '18,17,16,14,9,8', 6,	'RefIDEAInterimRemoval',					NULL,		NULL),
('Discipline', '18,17,16,14,9,8', 6,	'RefIDEAInterimRemovalReason',				NULL,		NULL),
('Discipline', 'c086', 6,				'RefFirearmType',	NULL,		NULL),
('Discipline', 'c086', 6,				'RefDisciplineMethodFirearms',	NULL,		NULL),
('Discipline', 'c086', 6,				'RefIDEADisciplineMethodFirearm',	NULL,		NULL),
('Exiting', '15', 39,	'RefSpecialEducationExitReason',	NULL,		NULL),
('Staff', '10,11,26', 22,	'RefK12StaffClassification',	NULL,		NULL),
('Staff', '10,26', 22,	'RefSpecialEducationAgeGroupTaught',	NULL,		NULL),
('Staff', '10', 22,	'RefParaprofessionalQualification',	NULL,		NULL),
('Staff', '11', 22,	'RefSpecialEducationStaffCategory',	NULL,		NULL),
('Staff', '11', 22,	'RefEdFactsCertificationStatus',	NULL,		NULL),
('Staff', '26', 22,	'RefSpecialEducationTeacherQualificationStatus',	NULL,		NULL)


--Populate new SSRD values with default mappings for the max school year in the SSRD table
declare @schoolYear int 
if (select count(*) from Staging.SourceSystemReferenceData where SchoolYear = 2023) > 0
	begin
		select @schoolYear = 2023
	end
else
	begin
		select @schoolYear = max(SchoolYear) from Staging.SourceSystemReferenceData
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefIdeaDisabilityType')
	begin
		insert into staging.SourceSystemReferenceData
		select distinct @schoolYear, 'RefIdeaDisabilityType', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'IdeaDisabilityType'
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefTeachingCredentialType')
	begin
		insert into staging.SourceSystemReferenceData
		select @schoolYear, 'RefTeachingCredentialType', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'TeachingCredentialType'
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefSpecialEducationTeacherQualificationStatus')
	begin
		insert into staging.SourceSystemReferenceData
		select distinct @schoolYear,  'RefSpecialEducationTeacherQualificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'SpecialEducationTeacherQualificationStatus'	
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefTitleIIILanguageInstructionProgramType')
	begin
		insert into staging.SourceSystemReferenceData
		select distinct @schoolYear, 'RefTitleIIILanguageInstructionProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'TitleIIILanguageInstructionProgramType'
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefProficiencyStatus')
	begin
		insert into staging.SourceSystemReferenceData
		select distinct @schoolYear, 'RefProficiencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'ProficiencyStatus'
	end

 if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = @schoolYear and TableName = 'RefTitleIIIAccountability')
	begin
		insert into staging.SourceSystemReferenceData
		select distinct @schoolYear, 'RefTitleIIIAccountability', NULL, CedsOptionSetCode, CedsOptionSetCode 
		from CEDS.CedsOptionSetMapping 
		where CedsElementTechnicalName = 'TitleIIIAccountabilityProgressStatus'
	end

