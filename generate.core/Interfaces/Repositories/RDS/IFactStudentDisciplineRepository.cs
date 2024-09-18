using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactStudentDisciplineRepository : IRDSRepository
    {
        void Migrate_StudentDisciplines(string factTypeCode);
        IEnumerable<ReportEDFactsK12StudentDiscipline> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeZeroCounts = false, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false);
    }
}
