DROP TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff];

CREATE TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] (
    [BridgeK12StudentCourseSectionK12StaffId] INT    IDENTITY (1, 1) NOT NULL,
    [K12StaffId]                              BIGINT CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_K12StaffId] DEFAULT ((-1)) NOT NULL,
    [K12Staff_CurrentId]                      BIGINT CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_K12Staff_CurrentId] DEFAULT ((-1)) NOT NULL,
    [FactK12StudentCourseSectionId]           BIGINT CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSectionId] DEFAULT ((-1)) NOT NULL,
    [TeacherOfRecord]                         BIT    NULL,
    CONSTRAINT [PK_BridgeK12StudentCourseSectionK12Staff] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionK12StaffId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
);


PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_K12StaffId]...';

CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_K12StaffId]
    ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([K12StaffId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_K12Staff_CurrentId]...';

CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_K12Staff_CurrentId]
    ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([K12Staff_CurrentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]...';

CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]
    ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([FactK12StudentCourseSectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

PRINT N'Altering Table [RDS].[DimAcademicTermDesignators]...';

ALTER TABLE [RDS].[DimAcademicTermDesignators] ALTER COLUMN [AcademicTermDesignatorCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAcademicTermDesignators] ALTER COLUMN [AcademicTermDesignatorDescription] NVARCHAR (MAX) NOT NULL;

PRINT N'Creating Index [RDS].[DimAcademicTermDesignators].[IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]...';

CREATE NONCLUSTERED INDEX [IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]
    ON [RDS].[DimAcademicTermDesignators]([AcademicTermDesignatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

PRINT N'Altering Table [RDS].[DimAeDemographics]...';



ALTER TABLE [RDS].[DimAeDemographics] DROP COLUMN [EconomicDisadvantageStatusCode], COLUMN [EconomicDisadvantageStatusDescription], COLUMN [EnglishLearnerStatusCode], COLUMN [EnglishLearnerStatusDescription], COLUMN [HomelessnessStatusCode], COLUMN [HomelessnessStatusDescription], COLUMN [HomelessPrimaryNighttimeResidenceCode], COLUMN [HomelessPrimaryNighttimeResidenceDescription], COLUMN [HomelessUnaccompaniedYouthStatusCode], COLUMN [HomelessUnaccompaniedYouthStatusDescription], COLUMN [MigrantStatusCode], COLUMN [MigrantStatusDescription], COLUMN [MilitaryConnectedStudentIndicatorCode], COLUMN [MilitaryConnectedStudentIndicatorDescription];
ALTER TABLE [RDS].[DimAeDemographics] ALTER COLUMN [SexCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAeDemographics] ALTER COLUMN [SexDescription] NVARCHAR (200) NOT NULL;


PRINT N'Altering Table [RDS].[DimAeProgramTypes]...';

ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [AeInstructionalProgramTypeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [AeInstructionalProgramTypeDescription] NVARCHAR (150) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [AeSpecialProgramTypeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [AeSpecialProgramTypeDescription] NVARCHAR (150) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [WioaCareerServicesCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [WioaCareerServicesDescription] NVARCHAR (150) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [WioaTrainingServicesCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAeProgramTypes] ALTER COLUMN [WioaTrainingServicesDescription] NVARCHAR (150) NOT NULL;

PRINT N'Starting rebuilding table [RDS].[DimAeProviders]...';

DROP TABLE [RDS].[DimAeProviders];

CREATE TABLE [RDS].[DimAeProviders] (
    [DimAeProviderId]                            INT             IDENTITY (1, 1) NOT NULL,
    [AdultEducationServiceProviderIdentifierSea] NVARCHAR (50)   NULL,
    [NameOfInstitution]                          NVARCHAR (1000) NULL,
    [ShortNameOfInstitution]                     NVARCHAR (30)   NULL,
    [AdultEducationProviderTypeCode]             NVARCHAR (50)   NULL,
    [AdultEducationProviderTypeDescription]      NVARCHAR (150)  NULL,
    [LevelOfInstitutionCode]                     NVARCHAR (50)   NULL,
    [LevelOfInstitutionDescription]              NVARCHAR (150)  NULL,
    [OrganizationOperationalStatusCode]          NVARCHAR (50)   NULL,
    [OrganizationOperationalStatusDescription]   NVARCHAR (150)  NULL,
    [OperationalStatusEffectiveDate]             DATETIME        NULL,
    [TelephoneNumber]                            NVARCHAR (24)   NULL,
    [WebSiteAddress]                             NVARCHAR (300)  NULL,
    [MailingAddressStreetNumberAndName]          NVARCHAR (150)  NULL,
    [MailingAddressApartmentRoomOrSuiteNumber]   NVARCHAR (60)   NULL,
    [MailingAddressCity]                         NVARCHAR (30)   NULL,
    [MailingAddressStateAbbreviation]            NVARCHAR (50)   NULL,
    [MailingAddressPostalCode]                   NVARCHAR (17)   NULL,
    [MailingAddressCountyAnsiCodeCode]           NVARCHAR (50)   NULL,
    [PhysicalAddressStreetNumberAndName]         NVARCHAR (150)  NULL,
    [PhysicalAddressApartmentRoomOrSuiteNumber]  NVARCHAR (60)   NULL,
    [PhysicalAddressCity]                        NVARCHAR (30)   NULL,
    [PhysicalAddressStateAbbreviation]           NVARCHAR (50)   NULL,
    [PhysicalAddressPostalCode]                  NVARCHAR (17)   NULL,
    [PhysicalAddressCountyAnsiCodeCode]          NVARCHAR (50)   NULL,
    [Latitude]                                   NVARCHAR (20)   NULL,
    [Longitude]                                  NVARCHAR (20)   NULL,
    [RecordStartDateTime]                        DATETIME        NULL,
    [RecordEndDateTime]                          DATETIME        NULL,
    CONSTRAINT [PK_DimAeProviders] PRIMARY KEY CLUSTERED ([DimAeProviderId] ASC)
);

PRINT N'Altering Table [RDS].[DimAges]...';

ALTER TABLE [RDS].[DimAges] ALTER COLUMN [AgeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAges] ALTER COLUMN [AgeDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimAges] ALTER COLUMN [AgeEdFactsCode] NVARCHAR (50) NOT NULL;

PRINT N'Creating Index [RDS].[DimAges].[IX_DimAges_AgeCode]...';

CREATE NONCLUSTERED INDEX [IX_DimAges_AgeCode]
    ON [RDS].[DimAges]([AgeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

ALTER TABLE RDS.DimAssessmentAdministrations ALTER COLUMN AssessmentIdentifier nvarchar(40) NULL;
ALTER TABLE RDS.DimAssessmentAdministrations ALTER COLUMN AssessmentAdministrationAssessmentFamily nvarchar(40) NULL;
EXEC sp_rename 'RDS.DimAssessmentAdministrations.SchoolIdentifierSea', 'SchoolIdentifier', 'COLUMN';
EXEC sp_rename 'RDS.DimAssessmentAdministrations.LEAIdentifierSea', 'LocalEducationAgencyIdentifier', 'COLUMN';
EXEC sp_rename 'RDS.DimAssessmentAdministrations.LEAIdentificationSystem', 'LeaIdentificationSystem', 'COLUMN';

PRINT N'Altering Table [RDS].[DimAssessmentParticipationSessions]...';

ALTER TABLE [RDS].[DimAssessmentParticipationSessions]
    ADD [AssessmentSessionActualStartDateTime] DATETIME NULL,
        [AssessmentSessionActualEndDateTime]   DATETIME NULL;

PRINT N'Altering Table [RDS].[DimAssessmentPerformanceLevels]...';

ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelIdentifier] NVARCHAR (40) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelLabel] NVARCHAR (20) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelLowerCutScore] NVARCHAR (30) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelScoreMetric] NVARCHAR (30) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentPerformanceLevels] ALTER COLUMN [AssessmentPerformanceLevelUpperCutScore] NVARCHAR (30) NOT NULL;

PRINT N'Creating Index [RDS].[DimAssessmentPerformanceLevels].[IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]...';

CREATE NONCLUSTERED INDEX [IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]
    ON [RDS].[DimAssessmentPerformanceLevels]([AssessmentPerformanceLevelIdentifier] ASC);


PRINT N'Altering Table [RDS].[DimAssessmentRegistrations]...';

ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationCompletionStatusCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationCompletionStatusDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationParticipationIndicatorCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationParticipationIndicatorDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationReasonNotCompletingCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationReasonNotCompletingDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [AssessmentRegistrationReasonNotCompletingEdFactsCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [LeaFullAcademicYearCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [LeaFullAcademicYearDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [LeaFullAcademicYearEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [ReasonNotTestedCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [ReasonNotTestedDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [ReasonNotTestedEdFactsCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [SchoolFullAcademicYearCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [SchoolFullAcademicYearDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [SchoolFullAcademicYearEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [StateFullAcademicYearCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [StateFullAcademicYearDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentRegistrations] ALTER COLUMN [StateFullAcademicYearEdFactsCode] NVARCHAR (50) NOT NULL;

PRINT N'Altering Table [RDS].[DimAssessments]...';



ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentAcademicSubjectCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentAcademicSubjectDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentAcademicSubjectEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredEdFactsCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredToEnglishLearnersCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredToEnglishLearnersDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeAdministeredToEnglishLearnersEdFactsCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimAssessments] ALTER COLUMN [AssessmentTypeEdFactsCode] NVARCHAR (100) NOT NULL;


PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_Codes]...';

CREATE NONCLUSTERED INDEX [IX_DimAssessments_Codes]
    ON [RDS].[DimAssessments]([AssessmentAcademicSubjectCode] ASC) WITH (FILLFACTOR = 80);


PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentSubjectEdFactsCode]...';


CREATE NONCLUSTERED INDEX [IX_DimAssessments_AssessmentSubjectEdFactsCode]
    ON [RDS].[DimAssessments]([AssessmentAcademicSubjectEdFactsCode] ASC) WITH (FILLFACTOR = 80);


PRINT N'Altering Table [RDS].[DimAssessmentStatuses]...';



ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [AssessedFirstTimeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [AssessedFirstTimeDescription] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [AssessedFirstTimeEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [ProgressLevelCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [ProgressLevelDescription] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimAssessmentStatuses] ALTER COLUMN [ProgressLevelEdFactsCode] NVARCHAR (50) NOT NULL;


PRINT N'Altering Table [RDS].[DimAttendances]...';

ALTER TABLE [RDS].[DimAttendances] DROP COLUMN [AbsenteeismCode], COLUMN [AbsenteeismDescription], COLUMN [AbsenteeismEdFactsCode];

ALTER TABLE [RDS].[DimAttendances]
    ADD [ChronicStudentAbsenteeismIndicatorCode]        NVARCHAR (50)  NULL,
        [ChronicStudentAbsenteeismIndicatorDescription] NVARCHAR (200) NULL,
        [ChronicStudentAbsenteeismIndicatorEdFactsCode] NVARCHAR (50)  NULL,
        [AttendanceEventTypeCode]                       NVARCHAR (50)  NULL,
        [AttendanceEventTypeDescription]                NVARCHAR (200) NULL,
        [AttendanceStatusCode]                          NVARCHAR (50)  NULL,
        [AttendanceStatusDescription]                   NVARCHAR (200) NULL,
        [PresentAttendanceCategoryCode]                 NVARCHAR (50)  NULL,
        [PresentAttendanceCategoryDescription]          NVARCHAR (200) NULL,
        [AbsentAttendanceCategoryCode]                  NVARCHAR (50)  NULL,
        [AbsentAttendanceCategoryDescription]           NVARCHAR (200) NULL;


PRINT N'Altering Table [RDS].[DimCharterSchoolStatuses]...';

ALTER TABLE [RDS].[DimCharterSchoolStatuses] ALTER COLUMN [AppropriationMethodCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCharterSchoolStatuses] ALTER COLUMN [AppropriationMethodDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCharterSchoolStatuses] ALTER COLUMN [AppropriationMethodEdFactsCode] NVARCHAR (50) NOT NULL;

DROP TABLE [RDS].[DimCipCodes];
CREATE TABLE [RDS].[DimCipCodes] (
    [DimCipCodeId]          INT            IDENTITY (1, 1) NOT NULL,
    [CipCode]               NVARCHAR (7)   NULL,
    [CipDescription]        NVARCHAR (200) NULL,
    [CipUseCode]            NVARCHAR (50)  NULL,
    [CipUseDescription]     NVARCHAR (200) NULL,
    [CipVersionCode]        NVARCHAR (50)  NULL,
    [CipVersionDescription] NVARCHAR (200) NULL,
    CONSTRAINT [PK_DimCipCodes] PRIMARY KEY CLUSTERED ([DimCipCodeId] ASC) WITH (DATA_COMPRESSION = PAGE)
);

PRINT N'Creating Index [RDS].[DimCipCodes].[IX_DimCipCodes_CipCode]...';



CREATE NONCLUSTERED INDEX [IX_DimCipCodes_CipCode]
    ON [RDS].[DimCipCodes]([CipCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimCohortStatuses]...';



ALTER TABLE [RDS].[DimCohortStatuses] DROP COLUMN [CohortStatusCode], COLUMN [CohortStatusDescription], COLUMN [CohortStatusEdFactsCode];



ALTER TABLE [RDS].[DimCohortStatuses]
    ADD [EdFactsCohortGraduationStatusCode]        VARCHAR (50)  CONSTRAINT [DF_DimCohortStatuses_EdFactsCohortGraduationStatusCode] DEFAULT ('MISSING') NOT NULL,
        [EdFactsCohortGraduationStatusDescription] VARCHAR (200) CONSTRAINT [DF_DimCohortStatuses_EdFactsCohortGraduationStatusDescription] DEFAULT ('MISSING') NOT NULL,
        [EdFactsCohortGraduationStatusEdFactsCode] VARCHAR (50)  CONSTRAINT [DF_DimCohortStatuses_EdFactsCohortGraduationStatusEdFactsCode] DEFAULT ('MISSING') NOT NULL;



PRINT N'Creating Index [RDS].[DimCohortStatuses].[IX_DimCohortStatuses_EdFactsCohortGraduationStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimCohortStatuses_EdFactsCohortGraduationStatusCode]
    ON [RDS].[DimCohortStatuses]([EdFactsCohortGraduationStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimComprehensiveAndTargetedSupports]...';



ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [AdditionalTargetedSupportAndImprovementStatusCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [AdditionalTargetedSupportAndImprovementStatusDescription] VARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [AdditionalTargetedSupportAndImprovementStatusEDFactsCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [ComprehensiveSupportAndImprovementStatusCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [ComprehensiveSupportAndImprovementStatusDescription] VARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [ComprehensiveSupportAndImprovementStatusEdFactsCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [TargetedSupportAndImprovementStatusCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [TargetedSupportAndImprovementStatusDescription] VARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] ALTER COLUMN [TargetedSupportAndImprovementStatusEdFactsCode] VARCHAR (50) NOT NULL;



PRINT N'Altering Table [RDS].[DimCredentials]...';



ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionAssessmentMethodTypeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionAssessmentMethodTypeDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionIntendedPurposeTypeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionIntendedPurposeTypeDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionStatusTypeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCredentials] ALTER COLUMN [CredentialDefinitionStatusTypeDescription] NVARCHAR (300) NOT NULL;



PRINT N'Creating Index [RDS].[DimCredentials].[IX_DimCredentials_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimCredentials_Codes]
    ON [RDS].[DimCredentials]([CredentialDefinitionCategorySystem] ASC, [CredentialDefinitionCategoryType] ASC, [CredentialDefinitionStatusTypeCode] ASC, [CredentialDefinitionIntendedPurposeTypeCode] ASC, [CredentialDefinitionAssessmentMethodTypeCode] ASC);



PRINT N'Altering Table [RDS].[DimCteStatuses]...';

ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteAeDisplacedHomemakerIndicatorCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteAeDisplacedHomemakerIndicatorDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteAeDisplacedHomemakerIndicatorEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteConcentratorCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteConcentratorDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteConcentratorEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteGraduationRateInclusionCode] NVARCHAR (450) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteGraduationRateInclusionDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteGraduationRateInclusionEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalCompletionCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalCompletionDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalCompletionEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalGenderStatusCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalGenderStatusDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteNontraditionalGenderStatusEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteParticipantCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteParticipantDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [CteParticipantEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [SingleParentOrSinglePregnantWomanStatusCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [SingleParentOrSinglePregnantWomanStatusDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimCteStatuses] ALTER COLUMN [SingleParentOrSinglePregnantWomanStatusEdFactsCode] NVARCHAR (50) NOT NULL;

PRINT N'Altering Table [RDS].[DimDataMigrationTypes]...';

ALTER TABLE [RDS].[DimDataMigrationTypes] ALTER COLUMN [DataMigrationTypeCode] VARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDataMigrationTypes] ALTER COLUMN [DataMigrationTypeName] VARCHAR (50) NOT NULL;

PRINT N'Altering Table [RDS].[DimDates]...';

ALTER TABLE [RDS].[DimDates] ALTER COLUMN [DateValue] DATETIME2 (7) NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [Day] INT NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [DayOfWeek] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [DayOfYear] INT NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [Month] INT NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [MonthName] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [SubmissionYear] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDates] ALTER COLUMN [Year] INT NOT NULL;


PRINT N'Creating Index [RDS].[DimDates].[IX_DimDates_DateValue]...';

CREATE NONCLUSTERED INDEX [IX_DimDates_DateValue]
    ON [RDS].[DimDates]([DateValue] ASC)
    INCLUDE([DimDateId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


PRINT N'Creating Index [RDS].[DimDates].[IX_DimDates_SubmissionYear]...';

CREATE NONCLUSTERED INDEX [IX_DimDates_SubmissionYear]
    ON [RDS].[DimDates]([SubmissionYear] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

PRINT N'Creating Index [RDS].[DimDates].[IXFK_FactK12SeaJobCatalogues_CountDateId]...';

CREATE NONCLUSTERED INDEX [IXFK_FactK12SeaJobCatalogues_CountDateId]
    ON [RDS].[DimDates]([DimDateId] ASC);

PRINT N'Creating Index [RDS].[DimDates].[IXFK_FactK12SeaJobCatalogues_EmploymentEndDateId]...';

CREATE NONCLUSTERED INDEX [IXFK_FactK12SeaJobCatalogues_EmploymentEndDateId]
    ON [RDS].[DimDates]([DimDateId] ASC);

PRINT N'Creating Index [RDS].[DimDates].[IXFK_FactK12SeaJobCatalogues_EmploymentStartDateId]...';

CREATE NONCLUSTERED INDEX [IXFK_FactK12SeaJobCatalogues_EmploymentStartDateId]
    ON [RDS].[DimDates]([DimDateId] ASC);

PRINT N'Altering Table [RDS].[DimDisabilityStatuses]...';


ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityConditionTypeCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityConditionTypeDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityDeterminationSourceTypeCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityDeterminationSourceTypeDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityStatusCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [DisabilityStatusDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [Section504StatusCode] NVARCHAR (100) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [Section504StatusDescription] NVARCHAR (300) NOT NULL;
ALTER TABLE [RDS].[DimDisabilityStatuses] ALTER COLUMN [Section504StatusEdFactsCode] NVARCHAR (50) NOT NULL;

PRINT N'Creating Index [RDS].[DimDisabilityStatuses].[IX_DimDisabilityStatuses_Codes]...';

CREATE NONCLUSTERED INDEX [IX_DimDisabilityStatuses_Codes]
    ON [RDS].[DimDisabilityStatuses]([DisabilityStatusCode] ASC, [Section504StatusCode] ASC, [DisabilityConditionTypeCode] ASC, [DisabilityDeterminationSourceTypeCode] ASC);



PRINT N'Altering Table [RDS].[DimDisciplineStatuses]...';

ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplinaryActionTakenCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplinaryActionTakenDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplinaryActionTakenEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplineMethodOfChildrenWithDisabilitiesCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplineMethodOfChildrenWithDisabilitiesDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [EducationalServicesAfterRemovalCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [EducationalServicesAfterRemovalDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [EducationalServicesAfterRemovalEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalEdFactsCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalReasonCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalReasonDescription] NVARCHAR (200) NOT NULL;
ALTER TABLE [RDS].[DimDisciplineStatuses] ALTER COLUMN [IdeaInterimRemovalReasonEdFactsCode] NVARCHAR (50) NOT NULL;

PRINT N'Creating Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_Codes]...';

CREATE NONCLUSTERED INDEX [IX_DimDisciplineStatuses_Codes]
    ON [RDS].[DimDisciplineStatuses]([DisciplinaryActionTakenCode] ASC, [DisciplineMethodOfChildrenWithDisabilitiesCode] ASC, [EducationalServicesAfterRemovalCode] ASC, [IdeaInterimRemovalCode] ASC) WITH (FILLFACTOR = 80);

PRINT N'Creating Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_DisciplineActionEdFactsCode]...';

CREATE NONCLUSTERED INDEX [IX_DimDisciplineStatuses_DisciplineActionEdFactsCode]
    ON [RDS].[DimDisciplineStatuses]([DisciplinaryActionTakenEdFactsCode] ASC) WITH (FILLFACTOR = 80);

PRINT N'Creating Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_DisciplineMethodEdFactsCode]...';

CREATE NONCLUSTERED INDEX [IX_DimDisciplineStatuses_DisciplineMethodEdFactsCode]
    ON [RDS].[DimDisciplineStatuses]([DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode] ASC) WITH (FILLFACTOR = 80);

PRINT N'Creating Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_EducationalServicesEdFactsCode]...';

CREATE NONCLUSTERED INDEX [IX_DimDisciplineStatuses_EducationalServicesEdFactsCode]
    ON [RDS].[DimDisciplineStatuses]([EducationalServicesAfterRemovalEdFactsCode] ASC) WITH (FILLFACTOR = 80);

PRINT N'Creating Index [RDS].[DimDisciplineStatuses].[IX_DimDisciplineStatuses_RemovalTypeEdFactsCode]...';

CREATE NONCLUSTERED INDEX [IX_DimDisciplineStatuses_RemovalTypeEdFactsCode]
    ON [RDS].[DimDisciplineStatuses]([IdeaInterimRemovalEdFactsCode] ASC) WITH (FILLFACTOR = 80);


PRINT N'Altering Table [RDS].[DimFederalFinancialAccountBalances]...';


ALTER TABLE [RDS].[DimFederalFinancialAccountBalances] ALTER COLUMN [FinancialAccountBalanceSheetCodeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountBalances] ALTER COLUMN [FinancialAccountBalanceSheetCodeDescription] NVARCHAR (150) NOT NULL;


PRINT N'Altering Table [RDS].[DimFederalFinancialAccountClassifications]...';

ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountCategoryCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountCategoryDescription] NVARCHAR (150) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountFundClassificationCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountFundClassificationDescription] NVARCHAR (150) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountProgramCodeCode] NVARCHAR (50) NOT NULL;
ALTER TABLE [RDS].[DimFederalFinancialAccountClassifications] ALTER COLUMN [FinancialAccountProgramCodeDescription] NVARCHAR (150) NOT NULL;


PRINT N'Altering Table [RDS].[DimFederalFinancialExpenditureClassifications]...';

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureFunctionCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureFunctionCodeDescription] NVARCHAR (150) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureLevelOfInstructionCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureLevelOfInstructionCodeDescription] NVARCHAR (150) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureObjectCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureObjectCodeDescription] NVARCHAR (150) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureProjectReportingCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialExpenditureClassifications] ALTER COLUMN [FinancialExpenditureProjectReportingCodeDescription] NVARCHAR (150) NOT NULL;



PRINT N'Altering Table [RDS].[DimFederalFinancialRevenueClassifications]...';



ALTER TABLE [RDS].[DimFederalFinancialRevenueClassifications] ALTER COLUMN [FinancialAccountRevenueCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalFinancialRevenueClassifications] ALTER COLUMN [FinancialAccountRevenueCodeDescription] NVARCHAR (150) NOT NULL;



ALTER TABLE [RDS].[DimFederalFinancialRevenueClassifications]
    ADD [FinancialAccountRevenueObjectCodeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimFederalFinancialRevenueClassifications_FinancialAccountRevenueObjectCodeCode] DEFAULT ('MISSING') NOT NULL,
        [FinancialAccountRevenueObjectCodeDescription] NVARCHAR (150) CONSTRAINT [DF_DimFederalFinancialRevenueClassifications_FinancialAccountRevenueObjectCodeDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Altering Table [RDS].[DimFederalProgramCodes]...';



ALTER TABLE [RDS].[DimFederalProgramCodes] ALTER COLUMN [FederalProgramCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalProgramCodes] ALTER COLUMN [FederalProgramCodeDescription] NVARCHAR (150) NOT NULL;

ALTER TABLE [RDS].[DimFederalProgramCodes] ALTER COLUMN [FederalProgramSubgrantCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFederalProgramCodes] ALTER COLUMN [FederalProgramSubgrantCodeDescription] NVARCHAR (150) NOT NULL;



PRINT N'Altering Table [RDS].[DimFinancialAccounts]...';



ALTER TABLE [RDS].[DimFinancialAccounts] ALTER COLUMN [FinancialAccountDescription] NVARCHAR (300) NOT NULL;

ALTER TABLE [RDS].[DimFinancialAccounts] ALTER COLUMN [FinancialAccountName] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimFinancialAccounts] ALTER COLUMN [FinancialAccountNumber] NVARCHAR (30) NOT NULL;



ALTER TABLE [RDS].[DimFinancialAccounts]
    ADD [RecordStartDateTime] DATETIME NULL,
        [RecordEndDateTime]   DATETIME NULL;



PRINT N'Altering Table [RDS].[DimFirearmDisciplineStatuses]...';



ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [DisciplineMethodForFirearmsIncidentsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [DisciplineMethodForFirearmsIncidentsDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [DisciplineMethodForFirearmsIncidentsEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [IdeaDisciplineMethodForFirearmsIncidentsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [IdeaDisciplineMethodForFirearmsIncidentsDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimFirearmDisciplineStatuses] ALTER COLUMN [IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Altering Table [RDS].[DimFirearms]...';



ALTER TABLE [RDS].[DimFirearms] ALTER COLUMN [FirearmTypeCode] VARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFirearms] ALTER COLUMN [FirearmTypeDescription] VARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimFirearms] ALTER COLUMN [FirearmTypeEdFactsCode] VARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimFirearms].[IX_DimFirearms_FirearmTypeCode]...';



CREATE NONCLUSTERED INDEX [IX_DimFirearms_FirearmTypeCode]
    ON [RDS].[DimFirearms]([FirearmTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimFirearms].[IX_DimFirearms_FirearmTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimFirearms_FirearmTypeEdFactsCode]
    ON [RDS].[DimFirearms]([FirearmTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimFiscalPeriods]...';



ALTER TABLE [RDS].[DimFiscalPeriods] ALTER COLUMN [FiscalPeriodBeginDate] DATETIME NOT NULL;

ALTER TABLE [RDS].[DimFiscalPeriods] ALTER COLUMN [FiscalPeriodEndDate] DATETIME NULL;

PRINT N'Altering Table [RDS].[DimFiscalYears]...';



ALTER TABLE [RDS].[DimFiscalYears] ALTER COLUMN [FiscalPeriodBeginDate] DATETIME NOT NULL;

ALTER TABLE [RDS].[DimFiscalYears] ALTER COLUMN [FiscalPeriodEndDate] DATETIME NULL;

ALTER TABLE [RDS].[DimFiscalYears] ALTER COLUMN [FiscalYear] SMALLINT NOT NULL;



PRINT N'Altering Table [RDS].[DimFosterCareStatuses]...';



ALTER TABLE [RDS].[DimFosterCareStatuses] ALTER COLUMN [ProgramParticipationFosterCareCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimFosterCareStatuses] ALTER COLUMN [ProgramParticipationFosterCareDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimFosterCareStatuses] ALTER COLUMN [ProgramParticipationFosterCareEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Altering Table [RDS].[DimGradeLevels]...';



ALTER TABLE [RDS].[DimGradeLevels] ALTER COLUMN [GradeLevelCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimGradeLevels] ALTER COLUMN [GradeLevelDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimGradeLevels] ALTER COLUMN [GradeLevelEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimGradeLevels].[IX_DimGradeLevels_GradeLevelCode]...';



CREATE NONCLUSTERED INDEX [IX_DimGradeLevels_GradeLevelCode]
    ON [RDS].[DimGradeLevels]([GradeLevelCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimGradeLevels].[IX_DimGradeLevels_GradeLevelEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimGradeLevels_GradeLevelEdFactsCode]
    ON [RDS].[DimGradeLevels]([GradeLevelEdFactsCode] ASC);

PRINT N'Starting rebuilding table [RDS].[DimHomelessnessStatuses]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [RDS].[tmp_ms_xx_DimHomelessnessStatuses] (
    [DimHomelessnessStatusId]                      INT            IDENTITY (1, 1) NOT NULL,
    [HomelessnessStatusCode]                       NVARCHAR (100) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessnessStatusCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessnessStatusDescription]                NVARCHAR (300) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessnessStatusDescription] DEFAULT ('MISSING') NOT NULL,
    [HomelessnessStatusEdFactsCode]                NVARCHAR (50)  CONSTRAINT [DF_DimHomelessnessStatuses_HomelessnessStatusEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessPrimaryNighttimeResidenceCode]        NVARCHAR (100) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessPrimaryNighttimeResidenceCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessPrimaryNighttimeResidenceDescription] NVARCHAR (300) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessPrimaryNighttimeResidenceDescription] DEFAULT ('MISSING') NOT NULL,
    [HomelessPrimaryNighttimeResidenceEdFactsCode] NVARCHAR (50)  CONSTRAINT [DF_DimHomelessnessStatuses_HomelessPrimaryNighttimeResidenceEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessServicedIndicatorCode]                NVARCHAR (100) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessServicedIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessServicedIndicatorDescription]         NVARCHAR (300) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessServicedIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    [HomelessUnaccompaniedYouthStatusCode]         NVARCHAR (100) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessUnaccompaniedYouthStatusCode] DEFAULT ('MISSING') NOT NULL,
    [HomelessUnaccompaniedYouthStatusDescription]  NVARCHAR (300) CONSTRAINT [DF_DimHomelessnessStatuses_HomelessUnaccompaniedYouthStatusDescription] DEFAULT ('MISSING') NOT NULL,
    [HomelessUnaccompaniedYouthStatusEdFactsCode]  NVARCHAR (50)  CONSTRAINT [DF_DimHomelessnessStatuses_HomelessUnaccompaniedYouthStatusEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_DimHomelessnessStatuses1] PRIMARY KEY CLUSTERED ([DimHomelessnessStatusId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [RDS].[DimHomelessnessStatuses])
    BEGIN
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimHomelessnessStatuses] ON;
        INSERT INTO [RDS].[tmp_ms_xx_DimHomelessnessStatuses] ([DimHomelessnessStatusId], [HomelessnessStatusCode], [HomelessnessStatusDescription], [HomelessnessStatusEdFactsCode], [HomelessPrimaryNighttimeResidenceCode], [HomelessPrimaryNighttimeResidenceDescription], [HomelessPrimaryNighttimeResidenceEdfactsCode], [HomelessServicedIndicatorCode], [HomelessServicedIndicatorDescription], [HomelessUnaccompaniedYouthStatusCode], [HomelessUnaccompaniedYouthStatusDescription], [HomelessUnaccompaniedYouthStatusEdfactsCode])
        SELECT   [DimHomelessnessStatusId],
                 [HomelessnessStatusCode],
                 [HomelessnessStatusDescription],
                 [HomelessnessStatusEdFactsCode],
                 [HomelessPrimaryNighttimeResidenceCode],
                 [HomelessPrimaryNighttimeResidenceDescription],
                 [HomelessPrimaryNighttimeResidenceEdfactsCode],
                 [HomelessServicedIndicatorCode],
                 [HomelessServicedIndicatorDescription],
                 [HomelessUnaccompaniedYouthStatusCode],
                 [HomelessUnaccompaniedYouthStatusDescription],
                 [HomelessUnaccompaniedYouthStatusEdfactsCode]
        FROM     [RDS].[DimHomelessnessStatuses]
        ORDER BY [DimHomelessnessStatusId] ASC;
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimHomelessnessStatuses] OFF;
    END

DROP TABLE [RDS].[DimHomelessnessStatuses];

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimHomelessnessStatuses]', N'DimHomelessnessStatuses';

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimHomelessnessStatuses1]', N'PK_DimHomelessnessStatuses', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


PRINT N'Altering Table [RDS].[DimIdeaDisabilityTypes]...';



ALTER TABLE [RDS].[DimIdeaDisabilityTypes] ALTER COLUMN [IdeaDisabilityTypeCode] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimIdeaDisabilityTypes] ALTER COLUMN [IdeaDisabilityTypeDescription] NVARCHAR (300) NOT NULL;

ALTER TABLE [RDS].[DimIdeaDisabilityTypes] ALTER COLUMN [IdeaDisabilityTypeEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Altering Table [RDS].[DimIdeaStatuses]...';



ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForEarlyChildhoodCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForEarlyChildhoodDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForSchoolAgeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForSchoolAgeDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaEducationalEnvironmentForSchoolAgeEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaIndicatorCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaIndicatorDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [IdeaIndicatorEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [SpecialEducationExitReasonCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [SpecialEducationExitReasonDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIdeaStatuses] ALTER COLUMN [SpecialEducationExitReasonEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_Codes]
    ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonCode] ASC, [IdeaEducationalEnvironmentForSchoolAgeCode] ASC, [IdeaEducationalEnvironmentForEarlyChildhoodCode] ASC, [IdeaIndicatorCode] ASC);



PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]
    ON [RDS].[DimIdeaStatuses]([IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]
    ON [RDS].[DimIdeaStatuses]([IdeaEducationalEnvironmentForSchoolAgeEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_BasisOfExitEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_BasisOfExitEdFactsCode]
    ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


DROP TABLE [RDS].[DimIeus];

CREATE TABLE [RDS].[DimIeus] (
    [DimIeuId]                                  INT             IDENTITY (1, 1) NOT NULL,
    [IeuOrganizationName]                       NVARCHAR (1000) NULL,
    [IeuOrganizationIdentifierSea]              NVARCHAR (50)   NULL,
    [SeaOrganizationName]                       NVARCHAR (1000) NULL,
    [SeaOrganizationIdentifierSea]              NVARCHAR (50)   NULL,
    [StateAnsiCode]                             NVARCHAR (10)   NULL,
    [StateAbbreviationCode]                     NVARCHAR (10)   NULL,
    [StateAbbreviationDescription]              NVARCHAR (1000) NULL,
    [MailingAddressStreetNumberAndName]         NVARCHAR (150)  NULL,
    [MailingAddressApartmentRoomOrSuiteNumber]  VARCHAR (40)    NULL,
    [MailingAddressCity]                        NVARCHAR (30)   NULL,
    [MailingAddressStateAbbreviation]           NVARCHAR (50)   NULL,
    [MailingAddressPostalCode]                  NVARCHAR (17)   NULL,
    [MailingAddressCountyAnsiCodeCode]          CHAR (5)        NULL,
    [MailingAddressCountyName]                  NVARCHAR (30)   NULL,
    [OutOfStateIndicator]                       BIT             NOT NULL,
    [OrganizationOperationalStatus]             VARCHAR (20)    NULL,
    [OperationalStatusEffectiveDate]            DATETIME        NULL,
    [PhysicalAddressStreetNumberAndName]        NVARCHAR (150)  NULL,
    [PhysicalAddressApartmentRoomOrSuiteNumber] VARCHAR (40)    NULL,
    [PhysicalAddressCity]                       NVARCHAR (30)   NULL,
    [PhysicalAddressPostalCode]                 NVARCHAR (17)   NULL,
    [PhysicalAddressStateAbbreviation]          NVARCHAR (50)   NULL,
    [PhysicalAddressCountyAnsiCodeCode]         CHAR (5)        NULL,
    [PhysicalAddressCountyName]                 NVARCHAR (30)   NULL,
    [TelephoneNumber]                           NVARCHAR (24)   NULL,
    [WebSiteAddress]                            NVARCHAR (300)  NULL,
    [OrganizationRegionGeoJson]                 NVARCHAR (MAX)  NULL,
    [Latitude]                                  NVARCHAR (20)   NULL,
    [Longitude]                                 NVARCHAR (20)   NULL,
    [RecordStartDateTime]                       DATETIME        NOT NULL,
    [RecordEndDateTime]                         DATETIME        NULL,
    CONSTRAINT [PK_DimIeus] PRIMARY KEY CLUSTERED ([DimIeuId] ASC) WITH (FILLFACTOR = 80)
);

DROP TABLE [RDS].[DimIncidentBehaviors];

CREATE TABLE [RDS].[DimIncidentBehaviors] (
    [DimIncidentBehaviorId]                INT            IDENTITY (1, 1) NOT NULL,
    [IncidentBehaviorCode]                 NVARCHAR (100) CONSTRAINT [DF_DimIncidentBehaviorss_IncidentBehaviorCode] DEFAULT ('MISSING') NOT NULL,
    [IncidentBehaviorDescription]          NVARCHAR (200) CONSTRAINT [DF_DimIncidentBehaviorss_IncidentBehaviorDescription] DEFAULT ('MISSING') NOT NULL,
    [SecondaryIncidentBehaviorCode]        NVARCHAR (100) CONSTRAINT [DF_DimIncidentBehaviorss_SecondaryIncidentBehaviorCode] DEFAULT ('MISSING') NOT NULL,
    [SecondaryIncidentBehaviorDescription] NVARCHAR (200) CONSTRAINT [DF_DimIncidentBehaviorss_SecondaryIncidentBehaviorDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [PK_DimIncidentBehaviors] PRIMARY KEY CLUSTERED ([DimIncidentBehaviorId] ASC)
);

PRINT N'Altering Table [RDS].[DimIncidentStatuses]...';



ALTER TABLE [RDS].[DimIncidentStatuses] DROP COLUMN [IncidentBehaviorCode], COLUMN [IncidentBehaviorDescription];



ALTER TABLE [RDS].[DimIncidentStatuses]
    ADD [IncidentReportedToLawEnforcementIndicatorCode]        NVARCHAR (100) CONSTRAINT [DF_DimIncidentStatuses_IncidentReportedToLawEnforcementIndicatorCode] DEFAULT ('MISSING') NOT NULL,
        [IncidentReportedToLawEnforcementIndicatorDescription] NVARCHAR (300) CONSTRAINT [DF_DimIncidentStatuses_IncidentReportedToLawEnforcementIndicatorDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Altering Table [RDS].[DimIndicatorStatuses]...';



ALTER TABLE [RDS].[DimIndicatorStatuses] DROP COLUMN [IndicatorStatusId];



ALTER TABLE [RDS].[DimIndicatorStatuses] ALTER COLUMN [IndicatorStatusCode] VARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIndicatorStatuses] ALTER COLUMN [IndicatorStatusDescription] VARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIndicatorStatuses] ALTER COLUMN [IndicatorStatusEdFactsCode] VARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimIndicatorStatuses].[IX_DimIndicatorStatuses_IndicatorStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatuses_IndicatorStatusCode]
    ON [RDS].[DimIndicatorStatuses]([IndicatorStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimIndicatorStatuses].[IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode]
    ON [RDS].[DimIndicatorStatuses]([IndicatorStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimIndicatorStatusTypes]...';



ALTER TABLE [RDS].[DimIndicatorStatusTypes] DROP COLUMN [IndicatorStatusTypeId];



ALTER TABLE [RDS].[DimIndicatorStatusTypes] ALTER COLUMN [IndicatorStatusTypeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimIndicatorStatusTypes] ALTER COLUMN [IndicatorStatusTypeDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimIndicatorStatusTypes] ALTER COLUMN [IndicatorStatusTypeEdFactsCode] VARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimIndicatorStatusTypes].[IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode]
    ON [RDS].[DimIndicatorStatusTypes]([IndicatorStatusTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimIndicatorStatusTypes].[IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode]
    ON [RDS].[DimIndicatorStatusTypes]([IndicatorStatusTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12AcademicAwardStatuses]...';



ALTER TABLE [RDS].[DimK12AcademicAwardStatuses] ALTER COLUMN [HighSchoolDiplomaTypeCode] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimK12AcademicAwardStatuses] ALTER COLUMN [HighSchoolDiplomaTypeDescription] NVARCHAR (300) NOT NULL;

ALTER TABLE [RDS].[DimK12AcademicAwardStatuses] ALTER COLUMN [HighSchoolDiplomaTypeEdFactsCode] NVARCHAR (50) NOT NULL;



ALTER TABLE [RDS].[DimK12AcademicAwardStatuses]
    ADD [HighSchoolDiplomaDistinctionTypeCode]        NVARCHAR (100) CONSTRAINT [DF_DimK12AcademicAwardStatuses_HighSchoolDiplomaDistinctionTypeCode] DEFAULT ('MISSING') NOT NULL,
        [HighSchoolDiplomaDistinctionTypeDescription] NVARCHAR (300) CONSTRAINT [DF_DimK12AcademicAwardStatuses_HighSchoolDiplomaDistinctionTypeDescription] DEFAULT ('MISSING') NOT NULL,
        [ProjectedHighSchoolDiplomaTypeCode]          NVARCHAR (100) CONSTRAINT [DF_DimK12AcademicAwardStatuses_ProjectedHighSchoolDiplomaTypeCode] DEFAULT ('MISSING') NOT NULL,
        [ProjectedHighSchoolDiplomaTypeDescription]   NVARCHAR (300) CONSTRAINT [DF_DimK12AcademicAwardStatuses_ProjectedHighSchoolDiplomaTypeDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Altering Table [RDS].[DimK12Courses]...';



ALTER TABLE [RDS].[DimK12Courses] ALTER COLUMN [CourseDescription] NVARCHAR (1024) NOT NULL;



ALTER TABLE [RDS].[DimK12Courses]
    ADD [CourseFundingProgramAllowed]   NVARCHAR (30)  NULL,
        [CoreAcademicCourseCode]        NVARCHAR (50)  NULL,
        [CoreAcademicCourseDescription] NVARCHAR (200) NULL,
        [CourseBeginDate]               DATETIME       NULL,
        [CourseEndDate]                 DATETIME       NULL,
        [RecordStartDateTime]           DATETIME       NULL,
        [RecordEndDateTime]             DATETIME       NULL;



PRINT N'Altering Table [RDS].[DimK12Demographics]...';



ALTER TABLE [RDS].[DimK12Demographics] ALTER COLUMN [SexCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12Demographics] ALTER COLUMN [SexDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12Demographics] ALTER COLUMN [SexEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_SexEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_SexEdFactsCode]
    ON [RDS].[DimK12Demographics]([SexEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12EnrollmentStatuses]...';



ALTER TABLE [RDS].[DimK12EnrollmentStatuses] DROP COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode], COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription], COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode], COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode], COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription], COLUMN [EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode], COLUMN [PostSecondaryEnrollmentStatusCode], COLUMN [PostSecondaryEnrollmentStatusDescription], COLUMN [PostSecondaryEnrollmentStatusEdFactsCode];



ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [EnrollmentStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [EnrollmentStatusDescription] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [EntryTypeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [EntryTypeDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [ExitOrWithdrawalTypeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12EnrollmentStatuses] ALTER COLUMN [ExitOrWithdrawalTypeDescription] NVARCHAR (300) NOT NULL;


ALTER TABLE [RDS].[DimK12EnrollmentStatuses]
    ADD [AdjustedExitOrWithdrawalTypeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimK12EnrollmentStatuses_AdjustedExitOrWithdrawalTypeCode] DEFAULT ('MISSING') NOT NULL,
        [AdjustedExitOrWithdrawalTypeDescription] NVARCHAR (300) CONSTRAINT [DF_DimK12EnrollmentStatuses_AdjustedExitOrWithdrawalTypeDescription] DEFAULT ('MISSING') NOT NULL,
        [ExitOrWithdrawalStatusCode]              NVARCHAR (50)  CONSTRAINT [DF_DimK12EnrollmentStatuses_ExitOrWithdrawalStatusCode] DEFAULT ('MISSING') NOT NULL,
        [ExitOrWithdrawalStatusDescription]       NVARCHAR (300) CONSTRAINT [DF_DimK12EnrollmentStatuses_ExitOrWithdrawalStatusDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Creating Index [RDS].[DimK12EnrollmentStatuses].[IX_DimK12EnrollmentStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimK12EnrollmentStatuses_Codes]
    ON [RDS].[DimK12EnrollmentStatuses]([EnrollmentStatusCode] ASC, [EntryTypeCode] ASC, [ExitOrWithdrawalTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12OrganizationStatuses]...';



ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [GunFreeSchoolsActReportingStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [GunFreeSchoolsActReportingStatusDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [GunFreeSchoolsActReportingStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [HighSchoolGraduationRateIndicatorStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [HighSchoolGraduationRateIndicatorStatusDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [HighSchoolGraduationRateIndicatorStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [ReapAlternativeFundingStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [ReapAlternativeFundingStatusDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [ReapAlternativeFundingStatusEdFactsCode] NVARCHAR (50) NOT NULL;


PRINT N'Creating Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_Codes]
    ON [RDS].[DimK12OrganizationStatuses]([ReapAlternativeFundingStatusCode] ASC, [GunFreeSchoolsActReportingStatusCode] ASC, [HighSchoolGraduationRateIndicatorStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses]([GunFreeSchoolsActReportingStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses]([HighSchoolGraduationRateIndicatorStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12OrganizationStatuses].[IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode]
    ON [RDS].[DimK12OrganizationStatuses]([ReapAlternativeFundingStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12ProgramTypes]...';

ALTER TABLE [RDS].[DimK12ProgramTypes] ALTER COLUMN [ProgramTypeDefinition] NVARCHAR (MAX) NOT NULL;
ALTER TABLE [RDS].[DimK12ProgramTypes] ALTER COLUMN [ProgramTypeDescription] NVARCHAR (60) NOT NULL;

ALTER TABLE [RDS].[DimK12Schools] ADD [SchoolIdentifierAct] NVARCHAR (50) NULL;
ALTER TABLE [RDS].[DimK12Schools] ALTER COLUMN [MailingAddressStreetNumberAndName] NVARCHAR (40) NULL;
ALTER TABLE [RDS].[DimK12Schools] ALTER COLUMN [PhysicalAddressStreetNumberAndName] NVARCHAR (40) NULL;
ALTER TABLE [RDS].[DimK12Schools] ALTER COLUMN [MailingAddressApartmentRoomOrSuiteNumber] VARCHAR (40) NULL;
ALTER TABLE [RDS].[DimK12Schools] ALTER COLUMN [PhysicalAddressApartmentRoomOrSuiteNumber] VARCHAR (40) NULL;
ALTER TABLE [RDS].[DimK12Schools] ADD MailingAddressCountyName NVARCHAR (30) NULL;
ALTER TABLE [RDS].[DimK12Schools] ADD PhysicalAddressCountyName NVARCHAR (30) NULL;

PRINT N'Altering Table [RDS].[DimK12SchoolStateStatuses]...';



ALTER TABLE [RDS].[DimK12SchoolStateStatuses] ALTER COLUMN [SchoolStateStatusCode] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStateStatuses] ALTER COLUMN [SchoolStateStatusDescription] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStateStatuses] ALTER COLUMN [SchoolStateStatusEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimK12SchoolStateStatuses].[IX_DimK12SchoolStateStatuses_SchoolStateStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStateStatuses_SchoolStateStatusCode]
    ON [RDS].[DimK12SchoolStateStatuses]([SchoolStateStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimRaces_SchoolStateStatusCode]
    ON [RDS].[DimK12SchoolStateStatuses]([SchoolStateStatusCode] ASC);



PRINT N'Creating Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimRaces_SchoolStateStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStateStatuses]([SchoolStateStatusEdFactsCode] ASC);



PRINT N'Altering Table [RDS].[DimK12SchoolStatuses]...';



ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [MagnetOrSpecialProgramEmphasisSchoolCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [MagnetOrSpecialProgramEmphasisSchoolDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [MagnetOrSpecialProgramEmphasisSchoolEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [NslpStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [NslpStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [NslpStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [PersistentlyDangerousStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [PersistentlyDangerousStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [PersistentlyDangerousStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [ProgressAchievingEnglishLanguageProficiencyIndicatorTypeDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [ProgressAchievingEnglishLanguageProficiencyIndicatorTypeEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SchoolImprovementStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SchoolImprovementStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SchoolImprovementStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SharedTimeIndicatorCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SharedTimeIndicatorDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [SharedTimeIndicatorEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [StatePovertyDesignationCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [StatePovertyDesignationDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [StatePovertyDesignationEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [VirtualSchoolStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [VirtualSchoolStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12SchoolStatuses] ALTER COLUMN [VirtualSchoolStatusEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses]([MagnetOrSpecialProgramEmphasisSchoolEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses]([NslpStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses]([SharedTimeIndicatorEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses]([StatePovertyDesignationEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]
    ON [RDS].[DimK12SchoolStatuses]([VirtualSchoolStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12StaffCategories]...';



ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [K12StaffClassificationCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [K12StaffClassificationDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [K12StaffClassificationEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [SpecialEducationSupportServicesCategoryCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [SpecialEducationSupportServicesCategoryDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [SpecialEducationSupportServicesCategoryEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [TitleIProgramStaffCategoryCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [TitleIProgramStaffCategoryDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffCategories] ALTER COLUMN [TitleIProgramStaffCategoryEdFactsCode] NVARCHAR (50) NOT NULL;



ALTER TABLE [RDS].[DimK12StaffCategories]
    ADD [MigrantEducationProgramStaffCategoryCode]            NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffCategories_MigrantEducationProgramStaffCategoryCode] DEFAULT ('MISSING') NOT NULL,
        [MigrantEducationProgramStaffCategoryDescription]     NVARCHAR (200) CONSTRAINT [DF_DimK12StaffCategories_MigrantEducationProgramStaffCategoryDescription] DEFAULT ('MISSING') NOT NULL,
        [ProfessionalEducationalJobClassificationCode]        NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffCategories_ProfessionalEducationalJobClassificationCode] DEFAULT ('MISSING') NOT NULL,
        [ProfessionalEducationalJobClassificationDescription] NVARCHAR (200) CONSTRAINT [DF_DimK12StaffCategories_ProfessionalEducationalJobClassificationDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Creating Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_Codes]
    ON [RDS].[DimK12StaffCategories]([K12StaffClassificationCode] ASC, [SpecialEducationSupportServicesCategoryCode] ASC, [TitleIProgramStaffCategoryCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode]
    ON [RDS].[DimK12StaffCategories]([K12StaffClassificationEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode]
    ON [RDS].[DimK12StaffCategories]([SpecialEducationSupportServicesCategoryEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffCategories].[IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode]
    ON [RDS].[DimK12StaffCategories]([TitleIProgramStaffCategoryEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Altering Table [RDS].[DimK12StaffStatuses]...';



ALTER TABLE [RDS].[DimK12StaffStatuses] DROP COLUMN [TeachingCredentialTypeCode], COLUMN [TeachingCredentialTypeDescription], COLUMN [TeachingCredentialTypeEdFactsCode];



ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsCertificationStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsCertificationStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsCertificationStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherInexperiencedStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherInexperiencedStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherInexperiencedStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherOutOfFieldStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherOutOfFieldStatusDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [EdFactsTeacherOutOfFieldStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [HighlyQualifiedTeacherIndicatorCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [HighlyQualifiedTeacherIndicatorDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [HighlyQualifiedTeacherIndicatorEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [ParaprofessionalQualificationStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [ParaprofessionalQualificationStatusDescription] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [ParaprofessionalQualificationStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationAgeGroupTaughtCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationAgeGroupTaughtDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationAgeGroupTaughtEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationTeacherQualificationStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationTeacherQualificationStatusDescription] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimK12StaffStatuses] ALTER COLUMN [SpecialEducationTeacherQualificationStatusEdFactsCode] NVARCHAR (50) NOT NULL;



ALTER TABLE [RDS].[DimK12StaffStatuses]
    ADD [SpecialEducationRelatedServicesPersonnelCode]        NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationRelatedServicesPersonnelCode] DEFAULT ('MISSING') NOT NULL,
        [SpecialEducationRelatedServicesPersonnelDescription] NVARCHAR (200) CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationRelatedServicesPersonnelDescription] DEFAULT ('MISSING') NOT NULL,
        [CTEInstructorIndustryCertificationCode]              NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffStatuses_CTEInstructorIndustryCertificationCode] DEFAULT ('MISSING') NOT NULL,
        [CTEInstructorIndustryCertificationDescription]       NVARCHAR (200) CONSTRAINT [DF_DimK12StaffStatuses_CTEInstructorIndustryCertificationDescription] DEFAULT ('MISSING') NOT NULL,
        [SpecialEducationParaprofessionalCode]                NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationParaprofessionalCode] DEFAULT ('MISSING') NOT NULL,
        [SpecialEducationParaprofessionalDescription]         NVARCHAR (200) CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationParaprofessionalDescription] DEFAULT ('MISSING') NOT NULL,
        [SpecialEducationTeacherCode]                         NVARCHAR (50)  CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationTeacherCode] DEFAULT ('MISSING') NOT NULL,
        [SpecialEducationTeacherDescription]                  NVARCHAR (200) CONSTRAINT [DF_DimK12StaffStatuses_SpecialEducationTeacherDescription] DEFAULT ('MISSING') NOT NULL;



PRINT N'Creating Column Store Index [RDS].[DimK12StaffStatuses].[CSI_DimK12StaffStatuses]...';



CREATE COLUMNSTORE INDEX [CSI_DimK12StaffStatuses]
    ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtCode], [EdFactsCertificationStatusCode], [HighlyQualifiedTeacherIndicatorCode], [EdFactsTeacherInexperiencedStatusCode], [EdFactsTeacherOutOfFieldStatusCode], [SpecialEducationTeacherQualificationStatusCode], [ParaprofessionalQualificationStatusCode], [SpecialEducationRelatedServicesPersonnelCode], [CTEInstructorIndustryCertificationCode], [SpecialEducationParaprofessionalCode], [SpecialEducationTeacherCode]);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]
    ON [RDS].[DimK12StaffStatuses]([EdFactsCertificationStatusCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_Codes]
    ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtCode] ASC, [EdFactsCertificationStatusCode] ASC, [HighlyQualifiedTeacherIndicatorCode] ASC, [EdFactsTeacherInexperiencedStatusCode] ASC, [EdFactsTeacherOutOfFieldStatusCode] ASC, [SpecialEducationTeacherQualificationStatusCode] ASC, [ParaprofessionalQualificationStatusCode] ASC);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]
    ON [RDS].[DimK12StaffStatuses]([EdFactsTeacherInexperiencedStatusCode] ASC);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses]([EdFactsTeacherOutOfFieldStatusEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]
    ON [RDS].[DimK12StaffStatuses]([HighlyQualifiedTeacherIndicatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses]([ParaprofessionalQualificationStatusEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]
    ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]
    ON [RDS].[DimK12StaffStatuses]([SpecialEducationTeacherQualificationStatusEdFactsCode] ASC);



PRINT N'Altering Table [RDS].[DimLanguages]...';

ALTER TABLE [RDS].[DimLanguages] ALTER COLUMN [Iso6392LanguageCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimLanguages] ALTER COLUMN [Iso6392LanguageCodeDescription] NVARCHAR (200) NOT NULL;

ALTER TABLE [RDS].[DimLanguages] ALTER COLUMN [Iso6392LanguageCodeEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimLanguages] ALTER COLUMN [Iso6393LanguageCodeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimLanguages] ALTER COLUMN [Iso6393LanguageCodeDescription] NVARCHAR (200) NOT NULL;


DROP TABLE [RDS].[DimLeaFinancialAccountBalances];

CREATE TABLE [RDS].[DimLeaFinancialAccountBalances] (
    [DimLeaFinancialAccountBalanceId]                         INT            IDENTITY (1, 1) NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountBalances_FinancialAccountCodingSystemOrganizationTypeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeDescription] NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountBalances_FinancialAccountCodingSystemOrganizationTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalBalanceSheetCodeCode]               NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountBalances_FinancialAccountLocalBalanceSheetCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalBalanceSheetCodeSeaCode]            NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountBalances_FinancialAccountLocalBalanceSheetCodeSeaCod] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalBalanceSheetCodeDescription]        NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountBalances_FinancialAccountLocalBalanceSheetCodeDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [PK_DimLeaFinancialAccountBalances] PRIMARY KEY NONCLUSTERED ([DimLeaFinancialAccountBalanceId] ASC)
);

DROP TABLE [RDS].[DimLeaFinancialAccountClassifications];

CREATE TABLE [RDS].[DimLeaFinancialAccountClassifications] (
    [DimLeaFinancialAccountClassificationId]                  INT            IDENTITY (1, 1) NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountCodingSystemOrganizationTypeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeDescription] NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountCodingSystemOrganizationTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCategoryCode]                            NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountCategoryCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCategorySeaCode]                         NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountCategorySeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCategoryDescription]                     NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountCategoryDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalProgramCodeCode]                    NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalProgramCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalProgramCodeSeaCode]                 NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalProgramCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalProgramCodeDescription]             NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalProgramCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalFundClassificationCode]             NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalFundClassificationCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalFundClassificationSeaCode]          NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalFundClassificationSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalFundClassificationDescription]      NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialAccountClassifications_FinancialAccountLocalFundClassificationDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [PK_DimLeaFinancialAccountClassifications] PRIMARY KEY NONCLUSTERED ([DimLeaFinancialAccountClassificationId] ASC)
);

DROP TABLE [RDS].[DimLeaFinancialExpenditureClassifications];

CREATE TABLE [RDS].[DimLeaFinancialExpenditureClassifications] (
    [DimLeaFinancialExpenditureClassificationId]                 INT            IDENTITY (1, 1) NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeCode]           NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialAccountCodingSystemOrganizationTypeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeDescription]    NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialAccountCodingSystemOrganizationTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalFunctionCodeCode]                  NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalFunctionCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalFunctionCodeSeaCode]               NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalFunctionCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalFunctionCodeDescription]           NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalFunctionCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalObjectCodeCode]                    NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalObjectCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalObjectCodeSeaCode]                 NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalObjectCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalObjectCodeDescription]             NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalObjectCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalLevelOfInstructionCodeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalLevelOfInstructionCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalLevelOfInstructionCodeSeaCode]     NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalLevelOfInstructionCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureLocalLevelOfInstructionCodeDescription] NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureLocalLevelOfInstructionCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureProjectReportingCodeCode]               NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureProjectReportingCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureProjectReportingCodeSeaCode]            NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureProjectReportingCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialExpenditureProjectReportingCodeDescription]        NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialExpenditureClassifications_FinancialExpenditureProjectReportingCodeDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [PK_DimLeaFinancialExpenditureClassifications] PRIMARY KEY NONCLUSTERED ([DimLeaFinancialExpenditureClassificationId] ASC)
);

DROP TABLE [RDS].[DimLeaFinancialRevenueClassifications];

CREATE TABLE [RDS].[DimLeaFinancialRevenueClassifications] (
    [DimLeaFinancialRevenueClassificationId]                  INT            IDENTITY (1, 1) NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeCode]        NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountCodingSystemOrganizationTypeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountCodingSystemOrganizationTypeDescription] NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountCodingSystemOrganizationTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueCodeCode]                    NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueCodeSeaCode]                 NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueCodeDescription]             NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueObjectCodeCode]              NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueObjectCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueObjectCodeSeaCode]           NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueObjectCodeSeaCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountLocalRevenueObjectCodeDescription]       NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountLocalRevenueObjectCodeDescription] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountRevenueObjectCodeCode]                   NVARCHAR (50)  CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountRevenueObjectCodeCode] DEFAULT ('MISSING') NOT NULL,
    [FinancialAccountRevenueObjectCodeDescription]            NVARCHAR (150) CONSTRAINT [DF_DimLeaFinancialRevenueClassifications_FinancialAccountRevenueObjectCodeDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [PK_DimLeaFinancialRevenueClassifications] PRIMARY KEY NONCLUSTERED ([DimLeaFinancialRevenueClassificationId] ASC)
);

ALTER TABLE [RDS].[DimLeas] DROP CONSTRAINT [PK_DimLeas];

EXEC sp_rename 'RDS.DimLeas.DimLeaID', 'DimLeaId', 'COLUMN';
ALTER TABLE [RDS].[DimLeas] ALTER COLUMN [MailingAddressApartmentRoomOrSuiteNumber] NVARCHAR (40) NULL;
ALTER TABLE [RDS].[DimLeas] ALTER COLUMN [PhysicalAddressApartmentRoomOrSuiteNumber] NVARCHAR (40) NULL;
ALTER TABLE [RDS].[DimLeas] ADD MailingAddressCountyName NVARCHAR (30) NULL;
ALTER TABLE [RDS].[DimLeas] ADD PhysicalAddressCountyName NVARCHAR (30) NULL;

ALTER TABLE [RDS].[DimLeas] ADD PRIMARY KEY CLUSTERED (DimLeaId ASC);


PRINT N'Creating Index [RDS].[DimLeas].[IX_DimLeas_RecordStartDateTime]...';



CREATE NONCLUSTERED INDEX [IX_DimLeas_RecordStartDateTime]
    ON [RDS].[DimLeas]([RecordStartDateTime] ASC)
    INCLUDE([LeaIdentifierSea], [RecordEndDateTime]);



PRINT N'Creating Index [RDS].[DimLeas].[IX_DimLeas_LeaIdentifierSea_RecordStartDateTime]...';



CREATE NONCLUSTERED INDEX [IX_DimLeas_LeaIdentifierSea_RecordStartDateTime]
    ON [RDS].[DimLeas]([LeaIdentifierSea] ASC, [RecordStartDateTime] ASC);


PRINT N'Starting rebuilding table [RDS].[DimMilitaryStatuses]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [RDS].[tmp_ms_xx_DimMilitaryStatuses] (
    [DimMilitaryStatusId]                          INT            IDENTITY (1, 1) NOT NULL,
    [MilitaryConnectedStudentIndicatorCode]        NVARCHAR (50)  CONSTRAINT [DF_DimMilitaryStatuses_MilitaryConnectedStudentIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [MilitaryConnectedStudentIndicatorDescription] NVARCHAR (200) CONSTRAINT [DF_DimMilitaryStatuses_MilitaryConnectedStudentIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    [MilitaryConnectedStudentIndicatorEdFactsCode] NVARCHAR (50)  CONSTRAINT [DF_DimMilitaryStatuses_MilitaryConnectedStudentIndicatorEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [ActiveMilitaryStatusIndicatorCode]            NVARCHAR (50)  CONSTRAINT [DF_DimMilitaryStatuses_ActiveMilitaryStatusIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [ActiveMilitaryStatusIndicatorDescription]     NVARCHAR (200) CONSTRAINT [DF_DimMilitaryStatuses_ActiveMilitaryStatusIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    [MilitaryBranchCode]                           NVARCHAR (50)  CONSTRAINT [DF_DimMilitaryStatuses_MilitaryBranchCode] DEFAULT ('MISSING') NOT NULL,
    [MilitaryBranchDescription]                    NVARCHAR (200) CONSTRAINT [DF_DimMilitaryStatuses_MilitaryBranchDescription] DEFAULT ('MISSING') NOT NULL,
    [MilitaryVeteranStatusIndicatorCode]           NVARCHAR (50)  CONSTRAINT [DF_DimMilitaryStatuses_MilitaryVeteranStatusIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [MilitaryVeteranStatusIndicatorDescription]    NVARCHAR (200) CONSTRAINT [DF_DimMilitaryStatuses_MilitaryVeteranStatusIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_DimMilitaryStatuses1] PRIMARY KEY CLUSTERED ([DimMilitaryStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [RDS].[DimMilitaryStatuses])
    BEGIN
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimMilitaryStatuses] ON;
        INSERT INTO [RDS].[tmp_ms_xx_DimMilitaryStatuses] ([DimMilitaryStatusId], [MilitaryConnectedStudentIndicatorCode], [MilitaryConnectedStudentIndicatorDescription], [MilitaryConnectedStudentIndicatorEdFactsCode], [MilitaryBranchCode], [MilitaryBranchDescription])
        SELECT   [DimMilitaryStatusId],
                 [MilitaryConnectedStudentIndicatorCode],
                 [MilitaryConnectedStudentIndicatorDescription],
                 [MilitaryConnectedStudentIndicatorEdFactsCode],
                 [MilitaryBranchCode],
                 [MilitaryBranchDescription]
        FROM     [RDS].[DimMilitaryStatuses]
        ORDER BY [DimMilitaryStatusId] ASC;
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimMilitaryStatuses] OFF;
    END

DROP TABLE [RDS].[DimMilitaryStatuses];

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimMilitaryStatuses]', N'DimMilitaryStatuses';

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimMilitaryStatuses1]', N'PK_DimMilitaryStatuses', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;



PRINT N'Creating Index [RDS].[DimMilitaryStatuses].[IX_DimMilitaryStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimMilitaryStatuses_Codes]
    ON [RDS].[DimMilitaryStatuses]([MilitaryConnectedStudentIndicatorCode] ASC, [ActiveMilitaryStatusIndicatorCode] ASC, [MilitaryBranchCode] ASC, [MilitaryVeteranStatusIndicatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


PRINT N'Starting rebuilding table [RDS].[DimNOrDStatuses]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [RDS].[tmp_ms_xx_DimNOrDStatuses] (
    [DimNOrDStatusId]                                              INT            IDENTITY (1, 1) NOT NULL,
    [NeglectedOrDelinquentLongTermStatusCode]                      NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentLongTermStatusDescription]               NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentLongTermStatusEdFactsCode]               NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentProgramTypeCode]                         NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentProgramTypeDescription]                  NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentProgramTypeEdFactsCode]                  NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedProgramTypeCode]                                     NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedProgramTypeCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedProgramTypeDescription]                              NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedProgramTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedProgramTypeEdFactsCode]                              NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedProgramTypeEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [DelinquentProgramTypeCode]                                    NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_DelinquentProgramTypeCode] DEFAULT ('MISSING') NOT NULL,
    [DelinquentProgramTypeDescription]                             NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_DelinquentProgramTypeDescription] DEFAULT ('MISSING') NOT NULL,
    [DelinquentProgramTypeEdFactsCode]                             NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_DelinquentProgramTypeEdFactsCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentStatusCode]                              NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentStatusCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentStatusDescription]                       NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentStatusDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentProgramEnrollmentSubpartCode]            NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentProgramEnrollmentSubpartCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentProgramEnrollmentSubpartDescription]     NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentProgramEnrollmentSubpartDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentAcademicAchievementIndicatorCode]        NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentAcademicAchievementIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentAcademicAchievementIndicatorDescription] NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentAcademicAchievementIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentAcademicOutcomeIndicatorCode]            NVARCHAR (50)  CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentAcademicOutcomeIndicatorCode] DEFAULT ('MISSING') NOT NULL,
    [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription]     NVARCHAR (100) CONSTRAINT [DF_DimNOrDStatuses_NeglectedOrDelinquentAcademicOutcomeIndicatorDescription] DEFAULT ('MISSING') NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_DimNorDStatuses1] PRIMARY KEY NONCLUSTERED ([DimNOrDStatusId] ASC) WITH (FILLFACTOR = 80)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [RDS].[DimNOrDStatuses])
    BEGIN
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimNOrDStatuses] ON;
        INSERT INTO [RDS].[tmp_ms_xx_DimNOrDStatuses] ([DimNOrDStatusId], [NeglectedOrDelinquentStatusCode], [NeglectedOrDelinquentStatusDescription], [NeglectedOrDelinquentProgramTypeCode], [NeglectedOrDelinquentProgramTypeDescription], [NeglectedOrDelinquentProgramTypeEdFactsCode], [NeglectedOrDelinquentLongTermStatusCode], [NeglectedOrDelinquentLongTermStatusDescription], [NeglectedOrDelinquentLongTermStatusEdFactsCode], [NeglectedOrDelinquentProgramEnrollmentSubpartCode], [NeglectedOrDelinquentProgramEnrollmentSubpartDescription], [NeglectedProgramTypeCode], [NeglectedProgramTypeDescription], [NeglectedProgramTypeEdFactsCode], [DelinquentProgramTypeCode], [DelinquentProgramTypeDescription], [DelinquentProgramTypeEdFactsCode], [NeglectedOrDelinquentAcademicAchievementIndicatorCode], [NeglectedOrDelinquentAcademicAchievementIndicatorDescription], [NeglectedOrDelinquentAcademicOutcomeIndicatorCode], [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription])
        SELECT [DimNOrDStatusId],
               [NeglectedOrDelinquentStatusCode],
               [NeglectedOrDelinquentStatusDescription],
               [NeglectedOrDelinquentProgramTypeCode],
               [NeglectedOrDelinquentProgramTypeDescription],
               [NeglectedOrDelinquentProgramTypeEdFactsCode],
               [NeglectedOrDelinquentLongTermStatusCode],
               [NeglectedOrDelinquentLongTermStatusDescription],
               [NeglectedOrDelinquentLongTermStatusEdFactsCode],
               [NeglectedOrDelinquentProgramEnrollmentSubpartCode],
               [NeglectedOrDelinquentProgramEnrollmentSubpartDescription],
               [NeglectedProgramTypeCode],
               [NeglectedProgramTypeDescription],
               [NeglectedProgramTypeEdFactsCode],
               [DelinquentProgramTypeCode],
               [DelinquentProgramTypeDescription],
               [DelinquentProgramTypeEdFactsCode],
               [NeglectedOrDelinquentAcademicAchievementIndicatorCode],
               [NeglectedOrDelinquentAcademicAchievementIndicatorDescription],
               [NeglectedOrDelinquentAcademicOutcomeIndicatorCode],
               [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription]
        FROM   [RDS].[DimNOrDStatuses];
        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimNOrDStatuses] OFF;
    END

DROP TABLE [RDS].[DimNOrDStatuses];

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimNOrDStatuses]', N'DimNOrDStatuses';

EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimNorDStatuses1]', N'PK_DimNorDStatuses', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;



PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusEdFactsCodes]...';



CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusEdFactsCodes]
    ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentLongTermStatusEdFactsCode] ASC, [NeglectedOrDelinquentProgramTypeEdFactsCode] ASC, [NeglectedProgramTypeEdFactsCode] ASC, [DelinquentProgramTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);



PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]
    ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentProgramTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);



PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_NeglectedProgramTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_NeglectedProgramTypeEdFactsCode]
    ON [RDS].[DimNOrDStatuses]([NeglectedProgramTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);



PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_DelinquentProgramTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_DelinquentProgramTypeEdFactsCode]
    ON [RDS].[DimNOrDStatuses]([DelinquentProgramTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);



PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_Codes]
    ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentLongTermStatusCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC, [NeglectedProgramTypeCode] ASC, [DelinquentProgramTypeCode] ASC) WITH (FILLFACTOR = 80);


PRINT N'Altering Table [RDS].[DimOnetSocOccupationTypes]...';



ALTER TABLE [RDS].[DimOnetSocOccupationTypes] ALTER COLUMN [OnetSocOccupationTypeCode] NVARCHAR (10) NOT NULL;

ALTER TABLE [RDS].[DimOnetSocOccupationTypes] ALTER COLUMN [OnetSocOccupationTypeDescription] NVARCHAR (4000) NOT NULL;



PRINT N'Altering Table [RDS].[DimOrganizationCalendarSessions]...';



ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [AcademicTermDesignatorCode] NVARCHAR (30) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [AcademicTermDesignatorDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [SessionBeginDate] DATETIME NOT NULL;

ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [SessionCode] NVARCHAR (30) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [SessionDescription] NVARCHAR (MAX) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationCalendarSessions] ALTER COLUMN [SessionEndDate] DATETIME NOT NULL;



PRINT N'Altering Table [RDS].[DimOrganizationTitleIStatuses]...';



ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIInstructionalServicesCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIInstructionalServicesDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIInstructionalServicesEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIProgramTypeCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIProgramTypeDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleIProgramTypeEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISchoolStatusCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISchoolStatusDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISchoolStatusEdFactsCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISupportServicesCode] NVARCHAR (50) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISupportServicesDescription] NVARCHAR (100) NOT NULL;

ALTER TABLE [RDS].[DimOrganizationTitleIStatuses] ALTER COLUMN [TitleISupportServicesEdFactsCode] NVARCHAR (50) NOT NULL;



PRINT N'Creating Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_Codes]...';



CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_Codes]
    ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusCode] ASC, [TitleIInstructionalServicesCode] ASC, [TitleISupportServicesCode] ASC, [TitleIProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleIInstructionalServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses]([TitleIInstructionalServicesEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleIProgramTypeEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses]([TitleIProgramTypeEdFactsCode] ASC);



PRINT N'Creating Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleISchoolStatusEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses]([TitleISchoolStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);



PRINT N'Creating Index [RDS].[DimOrganizationTitleIStatuses].[IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode]...';



CREATE NONCLUSTERED INDEX [IX_DimOrganizationTitleIStatuses_TitleISupportServicesEdFactsCode]
    ON [RDS].[DimOrganizationTitleIStatuses]([TitleISupportServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

