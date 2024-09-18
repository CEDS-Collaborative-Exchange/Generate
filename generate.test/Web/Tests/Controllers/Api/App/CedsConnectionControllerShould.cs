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

    public class CedsConnectionControllerShould
    {
        private List<CedsConnection> GetTestData()
        {
            var data = new List<CedsConnection>();
            data.Add(new CedsConnection()
            {
                 CedsConnectionId = 1,
                 CedsConnectionName = "C002",
                 CedsConnectionDescription = "C002 File Spec",
                 CedsConnectionSource = "EDFacts"
            });
            data.Add(new CedsConnection()
            {
                CedsConnectionId = 2,
                CedsConnectionName = "C029",
                CedsConnectionDescription = "C029 File Spec",
                CedsConnectionSource = "EDFacts"
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<CedsConnection>(0, 50))
                .Returns(GetTestData());
            var controller = new CedsConnectionController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<CedsConnection>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
