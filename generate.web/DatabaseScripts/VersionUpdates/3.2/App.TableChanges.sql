-- Release-Specific table changes for the App schema
-- e.g. new tables/fields
----------------------------------
set nocount on
begin try
	begin transaction
		
		IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA ='App' AND TABLE_NAME='GenerateReports' AND COLUMN_NAME = 'UseLegacyReportMigration') 
		BEGIN

			ALTER TABLE App.GenerateReports ADD
				UseLegacyReportMigration bit NOT NULL CONSTRAINT DF_GenerateReports_UseLegacyReportMigration DEFAULT 1

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