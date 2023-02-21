CREATE PROCEDURE [RDS].[Get_ReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@includeZeroCounts as bit,
	@includeFriendlyCaptions as bit,
	@obscureMissingCategoryCounts as bit,
	@isOnlineReport as bit=0

AS
BEGIN
	SET NOCOUNT ON;
-- Determine Fact/Report Tables
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)
	declare @factReportDtoId as varchar(50)
	declare @factTypeCode as varchar(50)
	declare @year as int

	select @factTypeCode = rds.Get_FactTypeByReport(@reportCode)

	select @year = SchoolYear from rds.DimSchoolYears where SchoolYear = @reportYear

	-- Determine Fact/Report Tables
	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName, 
	@factReportDtoId = ft.FactReportDtoIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode




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
			StateCode,
			StateName,			
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
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
	where r.ReportCode = @reportCode
	and cs.SubmissionYear = @reportYear
	and o.LevelCode = @reportLevel
	and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)


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
	if @reportCode in ('c175','c178','c179') and @reportLevel <> 'sea' and @year <= 2018 and LEN(ISNULL(@categorySetCode,'')) < 1
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
				where r.ReportCode = @reportCode
				and o.LevelCode = @reportLevel
				and cs.SubmissionYear = @reportYear
				and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
			'
		end

	
	set @sql = @sql + '
		declare @reportData as table (
			[' + @factReportDtoId + '] [int] identity NOT NULL,
			[StateANSICode] [nvarchar](100) NOT NULL,
			[StateAbbreviationCode] [nvarchar](100) NOT NULL,
			[StateAbbreviationDescription] [nvarchar](500) NOT NULL,
			
			[OrganizationNcesId] [nvarchar](100) NULL,
			[OrganizationStateId] [nvarchar](100) NULL,
			[OrganizationName] [nvarchar](1000) NULL,
			[ParentOrganizationStateId] [nvarchar](100) NULL,

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
					[StudentRate] [decimal](18,2) NOT NULL
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
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			TableTypeAbbrv,
			TotalIndicator,
		'

	-- @sqlSelectBeginning
	set @sqlSelectBeginning = '
		select	DISTINCT		
			f.StateANSICode,
			f.StateCode,
			f.StateName,			
			f.OrganizationNcesId,
			f.OrganizationStateId,
			f.OrganizationName,
			f.ParentOrganizationStateId,
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

	set @sql = @sql + @sqlReportFieldsDefinition + @sqlInsertDefinition + @sqlIncludedFieldList

	if(@factReportTable = 'ReportEDFactsK12StaffCounts')
		begin
			set @sql = @sql + 'StaffCount,'
		end
	else if(@factReportTable = 'ReportEDFactsK12StudentCounts')
		begin
			set @sql = @sql + 'StudentRate, '
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
		set @sql = @sql + 'ISNULL(f.StudentRate,0.0) as StudentRate,'
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
					DECLARE categoryset_cursor CURSOR FOR 
					select cs.CategorySetCode, tt.TableTypeAbbrv,
						CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
							ELSE 'N'
						END as TotalIndicator from app.CategorySets cs
					inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
					inner join app.OrganizationLevels levels on cs.OrganizationLevelId = levels.OrganizationLevelId
					left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
					where r.ReportCode = @reportCode and levels.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear
					order by cs.CategorySetSequence

					OPEN categoryset_cursor
					FETCH NEXT FROM categoryset_cursor INTO @catSetCode, @tableTypeAbbrvs, @totalIndicators

					WHILE @@FETCH_STATUS = 0
						BEGIN
							set @sqlCategoryFieldDefs = ''
							DECLARE category_cursor CURSOR FOR 
							select upper(d.DimensionFieldName) as ReportField 
							from app.CategorySets cs
							inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
							inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
							inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
							inner join app.Categories c on csc.CategoryId = c.CategoryId
							inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
							inner join app.Dimensions d on cd.DimensionId = d.DimensionId
							inner join App.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
							left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
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
							
							[OrganizationNcesId] [nvarchar](100) NULL,
							[OrganizationStateId] [nvarchar](100) NULL,
							[OrganizationName] [nvarchar](1000) NULL,
							[ParentOrganizationStateId] [nvarchar](100) NULL,

							[CategorySetCode] [nvarchar](40) NOT NULL,
							[TableTypeAbbrv] [nvarchar](100) NOT NULL,
							[TotalIndicator] [nvarchar](5) NOT NULL,
							AssessmentSubject nvarchar(50) NULL,
							AssessmentCount int' 
							+ @sqlCategoryFieldDefs + 
							' )
							truncate table #performanceData_' + @catSetCode + '
						' 
				
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
						FETCH NEXT FROM categoryset_cursor INTO @catSetCode, @tableTypeAbbrvs, @totalIndicators
						END
						
					CLOSE categoryset_cursor
					DEALLOCATE categoryset_cursor
				end
			set @sql = @sql + '			
				drop table #CAT_PerformanceLevel
			'
		end			-- END @isPerformanceSql = 1

	if @reportLevel <> 'sea' AND @reportCode in ('c002','c089')
	begin
		if @categorySetCode = 'TOT'
		begin
			set @includeZeroCounts = 1
		end
	end

	if @reportLevel = 'sea' AND @reportCode in ('c005','c006','c007','c088','c143','c144')
	begin
		set @includeZeroCounts = 1
	end

	-- Zero Counts
	if @includeZeroCounts = 1
		begin		
			if(LEN(ISNULL(@categorySetCode,'')) < 1)
				begin
					DECLARE categoryset_cursor CURSOR FOR 
					select cs.CategorySetCode, tt.TableTypeAbbrv,
					CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
						 ELSE 'N'
					END as TotalIndicator from app.CategorySets cs
					inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
					inner join app.OrganizationLevels levels on cs.OrganizationLevelId =levels.OrganizationLevelId
					left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
					where r.ReportCode = @reportCode and levels.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear
					order by cs.CategorySetSequence

					OPEN categoryset_cursor
					FETCH NEXT FROM categoryset_cursor INTO @catSetCode,@tableTypeAbbrvs, @totalIndicators

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

						SELECT @zeroCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @catSetCode, 'zero',@includeOrganizationSQL, 1,@tableTypeAbbrvs, @totalIndicators, @factTypeCode)
				
						IF(@zeroCountSql IS NOT NULL)
							begin
								set @sql = @sql + '
									' + @zeroCountSql
							end
							FETCH NEXT FROM categoryset_cursor INTO @catSetCode,@tableTypeAbbrvs, @totalIndicators
						END
					CLOSE categoryset_cursor
					DEALLOCATE categoryset_cursor

					if @reportCode in ('c032')
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

					if @reportCode = 'c052'
					BEGIN
						-- Exclude the Category Set A and SubTotals for the LEA or Schools if there are no students
						set @sql = @sql + 'delete a from @reportData a
							inner join 
							(select OrganizationStateId, CategorySetCode, sum(StudentCount) as totalStudentCount from @reportData group by OrganizationStateId, CategorySetCode having sum(StudentCount) < 1 and CategorySetCode <> ''TOT''	) b
							on a.CategorySetCode = b.CategorySetCode and a.OrganizationStateId = b.OrganizationStateId'

						set @sql = @sql + ' delete a from @reportData a 
							inner join 
							(select OrganizationStateId, GRADELEVEL, CategorySetCode, sum(StudentCount) as totalStudentCount from @reportData group by OrganizationStateId, GRADELEVEL, CategorySetCode having sum(StudentCount) < 1 and 
							CategorySetCode in (''CSA'', ''ST1'', ''ST2'' )) b
							on a.CategorySetCode = b.CategorySetCode and a.OrganizationStateId = b.OrganizationStateId  and a.GRADELEVEL = b.GRADELEVEL
						'
					END
				end
			else
				begin
					set @includeOrganizationSQL = 1
					SELECT @zeroCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero',@includeOrganizationSQL, 0,@tableTypeAbbrvs, @totalIndicators, @factTypeCode)

					IF(@zeroCountSql IS NOT NULL)
						begin
							set @sql = @sql + '
								' + @zeroCountSql
						end
				end
		end		-- END @includeZeroCounts = 1

	--print '@reportCode='+@reportCode
	--print '@zeroCountSql='+@zeroCountSql

	if(LEN(ISNULL(@categorySetCode,'')) < 1) AND @reportLevel <> 'sea' AND @reportCode in ('c002','c089')
		begin
			set @includeOrganizationSQL = 1
			SELECT @zeroCountSql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, 'TOT', 'zero',@includeOrganizationSQL, 1,@tableTypeAbbrvs, @totalIndicators, @factTypeCode)

			IF(@zeroCountSql IS NOT NULL)
				begin
					set @sql = @sql + '
						' + @zeroCountSql
				end
		end

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

	set @sql = @sql + '
		select ' + @factReportDtoId + ',
		StateANSICode,
		StateAbbreviationCode,
		StateAbbreviationDescription,		
		OrganizationNcesId,
		OrganizationStateId,
		OrganizationName,
		ParentOrganizationStateId,
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
		set @sql = @sql + ', StudentRate'
	end
	
	set @sql = @sql + '
		from @reportData 
	'

	set @sql = @sql + '
		IF OBJECT_ID(''#CAT_Organizations'') IS NOT NULL
			DROP TABLE #CAT_Organizations
	'

	DECLARE @printString NVARCHAR(MAX);
	set @printString = @sql;
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

	declare @ParmDefinition as nvarchar(max)
	SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @isOnlineReport bit';  
	EXECUTE sp_executesql @sql, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @isOnlineReport=@isOnlineReport;

	SET NOCOUNT OFF;
END