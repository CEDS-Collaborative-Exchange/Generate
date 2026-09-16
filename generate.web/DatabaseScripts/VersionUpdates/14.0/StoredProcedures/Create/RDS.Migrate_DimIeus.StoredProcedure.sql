CREATE PROCEDURE [RDS].[Migrate_DimIeus]
	@factTypeCode AS VARCHAR(50) = 'directory',
	@dataCollectionName AS VARCHAR(50) = NULL,
	@runAsTest AS BIT 
AS 
BEGIN
	DECLARE @dataCollectionId AS INT

	SELECT @dataCollectionId = DataCollectionId 
	FROM dbo.DataCollection
	WHERE DataCollectionName = @dataCollectionName

	DECLARE @migrationType AS VARCHAR(50)
	DECLARE @dataMigrationTypeId AS INT
	
	SELECT @dataMigrationTypeId = DimDataMigrationTypeId
	FROM App.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
	SET @migrationType='rds'

	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode

	DECLARE @organizationElementTypeId AS INT
	SELECT @organizationElementTypeId = RefOrganizationElementTypeId
	FROM dbo.RefOrganizationElementType 
	WHERE [Code] = '001156'

	DECLARE @seaOrgTypeId AS INT
	SELECT @seaOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE [Code] = 'SEA' AND RefOrganizationElementTypeId = @organizationElementTypeId

	DECLARE @ieuOrgTypeId AS INT
	SELECT @ieuOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'IEU') AND RefOrganizationElementTypeId = @organizationElementTypeId

	DECLARE @seaIdentifierTypeId AS INT	
	SELECT @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
	FROM dbo.RefOrganizationIdentifierType
	WHERE [Code] = '001491'

	DECLARE @seaFederalIdentificationSystemId AS INT
	SELECT @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'Federal'
	AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

	DECLARE @ieuSEAIdentificationSystemId AS INT
	SELECT @ieuSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'IEU'

	-- SEA
	DECLARE @seaOrganizationId AS INT
		
	SELECT @seaOrganizationId = OrganizationId
	FROM dbo.OrganizationDetail
	WHERE RefOrganizationTypeId = @seaOrgTypeId

	DECLARE @seaName AS VARCHAR(100)

	SELECT @seaName = Name
	FROM dbo.OrganizationDetail
	WHERE RefOrganizationTypeId = @seaOrgTypeId
	AND RecordEndDateTime IS NULL

	-- State
	DECLARE @seaIdentifier AS VARCHAR(50)

	SELECT @seaIdentifier = Identifier
	FROM dbo.OrganizationIdentifier 
	WHERE OrganizationId = @seaOrganizationId
	AND RefOrganizationIdentificationSystemId = @seaFederalIdentificationSystemId
	AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

	DECLARE @stateName AS VARCHAR(100)
	SELECT @stateName = [Description]
	FROM dbo.RefStateAnsicode
	WHERE [Code] = @seaIdentifier

	DECLARE @stateCode AS VARCHAR(5), @stateDescription AS VARCHAR(1000)
	SELECT @stateCode = [Code], @stateDescription = [Description]
	FROM dbo.RefState
	WHERE [Description] = @stateName


	IF NOT EXISTS (SELECT 1 FROM RDS.DimIeus WHERE DimIeuId = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimIeus on
		INSERT INTO RDS.DimIeus (DimIeuId, OutOfStateIndicator, RecordStartDateTime) VALUES (-1, 0, '1900-01-01')
		SET IDENTITY_INSERT RDS.DimIeus off
	END

	SELECT 
		  ol.OrganizationId
		, StreetNumberAndName
		, City
		, refState.Code AS StateCode
		, PostalCode
		, rc.Code as CountyCode
		, la.RecordStartDateTime
		, la.RecordEndDateTime
	INTO #mailingAddress
	FROM dbo.OrganizationLocation ol
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId	
	LEFT JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 1 -- mailing
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)
		
	CREATE INDEX AddressByOrg ON #mailingAddress (OrganizationId)
		
	SELECT 
		  ol.OrganizationId
		, StreetNumberAndName
		, City
		, refState.Code AS StateCode
		, PostalCode
		, rc.Code as CountyCode
		, la.Longitude
		, la.Latitude
		, la.RecordStartDateTime
		, la.RecordEndDateTime
	INTO #physicalAddress
	FROM dbo.OrganizationLocation ol
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId
	LEFT JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 2 -- Physical
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	

	CREATE INDEX AddressByOrg ON #physicalAddress (OrganizationId)

	SELECT DISTINCT
          OrganizationId
        , RecordStartDateTime
        , ROW_NUMBER() OVER(PARTITION BY OrganizationId ORDER BY RecordStartDateTime) AS SequenceNumber
	INTO #DATECTE
    FROM (
            SELECT DISTINCT 
                    OrganizationId
                    , RecordStartDateTime
            FROM dbo.OrganizationDetail
            WHERE RecordStartDateTime IS NOT NULL

            UNION

            SELECT DISTINCT 
                    OrganizationId
                    , RecordStartDateTime
            FROM dbo.OrganizationIdentifier
            WHERE RecordStartDateTime IS NOT NULL

            UNION

            SELECT DISTINCT 
                    OrganizationId
                    , OperationalStatusEffectiveDate as RecordStartDateTime
            FROM dbo.OrganizationOperationalStatus
            WHERE OperationalStatusEffectiveDate IS NOT NULL 

			UNION 
	
			SELECT DISTINCT 
                      OrganizationId
                    , RecordStartDateTime
            FROM #mailingAddress
            WHERE RecordStartDateTime IS NOT NULL

			UNION 

			SELECT DISTINCT 
                      OrganizationId
                    , RecordStartDateTime
            FROM #physicalAddress
            WHERE RecordStartDateTime IS NOT NULL

    ) dates

	CREATE INDEX DatesByOrg ON #DATECTE (OrganizationId)


	-- DimIeu Merge	
	;WITH CTE as 
	( 
		SELECT  DISTINCT
				@SeaName as SeaName
			, @stateCode AS StateANSICode
			, @stateName AS StateName
			, @seaIdentifier as SeaStateIdentifier
			, i.Identifier as IeuIdentifierState
			, o.Name as IeuName
			, mailingAddress.StreetNumberAndName as MailingStreet
			, mailingAddress.City as MailingCity
			, mailingAddress.StateCode as MailingState
			, mailingAddress.PostalCode as MailingPostalCode
			, mailingAddress.CountyCode as MailingCountyAnsiCode
			, case when physicalAddress.StateCode <> @stateCode or mailingAddress.StateCode <> @stateCode then 1 else 0 end as OutOfStateIndicator
			, physicalAddress.StreetNumberAndName
			, physicalAddress.City
			, physicalAddress.StateCode
			, physicalAddress.PostalCode
			, physicalAddress.CountyCode as PhysicalCountyAnsiCode
			, phone.TelephoneNumber
			, website.Website
			, physicalAddress.Longitude
			, physicalAddress.Latitude
			, IIF(o.RecordStartDateTime > i.RecordStartDateTime, o.RecordStartDateTime,  i.RecordStartDateTime) as RecordStartDateTime
			, IIF(o.RecordEndDateTime > i.RecordEndDateTime, o.RecordEndDateTime,  i.RecordEndDateTime) as RecordEndDateTime
		FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate 
			ON startDate.OrganizationId = endDate.OrganizationId 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.OrganizationDetail o
			ON o.OrganizationId = startDate.Organizationid
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		JOIN dbo.OrganizationIdentifier i 
			ON o.OrganizationId = i.OrganizationId 
		JOIN dbo.RefOrganizationType t 
			ON o.RefOrganizationTypeId = t.RefOrganizationTypeId											
		LEFT JOIN dbo.OrganizationOperationalStatus orgstat
			ON o.OrganizationId = orgstat.OrganizationId
		LEFT JOIN dbo.RefStateANSICode rsCode 
			ON rsCode.Code = i.Identifier
		LEFT JOIN dbo.RefState s 
			ON s.Description = rsCode.StateName	
		LEFT JOIN dbo.OrganizationWebsite website 
			ON o.OrganizationId = website.OrganizationId
		LEFT JOIN dbo.OrganizationTelephone phone 
			ON o.OrganizationId = phone.OrganizationId
		LEFT JOIN #mailingAddress mailingAddress
			ON o.OrganizationId = mailingAddress.OrganizationId
            AND startDate.RecordStartDateTime BETWEEN mailingAddress.RecordStartDateTime AND ISNULL(mailingAddress.RecordEndDateTime, GETDATE())
		LEFT JOIN #physicalAddress physicalAddress
			ON o.OrganizationId = physicalAddress.OrganizationId
            AND startDate.RecordStartDateTime BETWEEN physicalAddress.RecordStartDateTime AND ISNULL(physicalAddress.RecordEndDateTime, GETDATE())
		WHERE o.RefOrganizationTypeId = @IeuOrgTypeId
	)
	MERGE rds.DimIeus as trgt
	USING CTE as src
			on trgt.IeuIdentifierState = src.IeuIdentifierState
			AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN 
			UPDATE SET 
					trgt.IeuName = src.IeuName
				, trgt.IeuIdentifierState = src.IeuIdentifierState
				, trgt.SeaName = src.SeaName
				, trgt.StateANSICode = src.StateAnsiCode
				, trgt.StateCode = src.StateCode
				, trgt.StateName = src.StateName
				, trgt.SeaStateIdentifier = src.SeaStateIdentifier
				, trgt.MailingAddressStreet = src.MailingStreet
				, trgt.MailingAddressCity = src.MailingCity
				, trgt.MailingCountyAnsiCode = src.MailingCountyAnsiCode
				, trgt.MailingAddressState = src.MailingState
				, trgt.MailingAddressPostalCode = src.MailingPostalCode
				, trgt.OrganizationOperationalStatus = trgt.OrganizationOperationalStatus
				, trgt.PhysicalAddressStreet = src.StreetNumberAndName
				, trgt.PhysicalAddressCity = src.City
				, trgt.PhysicalCountyAnsiCode = src.PhysicalCountyAnsiCode
				, trgt.PhysicalAddressState = src.StateCode
				, trgt.PhysicalAddressPostalCode = src.PostalCode
				, trgt.Longitude = src.Longitude
				, trgt.Latitude = src.Latitude
				, trgt.OutOfStateIndicator = ISNULL(src.OutOfStateIndicator, 0)
				, trgt.Telephone = src.TelephoneNumber
				, trgt.Website = src.Website
				, trgt.RecordEndDateTime = src.RecordEndDateTime
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
	INSERT (
			IeuName
		, IeuIdentifierState
		, SeaName
		, StateANSICode
		, StateCode
		, StateName 
		, MailingAddressStreet
		, MailingAddressCity
		, MailingCountyAnsiCode
		, MailingAddressState
		, MailingAddressPostalCode 
		, OutOfStateIndicator
		, PhysicalAddressStreet
		, PhysicalAddressCity
		, PhysicalCountyAnsiCode
		, PhysicalAddressState
		, PhysicalAddressPostalCode
		, Telephone
		, Website
		, Longitude
		, Latitude 
		, RecordStartDateTime
		, RecordEndDateTime
		)
	VALUES (
			src.IeuName
		, src.IeuIdentifierState
		, src.SeaName
		, src.StateANSICode
		, src.StateCode
		, src.StateName
		, src.MailingStreet
		, src.MailingCity
		, src.MailingCountyAnsiCode
		, src.MailingState
		, src.MailingPostalCode
		, ISNULL(src.OutOfStateIndicator, 0)
		, src.StreetNumberAndName
		, src.City
		, src.PhysicalCountyAnsiCode
		, src.StateCode
		, src.PostalCode
		, src.TelephoneNumber
		, src.Website
		, src.Longitude
		, src.Latitude
		, src.RecordStartDateTime
		, src.RecordEndDateTime
		);

	;WITH upd AS(
			SELECT DimIeuId, IeuIdentifierState, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITIon BY IeuIdentifierState ORDER BY RecordStartDateTime ASC) AS endDate 
		FROM rds.DimIeus
	) 
	UPDATE ieu SET RecordEndDateTime = upd.endDate -1 
	FROM rds.DimIeus ieu
	INNER JOIN upd	
		on ieu.DimIeuId = upd.DimIeuId
	WHERE upd.endDate <> '1900-01-01 00:00:00.000'
		AND ieu.RecordEndDateTime IS NULL

	DROP TABLE #DATECTE
	DROP TABLE #mailingAddress
	DROP TABLE #physicalAddress
END 