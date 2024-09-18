-- Release-Specific metadata for the ODS schema
-- e.g. new reference data
----------------------------------

set nocount on
begin try
 
	begin transaction
		
		If not exists(select 1 from ods.RefPersonStatusType where Code = 'Homeless')
		begin
			INSERT INTO [ODS].[RefPersonStatusType]([Description],[Code])
			VALUES('Homeless','Homeless')
		end

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
