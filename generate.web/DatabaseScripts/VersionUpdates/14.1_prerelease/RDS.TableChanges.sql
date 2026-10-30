--Add PSEnrollmentStatus to the Fact table
IF COL_LENGTH('RDS.FactK12StudentCounts', 'PsEnrollmentStatusId') IS NULL
BEGIN
	ALTER TABLE RDS.FactK12StudentCounts ADD PsEnrollmentStatusId BIGINT NULL;
END;

if not exists (
	select *
	from sys.all_columns c
	join sys.tables t 
		on t.object_id = c.object_id
	join sys.schemas s 
		on s.schema_id = t.schema_id
	join sys.default_constraints d 
		on c.default_object_id = d.object_id
	where t.name = 'FactK12StudentCounts'
	and c.name = 'PsEnrollmentStatusId'
	and s.name = 'RDS'
	and d.type = 'D'
)
BEGIN 
	ALTER TABLE [RDS].[FactK12StudentCounts] ADD CONSTRAINT [DF_FactK12StudentCounts_PsEnrollmentStatusId] DEFAULT ((-1)) FOR [PsEnrollmentStatusId];
END;


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

-- IF OBJECT_ID(N'[RDS].[ReportEDFactsOrganizationCounts]', N'U') IS NOT NULL
-- BEGIN
-- 	IF COL_LENGTH(N'[RDS].[ReportEDFactsOrganizationCounts]', N'HomelessChildrenandYouthReservation') IS NOT NULL
-- 	BEGIN
-- 		ALTER TABLE [RDS].[ReportEDFactsOrganizationCounts]
-- 		DROP COLUMN [HomelessChildrenandYouthReservation];
-- 	END;

-- END;

-- IF OBJECT_ID(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'U') IS NOT NULL
--    AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'ECONOMICDISADVANTAGESTATUS') IS NOT NULL
--    AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'ECODISSTATUS') IS NULL
-- BEGIN
-- 	EXEC sp_rename
-- 		N'[RDS].[ReportEDFactsSchoolPerformanceIndicators].[ECONOMICDISADVANTAGESTATUS]',
-- 		N'ECODISSTATUS',
-- 		N'COLUMN';
-- END;

-- IF EXISTS (
--     SELECT 1
-- 	FROM sys.default_constraints dc
-- 	WHERE dc.name = N'DF_FactOrganizationCounts_HomelessChildrenandYouthReservation'
--       AND dc.parent_object_id = OBJECT_ID(N'[RDS].[FactOrganizationCounts]')
-- )
-- BEGIN
-- 	ALTER TABLE [RDS].[FactOrganizationCounts]
-- 	DROP CONSTRAINT [DF_FactOrganizationCounts_HomelessChildrenandYouthReservation];
-- END;

-- IF OBJECT_ID(N'[RDS].[FactOrganizationCounts]', N'U') IS NOT NULL
-- BEGIN
-- 	IF COL_LENGTH(N'[RDS].[FactOrganizationCounts]', N'HomelessChildrenandYouthReservation') IS NOT NULL
-- 	BEGIN
-- 		ALTER TABLE [RDS].[FactOrganizationCounts]
-- 		DROP COLUMN [HomelessChildrenandYouthReservation];
-- 	END;

-- END;

--Add default constraints to DimAssessmentRegistrations table
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

--Add default constraints to DimAssessmentRegistrations table
IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationParticipationIndicatorCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationParticipationIndicatorCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationParticipationIndicatorCode DEFAULT 'MISSING' FOR AssessmentRegistrationParticipationIndicatorCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationCompletionStatusCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationCompletionStatusCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationCompletionStatusCode DEFAULT 'MISSING' FOR AssessmentRegistrationCompletionStatusCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationCompletionStatusDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationCompletionStatusDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationCompletionStatusDescription DEFAULT 'MISSING' FOR AssessmentRegistrationCompletionStatusDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'StateFullAcademicYearCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_StateFullAcademicYearCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_StateFullAcademicYearCode DEFAULT 'MISSING' FOR StateFullAcademicYearCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'StateFullAcademicYearDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_StateFullAcademicYearDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_StateFullAcademicYearDescription DEFAULT 'MISSING' FOR StateFullAcademicYearDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'StateFullAcademicYearEdFactsCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_StateFullAcademicYearEdFactsCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_StateFullAcademicYearEdFactsCode DEFAULT 'MISSING' FOR StateFullAcademicYearEdFactsCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'LeaFullAcademicYearCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_LeaFullAcademicYearCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_LeaFullAcademicYearCode DEFAULT 'MISSING' FOR LeaFullAcademicYearCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'LeaFullAcademicYearDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_LeaFullAcademicYearDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_LeaFullAcademicYearDescription DEFAULT 'MISSING' FOR LeaFullAcademicYearDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'LeaFullAcademicYearEdFactsCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_LeaFullAcademicYearEdFactsCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_LeaFullAcademicYearEdFactsCode DEFAULT 'MISSING' FOR LeaFullAcademicYearEdFactsCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'SchoolFullAcademicYearCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_SchoolFullAcademicYearCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_SchoolFullAcademicYearCode DEFAULT 'MISSING' FOR SchoolFullAcademicYearCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'SchoolFullAcademicYearDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_SchoolFullAcademicYearDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_SchoolFullAcademicYearDescription DEFAULT 'MISSING' FOR SchoolFullAcademicYearDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'SchoolFullAcademicYearEdFactsCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_SchoolFullAcademicYearEdFactsCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_SchoolFullAcademicYearEdFactsCode DEFAULT 'MISSING' FOR SchoolFullAcademicYearEdFactsCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationReasonNotCompletingCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingCode DEFAULT 'MISSING' FOR AssessmentRegistrationReasonNotCompletingCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationReasonNotCompletingDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingDescription DEFAULT 'MISSING' FOR AssessmentRegistrationReasonNotCompletingDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'AssessmentRegistrationReasonNotCompletingEdFactsCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingEdFactsCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_AssessmentRegistrationReasonNotCompletingEdFactsCode DEFAULT 'MISSING' FOR AssessmentRegistrationReasonNotCompletingEdFactsCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'ReasonNotTestedCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_ReasonNotTestedCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_ReasonNotTestedCode DEFAULT 'MISSING' FOR ReasonNotTestedCode
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'ReasonNotTestedDescription') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_ReasonNotTestedDescription'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_ReasonNotTestedDescription DEFAULT 'MISSING' FOR ReasonNotTestedDescription
END;

IF OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[DimAssessmentRegistrations]', N'ReasonNotTestedEdFactsCode') IS NOT NULL
   AND NOT EXISTS (
		SELECT 1
		FROM sys.default_constraints
		WHERE name = N'DF_AssessmentRegistrations_ReasonNotTestedEdFactsCode'
		  AND parent_object_id = OBJECT_ID(N'[RDS].[DimAssessmentRegistrations]')
	)
BEGIN
	ALTER TABLE RDS.DimAssessmentRegistrations 
	ADD CONSTRAINT DF_AssessmentRegistrations_ReasonNotTestedEdFactsCode DEFAULT 'MISSING' FOR ReasonNotTestedEdFactsCode
END;

Update rds.DimRaces set RaceEdFactsCode = 'MU7' where RaceCode = 'DemographicRaceTwoOrMoreRaces'

--Fix misspelled SubgroupCode (Purto -> Puerto) and the OutputCode that maps to it in RDS.vwDimSubgroups
UPDATE RDS.DimSubgroups
SET SubgroupCode = 'HispanicNotPuertoRican'
WHERE SubgroupCode = 'HispanicNotPurtoRican'

UPDATE Staging.SourceSystemReferenceData
SET OutputCode = 'HispanicNotPuertoRican'
WHERE TableName = 'RefSubgroup'
	AND OutputCode = 'HispanicNotPurtoRican'

--Add SchoolYear to the bridge tables
IF COL_LENGTH(N'[RDS].[BridgeK12StudentAssessmentAccessibilityFeatures]', N'SchoolYearId') IS NULL
BEGIN
	ALTER TABLE RDS.BridgeK12StudentAssessmentAccessibilityFeatures
	ADD SchoolYearId INT DEFAULT -1 NOT NULL
END;

IF COL_LENGTH(N'[RDS].[BridgeK12StudentAssessmentRaces]', N'SchoolYearId') IS NULL
BEGIN
	ALTER TABLE RDS.BridgeK12StudentAssessmentRaces
	ADD SchoolYearId INT DEFAULT -1 NOT NULL
END;

-- Correct misspelled STATEDDEFINEDSTATUSCODE column to STATEDEFINEDSTATUSCODE
IF OBJECT_ID(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'U') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'STATEDDEFINEDSTATUSCODE') IS NOT NULL
   AND COL_LENGTH(N'[RDS].[ReportEDFactsSchoolPerformanceIndicators]', N'STATEDEFINEDSTATUSCODE') IS NULL
BEGIN
	EXEC sp_rename
		N'[RDS].[ReportEDFactsSchoolPerformanceIndicators].[STATEDDEFINEDSTATUSCODE]',
		N'STATEDEFINEDSTATUSCODE',
		N'COLUMN';
END;

--Remove the deprecated combined Comprehensive and Targeted Support element.
--It has been replaced by Comprehensive Support and Improvement, Targeted Support and Improvement,
--and Additional Targeted Support and Improvement.
IF COL_LENGTH(N'[RDS].[ReportEDFactsOrganizationCounts]', N'ComprehensiveAndTargetedSupportCode') IS NOT NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsOrganizationCounts DROP COLUMN ComprehensiveAndTargetedSupportCode;
END;

--Our 14.0 backup doesn't have this column in the table but the standard 14.0 version does
-- so I have to add the column (again) to ensure it exists in the table
    IF COL_LENGTH('RDS.FactOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    BEGIN
        ALTER TABLE RDS.FactOrganizationCounts ADD HomelessChildrenandYouthReservation INT NULL;
    END

-- =====================================================================================================
-- finish-generate (merged from the former VersionUpdates/14.1 folder). Runs AFTER the changes above.
-- NOTE: the block above drops RDS.FactK12StudentCounts.CteOutcomeIndicatorId, but the NeglectedOrDelinquent
-- fact proc (develop and finish-generate alike) still inserts it and debug.vwNeglectedOrDelinquent_FactTable
-- joins it, so it is re-added below. Remove both the drop and this re-add once that dependency is retired.
-- =====================================================================================================
/**********************************************************************
  14.1 - RDS (CEDS Data Warehouse) fact-table repair.

  DATA-PRESERVING UPGRADE: this script is strictly ADDITIVE and idempotent.
  It only ADDs a missing column (with a default that back-fills existing rows)
  and ADDs missing DEFAULT constraints. It performs NO drop, truncate, or
  table rebuild, so states upgrading in place keep all existing fact data
  (no reload of prior years required).

  Restore DEFAULT((-1)) on NOT NULL dimension/date key columns
         of the RDS fact tables (all RDS.Fact* tables).

  The 14.0 fact-table rebuild recreated these tables but dropped the
  DEFAULT((-1)) constraints on every key column except K12Student_CurrentId.
  As a result, any Staging->Fact procedure that does not explicitly list a
  (newly added) NOT NULL key column fails its INSERT with a
  "Cannot insert the value NULL" error. That error is swallowed by the
  procedures' generic TRY/CATCH, so the migration silently produces ZERO
  fact rows (observed across ChildCount, TitleI, Membership, etc. for 2027).

  -1 is the standard star-schema "not applicable / unknown" dimension
  member used throughout Generate (see the surviving default on
  K12Student_CurrentId). Restoring the defaults makes fact population
  robust to key columns a given fact type does not populate.

  Idempotent: only adds a default where the column currently has none.
***********************************************************************/
SET NOCOUNT ON;

-- The 14.0 fact-table rebuild also dropped RDS.FactK12StudentCounts.CteOutcomeIndicatorId,
-- which the NeglectedOrDelinquent fact proc still inserts (for FS218-221/119/127 CTE/academic
-- outcome reporting) and debug.vwNeglectedOrDelinquent_FactTable joins. Its absence made that
-- proc's INSERT fail (0 NorD facts) and the debug view fail to bind. Re-add it (NA-member default -1).
IF COL_LENGTH('RDS.FactK12StudentCounts', 'CteOutcomeIndicatorId') IS NULL
    ALTER TABLE RDS.FactK12StudentCounts
        ADD CteOutcomeIndicatorId INT NOT NULL
            CONSTRAINT DF_FactK12StudentCounts_CteOutcomeIndicatorId DEFAULT((-1));

-- 14.0 also dropped RDS.FactOrganizationCounts.HomelessChildrenandYouthReservation (added in 13.2 for
-- FS193 Title I allocations), but Staging-to-FactOrganizationCounts still inserts it and
-- RDS.Create_OrganizationReportData reads it for FS193 (the report-table column was kept). Its absence
-- fails the directory fact load ("Invalid column name"), which blocks every directory report.
-- Re-add it exactly as 13.2 defined it.
IF COL_LENGTH('RDS.FactOrganizationCounts', 'HomelessChildrenandYouthReservation') IS NULL
    ALTER TABLE RDS.FactOrganizationCounts
        ADD HomelessChildrenandYouthReservation INT NULL
            CONSTRAINT DF_FactOrganizationCounts_HomelessChildrenandYouthReservation DEFAULT((0));

DECLARE @facts TABLE (tbl sysname);
-- All RDS fact tables (the 14.0 rebuild dropped the NA-member -1 defaults across the board).
INSERT INTO @facts (tbl)
SELECT 'RDS.' + name FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'RDS' AND name LIKE 'Fact%';

DECLARE @sql nvarchar(max) = N'';

SELECT @sql = @sql
    + 'ALTER TABLE ' + f.tbl
    + ' ADD CONSTRAINT [DF_' + OBJECT_NAME(c.object_id) + '_' + c.name + ']'
    + ' DEFAULT((-1)) FOR ' + QUOTENAME(c.name) + ';' + CHAR(10)
FROM @facts f
JOIN sys.columns c
    ON c.object_id = OBJECT_ID(f.tbl)
LEFT JOIN sys.default_constraints dc
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE OBJECT_ID(f.tbl) IS NOT NULL
    AND c.is_nullable = 0
    AND c.is_identity = 0
    AND dc.object_id IS NULL      -- no existing default
    AND c.name LIKE '%Id';        -- dimension / date foreign keys only (never the StudentCount measure)

IF @sql <> N''
BEGIN
    PRINT @sql;
    EXEC sp_executesql @sql;
END
ELSE
    PRINT '14.1 RDS.TableChanges: all fact-table key columns already have defaults; nothing to do.';

SET NOCOUNT OFF;
