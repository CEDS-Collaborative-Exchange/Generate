---
description: >-
  DebugMode guidance for investigating Child Count fact migrations for files 002
  and 089.
---

# Debugging the Staging-to-Fact Migrations

Using stored procedure: `[Staging].[Staging-to-FactK12StudentCounts_ChildCount]` as an example

### Purpose

The DebugMode option helps troubleshoot why a specific student is or is not included in the Child Count fact migration for files 002 and 089.

### When to Use DebugMode

Use DebugMode when validating a single student's Child Count migration path. It is intended to show whether the student exists in the required staging data, whether required joins are satisfied, whether the enrollment date filter passes, and whether the student made it into the procedure's temporary `#Facts` table.

### Parameters

#### @SchoolYear

The school year being processed. This is used to derive the Child Count date and to match dimension and staging records.

#### @StudentIdentifierState

The state student identifier to inspect. This value is required when `@DebugMode = 1`.

#### @DebugMode

Set to 1 to run the procedure in diagnostic mode. The default value is 0, which runs the normal migration.

### Executing Debug mode

```sql
EXEC [Staging].[Staging-to-FactK12StudentCounts_ChildCount]
    @SchoolYear = 2026,
    @StudentIdentifierState = '123456789',
    @DebugMode = 1;
```

### What DebugMode Does

* Builds the same lookup temp tables used by the normal Fact migration process.
* Builds the `#Facts` temp table using the same required joins and filters as the normal process.
* Limits the fact-building query to the requested `@StudentIdentifierState`.
* Returns a diagnostic result set for that student.
* Stops immediately after the diagnostic result set by using `RETURN`.

### What DebugMode Does Not Do

* It does not delete existing rows from the Fact table.
* It does not insert rows into the Fact table.
* It does not rebuild indexes on the Fact table.

### Diagnostic Output Columns

{% hint style="info" %}
NOTE: The output columns will vary based on the Fact Type being processed. It pulls columns based on the inner join conditions for the population of the temp table `#Facts` in the corresponding Staging-to-Fact… stored procedure. Below are the examples from `[Staging].[Staging-to-FactK12StudentCounts_ChildCount]`.
{% endhint %}

#### StudentIdentifierState

The student identifier passed into the procedure.

#### K12EnrollmentStagingId

The matching `Staging.K12Enrollment.Id` for the student and school year, when found.

#### FoundInK12Enrollment

1 when a `Staging.K12Enrollment` record exists for the student and school year; otherwise 0.

#### MadeItIntoFacts

1 when the student produced a row in `#Facts`; otherwise 0.

#### DebugResult

The first required join or filter that appears to block the student from reaching `#Facts`, or Inserted into `#Facts` when the row was built successfully.

#### FactsRowsForStudent

The number of rows in `#Facts` for the debug run.

#### PassedEnrollmentDateFilter

1 when the Child Count date is within the student's enrollment entry and exit dates; otherwise 0.

#### MatchedDimSchoolYears

1 when the student's school year matches `RDS.DimSchoolYears`; otherwise 0.

#### MatchedDimK12Demographics

1 when the student's sex value matches `RDS.vwDimK12Demographics` for the school year; otherwise 0.

#### MatchedDimAges

1 when the student's age on the Child Count date matches `RDS.DimAges`; otherwise 0.

#### MatchedDimSeas

1 when a valid `RDS.DimSeas` record exists for the Child Count date; otherwise 0.

#### MatchedProgramParticipationSpecialEducation

1 when the student has a matching `Staging.ProgramParticipationSpecialEducation` record active on the Child Count date; otherwise 0.

### Quick Troubleshooting Flow

1. Run the procedure with `@DebugMode = 1` and the target `@StudentIdentifierState`.
2. Check ‘MadeItIntoFacts’. If it is 1, the student passed the fact-building logic.
3. If ‘MadeItIntoFacts’ is 0, review ‘DebugResult’ first. It identifies the likely blocking join or filter.
4. Use the matching boolean columns to confirm which required join or date filter failed.
5. Correct the source, staging, or dimension data, then rerun DebugMode for the same student.
