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

    public class ToggleResponseControllerShould
    {
        private List<ToggleResponse> GetTestData()
        {
            var data = new List<ToggleResponse>();
            data.Add(new ToggleResponse()
            {
                ToggleResponseId = 1,
                ToggleQuestion = new ToggleQuestion()
                {
                    ToggleQuestionId = 1,
                    QuestionText = "What is the day?"
                }
            });
            data.Add(new ToggleResponse()
            {
                ToggleResponseId = 1,
                ToggleQuestion = new ToggleQuestion()
                {
                    ToggleQuestionId = 1,
                    QuestionText = "What is the day?"
                }
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(GetTestData());
            var controller = new ToggleResponseController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleResponse>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

        [Fact]
        public void SaveResponses()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);
            mockRepo.Setup(repo => repo.CreateRange<ToggleResponse>(testData))
                .Returns(testData)
                .Verifiable();

            // Act
            var result = controller.SaveResponses(testData.ToArray());

            // Assert
            Assert.IsType<OkResult>(result);
            mockRepo.Verify();
        }


        [Fact]
        public void SaveResponses_Exception()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);

            mockRepo.Setup(repo => repo.CreateRange<ToggleResponse>(testData))
                .Throws(new InvalidOperationException());

            // Act
            var result = controller.SaveResponses(testData.ToArray());

            // Assert
            Assert.IsType<BadRequestObjectResult>(result);
        }



        [Fact]
        public void UpdateResponses()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);
            mockRepo.Setup(repo => repo.UpdateRange<ToggleResponse>(testData))
                .Verifiable();

            // Act
            var result = controller.UpdateResponses(testData.ToArray());

            // Assert
            Assert.IsType<OkResult>(result);
            mockRepo.Verify();
        }


        [Fact]
        public void UpdateResponses_Exception()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);
            mockRepo.Setup(repo => repo.UpdateRange<ToggleResponse>(testData))
                .Throws(new InvalidOperationException());

            // Act
            var result = controller.UpdateResponses(testData.ToArray());

            // Assert
            Assert.IsType<BadRequestObjectResult>(result);
        }


        [Fact]
        public void DeleteResponses()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);
            mockRepo.Setup(repo => repo.DeleteRange<ToggleResponse>(testData))
                .Verifiable();

            // Act
            var result = controller.DeleteResponses(testData.ToArray());

            // Assert
            Assert.IsType<OkResult>(result);
            mockRepo.Verify();
        }



        [Fact]
        public void DeleteResponses_Exception()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleResponse>(0, 0))
                .Returns(testData);
            var controller = new ToggleResponseController(mockRepo.Object);
            mockRepo.Setup(repo => repo.DeleteRange<ToggleResponse>(testData))
                .Throws(new InvalidOperationException());

            // Act
            var result = controller.DeleteResponses(testData.ToArray());

            // Assert
            Assert.IsType<BadRequestObjectResult>(result);
        }

    }


}
