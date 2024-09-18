using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.RDS;

namespace generate.infrastructure.Repositories.RDS 
{
    public class FactStudentDisciplineRepository : RDSRepository, IFactStudentDisciplineRepository
    {
        private readonly ILogger _logger;

        public FactStudentDisciplineRepository(
            ILogger<FactStudentDisciplineRepository> logger,
            RDSDbContext context
            )
            : base(context)
        {
            _logger = logger;
        }

        public void Migrate_StudentDisciplines(string factTypeCode)
        {

            int? oldTimeOut = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(11000);
            _context.Database.ExecuteSqlRaw("rds.Migrate_StudentDisciplines @factTypeCode = {0}, @runAsTest = 0", factTypeCode);
            _context.Database.SetCommandTimeout(oldTimeOut);

        }


        public IEnumerable<ReportEDFactsK12StudentDiscipline> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false)
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

            var returnObject = new List<ReportEDFactsK12StudentDiscipline>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000); 
                returnObject = _context.Set<ReportEDFactsK12StudentDiscipline>().FromSqlRaw("rds.Get_ReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @includeZeroCounts = {4}, @includeFriendlyCaptions = {5}, @obscureMissingCategoryCounts = {6}", reportCode, reportLevel, reportYear, categorySetCode, zeroCounts, friendlyCaptions, missingCategoryCounts).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }

            return returnObject;

        }


    }
}
