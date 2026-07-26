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
        public int IterationNumber { get; set; }
        public int MaxLoops { get; set; }
        public long? SourceCount { get; set; }
        public long? StagingCount { get; set; }
        public bool CanContinue { get; set; }      // client should auto-run the next iteration
        public string Summary { get; set; }
        public List<EtlChatMessage> NewMessages { get; set; }
    }

    /// <summary>What the LLM is asked to return each turn (parsed from its JSON reply).</summary>
    public class EtlChatModelReply
    {
        public List<string> Questions { get; set; }
        public string EtlSql { get; set; }
        public string TestSql { get; set; }
        public string Explanation { get; set; }
    }
}
