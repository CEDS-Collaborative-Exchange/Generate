# Staging.Staging-to-FactK12StudentEnrollments

### Overview & Purpose

This stored procedure transfers K12 student enrollment data from staging tables to the fact table RDS.FactK12StudentEnrollments and related bridge tables. It processes student enrollment records, enriches them with dimensional data, and loads them into the data warehouse structure for reporting and analysis purposes.

#### Main Functions:

*   **Data Extraction and Transformation**

    Extract student enrollment data from staging tables, join with dimension tables to get dimension keys, and prepare data for loading into fact tables
*   **Fact Table Loading**

    Load transformed student enrollment data into the fact table
*   **Bridge Table Population**

    Populate bridge tables for many-to-many relationships like student races and disability types

#### Key Calculations:

*   **Data Extraction and Transformation: Handle NULL values throughout the procedure**

    Formula: `ISNULL(value, default)`

    Business Significance: Ensures data integrity by providing default values when source data is missing

    Example: ISNULL(ske.Sex, 'MISSING')
*   **Fact Table Loading: Set the student count measure to 1 for each enrollment record**

    Formula: `StudentCount = 1`

    Business Significance: Enables counting of students in reporting

    Example: 1 as \[StudentCount]

#### Data Transformations:

* Creating temporary tables with filtered data based on school years
* Joining staging data with dimension tables to get dimension keys
* Handling NULL values with ISNULL function
* Converting boolean values (0/1) to 'Yes'/'No' strings
* Mapping codes to dimension table IDs

#### Expected Output:

Populated fact table (RDS.FactK12StudentEnrollments) and bridge tables (RDS.BridgeK12StudentEnrollmentRaces, RDS.BridgeK12StudentEnrollmentIdeaDisabilityTypes, RDS.BridgeK12StudentEnrollmentPersonAddresses) with student enrollment data

### Business Context

**System:** K12 Education Data Warehouse

**Necessity:** To transform staging data into a dimensional model for reporting and analysis of student enrollments

#### Business Rules:

* Student enrollment records are linked to multiple dimensions including schools, LEAs, demographics, and program participations
* Students can have multiple race designations requiring a bridge table
* Students can have multiple disability types requiring a bridge table
* Default dimension key value of -1 is used when no match is found

#### Result Usage:

The fact and bridge tables are used for reporting and analysis of student enrollment data across various dimensions

#### Execution Frequency:

Likely executed after each data collection or data load

#### Critical Periods:

* End of school year reporting periods
* State and federal education reporting deadlines

### Parameters

| Parameter           | Data Type   | Purpose                                                   | Required |
| ------------------- | ----------- | --------------------------------------------------------- | -------- |
| @DataCollectionName | VARCHAR(60) | Filters the data processing to a specific data collection | False    |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores staged student enrollment data

**Columns:**

| Name       | Data Type | Business Purpose                             |
| ---------- | --------- | -------------------------------------------- |
| Id         | INT       | Primary key for the staging table            |
| SchoolYear | VARCHAR   | Identifies the school year of the enrollment |

#### Staging.PersonStatus

**Business Purpose:** Stores various status indicators for students

#### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Stores special education program participation data

#### Staging.IdeaDisabilityType

**Business Purpose:** Stores disability type information for students

#### Staging.ProgramParticipationCte

**Business Purpose:** Stores career and technical education program participation data

#### Staging.Migrant

**Business Purpose:** Stores migrant student information

#### Staging.ProgramParticipationTitleIII

**Business Purpose:** Stores Title III program participation data

#### Staging.Military

**Business Purpose:** Stores military connection information for students

#### Staging.K12PersonRace

**Business Purpose:** Stores race information for students

#### Staging.K12StudentAddress

**Business Purpose:** Stores address information for students

### Temporary Tables

#### #SchoolYears

**Purpose:** Stores distinct school years from the filtered enrollment data

**Columns:**

| Name       | Data Type | Purpose/Calculation                         |
| ---------- | --------- | ------------------------------------------- |
| SchoolYear | VARCHAR   | Direct selection from Staging.K12Enrollment |

#### #vwDimK12Demographics

**Purpose:** Temporary copy of demographics dimension view filtered by relevant school years

#### #Facts

**Purpose:** Temporary storage for fact data before insertion into the fact table

**Columns:**

| Name      | Data Type | Purpose/Calculation                            |
| --------- | --------- | ---------------------------------------------- |
| StagingId | INT       | Direct selection from Staging.K12Enrollment.Id |

#### #temp

**Purpose:** Temporary storage for race data before insertion into the bridge table

### Potential Improvements

#### Performance

**Description:** Add explicit transaction handling to ensure data consistency

**Benefits:** Ensures all data is committed or rolled back as a unit

**Priority:** Medium

#### Error Handling

**Description:** Add explicit error handling with TRY/CATCH blocks

**Benefits:** Better error reporting and recovery

**Priority:** High

#### Performance

**Description:** Optimize the multiple UPDATE statements on #Facts table

**Benefits:** Reduced execution time

**Priority:** Medium

#### Maintainability

**Description:** Add comments to explain complex logic and business rules

**Benefits:** Easier maintenance and knowledge transfer

**Priority:** Medium

### Execution Steps

#### Step 1: Create temporary table of distinct school years

**Input Data:** Staging.K12Enrollment filtered by @DataCollectionName

**Transformations:** SELECT DISTINCT SchoolYear

SELECT DISTINCT SchoolYear INTO #SchoolYears FROM Staging.K12Enrollment WHERE (@DataCollectionName IS NULL OR DataCollectionName = @DataCollectionName)

#### Step 2: Create temporary tables with filtered dimension views

**Input Data:** Various RDS dimension views joined with #SchoolYears

**Transformations:** Filter dimension views by relevant school years

SELECT v.\* INTO #vwDimK12Demographics FROM RDS.vwDimK12Demographics v JOIN #SchoolYears t on v.SchoolYear = t.SchoolYear

#### Step 3: Create and populate #Facts temporary table

**Input Data:** Staging.K12Enrollment and related staging tables

**Transformations:** Join with dimension tables to get dimension keys

INSERT INTO #Facts (...) SELECT DISTINCT ... FROM Staging.K12Enrollment ske ...

#### Step 4: Update missing dimension keys in #Facts

**Input Data:** #Facts table and dimension tables

**Transformations:** Update NULL dimension keys with valid values

UPDATE #Facts SET K12StudentId = p.DimPersonId FROM #Facts f JOIN Staging.K12Enrollment ske ON f.StagingId = ske.Id JOIN (...) p ON ske.StudentIdentifierState = p.K12StudentStudentIdentifierState AND p.RecNum = 1

#### Step 5: Insert data into fact table

**Input Data:** #Facts temporary table

**Transformations:** Convert NULL dimension keys to -1

INSERT INTO RDS.FactK12StudentEnrollments (...) SELECT ISNULL(\[SchoolYearId], -1), ..., 1 as \[StudentCount] FROM #Facts

#### Step 6: Populate bridge tables

**Input Data:** Fact table, dimension tables, and staging tables

**Transformations:** Join fact table with dimension and staging tables

Insert Into RDS.BridgeK12StudentEnrollmentRaces (\[FactK12StudentEnrollmentId], \[RaceId]) Select distinct t.FactK12StudentEnrollmentId, rdr.DimRaceId From #temp t join RDS.vwDimRaces rdr on t.SchoolYear=rdr.SchoolYear and ... = rdr.RaceMap
