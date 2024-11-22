# Researching Mismatches

## Researching Mismatches in File Comparison Results

Depending on the file specification, there are multiple ways to research discrepancies between the Legacy file and the Generate file. This section provides some general guidance to help with your research.

***

### Directory Mismatches

When a column in the C029 comparison table does not match, follow these suggested steps:

#### Record is missing from the Generate file:

1. Verify that the organization exists in `Staging.K12Organization` table.&#x20;

{% hint style="danger" %}
If the record <mark style="color:red;">**DOES NOT**</mark> exist in the staging table, then check the logic in the ETL to determine why the record was not loaded into Generate.&#x20;
{% endhint %}

{% hint style="success" %}
If the record <mark style="color:green;">**DOES**</mark> exist in the staging table, then check that the following values in the staging record

1. `LEA_IsReportedFederally` and/or `School_IsReportedFederally` set to 1
2. The `LEA_OperationalStatusDate` must be within the school year
3. The `School_OperationalStatusDate` must be within the school year
4. The `LEA_RecordStartDateTime` must be within the school year
5. The `LEA_RecordEndDateTime` must be NULL or within the school year
6. The `School_RecordStartDateTime` must be within the school year
7. The `School_RecordEndDateTime` must be NULL or within the school year
8. All columns that map to `Staging.SourceSystemReferenceData` must have a value that corresponds to an InputCode value in `Staging.SourceSystemReferenceData`. These columns include:
   1. `LEA_OperationalStatus`
   2. `LEA_CharterLEAStatus`
   3. `LEA_Type`
   4. `School_OperationalStatus`
   5. `School_Type`
{% endhint %}

#### Generate value differs from the Legacy value

1. Look at the data for the organization in the Staging.K12Organization table to verify that the value matches what the Generate migration process produced.&#x20;

{% hint style="danger" %}
If the value <mark style="color:red;">**DOES NOT**</mark> match what was produced after the data was migrated through Generate, contact Generate technical support.
{% endhint %}

{% hint style="success" %}
If the value <mark style="color:green;">**DOES**</mark> match what was produced by the Generate migration process, then check the logic in the ETL to determine why the value in Generate differs from the value in the Legacy file. There are several reasons that the data could be different:

1. If the Generate ETL is pulling data from a different source than the Legacy process
2. If the source data changed between the creation of the Legacy file and the Generate file
3. If the Legacy process includes some business rules to transform the data that were not included in the Generate ETL
{% endhint %}

{% hint style="info" %}
In some instances, the mismatches are acceptable. For example, if the Legacy file contained an address of “123 N Main <mark style="color:yellow;">**St**</mark>”, but the Generate file has “123 N Main <mark style="color:yellow;">**Street**</mark>”, your agency may consider this an acceptable difference.
{% endhint %}

The suggestions above also apply to addresses, phone numbers and grades offered. Simply look in the corresponding Generate Staging tables to determine if the records exist and what values were populated from the ETL. These tables include:

* `Staging.OrganizationAddress`
* `Staging.OrganizationPhone`
* `Staging.OrganizationGradeOffered`

***

### Mismatches in Other File Types

For non-Directory files, any differences would be related to the **`Amount`** column (student or personnel counts, depending on the file specification). If any Generate Amounts differ from the Legacy Amounts, there are some tools in Generate to help determine why.

#### Generate Amount is LESS than the Legacy Amount

When the Generate Amount is less than the Legacy Amount, this indicates that:

1. Students were excluded from the ETL logic
2. Student data in the Generate Staging tables are missing important information and were excluded during the Generate migration
3. Check that count of distinct students in `Staging.K12Enrollment`
   1. `select count(distinct Student_Identifier_State) from Staging.K12Enrollment`
   2. If the total count in Staging is less than the count in the Legacy file, then check the ETL logic to determine why not all students were loaded into Generate.

#### Total count in Staging equals or exceeds the Legacy count,&#x20;

When the total count in Staging equals or exceeds the Legacy count then check that the student exists in all Staging tables used by the file specification. Depending on the file specification, these tables could include:

* `Staging.K12Enrollment`
* `Staging.PersonRace`
* `Staging.PersonStatus`
* `Staging.ProgramParticipationSpecialEducation`
* `Staging.Discipline`
* `Staging.AssessmentResult`

1. Check that all required student values are populated in the various staging tables. For example:
   * In **Staging.K12Enrollment**, the student has value for School\_Identifier\_State and/or LEA\_Identifier\_State
   * In **Staging.K12Enrollment**, the EnrollmentEntryDate is within the school year and the EnrollmentExitDate is within the school year or is NULL
2. The student has a value for HispanicOrLatinoEthnicity (1 or 0)
3. All columns that map to Staging.SourceSystemReferenceData must have a value that corresponds to an InputCode value in Staging.SourceSystemReferenceData.  These columns include:
   * Sex
   * ExitOrWithdrawalType
   * GradeLevel
4. In Staging.PersonStatus, make sure any columns that correspond to the file specification are populated, and that the StatusStartDate and StatusEndDates are within the school year.
5. In Staging.ProgramParticipationSpecialEducation, verify that the ProgramParticipationBeginDate is within the school year and ProgramParticipationEndDate is within the school year or NULL.
6. In Staging.ProgramParticipationSpecialEducation, make sure the various columns are populated with values that map to an InputCode value in SourceSystemReferenceData.

#### Record is missing from the Generate file,

Verify that the organization exists in `Staging.K12Organization table`.&#x20;

{% hint style="danger" %}
If the record <mark style="color:red;">**DOES NOT**</mark> exist in the staging table, then check the logic in the ETL to determine why the record was not loaded into Generate.&#x20;
{% endhint %}

{% hint style="success" %}
If the record <mark style="color:green;">DOES</mark> exist in the staging table, then check that the following values in the staging record:

1. `LEA_IsReportedFederally` and/or `School_IsReportedFederally` set to 1
2. The `LEA_OperationalStatusDate` must be within the school year
3. The `School_OperationalStatusDate` must be within the school year
4. The `LEA_RecordStartDateTime` must be within the school year
5. The `LEA_RecordEndDateTime` must be NULL or within the school year
6. The `School_RecordStartDateTime` must be within the school year
7. The `School_RecordEndDateTime` must be within the school year
8. All columns that map to `SourceSystemReferenceData` must have a value that corresponds to an `InputCode` value in `SourceSystemReferenceData`. These columns include:
   * `LEA_OperationalStatus`
   * `LEA_CharterLEAStatus`
   * `LEA_Type`
   * `School_OperationalStatus`
   * `School_Type`
{% endhint %}

***

### Using Debug Tables

When a migration is run in Generate to move data from the Staging area into the Report tables, Generate creates a series of “debug” tables with the student Ids used in the final counts.  All these tables are in the Generate database in the debug schema.

<figure><img src="../../../.gitbook/assets/image (213).png" alt=""><figcaption></figcaption></figure>

You can query the appropriate table to see the list of students that make up the Generate count.&#x20;

{% hint style="info" %}
For example, let us say the SEA C002 Comparison results table shows a mismatch on a record where the `AgeID` = 10 and the `EdEnvironmentID` = RC39. The `LegacyAmount` might show 35, but the `GenerateAmount` might show 19.
{% endhint %}

The debug tables are named according to the Report Level, Category Set, and the subtotal columns.  Look for the table name that starts with “`debug.c002_SEA_`” and includes the description for “Age” and “Education Environment” in the table name. Then query that table with the appropriate filters to see the list of students that made up the count produced by Generate.

{% code overflow="wrap" %}
```sql
select * from [debug].[c002_Sea_ST7_2022_AGESA_EDENVIRIDEASA] where Age = '10' and IDEAEDUCATIONALENVIRONMENT = 'RC39'
```
{% endcode %}

Based on our example above, this query should return 19 students. You can take this list and compare it to your source data and/or Legacy data to determine the difference.
