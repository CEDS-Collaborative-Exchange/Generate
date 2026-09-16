CREATE TABLE Staging.K12StaffAssignment (
	  ID INT IDENTITY(1, 1) Primary Key
	, Personnel_Identifier_State VARCHAR(100)
	, LEA_Identifier_State VARCHAR(100)
	, School_Identifier_State VARCHAR(100)
	, FirstName VARCHAR (100)  NULL
    , LastName VARCHAR (100)  NULL
    , MiddleName VARCHAR (100)  NULL
	, BirthDate datetime2(7) null
	, Sex VARCHAR (30) NULL
	, PositionTitle nvarchar(50) null
	, FullTimeEquivalency DECIMAL(5, 4) NULL
	, SpecialEducationStaffCategory VARCHAR(100) NULL
	, K12StaffClassification VARCHAR(100) NULL
	, TitleIProgramStaffCategory VARCHAR(100) NULL
	, CredentialType VARCHAR(100) NULL
	, CredentialIssuanceDate DATE NULL
	, CredentialExpirationDate DATE NULL
	, ParaprofessionalQualification VARCHAR(100) NULL 
	, SpecialEducationAgeGroupTaught VARCHAR(100) NULL
	, HighlyQualifiedTeacherIndicator BIT NULL
	, AssignmentStartDate DATE
	, AssignmentEndDate DATE NULL
	, InexperiencedStatus VARCHAR(100) NULL
	, EmergencyorProvisionalCredentialStatus VARCHAR(100) NULL
	, OutOfFieldStatus VARCHAR(100) NULL
	, RecordStartDateTime DATE NULL
    , RecordEndDateTime DATE NULL
	, SchoolYear VARCHAR(4) NULL
	, DataCollectionName VARCHAR(100) NULL
	-- CIID-5778 JW
	--, ProgramTypeCode VARCHAR(100) NULL
	, RunDateTime DATETIME
	)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'Personnel_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'School_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'FullTimeEquivalency' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'SpecialEducationStaffCategory' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'FirstName' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'LastName' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'MiddleName' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'BirthDate' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'Sex' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'PositionTitle' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefSpecialEducationStaffCategory', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'SpecialEducationStaffCategory ' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'K12StaffClassification' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefK12StaffClassification', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'K12StaffClassification' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'TitleIProgramStaffCategory' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefTitleIProgramStaffCategory', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'TitleIProgramStaffCategory' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'CredentialType' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefTitleIProgramStaffCategory', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'CredentialType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'CredentialExpirationDate' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'ParaprofessionalQualification' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefParaprofessionalQualification', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'ParaprofessionalQualification' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'SpecialEducationAgeGroupTaught' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefSpecialEducationAgeGroupTaught', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'SpecialEducationAgeGroupTaught' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'HighlyQualifiedTeacherIndicator' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'AssignmentStartDate' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'K12StaffAssignment', @level2type = N'Column', @level2name = 'AssignmentEndDate' 			