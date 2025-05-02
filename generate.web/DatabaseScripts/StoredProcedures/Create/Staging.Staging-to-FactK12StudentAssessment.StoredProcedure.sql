/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Assessment Data from Staging to RDS.FactK12StudentAssessments

NOTE: This Stored Procedure processes files: 175, 178, 179, 185, 188, 189, 224, 225

JW 11/16/2023: Made changes to address join issues
JW 4/10/2024: Added NorD Logic
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentAssessment]
	@SchoolYear SMALLINT
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwAssessments') IS NOT NULL DROP TABLE #vwAssessments
		IF OBJECT_ID(N'tempdb..#vwAssessmentResults') IS NOT NULL DROP TABLE #vwAssessmentResults
		IF OBJECT_ID(N'tempdb..#vwAssessmentRegistrations') IS NOT NULL DROP TABLE #vwAssessmentRegistrations

		IF OBJECT_ID(N'tempdb..#tempIdeaStatus') IS NOT NULL DROP TABLE #tempIdeaStatus
		IF OBJECT_ID(N'tempdb..#tempTitleIIIStatus') IS NOT NULL DROP TABLE #tempTitleIIIStatus
		IF OBJECT_ID(N'tempdb..#tempELStatus') IS NOT NULL DROP TABLE #tempELStatus
		IF OBJECT_ID(N'tempdb..#tempMigrantStatus') IS NOT NULL DROP TABLE #tempMigrantStatus
		IF OBJECT_ID(N'tempdb..#tempMilitaryStatus') IS NOT NULL DROP TABLE #tempMilitaryStatus
		IF OBJECT_ID(N'tempdb..#tempHomelessnessStatus') IS NOT NULL DROP TABLE #tempHomelessnessStatus
		IF OBJECT_ID(N'tempdb..#tempFosterCareStatus') IS NOT NULL DROP TABLE #tempFosterCareStatus
		IF OBJECT_ID(N'tempdb..#tempEconomicallyDisadvantagedStatus') IS NOT NULL DROP TABLE #tempEconomicallyDisadvantagedStatus
		IF OBJECT_ID(N'tempdb..#tempStagingAssessmentResults') IS NOT NULL DROP TABLE #tempStagingAssessmentResults
		IF OBJECT_ID(N'tempdb..#tempAssessmentAdministrations') IS NOT NULL DROP TABLE #tempAssessmentAdministrations
		IF OBJECT_ID(N'tempdb..#tempLeas') IS NOT NULL DROP TABLE #tempLeas
		IF OBJECT_ID(N'tempdb..#tempK12Schools') IS NOT NULL DROP TABLE #tempK12Schools
		IF OBJECT_ID(N'tempdb..#vwNOrDStatuses') IS NOT NULL DROP TABLE #vwNOrDStatuses
		IF OBJECT_ID(N'tempdb..#tempNorDStudents') IS NOT NULL DROP TABLE #tempNorDStudents
		IF OBJECT_ID(N'tempdb..#tempAccomodations') IS NOT NULL DROP TABLE #tempAccomodations

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT,
		@SYStartDate DATE,
		@SYEndDate DATE,
		@Today Date = convert(date, getdate())
		
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SET @SYStartDate = staging.GetFiscalYearStartDate(@SchoolYear)
		SET @SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)

	--Setting variables to be used in the select statements 
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

	--Get the set of students from DimPeople to be used for the migrated SY
		select K12StudentStudentIdentifierState
			, max(DimPersonId)								DimPersonId
			, min(RecordStartDateTime)						RecordStartDateTime
			, max(isnull(RecordEndDateTime, @SYEndDate))	RecordEndDateTime
			, max(isnull(birthdate, '1900-01-01'))			BirthDate
		into #dimPeople
		from rds.DimPeople
		where ((RecordStartDateTime <= @SYStartDate and RecordEndDateTime > @SYStartDate)
			or (RecordStartDateTime > @SYStartDate and isnull(RecordEndDateTime, @SYEndDate) <= @SYEndDate))
		and IsActiveK12Student = 1
		group by K12StudentStudentIdentifierState
		order by K12StudentStudentIdentifierState

	--reset the RecordStartDateTime if the date is prior to the default start date of 7/1
		update #dimPeople
		set RecordStartDateTime = @SYStartDate
		where RecordStartDateTime < @SYStartDate

	--Create the temp views (and any relevant indexes) needed for this domain
	-- #vwNOrDStatuses
		SELECT *
		INTO #vwNOrDStatuses
		FROM RDS.vwDimNOrDStatuses
		WHERE SchoolYear = @SchoolYear
			AND NeglectedOrDelinquentLongTermStatusCode = 'MISSING'
			AND NeglectedOrDelinquentProgramTypeCode = 'MISSING'
			AND NeglectedProgramTypeCode = 'MISSING'
			AND DelinquentProgramTypeCode = 'MISSING'
			AND NeglectedOrDelinquentAcademicAchievementIndicatorCode = 'MISSING'
			and NeglectedOrDelinquentAcademicOutcomeIndicatorCode = 'MISSING'
			AND EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = 'MISSING'
			AND EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = 'MISSING'
--			AND NeglectedOrDelinquentStatusCode = 'MISSING'

		--CREATE CLUSTERED INDEX ix_tempvwNOrDStatuses 
		--	ON #vwNOrDStatuses (
		--		NeglectedOrDelinquentProgramEnrollmentSubpartCode,
		--		NeglectedOrDelinquentLongTermStatusCode,
		--		NeglectedProgramTypeCode,
		--		DelinquentProgramTypeCode,
		--		NeglectedOrDelinquentProgramTypeCode,
		--		NeglectedOrDelinquentAcademicAchievementIndicatorMap,
		--		NeglectedOrDelinquentAcademicOutcomeIndicatorMap,
		--		EdFactsAcademicOrCareerAndTechnicalOutcomeTypeMap,
		--		EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeMap
		--	);

	-- #tempNorDStudents
		SELECT DISTINCT sppnord.StudentIdentifierState, sppnord.LeaIdentifierSeaAccountability, vw.DimNOrDStatusId
		INTO #tempNorDStudents
		FROM Staging.ProgramParticipationNorD sppnord
		INNER JOIN Staging.AssessmentResult sar
			ON sppnord.SchoolYear = sar.SchoolYear
			AND sppnord.StudentIdentifierState = sar.StudentIdentifierState
			AND sar.LeaIdentifierSeaAccountability = isnull(sppnord.LeaIdentifierSeaAccountability,'')
			AND sar.SchoolIdentifierSea = isnull(sppnord.SchoolIdentifierSea, '')
			AND sppnord.ProgramParticipationBeginDate <= CAST('6/30/' + CAST(sar.SchoolYear AS VARCHAR(4)) AS Date) -- Only students who were in the program during the school year
			AND isnull(sppnord.ProgramParticipationEndDate, '1/1/9999') >= CAST('7/1/' + CAST(sar.SchoolYear - 1 AS VARCHAR(10))  AS Date) -- Only students who were in the program during the school year
		LEFT JOIN #vwNOrDStatuses vw
			ON vw.SchoolYear = @SchoolYear
			AND vw.NeglectedOrDelinquentProgramEnrollmentSubpartMap = sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart
			AND vw.NeglectedOrDelinquentStatusMap = sppnord.NeglectedOrDelinquentStatus
		WHERE sppnord.NeglectedOrDelinquentProgramEnrollmentSubpart IS NOT NULL
			AND sppnord.NeglectedOrDelinquentStatus = 1 -- Only get NorD students

		CREATE INDEX IX_NorD 
			ON #tempNorDStudents(StudentIdentifierState, LeaIdentifierSeaAccountability)

	-- #vwAssessments
		SELECT *
		INTO #vwAssessments
		FROM RDS.vwDimAssessments
		WHERE SchoolYear = @SchoolYear

		CREATE NONCLUSTERED INDEX ix_tempvwAssessments -- JW
			ON #vwAssessments (AssessmentTitle, AssessmentTypeMap, AssessmentTypeAdministeredMap, AssessmentTypeAdministeredToEnglishLearnersMap);


	-- #vwAssessmentResults
		SELECT *
		INTO #vwAssessmentResults
		FROM RDS.vwDimAssessmentResults
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwAssessmentResults 
			ON #vwAssessmentResults (AssessmentScoreMetricTypeMap);

	-- #vwAssessmentRegistrations
		SELECT *
		INTO #vwAssessmentRegistrations
		FROM RDS.vwDimAssessmentRegistrations
		WHERE SchoolYear = @SchoolYear
			AND StateFullAcademicYearCode = 'MISSING'
			AND LeaFullAcademicYearCode = 'MISSING'
			AND SchoolFullAcademicYearCode = 'MISSING'
			AND AssessmentRegistrationCompletionStatusCode = 'MISSING'

		CREATE CLUSTERED INDEX ix_tempvwAssessmentRegistrations 
			ON #vwAssessmentRegistrations (AssessmentRegistrationParticipationIndicatorMap, AssessmentRegistrationReasonNotCompletingMap);

	-- #vwGradeLevels
		SELECT *
		INTO #vwGradeLevels
		FROM RDS.vwDimGradeLevels
		WHERE SchoolYear = @SchoolYear
		and GradeLevelTypeDescription = 'Grade Level When Assessed'

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels 
			ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

	-- #vwRaces
		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces 
			ON #vwRaces (RaceMap);

	-- #tempStagingAssessmentResults 
		SELECT sar.*, sa.AssessmentShortName, sa.AssessmentFamilyTitle, sa.AssessmentFamilyShortName
		INTO #tempStagingAssessmentResults
		FROM staging.assessmentresult sar
		LEFT JOIN Staging.Assessment sa
			ON ISNULL(sar.AssessmentIdentifier,'') = ISNULL(sa.AssessmentIdentifier,'')
			AND ISNULL(sar.AssessmentTitle, '') = ISNULL(sa.AssessmentTitle, '')
			AND ISNULL(sar.AssessmentAcademicSubject, '') = ISNULL(sa.AssessmentAcademicSubject, '') 
			AND ISNULL(sar.AssessmentPerformanceLevelIdentifier, '') = ISNULL(sa.AssessmentPerformanceLevelIdentifier, '') 
			AND ISNULL(sar.AssessmentTypeAdministered,'') = ISNULL(sa.AssessmentTypeAdministered,'')
		WHERE sar.schoolyear = @SchoolYear
		AND sar.AssessmentAdministrationStartDate is not null

		CREATE INDEX IX_tempStagingAssessment 
			ON #tempStagingAssessmentResults(
				StudentIdentifierState, AssessmentAdministrationStartDate, AssessmentAdministrationFinishDate, 
				LeaIdentifierSeaAccountability, SchoolIdentifierSea, AssessmentIdentifier, AssessmentFamilyTitle, 
				AssessmentFamilyShortName, AssessmentShortName, AssessmentTitle, AssessmentAcademicSubject, AssessmentType, 
				AssessmentTypeAdministered, AssessmentTypeAdministeredToEnglishLearners, AssessmentScoreMetricType)

	-- #tempLeas 
		SELECT DimLeaId, LeaIdentifierSea, convert(date, RecordStartDateTime) RecordStartDateTime, convert(date, RecordEndDateTime) RecordEndDateTime
		INTO #tempLeas
		FROM RDS.DimLeas
		WHERE convert(date, RecordStartDateTime) between @SYStartDate and @SYEndDate

		CREATE INDEX IX_tempLeas
			ON #tempLeas(LeaIdentifierSea, RecordStartDateTime, RecordEndDateTime)

	-- #tempK12Schools
		SELECT DimK12SchoolId, SchoolIdentifierSea, convert(date, RecordStartDateTime) RecordStartDateTime, convert(date, RecordEndDateTime) RecordEndDateTime
		INTO #tempK12Schools
		FROM RDS.DimK12Schools
		WHERE convert(date, RecordStartDateTime) between @SYStartDate and @SYEndDate

		CREATE INDEX IX_tempK12Schools
			ON #tempK12Schools(SchoolIdentifierSea, RecordStartDateTime, RecordEndDateTime)

	-- #tempAssessmentAdministrations
		SELECT DimAssessmentAdministrationId, AssessmentIdentifier, AssessmentIdentificationSystem, 
			AssessmentAdministrationCode, AssessmentAdministrationName,
			convert(date, AssessmentAdministrationStartDate) AssessmentAdministrationStartDate,
			convert(date, AssessmentAdministrationFinishDate) AssessmentAdministrationFinishDate,
			AssessmentAdministrationAssessmentFamily, SchoolIdentifierSEA, SchoolIdentificationSystem,
			LEAIdentifierSea, LEAIdentificationSystem, AssessmentAdministrationOrganizationName, 
			AssessmentAdministrationPeriodDescription, AssessmentSecureIndicator
		INTO #tempAssessmentAdministrations
		FROM RDS.DimAssessmentAdministrations
		WHERE AssessmentAdministrationStartDate between @SYStartDate and @SYEndDate
		AND AssessmentAdministrationFinishDate between @SYStartDate and @SYEndDate

		CREATE INDEX IX_tempAssessmentAdministrations 
			ON #tempAssessmentAdministrations(
				LeaIdentifierSea, SchoolIdentifierSea,
				AssessmentAdministrationAssessmentFamily, AssessmentAdministrationStartDate, AssessmentAdministrationFinishDate)

	-- #tempIdeaStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, IDEAIndicator
			, IdeaEducationalEnvironmentForSchoolAgeCode
			, ProgramParticipationBeginDate
			, ProgramParticipationEndDate
			, rvdis.DimIdeaStatusId
			, sppse.SchoolYear
		INTO #tempIdeaStatus
		FROM Staging.ProgramParticipationSpecialEducation sppse
		INNER JOIN RDS.vwDimIdeaStatuses rvdis
			ON sppse.SchoolYear = @SchoolYear
			AND ISNULL(CAST(sppse.IDEAIndicator AS SMALLINT), -1) = ISNULL(rvdis.IdeaIndicatorMap, -1)
			AND rvdis.SpecialEducationExitReasonCode = 'MISSING'
			AND rvdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
			AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge,'MISSING') = ISNULL(rvdis.IdeaEducationalEnvironmentForSchoolAgeMap, rvdis.IdeaEducationalEnvironmentForSchoolAgeCode)
		WHERE sppse.IDEAIndicator = 1

		CREATE INDEX IX_tempIdeaStatus 
			ON #tempIdeaStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationBeginDate, ProgramParticipationEndDate)

	-- #tempELStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
			, rdels.DimEnglishLearnerStatusId
			, sps.SchoolYear
		INTO #tempELStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON sps.SchoolYear = rdels.SchoolYear
			AND ISNULL(CAST(sps.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'

		CREATE INDEX IX_tempELStatus 
			ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusEndDate)
								
	-- #tempMigrantStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MigrantStatus
			, Migrant_StatusStartDate
			, Migrant_StatusEndDate
			, rdms.DimMigrantStatusId
			, sps.SchoolYear
		INTO #tempMigrantStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimMigrantStatuses rdms
			ON sps.SchoolYear = rdms.SchoolYear
			AND ISNULL(CAST(sps.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
			AND rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING' 
			AND rdms.ContinuationOfServicesReasonCode = 'MISSING'
			AND rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
			AND rdms.ConsolidatedMEPFundsStatusCode = 'MISSING'
			AND rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
			AND rdms.MigrantPrioritizedForServicesCode = 'MISSING'

		CREATE INDEX IX_tempMigrantStatus 
			ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant_StatusStartDate, Migrant_StatusEndDate)

	-- #tempHomelessnessStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, HomelessnessStatus
			, Homelessness_StatusStartDate
			, Homelessness_StatusEndDate
			, rdhs.DimHomelessnessStatusId
			, sps.SchoolYear
		INTO #tempHomelessnessStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimHomelessnessStatuses rdhs
			ON sps.SchoolYear = rdhs.SchoolYear
			AND ISNULL(CAST(sps.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
			AND rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdhs.HomelessServicedIndicatorCode = 'MISSING'

		CREATE INDEX IX_tempHomelessnessStatus 
			ON #tempHomelessnessStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Homelessness_StatusStartDate, Homelessness_StatusEndDate)
				
	-- #tempFosterCareStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, ProgramType_FosterCare
			, FosterCare_ProgramParticipationStartDate
			, FosterCare_ProgramParticipationEndDate
			, rdfcs.DimFosterCareStatusId
			, sps.SchoolYear
		INTO #tempFosterCareStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimFosterCareStatuses rdfcs
			ON sps.SchoolYear = rdfcs.SchoolYear
			AND ISNULL(CAST(sps.ProgramType_FosterCare AS SMALLINT), -1) = ISNULL(CAST(rdfcs.ProgramParticipationFosterCareMap AS SMALLINT), -1)

		CREATE INDEX IX_tempFosterCareStatus 
			ON #tempFosterCareStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, FosterCare_ProgramParticipationStartDate, FosterCare_ProgramParticipationEndDate)

	-- #tempEconomicallyDisadvantagedStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EconomicDisadvantageStatus
			, EconomicDisadvantage_StatusStartDate
			, EconomicDisadvantage_StatusEndDate
			, rdeds.DimEconomicallyDisadvantagedStatusId
			, sps.SchoolYear
		INTO #tempEconomicallyDisadvantagedStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimEconomicallyDisadvantagedStatuses rdeds
			ON sps.SchoolYear = rdeds.SchoolYear
			AND ISNULL(CAST(sps.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(CAST(rdeds.EconomicDisadvantageStatusMap AS SMALLINT), -1)
			AND rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
			AND rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'

		CREATE INDEX IX_tempEconomicallyDisadvantagedStatus
			ON #tempEconomicallyDisadvantagedStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EconomicDisadvantage_StatusStartDate, EconomicDisadvantage_StatusEndDate)
				
	-- #tempMilitaryStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MilitaryConnectedStudentIndicator
			, MilitaryConnected_StatusStartDate
			, MilitaryConnected_StatusEndDate
			, rdmils.DimMilitaryStatusId
			, sps.SchoolYear
		INTO #tempMilitaryStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimMilitaryStatuses rdmils
			ON sps.SchoolYear = rdmils.SchoolYear
			AND ISNULL(sps.MilitaryConnectedStudentIndicator, 'MISSING') = ISNULL(rdmils.MilitaryConnectedStudentIndicatorMap, rdmils.MilitaryConnectedStudentIndicatorCode)
			AND rdmils.MilitaryActiveStudentIndicatorCode = 'MISSING'
			AND rdmils.MilitaryBranchCode = 'MISSING'
			AND rdmils.MilitaryVeteranStudentIndicatorCode = 'MISSING'
		WHERE sps.MilitaryConnectedStudentIndicator is not null

		CREATE INDEX IX_tempMilitaryStatus 
			ON #tempMilitaryStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, MilitaryConnected_StatusStartDate, MilitaryConnected_StatusEndDate)

	-- #tempTitleIIIStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, TitleIIIAccountabilityProgressStatus
			, ProgramParticipationBeginDate
			, ProgramParticipationEndDate
			, rvdt3s.DimTitleIIIStatusId
			, sppt3.SchoolYear
		INTO #tempTitleIIIStatus
		FROM Staging.ProgramParticipationTitleIII sppt3
		INNER JOIN RDS.vwDimTitleIIIStatuses rvdt3s
			ON sppt3.SchoolYear = rvdt3s.SchoolYear
			AND rvdt3s.TitleIIIImmigrantParticipationStatusCode 				= 'MISSING'
			AND rvdt3s.TitleIIILanguageInstructionProgramTypeCode 				= 'MISSING'
			AND rvdt3s.ProficiencyStatusCode 									= 'MISSING'
			AND ISNULL(sppt3.TitleIIIAccountabilityProgressStatus, 'MISSING') 	= ISNULL(rvdt3s.TitleIIIAccountabilityProgressStatusMap, rvdt3s.TitleIIIAccountabilityProgressStatusCode)
			AND rvdt3s.ProgramParticipationTitleIIILiepCode 					= 'MISSING'
		WHERE sppt3.TitleIIIAccountabilityProgressStatus is not null

		CREATE INDEX IX_tempTitleIIIStatus 
			ON #tempTitleIIIStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationBeginDate, ProgramParticipationEndDate)

	--Set the Fact Type	
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'assessment'  --Assessments is still in the submission group

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts

	--Create and load #Facts temp table
		CREATE TABLE #Facts (
			SchoolYearId									int null
			, FactTypeId									int null
			, SeaId											int null		
			, IeuId											int null	
			, LeaId											int null	
			, K12SchoolId									int null	
			, K12StudentId									int null	
			, GradeLevelWhenAssessedId						int null	
			, AssessmentId									int null	
			, AssessmentSubtestId							int null		
			, AssessmentAdministrationId					int null		
			, AssessmentRegistrationId						int null	
			, AssessmentParticipationSessionId				int null	
			, AssessmentResultId							int null	
			, AssessmentPerformanceLevelId					int null		
			, AssessmentCount								int null	
			, AssessmentResultScoreValueRawScore			nvarchar(35) null	
			, AssessmentResultScoreValueScaleScore			nvarchar(35) null	
			, AssessmentResultScoreValuePercentile			nvarchar(35) null	
			, AssessmentResultScoreValueTScore				nvarchar(35) null	
			, AssessmentResultScoreValueZScore				nvarchar(35) null	
			, AssessmentResultScoreValueACTScore			nvarchar(35) null	
			, AssessmentResultScoreValueSATScore			nvarchar(35) null	
			, CompetencyDefinitionId						int null
			, CteStatusId									int null
			, HomelessnessStatusId					 		int null
			, EconomicallyDisadvantagedStatusId				int null	
			, EnglishLearnerStatusId						int null	
			, FosterCareStatusId							int null	
			, IdeaStatusId									int null	
			, ImmigrantStatusId								int null	
			, K12DemographicId								int null	
			, MigrantStatusId								int null	
			, MilitaryStatusId								int null	
			, NOrDStatusId									int null	
			, TitleIStatusId								int null	
			, TitleIIIStatusId								int null	
			, FactK12StudentAssessmentAccommodationId		int null	
			, PrimaryDisabilityTypeId						int null
		)

		INSERT INTO #Facts
		SELECT DISTINCT
			rsy.DimSchoolYearId												SchoolYearId							
			, @FactTypeId													FactTypeId							
			, ISNULL(rds.DimSeaId, -1)										SeaId									
			, -1															IeuId									
			, ISNULL(rdl.DimLeaID, -1)										LeaId									
			, ISNULL(rdksch.DimK12SchoolId, -1)								K12SchoolId							
			, ISNULL(rdp.DimPersonId, -1)									K12StudentId							
			, ISNULL(rgls.DimGradeLevelId, -1)								GradeLevelWhenAssessedId				
			, ISNULL(rda.DimAssessmentId, -1)								AssessmentId							
			, -1															AssessmentSubtestId					
			, ISNULL(rdaa.DimAssessmentAdministrationId, -1)				AssessmentAdministrationId			
			, ISNULL(rdars.DimAssessmentRegistrationId, -1)					AssessmentRegistrationId				
			, -1															AssessmentParticipationSessionId		
			, ISNULL(rdar.DimAssessmentResultId, -1)						AssessmentResultId					
			, ISNULL(rdapl.DimAssessmentPerformanceLevelId, -1)				AssessmentPerformanceLevelId			
			, 1																AssessmentCount						
			, ISNULL(sar.ScoreValue, -1)									AssessmentResultScoreValueRawScore	
			, -1															AssessmentResultScoreValueScaleScore	
			, -1															AssessmentResultScoreValuePercentile	
			, -1															AssessmentResultScoreValueTScore		
			, -1															AssessmentResultScoreValueZScore		
			, -1															AssessmentResultScoreValueACTScore	
			, -1										 					AssessmentResultScoreValueSATScore	
			, -1										 					CompetencyDefinitionId				
			, -1															CteStatusId							
			, ISNULL(hmStatus.DimHomelessnessStatusId, -1)					HomelessnessStatusId					 
			, ISNULL(ecoDisStatus.DimEconomicallyDisadvantagedStatusId, -1)	EconomicallyDisadvantagedStatusId		
			, ISNULL(el.DimEnglishLearnerStatusId, -1)						EnglishLearnerStatusId				
			, ISNULL(foster.DimFosterCareStatusId, -1)						FosterCareStatusId					
			, ISNULL(idea.DimIdeaStatusId, -1)								IdeaStatusId							
			, -1															ImmigrantStatusId						
			, ISNULL(rdkd.DimK12DemographicId, -1)							K12DemographicId						
			, ISNULL(migrant.DimMigrantStatusId, -1)						MigrantStatusId						
			, ISNULL(military.DimMilitaryStatusId, -1)						MilitaryStatusId						
			, case 
				when rda.AssessmentAcademicSubjectCode in ('01166', '13373') -- Math and RLA only
				then ISNULL(nord.DimNOrDStatusId, -1) 
				else -1 
			  end															NOrDStatusId							
			, -1															TitleIStatusId						
			, ISNULL(title3.DimTitleIIIStatusId, -1)						TitleIIIStatusId						
			, -1															FactK12StudentAssessmentAccommodationId
			, ISNULL(rdidt.DimIdeaDisabilityTypeId, -1)					    PrimaryDisabilityTypeId

		FROM Staging.K12Enrollment ske
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear AND rsy.SchoolYear = @SchoolYear
		--demographics			
			JOIN RDS.vwDimK12Demographics rdkd
 				ON rsy.SchoolYear = rdkd.SchoolYear
				AND ISNULL(ske.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
		--assessment results
			JOIN #tempStagingAssessmentResults sar
				ON ske.StudentIdentifierState 						= sar.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') 	= ISNULL(sar.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(sar.SchoolIdentifierSea,'')
		--seas (rds)			
			JOIN RDS.DimSeas rds
				ON sar.AssessmentAdministrationStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEndDate)		
		--dimpeople	(rds)
			JOIN #dimPeople rdp
				ON ske.StudentIdentifierState 			= rdp.K12StudentStudentIdentifierState
				AND ISNULL(ske.Birthdate, '1/1/1900') 	= ISNULL(rdp.BirthDate, '1/1/1900')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1/1/1900') BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, @SYEndDate)
		--assessments (rds)
			LEFT JOIN #vwAssessments rda
				ON ISNULL(sar.AssessmentIdentifier, 'MISSING') 			= ISNULL(rda.AssessmentIdentifierState, 'MISSING')
				AND ISNULL(sar.AssessmentAcademicSubject, 'MISSING') 	= ISNULL(rda.AssessmentAcademicSubjectMap, rda.AssessmentAcademicSubjectCode)	--RefAcademicSubject
				AND ISNULL(sar.AssessmentType, 'MISSING') 				= ISNULL(rda.AssessmentTypeMap, rda.AssessmentTypeCode)	--RefAssessmentType
				AND ISNULL(sar.AssessmentTypeAdministered, 'MISSING') 	= ISNULL(rda.AssessmentTypeAdministeredMap, rda.AssessmentTypeAdministeredCode)	--RefAssessmentTypeCildrenWithDisabilities
				AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, 'MISSING') = ISNULL(rda.AssessmentTypeAdministeredToEnglishLearnersMap, rda.AssessmentTypeAdministeredToEnglishLearnersCode)	--RefAssessmentTypeAdministeredToEnglishLearners
				and sar.SchoolYear = rda.SchoolYear
		--assessment results (rds)
			LEFT JOIN RDS.vwDimAssessmentResults rdar
				ON rdar.SchoolYear = rsy.SchoolYear
				AND ISNULL(sar.AssessmentScoreMetricType, '') = ISNULL(rdar.AssessmentScoreMetricTypeCode, '')	--RefScoreMetricType
		--assessment registrations (rds)
			LEFT JOIN #vwAssessmentRegistrations rdars
				ON ISNULL(CAST(sar.AssessmentRegistrationParticipationIndicator AS SMALLINT), -1) 	= ISNULL(rdars.AssessmentRegistrationParticipationIndicatorMap, -1)
				AND ISNULL(sar.AssessmentRegistrationReasonNotCompleting, 'MISSING') 				= ISNULL(rdars.AssessmentRegistrationReasonNotCompletingMap, rdars.AssessmentRegistrationReasonNotCompletingCode)	--RefAssessmentReasonNotCompleting
				AND ISNULL(sar.AssessmentRegistrationReasonNotTested, 'MISSING') 					= ISNULL(rdars.ReasonNotTestedMap, rdars.ReasonNotTestedCode)	--RefReasonNotTested
				AND rdars.StateFullAcademicYearCode 												= 'MISSING'
				AND rdars.LeaFullAcademicYearCode 													= 'MISSING'
				AND rdars.SchoolFullAcademicYearCode 												= 'MISSING'
				AND rdars.AssessmentRegistrationCompletionStatusCode 								= 'MISSING'
		--assessment administration (rds)
			LEFT JOIN #tempAssessmentAdministrations rdaa
				ON sar.LeaIdentifierSeaAccountability 								= rdaa.LEAIdentifierSea
				AND sar.SchoolIdentifierSea 										= rdaa.SchoolIdentifierSea
				AND sar.AssessmentIdentifier 										= rdaa.AssessmentIdentifier
				AND ISNULL(sar.AssessmentFamilyTitle, '') 							= ISNULL(rdaa.AssessmentAdministrationAssessmentFamily, '')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1900-01-01') 	= ISNULL(rdaa.AssessmentAdministrationStartDate, '1900-01-01')
				AND ISNULL(sar.AssessmentAdministrationFinishDate, '1900-01-01') 	= ISNULL(rdaa.AssessmentAdministrationFinishDate, '1900-01-01')
		--assessment performance levels (rds)
			LEFT JOIN RDS.DimAssessmentPerformanceLevels rdapl
				ON ISNULL(sar.AssessmentPerformanceLevelIdentifier, '') 	= ISNULL(rdapl.AssessmentPerformanceLevelIdentifier, '')
				AND ISNULL(sar.AssessmentPerformanceLevelLabel, '') 		= ISNULL(rdapl.AssessmentPerformanceLevelLabel, '')
		--leas (rds)	
			LEFT JOIN #tempLeas rdl -- RDS.DimLeas rdl
				ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(rdl.LeaIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @SYEndDate)
		--schools (rds)
			LEFT JOIN #tempK12Schools rdksch -- RDS.DimK12Schools rdksch
				ON ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(rdksch.SchoolIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @SYEndDate)
		--grade levels (rds)
			LEFT JOIN #vwGradeLevels rgls
				ON ISNULL(sar.GradeLevelWhenAssessed, '') = ISNULL(rgls.GradeLevelMap, '')
				--AND rgls.GradeLevelTypeDescription = 'Grade Level When Assessed'
		--idea disability type			
			LEFT JOIN Staging.IdeaDisabilityType sidt	
				ON ske.SchoolYear 									= sidt.SchoolYear
				AND sidt.StudentIdentifierState 					= ske.StudentIdentifierState
				AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sidt.SchoolIdentifierSea, '') 			= ISNULL(ske.SchoolIdentifierSea, '')
				AND sidt.IsPrimaryDisability = 1
				AND sar.AssessmentAdministrationStartDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, @SYEndDate)
		--idea (staging)	
			LEFT JOIN #tempIdeaStatus idea
				ON ske.SchoolYear 									= idea.SchoolYear
				AND ske.StudentIdentifierState 						= idea.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') 	= ISNULL(idea.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(idea.SchoolIdentifierSea,'')
				AND ((idea.ProgramParticipationBeginDate BETWEEN @SYStartDate and @SYEndDate 
						AND idea.ProgramParticipationBeginDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(idea.ProgramParticipationEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--english learner (staging)
			LEFT JOIN #tempELStatus el 
				ON sar.SchoolYear 									= el.SchoolYear
				AND sar.StudentIdentifierState 						= el.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(el.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(el.SchoolIdentifierSea, '')
				AND ((el.EnglishLearner_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND el.EnglishLearner_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(el.EnglishLearner_StatusEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--title III (staging)
			LEFT JOIN #tempTitleIIIStatus title3 
				ON sar.SchoolYear 									= title3.SchoolYear
				AND sar.StudentIdentifierState 						= title3.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(title3.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(title3.SchoolIdentifierSea, '')
				AND ((title3.ProgramParticipationBeginDate BETWEEN @SYStartDate and @SYEndDate 
						AND title3.ProgramParticipationBeginDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(title3.ProgramParticipationEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--migratory status (staging)	
			LEFT JOIN #tempMigrantStatus migrant
				ON sar.SchoolYear 									= migrant.SchoolYear
				AND sar.StudentIdentifierState 						= migrant.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(migrant.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(migrant.SchoolIdentifierSea, '')
				AND ((migrant.Migrant_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND migrant.Migrant_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(migrant.Migrant_StatusEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--homelessness status (staging)	
			LEFT JOIN #tempHomelessnessStatus hmStatus
				ON sar.SchoolYear 									= hmStatus.SchoolYear
				AND sar.StudentIdentifierState 						= hmStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(hmStatus.SchoolIdentifierSea, '')
				AND ((hmStatus.Homelessness_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND hmStatus.Homelessness_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(hmStatus.Homelessness_StatusEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--foster care status (staging)	
			LEFT JOIN #tempFosterCareStatus foster
				ON sar.SchoolYear 									= foster.SchoolYear
				AND sar.StudentIdentifierState 						= foster.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(foster.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(foster.SchoolIdentifierSea, '')
				AND ((foster.FosterCare_ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND foster.FosterCare_ProgramParticipationStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(foster.FosterCare_ProgramParticipationEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--economically disadvantaged status (staging)	
			LEFT JOIN #tempEconomicallyDisadvantagedStatus ecoDisStatus
				ON sar.SchoolYear 									= ecoDisStatus.SchoolYear
				AND sar.StudentIdentifierState 						= ecoDisStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '')	= ISNULL(ecoDisStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(ecoDisStatus.SchoolIdentifierSea, '')
				AND ((ecoDisStatus.EconomicDisadvantage_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND ecoDisStatus.EconomicDisadvantage_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(ecoDisStatus.EconomicDisadvantage_StatusEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--military status (staging)	
			LEFT JOIN #tempMilitaryStatus military
				ON sar.SchoolYear 									= military.SchoolYear
				AND sar.StudentIdentifierState 						= military.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(military.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(military.SchoolIdentifierSea, '')
				AND ((military.MilitaryConnected_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND military.MilitaryConnected_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(military.MilitaryConnected_StatusEndDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--race (staging + function)	
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
				ON ske.SchoolYear 				= spr.SchoolYear
				AND ske.StudentIdentifierState 	= spr.StudentIdentifierState
				AND (ske.SchoolIdentifierSea 	= spr.SchoolIdentifierSea
					OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)
		--race (RDS)	
			LEFT JOIN #vwRaces rdr
				ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
		-- NorD 
			LEFT JOIN #tempNorDStudents NorD
				ON NorD.StudentIdentifierState = sar.StudentIdentifierState
				AND NorD.LeaIdentifierSeaAccountability = sar.LeaIdentifierSeaAccountability
		--idea disability type (rds)
			LEFT JOIN RDS.vwDimIdeaDisabilityTypes rdidt
				ON sidt.SchoolYear = rdidt.SchoolYear
				AND ISNULL(sidt.IdeaDisabilityTypeCode, 'MISSING') = ISNULL(rdidt.IdeaDisabilityTypeMap, rdidt.IdeaDisabilityTypeCode)
				AND sidt.IsPrimaryDisability = 1

			WHERE 
			sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)


		DELETE FROM RDS.BridgeK12StudentAssessmentAccommodations
		WHERE FactK12StudentAssessmentId IN (
			SELECT FactK12StudentAssessmentId FROM RDS.FactK12StudentAssessments
			WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId)

	--Final insert into RDS.FactK12StudentAssessments table
		DELETE RDS.FactK12StudentAssessments
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		INSERT INTO RDS.FactK12StudentAssessments (
			[SchoolYearId]							
			, [FactTypeId]						
			, [SeaId]									
			, [IeuId]									
			, [LeaId]									
			, [K12SchoolId]
			, [K12StudentId]							
			, [GradeLevelWhenAssessedId]
			, [AssessmentId]			
			, [AssessmentSubtestId]
			, [AssessmentAdministrationId]
			, [AssessmentRegistrationId]				
			, [AssessmentParticipationSessionId]
			, [AssessmentResultId]	
			, [AssessmentPerformanceLevelId]
			, [AssessmentCount]		
			, [AssessmentResultScoreValueRawScore]
			, [AssessmentResultScoreValueScaleScore]
			, [AssessmentResultScoreValuePercentile]
			, [AssessmentResultScoreValueTScore]
			, [AssessmentResultScoreValueZScore]	
			, [AssessmentResultScoreValueACTScore]
			, [AssessmentResultScoreValueSATScore]
			, [CompetencyDefinitionId]
			, [CteStatusId]			
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [EnglishLearnerStatusId]	
			, [FosterCareStatusId]			
			, [IdeaStatusId]				
			, [ImmigrantStatusId]
			, [K12DemographicId]
			, [MigrantStatusId]
			, [MilitaryStatusId]
			, [NOrDStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [FactK12StudentAssessmentAccommodationId]
			, [PrimaryDisabilityTypeId]
		)
		SELECT 
			[SchoolYearId]							
			, [FactTypeId]						
			, [SeaId]									
			, [IeuId]									
			, [LeaId]									
			, [K12SchoolId]
			, [K12StudentId]							
			, [GradeLevelWhenAssessedId]
			, [AssessmentId]			
			, [AssessmentSubtestId]
			, [AssessmentAdministrationId]
			, [AssessmentRegistrationId]				
			, [AssessmentParticipationSessionId]
			, [AssessmentResultId]	
			, [AssessmentPerformanceLevelId]
			, [AssessmentCount]		
			, [AssessmentResultScoreValueRawScore]
			, [AssessmentResultScoreValueScaleScore]
			, [AssessmentResultScoreValuePercentile]
			, [AssessmentResultScoreValueTScore]
			, [AssessmentResultScoreValueZScore]	
			, [AssessmentResultScoreValueACTScore]
			, [AssessmentResultScoreValueSATScore]
			, [CompetencyDefinitionId]
			, [CteStatusId]			
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [EnglishLearnerStatusId]	
			, [FosterCareStatusId]			
			, [IdeaStatusId]				
			, [ImmigrantStatusId]
			, [K12DemographicId]
			, [MigrantStatusId]
			, [MilitaryStatusId]
			, [NOrDStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [FactK12StudentAssessmentAccommodationId]
			, [PrimaryDisabilityTypeId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentAssessments REBUILD

	--Populate the assessment race bridge table
		IF OBJECT_ID(N'tempdb..#raceHispanic') IS NOT NULL DROP TABLE #raceHispanic
	IF OBJECT_ID(N'tempdb..#temp') IS NOT NULL DROP TABLE #temp

	SELECT 	
		StudentIdentifierState
		, LeaIdentifierSeaAccountability
		, SchoolIdentifierSea
	INTO #raceHispanic
	FROM staging.K12Enrollment
	WHERE HispanicLatinoEthnicity = 1

	SELECT DISTINCT
		  rfksa.FactK12StudentAssessmentId
		, rdsy.SchoolYear
		, CASE 
			WHEN ISNULL(rh.StudentIdentifierState, '') <> '' or ISNULL(rhLEA.StudentIdentifierState,'') <> '' THEN 'HispanicOrLatinoEthnicity'
			ELSE ISNULL(spr.RaceMap, 'MISSING')
		  END AS RaceMap
	INTO #temp
	FROM RDS.FactK12StudentAssessments rfksa
	JOIN RDS.DimSchoolYears rdsy
		ON rfksa.SchoolYearId = rdsy.DimSchoolYearId
	JOIN RDS.DimPeople rdp
		ON rfksa.K12StudentId = rdp.DimPersonId
	JOIN RDS.DimK12Schools rdks
		ON rfksa.K12SchoolId = rdks.DimK12SchoolId
	JOIN RDS.DimLeas rdlsAcc
		ON rfksa.LeaId = rdlsAcc.DimLeaID

	left JOIN #raceHispanic rhLEA
		on rhLEA.StudentIdentifierState 						= rdp.K12StudentStudentIdentifierState 
		and ISNULL(rhLEA.LeaIdentifierSeaAccountability, '') 	= rdlsAcc.LeaIdentifierSea

	LEFT JOIN #raceHispanic rh
		ON rh.StudentIdentifierState 						= rdp.K12StudentStudentIdentifierState
		and rhLEA.LeaIdentifierSeaAccountability 			= rh.LeaIdentifierSeaAccountability
		AND ISNULL(rh.LeaIdentifierSeaAccountability, '') 	= rdlsAcc.LeaIdentifierSea
		AND ISNULL(rh.SchoolIdentifierSea, '') 				= isnull(rdks.SchoolIdentifierSea, '')
	--race (staging + function)	
	LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
		ON rdsy.SchoolYear = spr.SchoolYear
		AND rdp.K12StudentStudentIdentifierState 	= spr.StudentIdentifierState
		AND (rdks.SchoolIdentifierSea 				= spr.SchoolIdentifierSea
			OR rdlsAcc.LeaIdentifierSea 			= spr.LeaIdentifierSeaAccountability)
			
	INSERT INTO RDS.BridgeK12StudentAssessmentRaces (
		FactK12StudentAssessmentId
		, RaceId          
	)
	SELECT DISTINCT
		t.FactK12StudentAssessmentId
		, rdr.DimRaceId 
	FROM #temp t 
	JOIN #vwRaces rdr
		ON t.RaceMap = ISNULL(rdr.RaceMap, rdr.RaceCode)

	SELECT 	DISTINCT 
		  StudentIdentifierState
		, LeaIdentifierSeaAccountability
		, SchoolIdentifierSea
		, vwAcc.AssessmentAccommodationCategoryCode
		, vwAcc.DimAssessmentAccommodationId
		, sar.AssessmentIdentifier
	INTO #tempAccomodations
	FROM #tempStagingAssessmentResults sar
	INNER JOIN RDS.vwAssessmentAccommodations vwAcc
		ON vwAcc.SchoolYear = @SchoolYear
		AND ISNULL(sar.AssessmentAccommodationCategory, -1) = ISNULL(vwAcc.AssessmentAccommodationCategoryMap, -1)
		AND ISNULL(sar.AccommodationType,-1) = ISNULL(vwAcc.AccommodationTypeMap, -1)

	INSERT INTO RDS.BridgeK12StudentAssessmentAccommodations (
		  FactK12StudentAssessmentId
		  , AssessmentAccommodationId
		)
	SELECT 	rfsa.FactK12StudentAssessmentId
			, acc.DimAssessmentAccommodationId
	FROM RDS.FactK12StudentAssessments rfsa
			JOIN RDS.DimAssessments rda
				ON rfsa.AssessmentId = rda.DimAssessmentId
			JOIN RDS.DimLeas lea 
				ON rfsa.LeaId = lea.DimLeaID
			JOIN RDS.DimK12Schools sch 
				ON rfsa.K12SchoolId = sch.DimK12SchoolId
			JOIN RDS.DimPeople students 
				ON rfsa.K12StudentId = students.DimPersonId
			JOIN #tempAccomodations acc
				ON lea.LeaIdentifierSea = acc.LeaIdentifierSeaAccountability
				AND sch.SchoolIdentifierSea = acc.SchoolIdentifierSea
				AND students.K12StudentStudentIdentifierState = acc.StudentIdentifierState
				AND rda.AssessmentIdentifierState = acc.AssessmentIdentifier
		WHERE rfsa.SchoolYearId = @SchoolYearId
		AND acc.AssessmentAccommodationCategoryCode = 'TestAdministration'
		AND rda.AssessmentTypeAdministeredCode in ('REGASSWACC')

	--Update the Fact Assessment table with the Accomodation Id
		UPDATE f
		SET FactK12StudentAssessmentAccommodationId = rbsaa.FactK12StudentAssessmentAccommodationId
		FROM RDS.FactK12StudentAssessments f
			JOIN RDS.BridgeK12StudentAssessmentAccommodations rbsaa
				ON f.FactK12StudentAssessmentId = rbsaa.FactK12StudentAssessmentId

	END TRY
	BEGIN CATCH

	insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())
	END CATCH

END