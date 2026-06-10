CREATE VIEW [debug].[vwSchoolPerformanceIndicators_StagingTables]
AS
SELECT
	sspfi.SchoolYear
	, sspfi.LeaIdentifierSea
	, sspfi.SchoolIdentifierSea
	, sspfi.SchoolPerformanceIndicatorCategory
	, sspfi.SchoolPerformanceIndicatorType
	, sspfi.SchoolPerformanceIndicatorStatus
	, sspfi.SchoolPerformanceIndicatorStateDefinedStatus
	, sspfi.SchoolPerformanceIndicatorStateDefinedStatusDescription
	, sspfi.Race
	, sspfi.IdeaIndicator
	, sspfi.EnglishLearnerStatus
	, sspfi.EconomicDisadvantageStatus
	, sspfi.SubgroupCode
FROM Staging.SchoolPerformanceIndicators sspfi
WHERE 1 = 1
AND SchoolIdentifierSea IS NOT NULL -- Remove records that are only LEAs by checking for populated school identifier
