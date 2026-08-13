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
        private readonly IEtlChatRunner _etlChatRunner;

        public EtlChatController(IEtlChatService etlChatService, IEtlChatRunner etlChatRunner)
        {
            _etlChatService = etlChatService;
            _etlChatRunner = etlChatRunner;
        }

        [HttpGet("maps/{mapId}/sessions")]
        public JsonResult GetSessions(int mapId)
        {
            return Json(_etlChatService.GetSessions(mapId));
        }

        /// <summary>Readiness check for a map: does its mapping cover the Staging tables/columns the target
        /// file spec's end-to-end migration needs? Lets the UI warn before a session is started to no avail.</summary>
        [HttpGet("maps/{mapId}/coverage")]
        public JsonResult GetCoverage(int mapId)
        {
            return Json(_etlChatService.ComputeCoverage(mapId));
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

        /// <summary>Session state plus whether a background run is currently active — used by the UI to
        /// reconnect and show the working indicator after the user returns to the page.</summary>
        [HttpGet("sessions/{id}/status")]
        public IActionResult GetStatus(int id)
        {
            var session = _etlChatService.GetSession(id);
            if (session == null)
            {
                return NotFound();
            }
            return Json(new { session, isRunning = _etlChatRunner.IsRunning(id) });
        }

        /// <summary>Starts (or resumes) the background phase loop for a session. Returns immediately;
        /// the loop keeps running server-side even if the user leaves the page.</summary>
        [HttpPost("sessions/{id}/run")]
        public IActionResult Run(int id)
        {
            var session = _etlChatService.GetSession(id);
            if (session == null)
            {
                return NotFound();
            }
            _etlChatRunner.Start(id);
            return Json(new { started = true, isRunning = _etlChatRunner.IsRunning(id) });
        }

        /// <summary>Requests the background run to stop after the current step finishes.</summary>
        [HttpPost("sessions/{id}/stop")]
        public IActionResult Stop(int id)
        {
            _etlChatRunner.Stop(id);
            return Json(new { stopped = true, isRunning = _etlChatRunner.IsRunning(id) });
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

        [HttpPost("sessions/{id}/publish")]
        public IActionResult Publish(int id)
        {
            var session = _etlChatService.PublishProcedure(id);
            return session == null ? (IActionResult)NotFound() : Json(session);
        }

        [HttpDelete("sessions/{id}")]
        public IActionResult DeleteSession(int id)
        {
            return _etlChatService.DeleteSession(id) ? (IActionResult)Ok() : NotFound();
        }
    }
}
