---
icon: memo
description: >-
  This document describes the technical enhancements to Generate version 11.3
  released in February 2024. The purpose of this document is to communicate the
  technical updates made to Generate in version.
cover: ../../.gitbook/assets/Generate Release 11.3 Gitbook page banner.png
coverY: -36
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

# Release Notes 11.3

## Release Overview

Generate version 11.3 is primarily focused on **Directory**, small user interface changes, and NodeJS updates. We also added the hotfix changes from the last round of Assessment submissions and Discipline views (emailed 2/5) to this release.

### Required State Changes

For states that do not have internet access from their Generate server, we have modified the Update logic so that you can leverage the auto-update process, with two manual steps.

1. You will receive an update package from us. When you do:
   * Upload it to the **`/Updates`** folder found within both the **`/web`** and **`/background`** directories on your web server.
2. Open the configuration file and change the “**`callservice`**” setting to <mark style="color:red;">**`false`**</mark>.
   * On your webserver, navigate to the location of the **`/web`** files and then go to **`/wwwroot/assests/config`**

{% hint style="info" %}
**NOTE**: There may be more than one file in that location depending on how you installed/configured Generate. Make the change to any config files in that location.&#x20;
{% endhint %}

Run the update process from the UI as normal.&#x20;

### Important Updates

The below items do **NOT** require state action, but we wanted to bring your attention to:

* If you are submitting Directory (FS029) through Generate and you run into an issue creating a csv submission file because there are commas in the incoming data, we have an open ticket to address escaping the commas. That work is not complete so if you do experience that issue you can either remove the commas from the incoming data or create a TAB delimited submission file.  &#x20;
* We added a new Staging Table Snapshot utility. The documentation for this utility is available here -  [staging-table-snapshot.md](../../developer-guides/generate-utilities/staging-table-snapshot.md "mention")
* We now have a new way of displaying report data in the User Interface that will help us in promoting Generate to the Source Community. The new method is currently applied to most student-level reports only. The look and feel are slightly different, and we will be working on the next release making to make it faster as well. There is a new search feature will allow you to search for elements to filter to leverage for your data analysis. Turn on the search feature by selecting “Search” and then use categories to set filters.

**How to Use the New Search Feature**

1. Activate the search functionality by selecting the **“Search”** option.

<figure><img src="../../.gitbook/assets/Release Notes 11.3_Search button highlight.png" alt="Screenshot of the EDFacts Submission Report UI, featuring a table of data. An arrow points to the search checkbox, highlighting its functionality within the interface."><figcaption><p>Select the search box to view the filters</p></figcaption></figure>

2. Utilize categories to set filters, narrowing down your analysis to the most relevant data.

<figure><img src="../../.gitbook/assets/image (208).png" alt="Screenshot of filter options for SEA (State Education Agency), SEA ID, Disability Category, Sex, and Racial Ethnic fields."><figcaption><p>Filter options displayed for SEA, SEA ID, Disability Category, Sex, and Racial Ethnic fields, facilitating refined data selection within the interface.</p></figcaption></figure>

{% hint style="warning" %}
The **Search** feature is currently case and text specific.&#x20;

**Example:** To filter by **Disability Category**, ensure you input the category name exactly as it appears. For instance, to filter for **Deaf-blindness**, type it with the capital 'D', the dash, and the lowercase 'b'.
{% endhint %}

<figure><img src="../../.gitbook/assets/image (206).png" alt="A computer screen displaying a table with filtered results. A red box highlights the &#x27;Disability Category&#x27; section, with &#x27;Deaf-blindness&#x27; typed in the text input field. The table below shows data filtered to display only &#x27;Deaf-blindness&#x27; category."><figcaption><p>Filtering by Disability Category: Ensure precise input for accurate results.</p></figcaption></figure>

***

### Generate Enhancements &#x20;

The following ED_Facts_ reports were updated in this release.&#x20;

#### Type of Impact:&#x20;

* **Data** – the changes will improve data quality and completeness.&#x20;
* **User Interface** – the changes impact the Generate User Interface and/or migration process.&#x20;
* **Source to Staging ETL** – the changes may require modifications to the SEA’s Source to Staging ETL&#x20;
* **Performance** – the changes improve the performance of the application.&#x20;
* **Migration** – the changes impact a data migration process.&#x20;
* **Submission Files** – the changes may impact submission file(s)&#x20;
* **Database** – changes to the Generate database structure.&#x20;

{% tabs %}
{% tab title="Directory" %}
<table><thead><tr><th width="98">Report</th><th width="316">Approved Change</th><th width="127">Ticket #</th><th>Type of Impact<select><option value="aIrRgPs7pT7d" label="Data" color="blue"></option><option value="kKSj9lp0pb9l" label="Database" color="blue"></option><option value="22jOhF1aGVAS" label="Migration" color="blue"></option><option value="AR3REOfwMyxm" label="Performance" color="blue"></option><option value="OFxKBL4Vme6T" label="Reports" color="blue"></option><option value="f7bU9nAUZat4" label="Submission Files" color="blue"></option><option value="JIPX9Ifn7LnP" label="Source to Staging ETL" color="blue"></option><option value="YFLPhfzv17wC" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS029</td><td>Create delimiter handling for EDFacts Report Exports</td><td>CIID-2627</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>The column lengths for the Organization Address fields were different between staging and the RDS. We added code to ensure there are no issues with the migrations while we look at structural changes to permanently address it.</td><td>CIID-5241</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>We corrected the date-handling logic in Staging-to-FactOrganizationCounts so that it can handle multiple LEAs when some of them are future dated.</td><td>CIID-5731</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>The logic used in the migration of LEA data to determine whether to use NA or NOTCHR for the LEA Charter Status was incorrect, that has been corrected</td><td>CIID-6462</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>Corrected an issue in the code that was preventing Charter Primary and Secondary Authorizer data from displaying in the UI and in the submission file.</td><td>CIID-6484</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>Corrected a mapping issue that was preventing Charter School Authorizer Type Codes from migrating into the Data Warehouse with the proper values</td><td>CIID-6468</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td></td><td>Corrected the PV for GunFreeSchoolsActReportingStatusCode because it was displaying the dimension code value, not the EDFacts code in the UI and the submission file</td><td>CIID-6467</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td>FS163</td><td>Corrected the PV for GunFreeSchoolsActReportingStatusCode because it was displaying the dimension code value, not the EDFacts code in the UI and the submission file</td><td>CIID-6467</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr><tr><td>FS116</td><td>Corrected an issue in the Directory export that was excluding Prior LEA Identifier, Effective Date, and Updated Operational Status.</td><td>CIID-3963</td><td><span data-option="aIrRgPs7pT7d">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Assessment " %}
<table><thead><tr><th width="98">Report</th><th width="327">Approved Change</th><th width="117">Ticket #</th><th>Type of Impact<select><option value="5F3rtp88NRMi" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS175 </p><p>FS178 <br>FS179 </p><p>FS185 </p><p>FS188 </p><p>FS189 </p></td><td>Added a Toggle setting to allow states to report combined results for Asian and NativeHawaiianorOtherPacificIslander as a single Major Race Category of “MAP”.</td><td>CIID-5973</td><td><span data-option="5F3rtp88NRMi">Data</span></td></tr><tr><td></td><td>The Assessment logic was not correctly handling English Learner participation, ‘PARTELP’, that needs to be included in FS188, that has been corrected.</td><td>CIID-6029</td><td><span data-option="5F3rtp88NRMi">Data</span></td></tr><tr><td> </td><td>Corrected an issue in the race handling logic that was excluding Hispanic students in Private Schools from Reports</td><td>CIID-6043</td><td><span data-option="5F3rtp88NRMi">Data</span></td></tr><tr><td></td><td>Updated this release with the Assessment hotfix changes discovered after the 11.2 release to update the order of the logic to apply Medically Exempt and English Learner Participation</td><td>CIID-6048</td><td><span data-option="5F3rtp88NRMi">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Discipline " %}
<table><thead><tr><th width="100">Report</th><th width="296">Approved Change</th><th width="110">Ticket #</th><th>Type of Impact<select><option value="1KTv97vBREme" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS005</td><td>Updated the report creation logic when there is no age selected in Toggle for Developmental Delay (Child Count) to interpret that selection as a state not using Developmental Delay and excluding DD from any zero counts.</td><td>CIID-4793</td><td><span data-option="1KTv97vBREme">Data</span></td></tr><tr><td><p>FS005 FS006</p><p>FS007 FS088 FS143 FS144</p></td><td>Caught during our internal testing for this release, there was a change to the metadata, and Discipline data was not populating on the UI screen but still showed in the submission file. There was one additional metadata script that needed to be included in the update package that resolved that issue.</td><td>CIID-6453</td><td><span data-option="1KTv97vBREme">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Child Count " %}
<table><thead><tr><th width="98">Report</th><th width="310">Approved Change</th><th width="114">Ticket #</th><th>Type of Impact<select><option value="1FfC7v5SdxVI" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td><p>FS002 </p><p>FS089 </p></td><td>Corrected an issue in 2 scripts to create appropriate zero counts in the LEA and SCH files.</td><td>CIID-6021</td><td><span data-option="1FfC7v5SdxVI">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Immigrant" %}
<table><thead><tr><th width="98">Report</th><th width="243">Approved Change</th><th>Ticket #</th><th>Impact<select><option value="CeG8lWK2x2LV" label="Performance" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS045</td><td>One of the scripts that handles the report creation logic did not include the Immigrant Dimension definition and primary key, that has been corrected.</td><td>CIID-6444</td><td><span data-option="CeG8lWK2x2LV">Performance</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Title III " %}
<table><thead><tr><th width="98">Report</th><th width="319">Approved Change</th><th width="112">Ticket #</th><th>Type of Impact<select><option value="4hDWMFlfhzbu" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS116 </td><td>Our internal automated collection of updated metadata did not contain the updates for FS116 so we manually pulled that data and added it to the script that will update the metadata for this release.</td><td>CIID-6445</td><td><span data-option="4hDWMFlfhzbu">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="Staff" %}
<table><thead><tr><th width="98">Report</th><th>Approved Change</th><th>Ticket #</th><th>Type of Impact<select><option value="afQB8cuGA0PG" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS070 FS099 FS112</td><td>Updated the Age Group Taught Permitted Values in the category Age Group to the new more detailed descriptions, AGE3TO5NOTK and AGE5KTO21.</td><td>CIID-5923</td><td><span data-option="afQB8cuGA0PG">Data</span></td></tr><tr><td>FS112</td><td>Corrected a metadata issue that was preventing Paraprofessional Qualification Status from showing in the UI or submission file</td><td>CIID-6479</td><td><span data-option="afQB8cuGA0PG">Data</span></td></tr></tbody></table>
{% endtab %}

{% tab title="General " %}
<table><thead><tr><th width="98">Report</th><th width="356">Approved Change</th><th width="116">Ticket #</th><th>Type of Impact<select><option value="WVE9cispXeL6" label="User Interface" color="blue"></option><option value="zhiKtDTm2C5x" label="Migration" color="blue"></option><option value="a7f0HQKOtBQA" label="Performance" color="blue"></option><option value="hA7FUIQIujdf" label="Data" color="blue"></option></select></th></tr></thead><tbody><tr><td></td><td>The join logic in the debug view vwStudentDetails was not displaying the LEA Operational Status for non-Federally reported schools. That is now corrected.</td><td>CIID-6044</td><td><span data-option="hA7FUIQIujdf">Data</span></td></tr><tr><td>FS045</td><td>Adjusted the width of the ‘Migration Date’ and ‘Message’ sections of the log on the migration screens to eliminate unneeded space for the date so more of the message text is visible in the preview window.</td><td>CIID-6011</td><td><span data-option="zhiKtDTm2C5x">Migration</span></td></tr><tr><td></td><td>The name of the new Source migration scripts, Source-to-Staging_ChildCount for example, was causing an issue when executed through the UI. We added brackets [] around the names in the table that stores them so SQL will execute them without error.</td><td>CIID-6430</td><td><span data-option="WVE9cispXeL6">User Interface</span></td></tr><tr><td></td><td>Verified the SPR/APR Submission reports Indicator 4A, 4B, 9 and 10 are working as expected.</td><td>CIID-5772</td><td><span data-option="zhiKtDTm2C5x">Migration</span></td></tr><tr><td></td><td>Expanded the auto-upgrade feature for states with no internet access from their server.</td><td>CIID-5999</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr><tr><td></td><td>As detailed in the Important Updates section above, this is the ticket where we are replacing the library that handles the display of report data in the UI with one that will help us promote Generate to the Open-Source Community.</td><td>CIID-6003</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr><tr><td></td><td>Updated the Metadata for DATA POPULATION SUMMARY Reports.</td><td>CIID-6004</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr><tr><td></td><td>As referred to in the Important Updates section, we created a new utility to create snapshots of the staging tables as needed. There is a documentation link above as well.</td><td>CIID-6013</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr><tr><td></td><td>Corrected the logic that resets the RecordEndDateTime in both Staging-to-DimPeople_K12Staff and Staging-to-DimPeople_K12Students to accurately record start and end dates for longitudinal logic.</td><td>CIID-6045</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr><tr><td></td><td>We have scheduled security scans that run against all the Generate software and based on the latest run we updated NodeJS &#x26; child dependencies.</td><td>CIID-5981</td><td><span data-option="a7f0HQKOtBQA">Performance</span></td></tr></tbody></table>
{% endtab %}
{% endtabs %}

### Upgrade Procedure&#x20;

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 11.3.

### Compatible Systems &#x20;

Generate was tested on the following operating systems and browsers: &#x20;

* [x] Windows 10 Pro
* [x] Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

***

## Office Hour

{% embed url="https://youtu.be/4UbMWUf8LH4" %}
Generate 11.3 Office Hour Recording
{% endembed %}
