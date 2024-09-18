-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	-- DimIndicatorStatuses
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimIndicatorStatuses' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[DimIndicatorStatuses](
			    DimIndicatorStatusId [int] IDENTITY(1,1) NOT NULL,
				IndicatorStatusId [int] NULL,
				IndicatorStatusCode [varchar](50) NULL,
				IndicatorStatusDescription [varchar](200) NULL,
				IndicatorStatusEdFactsCode [varchar](50) NULL,
			 CONSTRAINT [PK_DimIndicatorStatus] PRIMARY KEY CLUSTERED 
			(
				[DimIndicatorStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END

   	-- DimStateDefinedStatuses
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimStateDefinedStatuses' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[DimStateDefinedStatuses](
			    [DimStateDefinedStatusId] [int] IDENTITY(1,1) NOT NULL,
				[StateDefinedStatusId] [int] NULL,
				[StateDefinedStatusCode] [nvarchar](50) NULL,
				[StateDefinedStatusDescription] [nvarchar](200) NULL,
			 CONSTRAINT [PK_DimStateDefinedStatus] PRIMARY KEY CLUSTERED 
			(
				[DimStateDefinedStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END

	-- FactOrganizationIndicatorStatuses
	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationStatusCounts' AND Type = N'U')
		begin
			CREATE TABLE [RDS].[FactOrganizationStatusCounts](
				FactOrganizationStatusCountId int IDENTITY(1,1) NOT NULL,
				DimFactTypeId int NOT NULL,
				DimSchoolId int not null,
				DimCountDateId int not null,
				DimRaceId int not null  default(-1),
				DimIdeaStatusId int not null  default(-1),
				DimDemographicId int not null  default(-1),
				DimEcoDisStatusId int not null default(-1),
				DimIndicatorStatusId int not null default(-1),
				DimStateDefinedStatusId int not null default(-1),
				OrganizationStatusCount int not null
			 CONSTRAINT [PK_FactOrganizationStatusCount] PRIMARY KEY CLUSTERED 
			(
				[FactOrganizationStatusCountId] ASC
				
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimFactTypes] FOREIGN KEY([DimFactTypeId])
				REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimDates] FOREIGN KEY([DimCountDateId])
			REFERENCES [RDS].[DimDates] ([DimDateId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchools] FOREIGN KEY([DimSchoolId])
				REFERENCES [RDS].[DimSchools] ([DimSchoolId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimRaces] FOREIGN KEY([DimRaceId])
				REFERENCES [RDS].[DimRaces] ([DimRaceId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimIdeaStatuses] FOREIGN KEY([DimIdeaStatusId])
				REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimDemographics] FOREIGN KEY([DimDemographicId])
				REFERENCES [RDS].[DimDemographics] ([DimDemographicId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimEcoDis] FOREIGN KEY([DimEcoDisStatusId])
				REFERENCES [RDS].[DimDemographics] ([DimDemographicId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimIndicatorStatuses] FOREIGN KEY([DimIndicatorStatusId])
				REFERENCES [RDS].[DimIndicatorStatuses] ([DimIndicatorStatusId])

			ALTER TABLE [RDS].[FactOrganizationStatusCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactOrganizationStatusCounts_DimStateDefinedStatuses] FOREIGN KEY([DimStateDefinedStatusId])
				REFERENCES [RDS].[DimStateDefinedStatuses] ([DimStateDefinedStatusId])
		end

	-- FactOrganizationIndicatorStatusReports
	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationStatusCountReports' AND Type = N'U')
		begin
			CREATE TABLE [RDS].[FactOrganizationStatusCountReports](
				FactOrganizationStatusCountReportId int IDENTITY(1,1) NOT NULL,
				Categories nvarchar(300) null,
				CategorySetCode nvarchar(40) null,
				ReportCode nvarchar(40) NOT NULL,
				ReportLevel nvarchar(40) NOT NULL,
				ReportYear nvarchar(40) NOT NULL,
				StateANSICode nvarchar(100) NOT NULL,
				StateCode nvarchar(100) NOT NULL,
				StateName nvarchar(500) NOT NULL,
				OrganizationId int NOT NULL,
				OrganizationName nvarchar(1000) NOT NULL,
				OrganizationNcesId nvarchar(100) NOT NULL,
				OrganizationStateId nvarchar(100) NOT NULL,
				ParentOrganizationStateId nvarchar(100) null,
				RACE nvarchar(50) NULL,
				DISABILITY nvarchar(50) NULL,
				LEPSTATUS nvarchar(50) NULL,
				ECODISSTATUS nvarchar(50) NULL,
				--SEX nvarchar(50) NULL,
				INDICATORSTATUS nvarchar(50),
				STATEDEFINEDSTATUSCODE nvarchar(50),
				OrganizationStatusCount int not null
			 CONSTRAINT [PK_FactOrganizationStatusCountReport] PRIMARY KEY CLUSTERED 
			(
				[FactOrganizationStatusCountReportId] ASC
				
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			CREATE NONCLUSTERED INDEX [IX_FactOrganizationStatusCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode] ON [RDS].[FactOrganizationStatusCountReports]
			(
				ReportCode ASC,
				ReportYear ASC,
				ReportLevel ASC,
				CategorySetCode ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		end

	-- FactOrganizationIndicatorStatusReportDtos
	IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'FactOrganizationStatusCountReportDtos' AND Type = N'U')
		begin
			CREATE TABLE [RDS].[FactOrganizationStatusCountReportDtos](
				FactOrganizationStatusCountReportDtoId int IDENTITY(1,1) NOT NULL,
				Categories nvarchar(300) null,
				CategorySetCode nvarchar(40) null,
				ReportCode nvarchar(40) NOT NULL,
				ReportLevel nvarchar(40) NOT NULL,
				ReportYear nvarchar(40) NOT NULL,
				StateANSICode nvarchar(100) NOT NULL,
				StateCode nvarchar(100) NOT NULL,
				StateName nvarchar(500) NOT NULL,
				OrganizationId int NOT NULL,
				OrganizationName nvarchar(1000) NOT NULL,
				OrganizationNcesId nvarchar(100) NOT NULL,
				OrganizationStateId nvarchar(100) NOT NULL,
				ParentOrganizationStateId nvarchar(100) null,
				RACE nvarchar(50) NULL,
				DISABILITY nvarchar(50) NULL,
				LEPSTATUS nvarchar(50) NULL,
				ECODISSTATUS nvarchar(50) NULL,
				--SEX nvarchar(50) NULL,
				INDICATORSTATUS nvarchar(50),
				STATEDEFINEDSTATUSCODE nvarchar(50),
				OrganizationStatusCount int not null
			 CONSTRAINT [PK_FactOrganizationStatusCountReportDto] PRIMARY KEY CLUSTERED 
			(
				[FactOrganizationStatusCountReportDtoId] ASC
				
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		end

	------------------------
	-- Place code here
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AssessmentProgressLevel' AND Object_ID = Object_ID(N'[RDS].[DimAssessmentStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimAssessmentStatuses] ADD AssessmentProgressLevel  nvarchar(50);
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AcademicOrVocationalOutcome' AND Object_ID = Object_ID(N'[RDS].[DimEnrollment]'))
	BEGIN
		ALTER TABLE [RDS].[DimEnrollment] ADD AcademicOrVocationalOutcome nvarchar(50);
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimNorDProgramStatuses' AND Type = N'U')
	 BEGIN
			
			CREATE TABLE [RDS].[DimNorDProgramStatuses](
			[DimNorDProgramStatusId] [int] IDENTITY(1,1) NOT NULL,
			[LongTermStatusCode] [nvarchar](50) NULL,
			[LongTermStatusDescription] [nvarchar](100) NULL,
			[LongTermStatusEdFactsCode] [nvarchar](50) NULL,
			[LongTermStatusId] [int] NOT NULL,
			[NeglectedProgramTypeCode] [nvarchar](50) NULL,
			[NeglectedProgramTypeDescription] [nvarchar](100) NULL,
			[NeglectedProgramTypeEdFactsCode] [nvarchar](50) NULL,
			[NeglectedProgramTypeId] [int] NOT NULL,
		 CONSTRAINT [PK_DimNorDProgramStatuses] PRIMARY KEY CLUSTERED 
		(
			[DimNorDProgramStatusId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END

	-- Fix the previous definition
	IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AssessmentProgressLevel' AND Object_ID = Object_ID(N'[RDS].[DimAssessmentStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimAssessmentStatuses] DROP COLUMN AssessmentProgressLevel
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AssessmentProgressLevelCode' AND Object_ID = Object_ID(N'[RDS].[DimAssessmentStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimAssessmentStatuses] ADD AssessmentProgressLevelCode  nvarchar(50)
		ALTER TABLE [RDS].[DimAssessmentStatuses] ADD AssessmentProgressLevelDescription  nvarchar(100)
		ALTER TABLE [RDS].[DimAssessmentStatuses] ADD AssessmentProgressLevelEdFactsCode  nvarchar(50)
		ALTER TABLE [RDS].[DimAssessmentStatuses] ADD AssessmentProgressLevelId  int not null default(-1)
	END

	-- Fix the previous definition
	IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AcademicOrVocationalOutcome' AND Object_ID = Object_ID(N'[RDS].[DimEnrollment]'))
	BEGIN
		ALTER TABLE [RDS].[DimEnrollment] DROP COLUMN AcademicOrVocationalOutcome
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'AcademicOrVocationalOutcomeCode' AND Object_ID = Object_ID(N'[RDS].[DimEnrollment]'))
	BEGIN
		ALTER TABLE [RDS].[DimEnrollment] ADD AcademicOrVocationalOutcomeCode  nvarchar(50)
		ALTER TABLE [RDS].[DimEnrollment] ADD AcademicOrVocationalOutcomeDescription  nvarchar(100)
		ALTER TABLE [RDS].[DimEnrollment] ADD AcademicOrVocationalOutcomeEdFactsCode  nvarchar(50)
		ALTER TABLE [RDS].[DimEnrollment] ADD AcademicOrVocationalOutcomeId  int not null default(-1)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimNorDProgramStatuses' AND Type = N'U')
	 BEGIN
			
			CREATE TABLE [RDS].[DimNorDProgramStatuses](
				[DimNorDProgramStatusId] [int] IDENTITY(1,1) NOT NULL,
				[LongTermStatusCode] [nvarchar](50) NULL,
				[LongTermStatusDescription] [nvarchar](100) NULL,
				[LongTermStatusEdFactsCode] [nvarchar](50) NULL,
				[LongTermStatusId] int not null default(-1),
				[NeglectedProgramTypeCode] [nvarchar](50) NULL,
				[NeglectedProgramTypeDescription] [nvarchar](100) NULL,
				[NeglectedProgramTypeEdFactsCode] [nvarchar](50) NULL,
				[NeglectedProgramTypeId] int not null default(-1)
			 CONSTRAINT [PK_DimNorDProgramStatuses] PRIMARY KEY CLUSTERED 
			(
				[DimNorDProgramStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimNorDProgramStatusId' AND Object_ID = Object_ID(N'[RDS].[FactStudentCounts]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCounts] ADD DimNorDProgramStatusId int not null default(-1)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALOUTCOME' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD ACADEMICORVOCATIONALOUTCOME nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALOUTCOME' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD ACADEMICORVOCATIONALOUTCOME nvarchar(50)
	END


	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReports] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReportDtos] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReports] ADD YEAR nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReportDtos] ADD YEAR nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'[RDS].[FactStudentDisciplineReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentDisciplineReports] ADD YEAR nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'YEAR' AND Object_ID = Object_ID(N'[RDS].[FactStudentDisciplineReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentDisciplineReportDtos] ADD YEAR nvarchar(50)
	END
	
	IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERM' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] DROP COLUMN LONGTERM
	END

	IF EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERM' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] DROP COLUMN LONGTERM
	END


	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERMSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD LONGTERMSTATUS nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERMSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD LONGTERMSTATUS nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD NEGLECTEDPROGRAMTYPE nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD NEGLECTEDPROGRAMTYPE nvarchar(50)
	END

	-- FactStudentAssessments
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimNorDProgramStatusId' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessments]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessments] ADD DimNorDProgramStatusId int not null default(-1);
		--ALTER TABLE [RDS].[FactStudentAssessments]
		--ADD CONSTRAINT FK_FactStudentAssessments_DimNorDProgramStatuses FOREIGN KEY (DimNorDProgramStatusId)     
		--REFERENCES [RDS].DimNorDProgramStatuses (DimNorDProgramStatusId)     
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERMSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReports] ADD LONGTERMSTATUS nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'LONGTERMSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReportDtos] ADD LONGTERMSTATUS nvarchar(50)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReports] ADD NEGLECTEDPROGRAMTYPE nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'NEGLECTEDPROGRAMTYPE' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessmentReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentAssessmentReportDtos] ADD NEGLECTEDPROGRAMTYPE nvarchar(50)
	END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTSUBJECT' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD ASSESSMENTSUBJECT nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTSUBJECT' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD ASSESSMENTSUBJECT nvarchar(50)
	END


		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReports] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ASSESSMENTPROGRESSLEVEL' AND Object_ID = Object_ID(N'[RDS].[FactStudentCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentCountReportDtos] ADD ASSESSMENTPROGRESSLEVEL nvarchar(50)
	END

	-- FS-203 dimensions
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UnexperiencedStatusCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD UnexperiencedStatusCode nvarchar(50)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UnexperiencedStatusDescription' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD UnexperiencedStatusDescription nvarchar(200)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UnexperiencedStatusEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD UnexperiencedStatusEdFactsCode nvarchar(50)
		-- add index
		CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_UnexperiencedStatusEdFactsCode] ON [RDS].[DimPersonnelStatuses]
		(
			[UnexperiencedStatusEdFactsCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UnexperiencedStatusId' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD UnexperiencedStatusId int
	END
	

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EmergencyOrProvisionalCredentialStatusCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD EmergencyOrProvisionalCredentialStatusCode nvarchar(50)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EmergencyOrProvisionalCredentialStatusDescription' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD EmergencyOrProvisionalCredentialStatusDescription nvarchar(200)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EmergencyOrProvisionalCredentialStatusEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD EmergencyOrProvisionalCredentialStatusEdFactsCode nvarchar(50)
		-- add index
		CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode] ON [RDS].[DimPersonnelStatuses]
		(
			[EmergencyOrProvisionalCredentialStatusEdFactsCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EmergencyOrProvisionalCredentialStatusId' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD EmergencyOrProvisionalCredentialStatusId int
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OutOfFieldStatusCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD OutOfFieldStatusCode nvarchar(50)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OutOfFieldStatusDescription' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD OutOfFieldStatusDescription nvarchar(200)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OutOfFieldStatusEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD OutOfFieldStatusEdFactsCode nvarchar(50)
		-- add index
		CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_OutOfFieldStatusEdFactsCode] ON [RDS].[DimPersonnelStatuses]
		(
			[OutOfFieldStatusEdFactsCode] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	END
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OutOfFieldStatusId' AND Object_ID = Object_ID(N'[RDS].[DimPersonnelStatuses]'))
	BEGIN
		ALTER TABLE [RDS].[DimPersonnelStatuses] ADD OutOfFieldStatusId int
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'col_18a' AND Object_ID = Object_ID(N'[RDS].[FactCustomCounts]'))
	BEGIN
		ALTER TABLE [RDS].[FactCustomCounts] ADD col_18a  decimal(18,2), col_18b  decimal(18,2),col_18c  decimal(18,2),col_18d  decimal(18,2),col_18e  decimal(18,2),col_18f  decimal(18,2),col_18g  decimal(18,2),col_18h  decimal(18,2),col_18i  decimal(18,2)

	END

	-- c206
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveAndTargetedSupportCode nvarchar(50)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportDescription' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveAndTargetedSupportDescription nvarchar(200)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveAndTargetedSupportEdFactsCode nvarchar(50)
	--	-- add index
	--	CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_ComprehensiveAndTargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
	--	(
	--		[ComprehensiveAndTargetedSupportEdFactsCode] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportId' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveAndTargetedSupportId int
	--END


	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveSupportCode nvarchar(50)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportDescription' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveSupportDescription nvarchar(200)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveSupportEdFactsCode nvarchar(50)
	--	-- add index
	--	CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_ComprehensiveSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
	--	(
	--		[ComprehensiveSupportEdFactsCode] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportId' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD ComprehensiveSupportId int
	--END


	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD TargetedSupportCode nvarchar(50)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportDescription' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD TargetedSupportDescription nvarchar(200)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportEdFactsCode' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD TargetedSupportEdFactsCode nvarchar(50)
	--	-- add index
	--	CREATE NONCLUSTERED INDEX [IX_DimPersonnelStatuses_TargetedSupportEdFactsCode] ON [RDS].[DimSchoolStatuses]
	--	(
	--		[TargetedSupportEdFactsCode] ASC
	--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
	--END
	--IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportId' AND Object_ID = Object_ID(N'[RDS].[DimSchoolStatuses]'))
	--BEGIN
	--	ALTER TABLE [RDS].[DimSchoolStatuses] ADD TargetedSupportId int
	--END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimLeaId' AND Object_ID = Object_ID(N'[RDS].[FactStudentDisciplines]'))
	BEGIN
		ALTER TABLE [RDS].[FactStudentDisciplines] ADD DimLeaId int
	END

	-- c202
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimStateDefinedCustomIndicators' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[DimStateDefinedCustomIndicators](
			    [DimStateDefinedCustomIndicatorId] [int] IDENTITY(1,1) NOT NULL,
				[StateDefinedCustomIndicatorId] [int] NULL,
				[StateDefinedCustomIndicatorCode] [nvarchar](50) NULL,
				[StateDefinedCustomIndicatorDescription] [nvarchar](200) NULL,
			 CONSTRAINT [PK_DimStateDefinedCustomIndicator] PRIMARY KEY CLUSTERED 
			(
				[DimStateDefinedCustomIndicatorId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimStateDefinedCustomIndicatorId' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCounts]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD DimStateDefinedCustomIndicatorId  int not null default(-1) 
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'STATEDEFINEDCUSTOMINDICATORCODE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD STATEDEFINEDCUSTOMINDICATORCODE nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'STATEDEFINEDCUSTOMINDICATORCODE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD STATEDEFINEDCUSTOMINDICATORCODE  nvarchar(50)
	END

	-- MEP status reports
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimIndicatorStatusTypes' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[DimIndicatorStatusTypes](
			    [DimIndicatorStatusTypeId] [int] IDENTITY(1,1) NOT NULL,
				[IndicatorStatusTypeId] [int] NULL,
				[IndicatorStatusTypeCode] [nvarchar](50) NULL,
				[IndicatorStatusTypeDescription] [nvarchar](200) NULL,
				IndicatorStatusTypeEdFactsCode [varchar](50) NULL
			 CONSTRAINT [PK_DimIndicatorStatusType] PRIMARY KEY CLUSTERED 
			(
				[DimIndicatorStatusTypeId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimIndicatorStatusTypeId' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCounts]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCounts] ADD DimIndicatorStatusTypeId  int not null default(-1) 
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'INDICATORSTATUSTYPECODE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD INDICATORSTATUSTYPECODE nvarchar(50)
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'INDICATORSTATUSTYPECODE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD INDICATORSTATUSTYPECODE  nvarchar(50)
	END


	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EDUCENV' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD EDUCENV nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EDUCENV' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD EDUCENV nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSNIGHTTIMERESIDENCE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD HOMELESSNIGHTTIMERESIDENCE nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSNIGHTTIMERESIDENCE' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD HOMELESSNIGHTTIMERESIDENCE nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD HOMELESSSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD HOMELESSSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSUNACCOMPANIEDYOUTHSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSUNACCOMPANIEDYOUTHSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'MIGRANTSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD MIGRANTSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'MIGRANTSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD MIGRANTSTATUS nvarchar(50)
    END


	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'MILITARYCONNECTEDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD MILITARYCONNECTEDSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'MILITARYCONNECTEDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD MILITARYCONNECTEDSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'SEX' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReports] ADD SEX nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'SEX' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationStatusCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationStatusCountReportDtos] ADD SEX nvarchar(50)
    END

	-- c203
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EMERGENCYORPROVISIONALCREDENTIALSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReports] ADD EMERGENCYORPROVISIONALCREDENTIALSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EMERGENCYORPROVISIONALCREDENTIALSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReportDtos] ADD EMERGENCYORPROVISIONALCREDENTIALSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OUTOFFIELDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReports] ADD OUTOFFIELDSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'OUTOFFIELDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReportDtos] ADD OUTOFFIELDSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UNEXPERIENCEDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReports]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReports] ADD UNEXPERIENCEDSTATUS nvarchar(50)
    END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'UNEXPERIENCEDSTATUS' AND Object_ID = Object_ID(N'[RDS].[FactPersonnelCountReportDtos]'))
    BEGIN
        ALTER TABLE [RDS].[FactPersonnelCountReportDtos] ADD UNEXPERIENCEDSTATUS nvarchar(50)
    END

	
	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'FederalFundAllocationType' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReports]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCountReports] ADD FederalFundAllocationType nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCountReportDtos] ADD FederalFundAllocationType nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCountReports] ADD FederalProgramCode nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCountReportDtos] ADD FederalProgramCode nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCountReports] ADD FederalFundAllocated int
		ALTER TABLE [RDS].[FactOrganizationCountReportDtos] ADD FederalFundAllocated int
	END

	IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'FederalFundAllocationType' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCounts]'))
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD FederalFundAllocationType nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD FederalProgramCode nvarchar(20)
		ALTER TABLE [RDS].[FactOrganizationCounts] ADD FederalFundAllocated int
	END

	-- FS206 
	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimComprehensiveAndTargetedSupports' AND Type = N'U')
		BEGIN
			CREATE TABLE [RDS].[DimComprehensiveAndTargetedSupports](
			    DimComprehensiveAndTargetedSupportId [int] IDENTITY(1,1) NOT NULL,
				ComprehensiveAndTargetedSupportId [int] NULL,
				ComprehensiveAndTargetedSupportCode [varchar](50) NULL,
				ComprehensiveAndTargetedSupportDescription [varchar](200) NULL,
				ComprehensiveAndTargetedSupportEdFactsCode [varchar](50) NULL,
				ComprehensiveSupportId [int] NULL,
				ComprehensiveSupportCode [varchar](50) NULL,
				ComprehensiveSupportDescription [varchar](200) NULL,
				ComprehensiveSupportEdFactsCode [varchar](50) NULL,
				TargetedSupportId [int] NULL,
				TargetedSupportCode [varchar](50) NULL,
				TargetedSupportDescription [varchar](200) NULL,
				TargetedSupportEdFactsCode [varchar](50) NULL,
			 CONSTRAINT [PK_DimComprehensiveAndTargetedSupport] PRIMARY KEY CLUSTERED 
			(
				[DimComprehensiveAndTargetedSupportId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
		END
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimComprehensiveAndTargetedSupportId' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCounts]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCounts ADD DimComprehensiveAndTargetedSupportId  int not null default(-1) 
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReports]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReports ADD ComprehensiveAndTargetedSupportCode nvarchar(50)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveAndTargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReportDtos]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReportDtos ADD ComprehensiveAndTargetedSupportCode  nvarchar(50)
		END
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReports]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReports ADD ComprehensiveSupportCode nvarchar(50)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'ComprehensiveSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReportDtos]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReportDtos ADD ComprehensiveSupportCode  nvarchar(50)
		END
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReports]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReports ADD TargetedSupportCode nvarchar(50)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TargetedSupportCode' AND Object_ID = Object_ID(N'[RDS].[FactOrganizationCountReportDtos]'))
		BEGIN
			ALTER TABLE RDS.FactOrganizationCountReportDtos ADD TargetedSupportCode  nvarchar(50)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'StudentCutOverStartDate' AND Object_ID = Object_ID(N'[RDS].[FactStudentCounts]'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentCounts] ADD StudentCutOverStartDate Date null
			ALTER TABLE [RDS].[FactStudentCounts] ADD DimRaceId int not null default(-1)
			
			ALTER TABLE [RDS].[FactStudentCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentCounts_DimRaces_DimRaceId] FOREIGN KEY([DimRaceId])
			REFERENCES [RDS].[DimRaces] ([DimRaceId])
			
			ALTER TABLE [RDS].[FactStudentCounts] CHECK CONSTRAINT [FK_FactStudentCounts_DimRaces_DimRaceId]
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DisciplinaryActionStartDate' AND Object_ID = Object_ID(N'[RDS].[FactStudentDisciplines]'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentDisciplines] ADD DisciplinaryActionStartDate Date not null default(convert(date, getdate())) 
			ALTER TABLE [RDS].[FactStudentDisciplines] ADD DimRaceId int not null default(-1)

			ALTER TABLE [RDS].[FactStudentDisciplines]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentDisciplines_DimRaces_DimRaceId] FOREIGN KEY([DimRaceId])
			REFERENCES [RDS].[DimRaces] ([DimRaceId])
			
			ALTER TABLE [RDS].[FactStudentDisciplines] CHECK CONSTRAINT [FK_FactStudentDisciplines_DimRaces_DimRaceId]
		END

		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'DimRaceId' AND Object_ID = Object_ID(N'[RDS].[FactStudentAssessments]'))
		BEGIN
			ALTER TABLE [RDS].[FactStudentAssessments] ADD DimRaceId int not null default(-1)
			ALTER TABLE [RDS].[FactStudentAssessments]  WITH CHECK ADD  CONSTRAINT [FK_FactStudentAssessments_DimRaces_DimRaceId] FOREIGN KEY([DimRaceId])
			REFERENCES [RDS].[DimRaces] ([DimRaceId])
			
			ALTER TABLE [RDS].[FactStudentAssessments] CHECK CONSTRAINT [FK_FactStudentAssessments_DimRaces_DimRaceId]
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
