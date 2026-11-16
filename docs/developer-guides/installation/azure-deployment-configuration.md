---
description: >-
  How to configure Generate's automatic updates to install through Azure Blob
  Storage when Generate is hosted on Azure App Service.
---

# Azure Deployment Configuration

## Audience

Technical staff at the State Education Agency who host Generate on **Azure App Service** and manage its Azure resources.

{% hint style="info" %}
If Generate runs on your own Windows/IIS servers, you do **not** need anything on this page. Leave `EnableAzureDeployment` set to `false` (the default) and automatic updates will keep working the way they always have.
{% endhint %}

## What these settings do

Generate's **Update** feature (Settings → Update) installs new releases for you. By default it does this by copying the new files over the existing site on disk.

On Azure App Service, Generate can instead install updates the Azure way:

1. It uploads the new release package to an Azure Blob Storage container.
2. It points the App Service at that package (the `WEBSITE_RUN_FROM_PACKAGE` setting).
3. Azure restarts the site and runs the new version.

Generate does this using each App Service's **managed identity**, so no passwords or keys are stored in the configuration files.

## The settings

These settings go in the `AppSettings` section of the `appsettings.json` file (or the `appsettings.{Environment}.json` file for your environment, such as `appsettings.Production.json`).

| Setting | Generate web site | Generate background site | What to enter |
| --- | --- | --- | --- |
| `EnableAzureDeployment` | Yes | Yes | `true` to install updates through Azure. `false` (default) to use the file-copy method. |
| `AzureAppServiceResourceId` | Yes | Yes | The resource ID of **that site's own** App Service. |
| `AzureStorageContainerUrl` | Yes | Yes | The URL of the Blob Storage container that holds update packages. |
| `BackgroundApiScope` | Yes | No | The scope the web site uses to call the background site securely. |

{% hint style="warning" %}
Set `EnableAzureDeployment` to the **same value** in both the web site and the background site. Leave it `false` until every step under [Azure setup](#azure-setup) is complete. If it is turned on before the Azure resources and permissions exist, updates will fail.
{% endhint %}

### EnableAzureDeployment

Turns the Azure update method on or off.

```json
"EnableAzureDeployment": true
```

When this is `false`, the other three settings are ignored and can stay empty.

### AzureAppServiceResourceId

The full Azure resource ID of the App Service that this copy of Generate is running in. Each site updates itself, so the web site and the background site each get **their own** resource ID.

```json
"AzureAppServiceResourceId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Web/sites/{app-service-name}"
```

To find it: in the Azure portal, open the App Service, select **Overview → JSON View**, and copy the **Resource ID**.

### AzureStorageContainerUrl

The full URL of the Blob Storage container where Generate uploads update packages. The web site and the background site can share the same container.

```json
"AzureStorageContainerUrl": "https://{storage-account}.blob.core.windows.net/{container-name}"
```

To find it: in the Azure portal, open the storage account, select **Containers**, open the container, and select **Properties** to copy the URL.

### BackgroundApiScope (web site only)

When the Azure update method is on, the background site only accepts update requests that carry a valid Microsoft Entra ID token. The web site uses this scope to request that token.

```json
"BackgroundApiScope": "api://{background-app-client-id}/.default"
```

Use the **Application ID URI** of the background site's app registration followed by `/.default`. Do not add this setting to the background site.

## Azure setup

Complete these steps **before** setting `EnableAzureDeployment` to `true`.

### 1. Turn on managed identity for both App Services

For the web App Service and the background App Service:

1. Open the App Service in the Azure portal.
2. Select **Identity → System assigned**.
3. Set **Status** to **On** and select **Save**.

### 2. Create the storage container

1. Create (or choose) a storage account.
2. Create a **private** container for update packages, for example `generate-packages`.

### 3. Grant permissions

Give **each** App Service's managed identity these two roles:

| Role | Assign it on |
| --- | --- |
| **Storage Blob Data Contributor** | The storage container from step 2 |
| **Website Contributor** | That site's **own** App Service |

To assign a role: open the resource, select **Access control (IAM) → Add → Add role assignment**, choose the role, then under **Members** choose **Managed identity** and select the App Service.

{% hint style="info" %}
The **Website Contributor** role lets the site change its own `WEBSITE_RUN_FROM_PACKAGE` setting. Scope it to the single App Service, not to the resource group or subscription.
{% endhint %}

### 4. Register the background site in Microsoft Entra ID

1. Create an app registration for the background site (see [Register an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)).
2. Under **Expose an API**, set the **Application ID URI** (the default `api://{client-id}` is fine).
3. Add the registration's details to the `AzureAd` section of the **background** site's `appsettings.json`:

```json
"AzureAd": {
  "Instance": "https://login.microsoftonline.com/",
  "Domain": "<Your Azure AD Domain>",
  "TenantId": "<Your Tenant ID>",
  "ClientId": "<Background app registration Client ID>"
}
```

4. Use the same Application ID URI for `BackgroundApiScope` in the **web** site's settings.

## Example configuration

**Web site** (`appsettings.Production.json`):

```json
"AppSettings": {
  "AzureAppServiceResourceId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Web/sites/generate-web",
  "AzureStorageContainerUrl": "https://{storage-account}.blob.core.windows.net/generate-packages",
  "BackgroundApiScope": "api://{background-app-client-id}/.default",
  "EnableAzureDeployment": true
}
```

**Background site** (`appsettings.Production.json`):

```json
"AppSettings": {
  "AzureAppServiceResourceId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Web/sites/generate-background",
  "AzureStorageContainerUrl": "https://{storage-account}.blob.core.windows.net/generate-packages",
  "EnableAzureDeployment": true
}
```

Restart both App Services after changing these files.

## Checking that it works

Run an update from **Settings → Update**, then check the Generate log files (`logs/log-{date}.txt`):

* **Working:** `Update - Uploaded deployment package to ...` followed by `Update - WEBSITE_RUN_FROM_PACKAGE updated`.
* **Still using file copy:** `Update - Executing Updates via legacy file copy (AppSettings:EnableAzureDeployment is false)`. Check that `EnableAzureDeployment` is `true` and that the site was restarted.

## Troubleshooting

| Problem | Likely cause |
| --- | --- |
| Update fails with a **403** error while uploading the package | The App Service's managed identity is missing **Storage Blob Data Contributor** on the container. |
| Update fails with a **403** error after the upload | The managed identity is missing **Website Contributor** on its own App Service, or `AzureAppServiceResourceId` points at the wrong App Service. |
| "The background site could not be reached (Unauthorized)" | `BackgroundApiScope` on the web site does not match the background app registration, or the background site's `AzureAd` section is incomplete. |
| Errors about managed identity not being available | Managed identity is not turned on for that App Service, or Generate is not running on Azure. Set `EnableAzureDeployment` to `false` for non-Azure installs. |

Role assignments can take several minutes to take effect. Wait about 10 minutes after assigning roles before retrying.
