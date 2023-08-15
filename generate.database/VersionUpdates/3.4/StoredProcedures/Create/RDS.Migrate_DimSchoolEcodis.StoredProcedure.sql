-- =============================================
-- Author:		Andy Tsovma
-- Create date: 11/5/2018
-- Description: migrate EcoDisadvantaged status
-- =============================================
CREATE PROCEDURE [RDS].[Migrate_DimSchoolEcodis]
	@DimOrganizationIndicatorStatus_Dates as SchoolStatusTableType READONLY
AS
BEGIN
	select 
		s.K12SchoolIndicatorStatusId,
		s.DimCountDateId,
		'EconomicDisadvantage' as EcoDisStatusCode,
		stat.IndicatorStatus,
		statestatus.Code as IndicatorStateDefinedStatus,
		customind.Code as CustomIndicator
	from @DimOrganizationIndicatorStatus_Dates s
	inner join ods.K12SchoolIndicatorStatus stat on stat.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
	inner join ods.RefIndicatorStatusSubgroupType subgroup on subgroup.RefIndicatorStatusSubgroupTypeId = stat.RefIndicatorStatusSubgroupTypeId
	inner join ods.RefIndicatorStateDefinedStatus statestatus on statestatus.RefIndicatorStateDefinedStatusId=stat.RefIndicatorStateDefinedStatusId
	left join ods.RefIndicatorStatusCustomType customind on customind.RefIndicatorStatusCustomTypeId=stat.RefIndicatorStatusCustomTypeId
	where subgroup.Code = 'EconomicallyDisadvantagedStatus'
END