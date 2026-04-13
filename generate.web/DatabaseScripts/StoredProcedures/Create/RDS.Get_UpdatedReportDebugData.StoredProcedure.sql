CREATE PROCEDURE [RDS].[Get_UpdatedReportDebugData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@parameters as nvarchar(1000)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @debugView VARCHAR(200);
	DECLARE @sql NVARCHAR(MAX) = '';
	DECLARE @WHERE NVARCHAR(MAX) = '';
	DECLARE @selectSQL NVARCHAR(MAX) = '';
	DECLARE @groupBySQL NVARCHAR(MAX) = '';
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
		SET @selectSQL = 'SELECT SeaOrganizationIdentifierSea, K12StudentStudentIdentifierState, COUNT(K12StudentStudentIdentifierState) AS StudentCount';
		SET @groupBySQL = ' GROUP BY SeaOrganizationIdentifierSea, K12StudentStudentIdentifierState';
	END
	ELSE IF @reportLevel = 'lea'
	BEGIN
		SET @selectSQL = 'SELECT K12StudentStudentIdentifierState, COUNT(K12StudentStudentIdentifierState) AS StudentCount';
		SET @groupBySQL = ' GROUP BY K12StudentStudentIdentifierState';
	END
	ELSE IF @reportLevel = 'sch'
	BEGIN
		SET @selectSQL = 'SELECT SchoolIdentifierSea, K12StudentStudentIdentifierState, COUNT(K12StudentStudentIdentifierState) AS StudentCount';
		SET @groupBySQL = ' GROUP BY SchoolIdentifierSea, K12StudentStudentIdentifierState';
	END

	
	SET @WHERE = ' WHERE SchoolYear = ''' + @reportYear + '''';


	-- Cursor over columns
	DECLARE tblcur CURSOR FOR
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @debugView;

	DECLARE @ColumnName VARCHAR(100);
	DECLARE @ParamName VARCHAR(100);
	DECLARE @ParamValue VARCHAR(100);

	OPEN tblcur;
	FETCH NEXT FROM tblcur INTO @ColumnName;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Map column name if needed

		SET @ParamName = ''
		SET @ParamValue = ''
	
		IF @ColumnName = 'LeaIdentifierSea' AND @reportLevel = 'lea'
			SET @ColumnName = 'organizationIdentifierSea';

		SELECT 
			@ParamName = Name, 
			@ParamValue = Value
		FROM @QueryParam
		WHERE Name = @ColumnName;

		--select @ColumnName
		-- SELECT @ParamName, @ParamValue

		-- Reverse mapping
		IF @ParamName = 'organizationIdentifierSea' AND @reportLevel = 'lea'
			SET @ParamName = 'LeaIdentifierSea';

		IF ISNULL(@ParamName, '') <> ''
		BEGIN
			SET @selectSQL += ', ' + @ParamName;
			SET @groupBySQL += ', ' + @ParamName;
			SET @WHERE += ' AND ' + @ParamName + ' = ''' + @ParamValue + '''';
		END

		FETCH NEXT FROM tblcur INTO @ColumnName;
	END

	CLOSE tblcur;
	DEALLOCATE tblcur;

	-- Build final SQL
	SET @sql = @selectSQL 
			 + ' FROM rds.' + @debugView
			 + @WHERE 
			 + @groupBySQL;

	-- ✅ FULL DEBUG OUTPUT (NO TRUNCATION)
	SELECT 
		@selectSQL AS SelectSQL,
		@WHERE AS WhereClause,
		@groupBySQL AS GroupBySQL,
		@sql AS FinalSQL;

	-- Execute
	EXEC(@sql);

	SET NOCOUNT OFF;
END