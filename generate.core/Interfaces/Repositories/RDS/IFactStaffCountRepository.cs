using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactStaffCountRepository : IRDSRepository
    {
        void Migrate_StaffCounts(string factTypeCode);
        IEnumerable<ReportEDFactsK12StaffCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false);
    }
}
