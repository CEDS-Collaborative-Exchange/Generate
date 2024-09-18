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

    public class ToggleAssessmentControllerShould
    {
        private List<ToggleAssessment> GetTestData()
        {
            var data = new List<ToggleAssessment>();
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 1,
                AssessmentName = "Test",
                AssessmentTypeCode = "TST"

            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 2,
                AssessmentName = "Test2",
                AssessmentTypeCode = "TST2"

            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleAssessment>(0, 0))
                .Returns(GetTestData());
            var controller = new ToggleAssessmentController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleAssessment>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

        [Fact]
        public void Post()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleAssessment>(0, 0))
                .Returns(testData);
            var controller = new ToggleAssessmentController(mockRepo.Object);
                
            // Act
            controller.Post(testData.FirstOrDefault());

            // Assert

            // No need to assert conditions -- we are just making sure that no exception occurs

        }
               

        [Fact]
        public void Put()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleAssessment>(0, 0))
                .Returns(testData);
            var controller = new ToggleAssessmentController(mockRepo.Object);

            // Act
            controller.Put(testData.FirstOrDefault());


            // Assert

            // No need to assert conditions -- we are just making sure that no exception occurs

        }


        [Fact]
        public void Delete()
        {
            // Arrange
            var testData = GetTestData();
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleAssessment>(0, 0))
                .Returns(testData);
            var controller = new ToggleAssessmentController(mockRepo.Object);

            // Act
            controller.Delete(testData.FirstOrDefault().ToggleAssessmentId);

            // Assert

            // No need to assert conditions -- we are just making sure that no exception occurs

        }

        
    }


}
