﻿-- Drop ODS Schema
----------------------------------
set nocount on
begin try
	begin transaction

		DECLARE @printString NVARCHAR(MAX)
		declare @schemaName as varchar(10)
		set @schemaName = 'ods'

		IF EXISTS(SELECT 1 
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'ods' and TABLE_TYPE = 'BASE TABLE' and TABLE_NAME NOT LIKE '__EFMigrationsHistory')
		BEGIN


			--drop all the ODS tables
			declare @sql nvarchar(max) = (
				select 
					'alter table ' + quotename(schema_name(schema_id)) + '.' +
					quotename(object_name(parent_object_id)) +
					' drop constraint '+quotename(name) + ';'
				from sys.foreign_keys
				where schema_name(schema_id) = @schemaName
				for xml path('') 
			);

			print 'dropping ods constraints'
			exec sp_executesql @sql;


			set @sql = ''

			SELECT @sql = 
				COALESCE(@sql, N'') + N'DROP TABLE [' + @schemaName + '].' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_SCHEMA = @schemaName and TABLE_TYPE = 'BASE TABLE' and TABLE_NAME NOT LIKE '__EFMigrationsHistory'
			order by TABLE_NAME

			print 'dropping ods tables'
			EXEC SP_EXECUTESQL @sql;

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