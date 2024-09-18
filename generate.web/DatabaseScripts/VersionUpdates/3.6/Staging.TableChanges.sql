-- Staging table changes
----------------------------------
set nocount on
begin try
	begin transaction

	--CIID-3855
		--PersonStatus
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'PerkinsLEPStatus'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			ALTER COLUMN PerkinsLEPStatus BIT;
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'PersonStatusId_PerkinsLEP'  AND Object_ID = Object_ID(N'Staging.PersonStatus'))
		BEGIN
			ALTER TABLE Staging.PersonStatus
			ADD PersonStatusId_PerkinsLEP int NULL
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