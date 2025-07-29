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
    public class FS037TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            var Org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            // Test data for FS037 test case #4.0.1.1
            // Data Record Definition with CSILOWPERF and RESNAPPLYES and Race should include schools in exit status
            var K12Enrollment = new K12Enrollment()
            {
                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSeaAccountability = Org.LeaIdentifierSea,
                SchoolIdentifierSea = Org.SchoolIdentifierSea,
                StudentIdentifierState = "037CID2517",
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear).ToString()),
                FirstName = "FS037",
                LastOrSurname = "Testcase",
                GradeLevel = "10",
                Sex = "Female"
            };

            var PersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "037CID2517",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = K12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = K12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = K12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = K12Enrollment.EnrollmentExitDate
            };

            var PersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "037CID2517",
                LeaIdentifierSeaAccountability = Org.LeaIdentifierSea,
                SchoolIdentifierSea = Org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = true,
                EnglishLearner_StatusStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                MigrantStatus = true,
                Migrant_StatusStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString())
            };

            var MigrantStatus = new Migrant()
            {
                StudentIdentifierState = "037CID2517",
                LeaIdentifierSeaAccountability = Org.LeaIdentifierSea,
                SchoolIdentifierSea = Org.SchoolIdentifierSea,
                MigrantStatus = "MS",
                ProgramParticipationStartDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString())
            };

            testData.K12Enrollments.Add(K12Enrollment);
            testData.PersonRaces.Add(PersonRaceLea);
            testData.PersonStatuses.Add(PersonStatus);
            testData.Migrants.Add(MigrantStatus);
        }
    }
}

