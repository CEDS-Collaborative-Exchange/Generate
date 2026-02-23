using Azure;
using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public record ReportDebugPagingOptions(
        int Sort = 1,
        int Skip = 0,
        int Take = 50,
        int PageSize = 10,
        int Page = 1);

    public interface IReportDebugRepository : IRDSRepository
    {
        IEnumerable<ReportDebug> Get_ReportDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string parameters, ReportDebugPagingOptions paging = null);

    }
}
