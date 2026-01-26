CREATE PROCEDURE [RDS].[Create_ReportData_ZeroCounts]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@tableTypeAbbrv as varchar(50),
	@includeZeroCounts as bit,
	@includeFriendlyCaptions as bit,
	@obscureMissingCategoryCounts as bit,
	@isOnlineReport as bit = 0,
	@runAsTest as bit = 0
AS

BEGIN

	--declare
	--@reportCode as varchar(50) = '002',
	--@reportLevel as varchar(50) = 'sea',
	--@reportYear as varchar(50) = '2025',
	--@categorySetCode as varchar(50) = 'csa',
	--@includeZeroCounts as bit = 1,
	--@includeFriendlyCaptions as bit = 0,
	--@obscureMissingCategoryCounts as bit = 1,
	--@isOnlineReport as bit = 0,
	--@runAsTest as bit=0

	SET NOCOUNT ON;

	--just in case the cursor wasn't removed
	if cursor_status('global','categoryset_cursor1') >= -1
	begin
		deallocate categoryset_cursor1
	end

	-- Determine Fact/Report Tables
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)
	declare @factReportDtoId as varchar(50)
	declare @factTypeCode as varchar(50)
	declare @year as int
	declare @toggleLunchCounts varchar(30)
	declare @zeroCntSql as varchar(MAX) = ''

	select @factTypeCode = (select dft.FactTypeCode
							from app.GenerateReport_FactType grft
								inner join app.GenerateReports gr
									on grft.GenerateReportId = gr.GenerateReportId
								inner join rds.DimFactTypes dft
									on grft.FactTypeId = dft.DimFactTypeId
							where gr.ReportCode = @reportCode)

	select @year = SchoolYear from rds.DimSchoolYears where SchoolYear = @reportYear

	-- Determine Fact/Report Tables
	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName, 
	@factReportDtoId = ft.FactReportDtoIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	select @toggleLunchCounts = r.ResponseValue
	from app.ToggleQuestions q
	left outer join app.ToggleResponses r
		on r.ToggleQuestionId = q.ToggleQuestionId
	WHERE q.EmapsQuestionAbbrv = 'LUNCHCOUNTS'

	--Manually exclude the 0 counts from the Reports that are using the new dynamic logic
	if @reportCode in ('218','219','220','221','222','224','225','226')
	begin
		set @includeZeroCounts = 0
	end

	if @factTable = 'FactCustomCounts'
	begin
		select
			FactCustomCountId,
			ReportCode,
			ReportYear,
			ReportLevel,
			ReportFilter,
			CategorySetCode,
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,			
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			Category1,
			Category2,
			Category3,
			Category4,
			col_1,
			col_2,
			col_3,
			col_4,
			col_5,
			col_6,
			col_7,
			col_8,
			col_9,
			col_10,
			col_10a,
			col_10b,
			col_11,
			col_11a,
			col_11b,
			col_11c,
			col_11d,
			col_11e,
			col_12,
			col_12a,
			col_12b,
			col_13,
			col_14,
			col_14a,
			col_14b,
			col_14c,
			col_14d,
			col_15,
			col_16,
			col_17,
			col_18,
			col_18a,
			col_18b,
			col_18c,
			col_18d,
			col_18e,
			col_18f,
			col_18g,
			col_18h,
			col_18i
		from rds.FactCustomCounts
		where ReportCode = @reportCode and ReportLevel = @reportLevel and ReportYear = @reportYear
		and CategorySetCode = isnull(@categorySetCode, CategorySetCode)
		return
	end

	-- Get Categories available to this report
	declare @ReportFieldsInFactTable as table (
		ReportField nvarchar(100)
	)
	delete from @ReportFieldsInFactTable

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		insert into @ReportFieldsInFactTable 
		(ReportField)
		select distinct upper(d.DimensionFieldName) as ReportField
		from App.Dimensions d 
		inner join App.FactTable_DimensionTables fd on d.DimensionTableId = fd.DimensionTableId
		inner join App.FactTables ft on fd.FactTableId = ft.FactTableId
		where ft.FactTableName = @factTable and upper(d.DimensionFieldName) <> 'YEAR'

	end
	else
	begin
		insert into @ReportFieldsInFactTable 
		(ReportField)
		select distinct upper(d.DimensionFieldName) as ReportField
		from App.Dimensions d 
		inner join App.FactTable_DimensionTables fd on d.DimensionTableId = fd.DimensionTableId
		inner join App.FactTables ft on fd.FactTableId = ft.FactTableId
		where ft.FactTableName = @factTable 
	end
	
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
	left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
	where r.ReportCode = @reportCode
	and cs.SubmissionYear = @reportYear
	and o.LevelCode = @reportLevel
	and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
	and tt.TableTypeAbbrv = @tableTypeAbbrv


	declare @sql as nvarchar(max)
	declare @sqlReportFieldsDefinition as nvarchar(max)
	declare @sqlInsertDefinition as nvarchar(max)
	declare @sqlSelectBeginning as nvarchar(max)
	declare @sqlCategories as nvarchar(max)
	declare @performanceCountSql as nvarchar(max)
	set @sql = ''
	set @sqlReportFieldsDefinition = ''
	set @sqlInsertDefinition = ''
	set @sqlSelectBeginning = ''
	set @sqlCategories = ''
	set @performanceCountSql = ''

	declare @isPerformanceSql as bit
	set @isPerformanceSql = 0
	if @reportCode in ('175','178','179') and @reportLevel <> 'sea' and @year <= 2018 and LEN(ISNULL(@categorySetCode,'')) < 1
		begin
			set @isPerformanceSql = 1
		end

	if @includeFriendlyCaptions = 1
		begin
			set @sql = @sql + '
				declare @friendlyValues as table (
					ReportField varchar(200),
					CategoryOptionCode varchar(100),
					CategoryOptionName varchar(500)
				)

				insert @friendlyValues
				(ReportField, CategoryOptionCode, CategoryOptionName) 
				select upper(d.DimensionFieldName), opt.CategoryOptionCode, opt.CategoryOptionName
				from app.CategoryOptions opt
				inner join app.Categories c on opt.CategoryId = c.CategoryId
				inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
				inner join app.Dimensions d on cd.DimensionId = d.DimensionId
				inner join app.CategorySets cs on opt.CategorySetId = cs.CategorySetId
				inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
				inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
				left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
				where r.ReportCode = @reportCode
				and o.LevelCode = @reportLevel
				and cs.SubmissionYear = @reportYear
				and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
				and tt.TableTypeAbbrv = @tableTypeAbbrv
			'
		end
	
	set @sql = @sql + '
		declare @reportData as table (
			[' + @factReportId + '] [int] identity NOT NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateAbbreviationCode] [nvarchar](100) NOT NULL,
			[StateAbbreviationDescription] [nvarchar](500) NOT NULL,
			
			[OrganizationIdentifierNces] [nvarchar](100) NULL,
			[OrganizationIdentifierSea] [nvarchar](100) NULL,
			[OrganizationName] [nvarchar](1000) NULL,
			[ParentOrganizationIdentifierSea] [nvarchar](100) NULL,

			[Categories] [nvarchar](300) NULL,
			[CategorySetCode] [nvarchar](40) NOT NULL,
			[TableTypeAbbrv] [nvarchar](100) NOT NULL,
			[TotalIndicator] [nvarchar](5) NOT NULL,
		'
	
	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		set @sqlInsertDefinition = @sqlInsertDefinition + 'StaffCount [int] NOT NULL,'
		set @sqlInsertDefinition = @sqlInsertDefinition + '
			[' + @factField + '] [decimal](18,2) NOT NULL
		)'
	end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
	begin
		set @sqlInsertDefinition = @sqlInsertDefinition + '
			[' + @factField + '] [int] NOT NULL, 
			[ADJUSTEDCOHORTGRADUATIONRATE] [decimal](18,2) NOT NULL
		)'
	end
	else
	begin
		set @sqlInsertDefinition = @sqlInsertDefinition + '
			[' + @factField + '] [int] NOT NULL
		)'
	end

	-- @sqlInsertDefinition
	set @sqlInsertDefinition = @sqlInsertDefinition + '
		insert into @reportData
		(
			StateANSICode,
			StateAbbreviationCode,
			StateAbbreviationDescription,			
			OrganizationIdentifierNces,
			OrganizationIdentifierSea,
			OrganizationName,
			ParentOrganizationIdentifierSea,
			Categories,
			TableTypeAbbrv,
			TotalIndicator,
		'

	-- @sqlSelectBeginning
	set @sqlSelectBeginning = '
		select	DISTINCT		
			f.StateANSICode,
			f.StateAbbreviationCode,
			f.StateAbbreviationDescription,			
			f.OrganizationIdentifierNces,
			f.OrganizationIdentifierSea,
			f.OrganizationName,
			f.ParentOrganizationIdentifierSea,
			f.Categories,
			f.TableTypeAbbrv ,
			f.TotalIndicator,
		'

	declare @sqlIncludedSelectList as nvarchar(max)
	set @sqlIncludedSelectList = ''
	declare @sqlIncludedFieldList as nvarchar(max)
	set @sqlIncludedFieldList = ''
	declare @sqlFriendlyTableList as nvarchar(max)
	set @sqlFriendlyTableList = ''
	DECLARE @tableTypeAbbrvs as varchar(50)
	set @tableTypeAbbrvs=''
	DECLARE @totalIndicators as varchar(1)
	set @totalIndicators=''
	declare @reportField as nvarchar(100)

	DECLARE reportField_cursor CURSOR FOR 
	SELECT ReportField
	FROM @ReportFieldsInFactTable

	OPEN reportField_cursor
	FETCH NEXT FROM reportField_cursor INTO @reportField

	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @sqlReportFieldsDefinition = @sqlReportFieldsDefinition + '[' + @reportField + '] [nvarchar](500) NULL,
		'
		set @sqlIncludedFieldList = @sqlIncludedFieldList + @reportField + ',
		'
		if exists (select 1 from @ReportFieldsInCategorySet where ReportField = @reportField)
		begin
			set @sqlCategories = @sqlCategories + ' and ' + @reportField + ' = ''MISSING'''
		end

		if @includeFriendlyCaptions = 1
		begin
			set @sqlIncludedSelectList = @sqlIncludedSelectList + '(select TOP 1 CategoryOptionName from @friendlyValues where CategoryOptionCode = f.' + @reportField + ' and ReportField = ''' + @reportField + ''') as ' + @reportField + ',
			'
		end
		else
		begin
			set @sqlIncludedSelectList = @sqlIncludedSelectList + 'f.' + @reportField + ',
			'
		end

		FETCH NEXT FROM reportField_cursor INTO @reportField
	END

	CLOSE reportField_cursor
	DEALLOCATE reportField_cursor

	--=====================================================================================

		set @zeroCntSql = @zeroCntSql + '
			--[' + @factReportId + '] ,
			[ReportCode] ,
			[ReportLevel] ,
			[ReportYear] ,
			[StateANSICode] ,
			[StateAbbreviationCode] ,
			[StateAbbreviationDescription] ,			
			[OrganizationIdentifierNces] ,
			[OrganizationIdentifierSea] ,
			[OrganizationName] ,
			[ParentOrganizationIdentifierSea] ,
			[Categories] ,
			[CategorySetCode] ,
			[TableTypeAbbrv] ,
			[TotalIndicator] ,
		'

	DECLARE reportField_cursor1 CURSOR FOR 
	SELECT ReportField
	FROM @ReportFieldsInFactTable

	OPEN reportField_cursor1
	FETCH NEXT FROM reportField_cursor1 INTO @reportField

	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @zeroCntSql = @zeroCntSql + '[' + @reportField + '] ,
		'
		--set @sqlIncludedFieldList = @sqlIncludedFieldList + @reportField + ',
		--'
		--if exists (select 1 from @ReportFieldsInCategorySet where ReportField = @reportField)
		--begin
		--	set @sqlCategories = @sqlCategories + ' and ' + @reportField + ' = ''MISSING'''
		--end

		--if @includeFriendlyCaptions = 1
		--begin
		--	set @sqlIncludedSelectList = @sqlIncludedSelectList + '(select TOP 1 CategoryOptionName from @friendlyValues where CategoryOptionCode = f.' + @reportField + ' and ReportField = ''' + @reportField + ''') as ' + @reportField + ',
		--	'
		--end
		--else
		--begin
		--	set @sqlIncludedSelectList = @sqlIncludedSelectList + 'f.' + @reportField + ',
		--	'
		--end

		FETCH NEXT FROM reportField_cursor1 INTO @reportField
	END

	CLOSE reportField_cursor1
	DEALLOCATE reportField_cursor1

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		set @zeroCntSql = @zeroCntSql + '
			[' + @factField + '] ,
			[StaffCount]
		'
	end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
	begin
		set @zeroCntSql = @zeroCntSql + '
			[' + @factField + '] , 
			[ADJUSTEDCOHORTGRADUATIONRATE] 
		'
	end
	else
	begin
		set @zeroCntSql = @zeroCntSql + '
			[' + @factField + '] 
		'
	end

	SET @zeroCntSql = '
	INSERT INTO RDS.' + @factReportTable + ' (
	' + @zeroCntSql + '
	)'

	--PRINT '=@zeroCntSql=='
	--PRINT @zeroCntSql
	--PRINT '=@zeroCntSql=='

	--=====================================================================================

	--PRINT '==='
	--PRINT @sql
	--PRINT '==='
	--PRINT @sqlReportFieldsDefinition
	--PRINT '==='
	--PRINT @sqlInsertDefinition
	--PRINT '==='

	set @sql = @sql + @sqlReportFieldsDefinition + @sqlInsertDefinition + @sqlIncludedFieldList

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		set @sql = @sql + 'StaffCount,'
	end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
	begin
		set @sql = @sql + 'ADJUSTEDCOHORTGRADUATIONRATE, '
	end

	set @sql = @sql + '
		' + @factField + ',
		CategorySetCode '
	
	set @sql = @sql + ')'

	set @sql = @sql + @sqlSelectBeginning + @sqlIncludedSelectList

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		set @sql = @sql + 'f.StaffCount,'
	end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
	begin
		set @sql = @sql + 'ISNULL(f.ADJUSTEDCOHORTGRADUATIONRATE,0.0) as ADJUSTEDCOHORTGRADUATIONRATE,'
	end

	set @sql = @sql + '
		f.' + @factField + ',
		f.CategorySetCode '
	
	set @sql = @sql + '
		from rds.' + @factReportTable + ' f
		inner join app.OrganizationLevels o on f.ReportLevel = o.LevelCode
		inner join app.GenerateReports r on f.ReportCode = r.ReportCode
		inner join app.CategorySets cs on f.CategorySetCode = cs.CategorySetCode and cs.GenerateReportId = r.GenerateReportId and cs.OrganizationLevelId = o.OrganizationLevelId and cs.SubmissionYear = f.ReportYear
		' + @sqlFriendlyTableList + '
		where f.ReportCode = @reportCode
		and f.ReportYear = @reportYear
		and f.ReportLevel = @reportLevel
		and f.CategorySetCode = isnull(@categorySetCode, f.CategorySetCode)		
		and f.TableTypeAbbrv = @tableTypeAbbrv
	'

	declare @categoryCode as nvarchar(150)
	declare @catSetCode as nvarchar(150)
	declare @zeroCountSql as nvarchar(max)
	declare @catSetCount as int
	declare @includeOrganizationSQL as bit
	set @zeroCountSql = ''
	set @catSetCount = 0
	set @includeOrganizationSQL = 0

	if(@isPerformanceSql = 1)
	begin
		declare @sqlCategoryFieldDefs as varchar(max)
		set @sqlCategoryFieldDefs = ''

		set @sql = @sql + '			
			CREATE table #CAT_PerformanceLevel(Code varchar(50))
			
			DELETE FROM #CAT_PerformanceLevel
					
			insert into #CAT_PerformanceLevel(Code)
			SELECT distinct o.CategoryOptionCode
			from app.CategoryOptions o
			inner join app.Categories c on o.CategoryId = c.CategoryId
			and c.CategoryCode = ''PERFLVL''
			and o.CategoryOptionCode <> ''MISSING''
			' 
		if(LEN(ISNULL(@categorySetCode,'')) < 1)
		begin
			DECLARE categoryset_cursor1 CURSOR FOR 
			select cs.CategorySetCode, tt.TableTypeAbbrv,
				CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
					ELSE 'N'
				END as TotalIndicator 
			from app.CategorySets cs
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels levels 
				on cs.OrganizationLevelId = levels.OrganizationLevelId
			left outer join app.TableTypes tt 
				on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode 
			and levels.LevelCode = @reportLevel 
			and cs.SubmissionYear = @reportYear
			order by cs.CategorySetSequence

			OPEN categoryset_cursor1
			FETCH NEXT FROM categoryset_cursor1 INTO @catSetCode, @tableTypeAbbrvs, @totalIndicators

			WHILE @@FETCH_STATUS = 0
			BEGIN
				set @sqlCategoryFieldDefs = ''
				DECLARE category_cursor CURSOR FOR 
				select upper(d.DimensionFieldName) as ReportField 
				from app.CategorySets cs
				inner join app.GenerateReports r 
					on cs.GenerateReportId = r.GenerateReportId
				inner join app.OrganizationLevels o 
					on cs.OrganizationLevelId = o.OrganizationLevelId
				inner join app.CategorySet_Categories csc	
					on cs.CategorySetId = csc.CategorySetId
				inner join app.Categories c 
					on csc.CategoryId = c.CategoryId
				inner join app.Category_Dimensions cd 
					on c.CategoryId = cd.CategoryId
				inner join app.Dimensions d 
					on cd.DimensionId = d.DimensionId
				inner join App.DimensionTables dt 
					on dt.DimensionTableId = d.DimensionTableId
				left outer join app.TableTypes tt 
					on cs.TableTypeId = tt.TableTypeId
				where r.ReportCode = @reportCode
				and cs.CategorySetCode = @catSetCode 
				and cs.SubmissionYear = @reportYear 
				and o.LevelCode = @reportLevel 

				OPEN category_cursor
				FETCH NEXT FROM category_cursor INTO @reportField

				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @sqlCategoryFieldDefs = @sqlCategoryFieldDefs + ', ' + @reportField + ' varchar(100)'
					FETCH NEXT FROM category_cursor INTO @reportField
				END

				CLOSE category_cursor
				DEALLOCATE category_cursor

			set @sql = @sql + '	
				CREATE table #performanceData_' + @catSetCode + '( 
				[StateANSICode] [nvarchar](100) NOT NULL,
				[StateCode] [nvarchar](100) NOT NULL,
				[StateName] [nvarchar](500) NOT NULL,
							
				[OrganizationIdentifierNces] [nvarchar](100) NULL,
				[OrganizationIdentifierSea] [nvarchar](100) NULL,
				[OrganizationName] [nvarchar](1000) NULL,
				[ParentOrganizationIdentifierSea] [nvarchar](100) NULL,

				[CategorySetCode] [nvarchar](40) NOT NULL,
				[TableTypeAbbrv] [nvarchar](100) NOT NULL,
				[TotalIndicator] [nvarchar](5) NOT NULL,
				AssessmentSubject nvarchar(50) NULL,
				AssessmentCount int' 
				+ @sqlCategoryFieldDefs + 
				' )
				truncate table #performanceData_' + @catSetCode + '
			' 
			PRINT '  123'
			SELECT @performanceCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @catSetCode, 'performanceLevels',0, 0,@tableTypeAbbrvs,@totalIndicators, @factTypeCode)

			IF(@performanceCountSql IS NOT NULL)
			begin
				set @sql = @sql + '
					' + @performanceCountSql
			end

			set @sql = @sql + '			
				drop table #performanceData_' + @catSetCode + '
			'
			--print @performanceCountSql
			FETCH NEXT FROM categoryset_cursor1 INTO @catSetCode, @tableTypeAbbrvs, @totalIndicators
			END
						
			CLOSE categoryset_cursor1
			DEALLOCATE categoryset_cursor1
		end
		set @sql = @sql + '			
			drop table #CAT_PerformanceLevel
		'
	end			-- END @isPerformanceSql = 1

	--ChildCount
	if @reportCode in ('002', '089')
	begin
		set @includeZeroCounts = 0
		if @reportLevel = 'SEA' set @includeZeroCounts = 1
		if @reportLevel <> 'SEA' and @categorySetCode = 'TOT' set @includeZeroCounts = 1
	end
	--Discipline
	if @reportCode in ('005','006','007','088','143','144')
	begin 
		if @reportLevel = 'sea' 
			set @includeZeroCounts = 1
		else 
			set @includeZeroCounts = 0
	end
	--Assessments
	if @reportCode in ('175','178','179','185','188','189') 
	begin
		if @reportLevel = 'sea'
			set @includeZeroCounts = 1
		else 
			set @includeZeroCounts = 0
	end
	--Homeless
	if @reportCode in ('118','194') 
	begin
		if @reportLevel = 'sea'
			set @includeZeroCounts = 1
		else 
			set @includeZeroCounts = 0
	end
	--TitleIIIELSY
	if @reportCode in ('045', '116')
	begin
		set @includeZeroCounts = 0
		if @reportCode = '116' and @reportLevel = 'sea' set @includeZeroCounts = 1
	end

	-- Zero Counts
	if @includeZeroCounts = 1
	begin		
		if(LEN(ISNULL(@categorySetCode,'')) < 1)
		begin
			DECLARE categoryset_cursor1 CURSOR FOR 
			select cs.CategorySetCode, tt.TableTypeAbbrv,
			CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
					ELSE 'N'
			END as TotalIndicator 
			from app.CategorySets cs
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels levels 
				on cs.OrganizationLevelId =levels.OrganizationLevelId
			left outer join app.TableTypes tt 
				on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode 
			and levels.LevelCode = @reportLevel 
			and cs.SubmissionYear = @reportYear
			and tt.TableTypeAbbrv = @tableTypeAbbrv
			order by cs.CategorySetSequence

			OPEN categoryset_cursor1
			FETCH NEXT FROM categoryset_cursor1 INTO @catSetCode,@tableTypeAbbrvs, @totalIndicators

			WHILE @@FETCH_STATUS = 0
			BEGIN
				set @catSetCount = @catSetCount + 1
				IF(@catSetCount = 1)
				begin
					set @includeOrganizationSQL = 1
				end
				else 
				begin
					set @includeOrganizationSQL = 0
				end
				PRINT '  234'
				SELECT @zeroCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @catSetCode, 'zero',@includeOrganizationSQL, 1,@tableTypeAbbrvs, @totalIndicators, @factTypeCode)
				
				IF(@zeroCountSql IS NOT NULL)
				begin
					set @sql = @sql + '
						' + @zeroCountSql
				end
				FETCH NEXT FROM categoryset_cursor1 INTO @catSetCode,@tableTypeAbbrvs, @totalIndicators
			END

			CLOSE categoryset_cursor1
			DEALLOCATE categoryset_cursor1

			if @reportCode in ('032')
			begin
				set @sql = @sql + '
					delete a from @reportData a '
				
				set @sql = @sql + '
					inner join (select OrganizationName, CategorySetCode from @reportData group by OrganizationName, 
					CategorySetCode having sum(' + @factField + ') = 0 and CategorySetCode <> ''TOT'') b'
				
				set @sql = @sql + '
					on a.CategorySetCode = b.CategorySetCode and a.OrganizationName = b.OrganizationName
				'

				set @sql = @sql + '
					delete a from @reportData a '

				set @sql = @sql + '
					inner join (select OrganizationName, GRADELEVEL, CategorySetCode  from @reportData group by OrganizationName, Gradelevel, 
					CategorySetCode having sum(' + @factField + ') = 0 and CategorySetCode like ''CS%'') b'
				set @sql = @sql + '
				on a.CategorySetCode = b.CategorySetCode and a.OrganizationName = b.OrganizationName and a.GRADELEVEL = b.GRADELEVEL
				'
			end

			if @reportCode = '033'
			BEGIN
				-- Exclude the Category Set A for Schools if there are no students
				set @sql = @sql + 'delete a from @reportData a
					inner join 
					(select OrganizationIdentifierSea, TableTypeAbbrv, CategorySetCode, sum(StudentCount) as totalStudentCount 
					from @reportData group by OrganizationIdentifierSea, CategorySetCode, TableTypeAbbrv 
					having sum(StudentCount) < 1 and CategorySetCode <> ''TOT'' and TableTypeAbbrv = ''LUNCHFREERED''	) b
					on a.CategorySetCode = b.CategorySetCode and a.OrganizationIdentifierSea = b.OrganizationIdentifierSea and a.TableTypeAbbrv = b.TableTypeAbbrv '
			END

			if @reportCode = '052'
			BEGIN
				-- Exclude the Category Set A and SubTotals for the LEA or Schools if there are no students
				set @sql = @sql + 'delete a from @reportData a
					inner join 
					(select OrganizationIdentifierSea, CategorySetCode, sum(StudentCount) as totalStudentCount from @reportData group by OrganizationIdentifierSea, CategorySetCode having sum(StudentCount) < 1 and CategorySetCode <> ''TOT''	) b
					on a.CategorySetCode = b.CategorySetCode and a.OrganizationIdentifierSea = b.OrganizationIdentifierSea'

				set @sql = @sql + ' delete a from @reportData a 
					inner join 
					(select OrganizationIdentifierSea, GRADELEVEL, CategorySetCode, sum(StudentCount) as totalStudentCount from @reportData group by OrganizationIdentifierSea, GRADELEVEL, CategorySetCode having sum(StudentCount) < 1 and 
					CategorySetCode in (''CSA'', ''ST1'', ''ST2'' )) b
					on a.CategorySetCode = b.CategorySetCode and a.OrganizationIdentifierSea = b.OrganizationIdentifierSea  and a.GRADELEVEL = b.GRADELEVEL
				'
			END
		end
		else
		begin
		--STUDPERFMLG, STUDPERFMHS
			set @includeOrganizationSQL = 1

			select @totalIndicators = 
			CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 THEN 'Y'
					ELSE 'N'
			END
			from app.CategorySets cs
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels levels 
				on cs.OrganizationLevelId =levels.OrganizationLevelId
			left outer join app.TableTypes tt 
				on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode 
			and levels.LevelCode = @reportLevel 
			and cs.SubmissionYear = @reportYear
			and tt.TableTypeAbbrv = @tableTypeAbbrv
			and cs.CategorySetCode = @categorySetCode

			SELECT @zeroCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero',@includeOrganizationSQL, 0, @tableTypeAbbrv, @totalIndicators, @factTypeCode)

			--PRINT '  456'
			--PRINT ' @reportCode - ' + cast ( @reportCode as varchar (10))
			--PRINT ' @reportLevel - ' + cast ( @reportLevel as varchar (10))
			--PRINT ' @reportYear - ' + cast ( @reportYear as varchar (10))
			--PRINT ' @categorySetCode - ' + cast ( @categorySetCode as varchar (10))
			--PRINT ' @includeOrganizationSQL - ' + cast ( @includeOrganizationSQL as varchar (10))
			--PRINT ' @tableTypeAbbrvs - ' + cast ( @tableTypeAbbrvs as varchar (10))
			--PRINT ' @totalIndicators - ' + cast ( @totalIndicators as varchar (10))
			--PRINT ' @factTypeCode - ' + cast ( @factTypeCode as varchar (10))
			--PRINT '---'

			IF(@zeroCountSql IS NOT NULL)
			begin
				set @sql = @sql + '
					' + @zeroCountSql
			end

		end

		-- Exclude Free/Reduced counts if toggle requires it
		if @reportCode = '033' and @toggleLunchCounts = 'Direct Certification Only'
		begin
			set @sql = @sql + 'delete from @reportData where TableTypeAbbrv = ''LUNCHFREERED'' '
		end

	end		-- END @includeZeroCounts = 1

	--print '@reportCode='+@reportCode
	--print '@zeroCountSql='+@zeroCountSql

	-- Obscure missing category counts with -1 values
	if @obscureMissingCategoryCounts = 1
	begin
		declare @sqlMissingAdjustment as nvarchar(max)
		set @sqlMissingAdjustment = ''
		declare @cs as nvarchar(50)
		declare @rf as nvarchar(50)

		DECLARE reportField_cursor CURSOR FOR   
		select cs.CategorySetCode, upper(d.DimensionFieldName) as ReportField
		from app.Dimensions d 
		inner join app.Category_Dimensions cd 
			on d.DimensionId = cd.DimensionId
		inner join app.Categories c 
			on cd.CategoryId = c.CategoryId
		inner join app.CategorySet_Categories csc 
			on c.CategoryId = csc.CategoryId
		inner join app.CategorySets cs 
			on csc.CategorySetId = cs.CategorySetId
		inner join app.GenerateReports r 
			on cs.GenerateReportId = r.GenerateReportId
		inner join app.GenerateReportTypes t 
			on r.GenerateReportTypeId = t.GenerateReportTypeId
		inner join app.OrganizationLevels o 
			on cs.OrganizationLevelId = o.OrganizationLevelId
		left outer join app.TableTypes tt
			on cs.TableTypeId = tt.TableTypeId
		where r.ReportCode = @reportCode
		and cs.SubmissionYear = @reportYear
		and o.LevelCode = @reportLevel
		and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
		and tt.TableTypeAbbrv = @tableTypeAbbrv
		order by cs.CategorySetCode, d.DimensionFieldName

		OPEN reportField_cursor  
  
		FETCH NEXT FROM reportField_cursor INTO @cs, @rf
  		WHILE @@FETCH_STATUS = 0  
		BEGIN
			SET @sqlMissingAdjustment = @sqlMissingAdjustment + '
				SET @missingCnt = 0
				SET @nonMissingCnt = 0

				SELECT @missingCnt = Count(*) FROM @reportData Where CategorySetCode = ''' + @cs + ''' Group BY ' +  @rf + ' HAVING ' +  @rf + ' = ''MISSING''
				SELECT @nonMissingCnt = Count(*) FROM @reportData Where CategorySetCode = ''' + @cs + ''' Group BY ' +  @rf + ' HAVING ' +  @rf + ' <> ''MISSING'' AND ''' + @rf + ''' IS NOT NULL
			
				IF(@missingCnt > 0 AND @nonMissingCnt > 0)
				BEGIN
					DELETE FROM @reportData Where CategorySetCode = ''' + @cs + ''' AND ' + @reportField + ' = ''MISSING''
				END
				IF(@missingCnt > 0 AND @nonMissingCnt <= 0)
				BEGIN
					UPDATE @reportData SET ' + @factField + ' = -1 Where CategorySetCode = ''' + @cs + ''' AND ' + @rf + ' = ''MISSING''
				END
			'
			--print @sqlMissingAdjustment
			FETCH NEXT FROM reportField_cursor INTO @cs, @rf
		END

		CLOSE reportField_cursor;  
		DEALLOCATE reportField_cursor;  
	
		set @sql = @sql + '	
			declare @missingCnt as int
			declare @nonMissingCnt as int
		' + @sqlMissingAdjustment;
	end

	set @sql = @sql + @zeroCntSql + '
	'
/*
	set @sql = @sql + '
		select ' + @factReportId + ',' + '''' + @reportCode + ''' as ReportCode'
		+ ',' + '''' + @reportLevel +  ''' as ReportLevel' + ',' 
		+ '''' + @reportYear +  ''' as ReportYear' + ',
		StateANSICode,
		StateAbbreviationCode,
		StateAbbreviationDescription,		
		OrganizationIdentifierNces,
		OrganizationIdentifierSea,
		OrganizationName,
		ParentOrganizationIdentifierSea,
		Categories,
		CategorySetCode,
		TableTypeAbbrv,
		TotalIndicator, 
		'+ @sqlIncludedFieldList + '
		' + @factField 
*/

	set @sql = @sql + '
		select 
		--' + @factReportId + ',
		'+ '''' + @reportCode + ''' as ReportCode'
		+ ',' + '''' + @reportLevel +  ''' as ReportLevel' + ',' 
		+ '''' + @reportYear +  ''' as ReportYear' + ',
		StateANSICode,
		StateAbbreviationCode,
		StateAbbreviationDescription,		
		OrganizationIdentifierNces,
		OrganizationIdentifierSea,
		OrganizationName,
		ParentOrganizationIdentifierSea,
		Categories,
		CategorySetCode,
		TableTypeAbbrv,
		TotalIndicator, 
		'+ @sqlIncludedFieldList + '
		' + @factField 

	

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
	begin
		set @sql = @sql + ', StaffCount'
	end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
	begin
		set @sql = @sql + ', ADJUSTEDCOHORTGRADUATIONRATE'
	end
	
	--set @sql = @sql + '
	--	FROM @reportData WHERE STUDENTCOUNT = 0 
	--'

	set @sql = @sql + '
		FROM @reportData WHERE '+@factField+' = 0 
	'

	set @sql = @sql + '
		IF OBJECT_ID(''#CAT_Organizations'') IS NOT NULL
			DROP TABLE #CAT_Organizations
	'
	-------------------------------------------------



	-------------------------------------------------
	/*
	DECLARE @ColCount INT = (Select COUNT(A.COLUMN_NAME) from INFORMATION_SCHEMA.COLUMNS a where a.TABLE_NAME  = @factReportTable)--= 'ReportEDFactsK12StudentCounts')
	DECLARE @ColName VARCHAR(500), @allCols VARCHAR(MAX) = ' ' + CHAR(10), @COUNTER INT =0

	DECLARE tblCols_cursor CURSOR FOR 
	SELECT A.COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS a where a.TABLE_NAME = @factReportTable --'ReportEDFactsK12StudentCounts'

	OPEN tblCols_cursor
	FETCH NEXT FROM tblCols_cursor INTO @ColName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		IF @ColName = 'ReportCode' OR @ColName = 'ReportLevel' OR @ColName = 'ReportYear' OR @ColName = @factReportId
		BEGIN 
			PRINT @ColName
			SET @COUNTER = @COUNTER + 1
			FETCH NEXT FROM tblCols_cursor INTO @ColName
			CONTINUE;
		END

		if @COUNTER < (@ColCount -1)
		begin
		 set @allCols = @allCols + UPPER(@ColName) +  ', ' + CHAR(10)
		end
		else
		begin
		 set @allCols = @allCols + UPPER(@ColName) +  ' ' + CHAR(10)
		end

		FETCH NEXT FROM tblCols_cursor INTO @ColName
		SET @COUNTER = @COUNTER + 1
	END

	CLOSE tblCols_cursor
	DEALLOCATE tblCols_cursor

	DECLARE @InsCols VARCHAR(5000)= CHAR(10) +'INSERT INTO  '+trim(@factReportTable)+' (
		' + @factReportId + CHAR(10) + ', ReportCode' + CHAR(10) +  ',  ReportLevel' + CHAR(10) + ', ReportYear ,' + CHAR(10) + 
		 @allCols + CHAR(10) + ')' + CHAR(10) + CHAR(10)

	DECLARE @selCols VARCHAR(5000) = 'SELECT ' + @factReportId + ', ' + '''' + @reportCode + ''' as ReportCode'
		+ ', ' + '''' + @reportLevel +  ''' as ReportLevel' + ', ' 
		+ '''' + @reportYear +  ''' as ReportYear' + ', 
		' + @allCols + '
         FROM @reportData WHERE STUDENTCOUNT = 0 
		' + CHAR(10) + CHAR(10)

	--PRINT '@InsCols : ' + @InsCols
	--PRINT '@selCols : ' + @selCols
	--PRINT '@allCols : ' + @allCols

	set @sql = @sql + @InsCols
	set @sql = @sql + @selCols
	*/
	-------------------------------------------------

	IF @runAsTest = 1
	BEGIN

		DECLARE @printString NVARCHAR(MAX);
		SET @printString = @sql;
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
				set @CurrentEnd = 4000
				set @offset = 1
			END   

			PRINT SUBSTRING(@printString, 1, @CurrentEnd) 
			set @printString = SUBSTRING(@printString, @CurrentEnd+@offset, LEN(@printString))   
		END

	END
	ELSE 
	BEGIN 

		DECLARE @ParmDefinition as nvarchar(max)
		SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @tableTypeAbbrv as varchar(50), @isOnlineReport bit';  
		EXECUTE sp_executesql @sql, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @tableTypeAbbrv = @tableTypeAbbrv, @isOnlineReport=@isOnlineReport;

	END

	SET NOCOUNT OFF;
END