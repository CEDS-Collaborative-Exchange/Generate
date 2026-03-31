
CREATE PROCEDURE [Utilities].[LoadSubmissionFileTable] 
		@TargetTableName varchar(100),
		@SourceFilePathAndName varchar(500),
		@FileType varchar(5) = NULL, -- This is optional.  If NULL then this is set to 'TAB'.  'CSV' is the other valid option.
		@ShowSQL bit  -- If this = 1 then the SQL will be returned rather than executing the SQL

		-- NOTE: Bulk Insert of CSV is only supported in SQL Server 2017 and above

AS
BEGIN

/****************************************************************************************
AEM Inc.
CIID Generate Team
November 21, 2022

This procedure creates a table for the specified file submission report code and report
level and loads data from the specified file using SQL Bulk Insert.

This assumes the file format corresonds to the ReportCode, and that the Bulk Insert
capability is available.

The file will be named as follows: [@SchemaName].[@ReportCode_@ReportLevel_@SubmissionYear + optional '_Label']

UPDATED
March 15, 2023 - Added logic to delete header row from target table

*****************************************************************************************/

	select @FileType = isnull(@FileType, 'Tab')

	-- LOAD THE TABLE --
	declare 
		@InsertSQL varchar(max),
		@DeleteSQL varchar(max)
		
	select @InsertSQL = 'BULK INSERT ' + @TargetTableName + char(10)
	select @InsertSQL = @InsertSQL + 'FROM ' + '''' + @SourceFilePathAndName + ''''

	if @FileType = 'CSV'
		begin
            select @InsertSQL = @InsertSQL + ' WITH (FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'');' + char(10)

			--select @InsertSQL = @InsertSQL + ' WITH (FORMAT = ''CSV'')' + char(10)

		end

	-- SQL TO DELETE HEADER ROW
	select @DeleteSQL = 'DELETE FROM ' + @TargetTableName + char(10)
	select @DeleteSQL = @DeleteSQL + 'WHERE isnumeric(FileRecordNumber) = 0' + char(10)

	
	if @ShowSQL = 1
		begin
			select 'INSERT SQL', @InsertSQL
			select 'DELETE HEADER ROW SQL', @DeleteSQL
			return
		end


	begin try
		exec (@InsertSQL)
		insert into App.DataMigrationHistories select getdate(), @TargetTableName + ' Loaded', 4
	end try
	begin catch
		insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO LOAD TABLE ' + isnull(@TargetTableName,''), 4
		print 'FAILED TO LOAD TABLE ' + isnull(@TargetTableName,'') + ' - ' + ERROR_MESSAGE()
	end catch

	-- DELETE HEADER ROW FROM TABLE ------------------

	begin try
		exec (@DeleteSQL)
		insert into App.DataMigrationHistories select getdate(), 'Header row deleted from ' + @TargetTableName, 4
	end try
	begin catch
		insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO DELETE HEADER ROW FROM TABLE ' + isnull(@TargetTableName,''), 4
		print 'FAILED TO DELETE HEADER ROW FROM TABLE ' + isnull(@TargetTableName,'') + ' - ' + ERROR_MESSAGE()
	end catch

end