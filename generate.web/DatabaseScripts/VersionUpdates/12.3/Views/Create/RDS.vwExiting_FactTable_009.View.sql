CREATE VIEW [RDS].[vwExiting_FactTable_009] 
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
		, SpecialEducationExitReasonEdFactsCode
		, RaceEdFactsCode
		, SexEdFactsCode
		, AgeEdFactsCode
		, EnglishLearnerStatusEdFactsCode
		, 1 AS StudentCount
	FROM Debug.vwExiting_FactTable vw
	WHERE AgeEdFactsCode IN ('14', '15', '16', '17', '18', '19', '20', '21')
