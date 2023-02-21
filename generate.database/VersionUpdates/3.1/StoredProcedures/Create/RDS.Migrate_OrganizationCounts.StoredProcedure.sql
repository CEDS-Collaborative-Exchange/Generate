CREATE PROCEDURE [RDS].[Migrate_OrganizationCounts]
	@factTypeCode as varchar(50) = 'directory',
	@runAsTest as bit 
AS 
BEGIN
-- migrate_OrganizationCounts
begin try
begin transaction	
	declare @factTable as varchar(50)
	set @factTable = 'FactPersonnelCounts'

	declare @migrationType as varchar(50)
	declare @dataMigrationTypeId as int
	
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


	declare	@seaStateIdentifer varchar(50),
	@stateANSICode varchar(10),
									
								
	--DimDirectories fiels 
	@LeaTypeCode varchar(50),
	@LeaTypeDescription varchar(100),
	@LeaTypeEdFactsCode varchar(50),
	@LeaTypeId int,

	@MailingAddressStreet varchar(40),
	@MailingAddressCity as varchar(30),
	@MailingAddressState varchar(50),
	@MailingAddressPostalCode varchar(20),	

	@OutOfStateIndicator bit,
	@PhysicalAddressStreet  varchar(40),
	@PhysicalAddressCity  varchar(30) ,
	@PhysicalAddressState  varchar(50),
	@PhysicalAddressPostalCode  varchar(20),
	@charterAuthorizerType varchar(50),
	@charterManagerType varchar(50),					
								
	@SchoolTypeCode   varchar(50),
	@SchoolTypeDescription  varchar(100),
	@SchoolTypeEdFactsCode  varchar(50),
	@SchoolTypeId int,
								
	@Telephone  varchar(24),
	@Website  varchar(300),
	@effectiveDate datetime,

	@leaName varchar(1000), 
	@LeaNcesIdentifier varchar(50), 
	@leaOrganizationId int, 
	@leaOrganizationIds int,
	@LeaStateIdentifiers varchar(50),
	@LeaStateIdentifier varchar(50),
	@PriorLeaStateIdentifier varchar(50),
	@SupervisoryIdNum varchar(3),
				--CIID-1963
	@ReportedFederally  bit = 1,

	@dimSeaId int = 0,
	@dimLeaId int = 0,
	@dimDirectoryId int = 0,
	@dimPersonnelId int = 0

	if not exists (select 1 from RDS.Dimseas)
		begin
			set identity_insert RDS.Dimseas on
			insert into RDS.DimSeas (DimSeaId) values (-1)
			set identity_insert RDS.Dimseas off
		end

	if not exists (select 1 from RDS.DimLeas)
		begin
			set identity_insert RDS.DimLeas on
			insert into RDS.DimLeas (DimLeaId) values (-1)
			set identity_insert RDS.DimLeas off
		end

	if not exists (select 1 from RDS.DimSchools)
		begin
			set identity_insert RDS.DimSchools on
			insert into RDS.DimSchools (DimSchoolId) values (-1)
			set identity_insert RDS.DimSchools off
		end

	if not exists (select 1 from RDS.DimCharterSchoolApproverAgency)
		begin
			set identity_insert RDS.DimCharterSchoolApproverAgency on
			insert into RDS.DimCharterSchoolApproverAgency (DimCharterSchoolApproverAgencyId) values (-1)
			set identity_insert RDS.DimCharterSchoolApproverAgency off
		end
	IF not exists (select 1 from RDS.DimSeas where DimSeaId <> -1)
	BEGIN		
		declare SEA_Cursor cursor for 						
		select distinct o.Name, 
			o.OrganizationId, 
			i.Identifier,
			i.Identifier,
			s.Code,
			rsCode.StateName,
			leaType.Code as LeaTypeCode,
			leaType.Description as LeaTypeDescription,
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
			END, -- EdFact
			leaType.RefLeaTypeId,
	
			mailingAddress.StreetNumberAndName, 
			mailingAddress.City, 
			mailingAddress.StateCode, 
			mailingAddress.PostalCode, 
			--out of state Indicator -- needs to calculate
			'0',
			physicalAddress.StreetNumberAndName,
			physicalAddress.City,
			physicalAddress.StateCode,
			physicalAddress.PostalCode,
						
			schoolType.Code as schoolTypeCode,
			schoolType.Description as SchoolTypeDescription,
			CASE schoolType.Code 
					WHEN 'Regular' then 1
					WHEN 'Special' then 2
					WHEN 'CareerAndTechnical' then 3
					WHEN 'Alternative' then 4
					WHEN 'Reportable' then 5
			END,
			schoolType.RefSchoolTypeId as SchoolTypeId,

			phone.TelephoneNumber,
			website.Website
	
			--t.Code as organizationType											
		from  ods.OrganizationDetail o 								
		inner join ods.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
		inner join ods.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId											
		left join ods.RefStateANSICode rsCode on rsCode.Code = i.Identifier
		left join ods.RefState s on s.Description = rsCode.StateName	
		left join ods.OrganizationWebsite website on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone on o.OrganizationId = phone.OrganizationId
		left join  
					(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode from ODS.OrganizationLocation ol
						inner join ods.LocationAddress la on ol.LocationId = la.LocationId
						inner join ods.RefState refState on refState.RefStateId = la.RefStateId
						where RefOrganizationLocationTypeId = 1 -- mailing
						) mailingAddress on mailingAddress.OrganizationId = o.OrganizationId
		left join (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  from ODS.OrganizationLocation ol
						inner join ods.LocationAddress la on ol.LocationId = la.LocationId
						inner join ods.RefState refState on refState.RefStateId = la.RefStateId
						where RefOrganizationLocationTypeId = 2 -- Physical
						) physicalAddress on physicalAddress.OrganizationId = o.OrganizationId
			left join ods.K12Lea lea on lea.OrganizationId = o.OrganizationId
			left join ods.RefLeaType leaType on lea.RefLeaTypeId = leaType.RefLeaTypeId
			left join ods.K12School school on school.OrganizationId = o.OrganizationId
			left join ods.RefSchoolType schoolType on schoolType.RefSchoolTypeId = school.RefSchoolTypeId
		where o.RefOrganizationTypeId = @seaOrgTypeId 
		AND o.RecordEndDateTime IS NULL

		open SEA_Cursor
		FETCH NEXT FROM SEA_Cursor INTO @seaName, @SeaOrganizationId, @seaStateIdentifer, @stateANSICode, @stateCode, @stateName,
										@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
										@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
										@OutOfStateIndicator ,
										@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
										@SchoolTypeCode, @SchoolTypeDescription, @SchoolTypeEdFactsCode, @SchoolTypeId,
										@Telephone, @Website							

		WHILE @@FETCH_STATUS = 0
			BEGIN
				--insert into DimSea 
				INSERT INTO [RDS].[DimSeas] (
					[SeaName]
					,[SeaOrganizationId]
					,[SeaStateIdentifier]
					,[StateANSICode]
					,[StateCode]
					,[StateName])
				VALUES 
					(@seaName, 
					@SeaOrganizationId, 
					@seaStateIdentifer, 
					@stateANSICode, 
					@stateCode, 
					@stateName)

				SET @dimSeaId = SCOPE_IDENTITY()
				-- insert the corresponding Directory info 
												
							
				INSERT INTO [RDS].[DimDirectories]
							(
							[LeaTypeCode]
							,[LeaTypeDescription]
							,[LeaTypeEdFactsCode]
							,[LeaTypeId]

							,[MailingAddressStreet]
							,[MailingAddressCity]
							,[MailingAddressState]
							,[MailingAddressPostalCode]
										   
										   

							,[OutOfStateIndicator]

							,[PhysicalAddressStreet]
							,[PhysicalAddressCity]
							,[PhysicalAddressState]
							,[PhysicalAddressPostalCode]

							,[SchoolTypeCode]
							,[SchoolTypeDescription]
							,[SchoolTypeEdFactsCode]
							,[SchoolTypeId]
							,[Telephone]
							,[Website])
					values 
						(

						@LeaTypeCode,
						@LeaTypeDescription,
						@LeaTypeEdFactsCode,
						@LeaTypeId,
						@MailingAddressStreet,
						@MailingAddressCity,
						@MailingAddressState,
						@MailingAddressPostalCode,	
						@OutOfStateIndicator,
						@PhysicalAddressStreet,
						@PhysicalAddressCity,
						@PhysicalAddressState,
						@PhysicalAddressPostalCode,	
						@SchoolTypeCode ,
						@SchoolTypeDescription,
						@SchoolTypeEdFactsCode,
						@SchoolTypeId ,
						@Telephone  ,
						@Website  
						)

				SET @dimDirectoryId = SCOPE_IDENTITY()

				-- insert into Bridgetable 		
				INSERT INTO [RDS].[BridgeDirectoryDate]
							([DimDirectoryId]
							,[DimDateId])
				SELECT @dimDirectoryId, d.DimDateId
				from rds.DimDates d
				inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
				inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
				where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode = 'rds'

				--insert CSSO information into Personnel 



				INSERT INTO [RDS].[DimPersonnel]
						([BirthDate]
						,[FirstName]
						,[LastName]
						,[MiddleName]
						,[PersonnelPersonId]
						,[StatePersonnelIdentifier]
						,[Email]
						,[Telephone]
						,[Title]
						,PersonnelRole
						)
				select Birthdate,
					FirstName, 
					LastName, 
					MiddleName, 
					p.PersonId, 
					Identifier, -- StatePersonnelIdentifier
					EmailAddress,
					TelephoneNumber,
					PositionTitle,
					@personnelRole
				from ods.PersonDetail p
				inner join ods.OrganizationPersonRole r on r.PersonId = p.PersonId and r.RoleId = @CSSORoleId		  
				AND p.RecordEndDateTime IS NULL
				left join ods.PersonIdentifier i on i.PersonId = p.PersonId
				left join ods.PersonEmailAddress e on e.PersonId = p.PersonId
				left join ods.StaffEmployment emp on emp.OrganizationPersonRoleId = r.OrganizationPersonRoleId
				left join ods.PersonTelephone tel on tel.PersonId = p.PersonId
				where r.OrganizationId = @SeaOrganizationId
					
				set @dimPersonnelId = SCOPE_IDENTITY()	
				
				INSERT INTO [RDS].[FactOrganizationCounts]
					([DimCountDateId]
					,[DimDirectoryId]
					,[DimDirectoryStatusId]
					,[DimOrganizationStatusId]
					,[DimFactTypeId]
					,[DimLeaId]
					,[DimPersonnelId]
					,[DimSchoolId]
					,[DimSchoolStatusId]
					,[DimSeaId]
					,[DimTitle1StatusId]
					,[OrganizationCount]
					,[DimCharterSchoolApproverAgencyId]
					,[DimCharterSchoolManagerOrganizationId]
					,[DimCharterSchoolSecondaryApproverAgencyId]
					,[DimCharterSchoolUpdatedManagerOrganizationId]
					,[DimCharterSchoolPrimaryApproverAgencyDirectoryId]
					,[DimCharterSchoolSecondaryApproverAgencyDirectoryId]
					,[DimCharterSchooleManagerDirectoryId]
					,[DimCharterSchoolUpdatedManagerDirectoryId]
					,[DimSchoolStateStatusId])

				SELECT 
					DimDateId as DimCountDateId,
					@dimDirectoryId,
					-1,
					-1,
					@factTypeId, 
					-1 as 'DimLeaId',
					isnull( @dimPersonnelId, -1) as 'DimPersonnelId',
					-1 as 'DimSchoolId',
					-1 as 'DimSchoolStatusId',
					@dimSeaId,
					-1 as 'DimTitle1StatusId',
					1 as OrganizationCount,
					-1 as 'DimCharterSchoolApproverAgencyId',
					-1 as'DimCharterSchoolManagerOrganizationId',
					-1 as'DimCharterSchoolSecondaryApproverAgencyId',
					-1 as'DimCharterSchoolUpdatedManagerOrganizationId',
					-1 as 'DimCharterSchoolPrimaryApproverAgencyDirectoryId',
					-1 as'DimCharterSchoolSecondaryApproverAgencyDirectoryId',		
					-1 as'DimCharterSchooleManagerDirectoryId',
					-1 as'DimCharterSchoolUpdatedManagerDirectoryId',
					-1 as 'DimSchoolStateStatusId'
				from rds.BridgeDirectoryDate where DimDirectoryId = @dimDirectoryId   

		FETCH NEXT FROM SEA_Cursor INTO @seaName, @SeaOrganizationId, @seaStateIdentifer, @stateANSICode, @stateCode, @stateName,
										@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
										@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
										@OutOfStateIndicator ,
										@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
										@SchoolTypeCode, @SchoolTypeDescription, @SchoolTypeEdFactsCode, @SchoolTypeId,
										@Telephone, @Website							
		END
		
		close SEA_Cursor
		DEALLOCATE SEA_Cursor
	END


	--DimLeasSeed

	IF not exists (SELECT 1 FROM RDS.DimLeas where DimLeaId <> -1)
	BEGIN
		declare LEA_Cursor cursor for 
		SELECT DISTINCT					
		o.Name, 
		i.Identifier,  --LeaNces Identifier
		o.OrganizationId, 
		i1.Identifier,  -- LeaStateIdentifier		
		lea.SupervisoryUnionIdentificationNumber,

		--DimDirectory
		leaType.Code as LeaTypeCode,
		leaType.Description as LeaTypeDescription,
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
			END, -- EdFact
		leaType.RefLeaTypeId,
	
		mailingAddress.StreetNumberAndName, 
		mailingAddress.City, 
		mailingAddress.StateCode, 
		mailingAddress.PostalCode, 
				
		case when physicalAddress.StateCode <> @stateCode or mailingAddress.StateCode <> @stateCode then '1'
						else 0 end as OutOfState,
		physicalAddress.StreetNumberAndName,
		physicalAddress.City,
		physicalAddress.StateCode,
		physicalAddress.PostalCode,
						
		schoolType.Code as schoolTypeCode,
		schoolType.Description as SchoolTypeDescription,
		CASE schoolType.Code 
					WHEN 'Regular' then 1
					WHEN 'Special' then 2
					WHEN 'CareerAndTechnical' then 3
					WHEN 'Alternative' then 4
					WHEN 'Reportable' then 5
			END,
		schoolType.RefSchoolTypeId as SchoolTypeId,

		phone.TelephoneNumber,
		website.Website,
		isnull(op.OperationalStatusEffectiveDate,''),
		isnull(priorLea.Identifier,''), -- PriorLeaStateIdentifier
		
		-- CIID-1963
		CASE WHEN t.Code = 'LEANotFederal' THEN 0 ELSE 1 END AS ReportedFederally		
							from  ods.OrganizationDetail o 								
								left join ods.OrganizationIdentifier i on o.OrganizationId = i.OrganizationId
																		and i.RefOrganizationIdentificationSystemId = @leaNCESIdentificationSystemId
								inner join ods.OrganizationIdentifier i1 on o.OrganizationId =i1.OrganizationId
								and i1.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
								inner join ods.RefOrganizationType t on o.RefOrganizationTypeId = t.RefOrganizationTypeId	
																
								left join ods.OrganizationWebsite website on o.OrganizationId = website.OrganizationId
								left join ods.OrganizationTelephone phone on o.OrganizationId = phone.OrganizationId
								left join  
											(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode from ODS.OrganizationLocation ol
											 inner join ods.LocationAddress la on ol.LocationId = la.LocationId
											 inner join ods.RefState refState on refState.RefStateId = la.RefStateId
											 where RefOrganizationLocationTypeId = 1 -- mailing
											 ) mailingAddress on mailingAddress.OrganizationId = o.OrganizationId
								left join (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  from ODS.OrganizationLocation ol
											 inner join ods.LocationAddress la on ol.LocationId = la.LocationId
											  inner join ods.RefState refState on refState.RefStateId = la.RefStateId
											 where RefOrganizationLocationTypeId = 2 -- Physical
											 ) physicalAddress on physicalAddress.OrganizationId = o.OrganizationId
								left join ods.K12Lea lea on lea.OrganizationId = o.OrganizationId
								left join ods.RefLeaType leaType on lea.RefLeaTypeId = leaType.RefLeaTypeId
								left join ods.K12School school on school.OrganizationId = o.OrganizationId
								left join ods.RefSchoolType schoolType on schoolType.RefSchoolTypeId = school.RefSchoolTypeId
								left outer join ods.OrganizationOperationalStatus op on o.OrganizationId = op.OrganizationId
								left outer join ods.OrganizationIdentifier priorLea on o.OrganizationId = priorLea.OrganizationId
								and priorLea.RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId and priorLea.RecordEndDateTime IS NOT NULL
								where 
								--o.RefOrganizationTypeId = @leaOrgTypeId 
								--and 
								(t.Code = 'LEA' OR t.Code = 'LEANotFederal')
								AND o.RecordEndDateTime IS NULL
		
		open LEA_Cursor
		FETCH NEXT FROM LEA_Cursor INTO @leaName, @LeaNcesIdentifier, @leaOrganizationId, @LeaStateIdentifier,@SupervisoryIdNum,
											
											@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
											@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
											@OutOfStateIndicator ,
											@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
											@SchoolTypeCode, @SchoolTypeDescription, @SchoolTypeEdFactsCode, @SchoolTypeId,
											@Telephone, @Website, @effectiveDate , @PriorLeaStateIdentifier, @ReportedFederally						

		WHILE @@FETCH_STATUS = 0
		BEGIN
	
			INSERT INTO [RDS].[DimLeas]
           ([LeaName]
           ,[LeaNcesIdentifier]
           ,[LeaOrganizationId]
           ,[LeaStateIdentifier]
           ,[SeaName]
           ,[SeaOrganizationId]
           ,[SeaStateIdentifier]
           ,[StateANSICode]
           ,[StateCode]
           ,[StateName]
           ,[SupervisoryUnionIdentificationNumber]
		   ,EffectiveDate
		   ,PriorLeaStateIdentifier
		   ,ReportedFederally) 
		   
		   values (
			@leaName, 
			@LeaNcesIdentifier, 
			@leaOrganizationId, 
			@LeaStateIdentifier,
			@seaName, 
			@seaOrganizationId, 
			@seaIdentifier,
			@seaIdentifier, 
			@stateCode, 
			@stateName, 
			@SupervisoryIdNum,
			@effectiveDate,
			@PriorLeaStateIdentifier,
			@ReportedFederally
		   )

		   SET @dimLeaId = SCOPE_IDENTITY()

		   	INSERT INTO [RDS].[DimDirectories]
										   (
										   [LeaTypeCode]
										   ,[LeaTypeDescription]
										   ,[LeaTypeEdFactsCode]
										   ,[LeaTypeId]

										   ,[MailingAddressStreet]
										   ,[MailingAddressCity]
										   ,[MailingAddressState]
										   ,[MailingAddressPostalCode]
										   
										   

										   ,[OutOfStateIndicator]

										   ,[PhysicalAddressStreet]
										   ,[PhysicalAddressCity]
										   ,[PhysicalAddressState]
										   ,[PhysicalAddressPostalCode]

										   ,[SchoolTypeCode]
										   ,[SchoolTypeDescription]
										   ,[SchoolTypeEdFactsCode]
										   ,[SchoolTypeId]
										   ,[Telephone]
										   ,[Website])
									values 
										(

										@LeaTypeCode,
										@LeaTypeDescription,
										@LeaTypeEdFactsCode,
										@LeaTypeId,
										@MailingAddressStreet,
										@MailingAddressCity,
										@MailingAddressState,
										@MailingAddressPostalCode,	
										
											
										@OutOfStateIndicator,

										@PhysicalAddressStreet,	
										@PhysicalAddressCity,
										@PhysicalAddressState,	
										@PhysicalAddressPostalCode,
										
																				
										@SchoolTypeCode ,
										@SchoolTypeDescription,
										@SchoolTypeEdFactsCode,
										@SchoolTypeId ,
										@Telephone  ,
										@Website  
										)

			SET @dimDirectoryId = SCOPE_IDENTITY()
			
				-- insert into Bridgetables
								
							INSERT INTO [RDS].[BridgeDirectoryDate]
									   ([DimDirectoryId]
									   ,[DimDateId])
							SELECT @dimDirectoryId, d.DimDateId
							from rds.DimDates d
							inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
							inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
							where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode= 'rds'
		
		INSERT INTO [RDS].[BridgeDirectoryGradeLevels]
           ([DimDirectoryId]
           ,[DimGradeLevelId])
		SELECT distinct @dimDirectoryId, grades.DimGradeLevelId 
			FROM ods.OrganizationDetail o
			inner join ods.K12School sch on o.OrganizationId = sch.OrganizationId
			inner join ods.OrganizationRelationship r on r.OrganizationId = sch.OrganizationId
			inner join ods.K12Lea lea on lea.OrganizationId = r.Parent_OrganizationId
			inner join ods.K12SchoolGradeOffered g on g.K12SchoolId = sch.K12SchoolId
			inner join ods.RefGradeLevel l on l.RefGradeLevelId = g.RefGradeLevelId
											and RefGradeLevelTypeId = (select top 1 RefGradeLevelTypeId from ods.RefGradeLevelType where code = '000131')
			inner join RDS.DimGradeLevels grades on grades.GradeLevelCode = l.Code
    	 WHERE lea.OrganizationId = @leaOrganizationId			


		
		 --  declare @LeaDirectoryDateQuery as rds.LeaDateTableType
			
			--insert into @LeaDirectoryDateQuery
			--(
			--	DimLeaId,
			--	DimCountDateId
			--)
			--select @dimDirectoryId, b.DimDateId
			--from rds.BridgeDirectoryDate  b
			--where DimDirectoryId = @dimDirectoryId



			declare @LeaDirectoryDateQuery as rds.LeaDateTableType
			
			insert into @LeaDirectoryDateQuery
			(
				DimLeaId,
				DimCountDateId,
				SubmissionYearDate,
				[year],
				SubmissionYearStartDate,
				SubmissionYearEndDate
			)
		exec rds.Migrate_DimDates_Directories @dimDirectoryId, @dimLeaId, @migrationType
	
			--Migrate_DimDirectoryStatuses_LEA

			declare @leaDirectoryStatusQuery as table(
					DimCountDateId int,
					DimLeaId int,
					CharterLeaStatusCode varchar(50),
					CharterSchoolStatusCode varchar(50),
					OperationalStatusCode varchar(50),
					ReconstitutedStatusCode varchar(50),
					UpdatedOperationalStatusCode varchar(50),
					McKinneyVentoSubgrantRecipient varchar(50)
				)
			insert into @leaDirectoryStatusQuery
			(
					DimLeaId ,
					DimCountDateId ,
					CharterLeaStatusCode,
					CharterSchoolStatusCode,
					ReconstitutedStatusCode,
					OperationalStatusCode,
					UpdatedOperationalStatusCode,
					McKinneyVentoSubgrantRecipient
			)
			exec [RDS].[Migrate_DimDirectoryStatuses_Lea] @LeaDirectoryDateQuery

			--Migrate_DimOrganizationStatuses_LEA

			declare @leaOrganizationStatusQuery as table(
					DimCountDateId int,
					DimLeaId int,
					REAPAlternativeFundingStatusCode varchar(50),
					GunFreeStatusCode varchar(50)
				)
			insert into @leaOrganizationStatusQuery
			(
					DimLeaId ,
					DimCountDateId ,
					REAPAlternativeFundingStatusCode,
					GunFreeStatusCode
			)
			exec [RDS].[Migrate_DimOrganizationStatuses_Lea] @LeaDirectoryDateQuery




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
					DimCountDateId ,
					DimLeaId ,
					ParentalInvolvementReservationFunds ,
					FederalProgramsFundingAllocation,
					FederalFundAllocationType,
				FederalProgramCode 					
				)

	SELECT 
	DimCountDateId	,
	leadate.dimLeaID, 
	leaFund.ParentalInvolvementReservationFunds,
					FederalProgramsFundingAllocation as 'FederalProgramsFundingAllocation',
				allocationType.Code as 'FederalFundAllocationType',
				federalProgramCode as 'FederalProgramCode'
	
	 FROM ODS.OrganizationDetail o
	inner join ods.OrganizationCalendar oc on o.OrganizationId = oc.OrganizationId and o.organizationid =@leaOrganizationId
	inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
	inner join ods.K12LeaFederalFunds leaFund on leaFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
	inner join [ODS].[K12FederalFundAllocation] k12fund on leaFund.[OrganizationCalendarSessionId] = k12fund.[OrganizationCalendarSessionId]	
	inner join ODS.RefFederalProgramFundingAllocationType allocationType on allocationType.RefFederalProgramFundingAllocationTypeId= k12fund.RefFederalProgramFundingAllocationTypeId
	inner join	(select l.*, @leaOrganizationId as organizationId from  @LeaDirectoryDateQuery l) as leaDate 
						on leaDate.organizationId = o.OrganizationId 
											--and o.RecordStartDateTime between leaDate.SubmissionYearStartDate and leaDate.SubmissionYearEndDate
										--	and o.RecordEndDateTime is not null	

	-- Combine Dimension Data
		----------------------------

	create table #leaQueryOutput (
		QueryOutputId int IDENTITY(1,1) NOT NULL,
		
		DimCountDateId int,
		DimLeaId int,

		CharterLeaStatusCode varchar(50),
		CharterSchoolStatusCode varchar(50),
		OperationalStatusCode varchar(50),
		ReconstitutedStatusCode varchar(50),
		UpdatedOperationalStatusCode varchar(50),
		OrgCount int,
		[TitleiParentalInvolveRes] int,
		[TitleiPartaAllocations] int,
		McKinneyVentoSubgrantRecipient varchar(50),
		REAPAlternativeFundingStatusCode varchar(50),
		GunFreeStatusCode varchar(50),
		FederalFundAllocationType varchar(20),
		FederalProgramCode varchar(20),
		FederalFundAllocated int
		)

	insert into #leaQueryOutput
	(
		DimCountDateId ,
		DimLeaId ,

		CharterLeaStatusCode,
		CharterSchoolStatusCode,
		ReconstitutedStatusCode,
		OperationalStatusCode,
		UpdatedOperationalStatusCode,
		OrgCount,
		[TitleiParentalInvolveRes],
		[TitleiPartaAllocations],
		McKinneyVentoSubgrantRecipient,
		REAPAlternativeFundingStatusCode,
		GunFreeStatusCode,
		FederalFundAllocationType,
		FederalProgramCode,
		FederalFundAllocated
	)

	select s.DimCountDateId,
		   s.DimLeaId,
		ISNULL(dirStatus.CharterLeaStatusCode ,'MISSING'),
		ISNULL(dirStatus.CharterSchoolStatusCode ,'MISSING'),
		ISNULL(dirStatus.ReconstitutedStatusCode ,'MISSING'),
		ISNULL(dirStatus.OperationalStatusCode ,'MISSING'),
		ISNULL(dirStatus.UpdatedOperationalStatusCode ,'MISSING'),
		1	,
		round(ParentalInvolvementReservationFunds,0),
		case when FederalProgramCode ='84.010' Then round(FederalProgramsFundingAllocation,0)
				else 0 end as 'TitleiPartaAllocations' ,
		dirStatus.McKinneyVentoSubgrantRecipient,
		ISNULL(dimOrganizationStatus.REAPAlternativeFundingStatusCode,'MISSING'),
		ISNULL(dimOrganizationStatus.GunFreeStatusCode,'MISSING'),
		ISNULL(fund.FederalFundAllocationType,'MISSING'),
		ISNULL(fund.FederalProgramCode, 'MISSING'),
		ISNULL(FederalProgramsFundingAllocation,0)
	 From @LeaDirectoryDateQuery s
	left outer join @leaDirectoryStatusQuery dirStatus on s.DimLeaId = dirStatus.DimLeaId and s.DimCountDateId = dirStatus.DimCountDateId --and s.DimLeaId = @dimDirectoryId
	left outer join @leaFederalFundQuery fund on s.DimLeaId = fund.DimLeaId and s.DimCountDateId = fund.DimCountDateId 
	left outer join @leaOrganizationStatusQuery dimOrganizationStatus on s.DimLeaId = dimOrganizationStatus.DimLeaId and s.DimCountDateId = dimOrganizationStatus.DimCountDateId 
				
			-- insert into FactOrganization 
						
							INSERT INTO [RDS].[FactOrganizationCounts]
							   ([DimCountDateId]
							   ,[DimDirectoryId]
							   ,[DimDirectoryStatusId]
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
							   ,[DimCharterSchoolPrimaryApproverAgencyDirectoryId]
							   ,[DimCharterSchoolSecondaryApproverAgencyDirectoryId]
							   ,[DimCharterSchooleManagerDirectoryId]
							   ,[DimCharterSchoolUpdatedManagerDirectoryId]
							   ,[DimSchoolStateStatusId]
							,[FederalFundAllocationType]
							,[FederalProgramCode]
							,[FederalFundAllocated]
							   )

							   SELECT 
								q.DimCountDateId,
							    @dimDirectoryId,
								ISNULL(dirStatus.DimDirectoryStatusId,-1) as 'DimDirectoryStatusId',
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
							   -1 as 'DimCharterSchoolPrimaryApproverAgencyDirectoryId',
							   -1 as'DimCharterSchoolSecondaryApproverAgencyDirectoryId',		
							   -1 as'DimCharterSchooleManagerDirectoryId',
							   -1 as'DimCharterSchoolUpdatedManagerDirectoryId',
							   -1 as 'DimSchoolStateStatusId',
				ISNULL(q.FederalFundAllocationType, 'MISSING') as 'FederalFundAllocationType',
				ISNULL(q.FederalProgramCode, 'MISSING') as 'FederalPrgoramCode',
				isnull(q.FederalFundAllocated,0)
							   from #leaQueryOutput q
								left outer join rds.DimDirectoryStatuses dirStatus 
								on dirStatus.CharterLeaStatusCode = q.CharterLeaStatusCode
								and dirStatus.CharterSchoolStatusCode = q.CharterSchoolStatusCode
								and dirStatus.ReconstitutedStatusCode = q.ReconstitutedStatusCode
								and dirStatus.OperationalStatusCode = q.OperationalStatusCode
								and dirStatus.UpdatedOperationalStatusCode = q.UpdatedOperationalStatusCode
								and dirStatus.McKinneyVentoSubgrantRecipientCode = q.McKinneyVentoSubgrantRecipient
								left outer join rds.DimOrganizationStatus dimOrganizationStatus on dimOrganizationStatus.REAPAlternativeFundingStatusCode = q.REAPAlternativeFundingStatusCode
																						  and dimOrganizationStatus.GunFreeStatusCode = q.GunFreeStatusCode 
			DELETE FROM @LeaDirectoryDateQuery
			DELETE FROM @leaDirectoryStatusQuery
			DELETE FROM @leaOrganizationStatusQuery
			drop table #leaQueryOutput

				FETCH NEXT FROM LEA_Cursor INTO @leaName, @LeaNcesIdentifier, @leaOrganizationId, @LeaStateIdentifier,@SupervisoryIdNum,
											
											@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
											@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
											@OutOfStateIndicator ,
											@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
											@SchoolTypeCode, @SchoolTypeDescription, @SchoolTypeEdFactsCode, @SchoolTypeId,
											@Telephone, @Website, @effectiveDate, @PriorLeaStateIdentifier, @ReportedFederally 	


		END
		close LEA_Cursor
		DEALLOCATE LEA_Cursor
	
	END
	ELSE
	BEGIN
		UPDATE L 
		SET  [ReportedFederally] = 0
		FROM [RDS].[DimLeas] l
		inner join ods.OrganizationDetail o on o.organizationId = l.[LeaOrganizationId]
		inner join ods.RefOrganizationType t on t.RefOrganizationTypeId = o.RefOrganizationTypeId
		-- CIID-1963
		WHERE t.Code = 'LEANotFederal' 
	END

	declare @schoolIdentifierTypeId as int
	declare @schoolSEAIdentificationSystemId as int
	declare @schoolNCESIdentificationSystemId as int
	declare @schoolOrgTypeId as int
	declare @schoolOrganizationId as int
	declare @schoolId as varchar(500)
	
	declare @charterSchoolManagerIdentifierTypeId as int
	declare @charterSchoolManagerIdentificationSystemId as int
	declare @charterSchoolManagerOrganizationIdentifierTypeId as int
	declare @charterSchoolManagerOrganizationIdentificationSystemId as int
	declare @charterAuthorizerIdentificationSystemId as int

	--DimSchool Seed
	IF not exists (SELECT 1 FROM RDS.DimSchools where DimSchoolId <> -1)
	BEGIN
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

	--declare @schoolOrganizationId as int
	declare @schoolName as varchar(500)
	declare @IsCharterSchool as int

	DECLARE school_cursor CURSOR FOR 
	select distinct O.OrganizationId, Name, K12.CharterSchoolIndicator 
	,CASE WHEN t.Code = 'K12SchoolNotFederal' THEN 0 ELSE 1 END AS ReportedFederally -- CIID-1963
	from ods.OrganizationDetail o
	INNER JOIN ODS.K12School K12 ON K12.OrganizationId=O.OrganizationId
	INNER JOIN ODS.RefOrganizationType t ON t.RefOrganizationTypeId = o.RefOrganizationTypeId
	where 
	--o.RefOrganizationTypeId = @schoolOrgTypeId
	--AND 
	(t.Code = 'K12School' OR t.Code = 'K12SchoolNotFederal')
	AND o.RecordEndDateTime IS NULL
		
	OPEN school_cursor
	FETCH NEXT FROM school_cursor INTO @schoolOrganizationId, @schoolName, @IsCharterSchool, @ReportedFederally
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--LEA
		declare @count as int
		declare @dimCharterSchoolManagerId as int
		declare @dimCharterSchoolSecondaryManagerId as int
		declare @dimCharterSchoolAuthorizerId as int
		declare @dimCharterSchoolSecondaryAuthorizerId as int
		declare @dimCharterSchoolManagerDirectoryId as int
		declare @dimCharterSchoolSecondaryManagerDirectoryId as int		
		declare @dimCharterSchoolPrimaryAuthorizerDirectoryId as int
		declare @dimCharterSchoolSecondaryAuthorizerDirectoryId as int

		set @dimCharterSchoolManagerId=-1
		set @dimCharterSchoolSecondaryManagerId=-1
		set @dimCharterSchoolAuthorizerId=-1
		set @dimCharterSchoolSecondaryAuthorizerId=-1
		set @dimCharterSchoolManagerDirectoryId=-1
		set @dimCharterSchoolSecondaryManagerDirectoryId=-1
		set @dimCharterSchoolPrimaryAuthorizerDirectoryId=-1
		set @dimCharterSchoolManagerDirectoryId=-1
		set @dimCharterSchoolSecondaryAuthorizerDirectoryId=-1
		set @count=0

		set @leaOrganizationId = null
		select @leaOrganizationId = r.Parent_OrganizationId
		from ods.OrganizationRelationship r
		inner join ods.OrganizationDetail o on o.OrganizationId = r.Parent_OrganizationId
		where r.OrganizationId = @schoolOrganizationId and RefOrganizationTypeId = @leaOrgTypeId

		declare @leaOrganizationName as varchar(500)
		set @leaOrganizationName = ''
		select @leaOrganizationName = o.Name
		from ods.OrganizationRelationship r
		inner join ods.OrganizationDetail o on o.OrganizationId = r.Parent_OrganizationId
		where r.OrganizationId = @schoolOrganizationId and RefOrganizationTypeId = @leaOrgTypeId

		set @leaNcesIdentifier = ''
		select @leaNcesIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @leaNCESIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		and OrganizationId = @leaOrganizationId

		set @leaStateIdentifier = ''
		select @leaStateIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		and OrganizationId = @leaOrganizationId

		set @PriorLeaStateIdentifier = ''
		select @PriorLeaStateIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @leaSEAIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @leaIdentifierTypeId
		and OrganizationId = @leaOrganizationId and RecordEndDateTime IS NOT NULL

		-- School
		declare @dimSchoolId int = null
		declare @schoolNcesIdentifier as varchar(50)
		set @schoolNcesIdentifier = ''

		select @schoolNcesIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @schoolNCESIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		and OrganizationId = @schoolOrganizationId

		declare @schoolStateIdentifier as varchar(50)
		set @schoolStateIdentifier = ''

		select @schoolStateIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		and OrganizationId = @schoolOrganizationId

		declare @priorSchoolStateIdentifier as varchar(50)
		set @priorSchoolStateIdentifier = ''

		select @priorSchoolStateIdentifier = Identifier
		from ods.OrganizationIdentifier
		where RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId
		and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId
		and OrganizationId = @schoolOrganizationId and RecordEndDateTime IS NOT NULL

		select @effectiveDate = op.OperationalStatusEffectiveDate
		from ods.OrganizationOperationalStatus op
		inner join ods.OrganizationDetail o on o.OrganizationId = op.OrganizationId
		where op.OrganizationId = @schoolOrganizationId

		declare @charterSchoolIdentifier as varchar(50)
		declare @charterSchoolContractApprovalDate as varchar(50)
		declare @charterSchoolContractRenewalDate as varchar(50)
		declare @charterSchoolContractIdNumber as varchar(50)
		set @charterSchoolContractApprovalDate = ''
		set @charterSchoolContractRenewalDate = ''
		set @charterSchoolIdentifier = ''
		set @charterSchoolContractIdNumber=''								
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		if(@IsCharterSchool=1)
		begin
			DECLARE CharterSchoolManager_Cursor CURSOR FOR 
			SELECT DISTINCT					
				o1.Name, 
				o1.OrganizationId, 
				i.Identifier AS LeaSateIdentifiers,   
				charterSchoolApprovalAgencyType.[Code] as LeaTypeCode,
				charterSchoolApprovalAgencyType.[Description] as LeaTypeDescription,
				charterSchoolApprovalAgencyType.[Code], -- EdFact
				charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId,
				Case when mailingAddress.StreetNumberAndName is null and mailingAddress.City is not null and mailingAddress.StateCode is not null and mailingAddress.PostalCode is not null 
					then 'No Street Address' else  mailingAddress.StreetNumberAndName  end, 
				mailingAddress.City, 
				mailingAddress.StateCode, 
				mailingAddress.PostalCode, 
				case when  (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
						or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StreetNumberAndName
					end					 
					end as StreetNumberAndName,
		
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('Po Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.City
					end	
					end as City,
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StateCode
					end	
					end as StateCode,
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0 ) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.PostalCode
					end	
					end as PostalCode,
				phone.TelephoneNumber,
				website.Website,
				charterSchoolApprovalAgencyType.[Code]			
			from  ods.OrganizationDetail o 									
			inner join ods.K12School c on c.OrganizationId=o.OrganizationId
			inner join ods.OrganizationRelationship a on a.OrganizationId=c.OrganizationId
			inner join ods.K12CharterSchoolManagementOrganization d on d.OrganizationId=a.Parent_OrganizationId	
			inner join ODS.RefCharterSchoolManagementOrganizationType charterSchoolApprovalAgencyType on charterSchoolApprovalAgencyType.RefCharterSchoolManagementOrganizationTypeId = d.RefCharterSchoolManagementOrganizationTypeId	
			inner join ods.OrganizationDetail o1 on o1.OrganizationId= d.OrganizationId	
			inner join ods.OrganizationIdentifier i on o1.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
									and aaa.RefOrganizationIdentificationSystemId=@charterSchoolManagerIdentificationSystemId
			inner join ods.RefOrganizationType t on o1.RefOrganizationTypeId = t.RefOrganizationTypeId															
			left join ods.OrganizationWebsite website on o1.OrganizationId = website.OrganizationId
			left join ods.OrganizationTelephone phone on o1.OrganizationId = phone.OrganizationId
			left join  
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la on ol.LocationId = la.LocationId
					inner join ods.RefState refState on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 1 -- mailing
					) mailingAddress on mailingAddress.OrganizationId = d.OrganizationId
			left join (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la on ol.LocationId = la.LocationId
					inner join ods.RefState refState on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 2 -- Physical
					) physicalAddress on physicalAddress.OrganizationId = d.OrganizationId
			where o1.RefOrganizationTypeId = @charterSchoolMgrTypeId and o.OrganizationId = @schoolOrganizationId
					
			set @count=0
			set @dimCharterSchoolManagerId=-1
			set @dimCharterSchoolSecondaryManagerId=-1
			set @dimCharterSchoolSecondaryManagerDirectoryId=-1
			set @dimCharterSchoolManagerDirectoryId=-1
		
			open CharterSchoolManager_Cursor
			FETCH NEXT FROM CharterSchoolManager_Cursor INTO @leaName, @leaOrganizationIds, @LeaStateIdentifiers,
											@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
											@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
											@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
											@Telephone, @Website, @charterManagerType					
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [RDS].[DimCharterSchoolApproverAgency]
					([Name],[OrganizationId],[StateIdentifier],[StateCode],[StateANSICode] ,[State] ,[OrganizationType],
					[IsApproverAgency]	,[SeaOrganizationId])
				values (@leaName, @leaOrganizationIds, @LeaStateIdentifiers, @stateCode, @seaIdentifier, @stateName, @charterManagerType,
					'No', @seaOrganizationId)

				if (@count=0) 
				BEGIN
					SET @dimCharterSchoolManagerId = SCOPE_IDENTITY()
				END
				ELSE 
				BEGIN
					SET @dimCharterSchoolSecondaryManagerId=SCOPE_IDENTITY()
				END

		   		INSERT INTO [RDS].[DimDirectories]( 
					[LeaTypeCode],[LeaTypeDescription] ,[LeaTypeEdFactsCode] ,[LeaTypeId] ,[MailingAddressStreet],
					[MailingAddressCity] ,[MailingAddressState],[MailingAddressPostalCode]
					,[OutOfStateIndicator] ,[PhysicalAddressStreet],[PhysicalAddressCity] ,[PhysicalAddressState],
					[PhysicalAddressPostalCode],[Telephone],[Website])
				values 
					(
					@LeaTypeCode,
					@LeaTypeDescription,
					@LeaTypeEdFactsCode,
					@LeaTypeId,

					@MailingAddressStreet,
					@MailingAddressCity,
					@MailingAddressState,
					@MailingAddressPostalCode,	
					1,
					@PhysicalAddressStreet,	
					@PhysicalAddressCity,
					@PhysicalAddressState,	
					@PhysicalAddressPostalCode,
														
					@Telephone  ,
					@Website  
					)
							
				if (@count=0)
					BEGIN
						SET @dimCharterSchoolManagerDirectoryId = SCOPE_IDENTITY()
					END
					ELSE 
					BEGIN
						SET @dimCharterSchoolSecondaryManagerDirectoryId=SCOPE_IDENTITY()
					END

				set @count= 1
			FETCH NEXT FROM CharterSchoolManager_Cursor INTO @leaName, @leaOrganizationIds, @LeaStateIdentifiers,
										@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
										@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,

										@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,											
										@Telephone, @Website, @charterManagerType
			END
			close CharterSchoolManager_Cursor
			DEALLOCATE CharterSchoolManager_Cursor

			declare CharterSchoolApprover_Cursor cursor for 
			SELECT DISTINCT					
				o1.Name, 
				o1.OrganizationId, 
				i.Identifier,   
				charterSchoolApprovalAgencyType.Code as LeaTypeCode,
				charterSchoolApprovalAgencyType.Description as LeaTypeDescription,
				charterSchoolApprovalAgencyType.Code, -- EdFact
				charterSchoolApprovalAgencyType.RefCharterSchoolApprovalAgencyTypeId,
				Case when mailingAddress.StreetNumberAndName is null and mailingAddress.City is not null and mailingAddress.StateCode is not null and mailingAddress.PostalCode is not null 
					then 'No Street Address' else  mailingAddress.StreetNumberAndName  end, 
				mailingAddress.City, 
				mailingAddress.StateCode, 
				mailingAddress.PostalCode, 
				case when  (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StreetNumberAndName
					end					 
					end as StreetNumberAndName,
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('Po Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
					CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.City
					end	
					end as City,
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null  then null else 
					CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.StateCode
					end	
					 end as StateCode,
				case when (physicalAddress.StreetNumberAndName = mailingAddress.StreetNumberAndName and CHARINDEX('PO Box',mailingAddress.StreetNumberAndName)=0 ) or physicalAddress.City is null 
					or physicalAddress.StateCode is null or physicalAddress.PostalCode is null then null else 
				CASE WHEN CHARINDEX('PO Box',physicalAddress.StreetNumberAndName)>0 then null else physicalAddress.PostalCode
					end	
					end as PostalCode,			
				phone.TelephoneNumber,
				website.Website,
				charterSchoolApprovalAgencyType.[Code]			
			from  ods.OrganizationDetail o 								
			inner join ods.K12School c on c.OrganizationId=o.OrganizationId
			inner join ods.OrganizationRelationship a on a.OrganizationId=c.OrganizationId
			inner join ods.K12CharterSchoolApprovalAgency d on d.OrganizationId=a.Parent_OrganizationId	
			inner join ODS.RefCharterSchoolApprovalAgencyType charterSchoolApprovalAgencyType on charterSchoolApprovalAgencyType.RefCharterSchoolApprovalAgencyTypeId = d.RefCharterSchoolApprovalAgencyTypeId	
			inner join ods.OrganizationDetail o1 on o1.OrganizationId= d.OrganizationId	
			inner join ods.OrganizationIdentifier i on o1.OrganizationId = i.OrganizationId
			inner join ods.RefOrganizationIdentificationSystem aaa on aaa.RefOrganizationIdentificationSystemId=i.RefOrganizationIdentificationSystemId
									and aaa.RefOrganizationIdentificationSystemId=@charterAuthorizerIdentificationSystemId
			inner join ods.RefOrganizationType t on o1.RefOrganizationTypeId = t.RefOrganizationTypeId
																				
			left join ods.OrganizationWebsite website on o1.OrganizationId = website.OrganizationId
			left join ods.OrganizationTelephone phone on o1.OrganizationId = phone.OrganizationId
			left join  
						(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode from ODS.OrganizationLocation ol
							inner join ods.LocationAddress la on ol.LocationId = la.LocationId
							inner join ods.RefState refState on refState.RefStateId = la.RefStateId
							where RefOrganizationLocationTypeId = 1 -- mailing
							) mailingAddress on mailingAddress.OrganizationId = d.OrganizationId
			left join (select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  from ODS.OrganizationLocation ol
							inner join ods.LocationAddress la on ol.LocationId = la.LocationId
							inner join ods.RefState refState on refState.RefStateId = la.RefStateId
							where RefOrganizationLocationTypeId = 2 -- Physical
							) physicalAddress on physicalAddress.OrganizationId = d.OrganizationId
			where o1.RefOrganizationTypeId = @charterSchoolAuthTypeId and o.OrganizationId =@schoolOrganizationId
		
			set @count=0
			set @dimCharterSchoolAuthorizerId=-1
			set @dimCharterSchoolSecondaryAuthorizerId=-1
			set @dimCharterSchoolPrimaryAuthorizerDirectoryId=-1
			set @dimCharterSchoolSecondaryAuthorizerDirectoryId=-1
			open CharterSchoolApprover_Cursor
			FETCH NEXT FROM CharterSchoolApprover_Cursor INTO @leaName,  @leaOrganizationIds,  @LeaStateIdentifiers,
											@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
											@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
											@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
											@Telephone, @Website, @charterAuthorizerType					
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [RDS].[DimCharterSchoolApproverAgency]
				   ([Name]
				   ,[OrganizationId]
				   ,[StateIdentifier]
				   ,[StateCode]
				   ,[StateANSICode]
				   ,[State]  
				   ,[OrganizationType]
				   ,[IsApproverAgency]
				   ,[SeaOrganizationId]
				   ) 
		   
				values (
					@leaName, 
					@leaOrganizationIds, 
					@LeaStateIdentifiers,			
					@stateCode,
					@seaIdentifier, 
					@stateName,
					@charterAuthorizerType,	 
					'Yes',
					@seaOrganizationId)

		 		IF (@count=0)
				BEGIN
					SET @dimCharterSchoolAuthorizerId = SCOPE_IDENTITY()
				END
				ELSE 
				BEGIN
					SET @dimCharterSchoolSecondaryAuthorizerId=SCOPE_IDENTITY()
				END
		   		INSERT INTO [RDS].[DimDirectories]
					(
					[LeaTypeCode]
					,[LeaTypeDescription]
					,[LeaTypeEdFactsCode]
					,[LeaTypeId]
					,[MailingAddressStreet]
					,[MailingAddressCity]
					,[MailingAddressState]
					,[MailingAddressPostalCode]
					,[OutOfStateIndicator]
					,[PhysicalAddressStreet]
					,[PhysicalAddressCity]
					,[PhysicalAddressState]
					,[PhysicalAddressPostalCode]
					,[Telephone]
					,[Website])
				values 
					(
					@LeaTypeCode,
					@LeaTypeDescription,
					@LeaTypeEdFactsCode,
					@LeaTypeId,
					@MailingAddressStreet,
					@MailingAddressCity,
					@MailingAddressState,
					@MailingAddressPostalCode,				
					1,
					@PhysicalAddressStreet,	
					@PhysicalAddressCity,
					@PhysicalAddressState,	
					@PhysicalAddressPostalCode,													
					@Telephone  ,
					@Website)
													
				IF (@count=0)
				BEGIN
					SET @dimCharterSchoolPrimaryAuthorizerDirectoryId = SCOPE_IDENTITY()
				END
				ELSE 
				BEGIN
					SET @dimCharterSchoolSecondaryAuthorizerDirectoryId=SCOPE_IDENTITY()
				END									
				SET @count= 1
			FETCH NEXT FROM CharterSchoolApprover_Cursor INTO  @leaName, @leaOrganizationIds,  @LeaStateIdentifiers,
											@LeaTypeCode, @LeaTypeDescription, @LeaTypeEdFactsCode, @LeaTypeId,
											@MailingAddressStreet, @MailingAddressCity, @MailingAddressState, @MailingAddressPostalCode,
											@PhysicalAddressStreet, @PhysicalAddressCity, @PhysicalAddressState, @PhysicalAddressPostalCode,
											@Telephone, @Website, @charterAuthorizerType	
			END
			close CharterSchoolApprover_Cursor
			DEALLOCATE CharterSchoolApprover_Cursor
		end			-- if(@IsCharterSchool=1)
		---------------------------------------------
		
		select @charterSchoolIdentifier=a.CharterSchoolIndicator,  @charterSchoolContractApprovalDate=a.CharterSchoolContractApprovalDate,  
			@charterSchoolContractRenewalDate= a.CharterSchoolContractRenewalDate,  @charterSchoolContractIdNumber=a.CharterSchoolContractIdNumber 					
		from ods.K12School a
		where a.OrganizationId = @schoolOrganizationId

		insert into rds.DimSchools
			(
			StateCode,
			StateName,
			StateANSICode,
				
			SeaOrganizationId,
			SeaName,
			SeaStateIdentifier,

			LeaOrganizationId,
			LeaNcesIdentifier,
			LeaStateIdentifier,
			LeaName,

			SchoolOrganizationId,
			SchoolNcesIdentifier,
			SchoolStateIdentifier,
			SchoolName,
			EffectiveDate,
			PriorLeaStateIdentifier,
			PriorSchoolStateIdentifier,
			CharterSchoolIndicator,
			CharterContractApprovalDate,
			CharterContractRenewalDate,
			CharterSchoolContractIdNumber,

			ReportedFederally
			)
		values
		(
			@stateCode,
			@stateName,
			@seaIdentifier,

			@seaOrganizationId,
			@seaName,
			@seaIdentifier,

			@leaOrganizationId,
			@leaNcesIdentifier,
			@leaStateIdentifier,
			@leaOrganizationName,

			@schoolOrganizationId,
			@schoolNcesIdentifier,
			@schoolStateIdentifier,
			@schoolName,
			@effectiveDate,
			@PriorLeaStateIdentifier,
			@priorSchoolStateIdentifier,
			@charterSchoolIdentifier,
			@charterSchoolContractApprovalDate,	
			@charterSchoolContractRenewalDate,						
			@charterSchoolContractIdNumber,

			@ReportedFederally
		)
		set @dimSchoolId = SCOPE_IDENTITY()

		--insert into DimDirectory
		INSERT INTO [RDS].[DimDirectories]
			(
			[LeaTypeCode]
			,[LeaTypeDescription]
			,[LeaTypeEdFactsCode]
			,[LeaTypeId]

			,[MailingAddressStreet]
			,[MailingAddressCity]
			,[MailingAddressState]
			,[MailingAddressPostalCode]
			,[OutOfStateIndicator]

			,[PhysicalAddressStreet]
			,[PhysicalAddressCity]
			,[PhysicalAddressState]
			,[PhysicalAddressPostalCode]
			,[SchoolTypeCode]
			,[SchoolTypeDescription]
			,[SchoolTypeEdFactsCode]
			,[SchoolTypeId]
			,[Telephone]
			,[Website])		
		select distinct	leaType.Code as LeaTypeCode,
						leaType.Description as LeaTypeDescription,
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
						END, -- EdFact
						leaType.RefLeaTypeId,
	
						mailingAddress.StreetNumberAndName, 
						mailingAddress.City, 
						mailingAddress.StateCode, 
						mailingAddress.PostalCode, 
						case when physicalAddress.StateCode <> @stateCode or mailingAddress.StateCode <> @stateCode then '1'
						else 0 end as OutOfState,
						physicalAddress.StreetNumberAndName,
						physicalAddress.City,
						physicalAddress.StateCode,
						physicalAddress.PostalCode,
						
						schoolType.Code as schoolTypeCode,
						schoolType.Description as SchoolTypeDescription,
						CASE schoolType.Code 
								WHEN 'Regular' then 1
								WHEN 'Special' then 2
								WHEN 'CareerAndTechnical' then 3
								WHEN 'Alternative' then 4
								WHEN 'Reportable' then 5
						END,
						schoolType.RefSchoolTypeId as SchoolTypeId,

						phone.TelephoneNumber,
						website.Website
		from ods.OrganizationDetail o 								
		left join ods.OrganizationWebsite website on o.OrganizationId = website.OrganizationId
		left join ods.OrganizationTelephone phone on o.OrganizationId = phone.OrganizationId
		left join  
				(select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode,  PostalCode from ODS.OrganizationLocation ol
					inner join ods.LocationAddress la on ol.LocationId = la.LocationId
					inner join ods.RefState refState on refState.RefStateId = la.RefStateId
					where RefOrganizationLocationTypeId = 1 -- mailing
					) mailingAddress on mailingAddress.OrganizationId = o.OrganizationId
		left join (
				select ol.OrganizationId, ol.LocationId, RefOrganizationLocationTypeId, StreetNumberAndName, City, refState.Code as StateCode, PostalCode  from ODS.OrganizationLocation ol
				inner join ods.LocationAddress la on ol.LocationId = la.LocationId
				inner join ods.RefState refState on refState.RefStateId = la.RefStateId
				where RefOrganizationLocationTypeId = 2 -- Physical
				) physicalAddress on physicalAddress.OrganizationId = o.OrganizationId
			left join ods.K12Lea lea on lea.OrganizationId = o.OrganizationId
			left join ods.RefLeaType leaType on lea.RefLeaTypeId = leaType.RefLeaTypeId
			left join ods.K12School school on school.OrganizationId = o.OrganizationId
			left join ods.RefSchoolType schoolType on schoolType.RefSchoolTypeId = school.RefSchoolTypeId
		where o.OrganizationId = @schoolOrganizationId
			
		set @dimDirectoryId = SCOPE_IDENTITY()

		-- insert into Bridgetable 
		INSERT INTO [RDS].[BridgeDirectoryDate]
					([DimDirectoryId]
					,[DimDateId])
		SELECT @dimDirectoryId, d.DimDateId
		from rds.DimDates d
		inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
		inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode='rds'
		
		-- insert into BridgeDirectoryGradeLevels
		INSERT INTO [RDS].[BridgeDirectoryGradeLevels]
           ([DimDirectoryId]
           ,[DimGradeLevelId])
		SELECT distinct @dimDirectoryId, grades.DimGradeLevelId 
		FROM ods.OrganizationDetail o
		inner join ods.K12School sch on o.OrganizationId = sch.OrganizationId
		inner join ods.K12SchoolGradeOffered g on g.K12SchoolId = sch.K12SchoolId
		inner join ods.RefGradeLevel l on l.RefGradeLevelId = g.RefGradeLevelId
										and RefGradeLevelTypeId = (select top 1 RefGradeLevelTypeId from ods.RefGradeLevelType where code = '000131')
		inner join RDS.DimGradeLevels grades on grades.GradeLevelCode = l.Code
    	WHERE o.OrganizationId = @schoolOrganizationId

		-- insert into @DirectoryDateQuery
		declare @DirectoryDateQuery as rds.SchoolDateTableType
		insert into @DirectoryDateQuery
		(
			DimSchoolId,
			DimCountDateId,
			SubmissionYearDate,
			[year],
			SubmissionYearStartDate,
			SubmissionYearEndDate
		)
		exec rds.Migrate_DimDates_Directories @dimDirectoryId, @dimSchoolId, @migrationType

		--Migrate_DimDirectoryStatuses_School
		declare @directoryStatusQuery as table(
				DimCountDateId int,
				DimSchoolId int,
				CharterLeaStatusCode varchar(50),
				CharterSchoolStatusCode varchar(50),
				OperationalStatusCode varchar(50),
				ReconstitutedStatusCode varchar(50),
				UpdatedOperationalStatusCode varchar(50)
			)
		insert into @directoryStatusQuery
		(
			DimSchoolId ,
			DimCountDateId ,
			CharterLeaStatusCode,
			CharterSchoolStatusCode,
			ReconstitutedStatusCode,
			OperationalStatusCode,
			UpdatedOperationalStatusCode
		)
		exec [RDS].[Migrate_DimDirectoryStatuses_School] @DirectoryDateQuery

		-- Migrate_DimOrganizationStatuses_School
		declare @organizationStatusSchoolQuery as table(
				DimCountDateId int,
				DimSchoolId int,
				GunFreeStatusCode varchar(50),
				GraduationRateCode varchar(50)
			)
		insert into @organizationStatusSchoolQuery
		(
			DimSchoolId ,
			DimCountDateId ,
			GunFreeStatusCode,
			GraduationRateCode
		)
		exec [RDS].[Migrate_DimOrganizationStatuses_School] @DirectoryDateQuery

		declare @SchoolDateQuery as rds.SchoolDateTableType
		insert into @SchoolDateQuery
		(
			DimSchoolId,
			SchoolOrganizationId,
			DimCountDateId
		)
		select @dimSchoolId, @schoolOrganizationId, b.DimDateId
		from rds.BridgeDirectoryDate  b
		where DimDirectoryId = @dimDirectoryId

		--Migrate_DimSchoolStatuses_School
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

		-- Migrate_DimTitle1Statuses
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
		exec [RDS].[Migrate_DimComprehensiveAndTargetedSupport_School] @DirectoryDateQuery
		/*
			[RDS].[Migrate_OrganizationCounts] @factTypeCode='directory', @runAsTest=0
		*/
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
		SELECT distinct 	DimCountDateId, schDate.DimSchoolId, schFund.SchoolImprovementAllocation
		FROM ODS.OrganizationDetail o
		inner join ods.OrganizationCalendar oc on o.OrganizationId = oc.OrganizationId and o.organizationid =@schoolOrganizationId
		inner join ods.OrganizationCalendarSession s on s.OrganizationCalendarId = oc.OrganizationCalendarId
		inner join ods.K12FederalFundAllocation schFund on schFund.[OrganizationCalendarSessionId] = s.OrganizationCalendarSessionId
		inner join ods.K12School sch on sch.OrganizationId = o.OrganizationId
		inner join ods.K12SchoolImprovement schImprv on sch.K12SchoolId = schImprv.K12SchoolId
		inner join ods.RefSchoolImprovementFunds refSis on schImprv.RefSchoolImprovementFundsId = refSis.RefSchoolImprovementFundsId and refSis.Code = 'YES'
		inner join	(select l.*, @schoolOrganizationId as organizationId from  @DirectoryDateQuery l) as schDate 
				on schDate.organizationId = o.OrganizationId 
				and (s.BeginDate between schDate.SubmissionYearStartDate and schDate.SubmissionYearEndDate)
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

			CharterLeaStatusCode varchar(50),
			CharterSchoolStatusCode varchar(50),
			OperationalStatusCode varchar(50),
			ReconstitutedStatusCode varchar(50),
			UpdatedOperationalStatusCode varchar(50),
			REAPAlternativeFundingStatusCode varchar(50),
			GunFreeStatusCode varchar(50),
			GraduationRateCode varchar(50),
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

			CharterLeaStatusCode,
			CharterSchoolStatusCode,
			ReconstitutedStatusCode,
			OperationalStatusCode,
			UpdatedOperationalStatusCode,
			GunFreeStatusCode,
			GraduationRateCode,
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

			ISNULL(dirStatus.CharterLeaStatusCode ,'MISSING'),
			ISNULL(dirStatus.CharterSchoolStatusCode ,'MISSING'),
			ISNULL(dirStatus.ReconstitutedStatusCode ,'MISSING'),
			ISNULL(dirStatus.OperationalStatusCode ,'MISSING'),
			ISNULL(dirStatus.UpdatedOperationalStatusCode ,'MISSING'),
			ISNULL(organizationStatus.GunFreeStatusCode ,'MISSING'),
			ISNULL(organizationStatus.GraduationRateCode ,'MISSING'),
			1		,
			round(SchImprovementFund,0),
			ISNULL(cts.ComprehensiveAndTargetedSupportCode ,'MISSING'),
			ISNULL(cts.ComprehensiveSupportCode ,'MISSING'),
			ISNULL(cts.TargetedSupportCode ,'MISSING')
		From @SchoolDateQuery s
		left outer join @schoolStatusQuery schStatus on s.DimSchoolId = schStatus.DimSchoolId and s.DimCountDateId = schStatus.DimCountDateId
		left outer join @title1StatusQuery t on s.DimSchoolId = t.DimSchoolId and s.DimCountDateId = t.DimCountDateId
		left outer join @directoryStatusQuery dirStatus on s.DimSchoolId = dirStatus.DimSchoolId and s.DimCountDateId = dirStatus.DimCountDateId
		left outer join @SchImprovementFundQuery schImprFund on s.DimSchoolId = schImprFund.DimSchoolId and s.DimCountDateId = schImprFund.DimCountDateId
		left outer join @organizationStatusSchoolQuery organizationStatus on s.DimSchoolId = organizationStatus.DimSchoolId and s.DimCountDateId = organizationStatus.DimCountDateId
		left join @ComprehensiveAndTargetedSupport cts on s.DimSchoolId=cts.DimSchoolId and s.DimCountDateId=cts.DimCountDateId
		--select * from @ComprehensiveAndTargetedSupport
		--select * from #queryOutput
		/*
			[RDS].[Migrate_OrganizationCounts] @factTypeCode='directory', @runAsTest=0
		*/
		----insert into FactOrganizationCounts
		INSERT INTO [RDS].[FactOrganizationCounts]
			([DimCountDateId]
			,[DimDirectoryId]
			,[DimDirectoryStatusId]
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
			,[DimCharterSchoolPrimaryApproverAgencyDirectoryId]
			,[DimCharterSchoolSecondaryApproverAgencyDirectoryId]
			,[DimCharterSchooleManagerDirectoryId]
			,[DimCharterSchoolUpdatedManagerDirectoryId]
			,[SCHOOLIMPROVEMENTFUNDS]
			,DimComprehensiveAndTargetedSupportId
			,FederalFundAllocated
			)
		Select distinct q.DimCountDateId,
				@dimDirectoryId,
				ISNULL(dirStatus.DimDirectoryStatusId,-1) as 'DimDirectoryStatusId',
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
				@dimCharterSchoolAuthorizerId as 'DimCharterSchoolApproverAgencyId',
				@dimCharterSchoolManagerId as'DimCharterSchoolManagerOrganizationId',		
				@dimCharterSchoolSecondaryAuthorizerId as'DimCharterSchoolSecondaryApproverAgencyId',
				@dimCharterSchoolSecondaryManagerId as'DimCharterSchoolUpdatedManagerOrganizationId',
				@dimCharterSchoolPrimaryAuthorizerDirectoryId as 'DimCharterSchoolPrimaryApproverAgencyDirectoryId',
				@dimCharterSchoolSecondaryAuthorizerDirectoryId as'DimCharterSchoolSecondaryApproverAgencyDirectoryId',		
				@dimCharterSchoolManagerDirectoryId as'DimCharterSchooleManagerDirectoryId',
				@dimCharterSchoolSecondaryManagerDirectoryId as'DimCharterSchoolUpdatedManagerDirectoryId',
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
		Left outer join rds.DimSchoolStateStatus dss on dss.SchoolStateStatusCode=q.SchoolStateStatusCode
		left outer join rds.DimTitle1Statuses t 
		on t.Title1InstructionalServicesCode = q.TitleIinstructionalServiceCode
			and t.Title1ProgramTypeCode = q.Title1ProgramTypeCode
			and t.Title1SchoolStatusCode = q.TitleISchoolStatusCode
			and t.Title1SupportServicesCode = q.Title1SupportServiceCode
		left outer join rds.DimDirectoryStatuses dirStatus 
		on dirStatus.CharterLeaStatusCode = q.CharterLeaStatusCode
			and dirStatus.CharterSchoolStatusCode = q.CharterSchoolStatusCode
			and dirStatus.ReconstitutedStatusCode = q.ReconstitutedStatusCode
			and dirStatus.OperationalStatusCode = q.OperationalStatusCode
			and dirStatus.UpdatedOperationalStatusCode = q.UpdatedOperationalStatusCode
		left outer join rds.DimOrganizationStatus organizationStatus 
		on organizationStatus.GunFreeStatusCode = q.GunFreeStatusCode
			and organizationStatus.GraduationRateCode = q.GraduationRateCode
		left join rds.DimComprehensiveAndTargetedSupports cts on cts.ComprehensiveAndTargetedSupportCode=q.ComprehensiveAndTargetedSupportCode
			and cts.ComprehensiveSupportCode=q.ComprehensiveSupportCode
			and cts.TargetedSupportCode=q.TargetedSupportCode
	
		--Clear the temp tables
		DELETE FROM @DirectoryDateQuery
		DELETE FROM @SchoolDateQuery
		DELETE FROM @schoolStatusQuery
		DELETE FROM @title1StatusQuery
		DELETE FROM @directoryStatusQuery
		DELETE FROM @organizationStatusSchoolQuery
		delete from @ComprehensiveAndTargetedSupport
		drop table #queryOutput

		FETCH NEXT FROM school_cursor INTO @schoolOrganizationId, @schoolName, @IsCharterSchool, @ReportedFederally
		END
		CLOSE school_cursor
		DEALLOCATE school_cursor
	END
	ELSE
	BEGIN
		UPDATE sch
			SET [ReportedFederally] = 0
		FROM [RDS].[DimSchools] sch
		inner join ods.OrganizationDetail o on o.organizationId = sch.SchoolOrganizationId
		inner join ods.RefOrganizationType t on t.RefOrganizationTypeId = o.RefOrganizationTypeId
		-- CIID-1963
		WHERE t.Code = 'K12SchoolNotFederal' 
	END
commit transaction
end try
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
END