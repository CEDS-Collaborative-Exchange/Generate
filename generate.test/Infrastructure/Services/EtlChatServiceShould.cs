using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.infrastructure.Services;
using Microsoft.Extensions.Configuration;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    /// <summary>
    /// ETL chat loop control (CIID-9061), with a mocked Ollama client and in-memory repository. SQL
    /// execution is disabled here so the loop logic is tested without a database.
    /// </summary>
    public class EtlChatServiceShould
    {
        private readonly Mock<IAppRepository> _repo = new Mock<IAppRepository>();
        private readonly Mock<IOllamaClient> _ollama = new Mock<IOllamaClient>();
        private readonly Mock<IEtlSourceMappingService> _mapping = new Mock<IEtlSourceMappingService>();
        private readonly List<EtlChatSession> _sessions = new List<EtlChatSession>();
        private readonly List<EtlChatMessage> _messages = new List<EtlChatMessage>();

        public EtlChatServiceShould()
        {
            _ollama.Setup(o => o.IsConfigured).Returns(true);
            _ollama.Setup(o => o.Model).Returns("test-model");
            _mapping.Setup(m => m.GetAllMappings(It.IsAny<int?>())).Returns(new List<EtlSourceElementMapping>
            {
                new EtlSourceElementMapping { SourceElementName = "Gender", CedsElementName = "Sex", CedsElementGlobalId = "000255", StagingTableColumns = "K12Enrollment.Sex" }
            });

            _repo.Setup(r => r.Find(It.IsAny<Expression<Func<EtlChatSession, bool>>>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<Expression<Func<EtlChatSession, object>>[]>()))
                .Returns((Expression<Func<EtlChatSession, bool>> c, int s, int t, Expression<Func<EtlChatSession, object>>[] e) => _sessions.Where(c.Compile()));
            _repo.Setup(r => r.FindReadOnly(It.IsAny<Expression<Func<EtlChatMessage, bool>>>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<Expression<Func<EtlChatMessage, object>>[]>()))
                .Returns((Expression<Func<EtlChatMessage, bool>> c, int s, int t, Expression<Func<EtlChatMessage, object>>[] e) => _messages.Where(c.Compile()));
            _repo.Setup(r => r.Create(It.IsAny<EtlChatMessage>()))
                .Returns((EtlChatMessage m) => { m.EtlChatMessageId = _messages.Count + 1; _messages.Add(m); return m; });
            _repo.Setup(r => r.Create(It.IsAny<EtlChatSession>()))
                .Returns((EtlChatSession m) => { m.EtlChatSessionId = _sessions.Count + 1; _sessions.Add(m); return m; });
        }

        private EtlChatService Build(string allowExec = "false")
        {
            var config = new Mock<IConfiguration>();
            config.Setup(c => c["EtlChat:AllowSqlExecution"]).Returns(allowExec);
            config.Setup(c => c["EtlChat:DefaultMaxLoops"]).Returns("10");
            config.Setup(c => c["Data:AppDbContextConnection"]).Returns("Server=.;Database=x;Trusted_Connection=True;");
            return new EtlChatService(_repo.Object, _mapping.Object, _ollama.Object, config.Object);
        }

        private EtlChatSession Session(int maxLoops = 5, int currentLoop = 0)
        {
            var s = new EtlChatSession { EtlChatSessionId = 1, EtlMapId = 1, MaxLoops = maxLoops, CurrentLoop = currentLoop, Status = EtlChatSessionStatus.Active };
            _sessions.Add(s);
            return s;
        }

        [Fact]
        public async Task PauseForInputWhenModelAsksQuestions()
        {
            Session();
            _ollama.Setup(o => o.ChatAsync(It.IsAny<IEnumerable<OllamaMessage>>()))
                .ReturnsAsync("{\"questions\":[\"What is the source primary key?\"],\"etlSql\":\"\",\"testSql\":\"\",\"explanation\":\"\"}");

            var result = await Build().RunIterationAsync(1);

            Assert.Equal(EtlChatIterationOutcome.AwaitingInput, result.Outcome);
            Assert.Equal(EtlChatSessionStatus.AwaitingInput, result.Status);
            Assert.False(result.CanContinue);
            Assert.Contains(_messages, m => m.MessageType == EtlChatMessageType.Question);
        }

        [Fact]
        public async Task ReturnSqlAndAwaitWhenExecutionDisabled()
        {
            Session();
            _ollama.Setup(o => o.ChatAsync(It.IsAny<IEnumerable<OllamaMessage>>()))
                .ReturnsAsync("{\"etlSql\":\"INSERT INTO Staging.K12Enrollment (Sex) SELECT Gender FROM src.t\",\"testSql\":\"SELECT 1 AS SourceCount, 1 AS StagingCount\",\"explanation\":\"loads sex\"}");

            var result = await Build(allowExec: "false").RunIterationAsync(1);

            Assert.Equal(EtlChatIterationOutcome.AwaitingInput, result.Outcome);
            Assert.Equal(1, _sessions[0].CurrentLoop); // producing SQL counts as a loop
            Assert.Equal("INSERT INTO Staging.K12Enrollment (Sex) SELECT Gender FROM src.t", _sessions[0].LastEtlSql);
            Assert.Contains(_messages, m => m.MessageType == EtlChatMessageType.Sql);
        }

        [Fact]
        public async Task StopAtMaxLoops()
        {
            Session(maxLoops: 3, currentLoop: 3);
            var result = await Build().RunIterationAsync(1);

            Assert.Equal(EtlChatIterationOutcome.MaxLoopsReached, result.Outcome);
            Assert.Equal(EtlChatSessionStatus.Failed, result.Status);
            Assert.False(result.CanContinue);
            _ollama.Verify(o => o.ChatAsync(It.IsAny<IEnumerable<OllamaMessage>>()), Times.Never);
        }

        [Fact]
        public async Task ErrorWhenOllamaNotConfigured()
        {
            Session();
            _ollama.Setup(o => o.IsConfigured).Returns(false);
            var result = await Build().RunIterationAsync(1);
            Assert.Equal(EtlChatIterationOutcome.Error, result.Outcome);
        }

        [Fact]
        public void CreateSessionUsesDefaultMaxLoopsAndPersists()
        {
            var service = Build();
            var session = service.CreateSession(new EtlChatSessionCreateDto { EtlMapId = 1, SessionName = "NJ load", SourceObject = "dbo.ALLTESTS" });

            Assert.Equal("NJ load", session.SessionName);
            Assert.Equal(10, session.MaxLoops);
            Assert.Equal(EtlChatSessionStatus.Active, session.Status);
            Assert.Contains(_messages, m => m.Role == EtlChatRole.Assistant); // greeting persisted
        }
    }
}
