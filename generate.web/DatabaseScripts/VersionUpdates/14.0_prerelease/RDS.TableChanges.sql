IF OBJECT_ID(N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards]', N'CredentialAwardRelationshipCode') IS NOT NULL
	   AND COL_LENGTH(N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards]', N'CredentialAwardRelationshipTypeCode') IS NULL
	BEGIN
		EXEC sp_rename
			N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards].[CredentialAwardRelationshipCode]',
			N'CredentialAwardRelationshipTypeCode',
			N'COLUMN';
	END;

	IF COL_LENGTH(N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards]', N'CredentialAwardRelationshipDescription') IS NOT NULL
	   AND COL_LENGTH(N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards]', N'CredentialAwardRelationshipTypeDescription') IS NULL
	BEGIN
		EXEC sp_rename
			N'[RDS].[BridgeCredentialAwardRelatedCredentialAwards].[CredentialAwardRelationshipDescription]',
			N'CredentialAwardRelationshipTypeDescription',
			N'COLUMN';
	END;
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactDirectory_EarlyChildhoodOrganizationStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactDirectory'
)
BEGIN
    ALTER TABLE [RDS].[FactDirectory] DROP CONSTRAINT [FK_FactDirectory_EarlyChildhoodOrganizationStatusId]
END;


IF OBJECT_ID(N'[RDS].[BridgeK12StudentAssessmentAccommodations]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[BridgeK12StudentAssessmentAccommodations];
END;

IF OBJECT_ID(N'[RDS].[BridgeK12StudentDisciplineDiscplineReasons]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons];
END;

IF OBJECT_ID(N'[RDS].[DimAeProgramYears]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimAeProgramYears];
END;

IF OBJECT_ID(N'[RDS].[DimAeStudentStatuses]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimAeStudentStatuses];
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentAccommodations]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimAssessmentAccommodations];
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentResults]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimAssessmentResults];
END;

IF OBJECT_ID(N'[RDS].[DimEarlyChildhoolOrganizationStatuses]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimEarlyChildhoolOrganizationStatuses];
END;

IF OBJECT_ID(N'[RDS].[DimEarlyChildhoodOrganizationStatuses]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[DimEarlyChildhoodOrganizationStatuses];
END;

CREATE TABLE [RDS].[DimEarlyChildhoodOrganizationStatuses] (
    [DimEarlyChildhoodOrganizationStatusId]              INT            IDENTITY (1, 1) NOT NULL,
    [EarlyChildhoodProgramEnrollmentTypeCode]            NVARCHAR (50)  NOT NULL,
    [EarlyChildhoodProgramEnrollmentTypeDescription]     NVARCHAR (300) NOT NULL,
    [EarlyLearningOtherFederalFundingSourcesCode]        NVARCHAR (50)  NOT NULL,
    [EarlyLearningOtherFederalFundingSourcesDescription] NVARCHAR (300) NOT NULL,
    CONSTRAINT [PK_DimEarlyChildhoodOrganizationStatuses] PRIMARY KEY CLUSTERED ([DimEarlyChildhoodOrganizationStatusId] ASC)
);

EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The system outlining activities and procedures based on a set of required services and standards in which the child is enrolled.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Early Childhood Program Enrollment Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000829', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/000829', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeCode';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The system outlining activities and procedures based on a set of required services and standards in which the child is enrolled.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Early Childhood Program Enrollment Type', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'000829', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/000829', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeDescription';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyChildhoodProgramEnrollmentTypeDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The other contributing funding sources.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Early Learning Other Federal Funding Sources', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001335', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001335', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesCode';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesCode';
EXECUTE sp_addextendedproperty @name = N'CEDS_Def_Desc', @value = N'The other contributing funding sources.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_Element', @value = N'Early Learning Other Federal Funding Sources', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_GlobalId', @value = N'001335', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesDescription';
EXECUTE sp_addextendedproperty @name = N'CEDS_URL', @value = N'https://ceds.ed.gov/element/001335', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesDescription';
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimEarlyChildhoodOrganizationStatuses', @level2type = N'COLUMN', @level2name = N'EarlyLearningOtherFederalFundingSourcesDescription';

IF OBJECT_ID(N'[RDS].[DimK12Schools]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimK12Schools]', N'SchoolIdentifierSat') IS NULL
BEGIN
	ALTER TABLE [RDS].[DimK12Schools]
	ADD [SchoolIdentifierSat] NVARCHAR (50) NULL;
END;

IF OBJECT_ID(N'[RDS].[DimK12StaffCategories]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[DimK12StaffCategories]', N'TitleIIILanguageInstructionIndicatorCode') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimK12StaffCategories]
		DROP COLUMN [TitleIIILanguageInstructionIndicatorCode];
	END;

	IF COL_LENGTH(N'[RDS].[DimK12StaffCategories]', N'TitleIIILanguageInstructionIndicatorDescription') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimK12StaffCategories]
		DROP COLUMN [TitleIIILanguageInstructionIndicatorDescription];
	END;
END;

IF OBJECT_ID(N'[RDS].[DimLeas]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[DimLeas]', N'NameOfInstitution') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimLeas]
		DROP COLUMN [NameOfInstitution];
	END;
END;

IF OBJECT_ID(N'[RDS].[DimPeople]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimPeople]', N'BirthDate') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimPeople]', N'Birthdate') IS NULL
BEGIN
	EXEC sp_rename
		N'[RDS].[DimPeople].[BirthDate]',
		N'Birthdate',
		N'COLUMN';
END;

IF OBJECT_ID(N'[RDS].[DimPsEnrollmentStatuses]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[DimPsEnrollmentStatuses]', N'PostSecondaryEnrollmentActionCode') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimPsEnrollmentStatuses]
		DROP COLUMN [PostSecondaryEnrollmentActionCode];
	END;

	IF COL_LENGTH(N'[RDS].[DimPsEnrollmentStatuses]', N'PostSecondaryEnrollmentActionDescription') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimPsEnrollmentStatuses]
		DROP COLUMN [PostSecondaryEnrollmentActionDescription];
	END;

	IF COL_LENGTH(N'[RDS].[DimPsEnrollmentStatuses]', N'PostSecondaryEnrollmentActionEdFactsCode') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[DimPsEnrollmentStatuses]
		DROP COLUMN [PostSecondaryEnrollmentActionEdFactsCode];
	END;
END;

IF OBJECT_ID(N'[RDS].[FactDirectory]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactDirectory]', N'ComprehensiveAndTargetedSupportI') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactDirectory]', N'ComprehensiveAndTargetedSupportId') IS NULL
BEGIN
	EXEC sp_rename
		N'[RDS].[FactDirectory].[ComprehensiveAndTargetedSupportI]',
		N'ComprehensiveAndTargetedSupportId',
		N'COLUMN';
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactDirectory_ComprehensiveAndTargetedSupportId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactDirectory'
)
BEGIN
	ALTER TABLE [RDS].[FactDirectory]
	DROP CONSTRAINT [FK_FactDirectory_ComprehensiveAndTargetedSupportId];
END;

IF OBJECT_ID(N'[RDS].[FactDirectory]', N'U') IS NOT NULL
   AND OBJECT_ID(N'[RDS].[DimComprehensiveAndTargetedSupports]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactDirectory]', N'ComprehensiveAndTargetedSupportId') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimComprehensiveAndTargetedSupports]', N'DimComprehensiveAndTargetedSupportId') IS NOT NULL
BEGIN
	ALTER TABLE [RDS].[FactDirectory] WITH CHECK
	ADD CONSTRAINT [FK_FactDirectory_ComprehensiveAndTargetedSupportId]
	FOREIGN KEY ([ComprehensiveAndTargetedSupportId]) REFERENCES [RDS].[DimComprehensiveAndTargetedSupports] ([DimComprehensiveAndTargetedSupportId]);
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactDirectory_EarlyChildhoodOrganizationStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactDirectory'
)
BEGIN
	ALTER TABLE [RDS].[FactDirectory]
	DROP CONSTRAINT [FK_FactDirectory_EarlyChildhoodOrganizationStatusId];
END;

IF OBJECT_ID(N'[RDS].[FactDirectory]', N'U') IS NOT NULL
   AND OBJECT_ID(N'[RDS].[DimEarlyChildhoodOrganizationStatuses]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactDirectory]', N'EarlyChildhoodOrganizationStatusId') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimEarlyChildhoodOrganizationStatuses]', N'DimEarlyChildhoodOrganizationStatusId') IS NOT NULL
BEGIN
	ALTER TABLE [RDS].[FactDirectory] WITH CHECK
	ADD CONSTRAINT [FK_FactDirectory_EarlyChildhoodOrganizationStatusId]
	FOREIGN KEY ([EarlyChildhoodOrganizationStatusId]) REFERENCES [RDS].[DimEarlyChildhoodOrganizationStatuses] ([DimEarlyChildhoodOrganizationStatusId]);
END;

IF OBJECT_ID(N'[RDS].[FactFinancialAccountBalances]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[FactFinancialAccountBalances];
END;

IF OBJECT_ID(N'[RDS].[FactFinancialAccountBudgets]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[FactFinancialAccountBudgets];
END;

IF OBJECT_ID(N'[RDS].[FactFinancialAccountGeneralLedgers]', N'U') IS NOT NULL
BEGIN
	DROP TABLE [RDS].[FactFinancialAccountGeneralLedgers];
END;

IF OBJECT_ID(N'[RDS].[FactK12AcademicCalendarEvents]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactK12AcademicCalendarEvents]', N'CalendarEventDayId') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_FactK12AcademicCalendarEvents_CalendarEventDayId'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[FactK12AcademicCalendarEvents]')
	)
BEGIN
	ALTER TABLE [RDS].[FactK12AcademicCalendarEvents]
	ADD CONSTRAINT [DF_FactK12AcademicCalendarEvents_CalendarEventDayId] DEFAULT ((-1)) FOR [CalendarEventDayId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactK12AcademicCalendarEvents_CalendarEventDayId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactK12AcademicCalendarEvents'
)
BEGIN
	ALTER TABLE [RDS].[FactK12AcademicCalendarEvents]
	DROP CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarEventDayId];
END;

IF OBJECT_ID(N'[RDS].[FactK12AcademicCalendarEvents]', N'U') IS NOT NULL
   AND OBJECT_ID(N'[RDS].[DimCalendarEventDays]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactK12AcademicCalendarEvents]', N'CalendarEventDayId') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimCalendarEventDays]', N'DimCalendarEventDayId') IS NOT NULL
BEGIN
	ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK
	ADD CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarEventDayId]
	FOREIGN KEY ([CalendarEventDayId]) REFERENCES [RDS].[DimCalendarEventDays] ([DimCalendarEventDayId]);
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactK12GraduationCohorts_CohortStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactK12GraduationCohorts'
)
BEGIN
	ALTER TABLE [RDS].[FactK12GraduationCohorts]
	DROP CONSTRAINT [FK_FactK12GraduationCohorts_CohortStatusId];
END;

IF OBJECT_ID(N'[RDS].[FactK12GraduationCohorts]', N'U') IS NOT NULL
   AND OBJECT_ID(N'[RDS].[DimCohortStatuses]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactK12GraduationCohorts]', N'CohortStatusId') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimCohortStatuses]', N'DimCohortStatusId') IS NOT NULL
BEGIN
	ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK
	ADD CONSTRAINT [FK_FactK12GraduationCohorts_CohortStatusId]
	FOREIGN KEY ([CohortStatusId]) REFERENCES [RDS].[DimCohortStatuses] ([DimCohortStatusId]);
END;

IF OBJECT_ID(N'[RDS].[FactK12StaffEvaluationParts]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactK12StaffEvaluationParts]', N'RecordStartDateTime') IS NULL
BEGIN
	ALTER TABLE [RDS].[FactK12StaffEvaluationParts]
	ADD [RecordStartDateTime] NVARCHAR (50) NULL;
END;

IF OBJECT_ID(N'[RDS].[FactK12StaffEvaluationParts]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[FactK12StaffEvaluationParts]', N'RecordEndDateTime') IS NULL
BEGIN
	ALTER TABLE [RDS].[FactK12StaffEvaluationParts]
	ADD [RecordEndDateTime] NVARCHAR (50) NULL;
END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactK12StudentCounts_CteOutcomeIndicatorId'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactK12StudentCounts]')
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentCounts]
	DROP CONSTRAINT [DF_FactK12StudentCounts_CteOutcomeIndicatorId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_CteOutcomeIndicatorId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactK12StudentCounts'
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentCounts]
	DROP CONSTRAINT [FK_FactK12StudentCounts_CteOutcomeIndicatorId];
END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactK12StudentCounts_PsEnrollmentStatusId'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactK12StudentCounts]')
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentCounts]
	DROP CONSTRAINT [DF_FactK12StudentCounts_PsEnrollmentStatusId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactK12StudentCounts_PSEnrollmentStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactK12StudentCounts'
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentCounts]
	DROP CONSTRAINT [FK_FactK12StudentCounts_PSEnrollmentStatusId];
END;

IF OBJECT_ID(N'[RDS].[FactK12StudentCounts]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[FactK12StudentCounts]', N'PsEnrollmentStatusId') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentCounts]
		DROP COLUMN [PsEnrollmentStatusId];
	END;

	IF COL_LENGTH(N'[RDS].[FactK12StudentCounts]', N'CteOutcomeIndicatorId') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentCounts]
		DROP COLUMN [CteOutcomeIndicatorId];
	END;

END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactK12StudentEnrollments_PsEnrollmentStatusId'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactK12StudentEnrollments]')
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentEnrollments]
	DROP CONSTRAINT [DF_FactK12StudentEnrollments_PsEnrollmentStatusId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactK12StudentEnrollments_PSEnrollmentStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactK12StudentEnrollments'
)
BEGIN
	ALTER TABLE [RDS].[FactK12StudentEnrollments]
	DROP CONSTRAINT [FK_FactK12StudentEnrollments_PSEnrollmentStatusId];
END;

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IXFX_FactK12StudentEnrollments_PsEnrollmentStatusId'
      AND object_id = OBJECT_ID(N'[RDS].[FactK12StudentEnrollments]')
)
BEGIN
    DROP INDEX [IXFX_FactK12StudentEnrollments_PsEnrollmentStatusId] ON [RDS].[FactK12StudentEnrollments];
END;

IF OBJECT_ID(N'[RDS].[FactK12StudentEnrollments]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[FactK12StudentEnrollments]', N'PsEnrollmentStatusId') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentEnrollments]
		DROP COLUMN [PsEnrollmentStatusId];
	END;

END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactPsStudentAcademicRecords]')
)
BEGIN
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords]
	DROP CONSTRAINT [DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactPsStudentAcademicRecords_PSEnrollmentStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactPsStudentAcademicRecords'
)
BEGIN
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords]
	DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_PSEnrollmentStatusId];
END;

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IXFK_FactPsStudentAcademicRecords_PsEnrollmentStatusId'
      AND object_id = OBJECT_ID(N'[RDS].[FactPsStudentAcademicRecords]')
)
BEGIN
    DROP INDEX [IXFK_FactPsStudentAcademicRecords_PsEnrollmentStatusId] ON [RDS].[FactPsStudentAcademicRecords];
END;

IF OBJECT_ID(N'[RDS].[FactPsStudentAcademicRecords]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[FactPsStudentAcademicRecords]', N'PsEnrollmentStatusId') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactPsStudentAcademicRecords]
		DROP COLUMN [PsEnrollmentStatusId];
	END;

END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactPsStudentEnrollments_PsEnrollmentStatusId'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactPsStudentEnrollments]')
)
BEGIN
	ALTER TABLE [RDS].[FactPsStudentEnrollments]
	DROP CONSTRAINT [DF_FactPsStudentEnrollments_PsEnrollmentStatusId];
END;

IF EXISTS (
	SELECT 1
	FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE CONSTRAINT_NAME = N'FK_FactPsStudentEnrollments_PSEnrollmentStatusId'
	  AND TABLE_SCHEMA = N'RDS'
	  AND TABLE_NAME = N'FactPsStudentEnrollments'
)
BEGIN
	ALTER TABLE [RDS].[FactPsStudentEnrollments]
	DROP CONSTRAINT [FK_FactPsStudentEnrollments_PSEnrollmentStatusId];
END;

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IXFK_FactPsStudentEnrollments_PsEnrollmentStatusId'
      AND object_id = OBJECT_ID(N'[RDS].[FactPsStudentEnrollments]')
)
BEGIN
    DROP INDEX [IXFK_FactPsStudentEnrollments_PsEnrollmentStatusId] ON [RDS].[FactPsStudentEnrollments];
END;


IF OBJECT_ID(N'[RDS].[FactPsStudentEnrollments]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[FactPsStudentEnrollments]', N'PsEnrollmentStatusId') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactPsStudentEnrollments]
		DROP COLUMN [PsEnrollmentStatusId];
	END;

END;

IF OBJECT_ID(N'[RDS].[ReportEDFactsK12StudentCounts]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsK12StudentCounts]', N'StateANSICode') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsK12StudentCounts]', N'StateAnsiCode') IS NULL
BEGIN
	EXEC sp_rename
		N'[RDS].[ReportEDFactsK12StudentCounts].[StateANSICode]',
		N'StateAnsiCode',
		N'COLUMN';
END;

IF OBJECT_ID(N'[RDS].[ReportEDFactsOrganizationCounts]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[ReportEDFactsOrganizationCounts]', N'HomelessChildrenandYouthReservation') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[ReportEDFactsOrganizationCounts]
		DROP COLUMN [HomelessChildrenandYouthReservation];
	END;

END;

IF OBJECT_ID(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'ECONOMICDISADVANTAGESTATUS') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'ECODISSTATUS') IS NULL
BEGIN
	EXEC sp_rename
		N'[RDS].[ReportEDFactsSchoolPerformanceIndicators].[ECONOMICDISADVANTAGESTATUS]',
		N'ECODISSTATUS',
		N'COLUMN';
END;

IF EXISTS (
    SELECT 1
	FROM sys.default_constraints dc
	WHERE dc.name = N'DF_FactOrganizationCounts_HomelessChildrenandYouthReservation'
      AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactOrganizationCounts]')
)
BEGIN
	ALTER TABLE [RDS].[FactOrganizationCounts]
	DROP CONSTRAINT [DF_FactOrganizationCounts_HomelessChildrenandYouthReservation];
END;

IF OBJECT_ID(N'[RDS].[FactOrganizationCounts]', N'U') IS NOT NULL
BEGIN
	IF COL_LENGTH(N'[RDS].[FactOrganizationCounts]', N'HomelessChildrenandYouthReservation') IS NOT NULL
	BEGIN
		ALTER TABLE [RDS].[FactOrganizationCounts]
		DROP COLUMN [HomelessChildrenandYouthReservation];
	END;

END;