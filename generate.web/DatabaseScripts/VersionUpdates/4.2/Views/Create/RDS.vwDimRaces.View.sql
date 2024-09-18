CREATE VIEW [RDS].[vwDimRaces]
AS
	SELECT
		  DimRaceId
		, rsy.SchoolYear
		, RaceCode
		, ISNULL(case when RaceCode = 'HispanicorLatinoEthnicity' then 'HispanicorLatinoEthnicity' else sssrd.InputCode end, 'MISSING') as RaceMap
	FROM rds.DimRaces rdr
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	left JOIN staging.SourceSystemReferenceData sssrd
		ON rdr.RaceCode = sssrd.OutputCode
		AND sssrd.TableName = 'refRace'
		AND rsy.SchoolYear = sssrd.SchoolYear