CREATE PROCEDURE [RDS].[Migrate_DimCharterSchoolAuthorizersAndManagementOrgs]
	@factTypeCode AS VARCHAR(50) = 'directory',
	@dataCollectionName AS VARCHAR(50) = NULL,
	@runAsTest AS BIT 
AS   
BEGIN
		/*
			Organization Declarations
		*/
		declare @migrationType as varchar(50)
		declare @dataMigrationTypeId as int
		declare @schoolIdentifierTypeId as int
		declare @schoolSEAIdentificationSystemId as int
		declare @schoolNCESIdentificationSystemId as int
		declare @schoolOrgTypeId as int
		declare @schoolStateIdentifier as VARCHAR(100)
		declare @schoolId as varchar(500)
	
		declare @charterSchoolManagerIdentifierTypeId as int
		declare @charterSchoolManagerIdentificationSystemId as int
		declare @charterSchoolManagerOrganizationIdentifierTypeId as int
		declare @charterSchoolManagerOrganizationIdentificationSystemId as int
		declare @charterAuthorizerIdentificationSystemId as int
		declare @dimDateId as int

		--declare the date table that will be used for the MERGE statements
		declare @MergeDates AS Table (CedsIdentifier int, RecordStartDateTime datetime, SequenceNumber int)
		--declare the temp table for the bridge grade level MERGE
		declare @BridgeGrades AS Table (DimOrgID int, DimGradeLevelId int) 

        declare @mainTelephoneTypeId as int
        select @mainTelephoneTypeId = RefInstitutionTelephoneTypeId
        from dbo.RefInstitutionTelephoneType
        where [Code] = 'Main'

		--DimSchool Seed
		select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
		from dbo.RefOrganizationIdentifierType
		where [Code] = '001073'

		select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

		select @schoolNCESIdentificationSystemId = RefOrganizationIdentificationSystemId
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'NCES'
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
		set @migrationType='rds'

		declare @factTypeId as int
		select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

		declare @organizationElementTypeId as int
		select @organizationElementTypeId = RefOrganizationElementTypeId
		from dbo.RefOrganizationElementType 
		where [Code] = '001156'

		declare @seaOrgTypeId as int
		select @seaOrgTypeId = RefOrganizationTypeId
		from dbo.RefOrganizationType 
		where [Code] = 'SEA' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @leaOrgTypeId as int
		select @leaOrgTypeId = RefOrganizationTypeId
		from dbo.RefOrganizationType 
		where ([Code] = 'LEA') and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @charterSchoolAuthTypeId as int
		select @charterSchoolAuthTypeId = RefOrganizationTypeId
		from dbo.RefOrganizationType 
		where [Code] = 'CharterSchoolAuthorizingOrganization' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @charterSchoolMgrTypeId as int
		select @charterSchoolMgrTypeId = RefOrganizationTypeId
		from dbo.RefOrganizationType 
		where [Code] = 'CharterSchoolManagementOrganization' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @seaIdentifierTypeId as int	
		select @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from dbo.RefOrganizationIdentifierType
		where [Code] = '001491'

		declare @seaFederalIdentificationSystemId as int
		select @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'Federal'
		and RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		declare @leaIdentifierTypeId as int
		select @leaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from dbo.RefOrganizationIdentifierType
		where [Code] = '001072'

		declare @leaNCESIdentificationSystemId as int			
		select @leaNCESIdentificationSystemId = RefOrganizationIdentificationSystemId		
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'NCES' and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		
		declare @leaSEAIdentificationSystemId as int
		select @leaSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId

		declare @gradeLevelTypeId as int = 0
		select @gradeLevelTypeId = RefGradeLevelTypeId 
		from dbo.RefGradeLevelType where code = '000131'

		declare @personnelRole varchar(50) = 'Chief State School Officer'

		-- SEA
		declare @seaOrganizationId as int
		
		select @seaOrganizationId = OrganizationId
		from dbo.OrganizationDetail
		where RefOrganizationTypeId = @seaOrgTypeId

		declare @seaName as varchar(100)

		select @seaName = Name
		from dbo.OrganizationDetail
		where RefOrganizationTypeId = @seaOrgTypeId
		AND RecordEndDateTime IS NULL
		-- State

		declare @seaIdentifier as varchar(50)

		select @seaIdentifier = Identifier
		from dbo.OrganizationIdentifier 
		where OrganizationId = @seaOrganizationId
		and RefOrganizationIdentificationSystemId = @seaFederalIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		declare @stateName as varchar(100)

		select @stateName = [Description]
		from dbo.RefStateAnsicode
		where [Code] = @seaIdentifier

		declare @stateCode as varchar(5)

		select @stateCode = [Code]
		from dbo.RefState
		where [Description] = @stateName

		declare @CSSORoleId as int
		select @CSSORoleId = RoleId
		from dbo.[Role] where Name = 'Chief State School Officer'

		declare @dimSeaId as int, @dimK12StaffId int, @dimLeaId int, @dimSchoolId int, @IsCharterSchool as bit, @leaStateIdentifier as VARCHAR(100)
		
		declare @count as int
		declare @dimCharterSchoolManagementOrganizationId as int
		declare @dimCharterSchoolSecondaryManagementOrganizationId as int
		declare @dimCharterSchoolAuthorizerId as int
		declare @dimCharterSchoolSecondaryAuthorizerId as int

		declare @leaOperationalStatustypeId as int, @schOperationalStatustypeId as int, @charterLeaCount as int

		select @leaOperationalStatustypeId = RefOperationalStatusTypeId from dbo.RefOperationalStatusType where Code = '000174'
		select @schOperationalStatustypeId = RefOperationalStatusTypeId from dbo.RefOperationalStatusType where Code = '000533'
		select @charterLeaCount = count(OrganizationId) from dbo.K12Lea where CharterSchoolIndicator = 1

		--declare @schoolOrgTypeId as int
		select @schoolOrgTypeId = RefOrganizationTypeId
		from dbo.RefOrganizationType 
		where [Code] = 'K12School' and RefOrganizationElementTypeId = @organizationElementTypeId

		select @charterSchoolManagerIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from dbo.RefOrganizationIdentifierType
		where [Code] = '000827'
			
		select @charterSchoolManagerIdentificationSystemId = RefOrganizationIdentificationSystemId
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'Federal'
		and RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

		select @charterAuthorizerIdentificationSystemId = RefOrganizationIdentificationSystemId
		from dbo.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

			BEGIN
	/*
		---DimCharterSchoolManagementOrganizations
		--organizationtype = 30(MO)
	*/

		INSERT INTO @MergeDates
              SELECT
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

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@MergeDates - CharterSchoolManagementOrganization' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @CharterSchoolManagementOrganizationSourceData as table (
			[Name] nvarchar(60) NULL
			, LeaSateIdentifier nvarchar(40) NULL 
			, CharterSchoolManagementOrganizationCode nvarchar(60) NULL
			, CharterSchoolManagementOrganizationTypeDescription nvarchar(100) NULL
			, CharterSchoolManagementOrganizationTypeEdfactsCode  nvarchar(60) NULL -- EdFact			
			, MailingStreet nvarchar(40) NULL
			, MailingCity nvarchar(30) NULL
			, MailingStateCode nvarchar(50) NULL
			, MailingPostalCode nvarchar(17) NULL
			, StreetNumberAndName nvarchar(40) NULL
			, City nvarchar(30) NULL
			, PhysicalStateCode nvarchar(50) NULL
			, PostalCode nvarchar(17) NULL
			, TelephoneNumber nvarchar(24) NULL
			, Website nvarchar(300) NULL
			, Code nvarchar(60) NULL
			, OutOfStateIndicator bit NULL
			, StateCode nvarchar(5) NULL 
			, StateANSICode nvarchar(60) NULL
			, [State] nvarchar(100) NULL
			, SchoolStateIdentifier nvarchar(40) NULL			
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @CharterSchoolManagementOrganizationSourceData
		SELECT DISTINCT	o.Name, i.Identifier AS LeaSateIdentifier, 
			charterSchoolApprovalAgencyType.Code AS CharterSchoolManagementOrganizationCode,
			charterSchoolApprovalAgencyType.[Description] AS CharterSchoolManagementOrganizationTypeDescription,			
			CASE 
				WHEN (startDate.RecordStartDateTime > '7/1/2019' AND charterSchoolApprovalAgencyType.Code IN ('CMO','EMO','SMNP','SMFP')) THEN 'CHAR' + charterSchoolApprovalAgencyType.Code
				ELSE charterSchoolApprovalAgencyType.Code
			END AS CharterSchoolManagementOrganizationTypeEdfactsCode, -- EdFact			
			CASE WHEN mailingAddress.StreetNumberAndName IS NULL and mailingAddress.City IS NOT NULL and mailingAddress.StateCode IS NOT NULL 
			and mailingAddress.PostalCode IS NOT NULL 
			THEN 'No Street Address' ELSE  mailingAddress.StreetNumberAndName  END AS MailingStreet, 
			mailingAddress.City AS MailingCity,	mailingAddress.StateCode AS MailingStateCode, mailingAddress.PostalCode AS MailingPostalCode, 
			CASE WHEN  (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City IS NULL or physicalAddress.StateCode IS NULL or physicalAddress.PostalCode IS NULL  THEN NULL ELSE 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 THEN NULL ELSE physicalAddress.StreetNumberAndName	END	END AS StreetNumberAndName,
			CASE WHEN (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('Po Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City IS NULL or physicalAddress.StateCode IS NULL or physicalAddress.PostalCode IS NULL  THEN NULL ELSE 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 THEN NULL ELSE physicalAddress.City	END	END AS City,
			CASE WHEN (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City IS NULL or physicalAddress.StateCode IS NULL or physicalAddress.PostalCode IS NULL  THEN NULL ELSE 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 THEN NULL ELSE physicalAddress.StateCode END END AS PhysicalStateCode,
			CASE WHEN (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0 ) 
			or physicalAddress.City IS NULL or physicalAddress.StateCode IS NULL or physicalAddress.PostalCode IS NULL THEN NULL ELSE 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 THEN NULL ELSE physicalAddress.PostalCode END END AS PostalCode,
			phone.TelephoneNumber,website.Website,charterSchoolApprovalAgencyType.Code, 1 as OutOfStateIndicator,
			@stateCode as StateCode, @seaIdentifier as StateANSICode, @stateName as [State],
			schoolStateIdentifier.Identifier AS SchoolStateIdentifier,			
			startDate.RecordStartDateTime AS RecordStartDateTime,
			endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
		LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join dbo.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
			AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join dbo.K12CharterSchoolManagementOrganization d 
			on d.OrganizationId = O.OrganizationId 
			AND o.RefOrganizationTypeId = @charterSchoolMgrTypeId 
		left outer join dbo.K12School s 
			on s.K12CharterSchoolManagementOrganizationId = d.K12CharterSchoolManagementOrganizationId
		inner join dbo.RefCharterSchoolManagementOrganizationType charterSchoolApprovalAgencyType 
			on charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId = d.RefCharterSchoolManagementOrganizationTypeId	
		inner join dbo.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId
		inner join dbo.OrganizationIdentifier schoolStateIdentifier 
			on s.OrganizationId = schoolStateIdentifier.OrganizationId
			and schoolStateIdentifier.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
			and schoolStateIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		inner join dbo.RefOrganizationIdentificationSystem aaa 
			on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
			and aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId
		inner join dbo.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId																	
			left join dbo.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join dbo.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code AS StateCode,  PostalCode 
				from dbo.OrganizationLocation ol
				inner join dbo.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join dbo.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 1 -- mailing
			) mailingAddress 
			on mailingAddress.OrganizationId = d.OrganizationId
		left join 
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code AS StateCode, PostalCode 
				from dbo.OrganizationLocation ol
				inner join dbo.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join dbo.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 2 -- Physical
			) physicalAddress 
			on physicalAddress.OrganizationId = d.OrganizationId		


		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@CharterSchoolManagementOrganizationSourceData' as TableName, * 
			from @CharterSchoolManagementOrganizationSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimCharterSchoolManagementOrganizations AS trgt
		USING @CharterSchoolManagementOrganizationSourceData AS src
				ON trgt.StateIdentifier = src.LeaSateIdentifier
				AND trgt.SchoolStateIdentifier = src.SchoolStateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
			Update SET trgt.Name = src.Name,
						trgt.StateCode = src.StateCode,
						trgt.StateANSICode = src.StateANSICode,
						trgt.[State] = src.[State],						
						trgt.CharterSchoolManagementOrganizationCode = src.CharterSchoolManagementOrganizationCode,
						trgt.CharterSchoolManagementOrganizationTypeDescription = src.CharterSchoolManagementOrganizationTypeDescription,
						trgt.CharterSchoolManagementOrganizationTypeEdfactsCode = src.CharterSchoolManagementOrganizationTypeEdfactsCode,
						trgt.MailingAddressStreet = src.MailingStreet,
						trgt.MailingAddressCity = src.MailingCity,
						trgt.MailingAddressState = src.MailingStateCode,
						trgt.MailingAddressPostalCode = src.MailingPostalCode,
						trgt.OutOfStateIndicator = src.OutOfStateIndicator,
						trgt.PhysicalAddressStreet = src.StreetNumberAndName,
						trgt.PhysicalAddressCity = src.City,
						trgt.PhysicalAddressState = src.PhysicalStateCode,
						trgt.PhysicalAddressPostalCode = src.PostalCode,
						trgt.Telephone = src.TelephoneNumber,
						trgt.Website = src.Website,
						trgt.SchoolStateIdentifier = src.SchoolStateIdentifier,						
						trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT(Name,StateIdentifier,StateCode,StateANSICode,[State],
		CharterSchoolManagementOrganizationCode,CharterSchoolManagementOrganizationTypeDescription,CharterSchoolManagementOrganizationTypeEdfactsCode,MailingAddressStreet,
		MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
		OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,PhysicalAddressPostalCode,
		Telephone,Website,SchoolStateIdentifier,RecordStartDateTime,RecordEndDateTime)
		VALUES(src.Name,src.LeaSateIdentifier, @stateCode, @seaIdentifier, @stateName,
			src.CharterSchoolManagementOrganizationCode,src.CharterSchoolManagementOrganizationTypeDescription,src.CharterSchoolManagementOrganizationTypeEdfactsCode,
			src.MailingStreet,	src.MailingCity,src.MailingStateCode,src.MailingPostalCode,src.OutOfStateIndicator,src.StreetNumberAndName,
			src.City,src.PhysicalStateCode,src.PostalCode,src.TelephoneNumber,src.Website,src.SchoolStateIdentifier,
			src.RecordStartDateTime,src.RecordEndDateTime);

		;WITH upd AS(
			SELECT DimCharterSchoolManagementOrganizationId, StateIdentifier, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimCharterSchoolManagementOrganizations  
			WHERE RecordEndDateTime is null 
			and DimCharterSchoolManagementOrganizationId <> -1 
		) 
		UPDATE charter SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimCharterSchoolManagementOrganizations charter
		inner join upd	
			on charter.DimCharterSchoolManagementOrganizationId = upd.DimCharterSchoolManagementOrganizationId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'DimCharterSchoolManagementOrganizations' as TableName, * from rds.DimCharterSchoolManagementOrganizations
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates

	END

	-- DimCharterSchoolAuthorizers
	BEGIN
	/*
		-- DimCharterSchoolAuthorizers
	*/

		INSERT INTO @MergeDates
              SELECT
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

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@MergeDates - CharterSchoolAuthorizers' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @CharterSchoolAuthorizersSourceData as table (
			[Name] nvarchar(60) NULL
			, LeaSateIdentifier nvarchar(40) NULL 
			, CharterSchoolAuthorizerTypeCode nvarchar(60) NULL
			, CharterSchoolAuthorizerTypeDescription nvarchar(100) NULL
			, CharterSchoolAuthorizerTypeEdfactsCode  nvarchar(60) NULL -- EdFact
			, RefCharterSchoolApprovalAgencyTypeId int NULL
			, MailingStreet nvarchar(40) NULL
			, MailingCity nvarchar(30) NULL
			, MailingStateCode nvarchar(50) NULL
			, MailingPostalCode nvarchar(17) NULL
			, StreetNumberAndName nvarchar(40) NULL
			, City nvarchar(30) NULL
			, PhysicalStateCode nvarchar(50) NULL
			, PostalCode nvarchar(17) NULL
			, TelephoneNumber nvarchar(24) NULL
			, Website nvarchar(300) NULL
			, Code nvarchar(60) NULL
			, OutOfStateIndicator bit NULL
			, StateCode nvarchar(5) NULL 
			, StateANSICode nvarchar(60) NULL
			, [State] nvarchar(100) NULL
			, SchoolStateIdentifier nvarchar(40) NULL
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @CharterSchoolAuthorizersSourceData
		SELECT DISTINCT	o.[Name], i.Identifier as LeaSateIdentifier, charterSchoolAuthorizerType.Code as CharterSchoolAuthorizerTypeCode,	
			charterSchoolAuthorizerType.[Description] as CharterSchoolAuthorizerTypeDescription,
			charterSchoolAuthorizerType.Code as CharterSchoolAuthorizerTypeEdfactsCode, -- EdFact
			charterSchoolAuthorizerType.RefCharterSchoolAuthorizerTypeId,
			Case when mailingAddress.StreetNumberAndName is null and mailingAddress.City is not null and mailingAddress.StateCode is not null 
			and mailingAddress.PostalCode is not null then 'No Street Address' else  mailingAddress.StreetNumberAndName  end as MailingStreet, 
			mailingAddress.City AS MailingCity, 
			mailingAddress.StateCode as MailingStateCode, 
			mailingAddress.PostalCode as MailingPostalCode, 
			case when  (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City is null or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StreetNumberAndName	end	end as StreetNumberAndName,
			case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('Po Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City is null or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.City	end	end as City,
			case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) 
			or physicalAddress.City is null or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StateCode
				end	
					end as PhysicalStateCode,
			case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0 )
				or physicalAddress.City is null 
				or physicalAddress.StateCode is null or physicalAddress.PostalCode is null then null else 
			CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.PostalCode
				end	
				end as PostalCode,			
			phone.TelephoneNumber,
			website.Website,
			charterSchoolAuthorizerType.Code, 1 as OutOfStateIndicator,
			@stateCode as StateCode, @seaIdentifier as StateANSICode, @stateName as [State],
			schoolStateIdentifier.Identifier AS SchoolStateIdentifier,
			startDate.RecordStartDateTime AS RecordStartDateTime,
			endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
        LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join dbo.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join dbo.OrganizationRelationship orgrel
			ON o.OrganizationId = orgrel.Parent_OrganizationId
		inner join dbo.K12CharterSchoolAuthorizer d 
			on d.OrganizationId = orgrel.Parent_OrganizationId
				and o.RefOrganizationTypeId = @charterSchoolAuthTypeId 
		left outer join dbo.K12School s on orgrel.OrganizationId = s.OrganizationId
		inner join dbo.RefCharterSchoolAuthorizerType charterSchoolAuthorizerType 
			on charterSchoolAuthorizerType.RefCharterSchoolAuthorizerTypeId = d.RefCharterSchoolAuthorizerTypeId	
		inner join dbo.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId
		inner join dbo.RefOrganizationIdentificationSystem aaa 
			on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
			and aaa.RefOrganizationIdentificationSystemId=@charterAuthorizerIdentificationSystemId
		inner join dbo.OrganizationIdentifier schoolStateIdentifier 
			on s.OrganizationId = schoolStateIdentifier.OrganizationId
			and schoolStateIdentifier.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
			and schoolStateIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		inner join dbo.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId
		left join dbo.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join dbo.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode 
				from dbo.OrganizationLocation ol
				inner join dbo.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join dbo.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 1 -- mailing
			) mailingAddress 
			on mailingAddress.OrganizationId = o.OrganizationId
		left join 
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  
				from dbo.OrganizationLocation ol
				inner join dbo.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join dbo.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 2 -- Physical
			) physicalAddress 
			on physicalAddress.OrganizationId = o.OrganizationId

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@CharterSchoolAuthorizerSourceData' as TableName, * from @CharterSchoolAuthorizersSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimCharterSchoolAuthorizers AS trgt
		USING @CharterSchoolAuthorizersSourceData AS src
				ON trgt.StateIdentifier = src.LeaSateIdentifier
				AND trgt.SchoolStateIdentifier = src.SchoolStateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
			Update SET trgt.Name = src.Name,							
						trgt.StateCode = src.StateCode,
						trgt.StateANSICode = src.StateANSICode,
						trgt.[State] = src.[State],												
						trgt.CharterSchoolAuthorizerTypeCode = src.CharterSchoolAuthorizerTypeCode,
						trgt.CharterSchoolAuthorizerTypeDescription = src.CharterSchoolAuthorizerTypeDescription,
						trgt.CharterSchoolAuthorizerTypeEdFactsCode = src.CharterSchoolAuthorizerTypeEdFactsCode,						
						trgt.MailingAddressStreet = src.MailingStreet,
						trgt.MailingAddressCity = src.MailingCity,
						trgt.MailingAddressState = src.MailingStateCode,
						trgt.MailingAddressPostalCode = src.MailingPostalCode,
						trgt.OutOfStateIndicator = src.OutOfStateIndicator,
						trgt.PhysicalAddressStreet = src.StreetNumberAndName,
						trgt.PhysicalAddressCity = src.City,
						trgt.PhysicalAddressState = src.PhysicalStateCode,
						trgt.PhysicalAddressPostalCode = src.PostalCode,
						trgt.Telephone = src.TelephoneNumber,
						trgt.Website = src.Website,
						trgt.SchoolStateIdentifier = src.SchoolStateIdentifier,
						trgt.RecordEndDateTime = src.RecordEndDateTime, 
						trgt.IsApproverAgency = 'No'
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT(Name,StateIdentifier,StateCode,StateANSICode,[State],
				CharterSchoolAuthorizerTypeCode,CharterSchoolAuthorizerTypeDescription,CharterSchoolAuthorizerTypeEdFactsCode,MailingAddressStreet,
				MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
				OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,
				PhysicalAddressPostalCode,Telephone,Website,SchoolStateIdentifier,RecordStartDateTime,RecordEndDateTime,IsApproverAgency)
		VALUES(src.Name,src.LeaSateIdentifier, @stateCode, @seaIdentifier, @stateName,
				src.CharterSchoolAuthorizerTypeCode,src.CharterSchoolAuthorizerTypeDescription,src.CharterSchoolAuthorizerTypeEdFactsCode,
				src.MailingStreet,src.MailingCity,src.MailingStateCode,src.MailingPostalCode,src.OutOfStateIndicator,
				src.StreetNumberAndName,src.City,src.PhysicalStateCode,src.PostalCode,
				src.TelephoneNumber,src.Website,src.SchoolStateIdentifier,src.RecordStartDateTime,src.RecordEndDateTime,'No');

		;WITH upd AS(
			SELECT 
				startd.SchoolStateIdentifier
				, startd.StateIdentifier
				, startd.RecordStartDateTime
				, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime 
			FROM rds.DimCharterSchoolAuthorizers startd
			JOIN rds.DimCharterSchoolAuthorizers endd
				ON startd.SchoolStateIdentifier = endd.SchoolStateIdentifier
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY startd.SchoolStateIdentifier, startd.StateIdentifier, startd.RecordStartDateTime
		) 
		UPDATE charter SET RecordEndDateTime = upd.RecordEndDateTime -1 
		FROM rds.DimCharterSchoolAuthorizers charter
		JOIN upd	
			ON charter.SchoolStateIdentifier = upd.SchoolStateIdentifier
			AND charter.StateIdentifier = upd.StateIdentifier
			AND charter.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'DimCharterSchoolAuthorizer' as TableName, * from rds.DimCharterSchoolAuthorizers
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates

	END

END