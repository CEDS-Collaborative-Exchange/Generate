CREATE PROCEDURE [RDS].[Migrate_SpecialEdStudentCounts]
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
	SET @factTable = 'FactK12StudentCounts'
	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DataMigrationTypeId
	FROM app.DataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 0

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	END

	create table #queryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		DimK12StudentId int,
		StudentPersonId int,
		DimSchoolYearId int,
		DimK12SchoolId int,
		DimLeaId int,
		DimSeaId int,

		AgeCode varchar(50),
		RaceCode varchar(50),
		DimRaceId INT,

		EcoDisStatusCode VARCHAR(50),
		HomelessStatusCode VARCHAR(50),
		LepStatusCode VARCHAR(50),
		MigrantStatusCode VARCHAR(50),
		SexCode VARCHAR(50),
		MilitaryConnected VARCHAR(50),
		HomelessUnaccompaniedYouthStatusCode VARCHAR(50),
		HomelessNighttimeResidenceCode VARCHAR(50),
		DimK12DemographicId INT,

		IdeaIndicatorCode varchar(50),
		BasisOfExitCode VARCHAR(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		StudentCutOverStartDate Date,
		DimIdeaStatusId INT,
		SpecialEducationServicesExitDateId INT,

		GradeLevelCode varchar(50),

		CteCode VARCHAR(50),
		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIProgramParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50),

		DisplacedHomemaker VARCHAR(50),
		SingleParent VARCHAR(50),
		CteNonTraditionalEnrollee VARCHAR(50),
		PlacementType VARCHAR(50),
		PlacementStatus VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		InclutypCode VARCHAR(50),
		LepPerkinsStatusCode VARCHAR(50),

		TitleISchoolStatusCode VARCHAR(50),
		TitleIinstructionalServiceCode VARCHAR(50),		
		Title1SupportServiceCode VARCHAR(50),
		Title1ProgramTypeCode VARCHAR(50),

		ExitOrWithdrawalTypeCode VARCHAR(50),
		DimK12EnrollmentStatusId INT
	)
	
	DECLARE @studentDateQuery AS rds.K12StudentDateTableType
	
	DECLARE @raceQuery AS table (
		DimK12StudentId INT,
		DimCountDateId INT,
		DimLeaId INT,
		DimK12SchoolId INT,
		DimRaceId INT,
		RaceCode VARCHAR(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate datetime
	)
	
	DECLARE @ageQuery AS table (
		DimK12StudentId INT,
		PersonId INT,
		DimLeaId INT,
		DimK12SchoolId INT,
		DimSeaId int,
		DimCountDateId INT,
		AgeCode VARCHAR(50),
		Exitdate datetime
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
	
	DECLARE @schoolQuery AS RDS.K12StudentOrganizationTableType
	
	DECLARE @ideaQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		DimIeuId INT,
		PersonId INT,
		DimCountDateId INT,
		IdeaIndicatorCode varchar(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		BasisOfExitCode VARCHAR(50),
		SpecialEducationServicesExitDate Date,
		RecordStartDateTime DATETIME,
		RecordEndDateTime DATETIME NULL,
		DimIdeaStatusId INT,
		SpecialEducationServicesExitDateId INT
	)
	
	DECLARE @programStatusQuery AS table (
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

	
	DECLARE @title1StatusQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,
		TitleISchoolStatusCode VARCHAR(50),
		TitleIinstructionalServiceCode VARCHAR(50),		
		Title1SupportServiceCode VARCHAR(50),
		Title1ProgramTypeCode VARCHAR(50)
	)

	DECLARE @cteStatusQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId int,
		PersonId INT,
		DimCountDateId INT,
		CteCode VARCHAR(50),
		DisplacedHomemaker VARCHAR(50),
		SingleParent VARCHAR(50),
		CteNonTraditionalEnrollee VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		InclutypCode VARCHAR(50),
		LepPerkinsStatusCode VARCHAR(50)
	)

	DECLARE @enrollmentStatusQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		ExitCode VARCHAR(50),
		EnrollmentStatusCode VARCHAR(50),
		EntryTypeCode VARCHAR(50),
		PostSecondaryEnrollmentStatusCode VARCHAR(50),
		DimK12EnrollmentStatusId INT,
		AcademicOrVocationalOutcomeCode VARCHAR(50),
		AcademicOrVocationalExitOutcomeCode VARCHAR(50)
	 )
			
	-- Log history

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	END


	BEGIN TRY
	
	DECLARE @selectedDate AS INT, @submissionYear AS VARCHAR(50)
	DECLARE selectedYears_cursor CURSOR FOR 
	SELECT d.DimSchoolYearId, d.SchoolYear
		FROM rds.DimSchoolYears d
		JOIN rds.DimSchoolYearDataMigrationTypes dd ON dd.DimSchoolYearId = d.DimSchoolYearId 
		JOIN rds.DimDataMigrationTypes b ON b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
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
	DELETE FROM @raceQuery
	DELETE FROM @ageQuery
	DELETE FROM #demoQuery
	DELETE FROM @schoolQuery
	DELETE FROM @ideaQuery
	DELETE FROM @programStatusQuery
	DELETE FROM @title1StatusQuery
	DELETE FROM @cteStatusQuery
	DELETE FROM @enrollmentStatusQuery
	

	-- Get Dimension Data
	----------------------------

	
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
	exec rds.Migrate_DimSchoolYears_K12Students @factTypeCode, @migrationType, @selectedDate, 0, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'studentDateQuery'
		SELECT * FROM @studentDateQuery order by DimK12StudentId
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
		print '@schoolQuery'
		SELECT * FROM @schoolQuery order by DimK12StudentId
	END

	-- Migrate_DimK12Races

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Race Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END

	
	INSERT INTO @raceQuery
	(
		DimK12StudentId,
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
		SELECT * FROM @raceQuery order by DimK12StudentId
	END

	 
	-- Migrate_DimAges

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Age Dimension for (' + @factTypeCode + ') - ' +  @submissionYear)
	END

	INSERT INTO @ageQuery
	(
		DimK12StudentId,
		PersonId,
		DimLeaId,
		DimK12SchoolId,
		DimSeaId,
		DimCountDateId,
		AgeCode,
		Exitdate
	)
	exec rds.Migrate_DimAges @studentDateQuery, @factTypeCode, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'ageQuery'
		SELECT * FROM @ageQuery order by DimK12StudentId
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
	exec rds.Migrate_DimK12Demographics @studentDateQuery, @schoolQuery, @useCutOffDate, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'demoQuery'
		SELECT * FROM #demoQuery  order by DimK12StudentId
	END

	
	-- Migrate_DimIdeaStatuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating IDEA Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END
		
	INSERT INTO @ideaQuery
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
		RecordEndDateTIme,
		DimIdeaStatusId,
		SpecialEducationServicesExitDateId
	)
	exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate, @schoolQuery, @dataCollectionId

	DELETE FROM @ideaQuery WHERE SpecialEducationServicesExitDate IS NULL

	IF @runAsTest = 1
	BEGIN
		print '@ideaQuery'
		SELECT * FROM @ideaQuery order by DimK12StudentId
	END

	
	-- Migrate_DimProgramStatuses
	
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Program Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO @programStatusQuery
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
	exec rds.Migrate_DimProgramStatuses @studentDateQuery, @useCutOffDate, @schoolQuery, @dataCollectionId
	
	IF @runAsTest = 1
	BEGIN
		print '@programStatusQuery'
		SELECT * FROM @programStatusQuery order by DimK12StudentId
	END


		
	-- Migrate_DimTitleIStatuses

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title I Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO @title1StatusQuery
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

	IF @runAsTest = 1
	BEGIN
		print 'title1StatusQuery'
		SELECT * FROM @title1StatusQuery order by DimK12StudentId
	END


	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Cte Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO @cteStatusQuery
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
		LepPerkinsStatusCode
	)
	exec RDS.Migrate_DimCteStatuses @studentDateQuery, @schoolQuery, @dataCollectionId

	IF @runAsTest = 1
	BEGIN
		print 'cteStatusQuery'
		SELECT * FROM @cteStatusQuery order by DimK12StudentId
	END




	insert into @enrollmentStatusQuery
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

	-- Combine Dimension Data
	----------------------------
	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combining Dimension Data for (' + @factTypeCode + ') -  ' + @submissionYear)
	END

	INSERT INTO #queryOutput
	(
		DimK12StudentId,
		DimSchoolYearId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		AgeCode,
		RaceCode,
		DimRaceId,

		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,
		DimK12DemographicId, 

		IdeaIndicatorCode,
		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		StudentCutOverStartDate,
		DimIdeaStatusId,
		SpecialEducationServicesExitDateId,
	
		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,
				
		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,

		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatusCode,

		ExitOrWithdrawalTypeCode,
		DimK12EnrollmentStatusId
	)
	SELECT 
		s.DimK12StudentId,
		s.DimSchoolYearId,
		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId, -1),
		ISNULL(sch.DimSeaId, -1),
		a.AgeCode,
		ISNULL(race.RaceCode,'MISSING'),
		ISNULL(race.DimRaceId, -1),

		ISNULL(demo.EcoDisStatusCode, 'MISSING'),
		ISNULL(demo.HomelessStatusCode, 'MISSING'),
--		ISNULL(demo.LepStatusCode, 'MISSING'),
		ISNULL(demo.LepStatusCode, 'NLEP'),
		ISNULL(demo.MigrantStatusCode, 'MISSING'),
		ISNULL(st.SexCode, 'MISSING'),
		ISNULL(demo.MilitaryConnected, 'MISSING'),
		ISNULL(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		ISNULL(demo.HomelessNighttimeResidenceCode, 'MISSING'),
		ISNULL(demo.DimK12DemographicId, -1),
		
		ISNULL(idea.IdeaIndicatorCode, 'MISSING'),
		ISNULL(idea.BasisOfExitCode, 'MISSING'),
		ISNULL(idea.DisabilityCode, 'MISSING'),
		ISNULL(idea.EducEnvCode, 'MISSING'),
		idea.SpecialEducationServicesExitDate,
		ISNULL(idea.DimIdeaStatusId, -1),
		ISNULL(idea.SpecialEducationServicesExitDateId, -1),
		
		ISNULL(cteStatus.CteCode,'MISSING'),
		ISNULL(programStatus.ImmigrantTitleIIICode,'MISSING'),
		ISNULL(programStatus.Section504Code,'MISSING'),
		ISNULL(programStatus.FoodServiceEligibilityCode,'MISSING'),
		ISNULL(programStatus.FosterCareCode,'MISSING'),
		ISNULL(programStatus.TitleIIIProgramParticipation, 'MISSING'),
		ISNULL(programStatus.HomelessServicedIndicatorCode, 'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),

		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatusCode, 'MISSING'),

		ISNULL(K12EnrollmentStatus.ExitCode, 'MISSING'),
		ISNULL(K12EnrollmentStatus.DimK12EnrollmentStatusId, -1)

	FROM @studentDateQuery s
	LEFT JOIN rds.DimK12Students st on s.DimK12StudentId = st.DimK12StudentId
	LEFT JOIN @schoolQuery sch ON s.DimK12StudentId = sch.DimK12StudentId AND s.DimCountDateId = sch.DimCountDateId
	LEFT JOIN @ideaQuery idea ON s.DimK12StudentId = idea.DimK12StudentId AND s.DimCountDateId = idea.DimCountDateId 
									AND sch.DimK12SchoolId = idea.DimK12SchoolId AND sch.DimLeaId = idea.DimLeaId
	LEFT JOIN #demoQuery demo ON s.DimK12StudentId = demo.DimK12StudentId AND s.DimCountDateId = demo.DimDateId
		AND idea.SpecialEducationServicesExitDate >= Convert(Date,demo.PersonStartDate)
		AND idea.SpecialEducationServicesExitDate <= Convert(Date,ISNULL(demo.PersonEndDate, idea.SpecialEducationServicesExitDate))
	LEFT JOIN @raceQuery race ON s.DimK12StudentId = race.DimK12StudentId AND s.DimCountDateId = race.DimCountDateId
		AND idea.SpecialEducationServicesExitDate >= Convert(Date,race.RaceRecordStartDate)
		AND idea.SpecialEducationServicesExitDate <= Convert(Date,ISNULL(race.RaceRecordEndDate, idea.SpecialEducationServicesExitDate))
	LEFT JOIN @ageQuery a ON s.DimK12StudentId = a.DimK12StudentId AND s.DimCountDateId = a.DimCountDateId 
									AND a.Exitdate = idea.SpecialEducationServicesExitDate
									AND sch.DimK12SchoolId = a.DimK12SchoolId AND sch.DimLeaId = a.DimLeaId
	LEFT JOIN @programStatusQuery programStatus ON s.DimK12StudentId = programStatus.DimK12StudentId AND s.DimCountDateId = programStatus.DimCountDateId 
											AND sch.DimK12SchoolId = programStatus.DimK12SchoolId AND sch.DimLeaId = programStatus.DimLeaId
	LEFT JOIN @title1StatusQuery title1  ON s.DimK12StudentId = title1.DimK12StudentId AND s.DimCountDateId = title1.DimCountDateId 
												AND sch.DimK12SchoolId = title1.DimK12SchoolId AND sch.DimLeaId = title1.DimLeaId
	LEFT JOIN @cteStatusQuery cteStatus ON s.DimK12StudentId = cteStatus.DimK12StudentId AND s.DimCountDateId = cteStatus.DimCountDateId 
										AND sch.DimK12SchoolId = cteStatus.DimK12SchoolId AND sch.DimLeaId = cteStatus.DimLeaId
	LEFT JOIN @EnrollmentStatusQuery K12EnrollmentStatus ON s.DimK12StudentId = K12EnrollmentStatus.DimK12StudentId AND s.DimCountDateId = K12EnrollmentStatus.DimCountDateId 
										AND sch.DimK12SchoolId = K12EnrollmentStatus.DimK12SchoolId AND sch.DimLeaId = K12EnrollmentStatus.DimLeaId
	
	IF @runAsTest = 1
	BEGIN
		print 'queryOutput'
		SELECT * FROM #queryOutput order by DimK12StudentId
	END

	-- INSERT New Facts
	----------------------------

	-- Log history

	
	IF @runAsTest = 0
	BEGIN

		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

		INSERT INTO rds.FactK12StudentCounts
		(
			FactTypeId,
			K12StudentId,
			K12SchoolId,
			LeaId,
			SeaId,
			SchoolYearId,
			K12DemographicId,
			IdeaStatusId,
			AgeId,
			GradeLevelId,
			ProgramStatusId,
			StudentCount,
			LanguageId,
			MigrantId,
			K12StudentStatusId,
			TitleIStatusId,
			TitleIIIStatusId,
			AttendanceId,
			CohortStatusId,
			NOrDProgramStatusId,
			StudentCutOverStartDate,
			RaceId,
			CteStatusId,
			K12EnrollmentStatusId,
			SpecialEducationServicesExitDateId
		)
		SELECT DISTINCT
		@factTypeId AS DimFactTypeId,
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(q.DimK12DemographicId, -1) AS DimK12DemographicId,
		ISNULL(q.DimIdeaStatusId, -1) AS DimIdeaStatusId,
		a.DimAgeId,
		-1,
		ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
		1 AS StudentCount,
		-1,	-1,	-1,
		ISNULL(titleI.DimTitleIStatusId, -1) AS DimTitleIStatusId,
		-1, -1, -1, -1,
		q.StudentCutOverStartDate,
		ISNULL(q.DimRaceId,-1) AS DimRaceId,
		ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
		q.DimK12EnrollmentStatusId,
		q.SpecialEducationServicesExitDateId
		FROM #queryOutput q
		JOIN rds.DimAges a	ON q.AgeCode = a.AgeCode

		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimTitleIStatuses titleI
			ON titleI.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND titleI.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND titleI.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND titleI.TitleISupportServicesCode = q.Title1SupportServiceCode

		LEFT JOIN rds.dimcteStatuses cte ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatusCode
		
	END
	ELSE
	BEGIN

		-- Run As Test (return data instead of inserting it)

		SELECT DISTINCT
		@factTypeId AS DimFactTypeId,
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(q.DimK12DemographicId, -1) AS DimK12DemographicId,
		ISNULL(q.DimIdeaStatusId, -1) AS DimIdeaStatusId,
		a.DimAgeId,
		-1,
		ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
		1 AS StudentCount,
		-1,	-1,	-1,
		ISNULL(titleI.DimTitleIStatusId, -1) AS DimTitleIStatusId,
		-1, -1, -1, -1,
		q.StudentCutOverStartDate,
		ISNULL(q.DimRaceId,-1) AS DimRaceId,
		ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
		q.DimK12EnrollmentStatusId,
		q.SpecialEducationServicesExitDateId
		FROM #queryOutput q
		JOIN rds.DimAges a	ON q.AgeCode = a.AgeCode

		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimTitleIStatuses titleI
			ON titleI.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND titleI.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND titleI.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND titleI.TitleISupportServicesCode = q.Title1SupportServiceCode

		LEFT JOIN rds.dimcteStatuses cte ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatusCode

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
	
	DROP table #queryOutput
	DROP TABLE #demoQuery

	SET NOCOUNT OFF;
END
