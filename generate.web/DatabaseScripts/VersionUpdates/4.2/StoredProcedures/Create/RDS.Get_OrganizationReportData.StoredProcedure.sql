CREATE PROCEDURE [RDS].[Get_OrganizationReportData]
	   @reportCode as varchar(50),
       @reportLevel as varchar(50),
       @reportYear as varchar(50),
       @categorySetCode as varchar(50),
	   @flag AS bit = 0
AS
BEGIN
IF(@reportCode = 'c029')
	BEGIN
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
            organizationInfo.* 
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
			[MAGNETSTATUS]  ,      
            SHAREDTIMESTATUS,
            VIRTUALSCHSTATUS,
			PERSISTENTLYDANGEROUSSTATUS,
			IMPROVEMENTSTATUS,												
            NSLPSTATUS ,
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
            case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            case when schDir.CharterSchoolStatus = 'MISSING' then '' else schDir.CharterSchoolStatus end as CharterSchoolStatus,
			case when leaDir.CharterLeaStatus = 'MISSING' then '' else leaDir.CharterLeaStatus end as CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
			CharterSchoolManagementOrganization ,
            CharterSchoolUpdatedManagementOrganization ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],											
			case 
				when @reportLevel = 'lea' THEN ISNULL(convert(varchar(10), leaDir.OperationalStatusEffectiveDate, 23), '')
				when @reportLevel = 'sch' THEN ISNULL(convert(varchar(10), schDir.SchoolOperationalStatusEffectiveDate, 23), '')
				else null
			end as EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus <= 0 THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId <= 0 then '' else fact.UpdatedOperationalStatusId end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
        ) organizationInfo
	END
	else if (@reportCode = 'c130')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
			case when @flag=1 then	
			RIGHT(PERSISTENTLYDANGEROUSSTATUS,(LEN(PERSISTENTLYDANGEROUSSTATUS)- CHARINDEX(',',PERSISTENTLYDANGEROUSSTATUS)))
			else 
			LEFT(PERSISTENTLYDANGEROUSSTATUS,(CHARINDEX(',',PERSISTENTLYDANGEROUSSTATUS)-1))
			end as PERSISTENTLYDANGEROUSSTATUS,
			case when @flag=1 then
			RIGHT(IMPROVEMENTSTATUS,(LEN(IMPROVEMENTSTATUS)-CHARINDEX(',',IMPROVEMENTSTATUS)))
			ELSE
			LEFT(IMPROVEMENTSTATUS,(CHARINDEX(',',IMPROVEMENTSTATUS)-1))
			END AS IMPROVEMENTSTATUS,
            NSLPSTATUS ,
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			 fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
        ) organizationInfo       
		inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                    GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                    FROM rds.FactOrganizationCountReports b 
                    WHERE b.OrganizationStateId = a.OrganizationStateId
                    and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                    and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                    FOR XML PATH('')), 1, 2, '') as varchar(50))
        FROM rds.FactOrganizationCountReports a
        GROUP BY OrganizationStateId, ReportYear, reportLevel
		)gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
							and organizationInfo.reportYear = gradesOffered.ReportYear
							and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c132')
	BEGIN
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
			CSSOLastName ,
			CSSOTelephone,
			CSSOTitle,
			fact.Website ,
			fact.Telephone ,
			fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
			fact.MailingAddressCity,
			fact.MailingAddressState ,
			left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
			fact.SupervisoryUnionIdentificationNumber,
			OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
			 case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
			case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
			fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
		from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
			and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'TOT')
		) organizationInfo         
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                     FROM rds.FactOrganizationCountReports a
                     GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
			and organizationInfo.reportYear = gradesOffered.ReportYear
			and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c039' AND @categorySetCode is NULL)
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
            organizationInfo.*
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
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT) as EconomicallyDisadvantagedStudentCount,
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
			case when fact.OperationalStatus in ('Inactive','Closed','Future') then 'NOGRADES'
			else ISNULL(GRADELEVEL, 'UG') end as GRADELEVEL
			
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear
		) organizationInfo     

      
	END
	ELSE if (@reportCode = 'c196')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(dcsaa.CharterSchoolManagementOrganizationTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		left outer join rds.DimCharterSchoolManagementOrganizations dcsaa on fact.OrganizationStateId = dcsaa.StateIdentifier
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
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                FROM rds.FactOrganizationCountReports a
                GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c035')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
		) organizationInfo     
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(100))
                FROM rds.FactOrganizationCountReports a
                GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on ISNULL(organizationInfo.OrganizationStateId,'') = case when @reportLevel = 'sea' then '' else gradesOffered.OrganizationStateId end
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationStateId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
			fact.MailingAddressStreet2,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when LEN(fact.MailingAddressPostalCode) = 10 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
			fact.PhysicalAddressStreet2 ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when LEN(fact.PhysicalAddressPostalCode) = 10 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            fact.SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
             case when @reportLevel = 'lea' then leaDir.ReconstitutedStatus 
				 when @reportLevel = 'sch' then schDir.ReconstitutedStatus
				 else NULL
			end as ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            schDir.CharterSchoolStatus,
            leaDir.CharterLeaStatus,
			fact.CHARTERCONTRACTAPPROVALDATE,
			fact.CHARTERCONTRACTRENEWALDATE,
			fact.CHARTERSCHOOLCONTRACTIDNUMBER,
            fact.CharterSchoolAuthorizer ,
            fact.CharterSchoolSecondaryAuthorizer ,
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
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
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
			AppropriationMethodCode
        from rds.FactOrganizationCountReports fact
		left outer join rds.DimLeas leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode and fact.OrganizationStateId = leaDir.LeaIdentifierState
		left outer join rds.DimK12Schools schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode and fact.OrganizationStateId = schDir.SchoolIdentifierState
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
		) organizationInfo     
        inner join (SELECT OrganizationStateId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationStateId = a.OrganizationStateId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(100))
                FROM rds.FactOrganizationCountReports a
                GROUP BY OrganizationStateId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationStateId = gradesOffered.OrganizationStateId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
END