CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTables_C218] 
AS
	WITH excludedLeas AS (
		SELECT DISTINCT LEAIdentifierSea
		FROM Staging.K12Organization
		WHERE LEA_IsReportedFederally = 0
			OR LEA_OperationalStatus in ('Closed', 'FutureAgency', 'Inactive', 'MISSING', 'Closed_1', 'FutureAgency_1', 'Inactive_1')
	)

	SELECT  DISTINCT
		vw.StudentIdentifierState
		,lea.SeaOrganizationIdentifierSea
		,NeglectedOrDelinquentProgramEnrollmentSubpart
		,vw.NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode
		,vw.EdFactsAcademicOrCareerAndTechnicalOutcomeType EdFactsAcademicOrCareerAndTechnicalOutcomeType_Staging
		,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode as EdFactsAcademicOrCareerAndTechnicalOutcomeType	
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
