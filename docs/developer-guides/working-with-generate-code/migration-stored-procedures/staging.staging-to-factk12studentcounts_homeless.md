# Staging.Staging-to-FactK12StudentCounts\_Homeless

### Overview & Purpose

This stored procedure migrates homeless student data from staging tables to the RDS.FactK12StudentCounts fact table. It specifically processes files 118 and 194, focusing on homeless student counts for a specified school year.

#### Main Functions:

*   **Data Migration**

    Transfers homeless student data from staging tables to the fact table while applying business rules and transformations

#### Key Calculations:

*   **Data Migration: Calculate student age based on birthdate and school year start date**

    Formula: `RDS.Get_Age(ske.Birthdate, @SYStartDate)`

    Business Significance: Ensures accurate age reporting for homeless students

    Example: If birthdate is 2010-01-15 and school year start is 2022-07-01, age would be 12

#### Data Transformations:

* Joins multiple staging tables to collect comprehensive homeless student information
* Maps staging table values to dimension table IDs
* Filters for students with HomelessnessStatus = 1
* Ensures date ranges align between enrollment periods and homeless status periods

#### Expected Output:

Populated RDS.FactK12StudentCounts table with homeless student records for the specified school year, with each record containing dimensional attributes like demographics, school information, and program participation details

### Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal and state reporting of homeless student statistics and to support educational program planning for homeless students

#### Business Rules:

* Only students with HomelessnessStatus = 1 are included
* Homeless status must be active during the student's enrollment period
* Each student record is associated with multiple dimension attributes including demographics, school information, and program participation

#### Result Usage:

The migrated data is used for federal reporting requirements, analysis of homeless student populations, and program planning for homeless student services

#### Execution Frequency:

Likely annual or semi-annual, based on school year reporting cycles

#### Critical Periods:

* End of school year reporting periods
* Federal and state education data submission deadlines

### Parameters

| Parameter   | Data Type | Purpose                                                                      | Required |
| ----------- | --------- | ---------------------------------------------------------------------------- | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which homeless student data should be migrated | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains student enrollment information including demographic data and enrollment dates

**Columns:**

| Name                           | Data Type | Business Purpose                            |
| ------------------------------ | --------- | ------------------------------------------- |
| id                             | int       | Unique identifier for the enrollment record |
| StudentIdentifierState         | varchar   | State-assigned student identifier           |
| SchoolYear                     | smallint  | Indicates the school year of the enrollment |
| LeaIdentifierSeaAccountability | varchar   | Identifier for the Local Education Agency   |
| SchoolIdentifierSea            | varchar   | Identifier for the school                   |
| EnrollmentEntryDate            | date      | Date when student enrolled                  |
| EnrollmentExitDate             | date      | Date when student exited enrollment         |
| GradeLevel                     | varchar   | Student's grade level                       |
| Birthdate                      | date      | Student's date of birth                     |
| Sex                            | varchar   | Student's sex/gender                        |
| FirstName                      | varchar   | Student's first name                        |
| MiddleName                     | varchar   | Student's middle name                       |
| LastOrSurname                  | varchar   | Student's last name                         |
| HispanicLatinoEthnicity        | bit       | Indicates if student is Hispanic/Latino     |

#### Staging.PersonStatus

**Business Purpose:** Contains various status indicators for students including homeless status

**Columns:**

| Name                                  | Data Type | Business Purpose                                 |
| ------------------------------------- | --------- | ------------------------------------------------ |
| StudentIdentifierState                | varchar   | State-assigned student identifier                |
| LeaIdentifierSeaAccountability        | varchar   | Identifier for the Local Education Agency        |
| SchoolIdentifierSea                   | varchar   | Identifier for the school                        |
| HomelessnessStatus                    | int       | Indicates if student is homeless                 |
| Homelessness\_StatusStartDate         | date      | Date when homeless status began                  |
| Homelessness\_StatusEndDate           | date      | Date when homeless status ended                  |
| HomelessUnaccompaniedYouth            | int       | Indicates if homeless student is unaccompanied   |
| HomelessServicedIndicator             | int       | Indicates if homeless student received services  |
| HomelessNightTimeResidence            | varchar   | Type of nighttime residence for homeless student |
| HomelessNightTimeResidence\_StartDate | date      | Date when nighttime residence status began       |
| EnglishLearnerStatus                  | int       | Indicates English Learner status                 |
| EnglishLearner\_StatusStartDate       | date      | Date when English Learner status began           |
| EnglishLearner\_StatusEndDate         | date      | Date when English Learner status ended           |
| MigrantStatus                         | int       | Indicates Migrant status                         |
| Migrant\_StatusStartDate              | date      | Date when Migrant status began                   |
| Migrant\_StatusEndDate                | date      | Date when Migrant status ended                   |

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Contains information about student participation in special education programs

**Columns:**

| Name                                        | Data Type | Business Purpose                                          |
| ------------------------------------------- | --------- | --------------------------------------------------------- |
| StudentIdentifierState                      | varchar   | State-assigned student identifier                         |
| LeaIdentifierSeaAccountability              | varchar   | Identifier for the Local Education Agency                 |
| SchoolIdentifierSea                         | varchar   | Identifier for the school                                 |
| ProgramParticipationBeginDate               | date      | Date when special education program participation began   |
| ProgramParticipationEndDate                 | date      | Date when special education program participation ended   |
| IDEAIndicator                               | bit       | Indicates if student receives services under IDEA         |
| IDEAEducationalEnvironmentForEarlyChildhood | varchar   | Educational environment for early childhood IDEA students |
| IDEAEducationalEnvironmentForSchoolAge      | varchar   | Educational environment for school-age IDEA students      |

#### Staging.IdeaDisabilityType

**Business Purpose:** Contains information about student disability types under IDEA

**Columns:**

| Name                           | Data Type | Business Purpose                                   |
| ------------------------------ | --------- | -------------------------------------------------- |
| SchoolYear                     | smallint  | Indicates the school year of the disability record |
| StudentIdentifierState         | varchar   | State-assigned student identifier                  |
| LeaIdentifierSeaAccountability | varchar   | Identifier for the Local Education Agency          |
| SchoolIdentifierSea            | varchar   | Identifier for the school                          |
| IdeaDisabilityTypeCode         | varchar   | Code indicating type of disability under IDEA      |
| IsPrimaryDisability            | bit       | Indicates if this is the primary disability        |
| RecordStartDateTime            | datetime  | Date when the disability record became active      |
| RecordEndDateTime              | datetime  | Date when the disability record became inactive    |

#### Staging.vwUnduplicatedRaceMap

**Business Purpose:** View that provides unduplicated race information for students

**Columns:**

| Name                           | Data Type | Business Purpose                             |
| ------------------------------ | --------- | -------------------------------------------- |
| SchoolYear                     | smallint  | Indicates the school year of the race record |
| StudentIdentifierState         | varchar   | State-assigned student identifier            |
| LeaIdentifierSeaAccountability | varchar   | Identifier for the Local Education Agency    |
| SchoolIdentifierSea            | varchar   | Identifier for the school                    |
| RaceMap                        | varchar   | Standardized race code for the student       |

### Temporary Tables

#### #vwRaces

**Purpose:** Temporary copy of RDS.vwDimRaces for the specified school year

**Columns:**

| Name                            | Data Type | Purpose/Calculation          |
| ------------------------------- | --------- | ---------------------------- |
| All columns from RDS.vwDimRaces | Various   | Direct copy from source view |

#### #vwMigrantStatuses

**Purpose:** Temporary copy of RDS.vwDimMigrantStatuses for the specified school year

**Columns:**

| Name                                      | Data Type | Purpose/Calculation          |
| ----------------------------------------- | --------- | ---------------------------- |
| All columns from RDS.vwDimMigrantStatuses | Various   | Direct copy from source view |

#### #vwGradeLevels

**Purpose:** Temporary copy of RDS.vwDimGradeLevels for the specified school year

**Columns:**

| Name                                  | Data Type | Purpose/Calculation          |
| ------------------------------------- | --------- | ---------------------------- |
| All columns from RDS.vwDimGradeLevels | Various   | Direct copy from source view |

#### #vwIdeaStatuses

**Purpose:** Temporary copy of RDS.vwDimIdeaStatuses for the specified school year

**Columns:**

| Name                                   | Data Type | Purpose/Calculation          |
| -------------------------------------- | --------- | ---------------------------- |
| All columns from RDS.vwDimIdeaStatuses | Various   | Direct copy from source view |

#### #tempELStatus

**Purpose:** Temporary table containing English Learner status information

**Columns:**

| Name                            | Data Type | Purpose/Calculation                   |
| ------------------------------- | --------- | ------------------------------------- |
| StudentIdentifierState          | varchar   | Direct copy from Staging.PersonStatus |
| LeaIdentifierSeaAccountability  | varchar   | Direct copy from Staging.PersonStatus |
| SchoolIdentifierSea             | varchar   | Direct copy from Staging.PersonStatus |
| EnglishLearnerStatus            | int       | Direct copy from Staging.PersonStatus |
| EnglishLearner\_StatusStartDate | date      | Direct copy from Staging.PersonStatus |
| EnglishLearner\_StatusEndDate   | date      | Direct copy from Staging.PersonStatus |

#### #tempMigrantStatus

**Purpose:** Temporary table containing Migrant status information

**Columns:**

| Name                           | Data Type | Purpose/Calculation                   |
| ------------------------------ | --------- | ------------------------------------- |
| StudentIdentifierState         | varchar   | Direct copy from Staging.PersonStatus |
| LeaIdentifierSeaAccountability | varchar   | Direct copy from Staging.PersonStatus |
| SchoolIdentifierSea            | varchar   | Direct copy from Staging.PersonStatus |
| MigrantStatus                  | int       | Direct copy from Staging.PersonStatus |
| Migrant\_StatusStartDate       | date      | Direct copy from Staging.PersonStatus |
| Migrant\_StatusEndDate         | date      | Direct copy from Staging.PersonStatus |

#### #Facts

**Purpose:** Temporary table to stage fact records before final insert

**Columns:**

| Name                                  | Data Type | Purpose/Calculation                         |
| ------------------------------------- | --------- | ------------------------------------------- |
| StagingId                             | int       | Direct copy from Staging.K12Enrollment.id   |
| SchoolYearId                          | int       | Lookup from RDS.DimSchoolYears              |
| FactTypeId                            | int       | Set to homeless fact type (16)              |
| GradeLevelId                          | int       | Lookup from #vwGradeLevels                  |
| AgeId                                 | int       | Lookup from RDS.DimAges                     |
| RaceId                                | int       | Lookup from #vwRaces                        |
| K12DemographicId                      | int       | Lookup from RDS.vwDimK12Demographics        |
| StudentCount                          | int       | Set to 1 for each record                    |
| SEAId                                 | int       | Lookup from RDS.DimSeas                     |
| IEUId                                 | int       | Set to -1 (not applicable)                  |
| LEAId                                 | int       | Lookup from RDS.DimLeas                     |
| K12SchoolId                           | int       | Lookup from RDS.DimK12Schools               |
| K12StudentId                          | int       | Lookup from RDS.DimPeople                   |
| IdeaStatusId                          | int       | Lookup from #vwIdeaStatuses                 |
| DisabilityStatusId                    | int       | Set to -1 (not applicable)                  |
| LanguageId                            | int       | Set to -1 (not applicable)                  |
| MigrantStatusId                       | int       | Lookup from #vwMigrantStatuses              |
| TitleIStatusId                        | int       | Set to -1 (not applicable)                  |
| TitleIIIStatusId                      | int       | Set to -1 (not applicable)                  |
| AttendanceId                          | int       | Set to -1 (not applicable)                  |
| CohortStatusId                        | int       | Set to -1 (not applicable)                  |
| NOrDStatusId                          | int       | Set to -1 (not applicable)                  |
| CTEStatusId                           | int       | Set to -1 (not applicable)                  |
| K12EnrollmentStatusId                 | int       | Set to -1 (not applicable)                  |
| EnglishLearnerStatusId                | int       | Lookup from RDS.vwDimEnglishLearnerStatuses |
| HomelessnessStatusId                  | int       | Lookup from RDS.vwDimHomelessnessStatuses   |
| EconomicallyDisadvantagedStatusId     | int       | Set to -1 (not applicable)                  |
| FosterCareStatusId                    | int       | Set to -1 (not applicable)                  |
| ImmigrantStatusId                     | int       | Set to -1 (not applicable)                  |
| PrimaryDisabilityTypeId               | int       | Lookup from RDS.vwDimIdeaDisabilityTypes    |
| SpecialEducationServicesExitDateId    | int       | Set to -1 (not applicable)                  |
| MigrantStudentQualifyingArrivalDateId | int       | Set to -1 (not applicable)                  |
| LastQualifyingMoveDateId              | int       | Set to -1 (not applicable)                  |

### Potential Improvements

#### Error Handling

**Description:** Implement more granular error handling for specific steps

**Benefits:** Better error diagnostics and recovery options

**Priority:** Medium

#### Performance

**Description:** Optimize the main INSERT query by breaking it into smaller steps

**Benefits:** Reduced memory usage and improved performance for large datasets

**Priority:** High

#### Transaction Management

**Description:** Add explicit transaction handling

**Benefits:** Ensures atomicity of the entire operation

**Priority:** Medium

#### Logging

**Description:** Add detailed logging of operation progress and counts

**Benefits:** Better monitoring and troubleshooting

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize environment and declare variables

**Input Data:** None

**Transformations:** None

SET NOCOUNT ON; IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Retrieve school year information

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Determine school year date range

**Input Data:** @SchoolYear parameter

**Transformations:** None

SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear); SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)

#### Step 4: Create and populate temporary dimension tables

**Input Data:** RDS dimension views

**Transformations:** Filter by school year

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 5: Create indexes on temporary dimension tables

**Input Data:** Temporary dimension tables

**Transformations:** None

CREATE CLUSTERED INDEX ix\_tempvwGradeLevels ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap)

#### Step 6: Extract English Learner status data

**Input Data:** Staging.PersonStatus

**Transformations:** Filter relevant columns

SELECT DISTINCT StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EnglishLearnerStatus, EnglishLearner\_StatusStartDate, EnglishLearner\_StatusEndDate INTO #tempELStatus FROM Staging.PersonStatus

#### Step 7: Create index on English Learner status temp table

**Input Data:** #tempELStatus

**Transformations:** None

CREATE INDEX IX\_tempELStatus ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner\_StatusStartDate, EnglishLearner\_StatusEndDate)

#### Step 8: Extract Migrant status data

**Input Data:** Staging.PersonStatus

**Transformations:** Filter relevant columns

SELECT DISTINCT StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, MigrantStatus, Migrant\_StatusStartDate, Migrant\_StatusEndDate INTO #tempMigrantStatus FROM Staging.PersonStatus

#### Step 9: Create index on Migrant status temp table

**Input Data:** #tempMigrantStatus

**Transformations:** None

CREATE INDEX IX\_tempMigrantStatus ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant\_StatusStartDate, Migrant\_StatusEndDate)

#### Step 10: Determine fact type ID

**Input Data:** rds.DimFactTypes

**Transformations:** None

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'homeless'

#### Step 11: Delete existing fact records

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 12: Create temporary facts table

**Input Data:** None

**Transformations:** None

CREATE TABLE #Facts (...)

#### Step 13: Populate temporary facts table

**Input Data:** Multiple staging and dimension tables

**Transformations:** Complex joins and mappings

INSERT INTO #Facts SELECT DISTINCT ske.id StagingId, ... FROM Staging.K12Enrollment ske JOIN Staging.PersonStatus hmStatus ON ... WHERE hmStatus.HomelessnessStatus = 1 ...

#### Step 14: Insert facts into destination table

**Input Data:** #Facts

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 15: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
