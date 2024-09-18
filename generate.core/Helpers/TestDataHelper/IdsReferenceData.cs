using generate.core.Helpers.ReferenceData;
using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper
{
    public class IdsReferenceData
    {
        #region Data
        public List<RefK12responsibilityType> RefK12responsibilityTypes { get; private set; }
        public List<RefSex> RefSexes { get; private set; }
        public List<RefPersonStatusType> RefPersonStatusTypes { get; private set; }
        public List<RefDisabilityType> RefDisabilityTypes { get; private set; }
        public List<RefHomelessNighttimeResidence> RefHomelessNighttimeResidences { get; private set; }
        public List<RefLanguage> RefLanguages { get; private set; }
        public List<RefLanguageUseType> RefLanguageUseTypes { get; private set; }
        public List<RefRace> RefRaces { get; private set; }

        public List<RefPersonalInformationVerification> RefPersonalInformationVerifications { get; private set; }
        public List<RefPersonIdentifierType> RefPersonIdentifierTypes { get; private set; }
        public List<RefPersonIdentificationSystem> RefPersonIdentificationSystems { get; private set; }
        public List<RefProgramExitReason> RefProgramExitReasons { get; private set; }
        public List<RefIdeaeducationalEnvironmentEc> RefIdeaeducationalEnvironmentEcs { get; private set; }


        public List<RefSpecialEducationExitReason> RefSpecialEducationExitReasons { get; private set; }
        public List<RefMepServiceType> RefMepServiceTypes { get; private set; }
        public List<RefCteNonTraditionalGenderStatus> RefCteNonTraditionalGenderStatuses { get; private set; }
        public List<RefEmployedWhileEnrolled> RefEmployedWhileEnrolleds { get; private set; }
        public List<RefEmployedAfterExit> RefEmployedAfterExits { get; private set; }
        public List<RefNeglectedProgramType> RefNeglectedProgramTypes { get; private set; }
        public List<RefAcademicCareerAndTechnicalOutcomesInProgram> RefAcademicCareerAndTechnicalOutcomesInPrograms { get; private set; }
        public List<RefAcademicCareerAndTechnicalOutcomesExitedProgram> RefAcademicCareerAndTechnicalOutcomesExitedPrograms { get; private set; }
        public List<RefTitleIiiaccountability> RefTitleIiiaccountabilities { get; private set; }
        public List<RefWfProgramParticipation> RefWfProgramParticipations { get; private set; }

        public List<RefDisciplinaryActionTaken> RefDisciplinaryActionTakens { get; private set; }
        public List<RefDisciplineReason> RefDisciplineReasons { get; private set; }
        public List<RefDisciplineLengthDifferenceReason> RefDisciplineLengthDifferenceReasons { get; private set; }
        public List<RefIdeainterimRemoval> RefIdeainterimRemovals { get; private set; }
        public List<RefIdeainterimRemovalReason> RefIdeainterimRemovalReasons { get; private set; }
        public List<RefDisciplineMethodOfCwd> RefDisciplineMethodOfCwds { get; private set; }
        public List<RefWeaponType> RefWeaponTypes { get; private set; }
        public List<RefDisciplineMethodFirearms> RefDisciplineMethodFirearms { get; private set; }
        public List<RefIdeadisciplineMethodFirearm> RefIdeadisciplineMethodFirearms { get; private set; }
        public List<RefIncidentBehavior> RefIncidentBehaviors { get; private set; }
        public List<RefFirearmType> RefFirearmTypes { get; private set; }
        public List<RefIdeaeducationalEnvironmentSchoolAge> RefIdeaeducationalEnvironmentSchoolAges { get; private set; }
        public List<RefProfessionalTechnicalCredentialType> RefProfessionalTechnicalCredentialTypes { get; private set; }

        public List<RefGradeLevelType> RefGradeLevelTypes { get; private set; }
        public List<RefGradeLevel> RefGradeLevels { get; private set; }

        public List<RefFoodServiceEligibility> RefFoodServiceEligibilities { get; private set; }

        public List<RefHighSchoolDiplomaType> RefHighSchoolDiplomaTypes { get; private set; }
        public List<RefPsEnrollmentAction> RefPsEnrollmentActions { get; private set; }
        public List<RefProgressLevel> RefProgressLevels { get; private set; }

        public List<AssessmentPerformanceLevel> PerformanceLevels { get; private set; }
        public List<RefScoreMetricType> RefScoreMetricTypes { get; private set; }
        public List<RefAssessmentReasonNotCompleting> RefAssessmentReasonNotCompletings { get; private set; }
        public List<RefAssessmentReasonNotTested> RefAssessmentReasonNotTested { get; private set; }
        public List<RefAssessmentParticipationIndicator> RefAssessmentParticipationIndicators { get; private set; }

        public List<RefParticipationType> RefParticipationTypes { get; private set; }

        public List<RefOrganizationType> RefOrganizationTypes { get; private set; }

        public List<RefOrganizationElementType> RefOrganizationElementTypes { get; private set; }
        public List<RefSchoolType> RefSchoolTypes { get; private set; }
        public List<RefOrganizationLocationType> RefOrganizationLocationTypes { get; private set; }
        public List<RefOrganizationIdentifierType> RefOrganizationIdentifierTypes { get; private set; }
        public List<RefOrganizationIdentificationSystem> RefOrganizationIdentificationSystems { get; private set; }
        public List<RefSessionType> RefSessionTypes { get; private set; }

        public List<RefReapAlternativeFundingStatus> RefReapAlternativeFundingStatuses { get; private set; }
        public List<RefFederalProgramFundingAllocationType> RefFederalProgramFundingAllocationTypes { get; private set; }

        public List<RefGunFreeSchoolsActReportingStatus> RefGunFreeSchoolsActReportingStatuses { get; private set; }


        public List<RefHighSchoolGraduationRateIndicator> RefHighSchoolGraduationRateIndicators { get; private set; }
        public List<RefReconstitutedStatus> RefReconstitutedStatuses { get; private set; }
        public List<RefCteGraduationRateInclusion> RefCteGraduationRateInclusions { get; private set; }
        public List<RefAmaoAttainmentStatus> RefAmaoAttainmentStatuses { get; private set; }

        public List<RefStatePovertyDesignation> RefStatePovertyDesignations { get; private set; }

        public List<RefSchoolImprovementStatus> RefSchoolImprovementStatuses { get; private set; }
        public List<RefSchoolImprovementFunds> RefSchoolImprovementFunds { get; private set; }

        public List<RefOrganizationIndicator> RefOrganizationIndicators { get; private set; }


        
        public List<RefTitleIschoolStatus> RefTitleIschoolStatuses { get; private set; }
        public List<RefVirtualSchoolStatus> RefVirtualSchoolStatuses { get; private set; }
        public List<RefMagnetSpecialProgram> RefMagnetSpecialPrograms { get; private set; }
        public List<RefNSLPStatus> RefNSLPStatuses { get; private set; }
        public List<RefSchoolDangerousStatus> RefSchoolDangerousStatuses { get; private set; }
        public List<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatuses { get; private set; }
        public List<RefComprehensiveAndTargetedSupport> RefComprehensiveAndTargetedSupports { get; private set; }
        public List<RefComprehensiveSupport> RefComprehensiveSupports { get; private set; }
        public List<RefTargetedSupport> RefTargetedSupports { get; private set; }
        public List<RefComprehensiveSupportImprovement> RefComprehensiveSupportImprovements { get; private set; }
        public List<RefTargetedSupportImprovement> RefTargetedSupportImprovements { get; private set; }
        public List<RefAdditionalTargetedSupport> RefAdditionalTargetedSupportImprovements { get; private set; }        
        public List<RefIndicatorStatusType> RefIndicatorStatusTypes { get; private set; }
        public List<RefIndicatorStatusSubgroupType> RefIndicatorStatusSubgroupTypes { get; private set; }
        public List<RefIndicatorStateDefinedStatus> RefIndicatorStateDefinedStatuses { get; private set; }
        public List<string> MajorRacialEthnicGroups { get; private set; }
        public List<string> IndicatorStatuses { get; private set; }
        public List<RefIndicatorStatusCustomType> RefIndicatorStatusCustomTypes { get; private set; }

        public List<RefAcademicSubject> RefAcademicSubjects { get; private set; }
        public List<AssessmentPerformanceLevel> AssessmentPerformanceLevels { get; private set; }
        public List<RefAssessmentTypeChildrenWithDisabilities> RefAssessmentTypeChildrenWithDisabilities { get; private set; }
        public List<RefAssessmentTypeAdministeredToEnglishLearners> RefAssessmentTypeAdministeredToEnglishLearners { get; private set; }

        public List<RefState> RefStates { get; private set; }
        public List<RefStateAnsicode> RefStateAnsicodes { get; private set; }

        public List<RefLeaType> RefLeaTypes { get; private set; }

        public List<RefK12leaTitleIsupportService> RefK12leaTitleIsupportServices { get; private set; }


        public List<RefTitleIinstructionalServices> RefTitleIinstructionalServices { get; private set; }
        public List<RefTitleIprogramType> RefTitleIprogramTypes { get; private set; }
        public List<RefMepProjectType> RefMepProjectTypes { get; private set; }

        public List<RefTitleIiilanguageInstructionProgramType> RefTitleIiilanguageInstructionProgramTypes { get; private set; }

        public List<RefOperationalStatusType> RefOperationalStatusTypes { get; private set; }
        public List<RefOperationalStatus> RefOperationalStatuses { get; private set; }

        public List<RefProgramType> RefProgramTypes { get; private set; }


        public List<RefSpecialEducationAgeGroupTaught> RefSpecialEducationAgeGroupTaughts { get; private set; }
        public List<RefSpecialEducationStaffCategory> RefSpecialEducationStaffCategories { get; private set; }
        public List<RefClassroomPositionType> RefClassroomPositionTypes { get; private set; }
        public List<RefK12staffClassification> RefK12staffClassifications { get; private set; }

        public List<RefTitleIprogramStaffCategory> RefTitleIprogramStaffCategories { get; private set; }
        public List<RefUnexperiencedStatus> RefUnexperiencedStatuses { get; private set; }
        public List<RefOutOfFieldStatus> RefOutOfFieldStatuses { get; private set; }
        public List<RefEmergencyOrProvisionalCredentialStatus> RefEmergencyOrProvisionalCredentialStatuses { get; private set; }

        public List<RefAeCertificationType> RefAeCertificationTypes { get; private set; }
        public List<RefCredentialType> RefCredentialTypes { get; private set; }
        public List<RefParaprofessionalQualification> RefParaprofessionalQualifications { get; private set; }

        public List<RefCharterLeaStatus> RefCharterLeaStatuses { get; private set; }

        public List<RefCharterSchoolAuthorizerType> RefCharterSchoolAuthorizerTypes { get; private set; }
        public List<RefCharterSchoolManagementOrganizationType> RefCharterSchoolManagementOrganizationTypes { get; private set; }
        public List<RefExitOrWithdrawalType> RefExitOrWithdrawalTypes { get; private set; }
        public List<RefStateAppropriationMethod> RefStateAppropriationMethods { get; private set; }
        public List<RefOrganizationRelationship> RefOrganizationRelationships { get; private set; }
        public List<RefInstitutionTelephoneType> RefInstitutionTelephoneTypes { get; private set; }

        #endregion

        // Ids
        public int FundingResponsibilityTypeId { get; private set; }
        public int AttendanceResponsibilityTypeId { get; private set; }
        public int IepResponsibilityTypeId { get; private set; }
        public int StateIssuedId { get; private set; }
        public int StudentIdentifierTypeId { get; private set; }
        public int StaffIdentifierTypeId { get; private set; }
        public int PersonIdentifierTypeId { get; private set; }
        public int StudentSchoolIdentificationSystemId { get; private set; }
        public int StudentStateIdentificationSystemId { get; private set; }
        public int StaffSchoolIdentificationSystemId { get; private set; }
        public int StaffStateIdentificationSystemId { get; private set; }
        public int PersonSchoolIdentificationSystemId { get; private set; }
        public int PersonStateIdentificationSystemId { get; private set; }

        public IEnumerable<int> EntryGradeLevelIds { get; private set; }
        public IEnumerable<int> ExitGradeLevelIds { get; private set; }
        public IEnumerable<int> GradesOfferedIds { get; private set; }

        public int RefScoreMetricTypeId { get; private set; }
        public string RefScoreMetricType { get; private set; }

        public int EcoDisStatusTypeId { get; private set; }
        public int HomelessStatusTypeId { get; private set; }
        public int HomlessUnaccompaniedYouthStatusTypeId { get; private set; }
        public int LepStatusTypeId { get; private set; }
        public int PerkinsLepStatusTypeId { get; private set; }
        public int MigrantStatusTypeId { get; private set; }
        public int SpecialEdStatusTypeId { get; private set; }
        public int ImmigrantTitleIIIStatusTypeId { get; private set; }
        public int GedParticipationTypeId { get; private set; }
        public int FullSchoolYearTypeId { get; private set; }

        public int GradesOfferedTypeId { get; private set; }
        public int EntryGradeLevelTypeId { get; private set; }
        public int ExitGradeLevelTypeId { get; private set; }

        public int OrganizationElementTypeId { get; private set; }
        public int SchoolOrganizationTypeId { get; private set; }

        public int ProgramRefOrganizationTypeId { get; private set; }

        public int SpecialEdProgramTypeId { get; private set; }
        public int LepProgramTypeId { get; private set; }
        public int FosterCareProgramTypeId { get; private set; }
        public int ImmigrantEducationProgramTypeId { get; private set; }
        public int MigrantEducationProgramTypeId { get; private set; }
        public int CteProgramTypeId { get; private set; }
        public int NeglectedProgramTypeId { get; private set; }
        public int HomelessProgramTypeId { get; private set; }

        public int ParaProfessionalId { get; private set; }
        public int SpecialEdTeacherId { get; private set; }


        public IdsReferenceData()
        {

            // Data

            this.RefK12responsibilityTypes = RefK12responsibilityTypeHelper.GetData();
            this.RefSexes = RefSexHelper.GetData();
            this.RefPersonStatusTypes = RefPersonStatusTypeHelper.GetData();
            this.RefDisabilityTypes = RefDisabilityTypeHelper.GetData();
            this.RefHomelessNighttimeResidences = RefHomelessNighttimeResidenceHelper.GetData();
            this.RefLanguages = RefLanguageHelper.GetData();
            this.RefLanguageUseTypes = RefLanguageUseTypeHelper.GetData();
            this.RefRaces = RefRaceHelper.GetData();

            this.RefPersonalInformationVerifications = RefPersonalInformationVerificationHelper.GetData();
            this.RefPersonIdentifierTypes = RefPersonIdentifierTypeHelper.GetData();
            this.RefPersonIdentificationSystems = RefPersonIdentificationSystemHelper.GetData();
            this.RefProgramExitReasons = RefProgramExitReasonHelper.GetData();
            this.RefIdeaeducationalEnvironmentEcs = RefIdeaeducationalEnvironmentEcHelper.GetData();
            this.RefExitOrWithdrawalTypes = RefExitOrWithdrawalTypeHelper.GetData();

            this.RefSpecialEducationExitReasons = RefSpecialEducationExitReasonHelper.GetData();
            this.RefMepServiceTypes = RefMepServiceTypeHelper.GetData();
            this.RefCteNonTraditionalGenderStatuses = RefCteNonTraditionalGenderStatusHelper.GetData();
            this.RefEmployedWhileEnrolleds = RefEmployedWhileEnrolledHelper.GetData();
            this.RefEmployedAfterExits = RefEmployedAfterExitHelper.GetData();
            this.RefNeglectedProgramTypes = RefNeglectedProgramTypeHelper.GetData();
            this.RefAcademicCareerAndTechnicalOutcomesInPrograms = RefAcademicCareerAndTechnicalOutcomesInProgramHelper.GetData();
            this.RefAcademicCareerAndTechnicalOutcomesExitedPrograms = RefAcademicCareerAndTechnicalOutcomesExitedProgramHelper.GetData();
            this.RefTitleIiiaccountabilities = RefTitleIiiaccountabilityHelper.GetData();
            this.RefWfProgramParticipations = RefWfProgramParticipationHelper.GetData();


            this.RefDisciplinaryActionTakens = RefDisciplinaryActionTakenHelper.GetData();
            this.RefDisciplineReasons = RefDisciplineReasonHelper.GetData();
            this.RefDisciplineLengthDifferenceReasons = RefDisciplineLengthDifferenceReasonHelper.GetData();
            this.RefIdeainterimRemovals = RefIdeainterimRemovalHelper.GetData();
            this.RefIdeainterimRemovalReasons = RefIdeainterimRemovalReasonHelper.GetData();
            this.RefDisciplineMethodFirearms = RefDisciplineMethodFirearmsHelper.GetData();
            this.RefIdeadisciplineMethodFirearms = RefIdeadisciplineMethodFirearmHelper.GetData();
            this.RefIncidentBehaviors = RefIncidentBehaviorHelper.GetData();
            this.RefFirearmTypes = RefFirearmTypeHelper.GetData();
            this.RefDisciplineMethodOfCwds = RefDisciplineMethodOfCwdHelper.GetData();
            this.RefWeaponTypes = RefWeaponTypeHelper.GetData();

            this.RefIdeaeducationalEnvironmentSchoolAges = RefIdeaeducationalEnvironmentSchoolAgeHelper.GetData();
            this.RefProfessionalTechnicalCredentialTypes = RefProfessionalTechnicalCredentialTypeHelper.GetData();

            this.RefGradeLevelTypes = RefGradeLevelTypeHelper.GetData();
            this.RefGradeLevels = RefGradeLevelHelper.GetData();

            this.RefFoodServiceEligibilities = RefFoodServiceEligibilityHelper.GetData();


            this.RefHighSchoolDiplomaTypes = RefHighSchoolDiplomaTypeHelper.GetData();
            this.RefPsEnrollmentActions = RefPsEnrollmentActionHelper.GetData();
            this.RefProgressLevels = RefProgressLevelHelper.GetData();

            this.AssessmentPerformanceLevels = AssessmentPerformanceLevelHelper.GetData();
            this.RefScoreMetricTypes = RefScoreMetricTypeHelper.GetData();
            this.RefAssessmentReasonNotCompletings = RefAssessmentReasonNotCompletingHelper.GetData();
            this.RefAssessmentReasonNotTested = RefAssessmentReasonNotTestedHelper.GetData();
            this.RefAssessmentParticipationIndicators = RefAssessmentParticipationIndicatorHelper.GetData();

            this.RefParticipationTypes = RefParticipationTypeHelper.GetData();

            this.RefOrganizationTypes = RefOrganizationTypeHelper.GetData();

            this.RefOrganizationElementTypes = RefOrganizationElementTypeHelper.GetData();
            this.RefSchoolTypes = RefSchoolTypeHelper.GetData();
            this.RefOrganizationLocationTypes = RefOrganizationLocationTypeHelper.GetData();
            this.RefOrganizationIdentifierTypes = RefOrganizationIdentifierTypeHelper.GetData();
            this.RefOrganizationIdentificationSystems = RefOrganizationIdentificationSystemHelper.GetData();

            this.RefSessionTypes = RefSessionTypeHelper.GetData();

            this.RefReapAlternativeFundingStatuses = RefReapAlternativeFundingStatusHelper.GetData();
            this.RefFederalProgramFundingAllocationTypes = RefFederalProgramFundingAllocationTypeHelper.GetData();

            this.RefGunFreeSchoolsActReportingStatuses = RefGunFreeSchoolsActReportingStatusHelper.GetData();

            this.RefHighSchoolGraduationRateIndicators = RefHighSchoolGraduationRateIndicatorHelper.GetData();
            this.RefReconstitutedStatuses = RefReconstitutedStatusHelper.GetData();
            this.RefCteGraduationRateInclusions = RefCteGraduationRateInclusionHelper.GetData();
            this.RefAmaoAttainmentStatuses = RefAmaoAttainmentStatusHelper.GetData();

            this.RefStatePovertyDesignations = RefStatePovertyDesignationHelper.GetData();

            this.RefSchoolImprovementStatuses = RefSchoolImprovementStatusHelper.GetData();
            this.RefSchoolImprovementFunds = RefSchoolImprovementFundsHelper.GetData();

            this.RefOrganizationIndicators = RefOrganizationIndicatorHelper.GetData();


            this.RefTitleIschoolStatuses = RefTitleIschoolStatusHelper.GetData();
            this.RefVirtualSchoolStatuses = RefVirtualSchoolStatusHelper.GetData();
            this.RefMagnetSpecialPrograms = RefMagnetSpecialProgramHelper.GetData();
            this.RefNSLPStatuses = RefNSLPStatusHelper.GetData();
            this.RefSchoolDangerousStatuses = RefSchoolDangerousStatusHelper.GetData();
            this.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatuses = RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusHelper.GetData();
            this.RefComprehensiveAndTargetedSupports = RefComprehensiveAndTargetedSupportHelper.GetData();
            this.RefComprehensiveSupports = RefComprehensiveSupportHelper.GetData();
            this.RefTargetedSupports = RefTargetedSupportHelper.GetData();
            this.RefComprehensiveSupportImprovements = RefComprehensiveSupportImprovementHelper.GetData();
            this.RefTargetedSupportImprovements = RefTargetedSupportImprovementHelper.GetData();
            this.RefAdditionalTargetedSupportImprovements = RefAdditionalTargetedSupportHelper.GetData();           
            
            this.RefIndicatorStatusTypes = RefIndicatorStatusTypeHelper.GetData();
            this.RefIndicatorStatusSubgroupTypes = RefIndicatorStatusSubgroupTypeHelper.GetData();
            this.RefIndicatorStateDefinedStatuses = RefIndicatorStateDefinedStatusHelper.GetData();
            this.MajorRacialEthnicGroups = MajorRacialEthnicGroupsHelper.GetData();
            this.IndicatorStatuses = IndicatorStatusHelper.GetData();
            this.RefIndicatorStatusCustomTypes = RefIndicatorStatusCustomTypeHelper.GetData();

            this.RefAcademicSubjects = RefAcademicSubjectHelper.GetData();
            this.RefAssessmentTypeChildrenWithDisabilities = RefAssessmentTypeChildrenWithDisabilitiesHelper.GetData();
            this.RefAssessmentTypeAdministeredToEnglishLearners = RefAssessmentTypeAdministeredToEnglishLearnersHelper.GetData();

            this.RefStates = RefStateHelper.GetData();
            this.RefStateAnsicodes = RefStateAnsiCodeHelper.GetData();

            this.RefLeaTypes = RefLeaTypeHelper.GetData();

            this.RefK12leaTitleIsupportServices = RefK12leaTitleIsupportServiceHelper.GetData();

            this.RefTitleIinstructionalServices = RefTitleIinstructionalServicesHelper.GetData();
            this.RefTitleIprogramTypes = RefTitleIprogramTypeHelper.GetData();
            this.RefMepProjectTypes = RefMepProjectTypeHelper.GetData();

            this.RefTitleIiilanguageInstructionProgramTypes = RefTitleIiilanguageInstructionProgramTypeHelper.GetData();

            this.RefOperationalStatusTypes = RefOperationalStatusTypeHelper.GetData();

            this.RefOperationalStatuses = RefOperationalStatusHelper.GetData();

            this.RefProgramTypes = RefProgramTypeHelper.GetData();


            this.RefSpecialEducationAgeGroupTaughts = RefSpecialEducationAgeGroupTaughtHelper.GetData();
            this.RefSpecialEducationStaffCategories = RefSpecialEducationStaffCategoryHelper.GetData();
            this.RefClassroomPositionTypes = RefClassroomPositionTypeHelper.GetData();
            this.RefK12staffClassifications = RefK12staffClassificationHelper.GetData();
            this.RefTitleIprogramStaffCategories = RefTitleIprogramStaffCategoryHelper.GetData();
            this.RefUnexperiencedStatuses = RefUnexperiencedStatusHelper.GetData();
            this.RefOutOfFieldStatuses = RefOutOfFieldStatusHelper.GetData();
            this.RefEmergencyOrProvisionalCredentialStatuses = RefEmergencyOrProvisionalCredentialStatusHelper.GetData();
            this.RefAeCertificationTypes = RefAeCertificationTypeHelper.GetData();
            this.RefCredentialTypes = RefCredentialTypeHelper.GetData();
            this.RefParaprofessionalQualifications = RefParaprofessionalQualificationHelper.GetData();
            this.RefCharterLeaStatuses = RefCharterLeaStatusHelper.GetData();

            this.RefCharterSchoolAuthorizerTypes = RefCharterSchoolAuthorizerTypeHelper.GetData();
            this.RefCharterSchoolManagementOrganizationTypes = RefCharterSchoolManagementOrganizationTypeHelper.GetData();
            this.RefStateAppropriationMethods = RefStateAppropriationMethodHelper.GetData();
            this.RefOrganizationRelationships = RefOrganizationRelationshipHelper.GetData();
            this.RefInstitutionTelephoneTypes = RefInstitutionTelephoneTypepHelper.GetData();

            // Ids

            this.FundingResponsibilityTypeId = this.RefK12responsibilityTypes.Single(x => x.Code == "Funding").RefK12responsibilityTypeId;
            this.AttendanceResponsibilityTypeId = this.RefK12responsibilityTypes.Single(x => x.Code == "Attendance").RefK12responsibilityTypeId;
            this.IepResponsibilityTypeId = this.RefK12responsibilityTypes.Single(x => x.Code == "IndividualizedEducationProgram").RefK12responsibilityTypeId;

            this.StateIssuedId = this.RefPersonalInformationVerifications.Single(x => x.Code == "01011").RefPersonalInformationVerificationId;
            this.StudentIdentifierTypeId = this.RefPersonIdentifierTypes.Single(s => s.Code == "001075").RefPersonIdentifierTypeId;
            this.StaffIdentifierTypeId = this.RefPersonIdentifierTypes.Single(s => s.Code == "001074").RefPersonIdentifierTypeId;
            this.PersonIdentifierTypeId = this.RefPersonIdentifierTypes.Single(s => s.Code == "001571").RefPersonIdentifierTypeId; 
            this.StudentSchoolIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "School" && s.RefPersonIdentifierTypeId == this.StudentIdentifierTypeId).RefPersonIdentificationSystemId;
            this.StudentStateIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "State" && s.RefPersonIdentifierTypeId == this.StudentIdentifierTypeId).RefPersonIdentificationSystemId;
            this.StaffSchoolIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "School" && s.RefPersonIdentifierTypeId == this.StaffIdentifierTypeId).RefPersonIdentificationSystemId;
            this.StaffStateIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "State" && s.RefPersonIdentifierTypeId == this.StaffIdentifierTypeId).RefPersonIdentificationSystemId;
            this.PersonSchoolIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "School" && s.RefPersonIdentifierTypeId == this.PersonIdentifierTypeId).RefPersonIdentificationSystemId;
            this.PersonStateIdentificationSystemId = this.RefPersonIdentificationSystems.Single(s => s.Code == "State" && s.RefPersonIdentifierTypeId == this.PersonIdentifierTypeId).RefPersonIdentificationSystemId;


            this.GradesOfferedTypeId = this.RefGradeLevelTypes.Single(x => x.Code == "000131").RefGradeLevelTypeId;
            this.EntryGradeLevelTypeId = this.RefGradeLevelTypes.Single(x => x.Code == "000100").RefGradeLevelTypeId;
            this.ExitGradeLevelTypeId = this.RefGradeLevelTypes.Single(x => x.Code == "001210").RefGradeLevelTypeId;

            this.GradesOfferedIds = this.RefGradeLevels.Where(x => x.RefGradeLevelTypeId == this.GradesOfferedTypeId).Select(x => x.RefGradeLevelId);
            this.EntryGradeLevelIds = this.RefGradeLevels.Where(x => x.RefGradeLevelTypeId == this.EntryGradeLevelTypeId).Select(x => x.RefGradeLevelId);
            this.ExitGradeLevelIds = this.RefGradeLevels.Where(x => x.RefGradeLevelTypeId == this.ExitGradeLevelTypeId).Select(x => x.RefGradeLevelId);

            this.RefScoreMetricTypeId = this.RefScoreMetricTypes.Single(x => x.Code == "00499").RefScoreMetricTypeId;
            this.RefScoreMetricType = this.RefScoreMetricTypes.Single(x => x.Code == "00499").Code;

            this.EcoDisStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "EconomicDisadvantage").RefPersonStatusTypeId;
            this.HomelessStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "Homeless").RefPersonStatusTypeId;
            this.HomlessUnaccompaniedYouthStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "HomelessUnaccompaniedYouth").RefPersonStatusTypeId;
            this.LepStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "LEP").RefPersonStatusTypeId;
            this.PerkinsLepStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "Perkins LEP").RefPersonStatusTypeId;
            this.MigrantStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "Migrant").RefPersonStatusTypeId;
            this.SpecialEdStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "IDEA").RefPersonStatusTypeId;
            this.ImmigrantTitleIIIStatusTypeId = this.RefPersonStatusTypes.Single(x => x.Code == "TitleIIIImmigrant").RefPersonStatusTypeId;

            this.GedParticipationTypeId = this.RefParticipationTypes.Single(x => x.Code == "GEDPreparationProgramParticipation").RefParticipationTypeId;

            this.FullSchoolYearTypeId = this.RefSessionTypes.Single(x => x.Code == "FullSchoolYear").RefSessionTypeId;

            this.OrganizationElementTypeId = this.RefOrganizationElementTypes.Single(x => x.Code == "001156").RefOrganizationElementTypeId;
            this.SchoolOrganizationTypeId = this.RefOrganizationTypes.Single(x => x.Code == "K12School" && x.RefOrganizationElementTypeId == this.OrganizationElementTypeId).RefOrganizationTypeId;

            this.ProgramRefOrganizationTypeId = this.RefOrganizationTypes.Single(x => x.Code == "Program" && x.RefOrganizationElementTypeId == this.OrganizationElementTypeId).RefOrganizationTypeId;
            this.SpecialEdProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04888").RefProgramTypeId;
            this.LepProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04928").RefProgramTypeId;
            this.FosterCareProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "75000").RefProgramTypeId;
            this.ImmigrantEducationProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04957").RefProgramTypeId;
            this.MigrantEducationProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04920").RefProgramTypeId;
            this.CteProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04906").RefProgramTypeId;
            this.NeglectedProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "04922").RefProgramTypeId;
            this.HomelessProgramTypeId = this.RefProgramTypes.Single(o => o.Code == "76000").RefProgramTypeId;


            this.ParaProfessionalId = this.RefK12staffClassifications.Single(c => c.Code == "Paraprofessionals").RefEducationStaffClassificationId;
            this.SpecialEdTeacherId = this.RefK12staffClassifications.Single(c => c.Code == "SpecialEducationTeachers").RefEducationStaffClassificationId;
           

        }

    }
}
