using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class GenerateReportDto
    {
        public int GenerateReportId { get; set; }
        public int GenerateReportTypeId { get; set; }
        public int GenerateReportControlTypeId { get; set; }
        public int? CedsConnectionId { get; set; }
        public string ReportName { get; set; }
        public string ReportShortName { get; set; }
        public string ReportTypeAbbreviation { get; set; }
        public string ReportCode { get; set; }
        public int? ReportSequence { get; set; }
        public string CategorySetControlCaption { get; set; }
        public bool ShowCategorySetControl { get; set; }
        public string CategorySetControlLabel { get; set; }
        public string FilterControlLabel { get; set; }
        public string SubFilterControlLabel { get; set; }
        public bool ShowFilterControl { get; set; }
        public bool ShowSubFilterControl { get; set; }
        public bool ShowData { get; set; }
        public bool ShowGraph { get; set; }

        public bool SeaLevel { get; set; }
        public bool LeaLevel { get; set; }
        public bool SchLevel { get; set; }

        public bool isActive { get; set; }
        public bool IsLocked { get; set; }
        public string ConnectionLink { get; set; }

        public GenerateReportControlType ReportControlType { get; set; }
        public List<OrganizationLevelDto> OrganizationLevels { get; set; }
        public List<CategorySetDto> CategorySets { get; set; }
        public List<GenerateReportFilterDto> ReportFilters { get; set; }
        public List<GenerateReportFilterOptionDto> ReportFilterOptions { get; set; }
    }
}
