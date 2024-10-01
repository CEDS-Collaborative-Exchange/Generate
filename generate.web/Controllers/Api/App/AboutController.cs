using generate.core.Config;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.infrastructure.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;

namespace generate.web.Controllers.Api.App
{

    [Route("api/app/about")]
    [ResponseCache(Duration = 0)]
    public class AboutController : Controller
    {

        private readonly IOptions<AppSettings> _appSettings;
        private readonly IAppRepository _appRepository;
        private readonly IAboutService _AboutService;
        private readonly IRDSRepository _rdsRepository;

        public AboutController
        (
            IOptions<AppSettings> appSettings,
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            IAboutService aboutService,
            IConfiguration configuration
        )
        {
            _appSettings = appSettings;
            _appRepository = appRepository;
            _AboutService = aboutService;
            _rdsRepository = rdsRepository;
        }

        //[HttpGet("getvers")]
        public string getVersion() 
        { 
         return _AboutService.GetDBVersion();
        }

        [HttpGet("getvers")]
        public IActionResult getversion()        
        {
            var message = this._AboutService.GetDBVersion();
            if (message != null && message.Contains("failed"))
            {
                return StatusCode(500, message);
            }
            else
            {
                //return StatusCode(200, "FS Population successful.");
                //return Ok(new { successMessage = "FS Metadata Population successful." });
                return Ok(new { successMessage = message });
            }
        }
    }
}
