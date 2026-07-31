CREATE VIEW [debug].[vwTitleIIIELSY_StagingTables]
AS
	-- Expected-side base for the Title III EL School-Year fact type (FactTypeId 10; files 045, 116).
	-- REWRITTEN to mirror the population of Staging.[Staging-to-FactK12StudentCounts_TitleIIIELSY]
	-- exactly (target = 199 distinct students for 2027, == RDS.vwTitleIIIELSY_FactTable_116).
	--
	-- Key fixes vs the prior deployed version (which returned only 29 students):
	--   * REMOVED the over-restrictive  titleIII.EnglishLearnerParticipation = 1  filter — the fact
	--     proc does NOT filter on EnglishLearnerParticipation (it INNER-joins ProgramParticipationTitleIII
	--     with only a fiscal-year date window). That filter alone dropped ~170 students.
	--   * Aligned the EL and Title III date windows to the proc's fiscal-year window
	--     (ISNULL(start,@SYStart) <= @SYEnd AND ISNULL(exit,@SYEnd) >= @SYStart) instead of the prior
	--     enrollment-span windows, and added the SchoolYear join predicate the proc uses.
	--   * Exposed the raw source columns the report dimensions need:
	--       - GradeLevel, HispanicLatinoEthnicity                       (Grade + Race dims, file 116)
	--       - EnglishLearnerStatus                                      (EL Status dim, file 045)
	--       - ISO_639_2_NativeLanguage                                  (ISO6392LanguageCode dim, file 045)
	--       - TitleIIILanguageInstructionProgramType (RAW, not the SSRD OutputCode) + the 3 other
	--         Title III status keys the proc joins on (TitleIIIImmigrantStatus, Proficiency_TitleIII,
	--         TitleIIIAccountabilityProgressStatus)                     (LIEP-type dim, file 116)
	--       - TitleIIIImmigrantStatus + TitleIIIImmigrantParticipationStatus (Immigrant dim, file 045)
	--   * Dropped the K12PersonRace join — race is unduplicated via RDS.vwUnduplicatedRaceMap in the
	--     expected view, so the base does not need (and must not multiply on) K12PersonRace rows.
	--
	-- Fiscal-year window: for SchoolYear >= 2023 the proc uses the full fiscal year
	-- (staging.GetFiscalYearStartDate / GetFiscalYearEndDate). @SchoolYear is the RDS-selected year.
	SELECT DISTINCT
		  enrollment.SchoolYear
		, enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.GradeLevel
		, enrollment.BirthDate
		, enrollment.HispanicLatinoEthnicity

		, el.EnglishLearnerStatus
		, el.EnglishLearner_StatusStartDate
		, el.EnglishLearner_StatusExitDate
		, el.ISO_639_2_NativeLanguage

		, titleIII.TitleIIILanguageInstructionProgramType
		, titleIII.TitleIIIImmigrantStatus
		, titleIII.TitleIIIImmigrantParticipationStatus
		, titleIII.Proficiency_TitleIII
		, titleIII.TitleIIIAccountabilityProgressStatus

	FROM Staging.K12Enrollment								enrollment

	-- Title III participation (INNER, proc fiscal-year window, NO EnglishLearnerParticipation filter)
	JOIN Staging.ProgramParticipationTitleIII			titleIII
		ON		enrollment.SchoolYear									=	titleIII.SchoolYear
		AND		enrollment.StudentIdentifierState						=	titleIII.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(titleIII.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(titleIII.SchoolIdentifierSea, '')
		AND		ISNULL(titleIII.ProgramParticipationStartDate, staging.GetFiscalYearStartDate(enrollment.SchoolYear)) <= staging.GetFiscalYearEndDate(enrollment.SchoolYear)
		AND		ISNULL(titleIII.ProgramParticipationExitDate,  staging.GetFiscalYearEndDate(enrollment.SchoolYear))   >= staging.GetFiscalYearStartDate(enrollment.SchoolYear)

	-- English learner status (INNER, proc fiscal-year window). EnglishLearnerStatus = 1 == the fact
	-- view's EnglishLearnerStatusEdFactsCode = 'LEP' filter.
	JOIN Staging.PersonStatus								el
		ON		enrollment.SchoolYear									=	el.SchoolYear
		AND		enrollment.StudentIdentifierState						=	el.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(el.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(el.SchoolIdentifierSea, '')
		AND		ISNULL(el.EnglishLearner_StatusStartDate, staging.GetFiscalYearStartDate(enrollment.SchoolYear)) <= staging.GetFiscalYearEndDate(enrollment.SchoolYear)
		AND		ISNULL(el.EnglishLearner_StatusExitDate,  staging.GetFiscalYearEndDate(enrollment.SchoolYear))   >= staging.GetFiscalYearStartDate(enrollment.SchoolYear)

	WHERE	enrollment.EnrollmentEntryDate <= staging.GetFiscalYearEndDate(enrollment.SchoolYear)
	AND		ISNULL(enrollment.EnrollmentExitDate, staging.GetFiscalYearEndDate(enrollment.SchoolYear)) >= staging.GetFiscalYearStartDate(enrollment.SchoolYear)
	AND		el.EnglishLearnerStatus = 1
