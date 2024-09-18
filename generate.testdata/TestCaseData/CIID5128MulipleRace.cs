using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class CIID5128MulipleRace
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for  CIID512 test

            // Data for  CIID512 - We need a to test multiple race records to make sure that only one row per org type is returend by rolling up the race records
            // // they roll up to two races, and that the hispanic flag works as expected.
            //this in cludes testing Staging-to-FactK12StudentCounts_ChildCount, Staging-to-FactK12StudentCounts_SpecEdExit, Staging-to-FactK12StudentCounts_TitleIII, Staging-to-FactK12StudentDisciplines

            //Test cases need two diferent orgs
            var firstOrg = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var secondOrg = testData.K12Organizations.Find(k => k.LeaIdentifierSea != firstOrg.LeaIdentifierSea && k.SchoolIdentifierSea != firstOrg.SchoolIdentifierSea);

            // not sure
            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            //Start Case 1 Condition: 2 Different Race, Same OrganizationType, 2 different school,both records are Hispanic
            var firstK12EnrollmentCase1 = new K12Enrollment() 
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString()),
                FirstName = "Case 1",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase1 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 1",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonStatusCase1 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString()),
            };

            var secondPersonStatusCase1 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstPersonRaceSchoolCase1 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case1",
                RaceType = "AmericanIndianorAlaskaNative",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("11/25/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase1 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case1",
                SchoolYear = (schoolYear).ToString(),
                RaceType = "White",
                RecordStartDateTime = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase1 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var secondPpseCase1 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var firstIdtCase1 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("11/25/" + (schoolYear - 1).ToString())
            };

            var secondIdtCase1 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString())
            };

            var firstTitleIIICase1 = new core.Models.Staging.ProgramParticipationTitleIII()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                TitleIIIAccountabilityProgressStatus = "PROGRESS",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString()),
                EnglishLearnerParticipation = true,
                TitleIIILanguageInstructionProgramType = "DualLanguage",
                TitleIIIImmigrantStatus_EndDate = DateTime.Parse("7/15/" + (schoolYear - 1).ToString())
            };

            var secondTitleIIICase1 = new core.Models.Staging.ProgramParticipationTitleIII()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                TitleIIIAccountabilityProgressStatus = "PROGRESS",
                ProgramParticipationBeginDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                EnglishLearnerParticipation = true,
                TitleIIILanguageInstructionProgramType = "DualLanguage",
                TitleIIIImmigrantStatus_EndDate = DateTime.Parse("7/15/" + (schoolYear - 1).ToString())
            };
           
            var firstDisciplineCase1 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,               
                IncidentIdentifier = "CIID1528Case1-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            var secondDisciplineCase1 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case1-2",
                IncidentDate = DateTime.Parse("3/27/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "10",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",                
                DisciplinaryActionStartDate = DateTime.Parse("3/29/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            //END TEST Case 1 Condition: 2 Different Race, Same OrganizationType, 2 different school,both records are Hispanic

            //START TEST Case 2  Condition: 2 Different Race, Same OrganizationType, 2 different school,both records are Hispanic

            var firstK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("10/12/" + (schoolYear - 1).ToString()),
                FirstName = "Case 2",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 1",
                LastOrSurname = "White",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonStatusCase2 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("10/12/" + (schoolYear - 1).ToString()),
            };

            var secondPersonStatusCase2 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
            };

            var firstPersonRaceSchoolCase2 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case2",
                RaceType = "White",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("10/12/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase2 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case2",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase2 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("10/12/" + (schoolYear - 1).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var secondPpseCase2 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var firstIdtCase2 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var secondIdtCase2 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("10/13/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstDisciplineCase2 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case2-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            var secondDisciplineCase2 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case2-2",
                IncidentDate = DateTime.Parse("3/27/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "10",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/29/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            //END TEST Case 2  Condition: 2 Different Race, Same OrganizationType, 2 different school,both records are Hispanic

            //START TEST Case 3  Condition: Same Race, Same OrganizationType, different school, Hispanic
            var firstK12EnrollmentCase3 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("2/20/" + (schoolYear).ToString()),
                FirstName = "Case 3",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase3 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 3",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonStatusCase3 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("2/20/" + (schoolYear).ToString()),
            };

            var secondPersonStatusCase3 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstIdtCase3 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString())
            };

            var secondIdtCase3 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString())
            };

            var firstPersonRaceSchoolCase3 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case3",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("2/20/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase3 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case3",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase3 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("2/20/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var secondPpseCase3 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("2/21/" + (schoolYear).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

           var firstDisciplineCase3 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case3-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            var secondDisciplineCase3 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case3-2",
                IncidentDate = DateTime.Parse("3/27/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "10",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/29/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };
            //END TEST Case 3 Condition: Same Race, Same OrganizationType, different school, Hispanic

            //START TEST Case 4  Condition: 2 Different Race, Different OrganizationType, Not Hispanic,
            var firstK12EnrollmentCase4 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 4",
                LastOrSurname = "NativeHawaiianorOtherPacificIslander",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };        

            var firstPersonStatusCase4 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
            };

            var firstIdtCase4 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString()),
            };

            var firstPersonRaceSchoolCase4 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case4",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase4 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case4",
                RaceType = "NativeHawaiianorOtherPacificIslander",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase4 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };
         
            var firstDisciplineCase4 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case4-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            var secondDisciplineCase4 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                //****School_Identifier_State = firstOrg.School_Identifier_State, - query all disapline where school is NULL
                IncidentIdentifier = "CIID1528Case4-2",
                IncidentDate = DateTime.Parse("3/27/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "10",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/29/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };
            //END TEST Case 4  Condition: 2 Different Race, Different OrganizationType, Not Hispanic,

            //START TEST Case 5 Condition: 2 Different Race, Different OrganizationType, Hispanic,
            var firstK12EnrollmentCase5 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                FirstName = "Case 5",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = true,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };
          
            var firstPersonStatusCase5 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
            };

            var firstIdtCase5 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
            };

            var firstPersonRaceSchoolCase5 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case5",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase5 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case5",
                RaceType = "NativeHawaiianorOtherPacificIslander",                
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase5 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                IDEAIndicator = true,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred"
            };

            var firstDisciplineCase5 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case5-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            //END TEST Case 5 Condition: 2 Different Race, Different OrganizationType, Hispanic,

            //Start Case 6 Condition: Same Race, same OrganizationType, different schools not Hispanic
            var firstK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                FirstName = "Case 1",
                LastOrSurname = "White",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 1",
                LastOrSurname = "White",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonStatusCase6 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
            };

            var secondPersonStatusCase6 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstIdtCase6 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
            };

            var secondIdtCase6 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };


            var firstPersonRaceSchoolCase6 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case6",
                RaceType = "White",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase6 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case6",
                RaceType = "White",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("4/2/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase6 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("4/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var secondPpseCase6 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("4/2/" + (schoolYear).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var firstDisciplineCase6 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case6-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            var secondDisciplineCase6 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case6-2",
                IncidentDate = DateTime.Parse("3/27/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "10",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/29/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            //END TEST Case 1 Condition: Same Race, same OrganizationType, different schools not Hispanic

            //START TEST Case 7 Condition: Diferent Race, Same OrganizationType, same school, not Hispanic	
            var firstK12EnrollmentCase7 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID1528Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Case 5",
                LastOrSurname = "Hispanic",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonStatusCase7 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CIID1528Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstIdtCase7 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID1528Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("6/1/" + (schoolYear).ToString()),
            };

            var firstPersonRaceSchoolCase7 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case7",
                RaceType = "BlackorAfricanAmerican",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
            };

            var secondPersonRaceSchoolCase7 = new K12PersonRace()
            {
                StudentIdentifierState = "CIID1528Case7",
                RaceType = "NativeHawaiianorOtherPacificIslander",
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
            };

            var firstPpseCase7 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CIID1528Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/1/" + (schoolYear).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var firstDisciplineCase7 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "CIID1528Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IncidentIdentifier = "CIID1528Case7-1",
                IncidentDate = DateTime.Parse("3/18/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                DisciplinaryActionStartDate = DateTime.Parse("3/26/" + (schoolYear).ToString()),
                EducationalServicesAfterRemoval = true
            };

            //END TEST Case 7 Condition: 2 Different Race, Same OrganizationType, same school, not Hispanic

            testData.K12Enrollments.Add(firstK12EnrollmentCase1);
            testData.K12Enrollments.Add(secondK12EnrollmentCase1);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase1);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase1);
            testData.PersonStatuses.Add(firstPersonStatusCase1);
            testData.PersonStatuses.Add(secondPersonStatusCase1);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase1);
            testData.ProgramParticipationSpecialEducations.Add(secondPpseCase1);
            testData.ProgramParticipationTitleIIIs.Add(firstTitleIIICase1);
            testData.ProgramParticipationTitleIIIs.Add(secondTitleIIICase1);
            testData.IdeaDisabilityTypes.Add(firstIdtCase1);
            testData.IdeaDisabilityTypes.Add(secondIdtCase1);
            testData.Disciplines.Add(firstDisciplineCase1);
            testData.Disciplines.Add(secondDisciplineCase1);

            testData.K12Enrollments.Add(firstK12EnrollmentCase2);
            testData.K12Enrollments.Add(secondK12EnrollmentCase2);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase2);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase2);
            testData.PersonStatuses.Add(firstPersonStatusCase2);
            testData.PersonStatuses.Add(secondPersonStatusCase2);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase2);
            testData.ProgramParticipationSpecialEducations.Add(secondPpseCase2);
            testData.Disciplines.Add(firstDisciplineCase2);
            testData.Disciplines.Add(secondDisciplineCase2);
            testData.IdeaDisabilityTypes.Add(firstIdtCase2);
            testData.IdeaDisabilityTypes.Add(secondIdtCase2);

            testData.K12Enrollments.Add(firstK12EnrollmentCase3);
            testData.K12Enrollments.Add(secondK12EnrollmentCase3);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase3);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase3);
            testData.PersonStatuses.Add(firstPersonStatusCase3);
            testData.PersonStatuses.Add(secondPersonStatusCase3);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase3);
            testData.ProgramParticipationSpecialEducations.Add(secondPpseCase3);
            testData.Disciplines.Add(firstDisciplineCase3);
            testData.Disciplines.Add(secondDisciplineCase3);
            testData.IdeaDisabilityTypes.Add(firstIdtCase3);
            testData.IdeaDisabilityTypes.Add(secondIdtCase3);

            testData.K12Enrollments.Add(firstK12EnrollmentCase4);           
            testData.PersonRaces.Add(firstPersonRaceSchoolCase4);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase4);
            testData.PersonStatuses.Add(firstPersonStatusCase4);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase4);
            testData.Disciplines.Add(firstDisciplineCase4);
            testData.Disciplines.Add(secondDisciplineCase4);
            testData.IdeaDisabilityTypes.Add(firstIdtCase4);

            testData.K12Enrollments.Add(firstK12EnrollmentCase5);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase5);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase5);
            testData.PersonStatuses.Add(firstPersonStatusCase5);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase5);
            testData.Disciplines.Add(firstDisciplineCase5);
            testData.IdeaDisabilityTypes.Add(firstIdtCase5);

            testData.K12Enrollments.Add(firstK12EnrollmentCase6);
            testData.K12Enrollments.Add(secondK12EnrollmentCase6);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase6);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase6);
            testData.PersonStatuses.Add(firstPersonStatusCase6);
            testData.PersonStatuses.Add(secondPersonStatusCase6);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase6);
            testData.ProgramParticipationSpecialEducations.Add(secondPpseCase6);
            testData.Disciplines.Add(firstDisciplineCase6);
            testData.Disciplines.Add(secondDisciplineCase6);
            testData.IdeaDisabilityTypes.Add(firstIdtCase6);
            testData.IdeaDisabilityTypes.Add(secondIdtCase6);

            testData.K12Enrollments.Add(firstK12EnrollmentCase7);
            testData.PersonRaces.Add(firstPersonRaceSchoolCase7);
            testData.PersonRaces.Add(secondPersonRaceSchoolCase7);
            testData.PersonStatuses.Add(firstPersonStatusCase7);
            testData.ProgramParticipationSpecialEducations.Add(firstPpseCase7);
            testData.Disciplines.Add(firstDisciplineCase7);
            testData.IdeaDisabilityTypes.Add(firstIdtCase7);
        }

    }
}
