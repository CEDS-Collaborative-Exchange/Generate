# Staging.Staging-to-DimPeople

### Overview & Purpose

This stored procedure populates the RDS.DimPeople dimension table from staging tables. It handles data from K-12 students, postsecondary students, and staff members, merging records where appropriate and managing record start and end dates to maintain historical data.

#### Main Functions:

*   **Data Integration**

    Combines person data from multiple source systems (K-12, postsecondary, and staff) into a single dimension table
*   **Historical Data Management**

    Maintains historical records by setting appropriate RecordEndDateTime values

#### Key Calculations:

*   **Data Integration: Identifies matching records across source systems**

    Formula: `MERGE operation with multiple join conditions`

    Business Significance: Creates a single view of a person across educational contexts

    Example: Matching K-12 and postsecondary student records based on identifiers and demographic information
*   **Historical Data Management: Sets the end date of a record to one day before the start date of the next version**

    Formula: `DATEADD(D, -1, MIN(endd.RecordStartDateTime))`

    Business Significance: Enables point-in-time analysis of person data

    Example: When a student record is updated, the previous version gets an end date

#### Data Transformations:

* Merging K-12 student records with matching postsecondary student records
* Handling missing values with ISNULL functions
* Creating a default record with ID -1
* Setting appropriate IsActive flags based on source data
* Removing duplicate person records where one has only K-12 ID and another has both K-12 and PS IDs

#### Expected Output:

A populated RDS.DimPeople dimension table with integrated person data from multiple educational contexts, with proper historical versioning through start and end dates

### Business Context

**System:** Education Data Warehouse

**Necessity:** Provides a unified view of individuals across educational systems for reporting and analysis

#### Business Rules:

* A person can be both a K-12 student and a postsecondary student simultaneously
* Person records are matched based on identifiers, name components, and birth date
* Records with missing LastOrSurname are populated with 'MISSING'
* When a person has both K-12 and postsecondary identifiers, duplicate records are removed
* Historical versioning is maintained through start and end dates

#### Result Usage:

The dimension table is used for reporting and analysis across educational contexts, enabling tracking of individuals through their educational journey

#### Execution Frequency:

Likely daily or weekly as part of the ETL process

#### Critical Periods:

* Beginning and end of academic terms
* State and federal reporting periods

### Parameters

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Contains enrollment data for K-12 students

**Columns:**

| Name                   | Data Type | Business Purpose                                       |
| ---------------------- | --------- | ------------------------------------------------------ |
| BirthDate              | DATE      | Student's date of birth                                |
| FirstName              | NVARCHAR  | Student's first name                                   |
| LastOrSurname          | NVARCHAR  | Student's last name or surname                         |
| MiddleName             | NVARCHAR  | Student's middle name                                  |
| StudentIdentifierState | NVARCHAR  | State-assigned student identifier                      |
| RecordStartDateTime    | DATETIME  | When this version of the record became effective       |
| RecordEndDateTime      | DATETIME  | When this version of the record ceased to be effective |
| DataCollectionName     | NVARCHAR  | Name of the data collection                            |

#### Staging.PsStudentEnrollment

**Business Purpose:** Contains enrollment data for postsecondary students

**Columns:**

| Name                   | Data Type | Business Purpose                                       |
| ---------------------- | --------- | ------------------------------------------------------ |
| BirthDate              | DATE      | Student's date of birth                                |
| FirstName              | NVARCHAR  | Student's first name                                   |
| LastOrSurname          | NVARCHAR  | Student's last name or surname                         |
| MiddleName             | NVARCHAR  | Student's middle name                                  |
| StudentIdentifierState | NVARCHAR  | State-assigned student identifier                      |
| RecordStartDateTime    | DATETIME  | When this version of the record became effective       |
| RecordEndDateTime      | DATETIME  | When this version of the record ceased to be effective |

#### Staging.StateDetail

**Business Purpose:** Contains information about state education officials

**Columns:**

| Name                              | Data Type | Business Purpose                                  |
| --------------------------------- | --------- | ------------------------------------------------- |
| SeaContact\_FirstName             | NVARCHAR  | First name of state education agency contact      |
| SeaContact\_LastOrSurname         | NVARCHAR  | Last name of state education agency contact       |
| SeaContact\_PersonalTitleOrPrefix | NVARCHAR  | Title or prefix of state education agency contact |
| SeaContact\_PositionTitle         | NVARCHAR  | Position title of state education agency contact  |
| SeaContact\_ElectronicMailAddress | NVARCHAR  | Email address of state education agency contact   |
| SeaContact\_PhoneNumber           | NVARCHAR  | Phone number of state education agency contact    |
| SeaContact\_Identifier            | NVARCHAR  | Identifier for state education agency contact     |
| RecordStartDateTime               | DATETIME  | When this version of the record became effective  |

### Temporary Tables

#### #People

**Purpose:** Temporary staging table to collect and transform person data from multiple sources

**Columns:**

| Name                             | Data Type     | Purpose/Calculation                                                         |
| -------------------------------- | ------------- | --------------------------------------------------------------------------- |
| BirthDate                        | DATE          | Direct copy from source tables                                              |
| FirstName                        | NVARCHAR(50)  | Direct copy from source tables                                              |
| LastOrSurname                    | NVARCHAR(50)  | ISNULL(source.LastOrSurname, 'MISSING')                                     |
| MiddleName                       | NVARCHAR(50)  | Direct copy from source tables                                              |
| PersonalTitleOrPrefix            | NVARCHAR(100) | NULL for students, copied from StateDetail for staff                        |
| PositionTitle                    | NVARCHAR(100) | NULL for students, copied from StateDetail for staff                        |
| ElectronicEmailAddressWork       | NVARCHAR(126) | NULL for students, copied from StateDetail for staff                        |
| TelephoneNumberWork              | NVARCHAR(24)  | NULL for students, copied from StateDetail for staff                        |
| K12StudentStudentIdentifierState | NVARCHAR(40)  | Copied from K12Enrollment.StudentIdentifierState                            |
| PsStudentStudentIdentifierState  | NVARCHAR(40)  | Copied from PsStudentEnrollment.StudentIdentifierState                      |
| K12StaffMemberIdentiferState     | NVARCHAR(40)  | NULL for students, copied from StateDetail.SeaContact\_Identifier for staff |
| IsActiveK12Student               | BIT           | 1 for K-12 students, 0 otherwise                                            |
| IsActivePsStudent                | BIT           | 1 for postsecondary students, 0 otherwise                                   |
| IsActiveK12StaffMember           | BIT           | 1 for staff members, 0 otherwise                                            |
| RecordStartDateTime              | DATETIME      | Copied from source tables                                                   |

#### #upd

**Purpose:** Temporary table to store record end dates for historical versioning

**Columns:**

| Name                             | Data Type    | Purpose/Calculation                           |
| -------------------------------- | ------------ | --------------------------------------------- |
| K12StudentStudentIdentifierState | NVARCHAR(60) | Copied from DimPeople                         |
| PsStudentStudentIdentifierState  | NVARCHAR(60) | Copied from DimPeople                         |
| RecordStartDateTime              | DATETIME     | Copied from DimPeople                         |
| RecordEndDateTime                | DATETIME     | DATEADD(D, -1, MIN(endd.RecordStartDateTime)) |

### Potential Improvements

#### Performance

**Description:** Replace the batched updates of RecordEndDateTime with a single update operation using a more efficient approach

**Benefits:** Significantly reduced execution time, less resource consumption

**Priority:** High

#### Maintainability

**Description:** Add comments explaining the business logic and performance considerations

**Benefits:** Improved understanding for future maintenance, easier troubleshooting

**Priority:** Medium

#### Performance

**Description:** Optimize the log file shrinking operation

**Benefits:** Reduced I/O overhead, potentially faster execution

**Priority:** Medium

#### Functionality

**Description:** Enhance matching logic to handle more variations in person data

**Benefits:** Improved data quality, fewer duplicate records

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize environment and create default record

**Input Data:** None

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM RDS.DimPeople WHERE DimPersonId = -1) BEGIN SET IDENTITY\_INSERT RDS.DimPeople ON INSERT INTO RDS.DimPeople (DimPersonId) VALUES (-1) SET IDENTITY\_INSERT RDS.DimPeople off END

#### Step 2: Create and populate temporary staging table

**Input Data:** Staging.K12Enrollment, Staging.PsStudentEnrollment, Staging.StateDetail

**Transformations:** Combining data from multiple sources, setting flags, handling nulls

CREATE TABLE #People (...) INSERT INTO #People ... FROM Staging.K12Enrollment ... INSERT INTO #People ... FROM Staging.PsStudentEnrollment ... INSERT INTO #People ... FROM Staging.StateDetail

#### Step 3: Merge data into dimension table

**Input Data:** #People temp table

**Transformations:** Insert new records into DimPeople

MERGE rds.DimPeople AS trgt USING #People AS src ON ... WHEN NOT MATCHED BY TARGET THEN INSERT ...

#### Step 4: Remove duplicate records

**Input Data:** RDS.DimPeople

**Transformations:** Delete duplicate records where one has only K-12 ID and another has both K-12 and PS IDs

DELETE FROM RDS.DimPeople WHERE DimPersonId IN (SELECT DISTINCT K12.DimPersonId FROM RDS.DimPeople k12 JOIN RDS.DimPeople ps ON ... WHERE k12.IsActiveK12Student = 1 AND K12.IsActivePsStudent = 0 AND ps.IsActiveK12Student = 1 AND ps.IsActivePsStudent = 1)

#### Step 5: Prepare for historical versioning

**Input Data:** RDS.DimPeople

**Transformations:** Reset all RecordEndDateTime values to NULL, disable indexes

ALTER INDEX ... ON RDS.DimPeople DISABLE UPDATE person SET RecordEndDateTime = NULL FROM RDS.DimPeople person

#### Step 6: Calculate record end dates

**Input Data:** RDS.DimPeople

**Transformations:** Calculate end dates for historical versioning

INSERT INTO #upd SELECT startd.\[K12StudentStudentIdentifierState], startd.\[PsStudentStudentIdentifierState], startd.RecordStartDateTime, DATEADD(D, -1, MIN(endd.RecordStartDateTime)) as RecordEndDateTime FROM RDS.DimPeople startd JOIN RDS.DimPeople endd ON ... GROUP BY ...

#### Step 7: Update record end dates

**Input Data:** #upd temp table, RDS.DimPeople

**Transformations:** Update RecordEndDateTime values in DimPeople

WHILE @index <= 9 BEGIN ... UPDATE rds.DimPeople SET RecordEndDateTime = upd.RecordEndDateTime FROM rds.DimPeople rdp INNER JOIN #upd upd ON ... WHERE ... AND ISNULL(rdp.\[K12StudentStudentIdentifierState],rdp.\[PsStudentStudentIdentifierState]) like CAST(@index AS VARCHAR) + '%' ... END

#### Step 8: Cleanup and finalize

**Input Data:** None

**Transformations:** Drop temp tables, rebuild indexes

DROP TABLE IF EXISTS #People DROP TABLE IF EXISTS #upd ALTER INDEX ALL ON RDS.DimPeople REBUILD
