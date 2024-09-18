CREATE PROCEDURE [RDS].[Create_StudentFederalProgramsReportData]
	@reportCode as varchar(50),
	@runAsTest as bit
AS
BEGIN


	SET NOCOUNT ON;


	-- Determine Fact/Report Tables

	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @factReportId as varchar(50)
	DECLARE @SQL nvarchar(MAX), @tableSql nvarchar(max)
	

	declare @reportField as nvarchar(100)
	DECLARE @rowField as nvarchar(100), @columnField as nvarchar(100)

	-- Get GenerateReportTypeCode

	declare @generateReportTypeCode as varchar(50)
	select @generateReportTypeCode = t.ReportTypeCode
	from app.GenerateReports r
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where r.ReportCode = @reportCode

	-- Get DataMigrationId and DimFactTypeId

	declare @dataMigrationTypeId as int
	declare @dimFactTypeId as int, @dimFactTypeCode as varchar(100)
	if @generateReportTypeCode = 'datapopulation'
	begin
		set @dimFactTypeCode = 'datapopulation'
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'
	end
	else 
	begin
		if(@reportCode in ('c002','c089'))
		begin
			set @dimFactTypeCode = 'childcount'
		end
		else if(@reportCode in ('c009'))
		begin
			set @dimFactTypeCode = 'specedexit'
		end
		else
		begin
			set @dimFactTypeCode = 'submission'
		end
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
	end

	select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @dimFactTypeCode

	-- Determine Fact/Report Tables

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, 
	@factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	-- Get Report Filters
	declare @reportFilter as varchar(50)
	declare @FiltersinReport Table(
					Filter varchar(100)
				)

	insert into @FiltersinReport(Filter)
	select distinct FilterCode
	from app.GenerateReportFilterOptions op
	inner join app.GenerateReports r on op.GenerateReportId = r.GenerateReportId
	Where ReportCode = @reportCode

	-- Loop through all submission years
	---------------------------------------------

	declare @submissionYears as table(
		SubmissionYear varchar(50)
	)

	insert into @submissionYears
	(
		SubmissionYear
	)
	select distinct SubmissionYear 
	from app.CategorySets cs 
	inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
	Where ReportCode = @reportCode

	declare @reportYear as varchar(50)
	
	DECLARE submissionYear_cursor CURSOR FOR 
	SELECT SubmissionYear
	FROM @submissionYears ORDER BY SubmissionYear

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear

	WHILE @@FETCH_STATUS = 0
	BEGIN

			---- Get DimDateId

			--declare @dimDateId as int
			--select @dimDateId = DimDateId from rds.DimDates where SubmissionYear = @reportYear

			-- Get Category Sets for this Submission Year

			declare @categorySets as table(
				CategorySetId int,
				ReportLevel varchar(5),
				CategorySetCode varchar(50),
				Categories varchar(2000),
				ReportFields varchar(2000),
				TableTypeAbbrv varchar(50),
				TotalIndicator varchar(5)
			)
			delete from @categorySets
		
			insert @categorySets
			(	
				CategorySetId,
				ReportLevel,
				CategorySetCode,
				Categories,
				ReportFields,
				TableTypeAbbrv,
				TotalIndicator
			)
			select	
				cs.CategorySetId,
				o.LevelCode,
				cs.CategorySetCode,
				isnull(app.Get_CategoriesByCategorySet(cs.CategorySetId, 1, 0), '') as Categories,
				isnull(app.Get_CategoriesByCategorySet(cs.CategorySetId, 1, 1), '') as ReportFields,
				isnull(tt.TableTypeAbbrv, '') as TableTypeAbbrv,
				CASE WHEN CHARINDEX('total', cs.CategorySetName) > 0 Then 'Y'
					 ELSE 'N'
				END as TotalIndicator
			from app.CategorySets cs 
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
			inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
			left outer join app.TableTypes tt on cs.TableTypeId = tt.TableTypeId
			where r.ReportCode = @reportCode
			and cs.SubmissionYear = @reportYear
			order by o.OrganizationLevelId, cs.CategorySetCode

			-- Loop through Category Sets for this Submission Year
		---------------------------------------------
			declare @categorySetId as int
			declare @reportLevel as varchar(5)
			declare @categorySetCode as varchar(50)
			declare @categorySetCategoryList as varchar(2000)
			declare @categorySetReportFieldList as varchar(2000)
			declare @tableTypeAbbrv as varchar(50)
			declare @totalIndicator as varchar(5)

			declare @categorySetCnt as int
			select @categorySetCnt = count(*) from @categorySets
			declare @categorySetCntr as int
			set @categorySetCntr = 0
			declare @reportDescription as varchar(2000)

			DECLARE categoryset_cursor CURSOR FOR 
			SELECT CategorySetId, ReportLevel, CategorySetCode, Categories, ReportFields, TableTypeAbbrv, TotalIndicator
			FROM @categorySets

			OPEN categoryset_cursor
			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator

			WHILE @@FETCH_STATUS = 0
			BEGIN

				set @categorySetCntr = @categorySetCntr + 1

				-- Log status

				print ''
				print '----------------------------------'
				print '-- ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode + ' - ' + @categorySetCategoryList
				print '----------------------------------'
				SET @reportDescription = @reportCode + '-' + @reportYear + '-' + @categorySetCode + ' - ' + @categorySetCategoryList

				if @runAsTest = 0
				begin
					insert into app.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)
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
				and upper(d.DimensionFieldName) <> 'DISABILITY'

					--				-- Zero Counts

					--declare @zeroCountSQL as nvarchar(max)
					--set @zeroCountSQL = ''
	
					--SELECT @zeroCountSQL = [RDS].Get_CountSQL (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero-programs', 1, 0,'','')

					--set @SQL = @SQL + @zeroCountSQL



				DECLARE filter_cursor CURSOR FOR 
				SELECT Filter
				FROM @FiltersinReport

				OPEN filter_cursor
				FETCH NEXT FROM filter_cursor INTO @reportFilter

				SET @SQL = '
		
						declare @reportCounts as table
						(
						[OrganizationId] [int] NOT NULL,
						[OrganizationName] [nvarchar](1000) NOT NULL,
						[OrganizationNcesId] [nvarchar](100) NOT NULL,
						[OrganizationStateId] [nvarchar](100) NOT NULL,
						[ParentOrganizationStateId] [nvarchar](100) NULL,
						[StateANSICode] [nvarchar](100) NOT NULL,
						[StateCode] [nvarchar](100) NOT NULL,
						[StateName] [nvarchar](500) NOT NULL,
						HOMELESSSTATUS [nvarchar](100) NULL,
						LEPSTATUS [nvarchar](100) NULL,
						MIGRANTSTATUS [nvarchar](100) NULL,
						CTEPROGRAM [nvarchar](100) NULL,
						FOODSERVICEELIGIBILITY [nvarchar](100) NULL,
						IMMIGRANTTITLEIIIPROGRAM [nvarchar](100) NULL,
						SECTION504PROGRAM [nvarchar](100) NULL,
						FOSTERCAREPROGRAM [nvarchar](100) NULL,
						TITLE1SCHOOLSTATUS [nvarchar](100) NULL,
						[StudentCount] int NULL
						)

		
					declare @federalProgramCounts as table
					(
					[Col_1] [decimal](18, 2) NULL,
					[OrganizationId] [int] NOT NULL,
					[OrganizationName] [nvarchar](1000) NOT NULL,
					[OrganizationNcesId] [nvarchar](100) NOT NULL,
					[OrganizationStateId] [nvarchar](100) NOT NULL,
					[ParentOrganizationStateId] [nvarchar](100) NULL,
					[StateANSICode] [nvarchar](100) NOT NULL,
					[StateCode] [nvarchar](100) NOT NULL,
					[StateName] [nvarchar](500) NOT NULL,
					[Category1] [nvarchar](100) NULL,
					[Category2] [nvarchar](100) NULL
					)
			
					'

				WHILE @@FETCH_STATUS = 0
				BEGIN

					IF(@reportCode = 'studentfederalprogramsparticipation')
					BEGIN

		
					SET @SQL = @SQL + '
											INSERT INTO @reportCounts(StateANSICode,
													StateCode,
													StateName,
													OrganizationId,
													OrganizationNcesId,
													OrganizationStateId,
													OrganizationName,
													ParentOrganizationStateId,
													HOMELESSSTATUS,
													LEPSTATUS,
													MIGRANTSTATUS,
													CTEPROGRAM,
													FOODSERVICEELIGIBILITY,
													IMMIGRANTTITLEIIIPROGRAM,
													SECTION504PROGRAM,
													FOSTERCAREPROGRAM,
													TITLE1SCHOOLSTATUS,
													StudentCount)
												select StateANSICode,
												StateCode,
												StateName,
												OrganizationId,
												OrganizationNcesId,
												OrganizationStateId,
												OrganizationName,
												ParentOrganizationStateId, 
												HOMELESSSTATUS,
												LEPSTATUS,
												MIGRANTSTATUS,
												CTEPROGRAM,
												FOODSERVICEELIGIBILITY,
												IMMIGRANTTITLEIIIPROGRAM,
												SECTION504PROGRAM,
												FOSTERCAREPROGRAM,
												CASE TITLE1SCHOOLSTATUS
													WHEN ''SWELIGNOPROG'' THEN ''TITLE1SCHOOLSTATUS''
													WHEN ''SWELIGSWPROG'' THEN ''TITLE1SCHOOLSTATUS''
													WHEN ''SWELIGTGPROG'' THEN ''TITLE1SCHOOLSTATUS''
													WHEN ''TGELGBNOPROG'' THEN ''TITLE1SCHOOLSTATUS''
													WHEN ''TGELGBTGPROG'' THEN ''TITLE1SCHOOLSTATUS''
													ELSE TITLE1SCHOOLSTATUS
												END as TITLE1SCHOOLSTATUS,
												SUM(StudentCount)
										from rds.FactStudentCountReports 
										Where ReportCode = @reportCode and ReportLevel = @reportLevel
										and ReportYear = @reportYear and CategorySetCode = @categorySetCode'

					IF(@reportFilter = 'SWD')
					BEGIN
						SET @SQL = @SQL + ' and DISABILITY = ''WDIS'' '
					END
					ELSE IF(@reportFilter = 'SWOD')
					BEGIN
						SET @SQL = @SQL + ' and DISABILITY = ''WODIS'' '
					END

					SET @SQL = @SQL + '
									group by StateANSICode,
											StateCode,
											StateName,
											OrganizationId,
											OrganizationNcesId,
											OrganizationStateId,
											OrganizationName,
											ParentOrganizationStateId, 
											HOMELESSSTATUS,
											LEPSTATUS,
											MIGRANTSTATUS,
											CTEPROGRAM,
											FOODSERVICEELIGIBILITY,
											IMMIGRANTTITLEIIIPROGRAM,
											SECTION504PROGRAM,
											FOSTERCAREPROGRAM,
											TITLE1SCHOOLSTATUS

										'

	
						DECLARE reportFieldRow_cursor CURSOR FOR   
						select ReportField FROM @ReportFieldsInCategorySet

						OPEN reportFieldRow_cursor  
  
						FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
						WHILE @@FETCH_STATUS = 0  
						BEGIN  

				
							DECLARE reportFieldCol_cursor CURSOR FOR   
							select ReportField FROM @ReportFieldsInCategorySet

							OPEN reportFieldCol_cursor  
  
							FETCH NEXT FROM reportFieldCol_cursor INTO @columnField
							WHILE @@FETCH_STATUS = 0  
							BEGIN  
						
						
						
									SET @SQL = @SQL + '
									INSERT INTO @federalProgramCounts(
										StateANSICode, StateCode, StateName, OrganizationId, OrganizationNcesId,
										OrganizationStateId, OrganizationName, ParentOrganizationStateId, Category1, Category2, Col_1)
									SELECT 
									f.StateANSICode,
									f.StateCode,
									f.StateName,
									f.OrganizationId,
									f.OrganizationNcesId,
									f.OrganizationStateId,
									f.OrganizationName,
									f.ParentOrganizationStateId,
									'

									SET @SQL =  @SQL + 'f.' + @rowField + ', f.' + @columnField + ','
					

									SET @SQL = @SQL +
									'SUM(StudentCount)
									from @reportCounts f
									GROUP BY StateANSICode, StateCode, StateName, OrganizationId, OrganizationName,
									OrganizationNcesId, OrganizationStateId, ParentOrganizationStateId,
									'

									IF(@rowField <> @columnField)
									BEGIN
										SET @SQL = @SQL + 'f.' + @rowField + ', f.' + @columnField
										SET @SQL = @SQL + '
											having ' + 'f.' + @rowField + ' <> ' + '''MISSING''' + ' AND ' + 'f.' + @columnField + ' <> ' + '''MISSING'''
									END
									ELSE
									BEGIN
										SET @SQL = @SQL + 'f.' + @rowField
										SET @SQL = @SQL + '
											having ' + 'f.' + @rowField + ' <> ' + '''MISSING'''
									END

						

									SET @SQL = @SQL + '
						
									'
				
							FETCH NEXT FROM reportFieldCol_cursor INTO @columnField

				
							END   
							CLOSE reportFieldCol_cursor;  
							DEALLOCATE reportFieldCol_cursor;  
				
				
							FETCH NEXT FROM reportFieldRow_cursor INTO @rowField

				
						END   
						CLOSE reportFieldRow_cursor;  
						DEALLOCATE reportFieldRow_cursor;  

						DECLARE reportField_cursor CURSOR FOR  
						select distinct CASE co.CategoryOptionCode
									WHEN 'SWELIGNOPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'SWELIGSWPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'SWELIGTGPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'TGELGBNOPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'TGELGBTGPROG' THEN 'TITLE1SCHOOLSTATUS'
									ELSE co.CategoryOptionCode
								END as CategoryOptionCode
							from app.GenerateReports r
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.Category_Dimensions cd on cd.CategoryId = c.CategoryId
						inner join app.Dimensions d on cd.DimensionId = d.DimensionId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and cs.CategorySetId = co.CategorySetId
						inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
						where r.ReportCode = @reportCode
						and cs.SubmissionYear = @reportYear
						and o.LevelCode = @reportLevel
						and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
						and co.CategoryOptionCode <> 'MISSING' 
						
						OPEN reportField_cursor  
  
						FETCH NEXT FROM reportField_cursor INTO @rowField
						WHILE @@FETCH_STATUS = 0  
						BEGIN 

								SET @SQL = @SQL + '
								INSERT INTO rds.FactCustomCounts(
									ReportCode,
									ReportYear,
									ReportLevel,
									ReportFilter,
									CategorySetCode,
									StateANSICode,
									StateCode,
									StateName,
									OrganizationId,
									OrganizationNcesId,
									OrganizationStateId,
									OrganizationName,
									ParentOrganizationStateId,
									Category1,
									col_1,
									col_2,
									col_3,
									col_4,
									col_5,
									col_6,
									col_7,
									col_8,
									col_9
								)
								SELECT 
								@reportCode, @reportYear, @reportLevel, @reportFilter, @categorySetCode,
								StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1,
								SUM([TITLE1SCHOOLSTATUS]) as TitleICount,
								SUM([HOMELSENRL]) as HomelessCount,
								SUM([MS]) as MigrantCount,
								SUM([LEP]) as LEPCount,
								SUM([CTE]) as CTECount,
								SUM([SECTION504]) as Section504Count,
								SUM([IMMIGNTTTLIII]) as IMGNTTITLIIICount,
								SUM([FREE]) as FREELUNCHCount,
								SUM([FOSTERCARE]) as FOSTERCARE
								FROM
								(SELECT StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1,
								Category2,
								Col_1
								FROM @federalProgramCounts
								Where Category1 in ('

								SET @SQL = @SQL + '''' + @rowField + ''''  + ')) as SourceTable
								PIVOT
								(	
									SUM(Col_1)
									FOR Category2 IN ([TITLE1SCHOOLSTATUS],[HOMELSENRL],[MS],[LEP],[SECTION504],[CTE],[IMMIGNTTTLIII],[FREE],[FOSTERCARE])
								) AS PivotTable
								group by StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1
								'
						FETCH NEXT FROM reportField_cursor INTO @rowField
			
						END   
						CLOSE reportField_cursor;  
						DEALLOCATE reportField_cursor;
				
				
					END
					ELSE IF(@reportCode = 'studentmultifedprogsparticipation')
					BEGIN

		
						SET @SQL = @SQL + '
												INSERT INTO @reportCounts(StateANSICode,
														StateCode,
														StateName,
														OrganizationId,
														OrganizationNcesId,
														OrganizationStateId,
														OrganizationName,
														ParentOrganizationStateId,
														HOMELESSSTATUS,
														LEPSTATUS,
														MIGRANTSTATUS,
														CTEPROGRAM,
														FOODSERVICEELIGIBILITY,
														IMMIGRANTTITLEIIIPROGRAM,
														SECTION504PROGRAM,
														FOSTERCAREPROGRAM,
														TITLE1SCHOOLSTATUS,
														StudentCount)
													select StateANSICode,
													StateCode,
													StateName,
													OrganizationId,
													OrganizationNcesId,
													OrganizationStateId,
													OrganizationName,
													ParentOrganizationStateId, 
													HOMELESSSTATUS,
													LEPSTATUS,
													MIGRANTSTATUS,
													CTEPROGRAM,
													FOODSERVICEELIGIBILITY,
													IMMIGRANTTITLEIIIPROGRAM,
													SECTION504PROGRAM,
													FOSTERCAREPROGRAM,
													TITLE1SCHOOLSTATUS,
													SUM(StudentCount)
											from rds.FactStudentCountReports 
											Where ReportCode = @reportCode and ReportLevel = @reportLevel
											and ReportYear = @reportYear and CategorySetCode = @categorySetCode'

					IF(@reportFilter = 'SWD')
					BEGIN
						SET @SQL = @SQL + ' and DISABILITY = ''WDIS'' '
					END
					ELSE IF(@reportFilter = 'SWOD')
					BEGIN
						SET @SQL = @SQL + ' and DISABILITY = ''WODIS'' '
					END

					SET @SQL = @SQL + '
									group by StateANSICode,
											StateCode,
											StateName,
											OrganizationId,
											OrganizationNcesId,
											OrganizationStateId,
											OrganizationName,
											ParentOrganizationStateId, 
											HOMELESSSTATUS,
											LEPSTATUS,
											MIGRANTSTATUS,
											CTEPROGRAM,
											FOODSERVICEELIGIBILITY,
											IMMIGRANTTITLEIIIPROGRAM,
											SECTION504PROGRAM,
											FOSTERCAREPROGRAM,
											TITLE1SCHOOLSTATUS

										'

					---- Zero Counts

	
					--set @zeroCountSQL = ''
	
					--SELECT @zeroCountSQL = [RDS].Get_CountSQL (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero-programs', 1, 0,'','')

					--set @SQL = @SQL + @zeroCountSQL



						DECLARE @i as INT, @categorycount as INT
						DECLARE @combination as nvarchar(1000), @federalProgramsSQL as nvarchar(MAX)
		
						DECLARE @combinations as table
						(
							missingSQL [nvarchar](MAX) NOT NULL,
							categorycount int NOT NULL,
							combinedSQL bit NULL
						);

	
						DECLARE reportFieldRow_cursor CURSOR FOR   
						select ReportField FROM @ReportFieldsInCategorySet

						OPEN reportFieldRow_cursor  
  
						FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
						WHILE @@FETCH_STATUS = 0  
						BEGIN  

							delete from @combinations;

							WITH Programs(Program) AS (
							SELECT Program
							FROM (select ReportField from @ReportFieldsInCategorySet) Programs(Program)),
							Recur(Program,Combination) AS (SELECT Program, CAST(Program AS VARCHAR(1000)) 
							FROM Programs
							UNION ALL
							SELECT n.Program,CAST(r.Combination + ',' + CAST(n.Program AS VARCHAR(100)) AS VARCHAR(1000)) 
							FROM Recur r
							INNER JOIN Programs n ON n.Program > r.Program)
			
							INSERT INTO @combinations(categorycount, missingSQL, combinedSQL)
							SELECT (LEN(Combination) - LEN(REPLACE(Combination, ',', ''))) + 1 as CategoryCount,
							CASE WHEN CHARINDEX('CTEPROGRAM',Combination) > 0 THEN ' f.CTEPROGRAM <> ''MISSING'' ' ELSE ' f.CTEPROGRAM = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('LEPSTATUS',Combination) > 0 THEN ' f.LEPSTATUS <> ''MISSING'' ' ELSE ' f.LEPSTATUS = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('FOODSERVICEELIGIBILITY',Combination) > 0 THEN ' f.FOODSERVICEELIGIBILITY <> ''MISSING'' ' ELSE ' f.FOODSERVICEELIGIBILITY = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('FOSTERCAREPROGRAM',Combination) > 0 THEN ' f.FOSTERCAREPROGRAM <> ''MISSING'' ' ELSE ' f.FOSTERCAREPROGRAM = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('HOMELESSSTATUS',Combination) > 0 THEN ' f.HOMELESSSTATUS <> ''MISSING'' ' ELSE ' f.HOMELESSSTATUS = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('IMMIGRANTTITLEIIIPROGRAM',Combination) > 0 THEN ' f.IMMIGRANTTITLEIIIPROGRAM <> ''MISSING'' ' ELSE ' f.IMMIGRANTTITLEIIIPROGRAM = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('MIGRANTSTATUS',Combination) > 0 THEN ' f.MIGRANTSTATUS <> ''MISSING'' ' ELSE ' f.MIGRANTSTATUS = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('SECTION504PROGRAM',Combination) > 0 THEN ' f.SECTION504PROGRAM <> ''MISSING'' ' ELSE ' f.SECTION504PROGRAM = ''MISSING'' '	END + ' AND ' +
							CASE WHEN CHARINDEX('TITLE1SCHOOLSTATUS',Combination) > 0 THEN ' f.TITLE1SCHOOLSTATUS <> ''MISSING'' ' ELSE ' f.TITLE1SCHOOLSTATUS = ''MISSING'' '	END as missingSQL, 0
							FROM Recur
							Where CHARINDEX(@rowField,Combination) > 0

							INSERT INTO @combinations(categorycount, missingSQL, combinedSQL)
							SELECT t.categorycount, REPLACE(REPLACE(STUFF((select '(' + CAST(missingSQL as nvarchar(max)) + ') OR ' FROM @combinations 
										Where CategoryCount = t.CategoryCount 
										FOR XML PATH('')), 1, 2,'('),'&lt;','<'),'&gt;','>'), 1
							FROM
							@combinations t
							Group by t.CategoryCount
							having categorycount <> 9

		
							DECLARE combination_cursor CURSOR FOR   
							select LEFT(missingSQL, LEN(missingSQL) - 2),CategoryCount from @combinations where combinedSQL = 1

							OPEN combination_cursor  
  
							FETCH NEXT FROM combination_cursor INTO @federalProgramsSQL, @categorycount
							WHILE @@FETCH_STATUS = 0  
							BEGIN  

									SET @SQL = @SQL + '
									INSERT INTO @federalProgramCounts(
										StateANSICode, StateCode, StateName, OrganizationId, OrganizationNcesId,
										OrganizationStateId, OrganizationName, ParentOrganizationStateId, Category1, Category2, Col_1)
									SELECT 
									f.StateANSICode,
									f.StateCode,
									f.StateName,
									f.OrganizationId,
									f.OrganizationNcesId,
									f.OrganizationStateId,
									f.OrganizationName,
									f.ParentOrganizationStateId,
									'

									IF(@rowField = 'TITLE1SCHOOLSTATUS')
									BEGIN
										SET @SQL =  @SQL + 'CASE f.' + @rowField + ' '+ 'WHEN ''SWELIGNOPROG'' THEN ''TITLE1SCHOOLSTATUS''
																					WHEN ''SWELIGSWPROG'' THEN ''TITLE1SCHOOLSTATUS''
																					WHEN ''SWELIGTGPROG'' THEN ''TITLE1SCHOOLSTATUS''
																					WHEN ''TGELGBNOPROG'' THEN ''TITLE1SCHOOLSTATUS''
																					WHEN ''TGELGBTGPROG'' THEN ''TITLE1SCHOOLSTATUS''
																					ELSE f.' + @rowField + ' END,' + ''''  + CAST(@categorycount as varchar(10))  + '''' + ','
									END
									ELSE
									BEGIN
										SET @SQL =  @SQL + 'f.' + @rowField + ',' + ''''  + CAST(@categorycount as varchar(10))  + '''' + ','
									END
					
					

									SET @SQL = @SQL +
									'SUM(StudentCount)
									from @reportCounts f
									GROUP BY StateANSICode, StateCode, StateName, OrganizationId, OrganizationName,
									OrganizationNcesId, OrganizationStateId, ParentOrganizationStateId,CTEPROGRAM,LEPSTATUS,
									FOODSERVICEELIGIBILITY,FOSTERCAREPROGRAM,HOMELESSSTATUS,IMMIGRANTTITLEIIIPROGRAM,
									MIGRANTSTATUS,SECTION504PROGRAM,TITLE1SCHOOLSTATUS
									'
											
									SET @SQL = @SQL + '	having ' + @federalProgramsSQL

									SET @SQL = @SQL + '
						
									'

								FETCH NEXT FROM combination_cursor INTO @federalProgramsSQL, @categorycount
			
							END   
							CLOSE combination_cursor;  
							DEALLOCATE combination_cursor;  


						FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
						END   
						CLOSE reportFieldRow_cursor;  
						DEALLOCATE reportFieldRow_cursor;  

						DECLARE reportField_cursor CURSOR FOR  
						select distinct CASE co.CategoryOptionCode
									WHEN 'SWELIGNOPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'SWELIGSWPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'SWELIGTGPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'TGELGBNOPROG' THEN 'TITLE1SCHOOLSTATUS'
									WHEN 'TGELGBTGPROG' THEN 'TITLE1SCHOOLSTATUS'
									ELSE co.CategoryOptionCode
								END as CategoryOptionCode
							from app.GenerateReports r
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.Category_Dimensions cd on cd.CategoryId = c.CategoryId
						inner join app.Dimensions d on cd.DimensionId = d.DimensionId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and cs.CategorySetId = co.CategorySetId
						inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
						where r.ReportCode = @reportCode
						and cs.SubmissionYear = @reportYear
						and o.LevelCode = @reportLevel
						and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode)
						and co.CategoryOptionCode <> 'MISSING' 
						

						OPEN reportField_cursor  
  
						FETCH NEXT FROM reportField_cursor INTO @rowField
						WHILE @@FETCH_STATUS = 0  
						BEGIN 

					

									SET @SQL = @SQL + '
								INSERT INTO rds.FactCustomCounts(
									ReportCode,
									ReportYear,
									ReportLevel,
									ReportFilter,
									CategorySetCode,
									StateANSICode,
									StateCode,
									StateName,
									OrganizationId,
									OrganizationNcesId,
									OrganizationStateId,
									OrganizationName,
									ParentOrganizationStateId,
									Category1,
									col_1,
									col_2,
									col_3,
									col_4,
									col_5,
									col_6,
									col_7,
									col_8
								)
								SELECT 
								@reportCode, @reportYear, @reportLevel, @reportFilter, @categorySetCode,
								StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1,
								SUM([1]),
								SUM([2]),
								SUM([3]),
								SUM([4]),
								SUM([5]),
								SUM([6]),
								SUM([7]),
								SUM([8])
								FROM
								(SELECT StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1,
								Category2,
								Col_1
								FROM @federalProgramCounts
								Where Category1 in ('


								SET @SQL = @SQL + '''' + @rowField + ''''  + ')) as SourceTable
								PIVOT
								(	
									SUM(Col_1)
									FOR Category2 IN ([1],[2],[3],[4],[5],[6],[7],[8])
								) AS PivotTable
								group by StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								Category1
								'		
				
						FETCH NEXT FROM reportField_cursor INTO @rowField
			
						END   
						CLOSE reportField_cursor;  
						DEALLOCATE reportField_cursor;
				
		
					END
	


					if( @runAsTest = 0)
					BEGIN

							declare @ParmDefinition as nvarchar(max)
							SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @reportFilter varchar(100)';  
							EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode,	@reportFilter = @reportFilter;

					END
					ELSE
					BEGIN

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

					END

					

				FETCH NEXT FROM filter_cursor INTO @reportFilter
				END
				
				CLOSE filter_cursor 
				DEALLOCATE filter_cursor 


		FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator
		END

		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor

		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	END

	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor

				

	SET NOCOUNT OFF;


END



