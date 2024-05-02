CREATE VIEW [Staging].[vwNeglectedOrDelinquent_StagingTable_C220] 
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
		,vw.NeglectedOrDelinquentAcademicAchievementIndicator
		,EdFactsAcademicOrCareerAndTechnicalOutcomeType	
	FROM [Debug].[vwNeglectedOrDelinquent_StagingTables] vw
	JOIN [RDS].[DimLeas] lea on lea.LeaIdentifierSea = vw.LeaIdentifierSeaAccountability
	LEFT JOIN excludedLeas el
		ON vw.LEAIdentifierSeaAccountability = el.LeaIdentifierSea
	WHERE el.LeaIdentifierSea IS NULL
		AND ISNULL(NeglectedOrDelinquentAcademicAchievementIndicator, '') <> ''
		AND 
		(
			(
				vw.ProgramParticipationBeginDate >= CAST(('7/1/' + CAST((vw.SchoolYear -1) as varchar))  AS Date)
				AND CAST(ISNULL(vw.ProgramParticipationEndDate, '1900-01-01') AS DATE) <= CAST(('6/30/' + CAST(vw.SchoolYear as varchar))  AS Date)
			) -- Received Title I, Part D, Subpart 1 services
			OR (
				 vw.NeglectedOrDelinquentExitOutcomeDate
					BETWEEN CAST(('7/1/' + CAST((vw.SchoolYear -1) as varchar))  AS Date) AND CAST(('6/30/' + CAST(vw.SchoolYear as varchar))  AS Date)
			) -- Exited the program
			OR (
				vw.DiplomaCredentialAwardDate
					BETWEEN vw.NeglectedOrDelinquentExitOutcomeDate AND DATEADD (DAY, 90, vw.NeglectedOrDelinquentExitOutcomeDate)
			) -- Earned an academic or career and technical outcome up to 90 calendar days after exiting from the program
		)
	GROUP BY
		 vw.StudentIdentifierState
		,lea.SeaOrganizationIdentifierSea
		,EdFactsAcademicOrCareerAndTechnicalOutcomeType
		,vw.NeglectedOrDelinquentAcademicAchievementIndicator
GO


