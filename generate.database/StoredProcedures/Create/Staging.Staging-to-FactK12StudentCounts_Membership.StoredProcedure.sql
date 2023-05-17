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

		-- Drop temp tables.  This is only needed when running this procedure as a script multiple times
		IF OBJECT_ID(N'tempdb..#seaOrganizationTypes') IS NOT NULL DROP TABLE #seaOrganizationTypes
		IF OBJECT_ID(N'tempdb..#leaOrganizationTypes') IS NOT NULL DROP TABLE #leaOrganizationTypes
		IF OBJECT_ID(N'tempdb..#schoolOrganizationTypes') IS NOT NULL DROP TABLE #schoolOrganizationTypes
		IF OBJECT_ID(N'tempdb..#vwGradeLevels') IS NOT NULL DROP TABLE #vwGradeLevels
		IF OBJECT_ID(N'tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces
		IF OBJECT_ID(N'tempdb..#vwK12StudentStatuses') IS NOT NULL DROP TABLE #vwK12StudentStatuses

		IF OBJECT_ID(N'tempdb..#vwEconomicallyDisadvantagedStatuses') IS NOT NULL DROP TABLE #vwEconomicallyDisadvantagedStatuses
		IF OBJECT_ID(N'tempdb..#vwFosterCareStatuses') IS NOT NULL DROP TABLE #vwFosterCareStatuses
		IF OBJECT_ID(N'tempdb..#vwHomelessnessStatuses') IS NOT NULL DROP TABLE #vwHomelessnessStatuses
		IF OBJECT_ID(N'tempdb..#vwDisabilityStatuses') IS NOT NULL DROP TABLE #vwDisabilityStatuses
		IF OBJECT_ID(N'tempdb..#vwImmigrantStatuses') IS NOT NULL DROP TABLE #vwImmigrantStatuses

		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PersonRace_StudentId_SchoolYear' AND object_id = OBJECT_ID('Staging.K12PersonRace')) BEGIN
			CREATE NONCLUSTERED INDEX [IX_Staging_PersonRace_StudentId_SchoolYear]
			ON [Staging].[K12PersonRace] ([StudentIdentifierState],[SchoolYear])
			INCLUDE (OrganizationID_LEA, OrganizationID_School,RaceType)
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
		WHERE SchoolYear = @SchoolYear

		--CREATE CLUSTERED INDEX ix_tempvwK12StudentStatuses 
		--	ON #vwK12StudentStatuses (DiplomaCredentialTypeCode, NSLPDirectCertificationIndicatorCode);

		SELECT * 
		INTO #vwEconomicallyDisadvantagedStatuses
		FROM RDS.vwDimEconomicallyDisadvantagedStatuses
		WHERE SchoolYear = @SchoolYear

		SELECT * 
		INTO #vwFosterCareStatuses
		FROM RDS.vwDimFosterCareStatuses
		WHERE SchoolYear = @SchoolYear

		SELECT * 
		INTO #vwHomelessnessStatuses
		FROM RDS.vwDimHomelessnessStatuses
		WHERE SchoolYear = @SchoolYear

		SELECT * 
		INTO #vwDisabilityStatuses
		FROM RDS.vwDimDisabilityStatuses
		WHERE SchoolYear = @SchoolYear

		SELECT * 
		INTO #vwImmigrantStatuses
		FROM RDS.vwDimImmigrantStatuses
		WHERE SchoolYear = @SchoolYear

		
		--SELECT *
		--INTO #vwProgramStatuses
		--FROM RDS.vwDimProgramStatuses
		--WHERE SchoolYear = @SchoolYear

		--CREATE CLUSTERED INDEX ix_tempvwProgramStatuses
		--	ON #vwProgramStatuses (EligibilityStatusForSchoolFoodServiceProgramCode, FosterCareProgramCode, TitleIIIImmigrantParticipationStatusCode, Section504StatusCode, TitleiiiProgramParticipationCode, HomelessServicedIndicatorCode);


		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'membership'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts
		
	/*  Creating and load #Facts temp table */
		CREATE TABLE #Facts (
			StagingId int NOT NULL,
			SchoolYearId int  NULL,
			FactTypeId int  NULL,
			SeaId int  NULL,
			IeuId int  NULL,
			LeaId int  NULL,
			K12SchoolId int  NULL,
			K12StudentId bigint  NULL,
			AgeId int  NULL,
			AttendanceId int  NULL,
			CohortStatusId int  NULL,
			CteStatusId int  NULL,
			EnglishLearnerStatusId int  NULL,
			GradeLevelId int  NULL,
			HomelessnessStatusId int  NULL,
			EconomicallyDisadvantagedStatusId int  NULL,
			FosterCareStatusId int  NULL,
			IdeaStatusId int  NULL,
			ImmigrantStatusId int  NULL,
			K12DemographicId int  NULL,
			K12EnrollmentStatusId int  NULL,
			K12StudentStatusId int  NULL,
			LanguageId int  NULL,
			MigrantStatusId int  NULL,
			NOrDStatusId int  NULL,
			PrimaryDisabilityTypeId int  NULL,
			RaceId int  NULL,
			SpecialEducationServicesExitDateId int  NULL,
			MigrantStudentQualifyingArrivalDateId int  NULL,
			LastQualifyingMoveDateId int  NULL,
			TitleIStatusId int  NULL,
			TitleIIIStatusId int  NULL,
			StudentCount int  NULL

			)

			INSERT INTO #Facts
			SELECT DISTINCT
				ske.id										StagingId
				, rsy.DimSchoolYearId						SchoolYearId
				, @FactTypeId								FactTypeId
				, ISNULL(rds.DimSeaId, -1)					SEAId
				, -1										IEUId
				, ISNULL(rdl.DimLeaID, -1)					LEAId
				, ISNULL(rdpch.DimK12SchoolId, -1)			K12SchoolId
				, ISNULL(rdp.DimPersonId, -1)				K12StudentId
				, rda.DimAgeId								AgeId
				, -1										AttendanceId
				, -1										CohortStatusId
				, -1										CTEStatusId
				, 0											EnglishLearnerStatusId -- TO BE DETERMINED --
				, ISNULL(rgls.DimGradeLevelId, -1)			GradeLevelId
				, 0											HomelessnessStatusId -- TO BE DETERMINED --
				, 0											EconomicallyDisadvantagedStatusId -- TO BE DETERMINED --
				, 0											FosterCareStatusId -- TO BE DETERMINED --
				, -1										IdeaStatusId
				, 0											ImmigrantStatusId -- TO BE DETERMINED --
				, -1										K12DemographicId
				, -1										K12EnrollmentStatusId
				, ISNULL(rkss.DimK12StudentStatusId, -1)	K12StudentStatusId
				, -1										LanguageId
				, 0											MigrantStatusId -- TO BE DETERMINED --
				, 0											NOrDStatusId 
				, 0											PrimaryDisabilityTypeId -- TO BE DETERMINED --
				, ISNULL(rdr.DimRaceId, -1)					RaceId
				, -1										SpecialEducationServicesExitDateId 
				, 0											MigrantStudentQualifyingArrivalDateId -- TO BE DETERMINED --
				, -1										LastQualifyingMoveDateId
				, -1										TitleIStatusId
				, -1										TitleIIIStatusId
				, 1											StudentCount

			
			FROM Staging.K12Enrollment ske
			JOIN RDS.DimSchoolYears rsy
				ON ske.SchoolYear = rsy.SchoolYear
			
			LEFT JOIN RDS.DimLeas rdl
				ON ske.LeaIdentifierSeaAccountability = rdl.LeaIdentifierSea
				AND @MembershipDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
			
			LEFT JOIN RDS.DimK12Schools rdpch
				ON ske.SchoolIdentifierSea = rdpch.SchoolIdentifierSea
				AND @MembershipDate BETWEEN rdpch.RecordStartDateTime AND ISNULL(rdpch.RecordEndDateTime, GETDATE())
			
			JOIN RDS.DimSeas rds
				ON @MembershipDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
			
			LEFT JOIN Staging.PersonStatus sps	
				ON ske.StudentIdentifierState = sps.StudentIdentifierState
				AND ISNULL(ske.LeaIdentifierSeaAccountability, '') = ISNULL(sps.LeaIdentifierSeaAccountability, '')
				AND ISNULL(ske.SchoolIdentifierSea, '') = ISNULL(sps.SchoolIdentifierSea, '')
			
			LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
				ON ske.SchoolYear = spr.SchoolYear
				AND ske.StudentIdentifierState = spr.StudentIdentifierState
				AND (ske.LEAIdentifierSeaAccountability = spr.LeaIdentifierSeaAccountability
						OR ske.SchoolIdentifierSea = spr.SchoolIdentifierSea)
			
			JOIN RDS.DimAges rda
				ON RDS.Get_Age(ske.Birthdate, @MembershipDate) = rda.AgeValue
			
			LEFT JOIN #vwGradeLevels rgls
				ON rgls.SchoolYear = ske.SchoolYear
				AND ske.GradeLevel = rgls.GradeLevelMap
				AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
			
			LEFT JOIN #vwRaces rdr
				ON rdr.SchoolYear = ske.SchoolYear
					AND ISNULL(rdr.RaceCode, rdr.RaceMap) =
					CASE
						when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
						WHEN spr.RaceCode IS NOT NULL THEN spr.RaceCode
						ELSE 'Missing'
					END
			
			LEFT JOIN #vwK12StudentStatuses rkss
 				ON rkss.SchoolYear = ske.SchoolYear
				AND rkss.DiplomaCredentialTypeCode = 'MISSING'
				AND rkss.MobilityStatus12moCode = 'MISSING'
				AND rkss.MobilityStatusSYCode = 'MISSING'	
				AND rkss.ReferralStatusCode = 'MISSING'	
				AND rkss.MobilityStatus36moCode = 'MISSING'
				AND rkss.PlacementStatusCode = 'MISSING'
				AND rkss.PlacementTypeCode = 'MISSING'

			LEFT JOIN #vwEconomicallyDisadvantagedStatuses vecon
				ON vecon.SchoolYear = ske.SchoolYear
				AND ISNULL(sps.EligibilityStatusForSchoolFoodServicePrograms, 'MISSING') = ISNULL(vecon.EligibilityStatusForSchoolFoodServiceProgramsMap, 'MISSING')
				AND ISNULL(CAST(sps.NationalSchoolLunchProgramDirectCertificationIndicator AS SMALLINT), -1)  = isnull(vecon.NationalSchoolLunchProgramDirectCertificationIndicatorMap, -1)
				AND ISNULL(CAST(sps.EconomicDisadvantageStatus as SMALLINT), -1) = ISNULL(vecon.EconomicDisadvantageStatusMap, -1)

			LEFT JOIN #vwFosterCareStatuses vfoster
				ON vfoster.SchoolYear = ske.SchoolYear
				AND ISNULL(CAST(sps.ProgramType_FosterCare AS SMALLINT), -1) = ISNULL(vfoster.ProgramParticipationFosterCareMap, -1)

			LEFT JOIN #vwHomelessnessStatuses vhomeless
				ON vhomeless.SchoolYear = ske.SchoolYear
				AND ISNULL(CAST(sps.HomelessnessStatus AS SMALLINT), -1) = ISNULL(vhomeless.HomelessnessStatusMap, -1)
				AND ISNULL(sps.HomelessNightTimeResidence, 'MISSING') = ISNULL(vhomeless.HomelessPrimaryNighttimeResidenceMap, 'MISSING')
				AND ISNULL(CAST(sps.HomelessServicedIndicator AS SMALLINT), -1) = ISNULL(vhomeless.HomelessServicedIndicatorMap, -1)
				AND ISNULL(CAST(sps.HomelessUnaccompaniedYouth AS SMALLINT), -1) = ISNULL(vhomeless.HomelessUnaccompaniedYouthStatusMap, -1)


			LEFT JOIN #vwImmigrantStatuses vimmigrant
				ON vimmigrant.SchoolYear = ske.SchoolYear
				AND ISNULL(CAST(sps.ProgramType_Immigrant AS SMALLINT), -1) = ISNULL(vimmigrant.TitleIIIImmigrantParticipationStatusMap, -1)

			JOIN RDS.DimPeople rdp
				ON ske.StudentIdentifierState = rdp.K12StudentStudentIdentifierState
				AND ISNULL(ske.FirstName, '') = ISNULL(rdp.FirstName, '')
				AND ISNULL(ske.MiddleName, '') = ISNULL(rdp.MiddleName, '')
				AND ISNULL(ske.LastOrSurname, 'MISSING') = rdp.LastOrSurname
				AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdp.BirthDate, '1/1/1900')
				AND @MembershipDate BETWEEN rdp.RecordStartDateTime AND ISNULL(rdp.RecordEndDateTime, GETDATE())

			WHERE @MembershipDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())


		/*  Final insert into RDS.FactK12StudentCounts  table */
		INSERT INTO RDS.FactK12StudentCounts
           (SchoolYearId
           ,FactTypeId
           ,SeaId
           ,IeuId
           ,LeaId
           ,K12SchoolId
           ,K12StudentId
           ,AgeId
           ,AttendanceId
           ,CohortStatusId
           ,CteStatusId
           ,EnglishLearnerStatusId
           ,GradeLevelId
           ,HomelessnessStatusId
           ,EconomicallyDisadvantagedStatusId
           ,FosterCareStatusId
           ,IdeaStatusId
           ,ImmigrantStatusId
           ,K12DemographicId
           ,K12EnrollmentStatusId
           ,K12StudentStatusId
           ,LanguageId
           ,MigrantStatusId
           ,NOrDStatusId
           ,PrimaryDisabilityTypeId
           ,RaceId
           ,SpecialEducationServicesExitDateId
           ,MigrantStudentQualifyingArrivalDateId
           ,LastQualifyingMoveDateId
           ,TitleIStatusId
           ,TitleIIIStatusId
           ,StudentCount)
		SELECT
			SchoolYearId
			,FactTypeId
			,SeaId
			,IeuId
			,LeaId
			,K12SchoolId
			,K12StudentId
			,AgeId
			,AttendanceId
			,CohortStatusId
			,CteStatusId
			,EnglishLearnerStatusId
			,GradeLevelId
			,HomelessnessStatusId
			,EconomicallyDisadvantagedStatusId
			,FosterCareStatusId
			,IdeaStatusId
			,ImmigrantStatusId
			,K12DemographicId
			,K12EnrollmentStatusId
			,K12StudentStatusId
			,LanguageId
			,MigrantStatusId
			,NOrDStatusId
			,PrimaryDisabilityTypeId
			,RaceId
			,SpecialEducationServicesExitDateId
			,MigrantStudentQualifyingArrivalDateId
			,LastQualifyingMoveDateId
			,TitleIStatusId
			,TitleIIIStatusId
			,StudentCount			
		FROM #Facts
	
			ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD


		END TRY
		BEGIN CATCH
			INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_Membership', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
		END CATCH

END