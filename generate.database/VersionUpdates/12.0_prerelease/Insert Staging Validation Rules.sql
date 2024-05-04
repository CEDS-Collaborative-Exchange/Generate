-- Generate V12 Staging Validation Rules
delete from staging.StagingValidationRules_ReportsXREF where CreatedBy = 'Generate'
delete from Staging.StagingValidationRules where CreatedBy = 'Generate'


-- K12Enrollment ---------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009, C005, C006, C007, C088, C143, C175, C178, C179, C185, C188, C189, C052, C032, C040',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'Sex',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'Birthdate',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C052, C032, C086, C141, C089, C002',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'GradeLevel',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C040',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'HighSchoolDiplomaType',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C045, C141',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'LanguageNative',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'RecordStartDateTime',
	@RuleDscr = 'RecordStartDateTime must be before RecordEndDateTime',
	@Condition = 'where RecordStartDateTime > isnull(RecordEndDateTime, getdate())',
	@ValidationMessage = 'RecordStartDateTime must be before RecordEndDateTime',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'EnrollmentEntryDate',
	@RuleDscr = 'EnrollmentEntryDate must be before EnrollmentExitDate',
	@Condition = 'where EnrollmentEntryDate > isnull(EnrollmentExitDate, getdate())',
	@ValidationMessage = 'EnrollmentEntryDate must be before EnrollmentExitDate',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C052, C032, C086, C141',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'GradeLevel',
	@RuleDscr = 'A student can only be enrolled in a single grade',
	@Condition = 'select StudentIdentifierState, count(*) GradeLevels from (
select distinct StudentIdentifierState, GradeLevel from staging.K12Enrollment) A
group by StudentIdentifierState
having count(*) > 1',
	@ValidationMessage = 'A student can only be enrolled in a single grade',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'StudentIdentifierState',
	@RuleDscr = 'A student has multiple versions of demographic information',
	@Condition = 'select a.StudentIdentifierState, a.LeaIdentifierSeaAccountability, a.SchoolIdentifierSea,
	a.FirstName, a.MiddleName, a.LastOrSurname, a.Birthdate, a.Sex, a.HispanicLatinoEthnicity
from staging.K12Enrollment a
left join staging.K12Enrollment b
	on a.StudentIdentifierState = b.StudentIdentifierState
where a.FirstName <> b.firstname
or a.MiddleName <> b.MiddleName
or a.LastOrSurname <> b.LastOrSurname
or a.Birthdate <> b.Birthdate
or a.sex <> b.sex
or a.HispanicLatinoEthnicity <> b.HispanicLatinoEthnicity',
	@ValidationMessage = 'A student has multiple versions of demographic information',
	@CreatedBy = 'Generate',
	@Enabled = 1


-- K12PersonRace ----------------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009, C005, C006, C007, C088, C143, C175, C178, C179, C185, C188, C189, C052, C118, C032, C040, C141',
	@StagingTableName = 'K12PersonRace',
	@StagingColumnName = 'RaceType',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C005, C006, C007, C009, C032, C040, C052, C086, C088, C089, C118, C141, C143, C144, C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'K12PersonRace',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1



-- PersonStatus -----------------------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009, C005, C006, C007, C088, C143, C175, C178, C179, C185, C188, C189, C118, C032, C040, C045',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'EnglishLearnerStatus',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189, C032, C040',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'EconomicDisadvantageStatus',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189, C118, C032, C040',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'MigrantStatus',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189, C032, C040',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'HomelessnessStatus',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'ProgramType_FosterCare',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'MilitaryConnectedStudentIndicator',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C118',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'HomelessNightTimeResidence',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C118',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'HomelessUnaccompaniedYouth',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C033',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'NationalSchoolLunchProgramDirectCertificationIndicator',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C045',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'ProgramType_Immigrant',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C005, C006, C007, C009, C032, C033, C040, C045, C086, C088, C089, C118, C143, C144, C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'PersonStatus',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1




-- IDEADisabilityType -----------------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009, C005, C006, C007, C088, C143, C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'IdeaDisabilityType',
	@StagingColumnName = 'IdeaDisabilityTypeCode',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C089, C009, C005, C006, C007, C088, C143, C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'IdeaDisabilityType',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1


-- Discipline ----------------------------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C005, C007',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'IdeaInterimRemoval',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C006, C088',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'DurationOfDisciplinaryAction',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C144',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'EducationalServicesAfterRemoval',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C086',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'FirearmType',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C086',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'DisciplineMethodFirearm',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C086',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'IdeaDisciplineMethodFirearm',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'Discipline',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'DisciplinaryActionStartDate',
	@RuleDscr = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
	@Condition = 'where DisciplinaryActionStartDate > isnull(DisciplinaryActionEndDate, getdate())',
	@ValidationMessage = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'Discipline',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1

-- AssessmentResult ------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179',
	@StagingTableName = 'AssessmentResult',
	@StagingColumnName = 'AssessmentTypeAdministered',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'AssessmentResult',
	@StagingColumnName = 'GradeLevelWhenAssessed',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179',
	@StagingTableName = 'AssessmentResult',
	@StagingColumnName = 'AssessmentPerformanceLevelIdentifier',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C185, C188, C189',
	@StagingTableName = 'AssessmentResult',
	@StagingColumnName = 'AssessmentRegistrationParticipationIndicator',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'AssessmentResult',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1


-- K12Organization ---------------------------------------------------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'LeaIdentifierSea',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'LeaOrganizationName',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'Lea_IsReportedFederally',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'Lea_RecordStartDateTime',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'SchoolYear',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'LEA_RecordStartDateTime',
	@RuleDscr = 'LEA_RecordStartDateTime must be before LEA_RecordEndDateTime',
	@Condition = 'where LEA_RecordStartDateTime > isnull(LEA_RecordEndDateTime, getdate())',
	@ValidationMessage = 'LEA_RecordStartDateTime must be before LEA_RecordEndDateTime',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'LEA_OperationalStatusEffectiveDate',
	@RuleDscr = 'LEA must have valid Operational Status Effective Date',
	@Condition = 'where LEA_OperationalStatusEffectiveDate not between ''6/30/'' + convert(varchar, SchoolYear-1) and ''7/1/'' + convert(varchar, SchoolYear)',
	@ValidationMessage = 'Operational Status Effective Date is not between dates of school year',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'School_IsReportedFederally',
	@RuleDscr = 'Column required for schools',
	@Condition = 'where School_IsReportedFederally is NULL and SchoolIdentifierSEA is NOT NULL',
	@ValidationMessage = 'Column required for schools',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'School_OperationalStatus',
	@RuleDscr = 'Column required for schools',
	@Condition = 'where School_OperationalStatus is NULL and SchoolIdentifierSEA is NOT NULL',
	@ValidationMessage = 'Column required for schools',
	@CreatedBy = 'Generate',
	@Enabled = 1    

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'SchoolOrganizationName',
	@RuleDscr = 'Column required for schools',
	@Condition = 'where SchoolOrganizationName is NULL and SchoolIdentifierSEA is NOT NULL',
	@ValidationMessage = 'Column required for schools',
	@CreatedBy = 'Generate',
	@Enabled = 1    

-- StateDetail -----------------------------------------------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'StateAbbreviationCode',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C029',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'SeaOrganizationIdentifierSea',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C029',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'SeasOrganizationName',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'RecordStartDateTime',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'SchoolYear',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'All',
	@StagingTableName = 'StateDetail',
	@StagingColumnName = 'RecordStartDateTime',
	@RuleDscr = 'RecordStartDateTime must be before RecordEndDateTime',
	@Condition = 'where RecordStartDateTime > isnull(RecordEndDateTime, getdate())',
	@ValidationMessage = 'RecordStartDateTime must be before RecordEndDateTime',
	@CreatedBy = 'Generate',
	@Enabled = 1

-- ProgramParticipationSpecialEducation -----------------------------------------------
exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C144, C175, C118, C032, C040, C141',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'IdeaIndicator',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C009',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'SpecialEducationExitReason',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'IDEAEducationalEnvironmentForSchoolAge',
	@RuleDscr = 'EducationalEnvironment Required',
	@Condition = 'select * from Staging.ProgramParticipationSpecialEducation 
		where (IDEAEducationalEnvironmentForSchoolAge is null or len(ltrim(rtrim(IDEAEducationalEnvironmentForSchoolAge))) =  0)
	and (IDEAEducationalEnvironmentForEarlyChildhood is null or len(ltrim(rtrim(IDEAEducationalEnvironmentForEarlyChildhood))) =  0)',
	@ValidationMessage = 'Either IdeaEducationalEnvironmentForSchoolAge or IdeaEducationalEnvironmentForEarlyChildhood must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C002, C005, C006, C007, C009, C032, C033, C040, C045, C086, C088, C089, C118, C143, C144, C175, C178, C179, C185, C188, C189',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'ProgramParticipationEndDate',
	@RuleDscr = 'If either ProgramParticipationEndDate or SpecialEducationExitReason is populated then both must be populated',
	@Condition = 'where (ProgramParticipationEndDate is not null and SpecialEducationExitReason is NULL) or (ProgramParticipationEndDate is null and SpecialEducationExitReason is not null) ',
	@ValidationMessage = 'If either ProgramParticipationEndDate or SpecialEducationExitReason is populated then both must be populated ',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C009',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'SpecialEducationExitReason',
	@RuleDscr = 'Exit Reason for ReachedMaximumAge can only apply to students that have reached maximum age according to the Toggle selection',
	@Condition = 'select ske.StudentIdentifierState, ske.birthdate,
				RDS.Get_Age(ske.Birthdate, IIF(sppse.ProgramParticipationEndDate < 
				(
				select 
				isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE''), 
				(
				select 
				dateadd(year, -1, isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1)))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE''),
				(
				select 
				isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE'')
				)) ExitAge, 
				ske.LeaIdentifierSeaAccountability, ske.SchoolIdentifierSea,
				sppse.ProgramParticipationBeginDate,
				sppse.ProgramParticipationEndDate, 
				sppse.SpecialEducationExitReason
				from Staging.K12Enrollment ske
				inner join Staging.ProgramParticipationSpecialEducation sppse 
				on ske.StudentIdentifierState = sppse.StudentIdentifierState
				where sppse.SpecialEducationExitReason = (
					select top 1 SpecialEducationExitReasonMap
					from rds.vwDimIdeaStatuses 
					where schoolyear = ske.SchoolYear
						and SpecialEducationExitReasonCode = ''ReachedMaximumAge''
					)
				and 
				RDS.Get_Age(ske.Birthdate, IIF(sppse.ProgramParticipationEndDate < 
				(
				select 
				isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE''), 
				(
				select 
				dateadd(year, -1, isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1)))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE''),
				(
				select 
				isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''CHDCTDTE'')
				)) < 
				(
				select isnull(tr.ResponseValue, 21)
				from app.togglequestions tq
				left join app.ToggleResponses tr
					on tq.ToggleQuestionId = tr.ToggleQuestionId
				where tq.EmapsQuestionAbbrv = ''DEFEXMAXAGE''
				) - 1	
				',
	@ValidationMessage = 'Invalid Age and Exit Reason Combination',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@FactTypeOrReportCode = 'C144, C175, C118, C032, C040, C141',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'LeaIdentifierSeaAccountability',
	@RuleDscr = 'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',
	@Condition = 'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',
	@ValidationMessage = 'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',
	@CreatedBy = 'Generate',
	@Enabled = 1


-- ProgramParticipationNorD -----------------------------------------------------------------










