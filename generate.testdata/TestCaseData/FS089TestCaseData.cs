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
    public class FS089TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS089 test

            // Data for CIID-4775 - We need an Age 5 student with NULL Grade Level

            var k12org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var k12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "089CID4775",
                LeaIdentifierSeaAccountability = k12org.LeaIdentifierSea,
                SchoolIdentifierSea = k12org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("08/10/" + (schoolYear - 6).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Gwen",
                LastOrSurname = "Stacy",
                SchoolYear = (schoolYear).ToString(),
                Sex = "Female"
            };

            var personRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "089CID4775",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = k12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = k12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = k12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = k12Enrollment.EnrollmentExitDate
            };

            var personStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "089CID4775",
                LeaIdentifierSeaAccountability = k12org.LeaIdentifierSea,
                SchoolIdentifierSea = k12org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString())
            };

            var idt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "089CID4775",
                LeaIdentifierSeaAccountability = k12org.LeaIdentifierSea,
                SchoolIdentifierSea = k12org.SchoolIdentifierSea,
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentEc>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentEcs).Code;

            var ppse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "089CID4775",
                LeaIdentifierSeaAccountability = k12org.LeaIdentifierSea,
                SchoolIdentifierSea = k12org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                IDEAEducationalEnvironmentForEarlyChildhood = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            testData.K12Enrollments.Add(k12Enrollment);
            testData.PersonRaces.Add(personRaceLea);
            testData.PersonStatuses.Add(personStatus);
            testData.ProgramParticipationSpecialEducations.Add(ppse);
            testData.IdeaDisabilityTypes.Add(idt);

        }

    }
}
