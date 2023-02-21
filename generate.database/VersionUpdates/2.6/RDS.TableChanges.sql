-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------

set nocount on
begin try
 
	begin transaction

	IF NOT EXISTS ( SELECT * FROM sys.columns WHERE (Name = N'IsSelected' OR Name = N'IsSelected') AND Object_ID = Object_ID(N'App.DataMigrationTasks'))
	BEGIN
		ALTER TABLE App.DataMigrationTasks ADD IsSelected Bit
	END
		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimDataMigrationTypes' AND Type = N'U')
		begin
	Create table [RDS].[DimDataMigrationTypes](
         DimDataMigrationTypeId int IDENTITY(1,1) not null ,
         DataMigrationTypeCode varchar(50),
		 DataMigrationTypeName varchar(50),
			 CONSTRAINT [PK_DimDataMigrationTypes] PRIMARY KEY CLUSTERED 
			(
				[DimDataMigrationTypeId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	  -- CONSTRAINT [PK_DimDataMigrationTypes] PRIMARY KEY CLUSTERED
	end

	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimDateDataMigrationTypes' AND Type = N'U')
		begin

			CREATE TABLE [RDS].[DimDateDataMigrationTypes](
				[DimDateId] [int] NOT NULL,
				[DataMigrationTypeId] [int] NOT NULL,
				IsSelected bit
			 CONSTRAINT [PK_DimDate_DimDataMigrationTypes] PRIMARY KEY CLUSTERED 
			(
				[DimDateId] ASC,
				[DataMigrationTypeId] ASC
				
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]


			ALTER TABLE [RDS].[DimDateDataMigrationTypes]  WITH CHECK ADD  CONSTRAINT [FK_DimDate_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId] FOREIGN KEY([DataMigrationTypeId])
			REFERENCES [RDS].[DimDataMigrationTypes] ([DimDataMigrationTypeId])
			ON DELETE CASCADE


			ALTER TABLE [RDS].[DimDateDataMigrationTypes] CHECK CONSTRAINT [FK_DimDate_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId]

			ALTER TABLE [RDS].[DimDateDataMigrationTypes]  WITH CHECK ADD  CONSTRAINT [FK_DimDate_DataMigrationTypes_DimDates_DimDateId] FOREIGN KEY([DimDateId])
			REFERENCES [RDS].[DimDates] ([DimDateId])
			ON DELETE CASCADE


			ALTER TABLE [RDS].[DimDateDataMigrationTypes] CHECK CONSTRAINT [FK_DimDate_DataMigrationTypes_DimDates_DimDateId]

		end
		--*******************************************************************************************************************
		IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimFirearms' AND Type = N'U')
		BEGIN
			
			CREATE TABLE [RDS].[DimFirearms](
			    [DimFirearmsId] [int] IDENTITY(1,1) NOT NULL,
				[FirearmsId] [int] NULL,
				[FirearmsCode] [varchar](50) NULL,
				[FirearmsDescription] [varchar](200) NULL,
				[FirearmsEdFactsCode] [varchar](50) NULL,
			 CONSTRAINT [PK_DimFirearms] PRIMARY KEY CLUSTERED 
			(
				[DimFirearmsId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			Alter table rds.FactStudentDisciplines add DimFirearmsId int not null default(-1)
			Alter table rds.FactStudentDisciplineReports add FIREARMS varchar(50)
			Alter table rds.FactStudentDisciplineReportDtos add FIREARMS varchar(50)
			
		END

		--IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FireArmsDisciplineCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
		--BEGIN

		--	Alter table rds.DimDisciplines add FireArmsDisciplineId int, FireArmsDisciplineCode nvarchar(50), FireArmsDisciplineDescription nvarchar(max), FireArmsDisciplineEdFactsCode nvarchar(50),
		--	                                   IDEAFireArmsDisciplineId int, IDEAFireArmsDisciplineCode nvarchar(50), IDEAFireArmsDisciplineDescription nvarchar(max), IDEAFireArmsDisciplineEdFactsCode nvarchar(50)
		--End

			IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimFirearmsDiscipline' AND Type = N'U')
		BEGIN		
			CREATE TABLE [RDS].[DimFirearmsDiscipline](
			    [DimFirearmsDisciplineId] [int] IDENTITY(1,1) NOT NULL,
				[FirearmsDisciplineId] int NULL, 
				[FirearmsDisciplineCode] nvarchar(50) NULL, 
				[FirearmsDisciplineDescription] nvarchar(max) NULL, 
				[FirearmsDisciplineEdFactsCode] nvarchar(50) NULL,
				[IDEAFirearmsDisciplineId] int NULL, 
				[IDEAFirearmsDisciplineCode] nvarchar(50) NULL, 
				[IDEAFirearmsDisciplineDescription] nvarchar(max) NULL, 
				[IDEAFirearmsDisciplineEdFactsCode] nvarchar(50) NULL
			 CONSTRAINT [PK_DimFirearmsDisciplineId] PRIMARY KEY CLUSTERED 
			(
				[DimFirearmsDisciplineId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			Alter table rds.FactStudentDisciplines add DimFirearmsDisciplineId int not null default(-1)
		 	Alter table rds.FactStudentDisciplineReports add FIREARMSDISCIPLINE varchar(50)
			Alter table rds.FactStudentDisciplineReportDtos add FIREARMSDISCIPLINE varchar(50)
			Alter table rds.FactStudentDisciplineReports add IDEAFIREARMSDISCIPLINE varchar(50)
			Alter table rds.FactStudentDisciplineReportDtos add IDEAFIREARMSDISCIPLINE varchar(50)
		END



		IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimOrganizationStatus' AND Type = N'U')
		BEGIN		
			CREATE TABLE [RDS].[DimOrganizationStatus](
			    [DimOrganizationStatusId] [int] IDENTITY(1,1) NOT NULL,
				REAPAlternativeFundingStatusId int NULL, 
				REAPAlternativeFundingStatusCode nvarchar(50) NULL, 
				REAPAlternativeFundingStatusDescription nvarchar(max) NULL, 
				REAPAlternativeFundingStatusEdFactsCode nvarchar(50) NULL,
				GunFreeStatusId int NULL, 
				GunFreeStatusCode nvarchar(50) NULL, 
				GunFreeStatusDescription nvarchar(max) NULL, 
				GunFreeStatusEdFactsCode nvarchar(50) NULL,
			    GraduationRateId int NULL, 
			    GraduationRateCode nvarchar(50) NULL, 
			    GraduationRateDescription nvarchar(max) NULL, 
			    GraduationRateEdFactsCode nvarchar(50) NULL
			 CONSTRAINT [PK_DimOrganizationStatus] PRIMARY KEY CLUSTERED 
			(
				[DimOrganizationStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimOrganizationStatusId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
			BEGIN
				Alter table rds.FactOrganizationCounts add DimOrganizationStatusId int not null default(-1)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'REAPAlternativeFundingStatus' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
			BEGIN
				Alter table rds.FactOrganizationCountReports add REAPAlternativeFundingStatus nvarchar(50), GraduationRate nvarchar(50), GunFreeStatus nvarchar(50)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'REAPAlternativeFundingStatus' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
			BEGIN
				Alter table rds.FactOrganizationCountReportDtos add REAPAlternativeFundingStatus nvarchar(50), GraduationRate nvarchar(50), GunFreeStatus nvarchar(50)
			END
		END

		IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimEnrollment' AND Type = N'U')
		BEGIN		
			CREATE TABLE [RDS].[DimEnrollment](
			    [DimEnrollmentId] [int] IDENTITY(1,1) NOT NULL,
				[PostSecondaryEnrollmentStatusId] [int] NULL,
				[PostSecondaryEnrollmentStatusCode] [varchar](50) NULL,
				[PostSecondaryEnrollmentStatusDescription] [varchar](200) NULL,
				[PostSecondaryEnrollmentStatusEdFactsCode] [varchar](50) NULL,
			 CONSTRAINT [PK_DimEnrollment] PRIMARY KEY CLUSTERED 
			(
				[DimEnrollmentId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimEnrollmentId' AND Object_ID = Object_ID(N'RDS.FactStudentCounts'))
			BEGIN
				Alter table rds.FactStudentCounts add DimEnrollmentId int not null default(-1)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PostSecondaryEnrollmentStatus' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
			BEGIN
				Alter table rds.FactStudentCountReports add PostSecondaryEnrollmentStatus varchar(50)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'PostSecondaryEnrollmentStatus' AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
			BEGIN
				Alter table rds.FactStudentCountReportDtos add PostSecondaryEnrollmentStatus varchar(50)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StudentRate' AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
			BEGIN
				Alter table rds.FactStudentCountReports add StudentRate  decimal(9,2)
			END

			IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StudentRate' AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
			BEGIN
				Alter table rds.FactStudentCountReportDtos add StudentRate  decimal(9,2)
			END
		END

		IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.FactStudentDisciplines'))
		BEGIN

				Alter table rds.FactStudentDisciplines add DimGradeLevelId int not null default(-1)
				Alter table rds.FactStudentDisciplineReports add GRADELEVEL varchar(50)
				Alter table rds.FactStudentDisciplineReportDtos add GRADELEVEL varchar(50)
		End


	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimSchoolStateStatus' AND Type = N'U')
	 BEGIN
			
			CREATE TABLE [RDS].[DimSchoolStateStatus](
				[DimSchoolStateStatusId] [int] IDENTITY(1,1) NOT NULL,
				[SchoolStateStatusId] [int]  NULL,
				[SchoolStateStatusCode] [nvarchar](200) NULL,
				[SchoolStateStatusDescription] [nvarchar](50) NULL,
				[SchoolStateStatusEdFactsCode]  [nvarchar](50) NULL,
			 CONSTRAINT [PK_DimSchoolStateStatus] PRIMARY KEY CLUSTERED 
			(
				[DimSchoolStateStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			Alter table rds.FactOrganizationCounts add DimSchoolStateStatusId int not null default(-1)

	END

	
	
	IF not EXISTS(SELECT *
			  FROM   INFORMATION_SCHEMA.COLUMNS
			  WHERE  TABLE_SCHEMA='RDS' and
				TABLE_NAME = 'DimLeas'
					 AND COLUMN_NAME = 'ReportedFederally')
	alter table RDS.DimLeas add ReportedFederally bit

	IF not EXISTS(SELECT *
			  FROM   INFORMATION_SCHEMA.COLUMNS
			  WHERE  TABLE_SCHEMA='RDS' and
				TABLE_NAME = 'DimSchools'
					 AND COLUMN_NAME = 'ReportedFederally')
	alter table RDS.DimSchools add ReportedFederally bit

	
	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'App.DataMigrationTasks'))
	BEGIN
			Alter table App.DataMigrationTasks add Description varchar(max)
	End

	
	--*******************************************************************************************************************
		IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimCohortStatuses' AND Type = N'U')
		BEGIN
			
			CREATE TABLE [RDS].[DimCohortStatuses](
			    [DimCohortStatusId] [int] IDENTITY(1,1) NOT NULL,
				[CohortStatusId] [int] NULL,
				[CohortStatusCode] [varchar](50) NULL,
				[CohortStatusDescription] [varchar](200) NULL,
				[CohortStatusEdFactsCode] [varchar](50) NULL,
			 CONSTRAINT [PK_DimCohortStatus] PRIMARY KEY CLUSTERED 
			(
				[DimCohortStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			Alter table rds.FactStudentCounts add DimCohortStatusId int not null default(-1)
			Alter table rds.FactStudentCountReports add COHORTSTATUS varchar(50)
			Alter table rds.FactStudentCountReportDtos add COHORTSTATUS varchar(50)
			
		END


	--*******************************************************************************************************************

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
