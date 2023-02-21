-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

		DECLARE @sql nvarchar(max)
		
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimSeas'))
		BEGIN
			ALTER TABLE RDS.DimSeas
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
		BEGIN
			ALTER TABLE RDS.DimPersonnel
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimStudents'))
		BEGIN
			ALTER TABLE RDS.DimStudents
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency'))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimSeas'))
		BEGIN
			ALTER TABLE RDS.DimSeas
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
		BEGIN
			ALTER TABLE RDS.DimPersonnel
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimStudents'))
		BEGIN
			ALTER TABLE RDS.DimStudents
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency'))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD LeaOperationalStatus varchar(50) NULL
		END

		
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD SchoolOperationalStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD LeaOperationalStatusEdFactsCode int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD SchoolOperationalStatusEdFactsCode int NULL
		END

		if exists(select 1 from sys.columns where name = 'EffectiveDate' AND Object_ID = Object_ID(N'RDS.DimLeas'))
		begin
			exec sp_rename 'RDS.DimLeas.EffectiveDate', 'OperationalStatusEffectiveDate', 'COLUMN'
		end
		
		if exists(select 1 from sys.columns where name = 'EffectiveDate' AND Object_ID = Object_ID(N'RDS.DimSchools'))
		begin
			exec sp_rename 'RDS.DimSchools.EffectiveDate', 'OperationalStatusEffectiveDate', 'COLUMN'
		end

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterLeaStatus'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD CharterLeaStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ReconstitutedStatus'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD ReconstitutedStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipient'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD McKinneyVentoSubgrantRecipient varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CharterSchoolStatus'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD CharterSchoolStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ReconstitutedStatus'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD ReconstitutedStatus varchar(50) NULL
		END

		if exists(SELECT * FROM sys.indexes WHERE name='IX_FactOrganizationCounts_DimDirectoryStatusId' )
		BEGIN
			DROP INDEX [IX_FactOrganizationCounts_DimDirectoryStatusId] ON [RDS].[FactOrganizationCounts]
		END


		IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimDirectoryStatuses_DimDirectoryStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
		BEGIN
			ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimDirectoryStatuses_DimDirectoryStatusId]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimDirectoryStatusId'  AND Object_ID = Object_ID(N'rds.FactOrganizationCounts'))
		BEGIN
			ALTER TABLE rds.FactOrganizationCounts	DROP COLUMN DimDirectoryStatusId
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimDirectoryStatuses' AND Type = N'U')
		BEGIN
			DROP TABLE [RDS].[DimDirectoryStatuses]
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedLeaOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD UpdatedLeaOperationalStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedLeaOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD UpdatedLeaOperationalStatusEdFactsCode varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedSchoolOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD UpdatedSchoolOperationalStatus varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedSchoolOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD UpdatedSchoolOperationalStatusEdFactsCode varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipientId'  AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
		BEGIN
			ALTER TABLE RDS.DimOrganizationStatus
			ADD McKinneyVentoSubgrantRecipientId int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipientCode'  AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
		BEGIN
			ALTER TABLE RDS.DimOrganizationStatus
			ADD McKinneyVentoSubgrantRecipientCode varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipientDescription'  AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
		BEGIN
			ALTER TABLE RDS.DimOrganizationStatus
			ADD McKinneyVentoSubgrantRecipientDescription varchar(max) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipientEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
		BEGIN
			ALTER TABLE RDS.DimOrganizationStatus
			ADD McKinneyVentoSubgrantRecipientEdFactsCode varchar(50) NULL
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipient'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			DROP COLUMN McKinneyVentoSubgrantRecipient
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAIndicatorCode'  AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
		BEGIN
			ALTER TABLE RDS.DimIdeaStatuses
			ADD IDEAIndicatorCode varchar(50) NULL, IDEAIndicatorDescription varchar(200) NULL, IDEAIndicatorEdFactsCode varchar(50) NULL, IDEAIndicatorId int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentCountReports
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplineReports
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentCountReportDtos
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IDEAINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplineReportDtos
			ADD IDEAINDICATOR varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimTitle1StatusId'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessments'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessments
			ADD DimTitle1StatusId int NOT NULL DEFAULT(-1)

			ALTER TABLE [RDS].[FactStudentAssessments]  WITH NOCHECK ADD  CONSTRAINT [FK_FactStudentAssessments_DimTitle1Status_DimTitle1StatusId] FOREIGN KEY([DimTitle1StatusId])
			REFERENCES [RDS].[DimTitle1Statuses] ([DimTitle1StatusId])
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1SUPPORTSERVICES'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD TITLE1SUPPORTSERVICES varchar(50) NULL

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1INSTRUCTIONALSERVICES'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD TITLE1INSTRUCTIONALSERVICES varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1PROGRAMTYPE'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD TITLE1PROGRAMTYPE varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1SCHOOLSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD TITLE1SCHOOLSTATUS varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1SUPPORTSERVICES'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD TITLE1SUPPORTSERVICES varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1INSTRUCTIONALSERVICES'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD TITLE1INSTRUCTIONALSERVICES varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1PROGRAMTYPE'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD TITLE1PROGRAMTYPE varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'TITLE1SCHOOLSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD TITLE1SCHOOLSTATUS varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactK12StudentAttendance' AND Type = N'U')
		BEGIN

			CREATE TABLE [RDS].[FactK12StudentAttendance](
				[FactK12StudentAttendanceId] [int] IDENTITY(1,1) NOT NULL,
				[DimCountDateId] [int] NOT NULL,
				[DimDemographicId] [int] NOT NULL,
				[DimFactTypeId] [int] NOT NULL,
				[DimSchoolId] [int] NOT NULL,
				[DimLeaId] [int] NOT NULL,
				[DimAttendanceId] [int] NOT NULL,
				[DimStudentId] [int] NOT NULL,
				[StudentAttendanceRate] decimal(18, 3) NOT NULL,
				CONSTRAINT [PK_FactK12StudentAttendance] PRIMARY KEY CLUSTERED 
				(
					[FactK12StudentAttendanceId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]
					
			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimDates_DimCountDateId] FOREIGN KEY([DimCountDateId])
			REFERENCES [RDS].[DimDates] ([DimDateId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimDates_DimCountDateId]

			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH NOCHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimDemographics_DimDemographicId] FOREIGN KEY([DimDemographicId])
			REFERENCES [RDS].[DimDemographics] ([DimDemographicId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] NOCHECK CONSTRAINT [FK_FactK12StudentAttendance_DimDemographics_DimDemographicId]

			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId] FOREIGN KEY([DimFactTypeId])
			REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId]

			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimLeas_DimLeaId] FOREIGN KEY([DimLeaId])
			REFERENCES [RDS].[DimLeas] ([DimLeaID])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimLeas_DimLeaId]

			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimSchools_DimSchoolId] FOREIGN KEY([DimSchoolId])
			REFERENCES [RDS].[DimSchools] ([DimSchoolId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimSchools_DimSchoolId]

			ALTER TABLE [RDS].[FactK12StudentAttendance]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAttendance_DimStudents_DimStudentId] FOREIGN KEY([DimStudentId])
			REFERENCES [RDS].[DimStudents] ([DimStudentId])

			ALTER TABLE [RDS].[FactK12StudentAttendance] CHECK CONSTRAINT [FK_FactK12StudentAttendance_DimStudents_DimStudentId]
			
		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactK12StudentAttendanceReports' AND Type = N'U')
		BEGIN
				CREATE TABLE [RDS].[FactK12StudentAttendanceReports](
				[FactK12StudentAttendanceReportId] [int] IDENTITY(1,1) NOT NULL,
				[Categories] [nvarchar](300) NULL,
				[CategorySetCode] [nvarchar](40) NOT NULL,
				[ECODISSTATUS] [nvarchar](50) NULL,
				[HOMELESSSTATUS] [nvarchar](50) NULL,
				[LEPSTATUS] [nvarchar](50) NULL,
				[MIGRANTSTATUS] [nvarchar](50) NULL,
				[OrganizationId] [int] NOT NULL,
				[OrganizationName] [nvarchar](1000) NOT NULL,
				[OrganizationNcesId] [nvarchar](100) NOT NULL,
				[OrganizationStateId] [nvarchar](100) NOT NULL,
				[ParentOrganizationStateId] [nvarchar](100) NULL,
				[RACE] [nvarchar](50) NULL,
				[ReportCode] [nvarchar](40) NOT NULL,
				[ReportLevel] [nvarchar](40) NOT NULL,
				[ReportYear] [nvarchar](40) NOT NULL,
				[SEX] [nvarchar](50) NULL,
				[StateANSICode] [nvarchar](100) NOT NULL,
				[StateCode] [nvarchar](100) NOT NULL,
				[StateName] [nvarchar](500) NOT NULL,
				[StudentAttendanceRate] decimal(18, 3) NOT NULL,
				[TableTypeAbbrv] [nvarchar](100) NULL,
				[TotalIndicator] [nvarchar](5) NULL,
				[MILITARYCONNECTEDSTATUS] [nvarchar](50) NULL,
				[HOMELESSNIGHTTIMERESIDENCE] [nvarchar](50) NULL,
				[HOMELESSUNACCOMPANIEDYOUTHSTATUS] [nvarchar](50) NULL,
				[ATTENDANCE] [varchar](50) NULL,
				 CONSTRAINT [PK_FactK12StudentAttendanceReports] PRIMARY KEY CLUSTERED 
				(
					[FactK12StudentAttendanceReportId] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY]

		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactK12StudentAttendanceReportDtos' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[FactK12StudentAttendanceReportDtos](
			[FactK12StudentAttendanceReportDtoId] [int] IDENTITY(1,1) NOT NULL,
			[Categories] [nvarchar](300) NULL,
			[CategorySetCode] [nvarchar](40) NOT NULL,
			[ECODISSTATUS] [nvarchar](50) NULL,
			[HOMELESSSTATUS] [nvarchar](50) NULL,
			[LEPSTATUS] [nvarchar](50) NULL,
			[MIGRANTSTATUS] [nvarchar](50) NULL,
			[OrganizationId] [int] NOT NULL,
			[OrganizationName] [nvarchar](1000) NOT NULL,
			[OrganizationNcesId] [nvarchar](100) NOT NULL,
			[OrganizationStateId] [nvarchar](100) NOT NULL,
			[ParentOrganizationStateId] [nvarchar](100) NULL,
			[RACE] [nvarchar](50) NULL,
			[ReportCode] [nvarchar](40) NOT NULL,
			[ReportLevel] [nvarchar](40) NOT NULL,
			[ReportYear] [nvarchar](40) NOT NULL,
			[SEX] [nvarchar](50) NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateCode] [nvarchar](100) NOT NULL,
			[StateName] [nvarchar](500) NOT NULL,
			[StudentAttendanceRate] decimal(18, 3) NOT NULL,
			[TableTypeAbbrv] [nvarchar](100) NULL,
			[TotalIndicator] [nvarchar](5) NULL,
			[MILITARYCONNECTEDSTATUS] [nvarchar](50) NULL,
			[HOMELESSNIGHTTIMERESIDENCE] [nvarchar](50) NULL,
			[HOMELESSUNACCOMPANIEDYOUTHSTATUS] [nvarchar](50) NULL,
			[ATTENDANCE] [varchar](50) NULL,
			 CONSTRAINT [PK_FactK12StudentAttendanceDtos] PRIMARY KEY CLUSTERED 
			(
				[FactK12StudentAttendanceReportDtoId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY] 

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Category2'  AND Object_ID = Object_ID(N'RDS.FactCustomCounts'))
		BEGIN
			ALTER TABLE RDS.FactCustomCounts
			ADD Category2 varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Category3'  AND Object_ID = Object_ID(N'RDS.FactCustomCounts'))
		BEGIN
			ALTER TABLE RDS.FactCustomCounts
			ADD Category3 varchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Category4'  AND Object_ID = Object_ID(N'RDS.FactCustomCounts'))
		BEGIN
			ALTER TABLE RDS.FactCustomCounts
			ADD Category4 varchar(50) NULL
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimAssessmentStatusId'  AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
		BEGIN
			SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
			FROM sys.default_constraints df
			  INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			  INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
			where t.name = 'FactStudentCounts' and c.name = 'DimAssessmentStatusId'

			EXEC sp_executeSql @sql

			ALTER TABLE rds.FactStudentCounts DROP COLUMN DimAssessmentStatusId
		END

		SET @sql = ''

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimAssessmentId'  AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
		BEGIN
			SELECT @sql = 'ALTER TABLE RDS.' + t.name + ' DROP CONSTRAINT ' + df.NAME 
			FROM sys.default_constraints df
			  INNER JOIN sys.tables t ON df.parent_object_id = t.object_id
			  INNER JOIN sys.columns c ON df.parent_object_id = c.object_id AND df.parent_column_id = c.column_id
			where t.name = 'FactStudentCounts' and c.name = 'DimAssessmentId'

			EXEC sp_executeSql @sql

			ALTER TABLE rds.FactStudentCounts DROP COLUMN DimAssessmentId
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeLeaDate' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.BridgeLeaDate
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgePersonnelDate' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.BridgePersonnelDate
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeSchoolDate' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.BridgeSchoolDate
		END

		IF EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'BridgeStudentRaces' AND Type = N'U')
		BEGIN
			DROP TABLE RDS.BridgeStudentRaces
		END
			   
		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimLeas_LeaOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimLeas_LeaOrganizationId] ON [RDS].[DimLeas]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimLeas '))
		BEGIN
			ALTER TABLE RDS.DimLeas
			DROP COLUMN LeaOrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimLeas_SeaOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimLeas_SeaOrganizationId] ON [RDS].[DimLeas]
		END
		
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimLeas '))
		BEGIN
			ALTER TABLE RDS.DimLeas
			DROP COLUMN SeaOrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimSchools_LeaOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimSchools_LeaOrganizationId] ON [RDS].[DimSchools]
		END
		
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimSchools '))
		BEGIN
			ALTER TABLE RDS.DimSchools
			DROP COLUMN LeaOrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimSchools_SeaOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimSchools_SeaOrganizationId] ON [RDS].[DimSchools]
		END
		
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimSchools '))
		BEGIN
			ALTER TABLE RDS.DimSchools
			DROP COLUMN SeaOrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimSchools_SchoolOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimSchools_SchoolOrganizationId] ON [RDS].[DimSchools]
		END
		
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimSchools '))
		BEGIN
			ALTER TABLE RDS.DimSchools
			DROP COLUMN SchoolOrganizationId
		END		 		 	  	  	   	

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplineReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplineReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentCountReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReports '))
		BEGIN
			ALTER TABLE RDS.FactPersonnelCountReports 
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactPersonnelCountReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactPersonnelCountReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCountReports'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationStatusCountReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationStatusCountReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationStatusCountReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationIndicatorStatusReports'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationIndicatorStatusReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationIndicatorStatusReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationIndicatorStatusReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendanceReports'))
		BEGIN
			ALTER TABLE RDS.FactK12StudentAttendanceReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactK12StudentAttendanceReportDtos '))
		BEGIN
			ALTER TABLE RDS.FactK12StudentAttendanceReportDtos
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactCustomCounts '))
		BEGIN
			ALTER TABLE RDS.FactCustomCounts
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency '))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency '))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			DROP COLUMN SeaOrganizationId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency '))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			DROP COLUMN SchOrganizationId
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SchoolStateIdentifier'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency '))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			ADD SchoolStateIdentifier NVARCHAR(50) NULL
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimPersonnel_PersonnelPersonId' )
		BEGIN
			DROP INDEX [IX_DimPersonnel_PersonnelPersonId] ON [RDS].[DimPersonnel]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'PersonnelPersonId'  AND Object_ID = Object_ID(N'RDS.DimPersonnel '))
		BEGIN
			ALTER TABLE RDS.DimPersonnel
			DROP COLUMN PersonnelPersonId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimStudents_StudentPersonId' )
		BEGIN
			DROP INDEX [IX_DimStudents_StudentPersonId] ON [RDS].[DimStudents]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'StudentPersonId'  AND Object_ID = Object_ID(N'RDS.DimStudents '))
		BEGIN
			ALTER TABLE RDS.DimStudents
			DROP COLUMN StudentPersonId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report' )
		BEGIN
			DROP INDEX [IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report] ON [RDS].[FactStudentCountReports]
		END

		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report' )
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report] ON [RDS].[FactStudentCountReports]
			(
				[CategorySetCode] ASC,
				[DISABILITY] ASC,
				[ReportCode] ASC,
				[ReportLevel] ASC,
				[ReportYear] ASC
			)
			INCLUDE ( 	[CTEPROGRAM],
				[FOODSERVICEELIGIBILITY],
				[FOSTERCAREPROGRAM],
				[HOMELESSSTATUS],
				[IMMIGRANTTITLEIIIPROGRAM],
				[LEPSTATUS],
				[MIGRANTSTATUS],
				[OrganizationName],
				[OrganizationNcesId],
				[OrganizationStateId],
				[ParentOrganizationStateId],
				[SECTION504PROGRAM],
				[StateANSICode],
				[StateCode],
				[StateName],
				[StudentCount],
				[TITLE1SCHOOLSTATUS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReports '))
		BEGIN
			ALTER TABLE RDS.FactStudentCountReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization' )
		BEGIN
			DROP INDEX [IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization] ON [RDS].[FactOrganizationCountReports]
		END
		
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organizatio' )
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization] ON [RDS].[FactOrganizationCountReports]
			(
				[ReportCode] ASC,
				[ReportLevel] ASC,
				[ReportYear] ASC
			)
			INCLUDE ( 	[GRADELEVEL] ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationId'  AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReports
			DROP COLUMN OrganizationId
		END

		IF EXISTS (SELECT * FROM sys.indexes WHERE name='IX_DimSeas_SeaOrganizationId' )
		BEGIN
			DROP INDEX [IX_DimSeas_SeaOrganizationId] ON [RDS].[DimSeas]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimSeas '))
		BEGIN
			ALTER TABLE RDS.DimSeas
			DROP COLUMN SeaOrganizationId
		END

		IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_ComprehensiveAndTargetedSupportEdFactsCode' AND object_id = OBJECT_ID('rds.DimSchoolStatuses'))
		BEGIN
			DROP INDEX [IX_DimSchoolStatuses_ComprehensiveAndTargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
			DROP INDEX [IX_DimSchoolStatuses_ComprehensiveSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
			DROP INDEX [IX_DimSchoolStatuses_TargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]


			ALTER TABLE rds.DimSchoolStatuses
			DROP COLUMN [ComprehensiveAndTargetedSupportCode], [ComprehensiveAndTargetedSupportDescription], 
			ComprehensiveAndTargetedSupportEdFactsCode, ComprehensiveAndTargetedSupportId,
			[ComprehensiveSupportCode], [ComprehensiveSupportDescription], [ComprehensiveSupportEdFactsCode],
			[ComprehensiveSupportId],[TargetedSupportCode],[TargetedSupportDescription],[TargetedSupportEdFactsCode],
			[TargetedSupportId]
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedLeaOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			DROP COLUMN UpdatedLeaOperationalStatus
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedLeaOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			DROP COLUMN UpdatedLeaOperationalStatusEdFactsCode
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedSchoolOperationalStatus'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			DROP COLUMN UpdatedSchoolOperationalStatus
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'UpdatedSchoolOperationalStatusEdFactsCode'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			DROP COLUMN UpdatedSchoolOperationalStatusEdFactsCode
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