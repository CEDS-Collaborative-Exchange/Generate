using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Organization
    {
        public Organization()
        {
            K12CharterSchoolAuthorizer = new HashSet<K12CharterSchoolAuthorizer>();
            K12CharterSchoolManagementOrganization = new HashSet<K12CharterSchoolManagementOrganization>();
            AssessmentAdministrationOrganization = new HashSet<AssessmentAdministrationOrganization>();
            AssessmentRegistrationLeaOrganization = new HashSet<AssessmentRegistration>();
            AssessmentRegistrationOrganization = new HashSet<AssessmentRegistration>();
            AssessmentRegistrationSchoolOrganization = new HashSet<AssessmentRegistration>();
            AssessmentSessionLeaOrganization = new HashSet<AssessmentSession>();
            AssessmentSessionOrganization = new HashSet<AssessmentSession>();
            AssessmentSessionSchoolOrganization = new HashSet<AssessmentSession>();
            EarlyChildhoodProgramTypeOffered = new HashSet<EarlyChildhoodProgramTypeOffered>();
            ElfacilityLicensing = new HashSet<ElfacilityLicensing>();
            ElorganizationMonitoring = new HashSet<ElorganizationMonitoring>();
            ElprogramLicensing = new HashSet<ElprogramLicensing>();
            ElqualityInitiative = new HashSet<ElqualityInitiative>();
            ElqualityRatingImprovement = new HashSet<ElqualityRatingImprovement>();
            K12school = new HashSet<K12school>();
            K12titleIiilanguageInstruction = new HashSet<K12titleIiilanguageInstruction>();
            LearnerActivityLeaOrganization = new HashSet<LearnerActivity>();
            LearnerActivitySchoolOrganization = new HashSet<LearnerActivity>();
            OrganizationAccreditation = new HashSet<OrganizationAccreditation>();
            OrganizationCalendar = new HashSet<OrganizationCalendar>();
            OrganizationCalendarCrisis = new HashSet<OrganizationCalendarCrisis>();
            OrganizationDetail = new HashSet<OrganizationDetail>();
            OrganizationEmail = new HashSet<OrganizationEmail>();
            OrganizationFederalAccountability = new HashSet<OrganizationFederalAccountability>();
            OrganizationIdentifier = new HashSet<OrganizationIdentifier>();
            OrganizationIndicator = new HashSet<OrganizationIndicator>();
            OrganizationLocation = new HashSet<OrganizationLocation>();
            OrganizationOperationalStatus = new HashSet<OrganizationOperationalStatus>();
            OrganizationPersonRole = new HashSet<OrganizationPersonRole>();
            OrganizationPolicy = new HashSet<OrganizationPolicy>();
            OrganizationProgramType = new HashSet<OrganizationProgramType>();
            OrganizationRelationshipOrganization = new HashSet<OrganizationRelationship>();
            OrganizationRelationshipParentOrganization = new HashSet<OrganizationRelationship>();
            OrganizationTechnicalAssistance = new HashSet<OrganizationTechnicalAssistance>();
            OrganizationTelephone = new HashSet<OrganizationTelephone>();
            ProgramParticipationMigrant = new HashSet<ProgramParticipationMigrant>();
            PsProgram = new HashSet<PsProgram>();
            RefAbsentAttendanceCategory = new HashSet<RefAbsentAttendanceCategory>();
            RefAcademicAwardLevel = new HashSet<RefAcademicAwardLevel>();
            RefAcademicHonorType = new HashSet<RefAcademicHonorType>();
            RefAcademicRank = new HashSet<RefAcademicRank>();
            RefAcademicSubject = new HashSet<RefAcademicSubject>();
            RefAcademicTermDesignator = new HashSet<RefAcademicTermDesignator>();
            RefAccommodationsNeededType = new HashSet<RefAccommodationsNeededType>();
            RefAccreditationAgency = new HashSet<RefAccreditationAgency>();
            RefActivityRecognitionType = new HashSet<RefActivityRecognitionType>();
            RefActivityTimeMeasurementType = new HashSet<RefActivityTimeMeasurementType>();
            RefAdditionalCreditType = new HashSet<RefAdditionalCreditType>();
            RefAdditionalTargetedSupport = new HashSet<RefAdditionalTargetedSupport>();
            RefAddressType = new HashSet<RefAddressType>();           
            RefAdministrativeFundingControl = new HashSet<RefAdministrativeFundingControl>();
            RefAdmissionConsiderationLevel = new HashSet<RefAdmissionConsiderationLevel>();
            RefAdmissionConsiderationType = new HashSet<RefAdmissionConsiderationType>();
            RefAdmittedStudent = new HashSet<RefAdmittedStudent>();
            RefAdvancedPlacementCourseCode = new HashSet<RefAdvancedPlacementCourseCode>();
            RefAeCertificationType = new HashSet<RefAeCertificationType>();
            RefAeFunctioningLevelAtIntake = new HashSet<RefAeFunctioningLevelAtIntake>();
            RefAeFunctioningLevelAtPosttest = new HashSet<RefAeFunctioningLevelAtPosttest>();
            RefAeInstructionalProgramType = new HashSet<RefAeInstructionalProgramType>();
            RefAePostsecondaryTransitionAction = new HashSet<RefAePostsecondaryTransitionAction>();
            RefAeSpecialProgramType = new HashSet<RefAeSpecialProgramType>();
            RefAeStaffClassification = new HashSet<RefAeStaffClassification>();
            RefAeStaffEmploymentStatus = new HashSet<RefAeStaffEmploymentStatus>();
            RefAllergySeverity = new HashSet<RefAllergySeverity>();
            RefAllergyType = new HashSet<RefAllergyType>();
            RefAlternateFundUses = new HashSet<RefAlternateFundUses>();
            RefAlternativeSchoolFocus = new HashSet<RefAlternativeSchoolFocus>();
            RefAltRouteToCertificationOrLicensure = new HashSet<RefAltRouteToCertificationOrLicensure>();
            RefAmaoAttainmentStatus = new HashSet<RefAmaoAttainmentStatus>();
            RefApipInteractionType = new HashSet<RefApipInteractionType>();
            RefAssessmentAccommodationType = new HashSet<RefAssessmentAccommodationType>();
            RefAssessmentAssetIdentifierType = new HashSet<RefAssessmentAssetIdentifierType>();
            RefAssessmentAssetType = new HashSet<RefAssessmentAssetType>();
            RefAssessmentEldevelopmentalDomain = new HashSet<RefAssessmentEldevelopmentalDomain>();
            RefAssessmentFormSectionIdentificationSystem = new HashSet<RefAssessmentFormSectionIdentificationSystem>();
            RefAssessmentItemCharacteristicType = new HashSet<RefAssessmentItemCharacteristicType>();
            RefAssessmentItemResponseScoreStatus = new HashSet<RefAssessmentItemResponseScoreStatus>();
            RefAssessmentItemResponseStatus = new HashSet<RefAssessmentItemResponseStatus>();
            RefAssessmentItemType = new HashSet<RefAssessmentItemType>();
            RefAssessmentNeedAlternativeRepresentationType = new HashSet<RefAssessmentNeedAlternativeRepresentationType>();
            RefAssessmentNeedBrailleGradeType = new HashSet<RefAssessmentNeedBrailleGradeType>();
            RefAssessmentNeedBrailleMarkType = new HashSet<RefAssessmentNeedBrailleMarkType>();
            RefAssessmentNeedBrailleStatusCellType = new HashSet<RefAssessmentNeedBrailleStatusCellType>();
            RefAssessmentNeedHazardType = new HashSet<RefAssessmentNeedHazardType>();
            RefAssessmentNeedIncreasedWhitespacingType = new HashSet<RefAssessmentNeedIncreasedWhitespacingType>();
            RefAssessmentNeedLanguageLearnerType = new HashSet<RefAssessmentNeedLanguageLearnerType>();
            RefAssessmentNeedMaskingType = new HashSet<RefAssessmentNeedMaskingType>();
            RefAssessmentNeedNumberOfBrailleDots = new HashSet<RefAssessmentNeedNumberOfBrailleDots>();
            RefAssessmentNeedSigningType = new HashSet<RefAssessmentNeedSigningType>();
            RefAssessmentNeedSpokenSourcePreferenceType = new HashSet<RefAssessmentNeedSpokenSourcePreferenceType>();
            RefAssessmentNeedSupportTool = new HashSet<RefAssessmentNeedSupportTool>();
            RefAssessmentNeedUsageType = new HashSet<RefAssessmentNeedUsageType>();
            RefAssessmentNeedUserSpokenPreferenceType = new HashSet<RefAssessmentNeedUserSpokenPreferenceType>();
            RefAssessmentParticipationIndicator = new HashSet<RefAssessmentParticipationIndicator>();
            RefAssessmentPlatformType = new HashSet<RefAssessmentPlatformType>();
            RefAssessmentPretestOutcome = new HashSet<RefAssessmentPretestOutcome>();
            RefAssessmentPurpose = new HashSet<RefAssessmentPurpose>();
            RefAssessmentReasonNotCompleting = new HashSet<RefAssessmentReasonNotCompleting>();
            RefAssessmentReasonNotTested = new HashSet<RefAssessmentReasonNotTested>();
            RefAssessmentRegistrationCompletionStatus = new HashSet<RefAssessmentRegistrationCompletionStatus>();
            RefAssessmentReportingMethod = new HashSet<RefAssessmentReportingMethod>();
            RefAssessmentResultDataType = new HashSet<RefAssessmentResultDataType>();
            RefAssessmentResultScoreType = new HashSet<RefAssessmentResultScoreType>();
            RefAssessmentSessionSpecialCircumstanceType = new HashSet<RefAssessmentSessionSpecialCircumstanceType>();
            RefAssessmentSessionStaffRoleType = new HashSet<RefAssessmentSessionStaffRoleType>();
            RefAssessmentSessionType = new HashSet<RefAssessmentSessionType>();
            RefAssessmentSubtestIdentifierType = new HashSet<RefAssessmentSubtestIdentifierType>();
            RefAssessmentType = new HashSet<RefAssessmentType>();
            RefAssessmentTypeChildrenWithDisabilities = new HashSet<RefAssessmentTypeChildrenWithDisabilities>();
            RefAttendanceEventType = new HashSet<RefAttendanceEventType>();
            RefAttendanceStatus = new HashSet<RefAttendanceStatus>();
            RefAypStatus = new HashSet<RefAypStatus>();
            RefBarrierToEducatingHomeless = new HashSet<RefBarrierToEducatingHomeless>();
            RefBillableBasisType = new HashSet<RefBillableBasisType>();
            RefBlendedLearningModelType = new HashSet<RefBlendedLearningModelType>();
            RefBloomsTaxonomyDomain = new HashSet<RefBloomsTaxonomyDomain>();
            RefBuildingUseType = new HashSet<RefBuildingUseType>();
            RefCalendarEventType = new HashSet<RefCalendarEventType>();
            RefCampusResidencyType = new HashSet<RefCampusResidencyType>();
            RefCareerCluster = new HashSet<RefCareerCluster>();
            RefCareerEducationPlanType = new HashSet<RefCareerEducationPlanType>();
            RefCarnegieBasicClassification = new HashSet<RefCarnegieBasicClassification>();
            RefCharterSchoolType = new HashSet<RefCharterSchoolType>();
            RefChildDevelopmentalScreeningStatus = new HashSet<RefChildDevelopmentalScreeningStatus>();
            RefChildDevelopmentAssociateType = new HashSet<RefChildDevelopmentAssociateType>();
            RefChildOutcomesSummaryRating = new HashSet<RefChildOutcomesSummaryRating>();
            RefCipCode = new HashSet<RefCipCode>();
            RefCipUse = new HashSet<RefCipUse>();
            RefCipVersion = new HashSet<RefCipVersion>();
            RefClassroomPositionType = new HashSet<RefClassroomPositionType>();
            RefCohortExclusion = new HashSet<RefCohortExclusion>();
            RefCommunicationMethod = new HashSet<RefCommunicationMethod>();
            RefCommunityBasedType = new HashSet<RefCommunityBasedType>();
            RefCompetencySetCompletionCriteria = new HashSet<RefCompetencySetCompletionCriteria>();
			RefComprehensiveSupport = new HashSet<RefComprehensiveSupport>();
			RefComprehensiveAndTargetedSupport = new HashSet<RefComprehensiveAndTargetedSupport>();
            RefComprehensiveSupportImprovement = new HashSet<RefComprehensiveSupportImprovement>();
            RefContentStandardType = new HashSet<RefContentStandardType>();
            RefContinuationOfServices = new HashSet<RefContinuationOfServices>();
            RefControlOfInstitution = new HashSet<RefControlOfInstitution>();
            RefCoreKnowledgeArea = new HashSet<RefCoreKnowledgeArea>();
            RefCorrectionalEducationFacilityType = new HashSet<RefCorrectionalEducationFacilityType>();
            RefCorrectiveActionType = new HashSet<RefCorrectiveActionType>();
            RefCountry = new HashSet<RefCountry>();
            RefCounty = new HashSet<RefCounty>();
            RefCourseAcademicGradeStatusCode = new HashSet<RefCourseAcademicGradeStatusCode>();
            RefCourseApplicableEducationLevel = new HashSet<RefCourseApplicableEducationLevel>();
            RefCourseCreditBasisType = new HashSet<RefCourseCreditBasisType>();
            RefCourseCreditLevelType = new HashSet<RefCourseCreditLevelType>();
            RefCourseCreditUnit = new HashSet<RefCourseCreditUnit>();
            RefCourseGpaApplicability = new HashSet<RefCourseGpaApplicability>();
            RefCourseHonorsType = new HashSet<RefCourseHonorsType>();
            RefCourseInstructionMethod = new HashSet<RefCourseInstructionMethod>();
            RefCourseInstructionSiteType = new HashSet<RefCourseInstructionSiteType>();
            RefCourseInteractionMode = new HashSet<RefCourseInteractionMode>();
            RefCourseLevelCharacteristic = new HashSet<RefCourseLevelCharacteristic>();
            RefCourseLevelType = new HashSet<RefCourseLevelType>();
            RefCourseRepeatCode = new HashSet<RefCourseRepeatCode>();
            RefCourseSectionAssessmentReportingMethod = new HashSet<RefCourseSectionAssessmentReportingMethod>();
            RefCourseSectionDeliveryMode = new HashSet<RefCourseSectionDeliveryMode>();
            RefCourseSectionEnrollmentStatusType = new HashSet<RefCourseSectionEnrollmentStatusType>();
            RefCourseSectionEntryType = new HashSet<RefCourseSectionEntryType>();
            RefCourseSectionExitType = new HashSet<RefCourseSectionExitType>();
            RefCredentialType = new HashSet<RefCredentialType>();
            RefCreditHoursAppliedOtherProgram = new HashSet<RefCreditHoursAppliedOtherProgram>();
            RefCreditTypeEarned = new HashSet<RefCreditTypeEarned>();
            RefCriticalTeacherShortageCandidate = new HashSet<RefCriticalTeacherShortageCandidate>();
            RefCteGraduationRateInclusion = new HashSet<RefCteGraduationRateInclusion>();
            RefCteNonTraditionalGenderStatus = new HashSet<RefCteNonTraditionalGenderStatus>();
            RefCurriculumFrameworkType = new HashSet<RefCurriculumFrameworkType>();
            RefDegreeOrCertificateType = new HashSet<RefDegreeOrCertificateType>();
            RefDentalInsuranceCoverageType = new HashSet<RefDentalInsuranceCoverageType>();
            RefDentalScreeningStatus = new HashSet<RefDentalScreeningStatus>();
            RefDependencyStatus = new HashSet<RefDependencyStatus>();
            RefDevelopmentalEducationReferralStatus = new HashSet<RefDevelopmentalEducationReferralStatus>();
            RefDevelopmentalEducationType = new HashSet<RefDevelopmentalEducationType>();
            RefDevelopmentalEvaluationFinding = new HashSet<RefDevelopmentalEvaluationFinding>();
            RefDirectoryInformationBlockStatus = new HashSet<RefDirectoryInformationBlockStatus>();
            RefDisabilityConditionStatusCode = new HashSet<RefDisabilityConditionStatusCode>();
            RefDisabilityConditionType = new HashSet<RefDisabilityConditionType>();
            RefDisabilityDeterminationSourceType = new HashSet<RefDisabilityDeterminationSourceType>();
            RefDisabilityType = new HashSet<RefDisabilityType>();
            RefDisciplinaryActionTaken = new HashSet<RefDisciplinaryActionTaken>();
            RefDisciplineLengthDifferenceReason = new HashSet<RefDisciplineLengthDifferenceReason>();
            RefDisciplineMethodFirearms = new HashSet<RefDisciplineMethodFirearms>();
            RefDisciplineMethodOfCwd = new HashSet<RefDisciplineMethodOfCwd>();
            RefDisciplineReason = new HashSet<RefDisciplineReason>();
            RefDistanceEducationCourseEnrollment = new HashSet<RefDistanceEducationCourseEnrollment>();
            RefDoctoralExamsRequiredCode = new HashSet<RefDoctoralExamsRequiredCode>();
            RefDqpcategoriesOfLearning = new HashSet<RefDqpcategoriesOfLearning>();
            RefEarlyChildhoodCredential = new HashSet<RefEarlyChildhoodCredential>();
            RefEarlyChildhoodProgramEnrollmentType = new HashSet<RefEarlyChildhoodProgramEnrollmentType>();
            RefEarlyChildhoodServices = new HashSet<RefEarlyChildhoodServices>();
            RefEducationLevel = new HashSet<RefEducationLevel>();
            RefEducationLevelType = new HashSet<RefEducationLevelType>();
            RefEducationVerificationMethod = new HashSet<RefEducationVerificationMethod>();
            RefEleducationStaffClassification = new HashSet<RefEleducationStaffClassification>();
            RefElementaryMiddleAdditional = new HashSet<RefElementaryMiddleAdditional>();
            RefElemploymentSeparationReason = new HashSet<RefElemploymentSeparationReason>();
            RefElfacilityLicensingStatus = new HashSet<RefElfacilityLicensingStatus>();
            RefElfederalFundingType = new HashSet<RefElfederalFundingType>();
            RefElgroupSizeStandardMet = new HashSet<RefElgroupSizeStandardMet>();
            RefEllevelOfSpecialization = new HashSet<RefEllevelOfSpecialization>();
            RefEllocalRevenueSource = new HashSet<RefEllocalRevenueSource>();
            RefElotherFederalFundingSources = new HashSet<RefElotherFederalFundingSources>();
            RefEloutcomeMeasurementLevel = new HashSet<RefEloutcomeMeasurementLevel>();
            RefElprofessionalDevelopmentTopicArea = new HashSet<RefElprofessionalDevelopmentTopicArea>();
            RefElprogramEligibility = new HashSet<RefElprogramEligibility>();
            RefElprogramEligibilityStatus = new HashSet<RefElprogramEligibilityStatus>();
            RefElprogramLicenseStatus = new HashSet<RefElprogramLicenseStatus>();
            RefElserviceProfessionalStaffClassification = new HashSet<RefElserviceProfessionalStaffClassification>();
            RefElserviceType = new HashSet<RefElserviceType>();
            RefElstateRevenueSource = new HashSet<RefElstateRevenueSource>();
            RefEltrainerCoreKnowledgeArea = new HashSet<RefEltrainerCoreKnowledgeArea>();
            RefEmailType = new HashSet<RefEmailType>();
			RefEmergencyOrProvisionalCredentialStatus = new HashSet<RefEmergencyOrProvisionalCredentialStatus>();
			RefEmployedAfterExit = new HashSet<RefEmployedAfterExit>();
            RefEmployedPriorToEnrollment = new HashSet<RefEmployedPriorToEnrollment>();
            RefEmployedWhileEnrolled = new HashSet<RefEmployedWhileEnrolled>();
            RefEmploymentContractType = new HashSet<RefEmploymentContractType>();
            RefEmploymentSeparationReason = new HashSet<RefEmploymentSeparationReason>();
            RefEmploymentSeparationType = new HashSet<RefEmploymentSeparationType>();
            RefEmploymentStatus = new HashSet<RefEmploymentStatus>();
            RefEmploymentStatusWhileEnrolled = new HashSet<RefEmploymentStatusWhileEnrolled>();
            RefEndOfTermStatus = new HashSet<RefEndOfTermStatus>();
            RefEnrollmentStatus = new HashSet<RefEnrollmentStatus>();
            RefEntityType = new HashSet<RefEntityType>();
            RefEntryType = new HashSet<RefEntryType>();
            RefEnvironmentSetting = new HashSet<RefEnvironmentSetting>();
            RefEradministrativeDataSource = new HashSet<RefEradministrativeDataSource>();
            RefErsruralUrbanContinuumCode = new HashSet<RefErsruralUrbanContinuumCode>();
            RefExitOrWithdrawalStatus = new HashSet<RefExitOrWithdrawalStatus>();
            RefExitOrWithdrawalType = new HashSet<RefExitOrWithdrawalType>();
            RefFamilyIncomeSource = new HashSet<RefFamilyIncomeSource>();
            RefFederalProgramFundingAllocationType = new HashSet<RefFederalProgramFundingAllocationType>();
            RefFinancialAccountBalanceSheetCode = new HashSet<RefFinancialAccountBalanceSheetCode>();
            RefFinancialAccountCategory = new HashSet<RefFinancialAccountCategory>();
            RefFinancialAccountFundClassification = new HashSet<RefFinancialAccountFundClassification>();
            RefFinancialAccountProgramCode = new HashSet<RefFinancialAccountProgramCode>();
            RefFinancialAccountRevenueCode = new HashSet<RefFinancialAccountRevenueCode>();
            RefFinancialAidApplicationType = new HashSet<RefFinancialAidApplicationType>();
            RefFinancialAidAwardStatus = new HashSet<RefFinancialAidAwardStatus>();
            RefFinancialAidAwardType = new HashSet<RefFinancialAidAwardType>();
            RefFinancialAidVeteransBenefitStatus = new HashSet<RefFinancialAidVeteransBenefitStatus>();
            RefFinancialAidVeteransBenefitType = new HashSet<RefFinancialAidVeteransBenefitType>();
            RefFinancialExpenditureFunctionCode = new HashSet<RefFinancialExpenditureFunctionCode>();
            RefFinancialExpenditureLevelOfInstructionCode = new HashSet<RefFinancialExpenditureLevelOfInstructionCode>();
            RefFinancialExpenditureObjectCode = new HashSet<RefFinancialExpenditureObjectCode>();
            RefFirearmType = new HashSet<RefFirearmType>();
            RefFoodServiceEligibility = new HashSet<RefFoodServiceEligibility>();
            RefFoodServiceParticipation = new HashSet<RefFoodServiceParticipation>();
            RefFrequencyOfService = new HashSet<RefFrequencyOfService>();
            RefFullTimeStatus = new HashSet<RefFullTimeStatus>();
            RefGoalsForAttendingAdultEducation = new HashSet<RefGoalsForAttendingAdultEducation>();
            RefGpaWeightedIndicator = new HashSet<RefGpaWeightedIndicator>();
            RefGradeLevel = new HashSet<RefGradeLevel>();
            RefGradeLevelType = new HashSet<RefGradeLevelType>();
            RefGradePointAverageDomain = new HashSet<RefGradePointAverageDomain>();
            RefGraduateAssistantIpedsCategory = new HashSet<RefGraduateAssistantIpedsCategory>();
            RefGraduateOrDoctoralExamResultsStatus = new HashSet<RefGraduateOrDoctoralExamResultsStatus>();
            RefGunFreeSchoolsActReportingStatus = new HashSet<RefGunFreeSchoolsActReportingStatus>();
            RefHealthInsuranceCoverage = new HashSet<RefHealthInsuranceCoverage>();
            RefHearingScreeningStatus = new HashSet<RefHearingScreeningStatus>();
            RefHigherEducationInstitutionAccreditationStatus = new HashSet<RefHigherEducationInstitutionAccreditationStatus>();
            RefHighSchoolDiplomaDistinctionType = new HashSet<RefHighSchoolDiplomaDistinctionType>();
            RefHighSchoolDiplomaType = new HashSet<RefHighSchoolDiplomaType>();
            RefHighSchoolGraduationRateIndicator = new HashSet<RefHighSchoolGraduationRateIndicator>();
            RefHomelessNighttimeResidence = new HashSet<RefHomelessNighttimeResidence>();
            RefIdeadisciplineMethodFirearm = new HashSet<RefIdeadisciplineMethodFirearm>();
            RefIdeaeducationalEnvironmentEc = new HashSet<RefIdeaeducationalEnvironmentEc>();
            RefIdeaeducationalEnvironmentSchoolAge = new HashSet<RefIdeaeducationalEnvironmentSchoolAge>();
            RefIdeaenvironmentEl = new HashSet<RefIdeaenvironmentEl>();
            RefIdeaiepstatus = new HashSet<RefIdeaiepstatus>();
            RefIdeainterimRemoval = new HashSet<RefIdeainterimRemoval>();
            RefIdeainterimRemovalReason = new HashSet<RefIdeainterimRemovalReason>();
            RefIdeapartCeligibilityCategory = new HashSet<RefIdeapartCeligibilityCategory>();
            RefImmunizationType = new HashSet<RefImmunizationType>();
            RefIncidentBehavior = new HashSet<RefIncidentBehavior>();
            RefIncidentBehaviorSecondary = new HashSet<RefIncidentBehaviorSecondary>();
            RefIncidentInjuryType = new HashSet<RefIncidentInjuryType>();
            RefIncidentLocation = new HashSet<RefIncidentLocation>();
            RefIncidentMultipleOffenseType = new HashSet<RefIncidentMultipleOffenseType>();
            RefIncidentPerpetratorInjuryType = new HashSet<RefIncidentPerpetratorInjuryType>();
            RefIncidentPersonRoleType = new HashSet<RefIncidentPersonRoleType>();
            RefIncidentPersonType = new HashSet<RefIncidentPersonType>();
            RefIncidentReporterType = new HashSet<RefIncidentReporterType>();
            RefIncidentTimeDescriptionCode = new HashSet<RefIncidentTimeDescriptionCode>();
            RefIncomeCalculationMethod = new HashSet<RefIncomeCalculationMethod>();
            RefIncreasedLearningTimeType = new HashSet<RefIncreasedLearningTimeType>();
            RefIndividualizedProgramDateType = new HashSet<RefIndividualizedProgramDateType>();
            RefIndividualizedProgramLocation = new HashSet<RefIndividualizedProgramLocation>();
            RefIndividualizedProgramPlannedServiceType = new HashSet<RefIndividualizedProgramPlannedServiceType>();
            RefIndividualizedProgramTransitionType = new HashSet<RefIndividualizedProgramTransitionType>();
            RefIndividualizedProgramType = new HashSet<RefIndividualizedProgramType>();
            RefInstitutionTelephoneType = new HashSet<RefInstitutionTelephoneType>();
            RefInstructionalActivityHours = new HashSet<RefInstructionalActivityHours>();
            RefInstructionalStaffContractLength = new HashSet<RefInstructionalStaffContractLength>();
            RefInstructionalStaffFacultyTenure = new HashSet<RefInstructionalStaffFacultyTenure>();
            RefInstructionCreditType = new HashSet<RefInstructionCreditType>();
            RefInstructionLocationType = new HashSet<RefInstructionLocationType>();
            RefIntegratedTechnologyStatus = new HashSet<RefIntegratedTechnologyStatus>();
            RefInternetAccess = new HashSet<RefInternetAccess>();
            RefIpedsOccupationalCategory = new HashSet<RefIpedsOccupationalCategory>();
            RefIso6392language = new HashSet<RefIso6392language>();
            RefIso6393language = new HashSet<RefIso6393language>();
            RefIso6395languageFamily = new HashSet<RefIso6395languageFamily>();
            RefItemResponseTheoryDifficultyCategory = new HashSet<RefItemResponseTheoryDifficultyCategory>();
            RefItemResponseTheoryKappaAlgorithm = new HashSet<RefItemResponseTheoryKappaAlgorithm>();
            RefK12endOfCourseRequirement = new HashSet<RefK12endOfCourseRequirement>();
            RefK12leaTitleIsupportService = new HashSet<RefK12leaTitleIsupportService>();
            RefK12responsibilityType = new HashSet<RefK12responsibilityType>();
            RefK12staffClassification = new HashSet<RefK12staffClassification>();
            RefLanguage = new HashSet<RefLanguage>();
            RefLanguageUseType = new HashSet<RefLanguageUseType>();
            RefLeaFundsTransferType = new HashSet<RefLeaFundsTransferType>();
            RefLeaImprovementStatus = new HashSet<RefLeaImprovementStatus>();
            RefLearnerActionType = new HashSet<RefLearnerActionType>();
            RefLearnerActivityMaximumTimeAllowedUnits = new HashSet<RefLearnerActivityMaximumTimeAllowedUnits>();
            RefLearnerActivityType = new HashSet<RefLearnerActivityType>();
            RefLearningResourceAccessApitype = new HashSet<RefLearningResourceAccessApitype>();
            RefLearningResourceAccessHazardType = new HashSet<RefLearningResourceAccessHazardType>();
            RefLearningResourceAccessModeType = new HashSet<RefLearningResourceAccessModeType>();
            RefLearningResourceAccessRightsUrl = new HashSet<RefLearningResourceAccessRightsUrl>();
            RefLearningResourceAuthorType = new HashSet<RefLearningResourceAuthorType>();
            RefLearningResourceBookFormatType = new HashSet<RefLearningResourceBookFormatType>();
            RefLearningResourceCompetencyAlignmentType = new HashSet<RefLearningResourceCompetencyAlignmentType>();
            RefLearningResourceControlFlexibilityType = new HashSet<RefLearningResourceControlFlexibilityType>();
            RefLearningResourceDigitalMediaSubType = new HashSet<RefLearningResourceDigitalMediaSubType>();
            RefLearningResourceDigitalMediaType = new HashSet<RefLearningResourceDigitalMediaType>();
            RefLearningResourceEducationalUse = new HashSet<RefLearningResourceEducationalUse>();
            RefLearningResourceIntendedEndUserRole = new HashSet<RefLearningResourceIntendedEndUserRole>();
            RefLearningResourceInteractionMode = new HashSet<RefLearningResourceInteractionMode>();
            RefLearningResourceInteractivityType = new HashSet<RefLearningResourceInteractivityType>();
            RefLearningResourceMediaFeatureType = new HashSet<RefLearningResourceMediaFeatureType>();
            RefLearningResourcePhysicalMediaType = new HashSet<RefLearningResourcePhysicalMediaType>();
            RefLearningResourceType = new HashSet<RefLearningResourceType>();
            RefLearningStandardDocumentPublicationStatus = new HashSet<RefLearningStandardDocumentPublicationStatus>();
            RefLearningStandardItemAssociationType = new HashSet<RefLearningStandardItemAssociationType>();
            RefLearningStandardItemNodeAccessibilityProfile = new HashSet<RefLearningStandardItemNodeAccessibilityProfile>();
            RefLearningStandardItemTestabilityType = new HashSet<RefLearningStandardItemTestabilityType>();
            RefLeaType = new HashSet<RefLeaType>();
            RefLeaveEventType = new HashSet<RefLeaveEventType>();
            RefLevelOfInstitution = new HashSet<RefLevelOfInstitution>();
            RefLicenseExempt = new HashSet<RefLicenseExempt>();
            RefLiteracyAssessment = new HashSet<RefLiteracyAssessment>();
            RefMagnetSpecialProgram = new HashSet<RefMagnetSpecialProgram>();
            RefMedicalAlertIndicator = new HashSet<RefMedicalAlertIndicator>();
            RefMepEnrollmentType = new HashSet<RefMepEnrollmentType>();
            RefMepProjectBased = new HashSet<RefMepProjectBased>();
            RefMepProjectType = new HashSet<RefMepProjectType>();
            RefMepServiceType = new HashSet<RefMepServiceType>();
            RefMepSessionType = new HashSet<RefMepSessionType>();
            RefMepStaffCategory = new HashSet<RefMepStaffCategory>();
            RefMethodOfServiceDelivery = new HashSet<RefMethodOfServiceDelivery>();
            RefMilitaryActiveStudentIndicator = new HashSet<RefMilitaryActiveStudentIndicator>();
            RefMilitaryBranch = new HashSet<RefMilitaryBranch>();
            RefMilitaryConnectedStudentIndicator = new HashSet<RefMilitaryConnectedStudentIndicator>();
            RefMilitaryVeteranStudentIndicator = new HashSet<RefMilitaryVeteranStudentIndicator>();
            RefMultipleIntelligenceType = new HashSet<RefMultipleIntelligenceType>();
            RefNaepAspectsOfReading = new HashSet<RefNaepAspectsOfReading>();
            RefNaepMathComplexityLevel = new HashSet<RefNaepMathComplexityLevel>();
            RefNcescollegeCourseMapCode = new HashSet<RefNcescollegeCourseMapCode>();
            RefNeedDeterminationMethod = new HashSet<RefNeedDeterminationMethod>();
            RefNeglectedProgramType = new HashSet<RefNeglectedProgramType>();
            RefNonPromotionReason = new HashSet<RefNonPromotionReason>();
            RefNonTraditionalGenderStatus = new HashSet<RefNonTraditionalGenderStatus>();
            RefOperationalStatus = new HashSet<RefOperationalStatus>();
            RefOperationalStatusType = new HashSet<RefOperationalStatusType>();
            RefOrganizationElementType = new HashSet<RefOrganizationElementType>();
            RefOrganizationIdentificationSystem = new HashSet<RefOrganizationIdentificationSystem>();
            RefOrganizationIdentifierType = new HashSet<RefOrganizationIdentifierType>();
            RefOrganizationIndicator = new HashSet<RefOrganizationIndicator>();
            RefOrganizationLocationType = new HashSet<RefOrganizationLocationType>();
            RefOrganizationMonitoringNotifications = new HashSet<RefOrganizationMonitoringNotifications>();
            RefOrganizationRelationship = new HashSet<RefOrganizationRelationship>();
            RefOrganizationType = new HashSet<RefOrganizationType>();
            RefOtherNameType = new HashSet<RefOtherNameType>();
            RefOutcomeTimePoint = new HashSet<RefOutcomeTimePoint>();
			RefOutOfFieldStatus = new HashSet<RefOutOfFieldStatus>();
			RefParaprofessionalQualification = new HashSet<RefParaprofessionalQualification>();
            RefParticipationStatusAyp = new HashSet<RefParticipationStatusAyp>();
            RefParticipationType = new HashSet<RefParticipationType>();
            RefPdactivityApprovedPurpose = new HashSet<RefPdactivityApprovedPurpose>();
            RefPdactivityCreditType = new HashSet<RefPdactivityCreditType>();
            RefPdactivityEducationLevelsAddressed = new HashSet<RefPdactivityEducationLevelsAddressed>();
            RefPdactivityLevel = new HashSet<RefPdactivityLevel>();
            RefPdactivityTargetAudience = new HashSet<RefPdactivityTargetAudience>();
            RefPdactivityType = new HashSet<RefPdactivityType>();
            RefPdaudienceType = new HashSet<RefPdaudienceType>();
            RefPddeliveryMethod = new HashSet<RefPddeliveryMethod>();
            RefPdinstructionalDeliveryMode = new HashSet<RefPdinstructionalDeliveryMode>();
            RefPdsessionStatus = new HashSet<RefPdsessionStatus>();
            RefPersonalInformationVerification = new HashSet<RefPersonalInformationVerification>();
            RefPersonIdentificationSystem = new HashSet<RefPersonIdentificationSystem>();
            RefPersonIdentifierType = new HashSet<RefPersonIdentifierType>();
            RefPersonLocationType = new HashSet<RefPersonLocationType>();
            RefPersonRelationship = new HashSet<RefPersonRelationship>();
            RefPersonStatusType = new HashSet<RefPersonStatusType>();
            RefPersonTelephoneNumberType = new HashSet<RefPersonTelephoneNumberType>();
            RefPopulationServed = new HashSet<RefPopulationServed>();
            RefPreAndPostTestIndicator = new HashSet<RefPreAndPostTestIndicator>();
            RefPredominantCalendarSystem = new HashSet<RefPredominantCalendarSystem>();
            RefPreKeligibleAgesNonIdea = new HashSet<RefPreKeligibleAgesNonIdea>();
            RefPrekindergartenEligibility = new HashSet<RefPrekindergartenEligibility>();
            RefPresentAttendanceCategory = new HashSet<RefPresentAttendanceCategory>();
            RefProfessionalDevelopmentFinancialSupport = new HashSet<RefProfessionalDevelopmentFinancialSupport>();
            RefProfessionalEducationJobClassification = new HashSet<RefProfessionalEducationJobClassification>();
            RefProfessionalTechnicalCredentialType = new HashSet<RefProfessionalTechnicalCredentialType>();
            RefProficiencyStatus = new HashSet<RefProficiencyStatus>();
            RefProficiencyTargetAyp = new HashSet<RefProficiencyTargetAyp>();
            RefProgramDayLength = new HashSet<RefProgramDayLength>();
            RefProgramExitReason = new HashSet<RefProgramExitReason>();
            RefProgramGiftedEligibility = new HashSet<RefProgramGiftedEligibility>();
            RefProgramLengthHoursType = new HashSet<RefProgramLengthHoursType>();
            RefProgramSponsorType = new HashSet<RefProgramSponsorType>();
            RefProgramType = new HashSet<RefProgramType>();
            RefProgressLevel = new HashSet<RefProgressLevel>();
            RefPromotionReason = new HashSet<RefPromotionReason>();
            RefProofOfResidencyType = new HashSet<RefProofOfResidencyType>();
            RefPsEnrollmentAction = new HashSet<RefPsEnrollmentAction>();
            RefPsEnrollmentAwardType = new HashSet<RefPsEnrollmentAwardType>();
            RefPsEnrollmentStatus = new HashSet<RefPsEnrollmentStatus>();
            RefPsEnrollmentType = new HashSet<RefPsEnrollmentType>();
            RefPsexitOrWithdrawalType = new HashSet<RefPsexitOrWithdrawalType>();
            RefPsLepType = new HashSet<RefPsLepType>();
            RefPsprogramLevel = new HashSet<RefPsprogramLevel>();
            RefPsStudentLevel = new HashSet<RefPsStudentLevel>();
            RefPublicSchoolChoiceStatus = new HashSet<RefPublicSchoolChoiceStatus>();
            RefPublicSchoolResidence = new HashSet<RefPublicSchoolResidence>();
            RefPurposeOfMonitoringVisit = new HashSet<RefPurposeOfMonitoringVisit>();
            RefQrisParticipation = new HashSet<RefQrisParticipation>();
            RefRace = new HashSet<RefRace>();
            RefReapAlternativeFundingStatus = new HashSet<RefReapAlternativeFundingStatus>();
            RefReasonDelayTransitionConf = new HashSet<RefReasonDelayTransitionConf>();
            RefReconstitutedStatus = new HashSet<RefReconstitutedStatus>();
            RefReferralOutcome = new HashSet<RefReferralOutcome>();
            RefReimbursementType = new HashSet<RefReimbursementType>();
            RefRestructuringAction = new HashSet<RefRestructuringAction>();
            RefRlisProgramUse = new HashSet<RefRlisProgramUse>();
            RefRoleStatus = new HashSet<RefRoleStatus>();
            RefRoleStatusType = new HashSet<RefRoleStatusType>();
            RefScedcourseLevel = new HashSet<RefScedcourseLevel>();
            RefScedcourseSubjectArea = new HashSet<RefScedcourseSubjectArea>();
            RefScheduledWellChildScreening = new HashSet<RefScheduledWellChildScreening>();
            RefSchoolFoodServiceProgram = new HashSet<RefSchoolFoodServiceProgram>();
            RefSchoolImprovementFunds = new HashSet<RefSchoolImprovementFunds>();
            RefSchoolImprovementStatus = new HashSet<RefSchoolImprovementStatus>();
            RefSchoolLevel = new HashSet<RefSchoolLevel>();
            RefSchoolType = new HashSet<RefSchoolType>();
            RefScoreMetricType = new HashSet<RefScoreMetricType>();
            RefServiceFrequency = new HashSet<RefServiceFrequency>();
            RefServiceOption = new HashSet<RefServiceOption>();
            RefServices = new HashSet<RefServices>();
            RefSessionType = new HashSet<RefSessionType>();
            RefSex = new HashSet<RefSex>();
            RefSigInterventionType = new HashSet<RefSigInterventionType>();
            RefSingleSexClassStatus = new HashSet<RefSingleSexClassStatus>();
            RefSpaceUseType = new HashSet<RefSpaceUseType>();
            RefSpecialEducationAgeGroupTaught = new HashSet<RefSpecialEducationAgeGroupTaught>();
            RefSpecialEducationExitReason = new HashSet<RefSpecialEducationExitReason>();
            RefSpecialEducationStaffCategory = new HashSet<RefSpecialEducationStaffCategory>();
            RefStaffPerformanceLevel = new HashSet<RefStaffPerformanceLevel>();
            RefStandardizedAdmissionTest = new HashSet<RefStandardizedAdmissionTest>();
            RefState = new HashSet<RefState>();
            RefStatePovertyDesignation = new HashSet<RefStatePovertyDesignation>();
            RefStudentSupportServiceType = new HashSet<RefStudentSupportServiceType>();
            RefSupervisedClinicalExperience = new HashSet<RefSupervisedClinicalExperience>();
			RefTargetedSupport = new HashSet<RefTargetedSupport>();
            RefTargetedSupportImprovement = new HashSet<RefTargetedSupportImprovement>();
            RefTeacherEducationCredentialExam = new HashSet<RefTeacherEducationCredentialExam>();
            RefTeacherEducationExamScoreType = new HashSet<RefTeacherEducationExamScoreType>();
            RefTeacherEducationTestCompany = new HashSet<RefTeacherEducationTestCompany>();
            RefTeacherPrepCompleterStatus = new HashSet<RefTeacherPrepCompleterStatus>();
            RefTeacherPrepEnrollmentStatus = new HashSet<RefTeacherPrepEnrollmentStatus>();
            RefTeachingAssignmentRole = new HashSet<RefTeachingAssignmentRole>();
            RefTeachingCredentialBasis = new HashSet<RefTeachingCredentialBasis>();
            RefTeachingCredentialType = new HashSet<RefTeachingCredentialType>();
            RefTechnicalAssistanceDeliveryType = new HashSet<RefTechnicalAssistanceDeliveryType>();
            RefTechnicalAssistanceType = new HashSet<RefTechnicalAssistanceType>();
            RefTechnologyLiteracyStatus = new HashSet<RefTechnologyLiteracyStatus>();
            RefTelephoneNumberType = new HashSet<RefTelephoneNumberType>();
            RefTenureSystem = new HashSet<RefTenureSystem>();
            RefTextComplexitySystem = new HashSet<RefTextComplexitySystem>();
            RefTimeForCompletionUnits = new HashSet<RefTimeForCompletionUnits>();
            RefTitleIiiaccountability = new HashSet<RefTitleIiiaccountability>();
            RefTitleIiilanguageInstructionProgramType = new HashSet<RefTitleIiilanguageInstructionProgramType>();
            RefTitleIiiprofessionalDevelopmentType = new HashSet<RefTitleIiiprofessionalDevelopmentType>();
            RefTitleIindicator = new HashSet<RefTitleIindicator>();
            RefTitleIinstructionalServices = new HashSet<RefTitleIinstructionalServices>();
            RefTitleIprogramStaffCategory = new HashSet<RefTitleIprogramStaffCategory>();
            RefTitleIprogramType = new HashSet<RefTitleIprogramType>();
            RefTitleIschoolStatus = new HashSet<RefTitleIschoolStatus>();
            RefTransferOutIndicator = new HashSet<RefTransferOutIndicator>();
            RefTransferReady = new HashSet<RefTransferReady>();
            RefTribalAffiliation = new HashSet<RefTribalAffiliation>();
            RefTrimesterWhenPrenatalCareBegan = new HashSet<RefTrimesterWhenPrenatalCareBegan>();
            RefTuitionResidencyType = new HashSet<RefTuitionResidencyType>();
            RefTuitionUnit = new HashSet<RefTuitionUnit>();
			RefUnexperiencedStatus = new HashSet<RefUnexperiencedStatus>();
			RefUscitizenshipStatus = new HashSet<RefUscitizenshipStatus>();
            RefVisaType = new HashSet<RefVisaType>();
            RefVisionScreeningStatus = new HashSet<RefVisionScreeningStatus>();
            RefWageCollectionMethod = new HashSet<RefWageCollectionMethod>();
            RefWageVerification = new HashSet<RefWageVerification>();
            RefWeaponType = new HashSet<RefWeaponType>();
            RefWfProgramParticipation = new HashSet<RefWfProgramParticipation>();
            RefWorkbasedLearningOpportunityType = new HashSet<RefWorkbasedLearningOpportunityType>();
            RequiredImmunization = new HashSet<RequiredImmunization>();
            Role = new HashSet<Role>();
            RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus = new HashSet<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus>();

			RefIndicatorStatusType = new HashSet<RefIndicatorStatusType>();
			RefIndicatorStatusSubgroupType = new HashSet<RefIndicatorStatusSubgroupType>();
			RefIndicatorStateDefinedStatus = new HashSet<RefIndicatorStateDefinedStatus>();
			RefIndicatorStatusCustomType = new HashSet<RefIndicatorStatusCustomType>();
            RefCharterSchoolAuthorizerType = new HashSet<RefCharterSchoolAuthorizerType>();
            RefCharterSchoolManagementOrganizationType = new HashSet<RefCharterSchoolManagementOrganizationType>();
            RefNSLPStatus = new HashSet<RefNSLPStatus>();
            RefSchoolDangerousStatus = new HashSet<RefSchoolDangerousStatus>();

        }

        public int OrganizationId { get; set; }

        public virtual Activity Activity { get; set; }
        public virtual AeProvider AeProvider { get; set; }
        public virtual ICollection<K12CharterSchoolAuthorizer> K12CharterSchoolAuthorizer { get; set; }
        public virtual ICollection<K12CharterSchoolManagementOrganization> K12CharterSchoolManagementOrganization { get; set; }
        public virtual ICollection<AssessmentAdministrationOrganization> AssessmentAdministrationOrganization { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationLeaOrganization { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationOrganization { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistrationSchoolOrganization { get; set; }
        public virtual ICollection<AssessmentSession> AssessmentSessionLeaOrganization { get; set; }
        public virtual ICollection<AssessmentSession> AssessmentSessionOrganization { get; set; }
        public virtual ICollection<AssessmentSession> AssessmentSessionSchoolOrganization { get; set; }
        public virtual Course Course { get; set; }
        public virtual CourseSection CourseSection { get; set; }
        public virtual ICollection<EarlyChildhoodProgramTypeOffered> EarlyChildhoodProgramTypeOffered { get; set; }
        public virtual ElclassSection ElclassSection { get; set; }
        public virtual ICollection<ElfacilityLicensing> ElfacilityLicensing { get; set; }
        public virtual ElorganizationAvailability ElorganizationAvailability { get; set; }
        public virtual ElorganizationFunds ElorganizationFunds { get; set; }
        public virtual ICollection<ElorganizationMonitoring> ElorganizationMonitoring { get; set; }
        public virtual ICollection<ElprogramLicensing> ElprogramLicensing { get; set; }
        public virtual ICollection<ElqualityInitiative> ElqualityInitiative { get; set; }
        public virtual ICollection<ElqualityRatingImprovement> ElqualityRatingImprovement { get; set; }
        public virtual ElservicePartner ElservicePartner { get; set; }
        public virtual K12lea K12lea { get; set; }
        public virtual K12programOrService K12programOrService { get; set; }
        public virtual ICollection<K12school> K12school { get; set; }
        public virtual K12sea K12sea { get; set; }
        public virtual ICollection<K12titleIiilanguageInstruction> K12titleIiilanguageInstruction { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivityLeaOrganization { get; set; }
        public virtual ICollection<LearnerActivity> LearnerActivitySchoolOrganization { get; set; }
        public virtual ICollection<OrganizationAccreditation> OrganizationAccreditation { get; set; }
        public virtual ICollection<OrganizationCalendar> OrganizationCalendar { get; set; }
        public virtual ICollection<OrganizationCalendarCrisis> OrganizationCalendarCrisis { get; set; }
        public virtual ICollection<OrganizationDetail> OrganizationDetail { get; set; }
        public virtual ICollection<OrganizationEmail> OrganizationEmail { get; set; }
        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountability { get; set; }
        public virtual ICollection<OrganizationIdentifier> OrganizationIdentifier { get; set; }
        public virtual ICollection<OrganizationIndicator> OrganizationIndicator { get; set; }
        public virtual ICollection<OrganizationLocation> OrganizationLocation { get; set; }
        public virtual ICollection<OrganizationOperationalStatus> OrganizationOperationalStatus { get; set; }
        public virtual ICollection<OrganizationPersonRole> OrganizationPersonRole { get; set; }
        public virtual ICollection<OrganizationPolicy> OrganizationPolicy { get; set; }
        public virtual ICollection<OrganizationProgramType> OrganizationProgramType { get; set; }
        public virtual ICollection<OrganizationRelationship> OrganizationRelationshipOrganization { get; set; }
        public virtual ICollection<OrganizationRelationship> OrganizationRelationshipParentOrganization { get; set; }
        public virtual ICollection<OrganizationTechnicalAssistance> OrganizationTechnicalAssistance { get; set; }
        public virtual ICollection<OrganizationTelephone> OrganizationTelephone { get; set; }
        public virtual OrganizationWebsite OrganizationWebsite { get; set; }
        public virtual Program Program { get; set; }
        public virtual ICollection<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual PsInstitution PsInstitution { get; set; }
        public virtual ICollection<PsProgram> PsProgram { get; set; }
        public virtual ICollection<RefAbsentAttendanceCategory> RefAbsentAttendanceCategory { get; set; }
        public virtual ICollection<RefAcademicAwardLevel> RefAcademicAwardLevel { get; set; }
        public virtual ICollection<RefAcademicHonorType> RefAcademicHonorType { get; set; }
        public virtual ICollection<RefAcademicRank> RefAcademicRank { get; set; }
        public virtual ICollection<RefAcademicSubject> RefAcademicSubject { get; set; }
        public virtual ICollection<RefAcademicTermDesignator> RefAcademicTermDesignator { get; set; }
        public virtual ICollection<RefAccommodationsNeededType> RefAccommodationsNeededType { get; set; }
        public virtual ICollection<RefAccreditationAgency> RefAccreditationAgency { get; set; }
        public virtual ICollection<RefActivityRecognitionType> RefActivityRecognitionType { get; set; }
        public virtual ICollection<RefActivityTimeMeasurementType> RefActivityTimeMeasurementType { get; set; }
        public virtual ICollection<RefAdditionalCreditType> RefAdditionalCreditType { get; set; }
        public virtual ICollection<RefAdditionalTargetedSupport> RefAdditionalTargetedSupport { get; set; }
        public virtual ICollection<RefAddressType> RefAddressType { get; set; }
        public virtual ICollection<RefAdministrativeFundingControl> RefAdministrativeFundingControl { get; set; }        
        public virtual ICollection<RefAdmissionConsiderationLevel> RefAdmissionConsiderationLevel { get; set; }
        public virtual ICollection<RefAdmissionConsiderationType> RefAdmissionConsiderationType { get; set; }
        public virtual ICollection<RefAdmittedStudent> RefAdmittedStudent { get; set; }
        public virtual ICollection<RefAdvancedPlacementCourseCode> RefAdvancedPlacementCourseCode { get; set; }
        public virtual ICollection<RefAeCertificationType> RefAeCertificationType { get; set; }
        public virtual ICollection<RefAeFunctioningLevelAtIntake> RefAeFunctioningLevelAtIntake { get; set; }
        public virtual ICollection<RefAeFunctioningLevelAtPosttest> RefAeFunctioningLevelAtPosttest { get; set; }
        public virtual ICollection<RefAeInstructionalProgramType> RefAeInstructionalProgramType { get; set; }
        public virtual ICollection<RefAePostsecondaryTransitionAction> RefAePostsecondaryTransitionAction { get; set; }
        public virtual ICollection<RefAeSpecialProgramType> RefAeSpecialProgramType { get; set; }
        public virtual ICollection<RefAeStaffClassification> RefAeStaffClassification { get; set; }
        public virtual ICollection<RefAeStaffEmploymentStatus> RefAeStaffEmploymentStatus { get; set; }
        public virtual ICollection<RefAllergySeverity> RefAllergySeverity { get; set; }
        public virtual ICollection<RefAllergyType> RefAllergyType { get; set; }
        public virtual ICollection<RefAlternateFundUses> RefAlternateFundUses { get; set; }
        public virtual ICollection<RefAlternativeSchoolFocus> RefAlternativeSchoolFocus { get; set; }
        public virtual ICollection<RefAltRouteToCertificationOrLicensure> RefAltRouteToCertificationOrLicensure { get; set; }
        public virtual ICollection<RefAmaoAttainmentStatus> RefAmaoAttainmentStatus { get; set; }
        public virtual ICollection<RefApipInteractionType> RefApipInteractionType { get; set; }
        public virtual ICollection<RefAssessmentAccommodationType> RefAssessmentAccommodationType { get; set; }
        public virtual ICollection<RefAssessmentAssetIdentifierType> RefAssessmentAssetIdentifierType { get; set; }
        public virtual ICollection<RefAssessmentAssetType> RefAssessmentAssetType { get; set; }
        public virtual ICollection<RefAssessmentEldevelopmentalDomain> RefAssessmentEldevelopmentalDomain { get; set; }
        public virtual ICollection<RefAssessmentFormSectionIdentificationSystem> RefAssessmentFormSectionIdentificationSystem { get; set; }
        public virtual ICollection<RefAssessmentItemCharacteristicType> RefAssessmentItemCharacteristicType { get; set; }
        public virtual ICollection<RefAssessmentItemResponseScoreStatus> RefAssessmentItemResponseScoreStatus { get; set; }
        public virtual ICollection<RefAssessmentItemResponseStatus> RefAssessmentItemResponseStatus { get; set; }
        public virtual ICollection<RefAssessmentItemType> RefAssessmentItemType { get; set; }
        public virtual ICollection<RefAssessmentNeedAlternativeRepresentationType> RefAssessmentNeedAlternativeRepresentationType { get; set; }
        public virtual ICollection<RefAssessmentNeedBrailleGradeType> RefAssessmentNeedBrailleGradeType { get; set; }
        public virtual ICollection<RefAssessmentNeedBrailleMarkType> RefAssessmentNeedBrailleMarkType { get; set; }
        public virtual ICollection<RefAssessmentNeedBrailleStatusCellType> RefAssessmentNeedBrailleStatusCellType { get; set; }
        public virtual ICollection<RefAssessmentNeedHazardType> RefAssessmentNeedHazardType { get; set; }
        public virtual ICollection<RefAssessmentNeedIncreasedWhitespacingType> RefAssessmentNeedIncreasedWhitespacingType { get; set; }
        public virtual ICollection<RefAssessmentNeedLanguageLearnerType> RefAssessmentNeedLanguageLearnerType { get; set; }
        public virtual ICollection<RefAssessmentNeedMaskingType> RefAssessmentNeedMaskingType { get; set; }
        public virtual ICollection<RefAssessmentNeedNumberOfBrailleDots> RefAssessmentNeedNumberOfBrailleDots { get; set; }
        public virtual ICollection<RefAssessmentNeedSigningType> RefAssessmentNeedSigningType { get; set; }
        public virtual ICollection<RefAssessmentNeedSpokenSourcePreferenceType> RefAssessmentNeedSpokenSourcePreferenceType { get; set; }
        public virtual ICollection<RefAssessmentNeedSupportTool> RefAssessmentNeedSupportTool { get; set; }
        public virtual ICollection<RefAssessmentNeedUsageType> RefAssessmentNeedUsageType { get; set; }
        public virtual ICollection<RefAssessmentNeedUserSpokenPreferenceType> RefAssessmentNeedUserSpokenPreferenceType { get; set; }
        public virtual ICollection<RefAssessmentParticipationIndicator> RefAssessmentParticipationIndicator { get; set; }
        public virtual ICollection<RefAssessmentPlatformType> RefAssessmentPlatformType { get; set; }
        public virtual ICollection<RefAssessmentPretestOutcome> RefAssessmentPretestOutcome { get; set; }
        public virtual ICollection<RefAssessmentPurpose> RefAssessmentPurpose { get; set; }
        public virtual ICollection<RefAssessmentReasonNotCompleting> RefAssessmentReasonNotCompleting { get; set; }
        public virtual ICollection<RefAssessmentReasonNotTested> RefAssessmentReasonNotTested { get; set; }
        public virtual ICollection<RefAssessmentRegistrationCompletionStatus> RefAssessmentRegistrationCompletionStatus { get; set; }
        public virtual ICollection<RefAssessmentReportingMethod> RefAssessmentReportingMethod { get; set; }
        public virtual ICollection<RefAssessmentResultDataType> RefAssessmentResultDataType { get; set; }
        public virtual ICollection<RefAssessmentResultScoreType> RefAssessmentResultScoreType { get; set; }
        public virtual ICollection<RefAssessmentSessionSpecialCircumstanceType> RefAssessmentSessionSpecialCircumstanceType { get; set; }
        public virtual ICollection<RefAssessmentSessionStaffRoleType> RefAssessmentSessionStaffRoleType { get; set; }
        public virtual ICollection<RefAssessmentSessionType> RefAssessmentSessionType { get; set; }
        public virtual ICollection<RefAssessmentSubtestIdentifierType> RefAssessmentSubtestIdentifierType { get; set; }
        public virtual ICollection<RefAssessmentType> RefAssessmentType { get; set; }
        public virtual ICollection<RefAssessmentTypeChildrenWithDisabilities> RefAssessmentTypeChildrenWithDisabilities { get; set; }
        public virtual ICollection<RefAttendanceEventType> RefAttendanceEventType { get; set; }
        public virtual ICollection<RefAttendanceStatus> RefAttendanceStatus { get; set; }
        public virtual ICollection<RefAypStatus> RefAypStatus { get; set; }
        public virtual ICollection<RefBarrierToEducatingHomeless> RefBarrierToEducatingHomeless { get; set; }
        public virtual ICollection<RefBillableBasisType> RefBillableBasisType { get; set; }
        public virtual ICollection<RefBlendedLearningModelType> RefBlendedLearningModelType { get; set; }
        public virtual ICollection<RefBloomsTaxonomyDomain> RefBloomsTaxonomyDomain { get; set; }
        public virtual ICollection<RefBuildingUseType> RefBuildingUseType { get; set; }
        public virtual ICollection<RefCalendarEventType> RefCalendarEventType { get; set; }
        public virtual ICollection<RefCampusResidencyType> RefCampusResidencyType { get; set; }
        public virtual ICollection<RefCareerCluster> RefCareerCluster { get; set; }
        public virtual ICollection<RefCareerEducationPlanType> RefCareerEducationPlanType { get; set; }
        public virtual ICollection<RefCarnegieBasicClassification> RefCarnegieBasicClassification { get; set; }
        public virtual ICollection<RefCharterSchoolAuthorizerType> RefCharterSchoolAuthorizerType { get; set; }
        public virtual ICollection<RefCharterSchoolManagementOrganizationType> RefCharterSchoolManagementOrganizationType { get; set; }
        public virtual ICollection<RefCharterSchoolType> RefCharterSchoolType { get; set; }
        public virtual ICollection<RefChildDevelopmentalScreeningStatus> RefChildDevelopmentalScreeningStatus { get; set; }
        public virtual ICollection<RefChildDevelopmentAssociateType> RefChildDevelopmentAssociateType { get; set; }
        public virtual ICollection<RefChildOutcomesSummaryRating> RefChildOutcomesSummaryRating { get; set; }
        public virtual ICollection<RefCipCode> RefCipCode { get; set; }
        public virtual ICollection<RefCipUse> RefCipUse { get; set; }
        public virtual ICollection<RefCipVersion> RefCipVersion { get; set; }
        public virtual ICollection<RefClassroomPositionType> RefClassroomPositionType { get; set; }
        public virtual ICollection<RefCohortExclusion> RefCohortExclusion { get; set; }
        public virtual ICollection<RefCommunicationMethod> RefCommunicationMethod { get; set; }
        public virtual ICollection<RefCommunityBasedType> RefCommunityBasedType { get; set; }
        public virtual ICollection<RefCompetencySetCompletionCriteria> RefCompetencySetCompletionCriteria { get; set; }
		public virtual ICollection<RefComprehensiveSupport> RefComprehensiveSupport { get; set; }
		public virtual ICollection<RefComprehensiveAndTargetedSupport> RefComprehensiveAndTargetedSupport { get; set; }
        public virtual ICollection<RefComprehensiveSupportImprovement> RefComprehensiveSupportImprovement { get; set; }
        public virtual ICollection<RefContentStandardType> RefContentStandardType { get; set; }
        public virtual ICollection<RefContinuationOfServices> RefContinuationOfServices { get; set; }
        public virtual ICollection<RefControlOfInstitution> RefControlOfInstitution { get; set; }
        public virtual ICollection<RefCoreKnowledgeArea> RefCoreKnowledgeArea { get; set; }
        public virtual ICollection<RefCorrectionalEducationFacilityType> RefCorrectionalEducationFacilityType { get; set; }
        public virtual ICollection<RefCorrectiveActionType> RefCorrectiveActionType { get; set; }
        public virtual ICollection<RefCountry> RefCountry { get; set; }
        public virtual ICollection<RefCounty> RefCounty { get; set; }
        public virtual ICollection<RefCourseAcademicGradeStatusCode> RefCourseAcademicGradeStatusCode { get; set; }
        public virtual ICollection<RefCourseApplicableEducationLevel> RefCourseApplicableEducationLevel { get; set; }
        public virtual ICollection<RefCourseCreditBasisType> RefCourseCreditBasisType { get; set; }
        public virtual ICollection<RefCourseCreditLevelType> RefCourseCreditLevelType { get; set; }
        public virtual ICollection<RefCourseCreditUnit> RefCourseCreditUnit { get; set; }
        public virtual ICollection<RefCourseGpaApplicability> RefCourseGpaApplicability { get; set; }
        public virtual ICollection<RefCourseHonorsType> RefCourseHonorsType { get; set; }
        public virtual ICollection<RefCourseInstructionMethod> RefCourseInstructionMethod { get; set; }
        public virtual ICollection<RefCourseInstructionSiteType> RefCourseInstructionSiteType { get; set; }
        public virtual ICollection<RefCourseInteractionMode> RefCourseInteractionMode { get; set; }
        public virtual ICollection<RefCourseLevelCharacteristic> RefCourseLevelCharacteristic { get; set; }
        public virtual ICollection<RefCourseLevelType> RefCourseLevelType { get; set; }
        public virtual ICollection<RefCourseRepeatCode> RefCourseRepeatCode { get; set; }
        public virtual ICollection<RefCourseSectionAssessmentReportingMethod> RefCourseSectionAssessmentReportingMethod { get; set; }
        public virtual ICollection<RefCourseSectionDeliveryMode> RefCourseSectionDeliveryMode { get; set; }
        public virtual ICollection<RefCourseSectionEnrollmentStatusType> RefCourseSectionEnrollmentStatusType { get; set; }
        public virtual ICollection<RefCourseSectionEntryType> RefCourseSectionEntryType { get; set; }
        public virtual ICollection<RefCourseSectionExitType> RefCourseSectionExitType { get; set; }
        public virtual ICollection<RefCredentialType> RefCredentialType { get; set; }
        public virtual ICollection<RefCreditHoursAppliedOtherProgram> RefCreditHoursAppliedOtherProgram { get; set; }
        public virtual ICollection<RefCreditTypeEarned> RefCreditTypeEarned { get; set; }
        public virtual ICollection<RefCriticalTeacherShortageCandidate> RefCriticalTeacherShortageCandidate { get; set; }
        public virtual ICollection<RefCteGraduationRateInclusion> RefCteGraduationRateInclusion { get; set; }
        public virtual ICollection<RefCteNonTraditionalGenderStatus> RefCteNonTraditionalGenderStatus { get; set; }
        public virtual ICollection<RefCurriculumFrameworkType> RefCurriculumFrameworkType { get; set; }
        public virtual ICollection<RefDegreeOrCertificateType> RefDegreeOrCertificateType { get; set; }
        public virtual ICollection<RefDentalInsuranceCoverageType> RefDentalInsuranceCoverageType { get; set; }
        public virtual ICollection<RefDentalScreeningStatus> RefDentalScreeningStatus { get; set; }
        public virtual ICollection<RefDependencyStatus> RefDependencyStatus { get; set; }
        public virtual ICollection<RefDevelopmentalEducationReferralStatus> RefDevelopmentalEducationReferralStatus { get; set; }
        public virtual ICollection<RefDevelopmentalEducationType> RefDevelopmentalEducationType { get; set; }
        public virtual ICollection<RefDevelopmentalEvaluationFinding> RefDevelopmentalEvaluationFinding { get; set; }
        public virtual ICollection<RefDirectoryInformationBlockStatus> RefDirectoryInformationBlockStatus { get; set; }
        public virtual ICollection<RefDisabilityConditionStatusCode> RefDisabilityConditionStatusCode { get; set; }
        public virtual ICollection<RefDisabilityConditionType> RefDisabilityConditionType { get; set; }
        public virtual ICollection<RefDisabilityDeterminationSourceType> RefDisabilityDeterminationSourceType { get; set; }
        public virtual ICollection<RefDisabilityType> RefDisabilityType { get; set; }
        public virtual ICollection<RefDisciplinaryActionTaken> RefDisciplinaryActionTaken { get; set; }
        public virtual ICollection<RefDisciplineLengthDifferenceReason> RefDisciplineLengthDifferenceReason { get; set; }
        public virtual ICollection<RefDisciplineMethodFirearms> RefDisciplineMethodFirearms { get; set; }
        public virtual ICollection<RefDisciplineMethodOfCwd> RefDisciplineMethodOfCwd { get; set; }
        public virtual ICollection<RefDisciplineReason> RefDisciplineReason { get; set; }
        public virtual ICollection<RefDistanceEducationCourseEnrollment> RefDistanceEducationCourseEnrollment { get; set; }
        public virtual ICollection<RefDoctoralExamsRequiredCode> RefDoctoralExamsRequiredCode { get; set; }
        public virtual ICollection<RefDqpcategoriesOfLearning> RefDqpcategoriesOfLearning { get; set; }
        public virtual ICollection<RefEarlyChildhoodCredential> RefEarlyChildhoodCredential { get; set; }
        public virtual ICollection<RefEarlyChildhoodProgramEnrollmentType> RefEarlyChildhoodProgramEnrollmentType { get; set; }
        public virtual ICollection<RefEarlyChildhoodServices> RefEarlyChildhoodServices { get; set; }
        public virtual ICollection<RefEducationLevel> RefEducationLevel { get; set; }
        public virtual ICollection<RefEducationLevelType> RefEducationLevelType { get; set; }
        public virtual ICollection<RefEducationVerificationMethod> RefEducationVerificationMethod { get; set; }
        public virtual ICollection<RefEleducationStaffClassification> RefEleducationStaffClassification { get; set; }
        public virtual ICollection<RefElementaryMiddleAdditional> RefElementaryMiddleAdditional { get; set; }
        public virtual ICollection<RefElemploymentSeparationReason> RefElemploymentSeparationReason { get; set; }
        public virtual ICollection<RefElfacilityLicensingStatus> RefElfacilityLicensingStatus { get; set; }
        public virtual ICollection<RefElfederalFundingType> RefElfederalFundingType { get; set; }
        public virtual ICollection<RefElgroupSizeStandardMet> RefElgroupSizeStandardMet { get; set; }
        public virtual ICollection<RefEllevelOfSpecialization> RefEllevelOfSpecialization { get; set; }
        public virtual ICollection<RefEllocalRevenueSource> RefEllocalRevenueSource { get; set; }
        public virtual ICollection<RefElotherFederalFundingSources> RefElotherFederalFundingSources { get; set; }
        public virtual ICollection<RefEloutcomeMeasurementLevel> RefEloutcomeMeasurementLevel { get; set; }
        public virtual ICollection<RefElprofessionalDevelopmentTopicArea> RefElprofessionalDevelopmentTopicArea { get; set; }
        public virtual ICollection<RefElprogramEligibility> RefElprogramEligibility { get; set; }
        public virtual ICollection<RefElprogramEligibilityStatus> RefElprogramEligibilityStatus { get; set; }
        public virtual ICollection<RefElprogramLicenseStatus> RefElprogramLicenseStatus { get; set; }
        public virtual ICollection<RefElserviceProfessionalStaffClassification> RefElserviceProfessionalStaffClassification { get; set; }
        public virtual ICollection<RefElserviceType> RefElserviceType { get; set; }
        public virtual ICollection<RefElstateRevenueSource> RefElstateRevenueSource { get; set; }
        public virtual ICollection<RefEltrainerCoreKnowledgeArea> RefEltrainerCoreKnowledgeArea { get; set; }
        public virtual ICollection<RefEmailType> RefEmailType { get; set; }
		public virtual ICollection<RefEmergencyOrProvisionalCredentialStatus> RefEmergencyOrProvisionalCredentialStatus { get; set; }
		public virtual ICollection<RefEmployedAfterExit> RefEmployedAfterExit { get; set; }
        public virtual ICollection<RefEmployedPriorToEnrollment> RefEmployedPriorToEnrollment { get; set; }
        public virtual ICollection<RefEmployedWhileEnrolled> RefEmployedWhileEnrolled { get; set; }
        public virtual ICollection<RefEmploymentContractType> RefEmploymentContractType { get; set; }
        public virtual ICollection<RefEmploymentSeparationReason> RefEmploymentSeparationReason { get; set; }
        public virtual ICollection<RefEmploymentSeparationType> RefEmploymentSeparationType { get; set; }
        public virtual ICollection<RefEmploymentStatus> RefEmploymentStatus { get; set; }
        public virtual ICollection<RefEmploymentStatusWhileEnrolled> RefEmploymentStatusWhileEnrolled { get; set; }
        public virtual ICollection<RefEndOfTermStatus> RefEndOfTermStatus { get; set; }
        public virtual ICollection<RefEnrollmentStatus> RefEnrollmentStatus { get; set; }
        public virtual ICollection<RefEntityType> RefEntityType { get; set; }
        public virtual ICollection<RefEntryType> RefEntryType { get; set; }
        public virtual ICollection<RefEnvironmentSetting> RefEnvironmentSetting { get; set; }
        public virtual ICollection<RefEradministrativeDataSource> RefEradministrativeDataSource { get; set; }
        public virtual ICollection<RefErsruralUrbanContinuumCode> RefErsruralUrbanContinuumCode { get; set; }
        public virtual ICollection<RefExitOrWithdrawalStatus> RefExitOrWithdrawalStatus { get; set; }
        public virtual ICollection<RefExitOrWithdrawalType> RefExitOrWithdrawalType { get; set; }
        public virtual ICollection<RefFamilyIncomeSource> RefFamilyIncomeSource { get; set; }
        public virtual ICollection<RefFederalProgramFundingAllocationType> RefFederalProgramFundingAllocationType { get; set; }
        public virtual ICollection<RefFinancialAccountBalanceSheetCode> RefFinancialAccountBalanceSheetCode { get; set; }
        public virtual ICollection<RefFinancialAccountCategory> RefFinancialAccountCategory { get; set; }
        public virtual ICollection<RefFinancialAccountFundClassification> RefFinancialAccountFundClassification { get; set; }
        public virtual ICollection<RefFinancialAccountProgramCode> RefFinancialAccountProgramCode { get; set; }
        public virtual ICollection<RefFinancialAccountRevenueCode> RefFinancialAccountRevenueCode { get; set; }
        public virtual ICollection<RefFinancialAidApplicationType> RefFinancialAidApplicationType { get; set; }
        public virtual ICollection<RefFinancialAidAwardStatus> RefFinancialAidAwardStatus { get; set; }
        public virtual ICollection<RefFinancialAidAwardType> RefFinancialAidAwardType { get; set; }
        public virtual ICollection<RefFinancialAidVeteransBenefitStatus> RefFinancialAidVeteransBenefitStatus { get; set; }
        public virtual ICollection<RefFinancialAidVeteransBenefitType> RefFinancialAidVeteransBenefitType { get; set; }
        public virtual ICollection<RefFinancialExpenditureFunctionCode> RefFinancialExpenditureFunctionCode { get; set; }
        public virtual ICollection<RefFinancialExpenditureLevelOfInstructionCode> RefFinancialExpenditureLevelOfInstructionCode { get; set; }
        public virtual ICollection<RefFinancialExpenditureObjectCode> RefFinancialExpenditureObjectCode { get; set; }
        public virtual ICollection<RefFirearmType> RefFirearmType { get; set; }
        public virtual ICollection<RefFoodServiceEligibility> RefFoodServiceEligibility { get; set; }
        public virtual ICollection<RefFoodServiceParticipation> RefFoodServiceParticipation { get; set; }
        public virtual ICollection<RefFrequencyOfService> RefFrequencyOfService { get; set; }
        public virtual ICollection<RefFullTimeStatus> RefFullTimeStatus { get; set; }
        public virtual ICollection<RefGoalsForAttendingAdultEducation> RefGoalsForAttendingAdultEducation { get; set; }
        public virtual ICollection<RefGpaWeightedIndicator> RefGpaWeightedIndicator { get; set; }
        public virtual ICollection<RefGradeLevel> RefGradeLevel { get; set; }
        public virtual ICollection<RefGradeLevelType> RefGradeLevelType { get; set; }
        public virtual ICollection<RefGradePointAverageDomain> RefGradePointAverageDomain { get; set; }
        public virtual ICollection<RefGraduateAssistantIpedsCategory> RefGraduateAssistantIpedsCategory { get; set; }
        public virtual ICollection<RefGraduateOrDoctoralExamResultsStatus> RefGraduateOrDoctoralExamResultsStatus { get; set; }
        public virtual ICollection<RefGunFreeSchoolsActReportingStatus> RefGunFreeSchoolsActReportingStatus { get; set; }
        public virtual ICollection<RefHealthInsuranceCoverage> RefHealthInsuranceCoverage { get; set; }
        public virtual ICollection<RefHearingScreeningStatus> RefHearingScreeningStatus { get; set; }
        public virtual ICollection<RefHigherEducationInstitutionAccreditationStatus> RefHigherEducationInstitutionAccreditationStatus { get; set; }
        public virtual ICollection<RefHighSchoolDiplomaDistinctionType> RefHighSchoolDiplomaDistinctionType { get; set; }
        public virtual ICollection<RefHighSchoolDiplomaType> RefHighSchoolDiplomaType { get; set; }
        public virtual ICollection<RefHighSchoolGraduationRateIndicator> RefHighSchoolGraduationRateIndicator { get; set; }
        public virtual ICollection<RefHomelessNighttimeResidence> RefHomelessNighttimeResidence { get; set; }
        public virtual ICollection<RefIdeadisciplineMethodFirearm> RefIdeadisciplineMethodFirearm { get; set; }
        public virtual ICollection<RefIdeaeducationalEnvironmentEc> RefIdeaeducationalEnvironmentEc { get; set; }
        public virtual ICollection<RefIdeaeducationalEnvironmentSchoolAge> RefIdeaeducationalEnvironmentSchoolAge { get; set; }
        public virtual ICollection<RefIdeaenvironmentEl> RefIdeaenvironmentEl { get; set; }
        public virtual ICollection<RefIdeaiepstatus> RefIdeaiepstatus { get; set; }
        public virtual ICollection<RefIdeainterimRemoval> RefIdeainterimRemoval { get; set; }
        public virtual ICollection<RefIdeainterimRemovalReason> RefIdeainterimRemovalReason { get; set; }
        public virtual ICollection<RefIdeapartCeligibilityCategory> RefIdeapartCeligibilityCategory { get; set; }
        public virtual ICollection<RefImmunizationType> RefImmunizationType { get; set; }
        public virtual ICollection<RefIncidentBehavior> RefIncidentBehavior { get; set; }
        public virtual ICollection<RefIncidentBehaviorSecondary> RefIncidentBehaviorSecondary { get; set; }
        public virtual ICollection<RefIncidentInjuryType> RefIncidentInjuryType { get; set; }
        public virtual ICollection<RefIncidentLocation> RefIncidentLocation { get; set; }
        public virtual ICollection<RefIncidentMultipleOffenseType> RefIncidentMultipleOffenseType { get; set; }
        public virtual ICollection<RefIncidentPerpetratorInjuryType> RefIncidentPerpetratorInjuryType { get; set; }
        public virtual ICollection<RefIncidentPersonRoleType> RefIncidentPersonRoleType { get; set; }
        public virtual ICollection<RefIncidentPersonType> RefIncidentPersonType { get; set; }
        public virtual ICollection<RefIncidentReporterType> RefIncidentReporterType { get; set; }
        public virtual ICollection<RefIncidentTimeDescriptionCode> RefIncidentTimeDescriptionCode { get; set; }
        public virtual ICollection<RefIncomeCalculationMethod> RefIncomeCalculationMethod { get; set; }
        public virtual ICollection<RefIncreasedLearningTimeType> RefIncreasedLearningTimeType { get; set; }
        public virtual ICollection<RefIndividualizedProgramDateType> RefIndividualizedProgramDateType { get; set; }
        public virtual ICollection<RefIndividualizedProgramLocation> RefIndividualizedProgramLocation { get; set; }
        public virtual ICollection<RefIndividualizedProgramPlannedServiceType> RefIndividualizedProgramPlannedServiceType { get; set; }
        public virtual ICollection<RefIndividualizedProgramTransitionType> RefIndividualizedProgramTransitionType { get; set; }
        public virtual ICollection<RefIndividualizedProgramType> RefIndividualizedProgramType { get; set; }
        public virtual ICollection<RefInstitutionTelephoneType> RefInstitutionTelephoneType { get; set; }
        public virtual ICollection<RefInstructionalActivityHours> RefInstructionalActivityHours { get; set; }
        public virtual ICollection<RefInstructionalStaffContractLength> RefInstructionalStaffContractLength { get; set; }
        public virtual ICollection<RefInstructionalStaffFacultyTenure> RefInstructionalStaffFacultyTenure { get; set; }
        public virtual ICollection<RefInstructionCreditType> RefInstructionCreditType { get; set; }
        public virtual ICollection<RefInstructionLocationType> RefInstructionLocationType { get; set; }
        public virtual ICollection<RefIntegratedTechnologyStatus> RefIntegratedTechnologyStatus { get; set; }
        public virtual ICollection<RefInternetAccess> RefInternetAccess { get; set; }
        public virtual ICollection<RefIpedsOccupationalCategory> RefIpedsOccupationalCategory { get; set; }
        public virtual ICollection<RefIso6392language> RefIso6392language { get; set; }
        public virtual ICollection<RefIso6393language> RefIso6393language { get; set; }
        public virtual ICollection<RefIso6395languageFamily> RefIso6395languageFamily { get; set; }
        public virtual ICollection<RefItemResponseTheoryDifficultyCategory> RefItemResponseTheoryDifficultyCategory { get; set; }
        public virtual ICollection<RefItemResponseTheoryKappaAlgorithm> RefItemResponseTheoryKappaAlgorithm { get; set; }
        public virtual ICollection<RefK12endOfCourseRequirement> RefK12endOfCourseRequirement { get; set; }
        public virtual ICollection<RefK12leaTitleIsupportService> RefK12leaTitleIsupportService { get; set; }
        public virtual ICollection<RefK12responsibilityType> RefK12responsibilityType { get; set; }
        public virtual ICollection<RefK12staffClassification> RefK12staffClassification { get; set; }
        public virtual ICollection<RefLanguage> RefLanguage { get; set; }
        public virtual ICollection<RefLanguageUseType> RefLanguageUseType { get; set; }
        public virtual ICollection<RefLeaFundsTransferType> RefLeaFundsTransferType { get; set; }
        public virtual ICollection<RefLeaImprovementStatus> RefLeaImprovementStatus { get; set; }
        public virtual ICollection<RefLearnerActionType> RefLearnerActionType { get; set; }
        public virtual ICollection<RefLearnerActivityMaximumTimeAllowedUnits> RefLearnerActivityMaximumTimeAllowedUnits { get; set; }
        public virtual ICollection<RefLearnerActivityType> RefLearnerActivityType { get; set; }
        public virtual ICollection<RefLearningResourceAccessApitype> RefLearningResourceAccessApitype { get; set; }
        public virtual ICollection<RefLearningResourceAccessHazardType> RefLearningResourceAccessHazardType { get; set; }
        public virtual ICollection<RefLearningResourceAccessModeType> RefLearningResourceAccessModeType { get; set; }
        public virtual ICollection<RefLearningResourceAccessRightsUrl> RefLearningResourceAccessRightsUrl { get; set; }
        public virtual ICollection<RefLearningResourceAuthorType> RefLearningResourceAuthorType { get; set; }
        public virtual ICollection<RefLearningResourceBookFormatType> RefLearningResourceBookFormatType { get; set; }
        public virtual ICollection<RefLearningResourceCompetencyAlignmentType> RefLearningResourceCompetencyAlignmentType { get; set; }
        public virtual ICollection<RefLearningResourceControlFlexibilityType> RefLearningResourceControlFlexibilityType { get; set; }
        public virtual ICollection<RefLearningResourceDigitalMediaSubType> RefLearningResourceDigitalMediaSubType { get; set; }
        public virtual ICollection<RefLearningResourceDigitalMediaType> RefLearningResourceDigitalMediaType { get; set; }
        public virtual ICollection<RefLearningResourceEducationalUse> RefLearningResourceEducationalUse { get; set; }
        public virtual ICollection<RefLearningResourceIntendedEndUserRole> RefLearningResourceIntendedEndUserRole { get; set; }
        public virtual ICollection<RefLearningResourceInteractionMode> RefLearningResourceInteractionMode { get; set; }
        public virtual ICollection<RefLearningResourceInteractivityType> RefLearningResourceInteractivityType { get; set; }
        public virtual ICollection<RefLearningResourceMediaFeatureType> RefLearningResourceMediaFeatureType { get; set; }
        public virtual ICollection<RefLearningResourcePhysicalMediaType> RefLearningResourcePhysicalMediaType { get; set; }
        public virtual ICollection<RefLearningResourceType> RefLearningResourceType { get; set; }
        public virtual ICollection<RefLearningStandardDocumentPublicationStatus> RefLearningStandardDocumentPublicationStatus { get; set; }
        public virtual ICollection<RefLearningStandardItemAssociationType> RefLearningStandardItemAssociationType { get; set; }
        public virtual ICollection<RefLearningStandardItemNodeAccessibilityProfile> RefLearningStandardItemNodeAccessibilityProfile { get; set; }
        public virtual ICollection<RefLearningStandardItemTestabilityType> RefLearningStandardItemTestabilityType { get; set; }
        public virtual ICollection<RefLeaType> RefLeaType { get; set; }
        public virtual ICollection<RefLeaveEventType> RefLeaveEventType { get; set; }
        public virtual ICollection<RefLevelOfInstitution> RefLevelOfInstitution { get; set; }
        public virtual ICollection<RefLicenseExempt> RefLicenseExempt { get; set; }
        public virtual ICollection<RefLiteracyAssessment> RefLiteracyAssessment { get; set; }
        public virtual ICollection<RefMagnetSpecialProgram> RefMagnetSpecialProgram { get; set; }
        public virtual ICollection<RefMedicalAlertIndicator> RefMedicalAlertIndicator { get; set; }
        public virtual ICollection<RefMepEnrollmentType> RefMepEnrollmentType { get; set; }
        public virtual ICollection<RefMepProjectBased> RefMepProjectBased { get; set; }
        public virtual ICollection<RefMepProjectType> RefMepProjectType { get; set; }
        public virtual ICollection<RefMepServiceType> RefMepServiceType { get; set; }
        public virtual ICollection<RefMepSessionType> RefMepSessionType { get; set; }
        public virtual ICollection<RefMepStaffCategory> RefMepStaffCategory { get; set; }
        public virtual ICollection<RefMethodOfServiceDelivery> RefMethodOfServiceDelivery { get; set; }
        public virtual ICollection<RefMilitaryActiveStudentIndicator> RefMilitaryActiveStudentIndicator { get; set; }
        public virtual ICollection<RefMilitaryBranch> RefMilitaryBranch { get; set; }
        public virtual ICollection<RefMilitaryConnectedStudentIndicator> RefMilitaryConnectedStudentIndicator { get; set; }
        public virtual ICollection<RefMilitaryVeteranStudentIndicator> RefMilitaryVeteranStudentIndicator { get; set; }
        public virtual ICollection<RefMultipleIntelligenceType> RefMultipleIntelligenceType { get; set; }
        public virtual ICollection<RefNaepAspectsOfReading> RefNaepAspectsOfReading { get; set; }
        public virtual ICollection<RefNaepMathComplexityLevel> RefNaepMathComplexityLevel { get; set; }
        public virtual ICollection<RefNcescollegeCourseMapCode> RefNcescollegeCourseMapCode { get; set; }
        public virtual ICollection<RefNeedDeterminationMethod> RefNeedDeterminationMethod { get; set; }
        public virtual ICollection<RefNeglectedProgramType> RefNeglectedProgramType { get; set; }
        public virtual ICollection<RefNonPromotionReason> RefNonPromotionReason { get; set; }
        public virtual ICollection<RefNonTraditionalGenderStatus> RefNonTraditionalGenderStatus { get; set; }
        public virtual ICollection<RefNSLPStatus> RefNSLPStatus { get; set; }
        public virtual ICollection<RefOperationalStatus> RefOperationalStatus { get; set; }
        public virtual ICollection<RefOperationalStatusType> RefOperationalStatusType { get; set; }
        public virtual ICollection<RefOrganizationElementType> RefOrganizationElementType { get; set; }
        public virtual ICollection<RefOrganizationIdentificationSystem> RefOrganizationIdentificationSystem { get; set; }
        public virtual ICollection<RefOrganizationIdentifierType> RefOrganizationIdentifierType { get; set; }
        public virtual ICollection<RefOrganizationIndicator> RefOrganizationIndicator { get; set; }
        public virtual ICollection<RefOrganizationLocationType> RefOrganizationLocationType { get; set; }
        public virtual ICollection<RefOrganizationMonitoringNotifications> RefOrganizationMonitoringNotifications { get; set; }
        public virtual ICollection<RefOrganizationRelationship> RefOrganizationRelationship { get; set; }
        public virtual ICollection<RefOrganizationType> RefOrganizationType { get; set; }
        public virtual ICollection<RefOtherNameType> RefOtherNameType { get; set; }
        public virtual ICollection<RefOutOfFieldStatus> RefOutOfFieldStatus { get; set; }
		public virtual ICollection<RefOutcomeTimePoint> RefOutcomeTimePoint { get; set; }
		public virtual ICollection<RefParaprofessionalQualification> RefParaprofessionalQualification { get; set; }
        public virtual ICollection<RefParticipationStatusAyp> RefParticipationStatusAyp { get; set; }
        public virtual ICollection<RefParticipationType> RefParticipationType { get; set; }
        public virtual ICollection<RefPdactivityApprovedPurpose> RefPdactivityApprovedPurpose { get; set; }
        public virtual ICollection<RefPdactivityCreditType> RefPdactivityCreditType { get; set; }
        public virtual ICollection<RefPdactivityEducationLevelsAddressed> RefPdactivityEducationLevelsAddressed { get; set; }
        public virtual ICollection<RefPdactivityLevel> RefPdactivityLevel { get; set; }
        public virtual ICollection<RefPdactivityTargetAudience> RefPdactivityTargetAudience { get; set; }
        public virtual ICollection<RefPdactivityType> RefPdactivityType { get; set; }
        public virtual ICollection<RefPdaudienceType> RefPdaudienceType { get; set; }
        public virtual ICollection<RefPddeliveryMethod> RefPddeliveryMethod { get; set; }
        public virtual ICollection<RefPdinstructionalDeliveryMode> RefPdinstructionalDeliveryMode { get; set; }
        public virtual ICollection<RefPdsessionStatus> RefPdsessionStatus { get; set; }
        public virtual ICollection<RefPersonalInformationVerification> RefPersonalInformationVerification { get; set; }
        public virtual ICollection<RefPersonIdentificationSystem> RefPersonIdentificationSystem { get; set; }
        public virtual ICollection<RefPersonIdentifierType> RefPersonIdentifierType { get; set; }
        public virtual ICollection<RefPersonLocationType> RefPersonLocationType { get; set; }
        public virtual ICollection<RefPersonRelationship> RefPersonRelationship { get; set; }
        public virtual ICollection<RefPersonStatusType> RefPersonStatusType { get; set; }
        public virtual ICollection<RefPersonTelephoneNumberType> RefPersonTelephoneNumberType { get; set; }
        public virtual ICollection<RefPopulationServed> RefPopulationServed { get; set; }
        public virtual ICollection<RefPreAndPostTestIndicator> RefPreAndPostTestIndicator { get; set; }
        public virtual ICollection<RefPredominantCalendarSystem> RefPredominantCalendarSystem { get; set; }
        public virtual ICollection<RefPreKeligibleAgesNonIdea> RefPreKeligibleAgesNonIdea { get; set; }
        public virtual ICollection<RefPrekindergartenEligibility> RefPrekindergartenEligibility { get; set; }
        public virtual ICollection<RefPresentAttendanceCategory> RefPresentAttendanceCategory { get; set; }
        public virtual ICollection<RefProfessionalDevelopmentFinancialSupport> RefProfessionalDevelopmentFinancialSupport { get; set; }
        public virtual ICollection<RefProfessionalEducationJobClassification> RefProfessionalEducationJobClassification { get; set; }
        public virtual ICollection<RefProfessionalTechnicalCredentialType> RefProfessionalTechnicalCredentialType { get; set; }
        public virtual ICollection<RefProficiencyStatus> RefProficiencyStatus { get; set; }
        public virtual ICollection<RefProficiencyTargetAyp> RefProficiencyTargetAyp { get; set; }
        public virtual ICollection<RefProgramDayLength> RefProgramDayLength { get; set; }
        public virtual ICollection<RefProgramExitReason> RefProgramExitReason { get; set; }
        public virtual ICollection<RefProgramGiftedEligibility> RefProgramGiftedEligibility { get; set; }
        public virtual ICollection<RefProgramLengthHoursType> RefProgramLengthHoursType { get; set; }
        public virtual ICollection<RefProgramSponsorType> RefProgramSponsorType { get; set; }
        public virtual ICollection<RefProgramType> RefProgramType { get; set; }
        public virtual ICollection<RefProgressLevel> RefProgressLevel { get; set; }
        public virtual ICollection<RefPromotionReason> RefPromotionReason { get; set; }
        public virtual ICollection<RefProofOfResidencyType> RefProofOfResidencyType { get; set; }
        public virtual ICollection<RefPsEnrollmentAction> RefPsEnrollmentAction { get; set; }
        public virtual ICollection<RefPsEnrollmentAwardType> RefPsEnrollmentAwardType { get; set; }
        public virtual ICollection<RefPsEnrollmentStatus> RefPsEnrollmentStatus { get; set; }
        public virtual ICollection<RefPsEnrollmentType> RefPsEnrollmentType { get; set; }
        public virtual ICollection<RefPsexitOrWithdrawalType> RefPsexitOrWithdrawalType { get; set; }
        public virtual ICollection<RefPsLepType> RefPsLepType { get; set; }
        public virtual ICollection<RefPsprogramLevel> RefPsprogramLevel { get; set; }
        public virtual ICollection<RefPsStudentLevel> RefPsStudentLevel { get; set; }
        public virtual ICollection<RefPublicSchoolChoiceStatus> RefPublicSchoolChoiceStatus { get; set; }
        public virtual ICollection<RefPublicSchoolResidence> RefPublicSchoolResidence { get; set; }
        public virtual ICollection<RefPurposeOfMonitoringVisit> RefPurposeOfMonitoringVisit { get; set; }
        public virtual ICollection<RefQrisParticipation> RefQrisParticipation { get; set; }
        public virtual ICollection<RefRace> RefRace { get; set; }
        public virtual ICollection<RefReapAlternativeFundingStatus> RefReapAlternativeFundingStatus { get; set; }
        public virtual ICollection<RefReasonDelayTransitionConf> RefReasonDelayTransitionConf { get; set; }
        public virtual ICollection<RefReconstitutedStatus> RefReconstitutedStatus { get; set; }
        public virtual ICollection<RefReferralOutcome> RefReferralOutcome { get; set; }
        public virtual ICollection<RefReimbursementType> RefReimbursementType { get; set; }
        public virtual ICollection<RefRestructuringAction> RefRestructuringAction { get; set; }
        public virtual ICollection<RefRlisProgramUse> RefRlisProgramUse { get; set; }
        public virtual ICollection<RefRoleStatus> RefRoleStatus { get; set; }
        public virtual ICollection<RefRoleStatusType> RefRoleStatusType { get; set; }
        public virtual ICollection<RefScedcourseLevel> RefScedcourseLevel { get; set; }
        public virtual ICollection<RefScedcourseSubjectArea> RefScedcourseSubjectArea { get; set; }
        public virtual ICollection<RefScheduledWellChildScreening> RefScheduledWellChildScreening { get; set; }
        public virtual ICollection<RefSchoolFoodServiceProgram> RefSchoolFoodServiceProgram { get; set; }
        public virtual ICollection<RefSchoolImprovementFunds> RefSchoolImprovementFunds { get; set; }
        public virtual ICollection<RefSchoolImprovementStatus> RefSchoolImprovementStatus { get; set; }
        public virtual ICollection<RefSchoolDangerousStatus> RefSchoolDangerousStatus { get; set; }
        public virtual ICollection<RefSchoolLevel> RefSchoolLevel { get; set; }
        public virtual ICollection<RefSchoolType> RefSchoolType { get; set; }
        public virtual ICollection<RefScoreMetricType> RefScoreMetricType { get; set; }
        public virtual ICollection<RefServiceFrequency> RefServiceFrequency { get; set; }
        public virtual ICollection<RefServiceOption> RefServiceOption { get; set; }
        public virtual ICollection<RefServices> RefServices { get; set; }
        public virtual ICollection<RefSessionType> RefSessionType { get; set; }
        public virtual ICollection<RefSex> RefSex { get; set; }
        public virtual ICollection<RefSigInterventionType> RefSigInterventionType { get; set; }
        public virtual ICollection<RefSingleSexClassStatus> RefSingleSexClassStatus { get; set; }
        public virtual ICollection<RefSpaceUseType> RefSpaceUseType { get; set; }
        public virtual ICollection<RefSpecialEducationAgeGroupTaught> RefSpecialEducationAgeGroupTaught { get; set; }
        public virtual ICollection<RefSpecialEducationExitReason> RefSpecialEducationExitReason { get; set; }
        public virtual ICollection<RefSpecialEducationStaffCategory> RefSpecialEducationStaffCategory { get; set; }
        public virtual ICollection<RefStaffPerformanceLevel> RefStaffPerformanceLevel { get; set; }
        public virtual ICollection<RefStandardizedAdmissionTest> RefStandardizedAdmissionTest { get; set; }
        public virtual ICollection<RefState> RefState { get; set; }
        public virtual ICollection<RefStatePovertyDesignation> RefStatePovertyDesignation { get; set; }
        public virtual ICollection<RefStudentSupportServiceType> RefStudentSupportServiceType { get; set; }
        public virtual ICollection<RefSupervisedClinicalExperience> RefSupervisedClinicalExperience { get; set; }
		public virtual ICollection<RefTargetedSupport> RefTargetedSupport { get; set; }
        public virtual ICollection<RefTargetedSupportImprovement> RefTargetedSupportImprovement { get; set; }
        public virtual ICollection<RefTeacherEducationCredentialExam> RefTeacherEducationCredentialExam { get; set; }
        public virtual ICollection<RefTeacherEducationExamScoreType> RefTeacherEducationExamScoreType { get; set; }
        public virtual ICollection<RefTeacherEducationTestCompany> RefTeacherEducationTestCompany { get; set; }
        public virtual ICollection<RefTeacherPrepCompleterStatus> RefTeacherPrepCompleterStatus { get; set; }
        public virtual ICollection<RefTeacherPrepEnrollmentStatus> RefTeacherPrepEnrollmentStatus { get; set; }
        public virtual ICollection<RefTeachingAssignmentRole> RefTeachingAssignmentRole { get; set; }
        public virtual ICollection<RefTeachingCredentialBasis> RefTeachingCredentialBasis { get; set; }
        public virtual ICollection<RefTeachingCredentialType> RefTeachingCredentialType { get; set; }
        public virtual ICollection<RefTechnicalAssistanceDeliveryType> RefTechnicalAssistanceDeliveryType { get; set; }
        public virtual ICollection<RefTechnicalAssistanceType> RefTechnicalAssistanceType { get; set; }
        public virtual ICollection<RefTechnologyLiteracyStatus> RefTechnologyLiteracyStatus { get; set; }
        public virtual ICollection<RefTelephoneNumberType> RefTelephoneNumberType { get; set; }
        public virtual ICollection<RefTenureSystem> RefTenureSystem { get; set; }
        public virtual ICollection<RefTextComplexitySystem> RefTextComplexitySystem { get; set; }
        public virtual ICollection<RefTimeForCompletionUnits> RefTimeForCompletionUnits { get; set; }
        public virtual ICollection<RefTitleIiiaccountability> RefTitleIiiaccountability { get; set; }
        public virtual ICollection<RefTitleIiilanguageInstructionProgramType> RefTitleIiilanguageInstructionProgramType { get; set; }
        public virtual ICollection<RefTitleIiiprofessionalDevelopmentType> RefTitleIiiprofessionalDevelopmentType { get; set; }
        public virtual ICollection<RefTitleIindicator> RefTitleIindicator { get; set; }
        public virtual ICollection<RefTitleIinstructionalServices> RefTitleIinstructionalServices { get; set; }
        public virtual ICollection<RefTitleIprogramStaffCategory> RefTitleIprogramStaffCategory { get; set; }
        public virtual ICollection<RefTitleIprogramType> RefTitleIprogramType { get; set; }
        public virtual ICollection<RefTitleIschoolStatus> RefTitleIschoolStatus { get; set; }
        public virtual ICollection<RefTransferOutIndicator> RefTransferOutIndicator { get; set; }
        public virtual ICollection<RefTransferReady> RefTransferReady { get; set; }
        public virtual ICollection<RefTribalAffiliation> RefTribalAffiliation { get; set; }
        public virtual ICollection<RefTrimesterWhenPrenatalCareBegan> RefTrimesterWhenPrenatalCareBegan { get; set; }
        public virtual ICollection<RefTuitionResidencyType> RefTuitionResidencyType { get; set; }
        public virtual ICollection<RefTuitionUnit> RefTuitionUnit { get; set; }
		public virtual ICollection<RefUnexperiencedStatus> RefUnexperiencedStatus { get; set; }
		public virtual ICollection<RefUscitizenshipStatus> RefUscitizenshipStatus { get; set; }
        public virtual ICollection<RefVisaType> RefVisaType { get; set; }
        public virtual ICollection<RefVisionScreeningStatus> RefVisionScreeningStatus { get; set; }
        public virtual ICollection<RefWageCollectionMethod> RefWageCollectionMethod { get; set; }
        public virtual ICollection<RefWageVerification> RefWageVerification { get; set; }
        public virtual ICollection<RefWeaponType> RefWeaponType { get; set; }
        public virtual ICollection<RefWfProgramParticipation> RefWfProgramParticipation { get; set; }
        public virtual ICollection<RefWorkbasedLearningOpportunityType> RefWorkbasedLearningOpportunityType { get; set; }
        public virtual ICollection<RequiredImmunization> RequiredImmunization { get; set; }
        public virtual ICollection<Role> Role { get; set; }
        public virtual ICollection<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus { get; set; }

		public virtual ICollection<RefIndicatorStatusType> RefIndicatorStatusType { get; set; }
		public virtual ICollection<RefIndicatorStatusSubgroupType> RefIndicatorStatusSubgroupType { get; set; }
		public virtual ICollection<RefIndicatorStateDefinedStatus> RefIndicatorStateDefinedStatus { get; set; }
		public virtual ICollection<RefIndicatorStatusCustomType> RefIndicatorStatusCustomType { get; set; }
	}
}
