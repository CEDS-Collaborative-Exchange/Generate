# The New Report Migration Process

## Overview

The existing report migration process relies on a function called Get\_CountSQL. This function dynamically builds SQL for each EDFacts file. It pulls data from the appropriate Fact table and applies all file specification rules during aggregation.

Because this logic is generated dynamically, it is difficult to troubleshoot. The function has also grown to more than 8,000 lines of code since it supports nearly every EDFacts file. While the troubleshooting steps are documented, the complexity limits maintainability and scalability.

To address these issues, a new report migration process was introduced. This process replaces file specific dynamic SQL generation with a single stored procedure and two supporting views. The goal is to reduce code duplication, improve readability, and simplify troubleshooting.

{% hint style="success" %}
Troubleshoot documented for Get\_CountSQL dynamic SQL  process \[GP1] is located here - [https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting/troubleshooting-report-migration-results](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting/troubleshooting-report-migration-results)
{% endhint %}

This new process is currently implemented for the following files: 218, 219, 220, 221, 222, 224, 225, and 226. Additional files will be converted over time.

{% hint style="info" %}
NOTE: If you are working on a file that is designated as a pilot opportunity file in Generate, you may choose to use this new approach where feasible.
{% endhint %}

## Stored Procedure: RDS.Insert\_CountsIntoReportTable

The core of the new process is the stored procedure RDS.Insert\_CountsIntoReportTable. This procedure generates the required SQL dynamically, but the procedure itself does not vary by report. As a result, the total code size is approximately 400 lines.

The stored procedure accepts five parameters.

* **@ReportCode**
  * The three digit EDFacts file number.
* **@SubmissionYear**
  * The four digit school year for the submission.
* **@IdentifierToCount**
  * The column used for aggregation. This is typically a student or staff identifier.
* **@IsDistinctCount**
  * A yes or no flag that determines whether the aggregation requires a distinct count.
* **@RunAsTest**
  * A yes or no flag that enables debug mode. When set to yes, the procedure outputs the generated SQL without executing it. This supports validation and troubleshooting.

{% hint style="info" %}
NOTE: As files are converted to this new process, they are integrated into the existing migration workflow. No changes are required when running migrations through the Generate user interface. The stored procedure can also be executed directly from the database when needed.
{% endhint %}

## Execution Example Using File 222

The following example shows how to execute the stored procedure for file 222, Foster Care.

```
exec [RDS].[Insert_CountsIntoReportTable]
			@ReportCode  = '222',
			@SubmissionYear = '2025', 
			@IdentifierToCount = 'K12StudentStudentIdentifierState',
			@IsDistinctCount  = 1,
			@RunAsTest = 0
```

### Supporting Views&#x20;

In the legacy process, file specific logic lived inside the Get\_CountSQL function. In the new process, that logic is implemented through views. These views already exist in Generate, although some are still being expanded.

## Debug Fact Table View

The first view is the debug fact table view for the applicable Fact Type. For file 222, which is handled by the Title I Fact Type, this view is:

**debug.vwTitleI\_FactTable**

This view returns all relevant data that has successfully migrated into the Fact table. It is not report specific. Instead, it includes all data elements used across any file associated with that Fact Type.

{% hint style="info" %}
NOTE: If you are new to Generate a more in-depth explanation of the Fact Types can be found here - [https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/fact-type-table](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/fact-type-table)
{% endhint %}

For example, the Discipline Fact Type debug view includes elements required for files 005, 006, 007, 086, 088, 143, and 144.

Originally, debug views only exposed elements that were directly reported. To support the new migration process, these views were expanded to include additional fields required for file specification logic.

An example is organization operational status. Many file specifications require including open organizations and excluding closed ones. While operational status is not reported in file 222, it is required to determine which students should be considered during aggregation.

If you are working with a debug view that has not yet been expanded, debug.vwTitleI\_FactTable provides a reference for the additional fields now required.

## Report Specific View

The second view applies file specific filtering logic. This view exists in the RDS schema and follows a consistent naming convention that includes both the Fact Type and file number.

For file 222, the view is: &#x20;

**RDS.vwTitleI\_FactTable\_222**

This view consumes the full dataset returned by the debug view. It then applies file specification rules to identify the records that qualify for counting.

For file 222, the filtering logic includes:

* LEAs that are Open or New.
* LEAs that received Title I funds.
* Students within those LEAs who are marked as Foster Care participants.
