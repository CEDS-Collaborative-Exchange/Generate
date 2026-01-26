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

-----------------------------------------------
--Populate DimK12StaffCategories
-----------------------------------------------

	--Remove the old data so we can repopulate after adding the new fields
	DELETE FROM [RDS].[DimK12StaffCategories]

	--Start the repopulation	
	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12StaffCategories d WHERE d.DimK12StaffCategoryId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimK12StaffCategories ON

	INSERT INTO [RDS].[DimK12StaffCategories]
           ([DimK12StaffCategoryId]
		   ,[K12StaffClassificationCode]
           ,[K12StaffClassificationDescription]
           ,[K12StaffClassificationEdFactsCode]
           ,[SpecialEducationSupportServicesCategoryCode]
           ,[SpecialEducationSupportServicesCategoryDescription]
           ,[SpecialEducationSupportServicesCategoryEdFactsCode]
           ,[TitleIProgramStaffCategoryCode]
           ,[TitleIProgramStaffCategoryDescription]
           ,[TitleIProgramStaffCategoryEdFactsCode]
		   ,[TitleIIILanguageInstructionIndicatorCode]
 		   ,[TitleIIILanguageInstructionIndicatorDescription]
		   )
		   VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

			SET IDENTITY_INSERT RDS.DimK12StaffCategories OFF
	END

		IF OBJECT_ID('tempdb..#K12StaffClassification') IS NOT NULL
			DROP TABLE #K12StaffClassification

		CREATE TABLE #K12StaffClassification (K12StaffClassificationCode VARCHAR(50), K12StaffClassificationDescription VARCHAR(200), K12StaffClassificationEdFactsCode VARCHAR(50))

		INSERT INTO #K12StaffClassification VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #K12StaffClassification 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'AdministrativeSupportStaff' THEN 'LEASUP'
				WHEN 'Administrators' THEN 'LEAADM'
				WHEN 'AllOtherSupportStaff' THEN 'OTHSUP'
				WHEN 'ElementaryTeachers' THEN 'ELMTCH'
				WHEN 'InstructionalCoordinators' THEN 'CORSUP'
				WHEN 'KindergartenTeachers' THEN 'KGTCH'
				WHEN 'LibraryMediaSpecialists' THEN 'LIBSPE'
				WHEN 'LibraryMediaSupportStaff' THEN 'LIBSUP'
				WHEN 'Paraprofessionals' THEN 'PARA'
				WHEN 'Pre-KindergartenTeachers'	THEN 'PKTCH'
				WHEN 'SchoolCounselors' THEN 'ELMGUI'
				WHEN 'SchoolPsychologist' THEN 'SCHPSYCH'
				WHEN 'SecondaryTeachers' THEN 'SECTCH'
				WHEN 'SpecialEducationTeachers' THEN 'MISSING'
				WHEN 'StudentSupportServicesStaff' THEN 'STUSUP'
				WHEN 'UngradedTeachers' THEN 'UGTCH'
				ELSE 'MISSING'
			  END
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'K12StaffClassification'

		IF OBJECT_ID('tempdb..#SpecialEducationSupportServicesCategory') IS NOT NULL
			DROP TABLE #SpecialEducationSupportServicesCategory
		CREATE TABLE #SpecialEducationSupportServicesCategory (SpecialEducationSupportServicesCategoryCode VARCHAR(50), SpecialEducationSupportServicesCategoryDescription VARCHAR(200), SpecialEducationSupportServicesCategoryEdFactsCode VARCHAR(50))

		INSERT INTO #SpecialEducationSupportServicesCategory VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #SpecialEducationSupportServicesCategory 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CedsOptionSetCode AS EdFactsOptionSetCode
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SpecialEducationSupportServicesCategory'

		IF OBJECT_ID('tempdb..#TitleIProgramStaffCategory') IS NOT NULL
			DROP TABLE #TitleIProgramStaffCategory

		CREATE TABLE #TitleIProgramStaffCategory (TitleIProgramStaffCategoryCode VARCHAR(50), TitleIProgramStaffCategoryDescription VARCHAR(200), TitleIProgramStaffCategoryEdFactsCode VARCHAR(50))

		INSERT INTO #TitleIProgramStaffCategory VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleIProgramStaffCategory 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'TitleISupportStaff' THEN 'TITSUP'
				WHEN 'TitleIOtherParaprofessional' THEN 'TITO'
				WHEN 'TitleIParaprofessional' THEN 'TITPARA'
				WHEN 'TitleITeacher' THEN 'TITTCH'
				WHEN 'TitleIAdministrator' THEN 'TITADM'
				ELSE 'MISSING'
			  END
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleIProgramStaffCategory'
		
		IF OBJECT_ID('tempdb..#MigrantEducationProgramStaffCategory') IS NOT NULL
			DROP TABLE #MigrantEducationProgramStaffCategory

		CREATE TABLE #MigrantEducationProgramStaffCategory (MigrantEducationProgramStaffCategoryCode VARCHAR(50), MigrantEducationProgramStaffCategoryDescription VARCHAR(200))

		INSERT INTO #MigrantEducationProgramStaffCategory VALUES ('MISSING', 'MISSING')
		INSERT INTO #MigrantEducationProgramStaffCategory 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'MigrantEducationProgramStaffCategory'

		
		IF OBJECT_ID('tempdb..#ProfessionalEducationalJobClassification') IS NOT NULL
			DROP TABLE #ProfessionalEducationalJobClassification

		CREATE TABLE #ProfessionalEducationalJobClassification (ProfessionalEducationalJobClassificationCode VARCHAR(50), ProfessionalEducationalJobClassificationDescription VARCHAR(200))

		INSERT INTO #ProfessionalEducationalJobClassification VALUES ('MISSING', 'MISSING')
		INSERT INTO #ProfessionalEducationalJobClassification 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'ProfessionalEducationalJobClassification'

	INSERT INTO [RDS].[DimK12StaffCategories]
           ([K12StaffClassificationCode]
           ,[K12StaffClassificationDescription]
           ,[K12StaffClassificationEdFactsCode]
           ,[SpecialEducationSupportServicesCategoryCode]
           ,[SpecialEducationSupportServicesCategoryDescription]
           ,[SpecialEducationSupportServicesCategoryEdFactsCode]
           ,[TitleIProgramStaffCategoryCode]
           ,[TitleIProgramStaffCategoryDescription]
           ,[TitleIProgramStaffCategoryEdFactsCode]
		   ,[TitleIIILanguageInstructionIndicatorCode]
 		   ,[TitleIIILanguageInstructionIndicatorDescription]
		   )
	SELECT 
		ksc.K12StaffClassificationCode
		,ksc.K12StaffClassificationDescription
		,ksc.K12StaffClassificationEdFactsCode
		,ssc.SpecialEducationSupportServicesCategoryCode
		,ssc.SpecialEducationSupportServicesCategoryDescription
		,ssc.SpecialEducationSupportServicesCategoryEdFactsCode
		,tsc.TitleIProgramStaffCategoryCode
		,tsc.TitleIProgramStaffCategoryDescription
		,tsc.TitleIProgramStaffCategoryEdFactsCode
		,TitleIIILiep.CedsOptionSetCode
		,TitleIIILiep.CedsOptionSetDescription
	FROM #K12StaffClassification ksc
	CROSS JOIN (VALUES('Yes', 'Taught TitleIII LIEP'),('No', 'Did Not Teach TitleIII LIEP'),('MISSING', 'MISSING')) TitleIIILiep(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN #SpecialEducationSupportServicesCategory ssc
	CROSS JOIN #TitleIProgramStaffCategory tsc
	LEFT JOIN RDS.DimK12StaffCategories dfd
		ON	ksc.K12StaffClassificationCode	= dfd.K12StaffClassificationCode								
		AND ssc.SpecialEducationSupportServicesCategoryCode = dfd.SpecialEducationSupportServicesCategoryCode
		AND tsc.TitleIProgramStaffCategoryCode = dfd.TitleIProgramStaffCategoryCode
	WHERE dfd.DimK12StaffCategoryId IS NULL

	DROP TABLE #K12StaffClassification
	DROP TABLE #SpecialEducationSupportServicesCategory
	DROP TABLE #TitleIProgramStaffCategory



