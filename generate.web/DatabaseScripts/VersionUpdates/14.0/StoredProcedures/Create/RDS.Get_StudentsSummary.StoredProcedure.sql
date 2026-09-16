CREATE PROCEDURE [RDS].[Get_StudentsSummary]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@reportLea as varchar(50)
AS
BEGIN


	SET NOCOUNT ON;
	DECLARE @factTable as varchar(50), @factField as varchar(50), @factReportTable as varchar(50), @factReportId as varchar(50), @SQL nvarchar(MAX), @tableSql nvarchar(max)
	DECLARE @DeclareSQL nvarchar(MAX), @InsertSQL nvarchar(MAX), @SelectSQL nvarchar(MAX), @GroupBySQL nvarchar(MAX), @pivot nvarchar(MAX), @calculator nvarchar(max), @pivoting nvarchar(max)
	DECLARE @GetValues nvarchar(max), @GroupByGetValuesSql nvarchar(max), @organizationInfo nvarchar(max), @organizationGroupBy nvarchar(max)
		
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

		if @categorySetCode in ('earlychildhood','schoolage','earlychildhoodwithraceethnic','schoolagewithraceethnic','earlychildhoodwithgender','schoolagewithgender','earlychildhoodwithdisability','schoolagewithdisability','earlychildhoodwithlepstatus','schoolagewithlepstatus')
		begin
			insert into @ReportFieldsInCategorySet (ReportField)
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
				and cs.CategorySetCode = isnull(@categorySetCode, cs.CategorySetCode) AND d.DimensionFieldName<>'AGE'
		end
	
		else
		begin
			insert into @ReportFieldsInCategorySet	(ReportField)
				select distinct upper(d.DimensionFieldName) as ReportField
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
		end
	DECLARE @catSetTemp nvarchar(max), @categoryColumn nvarchar(max), @catSetInsert nvarchar(Max), @FORPIVOT nvarchar(max), @forSelect nvarchar(max)
	DECLARE @sqlTemp nvarchar(max), @catIns nvarchar(max), @catSetIns nvarchar(max), @reportCounts nvarchar(max), @sqlInsert nvarchar(max)
	set @catSetTemp=''
	SET @categoryColumn=''
	set @catSetInsert=''
	set @sqlTemp=''
	set @sqlInsert=''
	set @SelectSQL=''
	set @GroupBySQL=''
	set @FORPIVOT=''
	set @forSelect=''
	set @pivoting=''
	set @GetValues=''
	set @organizationInfo=''
	set @organizationGroupBy=''
	IF @categorySetCode like ('disability%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'DISABILITY'
		SET @GroupBySQL = @GroupBySQL + ',' + 'DISABILITY'	
	END
	ELSE IF @categorySetCode like ('age%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'AGE'
		SET @GroupBySQL = @GroupBySQL + ',' + 'AGE'	
	END
	ELSE IF @categorySetCode like ('lepstatus%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'LEPSTATUS'
		SET @GroupBySQL = @GroupBySQL + ',' + 'LEPSTATUS'	
	END
	ELSE IF @categorySetCode like ('raceethnic%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'RACE'
		SET @GroupBySQL = @GroupBySQL + ',' + 'RACE'	
	END
	ELSE IF @categorySetCode like ('gender%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'SEX'
		SET @GroupBySQL = @GroupBySQL + ',' + 'SEX'	
	END
	ELSE IF @categorySetCode like ('earlychildhood%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'EDUCENV'
		SET @GroupBySQL = @GroupBySQL + ',' + 'EDUCENV'	
	END
	ELSE IF @categorySetCode like ('schoolage%')
	BEGIN
		SET @SelectSQL = @SelectSQL + ',' + 'EDUCENV'
		SET @GroupBySQL = @GroupBySQL + ',' + 'EDUCENV'	
	END

	DECLARE @rowField as nvarchar(100)
	DECLARE reportFieldRow_cursor CURSOR FOR   
	select ReportField FROM @ReportFieldsInCategorySet

	OPEN reportFieldRow_cursor  
  
	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	WHILE @@FETCH_STATUS = 0  
	BEGIN  	
		
		IF(@rowField<>'DISABILITY' and @categorySetCode like ('disabilityw%'))
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
		ELSE IF(@rowField<>'AGE' and @categorySetCode like ('agew%'))
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
		ELSE IF(@rowField<>'LEPSTATUS' and @categorySetCode like ('lepstatus%') )
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
		ELSE IF(@rowField<>'RACE' and @categorySetCode like ('raceethnic%') )
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
		ELSE IF(@rowField<>'SEX' and @categorySetCode like ('gender%') )
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
			ELSE IF(@rowField<>'EDUCENV' and @categorySetCode like ('earlychildhood%') )
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
			ELSE IF(@rowField<>'EDUCENV' and @categorySetCode like ('schoolage%') )
		BEGIN
		SET @SelectSQL = @SelectSQL + ',' + @rowField
		SET @GroupBySQL = @GroupBySQL + ',' + @rowField	
			SET @catSetTemp = @catSetTemp + ',
			'+ @rowField +' [nvarchar](100) NULL' 
			SET @catSetInsert= @catsetInsert + ' ,' + @rowField
			set @FORPIVOT ='['+ @rowField +']'
			set @forSelect= @forSelect+ ', ' + @rowField
		END
	FETCH NEXT FROM reportFieldRow_cursor INTO @rowField
	END
	CLOSE reportFieldRow_cursor;  
	DEALLOCATE reportFieldRow_cursor;

	set @reportCounts=''
	set @reportCounts =' create table #reportCounts
	(
		[OrganizationName] [nvarchar](1000) NOT NULL,
		[OrganizationNcesId] [nvarchar](100) NOT NULL,
		[OrganizationStateId] [nvarchar](100) NOT NULL,
		[ParentOrganizationStateId] [nvarchar](100) NULL,
		[StateANSICode] [nvarchar](100) NOT NULL,
		[StateCode] [nvarchar](100) NOT NULL,
		[StateName] [nvarchar](500) NOT NULL,
		Category [nvarchar](100) NULL,		
		CategorySetCode [nvarchar](100) NULL, 
		StudentCount int NULL'
	
	set @sqlInsert='
			INSERT INTO #reportCounts(StateANSICode,
								StateCode,
								StateName,
								OrganizationNcesId,
								OrganizationStateId,
								OrganizationName,
								ParentOrganizationStateId,								
								CategorySetCode,
								StudentCount,
								Category'

	set @reportCounts =@reportCounts+' ' + @catSetTemp +')'
	set @sqlInsert = @sqlInsert + '
		' + @catSetInsert +')'
	SET @SelectSQL = '
		select StateANSICode,
							StateCode,
							StateName,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId,
							CategorySetCode,
							ISNULL(SUM(StudentCount),0)
							
		' + @SelectSQL

	SET @GroupBySQL = '
		group by StateANSICode,
							StateCode,
							StateName,
							OrganizationNcesId,
							OrganizationStateId,
							OrganizationName,
							ParentOrganizationStateId, 
							CategorySetCode
		' + @GroupBySQL

		set @organizationInfo ='OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,'

					set @organizationGroupBy='OrganizationNcesId,
					OrganizationStateId,
					OrganizationName,
					ParentOrganizationStateId,'

	SET @SelectSQL = @SelectSQL + 
			'
				from rds.' + @factReportTable +	'	Where ReportCode = @reportCode and ReportLevel = @reportLevel
				and ReportYear = @reportYear and CategorySetCode=@categorySetCode
			'

	SET @SQL = @SelectSQL + @GroupBySQL

	set @pivot=''
	set @calculator=''
	if (@categorySetCode  in( 'disabilitywithraceethnic','agewithraceethnic','lepstatuswithraceethnic','genderwithraceethnic','earlychildhoodwithraceethnic','schoolagewithraceethnic'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([AM7],[AS7],[BL7],[HI7],[MU7],[PI7],[WH7])
					) AS PivotTable '

	set @calculator = 'CAST(ISNULL(SUM([AM7]),0) as decimal(18,4))  as col_1,
					CAST(CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_2,					
					CAST(ISNULL(SUM([BL7]),0) as decimal(18,4))  as col_3,
					CAST(CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_4,					
					CAST(ISNULL(SUM([AS7]),0)  as decimal(18,4)) as col_5,
					CAST(CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_6,															
					CAST(ISNULL(SUM([HI7]),0)  as decimal(18,4)) as col_7,
					CAST(CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_8,					
					CAST(ISNULL(SUM([MU7]),0)  as decimal(18,4)) as col_9,
					CAST(CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_10,					
					CAST(ISNULL(SUM([PI7]),0)  as decimal(18,4)) as col_10a,
					CAST(CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_10b,					
					CAST(ISNULL(SUM([WH7]),0)  as decimal(18,4)) as col_11,
					CAST(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) ) as decimal(18,4))  as col_11a,					
					CAST(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) as decimal(18,4)) as col_11b,
					CAST(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([WH7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PI7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MU7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI7]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([BL7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AM7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([AS7]),0) AS decimal(18,4)) as decimal(18,4)) as col_11c,
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
					'
	end
	else if  (@categorySetCode  in ( 'disabilitywithgender', 'agewithgender','lepstatuswithgender','raceethnicwithgender','schoolagewithgender','earlychildhoodwithgender'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([M],[F])
					) AS PivotTable'
	set @calculator = 'CAST(ISNULL(SUM([M]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([M]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([M]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([F]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,										
						CAST(ISNULL(SUM([F]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([F]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([M]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([F]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,															
						CAST(CAST(ISNULL(SUM([M]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([F]),0) AS decimal(18,4)) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([M]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([F]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([M]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([F]),0) AS decimal(18,4)) as decimal(18,4))  as col_6,
						NULL  as col_7,
						NULL  as col_8,
						NULL  as col_9,
						NULL  as col_10,
						NULL  as col_10a,
						NULL  as col_10b,
						NULL  as col_11,
						NULL  as col_11a,
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
					'
	end

		else if  (@categorySetCode  in ('agewithdisability', 'raceethnicwithdisability','lepstatuswithdisability','genderwithdisability','earlychildhoodwithdisability','schoolagewithdisability'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([AUT],[DD],[DB],[EMN],[HI],[MD],[MR],[OHI],[OI],[SLD],[SLI],[TBI],[VI])
					) AS PivotTable '
	set @calculator = 'CAST(ISNULL(SUM([AUT]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,										
						CAST(ISNULL(SUM([DB]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([DB]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,															
						CAST(ISNULL(SUM([DD]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([DD]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_6,
						CAST(ISNULL(SUM([EMN]),0) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_8,
						CAST(ISNULL(SUM([HI]),0) as decimal(18,4))  as col_9,
						CAST(CAST(ISNULL(SUM([HI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_10,
						CAST(ISNULL(SUM([MD]),0) as decimal(18,4))  as col_10a,
						CAST(CAST(ISNULL(SUM([MD]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_10b,
						CAST(ISNULL(SUM([MR]),0) as decimal(18,4))  as col_11,
						CAST(CAST(ISNULL(SUM([MR]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4))  as col_11a,
						CAST(ISNULL(SUM([OHI]),0) as decimal(18,4)) as col_11b,
						CAST(CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_11c,
						CAST(ISNULL(SUM([OI]),0) as decimal(18,4)) as col_11d,
						CAST(CAST(ISNULL(SUM([OI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_11e,
						CAST(ISNULL(SUM([SLD]),0) as decimal(18,4)) as col_12,
						CAST(CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_12a,
						CAST(ISNULL(SUM([SLI]),0) as decimal(18,4)) as col_12b,
						CAST(CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_13,
						CAST(ISNULL(SUM([TBI]),0) as decimal(18,4)) as col_14,
						CAST(CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_14a,
						CAST(ISNULL(SUM([VI]),0) as decimal(18,4)) as col_14b,
						CAST(CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4))) as decimal(18,4)) as col_14c,
						CAST(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4)) as decimal(18,4)) as col_14d,
						CAST(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([AUT]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([DB]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([DD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([EMN]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([MR]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OHI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([OI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLD]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SLI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([TBI]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([VI]),0) AS decimal(18,4)) as decimal(18,4)) as col_15,
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
					'
	end
	else if  (@categorySetCode  in ('disabilitywithlepstatus', 'agewithlepstatus', 'raceethnicwithlepstatus','genderwithlepstatus','earlychildhoodwithlepstatus','schoolagewithlepstatus'))
	begin
		set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([LEP],[NLEP])
					) AS PivotTable '
	set @calculator = 'CAST(ISNULL(SUM([LEP]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,	
						CAST(ISNULL(SUM([NLEP]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,	
						CAST(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4)) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([LEP]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([NLEP]),0) AS decimal(18,4)) as decimal(18,4))  as col_6,
						NULL  as col_7,
						NULL  as col_8,
						NULL  as col_9,
						NULL  as col_10,
						NULL  as col_10a,
						NULL  as col_10b,
						NULL  as col_11,
						NULL  as col_11a,
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

					'
	end
	else if  (@categorySetCode  in ('disabilitywithage','lepstatuswithage','raceethnicwithage','genderwithage','genderwithage'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21])
					) AS PivotTable '
	set @calculator = '	CAST(ISNULL(SUM([3]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,	
						CAST(ISNULL(SUM([4]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([4]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,	
						CAST(ISNULL(SUM([5]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([5]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_6,
						CAST(ISNULL(SUM([6]),0) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([6]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_8,
						CAST(ISNULL(SUM([7]),0) as decimal(18,4))  as col_9,
						CAST(CAST(ISNULL(SUM([7]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_10,
						CAST(ISNULL(SUM([8]),0) as decimal(18,4))  as col_10a,
						CAST(CAST(ISNULL(SUM([8]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_10b,
						CAST(ISNULL(SUM([9]),0) as decimal(18,4))  as col_11,
						CAST(CAST(ISNULL(SUM([9]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_11a,
						CAST(ISNULL(SUM([10]),0) as decimal(18,4))  as col_11b,
						CAST(CAST(ISNULL(SUM([10]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4)) as col_11c,
						CAST(ISNULL(SUM([11]),0) as decimal(18,4))  as col_11d,
						CAST(CAST(ISNULL(SUM([11]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_11e,
						CAST(ISNULL(SUM([12]),0) as decimal(18,4))  as col_12,
						CAST(CAST(ISNULL(SUM([12]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_12a,
						CAST(ISNULL(SUM([13]),0) as decimal(18,4))  as col_12b,
						CAST(CAST(ISNULL(SUM([13]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_13,
						CAST(ISNULL(SUM([14]),0) as decimal(18,4))  as col_14,
						CAST(CAST(ISNULL(SUM([14]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_14a,
						CAST(ISNULL(SUM([15]),0) as decimal(18,4))  as col_14b,
						CAST(CAST(ISNULL(SUM([15]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_14c,
						CAST(ISNULL(SUM([16]),0) as decimal(18,4))  as col_14d,
						CAST(CAST(ISNULL(SUM([16]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_15,
						CAST(ISNULL(SUM([17]),0) as decimal(18,4))  as col_16,
						CAST(CAST(ISNULL(SUM([17]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_17,
						CAST(ISNULL(SUM([18]),0) as decimal(18,4))  as col_18,
						CAST(CAST(ISNULL(SUM([18]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_18a,
						CAST(ISNULL(SUM([19]),0) as decimal(18,4))  as col_18b,
						CAST(CAST(ISNULL(SUM([19]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_18c,
						CAST(ISNULL(SUM([20]),0) as decimal(18,4))  as col_18d,
						CAST(CAST(ISNULL(SUM([20]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_18e,
						CAST(ISNULL(SUM([21]),0) as decimal(18,4))  as col_18f,
						CAST(CAST(ISNULL(SUM([21]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_18g,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4)) as col_18h,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4)) as col_18i
					'
	end

	else if  (@categorySetCode  in ('schoolagewithage'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21])
					) AS PivotTable '
	set @calculator = '	CAST(ISNULL(SUM([6]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([6]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,	
						CAST(ISNULL(SUM([7]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([7]),0) AS decimal(18,4))/( CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,	
						CAST(ISNULL(SUM([8]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([8]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_6,
						CAST(ISNULL(SUM([9]),0) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([9]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_8,
						CAST(ISNULL(SUM([10]),0) as decimal(18,4))  as col_9,
						CAST(CAST(ISNULL(SUM([10]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_10,
						CAST(ISNULL(SUM([11]),0) as decimal(18,4))  as col_10a,
						CAST(CAST(ISNULL(SUM([11]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_10b,
						CAST(ISNULL(SUM([12]),0) as decimal(18,4))  as col_11,
						CAST(CAST(ISNULL(SUM([12]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))  as col_11a,
						CAST(ISNULL(SUM([13]),0) as decimal(18,4))  as col_11b,
						CAST(CAST(ISNULL(SUM([13]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4)) as col_11c,
						CAST(ISNULL(SUM([14]),0) as decimal(18,4))  as col_11d,
						CAST(CAST(ISNULL(SUM([14]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_11e,
						CAST(ISNULL(SUM([15]),0) as decimal(18,4))  as col_12,
						CAST(CAST(ISNULL(SUM([15]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_12a,
						CAST(ISNULL(SUM([16]),0) as decimal(18,4))  as col_12b,
						CAST(CAST(ISNULL(SUM([16]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_13,
						CAST(ISNULL(SUM([17]),0) as decimal(18,4))  as col_14,
						CAST(CAST(ISNULL(SUM([17]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_14a,
						CAST(ISNULL(SUM([18]),0) as decimal(18,4))  as col_14b,
						CAST(CAST(ISNULL(SUM([18]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_14c,
						CAST(ISNULL(SUM([19]),0) as decimal(18,4))  as col_14d,
						CAST(CAST(ISNULL(SUM([19]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_15,
						CAST(ISNULL(SUM([20]),0) as decimal(18,4))  as col_16,
						CAST(CAST(ISNULL(SUM([20]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_17,
						CAST(ISNULL(SUM([21]),0) as decimal(18,4))  as col_18,
						CAST(CAST(ISNULL(SUM([21]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4))) as decimal(18,4))   as col_18a,
						CAST(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4)) as col_18b,
						CAST(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([6]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([7]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([8]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([9]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([10]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([11]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([12]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([13]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([14]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([15]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([16]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([17]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([18]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([19]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([20]),0) AS decimal(18,4)) +  CAST(ISNULL(SUM([21]),0) AS decimal(18,4)) as decimal(18,4)) as col_18c,
						NULL as col_18d,
						NULL as col_18e,
						NULL as col_18f,
						NULL as col_18g,
						NULL as col_18h,
						NULL as col_18i
					'
	end
	else if  (@categorySetCode  in ('earlychildhoodwithage'))
	begin
	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([3],[4],[5])
					) AS PivotTable '
	set @calculator = '	CAST(ISNULL(SUM([3]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,	
						CAST(ISNULL(SUM([4]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([4]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4))) as decimal(18,4))  as col_4,	
						CAST(ISNULL(SUM([5]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([5]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4))) as decimal(18,4))  as col_6,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4)) +CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([3]),0) AS decimal(18,4))  + CAST(ISNULL(SUM([4]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([5]),0) AS decimal(18,4)) as decimal(18,4))  as col_8,
						NULL  as col_9,
						NULL  as col_10,
						NULL  as col_10a,
						NULL  as col_10b,
						NULL  as col_11,
						NULL  as col_11a,
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
						'
	end
	else if  (@categorySetCode in ('disabilitywithearlychildhood' ,'agewithearlychildhood','lepstatuswithearlychildhood','raceethnicwithearlychildhood', 'genderwithearlychildhood'))
	begin

	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([H],[REC09YOTHLOC],[REC09YSVCS],[REC10YOTHLOC],[REC10YSVCS],[RF],[SC],[SPL],[SS])
					) AS PivotTable'

	set @calculator = 'CAST(ISNULL(SUM([H]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([H]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_2,	
						CAST(ISNULL(SUM([REC09YOTHLOC]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_4,	
						CAST(ISNULL(SUM([REC09YSVCS]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_6,
						CAST(ISNULL(SUM([REC10YOTHLOC]),0) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_8,
						CAST(ISNULL(SUM([REC10YSVCS]),0) as decimal(18,4))  as col_9,
						CAST(CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_10,
						CAST(ISNULL(SUM([RF]),0) as decimal(18,4))  as col_10a,
						CAST(CAST(ISNULL(SUM([RF]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_10b,
						CAST(ISNULL(SUM([SC]),0) as decimal(18,4))  as col_11,
						CAST(CAST(ISNULL(SUM([SC]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_11a,
						CAST(ISNULL(SUM([SPL]),0) as decimal(18,4)) as col_11b,
						CAST(CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_11c,
						CAST(ISNULL(SUM([SS]),0) as decimal(18,4)) as col_11d,
						CAST(CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_11e,
						CAST(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4)) as col_12,
						CAST(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([H]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC09YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YOTHLOC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([REC10YSVCS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SC]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SPL]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4)) as col_12a,
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

					'
	end
	else if  (@categorySetCode in ( 'disabilitywithschoolage','agewithschoolage','lepstatuswithschoolage','raceethnicwithschoolage','genderwithschoolage'))
	begin

	set @pivot='	PIVOT
					(	
						SUM(StudentCount)
						FOR '+ @FORPIVOT +' IN ([CF],[HH],[PPPS],[RC39],[RC79TO40],[RC80],[RF],[SS])
					) AS PivotTable '

	set @calculator = 'CAST(ISNULL(SUM([CF]),0) as decimal(18,4))  as col_1,
						CAST(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_2,	
						CAST(ISNULL(SUM([HH]),0) as decimal(18,4))  as col_3,
						CAST(CAST(ISNULL(SUM([HH]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_4,	
						CAST(ISNULL(SUM([PPPS]),0) as decimal(18,4)) as col_5,
						CAST(CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_6,
						CAST(ISNULL(SUM([RC39]),0) as decimal(18,4))  as col_7,
						CAST(CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_8,
						CAST(ISNULL(SUM([RC79TO40]),0) as decimal(18,4))  as col_9,
						CAST(CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_10,
						CAST(ISNULL(SUM([RC80]),0) as decimal(18,4))  as col_10a,
						CAST(CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_10b,
						CAST(ISNULL(SUM([RF]),0) as decimal(18,4))  as col_11,
						CAST(CAST(ISNULL(SUM([RF]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4))  as col_11a,
						CAST(ISNULL(SUM([SS]),0) as decimal(18,4)) as col_11b,
						CAST(CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))/(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4))) as decimal(18,4)) as col_11c,
						CAST(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4)) as col_11d,
						CAST(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4))/CAST(CAST(ISNULL(SUM([CF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([HH]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([PPPS]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC39]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RC79TO40]),0) AS decimal(18,4))+ CAST(ISNULL(SUM([RC80]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([RF]),0) AS decimal(18,4)) + CAST(ISNULL(SUM([SS]),0) AS decimal(18,4)) as decimal(18,4)) as col_11e,
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

					'
	end
	else if  (@categorySetCode in ( 'disability','raceethnic','age','gender','lepstatus','earlychildhood','schoolage'))
	begin

	set @calculator = ' CAST(ISNULL(Sum(StudentCount),0) as decimal(18,4))  as col_1,
						NULL  as col_2,	
						NULL  as col_3,
						NULL as col_4,	
						NULL as col_5,
						NULL  as col_6,
						NULL  as col_7,
						NULL  as col_8,
						NULL  as col_9,
						NULL  as col_10,
						NULL  as col_10a,
						NULL  as col_10b,
						NULL  as col_11,
						NULL  as col_11a,
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

					'
	end



	declare @ParDef as nvarchar(max)
	SET @ParDef = N'@reportCode varchar(50), @reportYear varchar(50), @reportLevel varchar(50), @categorySetCode varchar(50)';  

	declare @sqlrun as nvarchar(max)
	set @sqlrun= @reportCounts + @sqlInsert + @SQL

	set  @sqlrun = @sqlrun  + '		
	
			SELECT CAST(ROW_NUMBER() OVER(ORDER BY Category ASC) AS INT) as FactCustomCountId,
					@reportCode as ReportCode, 
					@reportYear as ReportYear,
					@reportLevel as ReportLevel, 
					CategorySetCode as CategorySetCode,
					NULL as ReportFilter,
					StateANSICode,
					StateCode,
					StateName,'
					+ @organizationInfo + '
					Category as Category1,
					NULL as Category2,
					NULL as Category3,
					NULL as Category4,' + 
					@calculator
					+ 
					'					
					FROM
					(
					SELECT StateANSICode,
					StateCode,
					StateName,
					'+ @organizationGroupBy +'
					options.CategoryOptionName as Category,
					StudentCount'
					+@forSelect+'
					,CategorySetCode
					FROM #reportCounts r
					left join (SELECT distinct co.CategoryOptionCode, co.CategoryOptionName FROM 
						app.GenerateReports r 
						inner join app.CategorySets cs on r.GenerateReportId = cs.GenerateReportId
						inner join app.CategorySet_Categories csc on cs.CategorySetId = csc.CategorySetId
						inner join app.Categories c on csc.CategoryId = c.CategoryId
						inner join app.OrganizationLevels o on o.OrganizationLevelId = cs.OrganizationLevelId
						inner join app.CategoryOptions co on co.CategoryId = c.CategoryId and co.CategorySetId = cs.CategorySetId
						inner join app.Category_Dimensions cd on c.CategoryId = cd.CategoryId
						inner join app.Dimensions d on d.DimensionId=cd.DimensionId
						Where r.ReportCode = @reportCode and o.LevelCode = @reportLevel and cs.SubmissionYear = @reportYear and cs.CategorySetCode=@categorySetCode
						) options
					
					on r.Category = options.CategoryOptionCode
					Where r.Category not in (''MISSING'')
					) as SourceTable '
					+ @pivot +
					' group by StateANSICode,
					StateCode,
					StateName,'+ @organizationGroupBy +'
					Category,
					CategorySetCode
					
					DROP TABLE #reportCounts
					'

					--print  @sqlrun
					EXECUTE sp_executesql @sqlRun, @ParDef, @reportCode = @reportCode, @reportYear=@reportYear, @reportLevel=@reportLevel, @categorySetCode=@categorySetCode;


	


		SET NOCOUNT OFF;
END