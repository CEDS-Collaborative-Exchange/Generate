using generate.background.Controllers;
using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Hosting;
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
            var options = Mock.Of<IOptions<AppSettings>>();
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

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService.Object, options, hangfireHelper);

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
            var options = Mock.Of<IOptions<AppSettings>>();            
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService, options, hangfireHelper);

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
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, backgroundUpdateService, appSettings, hangfireHelper);

            // Act

            var response = controller.ClearUpdates();

            // Assert

            Assert.IsType<OkResult>(response);

        }



        [Fact]
        public void ExecuteUpdate_Development()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = new Mock<IHostEnvironment>();
            var appUpdateService = Mock.Of<IAppUpdateService>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            hostingEnvironment.Setup(x => x.ContentRootPath).Returns(@"c:\generate.web");
            hostingEnvironment.Setup(x => x.EnvironmentName).Returns("Development");

            var controller = new BackgroundUpdateController(logger, hostingEnvironment.Object, appUpdateService, appSettings, hangfireHelper);

            // Act

            var response = controller.ExecuteUpdate();

            // Assert

            Assert.IsType<OkResult>(response);

        }


        [Fact]
        public void ExecuteUpdate_NotDevelopment()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = new Mock<IHostEnvironment>();
            var appUpdateService = Mock.Of<IAppUpdateService>();
            var appSettings = new Mock<IOptions<AppSettings>>();
            var hangfireHelper = Mock.Of<IHangfireHelper>();

            hostingEnvironment.Setup(x => x.ContentRootPath).Returns(@"c:\generate.web");
            hostingEnvironment.Setup(x => x.EnvironmentName).Returns("Production");

            var options = new AppSettings() {
                WebAppPath = @"c:\generate.web"
            };
            appSettings.Setup(x => x.Value).Returns(options);

            var controller = new BackgroundUpdateController(logger, hostingEnvironment.Object, appUpdateService, appSettings.Object, hangfireHelper);

            // Act

            var response = controller.ExecuteUpdate();

            // Assert

            Assert.IsType<OkResult>(response);

        }


        [Fact]
        public void ExecuteUpdate_BadRequest()
        {
            // Arrange

            var logger = Mock.Of<ILogger<BackgroundUpdateController>>();
            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = Mock.Of<IAppUpdateService>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var hangfireHelper = new Mock<IHangfireHelper>();

            hangfireHelper.Setup(x => x.TriggerSiteUpdate(It.IsAny<string>(), It.IsAny<string>())).Throws(new InvalidOperationException());

            var controller = new BackgroundUpdateController(logger, hostingEnvironment, appUpdateService, appSettings,hangfireHelper.Object);

            // Act

            var response = controller.ExecuteUpdate();

            // Assert

            Assert.IsType<BadRequestObjectResult>(response);

        }


    }
}
