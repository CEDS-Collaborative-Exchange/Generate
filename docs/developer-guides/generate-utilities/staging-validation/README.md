---
description: >-
  This new validation process includes an expanded library of validation rules
  and makes it easier to create and manage custom validation rules.
---

# Staging Validation

## Staging Validation Overview

Once data has been loaded into the Generate Staging tables, the Staging Validation process can be executed within SQL Server Management Studio (SSMS). This process scans the data in corresponding staging tables and applies validation rules to determine if any data have issues.&#x20;

A Staging Validation rule can apply to a particular column in a staging table or can be defined to apply validation logic across multiple columns/conditions. A rule can be associated to one or more E&#x44;_&#x46;acts_ reports. For example, Generate includes a rule that column `StudentIdentifierState` in table `Staging.K12Enrollment` is required. This rule is associated to all E&#x44;_&#x46;acts_ reports that produce student counts.&#x20;

Generate currently includes a library of over 50 pre-defined staging validation rules, located in table `Staging.StagingValidationRules`. These rules are used in over 1,000 instances across multiple Fact Types and Report Codes. The full list of rules and relationships can be viewed in `Staging.vwStagingValidationRules`.&#x20;

Rules can be defined, added, and associated at any time by the Generate developers and SEA users.&#x20;

{% hint style="info" %}
More information for how to add rules is later in this document.

[#creating-staging-validation-rules](./#creating-staging-validation-rules "mention")
{% endhint %}

### Run Staging Validation

Load data into the Generate Staging Tables, then execute the following procedure in SSMS (with the appropriate parameter values) to run the validation process:

```sql
exec staging.StagingValidation_Execute 
@SchoolYear = 2024, 
@FactTypeOrReportCode = 'childcount', 
@RemoveHistory = 1, 
@PrintSQL = 0
```

<table><thead><tr><th width="246">Parameter</th><th>Description</th></tr></thead><tbody><tr><td><strong>@SchoolYear</strong></td><td>The school year that corresponds to the data in staging.</td></tr><tr><td><strong>@FactTypeOrReportCode</strong></td><td>Either an ED<em>Facts</em> Report Code (i.e., C029, C002, C005) or a Generate Fact Type (i.e., Directory, ChildCount, Exiting). If an incorrect value is provided, the query will return a list of valid values.</td></tr><tr><td><strong>@RemoveHistory</strong></td><td>Determines if the validation results will replace historical validation results for the same school year and fact type/report code or will append to the existing results. This is an optional parameter, and if not supplied will default to 0 (<mark style="background-color:yellow;">do not remove history</mark>).</td></tr><tr><td><strong>@PrintSQL</strong></td><td>A debugging capability that will display the dynamic SQL that will run to perform the staging validation. This is an optional parameter and if not supplied will default to 0 (<mark style="background-color:yellow;">do not show the SQL</mark>).</td></tr></tbody></table>

### View Staging Validation Process Results

To view the results of the validation process, execute the following procedure in SSMS (with the appropriate parameter values):

```sql
exec staging.StagingValidation_GetResults 
@SchoolYear = 2024, 
@FactTypeOrReportCode = 'childcount', 
@IncludeHistory = 0
```

<table><thead><tr><th width="244">Parameter</th><th>Description</th></tr></thead><tbody><tr><td><strong>@IncludeHistory</strong></td><td>Will include all history of the validation results for the school year and fact type/report code as well as the latest results (assuming the history is still available) based on the <strong>@RemoveHistory</strong> parameter value used when executing the Staging Validation process. This is an optional parameter and if not provided will default to 0 (<mark style="background-color:yellow;">do not include history in the results</mark>).</td></tr></tbody></table>

Results of the Staging Validation process will be displayed in SSMS, similar to the example below:

{% hint style="success" %}
If no results are returned, it means the staging data passed all existing validation rules.
{% endhint %}

#### Staging Validation Columns

<table><thead><tr><th width="245">Column name</th><th>Description</th></tr></thead><tbody><tr><td>Id</td><td>Internal Id for the result record.</td></tr><tr><td>StagingValidationRuleId</td><td><p>The Rule Id that was processed to produce the result. There may be some auto-generated results that do not pertain to a rule:</p><ul><li>-1 This indicates that a staging table is required for the specific report and cannot be empty.</li><li>-2 This indicates that an option set value in a staging table is not mapped in the Generate <code>Staging.SourceSystemReferenceData</code> table.</li><li>-9 This indicates that the defined rule has a syntax error and could not be executed. Any results having a -9 should be reviewed by the rule developer.</li></ul></td></tr><tr><td>SchoolYear</td><td>The school year for which the result applies.</td></tr><tr><td>FactTypeOrReportCode</td><td>The fact type or report code for which the result applies.</td></tr><tr><td>StagingTableName</td><td>The staging table name for which the result applies.</td></tr><tr><td>ColumnName</td><td>The column name in the staging table for which the result applies.</td></tr><tr><td>Severity</td><td><p>The severity level of the result. Options are:</p><ul><li>Informational – this result indicates that the data may have an issue that may produce invalid report data.</li><li>Error – this result indicates that the data will likely produce incorrect report data.</li><li>Critical – this result indicates that the data may cause the migration to fail and/or the report to not produce.</li></ul></td></tr><tr><td>ValidationMessage</td><td>Provides information about the result.</td></tr><tr><td>RecordCount</td><td>The number of records identified as not passing the validation rule.</td></tr><tr><td>ShowRecordsSQL</td><td>A SQL query that will produce the records that failed the validation. You can copy the contents from this cell into a query window and execute it to see the data.</td></tr><tr><td>InsertDate</td><td>The date and time the Staging Validation process inserted this result into the table.</td></tr></tbody></table>

ETL developers can review the staging validation results and respond as needed to remediate the finding. This may include the following actions:

1. Changes to the source data.
2. Changes to the ETL.
3. Adjustments to mapped values in `Staging.SourceSystemReferenceData.`
4. Review by data owners and/or E&#x44;_&#x46;acts_ coordinators to determine if any action is needed.

After making changes and refreshing staging data if needed, the Staging Validation process can be rerun to review the updated results.

***

## Staging Validation Technical Details

The Staging Validation utility is comprised of the following components:

### Staging Tables

* `StagingValidationResults` – contains the results of staging validation executions
* `StagingvalidationRules` – contains the staging validation rules
* `StagingValidationRules_ReportsXREF` – contains the cross-reference showing which staging validation rules apply to which E&#x44;_&#x46;acts_ reports.

### Staging Stored Procedures

* `StagingValidation_Execute` – executes the staging validation process
* `StagingValidation_GetResults` – shows the results of the staging validation process
* `StagingValidation_InsertRule` – used to insert a new rule into the Staging Validation Rules table
* `StagingValidation_AssignRuleToReports` – used to assign an existing rule to reports

### Staging Views

* `vwStagingValidationRules` – shows all staging validation rules and their relationship to E&#x44;_&#x46;acts_ reports

### Viewing Existing Staging Validation Rules

To view rule definitions, query table `Staging.StagingValidationRules`:

```sql
select * from staging.StagingValidationRules
```

#### Staging Validation Rules Columns

<table><thead><tr><th width="238">Column name</th><th>Description</th></tr></thead><tbody><tr><td>StagingValidationRuleId</td><td>The internal rule Id.</td></tr><tr><td>StagingTableId</td><td>The staging table Id for which this rule applies.</td></tr><tr><td>StagingColumnId</td><td>The staging column Id for which this rule applies.</td></tr><tr><td>RuleDscr</td><td>A description of the rule.</td></tr><tr><td>Condition</td><td>The programmatic condition for this rule.</td></tr><tr><td>ValidationMessage</td><td>The message included in the validation result.</td></tr><tr><td>Severity</td><td>The severity level for the rule.</td></tr><tr><td>CreatedBy</td><td>The rule creator.<br>All rules created by the CIID development team will show “Generate”. Custom rules created by SEAs can have whatever value they prefer.</td></tr><tr><td>CreatedDateTime</td><td>The date and time the rule was inserted into the table.</td></tr></tbody></table>

Since this table contains **Id** values, a better way to view the rules is to use the **view**. To view all existing Staging Validation rules and determine for which reports they are applied, query `Staging.vwStagingValidationRules`:

```sql
select * from staging.vwStagingValidationRules
```

The view shows all columns from `Staging.StagingValidationRules`, but also shows if/where those rules area applied by returning the following additional columns:

* **StagingValidationRuleId** – the internal Id for a validation rule. If this value is NULL, it means that no rule exists that is associated to the report code, table and column shown.
* **StagingValidationRuleId\_XREF** – this indicates if the rule is associated to a report code. If this value is NULL, it means that the rule is not associated to a report code.

<table><thead><tr><th width="238">Column Name</th><th>Description</th></tr></thead><tbody><tr><td>FactTypeCode</td><td>The Fact Type for which this rule applies. Fact Types are groups of ED<em>Facts</em> reports such as “Assessment”, “Directory”, “Discipline”, etc.</td></tr><tr><td>DimFactTypeId</td><td>The internal Id for the Fact Type.</td></tr><tr><td>ReportCode</td><td>The ED<em>Facts</em> Report Code for which this rule applies.</td></tr><tr><td>ReportName</td><td>The ED<em>Facts</em> Report Name for which this rule applies.</td></tr><tr><td>GenerateReportId</td><td>The internal Id for the Report.</td></tr><tr><td>StagingTableName</td><td>The name of the Staging column for which this rule applies.</td></tr><tr><td>GenerateReportId_XREF</td><td>The internal report Id for which this rule applies.</td></tr><tr><td>Enabled_XREF</td><td>Indicates if this rule is enabled. A rule can be disabled or enabled, and only enabled rules will be executed during the Staging Validation process.</td></tr></tbody></table>

#### Understanding StagingValidationRuleId and StagingValidationRuleId\_XREF:

View `vwStagingValidationRules` shows a left join on all possible combinations of Staging Tables, Staging Columns and E&#x44;_&#x46;acts_ Reports. Columns `StagingValidationRuleId` and `StagingValidationRuleId_XREF` shows if a rule exists and if/where that rule is being applied.

| StagingValidationRuleId | StagingValidationRuleId\_XREF | Explanation                                                                                          |
| ----------------------- | ----------------------------- | ---------------------------------------------------------------------------------------------------- |
| NULL                    | NULL                          | No rule exists for the Staging Table and Staging Column shown.                                       |
| NOT NULL                | NULL                          | A rule exists for the Staging Table and Staging Column but is not associated with the Report Code.   |
| NOT NULL                | NOT NULL                      | A rule exists for the Staging Table and Staging Column and is associated with the Report Code shown. |
| NULL                    | NOT NULL                      | This combination will not exist.                                                                     |

***

## Creating Staging Validation Rules

The Staging stored procedure named “`StagingValidation_InsertRule`” can be used to easily add new rules to the database. The procedure accepts the following parameters:

<table><thead><tr><th width="248">Parameters</th><th>Description</th></tr></thead><tbody><tr><td><strong>@FactTypeOrReportCode</strong></td><td>The Fact Type or Report Code(s) for which this rule applies. This parameter can be single Fact Type value, a single Report Code value, a comma-delimited list of Report Code values, or have a value of “All” to indicate this rule applies to all ED<em>Facts</em> reports for which the Staging Table is used.</td></tr><tr><td><strong>@StagingTableName</strong></td><td>the Staging table for which this rule applies</td></tr><tr><td><strong>@StagingColumnName</strong></td><td>the Staging column for which this rule applies</td></tr><tr><td><strong>@RuleDscr</strong></td><td>a description for the rule</td></tr><tr><td><strong>@Condition</strong></td><td><p>the logic condition this rule applies to determine the rule result. There are three methods for defining a condition:</p><ul><li>“Required” – if the <strong>@Condition</strong> value is “Required”, this rule indicates that the staging column is required to be populated and must not contain NULL values.</li><li>“where ….” – if the <strong>@Condition</strong> value starts with “where”, the rule looks for all record in the Staging Table and Staging Column where the condition exists and returns all columns from the Staging Table in the results.</li><li>“select …” – if the <strong>@Condition</strong> value starts with “select”, the rule applies the logic defined in the rule, and will return the data elements specified in the condition.</li></ul></td></tr><tr><td><strong>@ValidationMessage</strong></td><td>the message returned in the Validation Result when the data fails the validation rule.</td></tr><tr><td><strong>@CreatedBy</strong></td><td>indicates who created the rule. All rules provided in the Generate releases will show “Generate”. States can populate this with their preferred value for rules they create.</td></tr><tr><td><strong>@Enabled</strong></td><td>indicates if the rule is enabled. Only enabled rules are executed by the Staging Validation process</td></tr></tbody></table>

{% hint style="info" %}
Notice that the “Severity” for a rule is not a parameter for inserting a rule. Generate will automatically set the severity for a rule.
{% endhint %}

Also note that Generate automatically applies some validations that are not defined as a rule. For example, Generate knows which staging tables are required to contain data for certain E&#x44;_&#x46;acts_ reports. Generate also knows which staging columns must contain option set values mapped in the `SourceSystemReferenceData` table. Therefore, no rules exist in the `StagingValidationRules` table for these instances. Instead, Generate automatically applies these rules when executing the Staging Validation process, so rules do not need to be manually defined for these conditions. These automatic results will show a specific Rule Id in the results:

* -1 This indicates that a staging table is required for the specific report and cannot be empty
* -2 This indicates that an option set value in a staging table is not mapped in the Generate `Staging.SourceSystemReferenceData` table.
* -9 This indicates that the defined rule has a syntax error and could not be executed. Any results having a -9 should be reviewed by the rule developer.

### Examples

#### Adding a REQUIRED Rule:

This example shows how to add a REQUIRED rule to a specific column in a specific table for a specific EDFacts report code.The @Condition value = “Required”

```sql
exec Staging.StagingValidation_InsertRule
@FactTypeOrReportCode = 'C141',
@StagingTableName = 'ProgramParticipationSpecialEducation',
@StagingColumnName = 'IdeaIndicator',
@RuleDscr = 'Cannot be NULL',
@Condition = 'Required',
@ValidationMessage = 'Cannot be NULL',
@CreatedBy = 'Generate',
@Enabled = 1
```

***

#### Adding a Conditional Rule with Basic Logic:

This example shows how to add a simple conditional rule that applies to a single staging table and column for all reports that are part of Fact Type “Discipline”. The **@Condition** value starts with “where”. The results will search all records in **@StagingTableName** where the condition exists.

{% code overflow="wrap" fullWidth="false" %}
```sql
exec Staging.StagingValidation_InsertRule
@FactTypeOrReportCode = 'Discipline',
@StagingTableName = 'Discipline',
@StagingColumnName = 'DisciplinaryActionStartDate',
@RuleDscr = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
@Condition = 'where DisciplinaryActionStartDate > isnull(DisciplinaryActionEndDate, getdate())',
@ValidationMessage = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
@CreatedBy = 'Generate',
@Enabled = 1
```
{% endcode %}

***

#### Adding a Conditional Rule with Expanded Logic:

This example shows how to add a conditional rule with expanded logic that may span multiple tables and columns. This rule is specific to the list of Reports shown in the **@FactTypeOrReportCode** parameter. The **@Condition** value starts with “select”, so the results will show only the columns defined in the condition.

```sql
exec Staging.StagingValidation_InsertRule
@FactTypeOrReportCode= 'C052, C032, C086, C141',
@StagingTableName = 'K12Enrollment',
@StagingColumnName = 'GradeLevel',
@RuleDscr = 'A student can only be enrolled in a single grade',
@Condition = 'select StudentIdentifierState, count(*) GradeLevels from (
select distinct StudentIdentifierState, GradeLevel from staging.K12Enrollment) A
group by StudentIdentifierState
having count(*) > 1',
@ValidationMessage = 'A student can only be enrolled in a single grade',
@CreatedBy = 'Generate',
@Enabled = 1
```

***

#### Adding a Conditional Rule For ALL Reports:

This example shows how to add a conditional rule that applies to all E&#x44;_&#x46;acts_ reports for which the **@StagingTableName** is used. The **@FactTypeOrReportCode** value = “All”. This rule is saying that the RecordStartDateTime column in Staging.K12Enrollment must meet the condition in all E&#x44;_&#x46;acts_ reports that use the K12Enrollment table.

```sql
exec Staging.StagingValidation_InsertRule
@FactTypeOrReportCode = 'All',
@StagingTableName = 'K12Enrollment',
@StagingColumnName = 'RecordStartDateTime',
@RuleDscr = 'RecordStartDateTime must be before RecordEndDateTime',
@Condition = 'where RecordStartDateTime > isnull(RecordEndDateTime, getdate())',
@ValidationMessage = 'RecordStartDateTime must be before RecordEndDateTime',
@CreatedBy = 'Generate',
@Enabled = 1
```

***

#### Assigning Existing Rules to a Fact Type or Report Code(s)

If a rule exists in `StagingValidationRules`, but is not associated to a specific Fact Type or Report Code, Generate provides the capability to create these relationships with procedure `StagingValidation_AssignRuleToReports`. The procedure accepts the following parameters:

<table><thead><tr><th width="258">Parameter</th><th>Description</th></tr></thead><tbody><tr><td><strong>@StagingValidationRuleId</strong></td><td>The rule Id to be assigned</td></tr><tr><td><strong>@FactTypeOrReportCode</strong></td><td>The Fact Type or Report Code(s) for which this rule applies. This parameter can be single Fact Type value, a single Report Code value, a comma-delimited list of Report Code values, or have a value of “All” to indicate this rule applies to all ED<em>Facts</em> reports for which the Staging Table is used.</td></tr><tr><td><strong>@CreatedBy</strong></td><td>Indicates who created the rule. All rules provided in the Generate releases will show “Generate”. States can populate this with their preferred value for rules they create.</td></tr><tr><td><strong>@Enabled</strong></td><td>Indicates if the rule is enabled. Only enabled rules are executed by the Staging Validation process.</td></tr></tbody></table>

Below are several examples of using the procedure to assign a rule:

This example assigns rule 36 to all Assessment reports.

```sql
exec Staging.StagingValidation_AssignRuleToReports
@StagingValidationRuleId = 36,
@FactTypeOrReportCode = 'Assessment',
@CreatedBy = 'Generate',
@Enabled = 1
```

\
This example assigns rule 19 to reports C188 and C189.

```sql
exec Staging.StagingValidation_AssignRuleToReports
@StagingValidationRuleId = 19,
@FactTypeOrReportCode = 'C188, C189',
@CreatedBy = 'Generate',
@Enabled = 1
```

***

## Additional Information

1. When a new version of Generate is released, all Validation Rules provided by the Generate development team will be replaced/updated. Any Validation Rules created by SEAs will be retained in the new version.
2. If new Staging Tables and/or Staging Columns are added to Generate, the Generate Development team will need to add rows to the following tables in the App schema to allow rules to be created for those new tables/columns:
   1. `App.GenerateStagingTables`
   2. `App.GenerateStagingColumns`
   3. `App.SourceSystemReferenceMapping_DomainFile_XREF`
3. `App.vwStagingRelationships` shows the relationship between Fact Types, Report Codes, Staging Tables, Staging Columns and `SourceSystemReferenceData`.
