SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


PRINT N'Creating new indexes for Assessment process';


		CREATE NONCLUSTERED INDEX ix_DimPeople_IsActiveStudent
			ON [RDS].[DimPeople] ([IsActiveK12Student])
			INCLUDE ([BirthDate],[K12StudentStudentIdentifierState],[RecordStartDateTime],[RecordEndDateTime])

		CREATE NONCLUSTERED INDEX [ix_AssessmentResult_StudentIdentifierState_AssessmentAdministrationStartDate]
			ON [Staging].[AssessmentResult] ([StudentIdentifierState],[AssessmentAdministrationStartDate])
			INCLUDE ([LeaIdentifierSeaAccountability],[SchoolIdentifierSea],[AssessmentTitle],[AssessmentAcademicSubject],[AssessmentPurpose],[AssessmentType],[AssessmentTypeAdministered],[AssessmentTypeAdministeredToEnglishLearners])

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


PRINT N'Update complete.';



