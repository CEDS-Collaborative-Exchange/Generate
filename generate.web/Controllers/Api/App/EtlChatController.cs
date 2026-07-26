using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{
    /// <summary>
    /// AI ETL developer chatbot API (CIID-9061, epic CIID-9029). Per-map sessions that iteratively
    /// build/execute/test SQL ETL from a source into the map's mapped Staging tables via Ollama.
    /// </summary>
    [Route("api/app/etlchat")]
    [ApiController]
    public class EtlChatController : Controller
    {
        private readonly IEtlChatService _etlChatService;

        public EtlChatController(IEtlChatService etlChatService)
        {
            _etlChatService = etlChatService;
        }

        [HttpGet("maps/{mapId}/sessions")]
        public JsonResult GetSessions(int mapId)
        {
            return Json(_etlChatService.GetSessions(mapId));
        }

        [HttpPost("sessions")]
        public IActionResult CreateSession([FromBody] EtlChatSessionCreateDto create)
        {
            if (create == null || create.EtlMapId <= 0)
            {
                return BadRequest("A map is required.");
            }
            if (string.IsNullOrWhiteSpace(create.CreatedBy))
            {
                create.CreatedBy = User?.Identity?.Name;
            }
            return Json(_etlChatService.CreateSession(create));
        }

        [HttpGet("sessions/{id}")]
        public IActionResult GetSession(int id)
        {
            var session = _etlChatService.GetSession(id);
            return session == null ? (IActionResult)NotFound() : Json(session);
        }

        [HttpGet("sessions/{id}/messages")]
        public JsonResult GetMessages(int id)
        {
            return Json(_etlChatService.GetMessages(id));
        }

        [HttpPost("sessions/{id}/messages")]
        public IActionResult PostUserMessage(int id, [FromBody] EtlChatUserMessageDto message)
        {
            if (message == null || string.IsNullOrWhiteSpace(message.Content))
            {
                return BadRequest("Message content is required.");
            }
            if (string.IsNullOrWhiteSpace(message.CreatedBy))
            {
                message.CreatedBy = User?.Identity?.Name;
            }
            var session = _etlChatService.PostUserMessage(id, message);
            return session == null ? (IActionResult)NotFound() : Json(session);
        }

        [HttpPost("sessions/{id}/iterate")]
        public async Task<IActionResult> RunIteration(int id)
        {
            var result = await _etlChatService.RunIterationAsync(id);
            return Json(result);
        }

        [HttpDelete("sessions/{id}")]
        public IActionResult DeleteSession(int id)
        {
            return _etlChatService.DeleteSession(id) ? (IActionResult)Ok() : NotFound();
        }
    }
}
