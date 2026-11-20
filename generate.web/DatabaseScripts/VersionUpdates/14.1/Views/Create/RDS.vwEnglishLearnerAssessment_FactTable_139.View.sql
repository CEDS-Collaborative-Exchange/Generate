CREATE VIEW [RDS].[vwEnglishLearnerAssessment_FactTable_139] 
AS
    SELECT  f.[FactK12StudentAssessmentId]
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
            , f.[AssessmentAcademicSubjectCode]
            , CASE f.[AssessmentAcademicSubjectEdFactsCode]
                WHEN 'Math' THEN 'M'
                ELSE f.[AssessmentAcademicSubjectEdFactsCode]
            END AS AssessmentAcademicSubjectEdFactsCode
    FROM  [debug].[vwEnglishLearnerAssessment_FactTable] f
    JOIN [rds].[DimLeas] rdl
        ON f.[DimLeaId] = rdl.[DimLeaId]
    WHERE f.[AssessmentAcademicSubjectCode] IN ('01166', '13373')
        AND f.[AssessmentRegistrationParticipationIndicatorCode] = 'Participated'
        AND rdl.[LeaOperationalStatus] NOT IN ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
