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
    public class FS007TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS007 test

            // Data for CIID-4494 - We need a REMDW record and a different type Discipline record that combined total more than 45 days

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var K12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CD4494_007",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear).ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Melissa",
                LastOrSurname = "Duck",
                SchoolYear = (schoolYear - 1).ToString(),
                GradeLevel = "09",
                Sex = "Female"
            };

            var PersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CD4494_007",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = K12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = K12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = K12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = K12Enrollment.EnrollmentExitDate
            };

            var PersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4494_007",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var Ppse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4494_007",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var discipline = new Discipline()
            {
                StudentIdentifierState = "CD4494_007",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4494_111",
                DisciplineActionIdentifier = "1",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DurationOfDisciplinaryAction = "25",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
            };

            var disciplineTwo = new Discipline()
            {
                StudentIdentifierState = "CD4494_007",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4494_222",
                DisciplineActionIdentifier = "2",
                DisciplinaryActionStartDate = DateTime.Parse("02/1/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "25",
                DisciplinaryActionTaken = "03101",
                DisciplineMethodOfCwd = "OutOfSchool",
            };

            testData.K12Enrollments.Add(K12Enrollment);
            testData.PersonRaces.Add(PersonRaceLea);
            testData.PersonStatuses.Add(PersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(Ppse);
            testData.Disciplines.Add(discipline);
            testData.Disciplines.Add(disciplineTwo);

        }
    }
}