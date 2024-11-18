CREATE PROCEDURE [Utilities].[CompareSubmissionFiles] 

		@DatabaseName varchar(100), -- If NULL then DatabaseName = 'Generate'
		@SchemaName varchar(25),
		@SubmissionYear int,
		@ReportCode varchar(10),
		@ReportLevel varchar(3),
		@LegacyTableName varchar(100), 
		@GenerateTableName varchar(100),
		@ShowSQL bit = 0,
		@ComparisonResultsTableName varchar(200) output


AS
BEGIN
/****************************************************************************************
AEM Inc.
CIID Generate Team
November 22, 2022

This procedure creates and populates a comparison table for the specified table names.

The table will be named as follows: [@DatabaseName].[@SchemaName].[@ReportCode_@ReportLevel_@SubmissionYear_COMPARISON]

*****************************************************************************************/
	SET NOCOUNT ON

	declare @CompareColumn varchar(50) = 'Amount' -- Note: this value is the same for all file specs except C029 and C039 (based on current CIID files)

	select @DatabaseName = ltrim(rtrim(case when isnull(@DatabaseName,'') = '' or ltrim(rtrim(@DatabaseName)) = '' then isnull(@DatabaseName,'Generate') else @DatabaseName end))

	IF OBJECT_ID(N'tempdb..#SelectColumns') IS NOT NULL drop table #SelectColumns
	IF OBJECT_ID(N'tempdb..#JoinColumns') IS NOT NULL drop table #JoinColumns
	IF OBJECT_ID(N'tempdb..#Results') IS NOT NULL DROP TABLE #Results

	-- LOAD FILE SPEC METADATA INTO TEMP TABLE --------------------------------------------------
	begin try
		select identity(int,1,1) as ID, R.GenerateReportId, R.ReportCode, OL.LevelCode, FSFC.SequenceNumber, FC.ColumnName
		into #SelectColumns
		from app.GenerateReports R
		left join app.FileSubmissions FS
			on R.GenerateReportId = FS.GenerateReportId
		inner join app.OrganizationLevels OL
			on FS.OrganizationLevelId = OL.OrganizationLevelId
		left join app.FileSubmission_FileColumns FSFC
			on FS.FileSubmissionId = FSFC.FileSubmissionId
		left join app.FileColumns FC
			on fsfc.FileColumnId = fc.FileColumnId
		where FS.SubmissionYear = @SubmissionYear and ReportCode = @ReportCode and OL.LevelCode = @ReportLevel
		and ColumnName <> 'CarriageReturn/LineFeed'
		and ColumnName <> 'FileRecordNumber'
		and ColumnName not like '%FILLER%'
		and ColumnName not like '%Explanation%'
		order by SequenceNumber
	end try
	begin catch
		print 'Error reading metadata!'
		return
	end catch


	declare 
		@DropSQL varchar(max) = '',
		--@ComparisonResultsTableName varchar(100),
		@TableName varchar(100) = @ReportCode + '_' + @ReportLevel + '_' + convert(varchar, @SubmissionYear) + '_COMPARISON',
		@InsertQuery varchar(max) = '',
		@ColumnName varchar(50),
		@ID int = 1,
		@ColumnCount int = (select count(*) from #SelectColumns where ReportCode = @ReportCode and LevelCode = @ReportLevel)

	select @ComparisonResultsTableName = '[' + @DatabaseName + '].[' + @SchemaName + '].[' + @TableName + ']'


	if @ColumnCount = 0
		begin
			print 'No Metadata defined!'
			return
		end

	-- CREATE THE DROP TABLE SQL -------------------------------------------------------------------------------------------
	select @DropSQL = 'IF EXISTS(SELECT 1 FROM [' + @DatabaseName + '].INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ''' + @SchemaName + ''' AND TABLE_NAME = ''' + @TableName + ''')' + char(10)
	select @DropSQL = @DropSQL + 'BEGIN' + char(10)
	select @DropSQL = @DropSQL + char(9) + 'DROP TABLE ' + @ComparisonResultsTableName + char(10)
	select @DropSQL = @DropSQL + 'END'



	-- CREATE THE CREATE TABLE SQL --------------------------------------------------
	select @InsertQuery = 'select DISTINCT ''' + @ReportCode + ''' ReportCode, ''' + @ReportLevel + ''' ReportLevel,' + char(10)

	--select * from #columns
	--return
	-- LOOP THROUGH EACH COLUMN AND BUILD SQL ------------------------------------------
	while @ID <= @ColumnCount
		begin
			select @ColumnName = ColumnName from #SelectColumns where ID = @ID
			if @ColumnName <> @CompareColumn
				begin
					select @InsertQuery = @InsertQuery + char(9) + 'ISNULL(L.[' + @ColumnName + '], G.[' + @ColumnName + ']) ' 
				end
			if @ColumnName = @CompareColumn
				begin
					select @InsertQuery = @InsertQuery + char(9) + 'L.[' + @ColumnName + '] Legacy' + @CompareColumn + ',' + char(10)
					-- Syntax for Zero Counts that don't exist in Generate Report Tables.  Assume if Generate amount is null (doesn't exist) that it will be a zero count in the final report
					select @InsertQuery = @InsertQuery + char(9) + 'case when L.[' + @ColumnName + '] = 0 and G.[' + @ColumnName + '] is NULL then 0 else G.[' + @CompareColumn + '] end Generate' + @CompareColumn
--					select @InsertQuery = @InsertQuery + char(9) + 'isnull(G.[' + @ColumnName + '],0) Generate' + @CompareColumn
				end
			else
				begin
					select @InsertQuery = @InsertQuery + ' ' + @ColumnName
				end
			if @ID < @ColumnCount
				begin
					select @InsertQuery = @InsertQuery + ','
				end
			select @InsertQuery = @InsertQuery + char(10)
			select @ID +=1
		end

		select @InsertQuery = @InsertQuery + 'INTO ' + @ComparisonResultsTableName + char(10)
		select @InsertQuery = @InsertQuery + 'FROM ' + @LegacyTableName + ' L' + char(10)
		select @InsertQuery = @InsertQuery + 'FULL OUTER JOIN ' + @GenerateTableName + ' G' + char(10)
		select @InsertQuery = @InsertQuery + 'ON '

		
	-- RESET TO ADD THE JOIN COLUMNS
	select identity(int,1,1) as ID, ColumnName, SequenceNumber
	into #JoinColumns
	from #SelectColumns
	where ColumnName <> @CompareColumn
	order by SequenceNumber

	select @ColumnCount = (select count(*) from #JoinColumns)
	select @ID = 1

	while @ID <= @ColumnCount
		begin
			select @ColumnName = ColumnName from #JoinColumns where ID = @ID

			if @ID > 1
				begin
					select @InsertQuery = @InsertQuery + char(9) + 'and '
				end
			if @ColumnName <> @CompareColumn
				begin
					select @InsertQuery = @InsertQuery + 'isnull (L.' + @ColumnName + ', '''') = isnull(G.' + @ColumnName + ', '''')' 
				end

			if @ColumnName = @CompareColumn
				begin
					select @InsertQuery = @InsertQuery + char(9) + 'L.[' + @ColumnName + 'Legacy' + @CompareColumn + ', ' + char(10)
					-- Syntax for Zero Counts that don't exist in Generate Report Tables.  Assume if Generate amount is null (doesn't exist) that it will be a zero count in the final report
					select @InsertQuery = @InsertQuery + char(9) + 'case when L.[' + @ColumnName + '] = 0 and G.[' + @ColumnName + '] is NULL then 0 else G.[' + @CompareColumn + '] end Generate' + @CompareColumn
--					select @InsertQuery = @InsertQuery + char(9) + 'isnull(G.[' + @ColumnName + '],0) Generate' + @CompareColumn

				end

			select @InsertQuery = @InsertQuery + char(10)
			select @ID +=1
		end

--print @InsertQuery
--return

	-- EXECUTE SQL -------------------------------------------------------------
	if @ShowSQL = 1
		begin
			select 'InsertQuery = ', @InsertQuery
			return
		end
	else
		begin
			begin try
				exec (@DropSQL)
				insert into App.DataMigrationHistories select getdate(), @ComparisonResultsTableName + ' Dropped', 4
			end try
			begin catch
				insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO DROP TABLE ' + @ComparisonResultsTableName, 4
				print 'DROP QUERY FAILED - ' + ERROR_MESSAGE() 
				return
			end catch	
		end

	begin try
		exec (@InsertQuery)
		insert into App.DataMigrationHistories select getdate(), 'Comparison results inserted into ' + @ComparisonResultsTableName, 4
	end try
	begin catch
		insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO CREATE TABLE ' + @ComparisonResultsTableName, 4
		print 'COMPARISON INSERT QUERY FAILED - ' + ERROR_MESSAGE()
		return
	end catch	
END
	

	
