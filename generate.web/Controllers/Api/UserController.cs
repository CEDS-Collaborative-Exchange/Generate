using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using generate.web.Security;
using generate.core.Models.App;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net;
using Microsoft.Extensions.Logging;
using generate.core.ViewModels.App;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.MicrosoftAccount;
using System.Configuration;
using Microsoft.Extensions.Configuration;
using System.Runtime.Versioning;

namespace generate.web.Controllers.Api
{

    [Route("api/users")]
    [Authorize]
    [ApiController]
    [SupportedOSPlatform("windows")]
    public class UserController : Controller
    {
        public UserManager<ApplicationUser> UserManager { get; private set; }
        public SignInManager<ApplicationUser> SignInManager { get; private set; }

        private readonly ILogger _logger;
        //private IConfiguration _configuration;

        public UserController(IHttpContextAccessor httpContextAccessor, UserManager<ApplicationUser> userManager, ILogger<UserController> logger, ILogger<ApplicationClaimsPrincipleFactory> principleFactoryLogger, IConfiguration configuration)
        {
            //MER changed to just "userManager"...because now it can be a different type...so just use what was passed in?
            SignInManager = new SignInManager(userManager, httpContextAccessor, new ApplicationClaimsPrincipleFactory(principleFactoryLogger));
            UserManager = userManager;
            _logger = logger;
        }


        [HttpPost("login")]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody]LoginViewModel model)
        {
            //if ("OAUTH".Equals(_configuration.GetSection("appSettings").GetValue<string>("AppSettings")))
            //{
            //    var authenticationProperties = new AuthenticationProperties { RedirectUri = Url.Action("Index", "Home") };
            //    return await Task.FromResult(Challenge(authenticationProperties, MicrosoftAccountDefaults.AuthenticationScheme));
            //}
            //else
            //{

                // This doesn't count login failures towards account lockout
                // To enable password failures to trigger account lockout, set shouldLockout: true
                var user = new ApplicationUser { Id = model.Username, UserName = model.Username, Password = model.Password };

                // This is where we do the LDAP Authentication
                //var result = await SignInManager.PasswordSignInAsync(user,model.Password, false, true);
                try
                {

                    _logger.LogInformation("Logging User:  " + model.Username);

                    bool logged = await UserManager.CheckPasswordAsync(user, model.Password);

                    // If user authenticates, we the do the Authorization (set Claims)
                    if (logged)
                    {
                        // Query LDAP to get the user
                        user = await UserManager.FindByIdAsync(user.Id);

                        user.Password = model.Password;
                        // Set user roles(by mapping LDAP groups to application defined roles)
                        var roles = UserManager.GetRolesAsync(user).Result;

                        if (roles != null)
                        {
                            user.Roles = roles.ToList();
                        }

                        var claimsPrincipal = await SignInManager.CreateUserPrincipalAsync(user);

                        if (claimsPrincipal != null && claimsPrincipal.Identity != null)
                        {
                            _logger.LogInformation("Setting User Claims for : " + claimsPrincipal.Identity.Name);
                            // Set the claims to the user 
                            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, claimsPrincipal);
                            return Json(user);
                        }
                        else
                        {
                            throw new UnauthorizedAccessException("Insufficient Privileges.");
                        }
                    }
                    else
                    {
                        throw new UnauthorizedAccessException("Invalid Username or Password.");
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogInformation(ex.Message);
                    _logger.LogInformation(ex.StackTrace);
                    return new BadRequestObjectResult(new { message = ex.Message });
                }
            //}

        }

        // POST: /Account/LogOff
        [HttpPost("logoff")]
        public void LogOff()
        {

            //if ("OAUTH".Equals(_configuration.GetSection("appSettings").GetValue<string>("AppSettings")))
            //{
            //    var authenticationProperties = new AuthenticationProperties { RedirectUri = Url.Action("Index", "Home") };
            //    HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            //    SignOut(authenticationProperties, MicrosoftAccountDefaults.AuthenticationScheme);
            //}
            //else
            //{
                SignInManager.SignOutAsync();
           // }
        }
    }
}
