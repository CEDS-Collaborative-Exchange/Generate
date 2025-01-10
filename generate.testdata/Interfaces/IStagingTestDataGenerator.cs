using generate.core.Config;
using generate.core.Helpers.TestDataHelper;
using generate.core.Interfaces.Services;
using generate.core.Models.IDS;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Interfaces
{
    public interface IStagingTestDataGenerator
    {
        StagingTestDataObject CreateAssessments(Random rnd, StagingTestDataObject testData, int numberOfAssessments, int SchoolYear);
        StagingTestDataObject CreateK12EnrollmentData(StagingTestDataObject testData, int recordCount, int disciplineCountLowerLimit, int disciplineCountUpperLimit);
        StagingEnrollmentTestDataObject UpdateK12EnrollmentData(StagingEnrollmentTestDataObject testData, int recordCount, int disciplineCountLowerLimit, int disciplineCountUpperLimit);
        void GenerateTestData(int seed, int quantityOfStudents, int schoolYear, int numberOfYears, string formatType, string outputType,string dataStandardType, string filePath, ITestDataInitializer testDataInitializer);
    }
}
