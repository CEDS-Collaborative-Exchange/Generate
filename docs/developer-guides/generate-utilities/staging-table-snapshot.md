---
description: >-
  Generate allows states to create a backup or “snapshot” of staging tables. 
  This is an optional utility that can be executed as needed or embedded into
  the State’s ETL workflow logic.
---

# Staging Table Snapshot

## Overview

The Generate Staging Table Snapshot Utility (“Snapshot Utility”) provides a method to create a backup copy of Staging tables for future use and reference after an ETL has populated Generate’s staging tables.

### Use Cases

* Retain and reuse Directory data for each submission year. This keeps all E&#x44;_&#x46;acts_ reports consistent. It also avoids changes caused by reloading updated Directory data.
* Preserve Staging table data across ETL executions. This supports change comparisons and ETL validation.

***

## How to Run the Snapshot Utility

{% hint style="info" %}
The Staging Table Snapshot Utility is not available in the Generate user interface. Use **SQL Server Management Studio (SSMS)** instead.
{% endhint %}

{% hint style="info" %}
The Snapshot Utility would be executed **AFTER** running an ETL to populate Staging tables.
{% endhint %}

To execute the Snapshot Utility, run the following command in SSMS with the desired parameters:

{% code title="Create a staging-table snapshot" %}
```sql
DECLARE
@SchoolYear SMALLINT,
@ReportCode as varchar(50)
exec Utilities.CreateSnapshotFromStaging
@SchoolYear = 2026,
@ReportCode = '029'
```
{% endcode %}

{% hint style="warning" %}
The `@SchoolYear` value should correspond to the data that currently exists in Staging tables.
{% endhint %}

The Snapshot Utility creates backup copies of staging tables for the `@ReportCode`. It places them in the **Source** schema in the Generate database. For `@ReportCode = '029'`, these tables include:

* `Source.K12Organization`
* `Source.OrganizationAddress`
* `Source.OrganizationFederalFunding`
* `Source.OrganizationPhone`
* `Source.OrganizationProgramType`
* `Source.StateDetail`

<figure><img src="../../.gitbook/assets/Capture 2.PNG" alt="Generate database Object Explorer with the Tables folder expanded to show newly created snapshot tables."><figcaption><p>Snapshot tables in Object Explorer.</p></figcaption></figure>

The tables are an identical copy of the Staging table(s), with the addition of three columns:

* **SnapshotReportCode** – the report code for which the snapshot data applies
* **SnapshotSchoolYear** – the school year for which the snapshot data applies
* **SnapshotDate** – the date the snapshot was created

These additional columns provide features to retain backups for multiple school years, and to retain a backup for multiple report codes in the same table.

> **Example**: After running your Child Count ETL, you could run the Snapshot Utility for C002 (a Child Count file) for 2023 to retain data from `Staging.K12Enrollment` and other related staging tables. Later in the year after running your Exiting ETL, you could run the Snapshot Utility for C009 (Exiting) to retain data from the staging tables. Both sets of data (Child Count and Exiting) will be available in each snapshot table, allowing you to review and compare if needed.

{% hint style="warning" %}
**Note:** The Snapshot Utility retains one data instance per _School Year_ and _Report Code_ in each table. You cannot retain multiple versions of `K12Enrollment` for school year 2023 and report code 002.

For example, `Source.K12Enrollment` can contain 2023 data for report codes 002, 089, and 009. It cannot contain separate “Version 1” and “Version 2” entries for 2023 and 002.

Multiple versions for the same school year and report code may be supported in a future release.
{% endhint %}

If a Snapshot table does not yet exist for a Staging table, it will be created. If a Snapshot table already exists for a Staging table, then the data in the table will either be appended or replaced, depending on if data already exists in the Snapshot table for the specified School Year and Report Code.

### When Staging table columns change

Generate updates can rename, add, or remove Staging table columns. When a Snapshot table already exists, the Snapshot Utility updates its columns to match the current Staging table before saving data. No action is required.

The utility handles each change as follows:

* **Renamed column:** The matching Snapshot table column is renamed. Existing data remains available.
* **Added column:** The new column is added to the Snapshot table. Existing rows have no value for that column.
* **Removed column:** The column remains in the Snapshot table. Existing data remains available, but new snapshot rows have no value for that column.

{% hint style="info" %}
The Snapshot Utility never removes columns or deletes saved snapshot data. Historical snapshots remain available as Staging tables change.
{% endhint %}

## Integrating the Snapshot Utility

The Snapshot Utility could be coded within an ETL to automatically make a backup copy of the related Staging tables each time the ETL is executed. The following diagram shows how this feature might be leveraged at a State to reuse a Directory snapshot for Child Count reporting.

<figure><img src="../../.gitbook/assets/Directory snapshot data flow.png" alt="Flowchart showing Directory data moving from source to staging, then through the Snapshot Utility. Child Count ETL reuses organization data from snapshot tables instead of the source directory system."><figcaption><p>Directory snapshot data flow.</p></figcaption></figure>

1. In the Source-to-Staging\_Directory ETL, the Snapshot Utility could be embedded to run automatically to create a copy of all Directory data.
2. The Snapshot Utility will run automatically and create/update backup copies of the Staging tables in the Source schema.
3. In the Source-to-Staging\_ChildCount ETL, required Organization information can be pulled directly from the Snapshot tables rather than from the Directory source system. This not only assures that Directory information used for Child Count will match the submitted 029 data, but may improve ETL performance by not requiring the ETL to jump to another system/database to pull Directory data.

Below is an example of code that could be used to restore data from a Snapshot table into a Staging table. In this case, data from `Source.K12Organization` for a school year for 029 will be restored to `Staging.K12Organization` for use with Child Count.

{% code title="Restore snapshot data to staging" %}
```sql
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
		and ReportCode = '029'

```
{% endcode %}

## Summary

This documentation will be updated as changes are made to Generate and the utilities within Generate.

***

## Office Hour Demo

{% embed url="https://youtu.be/4UbMWUf8LH4?feature=shared&t=1227" %}
Demonstration of the Staging Table Snapshot from the Generate 11.3 Office Hour
{% endembed %}
