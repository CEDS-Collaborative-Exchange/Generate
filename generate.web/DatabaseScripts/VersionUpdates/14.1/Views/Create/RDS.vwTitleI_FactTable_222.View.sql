CREATE VIEW [RDS].[vwTitleI_FactTable_222] 
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
		  	, a.[ProgramParticipationFosterCareEdFactsCode]
	FROM [debug].[vwTitleI_FactTable] a
	-- FS222 - Foster Care Enrolled (DG893): students in foster care enrolled in an open,
	-- federally-reported public LEA. Per SY2025-26 spec + review, the count is NOT restricted
	-- by school Title I status or program type, so the former TitleIProgramTypeCode filter is
	-- removed. ("LEA receives Title I, Part A funds" (CFDA 84.010) refinement is a documented
	-- later warehouse item - see docs/edfacts-migration/FS222-FosterCareEnrolled.md.)
	WHERE ProgramParticipationFosterCareEdFactsCode = 'FOSTERCARE'
		AND LeaOperationalStatus IN ('Open','New')
		AND LeaReportedFederally <> 0
