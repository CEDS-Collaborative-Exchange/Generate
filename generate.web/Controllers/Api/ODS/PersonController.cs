using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Models;
using generate.core.Models.IDS;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.ODS
{
    [Route("api/ods/persons")]
    public class PersonController: Controller
    {
        private IIDSRepository _idsRepository;

        public PersonController(IIDSRepository idsRepository)
        {
            _idsRepository = idsRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _idsRepository.GetAll<Person>();
            return Json(results);
        }
    }
}
