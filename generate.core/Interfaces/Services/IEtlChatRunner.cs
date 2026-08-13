namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// Runs an ETL chat session's phase loop server-side in the background (CIID-9061), so the run
    /// continues even when the user leaves the page. The UI just polls status/messages and reconnects.
    /// </summary>
    public interface IEtlChatRunner
    {
        /// <summary>Starts (or resumes) the background loop for a session. No-op if already running.</summary>
        void Start(int etlChatSessionId);

        /// <summary>Requests the background loop to stop after the current step finishes.</summary>
        void Stop(int etlChatSessionId);

        /// <summary>True while a background loop is actively iterating this session.</summary>
        bool IsRunning(int etlChatSessionId);
    }
}
