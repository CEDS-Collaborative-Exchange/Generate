CREATE VIEW [RDS].[vwDiscipline_FactTable_005]
AS
	SELECT 	f.[FactK12StudentDisciplineId]
			, f.[SchoolYear]
		  	, f.[K12Student_CurrentId]
		  	, f.[K12StudentStudentIdentifierState]
		  	, f.[BirthDate]
		  	, f.[FirstName]
		  	, f.[LastOrSurname]
		  	, f.[MiddleName]
		  	, f.[StateANSICode]
		  	, f.[StateAbbreviationCode]
		  	, f.[StateAbbreviationDescription]
		  	, f.[SeaOrganizationIdentifierSea]
		  	, f.[SeaOrganizationName]
		  	, f.[LeaIdentifierSea]
		  	, f.[LeaOrganizationName]
		  	, f.[SchoolIdentifierSea]
		  	, f.[DimK12SchoolId]
		  	, f.[NameOfInstitution]
		  	, f.[SchoolOperationalStatus]
		  	, f.[SchoolTypeCode]
			, f.[IdeaDisabilityTypeEdFactsCode]
			, f.[RaceEdFactsCode]
			, f.[SexEdFactsCode]
			, f.[EnglishLearnerStatusEdFactsCode]
			, f.[IdeaInterimRemovalEdFactsCode]
	FROM [debug].[vwDiscipline_FactTable] f
	WHERE 	IdeaIndicatorEdFactsCode = 'WDIS'
			AND AgeValue >= 3
			AND AgeValue <= 21
			AND IdeaInterimRemovalEdFactsCode in ('REMDW','REMHO')
			AND IdeaEducationalEnvironmentForSchoolAgeEDFactsCode <> 'PPPS'
			AND SchoolOperationalStatus IN ('Open','New')
