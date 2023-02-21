CREATE PROCEDURE [App].[Migrate_Data]
AS
BEGIN

	BEGIN TRY
	
		set nocount on;

		declare @dataMigrationId as int
		declare @dataMigrationTypeId as int
		declare @dataMigrationTypeCode as varchar(50)

	
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

		DECLARE @storedProcedureName as nvarchar(2000)
		DECLARE @sy as smallint

		-- Pre
		--------------

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunBeforeGenerateMigration = 1 and IsSelected=1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

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

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor

		-- ODS migration tasks
		-------------------------------------

		IF (@dataMigrationTypeCode = 'ods')
		BEGIN

			DECLARE task_cursor CURSOR FOR 
			select years.SY, tasks.StoredProcedureName
			from
			(select CAST(d.SchoolYear as smallint) as SY from rds.DimSchoolYearDataMigrationTypes ddt
			inner join rds.DimDataMigrationTypes r on ddt.DataMigrationTypeId = r.DimDataMigrationTypeId
			inner join rds.DimSchoolYears d on ddt.DimSchoolYearId = d.DimSchoolYearId
			where r.DataMigrationTypeCode = 'ods' and ddt.IsSelected = 1) years
			CROSS JOIN (SELECT StoredProcedureName, TaskSequence
				FROM App.DataMigrationTasks
				WHERE IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0 and IsSelected=1
				and DataMigrationTypeId = @dataMigrationTypeId
				) tasks
			order by years.SY,tasks.TaskSequence asc

						

			OPEN task_cursor
			FETCH NEXT FROM task_cursor INTO @sy , @storedProcedureName

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

					EXECUTE sp_executesql @storedProcedureName, N'@SchoolYear smallint', @SchoolYear = @sy

				FETCH NEXT FROM task_cursor INTO @sy , @storedProcedureName
			END
			

			CLOSE task_cursor
			DEALLOCATE task_cursor

		END
		ELSE
		BEGIN

			-- Generate
			--------------

			DECLARE dataMigrationTasks_cursor CURSOR FOR 
			SELECT StoredProcedureName
			FROM App.DataMigrationTasks
			WHERE IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0 and IsSelected=1
			and DataMigrationTypeId = @dataMigrationTypeId 
			ORDER BY TaskSequence

			OPEN dataMigrationTasks_cursor
			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

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

				EXECUTE sp_executesql @storedProcedureName


				FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
			END

			CLOSE dataMigrationTasks_cursor
			DEALLOCATE dataMigrationTasks_cursor

		END

		-- Post
		--------------
	
		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunAfterGenerateMigration = 1 and IsSelected=1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

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

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
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

			declare @startDate as DateTime
			declare @endDate as DateTime

			select @startDate = LastTriggerDate from App.DataMigrations where DataMigrationId = @dataMigrationId
			set @endDate = getutcdate()

			declare @durationInSeconds as int
			set @durationInSeconds =  DateDiff(second, @startDate, @endDate)

			update App.DataMigrations set DataMigrationStatusId = @successStatusId, LastDurationInSeconds = @durationInSeconds
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

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH; 

END