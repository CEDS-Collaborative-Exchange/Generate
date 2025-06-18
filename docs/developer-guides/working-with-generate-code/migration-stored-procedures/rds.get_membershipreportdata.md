# RDS.Get\_MembershipReportData

### Overview & Purpose

This stored procedure orchestrates a comprehensive data migration process from staging tables to a Reporting Data Store (RDS). It clears existing data in the RDS, resets identity columns, and then systematically executes a series of other stored procedures to populate the RDS tables with fresh data from staging tables. The procedure appears to be part of an ETL process for an education data system.

#### Main Functions:

*   **Data Clearing**

    Completely clears existing data from RDS tables to prepare for fresh data load
*   **Identity Reset**

    Resets identity columns in RDS tables to ensure proper sequencing of new data
*   **Orchestration**

    Systematically executes a series of stored procedures to populate RDS tables
*   **Error Tracking**

    Captures and logs errors that occur during the execution of child stored procedures

#### Data Transformations:

* Migrates data from staging tables to dimension tables (DimSeas, DimLeas, DimK12Schools, etc.)
* Migrates data from staging tables to fact tables (FactK12StudentCounts, FactK12StudentDisciplines, etc.)
* Populates bridge tables for many-to-many relationships
* Updates App.ToggleAssessments with assessment data from staging

#### Expected Output:

Fully populated RDS tables with current data from staging tables, with error information for any failed steps

### Business Context

**System:** Education data reporting system, likely for state or district level education data management

**Necessity:** Centralizes and standardizes the process of refreshing the reporting data store, ensuring consistency and completeness

#### Business Rules:

* All RDS tables must be completely cleared before new data is loaded
* Identity columns must be reset to ensure proper sequencing
* Dimension tables must be populated before fact tables
* Errors in individual migration steps should not halt the entire process

#### Result Usage:

The populated RDS tables are likely used for reporting, analytics, and compliance with education data reporting requirements

#### Execution Frequency:

Likely executed periodically (annually or semi-annually) based on school year submission cycles

#### Critical Periods:

* End of school year
* Federal or state reporting deadlines

### Parameters

| Parameter       | Data Type | Purpose                                                     | Required |
| --------------- | --------- | ----------------------------------------------------------- | -------- |
| @submissionYear | int       | Specifies the school year for which data is being processed | False    |

### Source Tables

#### staging.K12Enrollment

**Business Purpose:** Holds staged enrollment data for K12 students

**Columns:**

| Name       | Data Type | Business Purpose                                  |
| ---------- | --------- | ------------------------------------------------- |
| SchoolYear | int       | Identifies the school year of the enrollment data |

#### Staging.Assessment

**Business Purpose:** Contains assessment data for students

**Columns:**

| Name                            | Data Type | Business Purpose                                         |
| ------------------------------- | --------- | -------------------------------------------------------- |
| AssessmentTitle                 | Unknown   | Identifies the assessment                                |
| AssessmentTypeAdministered      | Unknown   | Indicates the type of assessment administration          |
| AssessmentAcademicSubject       | Unknown   | Indicates the academic subject of the assessment         |
| AssessmentPerformanceLevelLabel | Unknown   | Indicates the performance level label for the assessment |

#### Staging.AssessmentResult

**Business Purpose:** Contains assessment results for students

**Columns:**

| Name                            | Data Type | Business Purpose                                         |
| ------------------------------- | --------- | -------------------------------------------------------- |
| AssessmentTitle                 | Unknown   | Identifies the assessment                                |
| AssessmentAcademicSubject       | Unknown   | Indicates the academic subject of the assessment         |
| AssessmentPerformanceLevelLabel | Unknown   | Indicates the performance level label for the assessment |
| GradeLevelWhenAssessed          | Unknown   | Indicates the grade level of the student when assessed   |

### Temporary Tables

#### #RDSMigrationProcedures

**Purpose:** Tracks the execution status and errors of child stored procedures

**Columns:**

| Name                | Data Type     | Purpose/Calculation                                               |
| ------------------- | ------------- | ----------------------------------------------------------------- |
| SP\_ID              | int           | None, directly inserted                                           |
| StoredProcedureName | nvarchar(100) | None, directly inserted                                           |
| Executed            | bit           | None, initialized to 0 and updated to 1 upon successful execution |
| Error               | nvarchar(max) | None, updated with ERROR\_MESSAGE() if an error occurs            |

### Potential Improvements

#### Error Handling

**Description:** Implement more robust error handling with transaction management

**Benefits:** Better recovery from failures, more consistent data state

**Priority:** High

#### Performance

**Description:** Optimize database file shrinking operations

**Benefits:** Reduced execution time, less I/O impact

**Priority:** Medium

#### Code Organization

**Description:** Refactor the repetitive stored procedure execution blocks

**Benefits:** More maintainable code, reduced chance of errors

**Priority:** Medium

#### Documentation

**Description:** Add more comprehensive comments explaining the purpose and dependencies of each step

**Benefits:** Easier maintenance, better knowledge transfer

**Priority:** Low

### Execution Steps

#### Step 1: Clear existing data from RDS tables

**Input Data:** None

**Transformations:** None

TRUNCATE TABLE RDS.BridgeK12StudentAssessmentRaces TRUNCATE TABLE RDS.BridgeK12StudentAssessmentAccommodations ...

#### Step 2: Reset identity columns in RDS tables

**Input Data:** None

**Transformations:** None

DBCC CHECKIDENT('RDS.FactCustomCounts', RESEED, 1); DBCC CHECKIDENT('RDS.FactK12ProgramParticipations', RESEED, 1); ...

#### Step 3: Determine submission year if not provided

**Input Data:** staging.K12Enrollment.SchoolYear

**Transformations:** None

if ISNULL(@submissionYear, '') = '' begin select @submissionYear = SchoolYear from staging.K12Enrollment end

#### Step 4: Create and populate temporary table to track stored procedure execution

**Input Data:** None

**Transformations:** None

create table #RDSMigrationProcedures ( SP\_ID int , StoredProcedureName nvarchar(100) , Executed bit , Error nvarchar(max) )

#### Step 5: Execute each stored procedure in sequence

**Input Data:** Varies by stored procedure

**Transformations:** Varies by stored procedure

if exists (select 1 from #RDSMigrationProcedures where SP\_ID = 1 and executed = 0) begin try --write out message to DataMigrationHistories insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values (getutcdate(), 2, 'RUN DMC Staging-to-DimSeas') --execute the stored procedure exec \[Staging].\[Staging-to-DimSeas] 'directory', null, 0 DBCC SHRINKFILE(\[generate-test], 1) DBCC SHRINKFILE(\[generate-test\_log], 1) --update the temp table update #RDSMigrationProcedures set executed = 1 where SP\_ID = 1 end try begin catch update #RDSMigrationProcedures set Error = ERROR\_MESSAGE() where SP\_ID = 1 end catch

#### Step 6: Update App.ToggleAssessments with assessment data

**Input Data:** Staging.Assessment, Staging.AssessmentResult

**Transformations:** Complex transformation of assessment data

TRUNCATE TABLE App.ToggleAssessments ;WITH CTE AS ( SELECT DISTINCT AssessmentTitle , AssessmentTypeAdministered , AssessmentAcademicSubject , AssessmentPerformanceLevelLabel FROM Staging.Assessment sa ) INSERT INTO App.ToggleAssessments SELECT sa.AssessmentTitle , CASE sa.AssessmentTypeAdministered WHEN 'ALTASSALTACH' THEN 'Alternate assessments based on alternate achievement standards' ... END , sa.AssessmentTypeAdministered , 'End of Grade' , left(sar.GradeLevelWhenAssessed, 2) , COUNT(DISTINCT sar.AssessmentPerformanceLevelLabel) , '3' , CASE sa.AssessmentAcademicSubject WHEN '01166' THEN 'MATH' ... END FROM CTE sa JOIN Staging.AssessmentResult sar ON sa.AssessmentTitle = sar.AssessmentTitle AND sa.AssessmentAcademicSubject = sar.AssessmentAcademicSubject AND sa.AssessmentPerformanceLevelLabel = sar.AssessmentPerformanceLevelLabel LEFT JOIN App.ToggleAssessments ata ON sa.AssessmentTitle = ata.AssessmentName AND sa.AssessmentTypeAdministered = ata.AssessmentTypeCode AND sar.GradeLevelWhenAssessed = ata.Grade AND CASE sa.AssessmentAcademicSubject WHEN '01166' THEN 'MATH' ... END = ata.Subject WHERE sa.AssessmentAcademicSubject NOT IN ('00256', '00256\_1') -- ESL AND ata.ToggleAssessmentId IS NULL AND GradeLevelWhenAssessed NOT IN ('abe', 'abe\_1') GROUP BY sa.AssessmentTitle , sa.AssessmentTypeAdministered , sar.GradeLevelWhenAssessed , sa.AssessmentAcademicSubject

#### Step 7: Report any errors that occurred during execution

**Input Data:** #RDSMigrationProcedures

**Transformations:** None

IF EXISTS (SELECT 1 FROM #RDSMigrationProcedures WHERE Error IS NOT NULL) BEGIN SELECT \* FROM #RDSMigrationProcedures s WHERE s.Error IS NOT NULL END
