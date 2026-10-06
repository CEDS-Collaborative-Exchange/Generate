using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using generate.core.Config;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Interfaces.Helpers;
namespace generate.background.Controllers
{
    // Authorization (when enforced) is applied globally in Program.cs, conditional on
    // AppSettings:EnableAzureDeployment - see the comment there for why.
    [Route("api/[controller]")]
    [ApiController]
    public class BackgroundUpdateController : ControllerBase
    {
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<BackgroundUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;
        private readonly IHangfireHelper _hangfireHelper;
        private readonly IOptions<AppSettings> _appSettings;


        public BackgroundUpdateController(
            ILogger<BackgroundUpdateController> logger,
            IHostEnvironment hostingEnvironment,
            IAppUpdateService appUpdateService,
            IHangfireHelper hangfireHelper,
            IOptions<AppSettings> appSettings
            )
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _hostingEnvironment = hostingEnvironment ?? throw new ArgumentNullException(nameof(hostingEnvironment));
            _appUpdateService = appUpdateService ?? throw new ArgumentNullException(nameof(appUpdateService));
            _hangfireHelper = hangfireHelper ?? throw new ArgumentNullException(nameof(hangfireHelper));
            _appSettings = appSettings ?? throw new ArgumentNullException(nameof(appSettings));
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
                // Azure path: deploys this app's own ("background") part to itself via Azure Blob
                // Storage + ARM, using its own Managed Identity - never touches generate.web's
                // package or App Service resource directly.
                // Legacy path: a running process can never overwrite its own currently-loaded
                // binaries, so the in-place file copy targets generate.web's content root instead
                // (ignored entirely by the Azure path).
                var webAppPath = _hostingEnvironment.IsDevelopment()
                    ? _hostingEnvironment.ContentRootPath.Replace("generate.background", "generate.web")
                    : _appSettings.Value.WebAppPath;

                _hangfireHelper.TriggerSiteUpdate(_hostingEnvironment.ContentRootPath, "background", webAppPath);

                return Ok();

            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }


        }


    }
}
