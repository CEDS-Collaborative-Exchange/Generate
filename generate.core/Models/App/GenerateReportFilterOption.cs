using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class GenerateReportFilterOption
    {
        public int GenerateReportFilterOptionId { get; set; }
        public int GenerateReportId { get; set; }
        public bool IsSubFilter { get; set; }
        public bool IsDefaultOption { get; set; }
        public string FilterCode { get; set; }
        public string FilterName { get; set; }
        public int FilterSequence { get; set; }
        public GenerateReport GenerateReport { get; set; }
    }
}
