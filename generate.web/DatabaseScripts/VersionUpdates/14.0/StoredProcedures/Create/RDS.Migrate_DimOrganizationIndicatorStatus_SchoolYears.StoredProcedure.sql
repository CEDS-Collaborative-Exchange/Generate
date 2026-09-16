CREATE PROCEDURE [RDS].[Migrate_DimOrganizationIndicatorStatus_SchoolYears]
	@factTypeCode AS VARCHAR(50) = 'organizationstatus',
	@IndicatorStatusType AS VARCHAR(100),
	@dataCollectionId AS INT = NULL
AS
BEGIN
	DECLARE @factTable AS VARCHAR(50)
	SET @factTable = 'FactOrganizationIndicatorStatuses'
	DECLARE @migrationType AS VARCHAR(50) = 'ods'
	DECLARE @factTypeId AS INT
	SELECT @factTypeId = DimFactTypeId FROM rds.DimFactTypes WHERE FactTypeCode = @factTypeCode -- 1 for datapopulation

	-- variables for school_cursor
	DECLARE @schoolOrganizationId INT, @RefIndicatorStatusTypeId INT, @RefIndicatorStateDefinedStatusId INT, @RefIndicatorStatusSubgroupTypeId INT,
	@IndicatorStatusSubgroup NVARCHAR(100), @IndicatorStatus NVARCHAR(100)

	-- Get Reference Period Start

	DECLARE @referencePeriodStartMonth AS VARCHAR(2)
	SET @referencePeriodStartMonth = 7
	DECLARE @referencePeriodStartDay AS VARCHAR(2)
	SET @referencePeriodStartDay = 1
	
	-- Get Reference Period End

	DECLARE @referencePeriodEndMonth AS VARCHAR(2)
	SET @referencePeriodEndMonth = 6
	DECLARE @referencePeriodEndDay AS VARCHAR(2)
	SET @referencePeriodEndDay = 30

	DECLARE @SchoolStatusYear AS table (K12SchoolIndicatorStatusId INT, K12SchoolId INT, RecordStartDateTime [datetime], [Year] INT, StartDate date, EndDate date, RefIndicatorStatusTypeId INT)
	INSERT INTO @SchoolStatusYear (
		K12SchoolIndicatorStatusId, K12SchoolId, RecordStartDateTime, [Year], StartDate, EndDate, RefIndicatorStatusTypeId
	)
	SELECT 
		  k12status.K12SchoolIndicatorStatusId
		, k12status.K12SchoolId
		, k12status.RecordStartDateTime
		, CASE 
			WHEN k12status.RecordStartDateTime > datefromparts(year(k12status.RecordStartDateTime)-1, @referencePeriodStartMonth, @referencePeriodStartDay) 
				AND k12status.RecordStartDateTime < datefromparts(year(k12status.RecordStartDateTime), @referencePeriodEndMonth, @referencePeriodEndDay) 
				THEN year(k12status.RecordStartDateTime)-1
			ELSE year(k12status.RecordStartDateTime)
		  END
		, datefromparts(year(k12status.RecordStartDateTime)-1, @referencePeriodStartMonth, @referencePeriodStartDay) AS StartDate
		, datefromparts(year(k12status.RecordStartDateTime), @referencePeriodEndMonth, @referencePeriodEndDay) AS EndDate
		, k12status.RefIndicatorStatusTypeId
	FROM dbo.K12SchoolIndicatorStatus k12status
	JOIN dbo.RefIndicatorStatusType i 
		ON i.RefIndicatorStatusTypeId=k12status.RefIndicatorStatusTypeId
	WHERE i.Code = @IndicatorStatusType		-- filter ON different reports: c199='GraduationRateIndicatorStatus', c200 etc.
		AND (@dataCollectionId IS NULL 
			OR k12status.DataCollectionId = @dataCollectionId)	
		AND k12status.RecordEndDateTime IS NULL


	DECLARE @SchoolStatus AS TABLE (
		  K12SchoolIndicatorStatusId INT
		, K12SchoolId INT
		, DimSchoolYearId INT
		, SchoolYear INT
		, RefIndicatorStatusTypeId INT
		)
	INSERT INTO @SchoolStatus (
		  K12SchoolIndicatorStatusId
		, K12SchoolId
		, DimSchoolYearId
		, SchoolYear
		, RefIndicatorStatusTypeId
		)

	SELECT 
		  s.K12SchoolIndicatorStatusId
		, s.K12SchoolId
		, d.DimSchoolYearId
		, d.SchoolYear
		, s.RefIndicatorStatusTypeId
	FROM @SchoolStatusYear s
	CROSS JOIN rds.DimSchoolYears d
	JOIN rds.DimSchoolYearDataMigrationTypes dd 
		ON dd.DimSchoolYearId = d.DimSchoolYearId
	JOIN rds.DimDataMigrationTypes b 
		ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
	WHERE d.DimSchoolYearId <> -1 
		AND dd.IsSelected=1 
		AND DataMigrationTypeCode = @migrationType
		AND s.Year = d.SchoolYear

	SELECT 
		  ss.K12SchoolIndicatorStatusId
		, ss.K12SchoolId
		, ss.DimSchoolYearId
		, ss.SchoolYear
		, school.OrganizationId
		, sch.DimK12SchoolId
		, ss.RefIndicatorStatusTypeId
	FROM @SchoolStatus ss
	JOIN dbo.K12School school 
		ON school.K12SchoolId = ss.K12SchoolId
	JOIN rds.DimK12Schools sch 
		ON sch.SchoolOrganizationId = school.OrganizationId 
		AND sch.RecordEndDateTime IS NULL

END