using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Web
{
    // Reached as a redirect target during/after sign-out, when the session is already gone -
    // must stay reachable under the now-global default-authenticated-user policy.
    [AllowAnonymous]
    public class AccountController : Controller
    {
        // Needed to handle logout
        public IActionResult Login()
        {
            return new EmptyResult();
        }
    }
}
