# Initial Data Mapping and Settings

## Purpose

This section documents how source system data is mapped into Generate.

Some of these components will be set up initially and then some will need to be reviewed with each reporting cycle to confirm nothing has changed. Detailed field-level mappings will be maintained in a separate ETL Documentation Template workbook.

## Initial Full Data Mapping Setup

#### Source to Generate Data Mapping

Document how source system data maps to the Generate staging tables. Detailed field level mappings should be maintained in the ETL Documentation Template.

The Generate ETL Documentation Templates give a detailed breakdown of all data elements needed for each Fact Type and show how data are transformed through each stage of the data migration. This documentaion assists in building the initail ETL process. These templates can be used to document data transformation notes and option set mappings. The ETL Templates documentation has a detailed instruction tab to help you know how to utilize this tool effectively.

<mark style="color:$warning;">Link to ETL Documentation Template</mark>

\[Link to your completed copy of the template]

***

#### **Toggle Settings**

The Generate Toggle tables store information that impacts the business logic used to ETL the data for EDFacts reporting. It is important to make sure these questions are completed before data is migrated and that they match what will be entered in the corresponding EDPass Metadata Collection. These items can be updated on the Toggle page(s) in the Generate web application.

| Settings | Value | Notes |
| -------- | ----- | ----- |
|          |       |       |
|          |       |       |
|          |       |       |

***

#### Source System Reference Data Settings

[Source System Reference Data](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/source-system-reference-data-mapping-utility/source-system-reference-data) is used in the Staging to RDS Migration to determine how source system option set values map to CEDS option set values. This table needs to be updated with the complete set of values for all categorical fields by school year.

Mapping the value the source system passes into the staging table needs to map to a value in the Generate Staging.SourceSystemReferenceData table that is used throughout the migration process for all users of Generate.&#x20;

This mapping process is part of the ETL Documentation Templet and more information on how to find what needs to be mapped can be found here: [Source System Reference Data](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/source-system-reference-data-mapping-utility/source-system-reference-data) and in the Fact Type Documentation by selecting the specific Fact Type here: [Fact Type Documentation](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/fact-type-table)&#x20;

| Field Name            | Source Input Value | Generate Output Value |
| --------------------- | ------------------ | --------------------- |
| example: School\_Type | 1                  | Regular               |
|                       |                    |                       |
|                       |                    |                       |



### Source to Generate Mapping Summary

| Source Table | Generate Table | Description |
| ------------ | -------------- | ----------- |
|              |                |             |
|              |                |             |
|              |                |             |

***

### Related Documentation

| Resource                         | Link                                                                                                                                                                |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Generate Migration Documentation | [Generate Migration Fact Type Documentation](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/fact-type-table) |
| Source System Data Dictionary    |                                                                                                                                                                     |
| Source System Documentation      |                                                                                                                                                                     |

