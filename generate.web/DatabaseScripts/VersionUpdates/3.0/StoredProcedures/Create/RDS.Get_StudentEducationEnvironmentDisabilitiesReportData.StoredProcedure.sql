



CREATE PROCEDURE [RDS].[Get_StudentEducationEnvironmentDisabilitiesReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50)
AS
BEGIN


	SET NOCOUNT ON;


	-- Determine Fact/Report Tables

	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)

	DECLARE @SQL nvarchar(MAX), @tableSql nvarchar(max)
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
	and upper(d.DimensionFieldName) <> 'EDUCENV'


	create table #reportCounts
	(
		[OrganizationId] [int] NOT NULL,
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category [nvarchar](100) NULL,
		EDUCENV [nvarchar](50) NULL,
		StudentCount int NULL
	)

	
	SET @SelectSQL = '
		select StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							EDUCENV,
							SUM(StudentCount)
							
		'

	SET @GroupBySQL = '
		group by StateANSICode,
							StateCode,
							StateName,
							OrganizationId,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId, 
							EDUCENV
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
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								EDUCENV,
								StudentCount,
								Category)
	EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode;

		
	-- Zero Counts

	declare @zeroCountSQL as nvarchar(max)
	set @zeroCountSQL = ''
	
	SELECT @zeroCountSQL = [RDS].Get_CountSQL (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero-educenv', 1, 0,'','')

	EXECUTE sp_executesql @zeroCountSQL


	IF(@reportCode = 'edenvironmentdisabilitiesage3-5')
	BEGIN

				SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					@categorySetCode as CategorySetCode,
					NULL as ReportFilter,
					StateANSICode,
					StateCode,
					StateName,
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category as Category1,
					CAST(SUM([H]) as decimal(18,2)) as col_1,
					CAST(SUM([REC09YOTHLOC]) as decimal(18,2)) as col_2,
					CAST(SUM([REC09YSVCS]) as decimal(18,2)) as col_3,
					CAST(SUM([REC10YOTHLOC]) as decimal(18,2)) as col_4,
					CAST(SUM([REC10YSVCS]) as decimal(18,2)) as col_5,
					CAST(SUM([RF]) as decimal(18,2)) as col_6,
					CAST(SUM([SC]) as decimal(18,2)) as col_7,
					CAST(SUM([SPL]) as decimal(18,2)) as col_8,
					CAST(SUM([SS])  as decimal(18,2)) as col_9,
					CAST(SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +
						 SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS]) as decimal(18,2))  as col_10,
					NULL as col_10a,
					NULL as col_10b,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([H]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END  as col_11,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([REC09YOTHLOC]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_11a,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([REC09YSVCS]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_11b,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([REC10YOTHLOC]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_11c,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([REC10YSVCS]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_11d,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([RF]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS]))  ELSE 0 END as col_11e,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([SC]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_12,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([SPL]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_12a,
					CASE WHEN (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) +	SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) > 0 
					THEN CAST(SUM([SS]) as decimal(18,2)) / (SUM([H]) + SUM([REC09YOTHLOC]) + SUM([REC09YSVCS]) + SUM([REC10YOTHLOC]) + SUM([REC10YSVCS]) + SUM([RF]) + SUM([SC]) + SUM([SPL]) + SUM([SS])) ELSE 0 END as col_12b,
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
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					options.CategoryOptionName as Category,
					EDUCENV,
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
					Where r.Category not in ('MISSING','NOTCOLLECT')
					) as SourceTable
					PIVOT
					(	
						SUM(StudentCount)
						FOR EDUCENV IN ([H],[REC09YOTHLOC],[REC09YSVCS],[REC10YOTHLOC],[REC10YSVCS],[RF],[SC],[SPL],[SS])
					) AS PivotTable
					group by StateANSICode,
					StateCode,
					StateName,
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category

		
	END
	ELSE IF(@reportCode = 'edenvironmentdisabilitiesage6-21')
	BEGIN

				SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					@categorySetCode as CategorySetCode,
					NULL as ReportFilter,
					StateANSICode,
					StateCode,
					StateName,
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category as Category1,
					CAST(SUM([HH]) as decimal(18,2)) as col_1,
					CAST(SUM([CF]) as decimal(18,2)) as col_2,
					CAST(SUM([PPPS]) as decimal(18,2)) as col_3,
					CAST(SUM([RC39]) as decimal(18,2)) as col_4,
					CAST(SUM([RC79TO40]) as decimal(18,2)) as col_5,
					CAST(SUM([RC80]) as decimal(18,2)) as col_6,
					CAST(SUM([RF]) as decimal(18,2)) as col_7,
					CAST(SUM([SS]) as decimal(18,2)) as col_8,
					CAST(SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS]) as decimal(18,2)) as col_9,
					NULL as col_10,
					NULL as col_10a,
					NULL as col_10b,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([HH]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([CF]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11a,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([PPPS]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11b,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([RC39]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11c,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([RC79TO40]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11d,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([RC80]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_11e,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([RF]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_12,
					CASE WHEN (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) > 0 
					THEN CAST(SUM([SS]) as decimal(18,2)) / (SUM([HH]) + SUM([CF]) + SUM([PPPS]) + SUM([RC39]) + SUM([RC79TO40]) + SUM([RC80]) + SUM([RF]) + SUM([SS])) ELSE 0 END as col_12a,
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
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					options.CategoryOptionName as Category,
					EDUCENV,
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
					Where r.Category not in ('MISSING','NOTCOLLECT')
					) as SourceTable
					PIVOT
					(	
						SUM(StudentCount)
						FOR EDUCENV IN ([HH],[CF],[PPPS],[RC39],[RC79TO40],[RC80],[RF],[SS])
					) AS PivotTable
					group by StateANSICode,
					StateCode,
					StateName,
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category
		
	END
		
	drop table #reportCounts

	SET NOCOUNT OFF;


END

