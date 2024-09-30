using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.infrastructure.Contexts;
using Microsoft.Extensions.Logging;

namespace generate.infrastructure.Services
{
    public class AboutService : IAboutService
    {
        private readonly AppDbContext _appDbContext;
        private readonly IAppRepository _appRepository;
        private readonly ILogger<AppUpdateService> _logger;
        string GenerateConfigurationCategory = "Database";
        string GenerateConfigurationKey = "DatabaseVersion";

        public AboutService(AppDbContext appDbContext, IAppRepository appRepository, ILogger<AppUpdateService> logger)
        {
            _appDbContext = appDbContext ?? throw new ArgumentNullException(nameof(appDbContext));
            _appRepository = appRepository ?? throw new ArgumentNullException(nameof(appRepository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public string GetDBVersion()
        {
            //throw new NotImplementedException();

            string DBVersion =string.Empty;

            IQueryable<GenerateConfiguration> gc = _appDbContext.GenerateConfigurations
                                                   .Where(gc => gc.GenerateConfigurationCategory == GenerateConfigurationCategory 
                                                   && gc.GenerateConfigurationKey == GenerateConfigurationKey
                                                   );

            if (gc is null)
            {
                // string genConfigVal = gc.Where(a => a.GenerateConfigurationKey == essKey).Select(a => a.GenerateConfigurationValue).FirstOrDefault();
                return DBVersion; 
            }
            else if (gc.Count() == 0)
            {
                return DBVersion;
            }
            else
            {
                DBVersion = gc.Select(a => a.GenerateConfigurationValue).FirstOrDefault();
                return DBVersion;
            }            

        }

    }
}
