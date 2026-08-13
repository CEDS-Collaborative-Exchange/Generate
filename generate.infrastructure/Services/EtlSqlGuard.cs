using System.Linq;
using System.Text.RegularExpressions;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// Safety guardrails for LLM-generated SQL (CIID-9061). ETL statements must target the Staging
    /// schema and avoid destructive/administrative commands; tests must be read-only single SELECTs.
    /// Returns an error message, or null when the SQL is allowed.
    /// </summary>
    public static class EtlSqlGuard
    {
        private static readonly string[] DestructivePatterns =
        {
            @"\bdrop\s+database\b", @"\bdrop\s+table\b", @"\bdrop\s+schema\b", @"\btruncate\b",
            @"\balter\s+(database|login|server)\b", @"\bxp_cmdshell\b", @"\bsp_configure\b",
            @"\bgrant\b", @"\brevoke\b", @"\bshutdown\b", @"\bbackup\b", @"\brestore\b",
            @"\bexec\s*\(", @"\bexecute\s*\(", @"\bopenrowset\b", @"\bopendatasource\b"
        };

        public static string ValidateEtl(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql))
            {
                return "empty SQL";
            }
            string lower = sql.ToLowerInvariant();
            foreach (var pattern in DestructivePatterns)
            {
                if (Regex.IsMatch(lower, pattern))
                {
                    return $"contains a disallowed statement ({pattern}).";
                }
            }
            if (!Regex.IsMatch(lower, @"\bstaging\s*\."))
            {
                return "does not target the Staging schema.";
            }
            // DELETEs may be unconstrained (no WHERE required), but EVERY schema-qualified write target
            // — DELETE/UPDATE/INSERT/MERGE — must be in the Staging schema. Temp tables (#..) and
            // unqualified targets are allowed.
            foreach (Match m in Regex.Matches(lower,
                @"\b(?:delete\s+(?:from\s+)?|update\s+|insert\s+into\s+|merge\s+(?:into\s+)?)\[?([a-z0-9_]+)\]?\s*\."))
            {
                string schema = m.Groups[1].Value;
                if (schema != "staging")
                {
                    return $"writes must target the Staging schema (found a write to '{schema}').";
                }
            }
            return null;
        }

        public static string ValidateTest(string sql)
        {
            string lower = (sql ?? "").TrimStart().ToLowerInvariant();
            if (!(lower.StartsWith("select") || lower.StartsWith("with")))
            {
                return "test must be a single SELECT.";
            }
            foreach (var kw in new[] { "insert", "update", "delete", "merge", "drop", "alter", "truncate", "exec" })
            {
                if (Regex.IsMatch(lower, $@"\b{kw}\b"))
                {
                    return $"test must be read-only (found '{kw}').";
                }
            }
            return null;
        }

        /// <summary>
        /// Validates a read-only inspection query (e.g. against INFORMATION_SCHEMA or sys catalog views):
        /// must be a single SELECT/WITH with no writes, DDL, or EXEC. Returns an error, or null when allowed.
        /// </summary>
        public static string ValidateReadOnly(string sql)
        {
            string lower = (sql ?? "").ToLowerInvariant();
            if (string.IsNullOrWhiteSpace(lower))
            {
                return "empty query";
            }
            // Read-only inspection may open with DECLARE/SET/comments before the SELECT — only the absence
            // of writes/DDL/EXEC matters. It must, however, contain a SELECT.
            if (!Regex.IsMatch(lower, @"\bselect\b"))
            {
                return "lookup must contain a read-only SELECT.";
            }
            foreach (var kw in new[] { "insert", "update", "delete", "merge", "drop", "alter", "truncate", "create", "exec", "grant", "revoke", "backup", "restore" })
            {
                if (Regex.IsMatch(lower, $@"\b{kw}\b"))
                {
                    return $"lookup must be read-only (found '{kw}').";
                }
            }
            return null;
        }
    }
}
