---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 5.3 released in February 2023.
---

# Release Notes 5.3

### RELEASE OVERVIEW <a href="#id-3.1.1__impact" id="id-3.1.1__impact"></a>

Generate version 5.3 is a minor release that contains fixes/enhancements primarily focused on the spring file submissions. Additionally, there is a new File Comparison utility that automates the loading and comparison of a state submission file to the same file created in Generate. There is also a new schema called ‘Utilities’ to better group some of the helper processes available in Generate. Detailed documentation on how to use the Utilities in Generate will be available in the Generate Implementation Guide.

**State ETL changes: For Directory files, there are several possible ETL changes required by the States**.

{% hint style="warning" %}
1. `Columns LEA_IsReportedFederally` and `School_IsReportedFederally` in `Staging.K12Organization` are now required to be populated with a value of **1** for LEAs and Schools that are to be **reported in FS029**. If a state loads organizations into staging that are not to be **reported in FS029**, these columns can be populated with **0** or **NULL**.
2. There are two new columns in `Staging.K12Organization` that can be used if needed. These columns are `Prior_LEA_Identifier_State` and `Prior_School_Identifier_State`. These are to be populated in instances where the `LEA_Identifier_State` or `School_Identifier_State` have changed from the previous values. If these are not needed, they may be populated as **NULL**.
{% endhint %}

### GENERATE ENHANCEMENTS

The following E&#x44;_&#x46;acts_ reports were updated in this release.

**Type of Impact:**

* **Data** – the changes will improve data quality and completeness
* **User Interface** – the changes impact the Generate User Interface and/or migration process
* **Source to Staging ETL** – the changes may require modifications to the SEA’s Source to Staging ETL
* **Performance** – the changes improve the performance of a data migration
* **Migration** – the changes impact a data migration process
* **Submission Files** – the changes may impact submission file(s)
* **Database** – changes to the Generate database structure

<table><thead><tr><th width="168">Category</th><th width="153">Report</th><th width="269">Approved Change</th><th width="115">Reference Number</th><th>Type of Impact</th></tr></thead><tbody><tr><td><strong>Child Count</strong></td><td>FS002<br>FS089</td><td><p>Child Count report migration was modified to exclude counts for closed, inactive, and future schools.</p><p></p><p>Allow Child Count files to handle multiple records for a student in <code>PersonRace</code> during Staging-to-RDS migrations.</p></td><td><p>CIID-4780</p><p>CIID-5128</p></td><td>Data</td></tr><tr><td><strong>Discipline</strong></td><td><p>FS005<br>FS006</p><p>FS007</p><p>FS086</p><p>FS143</p></td><td>Modified Discipline Files to handle multiple records for a student in <code>PersonRace</code> during Staging-to-RDS migrations.</td><td>CIID-5126</td><td>Data</td></tr><tr><td><strong>Directory</strong></td><td>FS029 </td><td><p>Retired Chief State School Officer Contact Information (CSSO) in FS029 Directory.</p><p></p><p>Modified the population of the select lists for LEAs and Schools in the UI Report screen to use RDS tables rather than IDS tables to leverage the new staging-to-RDS for Organization data.</p></td><td><p>CIID-5078</p><p>CIID-5243</p></td><td>Data</td></tr><tr><td><strong>Grades Offered</strong></td><td>FS039 </td><td><p>Refined the logic for determining No Grades vs Ungraded based on state feedback and additional discussions about the file specification.</p><p><br>Modified the logic for determining "NOGRADES" vs “UNGRADED” to account for LEAs with no schools that still provide support services.</p></td><td>CIID-5166</td><td>Data</td></tr><tr><td><p><strong>Charter School Authorizer Directory</strong></p><p></p><p><strong>Management Organizations Directory</strong></p></td><td><p>FS190</p><p>FS196</p></td><td><p><br>Added missing metadata for FS190 and FS196.</p><p><br>Missing metadata caused an error creating the Submission Files.<br></p></td><td><p>CIID-4919</p><p>CIID-4870</p></td><td>Data</td></tr><tr><td><strong>User Interface</strong></td><td></td><td>Year to Year Child Count in Reports Library now available.</td><td>CIID-5032</td><td>Reports</td></tr><tr><td><strong>General</strong></td><td></td><td>Decided on a standard naming convention for the Source to Staging ETL stored procedures. This will be leveraged in future development. No action required by the State.</td><td>CIID-5123</td><td>Source to Staging ETL</td></tr><tr><td></td><td></td><td>Created Submission File Comparison Utility.</td><td>CIID-5246</td><td>Data</td></tr><tr><td></td><td></td><td>Automated end-to-end testing scripts into build process.</td><td>CIID-4515</td><td>Performance</td></tr><tr><td></td><td></td><td>Added a new schema, ‘Utilities’, to hold available tools.</td><td>CIID-5215</td><td>Database</td></tr><tr><td></td><td></td><td>Adjusted Debug tables for Year-to-Year comparison reports.</td><td>CIID-5652</td><td>User Interface</td></tr><tr><td></td><td></td><td>Created Common Debugging views for Child Count.</td><td>CIID-5654</td><td>Data</td></tr></tbody></table>

### UPGRADE PROCEDURE

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 5.3.

### COMPATIBLE SYSTEMS

Generate was tested on the following operating systems and browsers:

* [x] Windows 10 Pro
* [x] Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit)&#x20;
* [x] Firefox Quantum 61.01 (64 bit)
