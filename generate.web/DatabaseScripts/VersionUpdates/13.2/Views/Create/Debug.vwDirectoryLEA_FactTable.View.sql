CREATE VIEW [Debug].[vwDirectoryLEA_FactTable] 
AS
SELECT	
			  Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Fact.LeaId
			, CASE LEAs.ReportedFederally
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			ELSE 'MISSING' END AS LEA_ReportedFederally	
			, LEAs.StateAnsiCode
			, LEAs.LeaIdentifierSea
			, LEAs.LeaIdentifierNces
			, LEAs.LeaOrganizationName
			, LEAs.OutOfStateIndicator
			, LEAs.LeaTypeCode
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
			, LEAs.LeaOperationalStatus
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
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	AND Fact.LeaId > -1	

