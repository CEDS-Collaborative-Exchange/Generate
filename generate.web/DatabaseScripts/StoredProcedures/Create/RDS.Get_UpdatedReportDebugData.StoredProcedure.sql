CREATE PROCEDURE [RDS].[Get_UpdatedReportDebugData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@parameters as nvarchar(1000)
AS
BEGIN

	SET NOCOUNT ON;

	declare @debugView varchar(200)
	declare @sql varchar(500)
	declare @WHERE varchar(200) = ''
	declare @selectSQL varchar(200) = ''
	declare @groupBySQL varchar(200) = ''
	declare @tableTypeAbbrv as varchar(50)

	DECLARE @QueryParam TABLE
	(
		Name varchar(100),
		Value varchar(200)
	)
	INSERT INTO @QueryParam
	SELECT [key], value AS ColumnName
	FROM OPENJSON(@parameters)


	select @debugView = 'vw' + FactTypeCode + '_FactTable_' + ReportCode
	from app.GenerateReports r
	inner join app.GenerateReport_FactType rft on r.GenerateReportId = rft.GenerateReportId
	inner join rds.DimFactTypes ft on ft.DimFactTypeId = rft.FactTypeId
	where ReportCode = @reportCode

	IF @reportLevel = 'sea'
	BEGIN
		SET @selectSQL = 'select SeaOrganizationIdentifierSea, K12StudentStudentIdentifierState, count(K12StudentStudentIdentifierState) as StudentCount'
		SET @groupBySQL = 'Group by SeaOrganizationIdentifierSea, K12StudentStudentIdentifierState'
	END
	ELSE IF @reportLevel = 'lea'
	BEGIN
		SET @selectSQL = 'select LeaIdentifierSea, K12StudentStudentIdentifierState, count(K12StudentStudentIdentifierState) as StudentCount'
		SET @groupBySQL = 'Group by LeaIdentifierSea, K12StudentStudentIdentifierState'
	END
	ELSE IF @reportLevel = 'sch'
	BEGIN
		SET @selectSQL = 'select SchoolIdentifierSea, K12StudentStudentIdentifierState, count(K12StudentStudentIdentifierState) as StudentCount'
		SET @groupBySQL = 'Group by SchoolIdentifierSea, K12StudentStudentIdentifierState'
	END

	
	SET @WHERE += ' WHERE SchoolYear = ' + @reportYear


	SELECT * FROM @QueryParam

	DECLARE tblcur CURSOR FOR
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @debugView

	DECLARE @ColumnName varchar(100), @SortedColumnName varchar(100)

	OPEN tblcur;

	FETCH NEXT FROM tblcur INTO @ColumnName;

	SET @SortedColumnName = @ColumnName

	--SET @sql = 'SELECT * FROM ' + '[debug].[' + @debugTable + ']'

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ParamName varchar(100), @ParamValue varchar(100)
		SELECT @ParamName = Name,  @ParamValue = value FROM @QueryParam WHERE Name = @ColumnName

		SET @selectSQL += ',' + @ParamName
		SET @groupBySQL += ',' + @ParamName

		IF ISNULL(@WHERE, '') <> ''
			SET @WHERE += ' AND '

		IF ISNULL(@ParamName, '') <> ''
			SET @WHERE += @ParamName + ' = ''' + @ParamValue + ''''
		
		FETCH NEXT FROM tblcur INTO @ColumnName;
	END

	CLOSE tblcur;
	DEALLOCATE tblcur;

	--IF @WHERE <> '' OR @reportLevel <> 'sea'
	--BEGIN
	--	SET @sql = @sql+ ' WHERE '
	--END

	SET @sql = @selectSQL + ' FROM rds.' + @debugView

	DECLARE @OrderBy varchar(200)
	SELECT @OrderBy = ' ORDER BY ' + @SortedColumnName

	----Select @sql + @WHERE
	SET @sql = @sql + @WHERE + @groupBySQL + @OrderBy

	--declare @ParmDefinition as nvarchar(max)
	--SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @isOnlineReport bit';  
	--EXECUTE sp_executesql @sql, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @isOnlineReport=@isOnlineReport;
	--EXECUTE sp_executesql @sql
	print @sql
	EXEC(@sql)
	SET NOCOUNT OFF;
END