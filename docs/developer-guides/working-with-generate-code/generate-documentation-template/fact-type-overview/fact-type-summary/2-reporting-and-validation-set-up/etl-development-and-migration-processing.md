# ETL Development and Migration Processing

## Purpose

Migration processing moves validated source data into Generate and prepares data for reporting.

***

## Migration Workflow

<pre><code>Source Extract
      ↓
Generate Staging Tables
      ↓
<strong>Warehouse Processing
</strong>      ↓
Fact Tables
      ↓
Dimension Tables
      ↓
Report Tables
</code></pre>

***

## Source Extract ETL Details

The Generate database has a stored procedure for each Fact Type which is empty in the default load of the Generate database and serves as a placeholder. Since this Stored Procedure ETLs data from the education agency's source system(s) into the Generate Staging environment, the ETL code will be customized to your education agency's context. For Child Count, this Stored Procedure is called `[Source].[Source-to-Staging_ChildCount]`.

| ETL Source Table/queries            | Transformations  | Notes                                                   |
| ----------------------------------- | ---------------- | ------------------------------------------------------- |
| example: 2025\_Enrollment\_Snapshot | Rollup Ethnicity | Schools report more than one and creates duplicate rows |
|                                     |                  |                                                         |
|                                     |                  |                                                         |
|                                     |                  |                                                         |
|                                     | ☐                |                                                         |

***

## Migration Activities

<table><thead><tr><th width="118.79998779296875">Complete</th><th width="286.7999267578125">Step</th><th>Notes</th></tr></thead><tbody><tr><td>☐</td><td>Source extract executed</td><td></td></tr><tr><td>☐</td><td>Staging tables loaded</td><td></td></tr><tr><td>☐</td><td>Warehouse processing completed</td><td></td></tr><tr><td>☐</td><td>Fact tables populated</td><td></td></tr><tr><td>☐</td><td>Dimension tables populated</td><td></td></tr><tr><td>☐</td><td>Report tables generated</td><td></td></tr></tbody></table>

***

## Migration Notes

Document any migration issues, warnings, or exceptions encountered during processing.

***

## Supporting Documentation

| Resource                         | Link |
| -------------------------------- | ---- |
| Generate Migration Documentation |      |
| ETL Documentation                |      |
| Mapping Documentation            |      |
