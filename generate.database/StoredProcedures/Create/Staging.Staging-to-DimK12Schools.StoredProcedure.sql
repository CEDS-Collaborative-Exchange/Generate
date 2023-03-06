CREATE PROCEDURE [Staging].[Staging-to-DimK12Schools]
	@dataCollectionName AS VARCHAR(50) = NULL,
	@runAsTest AS BIT 
AS 
BEGIN

	declare @StateCode varchar(2), @StateName varchar(50), @StateANSICode varchar(5)
	select @StateCode = (select StateCode from Staging.StateDetail)
	select @StateName = (select [Description] from dbo.RefState where Code = @StateCode)
	select @StateANSICode = (select Code from dbo.RefStateANSICode where [Description] = @StateName)


	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12Schools WHERE DimK12SchoolId = -1)
	BEGIN
		SET IDENTITY_INSERT RDS.DimK12Schools ON
		INSERT INTO RDS.DimK12Schools (DimK12SchoolId) VALUES (-1)
		SET IDENTITY_INSERT RDS.DimK12Schools off
	END

	CREATE TABLE #organizationTypes (
		  SchoolYear							SMALLINT
		, K12SchoolOrganizationType				VARCHAR(20)
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
		AND OutputCode = 'K12School'

	INSERT INTO #organizationLocationTypes
	SELECT 
		  mail.SchoolYear
		, mail.InputCode
		, phys.InputCode
	FROM (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Mailing') mail
	JOIN (SELECT SchoolYear, InputCode FROM Staging.SourceSystemReferenceData WHERE TableName = 'RefOrganizationLocationType' AND OutputCode = 'Physical') phys
		ON mail.SchoolYear = phys.SchoolYear


	CREATE TABLE #K12Schools (
		  StateCode								CHAR(2)
		, SeaName								VARCHAR(250)
		, SeaShortName							VARCHAR(200)
		, SeaIdentifierState					VARCHAR(7)
		, IeuName								VARCHAR(200)
		, IeuStateIdentifier					VARCHAR(50)
		, LeaIdentifierNces						VARCHAR(50)
		, LeaIdentifierState					VARCHAR(50)
		, PriorLEAIdentifierState				varchar(50) -- CIID-4060
		, LeaOrganizationName					VARCHAR(200)
		, SchoolIdentifierNces					VARCHAR(50)
		, SchoolIdentifierState					VARCHAR(50)
		, PriorSchoolIdentifierState			VARCHAR(50) -- CIID-4060
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
		, AdministrativeFundingControlCode		nvarchar(50)
		, AdministrativeFundingControlDescription		NVARCHAR(200)
		, RecordStartDateTime					DATETIME
		, RecordEndDateTime						DATETIME
		)
		CREATE CLUSTERED INDEX IX_K12Schools ON #K12Schools (SchoolIdentifierState, RecordStartDateTime)

		INSERT INTO #K12Schools
		SELECT DISTINCT
			  ssd.StateCode
			, ssd.SeaName
			, @StateName 'StateAbbreviationDescription'
			, ssd.SeaStateIdentifier
			, sko.IEU_Name
			, sko.IEU_Identifier_State
			, sko.LEA_Identifier_NCES
			, sko.LEA_Identifier_State
			, sko.Prior_LEA_Identifier_State -- CIID-4060
			, sko.LEA_Name
			, sko.School_Identifier_NCES
			, sko.School_Identifier_State
			, sko.Prior_School_Identifier_State -- CIID-4060
			, sko.School_Name
			, sssrd1.OutputCode -- SchoolOperationalStatus
			, CASE sssrd1.OutputCode
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
			, sko.School_OperationalStatusEffectiveDate
			, sko.School_CharterSchoolIndicator
			, sko.School_CharterContractApprovalDate
			, sko.School_CharterContractRenewalDate
			, sko.School_CharterContractIDNumber
			, sko.School_IsReportedFederally
			, sssrd2.OutputCode AS LeaTypeCode-- LEA_Type
			, CASE sssrd2.OutputCode 
				 WHEN 'RegularNotInSupervisoryUnion' THEN 'Regular public school district that is NOT a component of a supervisory union'
				 WHEN 'RegularInSupervisoryUnion' THEN 'Regular public school district that is a component of a supervisory union'
				 WHEN 'SupervisoryUnion' THEN ' Supervisory Union'
				 WHEN 'SpecializedPublicSchoolDistrict' THEN 'Specialized Public School District'
				 WHEN 'ServiceAgency' THEN 'Service Agency'
				 WHEN 'StateOperatedAgency' THEN 'State Operated Agency'
				 WHEN 'FederalOperatedAgency' THEN 'Federal Operated Agency'
				 WHEN 'Other' THEN 'Other Local Education Agencies'
				 WHEN 'IndependentCharterDistrict' THEN 'Independent Charter District'
				 ELSE null
			   END AS LeaTypeDescription
			, CASE sssrd2.OutputCode 
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
			, null AS LeaTypeId
			, smam.AddressStreetNumberAndName AS MailingAddressStreet
			, smam.AddressApartmentRoomOrSuite AS MailingAddressStreet2
			, smam.AddressCity AS MailingAddressCity
			, smam.StateAbbreviation AS MailingAddressState
			, smam.AddressPostalCode AS MailingAddressPostalCode
			, smam.AddressCountyAnsiCode AS MailingAddressCountyAnsiCode
			, CASE 
				WHEN smam.StateAbbreviation <> smap.StateAbbreviation THEN 1
				ELSE 0
			  END AS OutOfState
			, smap.AddressStreetNumberAndName AS PhysicalAddressStreet
			, smap.AddressApartmentRoomOrSuite AS PhysicalAddressStreet2			
			, smap.AddressCity AS PhysicalAddressCity
			, smap.StateAbbreviation AS PhysicalAddressState
			, smap.AddressPostalCode AS PhysicalAddressPostalCode
			, smap.AddressCountyAnsiCode AS PhysicalAddressCountyAnsiCode
			, NULL
			, NULL
			, sssrd3.OutputCode -- School_Type
			, CASE sssrd3.OutputCode 
				WHEN 'Regular' THEN 'Regular School'
				WHEN 'Special' THEN 'Special Education School'
				WHEN 'CareerAndTechnical' THEN 'Career and Technical Education School'
				WHEN 'Alternative' THEN 'Alternative Education School'
				WHEN 'Reportable' THEN 'Reportable Program'
				ELSE NULL
			  END AS SchoolTypeDescription
			, CASE sssrd3.OutputCode 
				WHEN 'Regular' THEN 1
				WHEN 'Special' THEN 2
				WHEN 'CareerAndTechnical' THEN 3
				WHEN 'Alternative' THEN 4
				WHEN 'Reportable' THEN 5
				ELSE -1
			  END AS SchoolTypeEdfactsCode
			, null --SchoolTypeId
			, sop.TelephoneNumber
			, sko.School_WebSiteAddress
			, CASE
				WHEN School_CharterSchoolIndicator IS NULL THEN 'MISSING'
				WHEN School_CharterSchoolIndicator = 1 THEN 'YES'
				WHEN School_CharterSchoolIndicator = 0 THEN 'NO'
			  END AS CharterSchoolStatus
			, sssrd4.OutputCode -- School_ReconstitutedStatus
			, sssrd5.OutputCode -- Administrative Funding Control Code
			, CASE sssrd5.OutputCode -- Administrative Funding Control Description
				WHEN 'Public' THEN 'Public School'
				WHEN 'Private' THEN 'Private School'
				WHEN 'Other' THEN 'Other'
			  END 
			, sko.School_RecordStartDateTime
			, sko.School_RecordEndDateTime
		FROM Staging.K12Organization sko
		CROSS JOIN Staging.StateDetail ssd
		LEFT JOIN Staging.OrganizationAddress smam
			ON sko.School_Identifier_State = smam.OrganizationIdentifier
			AND smam.AddressTypeForOrganization = (select MailingAddressType from #organizationLocationTypes lt WHERE lt.SchoolYear = smam.SchoolYear)
			AND smam.OrganizationType in (select K12SchoolOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = smam.SchoolYear)
		LEFT JOIN Staging.OrganizationAddress smap
			ON sko.School_Identifier_State = smap.OrganizationIdentifier
			AND smap.AddressTypeForOrganization = (select PhysicalAddressType from #organizationLocationTypes lt WHERE lt.SchoolYear = smam.SchoolYear)
			AND smap.OrganizationType in (select K12SchoolOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = smap.SchoolYear)
		LEFT JOIN Staging.OrganizationPhone sop
			ON sko.School_Identifier_State = sop.OrganizationIdentifier
			AND sop.OrganizationType in (select K12SchoolOrganizationType from #organizationTypes ot WHERE ot.SchoolYear = sop.SchoolYear)
			AND isnull(sko.DataCollectionName,'') = isnull(sop.DataCollectionName,'')
		LEFT JOIN staging.SourceSystemReferenceData sssrd1
			ON sko.School_OperationalStatus = sssrd1.InputCode
			AND sssrd1.TableName = 'RefOperationalStatus'
			AND sssrd1.TableFilter = '000533'
			AND sko.SchoolYear = sssrd1.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd2
			ON sko.LEA_Type = sssrd2.InputCode
			AND sssrd2.TableName = 'RefLeaType'
			AND sko.SchoolYear = sssrd2.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd3
			ON sko.School_Type = sssrd3.InputCode
			AND sssrd3.TableName = 'RefSchoolType'
			AND sko.SchoolYear = sssrd3.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd4
			ON sko.School_ReconstitutedStatus = sssrd4.InputCode
			AND sssrd4.TableName = 'RefReconstitutedStatus'
			AND sko.SchoolYear = sssrd4.SchoolYear
		LEFT JOIN staging.SourceSystemReferenceData sssrd5
			ON sko.AdministrativeFundingControl = sssrd5.InputCode
			AND sssrd5.TableName = 'RefAdministrativeFundingControl'
			AND sko.SchoolYear = sssrd5.SchoolYear
		WHERE @DataCollectionName IS NULL	
			OR (
					sko.DataCollectionName = @dataCollectionName
				AND ssd.DataCollectionName = @dataCollectionName
				AND smam.DataCollectionName = @dataCollectionName
				AND smap.DataCollectionName = @dataCollectionName
				AND sop.DataCollectionName = @dataCollectionName
			)


	-- SchoolIdentifierState and RecordStartDateTime must always be unique in Staging.K12Organaization
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
					trgt.PriorLEAIdentifierState = src.PriorLEAIdentifierState, --CIID-4060
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
					trgt.PriorSchoolIdentifierState = src.PriorSchoolIdentifierState, --CIID-4060
					trgt.CharterSchoolStatus = src.CharterSchoolStatus,
					trgt.ReconstitutedStatus = src.ReconstitutedStatus,
					trgt.AdministrativeFundingControlCode = src.AdministrativeFundingControlCode,
					trgt.AdministrativeFundingControlDescription = src.AdministrativeFundingControlDescription,
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
		, PriorLEAIdentifierState --CIID-4060
		, LeaName
		, SchoolIdentifierNces
		, SchoolIdentifierState
		, PriorSchoolIdentifierState --CIID-4060
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
		, AdministrativeFundingControlCode
		, AdministrativeFundingControlDescription
		, RecordStartDateTime
		, RecordEndDateTime) 
	VALUES(
		  src.IeuName
		, src.IeuStateIdentifier
		, src.StateCode
		, @StateName
		, @StateANSICode
		, NULL	-- Remove this field (SEAOrganizationId)
		, src.SeaName
		, src.SeaIdentifierState
		, src.LeaIdentifierNces
		, src.LeaIdentifierState
		, src.PriorLEAIdentifierState --CIID-4060
		, src.LeaOrganizationName
		, src.SchoolIdentifierNces
		, src.SchoolIdentifierState
		, src.PriorSchoolIdentifierState --CIID-4060
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
		, src.AdministrativeFundingControlCode
		, src.AdministrativeFundingControlDescription
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


-- School Grade Levels
	CREATE TABLE #gradeLevels
	(
		  DimK12SchoolId INT
		, DimGradeLevelId INT
	)

	INSERT INTO #gradeLevels
	SELECT distinct 
		  rdks.DimK12SchoolId
		, rdgl.DimGradeLevelId 
	FROM rds.DimK12Schools rdks
	JOIN staging.OrganizationGradeOffered  sogo
		ON rdks.SchoolIdentifierState = sogo.OrganizationIdentifier
		AND rdks.RecordStartDateTime = sogo.RecordStartDateTime
		-- Record Start/End Dates must match between Staging.K12Organization and Staging.OrganizationGradesOffered
		AND ISNULL(rdks.RecordEndDateTime, '01/01/1900') = ISNULL(sogo.RecordEndDateTime, isnull(rdks.RecordEndDateTime, '01/01/1900'))
	JOIN rds.vwDimGradeLevels rdgl
		ON sogo.GradeOffered = rdgl.GradeLevelMap
		AND rdgl.GradeLevelTypeCode = '000131'
		and sogo.SchoolYear = rdgl.SchoolYear

	MERGE rds.BridgeK12SchoolGradeLevels AS trgt
	USING #gradeLevels AS src
					ON trgt.K12SchoolId = src.DimK12SchoolId
					AND trgt.GradeLevelId = src.DimGradeLevelId
	WHEN NOT MATCHED THEN
	INSERT(K12SchoolId, GradeLevelId) values(src.DimK12SchoolId, src.DimGradeLevelId);


-- LEA Grade Levels
-- Need to do this here because if you do it in Staging-to-DimLEAs and that runs before Staging-to-DimK12Schools, there may be no records in RDS.DimK12Schools to join to.
		
	;WITH CTE as
	(
	SELECT 
	distinct 
		  rdl.DimLeaID
		, rdgl.DimGradeLevelId 
	FROM RDS.DimK12Schools rdks
	JOIN RDS.DimLeas rdl
		ON rdks.LeaIdentifierState = rdl.LeaIdentifierState
		AND rdks.RecordStartDateTime BETWEEN rdl.RecordStartDateTime AND ISNULL(rdl.RecordEndDateTime, GETDATE())
	JOIN Staging.K12Organization sko
		on sko.LEA_Identifier_State = rdl.LeaIdentifierState
		and rdks.SchoolIdentifierState = sko.School_Identifier_State
	JOIN Staging.OrganizationGradeOffered sogo
		ON rdks.SchoolIdentifierState = sogo.OrganizationIdentifier
		
	JOIN RDS.vwDimGradeLevels rdgl
		ON sogo.GradeOffered = rdgl.GradeLevelMap
		AND rdgl.GradeLevelTypeCode = '000131'
		AND rdgl.SchoolYear = sogo.SchoolYear	
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

	DROP TABLE #K12Schools
	DROP TABLE #gradeLevels
	DROP TABLE #organizationTypes
	DROP TABLE #organizationLocationTypes
END