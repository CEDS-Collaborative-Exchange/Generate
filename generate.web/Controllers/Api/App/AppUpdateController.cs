using generate.core.Interfaces.Repositories.App;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using RestSharp;
using generate.core.Dtos.App;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/appupdate")]
    public class AppUpdateController: Controller
    {
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<AppUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;

        public AppUpdateController(
            ILogger<AppUpdateController> logger,
            IHostEnvironment hostingEnvironment,
            IAppUpdateService appUpdateService,
            IOptions<AppSettings> appSettings
            )
        {
            _logger = logger;
            _hostingEnvironment = hostingEnvironment;
            _appUpdateService = appUpdateService;
            _appSettings = appSettings;
        }

        [HttpGet("")]
        public ActionResult<IEnumerable<UpdatePackageDto>> DownloadedUpdates()
        {
            _logger.LogInformation("DownloadedUpdates - Initiated - " + _hostingEnvironment.ContentRootPath);

            // Get downloaded updates on web server

            List<UpdatePackageDto> updatesOnWebServer = _appUpdateService.GetDownloadedUpdates(_hostingEnvironment.ContentRootPath);

            // Get downloaded updates on background server
            var backgroundUrl = _appSettings.Value.BackgroundUrl;
            var client = new RestClient(backgroundUrl + "/api/backgroundUpdate/");
            var request = new RestRequest("", Method.Get);

            _logger.LogInformation("DownloadedUpdates - Calling " + backgroundUrl + "/api/backgroundUpdate/");

            var response = client.Get(request);

            _logger.LogInformation("DownloadedUpdates - Response status code = " + response.StatusCode);

            if (response.IsSuccessful)
            {
                var updatesOnBackgroundServer = JsonConvert.DeserializeObject<List<UpdatePackageDto>>(response.Content);
                
                if (updatesOnWebServer.Count == updatesOnBackgroundServer.Count)
                {
                    _logger.LogInformation("DownloadedUpdates - Successful - " + updatesOnWebServer.Count + " available update(s)");

                    return updatesOnWebServer;
                } 
                else
                {
                    _logger.LogError("DownloadedUpdates - Update count mismatch - Web = " + updatesOnWebServer.Count + " / Background = " + updatesOnBackgroundServer.Count);

                    return BadRequest();
                }
            }
            else
            {
                _logger.LogError("DownloadedUpdates - Background API call failed");
                _logger.LogError("DownloadedUpdates - Response ErrorMessage = " + response.ErrorMessage);
                _logger.LogError("DownloadedUpdates - Response Content = " + response.Content);

                return BadRequest();
            }

        }


        [HttpGet("pending")]
        public ActionResult<IEnumerable<UpdatePackageDto>> PendingUpdates()
        {
            try
            {
                return _appUpdateService.CheckForPendingUpdates();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }

        }


        [HttpGet("status")]
        public ActionResult<UpdateStatusDto> UpdateStatus()
        {
            try
            {
                return _appUpdateService.GetUpdateStatus();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }

        }


        [HttpPost("download")]
        public IActionResult DownloadUpdates()
        {
            // Download background updates to web server
            _appUpdateService.DownloadUpdates(_hostingEnvironment.ContentRootPath);

            // Download web updates to background server
            var backgroundUrl = _appSettings.Value.BackgroundUrl;
            var client = new RestClient(backgroundUrl + "/api/backgroundUpdate/");
            var request = new RestRequest("download", Method.Post);
            var response = client.Post(request);

            if (response.IsSuccessful)
            {
                return Ok();
            } else
            {
                return BadRequest();
            }
        }


        [HttpPost("clear")]
        public IActionResult ClearUpdates()
        {
            // Delete background updates from web server
            _appUpdateService.ClearUpdates(_hostingEnvironment.ContentRootPath);

            // Delete web updates from background server
            var backgroundUrl = _appSettings.Value.BackgroundUrl;
            var client = new RestClient(backgroundUrl + "/api/backgroundUpdate/");
            var request = new RestRequest("clear", Method.Post);
            var response = client.Post(request);

            if (response.IsSuccessful)
            {
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpPut("execute")]
        public IActionResult ExecuteUpdate()
        {
            // Apply update on background server using web server

            try
            {
                var backgroundAppPath = _hostingEnvironment.ContentRootPath;

                if (_hostingEnvironment.IsDevelopment())
                {
                    backgroundAppPath = backgroundAppPath.Replace("generate.web", "generate.background");
                    backgroundAppPath += @"\bin\Debug\netcoreapp2.2";
                }
                else
                {
                    backgroundAppPath = _appSettings.Value.BackgroundAppPath;
                }

                _appUpdateService.ExecuteSiteUpdate(_hostingEnvironment.ContentRootPath, backgroundAppPath);

                // Apply update on web server using background server
                var backgroundUrl = _appSettings.Value.BackgroundUrl;
                var client = new RestClient(backgroundUrl + "/api/backgroundUpdate/");
                var request = new RestRequest("execute", Method.Put);
                var response = client.Put(request);

                if (response.IsSuccessful)
                {
                    return Ok();
                }
                else
                {
                    return BadRequest();
                }


            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }


        }

    }
}
