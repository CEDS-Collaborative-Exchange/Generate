using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Authentication;

namespace generate.web.Security
{
    public class SignInManager : SignInManager<ApplicationUser>
    {
        private IHttpContextAccessor _ContextAccessor { get; set; }
        //MER Changed to UserManager...now it can be embedded
        public SignInManager(UserManager<ApplicationUser> userManager,
                                IHttpContextAccessor contextAccessor,
                                IUserClaimsPrincipalFactory<ApplicationUser> claimsFactory,
                                IOptions<IdentityOptions> optionsAccessor = null)
                : base(userManager, contextAccessor, claimsFactory, optionsAccessor, null, null, null)
        {
            _ContextAccessor = contextAccessor;
        }

        public async override Task SignOutAsync()
        {
            await _ContextAccessor.HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        }
    }
}
