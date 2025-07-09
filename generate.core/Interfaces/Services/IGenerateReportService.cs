using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using generate.core.Models.RDS;

namespace generate.core.Interfaces.Services
{
    public interface IGenerateReportService
    {
        List<GenerateReport> GetReports(string reportTypeCode);
        List<GenerateReport> GetReportList(string reportTypeCode);
        GenerateReport GetReport(string reportTypeCode, string reportCode);
        List<GenerateReportDto> GetReportDtos(List<GenerateReport> reports);
        GenerateReportDataDto GetReportDataDto(string reportType, string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea = null, string reportSchool = null, string reportFilter = null, string reportSubFilter = null, string reportGrade = null, string organizationalIdList=null, int reportSort = 1, int skip = 0, int take = 50, int pageSize = 10, int page = 1);
        List<ReportDebug> GetReportDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string parameters, int sort = 1, int skip = 0, int take = 50, int pageSize = 10, int page = 1);
    }
}