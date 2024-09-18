using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.PlatformAbstractions;
using Microsoft.AspNetCore.Builder;
using generate.core.Config;
using Microsoft.Extensions.Logging;
using System.DirectoryServices.AccountManagement;
using System.Configuration;
using Microsoft.Extensions.Configuration;

namespace generate.web.Security
{
    public class ApplicationUserManager : UserManager<ApplicationUser>
    {

        private readonly IOptions<AppSettings> _appSettings;
        private string _ADContainer;
        private string _adLoginDomain;
        private string _UserContainer;
        private string _adminGroup;
        private string _reviewerGroup;
        private readonly ILogger _logger;

        private string _ADDomain;
        private string _authenticationType;
        private bool _isSSLEnabled;
        private ContextType _contextType;


        public ApplicationUserManager(
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
            _appSettings = appSettings;
            _logger = logger;

            _adLoginDomain = configuration.GetSection("appSettings").GetValue<string>("ADLoginDomain");
            if (_adLoginDomain != null && _adLoginDomain.Length > 0)
            {
                _authenticationType = "AD";
                _contextType = ContextType.Domain;
            }
            else
            {
                _authenticationType = "ADLDS";
                _contextType = ContextType.ApplicationDirectory;
            }

            _ADDomain = configuration.GetSection("appSettings").GetValue<string>("ADDomain") + ":" + configuration.GetSection("appSettings").GetValue<string>("ADPort");

            if (_appSettings.Value.Environment.ToLower() == "development")
            {
                _ADDomain = Environment.MachineName + ":" + configuration.GetSection("appSettings").GetValue<string>("ADPort");
            }


            _ADContainer = configuration.GetSection("appSettings").GetValue<string>("ADContainer");
            _UserContainer = configuration.GetSection("appSettings").GetValue<string>("UserContainer");

            _adminGroup = configuration.GetSection("appSettings").GetValue<string>("AdminGroupName");
            _reviewerGroup = configuration.GetSection("appSettings").GetValue<string>("ReviewerGroupName");
            _isSSLEnabled = configuration.GetSection("appSettings").GetValue<bool>("IsSSLEnabled");
         


        }


        public async override Task<bool> CheckPasswordAsync(ApplicationUser user, string password)
        {
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
                if (_authenticationType == "AD")
                {
                    if (_isSSLEnabled) {

                        using (var context = new PrincipalContext(ContextType.Domain, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate, username, password))
                        {
                            if (IsUserInGroup(context, username, _reviewerGroup))
                                myRoles.Add(GetRoleFromGroup(_reviewerGroup));

                            if (IsUserInGroup(context, username, _adminGroup))
                                myRoles.Add(GetRoleFromGroup(_adminGroup));

                        }

                    }
                    else
                    {
                        using (var context = new PrincipalContext(ContextType.Domain, _ADDomain, _ADContainer, username, password))
                        {
                            if (IsUserInGroup(context, username, _reviewerGroup))
                                myRoles.Add(GetRoleFromGroup(_reviewerGroup));

                            if (IsUserInGroup(context, username, _adminGroup))
                                myRoles.Add(GetRoleFromGroup(_adminGroup));

                        }
                    }
                }
                else
                {
                    if (_isSSLEnabled)
                    {
                        using (var context = new PrincipalContext(ContextType.ApplicationDirectory, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate))
                        {
                            if (IsUserInGroup(context, username, _reviewerGroup))
                                myRoles.Add(GetRoleFromGroup(_reviewerGroup));

                            if (IsUserInGroup(context, username, _adminGroup))
                                myRoles.Add(GetRoleFromGroup(_adminGroup));

                        }
                    }
                    else
                    {
                        using (var context = new PrincipalContext(ContextType.ApplicationDirectory, _ADDomain, _ADContainer))
                        {
                            if (IsUserInGroup(context, username, _reviewerGroup))
                                myRoles.Add(GetRoleFromGroup(_reviewerGroup));

                            if (IsUserInGroup(context, username, _adminGroup))
                                myRoles.Add(GetRoleFromGroup(_adminGroup));

                        }
                    }

                }
                _logger.LogInformation("Number of User roles found: " + myRoles.Count);
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
            try
            {
                UserPrincipal u = null;

                

                if (_isSSLEnabled)
                {
                    // In case the app pool user doesn't have access to Active directory, pass in user credentials
                    // using (var context = new PrincipalContext(_contextType, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate, username, password))

                    string _userName = user;
                    if (_adLoginDomain != null)
                    {
                        _userName = _adLoginDomain.Length > 0 ? _adLoginDomain + "\\" + user.ToLower().Replace(_adLoginDomain.ToLower() + "\\", "") : user;
                    }

                    if (_authenticationType == "AD")
                    {

                            using (var userContext = new PrincipalContext(_contextType, _ADDomain, _UserContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate))
                            {
                                GroupPrincipal grp = GroupPrincipal.FindByIdentity(context, group);
                                if (grp != null)
                                {
                                    u = UserPrincipal.FindByIdentity(userContext, IdentityType.SamAccountName, _userName);
                                    found = grp.GetMembers(true).Contains(u);
                                    if (found) { _logger.LogInformation("User found in group : " + group); }
                                }
                            }

                    }
                    else
                    {
                            using (var userContext = new PrincipalContext(_contextType, _ADDomain, _UserContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate))
                            {
                                GroupPrincipal grp = GroupPrincipal.FindByIdentity(context, group);
                                if (grp != null)
                                {
                                    u = UserPrincipal.FindByIdentity(context, IdentityType.UserPrincipalName, _userName);
                                    found = grp.GetMembers(true).Contains(u);
                                    if (found) { _logger.LogInformation("User found in group : " + group); }
                                }
                            }

                    }

                }
                else
                {

                    if (_authenticationType == "AD")
                    {
                        _logger.LogInformation("User Container : " + _UserContainer);
                        using (var userContext = new PrincipalContext(_contextType, _ADDomain, _UserContainer))
                        {
                                _logger.LogInformation("User Context Created : ");
                                GroupPrincipal grp = GroupPrincipal.FindByIdentity(context, group);
                                if (grp != null)
                                {
                                    _logger.LogInformation("Group Found : " + group);
                                    u = UserPrincipal.FindByIdentity(userContext, IdentityType.SamAccountName, user);
                                    found = grp.GetMembers(true).Contains(u);
                                    if (found) { _logger.LogInformation("User found in group : " + group); }
                                }
                        }

                    }
                    else
                    {
                            GroupPrincipal grp = GroupPrincipal.FindByIdentity(context, group);
                            if (grp != null)
                            {
                                u = UserPrincipal.FindByIdentity(context, IdentityType.UserPrincipalName, user);
                                found = grp.GetMembers(true).Contains(u);
                                if (found) { _logger.LogInformation("User found in group : " + group); }
                            }

                    }

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

                _logger.LogInformation("User Name : " + username);
                string _username = username;
                if (_adLoginDomain != null)
                {
                    _username = _adLoginDomain.Length > 0 ? _adLoginDomain + "\\" + username.ToLower().Replace(_adLoginDomain.ToLower() + "\\", "") : username;
                }
                _logger.LogInformation("User Name and Domain : " + _username);
                _logger.LogInformation("ADDomain: " + _ADDomain);
                _logger.LogInformation("ADContainer : " + _ADContainer);
                _logger.LogInformation("User Container : " + _UserContainer);
                _logger.LogInformation("Admin Group : " + _adminGroup);
                _logger.LogInformation("Reviewer Group : " + _reviewerGroup);

                _logger.LogInformation("Beginning to authenticate against active directory in : " + _appSettings.Value.Environment.ToLower());
                if (_authenticationType == "AD")
                {
                    if (_ADDomain == "")
                    {
                        if (_ADContainer == "")
                        {
                            using (var context = new PrincipalContext(ContextType.Domain, null))
                            {
                                isAuthenticated = context.ValidateCredentials(_username, pwd, ContextOptions.SimpleBind);
                            }
                        }
                        else
                        {
                            using (var context = new PrincipalContext(ContextType.Domain, null, _ADContainer))
                            {
                                isAuthenticated = context.ValidateCredentials(_username, pwd, ContextOptions.SimpleBind);
                            }
                        }
                    }
                    else
                    {
                        if (_isSSLEnabled)
                        {
                            using (var context = new PrincipalContext(ContextType.Domain, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.SimpleBind))
                            {
                                isAuthenticated = context.ValidateCredentials(_username, pwd, ContextOptions.SecureSocketLayer | ContextOptions.SimpleBind);
                            }
                        }
                        else
                        {
                            using (var context = new PrincipalContext(ContextType.Domain, _ADDomain, _ADContainer))
                            {
                                isAuthenticated = context.ValidateCredentials(_username, pwd, ContextOptions.SimpleBind);
                            }
                        }
                    }

                }
                else
                {
                    if (_isSSLEnabled)
                    {
                        using (var context = new PrincipalContext(ContextType.ApplicationDirectory, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.SimpleBind))
                        {
                            isAuthenticated = context.ValidateCredentials(username, pwd, ContextOptions.SecureSocketLayer | ContextOptions.SimpleBind);
                        }
                    }
                    else
                    {
                        using (var context = new PrincipalContext(ContextType.ApplicationDirectory, _ADDomain, _ADContainer))
                        {
                            isAuthenticated = context.ValidateCredentials(username, pwd, ContextOptions.SimpleBind);
                        }
                    }
                }
                if (isAuthenticated) { _logger.LogInformation("Authentication completed and the user authentication was successful."); }
                else { _logger.LogInformation("Authentication completed and the user authentication was unsuccessful."); }

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
