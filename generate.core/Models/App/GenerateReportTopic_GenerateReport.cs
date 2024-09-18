using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class GenerateReportTopic_GenerateReport
    {
        public int GenerateReportTopicId { get; set; }
        public GenerateReportTopic GenerateReportTopic { get; set; }
        public int GenerateReportId { get; set; }
        public GenerateReport GenerateReport { get; set; }
    }
}
