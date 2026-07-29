using System.Collections.Generic;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// The deterministic, per-fact-type runbook the AI ETL Developer follows for steps 2-4 of the
    /// fact-type migration doc. Everything here is resolved from Generate metadata
    /// (App.DataMigrationTasks, App.GenerateReport_FactType, App.SqlUnitTest) so it works for any
    /// fact type without hard-coding proc names. Token substitution replaces @SchoolYear and
    /// @FactTypeOrReportCode in the task strings.
    /// </summary>
    public class EtlFactTypeRunbook
    {
        public int FactTypeId { get; set; }
        public string FactTypeCode { get; set; }

        /// <summary>EDFacts report codes for this fact type (e.g. childcount -> 002, 089).</summary>
        public List<string> ReportCodes { get; set; } = new List<string>();

        /// <summary>App.Wrapper_Migrate_&lt;FactType&gt;_to_RDS (DataMigrationTask type 2).</summary>
        public string RdsWrapperProc { get; set; }

        /// <summary>rds.Empty_Reports '&lt;code&gt;' (DataMigrationTask type 3).</summary>
        public string EmptyReportsSql { get; set; }

        /// <summary>rds.create_reports '&lt;code&gt;',0 (DataMigrationTask type 3).</summary>
        public string CreateReportsSql { get; set; }

        /// <summary>Staging.StagingValidation_Execute call (DataMigrationTask type 5), tokens substituted.</summary>
        public string StagingValidationExecuteSql { get; set; }

        /// <summary>Staging.StagingValidation_GetResults call (derived from the Execute proc).</summary>
        public string StagingValidationResultsSql { get; set; }

        /// <summary>Report code -> App.FS&lt;code&gt;_TestCase proc name (from App.SqlUnitTest, active, non-demo).</summary>
        public Dictionary<string, string> TestProcByReportCode { get; set; } = new Dictionary<string, string>();

        /// <summary>True when we have enough to run the migration/report phases (a fact type was resolved).</summary>
        public bool IsResolved => FactTypeId > 0 && !string.IsNullOrWhiteSpace(FactTypeCode);
    }
}
