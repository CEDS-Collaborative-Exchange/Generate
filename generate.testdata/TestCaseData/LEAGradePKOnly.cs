using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using generate.core.Models.Staging;
using System;

namespace generate.testdata.TestCaseData
{
    public class LEAGradePKOnlyTestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {

            // Test LEA that will only offer PK in Grade Levels

            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {
                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "LEAPKOnly",
                Lea_OperationalStatus = "Open",
                Lea_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1)),
                LeaOrganizationName = "LEA PK Only Grades",
                Lea_IsReportedFederally = true,
                Lea_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                Lea_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolIdentifierSea = "SCHPKOnly",
                School_OperationalStatus = "Open",
                School_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1)),
                SchoolOrganizationName = "School PK Only Grades",
                School_IsReportedFederally = true,
                School_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                School_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                School_CharterSchoolIndicator = true,
            });

            OrganizationGradeOffered k12schoolGradeOffered = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "SCHPKOnly",
                GradeOffered = "PK",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            testData.OrganizationGradeOffereds.Add(k12schoolGradeOffered);

        }
    }
}
