using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/togglequestionoptions")]
    public class ToggleQuestionOptionController : Controller
    {
        private IAppRepository _toggleQuestionOptionRepository;

        public ToggleQuestionOptionController(IAppRepository toggleQuestionOptionRepository)
        {
            _toggleQuestionOptionRepository = toggleQuestionOptionRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleQuestionOption> results = _toggleQuestionOptionRepository.GetAll<ToggleQuestionOption>(0, 0);

            List<ToggleQuestionOption> resultList = results.OrderBy(t => t.ToggleQuestionId).ThenBy(t => t.OptionSequence).ThenBy(t => t.OptionText).ToList();

            return Json(resultList);
        }
    }
}
