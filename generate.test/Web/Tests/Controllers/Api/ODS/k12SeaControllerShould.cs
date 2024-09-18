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

    public class K12SeaControllerShould
    {
        private List<K12sea> GetTestData()
        {
            var data = new List<K12sea>();
            data.Add(new K12sea()
            {
                OrganizationId = 1,
                RefStateAnsicodeId = 1
            });
            return data;
        }


        private RefState GetRefState()
        {
            return new RefState()
            {
                RefStateId = 1,
                Code = "CO",
                Description = "Colorado"
            };
        }


        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IIDSRepository>();
            mockRepo.Setup(repo => repo.GetAll<K12sea>(0, 1))
                .Returns(GetTestData());
            var controller = new k12SeaController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<K12sea>(viewResult.Value);
            Assert.NotNull(model);

        }

        [Fact]
        public void GetState()
        {

            // Arrange
            var mockRepo = new Mock<IIDSRepository>();
            mockRepo.Setup(repo => repo.GetAll<K12sea>(0, 1))
                .Returns(GetTestData());
            mockRepo.Setup(repo => repo.GetById<RefState>(1))
                .Returns(GetRefState());

            var controller = new k12SeaController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<K12sea>(viewResult.Value);
            Assert.NotNull(model);

        }

    }


}
