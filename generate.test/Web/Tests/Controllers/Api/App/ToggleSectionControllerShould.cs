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

    public class PersonControllerShould
    {
        private List<ToggleSection> GetTestData()
        {
            var data = new List<ToggleSection>();
            data.Add(new ToggleSection()
            {
                ToggleSectionId = 1,
                SectionName = "Section 1",
                SectionTitle = "Section 1",
                ToggleSectionType = new ToggleSectionType()
                {
                    ToggleSectionTypeId = 1,
                    SectionTypeName = "Section",
                    SectionTypeSequence = 1
                },
                SectionSequence = 1
            });
            data.Add(new ToggleSection()
            {
                ToggleSectionId = 2,
                SectionName = "Section 2",
                SectionTitle = "Section 2",
                ToggleSectionType = new ToggleSectionType()
                {
                    ToggleSectionTypeId = 1,
                    SectionTypeName = "Section",
                    SectionTypeSequence = 1
                },
                SectionSequence = 2
            });
            return data;
        }

        [Fact]
        public void Get()
        {

            // Arrange
            var mockRepo = new Mock<IAppRepository>();
            mockRepo.Setup(repo => repo.GetAll<ToggleSection>(0, 0, s => s.ToggleSectionType))
                .Returns(GetTestData());
            var controller = new ToggleSectionController(mockRepo.Object);

            // Act
            var result = controller.Get();

            // Assert
            var viewResult = Assert.IsType<JsonResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<ToggleSection>>(viewResult.Value);
            Assert.NotEmpty(model);
            Assert.Equal(2, model.Count());

        }

    }


}
