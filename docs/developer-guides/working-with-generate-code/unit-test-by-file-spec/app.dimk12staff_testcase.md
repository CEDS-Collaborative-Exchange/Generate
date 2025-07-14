# App.DimK12Staff\_TestCase

### Overview & Purpose

This stored procedure is designed to test the integrity of K12 staff data by comparing records in the staging table with corresponding records in the dimension table. It creates a unit test case, executes the test, and records the results in a test tracking table.

#### Main Functions:

*   **Unit Test Setup**

    Creates or retrieves a unit test record in App.SqlUnitTest table
*   **Data Comparison**

    Compares staff records between staging and dimension tables

#### Key Calculations:

*   **Unit Test Setup: Register the test case in the unit test tracking system**

    Formula: `INSERT INTO App.SqlUnitTest`

    Business Significance: Ensures test cases are properly documented and tracked

    Example: UnitTestName = 'DimK12Staff\_UnitTestCase'
*   **Data Comparison: Verify that all staff records in staging have corresponding dimension records**

    Formula: `COUNT(*) = (SELECT COUNT(*) FROM #Staff WHERE DimPersonId IS NOT NULL)`

    Business Significance: Ensures data integrity between staging and dimension tables

    Example: CASE WHEN COUNT(\*) = (SELECT COUNT(\*) FROM #Staff WHERE DimPersonId IS NOT NULL) THEN 1 ELSE 0 END

#### Data Transformations:

* Joins staging K12 staff data with dimension people data based on StaffMemberIdentifierState and RecordStartDateTime
* Creates a temporary table to store the joined data for analysis

#### Expected Output:

Test case results recorded in App.SqlUnitTestCaseResult table, indicating whether all staff records in staging have corresponding dimension records

### Business Context

**System:** K12 Education Data Warehouse

**Necessity:** Ensures data quality and integrity for K12 staff data between staging and dimension tables

#### Business Rules:

* Staff records should match between staging and dimension tables
* Staff are identified by StaffMemberIdentifierState and RecordStartDateTime
* Only active K12 staff records are considered (IsActiveK12Staff = 1)

#### Result Usage:

Test results are used to validate ETL processes and data integrity for K12 staff data

#### Execution Frequency:

Likely executed as part of ETL validation or regular data quality checks

### Parameters

### Source Tables

#### Staging.K12StaffAssignment

**Business Purpose:** Stores staging data for K12 staff assignments

**Columns:**

| Name                       | Data Type | Business Purpose                                       |
| -------------------------- | --------- | ------------------------------------------------------ |
| StaffMemberIdentifierState | Unknown   | Unique identifier for staff members at the state level |
| RecordStartDateTime        | DateTime  | Indicates when the staff record became effective       |

#### RDS.DimPeople

**Business Purpose:** Dimension table storing people data including K12 staff

**Columns:**

| Name                               | Data Type                      | Business Purpose                                            |
| ---------------------------------- | ------------------------------ | ----------------------------------------------------------- |
| DimPersonId                        | Unknown (likely INT or BIGINT) | Primary key for the dimension table                         |
| K12StaffStaffMemberIdentifierState | Unknown                        | Staff identifier that links to staging data                 |
| RecordStartDateTime                | DateTime                       | Indicates when the dimension record became effective        |
| IsActiveK12Staff                   | BIT                            | Flag indicating if the person is an active K12 staff member |

#### App.SqlUnitTest

**Business Purpose:** Stores metadata about unit tests

**Columns:**

| Name                | Data Type           | Business Purpose                          |
| ------------------- | ------------------- | ----------------------------------------- |
| SqlUnitTestId       | INT                 | Primary key for unit test records         |
| UnitTestName        | VARCHAR or NVARCHAR | Descriptive name for the unit test        |
| StoredProcedureName | VARCHAR or NVARCHAR | Name of the stored procedure being tested |
| TestScope           | VARCHAR or NVARCHAR | Indicates the scope or area being tested  |
| IsActive            | BIT                 | Indicates if the test is currently active |

#### App.SqlUnitTestCaseResult

**Business Purpose:** Stores results of unit test executions

**Columns:**

| Name            | Data Type           | Business Purpose                                |
| --------------- | ------------------- | ----------------------------------------------- |
| SqlUnitTestId   | INT                 | Foreign key to the unit test definition         |
| TestCaseName    | VARCHAR or NVARCHAR | Name of the specific test case                  |
| TestCaseDetails | VARCHAR or NVARCHAR | Detailed description of the test case           |
| ExpectedResult  | INT                 | The expected result value for the test          |
| ActualResult    | INT                 | The actual result value from the test execution |
| Passed          | BIT                 | Indicates if the test passed (1) or failed (0)  |
| TestDateTime    | DATETIME            | When the test was executed                      |

### Temporary Tables

#### #Staff

**Purpose:** Temporarily stores joined data between staging and dimension tables for analysis

**Columns:**

| Name                       | Data Type                       | Purpose/Calculation                         |
| -------------------------- | ------------------------------- | ------------------------------------------- |
| StaffMemberIdentifierState | Unknown (inherited from source) | Direct copy from Staging.K12StaffAssignment |
| RecordStartDateTime        | DateTime                        | Direct copy from Staging.K12StaffAssignment |
| DimPersonId                | Unknown (inherited from source) | Joined from RDS.DimPeople                   |

### Potential Improvements

#### Error Handling

**Description:** Add TRY/CATCH blocks to handle potential errors during execution

**Benefits:** Improved reliability and easier troubleshooting

**Priority:** Medium

#### Documentation

**Description:** Add header comments explaining the procedure's purpose and parameters

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Low

#### Performance

**Description:** Add indexes to the temporary table for better performance

**Benefits:** Potentially faster execution for large datasets

**Priority:** Low

#### Functionality

**Description:** Add more detailed test cases to check specific aspects of the data

**Benefits:** More comprehensive testing and validation

**Priority:** Medium

### Execution Steps

#### Step 1: Drop temporary table if it exists

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID('tempdb..#Staff') IS NOT NULL DROP TABLE #Staff

#### Step 2: Initialize variables and create/retrieve unit test record

**Input Data:** App.SqlUnitTest table

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'DimK12Staff\_UnitTestCase') BEGIN...

#### Step 3: Clear previous test results

**Input Data:** App.SqlUnitTestCaseResult table

**Transformations:** None

DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

#### Step 4: Create temporary table with joined data

**Input Data:** Staging.K12StaffAssignment and RDS.DimPeople tables

**Transformations:** Left join between staging and dimension tables

SELECT ske.StaffMemberIdentifierState, ske.RecordStartDateTime, rds.DimPersonId INTO #Staff FROM...

#### Step 5: Insert test results

**Input Data:** #Staff temporary table

**Transformations:** Aggregation and comparison

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT @SqlUnitTestId, 'Staff Match',...
