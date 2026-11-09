CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentAssessment_EnglishLearnerAssessment]
	@SchoolYear SMALLINT
	, @StudentIdentifierState VARCHAR(100) = NULL
	, @DebugMode BIT = 0
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @DebugMode = 1 AND ISNULL(@StudentIdentifierState, '') = ''
	BEGIN
		;THROW 50000, 'StudentIdentifierState is required when DebugMode is enabled.', 1;
	END

		IF OBJECT_ID(N'tempdb..#vwAssessments') IS NOT NULL DROP TABLE #vwAssessments
		IF OBJECT_ID(N'tempdb..#vwAssessmentRegistrations') IS NOT NULL DROP TABLE #vwAssessmentRegistrations

		IF OBJECT_ID(N'tempdb..#tempIdeaStatus') IS NOT NULL DROP TABLE #tempIdeaStatus
		IF OBJECT_ID(N'tempdb..#tempTitleIIIStatus') IS NOT NULL DROP TABLE #tempTitleIIIStatus
		IF OBJECT_ID(N'tempdb..#tempELStatus') IS NOT NULL DROP TABLE #tempELStatus
		IF OBJECT_ID(N'tempdb..#tempStagingAssessmentResults') IS NOT NULL DROP TABLE #tempStagingAssessmentResults
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

	-- No longer using #dimPeople temp table - direct join to DimPeople_Current

	--Create the temp views (and any relevant indexes) needed for this domain
	-- #vwAssessments
		SELECT *
		INTO #vwAssessments
		FROM RDS.vwDimAssessments
		WHERE SchoolYear = @SchoolYear

		CREATE NONCLUSTERED INDEX ix_tempvwAssessments -- JW
			ON #vwAssessments (AssessmentTitle, AssessmentTypeMap, AssessmentTypeAdministeredMap, AssessmentTypeAdministeredToEnglishLearnersMap);

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

	-- #tempIdeaStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, IDEAIndicator
			, IdeaEducationalEnvironmentForSchoolAgeCode
			, ProgramParticipationStartDate
			, ProgramParticipationExitDate
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
			ON #tempIdeaStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationStartDate, ProgramParticipationExitDate)

	-- #tempELStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusExitDate
			, rdels.DimEnglishLearnerStatusId
			, sps.SchoolYear
		INTO #tempELStatus
		FROM Staging.PersonStatus sps
		INNER JOIN RDS.vwDimEnglishLearnerStatuses rdels
			ON sps.SchoolYear = rdels.SchoolYear
			AND ISNULL(CAST(sps.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdels.EnglishLearnerStatusMap, -1)
			AND rdels.PerkinsEnglishLearnerStatusCode = 'MISSING'

		CREATE INDEX IX_tempELStatus 
			ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, Englishlearner_StatusStartDate, EnglishLearner_StatusExitDate)
								
	-- #tempTitleIIIStatus
		SELECT DISTINCT 
			StudentIdentifierState
			, LeaIdentifierSeaAccountability
			, SchoolIdentifierSea
			, TitleIIIAccountabilityProgressStatus
			, ProgramParticipationStartDate
			, ProgramParticipationExitDate
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
			ON #tempTitleIIIStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, ProgramParticipationStartDate, ProgramParticipationExitDate)

	--Set the Fact Type	
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'englishlearnerassessment'

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts

	--Create and load #Facts temp table
		CREATE TABLE #Facts (
			StagingAssessmentResultId						int not null
			, SchoolYearId									int null
			, FactTypeId									int null
			, SeaId											int null		
			, IeuId											int null	
			, LeaId											int null	
			, K12SchoolId									int null	
			, K12Student_CurrentId							int null	
			, GradeLevelWhenAssessedId						int null	
			, AssessmentId									int null	
			, AssessmentSubtestId							int null		
			, AssessmentAdministrationId					int null		
			, AssessmentRegistrationId						int null	
			, AssessmentParticipationSessionId				int null	
			, AssessmentStatusId							int null	
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
			, PrimaryDisabilityTypeId						int null
		)

		INSERT INTO #Facts
		SELECT DISTINCT
			sar.Id															StagingAssessmentResultId
			, rsy.DimSchoolYearId											SchoolYearId
			, @FactTypeId													FactTypeId							
			, ISNULL(rds.DimSeaId, -1)										SeaId									
			, -1															IeuId									
			, ISNULL(rdl.DimLeaID, -1)										LeaId									
			, ISNULL(rdksch.DimK12SchoolId, -1)								K12SchoolId							
			, ISNULL(rdpc.DimPersonId, -1)									K12Student_CurrentId							
			, -1															GradeLevelWhenAssessedId				
			, ISNULL(rda.DimAssessmentId, -1)								AssessmentId							
			, -1															AssessmentSubtestId					
			, -1 															AssessmentAdministrationId			
			, ISNULL(rdar.DimAssessmentRegistrationId, -1)					AssessmentRegistrationId				
			, -1															AssessmentParticipationSessionId		
			, ISNULL(rdas.DimAssessmentStatusId, -1)						AssessmentStatusId					
			, -1															AssessmentPerformanceLevelId			
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
			, -1															HomelessnessStatusId					 
			, -1															EconomicallyDisadvantagedStatusId		
			, ISNULL(el.DimEnglishLearnerStatusId, -1)						EnglishLearnerStatusId				
			, -1															FosterCareStatusId					
			, ISNULL(idea.DimIdeaStatusId, -1)								IdeaStatusId							
			, -1															ImmigrantStatusId						
			, -1															K12DemographicId						
			, -1									 						MigrantStatusId						
			, -1 															MilitaryStatusId						
			, case 
				when rda.AssessmentAcademicSubjectCode in ('01166', '13373') -- Math and RLA only
				then ISNULL(nord.DimNOrDStatusId, -1) 
				else -1 
			  end															NOrDStatusId							
			, -1															TitleIStatusId						
			, ISNULL(title3.DimTitleIIIStatusId, -1)						TitleIIIStatusId						
			, -1															PrimaryDisabilityTypeId

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
		--dimpeople	(rds) - direct join to DimPeople_Current
			LEFT JOIN RDS.DimPeople_Current rdpc
				ON ske.StudentIdentifierState = rdpc.K12StudentStudentIdentifierState
				AND ISNULL(ske.Birthdate, '1900-01-01') = ISNULL(rdpc.BirthDate, '1900-01-01')
				AND rdpc.IsActiveK12Student = 1
		--assessments (rds)
			LEFT JOIN #vwAssessments rda
				ON ISNULL(sar.AssessmentIdentifier, 'MISSING') 			= ISNULL(rda.AssessmentIdentifierState, 'MISSING')
				AND ISNULL(sar.AssessmentAcademicSubject, 'MISSING') 	= ISNULL(rda.AssessmentAcademicSubjectMap, rda.AssessmentAcademicSubjectCode)	--RefAcademicSubject
				AND ISNULL(sar.AssessmentType, 'MISSING') 				= ISNULL(rda.AssessmentTypeMap, rda.AssessmentTypeCode)	--RefAssessmentType
				AND ISNULL(sar.AssessmentTypeAdministered, 'MISSING') 	= ISNULL(rda.AssessmentTypeAdministeredMap, rda.AssessmentTypeAdministeredCode)	--RefAssessmentTypeCildrenWithDisabilities
				AND ISNULL(sar.AssessmentTypeAdministeredToEnglishLearners, 'MISSING') = ISNULL(rda.AssessmentTypeAdministeredToEnglishLearnersMap, rda.AssessmentTypeAdministeredToEnglishLearnersCode)	--RefAssessmentTypeAdministeredToEnglishLearners
				and sar.SchoolYear = rda.SchoolYear
		--assessment registrations (rds)
			LEFT JOIN #vwAssessmentRegistrations rdar
				ON ISNULL(CAST(sar.AssessmentRegistrationParticipationIndicator AS SMALLINT), -1) 	= ISNULL(rdar.AssessmentRegistrationParticipationIndicatorMap, -1)
				AND ISNULL(sar.AssessmentRegistrationReasonNotCompleting, 'MISSING') 				= ISNULL(rdar.AssessmentRegistrationReasonNotCompletingMap, rdar.AssessmentRegistrationReasonNotCompletingCode)	--RefAssessmentReasonNotCompleting
				AND ISNULL(sar.AssessmentRegistrationReasonNotTested, 'MISSING') 					= ISNULL(rdar.ReasonNotTestedMap, rdar.ReasonNotTestedCode)	--RefReasonNotTested
				AND rdar.StateFullAcademicYearCode 													= 'MISSING'
				AND rdar.LeaFullAcademicYearCode 													= 'MISSING'
				AND rdar.SchoolFullAcademicYearCode 												= 'MISSING'
				AND rdar.AssessmentRegistrationCompletionStatusCode 								= 'MISSING'
		--assessment status
			LEFT JOIN RDS.vwDimAssessmentStatuses rdas
				ON rdas.SchoolYear = rsy.SchoolYear
				AND ISNULL(CAST(sar.AssessedFirstTime AS SMALLINT), -1) = ISNULL(rdas.AssessedFirstTimeMap, -1)
				AND rdas.ProgressLevelCode								= 'MISSING'
				AND ISNULL(sar.EdFactsFormerEnglishLearnerYearStatus, 'MISSING') = ISNULL(rdas.FormerEnglishLearnerYearStatusCode, 'MISSING')
		--leas (rds)	
			LEFT JOIN #tempLeas rdl -- RDS.DimLeas rdl
				ON ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(rdl.LeaIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @SYEndDate)
		--schools (rds)
			LEFT JOIN #tempK12Schools rdksch -- RDS.DimK12Schools rdksch
				ON ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(rdksch.SchoolIdentifierSea, '')
				AND sar.AssessmentAdministrationStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @SYEndDate)
		--idea (staging)	
			LEFT JOIN #tempIdeaStatus idea
				ON ske.SchoolYear 									= idea.SchoolYear
				AND ske.StudentIdentifierState 						= idea.StudentIdentifierState
				AND ISNULL(ske.LEAIdentifierSeaAccountability,'') 	= ISNULL(idea.LeaIdentifierSeaAccountability,'')
				AND ISNULL(ske.SchoolIdentifierSea,'') 				= ISNULL(idea.SchoolIdentifierSea,'')
				AND ((idea.ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND idea.ProgramParticipationStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(idea.ProgramParticipationExitDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--english learner (staging)
			LEFT JOIN #tempELStatus el 
				ON sar.SchoolYear 									= el.SchoolYear
				AND sar.StudentIdentifierState 						= el.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(el.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(el.SchoolIdentifierSea, '')
				AND ((el.EnglishLearner_StatusStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND el.EnglishLearner_StatusStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(el.EnglishLearner_StatusExitDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)
		--title III (staging)
			LEFT JOIN #tempTitleIIIStatus title3 
				ON sar.SchoolYear 									= title3.SchoolYear
				AND sar.StudentIdentifierState 						= title3.StudentIdentifierState
				AND ISNULL(sar.LeaIdentifierSeaAccountability, '') 	= ISNULL(title3.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(sar.SchoolIdentifierSea, '') 			= ISNULL(title3.SchoolIdentifierSea, '')
				AND ((title3.ProgramParticipationStartDate BETWEEN @SYStartDate and @SYEndDate 
						AND title3.ProgramParticipationStartDate <= sar.AssessmentAdministrationStartDate) 
					AND ISNULL(title3.ProgramParticipationExitDate, @SYEndDate) >= sar.AssessmentAdministrationStartDate)

			WHERE 
			sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
			AND (@DebugMode = 0 OR (sar.StudentIdentifierState = @StudentIdentifierState AND sar.SchoolYear = @SchoolYear))

	--Final insert into RDS.FactK12StudentAssessments table
		IF @DebugMode = 1
		BEGIN
			SELECT
				@StudentIdentifierState AS StudentIdentifierState
				, sar.Id AS AssessmentResultStagingId
				, CASE WHEN sar.Id IS NULL THEN 0 ELSE 1 END AS FoundInAssessmentResult
				, CASE WHEN EXISTS (SELECT 1 FROM #Facts f WHERE f.StagingAssessmentResultId = sar.Id) THEN 1 ELSE 0 END AS MadeItIntoFacts
				, CASE
					WHEN sar.Id IS NULL THEN 'Staging.AssessmentResult'
					WHEN NOT EXISTS (
						SELECT 1
						FROM Staging.K12Enrollment ske
						WHERE ske.StudentIdentifierState = sar.StudentIdentifierState
							AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
							AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')
							AND ske.SchoolYear = sar.SchoolYear
					) THEN 'JOIN Staging.K12Enrollment'
					WHEN NOT EXISTS (SELECT 1 FROM RDS.DimSchoolYears rsy WHERE sar.SchoolYear = rsy.SchoolYear AND rsy.SchoolYear = @SchoolYear) THEN 'JOIN RDS.DimSchoolYears'
					WHEN NOT EXISTS (
						SELECT 1
						FROM Staging.K12Enrollment ske
						JOIN RDS.vwDimK12Demographics rdkd
							ON ske.SchoolYear = rdkd.SchoolYear
							AND ISNULL(ske.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode)
						WHERE ske.StudentIdentifierState = sar.StudentIdentifierState
							AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
							AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')
							AND ske.SchoolYear = sar.SchoolYear
					) THEN 'JOIN RDS.vwDimK12Demographics'
					WHEN sar.AssessmentAdministrationStartDate IS NULL OR NOT EXISTS (SELECT 1 FROM RDS.DimSeas rds WHERE sar.AssessmentAdministrationStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEndDate)) THEN 'JOIN RDS.DimSeas'
					WHEN NOT EXISTS (
						SELECT 1
						FROM Staging.K12Enrollment ske
						WHERE ske.StudentIdentifierState = sar.StudentIdentifierState
							AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
							AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')
							AND ske.SchoolYear = sar.SchoolYear
							AND sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
					) THEN 'WHERE AssessmentAdministrationStartDate between EnrollmentEntryDate/EnrollmentExitDate'
					WHEN NOT EXISTS (SELECT 1 FROM #Facts f WHERE f.StagingAssessmentResultId = sar.Id) THEN 'Unknown - all required joins matched but no #Facts row was inserted'
					ELSE 'Inserted into #Facts'
				END AS DebugResult
				, (SELECT COUNT(1) FROM #Facts) AS FactsRowsForStudent
				, CASE WHEN EXISTS (SELECT 1 FROM Staging.K12Enrollment ske WHERE ske.StudentIdentifierState = sar.StudentIdentifierState AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'') AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'') AND ske.SchoolYear = sar.SchoolYear) THEN 1 ELSE 0 END AS MatchedK12Enrollment
				, CASE WHEN EXISTS (SELECT 1 FROM RDS.DimSchoolYears rsy WHERE sar.SchoolYear = rsy.SchoolYear AND rsy.SchoolYear = @SchoolYear) THEN 1 ELSE 0 END AS MatchedDimSchoolYears
				, CASE WHEN sar.AssessmentAdministrationStartDate IS NOT NULL AND EXISTS (SELECT 1 FROM RDS.DimSeas rds WHERE sar.AssessmentAdministrationStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, @SYEndDate)) THEN 1 ELSE 0 END AS MatchedDimSeas
				, CASE WHEN EXISTS (
					SELECT 1
					FROM Staging.K12Enrollment ske
					WHERE ske.StudentIdentifierState = sar.StudentIdentifierState
						AND ISNULL(ske.LEAIdentifierSeaAccountability,'') = ISNULL(sar.LeaIdentifierSeaAccountability,'')
						AND ISNULL(ske.SchoolIdentifierSea,'') = ISNULL(sar.SchoolIdentifierSea,'')
						AND ske.SchoolYear = sar.SchoolYear
						AND sar.AssessmentAdministrationStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @SYEndDate)
				) THEN 1 ELSE 0 END AS PassedAssessmentAdministrationEnrollmentFilter
			FROM (SELECT @StudentIdentifierState AS StudentIdentifierState) debugStudent
			LEFT JOIN #tempStagingAssessmentResults sar
				ON sar.StudentIdentifierState = debugStudent.StudentIdentifierState
				AND sar.SchoolYear = @SchoolYear
			ORDER BY sar.Id

			RETURN
		END

	--Clear the Fact and Bridge tables of the data about to be migrated  
		IF ISNULL(@DebugMode, 0) = 0
		BEGIN
			--Fact
			DELETE RDS.FactK12StudentAssessments
			WHERE SchoolYearId = @SchoolYearId
				AND FactTypeId = @FactTypeId
		END


	--Final insert into RDS.FactK12StudentAssessments table
		INSERT INTO RDS.FactK12StudentAssessments (
			[SchoolYearId]							
			, [FactTypeId]						
			, [SeaId]									
			, [IeuId]									
			, [LeaId]									
			, [K12SchoolId]
			, [K12StudentId]
			, [K12Student_CurrentId]							
			, [GradeLevelWhenAssessedId]
			, [AssessmentId]			
			, [AssessmentSubtestId]
			, [AssessmentAdministrationId]
			, [AssessmentRegistrationId]				
			, [AssessmentParticipationSessionId]
			, [AssessmentStatusId]	
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
			, [PrimaryDisabilityTypeId]
		)
		SELECT 
			[SchoolYearId]							
			, [FactTypeId]						
			, [SeaId]									
			, [IeuId]									
			, [LeaId]									
			, [K12SchoolId]
			, -1 										AS [K12StudentId]
			, [K12Student_CurrentId]							
			, [GradeLevelWhenAssessedId]
			, [AssessmentId]			
			, [AssessmentSubtestId]
			, [AssessmentAdministrationId]
			, [AssessmentRegistrationId]				
			, [AssessmentParticipationSessionId]
			, [AssessmentStatusId]	
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
			, [PrimaryDisabilityTypeId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentAssessments REBUILD

	END TRY
	BEGIN CATCH

	insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 2, 'ERROR: ' + ERROR_MESSAGE())
	END CATCH

END