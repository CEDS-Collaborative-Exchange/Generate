--Adding back changes that didn't make it into 13.3 for some reason
-----------------------------------------------
--Staging.K12StaffAssignment
-----------------------------------------------

   	IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationStaffCategory') IS NOT NULL
	BEGIN
		exec sp_rename 'Staging.K12StaffAssignment.SpecialEducationStaffCategory', 'SpecialEducationSupportServicesCategory', 'COLUMN';
	END

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

        --Dropping RunDateTime, we don't use that anymore
        IF COL_LENGTH('Staging.K12Enrollment', 'RunDateTime') IS NOT NULL  
        BEGIN
            ALTER TABLE Staging.K12Enrollment DROP COLUMN RunDateTime;
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

-----------------------------------------------
--Staging.OrganizationFederalFunding
-----------------------------------------------
    --Drop the extended properties for SchoolYear and DataCollectionName
    --  they are added back after the new columns to keep the structure of the table clean    

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'OrganizationFederalFunding' AND c.name = 'SchoolYear' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'OrganizationFederalFunding' AND c.name = 'DataCollectionName' )
         BEGIN
            EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
            EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding DROP COLUMN DataCollectionName;
        END

    --Drop the deprecated columns
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'DataCollectionId') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding DROP COLUMN DataCollectionId;
        END
 
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'RunDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding DROP COLUMN RunDateTime;
        END

    --Add the new column
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'HomelessChildrenandYouthReservation') IS NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding ADD HomelessChildrenandYouthReservation NUMERIC(12,2) NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding ADD SchoolYear SMALLINT NULL;
        END
 
        IF COL_LENGTH('Staging.OrganizationFederalFunding', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.OrganizationFederalFunding ADD DataCollectionName NVARCHAR(100);
        END

        IF EXISTS(SELECT 1
         FROM 
             sys.extended_properties AS ep
             INNER JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
             INNER JOIN sys.tables AS t ON c.object_id = t.object_id
             INNER JOIN sys.schemas s on t.schema_id = s.schema_id
         WHERE 
         ep.class_desc = 'OBJECT_OR_COLUMN'	AND s.name = 'Staging'
         AND t.name = 'OrganizationFederalFunding' AND c.name = 'HomelessChildrenandYouthReservation' )
         BEGIN
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The initially reserved dollar amount of Title I, Part A allocation reserved by the LEA to serve homeless children and youth.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'HomelessChildrenandYouthReservation'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Homeless Children and Youth Reservation' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'HomelessChildrenandYouthReservation'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'HomelessChildrenandYouthReservation'
            EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=00000' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'HomelessChildrenandYouthReservation'
            EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'HomelessChildrenandYouthReservation'
        END
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'SchoolYear'

        EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
        EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

--End of staging changes added back in


IF COL_LENGTH('Staging.K12Enrollment', 'NumberOfSchoolDays') IS NOT NULL
   AND COL_LENGTH('Staging.K12Enrollment', 'NumberOfDaysInAttendance') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Enrollment.NumberOfSchoolDays',
        'NumberOfDaysInAttendance',
        'COLUMN';
END;

-- IF COL_LENGTH('Staging.K12Enrollment', 'PostSecondaryEnrollmentAction') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.K12Enrollment
--     DROP COLUMN PostSecondaryEnrollmentAction;
-- END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12StaffAssignment.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
     SELECT 1
     FROM sys.key_constraints kc
     INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
     INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
     INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
     INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
     WHERE kc.name = 'PK_K12StaffAssignment'
        AND s.name = 'Staging'
        AND t.name = 'K12StaffAssignment'
        AND c.name = 'ID'
)
    AND COL_LENGTH('Staging.K12StaffAssignment', 'Id') IS NOT NULL
BEGIN
     ALTER TABLE Staging.K12StaffAssignment
     DROP CONSTRAINT PK_K12StaffAssignment;

     ALTER TABLE Staging.K12StaffAssignment
     ADD CONSTRAINT PK_K12StaffAssignment PRIMARY KEY CLUSTERED (Id ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'BirthDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12StaffAssignment.BirthDate',
        'Birthdate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EDFactsTeacherOutOfFieldStatus') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12StaffAssignment.EDFactsTeacherOutOfFieldStatus',
        'EdFactsTeacherOutOfFieldStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'Homelessness_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.Homelessness_StatusEndDate',
        'Homelessness_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'HomelessNightimeResidence_BeginDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.HomelessNightimeResidence_BeginDate',
        'HomelessNightimeResidence_StartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'HomelessNightTimeResidence_EndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.HomelessNightTimeResidence_EndDate',
        'HomelessNightTimeResidence_ExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'EconomicDisadvantage_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.EconomicDisadvantage_StatusEndDate',
        'EconomicDisadvantage_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'Migrant_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.Migrant_StatusEndDate',
        'Migrant_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'MilitaryConnected_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.MilitaryConnected_StatusEndDate',
        'MilitaryConnected_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'EnglishLearner_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.EnglishLearner_StatusEndDate',
        'EnglishLearner_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'PerkinsEnglishLearnerStatus_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.PerkinsEnglishLearnerStatus_StatusEndDate',
        'PerkinsEnglishLearnerStatus_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.Disability', 'Disability_StatusEndDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.Disability.Disability_StatusEndDate',
        'Disability_StatusExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'MilitaryActiveStudentIndicator') IS NOT NULL
   AND COL_LENGTH('Staging.PersonStatus', 'MilitaryActiveStatusIndicator') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.MilitaryActiveStudentIndicator',
        'MilitaryActiveStatusIndicator',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'MilitaryVeteranStudentIndicator') IS NOT NULL
   AND COL_LENGTH('Staging.PersonStatus', 'MilitaryVeteranStatusIndicator') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.MilitaryVeteranStudentIndicator',
        'MilitaryVeteranStatusIndicator',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'FosterCare_ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.PersonStatus', 'FosterCare_ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.FosterCare_ProgramParticipationEndDate',
        'FosterCare_ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'Section504_ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.PersonStatus', 'Section504_ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.Section504_ProgramParticipationEndDate',
        'Section504_ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'Immigrant_ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.PersonStatus', 'Immigrant_ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.Immigrant_ProgramParticipationEndDate',
        'Immigrant_ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.PersonStatus', 'RecordStartDatetime') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.PersonStatus.RecordStartDatetime',
        'RecordStartDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationCTE', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationCTE.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
      SELECT 1
      FROM sys.key_constraints kc
      INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
      INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
      INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
      INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
      WHERE kc.name = 'PK_ProgramParticipationCTE'
          AND s.name = 'Staging'
          AND t.name = 'ProgramParticipationCTE'
          AND c.name = 'ID'
)
     AND COL_LENGTH('Staging.ProgramParticipationCTE', 'Id') IS NOT NULL
BEGIN
      ALTER TABLE Staging.ProgramParticipationCTE
      DROP CONSTRAINT PK_ProgramParticipationCTE;

      ALTER TABLE Staging.ProgramParticipationCTE
      ADD CONSTRAINT PK_ProgramParticipationCTE PRIMARY KEY CLUSTERED (Id ASC);
END;

IF COL_LENGTH('Staging.ProgramParticipationCTE', 'ProgramParticipationBeginDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationCTE', 'ProgramParticipationStartDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationCTE.ProgramParticipationBeginDate',
        'ProgramParticipationStartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationCTE', 'ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationCTE', 'ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationCTE.ProgramParticipationEndDate',
        'ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationNorD.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
        SELECT 1
        FROM sys.key_constraints kc
        INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
        INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE kc.name = 'PK_ProgramParticipationNorD'
             AND s.name = 'Staging'
             AND t.name = 'ProgramParticipationNorD'
             AND c.name = 'ID'
)
      AND COL_LENGTH('Staging.ProgramParticipationNorD', 'Id') IS NOT NULL
BEGIN
        ALTER TABLE Staging.ProgramParticipationNorD
        DROP CONSTRAINT PK_ProgramParticipationNorD;

        ALTER TABLE Staging.ProgramParticipationNorD
        ADD CONSTRAINT PK_ProgramParticipationNorD PRIMARY KEY CLUSTERED (Id ASC);
END;

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'ProgramParticipationBeginDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationNorD', 'ProgramParticipationStartDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationNorD.ProgramParticipationBeginDate',
        'ProgramParticipationStartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationNorD', 'ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationNorD.ProgramParticipationEndDate',
        'ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
        SELECT 1
        FROM sys.key_constraints kc
        INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
        INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE kc.name = 'PK_ProgramParticipationSpecialEducation'
             AND s.name = 'Staging'
             AND t.name = 'ProgramParticipationSpecialEducation'
             AND c.name = 'ID'
)
      AND COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'Id') IS NOT NULL
BEGIN
        ALTER TABLE Staging.ProgramParticipationSpecialEducation
        DROP CONSTRAINT PK_ProgramParticipationSpecialEducation;

        ALTER TABLE Staging.ProgramParticipationSpecialEducation
        ADD CONSTRAINT PK_ProgramParticipationSpecialEducation PRIMARY KEY CLUSTERED (Id ASC);
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'ProgramParticipationBeginDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'ProgramParticipationStartDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.ProgramParticipationBeginDate',
        'ProgramParticipationStartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.ProgramParticipationEndDate',
        'ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'IDEAIndicator') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.IDEAIndicator',
        'IdeaIndicator',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'IDEAEducationalEnvironmentForEarlyChildhood') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.IDEAEducationalEnvironmentForEarlyChildhood',
        'IdeaEducationalEnvironmentForEarlyChildhood',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationSpecialEducation', 'IDEAEducationalEnvironmentForSchoolAge') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationSpecialEducation.IDEAEducationalEnvironmentForSchoolAge',
        'IdeaEducationalEnvironmentForSchoolAge',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleI.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
        SELECT 1
        FROM sys.key_constraints kc
        INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
        INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE kc.name = 'PK_ProgramParticipationTitleI'
             AND s.name = 'Staging'
             AND t.name = 'ProgramParticipationTitleI'
             AND c.name = 'ID'
)
      AND COL_LENGTH('Staging.ProgramParticipationTitleI', 'Id') IS NOT NULL
BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleI
        DROP CONSTRAINT PK_ProgramParticipationTitleI;

        ALTER TABLE Staging.ProgramParticipationTitleI
        ADD CONSTRAINT PK_ProgramParticipationTitleI PRIMARY KEY CLUSTERED (Id ASC);
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'ProgramParticipationBeginDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationTitleI', 'ProgramParticipationStartDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleI.ProgramParticipationBeginDate',
        'ProgramParticipationStartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleI', 'ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationTitleI', 'ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleI.ProgramParticipationEndDate',
        'ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'ID') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleIII.ID',
        'Id',
        'COLUMN';
END;

IF EXISTS (
        SELECT 1
        FROM sys.key_constraints kc
        INNER JOIN sys.tables t ON t.object_id = kc.parent_object_id
        INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
        INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id AND ic.key_ordinal = 1
        INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE kc.name = 'PK_ProgramParticipationTitleIII'
             AND s.name = 'Staging'
             AND t.name = 'ProgramParticipationTitleIII'
             AND c.name = 'ID'
)
      AND COL_LENGTH('Staging.ProgramParticipationTitleIII', 'Id') IS NOT NULL
BEGIN
        ALTER TABLE Staging.ProgramParticipationTitleIII
        DROP CONSTRAINT PK_ProgramParticipationTitleIII;

        ALTER TABLE Staging.ProgramParticipationTitleIII
        ADD CONSTRAINT PK_ProgramParticipationTitleIII PRIMARY KEY CLUSTERED (Id ASC);
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'ProgramParticipationBeginDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationTitleIII', 'ProgramParticipationStartDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleIII.ProgramParticipationBeginDate',
        'ProgramParticipationStartDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'ProgramParticipationEndDate') IS NOT NULL
   AND COL_LENGTH('Staging.ProgramParticipationTitleIII', 'ProgramParticipationExitDate') IS NULL
BEGIN
    EXEC sp_rename
        'Staging.ProgramParticipationTitleIII.ProgramParticipationEndDate',
        'ProgramParticipationExitDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.ProgramParticipationTitleIII', 'RunDateTime') IS NULL
BEGIN
    ALTER TABLE Staging.ProgramParticipationTitleIII
    ADD RunDateTime DATETIME NULL;
END;

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'RunDateTime') IS NULL
BEGIN
    ALTER TABLE Staging.ProgramParticipationNorD
    ADD RunDateTime DATETIME NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'IeuOrganizationIdentifierSea') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD IeuOrganizationIdentifierSea NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EmployerOrganizationIdentifierSea') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD EmployerOrganizationIdentifierSea NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'JobPositionIdentifierSea') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD JobPositionIdentifierSea NVARCHAR (60) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'JobTitle') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD JobTitle NVARCHAR (200) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SEA_EducationJobTypeCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SEA_EducationJobTypeCode NVARCHAR (40) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SEA_LocalJobFunctionCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SEA_LocalJobFunctionCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SEA_LocalJobCategoryCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SEA_LocalJobCategoryCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'Lea_EducationJobTypeCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD Lea_EducationJobTypeCode NVARCHAR (40) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'Lea_LocalJobFunctionCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD Lea_LocalJobFunctionCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'Lea_LocalJobCategoryCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD Lea_LocalJobCategoryCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationStaffCategory') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SpecialEducationStaffCategory NVARCHAR (100) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'MigrantEducationProgramStaffCategory') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD MigrantEducationProgramStaffCategory NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ProfessionalEducationalJobClassification') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ProfessionalEducationalJobClassification NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EmploymentStartDate') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD EmploymentStartDate DATE NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EmploymentEndDate') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD EmploymentEndDate DATE NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'HireDate') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD HireDate DATE NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'InstructionalLanguage') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD InstructionalLanguage NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationRelatedServicesPersonnel') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SpecialEducationRelatedServicesPersonnel NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'TeachingCredentialBasis') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD TeachingCredentialBasis NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'CTEInstructorIndustryCertification') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD CTEInstructorIndustryCertification NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationParaprofessional') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SpecialEducationParaprofessional NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationTeacher') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD SpecialEducationTeacher NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ScedCourseCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ScedCourseCode NVARCHAR (5) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'OnetSocOccupationType') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD OnetSocOccupationType NVARCHAR (10) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EmploymentStatusCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD EmploymentStatusCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'EmploymentSeparationReasonCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD EmploymentSeparationReasonCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'TitleITargetedAssistanceStaffFundedCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD TitleITargetedAssistanceStaffFundedCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'MEPPersonnelIndicatorCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD MEPPersonnelIndicatorCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ItinerantTeacherCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ItinerantTeacherCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ItinerantTeacherDescription') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ItinerantTeacherDescription NVARCHAR (200) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ClassroomPositionTypeCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ClassroomPositionTypeCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'ClassroomPositionTypeDescription') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD ClassroomPositionTypeDescription NVARCHAR (200) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'PrimaryAssignmentIndicatorCode') IS NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    ADD PrimaryAssignmentIndicatorCode NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12StaffAssignment', 'SpecialEducationSupportServicesCategory') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StaffAssignment
    DROP COLUMN SpecialEducationSupportServicesCategory;
END;

IF COL_LENGTH('Staging.K12StudentAddress', 'RefStateId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentAddress
    DROP COLUMN RefStateId;
END;

IF COL_LENGTH('Staging.K12StudentAddress', 'OrganizationId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentAddress
    DROP COLUMN OrganizationId;
END;

IF COL_LENGTH('Staging.K12StudentAddress', 'LocationId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentAddress
    DROP COLUMN LocationId;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'DataCollectionId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN DataCollectionId;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'PersonId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN PersonId;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationID_LEA') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationID_LEA;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationPersonRoleId_LEA') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationPersonRoleId_LEA;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationID_School') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationID_School;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationPersonRoleId_School') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationPersonRoleId_School;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationID_Course') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationID_Course;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationID_CourseSection') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationID_CourseSection;
END;

IF COL_LENGTH('Staging.K12StudentCourseSection', 'OrganizationPersonRoleId_CourseSection') IS NOT NULL
BEGIN
    ALTER TABLE Staging.K12StudentCourseSection
    DROP COLUMN OrganizationPersonRoleId_CourseSection;
END;

IF COL_LENGTH('Staging.PsStudentAcademicRecord', 'CourseId') IS NOT NULL
BEGIN
    ALTER TABLE Staging.PsStudentAcademicRecord
    DROP COLUMN CourseId;
END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'LeaIdentifierSea') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN LeaIdentifierSea;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'SchoolPerformanceIndicatorStatus') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN SchoolPerformanceIndicatorStatus;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'SchoolPerformanceIndicatorStateDefinedStatusDescription') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN SchoolPerformanceIndicatorStateDefinedStatusDescription;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'Race') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN Race;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'IdeaIndicator') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN IdeaIndicator;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'EnglishLearnerStatus') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN EnglishLearnerStatus;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'EconomicDisadvantageStatus') IS NOT NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     DROP COLUMN EconomicDisadvantageStatus;
-- END;

-- IF COL_LENGTH('Staging.SchoolPerformanceIndicators', 'SubgroupElementName') IS NULL
-- BEGIN
--     ALTER TABLE Staging.SchoolPerformanceIndicators
--     ADD SubgroupElementName VARCHAR (100) NULL;
-- END;

IF COL_LENGTH('Staging.SourceSystemReferenceData', 'GlobalId') IS NULL
BEGIN
    ALTER TABLE Staging.SourceSystemReferenceData
    ADD GlobalId NVARCHAR (20) NULL;
END;

IF COL_LENGTH('Staging.SourceSystemReferenceData', 'ElementName') IS NULL
BEGIN
    ALTER TABLE Staging.SourceSystemReferenceData
    ADD ElementName NVARCHAR (150) NULL;
END;

IF COL_LENGTH('Staging.StagingValidationResults', 'ReportGroupOrCode') IS NULL
BEGIN
    ALTER TABLE Staging.StagingValidationResults
    ADD ReportGroupOrCode VARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.OrganizationAddress', 'AddressApartmentRoomOrSuiteNumber') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'Staging'
           AND TABLE_NAME = 'OrganizationAddress'
           AND COLUMN_NAME = 'AddressApartmentRoomOrSuiteNumber'
           AND DATA_TYPE <> 'varchar'
   )
BEGIN
    ALTER TABLE Staging.OrganizationAddress
    ALTER COLUMN AddressApartmentRoomOrSuiteNumber VARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.OrganizationFederalFunding', 'REAPAlternativeFundingStatusCode') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.OrganizationFederalFunding.REAPAlternativeFundingStatusCode',
        'ReapAlternativeFundingStatusCode',
        'COLUMN';
END;

IF COL_LENGTH('Staging.OrganizationFederalFunding', 'HomelessChildrenandYouthReservation') IS NOT NULL
BEGIN
    ALTER TABLE Staging.OrganizationFederalFunding
    DROP COLUMN HomelessChildrenandYouthReservation;
END;

IF COL_LENGTH('Staging.OrganizationFederalFunding', 'RunDateTime') IS NULL
BEGIN
    ALTER TABLE Staging.OrganizationFederalFunding
    ADD RunDateTime DATETIME NULL;
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RunDateTime') IS NULL
BEGIN
    ALTER TABLE Staging.K12Enrollment
    ADD RunDateTime DATETIME NULL;
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RecordStartDateTime') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'Staging'
           AND TABLE_NAME = 'K12Enrollment'
           AND COLUMN_NAME = 'RecordStartDateTime'
           AND DATA_TYPE <> 'datetime'
   )
BEGIN
    EXEC (
        'ALTER TABLE Staging.K12Enrollment ALTER COLUMN RecordStartDateTime DATETIME NULL;'
    );
END;

IF COL_LENGTH('Staging.K12Enrollment', 'RecordEndDateTime') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM INFORMATION_SCHEMA.COLUMNS
       WHERE TABLE_SCHEMA = 'Staging'
           AND TABLE_NAME = 'K12Enrollment'
           AND COLUMN_NAME = 'RecordEndDateTime'
           AND DATA_TYPE <> 'datetime'
   )
BEGIN
        EXEC (
        'ALTER TABLE Staging.K12Enrollment ALTER COLUMN RecordEndDateTime DATETIME NULL;'
    );
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_OrganizationName') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OrganizationName',
        'Ieu_OrganizationName',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_OperationalStatusEffectiveDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OperationalStatusEffectiveDate',
        'Ieu_OperationalStatusEffectiveDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_OrganizationOperationalStatus') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_OrganizationOperationalStatus',
        'Ieu_OrganizationOperationalStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_WebSiteAddress') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_WebSiteAddress',
        'Ieu_WebSiteAddress',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_RecordStartDateTime') IS NOT NULL
    BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_RecordStartDateTime',
        'Ieu_RecordStartDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'IEU_RecordEndDateTime') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.IEU_RecordEndDateTime',
        'Ieu_RecordEndDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_SupervisoryUnionIdentificationNumber') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_SupervisoryUnionIdentificationNumber',
        'Lea_SupervisoryUnionIdentificationNumber',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_WebSiteAddress') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_WebSiteAddress',
        'Lea_WebSiteAddress',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_OperationalStatus') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_OperationalStatus',
        'Lea_OperationalStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_OperationalStatusEffectiveDate') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_OperationalStatusEffectiveDate',
        'Lea_OperationalStatusEffectiveDate',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_CharterLeaStatus') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_CharterLeaStatus',
        'Lea_CharterLeaStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_CharterSchoolIndicator') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_CharterSchoolIndicator',
        'Lea_CharterSchoolIndicator',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_Type') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_Type',
        'Lea_Type',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_McKinneyVentoSubgrantRecipient') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_McKinneyVentoSubgrantRecipient',
        'Lea_McKinneyVentoSubgrantRecipient',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_GunFreeSchoolsActReportingStatus') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_GunFreeSchoolsActReportingStatus',
        'Lea_GunFreeSchoolsActReportingStatus',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_TitleIinstructionalService') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_TitleIinstructionalService',
        'Lea_TitleIinstructionalService',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_TitleIProgramType') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_TitleIProgramType',
        'Lea_TitleIProgramType',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_K12LeaTitleISupportService') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_K12LeaTitleISupportService',
        'Lea_K12LeaTitleISupportService',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_MepProjectType') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_MepProjectType',
        'Lea_MepProjectType',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_IsReportedFederally') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_IsReportedFederally',
        'Lea_IsReportedFederally',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_RecordStartDateTime') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_RecordStartDateTime',
        'Lea_RecordStartDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'LEA_RecordEndDateTime') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12Organization.LEA_RecordEndDateTime',
        'Lea_RecordEndDateTime',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12Organization', 'SchoolIdentifierAct') IS NULL
BEGIN
    ALTER TABLE Staging.K12Organization
    ADD SchoolIdentifierAct NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12Organization', 'SchoolIdentifierSat') IS NULL
BEGIN
    ALTER TABLE Staging.K12Organization
    ADD SchoolIdentifierSat NVARCHAR (50) NULL;
END;

IF COL_LENGTH('Staging.K12SchoolComprehensiveSupportIdentificationType', 'LEAIdentifierSea') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Staging.K12SchoolComprehensiveSupportIdentificationType.LEAIdentifierSea',
        'LeaIdentifierSea',
        'COLUMN';
END;

IF COL_LENGTH('Staging.K12SchoolComprehensiveSupportIdentificationType', 'DataCollectionName') IS NULL
BEGIN
    ALTER TABLE Staging.K12SchoolComprehensiveSupportIdentificationType
    ADD DataCollectionName NVARCHAR (100) NULL;
END;



DECLARE @K12SupportColumnName SYSNAME;
DECLARE @K12SupportMaxLength INT;
DECLARE @K12SupportIsNullable NVARCHAR(3);
DECLARE @K12SupportAlterSql NVARCHAR(MAX);

DECLARE K12SupportVarcharColumnsCursor CURSOR LOCAL FAST_FORWARD FOR
SELECT COLUMN_NAME,
             CHARACTER_MAXIMUM_LENGTH,
             IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Staging'
    AND TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType'
    AND COLUMN_NAME IN (
            'SchoolYear',
            'SchoolIdentifierSea',
            'ComprehensiveSupport',
            'ComprehensiveSupportReasonApplicability',
            'LeaIdentifierSea'
    )
    AND DATA_TYPE = 'varchar';

OPEN K12SupportVarcharColumnsCursor;

FETCH NEXT FROM K12SupportVarcharColumnsCursor
INTO @K12SupportColumnName, @K12SupportMaxLength, @K12SupportIsNullable;

WHILE @@FETCH_STATUS = 0
BEGIN
        SET @K12SupportAlterSql =
                'ALTER TABLE Staging.K12SchoolComprehensiveSupportIdentificationType ALTER COLUMN ['
                + @K12SupportColumnName
                + '] NVARCHAR('
                + CASE
                        WHEN @K12SupportMaxLength = -1 THEN 'MAX'
                        ELSE CAST(@K12SupportMaxLength AS NVARCHAR(10))
                    END
                + ') '
                + CASE
                        WHEN @K12SupportIsNullable = 'YES' THEN 'NULL'
                        ELSE 'NOT NULL'
                    END
                + ';';

        EXEC sp_executesql @K12SupportAlterSql;

        FETCH NEXT FROM K12SupportVarcharColumnsCursor
        INTO @K12SupportColumnName, @K12SupportMaxLength, @K12SupportIsNullable;
END;

CLOSE K12SupportVarcharColumnsCursor;
DEALLOCATE K12SupportVarcharColumnsCursor;

