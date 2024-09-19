---
description: >-
  This document provides guidance and steps to upgrade Generate to a new
  release.
---

# Generate Update

## Getting Started

### **Permission Changes for Auto-Update**

To ensure the Auto-Update feature of Generate functions correctly, set the following permissions:

* `generate.web` **Application Pool Identity**: Requires **Create** and **Modify** permissions on the entire `generate.background` application directory.
* `generate.background` **Application Pool Identity**: Requires **Create** and **Modify** permissions on the entire `generate.web` application directory.

### Updating Generate

For versions 3.1 and above, updates are streamlined through the Automatic Update feature. Admin users can follow these simple steps:

1. **Navigate to** `Settings`.
2. **Select** the `Update` option.

![](<../../../.gitbook/assets/Developer Guide\_Upgrade\_image1.png>)

This ensures your Generate application stays up-to-date effortlessly.

***

#### Web Application Update Process

Perform these steps **only if the database update was successful**:

1. Ensure the web server is running the required version of the **.NET Core Runtime and Hosting Bundle** as outlined in the System Requirements. Note that these requirements may have changed since the last version of Generate.
2. In IIS, **stop** the `generate.web` website.
3. **Backup** the `generate.web` website folder.
4. **Delete** all files within the `generate.web` folder, except for the `appSettings.json` file in the `Config` directory.
5. **Extract** the contents of `generate.web_x.x.zip` to a temporary directory.
6. **Copy** all files from the extracted `generate.web_x.x` folder (excluding the `appSettings.json` file) to the website folder.
7. In IIS, **start** the `generate.web` website.
8. Open the website in a browser to verify that it loads properly.

Perform these steps **only if both the database and web updates were successful**.

### Background Application Update Process

1. In IIS, **stop** the `generate.background` website.
2. **Backup** the `generate.background` website folder.
3. **Delete** all files within the `generate.background` folder, except for the `appSettings.json` file in the `Config` directory.
4. **Extract** the contents of `generate.background_x.x.zip` to a temporary directory.
5. **Copy** all files from the extracted `generate.background_x.x` folder (excluding the `appSettings.json` file) to the website folder.
6. In IIS, **start** the `generate.background` website.

### Permission Changes <a href="#toc113461790" id="toc113461790"></a>

For the Auto-Update functionality of Generate to work properly, you must ensure that the following permissions are set on the **generate.web** and **generate.backgound** directories:

* The Application Pool Identity user account used by the **generate.background** site, must have Create and Modify permissions on the entire **generate.web** application directory.
* The Application Pool Identity user account used by the **generate.web** site, must have Create and Modify permissions on the entire generate.background application directory.

### Active Directory (AD) <a href="#toc113461791" id="toc113461791"></a>

Generate makes use of Active Directory (AD) for authentication and authorization. If an existing installation of AD is not available, Active Directory Lightweight Directory Services (AD LDS) may be installed. For those instructions, please see the AD LDS instructions in the Optional Installations section. The AD settings for Generate are configured in the “appsettings.json” file located in the “Config” folder of the web application directory. Please see the following for the configuration settings.

```sql
{
"AppSettings": {
"Environment": "production",
"ProvisionJobs": false,
"ADDomain": "ETSS.local",
"ADLoginDomain": "ETSS",
"ADPort": "389",
"ADContainer": "CN=Builtin,DC=ETSS,DC=local",
"UserContainer": "CN=Users,DC=ETSS,DC=local",
"ReviewerGroupName": "CN=Users,CN=Builtin,DC=ETSS,DC=local",
"AdminGroupName": "CN=Administrators,CN=Builtin,DC=ETSS,DC=local",
"BackgroundUrl": "http://192.168.1.2",
"BackgroundAppPath": "D:\\Apps\\generate.background"
},
"Data": {
"AppDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
"ODSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
"RDSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;"
}
}
```

Generate makes use of two groups within Active Directory:

* Administrators
* Reviewers

Both AD roles must be configured in the AD instance and accessible by Generate. User access is provisioned via normal AD tools by adding or removing these roles to or from the desired users.

### Final Steps <a href="#final_steps" id="final_steps"></a>

1. Start the web application in IIS.
2. Open the website in a web browser to confirm that it loads properly.
