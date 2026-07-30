CREATE VIEW [RDS].[vwHomeless_FactTable_118] 
AS
	SELECT 	f.[FactK12StudentCountId]
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
			-- 14.1: FS118 breaks out by 7 dimensions; surface each dimension's EdFacts code for
			-- RDS.Insert_CountsIntoReportTable's permitted-value join.
			, f.[EnglishLearnerStatusEdFactsCode]
			, f.[GradeLevelEdFactsCode]
			, f.[HomelessPrimaryNighttimeResidenceEdFactsCode]
			, f.[HomelessUnaccompaniedYouthStatusEdFactsCode]
			, f.[IdeaIndicatorEdFactsCode]
			, f.[MigrantStatusEdFactsCode]
			, f.[RaceEdFactsCode]
	FROM [debug].[vwHomeless_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New')
		AND HomelessnessStatusEdFactsCode = 'HOMELSENRL'