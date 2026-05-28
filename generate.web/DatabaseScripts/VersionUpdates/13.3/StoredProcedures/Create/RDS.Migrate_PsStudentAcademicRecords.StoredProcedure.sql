CREATE PROCEDURE [RDS].[Migrate_PsStudentAcademicRecords]
@factTypeCode AS NVARCHAR(50),
@runAsTest AS BIT,
@dataCollectionName AS NVARCHAR(50) = NULL

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @dataCollectionId AS INT
	SELECT @dataCollectionId = DataCollectionId FROM dbo.DataCollection WHERE DataCollectionName = @dataCollectionName

	DECLARE @useCutOffDate AS BIT
	SET @useCutOffDate = 0

	DECLARE @studentOrganizations as RDS.PsStudentOrganizationTableType 
	DECLARE @studentDates as RDS.PsStudentDateTableType 	


	---RunAsTest
	
	DECLARE @DataMigrationHistories as Table (
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

	DECLARE @organizationCalendarSession AS TABLE (
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, DimCountDateId							INT
		, DimOrganizationCalendarSessionId			INT
		, SessionCode								NVARCHAR(30)
		, AcademicTermDesignatorCode				NVARCHAR(50)
		, BeginDate									DATETIME
		, EndDate									DATETIME
	)

	DECLARE @PsEnrollmentStatusQuery AS TABLE (
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, DimDateId									INT
		, PostsecondaryExitOrWithdrawalTypeCode		NVARCHAR(50)
		, DimPsEnrollmentStatusId					INT
		, DimOrganizationCalendarSessionId			INT
	)

	DECLARE @PsInstitutionStatusQuery AS TABLE (
		  DimPsStudentId							INT
		, DimPsInstitutionId						INT
		, DimDateId									INT
		, DimPsInstitutionStatusId					INT
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
				----VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @dimSchoolYearId)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Start (' + @factTypeCode + ') for ' +  @schoolYear
			END

			DELETE FROM @studentOrganizations
			DELETE FROM @studentDates
			DELETE FROM @organizationCalendarSession
			DELETE FROM @PsInstitutionStatusQuery
			DELETE FROM @PsEnrollmentStatusQuery

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

		-------Get_PsStudentOrganizations
			IF @runAsTest = 1
			BEGIN
				PRINT 'studentDates'
				SELECT * FROM @studentDates
			END
			
			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @dimSchoolYearId)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @schoolYear
			END

			INSERT INTO @studentOrganizations
			(
				DimPsInstitutionId
			  ,	DimPsStudentId				
			  , DimDateId									
			  , PsInstitutionOrganizationId
			)
			SELECT DimPsInstitutionId,DimPsStudentId,DimCountDateId,PsInstitutionOrganizationId
			FROM [Get_PsStudentOrganizations] (@studentDates, @dataCollectionId,0)

			IF @runAsTest = 1
				BEGIN
					PRINT 'studentOrganizations'
					SELECT * FROM @studentOrganizations
				END

			-- Get_PsInstitutionStatus

			IF @runAsTest = 0
			BEGIN
				--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @dimSchoolYearId)
				Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
			END
	   	
			INSERT INTO @PsInstitutionStatusQuery 
			(
				DimPsStudentId,
				DimPsInstitutionId,
				DimDateId,
				DimPsInstitutionStatusId
			)
			EXEC [RDS].[Migrate_DimPsInstitutionStatuses] @studentDates, @studentOrganizations ,@dataCollectionId

			IF @runAsTest = 1
			BEGIN
				PRINT 'PsInstitutionStatusQuery'
				SELECT * FROM @PsInstitutionStatusQuery
			END

			-- Get_organizationCalendarSession
			IF @runAsTest = 0
				BEGIN
					--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @dimSchoolYearId)
					Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
				END

				INSERT INTO @organizationCalendarSession
				(    
					  DimPsStudentId							
					, DimPsInstitutionId						
					, DimCountDateId							
					, DimOrganizationCalendarSessionId			
					, SessionCode								
					, AcademicTermDesignatorCode				
					, BeginDate									
					, EndDate
				)
				EXEC [RDS].[Migrate_DimOrganizationCalendarSession] @studentDates,@useCutOffDate,@studentOrganizations,@dataCollectionId

			-- Get_PsEnrollmentStatus
			IF @runAsTest = 0
				BEGIN
					--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Migrating Schools for (' + @factTypeCode + ') -  ' +  @dimSchoolYearId)
					Insert Into @DataMigrationHistories Select getutcdate(), NULL, @factTable + ' - Migrating Institutions for (' + @factTypeCode + ') -  ' +  @schoolYear
				END

				INSERT INTO @PsEnrollmentStatusQuery
				(
					  DimPsStudentId							
					, DimPsInstitutionId						
					, DimDateId									
					, PostsecondaryExitOrWithdrawalTypeCode		
					, DimPsEnrollmentStatusId
					, DimOrganizationCalendarSessionId
				)
				EXEC [RDS].[Migrate_DimPsEnrollmentStatuses] @studentDates,@useCutOffDate,@studentOrganizations,@dataCollectionId

				-- INSERT New Facts
				----------------------------

				-- Log history

				IF @runAsTest = 0
				BEGIN

					--INSERT INTO RDS.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					--VALUES (getutcdate(), @dataMigrationTypeId, @factTable + ' - Inserting New Facts for (' + @factTypeCode + ') -  ' + @dimSchoolYearId)
		
					INSERT INTO rds.FactPsStudentAcademicRecords
					(
						  SchoolYearId
						 --,OrganizationCalendarSessionId
						 --,DimSeaId
						 ,PsInstitutionID
 						 ,PsStudentId
						 ,PsInstitutionStatuseId
						 ,PsEnrollmentStatusId
						 ,DataCollectionId
					)
					SELECT DISTINCT
						  sy.DimSchoolYearId
						--, o.DimOrganizationCalendarSessionId
						--, sch.DimSeaId
						, q.DimPsInstitutionID
						, q.DimPsStudentId
						, p.DimPsInstitutionStatusId
						, e.DimPsEnrollmentStatusId
						, @dataCollectionId
					FROM  @studentOrganizations q
					JOIN @studentDates s
						ON q.DimDateId = s.DimCountDateId
					JOIN rds.DimSchoolYears sy
						ON s.CountDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
					JOIN @PsInstitutionStatusQuery p
						ON p.DimPsInstitutionId = q.DimPsInstitutionId
						AND p.DimPsStudentId = q.DimPsStudentId
					JOIN @PsEnrollmentStatusQuery e
						ON p.DimPsInstitutionId = e.DimPsInstitutionId
						AND p.DimPsStudentId = e.DimPsStudentId
						AND q.DimOrganizationCalendarSessionId = e.DimOrganizationCalendarSessionId
			END
			ELSE
				BEGIN

					-- Run As Test (return data instead of inserting it)

						SELECT DISTINCT
						  sy.DimSchoolYearId
						--, o.DimOrganizationCalendarSessionId
						--, sch.DimSeaId
						, q.DimPsInstitutionID
						, q.DimPsStudentId
						, p.DimPsInstitutionStatusId
						, e.DimPsEnrollmentStatusId
						, @dataCollectionId
					FROM  @studentOrganizations q
					JOIN @studentDates s
						ON q.DimDateId = s.DimCountDateId
					JOIN rds.DimSchoolYears sy
						ON s.CountDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
					JOIN @PsInstitutionStatusQuery p
						ON p.DimPsInstitutionId = q.DimPsInstitutionId
						AND p.DimPsStudentId = q.DimPsStudentId
					JOIN @organizationCalendarSession o 
						ON p.DimPsInstitutionId = o.DimPsInstitutionId
						AND p.DimDateId = o.DimCountDateId
						AND p.DimPsStudentId = o.DimPsStudentId
					JOIN @PsEnrollmentStatusQuery e
						ON p.DimPsInstitutionId = e.DimPsInstitutionId
						AND p.DimPsStudentId = e.DimPsStudentId
						AND q.DimOrganizationCalendarSessionId = e.DimOrganizationCalendarSessionId

			END				

			FETCH NEXT FROM selectedYears_cursor INTO @schoolYear, @dimSchoolYearId
		END

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

	SET NOCOUNT OFF;
END

