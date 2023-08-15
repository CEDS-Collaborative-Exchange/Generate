-- Release-Specific metadata for the ODS schema
-- e.g. new reference data
----------------------------------

set nocount on
begin try
 
	begin transaction

	------------------------
	-- Place code here
	------------------------

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
