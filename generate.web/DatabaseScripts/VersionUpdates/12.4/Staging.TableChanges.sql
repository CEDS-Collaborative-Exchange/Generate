-------------------------------------------
-- Source-to-Staging_MigrantEdProgram
-------------------------------------------
	IF OBJECT_ID('Source.Source-to-Staging_MigrantEdProgram', 'P') IS NOT NULL
	BEGIN
		EXEC sp_rename 'Source.Source-to-Staging_MigrantEdProgram', 'Source-to-Staging_MigrantEducationProgram';
	END	

-----------------------------------------------
--Staging.K12StaffAssignment add new column
-----------------------------------------------
    --Drop the extended properties for SchoolYear,	DataCollectionName,	RecordStartDateTime, RecordEndDateTime
    --  they are added back after the new column to keep the structure of the table clean    

         IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12StaffAssignment' AND c.name = 'RecordEndDateTime' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12StaffAssignment' AND c.name = 'RecordStartDateTime' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12StaffAssignment' AND c.name = 'DataCollectionName' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12StaffAssignment' AND c.name = 'SchoolYear' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.K12StaffAssignment', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.K12StaffAssignment', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment DROP COLUMN DataCollectionName;
        END

        IF COL_LENGTH('Staging.K12StaffAssignment', 'RecordStartDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment DROP COLUMN RecordStartDateTime;
        END

        IF COL_LENGTH('Staging.K12StaffAssignment', 'RecordEndDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment DROP COLUMN RecordEndDateTime;
        END

    --Add the new column
        IF COL_LENGTH('Staging.K12StaffAssignment', 'TitleIIILanguageInstructionIndicator') IS NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment ADD TitleIIILanguageInstructionIndicator BIT NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.K12StaffAssignment', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment ADD SchoolYear SMALLINT NULL;
        END
 
        IF COL_LENGTH('Staging.K12StaffAssignment', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment ADD DataCollectionName NVARCHAR(100);
        END

        IF COL_LENGTH('Staging.K12StaffAssignment', 'RecordStartDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment ADD RecordStartDateTime DATETIME NULL;
        END

        IF COL_LENGTH('Staging.K12StaffAssignment', 'RecordEndDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12StaffAssignment ADD RecordEndDateTime DATETIME NULL;
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
         AND t.name = 'K12StaffAssignment' AND c.name = 'TitleIIILanguageInstructionIndicator' )
         BEGIN
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'Indicates whether the staff member provides language instruction to students who are English learners.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIIILanguageInstructionIndicator'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Title III Language Instruction Indicator' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIIILanguageInstructionIndicator'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIIILanguageInstructionIndicator'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=00000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIIILanguageInstructionIndicator'
            EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIIILanguageInstructionIndicator'
        END
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'

------------------------------------------------
--ProgramParticipationSpecialEducation

--Drop DataCollectionName and RunDateTime, they are added back after 
--	the new column to keep the structure of the table clean
------------------------------------------------
	IF EXISTS (SELECT name 
	FROM sys.indexes
	WHERE name = N'IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers' )
	BEGIN
		DROP INDEX IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers ON Staging.ProgramParticipationSpecialEducation;
	END

    IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation DROP COLUMN RunDateTime;
    END
    
    --drop extended properties
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE ep.class_desc = 'OBJECT_OR_COLUMN'	
	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationSpecialEducation' 
	AND c.name = 'DataCollectionName' )
    BEGIN
        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Def_Desc', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Element',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_URL', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'MS_Description',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    END;

------------------------------------------------
--Add the SchoolYear column
------------------------------------------------

    IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation ADD SchoolYear SMALLINT NULL;
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation ADD DataCollectionName NVARCHAR(100) NULL;
    END

    IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation ADD RunDateTime DATETIME NULL;
    END

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SchoolYear'

	--add the index back
	CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationSpecialEducation_WithIdentifiers 
		ON Staging.ProgramParticipationSpecialEducation (DataCollectionName,StudentIdentifierState,LeaIdentifierSeaAccountability,LeaIdentifierSeaAttendance,LeaIdentifierSeaFunding,
			LeaIdentifierSeaGraduation,LeaIdentifierSeaIndividualizedEducationProgram,SchoolIdentifierSea,ProgramParticipationBeginDate,ProgramParticipationEndDate,SpecialEducationFTE);

------------------------------------------------
--ProgramParticipationTitleIII

--Drop DataCollectionName and RunDateTime, they are added back after 
--	the new column to keep the structure of the table clean
------------------------------------------------
	IF EXISTS (SELECT name 
	FROM sys.indexes
	WHERE name = N'IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers' )
	BEGIN
		DROP INDEX IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers ON Staging.ProgramParticipationTitleIII;
	END

    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII DROP COLUMN RunDateTime;
    END
    
    --drop extended properties
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE ep.class_desc = 'OBJECT_OR_COLUMN'	
	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationTitleIII' 
	AND c.name = 'DataCollectionName' )
    BEGIN
        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Def_Desc', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Element',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_URL', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'MS_Description',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    END;

------------------------------------------------
--Add the SchoolYear column
------------------------------------------------

    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII ADD SchoolYear SMALLINT NULL;
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII ADD DataCollectionName NVARCHAR(100) NULL;
    END

    IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII ADD RunDateTime DATETIME NULL;
    END

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'SchoolYear'

	--add the index back
	CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationTitleIII_DataCollectionName_WithIdentifiers 
		ON Staging.ProgramParticipationTitleIII (DataCollectionName,StudentIdentifierState,LeaIdentifierSeaAccountability,LeaIdentifierSeaAttendance,
            LeaIdentifierSeaFunding,LeaIdentifierSeaGraduation,LeaIdentifierSeaIndividualizedEducationProgram,SchoolIdentifierSea);

------------------------------------------------
--ProgramParticipationTitleI

--Drop DataCollectionName and RunDateTime, they are added back after 
--	the new column to keep the structure of the table clean
------------------------------------------------
    IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI DROP COLUMN RunDateTime;
    END
    
    --drop extended properties
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE ep.class_desc = 'OBJECT_OR_COLUMN'	
	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationTitleI' 
	AND c.name = 'DataCollectionName' )
    BEGIN
        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Def_Desc', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Element',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_URL', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'MS_Description',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    END;

------------------------------------------------
--Add the SchoolYear column
------------------------------------------------

    IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI ADD SchoolYear SMALLINT NULL;
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI ADD DataCollectionName NVARCHAR(100) NULL;
    END

    IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI ADD RunDateTime DATETIME NULL;
    END

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'SchoolYear'

------------------------------------------------
--ProgramParticipationNorD

--Drop DataCollectionName and RunDateTime, they are added back after 
--	the new column to keep the structure of the table clean
------------------------------------------------
	IF EXISTS (SELECT name 
	FROM sys.indexes
	WHERE name = N'IX_Staging_ProgramParticipationNOrD_DataCollectionName' )
	BEGIN
		DROP INDEX IX_Staging_ProgramParticipationNOrD_DataCollectionName ON Staging.ProgramParticipationNorD;
	END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD DROP COLUMN RunDateTime;
    END
    
    --drop extended properties
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE ep.class_desc = 'OBJECT_OR_COLUMN'	
	AND s.name = 'Staging'
    AND t.name = 'ProgramParticipationNorD' 
	AND c.name = 'DataCollectionName' )
    BEGIN
        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Def_Desc', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Element',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_URL', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'MS_Description',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    END;

------------------------------------------------
--Add the SchoolYear column
------------------------------------------------

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD SchoolYear SMALLINT NULL;
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD DataCollectionName NVARCHAR(100) NULL;
    END

    IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD ADD RunDateTime DATETIME NULL;
    END

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'SchoolYear'

	--add the index back
	CREATE NONCLUSTERED INDEX IX_Staging_ProgramParticipationNOrD_DataCollectionName 
		ON Staging.ProgramParticipationNorD (DataCollectionName,StudentIdentifierState,LeaIdentifierSeaAccountability,LeaIdentifierSeaAttendance,
            LeaIdentifierSeaFunding,LeaIdentifierSeaGraduation,LeaIdentifierSeaIndividualizedEducationProgram,SchoolIdentifierSea);

------------------------------------------------
--PersonStatus

--Drop DataCollectionName and RunDateTime, they are added back after 
--	the new column to keep the structure of the table clean
------------------------------------------------
	IF EXISTS (SELECT name 
	FROM sys.indexes
	WHERE name = N'Staging_PersonStatus_WithIdentifiers' )
	BEGIN
		DROP INDEX Staging_PersonStatus_WithIdentifiers ON Staging.PersonStatus;
	END

    IF COL_LENGTH('Staging.PersonStatus', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.PersonStatus DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.PersonStatus', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.PersonStatus DROP COLUMN RunDateTime;
    END
    
    --drop extended properties and indexes
    IF EXISTS(SELECT 1
    FROM 
        sys.extended_properties AS ep
        INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
        INNER JOIN sys.tables AS t ON c.object_id = t.object_id
        INNER JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE ep.class_desc = 'OBJECT_OR_COLUMN'	
	AND s.name = 'Staging'
    AND t.name = 'PersonStatus' 
	AND c.name = 'DataCollectionName' )
    BEGIN
        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Def_Desc', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_Element',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_GlobalId', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'CEDS_URL', @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

        EXEC sys. sp_dropextendedproperty @name=N'MS_Description',  @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
    END

------------------------------------------------
--Add the SchoolYear column
------------------------------------------------
    IF COL_LENGTH('Staging.PersonStatus', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.PersonStatus ADD SchoolYear SMALLINT NULL;
    END

    --Add DataCollectionName and RunDateTime back
    IF COL_LENGTH('Staging.PersonStatus', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.PersonStatus ADD DataCollectionName NVARCHAR(100) NULL;
    END

    IF COL_LENGTH('Staging.PersonStatus', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.PersonStatus ADD RunDateTime DATETIME NULL;
    END

    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'SchoolYear'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'SchoolYear'

	--add the index back
	CREATE NONCLUSTERED INDEX Staging_PersonStatus_WithIdentifiers 
		ON Staging.PersonStatus (DataCollectionName,StudentIdentifierState,LeaIdentifierSeaAccountability,LeaIdentifierSeaAttendance,
            LeaIdentifierSeaFunding,LeaIdentifierSeaGraduation,LeaIdentifierSeaIndividualizedEducationProgram,SchoolIdentifierSea);

