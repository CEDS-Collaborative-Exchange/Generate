CREATE PROCEDURE RDS.Migrate_DimSchoolRace
	@DimOrganizationIndicatorStatus_Dates AS SchoolStatusTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	SELECT 
		  s.K12SchoolIndicatorStatusId
		, s.DimK12SchoolId
		, s.OrganizationId
		, s.DimCountDateId
		, CASE 
			WHEN stat.IndicatorStatusSubgroup = 'MA' THEN 'Asian'
			WHEN stat.IndicatorStatusSubgroup = 'MAN' THEN 'AmericanIndianorAlaskaNative'
			WHEN stat.IndicatorStatusSubgroup = 'MAP' THEN 'Asian'
			WHEN stat.IndicatorStatusSubgroup = 'MB' THEN 'BlackorAfricanAmerican'
			WHEN stat.IndicatorStatusSubgroup = 'MF' THEN 'NativeHawaiianorOtherPacificIslander'
			WHEN stat.IndicatorStatusSubgroup = 'MHL' THEN 'HispanicorLatinoEthnicity'
			WHEN stat.IndicatorStatusSubgroup = 'MHN' THEN 'HispanicorLatinoEthnicity'
			WHEN stat.IndicatorStatusSubgroup = 'MM' THEN 'TwoorMoreRaces'
			WHEN stat.IndicatorStatusSubgroup = 'MNP' THEN 'NativeHawaiianorOtherPacificIslander'
			WHEN stat.IndicatorStatusSubgroup = 'MPR' THEN 'HispanicorLatinoEthnicity'
			WHEN stat.IndicatorStatusSubgroup = 'MW' THEN 'White'
		  END AS Race
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
	WHERE subgroup.Code = 'RaceEthnicity'
	ORDER BY s.K12SchoolIndicatorStatusId
END