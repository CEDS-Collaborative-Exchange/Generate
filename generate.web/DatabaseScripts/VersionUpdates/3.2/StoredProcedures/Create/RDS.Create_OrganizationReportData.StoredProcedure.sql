CREATE PROCEDURE [RDS].[Create_OrganizationReportData]
	@reportCode as varchar(50),
	@runAsTest as bit
AS

BEGIN
	SET NOCOUNT ON;
	declare @tableTypeAbbrv as nvarchar(50)
	
	-- Get DataMigrationId and DimFactTypeId
	declare @dataMigrationTypeId as int, @dimFactTypeId as int

	select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'directory'
	select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'
	
	
	-- Get Fact/Report Tables/Fields
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	select @tableTypeAbbrv=ReportTypeAbbreviation from app.GenerateReports where ReportCode=@reportCode

	-- Loop through all submission years
	---------------------------------------------
	declare @submissionYears as table(
		SubmissionYear varchar(50)
	)
	insert into @submissionYears
		(
			SubmissionYear
		)
	select distinct cs.SubmissionYear 	
	from app.CategorySets cs
	inner join rds.DimDates d on d.SubmissionYear=cs.SubmissionYear
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 
	and dd.DataMigrationTypeId=@dataMigrationTypeId
	inner join app.GenerateReports r on r.GenerateReportId=cs.GenerateReportId and r.ReportCode=@reportCode
	Where cs.GenerateReportId in (select GenerateReportId from app.GenerateReports where ReportCode <> 'cohortgraduationrate') 
		and r.IsLocked=1

	declare @reportYear as varchar(50)
	
	DECLARE submissionYear_cursor CURSOR FOR 
	SELECT SubmissionYear
	FROM @submissionYears
	order by SubmissionYear desc

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Loop through Category Sets for this Submission Year
		---------------------------------------------
		declare @categorySetId as int
		declare @reportLevel as varchar(5)
		declare @categorySetCode as varchar(50)

		declare @categorySetCnt as int
		select @categorySetCnt = count(*) from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		where r.ReportCode = @reportCode and cs.SubmissionYear = @reportYear

		declare @categorySetCntr as int
		set @categorySetCntr = 0

		DECLARE categoryset_cursor CURSOR FOR 
		SELECT cs.CategorySetId, o.LevelCode, cs.CategorySetCode
		from app.CategorySets cs
		inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		where r.ReportCode = @reportCode and cs.SubmissionYear = @reportYear

		OPEN categoryset_cursor
		FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if @runAsTest = 0
			begin
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)

				if(@reportCode = 'c029')
				begin
					if(@reportLevel = 'sea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CSSOEmail]
							,[CSSOFirstName]
							,[CSSOLastName]
							,[CSSOTelephone]
							,[CSSOTitle]
							,[CategorySetCode]
							,[MailingAddressCity]
							,[MailingAddressPostalCode]
							,[MailingAddressState]
							,[MailingAddressStreet]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[PhysicalAddressCity]
							,[PhysicalAddressPostalCode]
							,[PhysicalAddressState]
							,[PhysicalAddressStreet]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[Telephone]
							,[TotalIndicator]
							,[Website])
						select p.Email,p.FirstName,p.LastName,p.Telephone,p.Title, @categorySetCode,
							sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.MailingAddressState, sea.MailingAddressStreet,
							1 as OrganizationCount, 
							--sea.DimSeaId as OrganizationId,
							sea.seaOrganizationId as OrganizationId,
								sea.SeaName as OrganizationName ,
							sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressState, sea.PhysicalAddressStreet,
							@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateCode, sea.StateName, sea.Telephone, 0 as TotalIndicator, sea.Website
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSeas sea on fact.DimSeaId = sea.DimSeaId
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and sea.DimSeaId <> -1
					end
					else if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[CharterLeaStatus]
							,[LEAType]
							,[MailingAddressCity]
							,[MailingAddressPostalCode]
							,[MailingAddressState]
							,[MailingAddressStreet]
							,[OperationalStatus]
							,[OperationalStatusId]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[OutOfStateIndicator]
							,[PhysicalAddressCity]
							,[PhysicalAddressPostalCode]
							,[PhysicalAddressState]
							,[PhysicalAddressStreet]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[SupervisoryUnionIdentificationNumber]
							,[Telephone]
							,[TotalIndicator]
							,[Website]
							,EffectiveDate
							,PriorLeaStateIdentifier
							,UpdatedOperationalStatus
							,[UpdatedOperationalStatusId])
						select @categorySetCode,dirStatus.CharterLeaStatusEdFactsCode,lea.LeaTypeEdFactsCode,
							lea.MailingAddressCity, lea.MailingAddressPostalCode, lea.MailingAddressState, lea.MailingAddressStreet,
							dirStatus.OperationalStatusEdFactsCode, dirStatus.OperationalStatusId,
							1 as OrganizationCount, 
							lea.LeaOrganizationId as OrganizationId,
							lea.LeaName as OrganizationName ,lea.LeaNcesIdentifier,lea.LeaStateIdentifier,
							lea.OutOfStateIndicator,lea.PhysicalAddressCity , lea.PhysicalAddressPostalCode, lea.PhysicalAddressState, lea.PhysicalAddressStreet,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, lea.SupervisoryUnionIdentificationNumber,
							lea.Telephone, 0 as TotalIndicator, lea.Website, priorLea.EffectiveDate, priorLea.PriorLeaStateIdentifier, 
							dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						left outer join rds.DimLeas priorLea on fact.DimLeaId = priorLea.DimLeaID and priorLea.EffectiveDate > dates.DateValue
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
							and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[CharterSchoolAuthorizerIdPrimary]
							,[CharterSchoolAuthorizerIdSecondary]
							,[CharterSchoolStatus]
							,[MailingAddressCity]
							,[MailingAddressPostalCode]
							,[MailingAddressState]
							,[MailingAddressStreet]
							,[NSLPSTATUS]
							,[OperationalStatus]
							,[OperationalStatusId]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[ParentOrganizationStateId]
							,[ParentOrganizationNcesId]
							,[OutOfStateIndicator]
							,[PhysicalAddressCity]
							,[PhysicalAddressPostalCode]
							,[PhysicalAddressState]
							,[PhysicalAddressStreet]
							,[ReconstitutedStatus]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[SHAREDTIMESTATUS]
							,[SchoolType]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[TITLE1SCHOOLSTATUS]
							,[Telephone]
							,[TotalIndicator]
							,[VIRTUALSCHSTATUS]
							,[Website]
							,EffectiveDate
							,PriorLeaStateIdentifier
							,PriorSchoolStateIdentifier
							,UpdatedOperationalStatus
							,[UpdatedOperationalStatusId])
						select @categorySetCode,sch.CharterSchoolAuthorizerIdPrimary, sch.CharterSchoolAuthorizerIdSecondary,dirStatus.CharterSchoolStatusEdFactsCode,
							sch.MailingAddressCity, sch.MailingAddressPostalCode, sch.MailingAddressState, sch.MailingAddressStreet, 
							schStatus.NSLPStatusEdFactsCode ,dirStatus.OperationalStatusEdFactsCode,dirStatus.OperationalStatusId,
							1 as OrganizationCount,
							-- sch.DimSchoolId as OrganizationId, 
							sch.schoolOrganizationId as OrganizationId, 
							sch.SchoolName as OrganizationName ,sch.SchoolNcesIdentifier,sch.SchoolStateIdentifier,
							sch.LeaStateIdentifier,sch.LeaNcesIdentifier,
							sch.OutOfStateIndicator,sch.PhysicalAddressCity , sch.PhysicalAddressPostalCode, sch.PhysicalAddressState, sch.PhysicalAddressStreet, dirStatus.ReconstitutedStatusEdFactsCode,
							@reportCode, @reportLevel, @reportYear, schStatus.SharedTimeStatusEdFactsCode,sch.SchoolTypeEdFactsCode, sch.StateANSICode, sch.StateCode, sch.StateName,
							titleIStatus.Title1SchoolStatusEdFactsCode,sch.Telephone, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode, sch.Website,
							priorSch.EffectiveDate, priorSch.PriorLeaStateIdentifier, priorSch.PriorSchoolStateIdentifier, 
							dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						left outer join rds.DimSchools priorSch on fact.DimSchoolId = priorSch.DimSchoolId and priorSch.EffectiveDate > dates.DateValue
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
						left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
				end
				else if(@reportCode = 'c039')
				begin
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationStateId]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[TotalIndicator]
							,[GRADELEVEL]
							)
						select @categorySetCode,
							1 as OrganizationCount, 
							lea.LeaOrganizationId as OrganizationId,
							lea.LeaName as OrganizationName ,lea.LeaStateIdentifier,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, 0 as TotalIndicator, grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						left outer join rds.BridgeLeaGradeLevels bridgeGrades on fact.dimLeaId = bridgeGrades.DimLeaId
						left outer join rds.DimGradeLevels grades on grades.DimGradeLevelId = bridgeGrades.DimGradeLevelId
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
							and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationStateId]
							,[ParentOrganizationStateId]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[TotalIndicator]
							,[GRADELEVEL])
						select @categorySetCode,
							1 as OrganizationCount, sch.SchoolOrganizationId as OrganizationId, sch.SchoolName as OrganizationName ,
							sch.SchoolStateIdentifier, sch.LeaStateIdentifier,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateCode, sch.StateName, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						left outer join rds.BridgeSchoolGradeLevels bridgeGrades on fact.DimSchoolId = bridgeGrades.DimSchoolId
						left outer join rds.DimGradeLevels grades on grades.DimGradeLevelId = bridgeGrades.DimGradeLevelId
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
						left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
				end
				else if (@reportCode ='c129')
				BEGIN		
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[CharterSchoolAuthorizerIdPrimary]
						,[CharterSchoolAuthorizerIdSecondary]														
						,[NSLPSTATUS]	
						,[OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationNcesId]
						,[OrganizationStateId]							
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[SHAREDTIMESTATUS]								
						,[StateANSICode]
						,[StateCode]
						,[StateName]
						,[TITLE1SCHOOLSTATUS]							
						,[TotalIndicator]
						,[VIRTUALSCHSTATUS]
						,[MAGNETSTATUS]							
						)
					select @categorySetCode,
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						--sch.DimSchoolId as OrganizationId, 
						sch.schoolOrganizationId as OrganizationId,
						sch.SchoolName as OrganizationName ,
						sch.SchoolNcesIdentifier,
						sch.SchoolStateIdentifier,								
						@reportCode, 
						@reportLevel,
						@reportYear, 
						schStatus.SharedTimeStatusEdFactsCode, 
						sch.StateANSICode, 
						sch.StateCode,
						sch.StateName,
						titleIStatus.Title1SchoolStatusEdFactsCode, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode,
						MagnetStatusEdFactsCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId						
					left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
					left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId					
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				else if (@reportCode ='c130')
				BEGIN		
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[CharterSchoolAuthorizerIdPrimary]
						,[CharterSchoolAuthorizerIdSecondary]
						,[OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationNcesId]
						,[OrganizationStateId]								
						,[ParentOrganizationStateId]						
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]														
						,[StateANSICode]
						,[StateCode]
						,[StateName]													
						,[TotalIndicator]
						,PersistentlyDangerousStatus								
						,ImprovementStatus						
						)
					select @categorySetCode,
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						--schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						--sch.DimSchoolId as OrganizationId, 
						sch.schoolOrganizationId as OrganizationId,
						sch.SchoolName as OrganizationName ,
						sch.SchoolNcesIdentifier,
						sch.SchoolStateIdentifier,
						sch.[LeaStateIdentifier],														
						@reportCode, 
						@reportLevel,
						@reportYear, 
						-- schStatus.SharedTimeStatusEdFactsCode, 
						sch.StateANSICode, 
						sch.StateCode,
						sch.StateName,
						--titleIStatus.Title1SchoolStatusEdFactsCode,
						0 as TotalIndicator,
						--schStatus.VirtualSchoolStatusEdFactsCode,
						--	MagnetStatusEdFactsCode
						schStatus.PersistentlyDangerousStatusDescription+','+ schStatus.PersistentlyDangerousStatusCode,
						schStatus.ImprovementStatusDescription +','+ schStatus.ImprovementStatusCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId						
					left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId				
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				else if (@reportCode ='c193')
				BEGIN		
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[StateANSICode]
						,[StateCode]
						,[StateName]
						,[TotalIndicator]
						,TitleiParentalInvolveRes
						,TitleiPartaAllocations)
					select @categorySetCode,
						1 as OrganizationCount, 
						lea.LeaOrganizationId as OrganizationId,
						lea.LeaName as OrganizationName ,
						lea.LeaStateIdentifier,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateCode,
						lea.StateName, 0 as TotalIndicator, 
						TitleiParentalInvolveRes,
						TitleiPartaAllocations
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID						
					Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
						and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				else if(@reportCode='c198')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[StateCode]
						,[OrganizationStateId]
						,[StateANSICode]							
						,[StateName]	
						,[ReportCode]
						,[ReportYear]
						,[ReportLevel]
						,[CategorySetCode]
						,[ParentOrganizationStateId]
						,[CharterSchoolContractIdNumber]
						,[CharterContractApprovalDate]
						,[CharterContractRenewalDate])
					SELECT distinct 1 as OrganizationCount, 
						schools.SchoolOrganizationId, 
						schools.SchoolName as OrganizationName,									
							
						schools.StateCode, 
						schools.SchoolStateIdentifier, 
						schools.StateANSICode,
						schools.[StateName] as StateName,		

						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
								
						schools.LeaStateIdentifier, 
								
						schools.CharterSchoolContractIdNumber, 
						schools.CharterContractApprovalDate, 
						schools.CharterContractRenewalDate
					FROM rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimSchools schools on schools.DimSchoolId= fact.DimSchoolId
					inner join rds.DimCharterSchoolApproverAgency a on fact.DimCharterSchoolApproverAgencyId=a.DimCharterSchoolApproverAgencyId
					left join rds.DimCharterSchoolApproverAgency B on fact.DimCharterSchoolSecondaryApproverAgencyId=b.DimCharterSchoolApproverAgencyId
					WHERE dates.SubmissionYear = @reportYear and schools.CharterSchoolIndicator=1 and a.IsApproverAgency='Yes' 
						and ISNULL(schools.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE if(@reportCode='c197')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]	
						,[StateCode]
						,[OrganizationStateId]
						,[StateANSICode]							
						,[StateName]
						,[ReportCode]
						,[ReportYear]
						,[ReportLevel]
						,[CategorySetCode]
						,[ParentOrganizationStateId]
						,[ParentOrganizationNcesId]
						,[OrganizationNcesId]
						,[CharterSchoolManagerOrganization]
						,[CharterSchoolUpdatedManagerOrganization]
						)
					SELECT distinct 1 as OrganizationCount, 
						schools.SchoolOrganizationId, 
						schools.SchoolName as OrganizationName,									
						schools.StateCode, 
						schools.SchoolStateIdentifier, 
						schools.StateANSICode,
						schools.[StateName] as StateName,				
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaStateIdentifier, 
						schools.LeaNcesIdentifier, 
						schools.SchoolNcesIdentifier
						,a.StateIdentifier
						,b.StateIdentifier							 
					FROM rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimSchools schools on schools.DimSchoolId= fact.DimSchoolId
					inner join rds.DimCharterSchoolApproverAgency a on fact.DimCharterSchoolManagerOrganizationId=a.DimCharterSchoolApproverAgencyId
					left join rds.DimCharterSchoolApproverAgency b on DimCharterSchoolUpdatedManagerOrganizationId =b.DimCharterSchoolApproverAgencyId
					WHERE dates.SubmissionYear = @reportYear and schools.CharterSchoolIndicator=1 and a.IsApproverAgency='No' 
						and ISNULL(schools.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE IF(@reportCode='c196')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						(
						[OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[StateCode]
						,[StateANSICode]	
						,[StateName]
						,[CategorySetCode]
						,[ManagementOrganizationType]
						,[MailingAddressStreet]
						,[MailingAddressCity]
						,[MailingAddressState]
						,[MailingAddressPostalCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[PhysicalAddressStreet]
						,[PhysicalAddressCity]
						,[PhysicalAddressState]
						,[PhysicalAddressPostalCode])
					(SELECT distinct	1 as OrganizationCount, 
						lea.OrganizationId,
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.OrganizationType as ManagementOrganizationType,
						lea.MailingAddressStreet,
						lea.MailingAddressCity,								
						lea.MailingAddressState,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreet,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressState,
						lea.PhysicalAddressPostalCode
					FROM rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolUpdatedManagerOrganizationId = lea.DimCharterSchoolApproverAgencyId	
			    WHERE dates.SubmissionYear = @reportYear and lea.DimCharterSchoolApproverAgencyId <> -1 and lea.IsApproverAgency='NO'
				UNION
				SELECT distinct	1 as OrganizationCount, 
					lea.OrganizationId,
					lea.Name as OrganizationName,
					lea.StateIdentifier as LeaStateIdentifier,
					lea.StateCode,
					lea.StateANSICode,
					lea.[State] as StateName,
					@categorySetCode,
					lea.OrganizationType as ManagementOrganizationType,
					lea.MailingAddressStreet,
					lea.MailingAddressCity,								
					lea.MailingAddressState,
					lea.MailingAddressPostalCode,
					@reportCode,
					@reportLevel,
					@reportYear,
					lea.PhysicalAddressStreet,
					lea.PhysicalAddressCity,
					lea.PhysicalAddressState,
					lea.PhysicalAddressPostalCode
				FROM rds.FactOrganizationCounts fact
				inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
				inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolManagerOrganizationId = lea.DimCharterSchoolApproverAgencyId	
				WHERE dates.SubmissionYear = @reportYear and lea.DimCharterSchoolApproverAgencyId <> -1 and lea.IsApproverAgency='NO')
			END
				ELSE IF(@reportCode ='c190')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[StateCode]
						,[StateANSICode]
						,[StateName]							
						,[CategorySetCode]
						,[ManagementOrganizationType]
						,[MailingAddressStreet]
						,[MailingAddressCity]
						,[MailingAddressState]
						,[MailingAddressPostalCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[PhysicalAddressStreet]
						,[PhysicalAddressCity]
						,[PhysicalAddressState]
						,[PhysicalAddressPostalCode])
					(SELECT	1 as OrganizationCount, 
						lea.OrganizationId,
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,		 
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.OrganizationType as ManagementOrganizationType,
						lea.MailingAddressStreet,
						lea.MailingAddressCity,								
						lea.MailingAddressState,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreet,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressState,
						lea.PhysicalAddressPostalCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolApproverAgencyId = lea.DimCharterSchoolApproverAgencyId	
					Where dates.SubmissionYear = @reportYear and lea.DimCharterSchoolApproverAgencyId <> -1 AND lea.IsApproverAgency='YES'
					UNION 
					SELECT	1 as OrganizationCount, 
						lea.OrganizationId,
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,		 
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.OrganizationType as ManagementOrganizationType,
						lea.MailingAddressStreet,
						lea.MailingAddressCity,								
						lea.MailingAddressState,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreet,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressState,
						lea.PhysicalAddressPostalCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimCharterSchoolApproverAgency lea on 
						lea.DimCharterSchoolApproverAgencyId= fact.DimCharterSchoolSecondaryApproverAgencyId
					Where dates.SubmissionYear = @reportYear and lea.DimCharterSchoolApproverAgencyId <> -1 AND lea.IsApproverAgency='YES')
				END
				ELSE IF(@reportCode ='c103')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[ParentOrganizationStateId]
						,[StateANSICode]
						,[StateCode]
						,[StateName]							
						,[CategorySetCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[StatePovertyDesignation])
					SELECT	distinct 1 as OrganizationCount, 
						sch.SchoolOrganizationId,
						sch.SchoolName as OrganizationName,
						sch.SchoolStateIdentifier,	
						sch.LeaStateIdentifier as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateCode,
						sch.StateName as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						statuses.StatePovertyDesignationCode
					from rds.FactOrganizationCounts fact
					INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					INNER JOIN rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId	
					INNER JOIN RDS.DimSchoolStatuses statuses on fact.DimSchoolStatusId= statuses.DimSchoolStatusId 		
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1 
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE IF(@reportCode ='c132')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[ParentOrganizationStateId]
						,[StateANSICode]
						,[StateCode]
						,[StateName]							
						,[CategorySetCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[SCHOOLIMPROVEMENTFUNDS]
						,[EconomicallyDisadvantagedStudentCount]
						)
					SELECT distinct 1 as OrganizationCount, 
						sch.SchoolOrganizationId,
						sch.SchoolName as OrganizationName,
						sch.SchoolStateIdentifier,	
						sch.LeaStateIdentifier as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateCode,
						sch.StateName as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						[SCHOOLIMPROVEMENTFUNDS],
						isnull(ecodisStudentCount,0) as 'EconomicallyDisadvantagedStudentCount'								
					from rds.FactOrganizationCounts fact
					INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					INNER JOIN rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId	
					INNER JOIN RDS.DimSchoolStatuses statuses on fact.DimSchoolStatusId= statuses.DimSchoolStatusId 
					left join(	select 	DimCountDateId, DimSchoolId, sum(studentcount) as ecodisStudentCount
								from  RDS.FactStudentCounts factStd -- on dates.DimDateId = factStd.DimCountDateId and sch.DimSchoolId = factStd.DimSchoolId		
									inner join rds.DimDemographics demo on demo.DimDemographicId = factStd.DimDemographicId and demo.EcoDisStatusCode != 'MISSING'	
									where DimSchoolId <> -1
								group by DimCountDateId, DimSchoolId 
							)ecodisCount on ecodisCount.DimCountDateId = dates.DimDateId and sch.DimSchoolId = ecodisCount.DimSchoolId				
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE IF(@reportCode ='c170')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[LeaStateIdentifier]
						,[StateANSICode]
						,[StateCode]
						,[StateName]							
						,[CategorySetCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,McKinneyVentoSubgrantRecipient
						)
					SELECT distinct 1 as OrganizationCount,
						lea.LeaOrganizationId,								
						lea.LeaName as OrganizationName,
						lea.LeaStateIdentifier,	
						lea.LeaStateIdentifier as LeaStateIdentifier,										 
						lea.StateANSICode as StateANSICode,
						lea.StateCode,
						lea.StateName as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						case when statuses.McKinneyVentoSubgrantRecipientCode = 'MISSING' then 'MVSUBGNO'
							else statuses.McKinneyVentoSubgrantRecipientEdFactsCode end
					from rds.FactOrganizationCounts fact
					INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					INNER JOIN rds.DimLeas lea on fact.DimLeaId = 	lea.DimLeaID
					INNER JOIN RDS.DimDirectoryStatuses statuses on fact.DimDirectoryStatusId= statuses.DimDirectoryStatusId 						
					Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
						and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE IF(@reportCode ='c163')
				BEGIN
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationStateId]
							,[LeaStateIdentifier]
							,[StateANSICode]
							,[StateCode]
							,[StateName]							
							,[CategorySetCode]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,GunFreeStatus
							)
						SELECT distinct 1 as OrganizationCount,
							lea.LeaOrganizationId,								
							lea.LeaName as OrganizationName,
							lea.LeaStateIdentifier,	
							lea.LeaStateIdentifier as LeaStateIdentifier,										 
							lea.StateANSICode as StateANSICode,
							lea.StateCode,
							lea.StateName as StateName,
							@categorySetCode,	
							@reportCode,
							@reportLevel,
							@reportYear,
							statuses.GunFreeStatusCode
						from rds.FactOrganizationCounts fact
						INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						INNER JOIN rds.DimLeas lea on fact.DimLeaId = 	lea.DimLeaID
						LEFT OUTER JOIN RDS.DimOrganizationStatus statuses on fact.DimOrganizationStatusId= statuses.DimOrganizationStatusId 						
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
						and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationStateId]
							,[ParentOrganizationStateId]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[TotalIndicator]
							,GunFreeStatus)
						select @categorySetCode,
							1 as OrganizationCount, sch.SchoolOrganizationId as OrganizationId, sch.SchoolName as OrganizationName ,
							sch.SchoolStateIdentifier, sch.LeaStateIdentifier,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateCode, sch.StateName, 0 as TotalIndicator, 
							statuses.GunFreeStatusCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						LEFT OUTER JOIN RDS.DimOrganizationStatus statuses on fact.DimOrganizationStatusId= statuses.DimOrganizationStatusId 
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
							and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
				END
				ELSE IF(@reportCode ='c205')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[LeaStateIdentifier]
						,[StateANSICode]
						,[StateCode]
						,[StateName]							
						,[CategorySetCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[ProgressAchievingEnglishLanguage]
						,[TableTypeAbbrv]
						,[StateDefinedStatus]
						)
					SELECT distinct 1 as OrganizationCount, 
						sch.SchoolOrganizationId,
						sch.SchoolName as OrganizationName,
						sch.SchoolStateIdentifier,	
						sch.LeaStateIdentifier as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateCode,
						sch.StateName as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						statuses.ProgressAchievingEnglishLanguageCode as 'ProgressAchievingEnglishLanguage',
						@tableTypeAbbrv,
						case when statuses.ProgressAchievingEnglishLanguageCode = 'STTDEF' then dss.SchoolStateStatusCode 
							else null end as StateDefinedStatus
					from rds.FactOrganizationCounts fact
					INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					INNER JOIN rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId	
					INNER JOIN RDS.DimSchoolStatuses statuses on fact.DimSchoolStatusId= statuses.DimSchoolStatusId
					inner join rds.DimSchoolStateStatus dss on dss.DimSchoolStateStatusId= fact.DimSchoolStateStatusId
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1 AND statuses.ProgressAchievingEnglishLanguageCode<>'Missing'
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				ELSE IF(@reportCode ='c206')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[LeaStateIdentifier]
						,[StateANSICode]
						,[StateCode]
						,[StateName]							
						,[CategorySetCode]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[FederalFundAllocated],
						ComprehensiveAndTargetedSupportCode,
						ComprehensiveSupportCode,
						TargetedSupportCode
						)
					SELECT distinct 1 as OrganizationCount, 
						sch.SchoolOrganizationId,
						sch.SchoolName as OrganizationName,
						sch.SchoolStateIdentifier,	
						sch.LeaStateIdentifier as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateCode,
						sch.StateName as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
						statuses.ComprehensiveAndTargetedSupportCode,
						statuses.ComprehensiveSupportCode,
						statuses.TargetedSupportCode
					from rds.FactOrganizationCounts fact
					INNER JOIN rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					INNER JOIN rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId	
					INNER JOIN RDS.DimComprehensiveAndTargetedSupports statuses on fact.DimComprehensiveAndTargetedSupportId= statuses.DimComprehensiveAndTargetedSupportId
					inner join rds.DimSchoolStateStatus dss on dss.DimSchoolStateStatusId= fact.DimSchoolStateStatusId
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1 
					--AND (statuses.TargetedSupportCode <>'Missing' or statuses.ComprehensiveSupportCode <>'Missing' or statuses.ComprehensiveAndTargetedSupportCode <>'Missing')
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				else if (@reportCode ='c131')
				BEGIN	
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[OrganizationCount]
						,[OrganizationId]
						,[OrganizationName]
						,[OrganizationStateId]
						,[ReportCode]
						,[ReportLevel]
						,[ReportYear]
						,[StateANSICode]
						,[StateCode]
						,[StateName]
						,[TotalIndicator]
						,TitleiParentalInvolveRes
						,TitleiPartaAllocations
						,REAPAlternativeFundingStatus)
					select DISTINCT @categorySetCode, 	
						1 as OrganizationCount, 
						lea.LeaOrganizationId as OrganizationId,
						lea.LeaName as OrganizationName ,
						lea.LeaStateIdentifier,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateCode,
						lea.StateName, 
						0 as TotalIndicator, 
						TitleiParentalInvolveRes,
						TitleiPartaAllocations,
						REAPAlternativeFundingStatusCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID	
					INNER JOIN RDS.DimOrganizationStatus organizationStatus on organizationStatus.DimOrganizationStatusId=fact.DimOrganizationStatusId	
					Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
					and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
				END
				if(@reportCode = 'c035')
				begin
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[TableTypeAbbrv]
							,[TotalIndicator]
							,[FederalProgramCode]
							,[FederalFundAllocated])
						select distinct @categorySetCode,	1 as OrganizationCount, lea.leaOrganizationId as OrganizationId,
							lea.LeaName as OrganizationName , lea.LeaNcesIdentifier, lea.LeaStateIdentifier,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName,@tableTypeAbbrv,
							0 as TotalIndicator, fact.FederalProgramCode, fact.FederalFundAllocated
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						inner join rds.DimFactTypes facttype on facttype.DimFactTypeID= fact.DimFactTypeId
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1 and facttype.FactTypeCode='directory'
					end	
					else if(@reportLevel = 'sea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationName]
							,[OrganizationId]
							,[StateANSICode]
							,[StateName]
							,[StateCode]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]	
							,[TableTypeAbbrv]								
							,[TotalIndicator]
							,[FederalProgramCode]
							,[FederalFundAllocationType]
							,[FederalFundAllocated])
						select distinct @categorySetCode,1 as OrganizationCount,
							OrganizationName , SeaStateIdentifier, StateANSICode, StateName, StateCode,
							@reportCode, @reportLevel, @reportYear,@tableTypeAbbrv, 0 as TotalIndicator, 
							FederalProgramCode, FederalFundAllocationType, Sum(FederalFundAllocated)
						from (select distinct 1 as OrganizationCount,
							lea.SeaName as OrganizationName , lea.SeaStateIdentifier, lea.StateANSICode, lea.StateName, lea.StateCode,
							0 as TotalIndicator, fact.FederalProgramCode, fact.FederalFundAllocationType, fact.FederalFundAllocated
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1 )as a 
						group by OrganizationCount, OrganizationName,
							StateCode, FederalProgramCode, FederalFundAllocationType, SeaStateIdentifier, StateANSICode, StateName
					end						
				end
			end			-- @runAsTest = 0
			else
			begin
				if(@reportCode = 'c029')
				begin
					if(@reportLevel = 'sea')
					begin
						select p.Email,p.FirstName,p.LastName,p.Telephone,p.Title, @categorySetCode,
								sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.MailingAddressState, sea.MailingAddressStreet,
								1 as OrganizationCount, sea.DimSeaId as OrganizationId, sea.SeaName as OrganizationName ,
								sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressState, sea.PhysicalAddressStreet,
								@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateCode, sea.StateName, sea.Telephone, 0 as TotalIndicator, sea.Website
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSeas sea on fact.DimSeaId = sea.DimSeaId
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and sea.DimSeaId <> -1
					end
					else if(@reportLevel = 'lea')
					begin

						select @categorySetCode,dirStatus.CharterLeaStatusEdFactsCode,lea.LeaTypeEdFactsCode,
							lea.MailingAddressCity, lea.MailingAddressPostalCode, lea.MailingAddressState, lea.MailingAddressStreet,dirStatus.OperationalStatusEdFactsCode,
							1 as OrganizationCount, lea.DimLeaID as OrganizationId, lea.LeaName as OrganizationName ,lea.LeaNcesIdentifier,lea.LeaStateIdentifier,
							lea.OutOfStateIndicator,lea.PhysicalAddressCity , lea.PhysicalAddressPostalCode, lea.PhysicalAddressState, lea.PhysicalAddressStreet,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, lea.SupervisoryUnionIdentificationNumber,
							lea.Telephone, 0 as TotalIndicator, lea.Website, lea.EffectiveDate, lea.PriorLeaStateIdentifier, dirStatus.UpdatedOperationalStatusEdFactsCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
					left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
					left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
					Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
					and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					end
					else if(@reportLevel = 'sch')
					begin

							select @categorySetCode,sch.CharterSchoolAuthorizerIdPrimary, sch.CharterSchoolAuthorizerIdSecondary,dirStatus.CharterSchoolStatusEdFactsCode,
								sch.MailingAddressCity, sch.MailingAddressPostalCode, sch.MailingAddressState, sch.MailingAddressStreet, 
								schStatus.NSLPStatusEdFactsCode ,dirStatus.OperationalStatusEdFactsCode,dirStatus.OperationalStatusId,
								1 as OrganizationCount, sch.DimSchoolId as OrganizationId, sch.SchoolName as OrganizationName ,sch.SchoolNcesIdentifier,sch.SchoolStateIdentifier,
								sch.LeaStateIdentifier,sch.LeaNcesIdentifier,
								sch.OutOfStateIndicator,sch.PhysicalAddressCity , sch.PhysicalAddressPostalCode, sch.PhysicalAddressState, sch.PhysicalAddressStreet, dirStatus.ReconstitutedStatusEdFactsCode,
								@reportCode, @reportLevel, @reportYear, schStatus.SharedTimeStatusEdFactsCode,sch.SchoolTypeEdFactsCode, sch.StateANSICode, sch.StateCode, sch.StateName,
								titleIStatus.Title1SchoolStatusEdFactsCode,sch.Telephone, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode, sch.Website,
								priorSch.EffectiveDate, priorSch.PriorLeaStateIdentifier, priorSch.PriorSchoolStateIdentifier, 
								dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						left outer join rds.DimSchools priorSch on fact.DimSchoolId = priorSch.DimSchoolId and priorSch.EffectiveDate > dates.DateValue
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
						left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
						end
				end
				else if(@reportCode = 'c039')
				begin
						if(@reportLevel = 'lea')
						begin


							select @categorySetCode,
									1 as OrganizationCount, lea.DimLeaID as OrganizationId, lea.LeaName as OrganizationName ,lea.LeaStateIdentifier,
									@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, 0 as TotalIndicator, grades.GradeLevelEdFactsCode
							from rds.FactOrganizationCounts fact
							inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
							inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
							left outer join rds.BridgeLeaGradeLevels bridgeGrades on fact.dimLeaId = bridgeGrades.DimLeaId
							left outer join rds.DimGradeLevels grades on grades.DimGradeLevelId = bridgeGrades.DimGradeLevelId
							left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
							left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
							where ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
						end
						else if(@reportLevel = 'sch')
						begin

							select @categorySetCode,
									1 as OrganizationCount, sch.DimSchoolId as OrganizationId, sch.SchoolName as OrganizationName ,sch.SchoolStateIdentifier, sch.LeaStateIdentifier,
									@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateCode, sch.StateName, 0 as TotalIndicator, grades.GradeLevelEdFactsCode
							from rds.FactOrganizationCounts fact
							inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
							inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
							inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
							left outer join rds.BridgeSchoolGradeLevels bridgeGrades on fact.DimSchoolId = bridgeGrades.DimSchoolId
							left outer join rds.DimGradeLevels grades on grades.DimGradeLevelId = bridgeGrades.DimGradeLevelId
							left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
							left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
							left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId
							left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
							where ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
						end
					else if (@reportCode ='c129')
					BEGIN	
						select @categorySetCode,
								sch.CharterSchoolAuthorizerIdPrimary,
								sch.CharterSchoolAuthorizerIdSecondary,								
								schStatus.NSLPStatusEdFactsCode,
								1 as OrganizationCount, 
								sch.DimSchoolId as OrganizationId, 
								sch.SchoolName as OrganizationName ,
								sch.SchoolNcesIdentifier,
								sch.SchoolStateIdentifier,								
								@reportCode, 
								@reportLevel,
								 @reportYear, 
								 schStatus.SharedTimeStatusEdFactsCode, 
								 sch.StateANSICode, 
								 sch.StateCode,
								 sch.StateName,
								titleIStatus.Title1SchoolStatusEdFactsCode, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode
								,MagnetStatusEdFactsCode
								from rds.FactOrganizationCounts fact
								inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
								inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId						
								left outer join rds.DimSchoolStatuses schStatus on fact.DimSchoolStatusId = schStatus.DimSchoolStatusId
								left outer join rds.DimTitle1Statuses titleIStatus on fact.DimTitle1StatusId = titleIStatus.DimTitle1StatusId
								left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
								Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
								and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
					END
				
			end
			set @categorySetCntr = @categorySetCntr + 1
			END			-- @runAsTest = 1	
			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode
		END			-- categoryset_cursor
		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	END			-- submissionYear_cursor
	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor
	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1)
	begin
		update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1
	end
	SET NOCOUNT OFF;
END