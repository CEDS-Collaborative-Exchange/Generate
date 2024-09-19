---
description: Generate Release Notes Version 3.4
---

# Release Notes v3.4

### Introduction <a href="#introduction" id="introduction"></a>

The purpose of this document is to communicate the technical and general updates made to Generate 3.4, released in March 2020.

### Technical Release Summary <a href="#technical-release-summary" id="technical-release-summary"></a>

#### Before you upgrade <a href="#before-you-upgrade" id="before-you-upgrade"></a>

A JavaScript file must be copied to your Generate server in order to use the auto-upgrade feature. Please copy the JavaScript file (6.03a95cc8bbce5b3218ff.js) to the following location “\generate.web\ClientApp\dist” on the server. After the file has been copied to the server, log into Generate and press SHIFT-F5 to update the cached file from your local computer.

#### After you upgrade <a href="#after-you-upgrade" id="after-you-upgrade"></a>

Generate 3.4 includes several upgrades to the way data is loaded and stored in Generate, including changes to the staging environment that require states to make updates to the Generate loading scripts. Below is an overview of the steps that will need to be completed.

1. Organization operational statuses are now required in Generate to properly produce zero count records. Generate expects a record for every school that should be reported (open schools) for the school year. The initial operational status for each district and each school that needs to be counted for the school year must be set in LEA\_OperationalStatus and School\_OperationalStatus. Use the default start date of 7/1/YYYY (the first day of the school year) to populate the LEA and School effective dates (LEA\_UpdatedOperationalStatusEffectiveDate and School\_UpdatedOperationalStatusEffectiveDate) in order for Generate to include the LEA/School in EDFacts Reports.
2. To produce the FS029 – Directory file, the state must provide a record in Staging.Organization for all organizations that need to be reported with the initial operational status effective date set to 7/1/YYYY of the school year.
3. Operational status values for LEAs and Schools are translated using the ODS.SourceSystemReferenceData table. Please ensure that any accepted state values for that field are properly translated to the appropriate CEDS values in that table. Also, the TableFilter value in ODS.SourceSystemReferenceData for mapping to RefOperationalStatus now uses the proper codes from RefOperationalStatusType. Ensure that your mapping in ODS.SourceSystemReferenceData is using these codes:
   * TableFilter of “001418” = LEA Operational Statuses
   * TableFilter of “000533” = School Operational Statuses
4. Two new fields, RecordStartDateTime and RecordEndDateTime, have been added to several tables. These are used to inform Generate of the lifespan of the data in the record and allow Generate to store the accurate historical information for each Organization and Person. For instance, if an organization changes their mailing address during the school year, a record needs to be added to Staging.OrganizationAddress with the new address and RecordStartDateTime set to the date when the name mailing address change is effective. Likewise for student or personnel details, if a student changed their official birthdate during the school year, create a new record in Staging.Person with the new birthdate and RecordStartDateTime set to the time the new birthdate takes effect. RecordEndDateTime is handled within Generate. When a new record with an updated RecordStartDateTime for an existing organization or person is submitted the currently stored record is automatically end-dated one day prior to the start date of the new record. If you explicitly want to set the RecordEndDateTime outside that logic, the field can be populated in staging and that date will be used.

The tables affected include:

*
  * Staging.Organization (LEA\_RecordStartDateTime, LEA\_RecordEndDateTime, School\_RecordStartDateTime, School\_RecordEndDateTime)
  * Staging.OrganizationAddress
  * Staging.OrganizationGradeOffered
  * Staging.OrganizationPhone
  * Staging.Person

### General Release Summary <a href="#general-release-summary" id="general-release-summary"></a>

Generate Version 3.4 introduces several new features that affect Toggle, the Data Store, and the application in general, as well as defect resolution.

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following Standard ED_Facts_ reports were updated in this release.

| Report | Resolved Defect                                                                                                                                             |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 002    | Added permitted value AGE05K Age 5 (Kindergarten) to Category Age (School Age) for 2019-20 school year                                                      |
| 089    | Added permitted value AGE05NOTK Age 5 (not Kindergarten) to Category Age for 2019-20 school year                                                            |
| 143    | <ul><li>Updated total category set and MISSING counts</li><li>Resolved issue where count of distinct incidents was occurring rather than removals</li></ul> |
| 070    | Resolved inflated counts                                                                                                                                    |

| 112                                                            | Resolved inflated counts                                                                                                                                                                                                                                                                                                                                                                                                                             |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 099                                                            | <ul><li>Updated staff categories that were not showing up in the submission file with their FTE counts</li><li>Updated zero counts that were missing from submission file</li><li>Resolved issues with Basis of Exit and zero counts</li></ul>                                                                                                                                                                                                       |
| 006                                                            | Changed aggregation grouping based on report level                                                                                                                                                                                                                                                                                                                                                                                                   |
| 009                                                            | Resolved issue where zero counts for Basis for Exit were included in the file                                                                                                                                                                                                                                                                                                                                                                        |
| 144                                                            | Resolved issue where discipline incidents and IDEA statuses were not pulled by School                                                                                                                                                                                                                                                                                                                                                                |
| 189                                                            | Resolved issue where table type was not populating for SY 2018-19                                                                                                                                                                                                                                                                                                                                                                                    |
| 141                                                            | Resolved issue where LEP was not filtering on Grade level when Migrating Data into the RDS                                                                                                                                                                                                                                                                                                                                                           |
| 202                                                            | Resolved issue with discrepancy in report view and submission file                                                                                                                                                                                                                                                                                                                                                                                   |
| 029                                                            | <ul><li>Added new ED<em>Facts</em> fields</li><li>Updated report logic to calculate operational status and updated operational status using the effective date</li></ul>                                                                                                                                                                                                                                                                             |
| 045                                                            | Resolved issues with migration                                                                                                                                                                                                                                                                                                                                                                                                                       |
| 202                                                            | Resolved issue with school name filter                                                                                                                                                                                                                                                                                                                                                                                                               |
| 185, 188, 189                                                  | Resolved issue with zero counts                                                                                                                                                                                                                                                                                                                                                                                                                      |
| 039                                                            | <ul><li>Left justified organization name columns</li><li>Added SEA and LEA names</li></ul>                                                                                                                                                                                                                                                                                                                                                           |
| <p>002, 033, 052,</p><p>059, 089, 141,</p><p>185, 188, 189</p> | Rolled over metadata to year 2019-20                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 005                                                            | Updated report migration test scripts                                                                                                                                                                                                                                                                                                                                                                                                                |
| <p>059, 070, 099,</p><p>112, 203</p>                           | Changed column name from Rate to Total                                                                                                                                                                                                                                                                                                                                                                                                               |
| 207                                                            | Inactivated report because it is not active in ESS                                                                                                                                                                                                                                                                                                                                                                                                   |
| Personnel reports                                              | Resolved issue with metadata and stored procedure                                                                                                                                                                                                                                                                                                                                                                                                    |
| All                                                            | <ul><li>Logically arranged selection filters</li><li>Changed Order of School Year to descending</li><li>Corrected overlapping dropdown fields</li><li>Resolved binding issue when selecting menu options from two different dropdowns simultaneously</li><li>Updated reporting logic for file specs that look for only open schools to calculate the list based on operational status effective date</li><li>Resolved response time issues</li></ul> |

|   | <ul><li>Corrected calculation for child count dates and birthdays</li><li>Updated UI to address issue where Total of the Education Unit row was partially cut off by the row below it</li><li>Rolled over metadata for SY 2019-20 from previous year</li><li>Updated LEA identifier to populate correct field</li></ul> |
| - | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

#### State Designed Reports (SDRs) <a href="#state-designed-reports-sdrs" id="state-designed-reports-sdrs"></a>

| Report                    | Resolved Defect                                                                      |
| ------------------------- | ------------------------------------------------------------------------------------ |
| Special Education Report  | Fixed report display                                                                 |
| Research Reports          | <p>Added two new reports</p><ul><li>Assessment</li><li>Attendance Patterns</li></ul> |
| Migrant category          | Added migrant category to existing research reports                                  |
| Assessment and Discipline | Resolved performance issues                                                          |
| All                       | Customized graph functionality                                                       |
| SDR                       | Resolved data display issue with Special Education Report                            |
| URLs                      | Created URLs to the Connection link when the report is downloaded                    |

### Updated Pages <a href="#updated-pages" id="updated-pages"></a>

#### Toggle <a href="#toggle" id="toggle"></a>

1. Added a warning message when the user tries to exit the Toggle page without saving changes.
2. Added a “No Response” radio button.
3. Resolved issues with error messages and color scheme in Assessments Toggle.
4. Resolved issue with radio button functionality

#### Data Store <a href="#data-store" id="data-store"></a>

1. Resolved issues with the reporting data store and reports migrations.
2. Reversed order of school years on the migration pages.
3. Added a process that deletes data out of the Reporting Data Store (RDS).
4. Added functionality for users to view reports after running the ODS migration.

#### Update <a href="#update" id="update"></a>

1. Added a loading indicator to the “Download Next Update” page.

#### General <a href="#general" id="general"></a>

1. Current UI session/cookies are now stored so that a user can restore their session after logging out and back in.
2. Added a twenty-minute time-out feature that includes a five-minute warning and a countdown clock, located under the User Profile.
3. Menu links were improved so the user can click anywhere on the button area to activate the link.
4. Updated link to the new SPP/APR page.
5. Added functionality for users to configure Resources > About Generate > Environment to say Production.
6. Resolved broken Connection links

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

1. Windows 10 Pro
2. Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), and Firefox Quantum 61.01 (64 bit)
