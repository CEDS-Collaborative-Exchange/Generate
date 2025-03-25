using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/togglequestiontypes")]
    [ApiController]
    public class ToggleQuestionTypeController : Controller
    {
        private IAppRepository _toggleQuestionTypeRepository;

        public ToggleQuestionTypeController(IAppRepository toggleQuestionTypeRepository)
        {
            _toggleQuestionTypeRepository = toggleQuestionTypeRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleQuestionType> results = _toggleQuestionTypeRepository.GetAll<ToggleQuestionType>(0, 0);

            return Json(results);
        }
    }
}
