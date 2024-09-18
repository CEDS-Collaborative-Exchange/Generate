using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS029_CIID4827_TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Data for CIID-4827 - A K12School that has an NCES Id that matches the State Id of another school
            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "XYZ",
                LeaIdentifierNCES = "123456",
                LEA_OperationalStatus = "Open",
                LEA_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                LeaOrganizationName = "LEA Added for Testing",
                LEA_Type = "1",
                LEA_IsReportedFederally = true,
                LEA_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                SchoolIdentifierSea = "XYZ123",
                SchoolIdentifierNCES = "120320",
                School_OperationalStatus = "Open",
                School_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                SchoolOrganizationName = "K12School Added for Testing",
                School_Type = "Regular",
                School_IsReportedFederally = true,
                School_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                School_CharterSchoolIndicator = true,
            });
        }
    }
}
