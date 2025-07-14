# Staging.Staging-To-FactK12SeclusionsOrRestraints

### Overview & Purpose

This stored procedure populates the RDS.FactK12StudentSeclusionsOrRestraints fact table and related bridge tables with data about K-12 student seclusions and restraints. It extracts data from staging tables, transforms it by joining with dimension views to get dimension IDs, and loads the transformed data into the fact and bridge tables.

#### Main Functions:

*   **Data Extraction**

    Extract relevant data from staging tables related to K-12 student seclusions and restraints
*   **Dimension Lookup**

    Join staging data with dimension views to get dimension IDs for the fact table
*   **Fact Table Population**

    Insert transformed data into the fact table with appropriate dimension IDs
*   **Bridge Table Population**

    Populate bridge tables for many-to-many relationships (races and disability types)

#### Data Transformations:

* Creating temporary tables from dimension views filtered by relevant school years
* Transforming seclusion and restraint data into a unified format
* Joining staging data with dimension views to get dimension IDs
* Handling NULL values by replacing them with default values (-1 for dimension IDs)
* Creating bridge table relationships for races and disability types

#### Expected Output:

Populated RDS.FactK12StudentSeclusionsOrRestraints fact table and related bridge tables (RDS.BridgeK12SeclusionOrRestraintRaces and RDS.BridgeK12SeclusionOrRestraintIdeaDisabilityTypes) with transformed data from staging tables.

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Track and report on incidents of seclusion and restraint in K-12 educational settings, which is important for compliance, safety monitoring, and policy development.

#### Business Rules:

* Both seclusion and restraint incidents are tracked separately
* Each incident is associated with a specific student, school, and date
* Multiple demographic and program participation attributes are captured for analysis
* Incidents with zero count are excluded from processing

#### Result Usage:

The populated fact table is likely used for reporting, analysis, and compliance monitoring related to seclusion and restraint incidents in K-12 schools.

#### Execution Frequency:

Likely executed after each data collection cycle or on a scheduled basis (monthly, quarterly, or annually)

#### Critical Periods:

* End of reporting periods
* Federal or state compliance deadlines

### Parameters

| Parameter           | Data Type   | Purpose                                                               | Required |
| ------------------- | ----------- | --------------------------------------------------------------------- | -------- |
| @DataCollectionName | VARCHAR(60) | Filters the data processing to a specific data collection if provided | False    |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains enrollment information for K-12 students

**Columns:**

| Name                   | Data Type | Business Purpose                             |
| ---------------------- | --------- | -------------------------------------------- |
| Id                     | INT       | Primary key for the enrollment record        |
| SchoolYear             | VARCHAR   | Identifies the school year of the enrollment |
| DataCollectionName     | VARCHAR   | Identifies the data collection               |
| StudentIdentifierState | VARCHAR   | State-assigned student identifier            |

#### Staging.MiK12StudentSeclusionsOrRestraints

**Business Purpose:** Contains data about seclusion and restraint incidents

**Columns:**

| Name             | Data Type | Business Purpose                    |
| ---------------- | --------- | ----------------------------------- |
| Id               | INT       | Primary key for the incident record |
| NumberSecluded   | INT       | Count of seclusion incidents        |
| NumberRestrained | INT       | Count of restraint incidents        |
| DateOccurred     | DATE      | Date when the incident occurred     |

#### Staging.PersonStatus

**Business Purpose:** Contains status information about students

**Columns:**

| Name                  | Data Type | Business Purpose                              |
| --------------------- | --------- | --------------------------------------------- |
| Various status fields | Various   | Track different status attributes of students |

#### Staging.Disability

**Business Purpose:** Contains disability information about students

**Columns:**

| Name                      | Data Type | Business Purpose                        |
| ------------------------- | --------- | --------------------------------------- |
| Various disability fields | Various   | Track disability attributes of students |

### Temporary Tables

#### #SchoolYears

**Purpose:** Stores distinct school years from K12Enrollment for filtering dimension views

**Columns:**

| Name       | Data Type | Purpose/Calculation                         |
| ---------- | --------- | ------------------------------------------- |
| SchoolYear | VARCHAR   | Direct selection from Staging.K12Enrollment |

#### #vwDimDisabilityStatuses

**Purpose:** Temporary copy of disability status dimension view filtered by relevant school years

**Columns:**

| Name                      | Data Type | Purpose/Calculation                               |
| ------------------------- | --------- | ------------------------------------------------- |
| Various dimension columns | Various   | Direct selection from RDS.vwDimDisabilityStatuses |

#### #K12SeclusionOrRestraint

**Purpose:** Transforms seclusion and restraint data into a unified format

**Columns:**

| Name                      | Data Type | Purpose/Calculation                            |
| ------------------------- | --------- | ---------------------------------------------- |
| Id                        | INT       | Direct from source                             |
| SeclusionOrRestraintType  | VARCHAR   | Hardcoded as 'Seclusion' or 'Restraint'        |
| SeclusionOrRestraintCount | INT       | NumberSecluded or NumberRestrained from source |

#### #Facts

**Purpose:** Temporary staging for fact table data before final insert

**Columns:**

| Name                               | Data Type | Purpose/Calculation                              |
| ---------------------------------- | --------- | ------------------------------------------------ |
| Various dimension IDs and measures | Various   | Joins between staging tables and dimension views |

### Potential Improvements

#### Performance

**Description:** Add explicit transaction handling to ensure data consistency

**Benefits:** Ensures all data is committed or rolled back as a unit

**Priority:** Medium

#### Performance

**Description:** Review and optimize join conditions

**Benefits:** Improved query performance

**Priority:** Medium

#### Maintainability

**Description:** Add more comments explaining business logic

**Benefits:** Easier maintenance and knowledge transfer

**Priority:** Low

#### Error Handling

**Description:** Add explicit error handling

**Benefits:** Better error reporting and recovery

**Priority:** Medium

### Execution Steps

#### Step 1: Create temporary table of distinct school years

**Input Data:** Staging.K12Enrollment

**Transformations:** Extract distinct school years

SELECT DISTINCT SchoolYear INTO #SchoolYears FROM Staging.K12Enrollment

#### Step 2: Create temporary tables from dimension views filtered by relevant school years

**Input Data:** RDS dimension views

**Transformations:** Filter by school years

SELECT v.\* INTO #vwDimDisabilityStatuses FROM RDS.vwDimDisabilityStatuses v JOIN #SchoolYears t ON v.SchoolYear = t.SchoolYear

#### Step 3: Create temporary table with student ages

**Input Data:** Staging.K12Enrollment

**Transformations:** Calculate ages using RDS.Get\_Age function

SELECT ske.SchoolYear, DataCollectionName, StudentIdentifierState, LeaIdentifierSeaAttendance, SchoolIdentifierSea, RDS.Get\_Age(BirthDate, GETDATE()) Age INTO #SKEAges FROM staging.K12Enrollment ske

#### Step 4: Join age data with dimension IDs

**Input Data:** #SKEAges, RDS.DimAges

**Transformations:** Join to get dimension IDs

SELECT kea.DataCollectionName, kea.StudentIdentifierState, kea.LeaIdentifierSeaAttendance, kea.SchoolIdentifierSea, da.DimAgeId INTO #K12EnrollmentAges FROM #SKEAges kea INNER JOIN RDS.DimAges da ON kea.Age = da.AgeCode AND da.AgeCode <> 'MISSING'

#### Step 5: Transform seclusion and restraint data into unified format

**Input Data:** Staging.MiK12StudentSeclusionsOrRestraints

**Transformations:** Split into separate rows for seclusion and restraint

SELECT DISTINCT Id, StudentIdentifierState, LeaIdentifierSeaAttendance, SchoolIdentifierSea, DateOccurred, 'Seclusion' AS SeclusionOrRestraintType, NumberSecluded AS SeclusionOrRestraintCount, SchoolYear, DataCollectionName INTO #K12SeclusionOrRestraint FROM Staging.MiK12StudentSeclusionsOrRestraints WHERE ISNULL(NumberSecluded, 0) <> 0

#### Step 6: Create facts temporary table and populate with initial data

**Input Data:** Multiple staging and dimension tables

**Transformations:** Join staging data with dimension tables to get dimension IDs

INSERT INTO #Facts (...) SELECT DISTINCT ske.Id, sksr.Id AS SeclusionOrRestraintId, rsy.DimSchoolYearId, ...

#### Step 7: Update facts with additional dimension IDs

**Input Data:** #Facts and various staging tables

**Transformations:** Join with additional dimension tables

UPDATE #Facts SET K12DemographicId = rdkd.DimK12DemographicId, ...

#### Step 8: Insert data into fact table

**Input Data:** #Facts

**Transformations:** Handle NULL values by replacing with -1

INSERT INTO \[RDS].\[FactK12StudentSeclusionsOrRestraints] (...) SELECT ISNULL(\[SchoolYearId], -1), ...

#### Step 9: Clean up temporary tables

**Input Data:**

**Transformations:**

DROP TABLE IF EXISTS #vwDimDisabilityStatuses ...

#### Step 10: Populate bridge table for races

**Input Data:** Fact table and staging tables

**Transformations:** Join fact table with staging and dimension tables

INSERT INTO RDS.BridgeK12SeclusionOrRestraintRaces (...) SELECT DISTINCT rfksr.FactK12StudentSeclusionOrRestraintId, ISNULL(rdr.DimRaceId, -1) ...

#### Step 11: Populate bridge table for disability types

**Input Data:** Fact table and staging tables

**Transformations:** Join fact table with staging and dimension tables

INSERT INTO RDS.BridgeK12SeclusionOrRestraintIdeaDisabilityTypes (...) SELECT DISTINCT rfksr.FactK12StudentSeclusionOrRestraintId, ISNULL(rdidt.DimIdeaDisabilityTypeId, -1) ...
