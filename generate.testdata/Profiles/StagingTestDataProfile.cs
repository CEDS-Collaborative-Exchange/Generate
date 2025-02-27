using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Profiles
{
    public class StagingTestDataProfile : IStagingTestDataProfile
    {
        #region Global
        public List<string> FederalProgramCodes { get; set; }

        #endregion

        #region Numbers
        public int NumberOfParallelTasks { get; set; }

        public int BatchSize { get; set; }
        public int StudentIterationSize { get; set; }

        public int QuantityOfSeas { get; set; }
        public int OldestStartingYear { get; set; }
        public int MinimumAgeOfStudent { get; set; }
        public int MaximumAgeOfStudent { get; set; }

        public int MinimumAverageStudentsPerLea { get; set; }
        public int MaximumAverageStudentsPerLea { get; set; }
        public int MinimumSchoolsPerLeaRural { get; set; }
        public int MaximumSchoolsPerLeaRural { get; set; }
        public int MinimumSchoolsPerLeaUrban { get; set; }
        public int MaximumSchoolsPerLeaUrban { get; set; }

        public int MinimumStudentsPerElementary { get; set; }
        public int MaximumStudentsPerElementary { get; set; }
        public int MinimumStudentsPerMiddleSchool { get; set; }
        public int MaximumStudentsPerMiddleSchool { get; set; }
        public int MinimumStudentsPerHighSchool { get; set; }
        public int MaximumStudentsPerHighSchool { get; set; }

        public int MinimumStudentTeacherRatio { get; set; }
        public int MaximumStudentsTeacherRatio { get; set; }

        public int AverageNumberOfStudentsPerAssessment { get; set; }

        public List<DataDistribution<string>> RefAcademicSubjectDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentPurposeDistribution { get; set; }


        public List<DataDistribution<string>> RefAssessmentTypeAdministeredDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentTypeAdministeredToEnglishLearnersDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentTypeDistribution { get; set; }
        public List<DataDistribution<string>> AssessmentAccommodationTypeDistribution { get; set; }
        public List<DataDistribution<string>> AssessmentAccommodationCategoryDistribution { get; set; }


        #endregion

        #region Organization
        public List<DataDistribution<bool>> IncludePlus4ZipCodeDistribution { get; set; }
        public List<DataDistribution<bool>> HasMailingAddressDistribution { get; set; }
        public List<DataDistribution<bool>> HasShippingAddressDistribution { get; set; }
        public List<DataDistribution<string>> RefOrganizationIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> SharedTimeOrganizationIndicatorValueDistribution { get; set; }
        public List<DataDistribution<string>> RefVirtualSchoolStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIiilanguageInstructionProgramTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIiiAccountability { get; set; }
        public List<DataDistribution<string>> RefTitleIIndicator { get; set; }
        public List<DataDistribution<string>> RefGunFreeSchoolsActReportingStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefHighSchoolGraduationRateIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> RefReconstitutedStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefCteGraduationRateInclusionDistribution { get; set; }
        public List<DataDistribution<bool>> PersistentlyDangerousStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefAmaoAttainmentStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefReapAlternativeFundingStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefFederalProgramFundingAllocationTypeDistribution { get; set; }
        public List<DataDistribution<bool>> HasReceivedMckinneyGrantDistribution { get; set; }
        public List<DataDistribution<bool>> IsOrganizationClosedDistribution { get; set; }


        #endregion

        #region Demographics
        public List<DataDistribution<string>> SexDistribution { get; set; }
        public List<DataDistribution<string>> SexForIdeaDistribution { get; set; }
        public List<DataDistribution<bool>> DisabilityDistribution { get; set; }
        public List<DataDistribution<bool>> HispanicDistribution { get; set; }
        #endregion

        #region Leas
        public List<DataDistribution<string>> LeaGeographicDistribution { get; set; }
        public List<DataDistribution<string>> LeaTypeDistribution { get; set; }
        public List<DataDistribution<bool>> IsCharterLeaDistribution { get; set; }
        public List<DataDistribution<bool>> LeaHasNcesIdDistribution { get; set; }
        public List<DataDistribution<string>> RefK12leaTitleIsupportServiceDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIinstructionalServiceDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIprogramTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefMepProjectTypeDistribution { get; set; }
        public List<DataDistribution<string>> LeaRefOperationalStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefCharterLeaStatusDistribution { get; set; }
        public List<DataDistribution<bool>> IsMcKinneyVentoDistribution { get; set; }


        #endregion

        #region Schools
        public List<DataDistribution<string>> SchoolTypesInLeaDistribution { get; set; }
        public List<DataDistribution<string>> SchoolTypeDistribution { get; set; }
        public List<DataDistribution<bool>> IsCharterSchoolDistribution { get; set; }
        public List<DataDistribution<bool>> HasSecondaryCharterAuthorizerDistribution { get; set; }
        public List<DataDistribution<bool>> HasUpdatedCharterManagerDistribution { get; set; }
        public List<DataDistribution<string>> StatePovertyDesignationDistribution { get; set; }
        public List<DataDistribution<string>> StateAppropriationMethodDistribution { get; set; }
        public List<DataDistribution<bool>> SchoolHasNcesIdDistribution { get; set; }
        public List<DataDistribution<string>> SchoolRefOperationalStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefSchoolImprovementStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefSchoolImprovementFundsDistribution { get; set; }
        public List<DataDistribution<bool>> HasSpecialEdProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasLepProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasSection504ProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasFosterCareProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasImmigrantEducationProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasMigrantEducationProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasCTEProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasNeglectedProgramDistribution { get; set; }
        public List<DataDistribution<bool>> HasHomelessProgramDistribution { get; set; }

        public List<DataDistribution<string>> RefTitleIschoolStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefMagnetSpecialProgramDistribution { get; set; }
        public List<DataDistribution<string>> RefNSLPStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefSchoolDangerousStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefComprehensiveAndTargetedSupportDistribution { get; set; }
        public List<DataDistribution<string>> RefComprehensiveSupportDistribution { get; set; }
        public List<DataDistribution<string>> RefTargetedSupportDistribution { get; set; }
        public List<DataDistribution<string>> RefTargetedSupportImprovementDistribution { get; set; }
        public List<DataDistribution<string>> RefComprehensiveSupportImprovementDistribution { get; set; }
        public List<DataDistribution<string>> RefAdditionalTargetedSupportDistribution { get; set; }
        public List<DataDistribution<bool>> ConsolidatedMepFundsStatusDistribution { get; set; }
        public List<DataDistribution<bool>> HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution { get; set; }
        public List<DataDistribution<string>> ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution { get; set; }

        public List<DataDistribution<bool>> IncludeMajorRaceStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefExitOrWithdrawalTypeDistribution { get; set; }

        #endregion

        #region State Defined Indicators
        public List<DataDistribution<string>> RefIndicatorStatusTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefStateDefinedIndicatorStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefIndicatorStatusSubgroupTypeDistribution { get; set; }
        public List<DataDistribution<string>> IndicatorStatusSubgroup { get; set; }
        public List<DataDistribution<string>> IndicatorStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefIndicatorStatusCustomTypeDistribution { get; set; }
        public List<DataDistribution<string>> StateDefinedIndicatorStatusDistribution { get; set; }
        public List<DataDistribution<string>> RaceSubgroupTypeDistribution { get; set; }
        public List<DataDistribution<string>> DisabilitySubgroupTypeDistribution { get; set; }
        public List<DataDistribution<string>> EnglishLearnerSubgroupTypeDistribution { get; set; }
        public List<DataDistribution<string>> EconomicallyDisadvantagedSubgroupTypeDistribution { get; set; }
        #endregion

        #region Students

        public List<DataDistribution<int>> EcoDisStatusDistribution { get; set; }
        public List<DataDistribution<string>> EligibilityStatusForSchoolFoodServiceProgramsDistribution { get; set; }
        public List<DataDistribution<bool>> HomelessStatusDistribution { get; set; }
        public List<DataDistribution<bool>> HomelessUnaccompaniedYouthStatusDistribution { get; set; }
        public List<DataDistribution<bool>> LepStatusDistribution { get; set; }
        public List<DataDistribution<bool>> LepExitingDistribution { get; set; }
        public List<DataDistribution<bool>> PerkinsLepStatusDistribution { get; set; }
        public List<DataDistribution<bool>> MigrantStatusDistribution { get; set; }
        public List<DataDistribution<bool>> SpecialEdStatusDistribution { get; set; }
        public List<DataDistribution<bool>> ImmigrantTitleIIIStatusDistribution { get; set; }
        public List<DataDistribution<bool>> DisabilityStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefDisabilityTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefIdeaDisabilityTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution { get; set; }
        public List<DataDistribution<string>> RefIDEAEducationalEnvironmentForSchoolAgeDistribution { get; set; }
        public List<DataDistribution<bool>> PersonHomelessnessDistribution { get; set; }
        public List<DataDistribution<string>> HighSchoolDiplomaTypeDistribution { get; set; }
        public List<DataDistribution<string>> PostSecondaryEnrollmentActionDistribution { get; set; }
        public List<DataDistribution<string>> RefHomelessNighttimeResidenceDistribution { get; set; }
        public List<DataDistribution<string>> RefLanguageDistribution { get; set; }
        public List<DataDistribution<string>> RefLanguageUseTypeDistribution { get; set; }
        public List<DataDistribution<int>> NumberOfRacesDistribution { get; set; }
        public List<DataDistribution<string>> RefRaceDistribution { get; set; }
        public List<DataDistribution<bool>> EnrollmentAtOutOfLeaSchoolDistribution { get; set; }
        public List<DataDistribution<int>> NumberOfConcurrentSchoolEnrollmentDistribution { get; set; }
        public List<DataDistribution<bool>> EnrollmentOnlyAtLeaDistribution { get; set; }
        public List<DataDistribution<bool>> EnrollmentExitDuringSchoolYearDistribution { get; set; }

        public List<DataDistribution<bool>> SpecialEdProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> ImmigrantTitleIIIProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> MigrantProgramParticipationDistribution { get; set; }
        public List<DataDistribution<string>> MigrantEducationProgramEnrollmentTypeDistribution { get; set; }
        public List<DataDistribution<string>> MigrantEducationProgramServicesTypeDistribution { get; set; }
        public List<DataDistribution<bool>> MigrantEducationProgramContinuationOfServices { get; set; }
        public List<DataDistribution<string>> ContinuationOfServicesReason { get; set; }
        public List<DataDistribution<bool>> MigrantPrioritizedForServices { get; set; }
        //        public List<DataDistribution<bool>> MilitaryConnectedStudentIndicatorDistribution { get; set; }

        public List<DataDistribution<string>> RefMilitaryConnectedStudentIndicatorDistribution { get; set; }
        public List<DataDistribution<bool>> Section504ProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> FosterCareProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> CteProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> LepProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> NeglectedProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> DelinquentProgramParticipationDistribution { get; set; }
        public List<DataDistribution<string>> RefNeglectedOrDelinquentProgramTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefNeglectedProgramTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefDelinquentProgramTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefProgressLevelDistribution { get; set; }
        public List<DataDistribution<bool>> NorDOutcomeYesNoDistribution { get; set; }
        public List<DataDistribution<bool>> NorDOutcomeExitYesNoDistribution { get; set; }
        public List<DataDistribution<string>> NorDOutcomeDistribution { get; set; }
        public List<DataDistribution<bool>> NorDStatusDistribution { get; set; }
        public List<DataDistribution<bool>> NorDExitingDistribution { get; set; }
        public List<DataDistribution<string>> NorDSubpartDistribution { get; set; }
        public List<DataDistribution<string>> NorDOutcomeExitDistribution { get; set; }
        public List<DataDistribution<bool>> NorDOutcomeIndicatorDistribution { get; set; }
        public List<DataDistribution<bool>> NorDAchievementIndicatorDistribution { get; set; }

        public List<DataDistribution<bool>> HomelessServicedProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> NationalSchoolLunchProgramDirectCertificationIndicatorDistribution { get; set; }

        public List<DataDistribution<bool>> UseDatesInPersonStatusDistribution { get; set; }

        public List<DataDistribution<int>> NumberOfDisciplinesDistribution { get; set; }
        public List<DataDistribution<bool>> GEDPreparationProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> FullAcademicYearPersonStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentParticipationIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentRegistrationReasonNotCompleting { get; set; }
        public List<DataDistribution<string>> RefAssessmentRegistrationReasonNotTested { get; set; }
        public List<DataDistribution<bool>> SpecialEdProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> CteProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> DisplacedHomemakerDistribution { get; set; }

        public List<DataDistribution<bool>> SingleParentOrPregnantWomanDistribution { get; set; }
        public List<DataDistribution<bool>> CteNonTraditionalCompletionDistribution { get; set; }
        public List<DataDistribution<bool>> LepProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> Section504ProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> FosterCareProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> ImmigrantTitleIIIProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> NeglectedProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> HomelessProgramParticipantNowDistribution { get; set; }
        public List<DataDistribution<bool>> CteConcentratorDistribution { get; set; }
        public List<DataDistribution<bool>> CteCompleterDistribution { get; set; }
        public List<DataDistribution<string>> RefSpecialEducationExitReasonDistribution { get; set; }
        public List<DataDistribution<string>> RefIdeaInterimRemovalDistribution { get; set; }

        public List<DataDistribution<string>> ComprehensiveSupport { get; set; }
        public List<DataDistribution<string>> ComprehensiveSupportReasonApplicability { get; set; }
        public List<DataDistribution<string>> Subgroups { get; set; }
        public List<DataDistribution<string>> AccessibleFormatIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> AccessibleFormatRequiredIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> AccessibleFormatTypeDistribution { get; set; }
        public List<DataDistribution<string>> ERSRuralUrbanContinuumCodeDistribution { get; set; }
        public List<DataDistribution<string>> RuralResidencyStatusDistribution { get; set; }
        public List<DataDistribution<bool>> RefIdeaIndicatorDistribution { get; set; }

        #endregion

        #region Personnel

        public List<DataDistribution<bool>> HighlyQualifiedDistribution { get; set; }
        public List<DataDistribution<bool>> IsSpecialEdStaffDistribution { get; set; }
        public List<DataDistribution<decimal>> StaffFteDistribution { get; set; }
        public List<DataDistribution<bool>> IsAeStaffDistribution { get; set; }
        public List<DataDistribution<string>> RefCredentialTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefTeachingCredentialTypeDistribution { get; set; }
        public List<DataDistribution<string>> RefSpecialEducationStaffCategoryDistribution { get; set; }
        public List<DataDistribution<string>> RefK12StaffClassificationDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIProgramStaffCategoryDistribution { get; set; }
        public List<DataDistribution<string>> RefParaprofessionalQualificationDistribution { get; set; }
        public List<DataDistribution<string>> RefInexperiencedStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefOutOfFieldStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefEdFactsCertificationStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefSpecialEducationTeacherQualificationStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefSpecialEducationAgeGroupTaughtDistribution { get; set; }
        public List<DataDistribution<string>> RefProgramTypeDistribution { get; set; }
        # endregion

        #region Charter
        public List<DataDistribution<bool>> CharterSchoolAuthorizerTypeDistribution { get; set; }
        public List<DataDistribution<bool>> CharterRenewalDistribution { get; set; }
        #endregion

        #region Accessibility
        public List<string> SCEDCodes { get; set; }

        #endregion

        public StagingTestDataProfile()
        {
            // Set default values

            #region Global

            this.FederalProgramCodes = new List<string>
            {
                "84.010","84.002","84.011","84.013", "84.027", "84.048", "84.173", "84.196", "84.282", "84.287", "84.323A", "84.334S", "84.358", "84.365A", "84.367A", "84.371", "84.372", "84.424"
            };

            #endregion

            #region Numbers

            this.NumberOfParallelTasks = 4;
            this.BatchSize = 500;
            this.StudentIterationSize = 5000;

            this.QuantityOfSeas = 1;

            this.OldestStartingYear = 2015;

            this.MinimumAgeOfStudent = 4;
            this.MaximumAgeOfStudent = 25;

            this.MinimumAverageStudentsPerLea = 3000;
            this.MaximumAverageStudentsPerLea = 5000;

            this.MinimumSchoolsPerLeaRural = 25;
            this.MaximumSchoolsPerLeaRural = 50;

            this.MinimumSchoolsPerLeaUrban = 50;
            this.MaximumSchoolsPerLeaUrban = 75;


            this.MinimumStudentsPerElementary = 50;
            this.MaximumStudentsPerElementary = 500;

            this.MinimumStudentsPerMiddleSchool = 100;
            this.MaximumStudentsPerMiddleSchool = 1000;

            this.MinimumStudentsPerHighSchool = 100;
            this.MaximumStudentsPerHighSchool = 2000;

            this.MinimumStudentTeacherRatio = 15;
            this.MaximumStudentsTeacherRatio = 25;

            this.AverageNumberOfStudentsPerAssessment = 100;

            this.RefAcademicSubjectDistribution = new List<DataDistribution<string>>();


            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "13373", ExpectedDistribution = 30 }); // Reading/Language Arts
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "01166", ExpectedDistribution = 60 }); // Mathematics
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00562", ExpectedDistribution = 70 }); // Science
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73065", ExpectedDistribution = 80 }); // Career and Technical Education
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00256", ExpectedDistribution = 100 }); // English as a second language (ESL)
                                                                                                                                      //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 100 }); // Other
            this.RefAssessmentPurposeDistribution = new List<DataDistribution<string>>();

            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00050", ExpectedDistribution = 4 }); // Admission
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00051", ExpectedDistribution = 8 }); // Assessment of student's progress
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73055", ExpectedDistribution = 12 }); // College Readiness
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00063", ExpectedDistribution = 16 }); // Course credit
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00064", ExpectedDistribution = 20 }); // Course requirement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73069", ExpectedDistribution = 24 }); // Diagnosis
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03459", ExpectedDistribution = 28 }); // Federal accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73068", ExpectedDistribution = 32 }); // Inform local or state policy
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00055", ExpectedDistribution = 36 }); // Instructional decision
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03457", ExpectedDistribution = 40 }); // Local accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "02404", ExpectedDistribution = 44 }); // Local graduation requirement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73042", ExpectedDistribution = 48 }); // Obtain a state- or industry-recognized certificate or license
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73043", ExpectedDistribution = 52 }); // Obtain postsecondary credit for the course
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73067", ExpectedDistribution = 56 }); // Program eligibility
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00057", ExpectedDistribution = 60 }); // Program evaluation
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00058", ExpectedDistribution = 64 }); // Program placement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00062", ExpectedDistribution = 68 }); // Promotion to or retention in a grade or program
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00061", ExpectedDistribution = 72 }); // Screening
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00054", ExpectedDistribution = 76 }); // State accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 80 }); // Other
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03458", ExpectedDistribution = 100 }); // State graduation requirement

            this.RefAssessmentTypeDistribution = new List<DataDistribution<string>>();

            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AchievementTest", ExpectedDistribution = 2 }); //	AchievementTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AdvancedPlacementTest", ExpectedDistribution = 4 });   //	AdvancedPlacementTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternateAssessmentELL", ExpectedDistribution = 6 });  //	AlternateAssessmentELL
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternateAssessmentGradeLevelStandards", ExpectedDistribution = 8 });  //	AlternateAssessmentGradeLevelStandards
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternativeAssessmentModifiedStandards", ExpectedDistribution = 10 });  //	AlternativeAssessmentModifiedStandards
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AptitudeTest", ExpectedDistribution = 12 });    //	AptitudeTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Benchmark", ExpectedDistribution = 14 });   //	Benchmark
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "CognitiveAndPerceptualSkills", ExpectedDistribution = 16 });    //	CognitiveAndPerceptualSkills
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ComputerAdaptiveTest", ExpectedDistribution = 18 });    //	ComputerAdaptiveTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "DevelopmentalObservation", ExpectedDistribution = 20 });    //	DevelopmentalObservation
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Diagnostic", ExpectedDistribution = 22 });  //	Diagnostic
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "DirectAssessment", ExpectedDistribution = 24 });    //	DirectAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Formative", ExpectedDistribution = 26 });   //	Formative
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "GrowthMeasure", ExpectedDistribution = 28 });   //	GrowthMeasure
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Interim", ExpectedDistribution = 30 }); //	Interim
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "KindergartenReadiness", ExpectedDistribution = 32 });   //	KindergartenReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "LanguageProficiency", ExpectedDistribution = 34 }); //	LanguageProficiency
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "MentalAbility", ExpectedDistribution = 36 });   //	MentalAbility
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Observation", ExpectedDistribution = 38 }); //	Observation
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ParentReport", ExpectedDistribution = 40 });    //	ParentReport
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 42 });   //	PerformanceAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PortfolioAssessment", ExpectedDistribution = 44 }); //	PortfolioAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PrekindergartenReadiness", ExpectedDistribution = 46 });    //	PrekindergartenReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ReadingReadiness", ExpectedDistribution = 48 });    //	ReadingReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Screening", ExpectedDistribution = 50 });   //	Screening
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "TeacherReport", ExpectedDistribution = 52 });   //	TeacherReport
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PerformanceAssessment", ExpectedDistribution = 100 });	//	Other

            this.RefAssessmentTypeAdministeredDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "REGASSWOACC", ExpectedDistribution = 10 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "REGASSWACC", ExpectedDistribution = 15 }); 
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "ALTASSGRADELVL", ExpectedDistribution = 20 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "ALTASSMODACH", ExpectedDistribution = 25 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "ALTASSALTACH", ExpectedDistribution = 30 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "ADVASMTWACC", ExpectedDistribution = 35 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "ADVASMTWOACC", ExpectedDistribution = 40 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "IADAPLASMTWACC", ExpectedDistribution = 45 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "IADAPLASMTWOACC", ExpectedDistribution = 50 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMT2WACC", ExpectedDistribution = 55 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMT2WOACC", ExpectedDistribution = 60 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMT3WACC", ExpectedDistribution = 65 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMT3WOACC", ExpectedDistribution = 70 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMTIWACC", ExpectedDistribution = 80 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "HSREGASMTIWOACC", ExpectedDistribution = 85 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "LSNRHSASMTWACC", ExpectedDistribution = 90 });
            this.RefAssessmentTypeAdministeredDistribution.Add(new DataDistribution<string>() { Option = "LSNRHSASMTWOACC", ExpectedDistribution = 100 });


            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution.Add(new DataDistribution<string>() { Option = "REGELPASMNT", ExpectedDistribution = 70 }); // Regular English language proficiency (ELP) assessment
            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution.Add(new DataDistribution<string>() { Option = "ALTELPASMNTALT", ExpectedDistribution = 100 }); // Alternate English language proficiency (ELP) based on alternate ELP achievement standards

            #endregion

            #region Organization

            this.IsOrganizationClosedDistribution = new List<DataDistribution<bool>>();
            this.IsOrganizationClosedDistribution.Add(new DataDistribution<bool> { Option = false, ExpectedDistribution = 95 });
            this.IsOrganizationClosedDistribution.Add(new DataDistribution<bool> { Option = true, ExpectedDistribution = 100 });

            this.IncludePlus4ZipCodeDistribution = new List<DataDistribution<bool>>();
            this.IncludePlus4ZipCodeDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.IncludePlus4ZipCodeDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasMailingAddressDistribution = new List<DataDistribution<bool>>();
            this.HasMailingAddressDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 40 });
            this.HasMailingAddressDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasShippingAddressDistribution = new List<DataDistribution<bool>>();
            this.HasShippingAddressDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 20 });
            this.HasShippingAddressDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefOrganizationIndicatorDistribution = new List<DataDistribution<string>>();
            this.RefOrganizationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "AP Course Self Selection", ExpectedDistribution = 10 });
            this.RefOrganizationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "SharedTime", ExpectedDistribution = 50 });
            this.RefOrganizationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "AbilityGrouping", ExpectedDistribution = 60 });
            this.RefOrganizationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Virtual", ExpectedDistribution = 100 });

            this.SharedTimeOrganizationIndicatorValueDistribution = new List<DataDistribution<string>>();
            this.SharedTimeOrganizationIndicatorValueDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 50 });
            this.SharedTimeOrganizationIndicatorValueDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 100 });

            this.RefVirtualSchoolStatusDistribution = new List<DataDistribution<string>>();
            this.RefVirtualSchoolStatusDistribution.Add(new DataDistribution<string>() { Option = "NotVirtual", ExpectedDistribution = 60 });
            this.RefVirtualSchoolStatusDistribution.Add(new DataDistribution<string>() { Option = "FullVirtual", ExpectedDistribution = 80 });
            this.RefVirtualSchoolStatusDistribution.Add(new DataDistribution<string>() { Option = "FaceVirtual", ExpectedDistribution = 90 });
            this.RefVirtualSchoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SupplementalVirtual", ExpectedDistribution = 100 });

            this.RefTitleIiilanguageInstructionProgramTypeDistribution = new List<DataDistribution<string>>();
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "DualLanguage", ExpectedDistribution = 20 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "TwoWayImmersion", ExpectedDistribution = 40 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "TransitionalBilingual", ExpectedDistribution = 60 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "ContentBasedESL", ExpectedDistribution = 80 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "PullOutESL", ExpectedDistribution = 90 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 95 });
            this.RefTitleIiilanguageInstructionProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "NewcomerPrograms", ExpectedDistribution = 100 });

            this.RefTitleIiiAccountability = new List<DataDistribution<string>>();
            this.RefTitleIiiAccountability.Add(new DataDistribution<string>() { Option = "PROGRESS", ExpectedDistribution = 33 });
            this.RefTitleIiiAccountability.Add(new DataDistribution<string>() { Option = "NOPROGRESS", ExpectedDistribution = 66 });
            this.RefTitleIiiAccountability.Add(new DataDistribution<string>() { Option = "PROFICIENT", ExpectedDistribution = 100 });

            this.RefTitleIIndicator = new List<DataDistribution<string>>();
            this.RefTitleIIndicator.Add(new DataDistribution<string>() { Option = "01", ExpectedDistribution = 20 });  //Public Targeted Assistance Program
            this.RefTitleIIndicator.Add(new DataDistribution<string>() { Option = "02", ExpectedDistribution = 40 });  //Public Schoolwide Program
            this.RefTitleIIndicator.Add(new DataDistribution<string>() { Option = "03", ExpectedDistribution = 60 }); //Private school students participating
            this.RefTitleIIndicator.Add(new DataDistribution<string>() { Option = "04", ExpectedDistribution = 80 }); //Local Neglected Program
            this.RefTitleIIndicator.Add(new DataDistribution<string>() { Option = "05", ExpectedDistribution = 100 }); //Was not served


            this.RefGunFreeSchoolsActReportingStatusDistribution = new List<DataDistribution<string>>();
            this.RefGunFreeSchoolsActReportingStatusDistribution.Add(new DataDistribution<string>() { Option = "YesReportingOffenses", ExpectedDistribution = 20 });
            this.RefGunFreeSchoolsActReportingStatusDistribution.Add(new DataDistribution<string>() { Option = "YesNoReportedOffenses", ExpectedDistribution = 40 });
            this.RefGunFreeSchoolsActReportingStatusDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 80 });
            this.RefGunFreeSchoolsActReportingStatusDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 100 });

            this.RefHighSchoolGraduationRateIndicatorDistribution = new List<DataDistribution<string>>();
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "MetGoal", ExpectedDistribution = 50 });
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "MetTarget", ExpectedDistribution = 70 });
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "DidNotMeet", ExpectedDistribution = 80 });
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "TooFewStudents", ExpectedDistribution = 90 });
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "NoStudents", ExpectedDistribution = 95 });
            this.RefHighSchoolGraduationRateIndicatorDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 100 });

            this.RefReconstitutedStatusDistribution = new List<DataDistribution<string>>();
            this.RefReconstitutedStatusDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 80 });
            this.RefReconstitutedStatusDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 100 });

            this.RefCteGraduationRateInclusionDistribution = new List<DataDistribution<string>>();
            this.RefCteGraduationRateInclusionDistribution.Add(new DataDistribution<string>() { Option = "IncludedAsGraduated", ExpectedDistribution = 80 });
            this.RefCteGraduationRateInclusionDistribution.Add(new DataDistribution<string>() { Option = "NotIncludedAsGraduated", ExpectedDistribution = 100 });

            this.PersistentlyDangerousStatusDistribution = new List<DataDistribution<bool>>();
            this.PersistentlyDangerousStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.PersistentlyDangerousStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.RefAmaoAttainmentStatusDistribution = new List<DataDistribution<string>>();
            this.RefAmaoAttainmentStatusDistribution.Add(new DataDistribution<string>() { Option = "Met", ExpectedDistribution = 60 });
            this.RefAmaoAttainmentStatusDistribution.Add(new DataDistribution<string>() { Option = "DidNotMeet", ExpectedDistribution = 80 });
            this.RefAmaoAttainmentStatusDistribution.Add(new DataDistribution<string>() { Option = "NoTitleIII", ExpectedDistribution = 90 });
            this.RefAmaoAttainmentStatusDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 100 });

            this.RefReapAlternativeFundingStatusDistribution = new List<DataDistribution<string>>();
            this.RefReapAlternativeFundingStatusDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 40 });
            this.RefReapAlternativeFundingStatusDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 80 });
            this.RefReapAlternativeFundingStatusDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 100 });

            this.RefFederalProgramFundingAllocationTypeDistribution = new List<DataDistribution<string>>();
            this.RefFederalProgramFundingAllocationTypeDistribution.Add(new DataDistribution<string>() { Option = "RETAINED", ExpectedDistribution = 25 });
            this.RefFederalProgramFundingAllocationTypeDistribution.Add(new DataDistribution<string>() { Option = "TRANSFER", ExpectedDistribution = 50 });
            this.RefFederalProgramFundingAllocationTypeDistribution.Add(new DataDistribution<string>() { Option = "DISTNONLEA", ExpectedDistribution = 75 });
            this.RefFederalProgramFundingAllocationTypeDistribution.Add(new DataDistribution<string>() { Option = "UNALLOC", ExpectedDistribution = 100 });

            this.HasReceivedMckinneyGrantDistribution = new List<DataDistribution<bool>>();
            this.HasReceivedMckinneyGrantDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.HasReceivedMckinneyGrantDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });


            #endregion

            #region Demographics

            this.SexDistribution = new List<DataDistribution<string>>();
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Female", ExpectedDistribution = 49 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Male", ExpectedDistribution = 98 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "NotSelected", ExpectedDistribution = 100 });

            this.SexForIdeaDistribution = new List<DataDistribution<string>>();
            this.SexForIdeaDistribution.Add(new DataDistribution<string>() { Option = "Male", ExpectedDistribution = 66 });
            this.SexForIdeaDistribution.Add(new DataDistribution<string>() { Option = "Female", ExpectedDistribution = 100 });
            this.SexForIdeaDistribution.Add(new DataDistribution<string>() { Option = "NotSelected", ExpectedDistribution = 102 });

            this.HispanicDistribution = new List<DataDistribution<bool>>();
            this.HispanicDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.HispanicDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            #endregion

            #region Leas

            this.LeaGeographicDistribution = new List<DataDistribution<string>>();
            this.LeaGeographicDistribution.Add(new DataDistribution<string>() { Option = "Rural", ExpectedDistribution = 85 });
            this.LeaGeographicDistribution.Add(new DataDistribution<string>() { Option = "Urban", ExpectedDistribution = 100 });

            this.LeaTypeDistribution = new List<DataDistribution<string>>();
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "RegularNotInSupervisoryUnion", ExpectedDistribution = 80 });
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "SupervisoryUnion", ExpectedDistribution = 88 });
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "SpecializedPublicSchoolDistrict", ExpectedDistribution = 92 });
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "ServiceAgency", ExpectedDistribution = 96 });
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "StateOperatedAgency", ExpectedDistribution = 98 });
            this.LeaTypeDistribution.Add(new DataDistribution<string>() { Option = "FederalOperatedAgency", ExpectedDistribution = 100 });

            this.IsCharterLeaDistribution = new List<DataDistribution<bool>>();
            this.IsCharterLeaDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 90 });
            this.IsCharterLeaDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.LeaHasNcesIdDistribution = new List<DataDistribution<bool>>();
            this.LeaHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.LeaHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefK12leaTitleIsupportServiceDistribution = new List<DataDistribution<string>>();
            this.RefK12leaTitleIsupportServiceDistribution.Add(new DataDistribution<string>() { Option = "HealthDentalEyeCare", ExpectedDistribution = 40 });
            this.RefK12leaTitleIsupportServiceDistribution.Add(new DataDistribution<string>() { Option = "GuidanceAdvocacy", ExpectedDistribution = 70 });
            this.RefK12leaTitleIsupportServiceDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 100 });

            this.RefTitleIinstructionalServiceDistribution = new List<DataDistribution<string>>();
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "ReadingLanguageArts", ExpectedDistribution = 20 });
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "Mathematics", ExpectedDistribution = 40 });
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "Science", ExpectedDistribution = 60 });
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "SocialSciences", ExpectedDistribution = 80 });
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "CareerAndTechnical", ExpectedDistribution = 90 });
            this.RefTitleIinstructionalServiceDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 100 });

            this.RefTitleIprogramTypeDistribution = new List<DataDistribution<string>>();
            this.RefTitleIprogramTypeDistribution.Add(new DataDistribution<string>() { Option = "TargetedAssistanceProgram", ExpectedDistribution = 25 });
            this.RefTitleIprogramTypeDistribution.Add(new DataDistribution<string>() { Option = "SchoolwideProgram", ExpectedDistribution = 50 });
            this.RefTitleIprogramTypeDistribution.Add(new DataDistribution<string>() { Option = "PrivateSchoolStudents", ExpectedDistribution = 75 });
            this.RefTitleIprogramTypeDistribution.Add(new DataDistribution<string>() { Option = "LocalNeglectedProgram", ExpectedDistribution = 100 });

            this.RefMepProjectTypeDistribution = new List<DataDistribution<string>>();
            this.RefMepProjectTypeDistribution.Add(new DataDistribution<string>() { Option = "SchoolDay", ExpectedDistribution = 25 });
            this.RefMepProjectTypeDistribution.Add(new DataDistribution<string>() { Option = "ExtendedDay", ExpectedDistribution = 50 });
            this.RefMepProjectTypeDistribution.Add(new DataDistribution<string>() { Option = "SummerIntersession", ExpectedDistribution = 75 });
            this.RefMepProjectTypeDistribution.Add(new DataDistribution<string>() { Option = "YearRound", ExpectedDistribution = 100 });

            this.LeaRefOperationalStatusDistribution = new List<DataDistribution<string>>();
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Open", ExpectedDistribution = 70 });
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "New", ExpectedDistribution = 80 });
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Added", ExpectedDistribution = 85 });
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "ChangedBoundary", ExpectedDistribution = 90 });
            //this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Inactive", ExpectedDistribution = 92 });
            //this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "FutureAgency", ExpectedDistribution = 95 });
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Closed", ExpectedDistribution = 95 });
            this.LeaRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Reopened", ExpectedDistribution = 100 });

            this.RefCharterLeaStatusDistribution = new List<DataDistribution<string>>();
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "CHRTNOTLEA", ExpectedDistribution = 50 });
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "CHRTIDEA", ExpectedDistribution = 60 });
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "CHRTESEA", ExpectedDistribution = 70 });
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "CHRTIDEAESEA", ExpectedDistribution = 80 });
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 90 });
            this.RefCharterLeaStatusDistribution.Add(new DataDistribution<string>() { Option = "NOTCHR", ExpectedDistribution = 100 });

            this.IsMcKinneyVentoDistribution = new List<DataDistribution<bool>>();
            this.IsMcKinneyVentoDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.IsMcKinneyVentoDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            #endregion

            #region Schools

            this.SchoolTypesInLeaDistribution = new List<DataDistribution<string>>();
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "Elementary", ExpectedDistribution = 25 });
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "Middle School", ExpectedDistribution = 50 });
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "Junior High", ExpectedDistribution = 60 });
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "High School", ExpectedDistribution = 90 });
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "Academy", ExpectedDistribution = 95 });
            this.SchoolTypesInLeaDistribution.Add(new DataDistribution<string>() { Option = "Adult", ExpectedDistribution = 100 });


            this.SchoolTypeDistribution = new List<DataDistribution<string>>();
            this.SchoolTypeDistribution.Add(new DataDistribution<string>() { Option = "Regular", ExpectedDistribution = 70 });
            this.SchoolTypeDistribution.Add(new DataDistribution<string>() { Option = "Special", ExpectedDistribution = 80 });
            this.SchoolTypeDistribution.Add(new DataDistribution<string>() { Option = "CareerAndTechnical", ExpectedDistribution = 90 });
            this.SchoolTypeDistribution.Add(new DataDistribution<string>() { Option = "Alternative", ExpectedDistribution = 100 });

            this.IsCharterSchoolDistribution = new List<DataDistribution<bool>>();
            this.IsCharterSchoolDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.IsCharterSchoolDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.HasSecondaryCharterAuthorizerDistribution = new List<DataDistribution<bool>>();
            this.HasSecondaryCharterAuthorizerDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.HasSecondaryCharterAuthorizerDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.HasUpdatedCharterManagerDistribution = new List<DataDistribution<bool>>();
            this.HasUpdatedCharterManagerDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.HasUpdatedCharterManagerDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.StatePovertyDesignationDistribution = new List<DataDistribution<string>>();
            this.StatePovertyDesignationDistribution.Add(new DataDistribution<string>() { Option = "Neither", ExpectedDistribution = 60 });
            this.StatePovertyDesignationDistribution.Add(new DataDistribution<string>() { Option = "LowQuartile", ExpectedDistribution = 80 });
            this.StatePovertyDesignationDistribution.Add(new DataDistribution<string>() { Option = "HighQuartile", ExpectedDistribution = 100 });

            this.StateAppropriationMethodDistribution = new List<DataDistribution<string>>();
            this.StateAppropriationMethodDistribution.Add(new DataDistribution<string>() { Option = "STEAPRDRCT", ExpectedDistribution = 60 });
            this.StateAppropriationMethodDistribution.Add(new DataDistribution<string>() { Option = "STEAPRTHRULEA", ExpectedDistribution = 80 });
            this.StateAppropriationMethodDistribution.Add(new DataDistribution<string>() { Option = "STEAPRALLOCLEA", ExpectedDistribution = 100 });


            this.SchoolHasNcesIdDistribution = new List<DataDistribution<bool>>();
            this.SchoolHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.SchoolHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.SchoolRefOperationalStatusDistribution = new List<DataDistribution<string>>();
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Open", ExpectedDistribution = 50 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Closed", ExpectedDistribution = 60 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "New", ExpectedDistribution = 65 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Added", ExpectedDistribution = 70 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "ChangedAgency", ExpectedDistribution = 75 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Inactive", ExpectedDistribution = 80 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "FutureSchool", ExpectedDistribution = 85 });
            this.SchoolRefOperationalStatusDistribution.Add(new DataDistribution<string>() { Option = "Reopened", ExpectedDistribution = 100 });

            this.RefSchoolImprovementStatusDistribution = new List<DataDistribution<string>>();
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "CorrectiveAction", ExpectedDistribution = 20 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "Year1", ExpectedDistribution = 30 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "Year2", ExpectedDistribution = 40 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "Planning", ExpectedDistribution = 50 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "Restructuring", ExpectedDistribution = 60 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "NA", ExpectedDistribution = 70 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "FS", ExpectedDistribution = 80 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "PS", ExpectedDistribution = 90 });
            this.RefSchoolImprovementStatusDistribution.Add(new DataDistribution<string>() { Option = "NFPS", ExpectedDistribution = 100 });

            this.RefSchoolImprovementFundsDistribution = new List<DataDistribution<string>>();
            this.RefSchoolImprovementFundsDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 40 });
            this.RefSchoolImprovementFundsDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 100 });

            this.HasSpecialEdProgramDistribution = new List<DataDistribution<bool>>();
            this.HasSpecialEdProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasSpecialEdProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasLepProgramDistribution = new List<DataDistribution<bool>>();
            this.HasLepProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasLepProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasSection504ProgramDistribution = new List<DataDistribution<bool>>();
            this.HasSection504ProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasSection504ProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasFosterCareProgramDistribution = new List<DataDistribution<bool>>();
            this.HasFosterCareProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasFosterCareProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasImmigrantEducationProgramDistribution = new List<DataDistribution<bool>>();
            this.HasImmigrantEducationProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasImmigrantEducationProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasMigrantEducationProgramDistribution = new List<DataDistribution<bool>>();
            this.HasMigrantEducationProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasMigrantEducationProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasCTEProgramDistribution = new List<DataDistribution<bool>>();
            this.HasCTEProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasCTEProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasNeglectedProgramDistribution = new List<DataDistribution<bool>>();
            this.HasNeglectedProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasNeglectedProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasHomelessProgramDistribution = new List<DataDistribution<bool>>();
            this.HasHomelessProgramDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.HasHomelessProgramDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefTitleIschoolStatusDistribution = new List<DataDistribution<string>>();
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "TGELGBNOPROG", ExpectedDistribution = 10 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "TGELGBTGPROG", ExpectedDistribution = 20 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGTGPROG", ExpectedDistribution = 30 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGNOPROG", ExpectedDistribution = 40 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGSWPROG", ExpectedDistribution = 50 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "NOTTITLE1ELIG", ExpectedDistribution = 100 });


            this.RefMagnetSpecialProgramDistribution = new List<DataDistribution<string>>();
            this.RefMagnetSpecialProgramDistribution.Add(new DataDistribution<string>() { Option = "All", ExpectedDistribution = 33 });
            this.RefMagnetSpecialProgramDistribution.Add(new DataDistribution<string>() { Option = "None", ExpectedDistribution = 66 });
            this.RefMagnetSpecialProgramDistribution.Add(new DataDistribution<string>() { Option = "Some", ExpectedDistribution = 100 });

            this.RefNSLPStatusDistribution = new List<DataDistribution<string>>();
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPWOPRO", ExpectedDistribution = 25 });
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPPRO1", ExpectedDistribution = 40 });
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPPRO2", ExpectedDistribution = 55 });
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPPRO3", ExpectedDistribution = 70 });
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPCEO", ExpectedDistribution = 85 });
            this.RefNSLPStatusDistribution.Add(new DataDistribution<string>() { Option = "NSLPNO", ExpectedDistribution = 100 });

            this.RefSchoolDangerousStatusDistribution = new List<DataDistribution<string>>();
            this.RefSchoolDangerousStatusDistribution.Add(new DataDistribution<string>() { Option = "YES", ExpectedDistribution = 50 });
            this.RefSchoolDangerousStatusDistribution.Add(new DataDistribution<string>() { Option = "NO", ExpectedDistribution = 100 });


            this.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution = new List<DataDistribution<string>>();
            this.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "STTDEF", ExpectedDistribution = 33 });
            this.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "TOOFEW", ExpectedDistribution = 66 });
            this.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "NOSTUDENTS", ExpectedDistribution = 100 });


            this.RefComprehensiveAndTargetedSupportDistribution = new List<DataDistribution<string>>();
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "CSI", ExpectedDistribution = 15 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "TSI", ExpectedDistribution = 30 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "ADDLTSI", ExpectedDistribution = 45 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "CSIEXIT", ExpectedDistribution = 60 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "TSIEXIT", ExpectedDistribution = 75 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "NOTCSI", ExpectedDistribution = 85 });
            this.RefComprehensiveAndTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "NOTTSI", ExpectedDistribution = 95 });


            this.RefComprehensiveSupportDistribution = new List<DataDistribution<string>>();
            this.RefComprehensiveSupportDistribution.Add(new DataDistribution<string>() { Option = "CSILOWPERF", ExpectedDistribution = 25 });
            this.RefComprehensiveSupportDistribution.Add(new DataDistribution<string>() { Option = "CSILOWGR", ExpectedDistribution = 50 });
            this.RefComprehensiveSupportDistribution.Add(new DataDistribution<string>() { Option = "CSIOTHER", ExpectedDistribution = 75 });

            this.RefTargetedSupportDistribution = new List<DataDistribution<string>>();
            this.RefTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "TSIUNDER", ExpectedDistribution = 33 });
            this.RefTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "TSIOTHER", ExpectedDistribution = 66 });

            this.RefTargetedSupportImprovementDistribution = new List<DataDistribution<string>>();
            this.RefTargetedSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "TSI", ExpectedDistribution = 30 });
            this.RefTargetedSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "TSIEXIT", ExpectedDistribution = 60 });
            this.RefTargetedSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "NOTTSI", ExpectedDistribution = 75 });

            this.RefComprehensiveSupportImprovementDistribution = new List<DataDistribution<string>>();
            this.RefComprehensiveSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "CSI", ExpectedDistribution = 30 });
            this.RefComprehensiveSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "CSIEXIT", ExpectedDistribution = 60 });
            this.RefComprehensiveSupportImprovementDistribution.Add(new DataDistribution<string>() { Option = "NOTCSI", ExpectedDistribution = 75 });

            this.RefAdditionalTargetedSupportDistribution = new List<DataDistribution<string>>();
            this.RefAdditionalTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "ADDLTSI", ExpectedDistribution = 30 });
            this.RefAdditionalTargetedSupportDistribution.Add(new DataDistribution<string>() { Option = "NOTADDLTSI", ExpectedDistribution = 60 });

            this.ConsolidatedMepFundsStatusDistribution = new List<DataDistribution<bool>>();
            this.ConsolidatedMepFundsStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 60 });
            this.ConsolidatedMepFundsStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution = new List<DataDistribution<bool>>();
            this.HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 60 });
            this.HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution = new List<DataDistribution<string>>();
            this.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution.Add(new DataDistribution<string>() { Option = "Blue", ExpectedDistribution = 33 });
            this.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution.Add(new DataDistribution<string>() { Option = "Green", ExpectedDistribution = 66 });
            this.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution.Add(new DataDistribution<string>() { Option = "Yellow", ExpectedDistribution = 100 });



            this.ComprehensiveSupport = new List<DataDistribution<string>>();
            this.ComprehensiveSupport.Add(new DataDistribution<string>() { Option = "CSILOWPERF", ExpectedDistribution = 30 });
            this.ComprehensiveSupport.Add(new DataDistribution<string>() { Option = "CSILOWGR", ExpectedDistribution = 60 });
            this.ComprehensiveSupport.Add(new DataDistribution<string>() { Option = "CSIOTHER", ExpectedDistribution = 90 });
            this.ComprehensiveSupport.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.ComprehensiveSupportReasonApplicability = new List<DataDistribution<string>>();
            this.ComprehensiveSupportReasonApplicability.Add(new DataDistribution<string>() { Option = "ReasonApplies", ExpectedDistribution = 50 });
            this.ComprehensiveSupportReasonApplicability.Add(new DataDistribution<string>() { Option = "ReasonDoesNotApply", ExpectedDistribution = 100 });

            this.CharterRenewalDistribution = new List<DataDistribution<bool>>();
            this.CharterRenewalDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.CharterRenewalDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            //this.Subgroup = new List<DataDistribution<string>>();
            //this.Subgroup.Add(new DataDistribution<string>() { Option = "EconomicDisadvantage", ExpectedDistribution = 50 });
            //this.Subgroup.Add(new DataDistribution<string>() { Option = "ReasonDoesNotApply", ExpectedDistribution = 50 });

            #endregion

            #region State Defined Statuses
            this.RefIndicatorStatusTypeDistribution = new List<DataDistribution<string>>();
            this.RefIndicatorStatusTypeDistribution.Add(new DataDistribution<string>() { Option = "GraduationRateIndicatorStatus", ExpectedDistribution = 25 });
            this.RefIndicatorStatusTypeDistribution.Add(new DataDistribution<string>() { Option = "AcademicAchievementIndicatorStatus", ExpectedDistribution = 50 });
            this.RefIndicatorStatusTypeDistribution.Add(new DataDistribution<string>() { Option = "OtherAcademicIndicatorStatus", ExpectedDistribution = 75 });
            this.RefIndicatorStatusTypeDistribution.Add(new DataDistribution<string>() { Option = "SchoolQualityOrStudentSuccessIndicatorStatus", ExpectedDistribution = 100 });

            this.RefStateDefinedIndicatorStatusDistribution = new List<DataDistribution<string>>();
            this.RefStateDefinedIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "STTDEF", ExpectedDistribution = 30 });
            this.RefStateDefinedIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "TOOFEW", ExpectedDistribution = 60 });
            this.RefStateDefinedIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "NOSTUDENTS", ExpectedDistribution = 90 });
            this.RefStateDefinedIndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.RefIndicatorStatusSubgroupTypeDistribution = new List<DataDistribution<string>>();
            this.RefIndicatorStatusSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "RaceEthnicity", ExpectedDistribution = 20 });
            this.RefIndicatorStatusSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "DisabilityStatus", ExpectedDistribution = 40 });
            this.RefIndicatorStatusSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "EnglishLearnerStatus", ExpectedDistribution = 60 });
            this.RefIndicatorStatusSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "EconomicallyDisadvantagedStatus", ExpectedDistribution = 80 });
            this.RefIndicatorStatusSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "AllStudents", ExpectedDistribution = 100 });

            this.RaceSubgroupTypeDistribution = new List<DataDistribution<string>>();
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MA", ExpectedDistribution = 9 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MAP", ExpectedDistribution = 18 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MB", ExpectedDistribution = 27 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MF", ExpectedDistribution = 36 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MHN", ExpectedDistribution = 45 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MHL", ExpectedDistribution = 54 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MM", ExpectedDistribution = 63 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MNP", ExpectedDistribution = 72 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MPR", ExpectedDistribution = 81 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MW", ExpectedDistribution = 90 });
            this.RaceSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.DisabilitySubgroupTypeDistribution = new List<DataDistribution<string>>();
            this.DisabilitySubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "WDIS", ExpectedDistribution = 50 });
            this.DisabilitySubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.EnglishLearnerSubgroupTypeDistribution = new List<DataDistribution<string>>();
            this.EnglishLearnerSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "LEP", ExpectedDistribution = 50 });
            this.EnglishLearnerSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.EconomicallyDisadvantagedSubgroupTypeDistribution = new List<DataDistribution<string>>();
            this.EconomicallyDisadvantagedSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "ECODIS", ExpectedDistribution = 50 });
            this.EconomicallyDisadvantagedSubgroupTypeDistribution.Add(new DataDistribution<string>() { Option = "MISSING", ExpectedDistribution = 100 });

            this.RefIndicatorStatusCustomTypeDistribution = new List<DataDistribution<string>>();
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND01", ExpectedDistribution = 10 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND02", ExpectedDistribution = 20 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND03", ExpectedDistribution = 30 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND04", ExpectedDistribution = 40 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND05", ExpectedDistribution = 50 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND06", ExpectedDistribution = 60 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND07", ExpectedDistribution = 70 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND08", ExpectedDistribution = 80 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND09", ExpectedDistribution = 90 });
            this.RefIndicatorStatusCustomTypeDistribution.Add(new DataDistribution<string>() { Option = "IND10", ExpectedDistribution = 100 });

            this.IndicatorStatusDistribution = new List<DataDistribution<string>>();
            this.IndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "Green", ExpectedDistribution = 33 });
            this.IndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "Yellow", ExpectedDistribution = 66 });
            this.IndicatorStatusDistribution.Add(new DataDistribution<string>() { Option = "Red", ExpectedDistribution = 100 });
            #endregion

            #region Students

            this.EcoDisStatusDistribution = new List<DataDistribution<int>>();
            this.EcoDisStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.EcoDisStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.EcoDisStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.EligibilityStatusForSchoolFoodServiceProgramsDistribution = new List<DataDistribution<string>>();
            this.EligibilityStatusForSchoolFoodServiceProgramsDistribution.Add(new DataDistribution<string>() { Option = "Free", ExpectedDistribution = 30 });
            this.EligibilityStatusForSchoolFoodServiceProgramsDistribution.Add(new DataDistribution<string>() { Option = "FullPrice", ExpectedDistribution = 70 });
            this.EligibilityStatusForSchoolFoodServiceProgramsDistribution.Add(new DataDistribution<string>() { Option = "ReducedPrice", ExpectedDistribution = 95 });
            this.EligibilityStatusForSchoolFoodServiceProgramsDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 100 });

            this.HomelessStatusDistribution = new List<DataDistribution<bool>>();
            this.HomelessStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 1 });
            this.HomelessStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HomelessUnaccompaniedYouthStatusDistribution = new List<DataDistribution<bool>>();
            this.HomelessUnaccompaniedYouthStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.HomelessUnaccompaniedYouthStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.LepStatusDistribution = new List<DataDistribution<bool>>();
            this.LepStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 20 });
            this.LepStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.LepExitingDistribution = new List<DataDistribution<bool>>();
            this.LepExitingDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 10 });
            this.LepExitingDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.PerkinsLepStatusDistribution = new List<DataDistribution<bool>>();
            this.PerkinsLepStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 20 });
            this.PerkinsLepStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.MigrantStatusDistribution = new List<DataDistribution<bool>>();
            this.MigrantStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 10 });
            this.MigrantStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.SpecialEdStatusDistribution = new List<DataDistribution<bool>>();
            this.SpecialEdStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.SpecialEdStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.ImmigrantTitleIIIStatusDistribution = new List<DataDistribution<bool>>();
            this.ImmigrantTitleIIIStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 15 });
            this.ImmigrantTitleIIIStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.DisabilityStatusDistribution = new List<DataDistribution<bool>>();
            this.DisabilityStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.DisabilityStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefDisabilityTypeDistribution = new List<DataDistribution<string>>();
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "AUT", ExpectedDistribution = 12 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "DB", ExpectedDistribution = 13 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "DD", ExpectedDistribution = 14 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "EMN", ExpectedDistribution = 23 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "HI", ExpectedDistribution = 24 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "ID", ExpectedDistribution = 30 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "MD", ExpectedDistribution = 32 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "OI", ExpectedDistribution = 33 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "OHI", ExpectedDistribution = 50 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "SLD", ExpectedDistribution = 84 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "SLI", ExpectedDistribution = 102 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "TBI", ExpectedDistribution = 103 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "VI", ExpectedDistribution = 104 });

            this.RefIdeaDisabilityTypeDistribution = new List<DataDistribution<string>>();
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Autism", ExpectedDistribution = 12 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Deafblindness", ExpectedDistribution = 13 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Deafness", ExpectedDistribution = 14 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Developmentaldelay", ExpectedDistribution = 18 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Emotionaldisturbance", ExpectedDistribution = 23 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Hearingimpairment", ExpectedDistribution = 24 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Intellectualdisability", ExpectedDistribution = 30 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Multipledisabilities", ExpectedDistribution = 32 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Orthopedicimpairment", ExpectedDistribution = 33 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Otherhealthimpairment", ExpectedDistribution = 50 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Specificlearningdisability", ExpectedDistribution = 84 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Speechlanguageimpairment", ExpectedDistribution = 102 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Traumaticbraininjury", ExpectedDistribution = 103 });
            this.RefIdeaDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "Visualimpairment", ExpectedDistribution = 104 });

            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution = new List<DataDistribution<string>>();
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "RC80", ExpectedDistribution = 67 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "RC79TO40", ExpectedDistribution = 83 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "RC39", ExpectedDistribution = 96 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "SS", ExpectedDistribution = 98 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "RF", ExpectedDistribution = 99 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "HH", ExpectedDistribution = 100 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "CF", ExpectedDistribution = 101 });
            this.RefIDEAEducationalEnvironmentForSchoolAgeDistribution.Add(new DataDistribution<string>() { Option = "PPPS", ExpectedDistribution = 103 });
            
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution = new List<DataDistribution<string>>();
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "REC10YSVCS", ExpectedDistribution = 67 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "REC09YSVCS", ExpectedDistribution = 83 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "REC10YOTHLOC", ExpectedDistribution = 89 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "REC09YOTHLOC", ExpectedDistribution = 92 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "SC", ExpectedDistribution = 93 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "SS", ExpectedDistribution = 95 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "RF", ExpectedDistribution = 96 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "H", ExpectedDistribution = 97 });
            this.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution.Add(new DataDistribution<string>() { Option = "SPL", ExpectedDistribution = 100 });

            this.PersonHomelessnessDistribution = new List<DataDistribution<bool>>();
            this.PersonHomelessnessDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 1 });
            this.PersonHomelessnessDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.HighSchoolDiplomaTypeDistribution = new List<DataDistribution<string>>();
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00806", ExpectedDistribution = 10 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00807", ExpectedDistribution = 20 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00808", ExpectedDistribution = 30 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00809", ExpectedDistribution = 40 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00810", ExpectedDistribution = 50 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00811", ExpectedDistribution = 60 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00812", ExpectedDistribution = 65 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00813", ExpectedDistribution = 70 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00814", ExpectedDistribution = 75 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00815", ExpectedDistribution = 80 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00816", ExpectedDistribution = 85 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00818", ExpectedDistribution = 90 });
            this.HighSchoolDiplomaTypeDistribution.Add(new DataDistribution<string>() { Option = "00819", ExpectedDistribution = 100 });

            this.PostSecondaryEnrollmentActionDistribution = new List<DataDistribution<string>>();
            this.PostSecondaryEnrollmentActionDistribution.Add(new DataDistribution<string>() { Option = "NoInformation", ExpectedDistribution = 10 });
            this.PostSecondaryEnrollmentActionDistribution.Add(new DataDistribution<string>() { Option = "Enrolled", ExpectedDistribution = 40 });
            this.PostSecondaryEnrollmentActionDistribution.Add(new DataDistribution<string>() { Option = "NotEnrolled", ExpectedDistribution = 100 });

            this.RefHomelessNighttimeResidenceDistribution = new List<DataDistribution<string>>();
            this.RefHomelessNighttimeResidenceDistribution.Add(new DataDistribution<string>() { Option = "Shelter", ExpectedDistribution = 30 });
            this.RefHomelessNighttimeResidenceDistribution.Add(new DataDistribution<string>() { Option = "DoubledUp", ExpectedDistribution = 50 });
            this.RefHomelessNighttimeResidenceDistribution.Add(new DataDistribution<string>() { Option = "Unsheltered", ExpectedDistribution = 80 });
            this.RefHomelessNighttimeResidenceDistribution.Add(new DataDistribution<string>() { Option = "HotelMotel", ExpectedDistribution = 100 });

            this.RefLanguageDistribution = new List<DataDistribution<string>>();
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "eng", ExpectedDistribution = 70 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "spa", ExpectedDistribution = 80 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "chi", ExpectedDistribution = 82 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "hin", ExpectedDistribution = 84 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "fre", ExpectedDistribution = 86 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "ger", ExpectedDistribution = 88 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "rus", ExpectedDistribution = 90 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "ara", ExpectedDistribution = 92 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "swe", ExpectedDistribution = 94 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "jpn", ExpectedDistribution = 96 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "kor", ExpectedDistribution = 98 });
            this.RefLanguageDistribution.Add(new DataDistribution<string>() { Option = "vie", ExpectedDistribution = 100 });

            this.RefLanguageUseTypeDistribution = new List<DataDistribution<string>>();
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "Native", ExpectedDistribution = 60 });
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "Home", ExpectedDistribution = 70 });
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "Dominant", ExpectedDistribution = 80 });
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "Correspondence", ExpectedDistribution = 90 });
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "OtherLanguageProficiency", ExpectedDistribution = 95 });
            this.RefLanguageUseTypeDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 100 });

            this.NumberOfRacesDistribution = new List<DataDistribution<int>>();
            this.NumberOfRacesDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 10 });
            this.NumberOfRacesDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 70 });
            this.NumberOfRacesDistribution.Add(new DataDistribution<int>() { Option = 2, ExpectedDistribution = 90 });
            this.NumberOfRacesDistribution.Add(new DataDistribution<int>() { Option = 3, ExpectedDistribution = 100 });

            this.RefRaceDistribution = new List<DataDistribution<string>>();
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "AmericanIndianorAlaskaNative", ExpectedDistribution = 5 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "Asian", ExpectedDistribution = 15 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "BlackorAfricanAmerican", ExpectedDistribution = 35 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "NativeHawaiianorOtherPacificIslander", ExpectedDistribution = 40 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "White", ExpectedDistribution = 95 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "TwoorMoreRaces", ExpectedDistribution = 100 });


            this.NumberOfConcurrentSchoolEnrollmentDistribution = new List<DataDistribution<int>>();
            this.NumberOfConcurrentSchoolEnrollmentDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 98 });
            this.NumberOfConcurrentSchoolEnrollmentDistribution.Add(new DataDistribution<int>() { Option = 2, ExpectedDistribution = 99 });
            this.NumberOfConcurrentSchoolEnrollmentDistribution.Add(new DataDistribution<int>() { Option = 3, ExpectedDistribution = 100 });

            this.EnrollmentAtOutOfLeaSchoolDistribution = new List<DataDistribution<bool>>();
            this.EnrollmentAtOutOfLeaSchoolDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 95 });
            this.EnrollmentAtOutOfLeaSchoolDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.EnrollmentOnlyAtLeaDistribution = new List<DataDistribution<bool>>();
            this.EnrollmentOnlyAtLeaDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });
            //  this.EnrollmentOnlyAtLeaDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.EnrollmentExitDuringSchoolYearDistribution = new List<DataDistribution<bool>>();
            this.EnrollmentExitDuringSchoolYearDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 20 });
            this.EnrollmentExitDuringSchoolYearDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.SpecialEdProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.SpecialEdProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 20 });
            this.SpecialEdProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.ImmigrantTitleIIIProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.ImmigrantTitleIIIProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.ImmigrantTitleIIIProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.MigrantProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.MigrantProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.MigrantProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.MigrantEducationProgramEnrollmentTypeDistribution = new List<DataDistribution<string>>();
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "01", ExpectedDistribution = 5 });
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "02", ExpectedDistribution = 15 });
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "03", ExpectedDistribution = 35 });
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "04", ExpectedDistribution = 55 });
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "05", ExpectedDistribution = 85 });
            this.MigrantEducationProgramEnrollmentTypeDistribution.Add(new DataDistribution<string>() { Option = "06", ExpectedDistribution = 100 });

            this.MigrantEducationProgramServicesTypeDistribution = new List<DataDistribution<string>>();
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "CounselingServices", ExpectedDistribution = 5 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "HighSchoolAccrual", ExpectedDistribution = 15 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "InstructionalServices", ExpectedDistribution = 35 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "MathematicsInstruction", ExpectedDistribution = 55 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "ReadingInstruction", ExpectedDistribution = 70 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "ReferralServices", ExpectedDistribution = 85 });
            this.MigrantEducationProgramServicesTypeDistribution.Add(new DataDistribution<string>() { Option = "SupportServices", ExpectedDistribution = 100 });

            this.MigrantEducationProgramContinuationOfServices = new List<DataDistribution<bool>>();
            this.MigrantEducationProgramContinuationOfServices.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.MigrantEducationProgramContinuationOfServices.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.ContinuationOfServicesReason = new List<DataDistribution<string>>();
            this.ContinuationOfServicesReason.Add(new DataDistribution<string>() { Option = "01", ExpectedDistribution = 33 });
            this.ContinuationOfServicesReason.Add(new DataDistribution<string>() { Option = "02", ExpectedDistribution = 66 });
            this.ContinuationOfServicesReason.Add(new DataDistribution<string>() { Option = "03", ExpectedDistribution = 100 });

            this.MigrantPrioritizedForServices = new List<DataDistribution<bool>>();
            this.MigrantPrioritizedForServices.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.MigrantPrioritizedForServices.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            //this.MilitaryConnectedStudentIndicatorDistribution = new List<DataDistribution<bool>>();
            //this.MilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 4 });
            //this.MilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.Section504ProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.Section504ProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.Section504ProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.FosterCareProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.FosterCareProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.FosterCareProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.CteProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.CteProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.CteProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.LepProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.LepProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.LepProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.NorDOutcomeYesNoDistribution = new List<DataDistribution<bool>>();
            this.NorDOutcomeYesNoDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 65 });
            this.NorDOutcomeYesNoDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NorDOutcomeExitYesNoDistribution = new List<DataDistribution<bool>>();
            this.NorDOutcomeExitYesNoDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 65 });
            this.NorDOutcomeExitYesNoDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NorDExitingDistribution = new List<DataDistribution<bool>>();
            this.NorDExitingDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 65 });
            this.NorDExitingDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NeglectedProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.NeglectedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.NeglectedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.DelinquentProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.DelinquentProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.DelinquentProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.RefNeglectedOrDelinquentProgramTypeDistribution = new List<DataDistribution<string>>();
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "NeglectedPrograms", ExpectedDistribution = 14 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "DelinquentPrograms", ExpectedDistribution = 28 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "JuvenileDetention", ExpectedDistribution = 42 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "JuvenileCorrection", ExpectedDistribution = 56 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "AdultCorrection", ExpectedDistribution = 70 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "AtRiskPrograms", ExpectedDistribution = 84 });
            this.RefNeglectedOrDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "OtherPrograms", ExpectedDistribution = 100 });


            this.RefNeglectedProgramTypeDistribution = new List<DataDistribution<string>>();
            this.RefNeglectedProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "CMNTYDAYPRG", ExpectedDistribution = 25 });
            this.RefNeglectedProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "GRPHOMES", ExpectedDistribution = 50 });
            this.RefNeglectedProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "RSDNTLTRTMTHOME", ExpectedDistribution = 70 });
            this.RefNeglectedProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "SHELTERS", ExpectedDistribution = 85 });
            this.RefNeglectedProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "OTHER", ExpectedDistribution = 100 });

            this.RefDelinquentProgramTypeDistribution = new List<DataDistribution<string>>();
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "ADLTCORR", ExpectedDistribution = 10 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "GRPHOMES", ExpectedDistribution = 20 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "CMNTYDAYPRG", ExpectedDistribution = 30 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "JUVDET", ExpectedDistribution = 40 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "JUVLNGTRMFAC", ExpectedDistribution = 50 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "RNCHWLDRNSCMPS", ExpectedDistribution = 60 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "RSDNTLTRTMTCTRS", ExpectedDistribution = 70 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "SHELTERS", ExpectedDistribution = 85 });
            this.RefDelinquentProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "OTHER", ExpectedDistribution = 100 });

            this.RefMilitaryConnectedStudentIndicatorDistribution = new List<DataDistribution<string>>();
            this.RefMilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<string>() { Option = null, ExpectedDistribution = 80 });
            this.RefMilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<string>() { Option = "NotMilitaryConnected", ExpectedDistribution = 85 });
            this.RefMilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<string>() { Option = "ActiveDuty", ExpectedDistribution = 90 });
            this.RefMilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<string>() { Option = "NationalGuardOrReserve", ExpectedDistribution = 95 });
            this.RefMilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Unknown", ExpectedDistribution = 100 });

            this.RefProgressLevelDistribution = new List<DataDistribution<string>>();
            this.RefProgressLevelDistribution.Add(new DataDistribution<string>() { Option = "NEGGRADE", ExpectedDistribution = 20 });
            this.RefProgressLevelDistribution.Add(new DataDistribution<string>() { Option = "NOCHANGE", ExpectedDistribution = 40 });
            this.RefProgressLevelDistribution.Add(new DataDistribution<string>() { Option = "UPHALFGRADE", ExpectedDistribution = 60 });
            this.RefProgressLevelDistribution.Add(new DataDistribution<string>() { Option = "UPONEGRADE", ExpectedDistribution = 80 });
            this.RefProgressLevelDistribution.Add(new DataDistribution<string>() { Option = "UPGTONE", ExpectedDistribution = 100 });

            this.NorDOutcomeIndicatorDistribution = new List<DataDistribution<bool>>();
            this.NorDOutcomeIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 65 });
            this.NorDOutcomeIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NorDAchievementIndicatorDistribution = new List<DataDistribution<bool>>();
            this.NorDAchievementIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 65 });
            this.NorDAchievementIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NorDStatusDistribution = new List<DataDistribution<bool>>();
            this.NorDStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.NorDStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.NorDSubpartDistribution = new List<DataDistribution<string>>();
            this.NorDSubpartDistribution.Add(new DataDistribution<string>() { Option = "1", ExpectedDistribution = 50 });
            this.NorDSubpartDistribution.Add(new DataDistribution<string>() { Option = "2", ExpectedDistribution = 100 });

            this.NorDOutcomeDistribution = new List<DataDistribution<string>>();
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "EARNGED", ExpectedDistribution = 14 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "EARNCRE", ExpectedDistribution = 28 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "ENROLLGED", ExpectedDistribution = 42 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "ENROLLTRAIN", ExpectedDistribution = 56 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "OBTAINEMP", ExpectedDistribution = 70 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "EARNDIPL", ExpectedDistribution = 84 });
            this.NorDOutcomeDistribution.Add(new DataDistribution<string>() { Option = "POSTSEC", ExpectedDistribution = 100 });

            this.NorDOutcomeExitDistribution = new List<DataDistribution<string>>();
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "EARNGED", ExpectedDistribution = 12 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "EARNCRE", ExpectedDistribution = 24 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "ENROLLGED", ExpectedDistribution = 36 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "ENROLLTRAIN", ExpectedDistribution = 48 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "OBTAINEMP", ExpectedDistribution = 61 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "EARNDIPL", ExpectedDistribution = 74 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "POSTSEC", ExpectedDistribution = 87 });
            this.NorDOutcomeExitDistribution.Add(new DataDistribution<string>() { Option = "ENROLLSCH", ExpectedDistribution = 100 });

            this.HomelessServicedProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.HomelessServicedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.HomelessServicedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.NationalSchoolLunchProgramDirectCertificationIndicatorDistribution = new List<DataDistribution<bool>>();
            this.NationalSchoolLunchProgramDirectCertificationIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 35 });
            this.NationalSchoolLunchProgramDirectCertificationIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.UseDatesInPersonStatusDistribution = new List<DataDistribution<bool>>();
            this.UseDatesInPersonStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 80 });
            this.UseDatesInPersonStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.NumberOfDisciplinesDistribution = new List<DataDistribution<int>>();
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 70 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 80 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 2, ExpectedDistribution = 90 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 3, ExpectedDistribution = 95 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 4, ExpectedDistribution = 97 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 5, ExpectedDistribution = 99 });
            this.NumberOfDisciplinesDistribution.Add(new DataDistribution<int>() { Option = 6, ExpectedDistribution = 100 });

            this.GEDPreparationProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.GEDPreparationProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 90 });
            this.GEDPreparationProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.FullAcademicYearPersonStatusDistribution = new List<DataDistribution<bool>>();
            this.FullAcademicYearPersonStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 75 });
            this.FullAcademicYearPersonStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefAssessmentParticipationIndicatorDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentParticipationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Participated", ExpectedDistribution = 80 });
            this.RefAssessmentParticipationIndicatorDistribution.Add(new DataDistribution<string>() { Option = "DidNotParticipate", ExpectedDistribution = 100 });

            this.RefAssessmentRegistrationReasonNotCompleting = new List<DataDistribution<string>>();
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "ParentsOptOut", ExpectedDistribution = 10 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "Absent", ExpectedDistribution = 30 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 40 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "OutOfLevelTest", ExpectedDistribution = 50 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "NoValidScore", ExpectedDistribution = 60 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "Medical", ExpectedDistribution = 70 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "Moved", ExpectedDistribution = 80 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "LeftProgram", ExpectedDistribution = 90 });
            this.RefAssessmentRegistrationReasonNotCompleting.Add(new DataDistribution<string>() { Option = "PARTELP", ExpectedDistribution = 100 });

            this.RefAssessmentRegistrationReasonNotTested = new List<DataDistribution<string>>();
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03451", ExpectedDistribution = 14 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03455", ExpectedDistribution = 28 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03454", ExpectedDistribution = 42 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03456", ExpectedDistribution = 56 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03452", ExpectedDistribution = 70 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "03453", ExpectedDistribution = 84 });
            this.RefAssessmentRegistrationReasonNotTested.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 100 });

            this.AssessmentAccommodationCategoryDistribution = new List<DataDistribution<string>>();
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "Scheduling", ExpectedDistribution = 11 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "Setting", ExpectedDistribution = 22 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "EquipmentOrTechnology", ExpectedDistribution = 33 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "TestAdministration", ExpectedDistribution = 44 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "TestMaterial", ExpectedDistribution = 55 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "TestResponse", ExpectedDistribution = 66 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "EnglishLearner", ExpectedDistribution = 77 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "504", ExpectedDistribution = 88 });
            this.AssessmentAccommodationCategoryDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 100 });

            this.AssessmentAccommodationTypeDistribution = new List<DataDistribution<string>>();
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00461", ExpectedDistribution = 1 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00462", ExpectedDistribution = 2 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00463", ExpectedDistribution = 3 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00464", ExpectedDistribution = 4 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00465", ExpectedDistribution = 5 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00469", ExpectedDistribution = 6 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00471", ExpectedDistribution = 7 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00473", ExpectedDistribution = 8 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00474", ExpectedDistribution = 9 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00475", ExpectedDistribution = 10 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00476", ExpectedDistribution = 11 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00477", ExpectedDistribution = 12 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00479", ExpectedDistribution = 13 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "00937", ExpectedDistribution = 14 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03513", ExpectedDistribution = 15 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03514", ExpectedDistribution = 16 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03515", ExpectedDistribution = 17 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03517", ExpectedDistribution = 18 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03518", ExpectedDistribution = 19 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03519", ExpectedDistribution = 20 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03522", ExpectedDistribution = 21 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03524", ExpectedDistribution = 22 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03525", ExpectedDistribution = 23 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03526", ExpectedDistribution = 24 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03527", ExpectedDistribution = 25 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03528", ExpectedDistribution = 26 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03529", ExpectedDistribution = 27 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03530", ExpectedDistribution = 28 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03531", ExpectedDistribution = 29 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03533", ExpectedDistribution = 30 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03534", ExpectedDistribution = 31 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03535", ExpectedDistribution = 32 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03536", ExpectedDistribution = 33 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03537", ExpectedDistribution = 34 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03538", ExpectedDistribution = 35 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03539", ExpectedDistribution = 36 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03541", ExpectedDistribution = 37 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03543", ExpectedDistribution = 38 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03544", ExpectedDistribution = 39 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03545", ExpectedDistribution = 40 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03546", ExpectedDistribution = 41 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03547", ExpectedDistribution = 42 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03548", ExpectedDistribution = 43 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03549", ExpectedDistribution = 44 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03550", ExpectedDistribution = 45 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03551", ExpectedDistribution = 46 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03552", ExpectedDistribution = 47 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03553", ExpectedDistribution = 48 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03554", ExpectedDistribution = 49 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03555", ExpectedDistribution = 50 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03556", ExpectedDistribution = 51 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03557", ExpectedDistribution = 52 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03558", ExpectedDistribution = 53 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03559", ExpectedDistribution = 54 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03560", ExpectedDistribution = 55 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03562", ExpectedDistribution = 56 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03563", ExpectedDistribution = 57 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03564", ExpectedDistribution = 58 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03566", ExpectedDistribution = 59 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03567", ExpectedDistribution = 60 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03568", ExpectedDistribution = 61 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03570", ExpectedDistribution = 62 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03571", ExpectedDistribution = 63 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03572", ExpectedDistribution = 64 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "03573", ExpectedDistribution = 65 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "09997", ExpectedDistribution = 66 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 67 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13788", ExpectedDistribution = 68 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13789", ExpectedDistribution = 69 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13790", ExpectedDistribution = 70 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13791", ExpectedDistribution = 71 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13792", ExpectedDistribution = 72 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13793", ExpectedDistribution = 73 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13794", ExpectedDistribution = 74 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13795", ExpectedDistribution = 75 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13796", ExpectedDistribution = 76 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13797", ExpectedDistribution = 77 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13798", ExpectedDistribution = 78 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13799", ExpectedDistribution = 79 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13800", ExpectedDistribution = 80 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13801", ExpectedDistribution = 81 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13802", ExpectedDistribution = 82 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13803", ExpectedDistribution = 83 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13804", ExpectedDistribution = 84 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13805", ExpectedDistribution = 85 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "13806", ExpectedDistribution = 86 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "73070", ExpectedDistribution = 87 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75005", ExpectedDistribution = 88 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75006", ExpectedDistribution = 89 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75007", ExpectedDistribution = 90 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75008", ExpectedDistribution = 91 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75009", ExpectedDistribution = 92 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75010", ExpectedDistribution = 93 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75011", ExpectedDistribution = 94 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75012", ExpectedDistribution = 95 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75013", ExpectedDistribution = 96 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75014", ExpectedDistribution = 97 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75015", ExpectedDistribution = 98 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75016", ExpectedDistribution = 99 });
            this.AssessmentAccommodationTypeDistribution.Add(new DataDistribution<string>() { Option = "75017", ExpectedDistribution = 100 });


            this.SpecialEdProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.SpecialEdProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 20 });
            this.SpecialEdProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.CteProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.CteProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.CteProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.DisplacedHomemakerDistribution = new List<DataDistribution<bool>>();
            this.DisplacedHomemakerDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.DisplacedHomemakerDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.SingleParentOrPregnantWomanDistribution = new List<DataDistribution<bool>>();
            this.SingleParentOrPregnantWomanDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.SingleParentOrPregnantWomanDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.CteConcentratorDistribution = new List<DataDistribution<bool>>();
            this.CteConcentratorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 20 });
            this.CteConcentratorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.CteCompleterDistribution = new List<DataDistribution<bool>>();
            this.CteCompleterDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 20 });
            this.CteCompleterDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });


            this.CteNonTraditionalCompletionDistribution = new List<DataDistribution<bool>>();
            this.CteNonTraditionalCompletionDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.CteNonTraditionalCompletionDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.LepProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.LepProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.LepProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.Section504ProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.Section504ProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.Section504ProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.AccessibleFormatIndicatorDistribution = new List<DataDistribution<string>>();
            this.AccessibleFormatIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 50 });
            this.AccessibleFormatIndicatorDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 100 });

            this.AccessibleFormatRequiredIndicatorDistribution = new List<DataDistribution<string>>();
            this.AccessibleFormatRequiredIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 35 });
            this.AccessibleFormatRequiredIndicatorDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 70 });
            this.AccessibleFormatRequiredIndicatorDistribution.Add(new DataDistribution<string>() { Option = "Unknown", ExpectedDistribution = 100 });

            this.AccessibleFormatTypeDistribution = new List<DataDistribution<string>>();
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Audio", ExpectedDistribution = 10 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Audio Described Video", ExpectedDistribution = 20 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Braille", ExpectedDistribution = 30 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Captioned Video", ExpectedDistribution = 40 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Digital Text", ExpectedDistribution = 50 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Large Print", ExpectedDistribution = 60 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Tactile Graphics", ExpectedDistribution = 70 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Text Transcripts of Audio", ExpectedDistribution = 80 });
            this.AccessibleFormatTypeDistribution.Add(new DataDistribution<string>() { Option = "Video with Synchronized American Sign Language", ExpectedDistribution = 100 });

            this.ERSRuralUrbanContinuumCodeDistribution = new List<DataDistribution<string>>();
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "1", ExpectedDistribution = 11 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "2", ExpectedDistribution = 22 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "3", ExpectedDistribution = 33 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "4", ExpectedDistribution = 44 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "5", ExpectedDistribution = 55 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "6", ExpectedDistribution = 66 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "7", ExpectedDistribution = 77 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "8", ExpectedDistribution = 88 });
            this.ERSRuralUrbanContinuumCodeDistribution.Add(new DataDistribution<string>() { Option = "9", ExpectedDistribution = 100 });

            this.RuralResidencyStatusDistribution = new List<DataDistribution<string>>();
            this.RuralResidencyStatusDistribution.Add(new DataDistribution<string>() { Option = "Yes", ExpectedDistribution = 5 });
            this.RuralResidencyStatusDistribution.Add(new DataDistribution<string>() { Option = "No", ExpectedDistribution = 100 });


            this.FosterCareProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.FosterCareProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.FosterCareProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.ImmigrantTitleIIIProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.ImmigrantTitleIIIProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.ImmigrantTitleIIIProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.NeglectedProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.NeglectedProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.NeglectedProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.HomelessProgramParticipantNowDistribution = new List<DataDistribution<bool>>();
            this.HomelessProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.HomelessProgramParticipantNowDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.IncludeMajorRaceStatusDistribution = new List<DataDistribution<bool>>();
            this.IncludeMajorRaceStatusDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 80 });
            this.IncludeMajorRaceStatusDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefExitOrWithdrawalTypeDistribution = new List<DataDistribution<string>>();
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01927", ExpectedDistribution = 25 }); // Discontinued Schooling
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01907", ExpectedDistribution = 30 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01908", ExpectedDistribution = 35 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01909", ExpectedDistribution = 40 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01910", ExpectedDistribution = 45 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01911", ExpectedDistribution = 50 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01912", ExpectedDistribution = 55 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01913", ExpectedDistribution = 60 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01914", ExpectedDistribution = 65 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01915", ExpectedDistribution = 70 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01916", ExpectedDistribution = 75 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01917", ExpectedDistribution = 80 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01918", ExpectedDistribution = 82 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01919", ExpectedDistribution = 84 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01921", ExpectedDistribution = 86 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01922", ExpectedDistribution = 90 });
            this.RefExitOrWithdrawalTypeDistribution.Add(new DataDistribution<string>() { Option = "01923", ExpectedDistribution = 100 });


            this.RefSpecialEducationExitReasonDistribution = new List<DataDistribution<string>>();
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "HighSchoolDiploma", ExpectedDistribution = 9 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "ReceivedCertificate", ExpectedDistribution = 18 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "ReachedMaximumAge", ExpectedDistribution = 27 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "Died", ExpectedDistribution = 36 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "MovedAndContinuing", ExpectedDistribution = 45 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "DroppedOut", ExpectedDistribution = 54 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "Transferred", ExpectedDistribution = 63 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "PartCNoLongerEligible", ExpectedDistribution = 40 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "PartBEligibleExitingPartC", ExpectedDistribution = 45 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "PartBEligibleContinuingPartC", ExpectedDistribution = 50 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "NotPartBEligibleExitingPartCWithReferrrals", ExpectedDistribution = 55 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "NotPartBEligibleExitingPartCWithoutReferrrals", ExpectedDistribution = 60 });
            //this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "PartBEligibilityNotDeterminedExitingPartC", ExpectedDistribution = 65 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "WithdrawalByParent", ExpectedDistribution = 72 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "MovedOutOfState", ExpectedDistribution = 81 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "Unreachable", ExpectedDistribution = 90 });
            this.RefSpecialEducationExitReasonDistribution.Add(new DataDistribution<string>() { Option = "GraduatedAlternateDiploma", ExpectedDistribution = 100 });

            this.RefIdeaInterimRemovalDistribution = new List<DataDistribution<string>>();
            this.RefIdeaInterimRemovalDistribution.Add(new DataDistribution<string>() { Option = null, ExpectedDistribution = 60 });
            this.RefIdeaInterimRemovalDistribution.Add(new DataDistribution<string>() { Option = "REMDW", ExpectedDistribution = 85 });
            this.RefIdeaInterimRemovalDistribution.Add(new DataDistribution<string>() { Option = "REMHO", ExpectedDistribution = 100 });

            this.RefIdeaIndicatorDistribution = new List<DataDistribution<bool>>();
            this.RefIdeaIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 20 });
            this.RefIdeaIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            #endregion

            #region Personnel

            this.HighlyQualifiedDistribution = new List<DataDistribution<bool>>();
            this.HighlyQualifiedDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 60 });
            this.HighlyQualifiedDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.IsSpecialEdStaffDistribution = new List<DataDistribution<bool>>();
            this.IsSpecialEdStaffDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 40 });
            this.IsSpecialEdStaffDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.StaffFteDistribution = new List<DataDistribution<decimal>>();
            this.StaffFteDistribution.Add(new DataDistribution<decimal>() { Option = (decimal)0.33, ExpectedDistribution = 8 });
            this.StaffFteDistribution.Add(new DataDistribution<decimal>() { Option = (decimal)0.5, ExpectedDistribution = 16 });
            this.StaffFteDistribution.Add(new DataDistribution<decimal>() { Option = (decimal)0.66, ExpectedDistribution = 24 });
            this.StaffFteDistribution.Add(new DataDistribution<decimal>() { Option = (decimal)0.75, ExpectedDistribution = 30 });
            this.StaffFteDistribution.Add(new DataDistribution<decimal>() { Option = (decimal)1.0, ExpectedDistribution = 100 });

            this.IsAeStaffDistribution = new List<DataDistribution<bool>>();
            this.IsAeStaffDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 40 });
            this.IsAeStaffDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.RefCredentialTypeDistribution = new List<DataDistribution<string>>();
            this.RefCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Certification", ExpectedDistribution = 20 });
            this.RefCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Endorsement", ExpectedDistribution = 40 });
            this.RefCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Licensure", ExpectedDistribution = 60 });
            this.RefCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 80 });
            this.RefCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Registration", ExpectedDistribution = 100 });

            this.RefTeachingCredentialTypeDistribution = new List<DataDistribution<string>>();
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Emergency", ExpectedDistribution = 7 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Intern", ExpectedDistribution = 14 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Master", ExpectedDistribution = 21 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Nonrenewable", ExpectedDistribution = 28 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Probationary", ExpectedDistribution = 35 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Professional", ExpectedDistribution = 42 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Provisional", ExpectedDistribution = 49 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Regular", ExpectedDistribution = 56 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Retired", ExpectedDistribution = 63 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Specialist", ExpectedDistribution = 70 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Substitute", ExpectedDistribution = 77 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "TeacherAssistant", ExpectedDistribution = 84 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "Temporary", ExpectedDistribution = 91 });
            this.RefTeachingCredentialTypeDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 100 });


            this.RefSpecialEducationStaffCategoryDistribution = new List<DataDistribution<string>>();
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "PSYCH", ExpectedDistribution = 9 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "SOCIALWORK", ExpectedDistribution = 18 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "OCCTHERAP", ExpectedDistribution = 27 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "AUDIO", ExpectedDistribution = 36 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "PEANDREC", ExpectedDistribution = 45 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "PHYSTHERAP", ExpectedDistribution = 54 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "SPEECHPATH", ExpectedDistribution = 63 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "INTERPRET", ExpectedDistribution = 72 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "COUNSELOR", ExpectedDistribution = 81 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "ORIENTMOBIL", ExpectedDistribution = 90 });
            this.RefSpecialEducationStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "MEDNURSE", ExpectedDistribution = 100 });


            this.RefK12StaffClassificationDistribution = new List<DataDistribution<string>>();
            //needed for the IDEA files 070, 112 so the distribution is higher for these 
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "Paraprofessionals", ExpectedDistribution = 20 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "SpecialEducationTeachers", ExpectedDistribution = 40 });
            //the remaining classifications
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "AdministrativeSupportStaff", ExpectedDistribution = 42 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "Administrators", ExpectedDistribution = 44 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "AllOtherSupportStaff", ExpectedDistribution = 46 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "ElementaryTeachers", ExpectedDistribution = 54 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "InstructionalCoordinators", ExpectedDistribution = 62 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "KindergartenTeachers", ExpectedDistribution = 64 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "LibraryMediaSpecialists", ExpectedDistribution = 66 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "LibraryMediaSupportStaff", ExpectedDistribution = 68 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "SchoolCounselors", ExpectedDistribution = 80 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "SecondaryTeachers", ExpectedDistribution = 82 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "StudentSupportServicesStaff", ExpectedDistribution = 88 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "UngradedTeachers", ExpectedDistribution = 90 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "SchoolPsychologist", ExpectedDistribution = 92 });
            this.RefK12StaffClassificationDistribution.Add(new DataDistribution<string>() { Option = "Pre-KindergartenTeachers", ExpectedDistribution = 100 });


            this.RefTitleIProgramStaffCategoryDistribution = new List<DataDistribution<string>>();
            this.RefTitleIProgramStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "TitleITeacher", ExpectedDistribution = 20 });
            this.RefTitleIProgramStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "TitleIParaprofessional", ExpectedDistribution = 40 });
            this.RefTitleIProgramStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "TitleISupportStaff", ExpectedDistribution = 60 });
            this.RefTitleIProgramStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "TitleIAdministrator", ExpectedDistribution = 80 });
            this.RefTitleIProgramStaffCategoryDistribution.Add(new DataDistribution<string>() { Option = "TitleIOtherParaprofessional", ExpectedDistribution = 100 });


            this.RefParaprofessionalQualificationDistribution = new List<DataDistribution<string>>();
            this.RefParaprofessionalQualificationDistribution.Add(new DataDistribution<string>() { Option = "Qualified", ExpectedDistribution = 50 });
            this.RefParaprofessionalQualificationDistribution.Add(new DataDistribution<string>() { Option = "NotQualified", ExpectedDistribution = 100 });


            this.RefInexperiencedStatusDistribution = new List<DataDistribution<string>>();
            this.RefInexperiencedStatusDistribution.Add(new DataDistribution<string>() { Option = "TCHEXPRNCD", ExpectedDistribution = 50 });
            this.RefInexperiencedStatusDistribution.Add(new DataDistribution<string>() { Option = "TCHINEXPRNCD", ExpectedDistribution = 100 });


            this.RefSpecialEducationAgeGroupTaughtDistribution = new List<DataDistribution<string>>();
            this.RefSpecialEducationAgeGroupTaughtDistribution.Add(new DataDistribution<string>() { Option = "3TO5", ExpectedDistribution = 30 });
            this.RefSpecialEducationAgeGroupTaughtDistribution.Add(new DataDistribution<string>() { Option = "6TO21", ExpectedDistribution = 100 });


            this.RefProgramTypeDistribution = new List<DataDistribution<string>>();
            this.RefProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "04888", ExpectedDistribution = 80 });
            this.RefProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "76000", ExpectedDistribution = 90 });
            this.RefProgramTypeDistribution.Add(new DataDistribution<string>() { Option = "77000", ExpectedDistribution = 100 });


            this.RefOutOfFieldStatusDistribution = new List<DataDistribution<string>>();
            this.RefOutOfFieldStatusDistribution.Add(new DataDistribution<string>() { Option = "TCHINFLD", ExpectedDistribution = 50 });
            this.RefOutOfFieldStatusDistribution.Add(new DataDistribution<string>() { Option = "TCHOUTFLD", ExpectedDistribution = 100 });

            this.RefEdFactsCertificationStatusDistribution = new List<DataDistribution<string>>(); 
            this.RefEdFactsCertificationStatusDistribution.Add(new DataDistribution<string>() { Option = "FC", ExpectedDistribution = 50 });
            this.RefEdFactsCertificationStatusDistribution.Add(new DataDistribution<string>() { Option = "NFC", ExpectedDistribution = 100 });


            this.RefSpecialEducationTeacherQualificationStatusDistribution = new List<DataDistribution<string>>();
            this.RefSpecialEducationTeacherQualificationStatusDistribution.Add(new DataDistribution<string>() { Option = "SPEDTCHFULCRT", ExpectedDistribution = 50 });
            this.RefSpecialEducationTeacherQualificationStatusDistribution.Add(new DataDistribution<string>() { Option = "SPEDTCHNFULCRT", ExpectedDistribution = 100 });
            #endregion

            #region Accessibility

            this.SCEDCodes = new List<string>
            {
                "01001","01002","01003","01004","01005","01006","01007","01008","01009","01010","01011","01012","01013","01014","01026"
                ,"01027", "01028", "01029", "01030"

            };

            #endregion
        }

    }
}
