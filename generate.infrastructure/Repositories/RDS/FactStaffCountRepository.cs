using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.infrastructure.Contexts;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.RDS;

namespace generate.infrastructure.Repositories.RDS 
{
    public class FactStaffCountRepository : RDSRepository, IFactStaffCountRepository
    {
        private readonly ILogger _logger;

        public FactStaffCountRepository(
            ILogger<FactStaffCountRepository> logger,
            RDSDbContext context
            )
            : base(context)
        {
            _logger = logger;
        }

        public void Migrate_StaffCounts(string factTypeCode)
        {

            int? oldTimeOut = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(11000);
            _context.Database.ExecuteSqlRaw("rds.Migrate_PersonnelCounts @factTypeCode = {0}, @runAsTest = 0", factTypeCode);
            _context.Database.SetCommandTimeout(oldTimeOut);

        }


        public IEnumerable<ReportEDFactsK12StaffCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false)
        {
            // Convert bool parameters to bit values

            int zeroCounts = 0;
            int friendlyCaptions = 0;
            int missingCategoryCounts = 0;

            if (includeZeroCounts)
            {
                zeroCounts = 1;
            }
            if (includeFriendlyCaptions)
            {
                friendlyCaptions = 1;
            }
            if (obscureMissingCategoryCounts)
            {
                missingCategoryCounts = 1;
            }

            var returnObject = new List<ReportEDFactsK12StaffCount>();
            int? oldTimeout = null;

            try
            {
                oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<ReportEDFactsK12StaffCount>().FromSqlRaw("rds.Get_ReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @includeZeroCounts = {4}, @includeFriendlyCaptions = {5}, @obscureMissingCategoryCounts = {6}", reportCode, reportLevel, reportYear, categorySetCode, zeroCounts, friendlyCaptions, missingCategoryCounts).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            finally
            {
                _context.Database.SetCommandTimeout(oldTimeout);
            }

            return returnObject;

        }

        

    }
}
