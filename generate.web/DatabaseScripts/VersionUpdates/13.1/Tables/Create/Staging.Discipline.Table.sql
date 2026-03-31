CREATE TABLE Staging.Discipline
    ( Id INT IDENTITY(1, 1) PRIMARY KEY
	, Student_Identifier_State VARCHAR(100)
	, LEA_Identifier_State VARCHAR(100)
	, School_Identifier_State VARCHAR(100)
	, DisciplineActionIdentifier VARCHAR(100)
	, IncidentIdentifier VARCHAR(40) NULL
	, IncidentDate DATE NULL
	, IncidentTime TIME(7)
	, DisciplinaryActionTaken VARCHAR(100)
	, DisciplineReason VARCHAR(100) 
    , DisciplinaryActionStartDate VARCHAR(100)
    , DisciplinaryActionEndDate VARCHAR(100)
    , DurationOfDisciplinaryAction VARCHAR(100)
    , IdeaInterimRemoval VARCHAR(100)
    , IdeaInterimRemovalReason VARCHAR(100)
	, EducationalServicesAfterRemoval BIT
	, DisciplineMethodFirearm VARCHAR(100)
	, IDEADisciplineMethodFirearm VARCHAR(100)
    , DisciplineMethodOfCwd VARCHAR(100)
	, WeaponType VARCHAR(100) NULL
	, FirearmType VARCHAR(100) NULL
	, PersonId INT NULL
	, OrganizationID_LEA INT NULL
	, OrganizationPersonRoleId_LEA INT NULL 
	, OrganizationID_School INT NULL
	, OrganizationPersonRoleId_School INT NULL 
	, IncidentId_LEA INT NULL
	, IncidentId_School INT NULL
	, RunDateTime DATETIME
	)


exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'School_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'IncidentIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplinaryActionTaken' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefDisciplinaryActionTaken', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplinaryActionTaken' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplineReason' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefDisciplineReason', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplineReason' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplinaryActionStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplinaryActionEndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DurationOfDisciplinaryAction' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'IdeaInterimRemoval' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefIdeaInterimRemoval', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'IdeaInterimRemoval' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'IdeaInterimRemovalReason' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefIDEAInterimRemovalReason', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'IdeaInterimRemovalReason' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'EducationalServicesAfterRemoval' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplineMethodOfCwd' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefDisciplineMethodOfCwd', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Discipline', @level2type = N'Column', @level2name = 'DisciplineMethodOfCwd' 
