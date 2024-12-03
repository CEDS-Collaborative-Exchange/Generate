---
icon: memo
description: >-
  This document describes the technical enhancements to Generate version 12.1
  released November 1, 2024.
---

# Release Notes 12.1

Release Overview

Generate version 12.1 focuses on EDPass submissions due **January 8, 2025**, specifically enhancing reporting and compatibility for assessment files **FS175**, **FS178**, **FS179**, **FS185**, **FS188**, and **FS189**. Key upgrades include .NET framework updates, streamlined data processing, and expanded test capabilities.

### Required State Changes

#### 🚨 Important .NET update

In Generate 12.1, we’re updating the .NET Core runtime from version 6.0 to 8.0, as support for 6.0 is ending. Use the link below to download the compatible [**ASP.NET Core Runtime 8.0.10**](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) version for your environment.

{% embed url="https://dotnet.microsoft.com/en-us/download/dotnet/8.0" %}
Link to download .Net 8.0
{% endembed %}

{% hint style="info" %}
NOTE: The server can support multiple versions of .NET at the same time so you can install the newer version prior to upgrading and without removing older versions.
{% endhint %}

***

#### Assessments

We added the ability in version 12.1 to support the reporting of ‘HS’ as the grade level. In order to do that these are the considerations to be aware of.

1. The Assessment needs to be added/modified with HS selected as the Grade Level. If you are updating existing assessments to use ‘HS’ you would remove the versions of that assessment with Grade Level in 9, 10, 11, or 12. After logging in, from the gear icon, select Toggle. When that page loads select ‘Assessments’ to add or modify State assessment information.

<figure><img src="../.gitbook/assets/Release Notes 12.1_Assessments update v2 (1).png" alt="Screenshot of the Generate application interface showing the &#x22;Toggle&#x22; settings page. The &#x22;Assessments&#x22; option is highlighted on the left side, where users can add or modify State assessment information."><figcaption><p>To add or modify State assessment information for the new "HS" grade level in version 12.1, navigate to "Settings" and select "Toggle," then click on "Assessments."</p></figcaption></figure>

2. When loading the student assessment data into `Staging.AssessmentResult` for those assessments, set the `GradeLevelWhenAssessed` value as ‘HS’.
3. Add the following mapping to the `Staging.SourceSystemReferenceData` table to translate the value correctly.

```sql
INSERT INTO Staging.SourceSystemReferenceData
VALUES (2024, 'RefGradeLevel', '000126', 'HS', 'HS');
```

***

#### Staging Table Update

In Generate v12.1, the field `K12Organization.School_TitleIPartASchoolDesignation` has been renamed to `K12Organization.School_TitleISchoolStatus`. This change may impact any State ETLs that populate `Staging.K12Organization` or any Snapshot processes that reference the `Staging.K12Organization` table. Please review your ETL processes and Snapshot configurations to ensure compatibility with this update.

***

### Enhancements

#### New Testing Capabilities

In Generate 12.1, we have enhanced our testing processes by expanding unit and file specification testing and integrating with EDPass for a streamlined test environment. This integration allows us to validate submission files, verify upload functionality, and conduct data quality checks prior to submission windows, thereby ensuring the reliability and accuracy of Generate’s file specifications.

### Documentation Updates

[GitHub Guide:](../developer-guides/github-guide.md) This guide provides an overview of working with the Generate GitHub repository. It covers essential steps for accessing the repository, forking and cloning the codebase, submitting pull requests, and reporting issues. This resource is designed to help both new and experienced contributors get involved in the development process and collaborate on Generate’s open-source evolution.

[Azure Installation Guide: ](../developer-guides/installation/azure-installation-guide.md)The new installation guide offers step-by-step instructions for setting up Generate in an Azure environment. It includes guidance on configuring necessary Azure resources, optimizing system performance, and ensuring security within the cloud setup. This guide will streamline the installation process for users aiming to leverage Azure for hosting Generate.

### Generate Enhancements

The following E&#x44;_&#x46;acts_ reports were updated in this release.

#### Type of Impact:

* Data – changes will improve data quality and completeness.
* User Interface – changes impact the Generate User Interface and/or migration process.
* Source to Staging ETL – changes may require modifications to the SEA’s Source to Staging ETL.
* Performance – changes improve the performance of the application.
* Migration – changes impact a data migration process.
* Submission Files – changes may impact submission file(s).
* Database – changes to the Generate database structure.

<table><thead><tr><th width="136">Report #</th><th width="142">Report</th><th width="275">Change</th><th width="121">Ticket</th><th>Impact<select><option value="fiRQXDTuvxUH" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>175 178 179 185 188 189</td><td>Assessment</td><td>Added ability to include ‘HS' as a Grade Level in Assessment files.</td><td>CIID-6030</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>175 178 179 185 188 189</td><td>Assessment</td><td>We added 2 columns to <code>Staging.AssessmentResult</code> and added Disability Type to the data that is loaded into the Fact table during migrations to support xxx (need to fill this in)</td><td>CIID-7166</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>039</td><td>Directory</td><td>Corrected the population of Grades Offered in the submission file for an LEA when the only schools in that LEA are Reportable Programs.</td><td>CIID-6904</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>029</td><td>Directory</td><td>Cleaned up the population of the State values into the <code>DimLeas</code>, <code>DimK12Schools</code>, <code>DimCharterSchoolAuthorizers</code>, and <code>DImK12CharterSchoolManagementOrganizations</code> tables.</td><td>CIID-7057</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>195</td><td>Chronic Absenteeism</td><td>Added the dimension table and primary key setup for <code>DimDisabilityStatuses</code> to the report migration process.</td><td>CIID-7173</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>195</td><td>Chronic Absenteeism</td><td>Cleaned up the Staging to RDS code and the debug views for Chronic Absenteeism to allow migration of the data to support FS195</td><td></td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr><tr><td>002</td><td>Child Count</td><td>Updated the Staging-to-RDS migration for student and staff data to eliminate the possibility of truncation into <code>rds.DimPeople</code></td><td>CIID-7188</td><td><span data-option="fiRQXDTuvxUH">Data</span></td></tr></tbody></table>

### Upgrade Procedure

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 11.4.

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

### Generate Office Hour

{% embed url="https://youtu.be/L76VpYv0zeA" %}

