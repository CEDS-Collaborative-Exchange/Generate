CREATE OR ALTER PROCEDURE [App].[zz_DimK12Schools_Charter_NA_TestCase]
	@SchoolYear smallint = NULL
AS
BEGIN

	--This is a specific test that cannot be accomplished with our current Hydrate test data.  
	--	The School Level charter status field for Directory 029 has 3 possible values (Yes, No, NA)
	--	but to populate the NA value in RDS.DimK12Schools there must be 0 schools with Charter Indicator = 1.
	--	The current test data does not meet this criteria so the test scenario below will manually create
	--	the condition necessary to see this option.

	--NOTE: Testing Automation - This test needs to be run last because it resets all Schools so there are 
	--	none set as Charter which would affect several other tests.


	--Run Hydrate to populate the test data first, then follow these steps

	TRUNCATE TABLE RDS.FactOrganizationCounts
	TRUNCATE TABLE RDS.FactOrganizationStatusCounts
	DELETE FROM RDS.BridgeK12SchoolGradeLevels
	DELETE FROM RDS.BridgeLeaGradeLevels
	DELETE FROM RDS.DimK12Schools
	DELETE FROM RDS.DimLeas
	DELETE FROM RDS.DimSeas
	DELETE FROM RDS.DimIeus

	DBCC CHECKIDENT ('rds.dimseas', RESEED, 1);
	DBCC CHECKIDENT ('rds.dimieus', RESEED, 1);
	DBCC CHECKIDENT ('rds.dimleas', RESEED, 1);
	DBCC CHECKIDENT ('rds.dimk12schools', RESEED, 1);

	update staging.k12organization
	set School_CharterSchoolIndicator = 0
		, School_CharterPrimaryAuthorizer = null
		, School_CharterSecondaryAuthorizer = null

	exec [Staging].[Wrapper_Migrate_Directory_to_IDS] @SchoolYear

	--reset, then set the appropriate year for this migration
	update rds.DimSchoolYearDataMigrationTypes
	set IsSelected = 0

	update rds.DimSchoolYearDataMigrationTypes
	set IsSelected = 1
	from rds.DimSchoolYearDataMigrationTypes sydmt
	join rds.DimSchoolYears sy
		on sydmt.DimSchoolYearId = sy.DimSchoolYearId
	where SchoolYear = @SchoolYear
	
	exec App.Wrapper_Migrate_Directory_to_RDS

	--This should display the value as 'NA'
	select distinct CharterSchoolStatus from rds.dimk12schools

END