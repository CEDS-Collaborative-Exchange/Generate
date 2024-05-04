CREATE VIEW staging.vwAssessment_StagingTables_C224
	
	AS
	-- PerformanceLevels requires DimAssessmentPerformanceLevels, SourceSystemReferenceData table AssessmentPerformanceLevelMap, and ToggleAssessments
	WITH excludedLeas AS (
        SELECT DISTINCT LEAIdentifierSea
        FROM Staging.K12Organization
        WHERE LEA_IsReportedFederally = 0
            OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING', 'Closed_1', 'FutureAgency_1', 'Inactive_1')
    )
	
	,ToggleAssessments AS (
	SELECT ta.*
		,CASE [Subject]
			WHEN 'MATH' THEN '01166_1'
			WHEN 'RLA' THEN '13373_1'
			WHEN 'SCIENCE' THEN '00562_1'
			WHEN 'CTE' THEN '73065_1'
			WHEN 'MATH' THEN '01166'
			WHEN 'RLA' THEN '13373'
			WHEN 'SCIENCE' THEN '00562'
			WHEN 'CTE' THEN '73065'
			ELSE 'MISSING'
		END AS AssessmentAcademicSubject
	FROM App.ToggleAssessments ta
	WHERE [Subject] in ('MATH', 'RLA')	
	)
	
	-- NorDStudents with Assessments
	SELECT DISTINCT 
		  CASE ta.[Subject]
		  	WHEN 'Math' THEN 'M'
			ELSE ta.Subject
		  END AS AssessmentAcademicSubject
		, sar.LeaIdentifierSeaAccountability
		, ProficiencyStatus = CASE WHEN CAST(RIGHT(replace(sar.[Assessment-AssessmentPerformanceLevelIdentifier], '_1', ''),1) AS INT) < ta.ProficientOrAboveLevel THEN 'NOTPROFICIENT' ELSE 'PROFICIENT' END
		, sar.schoolyear
	FROM [debug].[vwAssessment_StagingTables] sar
	JOIN Staging.SourceSystemReferenceData sssrd
		ON sssrd.SchoolYear = sar.SchoolYear
		AND sssrd.TableName = 'refNeglectedOrDelinquentProgramEnrollmentSubpart'
		AND sssrd.InputCode = sar.NeglectedOrDelinquentProgramEnrollmentSubpart
	LEFT JOIN excludedLeas el
		ON sar.LEAIdentifierSeaAccountability = el.LeaIdentifierSea
	JOIN ToggleAssessments ta
		ON replace(sar.[Assessment-AssessmentTypeAdministered], '_1', '') = replace(ta.AssessmentTypeCode, '_1', '')
		AND replace(sar.[Results-GradeLevelWhenAssessed], '_1', '') = replace(ta.Grade, '_1', '') 
		AND	replace(sar.[Assessment-AssessmentAcademicSubject], '_1', '') = replace(ta.AssessmentAcademicSubject, '_1', '')	
	WHERE
		    el.LeaIdentifierSea IS NULL	
		AND sar.NeglectedOrDelinquentStatus = 1 -- Only students marked as NorD
		AND sssrd.OutputCode = 1 -- Subpart 1 only (SEA)
		AND sar.NorDProgramParticipationBeginDate <= CAST(('6/30/' + CAST((sar.SchoolYear) as varchar))  AS Date)
		AND CAST(ISNULL(sar.NorDProgramParticipationEndDate, '9999-01-01') AS DATE) >= CAST(('7/1/' + CAST(sar.SchoolYear - 1 as varchar))  AS Date)
	
