-- Release-Specific table changes for the ODS schema
-- e.g. changes to the CEDS data model
----------------------------------


set nocount on
begin try
 
	begin transaction

	------------------------
	-- Place code here
	------------------------

	
	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'FederalProgramCode' AND Object_ID = Object_ID(N'ODS.FinancialAccount'))
		begin

			Alter table ODS.FinancialAccount add FederalProgramCode nvarchar(10)												  

		
	End



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
