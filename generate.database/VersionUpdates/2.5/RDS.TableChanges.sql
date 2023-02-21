-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------

set nocount on
begin try
 
	begin transaction

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StatePovertyDesignationCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
		begin

			Alter table rds.DimSchoolStatuses add StatePovertyDesignationId int, StatePovertyDesignationCode nvarchar(50), StatePovertyDesignationDescription nvarchar(max), StatePovertyDesignationEdFactsCode nvarchar(50)
												  

			Alter table rds.DimDemographics add HomelessNighttimeResidenceId int, HomelessNighttimeResidenceCode nvarchar(50), HomelessNighttimeResidenceDescription nvarchar(max), HomelessNighttimeResidenceEdFactsCode nvarchar(50),
			                                    HomelessUnaccompaniedYouthStatusId int, HomelessUnaccompaniedYouthStatusCode nvarchar(50), HomelessUnaccompaniedYouthStatusDescription nvarchar(max), HomelessUnaccompaniedYouthStatusEdFactsCode nvarchar(50)
	End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProgressAchievingEnglishLanguageCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
		begin

			Alter table rds.DimSchoolStatuses add ProgressAchievingEnglishLanguageId int, ProgressAchievingEnglishLanguageCode nvarchar(50), ProgressAchievingEnglishLanguageDescription nvarchar(max), ProgressAchievingEnglishLanguageEdFactsCode nvarchar(50)
												  
			End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StatePovertyDesignation' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
		begin

			Alter table rds.FactOrganizationCountReports add STATEPOVERTYDESIGNATION nvarchar(50), SCHOOLIMPROVEMENTFUNDS int
			Alter table rds.FactStudentCountReports add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
			Alter table rds.FactStudentDisciplineReports add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
			Alter table rds.FactStudentAssessmentReports add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
			Alter table rds.FactOrganizationCountReportDtos add STATEPOVERTYDESIGNATION nvarchar(50), SCHOOLIMPROVEMENTFUNDS int
			Alter table rds.FactStudentCountReportDtos add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
			Alter table rds.FactStudentDisciplineReportDtos add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
			Alter table rds.FactStudentAssessmentReportDtos add HOMELESSNIGHTTIMERESIDENCE nvarchar(50), HOMELESSUNACCOMPANIEDYOUTHSTATUS nvarchar(50)
	End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DimCharterSchoolPrimaryApproverAgencyDirectoryId' AND Object_ID = Object_ID(N'RDS.FactOrganizationCounts'))
		begin
			Alter table rds.FactOrganizationCounts add DimCharterSchoolPrimaryApproverAgencyDirectoryId int, 
													   DimCharterSchoolSecondaryApproverAgencyDirectoryId int, 
													   DimCharterSchooleManagerDirectoryId int, 
													   DimCharterSchoolUpdatedManagerDirectoryId int,
													   SCHOOLIMPROVEMENTFUNDS int

	End


	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EconomicallyDisadvantagedStudentCount' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	Begin
			Alter table rds.FactOrganizationCountReports add EconomicallyDisadvantagedStudentCount int			
	End

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'DimAttendance' AND Type = N'U')
	 BEGIN
			
			CREATE TABLE [RDS].[DimAttendance](
				[DimAttendanceId] [int] IDENTITY(1,1) NOT NULL,
				[AbsenteeismCode] [nvarchar](50) NULL,
				[AbsenteeismDescription] [nvarchar](200) NULL,
				[AbsenteeismEdFactsCode] [nvarchar](50) NULL,
				[AbsenteeismId] [int] NULL,
			 CONSTRAINT [PK_DimAttendance] PRIMARY KEY CLUSTERED 
			(
				[DimAttendanceId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
			
			Alter table rds.FactStudentCounts add DimAttendanceId int not null default(-1)
			Alter table rds.FactStudentCountReports add ATTENDANCE varchar(50)
			Alter table rds.FactStudentCountReportDtos add ATTENDANCE varchar(50)

	END


	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'EconomicallyDisadvantagedStudentCount' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	Begin
			Alter table rds.FactOrganizationCountReportDtos add EconomicallyDisadvantagedStudentCount int			
	End

	--fS170

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipient' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	Begin
			Alter table rds.FactOrganizationCountReports add McKinneyVentoSubgrantRecipient varchar(50)			
	End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipient' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	Begin
			Alter table rds.FactOrganizationCountReportDtos add McKinneyVentoSubgrantRecipient varchar(50)			
	End


	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'McKinneyVentoSubgrantRecipientId' AND Object_ID = Object_ID(N'RDS.DimDirectoryStatuses'))
	Begin
			Alter table rds.DimDirectoryStatuses add McKinneyVentoSubgrantRecipientId int	,
													McKinneyVentoSubgrantRecipientCode varchar(50),
													McKinneyVentoSubgrantRecipientDescription varchar(100),
													McKinneyVentoSubgrantRecipientEdFactsCode varchar(50)
	End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProgressAchievingEnglishLanguage' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	Begin
			Alter table rds.FactOrganizationCountReportDtos add ProgressAchievingEnglishLanguage nvarchar(max)			
	End
	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'ProgressAchievingEnglishLanguage' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	Begin
			Alter table rds.FactOrganizationCountReports add ProgressAchievingEnglishLanguage nvarchar(max)			
	End
	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StateDefinedStatus' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReportDtos'))
	Begin
			Alter table rds.FactOrganizationCountReportDtos add StateDefinedStatus nvarchar(max)			
	End
	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'StateDefinedStatus' AND Object_ID = Object_ID(N'RDS.FactOrganizationCountReports'))
	Begin
			Alter table rds.FactOrganizationCountReports add StateDefinedStatus nvarchar(max)			
	End

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'DisciplineELStatusCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
	Begin
			Alter table RDS.DimDisciplines add DisciplineELStatusId int		
			Alter table RDS.DimDisciplines add DisciplineELStatusCode varchar(50)
			Alter table RDS.DimDisciplines add DisciplineELStatusDescription varchar(200)
			Alter table RDS.DimDisciplines add DisciplineELStatusEdFactsCode varchar(50)

			Alter Table RDS.FactStudentDisciplineReports add DISCIPLINEELSTATUS varchar(50)
			Alter Table RDS.FactStudentDisciplineReportDtos add DISCIPLINEELSTATUS varchar(50)
	End


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
