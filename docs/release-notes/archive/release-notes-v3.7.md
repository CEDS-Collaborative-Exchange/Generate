---
description: Generate Release Notes Version 3.7
---

# Release Notes 3.7

Introduction

The purpose of this document is to communicate the technical and general updates made to Generate in version 3.7.

### Technical Release Summary <a href="#technical-release-summary" id="technical-release-summary"></a>

Several changes were made to the database tables. Refer to the _3&#x55;_&#x44;_2T_ atabase Update&#x73;_&#x55;32&#x54;_&#x73;ection for details.

### General Release Summary <a href="#general-release-summary" id="general-release-summary"></a>

Generate Release 3.7 includes updates to reports, the database, and configuration changes.

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following Standard E&#x44;_&#x46;acts_ reports were updated in this release.

| Report                                        | Approved Change                                                                                             | Reference Number |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---------------- |
| 039                                           | Added permitted values for “Grades Offered” to online report.                                               | CIID-3921        |
| 039                                           | Added permitted values for “Grades Offered” to submission file                                              | CIID-3849        |
| 144                                           | Added permitted values for “Educational Services During Expulsion” to submission file                       | CIID-3934        |
| <p>002 &#x26;</p><p>089</p>                   | Changed abbreviation for the permitted values “Intellectual disability” to “ID”                             | CIID-3947        |
| <p>002 &#x26;</p><p>089</p>                   | Removed permitted value “AGE05 Age 5” and reference to transition of age 5 in kindergarten into FS002       | CIID-3948        |
| 113                                           | Added permitted values for “Progress Level” to report                                                       | CIID-2277        |
| <p>082, 083,</p><p>155, 157</p><p>and 204</p> | Discontinued in Generate to align with E&#x44;_&#x46;acts_ updates (files were discontinued for SY 2019-20) | CIID-2806        |

### Database Updates <a href="#database-updates" id="database-updates"></a>

1. Metadata was rolled over for the following years (reference CIID-3913 and CIID-3946):

o 2019-20: 005, 006, 007, 009, 045, 070, 088, 099, 112, 118, 143, and 144

o 2020-21: 029, 039, 033, 035, 052, 129, 141, 175, 178, 179, 185, 188 and 189

1. Updated PerkinsLEPStatus field in the staging PersonStatus table from a varchar field to a bit field. Edited encapsulated code to correctly insert records into ODS.PersonStatus for the Perkins LEP students and write the created IDs back. (Reference CIID-3855)
2. Updated SQL report to consider the LEA value migrated into the FactStudentDiscipline table to prevent reports from overwriting the responsible LEA with the attending LEA. (Reference CIID- 3852)
3. For FS134 report, updated aggregation rules for student counts in Get\_CountSQL.. (Reference CIID- 3875)
4. For files FS002 and FS029, removed filter on OperationalStatusEffectiveDate that was causing organizations without an operational status change mid-year to be excluded from several files that use different date ranges. (Reference CIID-3876)
5. Updated SPED wrapper scripts so the descriptions display for all files, not just IDEA. (Reference CIID-3918)
6. Applied logic and migration performance fixes to Generate source code. (Reference CIID-3951 and CIID-3952)
7. Created wrapper stored procedures for RDS migrations (Procedures & Parameters). (Reference CIID-2223)
8. Added functionality to track LEAs and Schools that are not reported federally. (Reference CIID- 3404)
9. For reports 029 and 039, updated ETL to RDS Reporting layer to handle multiple operational statuses. (Reference CIID-3872)
10. Disabled HTTPS redirect requirement for background app. (Reference CIID-3893)
11. Enabled logging of all errors in web app appUpdate and background app BackgroundUpdate controllers. (Reference CIID-3894)
12. For all IDEA files, updatedEnrollment\_encapsulated code to enable a check to ensure that OrganizationPersonRoleId\_LEA and OrganizationPersonRoleId\_School are populated. (Reference CIID-3853)
13. For file FS118, updated Get\_CountSQL to ensure proper creation of file. (Reference CIID-3959)
14. For files FS118 and FS194, updated Migrate\_DimAges and Migrate\_StudentCounts to ensure the FactTypeCode is passed through properly. (Reference CIID-3961)
15. Added option to Toggle so states can select a date to run the age calculation in Toggle. (Reference CIID-3966)
16. For file FS194, added the @useCutOffDate parameter into Migrate\_DimGradeLevels and use the proper date logic to determine which grade levels to return out of the stored procedure. (Reference CIID-3967)
17. Updated Migrate\_OrganizationCounts stored procedure so LEAs and schools do not end up with NULL operation status values. (Reference CIID-3839)
18. Updated ODS-RefOrganizationRelationship table because it was empty in Staging database after upgrading to 3.5 and was causing the migration to fail. (Reference CIID-3845)
19. Updated Enrollment\_encapsulated to check to ensure that OrganizationPersonRoleId\_LEA and OrganizationPersonRoleId\_School are populated when new records are inserted into the OrganizationPersonRoleRelationship table. (Reference CIID-3953)

### General Update <a href="#general-update" id="general-update"></a>

1. Added support for SSL connection to Active Directory. (Reference CIID-2713)
2. Toggle - corrected misspellings. (Reference CIID-1918, CIID-1999)
3. Toggle – updated “save” functionality in Assessments Toggle. (Reference CIID-3789)

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

*
  * Windows 10 Pro
  * Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), Firefox Quantum 61.01 (64 bit), and Internet Explorer 11, 1387,15063.0
