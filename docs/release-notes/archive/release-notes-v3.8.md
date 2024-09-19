---
description: Generate Release Notes Version 3.8
---

# Release Notes v3.8

### Introduction <a href="#introduction" id="introduction"></a>

The purpose of this document is to communicate the technical updates made to Generate in version 3.8.

### Technical Release Summary <a href="#technical-release-summary" id="technical-release-summary"></a>

Generate version 3.8 includes numerous updates to the database table and column names to match the official CEDS data warehouse names for CEDS version 9. Following the changes to the database, full end- to-end testing was performed.

### General Release Summary <a href="#general-release-summary" id="general-release-summary"></a>

Generate Release version 3.8 includes updates to reports, defect resolution, and development and non- development tasks.

### Updated Reports <a href="#updated-reports" id="updated-reports"></a>

The following Standard ED_Facts_ reports were updated in this release.

| Report                                                                                                                      | Approved Change                                                                                                                                                                                | Reference Number |
| --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| FS009                                                                                                                       | Add additional rule to FS009 – A student should be reported on the Exit with the Age they had when they exited at the LEA level. At the SEA level, this would be the age of the last LEA exit. | CIID-3880        |
| FS005, FS006, FS007, FS009, FS088 and FS143                                                                                 | Updated permitted value “MR” with “ID – Intellectual Disability.”                                                                                                                              | CIID-4322        |
| <p>FS054, FS070, FS086, FS099, FS112, FS118, FS121, FS122, FS144, FS145, FS163, FS165,</p><p>FS170, FS194, FS195, FS203</p> | Rolled over metadata for SY 2020-21.                                                                                                                                                           | CIID-4336        |

### Defect Resolution <a href="#defect-resolution" id="defect-resolution"></a>

1. CIID 3846: User Interface – Added Release Notes to Resources > About menu
   * Once the user updates Generate, the ability to view the Release Notes goes away.
     * Added a link to the Release Notes from the Resources > About menu.
2. CIID-3992: Added resolution to upper case Reconstituted Status fix into the next release.
   * Added Migrate\_OrganizationCounts to 3.8 UpdateScripts.csv.
   * Updated Migrate\_OrganizationCounts to existing 3.6 release, which is where this update should have occurred.
3. CIID-4000: Create\_OrganizationReportData referenced a temp table that was no longer populated.
   * In the previous version of the code, a temp table called @tblOperationalStatuses was used to get the effective date and updated effective date by operational status. In the current code, that table variable is still created but the code that would populate it no longer exists. There is still an inner join to that table in the code blocks for FS039, FS129, FS130, FS193, FS198, FS197, FS103, FS132, FS170, FS163, FS205, FS206, FS207, FS131,

and FS035. This also impacts FS002, FS089 and FS052, SY2020-21.

1. CIID-4016: Update RDS.Migrate\_OrganizationCounts to include LeaTypeEdFactsCode in the RDS.DimLeas MERGE statement.
   * Updated the MERGE statement for RDS.DimLeas in the RDS.Migrate\_OrganizationCounts stored procedure so it correctly includes the LeaTypeEdFactsCode. The result is that when an update is made to the Lea Type in the ODS, the LeaTypeEdFactsCode is out of sync with the other LEA Type fields in the RDS.DimLeas table. This causes the correct (updated) description to display on the FS029 Directory report but the incorrect (old) EDFactsCode to be exported in the submission file.
   * Three things were done: (1) The MERGE block below needed to be updated to include reconstituted status; (2) This code (trgt.LEATypeEDFactsCode = src.LeaType) was added to the MERGE block below; and (3) Check that all fields attached to the LEA records are being correctly updated when there is a change.
   * The following code: trgt.LEATypeEDFactsCode = src.LeaType, was added to this MERGE block:

MERGE rds.DimLeas as trgt USING @LeaSourceData as src

ON trgt.LeaStateIdentifier = src.StateIdentifier

AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '') WHEN MATCHED THEN

UPDATE SET trgt.LeaName = src.LeaName, trgt.MailingAddressStreet = src.MailingStreet, trgt.MailingAddressStreet2 = src.MailingStreet2, trgt.MailingAddressCity = src.MailingCity, trgt.MailingAddressState = src.MailingState, trgt.MailingAddressPostalCode = src.MailingPostalCode, trgt.PhysicalAddressStreet = src.StreetNumberAndName, trgt.PhysicalAddressStreet2 = src.PhysicalStreet2, trgt.PhysicalAddressCity = src.City, trgt.PhysicalAddressState = src.StateCode, trgt.PhysicalAddressPostalCode = src.PostalCode, trgt.Telephone = src.TelephoneNumber,

trgt.Website = src.Website, trgt.SupervisoryUnionIdentificationNumber = src.SupervisoryUnionIdentificationNumber, trgt.LeaOperationalStatus = src.LeaOperationalStatus,

trgt.LeaOperationalStatusEdFactsCode = src.LeaOperationalEdfactsStatus, trgt.OperationalStatusEffectiveDate = src.OperationalStatusEffectiveDate, trgt.PriorLeaStateIdentifier = src.PriorLeaStateIdentifier, trgt.ReportedFederally = src.ReportedFederally,

trgt.LeaTypeCode = src.LeaTypeCode, trgt.LEATypeEDFactsCode = src.LeaType, trgt.LeaTypeDescription = src.LeaTypeDescription, trgt.LeaTypeId = src.RefLeaTypeId, trgt.OutOfStateIndicator = src.OutOfState, trgt.LeaNcesIdentifier= src.NCESIdentifier, trgt.CharterLeaStatus = src.CharterLeaStatus, trgt.ReconstitutedStatus = src.ReconstitutedStatus, trgt.RecordEndDateTime = src.RecordEndDateTime

WHEN NOT MATCHED BY TARGET THEN — Records Exists in Source but not in Target

INSERT (

LeaName, LeaNcesIdentifier, LeaStateIdentifier, SeaName, SeaStateIdentifier, StateANSICode, StateCode, StateName,

SupervisoryUnionIdentificationNumber, LeaOperationalStatus, LeaOperationalStatusEdFactsCode, OperationalStatusEffectiveDate, PriorLeaStateIdentifier, ReportedFederally,

LeaTypeCode, LeaTypeDescription, LeaTypeEdFactsCode,LeaTypeId, MailingAddressStreet, MailingAddressStreet2, MailingAddressCity, MailingAddressState, MailingAddressPostalCode, OutOfStateIndicator, PhysicalAddressStreet, PhysicalAddressStreet2, PhysicalAddressCity, PhysicalAddressState, PhysicalAddressPostalCode,

Telephone,Website, CharterLeaStatus, ReconstitutedStatus, RecordStartDateTime, RecordEndDateTime

) VALUES (

src.LeaName, src.NCESIdentifier, src.StateIdentifier, @seaName, @seaIdentifier, @seaIdentifier, @stateCode, @stateName,

src.SupervisoryUnionIdentificationNumber, src.LeaOperationalStatus, src.LeaOperationalEdfactsStatus, src.OperationalStatusEffectiveDate, src.PriorLeaStateIdentifier, src.ReportedFederally,

src.LeaTypeCode, src.LeaTypeDescription, src.LeaType, src.RefLeaTypeId, src.MailingStreet, src.MailingStreet2, src.MailingCity, src.MailingState, src.MailingPostalCode, src.OutOfState, src.StreetNumberAndName, src.PhysicalStreet2,

src.City, src.StateCode, src.PostalCode,

src.TelephoneNumber, src.Website, src.CharterLeaStatus, src.ReconstitutedStatus, src.RecordStartDateTime, src.RecordEndDateTime

);

1. CIID-4021: Updated Get\_CountSQL to correctly split 5-year-olds between FS002 and FS089 files.
   * The new logic correctly splits 5-year-olds based on grade level logic. 3- and 4-year-olds are automatically in FS089 regardless of grade. 6–21-year-olds are automatically in FS002.
     * FS002: include 5-year-olds where grade level is not MISSING, PK.
     * FS089: Exclude 5-year-olds where grade level is MISSING, PK.
   * Grade level codes:
     * PK = Pre-K / Pre-Kindergarten.
     * Missing = Missing.
2. CIID-4022: Resolved issue where PersonStatus\_encapsulated was not creating the LEP records correctly.
   * Corrected code in PersonStatus\_encapsulated. It was only creating records for students in the program, or EnglishLearnerStatus = 1. This was not correct because ChildCount needs to be able to report by LEP/NLEP, so we needed the status = 0 record. This also applies to the Perkins LEP code in the same stored procedure.

WHERE ps.PersonStatusId\_EnglishLearner IS NULL AND ps.EnglishLearnerStatus = 1

should be

WHERE ps.PersonStatusId\_EnglishLearner IS NULL AND ps.EnglishLearnerStatus is not null

AND

WHERE ps.PersonStatusId\_PerkinsLEP IS NULL AND ps.PerkinsLEPStatus = 1

should be

WHERE ps.PersonStatusId\_PerkinsLEP IS NULL AND ps.PerkinsLEPStatus is not null.

1. CIID-4348: FS040 Graduates/Completers Migration: Identified and resolved issue with data not moving from Staging to IDS.
2. CIID-4405: Resolved “unknown error” when running submission files.
3. CIID-4407: Resolved “unknown error” when running FS070, FS099 and FS112.
4. CIID-4412: Resolved issue where permitted values were missing from submission files.
5. CIID-3931: Resolved issue in Migrate\_Data\_ETL\_IMPLEMENTATION\_STEP16\_StaffAssignment\_EncapsulatedCode. Resolved issue where stored procedure was missing a join to the ODS.SourceSystemReferenceData table when it did the insert for ODS.StaffCredential which resulted in the qualification for paraprofessionals showing up as missing in the online and submission reports.
6. CIID-3928: FS143 IDEA Disciplinary Removals. Resolved issue where student exclusion rules were improperly implemented in Get\_CountSQL.
   * There were two rules that weren’t implemented properly for FS143 in Get\_CountSQL:
     * Exclude students who have cumulatively been suspended for less than half a day.
     * Exclude parentally placed private school students.
7. CIID-3933: IDEA FS005 Removal & FS007 Removal Reason – Resolved issue where FS005 and FS007 were not displaying an SEA file properly when there wasn’t data.
8. CIID-4342: FS009 Special Education Exiting – User Interface – Toggle Question: Moved, Known to be Continuing – Other (specify)
   * Fixed issue where Toggle wasn’t saving the text entered.
9. CIID-4344: Updated Generate 3.8 to include any missing charter authorizer code from 3.7.
   * Charter Authorizer’s data was not migrating to the IDS.

### Non-Development Tasks <a href="#non-development-tasks" id="non-development-tasks"></a>

1. CIID-2673: Updated Directory ETL checklist with CEDS v9 Data Model IDs.
2. CIID-3917: Updated Generate Implementation Guide to reflect changes to schemas, tables/fields, and stored procedures.
3. CIID-4070: Updated the Generate Implementation Guide with newly collected reference information and stored procedure names.
   * Added a list of reference tables used in the IDS.
   * Changed new encapsulated code stored procedure names.
4. CIID-3972: Set the Wijmo License in the Staging Environment.
5. CIID-3979: Updated Wijmo for Release 3.8.
6. CIID-4054: Cleaned up the IDS script to reflect name changes.
   * Renamed the IDS scripts to make them more intuitive.

### Development Tasks <a href="#development-tasks" id="development-tasks"></a>

1. CIID-3995: Modified the staging tables for version 3.8.
   * Updated the staging table creation script to include all the necessary fields and reordered the fields for consistency between tables.
2. CIID-4026: Migrate\_Studentcounts for child count is very slow.
   * Added indexes to improve the performance of this data load.
3. CIID-4072: Fixed issue where Organization\_encapsulated inserts into ODS.OrganizationFederalAccountability failed in certain cases.
   * For LEAs that have no schools, the insert into ODS.OrganizationFederalAccountability failed because the OrganizationId can’t be null. Added “WHERE orgst.SchoolOrganizationId is not null to the end of the School level insert code.
4. CIID-4228: Verified/modified all encapsulated code stored procedures to check the new DataCollectionId field in joins.
   * Verified/modified all encapsulated code stored procedures to check that the DataCollectionId fields in joins were wrapped in ISNULL.
5. CIID-3960: Added state server URL to Wijmo license.
6. CIID-4253: Made the Staging Context connection string configurable.
   * The connection string for staging context was hard coded into the code. This posed a

security risk and was not a good practice. Modified the code to move it into a configuration file.

1. CIID-4332: End to End Data Migrations.
   * Verified CEDS changes are running from staging to reports for file specifications submitted via Generate output in the past. Each data migration should run and populate data into the Reports table. Migrations affected: Assessments, Discipline, Exiting and Directory Lite.
2. CIID-3989: Removed the calls to the Data Population Summary from the new wrapper scripts.
   * The wrapper scripts call each of the stored procedures needed to move the data to the RDS. Included in that set of stored procedures are the ones that populate the Data Population Summary. Those are not necessary for ED_Facts,_ and they have not been vetted fully with this release, so they were commented out for now.
3. CIID-4322: FS005, FS006, FS007, FS009, FS088, FS143 – The Disability Category (IDEA) permitted value “MR-Intellectual disability,” was replaced with “ID–Intellectual disability.”
4. CIID-4336: The metadata for the EDFacts 17.2 file specifications SY 2020-21 was rolled over for Generate. Files rolled over:
   * FS054, FS070, FS086, FS099, FS112, FS118, FS121, FS122, FS144, FS145, FS163, FS165, FS170, FS194, FS195, FS203.

### Enhancements <a href="#enhancements" id="enhancements"></a>

1. CIID-2832: CEDS table “PersonHomelessness” was updated, and the migration was adjusted.
   * Modified the CEDS (ODS) PersonHomelessness table and adjusted the migration to reflect the changes in CEDS Version 9. In Generate, the PersonId is both the PrimaryKey and the ForeignKey. There is no PersonHomelessnessId. To reflect the CEDS Version 9 schema, the ODS.PersonHomelessness table was updated to include the following columns in this order:
     * PersonHomelessnessId (PK, int, not null)
     * PersonId (FK, int, not null)
     * HomelessnessStatus (bit, not null)
     * RecordStartDateTime (datetime, null)
     * RecordEndDateTime (datetime, null)
     * RefHomelessNighttimeResidenceId (FK, int, not null)
   * Modified any encapsulated code that uses this table and verified and/or modified any RDS migration code that uses this table.
   * Verified and/or modified any RDS migration code that uses this table.
2. CIID-2834: CEDS 9.0 Update – CEDS Table K12StudentAcademicRecord Structural Change
   * Modified the Generate K12StudentAcademicRecord table to match the CEDS Version 9 table because a state attempted to load this table and they received a primary key constraint error because Generate still used the OrganizationPersonRoleId as the primary key/foreign key. Below is the updated CEDS layout:

\[K12StudentAcademicRecordId] \[int] IDENTITY(1,1) NOT NULL, \[OrganizationPersonRoleId] \[int] NOT NULL, \[CreditsAttemptedCumulative] \[decimal]\(18, 0) NULL, \[CreditsEarnedCumulative] \[decimal]\(18, 0) NULL, \[GradePointsEarnedCumulative] \[decimal]\(18, 0) NULL, \[GradePointAverageCumulative] \[decimal]\(18, 0) NULL, \[ProjectedGraduationDate] \[datetime] NULL, \[HighSchoolStudentClassRank] \[int] NULL,

\[ClassRankingDate] \[datetime] NULL, \[TotalNumberInClass] \[int] NULL, \[DiplomaOrCredentialAwardDate] \[datetime] NULL, \[RefGpaWeightedIndicatorId] \[int] NULL, \[RefHighSchoolDiplomaTypeId] \[int] NULL, \[RefHighSchoolDiplomaDistinctionTypeId] \[int] NULL, \[RefTechnologyLiteracyStatusId] \[int] NULL, \[RefPsEnrollmentActionId] \[int] NULL, \[RefPreAndPostTestIndicatorId] \[int] NULL, \[RefProfessionalTechnicalCredentialTypeId] \[int] NULL, \[RefProgressLevelId] \[int] NULL, \[RecordStartDateTime] \[datetime] NULL, \[RecordEndDateTime] \[datetime] NULL,

*
  * Reviewed and modified any Encapsulated Code that inserted or updated this table.
  * Reviewed/modified any RDS migration code that reads from this table.

1. CIID-3900: Upgraded the CEDS IDS to the OSC V9, including changing the schema name
   * Created a script to move the IDS tables from the ODS schema to the DBO schema.
2. CIID-3901: Upgraded the CEDS data warehouse to the OSC V9.
   * Upgraded the CEDS Data Warehouse so it aligns to the CEDS Open Source Community v9 by changing table and column names to official CEDS data warehouse names.
3. CIID-3903: Updated report migrations to use new CEDS DW column names.
   * Updated report metadata.
   * Updated Get\_CountSQL and Create\_ReportData stored procedures.
4. CIID-4229: Updated staging migrations to use new CEDS DW column names.
5. CIID-4230: Updated report migrations to use new CEDS DW column names.
   * Updated report metadata.
   * Updated Get\_CountSQL and Create\_ReportData stored procedures.

### Compatible Systems <a href="#compatible-systems" id="compatible-systems"></a>

Generate was tested on the following operating systems and browsers:

* Windows 10 Pro
* Google Chrome, Version 68 0.3440.106 (Official Build) (64-bit), Firefox Quantum 61.01 (64 bit), and Internet Explorer 11, 1387,15063.0
