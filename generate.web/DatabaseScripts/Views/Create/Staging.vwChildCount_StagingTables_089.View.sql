CREATE VIEW [Staging].[vwChildCount_StagingTables_089]
AS
	-- FS089 - IDEA Child Count, ages 3-5 (Part B section 619), broken out by Age, English Learner,
	-- IDEA disability type, IDEA educational environment (early childhood), Race, Sex.
	-- Mirrors RDS.vwChildCount_FactTable_089: IDEA special-ed participants (debug base INNER-joins the
	-- participation, active on the child-count date) whose age as-of the child-count date is 3-5
	-- (age 5 only if grade PK/MISSING).
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, ddemo.SexEdFactsCode											AS Sex
		, rda.AgeEdFactsCode											AS Age
		, drace.RaceEdFactsCode											AS Race
		, ddt.IdeaDisabilityTypeEdFactsCode								AS IdeaDisabilityType
		, dis.IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode	AS IdeaEducationalEnvironmentForEarlyChildhood
		, dels.EnglishLearnerStatusEdFactsCode							AS EnglishLearnerStatus

	FROM [debug].[vwChildCount_StagingTables]				s

	JOIN RDS.DimAges										rda
		ON		rda.AgeValue = s.CalculatedAge

	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
	JOIN RDS.DimK12Demographics								ddemo
		ON		ddemo.DimK12DemographicId = rdkd.DimK12DemographicId

	-- grade (for the age-5 filter only)
	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	-- IDEA disability type
	LEFT JOIN RDS.vwDimIdeaDisabilityTypes					rddt
		ON		rddt.SchoolYear = s.SchoolYear
		AND		ISNULL(s.IdeaDisabilityTypeCode, 'MISSING') = ISNULL(rddt.IdeaDisabilityTypeMap, rddt.IdeaDisabilityTypeCode)
	JOIN RDS.DimIdeaDisabilityTypes							ddt
		ON		ddt.DimIdeaDisabilityTypeId = ISNULL(rddt.DimIdeaDisabilityTypeId, -1)

	-- IDEA status (indicator + both environments; exit reason MISSING) -> early-childhood environment code
	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IdeaIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
		AND		ISNULL(s.IDEAEducationalEnvironmentForEarlyChildhood, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
		AND		ISNULL(s.IDEAEducationalEnvironmentForSchoolAge, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

	-- English learner
	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

	-- Race (unduplicated + Hispanic/Latino override)
	LEFT JOIN RDS.vwUnduplicatedRaceMap						spr
		ON		spr.SchoolYear = s.SchoolYear
		AND		spr.StudentIdentifierState = s.StudentIdentifierState
		AND		(spr.SchoolIdentifierSea = s.SchoolIdentifierSea
				OR spr.LeaIdentifierSeaAccountability = s.LEAIdentifierSeaAccountability)
	LEFT JOIN RDS.vwDimRaces									rdr
		ON		rdr.SchoolYear = s.SchoolYear
		AND		ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						WHEN s.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
	JOIN RDS.DimRaces										drace
		ON		drace.DimRaceId = ISNULL(rdr.DimRaceId, -1)

	-- exactly mirror the FS089 fact view: keep ONLY age-5 students in grade PK/MISSING
	WHERE	rda.AgeEdFactsCode IN ('3','4','5')
		AND	(CASE WHEN rda.AgeEdFactsCode = '5' AND dgl.GradeLevelEdFactsCode IN ('MISSING','PK') THEN 1
				 ELSE 0 END) = 1
