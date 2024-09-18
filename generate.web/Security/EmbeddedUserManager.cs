using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.Extensions.Logging;
using System.DirectoryServices.AccountManagement;
using System.Configuration;
using Microsoft.Extensions.Configuration;

namespace generate.web.Security.Embeddable
{
    public class EmbeddedUserManager : UserManager<ApplicationUser>
    {

        private string _adminGroup;
        private string _reviewerGroup;
        private readonly ILogger _logger;


        private String _adminUserName;
        private String _adminUserPassword;
        private String _reviewerUserName;
        private String _reviewerUserPassword;


        public EmbeddedUserManager(
            IUserStore<ApplicationUser> store,
            IOptions<IdentityOptions> optionsAccessor,
            IPasswordHasher<ApplicationUser> passwordHasher,
            IEnumerable<IUserValidator<ApplicationUser>> userValidators,
            IEnumerable<IPasswordValidator<ApplicationUser>> passwordValidators,
            ILookupNormalizer keyNormalizer,
            IdentityErrorDescriber errors,
            IServiceProvider services,
            ILogger<ApplicationUserManager> logger,
            IOptions<AppSettings> appSettings,
            IConfiguration configuration) :
            base(store, optionsAccessor, passwordHasher, userValidators, passwordValidators, keyNormalizer, errors, services, logger)
        {
            _adminUserName = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedAdminUserName");
            _adminUserPassword = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedAdminPassword");
            _reviewerUserName = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedReviewerUserName");
            _reviewerUserPassword = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedReviewerPassword");
            _logger = logger;

            _adminGroup = configuration.GetSection("AppSettings").GetValue<string>("AdminGroupName");
            _logger.LogError("_adminGroup from config: " + _adminGroup);
            _reviewerGroup = configuration.GetSection("AppSettings").GetValue<string>("ReviewerGroupName");
        }


        public async override Task<bool> CheckPasswordAsync(ApplicationUser user, string password)
        {
            _logger.LogInformation("Logging in user: " + user + " in Embedded");
            return await Task.Run(() => IsAuthenticated(user.UserName, password));
        }

        public async override Task<IList<string>> GetRolesAsync(ApplicationUser user)
        {
            var roles = GetUserMyRoles(user.UserName, user.Password);
            return await Task.Run(() => roles);
        }

        // Check LDAP if user is in a GROUP
        private List<string> GetUserMyRoles(string username, string password)
        {
            var myRoles = new List<string>();

            try
            {
                _logger.LogInformation("Check if user belongs to a valid group");
                _logger.LogInformation("username: " + username);
                
                if (username.Equals(_adminUserName) && password.Equals(_adminUserPassword))
                {
                    _logger.LogError(" - we have an admin");
                    myRoles.Add(GetRoleFromGroup(_adminGroup));
                }
                if (username.Equals(_reviewerUserName) && password.Equals(_reviewerUserPassword))
                {
                    _logger.LogError(" - we have a reviewer");
                    myRoles.Add(GetRoleFromGroup(_reviewerGroup));
                }
                
                _logger.LogError("myRoles: " + myRoles);
                _logger.LogError("...size: " + myRoles.Count);
                _logger.LogError("...first: " + myRoles.First());
                return myRoles;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ApplicationUserManager.GetUserMyRoles");
                return new List<string>();
            }
        }

        // Check LDAP if user is in a GROUP
        private bool IsUserInGroup(PrincipalContext context, string user, string group)
        {
            bool found = false;
            _logger.LogError("IsUserInGroup: user: " + user + " group: " + group);
            try
            {
               
                if((user.Equals(_adminUserName) && group.Equals("Administrators")) ||
                    (user.Equals(_reviewerUserName) && group.Equals("Reviewers"))){
                    found = true;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ApplicationUserManager.IsUserInGroup Error");
                found = false;
            }

            return found;
        }

        // Map LDAP Group to application Role
        private string GetRoleFromGroup(string group)
        {
            _logger.LogError("GetRoleForGroup: " + group);
            _logger.LogError("hopefully matches: " + _adminGroup);
            if (group == _reviewerGroup)
                return "REVIEWER";

            if (group == _adminGroup)
                return "ADMINISTRATOR";

            else throw new Exception("Undefined LDAP Group");
        }

        // Validate username / password in LDAP

        private bool IsAuthenticated(string username, string pwd)
        {
            try
            {   
                bool isAuthenticated = false;

                if ((username.Equals(_adminUserName) && pwd.Equals(_adminUserPassword)) ||
                    (username.Equals(_reviewerUserName) && pwd.Equals(_reviewerUserPassword)))
                {
                    isAuthenticated = true;
                }


                return isAuthenticated;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, ex.Message);
                throw new Exception("Active Directory not found.");
            }
        }

       
        }



}
