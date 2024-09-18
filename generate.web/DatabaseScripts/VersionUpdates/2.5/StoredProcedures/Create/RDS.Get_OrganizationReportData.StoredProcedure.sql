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

						SELECT 
                           CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
                           organizationInfo.* from
       
						(select  distinct       @reportCode as ReportCode, 
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
                                                fact.MailingAddressPostalCode ,
                                                fact.PhysicalAddressStreet ,
                                                fact.PhysicalAddressCity ,
                                                fact.PhysicalAddressState ,
                                                fact.PhysicalAddressPostalCode ,
												
                                                SupervisoryUnionIdentificationNumber ,
                                                OperationalStatus ,
												fact.OperationalStatusId,
                                                LEAType ,
												CAST(isnull(leaDir.LeaTypeId,'') as varchar(50)) as LEATypeId,
                                                SchoolType ,
												CAST(isnull(schDir.SchoolTypeId,'') as varchar(50)) as SchoolTypeId,
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
												CAST(isnull(fact.UpdatedOperationalStatusId,'') as varchar(50)) as UpdatedOperationalStatusId,
												CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
												CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
												fact.LeaStateIdentifier,
												fact.LeaNcesIdentifier,												
												ISNULL(fact.ManagementOrganizationType,'') as ManagementOrganizationType,
												isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
												CAST(isnull(EconomicallyDisadvantagedStudentCount,0) as int)as EconomicallyDisadvantagedStudentCount,
												CAST(isnull(fact.McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient,
												CAST(null as varchar(50)) as GRADELEVEL
                                         from rds.FactOrganizationCountReports fact
										 left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeCode 
										 left outer join [RDS].[DimDirectories] schDir on fact.LEAType = schDir.LeaTypeCode 
										 where reportcode = @reportCode and ReportLevel = @reportLevel 
										 and ReportYear = @reportYear and [CategorySetCode] = isnull(@categorySetCode,'CSA')
                     ) organizationInfo


		END
		else if (@reportCode = 'c130')

		BEGIN
						SELECT
                           CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
                           organizationInfo.*, gradesOffered.GRADELEVEL from
       
						(select  distinct       @reportCode as ReportCode, 
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
                                                fact.MailingAddressPostalCode ,
                                                fact.PhysicalAddressStreet ,
                                                fact.PhysicalAddressCity ,
                                                fact.PhysicalAddressState ,
                                                fact.PhysicalAddressPostalCode ,
                                                SupervisoryUnionIdentificationNumber ,
                                                OperationalStatus ,
												fact.OperationalStatusId,
                                                LEAType ,
												CAST(isnull(leaDir.LeaTypeId,'') as varchar(50)) as LEATypeId,
                                                SchoolType ,
												CAST(isnull(schDir.SchoolTypeId,'') as varchar(50)) as SchoolTypeId,
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
												CAST(isnull(fact.UpdatedOperationalStatusId,'') as varchar(50)) as UpdatedOperationalStatusId,
												CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
												CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
												fact.LeaStateIdentifier,
												fact.LeaNcesIdentifier,												
												ISNULL(fact.ManagementOrganizationType,'') as ManagementOrganizationType,
												isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
												CAST(isnull(EconomicallyDisadvantagedStudentCount,0) as int)as EconomicallyDisadvantagedStudentCount,
												CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient
                                         from rds.FactOrganizationCountReports fact
										 left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeCode 
										 left outer join [RDS].[DimDirectories] schDir on fact.LEAType = schDir.LeaTypeCode 
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
						SELECT
                           CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
                           organizationInfo.*, gradesOffered.GRADELEVEL from
       
						(select  distinct       @reportCode as ReportCode, 
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
                                                fact.MailingAddressPostalCode ,
                                                fact.PhysicalAddressStreet ,
                                                fact.PhysicalAddressCity ,
                                                fact.PhysicalAddressState ,
                                                fact.PhysicalAddressPostalCode ,
                                                SupervisoryUnionIdentificationNumber ,
                                                OperationalStatus ,
												fact.OperationalStatusId,
                                                LEAType ,
												CAST(isnull(leaDir.LeaTypeId,'') as varchar(50)) as LEATypeId,
                                                SchoolType ,
												CAST(isnull(schDir.SchoolTypeId,'') as varchar(50)) as SchoolTypeId,
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
												CAST(isnull(fact.UpdatedOperationalStatusId,'') as varchar(50)) as UpdatedOperationalStatusId,
												CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
												CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
												LeaStateIdentifier,
												LeaNcesIdentifier,												
												ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
												isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
												CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
												CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient
                                         from rds.FactOrganizationCountReports fact
										 left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeCode 
										 left outer join [RDS].[DimDirectories] schDir on fact.LEAType = schDir.LeaTypeCode 
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
               


		ELSE
		BEGIN
						SELECT
                           CAST(ROW_NUMBER() OVER(ORDER BY organizationInfo.OrganizationId ASC) AS INT) as FactOrganizationCountReportDtoId,                     
                           organizationInfo.*, gradesOffered.GRADELEVEL from
       
						(select  distinct       @reportCode as ReportCode, 
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
                                                fact.MailingAddressPostalCode ,
                                                fact.PhysicalAddressStreet ,
                                                fact.PhysicalAddressCity ,
                                                fact.PhysicalAddressState ,
                                                fact.PhysicalAddressPostalCode ,
                                                SupervisoryUnionIdentificationNumber ,
                                                OperationalStatus ,
												fact.OperationalStatusId,
                                                LEAType ,
												CAST(isnull(leaDir.LeaTypeId,'') as varchar(50)) as LEATypeId,
                                                SchoolType ,
												CAST(isnull(schDir.SchoolTypeId,'') as varchar(50)) as SchoolTypeId,
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
												CAST(isnull(fact.UpdatedOperationalStatusId,'') as varchar(50)) as UpdatedOperationalStatusId,
												CAST(isnull(fact.TitleiParentalInvolveRes,'') as varchar(50)) as TitleiParentalInvolveRes,
												CAST(isnull(fact.TitleiPartaAllocations,'') as varchar(50)) as TitleiPartaAllocations,
												LeaStateIdentifier,
												LeaNcesIdentifier,												
												ISNULL(ManagementOrganizationType,'') as ManagementOrganizationType,
												isnull(SCHOOLIMPROVEMENTFUNDS,0) as SCHOOLIMPROVEMENTFUNDS,
												CAST(isnull(EconomicallyDisadvantagedStudentCount,0) AS INT)as EconomicallyDisadvantagedStudentCount,
												CAST(isnull(McKinneyVentoSubgrantRecipient,'')AS VARCHAR(MAX)) as McKinneyVentoSubgrantRecipient
                                         from rds.FactOrganizationCountReports fact
										 left outer join [RDS].[DimDirectories] leaDir on fact.LEAType = leaDir.LeaTypeCode 
										 left outer join [RDS].[DimDirectories] schDir on fact.LEAType = schDir.LeaTypeCode 
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