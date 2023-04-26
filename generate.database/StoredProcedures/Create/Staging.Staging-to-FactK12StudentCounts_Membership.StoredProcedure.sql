/**********************************************************************
Author: AEM Corp
Date:	2/17/2023
Description: Migrates Membership Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_Membership]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PersonRace_StudentId_SchoolYear' AND object_id = OBJECT_ID('Staging.PersonRace')) BEGIN
			CREATE NONCLUSTERED INDEX [IX_Staging_PersonRace_StudentId_SchoolYear]
			ON [Staging].[PersonRace] ([Student_Identifier_State],[SchoolYear])
			INCLUDE ([OrganizationIdentifier],[OrganizationType],[RaceType])
		END

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId int,
		@MembershipDate date
		
	/*  Setting variables to be used in the select statements */
		
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SELECT @MembershipDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'MEMBERDTE'

		IF ISNULL(@MembershipDate, '') = ''
		BEGIN
			SELECT @MembershipDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-10-01' AS DATE)
		END
		ELSE 
		BEGIN
			SELECT @MembershipDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@MembershipDate) AS VARCHAR(2)) + '-' + CAST(DAY(@MembershipDate) AS VARCHAR(2)) AS DATE)
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

	/*  Creating temp tables to be used in the select statement joins */

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
		INTO #vwK12StudentStatuses
		FROM RDS.vwDimK12StudentStatuses
		WHERE SchoolYear = 2023--@SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwK12StudentStatuses 
			ON #vwK12StudentStatuses (HighSchoolDiplomaTypeCode, NSLPDirectCertificationIndicatorCode);

		SELECT *
		INTO #vwProgramStatuses
		FROM RDS.vwDimProgramStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwProgramStatuses
			ON #vwProgramStatuses (EligibilityStatusForSchoolFoodServiceProgramCode, FosterCareProgramCode, TitleIIIImmigrantParticipationStatusCode, Section504StatusCode, TitleiiiProgramParticipationCode, HomelessServicedIndicatorCode);


		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'membership'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts
		
	/*  Creating and load #Facts temp table */
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
				, -1										K12DemographicId
				, @FactTypeId								FactTypeId
				, ISNULL(rgls.DimGradeLevelId, -1)			GradeLevelId
				, -1										IdeaStatusId
				, ISNULL(rps.DimProgramStatusId, -1)		ProgramStatusId
				, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
				, ISNULL(rdks.DimK12StudentId, -1)			K12StudentId
				, 1											StudentCount
				, -1										LanguageId
				, -1										MigrantId
				, ISNULL(rkss.DimK12StudentStatusId, -1)	K12StudentStatusId
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
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			LEFT JOIN RDS.DimLeas rdl
				ON ske.LEA_Identifier_State = rdl.LeaIdentifierState
				AND @MembershipDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
			LEFT JOIN RDS.DimK12Schools rdksch
				ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
				AND @MembershipDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
			JOIN RDS.DimSeas rds
				ON @MembershipDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
			LEFT JOIN Staging.PersonStatus foodService
				ON ske.Student_Identifier_State = foodService.Student_Identifier_State
				AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(foodService.Lea_Identifier_State, '')
				AND ISNULL(ske.School_Identifier_State, '') = ISNULL(foodService.School_Identifier_State, '')
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.Student_Identifier_State = spr.Student_Identifier_State
				AND (spr.OrganizationType in (SELECT SeaOrganizationType FROM #seaOrganizationTypes)
					OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
						AND spr.OrganizationType in (SELECT LeaOrganizationType FROM #leaOrganizationTypes))
					OR (ske.School_Identifier_State = spr.OrganizationIdentifier
						AND spr.OrganizationType in (SELECT K12SchoolOrganizationType FROM #schoolOrganizationTypes)))
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, @MembershipDate) = rda.AgeValue
			LEFT JOIN #vwGradeLevels rgls
				ON ske.GradeLevel = rgls.GradeLevelMap
				AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
			LEFT JOIN #vwRaces rdr
				ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceMap IS NOT NULL THEN spr.RaceMap
						ELSE 'Missing'
					END
			LEFT JOIN #vwK12StudentStatuses rkss
 				ON ISNULL(CAST(foodService.NationalSchoolLunchProgramDirectCertificationIndicator AS SMALLINT), -1) = rkss.NSLPDirectCertificationIndicatorMap
				AND rkss.HighSchoolDiplomaTypeCode = 'MISSING'
				AND rkss.MobilityStatus12moCode = 'MISSING'
				AND rkss.MobilityStatusSYCode = 'MISSING'	
				AND rkss.ReferralStatusCode = 'MISSING'	
				AND rkss.MobilityStatus36moCode = 'MISSING'
				AND rkss.PlacementStatusCode = 'MISSING'
				AND rkss.PlacementTypeCode = 'MISSING'
			LEFT JOIN #vwProgramStatuses rps
 				ON ISNULL(foodService.EligibilityStatusForSchoolFoodServicePrograms, 'MISSING') = ISNULL(rps.EligibilityStatusForSchoolFoodServiceProgramMap, 'MISSING')
				AND rps.FosterCareProgramCode = 'MISSING'
				AND rps.TitleIIIImmigrantParticipationStatusCode = 'MISSING'
				AND rps.Section504StatusCode = 'MISSING'
				AND rps.TitleiiiProgramParticipationCode = 'MISSING'
				AND rps.HomelessServicedIndicatorCode = 'NO'
			LEFT JOIN Staging.SourceSystemReferenceData sssrd
				ON ISNULL(ske.Sex, 'MISSING') = sssrd.InputCode
				AND sssrd.TableName = 'RefSex'
				AND sssrd.SchoolYear = ske.SchoolYear
			JOIN RDS.DimK12Students rdks
				ON ske.Student_Identifier_State = rdks.StateStudentIdentifier
				AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
				AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
				AND ISNULL(sssrd.OutputCode, '') = ISNULL(rdks.SexCode, '')
				AND ISNULL(ske.EnrollmentEntryDate, '') = ISNULL(rdks.RecordStartDateTime, '')
				AND @MembershipDate BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, GETDATE())
			WHERE @MembershipDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())

		/*  Final insert into RDS.FactK12StudentCounts  table */
			INSERT INTO RDS.FactK12StudentCounts
				([AgeId]
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
				,[SpecialEducationServicesExitDateId])
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

		/*  Drop temp tables clean up before new ones are created */
			DROP TABLE #seaOrganizationTypes
			DROP TABLE #leaOrganizationTypes
			DROP TABLE #schoolOrganizationTypes
			DROP TABLE #vwGradeLevels
			DROP TABLE #vwRaces
			DROP TABLE #vwK12StudentStatuses
			DROP TABLE #vwProgramStatuses

		END TRY
		BEGIN CATCH
			INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_Membership', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
		END CATCH

END
