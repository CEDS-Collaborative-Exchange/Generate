# Manual Update Steps

## Manual Update Steps <a href="#toc113461785" id="toc113461785"></a>

Upgrading your database server can be approached in two distinct ways, depending on your technical expertise:

1. **PowerShell Method**
   * <mark style="color:green;">**Advantages**</mark>**:** Quicker execution.
   * <mark style="color:orange;">**Prerequisites**</mark>**:** A basic understanding of PowerShell.
2. **SQL Scripts Method**
   * <mark style="color:green;">**Advantages**</mark>**:** Accessible to those with SQL script experience.
   * <mark style="color:orange;">**Prerequisites**</mark>**:** Knowledge of SQL script execution, albeit more time-consuming.

Select the method that aligns with your skill set and available resources for an efficient upgrade process.

{% hint style="success" %}
We strongly recommend using the **PowerShell** method as it is much quicker and less prone to manual error.
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

### SQL Scripts Method

1. **Create a Database Backup**: Before initiating any updates, make sure to create a backup of your database. This precaution allows you to revert the database to its previous state if the update process encounters any issues.
2. **Prepare the Scripts**:
   * Navigate to the “`VersionUpdates\x.x`” directory.
   * Locate the “**VersionScripts.csv**” file. This file contains a list of scripts required for the update.
   * In the first column of the file, you will find the relative path to each script, while the second column provides the name of the script. The third column is not needed for this process.
3. **Transfer Scripts**:
   * Within the web application directory on your Web Server, identify the “`DatabaseScripts`” folder.
   * Copy this folder onto the database server to have all the required scripts in place for execution.
4. **Execute Scripts**:
   * Ensure that you execute all scripts in the order they appear in the “VersionScripts.csv” file.
   * These scripts should be run against the Generate database, strictly adhering to the sequence provided to avoid any update errors or inconsistencies.
5. **Reversion Strategy**:
   * In case any script fails to execute correctly, utilize the database backup created in the first step to revert the database to its pre-update condition. This ensures that your system maintains integrity and functionality even if the update process does not proceed as planned.

By following these guidelines, you can safely and efficiently update your database with new SQL scripts.

***

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
