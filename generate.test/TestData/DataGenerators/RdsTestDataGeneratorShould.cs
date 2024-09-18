using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using generate.testdata.DataGenerators;
using generate.testdata.Helpers;
using generate.testdata.Profiles;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.TestData.DataGenerators
{
    public class RdsTestDataGeneratorShould
    {


        [Fact]
        public void GetFreshTestDataObject()
        {

            // Arrange
            var rdsTestDataGenerator = new RdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new RdsTestDataProfile());

            // Act
            RdsTestDataObject testData = rdsTestDataGenerator.GetFreshTestDataObject(1);

            //Assert

            Assert.NotNull(testData);
            Assert.NotNull(testData.DimCharterSchoolAuthorizers);
            Assert.NotNull(testData.DimLeas);
            Assert.NotNull(testData.DimPersonnel);
            Assert.NotNull(testData.DimSchools);
            Assert.NotNull(testData.DimSeas);
            Assert.NotNull(testData.DimStudents);
            Assert.NotNull(testData.FactCustomCounts);
            Assert.NotNull(testData.FactOrganizationCounts);
            Assert.NotNull(testData.FactOrganizationStatusCounts);
            Assert.NotNull(testData.FactPersonnelCounts);
            Assert.NotNull(testData.FactStudentAssessments);
            Assert.NotNull(testData.FactStudentCounts);
            Assert.NotNull(testData.FactStudentDisciplines);

        }


        [Fact]
        public void GenerateTestData_Sql()
        {

            // Arrange
            var rdsTestDataGenerator = new RdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new RdsTestDataProfile());

            // Act
            rdsTestDataGenerator.GenerateTestData(1000, 10, "sql", "console", "");

            //Assert
            Assert.True(true);

        }

        [Fact]
        public void GenerateTestData_CSharp()
        {

            // Arrange
            var rdsTestDataGenerator = new RdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new RdsTestDataProfile());

            // Act
            rdsTestDataGenerator.GenerateTestData(1000, 10, "c#", "console", "");

            //Assert
            Assert.True(true);

        }


        [Fact]
        public void GenerateTestData_Json()
        {

            // Arrange
            var rdsTestDataGenerator = new RdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new RdsTestDataProfile());

            // Act
            rdsTestDataGenerator.GenerateTestData(1000, 10, "json", "console", "");

            //Assert
            Assert.True(true);

        }


    }
}
