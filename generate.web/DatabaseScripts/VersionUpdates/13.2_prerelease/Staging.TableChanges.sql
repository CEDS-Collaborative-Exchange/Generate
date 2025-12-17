--Add default SSRD values to convert PostSecondary Enrollment Action for FS160
	if not exists (select 1 
					from staging.SourceSystemReferenceData 
					where tablename = 'RefPostsecondaryEnrollmentAction'
					and SchoolYear = '2025')
	begin
		insert into staging.SourceSystemReferenceData 
		values ('2025', 'RefPostsecondaryEnrollmentAction', NULL, 'Enrolled,','Enrolled'),
			('2025', 'RefPostsecondaryEnrollmentAction', NULL, 'NoInformation','NoInformation'),
			('2025', 'RefPostsecondaryEnrollmentAction', NULL, 'NotEnrolled','NotEnrolled')
	end

-----------------------------------------------
--Staging.K12Enrollment
-----------------------------------------------
	--Add Post Secondary Enrollment Action

    --Drop the extended properties for SchoolYear,	RecordStartDateTime, and RecordEndDateTime, DataCollectionName
    --  they are added back after the new column to keep the structure of the table clean    

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12Enrollment' AND c.name = 'SchoolYear' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12Enrollment' AND c.name = 'RecordStartDateTime' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12Enrollment' AND c.name = 'RecordEndDateTime' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'K12Enrollment' AND c.name = 'DataCollectionName' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        END

    --Drop the indexes that exist
        IF EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_K12Enrollment_DataCollectionName')
        BEGIN
            DROP INDEX IX_Staging_K12Enrollment_DataCollectionName ON Staging.K12Enrollment;
        END

        IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_K12Enrollment_StuId_SchId_Hispanic_RecordStartDateTime')
        BEGIN
            DROP INDEX IX_Staging_K12Enrollment_StuId_SchId_Hispanic_RecordStartDateTime ON Staging.K12Enrollment;
        END

        IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_K12Enrollment_WithIdentifiers')
        BEGIN
            DROP INDEX IX_Staging_K12Enrollment_WithIdentifiers ON Staging.K12Enrollment;
        END

        IF EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_K12Enrollment_DataCollectionName')
        BEGIN
            DROP INDEX IX_K12Enrollment_DataCollectionName ON Staging.K12Enrollment;
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.K12Enrollment', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.K12Enrollment', 'RecordStartDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment DROP COLUMN RecordStartDateTime;
        END

        IF COL_LENGTH('Staging.K12Enrollment', 'RecordEndDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment DROP COLUMN RecordEndDateTime;
        END

        IF COL_LENGTH('Staging.K12Enrollment', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment DROP COLUMN DataCollectionName;
        END

    --Add the new column
        IF COL_LENGTH('Staging.K12Enrollment', 'PostSecondaryEnrollmentAction') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ADD PostSecondaryEnrollmentAction VARCHAR(50) NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.K12Enrollment', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ADD SchoolYear SMALLINT NULL;
        END
 
        IF COL_LENGTH('Staging.K12Enrollment', 'RecordStartDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ADD RecordStartDateTime DATETIME2 NULL;
        END

        IF COL_LENGTH('Staging.K12Enrollment', 'RecordEndDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ADD RecordEndDateTime DATETIME2 NULL;
        END

        IF COL_LENGTH('Staging.K12Enrollment', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Enrollment ADD DataCollectionName NVARCHAR(100);
        END

        --Add the index back
        IF NOT EXISTS (
            SELECT 1 
            FROM sys.indexes 
            WHERE name = 'IX_Staging_K12Enrollment_DataCollectionName'
            AND object_id = OBJECT_ID('Staging.K12Enrollment')
        )
        BEGIN
            CREATE NONCLUSTERED INDEX IX_Staging_K12Enrollment_DataCollectionName
            ON Staging.K12Enrollment (DataCollectionName);
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
         AND t.name = 'K12Enrollment' AND c.name = 'PostSecondaryEnrollmentAction' )
         BEGIN
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of the student''s enrollment action for a particular term as defined by the institution' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentAction'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Post Secondary Enrollment Action' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentAction'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentAction'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=00000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentAction'
            EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentAction'
        END
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear'

        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'P001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/desHome.aspx#/all/classes/details/C200275/P001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'

        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'P001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/desHome.aspx#/all/classes/details/C200275/P001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime'
		
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName'


