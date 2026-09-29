CREATE PROCEDURE RDS.Migrate_DimK12SchoolIdea 
	@DimOrganizationIndicatorStatus_Dates AS SchoolStatusTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	SELECT 
		  s.K12SchoolIndicatorStatusId
		, s.DimCountDateId
		, 'AUT' AS DisabilityCode
		, stat.IndicatorStatus
		, statestatus.Code AS IndicatorStateDefinedStatus
		, customind.Code AS CustomIndicator
	FROM @DimOrganizationIndicatorStatus_Dates s
	JOIN dbo.K12SchoolIndicatorStatus stat 
		ON stat.K12SchoolIndicatorStatusId = s.K12SchoolIndicatorStatusId
		AND (@dataCollectionId IS NULL 
			OR stat.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefIndicatorStatusSubgroupType subgroup 
		ON subgroup.RefIndicatorStatusSubgroupTypeId = stat.RefIndicatorStatusSubgroupTypeId
	JOIN dbo.RefIndicatorStateDefinedStatus statestatus 
		ON statestatus.RefIndicatorStateDefinedStatusId=stat.RefIndicatorStateDefinedStatusId
	LEFT JOIN dbo.RefIndicatorStatusCustomType customind 
		ON customind.RefIndicatorStatusCustomTypeId=stat.RefIndicatorStatusCustomTypeId
	WHERE subgroup.Code = 'DisabilityStatus'
END