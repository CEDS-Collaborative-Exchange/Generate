/**********************************************************************
Author: AEM Corp
Date:	5/1/2022
Description: Migrates Discipline Data from Staging to RDS.FactK12StudentDisciplines

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentDisciplines]
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Drop temp tables.  This allows for running the procedure as a script while debugging
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwIdeaStatuses') IS NOT NULL DROP TABLE #vwIdeaStatuses
		IF OBJECT_ID(N'tempdb..#tempELStatus') IS NOT NULL DROP TABLE #tempELStatus
		IF OBJECT_ID(N'tempdb..#vwUnduplicatedRaceMap') IS NOT NULL DROP TABLE #vwUnduplicatedRaceMap
		IF OBJECT_ID(N'tempdb..#vwK12Demographics') IS NOT NULL DROP TABLE #vwK12Demographics
		IF OBJECT_ID(N'tempdb..#vwDisciplines') IS NOT NULL DROP TABLE #vwDisciplines
		
	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT,
		@ChildCountDate DATE,
		@StartDate DATE,
		@EndDate DATE
		
	--Setting variables to be used in the select statements
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

	--set the default start/end dates for the SY
		SELECT @StartDate = CAST('7/1/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
		SELECT @EndDate = CAST('6/30/' + CAST(@SchoolYear  AS VARCHAR(4)) AS DATE)

		DECLARE @DimSeaId int
		SELECT @DimSeaId = (
		SELECT TOP 1 DimSeaId FROM rds.DimSeas 
		WHERE RecordStartDateTime between @StartDate and @EndDate
		ORDER BY RecordStartDateTime)
		

	--Set the Child Count date
		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)
	
	--Create the temp tables (and any relevant indexes) needed for this domain
		SELECT v.* 
		INTO #vwK12Demographics 
		FROM RDS.vwDimK12Demographics v 
		WHERE v.SchoolYear = @SchoolYear

		SELECT * 
		INTO #vwIdeaStatuses 
		FROM RDS.vwDimIdeaStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, IdeaEducationalEnvironmentForSchoolageMap);

		SELECT v.* 
		INTO #vwGradeLevels 
		FROM RDS.vwDimGradeLevels v
		WHERE GradeLevelTypeDescription = 'Entry Grade Level' 
		AND v.SchoolYear = @SchoolYear
		
		CREATE INDEX IX_vwGradeLevels ON #vwGradeLevels(SchoolYear, GradeLevelMap) INCLUDE (GradeLevelCode)

		SELECT v.* 
		INTO #vwDisciplines 
		FROM RDS.vwDimDisciplineStatuses v
		WHERE v.SchoolYear = @SchoolYear

		CREATE INDEX IX_vwDisciplines ON #vwDisciplines(SchoolYear, IdeaInterimRemovalMap, IdeaInterimRemovalReasonMap) INCLUDE (IdeaInterimRemovalCode, IdeaInterimRemovalReasonCode)

		SELECT v.* 
		INTO #vwRaces 
		FROM RDS.vwDimRaces v
		WHERE v.SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

	--Set the Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'submission'

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

	-- Create Index for #tempELStatus 
		CREATE INDEX IX_tempELStatus ON #tempELStatus(StudentIdentifierState, LeaIdentifierSeaAccountability, SchoolIdentifierSea, englishlearner_statusstartdate, englishlearner_statusenddate)-- INCLUDE (IdeaInterimRemovalCode, IdeaInterimRemovalReasonCode, DisciplineELStatusCode)

	-- Clear the Fact table for the SY being migrated
		DELETE RDS.FactK12StudentDisciplines
		WHERE SchoolYearId = @SchoolYearId 

	--Create and load #Facts temp table
		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL 
			DROP TABLE #Facts

		CREATE TABLE #Facts (
			StagingId 						int not null
			, AgeId							int null
			, SchoolYearId					int null
			, K12DemographicId				int null
			, DisciplineId 					int null
			, FactTypeId					int null
			, IdeaStatusId					int null
			, ProgramStatusId				int null
			, K12SchoolId					int null
			, K12StudentId					int null
			, DisciplineCount				int null
			, DisciplineDuration 			decimal(18,2) null
			, FirearmsId					int null
			, FirearmDisciplineId			int null
			, GradeLevelId					int null
			, CTEStatusId					int null
			, LEAId							int null			
			, DisciplinaryActionStartDate	date null
			, RaceId 						int null
			, SEAId							int null
			, IEUId							int null
			
		)
		INSERT INTO #Facts
		SELECT 
			  sd.Id											StagingId
			, rda.DimAgeId									AgeId
			, rsy.DimSchoolYearId							SchoolYearId
			, ISNULL(rdkd.DimK12DemographicId, -1)			K12DemographicId
			, ISNULL(rddisc.DimDisciplineStatusId, -1)		DisciplineStatusId
			, @FactTypeId									FactTypeId
			, ISNULL(rdis.DimIdeaStatusId, -1)				IdeaStatusId
			--, -1											ProgramStatusId
			, ISNULL(rdksch.DimK12SchoolId, -1)				K12SchoolId
			, rdp.DimPersonId								K12StudentId
			, 1												DisciplineCount
			, ISNULL(sd.DurationOfDisciplinaryAction, 0)	DisciplineDuration
			, -1											FirearmsId
			, -1											FirearmDisciplineId
			, ISNULL(rgls.DimGradeLevelId, -1)				GradeLevelId
			, -1											CteStatusId
			, ISNULL(rdl.DimLeaID, -1)						LeaId
			, sd.DisciplinaryActionStartDate				DisciplinaryActionStartDate
			, ISNULL(rdr.DimRaceId, -1)						RaceId
			, ISNULL(@DimSeaId, -1)							SeaId
			, -1											IeuId
		FROM Staging.Discipline sd 
		JOIN Staging.K12Enrollment ske
			ON sd.StudentIdentifierState = ske.StudentIdentifierState
			AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(ske.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(ske.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @EndDate)
		LEFT JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.StudentIdentifierState = sppse.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '') 
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, @EndDate)		
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.StudentIdentifierState = spr.StudentIdentifierState
			AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(spr.LeaIdentifierSeaAccountability, '')
			AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(spr.SchoolIdentifierSea, '')
		LEFT JOIN #tempELStatus el
			ON sd.StudentIdentifierState = el.StudentIdentifierState
			AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '')
			AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
			AND sd.DisciplinaryActionStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @EndDate)
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue
		JOIN RDS.DimPeople rdp
			ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
			AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
			AND sd.DisciplinaryActionStartDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, @EndDate)
			AND IsActiveK12Student = 1
		LEFT JOIN RDS.DimLeas rdl
			ON sd.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
			AND sd.DisciplinaryActionStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @EndDate)
		LEFT JOIN RDS.DimK12Schools rdksch
			ON sd.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
			AND sd.DisciplinaryActionStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @EndDate)
	   JOIN RDS.vwDimK12Demographics rdkd
 				ON rsy.SchoolYear = rdkd.SchoolYear
		
		-- this view is missing and codded wrong in in file
		LEFT JOIN #vwDimDisciplines rddisc
			ON rsy.SchoolYear = rddisc.SchoolYear
			AND ISNULL(sd.DisciplinaryActionTaken, 'MISSING')						= ISNULL(rddisc.DisciplinaryActionTakenMap, rddisc.DisciplinaryActionTakenCode)
			AND ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')							= ISNULL(rddisc.DisciplineMethodOfChildrenWithDisabilitiesMap, rddisc.DisciplineMethodOfChildrenWithDisabilitiesCode)
			AND ISNULL(CAST(sd.EducationalServicesAfterRemoval AS SMALLINT), -1)	= ISNULL(rddisc.EducationalServicesAfterRemovalMap, -1)
			AND ISNULL(sd.IdeaInterimRemoval, 'MISSING')							= ISNULL(rddisc.IdeaInterimRemovalMap, rddisc.IdeaInterimRemovalCode)
			AND ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')						= ISNULL(rddisc.IdeaInterimRemovalReasonMap, rddisc.IdeaInterimRemovalReasonCode)
			--AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1)				= ISNULL(rddisc.DisciplineELStatusMap, -1)
		LEFT JOIN #vwDimIdeaStatuses rdis
			ON ske.SchoolYear = rdis.SchoolYear
			AND  rdis.IdeaIndicatorCode = 'Yes'

		-- not sure what date this should be 
			AND sd.DisciplinaryActionStartDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, @EndDate)
		LEFT JOIN #vwDimGradeLevels rgls
			ON rsy.SchoolYear = rgls.SchoolYear
			AND ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
		LEFT JOIN #vwDimRaces rdr
			ON rsy.SchoolYear = rdr.SchoolYear
			AND CASE 
					WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
					ELSE spr.RaceCode
				END = rdr.RaceMap
				

		IF EXISTS (SELECT 1 FROM Staging.ProgramParticipationCTE) BEGIN

			IF OBJECT_ID('tempdb.dbo.#vwDimCteStatuses', 'U') IS NOT NULL 
				DROP TABLE #vwDimCteStatuses; 		
			SELECT v.* INTO #vwDimCteStatuses FROM RDS.vwDimCteStatuses v
			WHERE v.SchoolYear = @SchoolYear
			CREATE INDEX IX_vwDimCteStatuses ON #vwDimCteStatuses(SchoolYear, CteAeDisplacedHomemakerIndicatorMap, CteNontraditionalGenderStatusMap, SingleParentOrSinglePregnantWomanStatusMap) 
			INCLUDE (CteAeDisplacedHomemakerIndicatorCode, CteNontraditionalGenderStatusCode, SingleParentOrSinglePregnantWomanStatusCode)
	
		/*  Update the #Facts table */			
			UPDATE #Facts
			SET CteStatusId = ISNULL(rdcs.DimCteStatusId, -1)
			FROM #Facts fact
			JOIN Staging.Discipline sd
				ON fact.StagingId = sd.Id
			LEFT JOIN Staging.ProgramParticipationCTE sppc_part_conc
				ON sd.StudentIdentifierState = sppc_part_conc.StudentIdentifierState
				AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(sppc_part_conc.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(sppc_part_conc.SchoolIdentifierSea, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_part_conc.ProgramParticipationBeginDate AND ISNULL(sppc_part_conc.ProgramParticipationEndDate, @EndDate)
			LEFT JOIN Staging.ProgramParticipationCTE sppc_dhm
				ON sd.StudentIdentifierState = sppc_dhm.StudentIdentifierState
				AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(sppc_dhm.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(sppc_dhm.SchoolIdentifierSea, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_dhm.DisplacedHomeMaker_StatusStartDate AND ISNULL(sppc_dhm.DisplacedHomeMaker_StatusEndDate, @EndDate)
			LEFT JOIN Staging.ProgramParticipationCTE sppc_sp
				ON sd.StudentIdentifierState = sppc_sp.StudentIdentifierState
				AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(sppc_sp.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(sppc_sp.SchoolIdentifierSea, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_sp.SingleParent_StatusStartDate AND ISNULL(sppc_sp.SingleParent_StatusEndDate, @EndDate)
			-- DO not find these fields
			LEFT JOIN Staging.PersonStatus sps
				ON sd.StudentIdentifierState = sps.StudentIdentifierState
				AND ISNULL(sd.LeaIdentifierSeaAccountability, '') = ISNULL(sps.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sd.SchoolIdentifierSea, '') = ISNULL(sps.SchoolIdentifierSea, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sps.PerkinsEnglishLearnerStatus_StatusStartDate AND ISNULL(sps.PerkinsEnglishLearnerStatus_StatusEndDate, @EndDate)
			LEFT JOIN #vwDimCteStatuses rdcs
				ON  ISNULL(CAST(sppc_part_conc.CteParticipant AS SMALLINT), -1)					= ISNULL(rdcs.CteParticipantMap, -1)
				AND ISNULL(CAST(sppc_part_conc.CteConcentrator AS SMALLINT), -1)				= ISNULL(rdcs.CteConcentratorMap, -1)
				AND ISNULL(CAST(sppc_dhm.DisplacedHomeMakerIndicator AS SMALLINT), -1)			= ISNULL(rdcs.CteAeDisplacedHomemakerIndicatorMap, -1)
				AND ISNULL(CAST(sppc_part_conc.NonTraditionalGenderStatus AS SMALLINT), -1)		= ISNULL(rdcs.CteNontraditionalGenderStatusMap, -1)
				AND ISNULL(CAST(sppc_part_conc.NonTraditionalGenderStatus AS SMALLINT), -1)		= ISNULL(rdcs.CteNontraditionalGenderStatusMap, -1)
				AND ISNULL(CAST(sppc_sp.SingleParentIndicator AS SMALLINT), -1)					= ISNULL(rdcs.SingleParentOrSinglePregnantWomanStatusMap, -1)
				AND ISNULL(CAST(sppc_sp.SingleParentIndicator AS SMALLINT), -1)					= ISNULL(rdcs.SingleParentOrSinglePregnantWomanStatusMap, -1)
		END

		/*  Final insert into RDS.FactK12StudentDisciplines  table */
		INSERT INTO RDS.FactK12StudentDisciplines (
			  AgeId
			, SchoolYearId
			, K12DemographicId
			, DisciplineStatusId
			, FactTypeId
			, IdeaStatusId
			--, ProgramStatusId -- new table FactK12StudentAssessments
			, K12SchoolId
			, K12StudentId
			, DisciplineCount
			, DurationOfDisciplinaryAction
			, FirearmId
			, FirearmDisciplineStatusId
			, GradeLevelId
			, LeaId
			, DisciplinaryActionStartDateId
			, RaceId -- missing
			, CteStatusId
			, SeaId
			, IeuId
		)
		SELECT 
			  AgeId
			, SchoolYearId
			, K12DemographicId
			, DisciplineId
			, FactTypeId
			, IdeaStatusId
			--, ProgramStatusId
			, K12SchoolId
			, K12StudentId
			, DisciplineCount
			, DisciplineDuration
			, FirearmsId
			, FirearmDisciplineId
			, GradeLevelId
			, LeaId
			, DisciplinaryActionStartDate
			, RaceId
			, CteStatusId
			, SeaId
			, IeuId
		FROM #Facts

	ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
		
	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentDisciplines', 'RDS.FactK12StudentDisciplines', 'FactK12StudentDisciplines', NULL, ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

END
