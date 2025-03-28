using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.infrastructure.Contexts;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using System.Globalization;
using System.Dynamic;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class RDSDataMigrationService : IRDSDataMigrationService
    {

        public RDSDataMigrationService(
            )
        {
           
        }
        

    }

}