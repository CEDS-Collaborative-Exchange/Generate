--Example:
--EXEC [RDS].[Migrate_FactK12CourseSections] 'TSDL-DM 2015',0, 1
--EXEC rds.Migrate_DimSchoolYears_K12Students 'submission', 'rds',9 , 0 , 207, 0


CREATE PROCEDURE [RDS].[Migrate_FactK12CourseSections]
	@dataCollectionName AS NVARCHAR(255) = NULL,
	@loadAllForDataCollection AS BIT = 0,
	@runAsTest AS BIT = 1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @migrationType AS VARCHAR(50) ='rds',@useCutOffDate AS BIT = 1
	DECLARE @dataCollectionId AS INT
	SELECT @dataCollectionId = DataCollectionId FROM dbo.DataCollection WHERE DataCollectionName = @dataCollectionName
	DECLARE @dataMigrationTypeId INT
	SELECT @dataMigrationTypeId = DimDataMigrationTypeId FROM RDS.DimDataMigrationTypes WHERE DataMigrationTypeCode = @migrationType
	
	-- Define Cursor
	DECLARE @schoolYear AS NVARCHAR(50), @dimSchoolYearId AS INT
	DECLARE selectedYears_cursor CURSOR FOR 
	SELECT DISTINCT sy.DimSchoolYearId, sy.SchoolYear
	FROM rds.DimSchoolYears sy
	JOIN rds.DimSchoolYearDataMigrationTypes dm 
		ON dm.DimSchoolYearId = sy.DimSchoolYearId
	JOIN rds.DimDataCollections dc
		ON dc.DataCollectionSchoolYear = sy.SchoolYear
	JOIN rds.DimDataMigrationTypes dmt
		ON dm.DataMigrationTypeId = dmt.DimDataMigrationTypeId
			AND dmt.DataMigrationTypeCode = @migrationType
	WHERE dc.DataCollectionName=@dataCollectionName

	DECLARE @studentDateQuery AS rds.K12StudentDateTableType
	DECLARE @schoolQuery AS rds.K12StudentOrganizationTableType

	OPEN selectedYears_cursor
	FETCH NEXT FROM selectedYears_cursor INTO @dimSchoolYearId, @schoolYear
	WHILE @@FETCH_STATUS = 0
	BEGIN	
		-- Get Dimension Data
		----------------------------
		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#datacollectionQuery'))
			Begin
				Drop Table #datacollectionQuery
			End
		CREATE TABLE #datacollectionQuery (
			  DimCollectionId							INT
			, DataCollectionName						NVARCHAR(100)
		)

		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#raceQuery'))
			Begin
				Drop Table #raceQuery
			End
		CREATE TABLE #raceQuery(
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

		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#demoQuery'))
			Begin
				Drop Table #demoQuery
			End	
		CREATE TABLE #demoQuery (
			  DimK12StudentId							INT
			, DimDateId									INT
			, DimK12SchoolId							INT
			, DimLeaId									INT
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

		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#gradelevelQuery'))
		Begin
			Drop Table #gradelevelQuery
		End
		CREATE TABLE #gradelevelQuery(
			  DimK12StudentId							INT
			, DimDateId									INT
			, DimIeuId									INT
			, DimLeaId									INT
			, PersonId									INT
			, DimK12SchoolId							INT 
			, EntryGradeLevelCode						NVARCHAR(50)
			, ExitGradeLevelCode						NVARCHAR(50)	-- Not used here
			, DimEntryGradeLevelId						INT
			, DimExitGradeLevelId						INT				-- Not used here
		)
		CREATE NONCLUSTERED INDEX IX_Grade ON #gradelevelQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimDateId)
		
		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#k12CourseQuery'))
		Begin
			Drop Table #k12CourseQuery
		End
		CREATE TABLE #k12CourseQuery(
			  DimK12StudentId							INT
			, DimK12SchoolId							INT
			, DimLeaId									INT
			, PersonId									INT
			, DimCountDateId							INT
			, DimK12CourseId							INT
			, CourseTitle								NVARCHAR(60)
			, DimSchoolYearId							INT
			, EntryDate									DATETIME
			, ExitDate									DATETIME
		)
	
		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#k12CourseStatusQuery'))
		Begin
			Drop Table #k12CourseStatusQuery
		End
		CREATE TABLE #k12CourseStatusQuery(
			  DimK12StudentId							INT
			, DimK12SchoolId							INT
			, DimLeaId									INT
			, PersonId									INT
			, DimCountDateId							INT
			, DimK12CourseId							INT
			, CourseTitle								NVARCHAR(60)
			, DimK12CourseStatusId						INT
			, CourseLevelCharacteristicCode				NVARCHAR(50)
		)
	
		If EXISTS (Select * From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#scedCodeQuery'))
		Begin
			Drop Table #scedCodeQuery
		End
		CREATE TABLE #scedCodeQuery(
			  DimK12StudentId							INT
			, DimK12SchoolId							INT
			, DimLeaId									INT
			, PersonId									INT
			, DimCountDateId							INT
			, DimK12CourseId							INT
			, CourseTitle								NVARCHAR(60)
			, DimScedCodeId								INT
			, ScedCourseCode							NCHAR(5)
		)
		CREATE NONCLUSTERED INDEX IX_Sced ON #scedCodeQuery (DimK12StudentId, DimLeaId, DimK12SchoolId, DimCountDateId)

		DELETE FROM @studentDateQuery
		DELETE FROM @schoolQuery	

		-- Migrate_DimDates_Students
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
		--select * into #studentDateQuery from @studentDateQuery

		IF @runAsTest = 1 BEGIN
			SELECT * FROM @studentDateQuery
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
		--select * into #schoolQuery from @schoolQuery

		IF @runAsTest = 1 BEGIN
			SELECT * FROM @schoolQuery
		END
	
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
		--Select * From #raceQuery
		
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #raceQuery
		END

		INSERT INTO #demoQuery
		(
			  DimK12StudentId
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
		--Select * From #demoQuery
				
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #demoQuery
		END

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
		--Select * From #gradelevelQuery
				
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #gradelevelQuery
		END

		INSERT INTO #k12CourseQuery
		(
			  DimK12StudentId	
			, DimK12SchoolId	
			, DimLeaId			
			, PersonId			
			, DimCountDateId	
			, DimK12CourseId	
			, CourseTitle	
			, DimSchoolYearId
			, EntryDate
			, ExitDate
		)
		EXEC rds.[Migrate_DimK12Courses] @studentDateQuery, @schoolQuery, @dataCollectionId, @loadAllForDataCollection
		--Select * From #k12CourseQuery
			
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #k12CourseQuery
		END

		INSERT INTO #k12CourseStatusQuery
		(
			  DimK12StudentId					
			, DimK12SchoolId					
			, DimLeaId							
			, PersonId							
			, DimCountDateId					
			, DimK12CourseId					
			, CourseTitle						
			, DimK12CourseStatusId				
			, CourseLevelCharacteristicCode	
		)
		EXEC rds.[Migrate_DimK12CourseStatuses] @studentDateQuery, @schoolQuery, @dataCollectionId, @loadAllForDataCollection
		--Select * From #k12CourseStatusQuery
		
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #k12CourseStatusQuery
		END
	
		INSERT INTO #scedCodeQuery
		(
			  DimK12StudentId	
			, DimK12SchoolId	
			, DimLeaId			
			, PersonId			
			, DimCountDateId	
			, DimK12CourseId	
			, CourseTitle		
			, DimScedCodeId		
			, ScedCourseCode	
		)
		EXEC rds.[Migrate_DimScedCodes] @studentDateQuery, @schoolQuery, @dataCollectionId, @loadAllForDataCollection
		
		IF @runAsTest = 1 BEGIN
			SELECT * FROM #scedCodeQuery
		END
		
	-- INSERT New Facts
	-------------------
	
	IF @runAsTest = 0
	BEGIN		
		INSERT INTO [RDS].[FactK12StudentCourseSections]
		(
			  SchoolYearId
			, DataCollectionId
			, IeuId               
			, LeaId          
			, K12SchoolId         
			, K12StudentId     
			, DateId          
			, GradeLevelId
			, K12DemographicId
			, K12CourseId    
			, K12CourseStatusId
			, ScedCodeId
			, CipCodeId
			, LanguageId
			, StudentCourseSectionCount
		)
		SELECT DISTINCT
			  kc.DimSchoolYearId AS SchoolYearId
			, dc.DimDataCollectionId AS DataCollectionId
			--, sch.DimSeaId AS SeaId
			, sch.DimIeuId AS IeuId
			, sch.DimLeaId AS LeaId
			, ISNULL(sch.DimK12SchoolId, -1) AS K12SchoolId
			, q.DimK12StudentId AS K12StudentId
			, q.DimCountDateId AS DateId
			, ISNULL(grade.DimEntryGradeLevelId, -1) AS EntryGradeLevelId
			, ISNULL(de.DimK12DemographicId, -1) AS K12DemographicId
			, ISNULL(kc.DimK12CourseId, 1) AS K12CourseId
			, ISNULL(cs.DimK12CourseStatusId, -1) AS K12CourseStatusId
			, ISNULL(sc.DimScedCodeId, -1) AS ScedCodeId	
			, -1 AS CipCodeId		
			, -1 AS LanguageId	
			, -1 AS StudentCourseSectionCount	
		FROM @studentDateQuery q
		JOIN @schoolQuery sch		
			ON q.DimK12StudentId = sch.DimK12StudentId
			AND q.DimCountDateId = sch.DimCountDateId
		JOIN rds.DimDataCollections dc
			ON dc.DimDataCollectionId = (Select DimDataCollectionId from rds.DimDataCollections where DataCollectionName = @dataCollectionName)
		JOIN #k12CourseQuery kc
			ON sch.DimK12StudentId = kc.DimK12StudentId
			AND sch.DimK12SchoolId = kc.DimK12SchoolId
			AND sch.DimLeaId = kc.DimLeaId
			--AND sch.DimIeuId = kc.DimIeuId
			AND sch.DimCountDateId = kc.DimCountDateId 
		LEFT JOIN #gradelevelQuery grade
			ON sch.DimK12StudentId = grade.DimK12StudentId
			AND sch.DimK12SchoolId = grade.DimK12SchoolId
			AND sch.DimLeaId = grade.DimLeaId
			--AND sch.DimIeuId = grade.DimIeuId
			AND sch.DimCountDateId = grade.DimDateId
		LEFT JOIN #demoQuery de 
			ON sch.DimK12StudentId = de.DimK12StudentId
			AND sch.DimK12SchoolId = de.DimK12SchoolId
			AND sch.DimLeaId = de.DimLeaId
			--AND sch.DimIeuId = de.DimIeuId
			AND sch.DimCountDateId = de.DimDateId
		LEFT JOIN #k12CourseStatusQuery cs
			ON sch.DimK12StudentId = cs.DimK12StudentId
			AND sch.DimK12SchoolId = cs.DimK12SchoolId
			AND sch.DimLeaId = cs.DimLeaId
			--AND sch.DimIeuId = cs.DimIeuId
			AND sch.DimCountDateId = cs.DimCountDateId
			AND kc.DimK12CourseId = cs.DimK12CourseId
		LEFT JOIN #scedCodeQuery sc
			ON sch.DimK12StudentId = sc.DimK12StudentId
			AND sch.DimK12SchoolId = sc.DimK12SchoolId
			AND sch.DimLeaId = sc.DimLeaId
			--AND sch.DimIeuId = sc.DimIeuId
			AND sch.DimCountDateId = sc.DimCountDateId
			AND kc.DimK12CourseId = sc.DimK12CourseId

		-- Load the race bridge table
		INSERT INTO RDS.BridgeK12StudentCourseSectionRaces(
			  FactK12StudentCourseSectionId
			, RaceId		
			)
		SELECT
			  f.FactK12StudentCourseSectionId
			, r.DimRaceId
		FROM #raceQuery r
		JOIN RDS.FactK12StudentCourseSections f
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
			  sy.DimSchoolYearId AS SchoolYearId
			, dc.DimDataCollectionId AS DataCollectionId
			--, sch.DimSeaId AS SeaId
			, sch.DimIeuId AS IeuId
			, sch.DimLeaId AS LeaId
			, ISNULL(sch.DimK12SchoolId, -1) AS K12SchoolId
			, q.DimK12StudentId AS K12StudentId
			, q.DimCountDateId AS DateId
			, ISNULL(grade.DimEntryGradeLevelId, -1) AS EntryGradeLevelId
			, ISNULL(de.DimK12DemographicId, -1) AS K12DemographicId
			, ISNULL(kc.DimK12CourseId, 1) AS K12CourseId
			, ISNULL(cs.DimK12CourseStatusId, -1) AS K12CourseStatusId
			, ISNULL(sc.DimScedCodeId, -1) AS ScedCodeId			
		FROM @studentDateQuery q
		JOIN @schoolQuery sch		
			ON q.DimK12StudentId = sch.DimK12StudentId
			AND q.DimCountDateId = sch.DimCountDateId
		JOIN rds.DimSchoolYears sy
			ON q.CountDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
		JOIN rds.DimDataCollections dc
			ON dc.DimDataCollectionId = (Select DimDataCollectionId from rds.DimDataCollections where DataCollectionName = @dataCollectionName)
		JOIN #k12CourseQuery kc
			ON sch.DimK12StudentId = kc.DimK12StudentId
			AND sch.DimK12SchoolId = kc.DimK12SchoolId
			AND sch.DimLeaId = kc.DimLeaId
			--AND sch.DimIeuId = kc.DimIeuId
			AND sch.DimCountDateId = kc.DimCountDateId 
		LEFT JOIN #gradelevelQuery grade
			ON sch.DimK12StudentId = grade.DimK12StudentId
			AND sch.DimK12SchoolId = grade.DimK12SchoolId
			AND sch.DimLeaId = grade.DimLeaId
			--AND sch.DimIeuId = grade.DimIeuId
			AND sch.DimCountDateId = grade.DimDateId
		LEFT JOIN #demoQuery de 
			ON sch.DimK12StudentId = de.DimK12StudentId
			AND sch.DimK12SchoolId = de.DimK12SchoolId
			AND sch.DimLeaId = de.DimLeaId
			--AND sch.DimIeuId = de.DimIeuId
			AND sch.DimCountDateId = de.DimDateId
		LEFT JOIN #k12CourseStatusQuery cs
			ON sch.DimK12StudentId = cs.DimK12StudentId
			AND sch.DimK12SchoolId = cs.DimK12SchoolId
			AND sch.DimLeaId = cs.DimLeaId
			--AND sch.DimIeuId = cs.DimIeuId
			AND sch.DimCountDateId = cs.DimCountDateId
			AND kc.DimK12CourseId = cs.DimK12CourseId
		LEFT JOIN #scedCodeQuery sc
			ON sch.DimK12StudentId = sc.DimK12StudentId
			AND sch.DimK12SchoolId = sc.DimK12SchoolId
			AND sch.DimLeaId = sc.DimLeaId
			--AND sch.DimIeuId = sc.DimIeuId
			AND sch.DimCountDateId = sc.DimCountDateId
			AND kc.DimK12CourseId = sc.DimK12CourseId

		SELECT
			  f.FactK12StudentCourseSectionId
			, r.DimRaceId
			
		FROM #raceQuery r
		JOIN RDS.FactK12StudentCourseSections f
			ON r.DimK12StudentId = f.K12StudentId
			AND r.DimLeaId = f.LeaId
			AND r.DimK12SchoolId = f.K12SchoolId
	END

	FETCH NEXT FROM selectedYears_cursor INTO @dimSchoolYearId, @schoolYear
	END

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#datacollectionQuery'))
	Drop Table #datacollectionQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#raceQuery'))
	Drop Table #raceQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#demoQuery'))
	Drop Table #demoQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#gradelevelQuery'))
	Drop Table #gradelevelQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#k12CourseQuery'))
	Drop Table #k12CourseQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#k12CourseStatusQuery'))
	Drop Table #k12CourseStatusQuery
	If EXISTS (Select 1 From tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#scedCodeQuery'))
	Drop Table #scedCodeQuery

	SET NOCOUNT OFF;


END