# Fact Type Table

Fact Type refers to a categorization or classification of data that is used to organize and manage information within a data warehouse or data management system. It essentially represents a specific type of factual data that is collected, stored, and processed within the system.

### What is a Generate Fact Type?

A Generate Fact Type is a specific type of Fact Type that is used within the Generate ETL (Extract, Transform, Load) Stored Procedures. These procedures are organized based on different types of factual data, each representing a distinct aspect or category of information.

* Generate ETL Stored Procedures are organized by Fact Types.
* Many E&#x44;_&#x46;acts_ file specifications have shared timelines, reporting requirements, and/or a high degree of overlap in source system field mappings. When this happens, the data are organized into the same Fact Type to make data migration, testing, and file submission more efficient.
* The Fact Type determines where the data is stored in the Generate Reporting Data Store (RDS). For example, the Directory data are stored in `RDS.FactOrganizationCounts`. Generate has a series of tables used by the application where more information about Fact Types can be found. See the queries below.

### How do you query Fact Types?

```sql
-- RDS.DimFactTypes describes Fact Types used in the Generate database
SELECT * FROM RDS.DimFactTypes

-- App.GenerateReport_FactType captures the Fact Type associated with a report
-- This table is available in Generate 11.3 or later
SELECT * FROM App.GenerateReport_FactType

-- App.GenerateReports describes reports produced by Generate
SELECT * FROM App.GenerateReports

-- Get Fact Type to Report relationship with descriptions
SELECT       agrft.FactTypeId 
            ,agrft.GenerateReportId
            ,rdft.FactTypeCode
            ,rdft.FactTypeDescription
            ,agr.ReportCode
FROM         App.GenerateReport_FactType AS agrft
LEFT JOIN    RDS.DimFactTypes            AS rdft
             ON rdft.DimFactTypeId = agrft.FactTypeId
LEFT JOIN    App.GenerateReports         AS agr
             ON agr.GenerateReportId = agrft.GenerateReportId    
ORDER BY     agrft.FactTypeId, agrft.GenerateReportId
```

### How are Generate Fact Types Used?

The process of generating reports within our system involves identifying and associating specific Fact Types from numerous data sources to ensure accurate and relevant data representation. Fact Types are crucial for categorizing data across different dimensions such as assessments, discipline, membership, etc. This document outlines the architecture and processes used to manage, migrate, and utilize fact types in report generation.

#### ETL

Source to Staging ETL Stored Procedures: \[`Source].[Source-to-Staging_Assessments]`Staging to CEDS Data Warehouse ETL Stored Procedures: `[App].[Wrapper_Migrate_Assessments_to_RDS]`CEDS Data Warehouse to Report Tables:

* Current procedure: `[RDS].[Get_FactTypeByReport]`
  * Note: This procedure will be replaced by the `GenerateReports_FactType` table.
* Example: TBD (this hasn't been built as of 3/26/2024)

***

#### ETL Validation Tools

Staging Validation:

* Example values from of ReportGroupOrCodes field in StagingValidationRules: "Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership"

Debug views for verifying ETL to Staging: `[debug].[vwAssessments_StagingTables]`Debug views for verifying ETL to CEDS Data Warehouse: `[debug].[vwAssessments_FactTable]`

***

#### Reference Tables

App.DataMigrationTasks

* Names stored in the StoredProcedureName field contain fact type labels
  * `For example RDS.`Wrapper\_Migrate\_\[FactTypeLable]\_to\_RDS  (RDS`.vwDimAssessments)`
* Names used for views contain fact type labels
  * `For example` Source.Source-to-Staging\_\[FactTypeLable]  (Source.Source-to-Staging\_v`wDimAssessments)`
* Descriptions of Staging to CEDS Data Warehouse Wrapper scripts contain E&#x44;_&#x46;acts_ file specification numbers for the Fact Type
  * `For example RDS.`Wrapper\_Migrate\_\[FactTypeLable]\_to\_RDS  (`RDS.`Wrapper\_Migrate\_`vwDimAssessments`\_to\_RDS`)`
