CREATE procedure [RDS].[Create_OrganizationReportData]
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

	create table #minmaxLeas (
	  	  Identifier varchar(50)
		, MinDate datetime
		, MaxDate datetime
		)

	create table #minmaxSchools (
		  Identifier varchar(50)
		, MinDate datetime
		, MaxDate datetime
	)
	
	select @tableTypeAbbrv=ReportTypeAbbreviation from app.GenerateReports where ReportCode=@reportCode

	-- Loop through all submission years
	---------------------------------------------
	declare @submissionYears as table(
		  SubmissionYear varchar(50)
		, SubmissionYearStartDate datetime
		, SubmissionYearEndDate datetime
	)
	insert into @submissionYears
		(
			  SubmissionYear
			, SubmissionYearStartDate
			, SubmissionYearEndDate
		)
	select distinct 
		  cs.SubmissionYear
		, CONVERT(DATETIME, '7/1/' + CAST(d.SchoolYear - 1 AS VARCHAR(4)))
		, CONVERT(DATETIME, '6/30/' + CAST(d.SchoolYear AS VARCHAR(4)))
	from app.CategorySets cs
	inner join rds.DimSchoolYears d on d.SchoolYear = cs.SubmissionYear
	inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId and dd.IsSelected=1 
	and dd.DataMigrationTypeId=@dataMigrationTypeId
	inner join app.GenerateReports r on r.GenerateReportId=cs.GenerateReportId and r.ReportCode=@reportCode
	Where r.IsLocked=1

	declare @reportYear as varchar(50), @submissionYearStartDate as datetime, @submissionYearEndDate as datetime
	
	DECLARE submissionYear_cursor CURSOR FOR 
	SELECT    SubmissionYear
			, SubmissionYearStartDate
			, SubmissionYearEndDate
	FROM @submissionYears
	order by SubmissionYear desc

	OPEN submissionYear_cursor
	FETCH NEXT FROM submissionYear_cursor INTO @reportYear, @submissionYearStartDate, @submissionYearEndDate
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
			inner join app.GenerateReports r 
				on cs.GenerateReportId = r.GenerateReportId
			inner join app.OrganizationLevels o 
				on cs.OrganizationLevelId = o.OrganizationLevelId
		where r.ReportCode = @reportCode 
		and cs.SubmissionYear = @reportYear

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

					declare @effectiveDate varchar(10)
					select @effectiveDate = CONVERT(DATETIME2, ResponseValue)
					from app.ToggleResponses tr
					join app.ToggleQuestions tq 
						on tr.ToggleQuestionId = tq.ToggleQuestionId
					where tq.EmapsQuestionAbbrv = 'EFFECTIVEDTE'

					if(@reportLevel = 'sea')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
							([CSSOEmail]
							,[CSSOFirstName]
							,[CSSOLastOrSurname]
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
							,[Website]
							,[TitleiParentalInvolveRes]
							,[TitleiPartaAllocations])
						select distinct
						p.ElectronicMailAddressOrganizational,p.FirstName,p.LastOrSurname,p.TelephoneNumberWork,p.PositionTitle, @categorySetCode,
							sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.StateAbbreviationCode, sea.MailingAddressStreetNumberAndName,
							1 as OrganizationCount, 
							sea.DimSeaId,
							sea.SeaOrganizationName as OrganizationName ,
							sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressStateAbbreviation, sea.PhysicalAddressStreetNumberAndName,
							@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateAbbreviationCode, sea.StateAbbreviationDescription, 
							sea.TelephoneNumber, 0 as TotalIndicator, sea.WebSiteAddress, -1 , -1
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears dates 
								on fact.SchoolYearId = dates.DimSchoolYearId
							inner join rds.DimSeas sea 
								on fact.SeaId = sea.DimSeaId
							left outer join rds.DimPeople p 
								on fact.K12StaffId = p.DimPersonId
						where dates.SchoolYear = @reportYear 
						and sea.DimSeaId <> -1
					end
					else if(@reportLevel = 'lea')
					begin
						insert into #minmaxLeas
						(
							  Identifier
							, MinDate
							, MaxDate
						)
						select 
							  LeaIdentifierSea
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimLeas lea
							on fact.LeaId = lea.DimLeaId
						inner join rds.DimSchoolYears d 
								on fact.SchoolYearId = d.DimSchoolYearId
						where d.SchoolYear = @reportYear 
						GROUP BY lea.LeaIdentifierSea


						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
							,lea.PriorLeaStateIdentifier
							,UpdatedOperationalStatus
							,[UpdatedOperationalStatusId]
							,[TitleiParentalInvolveRes]
							,[TitleiPartaAllocations])
						select 
							  @categorySetCode
							, latestLea.CharterLeaStatus as CharterLeaStatusEdFactsCode
							, latestLea.LeaTypeEdFactsCode
							, latestLea.MailingAddressCity
							, latestLea.MailingAddressPostalCode
							, latestLea.MailingAddressStateAbbreviation
							, latestLea.MailingAddressStreetNumberAndName
							, syLea.LeaOperationalStatusEdFactsCode
							, syLea.LeaOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestLea.DimLeaID
							, latestLea.LeaOrganizationName as OrganizationName
							, latestLea.LeaIdentifierNces
							, latestLea.LeaIdentifierSea
							, latestLea.OutOfStateIndicator
							, latestLea.PhysicalAddressCity 
							, latestLea.PhysicalAddressPostalCode
							, latestLea.PhysicalAddressStateAbbreviation
							, latestLea.PhysicalAddressStreetNumberAndName
							, @reportCode
							, @reportLevel
							, @reportYear
							, latestLea.StateANSICode
							, latestLea.StateAbbreviationCode as StateCode
							, latestLea.StateAbbreviationDescription as StateName
							, latestLea.LeaSupervisoryUnionIdentificationNumber
							, latestLea.TelephoneNumber
							, 0 as TotalIndicator
							, latestLea.WebSiteAddress
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN latestLea.OperationalStatusEffectiveDate
								else @effectiveDate
							 end as OperationalStatusEffectiveDate
							, latestLea.PriorLeaIdentifierSea
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								else null
							 end as UpdatedOperationalStatusEdFactsCode
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								else null
							 end as UpdatedOperationalStatusId, 
							 -1, -1
						from #minmaxLeas mmlea						
						join rds.DimLeas syLea
							on mmlea.Identifier = syLea.LeaIdentifierSea
							and mmlea.MinDate = syLea.RecordStartDateTime
						join rds.DimLeas latestLea
							on mmlea.Identifier = latestLea.LeaIdentifierSea	
							and mmlea.MaxDate = latestLea.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestLea.DimLeaId = fact.LeaId
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						where latestLea.DimLeaID <> -1	
						and ISNULL(latestLea.ReportedFederally, 1) = 1 
						and latestLea.LeaOperationalStatus <> 'MISSING'

					end
					else if(@reportLevel = 'sch')
					begin

						insert into #minmaxSchools
						(
							  Identifier
							, MinDate
							, MaxDate
						)
						select 
							  SchoolIdentifierSea
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimK12Schools school
							on fact.K12SchoolId = school.DimK12SchoolId
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						where d.SchoolYear = @reportYear 
						GROUP BY school.SchoolIdentifierSea

						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
							([CategorySetCode]
							,[CharterSchoolAuthorizerIdPrimary]
							,[CharterSchoolAuthorizerIdSecondary]
							,[CharterSchoolStatus]
							,[CharterSchoolIndicator]
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
							,[UpdatedOperationalStatusId]
							,[TitleiParentalInvolveRes]
							,[TitleiPartaAllocations])
						select 
							  @categorySetCode
							, isnull(primaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, '')
							, ISNULL(secondaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, '')
							, latestSchool.CharterSchoolStatus as CharterSchoolStatusEdFactsCode
							, latestSchool.CharterSchoolIndicator
							, latestSchool.MailingAddressCity
							, latestSchool.MailingAddressPostalCode
							, latestSchool.MailingAddressStateAbbreviation
							, latestSchool.MailingAddressStreetNumberAndName
							, schStatus.NSLPStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestSchool.DimK12SchoolId
							, latestSchool.NameOfInstitution as OrganizationName 
							, latestSchool.SchoolIdentifierNces
							, latestSchool.SchoolIdentifierSea
							, latestSchool.LeaIdentifierSea
							, latestSchool.LeaIdentifierNces
							, latestSchool.OutOfStateIndicator
							, latestSchool.PhysicalAddressCity 
							, latestSchool.PhysicalAddressPostalCode
							, latestSchool.PhysicalAddressStateAbbreviation
							, latestSchool.PhysicalAddressStreetNumberAndName
							, latestSchool.ReconstitutedStatus
							, @reportCode
							, @reportLevel
							, @reportYear
							, schStatus.SharedTimeIndicatorEdFactsCode
							, latestSchool.SchoolTypeEdFactsCode
							, latestSchool.StateANSICode
							, latestSchool.StateAbbreviationCode
							, latestSchool.StateAbbreviationDescription
							, titleIStatus.TitleISchoolStatusEdFactsCode
							, latestSchool.TelephoneNumber
							, 0 as TotalIndicator
							, schStatus.VirtualSchoolStatusEdFactsCode
							, latestSchool.WebSiteAddress
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN latestSchool.SchoolOperationalStatusEffectiveDate
								
							  end as OperationalStatusEffectiveDate
							, latestSchool.PriorLeaIdentifierSea
							, latestSchool.PriorSchoolIdentifierSea
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN ISNULL(latestSchool.SchoolOperationalStatusEdFactsCode, '')
								ELSE NULL
							  end as UpdatedOperationalStatusEdFactsCode
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN ISNULL(latestSchool.SchoolOperationalStatusEdFactsCode, '')
								ELSE NULL
							  end as UpdatedOperationalStatusId,
							  -1, -1
						from #minmaxSchools mmSchool						
						join rds.DimK12Schools sySchool
							on mmSchool.Identifier = sySchool.SchoolIdentifierSea
							and mmSchool.MinDate = sySchool.RecordStartDateTime
						join rds.DimK12Schools latestSchool
							on mmSchool.Identifier = latestSchool.SchoolIdentifierSea	
							and mmSchool.MaxDate = latestSchool.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestSchool.DimK12SchoolId = fact.K12SchoolId
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.K12SchoolStatusId = schStatus.DimK12SchoolStatusId
						left outer join rds.DimTitleIStatuses titleIStatus 
							on fact.TitleIStatusId = titleIStatus.DimTitleIStatusId
						where d.SchoolYear = @reportYear 
						and latestSchool.DimK12SchoolId <> -1 
						and ISNULL(latestSchool.ReportedFederally, 1) = 1
						and latestSchool.SchoolOperationalStatus <> 'MISSING'
						
					end
				end
				else if(@reportCode = 'c039')
				begin
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						select distinct @categorySetCode,
							1 as OrganizationCount, 
							lea.DimLeaId,
							lea.LeaOrganizationName as OrganizationName ,lea.LeaIdentifierSea,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateAbbreviationCode, lea.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimLeas lea 
								on fact.LeaId = lea.DimLeaID
							left outer join rds.BridgeLeaGradeLevels bridgeGrades 
								on fact.LeaId = bridgeGrades.LeaId
							left outer join rds.DimGradeLevels grades 
								on grades.DimGradeLevelId = bridgeGrades.GradeLevelId
						where d.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1	
						and ISNULL(lea.ReportedFederally, 1) = 1 
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
							1 as OrganizationCount, 
							sch.DimK12SchoolId,
							sch.NameOfInstitution as OrganizationName ,
							sch.SchoolIdentifierSea, sch.LeaIdentifierSea,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode, sch.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							left outer join rds.BridgeK12SchoolGradeLevels bridgeGrades 
								on fact.K12SchoolId = bridgeGrades.K12SchoolId
							left outer join rds.DimGradeLevels grades 
								on grades.DimGradeLevelId = bridgeGrades.GradeLevelId
						where d.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1 
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					end
				end
				else if (@reportCode ='c129')
				BEGIN		
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
					select distinct @categorySetCode,
						isnull(primaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, ''),
						ISNULL(secondaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, ''),
						schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierSea,								
						@reportCode, 
						@reportLevel,
						@reportYear, 
						schStatus.SharedTimeIndicatorEdFactsCode, 
						sch.StateANSICode, 
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription,
						titleIStatus.TitleISchoolStatusEdFactsCode, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode,
						MagnetOrSpecialProgramEmphasisSchoolEdFactsCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId	
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.K12SchoolStatusId = schStatus.DimK12SchoolStatusId
						left outer join rds.DimTitleIStatuses titleIStatus 
							on fact.TitleIStatusId = titleIStatus.DimTitleIStatusId		
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
							
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c130')
				BEGIN		
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
					select distinct @categorySetCode,
						isnull(primaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, ''),
						ISNULL(secondaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, ''),
						1 as OrganizationCount, 
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierSea,				
						sch.[LeaIdentifierSea],														
						@reportCode, 
						@reportLevel,
						@reportYear, 
						sch.StateANSICode, 
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription,
						0 as TotalIndicator,
						schStatus.PersistentlyDangerousStatusDescription+','+ schStatus.PersistentlyDangerousStatusCode,
						schStatus.SchoolImprovementStatusDescription +','+ schStatus.SchoolImprovementStatusCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.K12SchoolStatusId = schStatus.DimK12SchoolStatusId				
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1	
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c193')
				BEGIN		
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
					select distinct @categorySetCode,
						1 as OrganizationCount, 
						lea.DimLeaId,
						lea.LeaOrganizationName as OrganizationName ,
						lea.LeaIdentifierSea,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription, 0 as TotalIndicator, 
						ISNULL(TitleiParentalInvolveRes, -1),
						TitleiPartaAllocations
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1 
					and ISNULL(lea.ReportedFederally, 1) = 1
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				else if(@reportCode='c198')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						schools.DimK12SchoolId,
						schools.NameOfInstitution as OrganizationName,									
						schools.StateAbbreviationCode, 
						schools.SchoolIdentifierSea, 
						schools.StateANSICode,
						schools.StateAbbreviationDescription as StateName,		
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierSea, 
						schools.CharterSchoolContractIdNumber, 
						schools.CharterSchoolContractApprovalDate, 
						schools.CharterSchoolContractRenewalDate
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools 
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join rds.DimCharterSchoolAuthorizers approver 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = approver.DimCharterSchoolAuthorizerId 
						inner join rds.DimCharterSchoolAuthorizers secondaryApprover 
							on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = secondaryApprover.DimCharterSchoolAuthorizerId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator = 1 		
					and ISNULL(schools.ReportedFederally, 1) = 1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE if(@reportCode='c197')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						,CHARTERSCHOOLMANAGERORGANIZATION
						,CHARTERSCHOOLUPDATEDMANAGERORGANIZATION
						)
					SELECT distinct 1 as OrganizationCount, 
						schools.dimK12SchoolId,
						schools.NameOfInstitution as OrganizationName,									
						schools.StateAbbreviationCode, 
						schools.SchoolIdentifierSea, 
						schools.StateANSICode,
						schools.StateAbbreviationDescription as StateName,				
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierSea, 
						schools.LeaIdentifierNces, 
						schools.SchoolIdentifierNces
						,a.CharterSchoolManagementOrganizationOrganizationIdentifierSea
						,b.CharterSchoolManagementOrganizationOrganizationIdentifierSea							 
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools 
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join rds.DimCharterSchoolManagementOrganizations a 
							on fact.CharterSchoolManagementOrganizationId = a.DimCharterSchoolManagementOrganizationId
						inner join rds.DimCharterSchoolManagementOrganizations b 
							on fact.CharterSchoolManagementOrganizationId = b.DimCharterSchoolManagementOrganizationId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator=1 
					and ISNULL(schools.ReportedFederally, 1) = 1
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode='c196')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						lea.DimCharterSchoolManagementOrganizationId,
						lea.CharterSchoolManagementOrganizationOrganizationName as OrganizationName,
						lea.CharterSchoolManagementOrganizationOrganizationIdentifierSea as LeaStateIdentifier,
						lea.StateAbbreviationCode,
						lea.StateANSICode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,
						lea.CharterSchoolManagementOrganizationTypeEdfactsCode as ManagementOrganizationType,
						lea.MailingAddressStreetNumberAndName,
						lea.MailingAddressCity,								
						lea.MailingAddressStateAbbreviation,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreetNumberAndName,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressStateAbbreviation,
						lea.PhysicalAddressPostalCode
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolManagementOrganizations lea 
							on fact.CharterSchoolManagementOrganizationId = lea.DimCharterSchoolManagementOrganizationId
/* JW 6/26/2023 Not sure of this join *********************************************************
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierSea = lea.SchoolStateIdentier
***********************************************************************************************/
					WHERE d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolManagementOrganizationId <> -1 
					-- JW 6/26/2023 Depends on join above that is commented 
					-- and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					UNION
					SELECT distinct	1 as OrganizationCount, 
						lea.DimCharterSchoolManagementOrganizationId,
						lea.CharterSchoolManagementOrganizationOrganizationName as OrganizationName,
						lea.CharterSchoolManagementOrganizationOrganizationIdentifierSea as LeaStateIdentifier,
						lea.StateAbbreviationCode,
						lea.StateANSICode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,
						lea.CharterSchoolManagementOrganizationTypeEdfactsCode as ManagementOrganizationType,
						lea.MailingAddressStreetNumberAndName,
						lea.MailingAddressCity,								
						lea.MailingAddressStateAbbreviation,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreetNumberAndName,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressStateAbbreviation,
						lea.PhysicalAddressPostalCode
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolManagementOrganizations lea 
							on fact.CharterSchoolUpdatedManagementOrganizationId = lea.DimCharterSchoolManagementOrganizationId	
/* JW 6/26/2023 Not sure of this join *********************************************************
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierSea = lea.SchoolStateIdentifier
***********************************************************************************************/

					WHERE d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolManagementOrganizationId <> -1 
					-- JW 6/26/2023 Depends on join above that is commented 
					-- and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					)
			END
				ELSE IF(@reportCode ='c190')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
					(SELECT distinct 1 as OrganizationCount, 
						lea.DimCharterSchoolAuthorizerId,
						lea.CharterSchoolAuthorizingOrganizationOrganizationName as OrganizationName,
						lea.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea as LeaStateIdentifier,		 
						lea.StateAbbreviationCode,
						lea.StateANSICode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,
						lea.CharterSchoolAuthorizingOrganizationTypeCode as ManagementOrganizationType,
						lea.MailingAddressStreetNumberAndName,
						lea.MailingAddressCity,								
						lea.MailingAddressStateAbbreviation,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreetNumberAndName,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressStateAbbreviation,
						lea.PhysicalAddressPostalCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolAuthorizers lea 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = lea.DimCharterSchoolAuthorizerId
/* JW 6/26/2023 Not sure of this join *********************************************************
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierSea = lea.SchoolStateIdentifier	
*********************************************************************************************/
					where d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolAuthorizerId <> -1 
					-- JW 6/26/2023 Depends on join above that is commented 
					-- and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					UNION 
					SELECT distinct	1 as OrganizationCount, 
						lea.DimCharterSchoolAuthorizerId,
						lea.CharterSchoolAuthorizingOrganizationOrganizationName as OrganizationName,
						lea.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea as LeaStateIdentifier,		 
						lea.StateAbbreviationCode,
						lea.StateANSICode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,
						lea.CharterSchoolAuthorizingOrganizationTypeCode,
						lea.MailingAddressStreetNumberAndName,
						lea.MailingAddressCity,								
						lea.MailingAddressStateAbbreviation,
						lea.MailingAddressPostalCode,
						@reportCode,
						@reportLevel,
						@reportYear,
						lea.PhysicalAddressStreetNumberAndName,
						lea.PhysicalAddressCity,
						lea.PhysicalAddressStateAbbreviation,
						lea.PhysicalAddressPostalCode
					from rds.FactOrganizationCounts fact
					inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
					inner join rds.DimCharterSchoolAuthorizers lea 
						on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = lea.DimCharterSchoolAuthorizerId
/* JW 6/26/2023 Not sure of this join *********************************************************
					inner join rds.DimK12Schools schools 
						on schools.SchoolIdentifierSea = lea.SchoolStateIdentifier	
*********************************************************************************************/
					where d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolAuthorizerId <> -1 
					-- JW 6/26/2023 Depends on join above that is commented 
					-- and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					)
				END
				ELSE IF(@reportCode ='c103')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierSea,	
						sch.LeaIdentifierSea as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						statuses.StatePovertyDesignationCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.K12SchoolStatusId= statuses.DimK12SchoolStatusId 		
					Where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c132')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierSea,	
						sch.LeaIdentifierSea as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						[SCHOOLIMPROVEMENTFUNDS],
						isnull(ecodisStudentCount,0) as 'EconomicallyDisadvantagedStudentCount'								
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						INNER JOIN rds.DimK12Schools sch
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.K12SchoolStatusId= statuses.DimK12SchoolStatusId 
						left join(	select 	SchoolYearId, K12SchoolId, sum(studentcount) as ecodisStudentCount
									from  RDS.FactK12StudentCounts factStd 		
											inner join rds.DimEconomicallyDisadvantagedStatuses demo 
												on demo.DimEconomicallyDisadvantagedStatusId = factStd.EconomicallyDisadvantagedStatusId 
												and demo.EconomicDisadvantageStatusCode != 'MISSING'	
									where K12SchoolId <> -1
									group by SchoolYearId, K12SchoolId 
								)ecodisCount 
							on ecodisCount.SchoolYearId = d.DimSchoolYearId 
							and sch.DimK12SchoolId = ecodisCount.K12SchoolId				
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1	
					and ISNULL(sch.ReportedFederally, 1) = 1
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
				END
				ELSE IF(@reportCode ='c170')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						lea.DimLeaId,
						lea.LeaOrganizationName as OrganizationName,
						lea.LeaIdentifierSea,	
						lea.LeaIdentifierSea as LeaStateIdentifier,										 
						lea.StateANSICode as StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						case when statuses.McKinneyVentoSubgrantRecipientCode = 'YES' then 'MVSUBGYES'
							else 'MVSUBGNO'
						end
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
						left outer join RDS.DimK12OrganizationStatuses statuses 
							on fact.K12OrganizationStatusId= statuses.DimK12OrganizationStatusId 
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1	
					and ISNULL(lea.ReportedFederally, 1) = 1 
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c163')
				BEGIN
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
							lea.DimLeaId,
							lea.LeaOrganizationName as OrganizationName,
							lea.LeaIdentifierSea,	
							lea.LeaIdentifierSea as LeaStateIdentifier,										 
							lea.StateANSICode as StateANSICode,
							lea.StateAbbreviationCode,
							lea.StateAbbreviationDescription as StateName,
							@categorySetCode,	
							@reportCode,
							@reportLevel,
							@reportYear,
							statuses.GunFreeSchoolsActReportingStatusCode as GunFreeStatusCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimLeas lea 
								on fact.LeaId = lea.DimLeaID
							left outer join RDS.DimK12OrganizationStatuses statuses 
								on fact.K12OrganizationStatusId= statuses.DimK12OrganizationStatusId
						where d.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
						and ISNULL(lea.ReportedFederally, 1) = 1
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						select distinct @categorySetCode,
							1 as OrganizationCount, 
							sch.DimK12SchoolId,
							sch.NameOfInstitution as OrganizationName ,
							sch.SchoolIdentifierSea,	
							sch.LeaIdentifierSea as LeaStateIdentifier,	
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode,
							sch.StateAbbreviationDescription as StateName, 0 as TotalIndicator, 
							statuses.GunFreeSchoolsActReportingStatusCode as GunFreeStatusCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							left outer join RDS.DimK12OrganizationStatuses statuses 
								on fact.K12OrganizationStatusId= statuses.DimK12OrganizationStatusId 
						where d.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1	
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					end
				END
				ELSE IF(@reportCode ='c205')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierSea,	
						sch.LeaIdentifierSea as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						statuses.ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode as 'ProgressAchievingEnglishLanguage',
						@tableTypeAbbrv,
						case when statuses.ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode = 'STTDEF' then dss.SchoolStateStatusCode else null end as StateDefinedStatus
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.K12SchoolStatusId= statuses.DimK12SchoolStatusId 		
						inner join rds.DimK12SchoolStateStatuses dss 
							on dss.DimK12SchoolStateStatusId= fact.K12SchoolStateStatusId
					where d.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1 
						and statuses.ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode <>'Missing'
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c206')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						--ComprehensiveAndTargetedSupportCode,
						ComprehensiveSupportImprovementCode,
						TargetedSupportImprovementCode,
						ComprehensiveSupportCode,
						TargetedSupportCode,
						AdditionalTargetedSupportandImprovementCode
						)
					SELECT distinct 1 as OrganizationCount, 
						sch.DimK12SchoolId,
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierSea,	
						sch.LeaIdentifierSea as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						ISNULL(FederalProgramsFundingAllocation, 0) as FederalFundAllocated,
						--statuses.ComprehensiveAndTargetedSupportCode,
						statuses.ComprehensiveSupportAndImprovementStatusCode,
						statuses.TargetedSupportAndImprovementStatusCode,						
						'', -- JW 6/26/2023 Not sure      statuses.ComprehensiveSupportCode,
						'', -- JW 6/26/2023 Not sure      statuses.TargetedSupportCode,
						statuses.AdditionalTargetedSupportAndImprovementStatusCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join RDS.DimComprehensiveAndTargetedSupports statuses 
							on fact.ComprehensiveAndTargetedSupportId = statuses.DimComprehensiveAndTargetedSupportId
						inner join rds.DimK12SchoolStateStatuses dss 
							on dss.DimK12SchoolStateStatusId= fact.K12SchoolStateStatusId
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1 
					and ISNULL(sch.ReportedFederally, 1) = 1
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if(@reportCode='c207')
				BEGIN
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						,[AppropriationMethodCode])
					SELECT distinct 1 as OrganizationCount, 
						schools.dimK12SchoolId,
						schools.NameOfInstitution as OrganizationName,
						schools.StateAbbreviationCode,
						schools.SchoolIdentifierSea,	
						schools.StateANSICode as StateANSICode,
						schools.StateAbbreviationDescription as StateName,	
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierSea, 
						charterStatus.AppropriationMethodEdFactsCode
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join rds.DimCharterSchoolStatuses charterStatus 
							on fact.CharterSchoolStatusId = charterStatus.DimCharterSchoolStatusId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator=1
					and ISNULL(schools.ReportedFederally, 1) = 1
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c131')
				BEGIN	
					INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						lea.DimLeaId,
						lea.LeaOrganizationName as OrganizationName ,
						lea.LeaIdentifierSea,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription, 
						0 as TotalIndicator, 
						ISNULL(TitleiParentalInvolveRes, -1),
						TitleiPartaAllocations,
						REAPAlternativeFundingStatusCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
						inner join RDS.DimK12OrganizationStatuses organizationStatus 
							on organizationStatus.DimK12OrganizationStatusId = fact.K12OrganizationStatusId	
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1	
					and ISNULL(lea.ReportedFederally, 1) = 1
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				if(@reportCode = 'c035')
				begin
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
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
						select distinct @categorySetCode,	1 as OrganizationCount, 
							lea.DimLeaId,
							lea.LeaOrganizationName as OrganizationName , lea.LeaIdentifierNces, lea.LeaIdentifierSea,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateAbbreviationCode, lea.StateAbbreviationDescription, @tableTypeAbbrv,
							0 as TotalIndicator, fact.FederalProgramCode, fact.FederalProgramsFundingAllocation
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimLeas lea 
								on fact.LeaId = lea.DimLeaID
							inner join rds.DimFactTypes facttype 
								on facttype.DimFactTypeID= fact.FactTypeId
						where d.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1 
						and facttype.FactTypeCode ='directory'
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
					end	
					else if(@reportLevel = 'sea')
					begin
						INSERT INTO [RDS].[ReportEDFactsOrganizationCounts]
							([CategorySetCode]
							,[OrganizationCount]
							,[OrganizationId]
							,[OrganizationName]
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
							a.DimSeaId,
							OrganizationName , StateANSICode, StateName, StateCode,
							@reportCode, @reportLevel, @reportYear,@tableTypeAbbrv, 0 as TotalIndicator, 
							FederalProgramCode, FederalProgramsFundingAllocationType, Sum(FederalProgramsFundingAllocation)
						from (	select distinct 1 as OrganizationCount, sea.DimSeaId,
									sea.SeaOrganizationName as OrganizationName , sea.StateANSICode, sea.StateAbbreviationDescription as StateName, 
									sea.StateAbbreviationCode as StateCode,
									0 as TotalIndicator, fact.FederalProgramCode, fact.FederalProgramsFundingAllocationType, 
									fact.FederalProgramsFundingAllocation
								from rds.FactOrganizationCounts fact
									inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
									inner join rds.DimSeas sea 
										on fact.SeaId = sea.DimSeaId						
								where d.SchoolYear = @reportYear and sea.DimSeaId <> -1 
							)as a 
						group by OrganizationCount, OrganizationName, DimSeaId,
							StateCode, FederalProgramCode, FederalProgramsFundingAllocationType, StateANSICode, StateName
					end						
				end
			end			-- @runAsTest = 1
			else
			begin
				if(@reportCode = 'c029')
				begin
					if(@reportLevel = 'sea')
					begin
						select p.ElectronicMailAddressOrganizational,p.FirstName,p.LastOrSurname,p.TelephoneNumberWork,p.PositionTitle, @categorySetCode,
							sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.MailingAddressStateAbbreviation, sea.MailingAddressStreetNumberAndName,
							1 as OrganizationCount, 							
							sea.SeaOrganizationName as OrganizationName ,
							sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressStateAbbreviation, sea.PhysicalAddressStreetNumberAndName,
							@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateAbbreviationCode, sea.StateAbbreviationDescription, 
							sea.TelephoneNumber, 0 as TotalIndicator, sea.WebSiteAddress
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimSeas sea 
								on fact.SeaId = sea.DimSeaId
							left outer join rds.DimPeople p 
								on fact.K12StaffId = p.DimPersonId
						where d.SchoolYear = @reportYear 
						and sea.DimSeaId <> -1
					end
					else if(@reportLevel = 'lea')
					begin

						insert into #minmaxLeas
						(
							  Identifier
							, MinDate
							, MaxDate
						)
						select 
							  LeaIdentifierSea
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimLeas lea
							on fact.LeaId = lea.DimLeaId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						where dates.SchoolYear = @reportYear 
						GROUP BY lea.LeaIdentifierSea

						select 
							  @categorySetCode
							, latestLea.CharterLeaStatus as CharterLeaStatusEdFactsCode
							, latestLea.LeaTypeEdFactsCode
							, latestLea.MailingAddressCity
							, latestLea.MailingAddressPostalCode
							, latestLea.MailingAddressStateAbbreviation
							, latestLea.MailingAddressStreetNumberAndName
							, syLea.LeaOperationalStatusEdFactsCode
							, syLea.LeaOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestLea.LeaOrganizationName as OrganizationName
							, latestLea.LeaIdentifierNces
							, latestLea.LeaIdentifierSea
							, latestLea.OutOfStateIndicator
							, latestLea.PhysicalAddressCity 
							, latestLea.PhysicalAddressPostalCode
							, latestLea.PhysicalAddressStateAbbreviation
							, latestLea.PhysicalAddressStreetNumberAndName
							, @reportCode
							, @reportLevel
							, @reportYear
							, latestLea.StateANSICode
							, latestLea.StateAbbreviationCode
							, latestLea.StateAbbreviationDescription
							, latestLea.LeaSupervisoryUnionIdentificationNumber
							, latestLea.TelephoneNumber
							, 0 as TotalIndicator
							, latestLea.WebSiteAddress
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN latestLea.OperationalStatusEffectiveDate
								ELSE @effectiveDate
							 end as OperationalStatusEffectiveDate
							, latestLea.PriorLeaIdentifierSea
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusEdFactsCode
							, case 
								when latestLea.OperationalStatusEffectiveDate > syLea.OperationalStatusEffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusId
						from #minmaxLeas mmlea						
						join rds.DimLeas syLea
							on mmlea.Identifier = syLea.LeaIdentifierSea
							and mmlea.MinDate = syLea.RecordStartDateTime
						join rds.DimLeas latestLea
							on mmlea.Identifier = latestLea.LeaIdentifierSea	
							and mmlea.MaxDate = latestLea.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestLea.DimLeaId = fact.LeaId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
							where latestLea.DimLeaID <> -1	
						and ISNULL(latestLea.ReportedFederally, 1) = 1 
						and latestLea.LeaOperationalStatus <> 'MISSING'

					end
					else if(@reportLevel = 'sch')
					begin
						insert into #minmaxSchools
						(
							  Identifier
							, MinDate
							, MaxDate
						)
						select 
							  SchoolIdentifierSea
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimK12Schools school
							on fact.K12SchoolId = school.DimK12SchoolId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						where dates.SchoolYear = @reportYear 
						GROUP BY school.SchoolIdentifierSea

						select 
							  @categorySetCode
							, isnull(primaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, '')
							, ISNULL(secondaryAuthorizer.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea, '')
							, latestSchool.CharterSchoolStatus as CharterSchoolStatusEdFactsCode
							, latestSchool.MailingAddressCity
							, latestSchool.MailingAddressPostalCode
							, latestSchool.MailingAddressStateAbbreviation
							, latestSchool.MailingAddressStreetNumberAndName
							, schStatus.NSLPStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestSchool.NameOfInstitution as OrganizationName 
							, latestSchool.SchoolIdentifierNces
							, latestSchool.SchoolIdentifierSea
							, latestSchool.LeaIdentifierSea
							, latestSchool.LeaIdentifierNces
							, latestSchool.OutOfStateIndicator
							, latestSchool.PhysicalAddressCity 
							, latestSchool.PhysicalAddressPostalCode
							, latestSchool.PhysicalAddressStateAbbreviation
							, latestSchool.PhysicalAddressStreetNumberAndName
							, latestSchool.ReconstitutedStatus
							, @reportCode
							, @reportLevel
							, @reportYear
							, schStatus.SharedTimeIndicatorEdFactsCode
							, latestSchool.SchoolTypeEdFactsCode
							, latestSchool.StateANSICode
							, latestSchool.StateAbbreviationCode
							, latestSchool.StateAbbreviationDescription
							, titleIStatus.TitleISchoolStatusEdFactsCode
							, latestSchool.TelephoneNumber
							, 0 as TotalIndicator
							, schStatus.VirtualSchoolStatusEdFactsCode
							, latestSchool.WebSiteAddress
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN latestSchool.SchoolOperationalStatusEffectiveDate
								
							  end as OperationalStatusEffectiveDate
							, latestSchool.PriorLeaIdentifierSea
							, latestSchool.PriorSchoolIdentifierSea
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN ISNULL(latestSchool.SchoolOperationalStatusEdFactsCode, '')
								ELSE NULL
							  end as UpdatedOperationalStatusEdFactsCode
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN ISNULL(latestSchool.SchoolOperationalStatusEdFactsCode, '')
								ELSE NULL
							  end as UpdatedOperationalStatusId
						from #minmaxSchools mmSchool						
						join rds.DimK12Schools sySchool
							on mmSchool.Identifier = sySchool.SchoolIdentifierSea	
							and mmSchool.MinDate = sySchool.RecordStartDateTime
						join rds.DimK12Schools latestSchool
							on mmSchool.Identifier = latestSchool.SchoolIdentifierSea	
							and mmSchool.MaxDate = latestSchool.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestSchool.DimK12SchoolId = fact.K12SchoolId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.AuthorizingBodyCharterSchoolAuthorizerId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.SecondaryAuthorizingBodyCharterSchoolAuthorizerId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.K12SchoolStatusId = schStatus.DimK12SchoolStatusId
						left outer join rds.DimTitleIStatuses titleIStatus 
							on fact.TitleIStatusId = titleIStatus.DimTitleIStatusId
						where dates.SchoolYear = @reportYear
						and latestSchool.DimK12SchoolId <> -1 
						and ISNULL(latestSchool.ReportedFederally, 1) = 1
						and latestSchool.SchoolOperationalStatus <> 'MISSING'

					end
				end
				else if(@reportCode = 'c039')
				begin
						if(@reportLevel = 'lea')
						begin
							select distinct @categorySetCode,
							1 as OrganizationCount, 
							lea.LeaOrganizationName as OrganizationName ,lea.LeaIdentifierSea,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateAbbreviationCode, lea.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
							inner join rds.DimLeas lea 
								on fact.LeaId = lea.DimLeaID
							left outer join rds.BridgeLeaGradeLevels bridgeGrades 
								on fact.LeaId = bridgeGrades.LeaId
							left outer join rds.DimGradeLevels grades 
								on grades.DimGradeLevelId = bridgeGrades.GradeLevelId
						where dates.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1	
						and ISNULL(lea.ReportedFederally, 1) = 1 
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
						end
						else if(@reportLevel = 'sch')
						begin

							select @categorySetCode,
							1 as OrganizationCount, sch.NameOfInstitution as OrganizationName ,
							sch.SchoolIdentifierSea, sch.LeaIdentifierSea,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode, sch.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							left outer join rds.BridgeK12SchoolGradeLevels bridgeGrades 
								on fact.K12SchoolId = bridgeGrades.K12SchoolId
							left outer join rds.DimGradeLevels grades 
								on grades.DimGradeLevelId = bridgeGrades.GradeLevelId
						where dates.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1 
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					end
						end
					else if (@reportCode ='c129')
					BEGIN	
						select distinct @categorySetCode,
						-- JW 6/26/2023...should these be blank?
						'',
						'',
						/**********************************
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						************************************/
						schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierSea,								
						@reportCode, 
						@reportLevel,
						@reportYear, 
						schStatus.SharedTimeIndicatorEdFactsCode, 
						sch.StateANSICode, 
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription,
						titleIStatus.TitleISchoolStatusEdFactsCode, 0 as TotalIndicator, schStatus.VirtualSchoolStatusEdFactsCode,
						MagnetOrSpecialProgramEmphasisSchoolEdFactsCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId	
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.K12SchoolStatusId = schStatus.DimK12SchoolStatusId
						left outer join rds.DimTitleIStatuses titleIStatus 
							on fact.TitleIStatusId = titleIStatus.DimTitleIStatusId					
					where dates.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				
				end
			set @categorySetCntr = @categorySetCntr + 1
			END			-- @runAsTest = 1	
			FETCH NEXT FROM categoryset_cursor INTO @categorySetId, @reportLevel, @categorySetCode
		END			-- categoryset_cursor
		CLOSE categoryset_cursor
		DEALLOCATE categoryset_cursor
		FETCH NEXT FROM submissionYear_cursor INTO @reportYear, @submissionYearStartDate, @submissionYearEndDate
	END			-- submissionYear_cursor
	CLOSE submissionYear_cursor
	DEALLOCATE submissionYear_cursor
	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1)
	begin
		update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1
	end

	drop table #minmaxLeas
	drop table #minmaxSchools

	SET NOCOUNT OFF;
END