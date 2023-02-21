
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'cedsv8' and TABLE_TYPE = 'BASE TABLE' ) 
    BEGIN
    
        ALTER SCHEMA cedsv8 TRANSFER RDS.DimNorDProgramStatuses; 
        ALTER SCHEMA cedsv8 TRANSFER RDS.DimDemographics; 
        ALTER SCHEMA cedsv8 TRANSFER RDS.DimEnrollmentStatuses;
        ALTER SCHEMA cedsv8 TRANSFER RDS.DimEnrollment;

    END

   
    --IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF__DimNorDPr__LongT__163AFC67' AND OBJECT_NAME(id) = 'DimNorDProgramStatuses')
    --ALTER TABLE [RDS].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__LongT__163AFC67]

    --IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF__DimNorDPr__Negle__172F20A0' AND OBJECT_NAME(id) = 'DimNorDProgramStatuses')
    --ALTER TABLE [RDS].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Negle__172F20A0]

    --IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF__DimNorDPr__Acade__16B25FB8' AND OBJECT_NAME(id) = 'DimNorDProgramStatuses')
    --ALTER TABLE [RDS].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Acade__16B25FB8]

    --IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'DF__DimNorDPr__Acade__17A683F1' AND OBJECT_NAME(id) = 'DimNorDProgramStatuses')
    --ALTER TABLE [RDS].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Acade__17A683F1]

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimAges' AND COLUMN_NAME = 'AgeId')
    ALTER TABLE RDS.DimAges DROP COLUMN AgeId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimAttendance' AND COLUMN_NAME = 'AbsenteeismId')
    ALTER TABLE RDS.DimAttendance DROP COLUMN AbsenteeismId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimFirearms' AND COLUMN_NAME = 'FirearmsId')
    ALTER TABLE RDS.DimFirearms DROP COLUMN FirearmsId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimFirearmDiscipline' AND COLUMN_NAME = 'FirearmDisciplineId')
    ALTER TABLE RDS.DimFirearmDiscipline DROP COLUMN FirearmDisciplineId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimFirearmsDiscipline' AND COLUMN_NAME = 'IDEAFirearmsDisciplineId')
    ALTER TABLE RDS.DimFirearmsDiscipline DROP COLUMN IDEAFirearmsDisciplineId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimOrganizationStatus' AND COLUMN_NAME = 'REAPAlternativeFundingStatusId')
    ALTER TABLE RDS.DimOrganizationStatus DROP COLUMN REAPAlternativeFundingStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimOrganizationStatus' AND COLUMN_NAME = 'GunFreeStatusId')
    ALTER TABLE RDS.DimOrganizationStatus DROP COLUMN GunFreeStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimOrganizationStatus' AND COLUMN_NAME = 'GraduationRateId')
    ALTER TABLE RDS.DimOrganizationStatus DROP COLUMN GraduationRateId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimOrganizationStatus' AND COLUMN_NAME = 'McKinneyVentoSubgrantRecipientId')
    ALTER TABLE RDS.DimOrganizationStatus DROP COLUMN McKinneyVentoSubgrantRecipientId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'MagnetStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN MagnetStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'NSLPStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN NSLPStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'SharedTimeStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN SharedTimeStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'VirtualSchoolStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN VirtualSchoolStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'ImprovementStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN ImprovementStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'PersistentlyDangerousStatusId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN PersistentlyDangerousStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'StatePovertyDesignationId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN StatePovertyDesignationId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimSchoolStatuses' AND COLUMN_NAME = 'ProgressAchievingEnglishLanguageId')
    ALTER TABLE RDS.DimSchoolStatuses DROP COLUMN ProgressAchievingEnglishLanguageId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelCategories' AND COLUMN_NAME = 'StaffCategoryCCDId')
    ALTER TABLE RDS.DimPersonnelCategories DROP COLUMN StaffCategoryCCDId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelCategories' AND COLUMN_NAME = 'StaffCategorySpecialEdId')
    ALTER TABLE RDS.DimPersonnelCategories DROP COLUMN StaffCategorySpecialEdId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelCategories' AND COLUMN_NAME = 'StaffCategoryTitle1Id')
    ALTER TABLE RDS.DimPersonnelCategories DROP COLUMN StaffCategoryTitle1Id;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'AgeGroupId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN AgeGroupId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'CertIFicationStatusId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN CertIFicationStatusId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'PersonnelTypeId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN PersonnelTypeId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'QualIFicationStatusId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN QualIFicationStatusId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'UnexperiencedStatusId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN UnexperiencedStatusId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'EmergencyOrProvisionalCredentialStatusId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN EmergencyOrProvisionalCredentialStatusId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimPersonnelStatuses' AND COLUMN_NAME = 'OutOfFieldStatusId')
    ALTER TABLE RDS.DimPersonnelStatuses DROP COLUMN OutOfFieldStatusId

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimLanguages' AND COLUMN_NAME = 'LanguageId')
    ALTER TABLE RDS.DimLanguages DROP COLUMN LanguageId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimMigrants' AND COLUMN_NAME = 'ContinuationId')
    ALTER TABLE RDS.DimMigrants DROP COLUMN ContinuationId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimMigrants' AND COLUMN_NAME = 'MepFundsStatusId')
    ALTER TABLE RDS.DimMigrants DROP COLUMN MepFundsStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimMigrants' AND COLUMN_NAME = 'MepServicesId')
    ALTER TABLE RDS.DimMigrants DROP COLUMN MepServicesId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimMigrants' AND COLUMN_NAME = 'MigrantPriorityForServicesId')
    ALTER TABLE RDS.DimMigrants DROP COLUMN MigrantPriorityForServicesId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimMigrants' AND COLUMN_NAME = 'MepEnrollmentTypeId')
    ALTER TABLE RDS.DimMigrants DROP COLUMN MepEnrollmentTypeId;

    --IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNorDProgramStatuses' AND COLUMN_NAME = 'LongTermStatusId')
    --ALTER TABLE RDS.DimNorDProgramStatuses DROP COLUMN LongTermStatusId;

    -- IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNorDProgramStatuses' AND COLUMN_NAME = 'NeglectedProgramTypeId')
    --ALTER TABLE RDS.DimNorDProgramStatuses DROP COLUMN NeglectedProgramTypeId;

    -- IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNorDProgramStatuses' AND COLUMN_NAME = 'AcademicOrVocationalOutcomeId')
    --ALTER TABLE RDS.DimNorDProgramStatuses DROP COLUMN AcademicOrVocationalOutcomeId;

    -- IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNorDProgramStatuses' AND COLUMN_NAME = 'AcademicOrVocationalExitOutcomeId')
    --ALTER TABLE RDS.DimNorDProgramStatuses DROP COLUMN AcademicOrVocationalExitOutcomeId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimStateDefinedCustomIndicators' AND COLUMN_NAME = 'StateDefinedCustomIndicatorId')
    ALTER TABLE RDS.DimStateDefinedCustomIndicators DROP COLUMN StateDefinedCustomIndicatorId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimStateDefinedStatuses' AND COLUMN_NAME = 'StateDefinedStatusId')
    ALTER TABLE RDS.DimStateDefinedStatuses DROP COLUMN StateDefinedStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleiiiStatuses' AND COLUMN_NAME = 'FormerEnglishLearnerYearStatusId')
    ALTER TABLE RDS.DimTitleiiiStatuses DROP COLUMN FormerEnglishLearnerYearStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleiiiStatuses' AND COLUMN_NAME = 'ProficiencyStatusId')
    ALTER TABLE RDS.DimTitleiiiStatuses DROP COLUMN ProficiencyStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleiiiStatuses' AND COLUMN_NAME = 'TitleiiiAccountabilityProgressStatusId')
    ALTER TABLE RDS.DimTitleiiiStatuses DROP COLUMN TitleiiiAccountabilityProgressStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleiiiStatuses' AND COLUMN_NAME = 'TitleiiiLanguageInstructionId')
    ALTER TABLE RDS.DimTitleiiiStatuses DROP COLUMN TitleiiiLanguageInstructionId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleIStatuses' AND COLUMN_NAME = 'Title1InstructionalServicesId')
    ALTER TABLE RDS.DimTitleIStatuses DROP COLUMN Title1InstructionalServicesId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleIStatuses' AND COLUMN_NAME = 'Title1ProgramTypeId')
    ALTER TABLE RDS.DimTitleIStatuses DROP COLUMN Title1ProgramTypeId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleIStatuses' AND COLUMN_NAME = 'Title1SchoolStatusId')
    ALTER TABLE RDS.DimTitleIStatuses DROP COLUMN Title1SchoolStatusId;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimTitleIStatuses' AND COLUMN_NAME = 'Title1SupportServicesId')
    ALTER TABLE RDS.DimTitleIStatuses DROP COLUMN Title1SupportServicesId;

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentDisciplines_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactStudentDisciplines')
	ALTER TABLE [RDS].[FactStudentDisciplines] DROP CONSTRAINT [FK_FactStudentDisciplines_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationStatusCounts_DimSchools' AND OBJECT_NAME(id) = 'FactOrganizationStatusCounts')
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchools]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationIndicatorStatuses_DimSchools' AND OBJECT_NAME(id) = 'FactOrganizationIndicatorStatuses')
	ALTER TABLE [RDS].[FactOrganizationIndicatorStatuses] DROP CONSTRAINT [FK_FactOrganizationIndicatorStatuses_DimSchools]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentCounts_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactStudentCounts')
	ALTER TABLE [RDS].[FactStudentCounts] DROP CONSTRAINT [FK_FactStudentCounts_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance')
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId]
	
	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeSchoolGradeLevels_DimSchools_DimSchoolId' AND OBJECT_NAME(id) = 'BridgeSchoolGradeLevels')
	ALTER TABLE [RDS].[BridgeSchoolGradeLevels] DROP CONSTRAINT [FK_BridgeSchoolGradeLevels_DimSchools_DimSchoolId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimPersonnel_DimPersonnelId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimPersonnel_DimPersonnelId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimPersonnel_DimPersonnelId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimPersonnel_DimPersonnelId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimPersonnelCategories_DimPersonnelCategoryId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimPersonnelCategories_DimPersonnelCategoryId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimPersonnelStatuses_DimPersonnelStatusId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimPersonnelStatuses_DimPersonnelStatusId]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentDisciplines_DimStudents_DimStudentId' AND OBJECT_NAME(id) = 'FactStudentDisciplines')
	ALTER TABLE [RDS].[FactStudentDisciplines] DROP CONSTRAINT [FK_FactStudentDisciplines_DimStudents_DimStudentId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeStudentDate_DimStudents_DimStudentId' AND OBJECT_NAME(id) = 'BridgeStudentDate')
	ALTER TABLE [RDS].[BridgeStudentDate] DROP CONSTRAINT [FK_BridgeStudentDate_DimStudents_DimStudentId]

	 IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentCounts_DimStudents_DimStudentId' AND OBJECT_NAME(id) = 'FactStudentCounts')
	ALTER TABLE [RDS].[FactStudentCounts] DROP CONSTRAINT [FK_FactStudentCounts_DimStudents_DimStudentId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimStudents_DimStudentId' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimStudents_DimStudentId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimStudents_DimStudentId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance')
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimStudents_DimStudentId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeLeaGradeLevels_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels')
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [FK_BridgeLeaGradeLevels_DimLeas_DimLeaId]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId' AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels')
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_BridgeSchoolGradeLevels_DimGradeLevels_DimGradeLevelId' AND OBJECT_NAME(id) = 'BridgeSchoolGradeLevels')
	ALTER TABLE [RDS].[BridgeSchoolGradeLevels] DROP CONSTRAINT [FK_BridgeSchoolGradeLevels_DimGradeLevels_DimGradeLevelId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentCounts_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactK12StudentCounts')
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimLeas_DimLeaId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimLeas_DimLeaId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAttendance_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactK12StudentAttendance')
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimLeas_DimLeaId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimLeas_DimLeaId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimLeas_DimLeaId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentAssessments_DimLeas' AND OBJECT_NAME(id) = 'FactK12StudentAssessments')
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimLeas]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimNorDProgramStatuses' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimNorDProgramStatuses]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimTitleiiiStatuses_DimTitleiiiStatusId' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimTitleiiiStatuses_DimTitleiiiStatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimStudentStatuses_DimStudentStatusId' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimStudentStatuses_DimStudentStatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentCounts_DimTitleiiiStatuses_DimTitleiiiStatusId' AND OBJECT_NAME(id) = 'FactStudentCounts')
	ALTER TABLE [RDS].[FactStudentCounts] DROP CONSTRAINT [FK_FactStudentCounts_DimTitleiiiStatuses_DimTitleiiiStatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentCounts_DimStudentStatuses_DimStudentStatusId' AND OBJECT_NAME(id) = 'FactStudentCounts')
	ALTER TABLE [RDS].[FactStudentCounts] DROP CONSTRAINT [FK_FactStudentCounts_DimStudentStatuses_DimStudentStatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactPersonnelCounts_DimTitleiiiStatuses_DimTitleiiiStatusId' AND OBJECT_NAME(id) = 'FactPersonnelCounts')
	ALTER TABLE [RDS].[FactPersonnelCounts] DROP CONSTRAINT [FK_FactPersonnelCounts_DimTitleiiiStatuses_DimTitleiiiStatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentAssessments_DimTitle1Status_DimTitle1StatusId' AND OBJECT_NAME(id) = 'FactStudentAssessments')
	ALTER TABLE [RDS].[FactStudentAssessments] DROP CONSTRAINT [FK_FactStudentAssessments_DimTitle1Status_DimTitle1StatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactStudentCounts_DimTitle1Statuses_DimTitle1StatusId' AND OBJECT_NAME(id) = 'FactStudentCounts')
	ALTER TABLE [RDS].[FactStudentCounts] DROP CONSTRAINT [FK_FactStudentCounts_DimTitle1Statuses_DimTitle1StatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactOrganizationCounts_DimTitle1Statuses_DimTitle1StatusId' AND OBJECT_NAME(id) = 'FactOrganizationCounts')
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimTitle1Statuses_DimTitle1StatusId]

	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_FactK12StudentEnrollments_DimLeas' AND OBJECT_NAME(id) = 'FactK12StudentEnrollments')
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimLeas]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_BridgeLeaGradeLevels' AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels')
    ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [PK_BridgeLeaGradeLevels]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_BridgeSchoolGradeLevels' AND OBJECT_NAME(id) = 'BridgeSchoolGradeLevels')
    ALTER TABLE [RDS].[BridgeSchoolGradeLevels] DROP CONSTRAINT [PK_BridgeSchoolGradeLevels]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimStudentStatuses' AND OBJECT_NAME(id) = 'DimStudentStatuses')
    ALTER TABLE [RDS].[DimStudentStatuses] DROP CONSTRAINT [PK_DimStudentStatuses]
    
	IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimFirearmsDisciplineId' AND OBJECT_NAME(id) = 'DimFirearmsDiscipline')
    ALTER TABLE [RDS].[DimFirearmsDiscipline] DROP CONSTRAINT [PK_DimFirearmsDisciplineId]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimOrganizationStatus' AND OBJECT_NAME(id) = 'DimOrganizationStatus')
    ALTER TABLE [RDS].[DimOrganizationStatus] DROP CONSTRAINT [PK_DimOrganizationStatus]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimSchools' AND OBJECT_NAME(id) = 'DimSchools')
    ALTER TABLE [RDS].[DimSchools] DROP CONSTRAINT [PK_DimSchools]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimSchoolStateStatus' AND OBJECT_NAME(id) = 'DimSchoolStateStatus')
    ALTER TABLE [RDS].[DimSchoolStateStatus] DROP CONSTRAINT [PK_DimSchoolStateStatus]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimSchoolStatuses' AND OBJECT_NAME(id) = 'DimSchoolStatuses')
    ALTER TABLE [RDS].[DimSchoolStatuses] DROP CONSTRAINT [PK_DimSchoolStatuses]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimPersonnel' AND OBJECT_NAME(id) = 'DimPersonnel')
    ALTER TABLE [RDS].[DimPersonnel] DROP CONSTRAINT [PK_DimPersonnel]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimPersonnelCategories' AND OBJECT_NAME(id) = 'DimPersonnelCategories')
    ALTER TABLE [RDS].[DimPersonnelCategories] DROP CONSTRAINT [PK_DimPersonnelCategories]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimPersonnelStatuses' AND OBJECT_NAME(id) = 'DimPersonnelStatuses')
    ALTER TABLE [RDS].[DimPersonnelStatuses] DROP CONSTRAINT [PK_DimPersonnelStatuses]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimStudents' AND OBJECT_NAME(id) = 'DimStudents')
    ALTER TABLE [RDS].[DimStudents] DROP CONSTRAINT [PK_DimStudents]

    IF EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimTitle1Statuses' AND OBJECT_NAME(id) = 'DimTitle1Statuses')
    ALTER TABLE [RDS].[DimTitle1Statuses] DROP CONSTRAINT [PK_DimTitle1Statuses]

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_DisciplineActionEdFactsCode')
    DROP INDEX IX_DimDisciplines_DisciplineActionEdFactsCode ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_DisciplineMethodEdFactsCode')
    DROP INDEX IX_DimDisciplines_DisciplineMethodEdFactsCode ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_EducationalServicesEdFactsCode')
    DROP INDEX IX_DimDisciplines_EducationalServicesEdFactsCode ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_RemovalReasonEdFactsCode')
    DROP INDEX IX_DimDisciplines_RemovalReasonEdFactsCode ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_RemovalTypeEdFactsCode')
    DROP INDEX IX_DimDisciplines_RemovalTypeEdFactsCode ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_Codes')
    DROP INDEX IX_DimDisciplines_Codes ON RDS.DimDisciplines; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_BasisOfExitEdFactsCode')
    DROP INDEX IX_DimIdeaStatuses_BasisOfExitEdFactsCode ON RDS.DimIdeaStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_DisabilityEdFactsCode')
    DROP INDEX IX_DimIdeaStatuses_DisabilityEdFactsCode ON RDS.DimIdeaStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_EducEnvEdFactsCode')
    DROP INDEX IX_DimIdeaStatuses_EducEnvEdFactsCode ON RDS.DimIdeaStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_Codes')
    DROP INDEX IX_DimIdeaStatuses_Codes ON RDS.DimIdeaStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_Codes')
    DROP INDEX IX_DimSchoolStatuses_Codes ON RDS.DimSchoolStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_MagnetStatusEdFactsCode')
    DROP INDEX IX_DimSchoolStatuses_MagnetStatusEdFactsCode ON RDS.DimSchoolStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_NSLPStatusEdFactsCode')
    DROP INDEX IX_DimSchoolStatuses_NSLPStatusEdFactsCode ON RDS.DimSchoolStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_SharedTimeStatusEdFactsCode')
    DROP INDEX IX_DimSchoolStatuses_SharedTimeStatusEdFactsCode ON RDS.DimSchoolStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolStatuses_VirtualSchoolStatusEdFactsCode')
    DROP INDEX IX_DimSchoolStatuses_VirtualSchoolStatusEdFactsCode ON RDS.DimSchoolStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnel_PersonnelRole')
    DROP INDEX IX_DimPersonnel_PersonnelRole ON RDS.DimPersonnel; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnel_StatePersonnelIdentIFier')
    DROP INDEX IX_DimPersonnel_StatePersonnelIdentIFier ON RDS.DimPersonnel;

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelCategories_Codes')
    DROP INDEX IX_DimPersonnelCategories_Codes ON RDS.DimPersonnelCategories; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelCategories_StaffCategoryCCDEdFactsCode')
    DROP INDEX IX_DimPersonnelCategories_StaffCategoryCCDEdFactsCode ON RDS.DimPersonnelCategories; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelCategories_StaffCategorySpecialEdEdFactsCode')
    DROP INDEX IX_DimPersonnelCategories_StaffCategorySpecialEdEdFactsCode ON RDS.DimPersonnelCategories; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelCategories_StaffCategoryTitle1EdFactsCode')
    DROP INDEX IX_DimPersonnelCategories_StaffCategoryTitle1EdFactsCode ON RDS.DimPersonnelCategories; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_AgeGroupEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_AgeGroupEdFactsCode ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_CertIFicationStatusEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_CertIFicationStatusEdFactsCode ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_Codes')
    DROP INDEX IX_DimPersonnelStatuses_Codes  ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode  ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_OutOfFieldStatusEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_OutOfFieldStatusEdFactsCode  ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_PersonnelTypeEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_PersonnelTypeEdFactsCode ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPersonnelStatuses_QualIFicationStatusEdFactsCode')
    DROP INDEX IX_DimPersonnelStatuses_QualIFicationStatusEdFactsCode  ON RDS.DimPersonnelStatuses; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimLeas_StateCode')
    DROP INDEX IX_DimLeas_StateCode ON RDS.DimLeas;

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSeas_StateCode')
    DROP INDEX IX_DimSeas_StateCode ON RDS.DimSeas;

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_ContinuationEdFactsCode')
    DROP INDEX IX_DimMigrants_ContinuationEdFactsCode ON RDS.DimMigrants; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepFundsStatusEdFactsCode')
    DROP INDEX IX_DimMigrants_MepFundsStatusEdFactsCode ON RDS.DimMigrants; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepServicesEdFactsCode')
    DROP INDEX IX_DimMigrants_MepServicesEdFactsCode ON RDS.DimMigrants; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MigrantPriorityForServicesEdFactsCode')
    DROP INDEX IX_DimMigrants_MigrantPriorityForServicesEdFactsCode ON RDS.DimMigrants; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepEnrollmentTypeEdFactsCode')
    DROP INDEX IX_DimMigrants_MepEnrollmentTypeEdFactsCode ON RDS.DimMigrants; 

    IF EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_Codes')
    DROP INDEX IX_DimMigrants_Codes ON RDS.DimMigrants; 

	IF EXISTS(select 1 from sys.columns where name = 'DimDataMigrationTypesId' AND Object_ID = Object_ID(N'RDS.DimDataMigrationTypes'))
    EXEC sp_rename 'RDS.DimDataMigrationTypes.DimDataMigrationTypesId', 'DimDataMigrationTypeId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimLeaId' AND Object_ID = Object_ID(N'RDS.BridgeLeaGradeLevels'))
    EXEC sp_rename 'RDS.BridgeLeaGradeLevels.DimLeaId', 'LeaId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.BridgeLeaGradeLevels'))
    EXEC sp_rename 'RDS.BridgeLeaGradeLevels.DimGradeLevelId', 'GradeLevelId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.BridgeSchoolGradeLevels'))
    EXEC sp_rename 'RDS.BridgeSchoolGradeLevels.DimSchoolId', 'K12SchoolId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimGradeLevelId' AND Object_ID = Object_ID(N'RDS.BridgeSchoolGradeLevels'))
    EXEC sp_rename 'RDS.BridgeSchoolGradeLevels.DimGradeLevelId', 'GradeLevelId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'CharterSchoolAuthorizerTypeCode' AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers'))
    EXEC sp_rename 'RDS.DimCharterSchoolAuthorizers.CharterSchoolAuthorizerTypeCode', 'LeaTypeCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'CharterSchoolAuthorizerTypeDescription' AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers'))
    EXEC sp_rename 'RDS.DimCharterSchoolAuthorizers.CharterSchoolAuthorizerTypeDescription', 'LeaTypeDescription', 'COLUMN'; 
    
    IF EXISTS(select 1 from sys.columns where name = 'CharterSchoolAuthorizerTypeEdfactsCode' AND Object_ID = Object_ID(N'RDS.DimCharterSchoolAuthorizers'))
    EXEC sp_rename 'RDS.DimCharterSchoolAuthorizers.CharterSchoolAuthorizerTypeEdfactsCode', 'LeaTypeEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineActionCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineActionCode', 'DisciplinaryActionTakenCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineActionDescription' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineActionDescription', 'DisciplinaryActionTakenDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineActionEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineActionEdFactsCode', 'DisciplinaryActionTakenEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineActionId' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineActionId', 'DisciplinaryActionTakenId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineMethodCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineMethodCode', 'DisciplineMethodOfChildrenWithDisabilitiesCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineMethodDescription' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineMethodDescription', 'DisciplineMethodOfChildrenWithDisabilitiesDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineMethodEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineMethodEdFactsCode', 'DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisciplineMethodId' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.DisciplineMethodId', 'DisciplineMethodOfChildrenWithDisabilitiesId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'EducationalServicesCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.EducationalServicesCode', 'EducationalServicesAfterRemovalCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'EducationalServicesDescription' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.EducationalServicesDescription', 'EducationalServicesAfterRemovalDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'EducationalServicesEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.EducationalServicesEdFactsCode', 'EducationalServicesAfterRemovalEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'EducationalServicesId' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.EducationalServicesId', 'EducationalServicesAfterRemovalId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalReasonCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalReasonCode', 'IdeaInterimRemovalReasonCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalReasonDescription' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalReasonDescription', 'IdeaInterimRemovalReasonDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'RemovalReasonEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalReasonEdFactsCode', 'IdeaInterimRemovalReasonEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalReasonId' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalReasonId', 'IdeaInterimRemovalReasonId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalTypeCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalTypeCode', 'IdeaInterimRemovalCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalTypeDescription' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalTypeDescription', 'IdeaInterimRemovalDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'RemovalTypeEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalTypeEdFactsCode', 'IdeaInterimRemovalEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'RemovalTypeId' AND Object_ID = Object_ID(N'RDS.DimDisciplines'))
    EXEC sp_rename 'RDS.DimDisciplines.RemovalTypeId', 'IdeaInterimRemovalId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsCode' AND Object_ID = Object_ID(N'RDS.DimFirearms'))
    EXEC sp_rename 'RDS.DimFirearms.FirearmsCode', 'FirearmTypeCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsDescription' AND Object_ID = Object_ID(N'RDS.DimFirearms'))
    EXEC sp_rename 'RDS.DimFirearms.FirearmsDescription', 'FirearmTypeDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimFirearms'))
    EXEC sp_rename 'RDS.DimFirearms.FirearmsEdFactsCode', 'FirearmTypeEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimFirearmsDisciplineId' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.DimFirearmsDisciplineId', 'DimFirearmDisciplineId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsDisciplineCode' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.FirearmsDisciplineCode', 'DisciplineMethodForFirearmsIncidentsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsDisciplineDescription' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.FirearmsDisciplineDescription', 'DisciplineMethodForFirearmsIncidentsDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'FirearmsDisciplineEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.FirearmsDisciplineEdFactsCode', 'DisciplineMethodForFirearmsIncidentsEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'IDEAFirearmsDisciplineCode' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.IDEAFirearmsDisciplineCode', 'IdeaDisciplineMethodForFirearmsIncidentsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'IDEAFirearmsDisciplineDescription' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.IDEAFirearmsDisciplineDescription', 'IdeaDisciplineMethodForFirearmsIncidentsDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'IDEAFirearmsDisciplineEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimFirearmsDiscipline'))
    EXEC sp_rename 'RDS.DimFirearmsDiscipline.IDEAFirearmsDisciplineEdFactsCode', 'IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'BasisOfExitCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.BasisOfExitCode', 'SpecialEducationExitReasonCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'BasisOfExitDescription' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.BasisOfExitDescription', 'SpecialEducationExitReasonDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'BasisOfExitEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.BasisOfExitEdFactsCode', 'SpecialEducationExitReasonEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'BasisOfExitId' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.BasisOfExitId', 'SpecialEducationExitReasonId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisabilityCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.DisabilityCode', 'PrimaryDisabilityTypeCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisabilityDescription' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.DisabilityDescription', 'PrimaryDisabilityTypeDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'DisabilityEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.DisabilityEdFactsCode', 'PrimaryDisabilityTypeEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DisabilityId' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.DisabilityId', 'PrimaryDisabilityTypeId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'EducEnvCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.EducEnvCode', 'IdeaEducationalEnvironmentCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'EducEnvDescription' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.EducEnvDescription', 'IdeaEducationalEnvironmentDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'EducEnvEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.EducEnvEdFactsCode', 'IdeaEducationalEnvironmentEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'EducEnvId' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.EducEnvId', 'IdeaEducationalEnvironmentId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'IDEAIndicatorCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.IDEAIndicatorCode', 'IdeaIndicatorCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'IDEAIndicatorDescription' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.IDEAIndicatorDescription', 'IdeaIndicatorDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'IDEAIndicatorEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.IDEAIndicatorEdFactsCode', 'IdeaIndicatorEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'IDEAIndicatorId' AND Object_ID = Object_ID(N'RDS.DimIdeaStatuses'))
    EXEC sp_rename 'RDS.DimIdeaStatuses.IDEAIndicatorId', 'IdeaIndicatorId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimOrganizationStatusId' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.DimOrganizationStatusId', 'DimK12OrganizationStatusId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'REAPAlternativeFundingStatusCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.REAPAlternativeFundingStatusCode', 'ReapAlternativeFundingStatusCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'REAPAlternativeFundingStatusDescription' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.REAPAlternativeFundingStatusDescription', 'ReapAlternativeFundingStatusDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'REAPAlternativeFundingStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.REAPAlternativeFundingStatusEdFactsCode', 'ReapAlternativeFundingStatusEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'GunFreeStatusCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GunFreeStatusCode', 'GunFreeSchoolsActReportingStatusCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'GunFreeStatusDescription' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GunFreeStatusDescription', 'GunFreeSchoolsActReportingStatusDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'GunFreeStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GunFreeStatusEdFactsCode', 'GunFreeSchoolsActReportingStatusEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'GraduationRateCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GraduationRateCode', 'HighSchoolGraduationRateIndicatorStatusCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'GraduationRateDescription' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GraduationRateDescription', 'HighSchoolGraduationRateIndicatorStatusDescription', 'COLUMN';  

    IF EXISTS(select 1 from sys.columns where name = 'GraduationRateEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimOrganizationStatus'))
    EXEC sp_rename 'RDS.DimOrganizationStatus.GraduationRateEdFactsCode', 'HighSchoolGraduationRateIndicatorStatusEdFactsCode', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimSchoolId' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.DimSchoolId', 'DimK12SchoolId', 'COLUMN';
    
    IF EXISTS(select 1 from sys.columns where name = 'LeaNcesIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.LeaNcesIdentifier', 'LeaIdentifierNces', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.LeaStateIdentifier', 'LeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SchoolNcesIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.SchoolNcesIdentifier', 'SchoolIdentifierNces', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SchoolName' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.SchoolName', 'NameOfInstitution', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SchoolStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.SchoolStateIdentifier', 'SchoolIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.SeaStateIdentifier', 'SeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateANSICode' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.StateANSICode', 'StateAnsiCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateCode' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.StateCode', 'StateAbbreviationCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateName' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.StateName', 'StateAbbreviationDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PriorLeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.PriorLeaStateIdentifier', 'PriorLeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PriorSchoolStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.PriorSchoolStateIdentifier', 'PriorSchoolIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'CharterContractApprovalDate' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.CharterContractApprovalDate', 'CharterSchoolContractApprovalDate', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'CharterContractRenewalDate' AND Object_ID = Object_ID(N'RDS.DimSchools'))
    EXEC sp_rename 'RDS.DimSchools.CharterContractRenewalDate', 'CharterSchoolContractRenewalDate', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LeaNcesIdentifier' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.LeaNcesIdentifier', 'LeaIdentifierNces', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.LeaStateIdentifier', 'LeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.SeaStateIdentifier', 'SeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateANSICode' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.StateANSICode', 'StateAnsiCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateCode' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.StateCode', 'StateAbbreviationCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateName' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.StateName', 'StateAbbreviationDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PriorLeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.PriorLeaStateIdentifier', 'PriorLeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SupervisoryUnionIdentificationNumber' AND Object_ID = Object_ID(N'RDS.DimLeas'))
    EXEC sp_rename 'RDS.DimLeas.SupervisoryUnionIdentificationNumber', 'LeaSupervisoryUnionIdentificationNumber', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SeaStateIdentifier' AND Object_ID = Object_ID(N'RDS.DimSeas'))
    EXEC sp_rename 'RDS.DimSeas.SeaStateIdentifier', 'SeaIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateANSICode' AND Object_ID = Object_ID(N'RDS.DimSeas'))
    EXEC sp_rename 'RDS.DimSeas.StateANSICode', 'StateAnsiCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateCode' AND Object_ID = Object_ID(N'RDS.DimSeas'))
    EXEC sp_rename 'RDS.DimSeas.StateCode', 'StateAbbreviationCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StateName' AND Object_ID = Object_ID(N'RDS.DimSeas'))
    EXEC sp_rename 'RDS.DimSeas.StateName', 'StateAbbreviationDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimSchoolStateStatusId' AND Object_ID = Object_ID(N'RDS.DimSchoolStateStatus'))
    EXEC sp_rename 'RDS.DimSchoolStateStatus.DimSchoolStateStatusId', 'DimK12SchoolStateStatusId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'DimSchoolStatusId' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.DimSchoolStatusId', 'DimK12SchoolStatusId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'MagnetStatusCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.MagnetStatusCode', 'MagnetOrSpecialProgramEmphasisSchoolCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MagnetStatusDescription' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.MagnetStatusDescription', 'MagnetOrSpecialProgramEmphasisSchoolDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MagnetStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.MagnetStatusEdFactsCode', 'MagnetOrSpecialProgramEmphasisSchoolEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'NSLPStatusCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.NSLPStatusCode', 'NslpStatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'NSLPStatusDescription' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.NSLPStatusDescription', 'NslpStatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'NSLPStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.NSLPStatusEdFactsCode', 'NslpStatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SharedTimeStatusCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.SharedTimeStatusCode', 'SharedTimeIndicatorCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SharedTimeStatusDescription' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.SharedTimeStatusDescription', 'SharedTimeIndicatorDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'SharedTimeStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.SharedTimeStatusEdFactsCode', 'SharedTimeIndicatorEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImprovementStatusCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.ImprovementStatusCode', 'SchoolImprovementStatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImprovementStatusDescription' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.ImprovementStatusDescription', 'SchoolImprovementStatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImprovementStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimSchoolStatuses'))
    EXEC sp_rename 'RDS.DimSchoolStatuses.ImprovementStatusEdFactsCode', 'SchoolImprovementStatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelId' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.DimPersonnelId', 'DimK12StaffId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'LastName' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.LastName', 'LastOrSurname', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StatePersonnelIdentifier' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.StatePersonnelIdentifier', 'StaffMemberIdentifierState', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Email' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.Email', 'ElectronicMailAddress', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PersonnelRole' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.PersonnelRole', 'K12StaffRole', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Telephone' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.Telephone', 'TelephoneNumber', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title' AND Object_ID = Object_ID(N'RDS.DimPersonnel'))
    EXEC sp_rename 'RDS.DimPersonnel.Title', 'PositionTitle', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelCategoryId' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.DimPersonnelCategoryId', 'DimK12StaffCategoryId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryCCDCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryCCDCode', 'K12StaffClassificationCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryCCDDescription' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryCCDDescription', 'K12StaffClassificationDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryCCDEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryCCDEdFactsCode', 'K12StaffClassificationEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategorySpecialEdCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategorySpecialEdCode', 'SpecialEducationSupportServicesCategoryCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategorySpecialEdDescription' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategorySpecialEdDescription', 'SpecialEducationSupportServicesCategoryDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategorySpecialEdEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategorySpecialEdEdFactsCode', 'SpecialEducationSupportServicesCategoryEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryTitle1Code' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryTitle1Code', 'TitleIProgramStaffCategoryCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryTitle1Description' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryTitle1Description', 'TitleIProgramStaffCategoryDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'StaffCategoryTitle1EdFactsCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelCategories'))
    EXEC sp_rename 'RDS.DimPersonnelCategories.StaffCategoryTitle1EdFactsCode', 'TitleIProgramStaffCategoryEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimPersonnelStatusId' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.DimPersonnelStatusId', 'DimK12StaffStatusId', 'COLUMN'; 

    IF EXISTS(select 1 from sys.columns where name = 'AgeGroupCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.AgeGroupCode', 'SpecialEducationAgeGroupTaughtCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'AgeGroupDescription' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.AgeGroupDescription', 'SpecialEducationAgeGroupTaughtDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'AgeGroupEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.AgeGroupEdFactsCode', 'SpecialEducationAgeGroupTaughtEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PersonnelTypeCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.PersonnelTypeCode', 'K12StaffClassificationCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PersonnelTypeDescription' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.PersonnelTypeDescription', 'K12StaffClassificationDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'PersonnelTypeEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimPersonnelStatuses'))
    EXEC sp_rename 'RDS.DimPersonnelStatuses.PersonnelTypeEdFactsCode', 'K12StaffClassificationEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimStudentId' AND Object_ID = Object_ID(N'RDS.DimStudents'))
    EXEC sp_rename 'RDS.DimStudents.DimStudentId', 'DimK12StudentId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LanguageCode' AND Object_ID = Object_ID(N'RDS.DimLanguages'))
    EXEC sp_rename 'RDS.DimLanguages.LanguageCode', 'Iso6392LanguageCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LanguageDescription' AND Object_ID = Object_ID(N'RDS.DimLanguages'))
    EXEC sp_rename 'RDS.DimLanguages.LanguageDescription', 'Iso6392LanguageDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'LanguageEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimLanguages'))
    EXEC sp_rename 'RDS.DimLanguages.LanguageEdFactsCode', 'Iso6392LanguageEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ContinuationCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.ContinuationCode', 'ContinuationOfServicesReasonCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ContinuationDescription' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.ContinuationDescription', 'ContinuationOfServicesReasonDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ContinuationEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.ContinuationEdFactsCode', 'ContinuationOfServicesReasonEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepFundsStatusCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepFundsStatusCode', 'ConsolidatedMepFundsStatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepFundsStatusDescription' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepFundsStatusDescription', 'ConsolidatedMepFundsStatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepFundsStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepFundsStatusEdFactsCode', 'ConsolidatedMepFundsStatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepServicesCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepServicesCode', 'MepServicesTypeCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepServicesDescription' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepServicesDescription', 'MepServicesTypeDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MepServicesEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MepServicesEdFactsCode', 'MepServicesTypeEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MigrantPriorityForServicesCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MigrantPriorityForServicesCode', 'MigrantPrioritizedForServicesCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MigrantPriorityForServicesDescription' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MigrantPriorityForServicesDescription', 'MigrantPrioritizedForServicesDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'MigrantPriorityForServicesEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimMigrants'))
    EXEC sp_rename 'RDS.DimMigrants.MigrantPriorityForServicesEdFactsCode', 'MigrantPrioritizedForServicesEdFactsCode', 'COLUMN';

    --IF EXISTS(select 1 from sys.columns where name = 'NeglectedProgramTypeCode' AND Object_ID = Object_ID(N'RDS.DimNorDProgramStatuses'))
    --EXEC sp_rename 'RDS.DimNorDProgramStatuses.NeglectedProgramTypeCode', 'NeglectedOrDelinquentProgramTypeCode', 'COLUMN';

    --IF EXISTS(select 1 from sys.columns where name = 'NeglectedProgramTypeDescription' AND Object_ID = Object_ID(N'RDS.DimNorDProgramStatuses'))
    --EXEC sp_rename 'RDS.DimNorDProgramStatuses.NeglectedProgramTypeDescription', 'NeglectedOrDelinquentProgramTypeDescription', 'COLUMN';

    --IF EXISTS(select 1 from sys.columns where name = 'NeglectedProgramTypeEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimNorDProgramStatuses'))
    --EXEC sp_rename 'RDS.DimNorDProgramStatuses.NeglectedProgramTypeEdFactsCode', 'NeglectedOrDelinquentProgramTypeEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FoodServiceEligibilityCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.FoodServiceEligibilityCode', 'EligibilityStatusForSchoolFoodServiceProgramCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FoodServiceEligibilityDescription' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.FoodServiceEligibilityDescription', 'EligibilityStatusForSchoolFoodServiceProgramDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'FoodServiceEligibilityEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.FoodServiceEligibilityEdFactsCode', 'EligibilityStatusForSchoolFoodServiceProgramEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImmigrantTitleIIIProgramCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.ImmigrantTitleIIIProgramCode', 'TitleIIIImmigrantParticipationStatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImmigrantTitleIIIProgramDescription' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.ImmigrantTitleIIIProgramDescription', 'TitleIIIImmigrantParticipationStatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'ImmigrantTitleIIIProgramEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.ImmigrantTitleIIIProgramEdFactsCode', 'TitleIIIImmigrantParticipationStatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Section504ProgramCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.Section504ProgramCode', 'Section504StatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Section504ProgramDescription' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.Section504ProgramDescription', 'Section504StatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Section504ProgramEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimProgramStatuses'))
    EXEC sp_rename 'RDS.DimProgramStatuses.Section504ProgramEdFactsCode', 'Section504StatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimTitleiiiStatusId' AND Object_ID = Object_ID(N'RDS.DimTitleiiiStatuses'))
    EXEC sp_rename 'RDS.DimTitleiiiStatuses.DimTitleiiiStatusId', 'DimTitleIIIStatusId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimTitle1StatusId' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.DimTitle1StatusId', 'DimTitleIStatusId', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1InstructionalServicesCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1InstructionalServicesCode', 'TitleIInstructionalServicesCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1InstructionalServicesDescription' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1InstructionalServicesDescription', 'TitleIInstructionalServicesDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1InstructionalServicesEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1InstructionalServicesEdFactsCode', 'TitleIInstructionalServicesEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1ProgramTypeCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1ProgramTypeCode', 'TitleIProgramTypeCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1ProgramTypeDescription' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1ProgramTypeDescription', 'TitleIProgramTypeDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1ProgramTypeEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1ProgramTypeEdFactsCode', 'TitleIProgramTypeEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SchoolStatusCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SchoolStatusCode', 'TitleISchoolStatusCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SchoolStatusDescription' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SchoolStatusDescription', 'TitleISchoolStatusDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SchoolStatusEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SchoolStatusEdFactsCode', 'TitleISchoolStatusEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SupportServicesCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SupportServicesCode', 'TitleISupportServicesCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SupportServicesDescription' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SupportServicesDescription', 'TitleISupportServicesDescription', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'Title1SupportServicesEdFactsCode' AND Object_ID = Object_ID(N'RDS.DimTitle1Statuses'))
    EXEC sp_rename 'RDS.DimTitle1Statuses.Title1SupportServicesEdFactsCode', 'TitleISupportServicesEdFactsCode', 'COLUMN';

    IF EXISTS(select 1 from sys.columns where name = 'DimStudentStatusId' AND Object_ID = Object_ID(N'RDS.DimStudentStatuses'))
    EXEC sp_rename 'RDS.DimStudentStatuses.DimStudentStatusId', 'DimK12StudentStatusId', 'COLUMN';


    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimFirearmsDiscipline')
    EXEC sp_rename 'RDS.DimFirearmsDiscipline', 'DimFirearmDisciplines';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimOrganizationStatus')
    EXEC sp_rename 'RDS.DimOrganizationStatus', 'DimK12OrganizationStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimSchoolStateStatus')
    EXEC sp_rename 'RDS.DimSchoolStateStatus', 'DimK12SchoolStateStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPersonnel')
    EXEC sp_rename 'RDS.DimPersonnel', 'DimK12Staff';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPersonnelCategories')
    EXEC sp_rename 'RDS.DimPersonnelCategories', 'DimK12StaffCategories';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPersonnelStatuses')
    EXEC sp_rename 'RDS.DimPersonnelStatuses', 'DimK12StaffStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimStudents')
    EXEC sp_rename 'RDS.DimStudents', 'DimK12Students';

    --IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimNorDProgramStatuses')
    --EXEC sp_rename 'RDS.DimNorDProgramStatuses', 'DimNOrDProgramStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimTitleiiiStatuses')
    EXEC sp_rename 'RDS.DimTitleiiiStatuses', 'DimTitleIIIStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimTitle1Statuses')
    EXEC sp_rename 'RDS.DimTitle1Statuses', 'DimTitleIStatuses';

	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimSchools')
    EXEC sp_rename 'RDS.DimSchools', 'DimK12Schools';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimSchoolStatuses')
    EXEC sp_rename 'RDS.DimSchoolStatuses', 'DimK12SchoolStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimStudentStatuses')
    EXEC sp_rename 'RDS.DimStudentStatuses', 'DimK12StudentStatuses';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeSchoolGradeLevels')
    EXEC sp_rename 'RDS.BridgeSchoolGradeLevels', 'BridgeK12SchoolGradeLevels';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'BridgeStudentDate')
    DROP TABLE RDS.BridgeStudentDate

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimK12Staff' AND COLUMN_NAME = 'K12StaffPersonId')
    ALTER TABLE RDS.DimK12Staff ADD K12StaffPersonId int NULL;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimCharterSchoolAuthorizers' AND COLUMN_NAME = 'LeaTypeId')
    ALTER TABLE RDS.DimCharterSchoolAuthorizers ADD LeaTypeId int NULL;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimCharterSchoolAuthorizers' AND COLUMN_NAME = 'MailingCountyAnsiCode')
    ALTER TABLE RDS.DimCharterSchoolAuthorizers ADD MailingCountyAnsiCode CHAR(5) NULL;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimCharterSchoolAuthorizers' AND COLUMN_NAME = 'PhysicalCountyAnsiCode')
    ALTER TABLE RDS.DimCharterSchoolAuthorizers ADD PhysicalCountyAnsiCode CHAR(5) NULL;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimCharterSchoolAuthorizers' AND COLUMN_NAME = 'IsApproverAgency')
    ALTER TABLE RDS.DimCharterSchoolAuthorizers ADD IsApproverAgency [nvarchar](max) NULL;

    IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimK12Students' AND COLUMN_NAME = 'SexCode')
    ALTER TABLE RDS.DimK12Students ADD SexCode NVARCHAR(50) NULL, SexDescription NVARCHAR(200) NULL, SexEdFactsCode NVARCHAR(50) NULL;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNOrDProgramStatuses' AND COLUMN_NAME = 'AcademicOrVocationalOutcomeCode')
    ALTER TABLE RDS.DimNOrDProgramStatuses DROP COLUMN AcademicOrVocationalOutcomeCode, AcademicOrVocationalOutcomeDescription, AcademicOrVocationalOutcomeEdFactsCode;

    IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'RDS' AND TABLE_NAME = 'DimNOrDProgramStatuses' AND COLUMN_NAME = 'AcademicOrVocationalExitOutcomeCode')
    ALTER TABLE RDS.DimNOrDProgramStatuses DROP COLUMN AcademicOrVocationalExitOutcomeCode, AcademicOrVocationalExitOutcomeDescription, AcademicOrVocationalExitOutcomeEdFactsCode;
	 
   
    

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = 'DimAcademicTermDesignators') 
    BEGIN
        CREATE TABLE [RDS].[DimAcademicTermDesignators] (
            [DimAcademicTermDesignatorId]  INT            NOT NULL,
            [AcademicTermDesignatorCode]        NVARCHAR (50)  NULL,
            [AcademicTermDesignatorDescription] NVARCHAR (MAX) NULL,
            CONSTRAINT [PK_DimAcademicTermDesignators] PRIMARY KEY CLUSTERED ([DimAcademicTermDesignatorId] ASC) WITH (DATA_COMPRESSION = PAGE)
        );
    END

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimCipCodes')
    CREATE TABLE [RDS].[DimCipCodes] (
        [DimCipCodeId]          INT            NOT NULL,
        [CipCode]               NVARCHAR (7)   NULL,
        [CipUseCode]            NVARCHAR (50)  NULL,
        [CipUseDescription]     NVARCHAR (200) NULL,
        [CipVersionCode]        NVARCHAR (50)  NULL,
        [CipVersionDescription] NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimCipCodes] PRIMARY KEY CLUSTERED ([DimCipCodeId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimCredentials')
    CREATE TABLE [RDS].[DimCredentials] (
        [DimCredentialsId]                          BIGINT         IDENTITY (1, 1) NOT NULL,
        [CredentialTitle]                           NVARCHAR (300) NOT NULL,
        [CredentialDescription]                     NVARCHAR (MAX) NOT NULL,
        [CredentialAlternateName]                   NVARCHAR (300) NULL,
        [CredentialCategorySystem]                  NVARCHAR (30)  NULL,
        [CredentialCategoryType]                    NVARCHAR (60)  NULL,
        [CredentialStatusTypeCode]                  NVARCHAR (50)  NULL,
        [CredentialStatusTypeDescription]           NVARCHAR (300) NULL,
        [CredentialIntendedPurposeTypeCode]         NVARCHAR (50)  NULL,
        [CredentialIntendedPurposeTypeDescription]  NVARCHAR (300) NULL,
        [CredentialAssessmentMethodTypeCode]        NVARCHAR (50)  NULL,
        [CredentialAssessmentMethodTypeDescription] NVARCHAR (300) NULL,
        CONSTRAINT [PK_DimCredentials] PRIMARY KEY CLUSTERED ([DimCredentialsId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimDataCollections')
    CREATE TABLE [RDS].[DimDataCollections] (
        [DimDataCollectionId]					INT            IDENTITY (1, 1) NOT NULL,
        [SourceSystemDataCollectionIdentifier]  INT            NULL,
        [SourceSystemName]						NVARCHAR (100) NULL,
        [DataCollectionName]					NVARCHAR (100) NOT NULL,
        [DataCollectionDescription]				NVARCHAR (MAX) NULL,
        [DataCollectionOpenDate]				DATETIME       NULL,
        [DataCollectionCloseDate]				DATETIME       NULL,
        [DataCollectionAcademicSchoolYear]		NVARCHAR (7)   NULL,
        [DataCollectionSchoolYear]				NVARCHAR (7)   NULL,
        CONSTRAINT [PK_DimCollections] PRIMARY KEY CLUSTERED ([DimDataCollectionId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimIeus')
    CREATE TABLE [RDS].[DimIeus] (
        [DimIeuId]                       INT             IDENTITY (1, 1) NOT NULL,
        [IeuName]                        NVARCHAR (1000) NULL,
        [IeuIdentifierState]             NVARCHAR (50)   NULL,
        [SeaName]                        NVARCHAR (1000) NULL,
        [SeaStateIdentifier]             NVARCHAR (50)   NULL,
        [StateANSICode]                  NVARCHAR (10)   NULL,
        [StateCode]                      NVARCHAR (10)   NULL,
        [StateName]                      NVARCHAR (1000) NULL,
        [MailingAddressStreet]           NVARCHAR (40)   NULL,
        [MailingAddressCity]             NVARCHAR (30)   NULL,
        [MailingAddressState]            NVARCHAR (50)   NULL,
        [MailingAddressPostalCode]       NVARCHAR (17)   NULL,
	    [MailingCountyAnsiCode]			 CHAR(5)		 NULL,
        [OutOfStateIndicator]            BIT             NOT NULL,
        [OrganizationOperationalStatus]  VARCHAR (20)    NULL,
        [OperationalStatusEffectiveDate] DATETIME        NULL,
        [PhysicalAddressStreet]          NVARCHAR (40)   NULL,
        [PhysicalAddressCity]            NVARCHAR (30)   NULL,
        [PhysicalAddressPostalCode]      NVARCHAR (17)   NULL,
        [PhysicalAddressState]           NVARCHAR (50)   NULL,
	    [PhysicalCountyAnsiCode]		 CHAR(5)		 NULL,
        [Telephone]                      NVARCHAR (24)   NULL,
        [Website]                        NVARCHAR (300)  NULL,
        [OrganizationRegionGeoJson]      NVARCHAR (MAX)  NULL,
        [Latitude]                       NVARCHAR (20)   NULL,
        [Longitude]                      NVARCHAR (20)   NULL,
        [RecordStartDateTime]            DATETIME        NOT NULL,
        [RecordEndDateTime]              DATETIME        NULL,
        CONSTRAINT [PK_DimIeus] PRIMARY KEY NONCLUSTERED ([DimIeuId] ASC) WITH (DATA_COMPRESSION = PAGE)
    )
    WITH (DATA_COMPRESSION = PAGE);

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimK12Courses')
    CREATE TABLE [RDS].[DimK12Courses] (
        [DimK12CourseId]                 INT            IDENTITY (1, 1) NOT NULL,
        [CourseIdentifier]               NVARCHAR (40)  NOT NULL,
        [CourseCodeSystemCode]           NVARCHAR (50)  NOT NULL,
        [CourseCodeSystemDesciption]     NVARCHAR (200) NOT NULL,
        [CourseTitle]                    NVARCHAR (60)  NOT NULL,
        [CourseDescription]              NVARCHAR (60)  NOT NULL,
        [CourseDepartmentName]           NVARCHAR (60)  NOT NULL,
        [CourseCreditUnitsCode]          NVARCHAR (50)  NOT NULL,
        [CourseCreditUnitsDescription]   NVARCHAR (200) NOT NULL,
        [CreditValue]                    DECIMAL (4, 2) NOT NULL,
        [AdvancedPlacementCourseCode]    NVARCHAR (60)  NOT NULL,
        [CareerClusterCode]              NVARCHAR (50)  NOT NULL,
        [CareerClusterDescription]       NVARCHAR (200) NOT NULL,
        [CourseCertificationDescription] NVARCHAR (300) NOT NULL,
        [TuitionFunded]                  BIT            NOT NULL,
        [CourseFundingProgram]           NVARCHAR (30)  NULL,
        CONSTRAINT [PK_DimK12Courses] PRIMARY KEY CLUSTERED ([DimK12CourseId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimK12CourseStatuses')
    CREATE TABLE [RDS].[DimK12CourseStatuses] (
        [DimK12CourseStatusId]                 INT            IDENTITY (1, 1) NOT NULL,
        [CourseLevelCharacteristicCode]        NVARCHAR (50)  NOT NULL,
        [CourseLevelCharacteristicDescription] NVARCHAR (200) NOT NULL,
        CONSTRAINT [PK_DimK12CourseStatuses] PRIMARY KEY CLUSTERED ([DimK12CourseStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimK12Demographics')
    CREATE TABLE RDS.[DimK12Demographics] (
        [DimK12DemographicId]                          INT            IDENTITY (1, 1) NOT NULL,
        [EconomicDisadvantageStatusCode]               NVARCHAR (50)  NULL,
        [EconomicDisadvantageStatusDescription]        NVARCHAR (200) NULL,
        [EconomicDisadvantageStatusEdFactsCode]        NVARCHAR (50)  NULL,
        [HomelessnessStatusCode]                       NVARCHAR (50)  NULL,
        [HomelessnessStatusDescription]                NVARCHAR (200) NULL,
        [HomelessnessStatusEdFactsCode]                NVARCHAR (50)  NULL,
        [EnglishLearnerStatusCode]                     NVARCHAR (50)  NULL,
        [EnglishLearnerStatusDescription]              NVARCHAR (200) NULL,
        [EnglishLearnerStatusEdFactsCode]              NVARCHAR (50)  NULL,
        [MigrantStatusCode]                            NVARCHAR (50)  NULL,
        [MigrantStatusDescription]                     NVARCHAR (200) NULL,
        [MigrantStatusEdFactsCode]                     NVARCHAR (50)  NULL,
        [MilitaryConnectedStudentIndicatorCode]        NVARCHAR (50)  NULL,
        [MilitaryConnectedStudentIndicatorDescription] NVARCHAR (200) NULL,
        [MilitaryConnectedStudentIndicatorEdFactsCode] NVARCHAR (50)  NULL,
        [HomelessPrimaryNighttimeResidenceCode]        NVARCHAR (50)  NULL,
        [HomelessPrimaryNighttimeResidenceDescription] NVARCHAR (MAX) NULL,
        [HomelessPrimaryNighttimeResidenceEdFactsCode] NVARCHAR (50)  NULL,
        [HomelessUnaccompaniedYouthStatusCode]         NVARCHAR (50)  NULL,
        [HomelessUnaccompaniedYouthStatusDescription]  NVARCHAR (MAX) NULL,
        [HomelessUnaccompaniedYouthStatusEdFactsCode]  NVARCHAR (50)  NULL,
        CONSTRAINT [PK_DimK12Demographics] PRIMARY KEY CLUSTERED ([DimK12DemographicId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimK12EnrollmentStatuses')
    CREATE TABLE [RDS].[DimK12EnrollmentStatuses] (
        [DimK12EnrollmentStatusId]                 INT            IDENTITY (1, 1) NOT NULL,
        [EnrollmentStatusCode]                     NVARCHAR (50)  NULL,
        [EnrollmentStatusDescription]              NVARCHAR (50)  NULL,
        [EntryTypeCode]                            NVARCHAR (50)  NULL,
        [EntryTypeDescription]                     NVARCHAR (200) NULL,
        [ExitOrWithdrawalTypeCode]                 NVARCHAR (50)  NULL,
        [ExitOrWithdrawalTypeDescription]          NVARCHAR (300) NULL,
        [PostSecondaryEnrollmentStatusCode]        VARCHAR (50)   NULL,
        [PostSecondaryEnrollmentStatusDescription] VARCHAR (200)  NULL,
        [PostSecondaryEnrollmentStatusEdFactsCode] VARCHAR (50)   NULL,
        [AcademicOrVocationalOutcomeCode]        VARCHAR (50)   NULL,
        [AcademicOrVocationalOutcomeDescription] VARCHAR (100)  NULL,
        [AcademicOrVocationalOutcomeEdFactsCode] VARCHAR (50)   NULL,
        [AcademicOrVocationalExitOutcomeCode]        VARCHAR (50)   NULL,
        [AcademicOrVocationalExitOutcomeDescription] VARCHAR (100)  NULL,
        [AcademicOrVocationalExitOutcomeEdFactsCode] VARCHAR (50)   NULL,
        CONSTRAINT [PK_DimK12EnrollmentStatuses] PRIMARY KEY CLUSTERED ([DimK12EnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimK12ProgramTypes')
    CREATE TABLE [RDS].[DimK12ProgramTypes] (
        [DimK12ProgramTypeId]    INT            IDENTITY (1, 1) NOT NULL,
        [ProgramTypeCode]        NVARCHAR (50)   NOT NULL,
        [ProgramTypeDescription] NVARCHAR (60)  NULL,
        [ProgramTypeDefinition]  NVARCHAR (MAX) NULL,
        CONSTRAINT [PK_DimK12ProgramTypes] PRIMARY KEY CLUSTERED ([DimK12ProgramTypeId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );


    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimOrganizationCalendarSessions')
    CREATE TABLE [RDS].[DimOrganizationCalendarSessions] (
        [DimOrganizationCalendarSessionId]  INT            NOT NULL IDENTITY,
        [BeginDate]                         DATETIME       NULL,
        [EndDate]                           DATETIME       NULL,
        [SessionCode]                       NVARCHAR (30)  NULL,
        [SessionDescription]                NVARCHAR (MAX) NULL,
        [AcademicTermDesignatorCode]        NVARCHAR (30)  NULL,
        [AcademicTermDesignatorDescription] NVARCHAR (MAX) NULL,
        CONSTRAINT [PK_DimOrganizationCalendarSessions] PRIMARY KEY CLUSTERED ([DimOrganizationCalendarSessionId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimProgramTypes')
    CREATE TABLE [RDS].[DimProgramTypes] (
        [DimProgramTypeId]                             INT            IDENTITY (1, 1) NOT NULL,
        [ProgramTypeCode]                              NVARCHAR (50)  NULL,
        [ProgramTypeDescription]                       NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimProgramType] PRIMARY KEY CLUSTERED ([DimProgramTypeId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimNOrDProgramStatuses')
    CREATE TABLE [RDS].[DimNOrDProgramStatuses] (
    [DimNOrDProgramStatusId]                      INT            IDENTITY (1, 1) NOT NULL,
    [LongTermStatusCode]                          NVARCHAR (50)  NULL,
    [LongTermStatusDescription]                   NVARCHAR (100) NULL,
    [LongTermStatusEdFactsCode]                   NVARCHAR (50)  NULL,
    [NeglectedOrDelinquentProgramTypeCode]        NVARCHAR (50)  NULL,
    [NeglectedOrDelinquentProgramTypeDescription] NVARCHAR (100) NULL,
    [NeglectedOrDelinquentProgramTypeEdFactsCode] NVARCHAR (50)  NULL,
    CONSTRAINT [PK_DimNOrDProgramStatuses] PRIMARY KEY CLUSTERED ([DimNOrDProgramStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );


    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsAcademicAwardStatuses')
    CREATE TABLE [RDS].[DimPsAcademicAwardStatuses] (
        [DimPsAcademicAwardStatusId]                            INT            IDENTITY (1, 1) NOT NULL,
        [PescAwardLevelTypeCode]                                NVARCHAR (50)  NULL,
        [PescAwardLevelTypeDescription]                         NVARCHAR (200) NULL,
        [ProfessionalOrTechnicalCredentialConferredCode]        NVARCHAR (50)  NULL,
        [ProfessionalOrTechnicalCredentialConferredDescription] NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimPsAcademicAwardStatuses] PRIMARY KEY CLUSTERED ([DimPsAcademicAwardStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsCitizenshipStatuses')
    CREATE TABLE [RDS].[DimPsCitizenshipStatuses] (
        [DimPsCitizenshipStatusId]                   BIGINT         IDENTITY (1, 1) NOT NULL,
        [UnitedStatesCitizenshipStatusCode]          NVARCHAR (50)  NULL,
        [UnitedStatesCitizenshipStatusDescription]   NVARCHAR (200) NULL,
        [VisaTypeCode]                               NVARCHAR (50)  NULL,
        [VisaTypeDescription]                        NVARCHAR (200) NULL,
        [MilitaryActiveStudentIndicatorCode]         NVARCHAR (50)  NULL,
        [MilitaryActiveStudentIndicatorDescription]  NVARCHAR (200) NULL,
        [MilitaryBranchCode]                         NVARCHAR (50)  NULL,
        [MilitaryBranchDescription]                  NVARCHAR (200) NULL,
        [MilitaryVeteranStudentIndicatorCode]        NVARCHAR (50)  NULL,
        [MilitaryVeteranStudentIndicatorDescription] NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimPsCitizenshipStatuses] PRIMARY KEY CLUSTERED ([DimPsCitizenshipStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsCourseStatuses')
    CREATE TABLE [RDS].[DimPsCourseStatuses] (
        [DimPsCourseStatusId]              INT            NOT NULL,
        [CourseLevelTypeCode]              NVARCHAR (50)  NULL,
        [CourseLevelTypeDescription]       NVARCHAR (200) NULL,
        [CourseHonorsTypeCode]             NVARCHAR (50)  NULL,
        [CourseHonorsTypeDescription]      NVARCHAR (200) NULL,
        [CourseCreditBasisTypeCode]        NVARCHAR (50)  NULL,
        [CourseCreditBasisTypeDescription] NVARCHAR (200) NULL,
        [CourseCreditLevelTypeCode]        NVARCHAR (50)  NULL,
        [CourseCreditLevelTypeDescription] NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimPsCourse] PRIMARY KEY CLUSTERED ([DimPsCourseStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsEnrollmentStatuses')
    CREATE TABLE [RDS].[DimPsEnrollmentStatuses] (
        [DimPsEnrollmentStatusId]                               BIGINT         IDENTITY(1, 1) NOT NULL,
        [PostsecondaryExitOrWithdrawalTypeCode]                 NVARCHAR (50)  NULL,
        [PostsecondaryExitOrWithdrawalTypeDescription]          NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimPsEnrollmentStatuses] PRIMARY KEY CLUSTERED ([DimPsEnrollmentStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsFamilyStatuses')
    CREATE TABLE [RDS].[DimPsFamilyStatuses] (
        [DimPsFamilyStatusId]                     BIGINT         IDENTITY (1, 1) NOT NULL,
        [DependencyStatusCode]                    NVARCHAR (50)  NULL,
        [DependencyStatusDescription]             NVARCHAR (200) NULL,
        [NumberOfDependentsCode]                  NVARCHAR (50)  NULL,
        [NumberOfDependentsDescription]           NVARCHAR (200) NULL,
        [SingleParentOrSinglePregnantWomanStatus] BIT            NULL,
        [MaternalGuardianEducationCode]           NVARCHAR (50)  NULL,
        [MaternalGuardianEducationDescription]    NVARCHAR (200) NULL,
        [PaternalGuardianEducationCode]           NVARCHAR (50)  NULL,
        [PaternalGuardianEducationDescription]    NVARCHAR (200) NULL,
        CONSTRAINT [PK_DimPsFamilyStatuses] PRIMARY KEY CLUSTERED ([DimPsFamilyStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsInstitutions')
    CREATE TABLE [RDS].[DimPsInstitutions] (
        [DimPsInstitutionID]                  INT            IDENTITY (1, 1) NOT NULL,
        [NameOfInstitution]                   NVARCHAR (128)  NOT NULL,
        [ShortNameOfInstitution]              NVARCHAR (30)  NOT NULL,
        [InstitutionIpedsUnitId]              INT            NOT NULL,
        [OrganizationOperationalStatus]       NVARCHAR (20)  NOT NULL,
        [OperationalStatusEffectiveDate]      DATETIME       NOT NULL,
	    [MostPrevalentLevelOfInstitutionCode]	  NVARCHAR (20)  NULL,
        [MailingAddressStreetNameAndNumber]   NVARCHAR (40)  NULL,
        [MailingAddressApartmentRoomOrSuite]  NVARCHAR (30)  NULL,
        [MailingAddressCity]                  NVARCHAR (30)  NULL,
        [MailingAddressPostalCode]            NVARCHAR (17)  NULL,
        [MailingAddressState]                 NVARCHAR (50)  NULL,
        [PhysicalAddressStreetNameAndNumber]  NVARCHAR (40)  NULL,
        [PhysicalAddressApartmentRoomOrSuite] NVARCHAR (30)  NULL,
        [PhysicalAddressCity]                 NVARCHAR (30)  NULL,
        [PhysicalAddressPostalCode]           NVARCHAR (17)  NULL,
        [PhysicalAddressState]                NVARCHAR (50)  NULL,
        [Telephone]                           NVARCHAR (24)  NULL,
        [Website]                             NVARCHAR (300) NULL,
        [Latitude]                            NVARCHAR (20)  NULL,
        [Longitude]                           NVARCHAR (20)  NULL,
        [RecordStartDateTime]                 DATETIME       NOT NULL,
        [RecordEndDateTime]                   DATETIME       NULL,
        CONSTRAINT [PK_DimPsInstitutions] PRIMARY KEY CLUSTERED ([DimPsInstitutionID] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsInstitutionStatuses')
    CREATE TABLE [RDS].[DimPsInstitutionStatuses] (
        [DimPsInstitutionStatusId]                     INT            NOT NULL IDENTITY,
        [LevelOfInstitututionCode]                     NVARCHAR (50)  NOT NULL,
        [LevelOfInstitututionDescription]              NVARCHAR (200) NOT NULL,
        [ControlOfInstitutionCode]                     NVARCHAR (50)  NOT NULL,
        [ControlOfInstitutionDescription]              NVARCHAR (200) NOT NULL,
        [VirtualIndicator]                             NVARCHAR (50)  NOT NULL,
        [CarnegieBasicClassificationCode]              NVARCHAR (50)  NOT NULL,
        [CarnegieBasicClassificationDescription]       NVARCHAR (200) NOT NULL,
        [MostPrevalentLevelOfInstitutionCode]          NVARCHAR (50)  NOT NULL,
        [MostPrevalentLevelOfInstitutionDescription]   NVARCHAR (200) NOT NULL,
        [PerdominentCalendarSystemCode]                NVARCHAR (50)  NOT NULL,
        [PerdominentCalendarSystemDescription]         NVARCHAR (200) NOT NULL,
        CONSTRAINT [PK_DimPsInstitutionStatuses] PRIMARY KEY CLUSTERED ([DimPsInstitutionStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimPsStudents')
    CREATE TABLE [RDS].[DimPsStudents] (
        [DimPsStudentId]         INT            IDENTITY (1, 1) NOT NULL,
        [FirstName]              NVARCHAR (50)  NULL,
        [MiddleName]             NVARCHAR (50)  NULL,
        [LastName]               NVARCHAR (50)  NULL,
        [BirthDate]              DATETIME2 (7)  NULL,
        [SexCode]                NVARCHAR (50)  NULL,
        [SexDescription]         NVARCHAR (200) NULL,
        [StudentIdentifierState] NVARCHAR (50)  NULL,
        [RecordStartDateTime]    DATETIME       NOT NULL,
        [RecordEndDateTime]      DATETIME       NULL,
        CONSTRAINT [PK_DimPsStudent] PRIMARY KEY CLUSTERED ([DimPsStudentId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimScedCodes')
    CREATE TABLE [RDS].[DimScedCodes] (
        [DimScedCodeId]                    INT             IDENTITY (1, 1) NOT NULL,
        [ScedCourseCode]                   NCHAR (5)       NOT NULL,
        [ScedCourseTitle]                  NVARCHAR (50)   NOT NULL,
        [ScedCourseDescription]            NVARCHAR (2000) NOT NULL,
        [ScedCourseLevelCode]              NVARCHAR (50)   NOT NULL,
        [ScedCourseLevelDescription]       NVARCHAR (200)  NOT NULL,
        [ScedCourseSubjectAreaCode]        NVARCHAR (50)   NOT NULL,
        [ScedCourseSubjectAreaDescription] NVARCHAR (200)  NOT NULL,
        [ScedGradeSpan]                    NCHAR (4)       NOT NULL,
        [ScedSequenceOfCourse]             NCHAR (10)      NOT NULL,
        CONSTRAINT [PK_DimScedCodes] PRIMARY KEY CLUSTERED ([DimScedCodeId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimSchoolYears')
    CREATE TABLE [RDS].[DimSchoolYears] (
        [DimSchoolYearId]  INT          IDENTITY (1, 1) NOT NULL,
        [SchoolYear]       SMALLINT NOT NULL,
        [SessionBeginDate] DATETIME     NOT NULL,
        [SessionEndDate]   DATETIME     NOT NULL,
        CONSTRAINT [PK_DimSchoolYears] PRIMARY KEY CLUSTERED ([DimSchoolYearId] ASC) WITH (DATA_COMPRESSION = PAGE)
    );

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'RDS' and TABLE_NAME = N'DimSchoolYearDataMigrationTypes')
    CREATE TABLE [RDS].[DimSchoolYearDataMigrationTypes] (
        [DimSchoolYearId]     INT NOT NULL,
        [DataMigrationTypeId] INT NOT NULL,
        [IsSelected]          BIT NULL,
        CONSTRAINT [PK_DimSchoolYear_DimSchoolYearMigrationTypes] PRIMARY KEY CLUSTERED ([DimSchoolYearId] ASC, [DataMigrationTypeId] ASC) WITH (DATA_COMPRESSION = PAGE),
        CONSTRAINT [FK_DimSchoolYear_DataMigrationTypes_DimSchoolYear_DimSchoolYearId] FOREIGN KEY ([DimSchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]) ON DELETE CASCADE,
        CONSTRAINT [FK_DimSchoolYear_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId] FOREIGN KEY ([DataMigrationTypeId]) REFERENCES [RDS].[DimDataMigrationTypes] ([DimDataMigrationTypeId]) ON DELETE CASCADE
    );

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IeuName'  AND Object_ID = Object_ID(N'RDS.DimK12Schools'))
    BEGIN
        ALTER TABLE RDS.DimK12Schools ADD IeuName NVARCHAR (1000) NULL, IeuIdentifierState NVARCHAR (50) NULL, 
        LeaOrganizationId INT NULL, SeaOrganizationId INT NULL, SchoolOrganizationId INT NULL,
        MailingCountyAnsiCode CHAR(5) NULL, PhysicalCountyAnsiCode CHAR(5) NULL, Longitude VARCHAR(20) NULL, Latitude VARCHAR(20) NULL,
        SchoolOperationalStatusEffectiveDate  DATETIME  NULL, AdministrativeFundingControlCode NVARCHAR (50)   NULL,
        AdministrativeFundingControlDescription  NVARCHAR (200)  NULL
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'IeuName'  AND Object_ID = Object_ID(N'RDS.DimLeas'))
    BEGIN
        ALTER TABLE RDS.DimLeas ADD McKinneyVentoSubgrantRecipient NVARCHAR(50) NULL, IeuName NVARCHAR (1000) NULL, IeuStateIdentifier NVARCHAR (50) NULL, 
        LeaOrganizationId INT NULL, NameOfInstitution [nvarchar](1000) NULL, SchoolOrganizationId INT NULL, SeaOrganizationId INT NULL, 
        MailingCountyAnsiCode CHAR(5) NULL, PhysicalCountyAnsiCode CHAR(5) NULL, Longitude VARCHAR(20) NULL, Latitude VARCHAR(20) NULL,
        EffectiveDate  DATETIME  NULL
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'SeaOrganizationId'  AND Object_ID = Object_ID(N'RDS.DimSeas'))
    ALTER TABLE RDS.DimSeas ADD SeaOrganizationId INT NULL, MailingCountyAnsiCode CHAR(5) NULL, PhysicalCountyAnsiCode CHAR(5) NULL

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_BridgeLeaGradeLevels' AND OBJECT_NAME(id) = 'BridgeLeaGradeLevels')
    ALTER TABLE [RDS].[BridgeLeaGradeLevels] ADD  CONSTRAINT [PK_BridgeLeaGradeLevels] PRIMARY KEY CLUSTERED 
    (
	    [LeaId] ASC,
	    [GradeLevelId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_BridgeK12SchoolGradeLevels' AND OBJECT_NAME(id) = 'BridgeK12SchoolGradeLevels')
    ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] ADD  CONSTRAINT [PK_BridgeK12SchoolGradeLevels] PRIMARY KEY CLUSTERED 
    (
	    [K12SchoolId] ASC,
	    [GradeLevelId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimFirearmDisciplineId' AND OBJECT_NAME(id) = 'DimFirearmDisciplines')
    ALTER TABLE [RDS].[DimFirearmDisciplines] ADD  CONSTRAINT [PK_DimFirearmDisciplineId] PRIMARY KEY CLUSTERED 
    (
	    [DimFirearmDisciplineId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12OrganizationStatus' AND OBJECT_NAME(id) = 'DimK12OrganizationStatuses')
    ALTER TABLE [RDS].[DimK12OrganizationStatuses] ADD  CONSTRAINT [PK_DimK12OrganizationStatus] PRIMARY KEY CLUSTERED 
    (
	    [DimK12OrganizationStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12Schools' AND OBJECT_NAME(id) = 'DimK12Schools')
    ALTER TABLE [RDS].[DimK12Schools] ADD  CONSTRAINT [PK_DimK12Schools] PRIMARY KEY CLUSTERED 
    (
	    [DimK12SchoolId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12SchoolStateStatus' AND OBJECT_NAME(id) = 'DimK12SchoolStateStatuses')
    ALTER TABLE [RDS].[DimK12SchoolStateStatuses] ADD  CONSTRAINT [PK_DimK12SchoolStateStatus] PRIMARY KEY CLUSTERED 
    (
	    [DimK12SchoolStateStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimSchoolStatuses' AND OBJECT_NAME(id) = 'DimK12SchoolStatuses')
    ALTER TABLE [RDS].[DimK12SchoolStatuses] ADD  CONSTRAINT [PK_DimSchoolStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimK12SchoolStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12Staff' AND OBJECT_NAME(id) = 'DimK12Staff')
    ALTER TABLE [RDS].[DimK12Staff] ADD  CONSTRAINT [PK_DimK12Staff] PRIMARY KEY CLUSTERED 
    (
	    [DimK12StaffId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12StaffCategories' AND OBJECT_NAME(id) = 'DimK12StaffCategories')
    ALTER TABLE [RDS].[DimK12StaffCategories] ADD  CONSTRAINT [PK_DimK12StaffCategories] PRIMARY KEY CLUSTERED 
    (
	    [DimK12StaffCategoryId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12StaffStatuses' AND OBJECT_NAME(id) = 'DimK12StaffStatuses')
    ALTER TABLE [RDS].[DimK12StaffStatuses] ADD  CONSTRAINT [PK_DimK12StaffStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimK12StaffStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12Students' AND OBJECT_NAME(id) = 'DimK12Students')
    ALTER TABLE [RDS].[DimK12Students] ADD  CONSTRAINT [PK_DimK12Students] PRIMARY KEY CLUSTERED 
    (
	    [DimK12StudentId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimNOrDProgramStatuses' AND OBJECT_NAME(id) = 'DimNOrDProgramStatuses')
    ALTER TABLE [RDS].[DimNOrDProgramStatuses] ADD  CONSTRAINT [PK_DimNOrDProgramStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimNOrDProgramStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimTitleIIIStatuses' AND OBJECT_NAME(id) = 'DimTitleIIIStatuses')
    ALTER TABLE [RDS].[DimTitleIIIStatuses] ADD  CONSTRAINT [PK_DimTitleIIIStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimTitleIIIStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

    IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimTitleIStatuses' AND OBJECT_NAME(id) = 'DimTitleIStatuses')
    ALTER TABLE [RDS].[DimTitleIStatuses] ADD  CONSTRAINT [PK_DimTitleIStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimTitleIStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

     IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimLeas' AND OBJECT_NAME(id) = 'DimLeas')
    ALTER TABLE [RDS].[DimLeas] ADD  CONSTRAINT [PK_DimLeas] PRIMARY KEY CLUSTERED 
    (
	    [DimLeaId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

     IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'PK_DimK12StudentStatuses' AND OBJECT_NAME(id) = 'DimK12StudentStatuses')
    ALTER TABLE [RDS].[DimK12StudentStatuses] ADD  CONSTRAINT [PK_DimK12StudentStatuses] PRIMARY KEY CLUSTERED 
    (
	    [DimK12StudentStatusId] ASC
    )WITH (DATA_COMPRESSION = PAGE)

	 

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimAcademicTermDesignators_AcademicTermDesignatorCode')
        CREATE NONCLUSTERED INDEX [IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]
        ON [RDS].[DimAcademicTermDesignators]([AcademicTermDesignatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimAssessmentStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimAssessmentStatuses_Codes]
        ON [RDS].[DimAssessmentStatuses]([AssessedFirstTimeCode] ASC, [AssessmentProgressLevelCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimCipCodes_CipCode')
        CREATE NONCLUSTERED INDEX [IX_DimCipCodes_CipCode]
        ON [RDS].[DimCipCodes]([CipCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimCohortStatuses_CohortStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimCohortStatuses_CohortStatusCode]
        ON [RDS].[DimCohortStatuses]([CohortStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimCredentials_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimCredentials_Codes]
        ON [RDS].[DimCredentials]([CredentialCategorySystem] ASC, [CredentialCategoryType] ASC, [CredentialStatusTypeCode] ASC, [CredentialIntendedPurposeTypeCode] ASC, [CredentialAssessmentMethodTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimCredentials_CredentialTitle')
        CREATE NONCLUSTERED INDEX [IX_DimCredentials_CredentialTitle]
        ON [RDS].[DimCredentials]([CredentialTitle] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDataCollections_DataCollectionName')
        CREATE NONCLUSTERED INDEX [IX_DimDataCollections_DataCollectionName]
        ON [RDS].[DimDataCollections]([DataCollectionName] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDateDataMigrationTypes_DimDateId')
        CREATE NONCLUSTERED INDEX [IX_DimDateDataMigrationTypes_DimDateId]
        ON [RDS].[DimDateDataMigrationTypes]([DimDateId] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_DisciplineActionEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_DisciplineActionEdFactsCode]
        ON [RDS].[DimDisciplines]([DisciplinaryActionTakenEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_DisciplineMethodEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_DisciplineMethodEdFactsCode]
        ON [RDS].[DimDisciplines]([DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_EducationalServicesEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_EducationalServicesEdFactsCode]
        ON [RDS].[DimDisciplines]([EducationalServicesAfterRemovalEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_RemovalReasonEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_RemovalReasonEdFactsCode]
        ON [RDS].[DimDisciplines]([IdeaInterimRemovalReasonEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_RemovalTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_RemovalTypeEdFactsCode]
        ON [RDS].[DimDisciplines]([IdeaInterimRemovalEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimDisciplines_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimDisciplines_Codes]
        ON [RDS].[DimDisciplines]([DisciplinaryActionTakenCode] ASC, [DisciplineMethodOfChildrenWithDisabilitiesCode] ASC, [EducationalServicesAfterRemovalCode] ASC, [IdeaInterimRemovalReasonCode] ASC, [IdeaInterimRemovalCode] ASC, [DisciplineELStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimEnrollments_Codes')
        --CREATE NONCLUSTERED INDEX [IX_DimEnrollments_Codes]
        --ON [RDS].[DimEnrollments]([PostsecondaryEnrollmentStatusCode] ASC, [AcademicOrVocationalOutcomeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimEnrollments_PostsecondaryEnrollmentStatusEdFactsCode')
        --CREATE NONCLUSTERED INDEX [IX_DimEnrollments_PostsecondaryEnrollmentStatusEdFactsCode]
        --ON [RDS].[DimEnrollments]([PostsecondaryEnrollmentStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimEnrollments_AcademicOrVocationalOutcomeEdFactsCodes')
        --CREATE NONCLUSTERED INDEX [IX_DimEnrollments_AcademicOrVocationalOutcomeEdFactsCodes]
        --ON [RDS].[DimEnrollments]([AcademicOrVocationalOutcomeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimFirearms_FirearmTypeCode')
        CREATE NONCLUSTERED INDEX [IX_DimFirearms_FirearmTypeCode]
        ON [RDS].[DimFirearms]([FirearmTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimFirearms_FirearmTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimFirearms_FirearmTypeEdFactsCode]
        ON [RDS].[DimFirearms]([FirearmTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimFirearmDisciplines_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimFirearmDisciplines_Codes]
        ON [RDS].[DimFirearmDisciplines]([DisciplineMethodForFirearmsIncidentsCode] ASC, [IdeaDisciplineMethodForFirearmsIncidentsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimFirearmDisciplines_DisciplineMethodForFirearmsIncidentsEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimFirearmDisciplines_DisciplineMethodForFirearmsIncidentsEdFactsCode]
        ON [RDS].[DimFirearmDisciplines]([DisciplineMethodForFirearmsIncidentsEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimFirearmDisciplines_IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimFirearmDisciplines_IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode]
        ON [RDS].[DimFirearmDisciplines]([IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_BasisOfExitEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_BasisOfExitEdFactsCode]
        ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_DisabilityEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_DisabilityEdFactsCode]
        ON [RDS].[DimIdeaStatuses]([PrimaryDisabilityTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_EducEnvEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_EducEnvEdFactsCode]
        ON [RDS].[DimIdeaStatuses]([IdeaEducationalEnvironmentEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIdeaStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_Codes]
        ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonCode] ASC, [PrimaryDisabilityTypeCode] ASC, [IdeaEducationalEnvironmentCode] ASC, [IdeaIndicatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIeus_IeuIdentifierState')
        CREATE NONCLUSTERED INDEX [IX_DimIeus_IeuIdentifierState]
        ON [RDS].[DimIeus]([IeuIdentifierState] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIndicatorStatuses_IndicatorStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatuses_IndicatorStatusCode]
        ON [RDS].[DimIndicatorStatuses]([IndicatorStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatuses_IndicatorStatusEdFactsCode]
        ON [RDS].[DimIndicatorStatuses]([IndicatorStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode')
        CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeCode]
        ON [RDS].[DimIndicatorStatusTypes]([IndicatorStatusTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimIndicatorStatusTypes_IndicatorStatusTypeEdFactsCode]
        ON [RDS].[DimIndicatorStatusTypes]([IndicatorStatusTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Courses_CourseIdentifer')
        CREATE NONCLUSTERED INDEX [IX_DimK12Courses_CourseIdentifer]
        ON [RDS].[DimK12Courses]([CourseIdentifier] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Courses_CourseTitle')
        CREATE NONCLUSTERED INDEX [IX_DimK12Courses_CourseTitle]
        ON [RDS].[DimK12Courses]([CourseTitle] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12CourseStatuses_CourseLevelCharacteristicCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12CourseStatuses_CourseLevelCharacteristicCode]
        ON [RDS].[DimK12CourseStatuses]([CourseLevelCharacteristicCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_Codes]
        ON [RDS].[DimK12Demographics]([EconomicDisadvantageStatusCode] ASC, [HomelessnessStatusCode] ASC, [EnglishLearnerStatusCode] ASC, [MigrantStatusCode] ASC, [MilitaryConnectedStudentIndicatorCode] ASC, [HomelessPrimaryNighttimeResidenceCode] ASC, [HomelessUnaccompaniedYouthStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_EconomicDisadvantageStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_EconomicDisadvantageStatusEdFactsCode]
        ON [RDS].[DimK12Demographics]([EconomicDisadvantageStatusEdFactsCode] ASC, [HomelessnessStatusEdFactsCode] ASC, [EnglishLearnerStatusEdFactsCode] ASC, [MigrantStatusEdFactsCode] ASC, [MilitaryConnectedStudentIndicatorEdFactsCode] ASC, [HomelessPrimaryNighttimeResidenceEdFactsCode] ASC, [HomelessUnaccompaniedYouthStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_HomelessnessStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_HomelessnessStatusEdFactsCode]
        ON [RDS].[DimK12Demographics]([HomelessnessStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_EnglishLearnerStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_EnglishLearnerStatusEdFactsCode]
        ON [RDS].[DimK12Demographics]([EnglishLearnerStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_MigrantStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_MigrantStatusEdFactsCode]
        ON [RDS].[DimK12Demographics]([MigrantStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_MilitaryConnectedStudentIndicatorEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_MilitaryConnectedStudentIndicatorEdFactsCode]
        ON [RDS].[DimK12Demographics]([MilitaryConnectedStudentIndicatorEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_HomelessPrimaryNighttimeResidenceEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_HomelessPrimaryNighttimeResidenceEdFactsCode]
        ON [RDS].[DimK12Demographics]([HomelessPrimaryNighttimeResidenceEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Demographics_HomelessUnaccompaniedYouthStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_HomelessUnaccompaniedYouthStatusEdFactsCode]
        ON [RDS].[DimK12Demographics]([HomelessUnaccompaniedYouthStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12EnrollmentStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimK12EnrollmentStatuses_Codes]
        ON [RDS].[DimK12EnrollmentStatuses] ([EnrollmentStatusCode] ASC,[EntryTypeCode] ASC,[ExitOrWithdrawalTypeCode] ASC, [PostSecondaryEnrollmentStatusCode] ASC)

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode]
        ON [RDS].[DimK12EnrollmentStatuses] ([PostSecondaryEnrollmentStatusEdFactsCode] ASC)

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12OrganizationStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_Codes]
        ON [RDS].[DimK12OrganizationStatuses] ([ReapAlternativeFundingStatusCode] ASC, [GunFreeSchoolsActReportingStatusCode] ASC, [HighSchoolGraduationRateIndicatorStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_ReapAlternativeFundingStatusEdFactsCode]
        ON [RDS].[DimK12OrganizationStatuses] ([ReapAlternativeFundingStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_GunFreeSchoolsActReportingStatusEdFactsCode]
        ON [RDS].[DimK12OrganizationStatuses] ([GunFreeSchoolsActReportingStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12OrganizationStatuses_HighSchoolGraduationRateIndicatorStatusEdFactsCode]
        ON [RDS].[DimK12OrganizationStatuses] ([HighSchoolGraduationRateIndicatorStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12ProgramTypes_ProgramTypeCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12ProgramTypes_ProgramTypeCode]
        ON [RDS].[DimK12ProgramTypes] ([ProgramTypeCode] ASC)

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Schools_SchoolIdentifierState')
        CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierState] ON [RDS].[DimK12Schools] ([SchoolIdentifierState])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Schools_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimK12Schools_RecordStartDateTime]
        ON [RDS].[DimK12Schools] ([RecordStartDateTime])
        INCLUDE ([SchoolIdentifierState],[RecordEndDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime]
        ON [RDS].[DimK12Schools] ([SchoolIdentifierState],[RecordStartDateTime])
        INCLUDE ([RecordEndDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStateStatuses_SchoolStateStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStateStatuses_SchoolStateStatusCode] 
        ON [RDS].[DimK12SchoolStateStatuses] ([SchoolStateStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_Codes] 
        -- ON [RDS].[DimK12SchoolStatuses] ([MagnetOrSpecialProgramEmphasisSchoolCode] ASC, [NslpStatusCode] ASC, [SharedTimeIndicatorCode] ASC, [VirtualSchoolStatusCode] ASC, [SchoolImprovementStatusCode] ASC, [PersistentlyDangerousStatusCode] ASC, [StatePovertyDesignationCode] ASC, [ProgressAchievingEnglishLanguageCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([MagnetOrSpecialProgramEmphasisSchoolEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_NslpStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_NslpStatusEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([NslpStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([SharedTimeIndicatorEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([VirtualSchoolStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_[SchoolImprovementStatusEdFactsCode] 
        -- ON [RDS].[DimK12SchoolStatuses] ([SchoolImprovementStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_PersistentlyDangerousStatusEdFactsCode] 
        -- ON [RDS].[DimK12SchoolStatuses] ([PersistentlyDangerousStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([StatePovertyDesignationEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageEdFactsCode] 
        ON [RDS].[DimK12SchoolStatuses] ([ProgressAchievingEnglishLanguageEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Staff_StaffMemberIdentifierState')
        CREATE NONCLUSTERED INDEX [IX_DimK12Staff_StaffMemberIdentifierState]
        ON [RDS].[DimK12Staff]([StaffMemberIdentifierState] ASC)
        INCLUDE([DimK12StaffId]) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Staff_K12StaffRole')
        CREATE NONCLUSTERED INDEX [IX_DimK12Staff_K12StaffRole]
        ON [RDS].[DimK12Staff]([K12StaffRole] ASC)
        INCLUDE([DimK12StaffId]) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffCategories_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_Codes]
        ON [RDS].[DimK12StaffCategories]([K12StaffClassificationCode] ASC, [SpecialEducationSupportServicesCategoryCode] ASC, [TitleIProgramStaffCategoryCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_K12StaffClassificationEdFactsCode]
        ON [RDS].[DimK12StaffCategories]([K12StaffClassificationEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_SpecialEducationSupportServicesCategoryEdFactsCode]
        ON [RDS].[DimK12StaffCategories]([SpecialEducationSupportServicesCategoryEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffCategories_TitleIProgramStaffCategoryEdFactsCode]
        ON [RDS].[DimK12StaffCategories]([TitleIProgramStaffCategoryEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_Codes]
        ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtCode] ASC, [CertificationStatusCode] ASC, [K12StaffClassificationCode] ASC, [QualificationStatusCode] ASC, [UnexperiencedStatusCode] ASC, [EmergencyOrProvisionalCredentialStatusCode] ASC, [OutOfFieldStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]
        ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_CertificationStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_CertificationStatusCode]
        ON [RDS].[DimK12StaffStatuses]([CertificationStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_K12StaffClassificationCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_K12StaffClassificationCode]
        ON [RDS].[DimK12StaffStatuses]([K12StaffClassificationCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_QualificationStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_QualificationStatusCode]
        ON [RDS].[DimK12StaffStatuses]([QualificationStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_UnexperiencedStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_UnexperiencedStatusCode]
        ON [RDS].[DimK12StaffStatuses]([UnexperiencedStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode]
        ON [RDS].[DimK12StaffStatuses]([EmergencyOrProvisionalCredentialStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12StaffStatuses_OutOfFieldStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_OutOfFieldStatusEdFactsCode]
        ON [RDS].[DimK12StaffStatuses]([OutOfFieldStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Students_RecordEndDateTime_DimK12StudentId')
        CREATE NONCLUSTERED INDEX [IX_DimK12Students_RecordEndDateTime_DimK12StudentId]
        ON [RDS].[DimK12Students] ([RecordEndDateTime],[DimK12StudentId])
        INCLUDE ([BirthDate],[FirstName],[LastName],[MiddleName],[StateStudentIdentifier],[SexCode],[RecordStartDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Students_RecordEndDateTime_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimK12Students_RecordEndDateTime_RecordStartDateTime]
        ON [RDS].[DimK12Students] ([RecordEndDateTime],[RecordStartDateTime])
        INCLUDE ([BirthDate],[FirstName],[LastName],[MiddleName],[StateStudentIdentifier],[SexCode])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimLanguages_LanguageEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimLanguages_LanguageEdFactsCode]
        ON [RDS].[DimLanguages]([IsoSO6392LanguageCodeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimLanguages_LanguageCode')
        CREATE NONCLUSTERED INDEX [IX_DimLanguages_LanguageCode]
        ON [RDS].[DimLanguages]([Iso6392LanguageCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimLeas_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimLeas_RecordStartDateTime]
        ON [RDS].[DimLeas] ([RecordStartDateTime])
        INCLUDE ([LeaIdentifierState],[RecordEndDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimLeas_LeaIdentifierState_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimLeas_LeaIdentifierState_RecordStartDateTime]
        ON [RDS].[DimLeas] ([LeaIdentifierState],[RecordStartDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_ContinuationEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_ContinuationEdFactsCode]
        ON [RDS].[DimMigrants]([ContinuationOfServicesReasonEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepFundsStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_MepFundsStatusEdFactsCode]
        ON [RDS].[DimMigrants]([ConsolidatedMepFundsStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepServicesEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_MepServicesEdFactsCode]
        ON [RDS].[DimMigrants]([MepServicesTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MigrantPriorityForServicesEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_MigrantPriorityForServicesEdFactsCode]
        ON [RDS].[DimMigrants]([MigrantPrioritizedForServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_MepEnrollmentTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_MepEnrollmentTypeEdFactsCode]
        ON [RDS].[DimMigrants]([MepEnrollmentTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimMigrants_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimMigrants_Codes]
        ON [RDS].[DimMigrants]([ContinuationOfServicesReasonCode] ASC, [ConsolidatedMepFundsStatusCode] ASC, [MepServicesTypeCode] ASC, [MigrantPrioritizedForServicesCode] ASC, [MepEnrollmentTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_Codes]
        ON [RDS].[DimNOrDProgramStatuses]([LongTermStatusCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_LongTermStatusEdFactsCodes')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_LongTermStatusEdFactsCodes]
        ON [RDS].[DimNOrDProgramStatuses]([LongTermStatusEdFactsCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]
        ON [RDS].[DimNOrDProgramStatuses]([NeglectedOrDelinquentProgramTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_Codes]
        ON [RDS].[DimProgramStatuses]([EligibilityStatusForSchoolFoodServiceProgramCode] ASC, [FosterCareProgramCode] ASC, [TitleIIIImmigrantParticipationStatusCode] ASC, [Section504StatusCode] ASC, [TitleiiiProgramParticipationCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        --IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_CteProgramEdFactsCode')
        --CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_CteProgramEdFactsCode]
        --ON [RDS].[DimProgramStatuses]([CteProgramEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_FoodServiceEligibilityEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_FoodServiceEligibilityEdFactsCode]
        ON [RDS].[DimProgramStatuses]([EligibilityStatusForSchoolFoodServiceProgramEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_FosterCareProgramEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_FosterCareProgramEdFactsCode]
        ON [RDS].[DimProgramStatuses]([FosterCareProgramEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_ImmigrantTitleIIIProgramEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_ImmigrantTitleIIIProgramEdFactsCode]
        ON [RDS].[DimProgramStatuses]([TitleIIIImmigrantParticipationStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_Section504ProgramEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_Section504ProgramEdFactsCode]
        ON [RDS].[DimProgramStatuses]([Section504StatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramStatuses_TitleiiiProgramParticipationEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramStatuses_TitleiiiProgramParticipationEdFactsCode]
        ON [RDS].[DimProgramStatuses]([TitleiiiProgramParticipationEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimProgramTypes_ProgramTypeCode')
        CREATE NONCLUSTERED INDEX [IX_DimProgramTypes_ProgramTypeCode]
        ON [RDS].[DimProgramTypes]([ProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsAcademicAwardStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsAcademicAwardStatuses_Codes]
        ON [RDS].[DimPsAcademicAwardStatuses]([PescAwardLevelTypeCode] ASC, [ProfessionalOrTechnicalCredentialConferredCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsCitizenshipStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsCitizenshipStatuses_Codes]
        ON [RDS].[DimPsCitizenshipStatuses]([UnitedStatesCitizenshipStatusCode] ASC, [VisaTypeCode] ASC, [MilitaryActiveStudentIndicatorCode] ASC, [MilitaryBranchCode] ASC, [MilitaryVeteranStudentIndicatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsCourseStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsCourseStatuses_Codes]
        ON [RDS].[DimPsCourseStatuses]([CourseLevelTypeCode] ASC, [CourseHonorsTypeCode] ASC, [CourseCreditBasisTypeCode] ASC, [CourseCreditLevelTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsEnrollmentStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsEnrollmentStatuses_Codes]
        ON [RDS].[DimPsEnrollmentStatuses]([PostsecondaryExitOrWithdrawalTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsFamilyStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsFamilyStatuses_Codes]
        ON [RDS].[DimPsFamilyStatuses]([DependencyStatusCode] ASC, [NumberOfDependentsCode] ASC, [MaternalGuardianEducationCode] ASC, [PaternalGuardianEducationCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsInstitutions_InstitutionIpedsUnitId')
        CREATE NONCLUSTERED INDEX [IX_DimPsInstitutions_InstitutionIpedsUnitId]
        ON [RDS].[DimPsInstitutions](InstitutionIpedsUnitId ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsInstitution_IpedsUnitId_RecordStartDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimPsInstitution_IpedsUnitId_RecordStartDateTime]
        ON [RDS].[DimPsInstitutions] ([InstitutionIpedsUnitId],[RecordStartDateTime])
        INCLUDE ([RecordEndDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsInstitutionStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_Codes]
        ON [RDS].[DimPsInstitutionStatuses]([LevelOfInstitututionCode] ASC, [ControlOfInstitutionCode] ASC, [CarnegieBasicClassificationCode] ASC, [MostPrevalentLevelOfInstitutionCode] ASC, [PerdominentCalendarSystemCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsInstitutionStatuses_CarnegieBasicClassificationCode')
        CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_CarnegieBasicClassificationCode]
        ON [RDS].[DimPsInstitutionStatuses] ([CarnegieBasicClassificationCode])
        INCLUDE ([LevelOfInstitututionCode],[ControlOfInstitutionCode],[MostPrevalentLevelOfInstitutionCode],[PerdominentCalendarSystemCode])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsInstitutionStatuses_MostPrevalentLevelOfInsitutionCode')
        CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_MostPrevalentLevelOfInsitutionCode]
        ON [RDS].[DimPsInstitutionStatuses] ([MostPrevalentLevelOfInstitutionCode])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimPsStudent_StudentIdentifierState')
        CREATE NONCLUSTERED INDEX [IX_DimPsStudent_StudentIdentifierState]
        ON [RDS].[DimPsStudents]([StudentIdentifierState] ASC) WITH (DATA_COMPRESSION = PAGE);
        
        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimScedCodes_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimScedCodes_Codes]
        ON [RDS].[DimScedCodes]([ScedCourseCode] ASC, [ScedCourseLevelCode] ASC, [ScedCourseSubjectAreaCode] ASC) WITH (DATA_COMPRESSION = PAGE);
        
        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimRaces_SchoolStateStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimRaces_SchoolStateStatusCode]
        ON [RDS].[DimK12SchoolStateStatuses]([SchoolStateStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimRaces_SchoolStateStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimRaces_SchoolStateStatusEdFactsCode]
        ON [RDS].[DimK12SchoolStateStatuses]([SchoolStateStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSchoolYears_SchoolYear')
        CREATE NONCLUSTERED INDEX [IX_DimSchoolYears_SchoolYear]
        ON [RDS].[DimSchoolYears]([SchoolYear] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimSeas_RecordStartDateTime_RecordEndDateTime')
        CREATE NONCLUSTERED INDEX [IX_DimSeas_RecordStartDateTime_RecordEndDateTime]
        ON [RDS].[DimSeas] ([RecordStartDateTime], [RecordEndDateTime])

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode')
        CREATE NONCLUSTERED INDEX [IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode]
        ON [RDS].[DimStateDefinedCustomIndicators]([StateDefinedCustomIndicatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimStateDefinedStatuses_StateDefinedStatusCode')
        CREATE NONCLUSTERED INDEX [IX_DimStateDefinedStatuses_StateDefinedStatusCode]
        ON [RDS].[DimStateDefinedStatuses]([StateDefinedStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimTitleIStatuses_TitleISupportServicesEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_TitleISupportServicesEdFactsCode]
        ON [RDS].[DimTitleIStatuses]([TitleISupportServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimTitleIStatuses_TitleISchoolStatusEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_TitleISchoolStatusEdFactsCode]
        ON [RDS].[DimTitleIStatuses]([TitleISchoolStatusEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimTitleIStatuses_TitleIProgramTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_TitleIProgramTypeEdFactsCode]
        ON [RDS].[DimTitleIStatuses]([TitleIProgramTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);
            
        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimTitleIStatuses_TitleIInstructionalServicesEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_TitleIInstructionalServicesEdFactsCode]
        ON [RDS].[DimTitleIStatuses]([TitleIInstructionalServicesEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimTitleIStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimTitleIStatuses_Codes]
        ON [RDS].[DimTitleIStatuses]([TitleISchoolStatusCode] ASC, [TitleIInstructionalServicesCode] ASC, [TitleISupportServicesCode] ASC, [TitleIProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);
        
        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_Codes')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_Codes]
        ON [RDS].[DimNOrDProgramStatuses]([LongTermStatusCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_LongTermStatusEdFactsCodes')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_LongTermStatusEdFactsCodes]
        ON [RDS].[DimNOrDProgramStatuses]([LongTermStatusEdFactsCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (DATA_COMPRESSION = PAGE);

        IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_DimNOrDProgramStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode')
        CREATE NONCLUSTERED INDEX [IX_DimNOrDProgramStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]
        ON [RDS].[DimNOrDProgramStatuses]([NeglectedOrDelinquentProgramTypeEdFactsCode] ASC) WITH (DATA_COMPRESSION = PAGE);

		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DimK12Schools_RecordStartDateTime') BEGIN
			CREATE NONCLUSTERED INDEX [IX_DimK12Schools_RecordStartDateTime]
			ON [RDS].[DimK12Schools] ([RecordStartDateTime])
			INCLUDE ([SchoolIdentifierState],[RecordEndDateTime])
		END

		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime') BEGIN
			CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime]
			ON [RDS].[DimK12Schools] ([SchoolIdentifierState],[RecordStartDateTime])
			INCLUDE ([RecordEndDateTime])
		END

		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_DimK12Schools_SchoolIdentifierState_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime') BEGIN
			CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierState_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime]
			ON [RDS].[DimK12Schools] ([SchoolIdentifierState],[DimK12SchoolId],[RecordStartDateTime],[RecordEndDateTime])
			INCLUDE ([SchoolOperationalStatus])
		END

        
       
        IF NOT EXISTS (SELECT 1 FROM SYS.EXTENDED_PROPERTIES WHERE [major_id] = OBJECT_ID('RDS.DimCipCodes') AND [name] = N'MS_Description' AND 
                        [minor_id] = (SELECT [column_id] FROM SYS.COLUMNS WHERE [name] = 'CipVersionCode' AND [object_id] = OBJECT_ID('RDS.DimCipCodes')))
        BEGIN

            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40959', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCipCodes', @level2type = N'COLUMN', @level2name = N'CipVersionCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40958', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCipCodes', @level2type = N'COLUMN', @level2name = N'CipUseDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40958', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCipCodes', @level2type = N'COLUMN', @level2name = N'CipUseCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40951', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCipCodes', @level2type = N'COLUMN', @level2name = N'CipCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41886', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAssessmentMethodTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41886', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAssessmentMethodTypeCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41893', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialIntendedPurposeTypeCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41893', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialIntendedPurposeTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41906', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialStatusTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41906', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialStatusTypeCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41158', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialCategoryType';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41162', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialCategorySystem';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41885 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAlternateName';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41165', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37869 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIeus', @level2type = N'COLUMN', @level2name = N'OperationalStatusEffectiveDate';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37898 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIeus', @level2type = N'COLUMN', @level2name = N'OrganizationOperationalStatus';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Intermediate Educational Unit (IEU) - A regional, multi-services public agency authorized by State law to develop, manage, AND provide services, programs, OR other support (e.g., construction, food services, technology services) to LEAs.', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIeus';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40104', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseFundingProgram';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40932', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'TuitionFunded';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40098', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCertificationDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40074', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CareerClusterDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40074', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CareerClusterCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40566', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'AdvancedPlacementCourseCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38719', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CreditValue';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38718', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCreditUnitsDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38718', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCreditUnitsCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40102', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseDepartmentName';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40102', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38944', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCodeSystemDesciption';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38944', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCodeSystemCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38943', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseIdentifier';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38928', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12CourseStatuses', @level2type = N'COLUMN', @level2name = N'CourseLevelCharacteristicDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38928', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12CourseStatuses', @level2type = N'COLUMN', @level2name = N'CourseLevelCharacteristicCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38752', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'ExitOrWithdrawalTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38748', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EntryTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38748 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EntryTypeCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38746', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12EnrollmentStatuses', @level2type = N'COLUMN', @level2name = N'EnrollmentStatusCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40936  ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40936  ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41310 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryBranchDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=41310 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryBranchCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40934  ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40934  ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37772', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'VisaTypeDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37794 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'UnitedStatesCitizenshipStatusDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37794 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'UnitedStatesCitizenshipStatusCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38683 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'PaternalGuardianEducationDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38683 ', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'PaternalGuardianEducationCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38682', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'MaternalGuardianEducationCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40296', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'NumberOfDependentsDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40296', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'NumberOfDependentsCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37740', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'DependencyStatusDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=37740', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'DependencyStatusCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'An organization that provides educational programs for individuals who have completed OR otherwise LEFT educational programs IN secondary school(s).', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsInstitutions';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=38935', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedSequenceOfCourse';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40671', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseSubjectAreaCode';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40668', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseLevelDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40670', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseDescription';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40670', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseTitle';
            EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=40670', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseCode';

        END

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimK12StudentStatuses' AND COLUMN_NAME = 'DiplomaCredentialTypeCode')
        EXEC sp_rename 'RDS.DimK12StudentStatuses.DiplomaCredentialTypeCode','HighSchoolDiplomaTypeCode','COLUMN';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimK12StudentStatuses' AND COLUMN_NAME = 'DiplomaCredentialTypeDescription')
        EXEC sp_rename 'RDS.DimK12StudentStatuses.DiplomaCredentialTypeDescription','HighSchoolDiplomaTypeDescription','COLUMN';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimK12StudentStatuses' AND COLUMN_NAME = 'DiplomaCredentialTypeEdFactsCode')
        EXEC sp_rename 'RDS.DimK12StudentStatuses.DiplomaCredentialTypeEdFactsCode','HighSchoolDiplomaTypeEdFactsCode','COLUMN';

    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DimK12StudentStatuses' AND COLUMN_NAME = 'DiplomaCredentialTypeId')
        EXEC sp_rename 'RDS.DimK12StudentStatuses.DiplomaCredentialTypeId','HighSchoolDiplomaTypeId','COLUMN';


