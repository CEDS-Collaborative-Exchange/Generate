CREATE VIEW [Debug].[vwDirectorySEA_FactTable] 
AS
SELECT	
			  Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Fact.SeaId
			, SEAs.SeaOrganizationIdentifierSea
			, SEAs.SeaOrganizationName
			, SEAs.StateAnsiCode
			, SEAs.WebSiteAddress
			, SEAs.TelephoneNumber
			, SEAs.MailingAddressStreetNumberAndName
			, SEAs.MailingAddressApartmentRoomOrSuiteNumber
			, SEAs.MailingAddressCity
			, SEAs.MailingAddressPostalCode
			, SEAs.MailingAddressStateAbbreviation
			, SEAs.PhysicalAddressStreetNumberAndName
			, SEAs.PhysicalAddressApartmentRoomOrSuiteNumber
			, SEAs.PhysicalAddressCity
			, SEAs.PhysicalAddressPostalCode
			, SEAs.PhysicalAddressStateAbbreviation
			, SEAs.RecordStartDateTime
			, SEAs.RecordEndDateTime
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears					ON Fact.SchoolYearId										= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT							ON SchoolYears.DimSchoolYearId								= DMT.DimSchoolYearId		
	LEFT JOIN   RDS.DimSeas                         SEAs						ON Fact.SeaId    											= SEAs.DimSeaId	

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	AND Fact.SeaId > -1
	--AND SEAs.SeaOrganizationIdentifierSea = '789'

