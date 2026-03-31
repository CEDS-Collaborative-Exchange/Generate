using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS118TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            //Test data for FS118 test
            // Student enrolled in 2 schools in the same LEA
            // Should only be counted once, at the LEA level by the report logic

            var firstK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CIID398600",
                LeaIdentifierSeaAccountability = "670",
                SchoolIdentifierSea = "670304",
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear).ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Johnny",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "Bravo",
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CIID398600",
                LeaIdentifierSeaAccountability = "670",
                SchoolIdentifierSea = "670379",
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("1/14/" + (schoolYear).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Johnny",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "Bravo",
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonRace = new K12PersonRace()
            {
                StudentIdentifierState = "CIID398600",
                RaceType = "White",
                LeaIdentifierSeaAccountability = firstK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = firstK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = firstK12Enrollment.EnrollmentExitDate
            };

            var secondPersonRace = new K12PersonRace()
            {
                StudentIdentifierState = "CIID398600",
                RaceType = "White",
                LeaIdentifierSeaAccountability = secondK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = secondK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = secondK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = secondK12Enrollment.EnrollmentExitDate
            };


            var firstPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "CIID398600",
                LeaIdentifierSeaAccountability = "670",
                SchoolIdentifierSea = "670304",
                SchoolYear = (schoolYear).ToString(),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = firstK12Enrollment.EnrollmentEntryDate,
                Homelessness_StatusEndDate = firstK12Enrollment.EnrollmentExitDate,
                HomelessNightTimeResidence = "HotelMotel",
                HomelessNightTimeResidence_StartDate = firstK12Enrollment.EnrollmentEntryDate,
                HomelessNightTimeResidence_EndDate = firstK12Enrollment.EnrollmentExitDate,
                HomelessUnaccompaniedYouth = true,
                HomelessServicedIndicator = true
            };

            var secondPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "CIID398600",
                LeaIdentifierSeaAccountability = "670",
                SchoolIdentifierSea = "670379",
                SchoolYear = (schoolYear).ToString(),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = secondK12Enrollment.EnrollmentEntryDate,
                Homelessness_StatusEndDate = secondK12Enrollment.EnrollmentExitDate,
                HomelessNightTimeResidence = "HotelMotel",
                HomelessNightTimeResidence_StartDate = secondK12Enrollment.EnrollmentEntryDate,
                HomelessNightTimeResidence_EndDate = secondK12Enrollment.EnrollmentExitDate,
                HomelessUnaccompaniedYouth = true,
                HomelessServicedIndicator = true
            };


            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.K12Enrollments.Add(secondK12Enrollment);
            testData.PersonRaces.Add(firstPersonRace);
            testData.PersonRaces.Add(secondPersonRace);
            testData.PersonStatuses.Add(firstPersonStatus);
            testData.PersonStatuses.Add(secondPersonStatus);



            //Test data for FS118 test
            // Student enrolled in 2 LEAs in the same SY, different Nighttime Residences

            var aK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CID4771118",
                LeaIdentifierSeaAccountability = "150",
                SchoolIdentifierSea = "150308",
                Birthdate = DateTime.Parse("04/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("8/25/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("12/13/" + (schoolYear - 1).ToString()),
                FirstName = "Dora",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "Explorer",
                GradeLevel = "10",
                Sex = "Female"
            };

            var bK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CID4771118",
                LeaIdentifierSeaAccountability = "240",
                SchoolIdentifierSea = "240371",
                Birthdate = DateTime.Parse("04/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("12/14/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("06/30/" + (schoolYear).ToString()),
                FirstName = "Dora",
                SchoolYear = schoolYear.ToString(),
                LastOrSurname = "Explorer",
                GradeLevel = "10",
                Sex = "Female"
            };

            var aPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CID4771118",
                RaceType = "White",
                LeaIdentifierSeaAccountability = aK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = aK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = aK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = aK12Enrollment.EnrollmentExitDate
            };

            var bPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CID4771118",
                RaceType = "White",
                LeaIdentifierSeaAccountability = bK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = bK12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = bK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = bK12Enrollment.EnrollmentExitDate
            };

            var aPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "CID4771118",
                LeaIdentifierSeaAccountability = "150",
                SchoolIdentifierSea = "150308",
                SchoolYear = (schoolYear).ToString(),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = firstK12Enrollment.EnrollmentEntryDate,
                Homelessness_StatusEndDate = aK12Enrollment.EnrollmentExitDate,
                HomelessNightTimeResidence = "HotelMotel",
                HomelessNightTimeResidence_StartDate = firstK12Enrollment.EnrollmentEntryDate,
                HomelessNightTimeResidence_EndDate = aK12Enrollment.EnrollmentExitDate,
                HomelessUnaccompaniedYouth = true,
                HomelessServicedIndicator = true
            };

            var bPersonStatus = new PersonStatus()
            {
                StudentIdentifierState = "CID4771118",
                LeaIdentifierSeaAccountability = "240",
                SchoolIdentifierSea = "240371",
                SchoolYear = (schoolYear).ToString(),
                HomelessnessStatus = true,
                Homelessness_StatusStartDate = bK12Enrollment.EnrollmentEntryDate,
                Homelessness_StatusEndDate = bK12Enrollment.EnrollmentExitDate,
                HomelessNightTimeResidence = "Shelter",
                HomelessNightTimeResidence_StartDate = bK12Enrollment.EnrollmentEntryDate,
                HomelessNightTimeResidence_EndDate = bK12Enrollment.EnrollmentExitDate,
                HomelessUnaccompaniedYouth = true,
                HomelessServicedIndicator = true
            };

            testData.K12Enrollments.Add(aK12Enrollment);
            testData.K12Enrollments.Add(bK12Enrollment);
            testData.PersonRaces.Add(aPersonRaceLea);
            testData.PersonRaces.Add(bPersonRaceLea);
            testData.PersonStatuses.Add(aPersonStatus);
            testData.PersonStatuses.Add(bPersonStatus);

        }
    }
}