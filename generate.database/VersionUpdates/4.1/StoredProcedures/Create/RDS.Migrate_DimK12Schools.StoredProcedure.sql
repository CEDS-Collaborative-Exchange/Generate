CREATE PROCEDURE [RDS].[Migrate_DimK12Schools]
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

	DECLARE @leaOrgTypeId AS INT
	SELECT @leaOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'LEA') AND RefOrganizationElementTypeId = @organizationElementTypeId

	DECLARE @leaNotFederalOrgTypeId AS INT
	SELECT @leaNotFederalOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'LEANotFederal') AND RefOrganizationElementTypeId = @organizationElementTypeId

	DECLARE @seaIdentifierTypeId AS INT	
	SELECT @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
	FROM dbo.RefOrganizationIdentifierType
	WHERE [Code] = '001491'

	DECLARE @seaFederalIdentificationSystemId AS INT
	SELECT @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'Federal'
	AND RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

	DECLARE @leaIdentifierTypeId AS INT
	SELECT @leaIdentifierTypeId = RefOrganizationIdentifierTypeId			
	FROM dbo.RefOrganizationIdentifierType
	WHERE [Code] = '001072'

	DECLARE @leaNCESIdentificationSystemId AS INT			
	SELECT @leaNCESIdentificationSystemId = RefOrganizationIdentificationSystemId		
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'NCES' AND RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		
	DECLARE @leaSEAIdentificationSystemId AS INT
	SELECT @leaSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'SEA'
	AND RefOrganizationIdentifierTypeId = @leaIdentifierTypeId

	DECLARE @ieuSEAIdentificationSystemId AS INT
	SELECT @ieuSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'IEU'

	DECLARE @gradeLevelTypeId AS INT = 0
	SELECT @gradeLevelTypeId = RefGradeLevelTypeId 
	FROM dbo.RefGradeLevelType WHERE code = '000131'

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

	--DECLARE @DimIeuId INT
	--	, @dimLeaId INT
	--	, @DimK12SchoolId INT
	--	, @IsCharterSchool BIT
	--	, @leaOrganizationId INT
		
	--DECLARE @count AS INT
	--DECLARE @dimCharterSchoolManagerId AS INT
	--DECLARE @dimCharterSchoolSecondaryManagerId AS INT
	--DECLARE @dimCharterSchoolAuthorizerId AS INT
	--DECLARE @dimCharterSchoolSecondaryAuthorizerId AS INT

	DECLARE @schoolIdentifierTypeId AS INT
	DECLARE @schoolSEAIdentificationSystemId AS INT
	DECLARE @schoolNCESIdentificationSystemId AS INT
	DECLARE @schoolOrgTypeId AS INT
	DECLARE @schoolOrgNotFederalTypeId AS INT
	
	--DimSchool Seed

	SELECT @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
	FROM dbo.RefOrganizationIdentifierType
	WHERE [Code] = '001073'

	SELECT @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'SEA'
	AND RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	SELECT @schoolNCESIdentificationSystemId = RefOrganizationIdentificationSystemId
	FROM dbo.RefOrganizationIdentificationSystem
	WHERE [Code] = 'NCES'
	AND RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	--DECLARE @schoolOrgTypeId AS INT
	SELECT @schoolOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE [Code] = 'K12School' AND RefOrganizationElementTypeId = @organizationElementTypeId

	SELECT @schoolOrgNotFederalTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE [Code] = 'K12SchoolNotFederal' AND RefOrganizationElementTypeId = @organizationElementTypeId

	
	if not exists (select 1 from RDS.DimK12Schools where DimK12SchoolId = -1)
	begin
		set identity_insert RDS.DimK12Schools on
		insert into RDS.DimK12Schools (DimK12SchoolId) values (-1)
		set identity_insert RDS.DimK12Schools off
	end
		
	CREATE TABLE #mailingAddress (
		  OrganizationId INT
		, StreetNumberAndName VARCHAR(250)
		, ApartmentRoomOrSuiteNumber VARCHAR(250)
		, City VARCHAR(100)
		, StateCode VARCHAR(2)
		, PostalCode VARCHAR(10)
		, CountyCode VARCHAR(20)
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)
	CREATE CLUSTERED INDEX IX_MailingAddress ON #mailingAddress (OrganizationId)

	CREATE TABLE #physicalAddress (
		  OrganizationId INT
		, StreetNumberAndName VARCHAR(250)
		, ApartmentRoomOrSuiteNumber VARCHAR(250)
		, City VARCHAR(100)
		, StateCode VARCHAR(2)
		, PostalCode VARCHAR(10)
		, CountyCode VARCHAR(20)
		, Longitude NVARCHAR(20)
		, Latitude NVARCHAR(20)
		, RecordStartDateTime DATETIME
		, RecordEndDateTime DATETIME
	)
	CREATE CLUSTERED INDEX IX_PhysicalAddress ON #physicalAddress (OrganizationId)

	INSERT INTO #mailingAddress
	SELECT
		  ol.OrganizationId
		, StreetNumberAndName
		, ApartmentRoomOrSuiteNumber
		, City
		, refState.Code AS StateCode
		, PostalCode
		, rc.Code as CountyCode
		, la.RecordStartDateTime
		, la.RecordEndDateTime
	FROM dbo.OrganizationLocation ol
	JOIN dbo.OrganizationDetail od
		ON ol.OrganizationId = od.OrganizationId
		AND od.RefOrganizationTypeId = @schoolOrgTypeId
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId	
	JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 1 -- mailing
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	

	INSERT INTO #physicalAddress
	SELECT DISTINCT
		  ol.OrganizationId
		, StreetNumberAndName
		, ApartmentRoomOrSuiteNumber
		, City
		, refState.Code AS StateCode
		, PostalCode
		, rc.Code as CountyCode
		, la.Longitude
		, la.Latitude
		, la.RecordStartDateTime
		, la.RecordEndDateTime
	FROM dbo.OrganizationLocation ol
	JOIN dbo.OrganizationDetail od
		ON ol.OrganizationId = od.OrganizationId		AND od.RefOrganizationTypeId = @schoolOrgTypeId
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId
	JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 2 -- Physical
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	


	CREATE TABLE #schoolSeaIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100) 
	)

	INSERT INTO #schoolSeaIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId

	CREATE TABLE #schoolNcesIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100) 
	)

	INSERT INTO #schoolNcesIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @schoolNCESIdentificationSystemId

	CREATE TABLE #leaSeaIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100)
	)
		
	INSERT INTO #leaSeaIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId

	CREATE TABLE #leaNcesIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100)
	)
		
	INSERT INTO #leaNcesIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @leaNcesIdentificationSystemId


	CREATE TABLE #ieuIdentifiers (
		  OrganizationId	INT PRIMARY KEY
		, Identifier		VARCHAR(100)
	)
		
	INSERT INTO #ieuIdentifiers
	SELECT DISTINCT
		  OrganizationId
		, Identifier
	FROM OrganizationIdentifier
	WHERE RefOrganizationIdentificationSystemId = @ieuSEAIdentificationSystemId


	-- DimK12School
	CREATE TABLE #DATECTE (
		  OrganizationId INT 
		, RecordStartDateTime DATETIME
		, SequenceNumber INT
	)
	CREATE NONCLUSTERED INDEX IX_DATECTE_Sequence ON #DATECTE (OrganizationId, SequenceNumber)
	CREATE NONCLUSTERED INDEX IX_DATECTE_StartDate ON #DATECTE (OrganizationId, RecordStartDateTime)


	INSERT INTO #DATECTE
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
			AND RefOrganizationTypeId IN (@schoolOrgTypeId, @schoolOrgNotFederalTypeId)

        UNION

        SELECT DISTINCT
                  oi.OrganizationId
                , oi.RecordStartDateTime
        FROM dbo.OrganizationIdentifier oi
		JOIN dbo.OrganizationDetail od
			ON oi.OrganizationId = od.OrganizationId
			AND od.RefOrganizationTypeId IN (@schoolOrgTypeId, @schoolOrgNotFederalTypeId)
        WHERE oi.RecordStartDateTime IS NOT NULL

        UNION

        SELECT DISTINCT
                  oos.OrganizationId
                , oos.OperationalStatusEffectiveDate
        FROM dbo.OrganizationOperationalStatus oos
		JOIN dbo.OrganizationDetail od
			ON oos.OrganizationId = od.OrganizationId
			AND RefOrganizationTypeId IN (@schoolOrgTypeId, @schoolOrgNotFederalTypeId)
        WHERE OperationalStatusEffectiveDate IS NOT NULL 

		UNION 

		SELECT DISTINCT
                  k.OrganizationId
                , g.RecordStartDateTime
        FROM dbo.K12SchoolGradeOffered g
		JOIN dbo.K12School k on g.K12SchoolId = k.K12SchoolId
        WHERE g.RecordStartDateTime IS NOT NULL

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

	CREATE TABLE #operatingStatuses (
		  OrganizationId INT
		, OrganizationOperationalStatusCode VARCHAR(50)
		, OperationalStatusEffectiveDate DATETIME
		, SequenceNumber INT
	)
	CREATE NONCLUSTERED INDEX IX_OperatingStatuses_Sequence ON #operatingStatuses (OrganizationId, SequenceNumber)
	CREATE NONCLUSTERED INDEX IX_OperatingStatuses_Date ON #operatingStatuses (OrganizationId, OperationalStatusEffectiveDate)

	INSERT INTO #operatingStatuses
	SELECT 
		  oos.OrganizationId
		, NULL
		, MAX(oos.OperationalStatusEffectiveDate)
		, startDate.SequenceNumber
	FROM #DATECTE startDate
	LEFT JOIN #DATECTE endDate 
		ON startDate.OrganizationId = endDate.OrganizationId 
		AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
	JOIN dbo.OrganizationOperationalStatus oos
		ON startDate.OrganizationId = oos.OrganizationId
		AND CONVERT(DATE, oos.OperationalStatusEffectiveDate) <= CONVERT(DATE, startDate.RecordStartDateTime) 
	JOIN dbo.RefOperationalStatus os
		ON oos.RefOperationalStatusId = os.RefOperationalStatusId
	JOIN dbo.RefOperationalStatusType ost
		ON os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId
		AND ost.Code = '000533' -- School Operational Status
	WHERE (@dataCollectionId IS NULL 
			OR oos.DataCollectionId = @dataCollectionId)	
	GROUP BY oos.OrganizationId, startDate.SequenceNumber

	UPDATE #operatingStatuses
	SET OrganizationOperationalStatusCode = ros.Code
	FROM #operatingStatuses os
	JOIN OrganizationOperationalStatus oos
		ON os.OrganizationId = oos.OrganizationId
		AND os.OperationalStatusEffectiveDate = oos.OperationalStatusEffectiveDate
	JOIN RefOperationalStatus ros
		ON oos.RefOperationalStatusId = ros.RefOperationalStatusId
	
	CREATE TABLE #K12Schools (
		  IeuName								VARCHAR(200)
		, IeuStateIdentifier					VARCHAR(50)
		, LeaIdentifierNces						VARCHAR(50)
		, LeaIdentifierState					VARCHAR(50)
		, LeaOrganizationName					VARCHAR(200)
		, SchoolIdentifierNces					VARCHAR(50)
		, SchoolIdentifierState					VARCHAR(50)
		, NameOfInstitution						VARCHAR(200)
		, SchOperationalStatus					VARCHAR(50)
		, SchOperationalEdfactsStatus			VARCHAR(50)
		, OperationalStatusEffectiveDate		DATETIME
		, CharterSchoolIndicator				BIT
		, CharterSchoolContractApprovalDate		DATETIME
		, CharterSchoolContractRenewalDate		DATETIME
		, CharterSchoolContractIdNumber			VARCHAR(50)
		, ReportedFederally						BIT
		, LeaTypeCode							VARCHAR(50)
		, LeaTypeDescription					VARCHAR(200)
		, LeaTypeEdfactsCode					VARCHAR(50)
		, LeaTypeId								INT
		, MailingAddressStreet					VARCHAR(200)
		, MailingAddressStreet2					VARCHAR(200)
		, MailingAddressCity					VARCHAR(200)
		, MailingAddressState					VARCHAR(50)
		, MailingAddressPostalCode				VARCHAR(10)
		, MailingAddressCountyAnsiCode			VARCHAR(20)
		, OutOfState							BIT
		, PhysicalAddressStreet					VARCHAR(200)
		, PhysicalAddressStreet2				VARCHAR(200)
		, PhysicalAddressCity					VARCHAR(200)
		, PhysicalAddressStateCode				VARCHAR(50)
		, PhysicalAddressPostalCode				VARCHAR(10)
		, PhysicalAddressCountyAnsiCode			VARCHAR(20)
		, Longitude								VARCHAR(20)
		, Latitude								VARCHAR(20)
		, SchoolTypeCode						VARCHAR(50)
		, SchoolTypeDescription					VARCHAR(200)
		, SchoolTypeEdfactsCode					VARCHAR(50)
		, SchoolTypeId							INT
		, TelephoneNumber						VARCHAR(20)
		, Website								VARCHAR(300)
		, CharterSchoolStatus					VARCHAR(50)
		, ReconstitutedStatus					VARCHAR(50)
		, RecordStartDateTime					DATETIME
		, RecordEndDateTime						DATETIME
		)
		CREATE CLUSTERED INDEX IX_K12Schools ON #K12Schools (SchoolIdentifierState, RecordStartDateTime)

		INSERT INTO #K12Schools
		SELECT DISTINCT
			  ieuoi.Name AS IeuName
			, ieuoi.Identifier AS IeuStateIdentifier
			, LeaIdentifierNces.Identifier AS LeaIdentifierNces
			, LeaIdentifierState.Identifier AS LeaIdentifierState
			, lea.Name AS LeaOrganizationName
			, SchoolIdentifierNces.Identifier AS SchoolIdentifierNces
			, SchoolIdentifierState.Identifier AS SchoolIdentifierState
			, o.Name AS NameOfInstitution
			, op.OrganizationOperationalStatusCode AS SchOperationalStatus
			, CASE op.OrganizationOperationalStatusCode
				WHEN 'Open' THEN 1 
				WHEN 'Closed' THEN 2 
				WHEN 'New' THEN 3 
				WHEN 'Added' THEN 4 
				WHEN 'ChangedAgency' THEN 5 
				WHEN 'Inactive' THEN 6 
				WHEN 'FutureSchool' THEN 7 
				WHEN 'Reopened' THEN 8 
				ELSE -1
			   END AS SchOperationalEdfactsStatus
			, ISNULL(op.OperationalStatusEffectiveDate, '') AS OperationalStatusEffectiveDate
			, K12.CharterSchoolIndicator
			, k12.CharterSchoolContractApprovalDate
			, k12.CharterSchoolContractRenewalDate
			, K12.CharterSchoolContractIdNumber
			, CASE 
				WHEN o.RefOrganizationTypeId = @schoolOrgNotFederalTypeId THEN 0 
				ELSE 1 
			  END AS ReportedFederally
			, leaType.Code AS LeaTypeCode
			, leaType.[Description] AS LeaTypeDescription
			, CASE leaType.Code 
				 WHEN 'RegularNotInSupervisoryUnion' THEN 1
				 WHEN 'RegularInSupervisoryUnion' THEN 2
				 WHEN 'SupervisoryUnion' THEN 3
				 WHEN 'SpecializedPublicSchoolDistrict' THEN 9
				 WHEN 'ServiceAgency' THEN 4
				 WHEN 'StateOperatedAgency' THEN 5
				 WHEN 'FederalOperatedAgency' THEN 6
				 WHEN 'Other' THEN 8
				 WHEN 'IndependentCharterDistrict' THEN 7
				 ELSE -1
			   END AS LeaTypeEdfactsCode
			, leaType.RefLeaTypeId AS LeaTypeId
			, mailingAddress.StreetNumberAndName AS MailingAddressStreet
			, mailingAddress.ApartmentRoomOrSuiteNumber AS MailingAddressStreet2
			, mailingAddress.City AS MailingAddressCity
			, mailingAddress.StateCode AS MailingAddressState
			, mailingAddress.PostalCode AS MailingAddressPostalCode
			, mailingAddress.CountyCode AS MailingAddressCountyAnsiCode
			, CASE 
				WHEN physicalAddress.StateCode <> @stateCode 
					OR mailingAddress.StateCode <> @stateCode THEN '1' 
				ELSE 0 
			  END AS OutOfState
			, physicalAddress.StreetNumberAndName AS PhysicalAddressStreet
			, physicalAddress.ApartmentRoomOrSuiteNumber AS PhysicalAddressStreet2
			, physicalAddress.City AS PhysicalAddressCity
			, physicalAddress.StateCode AS PhysicalAddressStateCode
			, physicalAddress.PostalCode AS PhysicalAddressPostalCode
			, physicalAddress.CountyCode AS PhysicalAddressCountyAnsiCode
			, physicalAddress.Longitude AS Longitude
			, physicalAddress.Latitude AS Latitude
			, schoolType.Code AS SchoolTypeCode
			, schoolType.[Description] AS SchoolTypeDescription
			, CASE schoolType.Code 
				WHEN 'Regular' THEN 1
				WHEN 'Special' THEN 2
				WHEN 'CareerAndTechnical' THEN 3
				WHEN 'Alternative' THEN 4
				WHEN 'Reportable' THEN 5
				ELSE -1
			  END AS SchoolTypeEdfactsCode
			, schoolType.RefSchoolTypeId AS SchoolTypeId
			, phone.TelephoneNumber
			, website.Website
			, CASE 
				WHEN K12.CharterSchoolIndicator IS NULL THEN 'MISSING'
				WHEN K12.CharterSchoolIndicator = 1 THEN 'YES'
				WHEN K12.CharterSchoolIndicator = 0 THEN 'NO'
			  END AS CharterSchoolStatus
			, UPPER(ISNULL(r.Code, 'MISSING')) AS ReconstitutedStatus
			, startDate.RecordStartDateTime AS RecordStartDateTime
			, DATEADD(DAY, -1, endDate.RecordStartDateTime) AS RecordEndDateTime
		FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate 
			ON startDate.OrganizationId = endDate.OrganizationId 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.OrganizationDetail o 
			ON o.OrganizationId = startDate.Organizationid
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		LEFT JOIN #mailingAddress mailingAddress
			ON o.OrganizationId = mailingAddress.OrganizationId
		LEFT JOIN #physicalAddress physicalAddress
			ON o.OrganizationId = physicalAddress.OrganizationId
		JOIN dbo.K12School K12 
			ON K12.OrganizationId = o.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR K12.DataCollectionId = @dataCollectionId)	
		JOIN #schoolSeaIdentifiers SchoolIdentifierState 
			ON o.OrganizationId = SchoolIdentifierState.OrganizationId
		LEFT JOIN #schoolNcesIdentifiers SchoolIdentifierNces 
			ON o.OrganizationId = SchoolIdentifierNces.OrganizationId
		LEFT JOIN dbo.OrganizationRelationship parent 
			ON parent.OrganizationId = o.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR parent.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.OrganizationDetail lea 
			ON lea.OrganizationId = parent.Parent_OrganizationId	
			AND (@dataCollectionId IS NULL 
				OR lea.DataCollectionId = @dataCollectionId)	
			AND lea.RefOrganizationTypeId in (@leaOrgTypeId, @leaNotFederalOrgTypeId)
		LEFT JOIN dbo.K12Lea k12lea 
			ON lea.OrganizationId = k12lea.OrganizationId
			AND (@dataCollectionId IS NULL OR k12lea.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefLeaType leaType 
			ON k12lea.RefLeaTypeId = leaType.RefLeaTypeId
		LEFT JOIN #leaNcesIdentifiers LeaIdentifierNces 
			ON lea.OrganizationId = LeaIdentifierNces.OrganizationId 
		LEFT JOIN #leaSeaIdentifiers LeaIdentifierState 
			ON lea.OrganizationId = LeaIdentifierState.OrganizationId 
		LEFT JOIN dbo.RefSchoolType schoolType 
			ON schoolType.RefSchoolTypeId = k12.RefSchoolTypeId
		LEFT JOIN #operatingStatuses op 
			ON o.OrganizationId = op.OrganizationId
			AND startDate.SequenceNumber = op.SequenceNumber
		LEFT JOIN dbo.OrganizationWebsite website 
			ON o.OrganizationId = website.OrganizationId
			AND (@dataCollectionId IS NULL OR website.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.OrganizationTelephone phone 
			ON o.OrganizationId = phone.OrganizationId
            AND phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
			AND (@dataCollectionId IS NULL OR phone.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.OrganizationFederalAccountability fa 
			ON o.OrganizationId = fa.OrganizationId
			AND (@dataCollectionId IS NULL OR fa.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefReconstitutedStatus r 
			ON r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
		LEFT JOIN	(SELECT ore.Parent_OrganizationId, ore.OrganizationId, ieuoi.Identifier, ieuDetail.Name
					FROM dbo.OrganizationRelationship ore 
					JOIN dbo.OrganizationDetail ieuDetail 
						ON ore.Parent_OrganizationId = ieuDetail.OrganizationId
						AND ieuDetail.RefOrganizationTypeId = @ieuOrgTypeId
	 				JOIN #ieuIdentifiers ieuoi 
						ON ieuDetail.OrganizationId = ieuoi.OrganizationId
					) ieuoi 
			ON lea.OrganizationId = ieuoi.OrganizationId
			OR o.OrganizationId = ieuoi.OrganizationId
		WHERE (@dataCollectionId IS NULL OR o.DataCollectionId = @dataCollectionId)	
		AND lea.OrganizationId IS NOT NULL

	MERGE rds.DimK12Schools AS trgt
	USING #K12Schools AS src
			ON trgt.SchoolIdentifierState = src.SchoolIdentifierState
			AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN 
			UPDATE SET trgt.IeuName = src.IeuName,
					trgt.IeuIdentifierState = src.IeuStateIdentifier,
			        trgt.LeaName = src.LeaOrganizationName,
					trgt.LeaIdentifierNces = src.LeaIdentifierNces,
					trgt.LeaIdentifierState = src.LeaIdentifierState,
					trgt.NameOfInstitution = src.NameOfInstitution,
					trgt.SchoolOperationalStatus = src.SchOperationalStatus,
					trgt.SchoolOperationalStatusEdFactsCode = src.SchOperationalEdfactsStatus,
					trgt.SchoolOperationalStatusEffectiveDate = src.OperationalStatusEffectiveDate,
					trgt.CharterSchoolIndicator = src.CharterSchoolIndicator,
					trgt.CharterSchoolContractIdNumber = src.CharterSchoolContractIdNumber,
					trgt.CharterSchoolContractApprovalDate = src.CharterSchoolContractApprovalDate,
					trgt.CharterSchoolContractRenewalDate = src.CharterSchoolContractRenewalDate,
					trgt.ReportedFederally = src.ReportedFederally,
					trgt.LeaTypeCode = src.LeaTypeCode,
					trgt.LeaTypeDescription = src.LeaTypeDescription,
					trgt.LeaTypeEdFactsCode = src.LeaTypeEdFactsCode,
					trgt.LeaTypeId = src.LeaTypeId,
					trgt.OutOfStateIndicator = src.OutOfState,
					trgt.MailingAddressStreet = src.MailingAddressStreet,
					trgt.MailingAddressStreet2 = src.MailingAddressStreet2,
					trgt.MailingAddressCity = src.MailingAddressCity,
					trgt.MailingCountyAnsiCode = src.MailingAddressCountyAnsiCode,
					trgt.MailingAddressState = src.MailingAddressState,
					trgt.MailingAddressPostalCode = src.MailingAddressPostalCode,
					trgt.PhysicalAddressStreet = src.PhysicalAddressStreet,
					trgt.PhysicalAddressStreet2 = src.PhysicalAddressStreet2,
					trgt.PhysicalAddressCity = src.PhysicalAddressCity,
					trgt.PhysicalCountyAnsiCode = src.PhysicalAddressCountyAnsiCode,
					trgt.PhysicalAddressState = src.PhysicalAddressStateCode,
					trgt.PhysicalAddressPostalCode = src.PhysicalAddressPostalCode,
					trgt.Longitude = src.Longitude,
					trgt.Latitude = src.Latitude,
					trgt.Telephone = src.TelephoneNumber,
					trgt.Website = src.Website,
					trgt.SchoolTypeCode = src.SchoolTypeCode,
					trgt.SchoolTypeDescription = src.SchoolTypeDescription,
					trgt.SchoolTypeEdFactsCode = src.SchoolTypeEdFactsCode,
					trgt.SchoolTypeId = src.SchoolTypeId,
					trgt.SchoolIdentifierNces = src.SchoolIdentifierNces,
					trgt.CharterSchoolStatus = src.CharterSchoolStatus,
					trgt.ReconstitutedStatus = src.ReconstitutedStatus,
					trgt.RecordEndDateTime = src.RecordEndDateTime
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
	INSERT (
		  IeuName
		, IeuIdentifierState
		, StateAbbreviationCode
		, StateAbbreviationDescription
		, StateANSICode
		, SeaOrganizationId
		, SeaName
		, SeaIdentifierState
		, LeaIdentifierNces
		, LeaIdentifierState
		, LeaName
		, SchoolIdentifierNces
		, SchoolIdentifierState
		, NameOfInstitution
		, SchoolOperationalStatus
		, SchoolOperationalStatusEdFactsCode
		, SchoolOperationalStatusEffectiveDate
		, CharterSchoolIndicator
		, CharterSchoolContractApprovalDate
		, CharterSchoolContractRenewalDate
		, CharterSchoolContractIdNumber
		, ReportedFederally
		, LeaTypeCode
		, LeaTypeDescription
		, LeaTypeEdFactsCode
		, LeaTypeId
		, MailingAddressStreet
		, MailingAddressStreet2
		, MailingAddressCity
		, MailingCountyAnsiCode
		, MailingAddressState
		, MailingAddressPostalCode
		, OutOfStateIndicator
		, PhysicalAddressStreet
		, PhysicalAddressStreet2
		, PhysicalAddressCity
		, PhysicalCountyAnsiCode
		, PhysicalAddressState
		, PhysicalAddressPostalCode
		, Longitude
		, Latitude
		, SchoolTypeCode 
		, SchoolTypeDescription 
		, SchoolTypeEdFactsCode	
		, SchoolTypeId	
		, Telephone
		, Website
		, CharterSchoolStatus
		, ReconstitutedStatus
		, RecordStartDateTime
		, RecordEndDateTime) 
	VALUES(
		  src.IeuName
		, src.IeuStateIdentifier
		, @stateCode
		, @stateDescription
		, @seaIdentifier
		, @seaOrganizationId
		, @seaName
		, @seaIdentifier
		, src.LeaIdentifierNces
		, src.LeaIdentifierState
		, src.LeaOrganizationName
		, src.SchoolIdentifierNces
		, src.SchoolIdentifierState
		, src.NameOfInstitution
		, src.SchOperationalStatus
		, src.SchOperationalEdfactsStatus
		, src.OperationalStatusEffectiveDate
		, src.CharterSchoolIndicator
		, src.CharterSchoolContractApprovalDate
		, src.CharterSchoolContractRenewalDate
		, src.CharterSchoolContractIdNumber
		, src.ReportedFederally
		, src.LeaTypeCode
		, src.LeaTypeDescription
		, src.LeaTypeEdFactsCode
		, src.LeaTypeId
		, src.MailingAddressStreet
		, src.MailingAddressStreet2
		, src.MailingAddressCity
		, src.MailingAddressCountyAnsiCode
		, src.MailingAddressState
		, src.MailingAddressPostalCode
		, src.OutOfState
		, src.PhysicalAddressStreet
		, src.PhysicalAddressStreet2
		, src.PhysicalAddressCity
		, src.PhysicalAddressCountyAnsiCode
		, src.PhysicalAddressStateCode
		, src.PhysicalAddressPostalCode
		, src.Longitude
		, src.Latitude
		, src.SchoolTypeCode
		, src.SchoolTypeDescription
		, src.SchoolTypeEdFactsCode
		, src.SchoolTypeId
		, src.TelephoneNumber
		, src.Website
		, src.CharterSchoolStatus
		, src.ReconstitutedStatus
		, src.RecordStartDateTime
		, src.RecordEndDateTime);

		;WITH upd AS(
			SELECT 
				  startd.SchoolIdentifierState
				, startd.RecordStartDateTime 
				, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
			FROM rds.DimK12Schools startd
			JOIN rds.DimK12Schools endd
				ON startd.SchoolIdentifierState = endd.SchoolIdentifierState
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY  startd.SchoolIdentifierState, startd.RecordStartDateTime
		) 
		UPDATE school SET RecordEndDateTime = upd.RecordEndDateTime
		FROM rds.DimK12Schools school
		JOIN upd	
			ON school.SchoolIdentifierState = upd.SchoolIdentifierState
			AND school.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'

	CREATE TABLE #gradeLevels
	(
		  DimK12SchoolId INT
		, DimGradeLevelId INT
	)

	INSERT INTO #gradeLevels
	SELECT distinct 
			dimSchool.DimK12SchoolId
		, grades.DimGradeLevelId 
	FROM rds.DimK12Schools dimSchool
	INNER JOIN dbo.OrganizationIdentifier i 
		ON dimSchool.LeaIdentifierState = i.Identifier 
		AND i.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
		AND ISNULL(i.RecordEndDateTime, GETDATE()) >= dimSchool.RecordStartDateTime
		AND ISNULL(dimSchool.RecordEndDateTime, GETDATE()) >= i.RecordStartDateTime
	INNER JOIN dbo.K12School sch 
		ON i.OrganizationId = sch.OrganizationId
	INNER JOIN dbo.K12SchoolGradeOffered g 
		ON g.K12SchoolId = sch.K12SchoolId
	INNER JOIN dbo.RefGradeLevel l 
		ON l.RefGradeLevelId = g.RefGradeLevelId
		AND RefGradeLevelTypeId = (SELECT TOP 1 RefGradeLevelTypeId FROM dbo.RefGradeLevelType WHERE code = '000131')
	INNER JOIN RDS.DimGradeLevels grades 
		ON grades.GradeLevelCode = l.Code

	MERGE rds.BridgeK12SchoolGradeLevels AS trgt
	USING #gradeLevels AS src
					ON trgt.K12SchoolId = src.DimK12SchoolId
					AND trgt.GradeLevelId = src.DimGradeLevelId
	WHEN NOT MATCHED THEN
	INSERT(K12SchoolId, GradeLevelId) values(src.DimK12SchoolId, src.DimGradeLevelId);

	DROP TABLE #K12Schools
	DROP TABLE #DATECTE
	DROP TABLE #gradeLevels
	DROP TABLE #ieuIdentifiers
	DROP TABLE #leaSeaIdentifiers
	DROP TABLE #mailingAddress
	DROP TABLE #operatingStatuses
	DROP TABLE #physicalAddress
	DROP TABLE #schoolSeaIdentifiers
	DROP TABLE #schoolNcesIdentifiers
	DROP TABLE #leaNcesIdentifiers


END 