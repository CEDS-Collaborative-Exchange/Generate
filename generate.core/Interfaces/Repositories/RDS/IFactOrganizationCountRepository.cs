using generate.core.Models.RDS;
using generate.core.Dtos.ODS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public record OrganizationCountQueryOptions(
        bool IncludeZeroCounts = false,
        bool IncludeFriendlyCaptions = false,
        bool ObscureMissingCategoryCounts = false,
        bool Flag = false);

    public interface IFactOrganizationCountRepository : IRDSRepository
    {
        void Migrate_OrganizationCounts(string factTypeCode);
        IEnumerable<ReportEDFactsOrganizationCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool flag = false);
        IEnumerable<ReportEDFactsGradesOffered> Get_GradesOfferedReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, OrganizationCountQueryOptions options = null);
        IEnumerable<ReportEDFactsPersistentlyDangerous> Get_PersistentlyDangerousReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, OrganizationCountQueryOptions options = null);
        IEnumerable<OrganizationDto> GetOrganizations(string organizationtype, string schoolYear);
    }
}
