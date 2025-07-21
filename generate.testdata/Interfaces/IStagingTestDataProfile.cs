using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace generate.testdata.Interfaces
{
    public interface IStagingTestDataProfile
    {
        #region Global
        List<string> FederalProgramCodes { get; set; }
        #endregion

        #region Numbers

        int NumberOfParallelTasks { get; set; }
        int BatchSize { get; set; }
        int StudentIterationSize { get; set; }

        int QuantityOfSeas { get; set; }
        int OldestStartingYear { get; set; }
        int MinimumAgeOfStudent { get; set; }
        int MaximumAgeOfStudent { get; set; }


        int MinimumAverageStudentsPerLea { get; set; }
        int MaximumAverageStudentsPerLea { get; set; }


        int MinimumSchoolsPerLeaRural { get; set; }
        int MaximumSchoolsPerLeaRural { get; set; }
        int MinimumSchoolsPerLeaUrban { get; set; }
        int MaximumSchoolsPerLeaUrban { get; set; }



        int MinimumStudentsPerElementary { get; set; }
        int MaximumStudentsPerElementary { get; set; }
        int MinimumStudentsPerMiddleSchool { get; set; }
        int MaximumStudentsPerMiddleSchool { get; set; }
        int MinimumStudentsPerHighSchool { get; set; }
        int MaximumStudentsPerHighSchool { get; set; }

        int MinimumStudentTeacherRatio { get; set; }
        int MaximumStudentsTeacherRatio { get; set; }

        int AverageNumberOfStudentsPerAssessment { get; set; }

        List<DataDistribution<string>> RefAcademicSubjectDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentPurposeDistribution { get; set; }
        List<DataDistribution<string>> StateAppropriationMethodDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentTypeAdministeredDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentTypeAdministeredToEnglishLearnersDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentTypeDistribution { get; set; }

        #endregion

        #region Organization

        List<DataDistribution<bool>> IsOrganizationClosedDistribution { get; set; }
        List<DataDistribution<bool>> IncludePlus4ZipCodeDistribution { get; set; }
        List<DataDistribution<bool>> HasMailingAddressDistribution { get; set; }
        List<DataDistribution<bool>> HasShippingAddressDistribution { get; set; }
        List<DataDistribution<string>> RefOrganizationIndicatorDistribution { get; set; }
        List<DataDistribution<string>> SharedTimeOrganizationIndicatorValueDistribution { get; set; }
        List<DataDistribution<string>> RefVirtualSchoolStatusDistribution { get; set; }
        List<DataDistribution<string>> RefTitleIiilanguageInstructionProgramTypeDistribution { get; set; }
        List<DataDistribution<string>> RefTitleIiiAccountability { get; set; }
        List<DataDistribution<string>> RefTitleIIndicator { get; set; }
        List<DataDistribution<string>> RefGunFreeSchoolsActReportingStatusDistribution { get; set; }
        List<DataDistribution<string>> RefHighSchoolGraduationRateIndicatorDistribution { get; set; }
        List<DataDistribution<string>> RefReconstitutedStatusDistribution { get; set; }
        List<DataDistribution<string>> RefCteGraduationRateInclusionDistribution { get; set; }
        List<DataDistribution<bool>> PersistentlyDangerousStatusDistribution { get; set; }
        List<DataDistribution<string>> RefAmaoAttainmentStatusDistribution { get; set; }
        List<DataDistribution<string>> RefReapAlternativeFundingStatusDistribution { get; set; }
        List<DataDistribution<string>> RefFederalProgramFundingAllocationTypeDistribution { get; set; }
        List<DataDistribution<bool>> HasReceivedMckinneyGrantDistribution { get; set; }
        List<DataDistribution<string>> RefTargetedSupportImprovementDistribution { get; set; }
        List<DataDistribution<string>> RefComprehensiveSupportImprovementDistribution { get; set; }
        List<DataDistribution<string>> RefAdditionalTargetedSupportDistribution { get; set; }

        #endregion

        #region Demographics
        List<DataDistribution<string>> SexDistribution { get; set; }
        List<DataDistribution<string>> SexForIdeaDistribution { get; set; }
        List<DataDistribution<bool>> HispanicDistribution { get; set; }
        #endregion

        #region Leas
        List<DataDistribution<string>> LeaGeographicDistribution { get; set; }
        List<DataDistribution<string>> LeaTypeDistribution { get; set; }
        List<DataDistribution<bool>> IsCharterLeaDistribution { get; set; }
        List<DataDistribution<bool>> LeaHasNcesIdDistribution { get; set; }
        List<DataDistribution<string>> RefK12leaTitleIsupportServiceDistribution { get; set; }
        List<DataDistribution<string>> RefTitleIinstructionalServiceDistribution { get; set; }
        List<DataDistribution<string>> RefTitleIprogramTypeDistribution { get; set; }
        List<DataDistribution<string>> RefMepProjectTypeDistribution { get; set; }
        List<DataDistribution<string>> LeaRefOperationalStatusDistribution { get; set; }
        List<DataDistribution<string>> RefCharterLeaStatusDistribution { get; set; }
        List<DataDistribution<bool>> IsMcKinneyVentoDistribution { get; set; }


        #endregion

        #region Schools
        List<DataDistribution<string>> SchoolTypesInLeaDistribution { get; set; }
        List<DataDistribution<string>> SchoolTypeDistribution { get; set; }
        List<DataDistribution<bool>> IsCharterSchoolDistribution { get; set; }
        List<DataDistribution<bool>> HasSecondaryCharterAuthorizerDistribution { get; set; }
        List<DataDistribution<bool>> HasUpdatedCharterManagerDistribution { get; set; }
        List<DataDistribution<string>> StatePovertyDesignationDistribution { get; set; }
        List<DataDistribution<bool>> SchoolHasNcesIdDistribution { get; set; }
        List<DataDistribution<string>> SchoolRefOperationalStatusDistribution { get; set; }
        List<DataDistribution<string>> RefSchoolImprovementStatusDistribution { get; set; }
        List<DataDistribution<string>> RefSchoolImprovementFundsDistribution { get; set; }
        List<DataDistribution<bool>> HasSpecialEdProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasLepProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasSection504ProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasFosterCareProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasImmigrantEducationProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasMigrantEducationProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasCTEProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasNeglectedProgramDistribution { get; set; }
        List<DataDistribution<bool>> HasHomelessProgramDistribution { get; set; }


        List<DataDistribution<string>> RefTitleIschoolStatusDistribution { get; set; }
        List<DataDistribution<string>> RefMagnetSpecialProgramDistribution { get; set; }
        List<DataDistribution<string>> RefNSLPStatusDistribution { get; set; }
        List<DataDistribution<string>> RefSchoolDangerousStatusDistribution { get; set; }
        List<DataDistribution<string>> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution { get; set; }
        List<DataDistribution<string>> RefComprehensiveAndTargetedSupportDistribution { get; set; }
        List<DataDistribution<string>> RefComprehensiveSupportDistribution { get; set; }
        List<DataDistribution<string>> RefTargetedSupportDistribution { get; set; }
        List<DataDistribution<bool>> ConsolidatedMepFundsStatusDistribution { get; set; }
        List<DataDistribution<bool>> HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution { get; set; }
        List<DataDistribution<string>> ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution { get; set; }

        List<DataDistribution<string>> ComprehensiveSupport { get; set; }
        List<DataDistribution<string>> ComprehensiveSupportReasonApplicability { get; set; }
        List<DataDistribution<string>> Subgroups { get; set; }
        


        #endregion

        #region StateDefinedIndicators
        List<DataDistribution<string>> RefIndicatorStatusTypeDistribution { get; set; }
        List<DataDistribution<string>> RefStateDefinedIndicatorStatusDistribution { get; set; }
        List<DataDistribution<string>> RefIndicatorStatusSubgroupTypeDistribution { get; set; }
        List<DataDistribution<string>> IndicatorStatusSubgroup { get; set; }
        List<DataDistribution<string>> IndicatorStatusDistribution { get; set; }
        List<DataDistribution<string>> RefIndicatorStatusCustomTypeDistribution { get; set; }
        List<DataDistribution<string>> StateDefinedIndicatorStatusDistribution { get; set; }
        List<DataDistribution<string>> RaceSubgroupTypeDistribution { get; set; }
        List<DataDistribution<string>> DisabilitySubgroupTypeDistribution { get; set; }
        List<DataDistribution<string>> EnglishLearnerSubgroupTypeDistribution { get; set; }
        List<DataDistribution<string>> EconomicallyDisadvantagedSubgroupTypeDistribution { get; set; }
        #endregion

        #region Students
        List<DataDistribution<int>> EcoDisStatusDistribution { get; set; }
        List<DataDistribution<string>> EligibilityStatusForSchoolFoodServiceProgramsDistribution { get; set; }
        List<DataDistribution<bool>> HomelessStatusDistribution { get; set; }
        List<DataDistribution<bool>> HomelessUnaccompaniedYouthStatusDistribution { get; set; }
        List<DataDistribution<bool>> LepStatusDistribution { get; set; }
        List<DataDistribution<bool>> LepExitingDistribution { get; set; }
        List<DataDistribution<bool>> PerkinsLepStatusDistribution { get; set; }
        List<DataDistribution<bool>> MigrantStatusDistribution { get; set; }
        List<DataDistribution<bool>> SpecialEdStatusDistribution { get; set; }
        List<DataDistribution<bool>> ImmigrantTitleIIIStatusDistribution { get; set; }
        List<DataDistribution<bool>> DisabilityStatusDistribution { get; set; }
        List<DataDistribution<string>> RefDisabilityTypeDistribution { get; set; }
        List<DataDistribution<string>> RefIdeaDisabilityTypeDistribution { get; set; }
        List<DataDistribution<string>> RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution { get; set; }
        List<DataDistribution<string>> RefIDEAEducationalEnvironmentForSchoolAgeDistribution { get; set; }
        List<DataDistribution<bool>> PersonHomelessnessDistribution { get; set; }
        List<DataDistribution<string>> HighSchoolDiplomaTypeDistribution { get; set; }
        List<DataDistribution<string>> PostSecondaryEnrollmentActionDistribution { get; set; }
        List<DataDistribution<string>> RefHomelessNighttimeResidenceDistribution { get; set; }
        List<DataDistribution<string>> RefLanguageDistribution { get; set; }
        List<DataDistribution<string>> RefLanguageUseTypeDistribution { get; set; }
        List<DataDistribution<int>> NumberOfRacesDistribution { get; set; }
        List<DataDistribution<string>> RefRaceDistribution { get; set; }


        List<DataDistribution<int>> NumberOfConcurrentSchoolEnrollmentDistribution { get; set; }
        List<DataDistribution<bool>> EnrollmentAtOutOfLeaSchoolDistribution { get; set; }
        List<DataDistribution<bool>> EnrollmentOnlyAtLeaDistribution { get; set; }
        List<DataDistribution<bool>> EnrollmentExitDuringSchoolYearDistribution { get; set; }

        List<DataDistribution<bool>> SpecialEdProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> ImmigrantTitleIIIProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> MigrantProgramParticipationDistribution { get; set; }
        List<DataDistribution<string>> MigrantEducationProgramEnrollmentTypeDistribution { get; set; }
        List<DataDistribution<string>> MigrantEducationProgramServicesTypeDistribution { get; set; }
        List<DataDistribution<bool>> MigrantEducationProgramContinuationOfServices { get; set; }
        List<DataDistribution<string>> ContinuationOfServicesReason { get; set; }
        List<DataDistribution<bool>> MigrantPrioritizedForServices { get; set; }

        List<DataDistribution<string>> RefMilitaryConnectedStudentIndicatorDistribution { get; set; }
        //List<DataDistribution<bool>> MilitaryConnectedStudentIndicatorDistribution { get; set; }
        List<DataDistribution<bool>> Section504ProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> FosterCareProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> CteProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> LepProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> NeglectedProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> DelinquentProgramParticipationDistribution { get; set; }
        List<DataDistribution<string>> RefNeglectedOrDelinquentProgramTypeDistribution { get; set; }
        List<DataDistribution<string>> RefNeglectedProgramTypeDistribution { get; set; }
        List<DataDistribution<string>> RefDelinquentProgramTypeDistribution { get; set; }
        List<DataDistribution<string>> RefProgressLevelDistribution { get; set; }
        List<DataDistribution<bool>> NorDStatusDistribution { get; set; }
        List<DataDistribution<bool>> NorDExitingDistribution { get; set; }
        List<DataDistribution<string>> NorDSubpartDistribution { get; set; }
        List<DataDistribution<bool>> NorDOutcomeYesNoDistribution { get; set; }
        List<DataDistribution<bool>> NorDOutcomeExitYesNoDistribution { get; set; }
        List<DataDistribution<string>> NorDOutcomeDistribution { get; set; }
        List<DataDistribution<string>> NorDOutcomeExitDistribution { get; set; }
        List<DataDistribution<bool>> NorDOutcomeIndicatorDistribution { get; set; }
        List<DataDistribution<bool>> NorDAchievementIndicatorDistribution { get; set; }
        List<DataDistribution<bool>> NorDLongTermStatusDistribution { get; set; }

        List<DataDistribution<bool>> HomelessServicedProgramParticipationDistribution { get; set; }
        List<DataDistribution<bool>> NationalSchoolLunchProgramDirectCertificationIndicatorDistribution { get; set; }

        List<DataDistribution<bool>> UseDatesInPersonStatusDistribution { get; set; }

        List<DataDistribution<int>> NumberOfDisciplinesDistribution { get; set; }

        List<DataDistribution<bool>> GEDPreparationProgramParticipationDistribution { get; set; }

        List<DataDistribution<bool>> FullAcademicYearPersonStatusDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentParticipationIndicatorDistribution { get; set; }
        List<DataDistribution<string>> RefAssessmentRegistrationReasonNotCompleting { get; set; }
        List<DataDistribution<string>> RefAssessmentRegistrationReasonNotTested { get; set; }
        List<DataDistribution<string>> AssessmentAccommodationTypeDistribution { get; set; }
        List<DataDistribution<string>> AssessmentAccommodationCategoryDistribution { get; set; }

        List<DataDistribution<bool>> SpecialEdProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> CteProgramParticipantNowDistribution { get; set; }

        List<DataDistribution<bool>> DisplacedHomemakerDistribution { get; set; }
        List<DataDistribution<bool>> SingleParentOrPregnantWomanDistribution { get; set; }
        List<DataDistribution<bool>> CteNonTraditionalCompletionDistribution { get; set; }

        List<DataDistribution<bool>> LepProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> Section504ProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> FosterCareProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> ImmigrantTitleIIIProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> NeglectedProgramParticipantNowDistribution { get; set; }
        List<DataDistribution<bool>> HomelessProgramParticipantNowDistribution { get; set; }

        List<DataDistribution<bool>> IncludeMajorRaceStatusDistribution { get; set; }
        List<DataDistribution<bool>> CteConcentratorDistribution { get; set; }
        List<DataDistribution<bool>> CteCompleterDistribution { get; set; }
        List<DataDistribution<string>> RefExitOrWithdrawalTypeDistribution { get; set; }
        List<DataDistribution<string>> RefSpecialEducationExitReasonDistribution { get; set; }
        List<DataDistribution<string>> RefIdeaInterimRemovalDistribution { get; set; }

        List<DataDistribution<string>> AccessibleFormatIndicatorDistribution { get; set; }
        List<DataDistribution<string>> AccessibleFormatRequiredIndicatorDistribution { get; set; }
        List<DataDistribution<string>> AccessibleFormatTypeDistribution { get; set; }
        List<DataDistribution<string>> ERSRuralUrbanContinuumCodeDistribution { get; set; }
        List<DataDistribution<string>> RuralResidencyStatusDistribution { get; set; }

        List<DataDistribution<bool>> RefIdeaIndicatorDistribution { get; set; }

        #endregion

        #region Personnel

        List<DataDistribution<bool>> HighlyQualifiedDistribution { get; set; }
        List<DataDistribution<bool>> IsSpecialEdStaffDistribution { get; set; }
        List<DataDistribution<decimal>> StaffFteDistribution { get; set; }
        List<DataDistribution<bool>> IsAeStaffDistribution { get; set; }
        List<DataDistribution<string>> RefCredentialTypeDistribution { get; set; }
        List<DataDistribution<string>> RefTeachingCredentialTypeDistribution { get; set; }
        List<DataDistribution<string>> RefSpecialEducationStaffCategoryDistribution { get; set; }
        List<DataDistribution<string>> RefK12StaffClassificationDistribution { get; set; }
        List<DataDistribution<string>> RefTitleIProgramStaffCategoryDistribution { get; set; }
        List<DataDistribution<string>> RefParaprofessionalQualificationDistribution { get; set; }
        List<DataDistribution<string>> RefInexperiencedStatusDistribution { get; set; }
        List<DataDistribution<string>> RefOutOfFieldStatusDistribution { get; set; }
        List<DataDistribution<string>> RefEdFactsCertificationStatusDistribution { get; set; }
        List<DataDistribution<string>> RefSpecialEducationTeacherQualificationStatusDistribution { get; set; }
        List<DataDistribution<string>> RefSpecialEducationAgeGroupTaughtDistribution { get; set; }
        List<DataDistribution<string>> RefProgramTypeDistribution { get; set; }
        #endregion

        #region Charter
        List<DataDistribution<bool>> CharterSchoolAuthorizerTypeDistribution { get; set; }

        List<DataDistribution<bool>> CharterRenewalDistribution { get; set; }
        #endregion
        #region Accessibility
        List<string> SCEDCodes { get; set; }

        #endregion

    }
}
