using generate.core.Models.RDS;
using System.Collections.Generic;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactOrganizationStatusCountRepository : IRDSRepository
	{
		void Migrate_FactOrganizationStatusCounts(string factTypeCode);
		IEnumerable<ReportEDFactsOrganizationStatusCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool flag = false);
	}
}
