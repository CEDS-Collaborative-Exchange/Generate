CREATE PROCEDURE [RDS].[Migrate_K12StudentEnrollments]
	@dataCollectionName AS NVARCHAR(50) = NULL,
	@loadAllForDataCollection AS BIT,
	@runAsTest AS BIT
AS
BEGIN

	DECLARE @dataCollectionId AS INT
	
	SELECT @dataCollectionId = DataCollectionId 
	FROM DataCollection
	WHERE DataCollectionName = @dataCollectionName

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 1

	DECLARE @dataMigrationTypeId INT, @migrationType VARCHAR(3)
	SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	FROM RDS.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	-- Log history
	--IF @runAsTest = 0
	--BEGIN
	--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	--END


	-- Get Dimension Data
	----------------------------

	DECLARE @studentDateQuery AS rds.K12StudentDateTableType

	CREATE TABLE #responsibleOrganizationTypeQuery (
		  DimK12StudentId							INT 
		, DimIeuId									INT
		, DimLeaId									INT
		, DimK12SchoolId							INT
		, DimDateId									INT
		, DimResponsibleOrganizationTypeId			INT      
		, ResponsibleDistrcitTypeCode				NVARCHAR(50)
		, ResponsibleSchoolTypeCode					NVARCHAR(50)
	)
	CREATE NONCLUSTERED INDEX IX_Org ON #responsibleOrganizationTypeQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)
		
	CREATE TABLE #raceQuery (
		  DimK12StudentId							INT
		, DimCountDateId							INT
		, DimLeaId									INT
		, DimK12SchoolId							INT
		, DimRaceId									INT
		, RaceCode									NVARCHAR(50)
		, RaceRecordStartDate						DATETIME
		, RaceRecordEndDate							DATETIME
	)
	CREATE NONCLUSTERED INDEX IX_Race ON #raceQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)
	
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

	
	DECLARE @schoolQuery AS rds.K12StudentOrganizationTableType

	CREATE TABLE #k12EnrollmentStatusQuery (
		  DimK12StudentId							INT 
		, DimK12SchoolId							INT
		, DimLeaId									INT
		, PersonId									INT
		, DimCountDateId							INT
		, ExitOrWithdrawalCode						VARCHAR(50)
		, EnrollmentStatusCode						VARCHAR(50)
		, PostSecondaryEnrollmentStatusCode			VARCHAR(50)
		, EntryTypeCode								VARCHAR(50)
		, DimK12EnrollmentStatusId					INT
	)
	CREATE NONCLUSTERED INDEX IX_Enroll ON #k12EnrollmentStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)
	
	CREATE TABLE #gradelevelQuery (
		  DimK12StudentId							INT 
		, DimDateId									INT
		, DimLeaId									INT
		, PersonId									INT
		, DimK12SchoolId							INT
		, EntryGradeLevelCode						NVARCHAR(50)
		, ExitGradeLevelCode						NVARCHAR(50)
		, DimEntryGradeLevelId						INT
		, DimExitGradeLevelId						INT
		)
	CREATE NONCLUSTERED INDEX IX_Grade ON #gradelevelQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)
	
	CREATE TABLE #ideaQuery (
		  DimK12StudentId							INT
		, DimK12SchoolId							INT
		, DimLeaId									INT
		, DimIeuId									INT
		, PersonId									INT
		, DimCountDateId							INT
		, IDEAIndicator								NVARCHAR(50)
		, DisabilityCode							NVARCHAR(50)
		, EducEnvCode								NVARCHAR(50)
		, BasisOfExitCode							NVARCHAR(50)
		, SpecialEducationServicesExitDate			DATE
		, DimIdeaStatusId							INT
		, SpecialEducationServicesExitDateId			INT
	)
	CREATE NONCLUSTERED INDEX IX_Idea ON #ideaQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	CREATE TABLE #enrollmentStatusQuery (
		  DimK12StudentId							INT 
		, DimK12SchoolId							INT
		, DimLeaId									INT
		, PersonId									INT
		, DimCountDateId							INT
		, ExitOrWithdrawalCode						NVARCHAR(50)
		, EnrollmentStatusCode						NVARCHAR(50)
		, PostSecondaryEnrollmentStatusCode			NVARCHAR(50)
		, EntryTypeCode								NVARCHAR(50)
		, DimEnrollmentStatusId						INT
	)
	CREATE NONCLUSTERED INDEX IX_EnrollStatus ON #enrollmentStatusQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)


	CREATE TABLE #enrollmentDatesQuery (	
		  DimK12StudentId							INT 
		, DimK12SchoolId							INT
		, DimLeaId									INT
		, PersonId									INT
		, DimDateId									INT
		, DimEntryDateId							INT
		, DimExitDateId								INT
		, DimProjectedGraduationDateId				INT
	)
	CREATE NONCLUSTERED INDEX IX_EnrollDates ON #enrollmentDatesQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)

	--DECLARE @factDimensions AS TABLE(
	--	DimensionTableName NVARCHAR(100)
	--)	

	--INSERT INTO @factDimensions(DimensionTableName)
	--SELECT dt.DimensionTableName 
	--FROM rds.DimFactType_DimensionTables ftd
	--JOIN rds.DimFactTypes ft ON ftd.DimFactTypeId = ft.DimFactTypeId
	--JOIN Staging.DimensionTables dt ON ftd.DimensionTableId = dt.DimensionTableId
	--WHERE ft.FactTypeCode = @factTypeCode
		

	--BEGIN TRY
	
		DECLARE @schoolYear AS NVARCHAR(50), @dimSchoolYearId AS INT
		DECLARE selectedYears_cursor CURSOR FOR 
		SELECT DISTINCT sy.SchoolYear, sy.DimSchoolYearId
		FROM rds.DimSchoolYears sy
		JOIN rds.DimSchoolYearDataMigrationTypes dm 
			ON dm.DimSchoolYearId = sy.DimSchoolYearId
		JOIN rds.DimDataMigrationTypes dmt
			ON dm.DataMigrationTypeId = dmt.DimDataMigrationTypeId
		WHERE sy.DimSchoolYearId <> -1 
			AND dm.IsSelected=1 
			AND dmt.DataMigrationTypeCode = @migrationType

		OPEN selectedYears_cursor
		FETCH NEXT FROM selectedYears_cursor INTO @schoolYear, @dimSchoolYearId
		WHILE @@FETCH_STATUS = 0
		BEGIN

	--IF @runAsTest = 0
	--BEGIN
	--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @schoolYear)
	--END
	

	DELETE FROM @studentDateQuery
	DELETE FROM #raceQuery
	DELETE FROM #demoQuery
	DELETE FROM @schoolQuery
	DELETE FROM #ideaQuery
	DELETE FROM #gradeLevelQuery
	DELETE FROM #k12EnrollmentStatusQuery
	DELETE FROM #enrollmentStatusQuery


	-- Migate_DimDates_Students

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
	EXEC rds.Migrate_DimSchoolYears_K12Students 'submission', @migrationType, @dimSchoolYearId, 0, @dataCollectionId, @loadAllForDataCollection

	IF @runAsTest = 1
	BEGIN
		PRINT 'studentDateQuery'
		SELECT * FROM @studentDateQuery
	END

	-- Get_K12StudentOrganizations

	--IF @runAsTest = 0
	--BEGIN
	--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear)
	--END
	   	
	INSERT INTO @schoolQuery
	(
		  DimK12StudentId
		, PersonId
		, DimCountDateId
		, DimSeaId 
		, DimIeuId 
		, DimLeaID
		, DimK12SchoolId
		, LeaOrganizationId
		, IeuOrganizationId
		, K12SchoolOrganizationId
		, LeaOrganizationPersonRoleId 
		, K12SchoolOrganizationPersonRoleId 
		, LeaEntryDate 
		, LeaExitDate 
		, K12SchoolEntryDate 
		, K12SchoolExitDate 
	)
	EXEC rds.Migrate_K12StudentOrganizations @studentDateQuery, @dataCollectionId, 0, @loadAllForDataCollection

	IF @runAsTest = 1
	BEGIN
		PRINT 'schoolQuery'
		SELECT * FROM @schoolQuery
	END

	-- Migrate_DimRaces

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimRaces')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Race Dimension for (' + @factTypeCode + ') - ' +  @schoolYear)
		--END
	
		INSERT INTO #raceQuery
		(
			  DimK12StudentId
			, DimCountDateId
			, DimLeaId
			, DimK12SchoolId
			, DimRaceId
			, RaceCode
			, RaceRecordStartDate
			, RaceRecordEndDate
		)
		EXEC rds.Migrate_DimK12Races  'reporting', @studentDateQuery, @schoolQuery, @dataCollectionId, 0, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'raceQuery'
			SELECT * FROM #raceQuery
		END

	--END
	
	-- Migrate_DimK12Demographics

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimDemographics')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Demographics Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END
	
		
		INSERT INTO #demoQuery
		(
			    DimK12StudentId
              , DimDateId
			  , DimK12SchoolId
              , DimLeaId
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
    EXEC rds.Migrate_DimK12Demographics @studentDateQuery,@schoolQuery,@useCutOffDate, @dataCollectionId, @loadAllForDataCollection
 


		IF @runAsTest = 1
		BEGIN
			PRINT 'demoQuery'
			SELECT * FROM #demoQuery
		END

	--END


	-- Migrate_DimIdeaStatuses

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimIdeaStatuses')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating IDEA Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END

		INSERT INTO #ideaQuery
		(
			  DimK12StudentId
			, DimK12SchoolId
			, DimLeaId
			, DimIeuId
			, PersonId
			, DimCountDateId
			, IDEAIndicator
			, DisabilityCode
			, EducEnvCode
			, BasisOfExitCode
			, SpecialEducationServicesExitDate
			, DimIdeaStatusId
			, SpecialEducationServicesExitDateId
		)
		EXEC rds.Migrate_DimIdeaStatuses @studentDateQuery, 'submission', @useCutOffDate, @schoolQuery, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'ideaQuery'
			SELECT * FROM #ideaQuery
		END

	--END
	
	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimGradeLevels')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Grade Level Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END
	
		INSERT INTO #gradelevelQuery
		(
			DimK12StudentId,
			DimK12SchoolId,
			DimLeaId,
			PersonId,
			DimDateId,
			EntryGradeLevelCode,
			ExitGradeLevelCode,
			DimEntryGradeLevelId,
			DimExitGradeLevelId
		)
		EXEC rds.Migrate_DimGradeLevels @studentDateQuery, @schoolQuery, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'gradelevelQuery'
			SELECT * FROM #gradelevelQuery
		END

	--END
	
	---- Migrate_DimEnrollments

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimEnrollment')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END
	
		INSERT INTO #k12EnrollmentStatusQuery
		(
			  DimK12StudentId
			, DimK12SchoolId
			, DimLeaId
			, PersonId
			, DimCountDateId	
			, ExitOrWithdrawalCode
			, EnrollmentStatusCode
			, PostSecondaryEnrollmentStatusCode
			, EntryTypeCode
			, DimK12EnrollmentStatusId
		)
		EXEC rds.[Migrate_DimK12EnrollmentStatuses] @studentDateQuery, @schoolQuery, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'studentEnrollmentQuery'
			SELECT * FROM #k12EnrollmentStatusQuery
		END

	--END
	
	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimEnrollmentStatuses')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Status Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END

	--END

		---- Migrate_DimK12StudentEnrollmentDates

	--IF EXISTS(SELECT 1 FROM @factDimensions WHERE DimensionTableName = 'DimEnrollment')
	--BEGIN

		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--	VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END
	
		INSERT INTO #enrollmentDatesQuery
		(
			  DimK12StudentId
			, DimK12SchoolId
			, DimLeaId
			, PersonId
			, DimDateId	
			, DimEntryDateId
			, DimExitDateId
			, DimProjectedGraduationDateId
		)
		EXEC rds.[Migrate_DimK12StudentsEnrollmentDates] @studentDateQuery, @schoolQuery, @dataCollectionId

		IF @runAsTest = 1
		BEGIN
			PRINT 'enrollmentDatesQuery'
			SELECT * FROM #enrollmentDatesQuery
		END

	--END


	-- INSERT New Facts
	----------------------------

	-- Log history

	IF @runAsTest = 0
	BEGIN

		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)
		
		INSERT INTO rds.FactK12StudentEnrollments
		(
			  SchoolYearId
			, DataCollectionId
			, SeaId
			, IeuId
			, LeaId
			, K12SchoolId
			, K12StudentId
			, EntryGradeLevelId
			, ExitGradeLevelId
			, K12EnrollmentStatusId
			, EntryDateId
			, ExitDateId
			, ProjectedGraduationDateId
			, IdeaStatusId
			, K12DemographicId
		)
		SELECT DISTINCT
			  q.DimSchoolYearId
			, dc.DimDataCollectionId
			, sch.DimSeaId
			, sch.DimIeuId
			, sch.DimLeaId
			, ISNULL(sch.DimK12SchoolId, -1) AS DimK12SchoolId
			, q.DimK12StudentId
			, ISNULL(grade.DimEntryGradeLevelId, -1) AS DimEntryGradeLevelId
			, ISNULL(grade.DimExitGradeLevelId, -1) AS DimExitGradeLevelId
			, ISNULL(enrStatus.DimK12EnrollmentStatusId, -1) AS DimK12EnrollmentStatusId
			, ISNULL(dates.DimEntryDateId, -1) AS DimEntryDateId
			, ISNULL(dates.DimExitDateId, -1) AS DimExitDateId
			, ISNULL(dates.DimProjectedGraduationDateId, -1) AS DimProjectedGraduationDateId
			, ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId
			, ISNULL(de.DimK12DemographicId, -1) AS DimK12DemographicId
		FROM @studentDateQuery q
		JOIN @schoolQuery sch
			ON q.DimK12StudentId = sch.DimK12StudentId
		LEFT JOIN rds.DimDataCollections dc
			ON dc.DataCollectionName = @dataCollectionName
		LEFT JOIN #gradelevelQuery grade
			ON sch.DimK12StudentId = grade.DimK12StudentId
			AND sch.DimK12SchoolId = grade.DimK12SchoolId
			AND sch.DimLeaId = grade.DimLeaId
			AND sch.DimCountDateId = grade.DimDateId
		LEFT JOIN #k12EnrollmentStatusQuery enrStatus
			ON sch.DimK12StudentId = enrStatus.DimK12StudentId
			AND sch.DimK12SchoolId = enrStatus.DimK12SchoolId
			AND sch.DimLeaId = enrStatus.DimLeaId
			AND sch.DimCountDateId = enrStatus.DimCountDateId
		LEFT JOIN #enrollmentDatesQuery dates
			ON sch.DimK12StudentId = dates.DimK12StudentId
			AND sch.DimK12SchoolId = dates.DimK12SchoolId
			AND sch.DimLeaId = dates.DimLeaId
			AND sch.DimCountDateId = dates.DimDateId
		LEFT JOIN #ideaQuery idea
			ON sch.DimK12StudentId = idea.DimK12StudentId
			AND sch.DimK12SchoolId = idea.DimK12SchoolId
			AND sch.DimLeaId = idea.DimLeaId
			AND sch.DimCountDateId = idea.DimCountDateId
		LEFT JOIN #demoQuery de 
			ON sch.DimK12StudentId = de.DimK12StudentId
			AND sch.DimK12SchoolId = de.DimK12SchoolId
			AND sch.DimLeaId = de.DimLeaId
			AND sch.DimCountDateId = de.DimDateId


		-- Load the race bridge table
		INSERT INTO RDS.BridgeK12StudentEnrollmentRaces(
			  RaceId
			, FactK12StudentEnrollmentId
			)
		SELECT
			  r.DimRaceId
			, f.FactK12StudentEnrollmentId
		FROM #raceQuery r
		JOIN RDS.FactK12StudentEnrollments f
			ON r.DimK12StudentId = f.K12StudentId
			AND r.DimLeaId = f.LeaId
			AND r.DimK12SchoolId = f.K12SchoolId
		WHERE r.DimRaceId IS NOT NULL 

		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)

	END
	ELSE
	BEGIN

		-- Run As Test (return data instead of inserting it)

		SELECT DISTINCT
			  q.DimSchoolYearId
			, dc.DimDataCollectionId
			, sch.DimSeaId
			, sch.DimIeuId
			, sch.DimLeaId
			, ISNULL(sch.DimK12SchoolId, -1) AS DimK12SchoolId
			, q.DimK12StudentId
			, ISNULL(grade.DimEntryGradeLevelId, -1) AS DimEntryGradeLevelId
			, ISNULL(grade.DimExitGradeLevelId, -1) AS DimExitGradeLevelId
			, ISNULL(enrStatus.DimEnrollmentStatusId, -1) AS DimK12EnrollmentStatusId
			, ISNULL(dates.DimEntryDateId, -1) AS DimEntryDateId
			, ISNULL(dates.DimExitDateId, -1) AS DimExitDateId
			, ISNULL(dates.DimProjectedGraduationDateId, -1) AS DimProjectedGraduationDateId
			, ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId
			, ISNULL(de.DimK12DemographicId, -1) AS DimK12DemographicId
		FROM @studentDateQuery q
		JOIN @schoolQuery sch
			ON q.DimK12StudentId = sch.DimK12StudentId
		LEFT JOIN rds.DimDataCollections dc
			ON dc.DataCollectionName = @dataCollectionName
		LEFT JOIN #gradelevelQuery grade
			ON sch.DimK12StudentId = grade.DimK12StudentId
			AND sch.DimK12SchoolId = grade.DimK12SchoolId
			AND sch.DimLeaId = grade.DimLeaId
			AND sch.DimCountDateId = grade.DimDateId
		LEFT JOIN #enrollmentStatusQuery enrStatus
			ON sch.DimK12StudentId = enrStatus.DimK12StudentId
			AND sch.DimK12SchoolId = enrStatus.DimK12SchoolId
			AND sch.DimLeaId = enrStatus.DimLeaId
			AND sch.DimCountDateId = enrStatus.DimCountDateId
		LEFT JOIN #enrollmentDatesQuery dates
			ON sch.DimK12StudentId = dates.DimK12StudentId
			AND sch.DimK12SchoolId = dates.DimK12SchoolId
			AND sch.DimLeaId = dates.DimLeaId
			AND sch.DimCountDateId = dates.DimDateId
		LEFT JOIN #ideaQuery idea
			ON sch.DimK12StudentId = idea.DimK12StudentId
			AND sch.DimK12SchoolId = idea.DimK12SchoolId
			AND sch.DimLeaId = idea.DimLeaId
			AND sch.DimCountDateId = idea.DimCountDateId
		LEFT JOIN #demoQuery de 
			ON sch.DimK12StudentId = de.DimK12StudentId
			AND sch.DimK12SchoolId = de.DimK12SchoolId
			AND sch.DimLeaId = de.DimLeaId
			AND sch.DimCountDateId = de.DimDateId


		-- Load the race bridge table
		SELECT
			  r.DimRaceId
			, f.FactK12StudentEnrollmentId
		FROM #raceQuery r
		JOIN RDS.FactK12StudentEnrollments f
			ON r.DimK12StudentId = f.K12StudentId
			AND r.DimLeaId = f.LeaID
			AND r.DimK12SchoolId = f.K12SchoolId
		WHERE r.DimRaceId IS NOT NULL 

	END

	FETCH NEXT FROM selectedYears_cursor INTO @dimSchoolYearId, @schoolYear
	END


	--END TRY
	--BEGIN CATCH
	--	print CAST(ERROR_MESSAGE() AS VARCHAR(900))
	--	--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
	--	--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		
	--END CATCH

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	SET NOCOUNT OFF;
END