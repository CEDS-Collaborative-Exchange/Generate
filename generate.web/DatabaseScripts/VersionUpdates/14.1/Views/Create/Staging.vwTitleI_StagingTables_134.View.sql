CREATE VIEW [Staging].[vwTitleI_StagingTables_134]
AS
	-- FS134 - Title I participation, broken out by Grade Level and Title I Indicator.
	-- Mirrors RDS.vwTitleI_FactTable_134: Title I program participants at operational (Open/New) schools.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, dgl.GradeLevelEdFactsCode								AS GradeLevel
		, dt1.TitleIIndicatorEdFactsCode						AS TitleIIndicator

	FROM [debug].[vwTitleI_StagingTables]					s

	-- Grade (Entry, LEFT + -1)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- Title I Indicator (combined dim; other title-I sub-statuses = MISSING, per the fact proc)
	LEFT JOIN RDS.vwDimTitleIStatuses						rdt1s
		ON		rdt1s.SchoolYear = s.SchoolYear
		AND		ISNULL(s.TitleIIndicator, 'MISSING') = ISNULL(rdt1s.TitleIIndicatorMap, rdt1s.TitleIIndicatorCode)
		AND		rdt1s.SchoolChoiceAppliedforTransferStatusCode = 'MISSING'
		AND		rdt1s.SchoolChoiceEligibleforTransferStatusCode = 'MISSING'
		AND		rdt1s.SchoolChoiceTransferStatusCode = 'MISSING'
		AND		rdt1s.TitleISchoolSupplementalServicesAppliedStatusCode = 'MISSING'
		AND		rdt1s.TitleISchoolSupplementalServicesEligibleStatusCode = 'MISSING'
	JOIN RDS.DimTitleIStatuses								dt1
		ON		dt1.DimTitleIStatusId = ISNULL(rdt1s.DimTitleIStatusId, -1)

	-- school operational status Open/New (the only filter the FS134 fact view adds)
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus IN ('Open','New')
