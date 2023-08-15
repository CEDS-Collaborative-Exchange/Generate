set nocount on
begin try
	begin transaction

		IF NOT EXISTS ( SELECT  1 FROM  sys.schemas  WHERE  name = N'cedsv8' ) 
			EXEC('CREATE SCHEMA [cedsv8] AUTHORIZATION [dbo]');

		--DECLARE @sql NVARCHAR(MAX) = N'';

		--IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'ODS' and TABLE_TYPE = 'BASE TABLE' and TABLE_NAME NOT IN ('__EFMigrationsHistory','sysdiagrams'))
		--BEGIN

		--	SELECT @sql += N'
		--	ALTER SCHEMA dbo TRANSFER ODS.' 
		--	  + QUOTENAME(t.name) + ';' FROM sys.tables AS t
		--	  INNER JOIN sys.schemas AS s
		--	  ON t.[schema_id] = s.[schema_id]
		--	  WHERE s.name = N'ODS';

		--	--PRINT @sql;
		--	 EXEC sp_executesql @sql;

		-- END
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