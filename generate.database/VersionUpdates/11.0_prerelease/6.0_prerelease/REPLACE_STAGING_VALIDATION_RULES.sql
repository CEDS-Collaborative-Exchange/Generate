

/**********************************************************************************************
REPLACE STAGING VALIDATION RULES
May 26, 2023

This script replaces all Generate staging validation rules in Staging.StagingValidationRules 
with the rules defined below.  Note that only rules where the "CreatedBy" = Generate will be 
deleted and replaced.  This allows States to define their own rules and set the "CreatedBy"
column to their own unique values to retain their validation rules during Generate version updates.

This script will be rolled into each Generate version release and updated as needed so that all
rules will be reviewed/tested/confirmed/refreshed with each release.

Each rule mus be defined in parenthesis () followed by a comma, except the last rule in this script
must not have a comma.  This format allows the INSERT...VALUES clause to work.

***********************************************************************************************/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[StagingValidationRules]') AND type in (N'U'))
BEGIN

delete from [Staging].[StagingValidationRules] where CreatedBy = 'Generate'


INSERT [Staging].[StagingValidationRules] VALUES 
-- PLACE ALL VALIDATION RULES BELOW THIS LINE --
-- RULES ARE ORGANIZED BY PRIMARY STAGING TABLE FOR WHICH THE RULE APPLIES

-- Staging.StateDetail -------------------------------------------------------------------------
(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Table cannot be empty', N'StateDetail', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,('Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership',
	'SchoolYear cannot be NULL',
	'StateDetail',
	'SchoolYear',
	'Null Value',
	NULL,
	NULL,
	NULL,
	'SchoolYear is missing',
	'Critical', 'Generate')

-- Staging.K12Organization -----------------------------------------------------------------------
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'K12Organization cannot be empty', N'K12Organization', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'LeaIdentifierSea cannot be NULL', N'K12Organization', N'LeaIdentifierSea', N'Null Value', NULL, NULL, NULL, NULL, 'Warning', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'LEA_IsReportedFederally cannot be NULL', N'K12Organization', N'LEA_IsReportedFederally',N'Null Value',NULL,NULL,NULL,NULL,N'Error', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'RecordStartDateTime cannot be NULL', N'K12Organization', N'School_RecordStartDateTime',N'Null Value',NULL,NULL,NULL,NULL,N'Error', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'School_IsReportedFederally cannot be NULL', N'K12Organization', N'School_IsReportedFederally',N'Null Value',NULL,NULL,NULL,NULL,N'Error', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'RecordStartDateTime cannot be NULL', N'K12Organization', N'LEA_RecordStartDateTime',N'Null Value',NULL,NULL,NULL,NULL,N'Error', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'SchoolYear cannot be NULL', N'K12Organization', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'LEA must have valid Operational Status Effective Date', N'K12Organization', N'LEA_OperationalStatusEffectiveDate', N'Bad Value', NULL, NULL, N'where LEA_OperationalStatusEffectiveDate not between ''6/30/'' + convert(varchar, SchoolYear-1) and ''7/1/'' + convert(varchar, SchoolYear)', N'Operational Status Effective Date is not between dates of school year', 'Warning', 'Generate')

,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'LEA_OperationalStatus options', N'K12Organization', N'LEA_OperationalStatus', N'Option Not Mapped', N'RefOperationalStatus', N'000174', NULL, NULL, 'Warning', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'LEA_Type options', N'K12Organization', N'LEA_Type', N'Option Not Mapped', N'RefLEAType', NULL, NULL, NULL, 'Warning', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'School_OperationalStatus options', N'K12Organization', N'School_OperationalStatus', N'Option Not Mapped', N'RefOperationalStatus', N'000533', NULL, NULL, 'Warning', 'Generate')
,(N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', N'School_Type options', N'K12Organization', N'School_Type', N'Option Not Mapped', N'RefSchoolType', NULL, NULL, NULL, 'Warning', 'Generate')


,('Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', 'LEAs with conflicting values in some columns', 'K12Organization', NULL, 'Bad Value', NULL, NULL, 
'where LEA_Identifier_State in (
select LEA_Identifier_State from (
		SELECT DISTINCT	
			LEA_Name
			, LEA_Identifier_NCES 
			, LEA_Identifier_State 
			, Prior_LEA_Identifier_State 
			, LEA_IsReportedFederally AS ReportedFederally
			, LEA_CharterLeaStatus
			, LEA_CharterSchoolIndicator
		FROM Staging.K12Organization) A
group by LEA_Identifier_State
having count(*) > 1)
',
'An LEA with different values in some columns will cause the RDS Migration to fail',
'Critical', 'Generate')


-- Staging.OrganizationAddress -------------------------------------------------------------------------
,(N'Directory', N'Table cannot be empty', N'OrganizationAddress', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error', 'Generate')


-- Staging.OrganizationPhone -------------------------------------------------------------------------
,(N'C029', N'Table cannot be empty', N'OrganizationPhone', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error', 'Generate')

,('Directory',
'Conflicting Organization Phones', 
'OrganizationPhone', NULL, 'Bad Value', NULL, NULL, 
'where OrganizationIdentifier in (
select OrganizationIdentifier from (
		SELECT	
			OrganizationIdentifier
			, OrganizationType
			, InstitutionTelephoneNumberType 
			, RecordStartDateTime
		FROM Staging.OrganizationPhone) A
group by OrganizationIdentifier
having count(*) > 1
)
',
'An organization with multiple phone numbers of the same type will cause a merge error in the RDS migration',
'Critical', 'Generate')

-- Staging.OrganizationFederalFunding -------------------------------------------------------------------------
,(N'C029', N'Table cannot be empty', N'OrganizationFederalFunding', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error', 'Generate')


-- Staging.OrganizationGradeOffered -------------------------------------------------------------------------
,(N'C039', N'Table cannot be empty', N'OrganizationGradeOffered', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error', 'Generate')


-- Staging.OrganizationProgramType -------------------------------------------------------------------------
,(N'Directory', N'Table cannot be empty', N'OrganizationProgramType', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error', 'Generate')


-- Staging.CharterSchoolAuthorizer -------------------------------------------------------------------------
,(N'C190', N'Table cannot be empty', N'CharterSchoolAuthorizer', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')



-- Staging.K12Enrollment -------------------------------------------------------------------------
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'Table cannot be empty', N'K12Enrollment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'StudentIdentifierState cannot be NULL', N'K12Enrollment', N'StudentIdentifierState', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline','Birthdate cannot be NULL','K12Enrollment','Birthdate','Null Value',NULL,NULL,NULL,NULL,'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'LEAIdentifierSeaAccountability cannot be NULL', N'K12Enrollment', N'LEAIdentifierSeaAccountability', N'Null Value', NULL, NULL, NULL, NULL, 'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'GradeLevel cannot be NULL', N'K12Enrollment', N'GradeLevel',N'Null Value',NULL,NULL,NULL,NULL,N'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'EnrollmentEntryDate cannot be NULL', N'K12Enrollment', N'EnrollmentEntryDate', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'HispanicLatinoEthnicity cannot be NULL', N'K12Enrollment', N'HispanicLatinoEthnicity', N'Null Value', NULL, NULL, NULL, NULL, 'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'SchoolYear cannot be NULL', N'K12Enrollment', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'SchoolYear', N'Bad Value', NULL, NULL, N'where EnrollmentEntryDate > cast(''6/30/'' + convert(varchar, SchoolYear) as date)', N'Enrollment Entry Date does not match the School Year', 'Warning', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'GradeLevel options', N'K12Enrollment', N'GradeLevel', N'Option Not Mapped', N'RefGradeLevel', N'000100', NULL, NULL, 'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'Sex options', N'K12Enrollment', N'Sex', N'Option Not Mapped', N'RefSex', NULL, NULL, NULL, 'Warning', 'Generate')


-- Staging.K12PersonRace -------------------------------------------------------------------------
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'Table cannot be empty', N'K12PersonRace', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'StudentIdentifierState cannot be NULL', N'K12PersonRace', N'StudentIdentifierState', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership',N'StudentIdentifierState cannot be NULL',N'K12PersonRace',N'StudentIdentifierState',N'Null Value',NULL,NULL,NULL,N'StudentIdentifierState is required',N'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership',N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',N'K12PersonRace',N'LeaIdentifierSeaAccountability',N'Bad Value',NULL,NULL,N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',N'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'SchoolYear cannot be NULL', N'K12PersonRace', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'RaceType options', N'K12PersonRace', N'RaceType', N'Option Not Mapped', N'RefRace', NULL, NULL, NULL, 'Warning', 'Generate')


-- Staging.PersonStatus -------------------------------------------------------------------------
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'Table cannot be empty', N'PersonStatus', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'StudentIdentifierState cannot be NULL', N'PersonStatus', N'StudentIdentifierState', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership',N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',N'PersonStatus',N'LeaIdentifierSeaAccountability',N'Bad Value',NULL,NULL,N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',N'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'English Learners must have a Start Date',N'PersonStatus',N'EnglishLearnerStatus',N'Bad Value',NULL,NULL,N'where isnull(EnglishLearnerStatus,0) = 1 and EnglishLearner_StatusStartDate is null',N'The EnglishLearnerStatus is 1 but EnglishLearner_StatusStartDate is NULL','Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'IDEA students must have an IDEA Start Date', N'PersonStatus', N'IDEAIndicator', N'Bad Value', NULL, NULL, N'where isnull(IDEAIndicator,0) = 0 and PrimaryDisabilityType is not null', N'Value is 0 or NULL but student has a PrimaryDisabilityType', 'Warning', 'Generate')
,('c033','EligibilityStatusForSchoolFoodServicePrograms cannot be NULL','PersonStatus','EligibilityStatusForSchoolFoodServicePrograms','Null Value',NULL,NULL,NULL,NULL,'Warning', 'Generate')
,('c033','NationalSchoolLunchProgramDirectCertificationIndicator cannot be NULL','PersonStatus','NationalSchoolLunchProgramDirectCertificationIndicator','Null Value',NULL,NULL,NULL,NULL,'Warning', 'Generate')

,('ChildCount, Exiting, Discipline, Assessment, Membership',
'PersonStatus records must be associated with an LEA and/or School in K12Enrollment', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps 
left join Staging.K12Organization sko
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
where sko.LEA_Identifier_State is null and sko.School_Identifier_State is null
',
'One or more records in PersonStatus are associated with an LEA/School that does not exist in K12Enrollment',
'Warning', 'Generate')

,('ChildCount, Exiting, Discipline, Assessment, Membership',
'PersonStatus records must have a student record in K12Enrollment', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps
left join Staging.K12Enrollment ske
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
	and sps.Student_Identifier_State = ske.Student_Identifier_State
where ske.Student_Identifier_State is null
',
'One or more records in PersonStatus do not have a student record in K12Enrollment',
'Warning', 'Generate')

-- Staging.ProgramParticipationSpecialEducation -------------------------------------------------------------------------
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'Table cannot be empty', N'ProgramParticipationSpecialEducation', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,(N'C002',N'Verify that one of the Education Environments is populated', N'ProgramParticipationSpecialEducation',N'IDEAEducationalEnvironmentForSchoolAge',N'Null Value',NULL,NULL,NULL,NULL,N'Warning', 'Generate')
,(N'C089',N'Verify that one of the Education Environments is populated', N'ProgramParticipationSpecialEducation',N'IDEAEducationalEnvironmentForEarlyChildhood',N'Null Value',NULL,NULL,NULL,NULL,N'Warning', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment', N'IDEAIndicator cannot be NULL', N'PersonStatus', N'IDEAIndicator', N'Null Value', NULL, NULL, NULL, NULL, 'Warning', 'Generate')

,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'StudentIdentifierState cannot be NULL', N'ProgramParticipationSpecialEducation', N'StudentIdentifierState', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership',N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated',N'ProgramParticipationSpecialEducation',N'LeaIdentifierSeaAccountability',N'Bad Value',NULL,NULL,N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ',N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated',N'Error', 'Generate')
,(N'ChildCount, Exiting, Discipline, Assessment, Membership', N'ProgramParticipationBeginDate cannot be NULL', N'ProgramParticipationSpecialEducation', N'ProgramParticipationBeginDate', N'Null Value', NULL, NULL, NULL, NULL, 'Error', 'Generate')


-- Staging.Assessment -------------------------------------------------------------------------
,(N'Assessment', N'Table cannot be empty', N'Assessment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')


-- Staging.AssessmentResult -------------------------------------------------------------------------
,(N'Assessment', N'Table cannot be empty', N'AssessmentResult', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')



-- Staging.Discipline -------------------------------------------------------------------------
,(N'Discipline', N'Table cannot be empty', N'Discipline', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')

,('c086','Column cannot be NULL','Discipline','IDEADisciplineMethodFirearm','Null Value',NULL,NULL,NULL,NULL,'Warning', 'Generate')
,('c086','Column options','Discipline','IDEADisciplineMethodFirearm','Option Not Mapped','RefIDEADisciplineMethodFirearm',NULL,NULL,NULL,'Warning', 'Generate')
,('c086','Column cannot be NULL','Discipline','FirearmType','Null Value',NULL,NULL,NULL,NULL,'Warning', 'Generate')
,('c086','Column options','Discipline','FirearmType','Option Not Mapped','RefFirearmType',NULL,NULL,NULL,'Warning', 'Generate')


-- Staging.K12StaffAssignment -------------------------------------------------------------------------
,(N'Personnel', N'Table cannot be empty', N'K12StaffAssignment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical', 'Generate')



END

