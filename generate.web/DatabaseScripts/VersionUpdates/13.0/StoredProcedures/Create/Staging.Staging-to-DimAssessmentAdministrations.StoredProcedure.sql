CREATE PROCEDURE [Staging].[Staging-to-DimAssessmentAdministrations]
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentAdministrations WHERE DimAssessmentAdministrationId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimAssessmentAdministrations ON

			INSERT INTO RDS.DimAssessmentAdministrations
				(DimAssessmentAdministrationId)
			VALUES
				(-1)
	
			SET IDENTITY_INSERT RDS.DimAssessmentAdministrations off
		END

		IF OBJECT_ID(N'tempdb..#AssessmentAdministrations') IS NOT NULL DROP TABLE #AssessmentAdministrations
		CREATE TABLE #AssessmentAdministrations (
			AssessmentIdentifier							VARCHAR (50)	NULL
			, AssessmentIdentificationSystem				VARCHAR (40)	NULL
			, AssessmentAdministrationCode					VARCHAR (400)	NULL
			, AssessmentAdministrationName					VARCHAR (400)	NULL
			, AssessmentAdministrationStartDate				DATETIME		NULL
			, AssessmentAdministrationFinishDate			DATETIME		NULL
			, AssessmentAdministrationAssessmentFamily		VARCHAR(100)	NULL
			, SchoolIdentifierSea							VARCHAR(40)		NULL
			, SchoolIdentificationSystem					VARCHAR(40)		NULL
			, LeaIdentifierSea								VARCHAR(40)		NULL
			, LEAIdentificationSystem						VARCHAR(40)		NULL
			, AssessmentAdministrationOrganizationName		VARCHAR(40)		NULL
			, AssessmentAdministrationPeriodDescription		VARCHAR(40)		NULL
			, AssessmentSecureIndicator						VARCHAR(40)		NULL
		)
		
		INSERT INTO #AssessmentAdministrations (
			AssessmentIdentifier
			, AssessmentIdentificationSystem
			, AssessmentAdministrationCode
			, AssessmentAdministrationName
			, AssessmentAdministrationStartDate
			, AssessmentAdministrationFinishDate
			, AssessmentAdministrationAssessmentFamily
			, SchoolIdentifierSea
			, SchoolIdentificationSystem
			, LeaIdentifierSea
			, LEAIdentificationSystem
			, AssessmentAdministrationOrganizationName
			, AssessmentAdministrationPeriodDescription
			, AssessmentSecureIndicator
		)		
		SELECT DISTINCT
			sa.AssessmentIdentifier
			, NULL											AS AssessmentIdentificationSystem
			, NULL											AS AssessmentAdministrationCode
			, NULL											AS AssessmentAdministrationName
			, sa.AssessmentAdministrationStartDate
			, sa.AssessmentAdministrationFinishDate
			, sa.AssessmentFamilyTitle						AS AssessmentAdministrationAssessmentFamily
			, sar.SchoolIdentifierSea						AS SchoolIdentifierSea
			, NULL											AS SchoolIdentificationSystem
			, sar.LeaIdentifierSeaAccountability			AS LeaIdentifierSea
			, NULL											AS LEAIdentificationSystem
			, NULL											AS AssessmentAdministrationOrganizationName
			, NULL											AS AssessmentAdministrationPeriodDescription
			, NULL											AS AssessmentSecureIndicator
		FROM Staging.AssessmentResult sar
		JOIN Staging.Assessment sa
			ON ISNULL(sar.AssessmentTitle, '')								= ISNULL(sa.AssessmentTitle, '')
			AND ISNULL(sar.AssessmentAcademicSubject, '')					= ISNULL(sa.AssessmentAcademicSubject, '') 
			AND ISNULL(sar.AssessmentPurpose, '')							= ISNULL(sa.AssessmentPurpose, '') 
			AND ISNULL(sar.AssessmentType, '')								= ISNULL(sa.AssessmentType, '')
			AND ISNULL(sar.AssessmentTypeAdministered, '')					= ISNULL(sa.AssessmentTypeAdministered, '')
			AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, '') = ISNULL(sa.AssessmentTypeAdministeredToEnglishLearners, '')

		MERGE RDS.DimAssessmentAdministrations AS trgt
		USING #AssessmentAdministrations AS src
				ON  ISNULL(trgt.AssessmentIdentifier, '')						= ISNULL(src.AssessmentIdentifier, '')
				AND ISNULL(trgt.AssessmentIdentificationSystem, '')				= ISNULL(src.AssessmentIdentificationSystem, '')
				AND ISNULL(trgt.AssessmentAdministrationCode, '')				= ISNULL(src.AssessmentAdministrationCode, '')
				AND ISNULL(trgt.AssessmentAdministrationName, '')				= ISNULL(src.AssessmentAdministrationName, '')
				AND ISNULL(trgt.AssessmentAdministrationStartDate, '')			= ISNULL(src.AssessmentAdministrationStartDate, '')
				AND ISNULL(trgt.AssessmentAdministrationFinishDate, '')			= ISNULL(src.AssessmentAdministrationFinishDate, '')
				AND ISNULL(trgt.AssessmentAdministrationAssessmentFamily, '')	= ISNULL(src.AssessmentAdministrationAssessmentFamily, '')
				AND ISNULL(trgt.SchoolIdentifierSea, '')						= ISNULL(src.SchoolIdentifierSea, '')
				AND ISNULL(trgt.SchoolIdentificationSystem, '')					= ISNULL(src.SchoolIdentificationSystem, '')
				AND ISNULL(trgt.LeaIdentifierSea, '')							= ISNULL(src.LeaIdentifierSea, '')
				AND ISNULL(trgt.LEAIdentificationSystem, '')					= ISNULL(src.LEAIdentificationSystem, '')
				AND ISNULL(trgt.AssessmentAdministrationOrganizationName, '')	= ISNULL(src.AssessmentAdministrationOrganizationName, '')
				AND ISNULL(trgt.AssessmentAdministrationPeriodDescription, '')	= ISNULL(src.AssessmentAdministrationPeriodDescription, '')
				AND ISNULL(trgt.AssessmentSecureIndicator, '')					= ISNULL(src.AssessmentSecureIndicator, '')

		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			AssessmentIdentifier
			, AssessmentIdentificationSystem
			, AssessmentAdministrationCode
			, AssessmentAdministrationName
			, AssessmentAdministrationStartDate
			, AssessmentAdministrationFinishDate
			, AssessmentAdministrationAssessmentFamily
			, SchoolIdentifierSea
			, SchoolIdentificationSystem
			, LeaIdentifierSea
			, LEAIdentificationSystem
			, AssessmentAdministrationOrganizationName
			, AssessmentAdministrationPeriodDescription
			, AssessmentSecureIndicator
		)
		VALUES (
			src.AssessmentIdentifier
			, src.AssessmentIdentificationSystem
			, src.AssessmentAdministrationCode
			, src.AssessmentAdministrationName
			, src.AssessmentAdministrationStartDate
			, src.AssessmentAdministrationFinishDate
			, src.AssessmentAdministrationAssessmentFamily
			, src.SchoolIdentifierSea
			, src.SchoolIdentificationSystem
			, src.LeaIdentifierSea
			, src.LEAIdentificationSystem
			, src.AssessmentAdministrationOrganizationName
			, src.AssessmentAdministrationPeriodDescription
			, src.AssessmentSecureIndicator
		);

		ALTER INDEX ALL ON RDS.DimAssessmentAdministrations REBUILD

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