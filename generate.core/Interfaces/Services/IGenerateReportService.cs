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
        GenerateReportDto GetReportDto(GenerateReport report, string reportYear);
        GenerateReportDataDto GetReportDataDto(string reportType, string reportCode, string reportLevel, string reportYear, string categorySetCode, string tableTypeAbbrv, string reportLea = null, string reportSchool = null, string reportFilter = null, string reportSubFilter = null, string reportGrade = null, string organizationalIdList=null, int reportSort = 1, int skip = 0, int take = 50, int pageSize = 10, int page = 1);
        List<ReportDebug> GetReportDebugData(string reportCode, string reportLevel, string reportYear, string categorySetCode, string parameters, int sort = 1, int skip = 0, int take = 50, int pageSize = 10, int page = 1);

        // Moved from GenerateReportController's direct IAppRepository/IRDSRepository usage
        IEnumerable<CategorySet> GetDistinctCategorySets(string reportCode, string reportLevel, string reportYear);
        List<string> GetYearCategoryOptions(string reportYear, string reportLevel);
        List<int> GetSubmissionYears(string reportCode);
        List<string> GetSubmissionYearsWithSelectionPrompt(string reportCode, string reportType);
        List<OrganizationLevelDto> GetOrganizationLevels();
        List<OrganizationLevelDto> GetOrganizationLevelsByReportCodeYear(string reportCode, string reportYear, string categorySetCode);
        GenerateReportFilterOption GetFilterOptionByCode(string filterCode);
        CategorySet GetCategorySetByCode(string categorySetCode);
    }
}