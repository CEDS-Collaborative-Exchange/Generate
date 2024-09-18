using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class LEAnoSchoolTestCaseData
    {
       
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Test data for LEAnoSchool
            
            testData.K12Organizations.Add(new core.Models.Staging.K12Organization()
            {

                SchoolYear = schoolYear.ToString(),
                LeaIdentifierSea = "ABC",
                LEA_OperationalStatus="Open",
                LeaOrganizationName="TestLEA",
                LEA_RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                LEA_RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                                        });

            
        }
    }
}
