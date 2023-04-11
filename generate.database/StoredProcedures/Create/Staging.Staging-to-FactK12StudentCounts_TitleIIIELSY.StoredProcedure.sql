/**********************************************************************************
Author: AEM Corp
Date:	2/20/2023
Description: Migrates Title III EL SY Data from Staging to RDS.FactK12StudentCounts

***********************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_TitleIIIELSY]
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

		--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwProgramStatuses
		FROM RDS.vwDimProgramStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwProgramStatuses
			ON #vwProgramStatuses (EligibilityStatusForSchoolFoodServiceProgramCode, FosterCareProgramCode, TitleIIIImmigrantParticipationStatusCode, Section504StatusCode, TitleiiiProgramParticipationCode, HomelessServicedIndicatorCode);

		SELECT *
		INTO #vwK12Demographics
		FROM RDS.vwDimK12Demographics
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwK12Demographics 
			ON #vwK12Demographics (EnglishLearnerStatusMap, EconomicDisadvantageStatusCode, HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode, MigrantStatusCode, MilitaryConnectedStudentIndicatorCode);

		SELECT *
		INTO #vwLanguages
		FROM RDS.vwDimLanguages
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwLanguages
			ON #vwLanguages (Iso6392LanguageCode);

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'TitleIIIELSY'

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
				, ISNULL(rda.DimAgeId, -1)					AgeId
				, rsy.DimSchoolYearId						SchoolYearId
				, ISNULL(rdkd.DimK12DemographicId, -1)		K12DemographicId
				, @FactTypeId								FactTypeId
				, -1										GradeLevelId
				, -1										IdeaStatusId
				, ISNULL(rps.DimProgramStatusId, -1)		ProgramStatusId
				, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
				, ISNULL(rdks.DimK12StudentId, -1)			K12StudentId
				, 1											StudentCount
				, ISNULL(rdvl.DimLanguageId, -1)			LanguageId
				, -1										MigrantId
				, -1										K12StudentStatusId
				, -1										TitleIStatusId
				, -1										TitleIIIStatusId
				, ISNULL(rdl.DimLeaID, -1)					LEAId
				, -1										AttendanceId
				, -1										CohortStatusId
				, -1										NorDProgramStatusId
				, NULL										StudentCutoverStartDate
				, -1										RaceId
				, -1										CTEStatusId
				, -1										K12EnrollmentStatusId
				, ISNULL(rds.DimSeaId, -1)					SEAId
				, -1										IEUId
				, -1										SpecialEducationServicesExitDateId
			
			FROM Staging.K12Enrollment ske
		--immigrant
			JOIN Staging.PersonStatus immigrant
				ON ske.Student_Identifier_State = immigrant.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(immigrant.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(immigrant.School_Identifier_State, '')
				AND immigrant.Immigrant_ProgramParticipationStartDate >= ske.EnrollmentEntryDate 
				AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(ske.EnrollmentExitDate, GETDATE())
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			LEFT JOIN RDS.DimLeas rdl
				ON ske.LEA_Identifier_State = rdl.LeaIdentifierState
				AND immigrant.Immigrant_ProgramParticipationStartDate >= rdl.RecordStartDateTime 
				AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(rdl.RecordEndDateTime, GETDATE())
			LEFT JOIN RDS.DimK12Schools rdksch
				ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
				AND immigrant.Immigrant_ProgramParticipationStartDate >= rdksch.RecordStartDateTime 
				AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(rdksch.RecordEndDateTime, GETDATE())
			JOIN RDS.DimSeas rds
				ON immigrant.Immigrant_ProgramParticipationStartDate >= convert(date, rds.RecordStartDateTime)
				AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(convert(date, rds.RecordEndDateTime), GETDATE())
		--english learner
			LEFT JOIN Staging.PersonStatus el 
				ON ske.Student_Identifier_State = el.Student_Identifier_State
				AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(el.LEA_Identifier_State, '') 
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
				AND immigrant.Immigrant_ProgramParticipationStartDate >= el.EnglishLearner_StatusStartDate 
				AND el.EnglishLearner_StatusStartDate <= ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
			LEFT JOIN #vwK12Demographics rdkd
 				ON ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = ISNULL(CAST(rdkd.EnglishLearnerStatusMap AS SMALLINT), -1)
				AND rdkd.EconomicDisadvantageStatusCode = 'MISSING'
				AND rdkd.HomelessnessStatusCode = 'MISSING'
				AND rdkd.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
				AND rdkd.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
				AND rdkd.MigrantStatusCode = 'MISSING'
				AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
			LEFT JOIN #vwProgramStatuses rps
 				ON ISNULL(CAST(immigrant.ProgramType_Immigrant AS SMALLINT), -1) = ISNULL(CAST(rps.TitleIIIImmigrantParticipationStatusMap AS SMALLINT), -1)
				AND rps.EligibilityStatusForSchoolFoodServiceProgramCode = 'MISSING'
				AND rps.FosterCareProgramCode = 'MISSING'
				AND rps.Section504StatusCode = 'MISSING'
				AND rps.TitleiiiProgramParticipationCode = 'MISSING'
				AND rps.HomelessServicedIndicatorCode = 'NO'
			LEFT JOIN #vwLanguages rdvl
 				ON ISNULL(immigrant.ISO_639_2_NativeLanguage, 'MISSING') = ISNULL(rdvl.Iso6392LanguageMap, 'MISSING')
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, immigrant.Immigrant_ProgramParticipationStartDate) = rda.AgeValue
			JOIN RDS.DimK12Students rdks
				ON ske.Student_Identifier_State = rdks.StateStudentIdentifier
				AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
				AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
				AND immigrant.Immigrant_ProgramParticipationStartDate >= rdks.RecordStartDateTime 
				AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(rdks.RecordEndDateTime, GETDATE())
			WHERE immigrant.ProgramType_Immigrant = 1 
			AND immigrant.Immigrant_ProgramParticipationStartDate >= ske.EnrollmentEntryDate 
			AND immigrant.Immigrant_ProgramParticipationStartDate <= ISNULL(ske.EnrollmentExitDate, GETDATE())

			--Final insert into RDS.FactK12StudentCounts table 
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
			DROP TABLE #vwK12Demographics
			DROP TABLE #vwProgramStatuses
			DROP TABLE #vwLanguages


		END TRY
		BEGIN CATCH
			INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_TitleIIIELSY', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
		END CATCH

END