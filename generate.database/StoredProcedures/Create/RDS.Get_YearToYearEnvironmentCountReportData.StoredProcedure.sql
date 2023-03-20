CREATE PROCEDURE [RDS].[Get_YearToYearEnvironmentCountReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50)
AS
BEGIN

	--set the Subtotal and column name for the report by CategorySetCode being compared
	declare @reportCategorySubtotal varchar(20), @reportColumnName varchar(50)
	set @reportCategorySubtotal = 'ST6'
	set @reportColumnName = 'IDEAEDUCATIONALENVIRONMENT'

	--Quick cleanup until the UI is fixed (file 089 isn't reported at the School level)
	if @categorySetCode = 'earlychildhood' and @reportLevel = 'sch'
	begin
		set @reportLevel = 'lea'
	end
		

	--Get the Year selected and set the variables for the query
	if isnull(@reportYear, '') <> ''
	begin
		--declare the SY variables for the comparison work
		declare @selectedYear varchar(4), @compareYear varchar(4)
		set @selectedYear = @reportYear
		set @compareYear = cast(cast(@reportYear as int) -1 as varchar(4))
	end
	else
	begin 
		print 'No Report Year value passed in'
		return;
	end

	--report logic goes here
	declare @sql varchar(max)

	set @sql = '
	SELECT 
		  CAST(ROW_NUMBER() OVER(ORDER BY ISNULL(a.OrganizationName, b.OrganizationName) ASC) AS INT) as FactCustomCountId
		, ''' + @reportCode + ''' as ReportCode
		, ''' + @reportYear + ''' as ReportYear
		, ''' + @reportLevel + ''' as ReportLevel
		, ''' + @categorySetCode + ''' as CategorySetCode
		, NULL as ReportFilter
		, ISNULL(a.StateANSICode			, b.StateANSICode			 ) AS StateANSICode			  
		, ISNULL(a.StateCode				, b.StateCode				 ) AS StateAbbreviationCode				 
		, ISNULL(a.StateName				, b.StateName				 ) AS StateAbbreviationDescription
		, ISNULL(a.OrganizationNcesId		, b.OrganizationNcesId		 ) AS OrganizationNcesId		 
		, ISNULL(a.OrganizationStateId		, b.OrganizationStateId		 ) AS OrganizationStateId		 
		, ISNULL(a.OrganizationName			, b.OrganizationName		 ) AS OrganizationName		 
		, ISNULL(a.ParentOrganizationStateId, b.ParentOrganizationStateId) AS ParentOrganizationStateId
		, ISNULL(a.IDEAEDUCATIONALENVIRONMENT, b.IDEAEDUCATIONALENVIRONMENT) as	Category1
		, NULL as Category2
		, NULL as Category3
		, NULL as Category4
		, CAST(ISNULL(b.StudentCount, 0) as decimal(18,2))  as col_1
		, CAST(ISNULL(a.StudentCount, 0) as decimal(18,2))  as col_2
		, CAST(ISNULL(a.StudentCount,0) - ISNULL(b.StudentCount,0) as decimal(18,2))  as col_3
		, CASE WHEN CAST(ISNULL(b.StudentCount,0) as decimal(18,2)) <>0 THEN CAST(ISNULL(a.StudentCount,0) - ISNULL(b.StudentCount,0) as decimal(18,2))/CAST(ISNULL(b.StudentCount,0) as decimal(18,2)) ELSE 0 END as col_4		
		, NULL as col_5
		, NULL as col_6
		, NULL as col_7
		, NULL as col_8
		, NULL as col_9
		, NULL as col_10
		, NULL as col_10a
		, NULL as col_10b
		, NULL as col_11
		, NULL as col_11a
		, NULL as col_11b
		, NULL as col_11c
		, NULL as col_11d
		, NULL as col_11e
		, NULL as col_12
		, NULL as col_12a
		, NULL as col_12b
		, NULL as col_13
		, NULL as col_14
		, NULL as col_14a
		, NULL as col_14b
		, NULL as col_14c
		, NULL as col_14d
		, NULL as col_15
		, NULL as col_16
		, NULL as col_17
		, NULL as col_18
		, NULL as col_18a
		, NULL as col_18b
		, NULL as col_18c
		, NULL as col_18d
		, NULL as col_18e
		, NULL as col_18f
		, NULL as col_18g
		, NULL as col_18h
		, NULL as col_18i
	FROM RDS.ReportEDFactsK12StudentCounts a
	FULL OUTER JOIN RDS.ReportEDFactsK12StudentCounts b
		ON a.ReportCode = b.ReportCode
		AND a.ReportLevel = b.ReportLevel
		AND ISNULL(a.OrganizationStateId, '''') = ISNULL(b.OrganizationStateId, '''')
		AND a.CategorySetCode = b.CategorySetCode
		AND CAST(a.ReportYear AS INT) - 1 = CAST(b.ReportYear AS INT)
		AND ISNULL(a.IDEAEDUCATIONALENVIRONMENT, '''') = ISNULL(b.IDEAEDUCATIONALENVIRONMENT, '''')
	WHERE a.ReportCode in (' + 
		CASE @categorySetCode	
			WHEN 'earlychildhood'
				THEN '''C089'')'
			WHEN 'schoolage'
				THEN '''C002'')'
			ELSE '''C002'',''C089'')'
		END + '
	AND a.ReportYear = ''' + @reportYear + '''
	AND a.ReportLevel = ''' + @reportLevel + ''' 
	AND a.CategorySetCode = ''' + @reportCategorySubtotal + '''
	ORDER BY a.ReportCode
	'

--	print (@sql)
	execute (@sql)


END