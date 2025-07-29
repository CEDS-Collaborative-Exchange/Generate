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
    public class FS002_CIID4780_TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS002 test

            // Data for CIID-4780 - We need a student enrolled in a closed school
            var K12Enrollment = new K12Enrollment() 
            {
                StudentIdentifierState = "002CIID4780",
                LeaIdentifierSeaAccountability = "140",
                SchoolIdentifierSea = "140376",
                Birthdate = DateTime.Parse("05/15/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Daffy",
                LastOrSurname = "Duck",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "08",
                Sex = "Male"
            };

            var PersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "002CIID4780",
                RaceType = "Asian",
                LeaIdentifierSeaAccountability = K12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = K12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = K12Enrollment.EnrollmentEntryDate
            };

            var PersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "002CIID4780",
                LeaIdentifierSeaAccountability = "140",
                SchoolIdentifierSea = "140376",
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var Ppse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "002CIID4780",
                LeaIdentifierSeaAccountability = "140",
                SchoolIdentifierSea = "140376",
                SchoolYear = (schoolYear).ToString(),
                IDEAIndicator = true,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
            };

            testData.K12Enrollments.Add(K12Enrollment);
            testData.PersonRaces.Add(PersonRaceLea);
            testData.PersonStatuses.Add(PersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(Ppse);

        }

    }
}
