using Azure.Core;
using Azure.Identity;
using Azure.Storage.Blobs;
using generate.core.Config;
using generate.core.Interfaces.Helpers;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading;

namespace generate.infrastructure.Helpers
{
    public class AzureAppDeploymentHelper : IAppDeploymentHelper
    {
        private const string ArmScope = "https://management.azure.com/.default";
        private const string ArmApiVersion = "2022-03-01";
        private const string ArmBaseUrl = "https://management.azure.com";

        private readonly IOptions<AppSettings> _appSettings;
        private readonly ILogger<AzureAppDeploymentHelper> _logger;
        private readonly ManagedIdentityCredential _credential;

        public AzureAppDeploymentHelper(IOptions<AppSettings> appSettings, ILogger<AzureAppDeploymentHelper> logger)
        {
            _appSettings = appSettings ?? throw new ArgumentNullException(nameof(appSettings));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _credential = new ManagedIdentityCredential();
        }

        public void DeployPackage(string packageZipFilePath)
        {
            var containerUrl = _appSettings.Value.AzureStorageContainerUrl;
            var resourceId = _appSettings.Value.AzureAppServiceResourceId;
            var blobName = Path.GetFileName(packageZipFilePath);

            // Upload the package. This app's managed identity needs Storage Blob Data
            // Contributor on this container.
            var containerClient = new BlobContainerClient(new Uri(containerUrl), _credential);
            var blobClient = containerClient.GetBlobClient(blobName);

            using (var stream = File.OpenRead(packageZipFilePath))
            {
                blobClient.Upload(stream, overwrite: true);
            }

            _logger.LogInformation("Update - Uploaded deployment package to " + blobClient.Uri);

            SetRunFromPackage(resourceId, blobClient.Uri.ToString());

            _logger.LogInformation("Update - WEBSITE_RUN_FROM_PACKAGE updated - Azure will restart and mount the new package");
        }

        /// <summary>
        /// Re-points WEBSITE_RUN_FROM_PACKAGE (and the Managed-Identity blob pull setting that
        /// makes the earlier Storage Blob Data Contributor grant meaningful) at the new package,
        /// via the ARM app-settings API. This app's managed identity needs the Website Contributor
        /// role scoped to itself for this call to succeed.
        /// </summary>
        private void SetRunFromPackage(string resourceId, string packageUrl)
        {
            var armToken = _credential.GetToken(new TokenRequestContext(new[] { ArmScope }), CancellationToken.None).Token;

            using var httpClient = new HttpClient { BaseAddress = new Uri(ArmBaseUrl) };
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", armToken);

            // Reading current app settings requires the "list" action - the collection can
            // contain secrets, so ARM doesn't expose it on a plain GET.
            using var listRequest = new HttpRequestMessage(HttpMethod.Post, resourceId + "/config/appsettings/list?api-version=" + ArmApiVersion);
            using var listResponse = httpClient.Send(listRequest);
            listResponse.EnsureSuccessStatusCode();

            var currentSettings = new Dictionary<string, string>();
            using (var listDocument = JsonDocument.Parse(listResponse.Content.ReadAsStream()))
            {
                if (listDocument.RootElement.TryGetProperty("properties", out var propertiesElement))
                {
                    foreach (var property in propertiesElement.EnumerateObject())
                    {
                        currentSettings[property.Name] = property.Value.GetString();
                    }
                }
            }

            // Updating app settings replaces the entire collection, so the existing settings
            // must be merged with the ones this deploy changes.
            currentSettings["WEBSITE_RUN_FROM_PACKAGE"] = packageUrl;
            currentSettings["WEBSITE_RUN_FROM_PACKAGE_BLOB_MI_RESOURCE_ID"] = "system";

            var updateBody = JsonSerializer.Serialize(new { properties = currentSettings });

            using var updateRequest = new HttpRequestMessage(HttpMethod.Put, resourceId + "/config/appsettings?api-version=" + ArmApiVersion)
            {
                Content = new StringContent(updateBody, Encoding.UTF8, "application/json")
            };
            using var updateResponse = httpClient.Send(updateRequest);
            updateResponse.EnsureSuccessStatusCode();
        }
    }
}
