-- =============================================
-- Author:		Andy Tsovma
-- Create date: 11/5/2018
-- Description:	Migrate DimSchoolRace
-- =============================================
CREATE PROCEDURE RDS.Migrate_DimSchoolRace
	@DimOrganizationIndicatorStatus_Dates as SchoolStatusTableType READONLY
AS
BEGIN
	select 
		s.K12SchoolIndicatorStatusId,
		s.DimSchoolId,
		s.OrganizationId,
		s.DimCountDateId,
		case 
			when stat.IndicatorStatusSubgroup = 'MA' then 'Asian'
			when stat.IndicatorStatusSubgroup = 'MAN' then 'AmericanIndianorAlaskaNative'
			when stat.IndicatorStatusSubgroup = 'MAP' then 'Asian'
			when stat.IndicatorStatusSubgroup = 'MB' then 'BlackorAfricanAmerican'
			when stat.IndicatorStatusSubgroup = 'MF' then 'NativeHawaiianorOtherPacificIslander'
			when stat.IndicatorStatusSubgroup = 'MHL' then 'HI'
			when stat.IndicatorStatusSubgroup = 'MHN' then 'HI'
			when stat.IndicatorStatusSubgroup = 'MM' then 'TwoorMoreRaces'
			when stat.IndicatorStatusSubgroup = 'MNP' then 'NativeHawaiianorOtherPacificIslander'
			when stat.IndicatorStatusSubgroup = 'MPR' then 'HI'
			when stat.IndicatorStatusSubgroup = 'MW' then 'White'
		end as Race,
		stat.IndicatorStatus,
		statestatus.Code as IndicatorStateDefinedStatus,
		customind.Code as CustomIndicator
	from @DimOrganizationIndicatorStatus_Dates s
	inner join ods.K12SchoolIndicatorStatus stat on stat.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
	inner join ods.RefIndicatorStatusSubgroupType subgroup on subgroup.RefIndicatorStatusSubgroupTypeId = stat.RefIndicatorStatusSubgroupTypeId
	inner join ods.RefIndicatorStateDefinedStatus statestatus on statestatus.RefIndicatorStateDefinedStatusId=stat.RefIndicatorStateDefinedStatusId
	left join ods.RefIndicatorStatusCustomType customind on customind.RefIndicatorStatusCustomTypeId=stat.RefIndicatorStatusCustomTypeId
	where subgroup.Code = 'RaceEthnicity'
	order by s.K12SchoolIndicatorStatusId
END