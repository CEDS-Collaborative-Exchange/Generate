using generate.background.Controllers;
using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using generate.core.Dtos.App;

namespace generate.test.Background.Controllers
{
    public class DataMigrationControllerShould
    {
               
        [Fact]
        public void MigrateData()
        {
            // Arrange

            var logger = Mock.Of<ILogger<DataMigrationController>>();
            var migrationService = Mock.Of<IMigrationService>();

            var controller = new DataMigrationController(logger, migrationService);

            // Act

            var response = controller.MigrateData("report");

            // Assert

            Assert.IsType<OkResult>(response);

        }


        [Fact]
        public void MigrateData_BadRequest()
        {
            // Arrange

            var logger = Mock.Of<ILogger<DataMigrationController>>();
            var migrationService = new Mock<IMigrationService>();

            migrationService.Setup(x => x.MigrateData(It.IsAny<string>())).Throws(new InvalidOperationException());

            var controller = new DataMigrationController(logger, migrationService.Object);

            // Act

            var response = controller.MigrateData("report");

            // Assert

            Assert.IsType<BadRequestObjectResult>(response);

        }

    }
}
