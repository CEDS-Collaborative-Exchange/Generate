using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class GenerateReportTopic
    {
        public int GenerateReportTopicId { get; set; }
        public string GenerateReportTopicName { get; set; }
        public string UserName { get; set; }
        public bool IsActive { get; set; }
        public List<GenerateReportTopic_GenerateReport> GenerateReportTopic_GenerateReports { get; set; }
    }
}
