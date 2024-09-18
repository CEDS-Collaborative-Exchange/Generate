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

    public class ToggleQuestionOptionControllerShould
    {
        private List<ToggleQuestionOption> GetTestData()
        {
            var data = new List<ToggleQuestionOption>();
            data.Add(new ToggleQuestionOption()
            {
                ToggleQuestionOptionId = 1,
                OptionText = "Option 1",
                OptionSequence = 1
            });
            data.Add(new ToggleQuestionOption()
            {
                ToggleQuestionOptionId = 2,
                OptionText = "Option 2",
                OptionSequence = 2
            });

            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleQuestionOption>(0, 0))
                .Returns(GetTestData());
            var controller = new ToggleQuestionOptionController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleQuestionOption>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
