-- Release-Specific table changes for the ODS schema

----------------------------------

set nocount on
begin try
 
	begin transaction

	------------------------
	-- Add EdFactsTableTypeId to App.CategorySets
	------------------------

	IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'EdFactsTableTypeId'
          AND Object_ID = Object_ID(N'App.CategorySets'))
	BEGIN
		ALTER TABLE App.CategorySets ADD EdFactsTableTypeId int NULL;
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'GenerateReportDisplayTypes' AND Type = N'U')
	BEGIN

		CREATE TABLE [App].[GenerateReportDisplayTypes](
			[GenerateReportDisplayTypeId] [int] IDENTITY(1,1) NOT NULL,
			[GenerateReportDisplayTypeName] [nvarchar](100) NOT NULL,
		 CONSTRAINT [PK_GenerateReportDisplayType] PRIMARY KEY CLUSTERED 
		(
			[GenerateReportDisplayTypeId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE App.CategorySet_Categories ADD GenerateReportDisplayTypeID int NULL;

		ALTER TABLE [App].[CategorySet_Categories]  WITH CHECK ADD  CONSTRAINT [FK_CategorySet_Categories_GenerateReportDisplayTypes_GenerateReportDisplayTypeId] FOREIGN KEY([GenerateReportDisplayTypeId])
		REFERENCES [App].[GenerateReportDisplayTypes] ([GenerateReportDisplayTypeId])
		ON DELETE CASCADE


		ALTER TABLE [App].[CategorySet_Categories] CHECK CONSTRAINT [FK_CategorySet_Categories_GenerateReportDisplayTypes_GenerateReportDisplayTypeId]

	END

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_School_Count' AND object_id = OBJECT_ID('RDS.FactStudentCounts'))
	BEGIN

		CREATE NONCLUSTERED INDEX IX_FactStudentCounts_Date_Type_School_Count ON [RDS].[FactStudentCounts] ([DimCountDateId],[DimFactTypeId],[DimSchoolId])
		INCLUDE ([DimDemographicId],[DimGradeLevelId],[DimStudentId],[StudentCount],[DimLeaId])

	END

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_Grade_School_Student' AND object_id = OBJECT_ID('RDS.FactStudentCounts'))
	BEGIN

		CREATE NONCLUSTERED INDEX IX_FactStudentCounts_Date_Type_Grade_School_Student ON [RDS].[FactStudentCounts] ([DimCountDateId],[DimFactTypeId],[DimGradeLevelId])
		INCLUDE ([DimSchoolId],[DimStudentId])

	END

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCounts_Date_Type_Grade_Statuses' AND object_id = OBJECT_ID('RDS.FactStudentCounts'))
	BEGIN

		CREATE NONCLUSTERED INDEX IX_FactStudentCounts_Date_Type_Grade_Statuses	ON [RDS].[FactStudentCounts] ([DimCountDateId],[DimFactTypeId],[DimGradeLevelId])
		INCLUDE ([DimDemographicId],[DimSchoolId],[DimStudentId],[StudentCount],[DimLeaId])


	END

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization' AND object_id = OBJECT_ID('RDS.FactOrganizationCountReports'))
	BEGIN

		CREATE NONCLUSTERED INDEX [IX_FactOrganizationCountReports_ReportCode_ReportYear_ReportLevel_Grade_Organization] ON [RDS].[FactOrganizationCountReports]
		(
			[ReportCode] ASC,
			[ReportLevel] ASC,
			[ReportYear] ASC
		)
		INCLUDE ( 	[GRADELEVEL],
			[OrganizationId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	END

	IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report' AND object_id = OBJECT_ID('RDS.FactStudentCountReports'))
	BEGIN

		CREATE NONCLUSTERED INDEX IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report
		ON [RDS].[FactStudentCountReports] ([CategorySetCode],[DISABILITY],[ReportCode],[ReportLevel],[ReportYear])
		INCLUDE ([CTEPROGRAM],[FOODSERVICEELIGIBILITY],[FOSTERCAREPROGRAM],[HOMELESSSTATUS],[IMMIGRANTTITLEIIIPROGRAM],[LEPSTATUS],[MIGRANTSTATUS],[OrganizationId],[OrganizationName],[OrganizationNcesId],[OrganizationStateId],[ParentOrganizationStateId],[SECTION504PROGRAM],[StateANSICode],[StateCode],[StateName],[StudentCount],[TITLE1SCHOOLSTATUS])

	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'ReportFilter'
          AND Object_ID = Object_ID(N'rds.FactCustomCounts'))
	BEGIN
		ALTER TABLE rds.FactCustomCounts ADD ReportFilter nvarchar(100) NULL;
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
