------------------------------------------------
	-- Populate DimK12EnrollmentStatuses			 ---
	------------------------------------------------
set nocount on
begin try
 
	begin transaction

	IF EXISTS (SELECT 1 FROM RDS.DimK12EnrollmentStatuses WHERE [AcademicOrVocationalOutcomeCode] IS NULL OR [AcademicOrVocationalExitOutcomeCode] IS NULL) BEGIN
		UPDATE RDS.DimK12EnrollmentStatuses
		SET [AcademicOrVocationalOutcomeCode] = 'MISSING',
			[AcademicOrVocationalOutcomeDescription] = 'MISSING',
			[AcademicOrVocationalOutcomeEdFactsCode] = 'MISSING'
		WHERE [AcademicOrVocationalOutcomeCode] IS NULL

		UPDATE RDS.DimK12EnrollmentStatuses
		SET [AcademicOrVocationalExitOutcomeCode] = 'MISSING',
			[AcademicOrVocationalExitOutcomeDescription] = 'MISSING',
			[AcademicOrVocationalExitOutcomeEdFactsCode] = 'MISSING'
		WHERE [AcademicOrVocationalExitOutcomeCode] IS NULL
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12EnrollmentStatuses d WHERE d.DimK12EnrollmentStatusId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimK12EnrollmentStatuses ON

		INSERT INTO RDS.DimK12EnrollmentStatuses (
			[DimK12EnrollmentStatusId]
			,[EnrollmentStatusCode]
			,[EnrollmentStatusDescription]
			,[EntryTypeCode]
			,[EntryTypeDescription]
			,[ExitOrWithdrawalTypeCode]
			,[ExitOrWithdrawalTypeDescription]
			,[PostSecondaryEnrollmentStatusCode]
			,[PostSecondaryEnrollmentStatusDescription]
			,[PostSecondaryEnrollmentStatusEdFactsCode]
			,[AcademicOrVocationalOutcomeCode]
			,[AcademicOrVocationalOutcomeDescription]
			,[AcademicOrVocationalOutcomeEdFactsCode]
			,[AcademicOrVocationalExitOutcomeCode]
			,[AcademicOrVocationalExitOutcomeDescription]
			,[AcademicOrVocationalExitOutcomeEdFactsCode]
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
				)

		SET IDENTITY_INSERT RDS.DimK12EnrollmentStatuses OFF
	END

	CREATE TABLE #EnrollmentStatus (EnrollmentStatusCode VARCHAR(50), EnrollmentStatusDescription VARCHAR(200))

	INSERT INTO #EnrollmentStatus VALUES ('MISSING', 'MISSING')
	INSERT INTO #EnrollmentStatus 
	SELECT 
		  Code
		, Description
	FROM dbo.RefEnrollmentStatus

	CREATE TABLE #EntryType (EntryTypeCode VARCHAR(50), EntryTypeDescription VARCHAR(200))

	INSERT INTO #EntryType VALUES ('MISSING', 'MISSING')
	INSERT INTO #EntryType 
	SELECT 
		  Code
		, Description
	FROM dbo.RefEntryType

	CREATE TABLE #ExitOrWithdrawalType (ExitOrWithdrawalTypeCode VARCHAR(50), ExitOrWithdrawalTypeDescription VARCHAR(200))

	INSERT INTO #ExitOrWithdrawalType VALUES ('MISSING', 'MISSING')
	INSERT INTO #ExitOrWithdrawalType 
	SELECT 
		  Code
		, Description
	FROM dbo.RefExitOrWithdrawalType

	CREATE TABLE #PostSecondaryEnrollmentStatus (PostSecondaryEnrollmentStatusCode VARCHAR(50), PostSecondaryEnrollmentStatusDescription VARCHAR(200), PostSecondaryEnrollmentStatusEdFactsCode VARCHAR(50))

	INSERT INTO #PostSecondaryEnrollmentStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #PostSecondaryEnrollmentStatus 
	SELECT 
		  Code
		, Description
		, Code
	FROM dbo.RefPsEnrollmentStatus

	CREATE TABLE #AcademicCareerAndTechnicalOutcomesInProgram (AcademicOrVocationalOutcomeCode VARCHAR(50), AcademicOrVocationalOutcomeDescription VARCHAR(200), AcademicOrVocationalOutcomeEdFactsCode VARCHAR(50))

	INSERT INTO #AcademicCareerAndTechnicalOutcomesInProgram  VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #AcademicCareerAndTechnicalOutcomesInProgram 
	SELECT 
		  Code
		, Description
		, Code
	FROM dbo.RefAcademicCareerAndTechnicalOutcomesInProgram

	CREATE TABLE #AcademicCareerAndTechnicalOutcomesExitedProgram (AcademicOrVocationalExitOutcomeCode VARCHAR(50), AcademicOrVocationalExitOutcomeDescription VARCHAR(200), AcademicOrVocationalExitOutcomeEdFactsCode VARCHAR(50))

	INSERT INTO #AcademicCareerAndTechnicalOutcomesExitedProgram VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #AcademicCareerAndTechnicalOutcomesExitedProgram 
	SELECT 
		  Code
		, Description
		, Code
	FROM dbo.RefAcademicCareerAndTechnicalOutcomesExitedProgram


	INSERT INTO RDS.DimK12EnrollmentStatuses
		(
			  [EnrollmentStatusCode]
			, [EnrollmentStatusDescription]
			, [EntryTypeCode]
			, [EntryTypeDescription]
			, [ExitOrWithdrawalTypeCode]
			, [ExitOrWithdrawalTypeDescription]
			, [PostSecondaryEnrollmentStatusCode]
			, [PostSecondaryEnrollmentStatusDescription]
			, [PostSecondaryEnrollmentStatusEdFactsCode]
			, [AcademicOrVocationalOutcomeCode]
			, [AcademicOrVocationalOutcomeDescription]
			, [AcademicOrVocationalOutcomeEdFactsCode]
			, [AcademicOrVocationalExitOutcomeCode]
			, [AcademicOrVocationalExitOutcomeDescription]
			, [AcademicOrVocationalExitOutcomeEdFactsCode]
		)
	SELECT DISTINCT
		  es.EnrollmentStatusCode
		, es.EnrollmentStatusDescription
		, et.EntryTypeCode
		, et.EntryTypeDescription
		, ewt.ExitOrWithdrawalTypeCode
		, ewt.ExitOrWithdrawalTypeDescription
		, pes.PostSecondaryEnrollmentStatusCode
		, pes.PostSecondaryEnrollmentStatusDescription
		, pes.PostSecondaryEnrollmentStatusEdFactsCode
		, acad.AcademicOrVocationalOutcomeCode
		, acad.AcademicOrVocationalOutcomeDescription
		, acad.AcademicOrVocationalOutcomeEdFactsCode
		, acadExit.AcademicOrVocationalExitOutcomeCode
		, acadExit.AcademicOrVocationalExitOutcomeDescription
		, acadExit.AcademicOrVocationalExitOutcomeEdFactsCode
	FROM #EnrollmentStatus es
	CROSS JOIN #EntryType et
	CROSS JOIN #ExitOrWithdrawalType ewt
	CROSS JOIN #PostSecondaryEnrollmentStatus pes
	CROSS JOIN #AcademicCareerAndTechnicalOutcomesInProgram acad
	CROSS JOIN #AcademicCareerAndTechnicalOutcomesExitedProgram acadExit
	LEFT JOIN rds.DimK12EnrollmentStatuses kes
		ON es.EnrollmentStatusCode = kes.EnrollmentStatusCode
		AND et.EntryTypeCode = kes.EntryTypeCode
		AND ewt.ExitOrWithdrawalTypeCode = kes.ExitOrWithdrawalTypeCode
		AND pes.PostSecondaryEnrollmentStatusCode = kes.PostSecondaryEnrollmentStatusCode
		AND acad.AcademicOrVocationalOutcomeCode = kes.AcademicOrVocationalOutcomeCode
		AND acadExit.AcademicOrVocationalExitOutcomeCode = kes.AcademicOrVocationalExitOutcomeCode
	WHERE kes.DimK12EnrollmentStatusId IS NULL

	DROP TABLE #EnrollmentStatus
	DROP TABLE #EntryType
	DROP TABLE #ExitOrWithdrawalType
	DROP TABLE #PostSecondaryEnrollmentStatus
	DROP TABLE #AcademicCareerAndTechnicalOutcomesInProgram
	DROP TABLE #AcademicCareerAndTechnicalOutcomesExitedProgram 

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