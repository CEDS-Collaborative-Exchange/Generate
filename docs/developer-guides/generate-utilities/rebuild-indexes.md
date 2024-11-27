# Rebuild Indexes

## Overview

Indexes improve the performance of INSERTS, UPDATES, and DELETES against sql tables. We have indexes built for all of the tables in the Generate Staging environment. As the indexes for tables are used they can become fragmented over time and their performance can degrade. Rebuilding the indexes cleans up the fragmentation and restores the performance of the index. You can choose to run this periodically as needed or make it part of your standard process, whichever makes the most sense in your environment. This will rebuild all of the indexes on every table in the Staging schema.

### Sample Execution

```sql
exec [Utilities].[RebuildIndexes]
```
