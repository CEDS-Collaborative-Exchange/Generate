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

    public class PersonControllerShould
    {
        private List<Person> GetTestData()
        {
            var data = new List<Person>();
            data.Add(new Person()
            {
                PersonId = 1,
                PersonDetail = new List<PersonDetail>()
                {
                    new PersonDetail()
                    {
                        FirstName = "John",
                        LastName = "Doe"
                    }
                }
            });
            data.Add(new Person()
            {
                PersonId = 2,
                PersonDetail = new List<PersonDetail>()
                {
                    new PersonDetail()
                    {
                        FirstName = "Jane",
                        LastName = "Doe"
                    }
                }

            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IIDSRepository>();
            mockRepo.Setup(repo => repo.GetAll<Person>(0, 50))
                .Returns(GetTestData());
            var controller = new PersonController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<Person>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
