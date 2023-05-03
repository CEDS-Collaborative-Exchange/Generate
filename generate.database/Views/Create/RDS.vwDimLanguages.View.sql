CREATE VIEW [RDS].[vwDimLanguages]
AS
	SELECT
		  DimLanguageId
		, rsy.SchoolYear
		, Iso6392LanguageCode
		, sssrd.InputCode AS Iso6392LanguageMap
	FROM rds.DimLanguages rdl
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd
		ON rdl.Iso6392LanguageCode = sssrd.OutputCode
		AND sssrd.TableName = 'refLanguage'
		AND rsy.SchoolYear = sssrd.SchoolYear
