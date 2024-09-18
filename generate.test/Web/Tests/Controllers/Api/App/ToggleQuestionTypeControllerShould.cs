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

    public class ToggleQuestionTypeControllerShould
    {
        private List<ToggleQuestionType> GetTestData()
        {
            var data = new List<ToggleQuestionType>();
            data.Add(new ToggleQuestionType()
            {
                ToggleQuestionTypeId = 1,
                IsMultiOption = false,
                ToggleQuestionTypeCode = "TYPE1",
                ToggleQuestionTypeName = "Type 1"
            });
            data.Add(new ToggleQuestionType()
            {
                ToggleQuestionTypeId = 2,
                IsMultiOption = false,
                ToggleQuestionTypeCode = "TYPE2",
                ToggleQuestionTypeName = "Type 2"
            });

            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleQuestionType>(0, 0))
                .Returns(GetTestData());
            var controller = new ToggleQuestionTypeController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleQuestionType>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
