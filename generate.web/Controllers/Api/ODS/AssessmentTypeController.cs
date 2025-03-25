using generate.infrastructure.Contexts;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.ODS;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Repositories.RDS;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/assessmenttypes")]
    [ApiController]
    public class AssessmentTypeController : Controller
    {
        private IDimensionRepository _dimensionRepository;

        public AssessmentTypeController(IDimensionRepository dimensionRepository)
        {
            _dimensionRepository = dimensionRepository;
        }

        [HttpGet("{subject}/{grade}")]
        public JsonResult Get(string subject, string grade)
        {
            var assessmentTypes = _dimensionRepository.GetAssessmentTypeChildrenWithDisabilities(subject, grade);
            return Json(assessmentTypes);
        }
    }
}
