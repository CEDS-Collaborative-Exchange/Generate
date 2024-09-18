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
    public class FS002TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS002 test

            // Data for CIID-4482 - We need a dual enrolled student with different race records for each enrollment

            var firstOrg = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var secondOrg = testData.K12Organizations.Find(k => k.LeaIdentifierSea != firstOrg.LeaIdentifierSea && k.SchoolIdentifierSea != firstOrg.SchoolIdentifierSea);

            var firstK12Enrollment = new K12Enrollment() 
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Calvin",
                LastOrSurname = "Hobbes",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstIdt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var secondK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Calvin",
                LastOrSurname = "Hobbes",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondIdt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var firstPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "002CID4482",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = firstK12Enrollment.EnrollmentEntryDate
            };

            var secondPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "002CID4482",
                RaceType = "Asian",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = secondK12Enrollment.EnrollmentEntryDate
            };

            var firstPersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var secondPersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var firstPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                IDEAIndicator = true,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var secondPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "002CID4482",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                IDEAIndicator = true,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.K12Enrollments.Add(secondK12Enrollment);
            testData.IdeaDisabilityTypes.Add(firstIdt);
            testData.IdeaDisabilityTypes.Add(secondIdt);
            testData.PersonRaces.Add(firstPersonRaceLea);
            testData.PersonRaces.Add(secondPersonRaceLea);
            testData.PersonStatuses.Add(firstPersonStatus);
            testData.PersonStatuses.Add(secondPersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(firstPpse);
            testData.ProgramParticipationSpecialEducations.Add(secondPpse);

        }

    }
}
