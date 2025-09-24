---
description: Resetting After a Failed Migration
---

# Troubleshooting

{% hint style="info" %}
In this instance we are describing ‘failed’ as a migration that did not complete successfully. This could be a migration that had a sql error and aborted or a migration that runs continuously until it eventually causes a time out error.\
This is not referring to a migration that completed but did not produce the expected results. For that, please refer to [https://app.gitbook.com/o/54A84G98mRVbG3AeyXRJ/s/rRyeWMyPKDUxlv4sroOL/\~/changes/301/developer-guides/generate-utilities/troubleshooting-report-migration-results](../generate-utilities/troubleshooting-report-migration-results.md) &#x20;
{% endhint %}

First, let’s look at how these different things present themselves in the Generate application. On the migration page when you start a migration for a report or set of reports you will see a screen that looks like this

<figure><img src="../../.gitbook/assets/data migration 1.png" alt=""><figcaption></figcaption></figure>

If that migration fails, you could see a message that looks like this

<figure><img src="../../.gitbook/assets/data migration fail 1.png" alt=""><figcaption></figcaption></figure>

This is described as a graceful failure because the application handles it and returns everything to a ready state for continued use. There are times where the failure is severe enough that the application can’t do that. This will help you resolve those instances.

If you try to pull a report from the UI and you see a message like the one below it means that the previous migration failed in a way that was unrecoverable. The migration failed but the application is ‘waiting’ for it to finish before it will continue normal operation.

<figure><img src="../../.gitbook/assets/data migration error 1.png" alt=""><figcaption></figcaption></figure>

If that happens the migration needs to be manually reset.  This can be done in Sql Server Management Studio (SSMS) or whatever tool you use to do sql work in Generate. \
\
For context on the update that is required there are 2 tables to look at, App.DataMigrations and App.DataMigrationStatuses.  The App.DataMigrations table stores the information about the most recent migration that was executed.  There are 3 individual migrations that run to complete the entire process and they are each represented with a row in the results, defined by DataMigrationTypeId (1, 2 , 3).&#x20;

The column in that table that we are interested in is DataMigrationStatusId.  These values are codes from the DataMigrationStatuses table.

<figure><img src="../../.gitbook/assets/data migration query 1a.png" alt=""><figcaption></figcaption></figure>

Under normal circumstances, if you executed a migration from the UI and were ‘watching’ the DataMigrations table you would see the flow of that migration represented in the status column. As one step is in ‘processing’ status, the others are ‘pending’. When a step moves to ‘success’, the next step moves to ‘processing’ and so on until each step has completed.

<figure><img src="../../.gitbook/assets/data migration flow.png" alt=""><figcaption></figcaption></figure>

What we are resolving here is a case where one step fails and ends in ‘error’ and the application is not able to resolve that. It would look like this in the table

<figure><img src="../../.gitbook/assets/data migration query 2.png" alt=""><figcaption></figcaption></figure>

The resolution is simple, update the DataMigrations table, setting the status column to 5 or ‘success’, example below. For this solution it does not matter which stage in the process failed, we are just resetting each one to a completed state. We would still need to research what caused the failure to begin with but this returns functionality to the application so you can pull reports, run migrations, etc.&#x20;

```
      update App.DataMigrations
      set DataMigrationStatusId = 5
```
