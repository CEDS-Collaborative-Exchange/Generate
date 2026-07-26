using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>One entry in an ETL chat session transcript (App.EtlChatMessage, CIID-9061).</summary>
    public class EtlChatMessage
    {
        public int EtlChatMessageId { get; set; }
        public int EtlChatSessionId { get; set; }
        public string Role { get; set; }          // user | assistant | system | tool
        public string MessageType { get; set; }   // chat | question | sql | testresult | status | error
        public int? IterationNumber { get; set; }
        public string Content { get; set; }
        public DateTime CreatedDate { get; set; }

        [JsonIgnore]
        public EtlChatSession EtlChatSession { get; set; }
    }
}
