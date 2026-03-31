using Azure;
using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IReportDebugRepository : IRDSRepository
    {
        IEnumerable<ReportDebug> Get_ReportDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string parameters, int sort, int skip, int take, int pageSize, int page);

    }
}
