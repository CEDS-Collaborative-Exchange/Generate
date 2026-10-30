CREATE VIEW [RDS].[vwDiscipline_FactTable_088]
AS
	WITH Removals AS (
		SELECT 	f.*
			-- Cumulative days removed for the school year, summed within the LEA
			, SUM(ISNULL(f.DurationOfDisciplinaryAction, 0)) OVER (PARTITION BY f.SchoolYear, f.K12StudentStudentIdentifierState, f.LeaIdentifierSea) AS TotalDaysRemoved
		FROM [debug].[vwDiscipline_FactTable] f
		WHERE IdeaIndicatorEdFactsCode = 'WDIS'
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
			, r.[DisciplinaryActionTakenEdFactsCode]
			, r.[IdeaInterimRemovalReasonEdFactsCode]
			, r.[IdeaInterimRemovalEdFactsCode]
			, r.[DurationOfDisciplinaryAction]
			-- Removal length buckets match the legacy Get_CountSQL REMOVALLENIDEA branch
			, CASE
				WHEN r.TotalDaysRemoved < 1.5 THEN 'LTOREQ1'
				WHEN r.TotalDaysRemoved <= 10.0 THEN '2TO10'
				ELSE 'GREATER10'
			  END AS RemovalLengthEdFactsCode
	FROM Removals r
	-- Only children removed for at least half a day in total are reported (legacy #Students HAVING clause)
	WHERE r.TotalDaysRemoved >= 0.5
