CREATE VIEW [RDS].[vwMembership_FactTable_052] 
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
			-- 14.1: FS052 breaks out by Grade Level, Race, and Sex. RDS.Insert_CountsIntoReportTable
			-- joins the report's permitted category values on cs.<Dimension>EdFactsCode, so the report
			-- fact view must surface each dimension's EdFacts code (previously omitted -> Msg 207).
			, f.[GradeLevelEdFactsCode]
			, f.[RaceEdFactsCode]
			, f.[SexEdFactsCode]
	FROM [debug].[vwMembership_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New')
