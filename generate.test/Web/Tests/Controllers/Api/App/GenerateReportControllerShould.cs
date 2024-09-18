using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.web.Controllers.Api.App;
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

namespace generate.test.Web.Tests.Controllers.Api.App
{

    public class GenerateReportControllerShould
    {
        private List<GenerateReportDto> GetTestData()
        {
            var data = new List<GenerateReportDto>();
            data.Add(new GenerateReportDto()
            {
                GenerateReportId = 1,
                ReportCode = "TEST1",
                ReportName = "Test 1"
            });
            data.Add(new GenerateReportDto()
            {
                GenerateReportId = 2,
                ReportCode = "TEST2",
                ReportName = "Test 2"
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var service = new Mock<IGenerateReportService>();
            var rdsRepository = new Mock<IRDSRepository>();
            var appRepository = new Mock<IAppRepository>();

            service.Setup(x => x.GetReportDtos(It.IsAny<List<GenerateReport>>()))
                .Returns(GetTestData());

            var controller = new GenerateReportController(service.Object, rdsRepository.Object, appRepository.Object);

            // Act
            var result = controller.Get("test");

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<GenerateReportDto>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }


        [Fact]
        public void Get_ReportCode()
        {

            // Arrange
            var service = new Mock<IGenerateReportService>();
            var rdsRepository = new Mock<IRDSRepository>();
            var appRepository = new Mock<IAppRepository>();

            service.Setup(x => x.GetReportDtos(It.IsAny<List<GenerateReport>>()))
                .Returns(GetTestData());

            var controller = new GenerateReportController(service.Object, rdsRepository.Object, appRepository.Object);

            // Act
            var result = controller.Get("test", "test");

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<GenerateReportDto>(viewResult.Value);
            Assert.NotNull(model);

        }


    }


}
