---
description: Generate Release Notes Version 3.5
---

# Release Notes 3.5

### Introduction <a href="#bookmark1" id="bookmark1"></a>

The purpose of this document is to communicate the technical and general updates made to Generate 3.5, released in July 2020.

### Technical Release Summary <a href="#bookmark2" id="bookmark2"></a>

Several changes were made to the Staging environment. Refer to the “Staging Tables” section below to

learn how your source-to-Staging ETL may be affected.

### General Release Summary <a href="#bookmark3" id="bookmark3"></a>

Generate Version 3.5 includes updates to reports, the ETL (Data Store), and defect resolution.

### Updated Reports <a href="#bookmark4" id="bookmark4"></a>

The following Standard E&#x44;_&#x46;acts_ reports were updated in this release.

| Report | Resolved Defect                                                                                                                                                                                                                         |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 005    | Resolved issue where SEA level was not excluding records where StudentCount = 0.                                                                                                                                                        |
| 029    | <ul><li>Resolved issue where “effective date” was displaying incorrectly on the report.</li><li>Resolved issue where telephone number was not displaying as a 10-digit number.</li></ul>                                                |
| 033    | Added direct certificate information to the report.                                                                                                                                                                                     |
| 035    | <ul><li>Added Federal Programs Funding Allocation Types to the report to address ED<em>Facts</em> reporting requirements.</li><li>Added Connection link to the report.</li></ul>                                                        |
| 039    | <ul><li>Resolved issue in user interface where LEA button was showing school level records.</li><li>Resolved issue where LEA name was not displaying on the report header.</li></ul>                                                    |
| 052    | Resolved issue where grades = AE and 13 were missing from the report.                                                                                                                                                                   |
| 059    | <ul><li><p>Added new permitted values to report:</p><ul><li>SCHPSYCH (School Psychologist)</li><li>STUSUPWOPSYCH (Student Support Services Staff w/out Psychology)</li></ul></li><li>Removed STUSUP (Student Services Staff).</li></ul> |
| 070    | Resolved issue where non-special education teachers were being included in the report.                                                                                                                                                  |

| 112 | Resolved issue where non-special education teachers were being included in the report.                                                                                                                                                                                                                                                                                         |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 116 | <p>Updated report to address ED<em>Facts</em> reporting changes for SY2019-20.</p><ul><li>Data Group 648 (DG648): Delete data element 2 Category set B Grade Level (Basic w/13) by Language Instruction Educational Program Type).</li><li>Added new Data Group 849 with one data element Grade Level (Basic w/13) by Language Instruction Educational Program Type.</li></ul> |
| 118 | <ul><li>Added new data element / Category Set H (Racial Ethnic).</li><li>Resolved issue where permitted values were missing from the submission files.</li></ul>                                                                                                                                                                                                               |
| 175 | <ul><li>Removed all category sets and subtotals for Performance Level.</li><li>Added Proficiency Status to all category sets and subtotals.</li><li>Added permitted value of MISSING.</li></ul>                                                                                                                                                                                |
| 178 | <ul><li>Removed all category sets and subtotals for Performance Level.</li><li>Added Proficiency Status to all category sets and subtotals.</li><li>Added permitted value of MISSING.</li></ul>                                                                                                                                                                                |
| 179 | <ul><li>Removed all category sets and subtotals for Performance Level.</li><li>Added Proficiency Status to all category sets and subtotals.</li><li>Added permitted value of MISSING.</li></ul>                                                                                                                                                                                |
| 196 | <p>Updated permitted values for SY2019-20 EDFacts reporting.</p><ul><li>Changed permitted value CMO to CHARCMO.</li><li>Changed permitted value EMO to CHAREMO.</li><li>Added permitted value CHARSMNP.</li><li>Added permitted value CHARSMFP.</li></ul>                                                                                                                      |
| 206 | <ul><li>Modified the application metadata to add new dimensions for SY19-20 file specification updates.</li><li>Made changes to user interface to add additional categories for SY19-20 file specification updates.</li></ul>                                                                                                                                                  |
| 207 | <ul><li>Modified metadata script to add new report for SY2019-20.</li><li>Implement report user interface.</li><li>Removed SY2018-19 from the dropdown list as that year is not applicable for the new report per ED<em>Facts</em> file specifications.</li></ul>                                                                                                              |

### Updated Pages <a href="#bookmark5" id="bookmark5"></a>

### Toggle <a href="#bookmark6" id="bookmark6"></a>

Resolved issue with save functionality.

### Data Store <a href="#bookmark7" id="bookmark7"></a>

1. Updated assessment ETL to use the school year end date for demographics.
2. Resolved issue with Child Count related to Hispanic Latino Ethnicity and Race Type:
   * When HispanicLatinoEthnicity was set to 1 and a RaceType value was set that was not 'HI7', two records were created for the student, one for the racetype selected and one for HI7. Now, if HispanicLatinoEthnicity is set to 1, the student is Hispanic, regardless of what the RaceType value is.
3. Resolved issue with task\_cursor for ODS migrations so that stored procedures now run in TaskSequence order rather than DataMigrationTaskId order.
4. Updated stored procedures for FS121 and FS122 to filter out 36 month, 12 month, and school year migrant students if their eligibility is before the performance period. Also validated that MEP EligibilityExpirationDate is greater than the beginning of the reporting period.
5. Updated FactStudentCount table to mark students as McKinney program recipients.
6. Resolved issue where metadata script was populating the wrong TableTypeId in app.CategorySets table.
7. Resolved issue where extra address records were being attached to some school records and cleaned up code for all three levels of address handling (SEA, LEA, and Schools).
8. Resolved duplicate records issue in RDS.FactOrganizationCounts table.
9. Updated Encapsulated Code to load Charter School Authorizers from Staging to the IDS.
10. Updated Encapsulated Code to load CharterLeaStatus into the IDS.
11. Resolved issue where PersonStatus encapsulated code was missing Section 504 and Immigrant programs code:
    * Added code to fill in the OrganizationId\_LEA\_Program\_Section504 value in the staging table.
    * Added code to set the OrganizationId\_LEA\_Program\_Immigrant value in the staging table.
    * Reviewed all error codes related to Section 504 and Immigrant programs code.
    * Added null handling for all references to the pers.StatusEndDates field in the Staging.PersonStatus table.
    * Added fields to Staging.Organization to capture organization data needed later for the PersonStatus table:
      * NewImmigrantProgram
      * LEAToImmigrantProgram\_OrganizationRelationshipId
      * SchoolToImmigrantProgram\_OrganizationRelationshipId
12. Resolved issue where Organization encapsulated code was not populating the neglected/delinquent IDs back into the staging table.
13. Updated Organization encapsulated code to include handling for Secondary Charter School Authorizers:
    * Added a record to ODS.RefOrganizationRelationship for Secondary Authorizer.
    * Created a @SecondaryAuthorizingBodyOrganizationRelationship variable.
    * Expanded the ODS>OrganizationRelationship MERGE INTO statement to include the secondary authorizer.
14. Added code-block for sproc Empty\_Reports used in DataMigrationTasks for 029 with the

parameter ‘directory’.

1. Made corrections to PersonStatus encapsulated code to fix missing Section 504 and Immigrant programs code:
   * Added code to fill in the OrganizationId\_LEA\_Program\_Section504 value.
   * Added “AND OrganizationId\_LEA\_Program\_Section504 is NOT NULL to the insert

statement to ensure that the code processes without error regardless of whether it’s null

or not.

*
  * Reviewed all error codes to make sure they represent step 05 and then reviewed to make sure they are different.

1. Resolved issue where LEA Migration did not include the Charter LEA status.
2. Resolved issue in Staging.StateDetail where the SEAContact\_PersonalTitleOrPrefix was not being passed through to reports.
3. Updated FS206:
   * Modified the table rds-DimComprehensiveAndTargetedSupports for SY19-20 file specification updates.
   * Added new dimensions to FactOrganizationCountReports table for SY19-20 file specification updates.
   * Modified the report creation and data fetching stored procedures for SY19-20 file specification updates.
4. Resolved issue in the ODS migration where user defined task sequence was being reset after a run.
5. Populated the new dimension tables to implement FS207 report.
6. Updated RDS migration tables to include FS207 report.
7. Modified tier changes (Controller & Services) to implement FS207 report.
8. Removed code from Migrate\_DimPersonnelStatuses so that it is not dependent on Credential Type.
9. Added support for SSL connection to Active Directory.
10. Removed "Updated\_OperationalStatus" and "Updated\_OperationalStatusEffectiveDate" fields from Staging.Organization and replaced them with one set of "OperationalStatus" and "OperationalStatusEffectiveDate". (See Staging Tables)
11. Resolved issue with FS052 report where Data ID was not populating after migration was run.
12. Split Charter School Management Organization records from DimCharterSchoolAuthorizers because management organizations need their own DIM table. This table should have all directory information, EIN, and Charter School Management Organization Type values. It is a type 2 slowly changing dimension.
    * Added DimCharterSchoolManagementOrganizationId to FactOrganizationCounts as a nullable field.
    * Moved DimCharterSchoolAuthorizerIdPrimary and DimCharterSchoolAuthorizerIdSecondary to FactOrganizationCounts.
    * Added DimCharterSchoolManagementOrganizationId to FactOrganizationCounts.
13. Added “StateAbbreviation” to the Staging.OrganizationAddress table. (See Staging Tables)
14. Corrected encapsulated code that reads from Staging.Organization.Address to only read from the StateAbbreviation column and no longer read from the RefStateId or AddressStateANSICode columns unless they are populated by using the StateAbbreviation column. (See Staging Tables)
15. Added "RunAsTest" capabilities to RDS.Migrate\_OrganizationCounts so implementers can diagnose issues presented during the RDS data load process.
16. Resolved issue where inactive schools were migrating in FactOrganizationCounts table.
17. Added debug code to each of the RDS student-level dimension migration stored procedures that will make it much easier to investigate specific dimension totals when completing migrations. The complete list of stored procedures affected is:
    * Migrate\_DimAges
    * Migrate\_DimAssessments
    * Migrate\_DimAssessmentStatuses
    * Migrate\_DimAttendance
    * Migrate\_DimCohortStatuses
    * Migrate\_DimCteStatuses
    * Migrate\_DimDemographics
    * Migrate\_DimDisciplines
    * Migrate\_DimEnrollments
    * Migrate\_DimEnrollmentStatuses
    * Migrate\_DimFirearms
    * Migrate\_DimFirearmsDiscipline
    * Migrate\_DimGradeLevels
    * Migrate\_DimIdeaStatuses
    * Migrate\_DimLanguage
    * Migrate\_DimMigrant
    * Migrate\_DimNoDProgramStatuses
    * Migrate\_DimProgramStatuses
    * Migrate\_DimRaces
    * Migrate\_DimStudentStatuses
    * Migrate\_DimTitle1Statuses
    * Migrate\_DimTitleIIIStatuses
18. Added “phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId” to

Migrate\_OrganizationCounts to qualify the phone number used in the migration.

1. Corrected issue where C052 was reporting zero counts for school that have ReportedFederally = 0 in the DimSchools Table.

### Staging Tables <a href="#bookmark8" id="bookmark8"></a>

The following updates were made to the staging tables to simply processes.

1. The CharterSchoolAuthorizer table replaced the CharterSchoolApprovalAgency table.
2. Simplified the naming and population of the Operational Status for both LEAs and Schools. In place of the three fields previously used for each type of organization to capture current and updated status/date, there are now only two fields for each type of organization:
   * LEA\_OperationalStatus
   * LEA\_OperationalStatusEffectiveDate
   * School\_OperationalStatus
   * School\_OperationalStatusEffectiveDate
3. Simplified the population of Address information for Organizations in Staging.OrganizationAddress. Replaced fields RefStateId and AddressStateANSICode with AddressStateAbbreviation. Instead of finding and populating code values for addresses, simply provide the 2-letter state abbreviation.
4. Clarified the population of information for the SEA Contact in the Staging.StateDetail

table. Updated field SeaContact\_PersonalTitleOrPrefix to SeaContact\_PositionTitle to better reflect the data that is expected to be loaded into that field for use in the Directory file.

1. Added new fields to build on the data that the staging tables can accommodate. Two new fields were added to Staging.Organization:
   * LEA\_IsReportedFederally
   * School\_IsReportedFederally.

Neither field is required. If left null for any organization, that organization will be treated as one that should be included in any federal reporting. If the state wants/needs to load either LEAs or Schools to track in their longitudinal data but does not want them included in any federal reporting, that option now exists.

1. Corrected issues with Merge into ODS.OrganizationPersonRoleRelationship would fail if either the OPRId\_School or OPRId\_Lea in staging.enrollment were null.

### General <a href="#bookmark9" id="bookmark9"></a>

Rolled over metadata for SY2019-20 files from previous year.

### Compatible Systems <a href="#bookmark10" id="bookmark10"></a>

Generate was tested on the following operating systems and browsers:

1. Windows 10 Pro
2. Google Chrome, Version 68 0.3440.106 (Official Build) )64-bit), and Firefox Quantum 61.01 (64 bit)
