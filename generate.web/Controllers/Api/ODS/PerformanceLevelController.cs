using generate.infrastructure.Contexts;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.ODS;
using generate.core.Interfaces.Repositories.IDS;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/performancelevels")]
    [ApiController]
    public class PerformanceLevelController : Controller
    {

        private IIDSRepository _idsRepository;

        public PerformanceLevelController(IIDSRepository idsRepository)
        {
            _idsRepository = idsRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var performanceLevels = _idsRepository
                .GetAll<AssessmentPerformanceLevel>(0, 0)
                .GroupBy(g => new { g.Identifier, g.Label, g.LowerCutScore, g.UpperCutScore, g.DescriptiveFeedback, g.ScoreMetric })
                .Distinct()
                .Select(s => new { s.Key.Identifier, s.Key.Label, s.Key.LowerCutScore, s.Key.UpperCutScore, s.Key.ScoreMetric, s.Key.DescriptiveFeedback })
                .OrderBy(t => t.Identifier);

            return Json(performanceLevels);
        }


    }
}
