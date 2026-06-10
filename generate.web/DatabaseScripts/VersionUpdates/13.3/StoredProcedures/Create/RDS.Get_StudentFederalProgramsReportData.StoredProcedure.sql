CREATE PROCEDURE [RDS].[Get_StudentFederalProgramsReportData]
	@reportCode as varchar(50),
	@reportLevel as varchar(50),
	@reportYear as varchar(50),
	@categorySetCode as varchar(50),
	@reportFilter as varchar(50)
AS
BEGIN


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
			CASE when Category1 = 'LEP' then 'English Learner Status' else Category1 end as Category1,
			NULL as Category2,
			NULL as Category3,
			NULL as Category4,
			ISNULL(col_1,0) as col_1,
			ISNULL(col_2,0) as col_2,
			ISNULL(col_3,0) as col_3,
			ISNULL(col_4,0) as col_4,
			ISNULL(col_5,0) as col_5,
			ISNULL(col_6,0) as col_6,
			ISNULL(col_7,0) as col_7,
			ISNULL(col_8,0) as col_8,
			ISNULL(col_9,0) as col_9,
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
		and ReportFilter = @reportFilter


END
