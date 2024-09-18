using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportTopicDto
    {
        public int GenerateReportTopicId { get; set; }
        public string GenerateReportTopicName { get; set; }
        public string UserName { get; set; }
        public bool IsActive { get; set; }
        public List<GenerateReportDto> GenerateReports { get; set; }
    }
}
