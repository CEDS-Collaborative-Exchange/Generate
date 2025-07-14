# Staging.Staging-to-FactK12StudentCounts\_Membership

### Overview & Purpose

This stored procedure migrates K12 student membership data from staging tables to the RDS.FactK12StudentCounts fact table. It processes files 033 and 052, focusing on student counts for membership reporting as of a specific membership date.

#### Main Functions:

*   **Data Migration**

    Transfers student membership data from staging tables to the fact table while applying business rules and data transformations
*   **Grade Level Filtering**

    Determines which grade levels to include based on toggle settings
*   **Race/Ethnicity Determination**

    Applies business rules to determine student race/ethnicity categorization

#### Key Calculations:

*   **Data Migration: Calculate student age as of the membership date**

    Formula: `RDS.Get_Age(ske.Birthdate, @MembershipDate)`

    Business Significance: Ensures accurate age reporting for student counts

    Example: If birthdate is 2010-05-15 and membership date is 2022-10-01, age would be 12

#### Data Transformations:

* Mapping staging table values to dimension table IDs
* Determining unduplicated race categorization
* Filtering students based on enrollment dates and membership date
* Applying grade level inclusion rules based on toggle settings

#### Expected Output:

Populated RDS.FactK12StudentCounts table with student count records for the specified school year, with each record representing one student's membership status

### Business Context

**System:** K12 Education Data Reporting System

**Necessity:** Required for federal and state education reporting on student membership counts

#### Business Rules:

* Students must be enrolled on the membership date to be counted
* Hispanic/Latino ethnicity takes precedence over race in reporting
* Grade levels 13, Ungraded, and Adult Education are conditionally included based on toggle settings
* Student demographic information must match between staging and dimension tables

#### Result Usage:

The data is used for official student count reporting, funding allocations, and educational statistics

#### Execution Frequency:

Annually during the official student count reporting period

#### Critical Periods:

* Fall membership count date (typically in October)
* End-of-year reporting deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                        | Required |
| ----------- | --------- | -------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which to process membership data | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores staged student enrollment data from source files

**Columns:**

| Name                   | Data Type | Business Purpose                                    |
| ---------------------- | --------- | --------------------------------------------------- |
| id                     | int       | Unique identifier for the staging record            |
| SchoolYear             | smallint  | Identifies the school year of the enrollment record |
| StudentIdentifierState | varchar   | State-assigned student identifier                   |
| GradeLevel             | varchar   | Student's grade level                               |
| EnrollmentEntryDate    | date      | Date student enrolled                               |
| EnrollmentExitDate     | date      | Date student exited enrollment                      |

#### Staging.PersonStatus

**Business Purpose:** Stores additional student demographic and status information

**Columns:**

| Name                                                   | Data Type | Business Purpose                                          |
| ------------------------------------------------------ | --------- | --------------------------------------------------------- |
| StudentIdentifierState                                 | varchar   | State-assigned student identifier                         |
| EligibilityStatusForSchoolFoodServicePrograms          | varchar   | Indicates student's eligibility for food service programs |
| NationalSchoolLunchProgramDirectCertificationIndicator | bit       | Indicates direct certification for lunch program          |
| EconomicDisadvantageStatus                             | bit       | Indicates if student is economically disadvantaged        |

#### App.ToggleQuestions

**Business Purpose:** Stores configuration questions that affect processing logic

**Columns:**

| Name               | Data Type | Business Purpose                          |
| ------------------ | --------- | ----------------------------------------- |
| ToggleQuestionId   | int       | Unique identifier for the toggle question |
| EmapsQuestionAbbrv | varchar   | Abbreviated code for the toggle question  |

#### App.ToggleResponses

**Business Purpose:** Stores responses to configuration questions

**Columns:**

| Name             | Data Type | Business Purpose                              |
| ---------------- | --------- | --------------------------------------------- |
| ToggleQuestionId | int       | Identifies which question the response is for |
| ResponseValue    | varchar   | The configured response value                 |

### Temporary Tables

#### #vwGradeLevels

**Purpose:** Caches grade level dimension data for the specified school year

**Columns:**

| Name                                  | Data Type | Purpose/Calculation   |
| ------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimGradeLevels | Various   | Direct copy from view |

#### #vwRaces

**Purpose:** Caches race dimension data for the specified school year

**Columns:**

| Name                            | Data Type | Purpose/Calculation   |
| ------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimRaces | Various   | Direct copy from view |

#### #vwUnduplicatedRaceMap

**Purpose:** Caches unduplicated race mapping data for the specified school year

**Columns:**

| Name                                       | Data Type | Purpose/Calculation   |
| ------------------------------------------ | --------- | --------------------- |
| All columns from RDS.vwUnduplicatedRaceMap | Various   | Direct copy from view |

#### #vwEconomicallyDisadvantagedStatuses

**Purpose:** Caches economically disadvantaged status dimension data for the specified school year

**Columns:**

| Name                                                        | Data Type | Purpose/Calculation   |
| ----------------------------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimEconomicallyDisadvantagedStatuses | Various   | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage for transformed fact records before final insert

**Columns:**

| Name                  | Data Type | Purpose/Calculation                                            |
| --------------------- | --------- | -------------------------------------------------------------- |
| StagingId             | int       | Direct copy from Staging.K12Enrollment.id                      |
| SchoolYearId          | int       | Lookup from RDS.DimSchoolYears                                 |
| FactTypeId            | int       | Lookup from RDS.DimFactTypes where FactTypeCode = 'membership' |
| Various dimension IDs | int       | Lookups from dimension tables or -1 for N/A                    |
| StudentCount          | int       | Hard-coded as 1 (one student per record)                       |

#### @GradesList

**Purpose:** Table variable to store valid grade levels to include based on toggle settings

**Columns:**

| Name       | Data Type  | Purpose/Calculation                |
| ---------- | ---------- | ---------------------------------- |
| GradeLevel | varchar(3) | Populated based on toggle settings |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling with specific error codes and messages

**Benefits:** Better troubleshooting and more specific error information

**Priority:** Medium

#### Transaction Management

**Description:** Add explicit transaction handling to ensure atomicity

**Benefits:** Prevents partial data loads if errors occur

**Priority:** High

#### Performance

**Description:** Optimize the large INSERT query by breaking it into smaller operations

**Benefits:** Reduced memory usage and potentially faster execution

**Priority:** Medium

#### Logging

**Description:** Add detailed logging of record counts and processing steps

**Benefits:** Better monitoring and troubleshooting

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize environment and clean up temporary objects

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels

#### Step 2: Declare and set variables

**Input Data:** Parameter @SchoolYear, App.ToggleQuestions, App.ToggleResponses

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Determine grade level inclusion based on toggle settings

**Input Data:** App.ToggleQuestions, App.ToggleResponses

**Transformations:** Convert toggle responses to bit values

select @toggleGrade13 = ISNULL( case when r.ResponseValue = 'true' then 1 else 0 end, 0 )

#### Step 4: Populate grade levels list based on toggle settings

**Input Data:** Toggle variables

**Transformations:** None

INSERT INTO @GradesList VALUES ('PK'),('KG'),('01'),...

#### Step 5: Create and populate temporary tables from dimension views

**Input Data:** RDS dimension views

**Transformations:** Filter by school year

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 6: Create indexes on temporary tables

**Input Data:** Temporary tables

**Transformations:** None

CREATE CLUSTERED INDEX ix\_tempvwGradeLevels ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap)

#### Step 7: Get fact type ID and delete existing records

**Input Data:** RDS.DimFactTypes

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 8: Create and populate #Facts temporary table

**Input Data:** Staging.K12Enrollment, Staging.PersonStatus, dimension tables

**Transformations:** Join staging data to dimension tables, apply business rules

INSERT INTO #Facts SELECT DISTINCT...

#### Step 9: Insert data from #Facts into destination table

**Input Data:** #Facts temporary table

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 10: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
