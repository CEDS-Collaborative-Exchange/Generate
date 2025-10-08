CREATE PROCEDURE [Staging].[Staging-to-DimSchoolPerformanceIndicators]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimSchoolPerformanceIndicators WHERE DimSchoolPerformanceIndicatorId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimSchoolPerfomanceIndicators ON

			INSERT INTO RDS.DimSchoolPerformanceIndicators
				(DimSchoolPerformanceIndicatorId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimSchoolPerfomanceIndicators off
		END

		IF OBJECT_ID(N'tempdb..#SchoolPerfomanceIndicators') IS NOT NULL DROP TABLE #SchoolPerfomanceIndicators
		CREATE TABLE #SchoolPerfomanceIndicators (
			SchoolPerformanceIndicatorTypeCode					VARCHAR (50) 	NULL	
			, SchoolPerformanceIndicatorTypeDescription			VARCHAR (200) 	NULL
			, SchoolPerformanceIndicatorTypeEdFactsCode			VARCHAR (50) 	NULL
		)
		
		INSERT INTO #SchoolPerfomanceIndicators (
			SchoolPerformanceIndicatorTypeCode
			, SchoolPerformanceIndicatorTypeDescription
			, SchoolPerformanceIndicatorTypeEdFactsCode
		)		
		SELECT DISTINCT
			SchoolPerformanceIndicatorType
			, CASE SchoolPerformanceIndicatorCategory 
				WHEN 'GRM' THEN 'Graduation Rate Measure'
				WHEN 'AAM' THEN 'Academic Achievement Measure'
				WHEN 'OAM' THEN 'Other Academic Measure'
				WHEN 'IND' THEN 'School Quality and Student Success Measure'
				WHEN 'PAELP' THEN 'Progress Achieving English Language Proficiency Measure'
				ELSE 'MISSING'
			END AS SchoolPerformanceIndicatorTypeDescription
			, SchoolPerformanceIndicatorType
		FROM Staging.SchoolPerformanceIndicators sspfi
		CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy

		MERGE RDS.DimSchoolPerformanceIndicators AS trgt
		USING #SchoolPerfomanceIndicators AS src
				ON  ISNULL(trgt.SchoolPerformanceIndicatorTypeCode, '') = ISNULL(src.SchoolPerformanceIndicatorTypeCode, '')
				AND ISNULL(trgt.SchoolPerformanceIndicatorTypeDescription, '') = ISNULL(src.SchoolPerformanceIndicatorTypeDescription, '')
				AND ISNULL(trgt.SchoolPerformanceIndicatorTypeEdFactsCode, '') = ISNULL(src.SchoolPerformanceIndicatorTypeEdFactsCode, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			SchoolPerformanceIndicatorTypeCode
			, SchoolPerformanceIndicatorTypeDescription
			, SchoolPerformanceIndicatorTypeEdFactsCode
		)
		VALUES (
			  src.SchoolPerformanceIndicatorTypeCode
			, src.SchoolPerformanceIndicatorTypeDescription
			, src.SchoolPerformanceIndicatorTypeEdFactsCode
		);

		ALTER INDEX ALL ON RDS.DimSchoolPerformanceIndicators REBUILD

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