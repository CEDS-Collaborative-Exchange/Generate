CREATE PROCEDURE [Utilities].[CreateSnapshotFromStaging]
	@SchoolYear smallint,
	@ReportCode varchar(3),
	@ShowSQL bit = 0
AS
BEGIN
	/*
		This procedure creates a snapshot of all staging tables specific to the @ReportCode into the Source schema.
		This can be executed at the end of an ETL, or anytime the State wants to make a snapshot of staging data

		The procedure will create the snapshot tables if they do not exist and will insert/overwrite data for the specified
		@SchoolYear value in that table.

		Use Case 1:
		States can opt to use these Snapshot tables as the source for Directory data needed for subsequent
		report ETLs rather than pulling from the state's source systems.  This will improve efficiency and assure
		that the Directory information matches what was submitted in C029.

		Use Case 2:
		ETL Developers can use the snapshot data for historical comparison to new Staging data that was recently loaded

		Schema-drift handling (CIID-8107):
		Staging tables gain, lose, or rename columns on Generate version upgrades.  When a Source snapshot table already exists and its
		columns no longer match Staging, the snapshot INSERT used to fail.  This procedure now reconciles an existing
		Source table to Staging's current columns before inserting:
			STEP 1 - Apply recorded column RENAMES from app.StagingSchemaChange (same-table only), so a rename carries
			         its data across instead of being treated as a drop-plus-add.  Guarded by COL_LENGTH so it renames only when needed,
			         which makes it safe to run repeatedly and on sites several versions behind.
			STEP 2 - Add any column present in Staging but missing from Source (as NULL).  Existing rows keep NULL.
			         Columns dropped from Staging are intentionally left in Source; archival data is never dropped here.
			STEP 3 - Build an explicit column list from the current Staging columns and use it in the INSERT instead of
			         SELECT *, so the statement survives drift.
		A brand-new Source table is still created with SELECT * INTO, which mirrors Staging exactly, so it needs no
		reconciliation.

		Possible Enhancements:
		1. We could pass in a parameter to indicate whether to overwrite existing snapshot data for the @SchoolYear, or
		   retain it and include a label so that multiple versions of snapshot data may exist for the same year.  This 
		   could be valuable when debugging ETLs.
		2. Extend app.StagingSchemaChange / STEP 2 to also apply type and length changes (NewDataDefinition hook).
		3. Auto-apply cross-table moves (OldTableName <> NewTableName), which are currently recorded but not applied.
	*/
	set NOCOUNT ON

	insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 4, 'CreateSnapshotFromStaging for ' + @ReportCode + ' - STARTED')

	declare 
		@SQL varchar(max) = '', 
		@Error varchar(max) = '',
		@TableName varchar(128) = '',
		@SnapshotDate varchar(100) = (select convert(varchar, getdate(), 23)),
		@ColumnList varchar(max) = '',       -- explicit Staging column list (STEP 3)
		@OldCol sysname,                      -- rename: name before (STEP 1)
		@NewCol sysname,                      -- rename: name after / new column name (STEP 1 and 2)
		@RenameObj nvarchar(400),             -- 'Source.<table>.<oldcol>' for sp_rename
		@ColType nvarchar(200),               -- reconstructed type for a missing column (STEP 2)
		@AddColSQL nvarchar(max),             -- ALTER TABLE ... ADD statement (STEP 2)
		@RowOrder int                         -- current row being applied from #Renames (STEP 1)

	--check that the @ReportCode value is valid
	if len(@ReportCode) <> 3 or @ReportCode like '%[^0-9]%'
	begin
		print 'Invalid ReportCode value passed in, use only the 3 digit file specification number';

		insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values	(getutcdate(), 4, 'Invalid ReportCode value passed in, only use the 3 digit file specification number')

		return
	end

	-- SET TABLES TO BE INCLUDED IN THE SNAPSHOT IN THIS SECTION -----------------------
	IF OBJECT_ID(N'tempdb..#StagingTables') IS NOT NULL DROP TABLE #StagingTables
	create table #StagingTables (
		TableName varchar(128)
		)

	insert into #StagingTables (TableName)
	select 
		agst.StagingTableName 
	from app.GenerateReports agr
	inner join app.GenerateReport_GenerateStagingXREF x
		on agr.GenerateReportId = x.GenerateReportId
	inner join app.GenerateStagingTables agst
		on agst.StagingTableId = x.StagingTableId
	where agr.ReportCode = @ReportCode
	--------------------------------------------------------------------------------------

	-- Working temp tables used by the per-table drift handling below
	IF OBJECT_ID(N'tempdb..#Renames') IS NOT NULL DROP TABLE #Renames
	create table #Renames (
		RowOrder int identity(1,1),
		NewGenerateVersion varchar(12),
		SchemaChangeId int,
		OldColumnName sysname,
		NewColumnName sysname
		)

	IF OBJECT_ID(N'tempdb..#MissingColumns') IS NOT NULL DROP TABLE #MissingColumns
	create table #MissingColumns (
		ColumnName sysname,
		ColumnDefinition nvarchar(400)
		)

	-- Loop through list of tables and create a snapshot for each one	
	select @TableName = (select top 1 TableName from #StagingTables)
	while @TableName is not null 
	begin
		select @ColumnList = ''

		------------------------------------------------------------------------------
		-- DRIFT HANDLING
		-- Only when the Source table already exists and this is a real run (@ShowSQL = 0), not just printing the SQL.
		-- A brand-new Source table is created by SELECT * INTO below and already
		-- mirrors Staging exactly, so it needs no reconciliation.
		------------------------------------------------------------------------------
		if @ShowSQL = 0 and OBJECT_ID('Source.' + @TableName) is not null
		begin
			begin try
				------------------------------------------------------------------
				-- STEP 1: Rename columns on the Source snapshot table so they match Staging.
				-- Only same-table renames are applied (OldTableName = NewTableName).
				--
				-- How the guard works, and why re-running is safe:
				--   COL_LENGTH('Source.<table>', '<column>') returns a value if the column exists,
				--   or NULL if it does not.  A rename is applied only when BOTH are true:
				--     - the OLD column name still exists on Source   (COL_LENGTH ... IS NOT NULL)
				--     - the NEW column name does not exist yet        (COL_LENGTH ... IS NULL)
				--   First run:  the old name is present and the new one is not, so the rename happens.
				--   Later runs: the old name is already gone, so the guard is false and nothing happens.
				--   Running the procedure repeatedly therefore cannot double-rename or raise an error.
				--
				-- Rows are applied in numeric version order (major, then minor), then by the order recorded (SchemaChangeId), so a
				-- column renamed over several versions reaches its final name in a single pass.  Parsing
				-- the version as numbers rather than text keeps 100.1 and 14.10 ordered correctly.
				------------------------------------------------------------------
				delete from #Renames

				insert into #Renames (SchemaChangeId, NewGenerateVersion, OldColumnName, NewColumnName)
				select ssc.SchemaChangeId, ssc.NewGenerateVersion, ssc.OldColumnName, ssc.NewColumnName
				from app.StagingSchemaChange ssc
				where ssc.ChangeType = 'RenameColumn'
				  and ssc.OldTableName = @TableName
				  and ssc.NewTableName = @TableName          -- same-table only

				while exists (select 1 from #Renames)
				begin
					-- Pick the next rename in (version, sort) order.  We order here at
					-- read time rather than trusting the identity RowOrder, because
					-- INSERT...SELECT...ORDER BY does not guarantee identity order.
					select top 1 @RowOrder = RowOrder, @OldCol = OldColumnName, @NewCol = NewColumnName
					from #Renames
					order by try_cast(parsename(NewGenerateVersion, 2) as int),  -- major
					         try_cast(parsename(NewGenerateVersion, 1) as int),  -- minor
					         SchemaChangeId

					if COL_LENGTH('Source.' + @TableName, @OldCol) is not null
					   and COL_LENGTH('Source.' + @TableName, @NewCol) is null
					begin
						set @RenameObj = 'Source.' + @TableName + '.' + @OldCol
						exec sp_rename @objname = @RenameObj, @newname = @NewCol, @objtype = 'COLUMN'

						insert into app.DataMigrationHistories
							(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
							values (getutcdate(), 4, 'CreateSnapshotFromStaging: renamed Source.' + @TableName + '.' + @OldCol + ' to ' + @NewCol)
					end

					delete from #Renames where RowOrder = @RowOrder
				end

				------------------------------------------------------------------
				-- STEP 2: Add any column that Staging has but Source does not yet have.
				--
				-- Why: a version upgrade can add new columns to a Staging table.  If Source is missing
				-- one of them, the INSERT further below would fail.  So we compare the two tables'
				-- columns (via INFORMATION_SCHEMA) and, for each column in Staging but not in Source,
				-- add it to Source as a NULLable column (rebuilding its data type from Staging).
				--   - Existing Source rows get NULL for the newly added column.
				--   - Columns that Staging dropped are left in place on Source; this procedure never
				--     drops Source columns, so archival data is preserved.
				------------------------------------------------------------------
				delete from #MissingColumns

				insert into #MissingColumns (ColumnName, ColumnDefinition)
				select
					s.COLUMN_NAME,
					s.DATA_TYPE +
					case
						when s.DATA_TYPE in ('char','varchar','nchar','nvarchar','binary','varbinary')
							then '(' + case when s.CHARACTER_MAXIMUM_LENGTH = -1 then 'max'
											else cast(s.CHARACTER_MAXIMUM_LENGTH as varchar(10)) end + ')'
						when s.DATA_TYPE in ('decimal','numeric')
							then '(' + cast(s.NUMERIC_PRECISION as varchar(10)) + ',' + cast(s.NUMERIC_SCALE as varchar(10)) + ')'
						when s.DATA_TYPE in ('datetime2','datetimeoffset','time')
							then '(' + cast(s.DATETIME_PRECISION as varchar(10)) + ')'
						else ''
					end
				from INFORMATION_SCHEMA.COLUMNS s
				where s.TABLE_SCHEMA = 'Staging'
				  and s.TABLE_NAME = @TableName
				  and not exists (
						select 1 from INFORMATION_SCHEMA.COLUMNS d
						where d.TABLE_SCHEMA = 'Source'
						  and d.TABLE_NAME = @TableName
						  and d.COLUMN_NAME = s.COLUMN_NAME)

				while exists (select 1 from #MissingColumns)
				begin
					select top 1 @NewCol = ColumnName, @ColType = ColumnDefinition
					from #MissingColumns

					set @AddColSQL = 'ALTER TABLE Source.' + quotename(@TableName) + ' ADD ' + quotename(@NewCol) + ' ' + @ColType + ' NULL'
					exec sp_executesql @AddColSQL

					insert into app.DataMigrationHistories
						(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
						values (getutcdate(), 4, 'CreateSnapshotFromStaging: added column ' + @NewCol + ' ' + @ColType + ' to Source.' + @TableName)

					delete from #MissingColumns where ColumnName = @NewCol
				end
			end try
			begin catch
				select @Error = ERROR_MESSAGE()
				insert into app.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage)
					values	(getutcdate(), 4, '   ERROR reconciling schema for Source.' + @TableName + '.  ' + @Error)
			end catch
		end

		------------------------------------------------------------------------------
		-- STEP 3: Build the exact list of columns to copy, from the CURRENT Staging columns
		-- (in their defined order).
		--
		-- Why: the original procedure used SELECT *, which only works when Source and Staging
		-- have the same columns in the same order.  After STEPS 1 and 2 every current Staging
		-- column exists in Source, so naming the columns explicitly lets the INSERT succeed even
		-- when the tables have drifted, and any column Staging dropped is simply left out.
		-- (STRING_AGG, used to build the list, requires SQL Server 2017 or later.)
		------------------------------------------------------------------------------
		select @ColumnList = string_agg(quotename(COLUMN_NAME), ', ') within group (order by ORDINAL_POSITION)
		from INFORMATION_SCHEMA.COLUMNS
		where TABLE_SCHEMA = 'Staging' and TABLE_NAME = @TableName

		------------------------------------------------------------------------------
		-- Build the snapshot SQL for this table.
		------------------------------------------------------------------------------
		select @SQL = 'IF OBJECT_ID(''Source.' + @TableName +''') is null' + char(10)
		select @SQL += 'BEGIN' + char(10)
		-- New Source table: SELECT * INTO mirrors the current Staging columns exactly.
		select @SQL += char(9) + 'SELECT ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @ReportCode + ''' as SnapshotReportCode, ' + char(10)
		select @SQL += char(9) + char(9) + convert(varchar, @SchoolYear) + ' as SnapshotSchoolYear, ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @SnapshotDate + ''' as SnapshotDate,' + char(10)
		select @SQL += char(9) + char(9) + '*' + char(10)
		select @SQL += char(9) + 'INTO Source.' + @TableName + char(10)
		select @SQL += char(9) + 'FROM Staging.' + @TableName + char(10)
		select @SQL += char(9) + 'UNION ALL -- This little UNION trick removes the Identify from the ID column in the new table so future inserts will work' + char(10)
		select @SQL += char(9) + 'SELECT ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @ReportCode + ''' as SnapshotReportCode, ' + char(10)
		select @SQL += char(9) + char(9) + convert(varchar, @SchoolYear) + ' as SnapshotSchoolYear, ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @SnapshotDate + ''' as SnapshotDate,' + char(10)
		select @SQL += char(9) + char(9) + '*' + char(10)
		select @SQL += char(9) + 'FROM Staging.' + @TableName + char(10)
		select @SQL += char(9) + 'WHERE 1 = 0' + char(10)
		select @SQL += 'END' + char(10)
		select @SQL += 'ELSE' + char(10)
		select @SQL += 'BEGIN' + char(10)
		select @SQL += char(9) + 'DELETE FROM Source.' + @TableName + char(10)
		select @SQL += char(9) + 'WHERE SnapshotReportCode = ''' + @ReportCode + '''' + char(10) + char(10)
		select @SQL += char(9) + 'AND SnapshotSchoolYear = ' + convert(varchar, @SchoolYear) + char(10) + char(10)
		-- Existing Source table: explicit column list so drift never breaks the INSERT.
		select @SQL += char(9) + 'INSERT INTO Source.' + @TableName + ' (SnapshotReportCode, SnapshotSchoolYear, SnapshotDate, ' + @ColumnList + ')' + char(10)
		select @SQL += char(9) + 'SELECT ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @ReportCode + ''' as SnapshotReportCode, ' + char(10)
		select @SQL += char(9) + char(9) + convert(varchar, @SchoolYear) + ' as SnapshotSchoolYear, ' + char(10)
		select @SQL += char(9) + char(9) + '''' + @SnapshotDate + ''' as SnapshotDate,' + char(10)
		select @SQL += char(9) + char(9) + @ColumnList + char(10)
		select @SQL += char(9) + 'FROM Staging.' + @TableName + char(10)
		select @SQL += 'END' + char(10)

		--print out the dynamic sql rather then executing it
		if @ShowSQL = 1
		begin
			select @sql
			return
		end

		--execute the sql that will create the snapshot tables
		begin try
			exec(@SQL)
		end try
		begin catch
			select @Error = ERROR_MESSAGE()
			insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), 4, '   ERROR creating snapshot for table Staging.' + @TableName + '.  ' + @Error)
		end catch

		delete from #StagingTables where TableName = @TableName
		select @TableName = (select top 1 TableName from #StagingTables)
	end

	insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 4, 'CreateSnapshotFromStaging for ' + @ReportCode + ' - FINISHED')


END
