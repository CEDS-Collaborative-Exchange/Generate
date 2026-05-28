CREATE PROCEDURE [RDS].[Migrate_StudentCounts]
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
	
	SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	FROM rds.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	-- Get child count date for age calculation
	DECLARE @cutOffMonth INT, @cutOffDay INT, @customFactTypeDate VARCHAR(10)
	set @cutOffMonth = 11
	set @cutOffDay = 1

	--Check if HOMELESS is being processed and grab that date
	IF @factTypeCode = 'Homeless'
	BEGIN
		
		-- Get Custom Homeless Date (if available)
		select @customFactTypeDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'HOMELESSAGE'

		select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
		select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

	END 
	ELSE 
	BEGIN
	
		-- Get Custom Child Count Date (if available)
		select @customFactTypeDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'CHDCTDTE'

		select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
		select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, 2)

	END

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 0

	IF @factTypeCode IN ('childcount','membership','titleIIIELOct','homeless')
	BEGIN
		SET @useCutOffDate = 1
	END
	
	-- Log history

	IF @runAsTest = 0
	BEGIN
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	END

	-- Get Dimension Data
	----------------------------

	create table #queryOutput (
		QueryOutputId INT IDENTITY(1,1) NOT NULL,
		DimK12StudentId INT,
		DimSchoolYearId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,

		AgeCode VARCHAR(50),
		RaceCode VARCHAR(50),

		EcoDisStatusCode VARCHAR(50),
		HomelessStatusCode VARCHAR(50),
		LepStatusCode VARCHAR(50),
		MigrantStatusCode VARCHAR(50),
		SexCode VARCHAR(50),
		MilitaryConnected VARCHAR(50),
		HomelessUnaccompaniedYouthStatusCode VARCHAR(50),
		HomelessNighttimeResidenceCode VARCHAR(50),
		K12DemographicId INT,

		IdeaIndicatorCode varchar(50),
		BasisOfExitCode VARCHAR(50),
		DisabilityCode VARCHAR(50),
		EducEnvCode VARCHAR(50),
		StudentCutOverStartDate Date,
		GradeLevelCode VARCHAR(50),

		CteCode VARCHAR(50),
		ImmigrantTitleIIICode VARCHAR(50),
		Section504Code VARCHAR(50),
		FoodServiceEligibilityCode VARCHAR(50),
		FosterCareCode VARCHAR(50),
		TitleIIIProgramParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50),

		LanguageCode VARCHAR(50),

		ContinuationOfServiceStatus VARCHAR(50),
		MigrantPriorityForServiceCode VARCHAR(50),
		MepServiceTypeCode VARCHAR(50),
		MepFundStatus VARCHAR(50),
		MepEnrollmentTypeCode VARCHAR(50),

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
		InclutypCode VARCHAR(50),
		LepPerkinsStatus VARCHAR(50),

		TitleISchoolStatusCode VARCHAR(50),
		TitleIinstructionalServiceCode VARCHAR(50),		
		Title1SupportServiceCode VARCHAR(50),
		Title1ProgramTypeCode VARCHAR(50),

		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50),

		AbsenteeismCode VARCHAR(50),
		PostSecondaryEnrollmentStatusCode VARCHAR(50),
		AcademicOrVocationalOutcomeCode VARCHAR(50),
		AcademicOrVocationalExitOutcomeCode VARCHAR(50),
		DimK12EnrollmentStatusId INT,
		CohortStatus VARCHAR(10),

		LongTermStatusCode NVARCHAR(50),
		NeglectedProgramTypeCode NVARCHAR(50),

		ExitCode NVARCHAR(50),
		
		NSLPDirectCertificationIndicatorCode nvarchar(50)
	)
	
	DECLARE @studentDateQuery AS rds.K12StudentDateTableType
	
	DECLARE @raceQuery AS table (
		DimK12StudentId INT,
		DimPersonId INT,
		DimCountDateId INT,
		DimLeaId INT,
		DimK12SchoolId INT,
		DimRaceId INT,
		RaceCode VARCHAR(50),
		RaceRecordStartDate datetime,
		RaceRecordEndDate DATETIME
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
		RecordStartDateTime Date,
		RecordEndDateTime Date,
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
		TitleIIIProgramParticipation VARCHAR(50),
		HomelessServicedIndicatorCode VARCHAR(50)
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

	DECLARE @languageQuery AS table (
		DimK12StudentId INT,
		PersonId INT,
		DimCountDateId INT,
		LanguageCode VARCHAR(50)
	)
	
	DECLARE @migrantQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		ContinuationOfServiceStatus VARCHAR(50),
		MigrantPriorityForServiceCode VARCHAR(50),
		MepServiceTypeCode VARCHAR(50),
		MepFundStatus VARCHAR(50),
		MepEnrollmentTypeCode VARCHAR(50)		
	)

	DECLARE @studentenrollmentQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		PostSecondaryEnrollmentStatusCode VARCHAR(50)
	)
	
	DECLARE @studentStatusQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		MobilityStatus12moCode VARCHAR(50),
		MobilityStatus36moCode VARCHAR(50),
		MobilityStatusSYCode VARCHAR(50),
		ReferralStatusCode VARCHAR(50),
		DiplomaCredentialCode VARCHAR(50),
		PlacementType VARCHAR(50),
		PlacementStatus VARCHAR(50),
		NSLPDirectCertificationIndicatorCode VARCHAR(50)
	)
	
	DECLARE @title1StatusQuery AS table (
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

	DECLARE @titleIIIStatusQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT,
		DimCountDateId INT,
		TitleIIIAccountabilityCode VARCHAR(50),
		TitleIIILanguageInstructionCode VARCHAR(50),		
		ProficiencyStatusCode VARCHAR(50),
		FormerEnglishLearnerYearStatus VARCHAR(50)
	)
	
	DECLARE @attendanceQuery AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		DimCountDateId INT,
		AbsenteeismCode VARCHAR(50)
	)

	DECLARE @studentCohortStatus AS table (
		DimK12StudentId INT,
		PersonId integer, 
		CohortYear VARCHAR(10), 
		CohortDescription VARCHAR(30),
		DiplomaOrCredentialAwardDate datetime,
		CohortStatus VARCHAR(10)
	)

	DECLARE @NoDProgramStatus AS table (
		DimK12StudentId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		PersonId INT, 
		DimCountDateId INT,
		LongTermStatusCode VARCHAR(10), 
		NeglectedProgramTypeCode VARCHAR(30)
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

	DECLARE @enrollmentStatusQuery AS table (
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

	DECLARE @factDimensions AS table(
		DimensionTableName NVARCHAR(100)
	)

	INSERT INTO @factDimensions(DimensionTableName)
	SELECT dt.DimensionTableName 
	FROM rds.DimFactType_DimensionTables ftd
	JOIN rds.DimFactTypes ft ON ftd.DimFactTypeId = ft.DimFactTypeId
	JOIN app.DimensionTables dt ON ftd.DimensionTableId = dt.DimensionTableId
	WHERE ft.FactTypeCode = @factTypeCode
		

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
	DELETE FROM #demoQuery
	DELETE FROM @schoolQuery
	DELETE FROM @ideaQuery
	DELETE FROM @programStatusQuery
	DELETE FROM @gradelevelQuery
	DELETE FROM @languageQuery
	DELETE FROM @studentenrollmentQuery
	DELETE FROM @studentStatusQuery
	DELETE FROM @title1StatusQuery
	DELETE FROM @titleIIIStatusQuery
	DELETE FROM @attendanceQuery
	DELETE FROM @studentCohortStatus
	DELETE FROM @NoDProgramStatus
	DELETE FROM @cteStatusQuery
	DELETE FROM @enrollmentStatusQuery

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

	IF @factTypeCode = 'hsgradenroll'
	BEGIN

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
	EXEC rds.Migrate_K12StudentOrganizations @studentDateQuery, @dataCollectionId, @useCutOffDate

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
			SELECT * FROM @raceQuery
		END

	END


	-- Migrate_DimK12Demographics

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimK12Demographics')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Demographics Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
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
		exec rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate, @schoolQuery, @dataCollectionId

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
			TitleIIIProgramParticipation,
			HomelessServicedIndicatorCode
		)
		exec rds.Migrate_DimProgramStatuses @studentDateQuery, @useCutOffDate, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'programStatusQuery'
			SELECT * FROM @programStatusQuery
		END

	END

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

	--Migrate Language

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimLanguages')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Language Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		INSERT INTO @languageQuery
		(
			DimK12StudentId,
			PersonId,
			DimCountDateId,
			LanguageCode
		)
		exec rds.[Migrate_DimLanguage] @studentDateQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'languageQuery'
			SELECT * FROM @languageQuery
		END

	END

	-- Migrate_DimMigrant

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimMigrants')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Migrant Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @migrantQuery
		(
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
			PersonId,
			DimCountDateId,
			ContinuationOfServiceStatus ,
			MigrantPriorityForServiceCode ,
			MepServiceTypeCode ,
			MepFundStatus,
			MepEnrollmentTypeCode 		
		)
		exec rds.[Migrate_DimMigrant] @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'migrantQuery'
			SELECT * FROM @migrantQuery
		END

	END

	---- Migrate_DimEnrollments

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimEnrollment')
	--BEGIN

	--	IF @runAsTest = 0
	--	BEGIN
	--		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	--			VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
	--	END
	
	--	INSERT INTO @studentenrollmentQuery
	--	(
	--		DimK12StudentId,
	--		DimK12SchoolId,
	--		DimLeaId,
	--		DimSeaId,
	--		PersonId,
	--		DimCountDateId,
	--		PostSecondaryEnrollmentStatusCode
	--	)
	--	exec rds.[Migrate_DimEnrollments] @studentDateQuery

	--	IF @runAsTest = 1
	--	BEGIN
	--		print 'studentenrollmentQuery'
	--		SELECT * FROM @studentenrollmentQuery
	--	END

	--END
	
	
	-- Migrate_DimK12Studentstatuses

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimK12Studentstatuses')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Student Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @studentStatusQuery
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
			SELECT * FROM @studentStatusQuery
		END

	END

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimTitleIStatuses')
	BEGIN

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
			SELECT * FROM @title1StatusQuery
		END

	END

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimTitleIIIStatuses')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Title III Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

	
		INSERT INTO @titleIIIStatusQuery
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
			SELECT * FROM @titleIIIStatusQuery
		END

	END

	--Migrate Attendance

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimAttendance')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Attendance Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END
	
		INSERT INTO @attendanceQuery
		(
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			DimSeaId,
			DimCountDateId,
			AbsenteeismCode
		)
		exec rds.[Migrate_DimAttendance] @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'attendanceQuery'
			SELECT * FROM @attendanceQuery
		END

	END

	-- migrate Cohort Statuses

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimCohortStatuses')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Student Cohort Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @studentCohortStatus
		(
			DimK12StudentId,
			PersonId,
			CohortYear,
			CohortDescription,
			DiplomaOrCredentialAwardDate,
			CohortStatus
		)
		exec RDS.Migrate_DimCohortStatuses @studentDateQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			print 'studentCohortStatus'
			SELECT * FROM @studentCohortStatus
		END

	END

	-- migrate N OR D Statuses

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimNorDProgramStatuses')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating N OR D Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
		END

		INSERT INTO @NoDProgramStatus
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
			SELECT * FROM @NoDProgramStatus
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

	IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimK12EnrollmentStatuses')
	BEGIN

		IF @runAsTest = 0
		BEGIN
			INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Status Dimension for (' + @factTypeCode + ') -  ' +  @submissionYear)
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

		IF @runAsTest = 1
		BEGIN
			print 'enrollmentStatusQuery'
			SELECT * FROM @enrollmentStatusQuery
		END

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
		AgeCode,
		RaceCode,

		EcoDisStatusCode,
		HomelessStatusCode,
		LepStatusCode,
		MigrantStatusCode,
		SexCode,
		MilitaryConnected,
		HomelessUnaccompaniedYouthStatusCode,
		HomelessNighttimeResidenceCode,
		K12DemographicId,

		IdeaIndicatorCode,
		BasisOfExitCode,
		DisabilityCode,
		EducEnvCode,
		StudentCutOverStartDate,
		--TitleIStatusCode,
		GradeLevelCode,

		CteCode,
		ImmigrantTitleIIICode,
		Section504Code,
		FoodServiceEligibilityCode,
		FosterCareCode,
		TitleIIIProgramParticipation,
		HomelessServicedIndicatorCode,

		LanguageCode, 

		ContinuationOfServiceStatus ,
		MigrantPriorityForServiceCode ,
		MepServiceTypeCode ,
		MepFundStatus,
		MepEnrollmentTypeCode,

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
		RepresentationStatus,
		InclutypCode,
		LepPerkinsStatus,

		TitleISchoolStatusCode,
		TitleIinstructionalServiceCode,		
		Title1SupportServiceCode ,
		Title1ProgramTypeCode,

		TitleIIIAccountabilityCode ,
		TitleIIILanguageInstructionCode ,		
		ProficiencyStatusCode ,
		FormerEnglishLearnerYearStatus,

		AbsenteeismCode,
		PostSecondaryEnrollmentStatusCode,
		AcademicOrVocationalOutcomeCode,
		AcademicOrVocationalExitOutcomeCode,
		DimK12EnrollmentStatusId,
		CohortStatus,

		LongTermStatusCode,
		NeglectedProgramTypeCode,
		
		ExitCode,

		NSLPDirectCertificationIndicatorCode
	)
	SELECT 
		s.DimK12StudentId,
		s.DimSchoolYearId,
		ISNULL(sch.DimK12SchoolId, -1),
		ISNULL(sch.DimLeaId, -1),
		ISNULL(sch.DimSeaId, -1),
		ISNULL(CASE @useCutOffDate 
			WHEN 1 THEN CAST(rds.Get_Age(st.Birthdate, DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN @submissionYear - 1 ELSE @submissionYear END, @cutOffMonth, @cutOffDay)) AS VARCHAR(50))
			WHEN 0 THEN CAST(rds.Get_Age(st.Birthdate, s.SessionBeginDate) AS VARCHAR(50))
		END, 'MISSING') AS AgeCode,
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
		ISNULL(demo.DimK12DemographicId, -1),

		ISNULL(idea.IdeaIndicatorCode, 'MISSING'),
		ISNULL(idea.BasisOfExitCode, 'MISSING'),
		ISNULL(idea.DisabilityCode, 'MISSING'),
		ISNULL(idea.EducEnvCode, 'MISSING'),
		idea.SpecialEducationServicesExitDate,

		ISNULL(grade.EntryGradeLevelCode,'MISSING'),
		ISNULL(cteStatus.CteCode,'MISSING'),
		ISNULL(programStatus.ImmigrantTitleIIICode,'MISSING'),
		ISNULL(programStatus.Section504Code,'MISSING'),
		ISNULL(programStatus.FoodServiceEligibilityCode,'MISSING'),
		ISNULL(programStatus.FosterCareCode,'MISSING'),
		ISNULL(programStatus.TitleIIIProgramParticipation, 'MISSING'),
		ISNULL(programStatus.HomelessServicedIndicatorCode, 'MISSING'),

		ISNULL(lang.LanguageCode, 'MISSING'),

		ISNULL(migrant.ContinuationOfServiceStatus, 'MISSING'),
		ISNULL(migrant.MigrantPriorityForServiceCode ,'MISSING'),
		ISNULL(migrant.MepServiceTypeCode ,'MISSING'),
		ISNULL(migrant.MepFundStatus ,'MISSING'),
		ISNULL(migrant.MepEnrollmentTypeCode ,'MISSING'),

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
		ISNULL(cteStatus.RepresentationStatus, 'MISSING'),
		ISNULL(cteStatus.InclutypCode, 'MISSING'),
		ISNULL(cteStatus.LepPerkinsStatus, 'MISSING'),

		ISNULL(title1.TitleISchoolStatusCode, 'MISSING'),
		ISNULL(title1.TitleIinstructionalServiceCode, 'MISSING'),
		ISNULL(title1.Title1SupportServiceCode , 'MISSING'),
		ISNULL(title1.Title1ProgramTypeCode, 'MISSING'),

		ISNULL(TitleIIIAccountabilityCode , 'MISSING'),
		ISNULL(TitleIIILanguageInstructionCode , 'MISSING'),	
		ISNULL(ProficiencyStatusCode , 'MISSING'),
		ISNULL(FormerEnglishLearnerYearStatus, 'MISSING'),

		ISNULL(att.AbsenteeismCode,'MISSING'),
		ISNULL(enrollmentStatus.PostSecondaryEnrollmentStatusCode,'MISSING'),
		ISNULL(enrollmentStatus.AcademicOrVocationalOutcomeCode,'MISSING'),
		ISNULL(enrollmentStatus.AcademicOrVocationalExitOutcomeCode,'MISSING'),
		ISNULL(enrollmentStatus.DimK12EnrollmentStatusId,-1),
		ISNULL(cohortstatus.CohortStatus, 'MISSING'),
		
		ISNULL(noDProgramStatus.LongTermStatusCode , 'MISSING'),
		ISNULL(noDProgramStatus.NeglectedProgramTypeCode, 'MISSING'),
		ISNULL(enrollmentStatus.ExitCode, 'MISSING'),
		isnull(studentStatus.NSLPDirectCertificationIndicatorCode, 'MISSING')

	FROM @studentDateQuery s
	LEFT JOIN rds.DimK12Students st 
		on s.DimK12StudentId = st.DimK12StudentId
	LEFT JOIN @schoolQuery sch 
		ON s.DimK12StudentId = sch.DimK12StudentId 
		AND s.DimCountDateId = sch.DimCountDateId
	LEFT JOIN #demoQuery demo 
		ON s.DimK12StudentId = demo.DimK12StudentId 
		AND s.DimCountDateId = demo.DimDateId
		AND ((@useCutOffDate = 0
				AND s.SessionEndDate BETWEEN demo.PersonStartDate AND ISNULL(demo.PersonEndDate, GETDATE()))
			OR (@useCutOffDate = 1
				AND s.CountDate BETWEEN demo.PersonStartDate AND ISNULL(demo.PersonEndDate, GETDATE()))
			)
	LEFT JOIN @raceQuery race 
		ON s.DimK12StudentId = race.DimK12StudentId 
		AND s.PersonId = race.DimPersonId
		AND s.DimCountDateId = race.DimCountDateId
	LEFT JOIN @languageQuery lang 
		ON s.DimK12StudentId = lang.DimK12StudentId 
		AND s.DimCountDateId = lang.DimCountDateId
	LEFT JOIN @studentCohortStatus cohortstatus 
		ON cohortstatus.DimK12StudentId = s.DimK12StudentId
	LEFT JOIN @gradelevelQuery grade 
		ON s.DimK12StudentId = grade.DimK12StudentId 
		AND s.DimCountDateId = grade.DimCountDateId 
		AND sch.DimK12SchoolId = grade.DimK12SchoolId 
		AND sch.DimLeaId = grade.DimLeaId
	LEFT JOIN @ideaQuery idea 
		ON s.DimK12StudentId = idea.DimK12StudentId 
		AND s.DimCountDateId = idea.DimCountDateId 
		AND sch.DimK12SchoolId = idea.DimK12SchoolId 
		AND sch.DimLeaId = idea.DimLeaId
		AND ((@useCutOffDate = 0
				AND s.SessionEndDate BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE()))
			OR (@useCutOffDate = 1
				AND s.CountDate BETWEEN idea.RecordStartDateTime AND ISNULL(idea.RecordEndDateTime, GETDATE()))
			)
	LEFT JOIN @programStatusQuery programStatus 
		ON s.DimK12StudentId = programStatus.DimK12StudentId 
		AND s.DimCountDateId = programStatus.DimCountDateId 
		AND sch.DimK12SchoolId = programStatus.DimK12SchoolId 
		AND sch.DimLeaId = programStatus.DimLeaId
	LEFT JOIN @migrantQuery migrant 
		ON s.DimK12StudentId = migrant.DimK12StudentId 
		AND s.DimCountDateId = migrant.DimCountDateId 
		AND sch.DimK12SchoolId = migrant.DimK12SchoolId 
		AND sch.DimLeaId = migrant.DimLeaId
	LEFT JOIN @studentStatusQuery studentStatus 
		ON s.DimK12StudentId = studentStatus.DimK12StudentId 
		AND s.DimCountDateId = studentStatus.DimCountDateId
		AND sch.DimK12SchoolId = studentStatus.DimK12SchoolId 
		AND sch.DimLeaId = studentStatus.DimLeaId
	LEFT JOIN @title1StatusQuery title1  
		ON s.DimK12StudentId = title1.DimK12StudentId 
		AND s.DimCountDateId = title1.DimCountDateId 
		AND sch.DimK12SchoolId = title1.DimK12SchoolId 
		AND sch.DimLeaId = title1.DimLeaId
	LEFT JOIN @titleIIIStatusQuery titleIII  
		ON s.DimK12StudentId = titleIII.DimK12StudentId 
		AND s.DimCountDateId = titleIII.DimCountDateId 
		AND sch.DimK12SchoolId = titleIII.DimK12SchoolId 
		AND sch.DimLeaId = titleIII.DimLeaId
	LEFT JOIN @attendanceQuery att 
		ON s.DimK12StudentId = att.DimK12StudentId 
		AND s.DimCountDateId = att.DimCountDateId 
		AND sch.DimK12SchoolId = att.DimK12SchoolId 
		AND sch.DimLeaId = att.DimLeaId
	LEFT JOIN @studentenrollmentQuery studentStatus2 
		ON s.DimK12StudentId = studentStatus2.DimK12StudentId 
		AND s.DimCountDateId = studentStatus2.DimCountDateId 
		AND sch.DimK12SchoolId = studentStatus2.DimK12SchoolId 
		AND sch.DimLeaId = studentStatus2.DimLeaId
	LEFT JOIN @NoDProgramStatus noDProgramStatus  
		ON s.DimK12StudentId = noDProgramStatus.DimK12StudentId 
		AND s.DimCountDateId = noDProgramStatus.DimCountDateId 
		AND sch.DimK12SchoolId = noDProgramStatus.DimK12SchoolId 
		AND sch.DimLeaId = noDProgramStatus.DimLeaId
	LEFT JOIN @cteStatusQuery cteStatus  
		ON s.DimK12StudentId = cteStatus.DimK12StudentId 
		AND s.DimCountDateId = cteStatus.DimCountDateId 
		AND sch.DimK12SchoolId = cteStatus.DimK12SchoolId 
		AND sch.DimLeaId = cteStatus.DimLeaId
	LEFT JOIN @enrollmentStatusQuery enrollmentStatus  
		ON s.DimK12StudentId = enrollmentStatus.DimK12StudentId 
		AND s.DimCountDateId = enrollmentStatus.DimCountDateId 
		AND sch.DimK12SchoolId = enrollmentStatus.DimK12SchoolId 
		AND sch.DimLeaId = enrollmentStatus.DimLeaId


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
			NorDProgramStatusId,
			CteStatusId,
			K12EnrollmentStatusId,
			StudentCutOverStartDate,
			RaceId
		)
			SELECT DISTINCT
			@factTypeId AS DimFactTypeId,
			q.DimK12StudentId,
			q.DimK12SchoolId,
			q.DimLeaId,
			q.DimSeaId,
			q.DimSchoolYearId,
			ISNULL(q.K12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(a.DimAgeId, -1) AS DimAgeId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			1 AS StudentCount,
			
			ISNULL(lang.DimLanguageId, -1) AS DimLanguageId,
			ISNULL(migrant.DimMigrantId, -1) AS	DimMigrantId,
			ISNULL(studentStatus.DimK12StudentStatusId, -1) AS DimStudentStatusId,
			ISNULL(titleI.DimTitleIStatusId, -1) AS DimTitleIStatusId,
			ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId,
			ISNULL(att.DimAttendanceId, -1) AS DimAttendanceId,
			ISNULL(cohortstatuses.DimCohortStatusId, -1) AS DimCohortStatusId,
			ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1) AS DimNorDProgramStatusId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
			ISNULL(q.DimK12EnrollmentStatusId, -1) AS DimEnrollmentStatusId,
			q.StudentCutOverStartDate,
			ISNULL(race.DimRaceId,-1) AS DimRaceId
		FROM #queryOutput q
		LEFT OUTER JOIN rds.DimGradeLevels grade
		    ON q.GradeLevelCode = grade.GradeLevelCode
		LEFT OUTER JOIN rds.DimAges a   
			ON q.AgeCode = a.AgeCode
		LEFT OUTER JOIN rds.DimRaces race
		    ON q.RaceCode = race.RaceCode 
		     
		LEFT OUTER JOIN rds.DimIdeaStatuses idea
		    ON q.DisabilityCode = idea.PrimaryDisabilityTypeCode
		    and q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
		    and q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
		    and q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		
		LEFT OUTER JOIN rds.DimProgramStatuses programStatus
		    ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
		    and q.Section504Code = programStatus.Section504StatusCode
		    and q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
		    and q.FosterCareCode = programStatus.FosterCareProgramCode
		    and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		    and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		LEFT OUTER JOIN rds.DimLanguages lang
			ON lang.Iso6392LanguageCode = q.LanguageCode
		LEFT OUTER JOIN rds.DimMigrants migrant 
			ON migrant.ContinuationOfServicesReasonCode = q.ContinuationOfServiceStatus
			AND migrant.ConsolidatedMepFundsStatusCode =q.MepFundStatus
			AND migrant.MepServicesTypeCode = q.MepServiceTypeCode
			AND migrant.MigrantPrioritizedForServicesCode = q.MigrantPriorityForServiceCode
			AND migrant.MepEnrollmentTypeCode = q.MepEnrollmentTypeCode
		
		LEFT OUTER JOIN rds.DimK12StudentStatuses studentStatus
			ON studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
			AND studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
			AND studentStatus.ReferralStatusCode = q.ReferralStatusCode
			AND studentStatus.HighSchoolDiplomaTypeCode = q.DiplomaCredentialCode
			AND studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
			AND studentStatus.PlacementTypeCode = q.PlacementType
			AND studentStatus.PlacementStatusCode = q.PlacementStatus
			AND studentStatus.NSLPDirectCertificationIndicatorCode = q.NSLPDirectCertificationIndicatorCode
		
		LEFT OUTER JOIN rds.DimTitleIStatuses titleI
			ON titleI.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND titleI.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND titleI.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND titleI.TitleISupportServicesCode = q.Title1SupportServiceCode
		
		LEFT OUTER JOIN rds.DimTitleiiiStatuses title3
			ON title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode      
			AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
			AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
			AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		
		LEFT OUTER JOIN rds.DimAttendance att
			ON att.AbsenteeismCode = q.AbsenteeismCode
		
		LEFT JOIN rds.DimCohortStatuses cohortstatuses ON cohortstatuses.CohortStatusCode=q.CohortStatus
		
		LEFT OUTER JOIN rds.DimNorDProgramStatuses NorDProgramStatuses
			ON NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
			AND NorDProgramStatuses.NeglectedOrDelinquentProgramTypeCode = q.NeglectedProgramTypeCode
			
		LEFT OUTER JOIN rds.dimcteStatuses cte ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus

		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @submissionYear)

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
			ISNULL(q.K12DemographicId, -1) AS DimDemographicId,
			ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,
			ISNULL(a.DimAgeId, -1) AS DimAgeId,
			ISNULL(grade.DimGradeLevelId, -1) AS DimGradeLevelId,
			ISNULL(programStatus.DimProgramStatusId, -1) AS DimProgramStatusId,
			1 AS StudentCount,
			
			ISNULL(lang.DimLanguageId, -1) AS DimLanguageId,
			ISNULL(migrant.DimMigrantId, -1) AS	DimMigrantId,
			ISNULL(studentStatus.DimK12StudentStatusId, -1) AS DimStudentStatusId,
			ISNULL(titleI.DimTitleIStatusId, -1) AS DimTitleIStatusId,
			ISNULL(title3.DimTitleiiiStatusId, -1) AS DimTitleiiiStatusId,
			ISNULL(att.DimAttendanceId, -1) AS DimAttendanceId,
			ISNULL(cohortstatuses.DimCohortStatusId, -1) AS DimCohortStatusId,
			ISNULL(NorDProgramStatuses.DimNorDProgramStatusId, -1) AS DimNorDProgramStatusId,
			ISNULL(cte.DimCteStatusId, -1) AS DimCteStatusId,
			ISNULL(q.DimK12EnrollmentStatusId, -1) AS DimEnrollmentStatusId,
			q.StudentCutOverStartDate,
			ISNULL(race.DimRaceId,-1) AS DimRaceId
		FROM #queryOutput q
		LEFT OUTER JOIN rds.DimGradeLevels grade
		    ON q.GradeLevelCode = grade.GradeLevelCode
		LEFT OUTER JOIN rds.DimAges a   
			ON q.AgeCode = a.AgeCode
		LEFT OUTER JOIN rds.DimRaces race
		    ON q.RaceCode = race.RaceCode 
		     
		LEFT OUTER JOIN rds.DimIdeaStatuses idea
		    ON q.DisabilityCode = idea.PrimaryDisabilityTypeCode
		    and q.EducEnvCode = idea.IdeaEducationalEnvironmentCode
		    and q.BasisOfExitCode = idea.SpecialEducationExitReasonCode
		    and q.IDEAIndicatorCode = idea.IDEAIndicatorCode
		
		LEFT OUTER JOIN rds.DimProgramStatuses programStatus
		    ON q.ImmigrantTitleIIICode = programStatus.TitleIIIImmigrantParticipationStatusCode
		    and q.Section504Code = programStatus.Section504StatusCode
		    and q.FoodServiceEligibilityCode = programStatus.EligibilityStatusForSchoolFoodServiceProgramCode
		    and q.FosterCareCode = programStatus.FosterCareProgramCode
		    and q.TitleIIIProgramParticipation = programStatus.TitleiiiProgramParticipationCode
		    and q.HomelessServicedIndicatorCode = programStatus.HomelessServicedIndicatorCode
		
		LEFT OUTER JOIN rds.DimLanguages lang
			ON lang.Iso6392LanguageCode = q.LanguageCode
		LEFT OUTER JOIN rds.DimMigrants migrant 
			ON migrant.ContinuationOfServicesReasonCode = q.ContinuationOfServiceStatus
			AND migrant.ConsolidatedMepFundsStatusCode =q.MepFundStatus
			AND migrant.MepServicesTypeCode = q.MepServiceTypeCode
			AND migrant.MigrantPrioritizedForServicesCode = q.MigrantPriorityForServiceCode
			AND migrant.MepEnrollmentTypeCode = q.MepEnrollmentTypeCode
		
		LEFT OUTER JOIN rds.DimK12StudentStatuses studentStatus
			ON studentStatus.MobilityStatus12moCode = q.MobilityStatus12moCode
			AND studentStatus.MobilityStatusSYCode = q.MobilityStatusSYCode
			AND studentStatus.ReferralStatusCode = q.ReferralStatusCode
			AND studentStatus.HighSchoolDiplomaTypeCode = q.DiplomaCredentialCode
			AND studentStatus.MobilityStatus36moCode = q.MobilityStatus36moCode
			AND studentStatus.PlacementTypeCode = q.PlacementType
			AND studentStatus.PlacementStatusCode = q.PlacementStatus
			AND studentStatus.NSLPDirectCertificationIndicatorCode = q.NSLPDirectCertificationIndicatorCode
		
		LEFT OUTER JOIN rds.DimTitleIStatuses titleI
			ON titleI.TitleIInstructionalServicesCode = q.TitleIinstructionalServiceCode
			AND titleI.TitleIProgramTypeCode = q.Title1ProgramTypeCode
			AND titleI.TitleISchoolStatusCode = q.TitleISchoolStatusCode
			AND titleI.TitleISupportServicesCode = q.Title1SupportServiceCode
		
		LEFT OUTER JOIN rds.DimTitleiiiStatuses title3
			ON title3.TitleiiiLanguageInstructionCode = q.TitleIIILanguageInstructionCode      
			AND title3.TitleiiiAccountabilityProgressStatusCode = q.TitleIIIAccountabilityCode
			AND title3.FormerEnglishLearnerYearStatusCode = q.FormerEnglishLearnerYearStatus
			AND title3.ProficiencyStatusCode = q.ProficiencyStatusCode
		
		LEFT OUTER JOIN rds.DimAttendance att
			ON att.AbsenteeismCode = q.AbsenteeismCode
		
		LEFT JOIN rds.DimCohortStatuses cohortstatuses ON cohortstatuses.CohortStatusCode=q.CohortStatus
		
		LEFT OUTER JOIN rds.DimNorDProgramStatuses NorDProgramStatuses
			ON NorDProgramStatuses.LongTermStatusCode = q.LongTermStatusCode
			AND NorDProgramStatuses.NeglectedOrDelinquentProgramTypeCode = q.NeglectedProgramTypeCode
			
		LEFT OUTER JOIN rds.dimcteStatuses cte ON q.CteCode = cte.CteProgramCode
			AND cte.CteAeDisplacedHomemakerIndicatorCode = q.DisplacedHomemaker
			AND cte.SingleParentOrSinglePregnantWomanCode = q.SingleParent
			AND cte.CteNontraditionalGenderStatusCode = q.CteNonTraditionalEnrollee
			AND cte.RepresentationStatusCode = q.RepresentationStatus
			AND cte.CteGraduationRateInclusionCode = q.InclutypCode
			AND cte.LepPerkinsStatusCode = q.LepPerkinsStatus

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

	SET NOCOUNT OFF;
END