CREATE VIEW [RDS].[vwChronicAbsenteeism_FactTable_195] 
AS
    SELECT  f.[FactK12StudentCountId]
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
			-- 14.1: FS195 breaks out by 7 dimensions; RDS.Insert_CountsIntoReportTable joins the
			-- report's permitted values on cs.<Dimension>EdFactsCode, so surface each here (was Msg 207).
			, f.[EconomicDisadvantageStatusEdFactsCode]
			, f.[EnglishLearnerStatusEdFactsCode]
			, f.[HomelessnessStatusEdFactsCode]
			, f.[IdeaIndicatorEdFactsCode]
			, f.[RaceEdFactsCode]
			-- 14.1: FS195 DISABSTATUS504 expects 'DISAB504STAT' (dim code is SECTION504/NONSECTION504);
			-- mirrors RDS.Get_CountSQL's per-report translation, ported to the new view-based path.
			, CASE WHEN f.[Section504StatusEdFactsCode] = 'SECTION504' THEN 'DISAB504STAT'
				ELSE 'MISSING' END AS [Section504StatusEdFactsCode]
			, f.[SexEdFactsCode]
	FROM [debug].[vwChronicAbsenteeism_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New')
