IF EXISTS (SELECT 1
               FROM   INFORMATION_SCHEMA.COLUMNS
               WHERE  TABLE_NAME = 'DimCharterSchoolAuthorizers'
                      AND COLUMN_NAME = 'IsApproverAgency'
                      AND TABLE_SCHEMA='RDS')
  BEGIN
      ALTER TABLE rds.DimCharterSchoolAuthorizers
        DROP COLUMN IsApproverAgency
  END

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







