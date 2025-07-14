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
	public class FactOrganizationStatusCountRepository : RDSRepository, IFactOrganizationStatusCountRepository
	{
		private readonly ILogger _logger;

		public FactOrganizationStatusCountRepository(
			ILogger<FactOrganizationStatusCountRepository> logger,
			RDSDbContext context
			)
			: base(context)
		{
			_logger = logger;
		}

		public void Migrate_FactOrganizationStatusCounts(string factTypeCode)
		{

			int? oldTimeOut = _context.Database.GetCommandTimeout();
			_context.Database.SetCommandTimeout(11000);
			//_context.Database.ExecuteSqlCommand("rds.Migrate_OrganizationIndicatorStatuses @factTypeCode = {0}, @runAsTest = 0", factTypeCode);
			_context.Database.SetCommandTimeout(oldTimeOut);

		}


		public IEnumerable<ReportEDFactsOrganizationStatusCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool flag = false)
		{
			var returnObject = new List<ReportEDFactsOrganizationStatusCount>();
            int? oldTimeout = null;

            try
			{
				oldTimeout = _context.Database.GetCommandTimeout();
				_context.Database.SetCommandTimeout(11000);
				returnObject = _context.Set<ReportEDFactsOrganizationStatusCount>().FromSqlRaw("rds.Get_OrganizationStatusReportData @reportCode = {0}, @reportLevel = {1}, @reportYear = {2}, @categorySetCode = {3}, @flag={4}", reportCode, reportLevel, reportYear, categorySetCode, flag).ToList();
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
