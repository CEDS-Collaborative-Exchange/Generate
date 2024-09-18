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
							,[OrganizationId]
							,[OrganizationName]
							,[OrganizationNcesId]
							,[OrganizationStateId]
							,[ParentOrganizationStateId]
							'

							if @categorySetCode = 'csa'
								select @sql=@sql+' ,[RACE]'
							if @categorySetCode = 'csb'
								select @sql=@sql+' ,[DISABILITY]'
							if @categorySetCode = 'csc'
								select @sql=@sql+' ,[LEPSTATUS]'
							if @categorySetCode = 'csd'
								select @sql=@sql+' ,[ECODISSTATUS]'

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
							sch.StateCode, 
							sch.StateName,
							sch.schoolOrganizationId as OrganizationId,
							sch.SchoolName as OrganizationName,
							sch.SchoolNcesIdentifier,
							sch.SchoolStateIdentifier,
							sch.LeaStateIdentifier,'

							if @categorySetCode = 'csa'
								select @sql=@sql+' race.RaceCode,'
							if @categorySetCode = 'csb'
								select @sql=@sql+' idea.DisabilityEdFactsCode,'
							if @categorySetCode = 'csc'
								select @sql=@sql+' lep.LepStatusEdFactsCode,'
							if @categorySetCode = 'csd'
								select @sql=@sql+' eco.EcoDisStatusEdFactsCode,'

							select @sql=@sql+'
							indicatorstatus.IndicatorStatusCode,
							case when statedefined.StateDefinedStatusCode = ''Missing'' then '''' else statedefined.StateDefinedStatusCode end,
							1 as OrganizationStatusCount,
							customindicator.StateDefinedCustomIndicatorCode as StateDefinedCustomIndicatorCode,
							indicatorstatustype.IndicatorStatusTypeEdFactsCode as IndicatorStatusType
						from rds.FactOrganizationStatusCounts fact
						inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
						inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
						'
						if @categorySetCode = 'csa'
						select @sql=@sql+'
							inner join rds.DimRaces race on race.DimRaceId=fact.DimRaceId
						'
						if @categorySetCode = 'csb'
						select @sql=@sql+'
							inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.DimIdeaStatusId
						'
						if @categorySetCode = 'csc'
						select @sql=@sql+'
							inner join rds.DimDemographics lep on lep.DimDemographicId=fact.DimDemographicId
						'
						if @categorySetCode = 'csd'
						select @sql=@sql+'
							inner join rds.DimDemographics eco on eco.DimDemographicId=fact.DimEcoDisStatusId
						'

						select @sql=@sql+'
						inner join rds.DimIndicatorStatuses indicatorstatus on indicatorstatus.DimIndicatorStatusId=fact.DimIndicatorStatusId
						inner join rds.DimStateDefinedStatuses statedefined on statedefined.DimStateDefinedStatusId=fact.DimStateDefinedStatusId
						inner join rds.DimStateDefinedCustomIndicators customindicator on customindicator.DimStateDefinedCustomIndicatorId=fact.DimStateDefinedCustomIndicatorId
						inner join rds.DimIndicatorStatusTypes indicatorstatustype on indicatorstatustype.DimIndicatorStatusTypeId=fact.DimIndicatorStatusTypeId
						Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1 and indicatorstatustype.IndicatorStatusTypeEdFactsCode=@ReportTypeAbbreviation
						'
						if @categorySetCode = 'csa'
							select @sql=@sql+' and fact.DimRaceId <> -1 '
						if @categorySetCode = 'csb'
							select @sql=@sql+' and fact.DimIdeaStatusId <> -1 '
						if @categorySetCode = 'csc'
							select @sql=@sql+' and fact.DimDemographicId <> -1 '
						if @categorySetCode = 'csd'
							select @sql=@sql+' and fact.DimEcoDisStatusId <> -1 '
						if @categorySetCode = 'tot'
							select @sql=@sql+' and fact.DimRaceId = -1 and fact.DimIdeaStatusId = -1 and fact.DimDemographicId = -1 and fact.DimEcoDisStatusId = -1
						'
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
						sch.StateCode, 
						sch.StateName,
						sch.schoolOrganizationId as OrganizationId,
						sch.SchoolName as OrganizationName,
						sch.SchoolNcesIdentifier,
						sch.SchoolStateIdentifier,
						sch.LeaStateIdentifier,'

						if @categorySetCode = 'csa'
							select @sql=@sql+' race.RaceCode,'
						if @categorySetCode = 'csb'
							select @sql=@sql+' idea.DisabilityEdFactsCode,'
						if @categorySetCode = 'csc'
							select @sql=@sql+' lep.LepStatusEdFactsCode,'
						if @categorySetCode = 'csd'
							select @sql=@sql+' eco.EcoDisStatusEdFactsCode,'
						--if @categorySetCode = 'tot'
						--	select @sql=@sql+' null,'

						select @sql=@sql+'
						indicatorstatus.IndicatorStatusCode,
						case when statedefined.StateDefinedStatusCode = ''Missing'' then '''' else statedefined.StateDefinedStatusCode end StateDefinedStatusCode,
						1 as OrganizationStatusCount,
						customindicator.StateDefinedCustomIndicatorCode as StateDefinedCustomIndicatorCode,
						indicatorstatustype.IndicatorStatusTypeEdFactsCode as IndicatorStatusType
					from rds.FactOrganizationStatusCounts fact
					inner join rds.DimDates dates on fact.DimCountDateId = dates.DimDateId
					inner join rds.DimSchools sch on fact.DimSchoolId = sch.DimSchoolId
					'
					if @categorySetCode = 'csa'
					select @sql=@sql+'
						inner join rds.DimRaces race on race.DimRaceId=fact.DimRaceId
					'
					if @categorySetCode = 'csb'
					select @sql=@sql+'
						inner join rds.DimIdeaStatuses idea on idea.DimIdeaStatusId=fact.DimIdeaStatusId
					'
					if @categorySetCode = 'csc'
					select @sql=@sql+'
						inner join rds.DimDemographics lep on lep.DimDemographicId=fact.DimDemographicId
					'
					if @categorySetCode = 'csd'
					select @sql=@sql+'
						inner join rds.DimDemographics eco on eco.DimDemographicId=fact.DimEcoDisStatusId
					'

					select @sql=@sql+'
					inner join rds.DimIndicatorStatuses indicatorstatus on indicatorstatus.DimIndicatorStatusId=fact.DimIndicatorStatusId
					inner join rds.DimStateDefinedStatuses statedefined on statedefined.DimStateDefinedStatusId=fact.DimStateDefinedStatusId
					inner join rds.DimStateDefinedCustomIndicators customindicator on customindicator.DimStateDefinedCustomIndicatorId=fact.DimStateDefinedCustomIndicatorId
					inner join rds.DimIndicatorStatusTypes indicatorstatustype on indicatorstatustype.DimIndicatorStatusTypeId=fact.DimIndicatorStatusTypeId
					Where dates.SubmissionYear = @reportYear and sch.DimSchoolId <> -1 and indicatorstatustype.IndicatorStatusTypeEdFactsCode=@ReportTypeAbbreviation
					'
					if @categorySetCode = 'csa'
						select @sql=@sql+' and fact.DimRaceId <> -1 '
					if @categorySetCode = 'csb'
						select @sql=@sql+' and fact.DimIdeaStatusId <> -1 '
					if @categorySetCode = 'csc'
						select @sql=@sql+' and fact.DimDemographicId <> -1 '
					if @categorySetCode = 'csd'
						select @sql=@sql+' and fact.DimEcoDisStatusId <> -1 '
					if @categorySetCode = 'tot'
						select @sql=@sql+' and fact.DimRaceId = -1 and fact.DimIdeaStatusId = -1 and fact.DimDemographicId = -1 and fact.DimEcoDisStatusId = -1
					'
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

	IF exists(select 1 from app.GenerateReports where ReportCode=@reportCode and IsLocked=1)
	begin
		update app.GenerateReports set IsLocked=0 where ReportCode=@reportCode
	end
END