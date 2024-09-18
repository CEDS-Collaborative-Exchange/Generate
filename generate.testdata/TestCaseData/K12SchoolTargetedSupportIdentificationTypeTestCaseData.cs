using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class K12SchoolTargetedSupportIdentificationTypeTestCaseData
    {
        public static void AppendStaticK12SchoolTargetedSupportIdentificationTypeTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Test data for FS212 test case #3.8_2.2
            // CSI and TSI should not include schools in exit status
            //testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.OrganizationAddress()
            //{
            //    SchoolYear = schoolYear,
            //    LEA_Identifier_State = "550",
            //    School_Identifier_State = "550320",
            //    Subgroup = "ECODIS",
            //    ComprehensiveSupportReasonApplicability = "RESNAPPLYES",
            //    RecordStartDateTime = DateTime.Parse("07/01/2020"),
            //    RecordEndDateTime = DateTime.Parse("06/30/2021")
            //});
        }
    }
}
