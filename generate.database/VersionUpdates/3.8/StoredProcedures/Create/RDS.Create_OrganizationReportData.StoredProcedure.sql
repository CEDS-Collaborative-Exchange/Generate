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

	declare @tblOperationalStatuses as TABLE(OrganizationLevel varchar(10), Identifier varchar(50), OperationalStatusEffectiveDate datetime, 
	UpdatedOperationalStatusEffectiveDate datetime, HasUpdatedOrganization bit)

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
							,[MailingAddressStreet2]
							,[OrganizationCount]
							,[OrganizationName]
							,[PhysicalAddressCity]
							,[PhysicalAddressPostalCode]
							,[PhysicalAddressState]
							,[PhysicalAddressStreet]
							,[PhysicalAddressStreet2]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[Telephone]
							,[TotalIndicator]
							,[Website])
						select p.ElectronicMailAddress,p.FirstName,p.LastOrSurname,p.TelephoneNumber,p.PositionTitle, @categorySetCode,
							sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.MailingAddressState, sea.MailingAddressStreet,sea.MailingAddressStreet2,
							1 as OrganizationCount, 							
							sea.SeaName as OrganizationName ,
							sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressState, sea.PhysicalAddressStreet,sea.PhysicalAddressStreet2,
							@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateAbbreviationCode, sea.StateAbbreviationDescription, 
							sea.Telephone, 0 as TotalIndicator, sea.Website
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears dates 
								on fact.SchoolYearId = dates.DimSchoolYearId
							inner join rds.DimSeas sea 
								on fact.SeaId = sea.DimSeaId
							left outer join rds.DimK12Staff p 
								on fact.K12StaffId = p.DimK12StaffId
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
							  LeaIdentifierState
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimLeas lea
							on fact.LeaId = lea.DimLeaId
						inner join rds.DimSchoolYears d 
								on fact.SchoolYearId = d.DimSchoolYearId
						where d.SchoolYear = @reportYear 
						GROUP BY lea.LeaIdentifierState


						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[CharterLeaStatus]
							,[LEAType]
							,[MailingAddressCity]
							,[MailingAddressPostalCode]
							,[MailingAddressState]
							,[MailingAddressStreet]
							,[MailingAddressStreet2]
							,[OperationalStatus]
							,[OperationalStatusId]
							,[OrganizationCount]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[OutOfStateIndicator]
							,[PhysicalAddressCity]
							,[PhysicalAddressPostalCode]
							,[PhysicalAddressState]
							,[PhysicalAddressStreet]
							,[PhysicalAddressStreet2]
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
							,[UpdatedOperationalStatusId])
						select 
							  @categorySetCode
							, latestLea.CharterLeaStatus as CharterLeaStatusEdFactsCode
							, latestLea.LeaTypeEdFactsCode
							, latestLea.MailingAddressCity
							, latestLea.MailingAddressPostalCode
							, latestLea.MailingAddressState
							, latestLea.MailingAddressStreet
							, latestLea.MailingAddressStreet2
							, syLea.LeaOperationalStatusEdFactsCode
							, syLea.LeaOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestLea.LeaName as OrganizationName
							, latestLea.LeaIdentifierNces
							, latestLea.LeaIdentifierState
							, latestLea.OutOfStateIndicator
							, latestLea.PhysicalAddressCity 
							, latestLea.PhysicalAddressPostalCode
							, latestLea.PhysicalAddressState
							, latestLea.PhysicalAddressStreet
							, latestLea.PhysicalAddressStreet2
							, @reportCode
							, @reportLevel
							, @reportYear
							, latestLea.StateANSICode
							, latestLea.StateAbbreviationCode as StateCode
							, latestLea.StateAbbreviationDescription as StateName
							, latestLea.LeaSupervisoryUnionIdentificationNumber
							, latestLea.Telephone
							, 0 as TotalIndicator
							, latestLea.Website
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN latestLea.EffectiveDate
								ELSE @effectiveDate
							 end as OperationalStatusEffectiveDate
							, latestLea.PriorLeaIdentifierState
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusEdFactsCode
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusId
						from #minmaxLeas mmlea						
						join rds.DimLeas syLea
							on mmlea.Identifier = syLea.LeaIdentifierState
							and mmlea.MinDate = syLea.RecordStartDateTime
						join rds.DimLeas latestLea
							on mmlea.Identifier = latestLea.LeaIdentifierState	
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
							  SchoolIdentifierState
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimK12Schools school
							on fact.K12SchoolId = school.DimK12SchoolId
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						where d.SchoolYear = @reportYear 
						GROUP BY school.SchoolIdentifierState

						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[CharterSchoolAuthorizer]
							,[CharterSchoolSecondaryAuthorizer]
							,[CharterSchoolStatus]
							,[CharterSchoolIndicator]
							,[MailingAddressCity]
							,[MailingAddressPostalCode]
							,[MailingAddressState]
							,[MailingAddressStreet]
							,[MailingAddressStreet2]
							,[NSLPSTATUS]
							,[OperationalStatus]
							,[OperationalStatusId]
							,[OrganizationCount]
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
							,[PhysicalAddressStreet2]
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
						select 
							  @categorySetCode
							, isnull(primaryAuthorizer.StateIdentifier, '')
							, ISNULL(secondaryAuthorizer.StateIdentifier, '')
							, latestSchool.CharterSchoolStatus as CharterSchoolStatusEdFactsCode
							, latestSchool.CharterSchoolIndicator
							, latestSchool.MailingAddressCity
							, latestSchool.MailingAddressPostalCode
							, latestSchool.MailingAddressState
							, latestSchool.MailingAddressStreet
							, latestSchool.MailingAddressStreet2
							, schStatus.NSLPStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestSchool.NameOfInstitution as OrganizationName 
							, latestSchool.SchoolIdentifierNces
							, latestSchool.SchoolIdentifierState
							, latestSchool.LeaIdentifierState
							, latestSchool.LeaIdentifierNces
							, latestSchool.OutOfStateIndicator
							, latestSchool.PhysicalAddressCity 
							, latestSchool.PhysicalAddressPostalCode
							, latestSchool.PhysicalAddressState
							, latestSchool.PhysicalAddressStreet
							, latestSchool.PhysicalAddressStreet2
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
							, latestSchool.Telephone
							, 0 as TotalIndicator
							, schStatus.VirtualSchoolStatusEdFactsCode
							, latestSchool.Website
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN latestSchool.SchoolOperationalStatusEffectiveDate
								
							  end as OperationalStatusEffectiveDate
							, latestSchool.PriorLeaIdentifierState
							, latestSchool.PriorSchoolIdentifierState
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
							on mmSchool.Identifier = sySchool.SchoolIdentifierState	
							and mmSchool.MinDate = sySchool.RecordStartDateTime
						join rds.DimK12Schools latestSchool
							on mmSchool.Identifier = latestSchool.SchoolIdentifierState	
							and mmSchool.MaxDate = latestSchool.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestSchool.DimK12SchoolId = fact.K12SchoolId
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.CharterSchoolApproverAgencyId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.CharterSchoolSecondaryApproverAgencyId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.SchoolStatusId = schStatus.DimK12SchoolStatusId
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
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]							
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
							lea.LeaName as OrganizationName ,lea.LeaIdentifierState,
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
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
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
							1 as OrganizationCount, sch.NameOfInstitution as OrganizationName ,
							sch.SchoolIdentifierState, sch.LeaIdentifierState,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode, sch.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
																else OperationalStatusEffectiveDate 
															end as OperationalStatusEffectiveDate
										from @tblOperationalStatuses 
										where OrganizationLevel = @reportLevel) opStatus
								on sch.SchoolIdentifierState = opStatus.Identifier
							   and sch.OperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
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
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[CharterSchoolAuthorizer]
						,[CharterSchoolSecondaryAuthorizer]													
						,[NSLPSTATUS]	
						,[OrganizationCount]
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
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierState,								
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
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
							and sch.OperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.SchoolStatusId = schStatus.DimK12SchoolStatusId
						left outer join rds.DimTitleIStatuses titleIStatus 
							on fact.TitleIStatusId = titleIStatus.DimTitleIStatusId					
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c130')
				BEGIN		
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[CharterSchoolAuthorizer]
						,[CharterSchoolSecondaryAuthorizer]
						,[OrganizationCount]
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
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						1 as OrganizationCount, 
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierState,				
						sch.[LeaIdentifierState],														
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
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
						   and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.SchoolStatusId = schStatus.DimK12SchoolStatusId				
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1	
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c193')
				BEGIN		
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[OrganizationCount]
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
						lea.LeaName as OrganizationName ,
						lea.LeaIdentifierState,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription, 0 as TotalIndicator, 
						TitleiParentalInvolveRes,
						TitleiPartaAllocations
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on lea.LeaIdentifierState = opStatus.Identifier
						   and lea.EffectiveDate = opStatus.OperationalStatusEffectiveDate		
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1 
					and ISNULL(lea.ReportedFederally, 1) = 1
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				else if(@reportCode='c198')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						schools.NameOfInstitution as OrganizationName,									
						schools.StateAbbreviationCode, 
						schools.SchoolIdentifierState, 
						schools.StateANSICode,
						schools.StateAbbreviationDescription as StateName,		
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierState, 
						schools.CharterSchoolContractIdNumber, 
						schools.CharterSchoolContractApprovalDate, 
						schools.CharterSchoolContractRenewalDate
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools 
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on schools.SchoolIdentifierState = opStatus.Identifier
							and schools.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join rds.DimCharterSchoolAuthorizers approver 
							on fact.CharterSchoolApproverAgencyId = approver.DimCharterSchoolAuthorizerId 
						inner join rds.DimCharterSchoolAuthorizers secondaryApprover 
							on fact.CharterSchoolSecondaryApproverAgencyId = secondaryApprover.DimCharterSchoolAuthorizerId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator = 1 		
					and ISNULL(schools.ReportedFederally, 1) = 1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE if(@reportCode='c197')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						,[CharterSchoolManagementOrganization]
						,[CharterSchoolUpdatedManagementOrganization]
						)
					SELECT distinct 1 as OrganizationCount, 
						schools.NameOfInstitution as OrganizationName,									
						schools.StateAbbreviationCode, 
						schools.SchoolIdentifierState, 
						schools.StateANSICode,
						schools.StateAbbreviationDescription as StateName,				
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierState, 
						schools.LeaIdentifierNces, 
						schools.SchoolIdentifierNces
						,a.StateIdentifier
						,b.StateIdentifier							 
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools 
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on schools.SchoolIdentifierState = opStatus.Identifier
							and schools.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join rds.DimCharterSchoolManagementOrganizations a 
							on fact.CharterSchoolManagerOrganizationId = a.DimCharterSchoolManagementOrganizationId
						inner join rds.DimCharterSchoolManagementOrganizations b 
							on fact.CharterSchoolUpdatedManagerOrganizationId = b.DimCharterSchoolManagementOrganizationId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator=1 
					and ISNULL(schools.ReportedFederally, 1) = 1
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode='c196')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						(
						[OrganizationCount]
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
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.CharterSchoolManagementOrganizationTypeEdfactsCode as ManagementOrganizationType,
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
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolManagementOrganizations lea 
							on fact.CharterSchoolManagerOrganizationId = lea.DimCharterSchoolManagementOrganizationId
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierState = lea.SchoolStateIdentifier	
					WHERE d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolManagementOrganizationId <> -1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					UNION
					SELECT distinct	1 as OrganizationCount, 
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.CharterSchoolManagementOrganizationTypeEdfactsCode as ManagementOrganizationType,
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
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolManagementOrganizations lea 
							on fact.CharterSchoolUpdatedManagerOrganizationId = lea.DimCharterSchoolManagementOrganizationId	
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierState = lea.SchoolStateIdentifier
					WHERE d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolManagementOrganizationId <> -1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					)
			END
				ELSE IF(@reportCode ='c190')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,		 
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.LeaTypeEdFactsCode as ManagementOrganizationType,
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
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimCharterSchoolAuthorizers lea 
							on fact.CharterSchoolApproverAgencyId = lea.DimCharterSchoolAuthorizerId
						inner join rds.DimK12Schools schools 
							on schools.SchoolIdentifierState = lea.SchoolStateIdentifier	
					where d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolAuthorizerId <> -1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING') 
					UNION 
					SELECT distinct	1 as OrganizationCount, 
						lea.Name as OrganizationName,
						lea.StateIdentifier as LeaStateIdentifier,		 
						lea.StateCode,
						lea.StateANSICode,
						lea.[State] as StateName,
						@categorySetCode,
						lea.LeaTypeEdfactsCode as ManagementOrganizationType,
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
					inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
					inner join rds.DimCharterSchoolAuthorizers lea 
						on fact.CharterSchoolSecondaryApproverAgencyId = lea.DimCharterSchoolAuthorizerId
					inner join rds.DimK12Schools schools 
						on schools.SchoolIdentifierState = lea.SchoolStateIdentifier	
					where d.SchoolYear = @reportYear 
					and lea.DimCharterSchoolAuthorizerId <> -1 
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					)
				END
				ELSE IF(@reportCode ='c103')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierState,	
						sch.LeaIdentifierState as LeaStateIdentifier,										 
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
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
						   and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.SchoolStatusId= statuses.DimK12SchoolStatusId 		
					Where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1
					and ISNULL(sch.ReportedFederally, 1) = 1 
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c132')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierState,	
						sch.LeaIdentifierState as LeaStateIdentifier,										 
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
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
							and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.SchoolStatusId= statuses.DimK12SchoolStatusId 
						left join(	select 	SchoolYearId, K12SchoolId, sum(studentcount) as ecodisStudentCount
									from  RDS.FactK12StudentCounts factStd 		
											inner join rds.DimK12Demographics demo 
												on demo.DimK12DemographicId = factStd.K12DemographicId 
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
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						lea.LeaName as OrganizationName,
						lea.LeaIdentifierState,	
						lea.LeaIdentifierState as LeaStateIdentifier,										 
						lea.StateANSICode as StateANSICode,
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						case when statuses.McKinneyVentoSubgrantRecipientCode = 'MISSING' then 'MVSUBGNO'
							else statuses.McKinneyVentoSubgrantRecipientCode end
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
						inner join(	select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel
								) opStatus
							on lea.LeaIdentifierState = opStatus.Identifier
							and lea.EffectiveDate = opStatus.OperationalStatusEffectiveDate
						left outer join RDS.DimK12OrganizationStatuses statuses 
							on fact.OrganizationStatusId= statuses.DimK12OrganizationStatusId 
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1	
					and ISNULL(lea.ReportedFederally, 1) = 1 
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c163')
				BEGIN
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([OrganizationCount]
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
							lea.LeaName as OrganizationName,
							lea.LeaIdentifierState,	
							lea.LeaIdentifierState as LeaStateIdentifier,										 
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
							inner join	(select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
																else OperationalStatusEffectiveDate 
															end as OperationalStatusEffectiveDate
										from @tblOperationalStatuses 
										where OrganizationLevel = @reportLevel
										) opStatus
								on lea.LeaIdentifierState = opStatus.Identifier
								and lea.EffectiveDate = opStatus.OperationalStatusEffectiveDate
							left outer join RDS.DimK12OrganizationStatuses statuses 
								on fact.OrganizationStatusId= statuses.DimK12OrganizationStatusId
						where d.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
						and ISNULL(lea.ReportedFederally, 1) = 1
					end
					else if(@reportLevel = 'sch')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
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
							1 as OrganizationCount, sch.NameOfInstitution as OrganizationName ,
							sch.SchoolIdentifierState,	
							sch.LeaIdentifierState as LeaStateIdentifier,	
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode,
							sch.StateAbbreviationDescription as StateName, 0 as TotalIndicator, 
							statuses.GunFreeSchoolsActReportingStatusCode as GunFreeStatusCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							inner join(	select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
																else OperationalStatusEffectiveDate 
															end as OperationalStatusEffectiveDate
										from @tblOperationalStatuses 
										where OrganizationLevel = @reportLevel) opStatus
								on sch.SchoolIdentifierState = opStatus.Identifier
								and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate	
							left outer join RDS.DimK12OrganizationStatuses statuses 
								on fact.OrganizationStatusId= statuses.DimK12OrganizationStatusId 
						where d.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1	
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
					end
				END
				ELSE IF(@reportCode ='c205')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierState,	
						sch.LeaIdentifierState as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						statuses.ProgressAchievingEnglishLanguageCode as 'ProgressAchievingEnglishLanguage',
						@tableTypeAbbrv,
						case when statuses.ProgressAchievingEnglishLanguageCode = 'STTDEF' then dss.SchoolStateStatusCode else null end as StateDefinedStatus
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
						   and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join RDS.DimK12SchoolStatuses statuses 
							on fact.SchoolStatusId= statuses.DimK12SchoolStatusId 		
						inner join rds.DimK12SchoolStateStatuses dss 
							on dss.DimK12SchoolStateStatusId= fact.SchoolStateStatusId
					where d.SchoolYear = @reportYear 
						and sch.DimK12SchoolId <> -1 
						and statuses.ProgressAchievingEnglishLanguageCode <>'Missing'
						and ISNULL(sch.ReportedFederally, 1) = 1
						and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				ELSE IF(@reportCode ='c206')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						sch.NameOfInstitution as OrganizationName,
						sch.SchoolIdentifierState,	
						sch.LeaIdentifierState as LeaStateIdentifier,										 
						sch.StateANSICode as StateANSICode,
						sch.StateAbbreviationCode,
						sch.StateAbbreviationDescription as StateName,
						@categorySetCode,	
						@reportCode,
						@reportLevel,
						@reportYear,
						ISNULL(FederalFundAllocated, 0) as FederalFundAllocated,
						--statuses.ComprehensiveAndTargetedSupportCode,
						statuses.ComprehensiveSupportImprovementCode,
						statuses.TargetedSupportImprovementCode,						
						statuses.ComprehensiveSupportCode,
						statuses.TargetedSupportCode,
						statuses.AdditionalTargetedSupportandImprovementCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools sch 
							on fact.K12SchoolId = sch.DimK12SchoolId
						inner join(	select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
							and sch.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join RDS.DimComprehensiveAndTargetedSupports statuses 
							on fact.ComprehensiveAndTargetedSupportId = statuses.DimComprehensiveAndTargetedSupportId
						inner join rds.DimK12SchoolStateStatuses dss 
							on dss.DimK12SchoolStateStatusId= fact.SchoolStateStatusId
					where d.SchoolYear = @reportYear 
					and sch.DimK12SchoolId <> -1 
					and ISNULL(sch.ReportedFederally, 1) = 1
					and sch.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if(@reportCode='c207')
				BEGIN
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([OrganizationCount]
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
						schools.NameOfInstitution as OrganizationName,
						schools.StateAbbreviationCode,
						schools.SchoolIdentifierState,	
						schools.StateANSICode as StateANSICode,
						schools.StateAbbreviationDescription as StateName,	
						@reportCode, 
						@reportYear,
						@reportLevel,
						@categorySetCode, 
						schools.LeaIdentifierState, 
						charterStatus.AppropriationMethodEdFactsCode
					FROM rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimK12Schools schools
							on schools.DimK12SchoolId= fact.K12SchoolId
						inner join( select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on schools.SchoolIdentifierState = opStatus.Identifier
							and schools.SchoolOperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join rds.DimCharterSchoolStatus charterStatus 
							on fact.CharterSchoolStatusId = charterStatus.DimCharterSchoolStatusId
					WHERE d.SchoolYear = @reportYear 
					and schools.CharterSchoolIndicator=1
					and ISNULL(schools.ReportedFederally, 1) = 1
					and schools.SchoolOperationalStatus not in ('Closed', 'FutureSchool', 'Inactive', 'MISSING')
				END
				else if (@reportCode ='c131')
				BEGIN	
					INSERT INTO [RDS].[FactOrganizationCountReports]
						([CategorySetCode]
						,[OrganizationCount]
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
						lea.LeaName as OrganizationName ,
						lea.LeaIdentifierState,
						@reportCode,
						@reportLevel, 
						@reportYear, 
						lea.StateANSICode, 
						lea.StateAbbreviationCode,
						lea.StateAbbreviationDescription, 
						0 as TotalIndicator, 
						TitleiParentalInvolveRes,
						TitleiPartaAllocations,
						REAPAlternativeFundingStatusCode
					from rds.FactOrganizationCounts fact
						inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
						inner join rds.DimLeas lea 
							on fact.LeaId = lea.DimLeaID
						inner join(	select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on lea.LeaIdentifierState = opStatus.Identifier
							and lea.EffectiveDate = opStatus.OperationalStatusEffectiveDate
						inner join RDS.DimK12OrganizationStatuses organizationStatus 
							on organizationStatus.DimK12OrganizationStatusId = fact.OrganizationStatusId	
					where d.SchoolYear = @reportYear 
					and lea.DimLeaID <> -1	
					and ISNULL(lea.ReportedFederally, 1) = 1
					and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
				END
				if(@reportCode = 'c035')
				begin
					if(@reportLevel = 'lea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
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
							lea.LeaName as OrganizationName , lea.LeaIdentifierNces, lea.LeaIdentifierState,
							@reportCode, @reportLevel, @reportYear, lea.StateANSICode, lea.StateAbbreviationCode, lea.StateAbbreviationDescription, @tableTypeAbbrv,
							0 as TotalIndicator, fact.FederalProgramCode, fact.FederalFundAllocated
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimLeas lea 
								on fact.LeaId = lea.DimLeaID
							inner join(	select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
																else OperationalStatusEffectiveDate 
															end as OperationalStatusEffectiveDate
										from @tblOperationalStatuses 
										where OrganizationLevel = @reportLevel) opStatus
								on lea.LeaIdentifierState = opStatus.Identifier
								and lea.EffectiveDate = opStatus.OperationalStatusEffectiveDate
							inner join rds.DimFactTypes facttype 
								on facttype.DimFactTypeID= fact.FactTypeId
						where d.SchoolYear = @reportYear 
						and lea.DimLeaID <> -1 
						and facttype.FactTypeCode ='directory'
						and lea.LeaOperationalStatus not in ('Closed', 'FutureAgency', 'Inactive', 'MISSING')
					end	
					else if(@reportLevel = 'sea')
					begin
						INSERT INTO [RDS].[FactOrganizationCountReports]
							([CategorySetCode]
							,[OrganizationCount]
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
							OrganizationName , StateANSICode, StateName, StateCode,
							@reportCode, @reportLevel, @reportYear,@tableTypeAbbrv, 0 as TotalIndicator, 
							FederalProgramCode, FederalFundAllocationType, Sum(FederalFundAllocated)
						from (	select distinct 1 as OrganizationCount,
									sea.SeaName as OrganizationName , sea.StateANSICode, sea.StateAbbreviationDescription as StateName, 
									sea.StateAbbreviationCode as StateCode,
									0 as TotalIndicator, fact.FederalProgramCode, fact.FederalFundAllocationType, 
									fact.FederalFundAllocated
								from rds.FactOrganizationCounts fact
									inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
									inner join rds.DimSeas sea 
										on fact.SeaId = sea.DimSeaId						
								where d.SchoolYear = @reportYear and sea.DimSeaId <> -1 
							)as a 
						group by OrganizationCount, OrganizationName,
							StateCode, FederalProgramCode, FederalFundAllocationType, StateANSICode, StateName
					end						
				end
			end			-- @runAsTest = 1
			else
			begin
				if(@reportCode = 'c029')
				begin
					if(@reportLevel = 'sea')
					begin
						select p.ElectronicMailAddress,p.FirstName,p.LastOrSurname,p.TelephoneNumber,p.PositionTitle, @categorySetCode,
							sea.MailingAddressCity, sea.MailingAddressPostalCode, sea.MailingAddressState, sea.MailingAddressStreet,sea.MailingAddressStreet2,
							1 as OrganizationCount, 							
							sea.SeaName as OrganizationName ,
							sea.PhysicalAddressCity , sea.PhysicalAddressPostalCode, sea.PhysicalAddressState, sea.PhysicalAddressStreet,sea.PhysicalAddressStreet2,
							@reportCode, @reportLevel, @reportYear, sea.StateANSICode, sea.StateAbbreviationCode, sea.StateAbbreviationDescription, 
							sea.Telephone, 0 as TotalIndicator, sea.Website
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears d
								on fact.SchoolYearId = d.DimSchoolYearId
							inner join rds.DimSeas sea 
								on fact.SeaId = sea.DimSeaId
							left outer join rds.DimK12Staff p 
								on fact.K12StaffId = p.DimK12StaffId
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
							  LeaIdentifierState
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimLeas lea
							on fact.LeaId = lea.DimLeaId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						where dates.SchoolYear = @reportYear 
						GROUP BY lea.LeaIdentifierState

						select 
							  @categorySetCode
							, latestLea.CharterLeaStatus as CharterLeaStatusEdFactsCode
							, latestLea.LeaTypeEdFactsCode
							, latestLea.MailingAddressCity
							, latestLea.MailingAddressPostalCode
							, latestLea.MailingAddressState
							, latestLea.MailingAddressStreet
							, latestLea.MailingAddressStreet2
							, syLea.LeaOperationalStatusEdFactsCode
							, syLea.LeaOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestLea.LeaName as OrganizationName
							, latestLea.LeaIdentifierNces
							, latestLea.LeaIdentifierState
							, latestLea.OutOfStateIndicator
							, latestLea.PhysicalAddressCity 
							, latestLea.PhysicalAddressPostalCode
							, latestLea.PhysicalAddressState
							, latestLea.PhysicalAddressStreet
							, latestLea.PhysicalAddressStreet2
							, @reportCode
							, @reportLevel
							, @reportYear
							, latestLea.StateANSICode
							, latestLea.StateAbbreviationCode
							, latestLea.StateAbbreviationDescription
							, latestLea.LeaSupervisoryUnionIdentificationNumber
							, latestLea.Telephone
							, 0 as TotalIndicator
							, latestLea.Website
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN latestLea.EffectiveDate
								ELSE @effectiveDate
							 end as OperationalStatusEffectiveDate
							, latestLea.PriorLeaIdentifierState
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusEdFactsCode
							, case 
								when latestLea.EffectiveDate > syLea.EffectiveDate THEN isnull(latestLea.LeaOperationalStatusEdFactsCode, '')
								ELSE null
							 end as UpdatedOperationalStatusId
						from #minmaxLeas mmlea						
						join rds.DimLeas syLea
							on mmlea.Identifier = syLea.LeaIdentifierState
							and mmlea.MinDate = syLea.RecordStartDateTime
						join rds.DimLeas latestLea
							on mmlea.Identifier = latestLea.LeaIdentifierState	
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
							  SchoolIdentifierState
							, min(RecordStartDateTime)
							, max(RecordStartDateTime)
						from rds.FactOrganizationCounts fact
						join rds.DimK12Schools school
							on fact.K12SchoolId = school.DimK12SchoolId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						where dates.SchoolYear = @reportYear 
						GROUP BY school.SchoolIdentifierState

						select 
							  @categorySetCode
							, isnull(primaryAuthorizer.StateIdentifier, '')
							, ISNULL(secondaryAuthorizer.StateIdentifier, '')
							, latestSchool.CharterSchoolStatus as CharterSchoolStatusEdFactsCode
							, latestSchool.MailingAddressCity
							, latestSchool.MailingAddressPostalCode
							, latestSchool.MailingAddressState
							, latestSchool.MailingAddressStreet
							, latestSchool.MailingAddressStreet2
							, schStatus.NSLPStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode
							, sySchool.SchoolOperationalStatusEdFactsCode as OperationalStatusId
							, 1 as OrganizationCount
							, latestSchool.NameOfInstitution as OrganizationName 
							, latestSchool.SchoolIdentifierNces
							, latestSchool.SchoolIdentifierState
							, latestSchool.LeaIdentifierState
							, latestSchool.LeaIdentifierNces
							, latestSchool.OutOfStateIndicator
							, latestSchool.PhysicalAddressCity 
							, latestSchool.PhysicalAddressPostalCode
							, latestSchool.PhysicalAddressState
							, latestSchool.PhysicalAddressStreet
							, latestSchool.PhysicalAddressStreet2
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
							, latestSchool.Telephone
							, 0 as TotalIndicator
							, schStatus.VirtualSchoolStatusEdFactsCode
							, latestSchool.Website
							, CASE 
								when latestSchool.SchoolOperationalStatusEffectiveDate > sySchool.SchoolOperationalStatusEffectiveDate THEN latestSchool.SchoolOperationalStatusEffectiveDate
								
							  end as OperationalStatusEffectiveDate
							, latestSchool.PriorLeaIdentifierState
							, latestSchool.PriorSchoolIdentifierState
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
							on mmSchool.Identifier = sySchool.SchoolIdentifierState	
							and mmSchool.MinDate = sySchool.RecordStartDateTime
						join rds.DimK12Schools latestSchool
							on mmSchool.Identifier = latestSchool.SchoolIdentifierState	
							and mmSchool.MaxDate = latestSchool.RecordStartDateTime
						join rds.FactOrganizationCounts fact
							on latestSchool.DimK12SchoolId = fact.K12SchoolId
						inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
						left outer join rds.DimCharterSchoolAuthorizers primaryAuthorizer 
							on fact.CharterSchoolApproverAgencyId = primaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimCharterSchoolAuthorizers secondaryAuthorizer 
							on fact.CharterSchoolSecondaryApproverAgencyId = secondaryAuthorizer.DimCharterSchoolAuthorizerId
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.SchoolStatusId = schStatus.DimK12SchoolStatusId
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
								select @categorySetCode,
							1 as OrganizationCount, 
							lea.LeaName as OrganizationName ,lea.LeaIdentifierState,
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
							sch.SchoolIdentifierState, sch.LeaIdentifierState,
							@reportCode, @reportLevel, @reportYear, sch.StateANSICode, sch.StateAbbreviationCode, sch.StateAbbreviationDescription, 0 as TotalIndicator, 
							grades.GradeLevelEdFactsCode
						from rds.FactOrganizationCounts fact
							inner join rds.DimSchoolYears dates
								on fact.SchoolYearId = dates.DimSchoolYearId
							inner join rds.DimK12Schools sch 
								on fact.K12SchoolId = sch.DimK12SchoolId
							inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
																else OperationalStatusEffectiveDate 
															end as OperationalStatusEffectiveDate
										from @tblOperationalStatuses 
										where OrganizationLevel = @reportLevel) opStatus
								on sch.SchoolIdentifierState = opStatus.Identifier
							   and sch.OperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
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
						sch.CharterSchoolAuthorizerIdPrimary,
						sch.CharterSchoolAuthorizerIdSecondary,								
						schStatus.NSLPStatusEdFactsCode,
						1 as OrganizationCount, 
						sch.NameOfInstitution as OrganizationName ,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierState,								
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
						inner join (select Identifier, case when HasUpdatedOrganization = 1 then UpdatedOperationalStatusEffectiveDate 
															else OperationalStatusEffectiveDate 
														end as OperationalStatusEffectiveDate
									from @tblOperationalStatuses 
									where OrganizationLevel = @reportLevel) opStatus
							on sch.SchoolIdentifierState = opStatus.Identifier
							and sch.OperationalStatusEffectiveDate = opStatus.OperationalStatusEffectiveDate
						left outer join rds.DimK12SchoolStatuses schStatus 
							on fact.SchoolStatusId = schStatus.DimK12SchoolStatusId
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