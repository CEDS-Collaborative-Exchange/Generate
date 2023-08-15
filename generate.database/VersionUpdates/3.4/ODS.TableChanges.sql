-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationOperationalStatus'))
		BEGIN
			ALTER TABLE ODS.OrganizationOperationalStatus
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationOperationalStatus'))
		BEGIN
			ALTER TABLE ODS.OrganizationOperationalStatus
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ods.K12SchoolGradeOffered'))
		BEGIN
			ALTER TABLE ods.K12SchoolGradeOffered
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ods.K12SchoolGradeOffered'))
		BEGIN
			ALTER TABLE ods.K12SchoolGradeOffered
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationIdentifier'))
		BEGIN
			ALTER TABLE ODS.OrganizationIdentifier
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationIdentifier'))
		BEGIN
			ALTER TABLE ODS.OrganizationIdentifier
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationTelephone'))
		BEGIN
			ALTER TABLE ODS.OrganizationTelephone
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationTelephone'))
		BEGIN
			ALTER TABLE ODS.OrganizationTelephone
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationWebsite'))
		BEGIN
			ALTER TABLE ODS.OrganizationWebsite
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationWebsite'))
		BEGIN
			ALTER TABLE ODS.OrganizationWebsite
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationRelationship'))
		BEGIN
			ALTER TABLE ODS.OrganizationRelationship
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationRelationship'))
		BEGIN
			ALTER TABLE ODS.OrganizationRelationship
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationEmail'))
		BEGIN
			ALTER TABLE ODS.OrganizationEmail
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationEmail'))
		BEGIN
			ALTER TABLE ODS.OrganizationEmail
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationLocation'))
		BEGIN
			ALTER TABLE ODS.OrganizationLocation
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'ODS.OrganizationLocation'))
		BEGIN
			ALTER TABLE ODS.OrganizationLocation
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[OrganizationPersonRoleRelationship]') AND type in (N'U'))
		BEGIN
			CREATE TABLE [ODS].[OrganizationPersonRoleRelationship](
				[OrganizationPersonRoleRelationshipId] [int] IDENTITY(1,1) NOT NULL,
				[OrganizationPersonRoleId] [int] NOT NULL,
				[OrganizationPersonRoleId_Parent] [int] NOT NULL,
				[RecordStartDateTime] [datetime] NULL,
				[RecordEndDateTime] [datetime] NULL,
			 CONSTRAINT [PK_OrganizationPersonRoleRelationship] PRIMARY KEY CLUSTERED 
			(
				[OrganizationPersonRoleRelationshipId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			 

			ALTER TABLE [ODS].[OrganizationPersonRoleRelationship]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationPersonRoleRelationship_OrganizationPersonRole] FOREIGN KEY([OrganizationPersonRoleId])
			REFERENCES [ODS].[OrganizationPersonRole] ([OrganizationPersonRoleId])
			 

			ALTER TABLE [ODS].[OrganizationPersonRoleRelationship] CHECK CONSTRAINT [FK_OrganizationPersonRoleRelationship_OrganizationPersonRole]			 

			ALTER TABLE [ODS].[OrganizationPersonRoleRelationship]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationPersonRoleRelationship_OrganizationPersonRole_Parent] FOREIGN KEY([OrganizationPersonRoleId_Parent])
			REFERENCES [ODS].[OrganizationPersonRole] ([OrganizationPersonRoleId])			 

			ALTER TABLE [ODS].[OrganizationPersonRoleRelationship] CHECK CONSTRAINT [FK_OrganizationPersonRoleRelationship_OrganizationPersonRole_Parent]
		END

		IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[OrganizationWebsite]') AND type in (N'U'))
		BEGIN
			DROP TABLE [ODS].[OrganizationWebsite]
		END	

		BEGIN			
			CREATE TABLE [ODS].[OrganizationWebsite](
				[OrganizationWebsiteId] [int] IDENTITY(1,1) NOT NULL,
				[OrganizationId] [int] NOT NULL,
				[Website] [nvarchar](300) NULL,
				[RecordStartDateTime] [datetime] NULL,
				[RecordEndDateTime] [datetime] NULL,
			 CONSTRAINT [PK_OrganizationWebsite] PRIMARY KEY CLUSTERED 
			(
				[OrganizationWebsiteId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [ODS].[OrganizationWebsite]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationWebsite_Organization] FOREIGN KEY([OrganizationId])
			REFERENCES [ODS].[Organization] ([OrganizationId])

			ALTER TABLE [ODS].[OrganizationWebsite] CHECK CONSTRAINT [FK_OrganizationWebsite_Organization]
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