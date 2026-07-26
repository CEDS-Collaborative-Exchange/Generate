using generate.infrastructure.Services;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>Safety guardrails for LLM-generated ETL/test SQL (CIID-9061).</summary>
    public class EtlSqlGuardShould
    {
        [Fact]
        public void AllowStagingTargetedEtl()
        {
            string sql = "DELETE FROM Staging.Assessment; INSERT INTO Staging.Assessment (Sex) SELECT Gender FROM src.Students;";
            Assert.Null(EtlSqlGuard.ValidateEtl(sql));
        }

        [Theory]
        [InlineData("DROP TABLE Staging.Assessment")]
        [InlineData("TRUNCATE TABLE Staging.Assessment")]
        [InlineData("ALTER DATABASE Generate SET SINGLE_USER")]
        [InlineData("EXEC('DELETE FROM x')")]
        [InlineData("EXEC xp_cmdshell 'dir'")]
        [InlineData("BACKUP DATABASE Generate TO DISK='x'")]
        public void RejectDestructiveEtl(string sql)
        {
            Assert.NotNull(EtlSqlGuard.ValidateEtl(sql));
        }

        [Fact]
        public void RejectEtlThatDoesNotTargetStaging()
        {
            string sql = "INSERT INTO dbo.SomethingElse (a) SELECT b FROM src.t;";
            Assert.NotNull(EtlSqlGuard.ValidateEtl(sql));
        }

        [Fact]
        public void RejectEmptyEtl()
        {
            Assert.NotNull(EtlSqlGuard.ValidateEtl("   "));
        }

        [Fact]
        public void AllowReadOnlyTest()
        {
            Assert.Null(EtlSqlGuard.ValidateTest("SELECT (SELECT COUNT(*) FROM src.t) AS SourceCount, (SELECT COUNT(*) FROM Staging.Assessment) AS StagingCount"));
            Assert.Null(EtlSqlGuard.ValidateTest("WITH c AS (SELECT 1 x) SELECT 1 AS SourceCount, 1 AS StagingCount"));
        }

        [Theory]
        [InlineData("DELETE FROM Staging.Assessment")]
        [InlineData("UPDATE Staging.Assessment SET Sex = 'M'")]
        [InlineData("INSERT INTO Staging.Assessment (Sex) VALUES ('M')")]
        [InlineData("MERGE Staging.Assessment USING src.t ON 1=1")]
        public void RejectNonReadOnlyTest(string sql)
        {
            Assert.NotNull(EtlSqlGuard.ValidateTest(sql));
        }
    }
}
