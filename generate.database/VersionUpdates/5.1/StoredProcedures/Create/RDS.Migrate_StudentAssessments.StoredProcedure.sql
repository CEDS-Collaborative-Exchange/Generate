CREATE PROCEDURE [RDS].[Migrate_StudentAssessments]
	@factTypeCode AS VARCHAR(50),
	@runAsTest AS BIT,
	@dataCollectionName AS VARCHAR(50) = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

	-- Lookup VALUES
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactK12StudentAssessments'
	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DataMigrationTypeId
	FROM app.DataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	DECLARE @studentDateQuery AS rds.K12StudentDateTableType

	IF Object_id('TempDB..#raceQuery') IS NOT NULL BEGIN DROP TABLE #raceQuery END 
	IF Object_id('TempDB..#demoQuery') IS NOT NULL BEGIN DROP TABLE #demoQuery END 
	IF Object_id('TempDB..#ideaQuery') IS NOT NULL BEGIN DROP TABLE #ideaQuery END 
	IF Object_id('TempDB..#programStatusQuery') IS NOT NULL BEGIN DROP TABLE #programStatusQuery END 
	IF Object_id('TempDB..#assessmentQuery') IS NOT NULL BEGIN DROP TABLE #assessmentQuery END 
	IF Object_id('TempDB..#titleIIIStatusQuery') IS NOT NULL BEGIN DROP TABLE #titleIIIStatusQuery END 
	IF Object_id('TempDB..#AssessmentStatusQuery') IS NOT NULL BEGIN DROP TABLE #AssessmentStatusQuery END 
	IF Object_id('TempDB..#studentStatusQuery') IS NOT NULL BEGIN DROP TABLE #studentStatusQuery END 
	IF Object_id('TempDB..#title1StatusQuery') IS NOT NULL BEGIN DROP TABLE #title1StatusQuery END 
	IF Object_id('TempDB..#NoDProgramStatus') IS NOT NULL BEGIN DROP TABLE #NoDProgramStatus END 
	IF Object_id('TempDB..#cteStatusQuery') IS NOT NULL BEGIN DROP TABLE #cteStatusQuery END 
	IF Object_id('TempDB..#enrollmentStatusQuery') IS NOT NULL BEGIN DROP TABLE #enrollmentStatusQuery END 
	
	CREATE TABLE #raceQuery (
		DimK12StudentId INT,
		DimPersonId INT,
		DimCountDateId INT,
		DimLeaId INT,
		DimK12SchoolId INT,
		DimRaceId INT,
		RaceCode VARCHAR(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate datetime
	)

	CREATE TABLE #demoQuery (
		  DimK12StudentId							INT
		, DimIeuId									INT
		, DimLeaId									INT
		, DimK12SchoolId							INT
		, DimDateId									INT
		, EcoDisStatusCode							NVARCHAR(50)
		, HomelessStatusCode						NVARCHAR(50)
		, HomelessUnaccompaniedYouthStatusCode		NVARCHAR(50)
		, LepStatusCode								NVARCHAR(50)
		, MigrantStatusCode							NVARCHAR(50)
		, MilitaryConnected							NVARCHAR(50)
		, HomelessNighttimeResidenceCode			NVARCHAR(50)
		, PersonStartDate							DATETIME
		, PersonEndDate								DATETIME
		, DimK12DemographicId						INT
	)
	CREATE NONCLUSTERED INDEX IX_Demo ON #demoQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)

	CREATE TABLE #ideaQuery (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		DimIeuId INT,
		PersonId INT,
		DimCountDateId INT,
		IDEAIndicatorCode varchar(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		BasisOfExitCode VARCHAR(50),
		SpecialEducationServicesExitDate Date,
		RecordStartDateTime DATETIME,
		RecordEndDateTime DATETIME NULL,
		DimIdeaStatusId INT,
		SpecialEducationServicesExitDateId INT
	)
	CREATE NONCLUSTERED INDEX IX_ideaQuery ON #ideaQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)


	CREATE TABLE #programStatusQuery  (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,
		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIProgramParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_programStatusQuery ON #programStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)


	CREATE TABLE #assessmentQuery (
		DimK12StudentId INT,
		PersonId INT,
		DimLeaId INT,
		DimK12SchoolId INT,
		DimSeaId int,
		DimCountDateId INT,
		AssessmentSubjectCode VARCHAR(50),
		AssessmentTypeCode VARCHAR(50),
		GradeLevelCode VARCHAR(50),
		ParticipationStatusCode VARCHAR(50),
		PerformanceLevelCode VARCHAR(50),
		SeaFullYearStatusCode VARCHAR(50),
		LeaFullYearStatusCode VARCHAR(50),
		SchFullYearStatusCode VARCHAR(50),
		AssessmentTypeAdministeredToEnglishLearnersCode VARCHAR(50),
		AssessmentStartDate DATE,
		AssessmentFinishDate DATE,
		AssessmentCount INT
	)
	CREATE NONCLUSTERED INDEX IX_assessmentQuery ON #assessmentQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)
		
	DECLARE @schoolQuery AS RDS.K12StudentOrganizationTableType
	
	CREATE TABLE #titleIIIStatusQuery  (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,
		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_titleIIIStatusQuery ON #titleIIIStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)
	
	CREATE TABLE #AssessmentStatusQuery (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,		
		AssessedFirstTime VARCHAR(50),
		AcademicSubjectCode VARCHAR(50),
		ProgressLevelCode VARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_AssessmentStatusQuery ON #AssessmentStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)
	
	CREATE TABLE #studentStatusQuery (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,
		MobilityStatus12moCode VARCHAR(50),
		MobilityStatus36moCode VARCHAR(50),
		MobilityStatusSYCode VARCHAR(50),
		ReferralStatusCode VARCHAR(50),
		DiplomaCredentialCode VARCHAR(50),
		PlacementType VARCHAR(50),
		PlacementStatus VARCHAR(50),
		NSLPDirectCertificationIndicatorCode varchar(50)
	)
	CREATE NONCLUSTERED INDEX IX_studentStatusQuery ON #studentStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	CREATE TABLE #title1StatusQuery  (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		TitleISchoolStatusCode VARCHAR(50),
		TitleIinstructionalServiceCode VARCHAR(50),		
		Title1SupportServiceCode VARCHAR(50),
		Title1ProgramTypeCode VARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_title1StatusQuery ON #title1StatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	CREATE TABLE #NoDProgramStatus  (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT, 
		DimCountDateId INT,
		LongTermStatusCode VARCHAR(10), 
		NeglectedProgramTypeCode VARCHAR(30)
	)
	CREATE NONCLUSTERED INDEX IX_NoDProgramStatus ON #NoDProgramStatus (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	CREATE TABLE #cteStatusQuery  (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		CteCode VARCHAR(50),
		DisplacedHomemaker VARCHAR(50),
		SingleParent VARCHAR(50),
		CteNonTraditionalEnrollee VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		InclutypCode VARCHAR(50),
		LepPerkinsStatus VARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_Cte ON #cteStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	CREATE TABLE #enrollmentStatusQuery (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		DimK12EnrollmentStatusId INT,
		ExitCode VARCHAR(50),
		EnrollmentStatusCode VARCHAR(50),
		EntryTypeCode VARCHAR(50),
		PostSecondaryEnrollmentStatusCode VARCHAR(50),
		AcademicOrVocationalOutcomeCode VARCHAR(50),
		AcademicOrVocationalExitOutcomeCode VARCHAR(50)
	 )
	 CREATE NONCLUSTERED INDEX IX_EnrollmentStatus ON #enrollmentStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	create table #queryOutput (
		QueryOutputId INT IDENTITY(1,1) NOT NULL,
		DimK12StudentId INT,
		DimCountDateId INT,
		DimSchoolYearId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		RaceCode VARCHAR(50),
		EcoDisStatusCode VARCHAR(50),
		HomelessStatusCode VARCHAR(50),
		LepStatusCode VARCHAR(50),
		MigrantStatusCode VARCHAR(50),
		SexCode VARCHAR(50),
		MilitaryConnected VARCHAR(50),
		HomelessUnaccompaniedYouthStatusCode VARCHAR(50),
		HomelessNighttimeResidenceCode VARCHAR(50),
		IDEAIndicatorCode VARCHAR(50),
		BasisOfExitCode VARCHAR(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		--TitleIStatusCode VARCHAR(50),
		CteCode VARCHAR(50),
		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIProgramParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50),
		AssessmentSubjectCode VARCHAR(50),
		AssessmentTypeCode VARCHAR(50),
		GradeLevelCode VARCHAR(50),
		ParticipationStatusCode VARCHAR(50),
		PerformanceLevelCode VARCHAR(50),
		SeaFullYearStatusCode VARCHAR(50),
		LeaFullYearStatusCode VARCHAR(50),
		SchFullYearStatusCode VARCHAR(50),
		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50),
		AssessedFirstTime VARCHAR(50),
		AcademicAssessmentSubjectCode VARCHAR(50),
		ProgressLevel VARCHAR(50),
		MobilityStatus12moCode VARCHAR(50),
		MobilityStatus36moCode VARCHAR(50),
		MobilityStatusSYCode VARCHAR(50),
		ReferralStatusCode VARCHAR(50),
		DiplomaCredentialCode VARCHAR(50),
		DisplacedHomemaker VARCHAR(50),
		SingleParent VARCHAR(50),
		CteNonTraditionalEnrollee VARCHAR(50),
		PlacementType VARCHAR(50),
		PlacementStatus VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		INCLUTYPCode VARCHAR(50),
		LepPerkinsStatus VARCHAR(50),
		LongTermStatusCode NVARCHAR(50),
		NeglectedProgramTypeCode NVARCHAR(50),
		AcademicOrVocationalOutcomeCode VARCHAR(50),
		AcademicOrVocationalExitOutcomeCode VARCHAR(50),
		NSLPDirectCertificationIndicatorCode VARCHAR(50),
		TitleISchoolStatusCode VARCHAR(50),
		TitleIinstructionalServiceCode VARCHAR(50),		
		Title1SupportServiceCode VARCHAR(50),
		Title1ProgramTypeCode VARCHAR(50),
		ExitCode VARCHAR(50),
		EnrollmentStatusCode VARCHAR(50),
		PostSecondaryEnrollmentStatusCode VARCHAR(50),
		EntryTypeCode VARCHAR(50),
		AssessmentTypeAdministeredToEnglishLearnersCode VARCHAR(50),
		AssessmentCount INT
	)

	
	
	-- Log history
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	END


	-- Get Dimension Data
	----------------------------

	BEGIN TRY
	
	DECLARE @selectedDate AS INT, @submissionYear AS VARCHAR(50)
	DECLARE selectedYears_cursor CURSOR FOR 
	SELECT d.DimSchoolYearId, d.SchoolYear
		FROM rds.DimSchoolYears d
		JOIN rds.DimSchoolYearDataMigrationTypes dd ON dd.DimSchoolYearId = d.DimSchoolYearId
		JOIN app.DataMigrationTypes b ON b.DataMigrationTypeId=dd.DataMigrationTypeId 
		WHERE d.DimSchoolYearId <> -1 
		AND dd.IsSelected=1 AND DataMigrationTypeCode=@migrationType

	OPEN selectedYears_cursor
	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @submissionYear)
	END

	

	DELETE FROM #queryOutput
	DELETE FROM @studentDateQuery
	DELETE FROM #raceQuery
	DELETE FROM #demoQuery
	DELETE FROM @schoolQuery
	DELETE FROM #assessmentQuery
	DELETE FROM #AssessmentStatusQuery
	DELETE FROM #ideaQuery
	DELETE FROM #programStatusQuery
	DELETE FROM #studentStatusQuery
	DELETE FROM #titleIIIStatusQuery
	DELETE FROM #NoDProgramStatus
	DELETE FROM #cteStatusQuery
	DELETE from #enrollmentStatusQuery

	INSERT INTO @studentDateQuery
	(
		DimK12StudentId,
		PersonId,
		DimSchoolYearId,
		DimCountDateId,
		CountDate,
		SchoolYear,
		SessionBeginDate,
		SessionEndDate,
		RecordStartDateTime,
		RecordEndDateTime
	)
	exec rds.Migrate_DimSchoolYears_K12Students @factTypeCode, @migrationType, @selectedDate, 1

	IF @runAsTest = 1
	BEGIN
		print 'studentDateQuery'
		SELECT * FROM @studentDateQuery
	END

	-- Migrate_DimK12Schools

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END
	INSERT INTO @schoolQuery
	(
		  DimK12StudentId
		, PersonId
		, DimCountDateId
		, DimSeaId 
		, DimIeuId 
		, DimLeaID
		, DimK12SchoolId
		, IeuOrganizationId
		, LeaOrganizationId
		, K12SchoolOrganizationId
		, LeaOrganizationPersonRoleId 
		, K12SchoolOrganizationPersonRoleId 
		, LeaEntryDate
		, LeaExitDate 
		, K12SchoolEntryDate	
		, K12SchoolExitDate 
	)
	EXEC rds.Migrate_K12StudentOrganizations @studentDateQuery, @dataCollectionId, 0



	IF @runAsTest = 1
	BEGIN
		print 'schoolQuery'
		SELECT * FROM @schoolQuery
	END
	

	-- Migrate_DimK12Races

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Race Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END

	INSERT INTO #raceQuery
	(
		DimK12StudentId,
		DimPersonId,
		DimCountDateId,
		DimLeaId,
		DimK12SchoolId,
		DimRaceId,
		RaceCode,
		RaceRecordStartDate,
		RaceRecordEndDate
	)
	exec rds.Migrate_DimK12Races  @factTypeCode, @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'raceQuery'
		SELECT * FROM #raceQuery
	END


	-- Migrate_DimK12Demographics

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Demographics Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END

		INSERT INTO #demoQuery
		(
			  DimK12StudentId							
			, DimIeuId									
			, DimLeaId									
			, DimK12SchoolId							
			, DimDateId									
			, EcoDisStatusCode							
			, HomelessStatusCode						
			, HomelessUnaccompaniedYouthStatusCode		
			, LepStatusCode								
			, MigrantStatusCode							
			, MilitaryConnected							
			, HomelessNighttimeResidenceCode			
			, PersonStartDate							
			, PersonEndDate								
			, DimK12DemographicId						
		)
		exec rds.Migrate_DimK12Demographics @studentDateQuery, @schoolQuery, 0, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'demoQuery'
		SELECT * FROM #demoQuery
	END


	-- Migrate_DimIdeaStatuses
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating IDEA Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #ideaQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		DimIeuId,
		PersonId,
		DimCountDateId,
		IdeaIndicatorCode,
		DisabilityCode,
		EducEnvCode,
		BasisOfExitCode,
		SpecialEducationServicesExitDate,
		RecordStartDateTime,
		RecordEndDateTime,
		DimIdeaStatusId,
		SpecialEducationServicesExitDateId
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, 0, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'ideaQuery'
		SELECT * FROM #ideaQuery
	END


	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Program Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #programStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode
	)
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'programStatusQuery'
		SELECT * FROM #programStatusQuery
	END


	-- Migrate_DimAssessments

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Assessment Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #assessmentQuery
	(
		DimK12StudentId,
		PersonId,
		DimLeaId,
		DimK12SchoolId,
		DimSeaId,
		DimCountDateId,
		AssessmentSubjectCode,
		AssessmentTypeCode,
		GradeLevelCode,
		ParticipationStatusCode,
		PerformanceLevelCode,
		SeaFullYearStatusCode,
		LeaFullYearStatusCode,
		SchFullYearStatusCode,
		AssessmentTypeAdministeredToEnglishLearnersCode,
		AssessmentStartDate,
		AssessmentFinishDate,
		AssessmentCount
	)
	exec rds.Migrate_DimAssessments @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'assessmentQuery'
		SELECT * FROM #assessmentQuery
	END


	
	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title I Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	insert into #title1StatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode
	)
	exec rds.[Migrate_DimTitleIStatuses] @studentDateQuery, @schoolQuery, @dataCollectionId

	if @runAsTest = 1
	BEGIN
		print 'title1StatusQuery'
		select * from #title1StatusQuery
	END


	-- Migrate Title III Statuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title III Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #titleIIIStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus
	)
	exec rds.[Migrate_DimTitleIIIStatuses] @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'titleIIIStatusQuery'
		SELECT * FROM #titleIIIStatusQuery
	END


	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Assessment Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #AssessmentStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,		
		AssessedFirstTime,
		AcademicSubjectCode,
		ProgressLevelCode 
	)
	exec [RDS].[Migrate_DimAssessmentStatuses] @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'AssessmentStatusQuery'
		SELECT * FROM #AssessmentStatusQuery
	END


	-- Migrate_DimK12Studentstatuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Student Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #studentStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		MobilityStatus12moCode,
		MobilityStatus36moCode,
		MobilityStatusSYCode,
		ReferralStatusCode,
		DiplomaCredentialCode,
		PlacementType,
		PlacementStatus,
		NSLPDirectCertificationIndicatorCode
	)
	exec rds.[Migrate_DimK12Studentstatuses] @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'studentStatusQuery'
		SELECT * FROM #studentStatusQuery
	END

	-- migrate N OR D Statuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating N OR D Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #NoDProgramStatus
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		LongTermStatusCode,
		NeglectedProgramTypeCode
	)
	exec RDS.Migrate_DimNoDProgramStatuses @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'NoDProgramStatus'
		SELECT * FROM #NoDProgramStatus
	END


	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Cte Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO #cteStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		CteCode,
		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatus
	)
	exec RDS.Migrate_DimCteStatuses @studentDateQuery, @schoolQuery, @dataCollectionId

	
	IF @runAsTest = 1
	BEGIN
		print 'cteStatusQuery'
		select * from #cteStatusQuery
	END

	if @runAsTest = 0
	BEGIN
		insert into app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	insert into #enrollmentStatusQuery
	(
		DimK12StudentId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		PersonId,
		DimCountDateId,
		ExitCode,
		EnrollmentStatusCode,
		PostSecondaryEnrollmentStatusCode,
		EntryTypeCode,
		DimK12EnrollmentStatusId,
		AcademicOrVocationalOutcomeCode,
		AcademicOrVocationalExitOutcomeCode
	)
	exec RDS.Migrate_DimK12EnrollmentStatuses @studentDateQuery, @schoolQuery, @dataCollectionId

	if @runAsTest = 1
	BEGIN
		print 'enrollmentStatusQuery'
		select * from #enrollmentStatusQuery
	END


	-- Combine Dimension Data
	----------------------------
	-- Log history
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combining Dimension Data for (' + @factTypeCode + ') -  ' + @submissionYear)
	END

	INSERT INTO #queryOutput
	(
		DimK12StudentId,
		DimCountDateId,
		DimSchoolYearId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		RaceCode,
		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected ,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,
		IDEAIndicatorCode,
		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,
		AssessmentSubjectCode,
		AssessmentTypeCode,
		GradeLevelCode,
		ParticipationStatusCode,
		PerformanceLevelCode,
		SeaFullYearStatusCode,
		LeaFullYearStatusCode,
		SchFullYearStatusCode,
		AssessmentTypeAdministeredToEnglishLearnersCode,
		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,
		AssessedFirstTime,
		AcademicAssessmentSubjectCode,
		ProgressLevel,
		MobilityStatus12moCode,
		MobilityStatus36moCode,
		MobilityStatusSYCode,
		ReferralStatusCode,
		DiplomaCredentialCode,
		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		PlacementType,
		PlacementStatus,
		NSLPDirectCertificationIndicatorCode,
		RepresentationStatus,
		INCLUTYPCode,
		LepPerkinsStatus,
		LongTermStatusCode,
		NeglectedProgramTypeCode,
		AcademicOrVocationalOutcomeCode,
		AcademicOrVocationalExitOutcomeCode,
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,
		ExitCode,	
		EnrollmentStatusCode,
		PostSecondaryEnrollmentStatusCode,
		EntryTypeCode,
		AssessmentCount
	)
	SELECT 
		s.DimK12StudentId,
		s.DimCountDateId,
		s.DimSchoolYearId,
		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId, -1),
		ISNULL(sch.DimSeaId, -1),
		ISNULL(race.RaceCode,'MISSING'),
		ISNULL(demo.EcoDisStatusCode, 'MISSING'),
		ISNULL(demo.HomelessStatusCode, 'MISSING'),
--		ISNULL(demo.LepStatusCode, 'MISSING'),
		ISNULL(demo.LepStatusCode, 'NLEP'),
		ISNULL(demo.MigrantStatusCode, 'MISSING'),
		ISNULL(st.SexCode, 'MISSING'),
		ISNULL(demo.MilitaryConnected ,'MISSING'),
		ISNULL(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		ISNULL(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		ISNULL(idea.IDEAIndicatorCode, 'MISSING'),
		ISNULL(idea.BasisOfExitCode, 'MISSING'),
		ISNULL(idea.DisabilityCode, 'MISSING'),
		ISNULL(idea.EducEnvCode, 'MISSING'),
		--ISNULL(idea.TitleIStatusCode, 'MISSING'),
		ISNULL(cteStatus.CteCode,'MISSING'),
		ISNULL(programStatus.ImmigrantTitleIIICode,'MISSING'),
		ISNULL(programStatus.Section504Code,'MISSING'),
		ISNULL(programStatus.FoodServiceEligibilityCode,'MISSING'),
		ISNULL(programStatus.FosterCareCode,'MISSING'),
		ISNULL(programStatus.TitleIIIProgramParticipation,'MISSING'),
		ISNULL(programStatus.HomelessServicedIndicatorCode,'MISSING'),

		ISNULL(assess.AssessmentSubjectCode, 'MISSING'),
		ISNULL(assess.AssessmentTypeCode, 'MISSING'),
		ISNULL(assess.GradeLevelCode, 'MISSING'),
		ISNULL(assess.ParticipationStatusCode, 'MISSING'),
		ISNULL(assess.PerformanceLevelCode, 'MISSING'),
		ISNULL(assess.SeaFullYearStatusCode, 'MISSING'),
		ISNULL(assess.LeaFullYearStatusCode, 'MISSING'),
		ISNULL(assess.SchFullYearStatusCode, 'MISSING'),
		ISNULL(assess.AssessmentTypeAdministeredToEnglishLearnersCode, 'MISSING'),

		ISNULL(titleIII.TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(titleIII.TitleIIILanguageInstructionCode , 'MISSING'),	
		ISNULL(titleIII.ProficiencyStatusCode , 'MISSING'),
		ISNULL(titleIII.FormerEnglishLearnerYearStatus, 'MISSING'),
		ISNULL(asq.AssessedFirstTime , 'MISSING'),
		ISNULL(asq.AcademicSubjectCode , 'MISSING'),
		ISNULL(asq.ProgresslevelCode , 'MISSING'),
		ISNULL(studentStatus.MobilityStatus12moCode, 'MISSING'),
		ISNULL(studentStatus.MobilityStatus36moCode, 'MISSING'),
		ISNULL(studentStatus.MobilityStatusSYCode, 'MISSING'),
		ISNULL(studentStatus.ReferralStatusCode, 'MISSING'),
		ISNULL(studentStatus.DiplomaCredentialCode, 'MISSING'),
		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(studentStatus.PlacementType, 'MISSING'),
		ISNULL(studentStatus.PlacementStatus, 'MISSING'),
		ISNULL(studentStatus.NSLPDirectCertificationIndicatorCode, 'MISSING'),			
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING'),

		ISNULL(noDProgramStatus.LongTermStatusCode , 'MISSING'),
		ISNULL(noDProgramStatus.NeglectedProgramTypeCode, 'MISSING'),
		ISNULL(enrollmentStatus.AcademicOrVocationalOutcomeCode,'MISSING'),
		ISNULL(enrollmentStatus.AcademicOrVocationalExitOutcomeCode,'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),
		ISNULL(enrollmentStatus.ExitCode, 'MISSING'),
		ISNULL(enrollmentStatus.EnrollmentStatusCode, 'MISSING'),
		ISNULL(enrollmentStatus.PostSecondaryEnrollmentStatusCode, 'MISSING'),
		ISNULL(enrollmentStatus.EntryTypeCode, 'MISSING'),
		
		ISNULL(assess.AssessmentCount, 0)
	from @studentDateQuery s
	inner join #demoQuery demo 
		on s.DimK12StudentId = demo.DimK12StudentId 
		and s.DimCountDateId = demo.DimDateId
	inner join #assessmentQuery assess 
		on s.DimK12StudentId = assess.DimK12StudentId 
		and s.DimCountDateId = assess.DimCountDateId
		AND assess.AssessmentStartDate BETWEEN demo.PersonStartDate AND ISNULL(PersonEndDate,GETDATE())
	left join rds.DimK12Students st 
		on s.DimK12StudentId = st.DimK12StudentId
	left outer join @schoolQuery sch 
		on s.DimK12StudentId = sch.DimK12StudentId 
		and s.DimCountDateId = sch.DimCountDateId 
	left outer join #raceQuery race 
		on s.DimK12StudentId = race.DimK12StudentId 
		and s.PersonId = race.DimPersonId
		and s.DimCountDateId = race.DimCountDateId
	left outer join #ideaQuery idea 
		on s.DimK12StudentId = idea.DimK12StudentId 
		and s.DimCountDateId = idea.DimCountDateId 
		and sch.DimK12SchoolId = idea.DimK12SchoolId 
		and sch.DimLeaId = idea.DimLeaId 
		and sch.DimSeaId = idea.DimSeaId
	left outer join #programStatusQuery programStatus 
		on s.DimK12StudentId = programStatus.DimK12StudentId 
		and s.DimCountDateId = programStatus.DimCountDateId 
		and sch.DimK12SchoolId = programStatus.DimK12SchoolId 
		and sch.DimLeaId = programStatus.DimLeaId
		and sch.DimSeaId = programStatus.DimSeaId
	left outer join #titleIIIStatusQuery titleIII  
		on s.DimK12StudentId = titleIII.DimK12StudentId 
		and s.DimCountDateId = titleIII.DimCountDateId 
		and sch.DimK12SchoolId = titleIII.DimK12SchoolId 
		and sch.DimLeaId = titleIII.DimLeaId
		and sch.DimSeaId = titleIII.DimSeaId
	left outer join #AssessmentStatusQuery asq 
		on  s.DimK12StudentId = asq.DimK12StudentId 
		and s.DimCountDateId = asq.DimCountDateId 
		and sch.DimK12SchoolId = asq.DimK12SchoolId 
		and sch.DimLeaId = asq.DimLeaId
		and sch.DimSeaId = asq.DimSeaId
	left outer join #studentStatusQuery studentStatus 
		on s.DimK12StudentId = studentStatus.DimK12StudentId 
		and s.DimCountDateId = studentStatus.DimCountDateId 
		and sch.DimK12SchoolId = studentStatus.DimK12SchoolId 
		and sch.DimLeaId = studentStatus.DimLeaId
		and sch.DimSeaId = studentStatus.DimSeaId
	left join #NoDProgramStatus noDProgramStatus  
		on s.DimK12StudentId = noDProgramStatus.DimK12StudentId 
		and s.DimCountDateId = noDProgramStatus.DimCountDateId 
		and sch.DimK12SchoolId = noDProgramStatus.DimK12SchoolId 
		and sch.DimLeaId = noDProgramStatus.DimLeaId
		and sch.DimSeaId = noDProgramStatus.DimSeaId
	left outer join #cteStatusQuery cteStatus  
		on s.DimK12StudentId = cteStatus.DimK12StudentId 
		and s.DimCountDateId = cteStatus.DimCountDateId 
		and sch.DimK12SchoolId = cteStatus.DimK12SchoolId 
		and sch.DimLeaId = cteStatus.DimLeaId
		and sch.DimSeaId = cteStatus.DimSeaId
	left outer join #title1StatusQuery title1  
		on s.DimK12StudentId = title1.DimK12StudentId 
		and s.DimCountDateId = title1.DimCountDateId 
		and sch.DimK12SchoolId = title1.DimK12SchoolId 
		and sch.DimLeaId = title1.DimLeaId
		and sch.DimSeaId = title1.DimSeaId
	left outer join #enrollmentStatusQuery enrollmentStatus  
		on s.DimK12StudentId = enrollmentStatus.DimK12StudentId 
		and s.DimCountDateId = enrollmentStatus.DimCountDateId 
		and sch.DimK12SchoolId = enrollmentStatus.DimK12SchoolId 
		and sch.DimLeaId = enrollmentStatus.DimLeaId
		and sch.DimSeaId = enrollmentStatus.DimSeaId
	
	IF @runAsTest = 1
	BEGIN
		print 'queryOutput'
		SELECT * FROM #queryOutput
	END


	-- INSERT New Facts
	----------------------------
	-- Log history
	
	IF @runAsTest = 0
	BEGIN
		
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

		INSERT INTO rds.FactK12StudentAssessments
		(
			FactTypeId,
			K12StudentId,
			K12SchoolId,
			LeaId,
			SeaId,
			SchoolYearId,
			K12DemographicId,
			IdeaStatusId,
			AssessmentId,
			GradeLevelId,
			ProgramStatusId,
			TitleIStatusId,
			TitleIIIStatusId,
			AssessmentStatusId,
			K12StudentStatusId,
			NorDProgramStatusId,
			CteStatusId,
			RaceId,
			EnrollmentStatusId,
			AssessmentCount
		)
		SELECT
			@factTypeId AS DimFactTypeId,
			q.DimK12StudentId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(d.DimK12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(assess.DimAssessmentId, -1) AS DimAssessmentId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			isnull(title1.DimTitleIStatusId, -1) as DimTitle1StatusId,
			ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId,
			ISNULL(assesSts.DimAssessmentStatusId, -1) AS DimAssessmentStatusId,
			ISNULL(studentStatus.DimK12StudentstatusId, -1) AS DimK12StudentstatusId,
			ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1) AS DimNorDProgramStatusId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
			ISNULL(race.DimRaceId,-1) AS DimRaceId,
			isnull(enrStatus.DimK12EnrollmentStatusId, -1) as DimEnrollmentStatusId,
			count(DISTINCT q.DimK12StudentId) AS AssessmentCount
		FROM #queryOutput q
		JOIN rds.DimAssessments assess
			ON q.AssessmentSubjectCode = assess.AssessmentSubjectCode
			AND q.AssessmentTypeCode = assess.AssessmentTypeCode
			AND q.ParticipationStatusCode = assess.ParticipationStatusCode
			AND q.PerformanceLevelCode = assess.PerformanceLevelCode
			AND q.SeaFullYearStatusCode = assess.SeaFullYearStatusCode
			AND q.LeaFullYearStatusCode = assess.LeaFullYearStatusCode
			AND q.SchFullYearStatusCode = assess.SchFullYearStatusCode
		JOIN rds.DimGradeLevels grade
			ON q.GradeLevelCode = grade.GradeLevelCode
		JOIN rds.DimRaces race
			ON q.RaceCode = race.RaceCode
		LEFT JOIN rds.DimK12Demographics d 
			ON q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			AND q.HomelessStatusCode = d.HomelessnessStatusCode
			AND q.LepStatusCode = d.EnglishLearnerStatusCode
			AND q.MigrantStatusCode = d.MigrantStatusCode
			AND q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			AND q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
			AND q.MilitaryConnected = CASE d.MilitaryConnectedStudentIndicatorCode
										WHEN 'ActiveDuty' THEN 'MILCNCTD'
										WHEN 'NationalGuardOrReserve' THEN 'MILCNCTD'
										WHEN 'NotMilitaryConnected' THEN 'NOTMILCNCTD'
										ELSE 'MISSING'
									END	
		LEFT JOIN rds.DimIdeaStatuses idea
			ON q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
			AND q.DisabilityCode = idea.PrimaryDisabilityTypeCode
			AND q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
			AND q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimTitleiiiStatuses title3	
			ON title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
			AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
			AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
			AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		LEFT JOIN rds.DimAssessmentStatuses assesSts 
			ON assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
			AND assesSts.AssessmentProgressLevelCode = q.ProgressLevel 
			AND q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode
		LEFT JOIN rds.DimNorDProgramStatuses NorDProgramStatuses
			ON NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
			AND NorDProgramStatuses.NeglectedOrDelinquentProgramTypeCode = q.NeglectedProgramTypeCode
		LEFT JOIN rds.DimK12Studentstatuses studentStatus
			ON studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
			AND studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
			AND studentStatus.ReferralStatusCode = q.ReferralStatusCode
			AND studentStatus.HighSchoolDiplomaTypeCode = q.DiplomaCredentialCode
			AND studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
			AND studentStatus.PlacementStatusCode = q.PlacementStatus
			AND studentStatus.PlacementTypeCode = q.PlacementStatus
		LEFT JOIN rds.dimcteStatuses cte 
			ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus
		LEFT OUTER JOIN rds.DimTitleIStatuses title1
			ON title1.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND title1.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND title1.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND title1.TitleISupportServicesCode = q.Title1SupportServiceCode
		LEFT OUTER JOIN rds.DimK12EnrollmentStatuses enrStatus
			ON q.exitCode = enrStatus.ExitOrWithdrawalTypeCode
			AND enrStatus.PostSecondaryEnrollmentStatusCode = q.PostSecondaryEnrollmentStatusCode
			AND enrStatus.EnrollmentStatusCode = q.EnrollmentStatusCode
			AND enrStatus.EntryTypeCode = q.EntryTypeCode
			AND enrStatus.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
			AND enrStatus.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		WHERE assess.DimAssessmentId <> -1
		GROUP BY
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(assess.DimAssessmentId, -1),
		ISNULL(grade.DimGradeLevelId, -1),
		ISNULL(d.DimK12DemographicId, -1),
		ISNULL(idea.DimIdeaStatusId, -1),
		ISNULL(programStatus.DimProgramStatusId, -1),
		isnull(title1.DimTitleIStatusId, -1),
		ISNULL(title3.DimTitleiiiStatusId, -1),
		ISNULL(assesSts.DimAssessmentStatusId, -1),
		ISNULL(studentStatus.DimK12StudentstatusId, -1),
		ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		ISNULL(race.DimRaceId,-1),
		isnull(enrStatus.DimK12EnrollmentStatusId, -1),
		ISNULL(cte.DimCteStatusId, -1)

		
	END
	ELSE
	BEGIN
		-- Run As Test (return data instead of inserting it)

		SELECT
			@factTypeId AS DimFactTypeId,
			q.DimK12StudentId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(d.DimK12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(assess.DimAssessmentId, -1) AS DimAssessmentId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			isnull(title1.DimTitleIStatusId, -1) as DimTitle1StatusId,
			ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId,
			ISNULL(assesSts.DimAssessmentStatusId, -1) AS DimAssessmentStatusId,
			ISNULL(studentStatus.DimK12StudentstatusId, -1) AS DimK12StudentstatusId,
			ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1) AS DimNorDProgramStatusId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
			ISNULL(race.DimRaceId,-1) AS DimRaceId,
			isnull(enrStatus.DimK12EnrollmentStatusId, -1) as DimEnrollmentStatusId,
			count(DISTINCT q.DimK12StudentId) AS AssessmentCount
		FROM #queryOutput q
		JOIN rds.DimAssessments assess
			ON q.AssessmentSubjectCode = assess.AssessmentSubjectCode
			AND q.AssessmentTypeCode = assess.AssessmentTypeCode
			AND q.ParticipationStatusCode = assess.ParticipationStatusCode
			AND q.PerformanceLevelCode = assess.PerformanceLevelCode
			AND q.SeaFullYearStatusCode = assess.SeaFullYearStatusCode
			AND q.LeaFullYearStatusCode = assess.LeaFullYearStatusCode
			AND q.SchFullYearStatusCode = assess.SchFullYearStatusCode
		JOIN rds.DimGradeLevels grade
			ON q.GradeLevelCode = grade.GradeLevelCode
		JOIN rds.DimRaces race
			ON q.RaceCode = race.RaceCode
		LEFT JOIN rds.DimK12Demographics d 
			ON q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			AND q.HomelessStatusCode = d.HomelessnessStatusCode
			AND q.LepStatusCode = d.EnglishLearnerStatusCode
			AND q.MigrantStatusCode = d.MigrantStatusCode
			AND q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			AND q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
			AND q.MilitaryConnected = CASE d.MilitaryConnectedStudentIndicatorCode
										WHEN 'ActiveDuty' THEN 'MILCNCTD'
										WHEN 'NationalGuardOrReserve' THEN 'MILCNCTD'
										WHEN 'NotMilitaryConnected' THEN 'NOTMILCNCTD'
										ELSE 'MISSING'
									END	
		LEFT JOIN rds.DimIdeaStatuses idea
			ON q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
			AND q.DisabilityCode = idea.PrimaryDisabilityTypeCode
			AND q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
			AND q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimTitleiiiStatuses title3	
			ON title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode		
			AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
			AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
			AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		LEFT JOIN rds.DimAssessmentStatuses assesSts 
			ON assesSts.AssessedFirstTimeCode = q.AssessedFirstTime
			AND assesSts.AssessmentProgressLevelCode = q.ProgressLevel 
			AND q.AcademicAssessmentSubjectCode = q.AssessmentSubjectCode
		LEFT JOIN rds.DimNorDProgramStatuses NorDProgramStatuses
			ON NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
			AND NorDProgramStatuses.NeglectedOrDelinquentProgramTypeCode = q.NeglectedProgramTypeCode
		LEFT JOIN rds.DimK12Studentstatuses studentStatus
			ON studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
			AND studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
			AND studentStatus.ReferralStatusCode = q.ReferralStatusCode
			AND studentStatus.HighSchoolDiplomaTypeCode = q.DiplomaCredentialCode
			AND studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
			AND studentStatus.PlacementStatusCode = q.PlacementStatus
			AND studentStatus.PlacementTypeCode = q.PlacementStatus
		LEFT JOIN rds.dimcteStatuses cte 
			ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus
		LEFT OUTER JOIN rds.DimTitleIStatuses title1
			ON title1.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND title1.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND title1.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND title1.TitleISupportServicesCode = q.Title1SupportServiceCode
		LEFT OUTER JOIN rds.DimK12EnrollmentStatuses enrStatus
			ON q.exitCode = enrStatus.ExitOrWithdrawalTypeCode
			AND enrStatus.PostSecondaryEnrollmentStatusCode = q.PostSecondaryEnrollmentStatusCode
			AND enrStatus.EnrollmentStatusCode = q.EnrollmentStatusCode
			AND enrStatus.EntryTypeCode = q.EntryTypeCode
			AND enrStatus.AcademicOrVocationalOutcomeEdFactsCode = q.AcademicOrVocationalOutcomeCode
			AND enrStatus.AcademicOrVocationalExitOutcomeEdFactsCode = q.AcademicOrVocationalExitOutcomeCode

		WHERE assess.DimAssessmentId <> -1
		GROUP BY
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(assess.DimAssessmentId, -1),
		ISNULL(grade.DimGradeLevelId, -1),
		ISNULL(d.DimK12DemographicId, -1),
		ISNULL(idea.DimIdeaStatusId, -1),
		ISNULL(programStatus.DimProgramStatusId, -1),
		isnull(title1.DimTitleIStatusId, -1),
		ISNULL(title3.DimTitleiiiStatusId, -1),
		ISNULL(assesSts.DimAssessmentStatusId, -1),
		ISNULL(studentStatus.DimK12StudentstatusId, -1),
		ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1),
		ISNULL(race.DimRaceId,-1),
		isnull(enrStatus.DimK12EnrollmentStatusId, -1),
		ISNULL(cte.DimCteStatusId, -1)

	END

	FETCH NEXT FROM selectedYears_cursor INTO @selectedDate, @submissionYear
	END

	END TRY
	BEGIN CATCH

		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		
	END CATCH

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END
	
	IF EXISTS (SELECT  1 FROM tempdb.dbo.sysobjects o WHERE o.xtype IN ('U') AND o.id = object_id(N'tempdb..#queryOutput'))
	DROP table #queryOutput
	DROP TABLE #demoQuery
	DROP TABLE #raceQuery
	DROP TABLE #assessmentQuery
	DROP TABLE #AssessmentStatusQuery
	DROP TABLE #ideaQuery
	DROP TABLE #programStatusQuery
	DROP TABLE #studentStatusQuery
	DROP TABLE #titleIIIStatusQuery
	DROP TABLE #NoDProgramStatus
	DROP TABLE #cteStatusQuery
	DROP TABLE #enrollmentStatusQuery	

	SET NOCOUNT OFF;
END
