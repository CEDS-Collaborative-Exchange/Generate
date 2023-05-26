/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Child Count Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_ChildCount]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwIdeaStatuses') IS NOT NULL DROP TABLE #vwIdeaStatuses
		IF OBJECT_ID(N'tempdb..#vwUnduplicatedRaceMap') IS NOT NULL DROP TABLE #vwUnduplicatedRaceMap

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId int,
		@ChildCountDate date
		
	--Setting variables to be used in the select statements 
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)


	--Create the temp tables (and any relevant indexes) needed for this domain

		SELECT *
		INTO #vwGradeLevels
		FROM RDS.vwDimGradeLevels
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

		SELECT *
		INTO #vwIdeaStatuses
		FROM RDS.vwDimIdeaStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, IdeaEducationalEnvironmentForSchoolageMap);

		SELECT * 
		INTO #vwRaces 
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

		SELECT * 
		INTO #vwUnduplicatedRaceMap 
		FROM RDS.vwUnduplicatedRaceMap
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwUnduplicatedRaceMap ON #vwUnduplicatedRaceMap (StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, RaceMap);



		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'childcount'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts
		
	--Create and load #Facts temp table
		CREATE TABLE #Facts (
			StagingId								int not null
			, SchoolYearId							int null
			, FactTypeId							int null
			, GradeLevelId							int null
			, AgeId									int null
			, RaceId								int null
			, K12DemographicId						int null
			, StudentCount							int null

			, SEAId									int null
			, IEUId									int null
			, LEAId									int null
			, K12SchoolId							int null
			, K12StudentId							int null

			, IdeaStatusId							int null
			, LanguageId							int null
			, MigrantStatusId						int null
			, K12StudentStatusId					int null
			, TitleIStatusId						int null
			, TitleIIIStatusId						int null
			, AttendanceId							int null
			, CohortStatusId						int null
			, NOrDStatusId							int null
			, CTEStatusId							int null
			, K12EnrollmentStatusId					int null
			, EnglishLearnerStatusId				int null
			, HomelessnessStatusId					int null
			, EconomicallyDisadvantagedStatusId		int null
			, FosterCareStatusId					int null
			, ImmigrantStatusId						int null
			, PrimaryDisabilityTypeId				int null

			, SpecialEducationServicesExitDateId	int null
			, MigrantStudentQualifyingArrivalDateId	int null
			, LastQualifyingMoveDateId				int null
		)

		INSERT INTO #Facts
		SELECT DISTINCT
			sppse.Id													StagingId
			, rsy.DimSchoolYearId										SchoolYearId
			, @FactTypeId												FactTypeId
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelId
			, rda.DimAgeId												AgeId
			, ISNULL(rdr.DimRaceId, -1)									RaceId
			, ISNULL(rdkd.DimK12DemographicId, -1)						K12DemographicId
			, 1															StudentCount
			, ISNULL(rds.DimSeaId, -1)									SEAId
			, -1														IEUId
			, ISNULL(rdl.DimLeaID, -1)									LEAId
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId
			, -1														LanguageId
			, -1														MigrantStatusId
			, -1														K12StudentStatusId
			, -1														TitleIStatusId
			, -1														TitleIIIStatusId
			, -1														AttendanceId
			, -1														CohortStatusId
			, -1														NOrDStatusId
			, -1														CTEStatusId
			, -1														K12EnrollmentStatusId
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId
			, -1										 				HomelessnessStatusId
			, -1										 				EconomicallyDisadvantagedStatusId
			, -1														FosterCareStatusId
			, -1														ImmigrantStatusId
			, ISNULL(rdidt.DimIdeaDisabilityTypeId, -1)					PrimaryDisabilityTypeId
			, ISNULL(rdd.DimDateId, -1)									SpecialEducationServicesExitDateId
			, -1														MigrantStudentQualifyingArrivalDateId
			, -1								
		FROM Staging.K12Enrollment ske
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			JOIN RDS.vwDimK12Demographics rdkd
 				ON rsy.SchoolYear = rdkd.SchoolYear
				AND convert(varchar, ISNULL(ske.Sex, 'MISSING')) = convert(varchar, ISNULL(rdkd.SexMap, rdkd.SexCode))
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue
			JOIN RDS.DimSeas rds
				ON @ChildCountDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())		
			JOIN Staging.ProgramParticipationSpecialEducation sppse
				ON convert(varchar, ske.StudentIdentifierState) = convert(varchar, sppse.StudentIdentifierState)
				AND ((ISNULL(convert(varchar, ske.LeaIdentifierSeaAccountability), '') = ISNULL(convert(varchar, sppse.LeaIdentifierSeaAccountability), '') 
					AND sppse.LeaIdentifierSeaAccountability is not null)
					OR
					(ISNULL(convert(varchar, ske.SchoolIdentifierSea), '') = ISNULL(convert(varchar, sppse.SchoolIdentifierSea), '')
					AND sppse.SchoolIdentifierSea is not null))
				AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
			JOIN Staging.IdeaDisabilityType sidt	
				ON ske.SchoolYear = sidt.SchoolYear
				AND convert(varchar, sidt.StudentIdentifierState) = convert(varchar, sppse.StudentIdentifierState)
				AND ISNULL(convert(varchar, sidt.LeaIdentifierSeaAccountability), '') = ISNULL(convert(varchar, sppse.LeaIdentifierSeaAccountability), '')
				AND ISNULL(convert(varchar, sidt.SchoolIdentifierSea), '') = ISNULL(convert(varchar, sppse.SchoolIdentifierSea), '')
				AND sidt.IsPrimaryDisability = 1
				AND @ChildCountDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, GETDATE())
			JOIN RDS.DimPeople rdp
				ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
				AND IsActiveK12Student = 1
				AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
				AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
				AND @ChildCountDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())

			LEFT JOIN RDS.DimDates rdd
				ON sppse.ProgramParticipationEndDate = rdd.DateValue
				AND rdd.DateValue BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())

			LEFT JOIN RDS.DimLeas rdl
				ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
				AND @ChildCountDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())


			LEFT JOIN RDS.DimK12Schools rdksch
				ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
				AND @ChildCountDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())

			LEFT JOIN #vwGradeLevels rgls
				ON ske.GradeLevel = rgls.GradeLevelMap
				AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'


			LEFT JOIN Staging.PersonStatus el 
				ON convert(varchar, ske.StudentIdentifierState) = convert(varchar, el.StudentIdentifierState)
				and ske.LeaIdentifierSeaAccountability = el.LeaIdentifierSeaAccountability
				and ske.SchoolIdentifierSea = el.SchoolIdentifierSea
				AND ((ISNULL(convert(varchar, ske.LeaIdentifierSeaAccountability), '') = ISNULL(convert(varchar, el.LeaIdentifierSeaAccountability), '') 
					AND el.LeaIdentifierSeaAccountability is not null)
					OR
					(ISNULL(convert(varchar, ske.SchoolIdentifierSea), '') = ISNULL(convert(varchar, el.SchoolIdentifierSea), '')
					AND el.SchoolIdentifierSea is not null))
				AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())


			LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
				ON rsy.SchoolYear = rdels.SchoolYear
				AND rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
				AND rdels.TitleIIIAccountabilityProgressStatusCode = 'MISSING'
				AND rdels.TitleIIILanguageInstructionProgramTypeCode = 'MISSING'
				AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)


			LEFT JOIN #vwUnduplicatedRaceMap spr
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.StudentIdentifierState = spr.StudentIdentifierState
				AND ((ISNULL(convert(varchar, ske.LeaIdentifierSeaAccountability), '') = ISNULL(convert(varchar, spr.LeaIdentifierSeaAccountability), '') 
					AND spr.LeaIdentifierSeaAccountability is not null)
					OR
					(ISNULL(convert(varchar, ske.SchoolIdentifierSea), '') = ISNULL(convert(varchar, spr.SchoolIdentifierSea), '')
					AND spr.SchoolIdentifierSea is not null))

			LEFT JOIN #vwRaces rdr
				ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
					AND rsy.SchoolYear = rdr.SchoolYear

			
			LEFT JOIN #vwIdeaStatuses rdis
				ON rdis.IdeaIndicatorCode = 'Yes'
				AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 
				CASE 
						WHEN rda.AgeCode = 'MISSING' THEN 'MISSING'
						WHEN 
							(rda.AgeCode < 5 OR (rda.AgeCode = 5 AND rgls.GradeLevelCode IN ('PK','MISSING')))
							AND	
							sppse.IDEAEducationalEnvironmentForEarlyChildhood IS NOT NULL AND sppse.IDEAEducationalEnvironmentForEarlyChildhood <> '' 
							and isnull(rdis.IdeaEducationalEnvironmentForSchoolAgeMap, 'MISSING') = 'MISSING' -- ONLY GET THE ONES WHERE THE School Age MAP IS NULL

							THEN sppse.IDEAEducationalEnvironmentForEarlyChildhood
						ELSE 'MISSING'
					END 
				and rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 
					CASE 
						WHEN rda.AgeCode = 'MISSING' THEN 'MISSING'
						WHEN 
							(rda.AgeCode >= 5 AND rgls.GradeLevelCode NOT IN ('PK','MISSING'))
							AND
							sppse.IDEAEducationalEnvironmentForSchoolAge IS NOT NULL and sppse.IDEAEducationalEnvironmentForSchoolAge <> ''
							and isnull(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, 'MISSING') = 'MISSING' -- ONLY GET THE ONES WHERE THE EARLY CHILDHOOD MAP IS NULL
							THEN sppse.IDEAEducationalEnvironmentForSchoolAge
						ELSE 'MISSING'
					END
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'

			LEFT JOIN RDS.vwDimIdeaDisabilityTypes rdidt
				ON ske.SchoolYear = rdis.SchoolYear
				AND ISNULL(sidt.IdeaDisabilityTypeCode, 'MISSING') = ISNULL(rdidt.IdeaDisabilityTypeMap, rdidt.IdeaDisabilityTypeCode)
				AND sidt.IsPrimaryDisability = 1
			
			WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())

	--Final insert into RDS.FactK12StudentCounts table
		INSERT INTO RDS.FactK12StudentCounts (
			[SchoolYearId]
			, [FactTypeId]
			, [GradeLevelId]
			, [AgeId]
			, [RaceId]
			, [K12DemographicId]
			, [StudentCount]
			, [SEAId]
			, [IEUId]
			, [LEAId]
			, [K12SchoolId]
			, [K12StudentId]
			, [IdeaStatusId]
			, [LanguageId]
			, [MigrantStatusId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDStatusId]
			, [CTEStatusId]
			, [K12EnrollmentStatusId]
			, [EnglishLearnerStatusId]
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [FosterCareStatusId]
			, [ImmigrantStatusId]
			, [PrimaryDisabilityTypeId]
			, [SpecialEducationServicesExitDateId]
			, [MigrantStudentQualifyingArrivalDateId]
			, [LastQualifyingMoveDateId]
		)
		SELECT 
			[SchoolYearId]
			, [FactTypeId]
			, [GradeLevelId]
			, [AgeId]
			, [RaceId]
			, [K12DemographicId]
			, [StudentCount]
			, [SEAId]
			, [IEUId]
			, [LEAId]
			, [K12SchoolId]
			, [K12StudentId]
			, [IdeaStatusId]
			, [LanguageId]
			, [MigrantStatusId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDStatusId]
			, [CTEStatusId]
			, [K12EnrollmentStatusId]
			, [EnglishLearnerStatusId]
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [FosterCareStatusId]
			, [ImmigrantStatusId]
			, [PrimaryDisabilityTypeId]
			, [SpecialEducationServicesExitDateId]
			, [MigrantStudentQualifyingArrivalDateId]
			, [LastQualifyingMoveDateId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())

		insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())

	END CATCH

END
