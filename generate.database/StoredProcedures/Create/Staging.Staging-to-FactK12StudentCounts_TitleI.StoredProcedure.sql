/**********************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Title I Data from Staging to RDS.FactK12StudentCounts

NOTE: This Stored Procedure processes files: 037, 134, 222
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_TitleI]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwHomelessnessStatuses') IS NOT NULL DROP TABLE #vwHomelessnessStatuses
		IF OBJECT_ID(N'tempdb..#vwMigrantStatuses') IS NOT NULL DROP TABLE #vwMigrantStatuses
		IF OBJECT_ID(N'tempdb..#vwTitleIStatuses') IS NOT NULL DROP TABLE #vwTitleIStatuses
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwFosterCareStatuses') IS NOT NULL DROP TABLE #vwFosterCareStatuses


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

		--CREATE CLUSTERED INDEX ix_tempvwGradeLevels 
		--	ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		--CREATE CLUSTERED INDEX ix_tempvwRaces 
		--	ON #vwRaces (RaceMap);

		SELECT *
		INTO #vwHomelessnessStatuses
		FROM RDS.vwDimHomelessnessStatuses
		WHERE SchoolYear = @SchoolYear

		--CREATE CLUSTERED INDEX ix_tempvwHomelessnessStatuses
		--	ON #vwHomelessnessStatuses (HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode);

		SELECT *
		INTO #vwMigrantStatuses
		FROM RDS.vwDimMigrantStatuses
		WHERE SchoolYear = @SchoolYear

		--CREATE CLUSTERED INDEX ix_tempvwMigrantStatuses
		--	ON #vwMigrantStatuses (MigrantStatusCode, MigrantEducationProgramEnrollmentTypeCode, ContinuationOfServicesReasonCode, ConsolidatedMepFundsStatusCode, MigrantEducationProgramServicesTypeCode, MigrantPrioritizedForServicesCode);

		SELECT *
		INTO #vwTitleIStatuses
		FROM RDS.vwDimTitleIStatuses
		WHERE SchoolYear = @SchoolYear
		AND TitleIProgramTypeCode in ('SchoolwideProgram','TargetedAssistanceProgram')
		AND TitleISchoolStatusCode in ('SWELIGSWPROG', 'TGELGBTGPROG')

		--CREATE CLUSTERED INDEX ix_tempvwTitleIStatuses
		--	ON #vwTitleIStatuses (TitleIInstructionalServicesCode, TitleIProgramTypeCode, TitleISchoolStatusCode, TitleISupportServicesCode);

		-- FOSTER CARE -------------------------------------------
		SELECT * 
		INTO #vwFosterCareStatuses
		FROM RDS.vwDimEconomicallyDisadvantagedStatuses
		WHERE SchoolYear = @SchoolYear
		--------------------------------------------------------------



		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'titleI'	--DimFactTypeId = 12


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
			, DisabilityStatusId					int null
			, LanguageId							int null
			, MigrantStatusId						int null
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
			ske.id														StagingId								
			, rsy.DimSchoolYearId										SchoolYearId							
			, @FactTypeId												FactTypeId							
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelId							
			, -1 														AgeId									
			, ISNULL(rdr.DimRaceId, -1)									RaceId								
			, -1														K12DemographicId						
			, 1															StudentCount							
			, ISNULL(rds.DimSeaId, -1)									SEAId									
			, -1														IEUId									
			, ISNULL(rdl.DimLeaID, -1)									LEAId									
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId							
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId							
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId							
			, -1														DisabilityStatusId							
			, -1														LanguageId							
			, ISNULL(rdms.DimMigrantStatusId, -1) 						MigrantStatusId						
			, ISNULL(rdt1s.DimTitleIStatusId, -1)						TitleIStatusId						
			, -1														TitleIIIStatusId						
			, -1														AttendanceId							
			, -1 														CohortStatusId						
			, -1														NOrDStatusId							
			, -1														CTEStatusId							
			, -1														K12EnrollmentStatusId					
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, ISNULL(rdhs.DimHomelessnessStatusId, -1)					HomelessnessStatusId					
			, -1														EconomicallyDisadvantagedStatusId		
			, ISNULL(rdvfc.DimFosterCareStatusId, -1)					FosterCareStatusId					
			, -1														ImmigrantStatusId						
			, -1														PrimaryDisabilityTypeId				
			, -1														SpecialEducationServicesExitDateId	
			, -1														MigrantStudentQualifyingArrivalDateId	
			, -1														LastQualifyingMoveDateId						

		FROM Staging.K12Enrollment ske
		JOIN Staging.K12Organization sko
			ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sko.LeaIdentifierSea, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sko.SchoolIdentifierSea, '')
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		JOIN RDS.DimSeas rds
			ON ske.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEndDate)
		JOIN RDS.DimPeople rdp
			ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND rdp.IsActiveK12Student = 1
			AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
			AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
			AND ske.EnrollmentEntryDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, @SYEndDate)
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @SYEndDate)
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @SYEndDate)
	--title I
		JOIN Staging.ProgramParticipationTitleI title1
			ON ske.StudentIdentifierState = title1.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(title1.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(title1.SchoolIdentifierSea, '')
			AND title1.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--homeless
		JOIN Staging.PersonStatus hmStatus
			ON ske.StudentIdentifierState = hmStatus.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
			AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--foster care
		JOIN Staging.PersonStatus FosterCareStatus
			ON ske.StudentIdentifierState = FosterCareStatus.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(FosterCareStatus.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(FosterCareStatus.SchoolIdentifierSea, '')
			AND FosterCareStatus.FosterCare_ProgramParticipationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--idea disability status
		LEFT JOIN Staging.ProgramParticipationSpecialEducation idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND idea.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--english learner
		LEFT JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND el.EnglishLearner_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--migratory status	
		LEFT JOIN Staging.PersonStatus migrant
			ON ske.StudentIdentifierState = migrant.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
			AND migrant.Migrant_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
	--race	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea
				OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)
	--title I (RDS)
		LEFT JOIN #vwTitleIStatuses rdt1s
			ON ISNULL(sko.LEA_TitleIProgramType, 'MISSING') 				= ISNULL(rdt1s.TitleIProgramTypeMap, rdt1s.TitleIProgramTypeCode)
			AND ISNULL(sko.LEA_TitleIinstructionalService, 'MISSING') 		= ISNULL(rdt1s.TitleIInstructionalServicesMap, rdt1s.TitleIInstructionalServicesCode)
			AND ISNULL(sko.LEA_K12LeaTitleISupportService, 'MISSING') 		= ISNULL(rdt1s.TitleISupportServicesMap, rdt1s.TitleISupportServicesCode)
			AND ISNULL(sko.School_TitleISchoolStatus, 'MISSING') 			= ISNULL(rdt1s.TitleISchoolStatusMap, rdt1s.TitleISchoolStatusCode)

	--homelessness (RDS)
		LEFT JOIN #vwHomelessnessStatuses rdhs
			ON ISNULL(CAST(hmStatus.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
			AND rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdhs.HomelessServicedIndicatorCode = 'MISSING' 

	--foster care (RDS)
		LEFT JOIN RDS.vwDimFosterCareStatuses rdvfc
			ON ISNULL(CAST(FosterCareStatus.ProgramType_FosterCare AS SMALLINT), -1) = ISNULL(CAST(rdvfc.ProgramParticipationFosterCareMap AS SMALLINT), -1)


	--idea disability (RDS)
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON ske.SchoolYear = rdis.SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
			AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
			AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'
	--english learner (RDS)
		LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rsy.SchoolYear = rdels.SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND PerkinsEnglishLearnerStatusCode = 'MISSING'
	--migrant (RDS)
		LEFT JOIN #vwMigrantStatuses rdms
			ON ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
			AND rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING' 
			AND rdms.ContinuationOfServicesReasonCode = 'MISSING'
			AND rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
			AND rdms.MigrantPrioritizedForServicesCode = 'MISSING'
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

	--Clear the Fact table of the data about to be migrated  
		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

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
			, [DisabilityStatusId]
			, [LanguageId]
			, [MigrantStatusId]
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
			, [DisabilityStatusId]
			, [LanguageId]
			, [MigrantStatusId]
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
	insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())
	END CATCH

END
