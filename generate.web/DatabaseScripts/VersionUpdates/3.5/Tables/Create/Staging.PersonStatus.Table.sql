CREATE TABLE Staging.PersonStatus (
	 Student_Identifier_State VARCHAR(100)
	,LEA_Identifier_State VARCHAR(100)
	,School_Identifier_State VARCHAR(100)
	,HomelessnessStatus BIT
	,Homelessness_StatusStartDate DATE
	,Homelessness_StatusEndDate DATE
	,HomelessNightTimeResidence VARCHAR(100)
	,HomelessNightTimeResidence_StartDate DATE
	,HomelessNightTimeResidence_EndDate DATE
	,HomelessUnaccompaniedYouth BIT
	,HomelessServicedIndicator BIT
	,EconomicDisadvantageStatus BIT
	,EconomicDisadvantage_StatusStartDate DATE
	,EconomicDisadvantage_StatusEndDate DATE
	,EligibilityStatusForSchoolFoodServicePrograms VARCHAR(100)
	,NationalSchoolLunchProgramDirectCertificationIndicator BIT
	,MigrantStatus BIT
	,Migrant_StatusStartDate DATE
	,Migrant_StatusEndDate DATE
	,MilitaryConnectedStudentIndicator VARCHAR(100)
	,MilitaryConnected_StatusStartDate DATE
	,MilitaryConnected_StatusEndDate DATE
	,ProgramType_FosterCare BIT
	,FosterCare_ProgramParticipationStartDate DATE
	,FosterCare_ProgramParticipationEndDate DATE
	,ProgramType_Section504 BIT
	,Section504_ProgramParticipationStartDate DATE
	,Section504_ProgramParticipationEndDate DATE
	,ProgramType_Immigrant BIT
	,Immigrant_ProgramParticipationStartDate DATE
	,Immigrant_ProgramParticipationEndDate DATE
	,EnglishLearnerStatus BIT
	,EnglishLearner_StatusStartDate DATE
	,EnglishLearner_StatusEndDate DATE
	,ISO_639_2_NativeLanguage VARCHAR(100)
	,PerkinsLEPStatus VARCHAR(100)
	,PerkinsLEPStatus_StatusStartDate DATE
	,PerkinsLEPStatus_StatusEndDate DATE
	,IDEAIndicator BIT
	,IDEA_StatusStartDate DATE
	,IDEA_StatusEndDate DATE
	,PrimaryDisabilityType VARCHAR(100)
	,PersonId INT
	,OrganizationID_LEA INT
	,OrganizationPersonRoleID_LEA INT
	,OrganizationID_School INT
	,OrganizationID_Program_Foster INT
	,OrganizationPersonRoleID_School INT
	,OrganizationID_LEA_Program_Foster INT
	,OrganizationPersonRoleID_LEA_Program_Foster INT
	,OrganizationID_School_Program_Foster INT
	,OrganizationPersonRoleID_School_Program_Foster INT

	,OrganizationID_Program_Section504 INT
	,OrganizationID_LEA_Program_Section504 INT
	,OrganizationPersonRoleID_LEA_Program_Section504 INT
	,OrganizationID_School_Program_Section504 INT
	,OrganizationPersonRoleID_School_Program_Section504 INT

	,OrganizationID_Program_Immigrant INT
	,OrganizationID_LEA_Program_Immigrant INT
	,OrganizationPersonRoleID_LEA_Program_Immigrant INT
	,OrganizationID_School_Program_Immigrant INT
	,OrganizationPersonRoleID_School_Program_Immigrant INT

	,OrganizationPersonRoleID_LEA_SPED INT
	,OrganizationPersonRoleID_School_SPED INT
	,OrganizationID_LEA_Program_Homeless INT
	,OrganizationID_School_Program_Homeless INT
	,OrganizationPersonRoleID_LEA_Program_Homeless INT
	,OrganizationPersonRoleID_School_Program_Homeless INT
	,PersonStatusId_Homeless INT
	,PersonHomelessNightTimeResidenceId INT
	,PersonStatusId_EconomicDisadvantage INT
	,PersonStatusId_IDEA INT
	,PersonStatusId_EnglishLearner INT
	,PersonLanguageId INT
	,PersonStatusId_Migrant INT
	,PersonMilitaryId INT
	,PersonHomelessnessId INT
	, [OrganizationPersonRoleID_Program_Foster] INT
	,RunDateTime DATETIME
	);

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'Student_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'School_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'HomelessnessStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'Homelessness_StatusStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'Homelessness_StatusEndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'HomelessNightTimeResidence' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'HomelessNightTimeResidence_StartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'HomelessNightTimeResidence_EndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'HomelessUnaccompaniedYouth' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EconomicDisadvantageStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EconomicDisadvantage_StatusStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EconomicDisadvantage_StatusEndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'MigrantStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'Migrant_StatusStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'MilitaryConnectedStudentIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'Migrant_StatusEndDate' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefMilitaryConnectedStudentIndicator', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'MilitaryConnectedStudentIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'ProgramType_FosterCare' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'FosterCare_ProgramParticipationStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'FosterCare_ProgramParticipationEndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EnglishLearnerStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EnglishLearner_StatusStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'EnglishLearner_StatusEndDate'
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'ISO_639_2_NativeLanguage' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'IDEAIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'IDEA_StatusStartDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'IDEA_StatusEndDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'PrimaryDisabilityType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefDisabilityType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'PersonStatus', @level2type = N'Column', @level2name = 'PrimaryDisabilityType' 