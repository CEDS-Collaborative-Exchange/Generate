CREATE VIEW [Staging].[vwMembership_StagingTables_226]
AS
	-- FS226 - Economically Disadvantaged Students (DG56).
	-- Expected-side population for RunEndToEndTest: the unduplicated count of economically
	-- disadvantaged students (as of the membership date) enrolled in operational, federally-
	-- reported public schools (excluding "reportable program" school type). School level, Total only.
	--
	-- Mirrors the membership fact migration (Staging.[Staging-to-FactK12StudentCounts_Membership])
	-- so expected == actual:
	--   * enrollment covers the membership date (from debug.vwMembership_StagingTables),
	--   * economic-disadvantage status window covers the membership date,
	--   * valid age as-of the membership date (inner DimAges),
	--   * valid demographic (inner vwDimK12Demographics, Sex map),
	--   * grade level in the toggle-driven included set (PK,KG,01-12 always; 13/UG/ABE only if the
	--     CCDGRADE13/CCDUNGRADED/ADULTEDU toggles are on) -> correctly excludes adult-ed/grade-13,
	--   * school operational + reported federally + not a "reportable program".
	-- (Supersedes the mis-named Staging.vwMembership_StagingTables_C226.)
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea

	FROM [debug].[vwMembership_StagingTables]				s

	-- valid age as-of the membership date
	JOIN RDS.DimAges										rda
		ON RDS.Get_Age(s.BirthDate, s.MembershipDate) = rda.AgeValue

	-- valid demographic (Sex maps via SSRD RefSex)
	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)

	-- grade level in the toggle-driven included set (mirrors the membership fact @GradesList)
	JOIN RDS.vwDimGradeLevels								gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
		AND		gl.GradeLevelCode IN (
					SELECT v.g FROM (VALUES ('PK'),('KG'),('01'),('02'),('03'),('04'),('05'),('06'),('07'),('08'),('09'),('10'),('11'),('12')) v(g)
					UNION ALL SELECT '13'  WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='CCDGRADE13') = 1
					UNION ALL SELECT 'UG'  WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='CCDUNGRADED') = 1
					UNION ALL SELECT 'ABE' WHERE (SELECT ISNULL(MAX(CASE WHEN r.ResponseValue='true' THEN 1 ELSE 0 END),0) FROM app.ToggleQuestions q LEFT JOIN app.ToggleResponses r ON r.ToggleQuestionId=q.ToggleQuestionId WHERE q.EmapsQuestionAbbrv='ADULTEDU') = 1
				)

	-- school must be operational, reported federally, and not a "reportable program"
	JOIN Staging.K12Organization							scho
		ON		scho.SchoolIdentifierSea = s.SchoolIdentifierSea
		AND		scho.SchoolYear = s.SchoolYear
		AND		scho.School_OperationalStatus NOT IN ('Closed','FutureSchool','Inactive','MISSING')
		AND		ISNULL(scho.School_IsReportedFederally, 0) <> 0
		AND		ISNULL(scho.School_Type, '') <> 'Reportable'

	WHERE	s.EconomicDisadvantageStatus = 1
	AND		s.MembershipDate BETWEEN s.EconomicDisadvantage_StatusStartDate AND ISNULL(s.EconomicDisadvantage_StatusExitDate, '9999-01-01')
