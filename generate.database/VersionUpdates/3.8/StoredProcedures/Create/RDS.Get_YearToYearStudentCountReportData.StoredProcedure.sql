CREATE PROCEDURE [RDS].[Get_YearToYearStudentCountReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50)
AS
BEGIN


	SET NOCOUNT ON;
	DECLARE @factTable as varchar(50), @factField as varchar(50), @factReportTable as varchar(50), @factReportId as varchar(50), @SQL nvarchar(MAX), @tableSql nvarchar(max)
	DECLARE @DeclareSQL nvarchar(MAX), @InsertSQL nvarchar(MAX), @SelectSQL nvarchar(MAX), @GroupBySQL nvarchar(MAX)
		
	-- Determine Fact/Report Tables

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode
	
	-- Get Categories used in this report

	declare @ReportFieldsInCategorySet as table(
		ReportField varchar(100)
	)

	delete from @ReportFieldsInCategorySet

		
	insert into @ReportFieldsInCategorySet
	(ReportField)
	select upper(d.DimensionFieldName) as ReportField
	from app.Dimensions d 
	inner join app.Category_Dimensions cd on d.DimensionId = cd.DimensionId
	inner join app.Categories c on cd.CategoryId = c.CategoryId
	inner join app.CategorySet_Categories csc on c.CategoryId = csc.CategoryId
	inner join app.CategorySets cs on csc.CategorySetId = cs.CategorySetId
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
	where r.ReportCode = @reportCode
	and cs.SubmissionYear = @reportYear
	and o.LevelCode = @reportLevel
	and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
	and upper(d.DimensionFieldName) <> 'YEAR'


	create table #reportCounts
	(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category [nvarchar](100) NULL,
		[YEAR] [nvarchar](50) NULL,
		StudentCount int NULL
	)

	
	SET @SelectSQL = '
		select StateANSICode,
							StateCode,
							StateName,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							[YEAR],
							SUM(StudentCount)
							
		'

	SET @GroupBySQL = '
		group by StateANSICode,
							StateCode,
							StateName,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId, 
							[YEAR]
		'
	DECLARE @rowField as nvarchar(100)
	DECLARE reportFieldRow_cursor CURSOR FOR   
	select ReportField FROM @ReportFieldsInCategorySet

	OPEN reportFieldRow_cursor  
  
	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField

	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	END

	CLOSE reportFieldRow_cursor;  
	DEALLOCATE reportFieldRow_cursor;

	SET @SelectSQL = @SelectSQL + 
			'
				from rds.' + @factReportTable +	'	Where ReportCode = @reportCode and ReportLevel = @reportLevel
				and ReportYear = @reportYear and CategorySetCode = @categorySetCode
			'

	SET @SQL = @SelectSQL + @GroupBySQL

	DECLARE @printString NVARCHAR(MAX);
	set @printString = @SQL;
	print @SQL
	DECLARE @CurrentEnd BIGINT; /* track the length of the next substring */
	DECLARE @offset tinyint; /*tracks the amount of offset needed */
	set @printString = replace(  replace(@printString, char(13) + char(10), char(10))   , char(13), char(10))

	WHILE LEN(@printString) > 1
	BEGIN
		IF CHARINDEX(CHAR(10), @printString) between 1 AND 4000
		BEGIN
				SET @CurrentEnd =  CHARINDEX(char(10), @printString) -1
				set @offset = 2
		END
		ELSE
		BEGIN
				SET @CurrentEnd = 4000
				set @offset = 1
		END   
		PRINT SUBSTRING(@printString, 1, @CurrentEnd) 
		set @printString = SUBSTRING(@printString, @CurrentEnd+@offset, LEN(@printString))   
	END

	declare @ParmDefinition as nvarchar(max)
	SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100)';  

	INSERT INTO #reportCounts(StateANSICode,
								StateCode,
								StateName,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								[YEAR],
								StudentCount,
								Category)
	EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode;

		CREATE TABLE #temp(CategoryOptionCode VARCHAR(100));
		INSERT INTO #temp 
		SELECT distinct e.CategoryOptionCode FROM APP.GenerateReports a 
			inner join app.CategorySets b on b.GenerateReportId=a.GenerateReportId
			inner join app.CategorySet_Categories c on c.CategorySetId=b.CategorySetId 
			inner join app.Categories d on c.CategoryId=d.CategoryId and CategoryCode='YEAR'
			inner join app.CategoryOptions e on e.CategorySetId=b.CategorySetId and e.CategoryId=d.CategoryId and SubmissionYear=@reportYear 
			inner join app.GenerateReport_OrganizationLevels f on f.GenerateReportId=a.GenerateReportId 
			inner join app.OrganizationLevels g on g.OrganizationLevelId=f.OrganizationLevelId and g.LevelCode=@reportLevel
		DECLARE @ListOfGroups VARCHAR(MAX)=(
		STUFF
		(
			(
			SELECT DISTINCT ',' + QUOTENAME(CategoryOptionCode) 
			FROM #temp
			FOR XML PATH('')
			 ),1,1,''
		)
		);
		DECLARE @LEFT AS VARCHAR(50), @RIGHT AS VARCHAR(50)
		SET @LEFT=LEFT(@ListOfGroups,6) 
		SET @RIGHT=RIGHT(@ListOfGroups,6)
		declare @ParDef as nvarchar(max)
	SET @ParDef = N'@reportCode varchar(50), @reportYear varchar(50), @reportLevel varchar(50), @categorySetCode as varchar(50)';  

	declare @sqlrun as nvarchar(max)
	
	set  @sqlrun='		SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					@categorySetCode as CategorySetCode,
					NULL as ReportFilter,
					StateANSICode,
					StateCode,
					StateName,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category as Category1,
					NULL as Category2,
					NULL as Category3,
					NULL as Category4,
					CAST(ISNULL(SUM(' +@LEFT+'),0) as decimal(18,2))  as col_1,
					CAST(ISNULL(SUM('+@RIGHT+'),0) as decimal(18,2))  as col_2,
					CAST(ISNULL(SUM(' +@RIGHT+'),0) - ISNULL(SUM('+@LEFT+'),0) as decimal(18,2))  as col_3,
					CASE WHEN CAST(ISNULL(SUM(' +@LEFT+'),0) as decimal(18,2)) <>0 THEN CAST(ISNULL(SUM(' +@RIGHT+'),0) - ISNULL(SUM('+@LEFT+'),0) as decimal(18,2))/CAST(ISNULL(SUM(' +@LEFT+'),0) as decimal(18,2)) ELSE 0 END as col_4,
					NULL  as col_5,
					NULL  as col_6,
					NULL as col_7,
					NULL as col_8,
					NULL as col_9,
					NULL as col_10,
					NULL as col_10a,
					NULL as col_10b,
					NULL  as col_11,
					NULL as col_11a,
					NULL as col_11b,
					NULL as col_11c,
					NULL as col_11d,
					NULL as col_11e,
					NULL as col_12,
					NULL as col_12a,
					NULL as col_12b,
					NULL as col_13,
					NULL as col_14,
					NULL as col_14a,
					NULL as col_14b,
					NULL as col_14c,
					NULL as col_14d,
					NULL as col_15,
					NULL as col_16,
					NULL as col_17,
					NULL as col_18,
					NULL as col_18a,
					NULL as col_18b,
					NULL as col_18c,
					NULL as col_18d,
					NULL as col_18e,
					NULL as col_18f,
					NULL as col_18g,
					NULL as col_18h,
					NULL as col_18i

					FROM
					(
					SELECT StateANSICode,
					StateCode,
					StateName,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					options.CategoryOptionName as Category,
					[YEAR],
					StudentCount
					FROM #reportCounts r
					inner join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear
						and cs.CategorySetCode = @categorySetCode) options
					on r.Category = options.CategoryOptionCode
					Where r.Category not in (''MISSING'')
					) as SourceTable
					PIVOT
					(	
						SUM(StudentCount)
						FOR [YEAR] IN ('+@ListOfGroups+')
					) AS PivotTable
					group by StateANSICode,
					StateCode,
					StateName,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category
						'
					--print @sqlRun
					EXECUTE sp_executesql @sqlRun, @ParDef, @reportCode = @reportCode, @reportYear=@reportYear, @reportLevel=@reportLevel, @categorySetCode=@categorySetCode;


	DROP TABLE #reportCounts


		SET NOCOUNT OFF;
END