using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using generate.core.Config;
using generate.core.Interfaces.Repositories.Staging;

namespace generate.infrastructure.Repositories.Staging
{

    public class StagingRepository : RepositoryBase, IStagingRepository
    {


        public StagingRepository(StagingDbContext context)
            : base(context)
        {

        }
        

    }

}