-----------------------------------------------------
	-- Populate DimTitleIStatuses
	-----------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimTitleIStatuses d WHERE d.DimTitleIStatusId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimTitleIStatuses ON

		INSERT INTO [RDS].[DimTitleIStatuses] (
			[DimTitleIStatusId]
			, [TitleIIndicatorCode] 
			, [TitleIIndicatorDescription] 
			, [TitleIIndicatorEdFactsCode] 
			, [SchoolChoiceAppliedforTransferStatusCode] 
			, [SchoolChoiceAppliedforTransferStatusDescription] 
			, [SchoolChoiceEligibleforTransferStatusCode] 
			, [SchoolChoiceEligibleforTransferStatusDescription] 
			, [SchoolChoiceTransferStatusCode] 
			, [SchoolChoiceTransferStatusDescription] 
			, [TitleISchoolSupplementalServicesAppliedStatusCode]
			, [TitleISchoolSupplementalServicesAppliedStatusDescription]
			, [TitleISchoolSupplementalServicesEligibleStatusCode] 
			, [TitleISchoolSupplementalServicesEligibleStatusDescription] 
			, [TitleISchoolSupplementalServicesReceivedStatusCode] 
			, [TitleISchoolSupplementalServicesReceivedStatusDescription] 
			, [TitleISchoolwideProgramParticipationCode] 
			, [TitleISchoolwideProgramParticipationDescription] 
			, [TitleITargetedAssistanceParticipationCode] 
			, [TitleITargetedAssistanceParticipationDescription] 
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

		SET IDENTITY_INSERT RDS.DimTitleIStatuses OFF

	END

		CREATE TABLE #TitleIIndicator (TitleIIndicatorCode VARCHAR(50), TitleIIndicatorDescription VARCHAR(100), TitleIIndicatorEdFactsCode VARCHAR(50))

		INSERT INTO #TitleIIndicator VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleIIndicator 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CASE CedsOptionSetCode
				WHEN '01' THEN 'TAS'
				WHEN '02' THEN 'SWP'
				WHEN '03' THEN 'PRIVTITLEI'
				WHEN '04' THEN 'NEG'
				WHEN '05' THEN 'MISSING'
			END 	
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleIIndicator'


		CREATE TABLE #SchoolChoiceAppliedforTransferStatus (SchoolChoiceAppliedforTransferStatusCode VARCHAR(50), SchoolChoiceAppliedforTransferStatusDescription VARCHAR(100))

		INSERT INTO #SchoolChoiceAppliedforTransferStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #SchoolChoiceAppliedforTransferStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SchoolChoiceAppliedForTransferStatus'

		CREATE TABLE #SchoolChoiceEligibleforTransferStatus (SchoolChoiceEligibleforTransferStatusCode VARCHAR(50), SchoolChoiceEligibleforTransferStatusDescription VARCHAR(100))

		INSERT INTO #SchoolChoiceEligibleforTransferStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #SchoolChoiceEligibleforTransferStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SchoolChoiceEligibleForTransferStatus'

		CREATE TABLE #SchoolChoiceTransferStatus (SchoolChoiceTransferStatusCode VARCHAR(50), SchoolChoiceTransferStatusDescription VARCHAR(100))

		INSERT INTO #SchoolChoiceTransferStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #SchoolChoiceTransferStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'SchoolChoiceTransferStatus'

		CREATE TABLE #TitleISchoolSupplementalServicesAppliedStatus (TitleISchoolSupplementalServicesAppliedStatusCode VARCHAR(50), TitleISchoolSupplementalServicesAppliedStatusDescription VARCHAR(100))

		INSERT INTO #TitleISchoolSupplementalServicesAppliedStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #TitleISchoolSupplementalServicesAppliedStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISchoolSupplementalServicesAppliedStatus'

		CREATE TABLE #TitleISchoolSupplementalServicesEligibleStatus (TitleISchoolSupplementalServicesEligibleStatusCode VARCHAR(50), TitleISchoolSupplementalServicesEligibleStatusDescription VARCHAR(100))

		INSERT INTO #TitleISchoolSupplementalServicesEligibleStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #TitleISchoolSupplementalServicesEligibleStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISchoolSupplementalServicesEligibleStatus'

		CREATE TABLE #TitleISchoolSupplementalServicesReceivedStatus (TitleISchoolSupplementalServicesReceivedStatusCode VARCHAR(50), TitleISchoolSupplementalServicesReceivedStatusDescription VARCHAR(100))

		INSERT INTO #TitleISchoolSupplementalServicesReceivedStatus VALUES ('MISSING', 'MISSING')
		INSERT INTO #TitleISchoolSupplementalServicesReceivedStatus 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISchoolSupplementalServicesReceivedStatus'

		CREATE TABLE #TitleISchoolwideProgramParticipation (TitleISchoolwideProgramParticipationCode VARCHAR(50), TitleISchoolwideProgramParticipationDescription VARCHAR(100))

		INSERT INTO #TitleISchoolwideProgramParticipation VALUES ('MISSING', 'MISSING')
		INSERT INTO #TitleISchoolwideProgramParticipation 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISchoolwideProgramParticipation'

		CREATE TABLE #TitleITargetedAssistanceParticipation (TitleITargetedAssistanceParticipationCode VARCHAR(50), TitleITargetedAssistanceParticipationDescription VARCHAR(100))

		INSERT INTO #TitleITargetedAssistanceParticipation VALUES ('MISSING', 'MISSING')
		INSERT INTO #TitleITargetedAssistanceParticipation 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleITargetedAssistanceParticipation'

	INSERT INTO [RDS].[DimTitleIStatuses] (
			[TitleIIndicatorCode] 
		    , [TitleIIndicatorDescription] 
		    , [TitleIIndicatorEdFactsCode] 
			, [SchoolChoiceAppliedforTransferStatusCode] 
			, [SchoolChoiceAppliedforTransferStatusDescription] 
			, [SchoolChoiceEligibleforTransferStatusCode] 
			, [SchoolChoiceEligibleforTransferStatusDescription] 
			, [SchoolChoiceTransferStatusCode] 
			, [SchoolChoiceTransferStatusDescription] 
			, [TitleISchoolSupplementalServicesAppliedStatusCode]
			, [TitleISchoolSupplementalServicesAppliedStatusDescription]
			, [TitleISchoolSupplementalServicesEligibleStatusCode] 
			, [TitleISchoolSupplementalServicesEligibleStatusDescription] 
			, [TitleISchoolSupplementalServicesReceivedStatusCode] 
			, [TitleISchoolSupplementalServicesReceivedStatusDescription] 
			, [TitleISchoolwideProgramParticipationCode] 
			, [TitleISchoolwideProgramParticipationDescription] 
			, [TitleITargetedAssistanceParticipationCode] 
			, [TitleITargetedAssistanceParticipationDescription] 
		)
	SELECT 
			tic.[TitleIIndicatorCode] 
		    , tic.[TitleIIndicatorDescription] 
		    , tic.[TitleIIndicatorEdFactsCode] 
			, scat.[SchoolChoiceAppliedforTransferStatusCode] 
			, scat.[SchoolChoiceAppliedforTransferStatusDescription] 
			, scet.[SchoolChoiceEligibleforTransferStatusCode] 
			, scet.[SchoolChoiceEligibleforTransferStatusDescription] 
			, sct.[SchoolChoiceTransferStatusCode] 
			, sct.[SchoolChoiceTransferStatusDescription] 
			, sssa.[TitleISchoolSupplementalServicesAppliedStatusCode]
			, sssa.[TitleISchoolSupplementalServicesAppliedStatusDescription]
			, ssse.[TitleISchoolSupplementalServicesEligibleStatusCode] 
			, ssse.[TitleISchoolSupplementalServicesEligibleStatusDescription] 
			, sssr.[TitleISchoolSupplementalServicesReceivedStatusCode] 
			, sssr.[TitleISchoolSupplementalServicesReceivedStatusDescription] 
			, swp.[TitleISchoolwideProgramParticipationCode] 
			, swp.[TitleISchoolwideProgramParticipationDescription] 
			, tap.[TitleITargetedAssistanceParticipationCode] 
			, tap.[TitleITargetedAssistanceParticipationDescription] 
	FROM #TitleIIndicator tic
	CROSS JOIN #SchoolChoiceAppliedforTransferStatus scat
	CROSS JOIN #SchoolChoiceEligibleforTransferStatus scet
	CROSS JOIN #SchoolChoiceTransferStatus sct
	CROSS JOIN #TitleISchoolSupplementalServicesAppliedStatus sssa
	CROSS JOIN #TitleISchoolSupplementalServicesEligibleStatus ssse
	CROSS JOIN #TitleISchoolSupplementalServicesReceivedStatus sssr
	CROSS JOIN #TitleISchoolwideProgramParticipation swp
	CROSS JOIN #TitleITargetedAssistanceParticipation tap
	LEFT JOIN rds.DimTitleIStatuses main
		ON tic.TitleIIndicatorCode = main.TitleIIndicatorCode
		AND scat.SchoolChoiceAppliedforTransferStatusCode = main.SchoolChoiceAppliedforTransferStatusCode
		AND scet.SchoolChoiceEligibleforTransferStatusCode = main.SchoolChoiceEligibleforTransferStatusCode
		AND sct.SchoolChoiceTransferStatusCode = main.SchoolChoiceTransferStatusCode
		AND sssa.TitleISchoolSupplementalServicesAppliedStatusCode = main.TitleISchoolSupplementalServicesAppliedStatusCode
		AND ssse.TitleISchoolSupplementalServicesEligibleStatusCode = main.TitleISchoolSupplementalServicesEligibleStatusCode
		AND sssr.TitleISchoolSupplementalServicesReceivedStatusCode = main.TitleISchoolSupplementalServicesReceivedStatusCode
		AND swp.TitleISchoolwideProgramParticipationCode = main.TitleISchoolwideProgramParticipationCode
		AND tap.TitleITargetedAssistanceParticipationCode = main.TitleITargetedAssistanceParticipationCode
	WHERE main.DimTitleIStatusId IS NULL

	DROP TABLE #TitleIIndicator
	DROP TABLE #SchoolChoiceAppliedforTransferStatus
	DROP TABLE #SchoolChoiceEligibleforTransferStatus
	DROP TABLE #SchoolChoiceTransferStatus
	DROP TABLE #TitleISchoolSupplementalServicesAppliedStatus
	DROP TABLE #TitleISchoolSupplementalServicesEligibleStatus
	DROP TABLE #TitleISchoolSupplementalServicesReceivedStatus
	DROP TABLE #TitleISchoolwideProgramParticipation
	DROP TABLE #TitleITargetedAssistanceParticipation


	-----------------------------------------------------
	-- Populate DimOrganizationTitleIStatuses
	-----------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimOrganizationTitleIStatuses d WHERE d.DimOrganizationTitleIStatusId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimOrganizationTitleIStatuses ON

		INSERT INTO [RDS].[DimOrganizationTitleIStatuses] (
			[DimOrganizationTitleIStatusId],
			[TitleIInstructionalServicesCode],
			[TitleIInstructionalServicesDescription],
			[TitleIInstructionalServicesEdFactsCode],
			[TitleIProgramTypeCode],
			[TitleIProgramTypeDescription],
			[TitleIProgramTypeEdFactsCode],
			[TitleISchoolStatusCode],
			[TitleISchoolStatusDescription],
			[TitleISchoolStatusEdFactsCode],
			[TitleISupportServicesCode],
			[TitleISupportServicesDescription],
			[TitleISupportServicesEdFactsCode]
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
		)

		SET IDENTITY_INSERT RDS.DimOrganizationTitleIStatuses OFF

	END

		CREATE TABLE #TitleIInstructionalServices (TitleIInstructionalServicesCode VARCHAR(50), TitleIInstructionalServicesDescription VARCHAR(100), TitleIInstructionalServicesEdFactsCode VARCHAR(50))

		INSERT INTO #TitleIInstructionalServices VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleIInstructionalServices 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, 'MISSING'
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleIInstructionalServices'


		CREATE TABLE #TitleIProgramType (TitleIProgramTypeCode VARCHAR(50), TitleIProgramTypeDescription VARCHAR(100), TitleIProgramTypeEdFactsCode VARCHAR(50))

		INSERT INTO #TitleIProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleIProgramType
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, 'MISSING'
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleIProgramType'

		CREATE TABLE #TitleISchoolStatus (TitleISchoolStatusCode VARCHAR(50), TitleISchoolStatusDescription VARCHAR(100), TitleISchoolStatusEdFactsCode VARCHAR(50))

		INSERT INTO #TitleISchoolStatus VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleISchoolStatus
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, CedsOptionSetCode
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISchoolStatus'

		CREATE TABLE #TitleISupportServices (TitleISupportServicesCode VARCHAR(50), TitleISupportServicesDescription VARCHAR(100), TitleISupportServicesEdFactsCode VARCHAR(50))

		INSERT INTO #TitleISupportServices VALUES ('MISSING', 'MISSING', 'MISSING')
		INSERT INTO #TitleISupportServices 
		SELECT 
			  CedsOptionSetCode
			, CedsOptionSetDescription
			, 'MISSING'
--		FROM [CEDS-Elements-V11.0.0.0].[CEDS].CedsOptionSetMapping
		FROM [CEDS].CedsOptionSetMapping
		WHERE CedsElementTechnicalName = 'TitleISupportServices'

	INSERT INTO [RDS].[DimOrganizationTitleIStatuses] (
			[TitleIInstructionalServicesCode]
			, [TitleIInstructionalServicesDescription]
			, [TitleIInstructionalServicesEdFactsCode]
			, [TitleIProgramTypeCode]
			, [TitleIProgramTypeDescription]
			, [TitleIProgramTypeEdFactsCode]
			, [TitleISchoolStatusCode]
			, [TitleISchoolStatusDescription]
			, [TitleISchoolStatusEdFactsCode]
			, [TitleISupportServicesCode]
			, [TitleISupportServicesDescription]
			, [TitleISupportServicesEdFactsCode]
		)
	SELECT 
			tis.[TitleIInstructionalServicesCode]
			, tis.[TitleIInstructionalServicesDescription]
			, tis.[TitleIInstructionalServicesEdFactsCode]
			, tipt.[TitleIProgramTypeCode]
			, tipt.[TitleIProgramTypeDescription]
			, tipt.[TitleIProgramTypeEdFactsCode]
			, tss.[TitleISchoolStatusCode]
			, tss.[TitleISchoolStatusDescription]
			, tss.[TitleISchoolStatusEdFactsCode]
			, tsps.[TitleISupportServicesCode]
			, tsps.[TitleISupportServicesDescription]
			, tsps.[TitleISupportServicesEdFactsCode]
	FROM #TitleIInstructionalServices tis
	CROSS JOIN #TitleIProgramType tipt
	CROSS JOIN #TitleISchoolStatus tss
	CROSS JOIN #TitleISupportServices tsps
	LEFT JOIN rds.DimOrganizationTitleIStatuses main
		ON tis.TitleIInstructionalServicesCode = main.TitleIInstructionalServicesCode
		AND tipt.TitleIProgramTypeCode = main.TitleIProgramTypeCode
		AND tss.TitleISchoolStatusCode = main.TitleISchoolStatusCode
		AND tsps.TitleISupportServicesCode = main.TitleISupportServicesCode
	WHERE main.DimOrganizationTitleIStatusId IS NULL

	DROP TABLE #TitleIInstructionalServices
	DROP TABLE #TitleIProgramType
	DROP TABLE #TitleISchoolStatus
	DROP TABLE #TitleISupportServices