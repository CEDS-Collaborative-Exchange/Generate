-----------------------------------------------
--Staging.ProgramParticipationNeglectedOrDelinquent
-----------------------------------------------
    --Drop the extended properties for SchoolYear,	DataCollectionName
    --  they are added back after the new column to keep the structure of the table clean    

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationTitleIII' AND c.name = 'DataCollectionName' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationTitleIII' AND c.name = 'SchoolYear' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        END

    --Drop the indexes that exist
        IF EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers')
        BEGIN
            DROP INDEX IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers ON Staging.ProgramParticipationTitleIII;
        END

         IF EXISTS (
            SELECT 1 
            FROM sys.indexes 
            WHERE name = 'IX_Staging_ProgramParticipationTitleIII_DataCollectionName'
        )
        BEGIN
            DROP INDEX IX_Staging_ProgramParticipationTitleIII_DataCollectionName ON Staging.ProgramParticipationTitleIII;
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationTitleIII DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationTitleIII DROP COLUMN DataCollectionName;
        END

    --Add the new column
        IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'EnglishLearnersExitedStatus') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationTitleIII ADD EnglishLearnersExitedStatus BIT NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationTitleIII ADD SchoolYear SMALLINT NULL;
        END
 
        IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationTitleIII ADD DataCollectionName NVARCHAR(100);
        END

        --Add the index back
        IF NOT EXISTS (
            SELECT 1 
            FROM sys.indexes 
            WHERE name = 'IX_Staging_ProgramParticipationTitleIII_DataCollectionName'
            AND object_id = OBJECT_ID('Staging.ProgramParticipationTitleIII')
        )
        BEGIN
            CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationTitleIII_DataCollectionName
            ON Staging.ProgramParticipationTitleIII (DataCollectionName);
        END

        --Add the extended proprties for the new column and the re-added columns
         IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationTitleIII' AND c.name = 'EnglishLearnersExitedStatus' )
         BEGIN
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that students were served for at least 90 consecutive days during the reporting period by Title I, Part D of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnersExitedStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Neglected or Delinquent Long Term Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnersExitedStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnersExitedStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=00000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnersExitedStatus'
            EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'EnglishLearnersExitedStatus'
        END
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

-----------------------------------------------
--Staging.ProgramParticipationNorD
-----------------------------------------------
    --Drop the extended properties for SchoolYear,	DataCollectionName
    --  they are added back after the new column to keep the structure of the table clean    

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationNorD' AND c.name = 'DataCollectionName' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationNorD' AND c.name = 'SchoolYear' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationNorD' AND c.name = 'RunDateTime' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'RunDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'RunDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'RunDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'RunDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'RunDateTime'
        END

    --Drop the indexes that exist
        IF EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_ProgramParticipationNorD_DataCollectionName')
        BEGIN
            DROP INDEX IX_Staging_ProgramParticipationNorD_DataCollectionName ON Staging.ProgramParticipationNorD;
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN DataCollectionName;
        END

        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN RunDateTime;
        END

    --Add the new column
        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedOrDelinquentLongTermStatus') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedOrDelinquentLongTermStatus BIT NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD ADD SchoolYear SMALLINT NULL;
        END
 
        IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.ProgramParticipationNorD ADD DataCollectionName NVARCHAR(100);
        END

        --Add the index back
        IF NOT EXISTS (
            SELECT 1 
            FROM sys.indexes 
            WHERE name = 'IX_Staging_ProgramParticipationNorD_DataCollectionName'
            AND object_id = OBJECT_ID('Staging.ProgramParticipationNorD')
        )
        BEGIN
            CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationNorD_DataCollectionName 
				ON Staging.ProgramParticipationNorD (DataCollectionName);
        END

        --Add the extended proprties for the new column and the re-added columns
         IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'ProgramParticipationNorD' AND c.name = 'NeglectedOrDelinquentLongTermStatus' )
         BEGIN
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication that students were served for at least 90 consecutive days during the reporting period by Title I, Part D of ESEA as amended.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentLongTermStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Neglected or Delinquent Long Term Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentLongTermStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentLongTermStatus'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=00000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentLongTermStatus'
            EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'NeglectedOrDelinquentLongTermStatus'
        END
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

