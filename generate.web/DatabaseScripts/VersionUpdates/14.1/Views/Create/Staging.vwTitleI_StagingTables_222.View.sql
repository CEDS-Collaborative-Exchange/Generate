CREATE VIEW [Staging].[vwTitleI_StagingTables_222]
AS
	-- FS222 - Foster Care Enrolled (DG893).
	-- Expected-side population for RunEndToEndTest: students in foster care enrolled in an
	-- open, federally-reported public LEA. Per SY2025-26 spec + review, the count is NOT
	-- restricted by school Title I status / program type (foster requirements apply even to
	-- non-Title-I-served students), so the shared debug.vwTitleI_StagingTables school-status
	-- filter is intentionally not used.
	--
	-- This view deliberately mirrors the join + date logic of the Title I fact migration
	-- (Staging.[Staging-to-FactK12StudentCounts_TitleI]) so the expected population exactly
	-- matches the fact table: the Title I-participation and foster-care date-overlap windows,
	-- the inner DimAges join (age as-of @TitleIDate = '2023-09-01', matching the proc), and
	-- LEA open/reported-federally. @SYEndDate is reproduced via staging.GetFiscalYearEndDate().
	-- The spec's "LEA receives Title I, Part A funds" (CFDA 84.010) refinement is a documented
	-- later warehouse item (see docs/edfacts-migration/FS222-FosterCareEnrolled.md).
	SELECT DISTINCT
		  ske.StudentIdentifierState
		, ske.LEAIdentifierSeaAccountability
		, ske.SchoolIdentifierSea

	FROM Staging.K12Enrollment								ske
	JOIN Staging.K12Organization							sko
		ON		ISNULL(ske.LeaIdentifierSeaAccountability, '')	=	ISNULL(sko.LeaIdentifierSea, '')
		AND		ISNULL(ske.SchoolIdentifierSea, '')				=	ISNULL(sko.SchoolIdentifierSea, '')
		AND		ske.SchoolYear									=	sko.SchoolYear

	-- Title I participation (date-overlap window mirrors the fact migration)
	JOIN Staging.ProgramParticipationTitleI					title1
		ON		ske.SchoolYear									=	title1.SchoolYear
		AND		ske.StudentIdentifierState						=	title1.StudentIdentifierState
		AND		ISNULL(ske.LeaIdentifierSeaAccountability, '')	=	ISNULL(title1.LeaIdentifierSeaAccountability, '')
		AND		ISNULL(ske.SchoolIdentifierSea, '')				=	ISNULL(title1.SchoolIdentifierSea, '')
		AND		((title1.ProgramParticipationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear)))
				OR (title1.ProgramParticipationStartDate < ske.EnrollmentEntryDate AND ISNULL(title1.ProgramParticipationExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear)) = staging.GetFiscalYearEndDate(ske.SchoolYear)))

	-- Age must resolve to a DimAges value (as-of @TitleIDate, matching the fact migration)
	JOIN RDS.DimAges										rda
		ON		RDS.Get_Age(ske.Birthdate, '2023-09-01')		=	rda.AgeValue

	-- Foster care membership (the population being counted; date-overlap mirrors the fact migration)
	JOIN Staging.PersonStatus								foster
		ON		ske.SchoolYear									=	foster.SchoolYear
		AND		ske.StudentIdentifierState						=	foster.StudentIdentifierState
		AND		ISNULL(ske.LeaIdentifierSeaAccountability, '')	=	ISNULL(foster.LeaIdentifierSeaAccountability, '')
		AND		ISNULL(ske.SchoolIdentifierSea, '')				=	ISNULL(foster.SchoolIdentifierSea, '')
		AND		((foster.FosterCare_ProgramParticipationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear)))
				OR (foster.FosterCare_ProgramParticipationStartDate < ske.EnrollmentEntryDate AND ISNULL(foster.FosterCare_ProgramParticipationExitDate, staging.GetFiscalYearEndDate(ske.SchoolYear)) = staging.GetFiscalYearEndDate(ske.SchoolYear)))
		AND		foster.ProgramType_FosterCare = 1

	-- LEA must be open/new and reported federally
	JOIN Staging.K12Organization							lea
		ON		lea.LeaIdentifierSea							=	ske.LEAIdentifierSeaAccountability
		AND		lea.SchoolYear									=	ske.SchoolYear
		AND		lea.Lea_OperationalStatus IN ('Open','New')
		AND		ISNULL(lea.Lea_IsReportedFederally, 0) <> 0
