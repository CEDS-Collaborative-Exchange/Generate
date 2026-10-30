CREATE VIEW [Staging].[vwDiscipline_StagingTables_088]
AS
	-- Expected-side population for FS088 (Children with Disabilities (IDEA) Disciplinary Removals).
	-- Mirrors Staging.[Staging-to-FactK12StudentDisciplines] (enrollment, IDEA status, primary disability,
	-- EL status and race resolution) and the filters in RDS.vwDiscipline_FactTable_088.
	-- Source codes are translated per attribute through Staging.SourceSystemReferenceData and the dimension
	-- tables rather than through RDS.vwDimDisciplineStatuses/vwDimIdeaStatuses, whose multi-column ISNULL
	-- joins against thousands of rows are too slow to evaluate inside a view.
	WITH Years AS (
		SELECT
			sy.SchoolYear
			, DATEFROMPARTS(sy.SchoolYear - 1, 7, 1) AS SYStartDate		-- staging.GetFiscalYearStartDate, inlined so it is not re-evaluated per row
			, DATEFROMPARTS(sy.SchoolYear, 6, 30) AS SYEndDate			-- staging.GetFiscalYearEndDate
			, CAST(CAST(sy.SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(cc.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(cc.ResponseValue) AS VARCHAR(2)) AS DATE) AS ChildCountDate
		FROM RDS.DimSchoolYears sy
		JOIN RDS.DimSchoolYearDataMigrationTypes dmt
			ON dmt.DimSchoolYearId = sy.DimSchoolYearId
			AND dmt.IsSelected = 1
			AND dmt.DataMigrationTypeId = 3
		CROSS JOIN (
			SELECT TOP 1 CAST(tr.ResponseValue AS DATE) AS ResponseValue
			FROM App.ToggleQuestions tq
			JOIN App.ToggleResponses tr
				ON tq.ToggleQuestionId = tr.ToggleQuestionId
			WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'
		) cc
	)
	-- Source code -> EdFacts code lookups (key = the staging value, or 'MISSING' when it is NULL)
	, DisciplineMethods AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, 'MISSING') AS MapKey, d.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode AS EdFactsCode
		FROM RDS.DimDisciplineStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.DisciplineMethodOfChildrenWithDisabilitiesCode
			AND sssrd.TableName = 'RefDisciplineMethodOfCwd'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, DisciplinaryActions AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, 'MISSING') AS MapKey, d.DisciplinaryActionTakenEdFactsCode AS EdFactsCode
		FROM RDS.DimDisciplineStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.DisciplinaryActionTakenCode
			AND sssrd.TableName = 'RefDisciplinaryActionTaken'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, InterimRemovals AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, 'MISSING') AS MapKey, d.IdeaInterimRemovalEdFactsCode AS EdFactsCode
		FROM RDS.DimDisciplineStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.IdeaInterimRemovalCode
			AND sssrd.TableName = 'RefIdeaInterimRemoval'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, InterimRemovalReasons AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, 'MISSING') AS MapKey, d.IdeaInterimRemovalReasonEdFactsCode AS EdFactsCode
		FROM RDS.DimDisciplineStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.IdeaInterimRemovalReasonCode
			AND sssrd.TableName = 'RefIdeaInterimRemovalReason'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, SchoolAgeEnvironments AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, d.IdeaEducationalEnvironmentForSchoolAgeCode) AS MapKey, d.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode AS EdFactsCode
		FROM RDS.DimIdeaStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.IdeaEducationalEnvironmentForSchoolAgeCode
			AND sssrd.TableName = 'RefIDEAEducationalEnvironmentSchoolAge'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, EarlyChildhoodEnvironments AS (
		SELECT DISTINCT y.SchoolYear, ISNULL(sssrd.InputCode, d.IdeaEducationalEnvironmentForEarlyChildhoodCode) AS MapKey
		FROM RDS.DimIdeaStatuses d
		CROSS JOIN Years y
		LEFT JOIN Staging.SourceSystemReferenceData sssrd
			ON sssrd.OutputCode = d.IdeaEducationalEnvironmentForEarlyChildhoodCode
			AND sssrd.TableName = 'RefIDEAEducationalEnvironmentEC'
			AND sssrd.SchoolYear = y.SchoolYear
	)
	, IdeaDisability AS (
		SELECT DISTINCT
			sidt.StudentIdentifierState
			, sidt.LeaIdentifierSeaAccountability
			, sidt.SchoolIdentifierSea
			, sidt.IdeaDisabilityTypeCode
			, sidt.RecordStartDateTime
			, sidt.RecordEndDateTime
			, sidt.SchoolYear
		FROM Staging.IdeaDisabilityType sidt
		JOIN Years y
			ON sidt.SchoolYear = y.SchoolYear
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON sidt.SchoolYear 									= sppse.SchoolYear
			AND sidt.StudentIdentifierState 					= sppse.StudentIdentifierState
			AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sidt.SchoolIdentifierSea, '') 			= ISNULL(sppse.SchoolIdentifierSea, '')
			AND sidt.IsPrimaryDisability = 1
			AND ((sidt.RecordStartDateTime <= sppse.ProgramParticipationStartDate AND ISNULL(sidt.RecordEndDateTime, y.SYEndDate) > sppse.ProgramParticipationStartDate)
				OR (sidt.RecordStartDateTime > sppse.ProgramParticipationStartDate AND sidt.RecordStartDateTime < ISNULL(sppse.ProgramParticipationExitDate, y.SYEndDate)))
	)
	, ELStatus AS (
		SELECT DISTINCT
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusExitDate
			, SchoolYear
		FROM Staging.PersonStatus
	)
	, IdeaStatus AS (
		SELECT DISTINCT
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, ProgramParticipationStartDate
			, ProgramParticipationExitDate
			, IdeaIndicator
			, IDEAEducationalEnvironmentForEarlyChildhood
			, IDEAEducationalEnvironmentForSchoolAge
			, SchoolYear
		FROM Staging.ProgramParticipationSpecialEducation
		WHERE IDEAIndicator = 1
	)
	, Removals AS (
		SELECT
			sd.StudentIdentifierState
			, sd.LeaIdentifierSeaAccountability
			, sd.SchoolIdentifierSea
			, sd.SchoolYear
			, ISNULL(CAST(sd.DurationOfDisciplinaryAction AS DECIMAL(18,2)), 0) AS DurationOfDisciplinaryAction
			, ISNULL(ridt.IdeaDisabilityTypeEdFactsCode, 'MISSING') AS IdeaDisabilityType
			, ISNULL(rr.RaceEdFactsCode, 'MISSING') AS Race
			, rkd.SexEdFactsCode AS Sex
			, ISNULL(rels.EnglishLearnerStatusEdFactsCode, 'MISSING') AS EnglishLearnerStatus
			, dm.EdFactsCode AS DisciplineMethodOfChildrenWithDisabilities
		FROM Staging.Discipline sd
		JOIN Years y
			ON sd.SchoolYear = y.SchoolYear
		INNER HASH JOIN Staging.K12Enrollment ske
			ON sd.SchoolYear 									= ske.SchoolYear
			AND sd.StudentIdentifierState 						= ske.StudentIdentifierState
			AND ISNULL(sd.LeaIdentifierSeaAccountability, '') 	= ISNULL(ske.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sd.SchoolIdentifierSea, '') 				= ISNULL(ske.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, y.SYEndDate)
		JOIN RDS.DimSeas rds
			ON sd.DisciplinaryActionStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, y.SYEndDate)
	--sex
		INNER HASH JOIN RDS.vwDimK12Demographics vkd
			ON vkd.SchoolYear = sd.SchoolYear
			AND ISNULL(ske.Sex, 'MISSING') = ISNULL(vkd.SexMap, vkd.SexCode)
		INNER HASH JOIN RDS.DimK12Demographics rkd
			ON rkd.DimK12DemographicId = vkd.DimK12DemographicId
	--idea status (IdeaIndicator = 1 -> WDIS; the early childhood environment must still resolve to a dimension member)
		INNER HASH JOIN IdeaStatus sppse
			ON sd.SchoolYear 									= sppse.SchoolYear
			AND sd.StudentIdentifierState 						= sppse.StudentIdentifierState
			AND ISNULL(sd.LEAIdentifierSeaAccountability,'') 	= ISNULL(sppse.LeaIdentifierSeaAccountability,'')
			AND ISNULL(sd.SchoolIdentifierSea,'') 				= ISNULL(sppse.SchoolIdentifierSea,'')
			AND sd.DisciplinaryActionStartDate BETWEEN sppse.ProgramParticipationStartDate AND ISNULL(sppse.ProgramParticipationExitDate, y.SYEndDate)
		INNER HASH JOIN SchoolAgeEnvironments sae
			ON sae.SchoolYear = sd.SchoolYear
			AND sae.MapKey = ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, 'MISSING')
		INNER HASH JOIN EarlyChildhoodEnvironments ece
			ON ece.SchoolYear = sd.SchoolYear
			AND ece.MapKey = ISNULL(sppse.IDEAEducationalEnvironmentForEarlyChildhood, 'MISSING')
	--primary disability
		LEFT HASH JOIN IdeaDisability sidt
			ON sidt.SchoolYear 									= sd.SchoolYear
			AND sidt.StudentIdentifierState 					= sd.StudentIdentifierState
			AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(sd.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sidt.SchoolIdentifierSea, '') 			= ISNULL(sd.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, y.SYEndDate)
		LEFT HASH JOIN RDS.vwDimIdeaDisabilityTypes vidt
			ON vidt.SchoolYear = sd.SchoolYear
			AND ISNULL(sidt.IdeaDisabilityTypeCode, 'MISSING') = ISNULL(vidt.IdeaDisabilityTypeMap, vidt.IdeaDisabilityTypeCode)
		LEFT HASH JOIN RDS.DimIdeaDisabilityTypes ridt
			ON ridt.DimIdeaDisabilityTypeId = vidt.DimIdeaDisabilityTypeId
	--english learner
		LEFT HASH JOIN ELStatus el
			ON sd.SchoolYear 									= el.SchoolYear
			AND sd.StudentIdentifierState 						= el.StudentIdentifierState
			AND ISNULL(sd.LeaIdentifierSeaAccountability, '') 	= ISNULL(el.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sd.SchoolIdentifierSea, '') 				= ISNULL(el.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusExitDate, y.SYEndDate)
		LEFT HASH JOIN RDS.vwDimEnglishLearnerStatuses vels
			ON vels.SchoolYear = sd.SchoolYear
			AND vels.PerkinsEnglishLearnerStatusCode = 'MISSING'
			AND (CASE
				WHEN ISNULL(sd.DisciplinaryActionStartDate, '1900-01-01')
					BETWEEN ISNULL(el.EnglishLearner_StatusStartDate, y.SYStartDate) AND ISNULL(el.EnglishLearner_StatusExitDate, y.SYEndDate)
						THEN ISNULL(el.EnglishLearnerStatus, 0)
				ELSE 0
				END) = ISNULL(vels.EnglishLearnerStatusMap, -1)
		LEFT HASH JOIN RDS.DimEnglishLearnerStatuses rels
			ON rels.DimEnglishLearnerStatusId = vels.DimEnglishLearnerStatusId
	--school
		INNER HASH JOIN RDS.DimK12Schools rdksch
			ON sd.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND sd.DisciplinaryActionStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, y.SYEndDate)
	--discipline status
		INNER HASH JOIN DisciplineMethods dm
			ON dm.SchoolYear = sd.SchoolYear
			AND dm.MapKey = ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')
		INNER HASH JOIN DisciplinaryActions da
			ON da.SchoolYear = sd.SchoolYear
			AND da.MapKey = ISNULL(sd.DisciplinaryActionTaken, 'MISSING')
		INNER HASH JOIN InterimRemovals ir
			ON ir.SchoolYear = sd.SchoolYear
			AND ir.MapKey = ISNULL(sd.IdeaInterimRemoval, 'MISSING')
		INNER HASH JOIN InterimRemovalReasons irr
			ON irr.SchoolYear = sd.SchoolYear
			AND irr.MapKey = ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')
	--race (unduplicated, Hispanic/Latino takes precedence)
		LEFT HASH JOIN RDS.vwUnduplicatedRaceMap spr
			ON spr.SchoolYear = sd.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND ISNULL(ske.LEAIdentifierSeaAccountability,'')	= ISNULL(spr.LeaIdentifierSeaAccountability,'')
			AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(spr.SchoolIdentifierSea,'')
		LEFT HASH JOIN RDS.vwDimRaces vr
			ON vr.SchoolYear = sd.SchoolYear
			AND ISNULL(vr.RaceMap, vr.RaceCode) =
				CASE
					WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
					WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
					ELSE 'Missing'
				END
		LEFT HASH JOIN RDS.DimRaces rr
			ON rr.DimRaceId = vr.DimRaceId
		WHERE
			-- age as of the child count date (same arithmetic as RDS.Get_Age)
			(CONVERT(INT, CONVERT(CHAR(8), y.ChildCountDate, 112)) - CONVERT(INT, CONVERT(CHAR(8), ske.Birthdate, 112))) / 10000 BETWEEN 3 AND 21
			AND (dm.EdFactsCode <> 'MISSING'
				OR da.EdFactsCode IN ('03086','03087')
				OR irr.EdFactsCode <> 'MISSING'
				OR ir.EdFactsCode <> 'MISSING')
			AND sae.EdFactsCode <> 'PPPS'
			AND rdksch.SchoolOperationalStatus IN ('Open','New')
	)
	, Totals AS (
		SELECT 
			r.*
			-- Cumulative days removed for the school year, summed within the LEA
			, SUM(r.DurationOfDisciplinaryAction) OVER (PARTITION BY r.SchoolYear, r.StudentIdentifierState, r.LeaIdentifierSeaAccountability) AS TotalDaysRemoved
		FROM Removals r
	)
	SELECT 
		t.StudentIdentifierState
		, t.LeaIdentifierSeaAccountability
		, t.SchoolIdentifierSea
		, t.SchoolYear
		, t.IdeaDisabilityType
		, t.Race
		, t.Sex
		, t.EnglishLearnerStatus
		-- Removal length buckets match the legacy Get_CountSQL REMOVALLENIDEA branch
		, CASE 
			WHEN t.TotalDaysRemoved < 1.5 THEN 'LTOREQ1'
			WHEN t.TotalDaysRemoved <= 10.0 THEN '2TO10'
			ELSE 'GREATER10'
		  END AS RemovalLength
	FROM Totals t
	-- Only children removed for at least half a day in total are reported
	WHERE t.TotalDaysRemoved >= 0.5
