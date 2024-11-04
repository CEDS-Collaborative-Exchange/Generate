using generate.infrastructure.Contexts;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using generate.core.Dtos.ODS;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Repositories.RDS;
using generate.infrastructure.Repositories.IDS;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/gradelevels")]
    [ApiController]
    public class GradeLevelController : Controller
    {
        private IIDSRepository _idsRepository;
        private IDimensionRepository _dimensionRepository;

        public GradeLevelController(IIDSRepository idsRepository, IDimensionRepository dimensionRepository)
        {
            _idsRepository = idsRepository;
            _dimensionRepository = dimensionRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _idsRepository.GetAll<RefGradeLevel>();
            return Json(results);
        }

        [HttpGet("{gradeLevelTypeCode}")]
        public JsonResult Get(string gradeLevelTypeCode)
        {

            return Json(_dimensionRepository.GetGradeLevels(gradeLevelTypeCode));
                      
        }

   }
}
