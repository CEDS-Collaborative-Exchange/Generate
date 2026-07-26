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

            // Build the conversation and call the model
            var messages = BuildPrompt(session);
            string reply;
            try
            {
                reply = await _ollama.ChatAsync(messages);
            }
            catch (Exception ex)
            {
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Error, session.CurrentLoop, "LLM error: " + ex.Message);
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.Error;
                result.Summary = ex.Message;
                result.CanContinue = false;
                result.Status = session.Status;
                return result;
            }

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
                session.Status = EtlChatSessionStatus.Completed;
                session.ModifiedDate = DateTime.UtcNow;
                AddMessage(session.EtlChatSessionId, EtlChatRole.Assistant, EtlChatMessageType.Status, session.CurrentLoop,
                    $"✅ Counts match ({counts}). ETL complete in {session.CurrentLoop} loop(s).");
                _appRepository.Save();
                result.Outcome = EtlChatIterationOutcome.Passed;
                result.Status = session.Status;
                result.CanContinue = false;
                result.Summary = "Counts match — done.";
                return result;
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

        private void AddMessage(int sessionId, string role, string type, int? iteration, string content)
        {
            _appRepository.Create(new EtlChatMessage
            {
                EtlChatSessionId = sessionId,
                Role = role,
                MessageType = type,
                IterationNumber = iteration,
                Content = content,
                CreatedDate = DateTime.UtcNow
            });
        }
    }
}
