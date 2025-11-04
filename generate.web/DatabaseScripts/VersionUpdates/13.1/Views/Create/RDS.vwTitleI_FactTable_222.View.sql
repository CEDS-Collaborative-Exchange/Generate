CREATE VIEW [RDS].[vwTitleI_FactTable_222] 
AS
	SELECT 	a.[FactK12StudentCountId]
			, a.[SchoolYear]
		  	, a.[K12StudentId]
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
	WHERE ProgramParticipationFosterCareEdFactsCode = 'FOSTERCARE' 
		AND LeaOperationalStatus IN ('Open','New') 
		AND TitleIProgramTypeCode in ('LocalNeglectedProgram','PrivateSchoolStudents','SchoolwideProgram','TargetedAssistanceProgram')
		--AND TitleISchoolStatusEdFactsCode in ('TGELGBTGPROG', 'SWELIGTGPROG', 'SWELIGSWPROG')
