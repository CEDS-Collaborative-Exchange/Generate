CREATE VIEW [RDS].[vwSignificantDisproportionality_006] AS

--================================================================================================
-- Discipline
--================================================================================================
WITH
DisciplineFilteredFactData 
AS
	(
		SELECT		 Fact.K12StudentId
					,Fact.PrimaryDisabilityTypeId 
					,Fact.SchoolYearId
					,rdp.K12StudentStudentIdentifierState 
					,Schools.SchoolIdentifierSea 
					,Fact.LeaId
					,Fact.RaceId
					,LEAs.LeaIdentifierSea 
					,LEAs.LeaIdentifierNces
					,Fact.IdeaStatusId					
					,Fact.GradeLevelId
					,Fact.AgeId
					,rdds.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode
					,rdds.DisciplinaryActionTakenEdFactsCode
					,rdds.IdeaInterimRemovalEdFactsCode
					,rdds.IdeaInterimRemovalReasonEdFactsCode
					,rdds.EducationalServicesAfterRemovalEdFactsCode
					,Fact.DurationOfDisciplinaryAction 
					,Fact.DisciplineCount
					,1 AS DisciplineStudentCount
					,SeaId
		FROM   		RDS.FactK12StudentDisciplines	Fact
		JOIN		RDS.DimSchoolYears				SchoolYears		ON Fact.SchoolYearId		= SchoolYears.DimSchoolYearId	
		LEFT JOIN  rds.DimPeople					rdp				on fact.K12StudentId		= rdp.DimPersonId
		LEFT JOIN  RDS.DimLeas                     LEAs            ON Fact.LeaId               = LEAs.DimLeaId
		LEFT JOIN  RDS.DimK12Schools               Schools         ON Fact.K12SchoolId         = Schools.DimK12SchoolId
		LEFT JOIN  RDS.DimIdeaStatuses				rdis 			ON fact.IdeaStatusId		= rdis.DimIdeaStatusId
		LEFT JOIN   RDS.DimAges                     Ages            ON Fact.AgeId               = Ages.DimAgeId      
		LEFT JOIN   RDS.DimRaces                    Races           ON Fact.RaceId              = Races.DimRaceId
		LEFT JOIN  RDS.DimIdeaDisabilityTypes		IDEADisability  ON Fact.PrimaryDisabilityTypeId = IDEADisability.DimIdeaDisabilityTypeId
		LEFT JOIN rds.DimDisciplineStatuses		rdds 			ON fact.DisciplineStatusId = rdds.DimDisciplineStatusId
		WHERE 1 = 1		
		--AND Fact.SeaId <> -1
		--AND Fact.LeaId <> -1
		AND Fact.K12SchoolId <> -1 
		AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS' --**
		AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode  <> 'PPPS'
		AND rdis.IdeaIndicatorEdFactsCode = 'IDEA'
		AND rdds.IdeaInterimRemovalEDFactsCode NOT IN ('REMDW', 'REMHO')
		AND Races.RaceEdFactsCode <> 'MISSING'
		AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21
	),
AggregateC006
AS
	(
		SELECT		 fact.K12StudentId
					,fact.PrimaryDisabilityTypeId					
					,fact.SchoolYearId
					,fact.LeaId
					,fact.RaceId
					,fact.LeaIdentifierSea
					,fact.LeaIdentifierNces
					,fact.IdeaStatusId
					,fact.GradeLevelId
					,fact.AgeId
					,fact.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode 
					,case 
								when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) < 0.5 then 'MISSING'
								when sum(isnull(fact.DurationOfDisciplinaryAction, 0)) <= 10.0 then 'LTOREQ10'
								else 'GREATER10'
							end AS REMOVALLENGTH
					
		FROM		DisciplineFilteredFactData AS fact		
		GROUP BY	fact.SchoolYearID, fact.LeaId, fact.K12StudentId, fact.RaceId, fact.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode, fact.PrimaryDisabilityTypeId, fact.LeaIdentifierSea, fact.LeaIdentifierNces,fact.IdeaStatusId ,fact.GradeLevelId ,fact.AgeId
		HAVING 		SUM(fact.DurationOfDisciplinaryAction) >= 0.5 
		
	),
FlattenedC006
AS
	(
		SELECT		c006.K12StudentId
					,c006.PrimaryDisabilityTypeId					
					,c006.SchoolYearId
					,c006.LeaId
					,c006.RaceId
					,c006.LeaIdentifierSea
					,c006.LeaIdentifierNces
					,c006.IdeaStatusId
					,c006.GradeLevelId
					,c006.AgeId
					
					,SUM(CASE WHEN REMOVALLENGTH ='LTOREQ10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'INSCHOOL' THEN 1 ELSE 0 END) AS INSCHOOL_LTOREQ10
					,SUM(CASE WHEN REMOVALLENGTH ='GREATER10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'INSCHOOL' THEN 1 ELSE 0 END) AS INSCHOOL_GREATER10
					,SUM(CASE WHEN REMOVALLENGTH ='LTOREQ10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'OUTOFSCHOOL' THEN 1 ELSE 0 END) AS OUTOFSCHOOL_LTOREQ10
					,SUM(CASE WHEN REMOVALLENGTH ='GREATER10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'OUTOFSCHOOL' THEN 1 ELSE 0 END) AS OUTOFSCHOOL_GREATER10
					
		FROM		AggregateC006 AS c006
		WHERE DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> 'Missing'
		GROUP BY	c006.SchoolYearId, c006.K12StudentId, c006.LeaId, c006.RaceId, c006.PrimaryDisabilityTypeId,c006.SchoolYearId,c006.LeaIdentifierSea ,c006.LeaIdentifierNces,c006.IdeaStatusId,c006.GradeLevelId
					,c006.AgeId
	),
StudentC006
AS 
	(
		SELECT		c006.K12StudentId
					,c006.PrimaryDisabilityTypeId					
					,c006.SchoolYearId
					,c006.LeaId
					,c006.RaceId
					,c006.LeaIdentifierSea
					,c006.LeaIdentifierNces
					,c006.IdeaStatusId
					,c006.GradeLevelId
					,c006.AgeId
					,c006.INSCHOOL_LTOREQ10
					,c006.INSCHOOL_GREATER10
					,c006.OUTOFSCHOOL_LTOREQ10
					,c006.OUTOFSCHOOL_GREATER10
		FROM		FlattenedC006 AS c006
	)

	SELECT		*
	FROM		StudentC006			AS c006
GO