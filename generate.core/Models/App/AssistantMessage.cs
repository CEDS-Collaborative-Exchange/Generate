using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>One entry in a general assistant chat transcript (App.AssistantMessage, CIID-9061).</summary>
    public class AssistantMessage
    {
        public int AssistantMessageId { get; set; }
        public int AssistantSessionId { get; set; }
        public string Role { get; set; }        // user | assistant | system
        public string Content { get; set; }
        public DateTime CreatedDate { get; set; }

        [JsonIgnore]
        public AssistantSession AssistantSession { get; set; }
    }
}
