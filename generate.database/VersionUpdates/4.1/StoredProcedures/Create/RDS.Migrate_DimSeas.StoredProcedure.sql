CREATE PROCEDURE [RDS].[Migrate_DimSeas]
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
	FROM rds.DimDataMigrationTypes WHERE DataMigrationTypeCode = 'rds'
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

	DECLARE @seaIdentifierTypeId AS INT	
	SELECT @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
	FROM dbo.RefOrganizationIdentifierType
	WHERE [Code] = '001491'

	DECLARE @seaFederalIdentificationSystemId AS INT
	SELECT @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'Federal'
	AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

    DECLARE @mainTelephoneTypeId AS INT
    SELECT @mainTelephoneTypeId = RefInstitutionTelephoneTypeId
    FROM dbo.RefInstitutionTelephoneType
    WHERE [Code] = 'Main'

	DECLARE @K12StaffRole VARCHAR(50) = 'Chief State School Officer'

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

	DECLARE @CSSORoleId AS INT
	SELECT @CSSORoleId = RoleId
	FROM dbo.[Role] WHERE Name = 'Chief State School Officer'

	DECLARE @dimSeaId AS INT, @DimK12StaffId INT, @DimIeuId INT, @dimLeaId INT, @DimK12SchoolId INT, @IsCharterSchool AS BIT, @leaOrganizationId AS INT
		
	DECLARE @count AS INT
	DECLARE @dimCharterSchoolManagerId AS INT
	DECLARE @dimCharterSchoolSecondaryManagerId AS INT
	DECLARE @dimCharterSchoolAuthorizerId AS INT
	DECLARE @dimCharterSchoolSecondaryAuthorizerId AS INT

	DECLARE @leaOperationalStatustypeId AS INT, @schOperationalStatustypeId AS INT, @charterLeaCount AS INT
	SELECT @leaOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000174'
	SELECT @schOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000533'
	SELECT @charterLeaCount = count(OrganizationId) FROM dbo.K12Lea WHERE CharterSchoolIndicator = 1


	IF NOT EXISTS (SELECT 1 FROM RDS.Dimseas WHERE DimSeaId = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.Dimseas ON
		INSERT INTO RDS.DimSeas (DimSeaId) VALUES (-1)
		SET IDENTITY_INSERT RDS.Dimseas off
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12Staff WHERE DimK12StaffId = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimK12Staff ON
		INSERT INTO RDS.DimK12Staff (DimK12StaffId) VALUES (-1)
		SET IDENTITY_INSERT RDS.DimK12Staff off
	END



	SELECT 
		  ol.OrganizationId
		, StreetNumberAndName   		AS MailingAddressStreet
		, ApartmentRoomOrSuiteNumber	AS MailingAddressStreet2		
		, City 							AS MailingAddressCity
		, refState.Code 				AS MailingAddressState
		, PostalCode 					AS MailingAddressPostalCode
		, rc.Code 						AS MailingAddressCountyAnsiCode
	INTO #mailingAddress
	FROM dbo.OrganizationLocation ol
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId	
	JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 1 -- mailing
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	
		
	CREATE INDEX AddressByOrg ON #mailingAddress (OrganizationId)
		
	SELECT 
		  ol.OrganizationId
		, StreetNumberAndName 			AS PhysicalAddressStreet
		, ApartmentRoomOrSuiteNumber	AS PhysicalAddressStreet2		
		, City 							AS PhysicalAddressCity
		, refState.Code 				AS PhysicalAddressState
		, PostalCode 					AS PhysicalAddressPostalCode
		, rc.Code 						AS PhysicalAddressCountyAnsiCode
		, la.Longitude
		, la.Latitude
	INTO #physicalAddress
	FROM dbo.OrganizationLocation ol
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId
	JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 2 -- Physical
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	

	CREATE INDEX AddressByOrg ON #physicalAddress (OrganizationId)

	
	-- Merge DimSeas
	
	;WITH DATECTE AS (
        SELECT DISTINCT
                OrganizationId
                , RecordStartDateTime
	            , ROW_NUMBER() OVER(PARTITION BY OrganizationId ORDER BY RecordStartDateTime) AS SequenceNumber
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

                ) dates
	)
	,  CTE AS 
	( 
		SELECT  DISTINCT
			  o.Name 								AS SeaName
			, i.Identifier
			, s.Code
			, s.Description 						AS StateAbbreviationDescription
			, rsCode.Description
			, mailingAddress.MailingAddressStreet
			, mailingAddress.MailingAddressStreet2
			, mailingAddress.MailingAddressCity
			, mailingAddress.MailingAddressState
			, mailingAddress.MailingAddressPostalCode
			, mailingAddress.MailingAddressCountyAnsiCode
			, physicalAddress.PhysicalAddressStreet
			, physicalAddress.PhysicalAddressStreet2
			, physicalAddress.PhysicalAddressCity
			, physicalAddress.PhysicalAddressState
			, physicalAddress.PhysicalAddressPostalCode
			, physicalAddress.PhysicalAddressCountyAnsiCode
			, phone.TelephoneNumber
			, website.Website
			, startDate.RecordStartDateTime AS RecordStartDateTime
			, endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		FROM DATECTE startDate
        LEFT JOIN DATECTE endDate 
			ON startDate.OrganizationId = endDate.OrganizationId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.OrganizationDetail o 
			ON o.OrganizationId = startDate.Organizationid
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		JOIN dbo.OrganizationIdentifier i 
			ON o.OrganizationId = i.OrganizationId 
			AND o.RefOrganizationTypeId = @seaOrgTypeId
			AND (@dataCollectionId IS NULL 
				OR i.DataCollectionId = @dataCollectionId)	
		JOIN dbo.RefOrganizationType t 
			ON o.RefOrganizationTypeId = t.RefOrganizationTypeId											
		LEFT JOIN dbo.RefStateANSICode rsCode 
			ON rsCode.Code = i.Identifier
		LEFT JOIN dbo.RefState s 
			ON s.Description = rsCode.Description
		LEFT JOIN dbo.OrganizationWebsite website 
			ON o.OrganizationId = website.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR website.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.OrganizationTelephone phone 
			ON o.OrganizationId = phone.OrganizationId
            AND phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
			AND (@dataCollectionId IS NULL 
				OR phone.DataCollectionId = @dataCollectionId)	
		LEFT JOIN #mailingAddress mailingAddress
			ON o.OrganizationId = mailingAddress.OrganizationId
		LEFT JOIN #physicalAddress physicalAddress
			ON o.OrganizationId = physicalAddress.OrganizationId
		WHERE (@dataCollectionId IS NULL 
			OR o.DataCollectionId = @dataCollectionId)	
		
	)
	MERGE rds.DimSeas AS trgt
	USING CTE AS src
		ON trgt.SeaIdentifierState = src.Identifier
		AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN 
		UPDATE SET 
			  trgt.SeaName = src.SeaName
			, trgt.StateAnsiCode = src.Identifier
			, trgt.StateAbbreviationCode = src.Code
			, trgt.StateAbbreviationDescription = src.StateAbbreviationDescription
			, trgt.MailingAddressStreet = src.MailingAddressStreet
			, trgt.MailingAddressStreet2 = src.MailingAddressStreet2	
			, trgt.MailingAddressCity = src.MailingAddressCity
			, trgt.MailingCountyAnsiCode = src.MailingAddressCountyAnsiCode
			, trgt.MailingAddressState = src.MailingAddressState
			, trgt.MailingAddressPostalCode = src.MailingAddressPostalCode
			, trgt.PhysicalAddressStreet = src.PhysicalAddressStreet
			, trgt.PhysicalAddressStreet2 = src.PhysicalAddressStreet2		
			, trgt.PhysicalAddressCity = src.PhysicalAddressCity
			, trgt.PhysicalCountyAnsiCode = src.PhysicalAddressCountyAnsiCode
			, trgt.PhysicalAddressState = src.PhysicalAddressState
			, trgt.PhysicalAddressPostalCode = src.PhysicalAddressPostalCode
			, trgt.Telephone = src.TelephoneNumber
			, trgt.Website = src.Website
			, trgt.RecordEndDateTime = src.RecordEndDateTime
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
		INSERT (
			  SeaName
			, SeaIdentifierState
			, StateANSICode
			, StateAbbreviationCode
			, StateAbbreviationDescription
			, MailingAddressStreet
			, MailingAddressStreet2			
			, MailingAddressCity
			, MailingCountyAnsiCode
			, MailingAddressState
			, MailingAddressPostalCode
			, PhysicalAddressStreet
			, PhysicalAddressStreet2			
			, PhysicalAddressCity
			, PhysicalCountyAnsiCode
			, PhysicalAddressState
			, PhysicalAddressPostalCode
			, Telephone
			, Website
			, RecordStartDateTime
			, RecordEndDateTime
			)
	VALUES (
			  src.SeaName
			, src.Identifier
			, src.Identifier
			, src.Code
			, src.StateAbbreviationDescription
			, src.MailingAddressStreet
			, src.MailingAddressStreet2			
			, src.MailingAddressCity
			, src.MailingAddressCountyAnsiCode
			, src.MailingAddressState
			, src.MailingAddressPostalCode
			, src.PhysicalAddressStreet
			, src.PhysicalAddressStreet2			
			, src.PhysicalAddressCity
			, src.PhysicalAddressCountyAnsiCode
			, src.PhysicalAddressState
			, src.PhysicalAddressPostalCode
			, src.TelephoneNumber
			, src.Website
			, src.RecordStartDateTime
			, src.RecordEndDateTime
			);

	;WITH upd AS(
			SELECT DimseaId, SeaIdentifierState, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY SeaIdentifierState ORDER BY RecordStartDateTime ASC) AS endDate 
		FROM rds.DimSeas
	) 
	UPDATE rds.DimSeas
	SET RecordEndDateTime = upd.endDate -1 
	FROM rds.DimSeas sea
	inner join upd	
		on sea.DimSeaId = upd.DimSeaId
	WHERE upd.endDate <> '1900-01-01 00:00:00.000'
		AND sea.RecordEndDateTime IS NULL
	
	
	---- Merge DimK12Staff
	;WITH DATECTE AS (
        SELECT DISTINCT
                PersonId
                , RecordStartDateTime
	            , ROW_NUMBER() OVER(PARTITION BY PersonId ORDER BY RecordStartDateTime) AS SequenceNumber
        FROM (
                    SELECT DISTINCT 
                            PersonId
                            , RecordStartDateTime
                    FROM dbo.PersonDetail
                    WHERE RecordStartDateTime IS NOT NULL

                ) dates
	)
	, CTE AS 
	( 
		SELECT  DISTINCT
			  p.Birthdate
			, p.FirstName
			, p.LastName
			, p.MiddleName
			, p.PersonId
			, Identifier
			, e.EmailAddress
			, tel.TelephoneNumber
			, PositionTitle
			, @K12StaffRole AS CSSORole
			, startDate.RecordStartDateTime AS RecordStartDateTime
			, endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
        LEFT JOIN DATECTE endDate 
			ON startDate.PersonId = endDate.PersonId 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.PersonDetail p 
			ON p.PersonId = startDate.PersonId  
			AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
		JOIN dbo.OrganizationPersonRole r 
			ON r.PersonId = p.PersonId 
			AND r.RoleId = @CSSORoleId		  
			AND (@dataCollectionId IS NULL 
				OR r.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.PersonIdentifier i 
			ON i.PersonId = p.PersonId
			AND (@dataCollectionId IS NULL 
				OR r.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.PersonEmailAddress e 
			ON e.PersonId = p.PersonId
			AND (@dataCollectionId IS NULL 
				OR e.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.StaffEmployment emp 
			ON emp.OrganizationPersonRoleId = r.OrganizationPersonRoleId
			AND (@dataCollectionId IS NULL 
				OR emp.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.PersonTelephone tel 
			ON tel.PersonId = p.PersonId
			AND (@dataCollectionId IS NULL 
				OR tel.DataCollectionId = @dataCollectionId)	
		WHERE (@dataCollectionId IS NULL 
			OR p.DataCollectionId = @dataCollectionId)	
	)
	MERGE rds.DimK12Staff AS trgt
	USING CTE AS src
		ON  trgt.StaffMemberIdentifierState = src.Identifier
		AND trgt.K12StaffRole = src.CSSORole
		AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN
		UPDATE SET 
			  trgt.Birthdate = src.Birthdate
			, trgt.FirstName = src.FirstName
			, trgt.LastOrSurname = src.LastName
			, trgt.MiddleName = src.MiddleName
			, trgt.K12StaffPersonId = src.PersonId
			, trgt.ElectronicMailAddress = src.EMailAddress
			, trgt.TelephoneNumber = src.TelephoneNumber
			, trgt.PositionTitle = src.PositionTitle
			, trgt.RecordEndDateTime = src.RecordEndDateTime 
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
	INSERT(
		  [BirthDate]
		, [FirstName]
		, [LastOrSurname]
		, [MiddleName]
		, [K12StaffPersonId]
		, [StaffMemberIdentifierState]
		, [ElectronicMailAddress]
		, [TelephoneNumber]
		, [PositionTitle]
		, K12StaffRole
		, RecordStartDateTime
		, RecordEndDateTime
		)
	VALUES(
		  src.Birthdate
		, src.FirstName
		, src.LastName
		, src.MiddleName
		, src.PersonId
		, src.Identifier
		, src.EMailAddress
		, src.TelephoneNumber
		, src.PositionTitle
		, src.CSSORole
		, src.RecordStartDateTime
		, src.RecordEndDateTime
		);


	;WITH upd AS(
			SELECT DimK12StaffId, StaffMemberIdentifierState, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StaffMemberIdentifierState ORDER BY RecordStartDateTime ASC) AS endDate 
		FROM rds.DimK12Staff
	) 
	UPDATE rds.DimK12Staff
	SET RecordEndDateTime = upd.endDate -1 
	FROM rds.DimK12Staff ks
	inner join upd	
		on ks.DimK12StaffId = upd.DimK12StaffId
	WHERE upd.endDate <> '1900-01-01 00:00:00.000'
		AND ks.RecordEndDateTime IS NULL

END 