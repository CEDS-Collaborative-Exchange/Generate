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
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
            organizationInfo.* 
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            NULL as CategorySetCode, 
            StateANSICode,
            StateCode,
            StateName,
            OrganizationId,
            OrganizationNcesId,
            OrganizationStateId,
            OrganizationName,
            ParentOrganizationStateId,
			ParentOrganizationNcesId,
            TITLE1SCHOOLSTATUS,
			PROGRESSACHIEVINGENGLISHLANGUAGE,
			StateDefinedStatus,
            -- MIGRNTSTATUS,
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
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when CHARINDEX('-', fact.MailingAddressPostalCode) > 0 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when CHARINDEX('-', fact.PhysicalAddressPostalCode) > 0 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
            ReconstitutedStatus ,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            case when CharterSchoolStatus = 'MISSING' then '' else CharterSchoolStatus end as CharterSchoolStatus,
			case when CharterLeaStatus = 'MISSING' then '' else CharterLeaStatus end as CharterLeaStatus,
			CHARTERCONTRACTAPPROVALDATE,
			CHARTERCONTRACTRENEWALDATE,
			CHARTERSCHOOLCONTRACTIDNUMBER,
            CharterSchoolAuthorizerIdPrimary ,
            CharterSchoolAuthorizerIdSecondary ,
			CHARTERSCHOOLMANAGERORGANIZATION ,
            CHARTERSCHOOLUPDATEDMANAGERORGANIZATION ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],											
			fact.EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus = 'MISSING' THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId > 0 then fact.UpdatedOperationalStatusId else '' end as UpdatedOperationalStatusId,
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
			TargetedSupportCode,
			CAST(null as varchar(50)) as GRADELEVEL
        from rds.FactOrganizationCountReports fact
		left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode
		left outer join [RDS].[DimDirectories] schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
        ) organizationInfo
	END
	else if (@reportCode = 'c130')
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
            organizationInfo.*, gradesOffered.GRADELEVEL 
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            NULL as CategorySetCode, 
            StateANSICode,
            StateCode,
            StateName,
            OrganizationId,
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
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when CHARINDEX('-', fact.MailingAddressPostalCode) > 0 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when CHARINDEX('-', fact.PhysicalAddressPostalCode) > 0 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
            ReconstitutedStatus ,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            CharterSchoolStatus ,
            CharterLeaStatus ,
			CHARTERCONTRACTAPPROVALDATE,
			CHARTERCONTRACTRENEWALDATE,
			CHARTERSCHOOLCONTRACTIDNUMBER,
            CharterSchoolAuthorizerIdPrimary ,
            CharterSchoolAuthorizerIdSecondary ,
			CHARTERSCHOOLMANAGERORGANIZATION ,
            CHARTERSCHOOLUPDATEDMANAGERORGANIZATION ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			fact.EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus = 'MISSING' THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId > 0 then fact.UpdatedOperationalStatusId else '' end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
			fact.LeaStateIdentifier,
			fact.LeaNcesIdentifier,												
			ISNULL(fact.ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) as int)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			TargetedSupportCode
        from rds.FactOrganizationCountReports fact
		left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode
		left outer join [RDS].[DimDirectories] schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
        ) organizationInfo       
		inner join (SELECT OrganizationId,[ReportYear], reportLevel, 
                    GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                    FROM rds.FactOrganizationCountReports b 
                    WHERE b.OrganizationId = a.OrganizationId
                    and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                    and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                    FOR XML PATH('')), 1, 2, '') as varchar(50))
        FROM rds.FactOrganizationCountReports a
        GROUP BY OrganizationId, ReportYear, reportLevel
		)gradesOffered 
		on organizationInfo.OrganizationId = gradesOffered.OrganizationId
							and organizationInfo.reportYear = gradesOffered.ReportYear
							and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c132')
	BEGIN
		SELECT CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
			organizationInfo.*, gradesOffered.GRADELEVEL 
		from
		(select  distinct       
			@reportCode as ReportCode, 
			@reportYear as ReportYear,
			@reportLevel as ReportLevel,
			NULL as CategorySetCode, 
			StateANSICode,
			StateCode,
			StateName,
			OrganizationId,
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
			fact.MailingAddressCity ,
			fact.MailingAddressState ,
			left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when CHARINDEX('-', fact.MailingAddressPostalCode) > 0 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when CHARINDEX('-', fact.PhysicalAddressPostalCode) > 0 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
			SupervisoryUnionIdentificationNumber ,
			OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
			ReconstitutedStatus ,
			case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
			CharterSchoolStatus ,
			CharterLeaStatus ,
			CHARTERCONTRACTAPPROVALDATE,
			CHARTERCONTRACTRENEWALDATE,
			CHARTERSCHOOLCONTRACTIDNUMBER,
			CharterSchoolAuthorizerIdPrimary ,
			CharterSchoolAuthorizerIdSecondary ,
			CHARTERSCHOOLMANAGERORGANIZATION ,
			CHARTERSCHOOLUPDATEDMANAGERORGANIZATION ,
			STATEPOVERTYDESIGNATION,											
			OrganizationCount,
			[TableTypeAbbrv],
			[TotalIndicator],												
			fact.EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus = 'MISSING' THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId > 0 then fact.UpdatedOperationalStatusId else '' end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
			LeaStateIdentifier,
			LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			TargetedSupportCode
		from rds.FactOrganizationCountReports fact
		left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode
		left outer join [RDS].[DimDirectories] schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode
		where reportcode = @reportCode and ReportLevel = @reportLevel 
			and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'TOT')
		) organizationInfo         
        inner join (SELECT OrganizationId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationId = a.OrganizationId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                     FROM rds.FactOrganizationCountReports a
                     GROUP BY OrganizationId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationId = gradesOffered.OrganizationId
			and organizationInfo.reportYear = gradesOffered.ReportYear
			and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
	ELSE if (@reportCode = 'c039' AND @categorySetCode is NULL)
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
            organizationInfo.*
		from
		(select  distinct       
			@reportCode as ReportCode, 
            @reportYear as ReportYear,
            @reportLevel as ReportLevel,
            NULL as CategorySetCode, 
            StateANSICode,
            StateCode,
            StateName,
            OrganizationId,
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
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when CHARINDEX('-', fact.MailingAddressPostalCode) > 0 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when CHARINDEX('-', fact.PhysicalAddressPostalCode) > 0 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
            ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            CharterSchoolStatus ,
            CharterLeaStatus ,
			CHARTERCONTRACTAPPROVALDATE,
			CHARTERCONTRACTRENEWALDATE,
			CHARTERSCHOOLCONTRACTIDNUMBER,
            CharterSchoolAuthorizerIdPrimary ,
            CharterSchoolAuthorizerIdSecondary ,
			CHARTERSCHOOLMANAGERORGANIZATION ,
            CHARTERSCHOOLUPDATEDMANAGERORGANIZATION ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			fact.EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus = 'MISSING' THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId > 0 then fact.UpdatedOperationalStatusId else '' end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
			LeaStateIdentifier,
			LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			TargetedSupportCode,
			case when fact.OperationalStatus in ('Inactive','Closed','Future') then 'NOGRADES'
			else ISNULL(GRADELEVEL, 'UG') end as GRADELEVEL
        from rds.FactOrganizationCountReports fact
		left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode
		left outer join [RDS].[DimDirectories] schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear
		) organizationInfo     

      
	END
	ELSE
	BEGIN
		SELECT
            CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
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
            StateANSICode,
            StateCode,
            StateName,
            OrganizationId,
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
			--COMPREHENSIVESUPPORTIDENTIFICATIONTYPEID,
			--COMPREHENSIVETARGETEDSUPPORTSCHTYPEID,
			--TARGETEDSUPPORTIDENTIFICATIONTYPEID,
            CSSOEmail ,
            CSSOFirstName ,
            CSSOLastName ,
            CSSOTelephone,
            CSSOTitle,
            fact.Website ,
            fact.Telephone ,
            fact.MailingAddressStreet,
            fact.MailingAddressCity ,
            fact.MailingAddressState ,
            left(fact.MailingAddressPostalCode, 5) as MailingAddressPostalCode,
            case when CHARINDEX('-', fact.MailingAddressPostalCode) > 0 then right(fact.MailingAddressPostalCode, 4) else '' end as MailingAddressPostalCode2,
            fact.PhysicalAddressStreet ,
            fact.PhysicalAddressCity ,
            fact.PhysicalAddressState ,
            left(fact.PhysicalAddressPostalCode, 5) as PhysicalAddressPostalCode,
			case when CHARINDEX('-', fact.PhysicalAddressPostalCode) > 0 then right(fact.PhysicalAddressPostalCode, 4) else '' end as PhysicalAddressPostalCode2,
            SupervisoryUnionIdentificationNumber ,
            OperationalStatus ,
			case when fact.OperationalStatusId > 0 then fact.OperationalStatusId else '' end as OperationalStatusId,
            CAST(ISNULL(leaDir.LeaTypeEdFactsCode,'') as varchar(50)) as LEAType,
			isnull(leaDir.LeaTypeDescription,'') as LEATypeDescription,
            CAST(isnull(schDir.SchoolTypeEdFactsCode,'') as varchar(50)) as SchoolType,
			isnull(schDir.SchoolTypeDescription,'') as SchoolTypeDescription,
            ReconstitutedStatus,
            case WHEN fact.OutOfStateIndicator = 1 then 'YES' ELSE 'NO' end as OutOfStateIndicator,
            CharterSchoolStatus ,
            CharterLeaStatus ,
			CHARTERCONTRACTAPPROVALDATE,
			CHARTERCONTRACTRENEWALDATE,
			CHARTERSCHOOLCONTRACTIDNUMBER,
            CharterSchoolAuthorizerIdPrimary ,
            CharterSchoolAuthorizerIdSecondary ,
			CHARTERSCHOOLMANAGERORGANIZATION ,
            CHARTERSCHOOLUPDATEDMANAGERORGANIZATION ,
			STATEPOVERTYDESIGNATION,											
            OrganizationCount,
            [TableTypeAbbrv],
            [TotalIndicator],												
			fact.EffectiveDate,
			fact.PriorLeaStateIdentifier,
			fact.PriorSchoolStateIdentifier,
			CASE WHEN fact.UpdatedOperationalStatus = 'MISSING' THEN '' else fact.UpdatedOperationalStatus end as UpdatedOperationalStatus,
			case when fact.UpdatedOperationalStatusId > 0 then fact.UpdatedOperationalStatusId else '' end as UpdatedOperationalStatusId,
			CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
			CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
			LeaStateIdentifier,
			LeaNcesIdentifier,												
			ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
			isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
			CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
			CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
			CAST(isnull(REAPAlternativeFundingStatus,'') as varchar(50)) as REAPAlternativeFundingStatus,
			CAST(isnull(GunFreeStatus,'') as varchar(50)) as GunFreeStatus,
			CAST(isnull(GraduationRate,'') as varchar(50)) as GraduationRate,
			FederalFundAllocationType,
			FederalProgramCode,
			ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
			ComprehensiveSupportCode,
			ComprehensiveAndTargetedSupportCode,
			TargetedSupportCode
        from rds.FactOrganizationCountReports fact
		left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeEdFactsCode
		left outer join [RDS].[DimDirectories] schDir on fact.SchoolType = schDir.SchoolTypeEdFactsCode
		where reportcode = @reportCode and ReportLevel = @reportLevel 
		and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
		) organizationInfo     
        inner join (SELECT OrganizationId,[ReportYear], reportLevel, 
                            GRADELEVEL =     Cast(STUFF((SELECT DISTINCT ', ' + GRADELEVEL
                            FROM rds.FactOrganizationCountReports b 
                            WHERE b.OrganizationId = a.OrganizationId
                            and reportcode = @reportCode and ReportLevel =@reportLevel and ReportYear = @reportYear and [CategorySetCode] = (case when @reportCode='c205' THEN 'TOT' ELSE isnull(@categorySetCode,'CSA') END)
                            and b.reportYear = a.reportYear and a.ReportLevel = b.ReportLevel
                            FOR XML PATH('')), 1, 2, '') as varchar(50))
                FROM rds.FactOrganizationCountReports a
                GROUP BY OrganizationId, ReportYear, reportLevel
       )gradesOffered 
		on organizationInfo.OrganizationId = gradesOffered.OrganizationId
            and organizationInfo.reportYear = gradesOffered.ReportYear
            and organizationInfo.ReportLevel = gradesOffered.ReportLevel
	END
END