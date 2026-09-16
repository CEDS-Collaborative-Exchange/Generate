CREATE PROCEDURE [RDS].[Get_ReportDebugData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@parameters as nvarchar(1000)
AS
BEGIN

	SET NOCOUNT ON;

	declare @debugTable varchar(200)
	declare @sql varchar(500)
	declare @WHERE varchar(200) = ''
	declare @tableTypeAbbrv as varchar(50)

	DECLARE @QueryParam TABLE
	(
		Name varchar(100),
		Value varchar(200)
	)
	INSERT INTO @QueryParam
	SELECT [key], value AS ColumnName
	FROM OPENJSON(@parameters)


	IF @reportCode in ('175','178','179','185','188','189')
	BEGIN
		
		IF @reportCode = '175'
		BEGIN
			select @tableTypeAbbrv = 'ASMTADMNMTH' + RIGHT([value], 2) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END
		ELSE IF @reportCode = '178'
		BEGIN
			select @tableTypeAbbrv = 'ASMTADMN' + RIGHT([value], 5) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END
		ELSE IF @reportCode = '179'
		BEGIN
			select @tableTypeAbbrv = 'ASMTADMNSCI' + RIGHT([value], 2) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END
		ELSE IF @reportCode = '185'
		BEGIN
			select @tableTypeAbbrv = 'PARTSTATUSMTH' + RIGHT([value], 2) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END
		ELSE IF @reportCode = '188'
		BEGIN
			select @tableTypeAbbrv = 'PARTSTATUS' + RIGHT([value], 5) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END
		ELSE IF @reportCode = '189'
		BEGIN
			select @tableTypeAbbrv = 'PARTSTATUSSCI' + RIGHT([value], 2) from @QueryParam where [Name] = 'tableTypeAbbrv'
		END

		SELECT @debugTable = TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME like '%' + @reportCode + '_' + @reportLevel + '_' + @categorySetCode + '_' + @reportYear + '%'
		AND TABLE_NAME like '%' + @tableTypeAbbrv  + '%'
	END
	ELSE
	BEGIN
		SELECT @debugTable = TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME like '%' + @reportCode + '_' + @reportLevel + '_' + @categorySetCode + '_' + @reportYear + '%'
	END


	--SELECT * FROM @QueryParam

	DECLARE tblcur CURSOR FOR
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @debugTable

	DECLARE @ColumnName varchar(100), @SortedColumnName varchar(100)

	OPEN tblcur;

	FETCH NEXT FROM tblcur INTO @ColumnName;

	SET @SortedColumnName = @ColumnName

	IF @reportCode in ('175','178','179','185','188','189')
	BEGIN
		SET @sql = 'SELECT  + '''  + @tableTypeAbbrv +  ''' as TableTypeAbbrv, * FROM ' + '[debug].[' + @debugTable + ']'
	END
	ELSE
	BEGIN
		SET @sql = 'SELECT * FROM ' + '[debug].[' + @debugTable + ']'
	END

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ParamName varchar(100), @ParamValue varchar(100)
		SELECT @ParamName = Name,  @ParamValue = value FROM @QueryParam WHERE Name = @ColumnName

		IF ISNULL(@WHERE, '') <> ''
			SET @WHERE += ' AND '

		IF ISNULL(@ParamName, '') <> ''
			SET @WHERE += @ParamName + ' = ''' + @ParamValue + ''''
		
		FETCH NEXT FROM tblcur INTO @ColumnName;
	END

	CLOSE tblcur;
	DEALLOCATE tblcur;

	IF @WHERE <> '' OR @reportLevel <> 'sea'
	BEGIN
		SET @sql = @sql+ ' WHERE '
	END

	IF @reportLevel <> 'sea'
	BEGIN
		DECLARE @orgName varchar(100), @orgValue varchar(100)
		IF ISNULL(@WHERE, '') <> ''
			SET @WHERE += ' AND '
			SET @ColumnName = 'organizationIdentifierSea'
			SELECT @orgValue = value FROM @QueryParam WHERE Name = @ColumnName
		IF @reportLevel = 'lea'
			SET @orgName = 'leaIdentifierSea'
		ELSE IF @reportLevel = 'sch'
			SET @orgName = 'schoolIdentifierSea'

		IF ISNULL(@orgName, '') <> ''
			SET @WHERE += @orgName + ' = ''' + @orgValue + ''''

	END

	DECLARE @OrderBy varchar(200)
	SELECT @OrderBy = ' ORDER BY ' + @SortedColumnName

	--Select @sql + @WHERE
	SET @sql = @sql + @WHERE + @OrderBy

	--declare @ParmDefinition as nvarchar(max)
	--SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @isOnlineReport bit';  
	--EXECUTE sp_executesql @sql, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @isOnlineReport=@isOnlineReport;
	--EXECUTE sp_executesql @sql
	print @sql
	EXEC(@sql)
	SET NOCOUNT OFF;
END