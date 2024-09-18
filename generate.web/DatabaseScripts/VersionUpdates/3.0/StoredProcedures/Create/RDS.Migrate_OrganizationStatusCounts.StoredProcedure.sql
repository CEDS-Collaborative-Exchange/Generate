-- =============================================
-- Author:		Andy Tsovma
-- Create date: 10/31/2018
-- Description:	migrate organization rate statuses for c199 etc.
-- =============================================
/*
	RDS.Migrate_OrganizationStatusCounts @factTypeCode='datapopulation', @runAsTest=1
*/
CREATE PROCEDURE RDS.Migrate_OrganizationStatusCounts
	@factTypeCode as varchar(50) = 'datapopulation',
	@runAsTest as bit 
AS
BEGIN
begin try
begin transaction
	-- step 1 - migrate custom indicator statuses and state defined statuses
	declare @indicator as varchar(50), @idx as int
	if not exists (select * from [RDS].[DimStateDefinedStatuses] where [RDS].[DimStateDefinedStatuses].StateDefinedStatusCode='Missing')
		begin
			set identity_insert [RDS].[DimStateDefinedStatuses] on
			insert into [RDS].[DimStateDefinedStatuses] (
				[DimStateDefinedStatusId]
				,[StateDefinedStatusId]
				,[StateDefinedStatusCode]
				,[StateDefinedStatusDescription]) values (
				-1, -1, 'Missing', 'State Defined Status not set'
				)
			set identity_insert [RDS].[DimStateDefinedStatuses] off
		end
	set @idx = 1
	DECLARE indicatorstatus_cursor CURSOR FOR 
	select distinct IndicatorStatus from ods.K12SchoolIndicatorStatus where IndicatorStatus is not null and IndicatorStatus != ''
	OPEN indicatorstatus_cursor
	FETCH NEXT FROM indicatorstatus_cursor INTO @indicator

	WHILE @@FETCH_STATUS = 0
	begin
		print '@indicator='+@indicator
		if not exists (select * from [RDS].[DimStateDefinedStatuses] where [RDS].[DimStateDefinedStatuses].StateDefinedStatusCode=@indicator)
			begin
				insert into [RDS].[DimStateDefinedStatuses] (
					[StateDefinedStatusId]
					,[StateDefinedStatusCode]
					,[StateDefinedStatusDescription]) values (
					@idx, @indicator, 'State Defined Status '+@indicator
				)
			end
		set @idx = @idx + 1
		FETCH NEXT FROM indicatorstatus_cursor INTO @indicator
	end
	CLOSE indicatorstatus_cursor
	DEALLOCATE indicatorstatus_cursor

	-- transfer custom indicator
	-- insert Missing
	if not exists (select * from RDS.DimStateDefinedCustomIndicators where RDS.DimStateDefinedCustomIndicators.StateDefinedCustomIndicatorCode='Missing')
		begin
			set identity_insert RDS.DimStateDefinedCustomIndicators on
			insert into RDS.DimStateDefinedCustomIndicators (
				DimStateDefinedCustomIndicatorId,
				StateDefinedCustomIndicatorId
				,StateDefinedCustomIndicatorCode
				,StateDefinedCustomIndicatorDescription) values (
				-1, -1, 'Missing', 'State Defined Custom Indicator not set '
			)
			set identity_insert RDS.DimStateDefinedCustomIndicators off
		end
	-- insert new custom indicators
	set @idx = 1
	DECLARE indicatorcustomstatus_cursor CURSOR FOR 
	select distinct ic.Code
	from ods.K12SchoolIndicatorStatus k12
	inner join ods.RefIndicatorStatusCustomType ic on ic.RefIndicatorStatusCustomTypeId=k12.RefIndicatorStatusCustomTypeId

	OPEN indicatorcustomstatus_cursor
	FETCH NEXT FROM indicatorcustomstatus_cursor INTO @indicator

	WHILE @@FETCH_STATUS = 0
	begin
		print '@indicator='+@indicator
		if not exists (select * from RDS.DimStateDefinedCustomIndicators where RDS.DimStateDefinedCustomIndicators.StateDefinedCustomIndicatorCode=@indicator)
			begin
				insert into RDS.DimStateDefinedCustomIndicators (
					StateDefinedCustomIndicatorId
					,StateDefinedCustomIndicatorCode
					,StateDefinedCustomIndicatorDescription) values (
					@idx, @indicator, 'State Defined Custom Indicator '+@indicator
				)
			end
		set @idx = @idx + 1
		FETCH NEXT FROM indicatorcustomstatus_cursor INTO @indicator
	end
	CLOSE indicatorcustomstatus_cursor
	DEALLOCATE indicatorcustomstatus_cursor
/*
	RDS.Migrate_OrganizationStatusCounts @factTypeCode='datapopulation', @runAsTest=1
*/
	-- step 2 - everything else ===========================================================================================================
	declare @factTable as varchar(50)
	set @factTable = 'FactOrganizationStatusCounts'
	declare @dataMigrationTypeId as int
	declare @migrationType as varchar(50) = 'rds'
	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode -- 1 for datapopulation

	if @factTypeCode = 'datapopulation'
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'ods'
		set @migrationType='ods'
	end
	else
	begin
		select @dataMigrationTypeId = DataMigrationTypeId
		from app.DataMigrationTypes where DataMigrationTypeCode = 'rds'
		set @migrationType='rds'
	end

	-- delete existing fact records
	if @runAsTest = 0
		begin
			delete from rds.FactOrganizationStatusCounts where DimFactTypeId = @factTypeId
		end

	declare @IndicatorStatusType as varchar(100) = 'GraduationRateIndicatorStatus', @IndicatorStatusTypeId int
	-- indicatorstatustype cursor
	DECLARE indicatorstatustype_cursor CURSOR FOR 
	SELECT Code, RefIndicatorStatusTypeId
	FROM ods.RefIndicatorStatusType
	--order by ods.RefIndicatorStatusType.SortOrder

/*
	RDS.Migrate_OrganizationStatusCounts @factTypeCode='datapopulation', @runAsTest=1
*/
	OPEN indicatorstatustype_cursor
	FETCH NEXT FROM indicatorstatustype_cursor INTO @IndicatorStatusType, @IndicatorStatusTypeId

	WHILE @@FETCH_STATUS = 0
	begin
		print '@IndicatorStatusType='+@IndicatorStatusType

		-- variables for school_cursor
		declare @schoolOrganizationId int, @RefIndicatorStatusTypeId int, @RefIndicatorStateDefinedStatusId int, @RefIndicatorStatusSubgroupTypeId int,
		@IndicatorStatusSubgroup nvarchar(100), @IndicatorStatus nvarchar(100)

		-- Log history
		if @runAsTest = 0
		begin
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Start (' + @factTypeCode + ')')
		end

		-- Migrate_DimDates
		declare @DimOrganizationIndicatorStatus_Dates as rds.SchoolStatusTableType

		delete from @DimOrganizationIndicatorStatus_Dates
		declare @count int
		--select @count = Count('c') from @DimOrganizationIndicatorStatus_Dates
		--print 'before @count='+cast(@count as varchar(20))
		-- select SchoolId, StartDate, EndDate, s.Year, d.Year, d.DimDateId
		insert into @DimOrganizationIndicatorStatus_Dates
		(
			K12SchoolIndicatorStatusId,
			K12SchoolId,
			DimCountDateId,
			[Year],
			OrganizationId,
			DimSchoolId,
			RefIndicatorStatusTypeId
		)
		exec rds.Migrate_DimOrganizationIndicatorStatus_Dates @factTypeCode, @IndicatorStatusType

		select @count = Count('c') from @DimOrganizationIndicatorStatus_Dates
		print 'after @count='+cast(@count as varchar(20))

		--select * from @DimOrganizationIndicatorStatus_Dates
		--order by K12SchoolIndicatorStatusId
		/*
			RDS.Migrate_OrganizationStatusCounts @factTypeCode='datapopulation', @runAsTest=1
		*/	
		-- Migrate_DimRace
		declare @Race as table (
			K12SchoolIndicatorStatusId int, DimSchoolId int, OrganizationId int, DimCountDateId int, Race varchar(100), IndicatorStatus varchar(100), IndicatorStateDefinedStatus varchar(100), CustomIndicator varchar(100))
		insert into @Race (
			K12SchoolIndicatorStatusId,
			DimSchoolId,
			OrganizationId,
			DimCountDateId,
			Race,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolRace @DimOrganizationIndicatorStatus_Dates

		-- Migrate LEP 
		declare @Lep as table (K12SchoolIndicatorStatusId int, DimCountDateId int, LepStatusCode nvarchar(50), IndicatorStatus varchar(100), IndicatorStateDefinedStatus varchar(100), CustomIndicator varchar(100))
		insert into @Lep (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			LepStatusCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolLep @DimOrganizationIndicatorStatus_Dates
	
		-- migrate Idea
		declare @Idea as table (K12SchoolIndicatorStatusId int, DimCountDateId int, DisabilityCode varchar(100), IndicatorStatus varchar(100), IndicatorStateDefinedStatus varchar(100), CustomIndicator varchar(100))
		insert into @Idea (
			K12SchoolIndicatorStatusId,
			DimCountDateId,
			DisabilityCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolIdea @DimOrganizationIndicatorStatus_Dates
		--select * from @Idea --order by OrganizationId
	
		-- Migrate EcoDis status
		declare @Ecodis as table (K12SchoolIndicatorStatusId int, DimCountDateId int, EcoDisStatusCode nvarchar(50), IndicatorStatus varchar(100), IndicatorStateDefinedStatus varchar(100), CustomIndicator varchar(100))
		insert into @Ecodis (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			EcoDisStatusCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolEcodis @DimOrganizationIndicatorStatus_Dates
		--select * from @Ecodis --order by OrganizationId

		-- Migrate AllStudents status
		declare @AllStudents as table (K12SchoolIndicatorStatusId int, DimCountDateId int, AllStudentsCode nvarchar(50), IndicatorStatus varchar(100), IndicatorStateDefinedStatus varchar(100), CustomIndicator varchar(100))
		insert into @AllStudents (
			K12SchoolIndicatorStatusId, 
			DimCountDateId, 
			AllStudentsCode,
			IndicatorStatus,
			IndicatorStateDefinedStatus,
			CustomIndicator
		)
		exec RDS.Migrate_DimSchoolAllStudents @DimOrganizationIndicatorStatus_Dates

		--select K12SchoolIndicatorStatusId from @DimOrganizationIndicatorStatus_Dates

		--select d.K12SchoolIndicatorStatusId from @DimOrganizationIndicatorStatus_Dates d
		--inner join ods.K12SchoolIndicatorStatus stat on stat.K12SchoolIndicatorStatusId=d.K12SchoolIndicatorStatusId
		--where d.K12SchoolIndicatorStatusId not in (select K12SchoolIndicatorStatusId from @AllStudents)
		--and stat.IndicatorStatusSubgroup = 'AllStudents'
	

		--select * from @AllStudents --order by OrganizationId
	/*
		[RDS].[Migrate_OrganizationStatusCounts] @runAsTest=1
	*/

		--======================================= output =====================
		create table #queryOutput (
			QueryOutputId int IDENTITY(1,1) NOT NULL,
			K12SchoolIndicatorStatusId int,
			DimSchoolId int,
			DimCountDateId int,
			Race varchar(100),
			LepStatusCode varchar(100),
			DisabilityCode varchar(100),
			EcoDisStatusCode varchar(100),
			AllStudentsCode varchar(100),
			StateDefinedStatus varchar(100),
			Indicator varchar(100),
			CustomIndicator varchar(100),
			IndicatorStatusTypeCode varchar(100)
		)
		insert into #queryOutput
		(
			K12SchoolIndicatorStatusId,
			DimSchoolId,
			DimCountDateId,
			Race,
			LepStatusCode,
			DisabilityCode,
			EcoDisStatusCode,
			AllStudentsCode,
			StateDefinedStatus,
			Indicator,
			CustomIndicator,
			IndicatorStatusTypeCode
		)
		select 
			s.K12SchoolIndicatorStatusId,
			s.DimSchoolId, 
			s.DimCountDateId,
			isnull(race.Race, 'MISSING') as Race,
			isnull(lep.LepStatusCode, 'MISSING') as LepStatusCode,
			isnull(idea.DisabilityCode, 'MISSING') as DisabilityCode,
			isnull(ecodis.EcoDisStatusCode, 'MISSING') as EcoDisStatusCode,
			isnull(allstudents.AllStudentsCode, 'MISSING') as AllStudentsCode,
			case 
				when race.Race is not null then race.IndicatorStateDefinedStatus
				when lep.LepStatusCode is not null then lep.IndicatorStateDefinedStatus
				when idea.DisabilityCode is not null then idea.IndicatorStateDefinedStatus
				when ecodis.EcoDisStatusCode is not null then ecodis.IndicatorStateDefinedStatus
				when allstudents.AllStudentsCode is not null then allstudents.IndicatorStateDefinedStatus
			end,
			case 
				when race.Race is not null then race.IndicatorStatus
				when lep.LepStatusCode is not null then lep.IndicatorStatus
				when idea.DisabilityCode is not null then idea.IndicatorStatus
				when ecodis.EcoDisStatusCode is not null then ecodis.IndicatorStatus
				when allstudents.AllStudentsCode is not null then allstudents.IndicatorStatus
			end,
			case 
				when race.CustomIndicator is not null then race.CustomIndicator else 
					case when lep.CustomIndicator is not null then lep.CustomIndicator else 
						case when idea.CustomIndicator is not null then idea.CustomIndicator else 
							case when ecodis.CustomIndicator is not null then ecodis.CustomIndicator else 
								case when allstudents.CustomIndicator is not null then allstudents.CustomIndicator else 'Missing'
							end
						end
					end
				end
			end,
			isnull(statustype.Code, 'MISSING') as IndicatorStatusTypeCode
		from  @DimOrganizationIndicatorStatus_Dates s
		inner join ods.RefIndicatorStatusType statustype on statustype.RefIndicatorStatusTypeId=s.RefIndicatorStatusTypeId
		left join @Race race on race.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		left join @Lep lep on lep.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		left join @Idea idea on idea.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		left join @Ecodis ecodis on ecodis.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		left join @AllStudents allstudents on allstudents.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
	
		select * from #queryOutput
		order by DimSchoolId

	/*
		[RDS].[Migrate_OrganizationStatusCounts] @runAsTest=1
	*/

		-- Combine Dimension Data
		----------------------------
		-- Log history
		if @runAsTest = 0
		begin
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Combine Dimension Data')
		end

		-- Delete Old Facts
		----------------------------
		-- Log history
		if @runAsTest = 0
		begin
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Delete Old Facts')
		end

		-- Insert New Facts
		----------------------------
		-- Log history
		if @runAsTest = 0
		begin
			insert into app.DataMigrationHistories
			(DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) values	(getutcdate(), @dataMigrationTypeId, @factTable + ' - Insert New Facts')
		end
	
		if @runAsTest = 0
		begin
			insert into rds.FactOrganizationStatusCounts
			(
				DimFactTypeId,
				DimSchoolId,
				DimCountDateId,
				DimRaceId,
				DimIdeaStatusId,
				DimDemographicId,
				DimEcoDisStatusId,
				DimIndicatorStatusId,
				DimStateDefinedStatusId,
				OrganizationStatusCount,
				DimStateDefinedCustomIndicatorId,
				DimIndicatorStatusTypeId
			)
			select 
				@factTypeId as DimFactTypeId,
				DimSchoolId,
				DimCountDateId,
				isnull(races.DimRaceId, -1) as DimRaceId,				-- race
				isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,				-- idea
				isnull(demo.DimDemographicId, -1) as DimDemographicId,				-- lep
				isnull(ecodis.DimEcoDisStatusId, -1) as DimEcoDisStatusId,				-- idea
				isnull(sdf.DimIndicatorStatusId, -1) as DimIndicatorStatusId,				-- indicator status id
				isnull(indicator.DimStateDefinedStatusId, -1) as DimStateDefinedStatusId,				-- state defined status
				1,
				isnull(customindicator.DimStateDefinedCustomIndicatorId, -1) as DimStateDefinedCustomIndicatorId,				-- custom indicator id
				isnull(statustype.DimIndicatorStatusTypeId, -1) as DimIndicatorStatusTypeId				-- indicator status type
			from #queryOutput q
			inner join rds.DimIndicatorStatusTypes statustype on statustype.IndicatorStatusTypeCode = q.IndicatorStatusTypeCode
			left join rds.DimRaces races on races.RaceCode=q.Race and races.DimFactTypeId = @factTypeId
			left join ( 
				select top(1) rds.DimDemographics.DimDemographicId, rds.DimDemographics.LepStatusCode from rds.DimDemographics
				) as demo on demo.LepStatusCode=q.LepStatusCode
			left join ( 
				select top(1) rds.DimIdeaStatuses.DimIdeaStatusId, rds.DimIdeaStatuses.DisabilityCode from rds.DimIdeaStatuses
				) as idea on idea.DisabilityCode=q.DisabilityCode
			left join ( 
				select top(1) rds.DimDemographics.DimDemographicId as DimEcoDisStatusId, rds.DimDemographics.EcoDisStatusCode from rds.DimDemographics
				) as ecodis on ecodis.EcoDisStatusCode=q.EcoDisStatusCode
			left join rds.DimIndicatorStatuses sdf on sdf.IndicatorStatusCode=q.StateDefinedStatus
			left join rds.DimStateDefinedStatuses indicator on indicator.StateDefinedStatusCode = q.Indicator
			left join rds.DimStateDefinedCustomIndicators customindicator on customindicator.StateDefinedCustomIndicatorCode=q.CustomIndicator
			order by K12SchoolIndicatorStatusId
		end
		else
		begin
			print 'test'
			-- Run As Test (return data instead of inserting it)
			select 
				q.K12SchoolIndicatorStatusId,
				@factTypeId as DimFactTypeId,
				DimSchoolId,
				DimCountDateId,
				isnull(races.DimRaceId, -1) as DimRaceId,				-- race
				isnull(idea.DimIdeaStatusId, -1) as DimIdeaStatusId,				-- idea
				isnull(demo.DimDemographicId, -1) as DimDemographicId,				-- lep
				isnull(ecodis.DimEcoDisStatusId, -1) as DimEcoDisStatusId,				-- idea
				--races.DimRaceId as DimRaceId, 
				--idea.DimIdeaStatusId as DimIdeaStatusId,
				--demo.DimDemographicId as DimDemographicId,
				--ecodis.DimEcoDisStatusId as DimEcoDisStatusId,
				--case when q.AllStudentsCode = 'AllStudents' then 1 else -1 end as DimAllStudentsStatusId,		-- all students
				isnull(sdf.DimIndicatorStatusId, -1) as DimIndicatorStatusId,				-- indicator status id
				isnull(indicator.DimStateDefinedStatusId, -1) as DimStateDefinedStatusId,				-- state defined status
				1 as OrganizationCount,
				isnull(customindicator.DimStateDefinedCustomIndicatorId, -1) as DimStateDefinedCustomIndicatorId				-- custom indicator id
				,isnull(statustype.DimIndicatorStatusTypeId, -1) as DimIndicatorStatusTypeId				-- indicator status type
			from #queryOutput q
			inner join rds.DimIndicatorStatusTypes statustype on statustype.IndicatorStatusTypeCode = q.IndicatorStatusTypeCode
			left join rds.DimRaces races on races.RaceCode=q.Race and races.DimFactTypeId = @factTypeId
			left join ( 
				select top(1) rds.DimDemographics.DimDemographicId, rds.DimDemographics.LepStatusCode from rds.DimDemographics
				) as demo on demo.LepStatusCode=q.LepStatusCode
			left join ( 
				select top(1) rds.DimIdeaStatuses.DimIdeaStatusId, rds.DimIdeaStatuses.DisabilityCode from rds.DimIdeaStatuses
				) as idea on idea.DisabilityCode=q.DisabilityCode
			left join ( 
				select top(1) rds.DimDemographics.DimDemographicId as DimEcoDisStatusId, rds.DimDemographics.EcoDisStatusCode from rds.DimDemographics
				) as ecodis on ecodis.EcoDisStatusCode=q.EcoDisStatusCode
			left join rds.DimIndicatorStatuses sdf on sdf.IndicatorStatusCode=q.StateDefinedStatus
			left join rds.DimStateDefinedStatuses indicator on indicator.StateDefinedStatusCode = q.Indicator
			left join rds.DimStateDefinedCustomIndicators customindicator on customindicator.StateDefinedCustomIndicatorCode=q.CustomIndicator
			order by K12SchoolIndicatorStatusId
		end

		drop table #queryOutput
		FETCH NEXT FROM indicatorstatustype_cursor INTO @IndicatorStatusType, @IndicatorStatusTypeId
	end
	
	CLOSE indicatorstatustype_cursor
	DEALLOCATE indicatorstatustype_cursor

commit transaction
end try
/*
	RDS.Migrate_OrganizationStatusCounts @runAsTest=1
*/
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
END