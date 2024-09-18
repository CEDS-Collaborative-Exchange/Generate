using generate.web.Controllers.Web;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Web.Tests.Controllers.Web
{
    public class ErrorControllerShould
    {
        [Fact]
        public void Index()
        {
            // Arrange
            var controller = new ErrorController();
            
            // Act
            var result = controller.Index();

            // Assert
            Assert.IsType<ViewResult>(result);
        }
    }
}
