using System.Collections.Generic;
using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Models.App;

namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// AI ETL developer chatbot (CIID-9061): per-map sessions that iteratively build, execute, and
    /// self-test SQL ETL from a source into the map's mapped Staging tables using a local Ollama model.
    /// </summary>
    public interface IEtlChatService
    {
        List<EtlChatSession> GetSessions(int etlMapId);
        EtlChatSession GetSession(int etlChatSessionId);
        List<EtlChatMessage> GetMessages(int etlChatSessionId);
        EtlChatSession CreateSession(EtlChatSessionCreateDto create);
        bool DeleteSession(int etlChatSessionId);

        /// <summary>Appends a user message (an answer/refinement) and reactivates the session.</summary>
        EtlChatSession PostUserMessage(int etlChatSessionId, EtlChatUserMessageDto message);

        /// <summary>
        /// Runs one iteration: prompts the model, and if it returns SQL, executes the ETL and its
        /// tests, comparing source vs Staging counts. Returns the outcome; the caller loops while
        /// CanContinue is true (up to MaxLoops).
        /// </summary>
        Task<EtlChatIterationResultDto> RunIterationAsync(int etlChatSessionId);

        /// <summary>
        /// Materializes the session's validated ETL as a unique stored procedure (CREATE OR ALTER)
        /// and registers it in App.DataMigrationTasks so the Generate tool can execute it. Runs
        /// automatically when a session completes; can also be invoked manually.
        /// </summary>
        EtlChatSession PublishProcedure(int etlChatSessionId);
    }
}
