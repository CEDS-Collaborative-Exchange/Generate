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
        private readonly int _adminTimeoutSeconds;

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
            // Timeout (seconds) for the long deterministic steps (RDS wrapper, create_reports, test case).
            _adminTimeoutSeconds = int.TryParse(configuration["EtlChat:AdminTimeoutSeconds"], out var at) && at > 0 ? at : 3600;
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

        // Columns the migration derives/defaults itself, so they don't need a source→Staging mapping even
        // when NOT NULL. Missing these is not a coverage gap (the ETL fills them from context or GETDATE()).
        private static readonly HashSet<string> AutoDerivedStagingColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "SchoolYear", "RecordStartDateTime", "RecordEndDateTime"
        };

        public EtlMappingCoverageDto ComputeCoverage(int etlMapId)
        {
            var dto = new EtlMappingCoverageDto { EtlMapId = etlMapId };
            var rb = ResolveRunbook(etlMapId);
            if (rb == null || string.IsNullOrWhiteSpace(rb.FactTypeCode))
            {
                dto.Resolved = false;
                dto.Summary = "This map isn't linked to a fact type / file spec yet, so required Staging tables can't be determined. Link a file spec on the map to enable the readiness check.";
                return dto;
            }

            dto.FactTypeCode = rb.FactTypeCode;
            dto.ReportCodes = rb.ReportCodes != null && rb.ReportCodes.Count > 0 ? string.Join(", ", rb.ReportCodes) : null;

            var required = GetRequiredStagingColumns(rb);   // (Table, Column, Nullable), identity excluded
            if (required.Count == 0)
            {
                dto.Resolved = false;
                dto.Summary = $"No Staging requirements are published for {rb.FactTypeCode} in app.vwStagingRelationships, so coverage can't be verified. The AI session can still attempt the load.";
                return dto;
            }
            dto.Resolved = true;

            var mappedColumns = GetMappedStagingColumns(etlMapId);            // set of "Table.Column"
            var mappedTables = new HashSet<string>(GetMappedStagingTables(etlMapId), StringComparer.OrdinalIgnoreCase);

            var requiredTables = required.Select(r => r.Table).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
            dto.RequiredTableCount = requiredTables.Count;
            dto.RequiredTables = requiredTables;

            foreach (var table in requiredTables)
            {
                if (mappedTables.Contains(table)) dto.CoveredTables.Add(table);
                else dto.MissingTables.Add(table);
            }
            dto.MappedRequiredTableCount = dto.CoveredTables.Count;

            // For tables that ARE mapped, flag any required NOT NULL business column with no mapping (a
            // likely gap). Skip auto-derived columns and skip tables that are entirely unmapped (already
            // reported at the table level — no need to list every one of their columns).
            foreach (var r in required)
            {
                if (r.Nullable) continue;
                if (AutoDerivedStagingColumns.Contains(r.Column)) continue;
                if (!mappedTables.Contains(r.Table)) continue;               // whole table missing — reported above
                if (!mappedColumns.Contains(r.Table + "." + r.Column))
                    dto.MissingRequiredColumns.Add(r.Table + "." + r.Column);
            }

            dto.IsReady = dto.MissingTables.Count == 0 && dto.MissingRequiredColumns.Count == 0;

            if (dto.IsReady)
            {
                dto.Summary = $"Ready — the map covers all {dto.RequiredTableCount} Staging table(s) required for {dto.FactTypeCode}.";
            }
            else
            {
                var parts = new List<string>();
                if (dto.MissingTables.Count > 0)
                    parts.Add($"{dto.MissingTables.Count} required Staging table(s) not mapped ({string.Join(", ", dto.MissingTables.Select(t => "Staging." + t))})");
                if (dto.MissingRequiredColumns.Count > 0)
                    parts.Add($"{dto.MissingRequiredColumns.Count} required NOT NULL column(s) not mapped ({string.Join(", ", dto.MissingRequiredColumns.Take(12))}{(dto.MissingRequiredColumns.Count > 12 ? ", …" : "")})");
                dto.Summary = "Not ready — " + string.Join("; ", parts) +
                    ". The end-to-end migration for this file spec cannot complete until these are mapped to a source.";
            }
            return dto;
        }

        // The authoritative required Staging tables/columns for a fact type / report code(s), from
        // app.vwStagingRelationships. Identity columns are excluded (never source-mapped).
        private List<(string Table, string Column, bool Nullable)> GetRequiredStagingColumns(EtlFactTypeRunbook rb)
        {
            var list = new List<(string, string, bool)>();
            if (rb == null || string.IsNullOrWhiteSpace(rb.FactTypeCode)) return list;
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                string codeFilter = "";
                if (rb.ReportCodes != null && rb.ReportCodes.Count > 0)
                {
                    var ins = new List<string>();
                    for (int i = 0; i < rb.ReportCodes.Count; i++)
                    {
                        string p = "@rc" + i;
                        ins.Add(p);
                        cmd.Parameters.AddWithValue(p, rb.ReportCodes[i]);
                    }
                    codeFilter = $" AND r.ReportCode IN ({string.Join(",", ins)})";
                }
                cmd.CommandText =
                    @"SELECT DISTINCT r.StagingTableName, r.StagingColumnName, c.IS_NULLABLE,
                             COLUMNPROPERTY(OBJECT_ID('Staging.' + r.StagingTableName), r.StagingColumnName, 'IsIdentity') AS IsIdentity
                      FROM app.vwStagingRelationships r
                      LEFT JOIN INFORMATION_SCHEMA.COLUMNS c
                        ON c.TABLE_SCHEMA = 'Staging' AND c.TABLE_NAME = r.StagingTableName AND c.COLUMN_NAME = r.StagingColumnName
                      WHERE r.FactTypeCode = @ft" + codeFilter;
                cmd.Parameters.AddWithValue("@ft", rb.FactTypeCode);
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string table = reader.IsDBNull(0) ? "" : reader.GetString(0);
                    string col = reader.IsDBNull(1) ? "" : reader.GetString(1);
                    if (string.IsNullOrWhiteSpace(table) || string.IsNullOrWhiteSpace(col)) continue;
                    bool isIdentity = !reader.IsDBNull(3) && Convert.ToInt32(reader.GetValue(3)) == 1;
                    if (isIdentity) continue;
                    bool nullable = reader.IsDBNull(2) || reader.GetString(2).Equals("YES", StringComparison.OrdinalIgnoreCase);
                    list.Add((table.Trim(), col.Trim(), nullable));
                }
            }
            catch
            {
                // best-effort — coverage is advisory
            }
            return list;
        }

        // Set of "Table.Column" the map's element mappings target in Staging.
        // Parse a StagingTableColumns value ("Table.Col; Table2.Col2; …") into normalized "Table.Column"
        // pairs (an optional leading "Staging." schema qualifier is stripped).
        private static List<string> ParseStagingPairs(string stagingTableColumns)
        {
            var pairs = new List<string>();
            if (string.IsNullOrWhiteSpace(stagingTableColumns)) return pairs;
            foreach (var tc in stagingTableColumns.Split(';'))
            {
                string pair = tc.Trim();
                if (pair.Length == 0) continue;
                if (pair.StartsWith("Staging.", StringComparison.OrdinalIgnoreCase)) pair = pair.Substring("Staging.".Length);
                if (pair.IndexOf('.') > 0) pairs.Add(pair);
            }
            return pairs;
        }

        private static string TableOf(string pair)
        {
            int dot = pair.IndexOf('.');
            return dot > 0 ? pair.Substring(0, dot).Trim() : pair.Trim();
        }

        // The "active" staging tables for a map: those a source element maps to with a DISCRETE 1-to-1
        // mapping (its StagingTableColumns resolves to exactly one table). Ubiquitous CEDS elements
        // (School/Student/LEA Identifier, School Year, …) fan out to EVERY staging table that has that
        // column, which clutters the UI and misleads the LLM. We treat only tables anchored by a discrete
        // mapping as real targets, then prune the fan-out elements to just those tables (PruneToActive).
        private HashSet<string> GetActiveStagingTables(int etlMapId)
        {
            var active = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in _mappingService.GetAllMappings(etlMapId))
            {
                var pairs = ParseStagingPairs(m.StagingTableColumns);
                if (pairs.Count == 0) continue;
                var tables = pairs.Select(TableOf).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
                if (tables.Count == 1) active.Add(tables[0]);   // discrete 1-to-1 → this table is real
            }
            return active;
        }

        // Filters a StagingTableColumns value to only the pairs whose table is allowed for the map.
        private List<string> PruneToActive(string stagingTableColumns, HashSet<string> allowed)
        {
            return ParseStagingPairs(stagingTableColumns).Where(p => allowed.Contains(TableOf(p))).ToList();
        }

        // The Staging tables we let the model see/target: ACTIVE (anchored by a discrete 1-to-1 mapping)
        // INTERSECTED with the file-spec REQUIRED tables when a file spec is resolved. This drops both the
        // ubiquitous-identifier fan-out (non-active) AND any active-but-not-required table (e.g. a stray
        // automatch to K12StaffAssignment on a membership map). When no file spec is resolved, falls back
        // to active-only so a map without a linked file spec still works.
        private HashSet<string> AllowedStagingTables(int etlMapId)
        {
            var active = GetActiveStagingTables(etlMapId);
            var rb = ResolveRunbook(etlMapId);
            var required = new HashSet<string>(GetRequiredStagingColumns(rb).Select(r => r.Table), StringComparer.OrdinalIgnoreCase);
            if (required.Count > 0) active.IntersectWith(required);
            return active;
        }

        private HashSet<string> GetMappedStagingColumns(int etlMapId)
        {
            var allowed = AllowedStagingTables(etlMapId);
            var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in _mappingService.GetAllMappings(etlMapId).Where(x => !string.IsNullOrWhiteSpace(x.StagingTableColumns)))
                foreach (var pair in PruneToActive(m.StagingTableColumns, allowed))
                    set.Add(pair);
            return set;
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

            string text = message.Content.Trim();
            AddMessage(etlChatSessionId, EtlChatRole.User, EtlChatMessageType.Chat, null, text);

            // Interpret control directives so the user can steer any step — especially to recover a
            // stuck/timed-out later step: change the year, retry, skip, or restart. The next run() then
            // re-dispatches to session.CurrentPhase and picks up any change.
            ApplyUserDirectives(session, text);

            if (session.Status == EtlChatSessionStatus.AwaitingInput || session.Status == EtlChatSessionStatus.Completed)
            {
                session.Status = EtlChatSessionStatus.Active;
            }
            session.ModifiedDate = DateTime.UtcNow;
            session.ModifiedBy = message.CreatedBy;
            _appRepository.Save();
            return session;
        }

        public void NotifyStopped(int etlChatSessionId)
        {
            var session = _appRepository.Find<EtlChatSession>(s => s.EtlChatSessionId == etlChatSessionId, 0, 0).FirstOrDefault();
            if (session == null)
            {
                return;
            }
            if (session.Status != EtlChatSessionStatus.Completed)
            {
                session.Status = EtlChatSessionStatus.AwaitingInput;
            }
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            AddMessage(etlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                "⏹️ Stopped by request. Send an instruction (e.g. \"retry\", \"use 2027\", \"skip\") or Run to resume.");
        }

        // Parses plain-language control directives from a user message and updates the session so the
        // next iteration acts on them. Deterministic (no LLM) so recovery works even if Ollama is down.
        private void ApplyUserDirectives(EtlChatSession session, string text)
        {
            string lower = text.ToLowerInvariant();

            // Year override: "run for 2027", "use 2027", "2027 not 2026", etc. (guarded by a year-context word).
            var ym = Regex.Match(text, @"\b(20\d{2})\b");
            if (ym.Success && int.TryParse(ym.Value, out int yr) && yr != (session.SchoolYear ?? 0)
                && Regex.IsMatch(lower, @"\b(year|run|use|for|migrat|report|sy|instead|not)\b"))
            {
                session.SchoolYear = yr;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"👍 Got it — using school year {yr} from here on.");
            }

            // Restart the whole run from the staging load (e.g. to rebuild for a new year).
            if (Regex.IsMatch(lower, @"\b(start over|restart|from the (beginning|start)|rebuild the load|redo the load)\b"))
            {
                session.CurrentPhase = EtlChatPhase.StagingLoad;
                session.CurrentLoop = 0;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "🔄 Restarting from the staging load.");
            }
            // Skip the current (e.g. failing) step and move to the next phase.
            else if (Regex.IsMatch(lower, @"\b(skip|move past|bypass)\b") && !string.IsNullOrWhiteSpace(session.CurrentPhase))
            {
                string next = NextPhase(session.CurrentPhase);
                if (next != null)
                {
                    string from = session.CurrentPhase;
                    session.CurrentPhase = next;
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                        $"⏭️ Skipping {from} — moving to {next}.");
                }
            }
        }

        private static string NextPhase(string phase)
        {
            switch (phase)
            {
                case EtlChatPhase.StagingLoad: return EtlChatPhase.StagingValidate;
                case EtlChatPhase.StagingValidate: return EtlChatPhase.RdsMigrate;
                case EtlChatPhase.RdsMigrate: return EtlChatPhase.RdsValidate;
                case EtlChatPhase.RdsValidate: return EtlChatPhase.ReportMigrate;
                case EtlChatPhase.ReportMigrate: return EtlChatPhase.ReportValidate;
                case EtlChatPhase.ReportValidate: return EtlChatPhase.Done;
                default: return null;
            }
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

            // At a later (deterministic) step, the user can steer in plain English:
            //  • "do it" / "yes" / "apply" → run the fix the bot last proposed, then retry the step.
            //  • any other free-form guidance → the LLM generates & runs corrective Staging SQL, then retries.
            // (StagingLoad already consumes user guidance in its own loop.)
            if (phase != EtlChatPhase.StagingLoad)
            {
                if (LastMessageIsApproval(session))
                {
                    return ApplyLastProposedFix(session, result, phase);
                }
                if (LastMessageIsFreeFormUserGuidance(session))
                {
                    return await RunAssistPhaseAsync(session, result, phase);
                }
            }

            // The run is a phase machine following the fact-type doc (steps 2-4). Each call advances one
            // phase and returns CanContinue=true so the client auto-runs the next, stopping only when the
            // final validation passes (Done), the bot needs input, or it hits a genuine problem.
            EtlChatIterationResultDto r;
            switch (phase)
            {
                case EtlChatPhase.StagingValidate: r = RunStagingValidatePhase(session, result); break;
                case EtlChatPhase.RdsMigrate: r = RunRdsMigratePhase(session, result); break;
                case EtlChatPhase.RdsValidate: r = RunRdsValidatePhase(session, result); break;
                case EtlChatPhase.ReportMigrate: r = RunReportMigratePhase(session, result); break;
                case EtlChatPhase.ReportValidate: r = RunReportValidatePhase(session, result); break;
                default: return await RunStagingLoadPhaseAsync(session, result);
            }

            // Whenever a deterministic step hits a problem, the LLM (best-effort, read-only) proposes a fix
            // the user can approve with "do it" — so help is always available at every phase.
            if (r.Outcome == EtlChatIterationOutcome.Failed && r.Status == EtlChatSessionStatus.AwaitingInput)
            {
                await AutoProposeFixAsync(session, phase);
            }
            return r;
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

            // Readiness preflight (authoring): ONCE per session, verify the map actually covers every
            // Staging table the target file spec's end-to-end migration requires. If a required table was
            // never mapped, the report migration can NEVER succeed — surface that up front so the user can
            // fix the mapping instead of watching a whole session run to a dead end.
            PostCoveragePreflightOnce(session);

            // Context phase (authoring): gather grounding context from the ETL map + source ONCE and post
            // it as a visible step, so it's in the transcript the prompt replays — the model builds the load
            // from real schema/values instead of guessing.
            PostPhase1ContextOnce(session);

            // Per-table chunked build: drive ONE mapped Staging table per iteration. The transcript replay
            // gives the model conversational context (prior chunks it wrote, lookup results, execution errors),
            // so it builds/fixes the CURRENT table incrementally instead of re-deriving a whole multi-table
            // script each turn (which small models can't do — that caused the repeat-the-same-thing loop).
            var mappedTables = GetMappedStagingTables(session.EtlMapId);
            if (mappedTables.Count == 0)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop,
                    "No Staging tables are mapped for this map — there is nothing to load. Map at least one source element to a Staging column, then retry.");
                session.Status = EtlChatSessionStatus.AwaitingInput;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                return result;
            }
            var remainingTables = MappedTablesNotInserted(session.EtlMapId, session.LastEtlSql ?? "");
            var loadedTables = mappedTables.Where(t => !remainingTables.Any(r => string.Equals(r, t, StringComparison.OrdinalIgnoreCase))).ToList();
            string currentTable = remainingTables.FirstOrDefault() ?? mappedTables[0];
            int tableIndex = mappedTables.FindIndex(t => string.Equals(t, currentTable, StringComparison.OrdinalIgnoreCase)) + 1;

            // Build the conversation (system + replayed transcript + a focused nudge for THIS table) and call
            // the model. Stream the response into a single live "thinking" message so the user can watch it.
            var messages = BuildPrompt(session, BuildPerTableNudge(session, currentTable, tableIndex, mappedTables.Count, loadedTables));
            var liveMessage = AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                $"🧠 Asking the model ({_ollama.Model}) to build Staging.{currentTable} ({tableIndex} of {mappedTables.Count})…");
            string reply;
            try
            {
                reply = await _ollama.ChatAsync(messages, accumulated =>
                {
                    // Show the tail of what the model is producing so progress is visible.
                    string tail = accumulated.Length > 600 ? "…" + accumulated.Substring(accumulated.Length - 600) : accumulated;
                    liveMessage.Content = $"🧠 The model is responding… ({accumulated.Length:N0} characters so far)\n\n{tail}";
                    liveMessage.CreatedDate = DateTime.Now;
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

            // Chunks are DECLARE-free by instruction — the stitched final script carries exactly one
            // @SchoolYear DECLARE at the top. Strip any DECLARE the model added anyway; a temporary one is
            // prepended only for standalone chunk execution below.
            if (!string.IsNullOrWhiteSpace(parsed.EtlSql))
            {
                parsed.EtlSql = StripYearDeclare(parsed.EtlSql);
            }

            if (!string.IsNullOrWhiteSpace(parsed.Explanation))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, session.CurrentLoop, parsed.Explanation.Trim());
            }

            // Bot wants to inspect the schema/data first -> run the read-only lookup and loop back with results.
            if (!string.IsNullOrWhiteSpace(parsed.LookupSql))
            {
                string lookupGuard = EtlSqlGuard.ValidateReadOnly(parsed.LookupSql);
                if (lookupGuard != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                        "Lookup rejected (must be a read-only SELECT): " + lookupGuard);
                    return FailOrContinue(session, result, "Lookup rejected; asking the model to try again.");
                }
                // Count the inspection as a loop so lookups are bounded by MaxLoops.
                session.CurrentLoop += 1;
                result.IterationNumber = session.CurrentLoop;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Sql, session.CurrentLoop,
                    "-- 🔎 SCHEMA LOOKUP\n" + parsed.LookupSql.Trim());
                string rows = ReadTabular(parsed.LookupSql, 50, out int rowCount);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                    $"🔎 Lookup results ({rowCount} row(s)):\n" + rows);
                _appRepository.Save();
                return StayAndContinue(session, result, EtlChatPhase.StagingLoad, "Inspected the schema — continuing to build the ETL.");
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

            // Deterministic backstop BEFORE execution: repair a `<source_table>`-style placeholder in the
            // FROM clause using the known source object (the #1 small-model failure → "Incorrect syntax
            // near '<'"). If it can't resolve, feed a focused correction back and retry THIS table.
            var placeholderFix = FixSourcePlaceholders(session, parsed.EtlSql);
            if (placeholderFix.Blocked)
            {
                var names = ResolveSourceObjects(session);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    $"Staging.{currentTable}: your SQL contains a placeholder like `<source_table>`. Use the REAL source object name(s) verbatim in FROM/JOIN: " +
                    (names.Count > 0 ? string.Join(", ", names) : "the source object shown in the ## Source section above") +
                    $". Re-send just the ```sql block for Staging.{currentTable} with the actual name(s).");
                return FailOrContinue(session, result, $"Staging.{currentTable}: <source_table> placeholder — asked the model to use the real source name.");
            }
            if (placeholderFix.Note != null)
            {
                parsed.EtlSql = StripYearDeclare(placeholderFix.Sql);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, placeholderFix.Note);
            }

            // Pre-run REVIEW: have the model review its own chunk for Microsoft T-SQL bugs, grounded in the
            // real Staging targets. Best-effort. (Strip any DECLARE review may reintroduce.)
            if (_allowSqlExecution)
            {
                parsed.EtlSql = StripYearDeclare(await ReviewEtlSqlAsync(session, parsed.EtlSql));
            }

            // Completeness backstop: the chunk for THIS table MUST insert into it. A delete-only chunk —
            // e.g. the model split the INSERT into a separate block, or the review dropped it — would run a
            // DELETE that removes the year's rows, leave the table empty, mark it "loaded", and then loop
            // forever (the table is still uninserted). Refuse it and ask for the complete DELETE+INSERT.
            bool insertsCurrent = Regex.IsMatch(parsed.EtlSql ?? "",
                @"(?i)\b(insert\s+into|merge\s+(into\s+)?)\s*(\[?Staging\]?\.)?\[?" + Regex.Escape(currentTable) + @"\]?\b");
            if (!insertsCurrent)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    $"The script for Staging.{currentTable} has no INSERT INTO Staging.{currentTable} — running only the DELETE would leave the table empty. " +
                    $"Re-send the COMPLETE load for Staging.{currentTable} in ONE ```sql block: the `DELETE FROM Staging.{currentTable} WHERE SchoolYear = @SchoolYear;` FOLLOWED BY the `INSERT INTO Staging.{currentTable} (...columns...) SELECT ... FROM <source>;`.");
                return FailOrContinue(session, result, $"Staging.{currentTable}: chunk had no INSERT — asked the model for the complete load.");
            }

            // Loop-break: if the model re-sent SQL identical to the previous attempt that already failed
            // (and the deterministic backstops above couldn't change it), stop re-running the same failing
            // SQL — pause and hand back with specific guidance instead of burning loops in an idempotent cycle.
            if (_allowSqlExecution && IsRepeatOfLastFailedChunk(session, currentTable, parsed.EtlSql))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop,
                    $"⛔ Stuck on Staging.{currentTable}: this attempt is identical to the previous one that just failed, so I stopped re-running it. " +
                    "Read the execution error above and change the SPECIFIC expression it names — e.g. for a bit column, feed it `CASE WHEN <sourceCol> IN ('Y','1') THEN 1 ELSE 0 END` instead of the raw value — then resend, or edit the SQL manually.");
                session.Status = EtlChatSessionStatus.AwaitingInput;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                return result;
            }

            // We have a chunk for this table: count a development loop and show it.
            session.CurrentLoop += 1;
            result.IterationNumber = session.CurrentLoop;
            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Sql, session.CurrentLoop,
                $"-- ETL SQL (Staging.{currentTable})\n" + parsed.EtlSql.Trim());

            int year = ResolveSchoolYear(session);
            string declareLine = $"DECLARE @SchoolYear SMALLINT = {year};";

            if (!_allowSqlExecution)
            {
                // Can't validate per-chunk; accumulate into the stitched script and let the user run it.
                AccumulateChunk(session, declareLine, parsed.EtlSql);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "SQL execution is disabled (EtlChat:AllowSqlExecution=false). Review and run the SQL above manually.");
                session.Status = EtlChatSessionStatus.AwaitingInput;
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.AwaitingInput;
                result.Status = session.Status;
                result.CanContinue = false;
                return result;
            }

            // Execute the chunk (guarded, Staging-scoped), prepending a temporary @SchoolYear DECLARE so the
            // standalone chunk runs. On error, feed it back and retry THIS table conversationally — NOT a
            // whole-script redo (that was the idempotency loop).
            string guardError = EtlSqlGuard.ValidateEtl(parsed.EtlSql);
            if (guardError != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, $"Staging.{currentTable}: rejected ETL SQL: " + guardError);
                return FailOrContinue(session, result, $"Staging.{currentTable}: rejected by safety guard: {guardError}");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"⚙️ Executing the Staging.{currentTable} load…");
            string execError = ExecuteNonQuery(declareLine + "\r\n" + parsed.EtlSql);
            if (execError != null)
            {
                // Point the model at the specific fix for the recurring bit-conversion error so it can
                // correct the exact expression rather than re-sending the same SQL.
                string hint = Regex.IsMatch(execError, @"(?i)to data type bit")
                    ? $"\n\nThat error means a `bit` column is being fed a non-1/0 value (a text/'' result or a raw source value). Find the offending SELECT expression for that bit column and make it evaluate to ONLY 1, 0, or NULL — e.g. `CASE WHEN <src>='Y' THEN 1 WHEN <src>='N' THEN 0 ELSE NULL END`. Use the source sample values to pick the right true/false mapping; a bit column's CASE must never return '' or the raw text. Change ONLY that expression."
                    : $"\n\nFix ONLY the Staging.{currentTable} block and re-send just its ```sql — keep whatever already worked.";
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    $"Staging.{currentTable} load error:\n" + execError + hint);
                return FailOrContinue(session, result, $"Staging.{currentTable} failed to execute; feeding the error back to the model.");
            }

            // Chunk executed cleanly — accumulate it into the stitched script (one DECLARE at the top).
            AccumulateChunk(session, declareLine, parsed.EtlSql);
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                $"✅ Loaded Staging.{currentTable}.");
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();

            // More mapped tables to load? Stay in StagingLoad and build the next one next iteration — the
            // transcript now carries this table's working SQL, so the model keeps context and only needs to
            // produce the next (small, focused) chunk.
            var stillRemaining = MappedTablesNotInserted(session.EtlMapId, session.LastEtlSql);
            if (stillRemaining.Count > 0)
            {
                return StayAndContinue(session, result, EtlChatPhase.StagingLoad,
                    $"Loaded Staging.{currentTable}. {stillRemaining.Count} table(s) left: " + string.Join(", ", stillRemaining.Select(t => "Staging." + t)) + ".");
            }

            // Every mapped table is loaded — publish the stitched procedure and advance the runbook.
            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                $"✅ All {mappedTables.Count} mapped Staging table(s) loaded. Advancing to validation.");
            _appRepository.Save();

            // Materialize the validated ETL as an executable, registered stored procedure.
            TryPublishProcedure(session);

            // Advance to the rest of the fact-type runbook (validate → RDS → reports → test).
            return Advance(session, result, EtlChatPhase.StagingValidate,
                "Staging loaded (all mapped tables) — moving on to validation, the warehouse migration, reports, and the official test.");
        }

        // Append an executed per-table chunk to the session's stitched ETL script, ensuring exactly one
        // @SchoolYear DECLARE at the top. This accumulator becomes the published stored-procedure body.
        private void AccumulateChunk(EtlChatSession session, string declareLine, string chunk)
        {
            chunk = StripYearDeclare(chunk ?? "").Trim();
            if (chunk.Length == 0) return;
            string existing = session.LastEtlSql ?? "";
            if (string.IsNullOrWhiteSpace(existing) || !Regex.IsMatch(existing, @"DECLARE\s+@SchoolYear", RegexOptions.IgnoreCase))
            {
                existing = declareLine;
            }
            session.LastEtlSql = existing.TrimEnd() + "\r\n\r\n" + chunk;
        }

        // -------------------- LLM assist / recovery at a paused later step --------------------
        // When the user gives free-form guidance at a deterministic step (e.g. "populate Staging.StateDetail"),
        // the LLM turns it into corrective Staging SQL, runs it, and the step is retried.

        private async Task<EtlChatIterationResultDto> RunAssistPhaseAsync(EtlChatSession session, EtlChatIterationResultDto result, string phase)
        {
            int year = ResolveSchoolYear(session);
            var msgs = GetMessages(session.EtlChatSessionId);
            string instruction = msgs.LastOrDefault(m => m.Role == EtlChatRole.User)?.Content?.Trim() ?? "";
            string lastError = msgs.LastOrDefault(m => m.MessageType == EtlChatMessageType.Error)?.Content ?? "(none)";

            if (!_ollama.IsConfigured)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "I can't act on that guidance (the model isn't configured); retrying the step as-is. To change the year say \"use 2027\", or \"skip\".");
                return StayAndContinue(session, result, phase, "Retrying the step.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"🛠️ Acting on your guidance at the '{phaseLabelFor(phase)}' step…");

            // Context phase (bug): gather + post the real schema of the objects the guidance/error references,
            // so the corrective SQL is grounded (this same context is fed into the model prompt below).
            string dbgSchema = GatherSchemaContext(instruction + " " + (lastError ?? ""));
            if (!string.IsNullOrWhiteSpace(dbgSchema))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "🔎 Context gathered from INFORMATION_SCHEMA for the referenced objects:\n" + dbgSchema);
            }

            var prompt = BuildAssistPrompt(phase, year, instruction, lastError);
            var live = AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                "🧠 Working out how to apply your guidance…");
            string reply;
            try
            {
                reply = await _ollama.ChatAsync(prompt, acc =>
                {
                    string tail = acc.Length > 600 ? "…" + acc.Substring(acc.Length - 600) : acc;
                    live.Content = $"🧠 Proposing a fix… ({acc.Length:N0} chars)\n\n{tail}";
                    live.CreatedDate = DateTime.Now;
                    _appRepository.Save();
                });
            }
            catch (Exception ex)
            {
                live.Content = "🧠 The model call failed.";
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop, "LLM error: " + ex.Message);
                return Problem(session, result, "Could not get a corrective fix from the model — retry or advise again.");
            }
            live.Content = $"🧠 Proposed a fix ({(reply ?? "").Length:N0} chars). Applying…";
            _appRepository.Save();

            var parsed = ParseReply(reply);
            if (!string.IsNullOrWhiteSpace(parsed.Explanation))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, session.CurrentLoop, parsed.Explanation.Trim());
            }
            if (parsed.Questions != null && parsed.Questions.Any(q => !string.IsNullOrWhiteSpace(q)))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    string.Join("\n", parsed.Questions.Where(q => !string.IsNullOrWhiteSpace(q)).Select(q => "• " + q.Trim())));
                return Problem(session, result, "The assistant needs more detail to apply your guidance.");
            }
            if (string.IsNullOrWhiteSpace(parsed.EtlSql))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "I couldn't turn that into SQL to run. Please be more specific (e.g. which table/values), then send it again.");
                return Problem(session, result, "No corrective SQL produced.");
            }

            string guard = EtlSqlGuard.ValidateEtl(parsed.EtlSql);
            if (guard != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    "The proposed fix was rejected by the safety guard (I can only write to the Staging schema): " + guard + "\n\n" + parsed.EtlSql.Trim());
                return Problem(session, result, "Proposed fix not allowed (Staging-only). Advise a Staging-scoped change.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Sql, session.CurrentLoop, "-- CORRECTIVE SQL\n" + parsed.EtlSql.Trim());
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, "⚙️ Applying the corrective SQL to Staging…");
            string execError = ExecuteNonQuery(parsed.EtlSql);
            if (execError != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "The corrective SQL failed:\n" + execError);
                return Problem(session, result, "The corrective SQL failed — see the error and advise again.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                $"✅ Applied your fix. Re-running the '{phaseLabelFor(phase)}' step…");
            return StayAndContinue(session, result, phase, "Applied your guidance — retrying the step.");
        }

        // Pre-run review: the model reviews its own ETL for Microsoft T-SQL bugs and invalid table/column
        // references (grounded in the real valid Staging targets) and returns corrected SQL. Best-effort:
        // if it can't run or returns nothing usable, the original SQL is used unchanged.
        private async Task<string> ReviewEtlSqlAsync(EtlChatSession session, string sql)
        {
            if (!_ollama.IsConfigured || string.IsNullOrWhiteSpace(sql))
            {
                return sql;
            }
            string valid = GetFileSpecStagingRequirements(ResolveRunbook(session.EtlMapId));

            var sys = new StringBuilder();
            sys.AppendLine("You are a meticulous Microsoft SQL Server (T-SQL) reviewer. Review the T-SQL below and FIX any bugs so it runs on SQL Server. Return ONLY the corrected SQL in a single ```sql block (return it unchanged if already correct). No commentary.");
            sys.AppendLine("Fix in particular:");
            sys.AppendLine("- `<expr> = <value> AS <alias>` — invalid, causes 'Incorrect syntax near AS'. Rewrite booleans as `CASE WHEN <expr> = <value> THEN 1 ELSE 0 END AS <alias>`.");
            sys.AppendLine("- MySQL/Postgres syntax → T-SQL: LIMIT/OFFSET → SELECT TOP (n); IFNULL → ISNULL; NOW() → GETDATE(); remove backticks; `#` comments → `--`.");
            sys.AppendLine("- Any table or column NOT in the valid targets below is a hallucination — correct it to the real table/column or remove it. Do NOT invent tables like 'Staging.StudentDemographics'.");
            sys.AppendLine("- Each INSERT's column list must match its SELECT/VALUES; bit columns take 1/0; populate NOT NULL columns; keep ALL writes in the Staging schema.");
            sys.AppendLine("- Preserve the intended load — keep a DELETE+INSERT for EVERY target table that was present.");
            sys.AppendLine();
            sys.AppendLine("## Valid Staging target tables & columns (use ONLY these)");
            sys.AppendLine(string.IsNullOrWhiteSpace(valid) ? "(none resolved — do not invent tables)" : valid);

            var msgs = new List<OllamaMessage>
            {
                new OllamaMessage { Role = EtlChatRole.System, Content = sys.ToString() },
                new OllamaMessage { Role = EtlChatRole.User, Content = "```sql\n" + sql + "\n```" }
            };
            try
            {
                string reply = await _ollama.ChatAsync(msgs);
                var parsed = ParseReply(reply);
                string fixedSql = !string.IsNullOrWhiteSpace(parsed.EtlSql) ? parsed.EtlSql : parsed.LookupSql;
                if (string.IsNullOrWhiteSpace(fixedSql))
                {
                    return sql;
                }

                // Safety backstop: the review must never DROP writes. A small model sometimes returns only
                // the DELETE (or splits the INSERT into a block we don't keep), which would run a delete-only
                // "load", leave the table empty, and loop forever. If the original had an INSERT/UPDATE/MERGE
                // that the reviewed SQL lost, distrust the review and run the ORIGINAL SQL unchanged.
                foreach (var verb in new[] { "insert", "update", "merge" })
                {
                    bool origHas = Regex.IsMatch(sql, $@"(?i)\b{verb}\b");
                    bool fixedHas = Regex.IsMatch(fixedSql, $@"(?i)\b{verb}\b");
                    if (origHas && !fixedHas)
                    {
                        AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                            $"🔎 Review dropped the {verb.ToUpperInvariant()} statement — keeping the original SQL to avoid an incomplete load.");
                        return sql;
                    }
                }

                bool changed = NormalizeSql(fixedSql) != NormalizeSql(sql);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    changed
                        ? "🔎 Reviewed the SQL for Microsoft T-SQL bugs (e.g. `= … AS`, LIMIT, invalid tables) and applied fixes before running."
                        : "🔎 Reviewed the SQL for Microsoft T-SQL bugs — no changes needed.");
                return fixedSql;
            }
            catch
            {
                return sql; // best-effort; run the original
            }
        }

        private static string NormalizeSql(string s) => Regex.Replace((s ?? "").Trim(), @"\s+", " ");

        private List<OllamaMessage> BuildAssistPrompt(string phase, int year, string instruction, string lastError)
        {
            var sb = new StringBuilder();
            sb.AppendLine($"You are a Microsoft T-SQL assistant helping RECOVER a failed '{phaseLabelFor(phase)}' step in a CEDS/EDFacts ETL pipeline for school year {year}.");
            sb.AppendLine("Carry out the user's instruction by writing T-SQL that fixes the problem so the step can be retried.");
            sb.AppendLine();
            sb.AppendLine("## Strict rules");
            sb.AppendLine("- You may ONLY INSERT/UPDATE/DELETE within the **Staging** schema (e.g. Staging.StateDetail). Do NOT EXEC procedures, run migrations, DROP/TRUNCATE/ALTER, or write outside Staging.");
            sb.AppendLine($"- Microsoft T-SQL only. Use the school year {year} where a year is needed. Make writes idempotent where reasonable (e.g. DELETE the year's rows then INSERT).");
            sb.AppendLine("- Provide concrete/hard-coded values when the user asks for them.");
            sb.AppendLine();
            sb.AppendLine("## The step failed with this error");
            string err = lastError ?? "";
            sb.AppendLine(err.Length > 900 ? err.Substring(0, 900) + " …" : err);

            // Context phase (bug): inject the real schema of EVERY object the instruction/error references
            // (ALL schemas, via INFORMATION_SCHEMA) so the fix is written against actual columns/types —
            // not just the Staging tables named literally.
            string schemaCtx = GatherSchemaContext(instruction + " " + (lastError ?? ""));
            if (!string.IsNullOrWhiteSpace(schemaCtx))
            {
                sb.AppendLine();
                sb.AppendLine("## Schema of referenced objects (from INFORMATION_SCHEMA)");
                sb.AppendLine(schemaCtx);
            }

            sb.AppendLine();
            sb.AppendLine("## Response format");
            sb.AppendLine("Respond with a single ```sql code block containing the T-SQL to run. If you genuinely need more information, respond instead with one or more lines starting with 'QUESTION:'.");

            return new List<OllamaMessage>
            {
                new OllamaMessage { Role = EtlChatRole.System, Content = sb.ToString() },
                new OllamaMessage { Role = EtlChatRole.User, Content = instruction }
            };
        }

        // Best-effort, READ-ONLY: after a deterministic step fails, ask the LLM to diagnose the error and
        // propose a corrective SQL fix, posted for the user to approve with "do it". Never executes.
        private async Task AutoProposeFixAsync(EtlChatSession session, string phase)
        {
            if (!_ollama.IsConfigured)
            {
                return;
            }
            var msgs = GetMessages(session.EtlChatSessionId);
            string lastError = msgs.LastOrDefault(m => m.MessageType == EtlChatMessageType.Error)?.Content;
            if (string.IsNullOrWhiteSpace(lastError))
            {
                return; // nothing concrete to diagnose (e.g. "no fact type linked")
            }
            // Include the deterministic diagnosis (the most recent question) so the model has our hints
            // (e.g. that Staging.StateDetail is the source of the state info).
            string diagnosis = msgs.LastOrDefault(m => m.MessageType == EtlChatMessageType.Question)?.Content ?? "";
            int year = ResolveSchoolYear(session);

            var prompt = BuildAssistPrompt(phase, year,
                "Diagnose the failure above and propose a MINIMAL corrective fix. If a Staging table needs data, give the exact INSERT/UPDATE.",
                lastError + "\n" + diagnosis);

            string reply;
            try { reply = await _ollama.ChatAsync(prompt); }
            catch { return; } // best-effort — deterministic guidance already covers the user

            var parsed = ParseReply(reply);
            if (!string.IsNullOrWhiteSpace(parsed.Explanation))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Chat, session.CurrentLoop,
                    "💡 " + parsed.Explanation.Trim());
            }
            if (!string.IsNullOrWhiteSpace(parsed.EtlSql) && EtlSqlGuard.ValidateEtl(parsed.EtlSql) == null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Sql, session.CurrentLoop,
                    "-- 💡 PROPOSED FIX — reply \"do it\" to apply, or tell me what to change\n" + parsed.EtlSql.Trim());
            }
        }

        // "do it" / "apply" / "yes" — the user approving the last proposed fix.
        private bool LastMessageIsApproval(EtlChatSession session)
        {
            var last = GetMessages(session.EtlChatSessionId).LastOrDefault();
            if (last == null || last.Role != EtlChatRole.User)
            {
                return false;
            }
            string l = (last.Content ?? "").Trim().ToLowerInvariant();
            return Regex.IsMatch(l, @"^(do it|apply( it)?|yes(,? do it| please)?|go ahead|run it|make it so|ok,? (do it|go)|proceed with (the|that) fix|sounds good,? do it)\b")
                   && l.Length < 40;
        }

        // Runs the SQL from the most recent PROPOSED FIX (an assistant sql message), guarded, then retries.
        private EtlChatIterationResultDto ApplyLastProposedFix(EtlChatSession session, EtlChatIterationResultDto result, string phase)
        {
            var proposal = GetMessages(session.EtlChatSessionId)
                .LastOrDefault(m => m.Role == EtlChatRole.Assistant && m.MessageType == EtlChatMessageType.Sql);
            if (proposal == null || string.IsNullOrWhiteSpace(proposal.Content))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    "I don't have a proposed fix on hand, so I'll just re-run this step. If you want a change, tell me what to do (e.g. \"populate Staging.<table> with …\").");
                return StayAndContinue(session, result, phase, "Retrying the step.");
            }

            string sql = proposal.Content;
            string guard = EtlSqlGuard.ValidateEtl(sql);
            if (guard != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop,
                    "The proposed fix can't be applied (Staging-schema only): " + guard);
                return Problem(session, result, "Proposed fix not allowed (Staging-only).");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, "⚙️ Applying the proposed fix to Staging…");
            string execError = ExecuteNonQuery(sql);
            if (execError != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "The proposed fix failed:\n" + execError);
                return Problem(session, result, "The proposed fix failed — see the error and advise again.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                $"✅ Applied the fix. Re-running the '{phaseLabelFor(phase)}' step…");
            return StayAndContinue(session, result, phase, "Applied the proposed fix — retrying the step.");
        }

        // Staging table names mentioned in free-form text (that actually exist).
        private List<string> MentionedStagingTables(string text)
        {
            var found = new List<string>();
            if (string.IsNullOrWhiteSpace(text)) return found;
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (Match m in Regex.Matches(text, @"(?:Staging\.)?\[?([A-Za-z][A-Za-z0-9_]{3,})\]?"))
            {
                string cand = m.Groups[1].Value;
                if (!seen.Add(cand)) continue;
                if (GetColumns("Staging", cand).Count > 0) found.Add(cand);
            }
            return found;
        }

        // Stay on the current phase and tell the client to re-run it (used after an assist/fix).
        private EtlChatIterationResultDto StayAndContinue(EtlChatSession session, EtlChatIterationResultDto result, string phase, string summary)
        {
            session.CurrentPhase = phase;
            session.Status = EtlChatSessionStatus.Active;
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            result.Phase = phase;
            result.Outcome = EtlChatIterationOutcome.PhaseComplete;
            result.Status = session.Status;
            result.CanContinue = true;
            result.Summary = summary;
            return result;
        }

        private bool LastMessageIsFreeFormUserGuidance(EtlChatSession session)
        {
            var last = GetMessages(session.EtlChatSessionId).LastOrDefault();
            if (last == null || last.Role != EtlChatRole.User)
            {
                return false;
            }
            return !IsPlainDirective(last.Content ?? "");
        }

        // True for short control words we already handle deterministically (retry/skip/restart/use YYYY).
        private static bool IsPlainDirective(string text)
        {
            string l = (text ?? "").Trim().ToLowerInvariant();
            if (l.Length == 0) return true;
            if (Regex.IsMatch(l, @"^(retry|try again|continue|proceed|resume|next|go|run)\b") && l.Length < 24) return true;
            if (Regex.IsMatch(l, @"^(skip|bypass|move past|restart|start over)\b")) return true;
            if (Regex.IsMatch(l, @"^(use|run for|set(\s+the)?\s+year(\s+to)?|year)\s+20\d{2}\b") && l.Length < 32) return true;
            return false;
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

        // A genuine problem: stop and hand back to the user (they can steer, then it re-runs this step).
        private EtlChatIterationResultDto Problem(EtlChatSession session, EtlChatIterationResultDto result, string summary)
        {
            session.Status = EtlChatSessionStatus.AwaitingInput;
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                $"I paused at the '{phaseLabelFor(session.CurrentPhase)}' step. Tell me how to proceed and I'll continue from here — for example: " +
                "\"retry\", \"use 2027\", \"skip this step\", or \"restart\". You can also give guidance and I'll try again.");
            result.Outcome = EtlChatIterationOutcome.Failed;
            result.Status = session.Status;
            result.CanContinue = false;
            result.Summary = summary;
            return result;
        }

        private static string phaseLabelFor(string phase)
        {
            switch (phase)
            {
                case EtlChatPhase.StagingLoad: return "Staging load";
                case EtlChatPhase.StagingValidate: return "Staging validation";
                case EtlChatPhase.RdsMigrate: return "Warehouse migration";
                case EtlChatPhase.RdsValidate: return "Warehouse validation";
                case EtlChatPhase.ReportMigrate: return "Report tables";
                case EtlChatPhase.ReportValidate: return "Validate the numbers";
                default: return phase ?? "current";
            }
        }

        // -------------------- Phase 2b: Staging validation (self-healing) --------------------
        // Automatically updates Staging.SourceSystemReferenceData (copy-forward + sync the map's option
        // mappings), then runs the validation rules and auto-fixes what it can, looping until the
        // validation is clean or only unfixable items remain (which it lists for the user to map).

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

            // Step: automatically update SourceSystemReferenceData for the year.
            // 1) If there are no SSRD rows for the year, copy last year's values forward (uses the sproc).
            EnsureReferenceDataForYear(session, year);
            // 2) Sync the map's accepted option-set-value mappings (source code -> CEDS code) into SSRD.
            bool syncedOnce = SyncMapReferenceData(session, year);

            if (string.IsNullOrWhiteSpace(rb.StagingValidationExecuteSql) || string.IsNullOrWhiteSpace(rb.StagingValidationResultsSql))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "No Staging validation is registered for this fact type; proceeding to the warehouse migration.");
                return Advance(session, result, EtlChatPhase.RdsMigrate, "No staging validation configured — migrating to the CEDS Data Warehouse.");
            }

            string execSql = AsExec(SubstituteTokens(rb.StagingValidationExecuteSql, year, rb.FactTypeCode));
            string resultsSql = AsExec(SubstituteTokens(rb.StagingValidationResultsSql, year, rb.FactTypeCode));

            // Self-healing loop: validate, auto-fix a known issue, re-validate — until clean or out of fixes.
            bool appliedSync = syncedOnce;
            const int maxAttempts = 5;
            for (int attempt = 1; attempt <= maxAttempts; attempt++)
            {
                string execErr = ExecuteAdminSql(execSql, _adminTimeoutSeconds);
                if (execErr != null)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "Staging validation could not run:\n" + execErr);
                    return Advance(session, result, EtlChatPhase.RdsMigrate, "Staging validation errored; proceeding to the warehouse migration.");
                }

                var v = ReadValidation(resultsSql);
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                    v.HeaderLine(attempt) + (v.Total > 0 ? "\n" + v.Summary : ""));

                // Clean (ignoring broken-rule "Rule_Error" rows, which are schema/rule issues, not data).
                if (v.UnmappedCount == 0 && v.OtherErrorCount == 0)
                {
                    if (v.RuleErrorCount > 0)
                    {
                        AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                            $"Note: {v.RuleErrorCount} validation rule error(s) (a rule references a column not in this staging schema) — not a data problem; ignoring.");
                    }
                    return Advance(session, result, EtlChatPhase.RdsMigrate, "Staging validated clean — migrating to the CEDS Data Warehouse (RDS).");
                }

                // Auto-fix: unmapped SourceSystemReferenceData values → sync the map's mappings (once).
                if (v.UnmappedCount > 0 && !appliedSync)
                {
                    AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                        "🛠️ Auto-fix: syncing the map's option-set mappings into SourceSystemReferenceData and re-validating…");
                    SyncMapReferenceData(session, year);
                    appliedSync = true;
                    continue;
                }

                // Out of automated fixes — remaining items need the user to map them.
                break;
            }

            // Report the specific unmapped values so the user can map them in the ETL Mapping UI.
            var final = ReadValidation(resultsSql);
            if (final.UnmappedCount > 0)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    "These source values still aren't mapped in Staging.SourceSystemReferenceData for " + year +
                    ". Map their option-set values in the ETL Mapping UI (or add them to reference data), then send \"retry\":\n" +
                    string.Join("\n", final.UnmappedLocations.Select(x => "• " + x)));
                return Problem(session, result, "Unmapped reference-data values remain — map them, then retry.");
            }

            // Only non-unmapped errors remain (e.g. other rule errors) — proceed; the official test is the gate.
            return Advance(session, result, EtlChatPhase.RdsMigrate, "Staging validation done — proceeding to the CEDS Data Warehouse (RDS).");
        }

        // Ensures Staging.SourceSystemReferenceData has rows for the year; if empty, copies the latest
        // prior year forward using the Rollover sproc, with a direct-copy fallback.
        private void EnsureReferenceDataForYear(EtlChatSession session, int year)
        {
            long count = ExecuteScalarLong($"SELECT COUNT(*) FROM Staging.SourceSystemReferenceData WHERE SchoolYear = {year}") ?? 0;
            if (count > 0)
            {
                return;
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"📋 No SourceSystemReferenceData for SY{year} — copying last year's values forward (Staging.Rollover_SourceSystemReferenceData)…");
            ExecuteAdminSql("EXEC Staging.Rollover_SourceSystemReferenceData", 300);

            // Fallback: the sproc keys off Staging.StateDetail; if it didn't populate our year, copy directly.
            count = ExecuteScalarLong($"SELECT COUNT(*) FROM Staging.SourceSystemReferenceData WHERE SchoolYear = {year}") ?? 0;
            if (count == 0)
            {
                // Copy from the most recent OTHER year present (matches the Rollover sproc, which uses
                // MAX(SchoolYear) — this also covers seeding a back-year from a later year's reference data).
                ExecuteAdminSql(
                    "INSERT INTO Staging.SourceSystemReferenceData (SchoolYear, TableName, TableFilter, InputCode, OutputCode)\n" +
                    $"SELECT DISTINCT {year}, TableName, TableFilter, InputCode, OutputCode\n" +
                    "FROM Staging.SourceSystemReferenceData\n" +
                    $"WHERE SchoolYear = (SELECT MAX(SchoolYear) FROM Staging.SourceSystemReferenceData WHERE SchoolYear <> {year});", 300);
                count = ExecuteScalarLong($"SELECT COUNT(*) FROM Staging.SourceSystemReferenceData WHERE SchoolYear = {year}") ?? 0;
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                count > 0
                    ? $"✅ SourceSystemReferenceData now has {count} row(s) for SY{year}."
                    : $"⚠️ Could not seed SourceSystemReferenceData for SY{year} (no prior-year values to copy). Add reference data / option-set mappings for this map.");
        }

        // Syncs the map's accepted option-set mappings into SSRD; returns true if any rows were written.
        private bool SyncMapReferenceData(EtlChatSession session, int year)
        {
            int synced = 0;
            try { synced = _mappingService.SyncReferenceDataForMap(session.EtlMapId, year); }
            catch { synced = 0; }
            if (synced > 0)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    $"🔗 Synced {synced} option-set value mapping(s) from the map into SourceSystemReferenceData for SY{year}.");
            }
            return synced > 0;
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

            string err = ExecuteAdminSql(AsExec(rb.RdsWrapperProc), _adminTimeoutSeconds);
            if (err != null)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, "The RDS migration wrapper failed:\n" + err);
                return Problem(session, result, "The Staging → RDS migration failed — see the error above.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop, "✅ CEDS Data Warehouse (fact/dim) migration complete.");
            return Advance(session, result, EtlChatPhase.RdsValidate, "Warehouse loaded — validating the fact/dim data before building reports.");
        }

        // -------------------- Phase 3b: Warehouse (fact/dim) validation --------------------
        // A record-count sanity check between the fact/dim migration and report generation: confirm the
        // fact table isn't empty, compare staging vs fact student counts (dropped rows = orphaned dims),
        // flag unresolved (-1) organization keys, and surface any migration-history errors.

        private EtlChatIterationResultDto RunRdsValidatePhase(EtlChatSession session, EtlChatIterationResultDto result)
        {
            int year = ResolveSchoolYear(session);
            var rb = ResolveRunbook(session.EtlMapId);
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"🔎 Phase 3 — validating the CEDS Data Warehouse fact/dim data for '{rb.FactTypeCode ?? "?"}' (SY{year})…");

            // Recent migration-history errors (best-effort).
            string migErrors = ReadTabular(
                "SELECT TOP 10 DataMigrationHistoryDate, DataMigrationHistoryMessage FROM App.DataMigrationHistories " +
                "WHERE (DataMigrationHistoryMessage LIKE '%ERROR%' OR DataMigrationHistoryMessage LIKE '%fail%') " +
                "AND DataMigrationHistoryDate >= DATEADD(HOUR, -6, GETUTCDATE()) ORDER BY DataMigrationHistoryDate DESC",
                10, out int migErrorRows);
            if (migErrorRows > 0)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    $"⚠️ Recent migration-history messages flagged errors ({migErrorRows}):\n" + migErrors);
            }

            // Locate the fact debug view for this fact type (debug.vw<FactType>_FactTable).
            string factView = DiscoverFactView(rb.FactTypeCode);
            if (string.IsNullOrWhiteSpace(factView))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                    "No fact debug view found for this fact type; skipping the fact-count check and proceeding to reports.");
                return Advance(session, result, EtlChatPhase.ReportMigrate, "No fact debug view — proceeding to build the report tables.");
            }

            var viewCols = GetColumns("debug", factView);
            string yearFilter = viewCols.Contains("SchoolYear") ? $" WHERE SchoolYear = {year}" : "";
            string studentCol = viewCols.FirstOrDefault(c => c.IndexOf("StudentIdentifierState", StringComparison.OrdinalIgnoreCase) >= 0);

            long factRows = ExecuteScalarLong($"SELECT COUNT(*) FROM debug.{factView}{yearFilter}") ?? 0;
            long factStudents = studentCol != null
                ? ExecuteScalarLong($"SELECT COUNT(DISTINCT [{studentCol}]) FROM debug.{factView}{yearFilter}") ?? 0
                : -1;

            // Unresolved (-1) organization dimension keys.
            var orphanConds = new[] { "SeaId", "LeaId", "K12SchoolId" }
                .Where(c => viewCols.Contains(c)).Select(c => $"[{c}] = -1").ToList();
            long orphanRows = orphanConds.Count > 0
                ? ExecuteScalarLong($"SELECT COUNT(*) FROM debug.{factView}{(yearFilter.Length > 0 ? yearFilter + " AND (" : " WHERE (")}{string.Join(" OR ", orphanConds)})") ?? 0
                : 0;

            // Staging distinct students (input) for comparison.
            long stagingStudents = StagingDistinctStudents(session.EtlMapId, year);

            var lines = new List<string>
            {
                $"• Fact rows (SY{year}): {factRows:N0}" + (factStudents >= 0 ? $" · distinct students: {factStudents:N0}" : "")
            };
            if (stagingStudents >= 0 && factStudents >= 0)
            {
                long dropped = stagingStudents - factStudents;
                lines.Add($"• Staging distinct students: {stagingStudents:N0} → fact: {factStudents:N0}" +
                          (dropped > 0 ? $"  ⚠️ {dropped:N0} not carried to fact (likely orphaned dimensions / unmapped values)" : "  ✓ all carried through"));
            }
            if (orphanConds.Count > 0)
            {
                lines.Add($"• Unresolved (-1) organization keys: {orphanRows:N0}" + (orphanRows > 0 ? "  ⚠️" : "  ✓"));
            }
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.TestResult, session.CurrentLoop,
                $"🔎 Warehouse validation ({factView}):\n" + string.Join("\n", lines));

            // Empty fact after migration is a real blocker — the report would be empty.
            if (factRows == 0)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    "The fact table is EMPTY after the warehouse migration, so the report would be empty too. This usually means unresolved dimension keys " +
                    "(org/student ids that don't match the directory dims), unmapped reference values, or the year isn't selected. Fix the cause, then send \"retry\" " +
                    "(or \"skip\" to build reports anyway).");
                return Problem(session, result, "Fact table empty after migration — resolve, then retry.");
            }

            return Advance(session, result, EtlChatPhase.ReportMigrate,
                "Warehouse validated — building the report tables.");
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

            // Pre-check + auto-fix: report generation needs category-set metadata for the year. If it's
            // missing (a common cause of empty reports), roll it forward automatically.
            EnsureCategorySets(session, year, rb.ReportCodes);

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
                string e = ExecuteAdminSql(AsExec(SubstituteTokens(rb.EmptyReportsSql, year, rb.FactTypeCode)), _adminTimeoutSeconds);
                if (e != null)
                {
                    return ReportStepFailed(session, result, "Empty_Reports", e);
                }
            }

            string createSql = !string.IsNullOrWhiteSpace(rb.CreateReportsSql)
                ? AsExec(SubstituteTokens(rb.CreateReportsSql, year, rb.FactTypeCode))
                : $"EXEC rds.create_reports '{rb.FactTypeCode}', 0";
            string cErr = ExecuteAdminSql(createSql, _adminTimeoutSeconds);
            if (cErr != null)
            {
                return ReportStepFailed(session, result, "create_reports", cErr);
            }

            // Post-check: did the report tables actually get populated?
            long reportRows = ReportRowCount(rb.ReportCodes, year);
            if (reportRows == 0)
            {
                long csCount = ExecuteScalarLong(CategorySetCountSql(year, rb.ReportCodes)) ?? 0;
                string factView = DiscoverFactView(rb.FactTypeCode);
                long factRows = factView != null
                    ? ExecuteScalarLong($"SELECT COUNT(*) FROM debug.{factView}" + (GetColumns("debug", factView).Contains("SchoolYear") ? $" WHERE SchoolYear = {year}" : "")) ?? 0
                    : -1;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    $"⚠️ The report tables built but produced 0 rows for {codes} / SY{year}. Diagnosis:\n" +
                    $"• Category sets for the year: {csCount} " + (csCount == 0 ? "❌ (none — metadata not rolled forward)" : "✓") + "\n" +
                    (factRows >= 0 ? $"• Fact rows for the year: {factRows} " + (factRows == 0 ? "❌ (empty — nothing to report)" : "✓") + "\n" : "") +
                    "Fix the failing item above (e.g. load fact data, or map reference values), then send \"retry\" (or \"skip\").");
                return Problem(session, result, "Report tables produced 0 rows — see the diagnosis above.");
            }

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"✅ Report tables built — {reportRows:N0} report row(s) for {codes} / SY{year}.");
            return Advance(session, result, EtlChatPhase.ReportValidate, "Reports built — validating the numbers.");
        }

        // Handles a failed report step: posts the full error PLUS a blocking-session diagnosis (the common
        // cause of report-table timeouts is another session holding a lock), then pauses recoverably.
        private EtlChatIterationResultDto ReportStepFailed(EtlChatSession session, EtlChatIterationResultDto result, string step, string error)
        {
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Error, session.CurrentLoop, $"{step} failed:\n{error}");

            string blocking = DescribeBlocking();
            string dataDiagnosis = DiagnoseReportError(error);
            if (!string.IsNullOrWhiteSpace(blocking))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    "🔒 The report tables appear to be LOCKED by another database session, which is why this step timed out/failed. " +
                    "That session must finish or be killed before reports can build:\n" + blocking +
                    "\nOnce it's cleared, send \"retry\".");
            }
            else if (!string.IsNullOrWhiteSpace(dataDiagnosis))
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop, dataDiagnosis);
            }
            else
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Question, session.CurrentLoop,
                    $"The {step} step failed. If it was a timeout, the report tables may be large or locked; you can raise EtlChat:AdminTimeoutSeconds. " +
                    "Send \"retry\", \"skip\", or tell me how to fix it (e.g. \"populate Staging.<table> with …\") and I'll apply it, then retry.");
            }
            return Problem(session, result, $"{step} failed — see the diagnosis above.");
        }

        // Recognizes known create_reports data errors and returns actionable guidance (empty for unknown).
        private string DiagnoseReportError(string error)
        {
            if (string.IsNullOrWhiteSpace(error)) return null;

            // create_reports pulls StateANSICode / StateAbbreviation from Staging.StateDetail. A NULL there
            // means that table is empty (or missing the state row) — a very common first-run gap.
            var m = Regex.Match(error, @"Cannot insert the value NULL into column '([^']+)'", RegexOptions.IgnoreCase);
            if (error.IndexOf("StateANSICode", StringComparison.OrdinalIgnoreCase) >= 0 ||
                error.IndexOf("StateAbbreviation", StringComparison.OrdinalIgnoreCase) >= 0 ||
                error.IndexOf("StateDetail", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                long sd = ExecuteScalarLong("SELECT COUNT(*) FROM Staging.StateDetail") ?? -1;
                return "This is a state-information gap: `rds.create_reports` derives the state ANSI code from the state abbreviation in **Staging.StateDetail**, " +
                       $"which currently has {(sd <= 0 ? "no rows" : $"{sd} row(s)")}" +
                       " (so it's missing a valid StateAbbreviationCode for this school year). " +
                       "Tell me to populate it and I'll do it and retry — for example: " +
                       "\"populate Staging.StateDetail with StateAbbreviationCode 'NJ' and SeaOrganizationName 'New Jersey Department of Education' for this year\" " +
                       "(use your state's values). I'll fill in the required columns. You can also \"skip\" or \"retry\".";
            }

            if (m.Success)
            {
                return $"A required value is NULL: column '{m.Groups[1].Value}' can't be null when building the report. " +
                       "This usually means a source Staging table is missing that value. Tell me which Staging table/value to set " +
                       "(e.g. \"populate Staging.<table> with …\") and I'll apply it, then retry.";
            }
            return null;
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
                string exErr = ExecuteAdminSql($"EXEC App.[{proc}] @SchoolYear = {year}", _adminTimeoutSeconds);
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
                return DescribeSqlError(ex, sql);
            }
        }

        // Builds a full, actionable error report: SQL Server error lines (Msg/Level/State/Procedure/Line),
        // the exact SQL that ran, and the complete exception with stack trace.
        private static string DescribeSqlError(Exception ex, string sql)
        {
            var sb = new StringBuilder();
            if (ex is SqlException sqlEx && sqlEx.Errors != null && sqlEx.Errors.Count > 0)
            {
                foreach (SqlError e in sqlEx.Errors)
                {
                    sb.Append($"Msg {e.Number}, Level {e.Class}, State {e.State}");
                    if (!string.IsNullOrEmpty(e.Procedure)) sb.Append($", Procedure {e.Procedure}");
                    sb.AppendLine($", Line {e.LineNumber}");
                    sb.AppendLine(e.Message);
                }
            }
            else
            {
                sb.AppendLine(ex.Message);
            }
            if (!string.IsNullOrWhiteSpace(sql))
            {
                sb.AppendLine();
                sb.AppendLine("-- SQL executed --");
                sb.AppendLine(sql.Trim());
            }
            sb.AppendLine();
            sb.AppendLine("-- Full exception (stack) --");
            sb.Append(ex.ToString());
            return sb.ToString().TrimEnd();
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

        // Finds the fact debug view for a fact type (debug.vw<FactType>_FactTable) by matching the
        // lowercased, stripped view name to the fact type code (e.g. 'childcount' -> vwChildCount_FactTable).
        private string DiscoverFactView(string factCode)
        {
            if (string.IsNullOrWhiteSpace(factCode)) return null;
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText =
                    @"SELECT TOP 1 name FROM sys.views
                      WHERE SCHEMA_NAME(schema_id) = 'debug' AND name LIKE 'vw%[_]FactTable'
                        AND LOWER(REPLACE(REPLACE(name, 'vw', ''), '_FactTable', '')) = @fc";
                cmd.Parameters.AddWithValue("@fc", factCode.ToLowerInvariant());
                return cmd.ExecuteScalar() as string;
            }
            catch
            {
                return null;
            }
        }

        // Column names of a table/view (case-insensitive set).
        private HashSet<string> GetColumns(string schema, string objectName)
        {
            var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT c.name FROM sys.columns c WHERE c.object_id = OBJECT_ID(@o)";
                cmd.Parameters.AddWithValue("@o", schema + "." + objectName);
                using var r = cmd.ExecuteReader();
                while (r.Read()) { set.Add(r.GetString(0)); }
            }
            catch { }
            return set;
        }

        // Distinct StudentIdentifierState across the map's staging tables (input count). -1 if not applicable.
        private long StagingDistinctStudents(int etlMapId, int year)
        {
            var tables = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            try
            {
                foreach (var m in _mappingService.GetAllMappings(etlMapId).Where(x => !string.IsNullOrWhiteSpace(x.StagingTableColumns)))
                {
                    foreach (var tc in m.StagingTableColumns.Split(';'))
                    {
                        string t = tc.Trim().Split('.').FirstOrDefault();
                        if (!string.IsNullOrWhiteSpace(t)) { tables.Add(t.Trim()); }
                    }
                }
            }
            catch { }

            var usable = tables
                .Where(t => { var c = GetColumns("Staging", t); return c.Contains("StudentIdentifierState") && c.Contains("SchoolYear"); })
                .ToList();
            if (usable.Count == 0) { return -1; }

            string union = string.Join(" UNION ", usable.Select(t =>
                $"SELECT DISTINCT StudentIdentifierState FROM Staging.[{t}] WHERE SchoolYear = {year} AND StudentIdentifierState IS NOT NULL"));
            return ExecuteScalarLong($"SELECT COUNT(*) FROM ({union}) x") ?? -1;
        }

        private static string CategorySetCountSql(int year, List<string> reportCodes)
        {
            string inList = reportCodes != null && reportCodes.Count > 0
                ? string.Join(",", reportCodes.Select(c => "'" + c.Replace("'", "''") + "'"))
                : "''";
            return "SELECT COUNT(*) FROM App.CategorySets cs " +
                   "JOIN App.GenerateReports r ON cs.GenerateReportId = r.GenerateReportId " +
                   $"WHERE r.ReportCode IN ({inList}) AND cs.SubmissionYear = {year}";
        }

        // Report generation needs App.CategorySets for the year; if missing, roll the metadata forward.
        private void EnsureCategorySets(EtlChatSession session, int year, List<string> reportCodes)
        {
            if (reportCodes == null || reportCodes.Count == 0) return;
            long count = ExecuteScalarLong(CategorySetCountSql(year, reportCodes)) ?? 0;
            if (count > 0) return;

            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                $"📋 No report category-set metadata for SY{year} — rolling it forward (App.Rollover_All_Metadata_up_to_SchoolYear)…");
            ExecuteAdminSql($"EXEC App.Rollover_All_Metadata_up_to_SchoolYear @targetSubmissionYear = {year}", _adminTimeoutSeconds);
            count = ExecuteScalarLong(CategorySetCountSql(year, reportCodes)) ?? 0;
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                count > 0
                    ? $"✅ Report category-set metadata now present for SY{year} ({count} set(s))."
                    : $"⚠️ Report category-set metadata still missing for SY{year} — the reports may build empty.");
        }

        // Counts report rows produced for the fact type's report codes / year across the RDS report tables
        // (matching either the raw code '089' or the EDFacts 'C089'). NOLOCK so it can't be blocked.
        private long ReportRowCount(List<string> reportCodes, int year)
        {
            if (reportCodes == null || reportCodes.Count == 0) return -1;
            var codeSet = new List<string>();
            foreach (var c in reportCodes) { codeSet.Add(c); codeSet.Add("C" + c); }
            string inList = string.Join(",", codeSet.Distinct().Select(c => "'" + c.Replace("'", "''") + "'"));
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                var tables = new List<string>();
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        @"SELECT t.name FROM sys.tables t
                          WHERE SCHEMA_NAME(t.schema_id) = 'RDS' AND t.name LIKE 'ReportEDFacts%'
                            AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'ReportCode')
                            AND EXISTS (SELECT 1 FROM sys.columns c WHERE c.object_id = t.object_id AND c.name = 'ReportYear')";
                    using var r = cmd.ExecuteReader();
                    while (r.Read()) { tables.Add(r.GetString(0)); }
                }
                long total = 0;
                foreach (var t in tables)
                {
                    using var cmd = conn.CreateCommand();
                    cmd.CommandTimeout = 120;
                    cmd.CommandText = $"SELECT COUNT(*) FROM RDS.[{t}] WITH (NOLOCK) WHERE ReportYear = {year} AND ReportCode IN ({inList})";
                    var v = cmd.ExecuteScalar();
                    if (v != null && v != DBNull.Value) { total += Convert.ToInt64(v); }
                }
                return total;
            }
            catch
            {
                return -1;
            }
        }

        // Describes any session currently blocking others (the usual cause of report-table timeouts),
        // including how to clear it (KILL). Returns null if nothing is blocking or DMVs aren't visible.
        private string DescribeBlocking()
        {
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandTimeout = 30;
                cmd.CommandText =
                    @"SELECT DISTINCT r.blocking_session_id AS spid, s.login_name, s.program_name, s.status,
                             DATEDIFF(MINUTE, s.last_request_start_time, GETDATE()) AS mins,
                             CONVERT(varchar(300), st.text) AS sql_text
                      FROM sys.dm_exec_requests r
                      JOIN sys.dm_exec_sessions s ON s.session_id = r.blocking_session_id
                      OUTER APPLY (
                          SELECT text FROM sys.dm_exec_connections c
                          CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle)
                          WHERE c.session_id = r.blocking_session_id
                      ) st
                      WHERE r.blocking_session_id <> 0";
                using var reader = cmd.ExecuteReader();
                var sb = new StringBuilder();
                var seen = new HashSet<int>();
                while (reader.Read())
                {
                    int spid = reader.IsDBNull(0) ? 0 : Convert.ToInt32(reader.GetValue(0));
                    if (spid == 0 || !seen.Add(spid)) continue;
                    string login = reader.IsDBNull(1) ? "" : reader.GetString(1);
                    string prog = reader.IsDBNull(2) ? "" : reader.GetString(2);
                    string mins = reader.IsDBNull(4) ? "?" : reader.GetValue(4).ToString();
                    string sql = reader.IsDBNull(5) ? "" : reader.GetValue(5).ToString();
                    sql = Regex.Replace(sql ?? "", @"\s+", " ").Trim();
                    if (sql.Length > 200) sql = sql.Substring(0, 200) + "…";
                    sb.AppendLine($"• Session {spid} ({login}{(string.IsNullOrWhiteSpace(prog) ? "" : ", " + prog)}), active ~{mins} min. Clear it with: KILL {spid};");
                    if (!string.IsNullOrWhiteSpace(sql)) { sb.AppendLine($"    running: {sql}"); }
                }
                string s = sb.ToString().TrimEnd();
                return string.IsNullOrWhiteSpace(s) ? null : s;
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

        // Categorized snapshot of StagingValidation_GetResults — used to drive the self-healing loop.
        private class ValidationSnapshot
        {
            public int Total;
            public int UnmappedCount;    // SourceSystemReferenceData "value not mapped" (RuleId -2) — auto-fixable
            public int RuleErrorCount;   // Severity 'Rule_Error' — a broken rule / column not in this schema
            public int OtherErrorCount;  // any other Error-severity row
            public string Summary = "";
            public List<string> UnmappedLocations = new List<string>();

            public string HeaderLine(int attempt)
            {
                if (Total == 0) return "🧪 Staging validation: clean, no rules flagged. ✓";
                return $"🧪 Staging validation (pass {attempt}): {Total} rule(s) flagged — " +
                       $"{UnmappedCount} unmapped-value error(s), {OtherErrorCount} other error(s), {RuleErrorCount} rule error(s):";
            }
        }

        // Runs StagingValidation_GetResults and categorizes the rows (only the useful columns; omits the
        // giant ShowRecordsSQL). Distinguishes SSRD "not mapped" errors (auto-fixable) from broken rules.
        private ValidationSnapshot ReadValidation(string sql)
        {
            var v = new ValidationSnapshot();
            var lines = new List<string>();
            const int maxLines = 25;
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandTimeout = 300;
                using var r = cmd.ExecuteReader();
                int oRule = TryOrdinal(r, "StagingValidationRuleId");
                int oTable = TryOrdinal(r, "StagingTableName");
                int oCol = TryOrdinal(r, "ColumnName");
                int oSev = TryOrdinal(r, "Severity");
                int oMsg = TryOrdinal(r, "ValidationMessage");
                int oCnt = TryOrdinal(r, "RecordCount");
                while (r.Read())
                {
                    v.Total++;
                    string sev = oSev >= 0 && !r.IsDBNull(oSev) ? r.GetValue(oSev).ToString() : "";
                    string msg = oMsg >= 0 && !r.IsDBNull(oMsg) ? r.GetValue(oMsg).ToString() : "";
                    long ruleId = oRule >= 0 && !r.IsDBNull(oRule) ? Convert.ToInt64(r.GetValue(oRule)) : 0;
                    string tbl = oTable >= 0 && !r.IsDBNull(oTable) ? r.GetValue(oTable).ToString() : "";
                    string col = oCol >= 0 && !r.IsDBNull(oCol) ? r.GetValue(oCol).ToString() : "";
                    string cnt = oCnt >= 0 && !r.IsDBNull(oCnt) ? r.GetValue(oCnt).ToString() : "";
                    string loc = string.IsNullOrEmpty(col) ? $"Staging.{tbl}" : $"Staging.{tbl}.{col}";

                    bool isRuleError = sev.Equals("Rule_Error", StringComparison.OrdinalIgnoreCase);
                    bool isUnmapped = !isRuleError && (ruleId == -2 || msg.IndexOf("Not Mapped", StringComparison.OrdinalIgnoreCase) >= 0);
                    bool isError = sev.Equals("Error", StringComparison.OrdinalIgnoreCase);

                    if (isRuleError) { v.RuleErrorCount++; }
                    else if (isUnmapped)
                    {
                        v.UnmappedCount++;
                        string entry = loc + (string.IsNullOrEmpty(cnt) ? "" : $" ({cnt} rows)");
                        if (seen.Add(loc)) { v.UnmappedLocations.Add(entry); }
                    }
                    else if (isError) { v.OtherErrorCount++; }

                    if (v.Total <= maxLines)
                    {
                        lines.Add($"• [{sev}] {loc} — {msg}" + (string.IsNullOrEmpty(cnt) ? "" : $" ({cnt} rows)"));
                    }
                }
                if (v.Total > maxLines) { lines.Add($"… and {v.Total - maxLines} more"); }
            }
            catch (Exception ex)
            {
                lines.Add("(could not read validation results: " + ex.Message + ")");
            }
            v.Summary = string.Join("\n", lines);
            return v;
        }

        private static int TryOrdinal(SqlDataReader reader, string name)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (string.Equals(reader.GetName(i), name, StringComparison.OrdinalIgnoreCase))
                {
                    return i;
                }
            }
            return -1;
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

            // Publish with @SchoolYear as a SMALLINT parameter: strip the inline `DECLARE @SchoolYear ...;`
            // used for live runs, so the procedure is reusable across years.
            string body = Regex.Replace(session.LastEtlSql.Trim(),
                @"(?im)^\s*DECLARE\s+@SchoolYear\s+\w+(\s*\(\s*\d+\s*\))?\s*(=\s*[^;]+)?;\s*", "");
            string createProc =
                $"CREATE OR ALTER PROCEDURE [Staging].[{procName}]\n    @SchoolYear SMALLINT\nAS\nBEGIN\n    SET NOCOUNT ON;\n\n" +
                body.Trim() + "\nEND";

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
                    // Register the task with the @SchoolYear parameter so the migration runner passes the year.
                    cmd.Parameters.AddWithValue("@proc", qualified + " @SchoolYear");
                    cmd.Parameters.AddWithValue("@ft", factTypeId);
                    cmd.Parameters.AddWithValue("@desc", description);
                    cmd.Parameters.AddWithValue("@task", mapLabel);
                    taskId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                session.GeneratedProcedureName = qualified;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"📦 Published as stored procedure [{qualified}] (@SchoolYear SMALLINT) and registered in App.DataMigrationTasks (task {taskId}, staging). Run it with EXEC {qualified} @SchoolYear = {ResolveSchoolYear(session)};.");
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

        // The concrete source object identifier(s) for a session. Resolution order, most authoritative first:
        //   1. The map's registered EtlMapSource rows (explicit multi-source registry).
        //   2. The distinct SourceSchema.SourceTable of the map's element mappings — i.e. DERIVED from the
        //      ETL Mapping data itself, so the user never has to type the source object on the session.
        //   3. The session's own SourceObject (legacy/manual override), only if the mapping yields nothing.
        // Used to tell the model the exact FROM target(s) and to repair `<source_table>` placeholders.
        private List<string> ResolveSourceObjects(EtlChatSession session)
        {
            var mapSources = _mappingService.GetMapSources(session.EtlMapId) ?? new List<EtlMapSource>();
            var list = mapSources
                .Where(s => !string.IsNullOrWhiteSpace(s.SourceObject))
                .Select(s => s.SourceObject.Trim())
                .ToList();

            // Derive from the mapping's source table columns when no explicit registry exists.
            if (list.Count == 0)
            {
                list = GetMappedSourceObjects(session.EtlMapId);
            }

            // Last resort: the manually-entered session source object.
            if (list.Count == 0 && !string.IsNullOrWhiteSpace(session.SourceObject))
            {
                list.Add(session.SourceObject.Trim());
            }
            return list;
        }

        // Distinct source objects the element mappings point at, as [Schema.]Table (the DB is assumed to be
        // the current one). This is the source object(s) the map already knows about — no user input needed.
        private List<string> GetMappedSourceObjects(int etlMapId)
        {
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            var result = new List<string>();
            foreach (var m in _mappingService.GetAllMappings(etlMapId))
            {
                if (string.IsNullOrWhiteSpace(m.SourceTableName)) continue;
                string schema = string.IsNullOrWhiteSpace(m.SourceSchemaName) ? "" : m.SourceSchemaName.Trim() + ".";
                string obj = (schema + m.SourceTableName.Trim());
                if (seen.Add(obj)) result.Add(obj);
            }
            return result;
        }

        // Matches angle-bracket placeholders that stand in for the SOURCE object, e.g. <source_table>,
        // < source >, <SourceObject>, <source_table_name>, <your_source_table>. Deliberately narrow to
        // SOURCE-specific tokens so it never touches real comparisons (a < b), <>, a `<src>` in a CASE
        // example, or a target-table/column placeholder like <table_name>/<column_name>.
        private static readonly Regex SourcePlaceholderRegex = new Regex(
            @"<\s*(?:source[_ ]?table(?:[_ ]?name)?|source[_ ]?object|your[_ ]?source[_ ]?table|source)\s*>",
            RegexOptions.IgnoreCase | RegexOptions.Compiled);

        // Loop-break: true when the model just re-sent a chunk IDENTICAL to the previous attempt for this
        // table that already failed (an idempotent loop). We stop re-executing the same failing SQL and hand
        // control back instead of burning loops.
        private bool IsRepeatOfLastFailedChunk(EtlChatSession session, string table, string sql)
        {
            var msgs = GetMessages(session.EtlChatSessionId);
            string marker = $"-- ETL SQL (Staging.{table})";
            for (int i = msgs.Count - 1; i >= 0; i--)
            {
                var msg = msgs[i];
                if (msg.Role == EtlChatRole.Assistant && msg.MessageType == EtlChatMessageType.Sql
                    && (msg.Content ?? "").TrimStart().StartsWith(marker))
                {
                    string priorSql = (msg.Content ?? "");
                    int nl = priorSql.IndexOf('\n');
                    priorSql = (nl >= 0 ? priorSql.Substring(nl + 1) : priorSql).Trim();
                    bool errAfter = msgs.Skip(i + 1).Any(x => x.MessageType == EtlChatMessageType.Error);
                    return errAfter && string.Equals(priorSql, (sql ?? "").Trim(), StringComparison.Ordinal);
                }
            }
            return false;
        }

        // Deterministic backstop for the #1 observed failure: the model writes a placeholder like
        // `<source_table>` in FROM instead of the real object (invalid T-SQL → "Incorrect syntax near '<'").
        // If exactly one source object is known, substitute it; if none/many, we can't guess — signal the
        // caller to bounce back naming the real object(s). Returns the (possibly fixed) SQL.
        private (string Sql, string Note, bool Blocked) FixSourcePlaceholders(EtlChatSession session, string sql)
        {
            if (string.IsNullOrWhiteSpace(sql) || !SourcePlaceholderRegex.IsMatch(sql))
            {
                return (sql, null, false);
            }
            var sources = ResolveSourceObjects(session);
            if (sources.Count == 1)
            {
                string fixedSql = SourcePlaceholderRegex.Replace(sql, sources[0]);
                return (fixedSql, $"🩹 Replaced a source-table placeholder with the actual source object `{sources[0]}` before running.", false);
            }
            return (sql, null, true); // 0 or several known sources — can't safely auto-pick
        }

        private List<OllamaMessage> BuildPrompt(EtlChatSession session, string trailingUserMessage = null)
        {
            var messages = new List<OllamaMessage>
            {
                new OllamaMessage { Role = EtlChatRole.System, Content = BuildSystemPrompt(session) }
            };

            // Repl ay recent transcript so the model can iterate. This growing transcript IS the model's
            // working context — prior chunks it built, lookup results, and execution errors all stay in view,
            // so it fixes the current table conversationally instead of re-deriving from scratch each turn.
            var transcript = GetMessages(session.EtlChatSessionId);
            foreach (var m in transcript.Skip(Math.Max(0, transcript.Count - 24)))
            {
                string role = m.Role == EtlChatRole.User ? EtlChatRole.User
                            : m.Role == EtlChatRole.Assistant ? EtlChatRole.Assistant
                            : EtlChatRole.User; // tool feedback relayed as user context
                string prefix = m.Role == EtlChatRole.Tool ? "[EXECUTION RESULT] " : "";
                messages.Add(new OllamaMessage { Role = role, Content = prefix + TrimReplayContent(m.Content) });
            }

            messages.Add(new OllamaMessage
            {
                Role = EtlChatRole.User,
                Content = trailingUserMessage ??
                    "Produce the next step now. If anything about the source/target schema is unclear, first send a ```lookup block with a read-only SELECT (e.g. against INFORMATION_SCHEMA.COLUMNS) to verify it; otherwise send the ```sql ETL block. If a previous attempt was approved or only needs a small fix, re-send the corrected SQL — do not ask again."
            });
            return messages;
        }

        // Execution-error messages echo the full "-- SQL executed --" block, which is redundant on replay
        // (the model's own ```sql message is right above it) and buries the actionable "Invalid column
        // name …" lines in a wall of repeated SQL. Drop that echo on replay so the real error stays in view.
        private static string TrimReplayContent(string content)
        {
            if (string.IsNullOrEmpty(content)) return content ?? string.Empty;
            int marker = content.IndexOf("-- SQL executed --", StringComparison.OrdinalIgnoreCase);
            return marker > 0 ? content.Substring(0, marker).TrimEnd() : content;
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
            int schoolYear = ResolveSchoolYear(session);

            // A file spec may draw from SEVERAL registered source datasets. Inject each source's schema
            // (types/lengths) + a sample, and instruct joining them on the shared business keys. Falls back
            // to the session's single SourceObject when no sources are registered on the map.
            // The EXACT source identifier(s) the FROM/JOIN clauses must use. Small models otherwise copy a
            // placeholder like `<source_table>` from generic examples (an invalid-syntax failure we hit
            // repeatedly), so we name them here and forbid placeholders — and back it with a deterministic
            // substitution before execution (FixSourcePlaceholders).
            var sourceObjects = ResolveSourceObjects(session);
            string fromList = sourceObjects.Count > 0 ? string.Join(", ", sourceObjects.Select(s => "`" + s + "`")) : null;
            string primarySource = sourceObjects.Count > 0 ? sourceObjects[0] : null;

            // Enrich resolved source objects with any registry metadata (name/connection/notes). Sources may
            // be REGISTERED (EtlMapSource) or DERIVED from the mapping's SourceTable columns — either way we
            // inject EVERY source's real columns + sample below, so the model never has to guess a column on
            // a source it can't see (the #1 cause of the "Invalid column name" retry loop).
            var mapSources = _mappingService.GetMapSources(session.EtlMapId) ?? new List<EtlMapSource>();
            var registryByObject = mapSources
                .Where(s => !string.IsNullOrWhiteSpace(s.SourceObject))
                .GroupBy(s => s.SourceObject.Trim(), StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);

            if (sourceObjects.Count > 1)
            {
                sb.AppendLine($"## Sources ({sourceObjects.Count}) — this file spec draws from multiple source datasets");
                sb.AppendLine("Build the load by JOIN/UNION across these sources on the shared business keys (student id, LEA id, school id, school year). CRITICAL: join and select ONLY columns listed under each source below. If a column is NOT in a source's list, it does NOT exist on that source — do not reference it, and do not assume every source has the same columns.");
                if (fromList != null)
                    sb.AppendLine($"Use these EXACT source objects verbatim in FROM/JOIN: {fromList}. NEVER invent a source column name or a placeholder like `<source_table>`.");
                foreach (var obj in sourceObjects)
                {
                    registryByObject.TryGetValue(obj, out var reg);
                    string name = reg != null && !string.IsNullOrWhiteSpace(reg.SourceName) ? reg.SourceName : obj;
                    sb.AppendLine($"### Source \"{name}\" — {obj}");
                    if (reg != null && !string.IsNullOrWhiteSpace(reg.SourceConnection)) sb.AppendLine($"- connection: {reg.SourceConnection}");
                    string cols = GetSourceColumns(obj);
                    if (!string.IsNullOrWhiteSpace(cols)) sb.AppendLine($"- columns: {cols}");
                    else sb.AppendLine("- columns: (could not read — inspect with a ```lookup before using this source)");
                    string samp = ReadSourceSample(obj, 5);
                    if (!string.IsNullOrWhiteSpace(samp)) { sb.AppendLine("- sample (TOP 5):"); sb.AppendLine(samp); }
                    if (reg != null && !string.IsNullOrWhiteSpace(reg.Notes))
                    {
                        string n = reg.Notes.Replace("\r", " ").Replace("\n", " ").Trim();
                        sb.AppendLine($"- notes: {(n.Length > 300 ? n.Substring(0, 300) + "…" : n)}");
                    }
                }
            }
            else
            {
                // Single source — taken from the ETL Mapping data (the mapped source table) unless the
                // session carries a manual override. The user does NOT need to type the source object.
                string src = primarySource ?? session.SourceObject;
                sb.AppendLine("## Source");
                sb.AppendLine($"- Connection/descriptor: {session.SourceConnection ?? "(same database)"}");
                sb.AppendLine($"- Source object (table/view/query): {src ?? "(unknown — no source table is mapped; map at least one source column with its table name)"}");
                if (!string.IsNullOrWhiteSpace(src))
                    sb.AppendLine($"- IMPORTANT: your FROM clause MUST be exactly `FROM {src}`, copied verbatim (this is the source table recorded in the ETL Mapping). NEVER write a placeholder like `<source_table>`, `<source>`, `<YourSourceTable>`, or `[SourceTable]` — that is a syntax error and the load will fail.");
                string sourceCols = GetSourceColumns(src);
                if (!string.IsNullOrWhiteSpace(sourceCols))
                {
                    sb.AppendLine($"- Source columns: {sourceCols}");
                }
            }
            sb.AppendLine($"- Target school year (end year): {schoolYear}. Use {schoolYear} as the literal school-year value.");

            // How the sources relate + any map-level filtering/processing the author specified. Declared
            // joins are authoritative — rendering them here stops the model inventing join columns (the
            // "Invalid column name" retry loop). Free-text notes cover anything the join grid can't express.
            var declaredJoins = _mappingService.GetMapJoins(session.EtlMapId) ?? new List<EtlMapJoin>();
            var mapInfo = (_mappingService.GetMaps() ?? new List<EtlMapDto>()).FirstOrDefault(mm => mm.EtlMapId == session.EtlMapId);
            string joinText = mapInfo?.JoinInstructions;
            string processingText = mapInfo?.ProcessingNotes;
            if (declaredJoins.Count > 0 || !string.IsNullOrWhiteSpace(joinText))
            {
                sb.AppendLine();
                sb.AppendLine("## How the source tables join (use these EXACTLY — do NOT invent join columns)");
                foreach (var g in declaredJoins
                             .Where(j => !string.IsNullOrWhiteSpace(j.LeftSourceObject) && !string.IsNullOrWhiteSpace(j.RightSourceObject))
                             .GroupBy(j => new { L = j.LeftSourceObject.Trim(), R = j.RightSourceObject.Trim(), T = string.IsNullOrWhiteSpace(j.JoinType) ? "LEFT" : j.JoinType.Trim().ToUpperInvariant() }))
                {
                    var conds = g.OrderBy(x => x.SortOrder)
                                 .Where(x => !string.IsNullOrWhiteSpace(x.LeftColumn) && !string.IsNullOrWhiteSpace(x.RightColumn))
                                 .Select(x => $"{g.Key.L}.{x.LeftColumn.Trim()} = {g.Key.R}.{x.RightColumn.Trim()}");
                    string on = string.Join(" AND ", conds);
                    sb.AppendLine($"- {g.Key.T} JOIN {g.Key.R} ON " + (on.Length > 0 ? on : "(conditions not specified — see the join notes below)"));
                }
                if (!string.IsNullOrWhiteSpace(joinText))
                {
                    sb.AppendLine("Author's join notes: " + joinText.Replace("\r", " ").Replace("\n", " ").Trim());
                }
                sb.AppendLine("Build FROM the first source and add the joins above; use ONLY the exact columns named for each ON clause.");
            }
            if (!string.IsNullOrWhiteSpace(processingText))
            {
                sb.AppendLine();
                sb.AppendLine("## Processing & filtering rules for this map (apply while selecting the source rows)");
                sb.AppendLine(processingText.Trim());
            }
            sb.AppendLine();
            sb.AppendLine("## ETL alignment map (complete — source → CEDS → Staging, with source data types, transforms, status & option-set values)");
            sb.AppendLine("This is the full curated mapping for this map. Use it as the source of truth for how each source column becomes a Staging column and how each coded value translates.");

            string Clip(string s)
            {
                if (string.IsNullOrWhiteSpace(s)) return s;
                s = s.Replace("\r", " ").Replace("\n", " ").Trim();
                return s.Length > 220 ? s.Substring(0, 220) + "…" : s;
            }

            var mappings = _mappingService.GetAllMappings(session.EtlMapId);
            var activeTables = AllowedStagingTables(session.EtlMapId);
            var stagingTables = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in mappings)
            {
                string srcCol = "";
                if (!string.IsNullOrWhiteSpace(m.SourceColumnName) || !string.IsNullOrWhiteSpace(m.SourceTableName))
                {
                    string tbl = string.IsNullOrWhiteSpace(m.SourceTableName) ? "" : m.SourceTableName + ".";
                    string typ = string.IsNullOrWhiteSpace(m.SourceDataType) ? "" :
                        " " + m.SourceDataType + (string.IsNullOrWhiteSpace(m.SourceDataLength) ? "" : $"({m.SourceDataLength})");
                    srcCol = $" [{tbl}{m.SourceColumnName}{typ}]";
                }
                string ceds = string.IsNullOrWhiteSpace(m.CedsElementName) ? "(unmapped)"
                    : $"{m.CedsElementName} ({m.CedsElementGlobalId})";
                // Prune the fan-out to the active tables so the model only sees destinations for tables that
                // are really in this map (anchored by a discrete mapping) — not every table with that column.
                var prunedPairs = PruneToActive(m.StagingTableColumns, activeTables);
                string staging = prunedPairs.Count > 0 ? string.Join("; ", prunedPairs) : "(no staging target)";
                string status = string.IsNullOrWhiteSpace(m.MappingStatus) ? "" : $" [{m.MappingStatus}]";
                string match = (!string.IsNullOrWhiteSpace(m.MatchType) || m.MatchConfidence.HasValue)
                    ? $"  (match: {m.MatchType}{(m.MatchConfidence.HasValue ? $" {Math.Round(m.MatchConfidence.Value * 100)}%" : "")})" : "";

                sb.AppendLine($"- {m.SourceElementName}{srcCol}{status} → CEDS {ceds} → Staging {staging}{match}");
                if (!string.IsNullOrWhiteSpace(m.SourceElementDefinition)) sb.AppendLine($"    source def: {Clip(m.SourceElementDefinition)}");
                if (!string.IsNullOrWhiteSpace(m.TransformationRules)) sb.AppendLine($"    transform: {Clip(m.TransformationRules)}");
                if (!string.IsNullOrWhiteSpace(m.SelectionCriteria)) sb.AppendLine($"    selection: {Clip(m.SelectionCriteria)}");
                if (!string.IsNullOrWhiteSpace(m.Notes)) sb.AppendLine($"    notes: {Clip(m.Notes)}");

                foreach (var pair in prunedPairs)
                {
                    stagingTables.Add(TableOf(pair));
                }

                var opts = (m.EtlSourceOptionSetMappings ?? new List<EtlSourceOptionSetMapping>()).ToList();
                if (opts.Count > 0)
                {
                    var optLines = opts.Select(o =>
                        $"'{o.SourceOptionSetCode}'" + (string.IsNullOrWhiteSpace(o.SourceOptionSetDescription) ? "" : $" ({o.SourceOptionSetDescription})") + "→" +
                        (string.IsNullOrWhiteSpace(o.CedsOptionSetCode) ? "(unmapped)" : $"'{o.CedsOptionSetCode}'" + (string.IsNullOrWhiteSpace(o.CedsOptionSetDescription) ? "" : $" ({o.CedsOptionSetDescription})")) +
                        (string.IsNullOrWhiteSpace(o.MappingStatus) ? "" : $" [{o.MappingStatus}]"));
                    sb.AppendLine($"    option-set values ({opts.Count}): {string.Join(", ", optLines)}");
                }
            }
            if (mappings.Count == 0)
            {
                sb.AppendLine("- (no mappings in this map yet — ask the user to confirm the source/target if unclear)");
            }

            // Context: the CEDS permitted values each mapped option set allows, so coded transforms are valid.
            string cedsValues = BuildCedsOptionValuesContext(mappings);
            if (!string.IsNullOrWhiteSpace(cedsValues))
            {
                sb.AppendLine();
                sb.AppendLine("## CEDS permitted option-set values (transform each coded source value to ONE of these)");
                sb.AppendLine(cedsValues);
            }

            sb.AppendLine();
            sb.AppendLine("## Target — I drive ONE Staging table per turn (build only the table I name)");
            if (stagingTables.Count > 0)
            {
                int ti = 0;
                foreach (var t in stagingTables) { sb.AppendLine($"  {++ti}. Staging.{t}"); }
                sb.AppendLine($"- This map targets {stagingTables.Count} Staging table(s). I ask you for ONE at a time. Each turn, build ONLY the single table I name — a DELETE+INSERT pair for just that table. Do NOT load them all in one script, and do NOT re-send tables already loaded this session. I stitch the per-table blocks together at the end.");
            }
            else
            {
                sb.AppendLine("- Target table(s): (from the mappings above)");
            }
            sb.AppendLine("- Write ONLY to the Staging schema.");
            sb.AppendLine();

            // Inject each target Staging table's real columns + types + nullability so the model uses
            // correct types (bit -> 1/0) and populates required (NOT NULL) columns like RecordStartDateTime.
            if (stagingTables.Count > 0)
            {
                sb.AppendLine("## Staging table columns (name : type ; NOT NULL / bit are flagged)");
                sb.AppendLine("Use these EXACT columns and types. INSERT ONLY the columns that have a mapped source (I list them for the table I name each turn) — OMIT any column with no source mapping; do NOT invent a value for it even if it is NOT NULL. Every `bit` column takes 1 or 0 only.");
                foreach (var t in stagingTables)
                {
                    string cols = GetStagingColumns(t);
                    if (!string.IsNullOrWhiteSpace(cols))
                    {
                        sb.AppendLine($"- Staging.{t}: {cols}");
                    }
                }
                sb.AppendLine();
            }

            // Authoritative file-spec requirements: EVERY Staging table + column this EDFacts file spec needs,
            // with data types and the CEDS reference (SSRD) table each coded column translates through.
            string fileSpecReqs = GetFileSpecStagingRequirements(runbook);
            if (!string.IsNullOrWhiteSpace(fileSpecReqs))
            {
                string codeList = runbook.ReportCodes.Count > 0 ? string.Join(", ", runbook.ReportCodes) : runbook.FactTypeCode;
                sb.AppendLine($"## Full Staging requirements for file spec(s) {codeList} (authoritative — from app.vwStagingRelationships)");
                sb.AppendLine("These are ALL the Staging schema tables & columns this file spec uses, with each column's data type/nullability and the CEDS reference table (SSRD) it maps through. Populate the columns your source provides (honoring NOT NULL and bit rules above); for coded columns, translate source values to the CEDS values shown earlier, which land in the referenced CEDS ref table.");
                sb.AppendLine(fileSpecReqs);
                sb.AppendLine();
            }

            sb.AppendLine("## Rules");
            sb.AppendLine("- Dialect: Microsoft T-SQL (SQL Server) ONLY. Use SELECT TOP (n) — NEVER LIMIT/OFFSET or MySQL/Postgres syntax.");
            sb.AppendLine($"- Reference @SchoolYear (already declared = {schoolYear}) wherever a year is needed — do NOT add your own `DECLARE @SchoolYear` line (I manage a single DECLARE for the stitched script). Treat the year as SMALLINT.");
            sb.AppendLine($"- Make the load idempotent: for the table I name, first `DELETE FROM Staging.<TargetTableName> WHERE SchoolYear = @SchoolYear;` then `INSERT INTO Staging.<TargetTableName> (<only the mapped columns>, SchoolYear) SELECT ..., @SchoolYear FROM {primarySource ?? "<the source object named above>"};` so re-runs do not double-count.");
            sb.AppendLine("- Build ONE table per turn (the one I name). Do NOT combine multiple Staging tables into a single script.");
            if (fromList != null)
                sb.AppendLine($"- CRITICAL: the source object name is KNOWN — use {fromList} verbatim in every FROM/JOIN. Do NOT emit ANY angle-bracket placeholder (e.g. `<source_table>`, `<source>`, `<table_name>`) in the SQL you run; every table, column, and value must be a real identifier. A `<...>` token is invalid T-SQL and the load will fail.");
            sb.AppendLine("- Use ONLY column names shown in the mappings/target list; do not invent columns. Copy the destination Table.Column names EXACTLY.");
            sb.AppendLine("- BIT columns: every `bit` destination column's SELECT expression MUST evaluate to exactly 1, 0, or NULL — nothing else. Look at the source column's ACTUAL sample values (in the Source sample above) and its mapping/transform + option-set to write the conversion. Examples: a Y/N flag → `CASE WHEN <src>='Y' THEN 1 WHEN <src>='N' THEN 0 ELSE NULL END`; a descriptive status like 'Not a charter LEA' → map the specific text values to 1/0 (`CASE WHEN <src>='Not a charter LEA' THEN 0 WHEN <src> LIKE '%charter%' THEN 1 ELSE NULL END`).");
            sb.AppendLine("  A bit column's CASE must NEVER return an empty string ('') , a text value, or the raw source column — that throws 'Conversion failed when converting the varchar value ... to data type bit'. If you are unsure which source value means true vs false, inspect the data first with a ```lookup (e.g. `SELECT DISTINCT <col> FROM <source>`), then write the exact mapping.");
            sb.AppendLine("- INSERT only the columns that have a mapped source element; leave every unmapped column OUT of the INSERT entirely (it keeps its NULL/default). Do NOT fabricate a value just to fill a NOT NULL column — if a required column truly has no source, omit it and it will surface in validation.");
            sb.AppendLine("- For RecordStartDateTime and RecordEndDateTime: use the source's record start/end date if provided. If it is NOT provided, use the CLOSEST available enrollment or program participation date — RecordStartDateTime ← EnrollmentEntryDate, else ProgramParticipationBeginDate; RecordEndDateTime ← EnrollmentExitDate, else ProgramParticipationEndDate. Use COALESCE (e.g. `COALESCE(RecordStartDt, EnrDt, PgmBegDt)`). Only if none of those exist, use `CAST(GETDATE() AS datetime)` for a NOT NULL RecordStartDateTime.");
            sb.AppendLine("- For boolean/indicator/flag columns use CASE, e.g. `CASE WHEN SpedEligFlg = 'Y' THEN 1 ELSE 0 END AS IDEAIndicator`. NEVER write `expr = value AS alias` (e.g. `SpedEligFlg = 'Y' AS IDEAIndicator`) — that is invalid T-SQL and causes 'Incorrect syntax near AS'.");
            sb.AppendLine("- Apply the option set value maps above when transforming coded values.");
            sb.AppendLine("- You may DELETE/INSERT freely, but ONLY within the Staging schema. Do NOT use DROP, TRUNCATE, ALTER, EXEC, xp_ procedures, or write outside Staging.");
            sb.AppendLine("- Do NOT include any test, validation, or count query — the system runs the official validation automatically after your load.");
            sb.AppendLine("- The Staging tables use surrogate identity primary keys that are IRRELEVANT — do NOT ask about primary keys/unique constraints. Records are matched by business keys (student id, LEA id, school id, school year).");
            sb.AppendLine("- The source schema is given above — do NOT ask for it. Only ask a question if genuinely blocked; otherwise inspect or produce SQL and keep going.");
            sb.AppendLine();
            sb.AppendLine("## Inspect the database before writing SQL (recommended)");
            sb.AppendLine("You can run READ-ONLY queries to verify the schema/data before writing the ETL — this is encouraged. To do so, reply with a ```lookup block containing a single read-only SELECT and I will run it and return the rows; then you continue. Good things to check first:");
            sb.AppendLine("- `SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='Staging' AND TABLE_NAME='<target>' ORDER BY ORDINAL_POSITION` — confirm target columns/types (esp. bit and NOT NULL columns).");
            sb.AppendLine($"- The same for the source table to confirm its columns, and `SELECT TOP 5 * FROM {primarySource ?? "<the source object named above>"}` to see sample values before mapping coded values.");
            sb.AppendLine("Lookups are read-only (SELECT only) and count toward the loop budget, so inspect what you need, then write the ETL.");
            sb.AppendLine();
            sb.AppendLine("## Response format");
            sb.AppendLine("Respond with a SINGLE labeled fenced code block:");
            sb.AppendLine("- A ```lookup block with ONE read-only SELECT if you want to inspect the schema/data first (I'll return the rows and you continue); OR");
            sb.AppendLine("- A ```sql block containing the DELETE+INSERT for ONLY the ONE Staging table I name this turn. Do NOT include a `DECLARE @SchoolYear` line (assume @SchoolYear is already declared) and do NOT include any other table.");
            sb.AppendLine("- Do NOT add a test/validation block or any query below the ETL.");
            sb.AppendLine("- Only if you are truly blocked, instead of a block, output one or more lines starting with `QUESTION:`.");
            sb.AppendLine("Put raw SQL inside the fenced block — do NOT wrap SQL in JSON or escape newlines.");
            return sb.ToString();
        }

        // Robustly parse the model's reply. Models are unreliable at emitting valid JSON around multi-line
        // SQL (literal newlines break JSON; key casing varies: etlSql vs ETL_SQL). So we accept, in order:
        // (1) labeled fenced code blocks ```sql / ```test (preferred), (2) tolerant JSON (any key casing),
        // (3) a bare SQL statement, (4) plain prose. This keeps the loop moving instead of stalling.
        private static EtlChatModelReply ParseReply(string reply)
        {
            var result = new EtlChatModelReply { Questions = new List<string>() };
            if (string.IsNullOrWhiteSpace(reply))
            {
                return result;
            }

            // 1) Labeled fenced code blocks.
            foreach (var (label, content) in ExtractCodeBlocks(reply))
            {
                string l = label.ToLowerInvariant();
                if (l == "json")
                {
                    continue; // handled by the JSON pass below
                }
                if (l.Contains("lookup") || l.Contains("inspect") || l.Contains("schema") || l.Contains("explore"))
                {
                    result.LookupSql ??= content;
                }
                else if (l.Contains("test") || l.Contains("valid") || l.Contains("check") || l.Contains("count"))
                {
                    result.TestSql ??= content;
                }
                else if (l.Contains("etl") || l.Contains("sql") || l.Contains("tsql") || l.Length == 0)
                {
                    if (result.EtlSql == null)
                    {
                        result.EtlSql = content;
                    }
                    else if (Regex.IsMatch(content, @"(?i)\b(insert|update|delete|merge)\b"))
                    {
                        // A FURTHER block that writes is MORE of the ETL — models often split the DELETE and
                        // the INSERT…SELECT into separate ```sql fences. Concatenate so the WHOLE load runs;
                        // never drop the INSERT as a "test" (that leaves the table empty and loops forever).
                        result.EtlSql = result.EtlSql.TrimEnd() + "\r\n\r\n" + content;
                    }
                    else
                    {
                        result.TestSql ??= content; // a read-only follow-up block is the validation/count query
                    }
                }
            }

            // 2) Tolerant JSON (only if we still have no ETL SQL).
            if (string.IsNullOrWhiteSpace(result.EtlSql) && string.IsNullOrWhiteSpace(result.LookupSql))
            {
                string json = ExtractJson(reply);
                if (json != null)
                {
                    TryParseJsonTolerant(json, result);
                }
            }

            // A reply with NO write (no INSERT/UPDATE/DELETE/MERGE) is not a staging load — it's a
            // schema-inspection lookup (even if it opens with `DECLARE @SchoolYear…;` then a SELECT, or
            // has leading comments). Reclassify it so we run it read-only and feed the rows back, instead
            // of running it as the ETL and rejecting it as an "incomplete load".
            if (string.IsNullOrWhiteSpace(result.LookupSql) && !string.IsNullOrWhiteSpace(result.EtlSql))
            {
                bool hasWrite = Regex.IsMatch(result.EtlSql, @"(?i)\b(insert|update|delete|merge)\b");
                bool hasSelect = Regex.IsMatch(result.EtlSql, @"(?i)\bselect\b");
                if (!hasWrite && hasSelect)
                {
                    result.LookupSql = result.EtlSql;
                    result.EtlSql = null;
                }
            }

            // 3) Explicit QUESTION: lines (fenced-block format).
            foreach (Match m in Regex.Matches(reply, @"(?im)^\s*(?:QUESTION|Q)\s*[:\-]\s*(.+?)\s*$"))
            {
                string q = m.Groups[1].Value.Trim();
                if (q.Length > 0 && !result.Questions.Contains(q))
                {
                    result.Questions.Add(q);
                }
            }

            // 4) Last resort: a reply that is itself a bare SQL statement.
            if (string.IsNullOrWhiteSpace(result.EtlSql) && result.Questions.Count == 0)
            {
                string trimmed = reply.Trim();
                if (Regex.IsMatch(trimmed, @"(?is)^\s*(with|delete|insert|update|merge|;|declare)\b"))
                {
                    result.EtlSql = trimmed;
                }
                else if (string.IsNullOrWhiteSpace(result.Explanation))
                {
                    result.Explanation = trimmed;
                }
            }

            return result;
        }

        // Extract ```label\n...\n``` blocks as (label, content) pairs.
        private static List<(string label, string content)> ExtractCodeBlocks(string text)
        {
            var list = new List<(string, string)>();
            foreach (Match m in Regex.Matches(text, "```[ \\t]*([A-Za-z0-9_+-]*)[ \\t]*\\r?\\n(.*?)```", RegexOptions.Singleline))
            {
                string content = m.Groups[2].Value.Trim();
                if (content.Length > 0)
                {
                    list.Add((m.Groups[1].Value.Trim(), content));
                }
            }
            return list;
        }

        // Parse a JSON object accepting any key casing/underscores (etlSql, ETL_SQL, etl_sql, sql, …).
        private static bool TryParseJsonTolerant(string json, EtlChatModelReply result)
        {
            try
            {
                using var doc = JsonDocument.Parse(json);
                var root = doc.RootElement;
                if (root.ValueKind != JsonValueKind.Object)
                {
                    return false;
                }
                foreach (var prop in root.EnumerateObject())
                {
                    string key = new string(prop.Name.ToLowerInvariant().Where(char.IsLetterOrDigit).ToArray());
                    switch (key)
                    {
                        case "etlsql": case "sql": case "etl": case "etlstatement": case "loadsql":
                            result.EtlSql ??= JsonValueToString(prop.Value); break;
                        case "testsql": case "test": case "validationsql": case "teststatement":
                            result.TestSql ??= JsonValueToString(prop.Value); break;
                        case "explanation": case "explain": case "notes": case "message": case "comment":
                            result.Explanation ??= JsonValueToString(prop.Value); break;
                        case "questions": case "question":
                            if (prop.Value.ValueKind == JsonValueKind.Array)
                            {
                                result.Questions.AddRange(prop.Value.EnumerateArray()
                                    .Select(e => e.ValueKind == JsonValueKind.String ? e.GetString() : e.GetRawText())
                                    .Where(s => !string.IsNullOrWhiteSpace(s)));
                            }
                            else if (prop.Value.ValueKind == JsonValueKind.String && !string.IsNullOrWhiteSpace(prop.Value.GetString()))
                            {
                                result.Questions.Add(prop.Value.GetString());
                            }
                            break;
                    }
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        private static string JsonValueToString(JsonElement el)
        {
            if (el.ValueKind == JsonValueKind.String) return el.GetString();
            if (el.ValueKind == JsonValueKind.Null || el.ValueKind == JsonValueKind.Undefined) return null;
            return el.GetRawText();
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

        // Reads a Staging table's columns (name, type, nullability) from INFORMATION_SCHEMA so the model
        // uses correct types (bit -> 1/0) and populates required (NOT NULL) columns like RecordStartDateTime.
        // Identity columns are excluded (the model must not insert into them).
        // Formats a SQL type with length/precision, e.g. nvarchar(60), nvarchar(max), decimal(18,2), datetime, bit.
        private static string FormatSqlType(string dataType, object charMaxLen, object numericPrecision, object numericScale)
        {
            string t = (dataType ?? "").ToLowerInvariant();
            int? Len(object o) => (o == null || o == DBNull.Value) ? (int?)null : Convert.ToInt32(o);
            int? maxLen = Len(charMaxLen);
            int? prec = Len(numericPrecision);
            int? scale = Len(numericScale);

            if (t == "varchar" || t == "nvarchar" || t == "char" || t == "nchar" || t == "varbinary" || t == "binary")
            {
                return maxLen.HasValue ? (maxLen.Value == -1 ? $"{t}(max)" : $"{t}({maxLen.Value})") : t;
            }
            if (t == "decimal" || t == "numeric")
            {
                return prec.HasValue ? $"{t}({prec.Value},{scale ?? 0})" : t;
            }
            return t; // int, bit, datetime, smallint, date, etc. — length not meaningful
        }

        private string GetStagingColumns(string tableName)
        {
            if (string.IsNullOrWhiteSpace(tableName)) return null;
            string t = tableName.Replace("[", "").Replace("]", "").Trim();
            int dot = t.IndexOf('.');
            if (dot >= 0) t = t.Substring(dot + 1);
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText =
                    @"SELECT c.COLUMN_NAME, c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH, c.NUMERIC_PRECISION, c.NUMERIC_SCALE, c.IS_NULLABLE
                      FROM INFORMATION_SCHEMA.COLUMNS c
                      WHERE c.TABLE_SCHEMA = 'Staging' AND c.TABLE_NAME = @t
                        AND COLUMNPROPERTY(OBJECT_ID('Staging.' + c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') = 0
                      ORDER BY c.ORDINAL_POSITION";
                cmd.Parameters.AddWithValue("@t", t);
                using var r = cmd.ExecuteReader();
                var cols = new List<string>();
                while (r.Read())
                {
                    string name = r.GetString(0);
                    string type = FormatSqlType(r.IsDBNull(1) ? "" : r.GetString(1), r.GetValue(2), r.GetValue(3), r.GetValue(4));
                    bool nullable = !r.IsDBNull(5) && r.GetString(5).Equals("YES", StringComparison.OrdinalIgnoreCase);
                    cols.Add($"{name} {type}{(nullable ? " NULL" : " NOT NULL")}");
                }
                return cols.Count == 0 ? null : string.Join(", ", cols);
            }
            catch
            {
                return null;
            }
        }

        // Authoritative per-file-spec staging requirements from app.vwStagingRelationships: every Staging
        // table + column the file spec needs, each column's data type/nullability (INFORMATION_SCHEMA), and
        // the CEDS reference table (SSRD) it translates through. Grouped by Staging.<Table>.
        private string GetFileSpecStagingRequirements(EtlFactTypeRunbook rb)
        {
            if (rb == null || string.IsNullOrWhiteSpace(rb.FactTypeCode)) return null;
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                string codeFilter = "";
                if (rb.ReportCodes != null && rb.ReportCodes.Count > 0)
                {
                    var ins = new List<string>();
                    for (int i = 0; i < rb.ReportCodes.Count; i++)
                    {
                        string p = "@rc" + i;
                        ins.Add(p);
                        cmd.Parameters.AddWithValue(p, rb.ReportCodes[i]);
                    }
                    codeFilter = $" AND r.ReportCode IN ({string.Join(",", ins)})";
                }
                cmd.CommandText =
                    @"SELECT DISTINCT r.StagingTableName, r.StagingColumnName,
                             c.DATA_TYPE, c.CHARACTER_MAXIMUM_LENGTH, c.NUMERIC_PRECISION, c.NUMERIC_SCALE, c.IS_NULLABLE,
                             r.SSRDRefTableName, r.SSRDTableFilter,
                             COLUMNPROPERTY(OBJECT_ID('Staging.' + r.StagingTableName), r.StagingColumnName, 'IsIdentity') AS IsIdentity
                      FROM app.vwStagingRelationships r
                      LEFT JOIN INFORMATION_SCHEMA.COLUMNS c
                        ON c.TABLE_SCHEMA = 'Staging' AND c.TABLE_NAME = r.StagingTableName AND c.COLUMN_NAME = r.StagingColumnName
                      WHERE r.FactTypeCode = @ft" + codeFilter + @"
                      ORDER BY r.StagingTableName, r.StagingColumnName";
                cmd.Parameters.AddWithValue("@ft", rb.FactTypeCode);

                var byTable = new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);
                var order = new List<string>();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string table = reader.IsDBNull(0) ? "" : reader.GetString(0);
                        string col = reader.IsDBNull(1) ? "" : reader.GetString(1);
                        if (string.IsNullOrWhiteSpace(table) || string.IsNullOrWhiteSpace(col)) continue;
                        bool isIdentity = !reader.IsDBNull(9) && Convert.ToInt32(reader.GetValue(9)) == 1;
                        if (isIdentity) continue; // don't ask the model to populate identity keys

                        string type = FormatSqlType(reader.IsDBNull(2) ? "" : reader.GetString(2), reader.GetValue(3), reader.GetValue(4), reader.GetValue(5));
                        bool nullable = !reader.IsDBNull(6) && reader.GetString(6).Equals("YES", StringComparison.OrdinalIgnoreCase);
                        string ssrd = reader.IsDBNull(7) ? null : reader.GetString(7);
                        string filter = reader.IsDBNull(8) ? null : reader.GetString(8);

                        string line = $"    - {col} {type}{(nullable ? " NULL" : " NOT NULL")}";
                        if (!string.IsNullOrWhiteSpace(ssrd))
                        {
                            line += $"  → CEDS ref: {ssrd}" + (string.IsNullOrWhiteSpace(filter) ? "" : $" (TableFilter '{filter}')");
                        }

                        if (!byTable.TryGetValue(table, out var list)) { list = new List<string>(); byTable[table] = list; order.Add(table); }
                        list.Add(line);
                    }
                }
                if (order.Count == 0) return null;

                var sb = new StringBuilder();
                foreach (var table in order)
                {
                    sb.AppendLine($"  Staging.{table}");
                    foreach (var l in byTable[table]) sb.AppendLine(l);
                }
                return sb.ToString().TrimEnd();
            }
            catch
            {
                return null;
            }
        }

        // Reads the source object's columns from INFORMATION_SCHEMA so the model doesn't have to ask.
        private string GetSourceColumns(string sourceObject)
        {
            if (string.IsNullOrWhiteSpace(sourceObject)) return null;
            string obj = sourceObject.Trim();
            if (obj.IndexOf(' ') >= 0 || obj.IndexOf('(') >= 0) return null; // a query, not a plain identifier
            obj = obj.Replace("[", "").Replace("]", "");
            string schema = null, table = obj;
            int dot = obj.LastIndexOf('.');
            if (dot > 0) { schema = obj.Substring(0, dot); table = obj.Substring(dot + 1); }
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText =
                    @"SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, IS_NULLABLE
                      FROM INFORMATION_SCHEMA.COLUMNS
                      WHERE TABLE_NAME = @t AND (@s IS NULL OR TABLE_SCHEMA = @s)
                      ORDER BY ORDINAL_POSITION";
                cmd.Parameters.AddWithValue("@t", table);
                cmd.Parameters.AddWithValue("@s", (object)schema ?? DBNull.Value);
                using var r = cmd.ExecuteReader();
                var cols = new List<string>();
                while (r.Read())
                {
                    string type = FormatSqlType(r.IsDBNull(1) ? "" : r.GetString(1), r.GetValue(2), r.GetValue(3), r.GetValue(4));
                    bool nullable = !r.IsDBNull(5) && r.GetString(5).Equals("YES", StringComparison.OrdinalIgnoreCase);
                    cols.Add($"{r.GetString(0)} {type}{(nullable ? " NULL" : " NOT NULL")}");
                }
                return cols.Count == 0 ? null : string.Join(", ", cols);
            }
            catch
            {
                return null;
            }
        }

        // -------------------- Context gathering (feed the model grounded context BEFORE it writes/debugs) --------------------
        // Directive (Nathan): run an explicit context phase as its own step and feed the results into the
        // next step. Phase-1 authoring gathers from the ETL map (+ source sample + CEDS permitted values);
        // a bug/debug gathers from INFORMATION_SCHEMA for the objects the failing SQL/error references.

        // Cross-schema INFORMATION_SCHEMA gather: for every schema.object referenced in the given text
        // (failing SQL + error message), return its columns/types/nullability so the debug/fix step reasons
        // from the real schema instead of guessing. Also picks up bare Staging tables named in guidance.
        private string GatherSchemaContext(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return null;
            var sb = new StringBuilder();
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            // 1) schema-qualified objects: RDS.DimLeas, Staging.StateDetail, App.DataMigrationHistories, ...
            foreach (Match m in Regex.Matches(text, @"\b([A-Za-z][A-Za-z0-9_]*)\.\[?([A-Za-z][A-Za-z0-9_]{2,})\]?"))
            {
                string schema = m.Groups[1].Value, obj = m.Groups[2].Value;
                if (!seen.Add(schema + "." + obj)) continue;
                string cols = GetAnyObjectColumns(schema, obj);
                if (!string.IsNullOrWhiteSpace(cols)) sb.AppendLine($"- {schema}.{obj}: {cols}");
            }
            // 2) bare Staging tables mentioned (e.g. guidance like "populate StateDetail").
            foreach (var t in MentionedStagingTables(text))
            {
                if (!seen.Add("Staging." + t)) continue;
                string cols = GetStagingColumns(t);
                if (!string.IsNullOrWhiteSpace(cols)) sb.AppendLine($"- Staging.{t}: {cols}");
            }
            return sb.Length == 0 ? null : sb.ToString().TrimEnd();
        }

        // Columns/types/nullability for ANY schema.object via INFORMATION_SCHEMA (NOT NULL flagged).
        private string GetAnyObjectColumns(string schema, string objectName)
        {
            if (string.IsNullOrWhiteSpace(schema) || string.IsNullOrWhiteSpace(objectName)) return null;
            try
            {
                using var conn = new SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText =
                    @"SELECT c.COLUMN_NAME, c.DATA_TYPE, c.IS_NULLABLE
                      FROM INFORMATION_SCHEMA.COLUMNS c
                      WHERE c.TABLE_SCHEMA = @s AND c.TABLE_NAME = @t
                      ORDER BY c.ORDINAL_POSITION";
                cmd.Parameters.AddWithValue("@s", schema);
                cmd.Parameters.AddWithValue("@t", objectName);
                using var r = cmd.ExecuteReader();
                var cols = new List<string>();
                while (r.Read())
                {
                    string name = r.GetString(0);
                    string type = r.IsDBNull(1) ? "" : r.GetString(1);
                    bool nullable = !r.IsDBNull(2) && r.GetString(2).Equals("YES", StringComparison.OrdinalIgnoreCase);
                    cols.Add($"{name} {type}{(nullable ? "" : " NOT NULL")}");
                }
                return cols.Count == 0 ? null : string.Join(", ", cols);
            }
            catch { return null; }
        }

        // A TOP-N read-only sample of the source object so the model sees real/coded values before mapping.
        private string ReadSourceSample(string sourceObject, int topN)
        {
            if (string.IsNullOrWhiteSpace(sourceObject)) return null;
            string obj = sourceObject.Trim();
            if (obj.IndexOf(' ') >= 0 || obj.IndexOf('(') >= 0 || obj.IndexOf(';') >= 0) return null; // plain identifier only
            try
            {
                string rows = ReadTabular($"SELECT TOP ({topN}) * FROM {obj}", topN, out int n);
                return n > 0 ? rows : null;
            }
            catch { return null; }
        }

        // CEDS permitted option-set values for each mapped element that carries option-set mappings, so the
        // model transforms coded source values to a VALID CEDS code.
        private string BuildCedsOptionValuesContext(List<EtlSourceElementMapping> mappings)
        {
            if (mappings == null) return null;
            var sb = new StringBuilder();
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in mappings.Where(x => !string.IsNullOrWhiteSpace(x.CedsElementGlobalId)
                        && x.EtlSourceOptionSetMappings != null && x.EtlSourceOptionSetMappings.Any()))
            {
                if (!seen.Add(m.CedsElementGlobalId)) continue;
                List<CedsOptionSetValueDto> vals;
                try { vals = _mappingService.GetCedsOptionSetValues(m.CedsElementGlobalId); }
                catch { continue; }
                if (vals == null || vals.Count == 0) continue;
                sb.AppendLine($"- {m.CedsElementName}: {string.Join(", ", vals.Take(40).Select(v => v.CedsOptionSetCode))}" + (vals.Count > 40 ? " …" : ""));
            }
            return sb.Length == 0 ? null : sb.ToString().TrimEnd();
        }

        // Distinct target Staging tables for the load: active (discrete 1-to-1) ∩ file-spec-required.
        // Fan-out-only tables and active-but-not-required tables are both excluded.
        private List<string> GetMappedStagingTables(int etlMapId)
        {
            return AllowedStagingTables(etlMapId).ToList();
        }

        // The mapped staging columns for ONE target table, each with its source expression hint + any
        // coded-value translations. Only columns with a mapped source appear — the model INSERTs exactly
        // these and OMITS every unmapped staging column (we do NOT force NOT NULL columns that have no source).
        private List<string> GetMappedColumnsForTable(int etlMapId, string table)
        {
            var lines = new List<string>();
            var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (var m in _mappingService.GetAllMappings(etlMapId).Where(x => !string.IsNullOrWhiteSpace(x.StagingTableColumns)))
            {
                foreach (var tc in m.StagingTableColumns.Split(';'))
                {
                    string pair = tc.Trim();
                    if (pair.StartsWith("Staging.", StringComparison.OrdinalIgnoreCase)) pair = pair.Substring("Staging.".Length);
                    var parts = pair.Split('.');
                    if (parts.Length < 2) continue;
                    if (!string.Equals(parts[0].Trim(), table, StringComparison.OrdinalIgnoreCase)) continue;
                    string stagingCol = parts[1].Trim();
                    if (!seen.Add(stagingCol)) continue;
                    string src = string.IsNullOrWhiteSpace(m.SourceColumnName)
                        ? "(derived/constant per transform)"
                        : (string.IsNullOrWhiteSpace(m.SourceTableName) ? "" : m.SourceTableName.Trim() + ".") + m.SourceColumnName.Trim();
                    string transform = string.IsNullOrWhiteSpace(m.TransformationRules) ? "" : "  transform: " + ClipText(m.TransformationRules, 160);
                    var opts = (m.EtlSourceOptionSetMappings ?? new List<EtlSourceOptionSetMapping>()).ToList();
                    string optStr = opts.Count > 0
                        ? "  values: " + string.Join(", ", opts.Select(o => $"'{o.SourceOptionSetCode}'→'{o.CedsOptionSetCode}'"))
                        : "";
                    lines.Add($"{stagingCol}  ← {src}{transform}{optStr}");
                }
            }
            return lines;
        }

        private static string ClipText(string s, int max)
        {
            if (string.IsNullOrWhiteSpace(s)) return s;
            s = s.Replace("\r", " ").Replace("\n", " ").Trim();
            return s.Length > max ? s.Substring(0, max) + "…" : s;
        }

        // Strip a leading `DECLARE @SchoolYear ...;` line from a per-table chunk. Chunks are stored
        // DECLARE-free and stitched under a single DECLARE at the top of the final script; a temporary
        // DECLARE is prepended only for standalone chunk execution.
        private static string StripYearDeclare(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql)) return sql;
            return Regex.Replace(sql, @"^\s*DECLARE\s+@SchoolYear\b[^\r\n;]*;?[ \t]*\r?\n?", "",
                RegexOptions.IgnoreCase | RegexOptions.Multiline).TrimStart();
        }

        // The focused, per-table instruction that drives ONE Staging table per turn. Names the exact table,
        // lists ONLY its mapped columns (insert exactly these, omit the rest), and — when earlier tables are
        // already loaded this session — reminds the model to build just the current one, keeping the task
        // small enough for a 7B model and avoiding the "reproduce the whole multi-table script" loop.
        private string BuildPerTableNudge(EtlChatSession session, string table, int index, int total, List<string> alreadyLoaded)
        {
            int year = ResolveSchoolYear(session);
            var cols = GetMappedColumnsForTable(session.EtlMapId, table);
            var sb = new StringBuilder();
            sb.AppendLine($"Build the load for Staging.{table} now — table {index} of {total}.");
            if (alreadyLoaded != null && alreadyLoaded.Count > 0)
                sb.AppendLine($"(Already loaded this session: {string.Join(", ", alreadyLoaded.Select(t => "Staging." + t))}. Do NOT re-send those — build ONLY Staging.{table}.)");
            sb.AppendLine();
            sb.AppendLine($"INSERT ONLY these mapped columns into Staging.{table} (omit every other column — unmapped columns are left out of the INSERT, NOT set to a made-up value):");
            if (cols.Count > 0)
                foreach (var c in cols) sb.AppendLine($"  • {c}");
            else
                sb.AppendLine("  • (no columns mapped to this table — skip it)");
            sb.AppendLine();
            sb.AppendLine($"Emit ONE ```sql block containing exactly: `DELETE FROM Staging.{table} WHERE SchoolYear = @SchoolYear;` then a single `INSERT INTO Staging.{table} (<only the mapped columns above, plus SchoolYear>) SELECT ... ` from the real source object(s). Assume `@SchoolYear` (= {year}) is already declared — do NOT add a DECLARE. Apply the transforms/value-maps shown. If you must inspect the schema first, send a ```lookup block instead.");
            return sb.ToString().TrimEnd();
        }

        // Which mapped target tables the generated ETL did NOT INSERT into (static check of the SQL, so it's
        // robust to pre-existing/stale rows). Empty => the load covered every mapped table.
        private List<string> MappedTablesNotInserted(int etlMapId, string etlSql)
        {
            if (string.IsNullOrWhiteSpace(etlSql)) return new List<string>();
            return GetMappedStagingTables(etlMapId)
                .Where(t => !Regex.IsMatch(etlSql, @"INSERT\s+INTO\s+(\[?Staging\]?\.)?\[?" + Regex.Escape(t) + @"\]?\b", RegexOptions.IgnoreCase))
                .ToList();
        }

        // Phase-1 context step: once per session, deterministically gather grounding context (source sample
        // + CEDS permitted values) from the ETL map/source and post it as a visible step. It is replayed into
        // the model prompt (BuildPrompt), so the model writes the load against real schema/values, not guesses.
        // Preflight readiness gate: post a coverage report ONCE at the start of a session. If the map is
        // missing a required Staging table (or a required NOT NULL business column), the report migration
        // can never complete — so we flag it loudly here rather than letting the session run to a dead end.
        private void PostCoveragePreflightOnce(EtlChatSession session)
        {
            bool already = GetMessages(session.EtlChatSessionId)
                .Any(m => (m.Content ?? "").Contains("Mapping readiness check"));
            if (already) return;

            EtlMappingCoverageDto cov;
            try { cov = ComputeCoverage(session.EtlMapId); }
            catch { return; } // advisory only — never block the session on the check itself

            if (cov == null || !cov.Resolved) return; // nothing authoritative to compare against — stay quiet

            if (cov.IsReady)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"✅ Mapping readiness check — the map covers all {cov.RequiredTableCount} Staging table(s) required for {cov.FactTypeCode}" +
                    (string.IsNullOrWhiteSpace(cov.ReportCodes) ? "" : $" (report code(s) {cov.ReportCodes})") + ". Building the load.");
                _appRepository.Save();
                return;
            }

            var sb = new StringBuilder();
            sb.AppendLine($"⚠️ Mapping readiness check — this map is NOT ready to complete an end-to-end migration for {cov.FactTypeCode}" +
                (string.IsNullOrWhiteSpace(cov.ReportCodes) ? "" : $" (report code(s) {cov.ReportCodes})") + ".");
            if (cov.MissingTables.Count > 0)
            {
                sb.AppendLine();
                sb.AppendLine($"Required Staging table(s) with NO element mapped ({cov.MissingTables.Count} of {cov.RequiredTableCount}):");
                foreach (var t in cov.MissingTables) sb.AppendLine($"  • Staging.{t}");
            }
            if (cov.MissingRequiredColumns.Count > 0)
            {
                sb.AppendLine();
                sb.AppendLine("Required NOT NULL column(s) in mapped tables with no source mapping:");
                foreach (var c in cov.MissingRequiredColumns.Take(20)) sb.AppendLine($"  • Staging.{c}");
                if (cov.MissingRequiredColumns.Count > 20) sb.AppendLine($"  • …and {cov.MissingRequiredColumns.Count - 20} more");
            }
            sb.AppendLine();
            sb.AppendLine("The report migration cannot succeed until these are mapped to a source. Add the missing source element(s) to this map (ETL Mapping → this map → add a Source and map its elements), then start the session again. I'll still attempt the load for the tables that ARE mapped, but expect the final report step to fall short.");

            AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop, sb.ToString().TrimEnd());
            _appRepository.Save();
        }

        private void PostPhase1ContextOnce(EtlChatSession session)
        {
            bool already = GetMessages(session.EtlChatSessionId)
                .Any(m => (m.Content ?? "").Contains("🔎 Context gathered from the ETL map"));
            if (already) return;

            var sb = new StringBuilder();
            var sources = _mappingService.GetMapSources(session.EtlMapId) ?? new List<EtlMapSource>();
            if (sources.Count > 0)
            {
                foreach (var s in sources)
                {
                    string sample = ReadSourceSample(s.SourceObject, 5);
                    if (!string.IsNullOrWhiteSpace(sample))
                    {
                        string name = string.IsNullOrWhiteSpace(s.SourceName) ? s.SourceObject : s.SourceName;
                        sb.AppendLine($"Source sample — TOP 5 rows of {name} ({s.SourceObject}):");
                        sb.AppendLine(sample);
                        sb.AppendLine();
                    }
                }
            }
            else
            {
                // Derive the source object(s) from the ETL Mapping when none is set on the session.
                foreach (var src in ResolveSourceObjects(session))
                {
                    string sample = ReadSourceSample(src, 5);
                    if (!string.IsNullOrWhiteSpace(sample))
                    {
                        sb.AppendLine($"Source sample — TOP 5 rows of {src}:");
                        sb.AppendLine(sample);
                        sb.AppendLine();
                    }
                }
            }
            string cedsVals = BuildCedsOptionValuesContext(_mappingService.GetAllMappings(session.EtlMapId));
            if (!string.IsNullOrWhiteSpace(cedsVals))
            {
                if (sb.Length > 0) sb.AppendLine();
                sb.AppendLine("CEDS permitted option-set values for the mapped elements:");
                sb.AppendLine(cedsVals);
            }
            if (sb.Length == 0) return;
            AddMessage(session.EtlChatSessionId, EtlChatRole.Tool, EtlChatMessageType.Status, session.CurrentLoop,
                "🔎 Context gathered from the ETL map & source (grounds the load):\n" + sb.ToString().TrimEnd());
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
                return DescribeSqlError(ex, sql);
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
                // Local wall-clock time of the comment — stored as-is and shown verbatim in the UI.
                CreatedDate = DateTime.Now
            });
            _appRepository.Save();
            return message;
        }
    }
}
