CREATE VIEW rds.vwDimMilitaryStatuses 
AS
	SELECT
		rdms.DimMilitaryStatusId
		, rsy.SchoolYear
		, rdms.MilitaryConnectedStudentIndicatorCode
		, ISNULL(sssrd1.InputCode, 'MISSING') AS MilitaryConnectedStudentIndicatorMap
		, rdms.MilitaryActiveStudentIndicatorCode
		, ISNULL(sssrd2.InputCode, 'MISSING') AS MilitaryActiveStudentIndicatorMap
		, rdms.MilitaryBranchCode
		, ISNULL(sssrd3.InputCode, 'MISSING') AS MilitaryBranchMap
		, rdms.MilitaryVeteranStudentIndicatorCode
		, ISNULL(sssrd4.InputCode, 'MISSING') AS MilitaryVeteranStudentIndicatorMap
	FROM rds.DimMilitaryStatuses rdms
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdms.MilitaryConnectedStudentIndicatorCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefMilitaryConnectedStudentIndicator'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdms.MilitaryActiveStudentIndicatorCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefMilitaryActiveStudentIndicator'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdms.MilitaryBranchCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefMilitaryBranch'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdms.MilitaryVeteranStudentIndicatorCode = sssrd4.OutputCode
		AND sssrd3.TableName = 'RefMilitaryVeteranStudentIndicator'
		AND rsy.SchoolYear = sssrd4.SchoolYear