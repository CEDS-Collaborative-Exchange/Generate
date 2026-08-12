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
        public List<RefK12responsibilityType> RefK12responsibilityTypes { get; }
        public List<RefSex> RefSexes { get; }
        public List<RefPersonStatusType> RefPersonStatusTypes { get; }
        public List<RefDisabilityType> RefDisabilityTypes { get; }
        public List<RefHomelessNighttimeResidence> RefHomelessNighttimeResidences { get; }
        public List<RefLanguage> RefLanguages { get; }
        public List<RefLanguageUseType> RefLanguageUseTypes { get; }
        public List<RefRace> RefRaces { get; }

        public List<RefPersonalInformationVerification> RefPersonalInformationVerifications { get; }
        public List<RefPersonIdentifierType> RefPersonIdentifierTypes { get; }
        public List<RefPersonIdentificationSystem> RefPersonIdentificationSystems { get;}
        public List<RefProgramExitReason> RefProgramExitReasons { get;}
        public List<RefIdeaeducationalEnvironmentEc> RefIdeaeducationalEnvironmentEcs { get;}


        public List<RefSpecialEducationExitReason> RefSpecialEducationExitReasons { get;}
        public List<RefMepServiceType> RefMepServiceTypes { get; }
        public List<RefCteNonTraditionalGenderStatus> RefCteNonTraditionalGenderStatuses { get;}
        public List<RefEmployedWhileEnrolled> RefEmployedWhileEnrolleds { get;}
        public List<RefEmployedAfterExit> RefEmployedAfterExits { get;}
        public List<RefNeglectedProgramType> RefNeglectedProgramTypes { get;}
        public List<RefAcademicCareerAndTechnicalOutcomesInProgram> RefAcademicCareerAndTechnicalOutcomesInPrograms { get; }
        public List<RefAcademicCareerAndTechnicalOutcomesExitedProgram> RefAcademicCareerAndTechnicalOutcomesExitedPrograms { get; }
        public List<RefTitleIiiaccountability> RefTitleIiiaccountabilities { get; }
        public List<RefWfProgramParticipation> RefWfProgramParticipations { get; }

        public List<RefDisciplinaryActionTaken> RefDisciplinaryActionTakens { get; }
        public List<RefDisciplineReason> RefDisciplineReasons { get; }
        public List<RefDisciplineLengthDifferenceReason> RefDisciplineLengthDifferenceReasons { get; }
        public List<RefIdeainterimRemoval> RefIdeainterimRemovals { get; }
        public List<RefIdeainterimRemovalReason> RefIdeainterimRemovalReasons { get; }
        public List<RefDisciplineMethodOfCwd> RefDisciplineMethodOfCwds { get; }
        public List<RefWeaponType> RefWeaponTypes { get; }
        public List<RefDisciplineMethodFirearms> RefDisciplineMethodFirearms { get; }
        public List<RefIdeadisciplineMethodFirearm> RefIdeadisciplineMethodFirearms { get; }
        public List<RefIncidentBehavior> RefIncidentBehaviors { get; }
        public List<RefFirearmType> RefFirearmTypes { get; }
        public List<RefIdeaeducationalEnvironmentSchoolAge> RefIdeaeducationalEnvironmentSchoolAges { get; }
        public List<RefProfessionalTechnicalCredentialType> RefProfessionalTechnicalCredentialTypes { get; }

        public List<RefGradeLevelType> RefGradeLevelTypes { get;}
        public List<RefGradeLevel> RefGradeLevels { get; }

        public List<RefFoodServiceEligibility> RefFoodServiceEligibilities { get; }

        public List<RefHighSchoolDiplomaType> RefHighSchoolDiplomaTypes { get;}
        public List<RefPsEnrollmentAction> RefPsEnrollmentActions { get; }
        public List<RefProgressLevel> RefProgressLevels { get; }

        public List<AssessmentPerformanceLevel> PerformanceLevels { get; }
        public List<RefScoreMetricType> RefScoreMetricTypes { get; }
        public List<RefAssessmentReasonNotCompleting> RefAssessmentReasonNotCompletings { get; }
        public List<RefAssessmentReasonNotTested> RefAssessmentReasonNotTested { get; }
        public List<RefAssessmentParticipationIndicator> RefAssessmentParticipationIndicators { get; }

        public List<RefParticipationType> RefParticipationTypes { get; }

        public List<RefOrganizationType> RefOrganizationTypes { get; }

        public List<RefOrganizationElementType> RefOrganizationElementTypes { get; }
        public List<RefSchoolType> RefSchoolTypes { get; }
        public List<RefOrganizationLocationType> RefOrganizationLocationTypes { get; }
        public List<RefOrganizationIdentifierType> RefOrganizationIdentifierTypes { get; }
        public List<RefOrganizationIdentificationSystem> RefOrganizationIdentificationSystems { get; }
        public List<RefSessionType> RefSessionTypes { get; }

        public List<RefReapAlternativeFundingStatus> RefReapAlternativeFundingStatuses { get; }
        public List<RefFederalProgramFundingAllocationType> RefFederalProgramFundingAllocationTypes { get; }

        public List<RefGunFreeSchoolsActReportingStatus> RefGunFreeSchoolsActReportingStatuses { get; }


        public List<RefHighSchoolGraduationRateIndicator> RefHighSchoolGraduationRateIndicators { get; }
        public List<RefReconstitutedStatus> RefReconstitutedStatuses { get; }
        public List<RefCteGraduationRateInclusion> RefCteGraduationRateInclusions { get; }
        public List<RefAmaoAttainmentStatus> RefAmaoAttainmentStatuses { get; }

        public List<RefStatePovertyDesignation> RefStatePovertyDesignations { get;}

        public List<RefSchoolImprovementStatus> RefSchoolImprovementStatuses { get;}
        public List<RefSchoolImprovementFunds> RefSchoolImprovementFunds { get; }

        public List<RefOrganizationIndicator> RefOrganizationIndicators { get;}


        
        public List<RefTitleIschoolStatus> RefTitleIschoolStatuses { get;  }
        public List<RefVirtualSchoolStatus> RefVirtualSchoolStatuses { get;  }
        public List<RefMagnetSpecialProgram> RefMagnetSpecialPrograms { get;  }
        public List<RefNSLPStatus> RefNSLPStatuses { get;  }
        public List<RefSchoolDangerousStatus> RefSchoolDangerousStatuses { get;  }
        public List<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatuses { get;  }
        public List<RefComprehensiveAndTargetedSupport> RefComprehensiveAndTargetedSupports { get;  }
        public List<RefComprehensiveSupport> RefComprehensiveSupports { get;  }
        public List<RefTargetedSupport> RefTargetedSupports { get;  }
        public List<RefComprehensiveSupportImprovement> RefComprehensiveSupportImprovements { get;  }
        public List<RefTargetedSupportImprovement> RefTargetedSupportImprovements { get;  }
        public List<RefAdditionalTargetedSupport> RefAdditionalTargetedSupportImprovements { get;  }        
        public List<RefIndicatorStatusType> RefIndicatorStatusTypes { get;  }
        public List<RefIndicatorStatusSubgroupType> RefIndicatorStatusSubgroupTypes { get;  }
        public List<RefIndicatorStateDefinedStatus> RefIndicatorStateDefinedStatuses { get;  }
        public List<string> MajorRacialEthnicGroups { get;  }
        public List<string> IndicatorStatuses { get;  }
        public List<RefIndicatorStatusCustomType> RefIndicatorStatusCustomTypes { get;  }

        public List<RefAcademicSubject> RefAcademicSubjects { get;  }
        public List<AssessmentPerformanceLevel> AssessmentPerformanceLevels { get;  }
        public List<RefAssessmentTypeChildrenWithDisabilities> RefAssessmentTypeChildrenWithDisabilities { get;  }
        public List<RefAssessmentTypeAdministeredToEnglishLearners> RefAssessmentTypeAdministeredToEnglishLearners { get;  }

        public List<RefState> RefStates { get;  }
        public List<RefStateAnsicode> RefStateAnsicodes { get;  }

        public List<RefLeaType> RefLeaTypes { get;  }

        public List<RefK12leaTitleIsupportService> RefK12leaTitleIsupportServices { get;  }


        public List<RefTitleIinstructionalServices> RefTitleIinstructionalServices { get;  }
        public List<RefTitleIprogramType> RefTitleIprogramTypes { get;  }
        public List<RefMepProjectType> RefMepProjectTypes { get;  }

        public List<RefTitleIiilanguageInstructionProgramType> RefTitleIiilanguageInstructionProgramTypes { get;  }

        public List<RefOperationalStatusType> RefOperationalStatusTypes { get;  }
        public List<RefOperationalStatus> RefOperationalStatuses { get;  }

        public List<RefProgramType> RefProgramTypes { get;  }


        public List<RefSpecialEducationAgeGroupTaught> RefSpecialEducationAgeGroupTaughts { get;  }
        public List<RefSpecialEducationStaffCategory> RefSpecialEducationStaffCategories { get;  }
        public List<RefClassroomPositionType> RefClassroomPositionTypes { get;  }
        public List<RefK12staffClassification> RefK12staffClassifications { get;  }

        public List<RefTitleIprogramStaffCategory> RefTitleIprogramStaffCategories { get;  }
        public List<RefUnexperiencedStatus> RefUnexperiencedStatuses { get;  }
        public List<RefOutOfFieldStatus> RefOutOfFieldStatuses { get;  }
        public List<RefEmergencyOrProvisionalCredentialStatus> RefEmergencyOrProvisionalCredentialStatuses { get;  }

        public List<RefAeCertificationType> RefAeCertificationTypes { get;  }
        public List<RefCredentialType> RefCredentialTypes { get;  }
        public List<RefParaprofessionalQualification> RefParaprofessionalQualifications { get;  }

        public List<RefCharterLeaStatus> RefCharterLeaStatuses { get;  }

        public List<RefCharterSchoolAuthorizerType> RefCharterSchoolAuthorizerTypes { get;  }
        public List<RefCharterSchoolManagementOrganizationType> RefCharterSchoolManagementOrganizationTypes { get;  }
        public List<RefExitOrWithdrawalType> RefExitOrWithdrawalTypes { get;  }
        public List<RefStateAppropriationMethod> RefStateAppropriationMethods { get;  }
        public List<RefOrganizationRelationship> RefOrganizationRelationships { get;  }
        public List<RefInstitutionTelephoneType> RefInstitutionTelephoneTypes { get;  }

        #endregion

        // Ids
        public int FundingResponsibilityTypeId { get;  }
        public int AttendanceResponsibilityTypeId { get;  }
        public int IepResponsibilityTypeId { get;  }
        public int StateIssuedId { get;  }
        public int StudentIdentifierTypeId { get;  }
        public int StaffIdentifierTypeId { get;  }
        public int PersonIdentifierTypeId { get;  }
        public int StudentSchoolIdentificationSystemId { get;  }
        public int StudentStateIdentificationSystemId { get;  }
        public int StaffSchoolIdentificationSystemId { get;  }
        public int StaffStateIdentificationSystemId { get;  }
        public int PersonSchoolIdentificationSystemId { get;  }
        public int PersonStateIdentificationSystemId { get;  }

        public IEnumerable<int> EntryGradeLevelIds { get;  }
        public IEnumerable<int> ExitGradeLevelIds { get;  }
        public IEnumerable<int> GradesOfferedIds { get;  }

        public int RefScoreMetricTypeId { get;  }
        public string RefScoreMetricType { get;  }

        public int EcoDisStatusTypeId { get;  }
        public int HomelessStatusTypeId { get;  }
        public int HomlessUnaccompaniedYouthStatusTypeId { get;  }
        public int LepStatusTypeId { get;  }
        public int PerkinsLepStatusTypeId { get;  }
        public int MigrantStatusTypeId { get;  }
        public int SpecialEdStatusTypeId { get;  }
        public int ImmigrantTitleIIIStatusTypeId { get;  }
        public int GedParticipationTypeId { get;  }
        public int FullSchoolYearTypeId { get;  }

        public int GradesOfferedTypeId { get;  }
        public int EntryGradeLevelTypeId { get;  }
        public int ExitGradeLevelTypeId { get;  }

        public int OrganizationElementTypeId { get;  }
        public int SchoolOrganizationTypeId { get;  }

        public int ProgramRefOrganizationTypeId { get;  }

        public int SpecialEdProgramTypeId { get;  }
        public int LepProgramTypeId { get;  }
        public int FosterCareProgramTypeId { get;  }
        public int ImmigrantEducationProgramTypeId { get;  }
        public int MigrantEducationProgramTypeId { get;  }
        public int CteProgramTypeId { get;  }
        public int NeglectedProgramTypeId { get;  }
        public int HomelessProgramTypeId { get;  }

        public int ParaProfessionalId { get;  }
        public int SpecialEdTeacherId { get;  }


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
