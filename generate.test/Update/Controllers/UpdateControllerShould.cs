using generate.update.Controllers;
using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Mvc;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using generate.core.Dtos.App;

namespace generate.test.Update.Controllers
{
    public class UpdateControllerShould
    {


        [Fact]
        public void GetAll()
        {
            // Arrange

            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = new Mock<IAppUpdateService>();

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

            appUpdateService.Setup(x => x.GetPendingUpdates(It.IsAny<string>(), 0, 0)).Returns(packages);

            var controller = new UpdateController(hostingEnvironment, appUpdateService.Object);

            // Act

            var response = controller.GetAll();

            // Assert

            Assert.NotEmpty(response.Value);

        }


        [Fact]
        public void GetByVersion()
        {
            // Arrange

            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = new Mock<IAppUpdateService>();

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

            appUpdateService.Setup(x => x.GetPendingUpdates(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(packages);

            var controller = new UpdateController(hostingEnvironment, appUpdateService.Object);

            // Act

            var response = controller.GetByVersion("3.0");

            // Assert

            Assert.NotEmpty(response.Value);

        }


        [Fact]
        public void GetByVersion_BadRequest_NoDecimals()
        {
            // Arrange

            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = new Mock<IAppUpdateService>();

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

            appUpdateService.Setup(x => x.GetPendingUpdates(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(packages);

            var controller = new UpdateController(hostingEnvironment, appUpdateService.Object);

            // Act

            var response = controller.GetByVersion("3");

            // Assert

            Assert.IsType<BadRequestResult>(response.Result);

        }


        [Fact]
        public void GetByVersion_BadRequest_TwoDecimals()
        {
            // Arrange

            var hostingEnvironment = Mock.Of<IHostEnvironment>();
            var appUpdateService = new Mock<IAppUpdateService>();

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

            appUpdateService.Setup(x => x.GetPendingUpdates(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns(packages);

            var controller = new UpdateController(hostingEnvironment, appUpdateService.Object);

            // Act

            var response = controller.GetByVersion("3.4.6");

            // Assert

            Assert.IsType<BadRequestResult>(response.Result);

        }
    }
}
