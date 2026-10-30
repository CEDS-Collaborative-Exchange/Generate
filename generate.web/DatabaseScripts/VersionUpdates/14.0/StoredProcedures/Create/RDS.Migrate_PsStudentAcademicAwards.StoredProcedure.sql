CREATE PROCEDURE [RDS].[Migrate_FactPsStudentAcademicAwards]
@factTypeCode AS NVARCHAR(50),
@runAsTest AS BIT,
@dataCollectionName AS NVARCHAR(50) = NULL

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @dataCollectionId AS INT
	SELECT @dataCollectionId = DataCollectionId FROM dbo.DataCollection WHERE DataCollectionName = @dataCollectionName

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 1

	DECLARE @studentOrganizations as RDS.PsStudentOrganizationTableType 
	DECLARE @studentDates as RDS.PsStudentDateTableType 	


	---RunAsTest
	
	Declare @DataMigrationHistories as Table (
		  DataMigrationHistoryDate DateTime
		, DataMigrationTypeId INT
		, DataMigrationHistoryMessage Varchar(50))

-- Lookup VALUES
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactStudentCounts'
	DECLARE @migrationType AS VARCHAR(50)
	SET @migrationType='rds'

	
	-- Log history
	IF @runAsTest = 0
	BEGIN
		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
		Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Start (' + @factTypeCode + ')'
	END

-- Get Dimension Data
	----------------------------
	DECLARE @PsDimAward AS TABLE(
		DimPsStudentId INT,
		DimPsInstitutionId INT,
		DimCountDateId INT,
		DimPsAcademicAwardStatusId INT)

	BEGIN TRY
	
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

		IF @runAsTest = 0
		BEGIN
			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			----VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @schoolYear)
			Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @schoolYear
		END

		DELETE FROM @PsDimAward	
		DELETE FROM @studentOrganizations
		DELETE FROM @studentDates

		-- Migate_DimDates_Students

		INSERT INTO @studentDates
		(
			[DimPsStudentId],
			[PersonId],
			[DimSchoolYearId],
			[DimCountDateId],
			[CountDate],
			[SchoolYear],
			[SessionBeginDate],
			[SessionEndDate]
		)
		EXEC [RDS].[Migrate_DimDates_PsStudents] NULL, @dimSchoolYearId
		--EXEC [RDS].[Migrate_DimSchoolYears_PsStudents] NULL, @dimSchoolYearId

		IF @runAsTest = 1
		BEGIN
			PRINT 'studentDates'
			SELECT * FROM @studentDates
		END

		-------Get_PsStudentOrganizations
		
		IF @runAsTest = 0
		BEGIN
			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear)
			Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating PS Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
		END

		INSERT INTO @studentOrganizations
		(
			DimPsInstitutionId
		  ,	DimPsStudentId				
		  , DimDateId									
		  , PsInstitutionOrganizationId
		)
		SELECT DimPsInstitutionId,DimPsStudentId,DimCountDateId,PsInstitutionOrganizationId
		FROM [Get_PsStudentOrganizations] (@studentDates, @dataCollectionId, 0)
		--Migrate_PsStudentOrganizations]

		IF @runAsTest = 1
			BEGIN
				PRINT 'studentOrganizations'
				SELECT * FROM @studentOrganizations
			END

		END

		-- Migate_AcademicAwardStatuses

		IF @runAsTest = 0
		BEGIN
			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear)
			Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
		END

		INSERT INTO @PsDimAward
		(
			DimPsStudentId,
			DimPsInstitutionId,
			DimCountDateId,
			DimPsAcademicAwardStatusId
		) 
		EXEC [RDS].[Migrate_DimPsAcademicAwardStatuses] @studentDates,0,@studentOrganizations,@dataCollectionId
	
		IF @runAsTest = 1
			BEGIN
				PRINT 'PsDimAward'
				SELECT * FROM @PsDimAward
			END

	-- INSERT New Facts
		----------------------------

		-- Log history

		IF @runAsTest = 0
		BEGIN

			--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)
			Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear
		
			INSERT INTO [RDS].[FactPsStudentAcademicAwards]
			(
				PsInstitutionID,
				PsStudentId,
				AcademicAwardDateId,
				PsAcademicAwardStatusId
			)
			SELECT DISTINCT
				o.DimPsInstitutionId,
				o.DimPsStudentId,
				d.DimCountDateId,
				p.DimPsAcademicAwardStatusId
			FROM @PsDimAward p JOIN @studentOrganizations o
			ON p.DimPsStudentId = o.DimPsStudentId
			JOIN @studentDates d 
			ON d.DimCountDateId = p.DimCountDateId
		END
		ELSE
		BEGIN

			-- Run As Test (return data instead of inserting it)

			SELECT DISTINCT
				o.DimPsInstitutionId,
				o.DimPsStudentId,
				d.DimCountDateId,
				p.DimPsAcademicAwardStatusId
			FROM @PsDimAward p 
			JOIN @studentOrganizations o
				ON p.DimPsStudentId = o.DimPsStudentId
				AND p.DimCountDateId = o.DimDateId
				AND p.DimPsInstitutionId = o.DimPsInstitutionId
			JOIN @studentDates d 
				ON d.DimCountDateId = p.DimCountDateId
				AND p.DimPsStudentId = o.DimPsStudentId

		END		

		FETCH NEXT FROM selectedYears_cursor INTO @schoolYear, @dimSchoolYearId
	END TRY

	BEGIN CATCH

	--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900))
	END CATCH

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	IF EXISTS (SELECT  1 FROM tempdb.dbo.sysobjects o WHERE o.xtype IN ('U') AND o.id = object_id(N'tempdb..#queryOutput'))
	DROP TABLE #queryOutput

	SET NOCOUNT OFF;
END

