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
delete from rds.FactK12StaffCounts
delete from rds.ReportEDFactsK12StudentAssessments
delete from rds.FactK12StudentAssessments
delete from rds.FactK12StudentAttendanceRates
delete from rds.ReportEDFactsK12StudentAttendance
delete from rds.FactK12StudentCounts
delete from rds.FactK12StudentDisciplines
delete from rds.FactK12AccessibleEducationMaterialAssignments
delete from rds.DimPeople
DBCC CHECKIDENT('rds.FactK12StaffCounts', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAssessments', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentAssessments', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentAttendanceRates', RESEED, 1);
DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAttendance', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentCounts', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12StudentDisciplines', RESEED, 1);
DBCC CHECKIDENT('rds.FactK12AccessibleEducationMaterialAssignments', RESEED, 1);
DBCC CHECKIDENT('rds.DimPeople', RESEED, 1);
-- Repopulate Staging.SourceSystemReferenceData

TRUNCATE TABLE Staging.SourceSystemReferenceData

INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefK12StaffClassification', NULL, Code, Code FROM RefK12StaffClassification
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefParaprofessionalQualification', NULL, Code, Code FROM RefParaprofessionalQualification
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSpecialEducationStaffCategory', NULL, Code, Code FROM RefSpecialEducationStaffCategory
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSpecialEducationAgeGroupTaught', NULL, Code, Code FROM RefSpecialEducationAgeGroupTaught
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTitleIProgramStaffCategory', NULL, Code, Code FROM RefTitleIProgramStaffCategory
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefCredentialType', NULL, Code, Code FROM RefCredentialType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefHighSchoolDiplomaType', NULL, Code, Code FROM RefHighSchoolDiplomaType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAcademicSubject', NULL, Code, Code FROM RefAcademicSubject
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentPurpose', NULL, Code, Code FROM RefAssessmentPurpose
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentType', NULL, Code, Code FROM RefAssessmentType
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'RefAssessmentParticipationIndicator', NULL, '1', 'Participated'), (2024, 'RefAssessmentParticipationIndicator', NULL, '0', 'DidNotParticipate')
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefGradeLevel', '000100', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000100'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefGradeLevel', '000126', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000126'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefGradeLevel', '000131', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000131'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefGradeLevel', '001210', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '001210'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentReasonNotCompleting', NULL, Code, Code FROM RefAssessmentReasonNotCompleting
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentReasonNotTested', NULL, Code, Code FROM RefAssessmentReasonNotTested
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefFirearmType', NULL, Code, Code FROM RefFirearmType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefDisciplineReason', NULL, Code, Code FROM RefDisciplineReason
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefDisciplinaryActionTaken', NULL, Code, Code FROM RefDisciplinaryActionTaken
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIdeaInterimRemoval', NULL, Code, Code FROM RefIdeaInterimRemoval
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIDEAInterimRemovalReason', NULL, Code, Code FROM RefIDEAInterimRemovalReason
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefDisciplineMethodOfCwd', NULL, Code, Code FROM RefDisciplineMethodOfCwd
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefDisciplineMethodFirearms', NULL, Code, Code FROM RefDisciplineMethodFirearms
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIDEADisciplineMethodFirearm', NULL, Code, Code FROM RefIDEADisciplineMethodFirearm
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIDEAEducationalEnvironmentEC', NULL, Code, Code FROM RefIDEAEducationalEnvironmentEC
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIDEAEducationalEnvironmentSchoolAge', NULL, Code, Code FROM RefIDEAEducationalEnvironmentSchoolAge
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSpecialEducationExitReason', NULL, Code, Code FROM RefSpecialEducationExitReason
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefHomelessNighttimeResidence', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'HomelessPrimaryNighttimeResidence'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefLanguage', NULL, Code, Code FROM RefLanguage
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefMilitaryConnectedStudentIndicator', NULL, Code, Code FROM RefMilitaryConnectedStudentIndicator
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefDisabilityType', NULL, Code, Code FROM RefDisabilityType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefIdeaDisabilityType', NULL, Code, Code FROM RefIdeaDisabilityType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefFoodServiceEligibility', NULL, Code, Code FROM RefFoodServiceEligibility
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefRace', NULL, Code, Code FROM RefRace
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSex', NULL, Code, Code FROM RefSex
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOrganizationType', '001156', o.Code, o.Code FROM RefOrganizationType o JOIN RefOrganizationElementType t ON o.RefOrganizationElementTypeId = t.RefOrganizationElementTypeId WHERE t.Code = '001156'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefInstitutionTelephoneType', NULL, Code, Code FROM RefInstitutionTelephoneType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOperationalStatus', '000174', os.Code, os.Code FROM RefOperationalStatus os JOIN RefOperationalStatusType ost on os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId WHERE ost.Code = '000174'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOperationalStatus', '000533', os.Code, os.Code FROM RefOperationalStatus os JOIN RefOperationalStatusType ost on os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId WHERE ost.Code = '000533'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefCharterSchoolAuthorizerType', NULL, Code, Code FROM RefCharterSchoolAuthorizerType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefLeaType', NULL, CASE Code WHEN 'RegularNotInSupervisoryUnion' THEN '1' WHEN 'RegularInSupervisoryUnion' THEN '2' WHEN 'SupervisoryUnion' THEN '3' WHEN 'SpecializedPublicSchoolDistrict' THEN '9' WHEN 'ServiceAgency' THEN '4' WHEN 'StateOperatedAgency' THEN '5' WHEN 'FederalOperatedAgency' THEN '6' WHEN 'Other' THEN '8' WHEN 'IndependentCharterDistrict' THEN '7' END, Code FROM RefLeaType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefProgramType', NULL, Code, Code FROM RefProgramType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefCharterLeaStatus', NULL, Code, Code FROM RefCharterLeaStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefK12LeaTitleISupportService', NULL, Code, Code FROM RefK12LeaTitleISupportService
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTitleIInstructionalServices', NULL, Code, Code FROM RefTitleIInstructionalServices
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTitleIProgramType', NULL, Code, Code FROM RefTitleIProgramType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefMepProjectType', NULL, Code, Code FROM RefMepProjectType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSchoolType', NULL, Code, Code FROM RefSchoolType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOrganizationLocationType', NULL, Code, Code FROM RefOrganizationLocationType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefState', NULL, Code, Code FROM RefState
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOrganizationIdentificationSystem', '001156', ois.Code, ois.Code FROM RefOrganizationIdentificationSystem ois JOIN RefOrganizationIdentifierType oit ON ois.RefOrganizationIdentifierTypeId = oit.RefOrganizationIdentifierTypeId where oit.Code = '001156'
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefFederalProgramFundingAllocationType', NULL, Code, Code FROM RefFederalProgramFundingAllocationType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefGunFreeSchoolsActReportingStatus', NULL, Code, Code FROM RefGunFreeSchoolsActReportingStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefReconstitutedStatus', NULL, Code, Code FROM RefReconstitutedStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus', NULL, Code, Code FROM RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTitleISchoolStatus', NULL, Code, Code FROM RefTitleISchoolStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefComprehensiveAndTargetedSupport', NULL, Code, Code FROM RefComprehensiveAndTargetedSupport
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefComprehensiveSupport', NULL, Code, Code FROM RefComprehensiveSupport
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTargetedSupport', NULL, Code, Code FROM RefTargetedSupport
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSchoolDangerousStatus', NULL, Code, Code FROM RefSchoolDangerousStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefMagnetSpecialProgram', NULL, Code, Code FROM RefMagnetSpecialProgram
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefVirtualSchoolStatus', NULL, Code, Code FROM RefVirtualSchoolStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefNSLPStatus', NULL, Code, Code FROM RefNSLPStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentTypeAdministered', NULL, Code, Code FROM RefAssessmentTypeChildrenWithDisabilities
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefAssessmentTypeAdministeredToEnglishLearners', NULL, Code, Code FROM RefAssessmentTypeAdministeredToEnglishLearners
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefNeglectedProgramType', NULL, Code, Code FROM RefNeglectedProgramType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefTitleIIndicator', NULL, Code, Code FROM RefTitleIIndicator
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefEnrollmentStatus', NULL, Code, Code FROM RefEnrollmentStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefEntryType', NULL, Code, Code FROM RefEntryType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefExitOrWithdrawalType', NULL, Code, Code FROM RefExitOrWithdrawalType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefPsEnrollmentStatus', NULL, Code, Code FROM RefPsEnrollmentStatus
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L1', 'L1'), (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L2', 'L2'), (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L3', 'L3'), (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L4', 'L4'), (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L5', 'L5'), (2024, 'AssessmentPerformanceLevel_Identifier', null, 'L6', 'L6')
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefSubgroup', NULL, Code, Code FROM RefSubgroup
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefComprehensiveSupportReasonApplicability', NULL, Code, Code FROM RefComprehensiveSupportReasonApplicability
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefUnexperiencedStatus', NULL, Code, Code FROM RefUnexperiencedStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefOutOfFieldStatus', NULL, Code, Code FROM RefOutOfFieldStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefEmergencyOrProvisionalCredentialStatus', NULL, Code, Code FROM RefEmergencyOrProvisionalCredentialStatus
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefContinuationOfServices', NULL, Code, Code FROM RefContinuationOfServices
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefMepServiceType', NULL, Code, Code FROM RefMepServiceType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefMepEnrollmentType', NULL, Code, Code FROM RefMepEnrollmentType
INSERT INTO Staging.SourceSystemReferenceData SELECT 2024, 'RefEdFactsTeacherInexperiencedStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsTeacherInexperiencedStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefTeachingCredentialType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TeachingCredentialType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefSpecialEducationTeacherQualificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'SpecialEducationTeacherQualificationStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefEdFactsCertificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsCertificationStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefTitleIIILanguageInstructionProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIILanguageInstructionProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefProficiencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ProficiencyStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefTitleIIIAccountability', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIIAccountabilityProgressStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefNeglectedOrDelinquentProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefAccessibleFormatIssuedIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatIssuedIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefAccessibleFormatRequiredIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatRequiredIndicator'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefAccessibleFormatType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatType'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefERSRuralUrbanContinuumCode', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ERSRuralUrbanContinuumCode'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefRuralResidencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'RuralResidencyStatus'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefSection504Status', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'Section504Status'
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, '1', '1'), (2024, 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, '2', '2')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'RefAccessibleFormatIssuedIndicator', NULL, 'Yes', 'Yes'), (2024, 'RefAccessibleFormatIssuedIndicator', NULL, 'No', 'No')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'RefAccessibleFormatRequiredIndicator', NULL, 'Yes', 'Yes'), (2024, 'RefAccessibleFormatRequiredIndicator', NULL, 'No', 'No'), (2024, 'RefAccessibleFormatRequiredIndicator', NULL, 'Unknown', 'Unknown')
INSERT INTO Staging.SourceSystemReferenceData VALUES (2024, 'RefAccessibleFormatType', NULL, 'LEA', 'LEA'), (2024, 'RefAccessibleFormatType', NULL, 'K12School', 'K12School'), (2024, 'RefAccessibleFormatType', NULL, 'NationalOrStateService', 'NationalOrStateService'), (2024, 'RefAccessibleFormatType', NULL, 'NonProfitOrganization', 'NonProfitOrganization')
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefAssessmentAccommodationCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AssessmentAccommodationCategory'
INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT 2024, 'RefAccommodationType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccommodationType'

