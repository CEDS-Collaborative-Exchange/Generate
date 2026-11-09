CREATE VIEW [RDS].[vwSignificantDisproportionality_ChildCount] AS

--================================================================================================
-- Child Count
--================================================================================================

with ChildCount_Fact AS (
SELECT		Fact.K12StudentId
			,Fact.FactK12StudentCountId
			,Fact.PrimaryDisabilityTypeId 
			,Fact.SchoolYearId
			,Fact.RaceId
			,Fact.IdeaStatusId
			,Fact.GradeLevelId
			,Fact.AgeId			
			, LEAs.LeaIdentifierSea
			, LEAs.DimLeaID AS LeaId
			, LEAs.SeaOrganizationIdentifierSea AS SeaId
			, LEAs.LeaIdentifierNces
			, schools.DimK12SchoolId AS K12SchoolId
			--, Schools.NameOfInstitution
			, SchoolYears.SchoolYear
			, Ages.AgeEdFactsCode
			--, Races.RaceEdFactsCode
			, Grades.GradeLevelEdFactsCode
			----Primary Disability
			, IDEADisability.IdeaDisabilityTypeEdFactsCode
		
 	FROM		RDS.FactK12StudentCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears			ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
	LEFT JOIN	RDS.DimPeople						Students			ON Fact.K12StudentId			= Students.DimPersonId			AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimLeas							LEAs				ON Fact.LeaId					= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools				ON Fact.K12SchoolId				= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimIdeaStatuses					IDEAStatus			ON Fact.IdeaStatusId			= IDEAStatus.DimIdeaStatusId
    LEFT JOIN   RDS.DimIdeaDisabilityTypes         	IDEADisability  	ON Fact.PrimaryDisabilityTypeId = IDEADisability.DimIdeaDisabilityTypeId
	LEFT JOIN	RDS.DimK12Demographics				Demo				ON Fact.K12DemographicId		= Demo.DimK12DemographicId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses		EL					ON Fact.EnglishLearnerStatusId	= EL.DimEnglishLearnerStatusId
	LEFT JOIN	RDS.DimAges							Ages				ON Fact.AgeId					= Ages.DimAgeId      
	LEFT JOIN	RDS.DimRaces						Races				ON Fact.RaceId					= Races.DimRaceId
	LEFT JOIN	RDS.DimGradeLevels					Grades				ON Fact.GradeLevelId			= Grades.DimGradeLevelId
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
		--AND SchoolYears.SchoolYear = 2023
		AND Fact.FactTypeId = 3),


FactType_ChildCount_002 AS (SELECT
		FactK12StudentCountId
		,PrimaryDisabilityTypeID
		,cte.K12StudentId
		,SchoolYearId
		,LeaId
		,RaceId	
		,LeaIdentifierSea
		,LeaIdentifierNces
		,IdeaStatusId
		,GradeLevelId
		,AgeId
		,1 AS ChildCountStudentCount
	FROM ChildCount_Fact cte
	LEFT JOIN (
		select distinct K12StudentId
		FROM ChildCount_Fact fact
		WHERE NOT AgeEdFactsCode in (	
							select replace(ResponseValue, ' Years', '') AS Ages
							from app.ToggleResponses r
							inner join app.ToggleQuestions q 
							on r.ToggleQuestionId = q.ToggleQuestionId 
							where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
							UNION
							select 'AGE05K'
							from app.ToggleResponses r
							inner join app.ToggleQuestions q 
							on r.ToggleQuestionId = q.ToggleQuestionId 
							where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
								AND ResponseValue LIKE '%5%'
							UNION
							select 'AGE05NOTK'
							from app.ToggleResponses r
							inner join app.ToggleQuestions q 
							on r.ToggleQuestionId = q.ToggleQuestionId 
							where q.EmapsQuestionAbbrv = 'CHDCTAGEDD'
								AND ResponseValue LIKE '%5%'
						) 
		AND  IdeaDisabilityTypeEdFactsCode = 'DD'
	) dd
		ON cte.K12StudentId = dd.K12StudentId
	WHERE AgeEdFactsCode IN ('5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21')
		AND (CASE 
				WHEN AgeEdFactsCode = '5' AND GradeLevelEdFactsCode in ('MISSING','PK') THEN 0
				ELSE 1
			END) = 1
		--AND dd.K12StudentId IS NULL
			)

	SELECT *  from FactType_ChildCount_002