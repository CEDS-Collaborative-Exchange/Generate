DECLARE @jobId binary(16)
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'MigrateData-Generate')
IF (@jobId IS NOT NULL)
BEGIN
    EXEC msdb.dbo.sp_delete_job @jobId
END