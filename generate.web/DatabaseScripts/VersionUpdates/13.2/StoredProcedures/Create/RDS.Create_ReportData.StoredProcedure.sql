CREATE PROCEDURE [RDS].[Create_ReportData]
	@reportCode as varchar(50),
	@dimFactTypeCode as varchar(50),
	@runAsTest as bit
AS
begin

	set NOCOUNT ON;
	
	begin try

		-- Get GenerateReportTypeCode
		declare @generateReportTypeCode as varchar(50)
		select @generateReportTypeCode = t.ReportTypeCode
		from app.GenerateReports r
			inner join app.GenerateReportTypes t 
				on r.GenerateReportTypeId = t.GenerateReportTypeId
		where r.ReportCode = @reportCode

		-- Get DataMigrationId and DimFactTypeId
		declare @dataMigrationTypeId as int, @dimFactTypeId as int

		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @dimFactTypeCode
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

		-- Get Fact/Report Tables/Fields
		declare @factTable as varchar(50)
		declare @factField as varchar(50)
		declare @factReportTable as varchar(50)
		declare @includeZeroCounts as bit = 0

		select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
		from app.FactTables ft 
			inner join app.GenerateReports r 
				on ft.FactTableId = r.FactTableId
		where r.ReportCode = @reportCode

		-- Loop through all submission years
		---------------------------------------------
		declare @submissionYears as table(
			SubmissionYear varchar(50)
		)

		if @runAsTest = 1
		begin

			insert into @submissionYears (
				SubmissionYear
			)
			select distinct cs.SubmissionYear 
			from app.CategorySets cs 
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join rds.DimSchoolYears d 
				on d.SchoolYear = cs.SubmissionYear
			inner join rds.DimSchoolYearDataMigrationTypes dd 
				on dd.DimSchoolYearId = d.DimSchoolYearId 
				and dd.IsSelected=1 
				and dd.DataMigrationTypeId = @dataMigrationTypeId
			where ReportCode = @reportCode

		end
		else
		begin

			if(@reportCode = 'yeartoyearprogress')
			begin

				insert into @submissionYears (
					SubmissionYear
				)
				select distinct cs.SubmissionYear 
				from app.CategorySets cs 
					inner join app.GenerateReports r 
						on cs.GenerateReportId = r.GenerateReportId
					inner join rds.DimSchoolYears d 
						on d.SchoolYear = cs.SubmissionYear
				Where ReportCode = @reportCode

			end
			else
			begin

				insert into @submissionYears (
					SubmissionYear
				)
				select distinct cs.SubmissionYear 
				from app.CategorySets cs 
					inner join app.GenerateReports r	
						on cs.GenerateReportId = r.GenerateReportId
					inner join rds.DimSchoolYears d 
						on d.SchoolYear = cs.SubmissionYear
					inner join rds.DimSchoolYearDataMigrationTypes dd 
						on dd.DimSchoolYearId = d.DimSchoolYearId 
						and dd.IsSelected = 1 
						and dd.DataMigrationTypeId = @dataMigrationTypeId
				where ReportCode = @reportCode 
				and r.isLocked=1
			end

		end

		declare @reportYear as varchar(50)
	
		declare submissionYear_cursor cursor for
		select SubmissionYear
		from @submissionYears order by SubmissionYear

		open submissionYear_cursor
		fetch next from submissionYear_cursor into @reportYear

		while @@FETCH_STATUS = 0
		begin

			-- Get DimSchoolYearId
			declare @dimSchoolYearId as int
			select @dimSchoolYearId = DimSchoolYearId from rds.DimSchoolYears where SchoolYear = @reportYear

			-- Get Category Sets for this Submission Year
			declare @categorySets as table (
				CategorySetId int,
				ReportLevel varchar(5),
				CategorySetCode varchar(50),
				Categories varchar(2000),
				ReportFields varchar(2000),
				TableTypeAbbrv varchar(50),
				TotalIndicator varchar(5)
			)
			delete from @categorySets
		
			insert @categorySets (	
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
				CASE WHEN charindex('total', cs.CategorySetName) > 0 Then 'Y'
					 ELSE 'N'
				end as TotalIndicator
			from app.CategorySets cs 
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

			declare categoryset_cursor CURSOR FOR 
			select CategorySetId, ReportLevel, CategorySetCode, Categories, ReportFields, TableTypeAbbrv, TotalIndicator
			FROM @categorySets

			open categoryset_cursor
			fetch next from categoryset_cursor into @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator

			while @@FETCH_STATUS = 0
			begin

				set @categorySetCntr = @categorySetCntr + 1
				set @includeZeroCounts = 0
				
				if @reportLevel <> 'SEA' and @reportCode in ('002', '089') and @categorySetCode = 'TOT' set @includeZeroCounts = 1

				if @reportLevel = 'SEA' 
				begin
					set @includeZeroCounts = 1
				end

				if @reportCode in ('052','032','040','033')
				begin
					set @includeZeroCounts = 1
				end

				if @reportCode in ('045','218','219','220','221','222','224','225','226')
				begin
					set @includeZeroCounts = 0
				end
				
				-- Log status
				print ''
				print '----------------------------------'
				print '-- ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode + ' - ' + @categorySetCategoryList
				print '----------------------------------'
				set @reportDescription = @reportCode + '-' + @reportYear + '-' + @categorySetCode + ' - ' + @categorySetCategoryList

				if @runAsTest = 0
				begin
					insert into app.DataMigrationHistories
					(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)
				end
				else
				begin
					print 'declare @dimSchoolYearId as int'
					print 'declare @dimFactTypeId as int'
					print 'set @dimSchoolYearId = ' + convert(varchar(20), @dimSchoolYearId)
					print 'set @dimFactTypeId = ' + convert(varchar(20), @dimFactTypeId)
					print ''
				end

				-- Only process if Categories set data hasn't already been generated

				declare @sqlAlreadyRun nvarchar(500)
				declare @sqlAlreadyRunParm nvarchar(500)
				declare @reportCount int
				declare @tableTypeAbbrvs as varchar(50)
				declare @totalIndicators as varchar(1)

				set @tableTypeAbbrvs = @tableTypeAbbrv
				set @totalIndicators = @totalIndicator

				-- Dynamic sql variables
				declare @sql as nvarchar(max)
				set @sql = ''

				select @sql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'actual', 1, 0, @tableTypeAbbrvs, @totalIndicators, @dimFactTypeCode)

				--PRINT '' 
				--PRINT '@reportCode : '+@reportCode
				--PRINT '@reportLevel : '+@reportLevel
				--PRINT '@reportYear : '+@reportYear
				--PRINT '@categorySetCode : '+@categorySetCode
				--PRINT '@tableTypeAbbrvs : '+@tableTypeAbbrvs
				--PRINT '@totalIndicators : '+@totalIndicators
				--PRINT '@dimFactTypeCode : '+@dimFactTypeCode
				--PRINT ''
					
				if @runAsTest = 1
				begin
					-- Print @sql
					------------------------
					declare @printString nvarchar(MAX);
					set @printString = @sql;
					declare @CurrentEnd bigint; /* track the length of the next substring */
					declare @offset tinyint; /*tracks the amount of offset needed */
					set @printString = replace(  replace(@printString, char(13) + char(10), char(10))   , char(13), char(10))

					while len(@printString) > 1
					begin
						if charindex(char(10), @printString) between 1 AND 4000
						begin
								set @CurrentEnd =  charindex(char(10), @printString) -1
								set @offset = 2
						end
						ELSE
						begin
								set @CurrentEnd = 4000
								set @offset = 1
						end   
						PRINT SUBSTRING(@printString, 1, @CurrentEnd) 
						set @printString = SUBSTRING(@printString, @CurrentEnd + @offset, len(@printString))   
					end

					if @includeZeroCounts = 1
					begin

						declare @countToZeroCountPrint nvarchar(max)

						set @countToZeroCountPrint = char(13) + char(10)
						set @countToZeroCountPrint += '-------------------------------------------------------------------------------------------------'
						set @countToZeroCountPrint += char(13) + char(10)
						set @countToZeroCountPrint += '-- This is the beginning of the ZeroCounts logic that inserts these rows into the Report Table --'
						set @countToZeroCountPrint += char(13) + char(10)
						set @countToZeroCountPrint += '-------------------------------------------------------------------------------------------------'

						PRINT @countToZeroCountPrint

						exec [RDS].[Create_ReportData_ZeroCounts] 	@reportCode, @reportLevel ,	@reportYear ,	@categorySetCode , @tableTypeAbbrvs, 1,0,1,0,1

						set @countToZeroCountPrint = char(13) + char(10)
						set @countToZeroCountPrint += '------------------------------------------------------------------------------------------------'
						set @countToZeroCountPrint += char(13) + char(10)
						set @countToZeroCountPrint += '-- End of ZeroCounts logic --'
						set @countToZeroCountPrint += char(13) + char(10)
						set @countToZeroCountPrint += '------------------------------------------------------------------------------------------------'

						PRINT @countToZeroCountPrint
					end

				end
				else
				begin
					
					-- Execute @sql
					------------------------------
					declare @ParmDefinition as nvarchar(max)
					set @ParmDefinition = N'@dimFactTypeId int, @dimSchoolYearId int, @reportLevel varchar(50)';  
					execute sp_executesql @sql, @ParmDefinition, @dimFactTypeId = @dimFactTypeId, @dimSchoolYearId = @dimSchoolYearId, @reportLevel = @reportLevel;

					if @includeZeroCounts = 1
					begin
						exec [RDS].[Create_ReportData_ZeroCounts] 	@reportCode, @reportLevel ,	@reportYear ,	@categorySetCode , @tableTypeAbbrvs, 1,0,1,0,0
					end

				end

				fetch next from categoryset_cursor into @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator
			end

			close categoryset_cursor
			deallocate categoryset_cursor

			fetch next from submissionYear_cursor into @reportYear
		end

		close submissionYear_cursor
		deallocate submissionYear_cursor

		if exists(select 1 from app.GenerateReports where ReportCode = @reportCode and IsLocked = 1 and UseLegacyReportMigration = 1)
		begin
			 if(@reportCode not in('studentfederalprogramsparticipation','studentmultifedprogsparticipation'))
			 begin
				update app.GenerateReports set IsLocked = 0 where ReportCode = @reportCode and IsLocked = 1 and UseLegacyReportMigration = 1
			 end
		end

	end try
	begin catch

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		raiserror(@msg, @sev, 1)

	end catch

	set NOCOUNT OFF;

end