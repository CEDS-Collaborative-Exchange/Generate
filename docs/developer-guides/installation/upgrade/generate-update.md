---
description: >-
  This document provides guidance and steps to upgrade Generate to a new
  release.
---

# Generate Update

## Audience <a href="#toc113461782" id="toc113461782"></a>

Technical staff that will be performing the Generate system upgrade.

{% hint style="info" %}
It is strongly recommended that this document be read in full before attempting the upgrade.
{% endhint %}

## System Requirements <a href="#toc113461784" id="toc113461784"></a>

#### Web Server:

* [x] **Windows 2012 R2** (or newer) with **IIS 8.5** (or newer)
* [x] At least **8 GB** of RAM

#### Database Server:

* [x] **Windows 2012 R2** (or newer) with **SQL Server 2017** (or newer)
* [x] At least **32 GB** of RAM (**64 GB** RAM recommended)
* [x] At least **50 GB** of free storage
* [x] Web Server and Database Server may be on the same machine, if desired.
* [x] .NET Core Runtime: Version 8.0.10 installed on Web Server.
* [x] Active Directory (AD) accessible from the Web Server. If no AD installation exists, AD LDS may be installed.
* [x] Application Initialization Module for IIS installed on the Web Server.

## Getting Started

If the current version of Generate is 3.1 or higher, updates should be performed using the Automatic Update functionality of Generate. This can be found in the Settings menu under the menu item named “Update”. This feature is available to users with the Admin role.

![](<../../../.gitbook/assets/Developer Guide_Upgrade_image1.png>)

## Update Steps (Manual Steps) <a href="#toc113461785" id="toc113461785"></a>

### Database Server <a href="#toc113461786" id="toc113461786"></a>

There are two options for upgrading the database server:

1. Using a PowerShell script
2. Running SQL scripts manually

The PowerShell method is quicker but requires some basic knowledge of PowerShell. The SQL script method will take longer but only requires knowledge of running SQL scripts.

{% hint style="info" %}
We strongly recommend using the PowerShell method as it is much quicker and less prone to manual error.
{% endhint %}

### **PowerShell Method**

1. Create a backup of your database in case the update fails, and you need to revert the changes.
2. In the web application directory on the Web Server, copy the “`DatabaseScripts`” directory to the database server.
3. Open the `RunDatabaseScripts.ps1` file in a text editor.
4. If needed, modify the `$sqlCmdPath` value to suit your environment. This should be the path of your `sqlcmd.exe` executable.
5. Save the file and open a PowerShell session.
6. Change the path to the directory where the `RunDatabaseScripts.ps1` file is located.
7. Execute the PowerShell script with the following parameters relevant to your environment:
   * Version
   * Server
   * Database
   * User
   * Password
8. Confirm that the script executes successfully.
9. If the script fails, you may revert the update by restoring the backup created in the first step.

{% hint style="info" %}
<mark style="background-color:blue;">**Example**</mark><mark style="background-color:blue;">:</mark>

./RunDatabaseScripts.ps1 "11.0" "192.168.51.53" "generate " "generate" "password"
{% endhint %}

### **SQL Scripts Method**

1. Create a backup of your database in case the update fails, and you need to revert the changes.
2. In the web application directory on the Web Server, copy the “`DatabaseScripts`” directory to the database server.
3. Open the “**VersionScripts.csv**” file in the “`VersionUpdates\x.x`” directory for the relevant version.
4. Execute each script listed in that file against the Generate database in the exact order they are listed in the file. The first column specifies the relative path of the file and the second column specifies the file name. You can ignore the third column.
5. It is important that every script is executed in order and runs successfully.
6. If any script fails, you may revert the update by restoring the backup created in the first step.

### Web Application <a href="#toc10102655" id="toc10102655"></a>

1. Only perform these steps if the database update was successful.
2. Ensure the web server has the proper version of the .NET Core Runtime and Hosting Bundle referenced in the System Requirements. Keep in mind this may have changed since the last version of Generate.
3. In IIS, stop the generate.web website.
4. Make a backup of the generate.web website folder.
5. Delete all files within the generate.web website folder, except for the “appSettings.json” file located in the “Config” directory.
6. Extract contents of “generate.web\_x.x.zip” into a temporary directory.
7. Copy all files from the just extracted “generate.web\_x.x” folder, except for the “appSettings.json” file located in the “Config” directory, into the website folder
8. Start up the web application in IIS.
9. Open the website in a browser to confirm that it loads properly.

{% hint style="info" %}
Only perform the following steps if the database and web updates were successful.
{% endhint %}

### Background Application (update) <a href="#toc113461789" id="toc113461789"></a>

15. In IIS, stop the **generate.background** website.
16. Make a backup of the **generate.background** website folder.
17. Delete all files within the **generate.background** website folder, except for the “**appSettings.json**” file located in the “**Config**” directory.
18. Extract contents of “**generate.background\_x.x.zip**” into a temporary directory.
19. Copy all files from the just extracted “**generate.background \_x.x**” folder, except for the “**appSettings.json**” file located in the “**Config**” directory, into the website folder.
20. Start up the web application in IIS.

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
