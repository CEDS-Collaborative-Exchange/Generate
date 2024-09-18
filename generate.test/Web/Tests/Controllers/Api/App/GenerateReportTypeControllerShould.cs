using generate.core.Interfaces.Repositories.App;
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

    public class GenerateReportTypeControllerShould
    {
        private List<GenerateReportType> GetTestData()
        {
            var data = new List<GenerateReportType>();
            data.Add(new GenerateReportType()
            {
                GenerateReportTypeId = 1,
                ReportTypeCode = "TST1",
                ReportTypeName = "Test1"
            });
            data.Add(new GenerateReportType()
            {
                GenerateReportTypeId = 2,
                ReportTypeCode = "TST2",
                ReportTypeName = "Test2"
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<GenerateReportType>(0, 0))
                .Returns(GetTestData());
            var controller = new GenerateReportTypeController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<GenerateReportType>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }
        

    }


}
