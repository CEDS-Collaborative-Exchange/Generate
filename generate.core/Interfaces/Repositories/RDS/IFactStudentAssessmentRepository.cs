using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactStudentAssessmentRepository : IRDSRepository
    {
        void Migrate_StudentAssessments(string factTypeCode);
        IEnumerable<ReportEDFactsK12StudentAssessment> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false);
    }
}
