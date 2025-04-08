# Staging-to-FactK12StudentDisciplines

## Staging.Staging-to-FactK12StudentDisciplines

***

## Overview & Purpose

This stored procedure migrates student discipline data from staging tables to the RDS.FactK12StudentDisciplines fact table. It processes discipline-related data for a specific school year, joining multiple staging tables to gather comprehensive information about student disciplinary actions, including demographic data, school information, and specific discipline details.

### Main Functions:

* **Data Migration**\
  Transfer discipline data from staging tables to the fact table while performing necessary transformations and lookups

### Key Calculations:

* **Data Migration: Calculate student age at the time of the child count date**
  * Formula: `Age calculation using RDS.Get_Age(ske.Birthdate, @ChildCountDate)`
  * Business Significance: Ensures accurate age reporting for disciplinary incidents
  * Example: If birthdate is 2005-05-15 and child count date is 2022-10-01, age would be 17
* **Data Migration: Track the length of disciplinary actions**
  * Formula: `DurationOfDisciplinaryAction`
  * Business Significance: Allows analysis of discipline severity and impact on student education time
  * Example: 5.0 days of suspension

### Data Transformations:

* Converting date values to appropriate date IDs for the dimensional model
* Resolving multiple race records to a single race value using the vwUnduplicatedRaceMap view
* Mapping staging table codes to dimension table IDs through various view lookups
* Determining IDEA status based on program participation dates
* Determining English Learner status based on status dates

### Expected Output:

Populated RDS.FactK12StudentDisciplines table with discipline records for the specified school year, with all dimension keys properly resolved

***

## Business Context

**System:** K-12 Education Data Reporting System

**Necessity:** Required for federal and state reporting of student discipline incidents and actions

### Business Rules:

* Discipline records must be associated with active student enrollment periods
* IDEA status is determined based on program participation dates that overlap with the discipline incident
* English Learner status is determined based on status dates that overlap with the discipline incident
* Race is determined using a hierarchy: Hispanic/Latino ethnicity takes precedence, followed by multiple race determination

### Result Usage:

The populated fact table is used for regulatory reporting, analysis of discipline patterns, and monitoring of equity in disciplinary actions across demographic groups

### Execution Frequency:

Annually or as needed when discipline data is updated

### Critical Periods:

* End of school year reporting periods
* Federal and state education data submission deadlines

***

## Parameters

\| @SchoolYear | SMALLINT | Specifies the school year for which discipline data should be migrated | True |

***

## Source Tables

### Staging.Discipline

**Business Purpose:** Stores discipline incident and action information from source systems

#### Columns:

\| Id | int | Primary key for the staging table |

\| StudentIdentifierState | nvarchar | Unique identifier for the student within the state |

\| DisciplinaryActionStartDate | date | Date when disciplinary action began |

### Staging.K12Enrollment

**Business Purpose:** Stores student enrollment information

#### Columns:

\| StudentIdentifierState | nvarchar | Unique identifier for the student within the state |

\| EnrollmentEntryDate | date | Date when student enrolled |

\| EnrollmentExitDate | date | Date when student exited enrollment |

### Staging.PersonStatus

**Business Purpose:** Stores various status indicators for students

#### Columns:

\| StudentIdentifierState | nvarchar | Unique identifier for the student within the state |

\| EnglishLearnerStatus | bit | Indicates if student is an English Learner |

\| EnglishLearner\_StatusStartDate | date | Date when English Learner status began |

### Staging.ProgramParticipationSpecialEducation

**Business Purpose:** Stores information about student participation in special education programs

#### Columns:

\| StudentIdentifierState | nvarchar | Unique identifier for the student within the state |

\| IdeaIndicator | bit | Indicates if student is served under IDEA |

\| ProgramParticipationBeginDate | date | Date when special education program participation began |

### Staging.IdeaDisabilityType

**Business Purpose:** Stores information about student disability types under IDEA

#### Columns:

\| StudentIdentifierState | nvarchar | Unique identifier for the student within the state |

\| IdeaDisabilityTypeCode | nvarchar | Code indicating the type of disability |

\| IsPrimaryDisability | bit | Indicates if this is the primary disability |

***

## Temporary Tables

### #vwGradeLevels

**Purpose:** Temporary storage of grade level dimension data for the specific school year

#### Columns:

\| GradeLevelTypeDescription | nvarchar | Copied from source view |

\| GradeLevelMap | nvarchar | Copied from source view |

### #vwRaces

**Purpose:** Temporary storage of race dimension data for the specific school year

#### Columns:

\| RaceMap | nvarchar | Copied from source view |

### #tempELStatus

**Purpose:** Temporary storage of English Learner status data

#### Columns:

\| StudentIdentifierState | nvarchar | Copied from source table |

\| EnglishLearnerStatus | bit | Copied from source table |

\| EnglishLearner\_StatusStartDate | date | Copied from source table |

### #tempIdeaStatus

**Purpose:** Temporary storage of IDEA status data

#### Columns:

\| StudentIdentifierState | nvarchar | Copied from source table |

\| IdeaIndicator | bit | Copied from source table |

\| ProgramParticipationBeginDate | date | Copied from source table |

### #Facts

**Purpose:** Temporary storage of fact records before final insert

#### Columns:

\| StagingId | int | Copied from Staging.Discipline.Id |

\| SchoolYearId | int | Looked up from RDS.DimSchoolYears |

\| K12DemographicId | int | Looked up from RDS.vwDimK12Demographics |

\| DisciplineCount | int | Set to 1 for each record |

***

## Potential Improvements

### Error Handling

* **Description:** Enhance error handling to provide more specific error messages and handle specific error conditions
* **Benefits:** Better troubleshooting and more robust execution
* **Priority:** Medium

### Transaction Management

* **Description:** Add explicit transaction handling with savepoints
* **Benefits:** Better data integrity and ability to recover from partial failures
* **Priority:** High

### Performance

* **Description:** Optimize the large join query by breaking it into smaller steps
* **Benefits:** Improved performance and reduced memory usage
* **Priority:** Medium

### Code Clarity

* **Description:** Add more comments and documentation within the code
* **Benefits:** Easier maintenance and knowledge transfer
* **Priority:** Low

***

## Execution Steps

### Step 1: Initialize and set up environment

**Input Data:** None

**Transformations:** None

```sql
IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
```

### Step 2: Set variables for the school year

**Input Data:** @SchoolYear parameter

**Transformations:** Convert school year to date ranges and IDs

```sql
SELECT @SchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear
```

### Step 3: Create and populate temporary tables

**Input Data:** Data from RDS views filtered by school year

**Transformations:** Copy data to temp tables

```sql
SELECT * INTO #vwGradeLevels FROM RDS.vwDimGradeLevels WHERE SchoolYear = @SchoolYear
```

### Step 4: Delete existing fact records for the school year

**Input Data:** SchoolYearId

**Transformations:** None

```sql
DELETE RDS.FactK12StudentDisciplines WHERE SchoolYearId = @SchoolYearId
```

### Step 5: Create and populate #Facts temp table

**Input Data:** Data from staging tables and dimension lookups

**Transformations:** Join multiple tables, map codes to dimension IDs

```sql
INSERT INTO #Facts SELECT sd.Id StagingId, rda.DimAgeId AgeId, ...
```

### Step 6: Insert data into fact table

**Input Data:** #Facts temp table

**Transformations:** None

```sql
INSERT INTO RDS.FactK12StudentDisciplines (...) SELECT ... FROM #Facts
```

### Step 7: Rebuild indexes

**Input Data:** None

**Transformations:** None

```sql
ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
```

***

## Security Considerations

The procedure does not implement any specific security measures beyond standard SQL Server security. It processes potentially sensitive student data including discipline records and special education status, which may be subject to FERPA and other privacy regulations.

***

## Performance Benchmarks

Performance will vary based on the volume of discipline data for the school year. The procedure uses temporary tables with appropriate indexes to optimize joins. The large join query in the #Facts population step is likely the most resource-intensive part of the procedure.

***

## Known Limitations

* The procedure does not handle partial updates - it always deletes and reloads all data for a school year
* There is no validation of input data quality before processing
* The procedure rebuilds indexes on FactK12StudentCounts instead of FactK12StudentDisciplines (possible error)
* CTE status update section is commented out but still present in the code
