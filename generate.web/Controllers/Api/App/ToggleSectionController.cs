using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/togglesections")]
    public class ToggleSectionController : Controller
    {
        private IAppRepository _toggleSectionRepository;

        public ToggleSectionController(IAppRepository toggleSectionRepository)
        {
            _toggleSectionRepository = toggleSectionRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<ToggleSection> results = _toggleSectionRepository.GetAll<ToggleSection>(0, 0, s => s.ToggleSectionType);

            List<ToggleSection> resultList = results.OrderBy(t => t.SectionSequence).ToList();

            return Json(resultList);
        }
    }
}
