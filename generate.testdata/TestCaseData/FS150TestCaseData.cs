using generate.core.Helpers.TestDataHelper;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS150TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {//Test data for FS150 test case#1
            // GRADRT7YRADJ

            testData.K12Enrollments.Add(new core.Models.Staging.K12Enrollment()

            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSeaAccountability = "360",
                SchoolIdentifierSea = "360380",
                StudentIdentifierState = "1500001339",
                Birthdate = DateTime.Parse("02/04/1999"),
                EnrollmentEntryDate = DateTime.Parse("02/01/2013"),
                FirstName = "Robin",
                LastOrSurname = "Hood",
                Sex = "Female",
                HispanicLatinoEthnicity = true,
                GradeLevel = "07",
                CohortYear = "2019",
                CohortGraduationYear = "2020",
                CohortDescription = "GRAD",

            });
            {//Test data for FS150 test case#2
             // GRADRT8YRADJ

                testData.K12Enrollments.Add(new core.Models.Staging.K12Enrollment()

                {

                    SchoolYear = schoolYear.ToString(),
                    LeaIdentifierSeaAccountability = "510",
                    SchoolIdentifierSea = "510323",
                    StudentIdentifierState = "1500001936",
                    Birthdate = DateTime.Parse("02/04/1998"),
                    EnrollmentEntryDate = DateTime.Parse("02/01/2012"),
                    FirstName = "Jason",
                    LastOrSurname = "Gwinn",
                    Sex = "Female",
                    HispanicLatinoEthnicity = true,
                    GradeLevel = "07",
                    CohortYear = "2019",
                    CohortGraduationYear = "2020",
                    CohortDescription = "GRAD",

                });
                {//Test data for FS150 test case#3
                 // GRADRT9YRADJ

                    testData.K12Enrollments.Add(new core.Models.Staging.K12Enrollment()

                    {

                        SchoolYear = schoolYear.ToString(),
                        LeaIdentifierSeaAccountability = "900",
                        SchoolIdentifierSea = "900376",
                        StudentIdentifierState = "1500000043",
                        Birthdate = DateTime.Parse("02/04/1997"),
                        EnrollmentEntryDate = DateTime.Parse("02/01/2011"),
                        FirstName = "Julie",
                        LastOrSurname = "Thompson",
                        Sex = "Female",
                        HispanicLatinoEthnicity = true,
                        GradeLevel = "07",
                        CohortYear = "2019",
                        CohortGraduationYear = "2020",
                        CohortDescription = "GRAD",

                    });
                    {//Test data for FS150 test case#4
                     // GRADRT10YRADJ

                        testData.K12Enrollments.Add(new core.Models.Staging.K12Enrollment()

                        {

                            SchoolYear = schoolYear.ToString(),
                            LeaIdentifierSeaAccountability = "181",
                            SchoolIdentifierSea = "181332",
                            StudentIdentifierState = "1500001338",
                            Birthdate = DateTime.Parse("02/04/1996"),
                            EnrollmentEntryDate = DateTime.Parse("02/01/2010"),
                            FirstName = "Mary",
                            LastOrSurname = "Thomas",
                            Sex = "Female",
                            HispanicLatinoEthnicity = true,
                            GradeLevel = "07",
                            CohortYear = "2019",
                            CohortGraduationYear = "2020",
                            CohortDescription = "GRAD",

                        });
                    }
                }
            }
        }
    }
}