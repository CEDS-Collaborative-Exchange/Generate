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
  [CourseIdentifier]                                                    NVARCHAR (40)  NOT NULL,
  [CourseCodeSystemCode]                                                NVARCHAR (50)  NOT NULL,
  [AccessibleEducationMaterialProviderOrganizationIdentifierSea]        NVARCHAR(60) NULL,
  [AccessibleFormatIndicatorCode]                                       NVARCHAR(50) NULL,
  [AccessibleFormatRequiredIndicatorCode]                               NVARCHAR(50) NULL,
  [AccessibleFormatTypeCode]                                            NVARCHAR(50) NULL,
  [LearningResourceIssuedDate]                                          DATE NULL,
  [LearningResourceOrderedDate]                                         DATE NULL,
  [LearningResourceReceivedDate]                                        DATE NULL,
  [CourseSectionStartDate]                                              DATE NULL,
  [CourseSectionEndDate]                                                DATE NULL,
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
	[OutOfStateIndicator] bit NULL
)
