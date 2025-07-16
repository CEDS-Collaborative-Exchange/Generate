using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.Extensions.Hosting;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using generate.core.Interfaces.Helpers;

namespace generate.background.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BackgroundUpdateController : ControllerBase
    {
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<BackgroundUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;
        private readonly IHangfireHelper _hangfireHelper;


        public BackgroundUpdateController(
            ILogger<BackgroundUpdateController> logger,
            IHostEnvironment hostingEnvironment,
            IAppUpdateService appUpdateService,
            IOptions<AppSettings> appSettings,
            IHangfireHelper hangfireHelper
            )
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _hostingEnvironment = hostingEnvironment ?? throw new ArgumentNullException(nameof(hostingEnvironment));
            _appUpdateService = appUpdateService ?? throw new ArgumentNullException(nameof(appUpdateService));
            _appSettings = appSettings ?? throw new ArgumentNullException(nameof(appSettings));
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
                var webAppPath = _hostingEnvironment.ContentRootPath;

                if (_hostingEnvironment.IsDevelopment())
                {
                    webAppPath = webAppPath.Replace("generate.background", "generate.web");
                    webAppPath += @"\bin\Debug\netcoreapp2.2";
                }
                else
                {
                    webAppPath = _appSettings.Value.WebAppPath;
                }

                _hangfireHelper.TriggerSiteUpdate(_hostingEnvironment.ContentRootPath, webAppPath);

                return Ok();

            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }


        }


    }
}
