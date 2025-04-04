CREATE VIEW [RDS].[vwDimPsDemographics] 
AS
	SELECT
		  DimPsDemographicId
		, rsy.SchoolYear
		, SexCode
		, sssrd1.InputCode AS SexMap
	FROM rds.DimPsDemographics rdkd
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkd.SexCode = sssrd1.OutputCode
		AND rsy.SchoolYear = sssrd1.SchoolYear
		AND sssrd1.TableName = 'RefSex'
