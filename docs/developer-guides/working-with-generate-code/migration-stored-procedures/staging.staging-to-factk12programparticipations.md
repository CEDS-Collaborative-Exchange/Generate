# Staging.Staging-to-FactK12ProgramParticipations

### Overview & Purpose

This stored procedure transfers K12 program participation data from staging tables to the fact table RDS.FactK12ProgramParticipations and populates the bridge table RDS.BridgeK12ProgramParticipationRaces. It performs data transformation, lookups to dimension tables, and handles various data relationships for K12 student program participation tracking.

#### Main Functions:

*   **Data Transfer from Staging to Fact Table**

    Moves K12 program participation data from staging tables to the fact table with proper dimension key lookups

#### Key Calculations:

*   **Data Transfer from Staging to Fact Table: Sets the count measure for each program participation record**

    Formula: `StudentCount = 1`

    Business Significance: Enables counting of student participation in various programs

    Example: Each row in the fact table represents one student's participation with StudentCount = 1

#### Data Transformations:

* Joining multiple staging tables to collect complete program participation data
* Looking up dimension keys from various dimension tables
* Handling NULL values with ISNULL function to default to -1 for dimension keys
* Updating student IDs that may have been missed in the initial lookup
* Creating race bridge table entries based on student race and ethnicity data

#### Expected Output:

Populated RDS.FactK12ProgramParticipations table with dimension keys and measures, and populated RDS.BridgeK12ProgramParticipationRaces bridge table with race relationships

### Business Context

**System:** K12 Education Data Warehouse

**Necessity:** Tracking student participation in various educational programs for reporting and analysis

#### Business Rules:

* Student identification uses multiple matching criteria including state ID and demographic information
* Program participation is tracked with entry and exit dates
* Race and ethnicity are handled through a bridge table to support multiple race values per student
* Special education status and educational environments are tracked for IDEA reporting

#### Result Usage:

Reporting on student program participation for compliance, funding, and educational outcome analysis

#### Execution Frequency:

Likely executed during regular ETL processes, possibly daily or weekly

#### Critical Periods:

* End of school year reporting periods
* State and federal education reporting deadlines

### Parameters

| Parameter           | Data Type   | Purpose                                                      | Required |
| ------------------- | ----------- | ------------------------------------------------------------ | -------- |
| @DataCollectionName | VARCHAR(60) | Filters processing to a specific data collection if provided | False    |

### Source Tables

#### Staging.K12ProgramParticipation

**Business Purpose:** Stores staging data about student participation in educational programs

**Columns:**

| Name               | Data Type | Business Purpose                      |
| ------------------ | --------- | ------------------------------------- |
| DataCollectionName | VARCHAR   | Identifies the source data collection |

#### Staging.K12Enrollment

**Business Purpose:** Stores staging data about student enrollment in schools

**Columns:**

| Name | Data Type | Business Purpose                      |
| ---- | --------- | ------------------------------------- |
| Id   | INT       | Primary key for the enrollment record |

#### Staging.PersonStatus

**Business Purpose:** Stores staging data about person status information

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Stores staging data about special education program participation

#### Staging.K12PersonRace

**Business Purpose:** Stores staging data about student race information

### Temporary Tables

#### #Facts

**Purpose:** Temporary storage of transformed fact data before insertion into fact table

**Columns:**

| Name      | Data Type | Purpose/Calculation                             |
| --------- | --------- | ----------------------------------------------- |
| StagingId | INT       | Direct assignment from Staging.K12Enrollment.Id |

#### #temp

**Purpose:** Temporary storage for race bridge table data preparation

**Columns:**

| Name                          | Data Type | Purpose/Calculation                           |
| ----------------------------- | --------- | --------------------------------------------- |
| FactK12ProgramParticipationId | INT       | Direct assignment from fact table primary key |

### Potential Improvements

#### Error Handling

**Description:** Add explicit error handling with TRY/CATCH blocks

**Benefits:** Better error reporting and recovery

**Priority:** High

#### Transaction Management

**Description:** Add explicit transaction control

**Benefits:** Ensures data consistency across related tables

**Priority:** Medium

#### Performance

**Description:** Add indexes to temporary tables

**Benefits:** Improved query performance for complex joins

**Priority:** Medium

#### Code Maintainability

**Description:** Refactor complex joins into modular components

**Benefits:** Improved readability and maintainability

**Priority:** Low

### Execution Steps

#### Step 1: Create temporary table for fact data

**Input Data:** None

**Transformations:** Table structure creation

CREATE TABLE #Facts (...)

#### Step 2: Populate temporary fact table with transformed data

**Input Data:** Multiple staging tables joined together

**Transformations:** Dimension key lookups, NULL handling

INSERT INTO #Facts SELECT DISTINCT ...

#### Step 3: Update student IDs that may have been missed

**Input Data:** #Facts table and dimension tables

**Transformations:** Additional lookups for missing student IDs

UPDATE #Facts SET K12StudentId = p.DimPersonId ...

#### Step 4: Insert data into fact table

**Input Data:** #Facts temporary table

**Transformations:** Final NULL handling

INSERT INTO RDS.FactK12ProgramParticipations SELECT DISTINCT ...

#### Step 5: Rebuild indexes on fact table

**Input Data:** None

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12ProgramParticipations REBUILD

#### Step 6: Create temporary table for race bridge data

**Input Data:** Fact table and staging tables

**Transformations:** Join fact data with race information

SELECT DISTINCT ... INTO #temp FROM ...

#### Step 7: Populate race bridge table

**Input Data:** #temp temporary table

**Transformations:** Race mapping logic

Insert Into RDS.BridgeK12ProgramParticipationRaces ...

#### Step 8: Clean up temporary tables

**Input Data:** None

**Transformations:** None

DROP TABLE IF EXISTS #temp
