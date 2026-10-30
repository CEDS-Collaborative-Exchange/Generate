CREATE PROCEDURE [Staging].[Staging-to-DimSchoolPerformanceIndicatorStateDefinedStatuses]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses WHERE DimSchoolPerformanceIndicatorStateDefinedStatusId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses ON

			INSERT INTO RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses
				(DimSchoolPerformanceIndicatorStateDefinedStatusId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses off
		END

		IF OBJECT_ID(N'tempdb..#SchoolPerfomanceIndicators') IS NOT NULL DROP TABLE #SchoolPerfomanceIndicators
		CREATE TABLE #StateDefinedStatuses (
			SchoolPerformanceIndicatorStateDefinedStatusCode					VARCHAR (50) 	NULL	
			, SchoolPerformanceIndicatorStateDefinedStatusDescription			VARCHAR (200) 	NULL
		)
		
		INSERT INTO #StateDefinedStatuses (
			SchoolPerformanceIndicatorStateDefinedStatusCode
			, SchoolPerformanceIndicatorStateDefinedStatusDescription
		)		
		SELECT DISTINCT
			SchoolPerformanceIndicatorStateDefinedStatus
			, SchoolPerformanceIndicatorStateDefinedStatusDescription
		FROM Staging.SchoolPerformanceIndicators sspfi
		CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy

		MERGE RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses AS trgt
		USING #StateDefinedStatuses AS src
				ON  ISNULL(trgt.SchoolPerformanceIndicatorStateDefinedStatusCode, '') = ISNULL(src.SchoolPerformanceIndicatorStateDefinedStatusCode, '')
				AND ISNULL(trgt.SchoolPerformanceIndicatorStateDefinedStatusDescription, '') = ISNULL(src.SchoolPerformanceIndicatorStateDefinedStatusDescription, '')
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			SchoolPerformanceIndicatorStateDefinedStatusCode
			, SchoolPerformanceIndicatorStateDefinedStatusDescription
		)
		VALUES (
			  src.SchoolPerformanceIndicatorStateDefinedStatusCode
			, src.SchoolPerformanceIndicatorStateDefinedStatusDescription
		);

		ALTER INDEX ALL ON RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses REBUILD

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