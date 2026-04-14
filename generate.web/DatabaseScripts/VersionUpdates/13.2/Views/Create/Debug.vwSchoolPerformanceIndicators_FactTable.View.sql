CREATE VIEW [debug].[vwSchoolPerformanceIndicators_FactTable] 
AS
	SELECT	
		Fact.SchoolYearId
		, SchoolYears.SchoolYear
		, Fact.K12SchoolId
		, Schools.StateAnsiCode
		, Schools.LeaIdentifierSea
		, Schools.LeaOrganizationName
		, Schools.SchoolIdentifierSea
		, Schools.NameOfInstitution
		, Schools.SchoolTypeCode
		, SPICats.SchoolPerformanceIndicatorCategoryEdFactsCode
		, SPI.SchoolPerformanceIndicatorTypeEdFactsCode
		, SPISD.SchoolPerformanceIndicatorStateDefinedStatusCode
		, Ind.IndicatorStatusEdFactsCode
		, SubGrp.SubgroupEdFactsCode
 	FROM		RDS.FactSchoolPerformanceIndicators						Fact
	JOIN		RDS.DimSchoolYears										SchoolYears	ON Fact.SchoolYearId									= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes						DMT			ON SchoolYears.DimSchoolYearId							= DMT.DimSchoolYearId		
	LEFT JOIN	RDS.DimK12Schools										Schools		ON Fact.K12SchoolId										= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimSchoolPerformanceIndicatorCategories				SPICats		ON Fact.SchoolPerformanceIndicatorCategoryId			= SPICats.DimSchoolPerformanceIndicatorCategoryId
	LEFT JOIN	RDS.DimSchoolPerformanceIndicators						SPI			ON Fact.SchoolPerformanceIndicatorId					= SPI.DimSchoolPerformanceIndicatorId
	LEFT JOIN	RDS.DimSchoolPerformanceIndicatorStateDefinedStatuses	SPISD		ON Fact.SchoolPerformanceIndicatorStateDefinedStatusId	= SPISD.DimSchoolPerformanceIndicatorStateDefinedStatusId
	LEFT JOIN	RDS.DimIndicatorStatuses								Ind			ON Fact.IndicatorStatusId								= Ind.DimIndicatorStatusId
	LEFT JOIN	RDS.DimSubgroups										SubGrp		ON Fact.SubgroupId										= SubGrp.DimSubgroupId

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2025
	AND Fact.FactTypeId = 27
	AND Fact.K12SchoolId > -1	
