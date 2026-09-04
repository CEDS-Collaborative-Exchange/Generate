using generate.core.Helpers.TestDataHelper;
using generate.testdata.Interfaces;
using generate.core.Models.Staging;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class LEASpecificGradesOffered
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            // Create grades offered that differ from the rolled-up school grades offered for a specific LEA.
            // This is to test that the LEA grades offered are used instead of the rolled-up school grades offered.

            var Grade1 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "01",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            var Grade2 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "02",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            var Grade3 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "03",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            var Grade4 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "04",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            var Grade5 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "05",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            var Grade6 = new OrganizationGradeOffered()
            {
                OrganizationIdentifier = "000920",
                OrganizationType = "Lea",
                GradeOffered = "06",
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1)),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear)),
                SchoolYear = schoolYear.ToString()
            };
            testData.OrganizationGradeOffereds.Add(Grade1);
            testData.OrganizationGradeOffereds.Add(Grade2);
            testData.OrganizationGradeOffereds.Add(Grade3);
            testData.OrganizationGradeOffereds.Add(Grade4);
            testData.OrganizationGradeOffereds.Add(Grade5);
            testData.OrganizationGradeOffereds.Add(Grade6);

        }
    }
}
