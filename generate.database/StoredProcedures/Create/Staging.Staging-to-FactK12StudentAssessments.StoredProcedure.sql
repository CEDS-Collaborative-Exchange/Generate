/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Assessment Data from Staging to RDS.FactK12StudentAssessments

NOTE: This Stored Procedure processes files: 175, 178, 179, 185, 188, 189
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentAssessments]
	@SchoolYear SMALLINT
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwIdeaStatuses') IS NOT NULL DROP TABLE #vwIdeaStatuses
		IF OBJECT_ID(N'tempdb..#vwEconomicallyDisadvantagedStatuses') IS NOT NULL DROP TABLE #vwEconomicallyDisadvantagedStatuses
		IF OBJECT_ID(N'tempdb..#vwMigrantStatuses') IS NOT NULL DROP TABLE #vwMigrantStatuses
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

	--Setting variables to be used in the select statements 
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

	--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwAssessments
		FROM RDS.vwDimAssessments
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_temp#vwAssessments
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

		CREATE CLUSTERED INDEX ix_tempvwAssessmentRegistrations 
			ON #vwAssessmentRegistrations (AssessmentRegistrationParticipationIndicatorMap, AssessmentRegistrationReasonNotCompletingMap);

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
		INTO #vwIdeaStatuses
		FROM RDS.vwDimIdeaStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, IdeaEducationalEnvironmentForSchoolageMap);

		SELECT *
		INTO #vwMigrantStatuses
		FROM RDS.vwDimMigrantStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwMigrantStatuses
			ON #vwMigrantStatuses (MigrantStatusCode, MigrantEducationProgramEnrollmentTypeCode, ContinuationOfServicesReasonCode, ConsolidatedMEPFundsStatusCode, MigrantEducationProgramServicesTypeCode, MigrantPrioritizedForServicesCode);

		SELECT * 
		INTO #vwEconomicallyDisadvantagedStatuses
		FROM RDS.vwDimEconomicallyDisadvantagedStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwEconomicallyDisadvantagedStatuses
			ON #vwEconomicallyDisadvantagedStatuses (EconomicDisadvantageStatusCode, EligibilityStatusForSchoolFoodServiceProgramsCode);

	--Pull the IDEA Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, IDEAIndicator
			, ProgramParticipationBeginDate
			, ProgramParticipationEndDate
		INTO #tempIdeaStatus
		FROM Staging.ProgramParticipationSpecialEducation
		WHERE IDEAIndicator = 1

	-- Create Index for #tempIdeaStatus 
		CREATE INDEX IX_tempIdeaStatus 
			ON #tempIdeaStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationBeginDate, ProgramParticipationEndDate)

	--Pull the EL Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
		INTO #tempELStatus
		FROM Staging.PersonStatus
		WHERE EnglishLearnerStatus = 1

	-- Create Index for #tempELStatus 
		CREATE INDEX IX_tempELStatus 
			ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusEndDate)

	--Pull the Migrant Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MigrantStatus
			, Migrant_StatusStartDate
			, Migrant_StatusEndDate
		INTO #tempMigrantStatus
		FROM Staging.PersonStatus
		WHERE MigrantStatus = 1

	-- Create Index for #tempMigrantStatus 
		CREATE INDEX IX_tempMigrantStatus 
			ON #tempMigrantStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Migrant_StatusStartDate, Migrant_StatusEndDate)

	--Pull the Military Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, MilitaryConnectedStudentIndicator
			, MilitaryConnected_StatusStartDate
			, MilitaryConnected_StatusEndDate
		INTO #tempMilitaryStatus
		FROM Staging.PersonStatus

	-- Create Index for #tempMilitaryStatus 
		CREATE INDEX IX_tempMilitaryStatus 
			ON #tempMilitaryStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, MilitaryConnected_StatusStartDate, MilitaryConnected_StatusEndDate)

	--Pull the Homeless Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, HomelessnessStatus
			, Homelessness_StatusStartDate
			, Homelessness_StatusEndDate
		INTO #tempHomelessnessStatus
		FROM Staging.PersonStatus
		WHERE HomelessnessStatus = 1

	-- Create Index for #tempHomelessnessStatus 
		CREATE INDEX IX_tempHomelessnessStatus 
			ON #tempHomelessnessStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Homelessness_StatusStartDate, Homelessness_StatusEndDate)

	--Pull the Foster Care Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, ProgramType_FosterCare
			, FosterCare_ProgramParticipationStartDate
			, FosterCare_ProgramParticipationEndDate
		INTO #tempFosterCareStatus
		FROM Staging.PersonStatus
		WHERE ProgramType_FosterCare = 1

	-- Create Index for #tempFosterCareStatus
		CREATE INDEX IX_tempFosterCareStatus 
			ON #tempFosterCareStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, FosterCare_ProgramParticipationStartDate, FosterCare_ProgramParticipationEndDate)

	--Pull the Economically Disadvantaged Status into a temp table
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EconomicDisadvantageStatus
			, EconomicDisadvantage_StatusStartDate
			, EconomicDisadvantage_StatusEndDate
		INTO #tempEconomicallyDisadvantagedStatus
		FROM Staging.PersonStatus
		WHERE EconomicDisadvantageStatus = 1

	-- Create Index for #tempEconomicallyDsadvantagedStatus 
		CREATE INDEX IX_tempEconomicallyDisadvantagedStatus
			ON #tempEconomicallyDisadvantagedStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, EconomicDisadvantage_StatusStartDate, EconomicDisadvantage_StatusEndDate)


		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'Submission'  --Assessments is still in the submission group

		DELETE RDS.FactK12StudentAssessments
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts

	--Create and load #Facts temp table
		CREATE TABLE #Facts (
			StagingId										int not null
			, SchoolYearId									int null
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
			sar.Id														StagingId
			, rsy.DimSchoolYearId										SchoolYearId							
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
			, ISNULL(rdhs.DimHomelessnessStatusId, -1)					HomelessnessStatusId					 
			, ISNULL(rdeds.DimEconomicallyDisadvantagedStatusId, -1)	EconomicallyDisadvantagedStatusId		
			, ISNULL(rdels.DimEnglishLearnerStatusId, -1)				EnglishLearnerStatusId				
			, ISNULL(rdfcs.DimFosterCareStatusId, -1)					FosterCareStatusId					
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId							
			, -1														ImmigrantStatusId						
			, ISNULL(rdkd.DimK12DemographicId, -1)						K12DemographicId						
			, ISNULL(rdms.DimMigrantStatusId, -1)						MigrantStatusId						
			, ISNULL(rdmils.DimMilitaryStatusId, -1)					MilitaryStatusId						
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
			JOIN Staging.AssessmentResult sar
				ON ske.StudentIdentifierState = sar.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')
		--seas (rds)			
			JOIN RDS.DimSeas rds
				ON sar.AssessmentAdministrationStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())		
		--dimpeople	(rds)
			JOIN RDS.DimPeople rdp
				ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
				AND IsActiveK12Student = 1
				--AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
				--AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
				--AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1/1/1900') BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())
		--assessments
			LEFT JOIN Staging.Assessment sa
				ON ISNULL(sar.AssessmentTitle, '') = ISNULL(sa.AssessmentTitle, '')
				AND ISNULL(sar.AssessmentAcademicSubject, '') = ISNULL(sa.AssessmentAcademicSubject, '') 
				AND ISNULL(sar.AssessmentPurpose, '') = ISNULL(sa.AssessmentPurpose, '') 
				AND ISNULL(sar.AssessmentType, '') = ISNULL(sa.AssessmentType, '')
				AND ISNULL(sar.AssessmentTypeAdministered, '') = ISNULL(sa.AssessmentTypeAdministered, '')
				AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, '') = ISNULL(sa.AssessmentTypeAdministeredToEnglishLearners, '')

		--assessments (rds)
			LEFT JOIN RDS.vwDimAssessments rda
				ON ISNULL(sa.AssessmentIdentifier, '') = ISNULL(rda.AssessmentIdentifierState, '')
				AND ISNULL(sa.AssessmentFamilyShortName, '') = ISNULL(rda.AssessmentFamilyShortName, '')
				AND ISNULL(sa.AssessmentShortName, '') = ISNULL(rda.AssessmentShortName, '')
				AND ISNULL(sa.AssessmentTitle, '') = ISNULL(rda.AssessmentTitle, '')
				AND ISNULL(sa.AssessmentAcademicSubject, '') = ISNULL(rda.AssessmentAcademicSubjectCode, '')	--RefAcademicSubject
				AND ISNULL(sa.AssessmentType, '') = ISNULL(rda.AssessmentTypeCode, '')	--RefAssessmentType
				AND ISNULL(sa.AssessmentTypeAdministered, '') = ISNULL(rda.AssessmentTypeAdministeredCode, '')	--RefAssessmentTypeCildrenWithDisabilities
				AND ISNULL(sa.AssessmentTypeAdministeredToEnglishLearners, '') = ISNULL(rda.AssessmentTypeAdministeredToEnglishLearnersCode, '')	--RefAssessmentTypeAdministeredToEnglishLearners

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
			LEFT JOIN RDS.DimAssessmentAdministrations rdaa
				ON ISNULL(sa.AssessmentFamilyTitle, '') = ISNULL(rdaa.AssessmentAdministrationAssessmentFamily, '')
				AND ISNULL(sar.AssessmentAdministrationStartDate, '1900-01-01') = ISNULL(rdaa.AssessmentAdministrationStartDate, '1900-01-01')
				AND ISNULL(sar.AssessmentAdministrationFinishDate, '1900-01-01') = ISNULL(rdaa.AssessmentAdministrationFinishDate, '1900-01-01')
		
		--assessment performance levels (rds)
			LEFT JOIN RDS.DimAssessmentPerformanceLevels rdapl
				ON ISNULL(sar.AssessmentPerformanceLevelIdentifier, '') = ISNULL(rdapl.AssessmentPerformanceLevelIdentifier, '')
				AND ISNULL(sar.AssessmentPerformanceLevelLabel, '') = ISNULL(rdapl.AssessmentPerformanceLevelLabel, '')

		--leas (rds)	
			LEFT JOIN RDS.DimLeas rdl
				ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(rdl.LeaIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		--schools (rds)
			LEFT JOIN RDS.DimK12Schools rdksch
				ON ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(rdksch.SchoolIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		--grade levels (rds)
			LEFT JOIN #vwGradeLevels rgls
				ON ISNULL(ske.GradeLevel, '') = ISNULL(rgls.GradeLevelMap, '')
				AND rgls.GradeLevelTypeDescription = 'Grade Level When Assessed'
		--idea (staging)	
			LEFT JOIN #tempIdeaStatus idea
				ON ske.StudentIdentifierState = idea.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(idea.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(idea.SchoolIdentifierSea,'')
				AND ((idea.ProgramParticipationBeginDate BETWEEN @SYStartDate and @SYEndDate 
						AND idea.ProgramParticipationBeginDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(idea.ProgramParticipationEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--idea status (rds)	
			LEFT JOIN #vwIdeaStatuses rdis
				ON rdis.IdeaIndicatorCode = 'Yes'
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'
				AND rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'MISSING'
				AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'MISSING'

		--english learner (staging)
			LEFT JOIN #tempELStatus el 
				ON sar.StudentIdentifierState = el.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
				AND ((el.EnglishLearner_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND el.EnglishLearner_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--english learner (rds)
			LEFT JOIN RDS.vwDimEnglishLearnerStatuses rdels
				ON rsy.SchoolYear = rdels.SchoolYear
				AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
				AND PerkinsEnglishLearnerStatusCode = 'MISSING'

		--migratory status (staging)	
			LEFT JOIN #tempMigrantStatus migrant
				ON sar.StudentIdentifierState = migrant.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(migrant.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(migrant.SchoolIdentifierSea, '')
				AND ((migrant.Migrant_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND migrant.Migrant_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(migrant.Migrant_StatusEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--migrant (rds)
			LEFT JOIN #vwMigrantStatuses rdms
				ON ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdms.MigrantStatusMap AS SMALLINT), -1)
				AND rdms.MigrantEducationProgramEnrollmentTypeCode = 'MISSING' 
				AND rdms.ContinuationOfServicesReasonCode = 'MISSING'
				AND rdms.MEPContinuationOfServicesStatusCode = 'MISSING'
				AND rdms.ConsolidatedMEPFundsStatusCode = 'MISSING'
				AND rdms.MigrantEducationProgramServicesTypeCode = 'MISSING'
				AND rdms.MigrantPrioritizedForServicesCode = 'MISSING'

		--homelessness status (staging)	
			LEFT JOIN #tempHomelessnessStatus hmStatus
				ON sar.StudentIdentifierState = hmStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(hmStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(hmStatus.SchoolIdentifierSea, '')
				AND ((hmStatus.Homelessness_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND hmStatus.Homelessness_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(hmStatus.Homelessness_StatusEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--homelessness (rds)
			LEFT JOIN RDS.vwDimHomelessnessStatuses rdhs
				ON ISNULL(CAST(hmStatus.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdhs.HomelessnessStatusMap AS SMALLINT), -1)
				AND rdhs.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
				AND rdhs.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
				AND rdhs.HomelessServicedIndicatorCode = 'MISSING'

		--foster care status (staging)	
			LEFT JOIN #tempFosterCareStatus foster
				ON sar.StudentIdentifierState = foster.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(foster.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(foster.SchoolIdentifierSea, '')
				AND ((foster.FosterCare_ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND foster.FosterCare_ProgramParticipationStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(foster.FosterCare_ProgramParticipationEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--foster care (rds)
			LEFT JOIN RDS.vwDimFosterCareStatuses rdfcs
				ON ISNULL(CAST(foster.ProgramType_FosterCare AS SMALLINT), -1) = ISNULL(CAST(rdfcs.ProgramParticipationFosterCareMap AS SMALLINT), -1)

		--economically disadvantaged status (staging)	
			LEFT JOIN #tempEconomicallyDisadvantagedStatus ecoDisStatus
				ON sar.StudentIdentifierState = ecoDisStatus.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(ecoDisStatus.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(ecoDisStatus.SchoolIdentifierSea, '')
				AND ((ecoDisStatus.EconomicDisadvantage_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND ecoDisStatus.EconomicDisadvantage_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(ecoDisStatus.EconomicDisadvantage_StatusEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--economically disadvantaged status (rds)
			LEFT JOIN RDS.vwDimEconomicallyDisadvantagedStatuses rdeds
				ON ISNULL(CAST(ecoDisStatus.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(CAST(rdeds.EconomicDisadvantageStatusMap AS SMALLINT), -1)
				AND rdeds.EligibilityStatusForSchoolFoodServiceProgramsCode = 'MISSING'
				AND rdeds.NationalSchoolLunchProgramDirectCertificationIndicatorCode = 'MISSING'

		--military status (staging)	
			LEFT JOIN #tempMilitaryStatus military
				ON sar.StudentIdentifierState = military.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') = ISNULL(military.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sar.SchoolIdentifierSea, '') = ISNULL(military.SchoolIdentifierSea, '')
				AND ((military.MilitaryConnected_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND military.MilitaryConnected_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(military.MilitaryConnected_StatusEndDate, GETDATE()) >= sar.AssessmentAdministrationStartDate)
		--military (rds)
			LEFT JOIN RDS.vwDimMilitaryStatuses rdmils
				ON ISNULL(military.MilitaryConnectedStudentIndicator, 'MISSING') = ISNULL(rdmils.MilitaryConnectedStudentIndicatorMap, rdmils.MilitaryConnectedStudentIndicatorCode)
				AND rdmils.MilitaryActiveStudentIndicatorCode = 'MISSING'
				AND rdmils.MilitaryBranchCode = 'MISSING'
				AND rdmils.MilitaryVeteranStudentIndicatorCode = 'MISSING'

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
			WHERE sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())


	--Final insert into RDS.FactK12StudentAssessments table
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
		SELECT DISTINCT
			  rfksa.FactK12StudentAssessmentId
			, rdsy.SchoolYear
			, spr.RaceMap
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
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentAssessments', 'RDS.FactK12StudentAssessments', 'FactK12StudentAssessments', 'FactK12StudentAssessments', ERROR_MESSAGE(), 1, NULL, GETDATE())

		INSERT INTO app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())

	END CATCH

END