-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	DECLARE @sql nvarchar(max)

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementId'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD AdditionalTargetedSupportandImprovementId INT NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD AdditionalTargetedSupportandImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementDescription'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD AdditionalTargetedSupportandImprovementDescription VARCHAR(200) NULL
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementEdFactCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		EXEC sp_rename 	'RDS.DimComprehensiveAndTargetedSupports.AdditionalTargetedSupportandImprovementEdFactCode', 
						'AdditionalTargetedSupportandImprovementEdFactsCode', 
						'COLUMN';  
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD AdditionalTargetedSupportandImprovementEdFactsCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementId'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD ComprehensiveSupportImprovementId INT NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD ComprehensiveSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementDescription'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD ComprehensiveSupportImprovementDescription VARCHAR(200) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD ComprehensiveSupportImprovementEdFactsCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementId'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD TargetedSupportImprovementId INT NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD TargetedSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementDescription'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD TargetedSupportImprovementDescription VARCHAR(200) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimComprehensiveAndTargetedSupports'))
	BEGIN
		ALTER TABLE RDS.DimComprehensiveAndTargetedSupports
		ADD TargetedSupportImprovementEdFactsCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReports
		ADD AdditionalTargetedSupportandImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AdditionalTargetedSupportandImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		ADD AdditionalTargetedSupportandImprovementCode VARCHAR(50) NULL
	END	

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReports
		ADD ComprehensiveSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		ADD ComprehensiveSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReports
		ADD TargetedSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		ADD TargetedSupportImprovementCode VARCHAR(50) NULL
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'COMPREHENSIVESUPPORTIDENTIFICATIONTYPEID'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		DROP COLUMN COMPREHENSIVESUPPORTIDENTIFICATIONTYPEID
	END	

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'COMPREHENSIVETARGETEDSUPPORTSCHTYPEID'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		DROP COLUMN COMPREHENSIVETARGETEDSUPPORTSCHTYPEID
	END	

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TARGETEDSUPPORTIDENTIFICATIONTYPEID'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		DROP COLUMN TARGETEDSUPPORTIDENTIFICATIONTYPEID
	END	

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReports
		ADD TargetedSupportImprovementCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportImprovementCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		ADD TargetedSupportImprovementCode VARCHAR(50) NULL
	END
	
	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'NSLPDirectCertificationIndicatorCode'  AND Object_ID = Object_ID(N'RDS.DimStudentStatuses'))
	BEGIN
		ALTER TABLE RDS.DimStudentStatuses
		ADD NSLPDirectCertificationIndicatorCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'NSLPDirectCertificationIndicatorDescription'  AND Object_ID = Object_ID(N'RDS.DimStudentStatuses'))
		BEGIN
			ALTER TABLE RDS.DimStudentStatuses
			ADD NSLPDirectCertificationIndicatorDescription VARCHAR(200) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'NSLPDirectCertificationIndicatorEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimStudentStatuses'))
		BEGIN
			ALTER TABLE RDS.DimStudentStatuses
			ADD NSLPDirectCertificationIndicatorEdFactsCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'NSLPDirectCertificationIndicatorId'  AND Object_ID = Object_ID(N'RDS.DimStudentStatuses'))
		BEGIN
			ALTER TABLE RDS.DimStudentStatuses
			ADD NSLPDirectCertificationIndicatorId INT NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCharterSchoolStatus' AND Type = N'U')
	BEGIN
		CREATE TABLE [RDS].[DimCharterSchoolStatus](
			[DimCharterSchoolStatusId] [int] IDENTITY(1,1) NOT NULL,
			[AppropriationMethodId] [int] NULL,
			[AppropriationMethodCode] [nvarchar](50) NULL,
			[AppropriationMethodDescription] [nvarchar](200) NULL,
			[AppropriationMethodEdFactsCode] [nvarchar](50) NULL,
		 CONSTRAINT [PK_DimCharterSchoolStatus] PRIMARY KEY CLUSTERED 
		(
			[DimCharterSchoolStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimCharterSchoolStatusId' AND Object_ID = Object_ID(N'RDS.[FactOrganizationCounts]'))
	BEGIN
		ALTER TABLE  [RDS].[FactOrganizationCounts] 
		ADD [DimCharterSchoolStatusId] INT NOT NULL DEFAULT (-1)	
	END
	

	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'RDS.FK_FactOrganizationCounts_DimCharterSchoolStatus_DimCharterSchoolStatusId') AND parent_object_id = OBJECT_ID(N'RDS.FactOrganizationCounts'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts]  WITH NOCHECK ADD  CONSTRAINT [FK_FactOrganizationCounts_DimCharterSchoolStatus_DimCharterSchoolStatusId] FOREIGN KEY([DimCharterSchoolStatusId])
		REFERENCES [RDS].[DimCharterSchoolStatus] ([DimCharterSchoolStatusId])

		ALTER TABLE [RDS].[FactOrganizationCounts] CHECK CONSTRAINT [FK_FactOrganizationCounts_DimCharterSchoolStatus_DimCharterSchoolStatusId]
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AppropriationMethodCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReports
		ADD AppropriationMethodCode VARCHAR(50) NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AppropriationMethodCode'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	BEGIN
		ALTER TABLE rds.FactOrganizationCountReportDtos
		ADD AppropriationMethodCode VARCHAR(50) NULL
	END	

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCharterSchoolManagementOrganizations' AND Type = N'U')
	BEGIN
		CREATE TABLE [RDS].[DimCharterSchoolManagementOrganizations](
			[DimCharterSchoolManagementOrganizationId] [int] IDENTITY(1,1) NOT NULL,
			[Name] [nvarchar](max) NULL,
			[StateIdentifier] [nvarchar](max) NULL,
			[State] [nvarchar](max) NULL,
			[StateCode] [nvarchar](max) NULL,
			[OrganizationType] [nvarchar](max) NULL,
			[StateANSICode] [nvarchar](max) NULL,
			[LeaTypeCode] [nvarchar](50) NULL,
			[LeaTypeDescription] [nvarchar](100) NULL,
			[LeaTypeEdFactsCode] [nvarchar](50) NULL,
			[LeaTypeId] [int] NULL,
			[MailingAddressCity] [nvarchar](30) NULL,
			[MailingAddressPostalCode] [nvarchar](17) NULL,
			[MailingAddressState] [nvarchar](50) NULL,
			[MailingAddressStreet] [nvarchar](40) NULL,
			[PhysicalAddressCity] [nvarchar](30) NULL,
			[PhysicalAddressPostalCode] [nvarchar](17) NULL,
			[PhysicalAddressState] [nvarchar](50) NULL,
			[PhysicalAddressStreet] [nvarchar](40) NULL,
			[Telephone] [nvarchar](24) NULL,
			[Website] [nvarchar](300) NULL,
			[OutOfStateIndicator] [bit] NOT NULL,
			[RecordStartDateTime] [datetime] NULL,
			[RecordEndDateTime] [datetime] NULL,
			[SchoolStateIdentifier] [nvarchar](50) NULL,
		 CONSTRAINT [PK_DimCharterSchoolManagementOrganization] PRIMARY KEY CLUSTERED 
		(
			[DimCharterSchoolManagementOrganizationId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


		ALTER TABLE [RDS].[DimCharterSchoolManagementOrganizations] ADD  DEFAULT ((0)) FOR [OutOfStateIndicator]

	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IsApproverAgency'  AND Object_ID = Object_ID(N'rds.DimCharterSchoolApproverAgency'))
	BEGIN
		ALTER TABLE rds.DimCharterSchoolApproverAgency DROP COLUMN IsApproverAgency
	END	

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimCharterSchoolApproverAgency' AND OBJECT_NAME(id) = 'DimCharterSchoolApproverAgency')
	BEGIN
		ALTER TABLE [RDS].[DimCharterSchoolApproverAgency] DROP CONSTRAINT [PK_DimCharterSchoolApproverAgency]
	END

	if exists(select 1 from sys.columns where name = 'DimCharterSchoolApproverAgencyId' AND Object_ID = Object_ID(N'rds.DimCharterSchoolApproverAgency'))
	begin
		exec sp_rename 'rds.DimCharterSchoolApproverAgency.DimCharterSchoolApproverAgencyId', 'DimCharterSchoolAuthorizerId', 'COLUMN'
	end

	IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCharterSchoolApproverAgency' AND Type = N'U')
	BEGIN
		EXEC sp_rename 'rds.DimCharterSchoolApproverAgency', 'DimCharterSchoolAuthorizer'
	END
	
	IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCharterSchoolAuthorizer' AND Type = N'U')
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimCharterSchoolAuthorizer' AND OBJECT_NAME(id) = 'DimCharterSchoolAuthorizer')
		BEGIN
			ALTER TABLE [RDS].[DimCharterSchoolAuthorizer] ADD  CONSTRAINT [PK_DimCharterSchoolAuthorizer] PRIMARY KEY CLUSTERED
			(
				[DimCharterSchoolAuthorizerId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		END
	END 
	

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCharterSchoolApproverAgencyId'  
			AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	BEGIN
		SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
		FROM sys.default_constraints df
			INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
		where t.name = 'FactOrganizationCounts' and c.name = 'DimCharterSchoolApproverAgencyId'

		EXEC sp_executeSql @sql
	END

	SET @sql = ''

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCharterSchoolManagerOrganizationId'  
				AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	BEGIN
		SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
		FROM sys.default_constraints df
			INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
		where t.name = 'FactOrganizationCounts' and c.name = 'DimCharterSchoolManagerOrganizationId'
		
		EXEC sp_executeSql @sql
	END

	SET @sql = ''

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCharterSchoolSecondaryApproverAgencyId'  
				AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	BEGIN
		SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
		FROM sys.default_constraints df
			INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
		where t.name = 'FactOrganizationCounts' and c.name = 'DimCharterSchoolSecondaryApproverAgencyId'

		EXEC sp_executeSql @sql
	END

	SET @sql = ''

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCharterSchoolUpdatedManagerOrganizationId'  
				AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	BEGIN
		SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
		FROM sys.default_constraints df
			INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
		where t.name = 'FactOrganizationCounts' and c.name = 'DimCharterSchoolUpdatedManagerOrganizationId'

		EXEC sp_executeSql @sql
	END

	SET @sql = ''

	if exists(select 1 from sys.columns where name = 'DimCharterSchoolApproverAgencyId' AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	begin
		exec sp_rename 'rds.FactOrganizationCounts.DimCharterSchoolApproverAgencyId', 'DimCharterSchoolAuthorizerId', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'DimCharterSchoolSecondaryApproverAgencyId' AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	begin
		exec sp_rename 'rds.FactOrganizationCounts.DimCharterSchoolSecondaryApproverAgencyId', 'DimCharterSchoolSecondaryAuthorizerId', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'DimCharterSchoolManagerOrganizationId' AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	begin
		exec sp_rename 'rds.FactOrganizationCounts.DimCharterSchoolManagerOrganizationId', 'DimCharterSchoolManagementOrganizationId', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'DimCharterSchoolUpdatedManagerOrganizationId' AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
	begin
		exec sp_rename 'rds.FactOrganizationCounts.DimCharterSchoolUpdatedManagerOrganizationId', 'DimCharterSchoolUpdatedManagementOrganizationId', 'COLUMN'
	end

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'CharterAuth_default' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT CharterAuth_default  DEFAULT ((0)) 
		FOR [DimCharterSchoolAuthorizerId]
	END

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'CharterSecAuth_default' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT CharterSecAuth_default DEFAULT ((0)) 
		FOR [DimCharterSchoolSecondaryAuthorizerId]
	END

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'CharterManagement_default' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT CharterManagement_default DEFAULT ((0)) 
		FOR [DimCharterSchoolManagementOrganizationId]
	END

	IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'CharterUpdatedManagement_default' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD CONSTRAINT CharterUpdatedManagement_default DEFAULT ((0)) 
		FOR [DimCharterSchoolUpdatedManagementOrganizationId]
	END

	if exists(select 1 from sys.columns where name = 'CharterSchoolAuthorizerIdPrimary' AND Object_ID = Object_ID(N'rds.FactOrganizationCountReports'))
	begin
		exec sp_rename 'rds.FactOrganizationCountReports.CharterSchoolAuthorizerIdPrimary', 'CharterSchoolAuthorizer', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'CharterSchoolAuthorizerIdSecondary' AND Object_ID = Object_ID(N'rds.FactOrganizationCountReports'))
	begin
		exec sp_rename 'rds.FactOrganizationCountReports.CharterSchoolAuthorizerIdSecondary', 'CharterSchoolSecondaryAuthorizer', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'CHARTERSCHOOLMANAGERORGANIZATION' AND Object_ID = Object_ID(N'rds.FactOrganizationCountReports'))
	begin
		exec sp_rename 'rds.FactOrganizationCountReports.CHARTERSCHOOLMANAGERORGANIZATION', 'CharterSchoolManagementOrganization', 'COLUMN'
	end

	if exists(select 1 from sys.columns where name = 'CHARTERSCHOOLUPDATEDMANAGERORGANIZATION' AND Object_ID = Object_ID(N'rds.FactOrganizationCountReports'))
	begin
		exec sp_rename 'rds.FactOrganizationCountReports.CHARTERSCHOOLUPDATEDMANAGERORGANIZATION', 'CharterSchoolUpdatedManagementOrganization', 'COLUMN'
	end

	IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCharterSchoolAuthorizer' AND Type = N'U')
	BEGIN
		EXEC sp_rename 'rds.DimCharterSchoolAuthorizer', 'DimCharterSchoolAuthorizers'
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolManagementOrganizations'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolManagementOrganizations.LeaTypeCode', 'CharterSchoolManagementOrganizationCode', 'COLUMN'
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeEdFactsCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolManagementOrganizations'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolManagementOrganizations.LeaTypeEdFactsCode', 'CharterSchoolManagementOrganizationTypeEdfactsCode', 'COLUMN'
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeDescription' AND Object_ID = Object_ID(N'rds.DimCharterSchoolManagementOrganizations'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolManagementOrganizations.LeaTypeDescription', 'CharterSchoolManagementOrganizationTypeDescription', 'COLUMN'
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationType'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolManagementOrganizations'))
	BEGIN
		ALTER TABLE rds.DimCharterSchoolManagementOrganizations
		DROP COLUMN OrganizationType
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaTypeId'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolManagementOrganizations'))
	BEGIN
		ALTER TABLE rds.DimCharterSchoolManagementOrganizations
		DROP COLUMN LeaTypeId
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolStateIdentifier'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolManagementOrganizations'))
	BEGIN
		ALTER TABLE RDS.DimCharterSchoolManagementOrganizations
		DROP COLUMN SchoolStateIdentifier 
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'EmployerIdentificationNumber'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolManagementOrganizations'))
	BEGIN
		ALTER TABLE RDS.DimCharterSchoolManagementOrganizations
		ADD EmployerIdentificationNumber VARCHAR(50) NULL
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeCode', 'CharterSchoolAuthorizerTypeCode', 'COLUMN'
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeEdFactsCode' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeEdFactsCode', 'CharterSchoolAuthorizerTypeEdfactsCode', 'COLUMN'
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE NAME = 'LeaTypeDescription' AND Object_ID = Object_ID(N'rds.DimCharterSchoolAuthorizers'))
	BEGIN
		EXEC SP_RENAME 'rds.DimCharterSchoolAuthorizers.LeaTypeDescription', 'CharterSchoolAuthorizerTypeDescription', 'COLUMN'
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationType'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers'))
	BEGIN
		ALTER TABLE rds.DimCharterSchoolAuthorizers
		DROP COLUMN OrganizationType
	END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaTypeID'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers'))
	BEGIN
		ALTER TABLE rds.DimCharterSchoolAuthorizers
		DROP COLUMN LeaTypeID
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