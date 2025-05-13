# Staging.Staging-To-DimPeople\_K12Students

### Overview & Purpose

This stored procedure populates the RDS.DimPeople dimension table with K-12 student data from the Staging.K12Enrollment table. It handles the creation of new student records and manages the historization of student data by setting appropriate start and end dates.

#### Main Functions:

*   **Insert Default Record**

    Ensures a default record with DimPersonId = -1 exists in the RDS.DimPeople table
*   **Student Data Extraction**

    Extracts distinct student records from Staging.K12Enrollment into a temporary table
*   **MERGE Operation**

    Inserts new student records into RDS.DimPeople that don't already exist
*   **Historical Record Management**

    Updates end dates for previous records of the same student to maintain historical accuracy

#### Key Calculations:

*   **Historical Record Management: Calculates the end date for previous student records**

    Formula: `dateadd(day, -1, min(endd.RecordStartDateTime))`

    Business Significance: Ensures historical tracking of student data changes over time

    Example: If a student has records starting on 2022-01-01 and 2022-06-01, the first record's end date would be set to 2022-05-31

#### Data Transformations:

* Extraction of distinct student demographic data from enrollment records
* Setting IsActiveK12Student flag to 1 for all extracted records
* Setting appropriate start and end dates for historical tracking

#### Expected Output:

Updated RDS.DimPeople table with current and historical K-12 student records, properly maintaining the timeline of student information changes

### Business Context

**System:** K-12 Student Information System

**Necessity:** Maintains a dimensional model of student data for reporting and analysis purposes

#### Business Rules:

* Each student is uniquely identified by a combination of state ID, name, and birth date
* Historical changes to student records must be preserved with appropriate date ranges
* A default record with ID -1 must exist for referential integrity

#### Result Usage:

The dimension table is likely used for reporting, analytics, and data warehousing purposes related to K-12 education

#### Execution Frequency:

Likely executed on a regular schedule (daily, weekly, or monthly) or after K12Enrollment data is updated

#### Critical Periods:

* Beginning and end of school terms
* State reporting deadlines

### Parameters

| Parameter         | Data Type | Purpose                                                                                                | Required |
| ----------------- | --------- | ------------------------------------------------------------------------------------------------------ | -------- |
| @dataCollectionId | INT       | Likely intended to filter data by a specific collection ID, though not currently used in the procedure | False    |

### Source Tables

#### Staging.K12Enrollment

**Business Purpose:** Stores K-12 student enrollment data in a staging area

**Columns:**

| Name                   | Data Type | Business Purpose                    |
| ---------------------- | --------- | ----------------------------------- |
| FirstName              | NVARCHAR  | Student's first name                |
| MiddleName             | NVARCHAR  | Student's middle name               |
| LastOrSurname          | NVARCHAR  | Student's last name or surname      |
| BirthDate              | DATE      | Student's date of birth             |
| StudentIdentifierState | NVARCHAR  | State-assigned student identifier   |
| EnrollmentEntryDate    | DATE      | Date when student enrolled          |
| EnrollmentExitDate     | DATE      | Date when student exited enrollment |

### Temporary Tables

#### #k12Students

**Purpose:** Temporary storage for distinct student records extracted from Staging.K12Enrollment

**Columns:**

| Name                             | Data Type    | Purpose/Calculation                     |
| -------------------------------- | ------------ | --------------------------------------- |
| FirstName                        | NVARCHAR(50) | Direct copy from source                 |
| MiddleName                       | NVARCHAR(50) | Direct copy from source                 |
| LastOrSurname                    | NVARCHAR(50) | Direct copy from source                 |
| BirthDate                        | DATE         | Direct copy from source                 |
| K12StudentStudentIdentifierState | NVARCHAR(40) | Direct copy from StudentIdentifierState |
| IsActiveK12Student               | BIT          | Set to 1 for all records                |
| RecordStartDateTime              | DATE         | Set to EnrollmentEntryDate              |
| RecordEndDateTime                | DATE         | Set to EnrollmentExitDate               |

### Potential Improvements

#### Error Handling

**Description:** Add more specific error handling for each major operation

**Benefits:** Better troubleshooting and more graceful failure handling

**Priority:** Medium

#### Performance

**Description:** Add appropriate indexes to the temporary table

**Benefits:** Faster MERGE operation, especially with large datasets

**Priority:** Medium

#### Functionality

**Description:** Implement the @dataCollectionId parameter functionality

**Benefits:** Allow filtering by data collection ID as intended

**Priority:** Low

#### Transaction Management

**Description:** Add explicit transaction control

**Benefits:** Ensure atomicity of operations

**Priority:** Medium

### Execution Steps

#### Step 1: Ensure default record exists

**Input Data:** None

**Transformations:** None

IF NOT EXISTS (SELECT 1 FROM RDS.DimPeople WHERE DimPersonId = -1) BEGIN SET IDENTITY\_INSERT RDS.DimPeople ON INSERT INTO RDS.DimPeople (DimPersonId) VALUES (-1) SET IDENTITY\_INSERT RDS.DimPeople off END

#### Step 2: Create temporary table for student data

**Input Data:** None

**Transformations:** None

CREATE TABLE #k12Students (...)

#### Step 3: Extract distinct student records

**Input Data:** Staging.K12Enrollment

**Transformations:** Selection of specific columns, setting IsActiveK12Student to 1

INSERT INTO #k12Students (...) SELECT DISTINCT ... FROM Staging.K12Enrollment e

#### Step 4: Insert new student records

**Input Data:** #k12Students temporary table

**Transformations:** None

MERGE rds.DimPeople AS trgt USING #k12Students AS src ON ... WHEN NOT MATCHED BY TARGET THEN INSERT ...

#### Step 5: Update end dates for historical records

**Input Data:** RDS.DimPeople

**Transformations:** Calculate end dates for previous records

WITH upd AS (...) UPDATE student SET RecordEndDateTime = upd.RecordEndDateTime FROM rds.DimPeople student INNER JOIN upd ON ...
