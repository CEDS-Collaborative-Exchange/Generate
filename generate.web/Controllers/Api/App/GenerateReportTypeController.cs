using generate.infrastructure.Contexts;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/generatereporttypes")]
    public class GenerateReportTypeController: Controller
    {
        private readonly IAppRepository _appRepository;

        public GenerateReportTypeController(IAppRepository appRepository)
        {
            _appRepository = appRepository;
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            var results = _appRepository.GetAll<GenerateReportType>(0, 0);
            return Json(results);
        }
    }
}
