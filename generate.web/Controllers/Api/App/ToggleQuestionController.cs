using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/togglequestions")]
    [ApiController]
    public class ToggleQuestionController: Controller
    {
        private IAppRepository _toggleQuestionRepository;

        public ToggleQuestionController(IAppRepository toggleQuestionRepository)
        {
            _toggleQuestionRepository = toggleQuestionRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleQuestion> results = _toggleQuestionRepository.GetAll<ToggleQuestion>(0, 0, t => t.ToggleSection, t => t.ToggleQuestionType);

            List<ToggleQuestion> resultList = results.OrderBy(t => t.ToggleSection.SectionSequence).ThenBy(t => t.QuestionSequence).ToList();

            return Json(resultList);
        }
    }
}
