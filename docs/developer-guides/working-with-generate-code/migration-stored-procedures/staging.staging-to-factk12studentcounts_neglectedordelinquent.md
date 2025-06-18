# Staging.Staging-to-FactK12StudentCounts\_NeglectedOrDelinquent

### Overview & Purpose

This stored procedure migrates Neglected Or Delinquent (NOrD) student data from staging tables to the RDS.FactK12StudentCounts fact table. It processes files 119, 127, 180, and 181, focusing on students in neglected or delinquent programs.

#### Main Functions:

*   **Data Migration**

    Transfer and transform NOrD student data from staging tables to the fact table

#### Key Calculations:

*   **Data Migration: Count each student record as 1 in the fact table**

    Formula: `StudentCount = 1`

    Business Significance: Enables accurate counting of students in neglected or delinquent programs

    Example: Each student record is counted as 1 in the StudentCount column

#### Data Transformations:

* Mapping staging table fields to dimension table IDs
* Joining multiple staging tables to create a comprehensive student record
* Handling of NULL values by replacing them with -1 for dimension keys
* Race determination based on HispanicLatinoEthnicity flag and race mapping
* Filtering data based on date ranges and program participation

#### Expected Output:

Populated RDS.FactK12StudentCounts table with NOrD student data for the specified school year

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal reporting on students in neglected or delinquent programs

#### Business Rules:

* Each student is counted once per program participation
* Students must have valid enrollment records
* Program participation dates must overlap with enrollment dates
* Race determination follows specific hierarchy rules

#### Result Usage:

Federal reporting, compliance tracking, and analysis of neglected or delinquent student populations

#### Execution Frequency:

Annually or as needed when new data is available

#### Critical Periods:

* Federal reporting deadlines
* End of school year data collection periods

### Parameters

| Parameter   | Data Type | Purpose                                                      | Required |
| ----------- | --------- | ------------------------------------------------------------ | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which data should be processed | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographics and school information

**Columns:**

| Name                   | Data Type | Business Purpose                            |
| ---------------------- | --------- | ------------------------------------------- |
| id                     | int       | Unique identifier for the enrollment record |
| StudentIdentifierState | varchar   | State-assigned student identifier           |

#### Staging.ProgramParticipationNOrD

**Business Purpose:** Contains data about student participation in neglected or delinquent programs

**Columns:**

| Name                             | Data Type | Business Purpose                                      |
| -------------------------------- | --------- | ----------------------------------------------------- |
| StudentIdentifierState           | varchar   | State-assigned student identifier                     |
| NeglectedOrDelinquentProgramType | varchar   | Indicates the type of neglected or delinquent program |

### Temporary Tables

#### #vwGradeLevels

**Purpose:** Temporary storage of grade level dimension data for the specified school year

**Columns:**

| Name                                  | Data Type | Purpose/Calculation   |
| ------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimGradeLevels | Various   | Direct copy from view |

#### #vwRaces

**Purpose:** Temporary storage of race dimension data for the specified school year

**Columns:**

| Name                            | Data Type | Purpose/Calculation   |
| ------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimRaces | Various   | Direct copy from view |

#### #vwNeglectedOrDelinquentStatuses

**Purpose:** Temporary storage of NOrD status dimension data for the specified school year

**Columns:**

| Name                                   | Data Type | Purpose/Calculation   |
| -------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimNOrDStatuses | Various   | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage of transformed fact data before final insert

**Columns:**

| Name                  | Data Type | Purpose/Calculation                             |
| --------------------- | --------- | ----------------------------------------------- |
| StagingId             | int       | Direct copy from Staging.K12Enrollment.id       |
| Various dimension IDs | int       | Lookup from dimension tables or -1 if not found |
| StudentCount          | int       | Set to 1 for each record                        |

### Potential Improvements

#### Code Comment

**Description:** Complete the incomplete comment about mapping in the NOrD dimension section

**Benefits:** Better documentation for future maintenance

**Priority:** Low

#### Error Handling

**Description:** Add more specific error handling for parameter validation

**Benefits:** Prevent execution with invalid parameters

**Priority:** Medium

#### Performance

**Description:** Add non-clustered indexes to #Facts temp table

**Benefits:** Potentially faster final insert operation

**Priority:** Low

#### Functionality

**Description:** Complete the NOrD dimension mapping logic

**Benefits:** Ensure accurate mapping of NOrD program types

**Priority:** High

### Execution Steps

#### Step 1: Initialize environment and declare variables

**Input Data:** None

**Transformations:** None

SET NOCOUNT ON; IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Retrieve school year information

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create and populate temporary dimension tables

**Input Data:** RDS dimension views

**Transformations:** Filter by school year

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Retrieve fact type ID

**Input Data:** RDS.DimFactTypes

**Transformations:** None

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'nord'

#### Step 5: Delete existing fact records

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create and populate #Facts temp table

**Input Data:** Multiple staging tables and dimension lookups

**Transformations:** Complex joins and mappings

INSERT INTO #Facts SELECT DISTINCT ske.id StagingId, ...

#### Step 7: Insert data into fact table

**Input Data:** #Facts temp table

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 8: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
