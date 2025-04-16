# Staging.Staging-to-FactK12StudentCounts\_Dropout

### Overview & Purpose

This stored procedure migrates dropout data from staging tables to the RDS.FactK12StudentCounts fact table for a specific school year. It processes file type 032 (dropout data) and transforms the data from various staging tables into a consolidated fact table format for reporting and analysis purposes.

#### Main Functions:

*   **Data Migration**

    Transfers dropout-related student data from staging tables to the RDS fact table
*   **Dimension Mapping**

    Maps staging data to appropriate dimension IDs for the fact table

#### Key Calculations:

*   **Data Migration: Counts each student record as 1 in the fact table**

    Formula: `StudentCount = 1`

    Business Significance: Enables accurate counting of dropout students for reporting

    Example: Each student record in the staging table becomes one row in the fact table with StudentCount=1

#### Data Transformations:

* Mapping student demographic data to dimension tables
* Joining multiple staging tables to create a comprehensive student record
* Filtering data based on date ranges to ensure accurate time period representation
* Handling NULL values by replacing them with default values (-1 for dimension IDs)

#### Expected Output:

Populated RDS.FactK12StudentCounts table with dropout data for the specified school year, with each record representing a student dropout instance with associated dimension references

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal and state reporting of student dropout statistics

#### Business Rules:

* Each student is counted once in the dropout statistics
* Students must have valid enrollment records
* Various demographic and status indicators must be properly mapped to dimension tables
* Time periods must align with the specified school year

#### Result Usage:

The data is used for educational reporting, analysis of dropout trends, and compliance with reporting requirements

#### Execution Frequency:

Likely annual, aligned with school year reporting cycles

#### Critical Periods:

* End of school year reporting periods
* Federal and state education data submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                              | Required |
| ----------- | --------- | -------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which dropout data should be processed | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including entry and exit dates

**Columns:**

| Name                   | Data Type | Business Purpose                            |
| ---------------------- | --------- | ------------------------------------------- |
| id                     | int       | Unique identifier for the enrollment record |
| SchoolYear             | smallint  | Indicates the school year of the enrollment |
| StudentIdentifierState | varchar   | State-assigned student identifier           |

#### Staging.PersonStatus

**Business Purpose:** Contains various status indicators for students

**Columns:**

| Name                   | Data Type | Business Purpose                        |
| ---------------------- | --------- | --------------------------------------- |
| StudentIdentifierState | varchar   | State-assigned student identifier       |
| HomelessnessStatus     | smallint  | Indicates student's homelessness status |

### Temporary Tables

#### #vwRaces

**Purpose:** Temporary storage of race dimension data for the specified school year

**Columns:**

| Name      | Data Type | Purpose/Calculation          |
| --------- | --------- | ---------------------------- |
| RaceMap   | varchar   | Direct copy from source view |
| DimRaceId | int       | Direct copy from source view |

#### #vwEconomicallyDisadvantagedStatuses

**Purpose:** Temporary storage of economic status dimension data

**Columns:**

| Name                                 | Data Type | Purpose/Calculation          |
| ------------------------------------ | --------- | ---------------------------- |
| EconomicDisadvantageStatusMap        | smallint  | Direct copy from source view |
| DimEconomicallyDisadvantagedStatusId | int       | Direct copy from source view |

#### #Facts

**Purpose:** Temporary storage of transformed fact data before final insert

**Columns:**

| Name         | Data Type | Purpose/Calculation                |
| ------------ | --------- | ---------------------------------- |
| StagingId    | int       | Direct copy from source staging ID |
| SchoolYearId | int       | Lookup from DimSchoolYears         |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling for each major step

**Benefits:** Better error diagnostics and recovery options

**Priority:** Medium

#### Transaction Management

**Description:** Implement explicit transaction handling

**Benefits:** Ensures data consistency if errors occur mid-process

**Priority:** High

#### Performance

**Description:** Optimize the complex join in the #Facts population step

**Benefits:** Reduced execution time and resource usage

**Priority:** Medium

#### Documentation

**Description:** Add more detailed inline comments explaining business logic

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Low

### Execution Steps

#### Step 1: Initialize variables and clean up any existing temp tables

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Retrieve school year information and set date variables

**Input Data:** @SchoolYear parameter

**Transformations:** Lookup DimSchoolYearId from RDS.DimSchoolYears

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create and populate temporary dimension view tables

**Input Data:** RDS dimension views filtered by school year

**Transformations:** Copy dimension data to temp tables

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Retrieve fact type ID for dropout data

**Input Data:** RDS.DimFactTypes table

**Transformations:** Lookup DimFactTypeId for 'dropout' code

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'dropout'

#### Step 5: Delete existing fact records for the school year and fact type

**Input Data:** RDS.FactK12StudentCounts table

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create and populate temporary facts table

**Input Data:** Multiple staging tables joined together

**Transformations:** Complex joins and mappings to dimension IDs

INSERT INTO #Facts SELECT DISTINCT ske.id StagingId, ...

#### Step 7: Insert data from temporary facts table to destination fact table

**Input Data:** #Facts temporary table

**Transformations:** None - direct copy

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 8: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts table

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
