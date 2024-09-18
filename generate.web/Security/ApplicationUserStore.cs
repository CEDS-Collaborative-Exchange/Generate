using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.PlatformAbstractions;
using Microsoft.AspNetCore.Hosting;
using generate.core.Config;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Logging;

using System.DirectoryServices.AccountManagement;
using System.Configuration;
using Microsoft.Extensions.Configuration;

namespace generate.web.Security
{
    public class ApplicationUserStore<T> : IUserStore<ApplicationUser>, IUserPasswordStore<ApplicationUser>
    {
        // Search and create a user from Active Directory

        private IOptions<AppSettings> _appSettings;
        private readonly ILogger _logger;
        //private string _UserContainer;

        private string _ADDomain;
        private string _ADLoginDomain;
        private string _authenticationType;
        private string _ADContainer;
        private bool _isSSLEnabled; 
        private ContextType _contextType;

        public ApplicationUserStore(IOptions<AppSettings> appSettings, ILogger<ApplicationUserStore<T>> logger, IConfiguration configuration) : base()
        {
            _appSettings = appSettings;
            _logger = logger;

            _ADLoginDomain = configuration.GetSection("appSettings").GetValue<string>("ADLoginDomain");
            if (_ADLoginDomain.Length > 0)
            {
                _authenticationType = "AD";
            } else
            {
                _authenticationType = "ADLDS";
            }

            _ADDomain = configuration.GetSection("appSettings").GetValue<string>("ADDomain") + ":" + configuration.GetSection("appSettings").GetValue<string>("ADPort");

            if (_appSettings.Value.Environment.ToLower() == "development")
            {
                _ADDomain = Environment.MachineName + ":" + configuration.GetSection("appSettings").GetValue<string>("ADPort");
            }

            _contextType = ContextType.ApplicationDirectory;
            _ADContainer = configuration.GetSection("appSettings").GetValue<string>("ADContainer");

            if (_authenticationType == "AD")
            {
                _ADContainer = configuration.GetSection("appSettings").GetValue<string>("UserContainer");
                _contextType = ContextType.Domain;
            }

            _isSSLEnabled = Convert.ToBoolean(configuration.GetSection("appSettings").GetValue<string>("IsSSLEnabled"));
        }
        public async Task<ApplicationUser> FindByIdAsync(string userId, CancellationToken cancellationToken)
        {

            if (userId == null)
                return await Task.Run(() => new ApplicationUser()
                {
                    UserName = "Anonymous",
                    Id = "Anonymous"
                });

            _logger.LogInformation("Searching in the AD container: " + _ADContainer);

            if (_isSSLEnabled) {

                // In case the app pool user doesn't have access to Active directory, pass in user credentials
                // using (var context = new PrincipalContext(_contextType, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate, username, password))
                string _userName = _ADLoginDomain.Length > 0 ? _ADLoginDomain + "\\" + userId.Replace(_ADLoginDomain + "\\", "") : userId;

                using (var context = new PrincipalContext(_contextType, _ADDomain, _ADContainer, ContextOptions.SecureSocketLayer | ContextOptions.Negotiate))
                {
                    try
                    {
                        _logger.LogInformation("Searching for user: " + _userName);
                        _logger.LogInformation("Searching with Authentication Type: " + _authenticationType);
                        _logger.LogInformation("Searching with context: " + _contextType.ToString());
                        _logger.LogInformation("Searching domain: " + _ADDomain);
                        _logger.LogInformation("Searching server: " + context.ConnectedServer);


                        var directoryUser = UserPrincipal.FindByIdentity(context, IdentityType.SamAccountName, _userName);

                        if (directoryUser != null)
                        {
                            _logger.LogInformation("User Found in Active Directory.");

                            return await Task.Run(() => new ApplicationUser()
                            {
                                Id = userId,
                                UserName = userId,
                                FirstName = directoryUser.GivenName,
                                LastName = directoryUser.Surname,
                                DisplayName = directoryUser.DisplayName,
                                isLocked = directoryUser.IsAccountLockedOut()
                            }
                            );
                        }
                        else
                        {
                            return await Task.Run(() => new ApplicationUser()
                            {
                                UserName = "Anonymous",
                                Id = "Anonymous"
                            });

                        }

                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex.Message);
                        return await Task.Run(() => new ApplicationUser()
                        {
                            UserName = "Anonymous",
                            Id = "Anonymous"
                        });
                    }
                }
            }
            else
            {
                // In case the app pool user doesn't have access to Active directory, pass in user credentials
                // using (var context = new PrincipalContext(_contextType, _ADDomain, _ADContainer, username, password))
                string _userName = _ADLoginDomain.Length > 0 ? _ADLoginDomain + "\\" + userId.Replace(_ADLoginDomain + "\\", "") : userId;

                PrincipalContext context = new PrincipalContext(_contextType, _ADDomain, _ADContainer);
                try
                {
                    _logger.LogInformation("Searching in the User Context: " + _userName);

                    var directoryUser = UserPrincipal.FindByIdentity(context, _userName);

                    if (directoryUser != null)
                    {
                        _logger.LogInformation("User Found in Active Directory.");

                        return await Task.Run(() => new ApplicationUser()
                        {
                            Id = userId,
                            UserName = userId,
                            FirstName = directoryUser.GivenName,
                            LastName = directoryUser.Surname,
                            DisplayName = directoryUser.DisplayName,
                            isLocked = directoryUser.IsAccountLockedOut()
                        }
                        );
                    }
                    else
                    {
                        _logger.LogInformation("User Not Found in Active Directory.");

                        return await Task.Run(() => new ApplicationUser()
                        {
                            UserName = "Anonymous",
                            Id = "Anonymous"
                        });

                    }

                }
                catch (Exception ex)
                {
                    _logger.LogError(ex.Message);
                    return await Task.Run(() => new ApplicationUser()
                    {
                        UserName = "Anonymous",
                        Id = "Anonymous"
                    });
                }

                context.Dispose();
            }
        }

        public void Dispose()
        {

        }

#region Not Implemented

        public Task<string> GetUserIdAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            return Task.Run(() => user.Id);
                        
        }

        public Task<ApplicationUser> FindByNameAsync(string normalizedUserName, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<IdentityResult> CreateAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<IdentityResult> DeleteAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetNormalizedUserNameAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetPasswordHashAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<string> GetUserNameAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<bool> HasPasswordAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task SetNormalizedUserNameAsync(ApplicationUser user, string normalizedName, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task SetPasswordHashAsync(ApplicationUser user, string passwordHash, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task SetUserNameAsync(ApplicationUser user, string userName, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

        public Task<IdentityResult> UpdateAsync(ApplicationUser user, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

#endregion
    }
}
