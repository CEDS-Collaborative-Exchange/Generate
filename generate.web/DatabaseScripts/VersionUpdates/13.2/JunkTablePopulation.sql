-----------------------------------------------
--Populate DimPsEnrollmentStatuses
-----------------------------------------------
	--drop constraints
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentCounts_PSEnrollmentStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentCounts')
		ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_PSEnrollmentStatusId];

	--Remove the existing dimension values
	DELETE FROM	RDS.DimPsEnrollmentStatuses WHERE DimPsEnrollmentStatusId <> -1

	--Repopulate the dimension with the new table values added
	IF NOT EXISTS (SELECT 1 FROM RDS.DimPsEnrollmentStatuses WHERE DimPsEnrollmentStatusId = -1) 
	BEGIN
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

	--add constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentCounts_PSEnrollmentStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentCounts')
	BEGIN 
		ALTER TABLE [RDS].[FactK12StudentCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentCounts_PSEnrollmentStatusId] FOREIGN KEY([PsEnrollmentStatusId])
		REFERENCES [RDS].[DimPsEnrollmentStatuses] ([DimPsEnrollmentStatusId]);

		ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_PSEnrollmentStatusId];
	END

-----------------------------------------------
--Populate DimAssessmentStatuses
-----------------------------------------------
	--drop constraints
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentAssessments_AssessmentStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentAssessments')
		ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId];

	--Remove the existing dimension values
	DELETE FROM	RDS.DimAssessmentStatuses WHERE DimAssessmentStatusId <> -1

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

	--add constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentAssessments_AssessmentStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentAssessments')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId] FOREIGN KEY([AssessmentStatusId])
		REFERENCES [RDS].[DimAssessmentStatuses] ([DimAssessmentStatusId]);

		ALTER TABLE [RDS].[FactK12StudentAssessments] CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId];
	END

-----------------------------------------------
--Populate DimK12StaffCategories
-----------------------------------------------
	--Drop constraints
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StaffCounts_K12StaffCategoryId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StaffCounts')
		ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId];	

	--Remove the old data so we can repopulate after adding the new fields
	DELETE FROM [RDS].[DimK12StaffCategories] WHERE DimK12StaffCategoryId <> -1

	--Start the repopulation	
	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12StaffCategories d WHERE d.DimK12StaffCategoryId = -1) 
	BEGIN
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
		   ,[MigrantEducationProgramStaffCategoryCode]
		   ,[MigrantEducationProgramStaffCategoryDescription]
		   ,[ProfessionalEducationalJobClassificationCode]
		   ,[ProfessionalEducationalJobClassificationDescription]
		   ,[TitleIIILanguageInstructionIndicatorCode]
 		   ,[TitleIIILanguageInstructionIndicatorDescription]
		   )
		   VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

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
		   ,[MigrantEducationProgramStaffCategoryCode]
		   ,[MigrantEducationProgramStaffCategoryDescription]
		   ,[ProfessionalEducationalJobClassificationCode]
		   ,[ProfessionalEducationalJobClassificationDescription]
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
		,mepsc.MigrantEducationProgramStaffCategoryCode
		,mepsc.MigrantEducationProgramStaffCategoryDescription
		,pejc.ProfessionalEducationalJobClassificationCode
		,pejc.ProfessionalEducationalJobClassificationDescription
		,TitleIIILiep.CedsOptionSetCode
		,TitleIIILiep.CedsOptionSetDescription
	FROM #K12StaffClassification ksc
	CROSS JOIN (VALUES('Yes', 'Taught TitleIII LIEP'),('No', 'Did Not Teach TitleIII LIEP'),('MISSING', 'MISSING')) TitleIIILiep(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN #SpecialEducationSupportServicesCategory ssc
	CROSS JOIN #TitleIProgramStaffCategory tsc
	CROSS JOIN #MigrantEducationProgramStaffCategory mepsc
	CROSS JOIN #ProfessionalEducationalJobClassification pejc
	LEFT JOIN RDS.DimK12StaffCategories dfd
		ON	ksc.K12StaffClassificationCode	= dfd.K12StaffClassificationCode								
		AND ssc.SpecialEducationSupportServicesCategoryCode = dfd.SpecialEducationSupportServicesCategoryCode
		AND tsc.TitleIProgramStaffCategoryCode = dfd.TitleIProgramStaffCategoryCode
		AND mepsc.MigrantEducationProgramStaffCategoryCode = dfd.MigrantEducationProgramStaffCategoryCode
		AND pejc.ProfessionalEducationalJobClassificationCode = dfd.ProfessionalEducationalJobClassificationCode
	WHERE dfd.DimK12StaffCategoryId IS NULL

	DROP TABLE #K12StaffClassification
	DROP TABLE #SpecialEducationSupportServicesCategory
	DROP TABLE #TitleIProgramStaffCategory
	DROP TABLE #MigrantEducationProgramStaffCategory
	DROP TABLE #ProfessionalEducationalJobClassification

	--add constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StaffCounts_K12StaffCategoryId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StaffCounts')
	BEGIN
		ALTER TABLE [RDS].[FactK12StaffCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId] FOREIGN KEY([K12StaffCategoryId])
		REFERENCES [RDS].[DimK12StaffCategories] ([DimK12StaffCategoryId]);

		ALTER TABLE [RDS].[FactK12StaffCounts] CHECK CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId];
	END

	-------------------------------------------------------------------------
	-- Populate DimTeachingCredentialStatuses   --
	-------------------------------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimTeachingCredentialStatuses d WHERE d.DimTeachingCredentialStatusId = -1) 
	BEGIN
		SET IDENTITY_INSERT rds.DimTeachingCredentialStatuses ON

			INSERT INTO rds.DimTeachingCredentialStatuses (
						DimTeachingCredentialStatusId
					, TeachingCredentialTypeCode
					, TeachingCredentialTypeDescription
					, TeachingCredentialTypeEdFactsCode
					, TeachingCredentialBasisCode
					, TeachingCredentialBasisDescription
			)
			VALUES (
					-1
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING')

		SET IDENTITY_INSERT rds.DimTeachingCredentialStatuses OFF
	END

	IF OBJECT_ID('tempdb..#TeachingCredentialType') IS NOT NULL 
	BEGIN
		DROP TABLE #TeachingCredentialType
	END
	CREATE TABLE #TeachingCredentialType (TeachingCredentialTypeCode VARCHAR(50), TeachingCredentialTypeDescription VARCHAR(200), TeachingCredentialTypeEdFactsCode VARCHAR(50))

	INSERT INTO #TeachingCredentialType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #TeachingCredentialType 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode
			WHEN 'Emergency' THEN 'TCHWEMRPRVCRD'
			WHEN 'Master' THEN 'TCHWOEMRPRVCRD'
			WHEN 'Professional' THEN 'TCHWOEMRPRVCRD'
			WHEN 'Provisional' THEN 'TCHWEMRPRVCRD'
			WHEN 'Regular' THEN 'TCHWOEMRPRVCRD'
			WHEN 'Specialist' THEN 'TCHWOEMRPRVCRD'
			ELSE 'MISSING'
		  END
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'TeachingCredentialType'


	IF OBJECT_ID('tempdb..#TeachingCredentialBasis') IS NOT NULL 
	BEGIN
		DROP TABLE #TeachingCredentialBasis
	END
	CREATE TABLE #TeachingCredentialBasis (TeachingCredentialBasisCode VARCHAR(50), TeachingCredentialBasisDescription VARCHAR(200))

	INSERT INTO #TeachingCredentialBasis VALUES ('MISSING', 'MISSING')
	INSERT INTO #TeachingCredentialBasis 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'TeachingCredentialBasis'


	INSERT INTO rds.DimTeachingCredentialStatuses (
				  TeachingCredentialTypeCode
				, TeachingCredentialTypeDescription
				, TeachingCredentialTypeEdFactsCode
				, TeachingCredentialBasisCode
				, TeachingCredentialBasisDescription
			)
	SELECT 
		a.TeachingCredentialTypeCode
		,a.TeachingCredentialTypeDescription
		,a.TeachingCredentialTypeEdFactsCode
		,b.TeachingCredentialBasisCode
		,b.TeachingCredentialBasisDescription
	FROM #TeachingCredentialType a
	CROSS JOIN #TeachingCredentialBasis b
	LEFT JOIN RDS.DimTeachingCredentialStatuses main
		ON	a.TeachingCredentialTypeCode = main.TeachingCredentialTypeCode								
		AND b.TeachingCredentialBasisCode = main.TeachingCredentialBasisCode			
	WHERE main.DimTeachingCredentialStatusId IS NULL

	DROP TABLE #TeachingCredentialType
	DROP TABLE #TeachingCredentialBasis

	-------------------------------------------------------------------------
	-- Populate DimK12StaffStatuses
	-------------------------------------------------------------------------
	--Drop constraints	
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StaffCounts_K12StaffStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StaffCounts')
		ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId];

	--Remove the old data so we can repopulate after adding the new fields
	DELETE FROM [RDS].[DimK12StaffStatuses] WHERE DimK12StaffStatusId <> -1

	--Start the repopulation	
	IF NOT EXISTS (
			SELECT 1 FROM RDS.DimK12StaffStatuses 
			WHERE DimK12StaffStatusId = -1
		) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimK12StaffStatuses ON

		INSERT INTO RDS.DimK12StaffStatuses (
			  DimK12StaffStatusId
			, SpecialEducationAgeGroupTaughtCode
			, SpecialEducationAgeGroupTaughtDescription
			, SpecialEducationAgeGroupTaughtEdFactsCode
			, EdFactsCertificationStatusCode
			, EdFactsCertificationStatusDescription
			, EdFactsCertificationStatusEdFactsCode
			, HighlyQualifiedTeacherIndicatorCode
			, HighlyQualifiedTeacherIndicatorDescription
			, HighlyQualifiedTeacherIndicatorEdFactsCode
			, EdFactsTeacherInexperiencedStatusCode
			, EdFactsTeacherInexperiencedStatusDescription
			, EdFactsTeacherInexperiencedStatusEdFactsCode
			, EdFactsTeacherOutOfFieldStatusCode
			, EdFactsTeacherOutOfFieldStatusDescription
			, EdFactsTeacherOutOfFieldStatusEdFactsCode
			, SpecialEducationTeacherQualificationStatusCode
			, SpecialEducationTeacherQualificationStatusDescription
			, SpecialEducationTeacherQualificationStatusEdFactsCode
			, ParaprofessionalQualificationStatusCode
			, ParaprofessionalQualificationStatusDescription
			, ParaprofessionalQualificationStatusEdFactsCode
			, SpecialEducationRelatedServicesPersonnelCode
			, SpecialEducationRelatedServicesPersonnelDescription
			, CTEInstructorIndustryCertificationCode
			, CTEInstructorIndustryCertificationDescription
			, SpecialEducationParaprofessionalCode
			, SpecialEducationParaprofessionalDescription
			, SpecialEducationTeacherCode
			, SpecialEducationTeacherDescription
		)
		VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimK12StaffStatuses OFF
	END

	IF OBJECT_ID('tempdb..#SpecialEducationAgeGroupTaught') IS NOT NULL BEGIN
		DROP TABLE #SpecialEducationAgeGroupTaught
	END

	CREATE TABLE #SpecialEducationAgeGroupTaught (SpecialEducationAgeGroupTaughtCode VARCHAR(50), SpecialEducationAgeGroupTaughtDescription VARCHAR(200), SpecialEducationAgeGroupTaughtEdFactsCode VARCHAR(50))

	INSERT INTO #SpecialEducationAgeGroupTaught VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #SpecialEducationAgeGroupTaught 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode 
			WHEN '3TO5' THEN '3TO5NOTK'
			WHEN '6TO21' THEN 'AGE5KTO21'
			ELSE 'MISSING'
		END AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'SpecialEducationAgeGroupTaught'

	IF OBJECT_ID('tempdb..#EdFactsCertificationStatus') IS NOT NULL BEGIN
		DROP TABLE #EdFactsCertificationStatus
	END

	IF OBJECT_ID('tempdb..#EdFactsCertificationStatus') IS NOT NULL BEGIN
		DROP TABLE #EdFactsCertificationStatus
	END

	CREATE TABLE #EdFactsCertificationStatus (EdFactsCertificationStatusCode VARCHAR(50), EdFactsCertificationStatusDescription VARCHAR(200), EdFactsCertificationStatusEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsCertificationStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsCertificationStatus
	SELECT DISTINCT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsCertificationStatus'

	IF OBJECT_ID('tempdb..#HighlyQualifiedTeacherIndicator') IS NOT NULL BEGIN
		DROP TABLE #HighlyQualifiedTeacherIndicator
	END

	CREATE TABLE #HighlyQualifiedTeacherIndicator (HighlyQualifiedTeacherIndicatorCode VARCHAR(50), HighlyQualifiedTeacherIndicatorDescription VARCHAR(200), HighlyQualifiedTeacherIndicatorEdFactsCode VARCHAR(50))

	INSERT INTO #HighlyQualifiedTeacherIndicator VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #HighlyQualifiedTeacherIndicator 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'HighlyQualifiedTeacherIndicator'

	IF OBJECT_ID('tempdb..#EdFactsTeacherInexperiencedStatus') IS NOT NULL BEGIN
		DROP TABLE #EdFactsTeacherInexperiencedStatus
	END
	CREATE TABLE #EdFactsTeacherInexperiencedStatus (EdFactsTeacherInexperiencedStatusCode VARCHAR(50), EdFactsTeacherInexperiencedStatusDescription VARCHAR(200), EdFactsTeacherInexperiencedStatusEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsTeacherInexperiencedStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsTeacherInexperiencedStatus 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsTeacherInexperiencedStatus'

	IF OBJECT_ID('tempdb..#EdFactsTeacherOutOfFieldStatus') IS NOT NULL BEGIN
		DROP TABLE #EdFactsTeacherOutOfFieldStatus
	END
	CREATE TABLE #EdFactsTeacherOutOfFieldStatus (EdFactsTeacherOutOfFieldStatusCode VARCHAR(50), EdFactsTeacherOutOfFieldStatusDescription VARCHAR(200), EdFactsTeacherOutOfFieldStatusEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsTeacherOutOfFieldStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsTeacherOutOfFieldStatus 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsTeacherOutOfFieldStatus'

	IF OBJECT_ID('tempdb..#SpecialEducationTeacherQualificationStatus') IS NOT NULL BEGIN
		DROP TABLE #SpecialEducationTeacherQualificationStatus
	END
	CREATE TABLE #SpecialEducationTeacherQualificationStatus (SpecialEducationTeacherQualificationStatusCode VARCHAR(50), SpecialEducationTeacherQualificationStatusDescription VARCHAR(200), SpecialEducationTeacherQualificationStatusEdFactsCode VARCHAR(50))

	INSERT INTO #SpecialEducationTeacherQualificationStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #SpecialEducationTeacherQualificationStatus 
	SELECT DISTINCT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'SpecialEducationTeacherQualificationStatus'

	IF OBJECT_ID('tempdb..#ParaprofessionalQualificationStatus') IS NOT NULL BEGIN
		DROP TABLE #ParaprofessionalQualificationStatus
	END
	CREATE TABLE #ParaprofessionalQualificationStatus (ParaprofessionalQualificationStatusCode VARCHAR(50), ParaprofessionalQualificationStatusDescription VARCHAR(200), ParaprofessionalQualificationStatusEdFactsCode VARCHAR(50))

	INSERT INTO #ParaprofessionalQualificationStatus VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #ParaprofessionalQualificationStatus 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode 
			WHEN 'Qualified' THEN 'Q'
			WHEN 'NotQualified' THEN 'NQ'
		  END AS EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'ParaprofessionalQualificationStatus'

	IF OBJECT_ID('tempdb..#SpecialEducationRelatedServicesPersonnel') IS NOT NULL BEGIN
		DROP TABLE #SpecialEducationRelatedServicesPersonnel
	END
	CREATE TABLE #SpecialEducationRelatedServicesPersonnel (SpecialEducationRelatedServicesPersonnelCode VARCHAR(50), SpecialEducationRelatedServicesPersonnelDescription VARCHAR(200))

	INSERT INTO #SpecialEducationRelatedServicesPersonnel VALUES ('MISSING', 'MISSING')
	INSERT INTO #SpecialEducationRelatedServicesPersonnel 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'SpecialEducationRelatedServicesPersonnel'


	IF OBJECT_ID('tempdb..#CTEInstructorIndustryCertification') IS NOT NULL BEGIN
		DROP TABLE #CTEInstructorIndustryCertification
	END
	CREATE TABLE #CTEInstructorIndustryCertification (CTEInstructorIndustryCertificationCode VARCHAR(50), CTEInstructorIndustryCertificationDescription VARCHAR(200))

	INSERT INTO #CTEInstructorIndustryCertification VALUES ('MISSING', 'MISSING')
	INSERT INTO #CTEInstructorIndustryCertification 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'CTEInstructorIndustryCertification'

	IF OBJECT_ID('tempdb..#SpecialEducationParaprofessional') IS NOT NULL BEGIN
		DROP TABLE #SpecialEducationParaprofessional
	END
	CREATE TABLE #SpecialEducationParaprofessional (SpecialEducationParaprofessionalCode VARCHAR(50), SpecialEducationParaprofessionalDescription VARCHAR(200))

	INSERT INTO #SpecialEducationParaprofessional VALUES ('MISSING', 'MISSING')
	INSERT INTO #SpecialEducationParaprofessional 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'SpecialEducationParaprofessional'

	IF OBJECT_ID('tempdb..#SpecialEducationTeacher') IS NOT NULL BEGIN
		DROP TABLE #SpecialEducationTeacher
	END
	CREATE TABLE #SpecialEducationTeacher (SpecialEducationTeacherCode VARCHAR(50), SpecialEducationTeacherDescription VARCHAR(200))

	INSERT INTO #SpecialEducationTeacher VALUES ('MISSING', 'MISSING')
	INSERT INTO #SpecialEducationTeacher 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'SpecialEducationTeacher'

	INSERT INTO RDS.DimK12StaffStatuses (
		SpecialEducationAgeGroupTaughtCode
		, SpecialEducationAgeGroupTaughtDescription
		, SpecialEducationAgeGroupTaughtEdFactsCode
		, EdFactsCertificationStatusCode
		, EdFactsCertificationStatusDescription
		, EdFactsCertificationStatusEdFactsCode
		, HighlyQualifiedTeacherIndicatorCode
		, HighlyQualifiedTeacherIndicatorDescription
		, HighlyQualifiedTeacherIndicatorEdFactsCode
		, EdFactsTeacherInexperiencedStatusCode
		, EdFactsTeacherInexperiencedStatusDescription
		, EdFactsTeacherInexperiencedStatusEdFactsCode
		, EdFactsTeacherOutOfFieldStatusCode
		, EdFactsTeacherOutOfFieldStatusDescription
		, EdFactsTeacherOutOfFieldStatusEdFactsCode
		, SpecialEducationTeacherQualificationStatusCode
		, SpecialEducationTeacherQualificationStatusDescription
		, SpecialEducationTeacherQualificationStatusEdFactsCode
		, ParaprofessionalQualificationStatusCode
		, ParaprofessionalQualificationStatusDescription
		, ParaprofessionalQualificationStatusEdFactsCode
		, SpecialEducationRelatedServicesPersonnelCode
		, SpecialEducationRelatedServicesPersonnelDescription
		, CTEInstructorIndustryCertificationCode
		, CTEInstructorIndustryCertificationDescription
		, SpecialEducationParaprofessionalCode
		, SpecialEducationParaprofessionalDescription
		, SpecialEducationTeacherCode
		, SpecialEducationTeacherDescription
	)
	SELECT 
		seagt.SpecialEducationAgeGroupTaughtCode 
		, seagt.SpecialEducationAgeGroupTaughtDescription
		, seagt.SpecialEducationAgeGroupTaughtEdFactsCode
		, efcs.EdFactsCertificationStatusCode
		, efcs.EdFactsCertificationStatusDescription
		, efcs.EdFactsCertificationStatusEdFactsCode
		, hqti.HighlyQualifiedTeacherIndicatorCode
		, hqti.HighlyQualifiedTeacherIndicatorDescription
		, hqti.HighlyQualifiedTeacherIndicatorEdFactsCode
		, dftis.EdFactsTeacherInexperiencedStatusCode
		, dftis.EdFactsTeacherInexperiencedStatusDescription
		, dftis.EdFactsTeacherInexperiencedStatusEdFactsCode
		, eftoofs.EdFactsTeacherOutOfFieldStatusCode
		, eftoofs.EdFactsTeacherOutOfFieldStatusDescription
		, eftoofs.EdFactsTeacherOutOfFieldStatusEdFactsCode
		, setqs.SpecialEducationTeacherQualificationStatusCode
		, setqs.SpecialEducationTeacherQualificationStatusDescription
		, setqs.SpecialEducationTeacherQualificationStatusEdFactsCode	
		, pqs.ParaprofessionalQualificationStatusCode
		, pqs.ParaprofessionalQualificationStatusDescription
		, pqs.ParaprofessionalQualificationStatusEdFactsCode
		, sersp.SpecialEducationRelatedServicesPersonnelCode
		, sersp.SpecialEducationRelatedServicesPersonnelDescription
		, cteiic.CTEInstructorIndustryCertificationCode
		, cteiic.CTEInstructorIndustryCertificationDescription
		, sep.SpecialEducationParaprofessionalCode
		, sep.SpecialEducationParaprofessionalDescription
		, spet.SpecialEducationTeacherCode
		, spet.SpecialEducationTeacherDescription
	FROM #SpecialEducationAgeGroupTaught seagt
	CROSS JOIN #EdFactsCertificationStatus efcs
	CROSS JOIN #HighlyQualifiedTeacherIndicator hqti
	CROSS JOIN #EdFactsTeacherInexperiencedStatus dftis
	CROSS JOIN #EdFactsTeacherOutOfFieldStatus eftoofs
	CROSS JOIN #SpecialEducationTeacherQualificationStatus setqs
	CROSS JOIN #ParaprofessionalQualificationStatus pqs
	CROSS JOIN #SpecialEducationRelatedServicesPersonnel sersp
	CROSS JOIN #CTEInstructorIndustryCertification cteiic
	CROSS JOIN #SpecialEducationParaprofessional sep
	CROSS JOIN #SpecialEducationTeacher spet
	LEFT JOIN RDS.DimK12StaffStatuses main
		ON seagt.SpecialEducationAgeGroupTaughtCode = main.SpecialEducationAgeGroupTaughtCode
		AND efcs.EdFactsCertificationStatusCode = main.EdFactsCertificationStatusCode
		AND hqti.HighlyQualifiedTeacherIndicatorCode = main.HighlyQualifiedTeacherIndicatorCode
		AND dftis.EdFactsTeacherInexperiencedStatusCode = main.EdFactsTeacherInexperiencedStatusCode
		AND eftoofs.EdFactsTeacherOutOfFieldStatusCode = main.EdFactsTeacherOutOfFieldStatusCode
		AND setqs.SpecialEducationTeacherQualificationStatusCode = main.SpecialEducationTeacherQualificationStatusCode
		AND pqs.ParaprofessionalQualificationStatusCode = main.ParaprofessionalQualificationStatusCode
		AND sersp.SpecialEducationRelatedServicesPersonnelCode = main.SpecialEducationRelatedServicesPersonnelCode
		AND cteiic.CTEInstructorIndustryCertificationCode = main.CTEInstructorIndustryCertificationCode
		AND sep.SpecialEducationParaprofessionalCode = main.SpecialEducationParaprofessionalCode
		AND spet.SpecialEducationTeacherCode = main.SpecialEducationTeacherCode
	WHERE main.DimK12StaffStatusId IS NULL

	DROP TABLE #SpecialEducationAgeGroupTaught
	DROP TABLE #EdFactsCertificationStatus
	DROP TABLE #HighlyQualifiedTeacherIndicator
	DROP TABLE #EdFactsTeacherInexperiencedStatus
	DROP TABLE #EdFactsTeacherOutOfFieldStatus
	DROP TABLE #SpecialEducationTeacherQualificationStatus
	DROP TABLE #ParaprofessionalQualificationStatus
	DROP TABLE #SpecialEducationRelatedServicesPersonnel
	DROP TABLE #CTEInstructorIndustryCertification
	DROP TABLE #SpecialEducationParaprofessional
	DROP TABLE #SpecialEducationTeacher

	--add constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StaffCounts_K12StaffStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StaffCounts')
	BEGIN
		ALTER TABLE [RDS].[FactK12StaffCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId] FOREIGN KEY([K12StaffStatusId])
		REFERENCES [RDS].[DimK12StaffStatuses] ([DimK12StaffStatusId]);

		ALTER TABLE [RDS].[FactK12StaffCounts] CHECK CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId];
	END

	-----------------------------------------------------
	-- Populate DimMilitaryStatuses					   --
	-----------------------------------------------------
	--drop constraints
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentAssessments_MilitaryStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentAssessments')
		ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_MilitaryStatusId];

	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentDisciplines_MilitaryStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentDisciplines')
		ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_MilitaryStatusId];

	--clear the table
	delete from RDS.DimMilitaryStatuses WHERE DimMilitaryStatusId <> -1

	IF NOT EXISTS (SELECT 1 FROM RDS.DimMilitaryStatuses d WHERE d.DimMilitaryStatusId = -1) BEGIN
		SET IDENTITY_INSERT rds.DimMilitaryStatuses ON

			INSERT INTO rds.DimMilitaryStatuses (
						  DimMilitaryStatusId
						, MilitaryConnectedStudentIndicatorCode       
						, MilitaryConnectedStudentIndicatorDescription
						, MilitaryConnectedStudentIndicatorEdFactsCode
						, ActiveMilitaryStatusIndicatorCode          
						, ActiveMilitaryStatusIndicatorDescription   
						, MilitaryBranchCode                          
						, MilitaryBranchDescription                   
						, MilitaryVeteranStatusIndicatorCode         
						, MilitaryVeteranStatusIndicatorDescription  
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
					, 'MISSING')

		SET IDENTITY_INSERT rds.DimMilitaryStatuses OFF
	END

	IF OBJECT_ID('tempdb..#MilitaryConnectedStudentIndicator') IS NOT NULL
		DROP TABLE #MilitaryConnectedStudentIndicator

	CREATE TABLE #MilitaryConnectedStudentIndicator (MilitaryConnectedStudentIndicatorCode VARCHAR(50), MilitaryConnectedStudentIndicatorDescription VARCHAR(200), MilitaryConnectedStudentIndicatorEdFactsCode VARCHAR(50))

	INSERT INTO #MilitaryConnectedStudentIndicator VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #MilitaryConnectedStudentIndicator 
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, EdFactsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'MilitaryConnectedStudentIndicator'

	IF OBJECT_ID('tempdb..#ActiveMilitaryStatusIndicator') IS NOT NULL
		DROP TABLE #ActiveMilitaryStatusIndicator

	CREATE TABLE #ActiveMilitaryStatusIndicator (ActiveMilitaryStatusIndicatorCode VARCHAR(50), ActiveMilitaryStatusIndicatorDescription VARCHAR(200))

	INSERT INTO #ActiveMilitaryStatusIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #ActiveMilitaryStatusIndicator 
	SELECT 
			CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'ActiveMilitaryStatusIndicator'

	IF OBJECT_ID('tempdb..#MilitaryBranch') IS NOT NULL
		DROP TABLE #MilitaryBranch

	CREATE TABLE #MilitaryBranch (MilitaryBranchCode VARCHAR(50), MilitaryBranchDescription VARCHAR(200))

	INSERT INTO #MilitaryBranch VALUES ('MISSING', 'MISSING')
	INSERT INTO #MilitaryBranch 
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'MilitaryBranch'
	
	IF OBJECT_ID('tempdb..#MilitaryVeteranStatusIndicator') IS NOT NULL
		DROP TABLE #MilitaryVeteranStatusIndicator

	CREATE TABLE #MilitaryVeteranStatusIndicator (MilitaryVeteranStatusIndicatorCode VARCHAR(50), MilitaryVeteranStatusIndicatorDescription VARCHAR(200))

	INSERT INTO #MilitaryVeteranStatusIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #MilitaryVeteranStatusIndicator 
	SELECT 
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'MilitaryVeteranStatusIndicator'

	INSERT INTO rds.DimMilitaryStatuses 
		(
			  MilitaryConnectedStudentIndicatorCode       
			, MilitaryConnectedStudentIndicatorDescription
			, MilitaryConnectedStudentIndicatorEdFactsCode
			, ActiveMilitaryStatusIndicatorCode          
			, ActiveMilitaryStatusIndicatorDescription   
			, MilitaryBranchCode                          
			, MilitaryBranchDescription                   
			, MilitaryVeteranStatusIndicatorCode         
			, MilitaryVeteranStatusIndicatorDescription  
		)
	SELECT 
		  a.MilitaryConnectedStudentIndicatorCode
		, a.MilitaryConnectedStudentIndicatorDescription
		, a.MilitaryConnectedStudentIndicatorEdFactsCode
		, b.ActiveMilitaryStatusIndicatorCode
		, b.ActiveMilitaryStatusIndicatorDescription
		, c.MilitaryBranchCode
		, c.MilitaryBranchDescription
		, d.MilitaryVeteranStatusIndicatorCode
		, d.MilitaryVeteranStatusIndicatorDescription
	FROM #MilitaryConnectedStudentIndicator a
	CROSS JOIN #ActiveMilitaryStatusIndicator b
	CROSS JOIN #MilitaryBranch c
	CROSS JOIN #MilitaryVeteranStatusIndicator d
	LEFT JOIN RDS.DimMilitaryStatuses main
		ON  a.MilitaryConnectedStudentIndicatorCode = main.MilitaryConnectedStudentIndicatorCode
		AND b.ActiveMilitaryStatusIndicatorCode	 = main.ActiveMilitaryStatusIndicatorCode
		AND c.MilitaryBranchCode						 = main.MilitaryBranchCode
		AND d.MilitaryVeteranStatusIndicatorCode   = main.MilitaryVeteranStatusIndicatorCode
	WHERE main.DimMilitaryStatusId IS NULL

	DROP TABLE #MilitaryConnectedStudentIndicator
	DROP TABLE #ActiveMilitaryStatusIndicator
	DROP TABLE #MilitaryBranch
	DROP TABLE #MilitaryVeteranStatusIndicator

	--add constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentAssessments_MilitaryStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentAssessments')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentAssessments_MilitaryStatusId] FOREIGN KEY([MilitaryStatusId])
		REFERENCES [RDS].[DimMilitaryStatuses] ([DimMilitaryStatusId]);

		ALTER TABLE [RDS].[FactK12StudentAssessments] CHECK CONSTRAINT [FK_FactK12StudentAssessments_MilitaryStatusId];
	END

	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentDisciplines_MilitaryStatusId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentDisciplines')
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentDisciplines]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentDisciplines_MilitaryStatusId] FOREIGN KEY([MilitaryStatusId])
		REFERENCES [RDS].[DimMilitaryStatuses] ([DimMilitaryStatusId]);

		ALTER TABLE [RDS].[FactK12StudentDisciplines] CHECK CONSTRAINT [FK_FactK12StudentDisciplines_MilitaryStatusId];
	END


	-----------------------------------------------------
	-- Populate DimAttendances                     --
	-----------------------------------------------------

	--Drop any FK constraints
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentCounts_AttendanceId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentCounts')
		ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_AttendanceId];
	
	--Remove any existing rows before populating
	DELETE FROM RDS.DimAttendances WHERE DimAttendanceId <> -1

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAttendances d WHERE d.DimAttendanceId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimAttendances ON

		INSERT INTO [RDS].[DimAttendances]
           ([DimAttendanceId]
           ,ChronicStudentAbsenteeismIndicatorCode
           ,ChronicStudentAbsenteeismIndicatorDescription
		   ,ChronicStudentAbsenteeismIndicatorEdFactsCode
		   ,AttendanceEventTypeCode
		   ,AttendanceEventTypeDescription
		   ,AttendanceStatusCode
		   ,AttendanceStatusDescription
		   ,PresentAttendanceCategoryCode
		   ,PresentAttendanceCategoryDescription
		   ,AbsentAttendanceCategoryCode
		   ,AbsentAttendanceCategoryDescription
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
				)

		SET IDENTITY_INSERT RDS.DimAttendances OFF

	END

	IF OBJECT_ID('tempdb..#ChronicStudentAbsenteeismIndicator') IS NOT NULL BEGIN
		DROP TABLE #ChronicStudentAbsenteeismIndicator
	END

	CREATE TABLE #ChronicStudentAbsenteeismIndicator (ChronicStudentAbsenteeismIndicatorCode VARCHAR(50), ChronicStudentAbsenteeismIndicatorDescription VARCHAR(200), ChronicStudentAbsenteeismIndicatorEdFactsCode VARCHAR(50))

	INSERT INTO #ChronicStudentAbsenteeismIndicator VALUES ('MISSING', 'MISSING', 'MISSING')

	--Insert the default row until the CEDS table is updated
	INSERT INTO #ChronicStudentAbsenteeismIndicator VALUES ('CA', 'Chronically Absent', 'MISSING')

	--INSERT INTO #ChronicStudentAbsenteeismIndicator 
	--SELECT
	--	  CedsOptionSetCode
	--	, CedsOptionSetDescription
	--	, EdFactsOptionSetCode
	--FROM [CEDS].CedsOptionSetMapping
	--WHERE CedsElementTechnicalName = 'ChronicStudentAbsenteeismIndicator'

	IF OBJECT_ID('tempdb..#AttendanceEventType') IS NOT NULL BEGIN
		DROP TABLE #AttendanceEventType
	END

	CREATE TABLE #AttendanceEventType (AttendanceEventTypeCode VARCHAR(50), AttendanceEventTypeDescription VARCHAR(200))

	INSERT INTO #AttendanceEventType VALUES ('MISSING', 'MISSING')
	INSERT INTO #AttendanceEventType 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AttendanceEventType'

	IF OBJECT_ID('tempdb..#AttendanceStatus') IS NOT NULL BEGIN
		DROP TABLE #AttendanceStatus
	END

	CREATE TABLE #AttendanceStatus (AttendanceStatusCode VARCHAR(50), AttendanceStatusDescription VARCHAR(200))

	INSERT INTO #AttendanceStatus VALUES ('MISSING', 'MISSING')
	INSERT INTO #AttendanceStatus 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AttendanceStatus'

	IF OBJECT_ID('tempdb..#PresentAttendanceCategory') IS NOT NULL BEGIN
		DROP TABLE #PresentAttendanceCategory
	END

	CREATE TABLE #PresentAttendanceCategory (PresentAttendanceCategoryCode VARCHAR(50), PresentAttendanceCategoryDescription VARCHAR(200))

	INSERT INTO #PresentAttendanceCategory VALUES ('MISSING', 'MISSING')
	INSERT INTO #PresentAttendanceCategory 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'PresentAttendanceCategory'

	IF OBJECT_ID('tempdb..#AbsentAttendanceCategory') IS NOT NULL BEGIN
		DROP TABLE #AbsentAttendanceCategory
	END

	CREATE TABLE #AbsentAttendanceCategory (AbsentAttendanceCategoryCode VARCHAR(50), AbsentAttendanceCategoryDescription VARCHAR(200))

	INSERT INTO #AbsentAttendanceCategory VALUES ('MISSING', 'MISSING')
	INSERT INTO #AbsentAttendanceCategory 
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'AbsentAttendanceCategory'

	INSERT INTO RDS.DimAttendances
		(
			  ChronicStudentAbsenteeismIndicatorCode
			, ChronicStudentAbsenteeismIndicatorDescription
			, ChronicStudentAbsenteeismIndicatorEdFactsCode
			, AttendanceEventTypeCode
			, AttendanceEventTypeDescription
			, AttendanceStatusCode
			, AttendanceStatusDescription
			, PresentAttendanceCategoryCode
			, PresentAttendanceCategoryDescription
			, AbsentAttendanceCategoryCode
			, AbsentAttendanceCategoryDescription
		)
	SELECT 
			  a.ChronicStudentAbsenteeismIndicatorCode
			, a.ChronicStudentAbsenteeismIndicatorDescription
			, a.ChronicStudentAbsenteeismIndicatorEdFactsCode
			, b.AttendanceEventTypeCode
			, b.AttendanceEventTypeDescription
			, c.AttendanceStatusCode
			, c.AttendanceStatusDescription
			, d.PresentAttendanceCategoryCode
			, d.PresentAttendanceCategoryDescription
			, e.AbsentAttendanceCategoryCode
			, e.AbsentAttendanceCategoryDescription

	FROM #ChronicStudentAbsenteeismIndicator a
	CROSS JOIN #AttendanceEventType b
	CROSS JOIN #AttendanceStatus c
	CROSS JOIN #PresentAttendanceCategory d
	CROSS JOIN #AbsentAttendanceCategory e
	LEFT JOIN RDS.DimAttendances main
		ON a.ChronicStudentAbsenteeismIndicatorCode = main.ChronicStudentAbsenteeismIndicatorCode
		AND b.AttendanceEventTypeCode = main.AttendanceEventTypeCode
		AND c.AttendanceStatusCode = main.AttendanceStatusCode
		AND d.PresentAttendanceCategoryCode = main.PresentAttendanceCategoryCode
		AND e.AbsentAttendanceCategoryCode = main.AbsentAttendanceCategoryCode
	WHERE main.DimAttendanceId IS NULL

	DROP TABLE #ChronicStudentAbsenteeismIndicator
	DROP TABLE #AttendanceEventType
	DROP TABLE #AttendanceStatus
	DROP TABLE #PresentAttendanceCategory
	DROP TABLE #AbsentAttendanceCategory

	--Add the constraints back
	IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_FactK12StudentCounts_AttendanceId' AND TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'FactK12StudentCounts')
	BEGIN 
		ALTER TABLE [RDS].[FactK12StudentCounts]  WITH CHECK ADD  CONSTRAINT [FK_FactK12StudentCounts_AttendanceId] FOREIGN KEY([AttendanceId])
		REFERENCES [RDS].[DimAttendances] ([DimAttendanceId]);

		ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_AttendanceId];
	END


