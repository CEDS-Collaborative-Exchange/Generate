CREATE PROCEDURE Staging.[Staging-to-DimCharterSchoolAuthorizers]
 
AS   

BEGIN

	-- This is a general cleanup of any records that were erroneously added with NULL SchoolStateIdentifier
		delete from rds.dimcharterschoolauthorizers
		where SchoolStateIdentifier is null
	--------------------------------------------------------------------------------------------------------

	IF OBJECT_ID(N'tempdb..#CharterSchoolAuthorizers') IS NOT NULL DROP TABLE #CharterSchoolAuthorizers

	declare @StateCode varchar(2), @StateName varchar(50), @StateANSICode varchar(5), @SchoolYear int
	select @StateCode = (select StateAbbreviationCode from Staging.StateDetail)
	select @StateName = (select [Description] from dbo.RefState where Code = @StateCode)
	select @StateANSICode = (select Code from dbo.RefStateANSICode where [Description] = @StateName)
	select @SchoolYear = (select SchoolYear from Staging.StateDetail)


	CREATE TABLE #organizationTypes (
		  SchoolYear							SMALLINT
		, CharterSchoolAuthorizingOrganization		VARCHAR(50)
	)

	CREATE TABLE #organizationLocationTypes (
		  SchoolYear							SMALLINT
		, MailingAddressType					VARCHAR(20)
		, PhysicalAddressType					VARCHAR(20)
	)

	INSERT INTO #organizationTypes
	SELECT 
		  SchoolYear
		, InputCode
	FROM Staging.SourceSystemReferenceData 
	WHERE TableName = 'RefOrganizationType' 
	AND TableFilter = '001156' 
	AND OutputCode = 'CharterSchoolAuthorizingOrganization'

	INSERT INTO #organizationLocationTypes
	SELECT 
		  mail.SchoolYear
		, mail.InputCode
		, phys.InputCode
	FROM (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Mailing') mail
	JOIN (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Physical') phys
		ON mail.SchoolYear = phys.SchoolYear



	SELECT DISTINCT
		scsa.CharterSchoolAuthorizingOrganizaionOrganizationName
		scsa.CharterSchoolAuthorizingOrganizaionIdentifierSea
		@StateName			 										'StateAbbreviationDescription',
		@StateCode 													'StateAbbreviationCode',
		@StateANSICode 												'StateANSICode',
		scsa.CharterSchoolAuthorizingOrganizaionType
		refcsat.[Definition] 										'CharterSchoolAuthorizingOrganizationTypeDescription',
		ssrd.OutputCode				 								'CharterSchoolAuthorizingOrganizationTypeEdfactsCode',
		smam.AddressCity 											
		smam.AddressPostalCode 										
		smam.StateAbbreviation 										
		smam.AddressStreetNumberAndName				 				
		smam.AddressApartmentRoomOrSuiteNumber
		smap.AddressCity 										
		smap.AddressPostalCode			 						
		smap.StateAbbreviation 								
		smap.AddressStreetNumberAndName 					
		smap.AddressApartmentRoomOrSuiteNumber
		sop.TelephoneNumber				 				
		NULL 														'WebsiteAddress',
		0 															'OutOfStateIndicator',
		scsa.RecordStartDateTime,
		scsa.RecordEndDateTime,
		NULL 														'MailingAddressCountyAnsiCode',
		NULL 														'PhysicalAddressCountyAnsiCode,'
	INTO #CharterSchoolAuthorizers
	FROM Staging.CharterSchoolAuthorizer scsa
	JOIN Staging.SourceSystemReferenceData ssrd
		ON ssrd.TableName = 'RefCharterSchoolAuthorizerType'
		AND scsa.CharterSchoolAuthorizerType = ssrd.InputCode
		AND ssrd.SchoolYear = @SchoolYear
	CROSS JOIN Staging.StateDetail ssd
	JOIN #organizationTypes orgTypes
		ON orgTypes.SchoolYear = @SchoolYear
	JOIN #organizationLocationTypes locType
		ON locType.SchoolYear = @SchoolYear
	LEFT JOIN Staging.OrganizationAddress smam
		ON scsa.CharterSchoolAuthorizerIdentifierSea = smam.OrganizationIdentifier
		AND smam.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
		AND smam.AddressTypeForOrganization = locType.MailingAddressType
	LEFT JOIN Staging.OrganizationAddress smap
		ON scsa.CharterSchoolAuthorizerIdentifierSea = smap.OrganizationIdentifier
		AND smap.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
		AND smap.AddressTypeForOrganization = locType.PhysicalAddressType
	LEFT JOIN Staging.OrganizationPhone sop
		ON scsa.CharterSchoolAuthorizerIdentifierSea = sop.OrganizationIdentifier
		AND sop.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
	LEFT JOIN dbo.RefCharterSchoolAuthorizerType refcsat
		ON refcsat.Code = ssrd.OutputCode

-- MERGE INTO DimCharterSchoolAuthorizers
	BEGIN TRY
		MERGE rds.DimCharterSchoolAuthorizers AS trgt
		USING #CharterSchoolAuthorizers AS src
			ON trgt.CharterSchoolAuthorizingOrganizaionIdentifierSea = src.CharterSchoolAuthorizingOrganizaionIdentifierSea
			AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN UPDATE
			SET trgt.CharterSchoolAuthorizingOrganizationName 				= src.CharterSchoolAuthorizingOrganizationName,							
				trgt.StateAbbreviationCode 									= src.StateAbbreviationCode,
				trgt.StateANSICode 											= src.StateANSICode,
				trgt.StateAbbreviationDescription 							= src.StateAbbreviationDescription,
				trgt.CharterSchoolAuthorizingOrganizationTypeCode 			= src.CharterSchoolAuthorizingOrganizationTypeCode,
				trgt.CharterSchoolAuthorizingOrganizationTypeDescription 	= src.CharterSchoolAuthorizingOrganizationTypeDescription,
				trgt.CharterSchoolAuthorizingOrganizationTypeEdFactsCode	= src.CharterSchoolAuthorizingOrganizationTypeEdFactsCode,						
				trgt.MailingAddressStreetNumberAndName						= src.MailingAddressStreetNumberAndName,
				trgt.MailingAddressApartmentRoomOrSuiteNumber				= src.MailingAddressApartmentRoomOrSuiteNumber,
				trgt.MailingAddressCity 									= src.MailingAddressCity,
				trgt.MailingAddressState 									= src.MailingAddressState,
				trgt.MailingAddressPostalCode 								= src.MailingAddressPostalCode,
				trgt.MailingAddressCountyAnsiCode 							= src.MailingAddressCountyAnsiCode,
				trgt.OutOfStateIndicator 									= src.OutOfStateIndicator,
				trgt.PhysicalAddressStreetNumberAndName						= src.PhysicalAddressStreetNumberAndName,
				trgt.PhysicalAddressApartmentRoomOrSuiteNumber				= src.PhysicalAddressApartmentRoomOrSuiteNumber,
				trgt.PhysicalAddressCity 									= src.PhysicalAddressCity,
				trgt.PhysicalAddressState 									= src.PhysicalAddressState,
				trgt.PhysicalAddressPostalCode								= src.PhysicalAddressPostalCode,
				trgt.PhysicalAddressCountyAnsiCode 							= src.PhysicalAddressCountyAnsiCode,
				trgt.TelephoneNumber										= src.TelephoneNumber,
				trgt.WebsiteAddress											= src.WebsiteAddress,
				trgt.RecordEndDateTime 										= src.RecordEndDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT (
			CharterSchoolAuthorizingOrganizationName
			, CharterSchoolAuthorizingOrganizaionIdentifierSea
			, StateAbbreviationCode
			, StateANSICode
			, StateAbbreviationDescription
			, CharterSchoolAuthorizingOrganizationTypeCode
			, CharterSchoolAuthorizingOrganizationTypeDescription
			, CharterSchoolAuthorizingOrganizationTypeEdFactsCode
			, MailingAddressStreetNumberAndName
			, MailingAddressApartmentRoomOrSuiteNumber
			, MailingAddressCity
			, MailingAddressStateAbbreviation
			, MailingAddressPostalCode
			, MailingAddressCountyAnsiCode
			, OutOfStateIndicator
			, PhysicalAddressStreetNumberAndName
			, PhysicalAddressApartmentRoomOrSuiteNumber
			, PhysicalAddressCity
			, PhysicalAddressStateAbbreviation
			, PhysicalAddressPostalCode
			, PhysicalAddressCountyAnsiCode
			, TelephoneNumber
			, WebsiteAddress
			, RecordStartDateTime
			, RecordEndDateTime
		)
		VALUES (
			src.CharterSchoolAuthorizingOrganizationName
			,src.CharterSchoolAuthorizingOrganizaionIdentifierSea
			, StateAbbreviationCode
			, StateANSICode
			, StateAbbreviationDescription
			, src.CharterSchoolAuthorizingOrganizationTypeCode
			, src.CharterSchoolAuthorizingOrganizationTypeDescription
			, src.CharterSchoolAuthorizingOrganizationTypeEdFactsCode
			, src.MailingAddressStreetNumberAndName
			, src.MailingAddressApartmentRoomOrSuiteNumber
			, src.MailingAddressCity
			, src.MailingAddressStateAbbreviation
			, src.MailingAddressPostalCode
			, src.MailingAddressCountyAnsiCode
			, src.OutOfStateIndicator
			, src.PhysicalAddressStreetNumberAndName
			, src.PhysicalAddressApartmentRoomOrSuiteNumber
			, src.PhysicalAddressCity
			, src.PhysicalAddressStateAbbreviation
			, src.PhysicalAddressPostalCode
			, src.PhysicalAddressCountyAnsiCode
			, src.TelephoneNumber
			, src.WebsiteAddress
			, src.RecordStartDateTime
			, src.RecordEndDateTime
		);

		;WITH upd AS(
			SELECT 
				startd.CharterSchoolAuthorizingOrganizaionIdentifierSea
				, startd.RecordStartDateTime
				, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime 
			FROM rds.DimCharterSchoolAuthorizers startd
			JOIN rds.DimCharterSchoolAuthorizers endd
				ON startd.CharterSchoolAuthorizingOrganizaionIdentifierSea = endd.CharterSchoolAuthorizingOrganizaionIdentifierSea
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY startd.CharterSchoolAuthorizingOrganizaionIdentifierSea, startd.RecordStartDateTime
		) 

		UPDATE charter SET RecordEndDateTime = upd.RecordEndDateTime 
		FROM rds.DimCharterSchoolAuthorizers charter
		JOIN upd	
			ON charter.CharterSchoolAuthorizingOrganizaionIdentifierSea = upd.CharterSchoolAuthorizingOrganizaionIdentifierSea
			AND charter.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
	END TRY
	BEGIN CATCH
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), 2, 'RDS.DimCharterSchoolAuthorizers - Error Occurred - ' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))

	END CATCH
	

END