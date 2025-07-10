using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Repositories.RDS
{
    public interface IFactCustomCountRepository : IRDSRepository
    {
        IEnumerable<FactCustomCount> Get_ReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, bool includeFriendlyCaptions = false, bool obscureMissingCategoryCounts = false);
        IEnumerable<FactCustomCount> Get_FederalProgramReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter);
        IEnumerable<FactCustomCount> Get_DisciplinaryRemovalsReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode);
        IEnumerable<FactCustomCount> Get_AssessmentPerformanceReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportSubFilter, string reportGrade);
        IEnumerable<FactCustomCount> Get_EducationEnvironmentDisabilitiesReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode);
        IEnumerable<FactCustomCount> Get_YearToYearChildCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode);
        IEnumerable<FactCustomCount> Get_YearToYearEnvironmentCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode);
        IEnumerable<FactCustomCount> Get_YearToYearExitCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter);
        IEnumerable<FactCustomCount> Get_YearToYearExitCountReportDataSCH(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter);
        IEnumerable<FactCustomCount> Get_LEAStudentsSummary(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportLea);
        IEnumerable<FactCustomCount> Get_YearToYearRemovalCountReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string filter);
        IEnumerable<FactCustomCount> Get_YearToYearProgressReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportFilter, string reportSubFilter, string reportGrade, string reportLea, string reportSchool);
        IEnumerable<FactCustomCount> Get_YearToYearAttendanceReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportGrade, string reportLea, string reportSchool);
    }
}
