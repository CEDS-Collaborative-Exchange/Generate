---
description: >-
  The Data Store is where the data migrations occur and can only be accessed by
  the Generate Administrator.
---

# Data Store

From the Data Store three migrations can be executed:

* [x] [**Staging Migration**](data-store.md#staging-migration)
* [x] [**RDS Migration**](data-store.md#rds\_migration)
* [x] [**Reports Migration**](data-store.md#reports\_migration)

<div data-full-width="true">

<figure><img src="../../.gitbook/assets/1 - Data Store Home.png" alt=""><figcaption><p>The three Migration process choices a Generate Admin can make are <strong>Staging Migration</strong>, <strong>RDS Migration</strong>, <strong>Reports Migration</strong>.</p></figcaption></figure>

</div>

Migrations are done via an ETL (Extract, Transform, Load) process that moves data from one database to another database. They are run independently and can be run in any order. Data travels through the system from the staging tables to the RDS to the Reports. While you can run components within each of these groups in whichever order is appropriate for your needs, data must follow the flow above to see reports in Generate. As an example, while working on issues related to data quality, the Staging Migration can be run as many times as needed until the data in Staging is correct. Then, the RDS Migration can be run to extract quality data from Staging. Following that, the Reports Migration would be run to aggregate the data and populate the reports.

## Staging Migration

The Staging migration moves data from the state’s Statewide Longitudinal Data System (SLDS) or other data source, into the Generate staging tables.

Click on the **Staging Migration** button to select it.

<figure><img src="../../.gitbook/assets/image (2).png" alt="Data Store Migration Selection Buttons with arrow to Staging Migration button" width="452"><figcaption><p>Data Store Migration Selection Buttons</p></figcaption></figure>

This opens the **Staging Migration** page.

<div data-full-width="true">

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption><p>Staging Migration School Years and Staging Migration Tasks</p></figcaption></figure>

</div>

From this page, you can enable or disable the Staging migration for specific school years and stored procedures.

### Staging Migration School Years

To migrate data for a specific school year, select the year from the dropdown list by clicking on the checkbox next to the specific year. You can select more than one year but generally one year at a time is recommended.

Follow the steps below to enable the migration for a particular school year.

1. To enable a school year’s migration to Staging, select the checkbox next to the school year. You can select more than one year at a time.

![](<../../.gitbook/assets/image (119).png>)

2. To disable a school year’s migration to Staging, deselect the checkbox next to the school year.

![](<../../.gitbook/assets/image (69).png>)

### Staging Stored Procedures

Stored procedures are migration tasks that move data via an ETL process into Staging. The execution and order of stored procedures is predetermined. For example, the first stored procedure that is executed in the Staging migration (Source.Source-to-Staging\_Directory @SchoolYear) loads directory data into Generate staging tables.

{% hint style="info" %}
The following steps explain how to disable or enable stored procedures. Generally, there are no dependencies between Source to Staging ETL procedures but if there are then you’ll need to manage this using the execution order. The execution order of stored procedures is predetermined by default but can be changed. However, modifying the order of certain stored procedures native to Generate may result in missing data. Make sure you understand the purpose of the stored procedures before disabling them or changing the order of execution.
{% endhint %}

1. To disable a stored procedure and prevent its migration to Staging, deselect the checkbox under the “**Enabled**?” column next to the stored procedure’s name.
2. To enable the stored procedure, select the checkbox under the “**Enabled**?” column next to the stored procedure’s name.

<div data-full-width="true">

<figure><img src="../../.gitbook/assets/image (3).png" alt="Staging Migration School Years and Staging Migration Tasks with Enabled column  highlighted"><figcaption><p>Staging Migration School Years and Staging Migration Tasks with Enabled column highlighted</p></figcaption></figure>

</div>

#### **To change the execution order:**

1. Click on the row for the stored procedure you want to move.
   1. The row will become highlighted showing that it is selected.
2. Click the Up arrow to move the stored procedure up a level in the order of execution.
   1. You will see the Execution Order number change as the stored procedure changes location.
3. Click the Down arrow to move the stored procedure down a level in the order of execution.
   1. You will see the Execution Order number change as the stored procedure changes location.

<div data-full-width="true">

<figure><img src="../../.gitbook/assets/image (4).png" alt="Staging Migration School Years and Staging Migration Tasks with Execution Order column highlighted"><figcaption><p>Staging Migration School Years and Staging Migration Tasks with Execution Order column highlighted</p></figcaption></figure>

</div>

When the school years and stored procedures have been selected, you can execute the migration. To execute the migration:

1\. Click on the “**MIGRATE TO STAGING**” button.

<div data-full-width="true">

<figure><img src="../../.gitbook/assets/image (5).png" alt="Staging Migration School Years, Tasks, and Migrate buttons with arrow pointing to &#x22;Migrate&#x22; button "><figcaption><p>Staging Migration School Years, Tasks, and Migrate buttons with arrow pointing to "Migrate" button</p></figcaption></figure>

</div>

The migration will begin and a message at the top of the page will show the processes being run, as well as the date and time of the migration progression.

When the process is complete, the message at the top of the page will show the date and time of completion, as well as the difference in processing time compared to the last Staging migration.

## RDS Migration <a href="#rds_migration" id="rds_migration"></a>

The RDS migration moves data from Generate Staging into the Generate Reporting Data Store (RDS).&#x20;

{% hint style="warning" %}
Toggle settings should be applied **before** this process is run.
{% endhint %}

To select the RDS Migration

1. Click the **RDS Migration** button.

<figure><img src="../../.gitbook/assets/image (6).png" alt="" width="301"><figcaption><p>Data Store Migration Selection Buttons with arrow to RDS Migration button</p></figcaption></figure>

This opens the RDS Migration page.

<figure><img src="../../.gitbook/assets/image (58).png" alt=""><figcaption><p>RDS Migration page</p></figcaption></figure>

From this page, you can enable or disable the School Year and RDS migration wrapper stored procedures.

### RDS Migration School Years

Specific school years can be included or excluded from the migration process. If a school year is enabled, data for the year selected will display on reports. If a school year is disabled data will not display on reports.

The stored procedures that were enabled and run previously will be enabled by default the next time you access the migration page. Review the selections and change them if needed.

Follow the steps below to enable and disable school years:

1. To enable a school year’s migration to the RDS, select the checkbox next to the school year.

![Enable School Year for RDS Migration Page](<../../.gitbook/assets/image (90).png>)

2. To disable a school year from migrating to the RDS, deselect the checkbox next to the year.

![Disable School Year for RDS Migration Page](<../../.gitbook/assets/image (64).png>)

### RDS Migration Tasks

Stored procedures are migration tasks that move data via the ETL into the RDS.

<figure><img src="../../.gitbook/assets/image (73).png" alt=""><figcaption><p>RDS Migration School Years and RDS Migration Tasks with Enabled column highlighted</p></figcaption></figure>

The following steps explain how to disable or enable the wrapper stored procedures.

1. To disable a stored procedure and prevent its migration to the RDS, deselect the checkbox under the “Enabled?” column next to the stored procedure’s name.
   1. In the screenshot below, the Stored Procedure “`App.Wrapper_Migrate_Directory_to_RDS`” is not selected. This means the stored procedure will be ignored (will not run) when the migration process is executed.
2. To enable the stored procedure, click in the empty checkbox under the “Enabled?” column next to the stored procedure’s name to select it.
   1. In the screenshot below, the Stored Procedures “`App.Wrapper_Migrate_Chronic_to_RDS`” and “`App.Wrapper_Migrate_CTE_to_RDS`” have been selected. This means the stored procedures will run when the migration process is executed.

<figure><img src="../../.gitbook/assets/image (67).png" alt=""><figcaption><p>RDS Migration School Years and RDS Migration Tasks with all columns highlighted</p></figcaption></figure>

When the school years and stored procedures have been selected, you can execute the migration. To execute the migration:

1. Click on the “**MIGRATE TO REPORTING DATA STORE**” button
   1. The migration will begin and a message at the top of the page will show the processes being run, as well as the date and time of the migration progression.
   2. When the process is complete, the message at the top of the page will show the date and time of completion, as well as the difference in runtime compared to the last RDS migration.

<figure><img src="../../.gitbook/assets/image (107).png" alt=""><figcaption><p>RDS Migration School Years and RDS Migration Tasks with arrow pointing to "Migrate" button</p></figcaption></figure>

## Reports Migration <a href="#reports_migration" id="reports_migration"></a>

The Reports Migration lets the user migrate new data into reports, or lockdown the reports to prevent the data from being overwritten.

To select the Reports Migration, click the **REPORTS MIGRATION** button as shown below.

<figure><img src="../../.gitbook/assets/image (7).png" alt="" width="301"><figcaption><p>Data Store Migration Selection Buttons with arrow to Report Migration button</p></figcaption></figure>

This opens the Report Migration page.

<figure><img src="../../.gitbook/assets/image (88).png" alt=""><figcaption><p>Reports Migration School Years and Reports Migration Tasks</p></figcaption></figure>

From this page, you can select specific school years to be locked down or overwritten and choose whether to lockdown reports or overwrite their data.

### Report Migration School Years

School year selection determines which school years to lock down or overwrite during the migration process. By default, the most recent school year displays in the field. Click on the dropdown field next to the year to select a different year. **It is important** that you select the correct year when determining whether to lock down the reports or overwrite them.

The Reports migration is different than Staging and RDS in that only one year can be selected at a time. Click on a school year to select it.

![](<../../.gitbook/assets/image (68).png>)

### Report Migration Tasks

To overwrite the data for a report, select the checkbox next to the Report Code. This lets the system know that the data for the school year selected should be overwritten for this report. For example, if you select school year 2017-18 and Report Code C002, you are enabling the migration process or will be overwriting data that was already populated for that school year and report.

<figure><img src="../../.gitbook/assets/image (139).png" alt=""><figcaption><p>Report Migration Tasks w/ C002 row highlighted</p></figcaption></figure>

If the report(s) passed review and are considered final, you may not want to overwrite them with new data. In this situation, do not select the checkbox next to the report code. Leave it empty. An empty checkbox means that the data for that report will not be overwritten.

When you have selected both year and report(s), click on **MIGRATE TO REPORT DATA STORE** located at the bottom of the page.

A warning displays alerting you that the data will be overwritten. Click **OK** to kick off the migration process.

<figure><img src="../../.gitbook/assets/image (136).png" alt=""><figcaption><p>Report Migration Tasks with "Migrate" and "GO TO DATA STORE" buttons highlighted</p></figcaption></figure>

To return to the Data Store’s home page, click on the **GO TO DATA STORE** link at the bottom right of the page as noted in the above screenshot.
