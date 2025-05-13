# App.FS032\_TestCase

### Overview & Purpose

This stored procedure is designed to test and validate the accuracy of student count data in the EdFacts reporting system. It creates test cases for various category sets (CSA through CSF, ST1, and TOT) across different reporting levels (SEA, LEA, SCH) and compares expected results with actual results from the reporting system.

#### Main Functions:

*   **Student Count Validation**

    To verify that student counts in the EdFacts reporting system match expected counts based on source data
*   **Test Case Management**

    To create, track, and record test case results for data validation

#### Key Calculations:

*   **Student Count Validation: To count unique students across various demographic and educational categories**

    Formula: `COUNT(DISTINCT StudentIdentifierState)`

    Business Significance: Ensures accurate reporting of student populations for federal/state compliance

    Example: Counting students by grade level, race, and sex for the CSA category set
*   **Test Case Management: To determine if expected and actual student counts match**

    Formula: `CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END`

    Business Significance: Provides a pass/fail indicator for each test case

    Example: Comparing expected student counts from staging data with actual counts in the reporting system

#### Data Transformations:

* Creating temporary tables for each category set and reporting level combination
* Aggregating student counts by various demographic and educational attributes
* Comparing calculated counts with stored counts in the reporting system
* Recording test results in the App.SqlUnitTestCaseResult table

#### Expected Output:

The procedure populates the App.SqlUnitTestCaseResult table with test case results, including test case names, details, expected and actual counts, and pass/fail indicators.

### Business Context

**System:** EdFacts Reporting System

**Necessity:** To ensure accurate reporting of student demographic and educational data to federal and state authorities

#### Business Rules:

* Student counts must be calculated based on distinct student identifiers
* Students must be categorized by various demographic and educational attributes
* Data must be aggregated at SEA (State), LEA (District), and SCH (School) levels
* Test cases must validate all required category sets (CSA through CSF, ST1, and TOT)

#### Result Usage:

Results are used to validate the accuracy of the EdFacts reporting system and identify discrepancies that need correction

#### Execution Frequency:

Likely executed on an as-needed basis during testing cycles or after data updates

#### Critical Periods:

* Before EdFacts submission deadlines
* After major data updates or system changes

### Parameters

| Parameter   | Data Type | Purpose                                                   | Required |
| ----------- | --------- | --------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which to run the test cases | True     |

### Source Tables

#### debug.vwStudentDetails

**Business Purpose:** Provides student demographic and educational data for analysis

**Columns:**

| Name                   | Data Type | Business Purpose                                |
| ---------------------- | --------- | ----------------------------------------------- |
| SchoolYear             | Unknown   | Identifies the academic year                    |
| StudentIdentifierState | Unknown   | Unique identifier for students within the state |
| GradeLevelEdFactsCode  | Unknown   | Standardized code for student grade level       |

#### staging.K12Enrollment

**Business Purpose:** Stores student enrollment data

**Columns:**

| Name                           | Data Type | Business Purpose                                     |
| ------------------------------ | --------- | ---------------------------------------------------- |
| StudentIdentifierState         | Unknown   | Unique identifier for students within the state      |
| LeaIdentifierSeaAccountability | Unknown   | Identifier for the Local Education Agency (district) |

#### RDS.ReportEdFactsK12StudentCounts

**Business Purpose:** Stores the actual student count data for EdFacts reporting

**Columns:**

| Name         | Data Type | Business Purpose                                          |
| ------------ | --------- | --------------------------------------------------------- |
| ReportCode   | Unknown   | Identifies the specific EdFacts report                    |
| ReportYear   | Unknown   | Identifies the reporting year                             |
| StudentCount | Unknown   | The count of students for a specific category combination |

### Temporary Tables

#### #vwStudentDetails

**Purpose:** Temporary storage of filtered student details from the source view

**Columns:**

| Name                   | Data Type | Purpose/Calculation                                                       |
| ---------------------- | --------- | ------------------------------------------------------------------------- |
| SchoolYear             | Unknown   | Direct copy from source                                                   |
| StudentIdentifierState | Unknown   | Direct copy from source                                                   |
| GradeLevelEdFactsCode  | Unknown   | Derived from GradeLevelEdFactsCode with transformation for grades below 7 |

#### #staging

**Purpose:** Combines student details with additional attributes needed for testing

**Columns:**

| Name                                  | Data Type | Purpose/Calculation                                          |
| ------------------------------------- | --------- | ------------------------------------------------------------ |
| All columns from #vwStudentDetails    | Various   | Direct copy from source                                      |
| EconomicDisadvantageStatusEdFactsCode | Unknown   | Derived from staging.PersonStatus.EconomicDisadvantageStatus |
| MigrantStatusEdFactsCode              | Unknown   | Derived from staging.PersonStatus.MigrantStatus              |
| HomelessnessStatusEdFactsCode         | Unknown   | Derived from staging.PersonStatus.HomelessnessStatus         |

#### #SEA\_CSA, #LEA\_CSA, #SCH\_CSA (and similar for other category sets)

**Purpose:** Store aggregated student counts for each category set and reporting level

**Columns:**

| Name                                                                            | Data Type | Purpose/Calculation                    |
| ------------------------------------------------------------------------------- | --------- | -------------------------------------- |
| GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode (varies by category set) | Unknown   | Direct copy from #staging              |
| StudentCount                                                                    | Unknown   | COUNT(DISTINCT StudentIdentifierState) |

### Potential Improvements

#### Error Handling

**Description:** Add comprehensive error handling with TRY/CATCH blocks and specific error messages

**Benefits:** Better troubleshooting and more robust execution

**Priority:** Medium

#### Performance

**Description:** Add appropriate indexes to temporary tables for better join performance

**Benefits:** Faster execution, especially with large data volumes

**Priority:** Medium

#### Code Organization

**Description:** Refactor repetitive code blocks into dynamic SQL or table-driven approach

**Benefits:** Reduced code size, easier maintenance

**Priority:** Low

#### Documentation

**Description:** Add more detailed inline documentation about business rules and data transformations

**Benefits:** Better understanding for future maintainers

**Priority:** Low

### Execution Steps

#### Step 1: Initialize by dropping any existing temporary tables

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID('tempdb..#Staging') IS NOT NULL DROP TABLE #Staging

#### Step 2: Set up unit test metadata

**Input Data:** Test name, procedure name, scope, and report code

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) BEGIN INSERT INTO App.SqlUnitTest... END

#### Step 3: Clear previous test results

**Input Data:** SqlUnitTestId

**Transformations:** None

DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

#### Step 4: Create and populate temporary student details table

**Input Data:** debug.vwStudentDetails

**Transformations:** Grade level transformation for grades below 7, disability status derivation

select SchoolYear, StudentIdentifierState, ... into #vwStudentDetails from debug.vwStudentDetails vw where SchoolYear = @SchoolYear

#### Step 5: Create and populate main staging table

**Input Data:** #vwStudentDetails, staging.K12Enrollment, staging.PersonStatus, RDS dimension tables

**Transformations:** Derivation of status codes for economic disadvantage, migrant, and homelessness

select vsd.\*, case when sps.EconomicDisadvantageStatus = 1 then 'ECODIS' else '' end EconomicDisadvantageStatusEdFactsCode, ... into #staging from #vwStudentDetails vsd inner join staging.K12Enrollment ske ...

#### Step 6: Process each category set (CSA through TOT) for each reporting level (SEA, LEA, SCH)

**Input Data:** #staging

**Transformations:** Aggregation by various dimension combinations

SELECT GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #SEA\_CSA FROM #staging GROUP BY GradeLevelEdFactsCode, RaceEdFactsCode, SexEdFactsCode

#### Step 7: Compare expected and actual results for each test case

**Input Data:** Temporary tables with expected counts, RDS.ReportEdFactsK12StudentCounts

**Transformations:** None

INSERT INTO App.SqlUnitTestCaseResult ... SELECT @SqlUnitTestId, @CategorySet + ' ' + @ReportLevel, 'Grade: ' + s.GradeLevelEdFactsCode + ..., s.StudentCount, Fact.StudentCount, CASE WHEN s.StudentCount = ISNULL(Fact.StudentCount, -1) THEN 1 ELSE 0 END, GETDATE() FROM #SEA\_CSA s JOIN RDS.ReportEdFactsK12StudentCounts Fact ...
