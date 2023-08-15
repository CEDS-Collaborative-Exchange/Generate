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
			Orgnization Declarations
		*/
		declare @migrationType as varchar(50)
		declare @dataMigrationTypeId as int
		declare @schoolIdentifierTypeId as int
		declare @schoolSEAIdentificationSystemId as int
		declare @schoolNCESIdentificationSystemId as int
		declare @schoolOrgTypeId as int
		declare @schoolStateIdentifier as int
		declare @schoolId as varchar(500)
	
		declare @charterSchoolManagerIdentifierTypeId as int
		declare @charterSchoolManagerIdentificationSystemId as int
		declare @charterSchoolManagerOrganizationIdentifierTypeId as int
		declare @charterSchoolManagerOrganizationIdentificationSystemId as int
		declare @charterAuthorizerIdentificationSystemId as int
		declare @dimDateId as int

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

		declare @dimSeaId as int, @dimPersonnelId int, @dimLeaId int, @dimSchoolId int, @IsCharterSchool as bit, @leaStateIdentifier as int
		
		declare @count as int
		declare @dimCharterSchoolManagerId as int
		declare @dimCharterSchoolSecondaryManagerId as int
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

		if not exists (select 1 from RDS.DimCharterSchoolApproverAgency where DimCharterSchoolApproverAgencyId = -1)
		begin
			set identity_insert RDS.DimCharterSchoolApproverAgency on
			insert into RDS.DimCharterSchoolApproverAgency (DimCharterSchoolApproverAgencyId) values (-1)
			set identity_insert RDS.DimCharterSchoolApproverAgency off
		end

	END
	
	-- DimSeas
	BEGIN
	/*
		-- Merge DimSeas
	*/
		WITH DATECTE AS (
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
		)
		, CTE as 
		( 
			select o.Name as SeaName, i.Identifier, s.Code, rsCode.StateName,	
				mailingAddress.StreetNumberAndName as MailingStreet, mailingAddress.City as MailingCity, mailingAddress.StateCode as MailingState, 
				mailingAddress.PostalCode as MailingPostalCode, 
				physicalAddress.StreetNumberAndName, physicalAddress.City,	physicalAddress.StateCode,	physicalAddress.PostalCode,					
				phone.TelephoneNumber, website.Website,
				startDate.RecordStartDateTime AS RecordStartDateTime,
				endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate 
				ON startDate.OrganizationId = endDate.OrganizationId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.OrganizationDetail o 
				ON o.OrganizationId = startDate.Organizationid
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
		)
		MERGE rds.DimSeas as trgt
		USING CTE as src
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

	END
	
	-- DimPersonnel
	BEGIN
	/*
	---- Merge DimPersonnel
	*/
		WITH DATECTE AS (
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
		)
		, CTE as 
		( 
			select p.Birthdate,	p.FirstName, p.LastName, p.MiddleName, p.PersonId, 	Identifier, EmailAddress,TelephoneNumber,PositionTitle,
					@personnelRole as CSSORole,
					 startDate.RecordStartDateTime AS RecordStartDateTime,
					endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate 
				ON startDate.PersonId = endDate.PersonId 
				AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.PersonDetail p 
				ON p.PersonId = startDate.PersonId  
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
		)
		MERGE rds.DimPersonnel as trgt
		USING CTE as src
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

	END

	-- DimLeas
	BEGIN
	/*
	----DimLeas
	*/
	
		;WITH DATECTE AS (
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
		)
		, CTE as 
		( 
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
				refop.Code as LeaOperationalStatus,	
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
				case when lea.CharterSchoolIndicator = 1 AND leaType.Code = 'RegularNotInSupervisoryUnion' then isnull(cl.Code, 'MISSING') 
				else IIF(@charterLeaCount > 0,'NOTCHR','NA') end as CharterLeaStatus,
				isnull(r.Code, 'MISSING') as ReconstitutedStatus,
				startDate.RecordStartDateTime AS RecordStartDateTime,
				endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate 
				ON startDate.OrganizationId = endDate.OrganizationId 
				AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.OrganizationDetail o 
				ON o.OrganizationId = startDate.Organizationid
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
		)
		MERGE rds.DimLeas as trgt
		USING CTE as src
				ON trgt.LeaStateIdentifier = src.StateIdentifier
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN 
				Update SET trgt.LeaName = src.Name,
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
				(src.Name, src.NCESIdentifier, src.StateIdentifier, 
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



		;WITH CTE as
		(
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
		)
		MERGE rds.BridgeLeaGradeLevels as trgt
		USING CTE as src
			ON trgt.DimLeaID = src.DimLeaID
			AND trgt.DimGradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT(DimLeaId,DimGradeLevelId) values(src.DimLeaID, src.DimGradeLevelId);

	END

	-- DimCharterSchoolApproverAgency
	BEGIN
	/*
		---DimCharterSchoolApproverAgency
		--organizationtype = 30(MO), 31(Authorizer)
	*/


		 WITH DATECTE AS (
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
		)
		, CTE as 
		(
			SELECT DISTINCT	o.Name, i.Identifier AS LeaSateIdentifier, charterSchoolApprovalAgencyType.Code AS LeaTypeCode,
				charterSchoolApprovalAgencyType.[Description] AS LeaTypeDescription,charterSchoolApprovalAgencyType.Code as LeaTypeEdfactsCode, -- EdFact
				charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId,
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
				i.Identifier AS SchoolStateIdentifier,
				startDate.RecordStartDateTime AS RecordStartDateTime,
				endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
			LEFT JOIN DATECTE endDate 
				ON startDate.OrganizationId = endDate.OrganizationId 
				AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.OrganizationDetail o 
				ON o.OrganizationId = startDate.Organizationid
				AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
			inner join ods.K12CharterSchoolManagementOrganization d 
				on d.OrganizationId = O.OrganizationId 
				AND o.RefOrganizationTypeId = @charterSchoolMgrTypeId 
			inner join ODS.RefCharterSchoolManagementOrganizationType charterSchoolApprovalAgencyType 
				on charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId = d.RefCharterSchoolManagementOrganizationTypeId	
			inner join ods.OrganizationIdentifier i 
				on o.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem aaa 
				on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
				and aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId
			inner join ods.RefOrganizationType t 
				on o.RefOrganizationTypeId = t.RefOrganizationTypeId															
			left join ods.OrganizationWebsite website 
				on o.OrganizationId = website.OrganizationId
			left join ods.OrganizationTelephone phone 
				on o.OrganizationId = phone.OrganizationId
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
		)
		MERGE rds.DimCharterSchoolApproverAgency AS trgt
		USING CTE AS src
				ON trgt.StateIdentifier = src.LeaSateIdentifier
				AND trgt.IsApproverAgency = 'No'
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
			Update SET trgt.Name = src.Name,
						trgt.StateCode = src.StateCode,
						trgt.StateANSICode = src.StateANSICode,
						trgt.[State] = src.[State],
						trgt.OrganizationType = src.Code,
						trgt.LeaTypeCode = src.LeaTypeCode,
						trgt.LeaTypeDescription = src.LeaTypeDescription,
						trgt.LeaTypeEdFactsCode = src.LeaTypeEdFactsCode,
						trgt.LeaTypeId = src.RefCharterSchoolManagementOrganizationTypeId,
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
		INSERT(Name,StateIdentifier,StateCode,StateANSICode,[State],OrganizationType,IsApproverAgency,
		LeaTypeCode,LeaTypeDescription,LeaTypeEdFactsCode,LeaTypeId,MailingAddressStreet,MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
		OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,PhysicalAddressPostalCode,Telephone,Website,
		RecordStartDateTime,RecordEndDateTime)
		VALUES(src.Name,src.LeaSateIdentifier, @stateCode, @seaIdentifier, @stateName,src.Code,'No',
			src.LeaTypeCode,src.LeaTypeDescription,src.LeaTypeEdFactsCode,src.RefCharterSchoolManagementOrganizationTypeId,src.MailingStreet,
			src.MailingCity,src.MailingStateCode,src.MailingPostalCode,src.OutOfStateIndicator,src.StreetNumberAndName,src.City,src.PhysicalStateCode,src.PostalCode,
			src.TelephoneNumber,src.Website,src.RecordStartDateTime,src.RecordEndDateTime);

		;WITH upd AS(
			SELECT DimCharterSchoolApproverAgencyId, StateIdentifier, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimCharterSchoolApproverAgency  
			WHERE RecordEndDateTime is null 
			and DimCharterSchoolApproverAgencyId <> -1 
			and IsApproverAgency = 'No'
		) 
		UPDATE charter SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimCharterSchoolApproverAgency charter
		inner join upd	
			on charter.DimCharterSchoolApproverAgencyId = upd.DimCharterSchoolApproverAgencyId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

	END

	-- DimCharterSchoolAuthorizer
	BEGIN
	/*
		-- DimCharterSchoolAuthorizer
	*/

	WITH DATECTE AS (
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
		)
		, CTE as 
		(
			SELECT DISTINCT	o.Name, i.Identifier as LeaSateIdentifier, charterSchoolApprovalAgencyType.Code as LeaTypeCode,	
				charterSchoolApprovalAgencyType.Description as LeaTypeDescription,
				charterSchoolApprovalAgencyType.Code as LeaTypeEdfactsCode, -- EdFact
				charterSchoolApprovalAgencyType.RefCharterSchoolApprovalAgencyTypeId,
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
				charterSchoolApprovalAgencyType.[Code], 1 as OutOfStateIndicator,
				@stateCode as StateCode, @seaIdentifier as StateANSICode, @stateName as [State],
				i.Identifier AS SchoolStateIdentifier,
				startDate.RecordStartDateTime AS RecordStartDateTime,
				endDate.RecordStartDateTime - 1 AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate 
				ON startDate.OrganizationId = endDate.OrganizationId 
				AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.OrganizationDetail o 
				ON o.OrganizationId = startDate.Organizationid
                AND startDate.RecordStartDateTime BETWEEN o.RecordStartDateTime AND ISNULL(o.RecordEndDateTime, GETDATE())
			inner join ods.K12CharterSchoolApprovalAgency d 
				on d.OrganizationId = o.OrganizationId 
				and o.RefOrganizationTypeId = @charterSchoolAuthTypeId 
			inner join ODS.RefCharterSchoolApprovalAgencyType charterSchoolApprovalAgencyType 
				on charterSchoolApprovalAgencyType.RefCharterSchoolApprovalAgencyTypeId = d.RefCharterSchoolApprovalAgencyTypeId	
			inner join ods.OrganizationIdentifier i 
				on o.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem aaa 
				on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
				and aaa.RefOrganizationIdentificationSystemId=@charterAuthorizerIdentificationSystemId
			inner join ods.RefOrganizationType t 
				on o.RefOrganizationTypeId = t.RefOrganizationTypeId
			left join ods.OrganizationWebsite website 
				on o.OrganizationId = website.OrganizationId
			left join ods.OrganizationTelephone phone 
				on o.OrganizationId = phone.OrganizationId
			left join  
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode 
					from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la 
						on ol.LocationId = la.LocationId
					inner join ods.RefState refState 
						on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 1 -- mailing
				) mailingAddress 
				on mailingAddress.OrganizationId = d.OrganizationId
			left join 
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  
					from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la 
						on ol.LocationId = la.LocationId
					inner join ods.RefState refState 
						on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 2 -- Physical
				) physicalAddress 
				on physicalAddress.OrganizationId = d.OrganizationId
		)
		MERGE rds.DimCharterSchoolApproverAgency AS trgt
		USING CTE AS src
				ON trgt.StateIdentifier = src.LeaSateIdentifier
				AND trgt.IsApproverAgency = 'Yes'
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
			Update SET trgt.Name = src.Name,							
						trgt.StateCode = src.StateCode,
						trgt.StateANSICode = src.StateANSICode,
						trgt.[State] = src.[State],
						trgt.OrganizationType = src.Code,							
						trgt.LeaTypeCode = src.LeaTypeCode,
						trgt.LeaTypeDescription = src.LeaTypeDescription,
						trgt.LeaTypeEdFactsCode = src.LeaTypeEdFactsCode,
						trgt.LeaTypeId = src.RefCharterSchoolApprovalAgencyTypeId,
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
		INSERT(Name,StateIdentifier,StateCode,StateANSICode,[State],OrganizationType,IsApproverAgency,
		LeaTypeCode,LeaTypeDescription,LeaTypeEdFactsCode,LeaTypeId,MailingAddressStreet,MailingAddressCity,MailingAddressState,MailingAddressPostalCode,
		OutOfStateIndicator,PhysicalAddressStreet,PhysicalAddressCity,PhysicalAddressState,PhysicalAddressPostalCode,Telephone,Website,RecordStartDateTime,RecordEndDateTime)
		VALUES(src.Name,src.LeaSateIdentifier, @stateCode, @seaIdentifier, @stateName,src.Code,'Yes',
				src.LeaTypeCode,src.LeaTypeDescription,src.LeaTypeEdFactsCode,src.RefCharterSchoolApprovalAgencyTypeId,src.MailingStreet,src.MailingCity,
				src.MailingStateCode,src.MailingPostalCode,src.OutOfStateIndicator,src.StreetNumberAndName,src.City,src.PhysicalStateCode,src.PostalCode,
				src.TelephoneNumber,src.Website,src.RecordStartDateTime,src.RecordEndDateTime);


		;WITH upd AS(
			SELECT DimCharterSchoolApproverAgencyId, StateIdentifier, RecordStartDateTime, 
			LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StateIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimCharterSchoolApproverAgency  
			WHERE RecordEndDateTime is null 
			and DimCharterSchoolApproverAgencyId <> -1 
			and IsApproverAgency = 'Yes'
		) 
		UPDATE charter SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimCharterSchoolApproverAgency charter
		inner join upd	
			on charter.DimCharterSchoolApproverAgencyId = upd.DimCharterSchoolApproverAgencyId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'

	END

	-- DimSchool
	BEGIN
	/*
	-- DimSchool
	*/

		WITH DATECTE AS (
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
		)
		, CTE as 
		( 
			select distinct  
				isnull(leaNCESIdentifier.Identifier, '') as LeaNcesIdentifier, 
				leaStateIdentifier.Identifier as LeaStateIdentifier,lea.Name as LeaOrganizationName, 
				isnull(schoolNCESIdentifier.Identifier, '') as SchoolNcesIdentifier,
				schoolStateIdentifier.Identifier as SchoolStateIdentifier, o.Name as SchoolName, 
				refop.Code as SchOperationalStatus,
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
			from DATECTE startDate
            LEFT JOIN DATECTE endDate 
				ON startDate.OrganizationId = endDate.OrganizationId 
				AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.OrganizationDetail o 
				ON o.OrganizationId = startDate.Organizationid
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
		)
		MERGE rds.DimSchools as trgt
		USING CTE as src
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

		;WITH CTE as
		(
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
		)
		MERGE rds.BridgeSchoolGradeLevels as trgt
		USING CTE as src
						ON trgt.DimSchoolId = src.DimSchoolId
						AND trgt.DimGradeLevelId = src.DimGradeLevelId
		WHEN NOT MATCHED THEN
		INSERT(DimSchoolId, DimGradeLevelId) values(src.DimSchoolId, src.DimGradeLevelId);


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


	declare @organiationDateQuery as TABLE(DimOrganizationId int, StateIdentifier varchar(50), DimDateId int) 
				
	insert into @organiationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'SEA'


	declare SEA_Cursor cursor for 						
	select DimOrganizationId,DimDateId from @organiationDateQuery

	open SEA_Cursor
	FETCH NEXT FROM SEA_Cursor INTO @dimSeaId, @dimDateId							

	WHILE @@FETCH_STATUS = 0
	BEGIN
							
			
		INSERT INTO [RDS].[FactOrganizationCounts]([DimCountDateId],
		[DimOrganizationStatusId],[DimFactTypeId],[DimLeaId],[DimPersonnelId],[DimSchoolId],[DimSchoolStatusId],[DimSeaId],[DimTitle1StatusId],			[OrganizationCount],[DimCharterSchoolApproverAgencyId],[DimCharterSchoolManagerOrganizationId],[DimCharterSchoolSecondaryApproverAgencyId],		[DimCharterSchoolUpdatedManagerOrganizationId],[DimSchoolStateStatusId])
		VALUES(@dimDateId,-1,@factTypeId,-1,isnull(@dimPersonnelId, -1),-1,-1,@dimSeaId,-1,1,-1,-1,-1,-1,-1)


	FETCH NEXT FROM SEA_Cursor INTO @dimSeaId, @dimDateId			
	END
		
	close SEA_Cursor
	DEALLOCATE SEA_Cursor

	delete from @organiationDateQuery

	insert into @organiationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'LEA'


	declare LEA_Cursor cursor for 						
	select DimOrganizationId, StateIdentifier, DimDateId from @organiationDateQuery

	open LEA_Cursor
	FETCH NEXT FROM LEA_Cursor INTO @dimLeaId, @leaStateIdentifier, @dimDateId							

	WHILE @@FETCH_STATUS = 0
	BEGIN

		declare @LeaDateQuery as rds.LeaDateTableType
			
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
			,[DimCharterSchoolApproverAgencyId]
			,[DimCharterSchoolManagerOrganizationId]
			,[DimCharterSchoolSecondaryApproverAgencyId]
			,[DimCharterSchoolUpdatedManagerOrganizationId]
			,[DimSchoolStateStatusId]
			,[FederalFundAllocationType]
			,[FederalProgramCode]
			,[FederalFundAllocated]
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
			-1 as 'DimCharterSchoolApproverAgencyId',
			-1 as'DimCharterSchoolManagerOrganizationId',
			-1 as'DimCharterSchoolSecondaryApproverAgencyId',
			-1 as'DimCharterSchoolUpdatedManagerOrganizationId',
			-1 as 'DimSchoolStateStatusId',
			ISNULL(q.FederalFundAllocationType, 'MISSING') as 'FederalFundAllocationType',
			ISNULL(q.FederalProgramCode, 'MISSING') as 'FederalPrgoramCode',
			isnull(q.FederalFundAllocated,0)
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


	delete from @organiationDateQuery

	insert into @organiationDateQuery(DimOrganizationId,StateIdentifier,DimDateId)
	exec rds.Migrate_DimDates_Organizations 'SCHOOL'


	declare SCH_Cursor cursor for 						
	select DimOrganizationId, StateIdentifier, DimDateId from @organiationDateQuery


	open SCH_Cursor
	FETCH NEXT FROM SCH_Cursor INTO @dimSchoolId, @schoolStateIdentifier, @dimDateId						

	WHILE @@FETCH_STATUS = 0
	BEGIN

		set @dimCharterSchoolManagerId=-1
		set @dimCharterSchoolSecondaryManagerId=-1
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
				ComprehensiveAndTargetedSupportCode varchar(50),
				ComprehensiveSupportCode varchar(50),
				TargetedSupportCode varchar(50)
			)
		insert into @ComprehensiveAndTargetedSupport (
			DimCountDateId,
			DimSchoolId,
			ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportCode,
			TargetedSupportCode
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

		--declare @schoolOrganizationId as int

		--select @schoolOrganizationId = OrganizationId from ods.OrganizationIdentifier where Identifier = @schoolStateIdentifier
		select @IsCharterSchool = CharterSchoolIndicator from rds.DimSchools where SchoolStateIdentifier = @schoolStateIdentifier

		if @IsCharterSchool = 1
		begin
				
			select @count = count(DimCharterSchoolApproverAgencyId) from rds.DimCharterSchoolApproverAgency 
			where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'No'

			IF @count = 1
			BEGIN
				select @dimCharterSchoolAuthorizerId = DimCharterSchoolApproverAgencyId from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'No'
			END
			ELSE
			BEGIN
				select @dimCharterSchoolAuthorizerId = min(DimCharterSchoolApproverAgencyId) from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'No'

				select @dimCharterSchoolSecondaryAuthorizerId = max(DimCharterSchoolApproverAgencyId)
				from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'No'
			END

			set @count = 0


			select @count = count(DimCharterSchoolApproverAgencyId) from rds.DimCharterSchoolApproverAgency 
			where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'Yes'

	

			IF @count = 1
			BEGIN
				select @dimCharterSchoolManagerId = DimCharterSchoolApproverAgencyId from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'Yes'
			END
			ELSE
			BEGIN
				select @dimCharterSchoolManagerId = min(DimCharterSchoolApproverAgencyId) from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'Yes'

				select @dimCharterSchoolSecondaryManagerId = max(DimCharterSchoolApproverAgencyId)
				from rds.DimCharterSchoolApproverAgency 
				where SchoolStateIdentifier = @schoolStateIdentifier and IsApproverAgency = 'Yes'
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
			ComprehensiveAndTargetedSupportCode varchar(50),
			ComprehensiveSupportCode varchar(50),
			TargetedSupportCode varchar(50)
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
			ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportCode,
			TargetedSupportCode      
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
			ISNULL(cts.ComprehensiveAndTargetedSupportCode ,'MISSING'),
			ISNULL(cts.ComprehensiveSupportCode ,'MISSING'),
			ISNULL(cts.TargetedSupportCode ,'MISSING')
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
			on s.DimSchoolId=cts.DimSchoolId 
			and s.DimCountDateId=cts.DimCountDateId
			
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
			,[DimCharterSchoolApproverAgencyId]
			,[DimCharterSchoolManagerOrganizationId]
			,[DimCharterSchoolSecondaryApproverAgencyId]
			,[DimCharterSchoolUpdatedManagerOrganizationId]
			,[SCHOOLIMPROVEMENTFUNDS]
			,DimComprehensiveAndTargetedSupportId
			,FederalFundAllocated
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
				ISNULL(@dimCharterSchoolManagerId, -1) as 'DimCharterSchoolApproverAgencyId',
				ISNULL(@dimCharterSchoolAuthorizerId, -1) as'DimCharterSchoolManagerOrganizationId',		
				ISNULL(@dimCharterSchoolSecondaryManagerId, -1) as'DimCharterSchoolSecondaryApproverAgencyId',
				ISNULL(@dimCharterSchoolSecondaryAuthorizerId, -1) as'DimCharterSchoolUpdatedManagerOrganizationId',
				isnull(q.SchImprovementAllocations,0),
				ISNULL(cts.DimComprehensiveAndTargetedSupportId,-1) as 'DimComprehensiveAndTargetedSupportId',
				isnull(q.SchImprovementAllocations,0)
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
			on cts.ComprehensiveAndTargetedSupportCode=q.ComprehensiveAndTargetedSupportCode
			and cts.ComprehensiveSupportCode=q.ComprehensiveSupportCode
			and cts.TargetedSupportCode=q.TargetedSupportCode
	
		--Clear the temp tables
		DELETE FROM @SchoolDateQuery
		DELETE FROM @schoolStatusQuery
		DELETE FROM @title1StatusQuery
		DELETE FROM @organizationStatusSchoolQuery
		DELETE FROM @ComprehensiveAndTargetedSupport
		DROP TABLE #queryOutput


	FETCH NEXT FROM SCH_Cursor INTO @dimSchoolId, @schoolStateIdentifier, @dimDateId		
	END
		
	close SCH_Cursor
	DEALLOCATE SCH_Cursor
		
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