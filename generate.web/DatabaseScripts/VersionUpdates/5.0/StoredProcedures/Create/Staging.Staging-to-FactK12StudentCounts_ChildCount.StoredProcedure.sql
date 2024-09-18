/**********************************************************************
Author: AEM Corp
Date:	1/6/2022
Description: Migrates Child Count Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_ChildCount]
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

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

		DECLARE 
		@FactTypeId INT,
		@SchoolYearId int,
		@ChildCountDate date

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

		CREATE CLUSTERED INDEX ix_tempvwIdeaStatuses ON #vwIdeaStatuses (IdeaIndicatorMap, PrimaryDisabilityTypeMap, IdeaEducationalEnvironmentMap);

		SELECT *
		INTO #vwK12Demographics
		FROM RDS.vwDimK12Demographics
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwK12Demographics ON #vwK12Demographics (EnglishLearnerStatusMap, EconomicDisadvantageStatusCode, HomelessnessStatusCode, HomelessPrimaryNighttimeResidenceCode, HomelessUnaccompaniedYouthStatusCode, MigrantStatusCode, MilitaryConnectedStudentIndicatorCode);

		SELECT *
		INTO #vwRaces
		FROM RDS.vwDimRaces
		WHERE SchoolYear = @SchoolYear

		CREATE CLUSTERED INDEX ix_tempvwRaces ON #vwRaces (RaceMap);

		SELECT @FactTypeId = DimFactTypeId 
		FROM rds.DimFactTypes
		WHERE FactTypeCode = 'childcount'

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
		SELECT DISTINCT
			  rda.DimAgeId								AgeId
			, rsy.DimSchoolYearId						SchoolYearId
			, ISNULL(rdkd.DimK12DemographicId, -1)		K12DemographicId
			, @FactTypeId								FactTypeId
			, ISNULL(rgls.DimGradeLevelId, -1)			GradeLevelId
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
		FROM Staging.K12Enrollment ske
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		LEFT JOIN RDS.DimLeas rdl
			ON ske.LEA_Identifier_State = rdl.LeaIdentifierState
			AND @ChildCountDate BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
		LEFT JOIN RDS.DimK12Schools rdksch
			ON ske.School_Identifier_State = rdksch.SchoolIdentifierState
			AND @ChildCountDate BETWEEN rdksch.RecordStartDateTime AND ISNULL(rdksch.RecordEndDateTime, GETDATE())
		JOIN RDS.DimSeas rds
			ON @ChildCountDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())
		JOIN Staging.PersonStatus idea
			ON ske.Student_Identifier_State = idea.Student_Identifier_State
			AND ISNULL(ske.Lea_Identifier_State, '') = ISNULL(idea.Lea_Identifier_State, '')
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(idea.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN idea.IDEA_StatusStartDate AND ISNULL(idea.IDEA_StatusEndDate, GETDATE())
		JOIN Staging.ProgramParticipationSpecialEducation sppse
			ON ske.Student_Identifier_State = sppse.Student_Identifier_State
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(sppse.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(sppse.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN sppse.ProgramParticipationBeginDate AND ISNULL(sppse.ProgramParticipationEndDate, GETDATE())
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
			AND ISNULL(ske.LEA_Identifier_State, '') = ISNULL(el.LEA_Identifier_State, '') 
			AND ISNULL(ske.School_Identifier_State, '') = ISNULL(el.School_Identifier_State, '')
			AND @ChildCountDate BETWEEN el.EnglishLearner_StatusStartDate AND ISNULL(el.EnglishLearner_StatusEndDate, GETDATE())
		JOIN #vwK12Demographics rdkd
 			ON ISNULL(CAST(el.EnglishLearnerStatus AS SMALLINT), -1) = rdkd.EnglishLearnerStatusMap
			AND rdkd.EconomicDisadvantageStatusCode = 'MISSING'
			AND rdkd.HomelessnessStatusCode = 'MISSING'
			AND rdkd.HomelessPrimaryNighttimeResidenceCode = 'MISSING'
			AND rdkd.HomelessUnaccompaniedYouthStatusCode = 'MISSING'
			AND rdkd.MigrantStatusCode = 'MISSING'
			AND rdkd.MilitaryConnectedStudentIndicatorCode = 'MISSING'
		JOIN RDS.DimAges rda
			ON RDS.Get_Age(ske.Birthdate, @ChildCountDate) = rda.AgeValue
		LEFT JOIN #vwGradeLevels rgls
			ON ske.GradeLevel = rgls.GradeLevelMap
			AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'
		LEFT JOIN #vwIdeaStatuses rdis
			ON ISNULL(CAST(idea.IDEAIndicator AS SMALLINT), -1) = rdis.IdeaIndicatorMap
			AND ISNULL(idea.PrimaryDisabilityType, 'MISSING') = ISNULL(rdis.PrimaryDisabilityTypeMap, rdis.PrimaryDisabilityTypeCode)
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
				END = ISNULL(rdis.IdeaEducationalEnvironmentMap, rdis.IdeaEducationalEnvironmentCode)
			AND rdis.SpecialEducationExitReasonCode = 'MISSING'
		LEFT JOIN #vwRaces rdr
			ON ISNULL(rdr.RaceMap, rdr.RaceCode) =
				CASE
					when ske.HispanicLatinoEthnicity = 1 then 'HispanicorLatinoEthnicity'
					WHEN spr.RaceType IS NOT NULL THEN spr.RaceType
					ELSE 'Missing'
				END
		LEFT JOIN RDS.DimDates rdd
			ON sppse.ProgramParticipationEndDate = rdd.DateValue
		JOIN RDS.DimK12Students rdks
			ON ske.Student_Identifier_State = rdks.StateStudentIdentifier
			AND ISNULL(ske.FirstName, '') = ISNULL(rdks.FirstName, '')
			AND ISNULL(ske.MiddleName, '') = ISNULL(rdks.MiddleName, '')
			AND ISNULL(ske.LastName, 'MISSING') = rdks.LastName
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdks.BirthDate, '1/1/1900')
			AND @ChildCountDate BETWEEN rdks.RecordStartDateTime AND ISNULL(rdks.RecordEndDateTime, GETDATE())
		WHERE @ChildCountDate BETWEEN ske.EnrollmentEntryDate AND ISNULL(ske.EnrollmentExitDate, GETDATE())

		ALTER INDEX ALL ON RDS.FactK12StudentCounts REBUILD
		
		DROP TABLE #seaOrganizationTypes
		DROP TABLE #leaOrganizationTypes
		DROP TABLE #schoolOrganizationTypes
		DROP TABLE #vwGradeLevels
		DROP TABLE #vwIdeaStatuses
		DROP TABLE #vwK12Demographics
		DROP TABLE #vwRaces


	END TRY
	BEGIN CATCH
		INSERT INTO Staging.ValidationErrors VALUES ('Staging.Staging-to-FactK12StudentCounts_ChildCount', 'RDS.FactK12StudentCounts', 'FactK12StudentCounts', 'FactK12StudentCounts', ERROR_MESSAGE(), 1, NULL, GETDATE())
	END CATCH

		
END
