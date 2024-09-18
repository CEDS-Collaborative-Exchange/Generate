/**********************************************************************
Author: AEM Corp
Date:	3/1/2022
Description: Migrates Child Count Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE  [Staging].[Staging-to-FactK12StudentCounts_SpecEdExit] 
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId int,
		@ChildCountDate date,
		@PreviousChildCountDate date,
		@StartDate DATE,
		@EndDate DATE,
		@UsesDefaultReferenceDates VARCHAR(10),
		@ToggleStartDate DATE,
		@ToggleEndDate DATE

		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		-- Get Child Count Date
		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'
						
		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)
		SELECT @PreviousChildCountDate = CAST(CAST(@SchoolYear - 2 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)

		-- Get Reference Period Dates, using Toggle to override if the state uses a custom reference period
		-- Default date range
		SELECT @StartDate = CAST('7/1/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
		SELECT @EndDate = CAST('6/30/' + CAST(@SchoolYear  AS VARCHAR(4)) AS DATE)

		-- Custom date range
		SELECT @UsesDefaultReferenceDates = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFPER'

		IF (@UsesDefaultReferenceDates = 'false') BEGIN
			SELECT @ToggleStartDate = tr.ResponseValue
			FROM App.ToggleQuestions tq
			JOIN App.ToggleResponses tr
				ON tq.ToggleQuestionId = tr.ToggleQuestionId
			WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFDTESTART'

			SELECT @ToggleEndDate = tr.ResponseValue
			FROM App.ToggleQuestions tq
			JOIN App.ToggleResponses tr
				ON tq.ToggleQuestionId = tr.ToggleQuestionId
			WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFDTEEND'

			SELECT @StartDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ToggleStartDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ToggleStartDate) AS VARCHAR(2)) AS DATE)
			SELECT @EndDate = CAST(CAST(@SchoolYear AS CHAR(4)) + '-' + CAST(MONTH(@ToggleEndDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ToggleEndDate) AS VARCHAR(2)) AS DATE)

		END 

		CREATE TABLE #seaOrganizationTypes (
			SeaOrganizationType					VARCHAR(20)
		)

		CREATE TABLE #leaOrganizationTypes (
			LeaOrganizationType					VARCHAR(20)
		)

		CREATE TABLE #schoolOrganizationTypes (
			K12SchoolOrganizationType				VARCHAR(20)
		)

		INSERT INTO #seaOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'SEA'
			AND SchoolYear = @SchoolYear

		INSERT INTO #leaOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'LEA'
			AND SchoolYear = @SchoolYear

		INSERT INTO #schoolOrganizationTypes
		SELECT 
			InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'K12School'
			AND SchoolYear = @SchoolYear

		IF OBJECT_ID('tempdb..#vwRaces') IS NOT NULL 
			DROP TABLE #vwRaces		
		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

		IF OBJECT_ID('tempdb..#vwDimCteStatuses') IS NOT NULL 
				DROP TABLE #vwDimCteStatuses; 		
		SELECT * 
		INTO #vwDimCteStatuses 
		FROM RDS.vwDimCteStatuses
		WHERE SchoolYear = @SchoolYear
		
		CREATE INDEX IX_vwDimCteStatuses ON #vwDimCteStatuses(SchoolYear, CteProgramMap, CteAeDisplacedHomemakerIndicatorMap, CteNontraditionalGenderStatusMap, RepresentationStatusMap, SingleParentOrSinglePregnantWomanMap, CteGraduationRateInclusionMap, LepPerkinsStatusMap) 
			INCLUDE (CteProgramCode, CteAeDisplacedHomemakerIndicatorCode, CteNontraditionalGenderStatusCode, RepresentationStatusCode, SingleParentOrSinglePregnantWomanCode, CteGraduationRateInclusionCode, LepPerkinsStatusCode)

		IF OBJECT_ID('tempdb..#vwDimTitleIStatuses') IS NOT NULL 
			DROP TABLE #vwDimTitleIStatuses		
		SELECT *
		INTO #vwDimTitleIStatuses
		FROM RDS.vwDimTitleIStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE INDEX ix_vwDimTitleIStatuses ON #vwDimTitleIStatuses (TitleIInstructionalServicesMap, TitleIProgramTypeMap, TitleISchoolStatusMap, TitleISupportServicesMap)
			INCLUDE (TitleIInstructionalServicesCode, TitleIProgramTypeCode, TitleISchoolStatusCode, TitleISupportServicesCode);

		IF OBJECT_ID('tempdb..#vwDimMigrants') IS NOT NULL 
			DROP TABLE #vwDimMigrants		
		SELECT *
		INTO #vwDimMigrants
		FROM RDS.vwDimMigrants
		WHERE SchoolYear = @SchoolYear

		CREATE INDEX ix_vwDimMigrants ON #vwDimMigrants (ContinuationOfServicesReasonMap, ConsolidatedMepFundsStatusMap, MepServicesTypeMap, MigrantPrioritizedForServicesMap, MepEnrollmentTypeMap)
			INCLUDE (ContinuationOfServicesReasonCode, ConsolidatedMepFundsStatusCode, MepServicesTypeCode, MigrantPrioritizedForServicesCode, MepEnrollmentTypeCode);


		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'specedexit'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts

		CREATE TABLE #Facts (
			StagingId int not null
			, AgeId	int null
			, SchoolYearId	int null
			, K12DemographicId	int null
			, FactTypeId	int null
			, GradeLevelId	int null
			, IdeaStatusId	int null
			, ProgramStatusId	int null
			, K12SchoolId	int null
			, K12StudentId	int null
			, StudentCount	int null
			, LanguageId	int null
			, MigrantId	int null
			, K12StudentStatusId	int null
			, TitleIStatusId	int null
			, TitleIIIStatusId	int null
			, LEAId	int null
			, AttendanceId	int null
			, CohortStatusId	int null
			, NorDProgramStatusId	int null
			, StudentCutoverStartDate	date null
			, RaceId	int null
			, CTEStatusId	int null
			, K12EnrollmentStatusId	int null
			, SEAId	int null
			, IEUId	int null
			, SpecialEducationServicesExitDateId	int null
		)

		INSERT INTO #Facts
		SELECT
			sppse.Id									StagingId
			, rda.DimAgeId								AgeId
			, rsy.DimSchoolYearId						SchoolYearId
			, ISNULL(rdkd.DimK12DemographicId, -1)		K12DemographicId
			, @FactTypeId								FactTypeId
			, -1										GradeLevelId
			, ISNULL(rdis.DimIdeaStatusId, -1)			IdeaStatusId
			, -1										ProgramStatusId
			, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
			, ISNULL(rdks.DimK12StudentId, -1)			K12StudentId
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
			, ISNULL(rdd.DimDateId, -1)					SpecialEducationServicesExitDateId
		FROM Staging.ProgramParticipationSpecialEducation sppse
		JOIN RDS.DimDates rdd
			ON sppse.ProgramParticipationEndDate = rdd.DateValue
		JOIN Staging.K12Enrollment ske
			ON ske.Student_Identifier_State = sppse.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(sppse.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(sppse.School_Identifier_State, '')
			AND rdd.DateValue BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LEA_Identifier_State = rdl.LeaIdentifierState
			AND rdd.DateValue BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
			AND rdd.DateValue BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		JOIN RDS.DimSeas rds
			ON rdd.DateValue BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		JOIN Staging.PersonStatus idea
			ON ske.Student_Identifier_State = idea.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
			AND rdd.DateValue BETWEEN idea.IDEA_StatusStartDate AND CASE WHEN idea.IDEA_StatusEndDate IS NULL THEN GETDATE() ELSE idea.IDEA_StatusEndDate END
		LEFT JOIN Staging.PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.Student_Identifier_State = spr.Student_Identifier_State
			AND (spr.OrganizationType in (SELECT SeaOrganizationType FROM #seaOrganizationTypes)
				OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT LeaOrganizationType FROM #leaOrganizationTypes))
				OR (ske.School_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT K12SchoolOrganizationType FROM #schoolOrganizationTypes)))
		LEFT JOIN Staging.PersonStatus el 
			ON ske.Student_Identifier_State = el.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(el.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
			AND rdd.DateValue BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
		LEFT JOIN Staging.PersonStatus econ 
			ON ske.Student_Identifier_State = econ.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(econ.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(econ.School_Identifier_State, '')
			AND rdd.DateValue BETWEEN econ.EconomicDisadvantage_StatusStartDate AND ISNULL(econ.EconomicDisadvantage_StatusEndDate, GETDATE())
		LEFT JOIN Staging.PersonStatus homeless 
			ON ske.Student_Identifier_State = homeless.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(homeless.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(homeless.School_Identifier_State, '')
			AND rdd.DateValue BETWEEN homeless.Homelessness_StatusStartDate AND ISNULL(homeless.Homelessness_StatusEndDate, GETDATE())
		JOIN RDS.vwDimK12Demographics rdkd
 			ON rsy.SchoolYear = rdkd.SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(rdkd.EnglishLearnerStatusMap, -1)
			AND ISNULL(CAST(econ.EconomicDisadvantageStatus AS SMALLINT), -1) = ISNULL(rdkd.EconomicDisadvantageStatusMap, -1)
			AND ISNULL(CAST(homeless.HomelessnessStatus AS SMALLINT), -1) = ISNULL(rdkd.HomelessnessStatusMap, -1)
			AND rdkd.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdkd.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdkd.MigrantStatusCode = 'MISSING'
			AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, IIF(rdd.DateValue < @ChildCountDate, @PreviousChildCountDate, @ChildCountDate)) = rda.AgeValue
		LEFT JOIN RDS.vwDimIdeaStatuses rdis
			ON ske.SchoolYear = rdis.SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = rdis.IdeaIndicatorMap
			AND ISNULL(idea.PrimaryDisabilityType, 'MISSING') = ISNULL(rdis.PrimaryDisabilityTypeMap, rdis.PrimaryDisabilityTypeCode)
			AND rdis.IdeaEducationalEnvironmentCode = 'MISSING'
			AND ISNULL(sppse.SpecialEducationExitReason, 'MISSING') = ISNULL(rdis.SpecialEducationExitReasonMap, rdis.SpecialEducationExitReasonCode)
		LEFT JOIN #vwRaces rdr
			ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
				CASE
					when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
					WHEN spr.RaceType IS NOT NULL THEN spr.RaceType
					ELSE 'Missing'
				END
		JOIN RDS.DimK12Students rdks
			ON ske.Student_Identifier_State = rdks.StateStudentIdentifier
			AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
			AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
			AND rdd.DateValue BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, GETDATE())
		WHERE sppse.ProgramParticipationEndDate IS NOT NULL

	--Update CTE
		UPDATE #Facts
		SET CteStatusId = ISNULL(rdcs.DimCteStatusId, -1)
		FROM #Facts fact
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON fact.StagingId = sppse.Id
		LEFT JOIN Staging.ProgramParticipationCTE sppc_part_conc
			ON sppse.Student_Identifier_State = sppc_part_conc.Student_Identifier_State
			AND ISNULL(sppse.Lea_Identifier_State, '') = ISNULL(sppc_part_conc.Lea_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sppc_part_conc.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sppc_part_conc.ProgramParticipationBeginDate AND ISNULL(sppc_part_conc.ProgramParticipationEndDate, @EndDate)
		LEFT JOIN Staging.ProgramParticipationCTE sppc_dhm
			ON sppse.Student_Identifier_State = sppc_dhm.Student_Identifier_State
			AND ISNULL(sppse.Lea_Identifier_State, '') = ISNULL(sppc_dhm.Lea_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sppc_dhm.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sppc_dhm.DisplacedHomeMaker_StatusStartDate AND ISNULL(sppc_dhm.DisplacedHomeMaker_StatusEndDate, @EndDate)
		LEFT JOIN Staging.ProgramParticipationCTE sppc_sp
			ON sppse.Student_Identifier_State = sppc_sp.Student_Identifier_State
			AND ISNULL(sppse.Lea_Identifier_State, '') = ISNULL(sppc_sp.Lea_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sppc_sp.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sppc_sp.SingleParent_StatusStartDate AND ISNULL(sppc_sp.SingleParent_StatusEndDate, @EndDate)
		LEFT JOIN Staging.PersonStatus sps
			ON sppse.Student_Identifier_State = sps.Student_Identifier_State
			AND ISNULL(sppse.Lea_Identifier_State, '') = ISNULL(sps.Lea_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sps.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sps.PerkinsLEPStatus_StatusStartDate AND ISNULL(sps.PerkinsLEPStatus_StatusEndDate, @EndDate)
		LEFT JOIN #vwDimCteStatuses rdcs
			ON CASE
				WHEN ISNULL(sppc_part_conc.CteConcentrator, 0) = 1					THEN 2
				WHEN ISNULL(sppc_part_conc.CteParticipant, 0) = 1					THEN 1
				WHEN sppc_part_conc.CteParticipant = 0								THEN 0
				ELSE -1
				END																			= ISNULL(rdcs.CteProgramMap, -1)
			AND ISNULL(CAST(sppc_dhm.DisplacedHomeMakerIndicator AS SMALLINT), -1)			= ISNULL(rdcs.CteAeDisplacedHomemakerIndicatorMap, -1)
			AND ISNULL(CAST(sppc_part_conc.NonTraditionalGenderStatus AS SMALLINT), -1)		= ISNULL(rdcs.CteNontraditionalGenderStatusMap, -1)
			AND ISNULL(CAST(sppc_part_conc.NonTraditionalGenderStatus AS SMALLINT), -1)		= ISNULL(rdcs.RepresentationStatusMap, -1)
			AND ISNULL(CAST(sppc_sp.SingleParentIndicator AS SMALLINT), -1)					= ISNULL(rdcs.SingleParentOrSinglePregnantWomanMap, -1)
			AND ISNULL(CAST(sppc_sp.SingleParentIndicator AS SMALLINT), -1)					= ISNULL(rdcs.SingleParentOrSinglePregnantWomanMap, -1)
			AND ISNULL(CAST(sps.PerkinsLEPStatus AS SMALLINT), -1)							= ISNULL(rdcs.LepPerkinsStatusMap, -1)

	--Get a unique set of Lea IDs to match against for Title I and Migrant update
		IF OBJECT_ID('tempdb..#uniqueLEAs') IS NOT NULL 
			DROP TABLE #uniqueLEAs		
		SELECT DISTINCT LEA_Identifier_State, LEA_RecordStartDateTime, LEA_RecordEndDateTime, LEA_TitleIProgramType, LEA_TitleIinstructionalService, LEA_K12LeaTitleISupportService
		INTO #uniqueLEAs
		FROM Staging.K12Organization
		WHERE LEA_IsReportedFederally = 1

	--Update Title I
		UPDATE #Facts
		SET TitleIStatusId = ISNULL(rdtis.DimTitleIStatusId, -1)
		FROM #Facts fact
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON fact.StagingId = sppse.Id
		JOIN #uniqueLEAs lea
			ON ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(lea.LEA_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN lea.LEA_RecordStartDateTime AND ISNULL(lea.LEA_RecordEndDateTime, @EndDate)
		LEFT JOIN Staging.K12Organization sch
			ON ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(lea.LEA_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sch.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sch.School_RecordStartDateTime AND ISNULL(sch.School_RecordEndDateTime, @EndDate)
		LEFT JOIN #vwDimTitleIStatuses rdtis
			ON ISNULL(lea.LEA_TitleIProgramType, 'MISSING') = ISNULL(rdtis.TitleIProgramTypeMap, rdtis.TitleIProgramTypeCode)
			AND ISNULL(lea.LEA_TitleIinstructionalService, 'MISSING') = ISNULL(rdtis.TitleIInstructionalServicesMap, rdtis.TitleIInstructionalServicesCode)
			AND ISNULL(lea.LEA_K12LeaTitleISupportService, 'MISSING') = ISNULL(rdtis.TitleISupportServicesMap, rdtis.TitleISupportServicesCode)
			AND ISNULL(sch.TitleIPartASchoolDesignation, 'MISSING') = ISNULL(rdtis.TitleISchoolStatusCode, rdtis.TitleISchoolStatusMap)

	--Update Migrant
		UPDATE #Facts
		SET MigrantId = ISNULL(rdm.DimMigrantId, -1)
		FROM #Facts fact
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON fact.StagingId = sppse.Id
		JOIN #uniqueLEAs lea
			ON ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(lea.LEA_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN lea.LEA_RecordStartDateTime AND ISNULL(lea.LEA_RecordEndDateTime, @EndDate)
		JOIN Staging.K12Organization sch
			ON ISNULL(sppse.LEA_Identifier_State, '') = ISNULL(lea.LEA_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sch.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sch.School_RecordStartDateTime AND ISNULL(sch.School_RecordEndDateTime, @EndDate)
		JOIN Staging.Migrant sm
			ON sppse.Student_Identifier_State = sm.Student_Identifier_State
			AND ISNULL(sppse.Lea_Identifier_State, '') = ISNULL(sm.Lea_Identifier_State, '')
			AND ISNULL(sppse.School_Identifier_State, '') = ISNULL(sm.School_Identifier_State, '')
			AND sppse.ProgramParticipationEndDate BETWEEN sm.ProgramParticipationStartDate AND ISNULL(sm.ProgramParticipationExitDate, @EndDate)
		LEFT JOIN #vwDimMigrants rdm
			ON ISNULL(CAST(sch.ConsolidatedMepFundsStatus AS SMALLINT), -1)	= ISNULL(rdm.ConsolidatedMepFundsStatusMap, -1)
			AND ISNULL(CAST(sm.MigrantPrioritizedForServices AS SMALLINT), -1) = ISNULL(rdm.MigrantPrioritizedForServicesMap, -1)
			AND ISNULL(sm.MigrantEducationProgramServicesType, 'MISSING') = ISNULL(rdm.MepServicesTypeMap, rdm.MepServicesTypeCode)
			AND rdm.ContinuationOfServicesReasonCode = 'MISSING'
			AND rdm.MepEnrollmentTypeCode = 'MISSING'
--			AND ISNULL(sm.ContinuationOfServicesReason, 'MISSING') = ISNULL(ContinuationOfServicesReasonMap, ContinuationOfServicesReasonCode)
--			AND ISNULL(sm.MigrantEducationProgramEnrollmentType, 'MISSING') = ISNULL(MepEnrollmentTypeMap, MepEnrollmentTypeCode)

		INSERT INTO RDS.FactK12StudentCounts (
			[AgeId]
			,[SchoolYearId]
			,[K12DemographicId]
			,[FactTypeId]
			,[GradeLevelId]
			,[IdeaStatusId]
			,[ProgramStatusId]
			,[K12SchoolId]
			,[K12StudentId]
			,[StudentCount]
			,[LanguageId]
			,[MigrantId]
			,[K12StudentStatusId]
			,[TitleIStatusId]
			,[TitleIIIStatusId]
			,[LeaId]
			,[AttendanceId]
			,[CohortStatusId]
			,[NOrDProgramStatusId]
			,[StudentCutOverStartDate]
			,[RaceId]
			,[CteStatusId]
			,[K12EnrollmentStatusId]
			,[SeaId]
			,[IeuId]
			,[SpecialEducationServicesExitDateId]
		)
		SELECT 
			[AgeId]
			,[SchoolYearId]
			,[K12DemographicId]
			,[FactTypeId]
			,[GradeLevelId]
			,[IdeaStatusId]
			,[ProgramStatusId]
			,[K12SchoolId]
			,[K12StudentId]
			,[StudentCount]
			,[LanguageId]
			,[MigrantId]
			,[K12StudentStatusId]
			,[TitleIStatusId]
			,[TitleIIIStatusId]
			,[LeaId]
			,[AttendanceId]
			,[CohortStatusId]
			,[NOrDProgramStatusId]
			,[StudentCutOverStartDate]
			,[RaceId]
			,[CteStatusId]
			,[K12EnrollmentStatusId]
			,[SeaId]
			,[IeuId]
			,[SpecialEducationServicesExitDateId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
		
		DROP TABLE #seaOrganizationTypes
		DROP TABLE #leaOrganizationTypes
		DROP TABLE #schoolOrganizationTypes
		DROP TABLE #vwRaces		
		DROP TABLE #vwDimCteStatuses 
		DROP TABLE #vwDimTitleIStatuses
		DROP TABLE #vwDimMigrants		

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', NULL, ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

		
END
