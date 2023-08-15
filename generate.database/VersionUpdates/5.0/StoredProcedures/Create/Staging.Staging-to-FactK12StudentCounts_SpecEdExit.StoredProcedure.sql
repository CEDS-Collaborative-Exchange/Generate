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
		@EndDate DATE

		SELECT @SchoolYearId = DimSchoolYearId 
		FROM RDS.DimSchoolYears
		WHERE SchoolYear = @SchoolYear

		SELECT @StartDate = CAST('7/1/' + CAST(@SchoolYear - 1 AS VARCHAR(4)) AS DATE)
		SELECT @EndDate = CAST('6/30/' + CAST(@SchoolYear  AS VARCHAR(4)) AS DATE)


		SELECT @ChildCountDate = tr.ResponseValue
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'CHDCTDTE'

		SELECT @ChildCountDate = CAST(CAST(@SchoolYear - 1 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)
		SELECT @PreviousChildCountDate = CAST(CAST(@SchoolYear - 2 AS CHAR(4)) + '-' + CAST(MONTH(@ChildCountDate) AS VARCHAR(2)) + '-' + CAST(DAY(@ChildCountDate) AS VARCHAR(2)) AS DATE)

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

		IF OBJECT_ID('tempdb..#vwRaces') IS NOT NULL DROP TABLE #vwRaces		
		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'specedexit'

		DELETE RDS.FactK12StudentCounts
		WHERE SchoolYearId = @SchoolYearId 
			AND FactTypeId = @FactTypeId

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
				rda.DimAgeId								AgeId
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
			AND ske.LEA_Identifier_State = el.LEA_Identifier_State
			AND ske.School_Identifier_State = el.School_Identifier_State
			AND rdd.DateValue BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
		JOIN RDS.vwDimK12Demographics rdkd
 			ON rsy.SchoolYear = rdkd.SchoolYear
			AND ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = rdkd.EnglishLearnerStatusMap
			AND rdkd.EconomicDisadvantageStatusCode = 'MISSING'
			AND rdkd.HomelessnessStatusCode = 'MISSING'
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


		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
		
		DROP TABLE #seaOrganizationTypes
		DROP TABLE #leaOrganizationTypes
		DROP TABLE #schoolOrganizationTypes
		DROP TABLE #vwRaces		

	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', NULL, ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

		
END
