CREATE VIEW [RDS].[vwDimCteStatuses] 
AS
	SELECT distinct
		  DimCteStatusId
		, rsy.SchoolYear
		, CteProgramCode
		, CASE CteProgramCode
			WHEN 'NONCTEPART' THEN 0 
			WHEN 'CTEPART' THEN 1
			WHEN 'CTECONC' THEN 2
			ELSE -1
		  END AS CteProgramMap
		, CteAeDisplacedHomemakerIndicatorCode
		, CASE CteAeDisplacedHomemakerIndicatorCode
			WHEN 'DH' THEN 1 
			ELSE -1
		  END AS CteAeDisplacedHomemakerIndicatorMap
		, CteNontraditionalGenderStatusCode 
		, CASE CteNontraditionalGenderStatusCode
			WHEN 'NTE' THEN 1 
			ELSE -1
		  END AS CteNontraditionalGenderStatusMap
		, RepresentationStatusCode
		, CASE RepresentationStatusCode
			WHEN 'NM' THEN 0
			WHEN 'MEM' THEN 1
			ELSE -1
		  END AS RepresentationStatusMap
		, SingleParentOrSinglePregnantWomanCode
		, CASE SingleParentOrSinglePregnantWomanCode
			WHEN 'SPPT' THEN 1 
			ELSE -1
		  END AS SingleParentOrSinglePregnantWomanMap
		, CteGraduationRateInclusionCode
		, CASE CteGraduationRateInclusionCode
			WHEN 'NOTG' THEN 0 
			WHEN 'GRAD' THEN 1
			ELSE -1
		  END AS CteGraduationRateInclusionMap
		, LepPerkinsStatusCode
		, CASE LepPerkinsStatusCode 
			WHEN 'LEPP' THEN 1 
			ELSE -1
		  END AS LepPerkinsStatusMap
	FROM rds.DimCteStatuses rdis
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
