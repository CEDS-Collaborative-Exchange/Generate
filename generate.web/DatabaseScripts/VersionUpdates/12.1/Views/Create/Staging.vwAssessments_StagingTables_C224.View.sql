CREATE VIEW staging.vwAssessments_StagingTables_C224
	
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
	   SELECT DISTINCT ta.[Subject] AS AssessmentAcademicSubject
		   ,ProficiencyStatus = CASE WHEN CAST(RIGHT(replace(sar.[Assessment-AssessmentPerformanceLevelIdentifier], '_1', ''),1) AS INT) < ta.ProficientOrAboveLevel THEN 'NOTPROFICIENT' ELSE 'PROFICIENT' END
		   ,sar.schoolyear
            FROM [Debug].[vwNeglectedOrDelinquent_StagingTables] vw
            INNER JOIN[debug].[vwAssessments_StagingTables] sar
                  ON vw.StudentIdentifierState = sar.StudentIdentifierState
                  AND sar.LeaIdentifierSeaAccountability = isnull(vw.LeaIdentifierSeaAccountability,'')
                  AND sar.SchoolIdentifierSea = isnull(vw.SchoolIdentifierSea, '')
                  AND vw.ProgramParticipationBeginDate <= sar.[Assessment-AssessmentAdministrationFinishDate]
                  AND isnull(vw.ProgramParticipationEndDate, '1900-01-01') >= sar.[Assessment-AssessmentAdministrationStartDate]
          JOIN Staging.SourceSystemReferenceData sssrd
				ON sssrd.SchoolYear = vw.SchoolYear
				AND sssrd.TableName = 'refNeglectedOrDelinquentProgramEnrollmentSubpart'
				AND sssrd.InputCode = vw.NeglectedOrDelinquentProgramEnrollmentSubpart                
		LEFT JOIN excludedLeas el
			ON sar.LEAIdentifierSeaAccountability = el.LeaIdentifierSea
		INNER JOIN ToggleAssessments ta
			ON replace(sar.[Assessment-AssessmentTypeAdministered], '_1', '') = replace(ta.AssessmentTypeCode, '_1', '')
			AND replace(sar.[Results-GradeLevelWhenAssessed], '_1', '') = replace(ta.Grade, '_1', '') 
			AND	replace(sar.[Assessment-AssessmentAcademicSubject], '_1', '') = replace(ta.AssessmentAcademicSubject, '_1', '')	
		WHERE
		el.LeaIdentifierSea IS NULL	
		AND vw.NeglectedOrDelinquentStatus = 1 -- Only students marked as NorD
		AND sssrd.OutputCode = 1 -- Subpart 1 only (SEA)
		AND vw.ProgramParticipationBeginDate >= CAST(('7/1/' + CAST((vw.SchoolYear -1) as varchar))  AS Date)
		AND CAST(ISNULL(vw.ProgramParticipationEndDate, '1900-01-01') AS DATE) <= CAST(('6/30/' + CAST(vw.SchoolYear as varchar))  AS Date)
	
