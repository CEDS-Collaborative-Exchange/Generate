# Staging.Staging-to-FactK12StudentCourseSections

### Overview & Purpose

This stored procedure populates the RDS.FactK12StudentCourseSections fact table and the RDS.BridgeK12StudentCourseSectionRaces bridge table with data from staging tables. It transfers K-12 student course section data from staging tables to the data warehouse, creating relationships between students, courses, schools, and various educational entities.

#### Main Functions:

*   **Populate FactK12StudentCourseSections**

    Transfers student course section data from staging tables to the fact table with appropriate dimension keys
*   **Populate BridgeK12StudentCourseSectionRaces**

    Creates relationships between student course sections and race information

#### Key Calculations:

*   **Populate FactK12StudentCourseSections: Sets a count of 1 for each student course section record**

    Formula: `StudentCourseSectionCount = 1`

    Business Significance: Enables counting of student course sections for reporting and analysis

    Example: Each row in the fact table will have a StudentCourseSectionCount of 1

#### Data Transformations:

* Mapping staging table identifiers to dimension table surrogate keys
* Handling NULL values with ISNULL functions to default to -1 for dimension keys
* Joining multiple staging tables to create comprehensive fact records
* Converting VARCHAR data types for proper joining conditions

#### Expected Output:

Populated RDS.FactK12StudentCourseSections fact table and RDS.BridgeK12StudentCourseSectionRaces bridge table with transformed data from staging tables

### Business Context

**System:** K-12 Education Data Warehouse

**Necessity:** Enables analysis and reporting of student course section data across educational institutions

#### Business Rules:

* Student records are linked to multiple LEA (Local Education Agency) types including accountability, attendance, funding, graduation, and IEP
* Race and ethnicity data is handled separately through a bridge table to support multiple race values per student
* Hispanic/Latino ethnicity is treated as a race category
* Default dimension key value of -1 is used for missing dimension references

#### Result Usage:

Reporting and analysis of student course enrollment patterns, demographic distribution in courses, and educational program participation

#### Execution Frequency:

Likely executed during regular ETL processes, possibly daily or weekly

#### Critical Periods:

* End of academic terms
* State and federal reporting deadlines

### Parameters

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores student enrollment data from source systems

**Columns:**

| Name                   | Data Type | Business Purpose                                               |
| ---------------------- | --------- | -------------------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Unique identifier for students at the state level              |
| SchoolIdentifierSea    | VARCHAR   | Identifies the school within the state education agency system |

#### Staging.K12StudentCourseSection

**Business Purpose:** Stores information about student course section enrollment

**Columns:**

| Name                   | Data Type | Business Purpose                                  |
| ---------------------- | --------- | ------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Unique identifier for students at the state level |
| ScedCourseCode         | VARCHAR   | School Codes for the Exchange of Data course code |

#### Staging.K12PersonRace

**Business Purpose:** Stores race information for K12 students

**Columns:**

| Name                   | Data Type | Business Purpose                                  |
| ---------------------- | --------- | ------------------------------------------------- |
| StudentIdentifierState | VARCHAR   | Unique identifier for students at the state level |
| RaceType               | VARCHAR   | Identifies the race of the student                |

### Potential Improvements

#### Performance

**Description:** Move the index rebuild operation outside the transaction

**Benefits:** Reduces transaction duration and lock contention

**Priority:** Medium

#### Error Handling

**Description:** Add explicit error handling with TRY/CATCH blocks

**Benefits:** Better error reporting and handling of specific error conditions

**Priority:** Medium

#### Performance

**Description:** Consider batch processing for large datasets

**Benefits:** Reduced memory usage and transaction size

**Priority:** Low

### Execution Steps

#### Step 1: Disable all indexes on the fact table to improve insert performance

**Input Data:** None

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCourseSections DISABLE

#### Step 2: Begin transaction for data consistency

**Input Data:** None

**Transformations:** None

Begin Transaction

#### Step 3: Insert data into the fact table

**Input Data:** Data from staging tables joined with dimension tables

**Transformations:** Mapping staging identifiers to dimension keys, handling nulls with ISNULL

INSERT INTO rds.FactK12StudentCourseSections (...) SELECT ... FROM Staging.K12Enrollment ske JOIN Staging.K12StudentCourseSection sppse ...

#### Step 4: Insert data into the bridge table

**Input Data:** Data from fact table joined with staging and dimension tables

**Transformations:** Mapping race information to dimension keys

INSERT INTO RDS.BridgeK12StudentCourseSectionRaces (...) SELECT ... FROM RDS.FactK12StudentCourseSections rfksc ...

#### Step 5: Rebuild all indexes on the fact table

**Input Data:** None

**Transformations:** None

ALTER INDEX ALL ON RDS.FactK12StudentCourseSections REBUILD

#### Step 6: Commit the transaction

**Input Data:** None

**Transformations:** None

Commit Transaction
