---
description: Generate Release Notes v3.6
---

# Release Notes 3.6

### Introduction <a href="#introduction" id="introduction"></a>

The purpose of this document is to communicate the technical and general updates made to Generate Hotfix 3.6.

### Technical Release Summary <a href="#technical-release-summary" id="technical-release-summary"></a>

Several changes were made to the database tables. Refer to the “Database” section for details.

### General Release Summary <a href="#general-release-summary" id="general-release-summary"></a>

Generate Hotfix 3.6 includes defect resolution for reports, and updates to the ETL (Data Store).

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following Standard E&#x44;_&#x46;acts_ reports were updated in this release.

| Report | Resolved Defect                                                                                                        | Reference Number |
| ------ | ---------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 029    | Resolved error related to creation of submission file.                                                                 | CIID-3929        |
| 029    | Added fields for “Mailing Address Line 2” and “Physical Address Line 2” to the user interface and the submission file. | CIID-3914        |
| 029    | Resolved issue where “effective date” was displaying today’s date instead of the original submission date.             | CIID-2736        |
| 039    | Resolved issue where “Grades Offered” was missing from the report on the user interface and the submission file.       | CIID 3954        |

### Database Updates <a href="#database-updates" id="database-updates"></a>

1. 029 Directory: Updated RDS.Create\_OrganizationReportData to remove filtering of Closed, Inactive, and Future Schools or LEAs. (Reference CIID-3908)
2. 029: Added fields and developed RDS ETL for Mailing Address Line 2 and Physical Address Line 2. (Reference CIID-3914)
3. 029: Resolved issue with reconstituted status. In organization\_encapsulated, the code that populated RefReconstitutedStatusId in ODS.OrganizationFederalAccountability did not qualify the select statement. Staging.Organization has LEA rows that do not have a school ID which caused there to be NULL OrganizationIds in the insert which resulted in an error. This was fixed by adding 'WHERE orgst.SchoolOrganizationId is not null' to the select. (Reference CIID-3889)
4. Cleaned up duplicated calls to functions in Organization\_encapsulated. (Reference CIID-3865)

### Configuration Changes <a href="#configuration-changes" id="configuration-changes"></a>

Generate 3.6 introduces the ability to connect to your Active Directory server over a Secure Socket Layer (SSL) encrypted connection. This addition requires a new configuration key in the Generate Web AppSettings.json file, located at \[web path]\Config\AppSettings.json. The key can be added after the “AD Port” line. Below is the new key and configuration options:

*
  * “IsSSLEnabled”: false|true,

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

1. Windows 10 Pro
2. Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), and Firefox Quantum 61.01 (64 bit)
