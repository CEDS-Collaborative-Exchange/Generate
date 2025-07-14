# Staging.Staging-to-FactK12StudentCounts\_GraduationRate

### Overview & Purpose

This stored procedure migrates Graduation Rate data from staging tables to the RDS.FactK12StudentCounts fact table for a specified school year. It processes files 150 and 151 as noted in the procedure header. The procedure joins multiple staging tables to collect student demographic and enrollment information, then transforms and loads this data into the fact table.

#### Main Functions:

*   **Data Migration**

    Transfer graduation rate data from staging tables to the RDS fact table
*   **Data Transformation**

    Map staging data to appropriate dimension keys for the fact table

#### Key Calculations:

*   **Data Migration: Sets the count value for each student record**

    Formula: `StudentCount = 1`

    Business Significance: Enables counting of students for graduation rate calculations

    Example: Each row in the fact table represents one student with a count of 1

#### Data Transformations:

* Mapping student demographic data to dimension tables
* Joining multiple staging tables to create a comprehensive student record
* Filtering data for the specified school year
* Resolving race information using a view for unduplicated race mapping

#### Expected Output:

Populated RDS.FactK12StudentCounts table with graduation rate data for the specified school year

### Business Context

**System:** K-12 Education Data Warehouse

**Necessity:** Required for reporting and analyzing graduation rates across various demographic groups

#### Business Rules:

* Each student record is counted once (StudentCount = 1)
* Records are filtered by the specified school year
* Student demographic information is mapped to appropriate dimension tables
* Existing data for the same school year and fact type is deleted before new data is inserted

#### Result Usage:

The data is used for graduation rate analysis, reporting, and compliance with educational standards

#### Execution Frequency:

Likely annual, based on school year parameter

#### Critical Periods:

* End of school year reporting periods
* Federal and state education data submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                                      | Required |
| ----------- | --------- | ---------------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which graduation rate data should be processed | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data

**Columns:**

| Name                   | Data Type | Business Purpose                            |
| ---------------------- | --------- | ------------------------------------------- |
| id                     | int       | Unique identifier for the enrollment record |
| StudentIdentifierState | varchar   | State-assigned student identifier           |
| SchoolYear             | smallint  | Indicates the school year of the enrollment |

#### Staging.PersonStatus

**Business Purpose:** Contains student demographic and status information

**Columns:**

| Name                       | Data Type | Business Purpose                               |
| -------------------------- | --------- | ---------------------------------------------- |
| StudentIdentifierState     | varchar   | State-assigned student identifier              |
| HomelessnessStatus         | smallint  | Indicates student homelessness status          |
| EconomicDisadvantageStatus | smallint  | Indicates student economic disadvantage status |

### Temporary Tables

#### #vwRaces

**Purpose:** Temporary storage for race dimension data

**Columns:**

| Name    | Data Type | Purpose/Calculation       |
| ------- | --------- | ------------------------- |
| RaceMap | varchar   | None - copied from source |

#### #vwEconomicallyDisadvantagedStatuses

**Purpose:** Temporary storage for economically disadvantaged status dimension data

#### #Facts

**Purpose:** Temporary storage for fact data before final insert

**Columns:**

| Name         | Data Type | Purpose/Calculation        |
| ------------ | --------- | -------------------------- |
| StagingId    | int       | Direct from source         |
| SchoolYearId | int       | Lookup from DimSchoolYears |
| StudentCount | int       | Set to 1 for each record   |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling with specific error codes and messages

**Benefits:** Better troubleshooting and error resolution

**Priority:** Medium

#### Performance

**Description:** Optimize the complex join in the #Facts table population

**Benefits:** Reduced execution time and resource usage

**Priority:** High

#### Code Clarity

**Description:** Complete the cohort mapping that is currently commented out and noted as needing research

**Benefits:** Complete functionality and better data accuracy

**Priority:** High

#### Transaction Management

**Description:** Add explicit transaction handling

**Benefits:** Better data consistency and recovery options

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize and set up environment

**Input Data:** None

**Transformations:** None

SET NOCOUNT ON; IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Retrieve school year information

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create temporary dimension views

**Input Data:** RDS dimension views

**Transformations:** None

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Get fact type ID

**Input Data:** RDS.DimFactTypes

**Transformations:** None

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'gradrate'

#### Step 5: Clear existing data

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create and populate facts temp table

**Input Data:** Multiple staging tables and dimension views

**Transformations:** Complex joins and mappings

INSERT INTO #Facts SELECT DISTINCT ske.id StagingId, rsy.DimSchoolYearId SchoolYearId, @FactTypeId FactTypeId, ...

#### Step 7: Insert data into fact table

**Input Data:** #Facts temp table

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 8: Rebuild indexes

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
