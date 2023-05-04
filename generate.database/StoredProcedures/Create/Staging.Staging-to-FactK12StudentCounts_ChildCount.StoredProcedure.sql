/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Child Count Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_ChildCount]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		-- IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_K12PersonRace_StudentId_SchoolYear' AND object_id = OBJECT_ID('Staging.K12PersonRace')) BEGIN
		-- 	CREATE NONCLUSTERED INDEX [IX_Staging_PersonRace_StudentId_SchoolYear]
		-- 	ON [Staging].[K12PersonRace] ([StudentIdentifierState],[SchoolYear])
		-- 	INCLUDE ([RaceType])
		-- END
					
		DECLARE 
		@FactTypeId INT,
		@SchoolYearId int,
		@ChildCountDate date
		
	/*  Setting variables to be used in the select statements */
		
		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear


		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)

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

		CREATE CLUSTERED INDEX ix_tempvwGradeLevels ON #vwGradeLevels (GradeLevelTypeDescription, GradeLevelMap);

		SELECT *
		INTO #vwIdeaStatuses
		FROM RDS.vwDimIdeaStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, IdeaEducationalEnvironmentForSchoolageMap);

		IF OBJECT_ID('tempdb..#vwDimMigrantStatuses') IS NOT NULL 
			DROP TABLE #vwDimMigrantStatuses		
		SELECT *
		INTO #vwDimMigrantStatuses
		FROM RDS.vwDimMigrantStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE INDEX ix_vwDimMigrantStatuses ON #vwDimMigrantStatuses (ContinuationOfServicesReasonMap, MigrantEducationProgramServicesTypeMap, MigrantPrioritizedForServicesMap, MigrantEducationProgramEnrollmentTypeMap)
			INCLUDE (ContinuationOfServicesReasonCode, MigrantEducationProgramServicesTypeCode, MigrantPrioritizedForServicesCode, MigrantEducationProgramEnrollmentTypeCode);

		IF OBJECT_ID('tempdb.dbo.#vwDimRaces', 'U') IS NOT NULL 
			DROP TABLE #vwDimRaces; 		
		SELECT v.* 
		INTO #vwDimRaces 
		FROM RDS.vwDimRaces v
		WHERE v.SchoolYear = @SchoolYear
		
		

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwDimRaces (RaceMap);

		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'childcount'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts
		
	/*  Creating and load #Facts temp table */
		CREATE TABLE #Facts (
				StagingId								int not null
			, SchoolYearId							int null
			, FactTypeId							int null
			, GradeLevelId							int null
			, AgeId									int null
			, RaceId								int null
			, K12DemographicId						int null
			, StudentCount							int null

			, SEAId									int null
			, IEUId									int null
			, LEAId									int null
			, K12SchoolId							int null
			, K12StudentId							int null

			, IdeaStatusId							int null
			, LanguageId							int null
			, MigrantStatusId						int null
			, K12StudentStatusId					int null
			, TitleIStatusId						int null
			, TitleIIIStatusId						int null
			, AttendanceId							int null
			, CohortStatusId						int null
			, NOrDStatusId							int null
			, CTEStatusId							int null
			, K12EnrollmentStatusId					int null
			, EnglishLearnerStatusId				int null
			, HomelessnessStatusId					int null
			, EconomicallyDisadvantagedStatusId		int null
			, FosterCareStatusId					int null
			, ImmigrantStatusId						int null
			, PrimaryDisabilityTypeId				int null

			, SpecialEducationServicesExitDateId	int null
			, MigrantStudentQualifyingArrivalDateId	int null
			, LastQualifyingMoveDateId				int null

			)

			INSERT INTO #Facts
			SELECT DISTINCT
			sppse.Id													StagingId
			, rsy.DimSchoolYearId										SchoolYearId
			, @FactTypeId												FactTypeId
			, ISNULL(rgls.DimGradeLevelId, -1)							GradeLevelId
			, rda.DimAgeId												AgeId
			, ISNULL(rdr.DimRaceId, -1)									RaceId
			, ISNULL(rdkd.DimK12DemographicId, -1)						K12DemographicId
			, 1															StudentCount
			, ISNULL(rds.DimSeaId, -1)									SEAId
			, -1														IEUId
			, ISNULL(rdl.DimLeaID, -1)									LEAId
			, ISNULL(rdksch.DimK12SchoolId, -1)							K12SchoolId
			, ISNULL(rdp.DimPersonId, -1)								K12StudentId
			, ISNULL(rdis.DimIdeaStatusId, -1)							IdeaStatusId
			, -1														LanguageId
			, -1														MigrantStatusId
			, -1														K12StudentStatusId
			, -1														TitleIStatusId
			, -1														TitleIIIStatusId
			, -1														AttendanceId
			, -1														CohortStatusId
			, -1														NOrDStatusId
			, -1														CTEStatusId
			, -1														K12EnrollmentStatusId
			, -1										 				EnglishLearnerStatusId
			, -1										 				HomelessnessStatusId
			, -1										 				EconomicallyDisadvantagedStatusId
			, -1														FosterCareStatusId
			, -1														ImmigrantStatusId
			, ISNULL(rdidt.DimIdeaDisabilityTypeId, -1)					PrimaryDisabilityTypeId
			, ISNULL(rdd.DimDateId, -1)									SpecialEducationServicesExitDateId
			, -1														MigrantStudentQualifyingArrivalDateId
			, -1								
		FROM Staging.K12Enrollment ske
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			LEFT JOIN RDS.DimLeas rdl
				ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
				AND @ChildCountDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
			LEFT JOIN RDS.DimK12Schools rdksch
				ON ske.SchoolIdentifierSea = rdksch.SchoolIdentifierSea
				AND @ChildCountDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
			JOIN RDS.DimSeas rds
				ON @ChildCountDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())		
			JOIN Staging.ProgramParticipationSpecialEducation sppse
				ON ske.StudentIdentifierState = sppse.StudentIdentifierState
				AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
				AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
			JOIN Staging.IdeaDisabilityType sidt	
				ON ske.SchoolYear = sidt.SchoolYear
				AND sidt.StudentIdentifierState = sppse.StudentIdentifierState
				AND ISNULL(sidt.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '')
				AND ISNULL(sidt.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
				AND sidt.IsPrimaryDisability = 1
				AND @ChildCountDate BETWEEN sidt.RecordStartDateTime AND ISNULL(sidt.RecordEndDateTime, GETDATE())

			LEFT JOIN RDS.DimDates rdd
				ON sppse.ProgramParticipationEndDate = rdd.DateValue
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.StudentIdentifierState = sppse.StudentIdentifierState
				AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sppse.LeaIdentifierSeaAccountability, '')
				AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sppse.SchoolIdentifierSea, '')
			LEFT JOIN Staging.PersonStatus el 
				ON ske.StudentIdentifierState = el.StudentIdentifierState
				AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(el.LeaIdentifierSeaAccountability, '') 
				AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(el.SchoolIdentifierSea, '')
				AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
			
			JOIN RDS.vwDimK12Demographics rdkd
 				ON rsy.SchoolYear = rdkd.SchoolYear
				--AND ISNULL(ske.Sex, 'MISSING') = ISNULL(rdkd.SexMap, rdkd.SexCode) -- do we need this?
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue
			LEFT JOIN #vwGradeLevels rgls
				ON ske.GradeLevel = rgls.GradeLevelMap
				AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
			LEFT JOIN #vwIdeaStatuses rdis
				ON rdis.IdeaIndicatorCode = 'Yes'
				AND CASE 
						WHEN rda.AgeCode = 'MISSING' THEN 'MISSING'
						WHEN 
							(rda.AgeCode < 5 OR (rda.AgeCode = 5 AND rgls.GradeLevelCode IN ('PK','MISSING')))
							AND	
							sppse.IDEAEducationalEnvironmentForEarlyChildhood IS NOT NULL AND sppse.IDEAEducationalEnvironmentForEarlyChildhood <> '' THEN sppse.IDEAEducationalEnvironmentForEarlyChildhood
						WHEN 
							(rda.AgeCode > 5 OR (rda.AgeCode = 5 AND rgls.GradeLevelCode NOT IN ('PK','MISSING')))
							AND
							sppse.IDEAEducationalEnvironmentForSchoolAge IS NOT NULL and sppse.IDEAEducationalEnvironmentForSchoolAge <> '' THEN sppse.IDEAEducationalEnvironmentForSchoolAge
						ELSE 'MISSING'
					END = ISNULL(rdis.IdeaEducationalEnvironmentForEarlyChildhoodMap, rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode)
				AND rdis.SpecialEducationExitReasonCode = 'MISSING'
			LEFT JOIN RDS.vwDimIdeaDisabilityTypes rdidt
				ON ske.SchoolYear = rdis.SchoolYear
			AND ISNULL(sidt.IdeaDisabilityType, 'MISSING') = ISNULL(IdeaDisabilityTypeMap, IdeaDisabilityTypeCode)
			
			
			LEFT JOIN #vwDimRaces rdr
				ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceCode IS NOT NULL THEN spr.RaceCode
						ELSE 'Missing'
					END
					AND rsy.SchoolYear = rdr.SchoolYear
			JOIN RDS.DimPeople rdp
				ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
				AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
				AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
				AND rdd.DateValue BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())
				AND IsActiveK12Student = 1
				AND @ChildCountDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())
			WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())

			
		/*  Final insert into RDS.FactK12StudentCounts  table */
		INSERT INTO RDS.FactK12StudentCounts (
			[SchoolYearId]
			, [FactTypeId]
			, [GradeLevelId]
			, [AgeId]
			, [RaceId]
			, [K12DemographicId]
			, [StudentCount]
			, [SEAId]
			, [IEUId]
			, [LEAId]
			, [K12SchoolId]
			, [K12StudentId]
			, [IdeaStatusId]
			, [LanguageId]
			, [MigrantStatusId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDStatusId]
			, [CTEStatusId]
			, [K12EnrollmentStatusId]
			, [EnglishLearnerStatusId]
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [FosterCareStatusId]
			, [ImmigrantStatusId]
			, [PrimaryDisabilityTypeId]
			, [SpecialEducationServicesExitDateId]
			, [MigrantStudentQualifyingArrivalDateId]
			, [LastQualifyingMoveDateId]
		)
		SELECT 
			[SchoolYearId]
			, [FactTypeId]
			, [GradeLevelId]
			, [AgeId]
			, [RaceId]
			, [K12DemographicId]
			, [StudentCount]
			, [SEAId]
			, [IEUId]
			, [LEAId]
			, [K12SchoolId]
			, [K12StudentId]
			, [IdeaStatusId]
			, [LanguageId]
			, [MigrantStatusId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDStatusId]
			, [CTEStatusId]
			, [K12EnrollmentStatusId]
			, [EnglishLearnerStatusId]
			, [HomelessnessStatusId]
			, [EconomicallyDisadvantagedStatusId]
			, [FosterCareStatusId]
			, [ImmigrantStatusId]
			, [PrimaryDisabilityTypeId]
			, [SpecialEducationServicesExitDateId]
			, [MigrantStudentQualifyingArrivalDateId]
			, [LastQualifyingMoveDateId]
		FROM #Facts

	

			ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

		/*  Drop temp tables clean up before new ones are created */
			DROP TABLE #seaOrganizationTypes
			DROP TABLE #leaOrganizationTypes
			DROP TABLE #schoolOrganizationTypes
			DROP TABLE #vwGradeLevels
			DROP TABLE #vwIdeaStatuses
			DROP TABLE #vwDimRaces


		END TRY
		BEGIN CATCH
			INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
		END CATCH

		
END

