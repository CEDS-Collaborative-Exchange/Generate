--Add new columns to ReportEDFactsK12StudentAssessments

	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'ASSESSMENTTYPEADMINISTERED') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD ASSESSMENTTYPEADMINISTERED nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'CONSOLIDATEDMEPFUNDSSTATUS') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD CONSOLIDATEDMEPFUNDSSTATUS nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'CONTINUATIONOFSERVICESREASON') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD CONTINUATIONOFSERVICESREASON nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'MIGRANTEDUCATIONPROGRAMENROLLMENTTYPE') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTEDUCATIONPROGRAMENROLLMENTTYPE nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'MIGRANTEDUCATIONPROGRAMSERVICESTYPE') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTEDUCATIONPROGRAMSERVICESTYPE nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'MIGRANTPRIORITIZEDFORSERVICES') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD MIGRANTPRIORITIZEDFORSERVICES nvarchar(50);
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'NEGLECTEDORDELINQUENTLONGTERMSTATUS') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDORDELINQUENTLONGTERMSTATUS nvarchar(50);
	END


--Rename existing columns in ReportEDFactsK12StudentAssessments

	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'FOSTERCAREPROGRAM') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].FOSTERCAREPROGRAM', N'PROGRAMPARTICIPATIONFOSTERCARE', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'ASSESSMENTSUBJECT') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ASSESSMENTSUBJECT', N'ASSESSMENTACADEMICSUBJECT', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'CTEPROGRAM') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].CTEPROGRAM', N'CTEPARTICIPANT', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'ACADEMICORVOCATIONALEXITOUTCOME') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ACADEMICORVOCATIONALEXITOUTCOME', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'ACADEMICORVOCATIONALOUTCOME') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].ACADEMICORVOCATIONALOUTCOME', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'IDEAEDUCATIONALENVIRONMENT') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].IDEAEDUCATIONALENVIRONMENT', N'IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'SINGLEPARENTORSINGLEPREGNANTWOMAN') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].SINGLEPARENTORSINGLEPREGNANTWOMAN', N'SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'PERFORMANCELEVEL') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].PERFORMANCELEVEL', N'ASSESSMENTPERFORMANCELEVELIDENTIFIER', 'COLUMN';
	END
	IF COL_LENGTH('RDS.ReportEDFactsK12StudentAssessments', 'PARTICIPATIONSTATUS') IS NOT NULL
	BEGIN
		EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentAssessments].PARTICIPATIONSTATUS', N'ASSESSMENTREGISTRATIONPARTICIPATIONINDICATOR', 'COLUMN';
	END

----------------------------------------------------------------------------------------------------------
--Repopulate the DimAssessmentRegistrations table (fields were swapped when it was created in v11)
----------------------------------------------------------------------------------------------------------
--Repopulate the DimAssessmentRegistrations table (fields were swapped when it was created in v11)

	TRUNCATE TABLE RDS.DimAssessmentRegistrations

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentRegistrations d WHERE d.DimAssessmentRegistrationId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimAssessmentRegistrations ON

		INSERT INTO [RDS].[DimAssessmentRegistrations] (
			[DimAssessmentRegistrationId]
			,[AssessmentRegistrationParticipationIndicatorCode]
			,[AssessmentRegistrationParticipationIndicatorDescription]
			,[AssessmentRegistrationCompletionStatusCode]
			,[AssessmentRegistrationCompletionStatusDescription]
			,[StateFullAcademicYearCode]
			,[StateFullAcademicYearDescription]
			,[StateFullAcademicYearEdFactsCode]
			,[LeaFullAcademicYearCode]
			,[LeaFullAcademicYearDescription]
			,[LeaFullAcademicYearEdFactsCode]
			,[SchoolFullAcademicYearCode]
			,[SchoolFullAcademicYearDescription]
			,[SchoolFullAcademicYearEdFactsCode]
			,[AssessmentRegistrationReasonNotCompletingCode]	
			,[AssessmentRegistrationReasonNotCompletingDescription]
			,[AssessmentRegistrationReasonNotCompletingEdFactsCode]	
			,[ReasonNotTestedCode]	
			,[ReasonNotTestedDescription]	
			,[ReasonNotTestedEdFactsCode]
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
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
		)

		SET IDENTITY_INSERT RDS.DimAssessmentRegistrations OFF

	END

		IF OBJECT_ID('tempdb..#AssessmentRegistrationParticipationIndicator') IS NOT NULL
			DROP TABLE  #AssessmentRegistrationParticipationIndicator
			
		CREATE TABLE #AssessmentRegistrationParticipationIndicator (AssessmentRegistrationParticipationIndicatorCode VARCHAR(50), AssessmentRegistrationParticipationIndicatorDescription VARCHAR(200))

		INSERT INTO #AssessmentRegistrationParticipationIndicator VALUES ('MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationParticipationIndicator 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationParticipationIndicator'


		IF OBJECT_ID('tempdb..#AssessmentRegistrationCompletionStatus') IS NOT NULL
			DROP TABLE #AssessmentRegistrationCompletionStatus

		CREATE TABLE #AssessmentRegistrationCompletionStatus (AssessmentRegistrationCompletionStatusCode VARCHAR(50), AssessmentRegistrationCompletionStatusDescription VARCHAR(200))

		INSERT INTO #AssessmentRegistrationCompletionStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationCompletionStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationCompletionStatus'


		IF OBJECT_ID('tempdb..#StateFullAcademicYear') IS NOT NULL
			DROP TABLE #StateFullAcademicYear

		CREATE TABLE #StateFullAcademicYear (StateFullAcademicYearCode VARCHAR(50), StateFullAcademicYearDescription VARCHAR(200), StateFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #StateFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #StateFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'StateFullAcademicYear'


		IF OBJECT_ID('tempdb..#LeaFullAcademicYear') IS NOT NULL
			DROP TABLE #LeaFullAcademicYear

		CREATE TABLE #LeaFullAcademicYear (LeaFullAcademicYearCode VARCHAR(50), LeaFullAcademicYearDescription VARCHAR(200), LeaFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #LeaFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #LeaFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'LeaFullAcademicYear'

		IF OBJECT_ID('tempdb..#SchoolFullAcademicYear') IS NOT NULL
			DROP TABLE #SchoolFullAcademicYear

		CREATE TABLE #SchoolFullAcademicYear (SchoolFullAcademicYearCode VARCHAR(50), SchoolFullAcademicYearDescription VARCHAR(200), SchoolFullAcademicYearEdFactsCode VARCHAR(50))

		INSERT INTO #SchoolFullAcademicYear VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #SchoolFullAcademicYear 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN 'Yes' THEN 'FULLYR'
				WHEN 'No' THEN 'NFULLYR'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SchoolFullAcademicYear'

		IF OBJECT_ID('tempdb..#AssessmentRegistrationReasonNotCompleting') IS NOT NULL
			DROP TABLE #AssessmentRegistrationReasonNotCompleting

		CREATE TABLE #AssessmentRegistrationReasonNotCompleting (AssessmentRegistrationReasonNotCompletingCode VARCHAR(50), AssessmentRegistrationReasonNotCompletingDescription VARCHAR(200), AssessmentRegistrationReasonNotCompletingEdFactsCode VARCHAR(50))

		INSERT INTO #AssessmentRegistrationReasonNotCompleting VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #AssessmentRegistrationReasonNotCompleting 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE 
				WHEN CedsOptionSetCode <> 'MISSING' THEN 'NPART'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'AssessmentRegistrationReasonNotCompleting'

		IF OBJECT_ID('tempdb..#ReasonNotTested') IS NOT NULL
			DROP TABLE #ReasonNotTested
		
		CREATE TABLE #ReasonNotTested (ReasonNotTestedCode VARCHAR(50), ReasonNotTestedDescription VARCHAR(200), ReasonNotTestedEdFactsCode VARCHAR(50))

		INSERT INTO #ReasonNotTested VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #ReasonNotTested 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN '03451' THEN 'NPART'
				WHEN '03452' THEN 'NPART'
				WHEN '03453' THEN 'NPART'
				WHEN '03454' THEN 'MEDEXEMPT'
				WHEN '03455' THEN 'NPART'
				WHEN '03456' THEN 'NPART'
				WHEN '09999' THEN 'NPART'
				ELSE 'MISSING'
			  END
		FROM CEDS.CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'ReasonNotTested'


	INSERT INTO [RDS].[DimAssessmentRegistrations] (
		[AssessmentRegistrationParticipationIndicatorCode]
		,[AssessmentRegistrationParticipationIndicatorDescription]
		,[AssessmentRegistrationCompletionStatusCode]
		,[AssessmentRegistrationCompletionStatusDescription]
		,[StateFullAcademicYearCode]
		,[StateFullAcademicYearDescription]
		,[StateFullAcademicYearEdFactsCode]
		,[LeaFullAcademicYearCode]
		,[LeaFullAcademicYearDescription]
		,[LeaFullAcademicYearEdFactsCode]
		,[SchoolFullAcademicYearCode]
		,[SchoolFullAcademicYearDescription]
		,[SchoolFullAcademicYearEdFactsCode]
		,[AssessmentRegistrationReasonNotCompletingCode]	
		,[AssessmentRegistrationReasonNotCompletingDescription]
		,[AssessmentRegistrationReasonNotCompletingEdFactsCode]	
		,[ReasonNotTestedCode]	
		,[ReasonNotTestedDescription]	
		,[ReasonNotTestedEdFactsCode]
	)
	SELECT 
		arpi.AssessmentRegistrationParticipationIndicatorCode
		,arpi.AssessmentRegistrationParticipationIndicatorDescription
		,arcs.AssessmentRegistrationCompletionStatusCode
		,arcs.AssessmentRegistrationCompletionStatusDescription
		,sfay.StateFullAcademicYearCode
		,sfay.StateFullAcademicYearDescription
		,sfay.StateFullAcademicYearEdFactsCode
		,lfay.LeaFullAcademicYearCode
		,lfay.LeaFullAcademicYearDescription
		,lfay.LeaFullAcademicYearEdFactsCode
		,schfay.SchoolFullAcademicYearCode
		,schfay.SchoolFullAcademicYearDescription
		,schfay.SchoolFullAcademicYearEdFactsCode
		,arrnc.AssessmentRegistrationReasonNotCompletingCode	
		,arrnc.AssessmentRegistrationReasonNotCompletingDescription
		,arrnc.AssessmentRegistrationReasonNotCompletingEdFactsCode	
		,rntc.ReasonNotTestedCode	
		,rntc.ReasonNotTestedDescription	
		,rntc.ReasonNotTestedEdFactsCode
	FROM #AssessmentRegistrationCompletionStatus arcs
	CROSS JOIN #AssessmentRegistrationParticipationIndicator arpi
	CROSS JOIN #StateFullAcademicYear sfay
	CROSS JOIN #LeaFullAcademicYear lfay
	CROSS JOIN #SchoolFullAcademicYear schfay
	CROSS JOIN #AssessmentRegistrationReasonNotCompleting arrnc
	CROSS JOIN #ReasonNotTested rntc
	LEFT JOIN rds.DimAssessmentRegistrations dar
		ON	arcs.AssessmentRegistrationCompletionStatusCode = dar.AssessmentRegistrationCompletionStatusCode
		AND arpi.AssessmentRegistrationParticipationIndicatorCode = dar.AssessmentRegistrationParticipationIndicatorCode
		AND sfay.StateFullAcademicYearCode = dar.StateFullAcademicYearCode
		AND lfay.LeaFullAcademicYearDescription = dar.LeaFullAcademicYearCode
		AND schfay.SchoolFullAcademicYearCode = dar.SchoolFullAcademicYearCode	
		AND arrnc.AssessmentRegistrationReasonNotCompletingCode = dar.AssessmentRegistrationReasonNotCompletingCode
		AND rntc.ReasonNotTestedCode = dar.ReasonNotTestedCode
	WHERE dar.DimAssessmentRegistrationId IS NULL

	DROP TABLE #AssessmentRegistrationCompletionStatus
	DROP TABLE #AssessmentRegistrationParticipationIndicator
	DROP TABLE #LeaFullAcademicYear
	DROP TABLE #SchoolFullAcademicYear
	DROP TABLE #StateFullAcademicYear
	DROP TABLE #AssessmentRegistrationReasonNotCompleting
	DROP TABLE #ReasonNotTested
