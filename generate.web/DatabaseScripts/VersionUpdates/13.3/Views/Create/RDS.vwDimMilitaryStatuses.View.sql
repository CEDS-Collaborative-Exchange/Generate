CREATE VIEW RDS.vwDimMilitaryStatuses 
AS
	SELECT
		  rdms.DimMilitaryStatusId
		, rsy.SchoolYear
		, rdms.MilitaryConnectedStudentIndicatorCode
		, sssrd1.InputCode AS MilitaryConnectedStudentIndicatorMap
		, rdms.ActiveMilitaryStatusIndicatorCode
		, sssrd2.InputCode AS ActiveMilitaryStatusIndicatorMap
		, rdms.MilitaryBranchCode
		, sssrd3.InputCode AS MilitaryBranchMap
		, rdms.MilitaryVeteranStatusIndicatorCode
		, sssrd4.InputCode AS MilitaryVeteranStatusIndicatorMap
	FROM rds.DimMilitaryStatuses rdms
	CROSS JOIN (select sy.SchoolYear
    			from rds.DimSchoolYearDataMigrationTypes dm
	    			inner join rds.dimschoolyears sy
			    		on dm.dimschoolyearid = sy.dimschoolyearid
			    where IsSelected = 1
			    and dm.DataMigrationTypeId = 3
			) AS rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdms.MilitaryConnectedStudentIndicatorCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefMilitaryConnectedStudentIndicator'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd2
		ON rdms.ActiveMilitaryStatusIndicatorCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefActiveMilitaryStatusIndicator'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd3
		ON rdms.MilitaryBranchCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefMilitaryBranch'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN Staging.SourceSystemReferenceData sssrd4
		ON rdms.MilitaryVeteranStatusIndicatorCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefMilitaryVeteranStatusIndicator'
		AND rsy.SchoolYear = sssrd4.SchoolYear