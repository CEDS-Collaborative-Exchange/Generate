CREATE PROCEDURE [RDS].[Migrate_DimK12Schoolstatuses_School]
	@OrganizationDates AS [RDS].[SchoolDateTableType] READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	DECLARE @sharedTimeStatusId AS INT
	SELECT @sharedTimeStatusId = RefOrganizationIndicatorId FROM dbo.RefOrganizationIndicator WHERE Code = 'SharedTime'

	SELECT    org.DimSchoolYearId
			, org.DimSchoolId 
			, NULL AS SchoolOrganizationId
			, nslp.Code AS NSLPStatusCode
			, mag.Code AS MagnetStatusCode
			, vsq.Code AS VirtualStatusCode
			, latest.SharedTimeIndicator AS SharedTimeStatusCode
			, CASE WHEN isq.Code = 'CorrectiveAction' THEN 'CORRACT' 
				 WHEN isq.Code = 'Year1' THEN 'IMPYR1' 
				 WHEN isq.Code = 'Year2' THEN 'IMPYR2' 
				 WHEN isq.Code = 'Planning' THEN 'RESTRPLAN' 
				 WHEN isq.Code = 'Restructuring' THEN 'RESTR' 
				 WHEN isq.Code = 'NA' THEN 'NA'
				 WHEN isq.Code = 'FS' THEN 'FOCUS'
				 WHEN isq.Code = 'PS' THEN 'PRIORITY'
				 WHEN isq.Code = 'NFPS' THEN 'NOTPRFOC'        			
				 ELSE ISNULL(isq.Code,'MISSING')
			  END AS ImprovementStatusCode
			, sdq.Code AS DangerousStatusCode
			, CASE WHEN spd.Code = 'HighQuartile' THEN 'HIGH' 
				 WHEN spd.Code = 'LowQuartile' THEN 'LOW' 
				 WHEN spd.Code = 'Neither' THEN 'NEITHER'     			
				 ELSE ISNULL(spd.Code,'MISSING')
			  END AS StatePovertyDesignationCode
			, pael.Code AS ProgressAchievingEnglishLanguageCode
			, latest.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus AS SchoolStateStatusCode
		FROM @OrganizationDates org
		JOIN (SELECT 
				  MAX(ds.DimK12SchoolId) AS DimK12SchoolId
				, MAX(schStatus.RefNSLPStatusId) AS RefNSLPStatusId
				, MAX(schStatus.RefMagnetSpecialProgramId) AS RefMagnetSpecialProgramId
				, MAX(ind.IndicatorValue) AS SharedTimeIndicator
				, MAX(schStatus.RefVirtualSchoolStatusId) AS RefVirtualSchoolStatusId
				, MAX(schStatus.RefSchoolImprovementStatusId) AS RefSchoolImprovementStatusId
				, MAX(schStatus.RefSchoolDangerousStatusId) AS RefSchoolDangerousStatusId
				, MAX(sch.RefStatePovertyDesignationId) AS RefStatePovertyDesignationId
				, MAX(schStatus.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId) AS RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId
				, MAX(schStatus.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus) AS ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus
			  FROM dbo.OrganizationIdentifier i
			  JOIN dbo.RefOrganizationIdentifierType roit 
				ON i.RefOrganizationIdentifierTypeId = roit.RefOrganizationIdentifierTypeId
		  		AND roit.Code = '001073'
			  JOIN dbo.RefOrganizationIdentificationSystem rois 
				ON i.RefOrganizationIdentificationSystemId = rois.RefOrganizationIdentificationSystemId
		  		AND rois.RefOrganizationIdentifierTypeId = roit.RefOrganizationIdentifierTypeId
			  JOIN RDS.DimK12Schools ds
				ON i.Identifier = ds.SchoolIdentifierState
			  JOIN @OrganizationDates orgDates
				ON ISNULL(i.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(i.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate
			  JOIN dbo.K12School sch 
				ON i.OrganizationId = sch.OrganizationId
				AND (@dataCollectionId IS NULL OR sch.DataCollectionId = @dataCollectionId)	
				AND ISNULL(sch.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(sch.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate
			  JOIN dbo.K12SchoolStatus schStatus 
				ON sch.K12SchoolId = schStatus.K12SchoolId
				AND (@dataCollectionId IS NULL OR schStatus.DataCollectionId = @dataCollectionId)	
				AND ISNULL(sch.RecordEndDateTime, GETDATE()) >= orgDates.SubmissionYearStartDate
				AND ISNULL(sch.RecordStartDateTime, '1/1/1900') <= orgDates.SubmissionYearEndDate 
			  JOIN dbo.OrganizationIndicator ind 
				ON i.OrganizationId = ind.OrganizationId
				AND (@dataCollectionId IS NULL OR ind.DataCollectionId = @dataCollectionId)	
				AND ind.RefOrganizationIndicatorId = @sharedTimeStatusId
			  WHERE (@dataCollectionId IS NULL OR i.DataCollectionId = @dataCollectionId)	
			  GROUP BY i.OrganizationId, i.RecordStartDateTime, sch.RecordStartDateTime
			  HAVING i.RecordStartDateTime = MAX(i.RecordStartDateTime)
				AND sch.RecordStartDateTime = MAX(sch.RecordStartDateTime)
			  ) latest ON latest.DimK12SchoolId = org.DimSchoolId
		LEFT JOIN dbo.RefMagnetSpecialProgram m 
			ON m.RefMagnetSpecialProgramId = latest.RefMagnetSpecialProgramId
		LEFT JOIN dbo.RefNSLPStatus nslp 
			ON nslp.RefNSLPStatusId = latest.RefNSLPStatusId
		LEFT JOIN dbo.RefMagnetSpecialProgram mag 
			ON mag.RefMagnetSpecialProgramId = latest.RefMagnetSpecialProgramId
		LEFT JOIN dbo.RefVirtualSchoolStatus vsq 
			ON vsq.RefVirtualSchoolStatusId = latest.RefVirtualSchoolStatusId
		LEFT JOIN dbo.RefSchoolImprovementStatus isq 
			ON isq.RefSchoolImprovementStatusId = latest.RefSchoolImprovementStatusId
		LEFT JOIN dbo.RefSchoolDangerousStatus sdq 
			ON sdq.RefSchoolDangerousStatusId = latest.RefSchoolDangerousStatusId
		LEFT JOIN dbo.RefStatePovertyDesignation spd 
			ON spd.RefStatePovertyDesignationId = latest.RefStatePovertyDesignationId
		LEFT JOIN dbo.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus pael 
			ON pael.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = latest.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId
END
