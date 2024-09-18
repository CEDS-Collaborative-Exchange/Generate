-- =============================================
-- Author:		Andy Tsovma
-- Create date: 11/1/2018
-- Description:	create temp table for schoolindicatorstatusdates
-- =============================================
CREATE PROCEDURE [RDS].[Migrate_DimOrganizationIndicatorStatus_Dates]
	@factTypeCode as varchar(50) = 'datapopulation',
	@IndicatorStatusType as varchar(100)
AS
BEGIN
	declare @factTable as varchar(50)
	set @factTable = 'FactOrganizationIndicatorStatuses'
	declare @migrationType as varchar(50) = 'ods'
	declare @factTypeId as int
	select @factTypeId = DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode -- 1 for datapopulation

	-- variables for school_cursor
	declare @schoolOrganizationId int, @RefIndicatorStatusTypeId int, @RefIndicatorStateDefinedStatusId int, @RefIndicatorStatusSubgroupTypeId int,
	@IndicatorStatusSubgroup nvarchar(100), @IndicatorStatus nvarchar(100)

	-- Get Reference Period Start

	declare @referencePeriodStartMonth as varchar(2)
	set @referencePeriodStartMonth = 7
	declare @referencePeriodStartDay as varchar(2)
	set @referencePeriodStartDay = 1
	
	-- Get Reference Period End

	declare @referencePeriodEndMonth as varchar(2)
	set @referencePeriodEndMonth = 6
	declare @referencePeriodEndDay as varchar(2)
	set @referencePeriodEndDay = 30

	declare @SchoolStatusYear as table (K12SchoolIndicatorStatusId int, K12SchoolId int, RecordStartDateTime [datetime], [Year] int, StartDate date, EndDate date, RefIndicatorStatusTypeId int)
	insert into @SchoolStatusYear (
		K12SchoolIndicatorStatusId, K12SchoolId, RecordStartDateTime, [Year], StartDate, EndDate, RefIndicatorStatusTypeId
	)
	select k12status.K12SchoolIndicatorStatusId, k12status.K12SchoolId, k12status.RecordStartDateTime
	--,year(RecordStartDateTime) as Year
	,case 
		when k12status.RecordStartDateTime > datefromparts(year(k12status.RecordStartDateTime)-1, @referencePeriodStartMonth, @referencePeriodStartDay) 
		 and k12status.RecordStartDateTime <  datefromparts(year(k12status.RecordStartDateTime), @referencePeriodEndMonth, @referencePeriodEndDay) 
			then year(k12status.RecordStartDateTime)-1
		else year(k12status.RecordStartDateTime)
		 
		 end
	, datefromparts(year(k12status.RecordStartDateTime)-1, @referencePeriodStartMonth, @referencePeriodStartDay) as StartDate
	, datefromparts(year(k12status.RecordStartDateTime), @referencePeriodEndMonth, @referencePeriodEndDay) as EndDate
	, k12status.RefIndicatorStatusTypeId
	from ods.K12SchoolIndicatorStatus k12status
	inner join ods.RefIndicatorStatusType i on i.RefIndicatorStatusTypeId=k12status.RefIndicatorStatusTypeId
	where i.Code = @IndicatorStatusType		-- filter on different reports: c199='GraduationRateIndicatorStatus', c200 etc.
	and k12status.RecordEndDateTime is null


	declare @SchoolStatus as table (K12SchoolIndicatorStatusId int, K12SchoolId int, DimDateId int, [Year] int, RefIndicatorStatusTypeId int)
	insert into @SchoolStatus (K12SchoolIndicatorStatusId, K12SchoolId, DimDateId, [Year], RefIndicatorStatusTypeId)

	select s.K12SchoolIndicatorStatusId, s.K12SchoolId, d.DimDateId, d.Year, s.RefIndicatorStatusTypeId
	from @SchoolStatusYear s
	cross join rds.DimDates d
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
	inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
	where d.DimDateId <> -1 
	and dd.IsSelected=1 
	and DataMigrationTypeCode=@migrationType
	and s.Year= d.Year

	select ss.K12SchoolIndicatorStatusId, ss.K12SchoolId, ss.DimDateId, ss.Year
	, school.OrganizationId
	, sch.DimSchoolId
	, ss.RefIndicatorStatusTypeId
	from  @SchoolStatus ss
	inner join ods.K12School school on school.K12SchoolId=ss.K12SchoolId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId=school.OrganizationId
/*
	[RDS].[Migrate_DimOrganizationIndicatorStatus_Dates] @IndicatorStatusType='GraduationRateIndicatorStatus'
	[RDS].[Migrate_DimOrganizationIndicatorStatus_Dates] @IndicatorStatusType='AcademicAchievementIndicatorStatus'
	[RDS].[Migrate_DimOrganizationIndicatorStatus_Dates] @IndicatorStatusType='OtherAcademicIndicatorStatus'
	[RDS].[Migrate_DimOrganizationIndicatorStatus_Dates] @IndicatorStatusType='SchoolQualityOrStudentSuccessIndicatorStatus'
*/
END