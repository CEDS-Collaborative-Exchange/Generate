using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportDataDto
    {
        public string ReportTitle { get; set; }
        public string ReportControlTypeName { get; set; }
        public string ReportYear { get; set; }
        public GenerateReportStructureDto structure { get; set; }
        public dynamic data { get; set; }
        public int dataCount { get; set; }
        public string totalKey { get; set; }
        public ExpandoObject totals { get; set; }
        public List<CategorySetDto> CategorySets { get; set; }
    }
}
