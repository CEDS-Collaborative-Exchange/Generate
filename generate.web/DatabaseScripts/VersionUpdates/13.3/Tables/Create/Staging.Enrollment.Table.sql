CREATE TABLE Staging.Enrollment (
	  Id INT IDENTITY(1, 1) Primary Key
	, Student_Identifier_State VARCHAR(100)
	, LEA_Identifier_State VARCHAR(100)
	, School_Identifier_State VARCHAR(100)
	, EnrollmentEntryDate DATE
	, EnrollmentExitDate DATE
	, ExitOrWithdrawalType VARCHAR(100) NULL
	, GradeLevel VARCHAR(100)
	, CohortYear NCHAR(4) NULL
	, CohortGraduationYear NCHAR(4) NULL
	, CohortDescription NCHAR(1024) NULL
	, HighSchoolDiplomaType VARCHAR(100) NULL
	, PersonId INT NULL
	, OrganizationID_LEA INT NULL
	, OrganizationPersonRoleId_LEA INT NULL
	, OrganizationID_School INT NULL
	, OrganizationPersonRoleId_School INT NULL
	, RunDateTime DATETIME
	, SchoolYear INT
	, NumberOfSchoolDays DECIMAL(9,2)
    , NumberOfDaysAbsent DECIMAL(9,2)
    , AttendanceRate DECIMAL(5,4)
	, PostSecondaryEnrollment BIT
	, DiplomaOrCredentialAwardDate DATE
	, FoodServiceEligibility VARCHAR(100)
	);


exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'EnrollmentEntryDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'EnrollmentExitDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'ExitOrWithdrawalType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefExitOrWithdrawalType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'ExitOrWithdrawalType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'GradeLevel' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefGradeLevel', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'GradeLevel' 
exec sp_addextendedproperty @name = N'TableFilter', @value = N'000100', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'GradeLevel' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'CohortYear' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'CohortGraduationYear' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'HighSchoolDiplomaType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefHighSchoolDiplomaType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Enrollment', @level2type = N'Column', @level2name = 'HighSchoolDiplomaType' 

