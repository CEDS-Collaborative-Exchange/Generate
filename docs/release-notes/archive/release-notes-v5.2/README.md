---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 5.2 released in December 2022.
coverY: 0
---

# Release Notes 5.2

### RELEASE OVERVIEW&#x20;

Generate 5.2 requires some additional steps that must be performed prior to performing the Generate upgrade. Below are the instructions for performing the update.

#### Step 1: **Verify Your Web Environments are Running ASP.NET Core 6.0:**&#x20;

{% hint style="warning" %}
IMPORTANT: Generate 5.2 has been upgraded to ASP.NET Core 6.0. Please verify your web environments are running **ASP.NET Core 6.0** before installing Generate 5.2.&#x20;
{% endhint %}

ASP.NET Core 6.0 Runtime Hosting Bundle download link:

{% embed url="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-6.0.11-windows-hosting-bundle-installer" %}

#### Step 2: Update Connection Strings:&#x20;

Prior to updating to Generate version 5.2, the state will need to update the connection strings in their **appSettings.json** file in both **\web\config** and **\background**. These files are located on the webserver where Generate was installed.&#x20;

In those files, there is a “Data” parameter that holds the connection string information. Add the following to each connection string, as noted below:&#x20;

{% hint style="info" %}
NOTE: There may be an additional connection string for`‘StagingDBContextConnection”`. If so, the new parameter needs to be added to that string as well.
{% endhint %}

`"Data": { "AppDbContextConnection": "Server=192.168.01.01; Database=generate; User ID=generate;Password=xxxxxxxxxxx; trustServerCertificate=true; MultipleActiveResultSets=true;", "ODSDbContextConnection": "Server=192.168.01.01; Database=generate; User ID=generate; Password=xxxxxxxxxxx; trustServerCertificate=true; MultipleActiveResultSets=true;", "RDSDbContextConnection": "Server=192.168.01.01; Database=generate; User ID=generate; Password=xxxxxxxxxxx; trustServerCertificate=true; MultipleActiveResultSets=true; Connect Timeout=300;" }`&#x20;

#### Step 3: Perform the Generate Update&#x20;

As for typical Generate updates, backup the Generate database, web files, and background files, then log into the Generate UI and perform the update.

#### State ETL changes:&#x20;

There is a new staging validation process added as part of version 5.2. It is driven by individual rules written to validate common data issues that would impact the results loaded into the final reports. It is a standalone process that does not, in any way, impact how a state currently migrates data for any report. If a state wants to leverage this process, the validation routine can be executed separately after the staging ETL has been successfully executed. The results are stored in a separate table with all the relevant information needed to research those records. A more detailed explanation of the process and how to use it can be found here in the [Generate Staging Validation](https://ciidta.communities.ed.gov/api/ApplicationMedia/GetDownload/109927) document.

{% file src="../../../.gitbook/assets/generatestagingvalidationdocument.docx" %}
Generate Staging Validation
{% endfile %}

### GENERATE ENHANCEMENTS&#x20;

The following EDFacts reports were updated in this release.

#### Type of Impact:&#x20;

* **Data** – the changes will improve data quality and completeness
* **User Interface** – the changes impact the Generate User Interface and/or migration process
* **Source to Staging ETL** – the changes may require modifications to the SEA’s Source to Staging ETL
* **Performance** – the changes improve the performance of a data migration
* **Migration** – the changes impact a data migration process
* **Submission Files** – the changes may impact submission file(s)
* **Database** – changes to the Generate database structure

<table><thead><tr><th width="125">Category</th><th width="118">Report</th><th width="239">Approved Change</th><th width="119">Reference</th><th>Type of Impact</th></tr></thead><tbody><tr><td>Child Count Exiting</td><td><p>FS002 </p><p>FS089 </p><p>FS009</p></td><td>Child Count / Exiting / Title III - Handle Multiple records for a person in Person Race during Staging-to-RDS migrations</td><td>CIID-5128</td><td>Staging to RDS Migration</td></tr><tr><td>Discipline</td><td><p>FS005 </p><p>FS006 </p><p>FS007 </p><p>FS088 </p><p>FS143 </p><p>FS144</p></td><td>Discipline - Handle Multiple records for a person in Person Race during Staging-to-RDS migrations</td><td>CIID-5126</td><td>Staging to RDS Migration</td></tr><tr><td>Directory</td><td>FS029</td><td><p>Resolved "Prior ID" is loading incorrectly from IDS </p><p></p><p>Resolved Get_OrganizationReportData - joins return multiple rows from the dimension tables Resolved closed schools are missing </p><p></p><p>Reconstituted and Charter School Status on Submission File Resolved date handling for DimLeas and DimK12Schools </p><p></p><p>Removed IsApproverAgency column and the supporting logic</p></td><td><p>CIID-4060 </p><p>CIID-4680 </p><p>CIID-4731 </p><p>CIID-5144 </p><p>CIID-4678</p></td><td>Data</td></tr><tr><td>Grades Offered</td><td>FS039</td><td><p>FS039 Grades Offered – developed a process for deleting data from the RDS for Grades Offered FS039 Grades </p><p></p><p>Offered – resolved Grade list is empty even when data is populated in the database FS039 Grades Offered – resolved </p><p></p><p>Staging.OrganizationGradeOffered has the wrong metadata for the GradeOffered column FS039 </p><p></p><p>Grades Offered – resolved new staging to RDS for LEAs and Schools joins incorrectly</p></td><td><p>CIID-4865 </p><p>CIID-3954 </p><p>CIID-4019 </p><p>CIID-5029</p></td><td>Data</td></tr><tr><td>General</td><td></td><td>Standardized the name of the Source to Staging ETL stored procedures for future development.in internal Generate testing databases (no state action required).</td><td>CIID-5123</td><td>Source to Staging ETL</td></tr><tr><td></td><td></td><td>Resolved Staging-to-DimK12Schools, Staging-to-DimLeas, and Staging-to-DimSeas duplicating records based on join to Organization Types and Organization Location Type in Source System Reference Data</td><td>CIID-5131</td><td>Source to Staging ETL</td></tr><tr><td></td><td></td><td>Updated RDS Wrapper Scripts to use new Staging-to-DimSeas, Staging-to-DimLeas, Staging-to-DimK12Schools</td><td>CIID-5025</td><td>Migration</td></tr><tr><td></td><td></td><td>Corrected Staging-to-Fact Discipline issues and improved migration performance.</td><td>CIID-5053</td><td>Performance</td></tr><tr><td></td><td></td><td>Add automatic rollover of SourceSystemReferenceData mappings for a new School Year to Staging to RDS migrations</td><td>CIID-5189</td><td>Migration</td></tr></tbody></table>

### GENERAL SECTION

<table><thead><tr><th width="127">Category</th><th width="115">Software</th><th width="244">Approved Change</th><th width="114">Reference</th><th>Type of Impact</th></tr></thead><tbody><tr><td>Upgrade</td><td>ASP.NET</td><td>Upgrade Generate from 3.1 .Net Core to 6.0 .Net Core</td><td>CIID-4898</td><td>Performance</td></tr></tbody></table>

### UPGRADE PROCEDURE&#x20;

Generate 5.2 has been upgraded to ASP.NET Core 6.0. Please verify your web environments are running ASP.NET Core 6.0 before installing Generate 5.2. Make the necessary changes to the AppSettings.json files as defined in the Overview section. Then, follow the standard Generate upgrade process to install version 5.2.

### COMPATIBLE SYSTEMS&#x20;

Generate was tested on the following operating systems and browsers:

* &#x20;Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)
