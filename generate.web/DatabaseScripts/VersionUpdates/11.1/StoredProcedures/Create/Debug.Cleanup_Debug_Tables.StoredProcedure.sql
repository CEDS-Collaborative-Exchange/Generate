CREATE PROCEDURE [Debug].[Cleanup_Debug_Tables] (
	@reportCode as nvarchar(4) = null,
	@reportYear as nvarchar(4) = null
)
AS
BEGIN

	declare @cmd varchar(4000)
	declare @cursorSql nvarchar(max)

	--create the cursor to drop the existing debug tables
	set @cursorSql = 'DECLARE cmds CURSOR FOR
	SELECT ''drop table [debug].['' + Table_Name + '']''
	FROM INFORMATION_SCHEMA.TABLES
	WHERE 1 = 1'

	--check for the report code condition to add to the query
	if @reportCode is not null
	begin
		set @cursorSql += ' AND Table_Name LIKE ''' + @reportCode + '_%'''
	end

	--check for the report year condition to add to the query
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
