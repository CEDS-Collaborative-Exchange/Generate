using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class CIID8750MultipleDisability
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            //Test data for CIID8750 test

            // Data for CIID8750 - We need students whose primary IDEA disability type differs between LEAs/Schools to make sure
            // they are returned by Debug.vwStudentDisabilityConflicts, and students whose disability type does not conflict to make sure they are not.

            //Test cases need two diferent orgs
            var firstOrg = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var secondOrg = testData.K12Organizations.Find(k => k.LeaIdentifierSea != firstOrg.LeaIdentifierSea && k.SchoolIdentifierSea != firstOrg.SchoolIdentifierSea);

            //START TEST Case 1 Condition: Different Primary Disability Type, 2 different schools - should be returned by the view
            var firstK12EnrollmentCase1 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 1",
                LastOrSurname = "DisabilityConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase1 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 1",
                LastOrSurname = "DisabilityConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstIdtCase1 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case1",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("11/25/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture)
            };

            var secondIdtCase1 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case1",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 1 Condition: Different Primary Disability Type, 2 different schools - should be returned by the view

            //START TEST Case 2 Condition: Same Primary Disability Type, 2 different schools - should NOT be returned by the view
            var firstK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("2/20/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 2",
                LastOrSurname = "SameDisability",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase2 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("2/21/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 2",
                LastOrSurname = "SameDisability",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstIdtCase2 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case2",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("2/20/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };

            var secondIdtCase2 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case2",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("2/21/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 2 Condition: Same Primary Disability Type, 2 different schools - should NOT be returned by the view

            //START TEST Case 3 Condition: Primary Disability Type changes within the same school - should NOT be returned by the view
            var firstK12EnrollmentCase3 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 3",
                LastOrSurname = "SameSchoolChange",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstIdtCase3 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("1/15/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };

            var secondIdtCase3 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case3",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("1/16/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 3 Condition: Primary Disability Type changes within the same school - should NOT be returned by the view

            //START TEST Case 4 Condition: Different Primary Disability Type, 2 different schools, concurrent enrollment - should be returned by the view
            var firstK12EnrollmentCase4 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case4",
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
                Sex = "Male"
            };

            var secondK12EnrollmentCase4 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case4",
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

            var firstIdtCase4 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case4",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Deafness",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };

            var secondIdtCase4 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case4",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 4 Condition: Different Primary Disability Type, 2 different schools, concurrent enrollment - should be returned by the view

            //START TEST Case 5 Condition: One school, one IdeaDisabilityType record - should NOT be returned by the view
            var firstK12EnrollmentCase5 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case5",
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

            var firstIdtCase5 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case5",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 5 Condition: One school, one IdeaDisabilityType record - should NOT be returned by the view

            //START TEST Case 6 Condition: Same Primary Disability Type, different Secondary Disability Type, 2 different schools - should NOT be returned by the view
            var firstK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 6",
                LastOrSurname = "SecondaryConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase6 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 6",
                LastOrSurname = "SecondaryConflict",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstIdtCase6 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case6",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };

            var secondIdtCase6 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };

            var thirdIdtCase6 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case6",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Hearingimpairment",
                IsPrimaryDisability = false,
                IsSecondaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 6 Condition: Same Primary Disability Type, different Secondary Disability Type, 2 different schools - should NOT be returned by the view

            //START TEST Case 7 Condition: No Disability at one school, Primary Disability Type at another school - should be returned by the view
            var firstK12EnrollmentCase7 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case7",
                LeaIdentifierSeaAccountability = firstOrg.LeaIdentifierSea,
                SchoolIdentifierSea = firstOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("11/25/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 7",
                LastOrSurname = "NoDisabilityOneSchool",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12EnrollmentCase7 = new K12Enrollment()
            {
                StudentIdentifierState = "CIID8750Case7",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString(), CultureInfo.InvariantCulture),
                EnrollmentEntryDate = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture),
                FirstName = "Case 7",
                LastOrSurname = "NoDisabilityOneSchool",
                HispanicLatinoEthnicity = false,
                ExitOrWithdrawalType = "1908",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            //No IdeaDisabilityType record at the first school
            var secondIdtCase7 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CIID8750Case7",
                LeaIdentifierSeaAccountability = secondOrg.LeaIdentifierSea,
                SchoolIdentifierSea = secondOrg.SchoolIdentifierSea,
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("11/26/" + (schoolYear - 1).ToString(), CultureInfo.InvariantCulture),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString(), CultureInfo.InvariantCulture)
            };
            //END TEST Case 7 Condition: No Disability at one school, Primary Disability Type at another school - should be returned by the view

            testData.K12Enrollments.Add(firstK12EnrollmentCase1);
            testData.K12Enrollments.Add(secondK12EnrollmentCase1);
            testData.IdeaDisabilityTypes.Add(firstIdtCase1);
            testData.IdeaDisabilityTypes.Add(secondIdtCase1);

            testData.K12Enrollments.Add(firstK12EnrollmentCase2);
            testData.K12Enrollments.Add(secondK12EnrollmentCase2);
            testData.IdeaDisabilityTypes.Add(firstIdtCase2);
            testData.IdeaDisabilityTypes.Add(secondIdtCase2);

            testData.K12Enrollments.Add(firstK12EnrollmentCase3);
            testData.IdeaDisabilityTypes.Add(firstIdtCase3);
            testData.IdeaDisabilityTypes.Add(secondIdtCase3);

            testData.K12Enrollments.Add(firstK12EnrollmentCase4);
            testData.K12Enrollments.Add(secondK12EnrollmentCase4);
            testData.IdeaDisabilityTypes.Add(firstIdtCase4);
            testData.IdeaDisabilityTypes.Add(secondIdtCase4);

            testData.K12Enrollments.Add(firstK12EnrollmentCase5);
            testData.IdeaDisabilityTypes.Add(firstIdtCase5);

            testData.K12Enrollments.Add(firstK12EnrollmentCase6);
            testData.K12Enrollments.Add(secondK12EnrollmentCase6);
            testData.IdeaDisabilityTypes.Add(firstIdtCase6);
            testData.IdeaDisabilityTypes.Add(secondIdtCase6);
            testData.IdeaDisabilityTypes.Add(thirdIdtCase6);

            testData.K12Enrollments.Add(firstK12EnrollmentCase7);
            testData.K12Enrollments.Add(secondK12EnrollmentCase7);
            testData.IdeaDisabilityTypes.Add(secondIdtCase7);
        }

    }
}
