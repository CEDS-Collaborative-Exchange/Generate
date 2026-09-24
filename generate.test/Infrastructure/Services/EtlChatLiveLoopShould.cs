using generate.core.Config;
using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.App;
using generate.infrastructure.Repositories.RDS;
using generate.infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using Xunit.Abstractions;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// LIVE integration harness for the AI ETL Developer StagingLoad loop (CIID-9061). Unlike the mocked
    /// <see cref="EtlChatServiceShould"/>, this drives the REAL EtlChatService against the REAL localhost
    /// Generate database and the REAL local Ollama model — exactly what the app does when the user clicks
    /// Run. Its purpose is to reproduce, observe, and drive OUT the "hits 10 loops and crashes with a
    /// different error each time" failure so the prompt/process can be perfected.
    ///
    /// It is GATED behind the env var ETLCHAT_LIVE=1 so it never runs in the normal suite (it needs a live
    /// DB + Ollama and mutates the FS002 Staging rows for the target year — idempotently: DELETE by
    /// SchoolYear then INSERT). Run it explicitly, e.g. (PowerShell):
    ///   $env:ETLCHAT_LIVE="1"; $env:ETLCHAT_MAP_ID="6"; $env:ETLCHAT_MAX_LOOPS="8"
    ///   dotnet test generate.test --filter FullyQualifiedName~EtlChatLiveLoopShould
    /// Tunables (all env vars): ETLCHAT_MAP_ID (default 6), ETLCHAT_MAX_LOOPS (default 8),
    ///   ETLCHAT_YEAR (default 2026), ETLCHAT_LOG_PATH (default %TEMP%\etlchat_harness.log).
    /// </summary>
    public class EtlChatLiveLoopShould
    {
        private readonly ITestOutputHelper _out;
        public EtlChatLiveLoopShould(ITestOutputHelper output) { _out = output; }

        private static string Env(string k, string dflt) =>
            string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable(k)) ? dflt : Environment.GetEnvironmentVariable(k);

        // Build the real service graph against localhost Generate + local Ollama, using the app's real
        // appsettings.Development.json (copied to the test output under Config/).
        private static (EtlChatService chat, IConfiguration config) BuildRealGraph()
        {
            // Load the LIVE web appsettings (the exact file the running app uses) rather than the stale copy
            // the test build drops in its own Config/ — otherwise the harness could test a different model.
            var configPath = Environment.GetEnvironmentVariable("ETLCHAT_CONFIG");
            if (string.IsNullOrWhiteSpace(configPath) || !File.Exists(configPath))
            {
                var dir = new DirectoryInfo(AppContext.BaseDirectory);
                while (dir != null)
                {
                    var candidate = Path.Combine(dir.FullName, "generate.web", "Config", "appsettings.Development.json");
                    if (File.Exists(candidate)) { configPath = candidate; break; }
                    dir = dir.Parent;
                }
            }
            if (string.IsNullOrWhiteSpace(configPath) || !File.Exists(configPath))
                configPath = Path.Combine(AppContext.BaseDirectory, "Config", "appsettings.Development.json"); // last resort
            var config = new ConfigurationBuilder()
                .AddJsonFile(configPath, optional: false, reloadOnChange: false)
                .AddEnvironmentVariables()
                .Build();

            string appConn = config["Data:AppDbContextConnection"];
            string rdsConn = config["Data:RDSDbContextConnection"] ?? appConn;

            var appOptions = new DbContextOptionsBuilder<AppDbContext>().UseSqlServer(appConn).Options;
            var rdsOptions = new DbContextOptionsBuilder<RDSDbContext>().UseSqlServer(rdsConn).Options;

            var appDb = new AppDbContext(appOptions, Mock.Of<ILogger<AppDbContext>>(), Options.Create(new AppSettings()));
            var rdsDb = new RDSDbContext(rdsOptions, Mock.Of<ILogger<RDSDbContext>>());

            IRDSRepository rdsRepo = new RDSRepository(rdsDb);
            IAppRepository appRepo = new AppRepository(appDb, rdsRepo);

            // EtlSourceMappingService's only heavy dependency (CedsAutoMapService) is used for auto-mapping,
            // NOT for the read methods the StagingLoad loop calls (GetAllMappings/GetMapSources/GetMapJoins/
            // GetMaps/GetCedsOptionSetValues), so a Moq stub is safe here.
            IEtlSourceMappingService mapping = new EtlSourceMappingService(
                appRepo, rdsRepo, Mock.Of<ICedsAutoMapService>(), null, config, null);

            IOllamaClient ollama = new OllamaClient(config);
            var chat = new EtlChatService(appRepo, mapping, ollama, config);
            return (chat, config);
        }

        [Fact]
        [Trait("Category", "LiveEtlChat")]
        public async Task DriveStagingLoadToCleanExecution()
        {
            if (Env("ETLCHAT_LIVE", "0") != "1")
            {
                _out.WriteLine("ETLCHAT_LIVE != 1 — skipping live harness (set ETLCHAT_LIVE=1 to run).");
                return;
            }

            int mapId = int.Parse(Env("ETLCHAT_MAP_ID", "6"));
            int maxLoops = int.Parse(Env("ETLCHAT_MAX_LOOPS", "8"));
            int year = int.Parse(Env("ETLCHAT_YEAR", "2026"));
            string logPath = Env("ETLCHAT_LOG_PATH", Path.Combine(Path.GetTempPath(), "etlchat_harness.log"));

            var sb = new StringBuilder();
            void Log(string s)
            {
                string line = s ?? "";
                sb.AppendLine(line);
                _out.WriteLine(line);
                try { File.AppendAllText(logPath, line + Environment.NewLine); } catch { }
            }

            try { File.WriteAllText(logPath, ""); } catch { }
            Log($"=== ETL chat live harness @ map {mapId}, maxLoops {maxLoops}, year {year} ===");

            var (chat0, config) = BuildRealGraph();
            Log($"Ollama model: {config["Ollama:SqlModel"]}  |  AllowSqlExecution: {config["EtlChat:AllowSqlExecution"]}  |  SelfReview: {config["EtlChat:SelfReview"] ?? "(default on)"}");

            var session = chat0.CreateSession(new EtlChatSessionCreateDto
            {
                EtlMapId = mapId,
                SessionName = "live-harness",
                SchoolYear = year,
                MaxLoops = maxLoops
            });
            int sid = session.EtlChatSessionId;
            Log($"Created session {sid}.");

            int lastMsgId = 0;
            string finalPhase = EtlChatPhase.StagingLoad;
            string finalStatus = EtlChatSessionStatus.Active;
            var startedUtc = DateTime.UtcNow;

            // Drive one iteration at a time (the client normally auto-continues while CanContinue). We stop the
            // moment StagingLoad succeeds (phase advances) — that IS the goal: a clean, executing load. In
            // per-table mode the phase stays on StagingLoad across many turns (one table each), so the driving
            // cap must be generous — the session's own per-table budget is the real stopping condition.
            int maxIters = int.Parse(Env("ETLCHAT_MAX_ITERS", "60"));
            for (int i = 1; i <= maxIters; i++)
            {
                // Fresh service graph (fresh DbContext) PER ITERATION — mirrors the app's scoped-per-request
                // lifetime, so the change-tracker never accumulates across turns (a long-lived context threw
                // "error saving entity changes" mid-run). The session lives in the DB and is re-read by id.
                var (chat, _) = BuildRealGraph();
                var iterStart = DateTime.UtcNow;
                var r = await chat.RunIterationAsync(sid);
                var iterSecs = (DateTime.UtcNow - iterStart).TotalSeconds;

                foreach (var m in chat.GetMessages(sid).Where(m => m.EtlChatMessageId > lastMsgId))
                {
                    lastMsgId = m.EtlChatMessageId;
                    string content = (m.Content ?? "").Trim();
                    Log($"  [{m.Role}/{m.MessageType}] {content}");
                }

                var s = chat.GetSession(sid);
                finalPhase = s.CurrentPhase;
                finalStatus = s.Status;
                Log($"-- iter {i}: phase={r.Phase} -> now {s.CurrentPhase} | outcome={r.Outcome} | status={s.Status} | loop={s.CurrentLoop}/{s.MaxLoops} | canContinue={r.CanContinue} | {iterSecs:F0}s");

                if (s.CurrentPhase != EtlChatPhase.StagingLoad)
                {
                    Log($"*** StagingLoad SUCCEEDED — advanced to {s.CurrentPhase}. Final ETL SQL:\n{s.LastEtlSql}");
                    break;
                }
                if (!r.CanContinue || s.Status == EtlChatSessionStatus.Failed)
                {
                    Log($"*** StagingLoad STOPPED without advancing (status={s.Status}).");
                    break;
                }
            }

            Log($"=== DONE in {(DateTime.UtcNow - startedUtc).TotalMinutes:F1} min. finalPhase={finalPhase}, finalStatus={finalStatus}. Log: {logPath} ===");

            Assert.True(finalPhase != EtlChatPhase.StagingLoad,
                $"StagingLoad did not produce a clean executing load (stuck at {finalPhase}/{finalStatus}). See {logPath}.\n\n" + sb);
        }
    }
}
