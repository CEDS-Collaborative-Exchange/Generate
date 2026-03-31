CREATE PROCEDURE [RDS].[Migrate_K12ProgramParticipation]
	@factTypeCode AS NVARCHAR(50),
	@dataCollectionName AS NVARCHAR(50) = NULL,
	@runAsTest AS BIT,
	@loadAllForDataCollection AS BIT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 1
	
	-- Lookup VALUES
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactStudentCounts'
	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	FROM RDS.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	-- Log history
	--IF @runAsTest = 0
	--BEGIN
		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
	--END


	-- Get Dimension Data
	----------------------------

	DECLARE @studentDateQuery AS rds.K12StudentDateTableType
	
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
	CREATE NONCLUSTERED INDEX IX_Demo ON #raceQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

	
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
		, SexCode									NVARCHAR(50)
		, MilitaryConnected							NVARCHAR(50)
		, HomelessNighttimeResidenceCode			NVARCHAR(50)
		, PersonStartDate							DATETIME
		, PersonEndDate								DATETIME
		, DimK12DemographicId						INT
	)
	CREATE NONCLUSTERED INDEX IX_Demo ON #demoQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)
	
	DECLARE @schoolQuery AS rds.K12StudentOrganizationTableType

	
	CREATE TABLE #ideaQuery (
		  DimK12StudentId							INT
		, DimK12SchoolId							INT
		, DimLeaId									INT
		, DimIeuId									INT
		, PersonId									INT
		, DimDateId									INT
		, IdeaIndicator								NVARCHAR(50)
		, DisabilityCode							NVARCHAR(50)
		, EducEnvCode								NVARCHAR(50)
		, BasisOfExitCode							NVARCHAR(50)
		, SpecialEducationServicesExitDate			DATE
		, DimIdeaStatusId							INT
		, SpecialEducationServicesExitDateId			INT
	)
	CREATE NONCLUSTERED INDEX IX_Idea ON #ideaQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)

	CREATE TABLE #programQuery (
		  DimK12StudentId							INT
		, DimSeaId									INT
		, DimIeuId									INT
		, DimLeaId									INT
		, DimK12SchoolId							INT
		, DimCountDateId							INT
		, DimSchoolYearId							INT
		, ProgramTypeCode							NVARCHAR(60)
		, EntryDate									NVARCHAR(10)
		, ExitDate									NVARCHAR(10)
		, DimK12ProgramTypeId						INT
		, DimEntryDateId							INT
		, DimExitDateId								INT
	)
	CREATE NONCLUSTERED INDEX IX_Program ON #programQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)


	
	DECLARE @schoolYear AS NVARCHAR(50), @dimSchoolYearId AS INT
	DECLARE selectedYears_cursor CURSOR FOR 
	SELECT sy.SchoolYear, sy.DimSchoolYearId
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


		DELETE FROM @studentDateQuery
		DELETE FROM #raceQuery
		DELETE FROM #demoQuery
		DELETE FROM @schoolQuery
		DELETE FROM #ideaQuery
		DELETE FROM #programQuery
	

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
		EXEC rds.Migrate_DimSchoolYears_K12Students @factTypeCode, @migrationType, @dimSchoolYearId, 0, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'studentDateQuery'
			SELECT top 10000 * FROM @studentDateQuery
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
		EXEC RDS.Migrate_K12StudentOrganizations @studentDateQuery, @dataCollectionId, @useCutOffDate, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'schoolQuery'
			SELECT top 10000 * FROM @schoolQuery
		END

		-- Migrate_DimK12Races

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
		EXEC rds.Migrate_DimK12Races  @factTypeCode, @studentDateQuery, @schoolQuery, @dataCollectionId, @useCutOffDate, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'raceQuery'
			SELECT top 10000 * FROM #raceQuery
		END
	
		-- Migrate_DimK12Demographics

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
		EXEC rds.Migrate_DimK12Demographics @studentDateQuery, @schoolQuery, @useCutOffDate, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'demoQuery'
			SELECT top 10000 * FROM #demoQuery
		END

		-- Migrate_DimIdeaStatuses

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
			, DimDateId
			, IdeaIndicator
			, DisabilityCode
			, EducEnvCode
			, BasisOfExitCode
			, SpecialEducationServicesExitDate
			, DimIdeaStatusId
			, SpecialEducationServicesExitDateId
		)
		EXEC rds.Migrate_DimIdeaStatuses @studentDateQuery, @factTypeCode, @useCutOffDate, @schoolQuery, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'ideaQuery'
			SELECT top 10000 * FROM #ideaQuery
		END

		-- Migrate_DimK12ProgramTypes

		--IF @runAsTest = 0
		--BEGIN
			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Program Type Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
		--END
	
		INSERT INTO #programQuery
		(
			  DimK12StudentId		
			, DimSeaId				
			, DimIeuId				
			, DimLeaId				
			, DimK12SchoolId		
			, DimCountDateId		
			, DimSchoolYearId		
			, ProgramTypeCode		
			, EntryDate				
			, ExitDate				
			, DimK12ProgramTypeId	
			, DimEntryDateId		
			, DimExitDateId			
		)
		EXEC rds.Migrate_DimK12ProgramTypes @studentDateQuery, @useCutOffDate, @schoolQuery, @dataCollectionId, @loadAllForDataCollection

		IF @runAsTest = 1
		BEGIN
			PRINT 'programQuery'
			SELECT top 10000 * FROM #programQuery
		END

		-- INSERT New Facts
		----------------------------

		-- Log history

		IF @runAsTest = 0
		BEGIN

			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)
		
			INSERT INTO rds.FactK12ProgramParticipations
			(
					SchoolYearId
				, DateId
				, DataCollectionId
				, SeaId
				, IeuId
				, LeaId
				, K12SchoolId
				, K12ProgramTypeId
				, K12StudentId
				, K12DemographicId
				, IdeaStatusId
				, EntryDateId
				, ExitDateId
			)
			SELECT DISTINCT
				  @dimSchoolYearId
				, sch.DimCountDateId
				, dc.DimDataCollectionId
				, ISNULL(sch.DimSeaId, -1) AS DimSeaId
				, ISNULL(sch.DimIeuId, -1) AS DimIeuId
				, ISNULL(sch.DimLeaId, -1) AS DimLeaId
				, ISNULL(sch.DimK12SchoolId, -1) AS K12SchoolId
				, ISNULL(pt.DimK12ProgramTypeId, -1) AS K12ProgramTypeId
				, sch.DimK12StudentId
				, ISNULL(de.DimK12DemographicId, -1) AS K12DemographicId
				, ISNULL(idea.DimIdeaStatusId, -1) AS IdeaStatusId
				, ISNULL(pt.DimEntryDateId, -1) AS EntryDate
				, ISNULL(pt.DimExitDateId, -1) AS ExitDate
			FROM @schoolQuery sch
			LEFT JOIN rds.DimDataCollections dc
				ON dc.DataCollectionName = @dataCollectionName
			JOIN #programQuery pt
				ON sch.DimK12StudentId = pt.DimK12StudentId
				AND sch.DimK12SchoolId = pt.DimK12SchoolId
				AND sch.DimLeaId = pt.DimLeaId
				AND sch.DimCountDateId = pt.DimCountDateId
			LEFT JOIN #ideaQuery idea
				ON sch.DimK12StudentId = idea.DimK12StudentId
				AND sch.DimK12SchoolId = idea.DimK12SchoolId
				AND sch.DimLeaId = idea.DimLeaId
				AND sch.DimCountDateId = idea.DimDateId
			LEFT JOIN #demoQuery de 
				ON sch.DimK12StudentId = de.DimK12StudentId
				AND sch.DimK12SchoolId = de.DimK12SchoolId
				AND sch.DimLeaId = de.DimLeaId
				AND sch.DimCountDateId = de.DimDateId


			-- Load the race bridge table
			INSERT INTO RDS.BridgeK12ProgramParticipationRaces (
				  RaceId
				, FactK12ProgramParticipationId
				)
			SELECT
					r.DimRaceId
				, f.FactK12ProgramParticipationId
			FROM #raceQuery r
			JOIN RDS.FactK12ProgramParticipations f
				ON r.DimK12StudentId = f.K12StudentId
				AND r.DimLeaId = f.LeaId
				AND r.DimK12SchoolId = f.K12SchoolId

			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)

		END
		ELSE
		BEGIN

			-- Run As Test (return data instead of inserting it)

			SELECT DISTINCT
				  @dimSchoolYearId
				, sch.DimCountDateId
				, dc.DimDataCollectionId
				, ISNULL(sch.DimSeaId, -1) AS DimSeaId
				, ISNULL(sch.DimIeuId, -1) AS DimIeuId
				, ISNULL(sch.DimLeaId, -1) AS DimLeaId
				, ISNULL(sch.DimK12SchoolId, -1) AS K12SchoolId
				, ISNULL(pt.DimK12ProgramTypeId, -1) AS K12ProgramTypeId
				, sch.DimK12StudentId
				, ISNULL(de.DimK12DemographicId, -1) AS K12DemographicId
				, ISNULL(idea.DimIdeaStatusId, -1) AS IdeaStatusId
				, ISNULL(pt.DimEntryDateId, -1) AS EntryDate
				, ISNULL(pt.DimExitDateId, -1) AS ExitDate
			FROM @schoolQuery sch
			LEFT JOIN rds.DimDataCollections dc
				ON dc.DataCollectionName = @dataCollectionName
			JOIN #programQuery pt
				ON sch.DimK12StudentId = pt.DimK12StudentId
				AND sch.DimK12SchoolId = pt.DimK12SchoolId
				AND sch.DimLeaId = pt.DimLeaId
				AND sch.DimCountDateId = pt.DimCountDateId
			LEFT JOIN #ideaQuery idea
				ON sch.DimK12StudentId = idea.DimK12StudentId
				AND sch.DimK12SchoolId = idea.DimK12SchoolId
				AND sch.DimLeaId = idea.DimLeaId
				AND sch.DimCountDateId = idea.DimDateId
			LEFT JOIN #demoQuery de 
				ON sch.DimK12StudentId = de.DimK12StudentId
				AND sch.DimK12SchoolId = de.DimK12SchoolId
				AND sch.DimLeaId = de.DimLeaId
				AND sch.DimCountDateId = de.DimDateId


			-- Load the race bridge table
			SELECT
				  r.DimRaceId
				, f.FactK12ProgramParticipationId
			FROM #raceQuery r
			JOIN RDS.FactK12ProgramParticipations f
				ON r.DimK12StudentId = f.K12StudentId
				AND r.DimLeaId = f.LeaId
				AND r.DimK12SchoolId = f.K12SchoolId
			
		END

		FETCH NEXT FROM selectedYears_cursor INTO @dimSchoolYearId, @schoolYear
	END


	DROP TABLE #raceQuery
	DROP TABLE #demoQuery
	DROP TABLE #ideaQuery
	DROP TABLE #programQuery

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	IF EXISTS (SELECT  1 FROM tempdb.dbo.sysobjects o WHERE o.xtype IN ('U') AND o.id = object_id(N'tempdb..#queryOutput'))
	DROP TABLE #queryOutput

	SET NOCOUNT OFF;
END