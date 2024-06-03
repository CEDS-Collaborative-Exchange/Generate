CREATE PROCEDURE [App].[Migrate_Data]
AS
BEGIN

	BEGIN TRY
	
		set nocount on;

		declare @dataMigrationId as int
		declare @dataMigrationTypeId as int
		declare @dataMigrationTypeCode as varchar(50)
		declare @factTypeCode as varchar(50)
		declare @startDate as DateTime
		declare @endDate as DateTime
		declare @durationInSeconds as int

	
		-- Check to see if a migration is pending
		if not exists (select 1 from App.DataMigrations dm 
			inner join App.DataMigrationStatuses dms on dm.DataMigrationStatusId = dms.DataMigrationStatusId
			and dms.DataMigrationStatusCode = 'pending')
		BEGIN
			print 'No migrations pending'
			return;
		END

				
		select @dataMigrationId = dm.DataMigrationId, @dataMigrationTypeId = dm.DataMigrationTypeId, @dataMigrationTypeCode = dmt.DataMigrationTypeCode
		from App.DataMigrations dm 
			inner join App.DataMigrationStatuses dms on dm.DataMigrationStatusId = dms.DataMigrationStatusId
			and dms.DataMigrationStatusCode = 'pending'
			inner join App.DataMigrationTypes dmt on dm.DataMigrationTypeId = dmt.DataMigrationTypeId


		-- Shrink database log

		insert into App.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
		values
		(getutcdate(), @dataMigrationTypeId, 'Shrink database log')

		declare @logName as varchar(100)
		select @logName = name from sys.database_files where type_desc = 'LOG'

		declare @dbName as varchar(100)
		select @dbName = DB_NAME() 

		--This maintenance task is no longer necessary as we're having states put Generate in Simple recovery mode. 
		--DECLARE @maintenanceTask as nvarchar(2000)

		--set @maintenanceTask = '
		--set nocount on;
		---- Truncate the log by changing the database recovery model to SIMPLE.
		--ALTER DATABASE [' + @dbName + ']
		--SET RECOVERY SIMPLE;
		---- Shrink the truncated log file to 1 MB.
		--DBCC SHRINKFILE (''' + @logName + ''');
		---- Reset the database recovery model.
		--ALTER DATABASE [' + @dbName + ']
		--SET RECOVERY FULL;
		--'
		--EXECUTE sp_executesql @maintenanceTask

		-- Delete Old DataMigrationHistories

		insert into App.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
		values
		(getutcdate(), @dataMigrationTypeId, 'Delete old DataMigrationHistories')

		delete from app.DataMigrationHistories where DataMigrationHistoryDate <= dateadd(d, -30, GETDATE())

		-- Lookup statuses

		declare @processingStatusId as int
		select @processingStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'processing'

		declare @errorStatusId as int
		select @errorStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'error'

		declare @successStatusId as int
		select @successStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'success'
		

		-- Get IDs


		-- Set migration to processing
		update app.DataMigrations
		set DataMigrationStatusId = @processingStatusId
		where DataMigrationId = @dataMigrationId
				

		-- Execute migration tasks

		DECLARE @storedProcedureName as nvarchar(2000), @migrationTaskList as varchar(1000)
		DECLARE @sy as smallint
		DECLARE @taskSequence as int, @migrationTaskId as int

		-- Pre
		--------------

		SET @migrationTaskList = ''

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName, DataMigrationTaskId
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunBeforeGenerateMigration = 1 and IsSelected=1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @migrationTaskId

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history
			if not exists(select * from app.DataMigrationTypes where DataMigrationTypeCode= @dataMigrationTypeCode and DataMigrationTypeCode='report')
			begin
			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
				(getutcdate(), @dataMigrationTypeId, @storedProcedureName)
			end
			print 'exec ' + @storedProcedureName

			SET @migrationTaskList = @migrationTaskList + CAST(@migrationTaskId as varchar(10)) + ','

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @migrationTaskId
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor

		-- Source to Staging migration tasks
		-------------------------------------

		DECLARE source_task_cursor CURSOR FOR 
		select distinct CAST(sy.SchoolYear as smallint) as SY, ddt.StoredProcedureName, ddt.DataMigrationTaskId, ddt.TaskSequence
		from app.GenerateReports app
		inner join app.GenerateReport_FactType app_ft on app.GenerateReportId = app_ft.GenerateReportId
		inner join rds.DimFactTypes ft on app_ft.FactTypeId = ft.DimFactTypeId
		inner join app.DataMigrationTasks ddt on app_ft.FactTypeId = ddt.FactTypeId
		inner join app.DataMigrationTypes dmt on dmt.DataMigrationTypeId = ddt.DataMigrationTypeId
		inner join rds.DimSchoolYearDataMigrationTypes sydmt on dmt.DataMigrationTypeId = sydmt.DataMigrationTypeId
		inner join rds.DimSchoolYears sy on sydmt.DimSchoolYearId = sy.DimSchoolYearId
		where app.IsLocked = 1 and app.IsActive = 1 and ddt.IsSelected = 1 and dmt.DataMigrationTypeCode = 'ods'
		and ddt.IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0
		and sydmt.IsSelected = 1 and ddt.StoredProcedureName like '%Source-to-Staging%'
		order by ddt.TaskSequence, ddt.DataMigrationTaskId

		

		OPEN source_task_cursor
		FETCH NEXT FROM source_task_cursor INTO @sy , @storedProcedureName, @migrationTaskId, @taskSequence

		WHILE @@FETCH_STATUS = 0
		BEGIN
				-- Log migration history
				if not exists(select * from app.DataMigrationTypes 
				where DataMigrationTypeCode= @dataMigrationTypeCode and DataMigrationTypeCode='report')
				begin
					insert into App.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
					values
					(getutcdate(), @dataMigrationTypeId, @storedProcedureName)
				end
				print 'exec ' + @storedProcedureName

				SET @migrationTaskList = @migrationTaskList + CAST(@migrationTaskId as varchar(10)) + ','

				EXECUTE sp_executesql @storedProcedureName, N'@SchoolYear smallint', @SchoolYear = @sy

				FETCH NEXT FROM source_task_cursor INTO @sy , @storedProcedureName, @migrationTaskId, @taskSequence
		END
			

		CLOSE source_task_cursor
		DEALLOCATE source_task_cursor

		-- Staging Validation
		-------------------------------------------------------------------

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		select distinct CAST(sy.SchoolYear as int) as SY, ddt.StoredProcedureName, ddt.TaskSequence, ddt.DataMigrationTaskId, ft.FactTypeCode
		from app.GenerateReports app
		inner join app.GenerateReport_FactType app_ft on app.GenerateReportId = app_ft.GenerateReportId
		inner join rds.DimFactTypes ft on app_ft.FactTypeId = ft.DimFactTypeId
		inner join app.DataMigrationTasks ddt on app_ft.FactTypeId = ddt.FactTypeId
		inner join app.DataMigrationTypes dmt on dmt.DataMigrationTypeId = ddt.DataMigrationTypeId
		inner join rds.DimSchoolYearDataMigrationTypes sydmt on sydmt.DataMigrationTypeId = @dataMigrationTypeId
		inner join rds.DimSchoolYears sy on sydmt.DimSchoolYearId = sy.DimSchoolYearId
		where app.IsLocked = 1 and app.IsActive = 1 and ddt.IsSelected = 1 and dmt.DataMigrationTypeCode in ('StagingValidation')
		and ddt.IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0
		and sydmt.IsSelected = 1
		order by ddt.TaskSequence, ddt.DataMigrationTaskId

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @sy, @storedProcedureName, @taskSequence, @migrationTaskId, @factTypeCode

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history
			if not exists(select * from app.DataMigrationTypes where DataMigrationTypeCode= @dataMigrationTypeCode and DataMigrationTypeCode='report')
			begin
				insert into App.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
				values
				(getutcdate(), @dataMigrationTypeId, @storedProcedureName)
			end
			print 'exec ' + @storedProcedureName

			SET @migrationTaskList = @migrationTaskList + CAST(@migrationTaskId as varchar(10)) + ','

			EXECUTE sp_executesql @storedProcedureName, N'@SchoolYear int, @FactTypeOrReportCode varchar(50)', @SchoolYear = @sy, @FactTypeOrReportCode = @factTypeCode


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @sy, @storedProcedureName, @taskSequence, @migrationTaskId, @factTypeCode

		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor


		-- Generate
		--------------

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		select distinct ddt.StoredProcedureName, ddt.TaskSequence, ddt.DataMigrationTaskId
		from app.GenerateReports app
		inner join app.GenerateReport_FactType app_ft on app.GenerateReportId = app_ft.GenerateReportId
		inner join rds.DimFactTypes ft on app_ft.FactTypeId = ft.DimFactTypeId
		inner join app.DataMigrationTasks ddt on app_ft.FactTypeId = ddt.FactTypeId
		inner join app.DataMigrationTypes dmt on dmt.DataMigrationTypeId = ddt.DataMigrationTypeId
		inner join rds.DimSchoolYearDataMigrationTypes sydmt on dmt.DataMigrationTypeId = sydmt.DataMigrationTypeId
		inner join rds.DimSchoolYears sy on sydmt.DimSchoolYearId = sy.DimSchoolYearId
		where app.IsLocked = 1 and app.IsActive = 1 and ddt.IsSelected = 1 and dmt.DataMigrationTypeCode in ('rds', 'report')
		and ddt.IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0
		and sydmt.IsSelected = 1 and ddt.StoredProcedureName not like '%Source-to-Staging%'
		order by ddt.TaskSequence, ddt.DataMigrationTaskId

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @taskSequence, @migrationTaskId

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history
			if not exists(select * from app.DataMigrationTypes where DataMigrationTypeCode= @dataMigrationTypeCode and DataMigrationTypeCode='report')
			begin
			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, @storedProcedureName)
			end
			print 'exec ' + @storedProcedureName

			SET @migrationTaskList = @migrationTaskList + CAST(@migrationTaskId as varchar(10)) + ','

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @taskSequence, @migrationTaskId
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor


		-- Post
		--------------
	
		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName, DataMigrationTaskId
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunAfterGenerateMigration = 1 and IsSelected=1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @migrationTaskId

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history
			if not exists(select * from app.DataMigrationTypes where DataMigrationTypeCode= @dataMigrationTypeCode and DataMigrationTypeCode='report')
			begin
			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, @storedProcedureName)
			end
			print 'exec ' + @storedProcedureName

			SET @migrationTaskList = @migrationTaskList + CAST(@migrationTaskId as varchar(10)) + ','

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName, @migrationTaskId
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor

		-- Final-------------
		
		-- Set status to success and log duration

		declare @shouldMarkAsComplete as bit
		set @shouldMarkAsComplete = 1

		if @dataMigrationTypeCode = 'report'
		begin
			IF exists(select 1 from app.GenerateReports where IsLocked=1 and UseLegacyReportMigration = 0)
			begin 
				-- Do not complete if new report migrations are still pending
				set @shouldMarkAsComplete = 0
			end
		end

		if @shouldMarkAsComplete = 1
		begin

			

			select @startDate = LastTriggerDate from App.DataMigrations where DataMigrationId = @dataMigrationId
			set @endDate = getutcdate()

			set @durationInSeconds =  DateDiff(second, @startDate, @endDate)

			set @migrationTaskList = CASE WHEN RIGHT(@migrationTaskList,1)=',' THEN LEFT(@migrationTaskList,LEN(@migrationTaskList)-1) ELSE @migrationTaskList END

			update App.DataMigrations set DataMigrationStatusId = @successStatusId, LastDurationInSeconds = @durationInSeconds,
										  DataMigrationTaskList = @migrationTaskList
			where DataMigrationId = @dataMigrationId
	
			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, 'Migration Complete')

			print 'Migration Complete'

		end

	

		set nocount off;


	END TRY
	BEGIN CATCH

		set @migrationTaskList = CASE WHEN RIGHT(@migrationTaskList,1)=',' THEN LEFT(@migrationTaskList,LEN(@migrationTaskList)-1) ELSE @migrationTaskList END

		update App.DataMigrations set  DataMigrationTaskList = @migrationTaskList
		where DataMigrationId = @dataMigrationId

		update app.GenerateReports set IsLocked = 0

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH; 

END