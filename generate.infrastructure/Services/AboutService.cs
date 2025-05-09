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
        readonly string GenerateConfigurationCategory = "Database";
        readonly string GenerateConfigurationKey = "DatabaseVersion";

        public AboutService(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext ?? throw new ArgumentNullException(nameof(appDbContext));
        }

        public string GetDBVersion()
        {
            string DBVersion =string.Empty;

            IQueryable<GenerateConfiguration> gc = _appDbContext.GenerateConfigurations
                                                   .Where(gc => gc.GenerateConfigurationCategory == GenerateConfigurationCategory 
                                                   && gc.GenerateConfigurationKey == GenerateConfigurationKey
                                                   );

            if (gc == null || !gc.Any())
            {
                return DBVersion; 
            }

            DBVersion = gc.Select(a => a.GenerateConfigurationValue).FirstOrDefault();
            return DBVersion;

        }

    }
}
