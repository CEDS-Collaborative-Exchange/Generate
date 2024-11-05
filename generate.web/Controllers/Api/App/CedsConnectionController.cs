using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/cedsconnections")]
    [ApiController]
    public class CedsConnectionController: Controller
    {
        private IAppRepository _appRepository;

        public CedsConnectionController(IAppRepository appRepository)
        {
            _appRepository = appRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _appRepository.GetAll<CedsConnection>();
            return Json(results);
        }
    }
}
