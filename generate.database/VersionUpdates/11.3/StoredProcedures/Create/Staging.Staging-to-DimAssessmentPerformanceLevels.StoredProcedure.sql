CREATE PROCEDURE [Staging].[Staging-to-DimAssessmentPerformanceLevels]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentPerformanceLevels WHERE DimAssessmentPerformanceLevelId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimAssessmentPerformanceLevels ON

			INSERT INTO RDS.DimAssessmentPerformanceLevels
				(DimAssessmentPerformanceLevelId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimAssessmentPerformanceLevels off
		END

		IF OBJECT_ID(N'tempdb..#AssessmentPerformanceLevels') IS NOT NULL DROP TABLE #AssessmentPerformanceLevels
		CREATE TABLE #AssessmentPerformanceLevels (
			AssessmentPerformanceLevelIdentifier		NVARCHAR(40) NULL
			, AssessmentPerformanceLevelLabel			NVARCHAR(20) NULL
			, AssessmentPerformanceLevelScoreMetric		NVARCHAR(30) NULL
			, AssessmentPerformanceLevelLowerCutScore	NVARCHAR(30) NULL
			, AssessmentPerformanceLevelUpperCutScore	NVARCHAR(30) NULL
		)
		
		INSERT INTO #AssessmentPerformanceLevels (
			AssessmentPerformanceLevelIdentifier	
			, AssessmentPerformanceLevelLabel		
			, AssessmentPerformanceLevelScoreMetric	
			, AssessmentPerformanceLevelLowerCutScore
			, AssessmentPerformanceLevelUpperCutScore
		)		
		SELECT DISTINCT
			sa.AssessmentPerformanceLevelIdentifier
			, sa.AssessmentPerformanceLevelLabel
--verify the Score Metric field and why it is in Staging.AssessmentResult and not in Staging.Assessment
			, NULL											AS AssessmentPerformanceLevelScoreMetric
			, NULL											AS AssessmentPerformanceLevelLowerCutScore
			, NULL											AS AssessmentPerformanceLevelUpperCutScore
		FROM Staging.AssessmentResult sar
		JOIN Staging.Assessment sa
			ON ISNULL(sar.AssessmentTitle, '')								= ISNULL(sa.AssessmentTitle, '')
			AND ISNULL(sar.AssessmentAcademicSubject, '')					= ISNULL(sa.AssessmentAcademicSubject, '') 
			AND ISNULL(sar.AssessmentPurpose, '')							= ISNULL(sa.AssessmentPurpose, '') 
			AND ISNULL(sar.AssessmentType, '')								= ISNULL(sa.AssessmentType, '')
			AND ISNULL(sar.AssessmentTypeAdministered, '')					= ISNULL(sa.AssessmentTypeAdministered, '')
			AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, '') = ISNULL(sa.AssessmentTypeAdministeredToEnglishLearners, '')
			AND ISNULL(sar.AssessmentPerformanceLevelIdentifier, '')		= ISNULL(sa.AssessmentPerformanceLevelIdentifier, '')
			AND ISNULL(sar.AssessmentPerformanceLevelLabel, '')				= ISNULL(sa.AssessmentPerformanceLevelLabel, '')


		MERGE RDS.DimAssessmentPerformanceLevels AS trgt
		USING #AssessmentPerformanceLevels AS src
				ON  ISNULL(trgt.AssessmentPerformanceLevelIdentifier, '')	= ISNULL(src.AssessmentPerformanceLevelIdentifier, '')
				AND ISNULL(trgt.AssessmentPerformanceLevelLabel, '')		= ISNULL(src.AssessmentPerformanceLevelLabel, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			AssessmentPerformanceLevelIdentifier	
			, AssessmentPerformanceLevelLabel		
			, AssessmentPerformanceLevelScoreMetric	
			, AssessmentPerformanceLevelLowerCutScore
			, AssessmentPerformanceLevelUpperCutScore
		)
		VALUES (
			src.AssessmentPerformanceLevelIdentifier	
			, src.AssessmentPerformanceLevelLabel		
			, src.AssessmentPerformanceLevelScoreMetric	
			, src.AssessmentPerformanceLevelLowerCutScore
			, src.AssessmentPerformanceLevelUpperCutScore
		);

		ALTER INDEX ALL ON RDS.DimAssessmentPerformanceLevels REBUILD

		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @msg AS NVARCHAR(MAX)
		SET @msg = ERROR_MESSAGE()

		DECLARE @sev AS INT
		SET @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH


	SET NOCOUNT OFF;

END