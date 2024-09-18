CREATE PROCEDURE [RDS].[Get_YeartoYearProgressReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@reportFilter as varchar(50),
	@reportSubFilter as varchar(50),
	@reportGrade as varchar(50),
	@reportLea as varchar(50) = null,
	@reportSchool as varchar(50) = null
AS
BEGIN


	SET NOCOUNT ON;


	-- Determine Fact/Report Tables

	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)
	declare @selectedYear as int
	declare @submissionYears as varchar(50), @pivotYears as varchar(50)

	
	DECLARE @SQL nvarchar(MAX), @tableSql nvarchar(max)
	DECLARE @DeclareSQL nvarchar(MAX), @InsertSQL nvarchar(MAX), @SelectSQL nvarchar(MAX), @GroupBySQL nvarchar(MAX)
	DECLARE @year1 as varchar(50), @year2 as varchar(50), @year3 as varchar(50), @year4 as varchar(50)

	declare @factTypeCode as varchar(50)

	select @factTypeCode = rds.Get_FactTypeByReport(@reportCode)
		
	-- Determine Fact/Report Tables

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	select @selectedYear = [Year]
	from rds.DimDates where SubmissionYear = @reportYear

	select @submissionYears = COALESCE(@submissionYears + ',', '') + Quotename(SubmissionYear, '''') 
	from rds.DimDates
	where [Year] in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)

	select @pivotYears = COALESCE(@pivotYears + ',', '') + '[' + SubmissionYear + ']'
	from rds.DimDates
	where [Year] in (@selectedYear, @selectedYear - 1, @selectedYear - 2, @selectedYear - 3)

	select @year1 = SubmissionYear
	from rds.DimDates
	where [Year] in (@selectedYear)

	select @year2 = SubmissionYear
	from rds.DimDates
	where [Year] in (@selectedYear - 1)

	select @year3 = SubmissionYear
	from rds.DimDates
	where [Year] in (@selectedYear - 2)

	select @year4 = SubmissionYear
	from rds.DimDates
	where [Year] in (@selectedYear - 3)
	
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
	and upper(d.DimensionFieldName) not in ('GRADELEVEL','ASSESSMENTSUBJECT')
	order by d.DimensionFieldName asc

	SET @SQL = '
		
		create table #organizations
		(
			[OrganizationName] [nvarchar](1000) NOT NULL,
			[OrganizationNcesId] [nvarchar](100) NOT NULL,
			[OrganizationStateId] [nvarchar](100) NOT NULL,
			[ParentOrganizationStateId] [nvarchar](100) NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateCode] [nvarchar](100) NOT NULL,
			[StateName] [nvarchar](500) NOT NULL,
		)

		create table #reportCounts
		(
			[OrganizationName] [nvarchar](1000) NOT NULL,
			[OrganizationNcesId] [nvarchar](100) NOT NULL,
			[OrganizationStateId] [nvarchar](100) NOT NULL,
			[ParentOrganizationStateId] [nvarchar](100) NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateCode] [nvarchar](100) NOT NULL,
			[StateName] [nvarchar](500) NOT NULL,
			ReportYear [nvarchar](50) NOT NULL,
			ProficiencyStatus [nvarchar](100) NULL,
			Category1 [nvarchar](100) NULL,
			AssessmentCount int NULL
		)

		create table #zeroCounts
		(
			[OrganizationName] [nvarchar](1000) NOT NULL,
			[OrganizationNcesId] [nvarchar](100) NOT NULL,
			[OrganizationStateId] [nvarchar](100) NOT NULL,
			[ParentOrganizationStateId] [nvarchar](100) NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateCode] [nvarchar](100) NOT NULL,
			[StateName] [nvarchar](500) NOT NULL,
			CategoryOptionCode [nvarchar](50) NOT NULL,
			CategoryOptionName [nvarchar](100) NULL,
			ProficiencyCode [nvarchar](50) NULL,
			ProficiencyLevel [nvarchar](100) NULL
		)
		'

		if @reportLevel = 'sea'
		begin
			SET @SQL = @SQL + ' insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, StateName)
			select SeaName, SeaStateIdentifier, SeaStateIdentifier, StateANSICode, StateCode, StateName from rds.DimSeas 
			where RecordEndDateTime IS NULL and DimSeaId <> -1'
		end
		else if @reportLevel = 'lea'
		begin
			SET @SQL = @SQL + ' insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, StateName, ParentOrganizationStateId)
			select LeaName, ISNULL(LeaNcesIdentifier, ''''), LeaStateIdentifier, StateANSICode, StateCode, StateName, SeaStateIdentifier from rds.DimLeas
			where RecordEndDateTime IS NULL and DimLeaId <> -1'
		end
		else if @reportLevel = 'sch'
		begin
			SET @SQL = @SQL + ' insert into #organizations(OrganizationName, OrganizationNcesId, OrganizationStateId, StateANSICode, StateCode, 
			StateName, ParentOrganizationStateId)
			select SchoolName, SchoolNcesIdentifier, SchoolStateIdentifier, StateANSICode, StateCode, StateName, LeaStateIdentifier from rds.DimSchools 
			where RecordEndDateTime IS NULL and DimSchoolId <> -1'
		end
		

		IF @reportLevel = 'lea' and @reportLea <> 'all' and LEN(@reportLea) > 0
		BEGIN
			SET @SQL = @SQL + ' and  LeaStateIdentifier = ' + @reportLea
		END

		IF @reportLevel = 'sch' and @reportSchool <> 'all' and LEN(@reportSchool) > 0
		BEGIN
			SET @SQL = @SQL + ' and  SchoolStateIdentifier = ' + @reportSchool
		END
	

	SET @SQL = @SQL + '


			INSERT INTO #reportCounts
			(StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			ReportYear,
			AssessmentCount,
			Category1,
			ProficiencyStatus
			)
	'	

	
	SET @SelectSQL = 'select f.StateANSICode,
							f.StateCode,
							f.StateName,
							f.OrganizationNcesId,
							f.OrganizationStateId,
							f.OrganizationName,
							f.ParentOrganizationStateId, 
							f.ReportYear,
							SUM(AssessmentCount)
		'

	SET @GroupBySQL = 'group by f.StateANSICode,
							f.StateCode,
							f.StateName,
							f.OrganizationNcesId,
							f.OrganizationStateId,
							f.OrganizationName,
							f.ParentOrganizationStateId, 
							f.ReportYear
		'


	declare @reportField as nvarchar(100)

	DECLARE reportField_cursor CURSOR FOR   
	select ReportField FROM @ReportFieldsInCategorySet

	OPEN reportField_cursor  
  
	FETCH NEXT FROM reportField_cursor INTO @reportField
	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		IF(@reportField = 'TITLE1SCHOOLSTATUS')
		BEGIN
			SET @SelectSQL = @SelectSQL + ', case when ' + @reportField + ' <> ''MISSING'' then ''Title1'' else ''NotTitle1'' end'
			SET @GroupBySQL = @GroupBySQL + ', case when ' + @reportField + ' <> ''MISSING'' then ''Title1'' else ''NotTitle1'' end'
		END
		ELSE IF(@reportField = 'MIGRANTSTATUS')
		BEGIN
			SET @SelectSQL = @SelectSQL + ', case when ' + @reportField + ' <> ''MISSING'' then ''MIGRANT'' else ''NonMigrant'' end'
			SET @GroupBySQL = @GroupBySQL + ', case when ' + @reportField + ' <> ''MISSING'' then ''MIGRANT'' else ''NonMigrant'' end'
		END
		ELSE
		BEGIN
			SET @SelectSQL = @SelectSQL + ',' + @reportField
			SET @GroupBySQL = @GroupBySQL + ',' + @reportField
		END
			

	FETCH NEXT FROM reportField_cursor INTO @reportField
	END
	CLOSE reportField_cursor;  
	DEALLOCATE reportField_cursor;
	
	IF(@categorySetCode = 'All')
	BEGIN
		SET @SelectSQL = @SelectSQL + ', ProficiencyStatus' 
		SET @GroupBySQL = @GroupBySQL + ', ProficiencyStatus'
	END
	
	SET @SelectSQL = @SelectSQL + 
	'
		from rds.' + @factReportTable +	' f
		inner join #organizations org on org.OrganizationStateId = f.OrganizationStateId
		Where ReportCode = @reportCode and ReportLevel = @reportLevel
		and ReportYear in (' + @submissionYears + ') and CategorySetCode = @categorySetCode
		and ASSESSMENTSUBJECT = @reportFilter and GradeLevel = @reportGrade
	'
	
	SET @SQL = @SQL + @SelectSQL + @GroupBySQL


	IF(@categorySetCode = 'All')
	BEGIN
		SET @SQL = @SQL + '

		INSERT INTO #zeroCounts
			(StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			CategoryOptionCode, CategoryOptionName, ProficiencyCode, ProficiencyLevel
			)
		select StateANSICode, StateCode, StateName, OrganizationNcesId, OrganizationStateId, OrganizationName, ParentOrganizationStateId,
				CategoryOptionCode, CategoryOptionName, ProficiencyCode, ProficiencyLevel
		from
		(SELECT distinct co.CategoryOptionCode as ProficiencyCode, co.CategoryOptionName as ProficiencyLevel, co.CategoryOptionCode, co.CategoryOptionName
						FROM app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId = cd.DimensionId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
						and cs.CategorySetCode = @categorySetCode
						and upper(d.DimensionFieldName) in (''PROFICIENCYSTATUS'')) options
		CROSS JOIN 
		(select * from #organizations) org

		'
	END
	ELSE
	BEGIN
	
		SET @SQL = @SQL + '

		INSERT INTO #zeroCounts
			(StateANSICode,
			StateCode,
			StateName,
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			CategoryOptionCode, CategoryOptionName, ProficiencyCode, ProficiencyLevel
			)
		select StateANSICode, StateCode, StateName, OrganizationNcesId, OrganizationStateId, OrganizationName, ParentOrganizationStateId,
				CategoryOptionCode, CategoryOptionName, ProficiencyCode, ProficiencyLevel
		from
		(select CategoryOptionCode, CategoryOptionName, ProficiencyCode, ProficiencyLevel  from
		(('
		

		IF(@categorySetCode = 'title1')
		BEGIN

			SET @SQL = @SQL + '	SELECT ''Title1'' as CategoryOptionCode, ''Title I'' as CategoryOptionName 
								UNION
								SELECT ''NotTitle1'' as CategoryOptionCode, ''Not Title I'' as CategoryOptionName
								'			
		END
		IF(@categorySetCode = 'migrant')
		BEGIN

			SET @SQL = @SQL + '	SELECT ''MIGRANT'' as CategoryOptionCode, ''Migrant Students'' as CategoryOptionName 
								UNION
								SELECT ''NonMigrant'' as CategoryOptionCode, ''Non Migrant Students'' as CategoryOptionName
								'			
		END
		ELSE
		BEGIN
		SET @SQL = @SQL + '	SELECT distinct co.CategoryOptionCode, co.CategoryOptionName 
						FROM app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId = cd.DimensionId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
						and cs.CategorySetCode = @categorySetCode
						and upper(d.DimensionFieldName) not in (''GRADELEVEL'',''ASSESSMENTSUBJECT'',''PROFICIENCYSTATUS'')
		'
		END
		
		SET @SQL = @SQL + ' ) catOptions
		CROSS JOIN
		(SELECT distinct co.CategoryOptionCode as ProficiencyCode, co.CategoryOptionName as ProficiencyLevel
						FROM app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId = cd.DimensionId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
						and cs.CategorySetCode = @categorySetCode
						and upper(d.DimensionFieldName) in (''PROFICIENCYSTATUS'')) profOptions)) options
		CROSS JOIN 
		(select * from #organizations) org

		'

	END



	
	

	SET @SQL = @SQL + '
					SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					@categorySetCode as CategorySetCode,
					z.ProficiencyLevel as ReportFilter,
					z.StateANSICode,
					z.StateCode,
					z.StateName,
					z.OrganizationNcesId,
					z.OrganizationStateId,
					z.OrganizationName,
					z.ParentOrganizationStateId,
					z.CategoryOptionName as Category1,
					NULL as Category2,
					NULL as Category3,
					NULL as Category4,
					isnull(col_1, 0) as col_1,
					isnull(col_2, 0) as col_2,
					isnull(col_3, 0) as col_3,
					isnull(col_4, 0) as col_4,
					NULL as col_5,
					NULL as col_6,
					NULL as col_7,
					NULL as col_8,
					NULL as col_9,
					NULL  as col_10,
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
					FROM #zeroCounts z
					left outer join
					(select StateANSICode,	StateCode, StateName, OrganizationNcesId, OrganizationStateId, OrganizationName, ParentOrganizationStateId,
						Category, ProficiencyStatus, 
						ISNULL(CAST(SUM([' + @year1 + ']) as decimal(18, 2)), 0) as col_1,
						ISNULL(CAST(SUM([' + @year2 + ']) as decimal(18, 2)), 0) as col_2,
						ISNULL(CAST(SUM([' + @year3 + ']) as decimal(18, 2)), 0) as col_3,
						ISNULL(CAST(SUM([' + @year4 + ']) as decimal(18, 2)), 0) as col_4
					FROM
					(
						SELECT StateANSICode,StateCode,StateName,OrganizationNcesId,OrganizationStateId,OrganizationName,
						ParentOrganizationStateId,ReportYear,r.Category1 as Category,ProficiencyStatus,AssessmentCount
						FROM #reportCounts r
					) as SourceTable
					PIVOT
					(	
						SUM(AssessmentCount)
						FOR ReportYear IN (' + @pivotYears + ')
					) AS PivotTable
					group by StateANSICode,
					StateCode,
					StateName,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category,
					ProficiencyStatus) r
					on z.OrganizationStateId = r.OrganizationStateId and r.Category = z.CategoryOptionCode and r.ProficiencyStatus = z.ProficiencyCode
					where z.CategoryOptionName <> ''MISSING''

		drop table #zeroCounts
		drop table #reportCounts
		drop table #organizations

		'

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
	    SET @ParmDefinition = N'@reportCode varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @reportFilter varchar(100), @reportGrade varchar(50), 
		@reportYear varchar(50)';  
		EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @reportFilter = @reportFilter, 
		@reportGrade = @reportGrade, @reportYear = @reportYear;

	SET NOCOUNT OFF;
	
END