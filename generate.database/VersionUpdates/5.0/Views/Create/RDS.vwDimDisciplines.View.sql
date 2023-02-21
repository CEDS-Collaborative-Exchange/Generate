create VIEW RDS.vwDimDisciplines 
AS
	SELECT
		  DimDisciplineId
		, rsy.SchoolYear
		, DisciplinaryActionTakenCode
		, sssrd1.InputCode AS DisciplinaryActionTakenMap
		, DisciplineMethodOfChildrenWithDisabilitiesCode
		, sssrd2.InputCode AS DisciplineMethodOfChildrenWithDisabilitiesMap
		, EducationalServicesAfterRemovalCode
		, CASE EducationalServicesAfterRemovalCode
			WHEN 'SERVPROV' THEN 1 
			WHEN 'SERVNOTPROV' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS EducationalServicesAfterRemovalMap
		, IdeaInterimRemovalReasonCode
		, CASE IdeaInterimRemovalReasonCode
			WHEN 'SBI' THEN 'SeriousBodilyInjury' 
			WHEN 'W' THEN 'Weapons'
			WHEN 'D' THEN 'Drugs'
			WHEN 'MISSING' THEN NULL
		END AS IdeaInterimRemovalReasonMap
		, IdeaInterimRemovalCode
		, sssrd3.InputCode AS IdeaInterimRemovalMap
		, DisciplineELStatusCode
		, CASE DisciplineELStatusCode
			WHEN 'LEP' THEN 1 
			WHEN 'NLEP' THEN 0
			WHEN 'MISSING' THEN NULL
		  END AS DisciplineELStatusMap
	FROM rds.DimDisciplines rdd
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdd.DisciplinaryActionTakenCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefDisciplinaryActionTaken'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdd.DisciplineMethodOfChildrenWithDisabilitiesCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefDisciplineMethodOfCwd'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdd.IdeaInterimRemovalCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefIdeaInterimRemoval'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdd.IdeaInterimRemovalReasonCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefIDEAInterimRemovalReason'
		AND rsy.SchoolYear = sssrd4.SchoolYear
