CREATE PROCEDURE [RDS].[Migrate_PsStudentEnrollments]
	@factTypeCode AS NVARCHAR(50),
	@dataCollectionName AS NVARCHAR(50) = NULL,
	@snapshotDate AS DATETIME,
	@runAsTest AS BIT,
	@loadAllForDataCollection AS BIT
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @dataCollectionId AS INT
	SELECT @dataCollectionId = DataCollectionId FROM dbo.DataCollection WHERE DataCollectionName = @dataCollectionName

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 1

	--RunAsTest
	Declare @DataMigrationHistories as Table (
		  DataMigrationHistoryDate DateTime
		, DataMigrationTypeId INT
		, DataMigrationHistoryMessage Varchar(2000)
	)

	-- Lookup VALUES
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'Reporting'
	DECLARE @migrationType AS VARCHAR(50)
	SET @migrationType='rds'

	--DECLARE @dataMigrationTypeId AS INT
	--SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	--FROM RDS.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	

	-- Log history
	IF @runAsTest = 0
	BEGIN
		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
		Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Start (' + @factTypeCode + ')'
	END


	-- Get Dimension Data
	----------------------------
	
	DECLARE @studentDateQuery AS rds.PsStudentDateTableType --SELECT COUNT(*) FROM  @studentDateQuery 
	DECLARE @PsInstitutionQuery AS rds.PsStudentOrganizationTableType

	DECLARE @schoolYearQuery AS TABLE (
		  DimSchoolYearId							INT
		, SchoolYear								NCHAR(4)
	)

	DECLARE @dataCollectionQuery AS TABLE (
		  DimCollectionId							INT
		, DataCollectionName						NVARCHAR(100)
	)

	DECLARE @PsEnrollmentStatusQuery AS TABLE (
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, DimCountDateId							INT
		, DimSchoolYearid							INT
		, PostsecondaryExitOrWithdrawalTypeCode		NVARCHAR(50)
		, DimPsEnrollmentStatusId					INT
		, DimOrganizationCalendarSessionId			INT
	)
	
	DECLARE @PsInstitutionStatusQuery AS TABLE (
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, DimDateId									INT
		, DimPsInstitutionStatusId					INT
		, MostPrevalentLevelOfInstitutionCode		NVARCHAR(100)
	)

	DECLARE @enrollmentDatesQuery AS TABLE (	
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, PersonId									INT
		, DimDateId									INT
		, DimEntryDateId							INT
		, DimExitDateId								INT
		, DimExpectedGraduationDateId				INT
	)

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
	

			DELETE FROM @studentDateQuery
			DELETE FROM @dataCollectionQuery
			DELETE FROM @schoolYearQuery
			DELETE FROM @PsInstitutionQuery
			DELETE FROM @PsEnrollmentStatusQuery
			DELETE FROM @PsInstitutionStatusQuery

			-- Migrate_DimDates_Students

			INSERT INTO @studentDateQuery
			(
				[DimPsStudentId],
				[PersonId],
				[DimSchoolYearId],
				[DimCountDateId],
				[CountDate],
				[SchoolYear],
				[SessionBeginDate],
				[SessionEndDate],
				[RecordStartDateTime],
				[RecordEndDateTime]
			)
			EXEC rds.Migrate_DimSchoolYears_PsStudents @factTypeCode, @migrationType, @dimSchoolYearId, 0, @dataCollectionId, @loadAllForDataCollection

			IF @runAsTest = 1
			BEGIN
				PRINT 'studentDateQuery'
				SELECT COUNT(*) FROM  @studentDateQuery
			END

			-- Get_PsStudentOrganizations

			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear
			END
	   	
			INSERT INTO @PsInstitutionQuery 
			(
				  DimPsStudentId
				, PersonId
				, DimDateId
				, DimPsInstitutionId
				, PsInstitutionOrganizationId 
				, DimOrganizationCalendarSessionId
				, DimAcademicTermDesignatorId
				, OrganizationPersonRoleId
			)
			EXEC [RDS].[Migrate_PsStudentOrganizations] @studentDateQuery, @dataCollectionId, 0, @loadAllForDataCollection

			IF @runAsTest = 1
			BEGIN
				PRINT 'PsInstitutionQuery'
				SELECT COUNT(*) FROM  @PsInstitutionQuery
			END

			-- Get_PsInstitutionStatus

			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
			END
	   	
			INSERT INTO @PsInstitutionStatusQuery 
			(
				DimPsStudentId,
				DimPsInstitutionId,
				DimDateId,
				DimPsInstitutionStatusId,
				MostPrevalentLevelOfInstitutionCode
			)
			EXEC [RDS].[Migrate_DimPsInstitutionStatuses] @studentDateQuery, @PsInstitutionQuery ,@dataCollectionId

			IF @runAsTest = 1
			BEGIN
				PRINT 'PsInstitutionStatusQuery'
				SELECT COUNT(*) FROM  @PsInstitutionStatusQuery
			END

			-- Migrate_DimSchoolYears

			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating School Year Dimension for (' + @factTypeCode + ') - ' +  @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating School Year Dimension for (' + @factTypeCode + ') - ' +  @schoolYear
			END
	
			-- Migrate_DimPsEnrollmentStatuses
	
			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating PsStudent Enrollment Dimension for (' + @factTypeCode + ') -  ' +  @schoolYear
			END
	
			INSERT INTO @PsEnrollmentStatusQuery
			(
				  DimPsStudentId
				, DimPsInstitutionId
				, DimCountDateId
				, DimSchoolYearid
				, PostsecondaryExitOrWithdrawalTypeCode
				, DimPsEnrollmentStatusId
				, DimOrganizationCalendarSessionId			
			)
			EXEC rds.[Migrate_DimPsEnrollmentStatuses] @studentDateQuery, @useCutOffDate, @PsInstitutionQuery, @dataCollectionId, @loadAllForDataCollection

			IF @runAsTest = 1
			BEGIN
				PRINT 'PsStudentEnrollmentStatusQuery'
				SELECT COUNT(*) FROM  @PsEnrollmentStatusQuery
			END


			-- INSERT New Facts
			----------------------------

			-- Log history

			IF @runAsTest = 0
			BEGIN

				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @schoolYear
		
				INSERT INTO rds.FactPsStudentEnrollments
				(
					  SchoolYearId
					, EntryDateId
					, ExitDateId
					, PsEnrollmentStatusId
					, PsInstitutionStatusId
					, PsInstitutionID
					, PsStudentId
					, DataCollectionId
				)
				SELECT DISTINCT
					  sy.DimSchoolYearId
					, ISNULL(dates.DimEntryDateId, -1) AS DimEntryDateId
					, ISNULL(dates.DimExitDateId, -1) AS DimExitDateId
					, ISNULL(psenStatus.DimPsEnrollmentStatusId, -1) AS DimPsEnrollmentStatusId
					, ISNULL(psiStatus.DimPsInstitutionStatusId, -1) AS DimPsInstitutionStatusId
					, ISNULL(psi.DimPsInstitutionId, -1) AS DimPsInstitutionId
					, q.DimPsStudentId
					, dc.DimDataCollectionId as DimCollectionId
				FROM @studentDateQuery q
				JOIN @PsInstitutionQuery psi
					ON q.DimPsStudentId = psi.DimPsStudentId
					AND q.DimCountDateId = psi.DimDateId
				JOIN rds.DimSchoolYears sy
					ON q.CountDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
				JOIN rds.DimDataCollections dc
					ON dc.SourceSystemDataCollectionIdentifier = @dataCollectionId
				LEFT JOIN @PsEnrollmentStatusQuery psenStatus
					ON psi.DimPsStudentId = psenStatus.DimPsStudentId
					AND psi.DimPsInstitutionId = psenStatus.DimPsInstitutionId
					AND psi.DimDateId = psenStatus.DimCountDateId
				LEFT JOIN @PsInstitutionStatusQuery psiStatus
					ON psi.DimPsStudentId = psiStatus.DimPsStudentId
					AND psi.DimPsInstitutionId = psiStatus.DimPsInstitutionId
					AND psi.DimDateId = psiStatus.DimDateId
				LEFT JOIN @enrollmentDatesQuery dates
					ON psi.DimPsStudentId = dates.DimPsStudentId
					AND psi.DimPsInstitutionId= dates.DimPsInstitutionId
					AND psi.DimDateId = dates.DimDateId

			
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @schoolYear)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Inserted New Facts for (' + @factTypeCode + ') -  ' + @schoolYear

			END
			ELSE
			BEGIN

				-- Run As Test (return data instead of inserting it)
				SELECT DISTINCT
					  sy.DimSchoolYearId
					, ISNULL(dates.DimEntryDateId, -1) AS DimEntryDateId
					, ISNULL(dates.DimExitDateId, -1) AS DimExitDateId
					, ISNULL(psenStatus.DimPsEnrollmentStatusId, -1) AS DimPsEnrollmentStatusId
					, ISNULL(psiStatus.DimPsInstitutionStatusId, -1) AS DimPsInstitutionStatusId
					, ISNULL(psi.DimPsInstitutionId, -1) AS DimPsInstitutionId
					, q.DimPsStudentId
					, dc.DimDataCollectionId as DimCollectionId
				FROM @studentDateQuery q
				JOIN @PsInstitutionQuery psi
					ON q.DimPsStudentId = psi.DimPsStudentId
					AND q.DimCountDateId = psi.DimDateId
				JOIN rds.DimSchoolYears sy
					ON q.CountDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
				JOIN rds.DimDataCollections dc
					ON dc.SourceSystemDataCollectionIdentifier = @dataCollectionId
				LEFT JOIN @PsEnrollmentStatusQuery psenStatus
					ON psi.DimPsStudentId = psenStatus.DimPsStudentId
					AND psi.DimPsInstitutionId = psenStatus.DimPsInstitutionId
					AND psi.DimDateId = psenStatus.DimCountDateId
				LEFT JOIN @PsInstitutionStatusQuery psiStatus
					ON psi.DimPsStudentId = psiStatus.DimPsStudentId
					AND psi.DimPsInstitutionId = psiStatus.DimPsInstitutionId
					AND psi.DimDateId = psiStatus.DimDateId
				LEFT JOIN @enrollmentDatesQuery dates
					ON psi.DimPsStudentId = dates.DimPsStudentId
					AND psi.DimPsInstitutionId= dates.DimPsInstitutionId
					AND psi.DimDateId = dates.DimDateId


			END

			FETCH NEXT FROM selectedYears_cursor INTO @schoolYear, @dimSchoolYearId
		END

	END TRY

	BEGIN CATCH

		--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))
		Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Error Occurred' + CAST(ERROR_MESSAGE() AS VARCHAR(900))
		SELECT COUNT(*) FROM  @DataMigrationHistories
	END CATCH

	IF CURSOR_STATUS('global','selectedYears_cursor') >= 0 
	BEGIN
		close selectedYears_cursor
		deallocate selectedYears_cursor 
	END

	SET NOCOUNT OFF;

END