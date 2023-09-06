	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId];
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