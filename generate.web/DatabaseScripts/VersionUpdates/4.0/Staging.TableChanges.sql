-- Staging table changes
----------------------------------
set nocount on
begin try
	begin transaction

	--CIID-4344
		--K12Organization
		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_CharterSchoolApprovalAgencyType'  AND Object_ID = Object_ID(N'Staging.K12Organization'))
		BEGIN

			ALTER TABLE Staging.K12Organization
			DROP COLUMN School_CharterSchoolApprovalAgencyType;

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