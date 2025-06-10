# Release Notes 12.3

### Required State Changes

### Enhancements

#### IDEA Reports

* **Discipline (006)** – Based on feedback from PSC, modified the logic for grouping the students counted in this file based on their cumulative duration of discipline.
* **Discipline (088)** – Fixed an issue including students in the counts that had only one removal and it was an expulsion.
* **Exiting (009)** - Fixed an issue with how the LEAs were being included that was incorrectly picking up records from previous school years.

#### Non-IDEA Reports

* **Title I (037, 134)** - Added support for these two files through the migration code, the UI display, and the submission files.
* **Title I (222)** – Added support for this file through the migration code and the UI display and developed it using the new Report population script.
* **Directory (131, 223)** - Added support for these two files through the migration code, the UI display, and the submission files.
* **Membership (226)** - Added support for this file through the migration code and the UI display and developed it using the new Report population script.
* **Assessments (210, 211)** - Added support for these two files through the migration code.

#### User Interface

* **Enhanced Metadata Update Process:** Added the ability to select a school year from the automated metadata update process.
* **Improved UI Reports:** Added a loading icon to the Reports page for better user experience, especially for longer loading reports like Assessments and Membership.
* **Updated Documentation Access:** Added a link from the Resources tab in the navigation ribbon to the Generate documentation in Gitbook.
* **Centralized Support Resources:** Consolidated all the support resources into a single location in Gitbook which can be accessed using the Support link from the Resources tab.

#### General System Updates

* **Generate infrastructure** – Added the new views to support transitioning the report migration code for all files to the new process. That will happen in stages over upcoming releases.
* **Utilities** – Enhanced the Rebuild Indexes utility to include the Fact and Dimension tables
* **ETL Documentation Templates** – Added the changes from this release into the appropriate templates

#### Documentation Updates

* New Fact Type pages
  * Directory
  * Discipline
  * Exiting
  * Membership
  * Staff

#### CEDS Collaborative Exchange

* New bug issue submission template

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

<table><thead><tr><th>Report #</th><th>Report</th><th width="233.5455322265625">Charge</th><th>Ticket</th><th>Impact<select><option value="UdetCa6RqyC4" label="Data" color="blue"></option><option value="0Zfsoxk6aFkO" label="User Interface" color="blue"></option></select></th></tr></thead><tbody><tr><td>FS222</td><td>Foster Care</td><td>Added nightly tests to verify FS222 report migration</td><td>CIID-6625</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td>FS129</td><td>CCD Schools</td><td>We added internal testing for file specification 129 - CCD Schools</td><td>CIID-6693</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td></td><td></td><td>Version 12 release notes should have included a statement that staging column K12Organization.School_TitleIPartASchoolDesignation was renamed to K12Organization.School_TitleISchoolStatus. This change may impact any State ETLs that populate Staging.K12Organization, or any Snapshot processes that reference table Staging.K12Organization.</td><td>CIID-7198</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td></td><td></td><td>Cleaned up the required parameters for the new report migration script, rds.Insert_CountsIntoReportTable and made it so that it can be run in debug mode for validating/verifying results</td><td>CIID-7152</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td></td><td></td><td>Added the ability to select the specific SY that the metadata will retrieve and refresh.</td><td>CIID-7320</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td></td><td></td><td>Enhanced the Index Rebuild utility to include the RDS dimension and fact tables.</td><td>CIID-7321</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td></td><td></td><td>We added the EDFacts report specific fact table views to support the use of the new report migration logic</td><td>CIID-7323</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr><tr><td>FS045</td><td>Title III</td><td>Addressed an issue with the RDS migration for Title III students to ensure the Fact table only includes Title III identified students</td><td>CIID-7750</td><td><span data-option="UdetCa6RqyC4">Data</span></td></tr></tbody></table>

{% @github-files/github-code-block url="https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is:issue+state:open+label:v12.3" %}

### Upgrade Procedure

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 12.3.

### Compatible Systems

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)

### Office Hour

{% embed url="https://www.youtube.com/watch?v=xL4Na7myRv0" %}
