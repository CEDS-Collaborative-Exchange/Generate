using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper.App;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.RDS;
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
    public class DimensionRepositoryShould
    {

        private AppDbContext GetAppDbContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.AppDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            return context;
        }


        private RDSDbContext GetRdsDbContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.RDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<RDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new RDSDbContext(options, logger, appSettings);

            return context;
        }


        private void SetupTestData(AppDbContext appDbContext)
        {
            appDbContext.ToggleQuestions.AddRange(ToggleQuestionHelper.GetData());
            appDbContext.ToggleQuestionOptions.AddRange(ToggleQuestionOptionHelper.GetData());
            appDbContext.ToggleResponses.AddRange(ToggleResponseHelper.GetData());

            appDbContext.SaveChanges();
        }

        [Fact]
        public void GetCustomDateFromToggle()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);
                int monthValue = 11;
                int dayValue = 1;

                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetCustomDateFromToggle("CHDCTDTE", 11, 1, out monthValue, out dayValue);

                //Assert               
                Assert.Equal(10, monthValue);
                Assert.Equal(1, dayValue);

            }

        }


        [Fact]
        public void GetCustomDateFromToggle_NullResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);

                var logger = Mock.Of<ILogger<DimensionRepository>>();
                var toggleResponse = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDTE");
                toggleResponse.ResponseValue = null;
                appDbContext.SaveChanges();

                int monthValue = 11;
                int dayValue = 1;

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetCustomDateFromToggle("CHDCTDTE", 11, 1, out monthValue, out dayValue);

                //Assert               
                Assert.Equal(11, monthValue);
                Assert.Equal(1, dayValue);

            }

        }



        [Fact]
        public void GetCustomDateFromToggle_NoResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                int monthValue = 11;
                int dayValue = 1;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetCustomDateFromToggle("CHDCTDTE", 11, 1, out monthValue, out dayValue);

                //Assert               
                Assert.Equal(11, monthValue);
                Assert.Equal(1, dayValue);

            }

        }


        [Fact]
        public void GetChildCountDates()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);
                int monthValue = 11;
                int dayValue = 1;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetChildCountDates(out monthValue, out dayValue);

                //Assert               
                Assert.Equal(10, monthValue);
                Assert.Equal(1, dayValue);

            }

        }


        [Fact]
        public void GetChildCountDates_NullResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                var toggleResponse = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDTE");
                toggleResponse.ResponseValue = null;
                appDbContext.SaveChanges();

                int monthValue = 11;
                int dayValue = 1;

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetChildCountDates(out monthValue, out dayValue);

                //Assert               
                Assert.Equal(11, monthValue);
                Assert.Equal(1, dayValue);

            }

        }



        [Fact]
        public void GetChildCountDates_NoResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                int monthValue = 11;
                int dayValue = 1;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetChildCountDates(out monthValue, out dayValue);

                //Assert               
                Assert.Equal(11, monthValue);
                Assert.Equal(1, dayValue);

            }

        }




        [Fact]
        public void GetReferencePeriodDates()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("submission", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(1, startDayValue);
                Assert.Equal(6, endMonthValue);
                Assert.Equal(2, endDayValue);
            }

        }


        [Fact]
        public void GetReferencePeriodDates_Cte()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;

                // Act
                var logger = Mock.Of<ILogger<DimensionRepository>>();
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("cte", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(6, startDayValue);
                Assert.Equal(10, endMonthValue);
                Assert.Equal(1, endDayValue);
            }

        }



        [Fact]
        public void GetReferencePeriodDates_NoResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;

                // Act
                var logger = Mock.Of<ILogger<DimensionRepository>>();
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("submission", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(1, startDayValue);
                Assert.Equal(6, endMonthValue);
                Assert.Equal(30, endDayValue);
            }

        }


        [Fact]
        public void GetReferencePeriodDates_CteNoResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;

                // Act
                var logger = Mock.Of<ILogger<DimensionRepository>>();
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("cte", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(1, startDayValue);
                Assert.Equal(6, endMonthValue);
                Assert.Equal(30, endDayValue);
            }

        }




        [Fact]
        public void GetReferencePeriodDates_NullResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);

                var toggleResponse = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "DEFEXREFDTESTART");
                if (toggleResponse != null)
                {
                    toggleResponse.ResponseValue = null;
                }
                var toggleResponse2 = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "DEFEXREFDTEEND");
                if (toggleResponse2 != null)
                {
                    toggleResponse2.ResponseValue = null;
                }
                appDbContext.SaveChanges();

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("submission", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(1, startDayValue);
                Assert.Equal(6, endMonthValue);
                Assert.Equal(30, endDayValue);
            }

        }


        [Fact]
        public void GetReferencePeriodDates_CteNullResponse()
        {

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupTestData(appDbContext);

                var toggleResponse = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CTEPERKPROGYRSTART");
                toggleResponse.ResponseValue = null;
                var toggleResponse2 = appDbContext.ToggleResponses.FirstOrDefault(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CTEPERKPROGYREND");
                toggleResponse2.ResponseValue = null;
                appDbContext.SaveChanges();

                int startMonthValue = 7;
                int startDayValue = 1;
                int endMonthValue = 6;
                int endDayValue = 30;
                var logger = Mock.Of<ILogger<DimensionRepository>>();

                // Act
                var repository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                repository.GetReferencePeriodDates("cte", out startMonthValue, out startDayValue, out endMonthValue, out endDayValue);

                //Assert               
                Assert.Equal(7, startMonthValue);
                Assert.Equal(1, startDayValue);
                Assert.Equal(6, endMonthValue);
                Assert.Equal(30, endDayValue);
            }

        }


    }
}
