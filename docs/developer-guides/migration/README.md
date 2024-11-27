---
icon: person-to-portal
---

# Migration

## Generate Data Migration Overview <a href="#toc108711244" id="toc108711244"></a>

The Generate SQL Server database contains a set of stored procedures and data layers for transforming data into the final “Reports Tables” layer used by the web-based application to create ED_Facts_ reports.

<figure><img src="../../.gitbook/assets/image (199).png" alt=""><figcaption></figcaption></figure>

### Data Layers

<table><thead><tr><th width="290">Data Layer</th><th>Description</th></tr></thead><tbody><tr><td><strong>Staging Tables</strong></td><td>Tables are flattened to make it easy to ETL data into the Staging Tables. Built specifically for data needed for Generate. Load raw data into this layer.</td></tr><tr><td><strong>CEDS Data Warehouse</strong></td><td>A Star Schema database model used to store atomic level data longitudinally.</td></tr><tr><td><strong>CEDS Semantic Layer</strong></td><td>Flattened tables used to store aggregate report data. This structure is ideal for populating reports rapidly.</td></tr></tbody></table>

### Extract, Transform, Load (ETL) Stored Procedures

All Generate data migrations are accomplished by running SQL Server Stored Procedures. They can be run either from the Generate Web-based application “Data Store” pages or directly through SQL Server. Running from the Web-based application is recommended, especially when running Data Warehouse and Report Migration steps. Code-snippets below are included as examples of how to run Generate ETL Stored Procedures from SQL Server Management Studio (SSMS). Reach out to your technical assistance (TA) provider if any questions arise.

<table><thead><tr><th width="199"></th><th>SEA Source to   Staging Migration </th><th>Data Warehouse   Migration </th><th>Report Migration </th></tr></thead><tbody><tr><td><p>Generate Web- based application (user interface)</p><p>Button</p></td><td>Staging Migration</td><td>RDS Migration</td><td>Report Migration</td></tr><tr><td>Source Schema</td><td><p>SEA Source</p><p>Schema</p></td><td>Generate.Staging</td><td><p>Generate.RDS (Dimension</p><p>and Fact tables)</p></td></tr><tr><td><p>Destination</p><p>Schema</p></td><td>Generate.Staging</td><td>Generate.RDS</td><td><p>Generate.RDS (Report</p><p>tables)</p></td></tr></tbody></table>

#### SEA Source to Staging

<figure><img src="../../.gitbook/assets/image (200).png" alt=""><figcaption></figcaption></figure>

These procedures migrate data from the _**SEA Source Systems**_ to the Generate _**Staging Tables**_. The approach to creating these stored procedures is to create a single stored procedure for each domain (such as Child Count, Discipline, Exiting, etc.) that migrates data for that domain into the staging tables. By default, Generate has empty template scripts available by data domain (example: `Source.[Source-to-Staging_ChildCount]`) which have a record in the `App.DataMigrationTasks`table.&#x20;

These stored procedures can be run from the Generate Web Application using the Staging Data Migration option.&#x20;

The Generate Web Application “[Data Store](../../user-guide/settings/data-store.md)” migration pages use the `App.DataMigrationTasks`table to determine what stored procedures can be run from the web interface. Using one of these template scripts is recommended for new SEA Source to Staging ETL because no updates to `App.DataMigrationTasks`records is needed to migrate using one of these stored procedures. These stored procedures can be run from the Generate Web Application using the Staging  Migration option.&#x20;

Reference the [ETL Documentation Template](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074)[ ](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074)for each domain to get a list of the tables/fields that need to be populated to create this ETL.

These stored procedures have a school year parameter that should be passed in if run from SQL Server Management Studio (note: the @SchoolYear SMALLINT parameter lines up with how the Generate Web App calls these scripts). For example, to run with 2023 school year data:

> **EXECUTE** \[Staging].\[Migrate\_SourceToStaging\_Organization] 2023

#### Data Warehouse Migration <a href="#data_warehouse_migration" id="data_warehouse_migration"></a>

<figure><img src="../../.gitbook/assets/image (201).png" alt=""><figcaption></figcaption></figure>

These procedures migrate data from the _**CEDS Staging Environment**_  to the _**CEDS Data Warehouse**_.

Starting in Generate version 3.7, wrapper scripts are available for each domain of data that is run at this stage. These wrapper scripts can be selected from the Generate web application or run from the SQL Server database. The wrapper scripts follow this naming convention:

> **App.Wrapper\_Migrate\_Directory\_to\_RDS**

The wrapper scripts call a set of stored procedures used at this stage:

> **\[Staging].\[Staging-to-DimSeas] 'directory', NULL, 0**
>
> **\[Staging].\[Staging-to-DimLeas] 'directory', NULL, 0**
>
> **\[Staging].\[Staging-to-DimK12Schools] NULL, 0**
>
> **\[Staging].\[Staging-to-DimCharterSchoolAuthorizers]**
>
> **\[Staging].\[Staging-to-DimCharterSchoolManagementOrganizations]**
>
> **\[Staging].\[Staging-to-FactOrganizationCounts]**&#x20;

* These stored procedures can be run from the “Data Store” page within the Generate web application using the RDS Migration option.

```sql
UPDATE rds.DimSchoolYearDataMigrationTypes
SET IsSelected = 0
UPDATE rds.DimSchoolYearDataMigrationTypes
SET IsSelected = 1
FROM rds.DimSchoolYearDataMigrationTypes sydmt
JOIN rds.DimSchoolYears sy
on sydmt.DimSchoolYearId = sy.DimSchoolYearId
WHERE DimDateId = 11 –2020-21
EXEC
WHERE SchoolYear = 2020 -- Update to the year you are migrating
EXEC
Exec [App].[Wrapper_Migrate_Directory_to_RDS]
```

#### Report Migration <a href="#report_migration" id="report_migration"></a>

* The RDS.CreateReports Stored Procedure migrates data from the **Staging** to the **Report Tables.**
* These stored procedures can be run from the Generate Web Application using the Report Migration option.
* The _RDS.CreateReports_ Stored Procedure kicks off the _Create\_ReportData_ Stored Procedure for each ED_Facts_ Report based on the fact type for that report. Fact types can be found in the _App.FactTables_ table and information for which fact types are used is stored in the _FactTableId_ field of the _`App.GenerateReports`_.
* The _`RDS.Create_ReportData`_ Stored Procedure uses Dynamic SQL to migrate data into the reporting tables.
* The Stored Procedures at this migration stage do not take a School Year parameter. They loop through school years based on the selections in the web application front end which are stored in `RDS.DimSchoolYearDataMigrationTypes`. These can be updated manually by setting the IsSelect field to 1 for all years you wish to run from SQL Server Management Studio. For example, when running Directory data migrations from SQL Server Management Studio the code would look like this:

```sql
UPDATE app.GenerateReports
SET IsLocked = 1
WHERE ReportCode IN ('c029', 'c039')
EXEC RDS.Create_Reports 'directory', 0, 'organizationcounts'
```

### Source System Reference Data Mapping <a href="#toc108711247" id="toc108711247"></a>

The Generate table Staging.SourceSystemReferenceData is used in the _**Staging Encapsulated Code Migration**_ stage to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year. If a migration is run and no mapping exist for the corresponding school year, then the Encapsulated Code will update the Staging.SourceSystemReferenceData table with a copy of mapping records from the most recent school year.

The `Staging.SourceSystemReferenceData` tables are noted below:

| K12Staff                          |
| --------------------------------- |
| RefK12StaffClassification         |
| RefSpecialEducationStaffCategory  |
| RefSpecialEducationAgeGroupTaught |
| RefTitleIProgramStaffCategory     |
| RefCredentialType                 |

| Assessments                               |
| ----------------------------------------- |
| RefAcademicSubject                        |
| RefAssessmentPurpose                      |
| RefAssessmentType                         |
| RefAssessmentTypeChildrenWithDisabilities |
| AssessmentPerformanceLevel\_Identifier    |
| RefAssessmentParticipationIndicator       |
| RefGradeLevel (Filter = ‘000126’)         |
| RefAssessmentReasonNotCompleting          |

| Discipline                     |
| ------------------------------ |
| RefFirearmType                 |
| RefDisciplineReason            |
| RefDisciplinaryActionTaken     |
| RefIdeaInterimRemoval          |
| RefIDEAInterimRemovalReason    |
| RefDisciplineMethodOfCwd       |
| RefDisciplineMethodFirearms    |
| RefIDEADisciplineMethodFirearm |

| PPSE                                   |
| -------------------------------------- |
| RefIDEAEducationalEnvironmentEC        |
| RefIDEAEducationalEnvironmentSchoolAge |
| RefSpecialEducationExitReason          |

| PersonStatus                         |
| ------------------------------------ |
| RefHomelessNighttimeResidence        |
| RefLanguage                          |
| RefMilitaryConnectedStudentIndicator |
| RefDisabilityType                    |
| RefFoodServiceEligibility            |

| PersonRace  |
| ----------- |
| RefRace     |

| K12Enrollment                     |
| --------------------------------- |
| RefSex                            |
| RefExitOrWithdrawalType           |
| RefGradeLevel (Filter = '000100') |
| RefHighSchoolDiplomaType          |

| K12Organization                                               |
| ------------------------------------------------------------- |
| RefOrganizationType (Filter = ‘001156’)                       |
| RefInstitutionTelephoneType                                   |
| RefOperationalStatus (Filter = ‘000174’)                      |
| RefOperationalStatus (Filter = ‘000533’)                      |
| RefCharterSchoolAuthorizerType                                |
| RefLeaType                                                    |
| RefCharterLeaStatus                                           |
| RefK12LeaTitleISupportService                                 |
| RefTitleInstructionalServices                                 |
| efTitleProgramType                                            |
| RefMepProjectType                                             |
| RefSchoolType                                                 |
| RefStatePovertyDesignation                                    |
| RefGradeLevel (Filter = ‘000131’)                             |
| RefOrganizationLocationType                                   |
| RefState                                                      |
| RefOrganizationIdentificationSystem (Filter = ‘Organization’) |
| RefFederalProgramFundingAllocationType                        |
| RefGunFreeSchoolsActReportingStatus                           |
| RefReconstitutedStatus                                        |
| RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus |
| RefTitleISchoolStatus                                         |
| RefComprehensiveAndTargetedSupport                            |
| RefComprehensiveSupport                                       |
| RefTargetedSupport                                            |
| RefSchoolDangerousStatus                                      |
| RefMagnetSpecialProgram                                       |
| RefVirtualSchoolStatus                                        |
| RefNSLPStatus                                                 |

Generate contains validation tools to assist ETL developers in verifying that data has successfully migrated across the Generate data layers. Errors and issues captured in the first stage of data migration (_**SEA Source to Staging Migration**_) are logged to the _Staging._StagingValidationResults table. The logs can be explored from the SQL Server database.

### Staging.StagingValidationResults Table <a href="#toc108711249" id="toc108711249"></a>

The Staging.StagingValidationResults table holds logs of certain errors and issues created during the data migration process. It is designed for troubleshooting and provides information such as stored procedure name, table name, specific error messaging, type of error, and datetime created.

Currently, there is a process that writes to the table:

1. The Stored Procedure **Staging.ValidateStagingData** can be called after each _**SEA Source to Staging Migration**_ Stored Procedure.&#x20;

<table><thead><tr><th width="137.33333333333331">Error Group</th><th width="284">Description</th><th>Logged by Stored Procedure</th></tr></thead><tbody><tr><td>1</td><td>Code Execution Failure</td><td>Staging.ValidateStagingData</td></tr><tr><td>2</td><td>Table Did Not Populate</td><td>Staging.ValidateStagingData</td></tr><tr><td>3</td><td>Field Required Not Populated</td><td>Staging.ValidateStagingData</td></tr><tr><td>4</td><td>Source Value Not In CEDS Option Set Mapping</td><td>Staging.ValidateStagingData</td></tr></tbody></table>

