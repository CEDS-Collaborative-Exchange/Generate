# Staging.Staging-To-FactSpecialEducation

### Overview & Purpose

This stored procedure populates the RDS.FactSpecialEducation table and related bridge tables with special education data from staging tables. It processes student enrollment data with a focus on special education program participation, creating dimension relationships and fact records for reporting and analysis purposes.

#### Main Functions:

*   **Data Preparation**

    Creates temporary tables with filtered data from dimension views to improve join performance
*   **Fact Table Population**

    Transforms staging data into the dimensional model for the FactSpecialEducation table
*   **Bridge Table Population**

    Creates many-to-many relationships between facts and dimensions for race and disability types

#### Key Calculations:

*   **Fact Table Population: Sets a count of 1 for each student record**

    Formula: `StudentCount = 1`

    Business Significance: Enables counting of students in reporting

    Example: Each row in the fact table represents one student with StudentCount = 1

#### Data Transformations:

* Converting staging table data into a dimensional model
* Mapping codes to dimension IDs
* Handling NULL values by replacing them with default values or 'MISSING'
* Creating relationships between facts and multiple dimensions through bridge tables

#### Expected Output:

Populated RDS.FactSpecialEducation table with dimensional relationships and two bridge tables (BridgeSpecialEducationRaces and BridgeSpecialEducationIdeaDisabilityTypes) containing the many-to-many relationships.

### Business Context

**System:** Education data warehouse for special education reporting

**Necessity:** Required for analyzing and reporting on special education students and programs across educational institutions

#### Business Rules:

* Special education data must be linked to student enrollment records
* Multiple disability types must be properly associated with students
* Race and ethnicity data must be properly captured for demographic analysis
* Various program statuses and indicators must be correctly mapped to dimension values

#### Result Usage:

The data is used for federal and state reporting requirements, program analysis, and educational outcome tracking for special education students

#### Execution Frequency:

Likely executed after each data collection cycle or periodically as new data becomes available

#### Critical Periods:

* End of school year reporting periods
* Federal and state reporting deadlines
* After major data collection efforts

### Parameters

| Parameter           | Data Type   | Purpose                                                               | Required |
| ------------------- | ----------- | --------------------------------------------------------------------- | -------- |
| @DataCollectionName | VARCHAR(60) | Filters the data processing to a specific data collection if provided | False    |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data that serves as the foundation for special education reporting

**Columns:**

| Name       | Data Type | Business Purpose                               |
| ---------- | --------- | ---------------------------------------------- |
| Id         | INT       | Primary key for the staging table              |
| SchoolYear | VARCHAR   | Identifies the academic year of the enrollment |

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Contains data about student participation in special education programs

**Columns:**

| Name                   | Data Type | Business Purpose                                     |
| ---------------------- | --------- | ---------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Unique identifier for students at the state level    |
| SpecialEducationFTE    | DECIMAL   | Full-time equivalency for special education services |

### Temporary Tables

#### #SchoolYears

**Purpose:** Stores distinct school years from the K12Enrollment table for filtering dimension views

**Columns:**

| Name       | Data Type | Purpose/Calculation                         |
| ---------- | --------- | ------------------------------------------- |
| SchoolYear | VARCHAR   | Direct selection from Staging.K12Enrollment |

#### #Facts

**Purpose:** Temporary storage for fact data before insertion into the fact table

**Columns:**

| Name         | Data Type | Purpose/Calculation                            |
| ------------ | --------- | ---------------------------------------------- |
| StagingId    | INT       | Direct selection from Staging.K12Enrollment.Id |
| SchoolYearId | INT       | Lookup from RDS.DimSchoolYears                 |

### Potential Improvements

#### Performance

**Description:** Add explicit transaction handling to ensure data consistency

**Benefits:** Prevents partial data loads and ensures atomicity

**Priority:** Medium

#### Performance

**Description:** Add error handling for parameter validation

**Benefits:** Prevents execution with invalid parameters

**Priority:** Low

#### Performance

**Description:** Optimize the multiple UPDATE statements on #Facts table

**Benefits:** Reduces execution time by combining updates or using more efficient patterns

**Priority:** Medium

#### Maintainability

**Description:** Add more detailed comments explaining business rules and transformations

**Benefits:** Improves maintainability and knowledge transfer

**Priority:** Low

### Execution Steps

#### Step 1: Create temporary table with distinct school years

**Input Data:** Staging.K12Enrollment

**Transformations:** Extract distinct school years

SELECT DISTINCT SchoolYear INTO #SchoolYears FROM Staging.K12Enrollment

#### Step 2: Create temporary tables from dimension views filtered by school years

**Input Data:** RDS dimension views

**Transformations:** Filter dimension data by relevant school years

SELECT v.\* INTO #vwDimK12Demographics FROM RDS.vwDimK12Demographics v JOIN #SchoolYears t ON v.SchoolYear = t.SchoolYear

#### Step 3: Create and populate temporary facts table

**Input Data:** Staging tables and dimension tables

**Transformations:** Join staging data with dimensions to create fact records

INSERT INTO #Facts (...) SELECT ... FROM staging.ProgramParticipationSpecialEducation sppse INNER JOIN staging.K12Enrollment ske ON ...

#### Step 4: Update temporary facts table with additional dimension keys

**Input Data:** #Facts table and staging tables

**Transformations:** Join with additional staging tables to populate more dimension keys

UPDATE #Facts SET K12DemographicId = rdkd.DimK12DemographicId, ... FROM #Facts f JOIN Staging.K12Enrollment ske ON f.StagingId = ske.Id ...

#### Step 5: Insert data into fact table

**Input Data:** #Facts temporary table

**Transformations:** Replace NULL dimension keys with -1 (unknown member)

INSERT INTO \[RDS].\[FactSpecialEducation] (...) SELECT ISNULL(\[SchoolYearId], -1), ..., 1 AS \[StudentCount] FROM #Facts

#### Step 6: Populate bridge tables for races

**Input Data:** Fact table and staging tables

**Transformations:** Create many-to-many relationships between facts and race dimensions

INSERT INTO RDS.BridgeSpecialEducationRaces (...) SELECT DISTINCT rfse.FactSpecialEducationId, ISNULL(rdr.DimRaceId, -1) FROM RDS.FactSpecialEducation rfse ...

#### Step 7: Populate bridge tables for disability types

**Input Data:** Fact table and staging tables

**Transformations:** Create many-to-many relationships between facts and disability type dimensions

INSERT INTO RDS.BridgeSpecialEducationIdeaDisabilityTypes (...) SELECT DISTINCT rfse.FactSpecialEducationId, ISNULL(rdidt.DimIdeaDisabilityTypeId, -1) FROM RDS.FactSpecialEducation rfse ...

#### Step 8: Clean up temporary tables

**Input Data:**

**Transformations:**

DROP TABLE IF EXISTS #SchoolYears, #vwDimK12Demographics, ...
