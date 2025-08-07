# Debug Views for Staging and the Fact tables

### Data Migration and Views in Generate

Data is migrated from the state's source system into the Generate staging environment and then to the Fact and Dimension tables based on Fact Type. If you need more information on Fact Types, refer to the [**Fact Type Tables**](../migration/fact-type-table/) section.

To assist with data validation and analysis, Fact Type-specific views are available for both staging and Fact table data. For the Child Count Fact Type, these views can be accessed in the debug schema:

* `[debug].[vwChildCount_StagingTables]`
* `[debug].[vwChildCount_FactTable]`

### Staging Tables

Generate contains multiple staging tables, and depending on the file you're working on, you’ll load data into a specific combination of these tables. The staging debug view joins only the relevant tables and columns, allowing you to:

* Validate your ETL load
* Identify potential migration issues
* Analyze specific data elements for accuracy

Use this view alongside the [**Staging Validation**](staging-validation/) to ensure data is loaded accurately and students are categorized correctly in the reports.

The view uses the same column names from the Staging tables themselves so you can qualify your query of the view to get more specific information like all the students in a school, all the students with a specific disability type, or just a single student.

{% hint style="info" %}
**Note:** At this stage, codesets like Race, Disability Type, and Sex have not yet been converted to CEDS values, so use state-specific values in your queries.
{% endhint %}

**Example queries:**

```sql
SELECT * FROM [debug].[vwChildCount_StagingTables]
SELECT * FROM [debug].[vwChildCount_StagingTables] WHERE SchoolIdentifierSea = '1234'
SELECT * FROM [debug].[vwChildCount_StagingTables] WHERE IdeaDisabilityTypeCode = 'XYZ'
SELECT * FROM [debug].[vwChildCount_StagingTables] WHERE StudentIdentifierState = '123456789'
```

### Fact Table

In a star schema, the Fact table combines relevant Dimension table data, allowing you to analyze data based on various dimensions. In Generate, the Fact table stores data for report migration and populates aggregated counts in report tables. For example, in the Child Count Fact Type, when the second migration (RDS) runs, data is loaded from Staging into Dimension tables, and finally into the Fact table (`RDS.FactK12StudentCounts`). This table is also used for other reports, such as Homeless and Membership.

The Fact table view simplifies data by:

1. Limiting results to columns relevant to the Fact Type
2. Translating Dimension table IDs into actual data values for easier analysis

**Example queries:**

{% code overflow="wrap" %}
```sql
SELECT * FROM [debug].[vwChildCount_FactTable]
SELECT * FROM [debug].[vwChildCount_FactTable] WHERE SchoolIdentifierSea = '1234'
SELECT * FROM [debug].[vwChildCount_FactTable] WHERE IdeaDisabilityTypeEdFactsCode = 'AUT'
SELECT * FROM [debug].[vwChildCount_FactTable] WHERE K12StudentStudentIdentifierState = '123456789'
```
{% endcode %}

{% hint style="info" %}
**Note:** At this point in the migration process the data has been successfully migrated into the Fact and Dimension tables.&#x20;
{% endhint %}

#### Dimension Tables

Generate uses two types of dimension tables:

* **Slowly Changing Dimensions (SCDs):** These tables store data that may change over time, such as `DimPeople`, `DimLeas`, and `DimK12Schools`. When querying related Fact table data, use the values directly from the staging table.
* **Junk Dimension Tables:** These tables consolidate related data into one table to reduce the number of Dimension tables and minimize bloat in the Fact table. Junk dimension tables in Generate store both CEDS and E&#x44;_&#x46;acts_ values. For example, the E&#x44;_&#x46;acts_ value is used for IDEA Disability Type.
