# Staging.Staging-to-FactK12StudentCounts\_ChildCount

### Overview & Purpose

This stored procedure migrates Child Count data from staging tables to the RDS.FactK12StudentCounts fact table for a specified school year. It specifically processes files 002 and 089, focusing on special education student counts for IDEA reporting requirements.

#### Main Functions:

*   **Data Migration**

    Transfers child count data from staging tables to the RDS fact table for reporting and analysis

#### Key Calculations:

*   **Data Migration: Calculate student age as of the child count date**

    Formula: `RDS.Get_Age(ske.Birthdate, @ChildCountDate)`

    Business Significance: Ensures accurate age reporting for special education students

    Example: If birthdate is 2010-05-15 and child count date is 2021-10-01, age would be 11

#### Data Transformations:

* Mapping staging data to dimension tables using view-based lookups
* Determining race categorization based on Hispanic/Latino ethnicity and race codes
* Filtering students based on enrollment dates that include the child count date
* Joining multiple staging tables to create a comprehensive student record

#### Expected Output:

Populated RDS.FactK12StudentCounts table with special education student counts for the specified school year

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal IDEA (Individuals with Disabilities Education Act) reporting of special education student counts

#### Business Rules:

* Students must be enrolled on the child count date to be included
* Students must have active special education program participation on the count date
* Race determination follows federal reporting guidelines with Hispanic/Latino ethnicity taking precedence
* Primary disability must be identified for special education students

#### Result Usage:

Federal reporting of special education student counts, funding allocations, and compliance monitoring

#### Execution Frequency:

Annual, typically after the child count date (appears to be in October)

#### Critical Periods:

* Federal reporting deadlines for IDEA Child Count data

### Parameters

| Parameter   | Data Type | Purpose                                                         | Required |
| ----------- | --------- | --------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which to process child count data | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment data including demographics and enrollment dates

**Columns:**

| Name                   | Data Type | Business Purpose                                    |
| ---------------------- | --------- | --------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Unique identifier for students within the state     |
| SchoolYear             | SMALLINT  | Identifies the school year of the enrollment record |

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Contains special education program participation data

**Columns:**

| Name                          | Data Type | Business Purpose                                |
| ----------------------------- | --------- | ----------------------------------------------- |
| StudentIdentifierState        | VARCHAR   | Unique identifier for students within the state |
| ProgramParticipationBeginDate | DATE      | Start date of special education services        |

#### Staging.IdeaDisabilityType

**Business Purpose:** Contains disability classification data for special education students

**Columns:**

| Name                   | Data Type | Business Purpose                                      |
| ---------------------- | --------- | ----------------------------------------------------- |
| IdeaDisabilityTypeCode | VARCHAR   | Code representing the student's disability category   |
| IsPrimaryDisability    | BIT       | Indicates if this is the student's primary disability |

#### Staging.PersonStatus

**Business Purpose:** Contains various student status indicators including English Learner status

**Columns:**

| Name                            | Data Type      | Business Purpose                           |
| ------------------------------- | -------------- | ------------------------------------------ |
| EnglishLearnerStatus            | VARCHAR or INT | Indicates if student is an English Learner |
| EnglishLearner\_StatusStartDate | DATE           | Start date of English Learner status       |

#### App.ToggleQuestions

**Business Purpose:** Contains configuration questions for the application

**Columns:**

| Name               | Data Type | Business Purpose                                 |
| ------------------ | --------- | ------------------------------------------------ |
| EmapsQuestionAbbrv | VARCHAR   | Abbreviation code for the configuration question |

#### App.ToggleResponses

**Business Purpose:** Contains responses to configuration questions

**Columns:**

| Name          | Data Type | Business Purpose                    |
| ------------- | --------- | ----------------------------------- |
| ResponseValue | VARCHAR   | Value of the configuration response |

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

#### #vwIdeaStatuses

**Purpose:** Caches IDEA status dimension data for the specified school year

**Columns:**

| Name                                   | Data Type | Purpose/Calculation   |
| -------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimIdeaStatuses | Various   | Direct copy from view |

#### #vwUnduplicatedRaceMap

**Purpose:** Caches unduplicated race mapping data for the specified school year

**Columns:**

| Name                                       | Data Type | Purpose/Calculation   |
| ------------------------------------------ | --------- | --------------------- |
| All columns from RDS.vwUnduplicatedRaceMap | Various   | Direct copy from view |

#### #vwEnglishLearnerStatuses

**Purpose:** Caches English Learner status dimension data for the specified school year

**Columns:**

| Name                                             | Data Type | Purpose/Calculation   |
| ------------------------------------------------ | --------- | --------------------- |
| All columns from RDS.vwDimEnglishLearnerStatuses | Various   | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage for fact records before final insert

**Columns:**

| Name                  | Data Type | Purpose/Calculation                      |
| --------------------- | --------- | ---------------------------------------- |
| StagingId             | int       | Direct from staging table ID             |
| SchoolYearId          | int       | Lookup from DimSchoolYears               |
| Various dimension IDs | int       | Lookups from dimension tables            |
| StudentCount          | int       | Hard-coded as 1 (one student per record) |

### Potential Improvements

#### Performance

**Description:** Add explicit transaction management to ensure atomicity

**Benefits:** Better error recovery and data consistency

**Priority:** Medium

#### Performance

**Description:** Add batch processing for large datasets

**Benefits:** Reduced memory usage and transaction log growth

**Priority:** Medium

#### Code Quality

**Description:** Add more detailed logging throughout the process

**Benefits:** Better troubleshooting and monitoring capabilities

**Priority:** Medium

#### Functionality

**Description:** Add parameter validation

**Benefits:** Prevents processing with invalid parameters

**Priority:** Low

### Execution Steps

#### Step 1: Initialize and set up environment

**Input Data:** None

**Transformations:** None

SET NOCOUNT ON; Drop temp tables if they exist

#### Step 2: Set variables for execution

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create and populate temporary tables

**Input Data:** Data from RDS views

**Transformations:** None, direct copy

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Delete existing fact records

**Input Data:** None

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 5: Create and populate #Facts temp table

**Input Data:** Data from staging tables and dimension lookups

**Transformations:** Multiple joins and lookups

INSERT INTO #Facts SELECT... FROM Staging.K12Enrollment ske JOIN... WHERE...

#### Step 6: Insert data into fact table

**Input Data:** Data from #Facts temp table

**Transformations:** None, direct copy

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 7: Rebuild indexes

**Input Data:** None

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

#### Step 8: Error handling

**Input Data:** Error information

**Transformations:** None

INSERT INTO Staging.ValidationErrors VALUES (..., ERROR\_MESSAGE(), ...)
