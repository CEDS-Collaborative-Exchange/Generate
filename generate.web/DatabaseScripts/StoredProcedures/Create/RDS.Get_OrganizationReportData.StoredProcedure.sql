CREATE PROCEDURE [RDS].[Get_OrganizationReportData]
	   @reportCode as varchar(50),
       @reportLevel as varchar(50),
       @reportYear as varchar(50),
       @categorySetCode as varchar(50),
	   @flag AS bit = 0,
	   @StartDate DATE = NULL,
	   @EndDate DATE = NULL
AS
BEGIN

	--set the SY start/end dates to the defaults if they weren't passed in
	if isnull(@StartDate, '') = ''
	begin
		SELECT @StartDate = CAST('7/1/' + CAST(@reportyear - 1 AS VARCHAR(4)) AS DATE)
	end 

	if isnull(@EndDate, '') = ''
	begin
		SELECT @EndDate = CAST('6/30/' + CAST(@reportyear  AS VARCHAR(4)) AS DATE)
	end 
		
	IF(@reportCode = 'c029')
	BEGIN
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
            organizationInfo.* 
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            'CSA' as CategorySetCode, 
            fact.StateANSICode,
            fact.StateCode,
            fact.StateName,
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
            TITLE1SCHOOLSTATUS,
			PROGRESSACHIEVINGENGLISHLANGUAGE,
			StateDefinedStatus,
			[MAGNETSTATUS]  ,      
            SHAREDTIMESTATUS,
            VIRTUALSCHSTATUS,
			PERSISTENTLYDANGEROUSSTATUS,
			IMPROVEMENTSTATUS,												
            NSLPSTATUS ,
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastOrSurname ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressApartmentRoomOrSuiteNumber,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressApartmentRoomOrSuiteNumber,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.OrganizationTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.OrganizationTypeDescription,'') as SchoolTypeDescription,
            case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            case when schDir.CharterStatus = 'MISSING' then '' else schDir.CharterStatus end as CharterSchoolStatus,
			case when leaDir.CharterStatus = 'MISSING' then '' else leaDir.CharterStatus end as CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizerIdPrimary ,
            fact.CharterSchoolAuthorizerIdSecondary,
			CharterSchoolManagementOrganization ,
            CharterSchoolUpdatedManagementOrganization,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],											
			case 
				when @reportLevel = 'lea' THEN ISNULL(convert(varchar(10), leaDir.OrganizationOperationalStatusEffectiveDate, 23), '')
				when @reportLevel = 'sch' THEN ISNULL(convert(varchar(10), schDir.OrganizationOperationalStatusEffectiveDate, 23), '')
				else null
			end as EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus <= 0 THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId <= 0 then '' else fact.UpdatedOperationalStatusId end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as int) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as int) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(fact.ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) as int)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(fact.McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,		
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			TargetedSupportCode,
			AdditionalTargetedSupportandImprovementCode,
			CAST(null as varchar(50)) as GRADELEVEL,
			AppropriationMethodCode,
			CharterSchoolAuthorizerType
        from RDS.ReportEDFactsOrganizationCounts fact
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir on fact.OrganizationStateId = schDir.OrganizationIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
			and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
		) organizationInfo
	END
	else if (@reportCode = 'c130')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
            organizationInfo.*
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            'CSA' as CategorySetCode, 
            StateANSICode,
            StateCode,
            StateName,
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
			PERSISTENTLYDANGEROUSSTATUS,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            OrganizationCount,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier
        from RDS.ReportEDFactsOrganizationCounts fact
		where reportcode = @reportCode 
		and ReportLevel = @reportLevel 
		and ReportYear = @reportYear 
		and [CategorySetCode] = isnull(@categorySetCode,'CSA')
        ) organizationInfo       
	END
	ELSE if (@reportCode = 'c132')
	BEGIN
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
			organizationInfo.*, gradesOffered.GRADELEVEL 
		from
		(select  distinct       
			@reportCode as ReportCode, 
			@reportYear as ReportYear,
			@reportLevel as ReportLevel,
			NULL as CategorySetCode, 
			fact.StateANSICode,
            fact.StateCode,
            fact.StateName,			
			OrganizationNcesId,
			OrganizationStateId,
			OrganizationName,
			ParentOrganizationStateId,
			ParentOrganizationNcesId,
			TITLE1SCHOOLSTATUS,   
			PROGRESSACHIEVINGENGLISHLANGUAGE,
			StateDefinedStatus,
			[MAGNETSTATUS],      
			SHAREDTIMESTATUS,
			VIRTUALSCHSTATUS,	
			PERSISTENTLYDANGEROUSSTATUS,
			IMPROVEMENTSTATUS,
			NSLPSTATUS ,
			CSSOEmail ,
			CSSOFirstName ,
			CSSOLastOrSurname ,
			CSSOTelephone,
			CSSOTitle,
			fact.Website ,
			fact.Telephone ,
			fact.MailingAddressStreet,
			fact.MailingAddressApartmentRoomOrSuiteNumber,
			fact.MailingAddressCity,
			fact.MailingAddressState ,
			left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressApartmentRoomOrSuiteNumber ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
			fact.SupervisoryUnionIdentificationNumber,
			OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.OrganizationTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.OrganizationTypeDescription,'') as SchoolTypeDescription,
			 case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
			case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterStatus AS CharterSchoolStatus,
            leaDir.CharterStatus AS CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
			fact.CharterSchoolAuthorizerIdPrimary ,
            fact.CharterSchoolAuthorizerIdSecondary ,
			CharterSchoolManagementOrganization ,
            CharterSchoolUpdatedManagementOrganization ,
			STATEPOVERTYDESIGNATION,											
			OrganizationCount,
			[TableTypeAbbrv],
			[TotalIndicator],												
			case 
				when fact.EffectiveDate IS NOT NULL THEN convert(varchar(10), fact.EffectiveDate, 23)
				else null
			end as EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus <= 0 THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId <= 0 then '' else fact.UpdatedOperationalStatusId end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as int) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as int) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(fact.McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			TargetedSupportCode,
			AdditionalTargetedSupportandImprovementCode,
			AppropriationMethodCode,
			CharterSchoolAuthorizerType
		from rds.ReportEDFactsOrganizationCounts fact
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir on fact.OrganizationStateId = schDir.OrganizationIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
			and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'TOT')
		) organizationInfo         
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.ReportEDFactsOrganizationCounts b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                     FROM rds.ReportEDFactsOrganizationCounts a
                     GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
			and organizationInfo.reportYear = gradesOffered.ReportYear
			and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c039' AND @categorySetCode is NULL)
	BEGIN

		--Get the reportable schools that will have no grades offered
		IF OBJECT_ID(N'tempdb..#reportableSchools') IS NOT NULL DROP TABLE #reportableSchools

		select distinct rdks.SchoolIdentifierSea
		into #reportableSchools	
		from rds.FactOrganizationCounts rfoc
			inner join rds.DimSchoolYearDataMigrationTypes rdsdmt
				on rfoc.SchoolYearId = rdsdmt.DimSchoolYearId
				and rdsdmt.DataMigrationTypeId = 3 	
				and IsSelected = 1
			inner join rds.dimschoolyears rdsy
				on rdsdmt.dimschoolyearid = rdsy.dimschoolyearid
				and rdsy.SchoolYear = @ReportYear
			inner join rds.DimK12Schools rdks
				on rdks.DimK12SchoolId = rfoc.K12SchoolId
		where rdks.SchoolTypeCode = 'Reportable'

		CREATE INDEX IDX_reportableSchools ON #reportableSchools (SchoolIdentifierSea)

		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsGradesOfferedId,                     
            organizationInfo.*
		from
			(select  distinct       
				@reportCode as ReportCode, 
				@reportYear as ReportYear,
				@reportLevel as ReportLevel,
				'CSA' as CategorySetCode, 
				fact.StateANSICode,
				fact.StateCode,
				fact.StateName,            
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				ParentOrganizationNcesId,
				[TableTypeAbbrv],
				[TotalIndicator],
				fact.OperationalStatus,
				-- NOTE: the Fact table doesn't store Operational Status as words, but rather the number (as a varchar).
				-- 2=closed   6=inactive   7=future
				case 
					when @ReportLevel = 'SCH' and fact.OperationalStatus in ('2','6','7') then 'NOGRADES' -- File spec doesn't mention how to handle non-operational schools, so making this assumption
					when @ReportLevel = 'LEA' and fact.OperationalStatus in ('2','6','7') then 'NOGRADES'
					when @ReportLevel = 'LEA' and Fact.OrganizationStateId in (
							-- LEAs with No Schools
							select distinct isnull(LEA.OrganizationStateId,'')
							from rds.ReportEDFactsOrganizationCounts LEA
							full outer join rds.ReportEDFactsOrganizationCounts SCH
								on isnull(SCH.ReportCode,'') = isnull(LEA.ReportCode,'')
								and isnull(SCH.ReportYear,'') = isnull(LEA.ReportYear,'')
								and isnull(SCH.ParentOrganizationStateId,'') = isnull(LEA.OrganizationStateId,'')
								and isnull(SCH.ReportLevel,'SCH') = 'SCH'
								and isnull(LEA.ReportLevel,'LEA') = 'LEA'
							left join #reportableSchools rs 	
								on SCH.OrganizationStateId = rs.SchoolIdentifierSea
							where LEA.ReportCode = 'c039' 
								and LEA.ReportYear = @ReportYear
								and LEA.ReportLevel = 'LEA'
								and SCH.ParentOrganizationStateId is null	
							) then 'NOGRADES'
				else ISNULL(GRADELEVEL, 'UG') 
				end as GRADELEVEL
			from rds.ReportEDFactsOrganizationCounts fact
				left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir 
					on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
				left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir 
					on fact.OrganizationStateId = schDir.OrganizationIdentifierState
			where reportcode = @reportCode and ReportLevel = @reportLevel 
			and ReportYear = @reportYear
			) organizationInfo     

	END
	ELSE if (@reportCode = 'c039')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsGradesOfferedId,                     
            organizationInfo.*,
			-- NOTE: the Fact table doesn't store Operational Status as words, but rather the number (as a varchar).
			-- 2=closed   6=inactive   7=future
			case 
				when Len(isnull(gradesOffered.GRADELEVEL,'')) > 0 and OrganizationInfo.OperationalStatus not in ('2','6', '7')  then gradesOffered.GRADELEVEL
				when @ReportLevel = 'LEA' and Len(isnull(gradesOffered.GRADELEVEL,'')) = 0 AND organizationInfo.OperationalStatus not in ('2','6','7') then 'NOGRADES'
				when @ReportLevel = 'SCH' and organizationInfo.OperationalStatus in ('2','6','7') then 'NOGRADES' -- File spec doesn't mention how to handle non-operational schools, so making this assumption
				when @ReportLevel = 'LEA' and organizationInfo.OperationalStatus in ('2','6','7') then 'NOGRADES'
			else ISNULL(GRADELEVEL, 'UG') 
			end as GRADELEVEL
		from
			(select  distinct       
				@reportCode as ReportCode, 
				@reportYear as ReportYear,
				@reportLevel as ReportLevel,
				'CSA' as CategorySetCode, 
				fact.StateANSICode,
				fact.StateCode,
				fact.StateName,            
				OrganizationNcesId,
				OrganizationStateId,
				OrganizationName,
				ParentOrganizationStateId,
				ParentOrganizationNcesId,
				[TableTypeAbbrv],
				[TotalIndicator],
				OperationalStatus
			from rds.ReportEDFactsOrganizationCounts fact
				left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir 
					on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
				left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir
					on fact.OrganizationStateId = schDir.OrganizationIdentifierState
			where reportcode = @reportCode
			and ReportLevel = @reportLevel 
			and ReportYear = @reportYear and CategorySetCode =  isnull(@categorySetCode,'CSA')
			) organizationInfo     
			inner join 
				(SELECT OrganizationStateId,[ReportYear], reportLevel, 
								GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
								FROM rds.ReportEDFactsOrganizationCounts b 
								WHERE b.OrganizationStateId = a.OrganizationStateId
								and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
								and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
								FOR XML PATH('')), 1, 2, '') as varchar(100))
				FROM rds.ReportEDFactsOrganizationCounts a
				GROUP BY OrganizationStateId, ReportYear, reportLevel
				) gradesOffered 
			on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel 

      
	END
	ELSE if (@reportCode = 'c196')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
            organizationInfo.*,
			case when Len(gradesOffered.GRADELEVEL) > 0 then gradesOffered.GRADELEVEL
			     when Len(gradesOffered.GRADELEVEL) = 0 AND organizationInfo.OperationalStatus in ('Inactive','Closed','Future') then 'NOGRADES'
				 else 'UG'
			end as GRADELEVEL
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            NULL as CategorySetCode, 
             fact.StateANSICode,
            fact.StateCode,
            fact.StateName,            
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
            TITLE1SCHOOLSTATUS,
			PROGRESSACHIEVINGENGLISHLANGUAGE,
			StateDefinedStatus,
			[MAGNETSTATUS],      
            SHAREDTIMESTATUS,
            VIRTUALSCHSTATUS,	
			PERSISTENTLYDANGEROUSSTATUS,
			IMPROVEMENTSTATUS,
            NSLPSTATUS ,			
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastOrSurname ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressApartmentRoomOrSuiteNumber,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressApartmentRoomOrSuiteNumber ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(dcsaa.OrganizationTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.OrganizationTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterStatus AS CharterSchoolStatus,
            leaDir.CharterStatus AS CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizerIdPrimary ,
            fact.CharterSchoolAuthorizerIdSecondary ,
			CharterSchoolManagementOrganization ,
            CharterSchoolUpdatedManagementOrganization ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			case 
				when fact.EffectiveDate IS NOT NULL THEN convert(varchar(10), fact.EffectiveDate, 23)
				else null
			end as EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus <= 0 THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId <= 0 then '' else fact.UpdatedOperationalStatusId end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as int) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as int) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(fact.McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			CASE 
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'TSI') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'CSIEXIT'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'TSI') THEN 'TSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'CSIEXIT'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'NOTCSITSI'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'TSI') THEN 'TSI'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'TSIEXIT'
			ELSE 'MISSING'
			END	AS	ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			TargetedSupportCode,
			AdditionalTargetedSupportandImprovementCode,
			AppropriationMethodCode,
			CharterSchoolAuthorizerType
        from rds.ReportEDFactsOrganizationCounts fact
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir on fact.OrganizationStateId = schDir.OrganizationIdentifierState
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'Charter', @StartDate, @EndDate) dcsaa on fact.OrganizationStateId = dcsaa.OrganizationIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
		AND LEN (
			CASE 
				WHEN (fact.ReportYear = '2018-19' AND fact.ManagementOrganizationType IN ('CMO','EMO','Other')) THEN fact.ManagementOrganizationType
				WHEN (fact.ReportYear = '2019-20' AND fact.ManagementOrganizationType IN ('CHARCMO','CHAREMO','CHARSMFP','CHARSMNP')) THEN fact.ManagementOrganizationType
				ELSE ''
			END	) > 0
		) organizationInfo     
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.ReportEDFactsOrganizationCounts b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                FROM rds.ReportEDFactsOrganizationCounts a
                GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c035')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY fact.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
            isnull(@categorySetCode,'CSA') AS CategorySetCode, 
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            fact.StateANSICode,
            fact.StateCode,
            fact.StateName,            
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
            NULL AS TITLE1SCHOOLSTATUS,
			NULL AS PROGRESSACHIEVINGENGLISHLANGUAGE,
			NULL AS StateDefinedStatus,
			NULL AS MAGNETSTATUS,
            NULL AS SHAREDTIMESTATUS,
            NULL AS VIRTUALSCHSTATUS,	
			NULL AS PERSISTENTLYDANGEROUSSTATUS,
			NULL AS IMPROVEMENTSTATUS,
            NULL AS NSLPSTATUS,			
            NULL AS CSSOEmail,
            NULL AS CSSOFirstName,
            NULL AS CSSOLastOrSurname,
            NULL AS CSSOTelephone,
            NULL AS CSSOTitle,
            NULL AS Website,
            NULL AS Telephone,
            NULL AS MailingAddressStreet,
			NULL AS MailingAddressApartmentRoomOrSuiteNumber,
            NULL AS MailingAddressCity ,
            NULL AS MailingAddressState ,
            NULL AS MailingAddressPostalCode,
            NULL AS MailingAddressPostalCode2,
            NULL AS PhysicalAddressStreet ,
			NULL AS PhysicalAddressApartmentRoomOrSuiteNumber ,
            NULL AS PhysicalAddressCity ,
            NULL AS PhysicalAddressState ,
            NULL AS PhysicalAddressPostalCode,
			NULL AS PhysicalAddressPostalCode2,
            NULL AS SupervisoryUnionIdentificationNumber,
            NULL AS OperationalStatus,
			NULL AS OperationalStatusId,
            NULL AS LEAType,
			NULL AS LEATypeDescription,
            NULL AS SchoolType,
			NULL AS SchoolTypeDescription,
			NULL AS ReconstitutedStatus,
            NULL AS OutOfStateIndicator,
            NULL AS CharterSchoolStatus,
            NULL AS CharterLeaStatus,
			NULL AS CHARTERCONTRACTAPPROVALDATE,
			NULL AS CHARTERCONTRACTRENEWALDATE,
			NULL AS CHARTERSCHOOLCONTRACTIDNUMBER,
            NULL AS CharterSchoolAuthorizerIdPrimary ,
            NULL AS CharterSchoolAuthorizerIdSecondary ,
			NULL AS CharterSchoolManagementOrganization ,
            NULL AS CharterSchoolUpdatedManagementOrganization ,
			NULL AS STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			NULL AS EffectiveDate,
			NULL AS PriorLeaStateIdentifier,
			NULL AS PriorSchoolStateIdentifier,
			NULL AS UpdatedOperationalStatus,
			NULL AS UpdatedOperationalStatusId,
			0 AS TitleiParentalInvolveRes,
			0 AS TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			NULL AS ManagementOrganizationType,
			NULL as SCHOOLIMPROVEMENTFUNDS,
			NULL AS EconomicallyDisadvantagedStudentCount,
			NULL AS McKinneyVentoSubgrantRecipient,
			NULL AS REAPAlternativeFundingStatus,
			NULL AS GunFreeStatus,
			NULL AS GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			NULL AS ComprehensiveSupportCode,
			NULL AS ComprehensiveAndTargetedSupportCode,
			NULL AS ComprehensiveSupportImprovementCode,
			NULL AS TargetedSupportImprovementCode,
			NULL AS TargetedSupportCode,
			NULL AS AdditionalTargetedSupportandImprovementCode,
			NULL AS AppropriationMethodCode,
			NULL as GRADELEVEL,
			NULL AS CharterSchoolAuthorizerType
        from rds.ReportEDFactsOrganizationCounts fact
		where reportcode = @reportCode 
			and ReportLevel = @reportLevel 
			and ReportYear = @reportYear 
			and [CategorySetCode] = isnull(@categorySetCode,'CSA')
	END
	ELSE
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as ReportEDFactsOrganizationCountId,                     
            organizationInfo.*,

			-- Previous Logic ---------------------------------------------------------------
			--case when Len(gradesOffered.GRADELEVEL) > 0 then gradesOffered.GRADELEVEL
			--     when Len(gradesOffered.GRADELEVEL) = 0 AND organizationInfo.OperationalStatus in ('Inactive','Closed','Future') then 'NOGRADES'
			--	 else 'UG'
			--end as GRADELEVEL

			-- New Logic --------------------------------------------------------------------
			-- NOTE: the Fact table doesn't store Operational Status as words, but rather the number (as a varchar).
			-- 2=closed   6=inactive   7=future
			case 
				when Len(isnull(gradesOffered.GRADELEVEL,'')) > 0 and OrganizationInfo.OperationalStatus not in ('2','6', '7')  then gradesOffered.GRADELEVEL
				when @ReportLevel = 'LEA' and Len(isnull(gradesOffered.GRADELEVEL,'')) = 0 AND organizationInfo.OperationalStatus not in ('2','6','7') then 'NOGRADES'
				when @ReportLevel = 'SCH' and organizationInfo.OperationalStatus in ('2','6','7') then 'NOGRADES' -- File spec doesn't mention how to handle non-operational schools, so making this assumption
				when @ReportLevel = 'LEA' and organizationInfo.OperationalStatus in ('2','6','7') then 'NOGRADES'
			else ISNULL(GRADELEVEL, 'UG') end 
			as GRADELEVEL
			---------------------------------------------------------------------------------

		FROM
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            'CSA' as CategorySetCode, 
             fact.StateANSICode,
            fact.StateCode,
            fact.StateName,            
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
            TITLE1SCHOOLSTATUS,
			PROGRESSACHIEVINGENGLISHLANGUAGE,
			StateDefinedStatus,
			[MAGNETSTATUS],      
            UPPER(SHAREDTIMESTATUS) as SHAREDTIMESTATUS,
            UPPER(VIRTUALSCHSTATUS) as VIRTUALSCHSTATUS,	
			PERSISTENTLYDANGEROUSSTATUS,
			IMPROVEMENTSTATUS,
            UPPER(NSLPSTATUS) as  NSLPSTATUS,			
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastOrSurname ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressApartmentRoomOrSuiteNumber,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressApartmentRoomOrSuiteNumber ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.OrganizationTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.OrganizationTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.OrganizationTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterStatus AS CharterSchoolStatus,
            leaDir.CharterStatus AS CharterLeaStatus,
			CAST(CAST(fact.CHARTERCONTRACTAPPROVALDATE AS DATE) AS Varchar(50)) AS CHARTERCONTRACTAPPROVALDATE,
			CAST(CAST(fact.CHARTERCONTRACTRENEWALDATE AS DATE) AS Varchar(50)) AS CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizerIdPrimary ,
            fact.CharterSchoolAuthorizerIdSecondary ,
			CharterSchoolManagementOrganization ,
            CharterSchoolUpdatedManagementOrganization ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			case 
				when fact.EffectiveDate IS NOT NULL THEN convert(varchar(10), fact.EffectiveDate, 23)
				else null
			end as EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus <= 0 THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId <= 0 then '' else fact.UpdatedOperationalStatusId end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as int) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as int) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(fact.McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			CASE 
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'TSI') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSI' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'CSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'CSIEXIT'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'TSI') THEN 'TSI'
				WHEN (ComprehensiveSupportImprovementCode = 'CSIEXIT' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'CSIEXIT'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'NOTTSI') THEN 'NOTCSITSI'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'TSI') THEN 'TSI'
				WHEN (ComprehensiveSupportImprovementCode = 'NOTCSI' AND TargetedSupportImprovementCode = 'TSIEXIT') THEN 'TSIEXIT'
			ELSE 'MISSING'
			END	AS	ComprehensiveAndTargetedSupportCode,
			ComprehensiveSupportImprovementCode,
			TargetedSupportImprovementCode,
			TargetedSupportCode,
			AdditionalTargetedSupportandImprovementCode,
			AppropriationMethodCode,
			CharterSchoolAuthorizerType
        from rds.ReportEDFactsOrganizationCounts fact
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'LEA', @StartDate, @EndDate) leaDir on  fact.OrganizationStateId = leaDir.OrganizationIdentifierState
			left outer join [RDS].[MaxRecordStartDateTime](@reportYear,'K12School', @StartDate, @EndDate) schDir on fact.OrganizationStateId = schDir.OrganizationIdentifierState
		where reportcode = case when @reportCode = 'C039' then 'C029' else @ReportCode end
		and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
		) organizationInfo     
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.ReportEDFactsOrganizationCounts b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear 
							and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(100))
                FROM rds.ReportEDFactsOrganizationCounts a
                GROUP BY OrganizationStateId, ReportYear, reportLevel
       ) gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
END