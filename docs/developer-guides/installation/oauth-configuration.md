---
description: >-
  This documentation provides the steps required to configure OAuth settings in
  the Angular config.json and the ASP.NET Core appsettings.json files for
  integration with Azure Active Directory (AAD).
---

# OAuth Configuration

### **Angular Configuration**

To configure OAuth in your Angular application, modify the `config.json` file as follows:

1. **authType**: Set this to `"OAUTH"` to enable OAuth authentication.

```json
"authType": "OAUTH"
```

2. **clientId**: Enter the Client ID from your Azure AD app registration.

```json
"clientId": "<Your Azure AD Client ID>"
```

3. **authority**: Specify the authority URL using your Azure AD tenant ID.

```json
"authority": "https://login.microsoftonline.com/{tenantid}"
```

4. **redirectUri**: Set this to the callback URI configured in Azure AD for your application.

```json
"redirectUri": "<Your Redirect URI>"
```



***

### **ASP.NET Core Configuration**

For the backend, configure the following settings in the `appsettings.json` file:

1. **UserStoreType**: Set this to `"OAUTH"` to indicate the use of OAuth for user authentication.

```json
jsonCopy code"UserStoreType": "OAUTH"
```

2. **AzureAd**: Configure the Azure AD details within this section.

```json
jsonCopy code"AzureAd": {
  "Instance": "https://login.microsoftonline.com/",
  "Domain": "<Your Azure AD Domain>",
  "TenantId": "<Your Tenant ID>",
  "ClientId": "<Your Azure AD Client ID>"
}
```

***

### **App Registration in Microsoft Entra ID**

To set up an app registration in Azure AD, follow the instructions provided in the Microsoft documentation:

1. Register app in Azure AD

{% embed url="https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate" %}

2.  Once the app registration is complete, the following app roles need to be created:

    * **Administrator**
    * **Reviewer**


3. After creating the app roles, assign users to one of the following roles based on their responsibilities:
   * **Administrator**
   * **Reviewer**
