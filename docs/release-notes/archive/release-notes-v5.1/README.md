---
description: >-
  This document provides a description of the technical enhancements to Generate
  version 5.1 released in October 2022.
---

# Release Notes 5.1

## RELEASE OVERVIEW

Generate version 5.1 continues to leverage a new data migration approach first introduced in version 4.2 of Generate in which data are migrated from Staging tables directly to the RDS Fact and Dimension tables. For SEAs using the Generate user interface to migrate data, this new migration method requires no changes to the loading of the staging tables and requires no changes to how you currently migrate data. Please continue to run the ODS Migration, RDS Migration, and Reports Migration to create submission files.&#x20;

For SEAs that use manual migration scripts that reference the individual stored procedure names that are saved locally, and that DO NOT use the wrapper scripts for that file group (Child Count, Discipline, Exiting, Personnel, or Directory), for example (App.Wrapper\_Migrate\_ChildCount\_to\_RDS), you will need to update them to call the wrapper script because the manual migration scripts will no longer be valid. The wrapper script handles the new process, and that is the only change needed.&#x20;

The benefits of this change include:

* Simplifying the steps in the migration process
* Less debugging as data is migrated
* The migrations run faster

### State ETL changes:&#x20;

There was a stored procedure named `Staging.Migrate_Data_Validation` that was used in earlier versions of Generate. We will be implementing a new migration validation procedure, so we removed this deprecated stored procedure. You will just need to verify that your Source to Staging ETL code does not call this stored procedure. If so, remove the call.

### GENERATE ENHANCEMENTS&#x20;

The following E&#x44;_&#x46;acts_ reports were updated in this release.

#### Type of Impact:&#x20;

* **Data** – the changes will improve data quality and completeness
* **User Interface** – the changes impact the Generate User Interface and/or migration process
* **Source to Staging ETL** – the changes may require modifications to the SEA’s Source to Staging ETL
* **Performance** – the changes improve the performance of a data migration
* **Migration** – the changes impact a data migration process
* **Submission Files** – the changes may impact submission file(s)
* **Database** – changes to the Generate database structure

<table><thead><tr><th width="124">Impact</th><th width="117">Category</th><th width="112">Report</th><th width="301">Approved Change</th><th width="119">Reference</th></tr></thead><tbody><tr><td><a data-footnote-ref href="#user-content-fn-1">Data</a></td><td>Exiting</td><td>FS009</td><td><p><strong>Spec Ed Exit</strong>: Modified procedure so that when states update the collection period in Toggle, the ETL uses the collection period dates.</p><p></p><p><strong>Spec Ed Exit</strong>: Updated join to capture students at LEA-level only to get EL status.</p></td><td><p>CIID-4920 </p><p>CIID-5019</p></td></tr><tr><td><a data-footnote-ref href="#user-content-fn-2">Data</a></td><td>Discipline</td><td><p>FS005</p><p>FS006 </p><p>FS007</p><p>FS009 </p><p>FS088 </p><p>FS143 </p><p>FS144</p></td><td><p>Fixed issue with Reports Library so Disciplinary Removals of Children with Disabilities (IDEA) Ages 3-21 now works correctly. </p><p></p><p>Corrected Staging-to-Fact Discipline Issues and improved migration performance.</p></td><td><p>CIID-4838</p><p>CIID-5053</p></td></tr><tr><td><a data-footnote-ref href="#user-content-fn-3">Data</a></td><td>Assessment</td><td>FS175 FS178 FS179 FS185 FS188 FS189</td><td><p>Corrected issue with Assessment Files (175, 178, 179, 185, 188, 189) to allow data to display for 2022 </p><p></p><p>Corrected issue with Assessment Files (175, 178, 179, 185, 188, 189) in the Create Report data</p></td><td>CIID-4875 CIID-4921</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-4">Data</a></td><td>Homeless</td><td>FS118</td><td>Homeless Students Enrolled The CIID team has been developing “end-to-end” tests for each EdFacts report to validate the migration processes. An end-to-end test for this report was created, executed and verified.</td><td>CIID-4900</td></tr><tr><td><p><a data-footnote-ref href="#user-content-fn-5">Data</a></p><p><a data-footnote-ref href="#user-content-fn-6">Migration</a></p></td><td>Directory</td><td>FS029</td><td><p>Corrected an issue when a NCES ID for a School is the same as another School's State Identifier Directory. Generate will correctly count the student for the School for which they are enrolled.</p><p></p><p>IDEA Develop Staging-to-RDS ETL Script for Directory Counts</p></td><td><p>CIID-4827</p><p>CIID-4516</p></td></tr><tr><td><a data-footnote-ref href="#user-content-fn-7">Data</a></td><td>Students Involved with Firearms</td><td>FS086</td><td>Created and completed end-to-end ETL Testing for Students Involved with Firearms</td><td>CIID-4827</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-8">User Interface</a></td><td>User Interface</td><td></td><td>Updated data visuals in reports library</td><td>CIID-4020</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-9">Submission Files</a></td><td>General</td><td></td><td>Complete the ESS Metadata Auditing Generate uses “metadata” to know what columns are to appear on each EdFacts report. As changes are made to EdFacts file specifications, changes may be needed in Generate to produce the reports according to the specifications</td><td>CIID-4924</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-10">Performance</a></td><td>General</td><td></td><td>Fixed an issue where Get_CountSQL Clause was producing Slow Results on School Level Submission File</td><td>CIID-4862</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-11">Source to Staging ETL</a></td><td>General</td><td></td><td>Fixed an issue where Migrate_DimLeas set the RecordEndDateTime to one day earlier than it should</td><td>CIID-4911</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-12">Database</a></td><td>General</td><td></td><td>Remove Ed-Fi Procedures from Staging schema in database Remove Staging.Migrate_Data_Validation procedure. For Ed-Fi procedures for Generate, please see Ed-Fi Repository NOTE: If your Source to Staging ETLs refer to this procedure you will need to remove the reference to it.</td><td>CIID-4916</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-13">Data</a></td><td>General</td><td></td><td>Updated Staging.Staging-to-DimSeas so it now populates DimK12Staff for State Officer</td><td>CIID-5024</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-14">Migration</a></td><td>General</td><td></td><td>Updated RDS Wrapper Scripts to use new Staging-to-DimSeas, Staging-to-DimLeas, Staging-to-DimK12Schools</td><td>CIID-5025</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-15">Submission Files</a></td><td>General</td><td></td><td>EUT (Education Unit of Total) changes required in Metadata</td><td>CIID-5054</td></tr><tr><td><a data-footnote-ref href="#user-content-fn-16">Data</a></td><td>Exiting</td><td>Standard Report-Exit from Special Education</td><td>Modified the code for this report on exits from Special Education. **the Migrant category in this report needs additional corrections that will be available in a future release.</td><td>CIID-4837</td></tr></tbody></table>

### GENERAL SECTION

<table><thead><tr><th width="127">Category</th><th width="115">Software</th><th width="244">Approved Change</th><th width="114">Reference</th><th>Type of Impact</th></tr></thead><tbody><tr><td>Upgrade</td><td>ASP.NET</td><td>Upgrade Generate from 3.1 .Net Core to 6.0 .Net Core</td><td>CIID-4898</td><td>Performance</td></tr></tbody></table>

### UPGRADE PROCEDURE&#x20;

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 5.1.

### COMPATIBLE SYSTEMS&#x20;

Generate was tested on the following operating systems and browsers:&#x20;

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)



[^1]: the changes will improve data quality and completeness

[^2]: the changes will improve data quality and completeness

[^3]: the changes will improve data quality and completeness

[^4]: the changes will improve data quality and completeness

[^5]: the changes will improve data quality and completeness

[^6]: the changes impact a data migration process

[^7]: the changes will improve data quality and completeness

[^8]: the changes impact the Generate User Interface and/or migration process

[^9]: the changes may impact submission file(s)

[^10]: the changes improve the performance of a data migration

[^11]: the changes may require modifications to the SEA’s Source to Staging ETL

[^12]: changes to the Generate database structure

[^13]: the changes will improve data quality and completeness

[^14]: the changes impact a data migration process

[^15]: the changes may impact submission file(s)

[^16]: the changes will improve data quality and completeness
