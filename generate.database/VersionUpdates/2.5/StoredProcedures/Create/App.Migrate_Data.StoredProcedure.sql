



CREATE PROCEDURE [App].[Migrate_Data]
AS
BEGIN

	BEGIN TRY
	
		set nocount on;

		-- Check to see if a migration is pending
		if not exists (select 1 from App.DataMigrations dm 
			inner join App.DataMigrationStatuses dms on dm.DataMigrationStatusId = dms.DataMigrationStatusId
			and dms.DataMigrationStatusCode = 'pending')
		BEGIN
			print 'No migrations pending'
			return;
		END

		-- Lookup statuses

		declare @processingStatusId as int
		select @processingStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'processing'

		declare @errorStatusId as int
		select @errorStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'error'

		declare @successStatusId as int
		select @successStatusId = DataMigrationStatusId from App.DataMigrationStatuses where DataMigrationStatusCode = 'success'
		

		-- Get IDs

		declare @dataMigrationId as int
		declare @dataMigrationTypeId as int
		declare @dataMigrationTypeCode as varchar(50)

		select @dataMigrationId = dm.DataMigrationId, @dataMigrationTypeId = dm.DataMigrationTypeId, @dataMigrationTypeCode = dmt.DataMigrationTypeCode
		from App.DataMigrations dm 
			inner join App.DataMigrationStatuses dms on dm.DataMigrationStatusId = dms.DataMigrationStatusId
			and dms.DataMigrationStatusCode = 'pending'
			inner join App.DataMigrationTypes dmt on dm.DataMigrationTypeId = dmt.DataMigrationTypeId

		-- Set migration to processing
		update app.DataMigrations
		set DataMigrationStatusId = @processingStatusId
		where DataMigrationId = @dataMigrationId
				

		-- Execute migration tasks

		DECLARE @storedProcedureName as nvarchar(2000)

		-- Pre
		--------------

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunBeforeGenerateMigration = 1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history

			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, @storedProcedureName)

			print 'exec ' + @storedProcedureName

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor


		-- Generate
		--------------

		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunBeforeGenerateMigration = 0 and RunAfterGenerateMigration = 0
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history

			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, @storedProcedureName)

			print 'exec ' + @storedProcedureName

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor



		-- Post
		--------------
	
		DECLARE dataMigrationTasks_cursor CURSOR FOR 
		SELECT StoredProcedureName
		FROM App.DataMigrationTasks
		WHERE IsActive = 1 and RunAfterGenerateMigration = 1
		and DataMigrationTypeId = @dataMigrationTypeId
		ORDER BY TaskSequence

		OPEN dataMigrationTasks_cursor
		FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Log migration history

			insert into App.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
			values
			(getutcdate(), @dataMigrationTypeId, @storedProcedureName)

			print 'exec ' + @storedProcedureName

			EXECUTE sp_executesql @storedProcedureName


			FETCH NEXT FROM dataMigrationTasks_cursor INTO @storedProcedureName
		END

		CLOSE dataMigrationTasks_cursor
		DEALLOCATE dataMigrationTasks_cursor



		-- Final
		--------------
		
		-- Set status to success and log duration

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

