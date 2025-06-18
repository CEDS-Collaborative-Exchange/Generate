# Staging.Staging-to-FactK12StudentCounts\_HSGradPSEnroll

### Overview & Purpose

This stored procedure migrates High School Graduate Post-Secondary Enrollment Data from staging tables to the RDS.FactK12StudentCounts table. It processes data for a specific school year provided as a parameter, focusing on high school graduates who enrolled in post-secondary education.

#### Main Functions:

*   **Data Migration**

    Transfers high school graduate post-secondary enrollment data from staging tables to the fact table
*   **Dimension Mapping**

    Maps staging data to appropriate dimension IDs for the fact table

#### Key Calculations:

*   **Data Migration: Sets the count value for each student record**

    Formula: `StudentCount = 1`

    Business Significance: Enables counting of students for reporting and analysis

    Example: Each row in the fact table represents one student with StudentCount = 1

#### Data Transformations:

* Mapping student demographic data to dimension tables
* Joining K12 enrollment data with post-secondary enrollment data
* Resolving race information through the vwUnduplicatedRaceMap view
* Mapping IDEA status, economically disadvantaged status, and English learner status to dimension IDs

#### Expected Output:

Populated RDS.FactK12StudentCounts table with high school graduate post-secondary enrollment data for the specified school year

### Business Context

**System:** K-12 Education Data Warehouse

**Necessity:** Track and analyze high school graduates' enrollment in post-secondary education

#### Business Rules:

* Each student is counted once (StudentCount = 1)
* Students are identified by state ID, name, and birthdate
* Race determination follows a specific hierarchy with Hispanic/Latino ethnicity taking precedence
* IDEA status, economically disadvantaged status, and English learner status are determined based on program participation dates

#### Result Usage:

Reporting and analysis of high school graduate outcomes and post-secondary enrollment patterns

#### Execution Frequency:

Likely annual or semi-annual, based on school year data processing cycles

#### Critical Periods:

* End of school year
* Beginning of new school year

### Parameters

| Parameter   | Data Type | Purpose                                                      | Required |
| ----------- | --------- | ------------------------------------------------------------ | -------- |
| @SchoolYear | SMALLINT  | Specifies the school year for which data should be processed | True     |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores K-12 student enrollment data

**Columns:**

| Name                           | Data Type | Business Purpose                                |
| ------------------------------ | --------- | ----------------------------------------------- |
| id                             | int       | Unique identifier for the enrollment record     |
| SchoolYear                     | smallint  | Identifies the school year of the enrollment    |
| StudentIdentifierState         | varchar   | State-assigned student identifier               |
| LeaIdentifierSeaAccountability | varchar   | Identifier for the Local Education Agency (LEA) |
| SchoolIdentifierSea            | varchar   | Identifier for the school                       |
| EnrollmentEntryDate            | date      | Date when student enrolled                      |
| EnrollmentExitDate             | date      | Date when student exited enrollment             |
| GradeLevel                     | varchar   | Student's grade level                           |
| HispanicLatinoEthnicity        | bit       | Indicates if student is Hispanic/Latino         |
| FirstName                      | varchar   | Student's first name                            |
| MiddleName                     | varchar   | Student's middle name                           |
| LastOrSurname                  | varchar   | Student's last name                             |
| Birthdate                      | date      | Student's date of birth                         |

#### Staging.PsStudentEnrollment

**Business Purpose:** Stores post-secondary enrollment data for students

**Columns:**

| Name                   | Data Type | Business Purpose                  |
| ---------------------- | --------- | --------------------------------- |
| StudentIdentifierState | varchar   | State-assigned student identifier |
| LastOrSurname          | varchar   | Student's last name               |
| BirthDate              | date      | Student's date of birth           |

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Stores special education program participation data

**Columns:**

| Name                           | Data Type | Business Purpose                                        |
| ------------------------------ | --------- | ------------------------------------------------------- |
| StudentIdentifierState         | varchar   | State-assigned student identifier                       |
| LeaIdentifierSeaAccountability | varchar   | Identifier for the Local Education Agency (LEA)         |
| SchoolIdentifierSea            | varchar   | Identifier for the school                               |
| ProgramParticipationBeginDate  | date      | Date when special education program participation began |

#### Staging.PersonStatus

**Business Purpose:** Stores various status indicators for students

**Columns:**

| Name                                  | Data Type | Business Purpose                                   |
| ------------------------------------- | --------- | -------------------------------------------------- |
| StudentIdentifierState                | varchar   | State-assigned student identifier                  |
| LeaIdentifierSeaAccountability        | varchar   | Identifier for the Local Education Agency (LEA)    |
| SchoolIdentifierSea                   | varchar   | Identifier for the school                          |
| EconomicDisadvantage\_StatusStartDate | date      | Date when economic disadvantage status began       |
| EconomicDisadvantageStatus            | varchar   | Indicates if student is economically disadvantaged |
| EnglishLearner\_StatusStartDate       | date      | Date when English learner status began             |
| EnglishLearnerStatus                  | varchar   | Indicates if student is an English learner         |

#### RDS.DimSchoolYears

**Business Purpose:** Dimension table for school years

**Columns:**

| Name            | Data Type | Business Purpose                             |
| --------------- | --------- | -------------------------------------------- |
| DimSchoolYearId | int       | Primary key for school year dimension        |
| SchoolYear      | smallint  | School year value (e.g., 2022 for 2021-2022) |

#### RDS.DimLeas

**Business Purpose:** Dimension table for Local Education Agencies

**Columns:**

| Name                | Data Type | Business Purpose                |
| ------------------- | --------- | ------------------------------- |
| DimLeaID            | int       | Primary key for LEA dimension   |
| LeaIdentifierSea    | varchar   | State-assigned LEA identifier   |
| RecordStartDateTime | datetime  | Start of record validity period |
| RecordEndDateTime   | datetime  | End of record validity period   |

#### RDS.DimK12Schools

**Business Purpose:** Dimension table for K-12 schools

**Columns:**

| Name                | Data Type | Business Purpose                 |
| ------------------- | --------- | -------------------------------- |
| DimK12SchoolId      | int       | Primary key for school dimension |
| SchoolIdentifierSea | varchar   | State-assigned school identifier |
| RecordStartDateTime | datetime  | Start of record validity period  |
| RecordEndDateTime   | datetime  | End of record validity period    |

#### RDS.DimSeas

**Business Purpose:** Dimension table for State Education Agencies

**Columns:**

| Name                | Data Type | Business Purpose                |
| ------------------- | --------- | ------------------------------- |
| DimSeaId            | int       | Primary key for SEA dimension   |
| RecordStartDateTime | datetime  | Start of record validity period |
| RecordEndDateTime   | datetime  | End of record validity period   |

#### RDS.vwUnduplicatedRaceMap

**Business Purpose:** View that provides unduplicated race information for students

**Columns:**

| Name                           | Data Type | Business Purpose                  |
| ------------------------------ | --------- | --------------------------------- |
| SchoolYear                     | smallint  | School year for the race data     |
| StudentIdentifierState         | varchar   | State-assigned student identifier |
| SchoolIdentifierSea            | varchar   | State-assigned school identifier  |
| LeaIdentifierSeaAccountability | varchar   | State-assigned LEA identifier     |
| RaceMap                        | varchar   | Standardized race category        |

#### RDS.vwDimIdeaStatuses

**Business Purpose:** View that provides IDEA status dimension data

**Columns:**

| Name                                            | Data Type | Business Purpose                                               |
| ----------------------------------------------- | --------- | -------------------------------------------------------------- |
| SchoolYear                                      | smallint  | School year for the IDEA status                                |
| DimIdeaStatusId                                 | int       | Primary key for IDEA status dimension                          |
| IdeaIndicatorCode                               | varchar   | Indicates if student is covered under IDEA                     |
| IdeaEducationalEnvironmentForSchoolAgeCode      | varchar   | Educational environment code for school-age IDEA students      |
| IdeaEducationalEnvironmentForEarlyChildhoodCode | varchar   | Educational environment code for early childhood IDEA students |
| SpecialEducationExitReasonCode                  | varchar   | Reason for exiting special education                           |

#### RDS.vwDimEnglishLearnerStatuses

**Business Purpose:** View that provides English learner status dimension data

**Columns:**

| Name                            | Data Type | Business Purpose                                 |
| ------------------------------- | --------- | ------------------------------------------------ |
| SchoolYear                      | smallint  | School year for the English learner status       |
| DimEnglishLearnerStatusId       | int       | Primary key for English learner status dimension |
| EnglishLearnerStatusMap         | smallint  | Mapped value for English learner status          |
| PerkinsEnglishLearnerStatusCode | varchar   | Perkins-specific English learner status code     |

#### RDS.DimPeople

**Business Purpose:** Dimension table for people (students, staff, etc.)

**Columns:**

| Name                   | Data Type | Business Purpose                              |
| ---------------------- | --------- | --------------------------------------------- |
| DimPersonId            | int       | Primary key for person dimension              |
| StudentIdentifierState | varchar   | State-assigned student identifier             |
| IsActiveK12Student     | bit       | Indicates if person is an active K-12 student |
| FirstName              | varchar   | Person's first name                           |
| MiddleName             | varchar   | Person's middle name                          |
| LastOrSurname          | varchar   | Person's last name                            |
| BirthDate              | date      | Person's date of birth                        |
| RecordStartDateTime    | datetime  | Start of record validity period               |
| RecordEndDateTime      | datetime  | End of record validity period                 |

#### Staging.ValidationErrors

**Business Purpose:** Stores validation errors encountered during ETL processes

**Columns:**

| Name    | Data Type | Business Purpose                 |
| ------- | --------- | -------------------------------- |
| Unknown | Unknown   | Various error information fields |

### Temporary Tables

#### #vwGradeLevels

**Purpose:** Temporary copy of grade level dimension data for the specified school year

**Columns:**

| Name                                  | Data Type | Purpose/Calculation   |
| ------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimGradeLevels | Various   | Direct copy from view |
| SchoolYear                            | smallint  | Direct copy from view |
| DimGradeLevelId                       | int       | Direct copy from view |
| GradeLevelTypeDescription             | varchar   | Direct copy from view |
| GradeLevelMap                         | varchar   | Direct copy from view |

#### #vwRaces

**Purpose:** Temporary copy of race dimension data for the specified school year

**Columns:**

| Name                            | Data Type | Purpose/Calculation   |
| ------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimRaces | Various   | Direct copy from view |
| SchoolYear                      | smallint  | Direct copy from view |
| DimRaceId                       | int       | Direct copy from view |
| RaceMap                         | varchar   | Direct copy from view |
| RaceCode                        | varchar   | Direct copy from view |

#### #vwEconomicallyDisadvantagedStatuses

**Purpose:** Temporary copy of economically disadvantaged status dimension data for the specified school year

**Columns:**

| Name                                                        | Data Type | Purpose/Calculation   |
| ----------------------------------------------------------- | --------- | --------------------- |
| All columns from RDS.vwDimEconomicallyDisadvantagedStatuses | Various   | Direct copy from view |
| SchoolYear                                                  | smallint  | Direct copy from view |
| DimEconomicallyDisadvantagedStatusId                        | int       | Direct copy from view |
| EconomicDisadvantageStatusCode                              | varchar   | Direct copy from view |
| EligibilityStatusForSchoolFoodServiceProgramsCode           | varchar   | Direct copy from view |
| NationalSchoolLunchProgramDirectCertificationIndicatorCode  | varchar   | Direct copy from view |
| EconomicDisadvantageStatusMap                               | smallint  | Direct copy from view |

#### #Facts

**Purpose:** Temporary storage for fact records before insertion into the fact table

**Columns:**

| Name                                  | Data Type | Purpose/Calculation                                                |
| ------------------------------------- | --------- | ------------------------------------------------------------------ |
| StagingId                             | int       | Direct copy from Staging.K12Enrollment.id                          |
| SchoolYearId                          | int       | Lookup from RDS.DimSchoolYears                                     |
| FactTypeId                            | int       | Lookup from RDS.DimFactTypes where FactTypeCode = 'hsGradPSEnroll' |
| GradeLevelId                          | int       | Lookup from #vwGradeLevels                                         |
| AgeId                                 | int       | Set to -1 (not used)                                               |
| RaceId                                | int       | Lookup from #vwRaces based on Hispanic ethnicity or race map       |
| K12DemographicId                      | int       | Set to -1 (not used)                                               |
| StudentCount                          | int       | Set to 1                                                           |
| SEAId                                 | int       | Lookup from RDS.DimSeas                                            |
| IEUId                                 | int       | Set to -1 (not used)                                               |
| LEAId                                 | int       | Lookup from RDS.DimLeas                                            |
| K12SchoolId                           | int       | Lookup from RDS.DimK12Schools                                      |
| K12StudentId                          | int       | Lookup from RDS.DimPeople                                          |
| IdeaStatusId                          | int       | Lookup from RDS.vwDimIdeaStatuses                                  |
| DisabilityStatusId                    | int       | Set to -1 (not used)                                               |
| LanguageId                            | int       | Set to -1 (not used)                                               |
| MigrantStatusId                       | int       | Set to -1 (not used)                                               |
| TitleIStatusId                        | int       | Set to -1 (not used)                                               |
| TitleIIIStatusId                      | int       | Set to -1 (not used)                                               |
| AttendanceId                          | int       | Set to -1 (not used)                                               |
| CohortStatusId                        | int       | Set to -1 (not used)                                               |
| NOrDStatusId                          | int       | Set to -1 (not used)                                               |
| CTEStatusId                           | int       | Set to -1 (not used)                                               |
| K12EnrollmentStatusId                 | int       | Set to -1 (not used)                                               |
| EnglishLearnerStatusId                | int       | Lookup from RDS.vwDimEnglishLearnerStatuses                        |
| HomelessnessStatusId                  | int       | Set to -1 (not used)                                               |
| EconomicallyDisadvantagedStatusId     | int       | Lookup from #vwEconomicallyDisadvantagedStatuses                   |
| FosterCareStatusId                    | int       | Set to -1 (not used)                                               |
| ImmigrantStatusId                     | int       | Set to -1 (not used)                                               |
| PrimaryDisabilityTypeId               | int       | Set to -1 (not used)                                               |
| SpecialEducationServicesExitDateId    | int       | Set to -1 (not used)                                               |
| MigrantStudentQualifyingArrivalDateId | int       | Set to -1 (not used)                                               |
| LastQualifyingMoveDateId              | int       | Set to -1 (not used)                                               |

### Potential Improvements

#### Error Handling

**Description:** Enhance error handling with more specific error messages and handling for different error scenarios

**Benefits:** Better troubleshooting and error resolution

**Priority:** Medium

#### Performance

**Description:** Add more selective indexes to the temporary tables based on join patterns

**Benefits:** Improved query performance for complex joins

**Priority:** Medium

#### Code Structure

**Description:** Break down the large INSERT statement into smaller, more manageable components

**Benefits:** Improved readability and maintainability

**Priority:** Low

#### Documentation

**Description:** Add more inline comments explaining complex logic and business rules

**Benefits:** Better understanding for future maintainers

**Priority:** Low

### Execution Steps

#### Step 1: Initialize environment and drop temporary tables if they exist

**Input Data:** None

**Transformations:** None

IF OBJECT\_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces

#### Step 2: Declare and set variables for school year and date ranges

**Input Data:** @SchoolYear parameter

**Transformations:** None

SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

#### Step 3: Create and populate temporary dimension tables with indexes

**Input Data:** RDS dimension views

**Transformations:** Filter by school year

SELECT \* INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear

#### Step 4: Set the fact type ID

**Input Data:** RDS.DimFactTypes

**Transformations:** None

SELECT @FactTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = 'hsGradPSEnroll'

#### Step 5: Clear existing fact data for the school year and fact type

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

DELETE RDS.FactK12StudentCounts WHERE SchoolYearId = @SchoolYearId AND FactTypeId = @FactTypeId

#### Step 6: Create temporary facts table

**Input Data:** None

**Transformations:** None

CREATE TABLE #Facts (...)

#### Step 7: Populate temporary facts table with transformed data

**Input Data:** Staging tables and dimension tables

**Transformations:** Join staging data with dimensions, map values to dimension IDs

INSERT INTO #Facts SELECT DISTINCT ...

#### Step 8: Insert data from temporary facts table to fact table

**Input Data:** #Facts

**Transformations:** None

INSERT INTO RDS.FactK12StudentCounts (...) SELECT ... FROM #Facts

#### Step 9: Rebuild indexes on fact table

**Input Data:** RDS.FactK12StudentCounts

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
