﻿-- Release-Specific table changes for the App schema
-- e.g. new tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
	

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