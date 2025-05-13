# Staging.Staging-to-FactK12StudentCounts\_MigrantEducationProgram

### Overview & Purpose

This stored procedure migrates Migrant Education Program (MEP) data from staging tables to the RDS.FactK12StudentCounts fact table. It specifically processes files 054, 121, 122, and 145 as noted in the procedure header. The procedure filters data for a specific school year, transforms it according to business rules, and loads it into the fact table.

#### Main Functions:

*   **Data Migration**

    Transfer MEP student data from staging tables to the fact table for reporting and analysis
*   **Dimension Mapping**

    Map staging data to appropriate dimension IDs for the star schema

#### Key Calculations:

*   **Data Migration: Each record represents a single student count in the fact table**

    Formula: `StudentCount = 1`

    Business Significance: Enables accurate counting of students in the Migrant Education Program

    Example: For each qualifying student record, a count of 1 is inserted

#### Data Transformations:

* Mapping student records to appropriate dimension IDs
* Filtering records based on enrollment dates and status dates
* Joining multiple staging tables to create a comprehensive student record
* Handling NULL values by replacing them with default dimension IDs (-1)

#### Expected Output:

Populated RDS.FactK12StudentCounts table with Migrant Education Program data for the specified school year

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal reporting of Migrant Education Program participation and services

#### Business Rules:

* Each student is counted once in the fact table
* Students must have valid enrollment records
* Migrant status is determined by matching status dates with enrollment periods
* IDEA status, English Learner status, and other attributes are linked to student records

#### Result Usage:

The migrated data is used for federal reporting, program evaluation, and educational decision-making regarding migrant students

#### Execution Frequency:

Likely annual or semi-annual, based on school year parameter

#### Critical Periods:

* End of school year reporting periods
* Federal education data submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                     | Required |
| ----------- | --------- | ----------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which data should be migrated | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including school, LEA, and enrollment dates

**Columns:**

| Name                   | Data Type | Business Purpose                             |
| ---------------------- | --------- | -------------------------------------------- |
| id                     | int       | Unique identifier for the enrollment record  |
| SchoolYear             | smallint  | Identifies the school year of the enrollment |
| StudentIdentifierState | varchar   | State-assigned student identifier            |

#### Staging.PersonStatus

**Business Purpose:** Contains student status information including migrant and English learner statuses

**Columns:**

| Name                     | Data Type   | Business Purpose                                          |
| ------------------------ | ----------- | --------------------------------------------------------- |
| StudentIdentifierState   | varchar     | State-assigned student identifier                         |
| MigrantStatus            | varchar/int | Indicates if student is part of Migrant Education Program |
| Migrant\_StatusStartDate | date        | Date when migrant status became effective                 |

### Temporary Tables

#### #vwGradeLevels

**Purpose:** Temporary storage of grade level dimension data for the specified school year

**Columns:**

| Name                                  | Data Type | Purpose/Calculation   |
| ------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimGradeLevels | Various   | Direct copy from view |

#### #vwMigrantStatuses

**Purpose:** Temporary storage of migrant status dimension data for the specified school year

**Columns:**

| Name                                      | Data Type | Purpose/Calculation   |
| ----------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimMigrantStatuses | Various   | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage of transformed fact records before final insert

**Columns:**

| Name                         | Data Type | Purpose/Calculation                           |
| ---------------------------- | --------- | --------------------------------------------- |
| StagingId                    | int       | Direct copy from Staging.K12Enrollment.id     |
| Various dimension ID columns | int       | Lookup from dimension tables or default to -1 |
| StudentCount                 | int       | Set to 1 for each record                      |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling with specific error codes and messages

**Benefits:** Better troubleshooting and error resolution

**Priority:** Medium

#### Transaction Management

**Description:** Add explicit transaction control

**Benefits:** Ensures data consistency if errors occur during processing

**Priority:** High

#### Performance

**Description:** Optimize the complex query that populates #Facts table

**Benefits:** Reduced execution time and resource usage

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize and set up environment

**Input Data:** @SchoolYear parameter

**Transformations:** None

SET NOCOUNT ON; IF OBJECT\_ID(N'tempdb..#vwMigrantStatuses') IS NOT NULL DROP TABLE #vwMigrantStatuses

#### Step 2: Retrieve school year information

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create temporary dimension tables

**Input Data:** RDS.vwDimGradeLevels, RDS.vwDimMigrantStatuses

**Transformations:** Filter by school year

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Determine fact type ID

**Input Data:** rds.DimFactTypes

**Transformations:** None

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'mep'

#### Step 5: Clear existing fact data

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create and populate facts temp table

**Input Data:** Multiple staging and dimension tables

**Transformations:** Complex joins and lookups

CREATE TABLE #Facts (...); INSERT INTO #Facts SELECT ...

#### Step 7: Insert data into fact table

**Input Data:** #Facts temp table

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 8: Rebuild indexes

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
