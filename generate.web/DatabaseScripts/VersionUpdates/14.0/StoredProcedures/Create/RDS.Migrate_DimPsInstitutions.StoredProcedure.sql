CREATE PROC [RDS].[Migrate_DimPsInstitutions]
	@factTypeCode AS VARCHAR(50) = 'directory',
	@dataCollectionName AS VARCHAR(50) = NULL
AS
BEGIN


	DECLARE @organizationElementTypeId AS INT
	SELECT @organizationElementTypeId = RefOrganizationElementTypeId
	FROM dbo.RefOrganizationElementType 
	WHERE [Code] = '001156'

	DECLARE @PsInstitutionOrgTypeId AS INT
	SELECT @PsInstitutionOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'PostsecondaryInstitution') AND RefOrganizationElementTypeId = @organizationElementTypeId;



		SELECT
			  OrganizationId
			, RecordStartDateTime
			, ROW_NUMBER() OVER(PARTITION BY OrganizationId ORDER BY RecordStartDateTime, RecordEndDateTime) AS SequenceNumber 
		INTO #DATECTE
		FROM (
				SELECT DISTINCT 
					  OrganizationId
					, RecordStartDateTime
					, RecordEndDateTime
				FROM dbo.OrganizationDetail
				WHERE RecordStartDateTime IS NOT NULL

				UNION

				SELECT DISTINCT 
					  OrganizationId
					, RecordStartDateTime
					, RecordEndDateTime
				FROM dbo.OrganizationWebsite
				WHERE RecordStartDateTime IS NOT NULL

				UNION

				SELECT DISTINCT 
					  OrganizationId
					, RecordStartDateTime
					, RecordEndDateTime
				FROM dbo.OrganizationIdentifier
				WHERE RecordStartDateTime IS NOT NULL

				UNION

				SELECT DISTINCT 
					  OrganizationId
					, RecordStartDateTime
					, RecordEndDateTime
				FROM dbo.OrganizationOperationalStatus
				WHERE RecordStartDateTime IS NOT NULL
			) dates

		SELECT 
			  o.Name AS NameOfInstitution
			, o.ShortName AS ShortNameOfInstitution
			, oi.Identifier AS InstitutionIpedsUnitId -- can be a block
			, os.Code AS OrganizationOperationalStatus
			, orgstat.OperationalStatusEffectiveDate AS OperationalStatusEffectiveDate
			, mpli.Code as MostPrevalentLevelOfInstitutionCode
			, mla.StreetNumberAndName AS MailingStreet
			, mla.City AS MailingCity
			, mrefState.Code AS MailingState
			, mla.PostalCode AS MailingPostalCode
			, pla.StreetNumberAndName
			, pla.City
			, prefState.Code
			, pla.PostalCode
			, prefState.Code AS [State]
			, pla.Latitude
			, pla.Longitude
			, phone.TelephoneNumber
			, website.Website
			, startDate.RecordStartDateTime AS RecordStartDateTime
			, dateadd(DAY,-1,endDate.RecordStartDateTime) AS RecordEndDateTime 
		INTO #CTE
		FROM #DATECTE startDate
		LEFT JOIN #DATECTE endDate
			ON startDate.OrganizationId = endDate.OrganizationId
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.OrganizationDetail o 								
			ON o.OrganizationId = startDate.Organizationid
			AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		JOIN dbo.PsInstitution pin
			ON o.OrganizationId = pin.OrganizationId
			AND startDate.RecordStartDateTime BETWEEN pin.RecordStartDateTime AND ISNULL(pin.RecordEndDateTime, GETDATE())
		LEFT JOIN dbo.RefMostPrevalentLevelOfInstitution mpli
			ON pin.RefMostPrevalentLevelOfInstitutionId = mpli.RefMostPrevalentLevelOfInstitutionId
		JOIN dbo.OrganizationIdentifier oi 
			ON o.OrganizationId = oi.OrganizationId 
			AND oi.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('000166')
			--AND oi.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('Federal', '000111')
			AND startDate.RecordStartDateTime BETWEEN oi.RecordStartDateTime AND ISNULL(oi.RecordEndDateTime, GETDATE())
		JOIN dbo.RefOrganizationType t 
			ON o.RefOrganizationTypeId = t.RefOrganizationTypeId											
		LEFT JOIN dbo.OrganizationOperationalStatus orgstat
			ON o.OrganizationId = orgstat.OrganizationId
			AND startDate.RecordStartDateTime BETWEEN orgstat.RecordStartDateTime AND ISNULL(orgstat.RecordEndDateTime, GETDATE())
		LEFT JOIN dbo.RefOperationalStatus os
			ON orgstat.RefOperationalStatusId = os.RefOperationalStatusId
		LEFT JOIN dbo.RefOperationalStatusType ost
			ON os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId
			AND ost.Code = '001418' -- Statuses for PS institutions
		LEFT JOIN dbo.OrganizationWebsite website 
			ON o.OrganizationId = website.OrganizationId
			AND startDate.RecordStartDateTime BETWEEN website.RecordStartDateTime AND ISNULL(website.RecordEndDateTime, GETDATE())
		LEFT JOIN dbo.OrganizationTelephone phone 
			ON o.OrganizationId = phone.OrganizationId
		LEFT JOIN dbo.OrganizationLocation mol
			ON o.OrganizationId = mol.OrganizationId
			AND mol.RefOrganizationLocationTypeId = 1 -- Mailing
		LEFT JOIN dbo.LocationAddress mla 
			ON mol.LocationId = mla.LocationId
			AND startDate.RecordStartDateTime BETWEEN mla.RecordStartDateTime AND ISNULL(mla.RecordEndDateTime, GETDATE()) 
		LEFT JOIN dbo.RefState mrefState 
			ON mrefState.RefStateId = mla.RefStateId
		LEFT JOIN dbo.OrganizationLocation pol
			ON o.OrganizationId = pol.OrganizationId
			AND pol.RefOrganizationLocationTypeId = 2 -- Physical
		LEFT JOIN dbo.LocationAddress pla 
			ON pol.LocationId = pla.LocationId
			AND startDate.RecordStartDateTime BETWEEN pla.RecordStartDateTime AND ISNULL(pla.RecordEndDateTime, GETDATE()) 
		LEFT JOIN dbo.RefState prefState 
			ON prefState.RefStateId = pla.RefStateId
		WHERE o.RefOrganizationTypeId = @PsInstitutionOrgTypeId

	--)
	MERGE rds.DimPsInstitutions as trgt
	USING #CTE as src
			ON trgt.InstitutionIpedsUnitId = src.InstitutionIpedsUnitId
			AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')			
	WHEN MATCHED THEN 
			UPDATE SET 
				  trgt.NameOfInstitution = src.NameOfInstitution
				, trgt.ShortNameOfInstitution = ISNULL(src.ShortNameOfInstitution,'MISSING')
				, trgt.InstitutionIpedsUnitId = src.InstitutionIpedsUnitId
				, trgt.OrganizationOperationalStatus = ISNULL(src.OrganizationOperationalStatus,'MISSING')
				, trgt.OperationalStatusEffectiveDate = ISNULL(src.OperationalStatusEffectiveDate,'1/1/1900')
				, trgt.MostPrevalentLevelOfInstitutionCode = src.MostPrevalentLevelOfInstitutionCode
				, trgt.MailingAddressStreetNameAndNumber = src.MailingStreet
				, trgt.MailingAddressCity = src.MailingCity
				, trgt.MailingAddressState = src.MailingState
				, trgt.MailingAddressPostalCode = src.MailingPostalCode
				, trgt.PhysicalAddressStreetNameAndNumber = src.StreetNumberAndName
				, trgt.PhysicalAddressCity = src.City
				, trgt.PhysicalAddressState = src.[State]
				, trgt.PhysicalAddressPostalCode = src.PostalCode
				, trgt.Latitude = src.Latitude
				, trgt.Longitude = src.Longitude
				, trgt.Telephone = src.TelephoneNumber
				, trgt.Website = src.Website
				, trgt.RecordEndDateTime = src.RecordEndDateTime
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
	INSERT (
		  NameOfInstitution 
		, ShortNameOfInstitution 
		, InstitutionIpedsUnitId 
		, OrganizationOperationalStatus 
		, OperationalStatusEffectiveDate
		, MostPrevalentLevelOfInstitutionCode
		, MailingAddressStreetNameAndNumber
		, MailingAddressCity
		, MailingAddressState
		, MailingAddressPostalCode
		, PhysicalAddressStreetNameAndNumber
		, PhysicalAddressCity
		, PhysicalAddressState
		, PhysicalAddressPostalCode
		, Latitude
		, Longitude
		, Telephone
		, Website
		, RecordStartDateTime
		, RecordEndDateTime
		)
	VALUES (
		  src.NameOfInstitution
		, ISNULL(src.ShortNameOfInstitution,'MISSING')
		, src.InstitutionIpedsUnitId
		, ISNULL(src.OrganizationOperationalStatus,'MISSING')
		, ISNULL(src.OperationalStatusEffectiveDate,'1/1/1900')
		, src.MostPrevalentLevelOfInstitutionCode
		, src.MailingStreet
		, src.MailingCity
		, src.MailingState
		, src.MailingPostalCode
		, src.StreetNumberAndName
		, src.City
		, src.[State]
		, src.PostalCode
		, src.Latitude
		, src.Longitude
		, src.TelephoneNumber
		, src.Website
		, src.RecordStartDateTime
		, src.RecordEndDateTime		
		);

	;WITH upd AS(
		SELECT 
				DimPsInstitutionId
			, InstitutionIpedsUnitId
			, RecordStartDateTime
			, LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY InstitutionIpedsUnitId ORDER BY RecordStartDateTime ASC) AS endDate 
		FROM rds.DimPsInstitutions
		WHERE RecordEndDateTime is null
	) 
	UPDATE psi
	SET RecordEndDateTime = datediff(DAY,-1,upd.endDate)
	FROM rds.DimPsInstitutions psi
	JOIN upd	
		ON psi.DimPsInstitutionId = upd.DimPsInstitutionId
	WHERE upd.endDate <> '1900-01-01 00:00:00.000'

	DROP TABLE #DATECTE
	DROP TABLE #CTE
END