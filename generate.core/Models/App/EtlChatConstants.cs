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
        public const string Passed = "Passed";                 // tests passed; done
        public const string Failed = "Failed";                 // tests failed; may continue
        public const string MaxLoopsReached = "MaxLoopsReached";
        public const string Error = "Error";
    }
}
