-- Release-Specific table changes for the App schema
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'TaskName' AND Object_ID = Object_ID(N'[App].[DataMigrationTasks]'))
		BEGIN
			ALTER TABLE [App].[DataMigrationTasks] ADD TaskName nvarchar(150) null
		END

	commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
