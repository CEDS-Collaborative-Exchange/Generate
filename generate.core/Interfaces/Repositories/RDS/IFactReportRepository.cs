using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactReportRepository
    {
        void ExecuteReportMigrationByYearLevelAndCategorySet(string reportCode, string reportYear, string reportLevel, string categorySetCode, List<string> excludeFilters, List<string> excludeToggles);
    }
}
