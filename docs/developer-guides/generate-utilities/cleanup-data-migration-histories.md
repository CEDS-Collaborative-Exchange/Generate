# Cleanup Data Migration Histories

### Overview

The App.DataMigrationHistories table is used by the migration process and several utilities. As a result, the table can grow large enough to impact performance. This utility provides a way to clean out that table.

#### Sample Execution

The procedure removes every record before the specified `@cleanupDate`.

```sql
EXEC Utilities.Cleanup_DataMigrationHistories @cleanupDate = '2026-09-10';
```

