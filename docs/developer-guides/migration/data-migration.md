---
hidden: true
---

# Data Migration

Generate makes use of data that have been migrated from that state source system, typically a State Longitudinal Database System (SLDS), into the Generate staging tables. Data can be migrated into Staging and through the Generate database either from the Generate Web Application “[Data Store](../../user-guide/settings/data-store.md)” pages or directly through SQL Server. Running from the Generate Web Application is recommended, especially when running Data Warehouse (RDS) and Reports Migration steps.&#x20;

### Location of Source to Staging ETL Code <a href="#location_of_etl_code" id="location_of_etl_code"></a>

ETL code should be placed in one or more stored procedures in the Generate database. By default, Generate has template scripts available by data domain (example: `Source.[Source-to-Staging_ChildCount`) which have a record in the `App.DataMigrationTasks` table. New Source to Staging ETL Code should reside in the Source schema, or a new schema (as long as the generate SQL user has access to that schema).

### Generate Web Application Migration Process <a href="#migration_process" id="migration_process"></a>

When a user triggers a Staging Migration via the Generate application, the following steps are executed by the Generate application in this order:

1. The `App.DataMigrationTasks` table is queried for all tasks with the following parameters:

> IsActive = 1
>
> DataMigrationTypeId = 1

2. The stored procedures found in the `App.DataMigrationTasks.StoredProcedureName` field from that query are then executed in ascending order of the `App.DataMigrationTasks.TaskSequence` field.

RDS and Reports Migrations use this same process but have different DataMigrationTypeId values.&#x20;
