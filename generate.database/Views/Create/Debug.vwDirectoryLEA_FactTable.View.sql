CREATE VIEW [Debug].[vwDirectoryLEA_FactTable] 
AS
SELECT	
			  Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Fact.LeaId
			, LEAs.ReportedFederally		
			, LEAs.StateAnsiCode
			, LEAs.LeaIdentifierSea
			, LEAs.LeaIdentifierNces
			, LEAs.LeaOrganizationName
			, LEAs.OutOfStateIndicator
			, LEAs.LeaTypeEdFactsCode
			, LEAs.WebSiteAddress
			, LEAs.LeaSupervisoryUnionIdentificationNumber
			, LEAs.TelephoneNumber
			, LEAs.MailingAddressStreetNumberAndName
			, LEAs.MailingAddressApartmentRoomOrSuiteNumber
			, LEAs.MailingAddressCity
			, LEAs.MailingAddressPostalCode
			, LEAs.MailingAddressStateAbbreviation
			, LEAs.PhysicalAddressStreetNumberAndName
			, LEAs.PhysicalAddressApartmentRoomOrSuiteNumber
			, LEAs.PhysicalAddressCity
			, LEAs.PhysicalAddressPostalCode
			, LEAs.PhysicalAddressStateAbbreviation
			, LEAs.LeaOperationalStatusEdFactsCode
			, LEAs.OperationalStatusEffectiveDate
			, LEAs.RecordStartDateTime
			, LEAs.RecordEndDateTime
			, LEAs.CharterLeaStatus
			, LEAs.PriorLeaIdentifierSea
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears					ON Fact.SchoolYearId										= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT							ON SchoolYears.DimSchoolYearId								= DMT.DimSchoolYearId		
	LEFT JOIN	RDS.DimLeas							LEAs						ON Fact.LeaId												= LEAs.DimLeaId

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	AND Fact.LeaId > -1	
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND LEAs.LeaOperationalStatusEdFactsCode IN (1,2,3)
