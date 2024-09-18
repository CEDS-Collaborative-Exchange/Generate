using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class GenerateReport
    {
        public int GenerateReportId { get; set; }

        public int GenerateReportTypeId { get; set; }
        public int GenerateReportControlTypeId { get; set; }
        public GenerateReportType GenerateReportType { get; set; }
        public GenerateReportControlType GenerateReportControlType { get; set; }
        public int? CedsConnectionId { get; set; }
        public CedsConnection CedsConnection { get; set; }
        public string ReportName { get; set; }
        public string ReportShortName { get; set; }
        public string ReportTypeAbbreviation{ get; set; }
        public string ReportCode { get; set; }
        public int? ReportSequence { get; set; }
        public string CategorySetControlCaption { get; set; }
        public string CategorySetControlLabel { get; set; }
        public string FilterControlLabel { get; set; }
        public string SubFilterControlLabel { get; set; }
        public bool ShowCategorySetControl { get; set; }
        public int? FactTableId { get; set; }
        public bool ShowFilterControl { get; set; }
        public bool ShowSubFilterControl { get; set; }
        public bool ShowData { get; set; }
        public bool ShowGraph { get; set; }
        public bool IsActive { get; set; }
        public bool IsLocked { get; set; }

        public bool UseLegacyReportMigration { get; set; }

        public List<GenerateReport_OrganizationLevel> GenerateReport_OrganizationLevels { get; set; }
        public List<GenerateReport_TableType> GenerateReport_TableTypes { get; set; }
        public List<GenerateReportTopic_GenerateReport> GenerateReportTopic_GenerateReports { get; set; }
        public List<CategorySet> CategorySets { get; set; }
        public FactTable FactTable { get; set; }
        public List<GenerateReportFilterOption> GenerateReportFilterOptions { get; set; }
        public List<GenerateReport_FactType> GenerateReport_FactTypes { get; set; }

    }
}
