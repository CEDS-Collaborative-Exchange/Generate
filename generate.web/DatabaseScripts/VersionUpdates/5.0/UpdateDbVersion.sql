-- Update database version in GenerateConfigurations
----------------------------------

set nocount on
begin try
	
	begin transaction

	update App.GenerateConfigurations set GenerateConfigurationValue = '5.0' where GenerateConfigurationCategory = 'Database' and GenerateConfigurationKey = 'DatabaseVersion'
	-- Reset Hydrate student count to 250,000 students rather than 50K.  We need more data!
	update app.GenerateConfigurations set GenerateConfigurationValue = '250000' where GenerateConfigurationKey = 'StudentCount'

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