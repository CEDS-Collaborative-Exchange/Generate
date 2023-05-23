/**********************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Homeless Data from Staging to RDS.FactK12StudentCounts
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_Homeless]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwEconomicallyDisadvantagedStatuses') IS NOT NULL DROP TABLE #vwEconomicallyDisadvantagedStatuses
		IF OBJECT_ID(N'tempdb..#vwMigrantStatuses') IS NOT NULL DROP TABLE #vwMigrantStatuses
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT,
		@SYStartDate DATE,
		@SYEndDate DATE
		
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear)
		SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)

	--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwGradeLevels
		FROM RDS.vwDimGradeLevels
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels 
			ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces 
			ON #vwRaces (RaceMap);

		SELECT *
		INTO #vwHomelessnessStatuses
		FROM RDS.vwDimHomelessnessStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwHomelessnessStatuses
			ON #vwHomelessnessStatuses (HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode);

		SELECT *
		INTO #vwEconomicallyDisadvantagedStatuses
		FROM RDS.vwDimEconomicallyDisadvantagedStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwEconomicallyDisadvantagedStatuses
			ON #vwEconomicallyDisadvantagedStatuses (EconomicDisadvantageStatusCode, EligibilityStatusForSchoolFoodServiceProgramsCode, NationalSchoolLunchProgramDirectCertificationIndicatorCode);

		SELECT *
		INTO #vwMigrantStatuses
		FROM RDS.vwDimMigrantStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwMigrantStatuses
			ON #vwMigrantStatuses (MigrantStatusCode, MigrantEducationProgramEnrollmentTypeCode, ContinuationOfServicesReasonCode, ConsolidatedMepFundsStatusCode, MigrantEducationProgramServicesTypeCode, MigrantPrioritizedForServicesCode);

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'homeless'

		--Clear the Fact table of the data about to be migrated  
		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts
		
		--Create and load #Facts temp table
		CREATE TABLE #Facts (
			StagingId								int not null
			, AgeId									int null
			, SchoolYearId							int null
			, K12DemographicId						int null
			, FactTypeId							int null
			, GradeLevelId							int null
			, IdeaStatusId							int null
			, ProgramStatusId						int null
			, K12SchoolId							int null
			, K12StudentId							int null
			, StudentCount							int null
			, LanguageId							int null
			, MigrantId								int null
			, K12StudentStatusId					int null
			, TitleIStatusId						int null
			, TitleIIIStatusId						int null
			, LEAId									int null
			, AttendanceId							int null
			, CohortStatusId						int null
			, NorDProgramStatusId					int null
			, StudentCutoverStartDate				date null
			, RaceId								int null
			, CTEStatusId							int null
			, K12EnrollmentStatusId					int null
			, SEAId									int null
			, IEUId									int null
			, SpecialEducationServicesExitDateId	int null
		)

		INSERT INTO #Facts
		SELECT DISTINCT
			ske.id										StagingId
			, rda.DimAgeId								AgeId
			, rsy.DimSchoolYearId						SchoolYearId
			, ISNULL(rdkd.DimK12DemographicId, -1)		K12DemographicId
			, @FactTypeId								FactTypeId
			, ISNULL(rgls.DimGradeLevelId, -1)			GradeLevelId
			, -1										IdeaStatusId
			, -1										ProgramStatusId
			, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
			, ISNULL(rdp.DimPersonId, -1)				K12StudentId
			, 1											StudentCount
			, -1										LanguageId
			, -1										MigrantId
			, -1										K12StudentStatusId
			, -1										TitleIStatusId
			, -1										TitleIIIStatusId
			, ISNULL(rdl.DimLeaID, -1)					LEAId
			, -1										AttendanceId
			, -1										CohortStatusId
			, -1										NorDProgramStatusId
			, NULL										StudentCutoverStartDate
			, ISNULL(rdr.DimRaceId, -1)					RaceId
			, -1										CTEStatusId
			, -1										K12EnrollmentStatusId
			, ISNULL(rds.DimSeaId, -1)					SEAId
			, -1										IEUId
			, -1										SpecialEducationServicesExitDateId
		
		FROM Staging.K12Enrollment ske
	--homeless
		JOIN Staging.PersonStatus hmStatus
			ON ske.StudentIdentifierState = hmStatus.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND hmStatus.Homelessness_StatusStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND hmStatus.Homelessness_StatusStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		JOIN RDS.DimSeas rds
			ON hmStatus.Homelessness_StatusStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
	--homeless nighttime residence
		LEFT JOIN Staging.PersonStatus hmNight
			ON ske.StudentIdentifierState = hmNight.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmNight.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmNight.SchoolIdentifierSea, '')
			AND hmNight.HomelessNightTimeResidence_StartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
	--disability status
		LEFT JOIN Staging.ProgramParticipationSpecialEducation idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN idea.ProgramParticipationBeginDate AND ISNULL(idea.ProgramParticipationEndDate, GETDATE())
	--english learner
		LEFT JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
	--migratory status	
		LEFT JOIN Staging.PersonStatus migrant
			ON ske.StudentIdentifierState = migrant.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN migrant.Migrant_StatusStartDate AND ISNULL(migrant.Migrant_StatusEndDate, GETDATE())
	--race	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea
				OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)
	--age
		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @SYStartDate) = rda.AgeValue
	--homelessness (RDS)
		LEFT JOIN #vwHomelessnessStatus rdhs
			ON ISNULL(CAST(hmStatus.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.HomelessnessStatusMap AS SMALLINT), -1)
			AND ISNULL(hmNight.HomelessNightTimeResidence, 'MISSING') = ISNULL(rdkd.HomelessPrimaryNighttimeResidenceMap, 'MISSING')
			AND ISNULL(CAST(hmStatus.HomelessUnaccompaniedYouth AS SMALLINT), -1) = ISNULL(CAST(rdkd.HomelessUnaccompaniedYouthStatusMap AS SMALLINT), -1)
	--economically disadvantaged (RDS)
		LEFT JOIN #vwEconomicallyDisadvantagedStatuses rdeds
			ON rdkd.EconomicDisadvantageStatusCode = 'MISSING'
	--migrant (RDS)
		LEFT JOIN #vwMigrantStatuses rdms
			ON ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.MigrantStatusMap AS SMALLINT), -1)
	--grade (RDS)
		LEFT JOIN #vwGradeLevels rgls
			ON ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
	--race (RDS)	
		LEFT JOIN #vwRaces rdr
			ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
				CASE
					when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
					WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
					ELSE 'Missing'
				END
		JOIN RDS.DimPeople rdp
			ON ske.StudentIdentifierState = rdp.StateStudentIdentifier
			AND rdp.IsActiveK12Student = 1
			AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
			AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())
		WHERE hmStatus.HomelessnessStatus = 1 
		AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())


	---Final insert into RDS.FactK12StudentCounts table 
		INSERT INTO RDS.FactK12StudentCounts (
			[AgeId]
			, [SchoolYearId]
			, [K12DemographicId]
			, [FactTypeId]
			, [GradeLevelId]
			, [IdeaStatusId]
			, [ProgramStatusId]
			, [K12SchoolId]
			, [K12StudentId]
			, [StudentCount]
			, [LanguageId]
			, [MigrantId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [LeaId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDProgramStatusId]
			, [StudentCutOverStartDate]
			, [RaceId]
			, [CteStatusId]
			, [K12EnrollmentStatusId]
			, [SeaId]
			, [IeuId]
			, [SpecialEducationServicesExitDateId]
		)
		SELECT
			[AgeId]
			, [SchoolYearId]
			, [K12DemographicId]
			, [FactTypeId]
			, [GradeLevelId]
			, [IdeaStatusId]
			, [ProgramStatusId]
			, [K12SchoolId]
			, [K12StudentId]
			, [StudentCount]
			, [LanguageId]
			, [MigrantId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [LeaId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDProgramStatusId]
			, [StudentCutOverStartDate]
			, [RaceId]
			, [CteStatusId]
			, [K12EnrollmentStatusId]
			, [SeaId]
			, [IeuId]
			, [SpecialEducationServicesExitDateId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_Homeless', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

END