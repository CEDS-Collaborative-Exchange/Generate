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
    [ApiController]
    public class AboutController : Controller
    {

        private readonly IAppRepository _appRepository;
        private readonly IAboutService _AboutService;
        private readonly IRDSRepository _rdsRepository;

        public AboutController
        (
            IAboutService aboutService,
            IConfiguration configuration
        )
        {
            _AboutService = aboutService;
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
