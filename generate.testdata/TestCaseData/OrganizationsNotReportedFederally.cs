using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class OrganizationsNotReportedFederallyTestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Test data for Organizations not reported federally

            //Test data for CIID-4565
            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "LEACID4565",
                Lea_OperationalStatus = "Open",
                Lea_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1)),
                LeaOrganizationName = "Lea Not Reported Federally",
                Lea_IsReportedFederally = false,
                Lea_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                Lea_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolIdentifierSea = "SCHCID4565",
                School_OperationalStatus = "Open",
                School_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1)),
                SchoolOrganizationName = "School Not Reported Federally",
                School_IsReportedFederally = false,
                School_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                School_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),

            });
        }
    }
}
