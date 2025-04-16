# App.FS040\_TestCase

### Overview & Purpose

This stored procedure is designed to test and validate the accuracy of diploma/credential reporting data in the EdFacts reporting system. It creates test cases for various category sets (CSA through CSF, ST1, TOT) across different reporting levels (SEA, LEA, SCH) and compares the expected results with actual results from the reporting system.

#### Main Functions:

*   **Data Validation**

    Validates that the student counts in the reporting system match the expected counts calculated from source data
*   **Test Case Generation**

    Creates test cases for different category sets and reporting levels
*   **Result Comparison**

    Compares calculated results with stored results in the reporting system

#### Key Calculations:

*   **Data Validation: Counts unique students for each combination of reporting attributes**

    Formula: `COUNT(DISTINCT StudentIdentifierState)`

    Business Significance: Ensures accurate reporting of student diploma/credential data to federal education authorities

    Example: Counting students by diploma type, race, and sex for the CSA category set

#### Data Transformations:

* Filtering students based on reporting period dates
* Mapping diploma types to EdFacts codes
* Categorizing students by various demographic attributes
* Aggregating student counts by different category combinations

#### Expected Output:

Records in App.SqlUnitTestCaseResult table indicating whether each test case passed or failed

### Business Context

**System:** EdFacts Reporting System

**Necessity:** Federal education reporting compliance for diploma and credential data

#### Business Rules:

* Reporting period is from October 1 of the previous year to September 30 of the current year
* Students must have valid diploma type codes
* Students are categorized by various demographic attributes including race, sex, disability status, etc.
* Data must be reported at SEA (state), LEA (district), and SCH (school) levels

#### Result Usage:

Validation of federal education reporting data before submission to authorities

#### Execution Frequency:

Likely annual or as needed before federal reporting deadlines

#### Critical Periods:

* Before EdFacts submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                   | Required |
| ----------- | --------- | --------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which to run the test cases | True     |

### Source Tables

#### debug.vwStudentDetails

**Business Purpose:** Provides student demographic and enrollment information

**Columns:**

| Name                       | Data Type | Business Purpose                                 |
| -------------------------- | --------- | ------------------------------------------------ |
| SchoolYear                 | Unknown   | Identifies the school year of the student record |
| StudentIdentifierState     | Unknown   | Unique identifier for students within the state  |
| Various demographic fields | Various   | Store student demographic information            |

#### RDS.vwDimK12AcademicAwardStatuses

**Business Purpose:** Maps diploma types to EdFacts codes

**Columns:**

| Name                      | Data Type | Business Purpose                         |
| ------------------------- | --------- | ---------------------------------------- |
| SchoolYear                | Unknown   | School year for the diploma type mapping |
| HighSchoolDiplomaTypeCode | Unknown   | Internal code for diploma types          |
| HighSchoolDiplomaTypeMap  | Unknown   | Mapping value for diploma types          |

#### RDS.DimK12AcademicAwardStatuses

**Business Purpose:** Stores EdFacts codes for diploma types

**Columns:**

| Name                             | Data Type | Business Purpose                         |
| -------------------------------- | --------- | ---------------------------------------- |
| HighSchoolDiplomaTypeCode        | Unknown   | Internal code for diploma types          |
| HighSchoolDiplomaTypeEdFactsCode | Unknown   | EdFacts reporting code for diploma types |

#### staging.K12Enrollment

**Business Purpose:** Stores student enrollment data

**Columns:**

| Name                           | Data Type | Business Purpose                    |
| ------------------------------ | --------- | ----------------------------------- |
| StudentIdentifierState         | Unknown   | Unique identifier for students      |
| LeaIdentifierSeaAccountability | Unknown   | Identifier for the LEA (district)   |
| SchoolIdentifierSea            | Unknown   | Identifier for the school           |
| HighSchoolDiplomaType          | Unknown   | Type of diploma received by student |

#### staging.PersonStatus

**Business Purpose:** Stores various status indicators for students

**Columns:**

| Name                       | Data Type | Business Purpose                                   |
| -------------------------- | --------- | -------------------------------------------------- |
| EconomicDisadvantageStatus | Unknown   | Indicates if student is economically disadvantaged |
| MigrantStatus              | Unknown   | Indicates if student has migrant status            |
| HomelessnessStatus         | Unknown   | Indicates if student is homeless                   |

#### RDS.ReportEdFactsK12StudentCounts

**Business Purpose:** Stores the actual reported student counts

**Columns:**

| Name            | Data Type | Business Purpose                               |
| --------------- | --------- | ---------------------------------------------- |
| ReportCode      | Unknown   | Identifies the specific EdFacts report         |
| ReportYear      | Unknown   | School year of the report                      |
| ReportLevel     | Unknown   | Level of reporting (SEA, LEA, SCH)             |
| CategorySetCode | Unknown   | Category set for reporting                     |
| StudentCount    | Unknown   | Count of students for the specific combination |

### Temporary Tables

#### #vwDiplomaType

**Purpose:** Stores diploma type mappings for the specified school year

**Columns:**

| Name                             | Data Type | Purpose/Calculation |
| -------------------------------- | --------- | ------------------- |
| SchoolYear                       | Unknown   | Direct from source  |
| HighSchoolDiplomaTypeCode        | Unknown   | Direct from source  |
| HighSchoolDiplomaTypeMap         | Unknown   | Direct from source  |
| HighSchoolDiplomaTypeEdFactsCode | Unknown   | Direct from source  |

#### #vwStudentDetails

**Purpose:** Stores filtered student demographic data

**Columns:**

| Name                       | Data Type | Purpose/Calculation           |
| -------------------------- | --------- | ----------------------------- |
| SchoolYear                 | Unknown   | Direct from source            |
| StudentIdentifierState     | Unknown   | Direct from source            |
| Various demographic fields | Various   | Direct from source or derived |

#### #staging

**Purpose:** Combines all necessary student data for analysis

**Columns:**

| Name                                  | Data Type | Purpose/Calculation                                |
| ------------------------------------- | --------- | -------------------------------------------------- |
| All columns from #vwStudentDetails    | Various   | Direct from source                                 |
| EconomicDisadvantageStatusEdFactsCode | Unknown   | CASE statement based on EconomicDisadvantageStatus |
| MigrantStatusEdFactsCode              | Unknown   | CASE statement based on MigrantStatus              |
| HomelessnessStatusEdFactsCode         | Unknown   | CASE statement based on HomelessnessStatus         |
| HighSchoolDiplomaTypeEdFactsCode      | Unknown   | Joined from #vwDiplomaType                         |

#### Various category set temp tables (#SEA\_CSA, #LEA\_CSA, etc.)

**Purpose:** Store aggregated student counts for each category set and reporting level

**Columns:**

| Name                     | Data Type | Purpose/Calculation                    |
| ------------------------ | --------- | -------------------------------------- |
| Various grouping columns | Various   | Direct from #staging                   |
| StudentCount             | Unknown   | COUNT(DISTINCT StudentIdentifierState) |

### Potential Improvements

#### Error Handling

**Description:** Add TRY/CATCH blocks to handle potential errors during execution

**Benefits:** Improved reliability and easier troubleshooting

**Priority:** Medium

#### Performance

**Description:** Add indexes to temporary tables for better join performance

**Benefits:** Faster execution, especially with large datasets

**Priority:** Medium

#### Code Organization

**Description:** Refactor repetitive code blocks into reusable modules

**Benefits:** Improved maintainability and reduced code duplication

**Priority:** Low

#### Documentation

**Description:** Add more detailed comments explaining business rules and calculations

**Benefits:** Improved understanding for future maintainers

**Priority:** Low

### Execution Steps

#### Step 1: Initialize and clean up temporary objects

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID('tempdb..#Staging') IS NOT NULL DROP TABLE #Staging

#### Step 2: Define test metadata

**Input Data:** Test name, procedure name, scope, report code

**Transformations:** None

DECLARE @UnitTestName VARCHAR(100) = 'FS040\_UnitTestCase'

#### Step 3: Create or retrieve test record

**Input Data:** App.SqlUnitTest table

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) BEGIN...

#### Step 4: Clear previous test results

**Input Data:** App.SqlUnitTestCaseResult table

**Transformations:** None

DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

#### Step 5: Define reporting period

**Input Data:** @SchoolYear parameter

**Transformations:** Calculate start and end dates

DECLARE @ReportingStartDate Date = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-10-01'AS DATE)

#### Step 6: Create diploma type mapping table

**Input Data:** RDS.vwDimK12AcademicAwardStatuses, RDS.DimK12AcademicAwardStatuses

**Transformations:** Join tables to get EdFacts codes

select vaward.SchoolYear, vaward.HighSchoolDiplomaTypeCode, vaward.HighSchoolDiplomaTypeMap, award.HighSchoolDiplomaTypeEdFactsCode into #vwDiplomaType...

#### Step 7: Create student details table

**Input Data:** debug.vwStudentDetails

**Transformations:** Filter by school year, transform grade levels

select SchoolYear, StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EnrollmentEntryDate...

#### Step 8: Create main staging table

**Input Data:** #vwStudentDetails, staging.K12Enrollment, various dimension tables

**Transformations:** Join tables, filter by reporting period, add status codes

select vsd.\*, case when eco.EconomicDisadvantageStatus = 1 then 'ECODIS' else '' end EconomicDisadvantageStatusEdFactsCode...

#### Step 9: Process each category set and reporting level

**Input Data:** #staging table

**Transformations:** Group by different attribute combinations

select @CategorySet = 'CSA'...

#### Step 10: Compare results and record test outcomes

**Input Data:** Category set temp tables, RDS.ReportEdFactsK12StudentCounts

**Transformations:** None

INSERT INTO App.SqlUnitTestCaseResult...
