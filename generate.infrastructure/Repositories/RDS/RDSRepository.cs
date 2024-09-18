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
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Models.RDS;

namespace generate.infrastructure.Repositories.RDS
{

    public class RDSRepository : RepositoryBase, IRDSRepository
    {
        public RDSRepository(RDSDbContext context)
            : base(context)
        {

        }

        public bool CheckIfDirectoryDataExists(int schoolYearId)
        {
            int recordCount = _context.Set<FactOrganizationCount>()
                                      .Where(t => t.SchoolYearId == schoolYearId && t.SeaId > 0)
                                      .Count();
            return recordCount > 0 ? true : false;
        }



    }

}
