--build the list of indexes that need to be removed
if OBJECT_ID('tempdb..#index_names', 'U') IS NOT NULL 
  drop table #index_names 

create table #index_names (
	indexName varchar(250)
	, tableName varchar(100)
)

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'Assessment'
	AND col.name in ('AssessmentId','AssessmentAdministrationId','AssessmentSubtestId','AssessmentFormId','AssessmentPerformanceLevelId','DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'AssessmentResult'
	AND col.name in ('DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'CharterSchoolAuthorizer'
	AND col.name in ('CharterSchoolId','CharterSchoolAuthorizingOrganizationOrganizationId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'CharterSchoolManagementOrganization'
	AND col.name in ('CharterSchoolId','CharterSchoolManagementOrganizationOrganizationId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'Discipline'
	AND col.name in ('PersonId','OrganizationID_LEA','OrganizationPersonRoleId_LEA','OrganizationID_School','OrganizationPersonRoleId_School','IncidentId_LEA','IncidentId_School')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12Enrollment'
	AND col.name in ('PersonId','OrganizationID_LEA','OrganizationPersonRoleId_LEA','OrganizationID_School','OrganizationPersonRoleId_School','OrganizationPersonRoleRelationshipId','DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12PersonRace'
	AND col.name in ('DataCollectionId','PersonId','PersonDemographicRaceId','OrganizationID_LEA','OrganizationID_School','RefRaceId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12ProgramParticipation'
	AND col.name in ('DataCollectionId','OrganizationId_LEA','OrganizationId_School','PersonId','ProgramOrganizationId_LEA','ProgramOrganizationId_School','OrganizationPersonRoleId_LEA','OrganizationPersonRoleId_School')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12SchoolComprehensiveSupportIdentificationType'
	AND col.name in ('OrganizationId','K12SchoolId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12StudentAddress'
	AND col.name in ('DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'K12StudentCourseSection'
	AND col.name in ('DataCollectionId','PersonId','OrganizationID_LEA','OrganizationPersonRoleId_LEA','OrganizationID_School','OrganizationPersonRoleId_School','OrganizationID_Course','OrganizationID_CourseSection','OrganizationPersonRoleId_CourseSection')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'Migrant'
	AND col.name in ('PersonID','OrganizationID_LEA','OrganizationID_School','LEAOrganizationPersonRoleID_MigrantProgram','LEAOrganizationID_MigrantProgram','SchoolOrganizationPersonRoleID_MigrantProgram','SchoolOrganizationID_MigrantProgram','PersonProgramParticipationId','ProgramParticipationMigrantId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationAddress'
	AND col.name in ('RefStateId','OrganizationId','LocationId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationCalendarSession'
	AND col.name in ('DataCollectionId','OrganizationId','OrganizationCalendarId','OrganizationCalendarSessionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationCustomSchoolIndicatorStatusType'
	AND col.name in ('DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationFederalFunding'
	AND col.name in ('DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationGradeOffered'
	AND col.name in ('DataCollectionId','OrganizationId','K12SchoolGradeOfferedId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationPhone'
	AND col.name in ('OrganizationId','LEA_OrganizationTelephoneId','School_OrganizationTelephoneId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'OrganizationProgramType'
	AND col.name in ('DataCollectionId','OrganizationId','ProgramOrganizationId','ProgramTypeId','OrganizationProgramTypeId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PersonStatus'
	AND col.name in ('DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'ProgramParticipationCTE'
	AND col.name in ('DataCollectionID','PersonID','OrganizationID_School','OrganizationPersonRoleID_School','OrganizationPersonRoleID_CTEProgram','OrganizationID_CTEProgram','PersonProgramParticipationId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'ProgramParticipationNorD'
	AND col.name in ('DataCollectionID','PersonID','OrganizationID_School','OrganizationID_LEA','LEAOrganizationID_Program','SchoolOrganizationID_Program','LEAOrganizationPersonRoleId_Program','SchoolOrganizationPersonRoleId_Program','PersonProgramParticipationID')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'ProgramParticipationSpecialEducation'
	AND col.name in ('DataCollectionID','PersonID','OrganizationID_School','OrganizationID_LEA','LEAOrganizationID_Program','SchoolOrganizationID_Program','LEAOrganizationPersonRoleId_Program','SchoolOrganizationPersonRoleId_Program','PersonProgramParticipationID_LEA','PersonProgramParticipationID_School')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'ProgramParticipationTitleI'
	AND col.name in ('DataCollectionID','PersonID','OrganizationID_LEA','OrganizationID_School','LEAOrganizationPersonRoleID_TitleIProgram','LEAOrganizationID_TitleIProgram','LEAPersonProgramParticipationId','SchoolOrganizationID_TitleIProgram','SchoolOrganizationPersonRoleID_TitleIProgram','SchoolPersonProgramParticipationId','RefTitleIIndicatorId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'ProgramParticipationTitleIII'
	AND col.name in ('DataCollectionID','PersonID','OrganizationID_School','OrganizationPersonRoleID_TitleIIIProgram','OrganizationID_TitleIIIProgram','PersonProgramParticipationId','ImmigrationPersonStatusId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PsInstitution'
	AND col.name in ('OrganizationId','OrganizationOperationalStatusId','OperationalStatusId','MostPrevalentLevelOfInstitutionId','PredominantCalendarSystemId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PsPersonRace'
	AND col.name in ('PersonId','PersonDemographicRaceId','OrganizationId','RefRaceId','RefAcademicTermDesignatorId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PsStudentAcademicAward'
	AND col.name in ('OrganizationId','PersonId','OrganizationPersonRoleId','PsStudentAcademicAwardId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PsStudentAcademicRecord'
	AND col.name in ('PersonID','OrganizationId','OrganizationPersonRoleId','PsStudentAcademicRecordId','DataCollectionId')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'PsStudentEnrollment'
	AND col.name in ('DataCollectionId','PersonId','OrganizationPersonRoleId','OrganizationId_PsInstitution')

INSERT INTO #index_names
SELECT distinct ind.name, t.name
FROM sys.indexes ind 
INNER JOIN sys.index_columns ic 
	ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN sys.columns col 
	ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN sys.tables t 
	ON ind.object_id = t.object_id 
INNER JOIN sys.schemas s 
	ON t.schema_id = s.schema_id 
WHERE ind.is_primary_key = 0 
    AND ind.is_unique = 0 
    AND ind.is_unique_constraint = 0 
    AND t.is_ms_shipped = 0 
	AND s.name = 'Staging'
	AND t.name = 'StateDetail'
	AND col.name in ('DataCollectionId','PersonId','OrganizationId')

--Drop the indexes
DECLARE @IndexName NVARCHAR(255)
DECLARE @TableName NVARCHAR(255)
DECLARE @DropIndexSQL NVARCHAR(MAX)

-- Create a cursor to iterate through the index names
DECLARE IndexCursor CURSOR FOR
SELECT DISTINCT IndexName, tableName
FROM #index_names -- Replace with your actual table name

-- Open the cursor
OPEN IndexCursor

-- Fetch the first index name
FETCH NEXT FROM IndexCursor INTO @IndexName, @TableName

-- Loop through the index names and drop the corresponding indexes
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build the dynamic SQL query to drop the index
    SET @DropIndexSQL = 'DROP INDEX ' + QUOTENAME(@IndexName) + ' ON Staging.' + QUOTENAME(@TableName)  -- Replace with your actual table name

    -- Execute the dynamic SQL query
    EXEC sp_executesql @DropIndexSQL

    -- Fetch the next index name
    FETCH NEXT FROM IndexCursor INTO @IndexName, @TableName
END

-- Close and deallocate the cursor
CLOSE IndexCursor
DEALLOCATE IndexCursor

--Assessment
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'AssessmentId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column AssessmentId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'AssessmentAdministrationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column AssessmentAdministrationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'AssessmentSubtestId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column AssessmentSubtestId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'AssessmentFormId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column AssessmentFormId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'AssessmentPerformanceLevelId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column AssessmentPerformanceLevelId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Assessment'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Assessment
        drop column DataCollectionId
  end

--AssessmentResult
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'AssessmentResult'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.AssessmentResult
        drop column DataCollectionId
  end

--CharterSchoolAuthorizer
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'CharterSchoolAuthorizer'
            and     COLUMN_NAME = 'CharterSchoolId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.CharterSchoolAuthorizer
        drop column CharterSchoolId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'CharterSchoolAuthorizer'
            and     COLUMN_NAME = 'CharterSchoolAuthorizingOrganizationOrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.CharterSchoolAuthorizer
        drop column CharterSchoolAuthorizingOrganizationOrganizationId
  end

--CharterSchoolManagementOrganization
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'CharterSchoolManagementOrganization'
            and     COLUMN_NAME = 'CharterSchoolId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.CharterSchoolManagementOrganization
        drop column CharterSchoolId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'CharterSchoolManagementOrganization'
            and     COLUMN_NAME = 'CharterSchoolManagementOrganizationOrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.CharterSchoolManagementOrganization
        drop column CharterSchoolManagementOrganizationOrganizationId
  end

--Discipline
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column OrganizationPersonRoleId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column OrganizationPersonRoleId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'IncidentId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column IncidentId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Discipline'
            and     COLUMN_NAME = 'IncidentId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Discipline
        drop column IncidentId_School
  end

--K12Enrollment
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column OrganizationPersonRoleId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column OrganizationPersonRoleId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'OrganizationPersonRoleRelationshipId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column OrganizationPersonRoleRelationshipId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12Enrollment'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12Enrollment
        drop column DataCollectionId
  end

--K12PersonRace
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'PersonDemographicRaceId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column PersonDemographicRaceId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'RefRaceId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column RefRaceId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12PersonRace'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12PersonRace
        drop column DataCollectionId
  end

--K12ProgramParticipation
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column OrganizationPersonRoleId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column OrganizationPersonRoleId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'ProgramOrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column ProgramOrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'ProgramOrganizationId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column ProgramOrganizationId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12ProgramParticipation'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12ProgramParticipation
        drop column DataCollectionId
  end

--K12SchoolComprehensiveSupportIdentificationType
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12SchoolComprehensiveSupportIdentificationType
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType'
            and     COLUMN_NAME = 'K12SchoolId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12SchoolComprehensiveSupportIdentificationType
        drop column K12SchoolId
  end

--K12StudentAddress
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentAddress'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentAddress
        drop column DataCollectionId
  end

--K12StudentCourseSection
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationPersonRoleId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationPersonRoleId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationID_Course'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationID_Course
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationID_CourseSection'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationID_CourseSection
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_CourseSection'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column OrganizationPersonRoleId_CourseSection
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'K12StudentCourseSection'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.K12StudentCourseSection
        drop column DataCollectionId
  end

--Migrant
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'OrganizationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column OrganizationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'LEAOrganizationPersonRoleID_MigrantProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column LEAOrganizationPersonRoleID_MigrantProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'LEAOrganizationID_MigrantProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column LEAOrganizationID_MigrantProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'SchoolOrganizationPersonRoleID_MigrantProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column SchoolOrganizationPersonRoleID_MigrantProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'SchoolOrganizationID_MigrantProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column SchoolOrganizationID_MigrantProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'PersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column PersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'Migrant'
            and     COLUMN_NAME = 'ProgramParticipationMigrantId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.Migrant
        drop column ProgramParticipationMigrantId
  end

--OrganizationAddress
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationAddress'
            and     COLUMN_NAME = 'RefStateId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationAddress
        drop column RefStateId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationAddress'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationAddress
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationAddress'
            and     COLUMN_NAME = 'LocationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationAddress
        drop column LocationId
  end

--OrganizationCalendarSession
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationCalendarSession'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationCalendarSession
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationCalendarSession'
            and     COLUMN_NAME = 'OrganizationCalendarId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationCalendarSession
        drop column OrganizationCalendarId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationCalendarSession'
            and     COLUMN_NAME = 'OrganizationCalendarSessionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationCalendarSession
        drop column OrganizationCalendarSessionId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationCalendarSession'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationCalendarSession
        drop column DataCollectionId
  end

--OrganizationCustomSchoolIndicatorStatusType
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationCustomSchoolIndicatorStatusType'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationCustomSchoolIndicatorStatusType
        drop column DataCollectionId
  end

--OrganizationFederalFunding
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationFederalFunding'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationFederalFunding
        drop column DataCollectionId
  end

--OrganizationGradeOffered
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationGradeOffered'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationGradeOffered
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationGradeOffered'
            and     COLUMN_NAME = 'K12SchoolGradeOfferedId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationGradeOffered
        drop column K12SchoolGradeOfferedId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationGradeOffered'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationGradeOffered
        drop column DataCollectionId
  end

--OrganizationPhone
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationPhone'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationPhone
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationPhone'
            and     COLUMN_NAME = 'LEA_OrganizationTelephoneId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationPhone
        drop column LEA_OrganizationTelephoneId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationPhone'
            and     COLUMN_NAME = 'School_OrganizationTelephoneId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationPhone
        drop column School_OrganizationTelephoneId
  end

--OrganizationProgramType
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationProgramType'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationProgramType
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationProgramType'
            and     COLUMN_NAME = 'ProgramOrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationProgramType
        drop column ProgramOrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationProgramType'
            and     COLUMN_NAME = 'ProgramTypeId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationProgramType
        drop column ProgramTypeId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationProgramType'
            and     COLUMN_NAME = 'OrganizationProgramTypeId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationProgramType
        drop column OrganizationProgramTypeId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'OrganizationProgramType'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.OrganizationProgramType
        drop column DataCollectionId
  end

--PersonStatus
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PersonStatus'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PersonStatus
        drop column DataCollectionId
  end

--ProgramParticipationCTE
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column OrganizationPersonRoleId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_CTEProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column OrganizationPersonRoleId_CTEProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'OrganizationID_CTEProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column OrganizationID_CTEProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'PersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column PersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationCTE'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationCTE
        drop column DataCollectionId
  end

--ProgramParticipationNorD
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'OrganizationID_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column OrganizationID_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'LEAOrganizationPersonRoleId_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column LEAOrganizationPersonRoleId_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'SchoolOrganizationPersonRoleId_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column SchoolOrganizationPersonRoleId_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'LEAOrganizationID_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column LEAOrganizationID_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'SchoolOrganizationID_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column SchoolOrganizationID_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'PersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column PersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationNorD'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationNorD
        drop column DataCollectionId
  end

--ProgramParticipationSpecialEducation
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'OrganizationID_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column OrganizationID_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'LEAOrganizationPersonRoleId_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column LEAOrganizationPersonRoleId_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'SchoolOrganizationPersonRoleId_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column SchoolOrganizationPersonRoleId_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'LEAOrganizationID_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column LEAOrganizationID_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'SchoolOrganizationID_Program'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column SchoolOrganizationID_Program
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'PersonProgramParticipationId_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column PersonProgramParticipationId_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'PersonProgramParticipationId_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column PersonProgramParticipationId_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationSpecialEducation'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationSpecialEducation
        drop column DataCollectionId
  end

--ProgramParticipationTitleI
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'OrganizationID_LEA'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column OrganizationID_LEA
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'LEAOrganizationPersonRoleId_TitleIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column LEAOrganizationPersonRoleId_TitleIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'SchoolOrganizationPersonRoleId_TitleIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column SchoolOrganizationPersonRoleId_TitleIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'LEAOrganizationID_TitleIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column LEAOrganizationID_TitleIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'SchoolOrganizationID_TitleIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column SchoolOrganizationID_TitleIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'LEAPersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column LEAPersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'SchoolPersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column SchoolPersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'RefTitleIIndicatorId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column RefTitleIIndicatorId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleI'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleI
        drop column DataCollectionId
  end

--ProgramParticipationTitleIII
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'PersonId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column PersonId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'OrganizationID_School'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column OrganizationID_School
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'OrganizationPersonRoleId_TitleIIIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column OrganizationPersonRoleId_TitleIIIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'OrganizationID_TitleIIIProgram'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column OrganizationID_TitleIIIProgram
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'PersonProgramParticipationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column PersonProgramParticipationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'ImmigrationPersonStatusId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column ImmigrationPersonStatusId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'ProgramParticipationTitleIII'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.ProgramParticipationTitleIII
        drop column DataCollectionId
  end

--PsInstitution
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsInstitution'
            and     COLUMN_NAME = 'OrganizationID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsInstitution
        drop column OrganizationID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsInstitution'
            and     COLUMN_NAME = 'OrganizationOperationalStatusId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsInstitution
        drop column OrganizationOperationalStatusId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsInstitution'
            and     COLUMN_NAME = 'OperationalStatusId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsInstitution
        drop column OperationalStatusId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsInstitution'
            and     COLUMN_NAME = 'MostPrevalentLevelOfInstitutionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsInstitution
        drop column MostPrevalentLevelOfInstitutionId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsInstitution'
            and     COLUMN_NAME = 'PredominantCalendarSystemId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsInstitution
        drop column PredominantCalendarSystemId
  end

--PsPersonRace
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsPersonRace'
            and     COLUMN_NAME = 'PersonID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsPersonRace
        drop column PersonID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsPersonRace'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsPersonRace
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsPersonRace'
            and     COLUMN_NAME = 'PersonDemographicRaceId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsPersonRace
        drop column PersonDemographicRaceId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsPersonRace'
            and     COLUMN_NAME = 'RefRaceId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsPersonRace
        drop column RefRaceId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsPersonRace'
            and     COLUMN_NAME = 'RefAcademicTermDesignatorId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsPersonRace
        drop column RefAcademicTermDesignatorId
  end

--PsStudentAcademicAward
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicAward'
            and     COLUMN_NAME = 'PersonID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicAward
        drop column PersonID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicAward'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicAward
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicAward'
            and     COLUMN_NAME = 'OrganizationPersonRoleId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicAward
        drop column OrganizationPersonRoleId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicAward'
            and     COLUMN_NAME = 'PsStudentAcademicAwardId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicAward
        drop column PsStudentAcademicAwardId
  end

--PsStudentAcademicRecord
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicRecord'
            and     COLUMN_NAME = 'PersonID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicRecord
        drop column PersonID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicRecord'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicRecord
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicRecord'
            and     COLUMN_NAME = 'OrganizationPersonRoleId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicRecord
        drop column OrganizationPersonRoleId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicRecord'
            and     COLUMN_NAME = 'PsStudentAcademicRecordId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicRecord
        drop column PsStudentAcademicRecordId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentAcademicRecord'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentAcademicRecord
        drop column DataCollectionId
  end

--PsStudentEnrollment
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentEnrollment'
            and     COLUMN_NAME = 'PersonID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentEnrollment
        drop column PersonID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentEnrollment'
            and     COLUMN_NAME = 'OrganizationPersonRoleId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentEnrollment
        drop column OrganizationPersonRoleId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentEnrollment'
            and     COLUMN_NAME = 'OrganizationId_PsInstitution'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentEnrollment
        drop column OrganizationId_PsInstitution
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'PsStudentEnrollment'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.PsStudentEnrollment
        drop column DataCollectionId
  end

--StateDetail
if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'StateDetail'
            and     COLUMN_NAME = 'PersonID'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.StateDetail
        drop column PersonID
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'StateDetail'
            and     COLUMN_NAME = 'OrganizationId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.StateDetail
        drop column OrganizationId
  end

if exists (select 1
            from    INFORMATION_SCHEMA.COLUMNS
            where   TABLE_NAME = 'StateDetail'
            and     COLUMN_NAME = 'DataCollectionId'
            and     TABLE_SCHEMA = 'Staging'
        )
  begin
        alter table Staging.StateDetail
        drop column DataCollectionId
  end

--cleanup
if OBJECT_ID('tempdb..#index_names', 'U') IS NOT NULL 
  drop table #index_names 
