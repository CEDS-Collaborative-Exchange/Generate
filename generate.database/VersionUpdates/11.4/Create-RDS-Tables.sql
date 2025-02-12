--ReportEdFactsOrganizationCounts
	IF COL_LENGTH('rds.ReportEdFactsOrganizationCounts', 'CharterSchoolAuthorizerType') IS NULL
	BEGIN
		ALTER TABLE rds.ReportEdFactsOrganizationCounts ADD CharterSchoolAuthorizerType nvarchar(100);
	END


CREATE TABLE [RDS].[DimAccessibleEducationMaterialProviders]
(
	[DimAccessibleEducationMaterialProviderId] int NOT NULL IDENTITY (1, 1),
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
	[RecordStartDateTime] date NOT NULL,
	[RecordEndDateTime] date NULL,
	CONSTRAINT [PK_DimAccessibleEducaitonMaterialProviders]	PRIMARY KEY CLUSTERED ([DimAccessibleEducationMaterialProviderId] ASC),
)

CREATE TABLE [RDS].[DimAccessibleEducationMaterialStatuses]
(
	[DimAccessibleEducationMaterialStatusId] int NOT NULL IDENTITY (1, 1),
	[AccessibleFormatIssuedIndicatorCode] nvarchar(50) NOT NULL DEFAULT 'MISSING',
	[AccessibleFormatIssuedIndicatorDescription] nvarchar(200) NOT NULL DEFAULT 'MISSING',
	[AccessibleFormatRequiredIndicatorCode] nvarchar(50) NOT NULL DEFAULT 'MISSING',
	[AccessibleFormatRequiredIndicatorDescription] nvarchar(200) NOT NULL DEFAULT 'MISSING',
	[AccessibleFormatTypeCode] nvarchar(50) NOT NULL DEFAULT 'MISSING',
	[AccessibleFormatTypeDescription] nvarchar(200) NOT NULL DEFAULT 'MISSING',
	CONSTRAINT [PK_DimAccessibleEducationMaterialStatuses]	PRIMARY KEY CLUSTERED ([DimAccessibleEducationMaterialStatusId] ASC)
)


CREATE TABLE [RDS].[DimRuralStatuses]
(
  [DimRuralStatusId]                            INT IDENTITY (1, 1) NOT NULL,
  [ERSRuralUrbanContinuumCodeCode]              NVARCHAR (50)  CONSTRAINT [DF_DimRuralStatuses_ERSRuralUrbanContinuumCodeCode] DEFAULT ('MISSING') NOT NULL,
  [ERSRuralUrbanContinuumCodeDescription]       NVARCHAR (200) CONSTRAINT [DF_DimRuralStatuses_ERSRuralUrbanContinuumCodeDescription] DEFAULT ('MISSING') NOT NULL,
  [RuralResidencyStatusCode]                    NVARCHAR (50)  CONSTRAINT [DF_DimRuralStatuses_RuralResidencyStatusCodeCode] DEFAULT ('MISSING') NOT NULL,
  [RuralResidencyStatusDescription]             NVARCHAR (200) CONSTRAINT [DF_DimRuralStatuses_RuralResidencyStatusCodeDescription] DEFAULT ('MISSING') NOT NULL,
  CONSTRAINT [PK_DimRuralStatuses] PRIMARY KEY CLUSTERED ([DimRuralStatusId] ASC)
)



CREATE TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments]
(
	[FactK12AccessibleEducationMaterialAssignmentId] int NOT NULL IDENTITY (1, 1),
	[SchoolYearId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SchoolYearId] DEFAULT ((-1)) NOT NULL,
	[CountDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CountDateId] DEFAULT ((-1)) NOT NULL,
	[K12StudentId] bigint CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12StudentId] DEFAULT ((-1)) NOT NULL,
	[SeaId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SeaId] DEFAULT ((-1)) NOT NULL,
	[IeuId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_IeuId] DEFAULT ((-1)) NOT NULL,
	[LeaId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LeaId] DEFAULT ((-1)) NOT NULL,
	[K12SchoolId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12SchoolId] DEFAULT ((-1)) NOT NULL,
	[AccessibleEducationMaterialProviderId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialProviderId] DEFAULT ((-1)) NOT NULL,
	[AccessibleEducationMaterialStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AccessibleEducationMaterialStatusId] DEFAULT ((-1)) NOT NULL,
	[DataCollectionId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_DataCollectionId] DEFAULT ((-1)) NOT NULL,
	[AgeId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AgeId] DEFAULT ((-1)) NOT NULL,
	[DisabilityStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_DisabilityStatusId] DEFAULT ((-1)) NOT NULL,
	[EconomicallyDisadvantagedStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
	[EnglishLearnerStatusId] int  CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
	[EntryGradeLevelId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EntryGradeLevelId] DEFAULT ((-1)) NOT NULL,
	[FosterCareStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
	[HomelessnessStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
	[IdeaStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
	[ImmigrantStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
	[K12CourseId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12CourseId] DEFAULT ((-1)) NOT NULL,
	[K12DemographicId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12DemographicId] DEFAULT ((-1)) NOT NULL,
	[K12EnrollmentStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_K12EnrollmentStatusId] DEFAULT ((-1)) NOT NULL,
	[MigrantStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_MigrantStatusId] DEFAULT ((-1)) NOT NULL,
	[MilitaryStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_MilitaryStatusId] DEFAULT ((-1)) NOT NULL,
	[RaceId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_RaceId] DEFAULT ((-1)) NOT NULL,
	[RuralStatusId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_RuralStatusId] DEFAULT ((-1)) NOT NULL,
	[PrimaryIdeaDisabilityTypeId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_PrimaryIdeaDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
	[SecondaryIdeaDisabilityTypeId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_SecondaryIdeaDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
	[ScedCodeId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_ScedCodeId] DEFAULT ((-1)) NOT NULL,
	[EnrollmentEntryDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentEntryDateId] DEFAULT ((-1)) NOT NULL,
	[EnrollmentExitDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_EnrollmentExitDateId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateEconomicallyDisadvantagedId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEconomicallyDisadvantagedId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateEconomicallyDisadvantagedId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEconomicallyDisadvantagedId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateEnglishLearnerId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateEnglishLearnerId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateHomelessnessId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateHomelessnessId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateHomelessnessId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateHomelessnessId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateIdeaId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateIdeaId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateIdeaId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateIdeaId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateMigrantId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMigrantId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateMigrantId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMigrantId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDateMilitaryId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDateMilitaryId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDateMilitaryId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDateMilitaryId] DEFAULT ((-1)) NOT NULL,
	[StatusStartDatePerkinsEnglishLearnerId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusStartDatePerkinsEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
	[StatusEndDatePerkinsEnglishLearnerId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_StatusEndDatePerkinsEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
	[LearningResourceIssuedDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceIssuedDateId] DEFAULT ((-1)) NOT NULL,
	[LearningResourceOrderedDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceOrderedDateId] DEFAULT ((-1)) NOT NULL,
	[LearningResourceReceivedDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_LearningResourceReceivedDateId] DEFAULT ((-1)) NOT NULL,
	[CourseSectionStartDateId] int  CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CourSectionStartDateId] DEFAULT (-1) NOT NULL,
	[CourseSectionEndDateId] int CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_CourSectionEndDateId] DEFAULT ((-1)) NOT NULL,
	[AssignmentCount] INT CONSTRAINT [DF_FactK12AccessibleEducationMaterialAssignment_AssignmentCount] DEFAULT ((1)) NOT NULL,
	CONSTRAINT [PK_FactK12AccessibleEducationMaterialAssignments] PRIMARY KEY CLUSTERED ([FactK12AccessibleEducationMaterialAssignmentId] ASC),
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialStatusId] FOREIGN KEY ([AccessibleEducationMaterialStatusId]) REFERENCES [RDS].[DimAccessibleEducationMaterialStatuses] ([DimAccessibleEducationMaterialStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialProviderId]	FOREIGN KEY ([AccessibleEducationMaterialProviderId]) REFERENCES [RDS].[DimAccessibleEducationMaterialProviders] ([DimAccessibleEducationMaterialProviderId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CountDateId] FOREIGN KEY ([CountDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId] FOREIGN KEY ([CourseSectionEndDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId] FOREIGN KEY ([CourseSectionStartDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AgeId] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DisabilityStatusId] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [RDS].[DimDisabilityStatuses] ([DimDisabilityStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EconomicallyDisadvantagedStatusId] FOREIGN KEY ([EconomicallyDisadvantagedStatusId]) REFERENCES [RDS].[DimEconomicallyDisadvantagedStatuses] ([DimEconomicallyDisadvantagedStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnglishLearnerStatusId] FOREIGN KEY ([EnglishLearnerStatusId]) REFERENCES [RDS].[DimEnglishLearnerStatuses] ([DimEnglishLearnerStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EntryGradeLevelId] FOREIGN KEY ([EntryGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_FosterCareStatusId] FOREIGN KEY ([FosterCareStatusId]) REFERENCES [RDS].[DimFosterCareStatuses] ([DimFosterCareStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_HomelessnessStatusId] FOREIGN KEY ([HomelessnessStatusId]) REFERENCES [RDS].[DimHomelessnessStatuses] ([DimHomelessnessStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ImmigrantStatusId] FOREIGN KEY ([ImmigrantStatusId]) REFERENCES [RDS].[DimImmigrantStatuses] ([DimImmigrantStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12CourseId] FOREIGN KEY ([K12CourseId]) REFERENCES [RDS].[DimK12Courses] ([DimK12CourseId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12EnrollmentStatusId] FOREIGN KEY ([K12EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId] FOREIGN KEY ([LearningResourceIssuedDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId] FOREIGN KEY ([LearningResourceOrderedDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId] FOREIGN KEY ([LearningResourceReceivedDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MigrantStatusId] FOREIGN KEY ([MigrantStatusId]) REFERENCES [RDS].[DimMigrantStatuses] ([DimMigrantStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MilitaryStatusId] FOREIGN KEY ([MilitaryStatusId]) REFERENCES [RDS].[DimMilitaryStatuses] ([DimMilitaryStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RuralStatusId] FOREIGN KEY ([RuralStatusId]) REFERENCES [RDS].[DimRuralStatuses] ([DimRuralStatusId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId] FOREIGN KEY ([PrimaryIdeaDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ScedCodeId] FOREIGN KEY ([ScedCodeId]) REFERENCES [RDS].[DimScedCodes] ([DimScedCodeId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId] FOREIGN KEY ([SecondaryIdeaDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId] FOREIGN KEY ([StatusEndDateEconomicallyDisadvantagedId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId] FOREIGN KEY ([StatusEndDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId] FOREIGN KEY ([StatusEndDateHomelessnessId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId] FOREIGN KEY ([StatusEndDateIdeaId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId] FOREIGN KEY ([StatusEndDateMigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId] FOREIGN KEY ([StatusEndDateMilitaryId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId] FOREIGN KEY ([StatusEndDatePerkinsEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId] FOREIGN KEY ([StatusStartDateEconomicallyDisadvantagedId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId] FOREIGN KEY ([StatusStartDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId] FOREIGN KEY ([StatusStartDateHomelessnessId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId] FOREIGN KEY ([StatusStartDateIdeaId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId] FOREIGN KEY ([StatusStartDateMigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId] FOREIGN KEY ([StatusStartDateMilitaryId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId] FOREIGN KEY ([StatusStartDatePerkinsEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]) ON DELETE No Action ON UPDATE No Action)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimAccessibleEducationMaterialProviders] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([AccessibleEducationMaterialProviderId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimAccessibleEducationMaterials] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([AccessibleEducationMaterialStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimDataCollections] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([DataCollectionId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_CountDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([CountDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([EnrollmentEntryDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([EnrollmentExitDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateEconomicallyDisadvantagedId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateEconomicallyDisadvantagedId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateEnglishLearnerId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateEnglishLearnerId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateHomelessnessId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateHomelessnessId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateIdeaId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateIdeaId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateMigrantId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateMigrantId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDateMilitaryId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDateMilitaryId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusStartDatePerkinsEnglishLearnerId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([StatusEndDatePerkinsEnglishLearnerId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([LearningResourceIssuedDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([LearningResourceOrderedDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([LearningResourceReceivedDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([CourseSectionStartDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([CourseSectionEndDateId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimDisabilityStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([DisabilityStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimEconomicallyDisadvantagedStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([EconomicallyDisadvantagedStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimEnglishLearnerStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([EnglishLearnerStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimFosterCareStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([FosterCareStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimGradeLevels] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([EntryGradeLevelId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimHomelessnessStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([HomelessnessStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([PrimaryIdeaDisabilityTypeId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([SecondaryIdeaDisabilityTypeId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimIdeaStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([IdeaStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimRaces] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([RaceId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimRuralStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([RuralStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimIeus] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([IeuId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimImmigrantStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([ImmigrantStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimK12Courses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([K12CourseId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimK12Demographics] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([K12DemographicId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimK12EnrollmentStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([K12EnrollmentStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimK12Schools] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([K12SchoolId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimLeas] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([LeaId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimMigrantStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([MigrantStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimMilitaryStatuses] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([MilitaryStatusId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimPeople] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([K12StudentId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimScedCodes] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([ScedCodeId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimSchoolYears] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([SchoolYearId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_FactK12AccessibleEducationMaterialAssignments_DimSeas] 
 ON [RDS].[FactK12AccessibleEducationMaterialAssignments] ([SeaId] ASC)



CREATE TABLE [RDS].[BridgeK12AccessibleEducationMaterialRaces]
(
	[BridgeK12AccessibleEducationMaterialRaceId] int NOT NULL IDENTITY (1, 1),
	[FactK12AccessibleEducationMaterialAssignmentId] int NULL,
	[RaceId] int NULL,
	CONSTRAINT [PK_BridgeK12AccessibleEducationMaterialRaces] PRIMARY KEY CLUSTERED ([BridgeK12AccessibleEducationMaterialRaceId] ASC),
	CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments] FOREIGN KEY ([FactK12AccessibleEducationMaterialAssignmentId]) REFERENCES [RDS].[FactK12AccessibleEducationMaterialAssignments] ([FactK12AccessibleEducationMaterialAssignmentId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]) ON DELETE No Action ON UPDATE No Action
)



CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AccessibleEducationMaterialRaces_DimRaces] 
 ON [RDS].[BridgeK12AccessibleEducationMaterialRaces] ([RaceId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments] 
 ON [RDS].[BridgeK12AccessibleEducationMaterialRaces] ([FactK12AccessibleEducationMaterialAssignmentId] ASC)


CREATE TABLE [RDS].[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes]
(
	[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypeId] int NOT NULL IDENTITY (1, 1),
	[FactK12AccessibleEducationMaterialAssignmentId] int NULL,
	[IdeaDisabilityTypeId] int NULL,
	CONSTRAINT [PK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes] PRIMARY KEY CLUSTERED ([BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypeId] ASC),
	CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments] FOREIGN KEY ([FactK12AccessibleEducationMaterialAssignmentId]) REFERENCES [RDS].[FactK12AccessibleEducationMaterialAssignments] ([FactK12AccessibleEducationMaterialAssignmentId]) ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_IdeaDisabilityTypeId] FOREIGN KEY ([IdeaDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]) ON DELETE No Action ON UPDATE No Action
);


CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_DimIdeaDisabilityTypes] 
 ON [RDS].[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes] ([IdeaDisabilityTypeId] ASC)


CREATE NONCLUSTERED INDEX [IXFK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments] 
 ON [RDS].[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes] ([FactK12AccessibleEducationMaterialAssignmentId] ASC)


ALTER TABLE RDS.DimScedCodes alter column [ScedCourseTitle] NVARCHAR (100) NOT NULL

