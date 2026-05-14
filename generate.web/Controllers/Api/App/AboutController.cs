using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;

namespace generate.web.Controllers.Api.App
{

    [Route("api/app/about")]
    [ResponseCache(Duration = 0)]
    [ApiController]
    public class AboutController : Controller
    {

        private readonly IAboutService _AboutService;

        public AboutController
        (
            IAboutService aboutService
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
