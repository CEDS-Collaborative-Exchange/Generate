using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Web
{
    // The error page must stay reachable for unauthenticated/session-expired requests, or the
    // now-global default-authenticated-user policy would turn every error into a login redirect.
    [AllowAnonymous]
    public class ErrorController : Controller
    {
        // GET: /<controller>/
        public IActionResult Index()
        {
            return View();
        }
    }
}
