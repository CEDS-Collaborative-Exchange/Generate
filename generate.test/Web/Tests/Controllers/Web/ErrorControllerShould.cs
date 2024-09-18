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
    public class AccountControllerShould
    {
        [Fact]
        public void Index()
        {
            // Arrange
            var controller = new AccountController();

            // Act
            var result = controller.Login();

            // Assert
            Assert.IsType<EmptyResult>(result);
        }
    }
}
