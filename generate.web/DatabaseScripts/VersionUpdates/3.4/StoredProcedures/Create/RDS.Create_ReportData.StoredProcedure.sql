CREATE PROCEDURE [RDS].[Create_ReportData]
	@reportCode as varchar(50),
	@dimFactTypeCode as varchar(50),
	@runAsTest as bit
AS
BEGIN

	SET NOCOUNT ON;
	
	begin try

		-- Get GenerateReportTypeCode

		declare @generateReportTypeCode as varchar(50)
		select @generateReportTypeCode = t.ReportTypeCode
		from app.GenerateReports r
		inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
		where r.ReportCode = @reportCode

		-- Get DataMigrationId and DimFactTypeId

		declare @dataMigrationTypeId as int, @dimFactTypeId as int

		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @dimFactTypeCode
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'

		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @dimFactTypeCode
	
		-- Get Fact/Report Tables/Fields

		declare @factTable as varchar(50)
		declare @factField as varchar(50)
		declare @factReportTable as varchar(50)

		select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
		from app.FactTables ft 
		inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
		where r.ReportCode = @reportCode


		-- Loop through all submission years
		---------------------------------------------

		declare @submissionYears as table(
			SubmissionYear varchar(50)
		)

		if @runAsTest = 1
		begin

			insert into @submissionYears
			(
				SubmissionYear
			)
			select distinct cs.SubmissionYear 
			from app.CategorySets cs 
			inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
			inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
			Where ReportCode = @reportCode

		end
		else
		begin

			if(@reportCode = 'yeartoyearprogress')
			begin

				insert into @submissionYears
				(
					SubmissionYear
				)
				select distinct cs.SubmissionYear 
				from app.CategorySets cs 
				inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
				inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
				Where ReportCode = @reportCode

			end
			else
			begin

				insert into @submissionYears
				(
					SubmissionYear
				)
				select distinct cs.SubmissionYear 
				from app.CategorySets cs 
				inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
				inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
				Where ReportCode = @reportCode and r.isLocked=1
			end

		end

		declare @reportYear as varchar(50)
	
		DECLARE submissionYear_cursor CURSOR FOR 
		SELECT SubmissionYear
		FROM @submissionYears ORDER BY SubmissionYear

		OPEN submissionYear_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- Get DimDateId

			declare @dimDateId as int
			select @dimDateId = DimDateId from rds.DimDates where SubmissionYear = @reportYear

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

			-- Get Categories available to this report

			declare @CategoriesAvailable as table (
				CategoryCode nvarchar(100), 
				ReportField nvarchar(100),
				DataPopulationDimensionField nvarchar(100),
				EdFactsDimensionField nvarchar(100),
				DimensionTable nvarchar(100),
				IsOrganizationLevelSpecific bit,
				IsCalculated bit
			)

			delete from @CategoriesAvailable

			insert into @CategoriesAvailable 
			(CategoryCode, ReportField, DataPopulationDimensionField, EdFactsDimensionField, DimensionTable, IsOrganizationLevelSpecific, IsCalculated) 
			select c.CategoryCode, 
			upper(d.DimensionFieldName) as ReportField, 
			d.DimensionFieldName + 'Code' as DataPopulationDimensionField,
			d.DimensionFieldName + 'EdFactsCode' as EdFactsDimensionField,
			dt.DimensionTableName,
			d.IsOrganizationLevelSpecific,
			d.IsCalculated
			from App.Categories c
			inner join App.Category_Dimensions cd on cd.CategoryId = c.CategoryId
			inner join App.Dimensions d on cd.DimensionId = d.DimensionId
			inner join App.DimensionTables dt on dt.DimensionTableId = d.DimensionTableId
			inner join App.FactTable_DimensionTables fd on d.DimensionTableId = fd.DimensionTableId
			inner join App.FactTables ft on fd.FactTableId = ft.FactTableId
			where ft.FactTableName = @factTable


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
				else
				begin
					print 'declare @dimDateId as int'
					print 'declare @dimFactTypeId as int'
					print 'set @dimDateId = ' + convert(varchar(20), @dimDateId)
					print 'set @dimFactTypeId = ' + convert(varchar(20), @dimFactTypeId)
					print ''
				end

				-- Only process if Categories set data hasn't already been generated

				DECLARE @sqlAlreadyRun nvarchar(500)
				DECLARE @sqlAlreadyRunParm nvarchar(500)
				DECLARE @reportCount int
				DECLARE @tableTypeAbbrvs as varchar(50)
				DECLARE @totalIndicators as varchar(1)

				set @tableTypeAbbrvs=@tableTypeAbbrv
				set @totalIndicators=@totalIndicator
				

					-- Dynamic sql variables
					declare @sql as nvarchar(max)
					set @sql = ''

					select @sql = [RDS].[Get_CountSQL] (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'actual', 1, 0, @tableTypeAbbrvs, @totalIndicators, @dimFactTypeCode)
		
				
					if @runAsTest = 1
					begin
						-- Print @sql
						------------------------
				
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
									SET @CurrentEnd = 4000
									set @offset = 1
							END   
							PRINT SUBSTRING(@printString, 1, @CurrentEnd) 
							set @printString = SUBSTRING(@printString, @CurrentEnd+@offset, LEN(@printString))   
						END
					end
					else
					begin
					
						-- Execute @sql
						------------------------------
						declare @ParmDefinition as nvarchar(max)
						SET @ParmDefinition = N'@dimFactTypeId int, @dimDateId int, @reportLevel varchar(50)';  
						EXECUTE sp_executesql @sql, @ParmDefinition, @dimFactTypeId = @dimFactTypeId, @dimDateId = @dimDateId, @reportLevel = @reportLevel;
					end



				FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode, @categorySetCategoryList, @categorySetReportFieldList, @tableTypeAbbrv, @totalIndicator
			END

			CLOSE categoryset_cursor
			DEALLOCATE categoryset_cursor


			FETCH NEXT FROM submissionYear_cursor INTO @reportYear
		END

		CLOSE submissionYear_cursor
		DEALLOCATE submissionYear_cursor

		IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1)
		begin
			 update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1
		end


	end try

	begin catch

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	end catch

	SET NOCOUNT OFF;

END