﻿	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CountDateId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_FactTypeId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SeaId];
--	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_IeuId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_LeaId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12SchoolId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12StudentId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentSubtestId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentAdministrationId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentRegistrationId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentParticipationSessionId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentResultId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentPerformanceLevelId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CompetencyDefinitionId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_GradeLevelWhenAssessedId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_IdeaStatusId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_K12DemographicId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_NOrDStatusId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId];
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentCount];

	ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] DROP CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId];
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces] DROP CONSTRAINT [FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments];


	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentAssessments] (
		[FactK12StudentAssessmentId]				INT IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]								INT CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]								INT CONSTRAINT [DF_FactK12StudentAssessments_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[SeaId]										INT CONSTRAINT [DF_FactK12StudentAssessments_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]										INT CONSTRAINT [DF_FactK12StudentAssessments_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaId]										INT CONSTRAINT [DF_FactK12StudentAssessments_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]								INT CONSTRAINT [DF_FactK12StudentAssessments_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]								BIGINT CONSTRAINT [DF_FactK12StudentAssessments_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelWhenAssessedId]					INT CONSTRAINT [DF_FactK12StudentAssessments_GradeLevelWhenAssessedId] DEFAULT ((-1)) NOT NULL,
		[AssessmentId]								INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentId] DEFAULT ((-1)) NOT NULL,
		[AssessmentSubtestId]						INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentSubtestId] DEFAULT ((-1)) NOT NULL,
		[AssessmentAdministrationId]				INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentAdministrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentRegistrationId]					INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentRegistrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentParticipationSessionId]			INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentParticipationSessionId] DEFAULT ((-1)) NOT NULL,
		[AssessmentResultId]						INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentResultId] DEFAULT ((-1)) NOT NULL,
		[AssessmentPerformanceLevelId]				INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentPerformanceLevelId] DEFAULT ((-1)) NOT NULL,
		[AssessmentCount]							INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentCount] DEFAULT ((1)) NOT NULL,
		[AssessmentResultScoreValueRawScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueScaleScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValuePercentile]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueTScore]			NVARCHAR (35) NULL,
		[AssessmentResultScoreValueZScore]			NVARCHAR (35) NULL,
		[AssessmentResultScoreValueACTScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueSATScore]		NVARCHAR (35) NULL,
		[CompetencyDefinitionId]					INT CONSTRAINT [DF_FactK12StudentAssessments_CompetencyDefinitionId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[HomelessnessStatusId]					    INT CONSTRAINT [DF_FactK12StudentAssessments_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId]			INT CONSTRAINT [DF_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
		[EnglishLearnerStatusId]					INT CONSTRAINT [DF_FactK12StudentAssessments_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
		[FosterCareStatusId]						INT CONSTRAINT [DF_FactK12StudentAssessments_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[ImmigrantStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]							INT CONSTRAINT [DF_FactK12StudentAssessments_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[MigrantStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_MigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[MilitaryStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_MilitaryStatusId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[FactK12StudentAssessmentAccommodationId]	INT CONSTRAINT [DF_FactK12StudentAssessments_FactK12StudentAssessmentAccommodationId] DEFAULT ((-1)) NOT NULL
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactStudentAssessments1] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [RDS].[FactK12StudentAssessments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentAssessments]', N'FactK12StudentAssessments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactStudentAssessments1]', N'PK_FactStudentAssessments';

	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD ASSESSMENTTYPEADMINISTERED nvarchar(50);

	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].FOSTERCAREPROGRAM', N'PROGRAMPARTICIPATIONFOSTERCARE', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ASSESSMENTSUBJECT', N'ASSESSMENTACADEMICSUBJECT', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].CTEPROGRAM', N'CTEPARTICIPANT', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ACADEMICORVOCATIONALEXITOUTCOME', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ACADEMICORVOCATIONALOUTCOME', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].IDEAEDUCATIONALENVIRONMENT', N'IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD', 'COLUMN';

	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE nvarchar(50);

	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].SINGLEPARENTORSINGLEPREGNANTWOMAN', N'SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS', 'COLUMN';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].PERFORMANCELEVEL', N'ASSESSMENTPERFORMANCELEVELIDENTIFIER', 'COLUMN';

	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD CONSOLIDATEDMEPFUNDSSTATUS nvarchar(50);
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD CONTINUATIONOFSERVICESREASON nvarchar(50);
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTEDUCATIONPROGRAMENROLLMENTTYPE nvarchar(50);
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTEDUCATIONPROGRAMSERVICESTYPE nvarchar(50);
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTPRIORITIZEDFORSERVICES nvarchar(50);
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDORDELINQUENTLONGTERMSTATUS nvarchar(50);

----------------------------------------------------------------------------------------------------------
--Repopulate the DimAssessmentRegistrations table (fields were swapped when it was created in v11)
----------------------------------------------------------------------------------------------------------
﻿--Repopulate the DimAssessmentRegistrations table (fields were swapped when it was created in v11)

	TRUNCATE TABLE RDS.DimAssessmentRegistrations

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentRegistrations d WHERE d.DimAssessmentRegistrationId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimAssessmentRegistrations ON

	INSERT INTO [RDS].[DimAssessmentRegistrations]
           ([DimAssessmentRegistrationId]
		   ,[AssessmentRegistrationParticipationIndicatorCode]
           ,[AssessmentRegistrationParticipationIndicatorDescription]
           ,[AssessmentRegistrationCompletionStatusCode]
           ,[AssessmentRegistrationCompletionStatusDescription]
           ,[StateFullAcademicYearCode]
           ,[StateFullAcademicYearDescription]
           ,[StateFullAcademicYearEdFactsCode]
           ,[LeaFullAcademicYearCode]
           ,[LeaFullAcademicYearDescription]
           ,[LeaFullAcademicYearEdFactsCode]
           ,[SchoolFullAcademicYearCode]
           ,[SchoolFullAcademicYearDescription]
           ,[SchoolFullAcademicYearEdFactsCode]
		   ,[AssessmentRegistrationReasonNotCompletingCode]	
		   ,[AssessmentRegistrationReasonNotCompletingDescription]
		   ,[AssessmentRegistrationReasonNotCompletingEdFactsCode]	
		   ,[ReasonNotTestedCode]	
		   ,[ReasonNotTestedDescription]	
		   ,[ReasonNotTestedEdFactsCode]
		   )
			VALUES (
				  -1
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				)

		SET IDENTITY_INSERT RDS.DimAssessmentRegistrations OFF

	END

		IF OBJECT_ID('tempdb..#AssessmentRegistrationParticipationIndicator') IS NOT NULL
			DROP TABLE  #AssessmentRegistrationParticipationIndicator
			
		CREATE TABLE #AssessmentRegistrationParticipationIndicator (AssessmentRegistrationParticipationIndicatorCode VARCHAR(50), AssessmentRegistrationParticipationIndicatorDescription VARCHAR(200))

		INSERT INTO #AssessmentRegistrationParticipationIndicator VALUES ('MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationParticipationIndicator 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationParticipationIndicator'


		IF OBJECT_ID('tempdb..#AssessmentRegistrationCompletionStatus') IS NOT NULL
			DROP TABLE #AssessmentRegistrationCompletionStatus

		CREATE TABLE #AssessmentRegistrationCompletionStatus (AssessmentRegistrationCompletionStatusCode VARCHAR(50), AssessmentRegistrationCompletionStatusDescription VARCHAR(200))

		INSERT INTO #AssessmentRegistrationCompletionStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationCompletionStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationCompletionStatus'


		IF OBJECT_ID('tempdb..#StateFullAcademicYear') IS NOT NULL
			DROP TABLE #StateFullAcademicYear

		CREATE TABLE #StateFullAcademicYear (StateFullAcademicYearCode VARCHAR(50), StateFullAcademicYearDescription VARCHAR(200), StateFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #StateFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #StateFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'StateFullAcademicYear'


		IF OBJECT_ID('tempdb..#LeaFullAcademicYear') IS NOT NULL
			DROP TABLE #LeaFullAcademicYear

		CREATE TABLE #LeaFullAcademicYear (LeaFullAcademicYearCode VARCHAR(50), LeaFullAcademicYearDescription VARCHAR(200), LeaFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #LeaFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #LeaFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'LeaFullAcademicYear'

		IF OBJECT_ID('tempdb..#SchoolFullAcademicYear') IS NOT NULL
			DROP TABLE #SchoolFullAcademicYear

		CREATE TABLE #SchoolFullAcademicYear (SchoolFullAcademicYearCode VARCHAR(50), SchoolFullAcademicYearDescription VARCHAR(200), SchoolFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #SchoolFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #SchoolFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SchoolFullAcademicYear'

		IF OBJECT_ID('tempdb..#AssessmentRegistrationReasonNotCompleting') IS NOT NULL
			DROP TABLE #AssessmentRegistrationReasonNotCompleting

		CREATE TABLE #AssessmentRegistrationReasonNotCompleting (AssessmentRegistrationReasonNotCompletingCode VARCHAR(50), AssessmentRegistrationReasonNotCompletingDescription VARCHAR(200), AssessmentRegistrationReasonNotCompletingEdFactsCode VARCHAR(50))

		INSERT INTO #AssessmentRegistrationReasonNotCompleting VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationReasonNotCompleting 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE 
				WHEN CedsOptionSetCode <> 'MISSING' THEN 'NPART'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationReasonNotCompleting'

		IF OBJECT_ID('tempdb..#ReasonNotTested') IS NOT NULL
			DROP TABLE #ReasonNotTested
		
		CREATE TABLE #ReasonNotTested (ReasonNotTestedCode VARCHAR(50), ReasonNotTestedDescription VARCHAR(200), ReasonNotTestedEdFactsCode VARCHAR(50))

		INSERT INTO #ReasonNotTested VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #ReasonNotTested 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN '03451' THEN 'NPART'
				WHEN '03452' THEN 'NPART'
				WHEN '03453' THEN 'NPART'
				WHEN '03454' THEN 'MEDEXEMPT'
				WHEN '03455' THEN 'NPART'
				WHEN '03456' THEN 'NPART'
				WHEN '09999' THEN 'NPART'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'ReasonNotTested'


	INSERT INTO [RDS].[DimAssessmentRegistrations]
           ([AssessmentRegistrationParticipationIndicatorCode]
           ,[AssessmentRegistrationParticipationIndicatorDescription]
           ,[AssessmentRegistrationCompletionStatusCode]
           ,[AssessmentRegistrationCompletionStatusDescription]
           ,[StateFullAcademicYearCode]
           ,[StateFullAcademicYearDescription]
           ,[StateFullAcademicYearEdFactsCode]
           ,[LeaFullAcademicYearCode]
           ,[LeaFullAcademicYearDescription]
           ,[LeaFullAcademicYearEdFactsCode]
           ,[SchoolFullAcademicYearCode]
           ,[SchoolFullAcademicYearDescription]
           ,[SchoolFullAcademicYearEdFactsCode]
		   ,[AssessmentRegistrationReasonNotCompletingCode]	
		   ,[AssessmentRegistrationReasonNotCompletingDescription]
		   ,[AssessmentRegistrationReasonNotCompletingEdFactsCode]	
		   ,[ReasonNotTestedCode]	
		   ,[ReasonNotTestedDescription]	
		   ,[ReasonNotTestedEdFactsCode]
)
	SELECT 
		arpi.AssessmentRegistrationParticipationIndicatorCode
		,arpi.AssessmentRegistrationParticipationIndicatorDescription
		,arcs.AssessmentRegistrationCompletionStatusCode
		,arcs.AssessmentRegistrationCompletionStatusDescription
		,sfay.StateFullAcademicYearCode
		,sfay.StateFullAcademicYearDescription
		,sfay.StateFullAcademicYearEdFactsCode
		,lfay.LeaFullAcademicYearCode
		,lfay.LeaFullAcademicYearDescription
		,lfay.LeaFullAcademicYearEdFactsCode
		,schfay.SchoolFullAcademicYearCode
		,schfay.SchoolFullAcademicYearDescription
		,schfay.SchoolFullAcademicYearEdFactsCode
		,arrnc.AssessmentRegistrationReasonNotCompletingCode	
		,arrnc.AssessmentRegistrationReasonNotCompletingDescription
		,arrnc.AssessmentRegistrationReasonNotCompletingEdFactsCode	
		,rntc.ReasonNotTestedCode	
		,rntc.ReasonNotTestedDescription	
		,rntc.ReasonNotTestedEdFactsCode
	FROM #AssessmentRegistrationCompletionStatus arcs
	CROSS JOIN #AssessmentRegistrationParticipationIndicator arpi
	CROSS JOIN #StateFullAcademicYear sfay
	CROSS JOIN #LeaFullAcademicYear lfay
	CROSS JOIN #SchoolFullAcademicYear schfay
	CROSS JOIN #AssessmentRegistrationReasonNotCompleting arrnc
	CROSS JOIN #ReasonNotTested rntc
	LEFT JOIN rds.DimAssessmentRegistrations dar
		ON	arcs.AssessmentRegistrationCompletionStatusCode = dar.AssessmentRegistrationCompletionStatusCode
		AND arpi.AssessmentRegistrationParticipationIndicatorCode = dar.AssessmentRegistrationParticipationIndicatorCode
		AND sfay.StateFullAcademicYearCode = dar.StateFullAcademicYearCode
		AND lfay.LeaFullAcademicYearDescription = dar.LeaFullAcademicYearCode
		AND schfay.SchoolFullAcademicYearCode = dar.SchoolFullAcademicYearCode	
		AND arrnc.AssessmentRegistrationReasonNotCompletingCode = dar.AssessmentRegistrationReasonNotCompletingCode
		AND rntc.ReasonNotTestedCode = dar.ReasonNotTestedCode
	WHERE dar.DimAssessmentRegistrationId IS NULL

	DROP TABLE #AssessmentRegistrationCompletionStatus
	DROP TABLE #AssessmentRegistrationParticipationIndicator
	DROP TABLE #LeaFullAcademicYear
	DROP TABLE #SchoolFullAcademicYear
	DROP TABLE #StateFullAcademicYear
	DROP TABLE #AssessmentRegistrationReasonNotCompleting
	DROP TABLE #ReasonNotTested


