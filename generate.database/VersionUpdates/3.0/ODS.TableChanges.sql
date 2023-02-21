-- Release-Specific table changes for the ODS schema
-- e.g. changes to the CEDS data model
----------------------------------
set nocount on
begin try
	begin transaction
	------------------------
	-- Place code here
	------------------------

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefIndicatorStatusType' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefIndicatorStatusType](
			[RefIndicatorStatusTypeId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefIndicatorStatusType] PRIMARY KEY CLUSTERED 
		(
			[RefIndicatorStatusTypeId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefIndicatorStatusType]  WITH CHECK ADD  CONSTRAINT [FK_RefIndicatorStatusType_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefIndicatorStatusSubgroupType' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefIndicatorStatusSubgroupType](
			[RefIndicatorStatusSubgroupTypeId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefIndicatorStatusSubgroupType] PRIMARY KEY CLUSTERED 
		(
			[RefIndicatorStatusSubgroupTypeId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [ODS].[RefIndicatorStatusSubgroupType]  WITH CHECK ADD  CONSTRAINT [FK_RefIndicatorStatusSubgroupType_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefIndicatorStateDefinedStatus' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefIndicatorStateDefinedStatus](
			[RefIndicatorStateDefinedStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefIndicatorStateDefinedStatus] PRIMARY KEY CLUSTERED 
		(
			[RefIndicatorStateDefinedStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefIndicatorStateDefinedStatus]  WITH CHECK ADD  CONSTRAINT [FK_RefIndicatorStateDefinedStatus_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'K12SchoolIndicatorStatus' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[K12SchoolIndicatorStatus](
			K12SchoolIndicatorStatusId int IDENTITY(1,1) NOT NULL,
			K12SchoolId int not NULL, 
			RefIndicatorStatusTypeId int not NULL, 
			RefIndicatorStateDefinedStatusId int NULL, 
			RefIndicatorStatusSubgroupTypeId int NULL,
			IndicatorStatusSubgroup nvarchar(100) NULL, 
			IndicatorStatus nvarchar(100) NULL,
			RecordStartDateTime datetime null,
			RecordEndDateTime datetime null
			CONSTRAINT [PK_K12SchoolIndicatorStatus] PRIMARY KEY CLUSTERED 
		(
			[K12SchoolIndicatorStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [ODS].[K12SchoolIndicatorStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolIndicatorStatus_K12School] FOREIGN KEY([K12SchoolId])
			REFERENCES [ODS].[K12School] ([K12SchoolId])

		ALTER TABLE [ODS].[K12SchoolIndicatorStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolIndicatorStatus_RefIndicatorStatusType] FOREIGN KEY([RefIndicatorStatusTypeId])
			REFERENCES [ODS].[RefIndicatorStatusType] ([RefIndicatorStatusTypeId])

		ALTER TABLE [ODS].[K12SchoolIndicatorStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolIndicatorStatus_RefIndicatorStateDefinedStatus] FOREIGN KEY([RefIndicatorStateDefinedStatusId])
			REFERENCES [ODS].[RefIndicatorStateDefinedStatus] ([RefIndicatorStateDefinedStatusId])

		ALTER TABLE [ODS].[K12SchoolIndicatorStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolIndicatorStatus_RefIndicatorStatusSubgroupType] FOREIGN KEY([RefIndicatorStatusSubgroupTypeId])
			REFERENCES [ODS].[RefIndicatorStatusSubgroupType] ([RefIndicatorStatusSubgroupTypeId])
	END

	-- С203
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefUnexperiencedStatus' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefUnexperiencedStatus](
			[RefUnexperiencedStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefUnexperiencedStatus] PRIMARY KEY CLUSTERED 
		(
			[RefUnexperiencedStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefUnexperiencedStatus]  WITH CHECK ADD  CONSTRAINT [FK_RefUnexperiencedStatus_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefEmergencyOrProvisionalCredentialStatus' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefEmergencyOrProvisionalCredentialStatus](
			[RefEmergencyOrProvisionalCredentialStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefEmergencyOrProvisionalCredentialStatus] PRIMARY KEY CLUSTERED 
		(
			[RefEmergencyOrProvisionalCredentialStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefEmergencyOrProvisionalCredentialStatus]  WITH CHECK ADD  CONSTRAINT [FK_RefEmergencyOrProvisionalCredentialStatus_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefOutOfFieldStatus' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefOutOfFieldStatus](
			[RefOutOfFieldStatusId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefOutOfFieldStatus] PRIMARY KEY CLUSTERED 
		(
			[RefOutOfFieldStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefOutOfFieldStatus]  WITH CHECK ADD  CONSTRAINT [FK_RefOutOfFieldStatus_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefUnexperiencedStatusId' AND Object_ID = Object_ID(N'[ODS].[K12StaffAssignment]'))
		ALTER TABLE [ODS].[K12StaffAssignment] ADD RefUnexperiencedStatusId int

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefEmergencyOrProvisionalCredentialStatusId' AND Object_ID = Object_ID(N'[ODS].[K12StaffAssignment]'))
		ALTER TABLE [ODS].[K12StaffAssignment] ADD RefEmergencyOrProvisionalCredentialStatusId int

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefOutOfFieldStatusId' AND Object_ID = Object_ID(N'[ODS].[K12StaffAssignment]'))
		ALTER TABLE [ODS].[K12StaffAssignment] ADD RefOutOfFieldStatusId int

	-- c206
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefComprehensiveAndTargetedSupport' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefComprehensiveAndTargetedSupport](
			[RefComprehensiveAndTargetedSupportId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefComprehensiveAndTargetedSupport] PRIMARY KEY CLUSTERED 
		(
			[RefComprehensiveAndTargetedSupportId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefComprehensiveAndTargetedSupport]  WITH CHECK ADD  CONSTRAINT [FK_RefComprehensiveAndTargetedSupport_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefComprehensiveSupport' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefComprehensiveSupport](
			[RefComprehensiveSupportId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefComprehensiveSupport] PRIMARY KEY CLUSTERED 
		(
			[RefComprehensiveSupportId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefComprehensiveSupport]  WITH CHECK ADD  CONSTRAINT [FK_RefComprehensiveSupport_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefTargetedSupport' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefTargetedSupport](
			[RefTargetedSupportId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefTargetedSupport] PRIMARY KEY CLUSTERED 
		(
			[RefTargetedSupportId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefTargetedSupport]  WITH CHECK ADD  CONSTRAINT [FK_RefTargetedSupport_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefComprehensiveAndTargetedSupportId' AND Object_ID = Object_ID(N'[ODS].[K12SchoolStatus]'))
		ALTER TABLE [ODS].[K12SchoolStatus] ADD RefComprehensiveAndTargetedSupportId int

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefComprehensiveSupportId' AND Object_ID = Object_ID(N'[ODS].[K12SchoolStatus]'))
		ALTER TABLE [ODS].[K12SchoolStatus] ADD RefComprehensiveSupportId int

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefTargetedSupportId' AND Object_ID = Object_ID(N'[ODS].[K12SchoolStatus]'))
		ALTER TABLE [ODS].[K12SchoolStatus] ADD RefTargetedSupportId int

	-- c202
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefIndicatorStatusCustomType' AND Type = N'U')
	BEGIN		
		CREATE TABLE [ODS].[RefIndicatorStatusCustomType](
			[RefIndicatorStatusCustomTypeId] [int] IDENTITY(1,1) NOT NULL,
			[Description] nvarchar(100) NULL, 
			[Code] nvarchar(50) NULL, 
			[Definition] nvarchar(max) NULL,
			[RefJurisdictionId] int NULL, 
			[SortOrder] [decimal](5, 2) NULL
			CONSTRAINT [PK_RefIndicatorStatusCustomType] PRIMARY KEY CLUSTERED 
		(
			[RefIndicatorStatusCustomTypeId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
		ALTER TABLE [ODS].[RefIndicatorStatusCustomType]  WITH CHECK ADD  CONSTRAINT [FK_RefIndicatorStatusCustomType_Org] FOREIGN KEY([RefJurisdictionId])
		REFERENCES [ODS].[Organization] ([OrganizationId])

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'RefIndicatorStatusCustomTypeId' AND Object_ID = Object_ID(N'[ODS].[K12SchoolIndicatorStatus]'))
			ALTER TABLE [ODS].[K12SchoolIndicatorStatus] ADD RefIndicatorStatusCustomTypeId int
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

