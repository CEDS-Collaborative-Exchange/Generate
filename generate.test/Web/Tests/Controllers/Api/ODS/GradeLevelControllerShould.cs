using generate.core.Interfaces.Repositories.IDS;
using generate.core.Models.IDS;
using generate.core.Config;
using generate.infrastructure.Repositories.RDS;
using generate.infrastructure.Contexts;
using generate.web.Controllers.Api.ODS;
using generate.web.Controllers.Web;
using generate.test.Web.Fixtures;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace generate.test.Web.Tests.Controllers.Api.ODS
{

    public class GradeLevelControllerShould
    {
        private List<RefGradeLevel> GetTestData()
        {
            var data = new List<RefGradeLevel>();
            data.Add(new RefGradeLevel()
            {
                RefGradeLevelId = 1,
                Code = "01",
                Description = "Grade 1"                
            });
            data.Add(new RefGradeLevel()
            {
                RefGradeLevelId = 1,
                Code = "01",
                Description = "Grade 1"
            });
            return data;
        }

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

        [Fact]
        public void Get()
        {
            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                var logger = Mock.Of<ILogger<DimensionRepository>>();
                var dimensionRepository = new DimensionRepository(appDbContext, rdsDbContext, logger);
                // Arrange
                var mockRepo = new Mock<IIDSRepository>();
                mockRepo.Setup(repo => repo.GetAll<RefGradeLevel>(0, 50))
                    .Returns(GetTestData());
                var controller = new GradeLevelController(mockRepo.Object, dimensionRepository);

                // Act
                var result = controller.Get();

                // Assert
                var viewResult = Assert.IsType<JsonResult>(result);
                var model = Assert.IsAssignableFrom<IEnumerable<RefGradeLevel>>(viewResult.Value);
                Assert.NotEmpty(model);
                Assert.Equal(2, model.Count());

            }
        }

    }


}
