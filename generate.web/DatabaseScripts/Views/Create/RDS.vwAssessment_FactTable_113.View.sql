CREATE VIEW [RDS].[vwAssessment_FactTable_113] 
AS
    SELECT  f.[FactK12StudentAssessmentId]
			, f.[SchoolYear]
		  	, f.[K12StudentId]
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
            , ata.[ProficientOrAboveLevel]
            , ata.[PerformanceLevels]
            , RIGHT(f.[AssessmentPerformanceLevelLabel], 1) AS AssessmentPerformanceLevelLabel
            , CASE
                WHEN ata.[ProficientOrAboveLevel] <= RIGHT(f.[AssessmentPerformanceLevelLabel], 1) THEN 'PROFICIENT'
                ELSE 'NOTPROFICIENT'
            END AS ProficiencyStatusEdFactsCode
    FROM  [debug].[vwAssessment_FactTable] f
    JOIN [rds].[DimLeas] rdl
        ON f.[DimLeaId] = rdl.[DimLeaId]
    JOIN  [App].[ToggleAssessments] ata
        ON f.[AssessmentAcademicSubjectEdFactsCode] = ata.Subject
        AND f.[AssessmentTitle] = ata.AssessmentName
        AND f.[AssessmentTypeAdministeredCode] = ata.AssessmentTypeCode
        AND f.[GradeLevelEdFactsCode] = ata.Grade
    WHERE f.[AssessmentAcademicSubjectCode] IN ('01166', '13373')
		AND f.[NeglectedOrDelinquentStatusCode] = 'Yes'
	    AND f.[NeglectedOrDelinquentProgramEnrollmentSubpartCode] = '1'
        AND f.[AssessmentRegistrationParticipationIndicatorCode] = 'Participated'
        AND f.[AssessmentRegistrationReasonNotCompletingCode] = 'MISSING'
        AND f.[AssessmentPerformanceLevelLabel] IS NOT NULL
        AND rdl.[LeaOperationalStatus] NOT IN ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
