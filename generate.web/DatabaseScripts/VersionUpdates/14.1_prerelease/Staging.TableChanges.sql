-- Correct misspelled "StatedDefined" columns to "StateDefined"
IF COL_LENGTH('Staging.OrganizationCustomSchoolIndicatorStatusType', 'StatedDefinedIndicatorStatus') IS NOT NULL
   AND COL_LENGTH('Staging.OrganizationCustomSchoolIndicatorStatusType', 'StateDefinedIndicatorStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.OrganizationCustomSchoolIndicatorStatusType.StatedDefinedIndicatorStatus',
        'StateDefinedIndicatorStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.OrganizationCustomSchoolIndicatorStatusType', 'StatedDefinedCustomIndicatorStatusType') IS NOT NULL
   AND COL_LENGTH('Staging.OrganizationCustomSchoolIndicatorStatusType', 'StateDefinedCustomIndicatorStatusType') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.OrganizationCustomSchoolIndicatorStatusType.StatedDefinedCustomIndicatorStatusType',
        'StateDefinedCustomIndicatorStatusType',
        'COLUMN';
END;

IF COL_LENGTH('Staging.OrganizationSchoolIndicatorStatus', 'StatedDefinedIndicatorStatus') IS NOT NULL
   AND COL_LENGTH('Staging.OrganizationSchoolIndicatorStatus', 'StateDefinedIndicatorStatus') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.OrganizationSchoolIndicatorStatus.StatedDefinedIndicatorStatus',
        'StateDefinedIndicatorStatus',
        'COLUMN';
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
