CREATE VIEW [RDS].[vwDimProgramStatuses] 
AS
	SELECT DISTINCT
		  DimProgramStatusId
		, rsy.SchoolYear
		, EligibilityStatusForSchoolFoodServiceProgramCode
		, sssrd1.InputCode AS EligibilityStatusForSchoolFoodServiceProgramMap
		, FosterCareProgramCode
		, CASE FosterCareProgramCode
			WHEN 'FOSTERCARE' THEN 1 
			WHEN 'NOTFOSTERCARE' THEN 0
			ELSE -1
		  END AS FosterCareProgramMap
		, TitleIIIImmigrantParticipationStatusCode
		, CASE TitleIIIImmigrantParticipationStatusCode
			WHEN 'IMMIGNTTTLIII' THEN 1 
			WHEN 'NONIMMIGNTTTLIII' THEN 0
			ELSE -1
		  END AS TitleIIIImmigrantParticipationStatusMap
		, Section504StatusCode
		, CASE Section504StatusCode
			WHEN 'SECTION504' THEN 1 
			WHEN 'NONSECTION504' THEN 0
			ELSE -1
		  END AS Section504StatusMap
		, TitleiiiProgramParticipationCode
		, CASE TitleiiiProgramParticipationCode
			WHEN 'PART' THEN 1 
			ELSE -1
		  END AS TitleiiiProgramParticipationMap
		, HomelessServicedIndicatorCode
		, CASE HomelessServicedIndicatorCode 
			WHEN 'YES' THEN 1 
			ELSE -1
		  END AS HomelessServicedIndicatorMap
	FROM rds.DimProgramStatuses rdps
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdps.EligibilityStatusForSchoolFoodServiceProgramCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefFoodServiceEligibility'
		AND rsy.SchoolYear = sssrd1.SchoolYear
