using generate.core.Interfaces.Repositories.IDS;
using generate.core.Models.IDS;
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

namespace generate.test.Web.Tests.Controllers.Api.ODS
{
    public class PerformanceLevelDto
    {
        public string Identifier;
        public string Label;
        public string LowerCutScore;
        public string UpperCutScore;
        public string ScoreMetric;
        public string DescriptiveFeedback;
    }


    public class PerformanceLevelControllerShould
    {
        private List<PerformanceLevelDto> GetTestData()
        {
            var data = new List<PerformanceLevelDto>();
            data.Add(new PerformanceLevelDto()
            {
                Identifier = "1",
                Label = "Level 1"
            });
            data.Add(new PerformanceLevelDto()
            {
                Identifier = "2",
                Label = "Level 2"
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IIDSRepository>();
            mockRepo.Setup(repo => repo.GetAll<PerformanceLevelDto>(0, 0))
                .Returns(GetTestData());
            var controller = new PerformanceLevelController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            Assert.NotNull(viewResult);

        }

    }


}
