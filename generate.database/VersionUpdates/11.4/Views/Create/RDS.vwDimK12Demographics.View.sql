create VIEW RDS.vwDimK12Demographics 
AS
	SELECT
		  DimK12DemographicId
		, rsy.SchoolYear
		, SexCode
		, sssrd1.InputCode AS SexMap
	FROM rds.DimK12Demographics rdkd
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkd.SexCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear
		AND sssrd1.TableName = 'RefSex'
