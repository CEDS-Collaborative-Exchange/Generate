CREATE TABLE Staging.ProgramParticipationTitleIII (
	 ID INT IDENTITY(1, 1) Primary Key
	,RecordId VARCHAR(100)
	,School_Identifier_State VARCHAR(100)
	,Student_Identifier_State VARCHAR(100)
	,ProgramParticipationBeginDate DATE
	,ProgramParticipationEndDate DATE NULL
	,Participation_TitleIII VARCHAR(100)
	,Proficiency_TitleIII VARCHAR(100)
	,Progress_TitleIII VARCHAR(100)
	,EnglishLearnerParticipation BIT
	,TitleIiiImmigrantStatus BIT
	,LanguageInstructionProgramServiceType VARCHAR(100)
	,TitleIiiImmigrantStatus_StartDate DATE
	,TitleIiiImmigrantStatus_EndDate DATE
	,PersonID INT
	,OrganizationID_School INT
	,OrganizationPersonRoleID_TitleIIIProgram INT
	,OrganizationID_TitleIIIProgram INT
	,PersonProgramParticipationId INT
	,ImmigrationPersonStatusId INT
	,RunDateTime DATETIME
    );

CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationTitleIII_RecordId
    ON Staging.ProgramParticipationTitleIII (RecordId);

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleIII', @level2type = N'Column', @level2name = 'RecordId' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleIII', @level2type = N'Column', @level2name = 'School_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationTitleIII', @level2type = N'Column', @level2name = 'Student_Identifier_State' 						
