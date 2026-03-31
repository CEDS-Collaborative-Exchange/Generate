CREATE PROCEDURE [RDS].[Migrate_OrganizationStatusCounts]
	@factTypeCode AS VARCHAR(50) = 'organizationstatus',
	@runAsTest AS BIT,
	@dataCollectionName AS VARCHAR(50) = NULL
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION

	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

	-- step 1 - migrate custom indicator statuses AND state defined statuses
	DECLARE @indicator AS VARCHAR(50), @idx AS INT
	IF NOT EXISTS (SELECT * FROM [RDS].[DimStateDefinedStatuses] WHERE [RDS].[DimStateDefinedStatuses].StateDefinedStatusCode='Missing')
		BEGIN
			SET IDENTITY_INSERT [RDS].[DimStateDefinedStatuses] ON
			INSERT INTO [RDS].[DimStateDefinedStatuses] (
				 [DimStateDefinedStatusId]
				,[StateDefinedStatusCode]
				,[StateDefinedStatusDescription]) VALUES (
				-1, 'Missing', 'State Defined Status NOT SET'
				)
			SET IDENTITY_INSERT [RDS].[DimStateDefinedStatuses] off
		END
	SET @idx = 1
	DECLARE indicatorstatus_cursor CURSOR FOR 
	SELECT DISTINCT IndicatorStatus FROM dbo.K12SchoolIndicatorStatus WHERE IndicatorStatus IS NOT NULL AND IndicatorStatus != ''
	OPEN indicatorstatus_cursor
	FETCH NEXT FROM indicatorstatus_cursor INTO @indicator

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT * FROM [RDS].[DimStateDefinedStatuses] WHERE [RDS].[DimStateDefinedStatuses].StateDefinedStatusCode=@indicator)
			BEGIN
				INSERT INTO [RDS].[DimStateDefinedStatuses] (
					 [StateDefinedStatusCode]
					,[StateDefinedStatusDescription]) VALUES (
					@indicator, 'State Defined Status '+@indicator
				)
			END
		SET @idx = @idx + 1
		FETCH NEXT FROM indicatorstatus_cursor INTO @indicator
	END
	CLOSE indicatorstatus_cursor
	DEALLOCATE indicatorstatus_cursor

	-- transfer custom indicator
	-- INSERT Missing
	IF NOT EXISTS (SELECT * FROM RDS.DimStateDefinedCustomIndicators WHERE RDS.DimStateDefinedCustomIndicators.StateDefinedCustomIndicatorCode='Missing')
		BEGIN
			SET IDENTITY_INSERT RDS.DimStateDefinedCustomIndicators ON
			INSERT INTO RDS.DimStateDefinedCustomIndicators (
				 DimStateDefinedCustomIndicatorId
				,StateDefinedCustomIndicatorCode
				,StateDefinedCustomIndicatorDescription) VALUES (
				 -1, 'Missing', 'State Defined Custom Indicator NOT SET '
			)
			SET IDENTITY_INSERT RDS.DimStateDefinedCustomIndicators off
		END
	-- INSERT new custom indicators
	SET @idx = 1
	DECLARE indicatorcustomstatus_cursor CURSOR FOR 
	SELECT DISTINCT ic.Code
	FROM dbo.K12SchoolIndicatorStatus k12
	JOIN dbo.RefIndicatorStatusCustomType ic ON ic.RefIndicatorStatusCustomTypeId=k12.RefIndicatorStatusCustomTypeId
	WHERE (@dataCollectionId IS NULL OR k12.DataCollectionId = @dataCollectionId)	
	
	OPEN indicatorcustomstatus_cursor
	FETCH NEXT FROM indicatorcustomstatus_cursor INTO @indicator

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT * FROM RDS.DimStateDefinedCustomIndicators WHERE RDS.DimStateDefinedCustomIndicators.StateDefinedCustomIndicatorCode=@indicator)
			BEGIN
				INSERT INTO RDS.DimStateDefinedCustomIndicators (
					 StateDefinedCustomIndicatorCode
					,StateDefinedCustomIndicatorDescription) VALUES (
					@indicator, 'State Defined Custom Indicator '+@indicator
				)
			END
		SET @idx = @idx + 1
		FETCH NEXT FROM indicatorcustomstatus_cursor INTO @indicator
	END
	CLOSE indicatorcustomstatus_cursor
	DEALLOCATE indicatorcustomstatus_cursor
/*
	RDS.Migrate_OrganizationStatusCounts @factTypeCode='organizationstatus', @runAsTest=1
*/
	-- step 2 - everything ELSE ===========================================================================================================
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactOrganizationStatusCounts'
	DECLARE @dataMigrationTypeId AS INT
	DECLARE @migrationType AS VARCHAR(50) = 'rds'
	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode -- 1 for organizationstatus

	SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	FROM rds.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	-- DELETE existing fact records
	IF @runAsTest = 0
		BEGIN
			DELETE FROM rds.FactOrganizationStatusCounts WHERE FactTypeId = @factTypeId
		END

	DECLARE @IndicatorStatusType AS VARCHAR(100) = 'GraduationRateIndicatorStatus', @IndicatorStatusTypeId INT
	-- indicatorstatustype cursor
	DECLARE indicatorstatustype_cursor CURSOR FOR 
	SELECT Code, RefIndicatorStatusTypeId
	FROM dbo.RefIndicatorStatusType
	--ORDER BY dbo.RefIndicatorStatusType.SortOrder

/*
	RDS.Migrate_OrganizationStatusCounts @factTypeCode='organizationstatus', @runAsTest=1
*/
	OPEN indicatorstatustype_cursor
	FETCH NEXT FROM indicatorstatustype_cursor INTO @IndicatorStatusType, @IndicatorStatusTypeId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- variables for school_cursor
		DECLARE @schoolOrganizationId INT, @RefIndicatorStatusTypeId INT, @RefIndicatorStateDefinedStatusId INT, @RefIndicatorStatusSubgroupTypeId INT,
		@IndicatorStatusSubgroup NVARCHAR(100), @IndicatorStatus NVARCHAR(100)

		-- Log history
		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
		--END

		DECLARE @DimOrganizationIndicatorStatus_Dates AS rds.SchoolStatusTableType

		DELETE FROM @DimOrganizationIndicatorStatus_Dates
		DECLARE @count INT
		--SELECT @count = Count('c') FROM @DimOrganizationIndicatorStatus_Dates
		--print 'before @count='+cast(@count AS VARCHAR(20))
		-- SELECT SchoolId, StartDate, EndDate, s.Year, d.Year, d.DimDateId
		INSERT INTO @DimOrganizationIndicatorStatus_Dates
		(
			K12SchoolIndicatorStatusId,
			K12SchoolId,
			DimCountDateId,
			[Year],
			OrganizationId,
			DimK12SchoolId,
			RefIndicatorStatusTypeId
		)
		exec rds.Migrate_DimOrganizationIndicatorStatus_SchoolYears @factTypeCode, @IndicatorStatusType, @dataCollectionId

		SELECT @count = Count('c') FROM @DimOrganizationIndicatorStatus_Dates

		--SELECT * FROM @DimOrganizationIndicatorStatus_Dates
		--ORDER BY K12SchoolIndicatorStatusId
		/*
			RDS.Migrate_OrganizationStatusCounts @factTypeCode='organizationstatus', @runAsTest=1
		*/	
		-- Migrate_DimRace
		DECLARE @Race AS table (
			K12SchoolIndicatorStatusId INT, DimK12SchoolId INT, OrganizationId INT, DimCountDateId INT, Race VARCHAR(100), IndicatorStatus VARCHAR(100), IndicatorStateDefinedStatus VARCHAR(100), CustomIndicator VARCHAR(100))
		INSERT INTO @Race (
			K12SchoolIndicatorStatusId,
			DimK12SchoolId,
			OrganizationId,
			DimCountDateId,
			Race,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolRace @DimOrganizationIndicatorStatus_Dates, @dataCollectionId

		-- Migrate LEP 
		DECLARE @Lep AS table (K12SchoolIndicatorStatusId INT, DimCountDateId INT, LepStatusCode NVARCHAR(50), IndicatorStatus VARCHAR(100), IndicatorStateDefinedStatus VARCHAR(100), CustomIndicator VARCHAR(100))
		INSERT INTO @Lep (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			LepStatusCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolLep @DimOrganizationIndicatorStatus_Dates, @dataCollectionId
	
		-- migrate Idea
		DECLARE @Idea AS table (K12SchoolIndicatorStatusId INT, DimCountDateId INT, DisabilityCode VARCHAR(100), IndicatorStatus VARCHAR(100), IndicatorStateDefinedStatus VARCHAR(100), CustomIndicator VARCHAR(100))
		INSERT INTO @Idea (
			K12SchoolIndicatorStatusId,
			DimCountDateId,
			DisabilityCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimK12SchoolIdea @DimOrganizationIndicatorStatus_Dates, @dataCollectionId
		--SELECT * FROM @Idea --ORDER BY OrganizationId
	
		-- Migrate EcoDis status
		DECLARE @Ecodis AS table (K12SchoolIndicatorStatusId INT, DimCountDateId INT, EcoDisStatusCode NVARCHAR(50), IndicatorStatus VARCHAR(100), IndicatorStateDefinedStatus VARCHAR(100), CustomIndicator VARCHAR(100))
		INSERT INTO @Ecodis (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			EcoDisStatusCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolEcodis @DimOrganizationIndicatorStatus_Dates, @dataCollectionId
		--SELECT * FROM @Ecodis --ORDER BY OrganizationId

		-- Migrate AllStudents status
		DECLARE @AllStudents AS table (K12SchoolIndicatorStatusId INT, DimCountDateId INT, AllStudentsCode NVARCHAR(50), IndicatorStatus VARCHAR(100), IndicatorStateDefinedStatus VARCHAR(100), CustomIndicator VARCHAR(100))
		INSERT INTO @AllStudents (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			AllStudentsCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolAllStudents @DimOrganizationIndicatorStatus_Dates, @dataCollectionId

		--SELECT K12SchoolIndicatorStatusId FROM @DimOrganizationIndicatorStatus_Dates

		--SELECT d.K12SchoolIndicatorStatusId FROM @DimOrganizationIndicatorStatus_Dates d
		--JOIN dbo.K12SchoolIndicatorStatus stat ON stat.K12SchoolIndicatorStatusId=d.K12SchoolIndicatorStatusId
		--WHERE d.K12SchoolIndicatorStatusId NOT IN (SELECT K12SchoolIndicatorStatusId FROM @AllStudents)
		--AND stat.IndicatorStatusSubgroup = 'AllStudents'
	

		--SELECT * FROM @AllStudents --ORDER BY OrganizationId
	/*
		[RDS].[Migrate_OrganizationStatusCounts] @runAsTest=1
	*/

		--======================================= output =====================
		create table #queryOutput (
			QueryOutputId INT IDENTITY(1,1) NOT NULL,
			K12SchoolIndicatorStatusId INT,
			DimK12SchoolId INT,
			DimCountDateId INT,
			Race VARCHAR(100),
			LepStatusCode VARCHAR(100),
			DisabilityCode VARCHAR(100),
			EcoDisStatusCode VARCHAR(100),
			AllStudentsCode VARCHAR(100),
			StateDefinedStatus VARCHAR(100),
			Indicator VARCHAR(100),
			CustomIndicator VARCHAR(100),
			IndicatorStatusTypeCode VARCHAR(100)
		)
		INSERT INTO #queryOutput
		(
			K12SchoolIndicatorStatusId,
			DimK12SchoolId,
			DimCountDateId,
			Race,
			LepStatusCode,
			DisabilityCode,
			EcoDisStatusCode,
			AllStudentsCode,
			StateDefinedStatus,
			Indicator,
			CustomIndicator,
			IndicatorStatusTypeCode
		)
		SELECT 
			s.K12SchoolIndicatorStatusId,
			s.DimK12SchoolId, 
			s.DimCountDateId,
			ISNULL(race.Race, 'MISSING') AS Race,
			ISNULL(lep.LepStatusCode, 'MISSING') AS LepStatusCode,
			ISNULL(idea.DisabilityCode, 'MISSING') AS DisabilityCode,
			ISNULL(ecodis.EcoDisStatusCode, 'MISSING') AS EcoDisStatusCode,
			ISNULL(allstudents.AllStudentsCode, 'MISSING') AS AllStudentsCode,
			CASE 
				WHEN race.Race IS NOT NULL THEN race.IndicatorStateDefinedStatus
				WHEN lep.LepStatusCode IS NOT NULL THEN lep.IndicatorStateDefinedStatus
				WHEN idea.DisabilityCode IS NOT NULL THEN idea.IndicatorStateDefinedStatus
				WHEN ecodis.EcoDisStatusCode IS NOT NULL THEN ecodis.IndicatorStateDefinedStatus
				WHEN allstudents.AllStudentsCode IS NOT NULL THEN allstudents.IndicatorStateDefinedStatus
			END,
			CASE 
				WHEN race.Race IS NOT NULL THEN race.IndicatorStatus
				WHEN lep.LepStatusCode IS NOT NULL THEN lep.IndicatorStatus
				WHEN idea.DisabilityCode IS NOT NULL THEN idea.IndicatorStatus
				WHEN ecodis.EcoDisStatusCode IS NOT NULL THEN ecodis.IndicatorStatus
				WHEN allstudents.AllStudentsCode IS NOT NULL THEN allstudents.IndicatorStatus
			END,
			CASE 
				WHEN race.CustomIndicator IS NOT NULL THEN race.CustomIndicator ELSE 
					CASE WHEN lep.CustomIndicator IS NOT NULL THEN lep.CustomIndicator ELSE 
						CASE WHEN idea.CustomIndicator IS NOT NULL THEN idea.CustomIndicator ELSE 
							CASE WHEN ecodis.CustomIndicator IS NOT NULL THEN ecodis.CustomIndicator ELSE 
								CASE WHEN allstudents.CustomIndicator IS NOT NULL THEN allstudents.CustomIndicator ELSE 'Missing'
							END
						END
					END
				END
			END,
			ISNULL(statustype.Code, 'MISSING') AS IndicatorStatusTypeCode
		FROM  @DimOrganizationIndicatorStatus_Dates s
		JOIN dbo.RefIndicatorStatusType statustype ON statustype.RefIndicatorStatusTypeId=s.RefIndicatorStatusTypeId
		LEFT JOIN @Race race ON race.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		LEFT JOIN @Lep lep ON lep.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		LEFT JOIN @Idea idea ON idea.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		LEFT JOIN @Ecodis ecodis ON ecodis.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		LEFT JOIN @AllStudents allstudents ON allstudents.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
	
		ORDER BY s.DimK12SchoolId

	/*
		[RDS].[Migrate_OrganizationStatusCounts] @runAsTest=1
	*/

		-- Combine Dimension Data
		----------------------------
		-- Log history
		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combine Dimension Data')
		--END

		-- INSERT New Facts
		----------------------------
		-- Log history
		--IF @runAsTest = 0
		--BEGIN
		--	INSERT INTO RDS.DataMigrationHistories
		--	(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) VALUES	(getutcdate(), @dataMigrationTypeId, @factTable + ' - INSERT New Facts')
		--END
	
		IF @runAsTest = 0
		BEGIN
			INSERT INTO rds.FactOrganizationStatusCounts
			(
				FactTypeId,
				K12SchoolId,
				SchoolYearId,
				RaceId,
				IdeaStatusId,
				K12DemographicId,
				IndicatorStatusId,
				StateDefinedStatusId,
				OrganizationStatusCount,
				StateDefinedCustomIndicatorId,
				IndicatorStatusTypeId
			)
			SELECT 
				@factTypeId AS DimFactTypeId,
				DimK12SchoolId,
				DimCountDateId,
				ISNULL(races.DimRaceId, -1) AS DimRaceId,				-- race
				ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,				-- idea
				ISNULL(demo.DimK12DemographicId, -1) AS DimDemographicId,				-- lep & Eco Dis
				ISNULL(sdf.DimIndicatorStatusId, -1) AS DimIndicatorStatusId,				-- indicator status id
				ISNULL(indicator.DimStateDefinedStatusId, -1) AS DimStateDefinedStatusId,				-- state defined status
				1,
				ISNULL(customindicator.DimStateDefinedCustomIndicatorId, -1) AS DimStateDefinedCustomIndicatorId,				-- custom indicator id
				ISNULL(statustype.DimIndicatorStatusTypeId, -1) AS DimIndicatorStatusTypeId				-- indicator status type
			FROM #queryOutput q
			JOIN rds.DimIndicatorStatusTypes statustype ON statustype.IndicatorStatusTypeCode = q.IndicatorStatusTypeCode
			LEFT JOIN rds.DimRaces races
				ON races.RaceCode=q.Race 
			LEFT JOIN rds.DimK12Demographics demo
				ON demo.EnglishLearnerStatusCode = q.LepStatusCode
				AND demo.EconomicDisadvantageStatusCode = q.EcoDisStatusCode
			LEFT JOIN rds.DimIdeaStatuses idea
				ON idea.PrimaryDisabilityTypeCode = q.DisabilityCode
			LEFT JOIN rds.DimIndicatorStatuses sdf ON sdf.IndicatorStatusCode=q.StateDefinedStatus
			LEFT JOIN rds.DimStateDefinedStatuses indicator ON indicator.StateDefinedStatusCode = q.Indicator
			LEFT JOIN rds.DimStateDefinedCustomIndicators customindicator ON customindicator.StateDefinedCustomIndicatorCode=q.CustomIndicator
			ORDER BY K12SchoolIndicatorStatusId
		END
		ELSE
		BEGIN
			-- Run As Test (return data instead of inserting it)
			SELECT 
				q.K12SchoolIndicatorStatusId,
				@factTypeId AS DimFactTypeId,
				DimK12SchoolId,
				DimCountDateId,
				ISNULL(races.DimRaceId, -1) AS DimRaceId,				-- race
				ISNULL(idea.DimIdeaStatusId, -1) AS DimIdeaStatusId,				-- idea
				ISNULL(demo.DimK12DemographicId, -1) AS DimDemographicId,				-- lep
				--races.DimRaceId AS DimRaceId, 
				--idea.DimIdeaStatusId AS DimIdeaStatusId,
				--demo.DimDemographicId AS DimDemographicId,
				--ecodis.DimEcoDisStatusId AS DimEcoDisStatusId,
				--CASE WHEN q.AllStudentsCode = 'AllStudents' THEN 1 ELSE -1 END AS DimAllStudentsStatusId,		-- all students
				ISNULL(sdf.DimIndicatorStatusId, -1) AS DimIndicatorStatusId,				-- indicator status id
				ISNULL(indicator.DimStateDefinedStatusId, -1) AS DimStateDefinedStatusId,				-- state defined status
				1 AS OrganizationCount,
				ISNULL(customindicator.DimStateDefinedCustomIndicatorId, -1) AS DimStateDefinedCustomIndicatorId				-- custom indicator id
				,ISNULL(statustype.DimIndicatorStatusTypeId, -1) AS DimIndicatorStatusTypeId				-- indicator status type
			FROM #queryOutput q
			JOIN rds.DimIndicatorStatusTypes statustype ON statustype.IndicatorStatusTypeCode = q.IndicatorStatusTypeCode
			LEFT JOIN rds.DimRaces races ON races.RaceCode=q.Race
			LEFT JOIN rds.DimK12Demographics demo
				ON demo.EnglishLearnerStatusCode = q.LepStatusCode
				AND demo.EconomicDisadvantageStatusCode = q.EcoDisStatusCode
			LEFT JOIN rds.DimIdeaStatuses idea
				ON idea.PrimaryDisabilityTypeCode = q.DisabilityCode
			LEFT JOIN rds.DimIndicatorStatuses sdf ON sdf.IndicatorStatusCode=q.StateDefinedStatus
			LEFT JOIN rds.DimStateDefinedStatuses indicator ON indicator.StateDefinedStatusCode = q.Indicator
			LEFT JOIN rds.DimStateDefinedCustomIndicators customindicator ON customindicator.StateDefinedCustomIndicatorCode=q.CustomIndicator
			ORDER BY K12SchoolIndicatorStatusId
		END

		DROP table #queryOutput
		FETCH NEXT FROM indicatorstatustype_cursor INTO @IndicatorStatusType, @IndicatorStatusTypeId
	END
	
	CLOSE indicatorstatustype_cursor
	DEALLOCATE indicatorstatustype_cursor

COMMIT TRANSACTION
END TRY
/*
	RDS.Migrate_OrganizationStatusCounts @runAsTest=1
*/
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	DECLARE @msg AS NVARCHAR(MAX)
	SET @msg = ERROR_MESSAGE()
	DECLARE @sev AS INT
	SET @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
END CATCH
END