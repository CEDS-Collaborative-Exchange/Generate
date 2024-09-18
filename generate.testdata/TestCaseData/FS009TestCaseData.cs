using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS009TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            //Test data for FS009 test
            // Catchment area test--we need a student who leaves one LEA and enters another.  
            // The age needs to be calculated differently for each district, so choose three sped exit date, 
            //    one before child count date at the first district , and one for the other two after, one for each district.

            var firstOrg = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var secondOrg = testData.K12Organizations.Find(k => k.LeaIdentifierSea != firstOrg.LeaIdentifierSea && k.SchoolIdentifierSea != firstOrg.SchoolIdentifierSea);

            var firstK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Sally",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "ExitsALot",
                GradeLevel = "10",
                Sex = "Female"
            };

            var secondK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("1/14/" + schoolYear.ToString()),
                FirstName = "Sally",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "ExitsALot",
                GradeLevel = "10",
                Sex = "Female"
            };

            var firstPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0090000001",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = firstK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = firstK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = firstK12Enrollment.EnrollmentExitDate
            };

            var secondPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0090000001",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = secondK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = secondK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = secondK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = secondK12Enrollment.EnrollmentExitDate
            };

            var firstPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
            };

            var secondPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
            };

            var thirdPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
            };

            var idsReferenceData = new IdsReferenceData();
            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var firstPpse = new ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("9/15/" + (schoolYear - 1).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            var secondPpse = new ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("11/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                SpecialEducationExitReason = "MovedAndContinuing",
                IDEAIndicator = true
            };

            var thirdPpse = new ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0090000001",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("1/14/" + schoolYear.ToString()),
                ProgramParticipationEndDate = DateTime.Parse("4/30/" + schoolYear.ToString()),
                SpecialEducationExitReason = "HighSchoolDiploma",
                IDEAIndicator = true
            };

            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.K12Enrollments.Add(secondK12Enrollment);
            testData.PersonRaces.Add(firstPersonRaceLea);
            testData.PersonRaces.Add(secondPersonRaceLea);
            testData.PersonStatuses.Add(firstPersonStatus);
            testData.PersonStatuses.Add(secondPersonStatus);
            testData.PersonStatuses.Add(thirdPersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(firstPpse);
            testData.ProgramParticipationSpecialEducations.Add(secondPpse);
            testData.ProgramParticipationSpecialEducations.Add(thirdPpse);

            // LEA-level only students
            var leaOnlyK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "0090000002",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                Birthdate = DateTime.Parse("11/15/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("2/21/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Sally",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "ExitsALot",
                GradeLevel = "10",
                Sex = "Female"
            };


            var leaOnlyPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0090000002",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = leaOnlyK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = leaOnlyK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = leaOnlyK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = leaOnlyK12Enrollment.EnrollmentExitDate
            };

            var leaOnlyPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "0090000002",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnglishLearner_StatusEndDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
            };


            env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var leaOnlyPpse = new ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0090000002",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("9/15/" + (schoolYear - 1).ToString()),
                SpecialEducationExitReason = "Transferred",
                IDEAIndicator = true
            };

            testData.K12Enrollments.Add(leaOnlyK12Enrollment);
            testData.PersonRaces.Add(leaOnlyPersonRaceLea);
            testData.PersonStatuses.Add(leaOnlyPersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(leaOnlyPpse);

        }
    }
}