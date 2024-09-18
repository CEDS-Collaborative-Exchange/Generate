-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCteStatusId'  AND Object_ID = Object_ID(N'rds.FactStudentCounts'))
		BEGIN
			ALTER TABLE RDS.FactStudentCounts
			ADD DimCteStatusId int not null default(-1), DimEnrollmentStatusId int not null default(-1)
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCteStatusId'  AND Object_ID = Object_ID(N'rds.FactStudentAssessments'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessments
			ADD DimCteStatusId int not null default(-1), DimEnrollmentStatusId int not null default(-1)
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'DimCteStatusId'  AND Object_ID = Object_ID(N'rds.FactStudentDisciplines'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplines
			ADD DimCteStatusId int not null default(-1)
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'CTEAEDISPLACEDHOMEMAKERINDICATOR'  AND Object_ID = Object_ID(N'rds.FactStudentDisciplineReports'))
		BEGIN
			ALTER TABLE RDS.FactStudentDisciplineReports
			ADD CTEAEDISPLACEDHOMEMAKERINDICATOR nvarchar(50) NULL,
			    CTENONTRADITIONALGENDERSTATUS nvarchar(50) NULL,
			    SINGLEPARENTORSINGLEPREGNANTWOMAN nvarchar(50) NULL,
				CTEGRADUATIONRATEINCLUSION nvarchar(50) NULL,
				REPRESENTATIONSTATUS nvarchar(50) NULL
		END

		if exists(select 1 from sys.columns where name = 'DISPLACEDHOMEMAKER' and object_name(object_id) = 'FactStudentAssessmentReports')
		begin
			exec sp_rename 'RDS.FactStudentAssessmentReports.DISPLACEDHOMEMAKER', 'CTEAEDISPLACEDHOMEMAKERINDICATOR', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'NONTRADITIONALENROLLEE' and object_name(object_id) = 'FactStudentAssessmentReports')
		begin
			exec sp_rename 'RDS.FactStudentAssessmentReports.NONTRADITIONALENROLLEE', 'CTENONTRADITIONALGENDERSTATUS', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'SINGLEPARENT' and object_name(object_id) = 'FactStudentAssessmentReports')
		begin
			exec sp_rename 'RDS.FactStudentAssessmentReports.SINGLEPARENT', 'SINGLEPARENTORSINGLEPREGNANTWOMAN', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'INCLUTYP' and object_name(object_id) = 'FactStudentAssessmentReports')
		begin
			exec sp_rename 'RDS.FactStudentAssessmentReports.INCLUTYP', 'CTEGRADUATIONRATEINCLUSION', 'COLUMN'
		end


		if exists(select 1 from sys.columns where name = 'DISPLACEDHOMEMAKER' and object_name(object_id) = 'FactStudentCountReports')
		begin
			exec sp_rename 'RDS.FactStudentCountReports.DISPLACEDHOMEMAKER', 'CTEAEDISPLACEDHOMEMAKERINDICATOR', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'NONTRADITIONALENROLLEE' and object_name(object_id) = 'FactStudentCountReports')
		begin
			exec sp_rename 'RDS.FactStudentCountReports.NONTRADITIONALENROLLEE', 'CTENONTRADITIONALGENDERSTATUS', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'SINGLEPARENT' and object_name(object_id) = 'FactStudentCountReports')
		begin
			exec sp_rename 'RDS.FactStudentCountReports.SINGLEPARENT', 'SINGLEPARENTORSINGLEPREGNANTWOMAN', 'COLUMN'
		end

		if exists(select 1 from sys.columns where name = 'INCLUTYP' and object_name(object_id) = 'FactStudentCountReports')
		begin
			exec sp_rename 'RDS.FactStudentCountReports.INCLUTYP', 'CTEGRADUATIONRATEINCLUSION', 'COLUMN'
		end

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimCteStatuses' AND Type = N'U')
		BEGIN
			
			CREATE TABLE rds.DimCteStatuses(
				DimCteStatusId int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				CteProgramCode [nvarchar](50) NULL,
				CteProgramDescription [nvarchar](200) NULL,
				CteProgramEdFactsCode [nvarchar](50) NULL,
				CteProgramId [int] NULL,
				CteAeDisplacedHomemakerIndicatorCode [nvarchar](50) NULL,
				CteAeDisplacedHomemakerIndicatorDescription [nvarchar](200) NULL,
				CteAeDisplacedHomemakerIndicatorEdFactsCode [nvarchar](50) NULL,
				CteAeDisplacedHomemakerIndicatorId [int] NULL,
				CteNontraditionalGenderStatusCode [nvarchar](50) NULL,
				CteNontraditionalGenderStatusDescription [nvarchar](200) NULL,
				CteNontraditionalGenderStatusEdFactsCode [nvarchar](50) NULL,
				CteNontraditionalGenderStatusId [int] NULL,
				RepresentationStatusCode [nvarchar](50) NULL,
				RepresentationStatusDescription [nvarchar](200) NULL,
				RepresentationStatusEdFactsCode [nvarchar](50) NULL,
				RepresentationStatusId [int] NULL,
				SingleParentOrSinglePregnantWomanCode [nvarchar](50) NULL,
				SingleParentOrSinglePregnantWomanDescription [nvarchar](200) NULL,
				SingleParentOrSinglePregnantWomanEdFactsCode [nvarchar](50) NULL,
				SingleParentOrSinglePregnantWomanId [int] NULL,
				CteGraduationRateInclusionCode [nvarchar](450) NULL,
				CteGraduationRateInclusionDescription [nvarchar](200) NULL,
				CteGraduationRateInclusionEdFactsCode [nvarchar](50) NULL,
				CteGraduationRateInclusionId [int] NULL
			 )
		END

		IF NOT EXISTS (SELECT 1 FROM sys.Tables WHERE Name = N'DimEnrollmentStatuses' AND Type = N'U')
		BEGIN

			CREATE TABLE rds.DimEnrollmentStatuses(
				DimEnrollmentStatusId int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				ExitOrWithdrawalCode [nvarchar](50) NULL,
				ExitOrWithdrawalDescription [nvarchar](200) NULL,
				ExitOrWithdrawalEdFactsCode [nvarchar](50) NULL,
				ExitOrWithdrawalId [int] NULL
			 )		

		END

		IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_Codes' AND object_id = OBJECT_ID('rds.DimProgramStatuses'))
		BEGIN
			DROP INDEX [IX_DimProgramStatuses_Codes] ON [RDS].[DimProgramStatuses]
			DROP INDEX [IX_DimProgramStatuses_CteProgramEdFactsCode] ON [RDS].[DimProgramStatuses]

			CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_ProgramStatusCodes] ON [RDS].[DimProgramStatuses]
			(
				[Section504ProgramCode] ASC,
				[FoodServiceEligibilityCode] ASC,
				[ImmigrantTitleIIIProgramCode] ASC,
				[FosterCareProgramCode] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS =	ON)

			ALTER TABLE rds.DimProgramStatuses
			DROP COLUMN CteProgramCode, CteProgramDescription, CteProgramEdFactsCode, CteProgramId
		END

		IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimStudentStatuses_DisplacedHomeMakerCode' AND object_id = OBJECT_ID('rds.DimStudentStatuses'))
		BEGIN

			DROP INDEX [IX_DimStudentStatuses_DisplacedHomeMakerCode] ON [RDS].[DimStudentStatuses]
			DROP INDEX [IX_DimStudentStatuses_INCLUTYPCode] ON [RDS].[DimStudentStatuses]
			DROP INDEX [IX_DimStudentStatuses_NonTraditionalEnrolleeCode] ON [RDS].[DimStudentStatuses]
			DROP INDEX [IX_DimStudentStatuses_RepresentationStatusCode] ON [RDS].[DimStudentStatuses]
			DROP INDEX [IX_DimStudentStatuses_SingleParentCode] ON [RDS].[DimStudentStatuses]

			ALTER TABLE rds.DimStudentStatuses
			DROP COLUMN DisplacedHomeMakerCode, DisplacedHomeMakerDescription, DisplacedHomeMakerEdFactsCode, DisplacedHomeMakerId,
						NonTraditionalEnrolleeCode, NonTraditionalEnrolleeDescription, NonTraditionalEnrolleeEdFactsCode, NonTraditionalEnrolleeId,
						RepresentationStatusCode, RepresentationStatusDescription, RepresentationStatusEdFactsCode, RepresentationStatusId,
						SingleParentCode, SingleParentDescription, SingleParentEdFactsCode, SingleParentId,
						INCLUTYPCode, INCLUTYPDescription, INCLUTYPEdFactsCode, INCLUTYPId

		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AcademicOrVocationalOutcomeCode'  AND Object_ID = Object_ID(N'rds.DimEnrollment'))
		BEGIN
			
			IF EXISTS(select 1 from sys.objects WHERE type = 'D' AND name = 'DF__DimEnroll__Acade__60B3145E')
			BEGIN
				ALTER TABLE rds.DimEnrollment DROP CONSTRAINT DF__DimEnroll__Acade__60B3145E
			END
					
			ALTER TABLE rds.DimEnrollment
			DROP COLUMN AcademicOrVocationalOutcomeCode, AcademicOrVocationalOutcomeDescription, AcademicOrVocationalOutcomeEdFactsCode, AcademicOrVocationalOutcomeId
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'AcademicOrVocationalOutcomeCode'  AND Object_ID = Object_ID(N'rds.DimNorDProgramStatuses'))
		BEGIN
			ALTER TABLE RDS.DimNorDProgramStatuses
			ADD [AcademicOrVocationalOutcomeCode] [nvarchar](50) NULL,
				[AcademicOrVocationalOutcomeDescription] [nvarchar](100) NULL,
				[AcademicOrVocationalOutcomeEdFactsCode] [nvarchar](50) NULL,
				[AcademicOrVocationalOutcomeId] [int] NOT NULL default(-1),
				[AcademicOrVocationalExitOutcomeCode] [nvarchar](50) NULL,
				[AcademicOrVocationalExitOutcomeDescription] [nvarchar](100) NULL,
				[AcademicOrVocationalExitOutcomeEdFactsCode] [nvarchar](50) NULL,
				[AcademicOrVocationalExitOutcomeId] [int] NOT NULL default(-1)

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALEXITOUTCOME'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReports
			ADD ACADEMICORVOCATIONALEXITOUTCOME nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALEXITOUTCOME'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD ACADEMICORVOCATIONALEXITOUTCOME nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALEXITOUTCOME'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReportDtos
			ADD ACADEMICORVOCATIONALEXITOUTCOME nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ACADEMICORVOCATIONALEXITOUTCOME'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD ACADEMICORVOCATIONALEXITOUTCOME nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimSeas'))
		BEGIN
			ALTER TABLE RDS.DimSeas
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
		BEGIN
			ALTER TABLE RDS.DimLeas
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimSchools'))
		BEGIN
			ALTER TABLE RDS.DimSchools
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
		BEGIN
			ALTER TABLE RDS.DimPersonnel
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimStudents'))
		BEGIN
			ALTER TABLE RDS.DimStudents
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'RDS.DimCharterSchoolApproverAgency'))
		BEGIN
			ALTER TABLE RDS.DimCharterSchoolApproverAgency
			ADD RecordStartDateTime datetime NULL, RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HomelessServicedIndicatorCode'  AND Object_ID = Object_ID(N'rds.DimProgramStatuses'))
		BEGIN
			ALTER TABLE RDS.DimProgramStatuses
			ADD [HomelessServicedIndicatorCode] [nvarchar](50) NULL,
				[HomelessServicedIndicatorDescription] [nvarchar](100) NULL,
				[HomelessServicedIndicatorEdFactsCode] [nvarchar](50) NULL,
				[HomelessServicedIndicatorId] [int] NOT NULL default(-1)

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReports
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReportDtos
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentDisciplineReports
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentDisciplineReportDtos
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'HOMELESSSERVICEDINDICATOR'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD HOMELESSSERVICEDINDICATOR nvarchar(50) NULL
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_HomelessServicedIndicatorCode' AND object_id = OBJECT_ID('rds.DimProgramStatuses'))
		BEGIN

			CREATE NONCLUSTERED INDEX IX_DimProgramStatuses_HomelessServicedIndicatorCode ON [RDS].[DimProgramStatuses]
			(
				[HomelessServicedIndicatorCode] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LepPerkinsStatusCode'  AND Object_ID = Object_ID(N'rds.DimCteStatuses'))
		BEGIN
			ALTER TABLE RDS.DimCteStatuses
			ADD [LepPerkinsStatusCode] [nvarchar](50) NULL,
				[LepPerkinsStatusDescription] [nvarchar](100) NULL,
				[LepPerkinsStatusEdFactsCode] [nvarchar](50) NULL,
				[LepPerkinsStatusId] [int] NOT NULL default(-1)

		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReports
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentCountReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentCountReportDtos
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentDisciplineReports
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentDisciplineReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentDisciplineReportDtos
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReports'))
		BEGIN			
			ALTER TABLE RDS.FactStudentAssessmentReports
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEPPERKINSSTATUS'  AND Object_ID = Object_ID(N'RDS.FactStudentAssessmentReportDtos'))
		BEGIN			
			ALTER TABLE RDS.FactStudentAssessmentReportDtos
			ADD LEPPERKINSSTATUS nvarchar(50) NULL
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