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
END;
