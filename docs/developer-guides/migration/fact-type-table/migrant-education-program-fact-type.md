---
description: >-
  This page describes the steps needed to use Generate to produce EDFacts Files
  for the Migrant  Education Program Fact Type
---

# Migrant Education Program Fact Type

***

{% hint style="info" %}
Please note, to take most of these steps you will need an up-to-date version of Generate installed. Please visit the [Installation](../../installation/) or [Upgrade](../../installation/upgrade/) pages for more information.
{% endhint %}

## Overview

### What are the high-level steps that you will need to take?

* Set Up: Data Mapping & Settings
* Migration: Building and Running ETLs
* Validation: Verifying Data Results

### What submitted E&#x44;_&#x46;acts_ Files are included in the <mark style="color:blue;">Migrant Education Program Fact Type</mark>?

The following files have been created in Generate and submitted to E&#x44;_&#x46;acts_:

* [x] FS054: MEP Students Served - 12 Months
* [x] FS121: Migratory Students Eligible - 12 Months
* [x] FS145: MEP Services

### What E&#x44;_&#x46;acts_ Files in the <mark style="color:blue;">Migrant Education Program Fact Type</mark> are available for pilot opportunity?

The following files are in pilot status or are available for piloting in Generate:

* [ ] FS054: MEP Students Served - 12 Months
* [ ] FS121: Migratory Students Eligible - 12 Months
* [ ] FS145: MEP Services

{% code overflow="wrap" %}
```sql
--What EDFacts Files are included in the Migrant Education Program Fact Type?
SELECT          agrft.FactTypeId 
               ,agrft.GenerateReportId
               ,rdft.FactTypeCode
               ,rdft.FactTypeDescription
               ,agr.ReportCode
               ,agr.ReportName
FROM            App.GenerateReport_FactType AS agrft
LEFT JOIN       RDS.DimFactTypes            AS rdft
                    ON rdft.DimFactTypeId = agrft.FactTypeId
LEFT JOIN       App.GenerateReports         AS agr
                    ON agr.GenerateReportId = agrft.GenerateReportId    
WHERE           rdft.FactTypeCode = 'migranteducationprogram'
                AND LEN(agr.ReportCode) = 3 -- only return those with report code    with a EDFacts format
ORDER BY        agrft.FactTypeId, agr.ReportCode
```
{% endcode %}

***

## 1. Set Up: Data Mappings & Settings

### Data Mappings

**ETL Documentation Templates**

The Generate ETL Documentation Templates give a detailed breakdown of all data elements needed for each Fact Type and show how data are transformed through each stage of the data migration. After completing the CEDS alignment process these templates can be used to document data transformation notes and option set mappings. They also contain a description of the CEDS data elements needed and what they are called throughout the Generate database. The ETL Templates documentation has a detailed instruction tab to help you know how to utilize this tool effectively. If you need clarification, please reach out to your CIID TA provider.

{% hint style="info" %}
You can find the Migrant Education Program ETL Documentation Template.xlsx on the [ETL Documentation Template](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074) page. If the ETL Documentation Template appears to not be outdated or is unavailable, please use these [alternatives to find the required mapping information](https://app.gitbook.com/o/54A84G98mRVbG3AeyXRJ/s/rRyeWMyPKDUxlv4sroOL/~/changes/286/developer-guides/generate-utilities/staging-etl-mapping-assistance).
{% endhint %}

**Generate Metadata**

The Generate metadata tables can be queried to determine which Staging tables need to be populated for a Fact Type.

{% hint style="success" %}
The following script will return the needed staging table, and columns for **Migrant Education Program**:
{% endhint %}

<pre class="language-sql"><code class="lang-sql"><strong>-- How do I know what data needs to be mapped for this Fact Type?
</strong>
-- Get table list of report codes, tables, and fields by fact type.

SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'migranteducationprogram'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
</code></pre>

### Settings

**Toggle Settings**

The Generate Toggle tables store information from the E&#x44;_&#x46;acts_ Metadata and Process System (EMAPS) survey that impacts the business logic used to ETL the data for E&#x44;_&#x46;acts_ reporting. It is important to make sure these questions are completed before data is migrated and that they match what was entered in EMAPS. These items can be updated on the Toggle page(s) in the Generate web application. The Toggle page is largely organized by Fact Type, though there may be cases where a setting from a different Fact Type or section may be required. We recommend updating all Toggle settings annually after you complete your EMAPS survey. Instructions for how to find and update the Toggle page are available in the Toggle documentation.

**Source System Reference Data Settings**

Source System Reference Data is used in the Staging to RDS Migration to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year.

{% hint style="success" %}
To find the Source System Reference Data needed for each Fact Type, you can query the system by running the following script by `FactTypeCode` and `ReportCode`.

You can also filter the Source System Reference Data table by `FactTypeCode` and `ReportCode` as shown below.

If there are no rows returned in the query with StagingTableName or StagingcolumnName that just means, there is no required data to map.
{% endhint %}

{% code overflow="wrap" %}
```sql
SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName, SSRDRefTableName, SSRDTableFilter 
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'migranteducationprogram' and ReportCode = '054'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
```
{% endcode %}

**Source System Reference Tables Migrant Education Program Filters**

In some instances, the CEDS reference table needs to be further qualified to determine what level or type of data is being referenced by the Table Filter field. For example, the fallowing fields will need to be mapped using the value in the SSRD table using these filters. For further information please review Source System Reference Data.

Migrant Education Program Reports ('054','121','145') have filters

* 000100 Used for Grade Level
* 000174 Used for LEA Operational Status
* 000533 Used for School Operational Status
* 001156 Used for Organization Type

Source System Reference Data Mapping Utility can be used to determine which option-set value mappings are needed for a Fact Type and which have been mapped. Note that new installations of Generate will come with both the InputCode and OutputCode fields loaded and you will need to review and update any values in the InputCode field to match your source data.

{% code overflow="wrap" %}
```sql
exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'migranteducationprogram', '2024', 0 -- This will show all mappings for the Migrant Education Program Fact Type for School Year 2023-24
```
{% endcode %}

***

## 2. Staging

### Migration: Building & Running ETLs

**Building the ETL Code:**

The Generate database has a stored procedure for each Fact Type which is empty in the default load of the Generate database and serves as a placeholder. Since this Stored Procedure ETLs data from the education agency's source system(s) into the Generate Staging environment, the ETL code will be customized to your education agency's context. For Migrant Education Program, this Stored Procedure is called `[Source].[Source-to-Staging_MigrantEducationProgram]`.

The tools from the Set Up phase (ETL Checklist and Generate metadata) are used to guide writing the ETL Code in this Stored Procedure. Additionally, ETL code written previously to perform this work in the education agency's source system(s) can also be a useful resource at this step, particularly for ensuring critical data handling and business rules from the source system are retained in the Generate Source to Staging ETL.

<figure><img src="../../../.gitbook/assets/image (228).png" alt=""><figcaption><p>Screenshot of the Generate database structure in SQL Server Management Studio, showing a stored procedure placeholder for the "Source-to-Staging_(Fact Type Name)" Fact Type.</p></figcaption></figure>

This is a sample of the stored procedure for each Fact Type which displays that it is empty by default, and also where you can place your specific ETL code.&#x20;

```
/****** Object:  StoredProcedure [Source].[Source-to-Staging_MigrantEducationProgram]    Script Date: 8/18/2025 10:12:03 AM ******/
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE PROCEDURE [Source].[Source-to-Staging_MigrantEducationProgram] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
GO
```

**Running the ETL**

{% tabs %}
{% tab title="Manually" %}
**Migrating Source to Staging**

The Source to Staging code can be run from SQL Server Management Studio (SSMS) by passing in the current school year as a parameter. Generate uses the end school year. For example, 2023-24 would be specified as '2024'.

```sql
exec [Source].[Source-to-Staging_MigrantEducationProgram] 2024
```
{% endtab %}

{% tab title="Generate UI" %}
**Migrating Source to Staging (Generate User Interface)**

This ETL can also be run from the Generate user interface.

{% content-ref url="../../../user-guide/settings/data-migration.md" %}
[data-migration.md](../../../user-guide/settings/data-migration.md)
{% endcontent-ref %}
{% endtab %}
{% endtabs %}

### Validation: Verifying Data Results

**Staging Validation**

Once data has been migrated to the Staging tables there are two Generate tools that can be used to validate the data.

1. Staging Validation Utility
2. Staging Table Debug View

**Staging Validation Utility**

Generate has a Staging Validation Process which can be called at the Fact Type or E&#x44;_&#x46;acts_ file level.

{% hint style="success" %}
The following is an example code snippet of how to call these Stored Procedures by the Migrant Education Program Fact Type.
{% endhint %}

```sql
exec [Staging].[StagingValidation_Execute] 2024,'migranteducationprogram'
exec [Staging].[StagingValidation_GetResults] 2024,'migranteducationprogram'
```

**Staging Table Debug View Process**

To aid validation we developed Staging Table Debug views that join together the Staging data for a Fact Type in a standard format that can be used for Generate testing. You can utilize these views in researching specific subsets of data or specific student data. These views can be found in the debug schema and will automatically be filtered by the school year(s) selected in the Generate web application. Opening the view in SSMS will provide you with a variety of filtering options to modify the query as needed during testing. Detailed instructions on how to utilize this process to debug Staging table data can be found in the Staging Table Validation Process.

The following is an example code snippet of how to select the Migrant Education Program Staging Table Debug view:

```sql
select * from [debug].[vwMigrantEducationProgram_StagingTables]
```

***

## 3. CEDS Data Warehouse

### Migration: Running ETLs

{% tabs %}
{% tab title="Manually" %}
**Migrating Staging to CEDS Data Warehouse in the Reporting Data Store (RDS) (Manually)**

To migrate data from Staging to the CEDS Data Warehouse you will need to call the `[App].[Wrapper_Migrate_MigrantEducationProgram_to_RDS]` Stored Procedure. This wrapper will call several Stored Procedures to migrate data to the dimension and fact tables in the CEDS Data Warehouse as well as log this activity in the `App.DataMigrationHistories` table. This process will also create debug tables that contain the information that is utilized in the counts and can be used in the validation process.

{% code overflow="wrap" %}
```sql
-- You will need to make sure the year is set to the school year you are migrating data. this script lets you check and then update if needed.

--Set school year for the RDS migrations (if necessary)    
    --check if the correct SY is already selected
     SELECT sy.SchoolYear, dm.* 
     FROM rds.DimSchoolYearDataMigrationTypes dm
     INNER join rds.dimschoolyears sy
     ON dm.dimschoolyearid = sy.dimschoolyearid
     WHERE IsSelected = 1
 
--IF THE ABOVE QUERY DOESN'T RETURN THE SY YOU NEED, RUN THE NEXT 2 QUERIES
 
  --reset, then set the appropriate year for this migration
     UPDATE rds.DimSchoolYearDataMigrationTypes
     SET IsSelected = 0
 -- Update to the year you are migrating
     UPDATE rds.DimSchoolYearDataMigrationTypes
     SET IsSelected = 1
     FROM rds.DimSchoolYearDataMigrationTypes sydmt
     JOIN rds.DimSchoolYears sy
     ON sydmt.DimSchoolYearId = sy.DimSchoolYearId
     WHERE SchoolYear = 2024
     
-- call the wrapper script to migrate the Fact Type data

exec [app].[Wrapper_Migrate_MigrantEducationProgram_to_RDS]
```
{% endcode %}
{% endtab %}

{% tab title="Generate UI" %}
**Migrating Staging to CEDS Data Warehouse in the Reporting Data Store (RDS) (Generate User Interface)**

This Migration process can also be run from the Generate user interface.

{% content-ref url="../../../user-guide/settings/data-migration.md" %}
[data-migration.md](../../../user-guide/settings/data-migration.md)
{% endcontent-ref %}
{% endtab %}
{% endtabs %}

### Validation: Verifying Data Results

Once data has been migrated to the Staging tables the Fact Table Debug View can be used to validate the data.

**Fact Table Debug View**

The Fact Table Debug view joins together the CEDS Data Warehouse data for a Fact Type in a standard format that is used for Generate testing. This view will automatically be filtered by the school year(s) selected in the Generate web application and stored in the `RDS.DimSchoolYearDataMigrationTypes` table. However, opening the view in SSMS will provide you with a variety of filtering options to modify this query as needed during testing. Detailed instructions on how to utilize this process to debug Fact Table data can be found in the Fact Type Table Validation Process guide.

{% hint style="success" %}
The following is an example code snippet of how to select the Migrant Education Program Staging Table Debug view:
{% endhint %}

```sql
select * from [debug].[vwMigrantEducationProgram_FactTable]
```

***

## 4. Report Tables

### Migration: Running ETLs

**Database Settings**

To migrate data from the CEDS Data Warehouse to the Report Tables in SSMS you will need to update some settings in the database and call the \[rds].\[create\_reports] Stored Procedure.

{% code overflow="wrap" %}
```sql
-- A. Make sure the Report Data Migration Type is selected
    DECLARE @SchoolYearId int = (SELECT DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = 2024)
    UPDATE RDS.DimSchoolYearDataMigrationTypes SET IsSelected = 0
    UPDATE RDS.DimSchoolYearDataMigrationTypes 
    SET IsSelected = 1
    WHERE DimSchoolYearId = @SchoolYearId and DataMigrationTypeId = 3 -- Reports

-- B. Lock the reports to be run
    UPDATE App.GenerateReports set IsLocked = 0
    UPDATE App.GenerateReports
    SET IsLocked = 1
    WHERE ReportCode IN ('054','121','145')

-- C. Empty the reports table for the specific reports    
    EXEC [rds].[Empty_Reports] @FactTypeCode = 'migranteducationprogram'

-- D. Perform the reports migration
    EXEC [rds].[create_reports] 'migranteducationprogram',0

```
{% endcode %}

The process of migrating data to Report Tables creates a set of tables in the \[debug] schema that provide the student IDs that make up the aggregated counts. These tables are especially useful when doing file comparisons and matching work. The sample below would return the list of students making up the counts.

```sql
-- simply query a corresponding table 
-- (using the table name to identify the category set contents)
-- This example will only work if the above code has been executed. 
SELECT * FROM [debug].[054_lea_ST1_2023_BASISEXIT]
```

Over time these tables will accumulate and create clutter in the Generate database debug schema. You can easily remove unneeded debug tables using the [Clean Up Debug Tables](file:///C:/o/54A84G98mRVbG3AeyXRJ/s/rRyeWMyPKDUxlv4sroOL/~/changes/210/developer-guides/generate-utilities/cleanup-debug-tables) utility.

### Validation: Verifying Data Results

**File Comparison Utility**

The File Comparison Utility allows you to compare E&#x44;_&#x46;acts_ submission files to data stored in the Report Tables in the Generate database. Instructions on how to use the `Utilities.CompareSubmissionFiles` Stored Procedure are available here. Typically, this step is performed in the first year of reporting a file through Generate to compare it to previous submission files produced by the legacy system.

{% code overflow="wrap" %}
```sql
-- Once you have followed the steps in the File Comparison Utility, you can run this to find the results.
exec Utilities.CompareSubmissionFiles
@DatabaseName = 'Generate', -- Your database name 
@SchemaName = 'XX', -- Your schema name 
@SubmissionYear = 2023, -- The report year
@ReportCode = '054', -- EdFacts File Number – '054','121','145'
@ReportLevel = 'LEA', -- 'SEA', 'LEA', 'SCH'
@LegacyTableName = 'Generate.XX.054_LEA_2023_Legacy', -- Legacy table
@GenerateTableName = 'Generate.XX.054_LEA_2023_Generate', -- Generate table
@ShowSQL = 0,
@ComparisonResultsTableName = 'generate.XX.054_LEA_2023_COMPARISON' -- Comparison table name
```
{% endcode %}

If you need further assistance validating your data or have data mismatches that you cannot resolve, please reach out to your TA provider for assistance.

***

## Additional Utilities

### IDEA Part B Data Review Checklist

This [IDEA Part B Data Review](https://ciidta.communities.ed.gov/#communities/pdc/documents/21449) Checklist helps state teams review and validate IDEA E&#x44;_&#x46;acts_ files. It includes a tab for each IDEA E&#x44;_&#x46;acts_ file specification, and lists considerations and types of validations to ensure accurate and complete data file submissions. Please review the Instruction tab and look for the associated report codes for the Assessment Fact Type.

### Staging Table Snapshot Utility

Generate allows states to create a backup or “snapshot” of staging tables. This is an optional utility that can be executed as needed or embedded into the State’s ETL workflow logic. The Staging Table Snapshot Utility provides a method to create a backup copy of staging tables for future use and reference after an ETL has populated Generate’s staging tables. This helps to ensure consistency across all E&#x44;_&#x46;acts_ reports for a given year and developers can preserve data in staging tables across ETL executions. This is best utilized after you have confirmed the Fact Type has successfully produced an accurate E&#x44;_&#x46;acts_ file.
