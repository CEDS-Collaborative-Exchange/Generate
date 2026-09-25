using generate.core.Interfaces.Repositories.App;
using generate.core.Models.App;
using Microsoft.AspNetCore.Mvc;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using RestSharp;
using generate.core.Dtos.App;
using System.Collections.Generic;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Authorization;
using Azure.Core;
using Azure.Identity;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/appupdate")]
    [Authorize]
    public class AppUpdateController: Controller
    {
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<AppUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;
        private readonly ManagedIdentityCredential _credential = new ManagedIdentityCredential();

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

        /// <summary>
        /// A RestSharp client for generate.background's own protected update API, authenticated
        /// with a token acquired via this app's managed identity, scoped to background's Azure
        /// AD app registration.
        /// </summary>
        private RestClient GetBackgroundClient()
        {
            var backgroundUrl = _appSettings.Value.BackgroundUrl;
            var scope = _appSettings.Value.BackgroundApiScope;

            var token = _credential.GetToken(new TokenRequestContext(new[] { scope }), CancellationToken.None).Token;

            var options = new RestClientOptions(backgroundUrl + "/api/backgroundUpdate/")
            {
                Authenticator = new RestSharp.Authenticators.JwtAuthenticator(token)
            };

            return new RestClient(options);
        }

        [HttpGet("")]
        public ActionResult<IEnumerable<UpdatePackageDto>> DownloadedUpdates()
        {
            _logger.LogInformation("DownloadedUpdates - Initiated - " + _hostingEnvironment.ContentRootPath);

            // Get downloaded updates on web server
            List<UpdatePackageDto> updatesOnWebServer = _appUpdateService.GetDownloadedUpdates(_hostingEnvironment.ContentRootPath);

            // Get downloaded updates on background server
            var client = GetBackgroundClient();
            var request = new RestRequest("", Method.Get);

            _logger.LogInformation("DownloadedUpdates - Calling " + _appSettings.Value.BackgroundUrl + "/api/backgroundUpdate/");
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
            try { return _appUpdateService.CheckForPendingUpdates(); }
            catch (Exception ex) { return BadRequest(ex); }
        }

        [HttpGet("status")]
        public ActionResult<UpdateStatusDto> UpdateStatus()
        {
            try { return _appUpdateService.GetUpdateStatus(); }
            catch (Exception ex) { return BadRequest(ex); }
        }

        [HttpPost("download")]
        public IActionResult DownloadUpdates()
        {
            // Download background updates to web server
            _appUpdateService.DownloadUpdates(_hostingEnvironment.ContentRootPath);

            // Download web updates to background server
            var client = GetBackgroundClient();
            var request = new RestRequest("download", Method.Post);
            var response = client.Post(request);

            if (response.IsSuccessful) return Ok();
            else return BadRequest();
        }

        [HttpPost("clear")]
        public IActionResult ClearUpdates()
        {
            // Delete background updates from web server
            _appUpdateService.ClearUpdates(_hostingEnvironment.ContentRootPath);

            // Delete web updates from background server
            var client = GetBackgroundClient();
            var request = new RestRequest("clear", Method.Post);
            var response = client.Post(request);

            if (response.IsSuccessful) return Ok();
            else return BadRequest();
        }

        [HttpPut("execute")]
        public IActionResult ExecuteUpdate()
        {
            try
            {
                // Apply this app's own ("web") part of the update to itself, via Azure Blob
                // Storage + ARM. Never touches generate.background's package or App Service
                // resource directly.
                _appUpdateService.ExecuteSiteUpdate(_hostingEnvironment.ContentRootPath, "web");

                // Ask background to apply its own ("background") part to itself the same way
                var client = GetBackgroundClient();
                var request = new RestRequest("execute", Method.Put);
                var response = client.Put(request);

                if (response.IsSuccessful) return Ok();
                else return BadRequest();
            }
            catch (Exception ex) { return BadRequest(ex); }
        }
    }
}
