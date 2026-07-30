CREATE VIEW [RDS].[vwHomeless_FactTable_194] 
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
			-- 14.1: FS194 breaks out by Age; RDS.Insert_CountsIntoReportTable joins the report's
			-- permitted Age values on cs.AgeEdFactsCode, so the report fact view must surface it
			-- (mirrors how the FS218 view surfaces EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode).
			, f.[AgeEdFactsCode]
	FROM [debug].[vwHomeless_FactTable] f
	WHERE SchoolOperationalStatus IN ('Open','New') 
		AND HomelessServicedIndicatorCode = 'Yes'