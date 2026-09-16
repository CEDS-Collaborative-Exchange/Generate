CREATE TABLE Staging.StudentCourse (
	  Id INT IDENTITY(1, 1) Primary Key
	, Student_Identifier_State VARCHAR(100)
	, LEA_Identifier_State VARCHAR(100)
	, School_Identifier_State VARCHAR(100)
	, SchoolYear INT
	, CourseCode VARCHAR(100)
	, CourseGradeLevel VARCHAR(100)
	, PersonId INT NULL
	, OrganizationID_LEA INT NULL
	, OrganizationPersonRoleId_LEA INT NULL
	, OrganizationID_School INT NULL
	, OrganizationPersonRoleId_School INT NULL
	, OrganizationID_Course INT NULL
	, OrganizationPersonRoleId_Course INT NULL
	, RunDateTime DATETIME
	);


exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StudentCourse', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StudentCourse', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'StudentCourse', @level2type = N'Column', @level2name = 'CourseGradeLevel' 
