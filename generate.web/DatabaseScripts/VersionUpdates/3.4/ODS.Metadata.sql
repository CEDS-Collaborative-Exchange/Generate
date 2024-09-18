-- Metadata changes for the ODS schema
----------------------------------
set nocount on
begin try
	begin transaction

		IF NOT EXISTS(SELECT 1 FROM [ODS].[RefProgramType] WHERE Code = '77000')
		INSERT INTO [ODS].[RefProgramType]([Description],[Code],[Definition],[SortOrder])
		Values('Title III program', '77000', 'Title III program', 38)



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