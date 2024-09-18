using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;

namespace generate.web.Security
{
    public class ApplicationClaimsPrincipleFactory : IUserClaimsPrincipalFactory<ApplicationUser>
    {
        private readonly ILogger _logger;

        public ApplicationClaimsPrincipleFactory(ILogger<ApplicationClaimsPrincipleFactory> logger)
        {
           _logger = logger;
        }
        public Task<ClaimsPrincipal> CreateAsync(ApplicationUser user)
        {
            return Task.Factory.StartNew(() =>
            {
                _logger.LogInformation("Begin Checking User Claims");

                if (user != null && user.Roles != null && user.Roles.Count > 0)
                {
                    _logger.LogInformation("Checking User Claims");
                    _logger.LogInformation("User Id is : " + user.Id);
                    _logger.LogInformation("User DisplayName is : " + user.DisplayName);
                    _logger.LogInformation("User FirstName is : " + user.FirstName);

                    // set user details in the claims
                    var claims = new List<Claim> {
                        new Claim(ClaimTypes.NameIdentifier, user.Id),
                        new Claim(ClaimTypes.Name, user.DisplayName),
                        new Claim(ClaimTypes.GivenName, user.FirstName)
                    };

                    _logger.LogInformation("User Role Claims found : " + user.Roles.Count.ToString());

                    // set user roles in the claims
                    foreach (var role in user.Roles)
                    {
                        claims.Add(new Claim(ClaimTypes.Role, role));
                    }

                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var principle = new ClaimsPrincipal(identity);

                    _logger.LogInformation("Assigning User Claims Completed.");

                    return principle;
                }
                else
                    return new ClaimsPrincipal();
            });
        }
    }
}
