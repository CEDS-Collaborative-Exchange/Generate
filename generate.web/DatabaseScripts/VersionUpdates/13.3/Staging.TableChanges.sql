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
