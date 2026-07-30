CREATE VIEW [Staging].[vwChildCount_StagingTables_002]
AS
	-- FS002 - IDEA Child Count, school age 5-21, broken out by Age, English Learner, IDEA disability
	-- type, IDEA educational environment (school age), Race, Sex.
	-- Mirrors RDS.vwChildCount_FactTable_002: IDEA special-ed participants (base INNER-joins the
	-- participation active on the child-count date), ages 5-21 (age 5 only if NOT grade PK/MISSING),
	-- excluding developmental-delay ('DD') students whose age is outside the CHDCTAGEDD toggle range.
	SELECT DISTINCT
		  s.StudentIdentifierState
		, s.LEAIdentifierSeaAccountability
		, s.SchoolIdentifierSea
		, ddemo.SexEdFactsCode											AS Sex
		, rda.AgeEdFactsCode											AS Age
		, drace.RaceEdFactsCode											AS Race
		, ddt.IdeaDisabilityTypeEdFactsCode								AS IdeaDisabilityType
		, dis.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode			AS IdeaEducationalEnvironmentForSchoolAge
		, dels.EnglishLearnerStatusEdFactsCode							AS EnglishLearnerStatus

	FROM [debug].[vwChildCount_StagingTables]				s

	JOIN RDS.DimAges										rda
		ON		rda.AgeValue = s.CalculatedAge

	JOIN RDS.vwDimK12Demographics							rdkd
		ON		rdkd.SchoolYear = s.SchoolYear
		AND		ISNULL(s.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
	JOIN RDS.DimK12Demographics								ddemo
		ON		ddemo.DimK12DemographicId = rdkd.DimK12DemographicId

	LEFT JOIN RDS.vwDimGradeLevels							gl
		ON		gl.SchoolYear = s.SchoolYear
		AND		gl.GradeLevelTypeDescription = 'Entry Grade Level'
		AND		gl.GradeLevelMap = s.GradeLevel
	LEFT JOIN RDS.DimGradeLevels							dgl
		ON		dgl.DimGradeLevelId = ISNULL(gl.DimGradeLevelId, -1)

	LEFT JOIN RDS.vwDimIdeaDisabilityTypes					rddt
		ON		rddt.SchoolYear = s.SchoolYear
		AND		ISNULL(s.IdeaDisabilityTypeCode, 'MISSING') = ISNULL(rddt.IdeaDisabilityTypeMap, rddt.IdeaDisabilityTypeCode)
	JOIN RDS.DimIdeaDisabilityTypes							ddt
		ON		ddt.DimIdeaDisabilityTypeId = ISNULL(rddt.DimIdeaDisabilityTypeId, -1)

	LEFT JOIN RDS.vwDimIdeaStatuses							rdis
		ON		rdis.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.IdeaIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
		AND		ISNULL(s.IDEAEducationalEnvironmentForEarlyChildhood, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
		AND		ISNULL(s.IDEAEducationalEnvironmentForSchoolAge, 'MISSING') = ISNULL(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, rdis.IdeaEducationalEnvironmentForSchoolAgeCode)
		AND		rdis.SpecialEducationExitReasonCode = 'MISSING'
	JOIN RDS.DimIdeaStatuses								dis
		ON		dis.DimIdeaStatusId = ISNULL(rdis.DimIdeaStatusId, -1)

	LEFT JOIN RDS.vwDimEnglishLearnerStatuses				rdels
		ON		rdels.SchoolYear = s.SchoolYear
		AND		ISNULL(CAST(s.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
		AND		rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
	JOIN RDS.DimEnglishLearnerStatuses						dels
		ON		dels.DimEnglishLearnerStatusId = ISNULL(rdels.DimEnglishLearnerStatusId, -1)

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

	-- ages 5-21, age 5 only if NOT grade PK/MISSING (age-5-in-PK/MISSING belongs to FS089)
	WHERE	rda.AgeEdFactsCode IN ('5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21')
		AND	(CASE WHEN rda.AgeEdFactsCode = '5' AND dgl.GradeLevelEdFactsCode IN ('MISSING','PK') THEN 0
				 ELSE 1 END) = 1
		-- developmental-delay age exclusion (mirror the fact view's dd subquery)
		AND NOT (
				ddt.IdeaDisabilityTypeEdFactsCode = 'DD'
				AND rda.AgeEdFactsCode NOT IN (
						SELECT REPLACE(rr.ResponseValue, ' Years', '')
						FROM app.ToggleResponses rr JOIN app.ToggleQuestions qq ON rr.ToggleQuestionId = qq.ToggleQuestionId
						WHERE qq.EmapsQuestionAbbrv = 'CHDCTAGEDD'
						UNION SELECT 'AGE05K'
						FROM app.ToggleResponses rr JOIN app.ToggleQuestions qq ON rr.ToggleQuestionId = qq.ToggleQuestionId
						WHERE qq.EmapsQuestionAbbrv = 'CHDCTAGEDD' AND rr.ResponseValue LIKE '%5%'
						UNION SELECT 'AGE05NOTK'
						FROM app.ToggleResponses rr JOIN app.ToggleQuestions qq ON rr.ToggleQuestionId = qq.ToggleQuestionId
						WHERE qq.EmapsQuestionAbbrv = 'CHDCTAGEDD' AND rr.ResponseValue LIKE '%5%'
					)
			)
