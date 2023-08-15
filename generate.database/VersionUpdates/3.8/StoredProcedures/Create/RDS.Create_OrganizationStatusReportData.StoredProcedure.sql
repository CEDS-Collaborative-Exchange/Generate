CREATE PROCEDURE [RDS].[Create_OrganizationStatusReportData]
	@reportCode as varchar(50),
	@runAsTest as bit
AS

BEGIN
	declare @dataMigrationTypeId as int, @dimFactTypeId as int

	select @dimFactTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = 'organizationstatus'
	select  @dataMigrationTypeId = DataMigrationTypeId from app.DataMigrationTypes where DataMigrationTypeCode = 'report'
	
	--print '@dimFactTypeId='+cast(@dimFactTypeId as varchar(10)) + ', @dataMigrationTypeId='+cast(@dataMigrationTypeId as varchar(10))

	-- Get Fact/Report Tables/Fields
	declare @factTable as varchar(50)
	declare @factField as varchar(50)
	declare @factReportTable as varchar(50)
	declare @ReportTypeAbbreviation as varchar(50)

	select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName
	, @ReportTypeAbbreviation = r.ReportTypeAbbreviation
	from app.FactTables ft 
	inner join app.GenerateReports r on ft.FactTableId = r.FactTableId
	where r.ReportCode = @reportCode

	--print '@factTable='+@factTable+', @factField='+@factField+', @factReportTable='+@factReportTable+', @ReportTypeAbbreviation='+@ReportTypeAbbreviation

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
	inner join rds.DimSchoolYears d on d.SchoolYear = cs.SubmissionYear
	inner join rds.DimSchoolYearDataMigrationTypes dd on dd.DimSchoolYearId = d.DimSchoolYearId and dd.IsSelected=1 and dd.DataMigrationTypeId=@dataMigrationTypeId
	inner join app.GenerateReports r on r.GenerateReportId = cs.GenerateReportId and r.ReportCode = @reportCode
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
		print 'Loop through Category Sets for this Submission Year'
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
		declare @sql nvarchar(max)
		declare @ParmDefinition as nvarchar(max)

		--SELECT cs.CategorySetId, o.LevelCode, cs.CategorySetCode
		--from app.CategorySets cs
		--inner join app.GenerateReports r on cs.GenerateReportId = r.GenerateReportId
		--inner join app.OrganizationLevels o on cs.OrganizationLevelId = o.OrganizationLevelId
		--where r.ReportCode = @reportCode and cs.SubmissionYear = @reportYear

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
			print 'loop through categoryset'
			print '@categorySetId='+cast(@categorySetId as varchar(10))+', @reportLevel='+@reportLevel+', @categorySetCode='+@categorySetCode
			/*
				[RDS].[Create_OrganizationStatusReportData] @reportCode = 'c201', @runAsTest=0
			*/
			if @runAsTest = 0
			begin
				insert into app.DataMigrationHistories
				(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values	(getutcdate(), @dataMigrationTypeId, 'Submission Report - ' + @reportYear + ' - ' + convert(varchar(20), @categorySetCntr) + ' of ' + convert(varchar(20), @categorySetCnt) + ' / ' + @reportCode + '-' + @reportLevel + '-' + @categorySetCode)
				if(@reportLevel = 'sch')
					begin
						select @sql=N'
						INSERT INTO [RDS].[FactOrganizationStatusCountReports]
							(
							[CategorySetCode]
							,[ReportCode]
							,[ReportLevel]
							,[ReportYear]
							,[StateANSICode]
							,[StateCode]
							,[StateName]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[ParentOrganizationStateId]
							'
							IF (@reportCode = 'c202')
							BEGIN
								if @categorySetCode IN ('csa','csa1')
									select @sql=@sql+' ,[RACE]'
								if @categorySetCode IN ('csb','csb1')
									select @sql=@sql+' ,[DISABILITY]'
								if @categorySetCode IN ('csc','csc1')
									select @sql=@sql+' ,[LEPSTATUS]'
								if @categorySetCode IN ('csd','csd1')
									select @sql=@sql+' ,[ECODISSTATUS]'
							END
							ELSE
							BEGIN
								if @categorySetCode = 'csa'
									select @sql=@sql+' ,[RACE]'
								if @categorySetCode = 'csb'
									select @sql=@sql+' ,[DISABILITY]'
								if @categorySetCode = 'csc'
									select @sql=@sql+' ,[LEPSTATUS]'
								if @categorySetCode = 'csd'
									select @sql=@sql+' ,[ECODISSTATUS]'
							END						

							select @sql=@sql+'
							,[INDICATORSTATUS]
							,[STATEDEFINEDSTATUSCODE]
							,OrganizationStatusCount
							,STATEDEFINEDCUSTOMINDICATORCODE
							,INDICATORSTATUSTYPECODE
						)
						'
						select @sql=@sql+'
						select 
							@categorySetCode,
							@reportCode, 
							@reportLevel, 
							@reportYear,
							sch.StateANSICode, 
							sch.StateAbbreviationCode, 
							sch.StateAbbreviationDescription,
							sch.NameOfInstitution as OrganizationName,
							sch.SchoolIdentifierNces,
							sch.SchoolIdentifierState,
							sch.LeaIdentifierState,'

							IF (@reportCode = 'c202')
							BEGIN
								if @categorySetCode IN ('csa','csa1')
									select @sql=@sql+' race.RaceEdFactsCode,'
								if @categorySetCode IN ('csb','csb1')
									select @sql=@sql+' ''WDIS'','
								if @categorySetCode IN ('csc','csc1')
									select @sql=@sql+' lep.EnglishLearnerStatusEdFactsCode,'
								if @categorySetCode IN ('csd','csd1')
									select @sql=@sql+' eco.EconomicDisadvantageStatusEdFactsCode,'	
							END
							ELSE
							BEGIN
								if @categorySetCode = 'csa'
									select @sql=@sql+' race.RaceEdFactsCode,'
								if @categorySetCode = 'csb'
									select @sql=@sql+' idea.PrimaryDisabilityTypeEdFactsCode,'
								if @categorySetCode = 'csc'
									select @sql=@sql+' lep.EnglishLearnerStatusEdFactsCode,'
								if @categorySetCode = 'csd'
									select @sql=@sql+' eco.EconomicDisadvantageStatusEdFactsCode,'
							END	
							

							select @sql=@sql+'
							indicatorstatus.IndicatorStatusCode,
							case when statedefined.StateDefinedStatusCode = ''Missing'' then '''' else statedefined.StateDefinedStatusCode end,
							1 as OrganizationStatusCount,
							customindicator.StateDefinedCustomIndicatorCode as StateDefinedCustomIndicatorCode,
							indicatorstatustype.IndicatorStatusTypeEdFactsCode as IndicatorStatusType
						from rds.FactOrganizationStatusCounts fact
						inner join rds.DimSchoolYears dates on fact.SchoolYearId = dates.DimSchoolYearId
						inner join rds.DimK12Schools sch on fact.K12SchoolId = sch.DimK12SchoolId
						'
						IF (@reportCode = 'c202')
						BEGIN
								if @categorySetCode IN ('csa','csa1')
									select @sql=@sql+'
									inner join rds.DimRaces race on race.DimRaceId=fact.RaceId
								'
								if @categorySetCode IN ('csb','csb1')
									select @sql=@sql+'
									inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.IdeaStatusId
								'
								if @categorySetCode IN ('csc','csc1')
									select @sql=@sql+'
									inner join rds.DimK12Demographics lep on lep.DimK12DemographicId=fact.K12DemographicId
								'
								if @categorySetCode IN ('csd','csd1')
									select @sql=@sql+'
									inner join rds.DimK12Demographics eco on eco.DimK12DemographicId=fact.EcoDisStatusId
								'
						END
						ELSE
						BEGIN
								if @categorySetCode = 'csa'
									select @sql=@sql+'
									inner join rds.DimRaces race on race.DimRaceId=fact.RaceId
								'
								if @categorySetCode = 'csb'
									select @sql=@sql+'
									inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.IdeaStatusId
								'
								if @categorySetCode = 'csc'
									select @sql=@sql+'
									inner join rds.DimK12Demographics lep on lep.DimK12DemographicId=fact.K12DemographicId
								'
								if @categorySetCode = 'csd'
									select @sql=@sql+'
									inner join rds.DimK12Demographics eco on eco.DimK12DemographicId=fact.EcoDisStatusId
								'
						END							

						select @sql=@sql+'
						inner join rds.DimIndicatorStatuses indicatorstatus on indicatorstatus.DimIndicatorStatusId=fact.IndicatorStatusId
						inner join rds.DimStateDefinedStatuses statedefined on statedefined.DimStateDefinedStatusId=fact.StateDefinedStatusId
						inner join rds.DimStateDefinedCustomIndicators customindicator on customindicator.DimStateDefinedCustomIndicatorId=fact.StateDefinedCustomIndicatorId
						inner join rds.DimIndicatorStatusTypes indicatorstatustype on indicatorstatustype.DimIndicatorStatusTypeId=fact.IndicatorStatusTypeId
						Where dates.SchoolYear = @reportYear and sch.DimK12SchoolId <> -1 and indicatorstatustype.IndicatorStatusTypeEdFactsCode=@ReportTypeAbbreviation
						'
						IF (@reportCode = 'c202')
						BEGIN
							if @categorySetCode IN ('csa','csa1')
								select @sql=@sql+' and fact.RaceId <> -1 '
							if @categorySetCode IN ('csb','csb1')
								select @sql=@sql+' and fact.IdeaStatusId <> -1 '
							if @categorySetCode IN ('csc','csc1')
								select @sql=@sql+' and fact.K12DemographicId <> -1 '
							if @categorySetCode IN ('csd','csd1')
								select @sql=@sql+' and fact.EcoDisStatusId <> -1 '
							if @categorySetCode IN ('tot','tot1')
								select @sql=@sql+' and fact.RaceId = -1 and fact.IdeaStatusId = -1 and fact.K12DemographicId = -1
							'
						END
						ELSE
						BEGIN
							if @categorySetCode = 'csa'
								select @sql=@sql+' and fact.RaceId <> -1 '
							if @categorySetCode = 'csb'
								select @sql=@sql+' and fact.IdeaStatusId <> -1 '
							if @categorySetCode = 'csc'
								select @sql=@sql+' and fact.K12DemographicId <> -1 '
							if @categorySetCode = 'csd'
								select @sql=@sql+' and fact.EcoDisStatusId <> -1 '
							if @categorySetCode = 'tot'
								select @sql=@sql+' and fact.RaceId = -1 and fact.IdeaStatusId = -1 and fact.K12DemographicId = -1
							'
						END	
						
				end
				SET @ParmDefinition = N'@categorySetCode varchar(50), @reportCode varchar(50), @reportLevel varchar(5), @reportYear varchar(50), @ReportTypeAbbreviation varchar(50)';  
				--print @sql
				EXECUTE sp_executesql @sql, @ParmDefinition, @categorySetCode = @categorySetCode, @reportCode = @reportCode, @reportLevel = @reportLevel, @reportYear=@reportYear, @ReportTypeAbbreviation=@ReportTypeAbbreviation;
			end
			else
			begin
				/*
					[RDS].[Create_OrganizationStatusReportData] @reportCode = 'c202', @runAsTest=1
				*/
				if(@reportLevel = 'sch')
				begin
					select @sql = N'
					select 
						@categorySetCode,
						@reportCode, 
						@reportLevel, 
						@reportYear,
						sch.StateANSICode, 
						sch.StateAbbreviationCode, 
						sch.StateAbbreviationDescription,
						sch.SchoolName as OrganizationName,
						sch.SchoolIdentifierNces,
						sch.SchoolIdentifierState,
						sch.LeaIdentifierState,'
						
						IF(@reportCode = 'c202')
						BEGIN
							if @categorySetCode IN ('csa','csa1')
								select @sql=@sql+' race.RaceEdFactsCode,'
							if @categorySetCode IN ('csb','csb1')
								select @sql=@sql+' ''WDIS'','
							if @categorySetCode IN ('csc','csc1')
								select @sql=@sql+' lep.LepStatusEdFactsCode,'
							if @categorySetCode IN ('csd','csd1')
								select @sql=@sql+' eco.EcoDisStatusEdFactsCode,'
							--if @categorySetCode = 'tot'
							--	select @sql=@sql+' null,'
						END
						ELSE
						BEGIN
							if @categorySetCode = 'csa'
								select @sql=@sql+' race.RaceEdFactsCode,'
							if @categorySetCode = 'csb'
								select @sql=@sql+' idea.DisabilityEdFactsCode,'
							if @categorySetCode = 'csc'
								select @sql=@sql+' lep.LepStatusEdFactsCode,'
							if @categorySetCode = 'csd'
								select @sql=@sql+' eco.EcoDisStatusEdFactsCode,'
							--if @categorySetCode = 'tot'
							--	select @sql=@sql+' null,'
						END

						

						select @sql=@sql+'
						indicatorstatus.IndicatorStatusCode,
						case when statedefined.StateDefinedStatusCode = ''Missing'' then '''' else statedefined.StateDefinedStatusCode end StateDefinedStatusCode,
						1 as OrganizationStatusCount,
						customindicator.StateDefinedCustomIndicatorCode as StateDefinedCustomIndicatorCode,
						indicatorstatustype.IndicatorStatusTypeEdFactsCode as IndicatorStatusType
					from rds.FactOrganizationStatusCounts fact
					inner join rds.DimSchoolYears dates on fact.SchoolYearId = dates.DimSchoolYearId
					inner join rds.DimK12Schools sch on fact.K12SchoolId = sch.DimK12SchoolId
					'
					IF(@reportCode = 'c202')
					BEGIN
						if @categorySetCode IN ('csa','csa1')
							select @sql=@sql+'
							inner join rds.DimRaces race on race.DimRaceId=fact.RaceId
						'
						if @categorySetCode IN ('csb','csb1')
							select @sql=@sql+'
							inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.IdeaStatusId
						'
						if @categorySetCode IN ('csc','csc1')
							select @sql=@sql+'
							inner join rds.DimK12Demographics lep on lep.DimK12DemographicId=fact.K12DemographicId
						'
						if @categorySetCode IN ('csd','csd1')
							select @sql=@sql+'
							inner join rds.DimDemographics eco on eco.DimDemographicId=fact.EcoDisStatusId
						'
					END
					ELSE
					BEGIN
						if @categorySetCode = 'csa'
							select @sql=@sql+'
							inner join rds.DimRaces race on race.DimRaceId=fact.RaceId
						'
						if @categorySetCode = 'csb'
							select @sql=@sql+'
							inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.IdeaStatusId
						'
						if @categorySetCode = 'csc'
							select @sql=@sql+'
							inner join rds.DimK12Demographics lep on lep.DimK12DemographicId=fact.K12DemographicId
						'
						if @categorySetCode = 'csd'
							select @sql=@sql+'
							inner join rds.DimDemographics eco on eco.DimDemographicId=fact.EcoDisStatusId
						'
					END
					

					select @sql=@sql+'
					inner join rds.DimIndicatorStatuses indicatorstatus on indicatorstatus.DimIndicatorStatusId=fact.IndicatorStatusId
					inner join rds.DimStateDefinedStatuses statedefined on statedefined.DimStateDefinedStatusId=fact.StateDefinedStatusId
					inner join rds.DimStateDefinedCustomIndicators customindicator on customindicator.DimStateDefinedCustomIndicatorId=fact.StateDefinedCustomIndicatorId
					inner join rds.DimIndicatorStatusTypes indicatorstatustype on indicatorstatustype.DimIndicatorStatusTypeId=fact.IndicatorStatusTypeId
					Where dates.SchoolYear = @reportYear and sch.DimK12SchoolId <> -1 and indicatorstatustype.IndicatorStatusTypeEdFactsCode=@ReportTypeAbbreviation
					'
					IF (@reportCode = 'c202')
					BEGIN
						if @categorySetCode IN ('csa','csa1')
							select @sql=@sql+' and fact.RaceId <> -1 '
						if @categorySetCode IN ('csb','csb1')
							select @sql=@sql+' and fact.IdeaStatusId <> -1 '
						if @categorySetCode IN ('csc','csc1')
							select @sql=@sql+' and fact.K12DemographicId <> -1 '
						if @categorySetCode IN ('csd','csd1')
							select @sql=@sql+' and fact.EcoDisStatusId <> -1 '
						if @categorySetCode IN ('tot','tot1')
							select @sql=@sql+' and fact.RaceId = -1 and fact.IdeaStatusId = -1 and fact.K12DemographicId = -1
						'
					END
					ELSE
					BEGIN
						if @categorySetCode = 'csa'
							select @sql=@sql+' and fact.RaceId <> -1 '
						if @categorySetCode = 'csb'
							select @sql=@sql+' and fact.IdeaStatusId <> -1 '
						if @categorySetCode = 'csc'
							select @sql=@sql+' and fact.K12DemographicId <> -1 '
						if @categorySetCode = 'csd'
							select @sql=@sql+' and fact.EcoDisStatusId <> -1 '
						if @categorySetCode = 'tot'
							select @sql=@sql+' and fact.RaceId = -1 and fact.IdeaStatusId = -1 and fact.K12DemographicId = -1
						'
					END
				end
				SET @ParmDefinition = N'@categorySetCode varchar(50), @reportCode varchar(50), @reportLevel varchar(5), @reportYear varchar(50), @ReportTypeAbbreviation varchar(50)';  
				--print @sql
				EXECUTE sp_executesql @sql, @ParmDefinition, @categorySetCode = @categorySetCode, @reportCode = @reportCode, @reportLevel = @reportLevel, @reportYear=@reportYear, @ReportTypeAbbreviation=@ReportTypeAbbreviation;
				/*
					[RDS].[Create_OrganizationStatusReportData] @reportCode = 'c201', @runAsTest=1
				*/
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

	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1)
	begin
		update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode and IsLocked=1 and UseLegacyReportMigration = 1
	end
END