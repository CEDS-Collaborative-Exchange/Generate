# FS006\_TestCase

## App.FS006\_TestCase

***

## Overview & Purpose

This stored procedure is designed to test the accuracy of EDFacts reporting for discipline data related to students with disabilities. It compares data generated from staging tables against data stored in the reporting data store (RDS) to verify that the counts match across various category sets and reporting levels.

### Main Functions:

* **Data Preparation**\
  Prepares staging data by joining multiple tables to create a comprehensive dataset of student discipline incidents
* **Test Case Execution**\
  Executes multiple test cases to validate data at SEA and LEA levels across different category sets

### Key Calculations:

* **Data Preparation: Categorizes discipline durations into EDFacts reporting categories**
  * Formula: `RemovalLength calculation based on DurationOfDisciplinaryAction`
  * Business Significance: Ensures proper classification of discipline incidents for federal reporting
  * Example: When sum(DurationOfDisciplinaryAction) is between 0.5 and 10 days, RemovalLength = 'LTOREQ10'
* **Test Case Execution: Counts unique students for each combination of reporting dimensions**
  * Formula: `COUNT(DISTINCT StudentIdentifierState)`
  * Business Significance: Ensures accurate student counts for federal reporting
  * Example: Counting students by DisciplineMethod, RemovalLength, and IdeaDisabilityType

### Data Transformations:

* Mapping of database codes to EDFacts codes (e.g., Sex values to 'M'/'F')
* Categorization of discipline durations into EDFacts reporting categories
* Filtering of records based on date ranges and program participation
* Exclusion of LEAs that should not be reported federally

### Expected Output:

A series of test case results stored in App.SqlUnitTestCaseResult that indicate whether the counts in the staging data match the counts in the reporting data store

***

## Business Context

**System:** EDFacts Reporting System

**Necessity:** To ensure accurate federal reporting of discipline data for students with disabilities as required by IDEA

### Business Rules:

* Students must be between ages 3 and 21 as of the child count date
* Only include discipline incidents that occurred within the school year
* Only include students with disabilities (IDEA indicator = 1)
* Exclude students in certain educational environments (PPPS)
* Discipline methods must be InSchool or OutOfSchool
* Exclude certain types of interim removals (REMDW, REMHO)

### Result Usage:

Results are used to validate the accuracy of EDFacts reporting before submission to the federal government

### Execution Frequency:

Annually, prior to EDFacts submission deadlines

### Critical Periods:

* Prior to EDFacts submission deadlines for discipline data

***

## Parameters

\| @SchoolYear | SMALLINT | Specifies the school year for which to run the test cases | True |

***

## Source Tables

### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographic information and enrollment dates

#### Columns:

\| StudentIdentifierState | VARCHAR | Unique identifier for students within the state |

\| LeaIdentifierSeaAccountability | VARCHAR | Identifier for the Local Education Agency (LEA) responsible for the student |

### Staging.Discipline

**Business Purpose:** Contains information about disciplinary actions taken against students

#### Columns:

\| StudentIdentifierState | VARCHAR | Unique identifier for students within the state |

\| DisciplinaryActionStartDate | DATE | Date when the disciplinary action began |

### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Contains information about students' participation in special education programs

#### Columns:

\| StudentIdentifierState | VARCHAR | Unique identifier for students within the state |

\| IDEAIndicator | BIT or INT | Indicates whether the student is served under IDEA |

### RDS.ReportEDFactsK12StudentDisciplines

**Business Purpose:** Contains the official EDFacts reporting data for student disciplines

#### Columns:

\| ReportCode | VARCHAR | Identifies the EDFacts file specification (e.g., 'C006') |

\| DisciplineCount | INT | Count of students for a specific combination of reporting dimensions |

***

## Temporary Tables

### #C006Staging

**Purpose:** Main staging table that combines data from multiple source tables for analysis

#### Columns:

\| StudentIdentifierState | VARCHAR | Direct from source |

\| RemovalLength | VARCHAR | Derived from DurationOfDisciplinaryAction |

### #S\_CSA, #S\_CSB, #S\_CSC, #S\_CSD, #S\_ST1

**Purpose:** Store SEA-level aggregated results for different category sets

#### Columns:

\| DisciplineMethod | VARCHAR | Direct from #C006Staging |

\| StudentCount | INT | COUNT(DISTINCT StudentIdentifierState) |

### #L\_CSA, #L\_CSB, #L\_CSC, #L\_CSD, #L\_ST1

**Purpose:** Store LEA-level aggregated results for different category sets

#### Columns:

\| LeaIdentifierSeaAccountability | VARCHAR | Direct from #C006Staging |

\| StudentCount | INT | COUNT(DISTINCT StudentIdentifierState) |

### #excludedLeas

**Purpose:** Stores LEAs that should not be included in federal reporting

#### Columns:

\| LeaIdentifierSeaAccountability | VARCHAR | Selected from Staging.K12Organization |

***

## Potential Improvements

### Performance

* **Description:** Add indexes to temporary tables to improve join and aggregation performance
* **Benefits:** Faster execution, especially for large datasets
* **Priority:** Medium

### Error Handling

* **Description:** Add TRY/CATCH blocks to handle potential errors
* **Benefits:** More robust execution and better error reporting
* **Priority:** Medium

### Code Organization

* **Description:** Refactor repetitive test case code into a parameterized approach
* **Benefits:** Reduced code duplication, easier maintenance
* **Priority:** Low

***

## Execution Steps

### Step 1: Initialize and clean up temporary objects

**Input Data:** None

**Transformations:** DROP TABLE statements for temporary tables

```sql
IF OBJECT_ID('tempdb..#C006Staging') IS NOT NULL DROP TABLE #C006Staging
```

### Step 2: Define or retrieve the test case in App.SqlUnitTest

**Input Data:** App.SqlUnitTest table

**Transformations:** Conditional INSERT or SELECT

```sql
IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = 'FS006_UnitTestCase') BEGIN...
```

### Step 3: Clear previous test results

**Input Data:** App.SqlUnitTestCaseResult table

**Transformations:** DELETE statement

```sql
DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId
```

### Step 4: Set up date variables and parameters

**Input Data:** app.ToggleResponses and app.ToggleQuestions tables

**Transformations:** Date calculations and string manipulations

```sql
declare @SYStart varchar(10) = CAST('07/01/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
```

### Step 5: Identify LEAs to exclude from reporting

**Input Data:** Staging.K12Organization table

**Transformations:** Filter based on reporting flags and operational status

```sql
INSERT INTO #excludedLeas SELECT DISTINCT LEAIdentifierSea FROM Staging.K12Organization WHERE LEA_IsReportedFederally = 0...
```

### Step 6: Create main staging table with all required data

**Input Data:** Multiple staging tables (K12Enrollment, Discipline, ProgramParticipationSpecialEducation, etc.)

**Transformations:** Multiple joins, filters, and data transformations

```sql
SELECT ske.StudentIdentifierState, ske.LeaIdentifierSeaAccountability, ... INTO #C006Staging FROM Staging.K12Enrollment ske JOIN...
```

### Step 7: Update removal length categories

**Input Data:** #C006Staging table

**Transformations:** Categorization of discipline durations

```sql
UPDATE s SET s.RemovalLength = tmp.RemovalLength FROM #C006Staging s INNER JOIN (...) tmp ON...
```

### Step 8: Execute test cases for SEA-level reporting

**Input Data:** #C006Staging table

**Transformations:** Aggregation by various dimensions

```sql
SELECT DisciplineMethod, RemovalLength, IdeaDisabilityType, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #S_CSA FROM #C006Staging...
```

### Step 9: Execute test cases for LEA-level reporting

**Input Data:** #C006Staging table, #excludedLeas table

**Transformations:** Aggregation by various dimensions including LEA

```sql
SELECT s.LeaIdentifierSeaAccountability, DisciplineMethod, RemovalLength, IdeaDisabilityType, COUNT(DISTINCT StudentIdentifierState) AS StudentCount INTO #L_CSA FROM #C006Staging s LEFT JOIN #excludedLeas elea...
```

***

## Security Considerations

The procedure does not appear to handle sensitive data directly, but it does access student-level data which may be subject to FERPA regulations. Access to this procedure should be restricted to authorized users responsible for EDFacts reporting.

***

## Performance Benchmarks

Performance will vary based on the volume of student data. The procedure performs multiple complex joins and aggregations which could be resource-intensive for large datasets. Consider monitoring execution time during peak reporting periods.

***

## Known Limitations

* No explicit error handling for missing or invalid data
* Hard-coded values for certain EDFacts codes and mappings
* No handling of potential duplicates in source data
