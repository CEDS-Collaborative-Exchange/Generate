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
using generate.web.Security;
using System.Net;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/appupdate")]
    [Authorize(Roles = AppRoles.Administrator)]
    public class AppUpdateController: Controller
    {
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IHostEnvironment _hostingEnvironment;
        private readonly ILogger<AppUpdateController> _logger;
        private readonly IAppUpdateService _appUpdateService;
        private readonly ManagedIdentityCredential _credential = new ManagedIdentityCredential();
        private static readonly TimeSpan BackgroundRetryInterval = TimeSpan.FromSeconds(5);
        private static readonly TimeSpan BackgroundRestartTimeout = TimeSpan.FromMinutes(2);

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
            var options = new RestClientOptions(backgroundUrl + "/api/backgroundUpdate/");

            // Managed Identity is only available when actually running in Azure, and
            // BackgroundApiScope is only configured there - skip the token acquisition for the
            // legacy/local path (EnableAzureDeployment = false) so this controller keeps working
            // outside Azure instead of throwing on every call.
            if (_appSettings.Value.EnableAzureDeployment)
            {
                var scope = _appSettings.Value.BackgroundApiScope;
                var token = _credential.GetToken(new TokenRequestContext(new[] { scope }), CancellationToken.None).Token;
                options.Authenticator = new RestSharp.Authenticators.JwtAuthenticator(token);
            }

            return new RestClient(options);
        }

        /// <summary>
        /// Calls generate.background's update API. Uses Execute rather than RestSharp's
        /// Get/Post/Put extensions, which throw on any non-success status - background answers
        /// 503 while an update has it offline (app_offline.htm), and that must surface as a
        /// handled error rather than an unhandled exception.
        /// With <paramref name="retryWhileUnavailable"/>, a 503 is retried every few seconds until
        /// that much time has passed.
        /// </summary>
        private RestResponse CallBackground(string resource, Method method, string caller, TimeSpan? retryWhileUnavailable = null)
        {
            var client = GetBackgroundClient();
            var giveUpAt = DateTime.UtcNow + (retryWhileUnavailable ?? TimeSpan.Zero);
            var response = client.Execute(new RestRequest(resource, method));

            while (response.StatusCode == HttpStatusCode.ServiceUnavailable && DateTime.UtcNow < giveUpAt)
            {
                _logger.LogInformation(caller + " - Background site unavailable, retrying in " + BackgroundRetryInterval.TotalSeconds + " seconds");
                Thread.Sleep(BackgroundRetryInterval);
                response = client.Execute(new RestRequest(resource, method));
            }

            if (!response.IsSuccessful)
            {
                _logger.LogError(caller + " - Background API call failed - Status = " + response.StatusCode);
                _logger.LogError(caller + " - Response ErrorMessage = " + response.ErrorMessage);
                _logger.LogError(caller + " - Response Content = " + response.Content);
            }

            return response;
        }

        private BadRequestObjectResult BackgroundFailed(RestResponse response)
        {
            if (response.StatusCode == HttpStatusCode.ServiceUnavailable)
            {
                return BadRequest("The background site is offline, most likely because an update is in progress. Try again in a few minutes.");
            }

            return BadRequest("The background site could not be reached (" + (response.ErrorMessage ?? response.StatusCode.ToString()) + ").");
        }

        [HttpGet("")]
        public ActionResult<IEnumerable<UpdatePackageDto>> DownloadedUpdates()
        {
            _logger.LogInformation("DownloadedUpdates - Initiated - " + _hostingEnvironment.ContentRootPath);

            // Get downloaded updates on web server
            List<UpdatePackageDto> updatesOnWebServer = _appUpdateService.GetDownloadedUpdates(_hostingEnvironment.ContentRootPath);

            // Get downloaded updates on background server
            _logger.LogInformation("DownloadedUpdates - Calling " + _appSettings.Value.BackgroundUrl + "/api/backgroundUpdate/");
            var response = CallBackground("", Method.Get, "DownloadedUpdates");
            _logger.LogInformation("DownloadedUpdates - Response status code = " + response.StatusCode);

            if (!response.IsSuccessful) return BackgroundFailed(response);

            var updatesOnBackgroundServer = JsonConvert.DeserializeObject<List<UpdatePackageDto>>(response.Content);
            if (updatesOnWebServer.Count == updatesOnBackgroundServer.Count)
            {
                _logger.LogInformation("DownloadedUpdates - Successful - " + updatesOnWebServer.Count + " available update(s)");
                return updatesOnWebServer;
            }
            else
            {
                _logger.LogError("DownloadedUpdates - Update count mismatch - Web = " + updatesOnWebServer.Count + " / Background = " + updatesOnBackgroundServer.Count);
                return BadRequest("Downloaded updates do not match - web has " + updatesOnWebServer.Count + ", background has " + updatesOnBackgroundServer.Count + ". Clear the updates and download them again.");
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
                return BadRequest(ex.Message);
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
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("download")]
        public IActionResult DownloadUpdates()
        {
            // Download background updates to web server
            _appUpdateService.DownloadUpdates(_hostingEnvironment.ContentRootPath);

            // Download web updates to background server
            var response = CallBackground("download", Method.Post, "DownloadUpdates");

            if (response.IsSuccessful) return Ok();
            else return BackgroundFailed(response);
        }

        [HttpPost("clear")]
        public IActionResult ClearUpdates()
        {
            // Delete background updates from web server
            _appUpdateService.ClearUpdates(_hostingEnvironment.ContentRootPath);

            // Delete web updates from background server
            var response = CallBackground("clear", Method.Post, "ClearUpdates");

            if (response.IsSuccessful) return Ok();
            else return BackgroundFailed(response);
        }

        [HttpPut("execute")]
        public IActionResult ExecuteUpdate()
        {
            try
            {
                // Azure path: deploys this app's own ("web") part to itself via Azure Blob
                // Storage + ARM, using its own Managed Identity - never touches
                // generate.background's package or App Service resource directly.
                // Legacy path: a running process can never overwrite its own currently-loaded
                // binaries, so the in-place file copy targets generate.background's content root
                // instead (ignored entirely by the Azure path).
                var backgroundAppPath = _appSettings.Value.BackgroundAppPath;
                if (_hostingEnvironment.IsDevelopment())
                {
                    // Use this app's own build output folder (e.g. bin\Debug\net10.0) for the background app
                    var buildOutputPath = System.IO.Path.GetRelativePath(_hostingEnvironment.ContentRootPath, AppContext.BaseDirectory);
                    backgroundAppPath = System.IO.Path.Combine(_hostingEnvironment.ContentRootPath.Replace("generate.web", "generate.background"), buildOutputPath).TrimEnd('\\');
                }

                _appUpdateService.ExecuteSiteUpdate(_hostingEnvironment.ContentRootPath, "web", backgroundAppPath);

                // Ask background to apply its own ("background") part to itself the same way
                // Background was just brought back online by the update above - IIS keeps serving
                // app_offline.htm (503) until it notices the file is gone and the site restarts,
                // so give it time instead of failing the second half of the update.
                var response = CallBackground("execute", Method.Put, "ExecuteUpdate", BackgroundRestartTimeout);

                if (response.IsSuccessful) return Ok();
                else return BackgroundFailed(response);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
