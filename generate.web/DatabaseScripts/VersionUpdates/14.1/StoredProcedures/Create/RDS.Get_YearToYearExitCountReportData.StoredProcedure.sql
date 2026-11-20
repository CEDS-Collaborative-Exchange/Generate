CREATE PROCEDURE [RDS].[Get_YearToYearExitCountReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50)
AS
BEGIN

 	declare @reportCategorySubtotal varchar(20), @reportColumnName varchar(50)

	--translate the categorySetCode to the values for ReportEdFactsK12StudentCounts
	if isnull(@categorySetCode, '') <> ''
	begin
		if @categorySetCode = 'age'
		begin
			set @reportCategorySubtotal = 'ST2'
			set @reportColumnName = 'Age'
		end
		else if @categorySetCode = 'disabilitytype'
		begin
			set @reportCategorySubtotal = 'ST6'
			set @reportColumnName = 'PrimaryDisabilityType'
		end
		else if @categorySetCode = 'exittype'
		begin
			set @reportCategorySubtotal = 'ST1'
			set @reportColumnName = 'SpecialEducationExitReason'
		end
		else if @categorySetCode = 'Gender'
		begin
			set @reportCategorySubtotal = 'ST4'
			set @reportColumnName = 'Sex'
		end
		else if @categorySetCode = 'lepstatus'
		begin
			set @reportCategorySubtotal = 'ST5'
			set @reportColumnName = 'LEPBoth'
		end
		else if @categorySetCode = 'raceethnicity'
		begin
			set @reportCategorySubtotal = 'ST3'
			set @reportColumnName = 'Race'
		end			
	end
	else
	begin 
		print 'No Category Set value passed in'
		return;
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

	--pull the report together
	SELECT 
		  CAST(ROW_NUMBER() OVER(ORDER BY ISNULL(a.OrganizationName, b.OrganizationName) ASC) AS INT) as FactCustomCountId
		, @reportCode as ReportCode
		, @reportYear as ReportYear
		, @reportLevel as ReportLevel
		, @categorySetCode as CategorySetCode
		, NULL as ReportFilter
		, ISNULL(a.StateANSICode					, b.StateANSICode						) AS StateANSICode			  
		, ISNULL(a.StateAbbreviationCode			, b.StateAbbreviationCode				) AS StateAbbreviationCode				 
		, ISNULL(a.StateAbbreviationDescription		, b.StateAbbreviationDescription		) AS StateAbbreviationDescription
		, ISNULL(a.OrganizationIdentifierNces		, b.OrganizationIdentifierNces			) AS OrganizationNcesId		 
		, ISNULL(a.OrganizationIdentifierSea		, b.OrganizationIdentifierSea			) AS OrganizationStateId		 
		, ISNULL(a.OrganizationName					, b.OrganizationName					) AS OrganizationName		 
		, ISNULL(a.ParentOrganizationIdentifierSea	, b.ParentOrganizationIdentifierSea		) AS ParentOrganizationStateId
		, CASE @reportColumnName
			WHEN 'AGE' THEN ISNULL(a.AGE, b.AGE)
			WHEN 'SEX' THEN ISNULL(a.SEX, b.SEX)
			WHEN 'PrimaryDisabilityType' THEN ISNULL(a.IDEADISABILITYTYPE, b.IDEADISABILITYTYPE)
			WHEN 'LEPBoth' THEN ISNULL(a.ENGLISHLEARNERSTATUS, b.ENGLISHLEARNERSTATUS)
			WHEN 'RACE' THEN ISNULL(a.RACE, b.RACE)
			WHEN 'SpecialEducationExitReason' THEN ISNULL(a.SpecialEducationExitReason, b.SpecialEducationExitReason)
		END AS Category1
		, NULL as Category2
		, NULL as Category3
		, NULL as Category4
		, CAST(ISNULL(b.StudentCount, 0) as decimal(18,2))  as col_1
		, CAST(ISNULL(a.StudentCount, 0) as decimal(18,2))  as col_2
		, CAST(ISNULL(a.StudentCount,0) - ISNULL(b.StudentCount,0) as decimal(18,2))  as col_3
		, CASE WHEN CAST(ISNULL(b.StudentCount,0) as decimal(18,2)) <>0 
			THEN CAST(ISNULL(a.StudentCount,0) - ISNULL(b.StudentCount,0) as decimal(18,2))/CAST(ISNULL(b.StudentCount,0) as decimal(18,2)) 
			ELSE 0 
		END as col_4		
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
		AND ISNULL(a.OrganizationIdentifierSea, '') = ISNULL(b.OrganizationIdentifierSea, '')
		AND a.CategorySetCode = b.CategorySetCode
		AND CAST(a.ReportYear AS INT) - 1 = CAST(b.ReportYear AS INT)
		AND ISNULL(a.Age, '') = ISNULL(b.Age, '')
		AND ISNULL(a.SEX, '') = ISNULL(b.SEX, '')
		AND ISNULL(a.IDEADISABILITYTYPE, '') = ISNULL(b.IDEADISABILITYTYPE, '')
		AND ISNULL(a.ENGLISHLEARNERSTATUS, '') = ISNULL(b.ENGLISHLEARNERSTATUS, '')
		AND ISNULL(a.RACE, '') = ISNULL(b.RACE, '')
		AND ISNULL(a.SpecialEducationExitReason, '') = ISNULL(b.SpecialEducationExitReason, '')
	WHERE a.ReportCode = 'C009'
		AND a.ReportYear = @selectedYear
		AND a.ReportLevel = @reportLevel
		AND a.CategorySetCode = @reportCategorySubtotal

END