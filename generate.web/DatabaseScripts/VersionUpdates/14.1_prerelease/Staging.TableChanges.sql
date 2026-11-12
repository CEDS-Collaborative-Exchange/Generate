-- Staging table updates for release 14.1

--------------------------------------------------
--Column Renames/Redefines
--------------------------------------------------

    --ProgramParticipationTitleIII- Rename EnglishLearnerParticipation to TitleIIIEnglishLearnerParticipationStatus
    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'EnglishLearnerParticipation') IS NOT NULL
    AND COL_LENGTH('Staging.ProgramParticipationTitleIII', 'TitleIIIEnglishLearnerParticipationStatus') IS NULL
    BEGIN
        EXEC sp_rename
            'Staging.ProgramParticipationTitleIII.EnglishLearnerParticipation',
            'TitleIIIEnglishLearnerParticipationStatus',
            'COLUMN';
    END;

    --Drop the extended properties for the old column
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE 
    ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationTitleIII' AND c.name = 'EnglishLearnerParticipation' )
    BEGIN
        EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
    END;

    --Add the extended proprties for the new column
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE 
    ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationTitleIII' AND c.name = 'EnglishLearnerParticipation' )
    BEGIN
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that an English Learner student is served by an English language instruction educational program supported with Title III of ESEA funds.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title III English Learner Participation Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'P000565' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/desHome.aspx#/all/elements/A/P000565' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnerParticipation'
    END;

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
