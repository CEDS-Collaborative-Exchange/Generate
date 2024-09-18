CREATE PROCEDURE [RDS].[Migrate_OrganizationCounts]
	@factTypeCode as varchar(50) = 'directory',
	@runAsTest as bit 

AS   
BEGIN
-- migrate_OrganizationCounts
begin try
begin transaction	

	-- Variable Declarations
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
        from ODS.RefInstitutionTelephoneType
        where [Code] = 'Main'

		--DimSchool Seed
		select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
		from ods.RefOrganizationIdentifierType
		where [Code] = '001073'

		select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

		select @schoolNCESIdentificationSystemId = RefOrganizationIdentificationSystemId
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'NCES'
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
		set @migrationType='rds'

		declare @factTypeId as int
		select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode

		declare @organizationElementTypeId as int
		select @organizationElementTypeId = RefOrganizationElementTypeId
		from ods.RefOrganizationElementType 
		where [Code] = '001156'

		declare @seaOrgTypeId as int
		select @seaOrgTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where [Code] = 'SEA' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @leaOrgTypeId as int
		select @leaOrgTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where ([Code] = 'LEA') and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @charterSchoolAuthTypeId as int
		select @charterSchoolAuthTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where [Code] = 'CharterSchoolAuthorizingOrganization' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @charterSchoolMgrTypeId as int
		select @charterSchoolMgrTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where [Code] = 'CharterSchoolManagementOrganization' and RefOrganizationElementTypeId = @organizationElementTypeId

		declare @seaIdentifierTypeId as int	
		select @seaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from ods.RefOrganizationIdentifierType
		where [Code] = '001491'

		declare @seaFederalIdentificationSystemId as int
		select @seaFederalIdentificationSystemId = RefOrganizationIdentificationSystemId			
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'Federal'
		and RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		declare @leaIdentifierTypeId as int
		select @leaIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from ods.RefOrganizationIdentifierType
		where [Code] = '001072'

		declare @leaNCESIdentificationSystemId as int			
		select @leaNCESIdentificationSystemId = RefOrganizationIdentificationSystemId		
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'NCES' and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		
		declare @leaSEAIdentificationSystemId as int
		select @leaSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId

		declare @gradeLevelTypeId as int = 0
		select @gradeLevelTypeId = RefGradeLevelTypeId 
		from ods.RefGradeLevelType where code = '000131'

		declare @personnelRole varchar(50) = 'Chief State School Officer'

		-- SEA
		declare @seaOrganizationId as int
		
		select @seaOrganizationId = OrganizationId
		from ods.OrganizationDetail
		where RefOrganizationTypeId = @seaOrgTypeId

		declare @seaName as varchar(100)

		select @seaName = Name
		from ods.OrganizationDetail
		where RefOrganizationTypeId = @seaOrgTypeId
		AND RecordEndDateTime IS NULL
		-- State

		declare @seaIdentifier as varchar(50)

		select @seaIdentifier = Identifier
		from ods.OrganizationIdentifier 
		where OrganizationId = @seaOrganizationId
		and RefOrganizationIdentificationSystemId = @seaFederalIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @seaIdentifierTypeId

		declare @stateName as varchar(100)

		select @stateName = StateName
		from ods.RefStateAnsicode
		where [Code] = @seaIdentifier

		declare @stateCode as varchar(5)

		select @stateCode = [Code]
		from ods.RefState
		where [Description] = @stateName

		declare @CSSORoleId as int
		select @CSSORoleId = RoleId
		from ods.[Role] where Name = 'Chief State School Officer'

		declare @dimSeaId as int, @dimPersonnelId int, @dimLeaId int, @dimSchoolId int, @IsCharterSchool as bit, @leaStateIdentifier as VARCHAR(100)
		
		declare @count as int
		declare @dimCharterSchoolManagementOrganizationId as int
		declare @dimCharterSchoolSecondaryManagementOrganizationId as int
		declare @dimCharterSchoolAuthorizerId as int
		declare @dimCharterSchoolSecondaryAuthorizerId as int

		declare @leaOperationalStatustypeId as int, @schOperationalStatustypeId as int, @charterLeaCount as int

		select @leaOperationalStatustypeId = RefOperationalStatusTypeId from ODS.RefOperationalStatusType where Code = '000174'
		select @schOperationalStatustypeId = RefOperationalStatusTypeId from ODS.RefOperationalStatusType where Code = '000533'
		select @charterLeaCount = count(OrganizationId) from ods.K12Lea where CharterSchoolIndicator = 1

		--declare @schoolOrgTypeId as int
		select @schoolOrgTypeId = RefOrganizationTypeId
		from ods.RefOrganizationType 
		where [Code] = 'K12School' and RefOrganizationElementTypeId = @organizationElementTypeId

		select @charterSchoolManagerIdentifierTypeId = RefOrganizationIdentifierTypeId			
		from ods.RefOrganizationIdentifierType
		where [Code] = '000827'
			
		select @charterSchoolManagerIdentificationSystemId = RefOrganizationIdentificationSystemId
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'Federal'
		and RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

		select @charterAuthorizerIdentificationSystemId = RefOrganizationIdentificationSystemId
		from ods.RefOrganizationIdentificationSystem
		where [Code] = 'SEA'
		and RefOrganizationIdentifierTypeId = @charterSchoolManagerIdentifierTypeId

	END

	-- Missing Inserts
	BEGIN
	/*
		Insert Missing values
	*/
		if not exists (select 1 from RDS.Dimseas where DimSeaId = -1)
		begin
			set identity_insert RDS.Dimseas on
			insert into RDS.DimSeas (DimSeaId) values (-1)
			set identity_insert RDS.Dimseas off
		end

		if not exists (select 1 from RDS.DimPersonnel where DimPersonnelId = -1)
		begin
			set identity_insert RDS.DimPersonnel on
			insert into RDS.DimPersonnel (DimPersonnelId) values (-1)
			set identity_insert RDS.DimPersonnel off
		end

		if not exists (select 1 from RDS.DimLeas where DimLeaID = -1)
		begin
			set identity_insert RDS.DimLeas on
			insert into RDS.DimLeas (DimLeaId) values (-1)
			set identity_insert RDS.DimLeas off
		end

		if not exists (select 1 from RDS.DimSchools where DimSchoolId = -1)
		begin
			set identity_insert RDS.DimSchools on
			insert into RDS.DimSchools (DimSchoolId) values (-1)
			set identity_insert RDS.DimSchools off
		end

		if not exists (select 1 from RDS.DimCharterSchoolAuthorizers where DimCharterSchoolAuthorizerId = -1)
		begin
			set identity_insert RDS.DimCharterSchoolAuthorizers  on
			insert into RDS.DimCharterSchoolAuthorizers (DimCharterSchoolAuthorizerId) values (-1)
			set identity_insert RDS.DimCharterSchoolAuthorizers off
		end

		if not exists (select 1 from RDS.DimCharterSchoolManagementOrganizations where DimCharterSchoolManagementOrganizationId = -1)
		begin
			set identity_insert RDS.DimCharterSchoolManagementOrganizations on
			insert into RDS.DimCharterSchoolManagementOrganizations (DimCharterSchoolManagementOrganizationId) values (-1)
			set identity_insert RDS.DimCharterSchoolManagementOrganizations off
		end

	END
	
	-- DimSeas
	BEGIN
	/*
		-- Merge DimSeas
	*/
		INSERT INTO @MergeDates
		SELECT
				OrganizationId
				, RecordStartDateTime
				, ROW_NUMBER() OVER(PARTITION BY OrganizationId ORDER BY RecordStartDateTime) AS SequenceNumber
		FROM (
				SELECT DISTINCT OrganizationId, RecordStartDateTime
				FROM ods.OrganizationDetail
				WHERE RecordStartDateTime IS NOT NULL

				UNION

				SELECT DISTINCT OrganizationId, RecordStartDateTime
				FROM ods.OrganizationIdentifier
				WHERE RecordStartDateTime IS NOT NULL

			) dates

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@OrganizationDates - SEA' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @SeaSourceData as table (
			SeaName nvarchar(60) NULL
			, Identifier nvarchar(40) NULL
			, Code nvarchar(50) NULL
			, StateName nvarchar(100) NULL
			, MailingStreet nvarchar(40) NULL
			, MailingCity nvarchar(30) NULL
			, MailingState nvarchar(50) NULL
			, MailingPostalCode nvarchar(17) NULL
			, StreetNumberAndName nvarchar(40) NULL
			, City nvarchar(30) NULL
			, StateCode nvarchar(50) NULL
			, PostalCode nvarchar(17) NULL
			, TelephoneNumber nvarchar(24) NULL
			, Website nvarchar(300) NULL
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @SeaSourceData
		select o.Name as SeaName, i.Identifier, s.Code, rsCode.StateName,	
			mailingAddress.StreetNumberAndName as MailingStreet, mailingAddress.City as MailingCity, mailingAddress.StateCode as MailingState, 
			mailingAddress.PostalCode as MailingPostalCode, 
			physicalAddress.StreetNumberAndName, physicalAddress.City,	physicalAddress.StateCode,	physicalAddress.PostalCode,					
			phone.TelephoneNumber, website.Website,
			startDate.RecordStartDateTime AS RecordStartDateTime,
			endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
        LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join ods.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join ods.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId 
			and o.RefOrganizationTypeId = @seaOrgTypeId
		inner join ods.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId											
		left join ods.RefStateANSICode rsCode 
			on rsCode.Code = i.Identifier
		left join ods.RefState s 
			on s.Description = rsCode.StateName	
		left join ods.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
		left join (
					select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
					refState.Code as StateCode,  PostalCode 
					from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la 
						on ol.LocationId = la.LocationId
					inner join ods.RefState refState 
						on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 1 -- mailing
				) mailingAddress 
				on mailingAddress.OrganizationId = o.OrganizationId
		left join (
					select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
					refState.Code as StateCode, PostalCode  
					from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la 
						on ol.LocationId = la.LocationId
					inner join ods.RefState refState 
						on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 2 -- Physical
				) physicalAddress 
				on physicalAddress.OrganizationId = o.OrganizationId
		where i.RefOrganizationIdentifierTypeId = 18
		and i.RefOrganizationIdentificationSystemId = 78

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@SeaSourceData' as TableName, * from @SeaSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimSeas as trgt
		USING @SeaSourceData as src
				ON trgt.SeaStateIdentifier = src.Identifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN 
				Update SET trgt.SeaName = src.SeaName, 
				 trgt.StateANSICode = src.Identifier,
				 trgt.StateCode = src.Code,
				 trgt.StateName = src.StateName,
				 trgt.MailingAddressStreet = src.MailingStreet,
				 trgt.MailingAddressCity = src.MailingCity,
				 trgt.MailingAddressState = src.MailingState,
				 trgt.MailingAddressPostalCode = src.MailingPostalCode,
				 trgt.PhysicalAddressStreet = src.StreetNumberAndName,
				 trgt.PhysicalAddressCity = src.City,
				 trgt.PhysicalAddressState = src.StateCode,
				 trgt.PhysicalAddressPostalCode = src.PostalCode,
				 trgt.Telephone = src.TelephoneNumber,
				 trgt.Website = src.Website,
				 trgt.RecordEndDateTime = src.RecordEndDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT(SeaName,SeaStateIdentifier,StateANSICode,StateCode,StateName
				,MailingAddressStreet,MailingAddressCity,MailingAddressState,MailingAddressPostalCode
				,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,PhysicalAddressPostalCode,
				Telephone,Website,RecordStartDateTime,RecordEndDateTime)
		Values(src.SeaName,src.Identifier,src.Identifier,src.Code,src.StateName,
				src.MailingStreet,src.MailingCity,src.MailingState,src.MailingPostalCode,src.StreetNumberAndName,
				src.City,src.StateCode,src.PostalCode,src.TelephoneNumber,src.Website,src.RecordStartDateTime,src.RecordEndDateTime);


		;WITH upd AS(
				SELECT DimSeaId, SeaStateIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY SeaStateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimSeas  
			WHERE RecordEndDateTime is null
		) 
		UPDATE sea SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimSeas sea
		inner join upd	
			on sea.DimSeaId = upd.DimSeaId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'dimSeas' as TableName, * from rds.dimSeas
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates

	END
	
	-- DimPersonnel
	BEGIN
	/*
	---- Merge DimPersonnel
	*/
		INSERT INTO @MergeDates
        SELECT
                PersonId
                , RecordStartDateTime
	            , ROW_NUMBER() OVER(PARTITION BY PersonId ORDER BY RecordStartDateTime) AS SequenceNumber
        FROM (
                    SELECT DISTINCT 
                            PersonId
                            , RecordStartDateTime
                    FROM ods.PersonDetail
                    WHERE RecordStartDateTime IS NOT NULL

                ) dates

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@MergeDates - Personnel' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @PersonnelSourceData as table (
			Birthdate date NULL
			, FirstName nvarchar(35) NULL
			, LastName nvarchar(35) NULL
			, MiddleName nvarchar(35) NULL
			, PersonId int NULL
			, Identifier nvarchar(40) NULL
			, EmailAddress nvarchar(128) NULL 
			, TelephoneNumber nvarchar(24) NULL
			, PositionTitle nvarchar(45) NULL
			, CSSORole nvarchar(50) NULL
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @PersonnelSourceData
		select p.Birthdate,	p.FirstName, p.LastName, p.MiddleName, p.PersonId, 	Identifier, EmailAddress,TelephoneNumber,PositionTitle,
				@personnelRole as CSSORole,
				startDate.RecordStartDateTime AS RecordStartDateTime,
				endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
        LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join ods.PersonDetail p 
			ON p.PersonId = startDate.CedsIdentifier
			AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
		inner join ods.OrganizationPersonRole r 
			on r.PersonId = p.PersonId and r.RoleId = @CSSORoleId		  
		left join ods.PersonIdentifier i 
			on i.PersonId = p.PersonId
		left join ods.PersonEmailAddress e 
			on e.PersonId = p.PersonId
		left join ods.StaffEmployment emp 
			on emp.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		left join ods.PersonTelephone tel 
			on tel.PersonId = p.PersonId

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@PersonnelSourceData' as TableName, * from @PersonnelSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimPersonnel as trgt
		USING @PersonnelSourceData as src
				ON  trgt.StatePersonnelIdentifier = src.Identifier
				AND trgt.PersonnelRole = src.CSSORole
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
				Update SET trgt.Birthdate = src.Birthdate,
				 trgt.FirstName = src.FirstName,
				 trgt.LastName = src.LastName,
				 trgt.MiddleName = src.MiddleName,
				 trgt.Email = src.EmailAddress,
				 trgt.Telephone = src.TelephoneNumber,
				 trgt.Title = src.PositionTitle,
				 trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT([BirthDate],[FirstName],[LastName],[MiddleName],[StatePersonnelIdentifier],[Email],
				[Telephone],[Title],PersonnelRole,RecordStartDateTime, RecordEndDateTime)
		Values(src.Birthdate, src.FirstName, src.LastName, src.MiddleName, src.Identifier, src.EmailAddress, 
				src.TelephoneNumber, src.PositionTitle, src.CSSORole, src.RecordStartDateTime, src.RecordEndDateTime);


		;WITH upd AS(
				SELECT DimPersonnelId, StatePersonnelIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StatePersonnelIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimPersonnel  
			WHERE RecordEndDateTime is null and PersonnelRole = @personnelRole
		) 
		UPDATE personnel SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimPersonnel personnel
		inner join upd	
			on personnel.DimPersonnelId = upd.DimPersonnelId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'dimPersonnel' as TableName, * from rds.dimPersonnel
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates

	END

	-- DimLeas
	BEGIN
	/*
	----DimLeas
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
                    FROM ods.OrganizationDetail
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    --SELECT DISTINCT 
                    --         OrganizationId
                    --       , RecordStartDateTime
                    --FROM ods.OrganizationWebsite
                    --WHERE RecordStartDateTime IS NOT NULL

                    --UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , RecordStartDateTime
                    FROM ods.OrganizationIdentifier
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , OperationalStatusEffectiveDate as RecordStartDateTime
                    FROM ods.OrganizationOperationalStatus
                    WHERE OperationalStatusEffectiveDate IS NOT NULL 

					UNION 

					SELECT DISTINCT 
                            k.OrganizationId
                            , g.RecordStartDateTime
                    FROM ods.K12SchoolGradeOffered g
					inner join ods.K12School k on g.K12SchoolId = k.K12SchoolId
                    WHERE g.RecordStartDateTime IS NOT NULL

                ) dates

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@MergeDates - LEA' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @LeaSourceData as table (
			LeaName nvarchar(60) NULL
			, NCESIdentifier nvarchar(40) NULL
			, StateIdentifier nvarchar(40) NULL
			, SupervisoryUnionIdentificationNumber nchar(3) NULL
			, LeaTypeCode nvarchar(50) NULL
			, LeaTypeDescription nvarchar(100) NULL
			, LeaType nvarchar(50) NULL --EdFacts code
			, RefLeaTypeId int NULL
			, MailingStreet nvarchar(40) NULL
			, MailingCity nvarchar(30) NULL
			, MailingState nvarchar(50) NULL
			, MailingPostalCode nvarchar(17) NULL
			, OutOfState bit NULL
			, StreetNumberAndName nvarchar(40) NULL
			, City nvarchar(30) NULL
			, StateCode nvarchar(50) NULL
			, PostalCode nvarchar(17) NULL
			, TelephoneNumber nvarchar(24) NULL
			, Website nvarchar(300) NULL
			, LeaOperationalStatus nvarchar(50) NULL
			, LeaOperationalEdfactsStatus int NULL
			, OperationalStatusEffectiveDate date NULL 
			, PriorLeaStateIdentifier nvarchar(40) NULL
			, ReportedFederally bit NULL
			, CharterLeaStatus nvarchar(50) NULL
			, ReconstitutedStatus nvarchar(50) NULL
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @LeaSourceData
		SELECT DISTINCT	o.Name, isnull(i.Identifier, '') as NCESIdentifier, i1.Identifier as StateIdentifier,
			lea.SupervisoryUnionIdentificationNumber, 
			leaType.Code as LeaTypeCode, leaType.Description as LeaTypeDescription,
			CASE leaType.Code 
						WHEN 'RegularNotInSupervisoryUnion' then 1
						WHEN 'RegularInSupervisoryUnion' then 2
						WHEN 'SupervisoryUnion' then 3
						WHEN 'SpecializedPublicSchoolDistrict' then 9
						WHEN 'ServiceAgency' then 4
						WHEN 'StateOperatedAgency' then 5
						WHEN 'FederalOperatedAgency' then 6
						WHEN 'Other' then 8
						WHEN 'IndependentCharterDistrict' then 7
						ELSE -1
			END as LeaType, -- EdFacts Code
			leaType.RefLeaTypeId,
			mailingAddress.StreetNumberAndName as MailingStreet, mailingAddress.City as MailingCity, mailingAddress.StateCode as MailingState,
			mailingAddress.PostalCode as MailingPostalCode, 
			case when physicalAddress.StateCode <> @stateCode or mailingAddress.StateCode <> @stateCode then '1' else 0 end as OutOfState,
			physicalAddress.StreetNumberAndName, physicalAddress.City,	physicalAddress.StateCode,	physicalAddress.PostalCode,	phone.TelephoneNumber,
			website.Website,
			ISNULL(refop.Code, 'MISSING') as LeaOperationalStatus,	
			case refop.Code
							when 'Open' then 1 
							when 'Closed' then 2 
							when 'New' then 3 
							when 'Added' then 4 
							when 'ChangedBoundary' then 5 
							when 'Inactive' then 6 
							when 'FutureAgency' then 7 
							when 'Reopened' then 8 
							else -1
			END as LeaOperationalEdfactsStatus,
			op.OperationalStatusEffectiveDate, 	
			isnull(priorLea.Identifier,'') as PriorLeaStateIdentifier,
			CASE WHEN t.Code = 'LEANotFederal' THEN 0 ELSE 1 END AS ReportedFederally,
			isnull(cl.Code, 'MISSING') AS CharterLeaStatus,
			isnull(r.Code, 'MISSING') as ReconstitutedStatus,
			startDate.RecordStartDateTime AS RecordStartDateTime,
			endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
        LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join ods.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join ods.OrganizationIdentifier i1 
			on o.OrganizationId = i1.OrganizationId 
			and i1.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId 
		inner join ods.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId 
			and t.Code in ('LEA','LEANotFederal')
		left join ods.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId 
			and i.RefOrganizationIdentificationSystemId = @leaNCESIdentificationSystemId	
		left join ods.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
					refState.Code as StateCode, PostalCode 
					from ODS.OrganizationLocation ol
						inner join ods.LocationAddress la 
							on ol.LocationId = la.LocationId
						inner join ods.RefState refState 
							on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 1 -- mailing
					) mailingAddress 
					on mailingAddress.OrganizationId = o.OrganizationId
		left join (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
					refState.Code as StateCode, PostalCode  
					from ODS.OrganizationLocation ol
						inner join ods.LocationAddress la 
							on ol.LocationId = la.LocationId
						inner join ods.RefState refState 
							on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 2 -- Physical
					) physicalAddress
					on physicalAddress.OrganizationId = o.OrganizationId
		left join ods.K12Lea lea 
			on lea.OrganizationId = o.OrganizationId
		left join ods.RefLeaType leaType 
			on lea.RefLeaTypeId = leaType.RefLeaTypeId
		left join ods.RefCharterLeaStatus cl 
			on lea.RefCharterLeaStatusId = cl.RefCharterLeaStatusId
		left join ods.OrganizationFederalAccountability fa 
			on o.OrganizationId = fa.OrganizationId
		left join ods.RefReconstitutedStatus r 
			on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
		left join ods.K12School school 
			on school.OrganizationId = o.OrganizationId
		left join ods.RefSchoolType schoolType 
			on schoolType.RefSchoolTypeId = school.RefSchoolTypeId
		left outer join ods.OrganizationOperationalStatus op 
			ON o.OrganizationId = op.OrganizationId
            AND op.operationalstatuseffectivedate between startdate.recordstartdatetime and isnull(enddate.recordstartdatetime - 1, getdate())
		left outer join ods.RefOperationalStatus refop 
			on refop.RefOperationalStatusId = op.RefOperationalStatusId 
			and refop.RefOperationalStatusTypeId = @leaOperationalStatustypeId
		left outer join (		
				select i.Identifier
				from ods.OrganizationDetail o
				inner join ods.OrganizationIdentifier i 
					on o.OrganizationId = i.OrganizationId
				where RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
				and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
				and i.RecordEndDateTime IS NOT NULL
				group by i.Identifier
			) priorLea 
			on i.Identifier = priorLea.Identifier

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@LeaSourceData' as TableName, * from @LeaSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimLeas as trgt
		USING @LeaSourceData as src
				ON trgt.LeaStateIdentifier = src.StateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN 
				Update SET trgt.LeaName = src.LeaName,
						trgt.MailingAddressStreet = src.MailingStreet,
						trgt.MailingAddressCity = src.MailingCity,
						trgt.MailingAddressState = src.MailingState,
						trgt.MailingAddressPostalCode = src.MailingPostalCode,
						trgt.PhysicalAddressStreet = src.StreetNumberAndName,
						trgt.PhysicalAddressCity = src.City,
						trgt.PhysicalAddressState = src.StateCode,
						trgt.PhysicalAddressPostalCode = src.PostalCode,
						trgt.Telephone = src.TelephoneNumber,
						trgt.Website = src.Website,
						trgt.SupervisoryUnionIdentificationNumber = src.SupervisoryUnionIdentificationNumber,
						trgt.LeaOperationalStatus = src.LeaOperationalStatus,
						trgt.LeaOperationalStatusEdFactsCode = src.LeaOperationalEdfactsStatus,
						trgt.OperationalStatusEffectiveDate = src.OperationalStatusEffectiveDate,
						trgt.PriorLeaStateIdentifier = src.PriorLeaStateIdentifier,
						trgt.ReportedFederally = src.ReportedFederally,
						trgt.LeaTypeCode = src.LeaTypeCode,
						trgt.LeaTypeDescription = src.LeaTypeDescription,
						trgt.LeaTypeId = src.RefLeaTypeId,
						trgt.OutOfStateIndicator = src.OutOfState,
						trgt.LeaNcesIdentifier= src.NCESIdentifier,
						trgt.CharterLeaStatus = src.CharterLeaStatus,
						trgt.ReconstitutedStatus = src.ReconstitutedStatus,
						trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT(LeaName,LeaNcesIdentifier,LeaStateIdentifier,
				SeaName,SeaStateIdentifier,StateANSICode,StateCode,StateName, SupervisoryUnionIdentificationNumber, 
				LeaOperationalStatus, LeaOperationalStatusEdFactsCode, OperationalStatusEffectiveDate,
				PriorLeaStateIdentifier,ReportedFederally, 
				LeaTypeCode,LeaTypeDescription,LeaTypeEdFactsCode,LeaTypeId, 
				MailingAddressStreet,MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
				OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity, PhysicalAddressState,PhysicalAddressPostalCode,Telephone,Website,
				CharterLeaStatus, ReconstitutedStatus,
				RecordStartDateTime, RecordEndDateTime) 	
				VALUES
				(src.LeaName, src.NCESIdentifier, src.StateIdentifier, 
				@seaName, @seaIdentifier, @seaIdentifier, @stateCode, @stateName,
				src.SupervisoryUnionIdentificationNumber, 
				src.LeaOperationalStatus, src.LeaOperationalEdfactsStatus, src.OperationalStatusEffectiveDate, 
				src.PriorLeaStateIdentifier, src.ReportedFederally,
				src.LeaTypeCode, src.LeaTypeDescription, src.LeaType, src.RefLeaTypeId,
				src.MailingStreet, src.MailingCity, src.MailingState, src.MailingPostalCode,
				src.OutOfState, src.StreetNumberAndName, src.City, src.StateCode, src.PostalCode, src.TelephoneNumber, src.Website, 
				src.CharterLeaStatus, src.ReconstitutedStatus,
				src.RecordStartDateTime, src.RecordEndDateTime);

	
		;WITH upd AS(
				SELECT DimLeaId, LeaStateIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY LeaStateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimLeas  
			WHERE RecordEndDateTime is null
		) 
		UPDATE lea SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimLeas lea
		inner join upd	
			on lea.DimLeaId = upd.DimLeaId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'dimLeas' as TableName, * from rds.dimLeas
		END
		-------------------------------------------------------

		
		INSERT INTO @BridgeGrades
		SELECT distinct dimLea.DimLeaID, grades.DimGradeLevelId 
		FROM rds.DimLeas dimLea
		inner join ods.OrganizationIdentifier i 
			on dimLea.LeaStateIdentifier = i.Identifier 
			and i.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
			and dimLea.RecordEndDateTime IS NULL 
			and i.RecordEndDateTime IS NULL
		inner join ods.K12Lea lea 
			on lea.OrganizationId = i.OrganizationId
		inner join ods.OrganizationRelationship r 
			on r.Parent_OrganizationId = lea.OrganizationId
		inner join ods.K12School sch 
			on sch.OrganizationId = r.OrganizationId
		inner join ods.K12SchoolGradeOffered g	
			on g.K12SchoolId = sch.K12SchoolId
		inner join ods.RefGradeLevel l 
			on l.RefGradeLevelId = g.RefGradeLevelId
			and RefGradeLevelTypeId = (select top 1 RefGradeLevelTypeId from ods.RefGradeLevelType where code = '000131')
		inner join RDS.DimGradeLevels grades 
			on grades.GradeLevelCode = l.Code

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@BridgeGrades' as TableName, * from @BridgeGrades
		END
		-------------------------------------------------------

		MERGE rds.BridgeLeaGradeLevels as trgt
		USING @BridgeGrades as src
			ON trgt.DimLeaID = src.DimOrgID
			AND trgt.DimGradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT(DimLeaId,DimGradeLevelId) values(src.DimOrgID, src.DimGradeLevelId);

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'BridgeLeaGradeLevels' as TableName, * from rds.BridgeLeaGradeLevels
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates
		DELETE FROM @BridgeGrades

	END

	-- DimCharterSchoolManagementOrganizations
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
                    FROM ods.OrganizationDetail
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , RecordStartDateTime
                    FROM ods.OrganizationIdentifier
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
		inner join ods.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
			AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join ods.K12CharterSchoolManagementOrganization d 
			on d.OrganizationId = O.OrganizationId 
			AND o.RefOrganizationTypeId = @charterSchoolMgrTypeId 
		left outer join ods.K12School s 
			on s.K12CharterSchoolManagementOrganizationId = d.K12CharterSchoolManagementOrganizationId
		inner join ODS.RefCharterSchoolManagementOrganizationType charterSchoolApprovalAgencyType 
			on charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId = d.RefCharterSchoolManagementOrganizationTypeId	
		inner join ods.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId
		inner join ods.OrganizationIdentifier schoolStateIdentifier 
			on s.OrganizationId = schoolStateIdentifier.OrganizationId
			and schoolStateIdentifier.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
			and schoolStateIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		inner join ods.RefOrganizationIdentificationSystem aaa 
			on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
			and aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId
		inner join ods.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId																	
			left join ods.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code AS StateCode,  PostalCode 
				from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join ods.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 1 -- mailing
			) mailingAddress 
			on mailingAddress.OrganizationId = d.OrganizationId
		left join 
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code AS StateCode, PostalCode 
				from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join ods.RefState refState 
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
                    FROM ods.OrganizationDetail
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , RecordStartDateTime
                    FROM ods.OrganizationIdentifier
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
		inner join ods.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		inner join ods.OrganizationRelationship orgrel
			ON o.OrganizationId = orgrel.Parent_OrganizationId
		inner join ods.K12CharterSchoolAuthorizer d 
			on d.OrganizationId = orgrel.Parent_OrganizationId
				and o.RefOrganizationTypeId = @charterSchoolAuthTypeId 
		left outer join ods.K12School s on orgrel.OrganizationId = s.OrganizationId
		inner join ods.RefCharterSchoolAuthorizerType charterSchoolAuthorizerType 
			on charterSchoolAuthorizerType.RefCharterSchoolAuthorizerTypeId = d.RefCharterSchoolAuthorizerTypeId	
		inner join ods.OrganizationIdentifier i 
			on o.OrganizationId = i.OrganizationId
		inner join ods.RefOrganizationIdentificationSystem aaa 
			on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
			and aaa.RefOrganizationIdentificationSystemId=@charterAuthorizerIdentificationSystemId
		inner join ods.OrganizationIdentifier schoolStateIdentifier 
			on s.OrganizationId = schoolStateIdentifier.OrganizationId
			and schoolStateIdentifier.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
			and schoolStateIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		inner join ods.RefOrganizationType t 
			on o.RefOrganizationTypeId = t.RefOrganizationTypeId
		left join ods.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode 
				from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join ods.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 1 -- mailing
			) mailingAddress 
			on mailingAddress.OrganizationId = o.OrganizationId
		left join 
			(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  
				from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join ods.RefState refState 
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
						trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT(Name,StateIdentifier,StateCode,StateANSICode,[State],
		CharterSchoolAuthorizerTypeCode,CharterSchoolAuthorizerTypeDescription,CharterSchoolAuthorizerTypeEdFactsCode,MailingAddressStreet,
		MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
		OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,
		PhysicalAddressPostalCode,Telephone,Website,SchoolStateIdentifier,RecordStartDateTime,RecordEndDateTime)
		VALUES(src.Name,src.LeaSateIdentifier, @stateCode, @seaIdentifier, @stateName,
				src.CharterSchoolAuthorizerTypeCode,src.CharterSchoolAuthorizerTypeDescription,src.CharterSchoolAuthorizerTypeEdFactsCode,
				src.MailingStreet,src.MailingCity,src.MailingStateCode,src.MailingPostalCode,src.OutOfStateIndicator,
				src.StreetNumberAndName,src.City,src.PhysicalStateCode,src.PostalCode,
				src.TelephoneNumber,src.Website,src.SchoolStateIdentifier,src.RecordStartDateTime,src.RecordEndDateTime);


		;WITH upd AS(
			SELECT DimCharterSchoolAuthorizerId, StateIdentifier, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimCharterSchoolAuthorizers  
			WHERE RecordEndDateTime is null 
			and DimCharterSchoolAuthorizerId <> -1 
		) 
		UPDATE charter SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimCharterSchoolAuthorizers charter
		inner join upd	
			on charter.DimCharterSchoolAuthorizerId = upd.DimCharterSchoolAuthorizerId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

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

	-- DimSchool
	BEGIN
	/*
	-- DimSchool
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
                    FROM ods.OrganizationDetail
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    --SELECT DISTINCT 
                    --         OrganizationId
                    --       , RecordStartDateTime
                    --FROM ods.OrganizationWebsite
                    --WHERE RecordStartDateTime IS NOT NULL

                    --UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , RecordStartDateTime
                    FROM ods.OrganizationIdentifier
                    WHERE RecordStartDateTime IS NOT NULL

                    UNION

                    SELECT DISTINCT 
                            OrganizationId
                            , OperationalStatusEffectiveDate
                    FROM ods.OrganizationOperationalStatus
                    WHERE OperationalStatusEffectiveDate IS NOT NULL 

					UNION 

					SELECT DISTINCT 
                            k.OrganizationId
                            , g.RecordStartDateTime
                    FROM ods.K12SchoolGradeOffered g
					inner join ods.K12School k on g.K12SchoolId = k.K12SchoolId
                    WHERE g.RecordStartDateTime IS NOT NULL

                ) dates

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@MergeDates - Schools' as TableName, * from @MergeDates
		END
		-------------------------------------------------------

		DECLARE @SchoolSourceData as table (
			LeaNcesIdentifier nvarchar(40) NULL
			, LeaStateIdentifier nvarchar(40) NULL
			, LeaOrganizationName nvarchar(60) NULL
			, SchoolNcesIdentifier nvarchar(40) NULL
			, SchoolStateIdentifier nvarchar(40) NULL
			, SchoolName nvarchar(60) NULL
			, SchOperationalStatus nvarchar(50) NULL
			, SchOperationalEdfactsStatus int NULL
			, OperationalStatusEffectiveDate date NULL
			, PriorLeaStateIdentifier nvarchar(40) NULL 
			, PriorSchoolStateIdentifier nvarchar(40) NULL
			, CharterSchoolIndicator int NULL
			, CharterSchoolContractApprovalDate date NULL
			, CharterSchoolContractRenewalDate date NULL
			, CharterSchoolContractIdNumber nvarchar(30) NULL
			, ReportedFederally bit NULL
			, LeaTypeCode nvarchar(60) NULL
			, LeaTypeDescription nvarchar(100) NULL
			, LeaTypeEdfactsCode  nvarchar(60) NULL -- EdFact
			, LeaTypeId int NULL
			, StreetNumberAndName nvarchar(40) NULL
			, MailingCity nvarchar(30) NULL
			, MailingState nvarchar(50) NULL
			, MailingPostalCode nvarchar(17) NULL
			, OutOfState bit NULL
			, PhysicalAddressStreet nvarchar(40) NULL
			, City nvarchar(30) NULL
			, StateCode nvarchar(50) NULL
			, PostalCode nvarchar(17) NULL
			, SchoolTypeCode nvarchar(50) NULL
			, SchoolTypeDescription nvarchar(100) NULL
			, SchoolTypeEdfactsCode int NULL
			, SchoolTypeId int NULL
			, TelephoneNumber nvarchar(24) NULL
			, Website nvarchar(300) NULL
			, CharterSchoolStatus nvarchar(10) NULL
			, ReconstitutedStatus nvarchar(50) NULL
			, RecordStartDateTime datetime NULL
			, RecordEndDateTime datetime NULL
		)
		INSERT INTO @SchoolSourceData
		select distinct  
			isnull(leaNCESIdentifier.Identifier, '') as LeaNcesIdentifier, 
			leaStateIdentifier.Identifier as LeaStateIdentifier,lea.Name as LeaOrganizationName, 
			isnull(schoolNCESIdentifier.Identifier, '') as SchoolNcesIdentifier,
			schoolStateIdentifier.Identifier as SchoolStateIdentifier, o.Name as SchoolName, 
			ISNULL(refop.Code, 'MISSING') as SchOperationalStatus,
			case refop.Code
							when 'Open' then 1 
							when 'Closed' then 2 
							when 'New' then 3 
							when 'Added' then 4 
							when 'ChangedAgency' then 5 
							when 'Inactive' then 6 
							when 'FutureSchool' then 7 
							when 'Reopened' then 8 
							else -1
			END as SchOperationalEdfactsStatus,	ISNULL(op.OperationalStatusEffectiveDate, '') as OperationalStatusEffectiveDate,
			priorLea.Identifier as PriorLeaStateIdentifier,
			priorSchool.Identifier as PriorSchoolStateIdentifier, K12.CharterSchoolIndicator, k12.CharterSchoolContractApprovalDate,	
			k12.CharterSchoolContractRenewalDate, K12.CharterSchoolContractIdNumber,
			CASE WHEN t.Code = 'K12SchoolNotFederal' THEN 0 ELSE 1 END AS ReportedFederally, leaType.Code as LeaTypeCode, 
			leaType.[Description] as LeaTypeDescription,
			CASE leaType.Code 
				WHEN 'RegularNotInSupervisoryUnion' then 1
				WHEN 'RegularInSupervisoryUnion' then 2
				WHEN 'SupervisoryUnion' then 3
				WHEN 'SpecializedPublicSchoolDistrict' then 9
				WHEN 'ServiceAgency' then 4
				WHEN 'StateOperatedAgency' then 5
				WHEN 'FederalOperatedAgency' then 6
				WHEN 'Other' then 8
				WHEN 'IndependentCharterDistrict' then 7
				ELSE -1
			END as LeaTypeEdfactsCode, leaType.RefLeaTypeId as LeaTypeId, mailingAddress.StreetNumberAndName, mailingAddress.City as MailingCity, 
			mailingAddress.StateCode as MailingState, mailingAddress.PostalCode as MailingPostalCode, 
			case when physicalAddress.StateCode <> @stateCode or mailingAddress.StateCode <> @stateCode then '1' else 0 end as OutOfState,
			physicalAddress.StreetNumberAndName as PhysicalAddressStreet, physicalAddress.City,	physicalAddress.StateCode, physicalAddress.PostalCode,	
			schoolType.Code as SchoolTypeCode, schoolType.[Description] as SchoolTypeDescription,
			CASE schoolType.Code 
					WHEN 'Regular' then 1
					WHEN 'Special' then 2
					WHEN 'CareerAndTechnical' then 3
					WHEN 'Alternative' then 4
					WHEN 'Reportable' then 5
					ELSE -1
			END as SchoolTypeEdfactsCode,
			schoolType.RefSchoolTypeId as SchoolTypeId, phone.TelephoneNumber,	website.Website,
			case WHEN K12.CharterSchoolIndicator is null then 'MISSING'
					WHEN K12.CharterSchoolIndicator = 1 then 'YES'
					WHEN K12.CharterSchoolIndicator = 0 then 'NO'
			END as CharterSchoolStatus,
			isnull(r.Code, 'MISSING') as ReconstitutedStatus,
			startDate.RecordStartDateTime AS RecordStartDateTime,
			endDate.RecordStartDateTime - 1 AS RecordEndDateTime
		from @MergeDates startDate
        LEFT JOIN @MergeDates endDate 
			ON startDate.CedsIdentifier = endDate.CedsIdentifier 
			AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
		inner join ods.OrganizationDetail o 
			ON o.OrganizationId = startDate.CedsIdentifier
            AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
		INNER JOIN ODS.K12School K12 
			ON K12.OrganizationId = o.OrganizationId
		INNER JOIN ODS.RefOrganizationType t 
			ON t.RefOrganizationTypeId = o.RefOrganizationTypeId 
			and t.Code in ('K12School','K12SchoolNotFederal')
		inner join ods.OrganizationIdentifier schoolStateIdentifier 
			on o.OrganizationId = schoolStateIdentifier.OrganizationId
			and schoolStateIdentifier.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
			and schoolStateIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		inner join ods.OrganizationRelationship parent 
			on parent.OrganizationId = o.OrganizationId
		inner join ods.OrganizationDetail lea 
			on lea.OrganizationId = parent.Parent_OrganizationId	
		inner join ods.RefOrganizationType leaOrgType 
			on lea.RefOrganizationTypeId = leaOrgType.RefOrganizationTypeId and leaOrgType.Code in ('LEA','LEANotFederal')
		left join ods.OrganizationIdentifier schoolNCESIdentifier 
			on o.OrganizationId = schoolNCESIdentifier.OrganizationId
			and schoolNCESIdentifier.RefOrganizationIdentificationSystemId = @schoolNCESIdentificationSystemId
			and schoolNCESIdentifier.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		left join ods.OrganizationIdentifier leaNCESIdentifier 
			on lea.OrganizationId = leaNCESIdentifier.OrganizationId 
			and leaNCESIdentifier.RefOrganizationIdentificationSystemId = @leaNCESIdentificationSystemId
		left join ods.OrganizationIdentifier leaStateIdentifier 
			on lea.OrganizationId = leaStateIdentifier.OrganizationId 
			and leaStateIdentifier.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
		left join ods.RefSchoolType schoolType 
			on schoolType.RefSchoolTypeId = k12.RefSchoolTypeId
		left outer join ods.OrganizationOperationalStatus op 
			ON o.OrganizationId = op.OrganizationId
            AND op.operationalstatuseffectivedate between startdate.recordstartdatetime and isnull(endDate.recordstartdatetime - 1, getdate())
		left outer join ods.RefOperationalStatus refop 
			on refop.RefOperationalStatusId = op.RefOperationalStatusId 
			and refop.RefOperationalStatusTypeId = @schOperationalStatustypeId
		left join ods.OrganizationWebsite website 
			on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone 
			on o.OrganizationId = phone.OrganizationId
            and phone.refInstitutionTelephoneTypeId = @mainTelephoneTypeId		
		left join  
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
					refState.Code as StateCode,  PostalCode 
				from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la 
					on ol.LocationId = la.LocationId
				inner join ods.RefState refState 
					on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 1 -- mailing
				) mailingAddress 
				on mailingAddress.OrganizationId = o.OrganizationId
		left join 
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, 
						refState.Code as StateCode, PostalCode  
					from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la 
						on ol.LocationId = la.LocationId
					inner join ods.RefState refState 
						on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 2 -- Physical
				) physicalAddress 
				on physicalAddress.OrganizationId = o.OrganizationId
		left join ods.OrganizationFederalAccountability fa 
			on o.OrganizationId = fa.OrganizationId
		left join ods.RefReconstitutedStatus r 
			on r.RefReconstitutedStatusId = fa.RefReconstitutedStatusId
		left join ods.K12Lea k12lea 
			on lea.OrganizationId = k12lea.OrganizationId
		left join ods.RefLeaType leaType 
			on k12lea.RefLeaTypeId = leaType.RefLeaTypeId
		left outer join 
			(select i.Identifier
				from ods.OrganizationDetail o
				inner join ods.OrganizationRelationship r 
					on o.OrganizationId = r.OrganizationId
				inner join ods.OrganizationIdentifier i 
					on r.Parent_OrganizationId = i.OrganizationId
				where RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
				and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
				and i.RecordEndDateTime IS NOT NULL
				group by i.Identifier
			) priorLea 
			on leaStateIdentifier.Identifier = priorLea.Identifier
		left outer join 
			(select i.Identifier
				from ods.OrganizationDetail o
				inner join ods.OrganizationIdentifier i 
					on o.OrganizationId = i.OrganizationId
				where RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
				and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
				and i.RecordEndDateTime IS NOT NULL
				group by i.Identifier
			) priorSchool 
			on schoolStateIdentifier.Identifier = priorSchool.Identifier

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@SchoolSourceData' as TableName, * from @SchoolSourceData
		END
		-------------------------------------------------------

		MERGE rds.DimSchools as trgt
		USING @SchoolSourceData as src
				ON trgt.SchoolStateIdentifier = src.SchoolStateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN 
			Update SET trgt.LeaName = src.LeaOrganizationName,
					trgt.LeaNcesIdentifier = src.LeaNcesIdentifier,
					trgt.LeaStateIdentifier = src.LeaStateIdentifier,
					trgt.SchoolName = src.SchoolName,
					trgt.SchoolOperationalStatus = src.SchOperationalStatus,
					trgt.SchoolOperationalStatusEdFactsCode = src.SchOperationalEdfactsStatus,
					trgt.OperationalStatusEffectiveDate = src.OperationalStatusEffectiveDate,
					trgt.PriorLeaStateIdentifier = src.PriorLeaStateIdentifier,
					trgt.PriorSchoolStateIdentifier = src.PriorSchoolStateIdentifier,
					trgt.CharterSchoolIndicator = src.CharterSchoolIndicator,
					trgt.CharterSchoolContractIdNumber = src.CharterSchoolContractIdNumber,
					trgt.CharterContractApprovalDate = src.CharterSchoolContractApprovalDate,
					trgt.CharterContractRenewalDate = src.CharterSchoolContractRenewalDate,
					trgt.ReportedFederally = src.ReportedFederally,
					trgt.LeaTypeCode = src.LeaTypeCode,
					trgt.LeaTypeDescription = src.LeaTypeDescription,
					trgt.LeaTypeEdFactsCode = src.LeaTypeEdFactsCode,
					trgt.LeaTypeId = src.LeaTypeId,
					trgt.OutOfStateIndicator = src.OutOfState,
					trgt.MailingAddressStreet = src.StreetNumberAndName,
					trgt.MailingAddressCity = src.MailingCity,
					trgt.MailingAddressState = src.MailingState,
					trgt.MailingAddressPostalCode = src.MailingPostalCode,
					trgt.PhysicalAddressStreet = src.PhysicalAddressStreet,
					trgt.PhysicalAddressCity = src.City,
					trgt.PhysicalAddressState = src.StateCode,
					trgt.PhysicalAddressPostalCode = src.PostalCode,
					trgt.Telephone = src.TelephoneNumber,
					trgt.Website = src.Website,
					trgt.SchoolTypeCode = src.SchoolTypeCode,
					trgt.SchoolTypeDescription = src.SchoolTypeDescription,
					trgt.SchoolTypeEdFactsCode = src.SchoolTypeEdFactsCode,
					trgt.SchoolTypeId = src.SchoolTypeId,
					trgt.SchoolNcesIdentifier = src.SchoolNcesIdentifier,
					trgt.CharterSchoolStatus = src.CharterSchoolStatus,
					trgt.ReconstitutedStatus = src.ReconstitutedStatus,
					trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT (StateCode, StateName, StateANSICode, SeaName, SeaStateIdentifier, 
				LeaNcesIdentifier,LeaStateIdentifier, LeaName,
				SchoolNcesIdentifier,	SchoolStateIdentifier, SchoolName,	
				SchoolOperationalStatus, SchoolOperationalStatusEdFactsCode, OperationalStatusEffectiveDate,	PriorLeaStateIdentifier, 
				PriorSchoolStateIdentifier,	CharterSchoolIndicator, CharterContractApprovalDate, CharterContractRenewalDate, 
				CharterSchoolContractIdNumber, ReportedFederally, [LeaTypeCode],[LeaTypeDescription], [LeaTypeEdFactsCode],[LeaTypeId],
				[MailingAddressStreet],[MailingAddressCity],[MailingAddressState],[MailingAddressPostalCode],[OutOfStateIndicator],
				[PhysicalAddressStreet],[PhysicalAddressCity],[PhysicalAddressState],[PhysicalAddressPostalCode],
				[SchoolTypeCode] ,[SchoolTypeDescription] ,[SchoolTypeEdFactsCode]	,[SchoolTypeId]	,[Telephone],
				[Website], CharterSchoolStatus, ReconstitutedStatus,
				RecordStartDateTime,RecordEndDateTime) 
		VALUES(@stateCode,	@stateName,	@seaIdentifier,	@seaName, @seaIdentifier, 
				src.LeaNcesIdentifier, 
				src.LeaStateIdentifier, src.LeaOrganizationName, src.SchoolNcesIdentifier, src.SchoolStateIdentifier, src.SchoolName, 
				src.SchOperationalStatus, src.SchOperationalEdfactsStatus, src.OperationalStatusEffectiveDate,  src.PriorLeaStateIdentifier,
				src.PriorSchoolStateIdentifier, src.CharterSchoolIndicator, 
				src.CharterSchoolContractApprovalDate, src.CharterSchoolContractRenewalDate, src.CharterSchoolContractIdNumber, 
				src.ReportedFederally, src.LeaTypeCode, src.LeaTypeDescription, src.LeaTypeEdFactsCode, src.LeaTypeId,
				src.StreetNumberAndName, src.MailingCity, src.MailingState, src.MailingPostalCode, src.OutOfState, 
				src.PhysicalAddressStreet, src.City, src.StateCode, src.PostalCode, src.SchoolTypeCode, src.SchoolTypeDescription, 
				src.SchoolTypeEdFactsCode, src.SchoolTypeId, src.TelephoneNumber, src.Website,
				src.CharterSchoolStatus, src.ReconstitutedStatus,src.RecordStartDateTime, src.RecordEndDateTime);


		;WITH upd AS(
				SELECT DimSchoolId, SchoolStateIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY SchoolStateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
				FROM rds.DimSchools  
				WHERE RecordEndDateTime is null
		) 
		UPDATE school SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimSchools school
		inner join upd	
			on school.DimSchoolId = upd.DimSchoolId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'DimSchools' as TableName, * from rds.DimSchools
		END
		-------------------------------------------------------

		INSERT INTO @BridgeGrades
		SELECT distinct dimSchool.DimSchoolId, grades.DimGradeLevelId 
		FROM rds.DimSchools dimSchool
			inner join ods.OrganizationIdentifier i 
				on dimSchool.SchoolStateIdentifier = i.Identifier 
				and i.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
				and dimSchool.RecordEndDateTime IS NULL and i.RecordEndDateTime IS NULL
			inner join ods.K12School sch 
				on i.OrganizationId = sch.OrganizationId
			inner join ods.K12SchoolGradeOffered g 
				on g.K12SchoolId = sch.K12SchoolId
			inner join ods.RefGradeLevel l 
				on l.RefGradeLevelId = g.RefGradeLevelId
				and RefGradeLevelTypeId = (select top 1 RefGradeLevelTypeId from ods.RefGradeLevelType where code = '000131')
			inner join RDS.DimGradeLevels grades	
				on grades.GradeLevelCode = l.Code

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select '@BridgeGrades' as TableName, * from @BridgeGrades
		END
		-------------------------------------------------------

		MERGE rds.BridgeSchoolGradeLevels as trgt
		USING @BridgeGrades as src
				ON trgt.DimSchoolId = src.DimOrgId
				AND trgt.DimGradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT(DimSchoolId, DimGradeLevelId) values(src.DimOrgId, src.DimGradeLevelId);

		-------------------------------------------------------
		--Debug query for RunAsTest
		-------------------------------------------------------
		IF @runAsTest = 1
		BEGIN
			select 'BridgeSchoolGradeLevels' as TableName, * from rds.BridgeSchoolGradeLevels
		END
		-------------------------------------------------------

		--Cleanup
		DELETE FROM @MergeDates
		DELETE FROM @BridgeGrades

	END

	delete from rds.FactOrganizationCounts 
	where DimCountDateId in 
			(select d.DimDateId 
			from rds.DimDates d
			inner join rds.DimDateDataMigrationTypes dd 
				on dd.DimDateId=d.DimDateId 
			inner join rds.DimDataMigrationTypes b 
				on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
			where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode = 'rds')
	and DimFactTypeId = @factTypeId

	select @dimPersonnelId = max(p.DimPersonnelId) 
	from rds.DimPersonnel p
	inner join ods.[Role] r 
		on p.PersonnelRole = r.Name
	where r.roleId = @CSSORoleId AND p.RecordEndDateTime IS NULL


	declare @organizationDateQuery as TABLE(DimOrganizationId int, StateIdentifier varchar(50), DimDateId int) 
				
	insert into @organizationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'SEA'

	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select '@organizationDateQuery - SEA' as TableName, * from @organizationDateQuery
	END
	-------------------------------------------------------

	declare SEA_Cursor cursor for 						
	select DimOrganizationId,DimDateId from @organizationDateQuery

	open SEA_Cursor
	FETCH NEXT FROM SEA_Cursor INTO @dimSeaId, @dimDateId							

	WHILE @@FETCH_STATUS = 0
	BEGIN

		declare @SeaDateQuery as rds.SeaDateTableType
			
		insert into @SeaDateQuery
		(
			DimSeaId,
			DimCountDateId,
			SubmissionYearDate,
			[year],
			SubmissionYearStartDate,
			SubmissionYearEndDate
		)
		EXEC rds.Migrate_DimDates_Seas @dimSeaId, @dimDateId

		--migrate SEA Federal Fund Allocatios
		DECLARE @seaFederalFundQuery AS TABLE(
						DimCountDateId INT,
						DimSeaId int,						
						FederalProgramsFundingAllocation  [numeric](12, 2),
						FederalFundAllocationType varchar(20),
						FederalProgramCode varchar(20)					
					)
		insert into @seaFederalFundQuery(
						DimCountDateId,
						DimSeaId,						
						FederalProgramsFundingAllocation,
						FederalFundAllocationType,
						FederalProgramCode 					
					)
		SELECT 
				DimCountDateId,
				seaDate.dimSeaID, 				
				FederalProgramsFundingAllocation as 'FederalProgramsFundingAllocation',
				allocationType.Code as 'FederalFundAllocationType',	
				federalProgramCode as 'FederalProgramCode'
	    FROM ODS.OrganizationDetail o
		inner join ods.OrganizationIdentifier oi 
			on o.OrganizationId = oi.OrganizationId 
			and oi.RefOrganizationIdentificationSystemId = @seaFederalIdentificationSystemId	
		inner join rds.DimSeas dsea 
			on oi.Identifier = dsea.SeaStateIdentifier
		inner join ods.OrganizationCalendar oc 
			on o.OrganizationId = oc.OrganizationId 			
			and o.RecordEndDateTime IS NULL
		inner join ods.OrganizationCalendarSession s 
			on s.OrganizationCalendarId = oc.OrganizationCalendarId		
		inner join [ODS].[K12FederalFundAllocation] k12fund 
			on s.[OrganizationCalendarSessionId] = k12fund.[OrganizationCalendarSessionId]	
		inner join ODS.RefFederalProgramFundingAllocationType allocationType 
			on allocationType.RefFederalProgramFundingAllocationTypeId= k12fund.RefFederalProgramFundingAllocationTypeId
		inner join (select l.* from  @SeaDateQuery l) as seaDate			
			on seaDate.DimSeaId = dsea.DimSeaId
			and (s.BeginDate between seaDate.SubmissionYearStartDate and seaDate.SubmissionYearEndDate)
							
			
		-- Populate Query Output
		----------------------------
		create table #seaQueryOutput (
			QueryOutputId int IDENTITY(1,1) NOT NULL,
			DimCountDateId int,
			DimSeaId int,
			OrgCount int,				
			[TitleiPartaAllocations] int,		
			McKinneyVentoSubgrantRecipient varchar(50),
			REAPAlternativeFundingStatusCode varchar(50),
			GunFreeStatusCode varchar(50),
			GraduationRateCode varchar(50),
			FederalFundAllocationType varchar(20),
			FederalProgramCode varchar(20),
			FederalFundAllocated int
			)

		insert into #seaQueryOutput
		(
			DimCountDateId,
			DimSeaId ,
			OrgCount,				
			[TitleiPartaAllocations],		
			REAPAlternativeFundingStatusCode,
			GunFreeStatusCode,
			GraduationRateCode,
			McKinneyVentoSubgrantRecipient,
			FederalFundAllocationType,
			FederalProgramCode,
			FederalFundAllocated
		)
		select 
			s.DimCountDateId,
			s.DimSeaId,
			1,			
			case when FederalProgramCode ='84.010' Then round(FederalProgramsFundingAllocation,0) else 0 end as 'TitleiPartaAllocations' ,
			'MISSING',
			'MISSING',
			'MISSING',
			'MISSING',
			ISNULL(fund.FederalFundAllocationType,'MISSING'),
			ISNULL(fund.FederalProgramCode, 'MISSING'),
			ISNULL(fund.FederalProgramsFundingAllocation,0)
		From @SeaDateQuery s
		left outer join @seaFederalFundQuery fund 
			on s.DimSeaId = fund.DimSeaId 
			and s.DimCountDateId = fund.DimCountDateId 
				
		-- insert into FactOrganization 
		INSERT INTO [RDS].[FactOrganizationCounts]
			([DimCountDateId]
			,[DimOrganizationStatusId]
			,[DimFactTypeId]
			,[DimLeaId]
			,[DimPersonnelId]
			,[DimSchoolId]
			,[DimSchoolStatusId]
			,[DimSeaId]
			,[DimTitle1StatusId]
			,[OrganizationCount]			
			,[TitleiPartaAllocations]
			,[DimCharterSchoolAuthorizerId]
			,[DimCharterSchoolManagementOrganizationId]
			,[DimCharterSchoolSecondaryAuthorizerId]
			,[DimCharterSchoolUpdatedManagementOrganizationId]
			,[DimSchoolStateStatusId]
			,[FederalFundAllocationType]
			,[FederalProgramCode]
			,[FederalFundAllocated]
			,[DimCharterSchoolStatusId]
		)
		SELECT 
			q.DimCountDateId,
			-1 as 'DimOrganizationStatusId',
			@factTypeId, 
			-1 as 'DimLeaId',
			isnull(@dimPersonnelId, -1),
			-1 as 'DimSchoolId',
			-1 as 'DimSchoolStatusId',
			@dimSeaId as  'DimSeaId',
			-1 as 'DimTitle1StatusId',
			1 as OrganizationCount,			
			isnull(q.TitleiPartaAllocations,0),	
			-1 as 'DimCharterSchoolAuthorizerId',
			-1 as 'DimCharterSchoolManagementOrganizationId',
			-1 as 'DimCharterSchoolSecondaryAuthorizerId',
			-1 as 'DimCharterSchoolUpdatedManagementOrganizationId',
			-1 as 'DimSchoolStateStatusId',
			ISNULL(q.FederalFundAllocationType, 'MISSING') as 'FederalFundAllocationType',
			ISNULL(q.FederalProgramCode, 'MISSING') as 'FederalPrgoramCode',
			isnull(q.FederalFundAllocated,0),
			-1 as 'DimCharterSchoolStatusId'
		from #seaQueryOutput q		

		DELETE FROM @SeaDateQuery
		DROP TABLE #seaQueryOutput	

	FETCH NEXT FROM SEA_Cursor INTO @dimSeaId, @dimDateId			
	END
		
	close SEA_Cursor
	DEALLOCATE SEA_Cursor

	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select 'FactOrganizationCounts- SEA' as TableName, *
		from rds.FactOrganizationCounts 
		where DimSeaId <> -1
		and DimCountDateId = @dimDateId
		and DimFactTypeId = @factTypeId
	END
	-------------------------------------------------------

	delete from @organizationDateQuery

	insert into @organizationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'LEA'

	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select '@organizationDateQuery - LEA' as TableName, * from @organizationDateQuery
	END
	-------------------------------------------------------

	declare LEA_Cursor cursor for 						
	select DimOrganizationId, StateIdentifier, DimDateId from @organizationDateQuery

	open LEA_Cursor
	FETCH NEXT FROM LEA_Cursor INTO @dimLeaId, @leaStateIdentifier, @dimDateId							

	WHILE @@FETCH_STATUS = 0
	BEGIN

		declare @LeaDateQuery as RDS.LeaDateTableType
			
		insert into @LeaDateQuery
		(
			DimLeaId,
			DimCountDateId,
			SubmissionYearDate,
			[year],
			SubmissionYearStartDate,
			SubmissionYearEndDate
		)
		exec rds.Migrate_DimDates_Leas @dimLeaId, @dimDateId
	
		--Migrate_DimOrganizationStatuses_LEA
		declare @leaOrganizationStatusQuery as table(
				DimCountDateId int,
				DimLeaId int,
				REAPAlternativeFundingStatusCode varchar(50),
				GunFreeStatusCode varchar(50),
				GraduationRateCode varchar(50),
				McKinneyVentoSubgrantRecipient varchar(50)
			)
		insert into @leaOrganizationStatusQuery
		(
				DimLeaId ,
				DimCountDateId ,
				REAPAlternativeFundingStatusCode,
				GunFreeStatusCode,
				GraduationRateCode,
				McKinneyVentoSubgrantRecipient
		)		
		exec [RDS].[Migrate_DimOrganizationStatuses_Lea] @LeaDateQuery

		--migrate LEA Federal Fund Allocatios
		declare @leaFederalFundQuery as table(
						DimCountDateId int,
						DimLeaId int,
						ParentalInvolvementReservationFunds  [numeric](12, 2),
						FederalProgramsFundingAllocation  [numeric](12, 2),
						FederalFundAllocationType varchar(20),
						FederalProgramCode varchar(20)					
					)
		insert into @leaFederalFundQuery(
						DimCountDateId,
						DimLeaId,
						ParentalInvolvementReservationFunds ,
						FederalProgramsFundingAllocation,
						FederalFundAllocationType,
						FederalProgramCode 					
					)

		SELECT 
				DimCountDateId,
				leadate.dimLeaID, 
				leaFund.ParentalInvolvementReservationFunds,
				FederalProgramsFundingAllocation as 'FederalProgramsFundingAllocation',
				allocationType.Code as 'FederalFundAllocationType',	
				federalProgramCode as 'FederalProgramCode'
	    FROM ODS.OrganizationDetail o
		inner join ods.OrganizationIdentifier oi 
			on o.OrganizationId = oi.OrganizationId 
			and oi.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId	
		inner join rds.DimLeas dlea 
			on oi.Identifier = dlea.LeaStateIdentifier
		inner join ods.OrganizationCalendar oc 
			on o.OrganizationId = oc.OrganizationId 
			--and oi.Identifier = @leaStateIdentifier 
			and o.RecordEndDateTime IS NULL
		inner join ods.OrganizationCalendarSession s 
			on s.OrganizationCalendarId = oc.OrganizationCalendarId
		inner join ods.K12LeaFederalFunds leaFund 
			on leaFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
		inner join [ODS].[K12FederalFundAllocation] k12fund 
			on leaFund.[OrganizationCalendarSessionId] = k12fund.[OrganizationCalendarSessionId]	
		inner join ODS.RefFederalProgramFundingAllocationType allocationType 
			on allocationType.RefFederalProgramFundingAllocationTypeId= k12fund.RefFederalProgramFundingAllocationTypeId
		inner join (select l.* from  @LeaDateQuery l) as leaDate
			--on leaDate.leastateidentifier = oi.Identifier
			on leaDate.DimLeaId = dlea.DimLeaID
			and (s.BeginDate between leaDate.SubmissionYearStartDate and leaDate.SubmissionYearEndDate)

		-- Combine Dimension Data
		----------------------------
		create table #leaQueryOutput (
			QueryOutputId int IDENTITY(1,1) NOT NULL,
			DimCountDateId int,
			DimLeaId int,
			OrgCount int,
			[TitleiParentalInvolveRes] int,
			[TitleiPartaAllocations] int,
			McKinneyVentoSubgrantRecipient varchar(50),
			REAPAlternativeFundingStatusCode varchar(50),
			GunFreeStatusCode varchar(50),
			GraduationRateCode varchar(50),
			FederalFundAllocationType varchar(20),
			FederalProgramCode varchar(20),
			FederalFundAllocated int
			)

		insert into #leaQueryOutput
		(
			DimCountDateId ,
			DimLeaId ,
			OrgCount,
			[TitleiParentalInvolveRes],
			[TitleiPartaAllocations],
			REAPAlternativeFundingStatusCode,
			GunFreeStatusCode,
			GraduationRateCode,
			McKinneyVentoSubgrantRecipient,
			FederalFundAllocationType,
			FederalProgramCode,
			FederalFundAllocated
		)

		select s.DimCountDateId,
			s.DimLeaId,
			1,
			round(ParentalInvolvementReservationFunds,0),
			case when FederalProgramCode ='84.010' Then round(FederalProgramsFundingAllocation,0) else 0 end as 'TitleiPartaAllocations' ,
			ISNULL(dimOrganizationStatus.REAPAlternativeFundingStatusCode,'MISSING'),
			ISNULL(dimOrganizationStatus.GunFreeStatusCode,'MISSING'),
			ISNULL(dimOrganizationStatus.GraduationRateCode,'MISSING'),
			ISNULL(dimOrganizationStatus.McKinneyVentoSubgrantRecipient,'MISSING'),
			ISNULL(fund.FederalFundAllocationType,'MISSING'),
			ISNULL(fund.FederalProgramCode, 'MISSING'),
			ISNULL(FederalProgramsFundingAllocation,0)
		From @LeaDateQuery s
		left outer join @leaFederalFundQuery fund 
			on s.DimLeaId = fund.DimLeaId 
			and s.DimCountDateId = fund.DimCountDateId 
		left outer join @leaOrganizationStatusQuery dimOrganizationStatus 
			on s.DimLeaId = dimOrganizationStatus.DimLeaId 
			and s.DimCountDateId = dimOrganizationStatus.DimCountDateId 
				
		-- insert into FactOrganization 
		INSERT INTO [RDS].[FactOrganizationCounts]
			([DimCountDateId]
			,[DimOrganizationStatusId]
			,[DimFactTypeId]
			,[DimLeaId]
			,[DimPersonnelId]
			,[DimSchoolId]
			,[DimSchoolStatusId]
			,[DimSeaId]
			,[DimTitle1StatusId]
			,[OrganizationCount]
			,[TitleiParentalInvolveRes]
			,[TitleiPartaAllocations]
			,[DimCharterSchoolAuthorizerId]
			,[DimCharterSchoolSecondaryAuthorizerId]
			,[DimCharterSchoolManagementOrganizationId]
			,[DimCharterSchoolUpdatedManagementOrganizationId]
			,[DimSchoolStateStatusId]
			,[FederalFundAllocationType]
			,[FederalProgramCode]
			,[FederalFundAllocated]
			,[DimCharterSchoolStatusId]
		)
		SELECT 
			q.DimCountDateId,
			ISNULL(dimOrganizationStatus.DimOrganizationStatusId,-1) as 'DimOrganizationStatusId',
			@factTypeId, 
			@dimLeaId as 'DimLeaId',
			-1 as 'DimPersonnelId',
			-1 as 'DimSchoolId',
			-1 as 'DimSchoolStatusId',
			-1 as  'DimSeaId',
			-1 as 'DimTitle1StatusId',
			1 as OrganizationCount,
			isnull(q.TitleiParentalInvolveRes,0),
			isnull(q.TitleiPartaAllocations,0),
			-1 as 'DimCharterSchoolAuthorizerId',
			-1 as 'DimCharterSchoolManagementOrganizationId',
			-1 as 'DimCharterSchoolSecondaryAuthorizerId',
			-1 as 'DimCharterSchoolUpdatedManagementOrganizationId',
			-1 as 'DimSchoolStateStatusId',
			ISNULL(q.FederalFundAllocationType, 'MISSING') as 'FederalFundAllocationType',
			ISNULL(q.FederalProgramCode, 'MISSING') as 'FederalPrgoramCode',
			isnull(q.FederalFundAllocated,0),
			-1 as 'DimCharterSchoolStatusId'
		from #leaQueryOutput q
		left outer join rds.DimOrganizationStatus dimOrganizationStatus 
			on dimOrganizationStatus.REAPAlternativeFundingStatusCode = q.REAPAlternativeFundingStatusCode
			and dimOrganizationStatus.GunFreeStatusCode = q.GunFreeStatusCode 
			and dimOrganizationStatus.GraduationRateCode = q.GraduationRateCode
			and dimOrganizationStatus.McKinneyVentoSubgrantRecipientCode = q.McKinneyVentoSubgrantRecipient

		DELETE FROM @LeaDateQuery
		DELETE FROM @leaOrganizationStatusQuery
		DROP TABLE #leaQueryOutput

	FETCH NEXT FROM LEA_Cursor INTO @dimLeaId, @leaStateIdentifier, @dimDateId			
	END
		
	close LEA_Cursor
	DEALLOCATE LEA_Cursor

	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select 'FactOrganizationCounts- LEA' as TableName, *
		from rds.FactOrganizationCounts 
		where DimLeaId <> -1
		and DimCountDateId = @dimDateId
		and DimFactTypeId = @factTypeId
	END
	-------------------------------------------------------

	delete from @organizationDateQuery

	insert into @organizationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'SCHOOL'

	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select '@organizationDateQuery - School' as TableName, * from @organizationDateQuery
	END
	-------------------------------------------------------


	declare SCH_Cursor cursor for 						
	select DimOrganizationId, StateIdentifier, DimDateId from @organizationDateQuery


	open SCH_Cursor
	FETCH NEXT FROM SCH_Cursor INTO @dimSchoolId, @schoolStateIdentifier, @dimDateId						

	WHILE @@FETCH_STATUS = 0
	BEGIN

		set @dimCharterSchoolManagementOrganizationId=-1
		set @dimCharterSchoolSecondaryManagementOrganizationId=-1
		set @dimCharterSchoolAuthorizerId=-1
		set @dimCharterSchoolSecondaryAuthorizerId=-1
		set @count=0

		declare @SchoolDateQuery as rds.SchoolDateTableType
		insert into @SchoolDateQuery
		(
			DimSchoolId,
			DimCountDateId,
			SubmissionYearDate,
			[year],
			SubmissionYearStartDate,
			SubmissionYearEndDate
		)
		exec rds.Migrate_DimDates_Schools @dimSchoolId, @dimDateId

		
		-- Migrate_DimOrganizationStatuses_School
		declare @organizationStatusSchoolQuery as table(
				DimCountDateId int,
				DimSchoolId int,
				REAPAlternativeFundingStatusCode varchar(50),
				GunFreeStatusCode varchar(50),
				GraduationRateCode varchar(50),
				McKinneyVentoSubgrantRecipient varchar(50)
			)
		insert into @organizationStatusSchoolQuery
		(
			DimSchoolId ,
			DimCountDateId ,
			REAPAlternativeFundingStatusCode,
			GunFreeStatusCode,
			GraduationRateCode,
			McKinneyVentoSubgrantRecipient
		)
		exec [RDS].[Migrate_DimOrganizationStatuses_School] @SchoolDateQuery

		declare @schoolStatusQuery as table(
				DimCountDateId int,
				DimSchoolId int,
				schoolOrganizationId int,
				NSLPStatusCode varchar(50),
				MagnetStatusCode varchar(50),
				VirtualStatusCode varchar(50),
				SharedTimeStatusCode varchar(50),
				ImprovementStatusCode varchar(50),
				DangerousStatusCode varchar(50),
				StatePovertyDesignationCode varchar(50),
				ProgressAchievingEnglishLanguageCode varchar(50),
				SchoolStateStatusCode varchar(50)
			)
		insert into @schoolStatusQuery
		(
			DimCountDateId ,
			DimSchoolId ,
			schoolOrganizationId,
			NSLPStatusCode ,
			MagnetStatusCode ,
			VirtualStatusCode ,
			SharedTimeStatusCode,
			ImprovementStatusCode,					
			DangerousStatusCode,
			StatePovertyDesignationCode,
			ProgressAchievingEnglishLanguageCode,
			SchoolStateStatusCode
		)
		exec [RDS].[Migrate_DimSchoolStatuses_School] @SchoolDateQuery

		declare @title1StatusQuery as table(
				DimCountDateId int,
				DimSchoolId int,
				TitleISchoolStatusCode varchar(50),
				TitleIinstructionalServiceCode varchar(50),
				Title1SupportServiceCode varchar(50),
				Title1ProgramTypeCode varchar(50)
			)

		insert into @title1StatusQuery
		(
			DimCountDateId ,
			DimSchoolId ,
			TitleISchoolStatusCode ,
			TitleIinstructionalServiceCode ,
			Title1SupportServiceCode ,
			Title1ProgramTypeCode
		)
		exec [RDS].[Migrate_DimTitle1Statuses_School] @SchoolDateQuery

		-- migrate ComprehensiveAndTargetedSupport
		declare @ComprehensiveAndTargetedSupport as table(
				DimCountDateId int,
				DimSchoolId int,
				--ComprehensiveAndTargetedSupportCode varchar(50),
				ComprehensiveSupportImprovementCode varchar(50),
				TargetedSupportImprovementCode varchar(50),
				ComprehensiveSupportCode varchar(50),
				TargetedSupportCode varchar(50),
				AdditionalTargetedSupportCode varchar(50)
			)
		insert into @ComprehensiveAndTargetedSupport (
			DimCountDateId,
			DimSchoolId,
			--ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			ComprehensiveSupportCode,
			TargetedSupportCode,
			AdditionalTargetedSupportCode
		)
		exec [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School] @SchoolDateQuery

		Declare @SchImprovementFundQuery as table (
			DimCountDateId int,
			DimSchoolId int,
			SchImprovementFund  [numeric](12, 2)
			)
		insert into @SchImprovementFundQuery (
			DimCountDateId,
			DimSchoolId,
			SchImprovementFund
			)
		SELECT distinct DimCountDateId, schDate.DimSchoolId, schFund.SchoolImprovementAllocation
		FROM ODS.OrganizationDetail o
		inner join ods.OrganizationIdentifier oi 
			on o.OrganizationId = oi.OrganizationId
			and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId	
		inner join rds.DimSchools dsch 
			on oi.Identifier = dsch.SchoolStateIdentifier
		inner join ods.OrganizationCalendar oc 
			on o.OrganizationId = oc.OrganizationId 
			--and oi.Identifier = @schoolStateIdentifier 
			and o.RecordEndDateTime IS NULL
		inner join ods.OrganizationCalendarSession s 
			on s.OrganizationCalendarId = oc.OrganizationCalendarId
		inner join ods.K12FederalFundAllocation schFund 
			on schFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
		inner join ods.K12School sch 
			on sch.OrganizationId = o.OrganizationId
		inner join ods.K12SchoolImprovement schImprv 
			on sch.K12SchoolId = schImprv.K12SchoolId
		inner join ods.RefSchoolImprovementFunds refSis 
			on schImprv.RefSchoolImprovementFundsId = refSis.RefSchoolImprovementFundsId 
			and refSis.Code = 'YES'
		inner join	(select l.*, @schoolStateIdentifier as StateIdentifier from  @SchoolDateQuery l) as schDate 
			on schDate.DimSchoolId = dsch.DimSchoolId
			--on schDate.StateIdentifier = oi.Identifier
			and (s.BeginDate between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)


		DECLARE @CharterSchoolStatusQuery AS TABLE (
				DimCountDateId INT,
				DimSchoolId INT,
				AppropriationMethodCode VARCHAR(50)
			)
		INSERT INTO @CharterSchoolStatusQuery (
				DimCountDateId,
				DimSchoolId,
				AppropriationMethodCode
			)
		SELECT distinct DimCountDateId, s.DimSchoolId, ISNULL(m.Code, 'MISSING')
		FROM 
		@SchoolDateQuery org
		INNER JOIN rds.DimSchools s ON org.DimSchoolId = s.DimSchoolId 
		INNER JOIN ods.OrganizationIdentifier oi ON s.SchoolStateIdentifier = oi.Identifier 
					AND oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
					AND oi.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		INNER JOIN ods.K12School sch ON  sch.OrganizationId = oi.OrganizationId
		INNER JOIN ods.RefStateAppropriationMethod m on sch.RefStateAppropriationMethodId = m.RefStateAppropriationMethodId
		

		--declare @schoolOrganizationId as int
		select @IsCharterSchool = CharterSchoolIndicator from rds.DimSchools where SchoolStateIdentifier = @schoolStateIdentifier

		

		if @IsCharterSchool = 1
		begin
				
			select @count = count(DimCharterSchoolManagementOrganizationId) 
			from rds.DimCharterSchoolManagementOrganizations cm			
			inner join ods.OrganizationIdentifier oi on cm.StateIdentifier = oi.Identifier
			inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=oi.RefOrganizationIdentificationSystemId
					AND aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId					
			inner join ods.OrganizationRelationship orgrel on oi.OrganizationId = orgrel.Parent_OrganizationId
			inner join ods.OrganizationIdentifier ois on orgrel.OrganizationId = ois.OrganizationId
					AND ois.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId  
					AND ois.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId	 	
			inner join rds.DimSchools sch on ois.Identifier = sch.SchoolStateIdentifier
			inner join	(select l.*, @schoolStateIdentifier as StateIdentifier from  @SchoolDateQuery l) as schDate on schDate.DimSchoolId = sch.DimSchoolId			
			where sch.SchoolStateIdentifier = @schoolStateIdentifier
			and (cm.RecordStartDateTime between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)

			IF @count = 1
			BEGIN
				select @dimCharterSchoolManagementOrganizationId = DimCharterSchoolManagementOrganizationId
				from rds.DimCharterSchoolManagementOrganizations cm			
				inner join ods.OrganizationIdentifier oi on cm.StateIdentifier = oi.Identifier
				inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=oi.RefOrganizationIdentificationSystemId
						AND aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId					
				inner join ods.OrganizationRelationship orgrel on oi.OrganizationId = orgrel.Parent_OrganizationId
				inner join ods.OrganizationIdentifier ois on orgrel.OrganizationId = ois.OrganizationId
						AND ois.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId  
						AND ois.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId	 	
				inner join rds.DimSchools sch on ois.Identifier = sch.SchoolStateIdentifier
				inner join	(select l.*, @schoolStateIdentifier as StateIdentifier from  @SchoolDateQuery l) as schDate on schDate.DimSchoolId = sch.DimSchoolId			
				where sch.SchoolStateIdentifier = @schoolStateIdentifier
				and (cm.RecordStartDateTime between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)
			END
			ELSE
			BEGIN
				select @dimCharterSchoolManagementOrganizationId = min(DimCharterSchoolManagementOrganizationId)
				from rds.DimCharterSchoolManagementOrganizations cm			
				inner join ods.OrganizationIdentifier oi on cm.StateIdentifier = oi.Identifier
				inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=oi.RefOrganizationIdentificationSystemId
						AND aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId					
				inner join ods.OrganizationRelationship orgrel on oi.OrganizationId = orgrel.Parent_OrganizationId
				inner join ods.OrganizationIdentifier ois on orgrel.OrganizationId = ois.OrganizationId
						AND ois.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId  
						AND ois.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId	 	
				inner join rds.DimSchools sch on ois.Identifier = sch.SchoolStateIdentifier
				inner join	(select l.*, @schoolStateIdentifier as StateIdentifier from  @SchoolDateQuery l) as schDate on schDate.DimSchoolId = sch.DimSchoolId			
				where sch.SchoolStateIdentifier = @schoolStateIdentifier
				and (cm.RecordStartDateTime between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)

				select @dimCharterSchoolSecondaryManagementOrganizationId = max(DimCharterSchoolManagementOrganizationId)
				from rds.DimCharterSchoolManagementOrganizations cm			
				inner join ods.OrganizationIdentifier oi on cm.StateIdentifier = oi.Identifier
				inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=oi.RefOrganizationIdentificationSystemId
						AND aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId					
				inner join ods.OrganizationRelationship orgrel on oi.OrganizationId = orgrel.Parent_OrganizationId
				inner join ods.OrganizationIdentifier ois on orgrel.OrganizationId = ois.OrganizationId
						AND ois.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId  
						AND ois.RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId	 	
				inner join rds.DimSchools sch on ois.Identifier = sch.SchoolStateIdentifier
				inner join	(select l.*, @schoolStateIdentifier as StateIdentifier from  @SchoolDateQuery l) as schDate on schDate.DimSchoolId = sch.DimSchoolId			
				where sch.SchoolStateIdentifier = @schoolStateIdentifier
				and (cm.RecordStartDateTime between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)

			END

			set @count = 0


			select @count = count(DimCharterSchoolAuthorizerId) from rds.DimCharterSchoolAuthorizers 
			where SchoolStateIdentifier = @schoolStateIdentifier


			IF @count = 1
			BEGIN
				select @dimCharterSchoolAuthorizerId = DimCharterSchoolAuthorizerId from rds.DimCharterSchoolAuthorizers
				where SchoolStateIdentifier = @schoolStateIdentifier
			END
			ELSE
			BEGIN
				select @dimCharterSchoolAuthorizerId = min(DimCharterSchoolAuthorizerId) 
				from rds.DimCharterSchoolAuthorizers 
				where SchoolStateIdentifier = @schoolStateIdentifier

				select @dimCharterSchoolSecondaryAuthorizerId = max(DimCharterSchoolAuthorizerId)
				from rds.DimCharterSchoolAuthorizers
				where SchoolStateIdentifier = @schoolStateIdentifier
			END
		end
		
		

		-- =====================================================================================
		-- Combine Dimension Data
		create table #queryOutput (
			QueryOutputId int IDENTITY(1,1) NOT NULL,
		
			DimCountDateId int,
			DimSchoolId int,

			NSLPStatusCode varchar(50),
			MagnetStatusCode varchar(50),
			VirtualStatusCode varchar(50),
			SharedTimeStatusCode varchar(50),
			PersistentlyDangerousStatusCode varchar(50),
			ImprovementStatusCode varchar(50),
			StatePovertyDesignationCode varchar(50),
			ProgressAchievingEnglishLanguageCode varchar(50),
			SchoolStateStatusCode varchar(50),

			TitleISchoolStatusCode varchar(50),
			TitleIinstructionalServiceCode varchar(50),
			Title1SupportServiceCode varchar(50),
			Title1ProgramTypeCode varchar(50),

			REAPAlternativeFundingStatusCode varchar(50),
			GunFreeStatusCode varchar(50),
			GraduationRateCode varchar(50),
			McKinneyVentoSubgrantRecipient varchar(50),
			OrgCount int,
			[SchImprovementAllocations] int,
			--ComprehensiveAndTargetedSupportCode varchar(50),
			ComprehensiveSupportImprovementCode varchar(50),
			TargetedSupportImprovementCode varchar(50),
			ComprehensiveSupportCode varchar(50),
			TargetedSupportCode varchar(50),
			AdditionalTargetedSupportCode varchar(50),
			AppropriationMethodCode varchar(50)
		)

		insert into #queryOutput
		(
			DimCountDateId ,
			DimSchoolId ,

			NSLPStatusCode ,
			MagnetStatusCode,
			VirtualStatusCode,
			SharedTimeStatusCode ,
			PersistentlyDangerousStatusCode ,
			ImprovementStatusCode ,
			StatePovertyDesignationCode,
			ProgressAchievingEnglishLanguageCode,
			SchoolStateStatusCode,

			TitleISchoolStatusCode ,
			TitleIinstructionalServiceCode ,
			Title1SupportServiceCode ,
			Title1ProgramTypeCode ,

			REAPAlternativeFundingStatusCode,
			GunFreeStatusCode,
			GraduationRateCode,
			McKinneyVentoSubgrantRecipient,

			OrgCount,	
			SchImprovementAllocations,
			--ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			ComprehensiveSupportCode,
			TargetedSupportCode,
			AdditionalTargetedSupportCode,
			AppropriationMethodCode     
		)
		select s.DimCountDateId,
			s.DimSchoolId,
			ISNULL(schStatus.NSLPStatusCode,'MISSING') ,
			ISNULL(schStatus.MagnetStatusCode,'MISSING'),
			ISNULL(schStatus.VirtualStatusCode,'MISSING'),
			ISNULL(schStatus.SharedTimeStatusCode ,'MISSING'),
			ISNULL(schStatus.DangerousStatusCode ,'MISSING'),
			ISNULL(schStatus.ImprovementStatusCode ,'MISSING'),
			ISNULL(schStatus.StatePovertyDesignationCode ,'MISSING'),
			IsNull(schStatus.ProgressAchievingEnglishLanguagecode,'MISSING'),
			IsNull(schStatus.SchoolStateStatusCode,'MISSING'),

			ISNULL(t.TitleISchoolStatusCode ,'MISSING'),
			ISNULL(t.TitleIinstructionalServiceCode ,'MISSING'),
			ISNULL(t.Title1SupportServiceCode ,'MISSING'),
			ISNULL(t.Title1ProgramTypeCode ,'MISSING'),

			ISNULL(organizationStatus.REAPAlternativeFundingStatusCode ,'MISSING'),
			ISNULL(organizationStatus.GunFreeStatusCode ,'MISSING'),
			ISNULL(organizationStatus.GraduationRateCode ,'MISSING'),
			ISNULL(organizationStatus.McKinneyVentoSubgrantRecipient ,'MISSING'),
			1,
			round(SchImprovementFund,0),
			ISNULL(cts.ComprehensiveSupportImprovementCode,'MISSING'),
			ISNULL(cts.TargetedSupportImprovementCode,'MISSING'),
			ISNULL(cts.ComprehensiveSupportCode,'MISSING'),
			ISNULL(cts.TargetedSupportCode,'MISSING'),
			ISNULL(cts.AdditionalTargetedSupportCode,'MISSING'),
			ISNULL(ch.AppropriationMethodCode,'MISSING')
		From @SchoolDateQuery s
		left outer join @schoolStatusQuery schStatus 
			on s.DimSchoolId = schStatus.DimSchoolId 
			and s.DimCountDateId = schStatus.DimCountDateId
		left outer join @title1StatusQuery t 
			on s.DimSchoolId = t.DimSchoolId 
			and s.DimCountDateId = t.DimCountDateId
		left outer join @SchImprovementFundQuery schImprFund 
			on s.DimSchoolId = schImprFund.DimSchoolId 
			and s.DimCountDateId = schImprFund.DimCountDateId
		left outer join @organizationStatusSchoolQuery organizationStatus 
			on s.DimSchoolId = organizationStatus.DimSchoolId 
			and s.DimCountDateId = organizationStatus.DimCountDateId
		left join @ComprehensiveAndTargetedSupport cts 
			on s.DimSchoolId = cts.DimSchoolId 
			and s.DimCountDateId = cts.DimCountDateId
		left join @CharterSchoolStatusQuery ch
			on s.DimSchoolId = ch.DimSchoolId 
			and s.DimCountDateId = ch.DimCountDateId
			
		----insert into FactOrganizationCounts
		INSERT INTO [RDS].[FactOrganizationCounts]
			([DimCountDateId]
			,[DimOrganizationStatusId]
			,[DimFactTypeId]
			,[DimLeaId]
			,[DimPersonnelId]
			,[DimSchoolId]
			,[DimSchoolStatusId]
			,[DimSchoolStateStatusId]
			,[DimSeaId]
			,[DimTitle1StatusId]
			,[OrganizationCount]
			,[DimCharterSchoolAuthorizerId]
			,[DimCharterSchoolSecondaryAuthorizerId]
			,[DimCharterSchoolManagementOrganizationId]
			,[DimCharterSchoolUpdatedManagementOrganizationId]
			,[SCHOOLIMPROVEMENTFUNDS]
			,DimComprehensiveAndTargetedSupportId
			,FederalFundAllocated
			,[DimCharterSchoolStatusId]
			)
		Select distinct q.DimCountDateId,
				ISNULL(organizationStatus.DimOrganizationStatusId,-1) as 'DimOrganizationStatusId', 
				@factTypeId,
				-1 as 'DimLeaId',
				-1 as 'DimPersonnelId',
				@dimSchoolId as 'DimSchoolId',
				ISNULL(s.DimSchoolStatusId,-1) as 'DimSchoolStatusId',
				ISNULL(dss.DimSchoolStateStatusId,-1) as 'DimschoolStateStatusId',
				-1 as  'DimSeaId',
				ISNULL(t.DimTitle1StatusId,-1) as 'DimTitle1StatusId',
				1 as OrganizationCount,
				ISNULL(@dimCharterSchoolAuthorizerId, -1) as 'DimCharterSchoolAuthorizerId',
				ISNULL(@dimCharterSchoolSecondaryAuthorizerId, -1) as'DimCharterSchoolSecondaryAuthorizerId',		
				ISNULL(@dimCharterSchoolManagementOrganizationId, -1) as'DimCharterSchoolManagementOrganizationId',
				ISNULL(@dimCharterSchoolSecondaryManagementOrganizationId, -1) as'DimCharterSchoolUpdatedManagementOrganizationId',
				isnull(q.SchImprovementAllocations,0),
				ISNULL(cts.DimComprehensiveAndTargetedSupportId,-1) as 'DimComprehensiveAndTargetedSupportId',
				isnull(q.SchImprovementAllocations,0),
				isnull(ch.DimCharterSchoolStatusId, -1) as 'DimCharterSchoolStatusId'
		from #queryOutput q
		Left outer join rds.DimSchoolStatuses s
			on s.MagnetStatusCode = q.MagnetStatusCode
			and s.NSLPStatusCode = q.NSLPStatusCode
			and s.SharedTimeStatusCode = q.SharedTimeStatusCode
			and s.VirtualSchoolStatusCode = q.VirtualStatusCode
			and s.ImprovementStatusCode = q.ImprovementStatusCode
			and s.PersistentlyDangerousStatusCode = q.PersistentlyDangerousStatusCode
			and s.StatePovertyDesignationCode =q.StatePovertyDesignationCode
			and s.ProgressAchievingEnglishLanguageCode =q.ProgressAchievingEnglishLanguageCode
		Left outer join rds.DimSchoolStateStatus dss 
			on dss.SchoolStateStatusCode=q.SchoolStateStatusCode
		left outer join rds.DimTitle1Statuses t 
			on t.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
			and t.Title1ProgramTypeCode = q.Title1ProgramTypeCode
			and t.Title1SchoolStatusCode = q.TitleISchoolStatusCode
			and t.Title1SupportServicesCode = q.Title1SupportServiceCode
		left outer join rds.DimOrganizationStatus organizationStatus 
			on organizationStatus.GunFreeStatusCode = q.GunFreeStatusCode
			and organizationStatus.GraduationRateCode = q.GraduationRateCode
			and organizationStatus.REAPAlternativeFundingStatusCode = q.REAPAlternativeFundingStatusCode
			and organizationStatus.McKinneyVentoSubgrantRecipientCode = q.McKinneyVentoSubgrantRecipient
		left join rds.DimComprehensiveAndTargetedSupports cts 
			on cts.ComprehensiveSupportImprovementCode =q.ComprehensiveSupportImprovementCode
			and cts.TargetedSupportImprovementCode = q.TargetedSupportImprovementCode			
			and cts.ComprehensiveSupportCode=q.ComprehensiveSupportCode
			and cts.TargetedSupportCode=q.TargetedSupportCode
			and cts.AdditionalTargetedSupportandImprovementCode = q.AdditionalTargetedSupportCode
		left join rds.DimCharterSchoolStatus ch
			on ch.AppropriationMethodCode = q.AppropriationMethodCode
	
		--Clear the temp tables
		DELETE FROM @SchoolDateQuery
		DELETE FROM @schoolStatusQuery
		DELETE FROM @title1StatusQuery
		DELETE FROM @organizationStatusSchoolQuery
		DELETE FROM @ComprehensiveAndTargetedSupport
		DELETE FROM @CharterSchoolStatusQuery
		DROP TABLE #queryOutput


	FETCH NEXT FROM SCH_Cursor INTO @dimSchoolId, @schoolStateIdentifier, @dimDateId		
	END
		
	close SCH_Cursor
	DEALLOCATE SCH_Cursor
		
	-------------------------------------------------------
	--Debug query for RunAsTest
	-------------------------------------------------------
	IF @runAsTest = 1
	BEGIN
		select 'FactOrganizationCounts - Schools' as TableName, * 
		from rds.FactOrganizationCounts 
		where DimSchoolId <> -1
		and DimCountDateId = @dimDateId
		and DimFactTypeId = @factTypeId
	END
	-------------------------------------------------------

commit transaction
end try
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	SET @msg = ' Error Number: ' + CAST(ERROR_NUMBER() as varchar) + ' : Line: ' + CAST(ERROR_LINE() as varchar) +    ' : Message: ' + CAST(error_message() as varchar(4000)) 
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch

END