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
    public class StudentsEnrolledAtSeaLevelOnly
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var k12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "9990000003",
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                //ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Susie",
                LastOrSurname = "SeaLevelOnly",
                SchoolYear = (schoolYear).ToString(),
                HispanicLatinoEthnicity = testDataHelper.GetWeightedSelection(rnd, testDataProfile.HispanicDistribution),
                GradeLevel = "11",
                Sex = "Female"
            };
            var idsReferenceData = new IdsReferenceData();
            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var ppse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "9990000003",
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/30/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("3/1/" + schoolYear.ToString()),
                SpecialEducationExitReason = "HighSchoolDiploma",
                IDEAIndicator = true
            };

            var personStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "9990000003",
                EconomicDisadvantageStatus = true,
                EconomicDisadvantage_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
            };

            var idt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "9990000003",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("3/1/" + (schoolYear).ToString()),
                IdeaDisabilityTypeCode = "Hearingimpairment",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
            };

            var personRace = new core.Models.Staging.K12PersonRace()
            {
                StudentIdentifierState = "9990000003",
                RaceType = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefRace>(rnd, idsReferenceData.RefRaces).Code,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("3/1/" + (schoolYear).ToString()),
                SchoolYear = schoolYear.ToString()
            };

            var discipline1 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "9990000003",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                IncidentIdentifier = "SEA9990001",
                IncidentDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                DurationOfDisciplinaryAction = "4.5",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
                DisciplineMethodOfCwd = "InSchool",
                EducationalServicesAfterRemoval = true
            };

            var discipline2 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "9990000003",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                IncidentIdentifier = "SEA9990002",
                IncidentDate = DateTime.Parse("9/05/" + (schoolYear - 1).ToString()),
                DurationOfDisciplinaryAction = "5.5",
                DisciplineMethodOfCwd = "InSchool",
                EducationalServicesAfterRemoval = false
            };

            var discipline3 = new core.Models.Staging.Discipline()
            {
                StudentIdentifierState = "9990000003",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                IncidentIdentifier = "SEA9990003",
                IncidentDate = DateTime.Parse("9/16/" + (schoolYear - 1).ToString()),
                DisciplinaryActionTaken = "03087",
                DurationOfDisciplinaryAction = "35",
                EducationalServicesAfterRemoval = true
            };

            testData.K12Enrollments.Add(k12Enrollment);
            testData.ProgramParticipationSpecialEducations.Add(ppse);
            testData.PersonRaces.Add(personRace);
            testData.IdeaDisabilityTypes.Add(idt);
            testData.PersonStatuses.Add(personStatus);
            testData.Disciplines.Add(discipline1);
            testData.Disciplines.Add(discipline2);
            testData.Disciplines.Add(discipline3);
        }
    }
}
