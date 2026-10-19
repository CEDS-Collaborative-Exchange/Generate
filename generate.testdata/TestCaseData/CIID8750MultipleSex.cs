using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class CIID8750MultipleSex
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            //Test data for CIID8750 test

            // Data for CIID8750 - We need students whose sex differs between LEAs/Schools to make sure
            // they are returned by Debug.vwStudentSexConflicts, and students whose sex does not conflict to make sure they are not.

            //Test cases need two diferent orgs
            var firstOrg = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var secondOrg = testData.K12Organizations.Find(k => k.LeaIdentifierSea != firstOrg.LeaIdentifierSea && k.SchoolIdentifierSea != firstOrg.SchoolIdentifierSea);

            //START TEST Case 1 Condition: Different Sex, 2 different schools - should be returned by the view
            var firstK12EnrollmentCase1 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 1",
                LastOrSurname = "SexConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase1 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 1",
                LastOrSurname = "SexConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };
            //END TEST Case 1 Condition: Different Sex, 2 different schools - should be returned by the view

            //START TEST Case 2 Condition: Same Sex, 2 different schools - should NOT be returned by the view
            var firstK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("2/20/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 2",
                LastOrSurname = "SameSex",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };

            var secondK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("2/21/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 2",
                LastOrSurname = "SameSex",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };
            //END TEST Case 2 Condition: Same Sex, 2 different schools - should NOT be returned by the view

            //START TEST Case 3 Condition: Sex changes between 2 enrollments at the same school - should NOT be returned by the view
            var firstK12EnrollmentCase3 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("1/15/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 3",
                LastOrSurname = "SameSchoolChange",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase3 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("1/16/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 3",
                LastOrSurname = "SameSchoolChange",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };
            //END TEST Case 3 Condition: Sex changes between 2 enrollments at the same school - should NOT be returned by the view

            //START TEST Case 4 Condition: Different Sex, 2 different schools, concurrent enrollment - should be returned by the view
            var firstK12EnrollmentCase4 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 4",
                LastOrSurname = "ConcurrentConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };

            var secondK12EnrollmentCase4 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase4",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 4",
                LastOrSurname = "ConcurrentConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };
            //END TEST Case 4 Condition: Different Sex, 2 different schools, concurrent enrollment - should be returned by the view

            //START TEST Case 5 Condition: One school, one enrollment - should NOT be returned by the view
            var firstK12EnrollmentCase5 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 5",
                LastOrSurname = "SingleSchool",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };
            //END TEST Case 5 Condition: One school, one enrollment - should NOT be returned by the view

            //START TEST Case 6 Condition: Male at one school, NotSelected at another school - should be returned by the view
            var firstK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 6",
                LastOrSurname = "NotSelectedConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750SexCase6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 6",
                LastOrSurname = "NotSelectedConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "NotSelected"
            };
            //END TEST Case 6 Condition: Male at one school, NotSelected at another school - should be returned by the view

            testData.K12Enrollments.Add(firstK12EnrollmentCase1);
            testData.K12Enrollments.Add(secondK12EnrollmentCase1);

            testData.K12Enrollments.Add(firstK12EnrollmentCase2);
            testData.K12Enrollments.Add(secondK12EnrollmentCase2);

            testData.K12Enrollments.Add(firstK12EnrollmentCase3);
            testData.K12Enrollments.Add(secondK12EnrollmentCase3);

            testData.K12Enrollments.Add(firstK12EnrollmentCase4);
            testData.K12Enrollments.Add(secondK12EnrollmentCase4);

            testData.K12Enrollments.Add(firstK12EnrollmentCase5);

            testData.K12Enrollments.Add(firstK12EnrollmentCase6);
            testData.K12Enrollments.Add(secondK12EnrollmentCase6);
        }

    }
}
