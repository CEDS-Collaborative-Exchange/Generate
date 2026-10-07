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

