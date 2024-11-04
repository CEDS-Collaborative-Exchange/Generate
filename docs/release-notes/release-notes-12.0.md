---
icon: memo
description: >-
  This document describes the technical enhancements to Generate version 12.0
  released September 18, 2024.
cover: ../.gitbook/assets/Generate 12.0 Release Notes cover.png
coverY: 0
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# Release Notes 12.0

## Release Overview

Generate version 12.0 is focused on the Assessment files, file specifications FS175, FS178, FS179, FS185, FS188, and FS189 due for submission to EDPass January 8, 2025.

### Release Highlights

* **Single Button Migration** - We’ve simplified the migration process in Generate! With a new single-button interface. The migration screen consolidates everything into one place, integrating both the migration log and staging validation results, so you can keep tabs on the entire process with minimal effort. For more details, view the [Data Migration](../user-guide/settings/data-migration.md) guide.
* **OAuth Support** - Generate 12.0 now supports OAuth for both authentication and authorization, giving users an added layer of security and seamless access across systems. Learn how to set up OAuth in your environment by checking out our [OAuth Configuration](../developer-guides/installation/oauth-configuration.md) guide.
* **Installation Updates** - We’ve added the ability to run Generate from a subfolder on your web server, increasing flexibility in deployment configurations. This update simplifies hosting Generate alongside other applications and services. See the [Subfolder Configuration](../developer-guides/installation/subfolder-configuration.md) guide for detailed steps.
* **API Metadata Feature** - The new API Metadata feature lets you retrieve the ED_Facts_ file specification metadata directly from EDPass via an API call. This automation saves time and ensures you’re always working with the most up-to-date specs. Find out how to integrate this feature in the [Configuring Metadata](../developer-guides/installation/configuring-metadata-updates.md) guide and how to run the refresh from the [Metadata](../user-guide/settings/metadata.md) guide.

### Important Updates

* **Generate in the OSC -** We’ve removed the last application dependencies on **Wijmo**, improving Generate’s compatibility within the Open Source Community (OSC) framework. This update not only makes Generate more lightweight but also prepares us for its upcoming transition to an open-source tool on GitHub. With this move, users will soon be able to contribute directly to Generate's development.
* **Migrations -** Improvements have been made to the migration performance for key organization tables—**DimSeas**, **DimLeas**, and **DimK12Schools**—leading to faster and more efficient migrations.&#x20;
* **Generate Utilities**\
  Several Generate utilities have been updated to provide more accuracy and faster processing. These include:
  * **Check\_SourceSystemReferenceData\_Mapping**: Improved mapping validation between source systems.
  * **Cleanup\_Debug\_Tables**: Enhanced functionality for cleaning up debug data more efficiently.
  * **Submission File Comparison Documentation**: Improved tools for comparing submission files.

### Documentation Updates

* **New Fact Type Documentation** - We’ve introduced a new guided documentation page to help users navigate the complete process of generating each set of Fact Type files from start to finish. The first draft focuses on the [Assessment Fact Type](../developer-guides/migration/fact-type-table/assessment-fact-type.md) and serves as a prototype for future Fact Type pages. We're eager to collaborate with the community to refine and improve these pages. At the bottom of the page, you’ll find a feedback form—we encourage you to share your thoughts and suggestions!

### Generate Enhancements

The following ED_Facts_ reports were updated in this release.

#### Type of Impact:

* Data – changes will improve data quality and completeness.
* User Interface – changes impact the Generate User Interface and/or migration process.
* Source to Staging ETL – changes may require modifications to the SEA’s Source to Staging ETL.
* Performance – changes improve the performance of the application.
* Migration – changes impact a data migration process.
* Submission Files – changes may impact submission file(s).
* Database – changes to the Generate database structure.

{% tabs %}
{% tab title="Assessment" %}
<table><thead><tr><th width="103">Report</th><th width="369">Approved Changes</th><th>Ticket #</th><th>Impact<select><option value="LEcBMykNK2wO" label="User Interface" color="blue"></option><option value="PlvFix97YIIc" label="Data" color="blue"></option><option value="SSdnS5L2NVcc" label="Performance" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS175, FS178, FS179, FS 185, FS188, FS189</td><td>Added ability to include ‘HS' as a Grade Level in Assessment files.</td><td>CIID-6030</td><td><span data-option="PlvFix97YIIc">Data</span></td></tr><tr><td>FS175, FS178, FS179, FS185, FS188, FS189</td><td>Corrected an issue to assure that only SEA level Assessment files contain zero counts.</td><td>CIID-6423</td><td><span data-option="PlvFix97YIIc">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Directory" %}
<table><thead><tr><th width="102">Report</th><th width="375">Approved Change</th><th width="117">Ticket #</th><th>Impact<select><option value="bTxddEiSM3OE" label="Performance" color="blue"></option><option value="5wzNrLATNYWj" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS029, FS039</td><td>Cleaned up the population of the State values into the DimLeas, DimK12Schools, DimCharterSchoolAuthorizers, and DImK12CharterSchoolManagementOrganizations tables.</td><td>CIID-7057</td><td><span data-option="bTxddEiSM3OE">Performance</span></td></tr><tr><td>FS029, FS039</td><td>Modified the migration of Organization phone numbers to remove the parentheses and hyphens</td><td>CIID-7072</td><td><span data-option="5wzNrLATNYWj">Data</span></td></tr><tr><td>FS198</td><td>Corrected an issue with the web code to display the Charter Contract ID, Charter Approval Date, and Charter Renewal Date columns in the UI and populate these fields in the submission file.</td><td>CIID-6898</td><td><span data-option="5wzNrLATNYWj">Data</span></td></tr><tr><td>FS129</td><td>Added logic to exclude Reportable Programs and Schools opened after October 1st from the report.</td><td>CIID-6917</td><td><span data-option="5wzNrLATNYWj">Data</span></td></tr><tr><td>FS129</td><td>Updated the metadata for FS129 to populate Shared Time Status, Virtual School Status, and NSLP Status, excluding Magnet School Status.</td><td>CIID-6918</td><td><span data-option="5wzNrLATNYWj">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Discipline" %}
<table><thead><tr><th width="99">Report</th><th width="373">Approved Change</th><th>Ticket #</th><th>Impact<select><option value="mVYPmkn8fP2X" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS086</td><td>Corrected an issue in the view that supports the IDEA Firearms Discipline data that was preventing it from migrating to the RDS level.</td><td>CIID-7005</td><td><span data-option="mVYPmkn8fP2X">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Exiting" %}
<table><thead><tr><th>Report</th><th width="342">Approved Changes</th><th>Ticket</th><th>Impact<select><option value="uA05VudK0rwm" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS009</td><td>Enhanced Toggle questions for Exiting to match EDPass questions regarding Diplomas. Separated the Toggle Question for “Regular High School Diplomas” into two questions: Alternate Diploma and Certificates.</td><td>CIID-5657</td><td><span data-option="uA05VudK0rwm">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Graduation" %}
<table><thead><tr><th>Report</th><th width="346">Approved Changes</th><th>Ticket #</th><th>Impact<select><option value="urg5cru8X3F0" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS150 FS151</td><td>We added CohortGraduationYearId and CohortYearId to FactK12StudentCounts to support FS150 and FS151.</td><td>CIID-6491</td><td><span data-option="urg5cru8X3F0">Data</span></td></tr><tr><td>FS150 FS151</td><td>We modified the RDS and Report migrations to support the new data elements that were added to FactK12StudentCounts to support FS150 and FS151.</td><td>CIID-6506</td><td><span data-option="urg5cru8X3F0">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Homeless" %}
<table><thead><tr><th>Report</th><th width="338">Approved Change</th><th>Ticket #</th><th>Impact<select><option value="Aenbq3YtSlAW" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS118</td><td>Corrected an aggregation count issue.</td><td>CIID-4771</td><td><span data-option="Aenbq3YtSlAW">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Membership" %}
<table><thead><tr><th>Report</th><th width="318">Approved Changes</th><th width="127">Ticket #</th><th>Impact<select><option value="h3TiNehwWuZ8" label="Data" color="blue"></option><option value="1nCnRkWhqGjg" label="Performance" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS033 FS052</td><td>The exclusion of Reportable Programs from the school level counts was added to our count logic but not to the zero count logic so we had to update that code to create the appropriate zero count rows.</td><td>CIID-6941</td><td><span data-option="h3TiNehwWuZ8">Data</span></td></tr><tr><td>FS052</td><td>We recently added code to handle the creation of the submission file more efficiently because the file size is very large at the school level. We corrected an issue in that new code that was causing the header row to repeat every 100k rows.</td><td>CIID-6984</td><td><span data-option="1nCnRkWhqGjg">Performance</span></td></tr><tr><td>FS033, FS052</td><td>We updated the zero count logic to exclude Schools with no students reported in FS052.</td><td>CIID-7017</td><td><span data-option="h3TiNehwWuZ8">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Staff" %}
<table><thead><tr><th>Report</th><th width="358">Approved Changes</th><th>Ticket #</th><th><select><option value="CvKe5CR3nTmB" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>SF070, SF099, SF112, SF059</td><td>Added some additional error handling on the FTE value in the Staging to RDS code when NULL values come in.</td><td>CIID-6969</td><td><span data-option="CvKe5CR3nTmB">Data</span></td></tr><tr><td>FS059</td><td>Modified the report population logic for FS059 - Staff FTE to only include Teachers in the counts at the School level.</td><td>CIID-7020</td><td><span data-option="CvKe5CR3nTmB">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="General" %}
<table><thead><tr><th width="456">Approved Changes</th><th width="131">Ticket #</th><th>Impact<select><option value="zpOngjoghtfS" label="User Interface" color="blue"></option><option value="R3dAx1XZaJLv" label="Performance" color="blue"></option><option value="bsoQd3Vh5wKE" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>Made enhancements to <strong>debug.vwStudentDetails</strong> to help with troubleshooting data issues.</td><td>CIID-6481</td><td><span data-option="bsoQd3Vh5wKE">Data</span></td></tr><tr><td>Incorporated all of the Generate v11.4 changes into v12</td><td>CIID-6981</td><td><span data-option="bsoQd3Vh5wKE">Data</span></td></tr><tr><td>Updated the Utilities to the latest table/column names</td><td>CIID-7066</td><td><span data-option="bsoQd3Vh5wKE">Data</span></td></tr><tr><td>We replaced the <strong>Wijmo</strong> library in Toggle, Calendar display and selection, and the report detail view in the grid.</td><td>CIID-6475</td><td><span data-option="zpOngjoghtfS">User Interface</span></td></tr><tr><td>We expanded Hydrate (our internal test data creation tool) to produce 2 years' worth of data for the same set of test students.</td><td>CIID-6515</td><td><span data-option="R3dAx1XZaJLv">Performance</span></td></tr><tr><td>In a previous release we removed the generic ‘submission’ fact type and created the specific fact types Discipline, Assessment, and Staff. We also created a metadata table the relates the Fact Types to the ED<em>Facts</em> reports that they support and updated the code to use the new metadata,</td><td>CIID-6525</td><td><span data-option="bsoQd3Vh5wKE">Data</span></td></tr><tr><td>Corrected an issue with Reports Migration that was logging unnecessary activities in <strong>DataMigrationHistories</strong>.</td><td>CIID-6943</td><td><span data-option="R3dAx1XZaJLv">Performance</span></td></tr><tr><td>Updated the ‘<strong>Check_SourceSystemReferenceData_Mapping</strong>’ utility to use the new metadata tables that we’ve created to provide a connection between Generate Report and Fact Type</td><td>CIID-6948</td><td><span data-option="R3dAx1XZaJLv">Performance</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

### Upgrade Procedure

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 12.0.

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

## Generate 12.0 Office Hour

{% embed url="https://youtu.be/zfGtirLFB4c" %}
