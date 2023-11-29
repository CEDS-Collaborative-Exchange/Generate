CREATE VIEW [Debug].[vwDirectory_FactTable] 
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
			, Fact.LeaId		
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
			, Fact.K12SchoolId		
			, Schools.StateAnsiCode
			, Schools.LeaIdentifierSea
			, Schools.LeaIdentifierNces
			, Schools.LeaOrganizationName
			, Schools.SchoolIdentifierSea
			, Schools.NameOfInstitution
			, Schools.SchoolTypeEdFactsCode
			, Schools.OutOfStateIndicator
			, Schools.WebSiteAddress
			, Schools.TelephoneNumber
			, Schools.MailingAddressStreetNumberAndName
			, Schools.MailingAddressApartmentRoomOrSuiteNumber
			, Schools.MailingAddressCity
			, Schools.MailingAddressPostalCode
			, Schools.MailingAddressStateAbbreviation
			, Schools.PhysicalAddressStreetNumberAndName
			, Schools.PhysicalAddressApartmentRoomOrSuiteNumber
			, Schools.PhysicalAddressCity
			, Schools.PhysicalAddressPostalCode
			, Schools.PhysicalAddressStateAbbreviation
			, Schools.SchoolOperationalStatusEdFactsCode
			, Schools.SchoolOperationalStatusEffectiveDate
			, Schools.RecordStartDateTime
			, Schools.RecordEndDateTime
			, Schools.PriorLeaIdentifierSea
			, Schools.PriorSchoolIdentifierSea
			, Schools.ReconstitutedStatus
			, Schools.CharterSchoolContractIdNumber
			, PrimaryAuthorizers.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea AS CharterSchoolAuthorizerPrimary
			, SecondaryAuthorizers.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea AS CharterSchoolAuthorizerAdditional
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears					ON Fact.SchoolYearId										= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT							ON SchoolYears.dimschoolyearid								= DMT.dimschoolyearid		
	LEFT JOIN   RDS.DimSeas                         SEAs						ON Fact.SeaId    											= SEAs.DimSeaId	
	LEFT JOIN	RDS.DimLeas							LEAs						ON Fact.LeaId												= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools						ON Fact.K12SchoolId											= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimCharterSchoolAuthorizers		PrimaryAuthorizers			ON Fact.AuthorizingBodyCharterSchoolAuthorizerId			= PrimaryAuthorizers.DimCharterSchoolAuthorizerId
	LEFT JOIN	RDS.DimCharterSchoolAuthorizers		SecondaryAuthorizers		ON Fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId	= SecondaryAuthorizers.DimCharterSchoolAuthorizerId

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	--AND SEAs.SeaOrganizationIdentifierSea = '789'
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND Schools.SchoolIdentifierSea = '456'
