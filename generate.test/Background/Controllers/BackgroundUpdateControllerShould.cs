using generate.background.Controllers;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using System.IO.Abstractions;
using System.IO.Abstractions.TestingHelpers;
using generate.core.Dtos.App;
using Newtonsoft.Json;
using System.Net;

namespace generate.test.Background.Controllers
{
    public class BackgroundUpdateControllerShould
    {

        [Fact]
        public void DownloadedUpdates()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var backgroundUpdateService = new Mock<IAppUpdateService>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            var updatePackage = new UpdatePackageDto()
            {
                FileName = "generate_3.0.zip",
                Description = "Minor Release",
                MajorVersion = 3,
                MinorVersion = 0,
                PrerequisiteVersion = "2.9",
                ReleaseDate = new DateTime(2019, 1, 15),
                DatabaseBackupSuggested = false,
                ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
            };

            List<UpdatePackageDto> packages = new List<UpdatePackageDto>();
            packages.Add(updatePackage);

            backgroundUpdateService.Setup(x => x.GetDownloadedUpdates(It.IsAny<string>())).Returns(packages);

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService.Object, hangfireHelper);

            // Act

            var response = controller.DownloadedUpdates();

            // Assert

            Assert.NotEmpty(response.Value);

        }


        [Fact]
        public void DownloadUpdates()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var backgroundUpdateService = Mock.Of<IAppUpdateService>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService, hangfireHelper);

            // Act

            var response = controller.DownloadUpdates();

            // Assert

            Assert.IsType<OkResult>(response);

        }


        [Fact]
        public void ClearUpdates()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var backgroundUpdateService = Mock.Of<IAppUpdateService>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService, hangfireHelper);

            // Act

            var response = controller.ClearUpdates();

            // Assert

            Assert.IsType<OkResult>(response);

        }



        [Fact]
        public void ExecuteUpdate()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = new Mock<IHostEnvironment>();
            var appUpdateService = Mock.Of<IAppUpdateService>();
            var hangfireHelper = new Mock<IHangfireHelper>();

            hostingEnvironment.Setup(x => x.ContentRootPath).Returns(@"c:\generate.background");

            var controller = new BackgroundUpdateController(logger, hostingEnvironment.Object, appUpdateService, hangfireHelper.Object);

            // Act

            var response = controller.ExecuteUpdate();

            // Assert

            Assert.IsType<OkResult>(response);
            hangfireHelper.Verify(x => x.TriggerSiteUpdate(@"c:\generate.background", "background"), Times.Once);

        }


        [Fact]
        public void ExecuteUpdate_BadRequest()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = Mock.Of<IAppUpdateService>();
            var hangfireHelper = new Mock<IHangfireHelper>();

            hangfireHelper.Setup(x => x.TriggerSiteUpdate(It.IsAny<string>(), It.IsAny<string>())).Throws(new InvalidOperationException());

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, appUpdateService, hangfireHelper.Object);

            // Act

            var response = controller.ExecuteUpdate();

            // Assert

            Assert.IsType<BadRequestObjectResult>(response);

        }


    }
}
