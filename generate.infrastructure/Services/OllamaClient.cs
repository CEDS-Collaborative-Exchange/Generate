using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Configuration;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Talks to a local Ollama server (CIID-9061). Configured by:
    ///   Ollama:Url            (default http://localhost:11434)
    ///   Ollama:SqlModel       (default qwen2.5:32b-instruct - best installed model for SQL)
    ///   Ollama:TimeoutSeconds (default 300)
    ///   Ollama:Temperature    (default 0.1 - low, for deterministic SQL)
    /// </summary>
    public class OllamaClient : IOllamaClient
    {
        private readonly string _url;
        private readonly double _temperature;
        private readonly TimeSpan _timeout;

        public OllamaClient(IConfiguration configuration)
        {
            _url = (configuration["Ollama:Url"] ?? "http://localhost:11434").TrimEnd('/');
            Model = configuration["Ollama:SqlModel"] ?? "qwen2.5:32b-instruct";
            _temperature = double.TryParse(configuration["Ollama:Temperature"], out var t) ? t : 0.1;
            _timeout = TimeSpan.FromSeconds(int.TryParse(configuration["Ollama:TimeoutSeconds"], out var s) ? s : 300);
        }

        public bool IsConfigured => !string.IsNullOrWhiteSpace(_url) && !string.IsNullOrWhiteSpace(Model);

        public string Model { get; }

        public async Task<string> ChatAsync(IEnumerable<OllamaMessage> messages)
        {
            var payload = new
            {
                model = Model,
                stream = false,
                options = new { temperature = _temperature },
                messages = messages.Select(m => new { role = m.Role, content = m.Content ?? string.Empty }).ToArray()
            };

            using var http = new HttpClient { Timeout = _timeout };
            using var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

            using var response = await http.PostAsync($"{_url}/api/chat", content);
            string body = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
            {
                throw new InvalidOperationException($"Ollama request failed ({(int)response.StatusCode}): {body}");
            }

            using var doc = JsonDocument.Parse(body);
            if (doc.RootElement.TryGetProperty("message", out var message) &&
                message.TryGetProperty("content", out var contentEl))
            {
                return contentEl.GetString() ?? string.Empty;
            }

            return string.Empty;
        }
    }
}
