using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS212TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSILOWPERF and RESNAPPLYES and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {

                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998703",
                //ComprehensiveSupport = "CSILOWPERF",
                Subgroup = "MAN",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")


            });

            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSILOWGR and RESNAPPLYES and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998706",
                //ComprehensiveSupport = "CSILOWGR",
                Subgroup = "MA",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });


            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSIOTHER and RESNAPPLYES and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998709",
                //ComprehensiveSupport = "CSIOTHER",
                Subgroup = "MNP",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")


            });

            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSILOWPERF and RESNAPPLYNO and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998711",
                //ComprehensiveSupport = "CSILOWPERF",
                Subgroup = "MB",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")


            });

            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSILOWGR and RESNAPPLYNO and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998712",
                //ComprehensiveSupport = "CSILOWGR",
                Subgroup = "MAP",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.4
            //  Data Record Definition with CSIOTHER and RESNAPPLYNO and Race should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998713",
                //ComprehensiveSupport = "CSIOTHER",
                Subgroup = "MW",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {

                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998714",
                Subgroup = "ECODIS",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });


            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998715",
                Subgroup = "WDIS",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998719",
                Subgroup = "LEP",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998729",
                Subgroup = "MAN",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998730",
                Subgroup = "MA",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "998",
                SchoolIdentifierState = "998731",
                Subgroup = "MHN",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "997",
                SchoolIdentifierState = "997220",
                Subgroup = "MF",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "997",
                SchoolIdentifierState = "997209",
                Subgroup = "MHN",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "997",
                SchoolIdentifierState = "997208",
                Subgroup = "MHL",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "997",
                SchoolIdentifierState = "997121",
                Subgroup = "MM",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYES should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "997",
                SchoolIdentifierState = "997000",
                Subgroup = "MNP",
                ComprehensiveSupportReasonApplicability = "ReasonApplies",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "996",
                SchoolIdentifierState = "996736",
                Subgroup = "MPR",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });

            // Test data for FS212 test case #3.8_2.5
            //  Data Record Definition with TSIREASONS and RESNAPPLYNO should include schools in exit status
            testData.K12SchoolTargetedSupportIdentificationType.Add(new core.Models.Staging.K12SchoolTargetedSupportIdentificationType()
            {
                SchoolYear = schoolYear.ToString(),
                LEAIdentifierState = "996",
                SchoolIdentifierState = "996734",
                Subgroup = "MB",
                ComprehensiveSupportReasonApplicability = "ReasonDoesNotApply",
                RecordStartDateTime = DateTime.Parse("07/01/2020"),
                RecordEndDateTime = DateTime.Parse("06/30/2021")
            });
        }
    }
}
