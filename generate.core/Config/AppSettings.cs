using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Config
{
    public class AppSettings
    {
        public string Environment { get; set; }
        public string ADLoginDomain { get; set; }
        public string BackgroundUrl { get; set; }
        public string WebAppPath { get; set; }
        public string BackgroundAppPath { get; set; }
        //MER Changed to switch to embedded mode...value currently used is EMBEDDED, otherwise defaults "normal" userstore/manager
        public string UserStoreType { get; set; }

        // ARM resource id of this app's own App Service (e.g. /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Web/sites/{name}),
        // used to re-point WEBSITE_RUN_FROM_PACKAGE at a newly-deployed package.
        public string AzureAppServiceResourceId { get; set; }
        // Full URL of the Azure Blob Storage container that this app's deployment packages are uploaded to
        // (e.g. https://<account>.blob.core.windows.net/<container>). This app's managed identity needs
        // Storage Blob Data Contributor on this container.
        public string AzureStorageContainerUrl { get; set; }
        // (generate.web only) Azure AD scope used to request a token, via managed identity, for calling
        // generate.background's own protected API (e.g. api://<background-app-client-id>/.default).
        public string BackgroundApiScope { get; set; }
        // Feature flag gating the Azure Blob Storage + WEBSITE_RUN_FROM_PACKAGE deployment mechanism.
        // Defaults to false, which falls back to the legacy in-place file-copy mechanism (backup/
        // offline/copy/restore) so updates keep working until the Azure infra/RBAC this depends on
        // (storage container, ARM role assignments, background's app registration) is provisioned.
        public bool EnableAzureDeployment { get; set; }

    }
}
