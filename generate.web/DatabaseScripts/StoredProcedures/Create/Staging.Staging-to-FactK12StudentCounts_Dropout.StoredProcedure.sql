/**********************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Dropout Data from Staging to RDS.FactK12StudentCounts

NOTE: This Stored Procedure processes files: 032

11/1/2023: Updated to properly set DimK12EnrollmentStatusId and improve performance
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_Dropout]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwEconomicallyDisadvantagedStatuses') IS NOT NULL DROP TABLE #vwEconomicallyDisadvantagedStatuses
		IF OBJECT_ID(N'tempdb..#vwHomelessnessStatuses') IS NOT NULL DROP TABLE #vwHomelessnessStatuses
		IF OBJECT_ID(N'tempdb..#vwMigrantStatuses') IS NOT NULL DROP TABLE #vwMigrantStatuses
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#tempELStatus') IS NOT NULL DROP TABLE #tempELStatus
		IF OBJECT_ID(N'tempdb..#tempMigrantStatus') IS NOT NULL DROP TABLE #tempMigrantStatus
		IF OBJECT_ID(N'tempdb..#tempHomelessStatus') IS NOT NULL DROP TABLE #tempHomelessStatus
		IF OBJECT_ID(N'tempdb..#tempEcoDisStatus') IS NOT NULL DROP TABLE #tempEcoDisStatus
		IF OBJECT_ID(N'tempdb..#tempIdeaStatus') IS NOT NULL DROP TABLE #tempIdeaStatus
		IF OBJECT_ID(N'tempdb..#tempDisabilityStatus') IS NOT NULL DROP TABLE #tempDisabilityStatus

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT,
		@SYStartDate DATE,
		@SYEndDate DATE,
		@DimK12EnrollmentStatusId int,
		@ExitOrWithdrawalTypeMap varchar(10)
		
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear)
		SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)

		select @DimK12EnrollmentStatusId = (
			select top 1 DimK12EnrollmentStatusId
			from rds.vwDimK12EnrollmentStatuses
			where ExitOrWithdrawalTypeCode = '01927'
				and EnrollmentStatusCode = 'MISSING'
				and EntryTypeCode = 'MISSING'
				and PostSecondaryEnrollmentStatusCode = 'MISSING'
				and EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = 'MISSING'
				and EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = 'MISSING'
				and SchoolYear = @SchoolYear
				)

		select @ExitOrWithdrawalTypeMap = (
			select top 1 ExitOrWithdrawalTypeMap
			from rds.vwDimK12EnrollmentStatuses
			where ExitOrWithdrawalTypeCode = '01927'
				and EnrollmentStatusCode = 'MISSING'
				and EntryTypeCode = 'MISSING'
				and PostSecondaryEnrollmentStatusCode = 'MISSING'
				and EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = 'MISSING'
				and EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = 'MISSING'
				and SchoolYear = @SchoolYear
				)

	--Get the set of students from DimPeople to be used for the migrated SY
		if object_id(N'tempdb..#dimPeople') is not null drop table #dimPeople

		select K12StudentStudentIdentifierState
			, max(DimPersonId)								DimPersonId
			, min(RecordStartDateTime)						RecordStartDateTime
			, max(isnull(RecordEndDateTime, @SYEndDate))	RecordEndDateTime
			, max(isnull(birthdate, '1900-01-01'))			BirthDate
		into #dimPeople
		from rds.DimPeople
		where ((RecordStartDateTime < @SYStartDate and isnull(RecordEndDateTime, @SYEndDate) > @SYStartDate)
			or (RecordStartDateTime >= @SYStartDate and isnull(RecordEndDateTime, @SYEndDate) <= @SYEndDate))
		and IsActiveK12Student = 1
		group by K12StudentStudentIdentifierState
		order by K12StudentStudentIdentifierState

		create index IDX_dimPeople ON #dimPeople (K12StudentStudentIdentifierState, DimPersonId, RecordStartDateTime, RecordEndDateTime, Birthdate)

	--reset the RecordStartDateTime if the date is prior to the default start date of 7/1
		update #dimPeople
		set RecordStartDateTime = @SYStartDate
		where RecordStartDateTime < @SYStartDate

	--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwGradeLevels
		FROM RDS.vwDimGradeLevels
		WHERE SchoolYear = @SchoolYear
			AND GradeLevelTypeDescription = 'Exit Grade Level'

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels 
			ON #vwGradeLevels (GradeLevelMap);

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
			AND HomelessPrimaryNighttimeResidenceCode =  'MISSING'
			AND HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND HomelessServicedIndicatorCode = 'MISSING'

		SELECT *
		INTO #vwEconomicallyDisadvantagedStatuses
		FROM RDS.vwDimEconomicallyDisadvantagedStatuses
		WHERE SchoolYear = @SchoolYear
			AND EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
			AND NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'

		CREATE CLUSTERED INDEX ix_tempvwEconomicallyDisadvantagedStatuses
			ON #vwEconomicallyDisadvantagedStatuses (EconomicDisadvantageStatusMap) --, EligibilityStatusForSchoolFoodServiceProgramsMap, NationalSchoolLunchProgramDirectCertificationIndicatorMap);

		SELECT *
		INTO #vwMigrantStatuses
		FROM RDS.vwDimMigrantStatuses
		WHERE SchoolYear = @SchoolYear
			AND MigrantEducationProgramEnrollmentTypeCode = 'MISSING' 
			AND ContinuationOfServicesReasonCode = 'MISSING'
			AND MigrantEducationProgramServicesTypeCode = 'MISSING'
			AND MigrantPrioritizedForServicesCode = 'MISSING'
			AND MEPContinuationOfServicesStatusCode = 'MISSING'
			and ConsolidatedMEPFundsStatusCode = 'MISSING'

		CREATE CLUSTERED INDEX ix_tempvwMigrantStatuses
			ON #vwMigrantStatuses (MigrantStatusMap) --, MigrantEducationProgramEnrollmentTypeCode, ContinuationOfServicesReasonCode, MigrantEducationProgramServicesTypeCode, MigrantPrioritizedForServicesCode, MEPContinuationOfServicesStatusCode, ConsolidatedMepFundsStatusCode);

	--Pull the EL Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
			, SchoolYear
		INTO #tempELStatus
		FROM Staging.PersonStatus
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempELStatus 
		CREATE INDEX IX_tempELStatus 
			ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusEndDate)

	--Pull the IDEA Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, IdeaIndicator
			, ProgramParticipationBeginDate
			, ProgramParticipationEndDate
			, SchoolYear
		INTO #tempIdeaStatus
		FROM Staging.ProgramParticipationSpecialEducation
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempIdeaStatus 
		CREATE INDEX IX_tempIdeaStatus 
			ON #tempIdeaStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationBeginDate, ProgramParticipationEndDate)

	--Pull the Disability Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, DisabilityStatus
			, Section504Status
			, Disability_StatusStartDate
			, Disability_StatusEndDate
			, SchoolYear
		INTO #tempDisabilityStatus
		FROM Staging.Disability
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempIdeaStatus 
		CREATE INDEX IX_tempDisabilityStatus 
			ON #tempDisabilityStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Disability_StatusStartDate, Disability_StatusEndDate)

	--Pull the Migrant Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MigrantStatus
			, Migrant_StatusStartDate
			, Migrant_StatusEndDate
			, SchoolYear
		INTO #tempMigrantStatus
		FROM Staging.PersonStatus
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempMigrantStatus 
		CREATE INDEX IX_tempMigrantStatus 
			ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant_StatusStartDate, Migrant_StatusEndDate)

	--Pull the Homeless Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, HomelessnessStatus
			, Homelessness_StatusStartDate
			, Homelessness_StatusEndDate
			, SchoolYear
		INTO #tempHomelessStatus
		FROM Staging.PersonStatus
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempHomelessStatus
		CREATE INDEX IX_tempHomelessStatus 
			ON #tempHomelessStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Homelessness_StatusStartDate, Homelessness_StatusEndDate)

	--Pull the Economic Disadvantage Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EconomicDisadvantageStatus
			, EconomicDisadvantage_StatusStartDate
			, EconomicDisadvantage_StatusEndDate
			, SchoolYear
		INTO #tempEcoDisStatus
		FROM Staging.PersonStatus
		WHERE SchoolYear = @SchoolYear

	-- Create Index for #tempEcoDisStatus
		CREATE INDEX IX_tempEcoDisStatus 
			ON #tempEcoDisStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EconomicDisadvantage_StatusStartDate, EconomicDisadvantage_StatusEndDate)

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'dropout'	--DimFactTypeId = 7

		--Clear the Fact table of the data about to be migrated  
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
		SELECT 
		DISTINCT
			ske.id														StagingId								
			, rsy.DimSchoolYearId										SchoolYearId							
			, @FactTypeId												FactTypeId							
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelId							
			, -1 														AgeId									
			, ISNULL(rdr.DimRaceId, -1)									RaceId								
			, ISNULL(rdkd.DimK12DemographicId, -1)						K12DemographicId						
			, 1															StudentCount							
			, ISNULL(rds.DimSeaId, -1)									SEAId									
			, -1														IEUId									
			, ISNULL(rdl.DimLeaID, -1)									LEAId									
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId							
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId							
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId							
			, ISNULL(rdds.DimDisabilityStatusId, -1)						DisabilityStatusId							
			, -1														LanguageId							
			, ISNULL(rdms.DimMigrantStatusId, -1) 						MigrantStatusId						
			, -1														TitleIStatusId						
			, -1														TitleIIIStatusId						
			, -1														AttendanceId							
			, -1 														CohortStatusId						
			, -1														NOrDStatusId							
			, -1														CTEStatusId							
			, @DimK12EnrollmentStatusId									K12EnrollmentStatusId					
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, ISNULL(rdhs.DimHomelessnessStatusId, -1)					HomelessnessStatusId					
			, ISNULL(rdeds.DimEconomicallyDisadvantagedStatusId, -1)	EconomicallyDisadvantagedStatusId		
			, -1														FosterCareStatusId					
			, -1														ImmigrantStatusId						
			, -1														PrimaryDisabilityTypeId				
			, -1														SpecialEducationServicesExitDateId	
			, -1														MigrantStudentQualifyingArrivalDateId	
			, -1														LastQualifyingMoveDateId						

		FROM Staging.K12Enrollment ske
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		JOIN RDS.DimSeas rds
			ON ske.EnrollmentEntryDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEndDate)
	--demographics			
		JOIN RDS.vwDimK12Demographics rdkd
 			ON rsy.SchoolYear = rdkd.SchoolYear
			AND ISNULL(ske.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
		JOIN #dimPeople rdp
			ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
			AND ske.EnrollmentEntryDate BETWEEN convert(date, rdp.RecordStartDateTime) AND convert(date, ISNULL(rdp.RecordEndDateTime, @SYEndDate))
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @SYEndDate)
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND ske.EnrollmentEntryDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @SYEndDate)
	--homeless
		LEFT JOIN #tempHomelessStatus hmStatus
			ON ske.SchoolYear = hmStatus.SchoolYear		
			AND ske.StudentIdentifierState = hmStatus.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
			AND ((hmStatus.Homelessness_StatusStartDate <= ske.EnrollmentEntryDate and isnull(hmStatus.Homelessness_StatusEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (hmStatus.Homelessness_StatusStartDate > ske.EnrollmentEntryDate and hmStatus.Homelessness_StatusStartDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--idea disability status
		LEFT JOIN #tempIdeaStatus idea
			ON ske.SchoolYear = idea.SchoolYear		
			AND ske.StudentIdentifierState = idea.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(idea.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(idea.SchoolIdentifierSea, '')
			AND ((idea.ProgramParticipationBeginDate <= ske.EnrollmentEntryDate and isnull(idea.ProgramParticipationEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (idea.ProgramParticipationBeginDate > ske.EnrollmentEntryDate and idea.ProgramParticipationBeginDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--504 disability status
		LEFT JOIN #tempDisabilityStatus disab
			ON ske.SchoolYear = disab.SchoolYear		
			AND ske.StudentIdentifierState = disab.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(disab.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(disab.SchoolIdentifierSea, '')
			AND ((disab.Disability_StatusStartDate <= ske.EnrollmentEntryDate and isnull(disab.Disability_StatusEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (disab.Disability_StatusStartDate > ske.EnrollmentEntryDate and disab.Disability_StatusStartDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--economic disadvantage
		LEFT JOIN #tempEcoDisStatus ecoDis
			ON ske.SchoolYear = ecoDis.SchoolYear		
			AND ske.StudentIdentifierState = ecoDis.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(ecoDis.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(ecoDis.SchoolIdentifierSea, '')
			AND ((ecoDis.EconomicDisadvantage_StatusStartDate <= ske.EnrollmentEntryDate and isnull(ecoDis.EconomicDisadvantage_StatusEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (ecoDis.EconomicDisadvantage_StatusStartDate > ske.EnrollmentEntryDate and ecoDis.EconomicDisadvantage_StatusStartDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--english learner
		LEFT JOIN #tempELStatus el 
			ON ske.SchoolYear = el.SchoolYear		
			AND ske.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND ((el.EnglishLearner_StatusStartDate <= ske.EnrollmentEntryDate and isnull(el.EnglishLearner_StatusEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (el.EnglishLearner_StatusStartDate > ske.EnrollmentEntryDate and el.EnglishLearner_StatusStartDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--migratory status	
		LEFT JOIN #tempMigrantStatus migrant
			ON ske.SchoolYear = migrant.SchoolYear		
			AND ske.StudentIdentifierState = migrant.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
			AND ((migrant.Migrant_StatusStartDate <= ske.EnrollmentEntryDate and isnull(migrant.Migrant_StatusEndDate, @SYEndDate) > ske.EnrollmentEntryDate)
				or (migrant.Migrant_StatusStartDate > ske.EnrollmentEntryDate and migrant.Migrant_StatusStartDate < isnull(ske.EnrollmentExitDate, @SYEndDate)))
	--race	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(spr.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(spr.SchoolIdentifierSea,'')
	--homelessness (RDS)
		LEFT JOIN #vwHomelessnessStatuses rdhs
			ON ISNULL(CAST(hmStatus.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
	--idea disability (RDS)
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON ske.SchoolYear = rdis.SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = ISNULL(rdis.IdeaIndicatorMap, -1)
			AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'
			AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'
	--504 disability (RDS)
		LEFT JOIN RDS.vwDimDisabilityStatuses rdds
			ON rsy.SchoolYear = rdds.SchoolYear
			AND ISNULL(CAST(disab.DisabilityStatus AS SMALLINT), -1) = ISNULL(rdds.DisabilityStatusMap, -1)
			AND ISNULL(CAST(disab.Section504Status AS SMALLINT), -1) = ISNULL(rdds.Section504StatusMap, -1)
			AND rdds.DisabilityConditionTypeCode = 'MISSING'
			AND rdds.DisabilityDeterminationSourceTypeCode = 'MISSING'
	--economically disadvantaged (RDS)
		LEFT JOIN #vwEconomicallyDisadvantagedStatuses rdeds
			ON rsy.SchoolYear = rdeds.SchoolYear
			AND ISNULL(CAST(ecoDis.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(rdeds.EconomicDisadvantageStatusMap, -1)
	--english learner (RDS)
		LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rsy.SchoolYear = rdels.SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND PerkinsEnglishLearnerStatusCode = 'MISSING'
	--migrant (RDS)
		LEFT JOIN #vwMigrantStatuses rdms
			ON ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
	--grade (RDS)
		LEFT JOIN #vwGradeLevels rgls
			ON ske.GradeLevel = rgls.GradeLevelMap
	--race (RDS)	
		LEFT JOIN #vwRaces rdr
			ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
				CASE
					when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
					WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
					ELSE 'Missing'
				END
		WHERE ske.ExitOrWithdrawalType = @ExitOrWithdrawalTypeMap

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
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())
	END CATCH

END
