USE [generate]
GO

/****** Object:  View [debug].[vwDirectorySCH_FactTable]    Script Date: 2/10/2025 12:22:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE VIEW [debug].[vwDirectorySCH_FactTable] 
AS
SELECT	
			  Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, Fact.K12SchoolId
			, CASE Schools.ReportedFederally
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			ELSE 'MISSING' END AS School_ReportedFederally					
			, Schools.StateAnsiCode
			, Schools.LeaIdentifierSea
			, Schools.LeaIdentifierNces
			, Schools.LeaOrganizationName
			, Schools.SchoolIdentifierSea
			, Schools.NameOfInstitution
			, Schools.SchoolTypeCode
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
			, Schools.SchoolOperationalStatus
			, Schools.SchoolOperationalStatusEffectiveDate
			, Schools.RecordStartDateTime
			, Schools.RecordEndDateTime
			, Schools.PriorLeaIdentifierSea
			, Schools.PriorSchoolIdentifierSea
			, Schools.ReconstitutedStatus
			, Schools.CharterSchoolContractIdNumber
			, PrimaryAuthorizers.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea AS CharterSchoolAuthorizerPrimary
			, SecondaryAuthorizers.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea AS CharterSchoolAuthorizerSecondary
			, OrgCounts.VIRTUALSCHSTATUS
			--, OrgCounts.ReconstitutedStatus
			, OrgCounts.NSLPSTATUS
			--, OrgCounts.ReportCode
			, Stucnts.TITLEISCHOOLSTATUS


 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears					ON Fact.SchoolYearId										= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT							ON SchoolYears.DimSchoolYearId								= DMT.DimSchoolYearId		
	LEFT JOIN	RDS.DimK12Schools					Schools						ON Fact.K12SchoolId											= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimCharterSchoolAuthorizers		PrimaryAuthorizers			ON Fact.AuthorizingBodyCharterSchoolAuthorizerId			= PrimaryAuthorizers.DimCharterSchoolAuthorizerId
	LEFT JOIN	RDS.DimCharterSchoolAuthorizers		SecondaryAuthorizers		ON Fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId	= SecondaryAuthorizers.DimCharterSchoolAuthorizerId
	LEFT JOIN	RDS.ReportEdFactsOrganizationCounts OrgCounts					ON Fact.K12SchoolId = OrgCounts.ReportEDFactsOrganizationCountId
	LEFT JOIN	RDS.ReportEDFactsK12StudentCounts   Stucnts						ON Schools.SchoolIdentifierSea = Stucnts.OrganizationIdentifierSea
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
	--AND Schools.SchoolIdentifierSea = '010456'
	--AND Schools.SchoolOperationalStatus = 'Open'      --'Open', 'Closed', 'New', 'FutureSchool'
	--AND Schools.SchoolTypeCode = 'Regular' 			--'CareerAndTechnical', 'Alternative', 'Special', 'Reportable', 'Regular'
GO


