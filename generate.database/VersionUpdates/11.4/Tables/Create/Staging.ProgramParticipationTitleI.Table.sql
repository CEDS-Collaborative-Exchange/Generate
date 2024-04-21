CREATE TABLE Staging.ProgramParticipationTitleI (
	 ID INT IDENTITY(1, 1) Primary Key
	,RecordId VARCHAR(100)
	,LEA_Identifier_State VARCHAR(100)
	,School_Identifier_State VARCHAR(100)
	,Student_Identifier_State VARCHAR(100)
	,TitleIIndicator VARCHAR(100)
	,PersonID INT
	,OrganizationID_LEA INT
	,OrganizationID_School INT
	,LEAOrganizationPersonRoleID_TitleIProgram INT
	,LEAOrganizationID_TitleIProgram INT
	,LEAPersonProgramParticipationId INT
	,SchoolOrganizationPersonRoleID_TitleIProgram INT
	,SchoolOrganizationID_TitleIProgram INT
	,SchoolPersonProgramParticipationId INT
	,RefTitleIIndicatorId INT
	,RunDateTime DATETIME
    );

CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationTitleI_RecordId
    ON Staging.ProgramParticipationTitleI (RecordId);   
  

CREATE NONCLUSTERED INDEX IX_Staging_LEAProgramParticipationTitleI_PersonSchool
    ON Staging.ProgramParticipationTitleI (PersonID, LEAOrganizationID_TitleIProgram);   
  

CREATE NONCLUSTERED INDEX IX_Staging_LEAProgramParticipationTitleI_PersonTitleI
    ON Staging.ProgramParticipationTitleI (LEAOrganizationPersonRoleID_TitleIProgram);   
  

CREATE NONCLUSTERED INDEX IX_Staging_SchoolProgramParticipationTitleI_PersonSchool
    ON Staging.ProgramParticipationTitleI (PersonID, SchoolOrganizationID_TitleIProgram);   
  

CREATE NONCLUSTERED INDEX IX_Staging_SchoolProgramParticipationTitleI_PersonTitleI
    ON Staging.ProgramParticipationTitleI (SchoolOrganizationPersonRoleID_TitleIProgram);   
  

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'RecordId' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'School_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'Student_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'TitleIIndicator' 			
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefTitleIIndicator', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleI', @level2type = N'Column', @level2name = 'TitleIIndicator' 
