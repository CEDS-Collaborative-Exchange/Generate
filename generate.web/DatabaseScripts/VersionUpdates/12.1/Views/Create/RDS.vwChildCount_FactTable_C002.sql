CREATE VIEW [RDS].[vwChildCount_FactTable_C002] 
AS
	SELECT
		  SchoolYear
		, SeaId
		, LeaId
		, K12SchoolId
		, StateANSICode
		, StateAbbreviationCode
		, StateAbbreviationDescription
		, SeaOrganizationIdentifierSea
		, SeaOrganizationName
		, LeaIdentifierSea
		, LeaOrganizationName
		, SchoolIdentifierSea
		, NameOfInstitution
		, vw.K12StudentId
		, K12StudentStudentIdentifierState
		, IdeaDisabilityTypeEdFactsCode
		, RaceEdFactsCode
		, SexEdFactsCode
		, AgeEdFactsCode
		, IdeaEducationalEnvironmentForSchoolAgeEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, 1 AS StudentCount
	FROM Debug.vwChildCount_FactTable vw
	LEFT JOIN (
		select distinct K12StudentId
		from [Debug].[vwChildCount_FactTable] fact
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
		ON vw.K12StudentId = dd.K12StudentId
	WHERE AgeEdFactsCode IN ('5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21')
		AND (CASE 
				WHEN AgeEdFactsCode = '5' AND GradeLevelEdFactsCode in ('MISSING','PK') THEN 0
				ELSE 1
			END) = 1
		AND dd.K12StudentId IS NULL