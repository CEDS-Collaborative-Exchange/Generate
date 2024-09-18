-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimFactType_DimensionTables' AND Type = N'U')
		BEGIN
			
			CREATE TABLE [RDS].[DimFactType_DimensionTables](
				[DimFactTypeId] [int] NOT NULL,
				[DimensionTableId] [int] NOT NULL,
			 CONSTRAINT [PK_DimFactType_DimensionTables] PRIMARY KEY CLUSTERED 
			(
				[DimFactTypeId] ASC,
				[DimensionTableId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [RDS].[DimFactType_DimensionTables]  WITH CHECK ADD  CONSTRAINT [FK_DimFactType_DimensionTables_DimensionTables_DimensionTableId] FOREIGN KEY([DimensionTableId])
			REFERENCES [App].[DimensionTables]([DimensionTableId])
			ON DELETE CASCADE

			ALTER TABLE [RDS].[DimFactType_DimensionTables] CHECK CONSTRAINT [FK_DimFactType_DimensionTables_DimensionTables_DimensionTableId]

			ALTER TABLE [RDS].[DimFactType_DimensionTables]  WITH CHECK ADD  CONSTRAINT [FK_DimFactType_DimensionTables_DimFactTypes_DimFactTypeId] FOREIGN KEY([DimFactTypeId])
			REFERENCES [RDS].[DimFactTypes]([DimFactTypeId])
			ON DELETE CASCADE

			ALTER TABLE [RDS].[DimFactType_DimensionTables] CHECK CONSTRAINT [FK_DimFactType_DimensionTables_DimFactTypes_DimFactTypeId]

		END

		
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'MailingAddressCity'  AND Object_ID = Object_ID(N'rds.DimSeas'))
		BEGIN
				Alter TABLE rds.DimSeas 
				ADD  MailingAddressCity nvarchar(30) NULL,
					 MailingAddressPostalCode nvarchar(17) NULL,
					 MailingAddressState nvarchar(50) NULL,
					 MailingAddressStreet nvarchar(40) NULL,
					 PhysicalAddressCity nvarchar(30) NULL,
					 PhysicalAddressPostalCode nvarchar(17) NULL,
					 PhysicalAddressState nvarchar(50) NULL,
					 PhysicalAddressStreet nvarchar(40) NULL,
					 Telephone nvarchar(24) NULL,
					 Website nvarchar(300) NULL


				Alter TABLE rds.DimLeas
				ADD  
					 LeaTypeCode nvarchar(50) NULL,
					 LeaTypeDescription nvarchar(100) NULL,
					 LeaTypeEdFactsCode nvarchar(50) NULL,
					 LeaTypeId int NULL,
					 MailingAddressCity nvarchar(30) NULL,
					 MailingAddressPostalCode nvarchar(17) NULL,
					 MailingAddressState nvarchar(50) NULL,
					 MailingAddressStreet nvarchar(40) NULL,
					 PhysicalAddressCity nvarchar(30) NULL,
					 PhysicalAddressPostalCode nvarchar(17) NULL,
					 PhysicalAddressState nvarchar(50) NULL,
					 PhysicalAddressStreet nvarchar(40) NULL,
					 Telephone nvarchar(24) NULL,
					 Website nvarchar(300) NULL,
					 OutOfStateIndicator bit NOT NULL default(0)


				Alter TABLE rds.DimSchools
				ADD  
					 LeaTypeCode nvarchar(50) NULL,
					 LeaTypeDescription nvarchar(100) NULL,
					 LeaTypeEdFactsCode nvarchar(50) NULL,
					 LeaTypeId int NULL,
					 SchoolTypeCode nvarchar(50) NULL,
					 SchoolTypeDescription nvarchar(100) NULL,
					 SchoolTypeEdFactsCode nvarchar(50) NULL,
					 SchoolTypeId int NULL,
					 MailingAddressCity nvarchar(30) NULL,
					 MailingAddressPostalCode nvarchar(17) NULL,
					 MailingAddressState nvarchar(50) NULL,
					 MailingAddressStreet nvarchar(40) NULL,
					 PhysicalAddressCity nvarchar(30) NULL,
					 PhysicalAddressPostalCode nvarchar(17) NULL,
					 PhysicalAddressState nvarchar(50) NULL,
					 PhysicalAddressStreet nvarchar(40) NULL,
					 Telephone nvarchar(24) NULL,
					 Website nvarchar(300) NULL,
					 OutOfStateIndicator bit NOT NULL default(0)


				Alter TABLE rds.DimCharterSchoolApproverAgency
				ADD  
					 SchOrganizationId int NULL,
					 LeaTypeCode nvarchar(50) NULL,
					 LeaTypeDescription nvarchar(100) NULL,
					 LeaTypeEdFactsCode nvarchar(50) NULL,
					 LeaTypeId int NULL,
					 MailingAddressCity nvarchar(30) NULL,
					 MailingAddressPostalCode nvarchar(17) NULL,
					 MailingAddressState nvarchar(50) NULL,
					 MailingAddressStreet nvarchar(40) NULL,
					 PhysicalAddressCity nvarchar(30) NULL,
					 PhysicalAddressPostalCode nvarchar(17) NULL,
					 PhysicalAddressState nvarchar(50) NULL,
					 PhysicalAddressStreet nvarchar(40) NULL,
					 Telephone nvarchar(24) NULL,
					 Website nvarchar(300) NULL,
					 OutOfStateIndicator bit NOT NULL default(0)

			END

			IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeLeaDate' AND Type = N'U')
			BEGIN

				CREATE TABLE [RDS].[BridgeLeaDate](
				[DimLeaId] [int] NOT NULL,
				[DimDateId] [int] NOT NULL,
				 CONSTRAINT [PK_BridgeLeaDate] PRIMARY KEY CLUSTERED 
				(
					[DimLeaId] ASC,
					[DimDateId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]


				ALTER TABLE [RDS].[BridgeLeaDate]  WITH CHECK ADD  CONSTRAINT [FK_BridgeLeaDate_DimDates_DimDateId] FOREIGN KEY([DimDateId])
				REFERENCES [RDS].[DimDates] ([DimDateId])

				ALTER TABLE [RDS].[BridgeLeaDate] CHECK CONSTRAINT [FK_BridgeLeaDate_DimDates_DimDateId]

				ALTER TABLE [RDS].[BridgeLeaDate]  WITH CHECK ADD  CONSTRAINT [FK_BridgeLeaDate_DimLeas_DimLeaId] FOREIGN KEY([DimLeaId])
				REFERENCES [RDS].[DimLeas] ([DimLeaId])

				ALTER TABLE [RDS].[BridgeLeaDate] CHECK CONSTRAINT [FK_BridgeLeaDate_DimLeas_DimLeaId]

			END

			IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeSchoolDate' AND Type = N'U')
			BEGIN

				CREATE TABLE [RDS].[BridgeSchoolDate](
					[DimSchoolId] [int] NOT NULL,
					[DimDateId] [int] NOT NULL,
				 CONSTRAINT [PK_BridgeSchoolDate] PRIMARY KEY CLUSTERED 
				(
					[DimSchoolId] ASC,
					[DimDateId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]


				ALTER TABLE [RDS].[BridgeSchoolDate]  WITH CHECK ADD  CONSTRAINT [FK_BridgeSchoolDate_DimDates_DimDateId] FOREIGN KEY([DimDateId])
				REFERENCES [RDS].[DimDates] ([DimDateId])

				ALTER TABLE [RDS].[BridgeSchoolDate] CHECK CONSTRAINT [FK_BridgeSchoolDate_DimDates_DimDateId]

				ALTER TABLE [RDS].[BridgeSchoolDate]  WITH CHECK ADD  CONSTRAINT [FK_BridgeSchoolDate_DimSchools_DimSchoolId] FOREIGN KEY([DimSchoolId])
				REFERENCES [RDS].[DimSchools] ([DimSchoolId])

				ALTER TABLE [RDS].[BridgeSchoolDate] CHECK CONSTRAINT [FK_BridgeSchoolDate_DimSchools_DimSchoolId]

			END

			IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeLeaGradeLevels' AND Type = N'U')
			BEGIN

				CREATE TABLE [RDS].[BridgeLeaGradeLevels](
				[DimLeaId] [int] NOT NULL,
				[DimGradeLevelId] [int] NOT NULL,
				 CONSTRAINT [PK_BridgeLeaGradeLevels] PRIMARY KEY CLUSTERED 
				(
					[DimLeaId] ASC,
					[DimGradeLevelId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]

				ALTER TABLE [RDS].[BridgeLeaGradeLevels]  WITH CHECK ADD  CONSTRAINT [FK_BridgeLeaGradeLevels_DimLeas_DimLeaId] FOREIGN KEY([DimLeaId])
				REFERENCES [RDS].[DimLeas] ([DimLeaId])

				ALTER TABLE [RDS].[BridgeLeaGradeLevels] CHECK CONSTRAINT [FK_BridgeLeaGradeLevels_DimLeas_DimLeaId]

				ALTER TABLE [RDS].[BridgeLeaGradeLevels]  WITH CHECK ADD  CONSTRAINT [FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId] FOREIGN KEY([DimGradeLevelId])
				REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])

				ALTER TABLE [RDS].[BridgeLeaGradeLevels] CHECK CONSTRAINT [FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId]

			END

			IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeSchoolGradeLevels' AND Type = N'U')
			BEGIN

				CREATE TABLE [RDS].[BridgeSchoolGradeLevels](
				[DimSchoolId] [int] NOT NULL,
				[DimGradeLevelId] [int] NOT NULL,
				 CONSTRAINT [PK_BridgeSchoolGradeLevels] PRIMARY KEY CLUSTERED 
				(
					[DimSchoolId] ASC,
					[DimGradeLevelId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]

				ALTER TABLE [RDS].[BridgeSchoolGradeLevels]  WITH CHECK ADD  CONSTRAINT [FK_BridgeSchoolGradeLevels_DimSchools_DimSchoolId] FOREIGN KEY([DimSchoolId])
				REFERENCES [RDS].[DimSchools] ([DimSchoolId])

				ALTER TABLE [RDS].[BridgeSchoolGradeLevels] CHECK CONSTRAINT [FK_BridgeSchoolGradeLevels_DimSchools_DimSchoolId]

				ALTER TABLE [RDS].[BridgeSchoolGradeLevels]  WITH CHECK ADD  CONSTRAINT [FK_BridgeSchoolGradeLevels_DimGradeLevels_DimGradeLevelId] FOREIGN KEY([DimGradeLevelId])
				REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId])

				ALTER TABLE [RDS].[BridgeSchoolGradeLevels] CHECK CONSTRAINT [FK_BridgeSchoolGradeLevels_DimGradeLevels_DimGradeLevelId]

			END

			IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimDirectories' AND Type = N'U')
			BEGIN

				
				IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimDirectories_DimDirectoryId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
				BEGIN
					ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimDirectories_DimDirectoryId]
				END


				IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimDirectoryId' AND object_id = OBJECT_ID('rds.FactOrganizationCounts'))
				BEGIN
					DROP INDEX [IX_FactOrganizationCounts_DimDirectoryId] ON [RDS].[FactOrganizationCounts]
				END

				Alter TABLE rds.FactOrganizationCounts DROP COLUMN DimDirectoryId
				Alter TABLE rds.FactOrganizationCounts DROP COLUMN DimCharterSchoolPrimaryApproverAgencyDirectoryId
				Alter TABLE rds.FactOrganizationCounts DROP COLUMN DimCharterSchoolSecondaryApproverAgencyDirectoryId
				Alter TABLE rds.FactOrganizationCounts DROP COLUMN DimCharterSchooleManagerDirectoryId
				Alter TABLE rds.FactOrganizationCounts DROP COLUMN DimCharterSchoolUpdatedManagerDirectoryId


				drop TABLE rds.BridgeDirectoryDate
				drop TABLE rds.BridgeDirectoryGradeLevels
				drop TABLE rds.DimDirectories

			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimPersonnel_PersonnelRole' 
				AND t.name = 'DimPersonnel')
			BEGIN
				CREATE NONCLUSTERED INDEX IX_DimPersonnel_PersonnelRole ON [RDS].[DimPersonnel] ([PersonnelRole]) INCLUDE ([DimPersonnelId])
			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimSchoolStatuses_ComprehensiveAndTargetedSupportEdFactsCode' 
							AND t.name = 'DimSchoolStatuses')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_DimSchoolStatuses_ComprehensiveAndTargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
				(
					[ComprehensiveAndTargetedSupportEdFactsCode] ASC
				)
			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimSchoolStatuses_ComprehensiveSupportEdFactsCode' 
							AND t.name = 'DimSchoolStatuses')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_DimSchoolStatuses_ComprehensiveSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
				(
					[ComprehensiveSupportEdFactsCode] ASC
				)

			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimPersonnelStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode' 
							AND t.name = 'DimPersonnelStatuses')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode] ON [RDS].[DimPersonnelStatuses]
				(
					[EmergencyOrProvisionalCredentialStatusEdFactsCode] ASC
				)


			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimPersonnelStatuses_OutOfFieldStatusEdFactsCode' 
							AND t.name = 'DimPersonnelStatuses')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_OutOfFieldStatusEdFactsCode] ON [RDS].[DimPersonnelStatuses]
				(
					[OutOfFieldStatusEdFactsCode] ASC
				)

			END

			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_DimSchoolStatuses_TargetedSupportEdFactsCode' 
							AND t.name = 'DimSchoolStatuses')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_DimSchoolStatuses_TargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
				(
					[TargetedSupportEdFactsCode] ASC
				)


			END


			if not exists(SELECT 1 FROM sys.indexes s inner join sys.objects t on s.object_id = t.object_id WHERE s.name='IX_FactStudentCounts_DimCountDateId_DimFactTypeId' 
							AND t.name = 'FactStudentCounts')
			BEGIN
				CREATE NONCLUSTERED INDEX [IX_FactStudentCounts_DimCountDateId_DimFactTypeId] ON [RDS].[FactStudentCounts]
				(
					[DimCountDateId] ASC,
					[DimFactTypeId] ASC
				)

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