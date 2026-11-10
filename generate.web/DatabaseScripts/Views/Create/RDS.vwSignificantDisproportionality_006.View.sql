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
Aggregate006
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
Flattened006
AS
	(
		SELECT		rc006.K12StudentId
					,rc006.PrimaryDisabilityTypeId					
					,rc006.SchoolYearId
					,rc006.LeaId
					,rc006.RaceId
					,rc006.LeaIdentifierSea
					,rc006.LeaIdentifierNces
					,rc006.IdeaStatusId
					,rc006.GradeLevelId
					,rc006.AgeId
					
					,SUM(CASE WHEN REMOVALLENGTH ='LTOREQ10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'INSCHOOL' THEN 1 ELSE 0 END) AS INSCHOOL_LTOREQ10
					,SUM(CASE WHEN REMOVALLENGTH ='GREATER10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'INSCHOOL' THEN 1 ELSE 0 END) AS INSCHOOL_GREATER10
					,SUM(CASE WHEN REMOVALLENGTH ='LTOREQ10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'OUTOFSCHOOL' THEN 1 ELSE 0 END) AS OUTOFSCHOOL_LTOREQ10
					,SUM(CASE WHEN REMOVALLENGTH ='GREATER10' AND DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode = 'OUTOFSCHOOL' THEN 1 ELSE 0 END) AS OUTOFSCHOOL_GREATER10
					
		FROM		Aggregate006 AS rc006
		WHERE DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> 'Missing'
		GROUP BY	rc006.SchoolYearId, rc006.K12StudentId, rc006.LeaId, rc006.RaceId, rc006.PrimaryDisabilityTypeId,rc006.SchoolYearId,rc006.LeaIdentifierSea ,rc006.LeaIdentifierNces,rc006.IdeaStatusId,rc006.GradeLevelId
					,rc006.AgeId
	),
Student006
AS 
	(
		SELECT		rc006.K12StudentId
					,rc006.PrimaryDisabilityTypeId					
					,rc006.SchoolYearId
					,rc006.LeaId
					,rc006.RaceId
					,rc006.LeaIdentifierSea
					,rc006.LeaIdentifierNces
					,rc006.IdeaStatusId
					,rc006.GradeLevelId
					,rc006.AgeId
					,rc006.INSCHOOL_LTOREQ10
					,rc006.INSCHOOL_GREATER10
					,rc006.OUTOFSCHOOL_LTOREQ10
					,rc006.OUTOFSCHOOL_GREATER10
		FROM		Flattened006 AS rc006
	)

	SELECT		*
	FROM		Student006			AS rc006