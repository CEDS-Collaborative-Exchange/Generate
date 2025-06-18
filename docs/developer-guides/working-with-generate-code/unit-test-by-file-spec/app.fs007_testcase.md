# App.FS007\_TestCase

### Overview & Purpose

This stored procedure is designed to test and validate the accuracy of EDFacts reporting for discipline data related to students with disabilities under IDEA (Individuals with Disabilities Education Act). It specifically focuses on testing the C007 report which tracks interim removals of students with disabilities for various reasons (drugs, weapons, serious bodily injury). The procedure creates test cases, compares expected vs. actual results, and logs the outcomes in a unit testing framework.

#### Main Functions:

*   **Data Preparation**

    Gathers and transforms student discipline data for IDEA students with interim removals
*   **Test Case Execution**

    Creates and executes multiple test cases for different category sets (CSA, CSB, CSC, CSD, ST1) at both SEA and LEA levels
*   **Results Recording**

    Records test results in the App.SqlUnitTestCaseResult table for analysis and validation

#### Key Calculations:

*   **Data Preparation: Determines if the test case passed by comparing the expected count with the actual count**

    Formula: `CASE WHEN s.IncidentCount = ISNULL(rreksd.DisciplineCount, -1) THEN 1 ELSE 0 END`

    Business Significance: Validates the accuracy of EDFacts reporting for federal compliance

    Example: If 5 incidents are calculated in the test case and 5 are found in the reporting table, the test passes with a value of 1

#### Data Transformations:

* Mapping disability types to standardized EDFacts codes (e.g., 'Autism' to 'AUT')
* Mapping race/ethnicity data to EDFacts reporting categories
* Converting sex values to EDFacts reporting codes
* Determining English Learner status based on program participation dates
* Filtering data to include only federally reportable LEAs
* Aggregating discipline incidents by various category sets

#### Expected Output:

A series of test case results stored in App.SqlUnitTestCaseResult table, indicating whether the calculated counts match the expected counts in the EDFacts reporting tables

### Business Context

**System:** EDFacts Reporting System

**Necessity:** Federal compliance with IDEA reporting requirements for student discipline data

#### Business Rules:

* Only include students with disabilities under IDEA
* Focus on interim removals for specific reasons (drugs, weapons, serious bodily injury)
* Exclude students in parentally-placed private school settings (PPPS)
* Only include students aged 3-21 as of the child count date
* Only include federally reportable LEAs for LEA-level reporting
* Data must be categorized by disability type, race/ethnicity, sex, and English learner status

#### Result Usage:

Validation of EDFacts reporting accuracy before submission to the U.S. Department of Education

#### Execution Frequency:

Annually before EDFacts submission deadline

#### Critical Periods:

* Prior to EDFacts submission deadlines for IDEA discipline data

### Parameters

| Parameter   | Data Type | Purpose                                                   | Required |
| ----------- | --------- | --------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which the test is being run | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographic information and enrollment dates

**Columns:**

| Name                           | Data Type | Business Purpose                                |
| ------------------------------ | --------- | ----------------------------------------------- |
| StudentIdentifierState         | VARCHAR   | Unique identifier for students within the state |
| LeaIdentifierSeaAccountability | VARCHAR   | Identifies the LEA responsible for the student  |

#### Staging.Discipline

**Business Purpose:** Contains disciplinary incident data for students

**Columns:**

| Name                     | Data Type | Business Purpose                                                                 |
| ------------------------ | --------- | -------------------------------------------------------------------------------- |
| IncidentIdentifier       | VARCHAR   | Unique identifier for disciplinary incidents                                     |
| DisciplinaryActionTaken  | VARCHAR   | Describes the type of disciplinary action                                        |
| IdeaInterimRemoval       | VARCHAR   | Indicates if the student was removed under IDEA provisions                       |
| IdeaInterimRemovalReason | VARCHAR   | Specifies the reason for interim removal (drugs, weapons, serious bodily injury) |

#### RDS.ReportEDFactsK12StudentDisciplines

**Business Purpose:** Contains the official EDFacts discipline reporting data

**Columns:**

| Name            | Data Type | Business Purpose                            |
| --------------- | --------- | ------------------------------------------- |
| ReportCode      | VARCHAR   | Identifies the EDFacts report (C007)        |
| DisciplineCount | INT       | Count of discipline incidents for reporting |

### Temporary Tables

#### #C007Staging

**Purpose:** Main staging table that holds transformed discipline data for analysis

**Columns:**

| Name                                | Data Type | Purpose/Calculation                                       |
| ----------------------------------- | --------- | --------------------------------------------------------- |
| StudentIdentifierState              | VARCHAR   | Direct from source                                        |
| LeaIdentifierSeaAccountability      | VARCHAR   | Direct from source                                        |
| IdeaInterimRemovalReasonEdFactsCode | VARCHAR   | Mapped from IdeaInterimRemovalReason using CASE statement |
| IDEADISABILITYTYPE                  | VARCHAR   | Mapped from IdeaDisabilityTypeCode using CASE statement   |
| RaceEdFactsCode                     | VARCHAR   | Derived from HispanicLatinoEthnicity and RaceType         |

#### #S\_CSA

**Purpose:** Holds aggregated data for Category Set A (disability type) at SEA level

**Columns:**

| Name                                | Data Type | Purpose/Calculation       |
| ----------------------------------- | --------- | ------------------------- |
| IdeaInterimRemovalReasonEdFactsCode | VARCHAR   | Direct from #C007Staging  |
| IDEADISABILITYTYPE                  | VARCHAR   | Direct from #C007Staging  |
| IncidentCount                       | INT       | COUNT(IncidentIdentifier) |

#### #notReportedFederallyLeas

**Purpose:** Stores LEAs that should be excluded from federal reporting

**Columns:**

| Name                           | Data Type   | Purpose/Calculation                 |
| ------------------------------ | ----------- | ----------------------------------- |
| LeaIdentifierSeaAccountability | VARCHAR(20) | Direct from Staging.K12Organization |

### Potential Improvements

#### Performance

**Description:** Add indexes to temporary tables to improve join and filtering performance

**Benefits:** Faster execution, especially for large datasets

**Priority:** Medium

#### Error Handling

**Description:** Add TRY/CATCH blocks to handle potential errors

**Benefits:** More robust execution and better error reporting

**Priority:** Medium

#### Code Organization

**Description:** Refactor repetitive test case code into a parameterized approach

**Benefits:** Reduced code duplication, easier maintenance

**Priority:** Low

#### Documentation

**Description:** Add more comprehensive comments explaining business rules and data transformations

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize and clean up temporary tables

**Input Data:** None

**Transformations:** Dropping existing temporary tables if they exist

IF OBJECT\_ID('tempdb..#C007Staging') IS NOT NULL DROP TABLE #C007Staging

#### Step 2: Set up unit test framework

**Input Data:** App.SqlUnitTest table

**Transformations:** Creating or retrieving test definition

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS007\_UnitTestCase') BEGIN...

#### Step 3: Determine school year date ranges and child count date

**Input Data:** @SchoolYear parameter, app.ToggleResponses table

**Transformations:** Converting school year to date ranges

declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)

#### Step 4: Create temporary tables with reference data

**Input Data:** Various staging and RDS tables

**Transformations:** Selecting and filtering data into temporary tables

SELECT \* INTO #vwDisciplineStatuses FROM RDS.vwDimDisciplineStatuses WHERE SchoolYear = @SchoolYear

#### Step 5: Create main staging table with transformed discipline data

**Input Data:** Multiple staging tables joined together

**Transformations:** Complex data transformation with multiple joins and CASE statements

SELECT DISTINCT ske.StudentIdentifierState, ske.LeaIdentifierSeaAccountability, ... INTO #C007Staging FROM Staging.K12Enrollment ske JOIN ...

#### Step 6: Execute SEA-level test cases

**Input Data:** #C007Staging table

**Transformations:** Aggregating data by different category sets

SELECT IdeaInterimRemovalReasonEdFactsCode, IDEADISABILITYTYPE, COUNT(IncidentIdentifier) AS IncidentCount INTO #S\_CSA FROM #C007Staging ...

#### Step 7: Record SEA-level test results

**Input Data:** Temporary tables with aggregated data, RDS.ReportEDFactsK12StudentDisciplines

**Transformations:** Comparing expected vs. actual counts

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT @SqlUnitTestId, 'CSA SEA Match All', ...

#### Step 8: Create LEA-level staging table

**Input Data:** #C007Staging table

**Transformations:** Filtering for reportable LEAs

Select \* INTO #C007staging\_LEA FROM #C007staging s JOIN RDS.DimLeas o ON ...

#### Step 9: Execute LEA-level test cases

**Input Data:** #C007staging\_LEA table

**Transformations:** Aggregating data by different category sets at LEA level

SELECT s.LeaIdentifierSeaAccountability, IdeaInterimRemovalReasonEdFactsCode, IDEADISABILITYTYPE, COUNT(IncidentIdentifier) AS IncidentCount INTO #L\_CSA FROM #C007staging\_LEA s ...

#### Step 10: Record LEA-level test results

**Input Data:** Temporary tables with aggregated LEA-level data, RDS.ReportEDFactsK12StudentDisciplines

**Transformations:** Comparing expected vs. actual counts at LEA level

INSERT INTO App.SqlUnitTestCaseResult (...) SELECT @SqlUnitTestId, 'CSA LEA Match All', ...
