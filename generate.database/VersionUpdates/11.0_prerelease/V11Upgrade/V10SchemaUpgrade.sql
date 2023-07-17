	--TODO: Check for state custom indicator stuff.  Don't delete those fields/tables.
	--TODO: 

	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialAlternateName].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAlternateName';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialAssessmentMethodTypeCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAssessmentMethodTypeCode';



	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialAssessmentMethodTypeDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialAssessmentMethodTypeDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialCategorySystem].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialCategorySystem';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialCategoryType].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialCategoryType';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialIntendedPurposeTypeCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialIntendedPurposeTypeCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialIntendedPurposeTypeDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialIntendedPurposeTypeDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialStatusTypeCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialStatusTypeCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimCredentials].[CredentialStatusTypeDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimCredentials', @level2type = N'COLUMN', @level2name = N'CredentialStatusTypeDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimIeus].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimIeus';


	
	PRINT N'Dropping Extended Property [RDS].[DimK12Courses].[CourseCodeSystemDesciption].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimK12Courses', @level2type = N'COLUMN', @level2name = N'CourseCodeSystemDesciption';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryActiveStudentIndicatorCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryActiveStudentIndicatorDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryActiveStudentIndicatorDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryBranchCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryBranchCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryBranchDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryBranchDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryVeteranStudentIndicatorCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsCitizenshipStatuses].[MilitaryVeteranStudentIndicatorDescription].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsCitizenshipStatuses', @level2type = N'COLUMN', @level2name = N'MilitaryVeteranStudentIndicatorDescription';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[NumberOfDependentsCode].[MS_Description]...';


	
	EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'NumberOfDependentsCode';


	
	PRINT N'Dropping Extended Property [RDS].[DimPsFamilyStatuses].[NumberOfDependentsDescription].[MS_Description]...';


		EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimPsFamilyStatuses', @level2type = N'COLUMN', @level2name = N'NumberOfDependentsDescription';


		PRINT N'Dropping Extended Property [RDS].[DimScedCodes].[ScedCourseDescription].[MS_Description]...';


		EXECUTE sp_dropextendedproperty @name = N'MS_Description', @level0type = N'SCHEMA', @level0name = N'RDS', @level1type = N'TABLE', @level1name = N'DimScedCodes', @level2type = N'COLUMN', @level2name = N'ScedCourseDescription';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'CharterSchoolAuthorizer', @level2type = N'COLUMN', @level2name = N'CharterSchoolAuthorizerType';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[SchoolYear].[Required]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'SchoolYear';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[LEA_Identifier_State].[Required]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[School_Identifier_State].[Required]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'School_Identifier_State';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[ComprehensiveSupport].[Lookup]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'ComprehensiveSupport';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[ComprehensiveSupportReasonApplicability].[Lookup]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'ComprehensiveSupportReasonApplicability';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[ComprehensiveSupportReasonApplicability].[Required]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'ComprehensiveSupportReasonApplicability';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[RecordStartDateTime].[Required]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[OrganizationId].[Identifier]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	-- 
	-- PRINT N'Dropping Extended Property [Staging].[K12SchoolComprehensiveSupportIdentificationType].[K12SchoolId].[Identifier]...';


	-- 
	-- EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolComprehensiveSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'K12SchoolId';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[SchoolYear].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'SchoolYear';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[LEA_Identifier_State].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[School_Identifier_State].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'School_Identifier_State';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[Subgroup].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'Subgroup';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[ComprehensiveSupportReasonApplicability].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'ComprehensiveSupportReasonApplicability';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[ComprehensiveSupportReasonApplicability].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'ComprehensiveSupportReasonApplicability';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[RecordStartDateTime].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'RecordStartDateTime';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[K12SchoolTargetedSupportIdentificationType].[K12SchoolId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12SchoolTargetedSupportIdentificationType', @level2type = N'COLUMN', @level2name = N'K12SchoolId';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[Personnel_Identifier_State].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'Personnel_Identifier_State';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[LEA_Identifier_State].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[School_Identifier_State].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'School_Identifier_State';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[LastName].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'LastName';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[CredentialType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'CredentialType';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[CredentialType].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'CredentialType';


	
	PRINT N'Dropping Extended Property [Staging].[K12StaffAssignment].[HighlyQualifiedTeacherIndicator].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StaffAssignment', @level2type = N'COLUMN', @level2name = N'HighlyQualifiedTeacherIndicator';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[RaceType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'RaceType';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[PersonDemographicRaceId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'PersonDemographicRaceId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[RefRaceId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'RefRaceId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonRace].[RefAcademicTermDesignatorId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonRace', @level2type = N'COLUMN', @level2name = N'RefAcademicTermDesignatorId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentAcademicSubject].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentAcademicSubject';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentAdministrationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentAdministrationId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentFormId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentFormId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentPerformanceLevelId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentPerformanceLevelId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentPurpose].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentPurpose';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentSubtestId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentSubtestId';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentType';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[AssessmentTypeAdministeredToChildrenWithDisabilities].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment', @level2type = N'COLUMN', @level2name = N'AssessmentTypeAdministeredToChildrenWithDisabilities';


	
	PRINT N'Dropping Extended Property [Staging].[Assessment].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Assessment';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentAcademicSubject].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentAcademicSubject';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentAdministrationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentAdministrationId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentFormId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentFormId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentPerformanceLevelId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentPerformanceLevelId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentPurpose].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentPurpose';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentRegistrationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentRegistrationId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentRegistrationReasonNotCompleting].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentRegistrationReasonNotCompleting';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentRegistrationReasonNotCompleting].[Required]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Required', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentRegistrationReasonNotCompleting';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentResult_PerformanceLevelId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentResult_PerformanceLevelId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentResultId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentResultId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentSubtestId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentSubtestId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentType';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[AssessmentTypeAdministeredToChildrenWithDisabilities].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'AssessmentTypeAdministeredToChildrenWithDisabilities';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[GradeLevelWhenAssessed].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'GradeLevelWhenAssessed';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[GradeLevelWhenAssessed].[TableFilter]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableFilter', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'GradeLevelWhenAssessed';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[OrganizationPersonRoleId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[OrganizationPersonRoleId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_School';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[AssessmentResult].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'AssessmentResult';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[DisciplinaryActionTaken].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplinaryActionTaken';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[DisciplineMethodOfCwd].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineMethodOfCwd';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[DisciplineReason].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'DisciplineReason';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[IdeaInterimRemoval].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'IdeaInterimRemoval';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[IdeaInterimRemovalReason].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'IdeaInterimRemovalReason';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[IncidentId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'IncidentId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[IncidentId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'IncidentId_School';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[OrganizationPersonRoleId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[OrganizationPersonRoleId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_School';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[Discipline].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Discipline';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[ExitOrWithdrawalType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'ExitOrWithdrawalType';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[GradeLevel].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'GradeLevel';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[GradeLevel].[TableFilter]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableFilter', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'GradeLevel';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[HighSchoolDiplomaType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'HighSchoolDiplomaType';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[OrganizationPersonRoleId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[OrganizationPersonRoleId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[OrganizationPersonRoleRelationshipId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleRelationshipId';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[K12Enrollment].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Enrollment';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[IEU_Identifier_State_ChangedIdentifier].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'IEU_Identifier_State_ChangedIdentifier';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[IEU_Identifier_State_Identifier_Old].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'IEU_Identifier_State_Identifier_Old';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[K12LeaTitleISupportServiceId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'K12LeaTitleISupportServiceId';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[K12ProgramOrServiceId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'K12ProgramOrServiceId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[K12ProgramOrServiceId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'K12ProgramOrServiceId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[LEA_Identifier_State_ChangedIdentifier].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State_ChangedIdentifier';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[LEA_Identifier_State_Identifier_Old].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_Identifier_State_Identifier_Old';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationId_IEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationId_IEU';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationId_SEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationId_SEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationOperationalStatusId_IEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationOperationalStatusId_IEU';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationOperationalStatusId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationOperationalStatusId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationOperationalStatusId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationOperationalStatusId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_IEUToLEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_IEUToLEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_LEAToSchool].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_LEAToSchool';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_SEAToIEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_SEAToIEU';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationRelationshipId_SEAToLEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationRelationshipId_SEAToLEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationWebsiteId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationWebsiteId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[OrganizationWebsiteId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'OrganizationWebsiteId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[School_Identifier_State_ChangedIdentifier].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_Identifier_State_ChangedIdentifier';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[School_Identifier_State_Identifier_Old].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_Identifier_State_Identifier_Old';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[LEA_OperationalStatus].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_OperationalStatus';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[LEA_Type].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'LEA_Type';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[NewIEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'NewIEU';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[NewLEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'NewLEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[NewSchool].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'NewSchool';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[School_OperationalStatus].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_OperationalStatus';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[School_ReconstitutedStatus].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_ReconstitutedStatus';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[School_Type].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization', @level2type = N'COLUMN', @level2name = N'School_Type';


	
	PRINT N'Dropping Extended Property [Staging].[K12Organization].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12Organization';


	
	PRINT N'Dropping Extended Property [Staging].[K12ProgramParticipation].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12ProgramParticipation', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[K12ProgramParticipation].[OrganizationPersonRoleId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12ProgramParticipation', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId';


	
	PRINT N'Dropping Extended Property [Staging].[K12ProgramParticipation].[ProgramOrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12ProgramParticipation', @level2type = N'COLUMN', @level2name = N'ProgramOrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[K12ProgramParticipation].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12ProgramParticipation', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[K12ProgramParticipation].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12ProgramParticipation';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationID_Course].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationID_Course';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationID_CourseSection].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationID_CourseSection';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationPersonRoleId_CourseSection].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_CourseSection';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationPersonRoleId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[OrganizationPersonRoleId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_School';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[K12StudentCourseSection].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'K12StudentCourseSection';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[ContinuationOfServicesReason].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'ContinuationOfServicesReason';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[LEAOrganizationID_MigrantProgram].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'LEAOrganizationID_MigrantProgram';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[LEAOrganizationPersonRoleID_MigrantProgram].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'LEAOrganizationPersonRoleID_MigrantProgram';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[MigrantEducationProgramEnrollmentType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'MigrantEducationProgramEnrollmentType';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[MigrantEducationProgramServicesType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'MigrantEducationProgramServicesType';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[PersonProgramParticipationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationId';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[ProgramParticipationMigrantId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'ProgramParticipationMigrantId';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[SchoolOrganizationID_MigrantProgram].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'SchoolOrganizationID_MigrantProgram';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[SchoolOrganizationPersonRoleID_MigrantProgram].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant', @level2type = N'COLUMN', @level2name = N'SchoolOrganizationPersonRoleID_MigrantProgram';


	
	PRINT N'Dropping Extended Property [Staging].[Migrant].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'Migrant';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationAddress].[LocationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationAddress', @level2type = N'COLUMN', @level2name = N'LocationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationAddress].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationAddress', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationAddress].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationAddress';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationCalendarSession].[OrganizationCalendarId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationCalendarSession', @level2type = N'COLUMN', @level2name = N'OrganizationCalendarId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationCalendarSession].[OrganizationCalendarSessionId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationCalendarSession', @level2type = N'COLUMN', @level2name = N'OrganizationCalendarSessionId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationCalendarSession].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationCalendarSession', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationCalendarSession].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationCalendarSession';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationFederalFunding].[OrganizationType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'OrganizationType';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationFederalFunding].[OrganizationType].[TableFilter]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableFilter', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding', @level2type = N'COLUMN', @level2name = N'OrganizationType';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationFederalFunding].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationFederalFunding';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationGradeOffered].[GradeOffered].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationGradeOffered].[GradeOffered].[TableFilter]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableFilter', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'GradeOffered';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationGradeOffered].[K12SchoolGradeOfferedId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'K12SchoolGradeOfferedId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationGradeOffered].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationGradeOffered].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationGradeOffered';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationPhone].[OrganizationTelephoneId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationPhone', @level2type = N'COLUMN', @level2name = N'OrganizationTelephoneId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationPhone].[InstitutionTelephoneNumberType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationPhone', @level2type = N'COLUMN', @level2name = N'InstitutionTelephoneNumberType';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationPhone].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationPhone', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationPhone].[OrganizationType].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationPhone', @level2type = N'COLUMN', @level2name = N'OrganizationType';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationPhone].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationPhone';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationProgramType].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationProgramType', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationProgramType].[OrganizationProgramTypeId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationProgramType', @level2type = N'COLUMN', @level2name = N'OrganizationProgramTypeId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationProgramType].[ProgramOrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationProgramType', @level2type = N'COLUMN', @level2name = N'ProgramOrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationProgramType].[ProgramTypeId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationProgramType', @level2type = N'COLUMN', @level2name = N'ProgramTypeId';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationProgramType].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationProgramType';


	
	PRINT N'Dropping Extended Property [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'OrganizationSchoolComprehensiveAndTargetedSupport';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_IEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_IEU';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_IEU_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_IEU_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_IEU_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_IEU_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_IEU_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_IEU_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_IEU_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_IEU_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_SPED].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_IEU_SPED';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_PerkinsLEP].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_PerkinsLEP';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[MilitaryConnectedStudentIndicator].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'MilitaryConnectedStudentIndicator';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_LEA_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_LEA_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_LEA_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_LEA_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_School_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_School_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_School_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_School_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_School_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_School_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationID_School_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationID_School_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_LEA_SPED].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA_SPED';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School_Program_Foster].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School_Program_Foster';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School_Program_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School_Program_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School_Program_Immigrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School_Program_Immigrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School_Program_Section504].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School_Program_Section504';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[OrganizationPersonRoleID_School_SPED].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School_SPED';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonHomelessnessId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonHomelessnessId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonHomelessNightTimeResidenceId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonHomelessNightTimeResidenceId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonLanguageId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonLanguageId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonMilitaryId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonMilitaryId';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_EconomicDisadvantage].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_EconomicDisadvantage';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_EnglishLearner].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_EnglishLearner';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_Homeless].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_Homeless';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_IDEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_IDEA';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[PersonStatusId_Migrant].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus', @level2type = N'COLUMN', @level2name = N'PersonStatusId_Migrant';


	
	PRINT N'Dropping Extended Property [Staging].[PersonStatus].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'PersonStatus';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationID_CTEProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationID_CTEProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationID_CTEProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationID_CTEProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_CTEProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_CTEProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_CTEProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_CTEProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[PersonProgramParticipationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[PersonProgramParticipationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationCTE].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationCTE';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationID_Program_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationID_Program_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationID_Program_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationID_Program_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationPersonRoleId_Program_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_Program_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationPersonRoleId_Program_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_Program_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[PersonProgramParticipationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[PersonProgramParticipationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationNorD].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationNorD';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_Program_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationID_Program_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_Program_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationID_Program_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationPersonRoleId_Program_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_Program_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationPersonRoleId_Program_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleId_Program_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[IDEAEducationalEnvironmentForEarlyChildhood].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'IDEAEducationalEnvironmentForEarlyChildhood';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[IDEAEducationalEnvironmentForSchoolAge].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'IDEAEducationalEnvironmentForSchoolAge';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[PersonProgramParticipationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[PersonProgramParticipationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[SpecialEducationExitReason].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation', @level2type = N'COLUMN', @level2name = N'SpecialEducationExitReason';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationSpecialEducation].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationSpecialEducation';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationID_TitleIProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationID_TitleIProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationID_TitleIProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationID_TitleIProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationPersonRoleID_TitleIProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_TitleIProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationPersonRoleID_TitleIProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_TitleIProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[PersonProgramParticipationId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[PersonProgramParticipationId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationId_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[RefTitleIIndicatorId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'RefTitleIIndicatorId';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[TitleIIndicator].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI', @level2type = N'COLUMN', @level2name = N'TitleIIndicator';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleI].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleI';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationID_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationID_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationID_TitleIIIProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationID_TitleIIIProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationID_TitleIIIProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationID_TitleIIIProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationPersonRoleID_TitleIIIProgram_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_TitleIIIProgram_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationPersonRoleID_TitleIIIProgram_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationPersonRoleID_TitleIIIProgram_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[PersonProgramParticipationId_LEA].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationId_LEA';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[PersonProgramParticipationId_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'PersonProgramParticipationId_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[PersonStatusId_Immigration].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'PersonStatusId_Immigration';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[OrganizationID_School].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'OrganizationID_School';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[PersonID].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII', @level2type = N'COLUMN', @level2name = N'PersonID';


	
	PRINT N'Dropping Extended Property [Staging].[ProgramParticipationTitleIII].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'ProgramParticipationTitleIII';


	
	PRINT N'Dropping Extended Property [Staging].[StateDetail].[SeaStateIdentifier].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'SeaStateIdentifier';


	
	PRINT N'Dropping Extended Property [Staging].[StateDetail].[OrganizationId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'OrganizationId';


	
	PRINT N'Dropping Extended Property [Staging].[StateDetail].[PersonId].[Identifier]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Identifier', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'PersonId';


	
	PRINT N'Dropping Extended Property [Staging].[StateDetail].[StateCode].[Lookup]...';


	
	EXECUTE sp_dropextendedproperty @name = N'Lookup', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail', @level2type = N'COLUMN', @level2name = N'StateCode';


	
	PRINT N'Dropping Extended Property [Staging].[StateDetail].[TableType]...';


	
	EXECUTE sp_dropextendedproperty @name = N'TableType', @level0type = N'SCHEMA', @level0name = N'Staging', @level1type = N'TABLE', @level1name = N'StateDetail';


	
	PRINT N'Dropping Index [RDS].[BridgeK12StudentEnrollmentRaces].[IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]...';


	
	DROP INDEX [IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]
		ON [RDS].[BridgeK12StudentEnrollmentRaces];


	
	PRINT N'Dropping Index [RDS].[BridgeK12StudentEnrollmentRaces].[IXFK_BridgeK12StudentEnrollmentRaces_DimRaces]...';


	
	DROP INDEX [IXFK_BridgeK12StudentEnrollmentRaces_DimRaces]
		ON [RDS].[BridgeK12StudentEnrollmentRaces];


	
	PRINT N'Dropping Index [RDS].[BridgePsStudentEnrollmentRaces].[IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]...';


	
	DROP INDEX [IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]
		ON [RDS].[BridgePsStudentEnrollmentRaces];


	
	PRINT N'Dropping Index [RDS].[BridgePsStudentEnrollmentRaces].[IXFK_BridgePsStudentEnrollmentRaces_DimRaces]...';


	
	DROP INDEX [IXFK_BridgePsStudentEnrollmentRaces_DimRaces]
		ON [RDS].[BridgePsStudentEnrollmentRaces];


	
	PRINT N'Dropping Index [RDS].[DimDates].[IX_DimDates_DateValue]...';


	
	DROP INDEX [IX_DimDates_DateValue]
		ON [RDS].[DimDates];


	
	PRINT N'Dropping Index [RDS].[DimLanguages].[IX_DimLanguages_LanguageCode]...';


	
	DROP INDEX [IX_DimLanguages_LanguageCode]
		ON [RDS].[DimLanguages];


	
	PRINT N'Dropping Index [RDS].[DimLanguages].[IX_DimLanguages_LanguageEdFactsCode]...';


	
	DROP INDEX [IX_DimLanguages_LanguageEdFactsCode]
		ON [RDS].[DimLanguages];


	
	PRINT N'Dropping Index [RDS].[DimPsCitizenshipStatuses].[IX_DimPsCitizenshipStatuses_Codes]...';


	
	DROP INDEX [IX_DimPsCitizenshipStatuses_Codes]
		ON [RDS].[DimPsCitizenshipStatuses];


	
	PRINT N'Dropping Index [RDS].[BridgeK12ProgramParticipationRaces].[IXFK_BridgeK12ProgramParticipationRaces_DimRaces]...';


	
	DROP INDEX [IXFK_BridgeK12ProgramParticipationRaces_DimRaces]
		ON [RDS].[BridgeK12ProgramParticipationRaces];


	-- 
	-- PRINT N'Dropping Index [RDS].[BridgeK12SchoolGradeLevels].[IXFK_BridgeK12SchoolGradeLevels_DimGradeLevels]...';


	-- 
	-- DROP INDEX [IXFK_BridgeK12SchoolGradeLevels_DimGradeLevels]
	-- 	ON [RDS].[BridgeK12SchoolGradeLevels];


	
	PRINT N'Dropping Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff]...';


	
	DROP INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff]
		ON [RDS].[BridgeK12StudentCourseSectionK12Staff];


	
	PRINT N'Dropping Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection]...';


	
	DROP INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection]
		ON [RDS].[BridgeK12StudentCourseSectionK12Staff];


	
	PRINT N'Dropping Index [RDS].[BridgeLeaGradeLevels].[IXFK_BridgeLeaGradeLevels_DimGradeLevels]...';


	
	DROP INDEX [IXFK_BridgeLeaGradeLevels_DimGradeLevels]
		ON [RDS].[BridgeLeaGradeLevels];


	
	PRINT N'Dropping Index [RDS].[BridgeLeaGradeLevels].[IXFK_BridgeLeaGradeLevels_DimLeas]...';


	
	DROP INDEX [IXFK_BridgeLeaGradeLevels_DimLeas]
		ON [RDS].[BridgeLeaGradeLevels];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentTypeEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_AssessmentTypeEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_LeaFullYearStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_LeaFullYearStatusEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_ParticipationStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_ParticipationStatusEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_PerformanceLevelEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_PerformanceLevelEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_SchFullYearStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_SchFullYearStatusEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimAssessments].[IX_DimAssessments_SeaFullYearStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimAssessments_SeaFullYearStatusEdFactsCode]
		ON [RDS].[DimAssessments];


	
	PRINT N'Dropping Index [RDS].[DimCteStatuses].[IX_DimCteStatuses_AllCodes]...';


	
	DROP INDEX [IX_DimCteStatuses_AllCodes]
		ON [RDS].[DimCteStatuses];


	
	PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_DisabilityEdFactsCode]...';


	
	DROP INDEX [IX_DimIdeaStatuses_DisabilityEdFactsCode]
		ON [RDS].[DimIdeaStatuses];


	
	PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvEdFactsCode]...';


	
	DROP INDEX [IX_DimIdeaStatuses_EducEnvEdFactsCode]
		ON [RDS].[DimIdeaStatuses];


	
	PRINT N'Dropping Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_IdeaIndicatorEdFactsCode]...';


	
	DROP INDEX [IX_DimIdeaStatuses_IdeaIndicatorEdFactsCode]
		ON [RDS].[DimIdeaStatuses];


	
	PRINT N'Dropping Index [RDS].[DimIeus].[IX_DimIeus_IeuIdentifierState]...';


	
	DROP INDEX [IX_DimIeus_IeuIdentifierState]
		ON [RDS].[DimIeus];


	
	PRINT N'Dropping Index [RDS].[DimK12Courses].[IX_DimK12Courses_CourseIdentifer]...';


	
	DROP INDEX [IX_DimK12Courses_CourseIdentifer]
		ON [RDS].[DimK12Courses];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_Codes]...';


	
	DROP INDEX [IX_DimK12Demographics_Codes]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_EconomicDisadvantageStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_EconomicDisadvantageStatusEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_EnglishLearnerStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_EnglishLearnerStatusEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_HomelessnessStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_HomelessnessStatusEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_HomelessPrimaryNighttimeResidenceEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_HomelessPrimaryNighttimeResidenceEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_HomelessUnaccompaniedYouthStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_HomelessUnaccompaniedYouthStatusEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_MigrantStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_MigrantStatusEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_MilitaryConnectedStudentIndicatorEdFactsCode]...';


	
	DROP INDEX [IX_DimK12Demographics_MilitaryConnectedStudentIndicatorEdFactsCode]
		ON [RDS].[DimK12Demographics];


	
	PRINT N'Dropping Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierState]...';


	
	DROP INDEX [IX_DimK12Schools_SchoolIdentifierState]
		ON [RDS].[DimK12Schools];


	
	PRINT N'Dropping Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierState_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime]...';


	
	DROP INDEX [IX_DimK12Schools_SchoolIdentifierState_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime]
		ON [RDS].[DimK12Schools];


	
	PRINT N'Dropping Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime]...';


	
	DROP INDEX [IX_DimK12Schools_SchoolIdentifierState_RecordStartDateTime]
		ON [RDS].[DimK12Schools];


	
	PRINT N'Dropping Index [RDS].[DimK12Schools].[IX_DimSchools_StateCode]...';


	
	DROP INDEX [IX_DimSchools_StateCode]
		ON [RDS].[DimK12Schools];


	
	PRINT N'Dropping Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageEdFactsCode]...';


	
	DROP INDEX [IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageEdFactsCode]
		ON [RDS].[DimK12SchoolStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_CertificationStatusCode]...';


	
	DROP INDEX [IX_DimK12StaffStatuses_CertificationStatusCode]
		ON [RDS].[DimK12StaffStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12StaffStatuses_EmergencyOrProvisionalCredentialStatusEdFactsCode]
		ON [RDS].[DimK12StaffStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_OutOfFieldStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimK12StaffStatuses_OutOfFieldStatusEdFactsCode]
		ON [RDS].[DimK12StaffStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_QualificationStatusCode]...';


	
	DROP INDEX [IX_DimK12StaffStatuses_QualificationStatusCode]
		ON [RDS].[DimK12StaffStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_UnexperiencedStatusCode]...';


	
	DROP INDEX [IX_DimK12StaffStatuses_UnexperiencedStatusCode]
		ON [RDS].[DimK12StaffStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_Codes]...';


	
	DROP INDEX [IX_DimStudentStatuses_Codes]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_DiplomaCredentialTypeEdFactsCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_DiplomaCredentialTypeEdFactsCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_MobilityStatus12moEdFactsCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_MobilityStatus12moEdFactsCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_MobilityStatus36moEdFactsCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_MobilityStatus36moEdFactsCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_MobilityStatusSYEdFactsCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_MobilityStatusSYEdFactsCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_PlacementStatusCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_PlacementStatusCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_PlacementTypeCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_PlacementTypeCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimK12StudentStatuses].[IX_DimStudentStatuses_ReferralStatusEdFactsCode]...';


	
	DROP INDEX [IX_DimStudentStatuses_ReferralStatusEdFactsCode]
		ON [RDS].[DimK12StudentStatuses];


	
	PRINT N'Dropping Index [RDS].[DimLeas].[IX_DimLeas_LeaIdentifierState_RecordStartDateTime]...';


	
	DROP INDEX [IX_DimLeas_LeaIdentifierState_RecordStartDateTime]
		ON [RDS].[DimLeas];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimCollections]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimCollections]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimDates]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimDates]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimIdeaStatuses]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimIdeaStatuses]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimIeus]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimIeus]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimK12Demographics]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimK12Demographics]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimK12ProgramTypes]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimK12ProgramTypes]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimK12Schools]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimK12Schools]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimLeas]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimLeas]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimSchoolYears]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimSchoolYears]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DimStudents]...';


	
	DROP INDEX [IXFK_FactK12ProgramParticipations_DimStudents]
		ON [RDS].[FactK12ProgramParticipations];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimK12School_DimK12SchoolId]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimK12School_DimK12SchoolId]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimK12Staff_DimK12Staffid]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimK12Staff_DimK12Staffid]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimK12StaffCateries_DimK12StaffCategoryId]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimK12StaffCateries_DimK12StaffCategoryId]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimSchoolYears_DimSchoolYearId]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimSchoolYears_DimSchoolYearId]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_DimTitleIIIStatuses]...';


	
	DROP INDEX [IXFK_FactK12StaffCounts_DimTitleIIIStatuses]
		ON [RDS].[FactK12StaffCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimAssessment]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimAssessment]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimAssessmentStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimAssessmentStatuses]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimCteStatus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimCteStatus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimGradeLevel]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimGradeLevel]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimIeaStatus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimIeaStatus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimIeus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimIeus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimK12Demographics]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimK12Demographics]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimK12Schools]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimK12Schools]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimK12Students]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimK12Students]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimK12StudentStatus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimK12StudentStatus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimLeas]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimLeas]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimNOrDProgramStatus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimNOrDProgramStatus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimProgramStatus]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimProgramStatus]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimRace]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimRace]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_DimTitleIIIStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentAssessments_DimTitleIIIStatuses]
		ON [RDS].[FactK12StudentAssessments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IX_FactK12StudentCounts_DimSchoolYearId_DimFactTypeId]...';


	
	DROP INDEX [IX_FactK12StudentCounts_DimSchoolYearId_DimFactTypeId]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimAges]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimAges]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimAttendances]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimAttendances]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimCohortStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimCohortStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimGradeLevels]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimGradeLevels]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimIdeaStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimIdeaStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimIeus]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimIeus]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimK12EnrollmentStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimK12EnrollmentStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimK12School]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimK12School]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimK12Students]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimK12Students]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimK12StudentStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimK12StudentStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimLanguages]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimLanguages]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimLeas]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimLeas]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimMigrants]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimMigrants]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimNOrDProgramStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimNOrDProgramStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimProgramStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimProgramStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimRace]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimRace]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimSchoolYearId]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimSchoolYearId]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimTitleIIIStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimTitleIIIStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_DimTitleIStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCounts_DimTitleIStatuses]
		ON [RDS].[FactK12StudentCounts];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimCipCodes]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimCipCodes]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimCollections]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimCollections]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimDates]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimDates]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimGradeLevels]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimGradeLevels]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimIeus]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimIeus]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimK12Courses]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimK12Courses]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimK12CourseStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimK12CourseStatuses]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimK12Schools]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimK12Schools]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimLanguages]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimLanguages]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimLeas]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimLeas]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimScedCodes]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimScedCodes]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimSchoolYears]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimSchoolYears]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_DimStudents]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_DimStudents]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSection_K12DemographicId]...';


	
	DROP INDEX [IXFK_FactK12StudentCourseSection_K12DemographicId]
		ON [RDS].[FactK12StudentCourseSections];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_AgeId_SchoolYearId_FactTypeId_WithIncludes]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_AgeId_SchoolYearId_FactTypeId_WithIncludes]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_IdeaStatusId_WithIncludes]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_IdeaStatusId_WithIncludes]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_SchoolYearId_DisciplineId_FactTypeId_WithIncludes]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_SchoolYearId_DisciplineId_FactTypeId_WithIncludes]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_IdeaStatusId_K12StudentId]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_IdeaStatusId_K12StudentId]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_WithIncludes]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_WithIncludes]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentDisciplines].[IX_FactK12StudentDisciplines_SchoolYearId_K12DemographicId_FactTypeId_WithIncludes]...';


	
	DROP INDEX [IX_FactK12StudentDisciplines_SchoolYearId_K12DemographicId_FactTypeId_WithIncludes]
		ON [RDS].[FactK12StudentDisciplines];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimCollection]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimCollection]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimDates_EntryDateId]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimDates_EntryDateId]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimDates_ExitDateId]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimDates_ExitDateId]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimDates_ProjectedGraduationDateId]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimDates_ProjectedGraduationDateId]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimGradeLevels]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimGradeLevels]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimIdeaStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimIdeaStatuses]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimIeus]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimIeus]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimK12Demographics]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimK12Demographics]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimK12EnrollmentStatuses]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimK12EnrollmentStatuses]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimK12Schools]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimK12Schools]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimK12Students]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimK12Students]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimLeas]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimLeas]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimSchoolYears]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimSchoolYears]
		ON [RDS].[FactK12StudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DimSeas]...';


	
	DROP INDEX [IXFK_FactK12StudentEnrollments_DimSeas]
		ON [RDS].[FactK12StudentEnrollments];



	
	PRINT N'Dropping Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimStateDefinedStatuses]...';


	
	DROP INDEX [IXFK_FactOrganizationStatusCounts_DimStateDefinedStatuses]
		ON [RDS].[FactOrganizationStatusCounts];

	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_DimAcademicAwardDates]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicAwards_DimAcademicAwardDates]
		ON [RDS].[FactPsStudentAcademicAwards];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus]
		ON [RDS].[FactPsStudentAcademicAwards];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_DimPsInstitutions]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicAwards_DimPsInstitutions]
		ON [RDS].[FactPsStudentAcademicAwards];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_DimPsStudents]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicAwards_DimPsStudents]
		ON [RDS].[FactPsStudentAcademicAwards];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimAcademicTermDesignators]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimAcademicTermDesignators]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimCollections]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimCollections]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimPsInstitutions]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimPsInstitutions]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimPsStudents]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimPsStudents]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimSchoolYears]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimSchoolYears]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DimSeas]...';


	
	DROP INDEX [IXFK_FactPsStudentAcademicRecords_DimSeas]
		ON [RDS].[FactPsStudentAcademicRecords];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimAges]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimAges]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimDataCollections]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimDataCollections]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimDates_EntryDate]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimDates_EntryDate]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimDates_ExitDate]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimDates_ExitDate]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimPsEnrollmentStatuses]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimPsEnrollmentStatuses]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimPsInstitutions]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimPsInstitutions]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimPsInstitutionStatuses]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimPsInstitutionStatuses]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimPsStudents]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimPsStudents]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DimSchoolYears]...';


	
	DROP INDEX [IXFK_FactPsStudentEnrollments_DimSchoolYears]
		ON [RDS].[FactPsStudentEnrollments];


	
	PRINT N'Dropping Index [Staging].[Discipline].[IX_Discipline_StudentIdentifier]...';


	
	DROP INDEX [IX_Discipline_StudentIdentifier]
		ON [Staging].[Discipline];


	
	PRINT N'Dropping Index [Staging].[K12Enrollment].[IX_K12Enrollment_StudentIdentifier_First_Middle_Last_DOB]...';


	
	DROP INDEX [IX_K12Enrollment_StudentIdentifier_First_Middle_Last_DOB]
		ON [Staging].[K12Enrollment];


	
	PRINT N'Dropping Index [Staging].[K12Enrollment].[IX_Staging_K12Enrollment_EnrollmentEntryDate_WithIncludes]...';


	
	DROP INDEX [IX_Staging_K12Enrollment_EnrollmentEntryDate_WithIncludes]
		ON [Staging].[K12Enrollment];


	
	PRINT N'Dropping Index [Staging].[K12Enrollment].[IX_Staging_K12Enrollment_StudentId_SchoolId_EnrollmentDate_WithIncludes]...';


	
	DROP INDEX [IX_Staging_K12Enrollment_StudentId_SchoolId_EnrollmentDate_WithIncludes]
		ON [Staging].[K12Enrollment];


	
	PRINT N'Dropping Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_EntryDate_PersonId_ProgramOrganizationId_DataCollectionId]...';


	
	DROP INDEX [IX_K12ProgramParticipation_EntryDate_PersonId_ProgramOrganizationId_DataCollectionId]
		ON [Staging].[K12ProgramParticipation];


	
	PRINT N'Dropping Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_Student_Identifier_State]...';


	
	DROP INDEX [IX_K12ProgramParticipation_Student_Identifier_State]
		ON [Staging].[K12ProgramParticipation];


	
	PRINT N'Dropping Index [Staging].[PersonStatus].[IX_PersonStatus_IDEAIndicator]...';


	
	DROP INDEX [IX_PersonStatus_IDEAIndicator]
		ON [Staging].[PersonStatus];


	
	PRINT N'Dropping Index [Staging].[PersonStatus].[IX_PersonStatus_LEA_Identifier_State_PersonId]...';


	
	DROP INDEX [IX_PersonStatus_LEA_Identifier_State_PersonId]
		ON [Staging].[PersonStatus];


	
	PRINT N'Dropping Index [Staging].[PersonStatus].[IX_PersonStatus_School_Identifier_State_PersonId]...';


	
	DROP INDEX [IX_PersonStatus_School_Identifier_State_PersonId]
		ON [Staging].[PersonStatus];


	
	PRINT N'Dropping Index [Staging].[PersonStatus].[IX_Staging_PersonStatus_IDEAStatusStartDate_WithIncludes]...';


	
	DROP INDEX [IX_Staging_PersonStatus_IDEAStatusStartDate_WithIncludes]
		ON [Staging].[PersonStatus];


	
	PRINT N'Dropping Index [Staging].[PersonStatus].[IX_Staging_PersonStatus_StudentId_IDEAStatusStartDate]...';


	
	DROP INDEX [IX_Staging_PersonStatus_StudentId_IDEAStatusStartDate]
		ON [Staging].[PersonStatus];


	
	PRINT N'Dropping Index [Staging].[ProgramParticipationSpecialEducation].[IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_LEA]...';


	
	DROP INDEX [IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_LEA]
		ON [Staging].[ProgramParticipationSpecialEducation];


	
	PRINT N'Dropping Index [Staging].[ProgramParticipationSpecialEducation].[IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_School]...';


	
	DROP INDEX [IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_School]
		ON [Staging].[ProgramParticipationSpecialEducation];


	
	PRINT N'Dropping Index [Staging].[ProgramParticipationSpecialEducation].[IX_Staging_PPSE_ProgramParticipationBeginDate_WithIncludes]...';


	
	DROP INDEX [IX_Staging_PPSE_ProgramParticipationBeginDate_WithIncludes]
		ON [Staging].[ProgramParticipationSpecialEducation];


	
	PRINT N'Dropping Index [Staging].[ProgramParticipationSpecialEducation].[IX_Staging_ProgramParticipationSpecialEducation_StudentId_LeaId_BeginDate]...';


	
	DROP INDEX [IX_Staging_ProgramParticipationSpecialEducation_StudentId_LeaId_BeginDate]
		ON [Staging].[ProgramParticipationSpecialEducation];


	
	PRINT N'Dropping Index [Staging].[SourceSystemReferenceData].[IX_Staging_SourceSystemReferenceData_OutputCode_TableName_SchoolYear]...';


	
	DROP INDEX [IX_Staging_SourceSystemReferenceData_OutputCode_TableName_SchoolYear]
		ON [Staging].[SourceSystemReferenceData];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[DimAssessmentStatuses]...';


	
	ALTER TABLE [RDS].[DimAssessmentStatuses] DROP CONSTRAINT [DF__DimAssess__Asses__5FBEF025];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[DimCteStatuses]...';


	
	ALTER TABLE [RDS].[DimCteStatuses] DROP CONSTRAINT [DF__DimCteSta__LepPe__3C6DF44C];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[DimK12Schools]...';


	
	ALTER TABLE [RDS].[DimK12Schools] DROP CONSTRAINT [DF__DimSchool__OutOf__431004E3];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[DimLeas]...';


	
	ALTER TABLE [RDS].[DimLeas] DROP CONSTRAINT [DF__DimLeas__OutOfSt__421BE0AA];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12ProgramParticipations]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [DF__FactK12Pr__Stude__37B75983];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_LeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_TitleIIIStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_K12StaffCategoryId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_K12StaffCategoryId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StaffCounts_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [DF_FactK12StaffCounts_SeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_RaceId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_TitleIStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_LeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_SeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_EnrollmentStatusId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentAssessments]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF__FactK12St__IeuId__3BBCF491];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_NorDProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_NorDProgramStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_AssessmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_AssessmentStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentAssessments_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CteStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_LeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_SeaId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_LanguageId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_LanguageId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_EnrollmentStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_TitleIIIStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_CohortStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_CohortStatusId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentCounts]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF__FactK12St__Speci__3DA53D03];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_NorDProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_NorDProgramStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_MigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_MigrantId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_AttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_AttendanceId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_TitleIStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentCounts_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF_FactK12StudentCounts_RaceId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentCounts]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [DF__FactK12St__IeuId__3CB118CA];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentCourseSections]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [DF__FactK12St__Stude__43290C2F];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_RaceId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentDisciplines]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF__FactK12St__IeuId__3E99613C];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_CteStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_DisciplineId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_DisciplineId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactK12StudentDisciplines_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [DF_FactK12StudentDisciplines_SeaId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactK12StudentEnrollments]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [DF__FactK12St__Stude__526B4FBF];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolManagerOrganizationId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolManagerOrganizationId];



	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_SchoolStateStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_SchoolStateStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_OrganizationStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_OrganizationStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId];



	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolStatusId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCounts]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF__FactOrgan__DimSu__209EEA01];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_CharterSchoolUpdatedManagerOrganizationId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolUpdatedManagerOrganizationId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCounts]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF__FactOrgan__DimCo__21930E3A];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_TitleIParentalInvolveRes]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_TitleIParentalInvolveRes];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationCounts_TitleIPartAAllocations]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [DF_FactOrganizationCounts_TitleIPartAAllocations];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationStatusCounts_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [DF_FactOrganizationStatusCounts_IdeaStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationStatusCounts_StateDefinedStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [DF_FactOrganizationStatusCounts_StateDefinedStatusId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationStatusCounts_DemographicId]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [DF_FactOrganizationStatusCounts_DemographicId];


	
	PRINT N'Dropping Default Constraint [RDS].[DF_FactOrganizationStatusCounts_RaceId]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [DF_FactOrganizationStatusCounts_RaceId];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactPsStudentAcademicRecords]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [DF__FactPsStu__Stude__694EB517];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactPsStudentEnrollments]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [DF__FactPsStu__Stude__73CC438A];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [cedsv8].[DimNorDProgramStatuses]...';


	
	ALTER TABLE [cedsv8].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Acade__16B25FB8];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [cedsv8].[DimNorDProgramStatuses]...';


	
	ALTER TABLE [cedsv8].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__LongT__163AFC67];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [cedsv8].[DimNorDProgramStatuses]...';


	
	ALTER TABLE [cedsv8].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Negle__172F20A0];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [cedsv8].[DimNorDProgramStatuses]...';


	
	ALTER TABLE [cedsv8].[DimNorDProgramStatuses] DROP CONSTRAINT [DF__DimNorDPr__Acade__17A683F1];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[DimProgramStatuses]...';


	
	ALTER TABLE [RDS].[DimProgramStatuses] DROP CONSTRAINT [DF__DimProgra__Homel__538663CE];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCountReportDtos]...';


	
	ALTER TABLE [RDS].[FactOrganizationCountReportDtos] DROP CONSTRAINT [DF__FactOrgan__Title__0D45C3B3];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCountReportDtos]...';


	
	ALTER TABLE [RDS].[FactOrganizationCountReportDtos] DROP CONSTRAINT [DF__FactOrgan__Title__0E39E7EC];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCountReports]...';


	
	ALTER TABLE [RDS].[FactOrganizationCountReports] DROP CONSTRAINT [DF__FactOrgan__Title__0F2E0C25];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCountReports]...';


	
	ALTER TABLE [RDS].[FactOrganizationCountReports] DROP CONSTRAINT [DF__FactOrgan__OutOf__7291CD77];


	
	PRINT N'Dropping Default Constraint unnamed constraint on [RDS].[FactOrganizationCountReports]...';


	
	ALTER TABLE [RDS].[FactOrganizationCountReports] DROP CONSTRAINT [DF__FactOrgan__Title__1022305E];


	-- 
	-- PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12SchoolGradeLevels_DimGradeLevels_DimGradeLevelId]...';


	-- 
	-- ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] DROP CONSTRAINT [FK_BridgeK12SchoolGradeLevels_DimGradeLevels_DimGradeLevelId];


	-- 
	-- PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12SchoolGradeLevels_DimK12Schools_DimK12SchoolId]...';


	-- 
	-- ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] DROP CONSTRAINT [FK_BridgeK12SchoolGradeLevels_DimK12Schools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_DimK12Staff];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSection];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentRaces_DimRaces]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_DimRaces];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId]...';


	
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [FK_BridgeLeaGradeLevels_DimGradeLevels_DimGradeLevelId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeLeaGradeLevels_DimLeas_DimLeaId]...';


	
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] DROP CONSTRAINT [FK_BridgeLeaGradeLevels_DimLeas_DimLeaId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgePsStudentEnrollmentRaces_DimRaces]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] DROP CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_DimRaces];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimAcademicTermDesignatorId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimAcademicTermDesignatorId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimAssessments_DimAssessmentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimAssessments_DimAssessmentId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimAssessmentStatuses_DimAssessmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimAssessmentStatuses_DimAssessmentStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimCteStatuses_DimCteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimCteStatuses_DimCteStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimFirearms_DimFirearmsId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimFirearms_DimFirearmsId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimIdeaStatuses]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimIdeaStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimIdeaStatuses_DimIdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimIdeaStatuses_DimIdeaStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimIdeaStatuses_DimIdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimIdeaStatuses_DimIdeaStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimIdeaStatuses]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimIdeaStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimIdeaStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimIdeaStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimIdeaStatuses_DimIdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimIdeaStatuses_DimIdeaStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimIeus]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimIeus];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimIeus]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimIeus];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimIeus]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimIeus];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimK12Courses]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Courses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimK12Schools]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Schools];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimSchools_DimK12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimSchools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimSchools_DimK12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimSchools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimK12Schools]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Schools];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimSchools_DimK12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimSchools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimSchools]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchools];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimK12Schools]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Schools];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimK12Schools_DimK12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimK12Schools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimSchools_DimK12SchoolId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimSchools_DimK12SchoolId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimSchoolStatuses_DimSchoolStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimK12StaffStatuses_DimK12StaffStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimLeas]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimLeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimLeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimLeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimLeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimLeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimLeas_DimLeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimLeas_DimLeaId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimLeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimLeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimLeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimLeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimLeas_DimLeaId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimLeas_DimLeaId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_DimPsInstitutions]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsInstitutions];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimPsInstitutions]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsInstitutions];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimPsInstitutions]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimPsInstitutions];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsInstitutionStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimPsInstitutionStatuses]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimPsInstitutionStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimScedCodes]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimScedCodes];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendance_DimSeas_DimSeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimSeas_DimSeaId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimSeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimSeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimSeas]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimSeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimSea]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimSea];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimSeas]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimSeas];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimSeas_DimSeaId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimSeas_DimSeaId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimTitleIiiStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimTitleIiiStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimTitleIIIStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimTitleIIIStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimTitleIIIStatuses_DimTitleiiiStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimTitleIIIStatuses_DimTitleiiiStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] DROP CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimCollections]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimCollections];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimK12Students]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Students];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimK12Demographics];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimK12ProgramTypes]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimK12ProgramTypes];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12ProgramParticipations_DimSchoolYears]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] DROP CONSTRAINT [FK_FactK12ProgramParticipations_DimSchoolYears];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimSchoolYear_DimSchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimSchoolYear_DimSchoolYearId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimK12Staff_DimK12StaffId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimK12Staff_DimK12StaffId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StaffCounts_DimK12StaffCategories_DimK12StaffCategoryId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] DROP CONSTRAINT [FK_FactK12StaffCounts_DimK12StaffCategories_DimK12StaffCategoryId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimSchoolYear_DimSchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimSchoolYear_DimSchoolYearId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimK12Students]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimK12Students];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimDemographics_DimDemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimDemographics_DimDemographicId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimGradeLevels_DimGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimGradeLevels_DimGradeLevelId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimNOrDProgramStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimNOrDProgramStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimProgramStatuses_DimProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimProgramStatuses_DimProgramStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAssessments_DimStudentStatuses_DimStudentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_DimStudentStatuses_DimStudentStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12AssessmentRaces_FactK12StudentAssessments]...';


	
	ALTER TABLE [RDS].[BridgeK12AssessmentRaces] DROP CONSTRAINT [FK_BridgeK12AssessmentRaces_FactK12StudentAssessments];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimDates_SpecialEducationServicesExitDate]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimDates_SpecialEducationServicesExitDate];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimAttendance]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimAttendance];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimCohortStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimCohortStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_FactK12StudentCounts]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_FactK12StudentCounts];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimAges_DimAgeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimAges_DimAgeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimGradeLevels_DimGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimGradeLevels_DimGradeLevelId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimLanguages_DimLanguageId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimLanguages_DimLanguageId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimMigrants_DimMigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimMigrants_DimMigrantId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimProgramStatuses_DimProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimProgramStatuses_DimProgramStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimRaces_DimRaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimRaces_DimRaceId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCounts_DimTitleIStatuses_DimTitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_DimTitleIStatuses_DimTitleIStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSection]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRace] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSection];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimCollection]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimCollection];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimK12Demographics];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimGradeLevels]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimGradeLevels];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimK12CourseStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimK12CourseStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimLanguages]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimLanguages];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimCipCodes]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimCipCodes];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimSchoolYears]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimSchoolYears];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentCourseSection_DimStudents]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] DROP CONSTRAINT [FK_FactK12StudentCourseSection_DimStudents];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimAges_DimAgeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimAges_DimAgeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimDisciplines_DimDisciplineId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimDisciplines_DimDisciplineId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimProgramStatuses_DimProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimProgramStatuses_DimProgramStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimRaces_DimRaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimRaces_DimRaceId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimK12Students_DimK12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimK12Students_DimK12StudentId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimFirearmDisciplines_DimFirearmsId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimFirearmDisciplines_DimFirearmsId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentDisciplines_DimGradeLevels_DimGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_DimGradeLevels_DimGradeLevelId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimCollection]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimCollection];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimEntryDates]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimEntryDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimEntryGradeLevels]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimEntryGradeLevels];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimExitDates]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimExitDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimExitGradeLevels]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimExitGradeLevels];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimProjectedGraduationDates]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimProjectedGraduationDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Demographics];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimK12EnrollmentStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimK12EnrollmentStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimK12Students]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimK12Students];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentEnrollments_DimSchoolYears]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] DROP CONSTRAINT [FK_FactK12StudentEnrollments_DimSchoolYears];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimK12Staff_DimK12StaffId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimK12Staff_DimK12StaffId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimTitleIStatuses_DimTitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimTitleIStatuses_DimTitleIStatusId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] DROP CONSTRAINT [FK_FactOrganizationCounts_DimComprehensiveSupportReasonApplicabilities_DimComprehensiveSupportReasonApplicabilityId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimK12Demographics];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimFactTypes]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimFactTypes];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimRaces]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimRaces];



	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimStateDefinedStatuses]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] DROP CONSTRAINT [FK_FactOrganizationStatusCounts_DimStateDefinedStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_DimAcademicAwardDates]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_DimAcademicAwardDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsAcademicAwardStatus];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_DimPsStudents]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] DROP CONSTRAINT [FK_FactPsStudentAcademicAwards_DimPsStudents];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimCollections]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimCollections];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimSchoolYears]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimSchoolYears];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsEnrollmentStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DimPsStudents]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] DROP CONSTRAINT [FK_FactPsStudentAcademicRecords_DimPsStudents];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimAges]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimAges];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimDataCollections]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimDataCollections];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimEntryDates]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimEntryDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimExitDates]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimExitDates];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimPsEnrollmentStatuses]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimPsEnrollmentStatuses];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimPsStudents]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimPsStudents];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactPsStudentEnrollments_DimSchoolYears]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] DROP CONSTRAINT [FK_FactPsStudentEnrollments_DimSchoolYears];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_DimSchoolYear_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId]...';


	
	ALTER TABLE [RDS].[DimSchoolYearDataMigrationTypes] DROP CONSTRAINT [FK_DimSchoolYear_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_DimDate_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypesId]...';


	
	ALTER TABLE [RDS].[DimDateDataMigrationTypes] DROP CONSTRAINT [FK_DimDate_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypesId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12AssessmentRaces_DimRaces]...';


	
	ALTER TABLE [RDS].[BridgeK12AssessmentRaces] DROP CONSTRAINT [FK_BridgeK12AssessmentRaces_DimRaces];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionRace_DimRace]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRace] DROP CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_DimRace];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_DimDate_DataMigrationTypes_DimDates_DimDateId]...';


	
	ALTER TABLE [RDS].[DimDateDataMigrationTypes] DROP CONSTRAINT [FK_DimDate_DataMigrationTypes_DimDates_DimDateId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_DimSchoolYear_DataMigrationTypes_DimSchoolYear_DimSchoolYearId]...';


	
	ALTER TABLE [RDS].[DimSchoolYearDataMigrationTypes] DROP CONSTRAINT [FK_DimSchoolYear_DataMigrationTypes_DimSchoolYear_DimSchoolYearId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendance_DimSchoolYears_DimSchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimSchoolYears_DimSchoolYearId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendance_DimDemographics_DimDemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimDemographics_DimDemographicId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendance] DROP CONSTRAINT [FK_FactK12StudentAttendance_DimFactTypes_DimFactTypeId];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_BridgeK12ProgramParticipationRaces_DimRaces]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] DROP CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_DimRaces];


	
	PRINT N'Dropping Foreign Key [RDS].[FK_DimFactType_DimensionTables_DimensionTables_DimensionTableId]...';


	
	ALTER TABLE [RDS].[DimFactType_DimensionTables] DROP CONSTRAINT [FK_DimFactType_DimensionTables_DimensionTables_DimensionTableId];


	
	PRINT N'Dropping Index [RDS].[DimCredentials].[IX_DimCredentials_CredentialTitle]...';


	
	DROP INDEX [IX_DimCredentials_CredentialTitle]
		ON [RDS].[DimCredentials];


	
	PRINT N'Dropping Table [RDS].[DimCredentials]...';


	
	DROP TABLE [RDS].[DimCredentials];


	
	PRINT N'Dropping Table [cedsv8].[DimEnrollment]...';


	
	DROP TABLE [cedsv8].[DimEnrollment];


	
	PRINT N'Dropping Table [cedsv8].[DimDemographics]...';


	
	DROP TABLE [cedsv8].[DimDemographics];


	
	PRINT N'Dropping Table [cedsv8].[DimNorDProgramStatuses]...';


	
	DROP TABLE [cedsv8].[DimNorDProgramStatuses];


	
	PRINT N'Dropping Table [cedsv8].[DimEnrollmentStatuses]...';


	
	DROP TABLE [cedsv8].[DimEnrollmentStatuses];


	
	PRINT N'Dropping Table [RDS].[FactK12StudentAttendanceReportDtos]...';


	
	DROP TABLE [RDS].[FactK12StudentAttendanceReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactOrganizationCountReportDtos]...';


	
	DROP TABLE [RDS].[FactOrganizationCountReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactOrganizationStatusCountReportDtos]...';


	
	DROP TABLE [RDS].[FactOrganizationStatusCountReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactPersonnelCountReportDtos]...';


	
	DROP TABLE [RDS].[FactPersonnelCountReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactStudentAssessmentReportDtos]...';


	
	DROP TABLE [RDS].[FactStudentAssessmentReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactStudentCountReportDtos]...';


	
	DROP TABLE [RDS].[FactStudentCountReportDtos];


	
	PRINT N'Dropping Table [RDS].[FactStudentDisciplineReportDtos]...';


	
	DROP TABLE [RDS].[FactStudentDisciplineReportDtos];


	--
	--PRINT N'Dropping Procedure [App].[DimK12Students_TestCase]...';


	--
	--DROP PROCEDURE [App].[DimK12Students_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[DimK12Staff_TestCase]...';


	--
	--DROP PROCEDURE [App].[DimK12Staff_TestCase];


	--
	--PRINT N'Dropping Procedure [app].[FS002_TestCase]...';


	--
	--DROP PROCEDURE [app].[FS002_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS005_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS005_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS029_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS029_TestCase];


	--
	--PRINT N'Dropping Procedure [app].[FS089_TestCase]...';


	--
	--DROP PROCEDURE [app].[FS089_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS116_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS116_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS141_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS141_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS175_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS175_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS178_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS178_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS179_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS179_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS185_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS185_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS188_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS188_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS189_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS189_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS194_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS194_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Chronic_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Chronic_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_CTE_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_CTE_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Dropout_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Dropout_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Grad_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Grad_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_gradrate_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_gradrate_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Homeless_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Homeless_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_HsGradEnroll_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_HsGradEnroll_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Immigrant_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Immigrant_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Membership_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Membership_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Mep_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Mep_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_NorD_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_NorD_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Other_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Other_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Assessments_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Assessments_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_SPPAPR_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_SPPAPR_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_StudentCounts_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_StudentCounts_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_TitleI_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_TitleI_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_titleIIIELOct_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_titleIIIELOct_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_TitleIIIELSY_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_TitleIIIELSY_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[FS006_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS006_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS007_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS007_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS009_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS009_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS070_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS070_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS088_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS088_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS099_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS099_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS112_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS112_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[FS143_TestCase]...';


	--
	--DROP PROCEDURE [App].[FS143_TestCase];


	--
	--PRINT N'Dropping Procedure [App].[Migrate_Data]...';


	--
	--DROP PROCEDURE [App].[Migrate_Data];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_ChildCount_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_ChildCount_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Directory_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Directory_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Discipline_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Discipline_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Exiting_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Exiting_to_RDS];


	--
	--PRINT N'Dropping Procedure [App].[Wrapper_Migrate_Personnel_to_RDS]...';


	--
	--DROP PROCEDURE [App].[Wrapper_Migrate_Personnel_to_RDS];


	--
	--PRINT N'Dropping Procedure [dbo].[FS212_TestCase]...';


	--
	--DROP PROCEDURE [dbo].[FS212_TestCase];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_Reports]...';


	--
	--DROP PROCEDURE [RDS].[Create_Reports];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_StudentFederalProgramsReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_StudentFederalProgramsReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_YeartoYearAttendanceReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_YeartoYearAttendanceReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Empty_Reports]...';


	--
	--DROP PROCEDURE [RDS].[Empty_Reports];


	--
	--PRINT N'Dropping Procedure [RDS].[Get_OrganizationReportData]...';


	--
	--DROP PROCEDURE [RDS].[Get_OrganizationReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Get_OrganizationStatusReportData]...';


	--
	--DROP PROCEDURE [RDS].[Get_OrganizationStatusReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimK12Schools]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimK12Schools];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimK12Staff]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimK12Staff];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimK12Students]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimK12Students];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimLeas]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimLeas];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimPsStudents]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimPsStudents];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_Organizations]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_Organizations];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSeas]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSeas];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_FactK12CourseSections]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_FactK12CourseSections];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_FactPsStudentAcademicAwards]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_FactPsStudentAcademicAwards];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_K12ProgramParticipation]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_K12ProgramParticipation];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_K12StaffCounts]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_K12StaffCounts];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_K12StudentEnrollments]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_K12StudentEnrollments];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_OrganizationCounts]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_OrganizationCounts];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_OrganizationStatusCounts]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_OrganizationStatusCounts];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_PsStudentAcademicRecords]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_PsStudentAcademicRecords];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_PsStudentEnrollments]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_PsStudentEnrollments];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_SpecialEdStudentCounts]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_SpecialEdStudentCounts];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_StudentAssessments]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_StudentAssessments];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_StudentAttendance]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_StudentAttendance];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_StudentCounts]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_StudentCounts];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_StudentDisciplines]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_StudentDisciplines];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_CharterSchoolManagementOrganization]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_CharterSchoolManagementOrganization];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_StateDefinedCustomIndicator]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_StateDefinedCustomIndicator];


	--
	--PRINT N'Dropping Procedure [Staging].[RUN_DMC]...';


	--
	--DROP PROCEDURE [Staging].[RUN_DMC];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-DimCharterSchoolAuthorizers]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-DimCharterSchoolAuthorizers];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-To-DimK12Staff]...';


	--
	--DROP PROCEDURE [Staging].[Staging-To-DimK12Staff];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-To-DimK12Students]...';


	--
	--DROP PROCEDURE [Staging].[Staging-To-DimK12Students];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-DimSeas]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-DimSeas];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactK12StaffCounts]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactK12StaffCounts];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactK12StudentCounts_ChildCount]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_ChildCount];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactK12StudentCounts_SpecEdExit]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_SpecEdExit];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactK12StudentCounts_TitleIII]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_TitleIII];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactK12StudentDisciplines]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactK12StudentDisciplines];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactOrganizationCounts]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactOrganizationCounts];


	--
	--PRINT N'Dropping Procedure [Staging].[Staging-to-FactOrganizationCounts_ComprehensiveAndTargetedSupport]...';


	--
	--DROP PROCEDURE [Staging].[Staging-to-FactOrganizationCounts_ComprehensiveAndTargetedSupport];


	--
	--PRINT N'Dropping Procedure [Staging].[ValidateStagingData]...';


	--
	--DROP PROCEDURE [Staging].[ValidateStagingData];


	--
	--PRINT N'Dropping Procedure [Staging].[ValidateStagingData_GetResults]...';


	--
	--DROP PROCEDURE [Staging].[ValidateStagingData_GetResults];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Assessment_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Assessment_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_ChildCount_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_ChildCount_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Chronic_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Chronic_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_CTE_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_CTE_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Directory_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Directory_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Discipline_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Discipline_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Dropout_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Dropout_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Exiting_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Exiting_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Grad_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Grad_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Gradrate_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Gradrate_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Homeless_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Homeless_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_HsGradEnroll_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_HsGradEnroll_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Immigrant_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Immigrant_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Membership_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Membership_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Mep_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Mep_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_NorD_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_NorD_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_Other_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_Other_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_SPPAPR_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_SPPAPR_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_StudentCounts_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_StudentCounts_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_TitleI_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_TitleI_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_TitleIIIELOct_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_TitleIIIELOct_to_IDS];


	--
	--PRINT N'Dropping Procedure [Staging].[Wrapper_Migrate_TitleIIIELSY_to_IDS]...';


	--
	--DROP PROCEDURE [Staging].[Wrapper_Migrate_TitleIIIELSY_to_IDS];


	--
	--PRINT N'Dropping Index [Staging].[PersonStatus].[IX_Staging_PersonStatus_IdeaStatusStartDate_WithIncludes2]...';


	--
	--DROP INDEX [IX_Staging_PersonStatus_IdeaStatusStartDate_WithIncludes2]
	--    ON [Staging].[PersonStatus];


	--
	--PRINT N'Dropping View [RDS].[vwDimComprehensiveAndTargetedSupports]...';


	--
	--DROP VIEW [RDS].[vwDimComprehensiveAndTargetedSupports];


	--
	--PRINT N'Dropping View [RDS].[vwDimComprehensiveSupportReasonApplicabilities]...';


	--
	--DROP VIEW [RDS].[vwDimComprehensiveSupportReasonApplicabilities];


	--
	--PRINT N'Dropping View [RDS].[vwDimCteStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimCteStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwDimDisciplines]...';


	--
	--DROP VIEW [RDS].[vwDimDisciplines];


	--
	--PRINT N'Dropping View [RDS].[vwDimK12OrganizationStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimK12OrganizationStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwDimK12SchoolStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimK12SchoolStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwDimK12StaffCategories]...';


	--
	--DROP VIEW [RDS].[vwDimK12StaffCategories];


	--
	--PRINT N'Dropping View [RDS].[vwDimK12StaffStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimK12StaffStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwDimMigrants]...';


	--
	--DROP VIEW [RDS].[vwDimMigrants];


	--
	--PRINT N'Dropping View [RDS].[vwDimSubgroups]...';


	--
	--DROP VIEW [RDS].[vwDimSubgroups];


	--
	--PRINT N'Dropping View [RDS].[vwDimTitleIIIStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimTitleIIIStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwDimTitleIStatuses]...';


	--
	--DROP VIEW [RDS].[vwDimTitleIStatuses];


	--
	--PRINT N'Dropping View [RDS].[vwUnduplicatedRaceMap]...';


	--
	--DROP VIEW [RDS].[vwUnduplicatedRaceMap];


	--TODO: Convert this to a table rename
	
	PRINT N'Dropping Table [RDS].[BridgeK12AssessmentRaces]...';


	
	DROP TABLE [RDS].[BridgeK12AssessmentRaces];


	--TODO: Convert this to a table rename

	
	PRINT N'Dropping Table [RDS].[BridgeK12StudentCourseSectionRace]...';


	
	DROP TABLE [RDS].[BridgeK12StudentCourseSectionRace];


	
	PRINT N'Dropping Table [RDS].[DimAttendance]...';


	
	DROP TABLE [RDS].[DimAttendance];


	
	PRINT N'Dropping Table [RDS].[DimComprehensiveSupportReasonApplicabilities]...';


	
	DROP TABLE [RDS].[DimComprehensiveSupportReasonApplicabilities];


	
	PRINT N'Dropping Table [RDS].[DimMigrants]...';


	
	DROP TABLE [RDS].[DimMigrants];


	
	PRINT N'Dropping Table [RDS].[DimNOrDProgramStatuses]...';


	
	DROP TABLE [RDS].[DimNOrDProgramStatuses];


	
	PRINT N'Dropping Table [RDS].[DimProgramStatuses]...';


	
	DROP TABLE [RDS].[DimProgramStatuses];


	
	PRINT N'Dropping Table [RDS].[FactK12StudentAssessmentReports]...';


	--TODO: Convert this to a table rename, if necessary
	
	DROP TABLE [RDS].[FactK12StudentAssessmentReports];


	
	PRINT N'Dropping Table [RDS].[FactK12StudentAttendanceReports]...';


	--TODO: Convert this to a table rename, if necessary
	
	DROP TABLE [RDS].[FactK12StudentAttendanceReports];


	
	PRINT N'Dropping Table [RDS].[FactOrganizationStatusCountReports]...';

	--TODO: Review if this should happen
	
	DROP TABLE [RDS].[FactOrganizationStatusCountReports];


	-- 
	-- PRINT N'Dropping Table [Staging].[K12SchoolComprehensiveSupportIdentificationType]...';


	-- --TODO: Review if this should happen
	-- 
	-- DROP TABLE [Staging].[K12SchoolComprehensiveSupportIdentificationType];
	EXECUTE sp_rename N'[Staging].[K12SchoolComprehensiveSupportIdentificationType].[LEA_Identifier_State]', N'LEAIdentifierSea';
	EXECUTE sp_rename N'[Staging].[K12SchoolComprehensiveSupportIdentificationType].[School_Identifier_State]', N'SchoolIdentifierSea';


	-- --TODO: Review if this should happen
	-- 
	-- PRINT N'Dropping Table [Staging].[K12SchoolTargetedSupportIdentificationType]...';


	
	DROP TABLE [Staging].[K12SchoolTargetedSupportIdentificationType];


	-- 
	-- PRINT N'Dropping Table [Staging].[StagingValidationResults]...';


	-- --TODO: Review if this should happen
	-- 
	-- DROP TABLE [Staging].[StagingValidationResults];


	-- 
	-- PRINT N'Dropping Table [Staging].[StagingValidationRules]...';


	-- --TODO: Review if this should happen
	-- 
	-- DROP TABLE [Staging].[StagingValidationRules];


	-- 
	-- PRINT N'Dropping Procedure [RDS].[Create_CustomReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_CustomReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_OrganizationReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_OrganizationReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_OrganizationStatusReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_OrganizationStatusReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Create_ReportData]...';


	--
	--DROP PROCEDURE [RDS].[Create_ReportData];


	--
	--PRINT N'Dropping Procedure [RDS].[Empty_RDS]...';


	--
	--DROP PROCEDURE [RDS].[Empty_RDS];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimAges]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimAges];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimAttendance]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimAttendance];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimDisciplines]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimDisciplines];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimGradeLevels]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimGradeLevels];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimScedCodes]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimScedCodes];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_K12Schools]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Schools];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_K12Staff]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Staff];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_K12Students]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Students];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_Leas]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_Leas];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_PsStudents]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_PsStudents];


	--
	--PRINT N'Dropping Procedure [RDS].[Migrate_DimSchoolYears_Seas]...';


	--
	--DROP PROCEDURE [RDS].[Migrate_DimSchoolYears_Seas];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_Assessment]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_Assessment];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_CompletelyClearDataFromODS];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_Discipline]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_Discipline];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_Migrant]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_Migrant];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_Organization]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_Organization];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_PersonRace]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_PersonRace];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_PersonStatus]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_PersonStatus];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_ProgramParticipationCTE]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationCTE];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_ProgramParticipationNorD]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationNorD];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_ProgramParticipationSpecialEducation]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationSpecialEducation];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleI]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleI];


	--
	--PRINT N'Dropping Procedure [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleIII]...';


	--
	--DROP PROCEDURE [Staging].[Migrate_StagingToIDS_ProgramParticipationTitleIII];


	--TODO: Check if this should happen.
	
	PRINT N'Dropping Table [RDS].[DimCharterSchoolStatus]...';


	
	DROP TABLE [RDS].[DimCharterSchoolStatus];


	--TODO: Review if this should happen
	
	-- PRINT N'Dropping Table [RDS].[DimDataMigrationTypes]...';


	-- 
	-- DROP TABLE [RDS].[DimDataMigrationTypes];


	-- 
	PRINT N'Dropping Table [RDS].[DimDateDataMigrationTypes]...';


	
	DROP TABLE [RDS].[DimDateDataMigrationTypes];


	
	PRINT N'Dropping Table [RDS].[DimDisciplines]...';


	--TODO: Review if this should happen
	
	DROP TABLE [RDS].[DimDisciplines];


	
	PRINT N'Dropping Table [RDS].[DimK12Staff]...';


	
	DROP TABLE [RDS].[DimK12Staff];


	
	PRINT N'Dropping Table [RDS].[DimK12Students]...';


	
	DROP TABLE [RDS].[DimK12Students];


	
	PRINT N'Dropping Table [RDS].[DimPsStudents]...';


	
	DROP TABLE [RDS].[DimPsStudents];


	
	--TODO: Review if this should happen
--	PRINT N'Dropping Table [RDS].[DimSchoolYearDataMigrationTypes]...';


	
--	DROP TABLE [RDS].[DimSchoolYearDataMigrationTypes];


	
	PRINT N'Dropping Table [RDS].[FactK12StudentAttendance]...';


	--TODO: Switch to rename
	
	DROP TABLE [RDS].[FactK12StudentAttendance];


	
	PRINT N'Dropping Table [RDS].[FactOrganizationCountReports]...';


	--TODO: Switch to rename
	
	DROP TABLE [RDS].[FactOrganizationCountReports];


	
	PRINT N'Dropping Table [Staging].[PersonRace]...';



	--TODO: Convert this in the OSC
	
	DROP TABLE [Staging].[PersonRace];


	-- 
	-- PRINT N'Starting rebuilding table [RDS].[BridgeK12SchoolGradeLevels]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_BridgeK12SchoolGradeLevels] (
		[BridgeK12SchoolGradeLevelId] INT IDENTITY (1, 1) NOT NULL,
		[K12SchoolId]                 INT CONSTRAINT [DF_BridgeK12SchoolGradeLevels_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelId]                INT CONSTRAINT [DF_BridgeK12SchoolGradeLevels_GradeLevelId] DEFAULT ((-1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_BridgeK12SchoolGradeLevels1] PRIMARY KEY CLUSTERED ([BridgeK12SchoolGradeLevelId] ASC)
	);

	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[BridgeK12SchoolGradeLevels])
		BEGIN
			INSERT INTO [RDS].[tmp_ms_xx_BridgeK12SchoolGradeLevels] ([K12SchoolId], [GradeLevelId])
			SELECT [K12SchoolId],
				   [GradeLevelId]
			FROM   [RDS].[BridgeK12SchoolGradeLevels];
		END

	DROP TABLE [RDS].[BridgeK12SchoolGradeLevels];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_BridgeK12SchoolGradeLevels]', N'BridgeK12SchoolGradeLevels';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_BridgeK12SchoolGradeLevels1]', N'PK_BridgeK12SchoolGradeLevels', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[BridgeK12SchoolGradeLevels].[IXFK_BridgeK12SchoolGradeLevels_DimK12Schools]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12SchoolGradeLevels_DimK12Schools]
		ON [RDS].[BridgeK12SchoolGradeLevels]([K12SchoolId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeK12SchoolGradeLevels].[IXFK_BridgeK12SchoolGradeLevels_GradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12SchoolGradeLevels_GradeLevelId]
		ON [RDS].[BridgeK12SchoolGradeLevels]([GradeLevelId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column FactK12StudentCourseSectionId on table [RDS].[BridgeK12StudentCourseSectionK12Staff] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

	The column K12StaffId on table [RDS].[BridgeK12StudentCourseSectionK12Staff] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[BridgeK12StudentCourseSectionK12Staff]...';


	
	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_BridgeK12StudentCourseSectionK12Staff] (
		[BridgeK12StudentCourseSectionK12StaffId] INT    IDENTITY (1, 1) NOT NULL,
		[K12StaffId]                              BIGINT    CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_K12StaffId] DEFAULT ((-1)) NOT NULL,
		[FactK12StudentCourseSectionId]           BIGINT CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSectionId] DEFAULT ((-1)) NOT NULL,
		[TeacherOfRecord]                         BIT    NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_BridgeK12StudentCourseSectionK12Staff1] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionK12StaffId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[BridgeK12StudentCourseSectionK12Staff])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_BridgeK12StudentCourseSectionK12Staff] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_BridgeK12StudentCourseSectionK12Staff] ([BridgeK12StudentCourseSectionK12StaffId], [K12StaffId], [FactK12StudentCourseSectionId], [TeacherOfRecord])
	--         SELECT   [BridgeK12StudentCourseSectionK12StaffId],
	--                  [K12StaffId],
	--                  [FactK12StudentCourseSectionId],
	--                  [TeacherOfRecord]
	--         FROM     [RDS].[BridgeK12StudentCourseSectionK12Staff]
	--         ORDER BY [BridgeK12StudentCourseSectionK12StaffId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_BridgeK12StudentCourseSectionK12Staff] OFF;
	--     END

	DROP TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_BridgeK12StudentCourseSectionK12Staff]', N'BridgeK12StudentCourseSectionK12Staff';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_BridgeK12StudentCourseSectionK12Staff1]', N'PK_BridgeK12StudentCourseSectionK12Staff', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]
		ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([FactK12StudentCourseSectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionK12Staff].[IXFK_BridgeK12StudentCourseSectionK12Staff_K12StaffId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionK12Staff_K12StaffId]
		ON [RDS].[BridgeK12StudentCourseSectionK12Staff]([K12StaffId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[BridgeK12StudentEnrollmentRaces]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] ALTER COLUMN [FactK12StudentEnrollmentId] BIGINT NOT NULL;

	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] ALTER COLUMN [RaceId] INT NOT NULL;


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentRaces].[IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]
		ON [RDS].[BridgeK12StudentEnrollmentRaces]([FactK12StudentEnrollmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentRaces].[IXFK_BridgeK12StudentEnrollmentRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentRaces_RaceId]
		ON [RDS].[BridgeK12StudentEnrollmentRaces]([RaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Starting rebuilding table [RDS].[BridgeLeaGradeLevels]...';


	
	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_BridgeLeaGradeLevels] (
		[BridgeLeaGradeLevelId] INT IDENTITY (1, 1) NOT NULL,
		[LeaId]                 INT CONSTRAINT [DF_BridgeLeaGradeLevels_LeaId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelId]          INT CONSTRAINT [DF_BridgeLeaGradeLevels_GradeLevelId] DEFAULT ((-1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_BridgeLeaGradeLevels1] PRIMARY KEY CLUSTERED ([BridgeLeaGradeLevelId] ASC)
	);

	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[BridgeLeaGradeLevels])
		BEGIN
			INSERT INTO [RDS].[tmp_ms_xx_BridgeLeaGradeLevels] ([LeaId], [GradeLevelId])
			SELECT [LeaId],
				   [GradeLevelId]
			FROM   [RDS].[BridgeLeaGradeLevels];
		END

	DROP TABLE [RDS].[BridgeLeaGradeLevels];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_BridgeLeaGradeLevels]', N'BridgeLeaGradeLevels';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_BridgeLeaGradeLevels1]', N'PK_BridgeLeaGradeLevels', N'OBJECT';



	
	PRINT N'Creating Index [RDS].[BridgeLeaGradeLevels].[IXFK_BridgeLeaGradeLevels_GradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeLeaGradeLevels_GradeLevelId]
		ON [RDS].[BridgeLeaGradeLevels]([GradeLevelId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeLeaGradeLevels].[IXFK_BridgeLeaGradeLevels_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeLeaGradeLevels_LeaId]
		ON [RDS].[BridgeLeaGradeLevels]([LeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[BridgePsStudentEnrollmentRaces]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] ALTER COLUMN [FactPsStudentEnrollmentId] BIGINT NOT NULL;

	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] ALTER COLUMN [RaceId] INT NOT NULL;


	
	PRINT N'Creating Index [RDS].[BridgePsStudentEnrollmentRaces].[IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]
		ON [RDS].[BridgePsStudentEnrollmentRaces]([FactPsStudentEnrollmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgePsStudentEnrollmentRaces].[IXFK_BridgePsStudentEnrollmentRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgePsStudentEnrollmentRaces_RaceId]
		ON [RDS].[BridgePsStudentEnrollmentRaces]([RaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Starting rebuilding table [RDS].[DimAcademicTermDesignators]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimAcademicTermDesignators] (
	    [DimAcademicTermDesignatorId]       INT            IDENTITY (1, 1) NOT NULL,
	    [AcademicTermDesignatorCode]        NVARCHAR (50)  NULL,
	    [AcademicTermDesignatorDescription] NVARCHAR (MAX) NULL,
	    CONSTRAINT [tmp_ms_xx_constraint_PK_DimAcademicTermDesignators1] PRIMARY KEY CLUSTERED ([DimAcademicTermDesignatorId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);

	IF EXISTS (SELECT TOP 1 1 
	           FROM   [RDS].[DimAcademicTermDesignators])
	    BEGIN
	        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAcademicTermDesignators] ON;
	        INSERT INTO [RDS].[tmp_ms_xx_DimAcademicTermDesignators] ([DimAcademicTermDesignatorId], [AcademicTermDesignatorCode], [AcademicTermDesignatorDescription])
	        SELECT   [DimAcademicTermDesignatorId],
	                 [AcademicTermDesignatorCode],
	                 [AcademicTermDesignatorDescription]
	        FROM     [RDS].[DimAcademicTermDesignators]
	        ORDER BY [DimAcademicTermDesignatorId] ASC;
	        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAcademicTermDesignators] OFF;
	    END

	DROP TABLE [RDS].[DimAcademicTermDesignators];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimAcademicTermDesignators]', N'DimAcademicTermDesignators';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimAcademicTermDesignators1]', N'PK_DimAcademicTermDesignators', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[DimAcademicTermDesignators].[IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAcademicTermDesignators_AcademicTermDesignatorCode]
	    ON [RDS].[DimAcademicTermDesignators]([AcademicTermDesignatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	-- 
	/*
	The column [RDS].[DimAssessments].[AssessmentSubjectCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentSubjectDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentSubjectEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentSubjectId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeAdministeredToEnglishLearnersCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeAdministeredToEnglishLearnersDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeAdministeredToEnglishLearnersEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeAdministeredToEnglishLearnersId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[AssessmentTypeId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[LeaFullYearStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[LeaFullYearStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[LeaFullYearStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[LeaFullYearStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[ParticipationStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[ParticipationStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[ParticipationStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[ParticipationStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[PerformanceLevelCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[PerformanceLevelDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[PerformanceLevelEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[PerformanceLevelId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SchFullYearStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SchFullYearStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SchFullYearStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SchFullYearStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SeaFullYearStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SeaFullYearStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SeaFullYearStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessments].[SeaFullYearStatusId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimAssessments]...';


	
	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimAssessments] (
		[DimAssessmentId]                      								INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentIdentifierState]            								NVARCHAR (40)  NULL,
		[AssessmentFamilyShortName]            								NVARCHAR (30)  NULL,
		[AssessmentTitle]                      								NVARCHAR (60)  NULL,
		[AssessmentShortName]                  								NVARCHAR (30)  NULL,
		[AssessmentTypeCode]                   								NVARCHAR (100) NULL,
		[AssessmentTypeDescription]            								NVARCHAR (300) NULL,
		[AssessmentTypeEdFactsCode]            								NVARCHAR (100) NULL,
		[AssessmentAcademicSubjectCode]        								NVARCHAR (100) NULL,
		[AssessmentAcademicSubjectDescription] 								NVARCHAR (300) NULL,
		[AssessmentAcademicSubjectEdFactsCode] 								NVARCHAR (50)  NULL,
		[AssessmentTypeAdministeredCode]                   					NVARCHAR (100) NULL,
		[AssessmentTypeAdministeredDescription]            					NVARCHAR (300) NULL,
		[AssessmentTypeAdministeredEdFactsCode]            					NVARCHAR (100) NULL,
		[AssessmentTypeAdministeredToEnglishLearnersCode]                   NVARCHAR (100) NULL,
		[AssessmentTypeAdministeredToEnglishLearnersDescription]            NVARCHAR (300) NULL,
		[AssessmentTypeAdministeredToEnglishLearnersEdFactsCode]            NVARCHAR (100) NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimAssessments1] PRIMARY KEY CLUSTERED ([DimAssessmentId] ASC) WITH (FILLFACTOR = 80)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[DimAssessments])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAssessments] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_DimAssessments] ([DimAssessmentId], [AssessmentTypeCode], [AssessmentTypeDescription])
	--         SELECT   [DimAssessmentId],
	--                  [AssessmentTypeCode],
	--                  [AssessmentTypeDescription]
	--         FROM     [RDS].[DimAssessments]
	--         ORDER BY [DimAssessmentId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAssessments] OFF;
	--     END

	DROP TABLE [RDS].[DimAssessments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimAssessments]', N'DimAssessments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimAssessments1]', N'PK_DimAssessments', N'OBJECT';



	
	PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentIdentifier]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessments_AssessmentIdentifier]
		ON [RDS].[DimAssessments]([AssessmentIdentifierState] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentShortName]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessments_AssessmentShortName]
		ON [RDS].[DimAssessments]([AssessmentShortName] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentSubjectEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessments_AssessmentSubjectEdFactsCode]
		ON [RDS].[DimAssessments]([AssessmentAcademicSubjectEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_AssessmentTitle]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessments_AssessmentTitle]
		ON [RDS].[DimAssessments]([AssessmentTitle] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimAssessments].[IX_DimAssessments_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessments_Codes]
		ON [RDS].[DimAssessments]([AssessmentAcademicSubjectCode] ASC) WITH (FILLFACTOR = 80);


	
	/*
	The column [RDS].[DimAssessmentStatuses].[AssessedFirstTimeId] is being dropped, data loss could occur.

	The column [RDS].[DimAssessmentStatuses].[AssessmentProgressLevelCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessmentStatuses].[AssessmentProgressLevelDescription] is being dropped, data loss could occur.

	The column [RDS].[DimAssessmentStatuses].[AssessmentProgressLevelEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimAssessmentStatuses].[AssessmentProgressLevelId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimAssessmentStatuses]...';


	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimAssessmentStatuses] (
		[DimAssessmentStatusId]                           INT            IDENTITY (1, 1) NOT NULL,
		[ProgressLevelCode]                               NVARCHAR (50)  NULL,
		[ProgressLevelDescription]                        NVARCHAR (100) NULL,
		[ProgressLevelEdFactsCode]                        NVARCHAR (50)  NULL,
		[AssessedFirstTimeCode]                           NVARCHAR (50)  NULL,
		[AssessedFirstTimeDescription]                    NVARCHAR (100) NULL,
		[AssessedFirstTimeEdFactsCode]                    NVARCHAR (50)  NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimAssessmentStatuses1] PRIMARY KEY CLUSTERED ([DimAssessmentStatusId] ASC) WITH (FILLFACTOR = 80)
	);

	--TODO: Verify no need to copy old data
	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[DimAssessmentStatuses])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAssessmentStatuses] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_DimAssessmentStatuses] ([DimAssessmentStatusId], [AssessedFirstTimeCode], [AssessedFirstTimeDescription], [AssessedFirstTimeEdFactsCode])
	--        SELECT   [DimAssessmentStatusId],
	--                 [AssessedFirstTimeCode],
	--                 [AssessedFirstTimeDescription],
	--                 [AssessedFirstTimeEdFactsCode]
	--        FROM     [RDS].[DimAssessmentStatuses]
	--        ORDER BY [DimAssessmentStatusId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimAssessmentStatuses] OFF;
	--    END

	DROP TABLE [RDS].[DimAssessmentStatuses];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimAssessmentStatuses]', N'DimAssessmentStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimAssessmentStatuses1]', N'PK_DimAssessmentStatuses', N'OBJECT';



	
	-- PRINT N'Creating Index [RDS].[DimAssessmentStatuses].[IX_DimAssessments_PerformanceLevelEdFactsCode]...';


	-- 
	-- CREATE NONCLUSTERED INDEX [IX_DimAssessments_PerformanceLevelEdFactsCode]
	-- 	ON [RDS].[DimAssessmentStatuses]([AssessmentPerformanceLevelIdentifierEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	-- 
	-- PRINT N'Creating Index [RDS].[DimAssessmentStatuses].[IX_DimAssessmentStatuses_Codes]...';


	-- 
	-- CREATE NONCLUSTERED INDEX [IX_DimAssessmentStatuses_Codes]
	-- 	ON [RDS].[DimAssessmentStatuses]([AssessmentPerformanceLevelIdentifier] ASC, [AssessmentPerformanceLevelIdentifierEdFactsCode] ASC, [ProgressLevelCode] ASC, [AssessmentTypeAdministeredCode] ASC, [AssessedFirstTimeCode] ASC, [AssessmentScoreMetricTypeCode] ASC) WITH (FILLFACTOR = 80);


	-- 
	--TODO: Verify this change
	PRINT N'Altering Table [RDS].[DimCohortStatuses]...';


	
	ALTER TABLE [RDS].[DimCohortStatuses] DROP COLUMN [CohortStatusId];


	
	PRINT N'Altering Primary Key [RDS].[PK_DimCohortStatus]...';


	
	ALTER INDEX [PK_DimCohortStatus]
		ON [RDS].[DimCohortStatuses] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[DimComprehensiveAndTargetedSupports]...';


	
	ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports] DROP COLUMN [AdditionalTargetedSupportandImprovementCode], COLUMN [AdditionalTargetedSupportandImprovementDescription], COLUMN [AdditionalTargetedSupportandImprovementEdFactsCode], COLUMN [AdditionalTargetedSupportandImprovementId], COLUMN [ComprehensiveAndTargetedSupportCode], COLUMN [ComprehensiveAndTargetedSupportDescription], COLUMN [ComprehensiveAndTargetedSupportEdFactsCode], COLUMN [ComprehensiveAndTargetedSupportId], COLUMN [ComprehensiveSupportCode], COLUMN [ComprehensiveSupportDescription], COLUMN [ComprehensiveSupportEdFactsCode], COLUMN [ComprehensiveSupportId], COLUMN [ComprehensiveSupportImprovementCode], COLUMN [ComprehensiveSupportImprovementDescription], COLUMN [ComprehensiveSupportImprovementEdFactsCode], COLUMN [ComprehensiveSupportImprovementId], COLUMN [TargetedSupportCode], COLUMN [TargetedSupportDescription], COLUMN [TargetedSupportEdFactsCode], COLUMN [TargetedSupportId], COLUMN [TargetedSupportImprovementCode], COLUMN [TargetedSupportImprovementDescription], COLUMN [TargetedSupportImprovementEdFactsCode], COLUMN [TargetedSupportImprovementId];


	
	ALTER TABLE [RDS].[DimComprehensiveAndTargetedSupports]
		ADD [ComprehensiveSupportIdentificationTypeCode]               VARCHAR (50)  NULL,
			[ComprehensiveSupportIdentificationTypeDescription]        VARCHAR (200) NULL,
			[ComprehensiveSupportIdentificationTypeEdFactsCode]        VARCHAR (50)  NULL,
			[AdditionalTargetedSupportAndImprovementStatusCode]        VARCHAR (50)  NULL,
			[AdditionalTargetedSupportAndImprovementStatusDescription] VARCHAR (200) NULL,
			[AdditionalTargetedSupportAndImprovementStatusEDFactsCode] VARCHAR (50)  NULL,
			[ComprehensiveSupportAndImprovementStatusCode]             VARCHAR (50)  NULL,
			[ComprehensiveSupportAndImprovementStatusDescription]      VARCHAR (200) NULL,
			[ComprehensiveSupportAndImprovementStatusEdFactsCode]      VARCHAR (50)  NULL,
			[TargetedSupportAndImprovementStatusCode]                  VARCHAR (50)  NULL,
			[TargetedSupportAndImprovementStatusDescription]           VARCHAR (200) NULL,
			[TargetedSupportAndImprovementStatusEdFactsCode]           VARCHAR (50)  NULL;


	
	PRINT N'Altering Primary Key [RDS].[PK_DimComprehensiveAndTargetedSupport]...';


	
	ALTER INDEX [PK_DimComprehensiveAndTargetedSupport]
		ON [RDS].[DimComprehensiveAndTargetedSupports] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[DimCredentials]...';


	
	CREATE TABLE [RDS].[DimCredentials] (
		[DimCredentialId]                                     BIGINT         IDENTITY (1, 1) NOT NULL,
		[CredentialDefinitionTitle]                           NVARCHAR (300) NOT NULL,
		[CredentialDefinitionDescription]                     NVARCHAR (MAX) NOT NULL,
		[CredentialDefinitionAlternateName]                   NVARCHAR (300) NULL,
		[CredentialDefinitionCategorySystem]                  NVARCHAR (30)  NULL,
		[CredentialDefinitionCategoryType]                    NVARCHAR (60)  NULL,
		[CredentialDefinitionStatusTypeCode]                  NVARCHAR (50)  NULL,
		[CredentialDefinitionStatusTypeDescription]           NVARCHAR (300) NULL,
		[CredentialDefinitionIntendedPurposeTypeCode]         NVARCHAR (50)  NULL,
		[CredentialDefinitionIntendedPurposeTypeDescription]  NVARCHAR (300) NULL,
		[CredentialDefinitionAssessmentMethodTypeCode]        NVARCHAR (50)  NULL,
		[CredentialDefinitionAssessmentMethodTypeDescription] NVARCHAR (300) NULL,
		CONSTRAINT [PK_DimCredentials] PRIMARY KEY CLUSTERED ([DimCredentialId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimCredentials].[IX_DimCredentials_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimCredentials_Codes]
		ON [RDS].[DimCredentials]([CredentialDefinitionCategorySystem] ASC, [CredentialDefinitionCategoryType] ASC, [CredentialDefinitionStatusTypeCode] ASC, [CredentialDefinitionIntendedPurposeTypeCode] ASC, [CredentialDefinitionAssessmentMethodTypeCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimCredentials].[IX_DimCredentials_CredentialDefinitionTitle]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimCredentials_CredentialDefinitionTitle]
		ON [RDS].[DimCredentials]([CredentialDefinitionTitle] ASC);


	
	/*
	The column [RDS].[DimCteStatuses].[CteAeDisplacedHomemakerIndicatorId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteGraduationRateInclusionId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteNontraditionalGenderStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteProgramCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteProgramDescription] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteProgramEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[CteProgramId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[LepPerkinsStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[LepPerkinsStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[LepPerkinsStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[LepPerkinsStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[RepresentationStatusCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[RepresentationStatusDescription] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[RepresentationStatusEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[RepresentationStatusId] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[SingleParentOrSinglePregnantWomanCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[SingleParentOrSinglePregnantWomanDescription] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[SingleParentOrSinglePregnantWomanEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimCteStatuses].[SingleParentOrSinglePregnantWomanId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimCteStatuses]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimCteStatuses] (
		[DimCteStatusId]                                     INT            IDENTITY (1, 1) NOT NULL,
		[CteAeDisplacedHomemakerIndicatorCode]               NVARCHAR (50)  NULL,
		[CteAeDisplacedHomemakerIndicatorDescription]        NVARCHAR (200) NULL,
		[CteAeDisplacedHomemakerIndicatorEdFactsCode]        NVARCHAR (50)  NULL,
		[CteNontraditionalGenderStatusCode]                  NVARCHAR (50)  NULL,
		[CteNontraditionalGenderStatusDescription]           NVARCHAR (200) NULL,
		[CteNontraditionalGenderStatusEdFactsCode]           NVARCHAR (50)  NULL,
		[CteNontraditionalCompletionCode]                    NVARCHAR (50)  NULL,
		[CteNontraditionalCompletionDescription]             NVARCHAR (200) NULL,
		[CteNontraditionalCompletionEdFactsCode]             NVARCHAR (50)  NULL,
		[SingleParentOrSinglePregnantWomanStatusCode]        NVARCHAR (50)  NULL,
		[SingleParentOrSinglePregnantWomanStatusDescription] NVARCHAR (200) NULL,
		[SingleParentOrSinglePregnantWomanStatusEdFactsCode] NVARCHAR (50)  NULL,
		[CteGraduationRateInclusionCode]                     NVARCHAR (450) NULL,
		[CteGraduationRateInclusionDescription]              NVARCHAR (200) NULL,
		[CteGraduationRateInclusionEdFactsCode]              NVARCHAR (50)  NULL,
		[CteParticipantCode]                                 NVARCHAR (50)  NULL,
		[CteParticipantDescription]                          NVARCHAR (200) NULL,
		[CteParticipantEdFactsCode]                          NVARCHAR (50)  NULL,
		[CteConcentratorCode]                                NVARCHAR (50)  NULL,
		[CteConcentratorDescription]                         NVARCHAR (200) NULL,
		[CteConcentratorEdFactsCode]                         NVARCHAR (50)  NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimCteStatuses1] PRIMARY KEY CLUSTERED ([DimCteStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);

	--TODO: Verify no need to copy old data
	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[DimCteStatuses])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCteStatuses] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_DimCteStatuses] ([DimCteStatusId], [CteAeDisplacedHomemakerIndicatorCode], [CteAeDisplacedHomemakerIndicatorDescription], [CteAeDisplacedHomemakerIndicatorEdFactsCode], [CteNontraditionalGenderStatusCode], [CteNontraditionalGenderStatusDescription], [CteNontraditionalGenderStatusEdFactsCode], [CteGraduationRateInclusionCode], [CteGraduationRateInclusionDescription], [CteGraduationRateInclusionEdFactsCode])
	--        SELECT   [DimCteStatusId],
	--                 [CteAeDisplacedHomemakerIndicatorCode],
	--                 [CteAeDisplacedHomemakerIndicatorDescription],
	--                 [CteAeDisplacedHomemakerIndicatorEdFactsCode],
	--                 [CteNontraditionalGenderStatusCode],
	--                 [CteNontraditionalGenderStatusDescription],
	--                 [CteNontraditionalGenderStatusEdFactsCode],
	--                 [CteGraduationRateInclusionCode],
	--                 [CteGraduationRateInclusionDescription],
	--                 [CteGraduationRateInclusionEdFactsCode]
	--        FROM     [RDS].[DimCteStatuses]
	--        ORDER BY [DimCteStatusId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCteStatuses] OFF;
	--    END

	DROP TABLE [RDS].[DimCteStatuses];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimCteStatuses]', N'DimCteStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimCteStatuses1]', N'PK_DimCteStatuses', N'OBJECT';



	--Alter table [RDS].[DimFirearms] and update DimFirearmsId

	EXECUTE sp_rename N'[RDS].[DimFirearms].[DimFirearmsId]', N'DimFirearmId';


	
	PRINT N'Renaming/Rebuilding Table [RDS].[DimFirearmDisciplines]...';

	CREATE TABLE [RDS].[tmp_ms_xx_DimFirearmDisciplineStatuses](
		[DimFirearmDisciplineStatusId] 							[int] IDENTITY(1,1) 	NOT NULL,
		[DisciplineMethodForFirearmsIncidentsCode] 				[nvarchar](50) 			NULL,
		[DisciplineMethodForFirearmsIncidentsDescription] 		[nvarchar](max) 		NULL,
		[DisciplineMethodForFirearmsIncidentsEdFactsCode] 		[nvarchar](50) 			NULL,
		[IdeaDisciplineMethodForFirearmsIncidentsCode] 			[nvarchar](50) 			NULL,
		[IdeaDisciplineMethodForFirearmsIncidentsDescription] 	[nvarchar](max) 		NULL,
		[IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode] 	[nvarchar](50) 			NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimFirearmDisciplineStatuses1] PRIMARY KEY CLUSTERED ([DimFirearmDisciplineStatusId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [RDS].[DimFirearmDisciplines];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimFirearmDisciplineStatuses]', N'DimFirearmDisciplineStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimFirearmDisciplineStatuses1]', N'PK_DimFirearmDisciplineStatuses', N'OBJECT';



	
	PRINT N'Altering Table [RDS].[DimGradeLevels]...';


	
	ALTER TABLE [RDS].[DimGradeLevels] DROP COLUMN [GradeLevelId];


	
	PRINT N'Altering Primary Key [RDS].[PK_DimGradeLevels]...';


	
	ALTER INDEX [PK_DimGradeLevels]
		ON [RDS].[DimGradeLevels] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimGradeLevels].[IX_DimGradeLevels_GradeLevelCode]...';


	
	ALTER INDEX [IX_DimGradeLevels_GradeLevelCode]
		ON [RDS].[DimGradeLevels] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[DimIdeaStatuses].[IdeaEducationalEnvironmentCode] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[IdeaEducationalEnvironmentDescription] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[IdeaEducationalEnvironmentEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[IdeaEducationalEnvironmentId] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[IdeaIndicatorId] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[PrimaryDisabilityTypeCode] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[PrimaryDisabilityTypeDescription] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[PrimaryDisabilityTypeEdFactsCode] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[PrimaryDisabilityTypeId] is being dropped, data loss could occur.

	The column [RDS].[DimIdeaStatuses].[SpecialEducationExitReasonId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimIdeaStatuses]...';


	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimIdeaStatuses] (
		[DimIdeaStatusId]                                        INT            IDENTITY (1, 1) NOT NULL,
		[SpecialEducationExitReasonCode]                         NVARCHAR (50)  NULL,
		[SpecialEducationExitReasonDescription]                  NVARCHAR (200) NULL,
		[SpecialEducationExitReasonEdFactsCode]                  NVARCHAR (50)  NULL,
		[IdeaEducationalEnvironmentForSchoolAgeDescription]      NVARCHAR (200) NULL,
		[IdeaEducationalEnvironmentForSchoolAgeCode]             NVARCHAR (50)  NULL,
		[IdeaEducationalEnvironmentForSchoolAgeEdFactsCode]      NVARCHAR (50)  NULL,
		[IdeaIndicatorCode]                                      NVARCHAR (50)  NULL,
		[IdeaIndicatorDescription]                               NVARCHAR (200) NULL,
		[IdeaIndicatorEdFactsCode]                               NVARCHAR (50)  NULL,
		[IdeaEducationalEnvironmentForEarlyChildhoodCode]        NVARCHAR (50)  NULL,
		[IdeaEducationalEnvironmentForEarlyChildhoodDescription] NVARCHAR (200) NULL,
		[IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimIdeaStatuses1] PRIMARY KEY CLUSTERED ([DimIdeaStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	--TODO: Verify no need to copy old data
	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[DimIdeaStatuses])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimIdeaStatuses] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_DimIdeaStatuses] ([DimIdeaStatusId], [SpecialEducationExitReasonCode], [SpecialEducationExitReasonDescription], [SpecialEducationExitReasonEdFactsCode], [IdeaIndicatorCode], [IdeaIndicatorDescription], [IdeaIndicatorEdFactsCode])
	--        SELECT   [DimIdeaStatusId],
	--                 [SpecialEducationExitReasonCode],
	--                 [SpecialEducationExitReasonDescription],
	--                 [SpecialEducationExitReasonEdFactsCode],
	--                 [IdeaIndicatorCode],
	--                 [IdeaIndicatorDescription],
	--                 [IdeaIndicatorEdFactsCode]
	--        FROM     [RDS].[DimIdeaStatuses]
	--        ORDER BY [DimIdeaStatusId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimIdeaStatuses] OFF;iso
	--    END

	DROP TABLE [RDS].[DimIdeaStatuses];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimIdeaStatuses]', N'DimIdeaStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimIdeaStatuses1]', N'PK_DimIdeaStatuses', N'OBJECT';



	
	PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_BasisOfExitEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_BasisOfExitEdFactsCode]
		ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_Codes]
		ON [RDS].[DimIdeaStatuses]([SpecialEducationExitReasonCode] ASC, [IdeaEducationalEnvironmentForSchoolAgeCode] ASC, [IdeaEducationalEnvironmentForEarlyChildhoodCode] ASC, [IdeaIndicatorCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_EducEnvEarlyChildhoodEdFactsCode]
		ON [RDS].[DimIdeaStatuses]([IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimIdeaStatuses].[IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_EducEnvSchoolAgeEdFactsCode]
		ON [RDS].[DimIdeaStatuses]([IdeaEducationalEnvironmentForSchoolAgeEdFactsCode] ASC);

	
	
	PRINT N'Altering Table [RDS].[DimK12Courses]...';

	/*
	The column [RDS].[DimK12Courses].[CourseCodeSystemDesciption] is being renamed.
	*/
	
	EXECUTE sp_rename N'[RDS].[DimK12Courses].[CourseCodeSystemDesciption]', N'CourseCodeSystemDescription';


	
	PRINT N'Altering Table [RDS].[DimK12Demographics]...';

	/*
	The column [RDS].[DimK12Demographics].[EconomicDisadvantageStatusCode] is being moved.
	The column [RDS].[DimK12Demographics].[EconomicDisadvantageStatusDescription] is being moved.
	The column [RDS].[DimK12Demographics].[EconomicDisadvantageStatusEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[EnglishLearnerStatusCode] is being moved.
	The column [RDS].[DimK12Demographics].[EnglishLearnerStatusDescription] is being moved.
	The column [RDS].[DimK12Demographics].[EnglishLearnerStatusEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessnessStatusCode] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessnessStatusDescription] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessnessStatusEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessPrimaryNighttimeResidenceCode] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessPrimaryNighttimeResidenceDescription] is being moved.
	The column [RDS].[DimK12Demographics].[HomelessPrimaryNighttimeResidenceEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[MigrantStatusCode] is being moved.
	The column [RDS].[DimK12Demographics].[MigrantStatusDescription] is being moved.
	The column [RDS].[DimK12Demographics].[MigrantStatusEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[MilitaryConnectedStudentIndicatorCode] is being moved.
	The column [RDS].[DimK12Demographics].[MilitaryConnectedStudentIndicatorDescription] is being moved.
	The column [RDS].[DimK12Demographics].[MilitaryConnectedStudentIndicatorEdFactsCode] is being moved.
	The column [RDS].[DimK12Demographics].[SexCode] is being added.
	The column [RDS].[DimK12Demographics].[SexDescription] is being added.
	The column [RDS].[DimK12Demographics].[SexEdFactsCode] is being added.

	*/


	
	DELETE FROM [RDS].[DimK12Demographics]
	DBCC CHECKIDENT('rds.DimK12Demographics', RESEED, 1);
	ALTER TABLE [RDS].[DimK12Demographics] DROP COLUMN [EconomicDisadvantageStatusCode], COLUMN [EconomicDisadvantageStatusDescription], COLUMN [EconomicDisadvantageStatusEdFactsCode], COLUMN [EnglishLearnerStatusCode], COLUMN [EnglishLearnerStatusDescription], COLUMN [EnglishLearnerStatusEdFactsCode], COLUMN [HomelessnessStatusCode], COLUMN [HomelessnessStatusDescription], COLUMN [HomelessnessStatusEdFactsCode], COLUMN [HomelessPrimaryNighttimeResidenceCode], COLUMN [HomelessPrimaryNighttimeResidenceDescription], COLUMN [HomelessPrimaryNighttimeResidenceEdFactsCode], COLUMN [HomelessUnaccompaniedYouthStatusCode], COLUMN [HomelessUnaccompaniedYouthStatusDescription], COLUMN [HomelessUnaccompaniedYouthStatusEdFactsCode], COLUMN [MigrantStatusCode], COLUMN [MigrantStatusDescription], COLUMN [MigrantStatusEdFactsCode], COLUMN [MilitaryConnectedStudentIndicatorCode], COLUMN [MilitaryConnectedStudentIndicatorDescription], COLUMN [MilitaryConnectedStudentIndicatorEdFactsCode];


	
	ALTER TABLE [RDS].[DimK12Demographics]
		ADD [SexCode]        NVARCHAR (50)  NULL,
			[SexDescription] NVARCHAR (200) NULL,
			[SexEdFactsCode] NVARCHAR (50)  NULL;


	
	PRINT N'Creating Index [RDS].[DimK12Demographics].[IX_DimK12Demographics_SexEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12Demographics_SexEdFactsCode]
		ON [RDS].[DimK12Demographics]([SexEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[DimK12EnrollmentStatuses]...';


	
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalOutcomeCode]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode';
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalOutcomeDescription]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription';
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalOutcomeEdFactsCode]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode';
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalExitOutcomeCode]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode';
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalExitOutcomeDescription]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription';
	EXECUTE sp_rename N'[RDS].[DimK12EnrollmentStatuses].[AcademicOrVocationalExitOutcomeEdFactsCode]', N'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode';

	
	PRINT N'Altering Index [RDS].[DimK12EnrollmentStatuses].[IX_DimK12EnrollmentStatuses_Codes]...';


	
	ALTER INDEX [IX_DimK12EnrollmentStatuses_Codes]
		ON [RDS].[DimK12EnrollmentStatuses] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimK12EnrollmentStatuses].[IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode]...';


	
	ALTER INDEX [IX_DimK12EnrollmentStatuses_PostSecondaryEnrollmentStatusEdFactsCode]
		ON [RDS].[DimK12EnrollmentStatuses] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[DimK12OrganizationStatuses]...';


	
	ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientCode] NVARCHAR (50) NULL;

	ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientDescription] NVARCHAR (MAX) NULL;

	ALTER TABLE [RDS].[DimK12OrganizationStatuses] ALTER COLUMN [McKinneyVentoSubgrantRecipientEdFactsCode] NVARCHAR (50) NULL;


	PRINT N'Rebuilding Table [RDS].[DimCharterSchoolAuthorizers]...';

	/*
	The column [RDS].[DimCharterSchoolAuthorizers].[StateIdentifier] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[StateCode] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[State] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[Name] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[MailingAddressStreet] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[PhysicalAddressStreet] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[Telephone] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[Website] renamed.
	The column [RDS].[DimCharterSchoolAuthorizers].[SchoolStateIdentifier] dropped.
	*/
	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ciid_xx_DimCharterSchoolAuthorizers] (
		  [CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea] [nvarchar](max) NULL
		, [RecordStartDateTime] [datetime] NULL
		, [RecordEndDateTime] [datetime] NULL
	)

	INSERT INTO [RDS].[tmp_ciid_xx_DimCharterSchoolAuthorizers]
	SELECT 
		[StateIdentifier]
		, [RecordStartDateTime]
		, [RecordEndDateTime]
	FROM [RDS].[DimCharterSchoolAuthorizers]


	CREATE TABLE [RDS].[tmp_ms_xx_DimCharterSchoolAuthorizers] (
		[DimCharterSchoolAuthorizerId] [int] IDENTITY(1,1) NOT NULL,
		[CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea] [nvarchar](max) NULL,
		[CharterSchoolAuthorizingOrganizationOrganizationName] [nvarchar](max) NULL,
		[CharterSchoolAuthorizerTypeCode] [nvarchar](50) NULL,
		[CharterSchoolAuthorizerTypeDescription] [nvarchar](100) NULL,
		[CharterSchoolAuthorizerTypeEdFactsCode] [nvarchar](50) NULL,
		[StateAbbreviationCode] [nvarchar](max) NULL,
		[StateANSICode] [nvarchar](max) NULL,
		[StateAbbreviationDescription] [nvarchar](max) NULL,
		[MailingAddressStreetNumberAndName] [nvarchar](150) NULL,
		[MailingAddressApartmentRoomOrSuiteNumber] [varchar](40) NULL,
		[MailingAddressCity] [nvarchar](30) NULL,
		[MailingAddressPostalCode] [nvarchar](17) NULL,
		[MailingAddressStateAbbreviation] [nvarchar](50) NULL,
		[MailingAddressCountyAnsiCodeCode] [char](5) NULL,
		[PhysicalAddressStreetNumberAndName] [nvarchar](150) NULL,
		[PhysicalAddressApartmentRoomOrSuiteNumber] [varchar](40) NULL,
		[PhysicalAddressCity] [nvarchar](30) NULL,
		[PhysicalAddressPostalCode] [nvarchar](17) NULL,
		[PhysicalAddressStateAbbreviation] [nvarchar](50) NULL,
		[PhysicalAddressCountyAnsiCodeCode] [char](5) NULL,
		[TelephoneNumber] [nvarchar](24) NULL,
		[WebSiteAddress] [nvarchar](300) NULL,
		[OutOfStateIndicator] [bit] NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
	 CONSTRAINT [tmp_ms_xx_PK_DimCharterSchoolAuthorizer] PRIMARY KEY CLUSTERED ([DimCharterSchoolAuthorizerId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) 

	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[DimCharterSchoolAuthorizers])
		BEGIN
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCharterSchoolAuthorizers] ON;
			INSERT INTO [RDS].[tmp_ms_xx_DimCharterSchoolAuthorizers] (
					  [DimCharterSchoolAuthorizerId]
					, [CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea]
					, [StateAbbreviationDescription]
					, [StateAbbreviationCode]
					, [CharterSchoolAuthorizingOrganizationOrganizationName]
					, [StateANSICode]
					, [CharterSchoolAuthorizerTypeCode]
					, [CharterSchoolAuthorizerTypeDescription]
					, [CharterSchoolAuthorizerTypeEdFactsCode]
					, [MailingAddressStreetNumberAndName]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressStateAbbreviation]
					, [MailingAddressCountyAnsiCodeCode]
					, [PhysicalAddressStreetNumberAndName]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressStateAbbreviation]
					, [PhysicalAddressCountyAnsiCodeCode]
					, [TelephoneNumber]
					, [WebSiteAddress]
					, [OutOfStateIndicator] 
					, [RecordStartDateTime] 
					, [RecordEndDateTime]
			)
			SELECT    MIN([DimCharterSchoolAuthorizerId])
					, [StateIdentifier]
					, [StateCode]
					, [State]
					, [Name]
					, [StateANSICode]
					, [CharterSchoolAuthorizerTypeCode]
					, [CharterSchoolAuthorizerTypeDescription]
					, [CharterSchoolAuthorizerTypeEdFactsCode]
					, [MailingAddressStreet]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressState]
					, [MailingCountyAnsiCode]
					, [PhysicalAddressStreet]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressState]
					, [PhysicalCountyAnsiCode]
					, [Telephone]
					, [Website]
					, [OutOfStateIndicator]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
			FROM     [RDS].[DimCharterSchoolAuthorizers]
			GROUP BY  [StateIdentifier]
					, [StateCode]
					, [State]
					, [Name]
					, [StateANSICode]
					, [CharterSchoolAuthorizerTypeCode]
					, [CharterSchoolAuthorizerTypeDescription]
					, [CharterSchoolAuthorizerTypeEdFactsCode]
					, [MailingAddressStreet]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressState]
					, [MailingCountyAnsiCode]
					, [PhysicalAddressStreet]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressState]
					, [PhysicalCountyAnsiCode]
					, [Telephone]
					, [Website]
					, [OutOfStateIndicator]
					, [RecordStartDateTime]
					, [RecordEndDateTime];
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCharterSchoolAuthorizers] OFF;
		END

	DROP TABLE [RDS].[DimCharterSchoolAuthorizers];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimCharterSchoolAuthorizers]', N'DimCharterSchoolAuthorizers';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_PK_DimCharterSchoolAuthorizer]', N'PK_DimCharterSchoolAuthorizers', N'OBJECT';


	


	PRINT N'Altering Table [RDS].[DimCharterSchoolManagementOrganizations]...';

	

	SET XACT_ABORT ON;


	CREATE TABLE [RDS].[tmp_ciid_xx_DimCharterSchoolManagementOrganizations](
		  [CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea] [nvarchar](max) NULL
		, [RecordStartDateTime] [datetime] NULL
		, [RecordEndDateTime] [datetime] NULL
	)

	INSERT INTO [RDS].[tmp_ciid_xx_DimCharterSchoolManagementOrganizations]
	SELECT 
		  [StateIdentifier]
		, [RecordStartDateTime]
		, [RecordEndDateTime]
	FROM [RDS].[DimCharterSchoolManagementOrganizations]

	CREATE TABLE [RDS].[tmp_ms_xx_DimCharterSchoolManagementOrganizations](
		[DimCharterSchoolManagementOrganizationId] [int] IDENTITY(1,1) NOT NULL,
		[CharterSchoolManagementOrganizationOrganizationName] [nvarchar](max) NULL,
		[CharterSchoolManagementOrganizationOrganizationIdentifierSea] [nvarchar](max) NULL,
		[StateAbbreviationDescription] [nvarchar](max) NULL,
		[StateAbbreviationCode] [nvarchar](max) NULL,
		[StateANSICode] [nvarchar](max) NULL,
		[CharterSchoolManagementOrganizationTypeCode] [nvarchar](50) NULL,
		[CharterSchoolManagementOrganizationTypeDescription] [nvarchar](100) NULL,
		[CharterSchoolManagementOrganizationTypeEdfactsCode] [nvarchar](50) NULL,
		[MailingAddressCity] [nvarchar](30) NULL,
		[MailingAddressPostalCode] [nvarchar](17) NULL,
		[MailingAddressStateAbbreviation] [nvarchar](50) NULL,
		[MailingAddressStreetNumberAndName] [nvarchar](150) NULL,
		[PhysicalAddressCity] [nvarchar](30) NULL,
		[PhysicalAddressPostalCode] [nvarchar](17) NULL,
		[PhysicalAddressStateAbbreviation] [nvarchar](50) NULL,
		[PhysicalAddressStreetNumberAndName] [nvarchar](150) NULL,
		[TelephoneNumber] [nvarchar](24) NULL,
		[WebSiteAddress] [nvarchar](300) NULL,
		[OutOfStateIndicator] [bit] NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[OrganizationIdentifierFein] [varchar](50) NULL,
	 CONSTRAINT [tmp_ms_xx_PK_DimCharterSchoolManagementOrganization] PRIMARY KEY CLUSTERED 
	(
		[DimCharterSchoolManagementOrganizationId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	


	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[DimCharterSchoolManagementOrganizations])
		BEGIN
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCharterSchoolManagementOrganizations] ON;
			INSERT INTO [RDS].[tmp_ms_xx_DimCharterSchoolManagementOrganizations] (
					  [DimCharterSchoolManagementOrganizationId]
					, [CharterSchoolManagementOrganizationOrganizationName]
					, [CharterSchoolManagementOrganizationOrganizationIdentifierSea]
					, [StateAbbreviationDescription]
					, [StateAbbreviationCode]
					, [StateANSICode]
					, [CharterSchoolManagementOrganizationTypeCode]
					, [CharterSchoolManagementOrganizationTypeDescription]
					, [CharterSchoolManagementOrganizationTypeEdfactsCode]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressStateAbbreviation]
					, [MailingAddressStreetNumberAndName]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressStateAbbreviation]
					, [PhysicalAddressStreetNumberAndName]
					, [TelephoneNumber]
					, [WebSiteAddress]
					, [OutOfStateIndicator]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
					, [OrganizationIdentifierFein]
					)
			SELECT    MIN([DimCharterSchoolManagementOrganizationId])
					, [Name]
					, [StateIdentifier]
					, [State]
					, [StateCode]
					, [StateANSICode]
					, [CharterSchoolManagementOrganizationCode]
					, [CharterSchoolManagementOrganizationTypeDescription]
					, [CharterSchoolManagementOrganizationTypeEdfactsCode]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressState]
					, [MailingAddressStreet]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressState]
					, [PhysicalAddressStreet]
					, [Telephone]
					, [Website]
					, [OutOfStateIndicator]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
					, [EmployerIdentificationNumber]
			FROM     [RDS].[DimCharterSchoolManagementOrganizations]
			GROUP BY  [Name]
					, [StateIdentifier]
					, [State]
					, [StateCode]
					, [StateANSICode]
					, [CharterSchoolManagementOrganizationCode]
					, [CharterSchoolManagementOrganizationTypeDescription]
					, [CharterSchoolManagementOrganizationTypeEdfactsCode]
					, [MailingAddressCity]
					, [MailingAddressPostalCode]
					, [MailingAddressState]
					, [MailingAddressStreet]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressState]
					, [PhysicalAddressStreet]
					, [Telephone]
					, [Website]
					, [OutOfStateIndicator]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
					, [EmployerIdentificationNumber];
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimCharterSchoolManagementOrganizations] OFF;
		END

	DROP TABLE [RDS].[DimCharterSchoolManagementOrganizations];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimCharterSchoolManagementOrganizations]', N'DimCharterSchoolManagementOrganizations';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_PK_DimCharterSchoolManagementOrganization]', N'PK_DimCharterSchoolManagementOrganizations', N'OBJECT';


	/*
	The column [RDS].[DimK12Schools].[CharterSchoolAuthorizerIdPrimary] is being dropped.
	The column [RDS].[DimK12Schools].[CharterSchoolAuthorizerIdSecondary] is being dropped.
	The column [RDS].[DimK12Schools].[IeuIdentifierState] is being renamed.
	The column [RDS].[DimK12Schools].[IeuName] is being renamed.
	The column [RDS].[DimK12Schools].[LeaIdentifierState] renamed.
	The column [RDS].[DimK12Schools].[LeaName] renamed.
	The column [RDS].[DimK12Schools].[LeaOrganizationId] dropped.
	The column [RDS].[DimK12Schools].[LeaTypeId] dropped.
	The column [RDS].[DimK12Schools].[MailingAddressState] renamed.
	The column [RDS].[DimK12Schools].[MailingAddressStreet] renamed.
	The column [RDS].[DimK12Schools].[MailingAddressStreet2] renamed.
	The column [RDS].[DimK12Schools].[MailingCountyAnsiCode] renamed.
	The column [RDS].[DimK12Schools].[PhysicalAddressState] renamed.
	The column [RDS].[DimK12Schools].[PhysicalAddressStreet] renamed.
	The column [RDS].[DimK12Schools].[PhysicalAddressStreet2] renamed.
	The column [RDS].[DimK12Schools].[PhysicalCountyAnsiCode] renamed.
	The column [RDS].[DimK12Schools].[PriorLeaIdentifierState] renamed.
	The column [RDS].[DimK12Schools].[PriorSchoolIdentifierState] renamed.
	The column [RDS].[DimK12Schools].[SchoolIdentifierState] renamed.
	The column [RDS].[DimK12Schools].[SchoolOperationalStatusEffectiveDate] renamed.
	The column [RDS].[DimK12Schools].[SchoolOrganizationId] dropped.
	The column [RDS].[DimK12Schools].[SchoolTypeId] dropped.
	The column [RDS].[DimK12Schools].[SeaIdentifierState] renamed.
	The column [RDS].[DimK12Schools].[SeaName] renamed.
	The column [RDS].[DimK12Schools].[SeaOrganizationId] renamed.
	The column [RDS].[DimK12Schools].[Telephone] renamed.
	The column [RDS].[DimK12Schools].[Website] renamed.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimK12Schools]...';

	ALTER TABLE [RDS].[DimK12Schools] DROP COLUMN [OperationalStatusEffectiveDate], COLUMN [CharterSchoolAuthorizerIdPrimary], COLUMN [CharterSchoolAuthorizerIdSecondary], COLUMN [LeaOrganizationId], COLUMN [LeaTypeId], COLUMN [SchoolOrganizationId], COLUMN [SchoolTypeId], COLUMN [SeaOrganizationId]

	EXECUTE sp_rename N'[RDS].[DimK12Schools].[IeuIdentifierState]', N'IeuOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[IeuName]', N'IeuOrganizationName';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[LeaIdentifierState]', N'LeaIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[LeaName]', N'LeaOrganizationName';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[MailingAddressState]', N'MailingAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[MailingAddressStreet]', N'MailingAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[MailingAddressStreet2]', N'MailingAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[MailingCountyAnsiCode]', N'MailingAddressCountyAnsiCodeCode';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PhysicalAddressState]', N'PhysicalAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PhysicalAddressStreet]', N'PhysicalAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PhysicalAddressStreet2]', N'PhysicalAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PhysicalCountyAnsiCode]', N'PhysicalAddressCountyAnsiCodeCode';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PriorLeaIdentifierState]', N'PriorLeaIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[PriorSchoolIdentifierState]', N'PriorSchoolIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[SchoolIdentifierState]', N'SchoolIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[SeaIdentifierState]', N'SeaOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[SeaName]', N'SeaOrganizationName';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[Telephone]', N'TelephoneNumber';
	EXECUTE sp_rename N'[RDS].[DimK12Schools].[Website]', N'WebSiteAddress';

	ALTER TABLE [RDS].[DimK12Schools] 
	ALTER COLUMN [OutOfStateIndicator] BIT NULL

	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimK12Schools_RecordStartDateTime]...';


	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_DimK12Schools_RecordStartDateTime') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimK12Schools_RecordStartDateTime]
			ON [RDS].[DimK12Schools]([RecordStartDateTime] ASC)
			INCLUDE([RecordEndDateTime], [SchoolIdentifierSea]);
	END 


	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierSea]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierSea]
		ON [RDS].[DimK12Schools]([SchoolIdentifierSea] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierSea_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierSea_DimK12SchoolId_RecordStartDateTime_RecordEndDateTime]
		ON [RDS].[DimK12Schools]([SchoolIdentifierSea] ASC, [DimK12SchoolId] ASC, [RecordStartDateTime] ASC, [RecordEndDateTime] ASC)
		INCLUDE([SchoolOperationalStatus]);


	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimK12Schools_SchoolIdentifierSea_RecordStartDateTime]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12Schools_SchoolIdentifierSea_RecordStartDateTime]
		ON [RDS].[DimK12Schools]([SchoolIdentifierSea] ASC, [RecordStartDateTime] ASC)
		INCLUDE([RecordEndDateTime]);


	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimSchools_StateAbbreviationCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchools_StateAbbreviationCode]
		ON [RDS].[DimK12Schools]([StateAbbreviationCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12Schools].[IX_DimSchools_StateANSICode]...';


	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_DimSchools_StateANSICode') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimSchools_StateANSICode]
			ON [RDS].[DimK12Schools]([StateAnsiCode] ASC);
	END

	
	PRINT N'Altering Table [RDS].[DimK12SchoolStateStatuses]...';


	
	ALTER TABLE [RDS].[DimK12SchoolStateStatuses] DROP COLUMN [SchoolStateStatusId];


	
	PRINT N'Altering Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusCode]...';


	
	ALTER INDEX [IX_DimRaces_SchoolStateStatusCode]
		ON [RDS].[DimK12SchoolStateStatuses] REBUILD WITH(DATA_COMPRESSION = NONE);


	
	PRINT N'Altering Index [RDS].[DimK12SchoolStateStatuses].[IX_DimRaces_SchoolStateStatusEdFactsCode]...';


	
	ALTER INDEX [IX_DimRaces_SchoolStateStatusEdFactsCode]
		ON [RDS].[DimK12SchoolStateStatuses] REBUILD WITH(DATA_COMPRESSION = NONE);


	
	/*
	The column [RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageCode] is being renamed.
	The column [RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageDescription] is being renamed.
	The column [RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageEdFactsCode] is being renamed.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimK12SchoolStatuses]...';
	EXECUTE sp_rename N'[RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageCode]', N'ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode';
	EXECUTE sp_rename N'[RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageDescription]', N'ProgressAchievingEnglishLanguageProficiencyIndicatorTypeDescription';
	EXECUTE sp_rename N'[RDS].[DimK12SchoolStatuses].[ProgressAchievingEnglishLanguageEdFactsCode]', N'ProgressAchievingEnglishLanguageProficiencyIndicatorTypeEdFactsCode';



	PRINT N'Starting alter of table [RDS].[DimK12SchoolStatuses]...';
	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN SchoolImprovementStatusCode NVARCHAR(50);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN SchoolImprovementStatusDescription NVARCHAR(200);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN SchoolImprovementStatusEdFactsCode NVARCHAR(50);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN PersistentlyDangerousStatusCode NVARCHAR(50);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN PersistentlyDangerousStatusDescription NVARCHAR(200);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN PersistentlyDangerousStatusEdFactsCode NVARCHAR(50);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN StatePovertyDesignationDescription NVARCHAR(200);

	ALTER TABLE [RDS].[DimK12SchoolStatuses]
	ALTER COLUMN ProgressAchievingEnglishLanguageProficiencyIndicatorTypeDescription NVARCHAR(200);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_SchoolImprovementStatusEdFactsCode]...';

	-- TODO: Do we need this index?  It takes forever to load for some reason.
	--
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_SchoolImprovementStatusEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([SchoolImprovementStatusEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_Codes]...';


	--
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_Codes]
	--    ON [RDS].[DimK12SchoolStatuses]([MagnetOrSpecialProgramEmphasisSchoolCode] ASC, [NslpStatusCode] ASC, [SharedTimeIndicatorCode] ASC, [VirtualSchoolStatusCode] ASC, [SchoolImprovementStatusCode] ASC, [PersistentlyDangerousStatusCode] ASC, [StatePovertyDesignationCode] ASC, [ProgressAchievingEnglishLanguageProficiencyIndicatorTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_MagnetOrSpecialProgramEmphasisSchoolEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([MagnetOrSpecialProgramEmphasisSchoolEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_NslpStatusEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([NslpStatusEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageProficiencyIndicatorTypeEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_ProgressAchievingEnglishLanguageProficiencyIndicatorTypeEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([ProgressAchievingEnglishLanguageProficiencyIndicatorTypeEdFactsCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_SharedTimeIndicatorEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([SharedTimeIndicatorEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_StatePovertyDesignationEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([StatePovertyDesignationEdFactsCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12SchoolStatuses].[IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]...';


	
	--CREATE NONCLUSTERED INDEX [IX_DimK12SchoolStatuses_VirtualSchoolStatusEdFactsCode]
	--    ON [RDS].[DimK12SchoolStatuses]([VirtualSchoolStatusEdFactsCode] ASC);


	PRINT N'Starting rebuilding table [RDS].[DimK12StaffStatuses]...';
	
	/*
	The column [RDS].[DimK12StaffStatuses].[CertificationStatusCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[CertificationStatusDescription] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[CertificationStatusEdFactsCode] is being renamed.
	TODO: Make sure these 3 should be dropped.
	The column [RDS].[DimK12StaffStatuses].[OutOfFieldStatusCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[OutOfFieldStatusDescription] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[OutOfFieldStatusEdFactsCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[QualificationStatusCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[QualificationStatusDescription] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[QualificationStatusEdFactsCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[UnexperiencedStatusCode] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[UnexperiencedStatusDescription] is being renamed.
	The column [RDS].[DimK12StaffStatuses].[UnexperiencedStatusEdFactsCode] is being renamed.

	The column [RDS].[EmergencyOrProvisionalCredentialStatusCode] is being dropped.
	The column [RDS].[EmergencyOrProvisionalCredentialStatusDescription] is being dropped.
	The column [RDS].[EmergencyOrProvisionalCredentialStatusEdFactsCode] is being dropped.
	*/

	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimK12StaffStatuses] (
		[DimK12StaffStatusId]                                   INT            IDENTITY (1, 1) NOT NULL,
		[SpecialEducationAgeGroupTaughtCode]                    NVARCHAR (50)  NULL,
		[SpecialEducationAgeGroupTaughtDescription]             NVARCHAR (200) NULL,
		[SpecialEducationAgeGroupTaughtEdFactsCode]             NVARCHAR (50)  NULL,
		[EdFactsCertificationStatusCode]                        NVARCHAR (50)  NULL,
		[EdFactsCertificationStatusDescription]                 NVARCHAR (200) NULL,
		[EdFactsCertificationStatusEdFactsCode]                 NVARCHAR (50)  NULL,
		[HighlyQualifiedTeacherIndicatorCode]                   NVARCHAR (50)  NULL,
		[HighlyQualifiedTeacherIndicatorDescription]            NVARCHAR (200) NULL,
		[HighlyQualifiedTeacherIndicatorEdFactsCode]            NVARCHAR (50)  NULL,
		[EdFactsTeacherInexperiencedStatusCode]                 NVARCHAR (50)  NULL,
		[EdFactsTeacherInexperiencedStatusDescription]          NVARCHAR (200) NULL,
		[EdFactsTeacherInexperiencedStatusEdFactsCode]          NVARCHAR (50)  NULL,
		[TeachingCredentialTypeCode]                            NVARCHAR (50)  NULL,
		[TeachingCredentialTypeDescription]                     NVARCHAR (200) NULL,
		[TeachingCredentialTypeEdFactsCode]                     NVARCHAR (50)  NULL,
		[EdFactsTeacherOutOfFieldStatusCode]                    NVARCHAR (50)  NULL,
		[EdFactsTeacherOutOfFieldStatusDescription]             NVARCHAR (200) NULL,
		[EdFactsTeacherOutOfFieldStatusEdFactsCode]             NVARCHAR (50)  NULL,
		[SpecialEducationTeacherQualificationStatusCode]        NVARCHAR (50)  NULL,
		[SpecialEducationTeacherQualificationStatusDescription] NVARCHAR (50)  NULL,
		[SpecialEducationTeacherQualificationStatusEdFactsCode] NVARCHAR (50)  NULL,
		[ParaprofessionalQualificationStatusCode]      			NVARCHAR (50)  NULL,
		[ParaprofessionalQualificationStatusDescription] 		NVARCHAR (50)  NULL,
		[ParaprofessionalQualificationStatusEdFactsCode] 		NVARCHAR (50)  NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimK12StaffStatuses1] PRIMARY KEY CLUSTERED ([DimK12StaffStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[DimK12StaffStatuses])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimK12StaffStatuses] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_DimK12StaffStatuses] ([DimK12StaffStatusId], [SpecialEducationAgeGroupTaughtCode], [SpecialEducationAgeGroupTaughtDescription], [SpecialEducationAgeGroupTaughtEdFactsCode], [K12StaffClassificationCode], [K12StaffClassificationDescription], [K12StaffClassificationEdFactsCode])
	--        SELECT   [DimK12StaffStatusId],
	--                 [SpecialEducationAgeGroupTaughtCode],
	--                 [SpecialEducationAgeGroupTaughtDescription],
	--                 [SpecialEducationAgeGroupTaughtEdFactsCode],
	--                 [K12StaffClassificationCode],
	--                 [K12StaffClassificationDescription],
	--                 [K12StaffClassificationEdFactsCode]
	--        FROM     [RDS].[DimK12StaffStatuses]
	--        ORDER BY [DimK12StaffStatusId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimK12StaffStatuses] OFF;
	--    END

	DROP TABLE [RDS].[DimK12StaffStatuses];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimK12StaffStatuses]', N'DimK12StaffStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimK12StaffStatuses1]', N'PK_DimK12StaffStatuses', N'OBJECT';



	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsCertificationStatusCode]
		ON [RDS].[DimK12StaffStatuses]([EdFactsCertificationStatusCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_Codes]
		ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtCode] ASC, [EdFactsCertificationStatusCode] ASC, [HighlyQualifiedTeacherIndicatorCode] ASC, [EdFactsTeacherInexperiencedStatusCode] ASC, [TeachingCredentialTypeCode] ASC, [EdFactsTeacherOutOfFieldStatusCode] ASC, [SpecialEducationTeacherQualificationStatusCode] ASC, [ParaprofessionalQualificationStatusCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsTeacherInexperiencedStatusCode]
		ON [RDS].[DimK12StaffStatuses]([EdFactsTeacherInexperiencedStatusCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_EdFactsTeacherOutOfFieldStatusEdFactsCode]
		ON [RDS].[DimK12StaffStatuses]([EdFactsTeacherOutOfFieldStatusEdFactsCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_SpecialEducationTeacherQualificationStatusEdFactsCode]
		ON [RDS].[DimK12StaffStatuses]([SpecialEducationTeacherQualificationStatusEdFactsCode] ASC);


	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_ParaprofessionalQualificationStatusEdFactsCode]
		ON [RDS].[DimK12StaffStatuses]([ParaprofessionalQualificationStatusEdFactsCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_TeachingCredentialTypeEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_TeachingCredentialTypeEdFactsCode]
		ON [RDS].[DimK12StaffStatuses]([TeachingCredentialTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_HighlyQualifiedTeacherIndicatorCode]
		ON [RDS].[DimK12StaffStatuses]([HighlyQualifiedTeacherIndicatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimK12StaffStatuses].[IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimK12StaffStatuses_SpecialEducationAgeGroupTaughtEdFactsCode]
		ON [RDS].[DimK12StaffStatuses]([SpecialEducationAgeGroupTaughtEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [RDS].[DimK12StudentStatuses]...';


	-- TODO: Need to repopulate this DIM
	
	ALTER TABLE [RDS].[DimK12StudentStatuses] DROP COLUMN [HighSchoolDiplomaTypeId], COLUMN [NSLPDirectCertificationIndicatorCode], COLUMN [NSLPDirectCertificationIndicatorDescription];


	
	PRINT N'Altering Table [RDS].[DimLanguages]...';


	-- TODO: Review these column name changes.
	
	EXECUTE sp_rename N'[RDS].[DimLanguages].[Iso6392LanguageCode]', N'Iso6392LanguageCodeCode';
	EXECUTE sp_rename N'[RDS].[DimLanguages].[Iso6392LanguageDescription]', N'Iso6392LanguageCodeDescription';
	EXECUTE sp_rename N'[RDS].[DimLanguages].[Iso6392LanguageEdFactsCode]', N'Iso6392LanguageCodeEdFactsCode';


	
	PRINT N'Altering Primary Key [RDS].[PK_DimLanguages]...';


	
	ALTER INDEX [PK_DimLanguages]
		ON [RDS].[DimLanguages] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimLanguages].[IX_DimLanguages_LanguageCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimLanguages_LanguageCode]
		ON [RDS].[DimLanguages]([Iso6392LanguageCodeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimLanguages].[IX_DimLanguages_LanguageEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimLanguages_LanguageEdFactsCode]
		ON [RDS].[DimLanguages]([Iso6392LanguageCodeEdFactsCode] ASC);


	
	/*
	The column [RDS].[DimLeas].[IeuName] is being renamed.
	The column [RDS].[DimLeas].[IeuStateIdentifier] is being renamed.
	The column [RDS].[DimLeas].[LeaIdentifierState] is being renamed.
	The column [RDS].[DimLeas].[LeaName] is being renamed.
	The column [RDS].[DimLeas].[LeaOrganizationId] is being dropped.
	The column [RDS].[DimLeas].[LeaTypeId] is being dropped.
	The column [RDS].[DimLeas].[MailingAddressState] is being renamed.
	The column [RDS].[DimLeas].[MailingAddressStreet] is being renamed.
	The column [RDS].[DimLeas].[MailingAddressStreet2] is being renamed.
	The column [RDS].[DimLeas].[MailingCountyAnsiCode] is being renamed.
	The column [RDS].[DimLeas].[PhysicalAddressState] is being renamed.
	The column [RDS].[DimLeas].[PhysicalAddressStreet] is being renamed.
	The column [RDS].[DimLeas].[PhysicalAddressStreet2] is being renamed.
	The column [RDS].[DimLeas].[PhysicalCountyAnsiCode] is being renamed.
	The column [RDS].[DimLeas].[PriorLeaIdentifierState] is being renamed.
	The column [RDS].[DimLeas].[SchoolOrganizationId] is being dropped.
	The column [RDS].[DimLeas].[SeaIdentifierState] is being renamed.
	The column [RDS].[DimLeas].[SeaName] is being renamed.
	The column [RDS].[DimLeas].[SeaOrganizationId] is being dropped.
	The column [RDS].[DimLeas].[Telephone] is being renamed.
	The column [RDS].[DimLeas].[Website] is being renamed.
	*/
	

	
	PRINT N'Starting rebuilding table [RDS].[DimLeas]...';

	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimLeas](
		[DimLeaID] [int] IDENTITY(1,1) NOT NULL,
		[IeuOrganizationName] [nvarchar](1000) NULL,
		[IeuOrganizationIdentifierSea] [nvarchar](50) NULL,
		[StateAnsiCode] [nvarchar](10) NULL,
		[StateAbbreviationCode] [nvarchar](10) NULL,
		[StateAbbreviationDescription] [nvarchar](1000) NULL,
		[SeaOrganizationName] [nvarchar](1000) NULL,
		[SeaOrganizationIdentifierSea] [nvarchar](50) NULL,
		[LeaOrganizationName] [nvarchar](1000) NULL,
		[LeaIdentifierNces] [nvarchar](50) NULL,
		[LeaIdentifierSea] [nvarchar](50) NULL,
		[PriorLeaIdentifierSea] [nvarchar](50) NULL,
		[LeaSupervisoryUnionIdentificationNumber] [nchar](3) NULL,
		[ReportedFederally] [bit] NULL,
		[LeaTypeCode] [nvarchar](50) NULL,
		[LeaTypeDescription] [nvarchar](100) NULL,
		[LeaTypeEdFactsCode] [nvarchar](50) NULL,
		[MailingAddressStreetNumberAndName] [nvarchar](150) NULL,
		[MailingAddressApartmentRoomOrSuiteNumber] [nvarchar](40) NULL,
		[MailingAddressCity] [nvarchar](30) NULL,
		[MailingAddressPostalCode] [nvarchar](17) NULL,
		[MailingAddressStateAbbreviation] [nvarchar](50) NULL,
		[MailingAddressCountyAnsiCodeCode] [nchar](5) NULL,
		[PhysicalAddressStreetNumberAndName] [nvarchar](150) NULL,
		[PhysicalAddressApartmentRoomOrSuiteNumber] [nvarchar](40) NULL,
		[PhysicalAddressCity] [nvarchar](30) NULL,
		[PhysicalAddressPostalCode] [nvarchar](17) NULL,
		[PhysicalAddressStateAbbreviation] [nvarchar](50) NULL,
		[PhysicalAddressCountyAnsiCodeCode] [nchar](5) NULL,
		[Longitude] [nvarchar](20) NULL,
		[Latitude] [nvarchar](20) NULL,
		[TelephoneNumber] [nvarchar](24) NULL,
		[WebSiteAddress] [nvarchar](300) NULL,
		[OutOfStateIndicator] [bit] NULL,
		[LeaOperationalStatus] [nvarchar](50) NULL,
		[LeaOperationalStatusEdFactsCode] [int] NULL,
		[OperationalStatusEffectiveDate] [datetime2](7) NULL,
		[CharterLeaStatus] [nvarchar](50) NULL,
		[ReconstitutedStatus] [nvarchar](50) NULL,
		[McKinneyVentoSubgrantRecipient] [nvarchar](50) NULL,
		[NameOfInstitution] [nvarchar](1000) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
	 CONSTRAINT [tmp_ms_xx_PK_DimLeas] PRIMARY KEY CLUSTERED  ( [DimLeaID] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY]


	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[DimLeas])
		BEGIN
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimLeas] ON;
			INSERT INTO [RDS].[tmp_ms_xx_DimLeas] (
					  CharterLeaStatus
					, DimLeaID
					, IeuOrganizationName
					, IeuOrganizationIdentifierSea
					, Latitude
					, LeaIdentifierNces
					, LeaIdentifierSea
					, LeaOrganizationName
					, LeaOperationalStatus
					, LeaOperationalStatusEdFactsCode
					, LeaSupervisoryUnionIdentificationNumber
					, LeaTypeCode
					, LeaTypeDescription
					, LeaTypeEdFactsCode
					, Longitude
					, MailingAddressCity
					, MailingAddressPostalCode
					, MailingAddressStateAbbreviation
					, MailingAddressStreetNumberAndName
					, MailingAddressApartmentRoomOrSuiteNumber
					, MailingAddressCountyAnsiCodeCode
					, McKinneyVentoSubgrantRecipient
					, NameOfInstitution
					, OperationalStatusEffectiveDate
					, OutOfStateIndicator
					, PhysicalAddressCity
					, PhysicalAddressPostalCode
					, PhysicalAddressStateAbbreviation
					, PhysicalAddressStreetNumberAndName
					, PhysicalAddressApartmentRoomOrSuiteNumber
					, PhysicalAddressCountyAnsiCodeCode
					, PriorLeaIdentifierSea
					, ReconstitutedStatus
					, RecordEndDateTime
					, RecordStartDateTime
					, ReportedFederally
					, SeaOrganizationIdentifierSea
					, SeaOrganizationName
					, StateAbbreviationCode
					, StateAbbreviationDescription
					, StateAnsiCode
					, TelephoneNumber
					, WebSiteAddress
					)
			SELECT    
					  CharterLeaStatus
					, DimLeaID
					, IeuName
					, IeuStateIdentifier
					, Latitude
					, LeaIdentifierNces
					, LeaIdentifierState
					, LeaName
					, LeaOperationalStatus
					, LeaOperationalStatusEdFactsCode
					, LeaSupervisoryUnionIdentificationNumber
					, LeaTypeCode
					, LeaTypeDescription
					, LeaTypeEdFactsCode
					, Longitude
					, MailingAddressCity
					, MailingAddressPostalCode
					, MailingAddressState
					, MailingAddressStreet
					, MailingAddressStreet2
					, MailingCountyAnsiCode
					, McKinneyVentoSubgrantRecipient
					, NameOfInstitution
					, OperationalStatusEffectiveDate
					, OutOfStateIndicator
					, PhysicalAddressCity
					, PhysicalAddressPostalCode
					, PhysicalAddressState
					, PhysicalAddressStreet
					, PhysicalAddressStreet2
					, PhysicalCountyAnsiCode
					, PriorLeaIdentifierState
					, ReconstitutedStatus
					, RecordEndDateTime
					, RecordStartDateTime
					, ReportedFederally
					, SeaIdentifierState
					, SeaName
					, StateAbbreviationCode
					, StateAbbreviationDescription
					, StateAnsiCode
					, Telephone
					, Website

			FROM     [RDS].[DimLeas]
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimLeas] OFF;
		END

	DROP TABLE [RDS].[DimLeas];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimLeas]', N'DimLeas';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_PK_DimLeas]', N'PK_DimLeas', N'OBJECT';


	


	
	PRINT N'Creating Index [RDS].[DimLeas].[IX_DimLeas_LeaIdentifierSea_RecordStartDateTime]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimLeas_LeaIdentifierSea_RecordStartDateTime]
		ON [RDS].[DimLeas]([LeaIdentifierSea] ASC, [RecordStartDateTime] ASC);


	
	PRINT N'Creating Index [RDS].[DimLeas].[IX_DimLeas_RecordStartDateTime]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimLeas_RecordStartDateTime') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimLeas_RecordStartDateTime]
			ON [RDS].[DimLeas]([RecordStartDateTime] ASC)
			INCLUDE([LeaIdentifierSea], [RecordEndDateTime]);
	END

	
	/*
	The column [RDS].[DimOrganizationCalendarSessions].[BeginDate] is being dropped, data loss could occur.

	The column [RDS].[DimOrganizationCalendarSessions].[EndDate] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimOrganizationCalendarSessions]...';
	EXECUTE sp_rename N'[RDS].[DimOrganizationCalendarSessions].[BeginDate]', N'SessionBeginDate';
	EXECUTE sp_rename N'[RDS].[DimOrganizationCalendarSessions].[EndDate]', N'SessionEndDate';



	
	PRINT N'Altering Table [RDS].[DimPsAcademicAwardStatuses]...';


	
	ALTER TABLE [RDS].[DimPsAcademicAwardStatuses] ALTER COLUMN [PescAwardLevelTypeDescription] NVARCHAR (400) NULL;


	
	PRINT N'Altering Table [RDS].[DimPsCitizenshipStatuses]...';


	
	ALTER TABLE [RDS].[DimPsCitizenshipStatuses] DROP COLUMN [MilitaryActiveStudentIndicatorCode], COLUMN [MilitaryActiveStudentIndicatorDescription], COLUMN [MilitaryBranchCode], COLUMN [MilitaryBranchDescription], COLUMN [MilitaryVeteranStudentIndicatorCode], COLUMN [MilitaryVeteranStudentIndicatorDescription];


	
	PRINT N'Creating Index [RDS].[DimPsCitizenshipStatuses].[IX_DimPsCitizenshipStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimPsCitizenshipStatuses_Codes]
		ON [RDS].[DimPsCitizenshipStatuses]([UnitedStatesCitizenshipStatusCode] ASC, [VisaTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[DimPsFamilyStatuses].[NumberOfDependentsCode] is being dropped, data loss could occur.

	The column [RDS].[DimPsFamilyStatuses].[NumberOfDependentsDescription] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimPsFamilyStatuses]...';
	EXECUTE sp_rename N'[RDS].[DimPsFamilyStatuses].[NumberOfDependentsCode]', N'NumberOfDependentsTypeCode';
	EXECUTE sp_rename N'[RDS].[DimPsFamilyStatuses].[NumberOfDependentsDescription]', N'NumberOfDependentsTypeDescription';


	
	PRINT N'Creating Index [RDS].[DimPsFamilyStatuses].[IX_DimPsFamilyStatuses_Codes]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimPsFamilyStatuses_Codes') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimPsFamilyStatuses_Codes]
			ON [RDS].[DimPsFamilyStatuses]([DependencyStatusCode] ASC, [NumberOfDependentsTypeCode] ASC, [MaternalGuardianEducationCode] ASC, [PaternalGuardianEducationCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END

	
	/*
	The column [RDS].[DimPsInstitutions].[InstitutionIpedsUnitId] is being renamed.
	The column [RDS].[DimPsInstitutions].[MailingAddressApartmentRoomOrSuite] is being renamed.
	The column [RDS].[DimPsInstitutions].[MailingAddressState] is being renamed.
	The column [RDS].[DimPsInstitutions].[MailingAddressStreetNameAndNumber] is being renamed.
	The column [RDS].[DimPsInstitutions].[MailingAddressCountyAnsiCodeCode] is being renamed.
	The column [RDS].[DimPsInstitutions].[MostPrevalentLevelOfInstitutionCode] is being renamed.
	The column [RDS].[DimPsInstitutions].[PhysicalAddressApartmentRoomOrSuite] is being renamed.
	The column [RDS].[DimPsInstitutions].[PhysicalAddressState] is being renamed.
	The column [RDS].[DimPsInstitutions].[PhysicalAddressStreetNameAndNumber] is being renamed.
	The column [RDS].[DimPsInstitutions].[PhysicalAddressCountyAnsiCodeCode] is being renamed.
	The column [RDS].[DimPsInstitutions].[Telephone] is being renamed.
	The column [RDS].[DimPsInstitutions].[Website] is being renamed.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimPsInstitutions]...';

	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[InstitutionIpedsUnitId]', N'IPEDSIdentifier';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[MailingAddressApartmentRoomOrSuite]', N'MailingAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[MailingAddressState]', N'MailingAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[MailingAddressStreetNameAndNumber]', N'MailingAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[PhysicalAddressApartmentRoomOrSuite]', N'PhysicalAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[PhysicalAddressState]', N'PhysicalAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[PhysicalAddressStreetNameAndNumber]', N'PhysicalAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[Telephone]', N'TelephoneNumber';
	EXECUTE sp_rename N'[RDS].[DimPsInstitutions].[Website]', N'WebsiteAddress';

	ALTER TABLE [RDS].[DimPsInstitutions]
	ADD MailingAddressCountyAnsiCodeCode NCHAR(5) NULL,
	PhysicalAddressCountyAnsiCodeCode NCHAR(5) NULL

	
	PRINT N'Creating Index [RDS].[DimPsInstitutions].[IX_DimPsInstitution_IpedsUnitId_RecordStartDateTime]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimPsInstitution_IpedsUnitId_RecordStartDateTime') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimPsInstitution_IpedsUnitId_RecordStartDateTime]
			ON [RDS].[DimPsInstitutions]([IPEDSIdentifier] ASC, [RecordStartDateTime] ASC)
			INCLUDE([RecordEndDateTime]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END

	
	PRINT N'Creating Index [RDS].[DimPsInstitutions].[IX_DimPsInstitutions_InstitutionIpedsUnitId]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimPsInstitutions_InstitutionIpedsUnitId') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimPsInstitutions_InstitutionIpedsUnitId]
			ON [RDS].[DimPsInstitutions]([IPEDSIdentifier] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END

	
	/*
	The column [RDS].[DimPsInstitutionStatuses].[LevelOfInstitututionCode] is being dropped, data loss could occur.
	The column [RDS].[DimPsInstitutionStatuses].[LevelOfInstitututionDescription] is being dropped, data loss could occur.
	The column [RDS].[DimPsInstitutionStatuses].[PerdominentCalendarSystemCode] is being dropped, data loss could occur.
	The column [RDS].[DimPsInstitutionStatuses].[PerdominentCalendarSystemDescription] is being dropped, data loss could occur.
	The column [RDS].[DimPsInstitutionStatuses].[VirtualIndicator] is being dropped, data loss could occur.
	The column [RDS].[DimPsInstitutionStatuses].[LevelOfInstitutionCode] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[DimPsInstitutionStatuses].[LevelOfInstitutionDescription] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[DimPsInstitutionStatuses].[PredominantCalendarSystemCode] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[DimPsInstitutionStatuses].[PredominantCalendarSystemDescription] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[DimPsInstitutionStatuses].[VirtualIndicatorCode] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[DimPsInstitutionStatuses].[VirtualIndicatorDescription] on table [RDS].[DimPsInstitutionStatuses] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimPsInstitutionStatuses]...';


	

	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimPsInstitutionStatuses] (
		[DimPsInstitutionStatusId]                   INT            IDENTITY (1, 1) NOT NULL,
		[LevelOfInstitutionCode]                     NVARCHAR (50)  NOT NULL,
		[LevelOfInstitutionDescription]              NVARCHAR (200) NOT NULL,
		[ControlOfInstitutionCode]                   NVARCHAR (50)  NOT NULL,
		[ControlOfInstitutionDescription]            NVARCHAR (200) NOT NULL,
		[VirtualIndicatorCode]                       NVARCHAR (50)  NOT NULL,
		[VirtualIndicatorDescription]                NVARCHAR (200) NOT NULL,
		[CarnegieBasicClassificationCode]            NVARCHAR (50)  NOT NULL,
		[CarnegieBasicClassificationDescription]     NVARCHAR (200) NOT NULL,
		[MostPrevalentLevelOfInstitutionCode]        NVARCHAR (50)  NOT NULL,
		[MostPrevalentLevelOfInstitutionDescription] NVARCHAR (200) NOT NULL,
		[PredominantCalendarSystemCode]              NVARCHAR (50)  NOT NULL,
		[PredominantCalendarSystemDescription]       NVARCHAR (200) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_DimPsInstitutionStatuses1] PRIMARY KEY CLUSTERED ([DimPsInstitutionStatusId] ASC)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[DimPsInstitutionStatuses])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimPsInstitutionStatuses] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_DimPsInstitutionStatuses] ([DimPsInstitutionStatusId], [ControlOfInstitutionCode], [ControlOfInstitutionDescription], [CarnegieBasicClassificationCode], [CarnegieBasicClassificationDescription], [MostPrevalentLevelOfInstitutionCode], [MostPrevalentLevelOfInstitutionDescription])
	--         SELECT   [DimPsInstitutionStatusId],
	--                  [ControlOfInstitutionCode],
	--                  [ControlOfInstitutionDescription],
	--                  [CarnegieBasicClassificationCode],
	--                  [CarnegieBasicClassificationDescription],
	--                  [MostPrevalentLevelOfInstitutionCode],
	--                  [MostPrevalentLevelOfInstitutionDescription]
	--         FROM     [RDS].[DimPsInstitutionStatuses]
	--         ORDER BY [DimPsInstitutionStatusId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimPsInstitutionStatuses] OFF;
	--     END

	DROP TABLE [RDS].[DimPsInstitutionStatuses];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimPsInstitutionStatuses]', N'DimPsInstitutionStatuses';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_DimPsInstitutionStatuses1]', N'PK_DimPsInstitutionStatuses', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[DimPsInstitutionStatuses].[IX_DimPsInstitutionStatuses_CarnegieBasicClassificationCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_CarnegieBasicClassificationCode]
		ON [RDS].[DimPsInstitutionStatuses]([CarnegieBasicClassificationCode] ASC)
		INCLUDE([ControlOfInstitutionCode], [LevelOfInstitutionCode], [MostPrevalentLevelOfInstitutionCode], [PredominantCalendarSystemCode]);


	
	PRINT N'Creating Index [RDS].[DimPsInstitutionStatuses].[IX_DimPsInstitutionStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_Codes]
		ON [RDS].[DimPsInstitutionStatuses]([LevelOfInstitutionCode] ASC, [ControlOfInstitutionCode] ASC, [CarnegieBasicClassificationCode] ASC, [MostPrevalentLevelOfInstitutionCode] ASC, [PredominantCalendarSystemCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimPsInstitutionStatuses].[IX_DimPsInstitutionStatuses_MostPrevalentLevelOfInsitutionCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimPsInstitutionStatuses_MostPrevalentLevelOfInsitutionCode]
		ON [RDS].[DimPsInstitutionStatuses]([MostPrevalentLevelOfInstitutionCode] ASC);


	
	PRINT N'Altering Table [RDS].[DimRaces]...';


	
	ALTER TABLE [RDS].[DimRaces] DROP COLUMN [RaceId];


	
	ALTER TABLE [RDS].[DimRaces] ALTER COLUMN [RaceEdFactsCode] NVARCHAR (100) NULL;


	
	PRINT N'Altering Primary Key [RDS].[PK_DimRaces]...';


	
	ALTER INDEX [PK_DimRaces]
		ON [RDS].[DimRaces] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimRaces].[IX_DimRaces_RaceCode]...';


	
	ALTER INDEX [IX_DimRaces_RaceCode]
		ON [RDS].[DimRaces] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[DimScedCodes].[ScedCourseDescription] is being dropped, data loss could occur.

	The column [RDS].[DimScedCodes].[ScedCourseCodeDescription] on table [RDS].[DimScedCodes] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimScedCodes]...';
	EXECUTE sp_rename N'[RDS].[DimScedCodes].[ScedCourseDescription]', N'ScedCourseCodeDescription';


	
	PRINT N'Creating Index [RDS].[DimScedCodes].[IX_DimScedCodes_Codes]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimScedCodes_Codes') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimScedCodes_Codes]
			ON [RDS].[DimScedCodes]([ScedCourseCode] ASC, [ScedCourseLevelCode] ASC, [ScedCourseSubjectAreaCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END

	
	/*
	The column [RDS].[DimSeas].[MailingAddressState] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[MailingAddressStreet] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[MailingAddressStreet2] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[MailingCountyAnsiCode] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[PhysicalAddressState] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[PhysicalAddressStreet] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[PhysicalAddressStreet2] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[PhysicalCountyAnsiCode] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[SeaIdentifierState] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[SeaName] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[SeaOrganizationId] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[Telephone] is being dropped, data loss could occur.
	The column [RDS].[DimSeas].[Website] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimSeas]...';
	ALTER TABLE [RDS].[DimSeas] DROP COLUMN [SeaOrganizationId]

	EXECUTE sp_rename N'[RDS].[DimSeas].[MailingAddressState]', N'MailingAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimSeas].[MailingAddressStreet]', N'MailingAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimSeas].[MailingAddressStreet2]', N'MailingAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimSeas].[MailingCountyAnsiCode]', N'MailingAddressCountyAnsiCodeCode';
	EXECUTE sp_rename N'[RDS].[DimSeas].[PhysicalAddressState]', N'PhysicalAddressStateAbbreviation';
	EXECUTE sp_rename N'[RDS].[DimSeas].[PhysicalAddressStreet]', N'PhysicalAddressStreetNumberAndName';
	EXECUTE sp_rename N'[RDS].[DimSeas].[PhysicalAddressStreet2]', N'PhysicalAddressApartmentRoomOrSuiteNumber';
	EXECUTE sp_rename N'[RDS].[DimSeas].[PhysicalCountyAnsiCode]', N'PhysicalAddressCountyAnsiCodeCode';
	EXECUTE sp_rename N'[RDS].[DimSeas].[SeaIdentifierState]', N'SeaOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[DimSeas].[SeaName]', N'SeaOrganizationName';
	EXECUTE sp_rename N'[RDS].[DimSeas].[Telephone]', N'TelephoneNumber';
	EXECUTE sp_rename N'[RDS].[DimSeas].[Website]', N'WebSiteAddress';


	
	PRINT N'Creating Index [RDS].[DimSeas].[IX_DimSeas_RecordStartDateTime_RecordEndDateTime]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_DimSeas_RecordStartDateTime_RecordEndDateTime') BEGIN
		CREATE NONCLUSTERED INDEX [IX_DimSeas_RecordStartDateTime_RecordEndDateTime]
			ON [RDS].[DimSeas]([RecordStartDateTime] ASC, [RecordEndDateTime] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END

	
	/*
	The column [RDS].[DimSubgroups].[SubgroupId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimSubgroups]...';
	ALTER TABLE RDS.DimSubgroups
	ALTER COLUMN SubgroupId VARCHAR(50);
	

	UPDATE RDS.DimSubgroups SET SubgroupId = null
	EXECUTE sp_rename N'[RDS].[DimSubgroups].[SubgroupId]', N'SubgroupElementName';
	


	
	/*
	The column [RDS].[DimTitleIIIStatuses].[TitleiiiLanguageInstructionCode] is being dropped, data loss could occur.

	The column [RDS].[DimTitleIIIStatuses].[TitleiiiLanguageInstructionDescription] is being dropped, data loss could occur.

	The column [RDS].[DimTitleIIIStatuses].[TitleiiiLanguageInstructionEdFactsCode] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[DimTitleIIIStatuses]...';
	
	DROP TABLE [RDS].[DimTitleIIIStatuses]
	

	CREATE TABLE [RDS].[DimTitleIIIStatuses](
	[DimTitleIIIStatusId] [int] IDENTITY(1,1) NOT NULL,
	[ProgramParticipationTitleIIILiepCode] [nvarchar](50) NULL,
	[ProgramParticipationTitleIIILiepDescription] [nvarchar](200) NULL,
	[TitleIIIImmigrantParticipationStatusCode] [nvarchar](50) NULL,
	[TitleIIIImmigrantParticipationStatusDescription] [nvarchar](200) NULL,
	[TitleIIIImmigrantParticipationStatusEdFactsCode] [nvarchar](50) NULL,
	[ProficiencyStatusCode] [nvarchar](50) NULL,
	[ProficiencyStatusDescription] [nvarchar](100) NULL,
	[ProficiencyStatusEdFactsCode] [nvarchar](50) NULL,
	[TitleIIIAccountabilityProgressStatusCode] [nvarchar](50) NULL,
	[TitleIIIAccountabilityProgressStatusDescription] [nvarchar](100) NULL,
	[TitleIIIAccountabilityProgressStatusEdFactsCode] [nvarchar](50) NULL,
	[TitleIIILanguageInstructionProgramTypeCode] [nvarchar](50) NULL,
	[TitleIIILanguageInstructionProgramTypeDescription] [nvarchar](100) NULL,
	[TitleIIILanguageInstructionProgramTypeEdFactsCode] [nvarchar](50) NULL,
	CONSTRAINT [PK_DimTitleIIIStatuses] PRIMARY KEY CLUSTERED ( [DimTitleIIIStatusId] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]) ON [PRIMARY]



	
	PRINT N'Altering Table [RDS].[DimTitleIStatuses]...';


	
	ALTER TABLE [RDS].[DimTitleIStatuses] DROP COLUMN [Title1InstructionalServicesId], COLUMN [Title1ProgramTypeId], COLUMN [Title1SchoolStatusId], COLUMN [Title1SupportServicesId];


	
	/*
	The column [RDS].[FactCustomCounts].[OrganizationNcesId] is being renamed.
	The column [RDS].[FactCustomCounts].[OrganizationStateId] is being renamed.
	The column [RDS].[FactCustomCounts].[ParentOrganizationStateId] is being renamed.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactCustomCounts]...';
	EXECUTE sp_rename N'[RDS].[FactCustomCounts].[OrganizationNcesId]', N'OrganizationIdentifierNces';
	EXECUTE sp_rename N'[RDS].[FactCustomCounts].[OrganizationStateId]', N'OrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[FactCustomCounts].[ParentOrganizationStateId]', N'ParentOrganizationIdentifierSea';


	
	PRINT N'Creating Index [RDS].[FactCustomCounts].[IX_FactCustomCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_FactCustomCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode') BEGIN
		CREATE NONCLUSTERED INDEX [IX_FactCustomCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]
			ON [RDS].[FactCustomCounts]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC);
	END

	
	/*
	The column [RDS].[FactK12ProgramParticipations].[DateId] is being dropped, data loss could occur.
	The column [RDS].[FactK12ProgramParticipations].[EntryDateId] is being dropped, data loss could occur.
	The column [RDS].[FactK12ProgramParticipations].[ExitDateId] is being dropped, data loss could occur.
	The column [RDS].[FactK12ProgramParticipations].[LeaID] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12ProgramParticipations]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12ProgramParticipations] (
		[FactK12ProgramParticipationId]       BIGINT IDENTITY (1, 1) NOT NULL,
		[DataCollectionId]                    INT    CONSTRAINT [DF_FactK12ProgramParticipations_DataCollectionId] DEFAULT ((-1)) NOT NULL,
		[SchoolYearId]                        INT    CONSTRAINT [DF_FactK12ProgramParticipations_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                               INT    CONSTRAINT [DF_FactK12ProgramParticipations_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                               INT    CONSTRAINT [DF_FactK12ProgramParticipations_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaAccountabilityId]                 INT    CONSTRAINT [DF_FactK12ProgramParticipations_LeaAccountabilityId] DEFAULT ((-1)) NOT NULL,
		[LeaAttendanceId]                     INT    CONSTRAINT [DF_FactK12ProgramParticipations_LeaAttendancId] DEFAULT ((-1)) NOT NULL,
		[LeaFundingId]                        INT    CONSTRAINT [DF_FactK12ProgramParticipations_LeaFundingId] DEFAULT ((-1)) NOT NULL,
		[LeaGraduationId]                     INT    CONSTRAINT [DF_FactK12ProgramParticipations_LeaGraduationId] DEFAULT ((-1)) NOT NULL,
		[LeaIndividualizedEducationProgramId] INT    CONSTRAINT [DF_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                         INT    CONSTRAINT [DF_FactK12ProgramParticipations_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                        BIGINT    CONSTRAINT [DF_FactK12ProgramParticipations_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                        INT    CONSTRAINT [DF_FactK12ProgramParticipations_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                    INT    CONSTRAINT [DF_FactK12ProgramParticipations_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[K12ProgramTypeId]                    INT    CONSTRAINT [DF_FactK12ProgramParticipations_K12ProgramTypeId] DEFAULT ((-1)) NOT NULL,
		[ProgramParticipationStartDateId]     INT    CONSTRAINT [DF_FactK12ProgramParticipations_ProgramParticipationStartDateId] DEFAULT ((-1)) NOT NULL,
		[ProgramParticipationExitDateId]      INT    CONSTRAINT [DF_FactK12ProgramParticipations_ProgramParticipationExitDateId] DEFAULT ((-1)) NOT NULL,
		[StudentCount]                        INT    CONSTRAINT [DF_FactK12ProgramParticipations_StudentCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12ProgramParticipations1] PRIMARY KEY CLUSTERED ([FactK12ProgramParticipationId] ASC)
	);

	--TODO: These are all renames of existing columns, so link them back up properly. 
	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactK12ProgramParticipations])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12ProgramParticipations] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactK12ProgramParticipations] ([FactK12ProgramParticipationId], [SchoolYearId], [DataCollectionId], [SeaId], [IeuId], [K12SchoolId], [K12ProgramTypeId], [K12StudentId], [K12DemographicId], [IdeaStatusId], [StudentCount])
	--         SELECT   [FactK12ProgramParticipationId],
	--                  [SchoolYearId],
	--                  [DataCollectionId],
	--                  [SeaId],
	--                  [IeuId],
	--                  [K12SchoolId],
	--                  [K12ProgramTypeId],
	--                  [K12StudentId],
	--                  [K12DemographicId],
	--                  [IdeaStatusId],
	--                  [StudentCount]
	--         FROM     [RDS].[FactK12ProgramParticipations]
	--         ORDER BY [FactK12ProgramParticipationId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12ProgramParticipations] OFF;
	--     END

	DROP TABLE [RDS].[FactK12ProgramParticipations];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12ProgramParticipations]', N'FactK12ProgramParticipations';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12ProgramParticipations1]', N'PK_FactK12ProgramParticipations', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_DataCollectionId]
		ON [RDS].[FactK12ProgramParticipations]([DataCollectionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_IdeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_IdeaStatusId]
		ON [RDS].[FactK12ProgramParticipations]([IdeaStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_IeuId]
		ON [RDS].[FactK12ProgramParticipations]([IeuId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_K12DemographicId]
		ON [RDS].[FactK12ProgramParticipations]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_K12ProgramTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_K12ProgramTypeId]
		ON [RDS].[FactK12ProgramParticipations]([K12ProgramTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_K12SchoolId]
		ON [RDS].[FactK12ProgramParticipations]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_K12StudentId]
		ON [RDS].[FactK12ProgramParticipations]([K12StudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_LeaAccountabilityId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_LeaAccountabilityId]
		ON [RDS].[FactK12ProgramParticipations]([LeaAccountabilityId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_LeaAttendanceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_LeaAttendanceId]
		ON [RDS].[FactK12ProgramParticipations]([LeaAttendanceId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_LeaFundingId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_LeaFundingId]
		ON [RDS].[FactK12ProgramParticipations]([LeaFundingId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_LeaGraduationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_LeaGraduationId]
		ON [RDS].[FactK12ProgramParticipations]([LeaGraduationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId]
		ON [RDS].[FactK12ProgramParticipations]([LeaIndividualizedEducationProgramId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_ProgramParticipationExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_ProgramParticipationExitDateId]
		ON [RDS].[FactK12ProgramParticipations]([ProgramParticipationExitDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_ProgramParticipationStartDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_ProgramParticipationStartDateId]
		ON [RDS].[FactK12ProgramParticipations]([ProgramParticipationStartDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_SchoolYearId]
		ON [RDS].[FactK12ProgramParticipations]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12ProgramParticipations].[IXFK_FactK12ProgramParticipations_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12ProgramParticipations_SeaId]
		ON [RDS].[FactK12ProgramParticipations]([SeaId] ASC);


	
	/*
	The column [RDS].[FactK12StaffCounts].[StaffFTE] is being dropped, data loss could occur.

	The column [RDS].[FactK12StaffCounts].[StaffFullTimeEquivalency] on table [RDS].[FactK12StaffCounts] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StaffCounts]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StaffCounts] (
		[FactK12StaffCountId]      				INT             IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]             				INT             CONSTRAINT [DF_FactK12StaffCounts_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]               				INT             CONSTRAINT [DF_FactK12StaffCounts_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                    				INT             CONSTRAINT [DF_FactK12StaffCounts_SeaId] DEFAULT ((-1)) NOT NULL,
		[LeaId]                    				INT             CONSTRAINT [DF_FactK12StaffCounts_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]              				INT             CONSTRAINT [DF_FactK12StaffCounts_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StaffId]               				BIGINT          CONSTRAINT [DF_FactK12StaffCounts_K12StaffId] DEFAULT ((-1)) NOT NULL,
		[K12StaffStatusId]         				INT             CONSTRAINT [DF_FactK12StaffCounts_K12StaffStatusId] DEFAULT ((-1)) NOT NULL,
		[K12StaffCategoryId]       				INT             CONSTRAINT [DF_FactK12StaffCounts_K12StaffCategoryId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]         				INT             CONSTRAINT [DF_FactK12StaffCounts_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[CredentialIssuanceDateId] 				INT             CONSTRAINT [DF_FactK12StaffCounts_CredentialIssuanceDateId] DEFAULT ((-1)) NOT NULL,
		[CredentialExpirationDateId]         	INT             CONSTRAINT [DF_FactK12StaffCounts_CredentialExpirationDateId] DEFAULT ((-1)) NOT NULL,
		[StaffCount]               				INT             CONSTRAINT [DF_FactK12StaffCounts_StaffCount] DEFAULT ((1)) NOT NULL,
		[StaffFullTimeEquivalency] 				DECIMAL (18, 3) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StaffCounts1] PRIMARY KEY CLUSTERED ([FactK12StaffCountId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[FactK12StaffCounts])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StaffCounts] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_FactK12StaffCounts] ([FactK12StaffCountId], [SchoolYearId], [FactTypeId], [K12StaffId], [K12StaffStatusId], [K12SchoolId], [StaffCount], [K12StaffCategoryId], [TitleIIIStatusId], [LeaId], [SeaId])
	--        SELECT   [FactK12StaffCountId],
	--                 [SchoolYearId],
	--                 [FactTypeId],
	--                 [K12StaffId],
	--                 [K12StaffStatusId],
	--                 [K12SchoolId],
	--                 [StaffCount],
	--                 [K12StaffCategoryId],
	--                 [TitleIIIStatusId],
	--                 [LeaId],
	--                 [SeaId]
	--        FROM     [RDS].[FactK12StaffCounts]
	--        ORDER BY [FactK12StaffCountId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StaffCounts] OFF;
	--    END

	DROP TABLE [RDS].[FactK12StaffCounts];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StaffCounts]', N'FactK12StaffCounts';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12StaffCounts1]', N'PK_FactK12StaffCounts', N'OBJECT';

	
	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_FactTypeId]
		ON [RDS].[FactK12StaffCounts]([FactTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_K12SchoolId]
		ON [RDS].[FactK12StaffCounts]([K12SchoolId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_K12StaffCategoryId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_K12StaffCategoryId]
		ON [RDS].[FactK12StaffCounts]([K12StaffCategoryId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_K12Staffid]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_K12Staffid]
		ON [RDS].[FactK12StaffCounts]([K12StaffId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_K12StaffStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_K12StaffStatusId]
		ON [RDS].[FactK12StaffCounts]([K12StaffStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_LeaId]
		ON [RDS].[FactK12StaffCounts]([LeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_SchoolYearId]
		ON [RDS].[FactK12StaffCounts]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_SeaId]
		ON [RDS].[FactK12StaffCounts]([SeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_TitleIIIStatusId]
		ON [RDS].[FactK12StaffCounts]([TitleIIIStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_CredentialIssuanceDateId]
		ON [RDS].[FactK12StaffCounts]([CredentialIssuanceDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

	
	PRINT N'Creating Index [RDS].[FactK12StaffCounts].[IXFK_FactK12StaffCounts_CredentialExpirationDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StaffCounts_CredentialExpirationDateId]
		ON [RDS].[FactK12StaffCounts]([CredentialExpirationDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[FactK12StudentAssessments].[AssessmentStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[EnrollmentStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[GradeLevelId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[NOrDProgramStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[ProgramStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[RaceId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentAssessments].[TitleIStatusId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StudentAssessments]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentAssessments] (
		[FactK12StudentAssessmentId]              INT           IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                            INT           CONSTRAINT [DF_FactK12StudentAssessments_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[CountDateId]                             INT           CONSTRAINT [DF_FactK12StudentAssessments_CountDateId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]                              INT           CONSTRAINT [DF_FactK12StudentAssessments_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                                   INT           CONSTRAINT [DF_FactK12StudentAssessments_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                                   INT           CONSTRAINT [DF_FactK12StudentAssessments_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaId]                                   INT           CONSTRAINT [DF_FactK12StudentAssessments_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                             INT           CONSTRAINT [DF_FactK12StudentAssessments_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                            BIGINT           CONSTRAINT [DF_FactK12StudentAssessments_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[AssessmentId]                            INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentId] DEFAULT ((-1)) NOT NULL,
		[AssessmentSubtestId]                     INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentSubtestId] DEFAULT ((-1)) NOT NULL,
		[AssessmentAdministrationId]              INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentAdministrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentRegistrationId]                INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentRegistrationId] DEFAULT ((-1)) NOT NULL,
		[AssessmentParticipationSessionId]        INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentParticipationSessionId] DEFAULT ((-1)) NOT NULL,
		[AssessmentResultId]                      INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentResultId] DEFAULT ((-1)) NOT NULL,
		[AssessmentPerformanceLevelId]            INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentPerformanceLevelId] DEFAULT ((-1)) NOT NULL,
		[CompetencyDefinitionId]                  INT           CONSTRAINT [DF_FactK12StudentAssessments_CompetencyDefinitionId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]                             INT           CONSTRAINT [DF_FactK12StudentAssessments_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelWhenAssessedId]                INT           CONSTRAINT [DF_FactK12StudentAssessments_GradeLevelWhenAssessedId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                            INT           CONSTRAINT [DF_FactK12StudentAssessments_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                        INT           CONSTRAINT [DF_FactK12StudentAssessments_K12DemographicId] DEFAULT ((-1)) NOT NULL,
--		[K12StudentStatusId]                      INT           CONSTRAINT [DF_FactK12StudentAssessments_K12StudentStatusId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]                            INT           CONSTRAINT [DF_FactK12StudentAssessments_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]                        INT           CONSTRAINT [DF_FactK12StudentAssessments_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[AssessmentCount]                         INT           CONSTRAINT [DF_FactK12StudentAssessments_AssessmentCount] DEFAULT ((1)) NOT NULL,
		[AssessmentResultScoreValueRawScore]      NVARCHAR (35) NULL,
		[AssessmentResultScoreValueScaleScore]    NVARCHAR (35) NULL,
		[AssessmentResultScoreValuePercentile]    NVARCHAR (35) NULL,
		[AssessmentResultScoreValueTScore]        NVARCHAR (35) NULL,
		[AssessmentResultScoreValueZScore]        NVARCHAR (35) NULL,
		[AssessmentResultScoreValueACTScore]      NVARCHAR (35) NULL,
		[AssessmentResultScoreValueSATScore]      NVARCHAR (35) NULL,
		[FactK12StudentAssessmentAccommodationId] INT           NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StudentAssessments1] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentId] ASC) WITH (FILLFACTOR = 80)
	);

	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[FactK12StudentAssessments])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentAssessments] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_FactK12StudentAssessments] ([FactK12StudentAssessmentId], [AssessmentCount], [AssessmentId], [SchoolYearId], [K12DemographicId], [FactTypeId], [IdeaStatusId], [K12SchoolId], [K12StudentId], [TitleIIIStatusId], [K12StudentStatusId], [LeaId], [CteStatusId], [SeaId], [IeuId])
	--        SELECT   [FactK12StudentAssessmentId],
	--                 [AssessmentCount],
	--                 [AssessmentId],
	--                 [SchoolYearId],
	--                 [K12DemographicId],
	--                 [FactTypeId],
	--                 [IdeaStatusId],
	--                 [K12SchoolId],
	--                 [K12StudentId],
	--                 [TitleIIIStatusId],
	--                 [K12StudentStatusId],
	--                 [LeaId],
	--                 [CteStatusId],
	--                 [SeaId],
	--                 [IeuId]
	--        FROM     [RDS].[FactK12StudentAssessments]
	--        ORDER BY [FactK12StudentAssessmentId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentAssessments] OFF;
	--    END

	DROP TABLE [RDS].[FactK12StudentAssessments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentAssessments]', N'FactK12StudentAssessments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12StudentAssessments1]', N'PK_FactK12StudentAssessments', N'OBJECT';

	
	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentAdministrationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentAdministrationId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentAdministrationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentParticipationSessionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentParticipationSessionId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentParticipationSessionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentPerformanceLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentPerformanceLevelId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentPerformanceLevelId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentRegistrationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentRegistrationId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentRegistrationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentResultId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentResultId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentResultId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_AssessmentSubtestId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_AssessmentSubtestId]
		ON [RDS].[FactK12StudentAssessments]([AssessmentSubtestId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_CompetencyDefinitionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_CompetencyDefinitionId]
		ON [RDS].[FactK12StudentAssessments]([CompetencyDefinitionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_CountDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_CountDateId]
		ON [RDS].[FactK12StudentAssessments]([CountDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_CteStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_CteStatusId]
		ON [RDS].[FactK12StudentAssessments]([CteStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_FactTypeId]
		ON [RDS].[FactK12StudentAssessments]([FactTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_GradeLevelWhenAssessedId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_GradeLevelWhenAssessedId]
		ON [RDS].[FactK12StudentAssessments]([GradeLevelWhenAssessedId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_IeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_IeaStatusId]
		ON [RDS].[FactK12StudentAssessments]([IdeaStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_IeuId]
		ON [RDS].[FactK12StudentAssessments]([IeuId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_K12DemographicId]
		ON [RDS].[FactK12StudentAssessments]([K12DemographicId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_K12SchoolId]
		ON [RDS].[FactK12StudentAssessments]([K12SchoolId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_K12StudentId]
		ON [RDS].[FactK12StudentAssessments]([K12StudentId] ASC);


	
	-- PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_K12StudentStatusId]...';


	-- 
	-- CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_K12StudentStatusId]
	-- 	ON [RDS].[FactK12StudentAssessments]([K12StudentStatusId] ASC) WITH (FILLFACTOR = 80);


	-- 
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_LeaId]
		ON [RDS].[FactK12StudentAssessments]([LeaId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_NOrDStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_NOrDStatusId]
		ON [RDS].[FactK12StudentAssessments]([NOrDStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_SchoolYearId]
		ON [RDS].[FactK12StudentAssessments]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_SeaId]
		ON [RDS].[FactK12StudentAssessments]([SeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessments].[IXFK_FactK12StudentAssessments_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessments_TitleIIIStatusId]
		ON [RDS].[FactK12StudentAssessments]([TitleIIIStatusId] ASC) WITH (FILLFACTOR = 80);



	PRINT N'Creating Table [RDS].[DimK12AcademicAwardStatuses]...';


	CREATE TABLE [RDS].[DimK12AcademicAwardStatuses] (
		[DimK12AcademicAwardStatusId]      INT            IDENTITY (1, 1) NOT NULL,
		[HighSchoolDiplomaTypeCode]        NVARCHAR (100)  NULL,
		[HighSchoolDiplomaTypeDescription] NVARCHAR (300) NULL,
		[HighSchoolDiplomaTypeEdFactsCode] NVARCHAR (50) NULL,
		CONSTRAINT [PK_DimK12AcademicAwardStatuses] PRIMARY KEY CLUSTERED ([DimK12AcademicAwardStatusId] ASC)
	);


	-- TODO: Review how StudentCutOverStartDate is currently used.  
	/*
	The column [RDS].[FactK12StudentCounts].[MigrantId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCounts].[NOrDProgramStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCounts].[ProgramStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCounts].[StudentCutOverStartDate] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCounts].[LastQualifyingMoveDateId] on table [RDS].[FactK12StudentCounts] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

	The column [RDS].[FactK12StudentCounts].[MigrantStudentQualifyingArrivalDateId] on table [RDS].[FactK12StudentCounts] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StudentCounts]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentCounts] (
		[FactK12StudentCountId]                 INT IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                          INT CONSTRAINT [DF_FactK12StudentCounts_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]                            INT CONSTRAINT [DF_FactK12StudentCounts_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                                 INT CONSTRAINT [DF_FactK12StudentCounts_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                                 INT CONSTRAINT [DF_FactK12StudentCounts_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaId]                                 INT CONSTRAINT [DF_FactK12StudentCounts_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                           INT CONSTRAINT [DF_FactK12StudentCounts_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                          BIGINT CONSTRAINT [DF_FactK12StudentCounts_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[AgeId]                                 INT CONSTRAINT [DF_FactK12StudentCounts_AgeId] DEFAULT ((-1)) NOT NULL,
		[AttendanceId]                          INT CONSTRAINT [DF_FactK12StudentCounts_AttendanceId] DEFAULT ((-1)) NOT NULL,
		[CohortStatusId]                        INT CONSTRAINT [DF_FactK12StudentCounts_CohortStatusId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]                           INT CONSTRAINT [DF_FactK12StudentCounts_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[DisabilityStatusId]      	            INT CONSTRAINT [DF_FactK12StudentCounts_DisabilityStatusId] DEFAULT ((-1)) NOT NULL,
		[EnglishLearnerStatusId]                INT CONSTRAINT [DF_FactK12StudentCounts_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelId]                          INT CONSTRAINT [DF_FactK12StudentCounts_GradeLevelId] DEFAULT ((-1)) NOT NULL,
		[HomelessnessStatusId]                  INT CONSTRAINT [DF_FactK12StudentCounts_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId]     INT CONSTRAINT [DF_FactK12StudentCounts_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
		[FosterCareStatusId]                    INT CONSTRAINT [DF_FactK12StudentCounts_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                          INT CONSTRAINT [DF_FactK12StudentCounts_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
--		[IdeaDisabilityTypeId]  				INT CONSTRAINT [DF_FactK12StudentCounts_IdeaDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[ImmigrantStatusId]                     INT CONSTRAINT [DF_FactK12StudentCounts_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                      INT CONSTRAINT [DF_FactK12StudentCounts_K12Demographic] DEFAULT ((-1)) NOT NULL,
		[K12EnrollmentStatusId]                 INT CONSTRAINT [DF_FactK12StudentCounts_EnrollmentStatusId] DEFAULT ((-1)) NOT NULL,
		[K12AcademicAwardStatusId]              INT CONSTRAINT [DF_FactK12StudentCounts_K12AcademicAwardStatusId] DEFAULT ((-1)) NOT NULL,
		[LanguageId]                            INT CONSTRAINT [DF_FactK12StudentCounts_LanguageId] DEFAULT ((-1)) NOT NULL,
		[MigrantStatusId]                       INT CONSTRAINT [DF_FactK12StudentCounts_MigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]                          INT CONSTRAINT [DF_FactK12StudentCounts_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[PrimaryDisabilityTypeId]               INT CONSTRAINT [DF_FactK12StudentCounts_PrimaryDisabilityType] DEFAULT ((-1)) NOT NULL,
		[RaceId]                                INT CONSTRAINT [DF_FactK12StudentCounts_RaceId] DEFAULT ((-1)) NOT NULL,
		[SpecialEducationServicesExitDateId]    INT CONSTRAINT [DF_FactK12StudentCounts_SpecialEducationServicesExitDateId] DEFAULT ((-1)) NOT NULL,
		[MigrantStudentQualifyingArrivalDateId] INT CONSTRAINT [DF_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId] DEFAULT ((-1)) NOT NULL,
		[LastQualifyingMoveDateId]              INT CONSTRAINT [DF_FactK12StudentCounts_LastQualifyingMoveDateId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]                        INT CONSTRAINT [DF_FactK12StudentCounts_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]                      INT CONSTRAINT [DF_FactK12StudentCounts_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateEnglishLearnerId]       INT CONSTRAINT [DF_FactK12StudentCounts_StatusStartDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateEnglishLearnerId]         INT CONSTRAINT [DF_FactK12StudentCounts_StatusEndDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
		[StudentCount]                          INT CONSTRAINT [DF_FactK12StudentCounts_StudentCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactStudentCounts1] PRIMARY KEY CLUSTERED ([FactK12StudentCountId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[FactK12StudentCounts])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentCounts] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_FactK12StudentCounts] ([FactK12StudentCountId], [AgeId], [SchoolYearId], [K12DemographicId], [FactTypeId], [GradeLevelId], [IdeaStatusId], [K12SchoolId], [K12StudentId], [StudentCount], [LanguageId], [K12StudentStatusId], [TitleIStatusId], [TitleIIIStatusId], [LeaId], [AttendanceId], [CohortStatusId], [RaceId], [CteStatusId], [K12EnrollmentStatusId], [SeaId], [IeuId], [SpecialEducationServicesExitDateId])
	--        SELECT   [FactK12StudentCountId],
	--                 [AgeId],
	--                 [SchoolYearId],
	--                 [K12DemographicId],
	--                 [FactTypeId],
	--                 [GradeLevelId],
	--                 [IdeaStatusId],
	--                 [K12SchoolId],
	--                 [K12StudentId],
	--                 [StudentCount],
	--                 [LanguageId],
	--                 [K12StudentStatusId],
	--                 [TitleIStatusId],
	--                 [TitleIIIStatusId],
	--                 [LeaId],
	--                 [AttendanceId],
	--                 [CohortStatusId],
	--                 [RaceId],
	--                 [CteStatusId],
	--                 [K12EnrollmentStatusId],
	--                 [SeaId],
	--                 [IeuId],
	--                 [SpecialEducationServicesExitDateId]
	--        FROM     [RDS].[FactK12StudentCounts]
	--        ORDER BY [FactK12StudentCountId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentCounts] OFF;
	--    END

	DROP TABLE [RDS].[FactK12StudentCounts];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentCounts]', N'FactK12StudentCounts';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactStudentCounts1]', N'PK_FactStudentCounts', N'OBJECT';



	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IX_FactK12StudentCounts_SchoolYearId_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IX_FactK12StudentCounts_SchoolYearId_FactTypeId]
		ON [RDS].[FactK12StudentCounts]([SchoolYearId] ASC, [FactTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_AgeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_AgeId]
		ON [RDS].[FactK12StudentCounts]([AgeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_AttendanceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_AttendanceId]
		ON [RDS].[FactK12StudentCounts]([AttendanceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_CohortStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_CohortStatusId]
		ON [RDS].[FactK12StudentCounts]([CohortStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_CteStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_CteStatusId]
		ON [RDS].[FactK12StudentCounts]([CteStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]
		ON [RDS].[FactK12StudentCounts]([EconomicallyDisadvantagedStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_StatusStartDateEnglishLearnerId]
		ON [RDS].[FactK12StudentCounts]([StatusStartDateEnglishLearnerId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_StatusEndDateEnglishLearnerId]
		ON [RDS].[FactK12StudentCounts]([StatusEndDateEnglishLearnerId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);

	PRINT N'Creating Foreign Key [RDS].[FactK12StudentCounts].[FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId]...';

	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId] FOREIGN KEY ([StatusStartDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]);

	PRINT N'Creating Foreign Key [RDS].[FactK12StudentCounts].[FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId]...';

	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId] FOREIGN KEY ([StatusEndDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]);

	PRINT N'Creating Foreign Key [RDS].[FactK12StudentCounts].[FK_FactK12StudentCounts_K12AcademicAwardStatusId]...';

	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_K12AcademicAwardStatusId] FOREIGN KEY ([K12AcademicAwardStatusId]) REFERENCES [RDS].[DimK12AcademicAwardStatuses] ([DimK12AcademicAwardStatusId]);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_EnglishLearnerStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_EnglishLearnerStatusId]
		ON [RDS].[FactK12StudentCounts]([EnglishLearnerStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_FactTypeId]
		ON [RDS].[FactK12StudentCounts]([FactTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_FosterCareStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_FosterCareStatusId]
		ON [RDS].[FactK12StudentCounts]([FosterCareStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_GradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_GradeLevelId]
		ON [RDS].[FactK12StudentCounts]([GradeLevelId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);



	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12AcademicAwardStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12AcademicAwardStatusId]
		ON [RDS].[FactK12StudentCounts]([K12AcademicAwardStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_HomelessnessStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_HomelessnessStatusId]
		ON [RDS].[FactK12StudentCounts]([HomelessnessStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_IdeaStatusesId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_IdeaStatusesId]
		ON [RDS].[FactK12StudentCounts]([IdeaStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_IeuId]
		ON [RDS].[FactK12StudentCounts]([IeuId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_ImmigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_ImmigrantStatusId]
		ON [RDS].[FactK12StudentCounts]([ImmigrantStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12DemographicId]
		ON [RDS].[FactK12StudentCounts]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12EnrollmentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12EnrollmentStatusId]
		ON [RDS].[FactK12StudentCounts]([K12EnrollmentStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12SchoolId]
		ON [RDS].[FactK12StudentCounts]([K12SchoolId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12Studentid]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12Studentid]
		ON [RDS].[FactK12StudentCounts]([K12StudentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	-- PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_K12StudentStatusId]...';


	-- 
	-- CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_K12StudentStatusId]
	-- 	ON [RDS].[FactK12StudentCounts]([K12StudentStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	-- 
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_LanguageId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_LanguageId]
		ON [RDS].[FactK12StudentCounts]([LanguageId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_LeaId]
		ON [RDS].[FactK12StudentCounts]([LeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_MigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_MigrantStatusId]
		ON [RDS].[FactK12StudentCounts]([MigrantStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_NOrDStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_NOrDStatusId]
		ON [RDS].[FactK12StudentCounts]([NOrDStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_PrimaryDisabilityTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_PrimaryDisabilityTypeId]
		ON [RDS].[FactK12StudentCounts]([PrimaryDisabilityTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_RaceId]
		ON [RDS].[FactK12StudentCounts]([RaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_SchoolYearId]
		ON [RDS].[FactK12StudentCounts]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_SeaId]
		ON [RDS].[FactK12StudentCounts]([SeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_SpecialEducationServicesExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_SpecialEducationServicesExitDateId]
		ON [RDS].[FactK12StudentCounts]([SpecialEducationServicesExitDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_TitleIIIStatusId]
		ON [RDS].[FactK12StudentCounts]([TitleIIIStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCounts].[IXFK_FactK12StudentCounts_TitleIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCounts_TitleIStatusId]
		ON [RDS].[FactK12StudentCounts]([TitleIStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	-- TODO: Do this with renames rather than drops/creates
	
	/*
	The column [RDS].[FactK12StudentCourseSections].[DateId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCourseSections].[GradeLevelId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentCourseSections].[LeaID] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StudentCourseSections]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentCourseSections] (
		[FactK12StudentCourseSectionId]       BIGINT IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                        INT    CONSTRAINT [DF_FactK12StudentCourseSections_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[DataCollectionId]                    INT    CONSTRAINT [DF_FactK12StudentCourseSections_DataCollectionId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                               INT    CONSTRAINT [DF_FactK12StudentCourseSections_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                               INT    CONSTRAINT [DF_FactK12StudentCourseSections_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaAccountabilityId]                 INT    CONSTRAINT [DF_FactK12StudentCourseSections_LeaAccountabilityId] DEFAULT ((-1)) NOT NULL,
		[LeaAttendanceId]                     INT    CONSTRAINT [DF_FactK12StudentCourseSections_LeaAttendanceId] DEFAULT ((-1)) NOT NULL,
		[LeaFundingId]                        INT    CONSTRAINT [DF_FactK12StudentCourseSections_LeaFundingId] DEFAULT ((-1)) NOT NULL,
		[LeaGraduationId]                     INT    CONSTRAINT [DF_FactK12StudentCourseSections_LeaGraduationId] DEFAULT ((-1)) NOT NULL,
		[LeaIndividualizedEducationProgramId] INT    CONSTRAINT [DF_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                         INT    CONSTRAINT [DF_FactK12StudentCourseSections_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                        BIGINT    CONSTRAINT [DF_FactK12StudentCourseSections_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                    INT    CONSTRAINT [DF_FactK12StudentCourseSections_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[K12CourseId]                         INT    CONSTRAINT [DF_FactK12StudentCourseSections_K12CourseId] DEFAULT ((-1)) NOT NULL,
		[K12CourseStatusId]                   INT    CONSTRAINT [DF_FactK12StudentCourseSections_K12CourseStatusId] DEFAULT ((-1)) NOT NULL,
		[ScedCodeId]                          INT    CONSTRAINT [DF_FactK12StudentCourseSections_ScedCodeId] DEFAULT ((-1)) NOT NULL,
		[CipCodeId]                           INT    CONSTRAINT [DF_FactK12StudentCourseSections_CipCodeId] DEFAULT ((-1)) NOT NULL,
		[LanguageId]                          INT    CONSTRAINT [DF_FactK12StudentCourseSections_LanguageId] DEFAULT ((-1)) NOT NULL,
		[EntryGradeLevelId]                   INT    CONSTRAINT [DF_FactK12StudentCourseSections_EntryGradeLevelId] DEFAULT ((-1)) NOT NULL,
		[StudentCourseSectionCount]           INT    CONSTRAINT [DF_FactK12StudentCourseSections_StudentCourseSectionCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StudentCourseSections1] PRIMARY KEY CLUSTERED ([FactK12StudentCourseSectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactK12StudentCourseSections])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentCourseSections] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactK12StudentCourseSections] ([FactK12StudentCourseSectionId], [SchoolYearId], [DataCollectionId], [IeuId], [K12SchoolId], [K12StudentId], [K12DemographicId], [K12CourseId], [K12CourseStatusId], [ScedCodeId], [CipCodeId], [LanguageId], [StudentCourseSectionCount])
	--         SELECT   [FactK12StudentCourseSectionId],
	--                  [SchoolYearId],
	--                  [DataCollectionId],
	--                  [IeuId],
	--                  [K12SchoolId],
	--                  [K12StudentId],
	--                  [K12DemographicId],
	--                  [K12CourseId],
	--                  [K12CourseStatusId],
	--                  [ScedCodeId],
	--                  [CipCodeId],
	--                  [LanguageId],
	--                  [StudentCourseSectionCount]
	--         FROM     [RDS].[FactK12StudentCourseSections]
	--         ORDER BY [FactK12StudentCourseSectionId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentCourseSections] OFF;
	--     END

	DROP TABLE [RDS].[FactK12StudentCourseSections];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentCourseSections]', N'FactK12StudentCourseSections';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12StudentCourseSections1]', N'PK_FactK12StudentCourseSections', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_CipCodeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_CipCodeId]
		ON [RDS].[FactK12StudentCourseSections]([CipCodeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_DataCollectionId]
		ON [RDS].[FactK12StudentCourseSections]([DataCollectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_EntryGradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_EntryGradeLevelId]
		ON [RDS].[FactK12StudentCourseSections]([EntryGradeLevelId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_IeuId]
		ON [RDS].[FactK12StudentCourseSections]([IeuId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12CourseId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_K12CourseId]
		ON [RDS].[FactK12StudentCourseSections]([K12CourseId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12CourseStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_K12CourseStatusId]
		ON [RDS].[FactK12StudentCourseSections]([K12CourseStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_K12DemographicId]
		ON [RDS].[FactK12StudentCourseSections]([K12DemographicId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_K12SchoolId]
		ON [RDS].[FactK12StudentCourseSections]([K12SchoolId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_K12StudentId]
		ON [RDS].[FactK12StudentCourseSections]([K12StudentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_LanguageId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_LanguageId]
		ON [RDS].[FactK12StudentCourseSections]([LanguageId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_LeaIds]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_LeaIds]
		ON [RDS].[FactK12StudentCourseSections]([LeaAccountabilityId] ASC, [LeaAttendanceId] ASC, [LeaFundingId] ASC, [LeaGraduationId] ASC, [LeaIndividualizedEducationProgramId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_ScedCodeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_ScedCodeId]
		ON [RDS].[FactK12StudentCourseSections]([ScedCodeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_SchoolYearId]
		ON [RDS].[FactK12StudentCourseSections]([SchoolYearId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactK12StudentCourseSections].[IXFK_FactK12StudentCourseSections_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentCourseSections_SeaId]
		ON [RDS].[FactK12StudentCourseSections]([SeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[FactK12StudentDisciplines].[DisciplinaryActionStartDate] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[DisciplineDuration] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[DisciplineId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[FirearmDisciplineId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[FirearmsId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[ProgramStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentDisciplines].[RaceId] is being dropped, data loss could occur.

	The column LeaId on table [RDS].[FactK12StudentDisciplines] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StudentDisciplines]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentDisciplines] (
		[FactK12StudentDisciplineId]        INT             IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]                        INT             CONSTRAINT [DF_FactK12StudentDisciplines_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[DataCollectionId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_DataCollectionId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_IeuId] DEFAULT ((-1)) NOT NULL,
		[LeaId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                       INT             CONSTRAINT [DF_FactK12StudentDisciplines_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                      BIGINT          CONSTRAINT [DF_FactK12StudentDisciplines_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[AgeId]                             INT             CONSTRAINT [DF_FactK12StudentDisciplines_AgeId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]                       INT             CONSTRAINT [DF_FactK12StudentDisciplines_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[DisabilityStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisabilityStatusId] DEFAULT ((-1)) NOT NULL,
		[DisciplinaryActionStartDateId]     INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplinaryActionStartDateId] DEFAULT ((-1)) NOT NULL,
		[DisciplinaryActionEndDateId]       INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplinaryActionEndDateId] DEFAULT ((-1)) NOT NULL,
		[DisciplineStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_DisciplineStatusId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId] INT             CONSTRAINT [DF_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
		[EnglishLearnerStatusId]            INT             CONSTRAINT [DF_FactK12StudentDisciplines_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
		[FirearmId]                         INT             CONSTRAINT [DF_FactK12StudentDisciplines_FirearmId] DEFAULT ((-1)) NOT NULL,
		[FirearmDisciplineStatusId]         INT             CONSTRAINT [DF_FactK12StudentDisciplines_FirearmDisciplineStatusId] DEFAULT ((-1)) NOT NULL,
		[FosterCareStatusId]                INT             CONSTRAINT [DF_FactK12StudentDisciplines_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
		[GradeLevelId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_GradeLevelId] DEFAULT ((-1)) NOT NULL,
		[HomelessnessStatusId]              INT             CONSTRAINT [DF_FactK12StudentDisciplines_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
--		[IdeaDisabilityTypeId]   			INT             CONSTRAINT [DF_FactK12StudentDisciplines_IdeaDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[ImmigrantStatusId]                 INT             CONSTRAINT [DF_FactK12StudentDisciplines_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[IncidentIdentifier]                NVARCHAR (40)   NULL,
		[IncidentStatusId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_IncidentStatusId] DEFAULT ((-1)) NOT NULL,
		[IncidentDateId]                    INT             CONSTRAINT [DF_FactK12StudentDisciplines_IncidentDateId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[MigrantStatusId]                   INT             CONSTRAINT [DF_FactK12StudentDisciplines_MigrantId] DEFAULT ((-1)) NOT NULL,
		[MilitaryStatusId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_MilitaryId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]                      INT             CONSTRAINT [DF_FactK12StudentDisciplines_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[RaceId]                            INT 			CONSTRAINT [DF_FactK12StudentDisciplines_RaceId] DEFAULT ((-1)) NOT NULL,
		[PrimaryDisabilityTypeId]           INT             CONSTRAINT [DF_FactK12StudentDisciplines_PrimaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[SecondaryDisabilityTypeId]         INT             CONSTRAINT [DF_FactK12StudentDisciplines_SecondaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]                    INT             CONSTRAINT [DF_FactK12StudentDisciplines_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]                  INT             CONSTRAINT [DF_FactK12StudentDisciplines_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[DurationOfDisciplinaryAction]      DECIMAL (18, 2) NULL,
		[DisciplineCount]                   INT             CONSTRAINT [DF_FactK12StudentDisciplines_Id] DEFAULT ((1)) NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StudentDisciplines1] PRIMARY KEY CLUSTERED ([FactK12StudentDisciplineId] ASC) WITH (FILLFACTOR = 80)
	);

	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[FactK12StudentDisciplines])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentDisciplines] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_FactK12StudentDisciplines] ([FactK12StudentDisciplineId], [AgeId], [SchoolYearId], [K12DemographicId], [FactTypeId], [IdeaStatusId], [K12SchoolId], [K12StudentId], [DisciplineCount], [GradeLevelId], [LeaId], [CteStatusId], [SeaId], [IeuId])
	--        SELECT   [FactK12StudentDisciplineId],
	--                 [AgeId],
	--                 [SchoolYearId],
	--                 [K12DemographicId],
	--                 [FactTypeId],
	--                 [IdeaStatusId],
	--                 [K12SchoolId],
	--                 [K12StudentId],
	--                 [DisciplineCount],
	--                 [GradeLevelId],
	--                 [LeaId],
	--                 [CteStatusId],
	--                 [SeaId],
	--                 [IeuId]
	--        FROM     [RDS].[FactK12StudentDisciplines]
	--        ORDER BY [FactK12StudentDisciplineId] ASC;
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentDisciplines] OFF;
	--    END

	DROP TABLE [RDS].[FactK12StudentDisciplines];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentDisciplines]', N'FactK12StudentDisciplines';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12StudentDisciplines1]', N'PK_FactK12StudentDisciplines', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_DataCollectionId]
		ON [RDS].[FactK12StudentDisciplines]([DataCollectionId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_AgeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_AgeId]
		ON [RDS].[FactK12StudentDisciplines]([AgeId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_CteStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_CteStatusId]
		ON [RDS].[FactK12StudentDisciplines]([CteStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_DisabilityStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_DisabilityStatusId]
		ON [RDS].[FactK12StudentDisciplines]([DisabilityStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_DisciplinaryActionEndDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_DisciplinaryActionEndDateId]
		ON [RDS].[FactK12StudentDisciplines]([DisciplinaryActionEndDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_DisciplinaryActionStartDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_DisciplinaryActionStartDateId]
		ON [RDS].[FactK12StudentDisciplines]([DisciplinaryActionStartDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_DisciplineStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_DisciplineStatusId]
		ON [RDS].[FactK12StudentDisciplines]([DisciplineStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId]
		ON [RDS].[FactK12StudentDisciplines]([EconomicallyDisadvantagedStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_EnglishLearnerStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_EnglishLearnerStatusId]
		ON [RDS].[FactK12StudentDisciplines]([EnglishLearnerStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_FactTypeId]
		ON [RDS].[FactK12StudentDisciplines]([FactTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_FirearmDisciplineStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_FirearmDisciplineStatusId]
		ON [RDS].[FactK12StudentDisciplines]([FirearmDisciplineStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_FirearmId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_FirearmId]
		ON [RDS].[FactK12StudentDisciplines]([FirearmId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_FosterCareStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_FosterCareStatusId]
		ON [RDS].[FactK12StudentDisciplines]([FosterCareStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_GradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_GradeLevelId]
		ON [RDS].[FactK12StudentDisciplines]([GradeLevelId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_HomelessnessStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_HomelessnessStatusId]
		ON [RDS].[FactK12StudentDisciplines]([HomelessnessStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_IdeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_IdeaStatusId]
		ON [RDS].[FactK12StudentDisciplines]([IdeaStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_IeuId]
		ON [RDS].[FactK12StudentDisciplines]([IeuId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_ImmigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_ImmigrantStatusId]
		ON [RDS].[FactK12StudentDisciplines]([ImmigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_IncidentDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_IncidentDateId]
		ON [RDS].[FactK12StudentDisciplines]([IncidentDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_IncidentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_IncidentStatusId]
		ON [RDS].[FactK12StudentDisciplines]([IncidentStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_K12DemographicId]
		ON [RDS].[FactK12StudentDisciplines]([K12DemographicId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_K12SchoolId]
		ON [RDS].[FactK12StudentDisciplines]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_K12StudentId]
		ON [RDS].[FactK12StudentDisciplines]([K12StudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_LeaId]
		ON [RDS].[FactK12StudentDisciplines]([LeaId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_MigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_MigrantStatusId]
		ON [RDS].[FactK12StudentDisciplines]([MigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_NOrDStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_NOrDStatusId]
		ON [RDS].[FactK12StudentDisciplines]([NOrDStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_PrimaryDisabilityTypes]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_PrimaryDisabilityTypes]
		ON [RDS].[FactK12StudentDisciplines]([PrimaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_SchoolYearId]
		ON [RDS].[FactK12StudentDisciplines]([SchoolYearId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_SeaId]
		ON [RDS].[FactK12StudentDisciplines]([SeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_SecondaryDisabilityTypes]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_SecondaryDisabilityTypes]
		ON [RDS].[FactK12StudentDisciplines]([SecondaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_TitleIIIStatusId]
		ON [RDS].[FactK12StudentDisciplines]([TitleIIIStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentDisciplines].[IXFK_FactK12StudentDisciplines_TitleIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentDisciplines_TitleIStatusId]
		ON [RDS].[FactK12StudentDisciplines]([TitleIStatusId] ASC);


	
	/*
	The column [RDS].[FactK12StudentEnrollments].[EntryDateId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentEnrollments].[ExitDateId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentEnrollments].[K12SchoolId] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentEnrollments].[LeaID] is being dropped, data loss could occur.

	The column [RDS].[FactK12StudentEnrollments].[CountDateId] on table [RDS].[FactK12StudentEnrollments] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactK12StudentEnrollments]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactK12StudentEnrollments] (
		[FactK12StudentEnrollmentId]                 BIGINT         IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[CountDateId]                                INT            CONSTRAINT [DF_FactK12StudentEnrollments_CountDateId] DEFAULT ((-1)) NOT NULL,
		[DataCollectionId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_DataCollectionId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                                      INT            CONSTRAINT [DF_FactK12StudentEnrollments_SeaId] DEFAULT ((-1)) NOT NULL,
		[IeuId]                                      INT            CONSTRAINT [DF_FactK12StudentEnrollments_IeuId] DEFAULT ((-1)) NOT NULL,
		[K12StudentId]                               BIGINT         CONSTRAINT [DF_FactK12StudentEnrollments_K12StudentId] DEFAULT ((-1)) NOT NULL,
		[LeaAccountabilityId]                        INT            CONSTRAINT [DF_FactK12StudentEnrollments_LeaAccountabilityId] DEFAULT ((-1)) NOT NULL,
		[LeaAttendanceId]                            INT            CONSTRAINT [DF_FactK12StudentEnrollments_LeaAttendanceId] DEFAULT ((-1)) NOT NULL,
		[LeaFundingId]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_LeaFundingId] DEFAULT ((-1)) NOT NULL,
		[LeaGraduationID]                            INT            CONSTRAINT [DF_FactK12StudentEnrollments_LeaGraduationId] DEFAULT ((-1)) NOT NULL,
		[LeaIndividualizedEducationProgramId]        INT            CONSTRAINT [DF_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId] DEFAULT ((-1)) NOT NULL,
		[AccountableK12SchoolId]                     INT            CONSTRAINT [DF_FactK12StudentEnrollments_AccountableK12SchoolId] DEFAULT ((-1)) NOT NULL,
		[EducationOrganizationNetworkId]             INT            CONSTRAINT [DF_FactK12StudentEnrollments_EducationOrganizationNetworkId] DEFAULT ((-1)) NOT NULL,
		[CohortGraduationYearId]                     INT            CONSTRAINT [DF_FactK12StudentEnrollments_CohortGraduationYearId] DEFAULT ((-1)) NOT NULL,
		[CohortYearId]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_CohortYearId] DEFAULT ((-1)) NOT NULL,
		[CteStatusId]                                INT            CONSTRAINT [DF_FactK12StudentEnrollments_CteStatusId] DEFAULT ((-1)) NOT NULL,
		[EntryGradeLevelId]                          INT            CONSTRAINT [DF_FactK12StudentEnrollments_EntryGradeLevelId] DEFAULT ((-1)) NOT NULL,
		[ExitGradeLevelId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_ExitGradeLevelId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentEntryDateId]                      INT            CONSTRAINT [DF_FactK12StudentEnrollments_EnrollmentEntryDateId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentExitDateId]                       INT            CONSTRAINT [DF_FactK12StudentEnrollments_EnrollmentExitDateId] DEFAULT ((-1)) NOT NULL,
		[EnglishLearnerStatusId]                     INT            CONSTRAINT [DF_FactK12StudentEnrollments_EnglishLearnerStatusId] DEFAULT ((-1)) NOT NULL,
		[K12EnrollmentStatusId]                      INT            CONSTRAINT [DF_FactK12StudentEnrollments_K12EnrollmentStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_K12DemographicId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[HomelessnessStatusId]                       INT            CONSTRAINT [DF_FactK12StudentEnrollments_HomelessnessStatusId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId]          INT            CONSTRAINT [DF_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) NOT NULL,
		[FosterCareStatusId]                         INT            CONSTRAINT [DF_FactK12StudentEnrollments_FosterCareStatusId] DEFAULT ((-1)) NOT NULL,
		[ImmigrantStatusId]                          INT            CONSTRAINT [DF_FactK12StudentEnrollments_ImmigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[LanguageHomeId]                             INT            CONSTRAINT [DF_FactK12StudentEnrollments_LanguageHomeId] DEFAULT ((-1)) NOT NULL,
		[LanguageNativeId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_LanguageNativeId] DEFAULT ((-1)) NOT NULL,
		[MigrantStatusId]                            INT            CONSTRAINT [DF_FactK12StudentEnrollments_MigrantStatusId] DEFAULT ((-1)) NOT NULL,
		[MilitaryStatusId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_MilitaryStatusId] DEFAULT ((-1)) NOT NULL,
		[NOrDStatusId]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_NOrDStatusId] DEFAULT ((-1)) NOT NULL,
		[PrimaryDisabilityTypeId]                    INT            CONSTRAINT [DF_FactK12StudentEnrollments_PrimaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[SecondaryDisabilityTypeId]                  INT            CONSTRAINT [DF_FactK12StudentEnrollments_SecondaryDisabilityTypeId] DEFAULT ((-1)) NOT NULL,
		[ProjectedGraduationDateId]                  INT            CONSTRAINT [DF_FactK12StudentEnrollments_ProjectedGraduationDateId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateEconomicallyDisadvantagedId] INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateEconomicallyDisadvantagedId]   INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateEnglishLearnerId]            INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateEnglishLearnerId]              INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateHomelessnessId]              INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateHomelessnessId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateHomelessnessId]                INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateHomelessnessId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateIdeaId]                      INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateIdeaId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateIdeaId]                        INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateIdeaId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateMigrantId]                   INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateMigrantId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateMigrantId]                     INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateMigrantId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateMilitaryConnectedStudentId]  INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateMilitaryConnectedStudentId]    INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDatePerkinsELId]                 INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDatePerkinsELId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDatePerkinsELId]  	             INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDatePerkinsELId] DEFAULT ((-1)) NOT NULL,
		[StatusEndDateTitleIIIImmigrantId]           INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId] DEFAULT ((-1)) NOT NULL,
		[StatusStartDateTitleIIIImmigrantId]         INT            CONSTRAINT [DF_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId] DEFAULT ((-1)) NOT NULL,
		[TitleIIIStatusId]                           INT            CONSTRAINT [DF_FactK12StudentEnrollments_TitleIIIStatusId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]                             INT            CONSTRAINT [DF_FactK12StudentEnrollments_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[FullTimeEquivalency]                        DECIMAL (5, 2) NULL,
		[StudentCount]                               INT            CONSTRAINT [DF_FactK12StudentEnrollments_StudentCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactK12StudentEnrollments1] PRIMARY KEY NONCLUSTERED ([FactK12StudentEnrollmentId] ASC)
	);

	-- TODO: Determine what to do with this table
	--IF EXISTS (SELECT TOP 1 1 
	--           FROM   [RDS].[FactK12StudentEnrollments])
	--    BEGIN
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentEnrollments] ON;
	--        INSERT INTO [RDS].[tmp_ms_xx_FactK12StudentEnrollments] ([FactK12StudentEnrollmentId], [SchoolYearId], [DataCollectionId], [SeaId], [IeuId], [K12StudentId], [K12EnrollmentStatusId], [EntryGradeLevelId], [ExitGradeLevelId], [ProjectedGraduationDateId], [K12DemographicId], [IdeaStatusId], [StudentCount])
	--        SELECT [FactK12StudentEnrollmentId],
	--               [SchoolYearId],
	--               [DataCollectionId],
	--               [SeaId],
	--               [IeuId],
	--               [K12StudentId],
	--               [K12EnrollmentStatusId],
	--               [EntryGradeLevelId],
	--               [ExitGradeLevelId],
	--               [ProjectedGraduationDateId],
	--               [K12DemographicId],
	--               [IdeaStatusId],
	--               [StudentCount]
	--        FROM   [RDS].[FactK12StudentEnrollments];
	--        SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactK12StudentEnrollments] OFF;
	--    END

	DROP TABLE [RDS].[FactK12StudentEnrollments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactK12StudentEnrollments]', N'FactK12StudentEnrollments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactK12StudentEnrollments1]', N'PK_FactK12StudentEnrollments', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IX_FactK12StudentEnrollments_DataCollectionId_With_Includes]...';


	
	CREATE NONCLUSTERED INDEX [IX_FactK12StudentEnrollments_DataCollectionId_With_Includes]
		ON [RDS].[FactK12StudentEnrollments]([DataCollectionId] ASC)
		INCLUDE([SchoolYearId], [SeaId], [IeuId], [LeaAccountabilityId], [AccountableK12SchoolId], [K12StudentId], [K12EnrollmentStatusId], [EntryGradeLevelId], [ExitGradeLevelId], [EnrollmentEntryDateId], [EnrollmentExitDateId], [ProjectedGraduationDateId], [K12DemographicId], [IdeaStatusId], [StudentCount]);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_CohortGraduationYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_CohortGraduationYearId]
		ON [RDS].[FactK12StudentEnrollments]([CohortGraduationYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_CohortYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_CohortYearId]
		ON [RDS].[FactK12StudentEnrollments]([CohortYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_CteStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_CteStatusId]
		ON [RDS].[FactK12StudentEnrollments]([CteStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_DataCollectionId]
		ON [RDS].[FactK12StudentEnrollments]([DataCollectionId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId]
		ON [RDS].[FactK12StudentEnrollments]([EconomicallyDisadvantagedStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EducationOrganizationNetworkId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EducationOrganizationNetworkId]
		ON [RDS].[FactK12StudentEnrollments]([EducationOrganizationNetworkId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EnglishLearnerStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EnglishLearnerStatusId]
		ON [RDS].[FactK12StudentEnrollments]([EnglishLearnerStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EnrollmentEntryDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EnrollmentEntryDateId]
		ON [RDS].[FactK12StudentEnrollments]([EnrollmentEntryDateId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EnrollmentExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EnrollmentExitDateId]
		ON [RDS].[FactK12StudentEnrollments]([EnrollmentExitDateId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_EntryGradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_EntryGradeLevelId]
		ON [RDS].[FactK12StudentEnrollments]([EntryGradeLevelId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_ExitGradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_ExitGradeLevelId]
		ON [RDS].[FactK12StudentEnrollments]([ExitGradeLevelId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_FosterCareStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_FosterCareStatusId]
		ON [RDS].[FactK12StudentEnrollments]([FosterCareStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_HomelessnessStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_HomelessnessStatusId]
		ON [RDS].[FactK12StudentEnrollments]([HomelessnessStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_IdeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_IdeaStatusId]
		ON [RDS].[FactK12StudentEnrollments]([IdeaStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_IeuId]
		ON [RDS].[FactK12StudentEnrollments]([IeuId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_ImmigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_ImmigrantStatusId]
		ON [RDS].[FactK12StudentEnrollments]([ImmigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_K12DemographicId]
		ON [RDS].[FactK12StudentEnrollments]([K12DemographicId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_K12EnrollmentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_K12EnrollmentStatusId]
		ON [RDS].[FactK12StudentEnrollments]([K12EnrollmentStatusId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_K12SchoolId]
		ON [RDS].[FactK12StudentEnrollments]([AccountableK12SchoolId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_K12StudentId]
		ON [RDS].[FactK12StudentEnrollments]([K12StudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LanguageHomeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LanguageHomeId]
		ON [RDS].[FactK12StudentEnrollments]([LanguageHomeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LanguageNativeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LanguageNativeId]
		ON [RDS].[FactK12StudentEnrollments]([LanguageNativeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaAccountabilityId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LeaAccountabilityId]
		ON [RDS].[FactK12StudentEnrollments]([LeaAccountabilityId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaAttendanceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LeaAttendanceId]
		ON [RDS].[FactK12StudentEnrollments]([LeaAttendanceId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaFundingId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LeaFundingId]
		ON [RDS].[FactK12StudentEnrollments]([LeaFundingId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaGraduationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LeaGraduationId]
		ON [RDS].[FactK12StudentEnrollments]([LeaGraduationID] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId]
		ON [RDS].[FactK12StudentEnrollments]([LeaIndividualizedEducationProgramId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_MigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_MigrantStatusId]
		ON [RDS].[FactK12StudentEnrollments]([MigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_MilitaryStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_MilitaryStatusId]
		ON [RDS].[FactK12StudentEnrollments]([MilitaryStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_NOrDStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_NOrDStatusId]
		ON [RDS].[FactK12StudentEnrollments]([NOrDStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_PrimaryDisabilityTypes]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_PrimaryDisabilityTypes]
		ON [RDS].[FactK12StudentEnrollments]([PrimaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_ProjectedGraduationDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_ProjectedGraduationDateId]
		ON [RDS].[FactK12StudentEnrollments]([ProjectedGraduationDateId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_SchoolYearId]
		ON [RDS].[FactK12StudentEnrollments]([SchoolYearId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_SeaId]
		ON [RDS].[FactK12StudentEnrollments]([SeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_SecodanryDisabilityTypes]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_SecodanryDisabilityTypes]
		ON [RDS].[FactK12StudentEnrollments]([SecondaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantageId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantageId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateEconomicallyDisadvantagedId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateEnglishLearnerId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateHomelessnessId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateHomelessnessId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateHomelessnessId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateIdeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateIdeaId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateIdeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateMigrantId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateMigrantId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateMigrantId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateMilitaryConnectedStudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDatePerkinsELId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDatePerkinsELId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDatePerkinsELId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmgirantId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmgirantId]
		ON [RDS].[FactK12StudentEnrollments]([StatusEndDateTitleIIIImmigrantId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateEconomicallyDisadvantagedId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateEnglishLearnerId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateHomelessnessId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateHomelessnessId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateHomelessnessId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateIdeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateIdeaId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateIdeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateMigrantId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateMigrantId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateMigrantId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateMilitaryConnectedStudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDatePerkinsELId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDatePerkinsELId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDatePerkinsELId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId]
		ON [RDS].[FactK12StudentEnrollments]([StatusStartDateTitleIIIImmigrantId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_TitleIIIStatusId]
		ON [RDS].[FactK12StudentEnrollments]([TitleIIIStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEnrollments].[IXFK_FactK12StudentEnrollments_TitleIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEnrollments_TitleIStatusId]
		ON [RDS].[FactK12StudentEnrollments]([TitleIStatusId] ASC);


	
	--TODO: Review these changes.
	/*
	The column [RDS].[FactOrganizationCounts].[CharterSchoolApproverAgencyId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[CharterSchoolManagerOrganizationId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[CharterSchoolSecondaryApproverAgencyId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[CharterSchoolUpdatedManagerOrganizationId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[DimComprehensiveSupportReasonApplicabilityId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[DimSubgroupId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[FederalFundAllocated] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[FederalFundAllocationType] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[OrganizationStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[SchoolStateStatusId] is being dropped, data loss could occur.

	The column [RDS].[FactOrganizationCounts].[SchoolStatusId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactOrganizationCounts]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactOrganizationCounts] (
		[FactOrganizationCountId]                           INT           IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                                      INT           CONSTRAINT [DF_FactOrganizationCounts_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[FactTypeId]                                        INT           CONSTRAINT [DF_FactOrganizationCounts_FactTypeId] DEFAULT ((-1)) NOT NULL,
		[SeaId]                                             INT           CONSTRAINT [DF_FactOrganizationCounts_SeaId] DEFAULT ((-1)) NOT NULL,
		[LeaId]                                             INT           CONSTRAINT [DF_FactOrganizationCounts_LeaId] DEFAULT ((-1)) NOT NULL,
		[K12StaffId]                                        BIGINT        CONSTRAINT [DF_FactOrganizationCounts_K12StaffId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolId]                                       INT           CONSTRAINT [DF_FactOrganizationCounts_K12SchoolId] DEFAULT ((-1)) NOT NULL,
		[AuthorizingBodyCharterSchoolAuthorizerId]          INT           CONSTRAINT [DF_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId] DEFAULT ((-1)) NOT NULL,
		[CharterSchoolManagementOrganizationId]             INT           CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolManagementOrganizationId] DEFAULT ((-1)) NOT NULL,
		[SecondaryAuthorizingBodyCharterSchoolAuthorizerId] INT           CONSTRAINT [DF_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId] DEFAULT ((-1)) NOT NULL,
		[CharterSchoolStatusId]                             INT           CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolStatusId] DEFAULT ((-1)) NOT NULL,
		[CharterSchoolUpdatedManagementOrganizationId]      INT           CONSTRAINT [DF_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId] DEFAULT ((-1)) NOT NULL,
		[ComprehensiveAndTargetedSupportId]                 INT           CONSTRAINT [DF_FactOrganizationCounts_ComprehensiveAndTargetedSupportId] DEFAULT ((-1)) NOT NULL,
		[ReasonApplicabilityId]                             INT           CONSTRAINT [DF_FactOrganizationCounts_ReasonApplicabilityId] DEFAULT ((-1)) NOT NULL,
		[K12OrganizationStatusId]                           INT           CONSTRAINT [DF_FactOrganizationCounts_K12OrganizationStatusId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolStatusId]                                 INT           CONSTRAINT [DF_FactOrganizationCounts_K12SchoolStatusId] DEFAULT ((-1)) NOT NULL,
		[K12SchoolStateStatusId]                            INT           CONSTRAINT [DF_FactOrganizationCounts_K12SchoolStateStatusId] DEFAULT ((-1)) NOT NULL,
		[SubgroupId]                                        INT           CONSTRAINT [DF_FactOrganizationCounts_SubgroupId] DEFAULT ((-1)) NOT NULL,
		[TitleIStatusId]                                    INT           CONSTRAINT [DF_FactOrganizationCounts_TitleIStatusId] DEFAULT ((-1)) NOT NULL,
		[FederalProgramCode]                                NVARCHAR (20) NULL,
		[FederalProgramsFundingAllocationType]              NVARCHAR (20) NULL,
		[FederalProgramsFundingAllocation]                  INT           NULL,
		[SchoolImprovementFunds]                            INT           NULL,
		[TitleIParentalInvolveRes]                          INT           NULL,
		[TitleIPartAAllocations]                            INT           NULL,
		[OrganizationCount]                                 INT           CONSTRAINT [DF_FactOrganizationCounts_OrganizationCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactOrganizationCounts1] PRIMARY KEY CLUSTERED ([FactOrganizationCountId] ASC)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactOrganizationCounts])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactOrganizationCounts] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactOrganizationCounts] ([FactOrganizationCountId], [SchoolYearId], [FactTypeId], [LeaId], [K12StaffId], [K12SchoolId], [SeaId], [TitleIStatusId], [OrganizationCount], [TitleIParentalInvolveRes], [TitleIPartAAllocations], [SchoolImprovementFunds], [FederalProgramCode], [ComprehensiveAndTargetedSupportId], [CharterSchoolStatusId])
	--         SELECT   [FactOrganizationCountId],
	--                  [SchoolYearId],
	--                  [FactTypeId],
	--                  [LeaId],
	--                  [K12StaffId],
	--                  [K12SchoolId],
	--                  [SeaId],
	--                  [TitleIStatusId],
	--                  [OrganizationCount],
	--                  [TitleIParentalInvolveRes],
	--                  [TitleIPartAAllocations],
	--                  [SchoolImprovementFunds],
	--                  [FederalProgramCode],
	--                  [ComprehensiveAndTargetedSupportId],
	--                  [CharterSchoolStatusId]
	--         FROM     [RDS].[FactOrganizationCounts]
	--         ORDER BY [FactOrganizationCountId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactOrganizationCounts] OFF;
	--     END

	DROP TABLE [RDS].[FactOrganizationCounts];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactOrganizationCounts]', N'FactOrganizationCounts';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactOrganizationCounts1]', N'PK_FactOrganizationCounts', N'OBJECT';

	
	
	/*
	The column [RDS].[FactOrganizationStatusCounts].[DimEcoDisStatusId] is being dropped, data loss could occur.
	The column [RDS].[FactOrganizationStatusCounts].[StateDefinedCustomIndicatorId] is being dropped, data loss could occur.
	The column [RDS].[FactOrganizationStatusCounts].[StateDefinedStatusId] is being dropped, data loss could occur.
	The column [RDS].[FactOrganizationStatusCounts].[EconomicallyDisadvantagedStatusId] on table [RDS].[FactOrganizationStatusCounts] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactOrganizationStatusCounts]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactOrganizationStatusCounts] (
		[FactOrganizationStatusCountId]                  INT IDENTITY (1, 1) NOT NULL,
		[FactTypeId]                                     INT NOT NULL,
		[K12SchoolId]                                    INT NOT NULL,
		[SchoolYearId]                                   INT NOT NULL,
		[RaceId]                                         INT CONSTRAINT [DF_FactOrganizationStatusCounts_RaceId] DEFAULT ((-1)) NOT NULL,
		[IdeaStatusId]                                   INT CONSTRAINT [DF_FactOrganizationStatusCounts_IdeaStatusId] DEFAULT ((-1)) NOT NULL,
		[K12DemographicId]                               INT CONSTRAINT [DF_FactOrganizationStatusCounts_DemographicId] DEFAULT ((-1)) NOT NULL,
		[EconomicallyDisadvantagedStatusId]              INT NOT NULL,
		[SchoolPerformanceIndicatorId]                   INT CONSTRAINT [DF_FactOrganizationStatusCounts_SchoolPerformanceIndicatorId] DEFAULT ((-1)) NOT NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusId] INT CONSTRAINT [DF_FactOrganizationStatusCounts_SchoolPerformanceIndicatorStateDefinedStatusId] DEFAULT ((-1)) NOT NULL,
		[OrganizationStatusCount]                        INT NOT NULL,
		[SchoolQualityOrStudentSuccessIndicatorId]       INT CONSTRAINT [DF_FactOrganizationStatusCounts_SchoolQualityOrStudentSuccessIndicatorId] DEFAULT ((-1)) NOT NULL,
		[SchoolPerformanceIndicatorCategoryId]           INT CONSTRAINT [DF_FactOrganizationStatusCounts_SchoolPerformanceIndicatorCategoryId] DEFAULT ((-1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactOrganizationStatusCount1] PRIMARY KEY CLUSTERED ([FactOrganizationStatusCountId] ASC)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactOrganizationStatusCounts])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactOrganizationStatusCounts] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactOrganizationStatusCounts] ([FactOrganizationStatusCountId], [FactTypeId], [K12SchoolId], [SchoolYearId], [RaceId], [IdeaStatusId], [K12DemographicId], [OrganizationStatusCount])
	--         SELECT   [FactOrganizationStatusCountId],
	--                  [FactTypeId],
	--                  [K12SchoolId],
	--                  [SchoolYearId],
	--                  [RaceId],
	--                  [IdeaStatusId],
	--                  [K12DemographicId],
	--                  [OrganizationStatusCount]
	--         FROM     [RDS].[FactOrganizationStatusCounts]
	--         ORDER BY [FactOrganizationStatusCountId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactOrganizationStatusCounts] OFF;
	--     END

	DROP TABLE [RDS].[FactOrganizationStatusCounts];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactOrganizationStatusCounts]', N'FactOrganizationStatusCounts';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactOrganizationStatusCount1]', N'PK_FactOrganizationStatusCount', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimIdeaStatuses]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimIdeaStatuses]
		ON [RDS].[FactOrganizationStatusCounts]([IdeaStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorCategories]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorCategories]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolPerformanceIndicatorCategoryId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimK12Demographics]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimK12Demographics]
		ON [RDS].[FactOrganizationStatusCounts]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimK12Schools]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimK12Schools]
		ON [RDS].[FactOrganizationStatusCounts]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimRace]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimRace]
		ON [RDS].[FactOrganizationStatusCounts]([RaceId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimSchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolYearId]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimSchoolQualityOrStudentSuccessIndicators]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolQualityOrStudentSuccessIndicators]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolQualityOrStudentSuccessIndicatorId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorStateDefinedStatuses]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorStateDefinedStatuses]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolPerformanceIndicatorStateDefinedStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactOrganizationStatusCounts].[IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicators]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicators]
		ON [RDS].[FactOrganizationStatusCounts]([SchoolPerformanceIndicatorId] ASC);


	
	PRINT N'Starting rebuilding table [RDS].[FactPsStudentAcademicAwards]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactPsStudentAcademicAwards] (
		[FactPsStudentAcademicAwardId] INT IDENTITY (1, 1) NOT NULL,
		[PsInstitutionID]              INT CONSTRAINT [DF_FactPsStudentAcademicAwards_PsInstitutionId] DEFAULT ((-1)) NOT NULL,
		[PsStudentId]                  BIGINT CONSTRAINT [DF_FactPsStudentAcademicAwards_PsStudentId] DEFAULT ((-1)) NOT NULL,
		[PsAcademicAwardTitleId]       INT CONSTRAINT [DF_FactPsStudentAcademicAwards_PsAcademicAwardTitleId] DEFAULT ((-1)) NOT NULL,
		[AcademicAwardDateId]          INT CONSTRAINT [DF_FactPsStudentAcademicAwards_AcademicAwardDateId] DEFAULT ((-1)) NOT NULL,
		[PsAcademicAwardStatusId]      INT CONSTRAINT [DF_FactPsStudentAcademicAwards_PsAcademicAwardStatusId] DEFAULT ((-1)) NOT NULL,
		[StudentCount]                 INT CONSTRAINT [DF_FactPsStudentAcademicAwards_StudentCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactPsStudentAcademicAwards1] PRIMARY KEY CLUSTERED ([FactPsStudentAcademicAwardId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactPsStudentAcademicAwards])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactPsStudentAcademicAwards] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactPsStudentAcademicAwards] ([FactPsStudentAcademicAwardId], [PsInstitutionID], [PsStudentId], [AcademicAwardDateId], [PsAcademicAwardStatusId], [StudentCount])
	--         SELECT   [FactPsStudentAcademicAwardId],
	--                  [PsInstitutionID],
	--                  [PsStudentId],
	--                  [AcademicAwardDateId],
	--                  [PsAcademicAwardStatusId],
	--                  [StudentCount]
	--         FROM     [RDS].[FactPsStudentAcademicAwards]
	--         ORDER BY [FactPsStudentAcademicAwardId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactPsStudentAcademicAwards] OFF;
	--     END

	DROP TABLE [RDS].[FactPsStudentAcademicAwards];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactPsStudentAcademicAwards]', N'FactPsStudentAcademicAwards';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactPsStudentAcademicAwards1]', N'PK_FactPsStudentAcademicAwards', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_AcademicAwardDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_AcademicAwardDateId]
		ON [RDS].[FactPsStudentAcademicAwards]([AcademicAwardDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_AcademicAwardTitleId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_AcademicAwardTitleId]
		ON [RDS].[FactPsStudentAcademicAwards]([PsAcademicAwardTitleId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_PsAcademicAwardStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_PsAcademicAwardStatusId]
		ON [RDS].[FactPsStudentAcademicAwards]([PsAcademicAwardStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_PsInstitutionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_PsInstitutionId]
		ON [RDS].[FactPsStudentAcademicAwards]([PsInstitutionID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicAwards].[IXFK_FactPsStudentAcademicAwards_PsStudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicAwards_PsStudentId]
		ON [RDS].[FactPsStudentAcademicAwards]([PsStudentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[FactPsStudentAcademicRecords].[AdvancePlacementsCreditsAwarded] is being dropped, data loss could occur.

	The column [RDS].[FactPsStudentAcademicRecords].[PsInstitutionStatuseId] is being dropped, data loss could occur.

	The column [RDS].[FactPsStudentAcademicRecords].[CountDateId] on table [RDS].[FactPsStudentAcademicRecords] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[FactPsStudentAcademicRecords]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactPsStudentAcademicRecords] (
		[FactPsStudentAcademicRecordId]          BIGINT         IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                           INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_SchoolYearId] DEFAULT ((-1)) NOT NULL,
		[CountDateId]                            INT            NOT NULL,
		[SeaId]                                  INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_SeaId] DEFAULT ((-1)) NOT NULL,
		[PsInstitutionID]                        INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_PsInstitutionId] DEFAULT ((-1)) NOT NULL,
		[PsStudentId]                            BIGINT         CONSTRAINT [DF_FactPsStudentAcademicRecords_PsStudentId] DEFAULT ((-1)) NOT NULL,
		[AcademicTermDesignatorId]               INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_AcademicTermDesignatorId] DEFAULT ((-1)) NOT NULL,
        [PsDemographicId]                        INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_PsDemographicId] DEFAULT (-1) NOT NULL,
		[PsInstitutionStatusId]                  INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_PsInstitutionStatusId] DEFAULT ((-1)) NOT NULL,
		[PsEnrollmentStatusId]                   BIGINT         CONSTRAINT [DF_FactPsStudentAcademicRecords_PsEnrollmentStatusId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentEntryDateId]                  INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_EnrollmentEntryDateId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentExitDateId]                   INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_EnrollmentExitDateId] DEFAULT ((-1)) NOT NULL,
		[DataCollectionId]                       INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_DataCollectionId] DEFAULT ((-1)) NOT NULL,
        [InstructionalActivityHoursCompletedCredit] DECIMAL (10, 2) NULL,
		[GradePointAverage]                      DECIMAL (5, 4) NULL,
		[GradePointAverageCumulative]            DECIMAL (5, 4) NULL,
		[DualCreditDualEnrollmentCreditsAwarded] DECIMAL (4, 2) NULL,
		[APCreditsAwarded]                       INT            NULL,
		[CourseTotal]                            INT            NULL,
		[StudentCourseCount]                     INT            CONSTRAINT [DF_FactPsStudentAcademicRecords_StudentCourseCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactPsStudentAcademicRecords1] PRIMARY KEY CLUSTERED ([FactPsStudentAcademicRecordId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [RDS].[FactPsStudentAcademicRecords];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactPsStudentAcademicRecords]', N'FactPsStudentAcademicRecords';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactPsStudentAcademicRecords1]', N'PK_FactPsStudentAcademicRecords', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_AcademicTermDesignatorId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_AcademicTermDesignatorId]
		ON [RDS].[FactPsStudentAcademicRecords]([AcademicTermDesignatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_DataCollectionId]
		ON [RDS].[FactPsStudentAcademicRecords]([DataCollectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_EnrollmentEntryDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_EnrollmentEntryDateId]
		ON [RDS].[FactPsStudentAcademicRecords]([EnrollmentEntryDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_EnrollmentExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_EnrollmentExitDateId]
		ON [RDS].[FactPsStudentAcademicRecords]([EnrollmentExitDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_PsEnrollmentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_PsEnrollmentStatusId]
		ON [RDS].[FactPsStudentAcademicRecords]([PsEnrollmentStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_PsInstitutionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_PsInstitutionId]
		ON [RDS].[FactPsStudentAcademicRecords]([PsInstitutionID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_PsInstitutionStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_PsInstitutionStatusId]
		ON [RDS].[FactPsStudentAcademicRecords]([PsInstitutionStatusId] ASC) WITH (DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_PsStudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_PsStudentId]
		ON [RDS].[FactPsStudentAcademicRecords]([PsStudentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_SchoolYearId]
		ON [RDS].[FactPsStudentAcademicRecords]([SchoolYearId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentAcademicRecords].[IXFK_FactPsStudentAcademicRecords_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentAcademicRecords_SeaId]
		ON [RDS].[FactPsStudentAcademicRecords]([SeaId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[FactPsStudentEnrollments].[AgeId] is being dropped, data loss could occur.

	The column [RDS].[FactPsStudentEnrollments].[EntryDateId] is being dropped, data loss could occur.

	The column [RDS].[FactPsStudentEnrollments].[ExitDateId] is being dropped, data loss could occur.
	*/
	
	-- PRINT N'Starting rebuilding table [RDS].[FactPsStudentEnrollments]...';


	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_FactPsStudentEnrollments] (
		[FactPsStudentEnrollmentId]    BIGINT IDENTITY (1, 1) NOT NULL,
		[DataCollectionId]             INT    CONSTRAINT [DF_FactPsStudentEnrollments_DataCollectionId] DEFAULT ((-1)) NOT NULL,
		[SchoolYearId]                 INT    CONSTRAINT [DF_FactPsStudentEnrollments_SchoolYearId] DEFAULT ((-1)) NOT NULL,
    	[CountDateId]                  INT    CONSTRAINT [DF_FactPsStudentEnrollments_CountDateId] DEFAULT (-1) NOT NULL,
		[PsInstitutionID]              INT    CONSTRAINT [DF_FactPsStudentEnrollments_PsInstitutionId] DEFAULT ((-1)) NOT NULL,
		[PsStudentId]                  BIGINT    CONSTRAINT [DF_FactPsStudentEnrollments_PsStudentId] DEFAULT ((-1)) NOT NULL,
		[AcademicTermDesignatorId]     INT    CONSTRAINT [DF_FactPsStudentEnrollments_AcademicTermDesignatorId] DEFAULT ((-1)) NOT NULL,
		[EntryDateIntoPostSecondaryId] INT    CONSTRAINT [DF_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentEntryDateId]        INT    CONSTRAINT [DF_FactPsStudentEnrollments_EnrollmentEntryDateId] DEFAULT ((-1)) NOT NULL,
		[EnrollmentExitDateId]         INT    CONSTRAINT [DF_FactPsStudentEnrollments_EnrollmentExitDateId] DEFAULT ((-1)) NOT NULL,
		[PsEnrollmentStatusId]         BIGINT CONSTRAINT [DF_FactPsStudentEnrollments_PsEnrollmentStatusId] DEFAULT ((-1)) NOT NULL,
		[PsInstitutionStatusId]        INT    CONSTRAINT [DF_FactPsStudentEnrollments_PsInstitutionStatusId] DEFAULT ((-1)) NOT NULL,
		[StudentCount]                 INT    CONSTRAINT [DF_FactPsStudentEnrollments_StudentCount] DEFAULT ((1)) NOT NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_FactPsStudentEnrollments1] PRIMARY KEY CLUSTERED ([FactPsStudentEnrollmentId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [RDS].[FactPsStudentEnrollments])
	--     BEGIN
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactPsStudentEnrollments] ON;
	--         INSERT INTO [RDS].[tmp_ms_xx_FactPsStudentEnrollments] ([FactPsStudentEnrollmentId], [SchoolYearId], [DataCollectionId], [PsEnrollmentStatusId], [PsInstitutionStatusId], [PsInstitutionID], [PsStudentId], [StudentCount])
	--         SELECT   [FactPsStudentEnrollmentId],
	--                  [SchoolYearId],
	--                  [DataCollectionId],
	--                  [PsEnrollmentStatusId],
	--                  [PsInstitutionStatusId],
	--                  [PsInstitutionID],
	--                  [PsStudentId],
	--                  [StudentCount]
	--         FROM     [RDS].[FactPsStudentEnrollments]
	--         ORDER BY [FactPsStudentEnrollmentId] ASC;
	--         SET IDENTITY_INSERT [RDS].[tmp_ms_xx_FactPsStudentEnrollments] OFF;
	--     END

	DROP TABLE [RDS].[FactPsStudentEnrollments];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_FactPsStudentEnrollments]', N'FactPsStudentEnrollments';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_constraint_PK_FactPsStudentEnrollments1]', N'PK_FactPsStudentEnrollments', N'OBJECT';


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_AcademicTermDesignatorId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_AcademicTermDesignatorId]
		ON [RDS].[FactPsStudentEnrollments]([AcademicTermDesignatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_DataCollectionId]
		ON [RDS].[FactPsStudentEnrollments]([DataCollectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_EnrollmentEntryDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_EnrollmentEntryDateId]
		ON [RDS].[FactPsStudentEnrollments]([EnrollmentEntryDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId]
		ON [RDS].[FactPsStudentEnrollments]([EntryDateIntoPostSecondaryId] ASC) WITH (DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_EnrollmentExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_EnrollmentExitDateId]
		ON [RDS].[FactPsStudentEnrollments]([EnrollmentExitDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_PsEnrollmentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_PsEnrollmentStatusId]
		ON [RDS].[FactPsStudentEnrollments]([PsEnrollmentStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_PsInstitutionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_PsInstitutionId]
		ON [RDS].[FactPsStudentEnrollments]([PsInstitutionID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_PsInstitutionStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_PsInstitutionStatusId]
		ON [RDS].[FactPsStudentEnrollments]([PsInstitutionStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_PsStudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_PsStudentId]
		ON [RDS].[FactPsStudentEnrollments]([PsStudentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactPsStudentEnrollments].[IXFK_FactPsStudentEnrollments_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactPsStudentEnrollments_SchoolYearId]
		ON [RDS].[FactPsStudentEnrollments]([SchoolYearId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [RDS].[ReportEDFactsK12StaffCounts].[OrganizationNcesId] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[OrganizationStateId] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[OUTOFFIELDSTATUS] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[ParentOrganizationStateId] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[StateCode] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[StateName] is being renamed.
	The column [RDS].[ReportEDFactsK12StaffCounts].[UNEXPERIENCEDSTATUS] is being renamed.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[ReportEDFactsK12StaffCounts]...';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[OrganizationNcesId]', N'OrganizationIdentifierNces';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[OrganizationStateId]', N'OrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[OUTOFFIELDSTATUS]', N'EDFACTSTEACHEROUTOFFIELDSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[ParentOrganizationStateId]', N'ParentOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[StateCode]', N'StateAbbreviationCode';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[StateName]', N'StateAbbreviationDescription';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[UNEXPERIENCEDSTATUS]', N'EDFACTSTEACHERINEXPERIENCEDSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[CERTIFICATIONSTATUS]', N'EDFACTSCERTIFICATIONSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[QUALIFICATIONSTATUS]', N'SPECIALEDUCATIONTEACHERQUALIFICATIONSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[TITLEIIILANGUAGEINSTRUCTION]', N'TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StaffCounts].[StaffFTE]', N'StaffFullTimeEquivalency';
	


	
	/*
	The column [RDS].[ReportEDFactsK12StudentCounts].[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[LEPPERKINSSTATUS] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[OrganizationNcesId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[OrganizationStateId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[ParentOrganizationStateId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[StateCode] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentCounts].[StateName] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[ReportEDFactsK12StudentCounts]...';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM]', N'ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[OrganizationNcesId]', N'OrganizationIdentifierNces';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[OrganizationStateId]', N'OrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ParentOrganizationStateId]', N'ParentOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[StateCode]', N'StateAbbreviationCode';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[StateName]', N'StateAbbreviationDescription';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[CTEPROGRAM]', N'CTEPARTICIPANT';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[PRIMARYDISABILITYTYPE]', N'IDEADISABILITYTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[IDEAEDUCATIONALENVIRONMENT]', N'IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[FOSTERCAREPROGRAM]', N'PROGRAMPARTICIPATIONFOSTERCARE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[MEPSERVICESTYPE]', N'MIGRANTEDUCATIONPROGRAMSERVICESTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[MEPENROLLMENTTYPE]', N'MIGRANTEDUCATIONPROGRAMENROLLMENTTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[TITLEIIILANGUAGEINSTRUCTION]', N'TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[TITLEIIIPROGRAMPARTICIPATION]', N'TITLEIIIIMMIGRANTSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[SINGLEPARENTORSINGLEPREGNANTWOMAN]', N'SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[IMPROVEMENTSTATUSCODE]', N'SCHOOLIMPROVEMENTSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[StudentRate]', N'ADJUSTEDCOHORTGRADUATIONRATE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ACADEMICORVOCATIONALOUTCOME]', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[LONGTERMSTATUS]', N'NEGLECTEDORDELINQUENTLONGTERMSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ASSESSMENTPROGRESSLEVEL]', N'PROGRESSLEVEL';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ASSESSMENTSUBJECT]', N'ASSESSMENTACADEMICSUBJECT';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[ACADEMICORVOCATIONALEXITOUTCOME]', N'EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentCounts].[LEPPERKINSSTATUS]', N'PERKINSENGLISHLEARNERSTATUS';

	

	ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD CTECONCENTRATOR NVARCHAR(50);
	ALTER TABLE [RDS].[ReportEDFactsK12StudentCounts] ADD IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD NVARCHAR(50);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsK12StudentCounts].[IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report') BEGIN
		CREATE NONCLUSTERED INDEX [IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report]
			ON [RDS].[ReportEDFactsK12StudentCounts]([CategorySetCode] ASC, [PRIMARYDISABILITYTYPE] ASC, [ReportCode] ASC, [ReportLevel] ASC, [ReportYear] ASC)
			INCLUDE([CTEPROGRAM], [ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS], [ENGLISHLEARNERSTATUS], [FOSTERCAREPROGRAM], [HOMELESSNESSSTATUS], [MIGRANTSTATUS], [OrganizationIdentifierNces], [OrganizationIdentifierSea], [OrganizationName], [ParentOrganizationIdentifierSea], [SECTION504STATUS], [StateAbbreviationCode], [StateAbbreviationDescription], [StateANSICode], [StudentCount], [TITLEIIIIMMIGRANTPARTICIPATIONSTATUS], [TITLEISCHOOLSTATUS]);
	END

	
	PRINT N'Creating Index [RDS].[ReportEDFactsK12StudentCounts].[IX_FactStudentCountReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_FactStudentCountReports_ReportCode_ReportYear_ReportLevel_CategorySetCode') BEGIN
		CREATE NONCLUSTERED INDEX [IX_FactStudentCountReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]
			ON [RDS].[ReportEDFactsK12StudentCounts]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC);
	END

	
	--TODO: Add these columns
	/*
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[LEPPERKINSSTATUS] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationNcesId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationStateId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[ParentOrganizationStateId] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[StateCode] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[StateName] is being dropped, data loss could occur.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationIdentifierNces] on table [RDS].[ReportEDFactsK12StudentDisciplines] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationIdentifierSea] on table [RDS].[ReportEDFactsK12StudentDisciplines] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[StateAbbreviationCode] on table [RDS].[ReportEDFactsK12StudentDisciplines] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	The column [RDS].[ReportEDFactsK12StudentDisciplines].[StateAbbreviationDescription] on table [RDS].[ReportEDFactsK12StudentDisciplines] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[ReportEDFactsK12StudentDisciplines]...';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAM]', N'ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationNcesId]', N'OrganizationIdentifierNces';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[OrganizationStateId]', N'OrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[ParentOrganizationStateId]', N'ParentOrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[StateCode]', N'StateAbbreviationCode';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[StateName]', N'StateAbbreviationDescription';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[CTEPROGRAM]', N'CTEPARTICIPANT';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[PRIMARYDISABILITYTYPE]', N'IDEADISABILITYTYPE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[IDEAEDUCATIONALENVIRONMENT]', N'IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[FOSTERCAREPROGRAM]', N'PROGRAMPARTICIPATIONFOSTERCARE';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[TITLEIIIPROGRAMPARTICIPATION]', N'TITLEIIIIMMIGRANTSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[SINGLEPARENTORSINGLEPREGNANTWOMAN]', N'SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS';
	EXECUTE sp_rename N'[RDS].[ReportEDFactsK12StudentDisciplines].[LEPPERKINSSTATUS]', N'PERKINSENGLISHLEARNERSTATUS';

	

	ALTER TABLE [RDS].[ReportEDFactsK12StudentDisciplines] ADD CTECONCENTRATOR NVARCHAR(50);
	ALTER TABLE [RDS].[ReportEDFactsK12StudentDisciplines] ADD IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD NVARCHAR(50);
	ALTER TABLE [RDS].[ReportEDFactsK12StudentDisciplines] ADD DISCIPLINEREASON NVARCHAR(50);
	ALTER TABLE [RDS].[ReportEDFactsK12StudentDisciplines] ADD INCIDENTBEHAVIOR NVARCHAR(50);
	ALTER TABLE [RDS].[ReportEDFactsK12StudentDisciplines] ADD INCIDENTINJURYTYPE NVARCHAR(50);

	

	PRINT N'Creating Index [RDS].[ReportEDFactsK12StudentDisciplines].[IX_FactStudentDisciplineReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name='IX_FactStudentDisciplineReports_ReportCode_ReportYear_ReportLevel_CategorySetCode') BEGIN
		CREATE NONCLUSTERED INDEX [IX_FactStudentDisciplineReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]
			ON [RDS].[ReportEDFactsK12StudentDisciplines]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC);
	END

	
	/*
	The column [RDS].[ReportK12PsProgramEffectiveness].[EconomicDisadvantagedStatus] is being dropped, data loss could occur.
	The column [RDS].[ReportK12PsProgramEffectiveness].[K12OrganizationIdentifier] is being dropped, data loss could occur.
	The column [RDS].[ReportK12PsProgramEffectiveness].[PsInstitutionIdentifier] is being dropped, data loss could occur.
	The column [RDS].[ReportK12PsProgramEffectiveness].[PsInstitutionName] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [RDS].[ReportK12PsProgramEffectiveness]...';
	EXECUTE sp_rename N'[RDS].[ReportK12PsProgramEffectiveness].[EconomicDisadvantagedStatus]', N'EconomicDisadvantageStatus';
	EXECUTE sp_rename N'[RDS].[ReportK12PsProgramEffectiveness].[K12OrganizationIdentifier]', N'K12OrganizationIdentifierSea';
	EXECUTE sp_rename N'[RDS].[ReportK12PsProgramEffectiveness].[PsInstitutionIdentifier]', N'IPEDSIdentifier';
	EXECUTE sp_rename N'[RDS].[ReportK12PsProgramEffectiveness].[PsInstitutionName]', N'PsNameOfInstitution';


	/*
	The column [RDS].[ReportPsAttainment].[	] is being renamed.
	The column [RDS].[ReportPsAttainment].[PsInstitutionIdentifier] is being renamed.
	*/
	EXECUTE sp_rename 'RDS.ReportPsAttainment.	', 'MostPrevalentLevelOfInstitution';
	EXECUTE sp_rename N'[RDS].[ReportPsAttainment].[PsInstitutionIdentifier]', N'IPEDSIdentifier';


	
	PRINT N'Starting rebuilding table [RDS].[ReportPsAttainment]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_ReportPsAttainment] (
		[ReportLevel]                     NVARCHAR (20)  NOT NULL,
		[ReportCode]                      NVARCHAR (20)  NOT NULL,
		[SchoolYear]                      SMALLINT       NULL,
		[CategorySetCode]                 NVARCHAR (20)  NOT NULL,
		[IPEDSIdentifier]                 NVARCHAR (40)  NULL,
		[PsInstitutionName]               NVARCHAR (100) NULL,
		[ReportMeasureLabel]              NVARCHAR (100) NULL,
		[ReportMeasure]                   NVARCHAR (MAX) NOT NULL,
		[AcademicAwardYear]               SMALLINT       NULL,
		[AgeRange]                        NVARCHAR (20)  NULL,
		[CumulativeCreditsEarnedRange]    NVARCHAR (20)  NULL,
		[Earned24CreditsFirst12Months]    NVARCHAR (20)  NULL,
		[EconomicDisadvantageStatus]      NVARCHAR (20)  NULL,
		[EnglishLearnerStatus]            NVARCHAR (20)  NULL,
		[EnrolledFirstToSecondFall]       NVARCHAR (20)  NULL,
		[HomelessnessStatus]              NVARCHAR (20)  NULL,
		[IdeaIndicator]                   NVARCHAR (20)  NULL,
		[MigrantStatus]                   NVARCHAR (20)  NULL,
		[MostPrevalentLevelOfInstitution] NVARCHAR (20)  NULL,
		[PescAwardLevelTypeDescription]   NVARCHAR (100) NULL,
		[RaceEthnicity]                   NVARCHAR (60)  NULL,
		[RemedialSession]                 NVARCHAR (20)  NULL,
		[Sex]                             NVARCHAR (20)  NULL,
		[SchoolYearExitedFromHS]          SMALLINT       NULL
	)
	WITH (DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[StateDetail].[StateCode] is being renamed.
	The column [Staging].[StateDetail].[SeaName] is being renamed.
	The column [Staging].[StateDetail].[SeaStateIdentifier] is being renamed.
	*/

	EXECUTE sp_rename N'[Staging].[StateDetail].[StateCode]', N'StateAbbreviationCode';
	EXECUTE sp_rename N'[Staging].[StateDetail].[SeaName]', N'SeaOrganizationName';
	EXECUTE sp_rename N'[Staging].[StateDetail].[SeaShortName]', N'SeaOrganizationShortName';
	EXECUTE sp_rename N'[Staging].[StateDetail].[SeaStateIdentifier]', N'SeaOrganizationIdentifierSea';

	ALTER TABLE [Staging].[StateDetail] ALTER COLUMN [SchoolYear] SMALLINT NULL;	



	
	PRINT N'Altering Primary Key [Staging].[PK_Assessment]...';


	
	ALTER INDEX [PK_Assessment]
		ON [Staging].[Assessment] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [Staging].[PK_CharterSchoolManagementOrganization]...';


	
	ALTER INDEX [PK_CharterSchoolManagementOrganization]
		ON [Staging].[CharterSchoolManagementOrganization] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[Discipline].[DataCollectionId] is being renamed
	The column [Staging].[Discipline].[LEA_Identifier_State] is being renamed
	The column [Staging].[Discipline].[School_Identifier_State] is being renamed
	The column [Staging].[Discipline].[Student_Identifier_State] is being renamed
	*/
	
	PRINT N'Starting rebuilding table [Staging].[Discipline]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_Discipline] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[SchoolYear]                                     SMALLINT       NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[DisciplineActionIdentifier]                     NVARCHAR (100) NULL,
		[IncidentIdentifier]                             NVARCHAR (40)  NULL,
		[IncidentDate]                                   DATE           NULL,
		[IncidentTime]                                   TIME (7)       NULL,
		[DisciplinaryActionTaken]                        NVARCHAR (100) NULL,
		[DisciplineReason]                               NVARCHAR (100) NULL,
		[DisciplinaryActionStartDate]                    NVARCHAR (100) NULL,
		[DisciplinaryActionEndDate]                      NVARCHAR (100) NULL,
		[IncidentInjuryType]                             NVARCHAR (100) NULL,
		[IncidentBehavior]                               NVARCHAR (100) NULL,
		[DurationOfDisciplinaryAction]                   NVARCHAR (100) NULL,
		[IdeaInterimRemoval]                             NVARCHAR (100) NULL,
		[IdeaInterimRemovalReason]                       NVARCHAR (100) NULL,
		[EducationalServicesAfterRemoval]                BIT            NULL,
		[DisciplineMethodFirearm]                        NVARCHAR (100) NULL,
		[IDEADisciplineMethodFirearm]                    NVARCHAR (100) NULL,
		[DisciplineMethodOfCwd]                          NVARCHAR (100) NULL,
		[WeaponType]                                     NVARCHAR (100) NULL,
		[FirearmType]                                    NVARCHAR (100) NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonId]                                       INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[OrganizationPersonRoleId_LEA]                   INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationPersonRoleId_School]                INT            NULL,
		[IncidentId_LEA]                                 INT            NULL,
		[IncidentId_School]                              INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_Discipline1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [Staging].[Discipline];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_Discipline]', N'Discipline';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_Discipline1]', N'PK_Discipline', N'OBJECT';

	
	
	/*
	The column [Staging].[K12Enrollment].[LastName] is being renamed
	The column [Staging].[K12Enrollment].[LEA_Identifier_State] is being renamed
	The column [Staging].[K12Enrollment].[School_Identifier_State] is being renamed
	The column [Staging].[K12Enrollment].[Student_Identifier_State] is being renamed
	*/
	
	PRINT N'Starting rebuilding table [Staging].[K12Enrollment]...';


	

	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_K12Enrollment] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[FirstName]                                      NVARCHAR (100) NULL,
		[LastOrSurname]                                  NVARCHAR (100) NULL,
		[MiddleName]                                     NVARCHAR (100) NULL,
		[Birthdate]                                      DATE           NULL,
		[Sex]                                            NVARCHAR (30)  NULL,
		[HispanicLatinoEthnicity]                        BIT            NULL,
		[EnrollmentEntryDate]                            DATE           NULL,
		[EnrollmentExitDate]                             DATE           NULL,
		[FullTimeEquivalency]                            DECIMAL (5, 2) NULL,
		[ExitOrWithdrawalType]                           NVARCHAR (100) NULL,
		[GradeLevel]                                     NVARCHAR (100) NULL,
		[CohortYear]                                     NCHAR (4)      NULL,
		[CohortGraduationYear]                           NCHAR (4)      NULL,
		[CohortDescription]                              NCHAR (1024)   NULL,
		[ProjectedGraduationDate]                        NVARCHAR (8)   NULL,
		[HighSchoolDiplomaType]                          NVARCHAR (100) NULL,
		[LanguageNative]                                 NVARCHAR (100) NULL,
		[LanguadeHome]                                   NVARCHAR (100) NULL,
		[NumberOfSchoolDays]                             DECIMAL (9, 2) NULL,
		[NumberOfDaysAbsent]                             DECIMAL (9, 2) NULL,
		[AttendanceRate]                                 DECIMAL (5, 4) NULL,
		[PostSecondaryEnrollment]                        BIT            NULL,
		[DiplomaOrCredentialAwardDate]                   DATE           NULL,
		[FoodServiceEligibility]                         NVARCHAR (100) NULL,
		[SchoolYear]                                     SMALLINT 		NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[RecordStartDateTime]                            DATETIME       NULL,
		[RecordEndDateTime]                              DATETIME       NULL,
		[PersonId]                                       INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[OrganizationPersonRoleId_LEA]                   INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationPersonRoleId_School]                INT            NULL,
		[OrganizationPersonRoleRelationshipId]           INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_K12Enrollment1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[K12Enrollment];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_K12Enrollment]', N'K12Enrollment';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_K12Enrollment1]', N'PK_K12Enrollment', N'OBJECT';



	
	PRINT N'Creating Index [Staging].[K12Enrollment].[IX_K12Enrollment_DataCollectionName]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12Enrollment_DataCollectionName]
		ON [Staging].[K12Enrollment]([DataCollectionName] ASC)
		INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [EnrollmentEntryDate], [EnrollmentExitDate], [SchoolYear]);


	
	PRINT N'Creating Index [Staging].[K12Enrollment].[IX_Staging_K12Enrollment_DataCollectionName]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_DataCollectionName]
		ON [Staging].[K12Enrollment]([DataCollectionName] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[K12Enrollment].[IX_Staging_K12Enrollment_WithIdentifiers]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_WithIdentifiers]
		ON [Staging].[K12Enrollment]([StudentIdentifierState] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC, [EnrollmentEntryDate] ASC)
		INCLUDE([Birthdate], [Sex], [EnrollmentExitDate], [DataCollectionName], [SchoolYear]);


	
	/*
	The column [Staging].[K12Organization].[IEU_Identifier_State] is being renamed.
	The column [Staging].[K12Organization].[IEU_Identifier_State_ChangedIdentifier] is being renamed.
	The column [Staging].[K12Organization].[IEU_Identifier_State_Identifier_Old] is being renamed.
	The column [Staging].[K12Organization].[K12LeaTitleISupportServiceId] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[K12ProgramOrServiceId_LEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[K12ProgramOrServiceId_School] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[LEA_Identifier_NCES] is being renamed.
	The column [Staging].[K12Organization].[LEA_Identifier_State] is being renamed.
	The column [Staging].[K12Organization].[LEA_Identifier_State_ChangedIdentifier] is being renamed.
	The column [Staging].[K12Organization].[LEA_Identifier_State_Identifier_Old] is being renamed.
	The column [Staging].[K12Organization].[LEA_Identifier_Name] is being renamed.
	The column [Staging].[K12Organization].[OrganizationId_IEU] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationId_LEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationId_School] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationId_SEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationOperationalStatusId_IEU] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationOperationalStatusId_LEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationOperationalStatusId_School] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_IEUToLEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_LEAToSchool] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_SEAToIEU] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationRelationshipId_SEAToLEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationWebsiteId_LEA] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[OrganizationWebsiteId_School] is being dropped, data loss could occur.
	The column [Staging].[K12Organization].[Prior_LEA_Identifier_State] is being renamed.
	The column [Staging].[K12Organization].[Prior_School_Identifier_State] is being renamed.
	The column [Staging].[K12Organization].[School_Identifier_NCES] is being renamed.
	The column [Staging].[K12Organization].[School_Identifier_State] is being renamed.
	The column [Staging].[K12Organization].[School_Identifier_State_ChangedIdentifier] is being renamed.
	The column [Staging].[K12Organization].[School_Identifier_State_Identifier_Old] is being renamed.
	The column [Staging].[K12Organization].[School_IsReportedFederally] is being renamed.
	The column [Staging].[K12Organization].[ConsolidatedMepFundsStatus] is being renamed.
	The column [Staging].[K12Organization].[MepProjectType] is being renamed.
	The column [Staging].[K12Organization].[TitleIPartASchoolDesignation] is being renamed.
	The column [Staging].[K12Organization].[AdministrativeFundingControl] is being renamed.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[K12Organization]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_K12Organization] (
		[Id]                                                                	INT            IDENTITY (1, 1) NOT NULL,
		[IeuIdentifierSea]                                                  	NVARCHAR (100) NULL,
		[IEU_OrganizationName]                                                 	NVARCHAR (256) NULL,
		[IEU_OperationalStatusEffectiveDate]                                	DATETIME       NULL,
		[IEU_OrganizationOperationalStatus]                                 	VARCHAR (100)  NULL,
		[IEU_WebSiteAddress]                                                	NVARCHAR (300) NULL,
		[IEU_RecordStartDateTime]                                           	DATETIME       NULL,
		[IEU_RecordEndDateTime]                                             	DATETIME       NULL,
		[LeaIdentifierSea]		          										NVARCHAR (50)  NULL,
		[PriorLeaIdentifierSea]		                                        	NVARCHAR (50)  NULL,
		[LeaIdentifierNCES] 	                                              	NVARCHAR (50)  NULL,
		[LEA_SupervisoryUnionIdentificationNumber]                          	VARCHAR (100)  NULL,
		[LeaOrganizationName]                                                 	VARCHAR (256)  NULL,
		[LEA_WebSiteAddress]                                                	VARCHAR (300)  NULL,
		[LEA_OperationalStatus]                                             	VARCHAR (100)  NULL,
		[LEA_OperationalStatusEffectiveDate]                                	DATETIME       NULL,
		[LEA_CharterLeaStatus]                                              	VARCHAR (100)  NULL,
		[LEA_CharterSchoolIndicator]                                        	BIT            NULL,
		[LEA_Type]                                                          	VARCHAR (100)  NULL,
		[LEA_McKinneyVentoSubgrantRecipient]                                	BIT            NULL,
		[LEA_GunFreeSchoolsActReportingStatus]                              	VARCHAR (100)  NULL,
		[LEA_TitleIinstructionalService]                                    	VARCHAR (100)  NULL,
		[LEA_TitleIProgramType]                                             	VARCHAR (100)  NULL,
		[LEA_K12LeaTitleISupportService]                                    	VARCHAR (100)  NULL,
		[LEA_MepProjectType]                                                	VARCHAR (100)  NULL,
		[LEA_IsReportedFederally]                                           	BIT			   NULL,
		[LEA_RecordStartDateTime]                                           	DATETIME       NULL,
		[LEA_RecordEndDateTime]                                             	DATETIME       NULL,
		[SchoolIdentifierSea]		                                           	NVARCHAR (50)  NULL,
		[PriorSchoolIdentifierSea]		                                     	NVARCHAR (50)  NULL,
		[School_PriorLeaIdentifierSea]	                                     	NVARCHAR (50)  NULL,
		[SchoolIdentifierNCES] 		                                           	NVARCHAR (50)  NULL,
		[SchoolOrganizationName]                                              	VARCHAR (256)  NULL,
		[School_WebSiteAddress]                                             	VARCHAR (300)  NULL,
		[School_OperationalStatus]                                          	VARCHAR (100)  NULL,
		[School_OperationalStatusEffectiveDate]                             	DATETIME       NULL,
		[School_Type]                                                       	VARCHAR (100)  NULL,
		[School_MagnetOrSpecialProgramEmphasisSchool]                       	VARCHAR (100)  NULL,
		[School_SharedTimeIndicator]                                        	VARCHAR (100)  NULL,
		[School_VirtualSchoolStatus]                                        	VARCHAR (100)  NULL,
		[School_NationalSchoolLunchProgramStatus]                           	VARCHAR (100)  NULL,
		[School_ReconstitutedStatus]                                        	VARCHAR (100)  NULL,
		[School_CharterSchoolIndicator]                                     	BIT            NULL,
		[School_CharterSchoolOpenEnrollmentIndicator]                       	BIT            NULL,
		[School_CharterSchoolFEIN]                                          	VARCHAR (100)  NULL,
		[School_CharterSchoolFEIN_Update]                                   	VARCHAR (100)  NULL,
		[School_CharterContractIDNumber]                                    	VARCHAR (100)  NULL,
		[School_CharterContractApprovalDate]                                	DATETIME       NULL,
		[School_CharterContractRenewalDate]                                 	DATETIME       NULL,
		[School_CharterPrimaryAuthorizer]                                   	VARCHAR (100)  NULL,
		[School_CharterSecondaryAuthorizer]                                 	VARCHAR (100)  NULL,
		[School_StatePovertyDesignation]                                    	VARCHAR (100)  NULL,
		[School_SchoolImprovementAllocation]                                	MONEY          NULL,
		[School_IndicatorStatusType]                                        	VARCHAR (100)  NULL,
		[School_GunFreeSchoolsActReportingStatus]                           	VARCHAR (100)  NULL,
		[School_ProgressAchievingEnglishLanguageProficiencyIndicatorType]	 	VARCHAR (100)  NULL,
		[School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus] 	VARCHAR (100)  NULL,
		[School_SchoolDangerousStatus]                                      	VARCHAR (100)  NULL,
		[School_ComprehensiveAndTargetedSupport]                               	VARCHAR (100)  NULL,
		[School_ComprehensiveSupport]                                          	VARCHAR (100)  NULL,
		[School_TargetedSupport]                                               	VARCHAR (100)  NULL,
		[School_ConsolidatedMigrantEducationProgramFundsStatus]                	BIT            NULL,
		[School_MigrantEducationProgramProjectType]                            	VARCHAR (100)  NULL,
		[School_TitleIPartASchoolDesignation]                                  	VARCHAR (100)  NULL,
		[School_AdministrativeFundingControl]                                  	NVARCHAR (100) NULL,
		[School_IsReportedFederally]										   	BIT			   NULL,
		[School_RecordStartDateTime]                                           	DATETIME       NULL,
		[School_RecordEndDateTime]                                             	DATETIME       NULL,
		[SchoolYear]                                                           	SMALLINT 	   NULL,
		[DataCollectionName]                                                   	NVARCHAR (100) NULL,
		[NewIEU]                                                               	BIT            NULL,
		[NewLEA]                                                               	BIT            NULL,
		[NewSchool]                                                            	BIT            NULL,
		[RunDateTime]                                                          	DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_K12Organization1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100, STATISTICS_NORECOMPUTE = ON, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[K12Organization];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_K12Organization]', N'K12Organization';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_K12Organization1]', N'PK_K12Organization', N'OBJECT';


	
	/*
	The column [Staging].[K12ProgramParticipation].[OrganizationId] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[OrganizationIdentifier] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[OrganizationPersonRoleId] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[OrganizationType] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[ProgramOrganizationId] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[RunDateTime] is being dropped, data loss could occur.
	The column [Staging].[K12ProgramParticipation].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[K12ProgramParticipation]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_K12ProgramParticipation] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[ProgramType]                                    NVARCHAR (100) NULL,
		[EntryDate]                                      DATETIME       NULL,
		[ExitDate]                                       DATETIME       NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[SchoolYear]                                     SMALLINT 		NULL,
		[OrganizationId_LEA]                             INT            NULL,
		[OrganizationId_School]                          INT            NULL,
		[PersonId]                                       INT            NULL,
		[ProgramOrganizationId_LEA]                      INT            NULL,
		[ProgramOrganizationId_School]                   INT            NULL,
		[OrganizationPersonRoleId_LEA]                   NCHAR (10)     NULL,
		[OrganizationPersonRoleId_School]                NCHAR (10)     NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_K12ProgramParticipation1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[K12ProgramParticipation])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_K12ProgramParticipation] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_K12ProgramParticipation] ([Id], [ProgramType], [EntryDate], [ExitDate], [SchoolYear], [DataCollectionName], [PersonId])
	--         SELECT   [Id],
	--                  [ProgramType],
	--                  [EntryDate],
	--                  [ExitDate],
	--                  [SchoolYear],
	--                  [DataCollectionName],
	--                  [PersonId]
	--         FROM     [Staging].[K12ProgramParticipation]
	--         ORDER BY [Id] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_K12ProgramParticipation] OFF;
	--     END

	DROP TABLE [Staging].[K12ProgramParticipation];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_K12ProgramParticipation]', N'K12ProgramParticipation';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_K12ProgramParticipation1]', N'PK_K12ProgramParticipation', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_DataCollectionName]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_DataCollectionName]
		ON [Staging].[K12ProgramParticipation]([DataCollectionName] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_DataCollectionName_WithIncludes]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_DataCollectionName_WithIncludes]
		ON [Staging].[K12ProgramParticipation]([DataCollectionName] ASC)
		INCLUDE([LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea], [StudentIdentifierState], [ProgramType], [EntryDate], [ExitDate]);


	
	PRINT N'Creating Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_OrganizationType_ProgramType]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_OrganizationType_ProgramType]
		ON [Staging].[K12ProgramParticipation]([SchoolIdentifierSea] ASC, [ProgramType] ASC)
		INCLUDE([LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolYear]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_ProgramType]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_ProgramType]
		ON [Staging].[K12ProgramParticipation]([ProgramType] ASC)
		INCLUDE([SchoolYear], [OrganizationId_LEA], [OrganizationId_School]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[K12ProgramParticipation].[IX_K12ProgramParticipation_StudentIdentifierState]...';


	
	CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_StudentIdentifierState]
		ON [Staging].[K12ProgramParticipation]([StudentIdentifierState] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[K12StudentCourseSection].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[K12StudentCourseSection].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[K12StudentCourseSection].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[K12StudentCourseSection]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_K12StudentCourseSection] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[SchoolYear]                                     SMALLINT 		NULL,
		[CourseGradeLevel]                               VARCHAR (100)  NULL,
		[ScedCourseCode]                                 NVARCHAR (50)  NULL,
		[CourseRecordStartDateTime]                      DATETIME       NULL,
		[CourseLevelCharacteristic]                      NVARCHAR (50)  NULL,
		[EntryDate]                                      DATETIME       NULL,
		[ExitDate]                                       DATETIME       NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonId]                                       INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[OrganizationPersonRoleId_LEA]                   INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationPersonRoleId_School]                INT            NULL,
		[OrganizationID_Course]                          INT            NULL,
		[OrganizationID_CourseSection]                   INT            NULL,
		[OrganizationPersonRoleId_CourseSection]         INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_K12StudentCourseSection1] PRIMARY KEY CLUSTERED ([Id] ASC)
	);


	DROP TABLE [Staging].[K12StudentCourseSection];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_K12StudentCourseSection]', N'K12StudentCourseSection';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_K12StudentCourseSection1]', N'PK_K12StudentCourseSection', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[K12StudentCourseSection].[IX_Staging_K12StudentCourseSection_DataCollectionName_WithIdentifiers]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_K12StudentCourseSection_DataCollectionName_WithIdentifiers]
		ON [Staging].[K12StudentCourseSection]([DataCollectionName] ASC)
		INCLUDE([StudentIdentifierState], [LeaIdentifierSeaAccountability], [LeaIdentifierSeaAttendance], [LeaIdentifierSeaFunding], [LeaIdentifierSeaGraduation], [LeaIdentifierSeaIndividualizedEducationProgram], [SchoolIdentifierSea]) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [Staging].[K12StudentCourseSection].[IX_Staging_K12StudentCourseSection_ScedCourseCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_K12StudentCourseSection_ScedCourseCode]
		ON [Staging].[K12StudentCourseSection]([ScedCourseCode] ASC) WITH (FILLFACTOR = 80);


	
	/*
	The column [Staging].[Migrant].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[Migrant].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[Migrant].[Student_Identifier_State] is being dropped, data loss could occur.

	The type for column SchoolYear in table [Staging].[Migrant] is currently  VARCHAR (100) NULL but is being changed to  VARCHAR (4) NULL. Data loss could occur and deployment may fail if the column contains data that is incompatible with type  VARCHAR (4) NULL.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[Migrant]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_Migrant] (
		[Id]                                                  INT            IDENTITY (1, 1) NOT NULL,
		[RecordId]                                            VARCHAR (100)  NULL,
		[SchoolYear]                                          SMALLINT 		 NULL,
		[LeaIdentifierSeaAccountability]                      NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                          NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                             NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                          NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram]      NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                                 NVARCHAR (50)  NULL,
		[StudentIdentifierState]                              NVARCHAR (40)  NULL,
		[MigrantStatus]                                       VARCHAR (100)  NULL,
		[MigrantEducationProgramEnrollmentType]               VARCHAR (100)  NULL,
		[MigrantEducationProgramServicesType]                 VARCHAR (100)  NULL,
		[MigrantEducationProgramContinuationOfServicesStatus] BIT            NULL,
		[ContinuationOfServicesReason]                        VARCHAR (100)  NULL,
		[MigrantStudentQualifyingArrivalDate]                 DATE           NULL,
		[LastQualifyingMoveDate]                              DATE           NULL,
		[MigrantPrioritizedForServices]                       BIT            NULL,
		[ProgramParticipationStartDate]                       DATE           NULL,
		[ProgramParticipationExitDate]                        DATE           NULL,
		[DataCollectionName]                                  NVARCHAR (100) NULL,
		[PersonID]                                            INT            NULL,
		[OrganizationID_LEA]                                  INT            NULL,
		[OrganizationID_School]                               INT            NULL,
		[LEAOrganizationPersonRoleID_MigrantProgram]          INT            NULL,
		[LEAOrganizationID_MigrantProgram]                    INT            NULL,
		[SchoolOrganizationPersonRoleID_MigrantProgram]       INT            NULL,
		[SchoolOrganizationID_MigrantProgram]                 INT            NULL,
		[PersonProgramParticipationId]                        INT            NULL,
		[ProgramParticipationMigrantId]                       INT            NULL,
		[RunDateTime]                                         DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_Migrant1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[Migrant];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_Migrant]', N'Migrant';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_Migrant1]', N'PK_Migrant', N'OBJECT';


	
	/*
	The column [Staging].[OrganizationAddress].[AddressApartmentRoomOrSuite] is being dropped, data loss could occur.

	The column [Staging].[OrganizationAddress].[AddressCountyAnsiCode] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[OrganizationAddress]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_OrganizationAddress] (
		[Id]                                INT            IDENTITY (1, 1) NOT NULL,
		[OrganizationIdentifier]            NVARCHAR (50)  NULL,
		[OrganizationType]                  VARCHAR (100)  NULL,
		[AddressTypeForOrganization]        VARCHAR (50)   NULL,
		[AddressStreetNumberAndName]        VARCHAR (150)  NULL,
		[AddressApartmentRoomOrSuiteNumber] VARCHAR (50)   NULL,
		[AddressCity]                       VARCHAR (30)   NULL,
		[AddressCountyAnsiCodeCode]         NVARCHAR (7)   NULL,
		[StateAbbreviation]                 VARCHAR (2)    NULL,
		[AddressPostalCode]                 VARCHAR (17)   NULL,
		[Latitude]                          NVARCHAR (100) NULL,
		[Longitude]                         NVARCHAR (100) NULL,
		[SchoolYear]                        SMALLINT       NULL,
		[DataCollectionName]                NVARCHAR (100) NULL,
		[RecordStartDateTime]               DATETIME       NULL,
		[RecordEndDateTime]                 DATETIME       NULL,
		[RefStateId]                        INT            NULL,
		[OrganizationId]                    VARCHAR (100)  NULL,
		[LocationId]                        VARCHAR (100)  NULL,
		[RunDateTime]                       DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_OrganizationAddress1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100, STATISTICS_NORECOMPUTE = ON, DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [Staging].[OrganizationAddress];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_OrganizationAddress]', N'OrganizationAddress';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_OrganizationAddress1]', N'PK_OrganizationAddress', N'OBJECT';


	
	PRINT N'Altering Table [Staging].[OrganizationCalendarSession]...';


	
	ALTER TABLE [Staging].[OrganizationCalendarSession] DROP COLUMN [RunDateTime];
	ALTER TABLE [Staging].[OrganizationCalendarSession] ALTER COLUMN [OrganizationIdentifier] NVARCHAR(50) NULL;


	
	PRINT N'Altering Primary Key [Staging].[PK_Session]...';


	
	ALTER INDEX [PK_Session]
		ON [Staging].[OrganizationCalendarSession] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Table [Staging].[OrganizationFederalFunding]...';


	
	ALTER TABLE [Staging].[OrganizationFederalFunding] ALTER COLUMN [SchoolYear] SMALLINT NULL;
	ALTER TABLE [Staging].[OrganizationFederalFunding] ALTER COLUMN [OrganizationIdentifier] NVARCHAR(50) NULL;


	
	PRINT N'Altering Table [Staging].[OrganizationGradeOffered]...';


	--We need to verify this change, commented out for now.
	
--	ALTER TABLE [Staging].[OrganizationGradeOffered] DROP COLUMN [RecordEndDateTime], COLUMN [RecordStartDateTime];


	
	ALTER TABLE [Staging].[OrganizationGradeOffered] ALTER COLUMN [OrganizationId] VARCHAR (100) NULL;


	
	PRINT N'Altering Primary Key [Staging].[PK_OrganizationGradeOffered]...';


	
	ALTER INDEX [PK_OrganizationGradeOffered]
		ON [Staging].[OrganizationGradeOffered] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[OrganizationGradeOffered].[IX_Staging_OrganizationGradesOffered_OrganizationId]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_OrganizationGradesOffered_OrganizationId]
		ON [Staging].[OrganizationGradeOffered]([OrganizationId] ASC) WITH (FILLFACTOR = 100, STATISTICS_NORECOMPUTE = ON);


	
	/*
	The column [Staging].[OrganizationPhone].[OrganizationTelephoneId] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[OrganizationPhone]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_OrganizationPhone] (
		[Id]                              INT            IDENTITY (1, 1) NOT NULL,
		[OrganizationIdentifier]          NVARCHAR (50)  NULL,
		[OrganizationType]                VARCHAR (100)  NULL,
		[InstitutionTelephoneNumberType]  VARCHAR (100)  NULL,
		[TelephoneNumber]                 VARCHAR (100)  NULL,
		[PrimaryTelephoneNumberIndicator] BIT            NULL,
		[SchoolYear]                      SMALLINT		 NULL,
		[DataCollectionName]              NVARCHAR (100) NULL,
		[RecordStartDateTime]             DATETIME       NULL,
		[RecordEndDateTime]               DATETIME       NULL,
		[OrganizationId]                  VARCHAR (100)  NULL,
		[LEA_OrganizationTelephoneId]     INT            NULL,
		[School_OrganizationTelephoneId]  INT            NULL,
		[RunDateTime]                     DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_OrganizationPhone1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 100, STATISTICS_NORECOMPUTE = ON)
	);

	DROP TABLE [Staging].[OrganizationPhone];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_OrganizationPhone]', N'OrganizationPhone';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_OrganizationPhone1]', N'PK_OrganizationPhone', N'OBJECT';


	
	PRINT N'Altering Table [Staging].[OrganizationProgramType]...';


	
	ALTER TABLE [Staging].[OrganizationProgramType] DROP COLUMN [OrganizationName], COLUMN [RunDateTime];
	ALTER TABLE [Staging].[OrganizationProgramType] ALTER COLUMN [OrganizationIdentifier] NVARCHAR(50) NULL;
	ALTER TABLE [Staging].[OrganizationProgramType] ALTER COLUMN [SchoolYear] SMALLINT NULL;


	
	PRINT N'Altering Primary Key [Staging].[PK_OrganizationProgramType]...';


	
	ALTER INDEX [PK_OrganizationProgramType]
		ON [Staging].[OrganizationProgramType] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[OrganizationProgramType].[IX_OrganizationProgramType_OrganizationId_ProgramOrganizationId]...';


	
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_OrganizationId_ProgramOrganizationId]
		ON [Staging].[OrganizationProgramType]([OrganizationId] ASC, [ProgramOrganizationId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[OrganizationProgramType].[IX_OrganizationProgramType_OrganizationId_ProgramTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_OrganizationId_ProgramTypeId]
		ON [Staging].[OrganizationProgramType]([OrganizationId] ASC, [ProgramTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[OrganizationProgramType].[IX_OrganizationProgramType_OrganizationType]...';


	
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_OrganizationType]
		ON [Staging].[OrganizationProgramType]([OrganizationType] ASC)
		INCLUDE([OrganizationIdentifier], [OrganizationId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[OrganizationProgramType].[IX_OrganizationProgramType_ProgramType]...';


	
	CREATE NONCLUSTERED INDEX [IX_OrganizationProgramType_ProgramType]
		ON [Staging].[OrganizationProgramType]([ProgramType] ASC)
		INCLUDE([SchoolYear], [ProgramTypeId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport].[RunDateTime] is being dropped, data loss could occur.
	The column [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport].[SchoolIdentifierSea] on table [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport]...';


	

	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_OrganizationSchoolComprehensiveAndTargetedSupport] (
		[Id]                                     INT            IDENTITY (1, 1) NOT NULL,
		[SchoolIdentifierSea]                    NVARCHAR (50)  NOT NULL,
		[SchoolYear]                             SMALLINT 		NULL,
		[School_ComprehensiveAndTargetedSupport] VARCHAR (100)  NULL,
		[School_ComprehensiveSupport]            VARCHAR (100)  NULL,
		[School_TargetedSupport]                 VARCHAR (100)  NULL,
		[DataCollectionName]                     NVARCHAR (100) NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_OrganizationSchoolComprehensiveAndTargetedSupport1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_OrganizationSchoolComprehensiveAndTargetedSupport]', N'OrganizationSchoolComprehensiveAndTargetedSupport';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_OrganizationSchoolComprehensiveAndTargetedSupport1]', N'PK_OrganizationSchoolComprehensiveAndTargetedSupport', N'OBJECT';


	
	/*
	The column [Staging].[PersonStatus].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationID_IEU_Program_Foster] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationID_IEU_Program_Homeless] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationID_IEU_Program_Immigrant] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationID_IEU_Program_Section504] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Foster] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Homeless] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Immigrant] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_Program_Section504] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[OrganizationPersonRoleID_IEU_SPED] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[PersonStatusId_PerkinsEL] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[PersonStatus].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[PersonStatus]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_PersonStatus] (
		[Id]                                                     INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                                 NVARCHAR (40) NULL,
		[LeaIdentifierSeaAccountability]                         NVARCHAR (50) NULL,
		[LeaIdentifierSeaAttendance]                             NVARCHAR (50) NULL,
		[LeaIdentifierSeaFunding]                                NVARCHAR (50) NULL,
		[LeaIdentifierSeaGraduation]                             NVARCHAR (50) NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram]         NVARCHAR (50) NULL,
		[SchoolIdentifierSea]                                    NVARCHAR (50) NULL,
		[HomelessnessStatus]                                     BIT            NULL,
		[Homelessness_StatusStartDate]                           DATE           NULL,
		[Homelessness_StatusEndDate]                             DATE           NULL,
		[HomelessNightTimeResidence]                             NVARCHAR (100) NULL,
		[HomelessNightTimeResidence_StartDate]                   DATE           NULL,
		[HomelessNightTimeResidence_EndDate]                     DATE           NULL,
		[HomelessUnaccompaniedYouth]                             BIT            NULL,
		[HomelessServicedIndicator]                              BIT            NULL,
		[EconomicDisadvantageStatus]                             BIT            NULL,
		[EconomicDisadvantage_StatusStartDate]                   DATE           NULL,
		[EconomicDisadvantage_StatusEndDate]                     DATE           NULL,
		[EligibilityStatusForSchoolFoodServicePrograms]          NVARCHAR (100) NULL,
		[NationalSchoolLunchProgramDirectCertificationIndicator] BIT            NULL,
		[MigrantStatus]                                          BIT            NULL,
		[Migrant_StatusStartDate]                                DATE           NULL,
		[Migrant_StatusEndDate]                                  DATE           NULL,
		[MilitaryConnectedStudentIndicator]                      NVARCHAR (100) NULL,
		[MilitaryConnected_StatusStartDate]                      DATE           NULL,
		[MilitaryConnected_StatusEndDate]                        DATE           NULL,
		[ProgramType_FosterCare]                                 BIT            NULL,
		[FosterCare_ProgramParticipationStartDate]               DATE           NULL,
		[FosterCare_ProgramParticipationEndDate]                 DATE           NULL,
		[ProgramType_Section504]                                 BIT            NULL,
		[Section504_ProgramParticipationStartDate]               DATE           NULL,
		[Section504_ProgramParticipationEndDate]                 DATE           NULL,
		[ProgramType_Immigrant]                                  BIT            NULL,
		[Immigrant_ProgramParticipationStartDate]                DATE           NULL,
		[Immigrant_ProgramParticipationEndDate]                  DATE           NULL,
		[EnglishLearnerStatus]                                   BIT            NULL,
		[EnglishLearner_StatusStartDate]                         DATE           NULL,
		[EnglishLearner_StatusEndDate]                           DATE           NULL,
		[ISO_639_2_NativeLanguage]                               NVARCHAR (100) NULL,
		[PerkinsELStatus]                                        NVARCHAR (100) NULL,
		[PerkinsELStatus_StatusStartDate]                        DATE           NULL,
		[PerkinsELStatus_StatusEndDate]                          DATE           NULL,
		[DataCollectionName]                                     NVARCHAR (100) NULL,
		[PersonId]                                               INT            NULL,
		[OrganizationID_LEA]                                     INT            NULL,
		[OrganizationPersonRoleID_LEA]                           INT            NULL,
		[OrganizationID_School]                                  INT            NULL,
		[OrganizationPersonRoleID_School]                        INT            NULL,
		[OrganizationID_Program_Foster]                          INT            NULL,
		[OrganizationID_LEA_Program_Foster]                      INT            NULL,
		[OrganizationPersonRoleID_LEA_Program_Foster]            INT            NULL,
		[OrganizationID_School_Program_Foster]                   INT            NULL,
		[OrganizationPersonRoleID_School_Program_Foster]         INT            NULL,
		[OrganizationID_Program_Section504]                      INT            NULL,
		[OrganizationID_LEA_Program_Section504]                  INT            NULL,
		[OrganizationPersonRoleID_LEA_Program_Section504]        INT            NULL,
		[OrganizationID_School_Program_Section504]               INT            NULL,
		[OrganizationPersonRoleID_School_Program_Section504]     INT            NULL,
		[OrganizationID_Program_Immigrant]                       INT            NULL,
		[OrganizationID_LEA_Program_Immigrant]                   INT            NULL,
		[OrganizationPersonRoleID_LEA_Program_Immigrant]         INT            NULL,
		[OrganizationID_School_Program_Immigrant]                INT            NULL,
		[OrganizationPersonRoleID_School_Program_Immigrant]      INT            NULL,
		[OrganizationPersonRoleID_LEA_SPED]                      INT            NULL,
		[OrganizationPersonRoleID_School_SPED]                   INT            NULL,
		[OrganizationID_LEA_Program_Homeless]                    INT            NULL,
		[OrganizationPersonRoleID_LEA_Program_Homeless]          INT            NULL,
		[OrganizationID_School_Program_Homeless]                 INT            NULL,
		[OrganizationPersonRoleID_School_Program_Homeless]       INT            NULL,
		[PersonStatusId_Homeless]                                INT            NULL,
		[PersonHomelessNightTimeResidenceId]                     INT            NULL,
		[PersonStatusId_EconomicDisadvantage]                    INT            NULL,
		[PersonStatusId_IDEA]                                    INT            NULL,
		[PersonStatusId_EnglishLearner]                          INT            NULL,
		[PersonLanguageId]                                       INT            NULL,
		[PersonStatusId_Migrant]                                 INT            NULL,
		[PersonMilitaryId]                                       INT            NULL,
		[PersonHomelessnessId]                                   INT            NULL,
		[RunDateTime]                                            DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_PersonStatus1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[PersonStatus];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_PersonStatus]', N'PersonStatus';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_PersonStatus1]', N'PK_PersonStatus', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[PersonStatus].[IX_PersonStatus_OrganizationId_LEA]...';


	
	CREATE NONCLUSTERED INDEX [IX_PersonStatus_OrganizationId_LEA]
		ON [Staging].[PersonStatus]([OrganizationID_LEA] ASC);


	
	PRINT N'Creating Index [Staging].[PersonStatus].[IX_PersonStatus_PersonId]...';


	
	CREATE NONCLUSTERED INDEX [IX_PersonStatus_PersonId]
		ON [Staging].[PersonStatus]([PersonId] ASC);


	
	PRINT N'Creating Index [Staging].[PersonStatus].[Staging_PersonStatus_WithIdentifiers]...';


	
	CREATE NONCLUSTERED INDEX [Staging_PersonStatus_WithIdentifiers]
		ON [Staging].[PersonStatus]([DataCollectionName] ASC, [LeaIdentifierSeaAccountability] ASC, [LeaIdentifierSeaAttendance] ASC, [LeaIdentifierSeaFunding] ASC, [LeaIdentifierSeaGraduation] ASC, [LeaIdentifierSeaIndividualizedEducationProgram] ASC, [SchoolIdentifierSea] ASC, [StudentIdentifierState] ASC);


	
	/*
	The column [Staging].[ProgramParticipationCTE].[DataCollectionId] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[IEU_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationID_CTEProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationID_CTEProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationID_CTEProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationID_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_CTEProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_CTEProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_CTEProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[OrganizationPersonRoleID_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[PersonProgramParticipationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[PersonProgramParticipationID_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[PersonProgramParticipationID_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationCTE].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	-- 
	-- PRINT N'Starting rebuilding table [Staging].[ProgramParticipationCTE]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_ProgramParticipationCTE] (
		[ID]                                             INT            IDENTITY (1, 1) NOT NULL,
		[RecordId]                                       VARCHAR (100)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[ProgramParticipationBeginDate]                  DATE           NULL,
		[ProgramParticipationEndDate]                    DATE           NULL,
		[DiplomaCredentialType]                          VARCHAR (100)  NULL,
		[DiplomaCredentialType_2]                        VARCHAR (100)  NULL,
		[DiplomaCredentialAwardDate]                     DATE           NULL,
		[CteParticipant]                                 BIT            NULL,
		[CteConcentrator]                                BIT            NULL,
		[CteCompleter]                                   BIT            NULL,
		[SingleParentIndicator]                          BIT            NULL,
		[SingleParent_StatusStartDate]                   DATE           NULL,
		[SingleParent_StatusEndDate]                     DATE           NULL,
		[DisplacedHomeMakerIndicator]                    BIT            NULL,
		[DisplacedHomeMaker_StatusStartDate]             DATE           NULL,
		[DisplacedHomeMaker_StatusEndDate]               DATE           NULL,
		[AdvancedTrainingEnrollmentDate]                 DATE           NULL,
		[PlacementType]                                  VARCHAR (100)  NULL,
		[TechnicalSkillsAssessmentType]                  VARCHAR (100)  NULL,
		[NonTraditionalGenderStatus]                     BIT            NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonID]                                       INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationPersonRoleID_School]                INT            NULL,
		[OrganizationPersonRoleID_CTEProgram]            INT            NULL,
		[OrganizationID_CTEProgram]                      INT            NULL,
		[PersonProgramParticipationId]                   INT            NULL,
		[CteExitReason]                                  VARCHAR (100)  NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationCTE1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[ProgramParticipationCTE])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationCTE] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_ProgramParticipationCTE] ([ID], [ProgramParticipationBeginDate], [ProgramParticipationEndDate], [DiplomaCredentialAwardDate], [CteParticipant], [CteConcentrator], [CteCompleter], [CteExitReason], [SingleParentIndicator], [SingleParent_StatusStartDate], [SingleParent_StatusEndDate], [DisplacedHomeMakerIndicator], [DisplacedHomeMaker_StatusStartDate], [DisplacedHomeMaker_StatusEndDate], [AdvancedTrainingEnrollmentDate], [PlacementType], [TechnicalSkillsAssessmentType], [NonTraditionalGenderStatus], [DataCollectionName], [PersonID], [OrganizationID_School], [OrganizationPersonRoleID_School], [RunDateTime])
	--         SELECT   [ID],
	--                  [ProgramParticipationBeginDate],
	--                  [ProgramParticipationEndDate],
	--                  [DiplomaCredentialAwardDate],
	--                  [CteParticipant],
	--                  [CteConcentrator],
	--                  [CteCompleter],
	--                  [CteExitReason],
	--                  [SingleParentIndicator],
	--                  [SingleParent_StatusStartDate],
	--                  [SingleParent_StatusEndDate],
	--                  [DisplacedHomeMakerIndicator],
	--                  [DisplacedHomeMaker_StatusStartDate],
	--                  [DisplacedHomeMaker_StatusEndDate],
	--                  [AdvancedTrainingEnrollmentDate],
	--                  [PlacementType],
	--                  [TechnicalSkillsAssessmentType],
	--                  [NonTraditionalGenderStatus],
	--                  [DataCollectionName],
	--                  [PersonID],
	--                  [OrganizationID_School],
	--                  [OrganizationPersonRoleID_School],
	--                  [RunDateTime]
	--         FROM     [Staging].[ProgramParticipationCTE]
	--         ORDER BY [ID] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationCTE] OFF;
	--     END

	DROP TABLE [Staging].[ProgramParticipationCTE];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_ProgramParticipationCTE]', N'ProgramParticipationCTE';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_ProgramParticipationCTE1]', N'PK_ProgramParticipationCTE', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[ProgramParticipationCTE].[IX_Staging_ProgramParticipationCTE_RecordId]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationCTE_RecordId]
		ON [Staging].[ProgramParticipationCTE]([RecordId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[ProgramParticipationNorD].[DataCollectionId] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[DataCollectionName] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationID_Program_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationID_Program_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationID_Program_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationPersonRoleId_Program_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationPersonRoleId_Program_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[OrganizationPersonRoleId_Program_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[PersonProgramParticipationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[PersonProgramParticipationID_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[PersonProgramParticipationID_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationNorD].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[ProgramParticipationNorD]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_ProgramParticipationNorD] (
		[ID]                                             INT            IDENTITY (1, 1) NOT NULL,
		[RecordId]                                       VARCHAR (100)  NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[ProgramParticipationNorD]                       VARCHAR (100)  NULL,
		[ProgramParticipationBeginDate]                  DATE           NULL,
		[ProgramParticipationEndDate]                    DATE           NULL,
		[ProgressLevel_Reading]                          VARCHAR (100)  NULL,
		[ProgressLevel_Math]                             VARCHAR (100)  NULL,
		[Outcome]                                        VARCHAR (100)  NULL,
		[DiplomaCredentialAwardDate]                     DATE           NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonID]                                       INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[LEAOrganizationID_Program]                      INT            NULL,
		[SchoolOrganizationID_Program]                   INT            NULL,
		[LEAOrganizationPersonRoleId_Program]            INT            NULL,
		[SchoolOrganizationPersonRoleId_Program]         INT            NULL,
		[PersonProgramParticipationID]                   INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationNorD1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[ProgramParticipationNorD])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationNorD] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_ProgramParticipationNorD] ([ID], [ProgramParticipationBeginDate], [ProgramParticipationEndDate], [ProgramParticipationNorD], [ProgressLevel_Reading], [ProgressLevel_Math], [Outcome], [DiplomaCredentialAwardDate], [PersonID], [OrganizationID_LEA], [OrganizationID_School], [RunDateTime])
	--         SELECT   [ID],
	--                  [ProgramParticipationBeginDate],
	--                  [ProgramParticipationEndDate],
	--                  [ProgramParticipationNorD],
	--                  [ProgressLevel_Reading],
	--                  [ProgressLevel_Math],
	--                  [Outcome],
	--                  [DiplomaCredentialAwardDate],
	--                  [PersonID],
	--                  [OrganizationID_LEA],
	--                  [OrganizationID_School],
	--                  [RunDateTime]
	--         FROM     [Staging].[ProgramParticipationNorD]
	--         ORDER BY [ID] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationNorD] OFF;
	--     END

	DROP TABLE [Staging].[ProgramParticipationNorD];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_ProgramParticipationNorD]', N'ProgramParticipationNorD';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_ProgramParticipationNorD1]', N'PK_ProgramParticipationNorD', N'OBJECT';


	
	/*
	The column [Staging].[ProgramParticipationSpecialEducation].[DataCollectionId] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_Program_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_Program_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationID_Program_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationPersonRoleId_Program_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationPersonRoleId_Program_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[OrganizationPersonRoleId_Program_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[PersonProgramParticipationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationSpecialEducation].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[ProgramParticipationSpecialEducation]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_ProgramParticipationSpecialEducation] (
		[ID]                                             INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[ProgramParticipationBeginDate]                  DATE           NULL,
		[ProgramParticipationEndDate]                    DATE           NULL,
		[SpecialEducationExitReason]                     NVARCHAR (100) NULL,
		[IDEAEducationalEnvironmentForEarlyChildhood]    NVARCHAR (100) NULL,
		[IDEAEducationalEnvironmentForSchoolAge]         NVARCHAR (100) NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonID]                                       INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[LEAOrganizationID_Program]                      INT            NULL,
		[SchoolOrganizationID_Program]                   INT            NULL,
		[LEAOrganizationPersonRoleId_Program]            INT            NULL,
		[SchoolOrganizationPersonRoleId_Program]         INT            NULL,
		[PersonProgramParticipationID_LEA]               INT            NULL,
		[PersonProgramParticipationID_School]            INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationSpecialEducation1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[ProgramParticipationSpecialEducation])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationSpecialEducation] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_ProgramParticipationSpecialEducation] ([ID], [ProgramParticipationBeginDate], [ProgramParticipationEndDate], [SpecialEducationExitReason], [IDEAEducationalEnvironmentForEarlyChildhood], [IDEAEducationalEnvironmentForSchoolAge], [DataCollectionName], [PersonID], [OrganizationID_LEA], [OrganizationID_School], [PersonProgramParticipationID_LEA], [PersonProgramParticipationID_School], [RunDateTime])
	--         SELECT   [ID],
	--                  [ProgramParticipationBeginDate],
	--                  [ProgramParticipationEndDate],
	--                  [SpecialEducationExitReason],
	--                  [IDEAEducationalEnvironmentForEarlyChildhood],
	--                  [IDEAEducationalEnvironmentForSchoolAge],
	--                  [DataCollectionName],
	--                  [PersonID],
	--                  [OrganizationID_LEA],
	--                  [OrganizationID_School],
	--                  [PersonProgramParticipationID_LEA],
	--                  [PersonProgramParticipationID_School],
	--                  [RunDateTime]
	--         FROM     [Staging].[ProgramParticipationSpecialEducation]
	--         ORDER BY [ID] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationSpecialEducation] OFF;
	--     END

	DROP TABLE [Staging].[ProgramParticipationSpecialEducation];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_ProgramParticipationSpecialEducation]', N'ProgramParticipationSpecialEducation';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_ProgramParticipationSpecialEducation1]', N'PK_ProgramParticipationSpecialEducation', N'OBJECT';


	
	/*
	The column [Staging].[ProgramParticipationTitleI].[DataCollectionId] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationID_TitleIProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationID_TitleIProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationID_TitleIProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationPersonRoleID_TitleIProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationPersonRoleID_TitleIProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[OrganizationPersonRoleID_TitleIProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[PersonProgramParticipationId_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[PersonProgramParticipationId_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[PersonProgramParticipationId_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[ProgramParticipationBeginDate] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[ProgramParticipationEndDate] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleI].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[ProgramParticipationTitleI]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_ProgramParticipationTitleI] (
		[ID]                                             INT            IDENTITY (1, 1) NOT NULL,
		[RecordId]                                       VARCHAR (100)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[ProgramParticipationBeginDate]                  DATE           NULL,
		[ProgramParticipationEndDate]                    DATE           NULL,
		[TitleIIndicator]                                VARCHAR (100)  NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonID]                                       INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[LEAOrganizationPersonRoleID_TitleIProgram]      INT            NULL,
		[LEAOrganizationID_TitleIProgram]                INT            NULL,
		[LEAPersonProgramParticipationId]                INT            NULL,
		[SchoolOrganizationID_TitleIProgram]             INT            NULL,
		[SchoolOrganizationPersonRoleID_TitleIProgram]   INT            NULL,
		[SchoolPersonProgramParticipationId]             INT            NULL,
		[RefTitleIIndicatorId]                           INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationTitleI1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[ProgramParticipationTitleI])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationTitleI] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_ProgramParticipationTitleI] ([ID], [TitleIIndicator], [DataCollectionName], [PersonID], [RefTitleIIndicatorId], [OrganizationID_LEA], [OrganizationID_School], [RunDateTime])
	--         SELECT   [ID],
	--                  [TitleIIndicator],
	--                  [DataCollectionName],
	--                  [PersonID],
	--                  [RefTitleIIndicatorId],
	--                  [OrganizationID_LEA],
	--                  [OrganizationID_School],
	--                  [RunDateTime]
	--         FROM     [Staging].[ProgramParticipationTitleI]
	--         ORDER BY [ID] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationTitleI] OFF;
	--     END

	DROP TABLE [Staging].[ProgramParticipationTitleI];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_ProgramParticipationTitleI]', N'ProgramParticipationTitleI';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_ProgramParticipationTitleI1]', N'PK_ProgramParticipationTitleI', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleI].[IX_Staging_LEAProgramParticipationTitleI_PersonSchool]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_LEAProgramParticipationTitleI_PersonSchool]
		ON [Staging].[ProgramParticipationTitleI]([PersonID] ASC, [LEAOrganizationID_TitleIProgram] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleI].[IX_Staging_LEAProgramParticipationTitleI_PersonTitleI]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_LEAProgramParticipationTitleI_PersonTitleI]
		ON [Staging].[ProgramParticipationTitleI]([LEAOrganizationPersonRoleID_TitleIProgram] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleI].[IX_Staging_ProgramParticipationTitleI_RecordId]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationTitleI_RecordId]
		ON [Staging].[ProgramParticipationTitleI]([RecordId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleI].[IX_Staging_SchoolProgramParticipationTitleI_PersonSchool]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_SchoolProgramParticipationTitleI_PersonSchool]
		ON [Staging].[ProgramParticipationTitleI]([PersonID] ASC, [SchoolOrganizationID_TitleIProgram] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleI].[IX_Staging_SchoolProgramParticipationTitleI_PersonTitleI]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_SchoolProgramParticipationTitleI_PersonTitleI]
		ON [Staging].[ProgramParticipationTitleI]([SchoolOrganizationPersonRoleID_TitleIProgram] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[ProgramParticipationTitleIII].[DataCollectionId] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[LEA_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationID_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationID_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationID_TitleIIIProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationID_TitleIIIProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationID_TitleIIIProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationPersonRoleID_TitleIIIProgram_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationPersonRoleID_TitleIIIProgram_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[OrganizationPersonRoleID_TitleIIIProgram_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[PersonProgramParticipationId_IEU] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[PersonProgramParticipationId_LEA] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[PersonProgramParticipationId_School] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[PersonStatusId_Immigration] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[School_Identifier_State] is being dropped, data loss could occur.
	The column [Staging].[ProgramParticipationTitleIII].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[ProgramParticipationTitleIII]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_ProgramParticipationTitleIII] (
		[ID]                                             INT            IDENTITY (1, 1) NOT NULL,
		[RecordId]                                       VARCHAR (100)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[ProgramParticipationBeginDate]                  DATE           NULL,
		[ProgramParticipationEndDate]                    DATE           NULL,
		[Participation_TitleIII]                         VARCHAR (100)  NULL,
		[Proficiency_TitleIII]                           VARCHAR (100)  NULL,
		[Progress_TitleIII]                              VARCHAR (100)  NULL,
		[EnglishLearnerParticipation]                    BIT            NULL,
		[TitleIiiImmigrantStatus]                        BIT            NULL,
		[LanguageInstructionProgramServiceType]          VARCHAR (100)  NULL,
		[TitleIiiImmigrantStatus_StartDate]              DATE           NULL,
		[TitleIiiImmigrantStatus_EndDate]                DATE           NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonID]                                       INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[OrganizationPersonRoleID_TitleIIIProgram]       INT            NULL,
		[OrganizationID_TitleIIIProgram]                 INT            NULL,
		[PersonProgramParticipationId]                   INT            NULL,
		[ImmigrationPersonStatusId]                      INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationTitleIII1] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[ProgramParticipationTitleIII])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationTitleIII] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_ProgramParticipationTitleIII] ([ID], [ProgramParticipationBeginDate], [ProgramParticipationEndDate], [Participation_TitleIII], [Proficiency_TitleIII], [Progress_TitleIII], [EnglishLearnerParticipation], [TitleIiiImmigrantStatus], [LanguageInstructionProgramServiceType], [TitleIiiImmigrantStatus_StartDate], [TitleIiiImmigrantStatus_EndDate], [DataCollectionName], [PersonID], [OrganizationID_School], [RunDateTime])
	--         SELECT   [ID],
	--                  [ProgramParticipationBeginDate],
	--                  [ProgramParticipationEndDate],
	--                  [Participation_TitleIII],
	--                  [Proficiency_TitleIII],
	--                  [Progress_TitleIII],
	--                  [EnglishLearnerParticipation],
	--                  [TitleIiiImmigrantStatus],
	--                  [LanguageInstructionProgramServiceType],
	--                  [TitleIiiImmigrantStatus_StartDate],
	--                  [TitleIiiImmigrantStatus_EndDate],
	--                  [DataCollectionName],
	--                  [PersonID],
	--                  [OrganizationID_School],
	--                  [RunDateTime]
	--         FROM     [Staging].[ProgramParticipationTitleIII]
	--         ORDER BY [ID] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_ProgramParticipationTitleIII] OFF;
	--     END

	DROP TABLE [Staging].[ProgramParticipationTitleIII];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_ProgramParticipationTitleIII]', N'ProgramParticipationTitleIII';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_ProgramParticipationTitleIII1]', N'PK_ProgramParticipationTitleIII', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[ProgramParticipationTitleIII].[IX_Staging_ProgramParticipationTitleIII_RecordId]...';


	
	CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationTitleIII_RecordId]
		ON [Staging].[ProgramParticipationTitleIII]([RecordId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	/*
	The column [Staging].[PsInstitution].[RunDateTime] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[PsInstitution]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_PsInstitution] (
		[Id]                                  INT            IDENTITY (1, 1) NOT NULL,
		[OrganizationName]                    VARCHAR (200)  NULL,
		[InstitutionIpedsUnitId]              NVARCHAR (50)  NULL,
		[Website]                             VARCHAR (300)  NULL,
		[OrganizationOperationalStatus]       VARCHAR (100)  NULL,
		[OperationalStatusEffectiveDate]      DATETIME       NULL,
		[MostPrevalentLevelOfInstitutionCode] NVARCHAR (50)  NULL,
		[PredominantCalendarSystem]           VARCHAR (100)  NULL,
		[SchoolYear]                          SMALLINT 		 NULL,
		[DataCollectionName]                  NVARCHAR (100) NULL,
		[RecordStartDateTime]                 DATETIME       NULL,
		[RecordEndDateTime]                   DATETIME       NULL,
		[OrganizationId]                      INT            NULL,
		[OrganizationOperationalStatusId]     INT            NULL,
		[OperationalStatusId]                 INT            NULL,
		[MostPrevalentLevelOfInstitutionId]   INT            NULL,
		[PredominantCalendarSystemId]         INT            NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_PsInstitution1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[PsInstitution])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsInstitution] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_PsInstitution] ([Id], [OrganizationName], [InstitutionIpedsUnitId], [Website], [OrganizationOperationalStatus], [OperationalStatusEffectiveDate], [MostPrevalentLevelOfInstitutionCode], [PredominantCalendarSystem], [RecordStartDateTime], [RecordEndDateTime], [SchoolYear], [DataCollectionName], [OrganizationId], [OrganizationOperationalStatusId], [OperationalStatusId], [MostPrevalentLevelOfInstitutionId], [PredominantCalendarSystemId])
	--         SELECT   [Id],
	--                  [OrganizationName],
	--                  [InstitutionIpedsUnitId],
	--                  [Website],
	--                  [OrganizationOperationalStatus],
	--                  [OperationalStatusEffectiveDate],
	--                  [MostPrevalentLevelOfInstitutionCode],
	--                  [PredominantCalendarSystem],
	--                  [SchoolYear],
	--                  [RecordStartDateTime],
	--                  [RecordEndDateTime],
	--                  [DataCollectionName],
	--                  [OrganizationId],
	--                  [OrganizationOperationalStatusId],
	--                  [OperationalStatusId],
	--                  [MostPrevalentLevelOfInstitutionId],
	--                  [PredominantCalendarSystemId]
	--         FROM     [Staging].[PsInstitution]
	--         ORDER BY [Id] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsInstitution] OFF;
	--     END

	DROP TABLE [Staging].[PsInstitution];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_PsInstitution]', N'PsInstitution';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_PsInstitution1]', N'PK_PsInstitution', N'OBJECT';


	
	/*
	The column [Staging].[PsStudentAcademicAward].[RunDateTime] is being dropped, data loss could occur.
	The column [Staging].[PsStudentAcademicAward].[Student_Identifier_State] is being dropped, data loss could occur.
	The type for column DataCollectionName in table [Staging].[PsStudentAcademicAward] is currently  NVARCHAR (100) NULL but is being changed to  NVARCHAR (50) NULL. Data loss could occur and deployment may fail if the column contains data that is incompatible with type  NVARCHAR (50) NULL.
	The type for column SchoolYear in table [Staging].[PsStudentAcademicAward] is currently  VARCHAR (100) NULL but is being changed to  NVARCHAR (50) NULL. Data loss could occur and deployment may fail if the column contains data that is incompatible with type  NVARCHAR (50) NULL.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[PsStudentAcademicAward]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_PsStudentAcademicAward] (
		[Id]                                         INT            IDENTITY (1, 1) NOT NULL,
		[InstitutionIpedsUnitId]                     VARCHAR (50)   NULL,
		[StudentIdentifierState]                     NVARCHAR (40)  NULL,
		[ProfessionalOrTechnicalCredentialConferred] NVARCHAR (50)  NULL,
		[AcademicAwardDate]                          DATETIME       NULL,
		[PescAwardLevelType]                         NVARCHAR (200) NULL,
		[AcademicAwardTitle]                         NVARCHAR (200) NULL,
		[EntryDate]                                  DATETIME       NULL,
		[ExitDate]                                   DATETIME       NULL,
		[SchoolYear]                                 SMALLINT 		NULL,
		[DataCollectionName]                         NVARCHAR (50)  NULL,
		[OrganizationId]                             INT            NULL,
		[PersonId]                                   INT            NULL,
		[OrganizationPersonRoleId]                   INT            NULL,
		[PsStudentAcademicAwardId]                   INT            NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_PsStudentAcademicAward1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[PsStudentAcademicAward])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentAcademicAward] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_PsStudentAcademicAward] ([Id], [InstitutionIpedsUnitId], [ProfessionalOrTechnicalCredentialConferred], [AcademicAwardDate], [PescAwardLevelType], [AcademicAwardTitle], [EntryDate], [ExitDate], [SchoolYear], [DataCollectionName], [OrganizationId], [PersonId], [OrganizationPersonRoleId], [PsStudentAcademicAwardId])
	--         SELECT   [Id],
	--                  [InstitutionIpedsUnitId],
	--                  [ProfessionalOrTechnicalCredentialConferred],
	--                  [AcademicAwardDate],
	--                  [PescAwardLevelType],
	--                  [AcademicAwardTitle],
	--                  [EntryDate],
	--                  [ExitDate],
	--                  [SchoolYear],
	--                  [DataCollectionName],
	--                  [OrganizationId],
	--                  [PersonId],
	--                  [OrganizationPersonRoleId],
	--                  [PsStudentAcademicAwardId]
	--         FROM     [Staging].[PsStudentAcademicAward]
	--         ORDER BY [Id] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentAcademicAward] OFF;
	--     END

	DROP TABLE [Staging].[PsStudentAcademicAward];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_PsStudentAcademicAward]', N'PsStudentAcademicAward';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_PsStudentAcademicAward1]', N'PK_PsStudentAcademicAward', N'OBJECT';


	
	/*
	The column [Staging].[PsStudentAcademicRecord].[RunDateTime] is being dropped, data loss could occur.
	The column [Staging].[PsStudentAcademicRecord].[Student_Identifier_State] is being dropped, data loss could occur.
	The type for column DataCollectionName in table [Staging].[PsStudentAcademicRecord] is currently  NVARCHAR (100) NULL but is being changed to  NVARCHAR (50) NULL. Data loss could occur and deployment may fail if the column contains data that is incompatible with type  NVARCHAR (50) NULL.
	The type for column SchoolYear in table [Staging].[PsStudentAcademicRecord] is currently  VARCHAR (100) NULL but is being changed to  NVARCHAR (50) NULL. Data loss could occur and deployment may fail if the column contains data that is incompatible with type  NVARCHAR (50) NULL.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[PsStudentAcademicRecord]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_PsStudentAcademicRecord] (
		[Id]                                         INT           IDENTITY (1, 1) NOT NULL,
		[InstitutionIpedsUnitId]                     VARCHAR (50)  NULL,
		[StudentIdentifierState]                     VARCHAR (50)  NULL,
		[DiplomaOrCredentialAwardDate]               DATETIME      NULL,
		[AcademicTermDesignator]                     NVARCHAR (50) NULL,
		[ProfessionalOrTechnicalCredentialConferred] VARCHAR (50)  NULL,
		[EntryDate]                                  DATETIME      NULL,
		[ExitDate]                                   DATETIME      NULL,
		[SchoolYear]                                 SMALLINT 	   NULL,
		[DataCollectionName]                         NVARCHAR (50) NULL,
		[OrganizationId]                             INT           NULL,
		[PersonId]                                   INT           NULL,
		[OrganizationPersonRoleId]                   INT           NULL,
		[PsStudentAcademicRecordId]                  INT           NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_PsStudentAcademicRecord1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[PsStudentAcademicRecord])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentAcademicRecord] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_PsStudentAcademicRecord] ([Id], [InstitutionIpedsUnitId], [DiplomaOrCredentialAwardDate], [AcademicTermDesignator], [ProfessionalOrTechnicalCredentialConferred], [EntryDate], [ExitDate], [SchoolYear], [DataCollectionName], [OrganizationId], [PersonId], [OrganizationPersonRoleId], [PsStudentAcademicRecordId])
	--         SELECT   [Id],
	--                  [InstitutionIpedsUnitId],
	--                  [DiplomaOrCredentialAwardDate],
	--                  [AcademicTermDesignator],
	--                  [ProfessionalOrTechnicalCredentialConferred],
	--                  [EntryDate],
	--                  [ExitDate],
	--                  [SchoolYear],
	--                  [DataCollectionName],
	--                  [OrganizationId],
	--                  [PersonId],
	--                  [OrganizationPersonRoleId],
	--                  [PsStudentAcademicRecordId]
	--         FROM     [Staging].[PsStudentAcademicRecord]
	--         ORDER BY [Id] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentAcademicRecord] OFF;
	--     END
	
	DROP TABLE [Staging].[PsStudentAcademicRecord];

	

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_PsStudentAcademicRecord]', N'PsStudentAcademicRecord';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_PsStudentAcademicRecord1]', N'PK_PsStudentAcademicRecord', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[PsStudentAcademicRecord].[IX_PsStudentAcademicRecord_AcademicTermDesignator]...';


	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_PsStudentAcademicRecord_AcademicTermDesignator') BEGIN
		CREATE NONCLUSTERED INDEX [IX_PsStudentAcademicRecord_AcademicTermDesignator]
			ON [Staging].[PsStudentAcademicRecord]([AcademicTermDesignator] ASC)
			INCLUDE([StudentIdentifierState], [SchoolYear], [EntryDate], [OrganizationId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
	END


	
	PRINT N'Creating Index [Staging].[PsStudentAcademicRecord].[IX_Staging_PsStudentAcademicRecord_SchoolYear_DC_StudentId]...';


	
	IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Staging_PsStudentAcademicRecord_SchoolYear_DC_StudentId') BEGIN
		CREATE NONCLUSTERED INDEX [IX_Staging_PsStudentAcademicRecord_SchoolYear_DC_StudentId]
			ON [Staging].[PsStudentAcademicRecord]([SchoolYear] ASC, [DataCollectionName] ASC, [StudentIdentifierState] ASC)
			INCLUDE([InstitutionIpedsUnitId], [AcademicTermDesignator], [EntryDate], [ExitDate]);
	END

	
	/*
	The column [Staging].[PsStudentEnrollment].[LastName] is being dropped, data loss could occur.
	The column [Staging].[PsStudentEnrollment].[RunDateTime] is being dropped, data loss could occur.
	The column [Staging].[PsStudentEnrollment].[Student_Identifier_State] is being dropped, data loss could occur.
	*/
	
	PRINT N'Starting rebuilding table [Staging].[PsStudentEnrollment]...';


	
	SET XACT_ABORT ON;

	CREATE TABLE [Staging].[tmp_ms_xx_PsStudentEnrollment] (
		[Id]                                INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]            NVARCHAR (100) NULL,
		[InstitutionIpedsUnitId]            NVARCHAR (100) NULL,
		[FirstName]                         VARCHAR (100)  NULL,
		[LastOrSurname]                     VARCHAR (100)  NULL,
		[MiddleName]                        VARCHAR (100)  NULL,
		[Birthdate]                         DATE           NULL,
		[Sex]                               VARCHAR (30)   NULL,
		[HispanicLatinoEthnicity]           BIT            NULL,
		[PostsecondaryExitOrWithdrawalType] NVARCHAR (100) NULL,
		[EntryDateIntoPostsecondary]        DATETIME       NULL,
		[EntryDate]                         DATETIME       NULL,
		[ExitDate]                          DATETIME       NULL,
		[AcademicTermDesignator]            VARCHAR (100)  NULL,
		[RecordStartDateTime]               DATETIME       NULL,
		[RecordEndDateTime]                 DATETIME       NULL,
		[DataCollectionName]                NVARCHAR (100) NULL,
		[OrganizationId_PsInstitution]      INT            NULL,
		[SchoolYear]                        SMALLINT 	   NULL,
		[PersonId]                          INT            NULL,
		[OrganizationPersonRoleId]          INT            NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_PsTermEnrollment1] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	-- IF EXISTS (SELECT TOP 1 1 
	--            FROM   [Staging].[PsStudentEnrollment])
	--     BEGIN
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentEnrollment] ON;
	--         INSERT INTO [Staging].[tmp_ms_xx_PsStudentEnrollment] ([Id], [InstitutionIpedsUnitId], [FirstName], [MiddleName], [Birthdate], [Sex], [HispanicLatinoEthnicity], [PostsecondaryExitOrWithdrawalType], [EntryDateIntoPostsecondary], [EntryDate], [ExitDate], [AcademicTermDesignator], [SchoolYear], [DataCollectionName], [OrganizationId_PsInstitution], [PersonId], [OrganizationPersonRoleId])
	--         SELECT   [Id],
	--                  [InstitutionIpedsUnitId],
	--                  [FirstName],
	--                  [MiddleName],
	--                  [Birthdate],
	--                  [Sex],
	--                  [HispanicLatinoEthnicity],
	--                  [PostsecondaryExitOrWithdrawalType],
	--                  [EntryDateIntoPostsecondary],
	--                  [EntryDate],
	--                  [ExitDate],
	--                  [AcademicTermDesignator],
	--                  [SchoolYear],
	--                  [DataCollectionName],
	--                  [OrganizationId_PsInstitution],
	--                  [PersonId],
	--                  [OrganizationPersonRoleId]
	--         FROM     [Staging].[PsStudentEnrollment]
	--         ORDER BY [Id] ASC;
	--         SET IDENTITY_INSERT [Staging].[tmp_ms_xx_PsStudentEnrollment] OFF;
	--     END

	DROP TABLE [Staging].[PsStudentEnrollment];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_PsStudentEnrollment]', N'PsStudentEnrollment';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_PsTermEnrollment1]', N'PK_PsTermEnrollment', N'OBJECT';


	
	PRINT N'Creating Index [Staging].[PsStudentEnrollment].[IX_PsStudentEnrollment_StudentId_InstitutionIpedsId_HispanicLatino_EntryDate_DataCollectionName]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsStudentEnrollment_StudentId_InstitutionIpedsId_HispanicLatino_EntryDate_DataCollectionName]
		ON [Staging].[PsStudentEnrollment]([DataCollectionName] ASC, [EntryDate] ASC, [StudentIdentifierState] ASC, [InstitutionIpedsUnitId] ASC, [HispanicLatinoEthnicity] ASC, [AcademicTermDesignator] ASC, [ExitDate] ASC);


	
	PRINT N'Creating Index [Staging].[PsStudentEnrollment].[IX_PsStudentEnrollment_StudentIdentifierState_EntryDate_DataCollectionName]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsStudentEnrollment_StudentIdentifierState_EntryDate_DataCollectionName]
		ON [Staging].[PsStudentEnrollment]([StudentIdentifierState] ASC, [EntryDate] ASC, [DataCollectionName] ASC)
		INCLUDE([InstitutionIpedsUnitId], [HispanicLatinoEthnicity], [ExitDate], [AcademicTermDesignator], [SchoolYear]);


	
	PRINT N'Creating Table [RDS].[BridgeAeStudentEnrollmentRaces]...';


	
	CREATE TABLE [RDS].[BridgeAeStudentEnrollmentRaces] (
		[BridgeAeStudentEnrollmentRaceId] INT IDENTITY (1, 1) NOT NULL,
		[FactAeStudentEnrollmentId]       INT NOT NULL,
		[RaceId]                          INT NOT NULL,
		CONSTRAINT [PK_BridgeAeStudentEnrollmentRaces] PRIMARY KEY CLUSTERED ([BridgeAeStudentEnrollmentRaceId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeAeStudentEnrollmentRaces].[IXFK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId]
		ON [RDS].[BridgeAeStudentEnrollmentRaces]([FactAeStudentEnrollmentId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeAeStudentEnrollmentRaces].[IXFK_BridgeAeStudentEnrollmentRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeAeStudentEnrollmentRaces_RaceId]
		ON [RDS].[BridgeAeStudentEnrollmentRaces]([RaceId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes] (
		[BridgeK12EnrollmentsIdeaDisabilityTypeId] INT    IDENTITY (1, 1) NOT NULL,
		[FactK12StudentEnrollmentId]               BIGINT NOT NULL,
		[IdeaDisabilityTypeId]                     INT    NOT NULL,
		CONSTRAINT [PK_BridgeK12EnrollmentsIdeaDisabilityTypeId] PRIMARY KEY CLUSTERED ([BridgeK12EnrollmentsIdeaDisabilityTypeId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes].[IXFK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollments]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollments]
		ON [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes]([FactK12StudentEnrollmentId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes].[IXFK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId]
		ON [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes]([IdeaDisabilityTypeId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentAssessmentAccommodations]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] (
		[FactK12StudentAssessmentAccommodationId] INT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentAssessmentId]              INT NOT NULL,
		[AssessmentAccommodationId]               INT NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentAssessmentAccommodations] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentAccommodationId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentAssessmentAccommodations].[IXFK_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId]
		ON [RDS].[BridgeK12StudentAssessmentAccommodations]([AssessmentAccommodationId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentAssessmentAccommodations].[IXFK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]
		ON [RDS].[BridgeK12StudentAssessmentAccommodations]([FactK12StudentAssessmentId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentAssessmentRaces]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentAssessmentRaces] (
		[BridgeK12StudentAssessmentRaceId] INT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentAssessmentId]       INT NOT NULL,
		[RaceId]                           INT NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentAssessmentRaces] PRIMARY KEY CLUSTERED ([BridgeK12StudentAssessmentRaceId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentAssessmentRaces].[IXFK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments]
		ON [RDS].[BridgeK12StudentAssessmentRaces]([FactK12StudentAssessmentId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentAssessmentRaces].[IXFK_BridgeK12StudentAssessmentRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentAssessmentRaces_RaceId]
		ON [RDS].[BridgeK12StudentAssessmentRaces]([RaceId] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentCourseSectionRaces]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentCourseSectionRaces] (
		[BridgeK12StudentCourseSectionRaceId] BIGINT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentCourseSectionId]       BIGINT NOT NULL,
		[RaceId]                              INT    NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentCourseSectionRace] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionRaceId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionRaces].[IXFK_BridgeK12StudentCourseSectionRaces_FactK12StudentCourseSectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionRaces_FactK12StudentCourseSectionId]
		ON [RDS].[BridgeK12StudentCourseSectionRaces]([FactK12StudentCourseSectionId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionRaces].[IXFK_BridgeK12StudentCourseSectionRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionRaces_RaceId]
		ON [RDS].[BridgeK12StudentCourseSectionRaces]([RaceId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentCourseSectionsCipCodes]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] (
		[BridgeK12StudentCourseSectionsCipCodeId] BIGINT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentCourseSectionId]           BIGINT NOT NULL,
		[CipCodeId]                               INT    NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentCourseSectionsCipCodes] PRIMARY KEY CLUSTERED ([BridgeK12StudentCourseSectionsCipCodeId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionsCipCodes].[IXFK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId]
		ON [RDS].[BridgeK12StudentCourseSectionsCipCodes]([CipCodeId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentCourseSectionsCipCodes].[IXFK_BridgeK12StudentCourseSectionsCipCodes_FactK12CourseSection]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentCourseSectionsCipCodes_FactK12CourseSection]
		ON [RDS].[BridgeK12StudentCourseSectionsCipCodes]([FactK12StudentCourseSectionId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentDisciplineRaces]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentDisciplineRaces] (
		[BridgeK12StudentDisciplineRaceId] INT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentDisciplineId]       INT NOT NULL,
		[RaceId]                           INT NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentDisciplineRaces] PRIMARY KEY CLUSTERED ([BridgeK12StudentDisciplineRaceId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentDisciplineRaces].[IXFK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines]
		ON [RDS].[BridgeK12StudentDisciplineRaces]([FactK12StudentDisciplineId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentDisciplineRaces].[IXFK_BridgeK12StudentDisciplineRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentDisciplineRaces_RaceId]
		ON [RDS].[BridgeK12StudentDisciplineRaces]([RaceId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentEconomicDisadvantageRaces]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces] (
		[BridgeK12StudentEconomicDisadvantageRaceId] INT IDENTITY (1, 1) NOT NULL,
		[FactK12StudentEconomicDisadvantageId]       INT NOT NULL,
		[RaceId]                                     INT NOT NULL,
		CONSTRAINT [PK_BridgeK12StudentEconomicDisadvantageRaces] PRIMARY KEY CLUSTERED ([BridgeK12StudentEconomicDisadvantageRaceId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEconomicDisadvantageRaces].[IXFK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId]
		ON [RDS].[BridgeK12StudentEconomicDisadvantageRaces]([FactK12StudentEconomicDisadvantageId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEconomicDisadvantageRaces].[IXFK_BridgeK12StudentEconomicDisadvantageRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEconomicDisadvantageRaces_RaceId]
		ON [RDS].[BridgeK12StudentEconomicDisadvantageRaces]([RaceId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeK12StudentEnrollmentPersonAddresses]...';


	
	CREATE TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses] (
		[BridgeK12StudentEnrollmentPersonAddressId] BIGINT         IDENTITY (1, 1) NOT NULL,
		[FactK12StudentEnrollmentId]                BIGINT         NOT NULL,
		[PersonAddressId]                           INT            NOT NULL,
		[AddressTypeForLearnerOrFamilyCode]         NVARCHAR (50)  NULL,
		[AddressTypeForLearnerOrFamilyDescription]  NVARCHAR (150) NULL,
		CONSTRAINT [PK_BridgeK12StudentEnrollmentPersonAddresses] PRIMARY KEY CLUSTERED ([BridgeK12StudentEnrollmentPersonAddressId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentPersonAddresses].[IXFK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments]
		ON [RDS].[BridgeK12StudentEnrollmentPersonAddresses]([FactK12StudentEnrollmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeK12StudentEnrollmentPersonAddresses].[IXFK_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId]
		ON [RDS].[BridgeK12StudentEnrollmentPersonAddresses]([PersonAddressId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[BridgeSpecialEducationIdeaDisabilityTypes]...';


	
	CREATE TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes] (
		[BridgeSpecialEducationIdeaDisabilityTypeId] INT IDENTITY (1, 1) NOT NULL,
		[FactSpecialEducationId]                     INT NOT NULL,
		[IdeaDisabilityTypeId]                       INT NOT NULL,
		CONSTRAINT [PK_BridgeSpecialEducationIdeaDisabilityTypes] PRIMARY KEY CLUSTERED ([BridgeSpecialEducationIdeaDisabilityTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[BridgeSpecialEducationIdeaDisabilityTypes].[IXFK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducation]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducation]
		ON [RDS].[BridgeSpecialEducationIdeaDisabilityTypes]([FactSpecialEducationId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeSpecialEducationIdeaDisabilityTypes].[IXFK_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId]
		ON [RDS].[BridgeSpecialEducationIdeaDisabilityTypes]([IdeaDisabilityTypeId] ASC);


	
	PRINT N'Creating Table [RDS].[BridgeSpecialEducationRaces]...';


	
	CREATE TABLE [RDS].[BridgeSpecialEducationRaces] (
		[BridgeSpecialEducationRaceId] INT IDENTITY (1, 1) NOT NULL,
		[FactSpecialEducationId]       INT NOT NULL,
		[RaceId]                       INT NOT NULL,
		CONSTRAINT [PK_BridgeSpecialEducationRaces] PRIMARY KEY CLUSTERED ([BridgeSpecialEducationRaceId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[BridgeSpecialEducationRaces].[IXFK_BridgeSpecialEducationRaces_FactSpecialEducation]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeSpecialEducationRaces_FactSpecialEducation]
		ON [RDS].[BridgeSpecialEducationRaces]([FactSpecialEducationId] ASC);


	
	PRINT N'Creating Index [RDS].[BridgeSpecialEducationRaces].[IXFK_BridgeSpecialEducationRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeSpecialEducationRaces_RaceId]
		ON [RDS].[BridgeSpecialEducationRaces]([RaceId] ASC);


	
	PRINT N'Creating Table [RDS].[DimAeDemographics]...';


	
	CREATE TABLE [RDS].[DimAeDemographics] (
		[DimAeDemographicId]                           INT            IDENTITY (1, 1) NOT NULL,
		[EconomicDisadvantageStatusCode]               NVARCHAR (50)  NULL,
		[EconomicDisadvantageStatusDescription]        NVARCHAR (200) NULL,
		[HomelessnessStatusCode]                       NVARCHAR (50)  NULL,
		[HomelessnessStatusDescription]                NVARCHAR (200) NULL,
		[EnglishLearnerStatusCode]                     NVARCHAR (50)  NULL,
		[EnglishLearnerStatusDescription]              NVARCHAR (200) NULL,
		[MigrantStatusCode]                            NVARCHAR (50)  NULL,
		[MigrantStatusDescription]                     NVARCHAR (200) NULL,
		[MilitaryConnectedStudentIndicatorCode]        NVARCHAR (50)  NULL,
		[MilitaryConnectedStudentIndicatorDescription] NVARCHAR (200) NULL,
		[HomelessPrimaryNighttimeResidenceCode]        NVARCHAR (50)  NULL,
		[HomelessPrimaryNighttimeResidenceDescription] NVARCHAR (MAX) NULL,
		[HomelessUnaccompaniedYouthStatusCode]         NVARCHAR (50)  NULL,
		[HomelessUnaccompaniedYouthStatusDescription]  NVARCHAR (MAX) NULL,
		[SexCode]                                      NVARCHAR (50)  NULL,
		[SexDescription]                               NVARCHAR (200) NULL,
		CONSTRAINT [PK_DimAeDemographics] PRIMARY KEY CLUSTERED ([DimAeDemographicId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAeProgramTypes]...';


	
	CREATE TABLE [RDS].[DimAeProgramTypes] (
		[DimAeProgramTypeId]                    INT            IDENTITY (1, 1) NOT NULL,
		[AeInstructionalProgramTypeCode]        NVARCHAR (50)  NULL,
		[AeInstructionalProgramTypeDescription] NVARCHAR (150) NULL,
		[AeSpecialProgramTypeCode]              NVARCHAR (50)  NULL,
		[AeSpecialProgramTypeDescription]       NVARCHAR (150) NULL,
		[WioaCareerServicesCode]                NVARCHAR (50)  NULL,
		[WioaCareerServicesDescription]         NVARCHAR (150) NULL,
		[WioaTrainingServicesCode]              NVARCHAR (50)  NULL,
		[WioaTrainingServicesDescription]       NVARCHAR (150) NULL,
		CONSTRAINT [PK_DimAeProgramTypes] PRIMARY KEY CLUSTERED ([DimAeProgramTypeId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAeProgramYears]...';


	
	CREATE TABLE [RDS].[DimAeProgramYears] (
		[DimAeProgramYearId] INT      IDENTITY (1, 1) NOT NULL,
		[AeProgramYear]      SMALLINT NOT NULL,
		[SessionBeginDate]   DATETIME NOT NULL,
		[SessionEndDate]     DATETIME NOT NULL,
		CONSTRAINT [PK_DimAeProgramYears] PRIMARY KEY CLUSTERED ([DimAeProgramYearId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAeProviders]...';


	
	CREATE TABLE [RDS].[DimAeProviders] (
		[DimAeProviderId]                           INT             IDENTITY (1, 1) NOT NULL,
		[AeServiceProviderIdentifierSea]            NVARCHAR (50)   NULL,
		[NameOfInstitution]                         NVARCHAR (1000) NULL,
		[ShortNameOfInstitution]                    NVARCHAR (30)   NULL,
		[AdultEducationProviderTypeCode]            NVARCHAR (50)   NULL,
		[AdultEducationProviderTypeDescription]     NVARCHAR (150)  NULL,
		[LevelOfInstitutionCode]                    NVARCHAR (50)   NULL,
		[LevelOfInstitutionDescription]             NVARCHAR (150)  NULL,
		[TelephoneNumber]                           NVARCHAR (24)   NULL,
		[WebSiteAddress]                            NVARCHAR (300)  NULL,
		[MailingAddressStreetNumberAndName]         NVARCHAR (150)  NULL,
		[MailingAddressApartmentRoomOrSuiteNumber]  NVARCHAR (60)   NULL,
		[MailingAddressCity]                        NVARCHAR (30)   NULL,
		[MailingAddressStateAbbreviation]           NVARCHAR (50)   NULL,
		[MailingAddressPostalCode]                  NVARCHAR (17)   NULL,
		[MailingAddressCountyAnsiCodeCode]          NVARCHAR (50)   NULL,
		[PhysicalAddressStreetNumberAndName]        NVARCHAR (150)  NULL,
		[PhysicalAddressApartmentRoomOrSuiteNumber] NVARCHAR (60)   NULL,
		[PhysicalAddressCity]                       NVARCHAR (30)   NULL,
		[PhysicalAddressStateAbbreviation]          NVARCHAR (50)   NULL,
		[PhysicalAddressPostalCode]                 NVARCHAR (17)   NULL,
		[PhysicalAddressCountyAnsiCodeCode]         NVARCHAR (50)   NULL,
		[Latitude]                                  NVARCHAR (20)   NULL,
		[Longitude]                                 NVARCHAR (20)   NULL,
		[RecordStartDateTime]                       DATETIME        NULL,
		[RecordEndDateTime]                         DATETIME        NULL,
		CONSTRAINT [PK_DimAeProviders] PRIMARY KEY CLUSTERED ([DimAeProviderId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAeStudentStatuses]...';


	
	CREATE TABLE [RDS].[DimAeStudentStatuses] (
		[DimAeStudentStatusId]                                                          INT            IDENTITY (1, 1) NOT NULL,
		[AeFunctioningLevelAtIntakeCode]                                                NVARCHAR (50)  NULL,
		[AeFunctioningLevelAtIntakeDescription]                                         NVARCHAR (150) NULL,
		[AeFunctioningLevelAtPosttestCode]                                              NVARCHAR (50)  NULL,
		[AeFunctioningLevelAtPosttestDescription]                                       NVARCHAR (150) NULL,
		[AePostsecondaryTransitionActionCode]                                           NVARCHAR (50)  NULL,
		[AePostsecondaryTransitionActionDescription]                                    NVARCHAR (150) NULL,
		[EmployedWhileEnrolledCode]                                                     NVARCHAR (50)  NULL,
		[EmployedWhileEnrolledDescription]                                              NVARCHAR (150) NULL,
		[EmployedAfterExitCode]                                                         NVARCHAR (50)  NULL,
		[EmployedAfterExitDescription]                                                  NVARCHAR (150) NULL,
		[AdultEducationCredentialAttainmentPostsecondaryEnrollmentIndicatorCode]        NVARCHAR (50)  NULL,
		[AdultEducationCredentialAttainmentPostsecondaryEnrollmentIndicatorDescription] NVARCHAR (150) NULL,
		[AdultEducationCredentialAttainmentEmployedIndicatorCode]                       NVARCHAR (50)  NULL,
		[AdultEducationCredentialAttainmentEmployedIndicatorDescription]                NVARCHAR (150) NULL,
		[AdultEducationCredentialAttainmentPostsecondaryCredentialIndicatorCode]        NVARCHAR (50)  NULL,
		[AdultEducationCredentialAttainmentPostsecondaryCredentialIndicatorDescription] NVARCHAR (150) NULL,
		CONSTRAINT [PK_DimAeStudentStatuses] PRIMARY KEY CLUSTERED ([DimAeStudentStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentAccommodations]...';


	
	CREATE TABLE [RDS].[DimAssessmentAccommodations] (
		[DimAssessmentAccommodationId]               INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentAccommodationCategoryCode]        NVARCHAR (100) NOT NULL,
		[AssessmentAccommodationCategoryDescription] NVARCHAR (300) NOT NULL,
		[AccommodationTypeCode]                      NVARCHAR (100) NOT NULL,
		[AccommodationTypeDescription]               NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimAssessmentAccommodationId] PRIMARY KEY CLUSTERED ([DimAssessmentAccommodationId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentAdministrations]...';


	
	CREATE TABLE [RDS].[DimAssessmentAdministrations] (
		[DimAssessmentAdministrationId]             INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentIdentifier]                      NVARCHAR (40)  NULL,
		[AssessmentIdentificationSystem]            NVARCHAR (40)  NULL,
		[AssessmentAdministrationCode]              NVARCHAR (400) NULL,
		[AssessmentAdministrationName]              NVARCHAR (400) NULL,
		[AssessmentAdministrationStartDate]         DATETIME       NULL,
		[AssessmentAdministrationFinishDate]        DATETIME       NULL,
		[AssessmentAdministrationAssessmentFamily]  NVARCHAR (40)  NULL,
		[SchoolIdentifier]                          NVARCHAR (40)  NULL,
		[SchoolIdentificationSystem]                NVARCHAR (40)  NULL,
		[LocalEducationAgencyIdentifier]            NVARCHAR (40)  NULL,
		[LEAIdentificationSystem]                   NVARCHAR (40)  NULL,
		[AssessmentAdministrationOrganizationName]  NVARCHAR (40)  NULL,
		[AssessmentAdministrationPeriodDescription] NVARCHAR (40)  NULL,
		[AssessmentSecureIndicator]                 NVARCHAR (40)  NULL,
		CONSTRAINT [PK_DimAssessmentAdministrations] PRIMARY KEY CLUSTERED ([DimAssessmentAdministrationId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[DimAssessmentAdministrations].[IX_DimAssessmentAdministrations_AssessmentAdministrationIdentifier]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessmentAdministrations_AssessmentAdministrationIdentifier]
		ON [RDS].[DimAssessmentAdministrations]([AssessmentAdministrationCode] ASC);


	
	PRINT N'Creating Index [RDS].[DimAssessmentAdministrations].[IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode]
		ON [RDS].[DimAssessmentAdministrations]([AssessmentIdentifier] ASC);


	
	PRINT N'Creating Table [RDS].[DimAssessmentForms]...';


	
	CREATE TABLE [RDS].[DimAssessmentForms] (
		[DimAssessmentFormId]  INT           IDENTITY (1, 1) NOT NULL,
		[AssessmentFormNumber] NVARCHAR (30) NOT NULL,
		CONSTRAINT [PK_DimAssessmentFormId] PRIMARY KEY CLUSTERED ([DimAssessmentFormId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentParticipationSessions]...';


	
	CREATE TABLE [RDS].[DimAssessmentParticipationSessions] (
		[DimAssessmentParticipationSessionId]                 INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentSessionSpecialCircumstanceTypeCode]        NVARCHAR (100) NOT NULL,
		[AssessmentSessionSpecialCircumstanceTypeDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimAssessmentParticipationSessions] PRIMARY KEY CLUSTERED ([DimAssessmentParticipationSessionId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentPerformanceLevels]...';


	
	CREATE TABLE [RDS].[DimAssessmentPerformanceLevels] (
		[DimAssessmentPerformanceLevelId]         INT           IDENTITY (1, 1) NOT NULL,
		[AssessmentPerformanceLevelIdentifier]    NVARCHAR (40) NOT NULL,
		[AssessmentPerformanceLevelLabel]         NVARCHAR (20) NOT NULL,
		[AssessmentPerformanceLevelScoreMetric]   NVARCHAR (30) NOT NULL,
		[AssessmentPerformanceLevelLowerCutScore] NVARCHAR (30) NOT NULL,
		[AssessmentPerformanceLevelUpperCutScore] NVARCHAR (30) NOT NULL,
		CONSTRAINT [PK_DimAssessmentPerformanceLevels] PRIMARY KEY CLUSTERED ([DimAssessmentPerformanceLevelId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[DimAssessmentPerformanceLevels].[IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimAssessmentPerformanceLevels_AssessmentPerformanceLevelIdentifier]
		ON [RDS].[DimAssessmentPerformanceLevels]([AssessmentPerformanceLevelIdentifier] ASC);


	
	PRINT N'Creating Table [RDS].[DimAssessmentRegistrations]...';


	
	CREATE TABLE [RDS].[DimAssessmentRegistrations] (
		[DimAssessmentRegistrationId]                             INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentRegistrationParticipationIndicatorCode]        NVARCHAR (100) NULL,
		[AssessmentRegistrationParticipationIndicatorDescription] NVARCHAR (300) NULL,
		[AssessmentRegistrationCompletionStatusCode]              NVARCHAR (100) NULL,
		[AssessmentRegistrationCompletionStatusDescription]       NVARCHAR (300) NULL,
		[StateFullAcademicYearCode]                               NVARCHAR (100) NULL,
		[StateFullAcademicYearDescription]                        NVARCHAR (300) NULL,
		[StateFullAcademicYearEdFactsCode]                        NVARCHAR (50)  NULL,
		[LeaFullAcademicYearCode]                                 NVARCHAR (100) NULL,
		[LeaFullAcademicYearDescription]                          NVARCHAR (300) NULL,
		[LeaFullAcademicYearEdFactsCode]                          NVARCHAR (50)  NULL,
		[SchoolFullAcademicYearCode]                              NVARCHAR (100) NULL,
		[SchoolFullAcademicYearDescription]                       NVARCHAR (300) NULL,
		[SchoolFullAcademicYearEdFactsCode]                       NVARCHAR (50)  NULL,
		[AssessmentRegistrationReasonNotCompletingCode]           NVARCHAR (100) NULL,
		[AssessmentRegistrationReasonNotCompletingDescription]    NVARCHAR (300) NULL,
		[AssessmentRegistrationReasonNotCompletingEdFactsCode]    NVARCHAR (100) NULL,
		[ReasonNotTestedCode]                                     NVARCHAR (100) NULL,
		[ReasonNotTestedDescription]                              NVARCHAR (300) NULL,
		[ReasonNotTestedEdFactsCode]                              NVARCHAR (100) NULL,
		CONSTRAINT [PK_DimAssessmentRegistrations] PRIMARY KEY CLUSTERED ([DimAssessmentRegistrationId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentResults]...';


	
	CREATE TABLE [RDS].[DimAssessmentResults] (
		[DimAssessmentResultId]                INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentScoreMetricTypeCode]        NVARCHAR (100) NULL,
		[AssessmentScoreMetricTypeDescription] NVARCHAR (300) NULL,
		CONSTRAINT [PK_DimAssessmentResultId] PRIMARY KEY CLUSTERED ([DimAssessmentResultId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAssessmentSubtests]...';


	
	CREATE TABLE [RDS].[DimAssessmentSubtests] (
		[DimAssessmentSubtestId]                     INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentFormNumber]                       NVARCHAR (30)  NULL,
		[AssessmentAcademicSubjectCode]              NVARCHAR (100) NOT NULL,
		[AssessmentAcademicSubjectDescription]       NVARCHAR (400) NOT NULL,
		[AssessmentSubtestIdentifierInternal]        NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestTitle]                     NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestAbbreviation]              NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestDescription]               NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestVersion]                   NVARCHAR (40)  NOT NULL,
		[AssessmentLevelForWhichDesigned]            NVARCHAR (40)  NOT NULL,
		[AssessmentEarlyLearningDevelopmentalDomain] NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestPublishedDate]             DATETIME       NULL,
		[AssessmentSubtestMinimumValue]              NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestMaximumValue]              NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestScaleOptimalValue]         NVARCHAR (40)  NOT NULL,
		[AssessmentContentStandardType]              NVARCHAR (40)  NOT NULL,
		[AssessmentPurpose]                          NVARCHAR (40)  NOT NULL,
		[AssessmentSubtestRules]                     NVARCHAR (40)  NOT NULL,
		[AssessmentFormSubtestTier]                  NVARCHAR (40)  NOT NULL,
		[AssessmentFormSubtestContainerOnly]         NVARCHAR (40)  NOT NULL,
		CONSTRAINT [PK_DimAssessmentSubtests] PRIMARY KEY CLUSTERED ([DimAssessmentSubtestId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimAttendances]...';


	
	CREATE TABLE [RDS].[DimAttendances] (
		[DimAttendanceId]        INT            IDENTITY (1, 1) NOT NULL,
		[AbsenteeismCode]        NVARCHAR (50)  NULL,
		[AbsenteeismDescription] NVARCHAR (200) NULL,
		[AbsenteeismEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimAttendances] PRIMARY KEY CLUSTERED ([DimAttendanceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[DimBuildingSpaceDesignTypes]...';


	
	CREATE TABLE [RDS].[DimBuildingSpaceDesignTypes] (
		[DimBuildingSpaceDesignTypeId]       INT            IDENTITY (1, 1) NOT NULL,
		[BuildingSpaceDesignTypeCode]        NVARCHAR (100) NOT NULL,
		[BuildingSpaceDesignTypeDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimBuildingSpaceDesignTypes] PRIMARY KEY CLUSTERED ([DimBuildingSpaceDesignTypeId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimCharterSchoolStatuses]...';


	
	CREATE TABLE [RDS].[DimCharterSchoolStatuses] (
		[DimCharterSchoolStatusId]       INT            IDENTITY (1, 1) NOT NULL,
		[AppropriationMethodCode]        NVARCHAR (50)  NULL,
		[AppropriationMethodDescription] NVARCHAR (200) NULL,
		[AppropriationMethodEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimCharterSchoolStatus] PRIMARY KEY CLUSTERED ([DimCharterSchoolStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimChildOutcomeSummaries]...';


	
	CREATE TABLE [RDS].[DimChildOutcomeSummaries] (
		[DimChildOutcomeSummaryId]         INT            IDENTITY (1, 1) NOT NULL,
		[COSRatingACode]                   NVARCHAR (100) NOT NULL,
		[COSRatingADescription]            NVARCHAR (300) NOT NULL,
		[COSRatingBCode]                   NVARCHAR (100) NOT NULL,
		[COSRatingBDescription]            NVARCHAR (300) NOT NULL,
		[COSRatingCCode]                   NVARCHAR (100) NOT NULL,
		[COSRatingCDescription]            NVARCHAR (300) NOT NULL,
		[COSProgressAIndicatorCode]        NVARCHAR (100) NOT NULL,
		[COSProgressAIndicatorDescription] NVARCHAR (300) NOT NULL,
		[COSProgressBIndicatorCode]        NVARCHAR (100) NOT NULL,
		[COSProgressBIndicatorDescription] NVARCHAR (300) NOT NULL,
		[COSProgressCIndicatorCode]        NVARCHAR (100) NOT NULL,
		[COSProgressCIndicatorDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimChildOutcomeSummaryId] PRIMARY KEY CLUSTERED ([DimChildOutcomeSummaryId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimCompetencyDefinitions]...';


	
	CREATE TABLE [RDS].[DimCompetencyDefinitions] (
		[DimCompetencyDefinitionId]          INT            IDENTITY (1, 1) NOT NULL,
		[CompetencyDefinitionIdentifier]     NVARCHAR (40)  NULL,
		[CompetencyDefinitionCode]           NVARCHAR (30)  NULL,
		[CompetencyDefinitionShortName]      NVARCHAR (60)  NULL,
		[CompetencyDefinitionStatement]      NVARCHAR (MAX) NULL,
		[CompetencyDefinitionType]           NVARCHAR (60)  NULL,
		[CompetencyDefinitionValidStartDate] DATETIME       NOT NULL,
		[CompetencyDefinitionValidEndDate]   DATETIME       NULL,
		CONSTRAINT [PK_DimCompetencyDefinitionId] PRIMARY KEY CLUSTERED ([DimCompetencyDefinitionId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimDisabilityStatuses]...';


	
	CREATE TABLE [RDS].[DimDisabilityStatuses] (
		[DimDisabilityStatusId]                        INT            IDENTITY (1, 1) NOT NULL,
		[DisabilityStatusCode]                         NVARCHAR (100) NULL,
		[DisabilityStatusDescription]                  NVARCHAR (300) NULL,
		[Section504StatusCode]                         NVARCHAR (100) NULL,
		[Section504StatusDescription]                  NVARCHAR (300) NULL,
		[Section504StatusEdFactsCode]                  NVARCHAR (50)  NULL,
		[DisabilityConditionTypeCode]                  NVARCHAR (100) NULL,
		[DisabilityConditionTypeDescription]           NVARCHAR (300) NULL,
		[DisabilityDeterminationSourceTypeCode]        NVARCHAR (100) NULL,
		[DisabilityDeterminationSourceTypeDescription] NVARCHAR (300) NULL,
		CONSTRAINT [PK_DimDisabilityStatuses] PRIMARY KEY CLUSTERED ([DimDisabilityStatusId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Table [RDS].[DimDisciplineStatuses]...';


	
	CREATE TABLE [RDS].[DimDisciplineStatuses] (
		[DimDisciplineStatusId]                                 INT            IDENTITY (1, 1) NOT NULL,
		[DisciplinaryActionTakenCode]                           NVARCHAR (50)  NULL,
		[DisciplinaryActionTakenDescription]                    NVARCHAR (200) NULL,
		[DisciplinaryActionTakenEdFactsCode]                    NVARCHAR (50)  NULL,
		[DisciplineMethodOfChildrenWithDisabilitiesCode]        NVARCHAR (50)  NULL,
		[DisciplineMethodOfChildrenWithDisabilitiesDescription] NVARCHAR (200) NULL,
		[DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode] NVARCHAR (50)  NULL,
		[EducationalServicesAfterRemovalCode]                   NVARCHAR (50)  NULL,
		[EducationalServicesAfterRemovalDescription]            NVARCHAR (200) NULL,
		[EducationalServicesAfterRemovalEdFactsCode]            NVARCHAR (50)  NULL,
		[IdeaInterimRemovalReasonCode]                          NVARCHAR (50)  NULL,
		[IdeaInterimRemovalReasonDescription]                   NVARCHAR (200) NULL,
		[IdeaInterimRemovalReasonEdFactsCode]                   NVARCHAR (50)  NULL,
		[IdeaInterimRemovalCode]                                NVARCHAR (50)  NULL,
		[IdeaInterimRemovalDescription]                         NVARCHAR (200) NULL,
		[IdeaInterimRemovalEdFactsCode]                         NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimDisciplineStatuses] PRIMARY KEY CLUSTERED ([DimDisciplineStatusId] ASC) WITH (FILLFACTOR = 80)
	);


	
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


	
	PRINT N'Creating Table [RDS].[DimEconomicallyDisadvantagedStatuses]...';


	
	CREATE TABLE [RDS].[DimEconomicallyDisadvantagedStatuses] (
		[DimEconomicallyDisadvantagedStatusId]                              INT            IDENTITY (1, 1) NOT NULL,
		[EconomicDisadvantageStatusCode]                                    NVARCHAR (100) NOT NULL,
		[EconomicDisadvantageStatusDescription]                             NVARCHAR (300) NOT NULL,
		[EconomicDisadvantageStatusEdFactsCode]                             NVARCHAR (50)  NOT NULL,
		[EligibilityStatusForSchoolFoodServiceProgramsCode]                 NVARCHAR (100) NOT NULL,
		[EligibilityStatusForSchoolFoodServiceProgramsDescription]          NVARCHAR (300) NOT NULL,
		[EligibilityStatusForSchoolFoodServiceProgramsEdFactsCode]          NVARCHAR (50)  NOT NULL,
		[NationalSchoolLunchProgramDirectCertificationIndicatorCode]        NVARCHAR (100) NOT NULL,
		[NationalSchoolLunchProgramDirectCertificationIndicatorDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimEconomicallyDisadvantagedStatusId] PRIMARY KEY CLUSTERED ([DimEconomicallyDisadvantagedStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimEducationOrganizationNetworks]...';


	
	CREATE TABLE [RDS].[DimEducationOrganizationNetworks] (
		[DimEducationOrganizationNetworkId] INT            IDENTITY (1, 1) NOT NULL,
		[OrganizationIdentifierSea]         NVARCHAR (50)  NOT NULL,
		[OrganizationTypeCode]              NVARCHAR (100) NOT NULL,
		[OrganizationTypeDescription]       NVARCHAR (300) NOT NULL,
		[OrganizationName]                  NVARCHAR (60)  NOT NULL,
		[RecordStartDateTime]               DATETIME       NOT NULL,
		[RecordEndDateTime]                 DATETIME       NULL,
		CONSTRAINT [PK_DimEducationOrganizationNetworkId] PRIMARY KEY CLUSTERED ([DimEducationOrganizationNetworkId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimEnglishLearnerStatuses]...';


	
	CREATE TABLE [RDS].[DimEnglishLearnerStatuses] (
		[DimEnglishLearnerStatusId]                         INT            IDENTITY (1, 1) NOT NULL,
		[EnglishLearnerStatusCode]                          NVARCHAR (100) NOT NULL,
		[EnglishLearnerStatusDescription]                   NVARCHAR (300) NOT NULL,
		[EnglishLearnerStatusEdFactsCode]                   NVARCHAR (50)  NOT NULL,
		[PerkinsEnglishLearnerStatusCode]                   NVARCHAR (100) NOT NULL,
		[PerkinsEnglishLearnerStatusDescription]            NVARCHAR (300) NOT NULL,
		[PerkinsEnglishLearnerStatusEdfactsCode]	        VARCHAR (50)   NOT NULL,
		CONSTRAINT [PK_DimEnglistLearnerStatuses] PRIMARY KEY CLUSTERED ([DimEnglishLearnerStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimFosterCareStatuses]...';


	
	CREATE TABLE [RDS].[DimFosterCareStatuses] (
		[DimFosterCareStatusId]                     INT            IDENTITY (1, 1) NOT NULL,
		[ProgramParticipationFosterCareCode]        NVARCHAR (50)  NULL,
		[ProgramParticipationFosterCareDescription] NVARCHAR (200) NULL,
		[ProgramParticipationFosterCareEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimFosterCareStatuses] PRIMARY KEY NONCLUSTERED ([DimFosterCareStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimHomelessnessStatuses]...';


	
	CREATE TABLE [RDS].[DimHomelessnessStatuses] (
		[DimHomelessnessStatusId]                      INT            IDENTITY (1, 1) NOT NULL,
		[HomelessnessStatusCode]                       NVARCHAR (100) NOT NULL,
		[HomelessnessStatusDescription]                NVARCHAR (300) NOT NULL,
		[HomelessnessStatusEdFactsCode]                NVARCHAR (50)  NULL,
		[HomelessPrimaryNighttimeResidenceCode]        NVARCHAR (100) NOT NULL,
		[HomelessPrimaryNighttimeResidenceDescription] NVARCHAR (300) NOT NULL,
		[HomelessPrimaryNighttimeResidenceEdfactsCode] NVARCHAR (50)  NOT NULL,
		[HomelessServicedIndicatorCode]                NVARCHAR (100) NOT NULL,
		[HomelessServicedIndicatorDescription]         NVARCHAR (300) NOT NULL,
		[HomelessUnaccompaniedYouthStatusCode]         NVARCHAR (100) NOT NULL,
		[HomelessUnaccompaniedYouthStatusDescription]  NVARCHAR (300) NOT NULL,
		[HomelessUnaccompaniedYouthStatusEdfactsCode]  NVARCHAR (50)  NOT NULL,
		CONSTRAINT [PK_DimHomelessnessStatusId] PRIMARY KEY CLUSTERED ([DimHomelessnessStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimIdeaDisabilityTypes]...';


	
	CREATE TABLE [RDS].[DimIdeaDisabilityTypes] (
		[DimIdeaDisabilityTypeId]       INT            IDENTITY (1, 1) NOT NULL,
		[IdeaDisabilityTypeCode]        NVARCHAR (100) NULL,
		[IdeaDisabilityTypeDescription] NVARCHAR (300) NULL,
		[IdeaDisabilityTypeEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimIdeaDisabilityTypes] PRIMARY KEY CLUSTERED ([DimIdeaDisabilityTypeId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimImmigrantStatuses]...';


	
	CREATE TABLE [RDS].[DimImmigrantStatuses] (
		[DimImmigrantStatusId]                            INT            IDENTITY (1, 1) NOT NULL,
		[TitleIIIImmigrantStatusCode]                     NVARCHAR (100) NOT NULL,
		[TitleIIIImmigrantStatusDescription]              NVARCHAR (300) NOT NULL,
		[TitleIIIImmigrantStatusEdFactsCode]              NVARCHAR (50)  NOT NULL,
		[TitleIIIImmigrantParticipationStatusCode]        NVARCHAR (100) NOT NULL,
		[TitleIIIImmigrantParticipationStatusDescription] NVARCHAR (300) NOT NULL,
		[TitleIIIImmigrantParticipationStatusEdFactsCode] NVARCHAR (50)  NOT NULL,
		CONSTRAINT [PK_DimImmigrantStatuses] PRIMARY KEY CLUSTERED ([DimImmigrantStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimIncidentStatuses]...';


	
	CREATE TABLE [RDS].[DimIncidentStatuses] (
		[DimIncidentStatusId]                 INT            IDENTITY (1, 1) NOT NULL,
		[IncidentBehaviorCode]                NVARCHAR (100) NOT NULL,
		[IncidentBehaviorDescription]         NVARCHAR (300) NOT NULL,
		[IdeaInterimRemovalReasonCode]        NVARCHAR (100) NOT NULL,
		[IdeaInterimRemovalReasonDescription] NVARCHAR (300) NOT NULL,
		[IdeaInterimRemovalReasonEdFactsCode] NVARCHAR (50)  NOT NULL,
		[DisciplineReasonCode]                NVARCHAR (100) NOT NULL,
		[DisciplineReasonDescription]         NVARCHAR (300) NOT NULL,
		[IncidentInjuryTypeCode]              NVARCHAR (100) NOT NULL,
		[IncidentInjuryTypeDescription]       NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimIncidentStatuses] PRIMARY KEY CLUSTERED ([DimIncidentStatusId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimIndividualizedProgramStatuses]...';


	
	CREATE TABLE [RDS].[DimIndividualizedProgramStatuses] (
		[DimIndividualizedProgramStatusId]        INT            IDENTITY (1, 1) NOT NULL,
		[IndividualizedProgramTypeCode]           NVARCHAR (100) NOT NULL,
		[IndividualizedProgramTypeDescription]    NVARCHAR (300) NOT NULL,
		[StudentSupportServiceTypeCode]           NVARCHAR (100) NOT NULL,
		[StudentSupportServiceTypeDescription]    NVARCHAR (300) NOT NULL,
		[ConsentToEvaluationIndicatorCode]        NVARCHAR (100) NOT NULL,
		[ConsentToEvaluationIndicatorDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimIndividualizedProgramStatusId] PRIMARY KEY CLUSTERED ([DimIndividualizedProgramStatusId] ASC)
	);



	
	PRINT N'Creating Table [RDS].[DimMigrantStatuses]...';


	
	CREATE TABLE [RDS].[DimMigrantStatuses] (
		[DimMigrantStatusId]                               INT            IDENTITY (1, 1) NOT NULL,
		[MigrantStatusCode]                                NVARCHAR (100) NOT NULL,
		[MigrantStatusDescription]                         NVARCHAR (300) NOT NULL,
		[MigrantStatusEdFactsCode]                         NVARCHAR (50)  NOT NULL,
		[MigrantEducationProgramEnrollmentTypeCode]        NVARCHAR (100) NOT NULL,
		[MigrantEducationProgramEnrollmentTypeDescription] NVARCHAR (300) NOT NULL,
		[ContinuationOfServicesReasonCode]                 NVARCHAR (100) NOT NULL,
		[ContinuationOfServicesReasonDescription]          NVARCHAR (300) NOT NULL,
		[ConsolidatedMepFundsStatusCode]                   NVARCHAR (100) NOT NULL,
		[MEPContinuationOfServicesStatusCode]			   NVARCHAR (100) NOT NULL,
		[MEPContinuationOfServicesStatusDescription]	   NVARCHAR (300) NOT NULL,
		[MEPContinuationOfServicesStatusEdFactsCode]	   NVARCHAR (50)  NOT NULL,
		[ConsolidatedMepFundsStatusDescription]            NVARCHAR (300) NOT NULL,
		[ConsolidatedMepFundsStatusEdFactsCode]            NVARCHAR (50)  NOT NULL,
		[MigrantEducationProgramServicesTypeCode]          NVARCHAR (100) NOT NULL,
		[MigrantEducationProgramServicesTypeDescription]   NVARCHAR (300) NOT NULL,
		[MigrantEducationProgramServicesTypeEdFactsCode]   NVARCHAR (50)  NOT NULL,
		[MigrantPrioritizedForServicesCode]                NVARCHAR (100) NOT NULL,
		[MigrantPrioritizedForServicesDescription]         NVARCHAR (300) NOT NULL,
		[MigrantPrioritizedForServicesEdFactsCode]         NVARCHAR (50)  NOT NULL,
		CONSTRAINT [PK_DimMigrantStatuses] PRIMARY KEY CLUSTERED ([DimMigrantStatusId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Index [RDS].[DimMigrantStatuses].[IX_DimMigrantStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMigrantStatuses_Codes]
		ON [RDS].[DimMigrantStatuses]([MEPContinuationOfServicesStatusCode] ASC, [ContinuationOfServicesReasonCode] ASC, [ConsolidatedMepFundsStatusCode] ASC, [MigrantEducationProgramServicesTypeCode] ASC, [MigrantPrioritizedForServicesCode] ASC, [MigrantEducationProgramEnrollmentTypeCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimMigrantStatuses].[IX_DimMigrantStatuses_MEPContinuationOfServicesStatusEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMigrantStatuses_MEPContinuationOfServicesStatusEdFactsCode]
		ON [RDS].[DimMigrantStatuses]([MEPContinuationOfServicesStatusEdFactsCode] ASC) WITH (FILLFACTOR = 80);



	
	PRINT N'Creating Index [RDS].[DimMigrantStatuses].[IX_DimMigrantStatuses_MepFundsStatusEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMigrantStatuses_MepFundsStatusEdFactsCode]
		ON [RDS].[DimMigrantStatuses]([ConsolidatedMepFundsStatusEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimMigrantStatuses].[IX_DimMigrantStatuses_MepServicesEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMigrantStatuses_MepServicesEdFactsCode]
		ON [RDS].[DimMigrantStatuses]([MigrantEducationProgramServicesTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimMigrantStatuses].[IX_DimMigrantStatuses_MigrantPriorityForServicesEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMigrantStatuses_MigrantPriorityForServicesEdFactsCode]
		ON [RDS].[DimMigrantStatuses]([MigrantPrioritizedForServicesEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Table [RDS].[DimMilitaryStatuses]...';


	
	CREATE TABLE [RDS].[DimMilitaryStatuses] (
		[DimMilitaryStatusId]                          INT            IDENTITY (1, 1) NOT NULL,
		[MilitaryConnectedStudentIndicatorCode]        NVARCHAR (50)  NULL,
		[MilitaryConnectedStudentIndicatorDescription] NVARCHAR (200) NULL,
		[MilitaryConnectedStudentIndicatorEdFactsCode] NVARCHAR (50)  NULL,
		[MilitaryActiveStudentIndicatorCode]           NVARCHAR (50)  NULL,
		[MilitaryActiveStudentIndicatorDescription]    NVARCHAR (200) NULL,
		[MilitaryBranchCode]                           NVARCHAR (50)  NULL,
		[MilitaryBranchDescription]                    NVARCHAR (200) NULL,
		[MilitaryVeteranStudentIndicatorCode]          NVARCHAR (50)  NULL,
		[MilitaryVeteranStudentIndicatorDescription]   NVARCHAR (200) NULL,
		CONSTRAINT [PK_DimMilitaryStatuses] PRIMARY KEY CLUSTERED ([DimMilitaryStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimMilitaryStatuses].[IX_DimMilitaryStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimMilitaryStatuses_Codes]
		ON [RDS].[DimMilitaryStatuses]([MilitaryConnectedStudentIndicatorCode] ASC, [MilitaryActiveStudentIndicatorCode] ASC, [MilitaryBranchCode] ASC, [MilitaryVeteranStudentIndicatorCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[DimNOrDStatuses]...';


	
	CREATE TABLE [RDS].[DimNOrDStatuses] (
		[DimNOrDStatusId]                                INT            IDENTITY (1, 1) NOT NULL,
		[NeglectedOrDelinquentLongTermStatusCode]        NVARCHAR (50)  NULL,
		[NeglectedOrDelinquentLongTermStatusDescription] NVARCHAR (100) NULL,
		[NeglectedOrDelinquentLongTermStatusEdFactsCode] NVARCHAR (50)  NULL,
		[NeglectedOrDelinquentProgramTypeCode]           NVARCHAR (50)  NULL,
		[NeglectedOrDelinquentProgramTypeDescription]    NVARCHAR (100) NULL,
		[NeglectedOrDelinquentProgramTypeEdFactsCode]    NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimNorDStatuses] PRIMARY KEY NONCLUSTERED ([DimNOrDStatusId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_Codes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_Codes]
		ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentLongTermStatusCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusEdFactsCodes]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_NeglectedOrDelinquentLongTermStatusEdFactsCodes]
		ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentLongTermStatusEdFactsCode] ASC, [NeglectedOrDelinquentProgramTypeCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Index [RDS].[DimNOrDStatuses].[IX_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimNOrDStatuses_NeglectedOrDelinquentProgramTypeEdFactsCode]
		ON [RDS].[DimNOrDStatuses]([NeglectedOrDelinquentProgramTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80);


	
	PRINT N'Creating Table [RDS].[DimPeople]...';


	
	CREATE TABLE [RDS].[DimPeople] (
		[DimPersonId]                                      BIGINT        IDENTITY (1, 1) NOT NULL,
		[FirstName]                                        NVARCHAR (50) NULL,
		[MiddleName]                                       NVARCHAR (50) NULL,
		[LastOrSurname]                                    NVARCHAR (50) NULL,
		[BirthDate]                                        DATE          NULL,
		[ELChildChildIdentifierState]                      NVARCHAR (40) NULL,
		[K12StudentStudentIdentifierState]                 NVARCHAR (40) NULL,
		[K12StudentStudentIdentifierDistrict]              NVARCHAR (40) NULL,
		[K12StudentStudentIdentifierNationalMigrant]       NVARCHAR (40) NULL,
		[PsStudentStudentIdentifierState]                  NVARCHAR (40) NULL,
		[AeStudentStudentIdentifierState]                  NVARCHAR (40) NULL,
		[WorkforceProgramParticipantPersonIdentifierState] NVARCHAR (40) NULL,
		[ELStaffStaffMemberIdentifierState]                NVARCHAR (40) NULL,
		[K12StaffStaffMemberIdentifierState]               NVARCHAR (40) NULL,
		[K12StaffStaffMemberIdentifierDistrict]            NVARCHAR (40) NULL,
		[PsStaffStaffMemberIdentifierState]                NVARCHAR (40) NULL,
		[PersonIdentifierDriversLicense]                   NVARCHAR (40) NULL,
		[IsActiveELChild]                                  BIT           NULL,
		[IsActiveK12Student]                               BIT           NULL,
		[IsActivePsStudent]                                BIT           NULL,
		[IsActiveAeStudent]                                BIT           NULL,
		[IsActiveWorkforceProgramParticipant]              BIT           NULL,
		[IsActiveELStaffMember]                            BIT           NULL,
		[IsActiveK12StaffMember]                           BIT           NULL,
		[IsActivePsStaffMember]                            BIT           NULL,
		[RecordStartDateTime]                              DATETIME      NULL,
		[RecordEndDateTime]                                DATETIME      NULL,
		CONSTRAINT [PK_DimPersonId] PRIMARY KEY CLUSTERED ([DimPersonId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimPersonAddresses]...';


	
	CREATE TABLE [RDS].[DimPersonAddresses] (
		[DimPersonAddressId]                         INT            IDENTITY (1, 1) NOT NULL,
		[AddressTypeForLearnerOrFamilyCode]          NVARCHAR (50)  NULL,
		[AddressTypeForLearnerOrFamilyDescription]   NVARCHAR (150) NULL,
		[AddressStreetNumberAndName]                 NVARCHAR (150) NULL,
		[AddressApartmentRoomOrSuiteNumber]          NVARCHAR (60)  NULL,
		[AddressCity]                                NVARCHAR (30)  NULL,
		[StateAbbreviationCode]                      NVARCHAR (50)  NULL,
		[StateAbbreviationDescription]               NVARCHAR (150) NULL,
		[AddressPostalCode]                          NVARCHAR (17)  NULL,
		[AddressCountyName]                          NVARCHAR (30)  NULL,
		[CountryCodeCode]                            NVARCHAR (50)  NULL,
		[CountryCodeDescription]                     NVARCHAR (150) NULL,
		[Latitude]                                   NVARCHAR (20)  NULL,
		[Longitude]                                  NVARCHAR (20)  NULL,
		[CountyAnsiCodeCode]                         NVARCHAR (50)  NULL,
		[CountyAnsiCodeDescription]                  NVARCHAR (150) NULL,
		[DoNotPublishIndicator]                      NVARCHAR (10)  NULL,
		[PersonalInformationVerificationCode]        NVARCHAR (50)  NULL,
		[PersonalInformationVerificationDescription] NVARCHAR (150) NULL,
		CONSTRAINT [PK_DimPersonAddresses] PRIMARY KEY CLUSTERED ([DimPersonAddressId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimPsAcademicAwardTitles]...';


	
	CREATE TABLE [RDS].[DimPsAcademicAwardTitles] (
		[DimPsAcademicAwardTitleId] INT            IDENTITY (1, 1) NOT NULL,
		[AcademicAwardTitle]        NVARCHAR (160) NOT NULL,
		CONSTRAINT [PK_DimPsAcademicAwardTitles] PRIMARY KEY CLUSTERED ([DimPsAcademicAwardTitleId] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Table [RDS].[DimPsDemographics]...';


	
	CREATE TABLE [RDS].[DimPsDemographics] (
		[DimPsDemographicId]                           INT            IDENTITY (1, 1) NOT NULL,
		[EconomicDisadvantageStatusCode]               NVARCHAR (50)  NULL,
		[EconomicDisadvantageStatusDescription]        NVARCHAR (200) NULL,
		[HomelessnessStatusCode]                       NVARCHAR (50)  NULL,
		[HomelessnessStatusDescription]                NVARCHAR (200) NULL,
		[EnglishLearnerStatusCode]                     NVARCHAR (50)  NULL,
		[EnglishLearnerStatusDescription]              NVARCHAR (200) NULL,
		[MigrantStatusCode]                            NVARCHAR (50)  NULL,
		[MigrantStatusDescription]                     NVARCHAR (200) NULL,
		[MilitaryConnectedStudentIndicatorCode]        NVARCHAR (50)  NULL,
		[MilitaryConnectedStudentIndicatorDescription] NVARCHAR (200) NULL,
		[HomelessPrimaryNighttimeResidenceCode]        NVARCHAR (50)  NULL,
		[HomelessPrimaryNighttimeResidenceDescription] NVARCHAR (MAX) NULL,
		[HomelessUnaccompaniedYouthStatusCode]         NVARCHAR (50)  NULL,
		[HomelessUnaccompaniedYouthStatusDescription]  NVARCHAR (MAX) NULL,
		[SexCode]                                      NVARCHAR (50)  NULL,
		[SexDescription]                               NVARCHAR (200) NULL,
		CONSTRAINT [PK_DimPsDemographics] PRIMARY KEY CLUSTERED ([DimPsDemographicId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimReasonApplicabilities]...';


	
	CREATE TABLE [RDS].[DimReasonApplicabilities] (
		[DimReasonApplicabilityId]       INT           IDENTITY (1, 1) NOT NULL,
		[ReasonApplicabilityCode]        VARCHAR (50)  NULL,
		[ReasonApplicabilityDescription] VARCHAR (200) NULL,
		[ReasonApplicabilityEdFactsCode] VARCHAR (50)  NULL,
		CONSTRAINT [PK_DimReasonApplicability] PRIMARY KEY CLUSTERED ([DimReasonApplicabilityId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimResponsibleOrganizationTypes]...';


	
	CREATE TABLE [RDS].[DimResponsibleOrganizationTypes] (
		[DimResponsibleOrganizationTypeId]   INT            IDENTITY (1, 1) NOT NULL,
		[ResponsibleDistrictTypeCode]        NVARCHAR (50)  NOT NULL,
		[ResponsibleDistrictTypeDescription] NVARCHAR (200) NOT NULL,
		[ResponsibleSchoolTypeCode]          NVARCHAR (50)  NOT NULL,
		[ResponsibleSchoolTypeDescription]   NVARCHAR (200) NOT NULL,
		CONSTRAINT [PK_DimResponsibleOrganizationTypes] PRIMARY KEY CLUSTERED ([DimResponsibleOrganizationTypeId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimResponsibleSchoolTypes]...';


	
	CREATE TABLE [RDS].[DimResponsibleSchoolTypes] (
		[DimResponsibleSchoolTypeId]       INT            IDENTITY (1, 1) NOT NULL,
		[ResponsibleSchoolTypeCode]        NVARCHAR (100) NOT NULL,
		[ResponsibleSchoolTypeDescription] NVARCHAR (300) NOT NULL,
		CONSTRAINT [PK_DimResponsibleSchoolTypes] PRIMARY KEY CLUSTERED ([DimResponsibleSchoolTypeId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[DimSchoolPerformanceIndicatorCategories]...';


	
	CREATE TABLE [RDS].[DimSchoolPerformanceIndicatorCategories] (
		[DimSchoolPerformanceIndicatorCategoryId]       INT            IDENTITY (1, 1) NOT NULL,
		[SchoolPerformanceIndicatorCategoryCode]        NVARCHAR (50)  NULL,
		[SchoolPerformanceIndicatorCategoryDescription] NVARCHAR (200) NULL,
		[SchoolPerformanceIndicatorCategoryEdFactsCode] VARCHAR (50)   NULL,
		CONSTRAINT [PK_DimSchoolPerformanceIndicatorCategories] PRIMARY KEY CLUSTERED ([DimSchoolPerformanceIndicatorCategoryId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimSchoolPerformanceIndicatorCategories].[IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode]
		ON [RDS].[DimSchoolPerformanceIndicatorCategories]([SchoolPerformanceIndicatorCategoryCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimSchoolPerformanceIndicatorCategories].[IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode]
		ON [RDS].[DimSchoolPerformanceIndicatorCategories]([SchoolPerformanceIndicatorCategoryEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[DimSchoolPerformanceIndicators]...';


	
	CREATE TABLE [RDS].[DimSchoolPerformanceIndicators] (
		[DimSchoolPerformanceIndicatorId]           INT           IDENTITY (1, 1) NOT NULL,
		[SchoolPerformanceIndicatorTypeCode]        VARCHAR (50)  NULL,
		[SchoolPerformanceIndicatorTypeDescription] VARCHAR (200) NULL,
		[SchoolPerformanceIndicatorTypeEdFactsCode] VARCHAR (50)  NULL,
		CONSTRAINT [PK_DimSchoolPerformanceIndicators] PRIMARY KEY CLUSTERED ([DimSchoolPerformanceIndicatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimSchoolPerformanceIndicators].[IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode]
		ON [RDS].[DimSchoolPerformanceIndicators]([SchoolPerformanceIndicatorTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimSchoolPerformanceIndicators].[IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode]
		ON [RDS].[DimSchoolPerformanceIndicators]([SchoolPerformanceIndicatorTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses]...';


	
	CREATE TABLE [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses] (
		[DimSchoolPerformanceIndicatorStateDefinedStatusId]       INT            IDENTITY (1, 1) NOT NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusCode]        NVARCHAR (50)  NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusDescription] NVARCHAR (200) NULL,
		CONSTRAINT [PK_DimSchoolPerformanceIndicatorStateDefinedStatuses] PRIMARY KEY CLUSTERED ([DimSchoolPerformanceIndicatorStateDefinedStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses].[IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode]
		ON [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses]([SchoolPerformanceIndicatorStateDefinedStatusCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[DimSchoolQualityOrStudentSuccessIndicators]...';


	
	CREATE TABLE [RDS].[DimSchoolQualityOrStudentSuccessIndicators] (
		[DimSchoolQualityOrStudentSuccessIndicatorId]           INT            IDENTITY (1, 1) NOT NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeCode]        NVARCHAR (50)  NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeDescription] NVARCHAR (200) NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeEdFactsCode] NVARCHAR (50)  NULL,
		CONSTRAINT [PK_DimSchoolQualityOrStudentSuccessIndicators] PRIMARY KEY CLUSTERED ([DimSchoolQualityOrStudentSuccessIndicatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[DimSchoolQualityOrStudentSuccessIndicators].[IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode]
		ON [RDS].[DimSchoolQualityOrStudentSuccessIndicators]([SchoolQualityOrStudentSuccessIndicatorTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[FactAeStudentEnrollments]...';


	
	CREATE TABLE [RDS].[FactAeStudentEnrollments] (
		[FactAeStudentEnrollmentId]           INT            IDENTITY (1, 1) NOT NULL,
		[AeProgramYearId]                     INT            NOT NULL,
		[DataCollectionId]                    INT            NOT NULL,
		[AeStudentId]                         BIGINT            NOT NULL,
		[AeProviderId]                        INT            NOT NULL,
		[AeProgramTypeId]                     INT            NOT NULL,
		[AeStudentStatusId]                   INT            NOT NULL,
		[ApplicationDateId]                   INT            NOT NULL,
		[EnrollmentEntryDateId]               INT            NOT NULL,
		[EnrollmentExitDateId]                INT            NOT NULL,
		[AePostsecondaryTransitionDateId]     INT            NOT NULL,
		[AeDemographicId]                     INT            NOT NULL,
		[K12DiplomaOrCredentialAwardDateId]   INT            NOT NULL,
		[K12AcademicAwardStatusId]            INT            NOT NULL,
		[QuarterlyEarningsAfterExitQ1]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ2]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ3]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ4]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ5]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ6]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ7]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ8]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ9]        DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ10]       DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ11]       DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ12]       DECIMAL (9, 2) NULL,
		[QuarterlyEarningsAfterExitQ13]       DECIMAL (9, 2) NULL,
		[InstructionalActivityHoursCompleted] DECIMAL (9, 2) NULL,
		[StudentCount]                        INT            NOT NULL,
		CONSTRAINT [PK_FactAeStudentEnrollments] PRIMARY KEY CLUSTERED ([FactAeStudentEnrollmentId] ASC)
	);


	
	PRINT N'Creating Table [RDS].[FactK12StudentAssessmentsResultAggregates]...';


	
	CREATE TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] (
		[FactK12StudentAssessmentsResultAggregateId]    INT             IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                                  INT             NOT NULL,
		[SeaId]                                         INT             NOT NULL,
		[IeuId]                                         INT             NOT NULL,
		[LeaId]                                         INT             NOT NULL,
		[K12SchoolId]                                   INT             NOT NULL,
		[AcademicTermDesignatorId]                      INT             NOT NULL,
		[AssessmentAdministrationId]                    INT             NOT NULL,
		[AssessmentId]                                  INT             NOT NULL,
		[AssessmentSubtestId]                           INT             NOT NULL,
		[CompetencyDefinitionId]                        INT             NOT NULL,
		[GradeLevelWhenAssessedId]                      INT             NOT NULL,
		[IdeaStatusId]                                  INT             NOT NULL,
		[K12DemographicId]                              INT             NOT NULL,
		[RaceId]                                        INT             NOT NULL,
		[TotalPerformanceLevel1]                        INT             NULL,
		[TotalPerformanceLevel2]                        INT             NULL,
		[TotalPerformanceLevel3]                        INT             NULL,
		[TotalPerformanceLevel4]                        INT             NULL,
		[TotalPerformanceLevel5]                        INT             NULL,
		[TotalPerformanceLevel6]                        INT             NULL,
		[TotalMetStandard]                              INT             NULL,
		[TotalDidNotMeetStandard]                       INT             NULL,
		[PercentagePerformanceLevel1]                   DECIMAL (4, 1)  NULL,
		[PercentagePerformanceLevel2]                   DECIMAL (4, 1)  NULL,
		[PercentagePerformanceLevel3]                   DECIMAL (4, 1)  NULL,
		[PercentagePerformanceLevel4]                   DECIMAL (4, 1)  NULL,
		[PercentagePerformanceLevel5]                   DECIMAL (4, 1)  NULL,
		[PercentagePerformanceLevel6]                   DECIMAL (4, 1)  NULL,
		[PercentageMetStandard]                         DECIMAL (4, 1)  NULL,
		[PercentageDidNotMeetStandard]                  DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel1]            DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel2]            DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel3]            DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel4]            DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel5]            DECIMAL (4, 1)  NULL,
		[AverageScaleScorePerformanceLevel6]            DECIMAL (4, 1)  NULL,
		[AverageScaleScoreMetStandard]                  DECIMAL (4, 1)  NULL,
		[AverageScaleScoreDidNotMeetStandard]           DECIMAL (4, 1)  NULL,
		[AverageScaleScore]                             DECIMAL (6, 2)  NULL,
		[StandarDeviationScaleScorePerformanceLevel1]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScorePerformanceLevel2]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScorePerformanceLevel3]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScorePerformanceLevel4]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScorePerformanceLevel5]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScorePerformanceLevel6]   DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScoreMetDeviation]        DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScoreDidNotMeetDeviation] DECIMAL (4, 1)  NULL,
		[StandarDeviationScaleScore]                    DECIMAL (5, 2)  NULL,
		[TotalAssessmentCount]                          INT             NULL,
		[TotalValidAssessmentCount]                     INT             NULL,
		[AssessmentSubtestMinimumValueScaleScore]       DECIMAL (20, 2) NULL,
		[AssessmentSubtestMaximumValueScaleScore]       DECIMAL (20, 2) NULL,
		[ScaleScore25thPercentile]                      DECIMAL (20, 2) NULL,
		[ScaleScore50thPercentile]                      DECIMAL (20, 2) NULL,
		[ScaleScore75thPercentile]                      DECIMAL (20, 2) NULL,
		CONSTRAINT [PK_FactK12StudentAssessmentsResultAggregates] PRIMARY KEY CLUSTERED ([FactK12StudentAssessmentsResultAggregateId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([AcademicTermDesignatorId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([AssessmentAdministrationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([AssessmentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([AssessmentSubtestId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([CompetencyDefinitionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([GradeLevelWhenAssessedId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([IdeaStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_IeuId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([IeuId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_K12DemographicId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_K12SchoolId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_LeaId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([LeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_RaceId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([RaceId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_SchoolYearId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAssessmentsResultAggregates].[IXFK_FactK12StudentAssessmentsResultAggregates_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAssessmentsResultAggregates_SeaId]
		ON [RDS].[FactK12StudentAssessmentsResultAggregates]([SeaId] ASC);


	
	PRINT N'Creating Table [RDS].[FactK12StudentAttendanceRates]...';


	
	CREATE TABLE [RDS].[FactK12StudentAttendanceRates] (
		[FactK12StudentAttendanceRateId] INT             IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                   INT             NOT NULL,
		[FactTypeId]                     INT             NOT NULL,
		[SeaId]                          INT             NOT NULL,
		[LeaId]                          INT             NOT NULL,
		[K12SchoolId]                    INT             NOT NULL,
		[K12StudentId]                   BIGINT             NOT NULL,
		[AttendanceId]                   INT             NOT NULL,
		[K12DemographicId]               INT             NOT NULL,
		[StudentAttendanceRate]          DECIMAL (18, 3) NULL
	);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_AttendanceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_AttendanceId]
		ON [RDS].[FactK12StudentAttendanceRates]([AttendanceId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_FactTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_FactTypeId]
		ON [RDS].[FactK12StudentAttendanceRates]([FactTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_K12DemographicId]
		ON [RDS].[FactK12StudentAttendanceRates]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_K12SchoolId]
		ON [RDS].[FactK12StudentAttendanceRates]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_K12StudentId]
		ON [RDS].[FactK12StudentAttendanceRates]([K12StudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_LeaId]
		ON [RDS].[FactK12StudentAttendanceRates]([LeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_SchoolYearId]
		ON [RDS].[FactK12StudentAttendanceRates]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentAttendanceRates].[IXFK_FactK12StudentAttendanceRates_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentAttendanceRates_SeaId]
		ON [RDS].[FactK12StudentAttendanceRates]([SeaId] ASC);


	
	PRINT N'Creating Table [RDS].[FactK12StudentEconomicDisadvantages]...';


	
	CREATE TABLE [RDS].[FactK12StudentEconomicDisadvantages] (
		[FactK12StudentEconomicDisadvantageId] INT IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                         INT NOT NULL,
		[CountDateId]                          INT NOT NULL,
		[DataCollectionId]                     INT NOT NULL,
		[NcesSideVintageBeginYearDateId]       INT NOT NULL,
		[NcesSideVintageEndYearDateId]         INT NOT NULL,
		[SeaId]                                INT NOT NULL,
		[IeuId]                                INT NOT NULL,
		[LeaId]                                INT NOT NULL,
		[K12SchoolId]                          INT NOT NULL,
		[K12StudentId]                         BIGINT NOT NULL,
		[K12DemographicId]                     INT NOT NULL,
		[EconomicallyDisadvantagedStatusId]    INT NOT NULL,
		[K12StudentStatusId]                   INT NOT NULL,
		[PersonAddressId]                      INT NOT NULL,
		[NcesSideEstimate]                     INT NOT NULL,
		[NcesSideStandardError]                INT NOT NULL,
		CONSTRAINT [PK_FactK12StudentEconomicDisadvantages] PRIMARY KEY CLUSTERED ([FactK12StudentEconomicDisadvantageId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_CountDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_CountDateId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([CountDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_DataCollectionId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([DataCollectionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([EconomicallyDisadvantagedStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_IeuId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([IeuId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_K12DemographicId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_K12SchoolId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_K12StudentId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([K12StudentId] ASC);


	
	-- PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_K12StudentStatusId]...';


	-- 
	-- CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_K12StudentStatusId]
	-- 	ON [RDS].[FactK12StudentEconomicDisadvantages]([K12StudentStatusId] ASC);


	-- 
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_LeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_LeaId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([LeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([NcesSideVintageBeginYearDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_NcesSideVantageDateYearDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_NcesSideVantageDateYearDateId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([NcesSideVintageEndYearDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_PersonAddressId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_PersonAddressId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([PersonAddressId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_SchoolYearId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactK12StudentEconomicDisadvantages].[IXFK_FactK12StudentEconomicDisadvantages_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactK12StudentEconomicDisadvantages_SeaId]
		ON [RDS].[FactK12StudentEconomicDisadvantages]([SeaId] ASC);


	
	PRINT N'Creating Table [RDS].[FactSchoolPerformanceIndicators]...';


	
	CREATE TABLE [RDS].[FactSchoolPerformanceIndicators] (
		[FactSchoolPerformanceIndicatorId]               INT IDENTITY (1, 1) NOT NULL,
		[FactTypeId]                                     INT NOT NULL,
		[K12SchoolId]                                    INT NOT NULL,
		[CountDateId]                                    INT NOT NULL,
		[RaceId]                                         INT NOT NULL,
		[IdeaStatusId]                                   INT NOT NULL,
		[K12DemographicId]                               INT NOT NULL,
		[EconomicallyDisadvantagedStatusId]              INT NOT NULL,
		[SubgroupId]                                     INT NOT NULL,
		[SchoolPerformanceIndicatorId]                   INT NOT NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusId] INT NOT NULL,
		[OrganizationCount]                              INT NOT NULL,
		CONSTRAINT [PK_FactSchoolPerformanceIndicators] PRIMARY KEY CLUSTERED ([FactSchoolPerformanceIndicatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimDates]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimDates]
		ON [RDS].[FactSchoolPerformanceIndicators]([CountDateId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimIdeaStatuses]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimIdeaStatuses]
		ON [RDS].[FactSchoolPerformanceIndicators]([IdeaStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators]
		ON [RDS].[FactSchoolPerformanceIndicators]([SchoolPerformanceIndicatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimK12Demographics]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimK12Demographics]
		ON [RDS].[FactSchoolPerformanceIndicators]([K12DemographicId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimK12Schools]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimK12Schools]
		ON [RDS].[FactSchoolPerformanceIndicators]([K12SchoolId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimRace]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimRace]
		ON [RDS].[FactSchoolPerformanceIndicators]([RaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[FactSchoolPerformanceIndicators].[IXFK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses]
		ON [RDS].[FactSchoolPerformanceIndicators]([SchoolPerformanceIndicatorStateDefinedStatusId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[FactSpecialEducation]...';


	
	CREATE TABLE [RDS].[FactSpecialEducation] (
		[FactSpecialEducationId]                             INT            IDENTITY (1, 1) NOT NULL,
		[SchoolYearId]                                       INT            NOT NULL,
		[CountDateId]                                        INT            NOT NULL,
		[DataCollectionId]                                   INT            NOT NULL,
		[SeaId]                                              INT            NOT NULL,
		[IeuId]                                              INT            NOT NULL,
		[LeaAccountabilityId]                                INT            NOT NULL,
		[LeaAttendanceId]                                    INT            NOT NULL,
		[LeaFundingId]                                       INT            NOT NULL,
		[LeaGraduationId]                                    INT            NOT NULL,
		[LeaIndividualizedEducationProgramId]                INT            NOT NULL,
		[LeaIEPServiceProviderId]                            INT            NOT NULL,
		[K12SchoolId]                                        INT            NOT NULL,
		[ResponsibleSchoolTypeId]                            INT            NOT NULL,
		[K12StudentId]                                       BIGINT            NOT NULL,
		[EnrollmentEntryDateId]                              INT            NOT NULL,
		[EnrollmentExitDateId]                               INT            NOT NULL,
		[ConsentToEvaluationDateId]                          INT            NOT NULL,
		[ChildOutcomeSummaryBaselineId]                      INT            NOT NULL,
		[ChildOutcomeSummaryAtExitId]                        INT            NOT NULL,
		[ChildOutcomeSummaryDateBaselineId]                  INT            NOT NULL,
		[ChildOutcomeSummaryDateAtExitId]                    INT            NOT NULL,
		[DisabilityStatusId]                                 INT            NOT NULL,
		[CteStatusId]                                        INT            NOT NULL,
		[EconomicallyDisadvantagedStatusId]                  INT            NOT NULL,
		[EnglishLearnerStatusId]                             INT            NOT NULL,
		[EntryGradeLevelId]                                  INT            NOT NULL,
		[EligibilityEvaluationDateInitialId]                 INT            NOT NULL,
		[EligibilityEvaluationDateReevaluationId]            INT            NOT NULL,
		[FosterCareStatusId]                                 INT            NOT NULL,
		[HomelessnessStatusId]                               INT            NOT NULL,
		[IdeaStatusId]                                       INT            NOT NULL,
		[ImmigrantStatusId]                                  INT            NOT NULL,
		[IndividualizedProgramStatusId]                      INT            NOT NULL,
		[IndividualizedProgramServicePlanDateId]             INT            NOT NULL,
		[IndividualizedProgramServicePlanReevaluationDateId] INT            NOT NULL,
		[IndividualizedProgramServicePlanExitDateId]         INT            NOT NULL,
		[IndividualizedProgramDateId]                        INT            NOT NULL,
		[K12EnrollmentStatusId]                              INT            NOT NULL,
		[K12DemographicId]                                   INT            NOT NULL,
		[MigrantStatusId]                                    INT            NOT NULL,
		[MilitaryStatusId]                                   INT            NOT NULL,
		[NOrDStatusId]                                       INT            NOT NULL,
		[ProgramParticipationStartDateId]                    INT            NOT NULL,
		[PrimaryDisabilityTypeId]                            INT            NOT NULL,
		[SecondaryDisabilityTypeId]                          INT            NOT NULL,
		[SpecialEducationServicesExitDateId]                 INT            NOT NULL,
		[TitleIIIStatusId]                                   INT            NOT NULL,
		[TitleIStatusId]                                     INT            NOT NULL,
		[FullTimeEquivalencyEnrollment]                      DECIMAL (5, 2) NULL,
		[FullTimeEquivalencySpecialEducation]                DECIMAL (5, 2) NULL,
		[StudentCount]                                       TINYINT        NULL,
		CONSTRAINT [PK_FactSpecialEducationId] PRIMARY KEY CLUSTERED ([FactSpecialEducationId] ASC)
	);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ChildOutcomeSummaryAtExitId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ChildOutcomeSummaryAtExitId]
		ON [RDS].[FactSpecialEducation]([ChildOutcomeSummaryAtExitId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ChildOutcomeSummaryBaselineId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ChildOutcomeSummaryBaselineId]
		ON [RDS].[FactSpecialEducation]([ChildOutcomeSummaryBaselineId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]
		ON [RDS].[FactSpecialEducation]([ChildOutcomeSummaryDateAtExitId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]
		ON [RDS].[FactSpecialEducation]([ChildOutcomeSummaryDateBaselineId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ConsentToEvaluationDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ConsentToEvaluationDateId]
		ON [RDS].[FactSpecialEducation]([ConsentToEvaluationDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_CteStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_CteStatusId]
		ON [RDS].[FactSpecialEducation]([CteStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_DataCollectionId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_DataCollectionId]
		ON [RDS].[FactSpecialEducation]([DataCollectionId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_DimK12Schools_K12SchoolId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_DimK12Schools_K12SchoolId]
		ON [RDS].[FactSpecialEducation]([K12SchoolId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_DisabilityStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_DisabilityStatusId]
		ON [RDS].[FactSpecialEducation]([DisabilityStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EconomicallyDisadvantagedStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EconomicallyDisadvantagedStatusId]
		ON [RDS].[FactSpecialEducation]([EconomicallyDisadvantagedStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EligibilityEvaluationDateInitialId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EligibilityEvaluationDateInitialId]
		ON [RDS].[FactSpecialEducation]([EligibilityEvaluationDateInitialId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]
		ON [RDS].[FactSpecialEducation]([EligibilityEvaluationDateReevaluationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EnglishLearnerStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EnglishLearnerStatusId]
		ON [RDS].[FactSpecialEducation]([EnglishLearnerStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EnrollmentEntryDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EnrollmentEntryDateId]
		ON [RDS].[FactSpecialEducation]([EnrollmentEntryDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_EnrollmentExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_EnrollmentExitDateId]
		ON [RDS].[FactSpecialEducation]([EnrollmentExitDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_FosterCareStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_FosterCareStatusId]
		ON [RDS].[FactSpecialEducation]([FosterCareStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_GradeLevelId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_GradeLevelId]
		ON [RDS].[FactSpecialEducation]([EntryGradeLevelId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_HomelessnessStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_HomelessnessStatusId]
		ON [RDS].[FactSpecialEducation]([HomelessnessStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IdeaStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IdeaStatusId]
		ON [RDS].[FactSpecialEducation]([IdeaStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IeuId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IeuId]
		ON [RDS].[FactSpecialEducation]([IeuId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ImmigrantStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ImmigrantStatusId]
		ON [RDS].[FactSpecialEducation]([ImmigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IndividualizedProgramDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IndividualizedProgramDateId]
		ON [RDS].[FactSpecialEducation]([IndividualizedProgramDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IndividualizedProgramStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IndividualizedProgramStatusId]
		ON [RDS].[FactSpecialEducation]([IndividualizedProgramStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanDateId]
		ON [RDS].[FactSpecialEducation]([IndividualizedProgramServicePlanDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanExitDateId]
		ON [RDS].[FactSpecialEducation]([IndividualizedProgramServicePlanExitDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanReevaluationDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_IndividualizedProgramStatusServicePlanReevaluationDateId]
		ON [RDS].[FactSpecialEducation]([IndividualizedProgramServicePlanReevaluationDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_K12DemographicId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_K12DemographicId]
		ON [RDS].[FactSpecialEducation]([K12DemographicId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_K12EnrollmentStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_K12EnrollmentStatusId]
		ON [RDS].[FactSpecialEducation]([K12EnrollmentStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_K12StudentId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_K12StudentId]
		ON [RDS].[FactSpecialEducation]([K12StudentId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaAccountabilityId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaAccountabilityId]
		ON [RDS].[FactSpecialEducation]([LeaAccountabilityId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaAttendanceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaAttendanceId]
		ON [RDS].[FactSpecialEducation]([LeaAttendanceId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaFundingId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaFundingId]
		ON [RDS].[FactSpecialEducation]([LeaFundingId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaGraduationId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaGraduationId]
		ON [RDS].[FactSpecialEducation]([LeaGraduationId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaIndividualizedEducationProgramId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaIndividualizedEducationProgramId]
		ON [RDS].[FactSpecialEducation]([LeaIndividualizedEducationProgramId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_LeaIEPServiceProviderId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_LeaIEPServiceProviderId]
		ON [RDS].[FactSpecialEducation]([LeaIEPServiceProviderId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_MigrantId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_MigrantId]
		ON [RDS].[FactSpecialEducation]([MigrantStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_MilitaryId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_MilitaryId]
		ON [RDS].[FactSpecialEducation]([MilitaryStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_NOrDStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_NOrDStatusId]
		ON [RDS].[FactSpecialEducation]([NOrDStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_PrimaryDisabilityTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_PrimaryDisabilityTypeId]
		ON [RDS].[FactSpecialEducation]([PrimaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ProgramParticipationStartDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ProgramParticipationStartDateId]
		ON [RDS].[FactSpecialEducation]([ProgramParticipationStartDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_ResponsibleSchoolTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_ResponsibleSchoolTypeId]
		ON [RDS].[FactSpecialEducation]([ResponsibleSchoolTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_SchoolYearId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_SchoolYearId]
		ON [RDS].[FactSpecialEducation]([SchoolYearId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_SeaId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_SeaId]
		ON [RDS].[FactSpecialEducation]([SeaId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_SecondaryDisabilityTypeId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_SecondaryDisabilityTypeId]
		ON [RDS].[FactSpecialEducation]([SecondaryDisabilityTypeId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_SpecialEducationServicesExitDateId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_SpecialEducationServicesExitDateId]
		ON [RDS].[FactSpecialEducation]([SpecialEducationServicesExitDateId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_TitleIIIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_TitleIIIStatusId]
		ON [RDS].[FactSpecialEducation]([TitleIIIStatusId] ASC);


	
	PRINT N'Creating Index [RDS].[FactSpecialEducation].[IXFK_FactSpecialEducation_TitleIStatusId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_FactSpecialEducation_TitleIStatusId]
		ON [RDS].[FactSpecialEducation]([TitleIStatusId] ASC);


	
	PRINT N'Creating Table [RDS].[ReportEDFactsK12StudentAssessments]...';


	
	CREATE TABLE [RDS].[ReportEDFactsK12StudentAssessments] (
		[ReportEDFactsK12StudentAssessmentId]           INT             IDENTITY (1, 1) NOT NULL,
		[ASSESSMENTSUBJECT]                             NVARCHAR (50)   NULL,
		[ASSESSMENTTYPE]                                NVARCHAR (50)   NULL,
		[AssessmentCount]                               INT             NOT NULL,
		[SPECIALEDUCATIONEXITREASON]                    NVARCHAR (50)   NULL,
		[CTEPROGRAM]                                    NVARCHAR (50)   NULL,
		[Categories]                                    NVARCHAR (300)  NULL,
		[CategorySetCode]                               NVARCHAR (40)   NOT NULL,
		[IDEADISABILITYTYPE]                            NVARCHAR (50)   NULL,
		[ECONOMICDISADVANTAGESTATUS]                    NVARCHAR (50)   NULL,
		[IDEAEDUCATIONALENVIRONMENT]                    NVARCHAR (50)   NULL,
		[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS] NVARCHAR (50)   NULL,
		[FOSTERCAREPROGRAM]                             NVARCHAR (50)   NULL,
		[FULLYEARSTATUS]                                NVARCHAR (50)   NULL,
		[GRADELEVEL]                                    NVARCHAR (50)   NULL,
		[HOMElESSNESSSTATUS]                            NVARCHAR (50)   NULL,
		[TITLEIIIIMMIGRANTPARTICIPATIONSTATUS]          NVARCHAR (50)   NULL,
		[ENGLISHLEARNERSTATUS]                          NVARCHAR (50)   NULL,
		[MIGRANTSTATUS]                                 NVARCHAR (50)   NULL,
		[OrganizationName]                              NVARCHAR (1000) NOT NULL,
		[OrganizationIdentifierNces]                    NVARCHAR (100)  NOT NULL,
		[OrganizationIdentifierSea]                     NVARCHAR (100)  NOT NULL,
		[PARTICIPATIONSTATUS]                           NVARCHAR (50)   NULL,
		[PERFORMANCELEVEL]                              NVARCHAR (50)   NULL,
		[ParentOrganizationIdentifierSea]               NVARCHAR (MAX)  NULL,
		[RACE]                                          NVARCHAR (50)   NULL,
		[ReportCode]                                    NVARCHAR (40)   NOT NULL,
		[ReportLevel]                                   NVARCHAR (40)   NOT NULL,
		[ReportYear]                                    NVARCHAR (40)   NOT NULL,
		[SECTION504STATUS]                              NVARCHAR (50)   NULL,
		[SEX]                                           NVARCHAR (50)   NULL,
		[StateANSICode]                                 NVARCHAR (100)  NOT NULL,
		[StateAbbreviationCode]                         NVARCHAR (100)  NOT NULL,
		[StateAbbreviationDescription]                  NVARCHAR (1000) NOT NULL,
		[TableTypeAbbrv]                                NVARCHAR (MAX)  NULL,
		[TotalIndicator]                                NVARCHAR (MAX)  NULL,
		[ASSESSEDFIRSTTIME]                             NVARCHAR (50)   NULL,
		[FORMERENGLISHLEARNERYEARSTATUS]                NVARCHAR (50)   NULL,
		[MILITARYCONNECTEDSTUDENTINDICATOR]             NVARCHAR (50)   NULL,
		[PROFICIENCYSTATUS]                             NVARCHAR (50)   NULL,
		[TITLEIIIACCOUNTABILITYPROGRESSSTATUS]          NVARCHAR (50)   NULL,
		[TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE]        NVARCHAR (50)   NULL,
		[TITLEIIIPROGRAMPARTICIPATION]                  NVARCHAR (50)   NULL,
		[CTEAEDISPLACEDHOMEMAKERINDICATOR]              NVARCHAR (50)   NULL,
		[CTENONTRADITIONALGENDERSTATUS]                 NVARCHAR (50)   NULL,
		[PLACEMENTSTATUS]                               NVARCHAR (50)   NULL,
		[PLACEMENTTYPE]                                 NVARCHAR (50)   NULL,
		[REPRESENTATIONSTATUS]                          NVARCHAR (50)   NULL,
		[SINGLEPARENTORSINGLEPREGNANTWOMAN]             NVARCHAR (50)   NULL,
		[NEGLECTEDORDELINQUENTPROGRAMTYPE]              NVARCHAR (50)   NULL,
		[MOBILITYSTATUS12MO]                            NVARCHAR (50)   NULL,
		[MOBILITYSTATUSSY]                              NVARCHAR (50)   NULL,
		[REFERRALSTATUS]                                NVARCHAR (50)   NULL,
		[CTEGRADUATIONRATEINCLUSION]                    NVARCHAR (50)   NULL,
		[TESTRESULT]                                    NVARCHAR (50)   NULL,
		[HOMELESSPRIMARYNIGHTTIMERESIDENCE]             NVARCHAR (50)   NULL,
		[HOMELESSUNACCOMPANIEDYOUTHSTATUS]              NVARCHAR (50)   NULL,
		[PROGRESSLEVEL]                       			NVARCHAR (50)   NULL,
		[YEAR]                                          NVARCHAR (50)   NULL,
		[LONGTERMSTATUS]                                NVARCHAR (50)   NULL,
		[HIGHSCHOOLDIPLOMATYPE]                         NVARCHAR (50)   NULL,
		[ACADEMICORVOCATIONALEXITOUTCOME]               NVARCHAR (50)   NULL,
		[ACADEMICORVOCATIONALOUTCOME]                   NVARCHAR (50)   NULL,
		[HOMELESSSERVICEDINDICATOR]                     NVARCHAR (50)   NULL,
		[PERKINSENGLISHLEARNERSTATUS]                   NVARCHAR (50)   NULL,
		[IDEAINDICATOR]                                 VARCHAR (50)    NULL,
		[TITLEISUPPORTSERVICES]                         VARCHAR (50)    NULL,
		[TITLEIINSTRUCTIONALSERVICES]                   VARCHAR (50)    NULL,
		[TITLEIPROGRAMTYPE]                             VARCHAR (50)    NULL,
		[TITLEISCHOOLSTATUS]                            VARCHAR (50)    NULL,
		[PostSecondaryEnrollmentStatus]                 VARCHAR (50)    NULL,
		[AssessmentTypeAdministeredToEnglishLearners]   VARCHAR (50)    NULL,
		CONSTRAINT [PK_FactStudentAssessmentReports] PRIMARY KEY CLUSTERED ([ReportEDFactsK12StudentAssessmentId] ASC) WITH (DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsK12StudentAssessments].[IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CategorySetCode]
		ON [RDS].[ReportEDFactsK12StudentAssessments]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsK12StudentAssessments].[IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CategorySetCode_SubJect_AssmentType_Grade]...';


	
	CREATE NONCLUSTERED INDEX [IX_FactStudentAssessmentReports_ReportCode_ReportYear_ReportLevel_CategorySetCode_SubJect_AssmentType_Grade]
		ON [RDS].[ReportEDFactsK12StudentAssessments]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC, [ASSESSMENTSUBJECT] ASC, [ASSESSMENTTYPE] ASC, [GRADELEVEL] ASC);


	
	PRINT N'Creating Table [RDS].[ReportEDFactsK12StudentAttendance]...';


	
	CREATE TABLE [RDS].[ReportEDFactsK12StudentAttendance] (
		[ReportEDFactsK12StudentAttendanceId] INT             IDENTITY (1, 1) NOT NULL,
		[Categories]                          NVARCHAR (300)  NULL,
		[CategorySetCode]                     NVARCHAR (40)   NOT NULL,
		[ECODISSTATUS]                        NVARCHAR (50)   NULL,
		[HOMELESSSTATUS]                      NVARCHAR (50)   NULL,
		[LEPSTATUS]                           NVARCHAR (50)   NULL,
		[MIGRANTSTATUS]                       NVARCHAR (50)   NULL,
		[OrganizationName]                    NVARCHAR (1000) NOT NULL,
		[OrganizationIdentifierNces]          NVARCHAR (100)  NOT NULL,
		[OrganizationIdentifierSea]           NVARCHAR (100)  NOT NULL,
		[ParentOrganizationIdentifierSea]     NVARCHAR (100)  NULL,
		[RACE]                                NVARCHAR (50)   NULL,
		[ReportCode]                          NVARCHAR (40)   NOT NULL,
		[ReportLevel]                         NVARCHAR (40)   NOT NULL,
		[ReportYear]                          NVARCHAR (40)   NOT NULL,
		[SEX]                                 NVARCHAR (50)   NULL,
		[StateANSICode]                       NVARCHAR (100)  NOT NULL,
		[StateAbbreviationCode]               NVARCHAR (100)  NOT NULL,
		[StateAbbreviationDescription]        NVARCHAR (500)  NOT NULL,
		[StudentAttendanceRate]               DECIMAL (18, 3) NOT NULL,
		[TableTypeAbbrv]                      NVARCHAR (100)  NULL,
		[TotalIndicator]                      NVARCHAR (5)    NULL,
		[MILITARYCONNECTEDSTATUS]             NVARCHAR (50)   NULL,
		[HOMELESSNIGHTTIMERESIDENCE]          NVARCHAR (50)   NULL,
		[HOMELESSUNACCOMPANIEDYOUTHSTATUS]    NVARCHAR (50)   NULL,
		[ATTENDANCE]                          VARCHAR (50)    NULL
	);


	
	PRINT N'Creating Table [RDS].[ReportEDFactsOrganizationCounts]...';


	
	CREATE TABLE [RDS].[ReportEDFactsOrganizationCounts] (
		[ReportEDFactsOrganizationCountId]        INT             IDENTITY (1, 1) NOT NULL,
		[CSSOEmail]                               NVARCHAR (100)  NULL,
		[CSSOFirstName]                           NVARCHAR (100)  NULL,
		[CSSOLastOrSurname]                       NVARCHAR (100)  NULL,
		[CSSOTelephone]                           NVARCHAR (24)   NULL,
		[CSSOTitle]                               NVARCHAR (100)  NULL,
		[Categories]                              NVARCHAR (300)  NULL,
		[CategorySetCode]                         NVARCHAR (40)   NOT NULL,
		[CharterLeaStatus]                        NVARCHAR (100)  NULL,
		[CharterSchoolAuthorizerIdPrimary]        NVARCHAR (50)   NULL,
		[CharterSchoolAuthorizerIdSecondary]      NVARCHAR (50)   NULL,
		[CharterSchoolStatus]                     NVARCHAR (100)  NULL,
		[EffectiveDate]                           NVARCHAR (50)   NULL,
		[GRADELEVEL]                              NVARCHAR (50)   NULL,
		[LEAType]                                 NVARCHAR (50)   NULL,
		[LEATypeId]                               NVARCHAR (MAX)  NULL,
		[MAGNETSTATUS]                            NVARCHAR (MAX)  NULL,
		[MailingAddressCity]                      NVARCHAR (50)   NULL,
		[MailingAddressPostalCode]                NVARCHAR (17)   NULL,
		[MailingAddressState]                     NVARCHAR (50)   NULL,
		[MailingAddressStreet]                    NVARCHAR (100)  NULL,
		[NSLPSTATUS]                              NVARCHAR (MAX)  NULL,
		[OperationalStatus]                       NVARCHAR (50)   NULL,
		[OperationalStatusId]                     NVARCHAR (MAX)  NULL,
		[OrganizationCount]                       INT             NOT NULL,
		[OrganizationId]                          INT             NOT NULL,
		[OrganizationName]                        NVARCHAR (1000) NOT NULL,
		[OrganizationNcesId]                      NVARCHAR (100)  NULL,
		[OrganizationStateId]                     NVARCHAR (100)  NULL,
		[OutOfStateIndicator]                     NVARCHAR (MAX)  NULL,
		[ParentOrganizationStateId]               NVARCHAR (100)  NULL,
		[PhysicalAddressCity]                     NVARCHAR (50)   NULL,
		[PhysicalAddressPostalCode]               NVARCHAR (17)   NULL,
		[PhysicalAddressState]                    NVARCHAR (50)   NULL,
		[PhysicalAddressStreet]                   NVARCHAR (100)  NULL,
		[PriorLeaStateIdentifier]                 NVARCHAR (50)   NULL,
		[PriorSchoolStateIdentifier]              NVARCHAR (50)   NULL,
		[ReconstitutedStatus]                     NVARCHAR (100)  NULL,
		[ReportCode]                              NVARCHAR (40)   NOT NULL,
		[ReportLevel]                             NVARCHAR (40)   NOT NULL,
		[ReportYear]                              NVARCHAR (40)   NOT NULL,
		[SHAREDTIMESTATUS]                        NVARCHAR (MAX)  NULL,
		[SchoolType]                              NVARCHAR (50)   NULL,
		[SchoolTypeId]                            NVARCHAR (MAX)  NULL,
		[StateANSICode]                           NVARCHAR (100)  NOT NULL,
		[StateCode]                               NVARCHAR (100)  NOT NULL,
		[StateName]                               NVARCHAR (1000) NOT NULL,
		[SupervisoryUnionIdentificationNumber]    NCHAR (3)       NULL,
		[TITLE1SCHOOLSTATUS]                      NVARCHAR (MAX)  NULL,
		[TableTypeAbbrv]                          NVARCHAR (100)  NULL,
		[Telephone]                               NVARCHAR (24)   NULL,
		[TotalIndicator]                          NVARCHAR (5)    NULL,
		[UpdatedOperationalStatus]                NVARCHAR (50)   NULL,
		[UpdatedOperationalStatusId]              NVARCHAR (MAX)  NULL,
		[VIRTUALSCHSTATUS]                        NVARCHAR (MAX)  NULL,
		[Website]                                 NVARCHAR (100)  NULL,
		[TitleiParentalInvolveRes]                INT             NOT NULL,
		[TitleiPartaAllocations]                  INT             NOT NULL,
		[ParentOrganizationNcesId]                NVARCHAR (100)  NULL,
		[CharterSchoolIndicator]                  BIT             NULL,
		[CharterSchoolContractIdNumber]           NVARCHAR (MAX)  NULL,
		[CharterContractApprovalDate]             NVARCHAR (MAX)  NULL,
		[CharterContractRenewalDate]              NVARCHAR (MAX)  NULL,
		[LeaNcesIdentifier]                       NVARCHAR (MAX)  NULL,
		[LeaStateIdentifier]                      NVARCHAR (MAX)  NULL,
		[ManagementOrganizationType]              NVARCHAR (MAX)  NULL,
		[IMPROVEMENTSTATUS]                       NVARCHAR (MAX)  NULL,
		[PERSISTENTLYDANGEROUSSTATUS]             NVARCHAR (MAX)  NULL,
		[CHARTERSCHOOLMANAGERORGANIZATION]        NVARCHAR (MAX)  NULL,
		[CHARTERSCHOOLUPDATEDMANAGERORGANIZATION] NVARCHAR (MAX)  NULL,
		[STATEPOVERTYDESIGNATION]                 NVARCHAR (50)   NULL,
		[SCHOOLIMPROVEMENTFUNDS]                  INT             NULL,
		[EconomicallyDisadvantagedStudentCount]   INT             NULL,
		[McKinneyVentoSubgrantRecipient]          VARCHAR (50)    NULL,
		[ProgressAchievingEnglishLanguage]        NVARCHAR (MAX)  NULL,
		[StateDefinedStatus]                      NVARCHAR (MAX)  NULL,
		[REAPAlternativeFundingStatus]            NVARCHAR (50)   NULL,
		[GraduationRate]                          NVARCHAR (50)   NULL,
		[GunFreeStatus]                           NVARCHAR (50)   NULL,
		[FederalFundAllocationType]               NVARCHAR (20)   NULL,
		[FederalProgramCode]                      NVARCHAR (20)   NULL,
		[FederalFundAllocated]                    INT             NULL,
		[ComprehensiveAndTargetedSupportCode]     NVARCHAR (50)   NULL,
		[ComprehensiveSupportCode]                NVARCHAR (50)   NULL,
		[TargetedSupportCode]                     NVARCHAR (50)   NULL,
		[ComprehensiveSupportImprovementCode]	  NVARCHAR (50)   NULL,
		[TargetedSupportImprovementCode] 		  NVARCHAR (50)   NULL,
		[AdditionalTargetedSupportandImprovementCode] NVARCHAR (50)   NULL,
		[AppropriationMethodCode]				  NVARCHAR (50)   NULL,
		CONSTRAINT [PK_ReportEDFactsOrganizationCounts] PRIMARY KEY CLUSTERED ([ReportEDFactsOrganizationCountId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsOrganizationCounts].[IX_ReportEDFactsOrganizationCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_ReportEDFactsOrganizationCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]
		ON [RDS].[ReportEDFactsOrganizationCounts]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsOrganizationCounts].[IX_ReportEDFactsOrganizationCounts_ReportCode_ReportYear_ReportLevel_Grade_Organization]...';


	
	CREATE NONCLUSTERED INDEX [IX_ReportEDFactsOrganizationCounts_ReportCode_ReportYear_ReportLevel_Grade_Organization]
		ON [RDS].[ReportEDFactsOrganizationCounts]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC)
		INCLUDE([GRADELEVEL], [OrganizationId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[ReportEDFactsOrganizationStatusCounts]...';


	
	CREATE TABLE [RDS].[ReportEDFactsOrganizationStatusCounts] (
		[ReportEDFactsOrganizationStatusCountId] INT             IDENTITY (1, 1) NOT NULL,
		[Categories]                             NVARCHAR (300)  NULL,
		[CategorySetCode]                        NVARCHAR (40)   NULL,
		[ReportCode]                             NVARCHAR (40)   NOT NULL,
		[ReportLevel]                            NVARCHAR (40)   NOT NULL,
		[ReportYear]                             NVARCHAR (40)   NOT NULL,
		[StateANSICode]                          NVARCHAR (100)  NOT NULL,
		[StateCode]                              NVARCHAR (100)  NOT NULL,
		[StateName]                              NVARCHAR (500)  NOT NULL,
		[OrganizationId]                         INT             NOT NULL,
		[OrganizationName]                       NVARCHAR (1000) NOT NULL,
		[OrganizationNcesId]                     NVARCHAR (100)  NOT NULL,
		[OrganizationStateId]                    NVARCHAR (100)  NOT NULL,
		[ParentOrganizationStateId]              NVARCHAR (100)  NULL,
		[RACE]                                   NVARCHAR (50)   NULL,
		[DISABILITY]                             NVARCHAR (50)   NULL,
		[LEPSTATUS]                              NVARCHAR (50)   NULL,
		[ECODISSTATUS]                           NVARCHAR (50)   NULL,
		[INDICATORSTATUS]                        NVARCHAR (50)   NULL,
		[STATEDEFINEDSTATUSCODE]                 NVARCHAR (50)   NULL,
		[OrganizationStatusCount]                INT             NOT NULL,
		[STATEDEFINEDCUSTOMINDICATORCODE]        NVARCHAR (50)   NULL,
		[TableTypeAbbrv]                         NVARCHAR (100)  NULL,
		[TotalIndicator]                         NVARCHAR (50)   NULL,
		[BASISOFEXIT]                            NVARCHAR (50)   NULL,
		[EDUCENV]                                NVARCHAR (50)   NULL,
		[HOMELESSNIGHTTIMERESIDENCE]             NVARCHAR (50)   NULL,
		[HOMELESSSTATUS]                         NVARCHAR (50)   NULL,
		[HOMELESSUNACCOMPANIEDYOUTHSTATUS]       NVARCHAR (50)   NULL,
		[MIGRANTSTATUS]                          NVARCHAR (50)   NULL,
		[MILITARYCONNECTEDSTATUS]                NVARCHAR (50)   NULL,
		[SEX]                                    NVARCHAR (50)   NULL,
		[INDICATORSTATUSTYPECODE]                NVARCHAR (50)   NULL,
		CONSTRAINT [PK_ReportEDFactsOrganizationStatusCounts] PRIMARY KEY CLUSTERED ([ReportEDFactsOrganizationStatusCountId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsOrganizationStatusCounts].[IX_FactOrganizationStatusCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_FactOrganizationStatusCounts_ReportCode_ReportYear_ReportLevel_CategorySetCode]
		ON [RDS].[ReportEDFactsOrganizationStatusCounts]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [Categories] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[ReportEDFactsSchoolPerformanceIndicators]...';


	
	CREATE TABLE [RDS].[ReportEDFactsSchoolPerformanceIndicators] (
		[ReportEDFactsSchoolPerformanceIndicatorId] INT             NOT NULL,
		[Categories]                                NVARCHAR (300)  NULL,
		[CategorySetCode]                           NVARCHAR (40)   NULL,
		[ReportCode]                                NVARCHAR (40)   NOT NULL,
		[ReportLevel]                               NVARCHAR (40)   NOT NULL,
		[ReportYear]                                NVARCHAR (40)   NOT NULL,
		[StateANSICode]                             NVARCHAR (100)  NOT NULL,
		[StateCode]                                 NVARCHAR (100)  NOT NULL,
		[StateName]                                 NVARCHAR (500)  NOT NULL,
		[OrganizationId]                            INT             NOT NULL,
		[OrganizationName]                          NVARCHAR (1000) NOT NULL,
		[OrganizationNcesId]                        NVARCHAR (100)  NOT NULL,
		[OrganizationStateId]                       NVARCHAR (100)  NOT NULL,
		[ParentOrganizationStateId]                 NVARCHAR (100)  NULL,
		[RACE]                                      NVARCHAR (50)   NULL,
		[DISABILITY]                                NVARCHAR (50)   NULL,
		[LEPSTATUS]                                 NVARCHAR (50)   NULL,
		[ECODISSTATUS]                              NVARCHAR (50)   NULL,
		[SEX]                                       NVARCHAR (50)   NULL,
		[INDICATORSTATUS]                           NVARCHAR (50)   NULL,
		[STATEDDEFINEDSTATUSCODE]                   NVARCHAR (50)   NULL,
		CONSTRAINT [PK_ReportEDFactsSchoolPerformanceIndicators] PRIMARY KEY CLUSTERED ([ReportEDFactsSchoolPerformanceIndicatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [RDS].[ReportEDFactsSchoolPerformanceIndicators].[IX_ReportEDFactsSchoolPerformanceIndicators_ReportCode_ReportYear_ReportLevel_CategorySetCode]...';


	
	CREATE NONCLUSTERED INDEX [IX_ReportEDFactsSchoolPerformanceIndicators_ReportCode_ReportYear_ReportLevel_CategorySetCode]
		ON [RDS].[ReportEDFactsSchoolPerformanceIndicators]([ReportCode] ASC, [ReportYear] ASC, [ReportLevel] ASC, [CategorySetCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [RDS].[ToggleAssessments]...';


	
	CREATE TABLE [RDS].[ToggleAssessments] (
		[ToggleAssessmentId]     INT            IDENTITY (1, 1) NOT NULL,
		[AssessmentName]         NVARCHAR (100) NOT NULL,
		[AssessmentType]         NVARCHAR (200) NOT NULL,
		[AssessmentTypeCode]     NVARCHAR (100) NOT NULL,
		[EOG]                    NVARCHAR (50)  NOT NULL,
		[Grade]                  NVARCHAR (2)   NOT NULL,
		[PerformanceLevels]      NVARCHAR (2)   NOT NULL,
		[ProficientOrAboveLevel] NVARCHAR (2)   NOT NULL,
		[Subject]                NVARCHAR (50)  NOT NULL,
		CONSTRAINT [PK_ToggleAssessments] PRIMARY KEY CLUSTERED ([ToggleAssessmentId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleQuestionOptions]...';


	
	CREATE TABLE [RDS].[ToggleQuestionOptions] (
		[ToggleQuestionOptionId] INT            IDENTITY (1, 1) NOT NULL,
		[OptionSequence]         INT            NOT NULL,
		[OptionText]             NVARCHAR (MAX) NOT NULL,
		[ToggleQuestionId]       INT            NOT NULL,
		CONSTRAINT [PK_ToggleQuestionOptions] PRIMARY KEY CLUSTERED ([ToggleQuestionOptionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleQuestions]...';


	
	CREATE TABLE [RDS].[ToggleQuestions] (
		[ToggleQuestionId]       INT            IDENTITY (1, 1) NOT NULL,
		[EmapsQuestionAbbrv]     NVARCHAR (50)  NOT NULL,
		[ParentToggleQuestionId] INT            NULL,
		[QuestionSequence]       INT            NOT NULL,
		[QuestionText]           NVARCHAR (MAX) NOT NULL,
		[ToggleQuestionTypeId]   INT            NOT NULL,
		[ToggleSectionId]        INT            NOT NULL,
		CONSTRAINT [PK_ToggleQuestions] PRIMARY KEY CLUSTERED ([ToggleQuestionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleQuestionTypes]...';


	
	CREATE TABLE [RDS].[ToggleQuestionTypes] (
		[ToggleQuestionTypeId]   INT            IDENTITY (1, 1) NOT NULL,
		[IsMultiOption]          BIT            NOT NULL,
		[ToggleQuestionTypeCode] NVARCHAR (50)  NOT NULL,
		[ToggleQuestionTypeName] NVARCHAR (500) NOT NULL,
		CONSTRAINT [PK_ToggleQuestionTypes] PRIMARY KEY CLUSTERED ([ToggleQuestionTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleResponses]...';


	
	CREATE TABLE [RDS].[ToggleResponses] (
		[ToggleResponseId]       INT            IDENTITY (1, 1) NOT NULL,
		[ResponseValue]          NVARCHAR (MAX) NOT NULL,
		[ToggleQuestionId]       INT            NOT NULL,
		[ToggleQuestionOptionId] INT            NULL,
		CONSTRAINT [PK_ToggleResponses] PRIMARY KEY CLUSTERED ([ToggleResponseId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleSections]...';


	
	CREATE TABLE [RDS].[ToggleSections] (
		[ToggleSectionId]               INT             IDENTITY (1, 1) NOT NULL,
		[EmapsParentSurveySectionAbbrv] NVARCHAR (50)   NULL,
		[EmapsSurveySectionAbbrv]       NVARCHAR (50)   NOT NULL,
		[SectionName]                   NVARCHAR (2000) NOT NULL,
		[SectionSequence]               INT             NOT NULL,
		[SectionTitle]                  NVARCHAR (500)  NOT NULL,
		[ToggleSectionTypeId]           INT             NOT NULL,
		CONSTRAINT [PK_ToggleSections] PRIMARY KEY CLUSTERED ([ToggleSectionId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [RDS].[ToggleSectionTypes]...';


	
	CREATE TABLE [RDS].[ToggleSectionTypes] (
		[ToggleSectionTypeId]  INT            IDENTITY (1, 1) NOT NULL,
		[EmapsSurveyTypeAbbrv] NVARCHAR (50)  NOT NULL,
		[SectionTypeName]      NVARCHAR (500) NOT NULL,
		[SectionTypeSequence]  INT            NOT NULL,
		[SectionTypeShortName] NVARCHAR (100) NOT NULL,
		CONSTRAINT [PK_ToggleSectionTypes] PRIMARY KEY CLUSTERED ([ToggleSectionTypeId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Modifying Table [Staging].[CharterSchoolManagementOrganization]...';


	
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolManagementOrganization].[CharterSchoolManagementOrganization_Identifier_EIN]', N'CharterSchoolManagementOrganizationOrganizationIdentifierEIN';
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolManagementOrganization].[CharterSchoolManagementOrganization_Type]', N'CharterSchoolManagementOrganizationType';
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolManagementOrganization].[CharterSchoolManagementOrganization_Name]', N'CharterSchoolManagementOrganizationOrganizationName';
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolManagementOrganization].[CharterSchoolManagementOrganizationId]', N'CharterSchoolManagementOrganizationOrganizationId';

	-- IF EXISTS (SELECT *
    --             FROM INFORMATION_SCHEMA.COLUMNS
    --             WHERE TABLE_SCHEMA = 'Staging'
	-- 			AND TABLE_NAME = 'CharterSchoolManagementOrganization' 
	-- 			AND COLUMN_NAME = 'DataCollectionId' 
	-- 		)
    -- BEGIN
    --    ALTER TABLE Staging.CharterSchoolManagementOrganization DROP COLUMN DataCollectionId;
    -- END;


	CREATE TABLE [Staging].[tmp_ms_xx_CharterSchoolManagementOrganization] (
		[Id]                               								INT            IDENTITY (1, 1) NOT NULL,
		[CharterSchoolManagementOrganizationOrganizationIdentifierEIN]  NVARCHAR (50)  NULL,
		[CharterSchoolManagementOrganizationType] 						VARCHAR (100)  NULL,
		[CharterSchoolManagementOrganizationOrganizationName]			VARCHAR (100)  NULL,
		[OrganizationIdentifier]							  			NVARCHAR (50)  NULL,
		[SchoolYear]				                                    SMALLINT       NULL,
		[RecordStartDateTime]			            					DATETIME       NULL,
		[RecordEndDateTime]             			            		DATETIME       NULL,
		[DataCollectionName]               								NVARCHAR (100) NULL,
		[CharterSchoolManagementOrganizationOrganizationId] 			INT            NOT NULL,
		[CharterSchoolId]                  								INT            NOT NULL,
		[RunDateTime]                      								DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_CharterSchoolManagementOrganization] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);

	DROP TABLE [Staging].[CharterSchoolManagementOrganization];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_CharterSchoolManagementOrganization]', N'CharterSchoolManagementOrganization';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_CharterSchoolManagementOrganization]', N'PK_CharterSchoolManagementOrganization', N'OBJECT';


	
	PRINT N'Modify Table [Staging].[CharterSchoolAuthorizer]...';


	
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolAuthorizer].[CharterSchoolAuthorizer_Identifier_State]', N'CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea';
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolAuthorizer].[CharterSchoolAuthorizer_Name]', N'CharterSchoolAuthorizingOrganizationOrganizationName';
	-- EXECUTE sp_rename N'[Staging].[CharterSchoolAuthorizer].[CharterSchoolAuthorizerOrganizationId]', N'CharterSchoolAuthorizingOrganizationOrganizationId';

	-- IF EXISTS (SELECT *
    --             FROM INFORMATION_SCHEMA.COLUMNS
    --             WHERE TABLE_SCHEMA = 'Staging'
	-- 			AND TABLE_NAME = 'CharterSchoolAuthorizer' 
	-- 			AND COLUMN_NAME = 'DataCollectionId' 
	-- 		)
    -- BEGIN
    --    ALTER TABLE Staging.CharterSchoolAuthorizer DROP COLUMN DataCollectionId;
    -- END;

	CREATE TABLE [Staging].[tmp_ms_xx_CharterSchoolAuthorizer] (
		[Id]                               									INT            IDENTITY (1, 1) NOT NULL,
		[CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea]  	NVARCHAR (50)  NULL,
		[CharterSchoolAuthorizerType]										VARCHAR (100)  NULL,
		[CharterSchoolAuthorizingOrganizationOrganizationName]				VARCHAR (100)  NULL,
		[SchoolYear]					                                    SMALLINT       NULL,
		[RecordStartDateTime]                       						DATETIME       NULL,
		[RecordEndDateTime]                         						DATETIME       NULL,
		[DataCollectionName]               									NVARCHAR (100) NULL,
		[CharterSchoolId]                  									INT            NULL,
		[CharterSchoolAuthorizingOrganizationOrganizationId] 				INT            NULL,
		[RunDateTime]                      									DATETIME       NULL,
		CONSTRAINT [tmp_ms_xx_constraint_PK_CharterSchoolAuthorizer] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	DROP TABLE [Staging].[CharterSchoolAuthorizer];

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_CharterSchoolAuthorizer]', N'CharterSchoolAuthorizer';

	EXECUTE sp_rename N'[Staging].[tmp_ms_xx_constraint_PK_CharterSchoolAuthorizer]', N'PK_CharterSchoolAuthorizer', N'OBJECT';


	
	PRINT N'Creating Table [Staging].[DataCollection]...';


	
	CREATE TABLE [Staging].[DataCollection] (
		[Id]                                   INT           IDENTITY (1, 1) NOT NULL,
		[SourceSystemDataCollectionIdentifier] INT           NULL,
		[SourceSystemName]                     VARCHAR (100) NULL,
		[DataCollectionName]                   VARCHAR (100) NULL,
		[DataCollectionDescription]            VARCHAR (800) NULL,
		[DataCollectionOpenDate]               DATETIME      NULL,
		[DataCollectionCloseDate]              DATETIME      NULL,
		[DataCollectionAcademicSchoolYear]     VARCHAR (50)  NULL,
		[DataCollectionSchoolYear]             VARCHAR (50)  NULL,
		CONSTRAINT [PK_DataCollection] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[EarlyLearningChildOutcomeSummary]...';


	
	CREATE TABLE [Staging].[EarlyLearningChildOutcomeSummary] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[SchoolYear]                                     SMALLINT       NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[COSRatingA]                                     NVARCHAR (100) NULL,
		[COSProgressAIndicator]                          BIT            NULL,
		[COSRatingB]                                     NVARCHAR (100) NULL,
		[COSProgressBIndicator]                          BIT            NULL,
		[COSRatingC]                                     NVARCHAR (100) NULL,
		[COSProgresscIndicator]                          BIT            NULL,
		[EarlyLearningOutcomeTimePoint]                  NVARCHAR (100) NULL,
		[EarlyLearningOutcomeDate]                       DATE           NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		CONSTRAINT [PK_EarlyLearningChildOutcomeSummary] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[EarlyLearningOrganization]...';


	
	CREATE TABLE [Staging].[EarlyLearningOrganization] (
		[EarlyLearningOrganizationIdentifierSea]	NVARCHAR (50)  NULL,
		[WebSiteAddress]			                NVARCHAR (300) NULL,
		[OperationalStatusEffectiveDate] 			DATETIME       NULL,
		[OrganizationName]                			NVARCHAR (100) NULL,
		[OrganizationOperationalStatus]   			NVARCHAR (100) NULL,
		[DataCollectionName]              			NVARCHAR (100) NULL,
		[OrganizationId]                  			INT            NULL,
		[OrganizationOperationalStatusId] 			INT            NULL
	)
	WITH (DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [Staging].[FipsCounty]...';


	
	CREATE TABLE [Staging].[FipsCounty] (
		[State]          VARCHAR (50) NULL,
		[StateFipsCode]  VARCHAR (50) NULL,
		[CountyFipsCode] VARCHAR (50) NULL,
		[CountyName]     VARCHAR (50) NULL
	);


	
	PRINT N'Creating Table [Staging].[IdeaDisabilityType]...';


	
	CREATE TABLE [Staging].[IdeaDisabilityType] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[SchoolYear]                                     SMALLINT       NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[IdeaDisabilityType]                             NVARCHAR (100) NULL,
		[IsPrimaryDisability]							 BIT NULL,	
		[IsSecondaryDisability]							 BIT NULL,	
		[RecordStartDateTime]                            DATETIME       NULL,
		[RecordEndDateTime]                              DATETIME       NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		CONSTRAINT [PK_IdeaDisabilityType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[IndividualizedProgram]...';


	
	CREATE TABLE [Staging].[IndividualizedProgram] (
		[Id]                                               INT            IDENTITY (1, 1) NOT NULL,
		[SchoolYear]                                       SMALLINT       NULL,
		[StudentIdentifierState]                           NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                   NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                       NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                          NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                       NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram]   NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                              NVARCHAR (50)  NULL,
		[IndividualizedProgramServicePlanDate]             DATE           NULL,
		[IndividualizedProgramServicePlanReevaluationDate] DATE           NULL,
		[IndividualizedProgramServicePlanEndDate]          DATE           NULL,
		[IndividualizedProgramDate]                        DATE           NULL,
		[EligibilityEvaluationDateInitial]                 DATE           NULL,
		[StudentSupportServiceType]                        NVARCHAR (100) NULL,
		[ConsentToEvaluationDate]                          DATE           NULL,
		[ConsentToEvaluationIndicator]                     BIT            NULL,
		[IndividualizedProgramType]                        NVARCHAR (100) NULL,
		[DataCollectionName]                               NVARCHAR (100) NULL,
		CONSTRAINT [PK_IndividualizedProgram] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[K12PersonRace]...';


	
	CREATE TABLE [Staging].[K12PersonRace] (
		[Id]                                             INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]                         NVARCHAR (40)  NULL,
		[LeaIdentifierSeaAccountability]                 NVARCHAR (50)  NULL,
		[LeaIdentifierSeaAttendance]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaFunding]                        NVARCHAR (50)  NULL,
		[LeaIdentifierSeaGraduation]                     NVARCHAR (50)  NULL,
		[LeaIdentifierSeaIndividualizedEducationProgram] NVARCHAR (50)  NULL,
		[SchoolIdentifierSea]                            NVARCHAR (50)  NULL,
		[RaceType]                                       VARCHAR (100)  NULL,
		[SchoolYear]                                     SMALLINT 		NULL,
		[RecordStartDateTime]                            DATETIME       NULL,
		[RecordEndDateTime]                              DATETIME       NULL,
		[DataCollectionName]                             NVARCHAR (100) NULL,
		[PersonId]                                       INT            NULL,
		[PersonDemographicRaceId]                        INT            NULL,
		[OrganizationID_LEA]                             INT            NULL,
		[OrganizationID_School]                          INT            NULL,
		[RefRaceId]                                      INT            NULL,
		[RunDateTime]                                    DATETIME       NULL,
		CONSTRAINT [PK_K12PersonRace] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
	);


	
	PRINT N'Creating Table [Staging].[PsPersonRace]...';


	
	CREATE TABLE [Staging].[PsPersonRace] (
		[Id]                          INT            IDENTITY (1, 1) NOT NULL,
		[StudentIdentifierState]      VARCHAR (100)  NULL,
		[InstitutionIpedsUnitId]      VARCHAR (100)  NULL,
		[RaceType]                    VARCHAR (100)  NULL,
		[AcademicTermDesignator]      VARCHAR (100)  NULL,
		[SchoolYear]                  SMALLINT 		 NULL,
		[RecordStartDateTime]         DATETIME       NULL,
		[RecordEndDateTime]           DATETIME       NULL,
		[DataCollectionName]          NVARCHAR (100) NULL,
		[PersonId]                    INT            NULL,
		[PersonDemographicRaceId]     INT            NULL,
		[OrganizationId]              INT            NULL,
		[RefRaceId]                   INT            NULL,
		[RefAcademicTermDesignatorId] INT            NULL,
		[RunDateTime]                 DATETIME       NULL,
		CONSTRAINT [PK_PsPersonRace] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Index [Staging].[PsPersonRace].[IX_PsPersonRace_InstitutionIpedsUnitId]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsPersonRace_InstitutionIpedsUnitId]
		ON [Staging].[PsPersonRace]([InstitutionIpedsUnitId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[PsPersonRace].[IX_PsPersonRace_PersonDemographicRaceId]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsPersonRace_PersonDemographicRaceId]
		ON [Staging].[PsPersonRace]([PersonDemographicRaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[PsPersonRace].[IX_PsPersonRace_RecordStartDateTime]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsPersonRace_RecordStartDateTime]
		ON [Staging].[PsPersonRace]([RecordStartDateTime] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[PsPersonRace].[IX_PsPersonRace_RefAcademicTermDesignatorId]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsPersonRace_RefAcademicTermDesignatorId]
		ON [Staging].[PsPersonRace]([RefAcademicTermDesignatorId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[PsPersonRace].[IX_PsPersonRace_RefRaceId]...';


	
	CREATE NONCLUSTERED INDEX [IX_PsPersonRace_RefRaceId]
		ON [Staging].[PsPersonRace]([RefRaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Table [Staging].[SchoolPerformanceIndicators]...';


	
	CREATE TABLE [Staging].[SchoolPerformanceIndicators] (
		[Id]                                           INT            IDENTITY (1, 1) NOT NULL,
		[SchoolIdentifierSea]                          NVARCHAR (50)  NOT NULL,
		[SchoolYear]                                   SMALLINT	  	  NULL,
		[SchoolPerformanceIndicatorCategory]           VARCHAR (100)  NULL,
		[SchoolPerformanceIndicatorStateDefinedStatus] VARCHAR (100)  NULL,
		[SubgroupElementName]                          VARCHAR (100)  NULL,
		[SubgroupCode]                                 VARCHAR (100)  NULL,
		[SchoolPerformanceIndicatorType]               VARCHAR (100)  NULL,
		[SchoolQualityOrStudentSuccessIndicatorType]   VARCHAR (100)  NULL,
		[RecordStartDateTime]                          DATETIME       NULL,
		[RecordEndDateTime]                            DATETIME       NULL,
		[DataCollectionName]                           NVARCHAR (100) NULL,
		CONSTRAINT [PK_SchoolPerformanceIndicators] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[SchoolPerformanceIndicatorStateDefinedStatus]...';


	
	CREATE TABLE [Staging].[SchoolPerformanceIndicatorStateDefinedStatus] (
		[Id]                                                      INT            IDENTITY (1, 1) NOT NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusCode]        NVARCHAR (50)  NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusDescription] NVARCHAR (100) NULL,
		[SchoolPerformanceIndicatorStateDefinedStatusDefinition]  NVARCHAR (MAX) NULL,
		[RefSchoolPerformanceIndicatorStateDefinedStatusId]       INT            NULL,
		[RunDateTime]                                             DATETIME       NULL,
		CONSTRAINT [PK_SchoolPerformanceIndicatorStateDefinedStatus] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	PRINT N'Creating Table [Staging].[SchoolQualityOrStudentSuccessIndicatorType]...';


	
	CREATE TABLE [Staging].[SchoolQualityOrStudentSuccessIndicatorType] (
		[Id]                                                    INT            IDENTITY (1, 1) NOT NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeCode]        NVARCHAR (50)  NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeDescription] NVARCHAR (100) NULL,
		[SchoolQualityOrStudentSuccessIndicatorTypeDefinition]  NVARCHAR (MAX) NULL,
		[RefSchoolQualityOrStudentSuccessIndicatorTypeId]       INT            NULL,
		[RunDateTime]                                           DATETIME       NULL,
		CONSTRAINT [PK_ScoolQualityOrStudentSuccessIndicatorType] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
	);


	
	
	PRINT N'Altering Columns in Table [Staging].[K12StaffAssignment]...';


	
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[Personnel_Identifier_State]', N'StaffMemberIdentifierState';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[LEA_Identifier_State]', N'LeaIdentifierSea';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[School_Identifier_State]', N'SchoolIdentifierSea';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[LastName]', N'LastOrSurname';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[InexperiencedStatus]', N'EdFactsTeacherInexperiencedStatus';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[OutOfFieldStatus]', N'EDFactsTeacherOutOfFieldStatus';
	EXECUTE sp_rename N'[Staging].[K12StaffAssignment].[CredentialType]', N'TeachingCredentialType';


	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN StaffMemberIdentifierState NVARCHAR(40) NULL;

	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN LeaIdentifierSea NVARCHAR(50) NULL;

	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN SchoolIdentifierSea NVARCHAR(50) NULL;

	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN SchoolYear SMALLINT NULL;

	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN RecordStartDateTime Datetime NULL;

	ALTER TABLE [Staging].[K12StaffAssignment] 
	ALTER COLUMN RecordEndDateTime Datetime NULL;


	
	PRINT N'Altering Primary Key [RDS].[PK_DimAges]...';


	
	ALTER INDEX [PK_DimAges]
		ON [RDS].[DimAges] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimAges].[IX_DimAges_AgeCode]...';


	
	ALTER INDEX [IX_DimAges_AgeCode]
		ON [RDS].[DimAges] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimAges].[IX_DimAges_AgeValue]...';


	
	ALTER INDEX [IX_DimAges_AgeValue]
		ON [RDS].[DimAges] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [RDS].[PK_DimFactType_DimensionTables]...';


	
	ALTER INDEX [PK_DimFactType_DimensionTables]
		ON [RDS].[DimFactType_DimensionTables] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [RDS].[PK_DimFactTypes]...';


	
	ALTER INDEX [PK_DimFactTypes]
		ON [RDS].[DimFactTypes] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [Staging].[PK_OrganizationFederalFunding]...';


	
	ALTER INDEX [PK_OrganizationFederalFunding]
		ON [Staging].[OrganizationFederalFunding] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [Staging].[PK_SourceSystemReferenceData]...';


	
	ALTER INDEX [PK_SourceSystemReferenceData]
		ON [Staging].[SourceSystemReferenceData] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Primary Key [Staging].[PK_ValidationErrors]...';


	
	ALTER INDEX [PK_ValidationErrors]
		ON [Staging].[ValidationErrors] REBUILD WITH(DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimDates].[IX_DimDates_DateValue]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimDates_DateValue]
		ON [RDS].[DimDates]([DateValue] ASC)
		INCLUDE([DimDateId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimDates].[IX_DimDates_SubmissionYear]...';


	
	ALTER INDEX [IX_DimDates_SubmissionYear]
		ON [RDS].[DimDates] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimFactTypes].[IX_DimFactTypes_FactTypeCode]...';


	
	ALTER INDEX [IX_DimFactTypes_FactTypeCode]
		ON [RDS].[DimFactTypes] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Altering Index [RDS].[DimK12ProgramTypes].[IX_DimK12ProgramTypes_ProgramTypeCode]...';


	
	ALTER INDEX [IX_DimK12ProgramTypes_ProgramTypeCode]
		ON [RDS].[DimK12ProgramTypes] REBUILD WITH(FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[BridgeK12ProgramParticipationRaces].[IXFK_BridgeK12ProgramParticipationRaces_RaceId]...';


	
	CREATE NONCLUSTERED INDEX [IXFK_BridgeK12ProgramParticipationRaces_RaceId]
		ON [RDS].[BridgeK12ProgramParticipationRaces]([RaceId] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [RDS].[DimDataCollections].[IX_DimDataCollections_DataCollectionSchoolYear]...';


	
	CREATE NONCLUSTERED INDEX [IX_DimDataCollections_DataCollectionSchoolYear]
		ON [RDS].[DimDataCollections]([DataCollectionSchoolYear] ASC) WITH (FILLFACTOR = 100, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Index [Staging].[SourceSystemReferenceData].[IX_SourceSystemReferenceData_Unique]...';


	
	CREATE UNIQUE NONCLUSTERED INDEX [IX_SourceSystemReferenceData_Unique]
		ON [Staging].[SourceSystemReferenceData]([SchoolYear] DESC, [TableName] ASC, [TableFilter] ASC, [InputCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId] DEFAULT ((-1)) FOR [FactAeStudentEnrollmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeAeStudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgeAeStudentEnrollmentRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollmentId] DEFAULT ((-1)) FOR [FactK12StudentEnrollmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId] DEFAULT ((-1)) FOR [IdeaDisabilityTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations]
		ADD CONSTRAINT [DF_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId] DEFAULT ((-1)) FOR [FactK12StudentAssessmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations]
		ADD CONSTRAINT [DF_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId] DEFAULT ((-1)) FOR [AssessmentAccommodationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_CONSTRAINT [DF_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces]
		ADD CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentAssessmentRaces_FactK12StudentAssessmentId] DEFAULT ((-1)) FOR [FactK12StudentAssessmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_CONSTRAINT [DF_BridgeK12StudentAssessmentAccommodations_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces]
		ADD CONSTRAINT [DF_CONSTRAINT [DF_BridgeK12StudentAssessmentRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentCourseSectionRaces_FactK12StudentCourseSectionId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentCourseSectionRaces_FactK12StudentCourseSectionId] DEFAULT ((-1)) FOR [FactK12StudentCourseSectionId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentCourseSectionRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentCourseSectionRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSectionId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes]
		ADD CONSTRAINT [DF_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSectionId] DEFAULT ((-1)) FOR [FactK12StudentCourseSectionId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentCourseSectionsCipCodes_CipCodeId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes]
		ADD CONSTRAINT [DF_BridgeK12StudentCourseSectionsCipCodes_CipCodeId] DEFAULT ((-1)) FOR [CipCodeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplineId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplineId] DEFAULT ((-1)) FOR [FactK12StudentDisciplineId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentDisciplineRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentDisciplineRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId] DEFAULT ((-1)) FOR [FactK12StudentEconomicDisadvantageId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEconomicDisadvantageRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentEconomicDisadvantageRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId] DEFAULT ((-1)) FOR [PersonAddressId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollmentId] DEFAULT ((-1)) FOR [FactK12StudentEnrollmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes]
		ADD CONSTRAINT [DF_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId] DEFAULT ((-1)) FOR [FactSpecialEducationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes]
		ADD CONSTRAINT [DF_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId] DEFAULT ((-1)) FOR [IdeaDisabilityTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeSpecialEducationRaces_FactSpecialEducationId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationRaces]
		ADD CONSTRAINT [DF_BridgeSpecialEducationRaces_FactSpecialEducationId] DEFAULT ((-1)) FOR [FactSpecialEducationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeSpecialEducationRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationRaces]
		ADD CONSTRAINT [DF_BridgeSpecialEducationRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_DimCompetencyDefinitionsCompetencyDefinitionValudStartDate]...';


	
	ALTER TABLE [RDS].[DimCompetencyDefinitions]
		ADD CONSTRAINT [DF_DimCompetencyDefinitionsCompetencyDefinitionValudStartDate] DEFAULT (getdate()) FOR [CompetencyDefinitionValidStartDate];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_SchoolYearId] DEFAULT ((-1)) FOR [SchoolYearId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_SeaId] DEFAULT ((-1)) FOR [SeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_IeuId] DEFAULT ((-1)) FOR [IeuId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_LeaId] DEFAULT ((-1)) FOR [LeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_K12SchoolId] DEFAULT ((-1)) FOR [K12SchoolId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId] DEFAULT ((-1)) FOR [AcademicTermDesignatorId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId] DEFAULT ((-1)) FOR [AssessmentAdministrationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentId] DEFAULT ((-1)) FOR [AssessmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId] DEFAULT ((-1)) FOR [AssessmentSubtestId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId] DEFAULT ((-1)) FOR [CompetencyDefinitionId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId] DEFAULT ((-1)) FOR [GradeLevelWhenAssessedId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_IdeaStatusId] DEFAULT ((-1)) FOR [IdeaStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_K12DemographicId] DEFAULT ((-1)) FOR [K12DemographicId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAssessmentsResultAggregates_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates]
		ADD CONSTRAINT [DF_FactK12StudentAssessmentsResultAggregates_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_SchoolYearId] DEFAULT ((-1)) FOR [SchoolYearId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_FactTypeId] DEFAULT ((-1)) FOR [FactTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_SeaId] DEFAULT ((-1)) FOR [SeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_LeaId] DEFAULT ((-1)) FOR [LeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_K12SchoolId] DEFAULT ((-1)) FOR [K12SchoolId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_K12StudentId] DEFAULT ((-1)) FOR [K12StudentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_AttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_AttendanceId] DEFAULT ((-1)) FOR [AttendanceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentAttendanceRates_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates]
		ADD CONSTRAINT [DF_FactK12StudentAttendanceRates_K12DemographicId] DEFAULT ((-1)) FOR [K12DemographicId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_SchoolYearId] DEFAULT ((-1)) FOR [SchoolYearId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_CountDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_CountDateId] DEFAULT ((-1)) FOR [CountDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_DataCollectionId] DEFAULT ((-1)) FOR [DataCollectionId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) FOR [EconomicallyDisadvantagedStatusId];


	
	-- PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12StudentStatusId]...';


	-- 
	-- ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
	-- 	ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12StudentStatusId] DEFAULT ((-1)) FOR [K12StudentStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12StudentId] DEFAULT ((-1)) FOR [K12StudentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12DemographicId] DEFAULT ((-1)) FOR [K12DemographicId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_LeaId] DEFAULT ((-1)) FOR [LeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_K12SchoolId] DEFAULT ((-1)) FOR [K12SchoolId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_SeaId] DEFAULT ((-1)) FOR [SeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_IeuId] DEFAULT ((-1)) FOR [IeuId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_NcesSideVantageBeginYearDateId] DEFAULT ((-1)) FOR [NcesSideVintageBeginYearDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_NcesSideVantageEndYearDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_NcesSideVantageEndYearDateId] DEFAULT ((-1)) FOR [NcesSideVintageEndYearDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactK12StudentEconomicDisadvantages_PersonAddressId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages]
		ADD CONSTRAINT [DF_FactK12StudentEconomicDisadvantages_PersonAddressId] DEFAULT ((-1)) FOR [PersonAddressId];


	
	PRINT N'Creating Default Constraint unnamed constraint on [RDS].[FactSchoolPerformanceIndicators]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators]
		ADD DEFAULT ((1)) FOR [OrganizationCount];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_SchoolYearId] DEFAULT ((-1)) FOR [SchoolYearId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_DataCollectionId] DEFAULT ((-1)) FOR [DataCollectionId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IeuId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IeuId] DEFAULT ((-1)) FOR [IeuId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_SeaId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_SeaId] DEFAULT ((-1)) FOR [SeaId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryBaselineId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryBaselineId] DEFAULT ((-1)) FOR [ChildOutcomeSummaryBaselineId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ConsentToEvaluationDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ConsentToEvaluationDateId] DEFAULT ((-1)) FOR [ConsentToEvaluationDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EnrollmentExitDateId] DEFAULT ((-1)) FOR [EnrollmentExitDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryAtExitId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryAtExitId] DEFAULT ((-1)) FOR [ChildOutcomeSummaryAtExitId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId] DEFAULT ((-1)) FOR [ChildOutcomeSummaryDateAtExitId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId] DEFAULT ((-1)) FOR [ChildOutcomeSummaryDateBaselineId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_DisabilityStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_DisabilityStatusId] DEFAULT ((-1)) FOR [DisabilityStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_CteStatusId] DEFAULT ((-1)) FOR [CteStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EntryGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EntryGradeLevelId] DEFAULT ((-1)) FOR [EntryGradeLevelId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EnglishLearnerStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EnglishLearnerStatusId] DEFAULT ((-1)) FOR [EnglishLearnerStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EconomicallyDisadvantagedStatusId] DEFAULT ((-1)) FOR [EconomicallyDisadvantagedStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EnrollmentEntryDateId] DEFAULT ((-1)) FOR [EnrollmentEntryDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_K12StudentId] DEFAULT ((-1)) FOR [K12StudentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaIEPServiceProviderId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaIEPServiceProviderId] DEFAULT ((-1)) FOR [LeaIEPServiceProviderId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ResponsibleSchoolTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ResponsibleSchoolTypeId] DEFAULT ((-1)) FOR [ResponsibleSchoolTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_K12SchoolId] DEFAULT ((-1)) FOR [K12SchoolId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaAccountabilityId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaAccountabilityId] DEFAULT ((-1)) FOR [LeaAccountabilityId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaAttendanceId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaAttendanceId] DEFAULT ((-1)) FOR [LeaAttendanceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaIndividualizedEducationProgramId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaIndividualizedEducationProgramId] DEFAULT ((-1)) FOR [LeaIndividualizedEducationProgramId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaGraduationId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaGraduationId] DEFAULT ((-1)) FOR [LeaGraduationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_LeaFundingId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_LeaFundingId] DEFAULT ((-1)) FOR [LeaFundingId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_TitleIStatusId] DEFAULT ((-1)) FOR [TitleIStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_K12EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_K12EnrollmentStatusId] DEFAULT ((-1)) FOR [K12EnrollmentStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_K12DemographicId] DEFAULT ((-1)) FOR [K12DemographicId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_NOrDStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_NOrDStatusId] DEFAULT ((-1)) FOR [NOrDStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_MilitaryStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_MilitaryStatusId] DEFAULT ((-1)) FOR [MilitaryStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_MigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_MigrantStatusId] DEFAULT ((-1)) FOR [MigrantStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ProgramParticipationStartDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ProgramParticipationStartDateId] DEFAULT ((-1)) FOR [ProgramParticipationStartDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_SecondaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_SecondaryDisabilityTypeId] DEFAULT ((-1)) FOR [SecondaryDisabilityTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_PrimaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_PrimaryDisabilityTypeId] DEFAULT ((-1)) FOR [PrimaryDisabilityTypeId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_SpecialEducationServicesExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_SpecialEducationServicesExitDateId] DEFAULT ((-1)) FOR [SpecialEducationServicesExitDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_TitleIIIStatusId] DEFAULT ((-1)) FOR [TitleIIIStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanDateId] DEFAULT ((-1)) FOR [IndividualizedProgramServicePlanDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramStatusId] DEFAULT ((-1)) FOR [IndividualizedProgramStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_ImmigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_ImmigrantStatusId] DEFAULT ((-1)) FOR [ImmigrantStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId] DEFAULT ((-1)) FOR [IndividualizedProgramServicePlanReevaluationDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramDateId] DEFAULT ((-1)) FOR [IndividualizedProgramDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId] DEFAULT ((-1)) FOR [IndividualizedProgramServicePlanExitDateId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_HomelessnessStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_HomelessnessStatusId] DEFAULT ((-1)) FOR [HomelessnessStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_IdeaStatusId] DEFAULT ((-1)) FOR [IdeaStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EligibilityEvaluationDateInitialId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EligibilityEvaluationDateInitialId] DEFAULT ((-1)) FOR [EligibilityEvaluationDateInitialId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_FosterCareId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_FosterCareId] DEFAULT ((-1)) FOR [FosterCareStatusId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation]
		ADD CONSTRAINT [DF_FactSpecialEducation_EligibilityEvaluationDateReevaluationId] DEFAULT ((-1)) FOR [EligibilityEvaluationDateReevaluationId];


	
	PRINT N'Creating Default Constraint unnamed constraint on [RDS].[ReportEDFactsOrganizationCounts]...';


	
	ALTER TABLE [RDS].[ReportEDFactsOrganizationCounts]
		ADD DEFAULT (N'0') FOR [OutOfStateIndicator];


	
	PRINT N'Creating Default Constraint unnamed constraint on [RDS].[ReportEDFactsOrganizationCounts]...';


	
	ALTER TABLE [RDS].[ReportEDFactsOrganizationCounts]
		ADD DEFAULT ((0)) FOR [TitleiParentalInvolveRes];


	
	PRINT N'Creating Default Constraint unnamed constraint on [RDS].[ReportEDFactsOrganizationCounts]...';


	
	ALTER TABLE [RDS].[ReportEDFactsOrganizationCounts]
		ADD DEFAULT ((0)) FOR [TitleiPartaAllocations];


	
	PRINT N'Creating Default Constraint unnamed constraint on [RDS].[ToggleAssessments]...';


	
	ALTER TABLE [RDS].[ToggleAssessments]
		ADD DEFAULT (N'') FOR [Subject];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipationId]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces]
		ADD CONSTRAINT [DF_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipationId] DEFAULT ((-1)) FOR [FactK12ProgramParticipationId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12ProgramParticipationRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces]
		ADD CONSTRAINT [DF_BridgeK12ProgramParticipationRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollmentId] DEFAULT ((-1)) FOR [FactK12StudentEnrollmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgeK12StudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgeK12StudentEnrollmentRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollmentId] DEFAULT ((-1)) FOR [FactPsStudentEnrollmentId];


	
	PRINT N'Creating Default Constraint [RDS].[DF_BridgePsStudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces]
		ADD CONSTRAINT [DF_BridgePsStudentEnrollmentRaces_RaceId] DEFAULT ((-1)) FOR [RaceId];


	-- 
	-- PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12SchoolGradeLevels_GradeLevelId]...';


	-- 
	-- ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] WITH NOCHECK
	-- 	ADD CONSTRAINT [FK_BridgeK12SchoolGradeLevels_GradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	-- 
	-- PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12SchoolGradeLevels_K12SchoolId]...';


	-- 
	-- ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] WITH NOCHECK
	-- 	ADD CONSTRAINT [FK_BridgeK12SchoolGradeLevels_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections] FOREIGN KEY ([FactK12StudentCourseSectionId]) REFERENCES [RDS].[FactK12StudentCourseSections] ([FactK12StudentCourseSectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionK12Staff_K12Staff]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_K12Staff] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments] FOREIGN KEY ([FactK12StudentEnrollmentId]) REFERENCES [RDS].[FactK12StudentEnrollments] ([FactK12StudentEnrollmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeLeaGradeLevels_GradeLevelId]...';


	
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeLeaGradeLevels_GradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeLeaGradeLevels_LeaId]...';


	
	ALTER TABLE [RDS].[BridgeLeaGradeLevels] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeLeaGradeLevels_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments] FOREIGN KEY ([FactPsStudentEnrollmentId]) REFERENCES [RDS].[FactPsStudentEnrollments] ([FactPsStudentEnrollmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimIdeaStatuses]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimIdeaStatuses] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations] FOREIGN KEY ([FactK12ProgramParticipationId]) REFERENCES [RDS].[FactK12ProgramParticipations] ([FactK12ProgramParticipationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	/*
	The column [RDS].[DimIeus].[CharterSchoolAuthorizerIdPrimary] is being dropped.
	The column [RDS].[DimIeus].[CharterSchoolAuthorizerIdSecondary] is being dropped.
	The column [RDS].[DimIeus].[IeuIdentifierState] is being renamed.
	The column [RDS].[DimIeus].[IeuName] is being renamed.
	The column [RDS].[DimIeus].[LeaIdentifierState] renamed.
	The column [RDS].[DimIeus].[LeaName] renamed.
	The column [RDS].[DimIeus].[LeaOrganizationId] dropped.
	The column [RDS].[DimIeus].[LeaTypeId] dropped.
	The column [RDS].[DimIeus].[MailingAddressState] renamed.
	The column [RDS].[DimIeus].[MailingAddressStreet] renamed.
	The column [RDS].[DimIeus].[MailingAddressStreet2] renamed.
	The column [RDS].[DimIeus].[MailingCountyAnsiCode] renamed.
	The column [RDS].[DimIeus].[PhysicalAddressState] renamed.
	The column [RDS].[DimIeus].[PhysicalAddressStreet] renamed.
	The column [RDS].[DimIeus].[PhysicalAddressStreet2] renamed.
	The column [RDS].[DimIeus].[PhysicalCountyAnsiCode] renamed.
	The column [RDS].[DimIeus].[PriorLeaIdentifierState] renamed.
	The column [RDS].[DimIeus].[PriorSchoolIdentifierState] renamed.
	The column [RDS].[DimIeus].[SchoolIdentifierState] renamed.
	The column [RDS].[DimIeus].[SchoolOperationalStatusEffectiveDate] renamed.
	The column [RDS].[DimIeus].[SchoolOrganizationId] dropped.
	The column [RDS].[DimIeus].[SchoolTypeId] dropped.
	The column [RDS].[DimIeus].[SeaIdentifierState] renamed.
	The column [RDS].[DimIeus].[SeaName] renamed.
	The column [RDS].[DimIeus].[SeaOrganizationId] renamed.
	The column [RDS].[DimIeus].[Telephone] renamed.
	The column [RDS].[DimIeus].[Website] renamed.
	*/
	PRINT N'Starting rebuilding table [RDS].[DimIeus]...';


	SET XACT_ABORT ON;

	CREATE TABLE [RDS].[tmp_ms_xx_DimIeus](
		[DimIeuId] [int] IDENTITY(1,1) NOT NULL,
		[IeuOrganizationName] [nvarchar](1000) NULL,
		[IeuOrganizationIdentifierSea] [nvarchar](50) NULL,
		[SeaOrganizationName] [nvarchar](1000) NULL,
		[SeaOrganizationIdentifierSea] [nvarchar](50) NULL,
		[StateANSICode] [nvarchar](10) NULL,
		[StateAbbreviationCode] [nvarchar](10) NULL,
		[StateAbbreviationDescription] [nvarchar](1000) NULL,
		[MailingAddressStreetNumberAndName] [nvarchar](150) NULL,
		[MailingAddressApartmentRoomOrSuiteNumber] [varchar](40) NULL,
		[MailingAddressCity] [nvarchar](30) NULL,
		[MailingAddressStateAbbreviation] [nvarchar](50) NULL,
		[MailingAddressPostalCode] [nvarchar](17) NULL,
		[MailingAddressCountyAnsiCodeCode] [char](5) NULL,
		[OutOfStateIndicator] [bit] NOT NULL,
		[OrganizationOperationalStatus] [varchar](20) NULL,
		[OperationalStatusEffectiveDate] [datetime] NULL,
		[PhysicalAddressStreetNumberAndName] [nvarchar](150) NULL,
		[PhysicalAddressApartmentRoomOrSuiteNumber] [varchar](40) NULL,
		[PhysicalAddressCity] [nvarchar](30) NULL,
		[PhysicalAddressPostalCode] [nvarchar](17) NULL,
		[PhysicalAddressStateAbbreviation] [nvarchar](50) NULL,
		[PhysicalAddressCountyAnsiCodeCode] [char](5) NULL,
		[TelephoneNumber] [nvarchar](24) NULL,
		[WebSiteAddress] [nvarchar](300) NULL,
		[OrganizationRegionGeoJson] [nvarchar](max) NULL,
		[Latitude] [nvarchar](20) NULL,
		[Longitude] [nvarchar](20) NULL,
		[RecordStartDateTime] [datetime] NOT NULL,
		[RecordEndDateTime] [datetime] NULL,
	 CONSTRAINT [tmp_ms_xx_PK_DimIeus] PRIMARY KEY CLUSTERED ([DimIeuId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) 

	IF EXISTS (SELECT TOP 1 1 
			   FROM   [RDS].[DimIeus])
		BEGIN
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimIeus] ON;
			INSERT INTO [RDS].[tmp_ms_xx_DimIeus] (
					  [DimIeuId]
					, [IeuOrganizationName]
					, [IeuOrganizationIdentifierSea]
					, [SeaOrganizationName]
					, [SeaOrganizationIdentifierSea]
					, [StateANSICode]
					, [StateAbbreviationCode]
					, [StateAbbreviationDescription]
					, [MailingAddressStreetNumberAndName]
					, [MailingAddressCity]
					, [MailingAddressStateAbbreviation]
					, [MailingAddressPostalCode]
					, [MailingAddressCountyAnsiCodeCode]
					, [OutOfStateIndicator]
					, [OrganizationOperationalStatus]
					, [OperationalStatusEffectiveDate]
					, [PhysicalAddressStreetNumberAndName]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressStateAbbreviation]
					, [PhysicalAddressCountyAnsiCodeCode]
					, [TelephoneNumber]
					, [WebSiteAddress]
					, [OrganizationRegionGeoJson]
					, [Latitude]
					, [Longitude]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
					)
			SELECT    
					  [DimIeuId]
					, [IeuName]
					, [IeuIdentifierState]
					, [SeaName]
					, [SeaStateIdentifier]
					, [StateANSICode]
					, [StateCode]
					, [StateName]
					, [MailingAddressStreet]
					, [MailingAddressCity]
					, [MailingAddressState]
					, [MailingAddressPostalCode]
					, [MailingCountyAnsiCode]
					, [OutOfStateIndicator]
					, [OrganizationOperationalStatus]
					, [OperationalStatusEffectiveDate]
					, [PhysicalAddressStreet]
					, [PhysicalAddressCity]
					, [PhysicalAddressPostalCode]
					, [PhysicalAddressState]
					, [PhysicalCountyAnsiCode]
					, [Telephone]
					, [WebSite]
					, [OrganizationRegionGeoJson]
					, [Latitude]
					, [Longitude]
					, [RecordStartDateTime]
					, [RecordEndDateTime]
			FROM     [RDS].[DimIeus]
			SET IDENTITY_INSERT [RDS].[tmp_ms_xx_DimIeus] OFF;
		END

	DROP TABLE [RDS].[DimIeus];

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_DimIeus]', N'DimIeus';

	EXECUTE sp_rename N'[RDS].[tmp_ms_xx_PK_DimIeus]', N'PK_DimIeus', N'OBJECT';
	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12Demographics]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_K12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12ProgramTypes]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_K12ProgramTypes] FOREIGN KEY ([K12ProgramTypeId]) REFERENCES [RDS].[DimK12ProgramTypes] ([DimK12ProgramTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaAccountabilityId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_LeaAccountabilityId] FOREIGN KEY ([LeaAccountabilityId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaAttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_LeaAttendanceId] FOREIGN KEY ([LeaAttendanceId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaFundingId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_LeaFundingId] FOREIGN KEY ([LeaFundingId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaGraduationID]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_LeaGraduationID] FOREIGN KEY ([LeaGraduationId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId] FOREIGN KEY ([LeaIndividualizedEducationProgramId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_ProgramParticipationExitDateId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationExitDateId] FOREIGN KEY ([ProgramParticipationExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_ProgramParticipationStartDateId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationStartDateId] FOREIGN KEY ([ProgramParticipationStartDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12ProgramParticipations_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12ProgramParticipations_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffCategoryId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId] FOREIGN KEY ([K12StaffCategoryId]) REFERENCES [RDS].[DimK12StaffCategories] ([DimK12StaffCategoryId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_K12StaffId] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_K12StaffStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId] FOREIGN KEY ([K12StaffStatusId]) REFERENCES [RDS].[DimK12StaffStatuses] ([DimK12StaffStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_TitleIIIStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_TitleIIIStatuses] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_CredentialIssuanceDateId]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_CredentialIssuanceDateId] FOREIGN KEY ([CredentialIssuanceDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StaffCounts_TCredentialExpirationDate]...';


	
	ALTER TABLE [RDS].[FactK12StaffCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StaffCounts_CredentialExpirationDate] FOREIGN KEY ([CredentialExpirationDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentAdministrationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentAdministrationId] FOREIGN KEY ([AssessmentAdministrationId]) REFERENCES [RDS].[DimAssessmentAdministrations] ([DimAssessmentAdministrationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentId] FOREIGN KEY ([AssessmentId]) REFERENCES [RDS].[DimAssessments] ([DimAssessmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentParticipationSessionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentParticipationSessionId] FOREIGN KEY ([AssessmentParticipationSessionId]) REFERENCES [RDS].[DimAssessmentParticipationSessions] ([DimAssessmentParticipationSessionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentPerformanceLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentPerformanceLevelId] FOREIGN KEY ([AssessmentPerformanceLevelId]) REFERENCES [RDS].[DimAssessmentPerformanceLevels] ([DimAssessmentPerformanceLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentRegistrationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentRegistrationId] FOREIGN KEY ([AssessmentRegistrationId]) REFERENCES [RDS].[DimAssessmentRegistrations] ([DimAssessmentRegistrationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentResultId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentResultId] FOREIGN KEY ([AssessmentResultId]) REFERENCES [RDS].[DimAssessmentResults] ([DimAssessmentResultId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_AssessmentSubtestId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentSubtestId] FOREIGN KEY ([AssessmentSubtestId]) REFERENCES [RDS].[DimAssessmentSubtests] ([DimAssessmentSubtestId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_CompetencyDefinitionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_CompetencyDefinitionId] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [RDS].[DimCompetencyDefinitions] ([DimCompetencyDefinitionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_CteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_CountDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_CountDateId] FOREIGN KEY ([CountDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_GradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_GradeLevelId] FOREIGN KEY ([GradeLevelWhenAssessedId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_NOrDStatuses]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_NOrDStatuses] FOREIGN KEY ([NOrDStatusId]) REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	-- PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_StudentStatusId]...';


	-- 
	-- ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
	-- 	ADD CONSTRAINT [FK_FactK12StudentAssessments_StudentStatusId] FOREIGN KEY ([K12StudentStatusId]) REFERENCES [RDS].[DimK12StudentStatuses] ([DimK12StudentstatusId]);


	-- 
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessments_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessments_TitleIIIStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_AgeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_AgeId] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_AttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_AttendanceId] FOREIGN KEY ([AttendanceId]) REFERENCES [RDS].[DimAttendances] ([DimAttendanceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_CohortStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_CohortStatusId] FOREIGN KEY ([CohortStatusId]) REFERENCES [RDS].[DimCohortStatuses] ([DimCohortStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_CteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId] FOREIGN KEY ([EconomicallyDisadvantagedStatusId]) REFERENCES [RDS].[DimEconomicallyDisadvantagedStatuses] ([DimEconomicallyDisadvantagedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_EnglishLearnerId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_EnglishLearnerId] FOREIGN KEY ([EnglishLearnerStatusId]) REFERENCES [RDS].[DimEnglishLearnerStatuses] ([DimEnglishLearnerStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_FosterCareStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_FosterCareStatusId] FOREIGN KEY ([FosterCareStatusId]) REFERENCES [RDS].[DimFosterCareStatuses] ([DimFosterCareStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_GradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_GradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_HomelessnessStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_HomelessnessStatusId] FOREIGN KEY ([HomelessnessStatusId]) REFERENCES [RDS].[DimHomelessnessStatuses] ([DimHomelessnessStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_ImmigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_ImmigrantStatusId] FOREIGN KEY ([ImmigrantStatusId]) REFERENCES [RDS].[DimImmigrantStatuses] ([DimImmigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_K12EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_K12EnrollmentStatusId] FOREIGN KEY ([K12EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId]);



	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	-- PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_K12StudentStatusId]...';


	-- 
	-- ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
	-- 	ADD CONSTRAINT [FK_FactK12StudentCounts_K12StudentStatusId] FOREIGN KEY ([K12StudentStatusId]) REFERENCES [RDS].[DimK12StudentStatuses] ([DimK12StudentstatusId]);


	-- 
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_LanguageId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_MigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_MigrantStatusId] FOREIGN KEY ([MigrantStatusId]) REFERENCES [RDS].[DimMigrantStatuses] ([DimMigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_NOrDStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_NOrDStatusId] FOREIGN KEY ([NOrDStatusId]) REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_PrimaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_PrimaryDisabilityTypeId] FOREIGN KEY ([PrimaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_SpecialEducationServicesExitDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_SpecialEducationServicesExitDateId] FOREIGN KEY ([SpecialEducationServicesExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_TitleIIIStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCounts_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCounts_TitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12CourseStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseStatusId] FOREIGN KEY ([K12CourseStatusId]) REFERENCES [RDS].[DimK12CourseStatuses] ([DimK12CourseStatusId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseStatusId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_K12DemographicId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LanguageId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LanguageId] FOREIGN KEY ([LanguageId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_LanguageId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaAccountabilityId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LeaAccountabilityId] FOREIGN KEY ([LeaAccountabilityId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaAttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LeaAttendanceId] FOREIGN KEY ([LeaAttendanceId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaFundingId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LeaFundingId] FOREIGN KEY ([LeaFundingId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaGraduationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LeaGraduationId] FOREIGN KEY ([LeaGraduationId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_LeaIndividualizedEducationProgramId] FOREIGN KEY ([LeaIndividualizedEducationProgramId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_ScedCodeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_ScedCodeId] FOREIGN KEY ([ScedCodeId]) REFERENCES [RDS].[DimScedCodes] ([DimScedCodeId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_ScedCodeId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_SchoolYearId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_SeaId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_CipCodeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_CipCodeId] FOREIGN KEY ([CipCodeId]) REFERENCES [RDS].[DimCipCodes] ([DimCipCodeId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_CipCodeId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_DataCollectionId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_EntryGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_EntryGradeLevelId] FOREIGN KEY ([EntryGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_EntryGradeLevelId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentCourseSections_K12CourseId]...';


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseId] FOREIGN KEY ([K12CourseId]) REFERENCES [RDS].[DimK12Courses] ([DimK12CourseId]);


	
	ALTER TABLE [RDS].[FactK12StudentCourseSections] NOCHECK CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseId];



	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_AgeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_AgeId] FOREIGN KEY ([AgeId]) REFERENCES [RDS].[DimAges] ([DimAgeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_CteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisabilityStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_DisabilityStatusId] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [RDS].[DimDisabilityStatuses] ([DimDisabilityStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId] FOREIGN KEY ([DisciplinaryActionEndDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId] FOREIGN KEY ([DisciplinaryActionStartDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_DisciplineStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_DisciplineStatusId] FOREIGN KEY ([DisciplineStatusId]) REFERENCES [RDS].[DimDisciplineStatuses] ([DimDisciplineStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId] FOREIGN KEY ([EconomicallyDisadvantagedStatusId]) REFERENCES [RDS].[DimEconomicallyDisadvantagedStatuses] ([DimEconomicallyDisadvantagedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_EnglishLearnerStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_EnglishLearnerStatusId] FOREIGN KEY ([EnglishLearnerStatusId]) REFERENCES [RDS].[DimEnglishLearnerStatuses] ([DimEnglishLearnerStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_FirearmId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_FirearmId] FOREIGN KEY ([FirearmId]) REFERENCES [RDS].[DimFirearms] ([DimFirearmId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId] FOREIGN KEY ([FirearmDisciplineStatusId]) REFERENCES [RDS].[DimFirearmDisciplineStatuses] ([DimFirearmDisciplineStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_FosterCareStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_FosterCareStatusId] FOREIGN KEY ([FosterCareStatusId]) REFERENCES [RDS].[DimFosterCareStatuses] ([DimFosterCareStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_GradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_GradeLevelId] FOREIGN KEY ([GradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_HomelessnessStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_HomelessnessStatusId] FOREIGN KEY ([HomelessnessStatusId]) REFERENCES [RDS].[DimHomelessnessStatuses] ([DimHomelessnessStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_ImmigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_ImmigrantStatusId] FOREIGN KEY ([ImmigrantStatusId]) REFERENCES [RDS].[DimImmigrantStatuses] ([DimImmigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_IncidentDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_IncidentDateId] FOREIGN KEY ([IncidentDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_IncidentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_IncidentStatusId] FOREIGN KEY ([IncidentStatusId]) REFERENCES [RDS].[DimIncidentStatuses] ([DimIncidentStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_LeaID]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_LeaID] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_MigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_MigrantStatusId] FOREIGN KEY ([MigrantStatusId]) REFERENCES [RDS].[DimMigrantStatuses] ([DimMigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_NOrDStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_NOrDStatusId] FOREIGN KEY ([NOrDStatusId]) REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId] FOREIGN KEY ([PrimaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId] FOREIGN KEY ([SecondaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_TitleiiiStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_TitleiiiStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentDisciplines_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentDisciplines_TitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_CohortGraduationYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_CohortGraduationYearId] FOREIGN KEY ([CohortGraduationYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_CohortYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_CohortYearId] FOREIGN KEY ([CohortYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_CteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId] FOREIGN KEY ([EconomicallyDisadvantagedStatusId]) REFERENCES [RDS].[DimEconomicallyDisadvantagedStatuses] ([DimEconomicallyDisadvantagedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EducationOrganizationNetworkId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EducationOrganizationNetworkId] FOREIGN KEY ([EducationOrganizationNetworkId]) REFERENCES [RDS].[DimEducationOrganizationNetworks] ([DimEducationOrganizationNetworkId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnglishLearnerStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EnglishLearnerStatusId] FOREIGN KEY ([EnglishLearnerStatusId]) REFERENCES [RDS].[DimEnglishLearnerStatuses] ([DimEnglishLearnerStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_EntryGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_EntryGradeLevelId] FOREIGN KEY ([EntryGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_ExitGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_ExitGradeLevelId] FOREIGN KEY ([ExitGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_FosterCareStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_FosterCareStatusId] FOREIGN KEY ([FosterCareStatusId]) REFERENCES [RDS].[DimFosterCareStatuses] ([DimFosterCareStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaGraduationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LeaGraduationId] FOREIGN KEY ([LeaGraduationID]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId] FOREIGN KEY ([StatusEndDateHomelessnessId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusId] FOREIGN KEY ([HomelessnessStatusId]) REFERENCES [RDS].[DimHomelessnessStatuses] ([DimHomelessnessStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId] FOREIGN KEY ([StatusStartDateHomelessnessId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_ImmigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_ImmigrantStatusId] FOREIGN KEY ([ImmigrantStatusId]) REFERENCES [RDS].[DimImmigrantStatuses] ([DimImmigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_K12EnrollmentStatusId] FOREIGN KEY ([K12EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_K12SchoolId] FOREIGN KEY ([AccountableK12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LanguageHomeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LanguageHomeId] FOREIGN KEY ([LanguageHomeId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LanguageNativeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LanguageNativeId] FOREIGN KEY ([LanguageNativeId]) REFERENCES [RDS].[DimLanguages] ([DimLanguageId]) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT;


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaAccountabilityId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LeaAccountabilityId] FOREIGN KEY ([LeaAccountabilityId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaAttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LeaAttendanceId] FOREIGN KEY ([LeaAttendanceId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaFundingId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LeaFundingId] FOREIGN KEY ([LeaFundingId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId] FOREIGN KEY ([LeaIndividualizedEducationProgramId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_MigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_MigrantStatusId] FOREIGN KEY ([MigrantStatusId]) REFERENCES [RDS].[DimMigrantStatuses] ([DimMigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_MilitaryStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_MilitaryStatusId] FOREIGN KEY ([MilitaryStatusId]) REFERENCES [RDS].[DimMilitaryStatuses] ([DimMilitaryStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_NOrDStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_NOrDStatusId] FOREIGN KEY ([NOrDStatusId]) REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId] FOREIGN KEY ([PrimaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_ProjectedGraduationDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_ProjectedGraduationDateId] FOREIGN KEY ([ProjectedGraduationDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId] FOREIGN KEY ([SecondaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId] FOREIGN KEY ([StatusEndDateEconomicallyDisadvantagedId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId] FOREIGN KEY ([StatusEndDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateIdeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateIdeaId] FOREIGN KEY ([StatusEndDateIdeaId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateMigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMigrantId] FOREIGN KEY ([StatusEndDateMigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ] FOREIGN KEY ([StatusEndDateMilitaryConnectedStudentId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDatePerkinsELId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDatePerkinsELId] FOREIGN KEY ([StatusEndDatePerkinsELId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId] FOREIGN KEY ([StatusEndDateTitleIIIImmigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId] FOREIGN KEY ([StatusStartDateEconomicallyDisadvantagedId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId] FOREIGN KEY ([StatusStartDateEnglishLearnerId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateIdeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateIdeaId] FOREIGN KEY ([StatusStartDateIdeaId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateMigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMigrantId] FOREIGN KEY ([StatusStartDateMigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId] FOREIGN KEY ([StatusStartDateMilitaryConnectedStudentId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDatePerkinsELId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDatePerkinsELId] FOREIGN KEY ([StatusStartDatePerkinsELId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId] FOREIGN KEY ([StatusStartDateTitleIIIImmigrantId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_TitleIIIStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEnrollments_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEnrollments_TitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId] FOREIGN KEY ([AuthorizingBodyCharterSchoolAuthorizerId]) REFERENCES [RDS].[DimCharterSchoolAuthorizers] ([DimCharterSchoolAuthorizerId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId] FOREIGN KEY ([CharterSchoolManagementOrganizationId]) REFERENCES [RDS].[DimCharterSchoolManagementOrganizations] ([DimCharterSchoolManagementOrganizationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId] FOREIGN KEY ([SecondaryAuthorizingBodyCharterSchoolAuthorizerId]) REFERENCES [RDS].[DimCharterSchoolAuthorizers] ([DimCharterSchoolAuthorizerId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_CharterSchoolStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolStatusId] FOREIGN KEY ([CharterSchoolStatusId]) REFERENCES [RDS].[DimCharterSchoolStatuses] ([DimCharterSchoolStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId] FOREIGN KEY ([CharterSchoolUpdatedManagementOrganizationId]) REFERENCES [RDS].[DimCharterSchoolManagementOrganizations] ([DimCharterSchoolManagementOrganizationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_ComprehensiveAndTargetedSupportId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_ComprehensiveAndTargetedSupportId] FOREIGN KEY ([ComprehensiveAndTargetedSupportId]) REFERENCES [RDS].[DimComprehensiveAndTargetedSupports] ([DimComprehensiveAndTargetedSupportId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_ReasonApplicabilityId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_ReasonApplicabilityId] FOREIGN KEY ([ReasonApplicabilityId]) REFERENCES [RDS].[DimReasonApplicabilities] ([DimReasonApplicabilityId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_K12OrganizationStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_K12OrganizationStatusId] FOREIGN KEY ([K12OrganizationStatusId]) REFERENCES [RDS].[DimK12OrganizationStatuses] ([DimK12OrganizationStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_K12SchoolStateStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_K12SchoolStateStatusId] FOREIGN KEY ([K12SchoolStateStatusId]) REFERENCES [RDS].[DimK12SchoolStateStatuses] ([DimK12SchoolStateStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_K12SchoolStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_K12SchoolStatusId] FOREIGN KEY ([K12SchoolStatusId]) REFERENCES [RDS].[DimK12SchoolStatuses] ([DimK12SchoolStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_K12StaffId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_K12StaffId] FOREIGN KEY ([K12StaffId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_LeaId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_SeaId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_SubgroupId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_SubgroupId] FOREIGN KEY ([SubgroupId]) REFERENCES [RDS].[DimSubgroups] ([DimSubgroupId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationCounts_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactOrganizationCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationCounts_TitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimFactTypes]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimFactTypes] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimRaces]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicators]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicators] FOREIGN KEY ([SchoolPerformanceIndicatorId]) REFERENCES [RDS].[DimSchoolPerformanceIndicators] ([DimSchoolPerformanceIndicatorId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorCategories]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorCategories] FOREIGN KEY ([SchoolPerformanceIndicatorCategoryId]) REFERENCES [RDS].[DimSchoolPerformanceIndicatorCategories] ([DimSchoolPerformanceIndicatorCategoryId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimSchoolQualityOrStudentSuccessIndicators]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolQualityOrStudentSuccessIndicators] FOREIGN KEY ([SchoolQualityOrStudentSuccessIndicatorId]) REFERENCES [RDS].[DimSchoolQualityOrStudentSuccessIndicators] ([DimSchoolQualityOrStudentSuccessIndicatorId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorStateDefinedStatuses]...';


	
	ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH NOCHECK
		ADD CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorStateDefinedStatuses] FOREIGN KEY ([SchoolPerformanceIndicatorStateDefinedStatusId]) REFERENCES [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses] ([DimSchoolPerformanceIndicatorStateDefinedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_AcademicAwardDateId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicAwards_AcademicAwardDateId] FOREIGN KEY ([AcademicAwardDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId] FOREIGN KEY ([PsAcademicAwardStatusId]) REFERENCES [RDS].[DimPsAcademicAwardStatuses] ([DimPsAcademicAwardStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId] FOREIGN KEY ([PsAcademicAwardTitleId]) REFERENCES [RDS].[DimPsAcademicAwardTitles] ([DimPsAcademicAwardTitleId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsInstitutionId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicAwards_PsInstitutionId] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicAwards_PsStudentId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicAwards_PsStudentId] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId] FOREIGN KEY ([AcademicTermDesignatorId]) REFERENCES [RDS].[DimAcademicTermDesignators] ([DimAcademicTermDesignatorId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId] FOREIGN KEY ([PsEnrollmentStatusId]) REFERENCES [RDS].[DimPsEnrollmentStatuses] ([DimPsEnrollmentStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsInstitutionId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionId] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsInstitutionStatusId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionStatusId] FOREIGN KEY ([PsInstitutionStatusId]) REFERENCES [RDS].[DimPsInstitutionStatuses] ([DimPsInstitutionStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_PsStudentId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_PsStudentId] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentAcademicRecords_SeaId]...';


	
	ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentAcademicRecords_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_AcademicTermDesignatorId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_AcademicTermDesignatorId] FOREIGN KEY ([AcademicTermDesignatorId]) REFERENCES [RDS].[DimAcademicTermDesignators] ([DimAcademicTermDesignatorId]);


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] NOCHECK CONSTRAINT [FK_FactPsStudentEnrollments_AcademicTermDesignatorId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] NOCHECK CONSTRAINT [FK_FactPsStudentEnrollments_DataCollectionId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId] FOREIGN KEY ([EntryDateIntoPostSecondaryId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsEnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_PsEnrollmentStatusId] FOREIGN KEY ([PsEnrollmentStatusId]) REFERENCES [RDS].[DimPsEnrollmentStatuses] ([DimPsEnrollmentStatusId]);


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] NOCHECK CONSTRAINT [FK_FactPsStudentEnrollments_PsEnrollmentStatusId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsInstitutionId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionId] FOREIGN KEY ([PsInstitutionID]) REFERENCES [RDS].[DimPsInstitutions] ([DimPsInstitutionID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsInstitutionStatusId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionStatusId] FOREIGN KEY ([PsInstitutionStatusId]) REFERENCES [RDS].[DimPsInstitutionStatuses] ([DimPsInstitutionStatusId]);


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] NOCHECK CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionStatusId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_PsStudentId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_PsStudentId] FOREIGN KEY ([PsStudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactPsStudentEnrollments_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactPsStudentEnrollments_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	ALTER TABLE [RDS].[FactPsStudentEnrollments] NOCHECK CONSTRAINT [FK_FactPsStudentEnrollments_SchoolYearId];


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId] FOREIGN KEY ([FactAeStudentEnrollmentId]) REFERENCES [RDS].[FactAeStudentEnrollments] ([FactAeStudentEnrollmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeAeStudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeAeStudentEnrollmentRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_FactK12StudentEnrollmentId] FOREIGN KEY ([FactK12StudentEnrollmentId]) REFERENCES [RDS].[FactK12StudentEnrollments] ([FactK12StudentEnrollmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentsIdeaDisabilityTypes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentsIdeaDisabilityTypes_IdeaDisabilityTypeId] FOREIGN KEY ([IdeaDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_AssessmentAccommodationId] FOREIGN KEY ([AssessmentAccommodationId]) REFERENCES [RDS].[DimAssessmentAccommodations] ([DimAssessmentAccommodationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId] FOREIGN KEY ([FactK12StudentAssessmentId]) REFERENCES [RDS].[FactK12StudentAssessments] ([FactK12StudentAssessmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments] FOREIGN KEY ([FactK12StudentAssessmentId]) REFERENCES [RDS].[FactK12StudentAssessments] ([FactK12StudentAssessmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentAssessmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentAssessmentRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionRace_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections] FOREIGN KEY ([FactK12StudentCourseSectionId]) REFERENCES [RDS].[FactK12StudentCourseSections] ([FactK12StudentCourseSectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId] FOREIGN KEY ([CipCodeId]) REFERENCES [RDS].[DimCipCodes] ([DimCipCodeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections] FOREIGN KEY ([FactK12StudentCourseSectionId]) REFERENCES [RDS].[FactK12StudentCourseSections] ([FactK12StudentCourseSectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines] FOREIGN KEY ([FactK12StudentDisciplineId]) REFERENCES [RDS].[FactK12StudentDisciplines] ([FactK12StudentDisciplineId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentDisciplineRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentDisciplineRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId] FOREIGN KEY ([FactK12StudentEconomicDisadvantageId]) REFERENCES [RDS].[FactK12StudentEconomicDisadvantages] ([FactK12StudentEconomicDisadvantageId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEconomicDisadvantageRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEconomicDisadvantageRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments] FOREIGN KEY ([FactK12StudentEnrollmentId]) REFERENCES [RDS].[FactK12StudentEnrollments] ([FactK12StudentEnrollmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentPersonAddresses_PersonAddressId] FOREIGN KEY ([PersonAddressId]) REFERENCES [RDS].[DimPersonAddresses] ([DimPersonAddressId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId] FOREIGN KEY ([FactSpecialEducationId]) REFERENCES [RDS].[FactSpecialEducation] ([FactSpecialEducationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeSpecialEducationIdeaDisabilityTypes_IdeaDisabilityTypeId] FOREIGN KEY ([IdeaDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeSpecialEducationRaces_FactSpecialEducationId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeSpecialEducationRaces_FactSpecialEducationId] FOREIGN KEY ([FactSpecialEducationId]) REFERENCES [RDS].[FactSpecialEducation] ([FactSpecialEducationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeSpecialEducationRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeSpecialEducationRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeSpecialEducationRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeDemographicId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeDemographicId] FOREIGN KEY ([AeDemographicId]) REFERENCES [RDS].[DimAeDemographics] ([DimAeDemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProgramYearId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramYearId] FOREIGN KEY ([AeProgramYearId]) REFERENCES [RDS].[DimAeProgramYears] ([DimAeProgramYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId] FOREIGN KEY ([AePostsecondaryTransitionDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProgramTypeId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramTypeId] FOREIGN KEY ([AeProgramTypeId]) REFERENCES [RDS].[DimAeProgramTypes] ([DimAeProgramTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeProviderId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeProviderId] FOREIGN KEY ([AeProviderId]) REFERENCES [RDS].[DimAeProviders] ([DimAeProviderId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeStudentId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeStudentId] FOREIGN KEY ([AeStudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_AeStudentStatusId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_AeStudentStatusId] FOREIGN KEY ([AeStudentStatusId]) REFERENCES [RDS].[DimAeStudentStatuses] ([DimAeStudentStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_ApplicationDateId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_ApplicationDateId] FOREIGN KEY ([ApplicationDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_K12AcademicAwardStatusId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_K12AcademicAwardStatusId] FOREIGN KEY ([K12AcademicAwardStatusId]) REFERENCES [RDS].[DimK12AcademicAwardStatuses] ([DimK12AcademicAwardStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactAeStudentEnrollments_K12DiplomaOrCredentialAwardDateId]...';


	
	ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH NOCHECK
		ADD CONSTRAINT [FK_FactAeStudentEnrollments_K12DiplomaOrCredentialAwardDateId] FOREIGN KEY ([K12DiplomaOrCredentialAwardDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId] FOREIGN KEY ([AcademicTermDesignatorId]) REFERENCES [RDS].[DimAcademicTermDesignators] ([DimAcademicTermDesignatorId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId] FOREIGN KEY ([AssessmentAdministrationId]) REFERENCES [RDS].[DimAssessmentAdministrations] ([DimAssessmentAdministrationId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentId] FOREIGN KEY ([AssessmentId]) REFERENCES [RDS].[DimAssessments] ([DimAssessmentId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId] FOREIGN KEY ([AssessmentSubtestId]) REFERENCES [RDS].[DimAssessmentSubtests] ([DimAssessmentSubtestId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [RDS].[DimCompetencyDefinitions] ([DimCompetencyDefinitionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId] FOREIGN KEY ([GradeLevelWhenAssessedId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_RaceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAssessmentsResultAggregates_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_AttendanceId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_AttendanceId] FOREIGN KEY ([AttendanceId]) REFERENCES [RDS].[DimAttendances] ([DimAttendanceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_FactTypeId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_FactTypeId] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentAttendanceRates_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentAttendanceRates_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_CountDateId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_CountDateId] FOREIGN KEY ([CountDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId] FOREIGN KEY ([EconomicallyDisadvantagedStatusId]) REFERENCES [RDS].[DimEconomicallyDisadvantagedStatuses] ([DimEconomicallyDisadvantagedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_IeuId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	-- PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_K12StudentStatusId]...';


	-- 
	-- ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
	-- 	ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12StudentStatusId] FOREIGN KEY ([K12StudentStatusId]) REFERENCES [RDS].[DimK12StudentStatuses] ([DimK12StudentstatusId]);


	-- 
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_LeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_LeaId] FOREIGN KEY ([LeaId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId] FOREIGN KEY ([NcesSideVintageBeginYearDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId] FOREIGN KEY ([NcesSideVintageEndYearDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_PersonAddressId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_PersonAddressId] FOREIGN KEY ([PersonAddressId]) REFERENCES [RDS].[DimPersonAddresses] ([DimPersonAddressId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactK12StudentEconomicDisadvantages_SeaId]...';


	
	ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH NOCHECK
		ADD CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses] FOREIGN KEY ([SchoolPerformanceIndicatorStateDefinedStatusId]) REFERENCES [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses] ([DimSchoolPerformanceIndicatorStateDefinedStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimFactTypes]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes] FOREIGN KEY ([FactTypeId]) REFERENCES [RDS].[DimFactTypes] ([DimFactTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimIdeaStatuses]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators] FOREIGN KEY ([SchoolPerformanceIndicatorId]) REFERENCES [RDS].[DimSchoolPerformanceIndicators] ([DimSchoolPerformanceIndicatorId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimK12Demographics]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSchoolPerformanceIndicators_DimRaces]...';


	
	ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId] FOREIGN KEY ([ChildOutcomeSummaryAtExitId]) REFERENCES [RDS].[DimChildOutcomeSummaries] ([DimChildOutcomeSummaryId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId] FOREIGN KEY ([ChildOutcomeSummaryBaselineId]) REFERENCES [RDS].[DimChildOutcomeSummaries] ([DimChildOutcomeSummaryId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId] FOREIGN KEY ([ChildOutcomeSummaryDateAtExitId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId] FOREIGN KEY ([ChildOutcomeSummaryDateBaselineId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ConsentToEvaluationDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ConsentToEvaluationDateId] FOREIGN KEY ([ConsentToEvaluationDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_CteStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_CteStatusId] FOREIGN KEY ([CteStatusId]) REFERENCES [RDS].[DimCteStatuses] ([DimCteStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_DataCollectionId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_DataCollectionId] FOREIGN KEY ([DataCollectionId]) REFERENCES [RDS].[DimDataCollections] ([DimDataCollectionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EligibilityEvaluationDateInitialId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateInitialId] FOREIGN KEY ([EligibilityEvaluationDateInitialId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId] FOREIGN KEY ([EligibilityEvaluationDateReevaluationId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EnglishLearnerStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EnglishLearnerStatusId] FOREIGN KEY ([EnglishLearnerStatusId]) REFERENCES [RDS].[DimEnglishLearnerStatuses] ([DimEnglishLearnerStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EnrollmentEntryDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EnrollmentEntryDateId] FOREIGN KEY ([EnrollmentEntryDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EnrollmentExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EnrollmentExitDateId] FOREIGN KEY ([EnrollmentExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_EntryGradeLevelId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_EntryGradeLevelId] FOREIGN KEY ([EntryGradeLevelId]) REFERENCES [RDS].[DimGradeLevels] ([DimGradeLevelId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_FosterCareStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_FosterCareStatusId] FOREIGN KEY ([FosterCareStatusId]) REFERENCES [RDS].[DimFosterCareStatuses] ([DimFosterCareStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_HomelessnessStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_HomelessnessStatusId] FOREIGN KEY ([HomelessnessStatusId]) REFERENCES [RDS].[DimHomelessnessStatuses] ([DimHomelessnessStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IdeaStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IdeaStatusId] FOREIGN KEY ([IdeaStatusId]) REFERENCES [RDS].[DimIdeaStatuses] ([DimIdeaStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IeuId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IeuId] FOREIGN KEY ([IeuId]) REFERENCES [RDS].[DimIeus] ([DimIeuId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ImmigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ImmigrantStatusId] FOREIGN KEY ([ImmigrantStatusId]) REFERENCES [RDS].[DimImmigrantStatuses] ([DimImmigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramDateId] FOREIGN KEY ([IndividualizedProgramDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId] FOREIGN KEY ([IndividualizedProgramServicePlanDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId] FOREIGN KEY ([IndividualizedProgramServicePlanExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId] FOREIGN KEY ([IndividualizedProgramServicePlanReevaluationDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_IndividualizedProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramStatusId] FOREIGN KEY ([IndividualizedProgramStatusId]) REFERENCES [RDS].[DimIndividualizedProgramStatuses] ([DimIndividualizedProgramStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_K12DemographicId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_K12DemographicId] FOREIGN KEY ([K12DemographicId]) REFERENCES [RDS].[DimK12Demographics] ([DimK12DemographicId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_K12EnrollmentStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_K12EnrollmentStatusId] FOREIGN KEY ([K12EnrollmentStatusId]) REFERENCES [RDS].[DimK12EnrollmentStatuses] ([DimK12EnrollmentStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_K12SchoolId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_K12SchoolId] FOREIGN KEY ([K12SchoolId]) REFERENCES [RDS].[DimK12Schools] ([DimK12SchoolId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_K12StudentId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_K12StudentId] FOREIGN KEY ([K12StudentId]) REFERENCES [RDS].[DimPeople] ([DimPersonId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaAccountabilityId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaAccountabilityId] FOREIGN KEY ([LeaAccountabilityId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaAttendanceId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaAttendanceId] FOREIGN KEY ([LeaAttendanceId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaFundingId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaFundingId] FOREIGN KEY ([LeaFundingId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaGraduationId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaGraduationId] FOREIGN KEY ([LeaGraduationId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaIndividualizedEducationProgramId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaIndividualizedEducationProgramId] FOREIGN KEY ([LeaIndividualizedEducationProgramId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_LeaIEPServiceProviderId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_LeaIEPServiceProviderId] FOREIGN KEY ([LeaIEPServiceProviderId]) REFERENCES [RDS].[DimLeas] ([DimLeaID]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_MigrantStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_MigrantStatusId] FOREIGN KEY ([MigrantStatusId]) REFERENCES [RDS].[DimMigrantStatuses] ([DimMigrantStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_MilitaryStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_MilitaryStatusId] FOREIGN KEY ([MilitaryStatusId]) REFERENCES [RDS].[DimMilitaryStatuses] ([DimMilitaryStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_NOrDStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_NOrDStatusId] FOREIGN KEY ([NOrDStatusId]) REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_PrimaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_PrimaryDisabilityTypeId] FOREIGN KEY ([PrimaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ProgramParticipationStartDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ProgramParticipationStartDateId] FOREIGN KEY ([ProgramParticipationStartDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ProgramStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ProgramStatusId] FOREIGN KEY ([DisabilityStatusId]) REFERENCES [RDS].[DimDisabilityStatuses] ([DimDisabilityStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_ResponsibleSchoolTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_ResponsibleSchoolTypeId] FOREIGN KEY ([ResponsibleSchoolTypeId]) REFERENCES [RDS].[DimResponsibleSchoolTypes] ([DimResponsibleSchoolTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_SchoolYearId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_SchoolYearId] FOREIGN KEY ([SchoolYearId]) REFERENCES [RDS].[DimSchoolYears] ([DimSchoolYearId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_SeaId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_SeaId] FOREIGN KEY ([SeaId]) REFERENCES [RDS].[DimSeas] ([DimSeaId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_SecondaryDisabilityTypeId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_SecondaryDisabilityTypeId] FOREIGN KEY ([SecondaryDisabilityTypeId]) REFERENCES [RDS].[DimIdeaDisabilityTypes] ([DimIdeaDisabilityTypeId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_SpecialEducationServicesExitDateId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_SpecialEducationServicesExitDateId] FOREIGN KEY ([SpecialEducationServicesExitDateId]) REFERENCES [RDS].[DimDates] ([DimDateId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_TitleIIIStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_TitleIIIStatusId] FOREIGN KEY ([TitleIIIStatusId]) REFERENCES [RDS].[DimTitleIIIStatuses] ([DimTitleIIIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_FactSpecialEducation_TitleIStatusId]...';


	
	ALTER TABLE [RDS].[FactSpecialEducation] WITH NOCHECK
		ADD CONSTRAINT [FK_FactSpecialEducation_TitleIStatusId] FOREIGN KEY ([TitleIStatusId]) REFERENCES [RDS].[DimTitleIStatuses] ([DimTitleIStatusId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleQuestionOptions_ToggleQuestions_ToggleQuestionId]...';


	
	ALTER TABLE [RDS].[ToggleQuestionOptions] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleQuestionOptions_ToggleQuestions_ToggleQuestionId] FOREIGN KEY ([ToggleQuestionId]) REFERENCES [RDS].[ToggleQuestions] ([ToggleQuestionId]) ON DELETE CASCADE;


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleQuestions_ToggleQuestions_ParentToggleQuestionId]...';


	
	ALTER TABLE [RDS].[ToggleQuestions] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleQuestions_ToggleQuestions_ParentToggleQuestionId] FOREIGN KEY ([ParentToggleQuestionId]) REFERENCES [RDS].[ToggleQuestions] ([ToggleQuestionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleQuestions_ToggleQuestionTypes_ToggleQuestionTypeId]...';


	
	ALTER TABLE [RDS].[ToggleQuestions] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleQuestions_ToggleQuestionTypes_ToggleQuestionTypeId] FOREIGN KEY ([ToggleQuestionTypeId]) REFERENCES [RDS].[ToggleQuestionTypes] ([ToggleQuestionTypeId]) ON DELETE CASCADE;


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleQuestions_ToggleSections_ToggleSectionId]...';


	
	ALTER TABLE [RDS].[ToggleQuestions] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleQuestions_ToggleSections_ToggleSectionId] FOREIGN KEY ([ToggleSectionId]) REFERENCES [RDS].[ToggleSections] ([ToggleSectionId]) ON DELETE CASCADE;


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleResponses_ToggleQuestionOptions_ToggleQuestionOptionId]...';


	
	ALTER TABLE [RDS].[ToggleResponses] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleResponses_ToggleQuestionOptions_ToggleQuestionOptionId] FOREIGN KEY ([ToggleQuestionOptionId]) REFERENCES [RDS].[ToggleQuestionOptions] ([ToggleQuestionOptionId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleResponses_ToggleQuestions_ToggleQuestionId]...';


	
	ALTER TABLE [RDS].[ToggleResponses] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleResponses_ToggleQuestions_ToggleQuestionId] FOREIGN KEY ([ToggleQuestionId]) REFERENCES [RDS].[ToggleQuestions] ([ToggleQuestionId]) ON DELETE CASCADE;


	
	PRINT N'Creating Foreign Key [RDS].[FK_ToggleSections_ToggleSectionTypes_ToggleSectionTypeId]...';


	
	ALTER TABLE [RDS].[ToggleSections] WITH NOCHECK
		ADD CONSTRAINT [FK_ToggleSections_ToggleSectionTypes_ToggleSectionTypeId] FOREIGN KEY ([ToggleSectionTypeId]) REFERENCES [RDS].[ToggleSectionTypes] ([ToggleSectionTypeId]) ON DELETE CASCADE;


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12ProgramParticipationRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgeK12StudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Creating Foreign Key [RDS].[FK_BridgePsStudentEnrollmentRaces_RaceId]...';


	
	ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] WITH NOCHECK
		ADD CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_RaceId] FOREIGN KEY ([RaceId]) REFERENCES [RDS].[DimRaces] ([DimRaceId]);


	
	PRINT N'Altering View [RDS].[vwDimGradeLevels]...';


	


	

-- CIID-5765 JW
alter table RDS.DimK12StudentStatuses 
	drop 
		column PlacementStatusCode,
		column PlacementStatusDescription,
		column PlacementStatusEdFactsCode,
		column PlacementStatusId,
		column PlacementTypeCode,
		column PlacementTypeDescription,
		column PlacementTypeEdFactsCode,
		column PlacementTypeId

-- CIID-5765 JW
alter table RDS.ReportEdFactsK12StudentCounts
	drop
		column PLACEMENTSTATUS,
		column PLACEMENTTYPE



	PRINT N'Update complete.';


	