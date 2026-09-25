using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Interfaces.Helpers;
using Microsoft.AspNetCore.Authorization;

namespace generate.background.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class BackgroundUpdateController : ControllerBase
    {
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<BackgroundUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;
        private readonly IHangfireHelper _hangfireHelper;


        public BackgroundUpdateController(
            ILogger<BackgroundUpdateController> logger,
            IHostEnvironment hostingEnvironment,
            IAppUpdateService appUpdateService,
            IHangfireHelper hangfireHelper
            )
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _hostingEnvironment = hostingEnvironment ?? throw new ArgumentNullException(nameof(hostingEnvironment));
            _appUpdateService = appUpdateService ?? throw new ArgumentNullException(nameof(appUpdateService));
            _hangfireHelper = hangfireHelper ?? throw new ArgumentNullException(nameof(hangfireHelper));
        }


        [HttpGet("")]
        public ActionResult<IEnumerable<UpdatePackageDto>> DownloadedUpdates()
        {

            _logger.LogInformation("DownloadedUpdates - Initiated - " + _hostingEnvironment.ContentRootPath);

            return _appUpdateService.GetDownloadedUpdates(_hostingEnvironment.ContentRootPath);
        }

        [HttpPost("download")]
        public IActionResult DownloadUpdates()
        {
            _appUpdateService.DownloadUpdates(_hostingEnvironment.ContentRootPath);
            return Ok();
        }


        [HttpPost("clear")]
        public IActionResult ClearUpdates()
        {
            _appUpdateService.ClearUpdates(_hostingEnvironment.ContentRootPath);
            return Ok();
        }

        [HttpPut("execute")]
        public IActionResult ExecuteUpdate()
        {

            try
            {
                // Apply this app's own ("background") part of the pending update to itself.
                // Never touches generate.web's package or App Service resource.
                _hangfireHelper.TriggerSiteUpdate(_hostingEnvironment.ContentRootPath, "background");

                return Ok();

            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }


        }


    }
}
