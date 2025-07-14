# App.DimK12Students\_TestCase

### Overview & Purpose

This stored procedure is designed to test the integrity of student data matching between the Staging.K12Enrollment table and the RDS.DimK12Students dimension table. It creates or references a unit test record, performs a match between staging and dimension tables, and records the test results in App.SqlUnitTestCaseResult.

#### Main Functions:

*   **Student Data Matching Test**

    To verify that student records in the staging table can be properly matched with corresponding records in the dimension table based on multiple matching criteria.

#### Key Calculations:

*   **Student Data Matching Test: Compares the total count of student records with the count of successfully matched records**

    Formula: `COUNT(*) = COUNT(*) WHERE DimK12StudentId IS NOT NULL`

    Business Significance: Ensures data integrity and proper relationship between staging and dimension tables

    Example: If 100 students exist in the staging table and all 100 match in the dimension table, the test passes

#### Data Transformations:

* Joining staging enrollment data with dimension student data based on multiple matching criteria
* Creating a temporary table to store the match results
* Recording test results in the unit test results table

#### Expected Output:

A record in App.SqlUnitTestCaseResult indicating whether all student records in the staging table were successfully matched with records in the dimension table

### Business Context

**System:** K-12 Education Data Warehouse

**Necessity:** Ensures data quality and integrity between staging and production tables for student information

#### Business Rules:

* Student records must match on state identifier, name fields, sex, birth date, cohort, and enrollment dates
* Missing values are handled by converting them to standard placeholders for comparison

#### Result Usage:

Test results are used to validate ETL processes and data quality for the student dimension

#### Execution Frequency:

Likely executed as part of ETL validation or on-demand testing

#### Critical Periods:

* During data loads
* Before reporting periods
* After schema or ETL process changes

### Parameters

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores staging data for K-12 student enrollment information

**Columns:**

| Name                       | Data Type | Business Purpose                                        |
| -------------------------- | --------- | ------------------------------------------------------- |
| Student\_Identifier\_State | Unknown   | Unique identifier for a student at the state level      |
| LEA\_Identifier\_State     | Unknown   | Identifier for Local Education Agency (school district) |
| School\_Identifier\_State  | Unknown   | Identifier for the specific school                      |
| FirstName                  | Unknown   | Student's first name                                    |
| MiddleName                 | Unknown   | Student's middle name                                   |
| LastName                   | Unknown   | Student's last name                                     |
| Birthdate                  | Date      | Student's date of birth                                 |
| Sex                        | Unknown   | Student's sex/gender                                    |
| EnrollmentEntryDate        | DateTime  | Date when student enrolled                              |
| EnrollmentExitDate         | DateTime  | Date when student exited enrollment                     |
| CohortGraduationYear       | Integer   | Expected graduation year for student cohort             |

#### RDS.DimK12Students

**Business Purpose:** Dimension table storing K-12 student information

**Columns:**

| Name                   | Data Type | Business Purpose                                   |
| ---------------------- | --------- | -------------------------------------------------- |
| DimK12StudentId        | Integer   | Surrogate key for the student dimension            |
| StateStudentIdentifier | Unknown   | Unique identifier for a student at the state level |
| FirstName              | Unknown   | Student's first name                               |
| MiddleName             | Unknown   | Student's middle name                              |
| LastName               | Unknown   | Student's last name                                |
| SexCode                | Unknown   | Student's sex/gender code                          |
| BirthDate              | Date      | Student's date of birth                            |
| Cohort                 | Integer   | Expected graduation year for student cohort        |
| RecordStartDateTime    | DateTime  | Start date/time for the student record             |

#### App.SqlUnitTest

**Business Purpose:** Stores metadata about unit tests for SQL objects

**Columns:**

| Name                | Data Type | Business Purpose                          |
| ------------------- | --------- | ----------------------------------------- |
| SqlUnitTestId       | Integer   | Primary key for the unit test             |
| UnitTestName        | String    | Descriptive name for the unit test        |
| StoredProcedureName | String    | Name of the stored procedure being tested |
| TestScope           | String    | Scope or area of the test                 |
| IsActive            | Bit       | Indicates if the test is active           |

#### App.SqlUnitTestCaseResult

**Business Purpose:** Stores results of unit test case executions

**Columns:**

| Name            | Data Type | Business Purpose                      |
| --------------- | --------- | ------------------------------------- |
| SqlUnitTestId   | Integer   | Foreign key to the unit test metadata |
| TestCaseName    | String    | Name of the specific test case        |
| TestCaseDetails | String    | Detailed description of the test case |
| ExpectedResult  | Integer   | Expected numeric result of the test   |
| ActualResult    | Integer   | Actual numeric result of the test     |
| Passed          | Bit       | Indicates if the test passed          |
| TestDateTime    | DateTime  | When the test was executed            |

### Temporary Tables

#### #Students

**Purpose:** Temporarily stores the results of matching student records between staging and dimension tables

**Columns:**

| Name                       | Data Type | Purpose/Calculation                                   |
| -------------------------- | --------- | ----------------------------------------------------- |
| Student\_Identifier\_State | Unknown   | Direct copy from Staging.K12Enrollment                |
| LEA\_Identifier\_State     | Unknown   | Direct copy from Staging.K12Enrollment                |
| School\_Identifier\_State  | Unknown   | Direct copy from Staging.K12Enrollment                |
| FirstName                  | Unknown   | Direct copy from Staging.K12Enrollment                |
| MiddleName                 | Unknown   | Direct copy from Staging.K12Enrollment                |
| LastName                   | Unknown   | Direct copy from Staging.K12Enrollment                |
| Birthdate                  | Date      | Direct copy from Staging.K12Enrollment                |
| Sex                        | Unknown   | Direct copy from Staging.K12Enrollment                |
| RecordStartDateTime        | DateTime  | Copied from Staging.K12Enrollment.EnrollmentEntryDate |
| RecordEndDateTime          | DateTime  | Copied from Staging.K12Enrollment.EnrollmentExitDate  |
| DimK12StudentId            | Integer   | Copied from RDS.DimK12Students when match is found    |

### Potential Improvements

#### Error Handling

**Description:** Add TRY/CATCH blocks to handle potential errors during execution

**Benefits:** Prevents procedure failures and provides better diagnostics

**Priority:** Medium

#### Performance

**Description:** Add indexes to the temporary table for better performance

**Benefits:** Faster execution for large datasets

**Priority:** Low

#### Code Structure

**Description:** Modularize the code by creating separate procedures for test setup and execution

**Benefits:** Improved maintainability and reusability

**Priority:** Low

#### Documentation

**Description:** Add more detailed comments explaining the matching logic and test criteria

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Medium

### Execution Steps

#### Step 1: Define or retrieve the unit test metadata

**Input Data:** App.SqlUnitTest table

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'DimK12Students\_UnitTestCase') BEGIN ... END ELSE BEGIN ... END

#### Step 2: Clear previous test results

**Input Data:** App.SqlUnitTestCaseResult table

**Transformations:** None

DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

#### Step 3: Create temporary table with student data and match results

**Input Data:** Staging.K12Enrollment and RDS.DimK12Students tables

**Transformations:** Join between staging and dimension tables with multiple match conditions

SELECT ... INTO #Students FROM Staging.K12Enrollment ske LEFT JOIN RDS.DimK12Students rds ON ...

#### Step 4: Record test results

**Input Data:** #Students temporary table

**Transformations:** Aggregation to count total and matched records

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT ...

#### Step 5: Clean up temporary resources

**Input Data:** #Students temporary table

**Transformations:** None

DROP TABLE #Students
