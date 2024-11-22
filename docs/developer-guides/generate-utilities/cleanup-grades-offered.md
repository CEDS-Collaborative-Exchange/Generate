# Cleanup Grades Offered

## Overview

Grades Offered data is migrated as part of the Directory migration in Generate and is stored in the tables, `RDS.BridgeLeaGradeLevels` and `RDS.BridgeK12SchoolGradeLevels`.  This utility allows for the deletion of incorrectly added Grade Level records from either of those tables as needed.

There are four parameters for the stored procedure:

1. @organizationIdentifier = The state ID value for the Organization
2. @organizationType = One of 2 types, either 'lea' or 'school'
3. @gradeLevel = The CEDS grade level code (PK, K, 01, 02, etc...)
4. @schoolYear = The 4 digit School Year to limit the removal by

If the `OrganizationIdentifier` or `OrganizationType` parameters are missing the stored procedure will not execute.

If the Grade Level parameter is passed in, that single Grade Level value for the Organization will be removed. If Grade Level is left null, all grades for the Organization will be removed.&#x20;

If the School Year parameter is passed in, the Grade Level(s) chosen by the previous parameter for that organization for that School Year value will be removed. If School Year is left null, the Grade Level(s) chosen by the previous parameter for that organization will be removed for all years.&#x20;

### Sample Execution

{% code overflow="wrap" %}
```sql
exec [Utilities].[Cleanup_Grades_Offered] '12345', 'school', '08', 2023  -- This will remove Grade 08 from the School with ID = 12345q
```
{% endcode %}

### Demonstration

{% embed url="https://youtu.be/MmfmSMswVFM?t=2255" %}
Cleanup Graded Offered Demo from the Generate 5.3 Office Hour meeting.
{% endembed %}
