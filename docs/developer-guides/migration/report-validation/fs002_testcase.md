# FS002\_TestCase

## App.FS002\_TestCase

***

## Overview & Purpose

This stored procedure is designed to test the accuracy of data processing for special education students (IDEA) reporting. It validates that student counts across various demographic categories and educational environments match expected results in the RDS.ReportEDFactsK12StudentCounts table. The procedure is part of a unit testing framework for the FS002 reporting module.

### Main Functions:

* **Data Preparation**\
  Creates temporary tables and prepares test data for special education student reporting
* **Test Case Execution**\
  Runs multiple test cases to validate student counts across different category sets and organizational levels
* **Test Result Validation**\
  Compares calculated student counts with expected values in the reporting system

### Key Calculations:

* **Data Preparation: Determines the reference date for counting students with disabilities**
  * Formula: `Child Count Date calculation`
  * Business Significance: Ensures consistent point-in-time reporting for federal requirements
  * Example: select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1)
* **Test Case Execution: Counts unique students in various demographic and educational environment groupings**
  * Formula: `COUNT(DISTINCT StudentIdentifierState)`
  * Business Significance: Ensures accurate federal reporting of students with disabilities
  * Example: COUNT(DISTINCT StudentIdentifierState) AS StudentCount
* **Test Result Validation: Determines if test case passed or failed**
  * Formula: `CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END`
  * Business Significance: Validates data integrity for federal reporting
  * Example: CASE WHEN s.StudentCount = ISNULL(rreksd.StudentCount, -1) THEN 1 ELSE 0 END

### Data Transformations:

* Mapping disability type codes to standardized formats
* Converting race/ethnicity data to EdFacts reporting codes
* Standardizing sex codes for federal reporting
* Determining English Learner status based on reference date
* Handling multiple race selections according to federal reporting rules

### Expected Output:

The procedure populates the App.SqlUnitTestCaseResult table with test results comparing calculated student counts against expected values from RDS.ReportEDFactsK12StudentCounts across multiple category sets (CSA-CSE, ST1-ST7, TOT) and organizational levels (SEA, LEA, School).

***

## Business Context

**System:** EDFacts Reporting System

**Necessity:** Federal compliance with IDEA (Individuals with Disabilities Education Act) reporting requirements

### Business Rules:

* Students must be enrolled on the child count date
* Students must have an active IDEA indicator
* Students must be ages 6-21, or age 5 and not in Pre-K
* Students in home/hospital or private placement settings are excluded from school-level reporting
* LEAs and schools marked as not federally reported are excluded
* LEAs and schools with certain operational statuses (Closed, Inactive, etc.) are excluded
* Hispanic/Latino ethnicity takes precedence over race in reporting
* Multiple races are reported as 'Two or More Races' unless Hispanic

### Result Usage:

Validation of data processing for federal EDFacts reporting file FS002 (Children with Disabilities School Age)

### Execution Frequency:

Annually during EDFacts reporting preparation

### Critical Periods:

* Prior to EDFacts submission deadlines
* After data refreshes from source systems

***

## Parameters

\| @SchoolYear | INT | Specifies the school year for which to run the test cases | True |

***

## Source Tables

### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographic information and enrollment dates

#### Columns:

\| StudentIdentifierState | VARCHAR | Unique identifier for students at the state level |

\| LeaIdentifierSeaAccountability | VARCHAR | Identifies the LEA responsible for the student |

### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Tracks student participation in special education programs

#### Columns:

\| IDEAIndicator | BIT | Indicates if student receives services under IDEA |

\| IDEAEducationalEnvironmentForSchoolAge | VARCHAR | Indicates educational setting for special education services |

### RDS.ReportEDFactsK12StudentCounts

**Business Purpose:** Stores expected student counts for EDFacts reporting

#### Columns:

\| ReportCode | VARCHAR | Identifies the EDFacts report (e.g., 'C002') |

\| CategorySetCode | VARCHAR | Identifies grouping of demographic factors for reporting |

***

## Temporary Tables

### #c002Staging

**Purpose:** Stores transformed student data for testing

#### Columns:

\| StudentIdentifierState | VARCHAR | Direct from source |

\| LeaIdentifierSeaAccountability | VARCHAR | Direct from source |

\| RaceEdFactsCode | VARCHAR | Derived from HispanicLatinoEthnicity and RaceType with business rules |

### #excludedLeas

**Purpose:** Stores LEAs that should be excluded from reporting

#### Columns:

\| LeaIdentifierSeaAccountability | VARCHAR | Filtered from Staging.K12Organization |

### #S\_CSA, #L\_CSA, etc.

**Purpose:** Store test results for different category sets and organizational levels

#### Columns:

\| StudentCount | INT | COUNT(DISTINCT StudentIdentifierState) |

***

## Potential Improvements

### Performance

* **Description:** Add indexes to temporary tables for improved query performance
* **Benefits:** Faster execution of test cases, especially for large datasets
* **Priority:** Medium

### Error Handling

* **Description:** Add explicit error handling with TRY/CATCH blocks
* **Benefits:** Better error reporting and more graceful failure handling
* **Priority:** Medium

### Code Organization

* **Description:** Modularize test cases into separate procedures
* **Benefits:** Improved maintainability, ability to run individual test cases
* **Priority:** Low

### Documentation

* **Description:** Add comprehensive header documentation and inline comments
* **Benefits:** Improved maintainability and knowledge transfer
* **Priority:** Medium

***

## Execution Steps

### Step 1: Clean up temporary tables from previous runs

**Input Data:** None

**Transformations:** None

```sql
IF OBJECT_ID('tempdb..#C002Staging') IS NOT NULL DROP TABLE #C002Staging
```

### Step 2: Define and retrieve test metadata

**Input Data:** App.SqlUnitTest

**Transformations:** None

```sql
IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS002_UnitTestCase') BEGIN...
```

### Step 3: Determine child count date

**Input Data:** App.ToggleResponses, App.ToggleQuestions

**Transformations:** Date string parsing

```sql
select @ChildCountDate = convert(varchar, @CutoffMonth) + '/' + convert(varchar, @CutoffDay) + '/' + convert(varchar, @SchoolYear-1)
```

### Step 4: Identify excluded LEAs and schools

**Input Data:** Staging.K12Organization

**Transformations:** Filtering based on reporting flags and operational status

```sql
INSERT INTO #excludedLeas SELECT DISTINCT LEAIdentifierSea FROM Staging.K12Organization WHERE LEA_IsReportedFederally = 0...
```

### Step 5: Prepare main staging data

**Input Data:** Multiple staging tables

**Transformations:** Multiple data transformations and standardizations

```sql
SELECT ske.StudentIdentifierState, ske.LeaIdentifierSeaAccountability, ... INTO #c002Staging FROM Staging.K12Enrollment ske JOIN...
```

### Step 6: Handle race reporting rules

**Input Data:** #c002Staging, Staging.K12PersonRace

**Transformations:** Multiple race detection and standardization

```sql
UPDATE stg SET RaceEdFactsCode = 'MU7' FROM #c002Staging stg INNER JOIN #TempRacesUpdate tru...
```

### Step 7: Execute test cases for each category set and organizational level

**Input Data:** #c002Staging, RDS.ReportEDFactsK12StudentCounts

**Transformations:** Grouping and aggregation

```sql
SELECT c.RaceEdFactsCode, SexEdFactsCode, IdeaDisabilityTypeCode, COUNT(DISTINCT c.StudentIdentifierState) AS StudentCount INTO #S_CSA FROM #c002staging c GROUP BY...
```

***

## Security Considerations

The procedure does not appear to handle sensitive student data directly but works with identifiers. However, access to this procedure should be restricted to authorized personnel involved in EDFacts reporting validation.

***

## Performance Benchmarks

Performance will vary based on the volume of student data. The procedure performs multiple aggregation operations which could be resource-intensive for large datasets. Consider monitoring execution time during peak reporting periods.

***

## Known Limitations

* No explicit error handling for data quality issues
* Limited validation of input parameters
* Hardcoded business rules for race/ethnicity reporting
* No logging of execution progress or performance metrics
