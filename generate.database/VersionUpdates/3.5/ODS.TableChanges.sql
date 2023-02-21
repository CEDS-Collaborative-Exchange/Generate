-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefTargetedSupportImprovement' AND Type = N'U')
	BEGIN
		CREATE TABLE [ODS].[RefTargetedSupportImprovement](
		[RefTargetedSupportImprovementId] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](100) NULL,
		[Code] [nvarchar](50) NULL,
		[Definition] [nvarchar](max) NULL,
		[RefJurisdictionId] [int] NULL,
		[SortOrder] [decimal](5, 2) NULL,
		 CONSTRAINT [PK_RefTargetedSupportImprovement] PRIMARY KEY CLUSTERED 
		(
			[RefTargetedSupportImprovementId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


		ALTER TABLE [ODS].[RefTargetedSupportImprovement]  WITH CHECK ADD  CONSTRAINT [FK_RefTargetedSupportImprovement_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])


		ALTER TABLE [ODS].[RefTargetedSupportImprovement] CHECK CONSTRAINT [FK_RefTargetedSupportImprovement_Org]

	END

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefAdditionalTargetedSupport' AND Type = N'U')
	BEGIN

		CREATE TABLE [ODS].[RefAdditionalTargetedSupport](
		[RefAdditionalTargetedSupportId] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](100) NULL,
		[Code] [nvarchar](50) NULL,
		[Definition] [nvarchar](max) NULL,
		[RefJurisdictionId] [int] NULL,
		[SortOrder] [decimal](5, 2) NULL,
		 CONSTRAINT [PK_RefAdditionalTargetedSupport] PRIMARY KEY CLUSTERED 
		(
			[RefAdditionalTargetedSupportId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


		ALTER TABLE [ODS].[RefAdditionalTargetedSupport]  WITH CHECK ADD  CONSTRAINT [FK_RefAdditionalTargetedSupport_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])


		ALTER TABLE [ODS].[RefAdditionalTargetedSupport] CHECK CONSTRAINT [FK_RefAdditionalTargetedSupport_Org]

	END

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefComprehensiveSupportImprovement' AND Type = N'U')
	BEGIN
		CREATE TABLE [ODS].[RefComprehensiveSupportImprovement](
		[RefComprehensiveSupportImprovementId] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](100) NULL,
		[Code] [nvarchar](50) NULL,
		[Definition] [nvarchar](max) NULL,
		[RefJurisdictionId] [int] NULL,
		[SortOrder] [decimal](5, 2) NULL,
		 CONSTRAINT [PK_RefComprehensiveSupportImprovement] PRIMARY KEY CLUSTERED 
		(
			[RefComprehensiveSupportImprovementId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


		ALTER TABLE [ODS].[RefComprehensiveSupportImprovement]  WITH CHECK ADD  CONSTRAINT [FK_RefComprehensiveSupportImprovement_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])


		ALTER TABLE [ODS].[RefComprehensiveSupportImprovement] CHECK CONSTRAINT [FK_RefComprehensiveSupportImprovement_Org]

	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefComprehensiveSupportImprovementId'  AND Object_ID = Object_ID(N'ODS.K12SchoolStatus'))
	BEGIN
			ALTER TABLE ODS.K12SchoolStatus
			ADD RefComprehensiveSupportImprovementId INT NULL
	END

	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ODS.FK_K12SchoolStatus_RefComprehensiveSupportImprovement') AND parent_object_id = OBJECT_ID(N'ODS.K12SchoolStatus'))
	BEGIN
		ALTER TABLE [ODS].[K12SchoolStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveSupportImprovement] FOREIGN KEY([RefComprehensiveSupportImprovementId])
		REFERENCES [ODS].[RefComprehensiveSupportImprovement] ([RefComprehensiveSupportImprovementId])

		ALTER TABLE [ODS].[K12SchoolStatus] CHECK CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveSupportImprovement]
	END 

 	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefTargetedSupportImprovementId'  AND Object_ID = Object_ID(N'ODS.K12SchoolStatus'))
	BEGIN
			ALTER TABLE ODS.K12SchoolStatus
			ADD RefTargetedSupportImprovementId INT NULL
	END

	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ODS.FK_K12SchoolStatus_RefTargetedSupportImprovement') AND parent_object_id = OBJECT_ID(N'ODS.K12SchoolStatus'))
	BEGIN
		ALTER TABLE [ODS].[K12SchoolStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolStatus_RefTargetedSupportImprovement] FOREIGN KEY([RefTargetedSupportImprovementId])
		REFERENCES [ODS].[RefTargetedSupportImprovement] ([RefTargetedSupportImprovementId])

		ALTER TABLE [ODS].[K12SchoolStatus] CHECK CONSTRAINT [FK_K12SchoolStatus_RefTargetedSupportImprovement]
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefAdditionalTargetedSupportId'  AND Object_ID = Object_ID(N'ODS.K12SchoolStatus'))
	BEGIN
			ALTER TABLE ODS.K12SchoolStatus
			ADD RefAdditionalTargetedSupportId INT NULL
	END

	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'ODS.FK_K12SchoolStatus_RefAdditionalTargetedSupport') AND parent_object_id = OBJECT_ID(N'ODS.K12SchoolStatus'))
	BEGIN
		ALTER TABLE [ODS].[K12SchoolStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolStatus_RefAdditionalTargetedSupport] FOREIGN KEY([RefAdditionalTargetedSupportId])
		REFERENCES [ODS].[RefAdditionalTargetedSupport] ([RefAdditionalTargetedSupportId])

		ALTER TABLE [ODS].[K12SchoolStatus] CHECK CONSTRAINT [FK_K12SchoolStatus_RefAdditionalTargetedSupport]
	END 

	

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'K12SeaId'  AND Object_ID = Object_ID(N'ODS.K12Sea'))
	BEGIN
			IF EXISTS(SELECT 1 from sysconstraints WHERE OBJECT_NAME(constid) = 'FK_K12SEAFederalFunds_K12SEA')
			BEGIN
				ALTER TABLE [ODS].[K12SeaFederalFunds] DROP CONSTRAINT [FK_K12SEAFederalFunds_K12SEA]
			END

			IF EXISTS(SELECT 1 from sysconstraints WHERE OBJECT_NAME(constid) = 'XPKK12Sea')
			BEGIN
				ALTER TABLE [ODS].[K12Sea] DROP CONSTRAINT [XPKK12Sea]
			END


			ALTER TABLE ODS.K12Sea
			ADD K12SeaId INT IDENTITY(1,1) NOT NULL PRIMARY KEY

			IF NOT EXISTS(SELECT 1 from sysconstraints WHERE OBJECT_NAME(constid) = 'FK_K12Sea_Organization')
			BEGIN
				ALTER TABLE [ODS].[K12Sea]  WITH CHECK ADD  CONSTRAINT [FK_K12Sea_Organization] FOREIGN KEY([OrganizationId])
				REFERENCES [ODS].[Organization] ([OrganizationId])
				ON UPDATE CASCADE
				ON DELETE CASCADE

				ALTER TABLE [ODS].[K12Sea] CHECK CONSTRAINT [FK_K12Sea_Organization]
			END

			IF NOT EXISTS(SELECT 1 from sysconstraints WHERE OBJECT_NAME(constid) = 'FK_K12SEA_RefStateANSICode')
			BEGIN
				ALTER TABLE [ODS].[K12Sea]  WITH CHECK ADD  CONSTRAINT [FK_K12SEA_RefStateANSICode] FOREIGN KEY([RefStateANSICode])
				REFERENCES [ODS].[RefStateANSICode] ([Code])


				ALTER TABLE [ODS].[K12Sea] CHECK CONSTRAINT [FK_K12SEA_RefStateANSICode]

			END

			
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.K12Sea'))
	BEGIN
			ALTER TABLE ODS.K12Sea
			ADD RecordStartDateTime datetime NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.K12Sea'))
	BEGIN
			ALTER TABLE ODS.K12Sea
			ADD RecordEndDateTime datetime NULL
	END

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'RefStateAppropriationMethod' AND Type = N'U')
	BEGIN

		CREATE TABLE [ODS].[RefStateAppropriationMethod](
		[RefStateAppropriationMethodId] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](100) NOT NULL,
		[Code] [nvarchar](50) NULL,
		[Definition] [nvarchar](4000) NULL,
		[RefJurisdictionId] [int] NULL,
		[SortOrder] [decimal](5, 2) NULL,
		 CONSTRAINT [PK_RefStateAppropriationMethod] PRIMARY KEY CLUSTERED 
		(
			[RefStateAppropriationMethodId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [ODS].[RefStateAppropriationMethod]  WITH CHECK ADD  CONSTRAINT [FK_RefStateAppropriationMethod_Organization] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])

	END

	IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefStateAppropriationMethodId'  AND Object_ID = Object_ID(N'ODS.K12School'))
	BEGIN
			ALTER TABLE ODS.K12School
			ADD RefStateAppropriationMethodId int null

			ALTER TABLE [ODS].[K12School]  WITH CHECK ADD  CONSTRAINT [FK_K12School_RefStateAppropriationMethod] FOREIGN KEY([RefStateAppropriationMethodId])
			REFERENCES [ODS].[RefStateAppropriationMethod] ([RefStateAppropriationMethodId])
	END

	--ODS.K12CharterSchoolAuthorizer (formerly ODS.K12CharterSchoolApprovalAgency) 
	IF OBJECT_ID('ODS.K12CharterSchoolApprovalAgency') IS NOT NULL
		EXEC sp_rename 'ODS.K12CharterSchoolApprovalAgency', 'K12CharterSchoolAuthorizer'
	;

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'K12CharterSchoolApprovalAgencyId'  AND Object_ID = Object_ID(N'ODS.K12CharterSchoolAuthorizer'))
	BEGIN
		EXEC sp_rename 'ODS.K12CharterSchoolAuthorizer.K12CharterSchoolApprovalAgencyId', 'K12CharterSchoolAuthorizerId', 'COLUMN';
	END
	
	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefCharterSchoolApprovalAgencyTypeId'  AND Object_ID = Object_ID(N'ODS.K12CharterSchoolAuthorizer'))
	BEGIN
		EXEC sp_rename 'ODS.K12CharterSchoolAuthorizer.RefCharterSchoolApprovalAgencyTypeId', 'RefCharterSchoolAuthorizerTypeId', 'COLUMN';
	END

	IF (OBJECT_ID('ODS.PK__K12CharterSchoolApprovalAgency') IS NOT NULL)
		EXEC sp_rename 'ODS.PK__K12CharterSchoolApprovalAgency', 'PK__K12CharterSchoolAuthorizer';

	IF (OBJECT_ID('ODS.FK_K12CharterSchoolApprovalAgency_Organization', 'F') IS NOT NULL)
		EXEC sp_rename 'ODS.FK_K12CharterSchoolApprovalAgency_Organization', 'FK_K12CharterSchoolAuthorizer_Organization';	

	IF (OBJECT_ID('ODS.FK_Organization_K12CharterSchoolApprovalAgency', 'F') IS NOT NULL)
		EXEC sp_rename 'ODS.FK_Organization_K12CharterSchoolApprovalAgency', 'FK_Organization_K12CharterSchoolAuthorizer';	

	--ODS.RefCharterSchoolAuthorizerType (formerly ODS.RefCharterSchoolApprovalAgencyType) 
	IF OBJECT_ID('ODS.RefCharterSchoolApprovalAgencyType') IS NOT NULL
		EXEC sp_rename 'ODS.RefCharterSchoolApprovalAgencyType', 'RefCharterSchoolAuthorizerType'
	;

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RefCharterSchoolApprovalAgencyTypeId'  AND Object_ID = Object_ID(N'ODS.RefCharterSchoolAuthorizerType'))
	BEGIN
		EXEC sp_rename 'ODS.RefCharterSchoolAuthorizerType.RefCharterSchoolApprovalAgencyTypeId', 'RefCharterSchoolAuthorizerTypeId', 'COLUMN';
	END

	--ODS.K12School
	IF (OBJECT_ID('ODS.FK_K12School_K12CharterSchoolApprovalAgency', 'F') IS NOT NULL)
		BEGIN
			ALTER TABLE ODS.K12School DROP CONSTRAINT FK_K12School_K12CharterSchoolApprovalAgency
		END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'K12CharterSchoolApprovalAgencyId'  AND Object_ID = Object_ID(N'ODS.K12School'))
	BEGIN
	
		ALTER TABLE ODS.K12School
		DROP COLUMN K12CharterSchoolApprovalAgencyId
		
	END

	IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Name' AND Object_ID = Object_ID(N'ODS.OrganizationDetail'))
	BEGIN
		ALTER TABLE ODS.OrganizationDetail
		ALTER COLUMN [Name] NVARCHAR(128) NULL
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