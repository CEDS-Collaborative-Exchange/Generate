    --Drop SchoolYear, DataCollectionName and RunDateTime, they are added back after the 2 new columns to keep the 
    --	structure of the table clean
    IF COL_LENGTH('Staging.AssessmentResult', 'SchoolYear') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult DROP COLUMN SchoolYear;
    END

    IF COL_LENGTH('Staging.AssessmentResult', 'DataCollectionName') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult DROP COLUMN DataCollectionName;
    END

    IF COL_LENGTH('Staging.AssessmentResult', 'RunDateTime') IS NOT NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult DROP COLUMN RunDateTime;
    END
    
------------------------------------------------
--Add the columns for the N or D file specs
------------------------------------------------

    --Add the new columns
    IF COL_LENGTH('Staging.AssessmentResult', 'AssessmentAccommodationCategory') IS NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult ADD AssessmentAccommodationCategory nvarchar(100);
    END

    IF COL_LENGTH('Staging.AssessmentResult', 'AccommodationType') IS NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult ADD AccommodationType nvarchar(100);
    END

    --Add the standard columns back to the table
    IF COL_LENGTH('Staging.AssessmentResult', 'SchoolYear') IS NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult ADD SchoolYear smallint;
    END

    IF COL_LENGTH('Staging.AssessmentResult', 'DataCollectionName') IS NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult ADD DataCollectionName nvarchar(100);
    END

    IF COL_LENGTH('Staging.AssessmentResult', 'RunDateTime') IS NULL
    BEGIN
        ALTER TABLE Staging.AssessmentResult ADD RunDateTime datetime;
    END


    --add the extended properties
    EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/element/001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'DataCollectionName'

