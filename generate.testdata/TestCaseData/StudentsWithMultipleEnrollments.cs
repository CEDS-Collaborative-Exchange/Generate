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
    public class StudentsWithMultipleEnrollments
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            var org2 = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            while(org.SchoolIdentifierSea == org2.SchoolIdentifierSea)
            {
                org2 = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);
            }

            var firstK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "9990000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 2).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear - 1).ToString()),
                //ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Sam",
                LastOrSurname = "Multienrolled",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var secondK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "9990000001",
                LeaIdentifierSeaAccountability = org2.LeaIdentifierSea,
                SchoolIdentifierSea = org2.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("03/12/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                //ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Jake",
                LastOrSurname = "Multienrolled",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Female"
            };

            var idsReferenceData = new IdsReferenceData();
            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var firstPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "9990000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/30/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                SpecialEducationExitReason = "HighSchoolDiploma"
            };

            var secondPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "9990000001",
                LeaIdentifierSeaAccountability = org2.LeaIdentifierSea,
                SchoolIdentifierSea = org2.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/30/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                SpecialEducationExitReason = "HighSchoolDiploma"
            };

            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.K12Enrollments.Add(secondK12Enrollment);
            testData.ProgramParticipationSpecialEducations.Add(firstPpse);
            testData.ProgramParticipationSpecialEducations.Add(secondPpse);
        }
    }
}
