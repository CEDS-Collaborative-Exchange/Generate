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

--Doesn't belong here but didn't want to create a separate script for it.
IF NOT EXISTS (select *
				from sys.procedures p 
					join sys.schemas s
						on p.schema_id = s.schema_id
				where s.name = 'Source'
				and p.name = 'Source-to-Staging_EnglishLearnerAssessment'
)
BEGIN
	EXEC ('CREATE PROCEDURE [Source].[Source-to-Staging_EnglishLearnerAssessment] 
	@schoolYear smallint
AS
--BEGIN
	--State specific ETL code here
--END
')
END



--Add Additional Targeted Support and Improvement for FS206 (CIID-6987).
--FS206 reports Comprehensive, Targeted, and Additional Targeted Support; staging only had the first two.
IF COL_LENGTH(N'[Staging].[K12Organization]', N'School_AdditionalTargetedSupport') IS NULL
BEGIN
	ALTER TABLE Staging.K12Organization ADD School_AdditionalTargetedSupport VARCHAR(100) NULL;
END;
-- Staging table updates for release 14.1
