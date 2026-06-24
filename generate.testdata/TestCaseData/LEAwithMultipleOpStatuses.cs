using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class LEAwithMultipleOpStatusesTestCaseData
    {
       
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Test data for LEA w/more than 1 Operationa Status in the same SY

            //Test data for CIID-3872
            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "029CID3872",
                Lea_OperationalStatus = "Open",
                Lea_OperationalStatusEffectiveDate = DateTime.Parse("7/1/" + (schoolYear - 1)),
                LeaOrganizationName = "TestLEA Multiple Op Status",
                Lea_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                Lea_RecordEndDateTime = DateTime.Parse("2/1/" + (schoolYear)),

            });

            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "029CID3872",
                Lea_OperationalStatus = "Closed",
                Lea_OperationalStatusEffectiveDate = DateTime.Parse("2/2/" + (schoolYear)),
                LeaOrganizationName = "TestLEA Multiple Op Status",
                Lea_RecordStartDateTime = DateTime.Parse("2/2/" + (schoolYear)),
                Lea_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),

            });


        }
    }
}
