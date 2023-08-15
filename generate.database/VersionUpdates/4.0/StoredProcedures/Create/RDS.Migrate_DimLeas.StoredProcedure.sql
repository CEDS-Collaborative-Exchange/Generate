CREATE PROCEDURE [RDS].[Migrate_DimLeas]
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
		
	DECLARE @leaOperationalStatustypeId AS INT, @schOperationalStatustypeId AS INT, @charterLeaCount AS INT
	SELECT @leaOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000174'
	SELECT @schOperationalStatustypeId = RefOperationalStatusTypeId FROM dbo.RefOperationalStatusType WHERE Code = '000533'
	SELECT @charterLeaCount = count(OrganizationId) FROM dbo.K12Lea WHERE CharterSchoolIndicator = 1

	IF NOT EXISTS (SELECT 1 FROM RDS.DimLeas WHERE DimLeaID = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimLeas ON
		INSERT INTO RDS.DimLeas (DimLeaId) VALUES (-1)
		SET IDENTITY_INSERT RDS.DimLeas off
	END

	SELECT 
		  ol.OrganizationId
		, StreetNumberAndName			AS MailingAddressStreet
		, ApartmentRoomOrSuiteNumber	AS MailingAddressStreet2
		, City							AS MailingAddressCity
		, refState.Code					AS MailingAddressState
		, PostalCode 					AS MailingAddressPostalCode
		, rc.Code						AS MailingAddressCountyAnsiCode
		, la.RecordStartDateTime
		, la.RecordEndDateTime
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
		, StreetNumberAndName			AS PhysicalAddressStreet
		, ApartmentRoomOrSuiteNumber	AS PhysicalAddressStreet2
		, City							AS PhysicalAddressCity
		, refState.Code					AS PhysicalAddressState
		, PostalCode					AS PhysicalAddressPostalCode
		, rc.Code						AS PhysicalAddressCountyAnsiCode
		, la.Longitude
		, la.Latitude
		, la.RecordStartDateTime
		, la.RecordEndDateTime
	INTO #physicalAddress
	FROM dbo.OrganizationLocation ol
	JOIN dbo.LocationAddress la ON ol.LocationId = la.LocationId
		AND (@dataCollectionId IS NULL OR la.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefCounty rc  ON la.RefCountyId = rc.RefCountyId
	JOIN dbo.RefState refState ON refState.RefStateId = la.RefStateId
	WHERE RefOrganizationLocationTypeId = 2 -- Physical
		AND (@dataCollectionId IS NULL OR ol.DataCollectionId = @dataCollectionId)	

	CREATE INDEX AddressByOrg ON #physicalAddress (OrganizationId)

	CREATE TABLE #operatingStatuses (
		  OrganizationId INT
		, OrganizationOperationalStatusCode VARCHAR(50)
		, OperationalStatusEffectiveDate DATETIME
		, SequenceNumber INT
	)

	CREATE NONCLUSTERED INDEX IX_OperatingStatuses_Sequence ON #operatingStatuses (OrganizationId, SequenceNumber)
	CREATE NONCLUSTERED INDEX IX_OperatingStatuses_Date ON #operatingStatuses (OrganizationId, OperationalStatusEffectiveDate)


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
                    k.OrganizationId
                    , g.RecordStartDateTime
            FROM dbo.K12SchoolGradeOffered g
			inner join dbo.K12School k on g.K12SchoolId = k.K12SchoolId
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

	CREATE INDEX DatesByOrg ON #DATECTE (OrganizationId)


	INSERT INTO #operatingStatuses
	SELECT 
		  oos.OrganizationId
		, NULL AS OrganizationOperationalStatusCode
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
		AND ost.Code = '000174' -- LEA Operational Status
	WHERE (@dataCollectionId IS NULL 
			OR oos.DataCollectionId = @dataCollectionId)	
	GROUP BY oos.OrganizationId, oos.OperationalStatusEffectiveDate, startDate.SequenceNumber

	UPDATE #operatingStatuses
	SET OrganizationOperationalStatusCode = ros.Code
	FROM #operatingStatuses os
	JOIN OrganizationOperationalStatus oos
		ON os.OrganizationId = oos.OrganizationId
		AND os.OperationalStatusEffectiveDate = oos.OperationalStatusEffectiveDate
	JOIN RefOperationalStatus ros
		ON oos.RefOperationalStatusId = ros.RefOperationalStatusId	

	----DimLeas
	;WITH CTE AS 
	( 
		SELECT DISTINCT	
			  o.Name
			, i.Identifier AS NCESIdentifier
			, i1.Identifier AS StateIdentifier
			, lea.SupervisoryUnionIdentificationNumber
			, leaType.Code AS LeaTypeCode
			, leaType.Description AS LeaTypeDescription
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
			  END AS LeaTypeEdfactsCode -- EdFacts Code
			, leaType.RefLeaTypeId
			, mailingAddress.MailingAddressStreet
			, mailingAddress.MailingAddressStreet2
			, mailingAddress.MailingAddressCity
			, mailingAddress.MailingAddressState
			, mailingAddress.MailingAddressPostalCode
			, mailingAddress.MailingAddressCountyAnsiCode
			, CASE 
				WHEN physicalAddress.PhysicalAddressState <> @stateCode 
					OR mailingAddress.MailingAddressState <> @stateCode THEN '1' 
				ELSE 0 
			  END AS OutOfState
			, physicalAddress.PhysicalAddressStreet
			, physicalAddress.PhysicalAddressStreet2
			, physicalAddress.PhysicalAddressCity
			, physicalAddress.PhysicalAddressState
			, physicalAddress.PhysicalAddressPostalCode
			, physicalAddress.PhysicalAddressCountyAnsiCode
			, phone.TelephoneNumber
			, website.Website
			, physicalAddress.Longitude
			, physicalAddress.Latitude
			, op.OrganizationOperationalStatusCode AS LeaOperationalStatus
			, CASE op.OrganizationOperationalStatusCode
				WHEN 'Open' THEN 1 
				WHEN 'Closed' THEN 2 
				WHEN 'New' THEN 3 
				WHEN 'Added' THEN 4 
				WHEN 'ChangedBoundary' THEN 5 
				WHEN 'Inactive' THEN 6 
				WHEN 'FutureAgency' THEN 7 
				WHEN 'Reopened' THEN 8 
				ELSE -1
			  END AS LeaOperationalEdfactsStatus
			, op.OperationalStatusEffectiveDate
			, ISNULL(priorLea.Identifier,'') AS PriorLeaIdentifierState
			, CASE 
				WHEN t.Code = 'LEANotFederal' THEN 0 
				ELSE 1 
			  END AS ReportedFederally
			, CASE 
				WHEN lea.CharterSchoolIndicator = 1 
					AND leaType.Code = 'RegularNotInSupervisoryUnion' THEN ISNULL(cl.Code, 'MISSING') 
				ELSE IIF(@charterLeaCount > 0,'NOTCHR','NA') 
			  END AS CharterLeaStatus
			, ISNULL(r.Code, 'MISSING') AS ReconstitutedStatus
			, startDate.RecordStartDateTime AS RecordStartDateTime
			, endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate 
			ON startDate.OrganizationId = endDate.OrganizationId 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		JOIN dbo.OrganizationDetail o 
			ON o.OrganizationId = startDate.Organizationid
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		JOIN dbo.OrganizationIdentifier i1 
			ON o.OrganizationId = i1.OrganizationId 
			AND i1.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId 
			AND (@dataCollectionId IS NULL 
				OR i1.DataCollectionId = @dataCollectionId)	
		JOIN dbo.RefOrganizationType t 
			ON o.RefOrganizationTypeId = t.RefOrganizationTypeId 
			AND t.Code IN ('LEA','LEANotFederal')
		LEFT JOIN dbo.OrganizationIdentifier i 
			ON o.OrganizationId = i.OrganizationId 
			AND i.RefOrganizationIdentificationSystemId = @leaNCESIdentificationSystemId	
			AND (@dataCollectionId IS NULL 
				OR i.DataCollectionId = @dataCollectionId)	
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
            AND startDate.RecordStartDateTime BETWEEN mailingAddress.RecordStartDateTime AND ISNULL(mailingAddress.RecordEndDateTime, GETDATE())
		LEFT JOIN #physicalAddress physicalAddress
			ON o.OrganizationId = physicalAddress.OrganizationId
            AND startDate.RecordStartDateTime BETWEEN physicalAddress.RecordStartDateTime AND ISNULL(physicalAddress.RecordEndDateTime, GETDATE())
		LEFT JOIN dbo.K12Lea lea 
			ON lea.OrganizationId = o.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR lea.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefLeaType leaType 
			ON lea.RefLeaTypeId = leaType.RefLeaTypeId
		LEFT JOIN dbo.RefCharterLeaStatus cl 
			ON lea.RefCharterLeaStatusId = cl.RefCharterLeaStatusId
		LEFT JOIN dbo.OrganizationFederalAccountability fa 
			ON o.OrganizationId = fa.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR fa.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefReconstitutedStatus r 
			ON r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
		LEFT JOIN dbo.K12School school 
			ON school.OrganizationId = o.OrganizationId
			AND (@dataCollectionId IS NULL 
				OR school.DataCollectionId = @dataCollectionId)	
		LEFT JOIN dbo.RefSchoolType schoolType 
			ON schoolType.RefSchoolTypeId = school.RefSchoolTypeId
		LEFT JOIN #operatingStatuses op 
			ON o.OrganizationId = op.OrganizationId
			AND startDate.SequenceNumber = op.SequenceNumber
		LEFT JOIN (		
				SELECT 
					  i.Identifier
					, MAX(i.RecordEndDateTime) AS RecordEndDateTime
				FROM dbo.OrganizationDetail o
				JOIN dbo.OrganizationIdentifier i 
					ON o.OrganizationId = i.OrganizationId
					AND (@dataCollectionId IS NULL 
						OR i.DataCollectionId = @dataCollectionId)	
				WHERE RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
					AND (@dataCollectionId IS NULL 
						OR o.DataCollectionId = @dataCollectionId)	
					AND RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
					AND i.RecordEndDateTime IS NOT NULL
				GROUP BY i.Identifier
			) priorLea ON i.Identifier = priorLea.Identifier
		WHERE (@dataCollectionId IS NULL 
			OR o.DataCollectionId = @dataCollectionId)	
	)
	MERGE rds.DimLeas AS trgt
	USING CTE AS src
		ON trgt.LeaIdentifierState = src.StateIdentifier
		AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN 
		UPDATE SET 
			  trgt.LeaName = src.Name
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
			, trgt.Longitude = src.Longitude
			, trgt.Latitude = src.Latitude
			, trgt.LeaSupervisoryUnionIdentificationNumber = src.SupervisoryUnionIdentificationNumber
			, trgt.LeaOperationalStatus = src.LeaOperationalStatus
			, trgt.LeaOperationalStatusEdFactsCode = src.LeaOperationalEdfactsStatus
			, trgt.OperationalStatusEffectiveDate = src.OperationalStatusEffectiveDate
			, trgt.PriorLeaIdentifierState = src.PriorLeaIdentifierState
			, trgt.ReportedFederally = src.ReportedFederally
			, trgt.LeaTypeCode = src.LeaTypeCode
			, trgt.LeaTypeDescription = src.LeaTypeDescription
			, trgt.LeaTypeEdFactsCode = src.LeaTypeEdFactsCode
			, trgt.LeaTypeId = src.RefLeaTypeId
			, trgt.OutOfStateIndicator = src.OutOfState
			, trgt.LeaIdentifierNces= src.NCESIdentifier
			, trgt.CharterLeaStatus = src.CharterLeaStatus
			, trgt.ReconstitutedStatus = src.ReconstitutedStatus
			, trgt.RecordEndDateTime = src.RecordEndDateTime 
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
	INSERT (
		  LeaName
		, LeaIdentifierNces
		, LeaIdentifierState
		, SeaName
		, SeaIdentifierState
		, StateANSICode
		, StateAbbreviationCode
		, StateAbbreviationDescription
		, LeaSupervisoryUnionIdentificationNumber
		, LeaOperationalStatus
		, LeaOperationalStatusEdFactsCode
		, OperationalStatusEffectiveDate
		, PriorLeaIdentifierState
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
		, Telephone
		, Website
		, Longitude
		, Latitude
		, CharterLeaStatus
		, ReconstitutedStatus
		, RecordStartDateTime
		, RecordEndDateTime
		) 	
	VALUES (
		  src.Name
		, src.NCESIdentifier
		, src.StateIdentifier
		, @seaName
		, @seaIdentifier
		, @seaIdentifier
		, @stateCode
		, @stateDescription
		, src.SupervisoryUnionIdentificationNumber
		, src.LeaOperationalStatus
		, src.LeaOperationalEdfactsStatus
		, src.OperationalStatusEffectiveDate
		, src.PriorLeaIdentifierState
		, src.ReportedFederally
		, src.LeaTypeCode
		, src.LeaTypeDescription
		, src.LeaTypeEdfactsCode
		, src.RefLeaTypeId
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
		, src.PhysicalAddressState
		, src.PhysicalAddressPostalCode
		, src.TelephoneNumber
		, src.Website
		, src.Longitude
		, src.Latitude
		, src.CharterLeaStatus
		, src.ReconstitutedStatus
		, src.RecordStartDateTime
		, src.RecordEndDateTime
		);

	
	;WITH upd AS(
		SELECT 
			  startd.LeaIdentifierState
			, startd.RecordStartDateTime 
			, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
		FROM rds.DimLeas startd
		JOIN rds.DimLeas endd
			ON startd.LeaIdentifierState = endd.LeaIdentifierState
			AND startd.RecordStartDateTime < endd.RecordStartDateTime
		GROUP BY  startd.LeaIdentifierState, startd.RecordStartDateTime
	) 
	UPDATE lea SET RecordEndDateTime = upd.RecordEndDateTime -1 
	FROM rds.DimLeas lea
	JOIN upd	
		ON lea.LeaIdentifierState = upd.LeaIdentifierState
		AND lea.RecordStartDateTime = upd.RecordStartDateTime
	WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'

		
	;WITH CTE as
	(
	SELECT distinct 
		  dimLea.DimLeaID
		, grades.DimGradeLevelId 
	FROM rds.DimLeas dimLea
	INNER JOIN dbo.OrganizationIdentifier i 
		ON dimLea.LeaIdentifierState = i.Identifier 
		AND i.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
		AND ISNULL(i.RecordEndDateTime, GETDATE()) >= dimLea.RecordStartDateTime
		AND ISNULL(dimLea.RecordEndDateTime, GETDATE()) >= i.RecordStartDateTime
	INNER JOIN dbo.K12Lea lea 
		ON lea.OrganizationId = i.OrganizationId
	INNER JOIN dbo.OrganizationRelationship r 
		ON r.Parent_OrganizationId = lea.OrganizationId
	INNER JOIN dbo.K12School sch 
		ON sch.OrganizationId = r.OrganizationId
	INNER JOIN dbo.K12SchoolGradeOffered g 
		ON g.K12SchoolId = sch.K12SchoolId
	INNER JOIN dbo.RefGradeLevel l 
		ON l.RefGradeLevelId = g.RefGradeLevelId
		AND RefGradeLevelTypeId = (SELECT TOP 1 RefGradeLevelTypeId FROM dbo.RefGradeLevelType WHERE code = '000131')
	INNER JOIN RDS.DimGradeLevels grades 
		ON grades.GradeLevelCode = l.Code
	)
	MERGE rds.BridgeLeaGradeLevels AS trgt
	USING CTE AS src
		ON trgt.LeaId = src.DimLeaId
		AND trgt.GradeLevelId = src.DimGradeLevelId
	WHEN NOT MATCHED THEN
		INSERT (
			  LeaId
			, GradeLevelId
			) 
		VALUES (
			  src.DimLeaID
			, src.DimGradeLevelId
			);

	DROP TABLE #DATECTE
	DROP TABLE #mailingAddress
	DROP TABLE #physicalAddress
END 