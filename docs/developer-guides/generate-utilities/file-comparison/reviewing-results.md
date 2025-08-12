# Reviewing Results

## Reviewing Comparison Results

After performing a file comparison, the resulting comparison table can be queried to view the results.

Most E&#x44;_&#x46;acts_ files contain records with an “**amount**” column – a count of students or personnel. This is the column that is compared between the Legacy and the Generate files.&#x20;

{% hint style="info" %}
Directory (FS029 and FS039) are different, and in those cases nearly every column in the files is compared.
{% endhint %}

In all cases, you can view the results of a comparison by running the following query in SSMS:

```sql
Select * from [Comparison Table Name]
```

Where `[Comparison Table Name]` is the fully qualified table name (database.schema.tablename) that contains the results. For example, the table might be named “`Generate.NH.029_LEA_2023_COMPARISON`”.

You can then filter the results as needed to determine which records have mismatches to be addressed.

### Reviewing Directory Comparison Results

The 029 file contains many columns of data that must be compared. The file comparison table that is created by the utility includes a Legacy column and a Generate column for nearly every column in the 029 file.

The table below compares records from the Legacy and Generate files, joined by **`SubmissionYear`**, **`ReportCode`**, **`ReportLevel`**, and **`StateSchoolIDNumber`**. The count of **`Errors`** in the row and a description of the **`Mismatches`** are indicated in subsequent columns. Each remaining column pairs data from the Legacy and Generate files, allowing you to easily spot discrepancies by scrolling across the table.

If a row has an Errors value = -1, this indicates the record exists in one of the files but not the other.  The Mismatch column will then indicate if the record is not in the Legacy file or not in the Generate file.

<div data-full-width="false"><figure><img src="../../../.gitbook/assets/File Comparison C029 SCH (1).PNG" alt="A table comparing records from Legacy and Generate files in the C029 report, including columns for SubmissionYear, ReportCode, ReportLevel, StateSchoolIDNumber, Errors, Mismatch, and various Legacy and Generate file columns. Errors marked as -1 indicate records present in only one file, with the Mismatch column specifying whether the record is missing from the Legacy or Generate file."><figcaption><p>This table compares records from Legacy and Generate files in the C029 report, matched by SubmissionYear, ReportCode, ReportLevel, and StateSchoolIDNumber. It shows error counts and mismatch descriptions, with each remaining column pairing data from both files. Errors with a value of -1 indicate records present in only one file, with details provided in the Mismatch column.</p></figcaption></figure></div>

The 039 Comparison table is similar to the 029 Comparison table but with fewer columns.  In most cases all results for the 039 that don’t match will show “-1” for the Errors because a Grade Level ID may not exist in one of the files.

You can alter the query to filter the results to only show records where the Errors <> 0 to simplify your review.  You can also create summary queries to view the scope of the errors.  For example:

{% code overflow="wrap" %}
```sql
select Errors, count(*) Records from TESTING.[NH].[029_SCH_2022_COMPARISON] group by Errors order by Errors
```
{% endcode %}

<figure><img src="../../../.gitbook/assets/image (215).png" alt="A table showing a summary of error records, with columns for Errors and Records. The table lists different error values (-1, 0, 1, 2, 3, 6) alongside their respective record counts, illustrating the distribution of errors in the dataset."><figcaption><p>Filtering and Summarizing Error Results</p></figcaption></figure>

***

### Reviewing Comparison Results of Other File Types

Nearly all other E&#x44;_&#x46;acts_ files only need to compare the Amount value between the Legacy and the Generate files.  Running the query to return results from the Comparison table will show various columns corresponding to the Category Sets in the E&#x44;_&#x46;acts_ report.  The “LegacyAmount” and “GenerateAmount” columns show the counts of students (or personnel, depending on the report) for each combination of Category Set groups.

&#x20;If the LegacyAmount and GenerateAmount do not match, then additional research can be done to determine the reason for the difference.  If a LegacyAmount is NULL, then that record is missing from the Legacy file.  If a GenerateAmount is NULL, then that record is missing from the Generate file.

To reduce the number of results to review, you can filter out records where the LegacyAmount and GenerateAmount match.

<figure><img src="../../../.gitbook/assets/File Comparison C002 SEA (1).PNG" alt="A table displaying comparison results between Legacy and Generate files in an EDFacts report. The columns include various IDs and amounts, with some columns showing NULL values and others showing counts. The LegacyAmount and GenerateAmount columns highlight counts of students or personnel for each category combination, indicating discrepancies where values differ."><figcaption><p>This table shows the comparison results between Legacy and Generate files in an ED<em>Facts</em> report. The <strong>LegacyAmount</strong> and <strong>GenerateAmount</strong> columns display counts of students or personnel for each combination of category sets. Differences between these amounts indicate discrepancies. NULL values in LegacyAmount or GenerateAmount show missing records in the respective files. Filter matching amounts to reduce the number of results to review.</p></figcaption></figure>

```sql
Select * from [Comparison Table Name] 
where isnull(LegacyAmount,0) <> isnull(GenerateAmount,0)
```

{% hint style="info" %}
#### A Note About Zero Counts

When no students (or personnel) exist for a combination of attributes, a zero count is included in the E&#x44;_&#x46;acts_ submission file.  Generate does not currently store zero counts in the Generate report tables. Instead, any zero counts are added to the actual submission file when it is created from Generate. The File Submission Comparison Utility accounts for this as follows:

If the Generate file table is missing a row (zero count row), but the corresponding row in the Legacy table contains a zero, then the utility treats this as a zero for the Generate value in the Comparison table.  This helps reduce the number of mismatched records and simply the review of the comparison results.

Given this logic, if a GenerateAmount is NULL, it means there are no students identified in that Category Set, and would result in a zero value in the Generate-produced submission file.

***

**In order to do a comparison that fully compares zero counts in the Generate submission file, load the Generate submission file into a table and run the comparison using the "**[**Comparing All Other Files**](run-the-file-comparison.md#comparing-all-other-files)**" instructions.**
{% endhint %}
