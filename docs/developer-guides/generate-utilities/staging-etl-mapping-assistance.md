---
description: Alternatives When the ETL Documentation Template is Unavailable or Outdated
---

# Staging ETL Mapping Assistance

{% hint style="info" %}
If the ETL Documentation Template appears to be outdated or is unavailable, please use these alternatives to find the required mapping information.&#x20;
{% endhint %}

The ETL Documentation Templates specify which columns must be populated in the Staging tables for E&#x44;_&#x46;acts_ files. However, if the required template is unavailable or outdated, this document outlines alternative methods for identifying these columns.

This document covers the following:

* Generate Metadata by Fact Type
* &#x20;Staging Debug view
* Staging to RDS Stored Procedure for the Appropriate Fact Type
* E&#x44;_&#x46;acts_ File Specifications
* Locating CEDS Option Set Code and CEDS Option Set Descriptions
* Previously Developed ETL Code

## Generate Metadata by Fact Type&#x20;

The views in the Generate metadata tables can be queried to determine which Staging tables need to be populated for a Fact Type.

{% hint style="success" %}
The following script is an example for returning the staging tables and columns needed for **Child Count**:
{% endhint %}

```sql
-- How do I know what data needs to be mapped for this Fact Type?

-- Get table list of report codes, tables, and fields by fact type.

SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'childcount'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
```

## Staging Debug Views

These views are in the Debug schema and are named like the example shown below:

* Debug.vwChildCount\_StagingTables

These views are built to handle all the data in the specific Fact Type, not a specific E&#x44;_&#x46;acts_ file, so there may be columns defined in the view that are not required for the file you are working on. By analyzing the SELECT and the JOIN clauses in the debug views, you can see the tables/columns that are included in that Fact Type. (Note: Some of the Staging views may not be fully developed to include the columns for every E&#x44;_&#x46;acts_ file included in the Fact Type if that file is in ‘_Pilot Opportunity_’ or ‘_To be developed in Generate_’ status.)

## Staging to RDS Stored Procedure

Each Fact Type has a stored procedure that moves data from the Staging tables to the Fact and Dimension tables. They are named like the example shown below.

* Staging.Staging-to-FactK12StudentCounts\_ChildCount

Discipline, Assessment, Staff, and Organization have their own specific stored procedures to handle this process, but the remaining Fact Types follow the naming convention above; just substitute the appropriate Fact Type name at the end.

Find the SELECT statement that populates the #Facts temp table. In the JOIN clauses, you can find the Staging tables that are used by that Fact Type. This does not go down to the column level but will provide some valuable information needed to complete the ETL.

## File Specification

The individual E&#x44;_&#x46;acts_ file specification is also very useful in developing your Staging ETL code. Look for the section in the file specification titled: **2.0 GUIDANCE FOR SUBMITTING THIS FILE**.

That section of the file specification indicates the level(s) (SEA, LEA, and/or School) that are required for reporting. It also includes a section that shows the required categories and totals for the file. Reviewing the categories gives you a high-level view of the data that is required. For example, if the file reports on Sex and Race, you will need to populate \[Staging.K12Enrollment.Sex] as well as a row in the “Staging.K12PersonRace” table.

## Locating CEDS Option Set Code and CEDS Option Set Description

The file specification also includes the option set codes (permitted values) required for the report. You can also find them in Generate to help you map the data correctly.

### Source System Reference Data Settings

[Source System Reference Data](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/source-system-reference-data-mapping-utility/source-system-reference-data) is used in the Staging to RDS Migration to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year. To learn more about this process review [Source System Reference Data](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/source-system-reference-data-mapping-utility/source-system-reference-data).&#x20;

To find the Source System Reference Data needed for each Fact Type, you can query the system by running the script below by FactTypeCode and ReportCode. You can also filter the Source System Reference Data table by FactTypeCode and ReportCode as shown in the Child Count example below.&#x20;

{% code overflow="wrap" fullWidth="false" %}
```
SELECT DISTINCT FactTypeCode, ReportCode, StagingTableName, StagingcolumnName, SSRDRefTableName, SSRDTableFilter
FROM app.vwStagingRelationships
WHERE FactTypeCode = 'childcount' and ReportCode = '002'
ORDER BY FactTypeCode, ReportCode, StagingTableName, StagingcolumnName
```
{% endcode %}

### Source System Reference Tables Child Count Filters

In some instances, the CEDS reference table needs to be further qualified to determine what level or type of data is being referenced by the Table Filter field. For example, the following fields will need to be mapped using the value in the Source System Reference Data table using these filters. For further information please review [Source System Reference Data](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/source-system-reference-data-mapping-utility/source-system-reference-data).&#x20;

Example for Child Count Reports ('002', '089') have filters

* 000100 Used for Grade Level&#x20;
* 000126 Used for Grade Level When Assessed&#x20;
* 000174 Used for LEA Operational Status&#x20;
* 000533 Used for School Operational Status

### Previously Developed ETL Code

If you have already developed an ETL to populate Staging for another file, you can leverage that code as well. If, from the above methods, you determine that a table/column is needed, look to see if you have already written code for that table in a previous ETL and re-use that code to the extent possible.

