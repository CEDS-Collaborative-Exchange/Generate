using System;
using System.Collections.Concurrent;
using System.Threading.Tasks;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Singleton background runner for ETL chat sessions (CIID-9061). Drives the phase loop server-side
    /// by repeatedly calling <see cref="IEtlChatService.RunIterationAsync"/> (each on its own DI scope)
    /// while the iteration says it can continue. This lets a run keep advancing after the user navigates
    /// away; the UI reconnects by polling status/messages.
    /// </summary>
    public class EtlChatRunner : IEtlChatRunner
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<EtlChatRunner> _logger;

        // Session ids with an active background loop. Presence == running.
        private readonly ConcurrentDictionary<int, byte> _running = new ConcurrentDictionary<int, byte>();

        // Session ids the user asked to stop; the loop breaks after the current step finishes.
        private readonly ConcurrentDictionary<int, byte> _stopRequested = new ConcurrentDictionary<int, byte>();

        // Safety cap on iterations per Start() so a bug can't spin forever.
        private const int MaxIterations = 500;

        public EtlChatRunner(IServiceScopeFactory scopeFactory, ILogger<EtlChatRunner> logger = null)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        public bool IsRunning(int etlChatSessionId) => _running.ContainsKey(etlChatSessionId);

        public void Start(int etlChatSessionId)
        {
            _stopRequested.TryRemove(etlChatSessionId, out _);
            // Only one background loop per session.
            if (!_running.TryAdd(etlChatSessionId, 0))
            {
                return;
            }
            _ = Task.Run(() => RunLoopAsync(etlChatSessionId));
        }

        public void Stop(int etlChatSessionId)
        {
            // Flag it; the loop checks between steps and breaks. Only meaningful while running.
            if (_running.ContainsKey(etlChatSessionId))
            {
                _stopRequested.TryAdd(etlChatSessionId, 0);
            }
        }

        private async Task RunLoopAsync(int etlChatSessionId)
        {
            bool stopped = false;
            try
            {
                for (int i = 0; i < MaxIterations; i++)
                {
                    if (_stopRequested.ContainsKey(etlChatSessionId))
                    {
                        stopped = true;
                        break;
                    }

                    bool canContinue;
                    // Fresh DI scope (fresh DbContext) per iteration — the background task outlives any request.
                    using (var scope = _scopeFactory.CreateScope())
                    {
                        var service = scope.ServiceProvider.GetRequiredService<IEtlChatService>();
                        var result = await service.RunIterationAsync(etlChatSessionId);
                        canContinue = result != null && result.CanContinue;
                    }

                    if (_stopRequested.ContainsKey(etlChatSessionId))
                    {
                        stopped = true;
                        break;
                    }
                    if (!canContinue)
                    {
                        break;
                    }
                    await Task.Delay(250);
                }
            }
            catch (Exception ex)
            {
                _logger?.LogError(ex, "EtlChatRunner background loop failed for session {SessionId}", etlChatSessionId);
            }
            finally
            {
                _stopRequested.TryRemove(etlChatSessionId, out _);
                _running.TryRemove(etlChatSessionId, out _);
                if (stopped)
                {
                    try
                    {
                        using var scope = _scopeFactory.CreateScope();
                        scope.ServiceProvider.GetRequiredService<IEtlChatService>().NotifyStopped(etlChatSessionId);
                    }
                    catch (Exception ex)
                    {
                        _logger?.LogError(ex, "EtlChatRunner could not mark session {SessionId} stopped", etlChatSessionId);
                    }
                }
            }
        }
    }
}
