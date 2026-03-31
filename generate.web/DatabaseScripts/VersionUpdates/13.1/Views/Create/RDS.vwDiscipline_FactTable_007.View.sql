CREATE VIEW [RDS].[vwDiscipline_FactTable_007] 
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
			, f.[IdeaInterimRemovalEdFactsCode]
			, f.[IdeaInterimRemovalReasonEdFactsCode]
			, f.[DisciplineCount]
	FROM [debug].[vwDiscipline_FactTable] f
	WHERE IdeaIndicatorEdFactsCode = 'IDEA'
			AND AgeValue >= 3
			AND AgeValue <= 21
			AND IdeaInterimRemovalEdFactsCode = ('REMDW')
			AND IdeaInterimRemovalReasonEdFactsCode in ('D','W','SBI')
			AND IdeaEducationalEnvironmentForSchoolAgeEDFactsCode <> 'PPPS' 
			AND SchoolOperationalStatus IN ('Open','New')
