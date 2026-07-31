CREATE VIEW [RDS].[vwMigrantEducationProgram_FactTable_121] 
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
			-- 14.1: FS121 dims GradeLevel/Race/MigrantPrioritizedForServices/EnglishLearnerStatus/IdeaIndicator/ConsolidatedMepFundsStatus/MobilityStatus12MO
			, f.[GradeLevelEdFactsCode]
			, f.[RaceEdFactsCode]
			, f.[MigrantPrioritizedForServicesEdFactsCode]
			, f.[EnglishLearnerStatusEdFactsCode]
			, f.[IdeaIndicatorEdFactsCode]
			, f.[ConsolidatedMEPFundsStatusEdFactsCode] AS ConsolidatedMepFundsStatusEdFactsCode
			-- MobilityStatus12MO has no source column in the fact (proc sets the mobility dates to -1); constant MISSING
			, CAST('MISSING' AS VARCHAR(50)) AS MobilityStatus12MOEdFactsCode
	FROM [debug].[vwMigrantEducationProgram_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New')
