/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Assessment Data from Staging to RDS.FactK12StudentAssessments

NOTE: This Stored Procedure processes files: 175, 178, 179, 185, 188, 189

JW 11/16/2023: Made changes to address join issues
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentAssessments]
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

	--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwAssessments
		FROM RDS.vwDimAssessments
		WHERE SchoolYear = @SchoolYear

		CREATE NONCLUSTERED INDEX ix_tempvwAssessments -- JW
			ON #vwAssessments (AssessmentTitle, AssessmentTypeMap, AssessmentTypeAdministeredMap, AssessmentTypeAdministeredToEnglishLearnersMap);

		SELECT *
		INTO #vwAssessmentResults
		FROM RDS.vwDimAssessmentResults
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwAssessmentResults 
			ON #vwAssessmentResults (AssessmentScoreMetricTypeMap);

		SELECT *
		INTO #vwAssessmentRegistrations
		FROM RDS.vwDimAssessmentRegistrations
		WHERE SchoolYear = @SchoolYear
			AND StateFullAcademicYearCode = 'MISSING'
			AND LeaFullAcademicYearCode = 'MISSING'
			AND SchoolFullAcademicYearCode = 'MISSING'
			AND ReasonNotTestedCode = 'MISSING'
			AND AssessmentRegistrationCompletionStatusCode = 'MISSING'

		CREATE CLUSTERED INDEX ix_tempvwAssessmentRegistrations 
			ON #vwAssessmentRegistrations (AssessmentRegistrationParticipationIndicatorMap, AssessmentRegistrationReasonNotCompletingMap);

		SELECT *
		INTO #vwGradeLevels
		FROM RDS.vwDimGradeLevels
		WHERE SchoolYear = @SchoolYear
		and GradeLevelTypeDescription = 'Grade Level When Assessed'

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels 
			ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces 
			ON #vwRaces (RaceMap);

	-- #tempStagingAssessmentResults ----------------------------------------------------------------------------------
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
		AND sar.AssessmentAdministrationStartDate IS NOT NULL

		-- Create Index
			CREATE INDEX IX_tempStagingAssessment 
				ON #tempStagingAssessmentResults(
					AssessmentAdministrationStartDate, AssessmentAdministrationFinishDate, 
					LeaIdentifierSeaAccountability, SchoolIdentifierSea,
					AssessmentIdentifier, AssessmentFamilyTitle, AssessmentFamilyShortName, AssessmentShortName, AssessmentTitle, AssessmentAcademicSubject, AssessmentType, 
					AssessmentTypeAdministered, AssessmentTypeAdministeredToEnglishLearners, AssessmentScoreMetricType)

	-- #tempLeas ----------------------------------------------------------------------------
		SELECT DimLeaId, LeaIdentifierSea, CONVERT(DATE, RecordStartDateTime) RecordStartDateTime, CONVERT(DATE, RecordEndDateTime) RecordEndDateTime
		INTO #tempLeas
		FROM RDS.DimLeas
		WHERE CONVERT(DATE, RecordStartDateTime) between @SYStartDate and @SYEndDate

		-- Create Index
			CREATE INDEX IX_tempLeas
				ON #tempLeas(LeaIdentifierSea, RecordStartDateTime, RecordEndDateTime)

	-- #tempK12Schools ------------------------------------------------------------------------
		SELECT DimK12SchoolId, SchoolIdentifierSea, CONVERT(DATE, RecordStartDateTime) RecordStartDateTime, CONVERT(DATE, RecordEndDateTime) RecordEndDateTime
		INTO #tempK12Schools
		FROM RDS.DimK12Schools
		WHERE CONVERT(DATE, RecordStartDateTime) between @SYStartDate and @SYEndDate

		-- Create Index
			CREATE INDEX IX_tempK12Schools
				ON #tempK12Schools(SchoolIdentifierSea, RecordStartDateTime, RecordEndDateTime)

	-- #tempAssessmentAdministrations -------------------------------------------------------------------
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

		-- Create Index 
			CREATE INDEX IX_tempAssessmentAdministrations 
				ON #tempAssessmentAdministrations(
					LeaIdentifierSea, SchoolIdentifierSea,
					AssessmentAdministrationAssessmentFamily, AssessmentAdministrationStartDate, AssessmentAdministrationFinishDate)

	-- #tempIdeaStatus ------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, IDEAIndicator
			, IdeaEducationalEnvironmentForSchoolAgeCode
			, ProgramParticipationBeginDate
			, ProgramParticipationEndDate
			, rvdis.DimIdeaStatusId
		INTO #tempIdeaStatus
		FROM Staging.ProgramParticipationSpecialEducation sppse
		INNER JOIN RDS.vwDimIdeaStatuses rvdis
			ON rvdis.SchoolYear = @SchoolYear
				AND ISNULL(CAST(sppse.IDEAIndicator AS SMALLINT), -1) = ISNULL(rvdis.IdeaIndicatorMap, -1)
				AND rvdis.SpecialEducationExitReasonCode = 'MISSING'
				AND rvdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
				AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge,'MISSING') = ISNULL(rvdis.IdeaEducationalEnvironmentForSchoolAgeMap, rvdis.IdeaEducationalEnvironmentForSchoolAgeCode)
		WHERE sppse.IDEAIndicator = 1

		-- Create Index
			CREATE INDEX IX_tempIdeaStatus 
				ON #tempIdeaStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationBeginDate, ProgramParticipationEndDate)

	-- #tempELStatus ----------------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
			, rdels.DimEnglishLearnerStatusId
		INTO #tempELStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON rdels.SchoolYear = @SchoolYear
				AND ISNULL(CAST(sps.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
				AND rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'
		WHERE sps.EnglishLearnerStatus = 1

		-- Create Index 
			CREATE INDEX IX_tempELStatus 
				ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusEndDate)

	-- #tempMigrantStatus --------------------------------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MigrantStatus
			, Migrant_StatusStartDate
			, Migrant_StatusEndDate
			, rdms.DimMigrantStatusId
		INTO #tempMigrantStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimMigrantStatuses rdms
			ON rdms.SchoolYear = @SchoolYear 
				AND ISNULL(CAST(sps.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
				AND rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING' 
				AND rdms.ContinuationOfServicesReasonCode = 'MISSING'
				AND rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
				AND rdms.ConsolidatedMEPFundsStatusCode = 'MISSING'
				AND rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
				AND rdms.MigrantPrioritizedForServicesCode = 'MISSING'
		WHERE sps.MigrantStatus = 1

		-- Create Index 
			CREATE INDEX IX_tempMigrantStatus 
				ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant_StatusStartDate, Migrant_StatusEndDate)

	-- #tempHomelessnessStatus ------------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, HomelessnessStatus
			, Homelessness_StatusStartDate
			, Homelessness_StatusEndDate
			, rdhs.DimHomelessnessStatusId
		INTO #tempHomelessnessStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimHomelessnessStatuses rdhs
				ON rdhs.SchoolYear = @SchoolYear
				AND ISNULL(CAST(sps.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
				AND rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
				AND rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
				AND rdhs.HomelessServicedIndicatorCode = 'MISSING'
		WHERE sps.HomelessnessStatus = 1

		-- Create Index 
			CREATE INDEX IX_tempHomelessnessStatus 
				ON #tempHomelessnessStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Homelessness_StatusStartDate, Homelessness_StatusEndDate)


	-- #tempFosterCareStatus ---------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, ProgramType_FosterCare
			, FosterCare_ProgramParticipationStartDate
			, FosterCare_ProgramParticipationEndDate
			, rdfcs.DimFosterCareStatusId
		INTO #tempFosterCareStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimFosterCareStatuses rdfcs
			ON rdfcs.SchoolYear = @SchoolYear 
				AND ISNULL(CAST(sps.ProgramType_FosterCare AS SMALLINT), -1) = ISNULL(CAST(rdfcs.ProgramParticipationFosterCareMap AS SMALLINT), -1)
		WHERE sps.ProgramType_FosterCare = 1

		-- Create Index 
			CREATE INDEX IX_tempFosterCareStatus 
				ON #tempFosterCareStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, FosterCare_ProgramParticipationStartDate, FosterCare_ProgramParticipationEndDate)

	-- #tempEconomicallyDisadvantagedStatus --------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EconomicDisadvantageStatus
			, EconomicDisadvantage_StatusStartDate
			, EconomicDisadvantage_StatusEndDate
			, rdeds.DimEconomicallyDisadvantagedStatusId
		INTO #tempEconomicallyDisadvantagedStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimEconomicallyDisadvantagedStatuses rdeds
			ON rdeds.SchoolYear = @SchoolYear
				AND ISNULL(CAST(sps.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(CAST(rdeds.EconomicDisadvantageStatusMap AS SMALLINT), -1)
				AND rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
				AND rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'
		WHERE sps.EconomicDisadvantageStatus = 1

		-- Create Index 
			CREATE INDEX IX_tempEconomicallyDisadvantagedStatus
				ON #tempEconomicallyDisadvantagedStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EconomicDisadvantage_StatusStartDate, EconomicDisadvantage_StatusEndDate)

	-- #tempMilitaryStatus ------------------------------------------------------------------------
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MilitaryConnectedStudentIndicator
			, MilitaryConnected_StatusStartDate
			, MilitaryConnected_StatusEndDate
			, rdmils.DimMilitaryStatusId
		INTO #tempMilitaryStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimMilitaryStatuses rdmils
			ON rdmils.SchoolYear = @SchoolYear
			AND ISNULL(sps.MilitaryConnectedStudentIndicator, 'MISSING') = ISNULL(rdmils.MilitaryConnectedStudentIndicatorMap, rdmils.MilitaryConnectedStudentIndicatorCode)
			AND rdmils.MilitaryActiveStudentIndicatorCode = 'MISSING'
			AND rdmils.MilitaryBranchCode = 'MISSING'
			AND rdmils.MilitaryVeteranStudentIndicatorCode = 'MISSING'
		WHERE sps.MilitaryConnectedStudentIndicator is not null

		-- Create Index  
			CREATE INDEX IX_tempMilitaryStatus 
				ON #tempMilitaryStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, MilitaryConnected_StatusStartDate, MilitaryConnected_StatusEndDate)


		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'Submission'  --Assessments is still in the submission group


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
		)

		INSERT INTO #Facts
		SELECT DISTINCT
			rsy.DimSchoolYearId										SchoolYearId							
			, @FactTypeId												FactTypeId							
			, ISNULL(rds.DimSeaId, -1)									SeaId									
			, -1														IeuId									
			, ISNULL(rdl.DimLeaID, -1)									LeaId									
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId							
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId							
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelWhenAssessedId				
			, ISNULL(rda.DimAssessmentId, -1)							AssessmentId							
			, -1														AssessmentSubtestId					
			, ISNULL(rdaa.DimAssessmentAdministrationId, -1)			AssessmentAdministrationId			
			, ISNULL(rdars.DimAssessmentRegistrationId, -1)				AssessmentRegistrationId				
			, -1														AssessmentParticipationSessionId		
			, ISNULL(rdar.DimAssessmentResultId, -1)					AssessmentResultId					
			, ISNULL(rdapl.DimAssessmentPerformanceLevelId, -1)			AssessmentPerformanceLevelId			
			, 1															AssessmentCount						
			, ISNULL(sar.ScoreValue, -1)								AssessmentResultScoreValueRawScore	
			, -1														AssessmentResultScoreValueScaleScore	
			, -1														AssessmentResultScoreValuePercentile	
			, -1														AssessmentResultScoreValueTScore		
			, -1														AssessmentResultScoreValueZScore		
			, -1														AssessmentResultScoreValueACTScore	
			, -1										 				AssessmentResultScoreValueSATScore	
			, -1										 				CompetencyDefinitionId				
			, -1														CteStatusId							
			, ISNULL(hmStatus.DimHomelessnessStatusId, -1)					HomelessnessStatusId					 
			, ISNULL(ecoDisStatus.DimEconomicallyDisadvantagedStatusId, -1)	EconomicallyDisadvantagedStatusId		
			, ISNULL(el.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, ISNULL(foster.DimFosterCareStatusId, -1)					FosterCareStatusId					
			, ISNULL(idea.DimIdeaStatusId, -1)							IdeaStatusId							
			, -1														ImmigrantStatusId						
			, ISNULL(rdkd.DimK12DemographicId, -1)						K12DemographicId						
			, ISNULL(migrant.DimMigrantStatusId, -1)						MigrantStatusId						
			, ISNULL(military.DimMilitaryStatusId, -1)					MilitaryStatusId						
			, -1														NOrDStatusId							
			, -1														TitleIStatusId						
			, -1														TitleIIIStatusId						
			, -1														FactK12StudentAssessmentAccommodationId

		FROM Staging.K12Enrollment ske

			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear

		--demographics			
			JOIN RDS.vwDimK12Demographics rdkd
 				ON rsy.SchoolYear = rdkd.SchoolYear
				AND ISNULL(ske.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)

		--assessment results
			JOIN #tempStagingAssessmentResults sar
				ON ske.StudentIdentifierState = sar.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')

		--seas (rds)			
			JOIN RDS.DimSeas rds
				ON sar.AssessmentAdministrationStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @Today)		
	
		--dimpeople	(rds)
			JOIN RDS.DimPeople rdp
				ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
				AND IsActiveK12Student = 1
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1/1/1900') BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, @Today)
	
		--assessments (rds)
			LEFT JOIN #vwAssessments rda --  RDS.vwDimAssessments rda -- JW
				ON ISNULL(sar.AssessmentIdentifier, '') = ISNULL(rda.AssessmentIdentifierState, '')
				AND ISNULL(sar.AssessmentFamilyShortName, '') = ISNULL(rda.AssessmentFamilyShortName, '')
				AND ISNULL(sar.AssessmentShortName, '') = ISNULL(rda.AssessmentShortName, '')
				AND ISNULL(sar.AssessmentTitle, '') = ISNULL(rda.AssessmentTitle, '')
				AND ISNULL(sar.AssessmentAcademicSubject, '') = ISNULL(rda.AssessmentAcademicSubjectMap, '')	--RefAcademicSubject
				AND ISNULL(sar.AssessmentType, '') = ISNULL(rda.AssessmentTypeMap, '')	--RefAssessmentType
				AND ISNULL(sar.AssessmentTypeAdministered, '') = ISNULL(rda.AssessmentTypeAdministeredMap, '')	--RefAssessmentTypeCildrenWithDisabilities
				AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, '') = ISNULL(rda.AssessmentTypeAdministeredToEnglishLearnersMap, '')	--RefAssessmentTypeAdministeredToEnglishLearners
				and sar.SchoolYear = rda.SchoolYear


		--assessment results (rds)
			LEFT JOIN RDS.vwDimAssessmentResults rdar
				ON ISNULL(sar.AssessmentScoreMetricType, '') = ISNULL(rdar.AssessmentScoreMetricTypeCode, '')	--RefScoreMetricType

		--assessment registrations (rds)
			LEFT JOIN #vwAssessmentRegistrations rdars
				ON ISNULL(CAST(sar.AssessmentRegistrationParticipationIndicator AS SMALLINT), -1) = ISNULL(rdars.AssessmentRegistrationParticipationIndicatorMap, -1)
				AND ISNULL(sar.AssessmentRegistrationReasonNotCompleting, 'MISSING') = ISNULL(rdars.AssessmentRegistrationReasonNotCompletingMap, rdars.AssessmentRegistrationReasonNotCompletingCode)	--RefAssessmentReasonNotCompleting
				AND rdars.StateFullAcademicYearCode = 'MISSING'
				AND rdars.LeaFullAcademicYearCode = 'MISSING'
				AND rdars.SchoolFullAcademicYearCode = 'MISSING'
				AND rdars.ReasonNotTestedCode = 'MISSING'
				AND rdars.AssessmentRegistrationCompletionStatusCode = 'MISSING'

		--assessment administration (rds)
			LEFT JOIN #tempAssessmentAdministrations rdaa
				ON sar.LeaIdentifierSeaAccountability = rdaa.LEAIdentifierSea
				AND sar.SchoolIdentifierSea = rdaa.SchoolIdentifierSea
				AND sar.AssessmentIdentifier = rdaa.AssessmentIdentifier
				AND ISNULL(sar.AssessmentFamilyTitle, '') = ISNULL(rdaa.AssessmentAdministrationAssessmentFamily, '')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1900-01-01') = ISNULL(rdaa.AssessmentAdministrationStartDate, '1900-01-01')
				AND ISNULL(sar.AssessmentAdministrationFinishDate, '1900-01-01') = ISNULL(rdaa.AssessmentAdministrationFinishDate, '1900-01-01')
	
		--assessment performance levels (rds)
			LEFT JOIN RDS.DimAssessmentPerformanceLevels rdapl
				ON ISNULL(sar.AssessmentPerformanceLevelIdentifier, '') = ISNULL(rdapl.AssessmentPerformanceLevelIdentifier, '')
				AND ISNULL(sar.AssessmentPerformanceLevelLabel, '') = ISNULL(rdapl.AssessmentPerformanceLevelLabel, '')

		--leas (rds)	
			LEFT JOIN #tempLeas rdl -- RDS.DimLeas rdl
				ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(rdl.LeaIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @Today)

		--schools (rds)
			LEFT JOIN #tempK12Schools rdksch -- RDS.DimK12Schools rdksch
				ON ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(rdksch.SchoolIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @Today)

		--grade levels (rds)
			LEFT JOIN #vwGradeLevels rgls
				ON ISNULL(ske.GradeLevel, '') = ISNULL(rgls.GradeLevelMap, '')
				--AND rgls.GradeLevelTypeDescription = 'Grade Level When Assessed'

		--idea (staging)	
			LEFT JOIN #tempIdeaStatus idea
				ON ske.StudentIdentifierState = idea.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(idea.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(idea.SchoolIdentifierSea,'')
				AND ((idea.ProgramParticipationBeginDate BETWEEN @SYStartDate and @SYEndDate 
						AND idea.ProgramParticipationBeginDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(idea.ProgramParticipationEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--english learner (staging)
			LEFT JOIN #tempELStatus el 
				ON sar.StudentIdentifierState = el.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
				AND ((el.EnglishLearner_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND el.EnglishLearner_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(el.EnglishLearner_StatusEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--migratory status (staging)	
			LEFT JOIN #tempMigrantStatus migrant
				ON sar.StudentIdentifierState = migrant.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
				AND ((migrant.Migrant_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND migrant.Migrant_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(migrant.Migrant_StatusEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--homelessness status (staging)	
			LEFT JOIN #tempHomelessnessStatus hmStatus
				ON sar.StudentIdentifierState = hmStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
				AND ((hmStatus.Homelessness_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND hmStatus.Homelessness_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(hmStatus.Homelessness_StatusEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--foster care status (staging)	
			LEFT JOIN #tempFosterCareStatus foster
				ON sar.StudentIdentifierState = foster.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(foster.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(foster.SchoolIdentifierSea, '')
				AND ((foster.FosterCare_ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND foster.FosterCare_ProgramParticipationStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(foster.FosterCare_ProgramParticipationEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--economically disadvantaged status (staging)	
			LEFT JOIN #tempEconomicallyDisadvantagedStatus ecoDisStatus
				ON sar.StudentIdentifierState = ecoDisStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(ecoDisStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(ecoDisStatus.SchoolIdentifierSea, '')
				AND ((ecoDisStatus.EconomicDisadvantage_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND ecoDisStatus.EconomicDisadvantage_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(ecoDisStatus.EconomicDisadvantage_StatusEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--military status (staging)	
			LEFT JOIN #tempMilitaryStatus military
				ON sar.StudentIdentifierState = military.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(military.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(military.SchoolIdentifierSea, '')
				AND ((military.MilitaryConnected_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND military.MilitaryConnected_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(military.MilitaryConnected_StatusEndDate, @Today) >= sar.AssessmentAdministrationStartDate)

		--race (staging + function)	
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.StudentIdentifierState = spr.StudentIdentifierState
				AND (ske.SchoolIdentifierSea = spr.SchoolIdentifierSea
					OR ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability)
		--race (RDS)	
			LEFT JOIN #vwRaces rdr
				ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END

			WHERE 
			sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @Today)


-----------------------------------------------------------------------------------------------------------------------------
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
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentAssessments REBUILD

	--Populate the assessment race bridge table

		IF OBJECT_ID(N'tempdb..#raceHispanic') IS NOT NULL DROP TABLE #raceHispanic

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
				WHEN ISNULL(rh.StudentIdentifierState, '') <> '' THEN 'HispanicOrLatinoEthnicity'
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
		LEFT JOIN #raceHispanic rh
			ON rh.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND ISNULL(rh.LeaIdentifierSeaAccountability, '') = rdlsAcc.LeaIdentifierSea
			AND ISNULL(rh.SchoolIdentifierSea, '') = rdks.SchoolIdentifierSea
		-- LEFT JOIN RDS.DimDataCollections rddc
		-- 	ON rfksa.DataCollectionId = rddc.DimDataCollectionId
		-- 	AND rddc.DataCollectionName = @DataCollectionName
		--race (staging + function)	
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON rdsy.SchoolYear = spr.SchoolYear
			AND rdp.K12StudentStudentIdentifierState = spr.StudentIdentifierState
			AND (rdks.SchoolIdentifierSea = spr.SchoolIdentifierSea
				OR rdlsAcc.LeaIdentifierSea = spr.LeaIdentifierSeaAccountability)

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

	--Populate the accommodations bridge table
		INSERT INTO RDS.BridgeK12StudentAssessmentAccommodations (
		  FactK12StudentAssessmentId
		  , AssessmentAccommodationId
		)
		SELECT rfsa.FactK12StudentAssessmentId
			, rdaa.DimAssessmentAccommodationId
		FROM RDS.FactK12StudentAssessments rfsa
			JOIN RDS.DimAssessments rda
				ON rfsa.AssessmentId = rda.DimAssessmentId
			JOIN RDS.vwAssessmentAccommodations rdaa
				ON rdaa.AssessmentAccommodationCategoryCode = 'TestAdministration'
				AND rdaa.AssessmentAccommodationCategoryCode = 'MISSING'
		WHERE rfsa.SchoolYearId = @SchoolYearId
		AND rda.AssessmentTypeAdministeredCode in ('REGASSWACC')

	--Update the Fact Assessment table with the Accomodation Id
		UPDATE f
		SET FactK12StudentAssessmentAccommodationId = rbsaa.FactK12StudentAssessmentAccommodationId
		FROM RDS.FactK12StudentAssessments f
			JOIN RDS.BridgeK12StudentAssessmentAccommodations rbsaa
				ON f.FactK12StudentAssessmentId = rbsaa.FactK12StudentAssessmentId


	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentAssessments', 'RDS.FactK12StudentAssessments', 'FactK12StudentAssessments', 'FactK12StudentAssessments', ERROR_MESSAGE(), 1, NULL, @Today)

		INSERT INTO app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())

	END CATCH

END