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

    public class ToggleQuestionControllerShould
    {
        private List<ToggleQuestion> GetTestData()
        {
            var data = new List<ToggleQuestion>();
            data.Add(new ToggleQuestion()
            {
                 ToggleQuestionId = 1,
                 QuestionText = "What day is it?",
                 QuestionSequence = 1,
                 ToggleSection = new ToggleSection()
                 {
                     ToggleSectionId = 1,
                     SectionName = "Section 1",
                     SectionTitle = "Section 1",
                     SectionSequence = 1
                 }
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 2,
                QuestionText = "What month is it?",
                QuestionSequence = 2,
                ToggleSection = new ToggleSection()
                {
                    ToggleSectionId = 1,
                    SectionName = "Section 1",
                    SectionTitle = "Section 1",
                    SectionSequence = 1
                }
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleQuestion>(0, 0, t => t.ToggleSection, t => t.ToggleQuestionType))
                .Returns(GetTestData());
            var controller = new ToggleQuestionController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleQuestion>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
