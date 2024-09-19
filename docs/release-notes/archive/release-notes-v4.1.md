---
description: Generate Release Notes Version 4.1
---

# Release Notes v4.1

## Purpose <a href="#introduction" id="introduction"></a>

The purpose of this document is to communicate the technical updates made to Generate in version 4.1.

### General Release Summary <a href="#general-release-summary" id="general-release-summary"></a>

Generate Release version 4.1 includes updates to reports, the ETL (Data Store), and defect resolution.

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following ED_Facts_ reports were updated in this release.

| Report                                                                                                          | Approved Change                                                                                  | Reference Number |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ---------------- |
| FS175, 178, 179                                                                                                 | Resolved performance issues with UI Assessments reports.                                         | CIID-2292        |
| FS029                                                                                                           | Resolved issue with the typo in the word “Primary Authorizer.”                                   | CIID-3867        |
| FS029                                                                                                           | Implemented ETL to RDS Reporting Layer to handle multiple operational statuses.                  | CIID-3872        |
| <p>FS 035, 039, 103, 129, 130,</p><p>131, 132, 163, 170, 190,</p><p>193, 196, 197, 198, 205,</p><p>206, 207</p> | Implemented new logic in Create\_OrganizationReportData to handle multiple operational statuses. | CIID-4432        |

### Defect Resolution <a href="#defect-resolution" id="defect-resolution"></a>

1. CIID-2292 Assessments - Investigate performance issues with UI Assessments reports (175, 178, 179).
   * Performance issues were resolved by implementing paging on the UI report.
2. CIID-2517: FS037 Title I Part A SWP/TAS Participation - Category E "Homeless" - permitted value "H" is missing from the SEA and LEA submission files.
   * Resolved issue where ‘H’ (Homeless) was missing from Category E.
3. CIID-3867: FS029 Directory - EDFacts submission School Report 'Primary Authorizers' should be singular (Authorizer) not plural.
   * Changed “Charter School Primary Authorizers” to “Charter School Primary Authorizer.”
4. CIID-3868 FS029 Directory - Charter School Authorizer Identifier (State) - Primary and Secondary Authorizers are not displaying in export to Excel.
   * Resolved issue where Charter School Authorizer Identifier (State) - Primary and Secondary Authorizers were appearing on the UI report but were missing from the export to Excel feature.
5. CIID-4429: Migrations - School Year should create the select list from the current metadata.
   * Resolved issue where School Year was displaying records through 2050.
6. CIID-4439: All file specs using Disability - GetCountSQL are using the wrong school year for the ID/MR Disability code switch.
   * Updated Get\_CountSQL to make sure it is correctly using MR/ID based on the School Year.
7. CIID-4457 FS086 - Migrate\_DimFirearmsDiscipline joins exclude previous year student records.
   * Updated join logic in Migrate\_ DimFirearmsDiscipline to be date-based so it pulls the appropriate record for the school year being migrated.
8. CIID-4567: FS029 - Reconstituted Status not handled correctly in the IDS migration
   * Resolved Reconstituted Status INSERT into dbo.OrganizationFederalAccountability is limited to only records where reconstituted status is populated
9. CIID-4570: FS029 Migrate\_StagingToIDS\_Organization insert into dbo.OrganizationWebsite can result in a null insert
   * Modified Migrate\_StagingToIDS\_Organization to add WHERE clause condition to the into dbo.OrganizationWebsite. This resolved the INSERT error.
10. CIID-4571: FS029 Migrate\_DimSeas is updating MailingAddressStreet2 with MailingAddressStreet
    * Resolved issue in Migrate\_DimSeas by mapping MailingAddressStreet2 to MailingAddressStreet2.
11. CIID-4472: FS178 ELA Assessment - Page Unresponsive message displays when changing category sets at the school level.
    * Resolved page response issue by implementing paging on the UI report.
12. CIID-4482: Migrate\_DimK12Races output doesn't include PersonId, so if races differ between dual-enrolled schools, output will be cross joined.
    * Resolved issue where output didn’t include PersonId in Migrate\_DimK12Races.
13. CIID-4494: FS005 & FS007 IDEA Discipline - Fix the code that sums discipline to check for > 45 days in Get\_CountSQL.
    * Resolved issue where Get\_CountSQL was summing all types of Discipline events when comparing to the 45-day rule for FS005 and FS007.
14. CIID-4503 FS006 - Update RDS.Get\_CountSQL to exclude REMDW records from the Removal Length Aggregation.
    * Resolved issue in RDS.Get\_CountSQL by excluding REMDW records from the Removal Length aggregation.
15. CIID-4514 FS143 & FS086 - Migrate\_DimFirearms creates a cross-join for FS143 duplicating records.
    * Modified rds.Migrate\_StudentDisciplines to add IncidentId to the @firearmsQuery temp table, then inserted into that temp table, and added it to the join condition in the population of #queryOutput. Also modified rds.Migrate\_DimFirearms to return IncidentId. This resolved the duplicate records.
16. CIID-4541 FS029 Directory is exporting from Generate Web Application with "Undefined" rather than the state abbreviation in the file name.
    * Resolved issue where the submission files were exporting the file name using the string

“Undefined” rather than the state code.

### Non-Development Tasks <a href="#non-development-tasks" id="non-development-tasks"></a>

1. CIID-4468: FS070, 099, 112 Spec Ed Teachers - Check the joins at the RDS level for Teachers and Paraprofessionals.
   * Resolved issue where FTE numbers were duplicated in FactK12StaffCounts.

### Development Tasks <a href="#development-tasks" id="development-tasks"></a>

1. CIID-4432: File specs - 035, 039, 103, 129, 130, 131, 132, 163, 170, 190, 193, 196, 197, 198, 205,

206, 207 - Update Create\_OrganizationReportData to use the new Operational Status logic.

*
  * Create\_OrganizationReportData was updated previously to handle Operational Status more efficiently for 029. The same logic was applied to the other Organization files included in that stored procedure.

### Enhancements <a href="#enhancements" id="enhancements"></a>

1. CIID-3872: FS029 Directory - Updated ETL to RDS Reporting Layer to handle multiple operational statuses.
2. CIID-4374: Rebuilt the indexes at the IDS migration level.
3. CIID-4543: Added code to IDS Organization migration to check/create the mappings for a new school year in SourceSystemReferenceData.

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit) and Firefox Quantum 61.01 (64 bit)
