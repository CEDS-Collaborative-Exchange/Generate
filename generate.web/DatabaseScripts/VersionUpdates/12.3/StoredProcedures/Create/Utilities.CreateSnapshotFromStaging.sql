create PROCEDURE Utilities.CreateSnapshotFromStaging
	@SchoolYear smallint,
	@ReportCode varchar(10),
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

		Possible Enhancements:
		1. We could pass in a parameter to indicate whether to overwrite existing snapshot data for the @SchoolYear, or
		   retain it and include a label so that multiple versions of snapshot data may exist for the same year.  This 
		   could be valuable when debugging ETLs.
	*/
	set NOCOUNT ON

	insert into app.DataMigrationHistories
		(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		values	(getutcdate(), 4, 'CreateSnapshotFromStaging for ' + @ReportCode + ' - STARTED')

	declare 
		@SQL varchar(max) = '', 
		@Error varchar(max) = '',
		@TableName varchar(50) = '', 
		@SnapshotDate varchar(100) = (select convert(varchar, getdate(), 27))



	-- SET TABLES TO BE INCLUDED IN THE SNAPSHOT IN THIS SECTION -----------------------
	IF OBJECT_ID(N'tempdb..#StagingTables') IS NOT NULL DROP TABLE #StagingTables
	create table #StagingTables (
		TableName varchar(50)
		)


	insert into #StagingTables (TableName)
	select 
		--agr.ReportCode, 
		agst.StagingTableName 
	from app.GenerateReports agr
	inner join app.GenerateReport_GenerateStagingTablesXREF x
		on agr.GenerateReportId = x.GenerateReportId
	inner join app.GenerateStagingTables agst
		on agst.StagingTableId = x.StagingTableId
	where right(agr.ReportCode,3) = right(@ReportCode,3) -- To handle @ReportCode that start with 'FS' or 'C'

			/*
				if @ReportCode like '%029'
					begin
						insert into #StagingTables (TableName)
							values 
								('StateDetail'), 
								('K12Organization'), 
								('OrganizationAddress'), 
								('OrganizationPhone')
					end
				if @ReportCode like '%039'
					begin
						insert into #StagingTables (TableName)
							values 
								('OrganizationGradeOffered') 
					end
			*/
	--------------------------------------------------------------------------------------

	-- Loop through list of tables and create a snapshot for each one	
	select @TableName = (select top 1 TableName from #StagingTables)
	while @TableName is not null 
		BEGIN
			select @SQL = 'IF OBJECT_ID(''Source.' + @TableName +''') is null' + char(10)
			select @SQL += 'BEGIN' + char(10)
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

			select @SQL += char(9) + 'INSERT INTO Source.' + @TableName + char(10)
			select @SQL += char(9) + 'SELECT ' + char(10)
			select @SQL += char(9) + char(9) + '''' + @ReportCode + ''' as SnapshotReportCode, ' + char(10)
			select @SQL += char(9) + char(9) + convert(varchar, @SchoolYear) + ' as SnapshotSchoolYear, ' + char(10)
			select @SQL += char(9) + char(9) + '''' + @SnapshotDate + ''' as SnapshotDate,' + char(10)
			select @SQL += char(9) + char(9) + '*' + char(10)
			select @SQL += char(9) + 'FROM Staging.' + @TableName + char(10)
			select @SQL += 'END' + char(10)

			if @ShowSQL = 1
			begin
				select @sql
				return
			end
			insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), 4, '   Creating snapshot for table Staging.' + @TableName)

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
