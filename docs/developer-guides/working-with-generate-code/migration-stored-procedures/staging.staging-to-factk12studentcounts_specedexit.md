# Staging.Staging-to-FactK12StudentCounts\_SpecEdExit

### Overview & Purpose

This stored procedure migrates special education exit data from staging tables to the RDS.FactK12StudentCounts fact table. It specifically processes data related to students who have exited special education services within a given school year. The procedure handles data transformation, joins across multiple dimension tables, and ensures proper attribution of demographic and program participation information.

#### Main Functions:

*   **Data Migration**

    Transfers special education exit data from staging tables to the fact table with proper dimension keys

#### Key Calculations:

*   **Data Migration: Determines the age of students at the time of the child count**

    Formula: `Age calculation using RDS.Get_Age(ske.Birthdate, IIF(rdd.DateValue < @ChildCountDate, @PreviousChildCountDate, @ChildCountDate))`

    Business Significance: Ensures accurate age reporting for federal/state compliance

    Example: If a student was born on 01/15/2010 and the child count date is 10/01/2021, the age would be 11

#### Data Transformations:

* Maps staging table IDs to dimension table surrogate keys
* Determines student race/ethnicity based on Hispanic/Latino ethnicity flag and race data
* Links special education exit data with enrollment records to ensure valid reporting periods
* Updates IDEA status and primary disability information
* Updates English Learner status information

#### Expected Output:

Populated RDS.FactK12StudentCounts table with special education exit data, including all relevant dimension keys and a student count of 1 for each record

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal and state reporting of special education exit data

#### Business Rules:

* Students must have a valid special education program participation end date
* Students must have enrollment records that overlap with their special education exit date
* Age is calculated based on the child count date for the reporting period
* Race/ethnicity is determined based on federal reporting guidelines (Hispanic/Latino takes precedence)

#### Result Usage:

The data is used for federal reporting requirements, state accountability, and analysis of special education program outcomes

#### Execution Frequency:

Annually during the federal/state reporting cycle

#### Critical Periods:

* End of school year reporting period
* Federal submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                                    | Required |
| ----------- | --------- | -------------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which to process special education exit data | True     |

### Source Tables

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Contains information about students' participation in special education programs, including exit dates and reasons

**Columns:**

| Name                        | Data Type | Business Purpose                                         |
| --------------------------- | --------- | -------------------------------------------------------- |
| Id                          | int       | Unique identifier for the record                         |
| StudentIdentifierState      | varchar   | State-assigned student identifier                        |
| ProgramParticipationEndDate | date      | Date when student exited special education services      |
| SpecialEducationExitReason  | varchar   | Reason code for why the student exited special education |

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment information

**Columns:**

| Name                    | Data Type | Business Purpose                        |
| ----------------------- | --------- | --------------------------------------- |
| StudentIdentifierState  | varchar   | State-assigned student identifier       |
| EnrollmentEntryDate     | date      | Date when student enrolled              |
| EnrollmentExitDate      | date      | Date when student exited enrollment     |
| Birthdate               | date      | Student's date of birth                 |
| Sex                     | varchar   | Student's sex                           |
| HispanicLatinoEthnicity | bit       | Indicates if student is Hispanic/Latino |

### Temporary Tables

#### #vwRaces

**Purpose:** Temporary storage of race dimension data for the specified school year

**Columns:**

| Name      | Data Type | Purpose/Calculation             |
| --------- | --------- | ------------------------------- |
| RaceMap   | varchar   | Direct copy from RDS.vwDimRaces |
| RaceCode  | varchar   | Direct copy from RDS.vwDimRaces |
| DimRaceId | int       | Direct copy from RDS.vwDimRaces |

#### #Facts

**Purpose:** Temporary storage of fact records before final insert into fact table

**Columns:**

| Name         | Data Type | Purpose/Calculation                                              |
| ------------ | --------- | ---------------------------------------------------------------- |
| StagingId    | int       | Direct copy from Staging.ProgramParticipationSpecialEducation.Id |
| SchoolYearId | int       | Lookup from RDS.DimSchoolYears based on @SchoolYear parameter    |
| FactTypeId   | int       | Lookup from RDS.DimFactTypes where FactTypeCode = 'specedexit'   |
| StudentCount | int       | Hard-coded as 1                                                  |

#### #uniqueLEAs

**Purpose:** Temporary storage of unique LEA information for Title I and Migrant updates

**Columns:**

| Name                     | Data Type   | Purpose/Calculation                      |
| ------------------------ | ----------- | ---------------------------------------- |
| LeaIdentifierSea         | VARCHAR(50) | Direct copy from Staging.K12Organization |
| LEA\_RecordStartDateTime | DATETIME    | Direct copy from Staging.K12Organization |
| LEA\_RecordEndDateTime   | DATETIME    | Direct copy from Staging.K12Organization |

### Potential Improvements

#### Error Handling

**Description:** Enhance error handling to include more specific error messages and handling for different types of errors

**Benefits:** Better troubleshooting and more robust execution

**Priority:** Medium

#### Performance

**Description:** Add appropriate indexes to temp tables to improve join performance

**Benefits:** Faster execution, especially for large datasets

**Priority:** Medium

#### Code Structure

**Description:** Modularize the procedure by breaking it into smaller, reusable components

**Benefits:** Improved maintainability and potential code reuse

**Priority:** Low

### Execution Steps

#### Step 1: Initialize variables and clean up any existing temp tables

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID(N'tempdb..#Facts') IS NOT NULL DROP TABLE #Facts

#### Step 2: Set up variables for date calculations and lookups

**Input Data:** App.ToggleQuestions, App.ToggleResponses, RDS.DimSchoolYears

**Transformations:** Calculate child count date and reference period dates

SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)

#### Step 3: Create and populate temporary tables

**Input Data:** RDS.vwDimRaces

**Transformations:** Copy race dimension data for the specified school year

SELECT \* INTO #vwRaces FROM RDS.vwDimRaces WHERE SchoolYear = @SchoolYear

#### Step 4: Delete existing fact records for the specified school year and fact type

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 5: Create and populate #Facts temp table with base data

**Input Data:** Multiple staging and dimension tables

**Transformations:** Join staging data with dimension tables to get surrogate keys

INSERT INTO #Facts SELECT...

#### Step 6: Create and populate #uniqueLEAs temp table

**Input Data:** Staging.K12Organization

**Transformations:** Filter for LEAs that are reported federally

INSERT INTO #uniqueLEAs SELECT DISTINCT...

#### Step 7: Update #Facts with IDEA data

**Input Data:** Staging.ProgramParticipationSpecialEducation, Staging.IdeaDisabilityType

**Transformations:** Join to get IDEA status and disability information

UPDATE #Facts SET IdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)...

#### Step 8: Update #Facts with English Learner data

**Input Data:** Staging.PersonStatus

**Transformations:** Join to get English Learner status information

UPDATE #Facts SET EnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)...

#### Step 9: Insert data from #Facts into RDS.FactK12StudentCounts

**Input Data:** #Facts

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 10: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
