CREATE VIEW RDS.vwDimDisciplineStatuses 
AS
	SELECT
		DimDisciplineStatusId
		, rsy.SchoolYear
		, rdds.DisciplinaryActionTakenCode
		, sssrd1.InputCode AS DisciplinaryActionTakenMap
		, DisciplineMethodOfChildrenWithDisabilitiesCode
		, sssrd2.InputCode AS DisciplineMethodOfChildrenWithDisabilitiesMap
		, EducationalServicesAfterRemovalCode
		, CASE EducationalServicesAfterRemovalCode
			WHEN 'YES' THEN 1
			WHEN 'NO' THEN 0
			END AS EducationalServicesAfterRemovalMap
		, IdeaInterimRemovalCode
		, sssrd3.InputCode AS IdeaInterimRemovalMap
		, IdeaInterimRemovalReasonCode
		, sssrd4.InputCode AS IdeaInterimRemovalReasonMap
	FROM rds.DimDisciplineStatuses rdds
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdds.DisciplinaryActionTakenCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefDisciplinaryActionTaken'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdds.DisciplineMethodOfChildrenWithDisabilitiesCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefDisciplineMethodOfCwd'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdds.IdeaInterimRemovalCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefIdeaInterimRemoval'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdds.IdeaInterimRemovalReasonCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefIdeaInterimRemovalReason'
		AND rsy.SchoolYear = sssrd4.SchoolYear
