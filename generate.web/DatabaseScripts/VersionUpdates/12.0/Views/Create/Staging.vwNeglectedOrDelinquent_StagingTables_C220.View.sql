CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_C220] 
AS
	WITH excludedLeas AS (
		SELECT DISTINCT LEAIdentifierSea
		FROM Staging.K12Organization sko
			LEFT JOIN Staging.SourceSystemReferenceData sssrd
				ON sko.SchoolYear = sssrd.SchoolYear
				AND sko.LEA_OperationalStatus = sssrd.InputCode
				AND sssrd.Tablename = 'RefOperationalStatus'
				AND sssrd.TableFilter = '000174'
		WHERE LEA_IsReportedFederally = 0
			OR sssrd.OutputCode in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
	)


SELECT  DISTINCT
		vw.StudentIdentifierState
		,lea.SeaOrganizationIdentifierSea
		,NeglectedOrDelinquentProgramEnrollmentSubpart
		,vw.NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode
		,vw.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType EdFactsAcademicOrCareerAndTechnicalOutcomeExitType_Staging
		,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode as EdFactsAcademicOrCareerAndTechnicalOutcomeExitType	
	FROM [Debug].[vwNeglectedOrDelinquent_StagingTables] vw
	JOIN [RDS].[DimLeas] lea on lea.LeaIdentifierSea = vw.LEAIdentifierSeaAccountability
	LEFT JOIN excludedLeas el
		ON vw.LEAIdentifierSeaAccountability = el.LeaIdentifierSea
	WHERE el.LeaIdentifierSea IS NULL
		AND vw.NeglectedOrDelinquentStatus = 1 -- Only students marked as NorD
		AND vw.NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode = 1
		AND vw.ProgramParticipationBeginDate >= CAST(('7/1/' + CAST((vw.SchoolYear -1) as varchar))  AS Date)
		AND CAST(ISNULL(vw.ProgramParticipationEndDate, '1900-01-01') AS DATE) <= CAST(('6/30/' + CAST(vw.SchoolYear as varchar))  AS Date)
		AND vw.ProgramParticipationBeginDate BETWEEN vw.EnrollmentEntryDate AND ISNULL(vw.EnrollmentExitDate, CAST(('6/30/' + CAST(vw.SchoolYear as varchar))  AS Date))


