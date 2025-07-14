# Staging.Staging-to-FactK12StudentCounts\_Chronic

### Overview & Purpose

This stored procedure migrates Chronic Absenteeism data from staging tables to the RDS.FactK12StudentCounts fact table. It processes data for a specific school year, joining multiple dimension tables to create a comprehensive view of student chronic absenteeism statistics.

#### Main Functions:

*   **Data Migration**

    Transfers chronic absenteeism data from staging tables to the production fact table

#### Key Calculations:

*   **Data Migration: Counts each student record as 1 in the fact table**

    Formula: `StudentCount = 1`

    Business Significance: Provides the basis for aggregating student counts in reporting

    Example: Each student with chronic absenteeism is counted once in the fact table

#### Data Transformations:

* Joins multiple dimension tables to enrich student data
* Maps codes from staging tables to dimension IDs in the fact table
* Filters data based on date ranges to ensure accurate time period representation
* Handles missing values by defaulting to -1 for dimension IDs

#### Expected Output:

Populated RDS.FactK12StudentCounts table with chronic absenteeism data for the specified school year

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for tracking and reporting chronic absenteeism statistics in K-12 education

#### Business Rules:

* Data is processed for a specific school year
* Records with missing dimension values default to -1
* Existing data for the same school year and fact type is deleted before new data is inserted
* Student records must match on multiple identifiers including state ID, name, and birth date

#### Result Usage:

The data is used for educational reporting, analysis of chronic absenteeism patterns, and compliance with educational reporting requirements

#### Execution Frequency:

Likely executed annually or semi-annually when new school year data becomes available

#### Critical Periods:

* End of school year reporting periods
* State and federal education data submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                                          | Required |
| ----------- | --------- | -------------------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which chronic absenteeism data should be processed | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographic information and enrollment dates

**Columns:**

| Name                   | Data Type | Business Purpose                             |
| ---------------------- | --------- | -------------------------------------------- |
| id                     | int       | Unique identifier for the enrollment record  |
| SchoolYear             | smallint  | Identifies the school year of the enrollment |
| StudentIdentifierState | varchar   | State-assigned student identifier            |

#### Staging.PersonStatus

**Business Purpose:** Contains various status indicators for students including homelessness, economic disadvantage, and English learner status

**Columns:**

| Name                   | Data Type | Business Purpose                        |
| ---------------------- | --------- | --------------------------------------- |
| StudentIdentifierState | varchar   | State-assigned student identifier       |
| HomelessnessStatus     | smallint  | Indicates student's homelessness status |

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

#### #vwHomelessnessStatuses

**Purpose:** Temporary storage of homelessness status dimension data for the specified school year

**Columns:**

| Name                                           | Data Type | Purpose/Calculation   |
| ---------------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimHomelessnessStatuses | Various   | Direct copy from view |

#### #vwEconomicallyDisadvantagedStatuses

**Purpose:** Temporary storage of economically disadvantaged status dimension data for the specified school year

**Columns:**

| Name                                                        | Data Type | Purpose/Calculation   |
| ----------------------------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimEconomicallyDisadvantagedStatuses | Various   | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage of fact data before final insertion into the fact table

**Columns:**

| Name         | Data Type | Purpose/Calculation                                 |
| ------------ | --------- | --------------------------------------------------- |
| StagingId    | int       | Direct copy from Staging.K12Enrollment.id           |
| SchoolYearId | int       | Lookup from RDS.DimSchoolYears based on @SchoolYear |
| StudentCount | int       | Set to 1 for each record                            |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling with specific error codes and messages

**Benefits:** Better troubleshooting and more specific error information

**Priority:** Medium

#### Transaction Management

**Description:** Implement explicit transaction management

**Benefits:** Ensures data consistency and provides rollback capability

**Priority:** Medium

#### Performance

**Description:** Optimize the complex join query in the #Facts population step

**Benefits:** Reduced execution time and resource usage

**Priority:** High

#### Documentation

**Description:** Add more detailed inline documentation

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Low

### Execution Steps

#### Step 1: Set up environment and declare variables

**Input Data:** None

**Transformations:** None

SET NOCOUNT ON; IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Retrieve school year information

**Input Data:** @SchoolYear parameter

**Transformations:** Lookup school year ID and date range

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create temporary dimension tables

**Input Data:** RDS dimension views

**Transformations:** Copy data to temp tables with filtering

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Determine fact type ID

**Input Data:** RDS.DimFactTypes

**Transformations:** Lookup fact type ID for chronic absenteeism

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'chronic'

#### Step 5: Delete existing fact records

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create and populate facts temp table

**Input Data:** Multiple staging and dimension tables

**Transformations:** Complex joins and lookups to create fact records

INSERT INTO #Facts SELECT DISTINCT ske.id StagingId, rsy.DimSchoolYearId SchoolYearId, @FactTypeId FactTypeId, ...

#### Step 7: Insert data into fact table

**Input Data:** #Facts temp table

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 8: Rebuild indexes

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
