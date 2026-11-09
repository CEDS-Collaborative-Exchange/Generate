# Cleanup Data Migration Histories

## Overview

Each time a data migration runs in Generate, log entries are written to the table `App.DataMigrationHistories`. Over time this table can grow large. This utility allows for the deletion of older Data Migration History records that are no longer needed.

There is one parameter for the stored procedure:

1. @cleanupDate = The cutoff date. All Data Migration History records dated before this date will be removed.

If the `cleanupDate` parameter is missing or null, the stored procedure will not execute and will return an error.

Records with a date earlier than the cleanup date will be removed. Records on or after the cleanup date will be kept.

When the stored procedure finishes, it returns the number of records that were removed in a column named `RowsDeleted`.

{% hint style="warning" %}
Deleted records cannot be recovered. If the history may be needed later, back up the `App.DataMigrationHistories` table before running this utility.
{% endhint %}

### Sample Execution

{% code overflow="wrap" %}
```sql
exec [Utilities].[Cleanup_DataMigrationHistories] '2026-01-01'  -- This will remove all Data Migration History records dated before January 1, 2026
```
{% endcode %}
