SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


PRINT N'Creating new FactK12StudentAssessments'

	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId];
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
		[AssessmentAdministrationId]				INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentAdministrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentCount]							INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentCount] DEFAULT ((1)) NOT NULL,
		[AssessmentId]								INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentId] DEFAULT ((-1)) NOT NULL,
		[AssessmentParticipationSessionId]			INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentParticipationSessionId] DEFAULT ((-1)) NOT NULL,
		[AssessmentPerformanceLevelId]				INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentPerformanceLevelId] DEFAULT ((-1)) NOT NULL,
		[AssessmentRegistrationId]					INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentRegistrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentResultId]						INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentResultId] DEFAULT ((-1)) NOT NULL,
		[AssessmentSubtestId]						INT CONSTRAINT [DF_FactK12StudentAssessments_AssessmentSubtestId] DEFAULT ((-1)) NOT NULL,
		[CompetencyDefinitionId]					INT CONSTRAINT [DF_FactK12StudentAssessments_CompetencyDefinitionId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId]			INT CONSTRAINT [DF_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
		[EnglishLearnerStatusId]					INT CONSTRAINT [DF_FactK12StudentAssessments_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
		[FosterCareStatusId]						INT CONSTRAINT [DF_FactK12StudentAssessments_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
		[HomelessnessStatusId]					    INT CONSTRAINT [DF_FactK12StudentAssessments_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[ImmigrantStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]							INT CONSTRAINT [DF_FactK12StudentAssessments_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[MigrantStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_MigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[MilitaryStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_MilitaryStatusId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]								INT CONSTRAINT [DF_FactK12StudentAssessments_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]							INT CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[FactK12StudentAssessmentAccommodationId]	INT CONSTRAINT [DF_FactK12StudentAssessments_FactK12StudentAssessmentAccommodationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentResultScoreValueRawScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueScaleScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValuePercentile]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueTScore]			NVARCHAR (35) NULL,
		[AssessmentResultScoreValueZScore]			NVARCHAR (35) NULL,
		[AssessmentResultScoreValueACTScore]		NVARCHAR (35) NULL,
		[AssessmentResultScoreValueSATScore]		NVARCHAR (35) NULL
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactStudentAssessments1] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [RDS].[FactK12StudentAssessments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentAssessments]', N'FactK12StudentAssessments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactStudentAssessments1]', N'PK_FactStudentAssessments';


PRINT N'Creating new indexes for Assessment process';


	CREATE NONCLUSTERED INDEX ix_DimPeople_IsActiveStudent
		ON [RDS].[DimPeople] ([IsActiveK12Student])
		INCLUDE ([BirthDate],[K12StudentStudentIdentifierState],[RecordStartDateTime],[RecordEndDateTime])

	CREATE NONCLUSTERED INDEX [ix_AssessmentResult_StudentIdentifierState_AssessmentAdministrationStartDate]
		ON [Staging].[AssessmentResult] ([StudentIdentifierState],[AssessmentAdministrationStartDate])
		INCLUDE ([LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[AssessmentTitle],[AssessmentAcademicSubject],[AssessmentPurpose],[AssessmentType],[AssessmentTypeAdministered],[AssessmentTypeAdministeredToEnglishLearners])

	CREATE NONCLUSTERED INDEX [ix_Assessment_Identifier_Title_AcademicSubject_PerformanceLevel]
		ON [Staging].[Assessment] ([AssessmentIdentifier],[AssessmentTitle],[AssessmentAcademicSubject],[AssessmentPerformanceLevelIdentifier])

	CREATE NONCLUSTERED INDEX [ix_PersonStatus_EnglishLearnerStatus]
		ON [Staging].[PersonStatus] ([EnglishLearnerStatus])
		INCLUDE ([StudentIdentifierState],[LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[EnglishLearner_StatusStartDate],[EnglishLearner_StatusEndDate])

	CREATE NONCLUSTERED INDEX [ix_PersonStatus_MigrantStatus]
		ON [Staging].[PersonStatus] ([MigrantStatus])
		INCLUDE ([StudentIdentifierState],[LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[Migrant_StatusStartDate],[Migrant_StatusEndDate])

	CREATE NONCLUSTERED INDEX [ix_PersonStatus_HomelessnessStatus]
		ON [Staging].[PersonStatus] ([HomelessnessStatus])
		INCLUDE ([StudentIdentifierState],[LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[Homelessness_StatusStartDate],[Homelessness_StatusEndDate])

	CREATE NONCLUSTERED INDEX [ix_PersonStatus_ProgramType_FosterCare]
		ON [Staging].[PersonStatus] ([ProgramType_FosterCare])
		INCLUDE ([StudentIdentifierState],[LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[FosterCare_ProgramParticipationStartDate],[FosterCare_ProgramParticipationEndDate])


PRINT N'Updating RDS.DimAssessmentAdministrations';

	EXECUTE sp_rename N'[RDS].[DimAssessmentAdministrations].[LocalEducationAgencyIdentifier]', N'LEAIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimAssessmentAdministrations].[SchoolIdentifier]', N'SchoolIdentifierSea';

	ALTER TABLE [RDS].[DimAssessmentAdministrations] ALTER COLUMN [AssessmentIdentifier] nvarchar(50) NULL;
	ALTER TABLE [RDS].[DimAssessmentAdministrations] ALTER COLUMN [AssessmentAdministrationAssessmentFamily] nvarchar(100) NULL;


PRINT N'Updating RDS.DimAssessmentPerformanceLevels';

	ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelIdentifier] nvarchar(40) NULL;
	ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelLabel] nvarchar(20) NULL;
	ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelScoreMetric] nvarchar(30) NULL;
	ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelLowerCutScore] nvarchar(30) NULL;
	ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelUpperCutScore] nvarchar(30) NULL;


PRINT N'Updating Staging.AssessmentResult';

	CREATE TABLE [Staging].[tmp_ms_xx_AssessmentResult] (
		[Id]                 									INT	IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                               	NVARCHAR (40)  	NULL,
		[LeaIdentifierSeaAccountability]                       	NVARCHAR (50)	NULL,
		[LeaIdentifierSeaAttendance]                           	NVARCHAR (50) 	NULL,
		[LeaIdentifierSeaFunding]                              	NVARCHAR (50) 	NULL,
		[LeaIdentifierSeaGraduation]                           	NVARCHAR (50) 	NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram]       	NVARCHAR (50) 	NULL,
		[SchoolIdentifierSea]                                  	VARCHAR (50)  	NULL,
		[AssessmentIdentifier]									VARCHAR (50)  	NULL,	
		[AssessmentTitle]                                      	VARCHAR (100)  	NULL,
		[AssessmentAcademicSubject]                            	VARCHAR (100)  	NULL,
		[AssessmentPurpose]                                    	VARCHAR (100)  	NULL,
		[AssessmentType]                                       	VARCHAR (100)  	NULL,
		[AssessmentTypeAdministered]                           	VARCHAR (100)  	NULL,
		[AssessmentTypeAdministeredToEnglishLearners]          	VARCHAR (100)  	NULL,
		[AssessmentAdministrationStartDate]                    	DATE           	NULL,
		[AssessmentAdministrationFinishDate]                   	DATE           	NULL,
		[AssessmentRegistrationParticipationIndicator]         	BIT            	NULL,
		[GradeLevelWhenAssessed]                               	VARCHAR (100)  	NULL,
		[ScoreValue]                                           	VARCHAR (50)   	NULL,
		[StateFullAcademicYear]                                	BIT				NULL,
		[LEAFullAcademicYear]                                  	BIT				NULL,
		[SchoolFullAcademicYear]                               	BIT				NULL,
		[AssessmentRegistrationReasonNotCompleting]            	VARCHAR (100)  	NULL,
		[AssessmentRegistrationReasonNotTested] 				VARCHAR (100) 	NULL,
		[AssessmentPerformanceLevelIdentifier]                 	VARCHAR (100)  	NULL,
		[AssessmentPerformanceLevelLabel]                      	VARCHAR (100)  	NULL,
		[AssessmentScoreMetricType]                            	VARCHAR (100)  	NULL,
		[SchoolYear]                                           	SMALLINT 	  	NULL,
		[DataCollectionName]                                   	VARCHAR (100)  	NULL,
		[DataCollectionId]                                     	INT            	NULL,
		[RunDateTime]                                          	DATETIME       	NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_AssessmentResult2] 	PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [Staging].[AssessmentResult];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_AssessmentResult]', N'AssessmentResult';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_AssessmentResult2]', N'PK_AssessmentResult', N'OBJECT';



PRINT N'v11.1 Schema Update complete.';



