using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS194TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            //Test data for FS194 test
            // Need Homeless student records associated with LEAs that are McKinney Vento subgrant recipients

            var testLEA = testData.K12Organizations.Find(k => k.LEA_McKinneyVentoSubgrantRecipient == true);

            var firstK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CIID396600",
                LeaIdentifierSeaAccountability = testLEA.LeaIdentifierSea,
                SchoolIdentifierSea = testLEA.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("10/01/" + (schoolYear - 2).ToString()),
                EnrollmentEntryDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Bugs",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "Bunny",
                GradeLevel = "05",
                Sex = "Male"
            };

            var firstPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CIID396600",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = firstK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = firstK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = firstK12Enrollment.EnrollmentExitDate
            };

            var firstPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "CIID396600",
                LeaIdentifierSeaAccountability = testLEA.LeaIdentifierSea,
                SchoolIdentifierSea = testLEA.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                Homelessness_StatusEndDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                HomelessNightTimeResidence = "HotelMotel_1",
                HomelessNightTimeResidence_StartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                HomelessNightTimeResidence_EndDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                HomelessUnaccompaniedYouth = true,
                HomelessServicedIndicator = true
            };

            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.PersonRaces.Add(firstPersonRaceLea);
            testData.PersonStatuses.Add(firstPersonStatus);
        }
    }
}