CREATE TABLE Staging.Organization (
	  Id INT IDENTITY(1, 1) Primary Key
	, LEA_Identifier_State VARCHAR(100)
	, LEA_Identifier_NCES VARCHAR(100)
	, LEA_SupervisoryUnionIdentificationNumber VARCHAR(100)
	, LEA_Name VARCHAR(100)
	, LEA_WebSiteAddress VARCHAR(300)
	, LEA_OperationalStatus VARCHAR(100)
	, LEA_UpdatedOperationalStatus VARCHAR(100)
	, LEA_UpdatedOperationalStatusEffectiveDate VARCHAR(100)
	, LEA_CharterLeaStatus VARCHAR(100)
	, LEA_CharterSchoolIndicator BIT
	, LEA_Type VARCHAR(100)
	, LEA_McKinneyVentoSubgrantRecipient bit
	, LEA_GunFreeSchoolsActReportingStatus VARCHAR(100)
	, LEA_TitleIinstructionalService VARCHAR(100)
	, LEA_TitleIProgramType VARCHAR(100)
	, LEA_K12LeaTitleISupportService VARCHAR(100)
	, LEA_MepProjectType VARCHAR(100)
	, School_Identifier_State VARCHAR(100)
	, School_Identifier_NCES VARCHAR(100)
	, School_Name VARCHAR(100)
	, School_WebSiteAddress VARCHAR(300)
	, School_OperationalStatus VARCHAR(100)
	, School_UpdatedOperationalStatus VARCHAR(100)
	, School_UpdatedOperationalStatusEffectiveDate VARCHAR(100)
	, School_Type VARCHAR(100)
	, School_MagnetOrSpecialProgramEmphasisSchool VARCHAR(100)
	, School_SharedTimeIndicator VARCHAR(100)
	, School_VirtualSchoolStatus VARCHAR(100)
	, School_NationalSchoolLunchProgramStatus VARCHAR(100)
	, School_ReconstitutedStatus VARCHAR(100)
	, School_CharterSchoolApprovalAgencyType VARCHAR(100)
	, School_CharterSchoolIndicator BIT
	, School_CharterSchoolOpenEnrollmentIndicator BIT
	, School_CharterSchoolFEIN VARCHAR(100)
	, School_CharterSchoolFEIN_Update VARCHAR(100)
	, School_CharterContractIDNumber VARCHAR(100)
	, School_CharterContractApprovalDate DateTime
	, School_CharterContractRenewalDate DateTime
	, School_CharterPrimaryAuthorizer [varchar](100) NULL
	, School_CharterSecondaryAuthorizer [varchar](100) NULL
	, School_StatePovertyDesignation VARCHAR(100)
	, SchoolImprovementAllocation MONEY
	, School_IndicatorStatusType VARCHAR(100)
	, School_GunFreeSchoolsActReportingStatus VARCHAR(100)
	, School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus  VARCHAR(100)
	, School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus  VARCHAR(100)
	, School_SchoolDangerousStatus  VARCHAR(100)
	, SchoolYear VARCHAR(100)
	, TitleIPartASchoolDesignation VARCHAR(100)
	, School_ComprehensiveAndTargetedSupport VARCHAR(100)
	, School_ComprehensiveSupport VARCHAR(100)
	, School_TargetedSupport  VARCHAR(100)
	, ConsolidatedMepFundsStatus BIT
	, School_MepProjectType VARCHAR(100)
	-- The fields below are populated and used by the ETL scripts.  
	, LEAOrganizationId INT
	, SchoolOrganizationId INT
	, SEAOrganizationId INT
	, LEA_SpecialEducationProgramOrganizationId INT
	, LEA_CTEProgramOrganizationId INT
	, LEA_TitleIIIProgramOrganizationId INT
	, LEA_NorDProgramOrganizationId INT
	, LEA_TitleIProgramOrganizationId INT
	, LEA_MigrantProgramOrganizationId INT
	, LEA_FosterProgramOrganizationId INT
	, LEA_Section504ProgramOrganizationId INT
	, LEA_K12programOrServiceId INT
	, LEA_K12LeaTitleISupportServiceId INT
	, LEA_HomelessProgramOrganizationId INT
	, School_SpecialEducationProgramOrganizationId INT
	, School_CTEProgramOrganizationId INT
	, School_TitleIIIProgramOrganizationId INT
	, School_NorDProgramOrganizationId INT
	, School_TitleIProgramOrganizationId INT
	, School_MigrantProgramOrganizationId INT
	, School_FosterProgramOrganizationId INT
	, School_Section504ProgramOrganizationId INT
	, School_K12programOrServiceId INT
	, School_HomelessProgramOrganizationId INT
	, NewLEA BIT
	, NewSchool BIT
	, NewSpecialEducationProgram BIT
	, NewCTEProgram BIT
	, NewTitleIIIProgram BIT
	, NewNorDProgram BIT
	, NewTitleIProgram BIT
	, NewMigrantProgram BIT
	, NewFosterProgram BIT
	, NewSection504Program BIT
	, NewHomelessProgram BIT
	, LEA_Identifier_State_ChangedIdentifier BIT
	, LEA_Identifier_State_Identifier_Old VARCHAR(100)
	, School_Identifier_State_ChangedIdentifier BIT
	, School_Identifier_State_Identifier_Old VARCHAR(100)
	, SEAToLEA_OrganizationRelationshipId INT
	, LEAToSchool_OrganizationRelationshipId INT
	, LEAToSpecialEducationProgram_OrganizationRelationshipId INT
	, LEAToCTEProgram_OrganizationRelationshipId INT
	, LEAToTitleIIIProgram_OrganizationRelationshipId INT
	, LEAToNorDProgram_OrganizationRelationshipId INT
	, LEAToTitleIProgram_OrganizationRelationshipId INT
	, LEAToMigrantProgram_OrganizationRelationshipId INT
	, LEAToFosterProgram_OrganizationRelationshipId INT
	, LEAToSection504Program_OrganizationRelationshipId INT
	, LEAToHomelessProgram_OrganizationRelationshipId INT
	, SchoolToSpecialEducationProgram_OrganizationRelationshipId INT
	, SchoolToCTEProgram_OrganizationRelationshipId INT
	, SchoolToTitleIIIProgram_OrganizationRelationshipId INT
	, SchoolToNorDProgram_OrganizationRelationshipId INT
	, SchoolToTitleIProgram_OrganizationRelationshipId INT
	, SchoolToMigrantProgram_OrganizationRelationshipId INT
	, SchoolToFosterProgram_OrganizationRelationshipId INT
	, SchoolToSection504Program_OrganizationRelationshipId INT
	, SchoolToHomelessProgram_OrganizationRelationshipId INT
	, LEA_OrganizationWebsiteId INT
	, School_OrganizationWebsiteId INT
	, RunDateTime DATETIME
	);

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_Identifier_NCES' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_SupervisoryUnionIdentificationNumber' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_Name' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_WebSiteAddress' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_OperationalStatus' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOperationalStatus', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_OperationalStatus' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOperationalStatus', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_UpdatedOperationalStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_UpdatedOperationalStatusEffectiveDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_CharterLeaStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_CharterSchoolIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_Type' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefLeaType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'LEA_Type' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_Identifier_State' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_Identifier_NCES' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_Name' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_WebSiteAddress' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_OperationalStatus' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOperationalStatus', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_OperationalStatus' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOperationalStatus', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_UpdatedOperationalStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_UpdatedOperationalStatusEffectiveDate' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_Type' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefSchoolType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_Type' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_MagnetOrSpecialProgramEmphasisSchool' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_SharedTimeIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_VirtualSchoolStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_NationalSchoolLunchProgramStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_ReconstitutedStatus' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefReconstitutedStatus', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_ReconstitutedStatus' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_CharterSchoolApprovalAgencyType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefCharterSchoolApprovalAgencyType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_CharterSchoolApprovalAgencyType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_CharterSchoolIndicator' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'School_StatePovertyDesignation' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'SchoolImprovementAllocation' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'Organization', @level2type = N'Column', @level2name = 'SchoolYear' 
