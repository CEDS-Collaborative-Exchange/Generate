PRINT 'Install test scripts'

PRINT 'Update Toggle'
DECLARE @SchoolYear SMALLINT = 2025
update App.ToggleResponses set ResponseValue = '10/01/' + CAST(@SchoolYear - 1 AS VARCHAR) where ToggleResponseId = 1

DECLARE  @DimSchoolYearId INT
SELECT @DimSchoolYearId = DimSchoolYearId FROM RDS.DimSchoolYears WHERE SchoolYear = @SchoolYear
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 0 
UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 1 WHERE DimSchoolYearId = @DimSchoolYearId

--Run any setup needed before executing the migrations
PRINT 'pre DMC'
EXEC [Staging].[pre_DMC] @SchoolYear

---- Load the IDS & RDS
PRINT 'Run DMC'
EXEC [Staging].[RUN_DMC] @SchoolYear