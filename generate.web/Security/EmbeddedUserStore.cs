using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using generate.core.Config;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;

namespace generate.web.Security.Embeddable
{
    public class EmbeddedUserStore<T> : IUserStore<ApplicationUser>, IUserPasswordStore<ApplicationUser>
    {
        // Search and create a user from Active Directory

        private readonly ILogger _logger;
        //private string _UserContainer;


        private String _adminUserName;
        private String _reviewerUserName;

        public EmbeddedUserStore(ILogger<EmbeddedUserStore<T>> logger, IConfiguration configuration) : base()
        {
            _logger = logger;

            _adminUserName = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedAdminUserName");
            _reviewerUserName = configuration.GetSection("AppSettings").GetValue<string>("EmbeddedReviewerUserName");

        }
        public async Task<ApplicationUser> FindByIdAsync(string userId, CancellationToken cancellationToken)
        {
            _logger.LogError("IN EMBEDDED FINDBYIDASYNC");
            
            if (userId.Equals(_adminUserName))
                return await Task.Run(() => new ApplicationUser()
                {
                    UserName = userId,
                    Id = userId,
                    DisplayName = "Embedded Generate Admin",
                    FirstName = "Embedded Admin"

                });
            else if (userId.Equals(_reviewerUserName))
                return await Task.Run(() => new ApplicationUser()
                {
                    UserName = userId,
                    Id = userId,
                    DisplayName = "Embedded Generate Reviewer",
                    FirstName = "Embedded Reviewer"
                });
           
            else 
                return await Task.Run(() => new ApplicationUser()
                {
                    UserName = "Anonymous",
                    Id = "Anonymous"
                });
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
