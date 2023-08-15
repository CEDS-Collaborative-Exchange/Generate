CREATE PROCEDURE [dbo].[Migrate_DimPersonnel_adhoc]
@SchoolYear smallint
AS
BEGIN

	SET NOCOUNT ON;

	begin try
		begin transaction
			WAITFOR DELAY '00:00:45' 
			print 'delayed'
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


	SET NOCOUNT OFF;

END


