using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    /// <summary>
    /// A general-purpose AI assistant chat session (App.AssistantSession, CIID-9061) — NOT tied to an ETL
    /// map. A place to ask questions or have the local LLM write/update T-SQL (e.g. roll a stored procedure
    /// to a new school year).
    /// </summary>
    public class AssistantSession
    {
        public int AssistantSessionId { get; set; }
        public string Title { get; set; }
        public string Status { get; set; }   // Active | AwaitingInput
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public List<AssistantMessage> AssistantMessages { get; set; }
    }
}
