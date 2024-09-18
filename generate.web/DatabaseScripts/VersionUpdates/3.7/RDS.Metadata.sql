-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction	

		Update rds.DimIdeaStatuses set DisabilityEdFactsCode = 'ID' where DisabilityCode = 'ID'

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