
CREATE PROCEDURE [RDS].[Create_OrganizationReportData]
	@reportCode as varchar(50),
	@runAsTest as bit
AS

BEGIN

	SET NOCOUNT ON;

	-- Get GenerateReportTypeCode

	declare @generateReportTypeCode as varchar(50)
	select @generateReportTypeCode = t.ReportTypeCode
	from app.GenerateReports r
	inner join app.GenerateReportTypes t on r.GenerateReportTypeId = t.GenerateReportTypeId
	where r.ReportCode = @reportCode

	-- Get DataMigrationId and DimFactTypeId

	declare @dataMigrationTypeId as int
	declare @dimFactTypeId as int
	if @generateReportTypeCode = 'datapopulation'
	begin
		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'datapopulation'
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'
	end
	else 
	begin
		select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'submission'
		select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'
	end
	
	-- Get Fact/Report Tables/Fields

	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode


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
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
	inner join app.GenerateReports r on r.GenerateReportId=cs.GenerateReportId and r.ReportCode=@reportCode
	 Where cs.GenerateReportId in (select GenerateReportId from app.GenerateReports where ReportCode <> 'cohortgraduationrate') and r.IsLocked=1


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
								dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet,
								1 as OrganizationCount, 
								--sea.DimSeaId as OrganizationId,
								sea.seaOrganizationId as OrganizationId,
								 sea.SeaName as OrganizationName ,
								dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet,
								@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateCode, sea.StateName, dir.Telephone, 0 as TotalIndicator, dir.Website
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSeas sea on fact.DimSeaId = sea.DimSeaId
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
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
						select @categorySetCode,dirStatus.CharterLeaStatusEdFactsCode,dir.LeaTypeEdFactsCode,
								dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet,
								dirStatus.OperationalStatusEdFactsCode, dirStatus.OperationalStatusId,
								1 as OrganizationCount, 
								lea.LeaOrganizationId as OrganizationId,
								 lea.LeaName as OrganizationName ,lea.LeaNcesIdentifier,lea.LeaStateIdentifier,
								dir.OutOfStateIndicator,dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet,
								@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, lea.SupervisoryUnionIdentificationNumber,
								dir.Telephone, 0 as TotalIndicator, dir.Website, priorLea.EffectiveDate, priorLea.PriorLeaStateIdentifier, 
								dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
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
								dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet, 
								schStatus.NSLPStatusEdFactsCode ,dirStatus.OperationalStatusEdFactsCode,dirStatus.OperationalStatusId,
								1 as OrganizationCount,
								-- sch.DimSchoolId as OrganizationId, 
								 sch.schoolOrganizationId as OrganizationId, 
								 sch.SchoolName as OrganizationName ,sch.SchoolNcesIdentifier,sch.SchoolStateIdentifier,
								sch.LeaStateIdentifier,sch.LeaNcesIdentifier,
								dir.OutOfStateIndicator,dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet, dirStatus.ReconstitutedStatusEdFactsCode,
								@reportCode, @reportLevel, @reportYear, schStatus.SharedTimeStatusEdFactsCode,dir.SchoolTypeEdFactsCode, sch.StateANSICode, sch.StateCode, sch.StateName,
								titleIStatus.Title1SchoolStatusEdFactsCode,dir.Telephone, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode, dir.Website,
								priorSch.EffectiveDate, priorSch.PriorLeaStateIdentifier, priorSch.PriorSchoolStateIdentifier, 
								dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
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
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
						left outer join rds.BridgeDirectoryGradeLevels bridgeGrades on fact.DimDirectoryId = bridgeGrades.DimDirectoryId
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
								1 as OrganizationCount, sch.SchoolOrganizationId as OrganizationId, sch.SchoolName as OrganizationName ,sch.SchoolStateIdentifier, sch.LeaStateIdentifier,
								@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateCode, sch.StateName, 0 as TotalIndicator, grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
						left outer join rds.BridgeDirectoryGradeLevels bridgeGrades on fact.DimDirectoryId = bridgeGrades.DimDirectoryId
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
			--------------------
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

								dir.MailingAddressStreet,
								dir.MailingAddressCity,								
								dir.MailingAddressState,
								dir.MailingAddressPostalCode,
							
								@reportCode,
								@reportLevel,
								@reportYear,

								dir.PhysicalAddressStreet,
								dir.PhysicalAddressCity,
								dir.PhysicalAddressState,
								dir.PhysicalAddressPostalCode
									FROM rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolUpdatedManagerOrganizationId = lea.DimCharterSchoolApproverAgencyId	
						inner join rds.DimDirectories dir on fact.DimCharterSchoolUpdatedManagerDirectoryId = dir.DimDirectoryId 				
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

								dir.MailingAddressStreet,
								dir.MailingAddressCity,								
								dir.MailingAddressState,
								dir.MailingAddressPostalCode,
							
								@reportCode,
								@reportLevel,
								@reportYear,

								dir.PhysicalAddressStreet,
								dir.PhysicalAddressCity,
								dir.PhysicalAddressState,
								dir.PhysicalAddressPostalCode
				FROM rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolManagerOrganizationId = lea.DimCharterSchoolApproverAgencyId	
						inner join rds.DimDirectories dir on fact.DimCharterSchooleManagerDirectoryId = dir.DimDirectoryId 	 				
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

								dir.MailingAddressStreet,
								dir.MailingAddressCity,								
								dir.MailingAddressState,
								dir.MailingAddressPostalCode,

								@reportCode,
								@reportLevel,
								@reportYear,

								dir.PhysicalAddressStreet,
								dir.PhysicalAddressCity,
								dir.PhysicalAddressState,
								dir.PhysicalAddressPostalCode
								
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimCharterSchoolApproverAgency lea on fact.DimCharterSchoolApproverAgencyId = lea.DimCharterSchoolApproverAgencyId	
						inner join rds.DimDirectories dir on fact.DimCharterSchoolPrimaryApproverAgencyDirectoryId = dir.DimDirectoryId 		
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

								dir.MailingAddressStreet,
								dir.MailingAddressCity,								
								dir.MailingAddressState,
								dir.MailingAddressPostalCode,

								@reportCode,
								@reportLevel,
								@reportYear,

								dir.PhysicalAddressStreet,
								dir.PhysicalAddressCity,
								dir.PhysicalAddressState,
								dir.PhysicalAddressPostalCode
								
							from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimCharterSchoolApproverAgency lea on 
									 lea.DimCharterSchoolApproverAgencyId= fact.DimCharterSchoolSecondaryApproverAgencyId
						inner join rds.DimDirectories dir on fact.DimCharterSchoolSecondaryApproverAgencyDirectoryId =dir.DimDirectoryId			
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

			SELECT distinct 	1 as OrganizationCount, 
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

			SELECT distinct 	1 as OrganizationCount,
			
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

			SELECT distinct 	1 as OrganizationCount,
			
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
								1 as OrganizationCount, sch.SchoolOrganizationId as OrganizationId, sch.SchoolName as OrganizationName ,sch.SchoolStateIdentifier, sch.LeaStateIdentifier,
								@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateCode, sch.StateName, 0 as TotalIndicator, statuses.GunFreeStatusCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
						LEFT OUTER JOIN RDS.DimOrganizationStatus statuses on fact.DimOrganizationStatusId= statuses.DimOrganizationStatusId 
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1
						and ISNULL(sch.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0

			end

			
		END



		ELSE IF(@reportCode ='c205')
		BEGIN
		declare @tableTypeAbbrv as nvarchar(50)
		select @tableTypeAbbrv=ReportTypeAbbreviation from app.GenerateReports where ReportCode=@reportCode
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

			SELECT distinct 	1 as OrganizationCount, 
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

		----------------------------


			end
			else
			begin

				if(@reportCode = 'c029')
				begin

						if(@reportLevel = 'sea')
						begin
							select p.Email,p.FirstName,p.LastName,p.Telephone,p.Title, @categorySetCode,
									dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet,
									1 as OrganizationCount, sea.DimSeaId as OrganizationId, sea.SeaName as OrganizationName ,
									dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet,
									@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateCode, sea.StateName, dir.Telephone, 0 as TotalIndicator, dir.Website
							from rds.FactOrganizationCounts fact
							inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
							inner join rds.DimSeas sea on fact.DimSeaId = sea.DimSeaId
							inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
							left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
							Where dates.SubmissionYear = @reportYear and sea.DimSeaId <> -1
						end
						else if(@reportLevel = 'lea')
						begin

							select @categorySetCode,dirStatus.CharterLeaStatusEdFactsCode,dir.LeaTypeEdFactsCode,
								dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet,dirStatus.OperationalStatusEdFactsCode,
								1 as OrganizationCount, lea.DimLeaID as OrganizationId, lea.LeaName as OrganizationName ,lea.LeaNcesIdentifier,lea.LeaStateIdentifier,
								dir.OutOfStateIndicator,dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet,
								@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateCode, lea.StateName, lea.SupervisoryUnionIdentificationNumber,
								dir.Telephone, 0 as TotalIndicator, dir.Website, lea.EffectiveDate, lea.PriorLeaStateIdentifier, dirStatus.UpdatedOperationalStatusEdFactsCode
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimLeas lea on fact.DimLeaId = lea.DimLeaID
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
						left outer join rds.DimDirectoryStatuses dirStatus on dirStatus.DimDirectoryStatusId = fact.DimDirectoryStatusID
						left outer join rds.DimPersonnel p on fact.DimPersonnelId = p.DimPersonnelId
						Where dates.SubmissionYear = @reportYear and lea.DimLeaID <> -1
						and ISNULL(lea.ReportedFederally, 1) = 1 -- CIID-1963 Exclude [ReportedFederally] = 0
						end
						else if(@reportLevel = 'sch')
						begin

							select @categorySetCode,sch.CharterSchoolAuthorizerIdPrimary, sch.CharterSchoolAuthorizerIdSecondary,dirStatus.CharterSchoolStatusEdFactsCode,
								dir.MailingAddressCity, dir.MailingAddressPostalCode, dir.MailingAddressState, dir.MailingAddressStreet, 
								schStatus.NSLPStatusEdFactsCode ,dirStatus.OperationalStatusEdFactsCode,dirStatus.OperationalStatusId,
								1 as OrganizationCount, sch.DimSchoolId as OrganizationId, sch.SchoolName as OrganizationName ,sch.SchoolNcesIdentifier,sch.SchoolStateIdentifier,
								sch.LeaStateIdentifier,sch.LeaNcesIdentifier,
								dir.OutOfStateIndicator,dir.PhysicalAddressCity , dir.PhysicalAddressPostalCode, dir.PhysicalAddressState, dir.PhysicalAddressStreet, dirStatus.ReconstitutedStatusEdFactsCode,
								@reportCode, @reportLevel, @reportYear, schStatus.SharedTimeStatusEdFactsCode,dir.SchoolTypeEdFactsCode, sch.StateANSICode, sch.StateCode, sch.StateName,
								titleIStatus.Title1SchoolStatusEdFactsCode,dir.Telephone, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode, dir.Website,
								priorSch.EffectiveDate, priorSch.PriorLeaStateIdentifier, priorSch.PriorSchoolStateIdentifier, 
								dirStatus.UpdatedOperationalStatusEdFactsCode, dirStatus.UpdatedOperationalStatusId
						from rds.FactOrganizationCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
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
							inner join rds.DimDirectories dir on fact.DimDirectoryId = dir.DimDirectoryId
							left outer join rds.BridgeDirectoryGradeLevels bridgeGrades on fact.DimDirectoryId = bridgeGrades.DimDirectoryId
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
							left outer join rds.BridgeDirectoryGradeLevels bridgeGrades on fact.DimDirectoryId = bridgeGrades.DimDirectoryId
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

		END

			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode
		END

		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear
	END

	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor

	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1)
	begin
			 update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode
	end

	SET NOCOUNT OFF;

END