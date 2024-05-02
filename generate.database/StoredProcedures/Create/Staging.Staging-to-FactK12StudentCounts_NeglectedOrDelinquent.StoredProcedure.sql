/**********************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Neglected Or Delinquent Data from Staging to RDS.FactK12StudentCounts

NOTE: This Stored Procedure processes files: 
FS119 
	1. Neglected programs participation table - state agency	869	The number of students participating in NEGLECTED programs 
		under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.
	2. Delinquent programs participation table - state agency	870	The number of students participating in DELINQUENT programs 
		under Title I, Part D, Subpart 1 (State Agency) of ESEA as amended.

FS127
	1. Delinquent programs participation table - LEA	872	The number of students participating in programs for DELINQUENT students 
		under Title I, Part D, Subpart 2 (LEA) of ESEA, as amended.
	2. At-Risk programs participation table - LEA	873	The number of students participating in programs for AT-RISK students 
		under Title I, Part D, Subpart 2 (LEA) of ESEA, as amended.

FS180 - Retired?

FS181 - Retired?

FS218
	1. The number of students participating in NEGLECTED AND DELINQUENT programs under Title I, Part D, Subpart 1 (State Agency) of ESEA, as amended, 
		who attained academic and career and technical outcomes while enrolled in the programs.

FS219
	1. The number of students participating in AT-RISK AND DELINQUENT programs under Title I, Part D, Subpart 2 (LEA) of ESEA, as amended, 
		who attained academic and career and technical outcomes while enrolled in the programs.
FS220
	1. The number of students participating in NEGLECTED AND DELINQUENT programs under Title I, Part D, Subpart 1 (State Agency) of ESEA, as amended, 
		who attained academic and career and technical outcomes up to 90 calendar days after exiting the program.

FS221
	1. The number of students participating in AT-RISK AND DELINQUENT programs under Title I, Part D, Subpart 2 (LEA) of ESEA, as amended, 
		who attained academic and career and technical outcomes up to 90 calendar days after exiting the program.

************************************************************************/

CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_NeglectedOrDelinquent]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwNeglectedOrDelinquentStatuses') IS NOT NULL DROP TABLE #vwNeglectedOrDelinquentStatuses

--	BEGIN TRY

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
		INTO #vwNeglectedOrDelinquentStatuses
		FROM RDS.vwDimNOrDStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwNeglectedOrDelinquentStatuses 
			ON #vwNeglectedOrDelinquentStatuses (
				NeglectedOrDelinquentLongTermStatusCode,
				NeglectedProgramTypeCode,
				DelinquentProgramTypeCode,
				NeglectedOrDelinquentProgramTypeCode,
				NeglectedOrDelinquentAcademicAchievementIndicatorMap,
				NeglectedOrDelinquentAcademicOutcomeIndicatorMap,
				EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap,
				EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap
			);

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'neglectedordelinquent'	--DimFactTypeId = 15


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
			, StatusStartDateNeglectedOrDelinquentId	int null
			, StatusEndDateNeglectedOrDelinquentId		int null
			, OutcomeExitDateNeglectedOrDelinquentId	int null
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
			, -1								 						MigrantStatusId						
			, -1														TitleIStatusId						
			, -1														TitleIIIStatusId						
			, -1														AttendanceId							
			, -1 														CohortStatusId						
			, ISNULL(rdnds.DimNOrDStatusId, -1)							NOrDStatusId							
			, -1														CTEStatusId							
			, -1														K12EnrollmentStatusId					
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, -1														HomelessnessStatusId					
			, -1														EconomicallyDisadvantagedStatusId		
			, -1														FosterCareStatusId					
			, -1														ImmigrantStatusId						
			, -1														PrimaryDisabilityTypeId				
			, -1														SpecialEducationServicesExitDateId	
			, -1														MigrantStudentQualifyingArrivalDateId	
			, -1														LastQualifyingMoveDateId	
			, ISNULL(BeginDate.DimDateId, -1)							StatusStartDateNeglectedOrDelinquentId
			, ISNULL(EndDate.DimDateId, -1)								StatusEndDateNeglectedOrDelinquentId
			, ISNULL(AwardDate.DimDateId, -1)							OutcomeExitDateNeglectedOrDelinquentId		

		FROM Staging.K12Enrollment ske

		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
			and ske.SchoolYear = @SchoolYear

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


	--negelected or delinquent
		LEFT JOIN Staging.ProgramParticipationNOrD nord
			ON ske.StudentIdentifierState = nord.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(nord.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(nord.SchoolIdentifierSea, '')
			AND nord.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)

	--idea disability status
		LEFT JOIN Staging.ProgramParticipationSpecialEducation idea
			ON ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND nord.ProgramParticipationBeginDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)

	--english learner
		LEFT JOIN Staging.PersonStatus el 
			ON ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND el.EnglishLearner_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)

	--race	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON spr.SchoolYear = @SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea
				OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)

	--neglected or delinquent (RDS)
		LEFT JOIN #vwNeglectedOrDelinquentStatuses rdnds
			ON rdnds.SchoolYear = @SchoolYear

			/* THESE WILL BE NEEDED FOR FS119 and FS127 but for now we are defaulting to 'MISSING' for FS218, FS219, FS220, FS221
			--AND ISNULL(nord.NeglectedProgramType, 'MISSING') = ISNULL(rdnds.NeglectedProgramTypeMap, rdnds.NeglectedProgramTypeCode)
			--AND ISNULL(nord.DelinquentProgramType, 'MISSING') = ISNULL(rdnds.DelinquentProgramTypeMap, rdnds.DelinquentProgramTypeCode)
			--AND ISNULL(nord.NeglectedOrDelinquentProgramType, 'MISSING') = ISNULL(rdnds.NeglectedOrDelinquentProgramTypeMap, rdnds.NeglectedOrDelinquentProgramTypeCode)
			*/

			AND rdnds.NeglectedOrDelinquentLongTermStatusCode = 'MISSING'
			AND rdnds.NeglectedProgramTypeCode = 'MISSING'
			AND rdnds.DelinquentProgramTypeCode = 'MISSING'
			AND rdnds.NeglectedOrDelinquentProgramTypeCode = 'MISSING'


			AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, 'MISSING') = ISNULL(rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap, rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode)
			AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, 'MISSING') = ISNULL(rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap, rdnds.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode)

			AND case 
					when nord.NeglectedOrDelinquentAcademicOutcomeIndicator = 1 then 'Yes'
					when nord.NeglectedOrDelinquentAcademicOutcomeIndicator = 0 then 'No'
					else 'MISSING'

				end
				= ISNULL(rdnds.NeglectedOrDelinquentAcademicOutcomeIndicatorMap, rdnds.NeglectedOrDelinquentAcademicOutcomeIndicatorCode)

			AND case 
					when nord.NeglectedOrDelinquentAcademicAchievementIndicator = 1 then 'Yes'
					when nord.NeglectedOrDelinquentAcademicAchievementIndicator = 0 then 'No'
					else 'MISSING'

				end
				= ISNULL(rdnds.NeglectedOrDelinquentAcademicAchievementIndicatorMap, rdnds.NeglectedOrDelinquentAcademicAchievementIndicatorCode)

	--idea disability (RDS)
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON rdis.SchoolYear = @SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
			AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
			AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'

	--english learner (RDS)
		LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rdels.SchoolYear = @SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND PerkinsEnglishLearnerStatusCode = 'MISSING'

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

	-- ProgramParticipationEndDate
		LEFT JOIN RDS.DimDates BeginDate 
			ON nord.ProgramParticipationEndDate = BeginDate.DateValue

	-- ProgramParticipationEndDate
		LEFT JOIN RDS.DimDates EndDate 
			ON nord.ProgramParticipationEndDate = EndDate.DateValue

	-- NorDDiplomaCredentialAwardDate
		LEFT JOIN RDS.DimDates AwardDate 
			ON nord.NeglectedOrDelinquentExitOutcomeDate = AwardDate.DateValue




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
			, StatusStartDateNeglectedOrDelinquentId
			, StatusEndDateNeglectedOrDelinquentId
			, OutcomeExitDateNeglectedOrDelinquentId

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
			, StatusStartDateNeglectedOrDelinquentId
			, StatusEndDateNeglectedOrDelinquentId
			, OutcomeExitDateNeglectedOrDelinquentId

		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

	--END TRY
	--BEGIN CATCH

	--	insert into app.DataMigrationHistories
	--		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())

	--END CATCH

END
