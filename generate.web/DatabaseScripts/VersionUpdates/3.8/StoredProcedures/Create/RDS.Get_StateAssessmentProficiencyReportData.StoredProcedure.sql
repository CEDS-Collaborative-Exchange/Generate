CREATE PROCEDURE [RDS].[Get_StateAssessmentProficiencyReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@reportFilter as varchar(50),
	@reportSubFilter as varchar(50),
	@reportGrade as varchar(50)
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
	select upper(c.CategoryCode) as ReportField
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
	and upper(d.DimensionFieldName) not in ('ASMTADMNSTRD','GRADELVLASS','PERFLVL','ASSESSMENTSUBJECT','PARTSTATUS')
	order by d.DimensionFieldName asc

	create table #reportCounts
		(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category1 [nvarchar](100) NULL,
		ECODISSTATUS [nvarchar](100) NULL,
		RACE [nvarchar](100) NULL,
		PERFORMANCELEVEL [nvarchar](100) NULL,
		PARTICIPATIONSTATUS [nvarchar](100) NULL,
		AssessmentCount int NULL)

	declare @PivotedCounts as table
		(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category [nvarchar](100) NULL,
		PERFORMANCELEVEL [nvarchar](100) NULL,
		PARTICIPATIONSTATUS [nvarchar](100) NULL,
		AssessmentCount int NULL)

	
	SET @SelectSQL = '
		select StateANSICode,
							StateCode,
							StateName,							
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId, 
							PERFORMANCELEVEL,
							PARTICIPATIONSTATUS,
							SUM(AssessmentCount)
		'

	SET @GroupBySQL = '
		group by StateANSICode,
							StateCode,
							StateName,							
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId, 
							PERFORMANCELEVEL,
							PARTICIPATIONSTATUS
		'


	DECLARE @rowFieldString as nvarchar(100)

	IF(@categorySetCode = 'SWOD')
	BEGIN
		SET @rowFieldString = 'SEX,ECODISSTATUS,RACE'
	END
	ELSE
	BEGIN
		SET @rowFieldString = 'DISABILITY,ECODISSTATUS,RACE'
	END

	SET @SelectSQL = @SelectSQL + ',' + @rowFieldString
	SET @GroupBySQL = @GroupBySQL + ',' + @rowFieldString

	IF(@reportSubFilter = 'REGASSAll')
	BEGIN
			SET @SelectSQL = @SelectSQL + 
			'
				from rds.' + @factReportTable +	'	Where ReportCode = @reportCode and ReportLevel = @reportLevel
				and ReportYear = @reportYear and CategorySetCode = @categorySetCode
				and ASSESSMENTSUBJECT = @reportFilter and ASSESSMENTTYPE in (''REGASSWOACC'',''REGASSWACC'')
				and GradeLevel = @reportGrade
			'
	END
	ELSE
	BEGIN
			SET @SelectSQL = @SelectSQL + 
			'
				from rds.' + @factReportTable +	'	Where ReportCode = @reportCode and ReportLevel = @reportLevel
				and ReportYear = @reportYear and CategorySetCode = @categorySetCode
				and ASSESSMENTSUBJECT = @reportFilter and ASSESSMENTTYPE = @reportSubFilter
				and GradeLevel = @reportGrade
			'
	END
	

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
	SET @ParmDefinition = N'@reportCode varchar(100), @reportYear varchar(100), @reportLevel varchar(100), @categorySetCode varchar(100), @reportFilter varchar(100), @reportSubFilter varchar(100), @reportGrade varchar(50)';  

	INSERT INTO #reportCounts
		(StateANSICode,
		StateCode,
		StateName,		
		OrganizationNcesId,
		OrganizationStateId,
		OrganizationName,
		ParentOrganizationStateId,
		PERFORMANCELEVEL,
		PARTICIPATIONSTATUS,
		AssessmentCount,
		Category1,
		ECODISSTATUS,
		RACE)
	EXECUTE sp_executesql @SQL, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @reportFilter = @reportFilter, @reportSubFilter = @reportSubFilter, @reportGrade = @reportGrade;

	
	-- Zero Counts

	declare @zeroCountSQL as nvarchar(max)
	set @zeroCountSQL = ''
	
	SELECT @zeroCountSQL = [RDS].Get_CountSQL (@reportCode, @reportLevel, @reportYear, @categorySetCode, 'zero-performance', 1, 0,'','',@factTypeCode)

	EXECUTE sp_executesql @zeroCountSQL

	

	declare @reportField as nvarchar(100)

	DECLARE reportField_cursor CURSOR FOR   
	select ReportField FROM @ReportFieldsInCategorySet

	OPEN reportField_cursor  
  
	FETCH NEXT FROM reportField_cursor INTO @reportField
	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		print @reportField
		
		IF(@reportField = 'DISABSTATIDEA')
		BEGIN

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category
						)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Disability Status'
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId



			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'All Students',
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
		END
		ELSE IF(@reportField = 'DISABCATIDEA')
		BEGIN
			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category
						)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Primary Disability Type'
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
		END
		ELSE IF(@reportField = 'RACEETHNIC')
		BEGIN
			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category
						)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Race/Ethnicity'
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						RACE,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						RACE,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS

				INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Asian or Pacific Islander',
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						RACE,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
			HAVING RACE in ('AS7', 'PI7')
		END
		ELSE IF(@reportField = 'ECODIS')
		BEGIN

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category
						)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Economically disadvantaged'
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						ECODISSTATUS,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						ECODISSTATUS,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
			HAVING ECODISSTATUS <> 'MISSING'

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Not economically disadvantaged',
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						ECODISSTATUS,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
			HAVING ECODISSTATUS = 'MISSING'
		END
		ELSE IF(@reportField = 'SEX')
		BEGIN
			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category
						)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						'Sex'
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,
						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId

			INSERT INTO @PivotedCounts(StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						AssessmentCount)
			SELECT 		StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS,
						SUM(AssessmentCount)
			FROM	#reportCounts
			GROUP BY	StateANSICode,
						StateCode,
						StateName,						
						OrganizationNcesId,
						OrganizationStateId,
						OrganizationName,
						ParentOrganizationStateId,
						Category1,
						PERFORMANCELEVEL,
						PARTICIPATIONSTATUS
		END

	FETCH NEXT FROM reportField_cursor INTO @reportField
	END
	CLOSE reportField_cursor;  
	DEALLOCATE reportField_cursor;  
		
	
		SELECT 			CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
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
						ISNULL(options.CategoryOptionName,r.Category) as Category1,
						NULL as Category2,
						NULL as Category3,
						NULL as Category4,
						CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_1,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L1' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_2,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L2' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_3,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L3' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_4,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L4' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_5,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L5' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_6,
						CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L6' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_7,
						CAST(SUM(CASE WHEN PARTICIPATIONSTATUS <> 'MISSING' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) as col_8,
						NULL as col_9,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS <> 'MISSING' THEN AssessmentCount ELSE 0 END) > 0 
							 THEN CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS <> 'MISSING' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_10,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L1' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_10a,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L2' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_10b,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L3' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_11,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L4' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_11a,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L5' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_11b,
						CASE WHEN SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) > 0
							 THEN CAST(SUM(CASE WHEN PERFORMANCELEVEL = 'L6' THEN AssessmentCount ELSE 0 END) as decimal(18,2)) / CAST(SUM(CASE WHEN PARTICIPATIONSTATUS NOT IN ('NPART','MISSING') THEN AssessmentCount ELSE 0 END) as decimal(18,2)) 
							 ELSE 0 
						END as col_11c,
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
						CAST(CASE WHEN r.Category = 'Disability Status' THEN 1
								  WHEN r.Category = 'Primary Disability Type' THEN 1
								  WHEN r.Category = 'All Students' THEN 2
								  WHEN options.Dimension = 'DISABILITY' THEN 3
								  WHEN r.Category = 'Race/Ethnicity' THEN 4
								  WHEN r.Category = 'AM7' THEN 5
								  WHEN r.Category = 'Asian or Pacific Islander' THEN 6
								  WHEN r.Category = 'AS7' THEN 7
								  WHEN r.Category = 'PI7' THEN 8
								  WHEN r.Category = 'BL7' THEN 9
								  WHEN r.Category = 'HI7' THEN 10
								  WHEN r.Category = 'WH7' THEN 11
								  WHEN r.Category = 'MU7' THEN 12
								  WHEN r.Category = 'Economically disadvantaged' THEN 13
								  WHEN r.Category = 'Not economically disadvantaged' THEN 14
								  WHEN options.Dimension = 'ECODISSTATUS' THEN 15
								  WHEN r.Category = 'Sex' THEN 16
								  ELSE 17
						END as decimal(18,2)) as col_17,
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
		@PivotedCounts r
		left outer join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName, c.CategoryName, UPPER(d.DimensionFieldName) as Dimension FROM 
					app.GenerateReports r 
					inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
					inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
					inner join app.Categories c on csc.CategoryId = c.CategoryId
					inner join app.Category_Dimensions cd on c.CategoryId= cd.CategoryId
					inner join app.Dimensions d on cd.DimensionId = d.DimensionId
					inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
					inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
					Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear 
					and cs.CategorySetCode = @categorySetCode ) options
		on r.Category = options.CategoryOptionCode
		Where r.Category <> 'MISSING'
		group by StateANSICode,
		StateCode,
		StateName,
		
		OrganizationNcesId,
		OrganizationStateId,
		OrganizationName,
		ParentOrganizationStateId,
		options.CategoryName,
		options.CategoryOptionName,
		Category,
		options.Dimension
		order by col_17, Category1

		drop table #reportCounts

	SET NOCOUNT OFF;
	
END