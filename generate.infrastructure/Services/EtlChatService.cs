using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// AI ETL developer chatbot (CIID-9061). Iteratively prompts a local Ollama model to build SQL
    /// that loads a source into the map's mapped Staging tables, then executes and self-tests it
    /// (source vs Staging counts), looping until the counts match or MaxLoops is reached. The bot can
    /// ask questions; the user answers to refine. Full transcript is stored per session/map.
    /// </summary>
    public class EtlChatService : IEtlChatService
    {
        private readonly IAppRepository _appRepository;
        private readonly IEtlSourceMappingService _mappingService;
        private readonly IOllamaClient _ollama;
        private readonly string _connectionString;
        private readonly bool _allowSqlExecution;
        private readonly int _defaultMaxLoops;

        public EtlChatService(
            IAppRepository appRepository,
            IEtlSourceMappingService mappingService,
            IOllamaClient ollama,
            IConfiguration configuration)
        {
            _appRepository = appRepository;
            _mappingService = mappingService;
            _ollama = ollama;
            _connectionString = configuration["Data:AppDbContextConnection"];
            _allowSqlExecution = !string.Equals(configuration["EtlChat:AllowSqlExecution"], "false", StringComparison.OrdinalIgnoreCase);
            _defaultMaxLoops = int.TryParse(configuration["EtlChat:DefaultMaxLoops"], out var m) ? m : 10;
        }

        public List<EtlChatSession> GetSessions(int etlMapId)
        {
            return _appRepository
                .FindReadOnly<EtlChatSession>(s => s.EtlMapId == etlMapId, 0, 0)
                .OrderByDescending(s => s.ModifiedDate ?? s.CreatedDate)
                .ToList();
        }

        public EtlChatSession GetSession(int etlChatSessionId)
        {
            return _appRepository.GetById<EtlChatSession>(etlChatSessionId);
        }

        public List<EtlChatMessage> GetMessages(int etlChatSessionId)
        {
            return _appRepository
                .FindReadOnly<EtlChatMessage>(m => m.EtlChatSessionId == etlChatSessionId, 0, 0)
                .OrderBy(m => m.EtlChatMessageId)
                .ToList();
        }

        public EtlChatSession CreateSession(EtlChatSessionCreateDto create)
        {
            var session = new EtlChatSession
            {
                EtlMapId = create.EtlMapId,
                SessionName = string.IsNullOrWhiteSpace(create.SessionName) ? "ETL session" : create.SessionName.Trim(),
                SourceConnection = create.SourceConnection,
                SourceObject = create.SourceObject,
                Status = EtlChatSessionStatus.Active,
                MaxLoops = create.MaxLoops.HasValue && create.MaxLoops.Value > 0 ? create.MaxLoops.Value : _defaultMaxLoops,
                CurrentLoop = 0,
                SchoolYear = create.SchoolYear.HasValue && create.SchoolYear.Value > 0 ? create.SchoolYear : null,
                CurrentPhase = EtlChatPhase.StagingLoad,
                CreatedDate = DateTime.UtcNow,
                CreatedBy = create.CreatedBy
            };
            _appRepository.Create(session);
            _appRepository.Save();

            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, null,
                "New ETL development session. Tell me to start and I'll build the load from " +
                (string.IsNullOrWhiteSpace(create.SourceObject) ? "the source" : create.SourceObject) +
                " into the mapped Staging tables, then test it. I'll ask if I need anything.");
            _appRepository.Save();
            return session;
        }

        public bool DeleteSession(int etlChatSessionId)
        {
            var session = _appRepository.Find<EtlChatSession>(s => s.EtlChatSessionId == etlChatSessionId, 0, 0).FirstOrDefault();
            if (session == null)
            {
                return false;
            }
            _appRepository.DeleteRange(new[] { session });
            _appRepository.Save();
            return true;
        }

        public EtlChatSession PostUserMessage(int etlChatSessionId, EtlChatUserMessageDto message)
        {
            var session = _appRepository.Find<EtlChatSession>(s => s.EtlChatSessionId == etlChatSessionId, 0, 0).FirstOrDefault();
            if (session == null || string.IsNullOrWhiteSpace(message?.Content))
            {
                return session;
            }

            AddMessage(etlChatSessionId, EtlChatRole.User, EtlChatMessageType.Chat, null, message.Content.Trim());
            if (session.Status == EtlChatSessionStatus.AwaitingInput || session.Status == EtlChatSessionStatus.Completed)
            {
                session.Status = EtlChatSessionStatus.Active;
            }
            session.ModifiedDate = DateTime.UtcNow;
            session.ModifiedBy = message.CreatedBy;
            _appRepository.Save();
            return session;
        }

        public async Task<EtlChatIterationResultDto> RunIterationAsync(int etlChatSessionId)
        {
            var session = _appRepository.Find<EtlChatSession>(s => s.EtlChatSessionId == etlChatSessionId, 0, 0).FirstOrDefault();
            if (session == null)
            {
                return new EtlChatIterationResultDto { EtlChatSessionId = etlChatSessionId, Outcome = EtlChatIterationOutcome.Error, Summary = "Session not found.", CanContinue = false };
            }

            var result = new EtlChatIterationResultDto
            {
                EtlChatSessionId = etlChatSessionId,
                MaxLoops = session.MaxLoops,
                IterationNumber = session.CurrentLoop,
                NewMessages = new List<EtlChatMessage>()
            };

            string phase = string.IsNullOrWhiteSpace(session.CurrentPhase) ? EtlChatPhase.StagingLoad : session.CurrentPhase;
            result.Phase = phase;

            if (session.Status == EtlChatSessionStatus.Completed || phase == EtlChatPhase.Done)
            {
                result.Outcome = EtlChatIterationOutcome.Passed;
                result.Status = EtlChatSessionStatus.Completed;
                result.CanContinue = false;
                result.Summary = "This session already finished — the numbers were validated.";
                return result;
            }

            // The run is a phase machine following the fact-type doc (steps 2-4). Each call advances one
            // phase and returns CanContinue=true so the client auto-runs the next, stopping only when the
            // final validation passes (Done), the bot needs input, or it hits a genuine problem.
            switch (phase)
            {
                case EtlChatPhase.StagingValidate: return RunStagingValidatePhase(session, result);
                case EtlChatPhase.RdsMigrate: return RunRdsMigratePhase(session, result);
                case EtlChatPhase.ReportMigrate: return RunReportMigratePhase(session, result);
                case EtlChatPhase.ReportValidate: return RunReportValidatePhase(session, result);
                default: return await RunStagingLoadPhaseAsync(session, result);
            }
        }

        // -------------------- Phase 2: Staging load (LLM) --------------------

        private async Task<EtlChatIterationResultDto> RunStagingLoadPhaseAsync(EtlChatSession session, EtlChatIterationResultDto result)
        {
            if (session.CurrentLoop >= session.MaxLoops && session.Status != EtlChatSessionStatus.Completed)
            {
                session.Status = EtlChatSessionStatus.Failed;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.MaxLoopsReached;
                result.Status = session.Status;
                result.CanContinue = false;
                result.Summary = $"Reached the max of {session.MaxLoops} loops without matching counts.";
                return result;
            }

            if (!_ollama.IsConfigured)
            {
                result.Outcome = EtlChatIterationOutcome.Error;
                result.Summary = "Ollama is not configured.";
                result.CanContinue = false;
                return result;
            }

            // Build the conversation and call the model. Stream the response into a single live
            // "thinking" message that updates as tokens arrive, so the user can watch it work.
            var messages = BuildPrompt(session);
            var liveMessage = AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                $"🧠 Asking the model ({_ollama.Model}) for the next attempt…");
            string reply;
            try
            {
                reply = await _ollama.ChatAsync(messages, accumulated =>
                {
                    // Show the tail of what the model is producing so progress is visible.
                    string tail = accumulated.Length > 600 ? "…" + accumulated.Substring(accumulated.Length - 600) : accumulated;
                    liveMessage.Content = $"🧠 The model is responding… ({accumulated.Length:N0} characters so far)\n\n{tail}";
                    liveMessage.CreatedDate = DateTime.UtcNow;
                    _appRepository.Save();
                });
            }
            catch (Exception ex)
            {
                liveMessage.Content = "🧠 The model call failed.";
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop, "LLM error: " + ex.Message);
                result.Outcome = EtlChatIterationOutcome.Error;
                result.Summary = ex.Message;
                result.CanContinue = false;
                result.Status = session.Status;
                return result;
            }

            // Collapse the live streaming message now that the full reply is in hand; the parsed
            // explanation and SQL are posted as their own messages below.
            liveMessage.Content = $"🧠 Model responded ({(reply ?? string.Empty).Length:N0} characters). Processing…";
            _appRepository.Save();

            var parsed = ParseReply(reply);

            if (!string.IsNullOrWhiteSpace(parsed.Explanation))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, session.CurrentLoop, parsed.Explanation.Trim());
            }

            // Bot has questions -> pause for the user
            if (parsed.Questions != null && parsed.Questions.Any(q => !string.IsNullOrWhiteSpace(q)))
            {
                string questions = string.Join("\n", parsed.Questions.Where(q => !string.IsNullOrWhiteSpace(q)).Select(q => "• " + q.Trim()));
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop, questions);
                session.Status = EtlChatSessionStatus.AwaitingInput;
                session.ModifiedDate = DateTime.UtcNow;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                result.Summary = "The assistant has questions.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(parsed.EtlSql))
            {
                // No SQL and no questions: treat as conversational; wait for the user
                if (string.IsNullOrWhiteSpace(parsed.Explanation))
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, session.CurrentLoop, reply.Trim());
                }
                session.Status = EtlChatSessionStatus.AwaitingInput;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                return result;
            }

            // We have ETL SQL: this counts as a development loop
            session.CurrentLoop += 1;
            result.IterationNumber = session.CurrentLoop;
            session.LastEtlSql = parsed.EtlSql;
            session.LastTestSql = parsed.TestSql;
            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Sql, session.CurrentLoop,
                "-- ETL SQL\n" + parsed.EtlSql.Trim() +
                (string.IsNullOrWhiteSpace(parsed.TestSql) ? "" : "\n\n-- TEST SQL\n" + parsed.TestSql.Trim()));

            if (!_allowSqlExecution)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "SQL execution is disabled (EtlChat:AllowSqlExecution=false). Review and run the SQL above manually.");
                session.Status = EtlChatSessionStatus.AwaitingInput;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                return result;
            }

            // Execute the ETL (guarded, Staging-scoped)
            string guardError = EtlSqlGuard.ValidateEtl(parsed.EtlSql);
            if (guardError != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Rejected ETL SQL: " + guardError);
                return FailOrContinue(session, result, $"ETL rejected by safety guard: {guardError}");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                "⚙️ Executing the ETL against the Staging schema…");
            string execError = ExecuteNonQuery(parsed.EtlSql);
            if (execError != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "ETL execution error:\n" + execError);
                return FailOrContinue(session, result, "ETL failed to execute; feeding the error back to the model.");
            }

            // Run the test (read-only) and compare counts
            long? sourceCount = null, stagingCount = null;
            if (!string.IsNullOrWhiteSpace(parsed.TestSql))
            {
                string testGuard = EtlSqlGuard.ValidateTest(parsed.TestSql);
                if (testGuard != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Rejected test SQL: " + testGuard);
                    return FailOrContinue(session, result, $"Test SQL rejected: {testGuard}");
                }
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "🧪 Validating — comparing source vs Staging row counts…");
                string testError = RunTest(parsed.TestSql, out sourceCount, out stagingCount);
                if (testError != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Test execution error:\n" + testError);
                    return FailOrContinue(session, result, "Test failed to execute; feeding the error back to the model.");
                }
            }

            result.SourceCount = sourceCount;
            result.StagingCount = stagingCount;
            string counts = $"SourceCount = {sourceCount?.ToString() ?? "?"}, StagingCount = {stagingCount?.ToString() ?? "?"}";
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop, counts);

            bool passed = sourceCount.HasValue && stagingCount.HasValue && sourceCount.Value == stagingCount.Value && stagingCount.Value > 0;
            if (passed)
            {
                session.ModifiedDate = DateTime.UtcNow;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"✅ Staging load matches source counts ({counts}) after {session.CurrentLoop} loop(s).");
                _appRepository.Save();

                // Materialize the validated ETL as an executable, registered stored procedure
                TryPublishProcedure(session);

                // Advance to the rest of the fact-type runbook (validate → RDS → reports → test).
                return Advance(session, result, EtlChatPhase.StagingValidate,
                    "Staging loaded — now validating the staging data, then migrating to the warehouse and reports.");
            }

            return FailOrContinue(session, result, $"Counts do not match ({counts}).");
        }

        private EtlChatIterationResultDto FailOrContinue(EtlChatSession session, EtlChatIterationResultDto result, string summary)
        {
            session.ModifiedDate = DateTime.UtcNow;
            if (session.CurrentLoop >= session.MaxLoops)
            {
                session.Status = EtlChatSessionStatus.Failed;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.MaxLoopsReached;
                result.Status = session.Status;
                result.CanContinue = false;
                result.Summary = summary + $" Reached max of {session.MaxLoops} loops.";
                return result;
            }
            session.Status = EtlChatSessionStatus.Active;
            _appRepository.Save();
            result.Outcome = EtlChatIterationOutcome.Failed;
            result.Status = session.Status;
            result.CanContinue = true;
            result.Summary = summary;
            return result;
        }

        // -------------------- Phase transitions --------------------

        // Move to the next phase and tell the client to auto-run it.
        private EtlChatIterationResultDto Advance(EtlChatSession session, EtlChatIterationResultDto result, string nextPhase, string summary)
        {
            session.CurrentPhase = nextPhase;
            session.Status = EtlChatSessionStatus.Active;
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            result.Phase = nextPhase;
            result.Outcome = EtlChatIterationOutcome.PhaseComplete;
            result.Status = session.Status;
            result.CanContinue = true;
            result.Summary = summary;
            return result;
        }

        private EtlChatIterationResultDto Done(EtlChatSession session, EtlChatIterationResultDto result, string summary)
        {
            session.CurrentPhase = EtlChatPhase.Done;
            session.Status = EtlChatSessionStatus.Completed;
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            result.Phase = EtlChatPhase.Done;
            result.Outcome = EtlChatIterationOutcome.Passed;
            result.Status = session.Status;
            result.CanContinue = false;
            result.Summary = summary;
            return result;
        }

        // A genuine problem: stop and hand back to the user (they can advise, then Run again).
        private EtlChatIterationResultDto Problem(EtlChatSession session, EtlChatIterationResultDto result, string summary)
        {
            session.Status = EtlChatSessionStatus.AwaitingInput;
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            result.Outcome = EtlChatIterationOutcome.Failed;
            result.Status = session.Status;
            result.CanContinue = false;
            result.Summary = summary;
            return result;
        }

        // -------------------- Phase 2b: Staging validation (deterministic) --------------------

        private EtlChatIterationResultDto RunStagingValidatePhase(EtlChatSession session, EtlChatIterationResultDto result)
        {
            int year = ResolveSchoolYear(session);
            var rb = ResolveRunbook(session.EtlMapId);
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"🧪 Phase 2 — validating the Staging data for '{rb.FactTypeCode ?? "?"}' (SY{year})…");

            if (!rb.IsResolved)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "No fact type is linked to this map's file spec, so I can't run the warehouse/report steps. Link a fact type or file spec to continue.");
                return Problem(session, result, "No fact type linked to the map — cannot run steps 3-4.");
            }

            if (string.IsNullOrWhiteSpace(rb.StagingValidationExecuteSql))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "No Staging validation is registered for this fact type; skipping to the warehouse migration.");
                return Advance(session, result, EtlChatPhase.RdsMigrate, "No staging validation configured — migrating to the CEDS Data Warehouse.");
            }

            string execSql = AsExec(SubstituteTokens(rb.StagingValidationExecuteSql, year, rb.FactTypeCode));
            string err = ExecuteAdminSql(execSql, 600);
            if (err != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Staging validation could not run:\n" + err);
                return Advance(session, result, EtlChatPhase.RdsMigrate, "Staging validation errored; proceeding to the warehouse migration.");
            }

            if (!string.IsNullOrWhiteSpace(rb.StagingValidationResultsSql))
            {
                string resultsSql = AsExec(SubstituteTokens(rb.StagingValidationResultsSql, year, rb.FactTypeCode));
                string table = ReadTabular(resultsSql, 20, out int rows);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                    $"Staging validation results ({rows} row(s)):\n" + table);
            }

            return Advance(session, result, EtlChatPhase.RdsMigrate, "Staging validated — migrating to the CEDS Data Warehouse (RDS).");
        }

        // -------------------- Phase 3: Staging → RDS (deterministic) --------------------

        private EtlChatIterationResultDto RunRdsMigratePhase(EtlChatSession session, EtlChatIterationResultDto result)
        {
            int year = ResolveSchoolYear(session);
            var rb = ResolveRunbook(session.EtlMapId);
            if (!rb.IsResolved || string.IsNullOrWhiteSpace(rb.RdsWrapperProc))
            {
                return Problem(session, result, "No RDS migration wrapper is registered for this fact type; cannot migrate to the warehouse.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"⚙️ Phase 3 — migrating Staging → CEDS Data Warehouse via {rb.RdsWrapperProc} (SY{year})…");

            string selErr = ExecuteAdminSql(SelectYearSql(year, 2), 120);
            if (selErr != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Could not select the school year for RDS:\n" + selErr);
                return Problem(session, result, "Could not select the school year for the RDS migration.");
            }

            string err = ExecuteAdminSql(AsExec(rb.RdsWrapperProc), 1800);
            if (err != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "The RDS migration wrapper failed:\n" + err);
                return Problem(session, result, "The Staging → RDS migration failed — see the error above.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, "✅ CEDS Data Warehouse (fact/dim) migration complete.");
            return Advance(session, result, EtlChatPhase.ReportMigrate, "Warehouse loaded — building the report tables.");
        }

        // -------------------- Phase 4a: Build report tables (deterministic) --------------------

        private EtlChatIterationResultDto RunReportMigratePhase(EtlChatSession session, EtlChatIterationResultDto result)
        {
            int year = ResolveSchoolYear(session);
            var rb = ResolveRunbook(session.EtlMapId);
            if (!rb.IsResolved)
            {
                return Problem(session, result, "No fact type linked — cannot build report tables.");
            }

            string codes = rb.ReportCodes.Count > 0 ? string.Join(", ", rb.ReportCodes) : "(none)";
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"📊 Phase 4 — building report tables for {codes} (SY{year})…");

            string selErr = ExecuteAdminSql(SelectYearSql(year, 3), 120);
            if (selErr != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Could not select the report year:\n" + selErr);
                return Problem(session, result, "Could not select the school year for the report migration.");
            }

            if (rb.ReportCodes.Count > 0)
            {
                string inList = string.Join(",", rb.ReportCodes.Select(c => "'" + c.Replace("'", "''") + "'"));
                string lockErr = ExecuteAdminSql(
                    "UPDATE App.GenerateReports SET IsLocked = 0;\n" +
                    $"UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN ({inList});", 120);
                if (lockErr != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Could not lock the reports:\n" + lockErr);
                    return Problem(session, result, "Could not lock the reports for this fact type.");
                }
            }

            if (!string.IsNullOrWhiteSpace(rb.EmptyReportsSql))
            {
                string e = ExecuteAdminSql(AsExec(SubstituteTokens(rb.EmptyReportsSql, year, rb.FactTypeCode)), 600);
                if (e != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Empty_Reports failed:\n" + e);
                    return Problem(session, result, "Empty_Reports failed — see the error above.");
                }
            }

            string createSql = !string.IsNullOrWhiteSpace(rb.CreateReportsSql)
                ? AsExec(SubstituteTokens(rb.CreateReportsSql, year, rb.FactTypeCode))
                : $"EXEC rds.create_reports '{rb.FactTypeCode}', 0";
            string cErr = ExecuteAdminSql(createSql, 1800);
            if (cErr != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "create_reports failed:\n" + cErr);
                return Problem(session, result, "create_reports failed — see the error above.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, "✅ Report tables built.");
            return Advance(session, result, EtlChatPhase.ReportValidate, "Reports built — validating the numbers.");
        }

        // -------------------- Phase 4b: Validate the numbers (deterministic) --------------------

        private EtlChatIterationResultDto RunReportValidatePhase(EtlChatSession session, EtlChatIterationResultDto result)
        {
            int year = ResolveSchoolYear(session);
            var rb = ResolveRunbook(session.EtlMapId);
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"🔎 Phase 4 — validating the numbers with the registered test case(s) (SY{year})…");

            if (rb.TestProcByReportCode.Count == 0)
            {
                return Problem(session, result, "No test cases are registered for these report codes, so I can't automatically validate the numbers.");
            }

            var lines = new List<string>();
            bool allPass = true;
            bool anyReal = false;
            foreach (var kv in rb.TestProcByReportCode)
            {
                string code = kv.Key;
                string proc = kv.Value;

                long beforeId = ExecuteScalarLong("SELECT ISNULL(MAX(SqlUnitTestResultId), 0) FROM App.SqlUnitTestCaseResult") ?? 0;
                string exErr = ExecuteAdminSql($"EXEC App.[{proc}] @SchoolYear = {year}", 1200);
                if (exErr != null)
                {
                    lines.Add($"FS{code}: test failed to run — {exErr.Split('\n')[0]}");
                    allPass = false;
                    continue;
                }

                long total = ExecuteScalarLong($"SELECT COUNT(*) FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestResultId > {beforeId}") ?? 0;
                long passedCnt = ExecuteScalarLong($"SELECT COUNT(*) FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestResultId > {beforeId} AND Passed = 1") ?? 0;
                long noResults = ExecuteScalarLong($"SELECT COUNT(*) FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestResultId > {beforeId} AND (ISNULL(TestCaseName,'') = 'NO TEST RESULTS' OR ExpectedResult = '-1')") ?? 0;
                long realChecks = total - noResults;

                if (realChecks <= 0)
                {
                    lines.Add($"FS{code}: NO TEST RESULTS — the test produced no comparisons (often a report-code label mismatch, e.g. the generator stamps '{code}' but the test joins on 'C{code}').");
                    allPass = false;
                }
                else
                {
                    anyReal = true;
                    lines.Add($"FS{code}: {passedCnt}/{realChecks} checks passed" + (passedCnt < realChecks ? " ❌" : " ✅"));
                    if (passedCnt < realChecks) allPass = false;
                }
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                "Validation results:\n" + string.Join("\n", lines));

            if (allPass && anyReal)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "✅ The numbers validated — Staging → RDS → Reports all check out. Done.");
                return Done(session, result, "All report numbers validated.");
            }

            return Problem(session, result, "Validation found problems — see the results above.");
        }

        // -------------------- Runbook resolution + SQL helpers --------------------

        private int ResolveSchoolYear(EtlChatSession session)
        {
            if (session.SchoolYear.HasValue && session.SchoolYear.Value > 0)
            {
                return session.SchoolYear.Value;
            }
            long? selected = ExecuteScalarLong(
                @"SELECT TOP 1 sy.SchoolYear FROM RDS.DimSchoolYearDataMigrationTypes dm
                  JOIN RDS.DimSchoolYears sy ON dm.DimSchoolYearId = sy.DimSchoolYearId
                  WHERE dm.IsSelected = 1 ORDER BY sy.SchoolYear DESC");
            return selected.HasValue && selected.Value > 0 ? (int)selected.Value : DateTime.UtcNow.Year;
        }

        private EtlFactTypeRunbook ResolveRunbook(int etlMapId)
        {
            var rb = new EtlFactTypeRunbook();
            try
            {
                ResolveRunbookCore(etlMapId, rb);
            }
            catch
            {
                // Best-effort: if metadata can't be read (e.g. no DB in a unit test), return whatever
                // resolved. Deterministic phases will surface an unresolved runbook as a clear problem.
            }
            return rb;
        }

        private void ResolveRunbookCore(int etlMapId, EtlFactTypeRunbook rb)
        {
            using var conn = new SqlConnection(_connectionString);
            conn.Open();

            // Resolve the fact type from the map's file-spec linkage, which may carry any of:
            // DimFactTypeId, FactTypeCode, or a FileSpecNumber (e.g. 'FS089' -> report code '089' -> fact type).
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    @"SELECT TOP 1 rdft.DimFactTypeId, rdft.FactTypeCode
                      FROM App.EtlMapFileSpec f
                      OUTER APPLY (
                          SELECT TOP 1 d.DimFactTypeId, d.FactTypeCode
                          FROM RDS.DimFactTypes d
                          WHERE d.DimFactTypeId = f.DimFactTypeId
                             OR d.FactTypeCode = f.FactTypeCode
                             OR d.DimFactTypeId = (
                                 SELECT TOP 1 agrft.FactTypeId
                                 FROM App.GenerateReports agr
                                 JOIN App.GenerateReport_FactType agrft ON agr.GenerateReportId = agrft.GenerateReportId
                                 WHERE agr.ReportCode = REPLACE(UPPER(f.FileSpecNumber), 'FS', ''))
                      ) rdft
                      WHERE f.EtlMapId = @map AND rdft.DimFactTypeId IS NOT NULL";
                cmd.Parameters.AddWithValue("@map", etlMapId);
                using var r = cmd.ExecuteReader();
                if (r.Read())
                {
                    rb.FactTypeId = r.GetInt32(0);
                    rb.FactTypeCode = r.IsDBNull(1) ? null : r.GetString(1).Trim();
                }
            }
            if (!rb.IsResolved)
            {
                return;
            }

            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    @"SELECT agr.ReportCode
                      FROM App.GenerateReport_FactType agrft
                      JOIN App.GenerateReports agr ON agr.GenerateReportId = agrft.GenerateReportId
                      WHERE agrft.FactTypeId = @ft AND LEN(agr.ReportCode) = 3
                      ORDER BY agr.ReportCode";
                cmd.Parameters.AddWithValue("@ft", rb.FactTypeId);
                using var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!r.IsDBNull(0)) rb.ReportCodes.Add(r.GetString(0).Trim());
                }
            }

            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    @"SELECT DataMigrationTypeId, StoredProcedureName
                      FROM App.DataMigrationTasks WHERE FactTypeId = @ft AND IsActive = 1";
                cmd.Parameters.AddWithValue("@ft", rb.FactTypeId);
                using var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    int type = r.GetInt32(0);
                    string sp = r.IsDBNull(1) ? "" : r.GetString(1).Trim();
                    if (string.IsNullOrWhiteSpace(sp)) continue;
                    string low = sp.ToLowerInvariant();
                    if (type == 2 && string.IsNullOrEmpty(rb.RdsWrapperProc) && low.Contains("wrapper_migrate")) rb.RdsWrapperProc = sp;
                    else if (type == 3 && low.Contains("empty_reports")) rb.EmptyReportsSql = sp;
                    else if (type == 3 && low.Contains("create_reports")) rb.CreateReportsSql = sp;
                    else if (type == 5 && low.Contains("stagingvalidation_execute")) rb.StagingValidationExecuteSql = sp;
                }
            }

            rb.StagingValidationResultsSql = rb.StagingValidationExecuteSql?
                .Replace("StagingValidation_Execute", "StagingValidation_GetResults");

            foreach (var code in rb.ReportCodes)
            {
                using var cmd = conn.CreateCommand();
                cmd.CommandText =
                    @"SELECT TOP 1 StoredProcedureName FROM App.SqlUnitTest
                      WHERE TestScope = @scope AND IsActive = 1 AND StoredProcedureName NOT LIKE '%[_]Demo'
                      ORDER BY SqlUnitTestId";
                cmd.Parameters.AddWithValue("@scope", "FS" + code);
                var val = cmd.ExecuteScalar();
                if (val != null && val != DBNull.Value)
                {
                    rb.TestProcByReportCode[code] = val.ToString().Trim();
                }
            }
        }

        private static string SubstituteTokens(string sql, int year, string factCode)
        {
            if (string.IsNullOrWhiteSpace(sql)) return sql;
            return sql
                .Replace("@SchoolYear", year.ToString())
                .Replace("@FactTypeOrReportCode", "'" + (factCode ?? "").Replace("'", "''") + "'");
        }

        private static string AsExec(string procCall)
        {
            string t = (procCall ?? "").Trim();
            return t.StartsWith("exec", StringComparison.OrdinalIgnoreCase) ? t : "EXEC " + t;
        }

        private static string SelectYearSql(int year, int dataMigrationTypeId)
        {
            return
                $"UPDATE RDS.DimSchoolYearDataMigrationTypes SET IsSelected = 0 WHERE DataMigrationTypeId = {dataMigrationTypeId};\n" +
                $"UPDATE dm SET IsSelected = 1 FROM RDS.DimSchoolYearDataMigrationTypes dm\n" +
                $"JOIN RDS.DimSchoolYears sy ON dm.DimSchoolYearId = sy.DimSchoolYearId\n" +
                $"WHERE sy.SchoolYear = {year} AND dm.DataMigrationTypeId = {dataMigrationTypeId};";
        }

        // Trusted, service-authored SQL (migration/report/validation runbook steps). No transaction
        // wrapper — these procs manage their own; and no guard, since the SQL is fixed by us, not the LLM.
        private string ExecuteAdminSql(string sql, int timeoutSeconds)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandTimeout = timeoutSeconds;
                cmd.ExecuteNonQuery();
                return null;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        private long? ExecuteScalarLong(string sql)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandTimeout = 120;
                var val = cmd.ExecuteScalar();
                return val == null || val == DBNull.Value ? (long?)null : Convert.ToInt64(val);
            }
            catch
            {
                return null;
            }
        }

        // Runs a SELECT (or proc returning a rowset) and formats the first result set as compact text.
        private string ReadTabular(string sql, int maxRows, out int rowCount)
        {
            rowCount = 0;
            var sb = new StringBuilder();
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandTimeout = 300;
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    rowCount++;
                    if (rowCount <= maxRows)
                    {
                        var cells = new List<string>();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            string v = reader.IsDBNull(i) ? "NULL" : reader.GetValue(i).ToString();
                            cells.Add($"{reader.GetName(i)}={v}");
                        }
                        sb.AppendLine(string.Join(" | ", cells));
                    }
                }
                if (rowCount > maxRows)
                {
                    sb.AppendLine($"… ({rowCount - maxRows} more row(s))");
                }
                if (rowCount == 0)
                {
                    sb.Append("(no rows)");
                }
            }
            catch (Exception ex)
            {
                sb.Append("(could not read results: " + ex.Message + ")");
            }
            return sb.ToString().TrimEnd();
        }

        // -------------------- Publish as stored procedure --------------------

        public EtlChatSession PublishProcedure(int etlChatSessionId)
        {
            var session = _appRepository.Find<EtlChatSession>(s => s.EtlChatSessionId == etlChatSessionId, 0, 0).FirstOrDefault();
            if (session == null)
            {
                return null;
            }
            TryPublishProcedure(session);
            _appRepository.Save();
            return session;
        }

        /// <summary>
        /// Wraps the session's validated ETL in CREATE OR ALTER PROCEDURE [Staging].[EtlChatLoad_&lt;map&gt;]
        /// and upserts an App.DataMigrationTasks row (staging type) so the Generate tool can run it.
        /// </summary>
        private void TryPublishProcedure(EtlChatSession session)
        {
            if (string.IsNullOrWhiteSpace(session.LastEtlSql))
            {
                return;
            }

            string guard = EtlSqlGuard.ValidateEtl(session.LastEtlSql);
            if (guard != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    "Not published: the ETL did not pass the safety guard (" + guard + ").");
                return;
            }

            var map = _appRepository.GetById<EtlMap>(session.EtlMapId);
            string mapLabel = map != null && !string.IsNullOrWhiteSpace(map.MapName) ? map.MapName : ("Map" + session.EtlMapId);
            string procName = "EtlChatLoad_" + Sanitize(mapLabel);
            string qualified = "Staging." + procName;

            // Fact type from the map's file-spec associations, else NA (-1)
            int factTypeId = _appRepository
                .FindReadOnly<EtlMapFileSpec>(f => f.EtlMapId == session.EtlMapId && f.DimFactTypeId != null, 0, 1)
                .Select(f => f.DimFactTypeId.Value)
                .DefaultIfEmpty(-1)
                .First();

            string createProc =
                $"CREATE OR ALTER PROCEDURE [Staging].[{procName}]\nAS\nBEGIN\n    SET NOCOUNT ON;\n\n" +
                session.LastEtlSql.Trim() + "\nEND";

            string description = $"Source-to-Staging ETL generated by the AI ETL Developer for map '{mapLabel}'" +
                (string.IsNullOrWhiteSpace(session.SourceObject) ? "" : $" (source {session.SourceObject})") + ".";

            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();

                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = createProc;
                    cmd.CommandTimeout = 120;
                    cmd.ExecuteNonQuery();
                }

                int taskId;
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
IF NOT EXISTS (SELECT 1 FROM App.DataMigrationTasks WHERE DataMigrationTypeId = 4 AND StoredProcedureName = @proc AND FactTypeId = @ft)
    INSERT INTO App.DataMigrationTasks
        (DataMigrationTypeId, IsActive, RunAfterGenerateMigration, RunBeforeGenerateMigration, StoredProcedureName, TaskSequence, IsSelected, Description, TaskName, FactTypeId)
    VALUES
        (4, 1, 0, 0, @proc, (SELECT ISNULL(MAX(TaskSequence), 0) + 1 FROM App.DataMigrationTasks), 1, @desc, @task, @ft);
ELSE
    UPDATE App.DataMigrationTasks SET Description = @desc, TaskName = @task, IsActive = 1
    WHERE DataMigrationTypeId = 4 AND StoredProcedureName = @proc AND FactTypeId = @ft;
SELECT DataMigrationTaskId FROM App.DataMigrationTasks WHERE DataMigrationTypeId = 4 AND StoredProcedureName = @proc AND FactTypeId = @ft;";
                    cmd.Parameters.AddWithValue("@proc", qualified);
                    cmd.Parameters.AddWithValue("@ft", factTypeId);
                    cmd.Parameters.AddWithValue("@desc", description);
                    cmd.Parameters.AddWithValue("@task", mapLabel);
                    taskId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                session.GeneratedProcedureName = qualified;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"📦 Published as stored procedure [{qualified}] and registered in App.DataMigrationTasks (task {taskId}, staging). The Generate tool can now run it (EXEC {qualified};).");
            }
            catch (Exception ex)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    "Failed to publish the stored procedure: " + ex.Message);
            }
        }

        private static string Sanitize(string name)
        {
            var chars = (name ?? "").Select(c => char.IsLetterOrDigit(c) ? c : '_').ToArray();
            string s = new string(chars);
            while (s.Contains("__")) s = s.Replace("__", "_");
            s = s.Trim('_');
            if (s.Length == 0) s = "Etl";
            if (char.IsDigit(s[0])) s = "N" + s;
            return s.Length > 100 ? s.Substring(0, 100) : s;
        }

        // -------------------- Prompt --------------------

        private List<OllamaMessage> BuildPrompt(EtlChatSession session)
        {
            var messages = new List<OllamaMessage>
            {
                new OllamaMessage { Role = EtlChatRole.System, Content = BuildSystemPrompt(session) }
            };

            // Replay recent transcript so the model can iterate
            var transcript = GetMessages(session.EtlChatSessionId);
            foreach (var m in transcript.Skip(Math.Max(0, transcript.Count - 24)))
            {
                string role = m.Role == EtlChatRole.User ? EtlChatRole.User
                            : m.Role == EtlChatRole.Assistant ? EtlChatRole.Assistant
                            : EtlChatRole.User; // tool feedback relayed as user context
                string prefix = m.Role == EtlChatRole.Tool ? "[EXECUTION RESULT] " : "";
                messages.Add(new OllamaMessage { Role = role, Content = prefix + (m.Content ?? "") });
            }

            messages.Add(new OllamaMessage
            {
                Role = EtlChatRole.User,
                Content = "Produce the next attempt now. Respond with ONLY the JSON object described in the system prompt."
            });
            return messages;
        }

        private string BuildSystemPrompt(EtlChatSession session)
        {
            var sb = new StringBuilder();
            sb.AppendLine("You are a senior Microsoft SQL Server ETL developer. You write T-SQL that loads a source dataset into a CEDS-aligned data warehouse Staging schema, then validates the load.");
            sb.AppendLine();

            // Scope: the LLM owns only Step 2 (Source -> Staging). The service runs steps 3-4 automatically.
            var runbook = ResolveRunbook(session.EtlMapId);
            sb.AppendLine("## Your job (Step 2 of the fact-type runbook)");
            if (runbook.IsResolved)
            {
                sb.AppendLine($"- Fact type: {runbook.FactTypeCode}" +
                              (runbook.ReportCodes.Count > 0 ? $" (EDFacts files: {string.Join(", ", runbook.ReportCodes)})" : ""));
            }
            sb.AppendLine("- You ONLY build and run the Source→Staging load. When your staging row count matches the source, you are done.");
            sb.AppendLine("- Do NOT write migration, RDS/warehouse, report, lock, or test SQL. After your staging load matches, the system AUTOMATICALLY runs staging validation, the Staging→RDS migration, report generation, and the official test case — you do not need to (and must not) do those.");
            sb.AppendLine();
            sb.AppendLine("## Source");
            sb.AppendLine($"- Connection/descriptor: {session.SourceConnection ?? "(ask the user)"}");
            sb.AppendLine($"- Source object (table/view/query): {session.SourceObject ?? "(ask the user)"}");
            sb.AppendLine();
            sb.AppendLine("## Field mappings (source -> CEDS -> Staging destination)");

            var mappings = _mappingService.GetAllMappings(session.EtlMapId);
            var stagingTables = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in mappings.Where(m => !string.IsNullOrWhiteSpace(m.StagingTableColumns)))
            {
                sb.AppendLine($"- Source '{m.SourceElementName}'" +
                              (string.IsNullOrWhiteSpace(m.SourceTableName) ? "" : $" [{m.SourceTableName}.{m.SourceColumnName}]") +
                              $" -> CEDS {m.CedsElementName} ({m.CedsElementGlobalId}) -> Staging {m.StagingTableColumns}");
                foreach (var tc in m.StagingTableColumns.Split(';'))
                {
                    string t = tc.Trim().Split('.').FirstOrDefault();
                    if (!string.IsNullOrWhiteSpace(t)) stagingTables.Add(t.Trim());
                }
                var opts = (m.EtlSourceOptionSetMappings ?? new List<EtlSourceOptionSetMapping>())
                    .Where(o => !string.IsNullOrWhiteSpace(o.CedsOptionSetCode))
                    .Select(o => $"'{o.SourceOptionSetCode}'->'{o.CedsOptionSetCode}'");
                if (opts.Any())
                {
                    sb.AppendLine($"    option set value map: {string.Join(", ", opts)}");
                }
            }
            if (mappings.All(m => string.IsNullOrWhiteSpace(m.StagingTableColumns)))
            {
                sb.AppendLine("- (no accepted Staging mappings yet — ask the user to confirm the target if unclear)");
            }

            sb.AppendLine();
            sb.AppendLine("## Target");
            sb.AppendLine($"- Write ONLY to the Staging schema. Target table(s): {(stagingTables.Count > 0 ? string.Join(", ", stagingTables.Select(t => "Staging." + t)) : "(from the mappings above)")}");
            sb.AppendLine();
            sb.AppendLine("## Rules");
            sb.AppendLine("- Dialect: T-SQL (SQL Server). Make the ETL idempotent (e.g., DELETE the target rows for this load then INSERT, or MERGE) so re-runs do not double-count.");
            sb.AppendLine("- Apply the option set value maps above when transforming coded values.");
            sb.AppendLine("- Do NOT use DROP, TRUNCATE, ALTER, EXEC, xp_ procedures, or write outside the Staging schema.");
            sb.AppendLine("- The test must be a single read-only SELECT returning exactly two integer columns named SourceCount and StagingCount, where SourceCount is the number of source rows expected and StagingCount is the number actually loaded. The load is correct when SourceCount = StagingCount.");
            sb.AppendLine("- If you are missing information you need (source schema, keys, filters), ASK via the questions array instead of guessing.");
            sb.AppendLine();
            sb.AppendLine("## Response format");
            sb.AppendLine("Respond with ONLY a single JSON object (no markdown fences), with keys:");
            sb.AppendLine("{\"questions\": [string], \"etlSql\": string, \"testSql\": string, \"explanation\": string}");
            sb.AppendLine("If you have blocking questions, populate \"questions\" and leave etlSql/testSql empty.");
            return sb.ToString();
        }

        private static EtlChatModelReply ParseReply(string reply)
        {
            var result = new EtlChatModelReply();
            if (string.IsNullOrWhiteSpace(reply))
            {
                return result;
            }

            string json = ExtractJson(reply);
            if (json != null)
            {
                try
                {
                    using var doc = JsonDocument.Parse(json);
                    var root = doc.RootElement;
                    if (root.TryGetProperty("questions", out var q) && q.ValueKind == JsonValueKind.Array)
                    {
                        result.Questions = q.EnumerateArray().Select(e => e.GetString()).Where(s => !string.IsNullOrWhiteSpace(s)).ToList();
                    }
                    result.EtlSql = GetStr(root, "etlSql");
                    result.TestSql = GetStr(root, "testSql");
                    result.Explanation = GetStr(root, "explanation");
                    return result;
                }
                catch
                {
                    // fall through to treat as plain text
                }
            }

            result.Explanation = reply.Trim();
            return result;
        }

        private static string GetStr(JsonElement root, string name)
        {
            return root.TryGetProperty(name, out var el) && el.ValueKind == JsonValueKind.String ? el.GetString() : null;
        }

        private static string ExtractJson(string text)
        {
            var fence = Regex.Match(text, "```(?:json)?\\s*(\\{.*\\})\\s*```", RegexOptions.Singleline);
            if (fence.Success)
            {
                return fence.Groups[1].Value;
            }
            int start = text.IndexOf('{');
            int end = text.LastIndexOf('}');
            return start >= 0 && end > start ? text.Substring(start, end - start + 1) : null;
        }

        // -------------------- SQL execution --------------------

        private string ExecuteNonQuery(string sql)
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var tran = conn.BeginTransaction();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.Transaction = tran;
                    cmd.CommandText = sql;
                    cmd.CommandTimeout = 300;
                    cmd.ExecuteNonQuery();
                }
                tran.Commit();
                return null;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        private string RunTest(string sql, out long? sourceCount, out long? stagingCount)
        {
            sourceCount = null;
            stagingCount = null;
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandTimeout = 300;
                using var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    int srcOrd = FindOrdinal(reader, new[] { "source" }, 0);
                    int stgOrd = FindOrdinal(reader, new[] { "stag", "target", "dest", "loaded" }, 1);
                    sourceCount = srcOrd >= 0 && !reader.IsDBNull(srcOrd) ? Convert.ToInt64(reader.GetValue(srcOrd)) : (long?)null;
                    stagingCount = stgOrd >= 0 && !reader.IsDBNull(stgOrd) ? Convert.ToInt64(reader.GetValue(stgOrd)) : (long?)null;
                }
                return null;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        private static int FindOrdinal(SqlDataReader reader, string[] namePartsInPriority, int fallbackIndex)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                string name = reader.GetName(i).ToLowerInvariant();
                if (namePartsInPriority.Any(p => name.Contains(p)))
                {
                    return i;
                }
            }
            return fallbackIndex < reader.FieldCount ? fallbackIndex : -1;
        }

        // Progress messages are committed immediately so a polling UI can show each step live
        // (prompting, SQL produced, executing, test counts, pass/fail) as it happens rather than
        // all at once when the iteration returns.
        private EtlChatMessage AddMessage(int sessionId, string role, string type, int? iteration, string content)
        {
            var message = _appRepository.Create(new EtlChatMessage
            {
                EtlChatSessionId = sessionId,
                Role = role,
                MessageType = type,
                IterationNumber = iteration,
                Content = content,
                CreatedDate = DateTime.UtcNow
            });
            _appRepository.Save();
            return message;
        }
    }
}
