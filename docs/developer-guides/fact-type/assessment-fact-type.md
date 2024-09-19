# Assessment Fact Type

{% hint style="info" %}
Please note, to take most of these steps you will need an up-to-date version of Generate installed. Please visit the [Installation](../installation/) or [Upgrade](../installation/upgrade/) pages for more information.
{% endhint %}

## Overview

### What are the high-level steps that you will need to take?

* Set Up: Data Mapping & Settings
* Migration: Building and Running ETLs
* Validation: Verify Data Results

### What submitted ED_Facts_ Files are included in the <mark style="color:yellow;">Assessment Fact Type</mark>?

The following files have been created in Generate and submitted to ED_Facts_:

* [x] 175: Academic Achievement in Mathematics
* [x] 178: Academic Achievement in Reading/Language Arts
* [x] 179: Academic Achievement in Science
* [x] 185: Assessment Participation in Mathematics
* [x] 188: Assessment Participation in Reading/Language Arts
* [x] 189: Assessment Participation in Science

### What ED_Facts_ Files are included in the <mark style="color:yellow;">Assessment Fact Type</mark> that are available for pilot opportunity?

The following files are in pilot status or available for pilot in Generate:

* [ ] 113: N or D Academic Achievement - State Agency
* [ ] 125: N or D Academic Achievement - LEA
* [ ] 126: Title III Former EL Students
* [ ] 137: English Language Proficiency Test
* [ ] 138: Title III English Language Proficiency Test
* [ ] 139: English Language Proficiency Results
* [ ] 142: CTE Concentrators Academic Achievement

{% code overflow="wrap" %}
```sql
-- What EDFacts Files are included in the Assessment Fact Type?
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
WHERE           rdft.FactTypeCode = 'assessment'
                AND LEN(agr.ReportCode) = 4 -- only return those with report code    with a EDFacts format
ORDER BY        agrft.FactTypeId, agr.ReportCode
```
{% endcode %}

***

## 1. Set Up: Data Mappings & Settings

### Data Mappings

#### **ETL Documentation Templates**

The Generate ETL Documentation Templates give a detailed breakdown of all data elements needed for each Fact Type and show how data are transformed through each stage of data migration. After completing the CEDS alignment process these templates can be used to document data transformation notes and option set mappings. They also contain a description of CEDS data elements needed and what they are called throughout the Generate database. The ETL Templates documentation has a detailed instruction tab to help you know how to utilize this tool effectively. If you need clarification, please reach out to your TA provider.

{% hint style="info" %}
You can find the Assessment ETL Documentation Template.xlsx on the [ETL Documentation Template](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074) page.
{% endhint %}

#### Generate Metadata

The Generate metadata tables can be queried to figure out which Staging tables need to be populated for a Fact Type.

{% hint style="success" %}
The following script will return the needed staging table, and columns for <mark style="color:yellow;">Assessment</mark>:
{% endhint %}

```sql
-- How do I know what data needs to be mapped for this Fact Type?

-- Get table list of report codes, tables, and fields by fact type.

SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'Assessment'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
```

### Settings

#### Toggle Settings

The Generate Toggle tables store information from the EMAPS survey that impacts the business logic used to ETL the data for ED_Facts_ reporting. It is important to make sure these questions are completed before data is migrated. These items can be updated on the Toggle page(s) in the Generate web application. The Toggle page is largely organized by Fact Type, though there may be cases where a setting from a different Fact Type or section may be required. We recommend updating all Toggle settings annually after you complete your EMAPS survey. Instructions for how to find and update the [Toggle page](../../user-workspace/settings/toggle.md) are available here.

Additionally, at the top of the Toggle page, you can find a link to an "Assessments" sub-page with multiple questions that should be reviewed and updated if needed. Link to the section in toggle for assessments

<figure><img src="broken-reference" alt=""><figcaption></figcaption></figure>

#### Source System Reference Data Settings

[Source System Reference Data](broken-reference) is used in the Staging to RDS Migration to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year.

{% hint style="success" %}
To find the Source System Reference Data needed for each Fact Type, you can query the system by running this script by `FactTypCode` and `ReportCode`.&#x20;

You can also filter the Source System Reference Data table by `FactTypeCode` and `ReportCode` as shown below.
{% endhint %}

{% code overflow="wrap" %}
```sql
SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName, SSRDRefTableName, SSRDTableFilter 
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'Assessment' and ReportCode = 'c188'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
```
{% endcode %}

#### Source System Reference Tables Assessment Filters&#x20;

In some instances, the CEDS reference table needs to be further qualified to determine what level or type of data is being referenced by the Table Filter field. For example, the fallowing fields will need to be mapped using the value in the SSRD table using these filters. For further information please review [Source System Reference Data](broken-reference).

Assessment Report ('C175', 'C178', 'C179', 'C185', 'C188', 'C189') have a 000100 Used for Grade Level 000126 Used for Grade Level When Assessed 000174 Used for LEA Operational Status 000533 Used for School Operational Status

[Source System Reference Data Mapping Utility](../generate-utilities-and-processes/source-system-reference-data-mapping-utility.md) can be used to determine which option-set value mappings are needed for a Fact Type and which have been mapped. Note that new installations of Generate will come with both the InputCode and OutputCode fields per loaded and you will need to review and update any values in the InputCode field to match your source data. More information about [Source System Reference Data](broken-reference) and how to Instructions on how to update can be found here.

{% code overflow="wrap" %}
```sql
exec [Utilities].[Check_SourceSystemReferenceData_Mapping] 'assessment', '2024', 0 -- This will show all mappings for the Assessment Fact Type for School Year 2023-24
```
{% endcode %}

## 2. Migration: Building & Running ETLs

### Building the ETL Code:

#### Source-to-Staging ETL&#x20;

The Generate database has a Stored Procedure for each Fact Type which is empty in the default load of the Generate database and serves as a placeholder. Since this Stored Procedure ETLs data from the education agency's source system(s) into the Generate Staging environment, the ETL code will be customized to your education agency's context.

For Assessments, this Stored Procedure is called **\[Source].\[Source-to-Staging\_Assessments]**.

The tools from the Set Up phase (ETL Checklist and Generate metadata) are used to guide writing the ETL Code in this Stored Procedure. Additionally, ETL code written previously to perform this work in the education agency's source system(s) can also be a useful resource at this step; particularly for ensuring critical data handling and business rules from to the source system are retained in the Generate Source to Staging ETL.

<figure><img src="broken-reference" alt=""><figcaption></figcaption></figure>

### Running the ETL

{% tabs %}
{% tab title="Manually" %}
#### Migrating Source to Staging

The Source to Staging code can be run from SQL Server Management Studio (SSMS) by passing in the current school year as a parameter. Generate uses the end school year. For example, 2023-24 would be specified as '2024'.

```sql
exec [Staging].[Source-to-Staging_Assessments] 2024
```
{% endtab %}

{% tab title="Generate UI" %}
#### Migrating Source to Staging (Generate User Interface)

This ETL can also be run from the Generate user interface.

{% content-ref url="../../user-workspace/settings/data-store.md" %}
[data-store.md](../../user-workspace/settings/data-store.md)
{% endcontent-ref %}
{% endtab %}
{% endtabs %}

## 3. Validation: Verifying Data Results

### Staging Validation

Once data has been migrated to the Staging tables there are two Generate tools that can be used to validate the data.

1. Staging Validation Utility
2. Staging Table Debug View

#### Staging Validation Utility

Generate has a [Staging Validation Process](broken-reference) which can be called at the Fact Type or ED_Facts_ file level.

{% hint style="success" %}
The following is an example code snippet of how to call these Stored Procedures by the Assessment Fact Type.
{% endhint %}

```sql
exec [Staging].[StagingValidation_Execute] 2024,'assessment'
exec [Staging].[StagingValidation_GetResults] 2024,'assessment'
```

#### Staging Table Debug View Process&#x20;

To aid in the validation we developed Staging Table Debug views that joins together the Staging data for a Fact Type in a standard format that can be used for Generate testing. You can utilize these views in researching specific subsets of data or specific student data. These views can be found in the debug schema, and they will automatically be filtered by the school year(s) selected in the Generate web application. Opening the view in SSMS will provide you with a variety of filtering options to modify the query as needed during testing. Detailed instructions on how to utilize this process to debug Staging table data can be found in the [Staging Table Validation Process](broken-reference)

The following is an example code snippet of how to select the Assessment Staging Table Debug view:

```sql
/select * from [debug].[vwAssessment_StagingTables]
```

***

## CEDS Data Warehouse Migration & Validation

### Migrating Staging to CEDS Data Warehouse

{% tabs %}
{% tab title="Manually" %}
#### Migrating Staging to CEDS Data Warehouse in the Reporting Data Store (RDS) (Manually)

To migrate data from Staging to the CEDS Data Warehouse you will need to call the \[App].\[Wrapper\_Migrate\_Assessments\_to\_RDS] Stored Procedure. This wrapper will call several Stored Procedures to migrate data to the dimension and fact tables in the CEDS Data Warehouse as well as log this activity in the app.DataMigrationHistories table. This process also will create debug tables that contain the information that is utilized in the counts and can be used in the validation process.

```sql
-- Note: add code to manually set school year?
-- code to set year
-- call the wrapper script
exec [app].[Wrapper_Migrate_Assessments_to_RDS]
```
{% endtab %}

{% tab title="Generate UI" %}
#### Migrating Staging to CEDS Data Warehouse in the Reporting Data Store (RDS) (Generate User Interface)

This Migration process can also be run from the Generate user interface \[link] (under settings once it is there. might be single migration only right now).
{% endtab %}
{% endtabs %}

### Validating CEDS Data Warehouse Data

Once data has been migrated to the Staging tables the Fact Table Debug View can be used to validate the data.

#### Fact Table Debug View

The Fact Table Debug view joins together the CEDS Data Warehouse data for a Fact Type in a standard format that is used for Generate testing. This view will automatically be filtered by the school year(s) selected in the Generate web application and stored in the `rds.DimSchoolYearDataMigrationTypes` table. However, opening the view in SSMS will provide you with a variety of filtering options to modify this query as needed during testing. Detailed instructions on how to utilize this process to debug Fact Table data can be found here \[link - New Page]

{% hint style="success" %}
The following is an example code snippet of how to select the Assessment Staging Table Debug view:
{% endhint %}

```sql
select * from [debug].[vwAssessment_FactTable]
```

The debug tables created by the migration process can be cleaned up using the [Clean Up Debug Tables](../generate-utilities-and-processes/cleanup-debug-tables.md) utility.

## Report Tables Migration & Validation

### Migrating Data to Report Tables

#### Database Settings

To migrate data from CEDS Data Warehouse to the Report Tables in SSMS you will need to update some settings in the database and call \[rds].\[create\_reports] Stored Procedure.

{% code overflow="wrap" %}
```sql
-- A. Make sure the Report Data Migration Type is selected
    DECLARE @SchoolYearId int = (SELECT DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = 2024)

    UPDATE RDS.DimSchoolYearDataMigrationTypes SET IsSelected = 0
    UPDATE RDS.DimSchoolYearDataMigrationTypes 
    SET IsSelected = 1
    WHERE DimSchoolYearId = @SchoolYearId and DataMigrationTypeId = 3 -- Reports

-- B. Lock the reports to be ran
    UPDATE App.GenerateReports set IsLocked = 0
    UPDATE App.GenerateReports
    SET IsLocked = 1
    WHERE ReportCode IN ('C175', 'C178', 'C179', 'C185', 'C188', 'C189')

-- C. Empty the reports table for the specific reports    
    EXEC [rds].[Empty_Reports] @FactTypeCode = 'assessment'

-- D. Perform the reports migration
    EXEC [rds].[create_reports] 'assessment',0

```
{% endcode %}

### Validating Report Table Data

#### File Comparison Utility

The [File Comparison Utility](broken-reference) allows you to compare ED_Facts_ submission files to data stored in the Report Tables in the Generate database. Instructions on how to use the `Utilities.Compare_ASSESSMENTS` Stored Procedure are available here. Typically, this step is performed in the first year of reporting a file through Generate to compare it to previous submission files produced by the legacy system.

{% code overflow="wrap" %}
```sql
-- Once you have followed the steps in the File Comparison Utility, you can run run this to find the results.

exec Utilities.Compare_ASSESSMENT
@DatabaseName = 'Generate', -- Your database name 
@SchemaName = 'XX', -- Your schema name 
@SubmissionYear = 2023, -- The report year
@ReportCode = 'C175', -- EdFacts File Number – C175, C178, C179, C185, C188, C189
@ReportLevel = 'LEA', -- 'SEA', 'LEA'
@LegacyTableName = 'Generate.XX.C175_LEA_2022_Legacy', -- Legacy table
@ShowSQL = 0
```
{% endcode %}

If you need further assistance validating your data or have data mismatches that you cannot resolve, please reach out to your TA for assistance.&#x20;

The debug tables created by this process can be cleaned up using the [Cleanup Debug Tables](../generate-utilities-and-processes/cleanup-debug-tables.md) utility.

## Additional Utilities

### IDEA Part B Data Review Checklist

This [IDEA Part B Data Review](https://ciidta.communities.ed.gov/#communities/pdc/documents/21449) Checklist helps state teams review and validate IDEA ED_Facts_ files. It includes a tab for each IDEA ED_Facts_ file specification, and lists considerations and types of validations to ensure accurate and complete data file submissions. Please review the Instruction tab and look for the associated report codes for the Assessment Fact Type.

### Staging Table Snapshot Utility

Generate allows states to create a backup or “snapshot” of staging tables. This is an optional utility that can be executed as needed or embedded into the State’s ETL workflow logic. The [Staging Table Snapshot Utility](broken-reference) provides a method to create a backup copy of staging tables for future use and reference after an ETL has populated Generate’s staging tables. This helps to ensure consistency across all ED_Facts_ reports for a given year and developers can preserve data in staging tables across ETL executions. This is best utilized after you have confirmed the Fact Type has successfully produced an accurate ED_Facts_ file.&#x20;
