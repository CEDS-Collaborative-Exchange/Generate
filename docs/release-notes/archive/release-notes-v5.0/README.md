---
description: GENERATE RELEASE NOTES VERSION 5.0
---

# Release Notes 5.0

## Purpose <a href="#purpose" id="purpose"></a>

This document provides a description of the technical enhancements to Generate version 5.0 released in August 2022. The purpose of this document is to communicate the technical updates made to Generate in version 5.0 with up-to-date information about improvements, including new features and reporting enhancements, which have been made to the system with the new software release.

### Upgrade Procedure <a href="#upgrade-procedure" id="upgrade-procedure"></a>

No changes have been made to the Generate upgrade procedure for this release. Follow the standard Generate upgrade process to install version 5.0.

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

* **Windows 10 Pro**
* **Google Chrome**, Version 68 0.3440.106 (Official Build) (64-bit) and&#x20;
* **Firefox Quantum** 61.01 (64 bit)

## Release Overview <a href="#release-overview" id="release-overview"></a>

Generate version 5.0 continues to leverage a new data migration approach first introduced in the previous release of Generate in which data are migrated from Staging tables directly to the RDS Fact and Dimension tables. In Generate version 5.0, there were additional files updated to the new migration method including all the IDEA Discipline files (FS005, FS006, FS007, FS088, FS143 and FS144), Personnel files (FS070, FS099 and FS112), and Exiting files (FS009).

For SEAs using the Generate user interface to migrate data, this new migration method requires no changes to the loading of the staging tables and requires no changes to how you currently migrate data. Please continue to run the ODS Migration, RDS Migration, and Reports Migration to create submission files. For SEAs that use manual migration scripts that reference the individual stored procedure names that are saved locally, and that DO NOT use the wrapper scripts for that file group (Child Count, Discipline, Exiting or Personnel), for example (`App.Wrapper_Migrate_ChildCount_to_RDS`), you will need to update them to call the wrapper script because the manual migration scripts will no longer be valid. The wrapper script handles the new process and that is the only change needed.

The benefits of this change include:

* Simplifying the steps in the migration process
* Less debugging as data is migrated
* The migrations run faster

In another effort to simplify the migration process, wrapper scripts were added at the IDS level for all the non-IDEA files specifications. This enhancement means that there is now a single stored procedure that can be selected to migrate every file grouping in Generate at both the IDS and RDS levels. It also means that the options in the IDS and RDS migration screens now match so to migrate Membership for instance, select Staging.Wrapper\_Migrate\_Membership\_to\_IDS for the IDS migration, then select App.Wrapper\_Migrate\_Membership\_to\_RDS for the RDS migration, then migrate the report(s) by file specification number for the Report migration. Also, on the IDS migration screen, the file specifications included in each wrapper script are noted in the Description column to the right to make it easier to know which wrapper needs to be executed for the file(s) being worked on.

Improvements in the deployment process used to perform automated end-to-end testing of Generate have introduced the potential conflict between the configuration files implemented in states. Please backup and

GENERATE RELEASE NOTES VERSION 5.0

1

delete the following files from your Generate instances to prevent any configuration issues. Also ensure that the AppSettings.json file in the locations below are complete and accurate.

### Generate.Web:

* Config\AppSettings.Development.json
* Config\AppSettings.Production.json
* Config\AppSettings.Stage.json
* Config\AppSettings.Test.json

### Generate.Background:

* AppSettings.Development.json
* AppSettings.Production.json
* AppSettings.Stage.json
* AppSettings.Test.json

## Generate Enhancements <a href="#generate-enhancements" id="generate-enhancements"></a>

The following E&#x44;_&#x46;acts_ reports were updated in this release.

| **Category**                     | **Report**                                                                                                                                                 | **Approved Change**                                                                                                                                        | **Reference Number**        | **Type of Impact** |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------- | ------------------ |
| **IDEA Child Count**             | FS002 FS089                                                                                                                                                | Updated the report logic to handle students that should only be reportable at the SEA level                                                                | CIID-4809                   | Data               |
| FS089                            | Corrected an issue with the handling of 5-year-old students in the 089 file with relation to Grade Level                                                   | CIID-4775                                                                                                                                                  | Data                        |                    |
| **Discipline**                   | FS005 FS006 FS007 FS009 FS088 FS143 FS144                                                                                                                  | Updated the report logic to handle students that should only be reportable at the SEA level.                                                               | CIID-4810                   | Data               |
| **Directory**                    | FS029                                                                                                                                                      | Corrected an issue in the Organization migration when the LEA/School has more than one (1) valid record in the given School Year.                          | CIID-4682                   | Data               |
| FS029                            | Resolved issue where there were duplicate records in the metadata table.                                                                                   | CIID-4824                                                                                                                                                  | <p>User</p><p>Interface</p> |                    |
| **Grades Offered**               | FS039                                                                                                                                                      | Enhanced the IDS Organization Address logic to handle NULL dates passed into RecordEndDateTime in Staging.OrganizationAddress.                             | CIID-4689                   | Data               |
| **Free and Reduced Price Lunch** | FS033                                                                                                                                                      | Resolved an issue with the reporting logic filter by adding a join to the DimStudentStatus table and modifying Get\_Count SQL to include the missing join. | CIID-4807                   | Data               |
| FS033                            | Resolved an issue where the report was not showing zero counts.                                                                                            | CIID-4802                                                                                                                                                  | Data                        |                    |
| FS033                            | Added file submission metadata for school years 2020, 2021 and 2022.                                                                                       | CIID-4800                                                                                                                                                  | Data                        |                    |
| FS033                            | <p>Modified the stored procedure “Staging.Migrate_PersonStatus” so that it</p><p>uses the membership date from Toggle instead of the child count date.</p> | CIID-4806                                                                                                                                                  | Data                        |                    |

|                                                                                |                                                                                           | <p>STATE IMPACT: states will need to make sure the Toggle has been set</p><p>before running the migration.</p>                                                                                             |                                    |                             |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | --------------------------- |
| <p><strong>Federal</strong></p><p><strong>Programs</strong></p>                | FS035                                                                                     | <p>Updated migration logic to migrate Federal Program Funding related</p><p>data.</p>                                                                                                                      | CIID-4833                          | Data                        |
| **Membership**                                                                 | FS052                                                                                     | Resolved error where the SEA Level was not producing zero counts.                                                                                                                                          | CIID-4738                          | Data                        |
| <p><strong>Students Involved with</strong></p><p><strong>Firearms</strong></p> | FS086                                                                                     | Updated the join logic in Migrate\_DimFirearmsDiscipline to be date based so that it pulls only the appropriate records for the school year being migrated.                                                | CIID-4457                          | Data                        |
| **Personnel**                                                                  | FS112                                                                                     | <p>Updated the descriptions for the permitted values in the age group category as follows:</p><p>“3 through 5” was changed to “Age 3 through 5”</p><p>“6 through 21” was changed to “Age 6 through 21”</p> | CIID-4754 CIID-4755                | Data                        |
|                                                                                | <p>Two new columns added to Staging.K12StaffAssignment: Birthdate</p><p>PositionTitle</p> |                                                                                                                                                                                                            | <p>Source to Staging</p><p>ETL</p> |                             |
| **Assessment**                                                                 | <p>FS175 FS178 FS179 FS185 FS188</p><p>FS189</p>                                          | Resolved issue where there were duplicate records in the metadata tables.                                                                                                                                  | CIID-4823                          | User Interface              |
| **Discipline, Exiting and Personnel**                                          | <p>FS005 FS006 FS007 FS088 FS143 FS144 FS009 FS070 FS099</p><p>FS112</p>                  | Resolved issue where there were duplicate records in the metadata tables that was preventing users from seeing certain reports correctly.                                                                  | CIID-4822                          | User Interface              |
| **User Interface**                                                             |                                                                                           | Resolved issue with saving responses in Toggle.                                                                                                                                                            | <p>CIID-4779</p><p>CIID-4803</p>   | <p>User</p><p>Interface</p> |
|                                                                                | Updated the links to the CIID and SPP/APR websites.                                       | CIID-4829                                                                                                                                                                                                  | <p>User</p><p>Interface</p>        |                             |
|                                                                                | Create IDS wrapper scripts for the non-IDEA migrations                                    | CIID-4498                                                                                                                                                                                                  | User Interface                     |                             |
|                                                                                | Create Common Debugging Views for each data group - Exit, Discipline, Staff               | CIID-4808                                                                                                                                                                                                  | User Interface                     |                             |

Type of Impact:

* Data – the changes will improve data quality and completeness
* User Interface – the changes impact the Generate User Interface and/or migration process
* Source to Staging ETL – the changes may require modifications to the SEA’s Source to Staging ETL
