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
            // Guard against accidental mass deletes/updates: any DELETE/UPDATE must be scoped by WHERE.
            if ((Regex.IsMatch(lower, @"\bdelete\b") || Regex.IsMatch(lower, @"\bupdate\b")) &&
                !Regex.IsMatch(lower, @"\bwhere\b"))
            {
                return "contains an unscoped DELETE/UPDATE (a WHERE clause is required).";
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
    }
}
