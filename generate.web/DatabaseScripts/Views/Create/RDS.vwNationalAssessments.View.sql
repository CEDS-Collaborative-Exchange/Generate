CREATE VIEW RDS.vwNationalAssessments
  AS 
  
    SELECT 
        f.SchoolYearId
      , f.K12StudentId
      , f.SeaId
      , f.LeaId
	  , ISNULL(lea.LeaIdentifierSea, 'MISSING') as LeaIdentifierSea
	  , ISNULL(lea.LeaOrganizationName, 'MISSING') as LeaOrganizationName
      , f.K12SchoolId
	  , f.AssessmentId
	  , f.AssessmentRegistrationId
	  , f.AssessmentPerformanceLevelId
	  , f.FactK12StudentAssessmentAccommodationId
      , f.K12DemographicId
      , f.GradeLevelWhenAssessedId
      , f.IdeaStatusId
      , f.EconomicallyDisadvantagedStatusId
      , f.EnglishLearnerStatusId
      , f.FosterCareStatusId
      , f.HomelessnessStatusId
      , f.ImmigrantStatusId
      , f.MigrantStatusId
      , f.MilitaryStatusId
	  , race.RaceId
      , f.FactK12StudentAssessmentId
      , f.AssessmentCount
	  , f.AssessmentResultScoreValueRawScore
	  , ISNULL(proficiency.ProficiencyStatus, 'MISSING') as ProficiencyStatus
    FROM rds.FactK12StudentAssessments f
	inner join rds.DimLeas lea on f.LeaId = lea.DimLeaID
	inner join rds.DimK12Schools sch on f.K12SchoolId = sch.DimK12SchoolId
	left join (select distinct FactK12StudentAssessmentId, RaceId from rds.BridgeK12StudentAssessmentRaces) race on f.FactK12StudentAssessmentId = race.FactK12StudentAssessmentId
	left join rds.BridgeK12StudentAssessmentAccommodations accomodations on f.FactK12StudentAssessmentAccommodationId = accomodations.FactK12StudentAssessmentAccommodationId
	left join (
			select distinct  fact.K12StudentId,  fact.SchoolYearId,
			case 
				WHEN assmntPerfLevl.AssessmentPerformanceLevelIdentifier ='MISSING' THEN 'MISSING'
				when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) >= CAST( tgglAssmnt.ProficientOrAboveLevel as int) THEN  'PROFICIENT'		
				when CAST(SUBSTRING( assmntPerfLevl.AssessmentPerformanceLevelIdentifier, 2,1) as int ) < CAST( tgglAssmnt.ProficientOrAboveLevel as int)  THEN  'NOTPROFICIENT'
				else 'MISSING' 
			end as ProficiencyStatus
			from
			rds.FactK12StudentAssessments fact
			inner join RDS.DimAssessments assmnt on fact.AssessmentId = assmnt.DimAssessmentId 
			inner join RDS.DimGradeLevels grades on fact.GradeLevelWhenAssessedId = grades.DimGradeLevelId
			inner join RDS.DimAssessmentPerformanceLevels assmntPerfLevl on fact.AssessmentPerformanceLevelId = assmntPerfLevl.DimAssessmentPerformanceLevelId
			inner join APP.ToggleAssessments tgglAssmnt ON tgglAssmnt.Grade = grades.GradeLevelCode and tgglAssmnt.Subject = assmnt.AssessmentAcademicSubjectEdFactsCode	
														AND tgglAssmnt.AssessmentTypeCode = assmnt.AssessmentTypeAdministeredCode
	) proficiency on f.K12StudentId = proficiency.K12StudentId and f.SchoolYearId = proficiency.SchoolYearId
