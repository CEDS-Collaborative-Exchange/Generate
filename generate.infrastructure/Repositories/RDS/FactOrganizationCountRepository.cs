using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.infrastructure.Contexts;
using generate.core.Models.RDS;
using Microsoft.EntityFrameworkCore;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Dtos.ODS;

namespace generate.infrastructure.Repositories.RDS 
{
    public class FactOrganizationCountRepository : RDSRepository, IFactOrganizationCountRepository
    {
        private readonly ILogger _logger;

        public FactOrganizationCountRepository(
            ILogger<FactOrganizationCountRepository> logger,
            RDSDbContext context
            )
            : base(context)
        {
            _logger = logger;
        }

        public void Migrate_OrganizationCounts(string factTypeCode)
        {

            int? oldTimeOut = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(11000);
            _context.Database.ExecuteSqlRaw("rds.Migrate_OrganizationCounts @factTypeCode = {0}, @runAsTest = 0", factTypeCode);
            _context.Database.SetCommandTimeout(oldTimeOut);

        }


        public IEnumerable<ReportEDFactsOrganizationCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool flag = false)
        {
            // Convert bool parameters to bit values


            var returnObject = new List<ReportEDFactsOrganizationCount>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<ReportEDFactsOrganizationCount>().FromSqlRaw("rds.Get_OrganizationReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @flag={4}", reportCode, reportLevel, reportYear, categorySetCode, flag).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<ReportEDFactsGradesOffered> Get_GradesOfferedReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool flag = false)
        {
            // Convert bool parameters to bit values


            var returnObject = new List<ReportEDFactsGradesOffered>();

            try
            {
                int? oldTimeout = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(11000);
                returnObject = _context.Set<ReportEDFactsGradesOffered>().FromSqlRaw("rds.Get_OrganizationReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @flag={4}", reportCode, reportLevel, reportYear, categorySetCode, flag).ToList();
                _context.Database.SetCommandTimeout(oldTimeout);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                throw;
            }
            return returnObject;

        }

        public IEnumerable<OrganizationDto> GetOrganizations(string organizationtype, string schoolYear)
        {

            var returnObject = new List<OrganizationDto>();

            try
            {
                if(schoolYear.ToLower() == "undefined") { 
                    schoolYear = DateTime.Now.Year.ToString();  
                }
                returnObject = _context.Set<OrganizationDto>().FromSqlRaw("App.Get_Organizations @organizationType = {0}, @schoolYear = {1}", organizationtype, Convert.ToInt32(schoolYear)).ToList();
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
