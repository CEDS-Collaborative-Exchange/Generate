using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Dtos.App;

namespace generate.core.Interfaces.Services
{
    public interface IStateDefinedReportService
    {
        GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, string reportLea = null, string reportSchool = null, string reportFilter = null, string reportSubFilter = null, string reportGrade = null, string organizationalIdList=null, int reportSort = 1, int skip = 0, int take = 50);
    }
}
