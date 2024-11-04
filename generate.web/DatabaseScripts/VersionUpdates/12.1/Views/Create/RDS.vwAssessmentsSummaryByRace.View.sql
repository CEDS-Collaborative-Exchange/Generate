CREATE VIEW RDS.vwAssessmentsSummaryByRace
  AS 
  
    SELECT 
        f.SchoolYearId
      , CASE WHEN SUM(f.K12StudentId) > 10 THEN SUM(f.K12StudentId) ELSE 0 END as StudentCount
      , f.SeaId
      , f.LeaId
	  , ISNULL(lea.LeaIdentifierSea, 'MISSING') as LeaIdentifierSea
	  , ISNULL(lea.LeaOrganizationName, 'MISSING') as LeaOrganizationName
      , f.K12SchoolId
      , race.RaceId
    FROM rds.FactK12StudentAssessments f
	inner join rds.DimLeas lea on f.LeaId = lea.DimLeaID
	inner join rds.DimK12Schools sch on f.K12SchoolId = sch.DimK12SchoolId
	left join (select distinct FactK12StudentAssessmentId, RaceId from rds.BridgeK12StudentAssessmentRaces) race on f.FactK12StudentAssessmentId = race.FactK12StudentAssessmentId
	where f.AssessmentCount > 0
	group by f.SchoolYearId, f.SeaId, f.LeaId, lea.LeaIdentifierSea, lea.LeaOrganizationName, f.K12SchoolId, race.RaceId