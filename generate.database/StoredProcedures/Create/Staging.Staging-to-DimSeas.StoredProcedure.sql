CREATE PROCEDURE [Staging].[Staging-to-DimSeas]
	@factTypeCode AS VARCHAR(50) = 'directory',
	@dataCollectionName AS VARCHAR(50) = NULL,
	@runAsTest AS BIT 
AS 
BEGIN

	--Insert the default 'missing' row if it doesn't exist
	IF NOT EXISTS (SELECT 1 FROM RDS.DimSeas WHERE DimSeaID = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimSeas ON
		INSERT INTO RDS.DimSeas (DimSeaId) VALUES (-1)
		SET IDENTITY_INSERT RDS.DimSeas off
	END

	--create and populate the temp tables for OrganizationType and OrganizationLocationType used in the joins
	CREATE TABLE #organizationTypes (
		  SchoolYear							SMALLINT
		, SeaOrganizationType					VARCHAR(20)
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
		AND OutputCode = 'SEA'

		INSERT INTO #organizationLocationTypes
	SELECT 
		  mail.SchoolYear
		, mail.InputCode
		, phys.InputCode
	FROM (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Mailing') mail
	JOIN (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Physical') phys
		ON mail.SchoolYear = phys.SchoolYear

	--load all the necessary data into the CTE for the MERGE
	;WITH CTE AS 
	( 
		SELECT DISTINCT	
			  ssd.StateCode
			, CASE ssd.StateCode
				WHEN 'AK' THEN 'Alaska'
				WHEN 'AL' THEN 'Alabama'
				WHEN 'AR' THEN 'Arkansas'
				WHEN 'AS' THEN 'American Samoa'
				WHEN 'AZ' THEN 'Arizona'
				WHEN 'CA' THEN 'California'
				WHEN 'CO' THEN 'Colorado'
				WHEN 'CT' THEN 'Connecticut'
				WHEN 'DC' THEN 'District of Columbia'
				WHEN 'DE' THEN 'Delaware'
				WHEN 'FL' THEN 'Florida'
				WHEN 'FM' THEN 'Federated States of Micronesia'
				WHEN 'GA' THEN 'Georgia'
				WHEN 'GU' THEN 'Guam'
				WHEN 'HI' THEN 'Hawaii'
				WHEN 'IA' THEN 'Iowa'
				WHEN 'ID' THEN 'Idaho'
				WHEN 'IL' THEN 'Illinois'
				WHEN 'IN' THEN 'Indiana'
				WHEN 'KS' THEN 'Kansas'
				WHEN 'KY' THEN 'Kentucky'
				WHEN 'LA' THEN 'Louisiana'
				WHEN 'MA' THEN 'Massachusetts'
				WHEN 'MD' THEN 'Maryland'
				WHEN 'ME' THEN 'Maine'
				WHEN 'MH' THEN 'Marshall Islands'
				WHEN 'MI' THEN 'Michigan'
				WHEN 'MN' THEN 'Minnesota'
				WHEN 'MO' THEN 'Missouri'
				WHEN 'MP' THEN 'Northern Marianas'
				WHEN 'MS' THEN 'Mississippi'
				WHEN 'MT' THEN 'Montana'
				WHEN 'NC' THEN 'North Carolina'
				WHEN 'ND' THEN 'North Dakota'
				WHEN 'NE' THEN 'Nebraska'
				WHEN 'NH' THEN 'New Hampshire'
				WHEN 'NJ' THEN 'New Jersey'
				WHEN 'NM' THEN 'New Mexico'
				WHEN 'NV' THEN 'Nevada'
				WHEN 'NY' THEN 'New York'
				WHEN 'OH' THEN 'Ohio'
				WHEN 'OK' THEN 'Oklahoma'
				WHEN 'OR' THEN 'Oregon'
				WHEN 'PA' THEN 'Pennsylvania'
				WHEN 'PR' THEN 'Puerto Rico'
				WHEN 'PW' THEN 'Palau'
				WHEN 'RI' THEN 'Rhode Island'
				WHEN 'SC' THEN 'South Carolina'
				WHEN 'SD' THEN 'South Dakota'
				WHEN 'TN' THEN 'Tennessee'
				WHEN 'TX' THEN 'Texas'
				WHEN 'UT' THEN 'Utah'
				WHEN 'VA' THEN 'Virginia'
				WHEN 'VI' THEN 'Virgin Islands'
				WHEN 'VT' THEN 'Vermont'
				WHEN 'WA' THEN 'Washington'
				WHEN 'WI' THEN 'Wisconsin'
				WHEN 'WV' THEN 'West Virginia'
				WHEN 'WY' THEN 'Wyoming'
				WHEN 'AA' THEN 'Armed Forces America'
				WHEN 'AE' THEN 'Armed Forces Africa, Canada, Europe, and Mideast'
				WHEN 'AP' THEN 'Armed Forces Pacific'
			  END AS StateDescription
			, ssd.SeaName
			, ssd.SeaShortName
			, ssd.SeaStateIdentifier
			, ssd.Sea_WebSiteAddress
			, ssd.SeaContact_FirstName
			, ssd.SeaContact_LastOrSurname
			, ssd.SeaContact_PersonalTitleOrPrefix
			, ssd.SeaContact_ElectronicMailAddress
			, sop.TelephoneNumber
			, ssd.SeaContact_Identifier
			, ssd.SeaContact_PositionTitle
			, smam.AddressStreetNumberAndName AS MailingAddressStreet
			, smam.AddressApartmentRoomOrSuite AS MailingAddressStreet2
			, smam.AddressCity AS MailingAddressCity
			, smam.StateAbbreviation AS MailingAddressState
			, smam.AddressPostalCode AS MailingAddressPostalCode
			, smam.AddressCountyAnsiCode AS MailingCountyAnsiCode
			, smap.AddressStreetNumberAndName AS PhysicalAddressStreet
			, smap.AddressApartmentRoomOrSuite AS PhysicalAddressStreet2
			, smap.AddressCity AS PhysicalAddressCity
			, smap.StateAbbreviation AS PhysicalAddressState
			, smap.AddressPostalCode AS PhysicalAddressPostalCode
			, smap.AddressCountyAnsiCode AS PhysicalCountyAnsiCode
			, ssd.RecordStartDateTime 
			, ssd.RecordEndDateTime 
		FROM Staging.StateDetail ssd
		LEFT JOIN Staging.OrganizationAddress smam
			ON ssd.SeaStateIdentifier = smam.OrganizationIdentifier
			AND smam.AddressTypeForOrganization = (select MailingAddressType from #organizationLocationTypes lt WHERE lt.SchoolYear = smam.SchoolYear)
			AND smam.OrganizationType in (select SeaOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = smam.SchoolYear)
		LEFT JOIN Staging.OrganizationAddress smap
			ON ssd.SeaStateIdentifier = smap.OrganizationIdentifier
			AND smap.AddressTypeForOrganization = (select PhysicalAddressType from #organizationLocationTypes lt WHERE lt.SchoolYear = smap.SchoolYear)
			AND smap.OrganizationType in (select SeaOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = smam.SchoolYear)
		LEFT JOIN Staging.OrganizationPhone sop
			ON ssd.SeaStateIdentifier = sop.OrganizationIdentifier
			AND sop.PrimaryTelephoneNumberIndicator = 1
			AND sop.OrganizationType in (select SeaOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = smam.SchoolYear)
		WHERE @DataCollectionName IS NULL	
			OR ssd.DataCollectionName = @dataCollectionName
	)
	MERGE rds.DimSeas AS trgt
	USING CTE AS src
		ON trgt.SeaIdentifierState = src.SeaStateIdentifier
		AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
	WHEN MATCHED THEN 
		UPDATE SET 
			  [SeaName]						 = src.[SeaName]							
			, [SeaIdentifierState]			 = src.[SeaStateIdentifier]
			, [StateAnsiCode]				 = src.[SeaStateIdentifier]
			, [StateAbbreviationCode]		 = src.[StateCode]
			, [StateAbbreviationDescription] = src.[StateDescription]
			, [MailingAddressCity]			 = src.[MailingAddressCity]
			, [MailingAddressPostalCode]	 = src.[MailingAddressPostalCode]
			, [MailingAddressState]			 = src.[MailingAddressState]
			, [MailingAddressStreet]		 = src.[MailingAddressStreet]
			, [PhysicalAddressCity]			 = src.[PhysicalAddressCity]
			, [PhysicalAddressPostalCode]	 = src.[PhysicalAddressPostalCode]
			, [PhysicalAddressState]		 = src.[PhysicalAddressState]
			, [PhysicalAddressStreet]		 = src.[PhysicalAddressStreet]
			, [Telephone]					 = src.[TelephoneNumber]
			, [Website]						 = src.[Sea_WebSiteAddress]
			, [RecordStartDateTime]			 = src.[RecordStartDateTime]
			, [RecordEndDateTime]			 = src.[RecordEndDateTime]
			, [MailingAddressStreet2]		 = src.[MailingAddressStreet2]
			, [PhysicalAddressStreet2]		 = src.[PhysicalAddressStreet2]
			, [MailingCountyAnsiCode]		 = src.[MailingCountyAnsiCode]
			, [PhysicalCountyAnsiCode]		 = src.[PhysicalCountyAnsiCode]
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
	INSERT (
		  [SeaName]						
		, [SeaIdentifierState]			
		, [StateAnsiCode]				
		, [StateAbbreviationCode]		
		, [StateAbbreviationDescription]
		, [MailingAddressCity]			
		, [MailingAddressPostalCode]	
		, [MailingAddressState]			
		, [MailingAddressStreet]		
		, [PhysicalAddressCity]			
		, [PhysicalAddressPostalCode]	
		, [PhysicalAddressState]		
		, [PhysicalAddressStreet]		
		, [Telephone]					
		, [Website]						
		, [RecordStartDateTime]			
		, [RecordEndDateTime]			
		, [MailingAddressStreet2]		
		, [PhysicalAddressStreet2]		
		, [MailingCountyAnsiCode]		
		, [PhysicalCountyAnsiCode]		
		) 	
	VALUES (
		  src.[SeaName]						
		, src.[SeaStateIdentifier]
		, src.[SeaStateIdentifier]
		, src.[StateCode]
		, src.[StateDescription]
		, src.[MailingAddressCity]
		, src.[MailingAddressPostalCode]
		, src.[MailingAddressState]
		, src.[MailingAddressStreet]
		, src.[PhysicalAddressCity]
		, src.[PhysicalAddressPostalCode]
		, src.[PhysicalAddressState]
		, src.[PhysicalAddressStreet]
		, src.[TelephoneNumber]
		, src.[Sea_WebSiteAddress]
		, src.[RecordStartDateTime]
		, src.[RecordEndDateTime]
		, src.[MailingAddressStreet2]
		, src.[PhysicalAddressStreet2]
		, src.[MailingCountyAnsiCode]
		, src.[PhysicalCountyAnsiCode]
		);

	--update the RecordEndDate of the previous record (if one exists)
	;WITH upd AS(
		SELECT 
			  startd.SeaIdentifierState
			, startd.RecordStartDateTime 
			, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
		FROM rds.DimSeas startd
		JOIN rds.DimSeas endd
			ON startd.SeaIdentifierState = endd.SeaIdentifierState
			AND startd.RecordStartDateTime < endd.RecordStartDateTime
		GROUP BY  startd.SeaIdentifierState, startd.RecordStartDateTime
	) 
	UPDATE sea SET RecordEndDateTime = upd.RecordEndDateTime 
	FROM rds.DimSeas sea
	JOIN upd	
		ON sea.SeaIdentifierState = upd.SeaIdentifierState
		AND sea.RecordStartDateTime = upd.RecordStartDateTime
	
	--cleanup
	DROP TABLE #organizationTypes
	DROP TABLE #organizationLocationTypes

	-----------------------------------------------------
	-- Insert DimK12Staff for State Officer
	-----------------------------------------------------
	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12Staff WHERE DimK12StaffId = -1)
	BEGIN
		--Insert the default 'missing' row if it doesn't exist
		SET IDENTITY_INSERT RDS.DimK12Staff ON
		INSERT INTO RDS.DimK12Staff (DimK12StaffId) VALUES (-1)
		SET IDENTITY_INSERT RDS.DimK12Staff off
	END

	--Create and populate the temp table for staff data	
	CREATE TABLE #K12Staff (
		BirthDate						DATE NULL
		, FirstName						NVARCHAR(50) NULL
		, LastName						NVARCHAR(50) NULL
		, MiddleName					NVARCHAR(50) NULL
		, StaffMemberIdentifierState	NVARCHAR(50) NULL
		, ElectronicMailAddress			NVARCHAR(124) NULL
		, K12StaffRole					NVARCHAR(50) NULL
		, TelephoneNumber				NVARCHAR(24) NULL
		, PositionTitle					VARCHAR(50) NULL
		, RecordStartDateTime			DATETIME	
		, RecordEndDateTime				DATETIME	NULL
	)
		
	declare @k12StaffRole varchar(50) = 'K12 Personnel'

	INSERT INTO #K12Staff
	(
		BirthDate
		, FirstName
		, LastName
		, MiddleName
		, StaffMemberIdentifierState
		, ElectronicMailAddress
		, K12StaffRole
		, TelephoneNumber
		, PositionTitle
		, RecordStartDateTime
		, RecordEndDateTime
	)		
	SELECT DISTINCT
		NULL -- Birthdate
		, SeaContact_FirstName
		, ISNULL(SeaContact_LastOrSurname, 'MISSING') as LastName
		, NULL -- MiddleName
		, SeaContact_Identifier
		, SeaContact_ElectronicMailAddress
		, 'Chief State School Officer' K12StaffRole
		, SeaContact_PhoneNumber TelephoneNumber
		, SeaContact_PositionTitle
		, RecordStartDateTime
		, RecordEndDateTime
	FROM Staging.StateDetail

	MERGE rds.DimK12Staff AS trgt
	USING #K12Staff AS src
			ON  trgt.StaffMemberIdentifierState = src.StaffMemberIdentifierState
			AND ISNULL(trgt.FirstName, '') = ISNULL(src.FirstName, '')
			AND ISNULL(trgt.LastOrSurname, '') = ISNULL(src.LastName, '')
			AND ISNULL(trgt.MiddleName, '') = ISNULL(src.MiddleName, '')
			AND ISNULL(trgt.PositionTitle, '') = ISNULL(src.PositionTitle, '')
			AND ISNULL(trgt.BirthDate, '1900-01-01') = ISNULL(src.BirthDate, '1900-01-01')
			AND trgt.RecordStartDateTime = src.RecordStartDateTime
	WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
	INSERT (
		[BirthDate]
		, [FirstName]
		, LastOrSurname
		, [MiddleName]
		, [StaffMemberIdentifierState]
		, ElectronicMailAddress
		, K12StaffRole
		, TelephoneNumber
		, PositionTitle
		, RecordStartDateTime
		)
	VALUES (
		src.Birthdate
		, src.FirstName
		, src.LastName
		, src.MiddleName
		, src.StaffMemberIdentifierState
		, src.ElectronicMailAddress
		, K12StaffRole
		, TelephoneNumber
		, src.PositionTitle
		, src.RecordStartDateTime
		);

	UPDATE staff 
	SET RecordEndDateTime = NULL
	FROM rds.DimK12Staff staff

	--set the RecordEndDate for previous records (if they exist)
	;WITH upd AS (
		SELECT 
			startd.StaffMemberIdentifierState
			, startd.RecordStartDateTime
			, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
		FROM rds.DimK12Staff startd
		JOIN rds.DimK12Staff endd
			ON startd.StaffMemberIdentifierState = endd.StaffMemberIdentifierState
			AND startd.RecordStartDateTime < endd.RecordStartDateTime
		GROUP BY startd.StaffMemberIdentifierState, startd.RecordStartDateTime
	) 
	UPDATE staff 
	SET RecordEndDateTime = upd.RecordEndDateTime
	FROM rds.DimK12Staff staff
	INNER JOIN upd
		ON staff.StaffMemberIdentifierState = upd.StaffMemberIdentifierState
		AND staff.RecordStartDateTime = upd.RecordStartDateTime
	WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
		AND staff.RecordEndDateTime IS NULL	

	--cleanup
	DROP TABLE #K12Staff

END 