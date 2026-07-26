using System.Collections.Generic;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public class OllamaMessage
    {
        public string Role { get; set; }
        public string Content { get; set; }
    }

    /// <summary>Minimal client for a local Ollama chat model (CIID-9061).</summary>
    public interface IOllamaClient
    {
        bool IsConfigured { get; }
        string Model { get; }

        /// <summary>Sends a chat completion request and returns the assistant's message content.</summary>
        Task<string> ChatAsync(IEnumerable<OllamaMessage> messages);
    }
}
