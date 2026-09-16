CREATE TABLE Staging.ProgramParticipationCTE (
	 ID INT IDENTITY(1, 1) Primary Key
	,RecordId VARCHAR(100)
	,School_Identifier_State VARCHAR(100)
	,Student_Identifier_State VARCHAR(100)
	,ProgramParticipationBeginDate DATE
	,ProgramParticipationEndDate DATE NULL
/*	,DiplomaCredentialType VARCHAR(100)
	,DiplomaCredentialType_2 VARCHAR(100)*/
	,DiplomaCredentialAwardDate DATE NULL
	,CteParticipant BIT NULL
	,CteConcentrator BIT NULL
	,CteCompleter BIT
	,SingleParentIndicator BIT
	,SingleParent_StatusStartDate DATE
	,SingleParent_StatusEndDate DATE
	,DisplacedHomeMakerIndicator BIT
	,DisplacedHomeMaker_StatusStartDate DATE
	,DisplacedHomeMaker_StatusEndDate DATE
	,AdvancedTrainingEnrollmentDate DATE
	,PlacementType VARCHAR(100)
	,TechnicalSkillsAssessmentType VARCHAR(100)
	,NonTraditionalGenderStatus BIT
	,PersonID INT
	,OrganizationID_School INT
	,OrganizationPersonRoleID_School INT
	,OrganizationPersonRoleID_CTEProgram INT
	,OrganizationID_CTEProgram INT
	,PersonProgramParticipationId INT
	,CteExitReason VARCHAR(100)
	,RunDateTime DATETIME
    );

CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationCTE_RecordId
    ON Staging.ProgramParticipationCTE (RecordId);

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationCTE', @level2type = N'Column', @level2name = 'RecordId' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationCTE', @level2type = N'Column', @level2name = 'School_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationCTE', @level2type = N'Column', @level2name = 'Student_Identifier_State' 			
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'ProgramParticipationCTE', @level2type = N'Column', @level2name = 'PlacementType' 			
