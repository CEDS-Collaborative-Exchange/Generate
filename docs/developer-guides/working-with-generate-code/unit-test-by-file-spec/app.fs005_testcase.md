# App.FS005\_TestCase

### Overview & Purpose

This stored procedure is designed to test the accuracy of student discipline data reporting for students with disabilities under IDEA (Individuals with Disabilities Education Act). It specifically validates data for the EDFacts report C005, which focuses on disciplinary actions involving students with disabilities who received interim removals. The procedure creates test data, compares it with actual report data, and logs the results of these comparisons.

#### Main Functions:

*   **Data Preparation**

    Gathers and transforms student discipline data for testing purposes
*   **Test Execution**

    Compares prepared test data with actual report data across multiple category sets and organizational levels

#### Key Calculations:

*   **Data Preparation: Transforms race/ethnicity data into EDFacts reporting codes**

    Formula: `CASE WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HI7' WHEN spr.RaceType = 'AmericanIndianorAlaskaNative' THEN 'AM7'...`

    Business Significance: Ensures proper categorization of students by race/ethnicity for federal reporting

    Example: A student with HispanicLatinoEthnicity = 1 would be assigned RaceEdFactsCode = 'HI7'
*   **Data Preparation: Calculates student age as of the child count date**

    Formula: `rds.Get_Age(ske.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @SchoolYear - 1 ELSE @SchoolYear END, @cutOffMonth, @cutOffDay))`

    Business Significance: Ensures only students aged 3-21 are included in the report as required by IDEA regulations

    Example: For a student born on 01/15/2010 with a cutoff date of 11/01/2022, the age would be calculated as of 11/01/2022
*   **Test Execution: Determines if the test case passed by comparing expected and actual counts**

    Formula: `CASE WHEN s.StudentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END`

    Business Significance: Validates the accuracy of discipline reporting for federal compliance

    Example: If the test data shows 5 students with autism who received disciplinary removals, and the report data shows the same count, the test passes

#### Data Transformations:

* Converting disability type codes to EDFacts standard codes (e.g., 'Autism' to 'AUT')
* Mapping race/ethnicity data to EDFacts race categories
* Converting sex values to EDFacts sex codes ('Male' to 'M', 'Female' to 'F')
* Determining English Learner status based on enrollment dates and discipline dates
* Filtering for specific IDEA interim removal codes ('REMDW', 'REMHO')
* Excluding students in private placements (IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS')
* Limiting to students aged 3-21 as of the child count date

#### Expected Output:

The procedure populates the App.SqlUnitTestCaseResult table with test results comparing expected and actual student counts across various category sets (CSA, CSB, CSC, CSD, ST1) at both SEA (state) and LEA (district) levels. Each test case indicates whether the counts match, providing validation of the discipline data reporting process.

### Business Context

**System:** EDFacts Reporting System for special education data

**Necessity:** Federal reporting requirements mandate accurate reporting of disciplinary actions for students with disabilities. This procedure ensures the data being reported meets these requirements by validating against test cases.

#### Business Rules:

* Only include students with disabilities (IDEA indicator = 1)
* Only include students aged 3-21 as of the child count date
* Only include interim removals with EDFacts codes 'REMDW' (drugs/weapons) or 'REMHO' (harm to others)
* Exclude students in private placements (PPPS)
* Only include LEAs that are operational and reported federally
* Discipline date must fall within the school year and within the student's enrollment period
* Discipline date must fall within the student's IDEA program participation period

#### Result Usage:

The test results are used to validate the accuracy of EDFacts C005 report data before submission to the U.S. Department of Education, ensuring compliance with federal reporting requirements.

#### Execution Frequency:

Annually, prior to EDFacts submission deadlines

#### Critical Periods:

* Prior to EDFacts C005 submission deadline (typically in spring)

### Parameters

| Parameter   | Data Type | Purpose                                                                                              | Required |
| ----------- | --------- | ---------------------------------------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which the test is being run (e.g., 2023 for the 2022-2023 school year) | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographic information and enrollment dates

**Columns:**

| Name                           | Data Type | Business Purpose                                                            |
| ------------------------------ | --------- | --------------------------------------------------------------------------- |
| StudentIdentifierState         | VARCHAR   | Unique identifier for the student within the state                          |
| LeaIdentifierSeaAccountability | VARCHAR   | Identifier for the LEA (Local Education Agency) responsible for the student |

#### Staging.Discipline

**Business Purpose:** Contains information about disciplinary actions taken for students

**Columns:**

| Name                        | Data Type | Business Purpose                                                     |
| --------------------------- | --------- | -------------------------------------------------------------------- |
| DisciplinaryActionStartDate | DATE      | The date when the disciplinary action began                          |
| IdeaInterimRemoval          | VARCHAR   | Indicates the type of interim removal for students with disabilities |

#### RDS.ReportEDFactsK12StudentDisciplines

**Business Purpose:** Contains the actual report data that has been generated for EDFacts reporting

**Columns:**

| Name            | Data Type | Business Purpose                                 |
| --------------- | --------- | ------------------------------------------------ |
| DisciplineCount | INT       | The count of students in each reporting category |
| ReportCode      | VARCHAR   | Identifies the EDFacts report (e.g., 'C005')     |

### Temporary Tables

#### #C005Staging

**Purpose:** Stores transformed and filtered student discipline data for testing at the SEA level

**Columns:**

| Name                   | Data Type | Purpose/Calculation                                                    |
| ---------------------- | --------- | ---------------------------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Direct from source                                                     |
| IDEADISABILITYTYPE     | VARCHAR   | Transformed from IdeaDisabilityTypeCode using CASE statement           |
| RaceEdFactsCode        | VARCHAR   | Derived from HispanicLatinoEthnicity and RaceType using CASE statement |

#### #S\_CSA

**Purpose:** Stores aggregated test data for Category Set A (Disability Type) at the SEA level

**Columns:**

| Name               | Data Type | Purpose/Calculation                    |
| ------------------ | --------- | -------------------------------------- |
| IdeaInterimRemoval | VARCHAR   | Direct from #C005Staging               |
| IDEADISABILITYTYPE | VARCHAR   | Direct from #C005Staging               |
| StudentCount       | INT       | COUNT(DISTINCT StudentIdentifierState) |

### Potential Improvements

#### Error Handling

**Description:** Add explicit error handling using TRY/CATCH blocks to capture and log errors during execution

**Benefits:** Improved troubleshooting and reliability

**Priority:** Medium

#### Performance

**Description:** Add indexes to temporary tables for improved query performance

**Benefits:** Faster execution, especially for large datasets

**Priority:** Medium

#### Code Organization

**Description:** Refactor into smaller, modular procedures for better maintainability

**Benefits:** Improved readability, easier maintenance, potential for code reuse

**Priority:** Low

#### Documentation

**Description:** Add more detailed inline documentation explaining business rules and transformations

**Benefits:** Improved knowledge transfer and maintenance

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize and clean up temporary tables

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID('tempdb..#C005Staging') IS NOT NULL DROP TABLE #C005Staging

#### Step 2: Set up test definition in App.SqlUnitTest

**Input Data:** App.SqlUnitTest table

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS005\_UnitTestCase') BEGIN...

#### Step 3: Prepare date variables and get custom child count date

**Input Data:** app.ToggleResponses, app.ToggleQuestions

**Transformations:** Date formatting and calculation

declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)

#### Step 4: Create temporary tables for reference data

**Input Data:** Staging.K12Organization, RDS.vwDimDisciplineStatuses, RDS.vwDimIdeaStatuses

**Transformations:** Filtering by school year

SELECT \* INTO #vwDisciplineStatuses FROM RDS.vwDimDisciplineStatuses WHERE SchoolYear = @SchoolYear

#### Step 5: Gather and transform student discipline data

**Input Data:** Multiple staging tables (K12Enrollment, Discipline, PersonStatus, etc.)

**Transformations:** Multiple transformations including code mapping and filtering

SELECT ske.StudentIdentifierState, ske.LeaIdentifierSeaAccountability, ... INTO #C005Staging FROM Staging.K12Enrollment ske JOIN ...

#### Step 6: Create SEA-level test data aggregations for each category set

**Input Data:** #C005Staging

**Transformations:** Aggregation by different category sets

SELECT IdeaInterimRemoval, IDEADISABILITYTYPE, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #S\_CSA FROM #C005staging GROUP BY IdeaInterimRemoval, IDEADISABILITYTYPE

#### Step 7: Compare SEA-level test data with actual report data

**Input Data:** SEA-level temporary tables, RDS.ReportEDFactsK12StudentDisciplines

**Transformations:** None

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT @SqlUnitTestId, 'CSA SEA Match All', ...

#### Step 8: Create LEA-level test data with additional filtering

**Input Data:** #C005Staging

**Transformations:** Filtering for open LEAs

Select \* INTO #C005staging\_LEA FROM #C005staging s JOIN RDS.DimLeas o ON LeaIdentifierSeaAccountability = o.LeaIdentifierSea AND ...

#### Step 9: Create LEA-level test data aggregations for each category set

**Input Data:** #C005staging\_LEA

**Transformations:** Aggregation by different category sets and LEA

SELECT IdeaInterimRemoval, IDEADISABILITYTYPE, s.LeaIdentifierSeaAccountability, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #L\_CSA FROM #C005staging\_LEA s ...

#### Step 10: Compare LEA-level test data with actual report data

**Input Data:** LEA-level temporary tables, RDS.ReportEDFactsK12StudentDisciplines

**Transformations:** None

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT @SqlUnitTestId, 'CSA LEA Match All', ...
