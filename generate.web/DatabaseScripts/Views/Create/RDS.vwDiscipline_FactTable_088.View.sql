CREATE VIEW [RDS].[vwDiscipline_FactTable_088] 
AS
	SELECT 	f.[FactK12StudentDisciplineId]
			, f.[SchoolYear]
		  	, f.[K12StudentId]
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
			, f.[DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode]
			, f.[DurationOfDisciplinaryAction]
	FROM [debug].[vwDiscipline_FactTable] f
	WHERE IdeaInterimRemovalEdFactsCode NOT IN ('REMDW','REMHO')
		AND SchoolOperationalStatus IN ('Open','New') 
		AND IdeaEducationalEnvironmentForSchoolAgeEDFactsCode <> 'PPPS'