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
			, f.[DisciplinaryActionTakenEdFactsCode]
			, f.[IdeaInterimRemovalReasonEdFactsCode]
			, f.[IdeaInterimRemovalEdFactsCode]
			, f.[DurationOfDisciplinaryAction]
	FROM [debug].[vwDiscipline_FactTable] f
	WHERE IdeaIndicatorEdFactsCode = 'IDEA'
			AND AgeValue >= 3
			AND AgeValue <= 21
			AND 
			(DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> 'MISSING'
			OR DisciplinaryActionTakenEdFactsCode IN ('03086', '03087')
			OR IdeaInterimRemovalReasonEdFactsCode <> 'MISSING'
			OR IdeaInterimRemovalEdFactsCode <> 'MISSING'
			)
			AND IdeaEducationalEnvironmentForSchoolAgeEDFactsCode <> 'PPPS'
			AND SchoolOperationalStatus IN ('Open','New') 
			