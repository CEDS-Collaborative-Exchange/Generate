using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Profiles
{
    public class IdsTestDataProfile : IIdsTestDataProfile
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

        public List<DataDistribution<string>> RefAssessmentTypeChildrenWithDisabilitiesDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentTypeAdministeredToEnglishLearnersDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentTypeDistribution { get; set; }



        #endregion

        #region Organization
        public List<DataDistribution<bool>> IncludePlus4ZipCodeDistribution { get; set; }
        public List<DataDistribution<bool>> HasMailingAddressDistribution { get; set; }
        public List<DataDistribution<bool>> HasShippingAddressDistribution { get; set; }
        public List<DataDistribution<string>> RefOrganizationIndicatorDistribution { get; set; }
        public List<DataDistribution<string>> SharedTimeOrganizationIndicatorValueDistribution { get; set; }
        public List<DataDistribution<string>> RefVirtualSchoolStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefTitleIiilanguageInstructionProgramTypeDistribution { get; set; }
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
        public  List<DataDistribution<string>> RefSchoolImprovementStatusDistribution { get; set; }
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

        #region Students

        public List<DataDistribution<int>> EcoDisStatusDistribution { get; set; }
        public List<DataDistribution<string>> EligibilityStatusForSchoolFoodServiceProgramsDistribution { get; set; }
        public List<DataDistribution<int>> HomelessStatusDistribution { get; set; }
        public List<DataDistribution<int>> HomelessUnaccompaniedYouthStatusDistribution { get; set; }
        public List<DataDistribution<int>> LepStatusDistribution { get; set; }
        public List<DataDistribution<int>> PerkinsLepStatusDistribution { get; set; }
        public List<DataDistribution<int>> MigrantStatusDistribution { get; set; }
        public List<DataDistribution<string>> MigrantEducationProgramEnrollmentTypeDistribution { get; set; }
        public List<DataDistribution<string>> MigrantEducationProgramServicesTypeDistribution { get; set; }
        public List<DataDistribution<bool>> MigrantEducationProgramContinuationOfServices { get; set; }
        public List<DataDistribution<string>> ContinuationOfServicesReason { get; set; }
        public List<DataDistribution<bool>> MigrantPrioritizedForServices { get; set; }
        public List<DataDistribution<int>> SpecialEdStatusDistribution { get; set; }
        public List<DataDistribution<int>> ImmigrantTitleIIIStatusDistribution { get; set; }
        public List<DataDistribution<int>> DisabilityStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefDisabilityTypeDistribution { get; set; }
        public List<DataDistribution<int>> PersonHomelessnessDistribution { get; set; }
        public List<DataDistribution<string>> RefHomelessNighttimeResidenceDistribution { get; set; }
        public List<DataDistribution<string>> RefLanguageDistribution { get; set; }
        public List<DataDistribution<string>> RefLanguageUseTypeDistribution { get; set; }
        public List<DataDistribution<int>> NumberOfRacesDistribution { get; set; }
        public List<DataDistribution<string>> RefRaceDistribution { get; set; }
        public List<DataDistribution<bool>> EnrollmentAtOutOfLeaSchoolDistribution { get; set; }
        public List<DataDistribution<int>> NumberOfConcurrentSchoolEnrollmentDistribution { get; set; }
        public List<DataDistribution<bool>> EnrollmentOnlyAtLeaDistribution { get; set; }

        public List<DataDistribution<bool>> SpecialEdProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> ImmigrantTitleIIIProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> MigrantProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> MilitaryConnectedStudentIndicatorDistribution { get; set; } 
        public List<DataDistribution<bool>> Section504ProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> FosterCareProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> CteProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> LepProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> NeglectedProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> HomelessServicedProgramParticipationDistribution { get; set; }

        public List<DataDistribution<bool>> UseDatesInPersonStatusDistribution { get; set; }

        public List<DataDistribution<int>> NumberOfDisciplinesDistribution { get; set; }
        public List<DataDistribution<bool>> GEDPreparationProgramParticipationDistribution { get; set; }
        public List<DataDistribution<bool>> FullAcademicYearPersonStatusDistribution { get; set; }
        public List<DataDistribution<string>> RefAssessmentParticipationIndicatorDistribution { get; set; }
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

        #endregion

        #region Personnel

        public List<DataDistribution<bool>> HighlyQualifiedDistribution { get; set; }
        public List<DataDistribution<bool>> IsSpecialEdStaffDistribution { get; set; }
        public List<DataDistribution<decimal>> StaffFteDistribution { get; set; }
        public List<DataDistribution<bool>> IsAeStaffDistribution { get; set; }

        #endregion


        public IdsTestDataProfile()
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

            this.MinimumAgeOfStudent = 0;
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

            this.AverageNumberOfStudentsPerAssessment = 500;
            
            this.RefAcademicSubjectDistribution = new List<DataDistribution<string>>();
                   
           
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "13373", ExpectedDistribution = 30 }); // Reading/Language Arts
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "01166", ExpectedDistribution = 60 }); // Mathematics
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00562", ExpectedDistribution = 70 }); // Science
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73065", ExpectedDistribution = 80 }); // Career and Technical Education
            this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00256", ExpectedDistribution = 100 }); // English as a second language (ESL)
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "13371", ExpectedDistribution = 88 }); // Arts
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00546", ExpectedDistribution = 89 }); // Foreign Languages
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "01287", ExpectedDistribution = 90 }); // Writing
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "02043", ExpectedDistribution = 91 }); // Special education
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "13372", ExpectedDistribution = 92 }); // English
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00560", ExpectedDistribution = 93 }); // Reading
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "00554", ExpectedDistribution = 94 }); // Language arts
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73086", ExpectedDistribution = 95 }); // Science - Life
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73087", ExpectedDistribution = 96 }); // Science - Physical
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "13374", ExpectedDistribution = 97 }); // Social Sciences (History, Geography, Economics, Civics and Government)
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73088", ExpectedDistribution = 98 }); // History Government - US
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "73089", ExpectedDistribution = 99 }); // History Government - World
            //this.RefAcademicSubjectDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 100 }); // Other

            this.RefAssessmentPurposeDistribution = new List<DataDistribution<string>>();

            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00050", ExpectedDistribution = 10 }); // Admission
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00051", ExpectedDistribution = 15 }); // Assessment of student's progress
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73055", ExpectedDistribution = 20 }); // College Readiness
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00063", ExpectedDistribution = 25 }); // Course credit
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00064", ExpectedDistribution = 30 }); // Course requirement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73069", ExpectedDistribution = 35 }); // Diagnosis
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03459", ExpectedDistribution = 40 }); // Federal accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73068", ExpectedDistribution = 45 }); // Inform local or state policy
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00055", ExpectedDistribution = 50 }); // Instructional decision
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03457", ExpectedDistribution = 55 }); // Local accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "02404", ExpectedDistribution = 60 }); // Local graduation requirement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73042", ExpectedDistribution = 65 }); // Obtain a state- or industry-recognized certificate or license
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73043", ExpectedDistribution = 70 }); // Obtain postsecondary credit for the course
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "73067", ExpectedDistribution = 75 }); // Program eligibility
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00057", ExpectedDistribution = 80 }); // Program evaluation
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00058", ExpectedDistribution = 85 }); // Program placement
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00062", ExpectedDistribution = 90 }); // Promotion to or retention in a grade or program
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00061", ExpectedDistribution = 95 }); // Screening
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "03458", ExpectedDistribution = 100 }); // State accountability
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "09999", ExpectedDistribution = 105 }); // Other
            this.RefAssessmentPurposeDistribution.Add(new DataDistribution<string>() { Option = "00054", ExpectedDistribution = 110 }); // State graduation requirement

            this.RefAssessmentTypeDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AchievementTest", ExpectedDistribution = 10 }); //	AchievementTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AdvancedPlacementTest", ExpectedDistribution = 15 });   //	AdvancedPlacementTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternateAssessmentELL", ExpectedDistribution = 20 });  //	AlternateAssessmentELL
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternateAssessmentGradeLevelStandards", ExpectedDistribution = 25 });  //	AlternateAssessmentGradeLevelStandards
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AlternativeAssessmentModifiedStandards", ExpectedDistribution = 30 });  //	AlternativeAssessmentModifiedStandards
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "AptitudeTest", ExpectedDistribution = 35 });    //	AptitudeTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Benchmark", ExpectedDistribution = 40 });   //	Benchmark
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "CognitiveAndPerceptualSkills", ExpectedDistribution = 45 });    //	CognitiveAndPerceptualSkills
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ComputerAdaptiveTest", ExpectedDistribution = 50 });    //	ComputerAdaptiveTest
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "DevelopmentalObservation", ExpectedDistribution = 55 });    //	DevelopmentalObservation
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Diagnostic", ExpectedDistribution = 60 });  //	Diagnostic
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "DirectAssessment", ExpectedDistribution = 65 });    //	DirectAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Formative", ExpectedDistribution = 70 });   //	Formative
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "GrowthMeasure", ExpectedDistribution = 75 });   //	GrowthMeasure
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Interim", ExpectedDistribution = 80 }); //	Interim
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "KindergartenReadiness", ExpectedDistribution = 85 });   //	KindergartenReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "LanguageProficiency", ExpectedDistribution = 90 }); //	LanguageProficiency
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "MentalAbility", ExpectedDistribution = 95 });   //	MentalAbility
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Observation", ExpectedDistribution = 100 }); //	Observation
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ParentReport", ExpectedDistribution = 105 });    //	ParentReport
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PerformanceAssessment", ExpectedDistribution = 110 });   //	PerformanceAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PortfolioAssessment", ExpectedDistribution = 115 }); //	PortfolioAssessment
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "PrekindergartenReadiness", ExpectedDistribution = 120 });    //	PrekindergartenReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "ReadingReadiness", ExpectedDistribution = 125 });    //	ReadingReadiness
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Screening", ExpectedDistribution = 130 });   //	Screening
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "TeacherReport", ExpectedDistribution = 135 });   //	TeacherReport
            this.RefAssessmentTypeDistribution.Add(new DataDistribution<string>() { Option = "Other", ExpectedDistribution = 140 });	//	Other

            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "REGASSWOACC", ExpectedDistribution = 5 }); // Regular assessments based on grade-level achievement standards without accommodations
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "REGASSWACC", ExpectedDistribution = 50 }); // Regular assessments based on grade-level achievement standards with accommodations
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "ALTASSGRADELVL", ExpectedDistribution = 65 }); // Alternate assessments based on grade-level achievement standards
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "ALTASSMODACH", ExpectedDistribution = 80 }); // Alternate assessments based on modified achievement standards
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "ALTASSALTACH", ExpectedDistribution = 95 }); // Alternate assessments based on alternate achievement standards
            //this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "AgeLevelWithoutAccommodations", ExpectedDistribution = 50 }); // Assessment based on  age level standards without accommodations
            //this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "AgeLevelWithAccommodations", ExpectedDistribution = 55 }); // Assessment based on  age level standards with accommodations
            //this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "BelowAgeLevelWithoutAccommodations", ExpectedDistribution = 60 }); // Assessment based on standards below age level without accommodations
            //this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "BelowAgeLevelWithAccommodations", ExpectedDistribution = 65 }); // Assessment based on standards below age level with accommodations
            this.RefAssessmentTypeChildrenWithDisabilitiesDistribution.Add(new DataDistribution<string>() { Option = "-1", ExpectedDistribution = 100 }); // None

            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution = new List<DataDistribution<string>>();
            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution.Add(new DataDistribution<string>() { Option = "REGELPASMNT", ExpectedDistribution = 30 }); // Regular English language proficiency (ELP) assessment
            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution.Add(new DataDistribution<string>() { Option = "ALTELPASMNTALT", ExpectedDistribution = 70 }); // Alternate English language proficiency (ELP) based on alternate ELP achievement standards
            this.RefAssessmentTypeAdministeredToEnglishLearnersDistribution.Add(new DataDistribution<string>() { Option = "-1", ExpectedDistribution = 100 }); // None

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
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Female", ExpectedDistribution = 40 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Male", ExpectedDistribution = 80 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "NotSelected", ExpectedDistribution = 90 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Unknown", ExpectedDistribution = 100 });
            
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
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "TGELGBNOPROG", ExpectedDistribution = 15 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "TGELGBTGPROG", ExpectedDistribution = 30 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGTGPROG", ExpectedDistribution = 45 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGNOPROG", ExpectedDistribution = 60 });
            this.RefTitleIschoolStatusDistribution.Add(new DataDistribution<string>() { Option = "SWELIGSWPROG", ExpectedDistribution = 75 });
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

            this.HomelessStatusDistribution = new List<DataDistribution<int>>();
            this.HomelessStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.HomelessStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.HomelessStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.HomelessUnaccompaniedYouthStatusDistribution = new List<DataDistribution<int>>();
            this.HomelessUnaccompaniedYouthStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.HomelessUnaccompaniedYouthStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.HomelessUnaccompaniedYouthStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });
            
            this.LepStatusDistribution = new List<DataDistribution<int>>();
            this.LepStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.LepStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 88 });
            this.LepStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.PerkinsLepStatusDistribution = new List<DataDistribution<int>>();
            this.PerkinsLepStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.PerkinsLepStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.PerkinsLepStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.MigrantStatusDistribution = new List<DataDistribution<int>>();
            this.MigrantStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.MigrantStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.MigrantStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.SpecialEdStatusDistribution = new List<DataDistribution<int>>();
            this.SpecialEdStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.SpecialEdStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 30 });
            this.SpecialEdStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.ImmigrantTitleIIIStatusDistribution = new List<DataDistribution<int>>();
            this.ImmigrantTitleIIIStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.ImmigrantTitleIIIStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.ImmigrantTitleIIIStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });
            
            this.DisabilityStatusDistribution = new List<DataDistribution<int>>();
            this.DisabilityStatusDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 10 });
            this.DisabilityStatusDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 20 });
            this.DisabilityStatusDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.RefDisabilityTypeDistribution = new List<DataDistribution<string>>();
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "AUT", ExpectedDistribution = 8 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "DB", ExpectedDistribution = 16 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "DD", ExpectedDistribution = 24 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "EMN", ExpectedDistribution = 32 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "HI", ExpectedDistribution = 40 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "ID", ExpectedDistribution = 48 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "MD", ExpectedDistribution = 56 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "OI", ExpectedDistribution = 64 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "OHI", ExpectedDistribution = 72 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "SLD", ExpectedDistribution = 80 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "SLI", ExpectedDistribution = 88 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "TBI", ExpectedDistribution = 96 });
            this.RefDisabilityTypeDistribution.Add(new DataDistribution<string>() { Option = "VI", ExpectedDistribution = 100 });

            this.PersonHomelessnessDistribution = new List<DataDistribution<int>>();
            this.PersonHomelessnessDistribution.Add(new DataDistribution<int>() { Option = -1, ExpectedDistribution = 20 });
            this.PersonHomelessnessDistribution.Add(new DataDistribution<int>() { Option = 0, ExpectedDistribution = 50 });
            this.PersonHomelessnessDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 100 });

            this.RefHomelessNighttimeResidenceDistribution = new List<DataDistribution<string>>();
            this.RefHomelessNighttimeResidenceDistribution.Add(new DataDistribution<string>() { Option = "Shelters", ExpectedDistribution = 30 });
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
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "AmericanIndianorAlaskaNative", ExpectedDistribution = 2 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "Asian", ExpectedDistribution = 7 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "BlackorAfricanAmerican", ExpectedDistribution = 31 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "NativeHawaiianorOtherPacificIslander", ExpectedDistribution = 32 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "White", ExpectedDistribution = 96 });
            this.RefRaceDistribution.Add(new DataDistribution<string>() { Option = "TwoorMoreRaces", ExpectedDistribution = 103 });


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

            this.MilitaryConnectedStudentIndicatorDistribution = new List<DataDistribution<bool>>();
            this.MilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 4 });
            this.MilitaryConnectedStudentIndicatorDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });


            this.Section504ProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.Section504ProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.Section504ProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.FosterCareProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.FosterCareProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.FosterCareProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.CteProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.CteProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.CteProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.LepProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.LepProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.LepProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.NeglectedProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.NeglectedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.NeglectedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.HomelessServicedProgramParticipationDistribution = new List<DataDistribution<bool>>();
            this.HomelessServicedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 50 });
            this.HomelessServicedProgramParticipationDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

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

            #endregion

        }

    }
}
