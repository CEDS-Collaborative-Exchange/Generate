/**********************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Homeless Data from Staging to RDS.FactK12StudentCounts
************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_Homeless]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

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

		--Create/populate temp table to hold the Organization Types for use by PersonRace
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

		--create an index for PersonRace
		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PersonRace_StudentId_SchoolYear' AND object_id = OBJECT_ID('Staging.PersonRace')) 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_Staging_PersonRace_StudentId_SchoolYear]
			ON [Staging].[PersonRace] ([Student_Identifier_State],[SchoolYear])
			INCLUDE ([OrganizationIdentifier],[OrganizationType],[RaceType])
		END

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
		INTO #vwK12Demographics
		FROM RDS.vwDimK12Demographics
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwK12Demographics 
			ON #vwK12Demographics (EnglishLearnerStatusMap, EconomicDisadvantageStatusCode, HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode, MigrantStatusCode, MilitaryConnectedStudentIndicatorCode);

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'homeless'

		--Clear the Fact table of the data about to be migrated  
		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts
		
		--Create and load #Facts temp table
		CREATE TABLE #Facts (
				StagingId								int not null
				, AgeId									int null
				, SchoolYearId							int null
				, K12DemographicId						int null
				, FactTypeId							int null
				, GradeLevelId							int null
				, IdeaStatusId							int null
				, ProgramStatusId						int null
				, K12SchoolId							int null
				, K12StudentId							int null
				, StudentCount							int null
				, LanguageId							int null
				, MigrantId								int null
				, K12StudentStatusId					int null
				, TitleIStatusId						int null
				, TitleIIIStatusId						int null
				, LEAId									int null
				, AttendanceId							int null
				, CohortStatusId						int null
				, NorDProgramStatusId					int null
				, StudentCutoverStartDate				date null
				, RaceId								int null
				, CTEStatusId							int null
				, K12EnrollmentStatusId					int null
				, SEAId									int null
				, IEUId									int null
				, SpecialEducationServicesExitDateId	int null
			)

			INSERT INTO #Facts
			SELECT DISTINCT
				ske.id										StagingId
				, rda.DimAgeId								AgeId
				, rsy.DimSchoolYearId						SchoolYearId
				, ISNULL(rdkd.DimK12DemographicId, -1)		K12DemographicId
				, @FactTypeId								FactTypeId
				, ISNULL(rgls.DimGradeLevelId, -1)			GradeLevelId
				, -1										IdeaStatusId
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
				, -1										SpecialEducationServicesExitDateId
			
			FROM Staging.K12Enrollment ske
		--homeless
			JOIN Staging.PersonStatus hmStatus
				ON ske.Student_Identifier_State = hmStatus.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(hmStatus.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(hmStatus.School_Identifier_State, '')
				AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			LEFT JOIN RDS.DimLeas rdl
				ON ske.LEA_Identifier_State = rdl.LeaIdentifierState
				AND hmStatus.Homelessness_StatusStartDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
			LEFT JOIN RDS.DimK12Schools rdksch
				ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
				AND hmStatus.Homelessness_StatusStartDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
			JOIN RDS.DimSeas rds
				ON hmStatus.Homelessness_StatusStartDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		--homeless nighttime residence
			LEFT JOIN Staging.PersonStatus hmNight
				ON ske.Student_Identifier_State = hmNight.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(hmNight.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(hmNight.School_Identifier_State, '')
				AND hmNight.HomelessNightTimeResidence_StartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())
		--disability status
			LEFT JOIN Staging.PersonStatus idea
				ON ske.Student_Identifier_State = idea.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
				AND hmStatus.Homelessness_StatusStartDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE())
		--english learner
			LEFT JOIN Staging.PersonStatus el 
				ON ske.Student_Identifier_State = el.Student_Identifier_State
				AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(el.LEA_Identifier_State, '') 
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
				AND hmStatus.Homelessness_StatusStartDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
		--migratory status	
			LEFT JOIN Staging.PersonStatus migrant
				ON ske.Student_Identifier_State = migrant.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(migrant.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(migrant.School_Identifier_State, '')
				AND hmStatus.Homelessness_StatusStartDate BETWEEN migrant.Migrant_StatusStartDate AND ISNULL(migrant.Migrant_StatusEndDate, GETDATE())
		--race	
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.Student_Identifier_State = spr.Student_Identifier_State
				AND (spr.OrganizationType in (SELECT SeaOrganizationType FROM #seaOrganizationTypes)
					OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
						AND spr.OrganizationType in (SELECT LeaOrganizationType FROM #leaOrganizationTypes))
					OR (ske.School_Identifier_State = spr.OrganizationIdentifier
						AND spr.OrganizationType in (SELECT K12SchoolOrganizationType FROM #schoolOrganizationTypes)))
		--age
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, @SYStartDate) = rda.AgeValue
			LEFT JOIN #vwK12Demographics rdkd
 				ON ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.EnglishLearnerStatusMap AS SMALLINT), -1)
				AND rdkd.EconomicDisadvantageStatusCode = 'MISSING'
				AND ISNULL(CAST(hmStatus.HomelessnessStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.HomelessnessStatusMap AS SMALLINT), -1)
				AND ISNULL(hmNight.HomelessNightTimeResidence, 'MISSING') = ISNULL(rdkd.HomelessPrimaryNighttimeResidenceMap, 'MISSING')
				AND ISNULL(CAST(hmStatus.HomelessUnaccompaniedYouth AS SMALLINT), -1) = ISNULL(CAST(rdkd.HomelessUnaccompaniedYouthStatusMap AS SMALLINT), -1)
				AND ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.MigrantStatusMap AS SMALLINT), -1)
				AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
			LEFT JOIN #vwGradeLevels rgls
				ON ske.GradeLevel = rgls.GradeLevelMap
				AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
			LEFT JOIN #vwRaces rdr
				ON ISNULL(rdr.RaceCode, rdr.RaceMap) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceCode IS NOT NULL THEN spr.RaceCode
						ELSE 'Missing'
					END
			JOIN RDS.DimK12Students rdks
				ON ske.Student_Identifier_State = rdks.StateStudentIdentifier
				AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
				AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
				AND hmStatus.Homelessness_StatusStartDate BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, GETDATE())
			WHERE hmStatus.HomelessnessStatus = 1 
			AND hmStatus.Homelessness_StatusStartDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())


			---Final insert into RDS.FactK12StudentCounts table 
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

			--Clean up the temp tables
			DROP TABLE #seaOrganizationTypes
			DROP TABLE #leaOrganizationTypes
			DROP TABLE #schoolOrganizationTypes
			DROP TABLE #vwGradeLevels
			DROP TABLE #vwRaces
			DROP TABLE #vwK12Demographics

		END TRY
		BEGIN CATCH
			INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_Homeless', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
		END CATCH

END