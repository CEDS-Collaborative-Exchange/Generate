CREATE VIEW [RDS].[vwTitleI_FactTable_134] 
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
			-- 14.1: FS134 breaks out by Grade Level and Title I Indicator; surface each dimension's
			-- EdFacts code for RDS.Insert_CountsIntoReportTable's permitted-value join (was Msg 207).
			, f.[GradeLevelEdFactsCode]
			, f.[TitleIIndicatorEdFactsCode]
	FROM [debug].[vwTitleI_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New')
