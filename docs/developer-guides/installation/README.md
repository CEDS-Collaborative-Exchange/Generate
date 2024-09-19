---
icon: download
---

# Installation & Upgrade

### 1. **Database Server Setup**

* Create an empty database named `generate` in SQL Server.
* Create a SQL login called `generate`.
* Use the provided backup file `generate_x.x.bak` to restore the `generate` database. If there are compatibility issues due to SQL Server versions, request a newer version of the backup file.
* **Note:** The backup file’s database name is `generate-test`. Ensure it is restored to the newly created `generate` database.
* Assign the `db_owner` role to the `generate` user on the `generate` database.

***

### 2. Web Server Setup

* Ensure IIS is installed.
* Ensure all pending Windows Updates are installed.
* Install [.NET Core Runtime and Hosting Bundle (version 6.0)](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-6.0.11-windows-hosting-bundle-installer).&#x20;
  * If the Web Server does not have access to the Internet, install the Microsoft Visual C++ 2015 Redistributable (version 14.0.24212 or newer) prior to the .NET Core Windows Server Hosting bundle.
* Execute `iisreset` at the command line or restart the server to pick up changes to the system PATH.
* Restart the server or execute `iisreset` to apply changes.
* Install **Application Initialization Module** in IIS via Server Manager under `Web Server -> Application Development -> Application Initialization`.

{% hint style="info" %}
This is the only item that is required for this installation; any other items checked in the following screenshot are not necessary and may remain checked or unchecked depending on your environment.&#x20;
{% endhint %}

![Graphical user interface, application, Generate](../../.gitbook/assets/1.jpeg)

{% hint style="info" %}
The Web Application will need to be accessible independent of the Background Application. You can achieve this by one of the following methods:
{% endhint %}

* Place both applications on the same server but assign different host names to each website.
* Place both applications on the same server but assign different ports to each website.
* Place both applications on the same server but assign different IP addresses to each website.
* Place the web application and background applications on different servers.

### Web Application

11. Extract the contents of “**generate.web\_x.x.zip**” into a temporary directory.
12. Copy the “**generate.web\_x.x**” folder into a location where you want your web application files to reside.
13. In IIS, create a website called “**generate.web**” and point the physical path to the location of the web application files. Leave the application pool set to a new pool called “**generate.web**”. Adjust the IP Address, Port, and/or Host name as needed for your environment (as mentioned in the Web Server installation steps).

![Graphical user interface, application](<../../.gitbook/assets/3 (1).jpeg>)

14. Set the application pool used by the `generate.web` website to “**No Managed Code**.”

![Graphical user interface, application](<../../.gitbook/assets/4 (2).jpeg>)

15. The application pool used by the Generate website needs to be run under a service account that has access to the Active Directory service. Usually, this account is a domain service account on the network. This can be changed by accessing the Advanced Settings of the newly created application pool.

![Graphical user interface, table](<../../.gitbook/assets/5 (1).jpeg>)

16. From that dialog, change the Identity setting under the Process Model section to the domain service account.

![Graphical user interface, text, application](<../../.gitbook/assets/6 (1).jpeg>)

17. Make sure that the Application Pool Identity user account has permission to Create and Modify files in the Updates and Logs directories of the website folder.
18. Ensure that **Anonymous Authentication** is "**Enabled"** on the website.

![Graphical user interface, application](<../../.gitbook/assets/7 (1).png>)

19. Open the “**appSettings.json**” file located in the “**Config**” directory of the `generate.web` application folder.

{% hint style="info" %}
To retain proper formatting, Notepad++ is recommended over Notepad or Wordpad.
{% endhint %}

20. Replace the values of the SQL Server Connection String keys with values appropriate for the installed environment.

```
{
“AppSettings”: {
“Environment”: “production”,
“ProvisionJobs”: false,
“ADDomain”: “ETSS.local”,
“ADLoginDomain”: “ETSS”,
“ADPort”: “389”,
“ADContainer”: “CN=Builtin,DC=ETSS,DC=local”,
“UserContainer”: “CN=Users,DC=ETSS,DC=local”,
“ReviewerGroupName”: “CN=Users,CN=Builtin,DC=ETSS,DC=local”,
“AdminGroupName”: “CN=Administrators,CN=Builtin,DC=ETSS,DC=local”,
“BackgroundUrl”: “http://192.168.1.2”,
"BackgroundAppPath": "D:\\Apps\\generate.background"
},
"Data": {
"AppDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;trustServerCertificate=true;MultipleActiveResultSets=true;",
"ODSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;trustServerCertificate=true;MultipleActiveResultSets=true;",
"RDSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;trustServerCertificate=true;MultipleActiveResultSets=true;Connect Timeout=300;"
}
}
```

{% hint style="info" %}
The SQL Connection String should be the same for all three connections.
{% endhint %}

21. If the connection string contains a backslash (\\), it should be escaped with an additional backslash to retain proper JSON syntax.

### Background Application

22. Please ensure that the Application Initialization Module for IIS was installed as part of [step 10](./#web-server-1) of the installation instructions.
23. Extract contents of “**generate.background\_x.x.zip**” into a temporary directory.
24. Copy the “**generate.background\_x.x**” folder into a location where you want your background application files to reside.
25. In IIS, create a website called “**generate.background**” and physical path to the location of the background application files. Leave the application pool set to a new pool called “**generate. background**”. Adjust the IP Address, Port, and/or Host name as needed for your environment (as mentioned in the Web Server installation steps).

![Graphical user interface, application](<../../.gitbook/assets/9 (1).jpeg>)

26. Edit the “**Advanced Settings**” of the **generate.background** website and make sure the following property is set:

> **Preload Enabled** = <mark style="color:blue;">**True**</mark>

![Graphical user interface, text, application, email](../../.gitbook/assets/10.jpeg)

27. Edit the “**Advanced Settings**” of the **generate.background** application pool and make sure the following properties are set:

> **.NET CLR Version** = <mark style="color:blue;">**v4.0**</mark>
>
> **Start Mode** = <mark style="color:blue;">**AlwaysRunning**</mark>
>
> **Idle Time-Out (minutes)** = <mark style="color:blue;">**0**</mark>

![Graphical user interface, application, table](../../.gitbook/assets/11.jpeg)

28. Make sure that the Application Pool Identity user account used by this website has permission to Create and Modify files in the Updates and Logs directories of the application folder.
29. Ensure that **Anonymous Authentication** is "**Enabled"** on the website.
30. Open the “**appSettings.json**” file located in the **generate.background** application folder.

{% hint style="info" %}
To retain proper formatting, Notepad++ is recommended over Notepad or Wordpad.
{% endhint %}

31. Replace the values of the SQL Server Connection String keys with values appropriate for the installed environment.

```sql
{
"AppSettings": {
"Environment": "production",
"WebAppPath": "D:\\Apps\\generate.web"
},
"Data": {
"HangfireConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
"AppDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=3600;",
"ODSDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;",
"RDSDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;"
}
}
```

The SQL Connection String should be the same for all four connections.

32. If the connection string contains a backslash (\\), it should be escaped with an additional backslash to retain proper JSON syntax.
33. Replace the value of the **WebAppPath** key with a value appropriate for the installed environment. This should be the physical path of the **generate.web** application files (specified in [step 13](./#web-application) of the Web Application installation steps).

```sql
{
"AppSettings": {
"Environment": "production",
"WebAppPath": "D:\\Apps\\generate.web"
},
"Data": {
"HangfireConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
"AppDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=3600;",
"ODSDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;",
"RDSDbContextConnection": "Server=192.168.1.1;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;"
}
}
```

34. Save and Close the “**appSettings.json**” file for **generate.background**.
35. Open the “**appSettings.json**” file located in the “**Config**” directory of the **generate.web** application folder. Replace the value of the **BackgroundUrl** and **BackgroundAppPath** keys with values appropriate for the installed environment. If these keys do not exist in the .json file, please add them.&#x20;
    * **BackgroundUrl** refers to the URL of the **generate.background** application.
    * **BackgroundAppPath** refers to the physical path of the **generate.background** application files (specified in [step 25](./#background-application) of the Background Application installation steps).

```sql
{
"AppSettings": {
"Environment": "production", "ProvisionJobs": false, "ADDomain": "ETSS.local", "ADLoginDomain": "ETSS", "ADPort": "389",
"ADContainer": "CN=Builtin,DC=ETSS,DC=local", "UserContainer": "CN=Users,DC=ETSS,DC=local", "ReviewerGroupName": "CN=Users,CN=Builtin,DC=ETSS,DC=local",
"AdminGroupName": "CN=Administrators,CN=Builtin,DC=ETSS,DC=local", "BackgroundUrl": "http://192.168.1.2",
"BackgroundAppPath": "D:\\Apps\\generate.background"
},
"Data": {
"AppDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
"ODSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;",
RDSDbContextConnection": "Server=192.168.01.01;Database=generate;User ID=generate;Password=xxxxxxxxxxx;MultipleActiveResultSets=true;Connect Timeout=300;"
}
}
```

### Permission Changes

For the Auto-Update functionality of Generate to work properly, you must ensure that the following permissions are set on the **generate.web** and **generate.backgound** directories:

* The Application Pool Identity user account used by the **generate.background** site, must have Create and Modify permissions on the entire **generate.web** application directory.
* The Application Pool Identity user account used by the **generate.web** site, must have Create and Modify permissions on the entire **generate.background** application directory.

### Active Directory (AD)

Generate makes use of Active Directory (AD) for authentication and authorization. If an existing installation of AD is not available, Active Directory Lightweight Directory Services (AD LDS) may be installed. For those instructions, please see the AD LDS instructions in the [Optional Installations](optional-installations.md#active\_directory\_lightweight\_directory\_s) section.

The AD settings for Generate are configured in the “**appsettings.json**” file located in the “**Config**” folder of the web application directory. Please see the following for the configuration settings.

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
"AdminGroupName": "CN=Administrators,CN=Builtin,DC=ETSS,DC=local", "BackgroundUrl": "http://192.168.1.2",
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

> 1. **Administrators**
> 2. **Reviewers**

Both AD roles must be configured in the AD instance and accessible by Generate. User access is provisioned via normal AD tools by adding or removing these roles to or from the desired users.

### Final Steps

1. Start up the web application in IIS.
2. Open the website in a web browser to confirm that it loads properly.

{% hint style="warning" %}
Generate is optimized for Chrome, do not use Internet Explorer.
{% endhint %}

![Graphical user interface](../../.gitbook/assets/14.jpeg)
