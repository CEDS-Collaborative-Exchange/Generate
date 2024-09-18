DECLARE @jobId binary(16)
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'MigrateData-Generate')

EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'MigrateData-Generate', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT


EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Migrate_Data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec App.Migrate_Data', 
		@database_name=N'generate', 
		@flags=0

	
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'RunMigration', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20160802, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959



EXEC msdb.dbo.sp_add_jobserver @job_name = N'MigrateData-Generate'
