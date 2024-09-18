CREATE PROCEDURE Staging.[Staging-to-DimCharterSchoolAuthorizers]
 
AS   

BEGIN

	-- This is a general cleanup of any records that were erroneously added with NULL SchoolStateIdentifier
		delete from rds.dimcharterschoolauthorizers
		where SchoolStateIdentifier is null
	--------------------------------------------------------------------------------------------------------

	IF OBJECT_ID(N'tempdb..#CharterSchoolAuthorizers') IS NOT NULL DROP TABLE #CharterSchoolAuthorizers

	declare @StateCode varchar(2), @StateName varchar(50), @StateANSICode varchar(5), @SchoolYear int
	select @StateCode = (select StateCode from Staging.StateDetail)
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



	select distinct
		scsa.CharterSchoolAuthorizer_Name 'Name', 
		scsa.CharterSchoolAuthorizer_Identifier_State 'StateIdentifier',
		@StateName 'State',
		@StateCode 'StateCode',
		@StateANSICode 'StateANSICode',
		scsa.CharterSchoolAuthorizerType 'CharterSchoolAuthorizerTypeCode',
		refcsat.[Definition] 'CharterSchoolAuthorizerTypeDescription',
		ssrd.OutputCode 'CharterSchoolAuthorizerTypeEdfactsCode',
		smam.AddressCity 'MailingAddressCity',
		smam.AddressPostalCode 'MailingAddressPostalCode',
		smam.StateAbbreviation 'MailingAddressState',
		smam.AddressStreetNumberAndName 'MailingAddressStreet',
		smap.AddressCity 'PhysicalAddressCity',
		smap.AddressPostalCode 'PhysicalAddressPostalCode',
		smap.StateAbbreviation 'PhysicalAddressState',
		smap.AddressStreetNumberAndName 'PhysicalAddressStreet',
		sop.TelephoneNumber 'Telephone',
		NULL 'Website',
		1 'OutOfStateIndicator',
		scsa.RecordStartDateTime,
		scsa.RecordEndDateTime,
		sk12o.School_Identifier_State 'SchoolStateIdentifier',
		NULL 'MailingCountyAnsiCode',
		NULL 'PhysicalCountyAnsiCode,'
	into #CharterSchoolAuthorizers
	from Staging.CharterSchoolAuthorizer scsa
	inner join Staging.K12Organization sk12o
		on isnull(sk12o.School_CharterPrimaryAuthorizer,'') = scsa.CharterSchoolAuthorizer_Identifier_State
		or isnull(School_CharterSecondaryAuthorizer,'') = scsa.CharterSchoolAuthorizer_Identifier_State
	inner join Staging.SourceSystemReferenceData ssrd
		on ssrd.TableName = 'RefCharterSchoolAuthorizerType'
		and scsa.CharterSchoolAuthorizerType = ssrd.InputCode
		and ssrd.SchoolYear = @SchoolYear
	CROSS JOIN Staging.StateDetail ssd
	JOIN #organizationTypes orgTypes
		ON orgTypes.SchoolYear = @SchoolYear
	JOIN #organizationLocationTypes locType
		ON locType.SchoolYear = @SchoolYear
	LEFT JOIN Staging.OrganizationAddress smam
		ON scsa.CharterSchoolAuthorizer_Identifier_State = smam.OrganizationIdentifier
		AND smam.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
		AND smam.AddressTypeForOrganization = locType.MailingAddressType
	LEFT JOIN Staging.OrganizationAddress smap
		ON scsa.CharterSchoolAuthorizer_Identifier_State = smap.OrganizationIdentifier
		AND smap.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
		AND smap.AddressTypeForOrganization = locType.PhysicalAddressType
	LEFT JOIN Staging.OrganizationPhone sop
		ON scsa.CharterSchoolAuthorizer_Identifier_State = sop.OrganizationIdentifier
		AND sop.OrganizationType = orgTypes.CharterSchoolAuthorizingOrganization
	left join dbo.RefCharterSchoolAuthorizerType refcsat
		on refcsat.Code = ssrd.OutputCode

-- MERGE INTO DimCharterSchoolAuthorizers
	BEGIN TRY
		MERGE rds.DimCharterSchoolAuthorizers AS trgt
		USING #CharterSchoolAuthorizers AS src
				ON trgt.StateIdentifier = src.StateIdentifier
				and trgt.SchoolStateIdentifier = src.SchoolStateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
			Update SET trgt.Name = src.Name,							
						trgt.StateCode = src.StateCode,
						trgt.StateANSICode = src.StateANSICode,
						trgt.[State] = src.[State],												
						trgt.CharterSchoolAuthorizerTypeCode = src.CharterSchoolAuthorizerTypeCode,
						trgt.CharterSchoolAuthorizerTypeDescription = src.CharterSchoolAuthorizerTypeDescription,
						trgt.CharterSchoolAuthorizerTypeEdFactsCode = src.CharterSchoolAuthorizerTypeEdFactsCode,						
						trgt.MailingAddressStreet = src.MailingAddressStreet,
						trgt.MailingAddressCity = src.MailingAddressCity,
						trgt.MailingAddressState = src.MailingAddressState,
						trgt.MailingAddressPostalCode = src.MailingAddressPostalCode,
						trgt.OutOfStateIndicator = src.OutOfStateIndicator,
						trgt.PhysicalAddressStreet = src.PhysicalAddressStreet,
						trgt.PhysicalAddressCity = src.PhysicalAddressCity,
						trgt.PhysicalAddressState = src.PhysicalAddressState,
						trgt.PhysicalAddressPostalCode = src.PhysicalAddressPostalCode,
						trgt.Telephone = src.Telephone,
						trgt.Website = src.Website,
						trgt.SchoolStateIdentifier = src.SchoolStateIdentifier,
						trgt.RecordEndDateTime = src.RecordEndDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT([Name],StateIdentifier,StateCode,StateANSICode,[State],
				CharterSchoolAuthorizerTypeCode,CharterSchoolAuthorizerTypeDescription,CharterSchoolAuthorizerTypeEdFactsCode,MailingAddressStreet,
				MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
				OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,
				PhysicalAddressPostalCode,Telephone,Website, SchoolStateIdentifier,
				RecordStartDateTime,RecordEndDateTime)
		VALUES(src.[Name],src.StateIdentifier, StateCode, StateANSICode, [State],
				src.CharterSchoolAuthorizerTypeCode,src.CharterSchoolAuthorizerTypeDescription,src.CharterSchoolAuthorizerTypeEdFactsCode,
				src.MailingAddressStreet,src.MailingAddressCity,src.MailingAddressState,src.MailingAddressPostalCode,src.OutOfStateIndicator,
				src.PhysicalAddressStreet,src.PhysicalAddressStreet,src.PhysicalAddressState,src.PhysicalAddressPostalCode,
				src.Telephone,src.Website,src.SchoolStateIdentifier,
				src.RecordStartDateTime,src.RecordEndDateTime);

		;WITH upd AS(
			SELECT 
				startd.StateIdentifier
				, startd.RecordStartDateTime
				, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime 
			FROM rds.DimCharterSchoolAuthorizers startd
			JOIN rds.DimCharterSchoolAuthorizers endd
				ON startd.StateIdentifier = endd.StateIdentifier
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY startd.StateIdentifier, startd.RecordStartDateTime
		) 

		UPDATE charter SET RecordEndDateTime = upd.RecordEndDateTime 
		FROM rds.DimCharterSchoolAuthorizers charter
		JOIN upd	
			ON charter.StateIdentifier = upd.StateIdentifier
			AND charter.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
	END TRY
	BEGIN CATCH
		INSERT INTO app.DataMigrationHistories(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
		VALUES	(getutcdate(), 2, 'RDS.DimCharterSchoolAuthorizers - Error Occurred - ' + CAST(ERROR_MESSAGE() AS VARCHAR(900)))

	END CATCH
	

END