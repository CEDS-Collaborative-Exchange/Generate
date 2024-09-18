using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    public interface IDataPopulationSummaryService
    {
        GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, int reportSort = 1, int skip = 0, int take = 50);
    }
}