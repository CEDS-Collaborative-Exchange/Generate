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

	BEGIN TRY

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId INT,
		@ChildCountDate DATE,
		@StartDate DATE,
		@EndDate DATE

		--Set the SchoolYear
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SELECT @StartDate = CAST('7/1/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
		SELECT @EndDate = CAST('6/30/' + CAST(@SchoolYear  AS VARCHAR(4)) AS DATE)

		-- Set @DimSeaId -----------------------------
		declare @DimSeaId int

		select @DimSeaId = (
		select top 1 DimSeaId from rds.DimSeas 
		where RecordStartDateTime between @StartDate and @EndDate
		order by RecordStartDateTime)
		--and isnull(RecordEndDateTime, @EndDate) between @StartDate and @EndDate)
		----------------------------------------------


		--Set the Child Count date
		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)
	
		IF OBJECT_ID('tempdb.dbo.#seaOrganizationTypes', 'U') IS NOT NULL DROP TABLE #seaOrganizationTypes
		IF OBJECT_ID('tempdb.dbo.#leaOrganizationTypes', 'U') IS NOT NULL DROP TABLE #leaOrganizationTypes
		IF OBJECT_ID('tempdb.dbo.#schoolOrganizationTypes', 'U') IS NOT NULL DROP TABLE #schoolOrganizationTypes
		IF OBJECT_ID('tempdb.dbo.#vwDimRaces', 'U') IS NOT NULL DROP TABLE #vwDimRaces		
		IF OBJECT_ID('tempdb.dbo.#tempELStatus', 'U') IS NOT NULL DROP TABLE #tempELStatus


		--Pull the views into temp tables
		IF OBJECT_ID('tempdb.dbo.#vwDimK12Demographics', 'U') IS NOT NULL 
			DROP TABLE #vwDimK12Demographics; 		
		SELECT v.* INTO #vwDimK12Demographics FROM RDS.vwDimK12Demographics v 
		WHERE v.SchoolYear = @SchoolYear

		IF OBJECT_ID('tempdb.dbo.#vwDimIdeaStatuses', 'U') IS NOT NULL 
			DROP TABLE #vwDimIdeaStatuses; 		
		SELECT v.* INTO #vwDimIdeaStatuses FROM RDS.vwDimIdeaStatuses v
		WHERE v.SchoolYear = @SchoolYear
		CREATE INDEX IX_vwDimIdeaStatuses ON #vwDimIdeaStatuses(SchoolYear, IdeaIndicatorMap, IdeaEducationalEnvironmentMap, SpecialEducationExitReasonMap) INCLUDE (IdeaIndicatorCode, IdeaEducationalEnvironmentCode, SpecialEducationExitReasonCode)

		IF OBJECT_ID('tempdb.dbo.#vwDimGradeLevels', 'U') IS NOT NULL 
			DROP TABLE #vwDimGradeLevels; 		
		SELECT v.* INTO #vwDimGradeLevels FROM RDS.vwDimGradeLevels v
		WHERE GradeLevelTypeDescription = 'Entry Grade Level' 
		AND v.SchoolYear = @SchoolYear
		CREATE INDEX IX_vwDimGradeLevels ON #vwDimGradeLevels(SchoolYear, GradeLevelMap) INCLUDE (GradeLevelCode)

		IF OBJECT_ID('tempdb.dbo.#vwDimDisciplines', 'U') IS NOT NULL 
			DROP TABLE #vwDimDisciplines; 		
		SELECT v.* INTO #vwDimDisciplines FROM RDS.vwDimDisciplines v
		WHERE v.SchoolYear = @SchoolYear
		CREATE INDEX IX_vwDimDisciplines ON #vwDimDisciplines(SchoolYear, IdeaInterimRemovalMap, IdeaInterimRemovalReasonMap, DisciplineELStatusMap) INCLUDE (IdeaInterimRemovalCode, IdeaInterimRemovalReasonCode, DisciplineELStatusCode)

		--create the temp table for Races
		IF OBJECT_ID('tempdb.dbo.#vwDimRaces', 'U') IS NOT NULL 
			DROP TABLE #vwDimRaces; 		
		SELECT v.* INTO #vwDimRaces FROM RDS.vwDimRaces v
		WHERE v.SchoolYear = @SchoolYear
		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwDimRaces (RaceMap);


		--Set the Organziation types used for getting the appropriate Race values
		CREATE TABLE #seaOrganizationTypes (
			SeaOrganizationType			VARCHAR(20)
		)

		CREATE TABLE #leaOrganizationTypes (
			LeaOrganizationType			VARCHAR(20)
		)

		CREATE TABLE #schoolOrganizationTypes (
			K12SchoolOrganizationType	VARCHAR(20)
		)

		INSERT INTO #seaOrganizationTypes
		SELECT InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'SEA'
			AND SchoolYear = @SchoolYear

		INSERT INTO #leaOrganizationTypes
		SELECT InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'LEA'
			AND SchoolYear = @SchoolYear

		INSERT INTO #schoolOrganizationTypes
		SELECT InputCode
		FROM Staging.SourceSystemReferenceData 
		WHERE TableName = 'RefOrganizationType' 
			AND TableFilter = '001156' 
			AND OutputCode = 'K12School'
			AND SchoolYear = @SchoolYear

		--Set the Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'submission'

		--Pull the EL Status into a temp table
		SELECT DISTINCT 
			student_identifier_state
			, lea_identifier_state
			, school_identifier_state 
			, EnglishLearnerStatus
			, EnglishLearner_StatusStartDate
			, EnglishLearner_StatusEndDate
		INTO #tempELStatus
		FROM Staging.PersonStatus

		-- Create Index for #tempELStatus ---------------------------------------
		CREATE INDEX IX_tempELStatus ON #tempELStatus(Student_identifier_state, lea_identifier_state, school_identifier_State, englishlearner_statusstartdate, englishlearner_statusenddate)-- INCLUDE (IdeaInterimRemovalCode, IdeaInterimRemovalReasonCode, DisciplineELStatusCode)
		----------------------------------------------------------------------------

		--Clear the Fact table for the SY being migrated
		DELETE RDS.FactK12StudentDisciplines
		WHERE SchoolYearId = @SchoolYearId 

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts

		SELECT 
			  sd.Id											StagingId
			, rda.DimAgeId									AgeId
			, rsy.DimSchoolYearId							SchoolYearId
			, ISNULL(rdkd.DimK12DemographicId, -1)			K12DemographicId
			, ISNULL(rddisc.DimDisciplineId, -1)			DisciplineId
			, @FactTypeId									FactTypeId
			, ISNULL(rdis.DimIdeaStatusId, -1)				IdeaStatusId
			, -1											ProgramStatusId
			, ISNULL(rdksch.DimK12SchoolId, -1)				K12SchoolId
			, rdks.DimK12StudentId							K12StudentId
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
		INTO #Facts
		FROM Staging.Discipline sd
		JOIN Staging.K12Enrollment ske
			ON sd.Student_Identifier_State = ske.Student_Identifier_State
			AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(ske.LEA_Identifier_State, '')
			AND ISNULL(sd.School_Identifier_State, '') = ISNULL(ske.School_Identifier_State, '')
			AND sd.DisciplinaryActionStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, @EndDate)
		LEFT JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.Student_Identifier_State = sppse.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(sppse.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(sppse.School_Identifier_State, '')
			AND sd.DisciplinaryActionStartDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, @EndDate)
		LEFT JOIN Staging.PersonStatus idea
			ON sd.Student_Identifier_State = idea.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
			AND sd.DisciplinaryActionStartDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, @EndDate)
		LEFT JOIN Staging.PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND sd.Student_Identifier_State = spr.Student_Identifier_State
			AND (spr.OrganizationType in (SELECT SeaOrganizationType FROM #seaOrganizationTypes)
				OR (sd.LEA_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT LeaOrganizationType FROM #leaOrganizationTypes))
				OR (sd.School_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT K12SchoolOrganizationType FROM #schoolOrganizationTypes)))
		LEFT JOIN #tempELStatus el
			ON sd.Student_Identifier_State = el.Student_Identifier_State
			AND ISNULL(sd.LEA_Identifier_State, '') = ISNULL(el.LEA_Identifier_State, '')
			AND ISNULL(sd.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
			AND sd.DisciplinaryActionStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, @EndDate)
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue
		JOIN RDS.DimK12Students rdks
			ON sd.Student_Identifier_State = rdks.StateStudentIdentifier
			AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
			AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
			AND sd.DisciplinaryActionStartDate BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, @EndDate)
		LEFT JOIN RDS.DimLeas rdl
			ON sd.LEA_Identifier_State = rdl.LeaIdentifierState
			AND sd.DisciplinaryActionStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, @EndDate)
		LEFT JOIN RDS.DimK12Schools rdksch
			ON sd.School_Identifier_State = rdksch.SchoolIdentifierState
			AND sd.DisciplinaryActionStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, @EndDate)
		LEFT JOIN #vwDimK12Demographics rdkd
			ON rsy.SchoolYear = rdkd.SchoolYear
			AND ISNULL(el.EnglishLearnerStatus, 0) = rdkd.EnglishLearnerStatusMap
			AND rdkd.EconomicDisadvantageStatusCode = 'MISSING'
			AND rdkd.HomelessnessStatusCode = 'MISSING'
			AND rdkd.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdkd.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdkd.MigrantStatusCode = 'MISSING'
			AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
		LEFT JOIN #vwDimDisciplines rddisc
			ON rsy.SchoolYear = rddisc.SchoolYear
			AND ISNULL(sd.DisciplinaryActionTaken, 'MISSING')						= ISNULL(rddisc.DisciplinaryActionTakenMap, rddisc.DisciplinaryActionTakenCode)
			AND ISNULL(sd.DisciplineMethodOfCwd, 'MISSING')							= ISNULL(rddisc.DisciplineMethodOfChildrenWithDisabilitiesMap, rddisc.DisciplineMethodOfChildrenWithDisabilitiesCode)
			AND ISNULL(CAST(sd.EducationalServicesAfterRemoval AS SMALLINT), -1)	= ISNULL(rddisc.EducationalServicesAfterRemovalMap, -1)
			AND ISNULL(sd.IdeaInterimRemoval, 'MISSING')							= ISNULL(rddisc.IdeaInterimRemovalMap, rddisc.IdeaInterimRemovalCode)
			AND ISNULL(sd.IdeaInterimRemovalReason, 'MISSING')						= ISNULL(rddisc.IdeaInterimRemovalReasonMap, rddisc.IdeaInterimRemovalReasonCode)
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1)				= ISNULL(rddisc.DisciplineELStatusMap, -1)
		LEFT JOIN #vwDimIdeaStatuses rdis
			ON ske.SchoolYear = rdis.SchoolYear
			AND ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1)					= ISNULL(rdis.IdeaIndicatorMap, -1)
			AND ISNULL(idea.PrimaryDisabilityType, 'MISSING')						= ISNULL(rdis.PrimaryDisabilityTypeMap, rdis.PrimaryDisabilityTypeCode)
			AND ISNULL(sppse.IDEAEducationalEnvironmentForSchoolAge, 'MISSING')		= ISNULL(rdis.IdeaEducationalEnvironmentMap, rdis.IdeaEducationalEnvironmentCode)
			AND ISNULL(sppse.SpecialEducationExitReason, 'MISSING')					= ISNULL(rdis.SpecialEducationExitReasonMap, rdis.SpecialEducationExitReasonCode) 
			AND sd.DisciplinaryActionStartDate BETWEEN idea.Idea_StatusStartDate AND ISNULL(idea.Idea_StatusEndDate, @EndDate)
		LEFT JOIN #vwDimGradeLevels rgls
			ON rsy.SchoolYear = rgls.SchoolYear
			AND ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
		LEFT JOIN #vwDimRaces rdr
			ON rsy.SchoolYear = rdr.SchoolYear
			AND CASE 
					WHEN ske.HispanicLatinoEthnicity = 1 THEN 'HispanicorLatinoEthnicity'
					ELSE spr.RaceType
				END = rdr.RaceMap


		/**************************************************************************************************************
		FIX MULTIPLE RACES
		If Staging.Person race contains multiple race records they will cause duplicates in the Fact table.
		The logic below removes duplicate records from the #Fact table prior to inserting them into the RDS Fact table.

		Had to place this here because the CREATE UNIQUE INDEX in the CTE section below was throwing an error if there
		are duplicate records.
		***************************************************************************************************************/

			declare @RaceId_TwoOrMoreRaces int
			select @RaceId_TwoOrMoreRaces = RaceId from rds.DimRaces where RaceCode = 'TwoorMoreRaces'

		-- 1. Add a unique identity column to the #Fact table
			alter table #Facts add Id int identity

		-- 2. Get students who have multiple records with the same race for the same occurence
			IF OBJECT_ID('tempdb.dbo.#StudentsWithDuplicateRace', 'U') IS NOT NULL DROP TABLE #StudentsWithDuplicateRace

			select s.StateStudentIdentifier, f.K12StudentId, f.StagingId, RaceId, count(RaceId) RaceCount, min(Id) 'MinId'
			into #StudentsWithDuplicateRace
			from #Facts f
				inner join rds.dimK12Students S
					on S.DimK12StudentId = F.K12StudentId
			group by s.StateStudentIdentifier, f.K12StudentId, f.StagingId, RaceId
			having count(RaceId) > 1

					--select * from #StudentsWithDuplicateRace


		-- 3. Remove Duplicates where Id <> MinId
			delete F
			from #Facts F
			inner join #StudentsWithDuplicateRace MR
				on F.K12StudentId = MR.K12StudentId
				and F.StagingId = MR.StagingId
				and F.RaceId = MR.RaceId
				and F.Id <> MR.MinId

					-- TEST SCRIPT TO VERIFY RESULTS AFTER DELETE.  Should be NO records returned
					/*
						select s.StateStudentIdentifier, f.K12StudentId, f.StagingId, RaceId, count(RaceId) RaceCount, min(Id) 'MinId'
						from #Facts f
							inner join rds.dimK12Students S
								on S.DimK12StudentId = F.K12StudentId
						group by s.StateStudentIdentifier, f.K12StudentId, f.StagingId, RaceId
						having count(RaceId) > 1
					*/


		-- 4. Get students that have more than one unique race value and set it to "Two or More Races"
			IF OBJECT_ID('tempdb.dbo.#StudentsWithMultipleRaces', 'U') IS NOT NULL DROP TABLE #StudentsWithMultipleRaces

			select s.StateStudentIdentifier, f.K12StudentId, f.StagingId, count(distinct RaceId) RaceCount, min(Id) 'MinId'
			into #StudentsWithMultipleRaces
			from #Facts f
				inner join rds.dimK12Students S
					on S.DimK12StudentId = F.K12StudentId
			group by s.StateStudentIdentifier, f.K12StudentId, f.StagingId
			having count(distinct RaceId) > 1

				--select * from #StudentsWithMultipleRaces

		-- 5. Update Race for Students with Multiple Races using MinId
			update F
			set F.RaceId = @RaceId_TwoOrMoreRaces --Two or More Races
			from #Facts F
			inner join #StudentsWithMultipleRaces MR
				on F.K12StudentId = MR.K12StudentId
				and F.StagingId = MR.StagingId
				and F.Id = MR.MinId

		-- 6. Delete records where Race <> 6 for students with multiple races
			delete F
			from #Facts F
			inner join #StudentsWithMultipleRaces MR
				on F.K12StudentId = MR.K12StudentId
				and F.StagingId = MR.StagingId
				and F.RaceId <> @RaceId_TwoOrMoreRaces

					-- TEST SCRIPT TO VERIFY RESULTS AFTER DELETE.  Should be NO records returned
					/*
						select s.StateStudentIdentifier, f.K12StudentId, f.StagingId, count(distinct RaceId) RaceCount, min(Id) 'MinId'
						into #StudentsWithMultipleRaces
						from #Facts f
							inner join rds.dimK12Students S
								on S.DimK12StudentId = F.K12StudentId
						group by s.StateStudentIdentifier, f.K12StudentId, f.StagingId
						having count(distinct RaceId) > 1
					*/


		/**************************************************************************************************************
		END OF CODE TO FIX MULTIPLE RACES
		***************************************************************************************************************/




		IF EXISTS (SELECT 1 FROM Staging.ProgramParticipationCTE) BEGIN
			
			CREATE UNIQUE CLUSTERED INDEX IX_Facts ON #Facts(StagingId) 

			IF OBJECT_ID('tempdb.dbo.#vwDimCteStatuses', 'U') IS NOT NULL 
				DROP TABLE #vwDimCteStatuses; 		
			SELECT v.* INTO #vwDimCteStatuses FROM RDS.vwDimCteStatuses v
			WHERE v.SchoolYear = @SchoolYear
			CREATE INDEX IX_vwDimCteStatuses ON #vwDimCteStatuses(SchoolYear, CteProgramMap, CteAeDisplacedHomemakerIndicatorMap, CteNontraditionalGenderStatusMap, RepresentationStatusMap, SingleParentOrSinglePregnantWomanMap, CteGraduationRateInclusionMap, LepPerkinsStatusMap) INCLUDE (CteProgramCode, CteAeDisplacedHomemakerIndicatorCode, CteNontraditionalGenderStatusCode, RepresentationStatusCode, SingleParentOrSinglePregnantWomanCode, CteGraduationRateInclusionCode, LepPerkinsStatusCode)
			
			UPDATE #Facts
			SET CteStatusId = ISNULL(rdcs.DimCteStatusId, -1)
			FROM #Facts fact
			JOIN Staging.Discipline sd
				ON fact.StagingId = sd.Id
			LEFT JOIN Staging.ProgramParticipationCTE sppc_part_conc
				ON sd.Student_Identifier_State = sppc_part_conc.Student_Identifier_State
				AND ISNULL(sd.Lea_Identifier_State, '') = ISNULL(sppc_part_conc.Lea_Identifier_State, '')
				AND ISNULL(sd.School_Identifier_State, '') = ISNULL(sppc_part_conc.School_Identifier_State, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_part_conc.ProgramParticipationBeginDate AND ISNULL(sppc_part_conc.ProgramParticipationEndDate, @EndDate)
			LEFT JOIN Staging.ProgramParticipationCTE sppc_dhm
				ON sd.Student_Identifier_State = sppc_dhm.Student_Identifier_State
				AND ISNULL(sd.Lea_Identifier_State, '') = ISNULL(sppc_dhm.Lea_Identifier_State, '')
				AND ISNULL(sd.School_Identifier_State, '') = ISNULL(sppc_dhm.School_Identifier_State, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_dhm.DisplacedHomeMaker_StatusStartDate AND ISNULL(sppc_dhm.DisplacedHomeMaker_StatusEndDate, @EndDate)
			LEFT JOIN Staging.ProgramParticipationCTE sppc_sp
				ON sd.Student_Identifier_State = sppc_sp.Student_Identifier_State
				AND ISNULL(sd.Lea_Identifier_State, '') = ISNULL(sppc_sp.Lea_Identifier_State, '')
				AND ISNULL(sd.School_Identifier_State, '') = ISNULL(sppc_sp.School_Identifier_State, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sppc_sp.SingleParent_StatusStartDate AND ISNULL(sppc_sp.SingleParent_StatusEndDate, @EndDate)
			LEFT JOIN Staging.PersonStatus sps
				ON sd.Student_Identifier_State = sps.Student_Identifier_State
				AND ISNULL(sd.Lea_Identifier_State, '') = ISNULL(sps.Lea_Identifier_State, '')
				AND ISNULL(sd.School_Identifier_State, '') = ISNULL(sps.School_Identifier_State, '')
				AND sd.DisciplinaryActionStartDate BETWEEN sps.PerkinsLEPStatus_StatusStartDate AND ISNULL(sps.PerkinsLEPStatus_StatusEndDate, @EndDate)
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
		END



		INSERT INTO RDS.FactK12StudentDisciplines (
			  AgeId
			, SchoolYearId
			, K12DemographicId
			, DisciplineId
			, FactTypeId
			, IdeaStatusId
			, ProgramStatusId
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
		)
		SELECT 
			  AgeId
			, SchoolYearId
			, K12DemographicId
			, DisciplineId
			, FactTypeId
			, IdeaStatusId
			, ProgramStatusId
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
