CREATE VIEW [RDS].[vwTitleI_FactTable_037] 
AS
	SELECT 	a.[FactK12StudentCountId]
			, a.[SchoolYear]
		  	, a.[K12Student_CurrentId]
		  	, a.[K12StudentStudentIdentifierState]
		  	, a.[BirthDate]
		  	, a.[FirstName]
		  	, a.[LastOrSurname]
		  	, a.[MiddleName]
		  	, a.[StateANSICode]
		  	, a.[StateAbbreviationCode]
		  	, a.[StateAbbreviationDescription]
		  	, a.[SeaOrganizationIdentifierSea]
		  	, a.[SeaOrganizationName]
		  	, a.[LeaIdentifierSea]
		  	, a.[LeaOrganizationName]
		  	, a.[SchoolIdentifierSea]
		  	, a.[DimK12SchoolId]
		  	, a.[NameOfInstitution]
		  	, a.[SchoolOperationalStatus]
		  	, a.[SchoolTypeCode]
			-- 14.1: FS037 breaks out by EL / Homelessness / IDEA Indicator / Migrant / Race
			, a.[EnglishLearnerStatusEdFactsCode]
			-- 14.1: FS037 homeless category 'HOMELESS' expects permitted value 'H' (not the dim's
			-- 'HOMELSENRL'). Mirrors RDS.Get_CountSQL's per-report translation (when homeless -> 'H',
			-- else keep the code). Ported to the new view-based path.
			, CASE WHEN a.[HomelessnessStatusEdFactsCode] = 'HOMELSENRL' THEN 'H'
				ELSE a.[HomelessnessStatusEdFactsCode] END			AS [HomelessnessStatusEdFactsCode]
			, a.[IdeaIndicatorEdFactsCode]
			, a.[MigrantStatusEdFactsCode]
			, a.[RaceEdFactsCode]
	FROM debug.[vwTitleI_FactTable] a
	WHERE SchoolOperationalStatus IN ('Open','New')
