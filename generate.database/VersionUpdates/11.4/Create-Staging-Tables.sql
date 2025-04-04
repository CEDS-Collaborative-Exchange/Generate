CREATE TABLE [Staging].[AccessibleEducationMaterialAssignment]
(
  [Id]                                                                  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  [SchoolYear]                                                          SMALLINT NULL,
  [CountDate]                                                           DATE NULL,
  [IeuOrganizationIdentifierSea]                                        NVARCHAR(60) NULL,
  [LeaIdentifierSea]                                                    NVARCHAR(60) NULL,
  [SchoolIdentifierSea]                                                 NVARCHAR(60) NULL,
  [K12StudentStudentIdentifierState]                                    NVARCHAR(60) NULL,
  [ScedCourseCode]                                                      NCHAR(5) NULL,
  [CourseIdentifier]                                                    NVARCHAR (40) NOT NULL,
  [CourseCodeSystemCode]                                                NVARCHAR (50) NOT NULL,
  [AccessibleEducationMaterialProviderOrganizationIdentifierSea]        NVARCHAR(60) NULL,
	[AccessibleFormatIssuedIndicatorCode]                                 NVARCHAR(50) NULL,
	[AccessibleFormatRequiredIndicatorCode]                               NVARCHAR(50) NULL,
	[AccessibleFormatTypeCode]                                            NVARCHAR(50) NULL,
  [LearningResourceIssuedDate]                                          DATE NULL,
  [LearningResourceOrderedDate]                                         DATE NULL,
  [LearningResourceReceivedDate]                                        DATE NULL,
  [DataCollectionName]                                                  NVARCHAR(100) NULL
)



CREATE TABLE [Staging].[AccessibleEducationMaterialProvider]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
	[AccessibleEducationMaterialProviderOrganizationIdentifierSea] nvarchar(60) NOT NULL,
	[AccessibleEducationMaterialProviderName] nvarchar(1000) NULL,
	[StateAbbreviationCode] nvarchar(2) NULL,
	[StateAbbreviationDescription] nvarchar(50) NULL,
	[StateANSICode] nvarchar(2) NULL,
	[MailingAddressStreetNumberAndName] nvarchar(300) NULL,
	[MailingAddressApartmentRoomOrSuiteNumber] nvarchar(40) NULL,
	[MailingAddressCity] nvarchar(60) NULL,
	[MailingAddressPostalCode] nvarchar(34) NULL,
	[MailingAddressStateAbbreviation] nvarchar(2) NULL,
	[MailingAddressCountyAnsiCodeCode] nvarchar(2) NULL,
	[PhysicalAddressStreetNumberAndName] nvarchar(300) NULL,
	[PhysicalAddressApartmentRoomOrSuiteNumber] nvarchar(40) NULL,
	[PhysicalAddressCity] nvarchar(60) NULL,
	[PhysicalAddressPostalCode] nvarchar(34) NULL,
	[PhysicalAddressStateAbbreviation] nvarchar(2) NULL,
	[PhysicalAddressCountyAnsiCodeCode] nvarchar(2) NULL,
	[TelephoneNumber] nvarchar(48) NULL,
	[WebSiteAddress] nvarchar(600) NULL,
	[OutOfStateIndicator] bit NULL,
	[RecordStartDateTime] datetime NOT NULL,
	[RecordEndDateTime] datetime NULL
)


DROP TABLE [Staging].[K12StudentCourseSection]


CREATE TABLE [Staging].[K12StudentCourseSection] (
    [Id]                                             INT            IDENTITY (1, 1) NOT NULL,
    [StudentIdentifierState]                         NVARCHAR (40)  NULL,
    [LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
    [LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
    [LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
    [LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
    [LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
    [SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
    [CourseGradeLevel]                               VARCHAR (100)  NULL,
    [ScedCourseCode]                                 NVARCHAR (50)  NULL,
    [CourseIdentifier]                               NVARCHAR (40) NOT NULL,
    [CourseCodeSystemCode]                           NVARCHAR (50) NOT NULL,
    [CourseRecordStartDateTime]                      DATETIME       NULL,
    [CourseLevelCharacteristic]                      NVARCHAR (50)  NULL,
    [EntryDate]                                      DATETIME       NULL,
    [ExitDate]                                       DATETIME       NULL,
    [SchoolYear]                                     SMALLINT       NULL,
    [RecordStartDateTime]                            DATETIME       NULL,
    [RecordEndDateTime]                              DATETIME       NULL,
    [DataCollectionName]                             NVARCHAR (100) NULL,
    [DataCollectionId]                               INT            NULL,
    [PersonId]                                       INT            NULL,
    [OrganizationID_LEA]                             INT            NULL,
    [OrganizationPersonRoleId_LEA]                   INT            NULL,
    [OrganizationID_School]                          INT            NULL,
    [OrganizationPersonRoleId_School]                INT            NULL,
    [OrganizationID_Course]                          INT            NULL,
    [OrganizationID_CourseSection]                   INT            NULL,
    [OrganizationPersonRoleId_CourseSection]         INT            NULL,
    [RunDateTime]                                    DATETIME       NULL,
    CONSTRAINT [PK_K12StudentCourseSection] PRIMARY KEY CLUSTERED ([Id] ASC)
);




CREATE NONCLUSTERED INDEX [IX_Staging_K12StudentCourseSection_ScedCourseCode]
    ON [Staging].[K12StudentCourseSection]([ScedCourseCode] ASC) WITH (FILLFACTOR = 80);




CREATE NONCLUSTERED INDEX [IX_Staging_K12StudentCourseSection_DataCollectionName_WithIdentifiers]
    ON [Staging].[K12StudentCourseSection]([DataCollectionName] ASC)
    INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea]) WITH (FILLFACTOR = 80);




EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseLevelCharacteristic';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of the general nature and difficulty of instruction provided throughout a course.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseLevelCharacteristic';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Course Level Characteristic' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseLevelCharacteristic';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000061' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseLevelCharacteristic';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21061' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseLevelCharacteristic';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseRecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseRecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseRecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseRecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'CourseRecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'ScedCourseCode';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The five-digit SCED code. The first two-digits of the code represent the Course Subject Area and the next three digits identify the course number. These identifiers are fairly general but provide enough specificity to identify the course''s topic and to distinguish it from other courses in that subject area.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'ScedCourseCode';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Courses for the Exchange of Data Course Code' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'ScedCourseCode';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001517' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'ScedCourseCode';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22490' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'ScedCourseCode';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to an institution by a school, school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001069' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21155' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a student by a school, school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Student Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001071' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21157' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';


DROP TABLE [Staging].[K12Enrollment]


CREATE TABLE [Staging].[K12Enrollment] (
    [Id]                                                  INT            IDENTITY (1, 1) NOT NULL,
    [StudentIdentifierState]                              NVARCHAR (40)  NULL,
    [LeaIdentifierSeaAccountability]                      NVARCHAR (50)  NULL,
    [LeaIdentifierSeaAttendance]                          NVARCHAR (50)  NULL,
    [LeaIdentifierSeaFunding]                             NVARCHAR (50)  NULL,
    [LeaIdentifierSeaGraduation]                          NVARCHAR (50)  NULL,
    [LeaIdentifierSeaIndividualizedEducationProgram]      NVARCHAR (50)  NULL,
    [LeaIdentifierSeaMembershipResident]                  NVARCHAR (50)  NULL,
    [SchoolIdentifierSea]                                 NVARCHAR (50)  NULL,
    [ResponsibleSchoolTypeAccountability]                 BIT            NULL,
    [ResponsibleSchoolTypeAttendance]                     BIT            NULL,
    [ResponsibleSchoolTypeFunding]                        BIT            NULL,
    [ResponsibleSchoolTypeGraduation]                     BIT            NULL,
    [ResponsibleSchoolTypeIndividualizedEducationProgram] BIT            NULL,
    [ResponsibleSchoolTypeTransportation]                 BIT            NULL,
    [ResponsibleSchoolTypeIepServiceProvider]             BIT            NULL,
    [EducationOrganizationNetworkIdentifierSea]           NVARCHAR (100) NULL,
    [FirstName]                                           NVARCHAR (100) NULL,
    [LastOrSurname]                                       NVARCHAR (100) NULL,
    [MiddleName]                                          NVARCHAR (100) NULL,
    [Birthdate]                                           DATE           NULL,
    [Sex]                                                 NVARCHAR (30)  NULL,
    [HispanicLatinoEthnicity]                             BIT            NULL,
    [EnrollmentEntryDate]                                 DATE           NULL,
    [EnrollmentExitDate]                                  DATE           NULL,
    [FullTimeEquivalency]                                 DECIMAL (5, 2) NULL,
    [EnrollmentStatus]                                    NVARCHAR (100) NULL,
    [ExitOrWithdrawalType]                                NVARCHAR (100) NULL,
    [EntryType]                                           NVARCHAR (100) NULL,
    [GradeLevel]                                          NVARCHAR (100) NULL,
    [CohortYear]                                          NCHAR (4)      NULL,
    [CohortGraduationYear]                                NCHAR (4)      NULL,
    [CohortDescription]                                   NCHAR (1024)   NULL,
    [ProjectedGraduationDate]                             NVARCHAR (8)   NULL,
    [HighSchoolDiplomaType]                               NVARCHAR (100) NULL,
    [LanguageNative]                                      NVARCHAR (100) NULL,
    [LanguageHome]                                        NVARCHAR (100) NULL,
    [NumberOfSchoolDays]                                  DECIMAL (9, 2) NULL,
    [NumberOfDaysAbsent]                                  DECIMAL (9, 2) NULL,
    [AttendanceRate]                                      DECIMAL (5, 4) NULL,
    [PostSecondaryEnrollmentStatus]                       NVARCHAR (100) NULL,
    [DiplomaOrCredentialAwardDate]                        DATE           NULL,
    [FoodServiceEligibility]                              NVARCHAR (100) NULL,
    [ERSRuralUrbanContinuumCode]                          NVARCHAR (50)  NULL,
    [RuralResidencyStatus]                                NVARCHAR (50)  NULL,
    [SchoolYear]                                          SMALLINT       NULL,
    [RecordStartDateTime]                                 DATETIME       NULL,
    [RecordEndDateTime]                                   DATETIME       NULL,
    [DataCollectionName]                                  NVARCHAR (100) NULL,
    [RunDateTime]                                         DATETIME       NULL,
    CONSTRAINT [PK_K12Enrollment] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
);




CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_StuId_SchId_Hispanic_RecordStartDateTime]
    ON [Staging].[K12Enrollment]([StudentIdentifierState] ASC, [SchoolIdentifierSea] ASC, [HispanicLatinoEthnicity] ASC, [RecordStartDateTime] ASC);




CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_WithIdentifiers]
    ON [Staging].[K12Enrollment]([DataCollectionName] ASC, [StudentIdentifierState] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC, [EnrollmentEntryDate] ASC)
    INCLUDE([Birthdate], [EnrollmentExitDate], [FirstName], [FullTimeEquivalency], [LastOrSurname], [MiddleName], [ProjectedGraduationDate], [RecordStartDateTime], [SchoolYear], [Sex]);




CREATE NONCLUSTERED INDEX [IX_K12Enrollment_DataCollectionName]
    ON [Staging].[K12Enrollment]([DataCollectionName] ASC)
    INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [EnrollmentEntryDate], [EnrollmentExitDate], [SchoolYear]);




EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Birthdate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year, month and day on which a person was born.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Birthdate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Birthdate' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Birthdate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000033' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Birthdate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21033' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Birthdate';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortDescription';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A description of the student cohort.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortDescription';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Cohort Description' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortDescription';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000711' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortDescription';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21687' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortDescription';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortGraduationYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year the cohort is expected to graduate.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortGraduationYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Cohort Graduation Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortGraduationYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000584' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortGraduationYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21577' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortGraduationYear';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The school year in which the student entered the baseline group used for computing completion rates (e.g., high school, program).' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Cohort Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000046' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21046' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'CohortYear';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A human readable name used to identify the data within the collection.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Data Collection Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001966' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22923' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DataCollectionName';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DiplomaOrCredentialAwardDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The month and year on which the diploma/credential is awarded to a student in recognition of his/her completion of the curricular requirements.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DiplomaOrCredentialAwardDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Diploma or Credential Award Date' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DiplomaOrCredentialAwardDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000081' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DiplomaOrCredentialAwardDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21081' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'DiplomaOrCredentialAwardDate';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentEntryDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The month, day, and year on which a person enters and begins to receive instructional services in a school, institution, program, or class-section during a given session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentEntryDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Enrollment Entry Date' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentEntryDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000097' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentEntryDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21097' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentEntryDate';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentExitDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year, month and day on which the student officially withdrew or graduated, i.e. the date on which the student''s enrollment ended.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentExitDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Enrollment Exit Date' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentExitDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000107' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentExitDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21107' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentExitDate';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication as to whether a student''s name was, is, or will be officially registered on the roll of a school or schools.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Enrollment Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000094' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21094' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EntryType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The process by which a student enters a school during a given academic session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EntryType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Entry Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EntryType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000099' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EntryType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21099' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'EntryType';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The circumstances under which the student exited from membership in an educational institution. ' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Exit or Withdrawal Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000110' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21110' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FirstName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The full legal first name given to a person at birth, baptism, or through legal change.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FirstName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'First Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FirstName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000115' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FirstName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21115' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FirstName';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FullTimeEquivalency';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The time a person is enrolled, employed, involved, or participates in the organization, divided by the time the organization defines as full-time for that role.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FullTimeEquivalency';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Full Time Equivalency' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FullTimeEquivalency';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001921' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FullTimeEquivalency';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22906' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'FullTimeEquivalency';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of diploma/credential that is awarded to a person in recognition of his/her completion of the curricular requirements.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'High School Diploma Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000138' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21138' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LastOrSurname';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The full legal last name borne in common by members of a family.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LastOrSurname';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Last or Surname' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LastOrSurname';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000172' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LastOrSurname';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21172' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LastOrSurname';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAccountability';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaAttendance';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaFunding';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaGraduation';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaMembershipResident';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a local education agency by a school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaMembershipResident';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Local Education Agency Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaMembershipResident';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001068' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaMembershipResident';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21153' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'LeaIdentifierSeaMembershipResident';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'MiddleName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A full legal middle name given to a person at birth, baptism, or through legal change.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'MiddleName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Middle Name' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'MiddleName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000184' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'MiddleName';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21184' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'MiddleName';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'NumberOfDaysAbsent';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The number of days a person is absent when school is in session during a given reporting period.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'NumberOfDaysAbsent';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Number of Days Absent' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'NumberOfDaysAbsent';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000201' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'NumberOfDaysAbsent';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21201' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'NumberOfDaysAbsent';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'An indication of the student''s enrollment status for a particular term as defined by the institution' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Postsecondary Enrollment Status' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000096' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21096' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PostSecondaryEnrollmentStatus';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ProjectedGraduationDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year and month the student is projected to graduate.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ProjectedGraduationDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Projected Graduation Date' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ProjectedGraduationDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000226' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ProjectedGraduationDate';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21226' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ProjectedGraduationDate';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The end date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record End Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001918' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22899' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordEndDateTime';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The start date and, optionally, time that a record is active as used to support version control.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Record Start Date Time' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001917' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=22898' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAccountability';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAccountability';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAttendance';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeAttendance';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeFunding';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeFunding';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeGraduation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeGraduation';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIepServiceProvider';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIepServiceProvider';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIepServiceProvider';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIepServiceProvider';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIepServiceProvider';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeIndividualizedEducationProgram';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeTransportation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The type of services/instruction the school is responsible for providing to the student.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeTransportation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Responsible School Type' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeTransportation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000595' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeTransportation';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21588' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ResponsibleSchoolTypeTransportation';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to an institution by a school, school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001069' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21155' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolIdentifierSea';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The year for a reported school session.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'School Year' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21243' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'SchoolYear';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Sex';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'The concept describing the biological traits that distinguish the males and females of a species.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Sex';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Sex' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Sex';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'000255' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Sex';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21255' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'Sex';

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Def_Desc', @value=N'A unique number or alphanumeric code assigned to a student by a school, school system, a state, or other agency or entity.' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_Element', @value=N'Student Identifier' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_GlobalId', @value=N'001071' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';

EXEC sys.sp_addextendedproperty @name=N'CEDS_URL', @value=N'https://ceds.ed.gov/CEDSElementDetails.aspx?TermId=21157' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'StudentIdentifierState';
