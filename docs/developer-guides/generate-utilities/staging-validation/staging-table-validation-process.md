---
description: >-
  Data is migrated from the State’s source system into the Generate staging
  environment and then to the Fact and Dimension tables by Fact Type.
---

# Staging Table Validation Process

{% hint style="info" %}
If you are unfamiliar with how Generate defines Fact Types review the [Fact Type Table](../../migration/fact-type-table/) page.
{% endhint %}

If you are unfamiliar with how Generate defines Fact Types, check here \[link to Fact Type info]

To aid in the validation of that data and in researching specific subsets of data or specific student data we created Fact Type specific views for both the relevant Staging data and Fact table data. Using the Child Count fact type, these views can be found in the debug schema.

```sql
     - [debug].[vwChildCount_StagingTables] 
     - [debug].[vwChildCount_FactTable]
```

There are a number of staging tables in Generate and depending on the files that you’re working on you will be loading data into some combination of them. Also, depending on the file you will be loading data into a subset of columns in those tables. The staging debug view is built to join only the relevant tables, and more specifically, only the relevant columns from those tables together so you can quickly validate your ETL load, identify potential issues with further migrations, and research specific data elements for accuracy.

Use this view in combination with the [Staging Validations](./) to load Generate accurately and completely and also after the Reports have been populated to ensure students have been captured in the appropriate subgroups.

The view uses the same column names from the Staging tables themselves so you can qualify your query of the view to get more specific information like all the students in a school, all the students with a specific disability type, or just a single student.

{% hint style="success" %}
NOTE: _At this point in the migration process columns that are codesets like Race, Disability Type, Sex, etc.. have not been converted to the matching CEDS code values yet so these queries would use the appropriate state value in the where clause conditions._
{% endhint %}

{% code overflow="wrap" %}
```sql
select * from [debug].[vwChildCount_StagingTables]

select * from [debug].[vwChildCount_StagingTables] where SchoolIdentifierSea = '1234'
select * from [debug].[vwChildCount_StagingTables] where IdeaDisabilityTypeCode = 'XYZ'
select * from [debug].[vwChildCount_StagingTables] where StudentIdentifierState = '123456789'

```
{% endcode %}
