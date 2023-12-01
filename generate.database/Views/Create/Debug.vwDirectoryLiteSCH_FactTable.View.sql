CREATE VIEW [Debug].[vwDirectoryLiteSCH_FactTable] 
AS
SELECT DISTINCT	
			Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Schools.LeaIdentifierSea
			, Schools.LeaOrganizationName
			, CASE Schools.ReportedFederally
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			ELSE 'MISSING' END									AS SchoolReportedFederally
			, Schools.SchoolIdentifierSea
			, Schools.NameOfInstitution
			, Schools.SchoolTypeCode
			, Schools.SchoolOperationalStatus
			, Schools.SchoolOperationalStatusEffectiveDate
			, Schools.RecordStartDateTime
			, Schools.RecordEndDateTime
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears		ON Fact.SchoolYearId				= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT				ON SchoolYears.DimSchoolYearId		= DMT.DimSchoolYearId		
	LEFT JOIN	RDS.DimK12Schools					Schools			ON Fact.K12SchoolId					= Schools.DimK12SchoolId

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	--AND Schools.SchoolIdentifierSea = '010456'
	--AND Schools.SchoolOperationalStatus = 'Open'      --'Open', 'Closed', 'New', 'FutureSchool'
	--AND Schools.SchoolTypeCode = 'Regular' 			--'CareerAndTechnical', 'Alternative', 'Special', 'Reportable', 'Regular'