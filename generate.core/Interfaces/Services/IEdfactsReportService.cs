using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    public interface IEdFactsReportService
    {
        GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, string tableTypeAbbrv, int reportSort = 1, int pageSize = 10, int page = 1);
        GenerateReportDataDto GetOrganizationStatusReportData(string reportCode, string reportLevel, string reportYear, string categorySetCode);
    }
}