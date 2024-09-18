using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportFilterDto
    {
        public string FilterName { get; set; }
        public string FilterControl { get; set; }
        public List<GenerateReportFilterItemDto> FilterItems { get; set; }
    }
}
