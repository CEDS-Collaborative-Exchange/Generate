CREATE PROCEDURE [Utilities].[CreateSubmissionFileTable] 
		@DatabaseName varchar(25) = NULL, -- If NULL then DatabaseName = 'Generate'
		@SchemaName varchar(25),
		@SubmissionYear int,
		@ReportCode varchar(10),
		@ReportLevel varchar(3),
		@Label varchar(25) = NULL, -- This is an optional label that can be appended to table name
		@ShowSQL bit = 0, -- If this = 1 then the SQL will be returned rather than executing the SQL
		@CreatedTableName varchar(100) output
AS
BEGIN

/****************************************************************************************
AEM Inc.
CIID Generate Team
November 17, 2022

This procedure creates a table for the specified file submission report code and report
level.

The file will be named as follows: [@SchemaName].[@ReportCode_@ReportLevel_@SubmissionYear]

*****************************************************************************************/

	set NOCOUNT ON
	IF OBJECT_ID(N'tempdb..#Columns') IS NOT NULL drop table #Columns

	select @DatabaseName = ltrim(rtrim(case when isnull(@DatabaseName,'') = '' or ltrim(rtrim(@DatabaseName)) = '' then isnull(@DatabaseName,'Generate') else @DatabaseName end))
	select @Label = ltrim(rtrim(case when isnull(@Label,'') = '' or ltrim(rtrim(@Label)) = '' then isnull(@Label,'') else '_' + @Label end))
		


	-- LOAD FILE SPEC METADATA INTO TEMP TABLE --------------------------------------------------
	begin try
		select R.GenerateReportId, R.ReportCode, OL.LevelCode, FSFC.SequenceNumber, FC.ColumnName, FC.ColumnLength, FC.datatype
		into #Columns
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
	end try
	begin catch
		print 'Error reading metadata!'
		return
	end catch

	declare 
		@TableName varchar(50) = @ReportCode + '_' + @ReportLevel + '_' + convert(varchar, @SubmissionYear) + @Label,
		@DropSQL varchar(max) = '',
		@CreateSQL varchar(max) = '',
		@ColumnName varchar(50),
		@Sequence int = 1,
		@ColumnCount int = (select count(*) from #Columns where ReportCode = @ReportCode and LevelCode = @ReportLevel)

	if @ColumnCount = 0
		begin
			print 'No Metadata defined!'
			return
		end


	select @CreatedTableName = '[' + @DatabaseName + '].[' + @SchemaName + '].[' + @TableName + ']'

	-- CREATE THE DROP TABLE SQL -------------------------------------------------------------------------------------------

	select @DropSQL = 'IF EXISTS(SELECT 1 FROM [' + @DatabaseName + '].INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = ''' + @SchemaName + ''' AND TABLE_NAME = ''' + @TableName + ''')' + char(10)
	select @DropSQL = @DropSQL + 'BEGIN' + char(10)
	select @DropSQL = @DropSQL + char(9) + 'DROP TABLE ' + @CreatedTableName + char(10)
	select @DropSQL = @DropSQL + 'END'


	-- CREATE THE CREATE TABLE SQL --------------------------------------------------
	select @CreateSQL = 'CREATE TABLE ' + @CreatedTableName + ' (' + char(10)

	-- LOOP THROUGH EACH COLUMN AND BUILD SQL ------------------------------------------
	while @Sequence <= @ColumnCount
		begin
			select @ColumnName = ColumnName from #Columns where SequenceNumber = @Sequence
			select @CreateSQL = @CreateSQL + char(9) + '[' + @ColumnName + '] varchar(100) NULL'
			if @Sequence < @ColumnCount
				begin
					select @CreateSQL = @CreateSQL + ','
				end
			select @CreateSQL = @CreateSQL + char(10)
			select @Sequence +=1
		end
		select @CreateSQL = @CreateSQL + ')' + char(10)

	-- EXECUTE SQL -------------------------------------------------------------
	if @ShowSQL = 1
		begin
			select 'DropSQL = ', @DropSQL
		end
	else
		begin
			begin try
				exec (@DropSQL)
				insert into App.DataMigrationHistories select getdate(), @CreatedTableName + ' Dropped', 4
			end try
			begin catch
				insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO DROP TABLE ' + @CreatedTableName, 4
				print 'DROP QUERY FAILED - ' + ERROR_MESSAGE() 
				return
			end catch	
		end

	if @ShowSQL = 1
		begin
			select 'CreateSQL = ', @CreateSQL
		end
	else
		begin
			begin try
				exec (@CreateSQL)
				insert into App.DataMigrationHistories select getdate(), @CreatedTableName + ' Created', 4
				print 'Table created: ' + @CreatedTableName
			end try
			begin catch
				insert into App.DataMigrationHistories select getdate(), 'ERROR - FAILED TO CREATE TABLE ' + @CreatedTableName, 4
				print 'CREATE TABLE FAILED - ' + ERROR_MESSAGE()
				return
			end catch
		end


END
