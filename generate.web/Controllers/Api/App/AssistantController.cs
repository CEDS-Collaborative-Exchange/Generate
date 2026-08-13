using System.Threading.Tasks;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{
    /// <summary>
    /// General-purpose AI assistant chat API (CIID-9061). Free-form sessions with the local Ollama model,
    /// not tied to an ETL map — for questions and writing/updating T-SQL.
    /// </summary>
    [Route("api/app/assistant")]
    [ApiController]
    public class AssistantController : Controller
    {
        private readonly IAssistantChatService _assistant;

        public AssistantController(IAssistantChatService assistant)
        {
            _assistant = assistant;
        }

        [HttpGet("sessions")]
        public JsonResult GetSessions()
        {
            return Json(_assistant.GetSessions());
        }

        [HttpPost("sessions")]
        public IActionResult CreateSession([FromBody] AssistantSessionCreateDto create)
        {
            create ??= new AssistantSessionCreateDto();
            if (string.IsNullOrWhiteSpace(create.CreatedBy)) { create.CreatedBy = User?.Identity?.Name; }
            return Json(_assistant.CreateSession(create));
        }

        [HttpGet("sessions/{id}")]
        public IActionResult GetSession(int id)
        {
            var s = _assistant.GetSession(id);
            return s == null ? (IActionResult)NotFound() : Json(s);
        }

        [HttpDelete("sessions/{id}")]
        public IActionResult DeleteSession(int id)
        {
            return _assistant.DeleteSession(id) ? (IActionResult)Ok() : NotFound();
        }

        [HttpGet("sessions/{id}/messages")]
        public JsonResult GetMessages(int id)
        {
            return Json(_assistant.GetMessages(id));
        }

        [HttpPost("sessions/{id}/messages")]
        public IActionResult PostUserMessage(int id, [FromBody] AssistantUserMessageDto message)
        {
            if (message == null || string.IsNullOrWhiteSpace(message.Content))
            {
                return BadRequest("Message content is required.");
            }
            if (string.IsNullOrWhiteSpace(message.CreatedBy)) { message.CreatedBy = User?.Identity?.Name; }
            var session = _assistant.PostUserMessage(id, message);
            return session == null ? (IActionResult)NotFound() : Json(session);
        }

        /// <summary>Generates the assistant's reply to the latest turn (streamed into a message row).</summary>
        [HttpPost("sessions/{id}/run")]
        public async Task<IActionResult> Run(int id)
        {
            var message = await _assistant.RunAsync(id);
            return message == null ? (IActionResult)NotFound() : Json(message);
        }
    }
}
