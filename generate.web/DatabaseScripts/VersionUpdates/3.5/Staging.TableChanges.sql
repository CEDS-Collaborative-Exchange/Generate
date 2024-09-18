-- Staging table changes
----------------------------------
set nocount on
begin try
	begin transaction

		--Organization
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_CharterSchoolApprovalAgencyType'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			DROP COLUMN School_CharterSchoolApprovalAgencyType
		END

		--Drop SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId if it exists. 
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			DROP COLUMN SchoolToCharterSchoolAuthorizer_OrganizationRelationshipId
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId INT NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId INT NULL
		END
		
		--Staging.CharterSchoolAuthorizer (formerly Staging.CharterSchoolApprovalAgency)
		IF OBJECT_ID('Staging.CharterSchoolApprovalAgency') IS NOT NULL
			EXEC sp_rename 'Staging.CharterSchoolApprovalAgency', 'CharterSchoolAuthorizer'
		;

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolApprovalAgency_Name'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			EXEC sp_rename 'Staging.CharterSchoolAuthorizer.CharterSchoolApprovalAgency_Name', 'CharterSchoolAuthorizer_Name', 'COLUMN';
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolApprovalAgencyId'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			EXEC sp_rename 'Staging.CharterSchoolAuthorizer.CharterSchoolApprovalAgencyId', 'CharterSchoolAuthorizer_Identifier_State', 'COLUMN';
			
			ALTER TABLE Staging.CharterSchoolAuthorizer
			ALTER COLUMN CharterSchoolAuthorizer_Identifier_State VARCHAR(100);
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolApprovalAgencyType'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			EXEC sp_rename 'Staging.CharterSchoolAuthorizer.CharterSchoolApprovalAgencyType', 'CharterSchoolAuthorizerType', 'COLUMN';

			EXEC sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'CharterSchoolAuthorizer', @level2type = N'Column', @level2name = 'CharterSchoolAuthorizerType' 
			EXEC sp_addextendedproperty @name = N'Lookup', @value = N'RefCharterSchoolApprovalAgencyType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'CharterSchoolAuthorizer', @level2type = N'Column', @level2name = 'CharterSchoolAuthorizerType'
		END
		
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolId'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			ALTER TABLE Staging.CharterSchoolAuthorizer
			DROP COLUMN CharterSchoolId
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Id'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			ALTER TABLE Staging.CharterSchoolAuthorizer
			ADD Id INT IDENTITY(1, 1) Primary Key
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolAuthorizerOrganizationId'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			ALTER TABLE Staging.CharterSchoolAuthorizer
			ADD CharterSchoolAuthorizerOrganizationId int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			ALTER TABLE Staging.CharterSchoolAuthorizer
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.CharterSchoolAuthorizer'))
		BEGIN
			ALTER TABLE Staging.CharterSchoolAuthorizer
			ADD RecordEndDateTime datetime NULL
		END

		--CIID-2716
		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'LEA_UpdatedOperationalStatusEffectiveDate'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			EXEC sp_rename 'Staging.Organization.LEA_UpdatedOperationalStatusEffectiveDate', 'LEA_OperationalStatusEffectiveDate', 'COLUMN';
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'School_UpdatedOperationalStatusEffectiveDate'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			EXEC sp_rename 'Staging.Organization.School_UpdatedOperationalStatusEffectiveDate', 'School_OperationalStatusEffectiveDate', 'COLUMN';
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'LEA_UpdatedOperationalStatus'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			DROP COLUMN LEA_UpdatedOperationalStatus
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'School_UpdatedOperationalStatus'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			DROP COLUMN School_UpdatedOperationalStatus
		END

		--CIID-2833
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'NewImmigrantProgram'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD NewImmigrantProgram bit null
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'LEA_ImmigrantProgramOrganizationId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD LEA_ImmigrantProgramOrganizationId int null
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'School_ImmigrantProgramOrganizationId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD School_ImmigrantProgramOrganizationId int null
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'LEAToImmigrantProgram_OrganizationRelationshipId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD LEAToImmigrantProgram_OrganizationRelationshipId int null
		END

		--CIID-2716
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'SchoolToImmigrantProgram_OrganizationRelationshipId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD SchoolToImmigrantProgram_OrganizationRelationshipId int null
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'OrganizationId_Program_Foster'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			DROP COLUMN OrganizationId_Program_Foster
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'OrganizationId_Program_Section504'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			DROP COLUMN OrganizationId_Program_Section504
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'OrganizationId_Program_Immigrant'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			DROP COLUMN OrganizationId_Program_Immigrant
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'OrganizationPersonRoleId_Program_Foster'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			DROP COLUMN OrganizationPersonRoleId_Program_Foster
		END
		
		--CIID-2830
		IF OBJECT_ID('Staging.OrganizationAddress') IS NOT NULL
		BEGIN
			DROP TABLE Staging.OrganizationAddress
		END

		CREATE TABLE [Staging].[OrganizationAddress](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[OrganizationIdentifier] [varchar](60) NULL,
			[OrganizationType] [varchar](100) NULL,
			[AddressTypeForOrganization] [varchar](50) NULL,
			[AddressStreetNumberAndName] [varchar](150) NULL,
			[AddressApartmentRoomOrSuite] [varchar](50) NULL,
			[AddressCity] [varchar](30) NULL,
			[AddressStateAbbreviation] [varchar](2) NULL,
			[AddressPostalCode] [varchar](17) NULL,
			[OrganizationId] [varchar](100) NULL,
			[LocationId] [varchar](100) NULL,
			[RunDateTime] [datetime] NULL,
			[RecordStartDateTime] [datetime] NULL,
			[RecordEndDateTime] [datetime] NULL,
		PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
		) ON [PRIMARY]

		--CIID-3218
		IF EXISTS (SELECT 1 FROM sys.columns WHERE [Name] = N'SeaContact_PersonalTitleOrPrefix'  AND Object_ID = Object_ID(N'Staging.StateDetail'))
		BEGIN
			EXEC sp_rename 'Staging.StateDetail.SeaContact_PersonalTitleOrPrefix', 'SeaContact_PositionTitle', 'COLUMN';
		END

		--CIID-3457	
		-----------------------------------------------------------------------
		--Recreate Staging.Organization and order the fields appropriately
		--	as well as adding the _IsReportedFederally fields
		-----------------------------------------------------------------------
		IF OBJECT_ID('Staging.Organization') IS NOT NULL
		BEGIN
			DROP TABLE Staging.Organization
		END

		CREATE TABLE [Staging].[Organization](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[LEA_Identifier_State] [varchar](100) NULL,
			[LEA_Identifier_NCES] [varchar](100) NULL,
			[LEA_SupervisoryUnionIdentificationNumber] [varchar](100) NULL,
			[LEA_Name] [varchar](100) NULL,
			[LEA_WebSiteAddress] [varchar](300) NULL,
			[LEA_OperationalStatus] [varchar](100) NULL,
			[LEA_OperationalStatusEffectiveDate] [varchar](100) NULL,
			[LEA_CharterLeaStatus] [varchar](100) NULL,
			[LEA_CharterSchoolIndicator] [bit] NULL,
			[LEA_Type] [varchar](100) NULL,
			[LEA_McKinneyVentoSubgrantRecipient] [bit] NULL,
			[LEA_GunFreeSchoolsActReportingStatus] [varchar](100) NULL,
			[LEA_TitleIinstructionalService] [varchar](100) NULL,
			[LEA_TitleIProgramType] [varchar](100) NULL,
			[LEA_K12LeaTitleISupportService] [varchar](100) NULL,
			[LEA_MepProjectType] [varchar](100) NULL,
			[LEA_IsReportedFederally] [bit] NULL,
			[LEA_RecordStartDateTime] [datetime] NULL,
			[LEA_RecordEndDateTime] [datetime] NULL,
			[School_Identifier_State] [varchar](100) NULL,
			[School_Identifier_NCES] [varchar](100) NULL,
			[School_Name] [varchar](100) NULL,
			[School_WebSiteAddress] [varchar](300) NULL,
			[School_OperationalStatus] [varchar](100) NULL,
			[School_OperationalStatusEffectiveDate] [varchar](100) NULL,
			[School_Type] [varchar](100) NULL,
			[School_MagnetOrSpecialProgramEmphasisSchool] [varchar](100) NULL,
			[School_SharedTimeIndicator] [varchar](100) NULL,
			[School_VirtualSchoolStatus] [varchar](100) NULL,
			[School_NationalSchoolLunchProgramStatus] [varchar](100) NULL,
			[School_ReconstitutedStatus] [varchar](100) NULL,
			[School_CharterSchoolIndicator] [bit] NULL,
			[School_CharterSchoolOpenEnrollmentIndicator] [bit] NULL,
			[School_CharterSchoolFEIN] [varchar](100) NULL,
			[School_CharterSchoolFEIN_Update] [varchar](100) NULL,
			[School_CharterContractIDNumber] [varchar](100) NULL,
			[School_CharterContractApprovalDate] [datetime] NULL,
			[School_CharterContractRenewalDate] [datetime] NULL,
			[School_CharterPrimaryAuthorizer] [varchar](100) NULL,
			[School_CharterSecondaryAuthorizer] [varchar](100) NULL,
			[School_StatePovertyDesignation] [varchar](100) NULL,
			[SchoolImprovementAllocation] [money] NULL,
			[School_IndicatorStatusType] [varchar](100) NULL,
			[School_GunFreeSchoolsActReportingStatus] [varchar](100) NULL,
			[School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus] [varchar](100) NULL,
			[School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus] [varchar](100) NULL,
			[School_SchoolDangerousStatus] [varchar](100) NULL,
			[SchoolYear] [varchar](100) NULL,
			[TitleIPartASchoolDesignation] [varchar](100) NULL,
			[School_ComprehensiveAndTargetedSupport] [varchar](100) NULL,
			[School_ComprehensiveSupport] [varchar](100) NULL,
			[School_TargetedSupport] [varchar](100) NULL,
			[ConsolidatedMepFundsStatus] [bit] NULL,
			[School_MepProjectType] [varchar](100) NULL,
			[School_IsReportedFederally] [bit] NULL,
			[School_RecordStartDateTime] [datetime] NULL,
			[School_RecordEndDateTime] [datetime] NULL,
			[SEAOrganizationId] [int] NULL,
			[LEAOrganizationId] [int] NULL,
			[SchoolOrganizationId] [int] NULL,
			[LEA_SpecialEducationProgramOrganizationId] [int] NULL,
			[LEA_CTEProgramOrganizationId] [int] NULL,
			[LEA_TitleIIIProgramOrganizationId] [int] NULL,
			[LEA_NorDProgramOrganizationId] [int] NULL,
			[LEA_TitleIProgramOrganizationId] [int] NULL,
			[LEA_MigrantProgramOrganizationId] [int] NULL,
			[LEA_FosterProgramOrganizationId] [int] NULL,
			[LEA_Section504ProgramOrganizationId] [int] NULL,
			[LEA_K12programOrServiceId] [int] NULL,
			[LEA_K12LeaTitleISupportServiceId] [int] NULL,
			[LEA_HomelessProgramOrganizationId] [int] NULL,
			[School_SpecialEducationProgramOrganizationId] [int] NULL,
			[School_CTEProgramOrganizationId] [int] NULL,
			[School_TitleIIIProgramOrganizationId] [int] NULL,
			[School_NorDProgramOrganizationId] [int] NULL,
			[School_TitleIProgramOrganizationId] [int] NULL,
			[School_MigrantProgramOrganizationId] [int] NULL,
			[School_FosterProgramOrganizationId] [int] NULL,
			[School_Section504ProgramOrganizationId] [int] NULL,
			[School_K12programOrServiceId] [int] NULL,
			[School_HomelessProgramOrganizationId] [int] NULL,
			[NewLEA] [bit] NULL,
			[NewSchool] [bit] NULL,
			[NewSpecialEducationProgram] [bit] NULL,
			[NewCTEProgram] [bit] NULL,
			[NewTitleIIIProgram] [bit] NULL,
			[NewNorDProgram] [bit] NULL,
			[NewTitleIProgram] [bit] NULL,
			[NewMigrantProgram] [bit] NULL,
			[NewFosterProgram] [bit] NULL,
			[NewSection504Program] [bit] NULL,
			[NewHomelessProgram] [bit] NULL,
			[NewImmigrantProgram] [bit] NULL,
			[LEA_Identifier_State_ChangedIdentifier] [bit] NULL,
			[LEA_Identifier_State_Identifier_Old] [varchar](100) NULL,
			[School_Identifier_State_ChangedIdentifier] [bit] NULL,
			[School_Identifier_State_Identifier_Old] [varchar](100) NULL,
			[SEAToLEA_OrganizationRelationshipId] [int] NULL,
			[LEAToSchool_OrganizationRelationshipId] [int] NULL,
			[LEAToSpecialEducationProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToCTEProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToTitleIIIProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToNorDProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToTitleIProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToMigrantProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToFosterProgram_OrganizationRelationshipId] [int] NULL,
			[LEAToSection504Program_OrganizationRelationshipId] [int] NULL,
			[LEAToHomelessProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToSpecialEducationProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToCTEProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToTitleIIIProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToNorDProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToTitleIProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToMigrantProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToFosterProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToSection504Program_OrganizationRelationshipId] [int] NULL,
			[SchoolToHomelessProgram_OrganizationRelationshipId] [int] NULL,
			[LEA_OrganizationWebsiteId] [int] NULL,
			[School_OrganizationWebsiteId] [int] NULL,
			[LEA_OrganizationOperationalStatusId] [int] NULL,
			[School_OrganizationOperationalStatusId] [int] NULL,
			[LEA_ImmigrantProgramOrganizationId] [int] NULL,
			[School_ImmigrantProgramOrganizationId] [int] NULL,
			[LEAToImmigrantProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToImmigrantProgram_OrganizationRelationshipId] [int] NULL,
			[SchoolToPrimaryCharterSchoolAuthorizer_OrganizationRelationshipId] [int] NULL,
			[SchoolToSecondaryCharterSchoolAuthorizer_OrganizationRelationshipId] [int] NULL,
			[RunDateTime] [datetime] NULL,
		PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
		) ON [PRIMARY]

		IF OBJECT_ID('Staging.Organization') IS NOT NULL
		BEGIN
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_NCES'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_SupervisoryUnionIdentificationNumber'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_Name'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_WebSiteAddress'
			EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOperationalStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_OperationalStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_OperationalStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_OperationalStatusEffectiveDate'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_CharterLeaStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_CharterSchoolIndicator'
			EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefLeaType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_Type'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_Type'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'LEA_RecordStartDateTime'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_Identifier_NCES'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_Name'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_WebSiteAddress'
			EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOperationalStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_OperationalStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_OperationalStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_OperationalStatusEffectiveDate'
			EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSchoolType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_Type'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_Type'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_MagnetOrSpecialProgramEmphasisSchool'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_SharedTimeIndicator'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_VirtualSchoolStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_NationalSchoolLunchProgramStatus'
			EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefReconstitutedStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_ReconstitutedStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_ReconstitutedStatus'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_CharterSchoolIndicator'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_StatePovertyDesignation'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'SchoolImprovementAllocation'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
			EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		END

	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off