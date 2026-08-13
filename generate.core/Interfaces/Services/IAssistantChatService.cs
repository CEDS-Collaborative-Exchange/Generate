using System.Collections.Generic;
using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Models.App;

namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// General-purpose AI assistant chat (CIID-9061): free-form sessions with the local Ollama model that
    /// are NOT tied to an ETL map. Used to ask questions or have the model write/update T-SQL.
    /// </summary>
    public interface IAssistantChatService
    {
        List<AssistantSession> GetSessions();
        AssistantSession GetSession(int assistantSessionId);
        List<AssistantMessage> GetMessages(int assistantSessionId);
        AssistantSession CreateSession(AssistantSessionCreateDto create);
        bool DeleteSession(int assistantSessionId);

        /// <summary>Appends a user message and reactivates the session.</summary>
        AssistantSession PostUserMessage(int assistantSessionId, AssistantUserMessageDto message);

        /// <summary>Streams the assistant's reply to the latest turn into a new message row (saved
        /// incrementally so the UI can poll and show it as it types). Returns when the reply is complete.</summary>
        Task<AssistantMessage> RunAsync(int assistantSessionId);
    }
}
