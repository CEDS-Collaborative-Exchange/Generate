-- Staging table updates for release 14.1

--Remove the deprecated combined Comprehensive and Targeted Support element.
--It has been replaced by Comprehensive Support and Improvement, Targeted Support and Improvement,
--and Additional Targeted Support and Improvement.
IF COL_LENGTH(N'[Staging].[K12Organization]', N'School_ComprehensiveAndTargetedSupport') IS NOT NULL
BEGIN
	ALTER TABLE Staging.K12Organization DROP COLUMN School_ComprehensiveAndTargetedSupport;
END;

IF OBJECT_ID(N'[Staging].[OrganizationSchoolComprehensiveAndTargetedSupport]', N'U') IS NOT NULL
BEGIN
	DROP TABLE Staging.OrganizationSchoolComprehensiveAndTargetedSupport;
END;
