CREATE VIEW [RDS].[vwDiscipline_FactTable_006]
AS
	WITH Removals AS (
		SELECT 	f.*
		FROM [debug].[vwDiscipline_FactTable] f
		WHERE IdeaIndicatorEdFactsCode = 'WDIS'
				AND AgeValue >= 3
				AND AgeValue <= 21
				AND IdeaInterimRemovalEdFactsCode NOT IN ('REMDW','REMHO')
				AND (DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode <> 'MISSING'
					OR DisciplinaryActionTakenEdFactsCode IN ('03086','03087'))
				AND IdeaEducationalEnvironmentForSchoolAgeEDFactsCode <> 'PPPS'
				AND SchoolOperationalStatus IN ('Open','New')
	)
	SELECT 	r.[FactK12StudentDisciplineId]
			, r.[SchoolYear]
		  	, r.[K12Student_CurrentId]
		  	, r.[K12StudentStudentIdentifierState]
		  	, r.[BirthDate]
		  	, r.[FirstName]
		  	, r.[LastOrSurname]
		  	, r.[MiddleName]
		  	, r.[StateANSICode]
		  	, r.[StateAbbreviationCode]
		  	, r.[StateAbbreviationDescription]
		  	, r.[SeaOrganizationIdentifierSea]
		  	, r.[SeaOrganizationName]
		  	, r.[LeaIdentifierSea]
		  	, r.[LeaOrganizationName]
		  	, r.[SchoolIdentifierSea]
		  	, r.[DimK12SchoolId]
		  	, r.[NameOfInstitution]
		  	, r.[SchoolOperationalStatus]
		  	, r.[SchoolTypeCode]
			, r.[IdeaDisabilityTypeEdFactsCode]
			, r.[RaceEdFactsCode]
			, r.[SexEdFactsCode]
			, r.[EnglishLearnerStatusEdFactsCode]
			, r.[DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode]
			, r.[DurationOfDisciplinaryAction]
			-- Removal length is the child's cumulative days of removal for the school year by discipline method,
			-- summed within the LEA (matches the legacy Get_CountSQL REMOVALLENSUS buckets)
			, CASE
				WHEN SUM(ISNULL(r.DurationOfDisciplinaryAction, 0)) OVER (PARTITION BY r.SchoolYear, r.K12StudentStudentIdentifierState, r.LeaIdentifierSea, r.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode) < 0.5 THEN 'MISSING'
				WHEN SUM(ISNULL(r.DurationOfDisciplinaryAction, 0)) OVER (PARTITION BY r.SchoolYear, r.K12StudentStudentIdentifierState, r.LeaIdentifierSea, r.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode) <= 10.0 THEN 'LTOREQ10'
				ELSE 'GREATER10'
			  END AS RemovalLengthEdFactsCode
	FROM Removals r
