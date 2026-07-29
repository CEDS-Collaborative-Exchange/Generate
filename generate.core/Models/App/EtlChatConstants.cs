namespace generate.core.Models.App
{
    public static class EtlChatSessionStatus
    {
        public const string Active = "Active";
        public const string AwaitingInput = "AwaitingInput";
        public const string Completed = "Completed";
        public const string Failed = "Failed";
    }

    public static class EtlChatRole
    {
        public const string User = "user";
        public const string Assistant = "assistant";
        public const string System = "system";
        public const string Tool = "tool";
    }

    public static class EtlChatMessageType
    {
        public const string Chat = "chat";
        public const string Question = "question";
        public const string Sql = "sql";
        public const string TestResult = "testresult";
        public const string Status = "status";
        public const string Error = "error";
    }

    /// <summary>Outcome of running one iteration of the ETL development loop.</summary>
    public static class EtlChatIterationOutcome
    {
        public const string AwaitingInput = "AwaitingInput";   // bot asked questions; stop and wait
        public const string Passed = "Passed";                 // final validation passed; done
        public const string Failed = "Failed";                 // a step failed; may continue/retry
        public const string PhaseComplete = "PhaseComplete";   // a phase finished; auto-advance to the next
        public const string MaxLoopsReached = "MaxLoopsReached";
        public const string Error = "Error";
    }

    /// <summary>
    /// Phases of the end-to-end run, following the fact-type migration doc (steps 2-4). The bot starts
    /// at StagingLoad and auto-advances through validate/migrate/report until ReportValidate confirms
    /// the numbers (Done) or it hits a problem.
    /// </summary>
    public static class EtlChatPhase
    {
        public const string StagingLoad = "StagingLoad";         // 2: LLM builds & runs Source->Staging
        public const string StagingValidate = "StagingValidate"; // 2: StagingValidation_Execute/GetResults
        public const string RdsMigrate = "RdsMigrate";           // 3: Wrapper_Migrate_<FactType>_to_RDS
        public const string ReportMigrate = "ReportMigrate";     // 4: lock + Empty_Reports + create_reports
        public const string ReportValidate = "ReportValidate";   // 4: FS<xxx>_TestCase + compare
        public const string Done = "Done";
    }
}
