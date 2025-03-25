# Cleanup Debug Tables

## Overview

The process of migrating E&#x44;_&#x46;acts_ data to the Reports tables automatically creates a set of tables in the debug schema that provide the student IDs that make up the aggregated counts. They are especially useful when doing file comparison and matching work. Those tables can build up over time. This utility provides a means of keeping those tables in check.

### Sample Execution

There are four options for managing the debug tables. Execute the stored procedure using the parameters as follows:

1. Leave both parameters blank and delete ALL tables in the debug schema

```sql
exec [Utilities].[Cleanup_Debug_Tables]
```

2. Pass a reportcode, ex, 'c002', for @reportCode and delete all the tables in the debug schema for that report (all school years)

```sql
exec [Utilities].[Cleanup_Debug_Tables] 'c002'
```

3. Pass a 4 digit School Year for @reportYear and delete all the tables in the debug schema for that School Year (all reports)

```sql
exec [Utilities].[Cleanup_Debug_Tables] null, '2022'
```

4. Pass in values for both parameters and delete all the tables for only the specified report for only the specified school year

```sql
exec [Utilities].[Cleanup_Debug_Tables] 'c002', '2022'
```

### Demonstration

{% embed url="https://youtu.be/MmfmSMswVFM?t=2335" %}
Cleanup Debug Tables demo from the Generate 5.3 Office Hour meeting.
{% endembed %}
