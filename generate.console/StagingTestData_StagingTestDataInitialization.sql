-- Generate Test Data
-- StagingTestDataInitialization

-- Parameters --
-- TestDataType = staging
-- Seed = 1000
-- Quantity = 100000

-- Delete Staging Data 

TRUNCATE TABLE Staging.Assessment
TRUNCATE TABLE Staging.AssessmentResult
TRUNCATE TABLE staging.AccessibleEducationMaterialAssignment
TRUNCATE TABLE staging.AccessibleEducationMaterialProvider
TRUNCATE TABLE Staging.CharterSchoolAuthorizer
TRUNCATE TABLE Staging.CharterSchoolManagementOrganization
TRUNCATE TABLE Staging.Disability
TRUNCATE TABLE Staging.Discipline
TRUNCATE TABLE Staging.IndicatorStatusCustomType
TRUNCATE TABLE Staging.IdeaDisabilityType
TRUNCATE TABLE Staging.K12Enrollment
TRUNCATE TABLE Staging.K12Organization
TRUNCATE TABLE Staging.K12SchoolComprehensiveSupportIdentificationType
TRUNCATE TABLE Staging.K12StaffAssignment
TRUNCATE TABLE Staging.K12StudentCourseSection
TRUNCATE TABLE Staging.Migrant
TRUNCATE TABLE Staging.OrganizationAddress
TRUNCATE TABLE Staging.OrganizationCalendarSession
TRUNCATE TABLE Staging.OrganizationCustomSchoolIndicatorStatusType
TRUNCATE TABLE Staging.OrganizationFederalFunding
TRUNCATE TABLE Staging.OrganizationGradeOffered
TRUNCATE TABLE Staging.OrganizationPhone
TRUNCATE TABLE Staging.OrganizationProgramType
TRUNCATE TABLE Staging.OrganizationSchoolComprehensiveAndTargetedSupport
TRUNCATE TABLE Staging.OrganizationSchoolIndicatorStatus
TRUNCATE TABLE Staging.K12PersonRace
TRUNCATE TABLE Staging.PersonStatus
TRUNCATE TABLE Staging.ProgramParticipationCTE
TRUNCATE TABLE Staging.ProgramParticipationNorD
TRUNCATE TABLE Staging.ProgramParticipationSpecialEducation
TRUNCATE TABLE Staging.ProgramParticipationTitleI
TRUNCATE TABLE Staging.ProgramParticipationTitleIII
TRUNCATE TABLE Staging.PsInstitution
TRUNCATE TABLE Staging.PsStudentAcademicAward
TRUNCATE TABLE Staging.PsStudentAcademicRecord
TRUNCATE TABLE Staging.PsStudentEnrollment
TRUNCATE TABLE Staging.StateDefinedCustomIndicator
TRUNCATE TABLE Staging.StateDetail
TRUNCATE TABLE Staging.AccessibleEducationMaterialAssignment
TRUNCATE TABLE Staging.AccessibleEducationMaterialProvider
truncate table rds.BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes
truncate table rds.BridgeK12AccessibleEducationMaterialRaces
truncate table rds.BridgeLeaGradeLevels
truncate table rds.BridgeK12SchoolGradeLevels
truncate table rds.BridgeK12StudentAssessmentRaces
truncate table rds.BridgeK12ProgramParticipationRaces
truncate table rds.BridgeK12StudentCourseSectionK12Staff
truncate table rds.BridgeK12StudentCourseSectionRaces
truncate table rds.BridgeK12StudentEnrollmentRaces
truncate table rds.BridgeK12StudentDisciplineRaces
truncate table rds.BridgeK12StudentAssessmentAccommodations
delete from rds.FactK12StaffCounts
delete from rds.ReportEDFactsK12StudentAssessments
delete from rds.FactK12StudentAssessments
delete from rds.FactK12StudentAttendanceRates
delete from rds.ReportEDFactsK12StudentAttendance
delete from rds.FactK12StudentCounts
delete from rds.FactK12StudentDisciplines
delete from rds.FactK12AccessibleEducationMaterialAssignments
delete from rds.FactK12StudentEnrollments
delete from rds.ReportEDFactsOrganizationCounts
delete from rds.FactOrganizationCounts
delete from rds.ReportEDFactsOrganizationStatusCounts
delete from rds.FactOrganizationStatusCounts
delete from rds.dimseas
delete from rds.dimleas
delete from rds.DimK12Schools
delete from rds.DimCharterSchoolManagementOrganizations
delete from rds.DimCharterSchoolAuthorizers
delete from rds.DimPeople_Current
delete from rds.DimPeople
DBCC CHECKIDENT('rds.FactK12StaffCounts', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAssessments', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentAssessments', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentAttendanceRates', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAttendance', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentCounts', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentDisciplines', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12AccessibleEducationMaterialAssignments', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentEnrollments', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsOrganizationCounts', RESEED, 1);
DBCC CHECKIDENT('rds.FactOrganizationCounts', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsOrganizationStatusCounts', RESEED, 1);
DBCC CHECKIDENT('rds.FactOrganizationStatusCounts', RESEED, 1);
DBCC CHECKIDENT('rds.dimseas', RESEED, 1);
DBCC CHECKIDENT('rds.dimleas', RESEED, 1);
DBCC CHECKIDENT('rds.DimK12Schools', RESEED, 1);
DBCC CHECKIDENT('rds.DimCharterSchoolManagementOrganizations', RESEED, 1);
DBCC CHECKIDENT('rds.DimCharterSchoolAuthorizers', RESEED, 1);
DBCC CHECKIDENT('rds.DimPeople_Current', RESEED, 1);
DBCC CHECKIDENT('rds.DimPeople', RESEED, 1);
-- Repopulate Staging.SourceSystemReferenceData

TRUNCATE TABLE Staging.SourceSystemReferenceData

INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSpecialEducationStaffCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SpecialEducationStaffCategory'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefK12StaffClassification', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'K12StaffClassification'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefParaprofessionalQualification', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ParaprofessionalQualification'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSpecialEducationStaffCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SpecialEducationSupportServicesCategory'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSpecialEducationAgeGroupTaught', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SpecialEducationAgeGroupTaught'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTitleIProgramStaffCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleIProgramStaffCategory'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefCredentialType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'CredentialType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefHighSchoolDiplomaType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'HighSchoolDiplomaType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAcademicSubject', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentAcademicSubject'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentPurpose', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentPurpose'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentType'
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'RefAssessmentParticipationIndicator', NULL, '1', 'Participated'), (2025, 'RefAssessmentParticipationIndicator', NULL, '0', 'DidNotParticipate')
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefGradeLevel', '000100', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EntryGradeLevel'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefGradeLevel', '000126', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'GradeLevelWhenAssessed'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefGradeLevel', '000131', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'GradesOffered'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefGradeLevel', '001210', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ExitGradeLevel'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentReasonNotCompleting', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentRegistrationReasonNotCompleting'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentReasonNotTested', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ReasonNotTested'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefFirearmType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'FirearmType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefDisciplineReason', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'DisciplineReason'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefDisciplinaryActionTaken', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'DisciplinaryActionTaken'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIdeaInterimRemoval', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IDEAInterimRemoval'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIDEAInterimRemovalReason', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IDEAInterimRemovalReason'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefDisciplineMethodOfCwd', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'DisciplineMethodOfChildrenWithDisabilities'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefDisciplineMethodFirearms', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'DisciplineMethodForFirearmsIncidents'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIDEADisciplineMethodFirearm', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IDEADisciplineMethodForFirearmsIncidents'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIDEAEducationalEnvironmentEC', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IDEAEducationalEnvironmentForEarlyChildhood'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIDEAEducationalEnvironmentSchoolAge', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IDEAEducationalEnvironmentForSchoolAge'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSpecialEducationExitReason', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SpecialEducationExitReason'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefHomelessNighttimeResidence', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'HomelessPrimaryNighttimeResidence'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefLanguage', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ISO6393LanguageCode'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefMilitaryConnectedStudentIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'MilitaryConnectedStudentIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefDisabilityType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'PrimaryDisabilityType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefIdeaDisabilityType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'IdeaDisabilityType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefFoodServiceEligibility', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EligibilityStatusForSchoolFoodServicePrograms'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefRace', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'Race'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSex', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'Sex'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefOrganizationType', '001156', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'OrganizationType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefInstitutionTelephoneType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'InstitutionTelephoneNumberType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefOperationalStatus', '000174', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'LEAOperationalStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefOperationalStatus', '000533', CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SchoolOperationalStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefCharterSchoolAuthorizerType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'CharterSchoolAuthorizerType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefLeaType', NULL, CASE CedsOptionSetCode WHEN 'RegularNotInSupervisoryUnion' THEN '1' WHEN 'RegularInSupervisoryUnion' THEN '2' WHEN 'SupervisoryUnion' THEN '3' WHEN 'SpecializedPublicSchoolDistrict' THEN '9' WHEN 'ServiceAgency' THEN '4' WHEN 'StateOperatedAgency' THEN '5' WHEN 'FederalOperatedAgency' THEN '6' WHEN 'Other' THEN '8' WHEN 'IndependentCharterDistrict' THEN '7' END, CedsOptionSetCode FROM Ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'LocalEducationAgencyType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefK12LeaTitleISupportService', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleISupportServices'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTitleIInstructionalServices', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleIInstructionalServices'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTitleIProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleIProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefMepProjectType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'MigrantEducationProgramProjectType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSchoolType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'SchoolType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefOrganizationLocationType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AddressTypeForOrganization'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefState', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'StateAbbreviation'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefFederalProgramFundingAllocationType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'FederalProgramsFundingAllocationType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefGunFreeSchoolsActReportingStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'GunFreeSchoolsActReportingStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefReconstitutedStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ReconstitutedStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ProgressAchievingEnglishLanguageProficiencyIndicatorType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTitleISchoolStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleISchoolStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefComprehensiveSupport', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ComprehensiveSupportAndImprovementStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTargetedSupport', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TargetedSupportAndImprovementStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefSchoolDangerousStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'PersistentlyDangerousStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefMagnetSpecialProgram', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'MagnetOrSpecialProgramEmphasisSchool'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefVirtualSchoolStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'VirtualSchoolStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefNSLPStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'NationalSchoolLunchProgramStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentTypeAdministered', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentTypeAdministered'
--Add to AssessmentTypeAdminstered values not in the CEDS option set
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'ADVASMTWACC','ADVASMTWACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'ADVASMTWOACC','ADVASMTWOACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'IADAPLASMTWACC','IADAPLASMTWACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'IADAPLASMTWOACC','IADAPLASMTWOACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMT2WACC','HSREGASMT2WACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMT2WOACC','HSREGASMT2WOACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMT3WACC','HSREGASMT3WACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMT3WOACC','HSREGASMT3WOACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMTIWACC','HSREGASMTIWACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'HSREGASMTIWOACC','HSREGASMTIWOACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'LSNRHSASMTWACC','LSNRHSASMTWACC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefAssessmentTypeAdminstered' ,NULL,'LSNRHSASMTWOACC','LSNRHSASMTWOACC')
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefAssessmentTypeAdministeredToEnglishLearners', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'AssessmentTypeAdministeredToEnglishLearners'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefNeglectedProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefTitleIIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'TitleIIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefEnrollmentStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EnrollmentStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefEntryType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EntryType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefExitOrWithdrawalType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ExitOrWithdrawalType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefPsEnrollmentStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'PostsecondaryEnrollmentStatus'
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L1', 'L1'), (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L2', 'L2'), (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L3', 'L3'), (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L4', 'L4'), (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L5', 'L5'), (2025, 'AssessmentPerformanceLevel_Identifier', null, 'L6', 'L6')
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefUnexperiencedStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EDFactsTeacherInexperiencedStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefOutOfFieldStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'EDFactsTeacherOutOfFieldStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefContinuationOfServices', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'ContinuationOfServicesReason'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefMepServiceType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'MigrantEducationProgramServicesType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefMepEnrollmentType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM ceds.CedsOptionSetMapping where CedsElementTechnicalName = 'MigrantEducationProgramEnrollmentType'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2025, 'RefEdFactsTeacherInexperiencedStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsTeacherInexperiencedStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefTeachingCredentialType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TeachingCredentialType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefSpecialEducationTeacherQualificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'SpecialEducationTeacherQualificationStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefEdFactsCertificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsCertificationStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefTitleIIILanguageInstructionProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIILanguageInstructionProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefProficiencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ProficiencyStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefTitleIIIAccountability', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIIAccountabilityProgressStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefNeglectedOrDelinquentProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefAccessibleFormatIssuedIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatIssuedIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefAccessibleFormatRequiredIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatRequiredIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefAccessibleFormatType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefERSRuralUrbanContinuumCode', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ERSRuralUrbanContinuumCode'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefRuralResidencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'RuralResidencyStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefSection504Status', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'Section504Status'
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, 'Subpart1', 'Subpart1'), (2025, 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, 'Subpart2', 'Subpart2')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'RefAccessibleFormatIssuedIndicator', NULL, 'Yes', 'Yes'), (2025, 'RefAccessibleFormatIssuedIndicator', NULL, 'No', 'No')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'RefAccessibleFormatRequiredIndicator', NULL, 'Yes', 'Yes'), (2025, 'RefAccessibleFormatRequiredIndicator', NULL, 'No', 'No'), (2025, 'RefAccessibleFormatRequiredIndicator', NULL, 'Unknown', 'Unknown')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025, 'RefAccessibleFormatType', NULL, 'LEA', 'LEA'), (2025, 'RefAccessibleFormatType', NULL, 'K12School', 'K12School'), (2025, 'RefAccessibleFormatType', NULL, 'NationalOrStateService', 'NationalOrStateService'), (2025, 'RefAccessibleFormatType', NULL, 'NonProfitOrganization', 'NonProfitOrganization')
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefAssessmentAccommodationCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AssessmentAccommodationCategory'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2025, 'RefAccommodationType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccommodationType'
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefNeglectedProgramType' ,NULL,'OTHER','OTHER')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefNeglectedProgramType' ,NULL,'CMNTYDAYPRG','CMNTYDAYPRG')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefNeglectedProgramType' ,NULL,'SHELTERS','SHELTERS')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefNeglectedProgramType' ,NULL,'GRPHOMES','GRPHOMES')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefNeglectedProgramType' ,NULL,'RSDNTLTRTMTHOME','RSDNTLTRTMTHOME')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'ADLTCORR','ADLTCORR')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'GRPHOMES','GRPHOMES')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'CMNTYDAYPRG','CMNTYDAYPRG')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'JUVDET','JUVDET')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'JUVLNGTRMFAC','JUVLNGTRMFAC')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'RNCHWLDRNSCMPS','RNCHWLDRNSCMPS')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'RSDNTLTRTMTCTRS','RSDNTLTRTMTCTRS')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'SHELTERS','SHELTERS')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefDelinquentProgramType' ,NULL,'OTHER','OTHER')
--RefCharterLeaStatus
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'NA','NA')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'NOTCHR','NOTCHR')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'CHRTNOTLEA','CHRTNOTLEA')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'CHRTIDEA','CHRTIDEA')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'CHRTESEA','CHRTESEA')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefCharterLeaStatus' ,NULL,'CHRTIDEAESEA','CHRTIDEAESEA')
--RefComprehensiveAndTargetedSupport
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'CSI','CSI')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'TSI','TSI')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'CSIEXIT','CSIEXIT')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'TSIEXIT','TSIEXIT')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'NOTCSITSI','NOTCSITSI')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveAndTargetedSupport' ,NULL,'MISSING','MISSING')
--RefSubgroup
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'EconomicDisadvantage','EconomicDisadvantage')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'IDEA','IDEA')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'LEP','LEP')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'AmericanIndianorAlaskaNative','AmericanIndianorAlaskaNative')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'Asian','Asian')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'AsianPacificIslander','AsianPacificIslander')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'BlackorAfricanAmerican','BlackorAfricanAmerican')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'Filipino','Filipino')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'HispanicNotPurtoRican','HispanicNotPurtoRican')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'HispanicLatino','HispanicLatino')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'TwoorMoreRaces','TwoorMoreRaces')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'NativeHawaiianorOtherPacificIslander','NativeHawaiianorOtherPacificIslander')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'PuertoRican','PuertoRican')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'White','White')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefSubgroup' ,NULL,'UnderservedRaceEthnicity','UnderservedRaceEthnicity')
--RefComprehensiveSupportReasonApplicability
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveSupportReasonApplicability' ,NULL,'ReasonApplies','ReasonApplies')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefComprehensiveSupportReasonApplicability' ,NULL,'ReasonDoesNotApply','ReasonDoesNotApply')
--RefEmergencyOrProvisionalCredentialStatus
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefEmergencyOrProvisionalCredentialStatus' ,NULL,'TCHWEMRPRVCRD','TCHWEMRPRVCRD')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2025,'RefEmergencyOrProvisionalCredentialStatus' ,NULL,'TCHWOEMRPRVCRD','TCHWOEMRPRVCRD')
