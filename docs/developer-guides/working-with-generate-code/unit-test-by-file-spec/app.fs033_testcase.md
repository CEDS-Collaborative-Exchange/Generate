# App.FS033\_TestCase

### Overview & Purpose

This stored procedure is designed to test the accuracy of EDFacts report C033 data by comparing calculated student counts with expected values stored in the RDS.ReportEDFactsK12StudentCounts table. It focuses on free and reduced-price lunch eligibility status and direct certification for the National School Lunch Program at the school level.

#### Main Functions:

*   **Test Case Validation**

    Validates that student counts for free/reduced lunch eligibility and direct certification match between calculated values and stored report data

#### Key Calculations:

*   **Test Case Validation: Count unique students by school and eligibility status**

    Formula: `COUNT(DISTINCT StudentIdentifierState)`

    Business Significance: Ensures accurate reporting of student counts for federal education reporting

    Example: Count of students with 'Free' lunch status at a specific school

#### Data Transformations:

* Maps 'Free' lunch status to 'FL' EDFacts code
* Maps 'ReducedPrice' lunch status to 'RPL' EDFacts code
* Identifies direct certification students with 'DIRECTCERT' code
* Identifies free/reduced lunch students with 'LUNCHFREERED' code

#### Expected Output:

Test case results stored in App.SqlUnitTestCaseResult table, indicating whether calculated student counts match expected values

### Business Context

**System:** EDFacts Reporting System

**Necessity:** Ensures accurate federal reporting of student eligibility for free and reduced-price lunch programs

#### Business Rules:

* Student enrollment is determined based on a specific membership date
* Only students enrolled on the membership date are counted
* Grade levels to include are configurable via toggle settings
* Free/reduced lunch eligibility is mapped to specific EDFacts codes
* Direct certification is tracked separately from general eligibility

#### Result Usage:

Validates the accuracy of C033 report data before submission to federal education authorities

#### Execution Frequency:

Likely annual, aligned with EDFacts reporting cycle

#### Critical Periods:

* EDFacts submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                  | Required |
| ----------- | --------- | -------------------------------------------------------- | -------- |
| @SchoolYear | INT       | Specifies the school year for which to run the test case | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores student enrollment information

**Columns:**

| Name                           | Data Type          | Business Purpose                                                             |
| ------------------------------ | ------------------ | ---------------------------------------------------------------------------- |
| StudentIdentifierState         | Unknown            | Unique identifier for students within the state                              |
| LEAIdentifierSeaAccountability | Unknown            | Identifies the Local Education Agency (district) responsible for the student |
| SchoolIdentifierSea            | Unknown            | Identifies the school the student attends                                    |
| EnrollmentEntryDate            | Date or DateTime   | Date student enrolled in school                                              |
| EnrollmentExitDate             | Date or DateTime   | Date student exited school, if applicable                                    |
| GradeLevel                     | VARCHAR or similar | Student's grade level                                                        |

#### Staging.PersonStatus

**Business Purpose:** Stores student eligibility status for various programs

**Columns:**

| Name                                                   | Data Type          | Business Purpose                                                 |
| ------------------------------------------------------ | ------------------ | ---------------------------------------------------------------- |
| StudentIdentifierState                                 | Unknown            | Unique identifier for students within the state                  |
| SchoolIdentifierSea                                    | Unknown            | Identifies the school associated with the status record          |
| EligibilityStatusForSchoolFoodServicePrograms          | VARCHAR or similar | Indicates student's eligibility status for school lunch programs |
| NationalSchoolLunchProgramDirectCertificationIndicator | BIT or INT         | Indicates if student is directly certified for lunch program     |

#### App.ToggleResponses

**Business Purpose:** Stores configuration settings for report generation

**Columns:**

| Name             | Data Type      | Business Purpose                            |
| ---------------- | -------------- | ------------------------------------------- |
| ResponseValue    | VARCHAR        | Stores the value of a configuration setting |
| ToggleQuestionId | INT or similar | Links to the question definition            |

#### App.ToggleQuestions

**Business Purpose:** Defines configuration questions/settings

**Columns:**

| Name               | Data Type      | Business Purpose                               |
| ------------------ | -------------- | ---------------------------------------------- |
| ToggleQuestionId   | INT or similar | Primary key for questions                      |
| EmapsQuestionAbbrv | VARCHAR        | Abbreviated code for the configuration setting |

#### RDS.ReportEDFactsK12StudentCounts

**Business Purpose:** Stores expected student counts for EDFacts reports

**Columns:**

| Name                                          | Data Type          | Business Purpose                                        |
| --------------------------------------------- | ------------------ | ------------------------------------------------------- |
| OrganizationIdentifierSea                     | VARCHAR or similar | Identifies the organization (school) for the count      |
| ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS | VARCHAR            | EDFacts code for lunch eligibility status               |
| TableTypeAbbrv                                | VARCHAR            | Identifies the type of count (DIRECTCERT, LUNCHFREERED) |
| ReportCode                                    | VARCHAR            | Identifies the EDFacts report                           |
| ReportYear                                    | INT                | School year for the report                              |
| ReportLevel                                   | VARCHAR            | Level of aggregation (SCH for school)                   |
| CategorySetCode                               | VARCHAR            | Identifies the category set for the count               |
| StudentCount                                  | INT                | Expected count of students                              |

### Temporary Tables

#### #c033Staging

**Purpose:** Stores intermediate student data with eligibility status and EDFacts codes

**Columns:**

| Name                                          | Data Type      | Purpose/Calculation                                                                                   |
| --------------------------------------------- | -------------- | ----------------------------------------------------------------------------------------------------- |
| StudentIdentifierState                        | Same as source | Direct from source                                                                                    |
| LEAIdentifierSeaAccountability                | Same as source | Direct from source                                                                                    |
| SchoolIdentifierSea                           | Same as source | Direct from source                                                                                    |
| FRLEdFactsCode                                | VARCHAR        | CASE statement mapping from EligibilityStatusForSchoolFoodServicePrograms                             |
| EligibilityStatusForSchoolFoodServicePrograms | Same as source | Direct from source                                                                                    |
| DirectCertEdFactsCode                         | VARCHAR        | CASE statement based on NationalSchoolLunchProgramDirectCertificationIndicator and eligibility status |

#### #SCH\_CSA

**Purpose:** Stores school-level student counts by FRL status for CSA category set

**Columns:**

| Name                | Data Type      | Purpose/Calculation                    |
| ------------------- | -------------- | -------------------------------------- |
| SchoolIdentifierSea | Same as source | Direct from source                     |
| FRLEdFactsCode      | VARCHAR        | From staging table                     |
| StudentCount        | INT            | COUNT(DISTINCT StudentIdentifierState) |

#### #SCH\_TOT

**Purpose:** Stores school-level student counts for direct certification and free/reduced lunch for TOT category set

**Columns:**

| Name                  | Data Type      | Purpose/Calculation                           |
| --------------------- | -------------- | --------------------------------------------- |
| SchoolIdentifierSea   | Same as source | Direct from source                            |
| DirectCertEdFactsCode | VARCHAR        | Literal values 'DIRECTCERT' or 'LUNCHFREERED' |
| StudentCount          | INT            | COUNT(DISTINCT StudentIdentifierState)        |

#### @GradesList

**Purpose:** Stores valid grade levels to include in the analysis

**Columns:**

| Name       | Data Type  | Purpose/Calculation        |
| ---------- | ---------- | -------------------------- |
| GradeLevel | VARCHAR(3) | Direct insertion of values |

### Potential Improvements

#### Error Handling

**Description:** Add explicit error handling with TRY/CATCH blocks

**Benefits:** Better error reporting and recovery

**Priority:** Medium

#### Performance

**Description:** Add indexes to temporary tables for better join performance

**Benefits:** Faster execution for large datasets

**Priority:** Low

#### Code Structure

**Description:** Refactor into smaller, more focused procedures

**Benefits:** Improved maintainability and reusability

**Priority:** Medium

#### Documentation

**Description:** Add comprehensive header comments and inline documentation

**Benefits:** Improved understanding for future maintainers

**Priority:** Medium

### Execution Steps

#### Step 1: Clean up temporary tables from previous runs

**Input Data:** None

**Transformations:** DROP TABLE statements for temp tables

IF OBJECT\_ID('tempdb..#C033Staging') IS NOT NULL DROP TABLE #C033Staging

#### Step 2: Set up test case in SqlUnitTest table if it doesn't exist

**Input Data:** App.SqlUnitTest table

**Transformations:** INSERT if not exists

IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS033\_UnitTestCase') BEGIN INSERT INTO App.SqlUnitTest... END

#### Step 3: Clear previous test results

**Input Data:** App.SqlUnitTestCaseResult table

**Transformations:** DELETE statement

DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId

#### Step 4: Determine membership date from configuration

**Input Data:** App.ToggleQuestions and App.ToggleResponses tables

**Transformations:** Parse date components from configuration value

select @customFactTypeDate = r.ResponseValue from app.ToggleResponses r INNER join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId where q.EmapsQuestionAbbrv = 'MEMBERDTE'

#### Step 5: Determine grade level inclusion settings

**Input Data:** App.ToggleQuestions and App.ToggleResponses tables

**Transformations:** Convert 'true'/'false' string values to bit flags

select @toggleGrade13 = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end, 0 ) from app.ToggleQuestions q left outer join app.ToggleResponses r on r.ToggleQuestionId = q.ToggleQuestionId where q.EmapsQuestionAbbrv = 'CCDGRADE13'

#### Step 6: Create list of valid grade levels

**Input Data:** Configuration settings from previous step

**Transformations:** Populate table variable with grade level codes

DECLARE @GradesList TABLE (GradeLevel varchar(3)) INSERT INTO @GradesList VALUES ('PK'),('KG'),('01'),...

#### Step 7: Extract and transform student data

**Input Data:** Staging.K12Enrollment and Staging.PersonStatus tables

**Transformations:** Join tables, filter by date and grade, map status codes

SELECT ske.StudentIdentifierState, ske.LEAIdentifierSeaAccountability, ske.SchoolIdentifierSea, CASE sps.EligibilityStatusForSchoolFoodServicePrograms WHEN 'Free' THEN 'FL'... INTO #c033Staging FROM Staging.K12Enrollment ske LEFT JOIN Staging.PersonStatus sps...

#### Step 8: Test Case 1: Calculate and validate CSA category counts

**Input Data:** #c033Staging temporary table

**Transformations:** Aggregate by school and FRL status

SELECT SchoolIdentifierSea, FRLEdFactsCode, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #SCH\_CSA FROM #c033staging GROUP BY SchoolIdentifierSea, FRLEdFactsCode

#### Step 9: Test Case 2: Calculate and validate TOT category counts

**Input Data:** #c033Staging temporary table

**Transformations:** Aggregate by school and direct certification status

SELECT SchoolIdentifierSea, 'DIRECTCERT' DirectCertEdFactsCode, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #SCH\_TOT FROM #c033staging where FRLEdFactsCode in ('FL', 'RPL') and DirectCertEdFactsCode = 'DIRECTCERT' GROUP BY SchoolIdentifierSea, DirectCertEdFactsCode UNION SELECT...
