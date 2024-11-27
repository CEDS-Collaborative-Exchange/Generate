---
description: >-
  Generate allows states to create a backup or “snapshot” of staging tables. 
  This is an optional utility that can be executed as needed or embedded into
  the State’s ETL workflow logic.
---

# Staging Table Snapshot

## Overview

The Generate Staging Table Snapshot Utility (“Snapshot Utility”) provides a method to create a backup copy of staging tables for future use and reference after an ETL has populated Generate’s staging tables.

### Use Cases

1. To ensure consistency across all ED_Facts_ reports for a given year, it's recommended to retain and reuse the Directory data collected for each submission year. This approach prevents the introduction of errors or inconsistencies that might arise from reloading and updating the Directory data with new organizations or changes to existing ones that were not part of the initial report.
2. Developers can preserve data in staging tables across ETL executions. This practice facilitates the comparison of changes and the validation of ETL logic.

***

## How to Run the Snapshot Utility

{% hint style="info" %}
The Staging Table Snapshot Utility is not available in the Generate user interface – it can only be used withing **SQL Server Management Studio** **(SSMS)**.
{% endhint %}

{% hint style="info" %}
The Snapshot Utility would be executed **AFTER** running an ETL to populate Staging tables.
{% endhint %}

To execute the Snapshot Utility, run the following command in SSMS with the desired parameters:

```
Utilities.CreateSnapshotFromStaging

@SchoolYear = 2023,
@ReportCode = 'C029'
```

<figure><img src="../../.gitbook/assets/Execute the Snapshot.PNG" alt="Screenshot of SQL Server Management Studio displaying the command line execution of the Create Snapshot From Staging utility"><figcaption><p>How to execute the Create Snapshot From Staging utility from SSMS</p></figcaption></figure>

{% hint style="warning" %}
The `@SchoolYear` value should correspond to the data that currently exists in Staging tables.
{% endhint %}

The Snapshot Utility will make backup copies of all staging tables that pertain to the `@ReportCode` and place them in the **Source schema** in the Generate database.  For example, for `@ReportCode = '`**`C029`**`'` these tables are:

* `Staging.K12Organization`
* `Staging.OrganizationAddress`
* `Staging.OrganizationFederalFunding`
* `Staging.OrganizationPhone`
* `Staging.OrganizationProgramType`
* `Staging.StateDetail`

<figure><img src="../../.gitbook/assets/Capture 2.PNG" alt="Screenshot of the server folder tree in the Generate database with Tables expanded to show the newly created"><figcaption><p>Where to find the newly created tables from the Create Snapshot From Staging utility</p></figcaption></figure>

The tables are an identical copy of the Staging table(s), with the addition of three columns:

* **SnapshotReportCode** – the report code for which the snapshot data applies
* **SnapshotSchoolYear** – the school year for which the snapshot data applies
* **SnapshotDate** – the date the snapshot was created

These additional columns provide features to retain backups for multiple school years, and to retain a backup for multiple report codes in the same table.&#x20;

> **Example**: After running your Child Count ETL, you could run the Snapshot Utility for C002 (a Child Count file) for 2023 to retain data from `Staging.K12Enrollment` and other related staging tables. Later in the year after running your Exiting ETL, you could run the Snapshot Utility for C009 (Exiting) to retain data from the staging tables. Both sets of data (Child Count and Exiting) will be available in each snapshot table, allowing you to review and compare if needed.

{% hint style="warning" %}
**Note:** The Snapshot Utility retains a single instance of data in each table for a particular _School Year_ and _Report Code_.  This means you cannot retain multiple “versions” of data for K12Enrollment for 2023 for C002. &#x20;

***

For example, while you could have Snapshot data in `Source.K12Enrollment` for 2023 for C002, C089, C009, etc., you cannot have data for 2023 C002 “Version 1”, “Version 2”, etc. &#x20;

* [ ] That may be a future enhancement to the Snapshot Utility if desired.
{% endhint %}

If a Snapshot table does not yet exist for a Staging table, it will be created. If a Snapshot table already exists for a Staging table, then the data in the table will either be appended or replaced, depending on if data already exists in the Snapshot table for the specified School Year and Report Code.

## Integrating the Snapshot Utility

The Snapshot Utility could be coded within an ETL to automatically make a backup copy of the related Staging Tables each time the ETL is executed. The following diagram shows how this feature might be leveraged at a State to reuse a Directory snapshot for Child Count reporting.

<figure><img src="../../.gitbook/assets/Staging Snapshot Process.jpg" alt="Diagram illustrating the Source-to-Staging ETL process. A flowchart depicts three main stages: Source-to-Staging_Directory, Snapshot Utility, and Source-to-Staging_ChildCount. Source-to-Staging_Directory ETL: The diagram shows data flowing from the source directory system to the staging directory. A note indicates that the Snapshot Utility may be embedded to automatically create a copy of all directory data. Snapshot Utility: A separate process, represented by a box, runs automatically to create or update backup copies of the staging tables in the source schema. Source-to-Staging_ChildCount ETL: This stage involves pulling required organization information directly from the snapshot tables instead of the directory source system. This approach ensures alignment between directory information used for child count and submitted C029 data. Additionally, it may enhance ETL performance by eliminating the need to access another system or database for directory data. Overall, the diagram illustrates a streamlined ETL process optimizing data flow and performance."><figcaption></figcaption></figure>

1. In the Source-to-Staging\_Directory ETL, the Snapshot Utility could be embedded to run automatically to create a copy of all Directory data.
2. The Snapshot Utility will run automatically and create/update backup copies of the Staging tables in the Source schema.
3. In the Source-to-Staging\_ChildCount ETL, required Organization information can be pulled directly from the Snapshot tables rather than from the Directory source system.  This not only assures that Directory information used for Child Count will match the submitted C029 data, but may improve ETL performance by not requiring the ETL to jump to another system/database to pull Directory data.&#x20;

Below is an example of code that could be used to restore data from a Snapshot table into a Staging table. In this case, data from `Source.K12Organization` for a school year for C029 will be restored to `Staging.K12Organization` for use with Child Count.

```
TRUNCATE TABLE Staging.K12Organization

		insert into Staging.K12Organization (
			LeaIdentifierSea,
			PriorLeaIdentifierSea, 
			LeaIdentifierNCES,
			LEA_SupervisoryUnionIdentificationNumber,
			LeaOrganizationName,
			LEA_WebSiteAddress,
			LEA_OperationalStatus, 
			LEA_OperationalStatusEffectiveDate,
			LEA_CharterLEAStatus,
			LEA_CharterSchoolIndicator,
			LEA_Type,
			LEA_McKinneyVentoSubgrantRecipient,
			LEA_GunFreeSchoolsActReportingStatus,
			LEA_TitleIinstructionalService,
			LEA_TitleIProgramType,
			LEA_K12LeaTitleISupportService,
			LEA_MepProjectType,
			LEA_IsReportedFederally,
			LEA_RecordStartDateTime,
			LEA_RecordEndDateTime,
			SchoolIdentifierSea,
			PriorSchoolIdentifierSea,
			SchoolIdentifierNCES,
			SchoolOrganizationName,
			School_WebSiteAddress,
			School_OperationalStatus, 
			School_OperationalStatusEffectiveDate,
			School_Type,
			School_MagnetOrSpecialProgramEmphasisSchool,
			School_SharedTimeIndicator,
			School_VirtualSchoolStatus,
			School_NationalSchoolLunchProgramStatus,
			School_ReconstitutedStatus,
			School_CharterSchoolIndicator,
			School_CharterSchoolOpenEnrollmentIndicator,
			School_CharterSchoolFEIN,
			School_CharterSchoolFEIN_Update,
			School_CharterContractIDNumber,
			School_CharterContractApprovalDate,
			School_CharterContractRenewalDate,
			School_CharterPrimaryAuthorizer,
			School_CharterSecondaryAuthorizer,
			School_StatePovertyDesignation,
			School_SchoolImprovementAllocation,
			School_IndicatorStatusType,
			School_GunFreeSchoolsActReportingStatus,
			School_ProgressAchievingEnglishLanguageProficiencyIndicatorType,
			School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus,
			School_SchoolDangerousStatus,
			School_TitleIPartASchoolDesignation,
			School_ComprehensiveAndTargetedSupport,
			School_ComprehensiveSupport,
			School_TargetedSupport,
			School_ConsolidatedMigrantEducationProgramFundsStatus,
			School_MigrantEducationProgramProjectType,
			School_AdministrativeFundingControl,
			School_IsReportedFederally,
			School_RecordStartDateTime,
			School_RecordEndDateTime,
			SchoolYear)

		select DISTINCT
			LeaIdentifierSea,
			PriorLeaIdentifierSea, 
			LeaIdentifierNCES,
			LEA_SupervisoryUnionIdentificationNumber,
			LeaOrganizationName,
			LEA_WebSiteAddress,
			LEA_OperationalStatus, 
			LEA_OperationalStatusEffectiveDate,
			LEA_CharterLEAStatus,
			LEA_CharterSchoolIndicator,
			LEA_Type,
			LEA_McKinneyVentoSubgrantRecipient,
			LEA_GunFreeSchoolsActReportingStatus,
			LEA_TitleIinstructionalService,
			LEA_TitleIProgramType,
			LEA_K12LeaTitleISupportService,
			LEA_MepProjectType,
			LEA_IsReportedFederally,
			LEA_RecordStartDateTime,
			LEA_RecordEndDateTime,
			SchoolIdentifierSea,
			PriorSchoolIdentifierSea, 
			SchoolIdentifierNCES,
			SchoolOrganizationName,
			School_WebSiteAddress,
			School_OperationalStatus, 
			School_OperationalStatusEffectiveDate,
			School_Type,
			School_MagnetOrSpecialProgramEmphasisSchool,
			School_SharedTimeIndicator,
			School_VirtualSchoolStatus,
			School_NationalSchoolLunchProgramStatus,
			School_ReconstitutedStatus,
			School_CharterSchoolIndicator,
			School_CharterSchoolOpenEnrollmentIndicator,
			School_CharterSchoolFEIN,
			School_CharterSchoolFEIN_Update,
			School_CharterContractIDNumber,
			School_CharterContractApprovalDate,
			School_CharterContractRenewalDate,
			School_CharterPrimaryAuthorizer,
			School_CharterSecondaryAuthorizer,
			School_StatePovertyDesignation,
			School_SchoolImprovementAllocation,
			School_IndicatorStatusType,
			School_GunFreeSchoolsActReportingStatus,
			School_ProgressAchievingEnglishLanguageProficiencyIndicatorType,
			School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus,
			School_SchoolDangerousStatus,
			School_TitleIPartASchoolDesignation,
			School_ComprehensiveAndTargetedSupport,
			School_ComprehensiveSupport,
			School_TargetedSupport,
			School_ConsolidatedMigrantEducationProgramFundsStatus,
			School_MigrantEducationProgramProjectType,
			School_AdministrativeFundingControl,
			School_IsReportedFederally,
			School_RecordStartDateTime,
			School_RecordEndDateTime,
			SchoolYear
		from source.K12Organization
		where SchoolYear = @SchoolYear
		and ReportCode = 'C029'

```

## Summary

This documentation will be updated as changes are made to Generate and the utilities within Generate.

***

## Office Hour Demo

{% embed url="https://youtu.be/4UbMWUf8LH4?feature=shared&t=1227" %}
Demonstration of the Staging Table Snapshot from the Generate 11.3 Office Hour
{% endembed %}
