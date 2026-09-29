CREATE PROCEDURE [Utilities].[Cleanup_Debug_Tables] (
	@reportCode as nvarchar(4) = null,
	@reportYear as nvarchar(4) = null
)
AS
BEGIN

	/*
		The process of migrating EDFacts data through to the Reports tables 
		automatically creates a set of tables in the debug schema that 
		provide the student IDs that make up the aggregated counts.  They 
		are very useful when doing file comparison/matching work.  Those 
		tables can build up over time.  This utility provides a means of 
		keeping those tables in check.

		There are 4 options for managing the debug tables.  Execute the stored 
			procedure using the parameters as follows:
		1. Leave both parameters blank and delete ALL tables in the debug schema
			exec [Utilities].[Cleanup_Debug_Tables]
		2. Pass a reportcode, ex, 'c002', for @reportCode and delete all the 
			tables in the debug schema for that report (all school years)
			exec [Utilities].[Cleanup_Debug_Tables] 'c002'
		3. Pass a 4 digit School Year for @reportYear and delete all the tables
			in the debug schema for that School Year (all reports)
			exec [Utilities].[Cleanup_Debug_Tables] null, '2022'
		4. Pass in values for both parameters and delete all the tables for only 
			the specified report for only the specified school year
			exec [Utilities].[Cleanup_Debug_Tables] 'c002', '2022'
	*/

	declare @cmd varchar(4000)
	declare @cursorSql nvarchar(max)

	set @cursorSql = 'DECLARE cmds CURSOR FOR
	SELECT ''drop table [debug].['' + Table_Name + '']''
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = ''DEBUG''
	AND TABLE_TYPE = ''BASE TABLE''
	'

	if @reportCode is not null
	begin
		set @cursorSql += ' AND Table_Name LIKE ''' + @reportCode + '_%'''
	end

	if @reportYear is not null
	begin 
		set @cursorSql += ' AND Table_Name LIKE ''%_' + @reportYear + '%'''
	end

	exec (@cursorSql)

	open cmds
	while 1 = 1
	begin
		fetch cmds into @cmd
		if @@fetch_status != 0 BREAK
		exec(@cmd)
	end
	close cmds;
	deallocate cmds

END
