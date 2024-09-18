CREATE PROCEDURE [RDS].[Migrate_StudentDisciplines]
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
	SET @factTable = 'FactStudentDisciplines'
	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DataMigrationTypeId
	FROM app.DataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	-- Get child count date for age calculation
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
	set @cutOffMonth = 11
	set @cutOffDay = 1

	-- Get Custom Child Count Date (if available)
	select @customFactTypeDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
	select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	create table #queryOutput (
		QueryOutputId INT IDENTITY(1,1) NOT NULL,
		DimK12StudentId INT,
		DimSchoolYearId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		IncidentId int,

		AgeCode VARCHAR(50),
		GradeLevelCode VARCHAR(50),
		RaceCode VARCHAR(50),

		EcoDisStatusCode VARCHAR(50),
		HomelessStatusCode VARCHAR(50),
		LepStatusCode VARCHAR(50),
		MigrantStatusCode VARCHAR(50),
		SexCode VARCHAR(50),
		MilitaryConnected VARCHAR(50),
		HomelessUnaccompaniedYouthStatusCode VARCHAR(50),
		HomelessNighttimeResidenceCode VARCHAR(50),

		IdeaIndicatorCode VARCHAR(50),
		BasisOfExitCode VARCHAR(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		--TitleIStatusCode VARCHAR(50),

		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIImmigrantParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50),

		DimDisciplineId INT,
		--DisciplineMethodCode VARCHAR(50),
		--EducationalServicesCode VARCHAR(50),
		--RemovalReasonCode VARCHAR(50),
		--RemovalTypeCode VARCHAR(50),
		--DisciplineELStatusCode VARCHAR(50),
		DisciplinaryActionStartDate date,

		CteCode VARCHAR(50),
		DisplacedHomemaker VARCHAR(50),
		SingleParent VARCHAR(50),
		CteNonTraditionalEnrollee VARCHAR(50),
		RepresentationStatus VARCHAR(50),
		InclutypCode VARCHAR(50),
		LepPerkinsStatus VARCHAR(50),

		FirearmsCode VARCHAR(50),
		DimFirearmDisciplineId INT,
		--FirearmsDisciplineCode VARCHAR(50),
		--IDEAFirearmsDisciplineCode VARCHAR(50),
			
		DisciplineCount INT,
		DisciplineDuration DECIMAL(18,2)

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

	DECLARE @gradelevelQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		EntryGradeLevelCode Varchar(50),
		ExitGradeLevelCode Varchar(50),
		DimEntryGradeLevelId INT,
		DimExitGradeLevelId INT
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
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIImmigrantParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50)
	)

	DECLARE @firearmQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		FirearmsCode VARCHAR(50))


	DECLARE @disciplineQuery AS table (
		DimK12StudentId INT,
		PersonId INT,
		DimCountDateId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		IncidentId int,
		DisciplineActionCode VARCHAR(50),
		DisciplineMethodCode VARCHAR(50),
		EducationalServicesCode VARCHAR(50),
		RemovalReasonCode VARCHAR(50),
		RemovalTypeCode VARCHAR(50),
		DisciplineELStatusCode VARCHAR(50),
		DisciplineDuration DECIMAL(18,2),
		DisciplinaryActionStartDate Date,
		DimDisciplineId INT
	)

	DECLARE @disciplineFirearmsQuery AS table (
		DimK12StudentId INT,
		DimCountDateId INT,
		PersonId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		IncidentId INT,
		FirearmsDisciplineCode VARCHAR(50),
		IDEAFirearmsDisciplineCode VARCHAR(50),
		DisciplinaryActionStartDate Date,
		DimFirearmDisciplineId INT
		)

	DECLARE @cteStatusQuery AS table (
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

	DECLARE @schoolQuery AS RDS.K12StudentOrganizationTableType

	DECLARE @factDimensions AS table(
		DimensionTableName NVARCHAR(100)
	)

	INSERT INTO @factDimensions(DimensionTableName)
	SELECT dt.DimensionTableName 
	FROM rds.DimFactType_DimensionTables ftd
	JOIN rds.DimFactTypes ft ON ftd.DimFactTypeId = ft.DimFactTypeId
	JOIN app.DimensionTables dt ON ftd.DimensionTableId = dt.DimensionTableId
	WHERE ft.FactTypeCode = @factTypeCode
	

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
	JOIN rds.DimSchoolYearDataMigrationTypes dd 
		ON dd.DimSchoolYearId = d.DimSchoolYearId
	JOIN rds.DimDataMigrationTypes b 
		ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
	WHERE d.DimSchoolYearId <> -1 
	AND dd.IsSelected = 1 
	AND DataMigrationTypeCode = @migrationType

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
	DELETE FROM #demoQuery
	DELETE FROM @schoolQuery
	DELETE FROM @gradelevelQuery
	DELETE FROM @ideaQuery
	DELETE FROM @programStatusQuery
	DELETE FROM @disciplineFirearmsQuery
	DELETE FROM @disciplineQuery
	DELETE FROM @firearmQuery
	DELETE FROM @cteStatusQuery

	-- Migrate_DimDates
	
	
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
	exec rds.Migrate_DimSchoolYears_K12Students @factTypeCode, @migrationType, @selectedDate

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

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimRaces')
	BEGIN

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
			SELECT * FROM @raceQuery
		END

	END

	

	--- Migrate GradeLevels

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimGradeLevels')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Grade Level Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		INSERT INTO @gradelevelQuery
		(
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
			PersonId,
			DimCountDateId,
			EntryGradeLevelCode,
			ExitGradeLevelCode,
			DimEntryGradeLevelId,
			DimExitGradeLevelId
		)
		exec rds.Migrate_DimGradeLevels @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'gradelevelQuery'
			SELECT * FROM @gradelevelQuery
		END

	END
	
	-- Migrate_DimK12Demographics

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimK12Demographics')
	BEGIN

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

	END
	
	-- Migrate_DimIdeaStatuses

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimIdeaStatuses')
	BEGIN

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
			RecordEndDateTime,
			DimIdeaStatusId,
			SpecialEducationServicesExitDateId

		)
		exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, 0, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'ideaQuery'
			SELECT * FROM @ideaQuery
		END

	END

	
	-- Migrate_DimProgramStatuses

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimProgramStatuses')
	BEGIN

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
			TitleIIIImmigrantParticipation,
			HomelessServicedIndicatorCode
		)
		exec rds.Migrate_DimProgramStatuses @studentDateQuery, 0, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'programStatusQuery'
			SELECT * FROM @programStatusQuery
		END

	END

----Migrate_DimFirearms

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimFirearms')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Firearms Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @firearmQuery
		(
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
			PersonId,
			DimCountDateId,
			FirearmsCode
		)
		exec rds.Migrate_DimFirearms @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'firearmQuery'
			SELECT * FROM @firearmQuery
		END

	END

	--Migrate_DimDisciplineFirearms

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimFirearmDisciplines')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Discipline Firearms Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @disciplineFirearmsQuery
		(
			DimK12StudentId,
			DimCountDateId,
			PersonId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
			IncidentId,
			FirearmsDisciplineCode,
			IDEAFirearmsDisciplineCode,
			DisciplinaryActionStartDate,
			DimFirearmDisciplineId
		)
		exec rds.Migrate_DimFirearmsDiscipline @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'disciplineFirearmsQuery'
			SELECT * FROM @disciplineFirearmsQuery
		END

	END

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimCteStatuses')
	BEGIN

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
			LepPerkinsStatus
		)
		exec RDS.Migrate_DimCteStatuses @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'cteStatusQuery'
			SELECT * FROM @cteStatusQuery
		END

	END
		
	-- Migrate_DimDisciplines

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Discipline Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	END

	INSERT INTO @disciplineQuery
	(
		DimK12StudentId,
		DimCountDateId,
		PersonId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		IncidentId,
		DisciplineActionCode,
		DisciplineMethodCode,
		EducationalServicesCode,
		RemovalReasonCode,
		RemovalTypeCode,
		DisciplineELStatusCode,
		DisciplineDuration,
		DisciplinaryActionStartDate,
		DimDisciplineId
	)
	exec rds.Migrate_DimDisciplines @studentDateQuery, @schoolQuery, @dataCollectionId
		
	IF @runAsTest = 1
	BEGIN
		print 'disciplineQuery'
		SELECT * FROM @disciplineQuery
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
		DimSchoolYearId,
		DimK12SchoolId,
		DimLeaId,
		DimSeaId,
		IncidentId,

		AgeCode,
		GradeLevelCode,
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
	--	TitleIStatusCode,

		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIImmigrantParticipation,
		HomelessServicedIndicatorCode,

		DimDisciplineId,
		--DisciplineMethodCode,
		--EducationalServicesCode,
		--RemovalReasonCode,
		--RemovalTypeCode,
		--DisciplineELStatusCode,
		DisciplinaryActionStartDate,

		CteCode,
		DisplacedHomemaker,
		SingleParent,
		CteNonTraditionalEnrollee,
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatus,

		FirearmsCode,
		DimFirearmDisciplineId,
		--FirearmsDisciplineCode, 
		--IDEAFirearmsDisciplineCode, 

		DisciplineCount,
		DisciplineDuration

	)
	SELECT DISTINCT 
		s.DimK12StudentId,
		s.DimSchoolYearId,
		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId,-1),
		isnull(sch.DimSeaId,-1),
		dis.IncidentId,
		ISNULL(CAST(rds.Get_Age(st.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @submissionYear - 1 ELSE @submissionYear END, @cutOffMonth, @cutOffDay)) AS VARCHAR(50)), 'MISSING') AS AgeCode,
		ISNULL(grade.EntryGradeLevelCode,'MISSING'),
		ISNULL(race.RaceCode,'MISSING'),

		ISNULL(demo.EcoDisStatusCode, 'MISSING'),
		ISNULL(demo.HomelessStatusCode, 'MISSING'),
--		ISNULL(demo.LepStatusCode, 'MISSING'),
		ISNULL(demo.LepStatusCode, 'NLEP'),
		ISNULL(demo.MigrantStatusCode, 'MISSING'),
		ISNULL(st.SexCode, 'MISSING'),
		ISNULL(demo.MilitaryConnected, 'MISSING'),
		ISNULL(demo.HomelessUnaccompaniedYouthStatusCode, 'MISSING'),
		ISNULL(demo.HomelessNighttimeResidenceCode, 'MISSING'),

		ISNULL(idea.IDEAIndicatorCode, 'MISSING'),
		ISNULL(idea.BasisOfExitCode, 'MISSING'),
		ISNULL(idea.DisabilityCode, 'MISSING'),
		ISNULL(idea.EducEnvCode, 'MISSING'),
	--	ISNULL(idea.TitleIStatusCode, 'MISSING'),

		ISNULL(programStatus.ImmigrantTitleIIICode,'MISSING'),
		ISNULL(programStatus.Section504Code,'MISSING'),
		ISNULL(programStatus.FoodServiceEligibilityCode,'MISSING'),
		ISNULL(programStatus.FosterCareCode,'MISSING'),
		ISNULL(programStatus.TitleIIIImmigrantParticipation,'MISSING'),
		ISNULL(programStatus.HomelessServicedIndicatorCode,'MISSING'),

		dis.DimDisciplineId,
		--ISNULL(dis.DisciplineMethodCode, 'MISSING'),
		--ISNULL(dis.EducationalServicesCode, 'MISSING'),
		--ISNULL(dis.RemovalReasonCode, 'MISSING'),
		--ISNULL(dis.RemovalTypeCode, 'MISSING'),
		--ISNULL(DisciplineELStatusCode, 'MISSING'),
		dis.DisciplinaryActionStartDate,

		ISNULL(cteStatus.CteCode,'MISSING'),
		ISNULL(cteStatus.DisplacedHomemaker, 'MISSING'),
		ISNULL(cteStatus.SingleParent, 'MISSING'),
		ISNULL(cteStatus.CteNonTraditionalEnrollee, 'MISSING'),
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING'),

		ISNULL(firearms.FirearmsCode, 'MISSING'),
		disciplineFirearms.DimFirearmDisciplineId,
		--ISNULL(disciplineFirearms.FirearmsDisciplineCode, 'MISSING'),
		--ISNULL(disciplineFirearms.IDEAFirearmsDisciplineCode, 'MISSING'),

		1,
		dis.DisciplineDuration

	FROM @studentDateQuery s
	JOIN rds.DimK12Students st 
		on s.DimK12StudentId = st.DimK12StudentId
	JOIN @schoolQuery sch 
		ON s.DimK12StudentId = sch.DimK12StudentId 
		AND s.DimCountDateId = sch.DimCountDateId
	LEFT JOIN @disciplineQuery dis 
		ON s.DimK12StudentId = dis.DimK12StudentId 
		AND s.DimCountDateId = dis.DimCountDateId 
		AND sch.DimK12SchoolId = dis.DimK12SchoolId 
		AND sch.DimLeaId = dis.DimLeaId
	LEFT JOIN #demoQuery demo 
		ON s.DimK12StudentId = demo.DimK12StudentId 
		AND s.DimCountDateId = demo.DimDateId
		AND dis.DisciplinaryActionStartDate >= Convert(Date,demo.PersonStartDate)
		AND dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(demo.PersonEndDate,dis.DisciplinaryActionStartDate))
	LEFT JOIN @raceQuery race 
		ON s.DimK12StudentId = race.DimK12StudentId 
		AND s.DimCountDateId = race.DimCountDateId
		AND dis.DisciplinaryActionStartDate >= Convert(Date,race.RaceRecordStartDate)
		AND dis.DisciplinaryActionStartDate <= Convert(Date,ISNULL(race.RaceRecordEndDate,dis.DisciplinaryActionStartDate))
	LEFT JOIN @gradelevelQuery grade 
		ON s.DimK12StudentId = grade.DimK12StudentId 
		AND s.DimCountDateId = grade.DimCountDateId 
		AND sch.DimK12SchoolId = grade.DimK12SchoolId 
		AND sch.DimLeaId = grade.DimLeaId
	LEFT JOIN @ideaQuery idea 
		ON s.DimK12StudentId = idea.DimK12StudentId 
		AND s.DimCountDateId = idea.DimCountDateId 
		AND idea.DimK12SchoolId = sch.DimK12SchoolId AND sch.DimLeaId = idea.DimLeaId
		AND dis.DisciplinaryActionStartDate BETWEEN idea.RecordStartDateTime and ISNULL(idea.RecordEndDateTime, GETDATE())
	LEFT JOIN @programStatusQuery programStatus 
		ON s.DimK12StudentId = programStatus.DimK12StudentId 
		AND s.DimCountDateId = programStatus.DimCountDateId 
		AND sch.DimK12SchoolId = programStatus.DimK12SchoolId 
		AND sch.DimLeaId = programStatus.DimLeaId
	LEFT JOIN @firearmQuery firearms 
		ON s.DimK12StudentId = firearms.DimK12StudentId 
		AND s.DimCountDateId = firearms.DimCountDateId 
		AND sch.DimK12SchoolId = firearms.DimK12SchoolId 
		AND sch.DimLeaId = firearms.DimLeaId
	LEFT JOIN @cteStatusQuery cteStatus  
		ON s.DimK12StudentId = cteStatus.DimK12StudentId 
		AND s.DimCountDateId = cteStatus.DimCountDateId 
		AND sch.DimK12SchoolId = cteStatus.DimK12SchoolId 
		AND sch.DimLeaId = cteStatus.DimLeaId
	LEFT JOIN @disciplineFirearmsQuery disciplineFirearms 
		ON s.DimK12StudentId = disciplineFirearms.DimK12StudentId 
		AND s.DimCountDateId = disciplineFirearms.DimCountDateId 
		AND sch.DimK12SchoolId = disciplineFirearms.DimK12SchoolId 
		AND sch.DimLeaId = disciplineFirearms.DimLeaId
		AND disciplineFirearms.IncidentId = dis.IncidentId
		AND disciplineFirearms.DisciplinaryActionStartDate = dis.DisciplinaryActionStartDate

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
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

		INSERT INTO rds.FactK12StudentDisciplines
		(
			FactTypeId,
			K12StudentId,
			K12SchoolId,
			LeaId,
			SeaId,
			SchoolYearId,
			AgeId,
			GradeLevelId,
			K12DemographicId,
			IdeaStatusId,
			ProgramStatusId,
			DisciplineId,
			FirearmsId,
			FirearmDisciplineId,
			DisciplineCount,
			DisciplineDuration,
			DisciplinaryActionStartDate,
			RaceId,
			CteStatusId
		)
		SELECT DISTINCT
			@factTypeId AS DimFactTypeId,
			q.DimK12StudentId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(a.DimAgeId, -1) AS DimAgeId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(d.DimK12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			ISNULL(dis.DimDisciplineId, -1) AS DimDisciplineId,
			ISNULL(firearms.DimFirearmsId,-1) AS DimFirearmsId,
			ISNULL(disciplineFirearms.DimFirearmDisciplineId,-1) AS DimFirearmsDisciplineId,
			--sum( 
			CASE WHEN ISNULL(dis.DimDisciplineId, -1) <> -1 THEN 1 ELSE 0 END AS DisciplineCount,
			CASE WHEN ISNULL(dis.DimDisciplineId, -1) <> -1 THEN sum(q.DisciplineDuration) ELSE 0 END AS DisciplineDuration,
			ISNULL(q.DisciplinaryActionStartDate, getdate()) AS DisciplinaryActionStartDate,
			ISNULL(race.DimRaceId,-1) AS DimRaceId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId
		FROM #queryOutput q
		LEFT JOIN rds.DimAges a 
			ON q.AgeCode = a.AgeCode
		LEFT JOIN rds.DimGradeLevels grade
			ON q.GradeLevelCode = grade.GradeLevelCode
		LEFT JOIN rds.DimRaces race
			ON q.RaceCode = race.RaceCode
		LEFT JOIN rds.DimK12Demographics d 
			ON q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			AND q.HomelessStatusCode = d.HomelessnessStatusCode
			AND q.LepStatusCode = d.EnglishLearnerStatusCode
			AND q.MigrantStatusCode = d.MigrantStatusCode
			AND q.MilitaryConnected = d.MilitaryConnectedStudentIndicatorCode
			AND q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			AND q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
		LEFT JOIN rds.DimIdeaStatuses idea
			ON q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
			AND q.DisabilityCode = idea.PrimaryDisabilityTypeCode
			AND q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
			AND q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		LEFT JOIN rds.DimDisciplines dis
			ON q.DimDisciplineId = dis.DimDisciplineId
			--ON q.DisciplineMethodCode = dis.DisciplineMethodOfChildrenWithDisabilitiesCode
			--AND q.EducationalServicesCode = dis.EducationalServicesAfterRemovalCode
			--AND q.RemovalReasonCode = dis.IdeaInterimRemovalReasonCode
			--AND q.RemovalTypeCode = dis.IdeaInterimRemovalCode
			--AND q.DisciplineELStatusCode = dis.DisciplineELStatusCode
		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIImmigrantParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimFirearms firearms 
			ON firearms.FirearmTypeCode = q.FirearmsCode
		LEFT JOIN rds.DimFirearmDisciplines disciplineFirearms 
			ON q.DimFirearmDisciplineId = disciplineFirearms.DimFirearmDisciplineId
			--ON disciplineFirearms.DisciplineMethodForFirearmsIncidentsCode = q.FirearmsDisciplineCode
			--AND disciplineFirearms.IdeaDisciplineMethodForFirearmsIncidentsCode = q.IDEAFirearmsDisciplineCode
		LEFT JOIN rds.dimcteStatuses cte 
			ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus
		GROUP BY
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(a.DimAgeId, -1),
		ISNULL(grade.DimGradeLevelId, -1),
		ISNULL(d.DimK12DemographicId, -1),
		ISNULL(idea.DimIdeaStatusId, -1),
		ISNULL(dis.DimDisciplineId, -1),
		isnull(q.IncidentId, -1),
		ISNULL(programStatus.DimProgramStatusId, -1),
		ISNULL(firearms.DimFirearmsId, -1),
		ISNULL(disciplineFirearms.DimFirearmDisciplineId,-1),
		ISNULL(cte.DimCteStatusId, -1),
		ISNULL(race.DimRaceId,-1),
		ISNULL(cte.DimCteStatusId, -1),
		q.DisciplinaryActionStartDate

		
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
			ISNULL(a.DimAgeId, -1) AS DimAgeId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(d.DimK12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			ISNULL(dis.DimDisciplineId, -1) AS DimDisciplineId,
			ISNULL(firearms.DimFirearmsId,-1) AS DimFirearmsId,
			ISNULL(disciplineFirearms.DimFirearmDisciplineId,-1) AS DimFirearmsDisciplineId,
			--sum( 
			CASE WHEN ISNULL(dis.DimDisciplineId, -1) <> -1 THEN 1 ELSE 0 END AS DisciplineCount,
			CASE WHEN ISNULL(dis.DimDisciplineId, -1) <> -1 THEN sum(q.DisciplineDuration) ELSE 0 END AS DisciplineDuration,
			ISNULL(q.DisciplinaryActionStartDate,getdate()) AS DisciplinaryActionStartDate,
			ISNULL(race.DimRaceId,-1) AS DimRaceId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId
		FROM #queryOutput q
		LEFT JOIN rds.DimAges a ON q.AgeCode = a.AgeCode
		LEFT JOIN rds.DimGradeLevels grade
			ON q.GradeLevelCode = grade.GradeLevelCode
		LEFT JOIN rds.DimRaces race
			ON q.RaceCode = race.RaceCode
		LEFT JOIN rds.DimK12Demographics d 
			ON q.EcoDisStatusCode = d.EconomicDisadvantageStatusCode
			AND q.HomelessStatusCode = d.HomelessnessStatusCode
			AND q.LepStatusCode = d.EnglishLearnerStatusCode
			AND q.MigrantStatusCode = d.MigrantStatusCode
			AND q.MilitaryConnected = d.MilitaryConnectedStudentIndicatorCode
			AND q.HomelessUnaccompaniedYouthStatusCode = d.HomelessUnaccompaniedYouthStatusCode
			AND q.HomelessNighttimeResidenceCode = d.HomelessPrimaryNighttimeResidenceCode
		LEFT JOIN rds.DimIdeaStatuses idea
			ON q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
			AND q.DisabilityCode = idea.PrimaryDisabilityTypeCode
			AND q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
			AND q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		LEFT JOIN rds.DimDisciplines dis
			ON q.DimDisciplineId = dis.DimDisciplineId
			--ON q.DisciplineMethodCode = dis.DisciplineMethodOfChildrenWithDisabilitiesCode
			--AND q.EducationalServicesCode = dis.EducationalServicesAfterRemovalCode
			--AND q.RemovalReasonCode = dis.IdeaInterimRemovalReasonCode
			--AND q.RemovalTypeCode = dis.IdeaInterimRemovalCode
			--AND q.DisciplineELStatusCode = dis.DisciplineELStatusCode
		LEFT JOIN rds.DimProgramStatuses programStatus
			ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
			AND q.Section504Code = programStatus.Section504StatusCode
			AND q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
			AND q.FosterCareCode = programStatus.FosterCareProgramCode
			AND q.TitleIIIImmigrantParticipation = programStatus.TitleiiiProgramParticipationCode
			AND q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		LEFT JOIN rds.DimFirearms firearms 
			ON firearms.FirearmTypeCode = q.FirearmsCode
		LEFT JOIN rds.DimFirearmDisciplines disciplineFirearms 
			ON q.DimFirearmDisciplineId = disciplineFirearms.DimFirearmDisciplineId
			--ON disciplineFirearms.DisciplineMethodForFirearmsIncidentsCode = q.FirearmsDisciplineCode
			--AND disciplineFirearms.IdeaDisciplineMethodForFirearmsIncidentsCode = q.IDEAFirearmsDisciplineCode
		LEFT JOIN rds.dimcteStatuses cte 
			ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus
		GROUP BY
		q.DimK12StudentId,
		q.DimK12SchoolId,
		q.DimLeaId,
		q.DimSeaId,
		q.DimSchoolYearId,
		ISNULL(a.DimAgeId, -1),
		ISNULL(grade.DimGradeLevelId, -1),
		ISNULL(d.DimK12DemographicId, -1),
		ISNULL(idea.DimIdeaStatusId, -1),
		ISNULL(dis.DimDisciplineId, -1),
		isnull(q.IncidentId, -1),
		ISNULL(programStatus.DimProgramStatusId, -1),
		ISNULL(firearms.DimFirearmsId, -1),
		ISNULL(disciplineFirearms.DimFirearmDisciplineId,-1),
		ISNULL(cte.DimCteStatusId, -1),
		ISNULL(race.DimRaceId,-1),
		ISNULL(cte.DimCteStatusId, -1),
		q.DisciplinaryActionStartDate

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

	IF EXISTS (SELECT  1 FROM tempdb.dbo.sysobjects o WHERE o.xtype IN ('U') AND o.id = object_id(N'tempdb..#demoQuery'))
	DROP TABLE #demoQuery
	
	SET NOCOUNT OFF;

END