set nocount on
begin try
	begin transaction

			 Update app.DataMigrationTasks set [Description] = 'Staging Migration - Implementation Step 13 - Discipline'
			 where DataMigrationTypeId = 1 and TaskSequence = 19

			 UPDATE app.CategoryOptions SET CategoryOptionCode = LTRIM(RTRIM(CategoryOptionCode))
			 
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