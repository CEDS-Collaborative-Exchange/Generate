CREATE VIEW [Debug].[vwDirectorySCH_FactTable] 
AS
SELECT	
			  Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Fact.K12SchoolId
			, Schools.ReportedFederally							
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
			, SecondaryAuthorizers.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea AS CharterSchoolAuthorizerSecondary
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears					ON Fact.SchoolYearId										= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT							ON SchoolYears.DimSchoolYearId								= DMT.DimSchoolYearId		
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
	AND Fact.K12SchoolId > -1	
	--AND Schools.SchoolIdentifierSea = '456'
	--AND Schools.SchoolOperationalStatusEdFactsCode IN (1,2,7)
