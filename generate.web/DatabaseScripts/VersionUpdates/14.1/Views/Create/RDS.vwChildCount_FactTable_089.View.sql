CREATE VIEW [RDS].[vwChildCount_FactTable_089] 
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
		, K12Student_CurrentId
		, K12StudentStudentIdentifierState
		, IdeaDisabilityTypeEdFactsCode
		, RaceEdFactsCode
		, SexEdFactsCode
		, AgeEdFactsCode
		, IdeaEducationalEnvironmentForSchoolAgeEdFactsCode
		-- 14.1: FS089 (ages 3-5, Part B 619) breaks out by the EARLY CHILDHOOD environment
		, IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, 1 AS StudentCount
	FROM Debug.vwChildCount_FactTable vw
	WHERE AgeEdFactsCode IN ('3', '4', '5')
		AND (CASE 
				WHEN AgeEdFactsCode = '5' AND GradeLevelEdFactsCode in ('MISSING','PK') THEN 1
				ELSE 0
			END) = 1
