using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Web
{
    public class AccountController : Controller
    {
        // Needed to handle logout
        public IActionResult Login()
        {
            return new EmptyResult();
        }
    }
}
