USE [generate]
GO

/****** Object:  View [debug].[vwDirectorySCH_StagingTables]    Script Date: 2/10/2025 12:25:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE VIEW [debug].[vwDirectorySCH_StagingTables]
AS
SELECT
	K12Org.[SchoolYear],
	K12Org.[School_IsReportedFederally],
	K12Org.[LeaIdentifierSea],
	K12Org.[LeaIdentifierNCES],
	K12Org.[LeaOrganizationName],
	K12Org.[SchoolIdentifierSea],
	K12Org.SchoolOrganizationName,
	K12Org.[School_Type],
	K12Org.[School_WebSiteAddress],
	K12Org.[School_OperationalStatus],
	K12Org.[School_OperationalStatusEffectiveDate],
	K12Org.[School_RecordStartDateTime],
	K12Org.[School_RecordEndDateTime],
	K12Org.[PriorLeaIdentifierSea],
	K12Org.[PriorSchoolIdentifierSea],
	K12Org.[School_ReconstitutedStatus],
	K12Org.School_CharterContractIDNumber,
	K12Org.School_CharterPrimaryAuthorizer,
	K12Org.School_CharterSecondaryAuthorizer,
	K12Org.[School_SharedTimeIndicator],
	K12Org.[School_VirtualSchoolStatus],
	K12Org.[School_NationalSchoolLunchProgramStatus],
	OrgAdd1.AddressStreetNumberAndName AS MailingAddressStreetNumberAndName,
	OrgAdd1.AddressApartmentRoomOrSuiteNumber As MailingAddressApartmentRoomOrSuiteNumber,
	OrgAdd1.AddressCity As MailingAddressCity,
	OrgAdd1.AddressPostalCode As MailingAddressPostalCode,
	OrgAdd1.StateAbbreviation As MailingAddressStateAbbreviation,
	OrgAdd2.AddressStreetNumberAndName AS PhysicalAddressStreetNumberAndName,
	OrgAdd2.AddressApartmentRoomOrSuiteNumber As PhysicalAddressApartmentRoomOrSuiteNumber,
	OrgAdd2.AddressCity As PhysicalAddressCity,
	OrgAdd2.AddressPostalCode As PhysicalAddressPostalCode,
	OrgAdd2.StateAbbreviation As PhysicalAddressStateAbbreviation,
	OrgPh.[TelephoneNumber],
	--,[StateAnsiCode] -- NA Ge
	--,[OutOfStateIndicator] -- NA
	K12Org.School_TitleISchoolStatus
FROM [Staging].[K12Organization] K12Org
LEFT JOIN [Staging].[OrganizationAddress] OrgAdd1 ON  K12Org.[LeaIdentifierSea] = OrgAdd1.OrganizationIdentifier AND OrgAdd1.AddressTypeForOrganization = 'Physical_1' AND K12Org.[SchoolYear] = OrgAdd1.[SchoolYear]
LEFT JOIN [Staging].[OrganizationAddress] OrgAdd2 ON  K12Org.[LeaIdentifierSea] = OrgAdd2.OrganizationIdentifier AND OrgAdd2.AddressTypeForOrganization = 'Mailing_1'AND  K12Org.[SchoolYear] = OrgAdd2.[SchoolYear]
LEFT JOIN [Staging].[OrganizationPhone]  OrgPh ON K12Org.[LeaIdentifierSea] = OrgPh.OrganizationIdentifier AND  K12Org.[SchoolYear] = OrgPh.[SchoolYear]

--SELECT 
--	ReportCode
--	,K12SchoolId	
--	,SchoolYearId	
--	,SchoolYear
--	,School_ReportedFederally	
--	,StateAnsiCode	
--	,LeaIdentifierSea	
--	,LeaIdentifierNces	
--	,LeaOrganizationName	
--	,SchoolIdentifierSea	
--	,NameOfInstitution	
--	,SchoolTypeCode
--	,ReconstitutedStatus
--	,VIRTUALSCHSTATUS	
--	,NSLPSTATUS
--FROM [debug].[vwDirectorySCH_FactTable]
--WHERE ReportCode = 'c129'

GO


