using generate.core.Dtos.RDS;
using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace generate.core.Interfaces.Repositories.RDS
{
    public record MembershipReportQueryOptions(
        bool IncludeFriendlyCaptions = false,
        bool ObscureMissingCategoryCounts = false,
        bool IsOnlineReport = false,
        int StartRecord = 1,
        int NumberOfRecords = 1000000);

    public interface IFactStudentCountRepository
    {
        void Migrate_StudentCounts(string factTypeCode);
        IEnumerable<ReportEDFactsK12StudentCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false, bool isOnlineReport = false);
        (IEnumerable<MembershipReportDto>, int) Get_MembershipReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, MembershipReportQueryOptions options = null);
         // New ETL
        void Migrate_FactStudentCounts(string reportYear, string factTypeCode);

       


    }
}
