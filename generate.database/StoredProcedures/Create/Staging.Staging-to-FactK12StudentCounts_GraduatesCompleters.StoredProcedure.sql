/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Graduate/Completer Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_GraduatesCompleters]
	@SchoolYear SMALLINT
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		--create indexes to improve query performance
		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PersonRace_StudentId_SchoolYear' AND object_id = OBJECT_ID('Staging.PersonRace')) BEGIN
			CREATE NONCLUSTERED INDEX [IX_Staging_PersonRace_StudentId_SchoolYear]
			ON [Staging].[PersonRace] ([Student_Identifier_State],[SchoolYear])
			INCLUDE ([OrganizationIdentifier],[OrganizationType],[RaceType])
		END


		IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PersonStatus_IdeaStatusStartDate_WithIncludes2' AND object_id = OBJECT_ID('Staging.PersonStatus')) BEGIN
			CREATE NONCLUSTERED INDEX [IX_Staging_PersonStatus_IdeaStatusStartDate_WithIncludes2]
			ON [Staging].[PersonStatus] ([IDEA_StatusStartDate])
			INCLUDE ([Student_Identifier_State],[LEA_Identifier_State],[School_Identifier_State],[IDEAIndicator],[IDEA_StatusEndDate],[PrimaryDisabilityType])
		END

		--Set the standard variables used throughout
		DECLARE 
		@FactTypeId int,
		@SchoolYearId int,
		@ReportingStartDate date,
		@ReportingEndDate date

		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		--Set the reporting period as 10-01 to 09-30
		SELECT @ReportingStartDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-10-01'AS DATE)
		SELECT @ReportingEndDate = CAST(CAST(@SchoolYear AS CHAR(4)) + '-09-30'AS DATE)

		--create/populate the temp tables for Organization types
		CREATE TABLE #seaOrganizationTypes (
			SeaOrganizationType					VARCHAR(20)
		)

		CREATE TABLE #leaOrganizationTypes (
			LeaOrganizationType					VARCHAR(20)
		)

		CREATE TABLE #schoolOrganizationTypes (
			K12SchoolOrganizationType			VARCHAR(20)
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

		--Create the temp views (and any relevant indexes) needed for this domain
		SELECT *
		INTO #vwK12StudentStatuses
		FROM RDS.vwDimK12StudentStatuses
		WHERE SchoolYear = @SchoolYear
		CREATE CLUSTERED INDEX ix_tempvwK12StudentStatuses 
			ON #vwK12StudentStatuses (HighSchoolDiplomaTypeCode, NSLPDirectCertificationIndicatorCode);

		SELECT *
		INTO #vwK12Demographics
		FROM RDS.vwDimK12Demographics
		WHERE SchoolYear = @SchoolYear
		CREATE CLUSTERED INDEX ix_tempvwK12Demographics 
			ON #vwK12Demographics (EnglishLearnerStatusMap, EconomicDisadvantageStatusCode, HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode, MigrantStatusCode, MilitaryConnectedStudentIndicatorCode);

		SELECT *
		INTO #vwIdeaStatuses
		FROM RDS.vwDimIdeaStatuses
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, PrimaryDisabilityTypeMap, IdeaEducationalEnvironmentMap);

		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

		--Set the correct Fact Type
		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'Grad'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

		IF OBJECT_ID('tempdb..#Facts') IS NOT NULL DROP TABLE #Facts
		
		--Create and load #Facts temp table
		CREATE TABLE #Facts (
				StagingId 								int not null
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
			, -1										AgeId
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
			AND ((rdl.RecordStartDateTime BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (rdl.RecordStartDateTime < @ReportingStartDate AND ISNULL(rdl.RecordEndDateTime, GETDATE()) > @ReportingStartDate))
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
			AND ((rdksch.RecordStartDateTime BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (rdksch.RecordStartDateTime < @ReportingStartDate AND ISNULL(rdksch.RecordEndDateTime, GETDATE()) > @ReportingStartDate))
		JOIN RDS.DimSeas rds
			ON ((rds.RecordStartDateTime BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (rds.RecordStartDateTime < @ReportingStartDate AND ISNULL(rds.RecordEndDateTime, GETDATE()) > @ReportingStartDate))
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.Student_Identifier_State = sppse.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(sppse.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(sppse.School_Identifier_State, '')
			AND sppse.ProgramParticipationBeginDate BETWEEN @ReportingStartDate and @ReportingEndDate
			AND ((sppse.ProgramParticipationBeginDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (sppse.ProgramParticipationBeginDate < @ReportingStartDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN RDS.vwUnduplicatedRaceMap spr 
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.Student_Identifier_State = spr.Student_Identifier_State
			AND (spr.OrganizationType in (SELECT SeaOrganizationType FROM #seaOrganizationTypes)
				OR (ske.LEA_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT LeaOrganizationType FROM #leaOrganizationTypes))
				OR (ske.School_Identifier_State = spr.OrganizationIdentifier
					AND spr.OrganizationType in (SELECT K12SchoolOrganizationType FROM #schoolOrganizationTypes)))
		LEFT JOIN Staging.PersonStatus idea
			ON ske.Student_Identifier_State = idea.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
			AND idea.IdeaIndicator = 1
			AND ((idea.IDEA_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (idea.IDEA_StatusStartDate < @ReportingStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN Staging.PersonStatus el 
			ON ske.Student_Identifier_State = el.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(el.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
			AND el.EnglishLearnerStatus = 1
			AND ((el.EnglishLearner_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (el.EnglishLearner_StatusStartDate < @ReportingStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN Staging.PersonStatus homeless 
			ON ske.Student_Identifier_State = homeless.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(homeless.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(homeless.School_Identifier_State, '')
			AND homeless.HomelessnessStatus = 1
			AND ((homeless.Homelessness_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (homeless.Homelessness_StatusStartDate < @ReportingStartDate AND ISNULL(homeless.Homelessness_StatusEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN Staging.PersonStatus ecoDis
			ON ske.Student_Identifier_State = ecoDis.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(ecoDis.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(ecoDis.School_Identifier_State, '')
			AND ecoDis.EconomicDisadvantageStatus = 1
			AND ((ecoDis.EconomicDisadvantage_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (ecoDis.EconomicDisadvantage_StatusStartDate < @ReportingStartDate AND ISNULL(ecoDis.EconomicDisadvantage_StatusEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN Staging.PersonStatus migrant
			ON ske.Student_Identifier_State = migrant.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(migrant.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(migrant.School_Identifier_State, '')
			AND migrant.MigrantStatus = 1
			AND ((migrant.Migrant_StatusStartDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (migrant.Migrant_StatusStartDate < @ReportingStartDate AND ISNULL(migrant.Migrant_StatusEndDate, GETDATE()) > @ReportingStartDate))
		LEFT JOIN #vwK12Demographics rdkd
			ON ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = rdkd.EnglishLearnerStatusMap
			AND ISNULL(CAST(ecoDis.EconomicDisadvantageStatus AS SMALLINT), -1) = rdkd.EconomicDisadvantageStatusMap
			AND ISNULL(CAST(homeless.HomelessnessStatus AS SMALLINT), -1) = rdkd.HomelessnessStatusMap
			AND ISNULL(CAST(migrant.MigrantStatus AS SMALLINT), -1) = rdkd.MigrantStatusMap
			AND rdkd.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdkd.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
		LEFT JOIN #vwK12StudentStatuses rkss
			ON ISNULL(ske.HighSchoolDiplomaType, 'MISSING') = ISNULL(rkss.HighSchoolDiplomaTypeMap, rkss.HighSchoolDiplomaTypeCode)
			AND rkss.NSLPDirectCertificationIndicatorCode = 'MISSING'
			AND rkss.MobilityStatus12moCode = 'MISSING'
			AND rkss.MobilityStatusSYCode = 'MISSING'	
			AND rkss.ReferralStatusCode = 'MISSING'	
			AND rkss.MobilityStatus36moCode = 'MISSING'
			AND rkss.PlacementStatusCode = 'MISSING'
			AND rkss.PlacementTypeCode = 'MISSING'
		LEFT JOIN #vwIdeaStatuses rdis
			ON ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = rdis.IdeaIndicatorMap
			AND ISNULL(idea.PrimaryDisabilityType, 'MISSING') = ISNULL(rdis.PrimaryDisabilityTypeMap, rdis.PrimaryDisabilityTypeCode)
			AND rdis.IdeaEducationalEnvironmentCode = 'MISSING'
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'
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
			AND rdks.RecordStartDateTime BETWEEN @ReportingStartDate and @ReportingEndDate
			AND ((rdks.RecordStartDateTime BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (rdks.RecordStartDateTime < @ReportingStartDate AND ISNULL(rdks.RecordEndDateTime, GETDATE()) > @ReportingStartDate))
		WHERE (ske.EnrollmentEntryDate BETWEEN @ReportingStartDate and @ReportingEndDate)
				OR (ske.EnrollmentEntryDate < @ReportingStartDate AND ISNULL(ske.EnrollmentExitDate, GETDATE()) > @ReportingStartDate)
		AND ISNULL(ske.HighSchoolDiplomaType, '') <> ''

		--Final insert into RDS.FactK12StudentCounts table
		INSERT INTO RDS.FactK12StudentCounts (
			[AgeId]
			, [SchoolYearId]
			, [K12DemographicId]
			, [FactTypeId]
			, [GradeLevelId]
			, [IdeaStatusId]
			, [ProgramStatusId]
			, [K12SchoolId]
			, [K12StudentId]
			, [StudentCount]
			, [LanguageId]
			, [MigrantId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [LeaId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDProgramStatusId]
			, [StudentCutOverStartDate]
			, [RaceId]
			, [CteStatusId]
			, [K12EnrollmentStatusId]
			, [SeaId]
			, [IeuId]
			, [SpecialEducationServicesExitDateId]
		)
		SELECT
			[AgeId]
			, [SchoolYearId]
			, [K12DemographicId]
			, [FactTypeId]
			, [GradeLevelId]
			, [IdeaStatusId]
			, [ProgramStatusId]
			, [K12SchoolId]
			, [K12StudentId]
			, [StudentCount]
			, [LanguageId]
			, [MigrantId]
			, [K12StudentStatusId]
			, [TitleIStatusId]
			, [TitleIIIStatusId]
			, [LeaId]
			, [AttendanceId]
			, [CohortStatusId]
			, [NOrDProgramStatusId]
			, [StudentCutOverStartDate]
			, [RaceId]
			, [CteStatusId]
			, [K12EnrollmentStatusId]
			, [SeaId]
			, [IeuId]
			, [SpecialEducationServicesExitDateId]
		FROM #Facts

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD

		--Drop temp tables 
		DROP TABLE #seaOrganizationTypes
		DROP TABLE #leaOrganizationTypes
		DROP TABLE #schoolOrganizationTypes
		DROP TABLE #vwK12StudentStatuses
		DROP TABLE #vwIdeaStatuses
		DROP TABLE #vwK12Demographics
		DROP TABLE #vwRaces

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH
		
END

