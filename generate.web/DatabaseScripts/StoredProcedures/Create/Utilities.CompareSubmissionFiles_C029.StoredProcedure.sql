CREATE PROCEDURE [Utilities].[CompareSubmissionFiles_C029] 


		@DatabaseName varchar(25), -- If NULL then DatabaseName = 'Generate'
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

This procedure creates and populates a comparison table for the specified table names for C029.

The table will be named as follows: [@DatabaseName].[@SchemaName].[@ReportCode_@ReportLevel_@SubmissionYear_COMPARISON]

MODIFIED
March 15, 2023 - Added alternate comparisons for OutOfStateInd and ChrtSchoolLEAStatusId to handle multiple options

*****************************************************************************************/


	SET NOCOUNT ON

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

	--select * from #SelectColumns
	--return


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
	select @InsertQuery = 'select DISTINCT ' + convert(varchar, @SubmissionYear) + ' SubmissionYear, ''' + @ReportCode + ''' ReportCode, ''' + @ReportLevel + ''' ReportLevel,' + char(10)
	select @InsertQuery = @InsertQuery + char(9) +
			case 
				when @ReportLevel = 'SEA' then 'ISNULL(L.FIPSStateCode, G.FIPSStateCode) FIPSStateCode, '
				when @ReportLevel = 'LEA' then 'ISNULL(L.StateLEAIDNumber, G.StateLEAIDNumber) StateLEAIDNumber, '
				when @ReportLevel = 'SCH' then 'ISNULL(L.StateSchoolIDNumber, G.StateSchoolIDNumber) StateSchoolIDNumber, '
			end + char(10)
	select @InsertQuery = @InsertQuery + char(9) + '0 Errors, ' + char(10)

	select @InsertQuery = @InsertQuery + char(9) + 'case ' + char(10)
	select @InsertQuery = @InsertQuery + char(9) + char(9) + 'when ' + 
		case
			when @ReportLevel = 'SEA' then 'L.FIPSStateCode '
			when @ReportLevel = 'LEA' then 'L.StateLEAIDNumber '
			when @ReportLevel = 'SCH' then 'L.StateSchoolIDNumber '
		end + 'IS NULL then ''* NOT IN LEGACY FILE *''' + char(10)
	select @InsertQuery = @InsertQuery + char(9) + char(9) + 'when ' + 
		case
			when @ReportLevel = 'SEA' then 'G.FIPSStateCode '
			when @ReportLevel = 'LEA' then 'G.StateLEAIDNumber '
			when @ReportLevel = 'SCH' then 'G.StateSchoolIDNumber '
		end + 'IS NULL then ''* NOT IN GENERATE FILE *''' + char(10)
	select @InsertQuery = @InsertQuery + char(9) + 'else ' + char(10)



	-- LOOP THROUGH EACH COLUMN AND BUILD SQL ------------------------------------------
	while @ID <= @ColumnCount
		begin
			select @ColumnName = ColumnName from #SelectColumns where ID = @ID
			select @InsertQuery = @InsertQuery + 
				case when (@ReportLevel = 'SEA' and @ColumnName <> 'FIPSStateCode')
					or (@ReportLevel = 'LEA' and @ColumnName <> 'StateLEAIDNumber')
					or (@ReportLevel = 'SCH' and @ColumnName <> 'StateSchoolIDNumber')
				then
					case 
						when @ColumnName = 'OutOfStateInd'
							then char(9) +
							'CASE WHEN ISNULL(L.' + @ColumnName + ',''NO'') <> ISNULL(G.' + @ColumnName + ','''') 
							THEN ''' + @ColumnName + ' | '' else '''' end + ' + char(10)
						when @ColumnName = 'ChrtSchoolLEAStatusId'
							then char(9) +
							'CASE WHEN ISNULL(L.' + @ColumnName + ',''NO'') <> ISNULL(G.' + @ColumnName + ','''')
							AND L.' + @ColumnName + ' <> ''NOTCHR'' AND G.' + @ColumnName + ' <> ''NA''
							THEN ''' + @ColumnName + ' | '' else '''' end + ' + char(10)
					else
						char(9) + 
						'CASE WHEN ISNULL(L.' + @ColumnName + ','''') <> ISNULL(G.' + @ColumnName + ','''') THEN ''' + @ColumnName + ' | '' else '''' end + ' + char(10)
					end
				else ''
				end
			select @ID +=1
		end

		select @InsertQuery = @InsertQuery + char(9) + '''''' + char(10)
		select @InsertQuery = @InsertQuery + char(9) + 'end ' + ' Mismatch ' + char(10)


	-- LOOP THROUGH COLUMNS AND ADD THEM TO THE SELECT
	select @ID = 1
	while @ID <= @ColumnCount
		begin
			select @ColumnName = ColumnName from #SelectColumns where ID = @ID
			select @InsertQuery = @InsertQuery + 
				case when (@ReportLevel = 'SEA' and @ColumnName <> 'FIPSStateCode')
					or (@ReportLevel = 'LEA' and @ColumnName <> 'StateLEAIDNumber')
					or (@ReportLevel = 'SCH' and @ColumnName <> 'StateSchoolIDNumber')
				then
				char(9) + 
				',ISNULL(L.' + @ColumnName + ','''') Legacy_' + @ColumnName + ', ISNULL(G.' + @ColumnName + ','''') Generate_' + @ColumnName + char(10)
				else ''
				end
			select @ID +=1
		end

		select @InsertQuery = @InsertQuery + 'INTO ' + @ComparisonResultsTableName + char(10)
		select @InsertQuery = @InsertQuery + 'FROM ' + @LegacyTableName + ' L' + char(10)
		select @InsertQuery = @InsertQuery + 'FULL OUTER JOIN ' + @GenerateTableName + ' G' + char(10)
		select @InsertQuery = @InsertQuery + 'ON '
		select @InsertQuery = @InsertQuery + 
			case 
				when @ReportLevel = 'SEA' then 'ISNULL(L.FIPSStateCode, G.FIPSStateCode) = ISNULL(G.FIPSStateCode, L.FIPSStateCode)'
				when @ReportLevel = 'LEA' then 'ISNULL(L.StateLEAIDNumber, G.StateLEAIDNumber) = ISNULL(G.StateLEAIDNumber, L.StateLEAIDNumber)'
				when @ReportLevel = 'SCH' then 'ISNULL(L.StateSchoolIDNumber, G.StateSchoolIDNumber) = ISNULL(G.StateSchoolIDNumber, L.StateSchoolIDNumber)'
			end + char(10)



	-- EXECUTE SQL -------------------------------------------------------------
	if @ShowSQL = 1
		begin
			select 'Comparison Query = ', @InsertQuery
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

	-- Populate Error Count ----------------------------
	begin try
	
		select @InsertQuery = 'UPDATE ' + @ComparisonResultsTableName + char(10)
		select @InsertQuery = @InsertQuery + 'SET ERRORS = len(Mismatch)-len(replace(Mismatch,''|'',''''))-1'
		exec (@InsertQuery)

		select @InsertQuery = 'UPDATE ' + @ComparisonResultsTableName + char(10)
		select @InsertQuery = @InsertQuery + 'SET ERRORS = 0 where ERRORS = -1'
		exec (@InsertQuery)

		select @InsertQuery = 'UPDATE ' + @ComparisonResultsTableName + char(10)
		select @InsertQuery = @InsertQuery + 'SET ERRORS = -1 where Mismatch like ''%NOT IN%'''
		exec (@InsertQuery)
	end try
	begin catch
		insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO UPDATE ERROR COUNT ' + @ComparisonResultsTableName, 4
		print 'COMPARISON ERROR COUNT UPDATE FAILED - ' + ERROR_MESSAGE()
		return
	end catch	



END
	
