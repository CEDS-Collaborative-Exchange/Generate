using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportFilterOptionDto
    {
        public int GenerateReportFilterOptionId { get; set; }
        public bool IsSubFilter { get; set; }
        public bool IsDefaultOption { get; set; }
        public string FilterCode { get; set; }
        public string FilterName { get; set; }
        public int FilterSequence { get; set; }
    }
}
