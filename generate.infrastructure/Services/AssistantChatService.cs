using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// General-purpose AI assistant chat (CIID-9061). Free-form conversations with the local Ollama model,
    /// not tied to an ETL map. Streams the reply into a message row so the UI can poll and watch it type.
    /// </summary>
    public class AssistantChatService : IAssistantChatService
    {
        private const string RoleUser = "user";
        private const string RoleAssistant = "assistant";

        private readonly IAppRepository _appRepository;
        private readonly IOllamaClient _ollama;

        public AssistantChatService(IAppRepository appRepository, IOllamaClient ollama)
        {
            _appRepository = appRepository;
            _ollama = ollama;
        }

        public List<AssistantSession> GetSessions()
        {
            return _appRepository
                .FindReadOnly<AssistantSession>(s => s.AssistantSessionId > 0, 0, 0)
                .OrderByDescending(s => s.ModifiedDate ?? s.CreatedDate)
                .ToList();
        }

        public AssistantSession GetSession(int assistantSessionId)
        {
            return _appRepository
                .Find<AssistantSession>(s => s.AssistantSessionId == assistantSessionId, 0, 0)
                .FirstOrDefault();
        }

        public List<AssistantMessage> GetMessages(int assistantSessionId)
        {
            return _appRepository
                .FindReadOnly<AssistantMessage>(m => m.AssistantSessionId == assistantSessionId, 0, 0)
                .OrderBy(m => m.AssistantMessageId)
                .ToList();
        }

        public AssistantSession CreateSession(AssistantSessionCreateDto create)
        {
            var session = new AssistantSession
            {
                Title = string.IsNullOrWhiteSpace(create?.Title) ? "New chat" : create.Title.Trim(),
                Status = "Active",
                CreatedDate = DateTime.UtcNow,
                CreatedBy = create?.CreatedBy
            };
            _appRepository.Create(session);
            _appRepository.Save();

            AddMessage(session.AssistantSessionId, RoleAssistant,
                "Hi — I'm the Generate SQL assistant. Ask me anything, or have me write or update T-SQL " +
                "(for example, roll a stored procedure to a new school year). What can I help with?");
            _appRepository.Save();
            return session;
        }

        public bool DeleteSession(int assistantSessionId)
        {
            var session = _appRepository
                .Find<AssistantSession>(s => s.AssistantSessionId == assistantSessionId, 0, 0)
                .FirstOrDefault();
            if (session == null) return false;
            _appRepository.DeleteRange(new[] { session });
            _appRepository.Save();
            return true;
        }

        public AssistantSession PostUserMessage(int assistantSessionId, AssistantUserMessageDto message)
        {
            var session = GetSession(assistantSessionId);
            if (session == null || string.IsNullOrWhiteSpace(message?.Content)) return session;

            AddMessage(assistantSessionId, RoleUser, message.Content.Trim());

            // First user message names the session (until then it's "New chat").
            if (string.Equals(session.Title, "New chat", StringComparison.OrdinalIgnoreCase))
            {
                string t = message.Content.Trim();
                session.Title = t.Length > 60 ? t.Substring(0, 60) + "…" : t;
            }
            session.Status = "Active";
            session.ModifiedDate = DateTime.UtcNow;
            session.ModifiedBy = message.CreatedBy;
            _appRepository.Save();
            return session;
        }

        public async Task<AssistantMessage> RunAsync(int assistantSessionId)
        {
            var session = GetSession(assistantSessionId);
            if (session == null) return null;

            if (!_ollama.IsConfigured)
            {
                var err = AddMessage(assistantSessionId, RoleAssistant, "The local model (Ollama) is not configured.");
                _appRepository.Save();
                return err;
            }

            // Live message the reply streams into, saved incrementally so the UI can poll and show it type.
            var live = AddMessage(assistantSessionId, RoleAssistant, "…");
            _appRepository.Save();

            var prompt = BuildPrompt(assistantSessionId);
            try
            {
                string reply = await _ollama.ChatAsync(prompt, accumulated =>
                {
                    live.Content = accumulated;
                    live.CreatedDate = DateTime.Now;
                    _appRepository.Save();
                });
                live.Content = string.IsNullOrWhiteSpace(reply) ? "(no response)" : reply.Trim();
            }
            catch (Exception ex)
            {
                live.Content = "The model call failed: " + ex.Message;
            }

            session.Status = "AwaitingInput";
            session.ModifiedDate = DateTime.UtcNow;
            _appRepository.Save();
            return live;
        }

        // System prompt + replayed transcript. General-purpose but Generate/T-SQL aware.
        private List<OllamaMessage> BuildPrompt(int assistantSessionId)
        {
            var messages = new List<OllamaMessage>
            {
                new OllamaMessage { Role = "system", Content =
                    "You are a helpful senior Microsoft SQL Server (T-SQL) developer and EDFacts/CEDS expert " +
                    "working inside the Generate application — a SQL Server education-data warehouse that " +
                    "produces federal EDFacts submission files. Help the user write and update T-SQL (stored " +
                    "procedures, functions, migrations, queries) and answer questions about SQL, the warehouse, " +
                    "and EDFacts/CEDS. Use Microsoft T-SQL syntax only (SELECT TOP (n), ISNULL, GETDATE(), etc.). " +
                    "When updating an object for a new school year, preserve its existing logic and change only " +
                    "what the year change requires. Put SQL in ```sql code blocks. Be concise and correct; if " +
                    "you are unsure or need more detail (schema, current definition), say so and ask." }
            };

            var transcript = GetMessages(assistantSessionId);
            foreach (var m in transcript.Skip(Math.Max(0, transcript.Count - 30)))
            {
                string role = m.Role == RoleUser ? RoleUser : RoleAssistant;
                messages.Add(new OllamaMessage { Role = role, Content = m.Content ?? string.Empty });
            }
            return messages;
        }

        private AssistantMessage AddMessage(int sessionId, string role, string content)
        {
            var m = new AssistantMessage
            {
                AssistantSessionId = sessionId,
                Role = role,
                Content = content,
                CreatedDate = DateTime.Now
            };
            _appRepository.Create(m);
            return m;
        }
    }
}
