---
description: >-
  Data is migrated from the State’s source system into the Generate staging
  environment and then to the Fact and Dimension tables by Fact Type.
---

# Fact Type Table Validation Process

{% hint style="info" %}
If you are unfamiliar with how Generate defines Fact Types review the [Fact Type Table](../migration/fact-type-table/) page.
{% endhint %}

In a star schema database, the Fact table is a combination of the appropriate Dimension table data. The Fact table allows the user to slice and dice the data depending on which dimensions they return.

In Generate, the Fact table stores all the relevant data used by the report migration to populate the aggregated counts in the report table. Using Child Count as our example again, when the second migration (RDS) runs the data from Staging is populated into the dimension tables and ultimately into the Fact table, `RDS.FactK12StudentCounts`. That Fact table is also used by other reports for Homeless, Membership, etc. So, there are columns in the Fact table that are used for one report and not another.

The Fact table view will do two things. First, it will limit the results to only the columns that are relevant to the Fact Type and second, it will translate the Dimension table ID that is stored in the Fact Table back to the actual data values to make it easier to see and interact with the data.

The view uses the same column names from the Dimension tables so you can qualify your query of the view to get more specific information like all the students in a school, all the students with a specific disability type, or just a single student.

{% hint style="success" %}
NOTE: At this point in the migration process the data has been successfully migrated into the Fact and Dimension tables. There are 2 types of dimension tables. The first is a slowly changing dimension and examples of that are `DimPeople`, `DimLeas`, and `DimK12Schools`. That data can change over time and when you query data in the Fact table that comes from one of those, you would use the value as-is in the staging table.&#x20;

The other type of dimension table is called a junk dimension table. It is basically a way to group related data into a single table to reduce the number of dimension tables that need to be maintained and reduce bloat in the Fact table.&#x20;

The junk dimension tables in Generate store both the translated CEDS value and the ED_Facts_ value.

If the data element you want to use comes from one of those the view uses the ED_Facts_ value as shown below for IDEA Disability Type.&#x20;
{% endhint %}

```sql
select * from [debug].[vwChildCount_FactTable]
select * from [debug].[vwChildCount_FactTable] where SchoolIdentifierSea = '1234'
select * from [debug].[vwChildCount_FactTable] where IdeaDisabilityTypeEdFactsCode = 'AUT'
select * from
```
