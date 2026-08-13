using System.Collections.Generic;
using generate.core.Models.App;

namespace generate.core.Dtos.App
{
    /// <summary>Create-session payload.</summary>
    public class EtlChatSessionCreateDto
    {
        public int EtlMapId { get; set; }
        public string SessionName { get; set; }
        public string SourceConnection { get; set; }
        public string SourceObject { get; set; }
        public int? MaxLoops { get; set; }
        public int? SchoolYear { get; set; }
        public string CreatedBy { get; set; }
    }

    /// <summary>A user chat turn (an answer to the bot's question or a refinement).</summary>
    public class EtlChatUserMessageDto
    {
        public string Content { get; set; }
        public string CreatedBy { get; set; }
    }

    /// <summary>Result of running one iteration of the ETL development loop.</summary>
    public class EtlChatIterationResultDto
    {
        public int EtlChatSessionId { get; set; }
        public string Outcome { get; set; }        // EtlChatIterationOutcome.*
        public string Status { get; set; }         // session status
        public string Phase { get; set; }          // EtlChatPhase.* the session is now in
        public int IterationNumber { get; set; }
        public int MaxLoops { get; set; }
        public long? SourceCount { get; set; }
        public long? StagingCount { get; set; }
        public bool CanContinue { get; set; }      // client should auto-run the next iteration
        public string Summary { get; set; }
        public List<EtlChatMessage> NewMessages { get; set; }
    }

    /// <summary>
    /// Readiness check: can this map's mappings actually satisfy the target file spec / fact type's
    /// end-to-end migration? Compares the authoritative Staging tables/columns the file spec requires
    /// (app.vwStagingRelationships) against what the map's element mappings target. Surfaced before/at
    /// the start of an AI session so a user isn't left running a whole session that can never complete
    /// the report migration because a required Staging table was never mapped.
    /// </summary>
    public class EtlMappingCoverageDto
    {
        public int EtlMapId { get; set; }
        public string FactTypeCode { get; set; }
        public string ReportCodes { get; set; }            // comma-joined report code(s), if any

        public bool Resolved { get; set; }                 // false = couldn't resolve a fact type / requirements for this map
        public bool IsReady { get; set; }                  // true = every required Staging table (and its NOT NULL business columns) is mapped

        public int RequiredTableCount { get; set; }
        public int MappedRequiredTableCount { get; set; }

        public List<string> RequiredTables { get; set; } = new List<string>();         // ALL Staging tables the file spec requires
        public List<string> MissingTables { get; set; } = new List<string>();          // required Staging tables with NO mapped column
        public List<string> MissingRequiredColumns { get; set; } = new List<string>(); // required NOT NULL columns (Table.Column) with no mapping
        public List<string> CoveredTables { get; set; } = new List<string>();          // required Staging tables that ARE mapped

        public string Summary { get; set; }                // one-line human summary
    }

    /// <summary>What the LLM is asked to return each turn (parsed from its JSON reply).</summary>
    public class EtlChatModelReply
    {
        public List<string> Questions { get; set; }
        public string EtlSql { get; set; }
        public string TestSql { get; set; }
        public string Explanation { get; set; }

        /// <summary>A read-only SELECT the model wants to run to inspect the schema/data (e.g. INFORMATION_SCHEMA)
        /// before writing its ETL. Executed read-only; results are fed back into the loop.</summary>
        public string LookupSql { get; set; }
    }
}
