

/**********************************************************************
Author: AEM Corp
Date:	08/16/2022
Description: Migrates title III student Count Data from Staging to RDS.FactK12StudentCounts

************************************************************************/
CREATE PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_TitleIII]
	@SchoolYear SMALLINT
AS
BEGIN
	 --SET NOCOUNT ON added to prevent extra result sets from
	 --interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 
	--@SchoolYear SMALLINT,
	@SessionBeginDate Datetime,
	@SessionEndDate Datetime,
	@FactTypeId INT,
	@SchoolYearId int,
	@ProficiencyCheckDate date

--SET @SchoolYear = 2021
	SELECT @SchoolYearId = DimSchoolYearId 
	FROM RDS.DimSchoolYears
	WHERE SchoolYear = @SchoolYear

	SELECT  @SessionBeginDate = SessionBeginDate, @SessionEndDate = SessionEndDate  FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear

	CREATE TABLE #vwTitleIIIStatuses (
		DimTitleIIIStatusId							SMALLINT
		, TitleiiiAccountabilityProgressStatusCode	NVARCHAR(100)
		, TitleiiiAccountabilityProgressStatusMap  	NVARCHAR(100)				
	)

	INSERT INTO #vwTitleIIIStatuses 
	SELECT DimTitleIIIStatusId
		, TitleiiiAccountabilityProgressStatusCode
		, TitleiiiAccountabilityProgressStatusMap
	FROM RDS.vwDimTitleIIIStatuses
	WHERE SchoolYear = @SchoolYear
	AND ProficiencyStatusCode = 'MISSING'
	AND TitleiiiLanguageInstructionProgramTypeCode = 'MISSING'
	AND TitleiiiAccountabilityProgressStatusCode <> 'MISSING'
	
	
	CREATE TABLE #organizationTypes (
		SchoolYear								SMALLINT
		, LeaOrganizationType					VARCHAR(20)
		, K12SchoolOrganizationType				VARCHAR(20)
	)

	INSERT INTO #organizationTypes
	SELECT 
		lea.SchoolYear
		, lea.InputCode
		, sch.InputCode
	FROM (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationType' AND TableFilter = '001156' AND OutputCode = 'LEA') lea
	JOIN (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationType' AND TableFilter = '001156' AND OutputCode = 'K12School') sch
		ON lea.SchoolYear = sch.SchoolYear

	SELECT @FactTypeId = DimFactTypeId 
	FROM rds.DimFactTypes
	WHERE FactTypeCode = 'titleIIIELSY'

	DELETE RDS.FactK12StudentCounts
	WHERE SchoolYearId = @SchoolYearId 
		AND FactTypeId = @FactTypeId

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
        , [K12Student_CurrentId]
        , [StudentCount]
        , [LanguageId]
        , [MigrantId]
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
	    -1											AgeId
		, rsy.DimSchoolYearId						SchoolYearId
		, -1									    K12DemographicId
		, @FactTypeId								FactTypeId
		, -1										GradeLevelId
		, -1										IdeaStatusId	
		, -1										ProgramStatusId
		, ISNULL(rdksch.DimK12SchoolId, -1)			K12SchoolId
		, -1										K12StudentId
		, rdpc.DimPersonId							K12Student_CurrentId
		, 1											StudentCount
		, -1										LanguageId
		, -1										MigrantId
		, -1										TitleIStatusId
		, title3Statuses.DimTitleIIIStatusId        TitleIIIStatusId
	    , ISNULL(rdl.DimLeaID, -1)					LEAId
		, -1										AttendanceId
		, -1										CohortStatusId
		, -1										NorDProgramStatusId
		, NULL										StudentCutoverStartDate		
		, -1								     	RaceId
		, -1										CTEStatusId
		, -1										K12EnrollmentStatusId
		, ISNULL(rds.DimSeaId, -1)					SEAId
		, -1										IEUId
		, -1					                    SpecialEducationServicesExitDateId
	FROM Staging.K12Enrollment ske
		JOIN RDS.DimSchoolYears rsy
			ON ske.SchoolYear = rsy.SchoolYear
		JOIN #organizationTypes orgTypes
			ON ske.SchoolYear = orgTypes.SchoolYear
		JOIN Staging.ProgramParticipationTitleIII ppt3
			ON ske.SchoolYear = ppt3.SchoolYear		
			AND ske.Student_Identifier_State = ppt3.Student_Identifier_State	
			--AND ppt3.ProgramParticipationBeginDate BETWEEN @SessionBeginDate AND ISNULL(@SessionEndDate, GETDATE())  
		JOIN #vwTitleIIIStatuses  title3Statuses
			ON RTRIM(LTRIM(ppt3.Progress_TitleIII)) = RTRIM(LTRIM(title3Statuses.TitleiiiAccountabilityProgressStatusCode))
		JOIN RDS.DimLeas rdl
			ON ske.LEA_Identifier_State = rdl.LeaIdentifierState	
		JOIN RDS.DimK12Schools rdksch
			ON ske.School_Identifier_State = rdksch.SchoolIdentifierState	
		JOIN RDS.DimSeas rds
			ON @SessionBeginDate BETWEEN rds.RecordStartDateTime AND ISNULL(rds.RecordEndDateTime, GETDATE())	
		JOIN Staging.PersonRace spr
			ON ske.SchoolYear = spr.SchoolYear
			AND ske.Student_Identifier_State = spr.Student_Identifier_State
			
		--      JOIN RDS.DimAges rda
		--	      ON RDS.Get_Age(ske.Birthdate, @SessionBeginDate) = rda.AgeValue
		--					LEFT JOIN RDS.vwDimGradeLevels rgls
		--						ON ske.SchoolYear = rgls.SchoolYear
		--						AND ske.GradeLevel = rgls.GradeLevelMap
		--						AND rgls.GradeLevelTypeDescription = 'Entry Grade Level'	
		--LEFT JOIN RDS.vwDimRaces rdr    
		--	ON ske.SchoolYear = rdr.SchoolYear
		--	AND rdr.RaceMap =
		--		CASE
		--			WHEN spr.RaceType IS NOT NULL THEN spr.RaceType
		--			when spr.RaceType IS NULL AND ske.HispanicLatinoEthnicity = 1 then 'HispaniceorLatinoEthnicity'
		--			when spr.RaceType IS NULL AND ske.HispanicLatinoEthnicity is null then 'Missing'
		--		END
		LEFT JOIN RDS.DimPeople_Current rdpc
			ON ske.Student_Identifier_State = rdpc.K12StudentStudentIdentifierState
			AND ISNULL(ske.Birthdate, '1/1/1900') = ISNULL(rdpc.BirthDate, '1/1/1900')
	WHERE 
		(ppt3.ProgramParticipationBeginDate < @SessionEndDate) and (ppt3.ProgramParticipationEndDate > @SessionBeginDate) 
		OR 
		(ppt3.ProgramParticipationBeginDate < @SessionEndDate)

DROP TABLE #organizationTypes
DROP TABLE #vwTitleIIIStatuses

END