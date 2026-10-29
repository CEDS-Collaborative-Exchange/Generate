-- App.StagingSchemaChange : registry of Staging schema changes across Generate versions.
-- Consumers: CreateSnapshotFromStaging (acts on RenameColumn only), release-notes generation,
-- and ETL-documentation diffing. Deploys inside a version's App.TableChanges.sql (no GO / no USE).
--
-- PERSISTENCE: this table accumulates rows across versions, so it must NOT be dropped on upgrade.
-- Unlike App.EtlMetadata (which uses DROP TABLE IF EXISTS + recreate), this uses a guarded create so
-- re-running an upgrade never discards accumulated history.
IF OBJECT_ID('App.StagingSchemaChange', 'U') IS NULL
BEGIN
    CREATE TABLE [App].[StagingSchemaChange](
        [SchemaChangeId]       [int] IDENTITY(1,1) NOT NULL,
        [ChangeType]           [varchar](20)   NOT NULL,	
        [OldGenerateVersion]   [varchar](12)   NOT NULL,   	-- baseline version, e.g. '13.3'
        [OldTableName]         [varchar](128)  NOT NULL,   	-- equal to NewTableName except for MoveColumn / RenameTable
        [OldColumnName]        [nvarchar](128) NULL,        -- name before (NULL for AddColumn / table-level)
        [NewGenerateVersion]   [varchar](12)   NOT NULL,   	-- version that introduces the change, e.g. '14.0'
        [NewTableName]         [varchar](128)  NOT NULL,   	-- the table the change targets
        [NewColumnName]        [nvarchar](128) NULL,        -- name after (NULL for DropColumn / table-level)
        [IsRequiredForEDFacts] [bit]           NULL,        -- flag carried by the change spreadsheet
        [OldDataDefinition]    [nvarchar](256) NULL,        -- prior type/length, for release-notes narrative
        [NewDataDefinition]    [nvarchar](256) NULL,        -- new type/length (AddColumn / AlterColumn)
        [CreatedDate]          [datetime2](0)  NOT NULL CONSTRAINT [DF_StagingSchemaChange_CreatedDate] DEFAULT (sysutcdatetime()),
        CONSTRAINT [PK_StagingSchemaChange] PRIMARY KEY CLUSTERED
        (
            [SchemaChangeId] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
        CONSTRAINT [UQ_StagingSchemaChange_Change] UNIQUE NONCLUSTERED
        (
            [NewGenerateVersion] ASC,
            [NewTableName] ASC,
            [ChangeType] ASC,
            [OldColumnName] ASC,
            [NewColumnName] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
        CONSTRAINT [CK_StagingSchemaChange_ChangeType] CHECK 
		(
			[ChangeType] IN ('RenameColumn','AddColumn','DropColumn','AlterColumn','MoveColumn','RenameTable','AddTable','DropTable')
		)
    ) ON [PRIMARY]
END

/*
    Historical backfill for App.StagingSchemaChange  (Staging schema changes 11.3 -> 14.0)
    ============================================================================
    Generated from the actual Staging.TableChanges.sql DDL (comments stripped), which is the
    authoritative record of what happened to customer Staging tables -- NOT the CEDS v14 spreadsheet
    (which was incomplete and mis-attributed a 13.2 rename to 14.0).

    Floor = 11.3, the version Utilities.CreateSnapshotFromStaging (and therefore Source snapshots)
    was introduced; nothing before it can have drifted.

    KNOWN EXCEPTIONS (not captured as static rows; enumerate manually if the registry needs them):
      - 14.0 K12SchoolComprehensiveSupportIdentificationType: a cursor converts all varchar columns
        to nvarchar at runtime (dynamic DDL), so the exact columns/lengths are not statically known.
      - Table-level changes (new/dropped/renamed Staging tables) and cross-table moves are not here;
        none occurred as column changes in this window. See the table's ChangeType enum for support.

    Deploys with no GO / no USE. Each version block is idempotent via its own guard.
*/

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '11.3')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('11.2','11.3','OrganizationAddress','OrganizationAddress','AlterColumn','AddressApartmentRoomOrSuiteNumber','AddressApartmentRoomOrSuiteNumber','nvarchar(60)', 1);
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '12.0')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('11.4','12.0','K12Organization','K12Organization','RenameColumn','School_TitleIPartASchoolDesignation','School_TitleISchoolStatus',NULL,1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AlterColumn','NeglectedOrDelinquentAcademicOutcomeIndicator','NeglectedOrDelinquentAcademicOutcomeIndicator','bit',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'NeglectedOrDelinquentStatus','bit',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'NeglectedOrDelinquentProgramEnrollmentSubpart','nvarchar(100)',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'NeglectedOrDelinquentAcademicAchievementIndicator','bit',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'EdFactsAcademicOrCareerAndTechnicalOutcomeType','nvarchar(100)',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType','nvarchar(100)',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'NeglectedProgramType','nvarchar(100)',1),
    ('11.4','12.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'DelinquentProgramType','nvarchar(100)',1),
    ('11.4','12.0','PsStudentAcademicRecord','PsStudentAcademicRecord','AddColumn',NULL,'CourseId','int',0);
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '12.1')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('12.0','12.1','AssessmentResult','AssessmentResult','AddColumn',NULL,'AssessmentAccommodationCategory','nvarchar(100)',0),
    ('12.0','12.1','AssessmentResult','AssessmentResult','AddColumn',NULL,'AccommodationType','nvarchar(100)',0)
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '12.4')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('12.3','12.4','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'TitleIIILanguageInstructionIndicator','BIT NULL',1)
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '13.0')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('12.4','13.0','ProgramParticipationTitleIII','ProgramParticipationTitleIII','AddColumn',NULL,'EnglishLearnersExitedStatus','BIT NULL',1),
    ('12.4','13.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'NeglectedOrDelinquentLongTermStatus','BIT NULL',1)
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '13.2')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('13.1','13.2','K12StaffAssignment','K12StaffAssignment','RenameColumn','SpecialEducationStaffCategory','SpecialEducationSupportServicesCategory',NULL,1),
    ('13.1','13.2','ProgramParticipationTitleIII','ProgramParticipationTitleIII','RenameColumn','EnglishLearnersExitedStatus','EnglishLearnerExitedStatus',NULL,1),																			 
    ('13.1','13.2','OrganizationFederalFunding','OrganizationFederalFunding','DropColumn','DataCollectionId',NULL,NULL,0),
    ('13.1','13.2','K12Enrollment','K12Enrollment','AddColumn',NULL,'PostSecondaryEnrollmentAction','VARCHAR(50) NULL',1),
    ('13.1','13.2','OrganizationFederalFunding','OrganizationFederalFunding','AddColumn',NULL,'HomelessChildrenandYouthReservation','NUMERIC(12,2) NULL',1),
    ('13.1','13.2','AssessmentResult','AssessmentResult','AddColumn',NULL,'AssessedFirstTime','BIT NULL',1)
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '13.3')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('13.2','13.3','K12Organization','K12Organization','AddColumn',NULL,'School_CharterSchoolStateAppropriationMethod','NVARCHAR(100) NULL',1)
END

IF NOT EXISTS (SELECT 1 FROM App.StagingSchemaChange WHERE NewGenerateVersion = '14.0')
BEGIN
    INSERT App.StagingSchemaChange
        (OldGenerateVersion, NewGenerateVersion, OldTableName, NewTableName, ChangeType, OldColumnName, NewColumnName, NewDataDefinition, IsRequiredForEDFacts)
    VALUES
    ('13.3','14.0','K12Enrollment','K12Enrollment','RenameColumn','NumberOfSchoolDays','NumberOfDaysInAttendance',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','Homelessness_StatusEndDate','Homelessness_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','HomelessNightimeResidence_BeginDate','HomelessNightimeResidence_StartDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','HomelessNightTimeResidence_EndDate','HomelessNightTimeResidence_ExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','EconomicDisadvantage_StatusEndDate','EconomicDisadvantage_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','Migrant_StatusEndDate','Migrant_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','MilitaryConnected_StatusEndDate','MilitaryConnected_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','EnglishLearner_StatusEndDate','EnglishLearner_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','PerkinsEnglishLearnerStatus_StatusEndDate','PerkinsEnglishLearnerStatus_StatusExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','MilitaryActiveStudentIndicator','MilitaryActiveStatusIndicator',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','MilitaryVeteranStudentIndicator','MilitaryVeteranStatusIndicator',NULL,0),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','FosterCare_ProgramParticipationEndDate','FosterCare_ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','Section504_ProgramParticipationEndDate','Section504_ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','PersonStatus','PersonStatus','RenameColumn','Immigrant_ProgramParticipationEndDate','Immigrant_ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','ProgramParticipationCTE','ProgramParticipationCTE','RenameColumn','ProgramParticipationBeginDate','ProgramParticipationStartDate',NULL,1),
    ('13.3','14.0','ProgramParticipationCTE','ProgramParticipationCTE','RenameColumn','ProgramParticipationEndDate','ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','ProgramParticipationNorD','ProgramParticipationNorD','RenameColumn','ProgramParticipationBeginDate','ProgramParticipationStartDate',NULL,1),
    ('13.3','14.0','ProgramParticipationNorD','ProgramParticipationNorD','RenameColumn','ProgramParticipationEndDate','ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','ProgramParticipationSpecialEducation','ProgramParticipationSpecialEducation','RenameColumn','ProgramParticipationBeginDate','ProgramParticipationStartDate',NULL,1),
    ('13.3','14.0','ProgramParticipationSpecialEducation','ProgramParticipationSpecialEducation','RenameColumn','ProgramParticipationEndDate','ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','ProgramParticipationTitleI','ProgramParticipationTitleI','RenameColumn','ProgramParticipationBeginDate','ProgramParticipationStartDate',NULL,1),
    ('13.3','14.0','ProgramParticipationTitleI','ProgramParticipationTitleI','RenameColumn','ProgramParticipationEndDate','ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','ProgramParticipationTitleIII','ProgramParticipationTitleIII','RenameColumn','ProgramParticipationBeginDate','ProgramParticipationStartDate',NULL,1),
    ('13.3','14.0','ProgramParticipationTitleIII','ProgramParticipationTitleIII','RenameColumn','ProgramParticipationEndDate','ProgramParticipationExitDate',NULL,1),
    ('13.3','14.0','K12StudentAddress','K12StudentAddress','DropColumn','RefStateId',NULL,NULL,0),
    ('13.3','14.0','K12StudentAddress','K12StudentAddress','DropColumn','OrganizationId',NULL,NULL,0),
    ('13.3','14.0','K12StudentAddress','K12StudentAddress','DropColumn','LocationId',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','DataCollectionId',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','PersonId',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationID_LEA',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationPersonRoleId_LEA',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationID_School',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationPersonRoleId_School',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationID_Course',NULL,NULL,0),	
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationID_CourseSection',NULL,NULL,0),
    ('13.3','14.0','K12StudentCourseSection','K12StudentCourseSection','DropColumn','OrganizationPersonRoleId_CourseSection',NULL,NULL,0),
    ('13.3','14.0','PsStudentAcademicRecord','PsStudentAcademicRecord','DropColumn','CourseId',NULL,NULL,0),
    ('13.3','14.0','AssessmentResult','AssessmentResult','DropColumn','AccommodationType',NULL,NULL,0),
    ('13.3','14.0','OrganizationAddress','OrganizationAddress','AlterColumn','AddressApartmentRoomOrSuiteNumber','AddressApartmentRoomOrSuiteNumber','VARCHAR (50) NULL',1),
    ('13.3','14.0','K12Enrollment','K12Enrollment','AlterColumn','RecordStartDateTime','RecordStartDateTime','DATETIME NULL',1),
    ('13.3','14.0','K12Enrollment','K12Enrollment','AlterColumn','RecordEndDateTime','RecordEndDateTime','DATETIME NULL',1),
    ('13.3','14.0','ProgramParticipationTitleIII','ProgramParticipationTitleIII','AddColumn',NULL,'RunDateTime','DATETIME NULL',0),
    ('13.3','14.0','ProgramParticipationNorD','ProgramParticipationNorD','AddColumn',NULL,'RunDateTime','DATETIME NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'IeuOrganizationIdentifierSea','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'EmployerOrganizationIdentifierSea','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'JobPositionIdentifierSea','NVARCHAR (60) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'JobTitle','NVARCHAR (200) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SEA_EducationJobTypeCode','NVARCHAR (40) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SEA_LocalJobFunctionCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SEA_LocalJobCategoryCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'Lea_EducationJobTypeCode','NVARCHAR (40) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'Lea_LocalJobFunctionCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'Lea_LocalJobCategoryCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'MigrantEducationProgramStaffCategory','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ProfessionalEducationalJobClassification','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'EmploymentStartDate','DATE NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'EmploymentEndDate','DATE NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'HireDate','DATE NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'InstructionalLanguage','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SpecialEducationRelatedServicesPersonnel','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'TeachingCredentialBasis','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'CTEInstructorIndustryCertification','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SpecialEducationParaprofessional','NVARCHAR (50) NULL',1),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'SpecialEducationTeacher','NVARCHAR (50) NULL',1),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ScedCourseCode','NVARCHAR (5) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'OnetSocOccupationType','NVARCHAR (10) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'EmploymentStatusCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'EmploymentSeparationReasonCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'TitleITargetedAssistanceStaffFundedCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'MEPPersonnelIndicatorCode','NVARCHAR (50) NULL',0),	
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ItinerantTeacherCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ItinerantTeacherDescription','NVARCHAR (200) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ClassroomPositionTypeCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'ClassroomPositionTypeDescription','NVARCHAR (200) NULL',0),
    ('13.3','14.0','K12StaffAssignment','K12StaffAssignment','AddColumn',NULL,'PrimaryAssignmentIndicatorCode','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12Organization','K12Organization','AddColumn',NULL,'School_CharterSchoolStateAppropriationMethod','NVARCHAR(100) NULL',0),
    ('13.3','14.0','K12Organization','K12Organization','AddColumn',NULL,'SchoolIdentifierAct','NVARCHAR (50) NULL',0),
    ('13.3','14.0','K12Organization','K12Organization','AddColumn',NULL,'SchoolIdentifierSat','NVARCHAR (50) NULL',0),
    ('13.3','14.0','SourceSystemReferenceData','SourceSystemReferenceData','AddColumn',NULL,'GlobalId','NVARCHAR (20) NULL',0),
    ('13.3','14.0','SourceSystemReferenceData','SourceSystemReferenceData','AddColumn',NULL,'ElementName','NVARCHAR (150) NULL',0),
    ('13.3','14.0','K12SchoolComprehensiveSupportIdentificationType','K12SchoolComprehensiveSupportIdentificationType','AddColumn',NULL,'DataCollectionName','NVARCHAR (100) NULL',0),
    ('13.3','14.0','AssessmentResult','AssessmentResult','AddColumn',NULL,'AccessibilityFeatureType','VARCHAR(100) NULL',0),
    ('13.3','14.0','AssessmentResult','AssessmentResult','AddColumn',NULL,'AccessibilityFeatureApplicationType','VARCHAR(100) NULL',0)

END

