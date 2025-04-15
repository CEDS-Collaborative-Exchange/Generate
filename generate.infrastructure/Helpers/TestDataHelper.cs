using generate.core.Models.App;
using generate.infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.web.Infrastructure.Helpers
{
    public static class TestDataHelper
    {
        /// <summary>
        /// Setup Test Data
        /// </summary>
        public static void SetupTestDataForInMemoryStore(AppDbContext appDbContext, IDSDbContext odsDbContext)
        {
            
            // CedsConnection
            DbSet<CedsConnection> cedsConnectionSet = appDbContext.Set<CedsConnection>();

            var cedsConnection = new CedsConnection()
            {
                CedsConnectionId = 1,
                CedsConnectionName = "002",
                CedsConnectionDescription = "002 File Spec",
                CedsConnectionSource = "EDFacts"
            };

            cedsConnectionSet.Add(cedsConnection);


            appDbContext.SaveChanges();

        }
    }
}
