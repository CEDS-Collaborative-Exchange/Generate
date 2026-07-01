-------------------------------------------------------------
--Staging Changes
-------------------------------------------------------------

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

    IF COL_LENGTH('Staging.K12Enrollment', 'PostSecondaryEnrollmentAction') IS NULL
    BEGIN
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

    END
    -----------------------------------------------
    --Staging.OrganizationFederalFunding
    -----------------------------------------------
    --Drop the extended properties for SchoolYear and DataCollectionName
    --  they are added back after the new columns to keep the structure of the table clean    

    IF COL_LENGTH('Staging.OrganizationFederalFunding', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN

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

    END

-----------------------------------------------------
--Create the default mapping rows in SSRD
-----------------------------------------------------
	if not exists (select 1 
					from staging.SourceSystemReferenceData 
					where tablename = 'RefCharterSchoolAppropriationMethod'
					and SchoolYear = '2026')
	begin
		insert into staging.SourceSystemReferenceData 
		values ('2026', 'RefCharterSchoolAppropriationMethod', NULL, 'STEAPRDRCT', 'STEAPRDRCT'),
			('2026', 'RefCharterSchoolAppropriationMethod', NULL, 'STEAPRTHRULEA', 'STEAPRTHRULEA'),
			('2026', 'RefCharterSchoolAppropriationMethod', NULL, 'STEAPRALLOCLEA', 'STEAPRALLOCLEA')
	end

    -----------------------------------------------------
    --Modify Staging.K12Organization
    -----------------------------------------------------
	--Drop the extended properties
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_URL' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_GlobalId' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Element' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_dropextendedproperty @name=N'CEDS_Def_Desc' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'

    --Drop the indexes that exist
        IF EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_K12Organization_LEA_IsReportedFederally')
        BEGIN
            DROP INDEX IX_Staging_K12Organization_LEA_IsReportedFederally ON Staging.K12Organization;
        END

        IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Staging_K12Organization_School_RecordStartDateTime')
        BEGIN
            DROP INDEX IX_Staging_K12Organization_School_RecordStartDateTime ON Staging.K12Organization;
        END

    --Drop the columns at the bottom of the table temporarily
        IF COL_LENGTH('Staging.K12Organization', 'School_IsReportedFederally') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN School_IsReportedFederally;
        END
 
        IF COL_LENGTH('Staging.K12Organization', 'School_RecordStartDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN School_RecordStartDateTime;
        END

        IF COL_LENGTH('Staging.K12Organization', 'School_RecordEndDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN School_RecordEndDateTime;
        END

        IF COL_LENGTH('Staging.K12Organization', 'SchoolYear') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN SchoolYear;
        END
 
        IF COL_LENGTH('Staging.K12Organization', 'DataCollectionName') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN DataCollectionName;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewIEU') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN NewIEU;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewLEA') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN NewLEA;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewSchool') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN NewSchool;
        END

        IF COL_LENGTH('Staging.K12Organization', 'RunDateTime') IS NOT NULL
        BEGIN
            ALTER TABLE Staging.K12Organization DROP COLUMN RunDateTime;
        END

    --Add the new column
        IF COL_LENGTH('Staging.K12Organization', 'School_CharterSchoolStateAppropriationMethod') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD School_CharterSchoolStateAppropriationMethod NVARCHAR(100) NULL;
        END

    --Add the columns back
        IF COL_LENGTH('Staging.K12Organization', 'School_IsReportedFederally') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD School_IsReportedFederally bit NULL;
        END
 
        IF COL_LENGTH('Staging.K12Organization', 'School_RecordStartDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD School_RecordStartDateTime datetime null; 
        END

        IF COL_LENGTH('Staging.K12Organization', 'School_RecordEndDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD School_RecordEndDateTime datetime null;
        END

        IF COL_LENGTH('Staging.K12Organization', 'SchoolYear') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD SchoolYear smallint null;
        END
 
        IF COL_LENGTH('Staging.K12Organization', 'DataCollectionName') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD DataCollectionName nvarchar(100) null;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewIEU') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD NewIEU bit null;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewLEA') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD NewLEA bit null;
        END

        IF COL_LENGTH('Staging.K12Organization', 'NewSchool') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD NewSchool bit null;
        END

        IF COL_LENGTH('Staging.K12Organization', 'RunDateTime') IS NULL
        BEGIN
            ALTER TABLE Staging.K12Organization ADD RunDateTime datetime null;
        END

	--Add the extended properties back
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordStartDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_RecordEndDateTime'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'SchoolYear'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'
		EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

-------------------------------------------------------------
--RDS Changes
-------------------------------------------------------------

	-----------------------------------------------
	--File 035 changes	
	-----------------------------------------------

    IF COL_LENGTH('RDS.FactOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN
        ALTER TABLE RDS.FactOrganizationCounts ADD HomelessChildrenandYouthReservation INT NULL;
    END

    --Add the default constraint for the new column
    IF OBJECT_ID('[DF_FactOrganizationCounts_HomelessChildrenandYouthReservation]') IS NULL 
    BEGIN
        ALTER TABLE [RDS].[FactOrganizationCounts] ADD  CONSTRAINT [DF_FactOrganizationCounts_HomelessChildrenandYouthReservation]  DEFAULT ((0)) FOR [HomelessChildrenandYouthReservation]
    END

    --Add the new column to ReportEdFactsOrganizationCounts
    IF COL_LENGTH('RDS.ReportEdFactsOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN
        ALTER TABLE RDS.ReportEdFactsOrganizationCounts ADD HomelessChildrenandYouthReservation INT NULL;
    END

	-----------------------------------------------
	--File 067 changes	
	-----------------------------------------------

    IF COL_LENGTH('RDS.DimK12StaffCategories', 'TitleIIILanguageInstructionIndicatorCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimK12StaffCategories ADD TitleIIILanguageInstructionIndicatorCode VARCHAR(50) NULL;
    END
	
    IF COL_LENGTH('RDS.DimK12StaffCategories', 'TitleIIILanguageInstructionIndicatorDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimK12StaffCategories ADD TitleIIILanguageInstructionIndicatorDescription VARCHAR(200) NULL;
    END

	-----------------------------------------------
	--File 160 changes	
	-----------------------------------------------

	--Add Postsecondary Enrollment Action to the dimension table
    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionCode VARCHAR(50) NULL;
    END
	
    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionDescription') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionDescription VARCHAR(200) NULL;
    END

    IF COL_LENGTH('RDS.DimPsEnrollmentStatuses', 'PostSecondaryEnrollmentActionEdFactsCode') IS NULL
    BEGIN
        ALTER TABLE RDS.DimPsEnrollmentStatuses ADD PostSecondaryEnrollmentActionEdFactsCode VARCHAR(50) NULL;
    END

	--Add PSEnrollmentStatus to the Fact table
    IF COL_LENGTH('RDS.FactK12StudentCounts', 'PsEnrollmentStatusId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD PsEnrollmentStatusId BIGINT NULL;
    END
       
	IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys fk
    JOIN sys.tables t ON fk.parent_object_id = t.object_id
    WHERE t.name = 'FactK12StudentCounts'
      AND fk.name = 'FK_FactK12StudentCounts_PSEnrollmentStatusId'
	)
	BEGIN
		ALTER TABLE RDS.FactK12StudentCounts
		ADD CONSTRAINT FK_FactK12StudentCounts_PSEnrollmentStatusId
		FOREIGN KEY (PSEnrollmentStatusId)
		REFERENCES RDS.DimPsEnrollmentStatuses(DimPSEnrollmentStatusId);
	END

    IF COL_LENGTH('RDS.FactK12StudentCounts', 'PsEnrollmentStatusId') IS NOT NULL
    BEGIN
    	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_PsEnrollmentStatusId] DEFAULT ((-1)) FOR [PsEnrollmentStatusId];
    END

--End of code to add back fields missing from 13.2
