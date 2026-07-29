using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading;
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
    ///   Ollama:TimeoutSeconds     (default 600) - hard cap on the whole call
    ///   Ollama:IdleTimeoutSeconds (default 120) - abort only if NO token arrives for this long,
    ///                              so a model that is actively streaming is never killed mid-answer
    ///   Ollama:MaxTokens          (default 4096) - num_predict cap so a runaway model can't stream forever
    /// </summary>
    public class OllamaClient : IOllamaClient
    {
        private readonly string _url;
        private readonly double _temperature;
        private readonly TimeSpan _timeout;
        private readonly TimeSpan _idleTimeout;
        private readonly int _maxTokens;

        public OllamaClient(IConfiguration configuration)
        {
            _url = (configuration["Ollama:Url"] ?? "http://localhost:11434").TrimEnd('/');
            Model = configuration["Ollama:SqlModel"] ?? "qwen2.5:7b-instruct";
            _temperature = double.TryParse(configuration["Ollama:Temperature"], out var t) ? t : 0.1;
            _timeout = TimeSpan.FromSeconds(int.TryParse(configuration["Ollama:TimeoutSeconds"], out var s) ? s : 600);
            _idleTimeout = TimeSpan.FromSeconds(int.TryParse(configuration["Ollama:IdleTimeoutSeconds"], out var i) ? i : 120);
            _maxTokens = int.TryParse(configuration["Ollama:MaxTokens"], out var mt) ? mt : 4096;
        }

        public bool IsConfigured => !string.IsNullOrWhiteSpace(_url) && !string.IsNullOrWhiteSpace(Model);

        public string Model { get; }

        public Task<string> ChatAsync(IEnumerable<OllamaMessage> messages)
        {
            return ChatAsync(messages, null);
        }

        public async Task<string> ChatAsync(IEnumerable<OllamaMessage> messages, Action<string> onProgress)
        {
            // Stream tokens so the caller can surface live progress. Without a progress callback the
            // behaviour is identical to a blocking call (we just accumulate and return the content).
            var payload = new
            {
                model = Model,
                stream = true,
                options = new { temperature = _temperature, num_predict = _maxTokens },
                messages = messages.Select(m => new { role = m.Role, content = m.Content ?? string.Empty }).ToArray()
            };

            // Two guards: a hard overall cap, and an idle timeout that only fires when the model
            // produces NO output for _idleTimeout. The idle timer is reset on every streamed line,
            // so a model that is slowly-but-steadily streaming an answer is never killed mid-generation.
            using var http = new HttpClient { Timeout = Timeout.InfiniteTimeSpan };
            using var overallCts = new CancellationTokenSource(_timeout);
            using var idleCts = new CancellationTokenSource(_idleTimeout);
            using var linked = CancellationTokenSource.CreateLinkedTokenSource(overallCts.Token, idleCts.Token);

            using var request = new HttpRequestMessage(HttpMethod.Post, $"{_url}/api/chat")
            {
                Content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json")
            };

            HttpResponseMessage response;
            try
            {
                response = await http.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, linked.Token);
            }
            catch (OperationCanceledException) when (overallCts.IsCancellationRequested)
            {
                throw new TimeoutException($"Ollama did not respond within {_timeout.TotalSeconds:N0}s (model '{Model}').");
            }
            catch (OperationCanceledException)
            {
                throw new TimeoutException($"Ollama produced no output for {_idleTimeout.TotalSeconds:N0}s while loading model '{Model}'.");
            }

            if (!response.IsSuccessStatusCode)
            {
                string body = await response.Content.ReadAsStringAsync();
                response.Dispose();
                throw new InvalidOperationException($"Ollama request failed ({(int)response.StatusCode}): {body}");
            }

            var accumulated = new StringBuilder();
            var throttle = Stopwatch.StartNew();
            using var stream = await response.Content.ReadAsStreamAsync();
            using var reader = new StreamReader(stream);

            string line;
            while (true)
            {
                try
                {
                    line = await reader.ReadLineAsync(linked.Token);
                }
                catch (OperationCanceledException) when (overallCts.IsCancellationRequested)
                {
                    throw new TimeoutException(
                        $"Ollama exceeded the {_timeout.TotalSeconds:N0}s cap (model '{Model}'); returned {accumulated.Length:N0} chars so far.");
                }
                catch (OperationCanceledException)
                {
                    throw new TimeoutException(
                        $"Ollama stalled — no output for {_idleTimeout.TotalSeconds:N0}s (model '{Model}').");
                }

                if (line == null)
                {
                    break;
                }

                // Any line (even a keep-alive) counts as progress: push the idle deadline forward.
                idleCts.CancelAfter(_idleTimeout);

                if (string.IsNullOrWhiteSpace(line))
                {
                    continue;
                }

                string delta = null;
                bool done = false;
                try
                {
                    using var doc = JsonDocument.Parse(line);
                    var root = doc.RootElement;
                    if (root.TryGetProperty("message", out var message) &&
                        message.TryGetProperty("content", out var contentEl))
                    {
                        delta = contentEl.GetString();
                    }
                    if (root.TryGetProperty("done", out var doneEl) && doneEl.ValueKind == JsonValueKind.True)
                    {
                        done = true;
                    }
                }
                catch (JsonException)
                {
                    // Ignore any non-JSON keep-alive line.
                    continue;
                }

                if (!string.IsNullOrEmpty(delta))
                {
                    accumulated.Append(delta);
                    // Throttle progress callbacks to ~1/second so we don't hammer the store.
                    if (onProgress != null && throttle.ElapsedMilliseconds >= 900)
                    {
                        throttle.Restart();
                        onProgress(accumulated.ToString());
                    }
                }

                if (done)
                {
                    break;
                }
            }

            return accumulated.ToString();
        }
    }
}
