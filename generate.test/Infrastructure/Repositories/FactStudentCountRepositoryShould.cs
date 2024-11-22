using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.RDS;
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

namespace generate.test.Infrastructure.Repositories
{
    public class FactStudentCountRepositoryShould
    {

        private AppDbContext GetAppDbContext()
        {

            var options = new DbContextOptionsBuilder<AppDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            return context;
        }


        private IDSDbContext GetOdsDbContext()
        {

            var options = new DbContextOptionsBuilder<IDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<IDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new IDSDbContext(options, logger, appSettings);

            return context;
        }


        private RDSDbContext GetRdsDbContext()
        {

            var options = new DbContextOptionsBuilder<RDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<RDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new RDSDbContext(options, logger);

            return context;
        }


        private void SetupReferenceData(IDSDbContext odsDbContext, RDSDbContext rdsDbContext)
        {

            rdsDbContext.DimDates.AddRange(DimDateHelper.GetData());
            rdsDbContext.DimAges.AddRange(DimAgeHelper.GetData());
            rdsDbContext.DimDemographics.AddRange(DimDemographicHelper.GetData());
            rdsDbContext.DimFactTypes.AddRange(DimFactTypeHelper.GetData());
            rdsDbContext.DimLanguages.AddRange(DimLanguageHelper.GetData());
            rdsDbContext.DimProgramStatuses.AddRange(DimProgramStatusHelper.GetData());

            rdsDbContext.SaveChanges();

        }


        //private void SetupTestData(AppDbContext appDbContext, ODSDbContext oDSDbContext, RDSDbContext rdsDbContext)
        //{
        //    appDbContext.ToggleResponses.AddRange(ToggleResponseHelper.GetData());
        //    appDbContext.SaveChanges();

        //    OdsTestDataGenerator odsTestDataGenerator = new OdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new TestDataProfile());

        //    int generateOrganizationId = 0;
        //    int seaOrganizationId = 0;
        //    var refState = RefStateHelper.GetData().FirstOrDefault();
        //    var testData = odsTestDataGenerator.GetFreshTestDataObject();
        //    var rnd = new Random(1000);
        //    testData = odsTestDataGenerator.CreateGenerateOrganization(testData, out generateOrganizationId);
        //    testData = odsTestDataGenerator.CreateRoles(testData, generateOrganizationId);
        //    testData = odsTestDataGenerator.CreateSea(rnd, testData, out seaOrganizationId, out refState);
        //    testData = odsTestDataGenerator.CreateOrganizations(rnd, 10, 0, refState);

        //    oDSDbContext.Person.AddRange(testData.Persons);
        //    oDSDbContext.PersonDetail.AddRange(testData.PersonDetails);
        //    oDSDbContext.SaveChanges();

        //    RdsTestDataGenerator rdsTestDataGenerator = new RdsTestDataGenerator(new OutputHelper(), new TestDataHelper(), new TestDataProfile());
        //    var rdsTestData = rdsTestDataGenerator.GetTestData(100, 10);

        //    rdsDbContext.DimSchools.AddRange(rdsTestData.DimSchools);
        //    rdsDbContext.DimStudents.AddRange(rdsTestData.DimStudents);
        //    rdsDbContext.SaveChanges();
        //}


        //[Fact]
        //public void Migrate_FactStudentCounts()
        //{

        //    using (var appDbContext = GetAppDbContext())
        //    using (var odsDbContext = GetOdsDbContext())
        //    using (var rdsDbContext = GetRdsDbContext())
        //    {
        //        // Arrange
        //        var logger = Mock.Of<ILogger<FactStudentCountRepository>>();
        //        var dimensionRepository = new DimensionRepository(appDbContext, rdsDbContext);

        //        SetupReferenceData(odsDbContext, rdsDbContext);
        //        SetupTestData(appDbContext, odsDbContext, rdsDbContext);

        //        int monthValue = 11;
        //        int dayValue = 1;

        //        // Act
        //        var repository = new FactStudentCountRepository(logger, odsDbContext, rdsDbContext, dimensionRepository);
        //        repository.Migrate_FactStudentCounts("2018-19", "submission");

        //        //Assert
        //        var results = rdsDbContext.FactStudentCounts.ToList();
        //        Assert.NotEmpty(results);
        //    }

        //}


    }
}
