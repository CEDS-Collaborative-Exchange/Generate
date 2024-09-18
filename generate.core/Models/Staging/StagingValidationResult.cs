using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class StagingValidationResult
    {
        public int Id { get; set; }
        public int StagingValidationRuleId { get; set; }
        public int SchoolYear { get; set; }
        public string FactTypeOrReportCode { get; set; }
        public string StagingTableName { get; set; }
        public string ColumnName { get; set; }
        public string Severity { get; set; }
        public string ValidationMessage { get; set; }
        public int RecordCount { get; set; }
        public DateTime? InsertDate { get; set; }
        public string ShowRecordsSQL { get; set; }
    }

}
