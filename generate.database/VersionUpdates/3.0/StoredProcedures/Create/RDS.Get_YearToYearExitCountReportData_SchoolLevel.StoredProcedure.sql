CREATE PROCEDURE [RDS].[Get_YearToYearExitCountReportData_SchoolLevel]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50)
AS
BEGIN


	SET NOCOUNT ON;
	DECLARE  @factReportTable as varchar(50), @SQL nvarchar(MAX), @sqlTemp nvarchar(MAX), @catSetTemp nvarchar(MAX),@catSetInsert nvarchar(MAX), @tableSql nvarchar(max),@catSetIns nvarchar(MAX)
	DECLARE @DeclareSQL nvarchar(MAX), @InsertSQL nvarchar(MAX), @SelectSQL nvarchar(MAX), @count as int, @categoryColumn nvarchar(max), @remainingCategory nvarchar(max)
	-- Determine Fact/Report Tables

	select @factReportTable = ft.FactReportTableName
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

	select @count=count(*) from @ReportFieldsInCategorySet
	

	set @catSetTemp=''
	SET @categoryColumn=''
	set @catSetInsert=''
	set @sqlTemp=''
	DECLARE @rowField as nvarchar(100)
	DECLARE reportFieldRow_cursor CURSOR FOR   
	select ReportField FROM @ReportFieldsInCategorySet

	OPEN reportFieldRow_cursor  
  
	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	WHILE @@FETCH_STATUS = 0  
	BEGIN  		
		IF(@rowField<>'BASISOFEXIT' and @count>1)
		BEGIN
		SET @categoryColumn=@categoryColumn+@rowField
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](50) NULL' 
			SET @catSetInsert= @catsetInsert+' ,' + @rowField
			SET @catSetIns=@catSetIns+' ,' + @rowField
		END
		else IF(@rowField='BASISOFEXIT' and @count>1)
		BEGIN
			SET @catSetInsert=''
			SET @catSetIns=''
		END
		else
		begin
			SET @catSetIns=', NULL'
			SET @catSetInsert=''
		end
	
	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	END

	CLOSE reportFieldRow_cursor;  
	DEALLOCATE reportFieldRow_cursor;

	
	select top(1) @remainingCategory = d.CategoryCode from app.CategorySets a
		inner join app.GenerateReports b on a.GenerateReportId=b.GenerateReportId
		inner join app.CategorySet_Categories c on a.CategorySetId=c.CategorySetId
		inner join app.Categories d on d.CategoryId=c.CategoryId
		inner join app.GenerateReport_OrganizationLevels e on e.GenerateReportId=b.GenerateReportId
		inner join app.OrganizationLevels f on f.OrganizationLevelId=e.OrganizationLevelId
		where a.CategorySetCode=@categorySetCode and SubmissionYear=@reportYear and f.LevelCode=@reportLevel  and d.CategoryCode  NOT IN ('YEAR' , 'BASISEXIT')
	
	-----
	SET @SelectSQL = 'CREATE TABLE #tempo(CategoryOptionCode NVARCHAR(100));
			INSERT INTO #tempo 
			SELECT distinct e.CategoryOptionCode FROM APP.GenerateReports a 
			inner join app.CategorySets b on b.GenerateReportId=a.GenerateReportId
			inner join app.CategorySet_Categories c on c.CategorySetId=b.CategorySetId 
			inner join app.Categories d on c.CategoryId=d.CategoryId and CategoryCode=''YEAR''
			inner join app.CategoryOptions e on e.CategorySetId=b.CategorySetId and e.CategoryId=d.CategoryId and SubmissionYear=@reportYear
			inner join app.GenerateReport_OrganizationLevels f on f.GenerateReportId=a.GenerateReportId 
			inner join app.OrganizationLevels g on g.OrganizationLevelId=f.OrganizationLevelId and g.LevelCode=@reportLevel'
	-----
	
	SET @SQL = '			
		SELECT schoolInfo.StateANSICode,schoolInfo.StateCode,schoolInfo.StateName, schoolInfo.SchoolOrganizationId,  schoolInfo.SchoolNcesIdentifier, schoolInfo.SchoolStateIdentifier,schoolInfo.SchoolName, schoolInfo.LeaOrganizationId,   
		 schoolInfo.CategoryOptionCode,  ISNULL(sum(studentReports.StudentCount),0), schoolInfo.BASISOFEXIT,  schoolInfo.'+@categoryColumn+'
		FROM (
		SELECT * FROM
		(select StateANSICode,StateCode,StateName,SchoolOrganizationId,SchoolStateIdentifier, SchoolNcesIdentifier,LeaOrganizationId, SchoolName'+@catSetInsert+',  BASISOFEXIT from 
			(select SchoolOrganizationId, 
							SchoolName, 
							StateANSICode,
							StateCode,
							StateName,
							SchoolNcesIdentifier,	
							LeaOrganizationId,
							SchoolStateIdentifier						
							from rds.DimSchools where SchoolName is not null ) school
				cross join (
				select distinct filterType.CategoryOptionName AS '+@categoryColumn+', exitBasis.CategoryOptionCode AS BASISOFEXIT from
						(SELECT co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId=cd.DimensionId
						and cs.CategorySetCode = @categorySetCode and C.CategoryCode =''BASISEXIT'' AND co.CategoryOptionCode <>''Missing'') exitBasis
					CROSS JOIN	(SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId=cd.DimensionId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear
						and cs.CategorySetCode = @categorySetCode and C.CategoryCode ='''+@remainingCategory+''' AND co.CategoryOptionCode <>''Missing'') filterType
				) schoolCategories
				)schoolCategoriesYear
				CROSS JOIN (SELECT * FROM #tempo) comparisonYear
) schoolInfo
LEFT JOIN RDS.'+@factReportTable+' studentReports ON studentReports.OrganizationName=schoolInfo.SchoolName AND studentReports.BASISOFEXIT=schoolInfo.BASISOFEXIT AND studentReports.'+@categoryColumn+'=schoolInfo.'+@categoryColumn+' AND studentReports.OrganizationStateId=schoolInfo.SchoolOrganizationId AND studentReports.OrganizationNcesId=schoolInfo.SchoolNcesIdentifier AND schoolInfo.CategoryOptionCode=studentReports.YEAR
group by schoolInfo.StateCode, schoolInfo.StateANSICode, schoolInfo.StateName, schoolInfo.SchoolName, schoolInfo.'+@categoryColumn+', schoolInfo.BASISOFEXIT, schoolInfo.SchoolStateIdentifier, schoolInfo.SchoolNcesIdentifier, 
	schoolInfo.LeaOrganizationId,schoolInfo.CategoryOptionCode, schoolInfo.SchoolOrganizationId
'


	SET @sqlTemp = '
	CREATE TABLE #reportCounts(
		[OrganizationId] [int] NULL,
		[OrganizationName] [nvarchar](1000)  NULL,
		[OrganizationNcesId] [nvarchar](100) NULL,
		[OrganizationStateId] [nvarchar](100) NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category [nvarchar](100) NULL,
		[YEAR] [nvarchar](50) NULL,
		StudentCount int NULL' + @catSetTemp + '
		)
		INSERT INTO #reportCounts(StateANSICode,
								StateCode,
								StateName,
								OrganizationId,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,
								[YEAR],
								StudentCount,
								Category 
								'+ @catSetInsert + '
								)'



	set @SQL = @SelectSQL + @sqlTemp + @SQL
	declare @ParmDefinition as nvarchar(max)
	SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100)'; 
	 EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear=@reportYear, @reportLevel=@reportLevel, @categorySetCode=@categorySetCode;
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

	SET @sqlrun =  @SQL + '
	SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel
					'+ @catSetIns+ ' as CategorySetCode,
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
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					options.CategoryOptionName as Category,
					[YEAR] '+
					@catSetInsert
					+'
					,StudentCount
					FROM #reportCounts r
					inner join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId=cd.DimensionId
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
					OrganizationId,
					OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,
					Category '+ @catSetInsert + '

				DROP TABLE #reportCounts
				DROP TABLE #tempo
				DROP TABLE #temp
					'
	               EXECUTE sp_executesql @sqlRun, @ParDef, @reportCode = @reportCode, @reportYear=@reportYear, @reportLevel=@reportLevel, @categorySetCode=@categorySetCode;
		SET NOCOUNT OFF;
END


