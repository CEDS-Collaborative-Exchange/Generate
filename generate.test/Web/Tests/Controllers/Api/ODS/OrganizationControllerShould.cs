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
using generate.core.Interfaces.Repositories.RDS;
using generate.infrastructure.Repositories.RDS;
using Microsoft.Extensions.Logging;

namespace generate.test.Web.Tests.Controllers.Api.ODS
{

    public class OrganizationControllerShould
    {
        private List<OrganizationDetail> GetTestData()
        {
            var data = new List<OrganizationDetail>();
            data.Add(new OrganizationDetail()
            {
                Name = "Test 1"
            });
            data.Add(new OrganizationDetail()
            {
                Name = "Test 2"
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IIDSRepository>();
            mockRepo.Setup(repo => repo.GetAll<OrganizationDetail>(0, 50))
                .Returns(GetTestData());

            var mockOrganization = new Mock<IFactOrganizationCountRepository>();

            var controller = new OrganizationController(mockRepo.Object, mockOrganization.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<OrganizationDetail>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
