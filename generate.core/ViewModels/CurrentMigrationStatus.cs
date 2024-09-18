using System;
using generate.core.Models.App;

namespace generate.core.ViewModels.App
{
    public class CurrentMigrationStatus
    {
        public string ODSMigrationStatusCode { get; set; }
        public DateTime? ODSLastMigrationTriggerDate { get; set; }
        public int? ODSLastMigrationDurationInSeconds { get; set; }
        public DateTime? ODSLastMigrationHistoryDate { get; set; }
        public string ODSLastMigrationHistoryMessage { get; set; }

        public string RDSMigrationStatusCode { get; set; }
        public DateTime? RDSLastMigrationTriggerDate { get; set; }
        public int? RDSLastMigrationDurationInSeconds { get; set; }
        public DateTime? RDSLastMigrationHistoryDate { get; set; }
        public string RDSLastMigrationHistoryMessage { get; set; }

        public string ReportMigrationStatusCode { get; set; }
        public DateTime? ReportLastMigrationTriggerDate { get; set; }
        public int? ReportLastMigrationDurationInSeconds { get; set; }
        public DateTime? ReportLastMigrationHistoryDate { get; set; }
        public string ReportLastMigrationHistoryMessage { get; set; }
        public string UserName { get; set; }
    }
}
