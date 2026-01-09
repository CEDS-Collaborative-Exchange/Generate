-----------------------------------------------
--Populate DimPsEnrollmentStatuses
-----------------------------------------------
	--Remove the existing dimension values
	DELETE FROM	RDS.DimPsEnrollmentStatuses

	--Repopulate the dimension with the new table values added
	IF NOT EXISTS (SELECT 1 FROM RDS.DimPsEnrollmentStatuses WHERE DimPsEnrollmentStatusId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses ON

		INSERT INTO [RDS].DimPsEnrollmentStatuses (
			[DimPsEnrollmentStatusId]
		   ,[PostsecondaryExitOrWithdrawalTypeCode]
		   ,[PostsecondaryExitOrWithdrawalTypeDescription]
		   ,[PostsecondaryEnrollmentStatusCode]
		   ,[PostsecondaryEnrollmentStatusDescription]
		   ,[PostSecondaryEnrollmentStatusEdFactsCode]
		   ,[PostsecondaryEnrollmentActionCode]
		   ,[PostsecondaryEnrollmentActionDescription]
		   ,[PostSecondaryEnrollmentActionEdFactsCode]
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
		)

		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses OFF
	END

	--PostsecondaryExitOrWithdrawalType
	CREATE TABLE #PostsecondaryExitOrWithdrawalType (PostsecondaryExitOrWithdrawalTypeCode VARCHAR(50), PostsecondaryExitOrWithdrawalTypeDescription VARCHAR(200))
	INSERT INTO #PostsecondaryExitOrWithdrawalType VALUES ('MISSING', 'MISSING')
	INSERT INTO #PostsecondaryExitOrWithdrawalType
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'PostsecondaryExitOrWithdrawalType'

	--PostsecondaryEnrollmentStatus
	CREATE TABLE #PostsecondaryEnrollmentStatus (PostsecondaryEnrollmentStatusCode VARCHAR(50), PostsecondaryEnrollmentStatusDescription VARCHAR(200), PostSecondaryEnrollmentStatusEdFactsCode VARCHAR(200))
	INSERT INTO #PostsecondaryEnrollmentStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #PostsecondaryEnrollmentStatus
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'PostsecondaryEnrollmentStatus'

	--PostsecondaryEnrollmentAction
	CREATE TABLE #PostsecondaryEnrollmentAction (PostsecondaryEnrollmentActionCode VARCHAR(50), PostsecondaryEnrollmentActionDescription VARCHAR(200), PostSecondaryEnrollmentActionEdFactsCode VARCHAR(200))
	INSERT INTO #PostsecondaryEnrollmentAction VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #PostsecondaryEnrollmentAction
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'PostsecondaryEnrollmentAction'


	INSERT INTO RDS.DimPsEnrollmentStatuses (
			[PostsecondaryExitOrWithdrawalTypeCode]
		   ,[PostsecondaryExitOrWithdrawalTypeDescription]
		   ,[PostsecondaryEnrollmentStatusCode]
		   ,[PostsecondaryEnrollmentStatusDescription]
		   ,[PostSecondaryEnrollmentStatusEdFactsCode]
		   ,[PostsecondaryEnrollmentActionCode]
		   ,[PostsecondaryEnrollmentActionDescription]
		   ,[PostSecondaryEnrollmentActionEdFactsCode]
	)
	SELECT DISTINCT
		  a.PostsecondaryExitOrWithdrawalTypeCode
		, a.PostsecondaryExitOrWithdrawalTypeDescription
		, b.PostsecondaryEnrollmentStatusCode
		, b.PostsecondaryEnrollmentStatusDescription
		, b.PostSecondaryEnrollmentStatusEdFactsCode
		, c.PostsecondaryEnrollmentActionCode
		, c.PostsecondaryEnrollmentActionDescription
		, c.PostSecondaryEnrollmentActionEdFactsCode
	FROM #PostsecondaryExitOrWithdrawalType a
	CROSS JOIN #PostsecondaryEnrollmentStatus b
	CROSS JOIN #PostsecondaryEnrollmentAction c
	LEFT JOIN RDS.DimPsEnrollmentStatuses main
		ON a.PostsecondaryExitOrWithdrawalTypeCode = main.PostsecondaryExitOrWithdrawalTypeCode
		AND b.PostsecondaryEnrollmentStatusCode = main.PostsecondaryEnrollmentStatusCode
		AND c.PostsecondaryEnrollmentActionCode = main.PostsecondaryEnrollmentActionCode
	WHERE main.DimPsEnrollmentStatusId IS NULL

	DROP TABLE #PostsecondaryExitOrWithdrawalType
	DROP TABLE #PostsecondaryEnrollmentStatus
	DROP TABLE #PostsecondaryEnrollmentAction

-----------------------------------------------
--Populate DimAssessmentStatuses
-----------------------------------------------

	--Remove the existing dimension values
	DELETE FROM	RDS.DimAssessmentStatuses

	--Repopulate the dimension with the new table values added
	IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentStatuses WHERE DimAssessmentStatusId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimAssessmentStatuses ON

		INSERT INTO [RDS].DimAssessmentStatuses (
			[DimAssessmentStatusId]
			, [ProgressLevelCode]
			, [ProgressLevelDescription]
			, [ProgressLevelEdFactsCode]
			, [AssessedFirstTimeCode]
			, [AssessedFirstTimeDescription]
			, [AssessedFirstTimeEdFactsCode]
		)
		VALUES (
			-1
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
		)

		SET IDENTITY_INSERT RDS.DimAssessmentStatuses OFF
	END

	--ProgressLevel
	CREATE TABLE #ProgressLevel (ProgressLevelCode VARCHAR(50), ProgressLevelDescription VARCHAR(200), ProgressLevelEdFactsCode VARCHAR(50))
	INSERT INTO #ProgressLevel VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #ProgressLevel
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'ProgressLevel'

	INSERT INTO RDS.DimAssessmentStatuses (
		[ProgressLevelCode]
		, [ProgressLevelDescription]
		, [ProgressLevelEdFactsCode]
		, [AssessedFirstTimeCode]
		, [AssessedFirstTimeDescription]
		, [AssessedFirstTimeEdFactsCode]
	)
	SELECT DISTINCT
		  a.ProgressLevelCode
		, a.ProgressLevelDescription
		, a.ProgressLevelEdFactsCode
		, b.CedsOptionSetCode
		, b.CedsOptionSetDescription
		, b.EdFactsCode
	FROM (VALUES('Yes', 'Yes', 'FIRSTASSESS'),('No', 'No', 'MISSING'),('MISSING', 'MISSING', 'MISSING')) b(CedsOptionSetCode, CedsOptionSetDescription, EdFactsCode)
	CROSS JOIN #ProgressLevel a
	LEFT JOIN RDS.DimAssessmentStatuses main
		ON a.ProgressLevelCode = main.ProgressLevelCode
		AND b.CedsOptionSetCode = main.AssessedFirstTimeCode
	WHERE main.DimAssessmentStatusId IS NULL

	DROP TABLE #ProgressLevel

