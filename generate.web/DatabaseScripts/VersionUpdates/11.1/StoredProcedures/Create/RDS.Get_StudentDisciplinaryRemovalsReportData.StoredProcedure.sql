CREATE PROCEDURE [RDS].[Get_StudentDisciplinaryRemovalsReportData]
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
	declare @factTypeCode as varchar(50)

	select @factTypeCode = rds.Get_FactTypeByReport(@reportCode)
		
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
	select DISTINCT upper(d.DimensionFieldName) as ReportField
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
	and upper(d.DimensionFieldName) not in ('REMOVALLENGTH','DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES','IDEAINTERIMREMOVALREASON')

	create table #reportCounts
		(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateAbbreviationCode] [nvarchar](100) NOT NULL,
		[StateAbbreviationDescription] [nvarchar](100) NOT NULL,
		Category [nvarchar](100) NULL,
		DISCIPLINARYACTIONTAKEN [nvarchar](100) NULL,
		DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES [nvarchar](100) NULL,
		IDEAINTERIMREMOVALREASON [nvarchar](100) NULL,
		IDEAINTERIMREMOVAL [nvarchar](100) NULL,
		REMOVALLENGTH [nvarchar](100) NULL,
		REMOVALLENGTHIDEA [nvarchar](100) NULL,
		CTEPROGRAM [NVARCHAR](100) NULL,
		[DisciplineCount] int NULL)

	
	SET @SelectSQL = '
		select StateANSICode,
							StateCode,
							StateName,
							OrganizationIdentifierNces,
							OrganizationIdentifierSea,
							OrganizationName,
							ParentOrganizationIdentifierSea, 
							DISCIPLINARYACTIONTAKEN,
							DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES,
							IDEAINTERIMREMOVALREASON,
							IDEAINTERIMREMOVAL,
							REMOVALLENGTH,
							CASE WHEN REMOVALLENGTH = ''GREATER10'' THEN REMOVALLENGTH
							WHEN  REMOVALLENGTH <> ''GREATER10''  THEN ''LESS10'' END AS REMOVALLENGTHIDEA,
							SUM(DisciplineCount)
		'

	SET @GroupBySQL = '
		group by StateANSICode,
							StateCode,
							StateName,
							OrganizationIdentifierNces,
							OrganizationIdentifierSea,
							OrganizationName,
							ParentOrganizationIdentifierSea,  
							DISCIPLINARYACTIONTAKEN,
							DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES,
							IDEAINTERIMREMOVALREASON,
							IDEAINTERIMREMOVAL,
							REMOVALLENGTH,
							CASE WHEN REMOVALLENGTH = ''GREATER10'' THEN REMOVALLENGTH
							WHEN  REMOVALLENGTH <> ''GREATER10''  THEN ''LESS10'' END						
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
								StateAbbreviationCode,
								StateAbbreviationDescription,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								DISCIPLINARYACTIONTAKEN,
								DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES,
								IDEAINTERIMREMOVALREASON,
								IDEAINTERIMREMOVAL,
								REMOVALLENGTH,
								REMOVALLENGTHIDEA,
								DisciplineCount,
								Category,
								CTEPROGRAM)
	EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode;
	
	
	
	-- Zero Counts

	declare @zeroCountSQL as nvarchar(max)
	set @zeroCountSQL = ''
	
	SELECT @zeroCountSQL = [RDS].Get_CountSQL (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero-discipline', 1, 0,'','', @factTypeCode)

	EXECUTE sp_executesql @zeroCountSQL

	

	SELECT 			CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					@categorySetCode as CategorySetCode,
					NULL as ReportFilter,
					StateANSICode,
					StateAbbreviationCode,
					StateAbbreviationDescription,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					options.CategoryOptionName as Category1,
					NULL as Category2,
					NULL as Category3,
					NULL as Category4,
					CAST(SUM(CASE WHEN IDEAINTERIMREMOVAL = 'REMHO' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_1,
					CAST(SUM(CASE WHEN IDEAINTERIMREMOVAL = 'REMDW' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_2,
					CAST(SUM(CASE WHEN IDEAINTERIMREMOVALREASON = 'W' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_3,
					CAST(SUM(CASE WHEN IDEAINTERIMREMOVALREASON = 'D' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_4,
					CAST(SUM(CASE WHEN IDEAINTERIMREMOVALREASON = 'SBI' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_5,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'LESS10' AND IDEAINTERIMREMOVAL = 'REMHO' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_6,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'GREATER10' AND IDEAINTERIMREMOVAL = 'REMHO' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_7,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'LESS10' AND IDEAINTERIMREMOVAL = 'REMDW' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_8,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'GREATER10' AND IDEAINTERIMREMOVAL = 'REMDW' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_9,
					CAST(SUM(CASE WHEN REMOVALLENGTH IN ('LTOREQ1','2TO10','GREATER10') THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_10,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'LTOREQ1' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_10a,
					CAST(SUM(CASE WHEN REMOVALLENGTH = '2TO10' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_10b,
					CAST(SUM(CASE WHEN REMOVALLENGTH = 'GREATER10' THEN DisciplineCount ELSE 0 END) as decimal(18,2)) as col_11,
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
	#reportCounts r
	inner join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
				app.GenerateReports r 
				inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
				inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
				inner join app.Categories c on csc.CategoryId = c.CategoryId
				inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
				inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
				Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
				and cs.CategorySetCode = @categorySetCode ) options
	on r.Category = options.CategoryOptionCode
	Where r.Category <> 'MISSING'
	group by StateANSICode,
	StateAbbreviationCode,
	StateAbbreviationDescription,
	OrganizationNcesId,
	OrganizationStateId,
	OrganizationName,
	ParentOrganizationStateId,
	options.CategoryOptionName,
	Category

	drop table #reportCounts

	SET NOCOUNT OFF;


END