
DECLARE @sql as nvarchar(max)

IF NOT EXISTS(select 1 from sys.columns where name = 'DoNotPublishIndicator' AND Object_ID = Object_ID(N'dbo.PersonTelephone'))
BEGIN

PRINT N'Starting rebuilding table [dbo].[K12Sea]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12Sea] (
	[K12SeaId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NOT NULL,
	[RefStateANSICodeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_XPKK12Sea1] PRIMARY KEY CLUSTERED ([K12SeaId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12Sea])
	BEGIN

		SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12Sea] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12Sea] ([K12SeaId], [OrganizationId], [RefStateANSICodeId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12Sea].[K12SeaId],
				 [K12Sea].[OrganizationId],
				 [RefStateANSICode].[RefStateANSICodeId],
				 [K12Sea].[RecordStartDateTime],
				 [K12Sea].[RecordEndDateTime]
		FROM     [dbo].[K12Sea]
		'
				

		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'K12Sea' AND COLUMN_NAME = 'RefStateANSICode')
		BEGIN
			
			SET @sql = @sql + '
			INNER JOIN [dbo].[RefStateANSICode] ON [RefStateANSICode].[Code] = [K12Sea].[RefStateANSICode]
			'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			INNER JOIN [dbo].[RefStateANSICode] ON [RefStateANSICode].[Code] = [K12Sea].[RefStateANSICodeId]
			'

		END

		SET @sql = @sql + '
			ORDER BY [K12SeaId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12Sea] OFF;
		'		

		EXEC sp_executesql @sql


	END

DROP TABLE [dbo].[K12Sea];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12Sea]', N'K12Sea';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_XPKK12Sea1]', N'XPKK12Sea', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12StaffAssignment]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12StaffAssignment] (
	[K12StaffAssignmentId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationPersonRoleId]                       INT             NOT NULL,
	[PrimaryAssignment]                       BIT             NULL,
	[TeacherOfRecord]                       BIT             NULL,
	[FullTimeEquivalency]                       DECIMAL(5, 4)             NULL,
	[ContributionPercentage]                       DECIMAL(5, 2)             NULL,
	[ItinerantTeacher]                       BIT             NULL,
	[HighlyQualifiedTeacherIndicator]                       BIT             NULL,
	[SpecialEducationTeacher]                       BIT             NULL,
	[SpecialEducationRelatedServicesPersonnel]                       BIT             NULL,
	[SpecialEducationParaprofessional]                       BIT             NULL,
	[RefK12StaffClassificationId]                       INT             NULL,
	[RefProfessionalEducationJobClassificationId]                       INT             NULL,
	[RefTeachingAssignmentRoleId]                       INT             NULL,
	[RefClassroomPositionTypeId]                       INT             NULL,
	[RefSpecialEducationStaffCategoryId]                       INT             NULL,
	[RefSpecialEducationAgeGroupTaughtId]                       INT             NULL,
	[RefMepStaffCategoryId]                       INT             NULL,
	[RefTitleIProgramStaffCategoryId]                       INT             NULL,
	[RefUnexperiencedStatusId]                       INT             NULL,
	[RefEmergencyOrProvisionalCredentialStatusId]                       INT             NULL,
	[RefOutOfFieldStatusId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12StaffAssignmentId1] PRIMARY KEY CLUSTERED ([K12StaffAssignmentId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12StaffAssignment])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StaffAssignment] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12StaffAssignment] ([K12StaffAssignmentId], [OrganizationPersonRoleId], [PrimaryAssignment], [TeacherOfRecord], [FullTimeEquivalency], [ContributionPercentage], [ItinerantTeacher], [HighlyQualifiedTeacherIndicator], [SpecialEducationTeacher], [SpecialEducationRelatedServicesPersonnel], [SpecialEducationParaprofessional], [RefK12StaffClassificationId], [RefProfessionalEducationJobClassificationId], [RefTeachingAssignmentRoleId], [RefClassroomPositionTypeId], [RefSpecialEducationStaffCategoryId], [RefSpecialEducationAgeGroupTaughtId], [RefMepStaffCategoryId], [RefTitleIProgramStaffCategoryId], [RefUnexperiencedStatusId], [RefEmergencyOrProvisionalCredentialStatusId], [RefOutOfFieldStatusId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12StaffAssignmentId],
				 [OrganizationPersonRoleId],
				 [PrimaryAssignment],
				 [TeacherOfRecord],
				 [FullTimeEquivalency],
				 [ContributionPercentage],
				 [ItinerantTeacher],
				 [HighlyQualifiedTeacherIndicator],
				 [SpecialEducationTeacher],
				 [SpecialEducationRelatedServicesPersonnel],
				 [SpecialEducationParaprofessional],
				 [RefK12StaffClassificationId],
				 [RefProfessionalEducationJobClassificationId],
				 [RefTeachingAssignmentRoleId],
				 [RefClassroomPositionTypeId],
				 [RefSpecialEducationStaffCategoryId],
				 [RefSpecialEducationAgeGroupTaughtId],
				 [RefMepStaffCategoryId],
				 [RefTitleIProgramStaffCategoryId],
				 [RefUnexperiencedStatusId],
				 [RefEmergencyOrProvisionalCredentialStatusId],
				 [RefOutOfFieldStatusId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12StaffAssignment]
		ORDER BY [K12StaffAssignmentId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StaffAssignment] OFF;
	END

DROP TABLE [dbo].[K12StaffAssignment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12StaffAssignment]', N'K12StaffAssignment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12StaffAssignmentId1]', N'PK_K12StaffAssignmentId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12StaffEmployment]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12StaffEmployment] (
	[K12StaffEmploymentId]                       INT            IDENTITY (1, 1) NOT NULL,
	[StaffEmploymentId]                       INT             NOT NULL,
	[ContractDaysOfServicePerYear]                       DECIMAL(5, 2)             NULL,
	[StaffCompensationBaseSalary]                       DECIMAL(9, 2)             NULL,
	[StaffCompensationRetirementBenefits]                       DECIMAL(9, 2)             NULL,
	[StaffCompensationHealthBenefits]                       DECIMAL(9, 2)             NULL,
	[StaffCompensationOtherBenefits]                       DECIMAL(9, 2)             NULL,
	[StaffCompensationTotalBenefits]                       DECIMAL(9, 2)             NULL,
	[StaffCompensationTotalSalary]                       DECIMAL(9, 2)             NULL,
	[MepPersonnelIndicator]                       BIT             NULL,
	[TitleITargetedAssistanceStaffFunded]                       BIT             NULL,
	[SalaryForTeachingAssignmentOnlyIndicator]                       BIT             NULL,
	[RefK12StaffClassificationId]                       INT             NULL,
	[RefEmploymentStatusId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12StaffEmployment1] PRIMARY KEY CLUSTERED ([K12StaffEmploymentId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12StaffEmployment])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StaffEmployment] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12StaffEmployment] ([K12StaffEmploymentId], [StaffEmploymentId], [ContractDaysOfServicePerYear], [StaffCompensationBaseSalary], [StaffCompensationRetirementBenefits], [StaffCompensationHealthBenefits], [StaffCompensationOtherBenefits], [StaffCompensationTotalBenefits], [StaffCompensationTotalSalary], [MepPersonnelIndicator], [TitleITargetedAssistanceStaffFunded], [SalaryForTeachingAssignmentOnlyIndicator], [RefK12StaffClassificationId], [RefEmploymentStatusId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [K12StaffEmploymentId],
				 [StaffEmploymentId],
				 [ContractDaysOfServicePerYear],
				 [StaffCompensationBaseSalary],
				 [StaffCompensationRetirementBenefits],
				 [StaffCompensationHealthBenefits],
				 [StaffCompensationOtherBenefits],
				 [StaffCompensationTotalBenefits],
				 [StaffCompensationTotalSalary],
				 [MepPersonnelIndicator],
				 [TitleITargetedAssistanceStaffFunded],
				 [SalaryForTeachingAssignmentOnlyIndicator],
				 [RefK12StaffClassificationId],
				 [RefEmploymentStatusId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12StaffEmployment]
		ORDER BY [K12StaffEmploymentId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StaffEmployment] OFF;
	END

DROP TABLE [dbo].[K12StaffEmployment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12StaffEmployment]', N'K12StaffEmployment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12StaffEmployment1]', N'PK_K12StaffEmployment', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[K12StudentEnrollment]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_K12StudentEnrollment] (
	[K12StudentEnrollmentId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationPersonRoleId]                       INT             NOT NULL,
	[DisplacedStudentStatus]                       BIT             NULL,
	[FirstEntryDateIntoUSSchool]                       DATE             NULL,
	[NSLPDirectCertificationIndicator]                       BIT             NULL,
	[RefEntryGradeLevelId]                       INT             NULL,
	[RefPublicSchoolResidence]                       INT             NULL,
	[RefEnrollmentStatusId]                       INT             NULL,
	[RefEntryType]                       INT             NULL,
	[RefExitGradeLevelId]                       INT             NULL,
	[RefExitOrWithdrawalStatusId]                       INT             NULL,
	[RefExitOrWithdrawalTypeId]                       INT             NULL,
	[RefEndOfTermStatusId]                       INT             NULL,
	[RefPromotionReasonId]                       INT             NULL,
	[RefNonPromotionReasonId]                       INT             NULL,
	[RefFoodServiceEligibilityId]                       INT             NULL,
	[RefDirectoryInformationBlockStatusId]                       INT             NULL,
	[RefStudentEnrollmentAccessTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_K12StudentEnrollment1] PRIMARY KEY CLUSTERED ([K12StudentEnrollmentId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[K12StudentEnrollment])
	BEGIN

		SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StudentEnrollment] ON;
		INSERT INTO [dbo].[tmp_ms_xx_K12StudentEnrollment] ([K12StudentEnrollmentId], [OrganizationPersonRoleId], [DisplacedStudentStatus], [FirstEntryDateIntoUSSchool], [NSLPDirectCertificationIndicator], [RefEntryGradeLevelId], [RefPublicSchoolResidence], [RefEnrollmentStatusId], [RefEntryType], [RefExitGradeLevelId], [RefExitOrWithdrawalStatusId], [RefExitOrWithdrawalTypeId], [RefEndOfTermStatusId], [RefPromotionReasonId], [RefNonPromotionReasonId], [RefFoodServiceEligibilityId], [RefDirectoryInformationBlockStatusId], [RefStudentEnrollmentAccessTypeId], [RecordStartDateTime], [RecordEndDateTime])
		'
				

		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'K12StudentEnrollment' AND COLUMN_NAME = 'RefExitGradeLevel')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [K12StudentEnrollmentId],
				 [OrganizationPersonRoleId],
				 [DisplacedStudentStatus],
				 [FirstEntryDateIntoUSSchool],
				 [NSLPDirectCertificationIndicator],
				 [RefEntryGradeLevelId],
				 [RefPublicSchoolResidence],
				 [RefEnrollmentStatusId],
				 [RefEntryType],
				 [RefExitGradeLevel],
				 [RefExitOrWithdrawalStatusId],
				 [RefExitOrWithdrawalTypeId],
				 [RefEndOfTermStatusId],
				 [RefPromotionReasonId],
				 [RefNonPromotionReasonId],
				 [RefFoodServiceEligibilityId],
				 [RefDirectoryInformationBlockStatusId],
				 [RefStudentEnrollmentAccessTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12StudentEnrollment]
		ORDER BY [K12StudentEnrollmentId] ASC;
			'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [K12StudentEnrollmentId],
				 [OrganizationPersonRoleId],
				 [DisplacedStudentStatus],
				 [FirstEntryDateIntoUSSchool],
				 [NSLPDirectCertificationIndicator],
				 [RefEntryGradeLevelId],
				 [RefPublicSchoolResidence],
				 [RefEnrollmentStatusId],
				 [RefEntryType],
				 [RefExitGradeLevelId],
				 [RefExitOrWithdrawalStatusId],
				 [RefExitOrWithdrawalTypeId],
				 [RefEndOfTermStatusId],
				 [RefPromotionReasonId],
				 [RefNonPromotionReasonId],
				 [RefFoodServiceEligibilityId],
				 [RefDirectoryInformationBlockStatusId],
				 [RefStudentEnrollmentAccessTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[K12StudentEnrollment]
		ORDER BY [K12StudentEnrollmentId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_K12StudentEnrollment] OFF;
		'		

		EXEC sp_executesql @sql

	END

DROP TABLE [dbo].[K12StudentEnrollment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_K12StudentEnrollment]', N'K12StudentEnrollment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_K12StudentEnrollment1]', N'PK_K12StudentEnrollment', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;



PRINT N'Creating [dbo].[K12StudentEnrollment].[IX_OrganizationPersonRoleId]...';



CREATE  NONCLUSTERED INDEX [IX_OrganizationPersonRoleId]
	ON [dbo].[K12StudentEnrollment]([OrganizationPersonRoleId] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];




PRINT N'Altering [dbo].[LocationAddress]...';



ALTER TABLE [dbo].[LocationAddress]
    ALTER COLUMN 
	[StreetNumberAndName]                       NVARCHAR(150)             NULL;



ALTER TABLE [dbo].[LocationAddress]
    ALTER COLUMN 
	[ApartmentRoomOrSuiteNumber]                       NVARCHAR(60)             NULL;



ALTER TABLE [dbo].[LocationAddress]
    ALTER COLUMN 
	[BuildingSiteNumber]                       NVARCHAR(60)             NULL;



PRINT N'Altering [dbo].[LocationAddress]...';



ALTER TABLE [dbo].[LocationAddress]
    ADD 
		[DoNotPublishIndicator] BIT  NULL;



PRINT N'Starting rebuilding table [dbo].[OrganizationDetail]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_OrganizationDetail] (
	[OrganizationDetailId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NOT NULL,
	[Name]                       NVARCHAR (128)             NULL,
	[ShortName]                       NVARCHAR (30)             NULL,
	[RegionGeoJSON]                       NVARCHAR(2000)             NULL,
	[RefOrganizationTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_OrganizationDetail1] PRIMARY KEY CLUSTERED ([OrganizationDetailId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[OrganizationDetail])
	BEGIN
		
		
		SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrganizationDetail] ON;
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Organization' AND COLUMN_NAME = 'RegionGeoJSON')
		BEGIN
			
			SET @sql = @sql + '
				INSERT INTO [dbo].[tmp_ms_xx_OrganizationDetail] ([OrganizationDetailId], [OrganizationId], [Name], [ShortName], [RegionGeoJSON], [RefOrganizationTypeId], [RecordStartDateTime], [RecordEndDateTime])
				SELECT   
					 [OrganizationDetail].[OrganizationDetailId],
					 [OrganizationDetail].[OrganizationId],
					 [OrganizationDetail].[Name],
					 [OrganizationDetail].[ShortName],
					 [Organization].[RegionGeoJSON],
					 [OrganizationDetail].[RefOrganizationTypeId],
					 [OrganizationDetail].[RecordStartDateTime],
					 [OrganizationDetail].[RecordEndDateTime]
			FROM     [dbo].[OrganizationDetail]
				LEFT OUTER JOIN [dbo].[Organization] ON [Organization].[OrganizationId] = [OrganizationDetail].[OrganizationId]
			ORDER BY [OrganizationDetailId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				INSERT INTO [dbo].[tmp_ms_xx_OrganizationDetail] ([OrganizationDetailId], [OrganizationId], [Name], [ShortName], [RefOrganizationTypeId], [RecordStartDateTime], [RecordEndDateTime])
				SELECT   
					 [OrganizationDetail].[OrganizationDetailId],
					 [OrganizationDetail].[OrganizationId],
					 [OrganizationDetail].[Name],
					 [OrganizationDetail].[ShortName],
					 [OrganizationDetail].[RefOrganizationTypeId],
					 [OrganizationDetail].[RecordStartDateTime],
					 [OrganizationDetail].[RecordEndDateTime]
			FROM     [dbo].[OrganizationDetail]
				LEFT OUTER JOIN [dbo].[Organization] ON [Organization].[OrganizationId] = [OrganizationDetail].[OrganizationId]
			ORDER BY [OrganizationDetailId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrganizationDetail] OFF;
		'		

		EXEC sp_executesql @sql

	END

DROP TABLE [dbo].[OrganizationDetail];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_OrganizationDetail]', N'OrganizationDetail';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_OrganizationDetail1]', N'PK_OrganizationDetail', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT '--NOTE: Adjustments may be needed to JOIN condition for data moved to OrganizationDetail.'

PRINT N'Altering [dbo].[Organization]...';



ALTER TABLE [dbo].[Organization]
    DROP COLUMN 
		[RegionGeoJSON];



PRINT N'Altering [dbo].[OrganizationEmail]...';



ALTER TABLE [dbo].[OrganizationEmail]
    ADD 
		[DoNotPublishIndicator] BIT  NULL;



PRINT N'Starting rebuilding table [dbo].[OrganizationFederalAccountability]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_OrganizationFederalAccountability] (
	[OrganizationFederalAccountabilityId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationId]                       INT             NOT NULL,
	[AlternateAypApproachIndicator]                       BIT             NULL,
	[AypAppealChangedDesignation]                       BIT             NULL,
	[AypAppealProcessDate]                       DATE             NULL,
	[AypAppealProcessDesignation]                       BIT             NULL,
	[AmaoAypProgressAttainmentLepStudents]                       INT             NULL,
	[AmaoProficiencyAttainmentLepStudents]                       INT             NULL,
	[AmaoProgressAttainmentLepStudents]                       INT             NULL,
	[PersistentlyDangerousStatus]                       BIT             NULL,
	[AccountabilityReportTitle]                       NVARCHAR (80)             NULL,
	[RefAypStatusId]                       INT             NULL,
	[RefGunFreeSchoolsActReportingStatusId]                       INT             NULL,
	[RefHighSchoolGraduationRateIndicatorId]                       INT             NULL,
	[RefParticipationStatusMathId]                       INT             NULL,
	[RefParticipationStatusRlaId]                       INT             NULL,
	[RefProficiencyTargetStatusMathId]                       INT             NULL,
	[RefProficiencyTargetStatusRLAId]                       INT             NULL,
	[RefReconstitutedStatusId]                       INT             NULL,
	[RefElementaryMiddleAdditionalId]                       INT             NULL,
	[RefCteGraduationRateInclusionId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	[RefAdditionalTargetedSupportAndImprovementStatusId]                       INT             NULL,
	[RefComprehensiveSupportAndImprovementStatusId]                       INT             NULL,
	[RefTargetedSupportAndImprovementStatusId]                       INT             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_OrganizationFederalAccountability1] PRIMARY KEY CLUSTERED ([OrganizationFederalAccountabilityId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[OrganizationFederalAccountability])
	BEGIN

		SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrganizationFederalAccountability] ON;
		INSERT INTO [dbo].[tmp_ms_xx_OrganizationFederalAccountability] ([OrganizationFederalAccountabilityId], [OrganizationId], [AlternateAypApproachIndicator], [AypAppealChangedDesignation], [AypAppealProcessDate], [AypAppealProcessDesignation], [AmaoAypProgressAttainmentLepStudents], [AmaoProficiencyAttainmentLepStudents], [AmaoProgressAttainmentLepStudents], [PersistentlyDangerousStatus], [AccountabilityReportTitle], [RefAypStatusId], [RefGunFreeSchoolsActReportingStatusId], [RefHighSchoolGraduationRateIndicatorId], [RefParticipationStatusMathId], [RefParticipationStatusRlaId], [RefProficiencyTargetStatusMathId], [RefProficiencyTargetStatusRLAId], [RefReconstitutedStatusId], [RefElementaryMiddleAdditionalId], [RefCteGraduationRateInclusionId], [RecordStartDateTime], [RecordEndDateTime])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'OrganizationFederalAccountability' AND COLUMN_NAME = 'RefGunFreeSchoolsActStatusReportingId')
		BEGIN
			
			SET @sql = @sql + '
				SELECT   
				 [OrganizationFederalAccountabilityId],
				 [OrganizationId],
				 [AlternateAypApproachIndicator],
				 [AypAppealChangedDesignation],
				 [AypAppealProcessDate],
				 [AypAppealProcessDesignation],
				 [AmaoAypProgressAttainmentLepStudents],
				 [AmaoProficiencyAttainmentLepStudents],
				 [AmaoProgressAttainmentLepStudents],
				 [PersistentlyDangerousStatus],
				 [AccountabilityReportTitle],
				 [RefAypStatusId],
				 [RefGunFreeSchoolsActStatusReportingId],
				 [RefHighSchoolGraduationRateIndicator],
				 [RefParticipationStatusMathId],
				 [RefParticipationStatusRlaId],
				 [RefProficiencyTargetStatusMathId],
				 [RefProficiencyTargetStatusRLAId],
				 [RefReconstitutedStatusId],
				 [RefElementaryMiddleAdditionalId],
				 [RefCteGraduationRateInclusionId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[OrganizationFederalAccountability]
		ORDER BY [OrganizationFederalAccountabilityId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				SELECT   
				 [OrganizationFederalAccountabilityId],
				 [OrganizationId],
				 [AlternateAypApproachIndicator],
				 [AypAppealChangedDesignation],
				 [AypAppealProcessDate],
				 [AypAppealProcessDesignation],
				 [AmaoAypProgressAttainmentLepStudents],
				 [AmaoProficiencyAttainmentLepStudents],
				 [AmaoProgressAttainmentLepStudents],
				 [PersistentlyDangerousStatus],
				 [AccountabilityReportTitle],
				 [RefAypStatusId],
				 [RefGunFreeSchoolsActReportingStatusId],
				 [RefHighSchoolGraduationRateIndicator],
				 [RefParticipationStatusMathId],
				 [RefParticipationStatusRlaId],
				 [RefProficiencyTargetStatusMathId],
				 [RefProficiencyTargetStatusRLAId],
				 [RefReconstitutedStatusId],
				 [RefElementaryMiddleAdditionalId],
				 [RefCteGraduationRateInclusionId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[OrganizationFederalAccountability]
		ORDER BY [OrganizationFederalAccountabilityId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_OrganizationFederalAccountability] OFF;
		'		

		EXEC sp_executesql @sql
		
	END

DROP TABLE [dbo].[OrganizationFederalAccountability];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_OrganizationFederalAccountability]', N'OrganizationFederalAccountability';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_OrganizationFederalAccountability1]', N'PK_OrganizationFederalAccountability', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[OrganizationTelephone]...';



ALTER TABLE [dbo].[OrganizationTelephone]
    ADD 
		[DoNotPublishIndicator] BIT  NULL,
		[RefTelephoneNumberListedStatusId] INT  NULL;



PRINT N'Altering [dbo].[PersonAddress]...';



ALTER TABLE [dbo].[PersonAddress]
    ALTER COLUMN 
	[StreetNumberAndName]                       NVARCHAR(150)             NULL;



ALTER TABLE [dbo].[PersonAddress]
    ALTER COLUMN 
	[ApartmentRoomOrSuiteNumber]                       NVARCHAR(60)             NULL;



PRINT N'Altering [dbo].[PersonAddress]...';



ALTER TABLE [dbo].[PersonAddress]
    ADD 
		[DoNotPublishIndicator] BIT  NULL;



PRINT N'Altering [dbo].[PersonEmailAddress]...';



ALTER TABLE [dbo].[PersonEmailAddress]
    ADD 
		[DoNotPublishIndicator] BIT  NULL;



PRINT N'Altering [dbo].[PersonProgramParticipation]...';



ALTER TABLE [dbo].[PersonProgramParticipation]
    ADD 
		[RefProgramEntryReasonId] INT  NULL;



PRINT N'Starting rebuilding table [dbo].[PersonRelationship]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_PersonRelationship] (
	[PersonRelationshipId]                       INT            IDENTITY (1, 1) NOT NULL,
	[PersonId]                       INT             NOT NULL,
	[RelatedPersonId]                       INT             NOT NULL,
	[CustodialRelationshipIndicator]                       BIT             NULL,
	[EmergencyContactInd]                       BIT             NULL,
	[ContactPriorityNumber]                       INT             NULL,
	[ContactRestrictions]                       NVARCHAR (2000)             NULL,
	[LivesWithIndicator]                       BIT             NULL,
	[PrimaryContactIndicator]                       BIT             NULL,
	[RefPersonRelationshipTypeId]                       INT             NOT NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_XPKPersonRelationship1] PRIMARY KEY CLUSTERED ([PersonRelationshipId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[PersonRelationship])
	BEGIN
		
		SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PersonRelationship] ON;
		INSERT INTO [dbo].[tmp_ms_xx_PersonRelationship] ([PersonRelationshipId], [PersonId], [RelatedPersonId], [CustodialRelationshipIndicator], [EmergencyContactInd], [ContactPriorityNumber], [ContactRestrictions], [LivesWithIndicator], [PrimaryContactIndicator], [RefPersonRelationshipTypeId], [RecordStartDateTime], [RecordEndDateTime])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'PersonRelationship' AND COLUMN_NAME = 'RefPersonRelationshipId')
		BEGIN
			
			SET @sql = @sql + '
				SELECT   
				 [PersonRelationshipId],
				 [PersonId],
				 [RelatedPersonId],
				 [CustodialRelationshipIndicator],
				 [EmergencyContactInd],
				 [ContactPriorityNumber],
				 [ContactRestrictions],
				 [LivesWithIndicator],
				 [PrimaryContactIndicator],
				 [RefPersonRelationshipId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
			FROM     [dbo].[PersonRelationship]
			ORDER BY [PersonRelationshipId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				SELECT   
				 [PersonRelationshipId],
				 [PersonId],
				 [RelatedPersonId],
				 [CustodialRelationshipIndicator],
				 [EmergencyContactInd],
				 [ContactPriorityNumber],
				 [ContactRestrictions],
				 [LivesWithIndicator],
				 [PrimaryContactIndicator],
				 [RefPersonRelationshipTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
			FROM  [dbo].[PersonRelationship]
			ORDER BY [PersonRelationshipId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PersonRelationship] OFF;
		'		

		EXEC sp_executesql @sql

		
	END

DROP TABLE [dbo].[PersonRelationship];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_PersonRelationship]', N'PersonRelationship';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_XPKPersonRelationship1]', N'XPKPersonRelationship', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[PersonTelephone]...';



ALTER TABLE [dbo].[PersonTelephone]
    ADD 
		[DoNotPublishIndicator] BIT  NULL,
		[RefTelephoneNumberListedStatusId] INT  NULL;



PRINT N'Starting rebuilding table [dbo].[ProfessionalDevelopmentActivity]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_ProfessionalDevelopmentActivity] (
	[ProfessionalDevelopmentActivityId]                       INT            IDENTITY (1, 1) NOT NULL,
	[ProfessionalDevelopmentRequirementId]                       INT             NOT NULL,
	[CourseId]                       INT             NULL,
	[Title]                       NVARCHAR (60)             NULL,
	[ActivityIdentifier]                       NVARCHAR (40)             NULL,
	[Description]                       NVARCHAR (2000)             NULL,
	[Objective]                       NVARCHAR (2000)             NULL,
	[ActivityCode]                       NVARCHAR (30)             NULL,
	[ApprovalCode]                       NVARCHAR (30)             NULL,
	[Cost]                       DECIMAL(6, 2)             NULL,
	[Credits]                       DECIMAL(6, 2)             NULL,
	[ScholarshipStatus]                       BIT             NULL,
	[PublishIndicator]                       BIT             NULL,
	[ProfessionalDevelopmentActivityStateApprovedStatus]                       BIT             NULL,
	[RefCourseCreditUnitId]                       INT             NULL,
	[RefProfessionalDevelopmentFinancialSupportId]                       INT             NULL,
	[RefPDAudienceTypeId]                       INT             NULL,
	[RefPDActivityApprovedPurposeId]                       INT             NULL,
	[RefPDActivityCreditTypeId]                       INT             NULL,
	[RefPDActivityLevelId]                       INT             NULL,
	[RefPDActivityTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_ProfessionalDevelopmentActivity1] PRIMARY KEY CLUSTERED ([ProfessionalDevelopmentActivityId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[ProfessionalDevelopmentActivity])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProfessionalDevelopmentActivity] ON;
		INSERT INTO [dbo].[tmp_ms_xx_ProfessionalDevelopmentActivity] ([ProfessionalDevelopmentActivityId], [ProfessionalDevelopmentRequirementId], [CourseId], [Title], [ActivityIdentifier], [Description], [Objective], [ActivityCode], [ApprovalCode], [Cost], [Credits], [ScholarshipStatus], [PublishIndicator], [ProfessionalDevelopmentActivityStateApprovedStatus], [RefCourseCreditUnitId], [RefProfessionalDevelopmentFinancialSupportId], [RefPDAudienceTypeId], [RefPDActivityApprovedPurposeId], [RefPDActivityCreditTypeId], [RefPDActivityLevelId], [RefPDActivityTypeId], [RecordStartDateTime], [RecordEndDateTime])
		SELECT   
				 [ProfessionalDevelopmentActivityId],
				 [ProfessionalDevelopmentRequirementId],
				 [CourseId],
				 [Title],
				 [ActivityIdentifier],
				 [Description],
				 [Objective],
				 [ActivityCode],
				 [ApprovalCode],
				 [Cost],
				 [Credits],
				 [ScholarshipStatus],
				 [PublishIndicator],
				 [ProfessionalDevelopmentActivityStateApprovedStatus],
				 [RefCourseCreditUnitId],
				 [RefProfessionalDevelopmentFinancialSupportId],
				 [RefPDAudienceTypeId],
				 [RefPDActivityApprovedPurposeId],
				 [RefPDActivityCreditTypeId],
				 [RefPDActivityLevelId],
				 [RefPDActivityTypeId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[ProfessionalDevelopmentActivity]
		ORDER BY [ProfessionalDevelopmentActivityId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProfessionalDevelopmentActivity] OFF;
	END

DROP TABLE [dbo].[ProfessionalDevelopmentActivity];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_ProfessionalDevelopmentActivity]', N'ProfessionalDevelopmentActivity';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_ProfessionalDevelopmentActivity1]', N'PK_ProfessionalDevelopmentActivity', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[ProgramParticipationAE]...';



ALTER TABLE [dbo].[ProgramParticipationAE]
    ADD 
		[OutOfWorkforceIndicator] BIT  NULL;



PRINT N'Altering [dbo].[ProgramParticipationCte]...';



ALTER TABLE [dbo].[ProgramParticipationCte]
    ADD 
		[OutOfWorkforceIndicator] BIT  NULL;



PRINT N'Starting rebuilding table [dbo].[ProgramParticipationSpecialEducation]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_ProgramParticipationSpecialEducation] (
	[ProgramParticipationSpecialEducationId]                       INT            IDENTITY (1, 1) NOT NULL,
	[PersonProgramParticipationId]                       INT             NOT NULL,
	[AwaitingInitialIDEAEvaluationStatus]                       BIT             NULL,
	[SpecialEducationFTE]                       DECIMAL(5, 4)             NULL,
	[SpecialEducationServicesExitDate]                       DATE             NULL,
	[IDEAPlacementRationale]                       NVARCHAR (MAX)             NULL,
	[RefIDEAEducationalEnvironmentECId]                       INT             NULL,
	[RefIDEAEducationalEnvironmentSchoolAgeId]                       INT             NULL,
	[RefSpecialEducationExitReasonId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_ProgramParticipationSpecialEducation1] PRIMARY KEY CLUSTERED ([ProgramParticipationSpecialEducationId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[ProgramParticipationSpecialEducation])
	BEGIN

			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProgramParticipationSpecialEducation] ON;
		INSERT INTO [dbo].[tmp_ms_xx_ProgramParticipationSpecialEducation] ([ProgramParticipationSpecialEducationId], [PersonProgramParticipationId], [AwaitingInitialIDEAEvaluationStatus], [SpecialEducationFTE], [SpecialEducationServicesExitDate], [IDEAPlacementRationale], [RefIDEAEducationalEnvironmentECId], [RefIDEAEducationalEnvironmentSchoolAgeId], [RefSpecialEducationExitReasonId], [RecordStartDateTime], [RecordEndDateTime])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ProgramParticipationSpecialEducation' AND COLUMN_NAME = 'RefIDEAEdEnvironmentSchoolAgeId')
		BEGIN
			
			SET @sql = @sql + '
				SELECT   
				 [ProgramParticipationSpecialEducationId],
				 [PersonProgramParticipationId],
				 [AwaitingInitialIDEAEvaluationStatus],
				 [SpecialEducationFTE],
				 [SpecialEducationServicesExitDate],
				 [IDEAPlacementRationale],
				 [RefIDEAEducationalEnvironmentECId],
				 [RefIDEAEdEnvironmentSchoolAgeId],
				 [RefSpecialEducationExitReasonId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[ProgramParticipationSpecialEducation]
		ORDER BY [ProgramParticipationSpecialEducationId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				SELECT   
				 [ProgramParticipationSpecialEducationId],
				 [PersonProgramParticipationId],
				 [AwaitingInitialIDEAEvaluationStatus],
				 [SpecialEducationFTE],
				 [SpecialEducationServicesExitDate],
				 [IDEAPlacementRationale],
				 [RefIDEAEducationalEnvironmentECId],
				 [RefIDEAEducationalEnvironmentSchoolAgeId],
				 [RefSpecialEducationExitReasonId],
				 [RecordStartDateTime],
				 [RecordEndDateTime]
		FROM     [dbo].[ProgramParticipationSpecialEducation]
		ORDER BY [ProgramParticipationSpecialEducationId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_ProgramParticipationSpecialEducation] OFF;
		'		

		EXEC sp_executesql @sql
		
	END

DROP TABLE [dbo].[ProgramParticipationSpecialEducation];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_ProgramParticipationSpecialEducation]', N'ProgramParticipationSpecialEducation';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_ProgramParticipationSpecialEducation1]', N'PK_ProgramParticipationSpecialEducation', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Starting rebuilding table [dbo].[PsStudentEnrollment]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_PsStudentEnrollment] (
	[PSStudentEnrollmentId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationPersonRoleId]                       INT             NOT NULL,
	[DegreeOrCertificateSeekingStudent]                       BIT             NULL,
	[FirstTimePostsecondaryStudent]                       BIT             NULL,
	[InitialEnrollmentTerm]                       NVARCHAR (30)             NULL,
	[InstructionalActivityHoursAttempted]                       DECIMAL(9, 2)             NULL,
	[InstructionalActivityHoursCompleted]                       DECIMAL(9, 2)             NULL,
	[HousingonCampus]                       BIT             NULL,
	[FraternityParticipationStatus]                       BIT             NULL,
	[SororityParticipationStatus]                       BIT             NULL,
	[EntryDateIntoPostsecondary]                       DATE             NULL,
	[DistanceEducationProgramEnrollmentInd]                       BIT             NULL,
	[DoctoralCandidacyAdmitInd]                       BIT             NULL,
	[DoctoralCandidacyDate]                       DATE             NULL,
	[DoctoralExamTakenDate]                       DATE             NULL,
	[OralDefenseCompletedIndicator]                       BIT             NULL,
	[OralDefenseDate]                       DATE             NULL,
	[PostsecondaryEnteringStudentInd]                       BIT             NULL,
	[ThesisOrDissertationTitle]                       NVARCHAR (300)             NULL,
	[RefPsEnrollmentTypeId]                       INT             NULL,
	[RefPsEnrollmentStatusId]                       INT             NULL,
	[RefPsStudentLevelId]                       INT             NULL,
	[RefPsEnrollmentAwardTypeId]                       INT             NULL,
	[RefTransferReadyId]                       INT             NULL,
	[RefInstructionalActivityHoursId]                       INT             NULL,
	[RefDistanceEducationCourseEnrollmentId]                       INT             NULL,
	[RefDoctoralExamsRequiredCodeId]                       INT             NULL,
	[RefGraduateOrDoctoralExamResultsStatusId]                       INT             NULL,
	[RefDevelopmentalEducationReferralStatusId]                       INT             NULL,
	[RefDevelopmentalEducationTypeId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	[RefPSExitOrWithdrawalTypeId]                       INT             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_PsStudentEnrollment1] PRIMARY KEY CLUSTERED ([PSStudentEnrollmentId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[PsStudentEnrollment])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PsStudentEnrollment] ON;
		INSERT INTO [dbo].[tmp_ms_xx_PsStudentEnrollment] ([PSStudentEnrollmentId], [OrganizationPersonRoleId], [DegreeOrCertificateSeekingStudent], [FirstTimePostsecondaryStudent], [InitialEnrollmentTerm], [InstructionalActivityHoursAttempted], [InstructionalActivityHoursCompleted], [HousingonCampus], [FraternityParticipationStatus], [SororityParticipationStatus], [EntryDateIntoPostsecondary], [DistanceEducationProgramEnrollmentInd], [DoctoralCandidacyAdmitInd], [DoctoralCandidacyDate], [DoctoralExamTakenDate], [OralDefenseCompletedIndicator], [OralDefenseDate], [PostsecondaryEnteringStudentInd], [ThesisOrDissertationTitle], [RefPsEnrollmentTypeId], [RefPsEnrollmentStatusId], [RefPsStudentLevelId], [RefPsEnrollmentAwardTypeId], [RefTransferReadyId], [RefInstructionalActivityHoursId], [RefDistanceEducationCourseEnrollmentId], [RefDoctoralExamsRequiredCodeId], [RefGraduateOrDoctoralExamResultsStatusId], [RefDevelopmentalEducationReferralStatusId], [RefDevelopmentalEducationTypeId], [RecordStartDateTime], [RecordEndDateTime], [RefPSExitOrWithdrawalTypeId])
		SELECT   
				 [PsStudentEnrollment].[PSStudentEnrollmentId],
				 [PsStudentEnrollment].[OrganizationPersonRoleId],
				 [PsStudentEnrollment].[DegreeOrCertificateSeekingStudent],
				 [PsStudentEnrollment].[FirstTimePostsecondaryStudent],
				 [PsStudentEnrollment].[InitialEnrollmentTerm],
				 [PsStudentEnrollment].[InstructionalActivityHoursAttempted],
				 [PsStudentEnrollment].[InstructionalActivityHoursCompleted],
				 [PsStudentEnrollment].[HousingonCampus],
				 [PsStudentEnrollment].[FraternityParticipationStatus],
				 [PsStudentEnrollment].[SororityParticipationStatus],
				 [PsStudentEnrollment].[EntryDateIntoPostsecondary],
				 [PsStudentEnrollment].[DistanceEducationProgramEnrollmentInd],
				 [PsStudentEnrollment].[DoctoralCandidacyAdmitInd],
				 [PsStudentEnrollment].[DoctoralCandidacyDate],
				 [PsStudentEnrollment].[DoctoralExamTakenDate],
				 [PsStudentEnrollment].[OralDefenseCompletedIndicator],
				 [PsStudentEnrollment].[OralDefenseDate],
				 [PsStudentEnrollment].[PostsecondaryEnteringStudentInd],
				 [PsStudentEnrollment].[ThesisOrDissertationTitle],
				 [PsStudentEnrollment].[RefPsEnrollmentTypeId],
				 [PsStudentEnrollment].[RefPsEnrollmentStatusId],
				 [PsStudentEnrollment].[RefPsStudentLevelId],
				 [PsStudentEnrollment].[RefPsEnrollmentAwardTypeId],
				 [PsStudentEnrollment].[RefTransferReadyId],
				 [PsStudentEnrollment].[RefInstructionalActivityHoursId],
				 [PsStudentEnrollment].[RefDistanceEducationCourseEnrollmentId],
				 [PsStudentEnrollment].[RefDoctoralExamsRequiredCodeId],
				 [PsStudentEnrollment].[RefGraduateOrDoctoralExamResultsStatusId],
				 [PsStudentEnrollment].[RefDevelopmentalEducationReferralStatusId],
				 [PsStudentEnrollment].[RefDevelopmentalEducationTypeId],
				 [PsStudentEnrollment].[RecordStartDateTime],
				 [PsStudentEnrollment].[RecordEndDateTime],
				 --[PsProgram].[RefPSExitOrWithdrawalTypeId],	--WARNING!!!! - need to add JOINS to PsProgram if moving data, else NULL
				 NULL
		FROM     [dbo].[PsStudentEnrollment]
		ORDER BY [PSStudentEnrollmentId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PsStudentEnrollment] OFF;
	END

DROP TABLE [dbo].[PsStudentEnrollment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_PsStudentEnrollment]', N'PsStudentEnrollment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_PsStudentEnrollment1]', N'PK_PsStudentEnrollment', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[PsProgram]...';



--ALTER TABLE [dbo].[PsProgram]
--    DROP COLUMN 
--		[RefPSExitOrWithdrawalTypeId];



PRINT N'Altering [dbo].[RefAbsentAttendanceCategory]...';



ALTER TABLE [dbo].[RefAbsentAttendanceCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAbsentAttendanceCategory]...';



ALTER TABLE [dbo].[RefAbsentAttendanceCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicAwardLevel]...';



ALTER TABLE [dbo].[RefAcademicAwardLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicAwardLevel]...';



ALTER TABLE [dbo].[RefAcademicAwardLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicAwardPrerequisiteType]...';



ALTER TABLE [dbo].[RefAcademicAwardPrerequisiteType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicAwardPrerequisiteType]...';



ALTER TABLE [dbo].[RefAcademicAwardPrerequisiteType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicHonorType]...';



ALTER TABLE [dbo].[RefAcademicHonorType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicHonorType]...';



ALTER TABLE [dbo].[RefAcademicHonorType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicRank]...';



ALTER TABLE [dbo].[RefAcademicRank]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicRank]...';



ALTER TABLE [dbo].[RefAcademicRank]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicSubject]...';



ALTER TABLE [dbo].[RefAcademicSubject]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicSubject]...';



ALTER TABLE [dbo].[RefAcademicSubject]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAcademicTermDesignator]...';



ALTER TABLE [dbo].[RefAcademicTermDesignator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAcademicTermDesignator]...';



ALTER TABLE [dbo].[RefAcademicTermDesignator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAccommodationsNeededType]...';



ALTER TABLE [dbo].[RefAccommodationsNeededType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAccommodationsNeededType]...';



ALTER TABLE [dbo].[RefAccommodationsNeededType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAccommodationType]...';



ALTER TABLE [dbo].[RefAccommodationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAccommodationType]...';



ALTER TABLE [dbo].[RefAccommodationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAccreditationAgency]...';



ALTER TABLE [dbo].[RefAccreditationAgency]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAccreditationAgency]...';



ALTER TABLE [dbo].[RefAccreditationAgency]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefActivityRecognitionType]...';



ALTER TABLE [dbo].[RefActivityRecognitionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefActivityRecognitionType]...';



ALTER TABLE [dbo].[RefActivityRecognitionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefActivityTimeMeasurementType]...';



ALTER TABLE [dbo].[RefActivityTimeMeasurementType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefActivityTimeMeasurementType]...';



ALTER TABLE [dbo].[RefActivityTimeMeasurementType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdditionalCreditType]...';



ALTER TABLE [dbo].[RefAdditionalCreditType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdditionalCreditType]...';



ALTER TABLE [dbo].[RefAdditionalCreditType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAddressType]...';



ALTER TABLE [dbo].[RefAddressType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAddressType]...';



ALTER TABLE [dbo].[RefAddressType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdministrativeFundingControl]...';



ALTER TABLE [dbo].[RefAdministrativeFundingControl]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdministrativeFundingControl]...';



ALTER TABLE [dbo].[RefAdministrativeFundingControl]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdmissionConsiderationLevel]...';



ALTER TABLE [dbo].[RefAdmissionConsiderationLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdmissionConsiderationLevel]...';



ALTER TABLE [dbo].[RefAdmissionConsiderationLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdmissionConsiderationType]...';



ALTER TABLE [dbo].[RefAdmissionConsiderationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdmissionConsiderationType]...';



ALTER TABLE [dbo].[RefAdmissionConsiderationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdmittedStudent]...';



ALTER TABLE [dbo].[RefAdmittedStudent]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdmittedStudent]...';



ALTER TABLE [dbo].[RefAdmittedStudent]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAdvancedPlacementCourseCode]...';



ALTER TABLE [dbo].[RefAdvancedPlacementCourseCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAdvancedPlacementCourseCode]...';



ALTER TABLE [dbo].[RefAdvancedPlacementCourseCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeCertificationType]...';



ALTER TABLE [dbo].[RefAeCertificationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeCertificationType]...';



ALTER TABLE [dbo].[RefAeCertificationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeFunctioningLevelAtIntake]...';



ALTER TABLE [dbo].[RefAeFunctioningLevelAtIntake]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeFunctioningLevelAtIntake]...';



ALTER TABLE [dbo].[RefAeFunctioningLevelAtIntake]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeFunctioningLevelAtPosttest]...';



ALTER TABLE [dbo].[RefAeFunctioningLevelAtPosttest]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeFunctioningLevelAtPosttest]...';



ALTER TABLE [dbo].[RefAeFunctioningLevelAtPosttest]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeInstructionalProgramType]...';



ALTER TABLE [dbo].[RefAeInstructionalProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeInstructionalProgramType]...';



ALTER TABLE [dbo].[RefAeInstructionalProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAePostsecondaryTransitionAction]...';



ALTER TABLE [dbo].[RefAePostsecondaryTransitionAction]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAePostsecondaryTransitionAction]...';



ALTER TABLE [dbo].[RefAePostsecondaryTransitionAction]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeSpecialProgramType]...';



ALTER TABLE [dbo].[RefAeSpecialProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeSpecialProgramType]...';



ALTER TABLE [dbo].[RefAeSpecialProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeStaffClassification]...';



ALTER TABLE [dbo].[RefAeStaffClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeStaffClassification]...';



ALTER TABLE [dbo].[RefAeStaffClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAeStaffEmploymentStatus]...';



ALTER TABLE [dbo].[RefAeStaffEmploymentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAeStaffEmploymentStatus]...';



ALTER TABLE [dbo].[RefAeStaffEmploymentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAllergySeverity]...';



ALTER TABLE [dbo].[RefAllergySeverity]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAllergySeverity]...';



ALTER TABLE [dbo].[RefAllergySeverity]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAllergyType]...';



ALTER TABLE [dbo].[RefAllergyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAllergyType]...';



ALTER TABLE [dbo].[RefAllergyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAlternateFundUses]...';



ALTER TABLE [dbo].[RefAlternateFundUses]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAlternateFundUses]...';



ALTER TABLE [dbo].[RefAlternateFundUses]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAlternativeSchoolFocus]...';



ALTER TABLE [dbo].[RefAlternativeSchoolFocus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAlternativeSchoolFocus]...';



ALTER TABLE [dbo].[RefAlternativeSchoolFocus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAltRouteToCertificationOrLicensure]...';



ALTER TABLE [dbo].[RefAltRouteToCertificationOrLicensure]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAltRouteToCertificationOrLicensure]...';



ALTER TABLE [dbo].[RefAltRouteToCertificationOrLicensure]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAmaoAttainmentStatus]...';



ALTER TABLE [dbo].[RefAmaoAttainmentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAmaoAttainmentStatus]...';



ALTER TABLE [dbo].[RefAmaoAttainmentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefApipInteractionType]...';



ALTER TABLE [dbo].[RefApipInteractionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefApipInteractionType]...';



ALTER TABLE [dbo].[RefApipInteractionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentAccommodationCategory]...';



ALTER TABLE [dbo].[RefAssessmentAccommodationCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentAccommodationCategory]...';



ALTER TABLE [dbo].[RefAssessmentAccommodationCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentAssetIdentifierType]...';



ALTER TABLE [dbo].[RefAssessmentAssetIdentifierType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentAssetIdentifierType]...';



ALTER TABLE [dbo].[RefAssessmentAssetIdentifierType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentAssetType]...';



ALTER TABLE [dbo].[RefAssessmentAssetType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentAssetType]...';



ALTER TABLE [dbo].[RefAssessmentAssetType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentELDevelopmentalDomain]...';



ALTER TABLE [dbo].[RefAssessmentELDevelopmentalDomain]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentELDevelopmentalDomain]...';



ALTER TABLE [dbo].[RefAssessmentELDevelopmentalDomain]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentFormSectionIdentificationSystem]...';



ALTER TABLE [dbo].[RefAssessmentFormSectionIdentificationSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentFormSectionIdentificationSystem]...';



ALTER TABLE [dbo].[RefAssessmentFormSectionIdentificationSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentItemCharacteristicType]...';



ALTER TABLE [dbo].[RefAssessmentItemCharacteristicType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentItemCharacteristicType]...';



ALTER TABLE [dbo].[RefAssessmentItemCharacteristicType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentItemResponseScoreStatus]...';



ALTER TABLE [dbo].[RefAssessmentItemResponseScoreStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentItemResponseScoreStatus]...';



ALTER TABLE [dbo].[RefAssessmentItemResponseScoreStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentItemResponseStatus]...';



ALTER TABLE [dbo].[RefAssessmentItemResponseStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentItemResponseStatus]...';



ALTER TABLE [dbo].[RefAssessmentItemResponseStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentItemType]...';



ALTER TABLE [dbo].[RefAssessmentItemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentItemType]...';



ALTER TABLE [dbo].[RefAssessmentItemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedAlternativeRepresentationType]...';



ALTER TABLE [dbo].[RefAssessmentNeedAlternativeRepresentationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedAlternativeRepresentationType]...';



ALTER TABLE [dbo].[RefAssessmentNeedAlternativeRepresentationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleGradeType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleGradeType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleGradeType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleGradeType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleMarkType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleMarkType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleMarkType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleMarkType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleStatusCellType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleStatusCellType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedBrailleStatusCellType]...';



ALTER TABLE [dbo].[RefAssessmentNeedBrailleStatusCellType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedHazardType]...';



ALTER TABLE [dbo].[RefAssessmentNeedHazardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedHazardType]...';



ALTER TABLE [dbo].[RefAssessmentNeedHazardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedIncreasedWhitespacingType]...';



ALTER TABLE [dbo].[RefAssessmentNeedIncreasedWhitespacingType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedIncreasedWhitespacingType]...';



ALTER TABLE [dbo].[RefAssessmentNeedIncreasedWhitespacingType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedLanguageLearnerType]...';



ALTER TABLE [dbo].[RefAssessmentNeedLanguageLearnerType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedLanguageLearnerType]...';



ALTER TABLE [dbo].[RefAssessmentNeedLanguageLearnerType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedLinkIndicationType]...';



ALTER TABLE [dbo].[RefAssessmentNeedLinkIndicationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedLinkIndicationType]...';



ALTER TABLE [dbo].[RefAssessmentNeedLinkIndicationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedMaskingType]...';



ALTER TABLE [dbo].[RefAssessmentNeedMaskingType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedMaskingType]...';



ALTER TABLE [dbo].[RefAssessmentNeedMaskingType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedNumberOfBrailleDots]...';



ALTER TABLE [dbo].[RefAssessmentNeedNumberOfBrailleDots]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedNumberOfBrailleDots]...';



ALTER TABLE [dbo].[RefAssessmentNeedNumberOfBrailleDots]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSigningType]...';



ALTER TABLE [dbo].[RefAssessmentNeedSigningType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSigningType]...';



ALTER TABLE [dbo].[RefAssessmentNeedSigningType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSpokenSourcePreferenceType]...';



ALTER TABLE [dbo].[RefAssessmentNeedSpokenSourcePreferenceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSpokenSourcePreferenceType]...';



ALTER TABLE [dbo].[RefAssessmentNeedSpokenSourcePreferenceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSupportTool]...';



ALTER TABLE [dbo].[RefAssessmentNeedSupportTool]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedSupportTool]...';



ALTER TABLE [dbo].[RefAssessmentNeedSupportTool]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedUsageType]...';



ALTER TABLE [dbo].[RefAssessmentNeedUsageType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedUsageType]...';



ALTER TABLE [dbo].[RefAssessmentNeedUsageType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedUserSpokenPreferenceType]...';



ALTER TABLE [dbo].[RefAssessmentNeedUserSpokenPreferenceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentNeedUserSpokenPreferenceType]...';



ALTER TABLE [dbo].[RefAssessmentNeedUserSpokenPreferenceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentParticipationIndicator]...';



ALTER TABLE [dbo].[RefAssessmentParticipationIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentParticipationIndicator]...';



ALTER TABLE [dbo].[RefAssessmentParticipationIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentPlatformType]...';



ALTER TABLE [dbo].[RefAssessmentPlatformType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentPlatformType]...';



ALTER TABLE [dbo].[RefAssessmentPlatformType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentPretestOutcome]...';



ALTER TABLE [dbo].[RefAssessmentPretestOutcome]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentPretestOutcome]...';



ALTER TABLE [dbo].[RefAssessmentPretestOutcome]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentPurpose]...';



ALTER TABLE [dbo].[RefAssessmentPurpose]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentPurpose]...';



ALTER TABLE [dbo].[RefAssessmentPurpose]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentReasonNotCompleting]...';



ALTER TABLE [dbo].[RefAssessmentReasonNotCompleting]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentReasonNotCompleting]...';



ALTER TABLE [dbo].[RefAssessmentReasonNotCompleting]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentReasonNotTested]...';



ALTER TABLE [dbo].[RefAssessmentReasonNotTested]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentReasonNotTested]...';



ALTER TABLE [dbo].[RefAssessmentReasonNotTested]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentRegistrationCompletionStatus]...';



ALTER TABLE [dbo].[RefAssessmentRegistrationCompletionStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentRegistrationCompletionStatus]...';



ALTER TABLE [dbo].[RefAssessmentRegistrationCompletionStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentReportingMethod]...';



ALTER TABLE [dbo].[RefAssessmentReportingMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentReportingMethod]...';



ALTER TABLE [dbo].[RefAssessmentReportingMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentResultDataType]...';



ALTER TABLE [dbo].[RefAssessmentResultDataType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentResultDataType]...';



ALTER TABLE [dbo].[RefAssessmentResultDataType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentResultScoreType]...';



ALTER TABLE [dbo].[RefAssessmentResultScoreType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentResultScoreType]...';



ALTER TABLE [dbo].[RefAssessmentResultScoreType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionSpecialCircumstanceType]...';



ALTER TABLE [dbo].[RefAssessmentSessionSpecialCircumstanceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionSpecialCircumstanceType]...';



ALTER TABLE [dbo].[RefAssessmentSessionSpecialCircumstanceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionStaffRoleType]...';



ALTER TABLE [dbo].[RefAssessmentSessionStaffRoleType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionStaffRoleType]...';



ALTER TABLE [dbo].[RefAssessmentSessionStaffRoleType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionType]...';



ALTER TABLE [dbo].[RefAssessmentSessionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentSessionType]...';



ALTER TABLE [dbo].[RefAssessmentSessionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentSubtestIdentifierType]...';



ALTER TABLE [dbo].[RefAssessmentSubtestIdentifierType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentSubtestIdentifierType]...';



ALTER TABLE [dbo].[RefAssessmentSubtestIdentifierType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentType]...';



ALTER TABLE [dbo].[RefAssessmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentType]...';



ALTER TABLE [dbo].[RefAssessmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAssessmentTypeChildrenWithDisabilities]...';



ALTER TABLE [dbo].[RefAssessmentTypeChildrenWithDisabilities]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAssessmentTypeChildrenWithDisabilities]...';



ALTER TABLE [dbo].[RefAssessmentTypeChildrenWithDisabilities]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAttendanceEventType]...';



ALTER TABLE [dbo].[RefAttendanceEventType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAttendanceEventType]...';



ALTER TABLE [dbo].[RefAttendanceEventType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAttendanceStatus]...';



ALTER TABLE [dbo].[RefAttendanceStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAttendanceStatus]...';



ALTER TABLE [dbo].[RefAttendanceStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAuthorizerType]...';



ALTER TABLE [dbo].[RefAuthorizerType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAuthorizerType]...';



ALTER TABLE [dbo].[RefAuthorizerType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefAypStatus]...';



ALTER TABLE [dbo].[RefAypStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefAypStatus]...';



ALTER TABLE [dbo].[RefAypStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBarrierToEducatingHomeless]...';



ALTER TABLE [dbo].[RefBarrierToEducatingHomeless]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBarrierToEducatingHomeless]...';



ALTER TABLE [dbo].[RefBarrierToEducatingHomeless]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBillableBasisType]...';



ALTER TABLE [dbo].[RefBillableBasisType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBillableBasisType]...';



ALTER TABLE [dbo].[RefBillableBasisType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBlendedLearningModelType]...';



ALTER TABLE [dbo].[RefBlendedLearningModelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBlendedLearningModelType]...';



ALTER TABLE [dbo].[RefBlendedLearningModelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBloomsTaxonomyDomain]...';



ALTER TABLE [dbo].[RefBloomsTaxonomyDomain]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBloomsTaxonomyDomain]...';



ALTER TABLE [dbo].[RefBloomsTaxonomyDomain]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingAdministrativeSpaceType]...';



ALTER TABLE [dbo].[RefBuildingAdministrativeSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingAdministrativeSpaceType]...';



ALTER TABLE [dbo].[RefBuildingAdministrativeSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingAirDistributionSystemType]...';



ALTER TABLE [dbo].[RefBuildingAirDistributionSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingAirDistributionSystemType]...';



ALTER TABLE [dbo].[RefBuildingAirDistributionSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingArtSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingArtSpecialtySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingArtSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingArtSpecialtySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingAssemblySpaceType]...';



ALTER TABLE [dbo].[RefBuildingAssemblySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingAssemblySpaceType]...';



ALTER TABLE [dbo].[RefBuildingAssemblySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingBasicClassroomDesignType]...';



ALTER TABLE [dbo].[RefBuildingBasicClassroomDesignType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingBasicClassroomDesignType]...';



ALTER TABLE [dbo].[RefBuildingBasicClassroomDesignType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCareerTechEducationSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCareerTechEducationSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCareerTechEducationSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCareerTechEducationSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCharterSchoolRealtyAccessType]...';



ALTER TABLE [dbo].[RefBuildingCharterSchoolRealtyAccessType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCharterSchoolRealtyAccessType]...';



ALTER TABLE [dbo].[RefBuildingCharterSchoolRealtyAccessType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCirculationSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCirculationSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCirculationSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCirculationSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCleaningStandardType]...';



ALTER TABLE [dbo].[RefBuildingCleaningStandardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCleaningStandardType]...';



ALTER TABLE [dbo].[RefBuildingCleaningStandardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCommMgmtComponentSystemType]...';



ALTER TABLE [dbo].[RefBuildingCommMgmtComponentSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCommMgmtComponentSystemType]...';



ALTER TABLE [dbo].[RefBuildingCommMgmtComponentSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCommunityUseSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCommunityUseSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCommunityUseSpaceType]...';



ALTER TABLE [dbo].[RefBuildingCommunityUseSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingCoolingGenerationSystemType]...';



ALTER TABLE [dbo].[RefBuildingCoolingGenerationSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingCoolingGenerationSystemType]...';



ALTER TABLE [dbo].[RefBuildingCoolingGenerationSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingDesignType]...';



ALTER TABLE [dbo].[RefBuildingDesignType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingDesignType]...';



ALTER TABLE [dbo].[RefBuildingDesignType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingElectricalSystemType]...';



ALTER TABLE [dbo].[RefBuildingElectricalSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingElectricalSystemType]...';



ALTER TABLE [dbo].[RefBuildingElectricalSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingEnergyConservationMeasureType]...';



ALTER TABLE [dbo].[RefBuildingEnergyConservationMeasureType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingEnergyConservationMeasureType]...';



ALTER TABLE [dbo].[RefBuildingEnergyConservationMeasureType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingEnergySourceType]...';



ALTER TABLE [dbo].[RefBuildingEnergySourceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingEnergySourceType]...';



ALTER TABLE [dbo].[RefBuildingEnergySourceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingEnvOrEnergyPerformanceRatingCat]...';



ALTER TABLE [dbo].[RefBuildingEnvOrEnergyPerformanceRatingCat]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingEnvOrEnergyPerformanceRatingCat]...';



ALTER TABLE [dbo].[RefBuildingEnvOrEnergyPerformanceRatingCat]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingFireProtectionSystemType]...';



ALTER TABLE [dbo].[RefBuildingFireProtectionSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingFireProtectionSystemType]...';



ALTER TABLE [dbo].[RefBuildingFireProtectionSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingFoodServiceSpaceType]...';



ALTER TABLE [dbo].[RefBuildingFoodServiceSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingFoodServiceSpaceType]...';



ALTER TABLE [dbo].[RefBuildingFoodServiceSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingFullServiceKitchenType]...';



ALTER TABLE [dbo].[RefBuildingFullServiceKitchenType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingFullServiceKitchenType]...';



ALTER TABLE [dbo].[RefBuildingFullServiceKitchenType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingHeatingGenerationSystemType]...';



ALTER TABLE [dbo].[RefBuildingHeatingGenerationSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingHeatingGenerationSystemType]...';



ALTER TABLE [dbo].[RefBuildingHeatingGenerationSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingHistoricStatus]...';



ALTER TABLE [dbo].[RefBuildingHistoricStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingHistoricStatus]...';



ALTER TABLE [dbo].[RefBuildingHistoricStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingHVACSystemType]...';



ALTER TABLE [dbo].[RefBuildingHVACSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingHVACSystemType]...';



ALTER TABLE [dbo].[RefBuildingHVACSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingIndoorAthleticOrPhysEdSpaceType]...';



ALTER TABLE [dbo].[RefBuildingIndoorAthleticOrPhysEdSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingIndoorAthleticOrPhysEdSpaceType]...';



ALTER TABLE [dbo].[RefBuildingIndoorAthleticOrPhysEdSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingInstructionalSpaceFactorType]...';



ALTER TABLE [dbo].[RefBuildingInstructionalSpaceFactorType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingInstructionalSpaceFactorType]...';



ALTER TABLE [dbo].[RefBuildingInstructionalSpaceFactorType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingJointUseRationaleType]...';



ALTER TABLE [dbo].[RefBuildingJointUseRationaleType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingJointUseRationaleType]...';



ALTER TABLE [dbo].[RefBuildingJointUseRationaleType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingJointUserType]...';



ALTER TABLE [dbo].[RefBuildingJointUserType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingJointUserType]...';



ALTER TABLE [dbo].[RefBuildingJointUserType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingJointUseSchedulingType]...';



ALTER TABLE [dbo].[RefBuildingJointUseSchedulingType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingJointUseSchedulingType]...';



ALTER TABLE [dbo].[RefBuildingJointUseSchedulingType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingLibMediaCenterSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingLibMediaCenterSpecialtySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingLibMediaCenterSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingLibMediaCenterSpecialtySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingMechanicalConveyingSystemType]...';



ALTER TABLE [dbo].[RefBuildingMechanicalConveyingSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingMechanicalConveyingSystemType]...';



ALTER TABLE [dbo].[RefBuildingMechanicalConveyingSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingMechanicalSystemType]...';



ALTER TABLE [dbo].[RefBuildingMechanicalSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingMechanicalSystemType]...';



ALTER TABLE [dbo].[RefBuildingMechanicalSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingoperationsOrMaintSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoperationsOrMaintSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingoperationsOrMaintSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoperationsOrMaintSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingoutdoorAthleticOrPhysEdSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoutdoorAthleticOrPhysEdSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingoutdoorAthleticOrPhysEdSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoutdoorAthleticOrPhysEdSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingoutdoorOrNonathleticSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoutdoorOrNonathleticSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingoutdoorOrNonathleticSpaceType]...';



ALTER TABLE [dbo].[RefBuildingoutdoorOrNonathleticSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingPerformingArtsSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingPerformingArtsSpecialtySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingPerformingArtsSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingPerformingArtsSpecialtySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingPlumbingSystemType]...';



ALTER TABLE [dbo].[RefBuildingPlumbingSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingPlumbingSystemType]...';



ALTER TABLE [dbo].[RefBuildingPlumbingSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingPrimaryUseType]...';



ALTER TABLE [dbo].[RefBuildingPrimaryUseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingPrimaryUseType]...';



ALTER TABLE [dbo].[RefBuildingPrimaryUseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSchoolDesignType]...';



ALTER TABLE [dbo].[RefBuildingSchoolDesignType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSchoolDesignType]...';



ALTER TABLE [dbo].[RefBuildingSchoolDesignType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingScienceSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingScienceSpecialtySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingScienceSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingScienceSpecialtySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSecuritySystemType]...';



ALTER TABLE [dbo].[RefBuildingSecuritySystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSecuritySystemType]...';



ALTER TABLE [dbo].[RefBuildingSecuritySystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSiteUseRestrictionsType]...';



ALTER TABLE [dbo].[RefBuildingSiteUseRestrictionsType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSiteUseRestrictionsType]...';



ALTER TABLE [dbo].[RefBuildingSiteUseRestrictionsType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSpaceDesignType]...';



ALTER TABLE [dbo].[RefBuildingSpaceDesignType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSpaceDesignType]...';



ALTER TABLE [dbo].[RefBuildingSpaceDesignType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSpecEdSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingSpecEdSpecialtySpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSpecEdSpecialtySpaceType]...';



ALTER TABLE [dbo].[RefBuildingSpecEdSpecialtySpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingStudentSupportSpaceType]...';



ALTER TABLE [dbo].[RefBuildingStudentSupportSpaceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingStudentSupportSpaceType]...';



ALTER TABLE [dbo].[RefBuildingStudentSupportSpaceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingSystemType]...';



ALTER TABLE [dbo].[RefBuildingSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingSystemType]...';



ALTER TABLE [dbo].[RefBuildingSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingTechnologyWiringSystemType]...';



ALTER TABLE [dbo].[RefBuildingTechnologyWiringSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingTechnologyWiringSystemType]...';



ALTER TABLE [dbo].[RefBuildingTechnologyWiringSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingUseType]...';



ALTER TABLE [dbo].[RefBuildingUseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingUseType]...';



ALTER TABLE [dbo].[RefBuildingUseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefBuildingVerticalTransportationSystemType]...';



ALTER TABLE [dbo].[RefBuildingVerticalTransportationSystemType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefBuildingVerticalTransportationSystemType]...';



ALTER TABLE [dbo].[RefBuildingVerticalTransportationSystemType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCalendarEventType]...';



ALTER TABLE [dbo].[RefCalendarEventType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCalendarEventType]...';



ALTER TABLE [dbo].[RefCalendarEventType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCampusResidencyType]...';



ALTER TABLE [dbo].[RefCampusResidencyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCampusResidencyType]...';



ALTER TABLE [dbo].[RefCampusResidencyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCampusStatus]...';



ALTER TABLE [dbo].[RefCampusStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCampusStatus]...';



ALTER TABLE [dbo].[RefCampusStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCampusType]...';



ALTER TABLE [dbo].[RefCampusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCampusType]...';



ALTER TABLE [dbo].[RefCampusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCareerCluster]...';



ALTER TABLE [dbo].[RefCareerCluster]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCareerCluster]...';



ALTER TABLE [dbo].[RefCareerCluster]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCareerEducationPlanType]...';



ALTER TABLE [dbo].[RefCareerEducationPlanType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCareerEducationPlanType]...';



ALTER TABLE [dbo].[RefCareerEducationPlanType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCarnegieBasicClassification]...';



ALTER TABLE [dbo].[RefCarnegieBasicClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCarnegieBasicClassification]...';



ALTER TABLE [dbo].[RefCarnegieBasicClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCharterLeaStatus]...';



ALTER TABLE [dbo].[RefCharterLeaStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCharterLeaStatus]...';



ALTER TABLE [dbo].[RefCharterLeaStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefCharterSchoolAuthorizerType]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefCharterSchoolAuthorizerType] (
	[RefCharterSchoolAuthorizerTypeId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefCharterSchoolAuthorizerType1] PRIMARY KEY CLUSTERED ([RefCharterSchoolAuthorizerTypeId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefCharterSchoolApprovalAgencyType])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefCharterSchoolAuthorizerType] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefCharterSchoolAuthorizerType] ([RefCharterSchoolAuthorizerTypeId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		SELECT   
				 [RefCharterSchoolApprovalAgencyTypeId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefCharterSchoolApprovalAgencyType]
		ORDER BY [RefCharterSchoolApprovalAgencyTypeId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefCharterSchoolAuthorizerType] OFF;
	END

DROP TABLE [dbo].[RefCharterSchoolApprovalAgencyType];

DROP TABLE [dbo].[RefCharterSchoolAuthorizerType];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefCharterSchoolAuthorizerType]', N'RefCharterSchoolAuthorizerType';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefCharterSchoolAuthorizerType1]', N'PK_RefCharterSchoolAuthorizerType', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefCharterSchoolManagementOrganizationType]...';



ALTER TABLE [dbo].[RefCharterSchoolManagementOrganizationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCharterSchoolManagementOrganizationType]...';



ALTER TABLE [dbo].[RefCharterSchoolManagementOrganizationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCharterSchoolType]...';



ALTER TABLE [dbo].[RefCharterSchoolType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCharterSchoolType]...';



ALTER TABLE [dbo].[RefCharterSchoolType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefChildDevelopmentalScreeningStatus]...';



ALTER TABLE [dbo].[RefChildDevelopmentalScreeningStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefChildDevelopmentalScreeningStatus]...';



ALTER TABLE [dbo].[RefChildDevelopmentalScreeningStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefChildDevelopmentAssociateType]...';



ALTER TABLE [dbo].[RefChildDevelopmentAssociateType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefChildDevelopmentAssociateType]...';



ALTER TABLE [dbo].[RefChildDevelopmentAssociateType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefChildOutcomesSummaryRating]...';



ALTER TABLE [dbo].[RefChildOutcomesSummaryRating]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefChildOutcomesSummaryRating]...';



ALTER TABLE [dbo].[RefChildOutcomesSummaryRating]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCipCode]...';



ALTER TABLE [dbo].[RefCipCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCipCode]...';



ALTER TABLE [dbo].[RefCipCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCipUse]...';



ALTER TABLE [dbo].[RefCipUse]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCipUse]...';



ALTER TABLE [dbo].[RefCipUse]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCipVersion]...';



ALTER TABLE [dbo].[RefCipVersion]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCipVersion]...';



ALTER TABLE [dbo].[RefCipVersion]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefClassroomPositionType]...';



ALTER TABLE [dbo].[RefClassroomPositionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefClassroomPositionType]...';



ALTER TABLE [dbo].[RefClassroomPositionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCohortExclusion]...';



ALTER TABLE [dbo].[RefCohortExclusion]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCohortExclusion]...';



ALTER TABLE [dbo].[RefCohortExclusion]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCommunicationMethod]...';



ALTER TABLE [dbo].[RefCommunicationMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCommunicationMethod]...';



ALTER TABLE [dbo].[RefCommunicationMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCommunityBasedType]...';



ALTER TABLE [dbo].[RefCommunityBasedType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCommunityBasedType]...';



ALTER TABLE [dbo].[RefCommunityBasedType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCompetencyDefAssociationType]...';



ALTER TABLE [dbo].[RefCompetencyDefAssociationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCompetencyDefAssociationType]...';



ALTER TABLE [dbo].[RefCompetencyDefAssociationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCompetencyDefNodeAccessibilityProfile]...';



ALTER TABLE [dbo].[RefCompetencyDefNodeAccessibilityProfile]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCompetencyDefNodeAccessibilityProfile]...';



ALTER TABLE [dbo].[RefCompetencyDefNodeAccessibilityProfile]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCompetencyDefTestabilityType]...';



ALTER TABLE [dbo].[RefCompetencyDefTestabilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCompetencyDefTestabilityType]...';



ALTER TABLE [dbo].[RefCompetencyDefTestabilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCompetencyFrameworkPublicationStatus]...';



ALTER TABLE [dbo].[RefCompetencyFrameworkPublicationStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCompetencyFrameworkPublicationStatus]...';



ALTER TABLE [dbo].[RefCompetencyFrameworkPublicationStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCompetencySetCompletionCriteria]...';



ALTER TABLE [dbo].[RefCompetencySetCompletionCriteria]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCompetencySetCompletionCriteria]...';



ALTER TABLE [dbo].[RefCompetencySetCompletionCriteria]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefComprehensiveAndTargetedSupport]...';



ALTER TABLE [dbo].[RefComprehensiveAndTargetedSupport]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefComprehensiveAndTargetedSupport]...';



ALTER TABLE [dbo].[RefComprehensiveAndTargetedSupport]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefComprehensiveSupport]...';



ALTER TABLE [dbo].[RefComprehensiveSupport]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefComprehensiveSupport]...';



ALTER TABLE [dbo].[RefComprehensiveSupport]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefContentStandardType]...';



ALTER TABLE [dbo].[RefContentStandardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefContentStandardType]...';



ALTER TABLE [dbo].[RefContentStandardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefContinuationOfServices]...';



ALTER TABLE [dbo].[RefContinuationOfServices]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefContinuationOfServices]...';



ALTER TABLE [dbo].[RefContinuationOfServices]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefControlOfInstitution]...';



ALTER TABLE [dbo].[RefControlOfInstitution]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefControlOfInstitution]...';



ALTER TABLE [dbo].[RefControlOfInstitution]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCoreKnowledgeArea]...';



ALTER TABLE [dbo].[RefCoreKnowledgeArea]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCoreKnowledgeArea]...';



ALTER TABLE [dbo].[RefCoreKnowledgeArea]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCorrectionalEducationFacilityType]...';



ALTER TABLE [dbo].[RefCorrectionalEducationFacilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCorrectionalEducationFacilityType]...';



ALTER TABLE [dbo].[RefCorrectionalEducationFacilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCorrectiveActionType]...';



ALTER TABLE [dbo].[RefCorrectiveActionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCorrectiveActionType]...';



ALTER TABLE [dbo].[RefCorrectiveActionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCountry]...';



ALTER TABLE [dbo].[RefCountry]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCountry]...';



ALTER TABLE [dbo].[RefCountry]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCounty]...';



ALTER TABLE [dbo].[RefCounty]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCounty]...';



ALTER TABLE [dbo].[RefCounty]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseAcademicGradeStatusCode]...';



ALTER TABLE [dbo].[RefCourseAcademicGradeStatusCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseAcademicGradeStatusCode]...';



ALTER TABLE [dbo].[RefCourseAcademicGradeStatusCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseApplicableEducationLevel]...';



ALTER TABLE [dbo].[RefCourseApplicableEducationLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseApplicableEducationLevel]...';



ALTER TABLE [dbo].[RefCourseApplicableEducationLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseCreditBasisType]...';



ALTER TABLE [dbo].[RefCourseCreditBasisType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseCreditBasisType]...';



ALTER TABLE [dbo].[RefCourseCreditBasisType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseCreditLevelType]...';



ALTER TABLE [dbo].[RefCourseCreditLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseCreditLevelType]...';



ALTER TABLE [dbo].[RefCourseCreditLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseCreditUnit]...';



ALTER TABLE [dbo].[RefCourseCreditUnit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseCreditUnit]...';



ALTER TABLE [dbo].[RefCourseCreditUnit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseGpaApplicability]...';



ALTER TABLE [dbo].[RefCourseGpaApplicability]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseGpaApplicability]...';



ALTER TABLE [dbo].[RefCourseGpaApplicability]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseHonorsType]...';



ALTER TABLE [dbo].[RefCourseHonorsType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseHonorsType]...';



ALTER TABLE [dbo].[RefCourseHonorsType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseInstructionMethod]...';



ALTER TABLE [dbo].[RefCourseInstructionMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseInstructionMethod]...';



ALTER TABLE [dbo].[RefCourseInstructionMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseInstructionSiteType]...';



ALTER TABLE [dbo].[RefCourseInstructionSiteType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseInstructionSiteType]...';



ALTER TABLE [dbo].[RefCourseInstructionSiteType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseInteractionMode]...';



ALTER TABLE [dbo].[RefCourseInteractionMode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseInteractionMode]...';



ALTER TABLE [dbo].[RefCourseInteractionMode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseLevelCharacteristic]...';



ALTER TABLE [dbo].[RefCourseLevelCharacteristic]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseLevelCharacteristic]...';



ALTER TABLE [dbo].[RefCourseLevelCharacteristic]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseLevelType]...';



ALTER TABLE [dbo].[RefCourseLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseLevelType]...';



ALTER TABLE [dbo].[RefCourseLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseRepeatCode]...';



ALTER TABLE [dbo].[RefCourseRepeatCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseRepeatCode]...';



ALTER TABLE [dbo].[RefCourseRepeatCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseSectionAssessmentReportingMethod]...';



ALTER TABLE [dbo].[RefCourseSectionAssessmentReportingMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseSectionAssessmentReportingMethod]...';



ALTER TABLE [dbo].[RefCourseSectionAssessmentReportingMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseSectionDeliveryMode]...';



ALTER TABLE [dbo].[RefCourseSectionDeliveryMode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseSectionDeliveryMode]...';



ALTER TABLE [dbo].[RefCourseSectionDeliveryMode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseSectionEnrollmentStatusType]...';



ALTER TABLE [dbo].[RefCourseSectionEnrollmentStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseSectionEnrollmentStatusType]...';



ALTER TABLE [dbo].[RefCourseSectionEnrollmentStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseSectionEntryType]...';



ALTER TABLE [dbo].[RefCourseSectionEntryType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseSectionEntryType]...';



ALTER TABLE [dbo].[RefCourseSectionEntryType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCourseSectionExitType]...';



ALTER TABLE [dbo].[RefCourseSectionExitType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCourseSectionExitType]...';



ALTER TABLE [dbo].[RefCourseSectionExitType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialDefAgentRoleType]...';



ALTER TABLE [dbo].[RefCredentialDefAgentRoleType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialDefAgentRoleType]...';



ALTER TABLE [dbo].[RefCredentialDefAgentRoleType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialDefAssessMethodType]...';



ALTER TABLE [dbo].[RefCredentialDefAssessMethodType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialDefAssessMethodType]...';



ALTER TABLE [dbo].[RefCredentialDefAssessMethodType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialDefIntendedPurposeType]...';



ALTER TABLE [dbo].[RefCredentialDefIntendedPurposeType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialDefIntendedPurposeType]...';



ALTER TABLE [dbo].[RefCredentialDefIntendedPurposeType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialDefStatusType]...';



ALTER TABLE [dbo].[RefCredentialDefStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialDefStatusType]...';



ALTER TABLE [dbo].[RefCredentialDefStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialDefVerificationType]...';



ALTER TABLE [dbo].[RefCredentialDefVerificationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialDefVerificationType]...';



ALTER TABLE [dbo].[RefCredentialDefVerificationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialIdentifierSystem]...';



ALTER TABLE [dbo].[RefCredentialIdentifierSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialIdentifierSystem]...';



ALTER TABLE [dbo].[RefCredentialIdentifierSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCredentialType]...';



ALTER TABLE [dbo].[RefCredentialType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCredentialType]...';



ALTER TABLE [dbo].[RefCredentialType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCreditHoursAppliedOtherProgram]...';



ALTER TABLE [dbo].[RefCreditHoursAppliedOtherProgram]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCreditHoursAppliedOtherProgram]...';



ALTER TABLE [dbo].[RefCreditHoursAppliedOtherProgram]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCreditTypeEarned]...';



ALTER TABLE [dbo].[RefCreditTypeEarned]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCreditTypeEarned]...';



ALTER TABLE [dbo].[RefCreditTypeEarned]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCriticalTeacherShortageCandidate]...';



ALTER TABLE [dbo].[RefCriticalTeacherShortageCandidate]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCriticalTeacherShortageCandidate]...';



ALTER TABLE [dbo].[RefCriticalTeacherShortageCandidate]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCTDLAudienceLevelType]...';



ALTER TABLE [dbo].[RefCTDLAudienceLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCTDLAudienceLevelType]...';



ALTER TABLE [dbo].[RefCTDLAudienceLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCTDLOrganizationType]...';



ALTER TABLE [dbo].[RefCTDLOrganizationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCTDLOrganizationType]...';



ALTER TABLE [dbo].[RefCTDLOrganizationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCteGraduationRateInclusion]...';



ALTER TABLE [dbo].[RefCteGraduationRateInclusion]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCteGraduationRateInclusion]...';



ALTER TABLE [dbo].[RefCteGraduationRateInclusion]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCteNonTraditionalGenderStatus]...';



ALTER TABLE [dbo].[RefCteNonTraditionalGenderStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCteNonTraditionalGenderStatus]...';



ALTER TABLE [dbo].[RefCteNonTraditionalGenderStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefCurriculumFrameworkType]...';



ALTER TABLE [dbo].[RefCurriculumFrameworkType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefCurriculumFrameworkType]...';



ALTER TABLE [dbo].[RefCurriculumFrameworkType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDegreeOrCertificateType]...';



ALTER TABLE [dbo].[RefDegreeOrCertificateType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDegreeOrCertificateType]...';



ALTER TABLE [dbo].[RefDegreeOrCertificateType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDentalInsuranceCoverageType]...';



ALTER TABLE [dbo].[RefDentalInsuranceCoverageType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDentalInsuranceCoverageType]...';



ALTER TABLE [dbo].[RefDentalInsuranceCoverageType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDentalScreeningStatus]...';



ALTER TABLE [dbo].[RefDentalScreeningStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDentalScreeningStatus]...';



ALTER TABLE [dbo].[RefDentalScreeningStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDependencyStatus]...';



ALTER TABLE [dbo].[RefDependencyStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDependencyStatus]...';



ALTER TABLE [dbo].[RefDependencyStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEducationReferralStatus]...';



ALTER TABLE [dbo].[RefDevelopmentalEducationReferralStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEducationReferralStatus]...';



ALTER TABLE [dbo].[RefDevelopmentalEducationReferralStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEducationType]...';



ALTER TABLE [dbo].[RefDevelopmentalEducationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEducationType]...';



ALTER TABLE [dbo].[RefDevelopmentalEducationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEvaluationFinding]...';



ALTER TABLE [dbo].[RefDevelopmentalEvaluationFinding]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDevelopmentalEvaluationFinding]...';



ALTER TABLE [dbo].[RefDevelopmentalEvaluationFinding]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDirectoryInformationBlockStatus]...';



ALTER TABLE [dbo].[RefDirectoryInformationBlockStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDirectoryInformationBlockStatus]...';



ALTER TABLE [dbo].[RefDirectoryInformationBlockStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisabilityConditionStatusCode]...';



ALTER TABLE [dbo].[RefDisabilityConditionStatusCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisabilityConditionStatusCode]...';



ALTER TABLE [dbo].[RefDisabilityConditionStatusCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisabilityConditionType]...';



ALTER TABLE [dbo].[RefDisabilityConditionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisabilityConditionType]...';



ALTER TABLE [dbo].[RefDisabilityConditionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisabilityDeterminationSourceType]...';



ALTER TABLE [dbo].[RefDisabilityDeterminationSourceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisabilityDeterminationSourceType]...';



ALTER TABLE [dbo].[RefDisabilityDeterminationSourceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisabilityType]...';



ALTER TABLE [dbo].[RefDisabilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisabilityType]...';



ALTER TABLE [dbo].[RefDisabilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisciplinaryActionTaken]...';



ALTER TABLE [dbo].[RefDisciplinaryActionTaken]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisciplinaryActionTaken]...';



ALTER TABLE [dbo].[RefDisciplinaryActionTaken]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisciplineLengthDifferenceReason]...';



ALTER TABLE [dbo].[RefDisciplineLengthDifferenceReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisciplineLengthDifferenceReason]...';



ALTER TABLE [dbo].[RefDisciplineLengthDifferenceReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisciplineMethodFirearms]...';



ALTER TABLE [dbo].[RefDisciplineMethodFirearms]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisciplineMethodFirearms]...';



ALTER TABLE [dbo].[RefDisciplineMethodFirearms]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisciplineMethodOfCwd]...';



ALTER TABLE [dbo].[RefDisciplineMethodOfCwd]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisciplineMethodOfCwd]...';



ALTER TABLE [dbo].[RefDisciplineMethodOfCwd]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDisciplineReason]...';



ALTER TABLE [dbo].[RefDisciplineReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDisciplineReason]...';



ALTER TABLE [dbo].[RefDisciplineReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDistanceEducationCourseEnrollment]...';



ALTER TABLE [dbo].[RefDistanceEducationCourseEnrollment]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDistanceEducationCourseEnrollment]...';



ALTER TABLE [dbo].[RefDistanceEducationCourseEnrollment]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDoctoralExamsRequiredCode]...';



ALTER TABLE [dbo].[RefDoctoralExamsRequiredCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDoctoralExamsRequiredCode]...';



ALTER TABLE [dbo].[RefDoctoralExamsRequiredCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefDQPCategoriesOfLearning]...';



ALTER TABLE [dbo].[RefDQPCategoriesOfLearning]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefDQPCategoriesOfLearning]...';



ALTER TABLE [dbo].[RefDQPCategoriesOfLearning]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodCredential]...';



ALTER TABLE [dbo].[RefEarlyChildhoodCredential]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodCredential]...';



ALTER TABLE [dbo].[RefEarlyChildhoodCredential]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodProgramEnrollmentType]...';



ALTER TABLE [dbo].[RefEarlyChildhoodProgramEnrollmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodProgramEnrollmentType]...';



ALTER TABLE [dbo].[RefEarlyChildhoodProgramEnrollmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodServices]...';



ALTER TABLE [dbo].[RefEarlyChildhoodServices]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEarlyChildhoodServices]...';



ALTER TABLE [dbo].[RefEarlyChildhoodServices]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEducationLevel]...';



ALTER TABLE [dbo].[RefEducationLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEducationLevel]...';



ALTER TABLE [dbo].[RefEducationLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEducationLevelType]...';



ALTER TABLE [dbo].[RefEducationLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEducationLevelType]...';



ALTER TABLE [dbo].[RefEducationLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEducationVerificationMethod]...';



ALTER TABLE [dbo].[RefEducationVerificationMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEducationVerificationMethod]...';



ALTER TABLE [dbo].[RefEducationVerificationMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELEducationStaffClassification]...';



ALTER TABLE [dbo].[RefELEducationStaffClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELEducationStaffClassification]...';



ALTER TABLE [dbo].[RefELEducationStaffClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefElementaryMiddleAdditional]...';



ALTER TABLE [dbo].[RefElementaryMiddleAdditional]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefElementaryMiddleAdditional]...';



ALTER TABLE [dbo].[RefElementaryMiddleAdditional]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELEmploymentSeparationReason]...';



ALTER TABLE [dbo].[RefELEmploymentSeparationReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELEmploymentSeparationReason]...';



ALTER TABLE [dbo].[RefELEmploymentSeparationReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELFacilityLicensingStatus]...';



ALTER TABLE [dbo].[RefELFacilityLicensingStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELFacilityLicensingStatus]...';



ALTER TABLE [dbo].[RefELFacilityLicensingStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELFederalFundingType]...';



ALTER TABLE [dbo].[RefELFederalFundingType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELFederalFundingType]...';



ALTER TABLE [dbo].[RefELFederalFundingType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELGroupSizeStandardMet]...';



ALTER TABLE [dbo].[RefELGroupSizeStandardMet]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELGroupSizeStandardMet]...';



ALTER TABLE [dbo].[RefELGroupSizeStandardMet]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELLevelOfSpecialization]...';



ALTER TABLE [dbo].[RefELLevelOfSpecialization]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELLevelOfSpecialization]...';



ALTER TABLE [dbo].[RefELLevelOfSpecialization]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELLocalRevenueSource]...';



ALTER TABLE [dbo].[RefELLocalRevenueSource]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELLocalRevenueSource]...';



ALTER TABLE [dbo].[RefELLocalRevenueSource]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELOtherFederalFundingSources]...';



ALTER TABLE [dbo].[RefELOtherFederalFundingSources]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELOtherFederalFundingSources]...';



ALTER TABLE [dbo].[RefELOtherFederalFundingSources]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELOutcomeMeasurementLevel]...';



ALTER TABLE [dbo].[RefELOutcomeMeasurementLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELOutcomeMeasurementLevel]...';



ALTER TABLE [dbo].[RefELOutcomeMeasurementLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELProfessionalDevelopmentTopicArea]...';



ALTER TABLE [dbo].[RefELProfessionalDevelopmentTopicArea]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELProfessionalDevelopmentTopicArea]...';



ALTER TABLE [dbo].[RefELProfessionalDevelopmentTopicArea]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELProgramEligibility]...';



ALTER TABLE [dbo].[RefELProgramEligibility]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELProgramEligibility]...';



ALTER TABLE [dbo].[RefELProgramEligibility]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELProgramEligibilityStatus]...';



ALTER TABLE [dbo].[RefELProgramEligibilityStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELProgramEligibilityStatus]...';



ALTER TABLE [dbo].[RefELProgramEligibilityStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELProgramLicenseStatus]...';



ALTER TABLE [dbo].[RefELProgramLicenseStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELProgramLicenseStatus]...';



ALTER TABLE [dbo].[RefELProgramLicenseStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELServiceProfessionalStaffClassification]...';



ALTER TABLE [dbo].[RefELServiceProfessionalStaffClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELServiceProfessionalStaffClassification]...';



ALTER TABLE [dbo].[RefELServiceProfessionalStaffClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELServiceType]...';



ALTER TABLE [dbo].[RefELServiceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELServiceType]...';



ALTER TABLE [dbo].[RefELServiceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELStateRevenueSource]...';



ALTER TABLE [dbo].[RefELStateRevenueSource]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELStateRevenueSource]...';



ALTER TABLE [dbo].[RefELStateRevenueSource]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefELTrainerCoreKnowledgeArea]...';



ALTER TABLE [dbo].[RefELTrainerCoreKnowledgeArea]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefELTrainerCoreKnowledgeArea]...';



ALTER TABLE [dbo].[RefELTrainerCoreKnowledgeArea]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmailType]...';



ALTER TABLE [dbo].[RefEmailType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmailType]...';



ALTER TABLE [dbo].[RefEmailType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmergencyOrProvisionalCredentialStatus]...';



ALTER TABLE [dbo].[RefEmergencyOrProvisionalCredentialStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefEmergencyOrProvisionalCredentialStatus]...';



ALTER TABLE [dbo].[RefEmergencyOrProvisionalCredentialStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmployedAfterExit]...';



ALTER TABLE [dbo].[RefEmployedAfterExit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmployedAfterExit]...';



ALTER TABLE [dbo].[RefEmployedAfterExit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmployedPriorToEnrollment]...';



ALTER TABLE [dbo].[RefEmployedPriorToEnrollment]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmployedPriorToEnrollment]...';



ALTER TABLE [dbo].[RefEmployedPriorToEnrollment]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmployedWhileEnrolled]...';



ALTER TABLE [dbo].[RefEmployedWhileEnrolled]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmployedWhileEnrolled]...';



ALTER TABLE [dbo].[RefEmployedWhileEnrolled]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmployeeBenefit]...';



ALTER TABLE [dbo].[RefEmployeeBenefit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmployeeBenefit]...';



ALTER TABLE [dbo].[RefEmployeeBenefit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentContractType]...';



ALTER TABLE [dbo].[RefEmploymentContractType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentContractType]...';



ALTER TABLE [dbo].[RefEmploymentContractType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentLocation]...';



ALTER TABLE [dbo].[RefEmploymentLocation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentLocation]...';



ALTER TABLE [dbo].[RefEmploymentLocation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentSeparationReason]...';



ALTER TABLE [dbo].[RefEmploymentSeparationReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentSeparationReason]...';



ALTER TABLE [dbo].[RefEmploymentSeparationReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentSeparationType]...';



ALTER TABLE [dbo].[RefEmploymentSeparationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentSeparationType]...';



ALTER TABLE [dbo].[RefEmploymentSeparationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentStatus]...';



ALTER TABLE [dbo].[RefEmploymentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentStatus]...';



ALTER TABLE [dbo].[RefEmploymentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEmploymentStatusWhileEnrolled]...';



ALTER TABLE [dbo].[RefEmploymentStatusWhileEnrolled]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEmploymentStatusWhileEnrolled]...';



ALTER TABLE [dbo].[RefEmploymentStatusWhileEnrolled]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEndOfTermStatus]...';



ALTER TABLE [dbo].[RefEndOfTermStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEndOfTermStatus]...';



ALTER TABLE [dbo].[RefEndOfTermStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEnrollmentStatus]...';



ALTER TABLE [dbo].[RefEnrollmentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEnrollmentStatus]...';



ALTER TABLE [dbo].[RefEnrollmentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEntityType]...';



ALTER TABLE [dbo].[RefEntityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEntityType]...';



ALTER TABLE [dbo].[RefEntityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEntryType]...';



ALTER TABLE [dbo].[RefEntryType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEntryType]...';



ALTER TABLE [dbo].[RefEntryType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefEnvironmentSetting]...';



ALTER TABLE [dbo].[RefEnvironmentSetting]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefEnvironmentSetting]...';



ALTER TABLE [dbo].[RefEnvironmentSetting]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefERAdministrativeDataSource]...';



ALTER TABLE [dbo].[RefERAdministrativeDataSource]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefERAdministrativeDataSource]...';



ALTER TABLE [dbo].[RefERAdministrativeDataSource]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefERSRuralUrbanContinuumCode]...';



ALTER TABLE [dbo].[RefERSRuralUrbanContinuumCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefERSRuralUrbanContinuumCode]...';



ALTER TABLE [dbo].[RefERSRuralUrbanContinuumCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefExitOrWithdrawalStatus]...';



ALTER TABLE [dbo].[RefExitOrWithdrawalStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefExitOrWithdrawalStatus]...';



ALTER TABLE [dbo].[RefExitOrWithdrawalStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefExitOrWithdrawalType]...';



ALTER TABLE [dbo].[RefExitOrWithdrawalType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefExitOrWithdrawalType]...';



ALTER TABLE [dbo].[RefExitOrWithdrawalType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitiesMandateAuthorityType]...';



ALTER TABLE [dbo].[RefFacilitiesMandateAuthorityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitiesMandateAuthorityType]...';



ALTER TABLE [dbo].[RefFacilitiesMandateAuthorityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitiesMgmtEmergencyType]...';



ALTER TABLE [dbo].[RefFacilitiesMgmtEmergencyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitiesMgmtEmergencyType]...';



ALTER TABLE [dbo].[RefFacilitiesMgmtEmergencyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitiesPlanType]...';



ALTER TABLE [dbo].[RefFacilitiesPlanType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitiesPlanType]...';



ALTER TABLE [dbo].[RefFacilitiesPlanType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityApplicableFederalMandateType]...';



ALTER TABLE [dbo].[RefFacilityApplicableFederalMandateType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityApplicableFederalMandateType]...';



ALTER TABLE [dbo].[RefFacilityApplicableFederalMandateType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityAuditType]...';



ALTER TABLE [dbo].[RefFacilityAuditType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityAuditType]...';



ALTER TABLE [dbo].[RefFacilityAuditType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityCapitalProgramMgmtType]...';



ALTER TABLE [dbo].[RefFacilityCapitalProgramMgmtType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityCapitalProgramMgmtType]...';



ALTER TABLE [dbo].[RefFacilityCapitalProgramMgmtType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityComplianceAgencyType]...';



ALTER TABLE [dbo].[RefFacilityComplianceAgencyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityComplianceAgencyType]...';



ALTER TABLE [dbo].[RefFacilityComplianceAgencyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityComplianceStatus]...';



ALTER TABLE [dbo].[RefFacilityComplianceStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityComplianceStatus]...';



ALTER TABLE [dbo].[RefFacilityComplianceStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityConstructionDateType]...';



ALTER TABLE [dbo].[RefFacilityConstructionDateType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityConstructionDateType]...';



ALTER TABLE [dbo].[RefFacilityConstructionDateType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityConstructionMaterialType]...';



ALTER TABLE [dbo].[RefFacilityConstructionMaterialType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityConstructionMaterialType]...';



ALTER TABLE [dbo].[RefFacilityConstructionMaterialType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityFederalMandateInterestType]...';



ALTER TABLE [dbo].[RefFacilityFederalMandateInterestType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityFederalMandateInterestType]...';



ALTER TABLE [dbo].[RefFacilityFederalMandateInterestType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityFinancingFeeType]...';



ALTER TABLE [dbo].[RefFacilityFinancingFeeType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityFinancingFeeType]...';



ALTER TABLE [dbo].[RefFacilityFinancingFeeType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityFurnishingsType]...';



ALTER TABLE [dbo].[RefFacilityFurnishingsType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityFurnishingsType]...';



ALTER TABLE [dbo].[RefFacilityFurnishingsType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityHazardousMaterialsOrCondType]...';



ALTER TABLE [dbo].[RefFacilityHazardousMaterialsOrCondType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityHazardousMaterialsOrCondType]...';



ALTER TABLE [dbo].[RefFacilityHazardousMaterialsOrCondType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityJointDevelopmentType]...';



ALTER TABLE [dbo].[RefFacilityJointDevelopmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityJointDevelopmentType]...';



ALTER TABLE [dbo].[RefFacilityJointDevelopmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityLeaseAmountCategory]...';



ALTER TABLE [dbo].[RefFacilityLeaseAmountCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityLeaseAmountCategory]...';



ALTER TABLE [dbo].[RefFacilityLeaseAmountCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityLeaseType]...';



ALTER TABLE [dbo].[RefFacilityLeaseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityLeaseType]...';



ALTER TABLE [dbo].[RefFacilityLeaseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityMaintStandardType]...';



ALTER TABLE [dbo].[RefFacilityMaintStandardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityMaintStandardType]...';



ALTER TABLE [dbo].[RefFacilityMaintStandardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityMortgageInterestType]...';



ALTER TABLE [dbo].[RefFacilityMortgageInterestType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityMortgageInterestType]...';



ALTER TABLE [dbo].[RefFacilityMortgageInterestType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityMortgageType]...';



ALTER TABLE [dbo].[RefFacilityMortgageType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityMortgageType]...';



ALTER TABLE [dbo].[RefFacilityMortgageType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityNaturallyOccurringHazardType]...';



ALTER TABLE [dbo].[RefFacilityNaturallyOccurringHazardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityNaturallyOccurringHazardType]...';



ALTER TABLE [dbo].[RefFacilityNaturallyOccurringHazardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityOperationsMgmtType]...';



ALTER TABLE [dbo].[RefFacilityOperationsMgmtType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityOperationsMgmtType]...';



ALTER TABLE [dbo].[RefFacilityOperationsMgmtType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitySiteImprovementLocationType]...';



ALTER TABLE [dbo].[RefFacilitySiteImprovementLocationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitySiteImprovementLocationType]...';



ALTER TABLE [dbo].[RefFacilitySiteImprovementLocationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitySiteOutdoorAreaType]...';



ALTER TABLE [dbo].[RefFacilitySiteOutdoorAreaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitySiteOutdoorAreaType]...';



ALTER TABLE [dbo].[RefFacilitySiteOutdoorAreaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityStandardType]...';



ALTER TABLE [dbo].[RefFacilityStandardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityStandardType]...';



ALTER TABLE [dbo].[RefFacilityStandardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityStateOrLocalMandateInterestType]...';



ALTER TABLE [dbo].[RefFacilityStateOrLocalMandateInterestType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityStateOrLocalMandateInterestType]...';



ALTER TABLE [dbo].[RefFacilityStateOrLocalMandateInterestType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilitySystemOrComponentCondition]...';



ALTER TABLE [dbo].[RefFacilitySystemOrComponentCondition]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilitySystemOrComponentCondition]...';



ALTER TABLE [dbo].[RefFacilitySystemOrComponentCondition]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityUtilityProviderType]...';



ALTER TABLE [dbo].[RefFacilityUtilityProviderType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityUtilityProviderType]...';



ALTER TABLE [dbo].[RefFacilityUtilityProviderType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFacilityUtilityType]...';



ALTER TABLE [dbo].[RefFacilityUtilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFacilityUtilityType]...';



ALTER TABLE [dbo].[RefFacilityUtilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFamilyIncomeSource]...';



ALTER TABLE [dbo].[RefFamilyIncomeSource]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFamilyIncomeSource]...';



ALTER TABLE [dbo].[RefFamilyIncomeSource]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFederalProgramFundingAllocationType]...';



ALTER TABLE [dbo].[RefFederalProgramFundingAllocationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFederalProgramFundingAllocationType]...';



ALTER TABLE [dbo].[RefFederalProgramFundingAllocationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAccountBalanceSheetCode]...';



ALTER TABLE [dbo].[RefFinancialAccountBalanceSheetCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAccountBalanceSheetCode]...';



ALTER TABLE [dbo].[RefFinancialAccountBalanceSheetCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAccountCategory]...';



ALTER TABLE [dbo].[RefFinancialAccountCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAccountCategory]...';



ALTER TABLE [dbo].[RefFinancialAccountCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAccountFundClassification]...';



ALTER TABLE [dbo].[RefFinancialAccountFundClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAccountFundClassification]...';



ALTER TABLE [dbo].[RefFinancialAccountFundClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAccountProgramCode]...';



ALTER TABLE [dbo].[RefFinancialAccountProgramCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAccountProgramCode]...';



ALTER TABLE [dbo].[RefFinancialAccountProgramCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAccountRevenueCode]...';



ALTER TABLE [dbo].[RefFinancialAccountRevenueCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAccountRevenueCode]...';



ALTER TABLE [dbo].[RefFinancialAccountRevenueCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAidApplicationType]...';



ALTER TABLE [dbo].[RefFinancialAidApplicationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAidApplicationType]...';



ALTER TABLE [dbo].[RefFinancialAidApplicationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAidAwardStatus]...';



ALTER TABLE [dbo].[RefFinancialAidAwardStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAidAwardStatus]...';



ALTER TABLE [dbo].[RefFinancialAidAwardStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAidAwardType]...';



ALTER TABLE [dbo].[RefFinancialAidAwardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAidAwardType]...';



ALTER TABLE [dbo].[RefFinancialAidAwardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAidVeteransBenefitStatus]...';



ALTER TABLE [dbo].[RefFinancialAidVeteransBenefitStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAidVeteransBenefitStatus]...';



ALTER TABLE [dbo].[RefFinancialAidVeteransBenefitStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialAidVeteransBenefitType]...';



ALTER TABLE [dbo].[RefFinancialAidVeteransBenefitType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialAidVeteransBenefitType]...';



ALTER TABLE [dbo].[RefFinancialAidVeteransBenefitType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureFunctionCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureFunctionCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureFunctionCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureFunctionCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureLevelOfInstructionCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureLevelOfInstructionCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureLevelOfInstructionCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureLevelOfInstructionCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureObjectCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureObjectCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFinancialExpenditureObjectCode]...';



ALTER TABLE [dbo].[RefFinancialExpenditureObjectCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFirearmType]...';



ALTER TABLE [dbo].[RefFirearmType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFirearmType]...';



ALTER TABLE [dbo].[RefFirearmType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFoodServiceEligibility]...';



ALTER TABLE [dbo].[RefFoodServiceEligibility]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFoodServiceEligibility]...';



ALTER TABLE [dbo].[RefFoodServiceEligibility]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFoodServiceParticipation]...';



ALTER TABLE [dbo].[RefFoodServiceParticipation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFoodServiceParticipation]...';



ALTER TABLE [dbo].[RefFoodServiceParticipation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFrequencyOfService]...';



ALTER TABLE [dbo].[RefFrequencyOfService]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFrequencyOfService]...';



ALTER TABLE [dbo].[RefFrequencyOfService]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFrequencyUnit]...';



ALTER TABLE [dbo].[RefFrequencyUnit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFrequencyUnit]...';



ALTER TABLE [dbo].[RefFrequencyUnit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefFullTimeStatus]...';



ALTER TABLE [dbo].[RefFullTimeStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefFullTimeStatus]...';



ALTER TABLE [dbo].[RefFullTimeStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefgoalMeasurementType]...';



ALTER TABLE [dbo].[RefgoalMeasurementType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefgoalMeasurementType]...';



ALTER TABLE [dbo].[RefgoalMeasurementType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefgoalsForAttendingAdultEducation]...';



ALTER TABLE [dbo].[RefgoalsForAttendingAdultEducation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefgoalsForAttendingAdultEducation]...';



ALTER TABLE [dbo].[RefgoalsForAttendingAdultEducation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefgoalStatusType]...';



ALTER TABLE [dbo].[RefgoalStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefgoalStatusType]...';



ALTER TABLE [dbo].[RefgoalStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGpaWeightedIndicator]...';



ALTER TABLE [dbo].[RefGpaWeightedIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGpaWeightedIndicator]...';



ALTER TABLE [dbo].[RefGpaWeightedIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGradeLevel]...';



ALTER TABLE [dbo].[RefGradeLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGradeLevel]...';



ALTER TABLE [dbo].[RefGradeLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGradeLevelType]...';



ALTER TABLE [dbo].[RefGradeLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGradeLevelType]...';



ALTER TABLE [dbo].[RefGradeLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGradePointAverageDomain]...';



ALTER TABLE [dbo].[RefGradePointAverageDomain]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGradePointAverageDomain]...';



ALTER TABLE [dbo].[RefGradePointAverageDomain]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGraduateAssistantIpedsCategory]...';



ALTER TABLE [dbo].[RefGraduateAssistantIpedsCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGraduateAssistantIpedsCategory]...';



ALTER TABLE [dbo].[RefGraduateAssistantIpedsCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefGraduateOrDoctoralExamResultsStatus]...';



ALTER TABLE [dbo].[RefGraduateOrDoctoralExamResultsStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefGraduateOrDoctoralExamResultsStatus]...';



ALTER TABLE [dbo].[RefGraduateOrDoctoralExamResultsStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefGunFreeSchoolsActReportingStatus]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefGunFreeSchoolsActReportingStatus] (
	[RefGunFreeSchoolsActReportingStatusId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefGunFreeSchoolsActStatusReporting1] PRIMARY KEY CLUSTERED ([RefGunFreeSchoolsActReportingStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefGunFreeSchoolsActReportingStatus])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefGunFreeSchoolsActReportingStatus] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefGunFreeSchoolsActReportingStatus] ([RefGunFreeSchoolsActReportingStatusId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefGunFreeSchoolsActReportingStatus' AND COLUMN_NAME = 'RefGunFreeSchoolsActStatusReportingId')
		BEGIN
			
			SET @sql = @sql + '
				SELECT   
				 [RefGunFreeSchoolsActStatusReportingId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefGunFreeSchoolsActReportingStatus]
		ORDER BY [RefGunFreeSchoolsActStatusReportingId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				SELECT   
				 [RefGunFreeSchoolsActReportingStatusId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefGunFreeSchoolsActReportingStatus]
		ORDER BY [RefGunFreeSchoolsActReportingStatusId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefGunFreeSchoolsActReportingStatus] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefGunFreeSchoolsActReportingStatus];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefGunFreeSchoolsActReportingStatus]', N'RefGunFreeSchoolsActReportingStatus';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefGunFreeSchoolsActStatusReporting1]', N'PK_RefGunFreeSchoolsActStatusReporting', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefHealthInsuranceCoverage]...';



ALTER TABLE [dbo].[RefHealthInsuranceCoverage]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHealthInsuranceCoverage]...';



ALTER TABLE [dbo].[RefHealthInsuranceCoverage]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefHearingScreeningStatus]...';



ALTER TABLE [dbo].[RefHearingScreeningStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHearingScreeningStatus]...';



ALTER TABLE [dbo].[RefHearingScreeningStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefHigherEducationInstitutionAccreditationStatus]...';



ALTER TABLE [dbo].[RefHigherEducationInstitutionAccreditationStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHigherEducationInstitutionAccreditationStatus]...';



ALTER TABLE [dbo].[RefHigherEducationInstitutionAccreditationStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefHighSchoolDiplomaDistinctionType]...';



ALTER TABLE [dbo].[RefHighSchoolDiplomaDistinctionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHighSchoolDiplomaDistinctionType]...';



ALTER TABLE [dbo].[RefHighSchoolDiplomaDistinctionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefHighSchoolDiplomaType]...';



ALTER TABLE [dbo].[RefHighSchoolDiplomaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHighSchoolDiplomaType]...';



ALTER TABLE [dbo].[RefHighSchoolDiplomaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefHighSchoolGraduationRateIndicator]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefHighSchoolGraduationRateIndicator] (
	[RefHighSchoolGraduationRateIndicatorId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefHSGraduationRateIndicator1] PRIMARY KEY CLUSTERED ([RefHighSchoolGraduationRateIndicatorId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefHighSchoolGraduationRateIndicator])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefHighSchoolGraduationRateIndicator] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefHighSchoolGraduationRateIndicator] ([RefHighSchoolGraduationRateIndicatorId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefHighSchoolGraduationRateIndicator' AND COLUMN_NAME = 'RefHSGraduationRateIndicatorId')
		BEGIN
			
			SET @sql = @sql + '
				SELECT   
				 [RefHSGraduationRateIndicatorId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefHighSchoolGraduationRateIndicator]
		ORDER BY [RefHSGraduationRateIndicatorId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
				SELECT   
				 [RefHighSchoolGraduationRateIndicatorId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefHighSchoolGraduationRateIndicator]
		ORDER BY [RefHSGraduationRateIndicatorId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefHighSchoolGraduationRateIndicator] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefHighSchoolGraduationRateIndicator];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefHighSchoolGraduationRateIndicator]', N'RefHighSchoolGraduationRateIndicator';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefHSGraduationRateIndicator1]', N'PK_RefHSGraduationRateIndicator', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefHomelessNighttimeResidence]...';



ALTER TABLE [dbo].[RefHomelessNighttimeResidence]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefHomelessNighttimeResidence]...';



ALTER TABLE [dbo].[RefHomelessNighttimeResidence]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEADisabilityType]...';



ALTER TABLE [dbo].[RefIDEADisabilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEADisabilityType]...';



ALTER TABLE [dbo].[RefIDEADisabilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEADisciplineMethodFirearm]...';



ALTER TABLE [dbo].[RefIDEADisciplineMethodFirearm]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEADisciplineMethodFirearm]...';



ALTER TABLE [dbo].[RefIDEADisciplineMethodFirearm]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAEducationalEnvironmentEC]...';



ALTER TABLE [dbo].[RefIDEAEducationalEnvironmentEC]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAEducationalEnvironmentEC]...';



ALTER TABLE [dbo].[RefIDEAEducationalEnvironmentEC]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefIDEAEducationalEnvironmentSchoolAge]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefIDEAEducationalEnvironmentSchoolAge] (
	[RefIDEAEducationalEnvironmentSchoolAgeId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefIDEAEducationalEnvironmentSchoolAge1] PRIMARY KEY CLUSTERED ([RefIDEAEducationalEnvironmentSchoolAgeId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefIDEAEducationalEnvironmentSchoolAge])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefIDEAEducationalEnvironmentSchoolAge] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefIDEAEducationalEnvironmentSchoolAge] ([RefIDEAEducationalEnvironmentSchoolAgeId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefIDEAEducationalEnvironmentSchoolAge' AND COLUMN_NAME = 'RefIDESEducationalEnvironmentSchoolAge')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [RefIDESEducationalEnvironmentSchoolAge],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefIDEAEducationalEnvironmentSchoolAge]
		ORDER BY [RefIDESEducationalEnvironmentSchoolAge] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [RefIDEAEducationalEnvironmentSchoolAgeId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefIDEAEducationalEnvironmentSchoolAge]
		ORDER BY [RefIDEAEducationalEnvironmentSchoolAgeId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefIDEAEducationalEnvironmentSchoolAge] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefIDEAEducationalEnvironmentSchoolAge];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefIDEAEducationalEnvironmentSchoolAge]', N'RefIDEAEducationalEnvironmentSchoolAge';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefIDEAEducationalEnvironmentSchoolAge1]', N'PK_RefIDEAEducationalEnvironmentSchoolAge', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefIDEAEligibilityEvaluationCategory]...';



ALTER TABLE [dbo].[RefIDEAEligibilityEvaluationCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAEligibilityEvaluationCategory]...';



ALTER TABLE [dbo].[RefIDEAEligibilityEvaluationCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAEnvironmentEL]...';



ALTER TABLE [dbo].[RefIDEAEnvironmentEL]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAEnvironmentEL]...';



ALTER TABLE [dbo].[RefIDEAEnvironmentEL]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAIEPStatus]...';



ALTER TABLE [dbo].[RefIDEAIEPStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAIEPStatus]...';



ALTER TABLE [dbo].[RefIDEAIEPStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAInterimRemoval]...';



ALTER TABLE [dbo].[RefIDEAInterimRemoval]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAInterimRemoval]...';



ALTER TABLE [dbo].[RefIDEAInterimRemoval]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAInterimRemovalReason]...';



ALTER TABLE [dbo].[RefIDEAInterimRemovalReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAInterimRemovalReason]...';



ALTER TABLE [dbo].[RefIDEAInterimRemovalReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIDEAPartCEligibilityCategory]...';



ALTER TABLE [dbo].[RefIDEAPartCEligibilityCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIDEAPartCEligibilityCategory]...';



ALTER TABLE [dbo].[RefIDEAPartCEligibilityCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIEPAuthorizationDocumentType]...';



ALTER TABLE [dbo].[RefIEPAuthorizationDocumentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIEPAuthorizationDocumentType]...';



ALTER TABLE [dbo].[RefIEPAuthorizationDocumentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIEPEligibilityEvaluationType]...';



ALTER TABLE [dbo].[RefIEPEligibilityEvaluationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIEPEligibilityEvaluationType]...';



ALTER TABLE [dbo].[RefIEPEligibilityEvaluationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIEPGoalType]...';



ALTER TABLE [dbo].[RefIEPGoalType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIEPGoalType]...';



ALTER TABLE [dbo].[RefIEPGoalType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefImmunizationType]...';



ALTER TABLE [dbo].[RefImmunizationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefImmunizationType]...';



ALTER TABLE [dbo].[RefImmunizationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentBehavior]...';



ALTER TABLE [dbo].[RefIncidentBehavior]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentBehavior]...';



ALTER TABLE [dbo].[RefIncidentBehavior]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentBehaviorSecondary]...';



ALTER TABLE [dbo].[RefIncidentBehaviorSecondary]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentBehaviorSecondary]...';



ALTER TABLE [dbo].[RefIncidentBehaviorSecondary]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentInjuryType]...';



ALTER TABLE [dbo].[RefIncidentInjuryType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentInjuryType]...';



ALTER TABLE [dbo].[RefIncidentInjuryType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentLocation]...';



ALTER TABLE [dbo].[RefIncidentLocation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentLocation]...';



ALTER TABLE [dbo].[RefIncidentLocation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentMultipleOffenseType]...';



ALTER TABLE [dbo].[RefIncidentMultipleOffenseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentMultipleOffenseType]...';



ALTER TABLE [dbo].[RefIncidentMultipleOffenseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentPerpetratorInjuryType]...';



ALTER TABLE [dbo].[RefIncidentPerpetratorInjuryType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentPerpetratorInjuryType]...';



ALTER TABLE [dbo].[RefIncidentPerpetratorInjuryType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentPersonRoleType]...';



ALTER TABLE [dbo].[RefIncidentPersonRoleType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentPersonRoleType]...';



ALTER TABLE [dbo].[RefIncidentPersonRoleType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentPersonType]...';



ALTER TABLE [dbo].[RefIncidentPersonType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentPersonType]...';



ALTER TABLE [dbo].[RefIncidentPersonType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentReporterType]...';



ALTER TABLE [dbo].[RefIncidentReporterType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentReporterType]...';



ALTER TABLE [dbo].[RefIncidentReporterType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncidentTimeDescriptionCode]...';



ALTER TABLE [dbo].[RefIncidentTimeDescriptionCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncidentTimeDescriptionCode]...';



ALTER TABLE [dbo].[RefIncidentTimeDescriptionCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncomeCalculationMethod]...';



ALTER TABLE [dbo].[RefIncomeCalculationMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncomeCalculationMethod]...';



ALTER TABLE [dbo].[RefIncomeCalculationMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIncreasedLearningTimeType]...';



ALTER TABLE [dbo].[RefIncreasedLearningTimeType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIncreasedLearningTimeType]...';



ALTER TABLE [dbo].[RefIncreasedLearningTimeType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndicatorStateDefinedStatus]...';



ALTER TABLE [dbo].[RefIndicatorStateDefinedStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefIndicatorStateDefinedStatus]...';



ALTER TABLE [dbo].[RefIndicatorStateDefinedStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusCustomType]...';



ALTER TABLE [dbo].[RefIndicatorStatusCustomType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusCustomType]...';



ALTER TABLE [dbo].[RefIndicatorStatusCustomType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusSubgroupType]...';



ALTER TABLE [dbo].[RefIndicatorStatusSubgroupType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusSubgroupType]...';



ALTER TABLE [dbo].[RefIndicatorStatusSubgroupType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusType]...';



ALTER TABLE [dbo].[RefIndicatorStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefIndicatorStatusType]...';



ALTER TABLE [dbo].[RefIndicatorStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramDateType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramDateType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramDateType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramDateType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramLocation]...';



ALTER TABLE [dbo].[RefIndividualizedProgramLocation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramLocation]...';



ALTER TABLE [dbo].[RefIndividualizedProgramLocation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramPlannedServiceType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramPlannedServiceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramPlannedServiceType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramPlannedServiceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramTransitionType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramTransitionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramTransitionType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramTransitionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIndividualizedProgramType]...';



ALTER TABLE [dbo].[RefIndividualizedProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstitutionTelephoneType]...';



ALTER TABLE [dbo].[RefInstitutionTelephoneType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstitutionTelephoneType]...';



ALTER TABLE [dbo].[RefInstitutionTelephoneType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstructionalActivityHours]...';



ALTER TABLE [dbo].[RefInstructionalActivityHours]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstructionalActivityHours]...';



ALTER TABLE [dbo].[RefInstructionalActivityHours]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstructionalStaffContractLength]...';



ALTER TABLE [dbo].[RefInstructionalStaffContractLength]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstructionalStaffContractLength]...';



ALTER TABLE [dbo].[RefInstructionalStaffContractLength]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstructionalStaffFacultyTenure]...';



ALTER TABLE [dbo].[RefInstructionalStaffFacultyTenure]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstructionalStaffFacultyTenure]...';



ALTER TABLE [dbo].[RefInstructionalStaffFacultyTenure]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstructionCreditType]...';



ALTER TABLE [dbo].[RefInstructionCreditType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstructionCreditType]...';



ALTER TABLE [dbo].[RefInstructionCreditType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInstructionLocationType]...';



ALTER TABLE [dbo].[RefInstructionLocationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInstructionLocationType]...';



ALTER TABLE [dbo].[RefInstructionLocationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIntegratedTechnologyStatus]...';



ALTER TABLE [dbo].[RefIntegratedTechnologyStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIntegratedTechnologyStatus]...';



ALTER TABLE [dbo].[RefIntegratedTechnologyStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefInternetAccess]...';



ALTER TABLE [dbo].[RefInternetAccess]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefInternetAccess]...';



ALTER TABLE [dbo].[RefInternetAccess]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBFinancialPosition]...';



ALTER TABLE [dbo].[RefIPEDSFASBFinancialPosition]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBFinancialPosition]...';



ALTER TABLE [dbo].[RefIPEDSFASBFinancialPosition]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBFunctionalExpense]...';



ALTER TABLE [dbo].[RefIPEDSFASBFunctionalExpense]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBFunctionalExpense]...';



ALTER TABLE [dbo].[RefIPEDSFASBFunctionalExpense]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBPellGrantTransactions]...';



ALTER TABLE [dbo].[RefIPEDSFASBPellGrantTransactions]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBPellGrantTransactions]...';



ALTER TABLE [dbo].[RefIPEDSFASBPellGrantTransactions]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBRevenue]...';



ALTER TABLE [dbo].[RefIPEDSFASBRevenue]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBRevenue]...';



ALTER TABLE [dbo].[RefIPEDSFASBRevenue]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBRevenueRestriction]...';



ALTER TABLE [dbo].[RefIPEDSFASBRevenueRestriction]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBRevenueRestriction]...';



ALTER TABLE [dbo].[RefIPEDSFASBRevenueRestriction]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBScholarshipsandFellowshipsRevenue]...';



ALTER TABLE [dbo].[RefIPEDSFASBScholarshipsandFellowshipsRevenue]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSFASBScholarshipsandFellowshipsRevenue]...';



ALTER TABLE [dbo].[RefIPEDSFASBScholarshipsandFellowshipsRevenue]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBFinancialPosition]...';



ALTER TABLE [dbo].[RefIPEDSGASBFinancialPosition]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBFinancialPosition]...';



ALTER TABLE [dbo].[RefIPEDSGASBFinancialPosition]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBFunctionalExpense]...';



ALTER TABLE [dbo].[RefIPEDSGASBFunctionalExpense]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBFunctionalExpense]...';



ALTER TABLE [dbo].[RefIPEDSGASBFunctionalExpense]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBRevenue]...';



ALTER TABLE [dbo].[RefIPEDSGASBRevenue]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBRevenue]...';



ALTER TABLE [dbo].[RefIPEDSGASBRevenue]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBScholarshipsandFellowshipsRevenue]...';



ALTER TABLE [dbo].[RefIPEDSGASBScholarshipsandFellowshipsRevenue]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSGASBScholarshipsandFellowshipsRevenue]...';



ALTER TABLE [dbo].[RefIPEDSGASBScholarshipsandFellowshipsRevenue]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSIntercollegiateAthleticsExpenses]...';



ALTER TABLE [dbo].[RefIPEDSIntercollegiateAthleticsExpenses]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSIntercollegiateAthleticsExpenses]...';



ALTER TABLE [dbo].[RefIPEDSIntercollegiateAthleticsExpenses]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPEDSNaturalExpense]...';



ALTER TABLE [dbo].[RefIPEDSNaturalExpense]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPEDSNaturalExpense]...';



ALTER TABLE [dbo].[RefIPEDSNaturalExpense]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIpedsOccupationalCategory]...';



ALTER TABLE [dbo].[RefIpedsOccupationalCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIpedsOccupationalCategory]...';



ALTER TABLE [dbo].[RefIpedsOccupationalCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPSPProgressReportSchedule]...';



ALTER TABLE [dbo].[RefIPSPProgressReportSchedule]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPSPProgressReportSchedule]...';



ALTER TABLE [dbo].[RefIPSPProgressReportSchedule]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefIPSPProgressReportType]...';



ALTER TABLE [dbo].[RefIPSPProgressReportType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefIPSPProgressReportType]...';



ALTER TABLE [dbo].[RefIPSPProgressReportType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefISO6392Language]...';



ALTER TABLE [dbo].[RefISO6392Language]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefISO6392Language]...';



ALTER TABLE [dbo].[RefISO6392Language]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefISO6393Language]...';



ALTER TABLE [dbo].[RefISO6393Language]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefISO6393Language]...';



ALTER TABLE [dbo].[RefISO6393Language]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefISO6395LanguageFamily]...';



ALTER TABLE [dbo].[RefISO6395LanguageFamily]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefISO6395LanguageFamily]...';



ALTER TABLE [dbo].[RefISO6395LanguageFamily]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefItemResponseTheoryDifficultyCategory]...';



ALTER TABLE [dbo].[RefItemResponseTheoryDifficultyCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefItemResponseTheoryDifficultyCategory]...';



ALTER TABLE [dbo].[RefItemResponseTheoryDifficultyCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefItemResponseTheoryKappaAlgorithm]...';



ALTER TABLE [dbo].[RefItemResponseTheoryKappaAlgorithm]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefItemResponseTheoryKappaAlgorithm]...';



ALTER TABLE [dbo].[RefItemResponseTheoryKappaAlgorithm]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefK12EndOfCourseRequirement]...';



ALTER TABLE [dbo].[RefK12EndOfCourseRequirement]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefK12EndOfCourseRequirement]...';



ALTER TABLE [dbo].[RefK12EndOfCourseRequirement]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefK12LeaTitleISupportService]...';



ALTER TABLE [dbo].[RefK12LeaTitleISupportService]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefK12LeaTitleISupportService]...';



ALTER TABLE [dbo].[RefK12LeaTitleISupportService]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefK12ResponsibilityType]...';



ALTER TABLE [dbo].[RefK12ResponsibilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefK12ResponsibilityType]...';



ALTER TABLE [dbo].[RefK12ResponsibilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefK12StaffClassification]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefK12StaffClassification] (
	[RefK12StaffClassificationId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefEducationStaffClassification1] PRIMARY KEY CLUSTERED ([RefK12StaffClassificationId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefK12StaffClassification])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefK12StaffClassification] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefK12StaffClassification] ([RefK12StaffClassificationId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefK12StaffClassification' AND COLUMN_NAME = 'RefEducationStaffClassificationId')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [RefEducationStaffClassificationId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefK12StaffClassification]
		ORDER BY [RefEducationStaffClassificationId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [RefK12StaffClassificationId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefK12StaffClassification]
		ORDER BY [RefK12StaffClassificationId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefK12StaffClassification] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefK12StaffClassification];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefK12StaffClassification]', N'RefK12StaffClassification';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefEducationStaffClassification1]', N'PK_RefEducationStaffClassification', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefLanguage]...';



ALTER TABLE [dbo].[RefLanguage]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLanguage]...';



ALTER TABLE [dbo].[RefLanguage]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLanguageUseType]...';



ALTER TABLE [dbo].[RefLanguageUseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLanguageUseType]...';



ALTER TABLE [dbo].[RefLanguageUseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLeaFundsTransferType]...';



ALTER TABLE [dbo].[RefLeaFundsTransferType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLeaFundsTransferType]...';



ALTER TABLE [dbo].[RefLeaFundsTransferType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLeaImprovementStatus]...';



ALTER TABLE [dbo].[RefLeaImprovementStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLeaImprovementStatus]...';



ALTER TABLE [dbo].[RefLeaImprovementStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearnerActionType]...';



ALTER TABLE [dbo].[RefLearnerActionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearnerActionType]...';



ALTER TABLE [dbo].[RefLearnerActionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearnerActivityAddToGradeBookFlag]...';



ALTER TABLE [dbo].[RefLearnerActivityAddToGradeBookFlag]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearnerActivityAddToGradeBookFlag]...';



ALTER TABLE [dbo].[RefLearnerActivityAddToGradeBookFlag]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearnerActivityMaximumTimeAllowedUnits]...';



ALTER TABLE [dbo].[RefLearnerActivityMaximumTimeAllowedUnits]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearnerActivityMaximumTimeAllowedUnits]...';



ALTER TABLE [dbo].[RefLearnerActivityMaximumTimeAllowedUnits]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearnerActivityType]...';



ALTER TABLE [dbo].[RefLearnerActivityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearnerActivityType]...';



ALTER TABLE [dbo].[RefLearnerActivityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessAPIType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessAPIType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessAPIType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessAPIType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessHazardType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessHazardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessHazardType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessHazardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessModeType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessModeType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessModeType]...';



ALTER TABLE [dbo].[RefLearningResourceAccessModeType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessRightsUrl]...';



ALTER TABLE [dbo].[RefLearningResourceAccessRightsUrl]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceAccessRightsUrl]...';



ALTER TABLE [dbo].[RefLearningResourceAccessRightsUrl]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceAuthorType]...';



ALTER TABLE [dbo].[RefLearningResourceAuthorType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceAuthorType]...';



ALTER TABLE [dbo].[RefLearningResourceAuthorType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceBookFormatType]...';



ALTER TABLE [dbo].[RefLearningResourceBookFormatType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceBookFormatType]...';



ALTER TABLE [dbo].[RefLearningResourceBookFormatType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceCompetencyAlignmentType]...';



ALTER TABLE [dbo].[RefLearningResourceCompetencyAlignmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceCompetencyAlignmentType]...';



ALTER TABLE [dbo].[RefLearningResourceCompetencyAlignmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceControlFlexibilityType]...';



ALTER TABLE [dbo].[RefLearningResourceControlFlexibilityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceControlFlexibilityType]...';



ALTER TABLE [dbo].[RefLearningResourceControlFlexibilityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceDigitalMediaSubType]...';



ALTER TABLE [dbo].[RefLearningResourceDigitalMediaSubType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceDigitalMediaSubType]...';



ALTER TABLE [dbo].[RefLearningResourceDigitalMediaSubType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceDigitalMediaType]...';



ALTER TABLE [dbo].[RefLearningResourceDigitalMediaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceDigitalMediaType]...';



ALTER TABLE [dbo].[RefLearningResourceDigitalMediaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceEducationalUse]...';



ALTER TABLE [dbo].[RefLearningResourceEducationalUse]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceEducationalUse]...';



ALTER TABLE [dbo].[RefLearningResourceEducationalUse]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceIntendedEndUserRole]...';



ALTER TABLE [dbo].[RefLearningResourceIntendedEndUserRole]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceIntendedEndUserRole]...';



ALTER TABLE [dbo].[RefLearningResourceIntendedEndUserRole]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceInteractionMode]...';



ALTER TABLE [dbo].[RefLearningResourceInteractionMode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceInteractionMode]...';



ALTER TABLE [dbo].[RefLearningResourceInteractionMode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceInteractivityType]...';



ALTER TABLE [dbo].[RefLearningResourceInteractivityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceInteractivityType]...';



ALTER TABLE [dbo].[RefLearningResourceInteractivityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceMediaFeatureType]...';



ALTER TABLE [dbo].[RefLearningResourceMediaFeatureType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceMediaFeatureType]...';



ALTER TABLE [dbo].[RefLearningResourceMediaFeatureType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourcePhysicalMediaType]...';



ALTER TABLE [dbo].[RefLearningResourcePhysicalMediaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourcePhysicalMediaType]...';



ALTER TABLE [dbo].[RefLearningResourcePhysicalMediaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLearningResourceType]...';



ALTER TABLE [dbo].[RefLearningResourceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLearningResourceType]...';



ALTER TABLE [dbo].[RefLearningResourceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLeaType]...';



ALTER TABLE [dbo].[RefLeaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLeaType]...';



ALTER TABLE [dbo].[RefLeaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLeaveEventType]...';



ALTER TABLE [dbo].[RefLeaveEventType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLeaveEventType]...';



ALTER TABLE [dbo].[RefLeaveEventType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLevelOfInstitution]...';



ALTER TABLE [dbo].[RefLevelOfInstitution]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLevelOfInstitution]...';



ALTER TABLE [dbo].[RefLevelOfInstitution]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLicenseExempt]...';



ALTER TABLE [dbo].[RefLicenseExempt]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLicenseExempt]...';



ALTER TABLE [dbo].[RefLicenseExempt]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefLiteracyAssessment]...';



ALTER TABLE [dbo].[RefLiteracyAssessment]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefLiteracyAssessment]...';



ALTER TABLE [dbo].[RefLiteracyAssessment]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMagnetSpecialProgram]...';



ALTER TABLE [dbo].[RefMagnetSpecialProgram]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMagnetSpecialProgram]...';



ALTER TABLE [dbo].[RefMagnetSpecialProgram]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMedicalAlertIndicator]...';



ALTER TABLE [dbo].[RefMedicalAlertIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMedicalAlertIndicator]...';



ALTER TABLE [dbo].[RefMedicalAlertIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepEnrollmentType]...';



ALTER TABLE [dbo].[RefMepEnrollmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepEnrollmentType]...';



ALTER TABLE [dbo].[RefMepEnrollmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepProjectBased]...';



ALTER TABLE [dbo].[RefMepProjectBased]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepProjectBased]...';



ALTER TABLE [dbo].[RefMepProjectBased]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepProjectType]...';



ALTER TABLE [dbo].[RefMepProjectType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepProjectType]...';



ALTER TABLE [dbo].[RefMepProjectType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepServiceType]...';



ALTER TABLE [dbo].[RefMepServiceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepServiceType]...';



ALTER TABLE [dbo].[RefMepServiceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepSessionType]...';



ALTER TABLE [dbo].[RefMepSessionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepSessionType]...';



ALTER TABLE [dbo].[RefMepSessionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMepStaffCategory]...';



ALTER TABLE [dbo].[RefMepStaffCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMepStaffCategory]...';



ALTER TABLE [dbo].[RefMepStaffCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMethodOfServiceDelivery]...';



ALTER TABLE [dbo].[RefMethodOfServiceDelivery]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMethodOfServiceDelivery]...';



ALTER TABLE [dbo].[RefMethodOfServiceDelivery]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMilitaryActiveStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryActiveStudentIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMilitaryActiveStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryActiveStudentIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMilitaryBranch]...';



ALTER TABLE [dbo].[RefMilitaryBranch]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMilitaryBranch]...';



ALTER TABLE [dbo].[RefMilitaryBranch]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMilitaryConnectedStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryConnectedStudentIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMilitaryConnectedStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryConnectedStudentIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMilitaryVeteranStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryVeteranStudentIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMilitaryVeteranStudentIndicator]...';



ALTER TABLE [dbo].[RefMilitaryVeteranStudentIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefMultipleIntelligenceType]...';



ALTER TABLE [dbo].[RefMultipleIntelligenceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefMultipleIntelligenceType]...';



ALTER TABLE [dbo].[RefMultipleIntelligenceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNaepAspectsOfReading]...';



ALTER TABLE [dbo].[RefNaepAspectsOfReading]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNaepAspectsOfReading]...';



ALTER TABLE [dbo].[RefNaepAspectsOfReading]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNaepMathComplexityLevel]...';



ALTER TABLE [dbo].[RefNaepMathComplexityLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNaepMathComplexityLevel]...';



ALTER TABLE [dbo].[RefNaepMathComplexityLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNationalSchoolLunchProgramStatus]...';



ALTER TABLE [dbo].[RefNationalSchoolLunchProgramStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNationalSchoolLunchProgramStatus]...';



ALTER TABLE [dbo].[RefNationalSchoolLunchProgramStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNCESCollegeCourseMapCode]...';



ALTER TABLE [dbo].[RefNCESCollegeCourseMapCode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNCESCollegeCourseMapCode]...';



ALTER TABLE [dbo].[RefNCESCollegeCourseMapCode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNeedDeterminationMethod]...';



ALTER TABLE [dbo].[RefNeedDeterminationMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNeedDeterminationMethod]...';



ALTER TABLE [dbo].[RefNeedDeterminationMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNeglectedProgramType]...';



ALTER TABLE [dbo].[RefNeglectedProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNeglectedProgramType]...';



ALTER TABLE [dbo].[RefNeglectedProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNonPromotionReason]...';



ALTER TABLE [dbo].[RefNonPromotionReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNonPromotionReason]...';



ALTER TABLE [dbo].[RefNonPromotionReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNonTraditionalGenderStatus]...';



ALTER TABLE [dbo].[RefNonTraditionalGenderStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNonTraditionalGenderStatus]...';



ALTER TABLE [dbo].[RefNonTraditionalGenderStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefNSLPStatus]...';



ALTER TABLE [dbo].[RefNSLPStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefNSLPStatus]...';



ALTER TABLE [dbo].[RefNSLPStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefONETSOCOccupationType]...';



ALTER TABLE [dbo].[RefONETSOCOccupationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefONETSOCOccupationType]...';



ALTER TABLE [dbo].[RefONETSOCOccupationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOperationalStatus]...';



ALTER TABLE [dbo].[RefOperationalStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOperationalStatus]...';



ALTER TABLE [dbo].[RefOperationalStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOperationalStatusType]...';



ALTER TABLE [dbo].[RefOperationalStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOperationalStatusType]...';



ALTER TABLE [dbo].[RefOperationalStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationElementType]...';



ALTER TABLE [dbo].[RefOrganizationElementType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationElementType]...';



ALTER TABLE [dbo].[RefOrganizationElementType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationIdentificationSystem]...';



ALTER TABLE [dbo].[RefOrganizationIdentificationSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationIdentificationSystem]...';



ALTER TABLE [dbo].[RefOrganizationIdentificationSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationIdentifierType]...';



ALTER TABLE [dbo].[RefOrganizationIdentifierType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationIdentifierType]...';



ALTER TABLE [dbo].[RefOrganizationIdentifierType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationIndicator]...';



ALTER TABLE [dbo].[RefOrganizationIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationIndicator]...';



ALTER TABLE [dbo].[RefOrganizationIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationLocationType]...';



ALTER TABLE [dbo].[RefOrganizationLocationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationLocationType]...';



ALTER TABLE [dbo].[RefOrganizationLocationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationMonitoringNotifications]...';



ALTER TABLE [dbo].[RefOrganizationMonitoringNotifications]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationMonitoringNotifications]...';



ALTER TABLE [dbo].[RefOrganizationMonitoringNotifications]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationRelationship]...';



ALTER TABLE [dbo].[RefOrganizationRelationship]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationRelationship]...';



ALTER TABLE [dbo].[RefOrganizationRelationship]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOrganizationType]...';



ALTER TABLE [dbo].[RefOrganizationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOrganizationType]...';



ALTER TABLE [dbo].[RefOrganizationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOtherNameType]...';



ALTER TABLE [dbo].[RefOtherNameType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOtherNameType]...';



ALTER TABLE [dbo].[RefOtherNameType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOutcomeTimePoint]...';



ALTER TABLE [dbo].[RefOutcomeTimePoint]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefOutcomeTimePoint]...';



ALTER TABLE [dbo].[RefOutcomeTimePoint]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefOutOfFieldStatus]...';



ALTER TABLE [dbo].[RefOutOfFieldStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefOutOfFieldStatus]...';



ALTER TABLE [dbo].[RefOutOfFieldStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefParaprofessionalQualification]...';



ALTER TABLE [dbo].[RefParaprofessionalQualification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefParaprofessionalQualification]...';



ALTER TABLE [dbo].[RefParaprofessionalQualification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefParticipationStatusAyp]...';



ALTER TABLE [dbo].[RefParticipationStatusAyp]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefParticipationStatusAyp]...';



ALTER TABLE [dbo].[RefParticipationStatusAyp]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefParticipationType]...';



ALTER TABLE [dbo].[RefParticipationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefParticipationType]...';



ALTER TABLE [dbo].[RefParticipationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefPDActivityApprovedPurpose]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefPDActivityApprovedPurpose] (
	[RefPDActivityApprovedPurposeId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_RefPDActivityApprovedFor1] PRIMARY KEY CLUSTERED ([RefPDActivityApprovedPurposeId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefPDActivityApprovedPurpose])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefPDActivityApprovedPurpose] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefPDActivityApprovedPurpose] ([RefPDActivityApprovedPurposeId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefPDActivityApprovedPurpose' AND COLUMN_NAME = 'RefPDActivityApprovedForId')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [RefPDActivityApprovedForId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefPDActivityApprovedPurpose]
		ORDER BY [RefPDActivityApprovedForId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [RefPDActivityApprovedPurposeId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefPDActivityApprovedPurpose]
		ORDER BY [RefPDActivityApprovedPurposeId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefPDActivityApprovedPurpose] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefPDActivityApprovedPurpose];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefPDActivityApprovedPurpose]', N'RefPDActivityApprovedPurpose';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_RefPDActivityApprovedFor1]', N'PK_RefPDActivityApprovedFor', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefPDActivityCreditType]...';



ALTER TABLE [dbo].[RefPDActivityCreditType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDActivityCreditType]...';



ALTER TABLE [dbo].[RefPDActivityCreditType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDActivityEducationLevelsAddressed]...';



ALTER TABLE [dbo].[RefPDActivityEducationLevelsAddressed]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDActivityEducationLevelsAddressed]...';



ALTER TABLE [dbo].[RefPDActivityEducationLevelsAddressed]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDActivityLevel]...';



ALTER TABLE [dbo].[RefPDActivityLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDActivityLevel]...';



ALTER TABLE [dbo].[RefPDActivityLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDActivityTargetAudience]...';



ALTER TABLE [dbo].[RefPDActivityTargetAudience]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDActivityTargetAudience]...';



ALTER TABLE [dbo].[RefPDActivityTargetAudience]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDActivityType]...';



ALTER TABLE [dbo].[RefPDActivityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDActivityType]...';



ALTER TABLE [dbo].[RefPDActivityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDAudienceType]...';



ALTER TABLE [dbo].[RefPDAudienceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDAudienceType]...';



ALTER TABLE [dbo].[RefPDAudienceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDDeliveryMethod]...';



ALTER TABLE [dbo].[RefPDDeliveryMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDDeliveryMethod]...';



ALTER TABLE [dbo].[RefPDDeliveryMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDInstructionalDeliveryMode]...';



ALTER TABLE [dbo].[RefPDInstructionalDeliveryMode]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDInstructionalDeliveryMode]...';



ALTER TABLE [dbo].[RefPDInstructionalDeliveryMode]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPDSessionStatus]...';



ALTER TABLE [dbo].[RefPDSessionStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPDSessionStatus]...';



ALTER TABLE [dbo].[RefPDSessionStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPersonalInformationVerification]...';



ALTER TABLE [dbo].[RefPersonalInformationVerification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonalInformationVerification]...';



ALTER TABLE [dbo].[RefPersonalInformationVerification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPersonIdentificationSystem]...';



ALTER TABLE [dbo].[RefPersonIdentificationSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonIdentificationSystem]...';



ALTER TABLE [dbo].[RefPersonIdentificationSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPersonIdentifierType]...';



ALTER TABLE [dbo].[RefPersonIdentifierType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonIdentifierType]...';



ALTER TABLE [dbo].[RefPersonIdentifierType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPersonLocationType]...';



ALTER TABLE [dbo].[RefPersonLocationType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonLocationType]...';



ALTER TABLE [dbo].[RefPersonLocationType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefPersonRelationshipType]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefPersonRelationshipType] (
	[RefPersonRelationshipTypeId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (4000)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_XPKRefRelationship1] PRIMARY KEY CLUSTERED ([RefPersonRelationshipTypeId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefPersonRelationship])
	BEGIN
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefPersonRelationshipType] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefPersonRelationshipType] ([RefPersonRelationshipTypeId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		SELECT   
				 [RefPersonRelationshipId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefPersonRelationship]
		ORDER BY [RefPersonRelationshipId] ASC;
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefPersonRelationshipType] OFF;
	END

DROP TABLE [dbo].[RefPersonRelationship];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefPersonRelationshipType]', N'RefPersonRelationshipType';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_XPKRefRelationship1]', N'XPKRefRelationship', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefPersonStatusType]...';



ALTER TABLE [dbo].[RefPersonStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonStatusType]...';



ALTER TABLE [dbo].[RefPersonStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPersonTelephoneNumberType]...';



ALTER TABLE [dbo].[RefPersonTelephoneNumberType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPersonTelephoneNumberType]...';



ALTER TABLE [dbo].[RefPersonTelephoneNumberType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPESCAwardLevelType]...';



ALTER TABLE [dbo].[RefPESCAwardLevelType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPESCAwardLevelType]...';



ALTER TABLE [dbo].[RefPESCAwardLevelType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPopulationServed]...';



ALTER TABLE [dbo].[RefPopulationServed]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPopulationServed]...';



ALTER TABLE [dbo].[RefPopulationServed]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPreAndPostTestIndicator]...';



ALTER TABLE [dbo].[RefPreAndPostTestIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPreAndPostTestIndicator]...';



ALTER TABLE [dbo].[RefPreAndPostTestIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPredominantCalendarSystem]...';



ALTER TABLE [dbo].[RefPredominantCalendarSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPredominantCalendarSystem]...';



ALTER TABLE [dbo].[RefPredominantCalendarSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPreKEligibleAgesNonIDEA]...';



ALTER TABLE [dbo].[RefPreKEligibleAgesNonIDEA]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPreKEligibleAgesNonIDEA]...';



ALTER TABLE [dbo].[RefPreKEligibleAgesNonIDEA]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPrekindergartenEligibility]...';



ALTER TABLE [dbo].[RefPrekindergartenEligibility]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPrekindergartenEligibility]...';



ALTER TABLE [dbo].[RefPrekindergartenEligibility]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPresentAttendanceCategory]...';



ALTER TABLE [dbo].[RefPresentAttendanceCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPresentAttendanceCategory]...';



ALTER TABLE [dbo].[RefPresentAttendanceCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProfessionalDevelopmentFinancialSupport]...';



ALTER TABLE [dbo].[RefProfessionalDevelopmentFinancialSupport]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProfessionalDevelopmentFinancialSupport]...';



ALTER TABLE [dbo].[RefProfessionalDevelopmentFinancialSupport]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProfessionalEducationJobClassification]...';



ALTER TABLE [dbo].[RefProfessionalEducationJobClassification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProfessionalEducationJobClassification]...';



ALTER TABLE [dbo].[RefProfessionalEducationJobClassification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProfessionalTechnicalCredentialType]...';



ALTER TABLE [dbo].[RefProfessionalTechnicalCredentialType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProfessionalTechnicalCredentialType]...';



ALTER TABLE [dbo].[RefProfessionalTechnicalCredentialType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProficiencyStatus]...';



ALTER TABLE [dbo].[RefProficiencyStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProficiencyStatus]...';



ALTER TABLE [dbo].[RefProficiencyStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProficiencyTargetAyp]...';



ALTER TABLE [dbo].[RefProficiencyTargetAyp]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProficiencyTargetAyp]...';



ALTER TABLE [dbo].[RefProficiencyTargetAyp]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProfitStatus]...';



ALTER TABLE [dbo].[RefProfitStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProfitStatus]...';



ALTER TABLE [dbo].[RefProfitStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramDayLength]...';



ALTER TABLE [dbo].[RefProgramDayLength]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramDayLength]...';



ALTER TABLE [dbo].[RefProgramDayLength]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramExitReason]...';



ALTER TABLE [dbo].[RefProgramExitReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramExitReason]...';



ALTER TABLE [dbo].[RefProgramExitReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramGiftedEligibility]...';



ALTER TABLE [dbo].[RefProgramGiftedEligibility]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramGiftedEligibility]...';



ALTER TABLE [dbo].[RefProgramGiftedEligibility]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramLengthHoursType]...';



ALTER TABLE [dbo].[RefProgramLengthHoursType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramLengthHoursType]...';



ALTER TABLE [dbo].[RefProgramLengthHoursType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramSponsorType]...';



ALTER TABLE [dbo].[RefProgramSponsorType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramSponsorType]...';



ALTER TABLE [dbo].[RefProgramSponsorType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgramType]...';



ALTER TABLE [dbo].[RefProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgramType]...';



ALTER TABLE [dbo].[RefProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]...';



ALTER TABLE [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]...';



ALTER TABLE [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProgressLevel]...';



ALTER TABLE [dbo].[RefProgressLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProgressLevel]...';



ALTER TABLE [dbo].[RefProgressLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPromotionReason]...';



ALTER TABLE [dbo].[RefPromotionReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPromotionReason]...';



ALTER TABLE [dbo].[RefPromotionReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefProofOfResidencyType]...';



ALTER TABLE [dbo].[RefProofOfResidencyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefProofOfResidencyType]...';



ALTER TABLE [dbo].[RefProofOfResidencyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentAction]...';



ALTER TABLE [dbo].[RefPsEnrollmentAction]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentAction]...';



ALTER TABLE [dbo].[RefPsEnrollmentAction]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentAwardType]...';



ALTER TABLE [dbo].[RefPsEnrollmentAwardType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentAwardType]...';



ALTER TABLE [dbo].[RefPsEnrollmentAwardType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentStatus]...';



ALTER TABLE [dbo].[RefPsEnrollmentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentStatus]...';



ALTER TABLE [dbo].[RefPsEnrollmentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentType]...';



ALTER TABLE [dbo].[RefPsEnrollmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsEnrollmentType]...';



ALTER TABLE [dbo].[RefPsEnrollmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPSExitOrWithdrawalType]...';



ALTER TABLE [dbo].[RefPSExitOrWithdrawalType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPSExitOrWithdrawalType]...';



ALTER TABLE [dbo].[RefPSExitOrWithdrawalType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsLepType]...';



ALTER TABLE [dbo].[RefPsLepType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsLepType]...';



ALTER TABLE [dbo].[RefPsLepType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPSProgramLevel]...';



ALTER TABLE [dbo].[RefPSProgramLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPSProgramLevel]...';



ALTER TABLE [dbo].[RefPSProgramLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPsStudentLevel]...';



ALTER TABLE [dbo].[RefPsStudentLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPsStudentLevel]...';



ALTER TABLE [dbo].[RefPsStudentLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPublicSchoolChoiceStatus]...';



ALTER TABLE [dbo].[RefPublicSchoolChoiceStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPublicSchoolChoiceStatus]...';



ALTER TABLE [dbo].[RefPublicSchoolChoiceStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPublicSchoolResidence]...';



ALTER TABLE [dbo].[RefPublicSchoolResidence]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPublicSchoolResidence]...';



ALTER TABLE [dbo].[RefPublicSchoolResidence]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefPurposeOfMonitoringVisit]...';



ALTER TABLE [dbo].[RefPurposeOfMonitoringVisit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefPurposeOfMonitoringVisit]...';



ALTER TABLE [dbo].[RefPurposeOfMonitoringVisit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefQrisParticipation]...';



ALTER TABLE [dbo].[RefQrisParticipation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefQrisParticipation]...';



ALTER TABLE [dbo].[RefQrisParticipation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefRace]...';



ALTER TABLE [dbo].[RefRace]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefRace]...';



ALTER TABLE [dbo].[RefRace]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefReapAlternativeFundingStatus]...';



ALTER TABLE [dbo].[RefReapAlternativeFundingStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefReapAlternativeFundingStatus]...';



ALTER TABLE [dbo].[RefReapAlternativeFundingStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefReasonDelayTransitionConf]...';



ALTER TABLE [dbo].[RefReasonDelayTransitionConf]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefReasonDelayTransitionConf]...';



ALTER TABLE [dbo].[RefReasonDelayTransitionConf]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefReconstitutedStatus]...';



ALTER TABLE [dbo].[RefReconstitutedStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefReconstitutedStatus]...';



ALTER TABLE [dbo].[RefReconstitutedStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefReferralOutcome]...';



ALTER TABLE [dbo].[RefReferralOutcome]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefReferralOutcome]...';



ALTER TABLE [dbo].[RefReferralOutcome]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefReimbursementType]...';



ALTER TABLE [dbo].[RefReimbursementType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefReimbursementType]...';



ALTER TABLE [dbo].[RefReimbursementType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefRestructuringAction]...';



ALTER TABLE [dbo].[RefRestructuringAction]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefRestructuringAction]...';



ALTER TABLE [dbo].[RefRestructuringAction]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefRlisProgramUse]...';



ALTER TABLE [dbo].[RefRlisProgramUse]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefRlisProgramUse]...';



ALTER TABLE [dbo].[RefRlisProgramUse]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefRoleStatus]...';



ALTER TABLE [dbo].[RefRoleStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefRoleStatus]...';



ALTER TABLE [dbo].[RefRoleStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefRoleStatusType]...';



ALTER TABLE [dbo].[RefRoleStatusType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefRoleStatusType]...';



ALTER TABLE [dbo].[RefRoleStatusType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSCEDCourseLevel]...';



ALTER TABLE [dbo].[RefSCEDCourseLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSCEDCourseLevel]...';



ALTER TABLE [dbo].[RefSCEDCourseLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSCEDCourseSubjectArea]...';



ALTER TABLE [dbo].[RefSCEDCourseSubjectArea]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSCEDCourseSubjectArea]...';



ALTER TABLE [dbo].[RefSCEDCourseSubjectArea]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefScheduledWellChildScreening]...';



ALTER TABLE [dbo].[RefScheduledWellChildScreening]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefScheduledWellChildScreening]...';



ALTER TABLE [dbo].[RefScheduledWellChildScreening]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolDangerousStatus]...';



ALTER TABLE [dbo].[RefSchoolDangerousStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolDangerousStatus]...';



ALTER TABLE [dbo].[RefSchoolDangerousStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolFoodServiceProgram]...';



ALTER TABLE [dbo].[RefSchoolFoodServiceProgram]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolFoodServiceProgram]...';



ALTER TABLE [dbo].[RefSchoolFoodServiceProgram]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolImprovementFunds]...';



ALTER TABLE [dbo].[RefSchoolImprovementFunds]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolImprovementFunds]...';



ALTER TABLE [dbo].[RefSchoolImprovementFunds]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolImprovementStatus]...';



ALTER TABLE [dbo].[RefSchoolImprovementStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolImprovementStatus]...';



ALTER TABLE [dbo].[RefSchoolImprovementStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolLevel]...';



ALTER TABLE [dbo].[RefSchoolLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolLevel]...';



ALTER TABLE [dbo].[RefSchoolLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSchoolType]...';



ALTER TABLE [dbo].[RefSchoolType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSchoolType]...';



ALTER TABLE [dbo].[RefSchoolType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefScoreMetricType]...';



ALTER TABLE [dbo].[RefScoreMetricType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefScoreMetricType]...';



ALTER TABLE [dbo].[RefScoreMetricType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefServiceFrequency]...';



ALTER TABLE [dbo].[RefServiceFrequency]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefServiceFrequency]...';



ALTER TABLE [dbo].[RefServiceFrequency]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefServiceOption]...';



ALTER TABLE [dbo].[RefServiceOption]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefServiceOption]...';



ALTER TABLE [dbo].[RefServiceOption]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefServices]...';



ALTER TABLE [dbo].[RefServices]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefServices]...';



ALTER TABLE [dbo].[RefServices]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSessionType]...';



ALTER TABLE [dbo].[RefSessionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSessionType]...';



ALTER TABLE [dbo].[RefSessionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSex]...';



ALTER TABLE [dbo].[RefSex]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSex]...';



ALTER TABLE [dbo].[RefSex]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSigInterventionType]...';



ALTER TABLE [dbo].[RefSigInterventionType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSigInterventionType]...';



ALTER TABLE [dbo].[RefSigInterventionType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSingleSexClassStatus]...';



ALTER TABLE [dbo].[RefSingleSexClassStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSingleSexClassStatus]...';



ALTER TABLE [dbo].[RefSingleSexClassStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSpaceUseType]...';



ALTER TABLE [dbo].[RefSpaceUseType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSpaceUseType]...';



ALTER TABLE [dbo].[RefSpaceUseType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSpecialEducationAgeGroupTaught]...';



ALTER TABLE [dbo].[RefSpecialEducationAgeGroupTaught]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSpecialEducationAgeGroupTaught]...';



ALTER TABLE [dbo].[RefSpecialEducationAgeGroupTaught]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSpecialEducationExitReason]...';



ALTER TABLE [dbo].[RefSpecialEducationExitReason]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSpecialEducationExitReason]...';



ALTER TABLE [dbo].[RefSpecialEducationExitReason]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSpecialEducationStaffCategory]...';



ALTER TABLE [dbo].[RefSpecialEducationStaffCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSpecialEducationStaffCategory]...';



ALTER TABLE [dbo].[RefSpecialEducationStaffCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefStaffPerformanceLevel]...';



ALTER TABLE [dbo].[RefStaffPerformanceLevel]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefStaffPerformanceLevel]...';



ALTER TABLE [dbo].[RefStaffPerformanceLevel]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefStandardizedAdmissionTest]...';



ALTER TABLE [dbo].[RefStandardizedAdmissionTest]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefStandardizedAdmissionTest]...';



ALTER TABLE [dbo].[RefStandardizedAdmissionTest]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefState]...';



ALTER TABLE [dbo].[RefState]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefState]...';



ALTER TABLE [dbo].[RefState]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefStatePovertyDesignation]...';



ALTER TABLE [dbo].[RefStatePovertyDesignation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefStatePovertyDesignation]...';



ALTER TABLE [dbo].[RefStatePovertyDesignation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefStudentEnrollmentAccessType]...';



ALTER TABLE [dbo].[RefStudentEnrollmentAccessType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefStudentEnrollmentAccessType]...';



ALTER TABLE [dbo].[RefStudentEnrollmentAccessType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefStudentSupportServiceType]...';



ALTER TABLE [dbo].[RefStudentSupportServiceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefStudentSupportServiceType]...';



ALTER TABLE [dbo].[RefStudentSupportServiceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefSupervisedClinicalExperience]...';



ALTER TABLE [dbo].[RefSupervisedClinicalExperience]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefSupervisedClinicalExperience]...';



ALTER TABLE [dbo].[RefSupervisedClinicalExperience]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTargetedSupport]...';



ALTER TABLE [dbo].[RefTargetedSupport]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefTargetedSupport]...';



ALTER TABLE [dbo].[RefTargetedSupport]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeacherEducationCredentialExam]...';



ALTER TABLE [dbo].[RefTeacherEducationCredentialExam]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeacherEducationCredentialExam]...';



ALTER TABLE [dbo].[RefTeacherEducationCredentialExam]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeacherEducationExamScoreType]...';



ALTER TABLE [dbo].[RefTeacherEducationExamScoreType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeacherEducationExamScoreType]...';



ALTER TABLE [dbo].[RefTeacherEducationExamScoreType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeacherEducationTestCompany]...';



ALTER TABLE [dbo].[RefTeacherEducationTestCompany]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeacherEducationTestCompany]...';



ALTER TABLE [dbo].[RefTeacherEducationTestCompany]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeacherPrepCompleterStatus]...';



ALTER TABLE [dbo].[RefTeacherPrepCompleterStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeacherPrepCompleterStatus]...';



ALTER TABLE [dbo].[RefTeacherPrepCompleterStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeacherPrepEnrollmentStatus]...';



ALTER TABLE [dbo].[RefTeacherPrepEnrollmentStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeacherPrepEnrollmentStatus]...';



ALTER TABLE [dbo].[RefTeacherPrepEnrollmentStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeachingAssignmentRole]...';



ALTER TABLE [dbo].[RefTeachingAssignmentRole]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeachingAssignmentRole]...';



ALTER TABLE [dbo].[RefTeachingAssignmentRole]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeachingCredentialBasis]...';



ALTER TABLE [dbo].[RefTeachingCredentialBasis]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeachingCredentialBasis]...';



ALTER TABLE [dbo].[RefTeachingCredentialBasis]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTeachingCredentialType]...';



ALTER TABLE [dbo].[RefTeachingCredentialType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTeachingCredentialType]...';



ALTER TABLE [dbo].[RefTeachingCredentialType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTechnicalAssistanceDeliveryType]...';



ALTER TABLE [dbo].[RefTechnicalAssistanceDeliveryType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTechnicalAssistanceDeliveryType]...';



ALTER TABLE [dbo].[RefTechnicalAssistanceDeliveryType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTechnicalAssistanceType]...';



ALTER TABLE [dbo].[RefTechnicalAssistanceType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTechnicalAssistanceType]...';



ALTER TABLE [dbo].[RefTechnicalAssistanceType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTechnologyLiteracyStatus]...';



ALTER TABLE [dbo].[RefTechnologyLiteracyStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTechnologyLiteracyStatus]...';



ALTER TABLE [dbo].[RefTechnologyLiteracyStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTelephoneNumberType]...';



ALTER TABLE [dbo].[RefTelephoneNumberType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTelephoneNumberType]...';



ALTER TABLE [dbo].[RefTelephoneNumberType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTenureSystem]...';



ALTER TABLE [dbo].[RefTenureSystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTenureSystem]...';



ALTER TABLE [dbo].[RefTenureSystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTextComplexitySystem]...';



ALTER TABLE [dbo].[RefTextComplexitySystem]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTextComplexitySystem]...';



ALTER TABLE [dbo].[RefTextComplexitySystem]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTimeForCompletionUnits]...';



ALTER TABLE [dbo].[RefTimeForCompletionUnits]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTimeForCompletionUnits]...';



ALTER TABLE [dbo].[RefTimeForCompletionUnits]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIIIAccountability]...';



ALTER TABLE [dbo].[RefTitleIIIAccountability]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIIIAccountability]...';



ALTER TABLE [dbo].[RefTitleIIIAccountability]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIIILanguageInstructionProgramType]...';



ALTER TABLE [dbo].[RefTitleIIILanguageInstructionProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIIILanguageInstructionProgramType]...';



ALTER TABLE [dbo].[RefTitleIIILanguageInstructionProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIIIProfessionalDevelopmentType]...';



ALTER TABLE [dbo].[RefTitleIIIProfessionalDevelopmentType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIIIProfessionalDevelopmentType]...';



ALTER TABLE [dbo].[RefTitleIIIProfessionalDevelopmentType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIIndicator]...';



ALTER TABLE [dbo].[RefTitleIIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIIndicator]...';



ALTER TABLE [dbo].[RefTitleIIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIInstructionalServices]...';



ALTER TABLE [dbo].[RefTitleIInstructionalServices]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIInstructionalServices]...';



ALTER TABLE [dbo].[RefTitleIInstructionalServices]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIProgramStaffCategory]...';



ALTER TABLE [dbo].[RefTitleIProgramStaffCategory]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIProgramStaffCategory]...';



ALTER TABLE [dbo].[RefTitleIProgramStaffCategory]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTitleIProgramType]...';



ALTER TABLE [dbo].[RefTitleIProgramType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTitleIProgramType]...';



ALTER TABLE [dbo].[RefTitleIProgramType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[RefTitleISchoolStatus]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_RefTitleISchoolStatus] (
	[RefTitleISchoolStatusId]                       INT            IDENTITY (1, 1) NOT NULL,
	[Description]                       NVARCHAR(150)             NOT NULL,
	[Code]                       NVARCHAR (50)             NULL,
	[Definition]                       NVARCHAR (400)             NULL,
	[RefJurisdictionId]                       INT             NULL,
	[SortOrder]                       DECIMAL(5, 2)             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_XPKRefTitle1Status1] PRIMARY KEY CLUSTERED ([RefTitleISchoolStatusId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[RefTitleISchoolStatus])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefTitleISchoolStatus] ON;
		INSERT INTO [dbo].[tmp_ms_xx_RefTitleISchoolStatus] ([RefTitleISchoolStatusId], [Description], [Code], [Definition], [RefJurisdictionId], [SortOrder])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefTitleISchoolStatus' AND COLUMN_NAME = 'RefTitle1SchoolStatusId')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [RefTitle1SchoolStatusId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefTitleISchoolStatus]
		ORDER BY [RefTitle1SchoolStatusId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [RefTitleISchoolStatusId],
				 [Description],
				 [Code],
				 [Definition],
				 [RefJurisdictionId],
				 [SortOrder]
		FROM     [dbo].[RefTitleISchoolStatus]
		ORDER BY [RefTitleISchoolStatusId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_RefTitleISchoolStatus] OFF
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[RefTitleISchoolStatus];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_RefTitleISchoolStatus]', N'RefTitleISchoolStatus';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_XPKRefTitle1Status1]', N'XPKRefTitle1Status', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT N'Altering [dbo].[RefTransferOutIndicator]...';



ALTER TABLE [dbo].[RefTransferOutIndicator]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTransferOutIndicator]...';



ALTER TABLE [dbo].[RefTransferOutIndicator]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTransferReady]...';



ALTER TABLE [dbo].[RefTransferReady]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTransferReady]...';



ALTER TABLE [dbo].[RefTransferReady]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTribalAffiliation]...';



ALTER TABLE [dbo].[RefTribalAffiliation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTribalAffiliation]...';



ALTER TABLE [dbo].[RefTribalAffiliation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTrimesterWhenPrenatalCareBegan]...';



ALTER TABLE [dbo].[RefTrimesterWhenPrenatalCareBegan]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTrimesterWhenPrenatalCareBegan]...';



ALTER TABLE [dbo].[RefTrimesterWhenPrenatalCareBegan]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTuitionResidencyType]...';



ALTER TABLE [dbo].[RefTuitionResidencyType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTuitionResidencyType]...';



ALTER TABLE [dbo].[RefTuitionResidencyType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefTuitionUnit]...';



ALTER TABLE [dbo].[RefTuitionUnit]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefTuitionUnit]...';



ALTER TABLE [dbo].[RefTuitionUnit]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefUnexperiencedStatus]...';



ALTER TABLE [dbo].[RefUnexperiencedStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NULL;



PRINT N'Altering [dbo].[RefUnexperiencedStatus]...';



ALTER TABLE [dbo].[RefUnexperiencedStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefUSCitizenshipStatus]...';



ALTER TABLE [dbo].[RefUSCitizenshipStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefUSCitizenshipStatus]...';



ALTER TABLE [dbo].[RefUSCitizenshipStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefVirtualSchoolStatus]...';



ALTER TABLE [dbo].[RefVirtualSchoolStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefVirtualSchoolStatus]...';



ALTER TABLE [dbo].[RefVirtualSchoolStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefVisaType]...';



ALTER TABLE [dbo].[RefVisaType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefVisaType]...';



ALTER TABLE [dbo].[RefVisaType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefVisionScreeningStatus]...';



ALTER TABLE [dbo].[RefVisionScreeningStatus]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefVisionScreeningStatus]...';



ALTER TABLE [dbo].[RefVisionScreeningStatus]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefWageCollectionMethod]...';



ALTER TABLE [dbo].[RefWageCollectionMethod]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefWageCollectionMethod]...';



ALTER TABLE [dbo].[RefWageCollectionMethod]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefWageVerification]...';



ALTER TABLE [dbo].[RefWageVerification]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefWageVerification]...';



ALTER TABLE [dbo].[RefWageVerification]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefWeaponType]...';



ALTER TABLE [dbo].[RefWeaponType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefWeaponType]...';



ALTER TABLE [dbo].[RefWeaponType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefWfProgramParticipation]...';



ALTER TABLE [dbo].[RefWfProgramParticipation]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefWfProgramParticipation]...';



ALTER TABLE [dbo].[RefWfProgramParticipation]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Altering [dbo].[RefWorkbasedLearningopportunityType]...';



ALTER TABLE [dbo].[RefWorkbasedLearningopportunityType]
    ALTER COLUMN 
	[Description]                       NVARCHAR(150)             NOT NULL;



PRINT N'Altering [dbo].[RefWorkbasedLearningopportunityType]...';



ALTER TABLE [dbo].[RefWorkbasedLearningopportunityType]
    ADD 
		[RecordStartDateTime] DATETIME  NULL,
		[RecordEndDateTime] DATETIME  NULL;



PRINT N'Starting rebuilding table [dbo].[StaffEmployment]...';



BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_StaffEmployment] (
	[StaffEmploymentId]                       INT            IDENTITY (1, 1) NOT NULL,
	[OrganizationPersonRoleId]                       INT             NOT NULL,
	[HireDate]                       DATE             NULL,
	[PositionTitle]                       NVARCHAR (45)             NULL,
	[UnionMembershipName]                       NVARCHAR (200)             NULL,
	[WeeksEmployedPerYear]                       INT             NULL,
	[StandardOccupationalClassification]                       NCHAR(7)             NULL,
	[RefEmploymentSeparationTypeId]                       INT             NULL,
	[RefEmploymentSeparationReasonId]                       INT             NULL,
	[RecordStartDateTime]                       DATETIME             NULL,
	[RecordEndDateTime]                       DATETIME             NULL,
	CONSTRAINT [tmp_ms_xx_constraint_PK_StaffEmployment1] PRIMARY KEY CLUSTERED ([StaffEmploymentId] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
);

IF EXISTS (SELECT TOP 1 1 
		   FROM   [dbo].[StaffEmployment])
	BEGIN
			SET @sql = '
		SET IDENTITY_INSERT [dbo].[tmp_ms_xx_StaffEmployment] ON;
		INSERT INTO [dbo].[tmp_ms_xx_StaffEmployment] ([StaffEmploymentId], [OrganizationPersonRoleId], [HireDate], [PositionTitle], [UnionMembershipName], [WeeksEmployedPerYear], [StandardOccupationalClassification], [RefEmploymentSeparationTypeId], [RefEmploymentSeparationReasonId], [RecordStartDateTime], [RecordEndDateTime])
		'
		
		IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'PsStaffEmployment' AND COLUMN_NAME = 'StandardOccupationalClass')
		BEGIN
			
			SET @sql = @sql + '
			SELECT   
				 [StaffEmployment].[StaffEmploymentId],
				 [StaffEmployment].[OrganizationPersonRoleId],
				 [StaffEmployment].[HireDate],
				 [StaffEmployment].[PositionTitle],
				 [StaffEmployment].[UnionMembershipName],
				 [StaffEmployment].[WeeksEmployedPerYear],
				 [PsStaffEmployment].[StandardOccupationalClass],
				 [StaffEmployment].[RefEmploymentSeparationTypeId],
				 [StaffEmployment].[RefEmploymentSeparationReasonId],
				 [StaffEmployment].[RecordStartDateTime],
				 [StaffEmployment].[RecordEndDateTime]
		FROM     [dbo].[StaffEmployment]
			LEFT OUTER JOIN [dbo].[PsStaffEmployment] ON [PsStaffEmployment].[StaffEmploymentId] = [StaffEmployment].[StaffEmploymentId]
		ORDER BY [StaffEmploymentId] ASC;
				'

		END
		ELSE
		BEGIN

			SET @sql = @sql + '
			SELECT   
				 [StaffEmployment].[StaffEmploymentId],
				 [StaffEmployment].[OrganizationPersonRoleId],
				 [StaffEmployment].[HireDate],
				 [StaffEmployment].[PositionTitle],
				 [StaffEmployment].[UnionMembershipName],
				 [StaffEmployment].[WeeksEmployedPerYear],
				 [StaffEmployment].[StandardOccupationalClassification],
				 [StaffEmployment].[RefEmploymentSeparationTypeId],
				 [StaffEmployment].[RefEmploymentSeparationReasonId],
				 [StaffEmployment].[RecordStartDateTime],
				 [StaffEmployment].[RecordEndDateTime]
		FROM     [dbo].[StaffEmployment]
		ORDER BY [StaffEmploymentId] ASC;
			'

		END

		SET @sql = @sql + '
			SET IDENTITY_INSERT [dbo].[tmp_ms_xx_StaffEmployment] OFF;
		'		

		EXEC sp_executesql @sql
	END

DROP TABLE [dbo].[StaffEmployment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_StaffEmployment]', N'StaffEmployment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_StaffEmployment1]', N'PK_StaffEmployment', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




PRINT '--NOTE: Adjustments may be needed to JOIN condition for data moved to StaffEmployment.'

PRINT N'Altering [dbo].[PsStaffEmployment]...';



ALTER TABLE [dbo].[PsStaffEmployment]
    DROP COLUMN 
		[StandardOccupationalClass];



PRINT N'Creating [dbo].[FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition]...';



ALTER TABLE [dbo].[AssessmentSubtest_CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [dbo].[CompetencyDefinition] ([CompetencyDefinitionId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefAssociation_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefAssociation] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefAssociation_CompetencyDefinition] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [dbo].[CompetencyDefinition] ([CompetencyDefinitionId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefEducationLevel_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefEducationLevel] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefEducationLevel_CompetencyDefinition] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [dbo].[CompetencyDefinition] ([CompetencyDefinitionId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_CompetencyDefinition] FOREIGN KEY ([ChildOf_CompetencyDefinitionId]) REFERENCES [dbo].[CompetencyDefinition] ([CompetencyDefinitionId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_CompetencyFramework]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_CompetencyFramework] FOREIGN KEY ([CompetencyFrameworkId]) REFERENCES [dbo].[CompetencyFramework] ([CompetencyFrameworkId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_RefBloomsTaxonomyDomain]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_RefBloomsTaxonomyDomain] FOREIGN KEY ([RefBloomsTaxonomyDomainId]) REFERENCES [dbo].[RefBloomsTaxonomyDomain] ([RefBloomsTaxonomyDomainId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_RefCompetencyDefinitionNodeAccessibilityProfile]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionNodeAccessibilityProfile] FOREIGN KEY ([RefCompetencyDefNodeAccessibilityProfileId]) REFERENCES [dbo].[RefCompetencyDefNodeAccessibilityProfile] ([RefCompetencyDefNodeAccessibilityProfileId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_RefCompetencyDefinitionTestabilityType]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionTestabilityType] FOREIGN KEY ([RefCompetencyDefTestabilityTypeId]) REFERENCES [dbo].[RefCompetencyDefTestabilityType] ([RefCompetencyDefTestabilityTypeId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_RefLanguage]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_RefLanguage] FOREIGN KEY ([RefLanguageId]) REFERENCES [dbo].[RefLanguage] ([RefLanguageId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_RefMultipleIntelligenceType]...';



ALTER TABLE [dbo].[CompetencyDefinition] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_RefMultipleIntelligenceType] FOREIGN KEY ([RefMultipleIntelligenceTypeId]) REFERENCES [dbo].[RefMultipleIntelligenceType] ([RefMultipleIntelligenceTypeId]) ;




PRINT N'Creating [dbo].[FK_CompetencyDefinition_CompetencySet_CompetencyDefinition]...';



ALTER TABLE [dbo].[CompetencyDefinition_CompetencySet] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencyDefinition_CompetencySet_CompetencyDefinition] FOREIGN KEY ([CompetencyDefinitionId]) REFERENCES [dbo].[CompetencyDefinition] ([CompetencyDefinitionId]) ;




PRINT N'Creating [dbo].[FK_CompetencySet_Rubric_CompetencySet]...';



ALTER TABLE [dbo].[CompetencySet_Rubric] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencySet_Rubric_CompetencySet] FOREIGN KEY ([CompetencySetId]) REFERENCES [dbo].[CompetencySet] ([CompetencySetId]) ;




PRINT N'Creating [dbo].[FK_CompetencySet_Rubric_Rubric]...';



ALTER TABLE [dbo].[CompetencySet_Rubric] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencySet_Rubric_Rubric] FOREIGN KEY ([RubricId]) REFERENCES [dbo].[Rubric] ([RubricId]) ;




PRINT N'Creating [dbo].[FK_CompetencySet_RubricCriterion_CompetencySet]...';



ALTER TABLE [dbo].[CompetencySet_RubricCriterion] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencySet_RubricCriterion_CompetencySet] FOREIGN KEY ([CompetencySetId]) REFERENCES [dbo].[CompetencySet] ([CompetencySetId]) ;




PRINT N'Creating [dbo].[FK_CompetencySet_RubricCriterion_RubricCriterion]...';



ALTER TABLE [dbo].[CompetencySet_RubricCriterion] WITH NOCHECK
	ADD CONSTRAINT [FK_CompetencySet_RubricCriterion_RubricCriterion] FOREIGN KEY ([RubricCriterionId]) REFERENCES [dbo].[RubricCriterion] ([RubricCriterionId]) ;




PRINT N'Creating [dbo].[FK_Course_Organization]...';



ALTER TABLE [dbo].[Course] WITH NOCHECK
	ADD CONSTRAINT [FK_Course_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_Course_RefCourseApplicableEducationLevel]...';



ALTER TABLE [dbo].[Course] WITH NOCHECK
	ADD CONSTRAINT [FK_Course_RefCourseApplicableEducationLevel] FOREIGN KEY ([RefCourseApplicableEducationLevelId]) REFERENCES [dbo].[RefCourseApplicableEducationLevel] ([RefCourseApplicableEducationLevelId]) ;




PRINT N'Creating [dbo].[FK_Course_RefCourseCreditUnit]...';



ALTER TABLE [dbo].[Course] WITH NOCHECK
	ADD CONSTRAINT [FK_Course_RefCourseCreditUnit] FOREIGN KEY ([RefCourseCreditUnitId]) REFERENCES [dbo].[RefCourseCreditUnit] ([RefCourseCreditUnitId]) ;




PRINT N'Creating [dbo].[FK_Course_RefCourseLevelCharacteristic]...';



ALTER TABLE [dbo].[Course] WITH NOCHECK
	ADD CONSTRAINT [FK_Course_RefCourseLevelCharacteristic] FOREIGN KEY ([RefCourseLevelCharacteristicsId]) REFERENCES [dbo].[RefCourseLevelCharacteristic] ([RefCourseLevelCharacteristicId]) ;




PRINT N'Creating [dbo].[FK_Course_RefLanguage]...';



ALTER TABLE [dbo].[Course] WITH NOCHECK
	ADD CONSTRAINT [FK_Course_RefLanguage] FOREIGN KEY ([RefInstructionLanguageId]) REFERENCES [dbo].[RefLanguage] ([RefLanguageId]) ;




PRINT N'Creating [dbo].[FK_CourseSection_Course]...';



ALTER TABLE [dbo].[CourseSection] WITH NOCHECK
	ADD CONSTRAINT [FK_CourseSection_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_CredentialCriteriaCourse_Course]...';



ALTER TABLE [dbo].[CredentialCriteriaCourse] WITH NOCHECK
	ADD CONSTRAINT [FK_CredentialCriteriaCourse_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_CteCourse_Course]...';



ALTER TABLE [dbo].[CteCourse] WITH NOCHECK
	ADD CONSTRAINT [FK_CteCourse_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_ELStaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[ELStaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_ELStaffEmployment_StaffEmployment] FOREIGN KEY ([StaffEmploymentId]) REFERENCES [dbo].[StaffEmployment] ([StaffEmploymentId]) ;




PRINT N'Creating [dbo].[FK_K12CharterSchoolAuthorizerAgency_RefCharterSchoolAuthorizerType]...';



ALTER TABLE [dbo].[K12CharterSchoolAuthorizerAgency] WITH NOCHECK
	ADD CONSTRAINT [FK_K12CharterSchoolAuthorizerAgency_RefCharterSchoolAuthorizerType] FOREIGN KEY ([RefCharterSchoolAuthorizerTypeId]) REFERENCES [dbo].[RefCharterSchoolAuthorizerType] ([RefCharterSchoolAuthorizerTypeId]) ;




PRINT N'Creating [dbo].[FK_K12CharterSchoolAuthorizerAgency_Organization]...';



ALTER TABLE [dbo].[K12CharterSchoolAuthorizerAgency] WITH NOCHECK
	ADD CONSTRAINT [FK_K12CharterSchoolAuthorizerAgency_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_K12Course_Course]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefAdditionalCreditType]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefAdditionalCreditType] FOREIGN KEY ([RefAdditionalCreditTypeId]) REFERENCES [dbo].[RefAdditionalCreditType] ([RefAdditionalCreditTypeId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefBlendedLearningModel]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefBlendedLearningModel] FOREIGN KEY ([RefBlendedLearningModelTypeId]) REFERENCES [dbo].[RefBlendedLearningModelType] ([RefBlendedLearningModelTypeId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefCareerCluster]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefCareerCluster] FOREIGN KEY ([RefCareerClusterId]) REFERENCES [dbo].[RefCareerCluster] ([RefCareerClusterId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefCourseGpaApplicability]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefCourseGpaApplicability] FOREIGN KEY ([RefCourseGPAApplicabilityId]) REFERENCES [dbo].[RefCourseGpaApplicability] ([RefCourseGPAApplicabilityId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefCourseInteractionMode]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefCourseInteractionMode] FOREIGN KEY ([RefCourseInteractionModeId]) REFERENCES [dbo].[RefCourseInteractionMode] ([RefCourseInteractionModeId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefCreditTypeEarned]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefCreditTypeEarned] FOREIGN KEY ([RefCreditTypeEarnedId]) REFERENCES [dbo].[RefCreditTypeEarned] ([RefCreditTypeEarnedId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefCurriculumFrameworkType]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefCurriculumFrameworkType] FOREIGN KEY ([RefCurriculumFrameworkTypeId]) REFERENCES [dbo].[RefCurriculumFrameworkType] ([RefCurriculumFrameworkTypeId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefK12EndOfCourseRequirement]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefK12EndOfCourseRequirement] FOREIGN KEY ([RefK12EndOfCourseRequirementId]) REFERENCES [dbo].[RefK12EndOfCourseRequirement] ([RefK12EndOfCourseRequirementId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefSCEDCourseLevel]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefSCEDCourseLevel] FOREIGN KEY ([RefSCEDCourseLevelId]) REFERENCES [dbo].[RefSCEDCourseLevel] ([RefSCEDCourseLevelId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefSCEDCourseSubjectArea]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefSCEDCourseSubjectArea] FOREIGN KEY ([RefSCEDCourseSubjectAreaId]) REFERENCES [dbo].[RefSCEDCourseSubjectArea] ([RefSCEDCourseSubjectAreaId]) ;




PRINT N'Creating [dbo].[FK_K12Course_RefWorkbasedLearningopportunityType]...';



ALTER TABLE [dbo].[K12Course] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Course_RefWorkbasedLearningopportunityType] FOREIGN KEY ([RefWorkbasedLearningopportunityTypeId]) REFERENCES [dbo].[RefWorkbasedLearningopportunityType] ([RefWorkbasedLearningopportunityTypeId]) ;




PRINT N'Creating [dbo].[FK_K12LeaGradeLevelsApproved_K12Lea]...';



ALTER TABLE [dbo].[K12LeaGradeLevelsApproved] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaGradeLevelsApproved_K12Lea] FOREIGN KEY ([K12LeaId]) REFERENCES [dbo].[K12Lea] ([K12LeaId]) ;




PRINT N'Creating [dbo].[FK_K12LeaGradeLevelsApproved_RefGradeLevel]...';



ALTER TABLE [dbo].[K12LeaGradeLevelsApproved] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaGradeLevelsApproved_RefGradeLevel] FOREIGN KEY ([RefGradeLevelId]) REFERENCES [dbo].[RefGradeLevel] ([RefGradeLevelId]) ;




PRINT N'Creating [dbo].[FK_K12LeaGradeOffered_K12Lea]...';



ALTER TABLE [dbo].[K12LeaGradeOffered] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaGradeOffered_K12Lea] FOREIGN KEY ([K12LeaId]) REFERENCES [dbo].[K12Lea] ([K12LeaId]) ;




PRINT N'Creating [dbo].[FK_K12LeaGradeOffered_RefGradeLevel]...';



ALTER TABLE [dbo].[K12LeaGradeOffered] WITH NOCHECK
	ADD CONSTRAINT [FK_K12LeaGradeOffered_RefGradeLevel] FOREIGN KEY ([RefGradeLevelId]) REFERENCES [dbo].[RefGradeLevel] ([RefGradeLevelId]) ;




PRINT N'Creating [dbo].[FK_K12School_K12CharterSchoolAuthorizerAgency]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_K12CharterSchoolAuthorizerAgency] FOREIGN KEY ([K12CharterSchoolAuthorizerAgencyId]) REFERENCES [dbo].[K12CharterSchoolAuthorizerAgency] ([K12CharterSchoolAuthorizerAgencyId]) ;




PRINT N'Creating [dbo].[FK_K12School_K12CharterSchoolManagementOrganization]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_K12CharterSchoolManagementOrganization] FOREIGN KEY ([K12CharterSchoolManagementOrganizationId]) REFERENCES [dbo].[K12CharterSchoolManagementOrganization] ([K12CharterSchoolManagementOrganizationId]) ;




PRINT N'Creating [dbo].[FK_K12School_Organization]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefAdminFundingControl]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefAdminFundingControl] FOREIGN KEY ([RefAdministrativeFundingControlId]) REFERENCES [dbo].[RefAdministrativeFundingControl] ([RefAdministrativeFundingControlId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefCharterSchoolType]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefCharterSchoolType] FOREIGN KEY ([RefCharterSchoolTypeId]) REFERENCES [dbo].[RefCharterSchoolType] ([RefCharterSchoolTypeId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefIncreasedLearningTimeType]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefIncreasedLearningTimeType] FOREIGN KEY ([RefIncreasedLearningTimeTypeId]) REFERENCES [dbo].[RefIncreasedLearningTimeType] ([RefIncreasedLearningTimeTypeId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefSchoolLevel]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefSchoolLevel] FOREIGN KEY ([RefSchoolLevelId]) REFERENCES [dbo].[RefSchoolLevel] ([RefSchoolLevelId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefSchoolType]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefSchoolType] FOREIGN KEY ([RefSchoolTypeId]) REFERENCES [dbo].[RefSchoolType] ([RefSchoolTypeId]) ;




PRINT N'Creating [dbo].[FK_K12School_RefStatePovertyDesignation]...';



ALTER TABLE [dbo].[K12School] WITH NOCHECK
	ADD CONSTRAINT [FK_K12School_RefStatePovertyDesignation] FOREIGN KEY ([RefStatePovertyDesignationId]) REFERENCES [dbo].[RefStatePovertyDesignation] ([RefStatePovertyDesignationId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolCorrectiveAction_K12School]...';



ALTER TABLE [dbo].[K12SchoolCorrectiveAction] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolCorrectiveAction_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolGradeLevelsApproved_K12School]...';



ALTER TABLE [dbo].[K12SchoolGradeLevelsApproved] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolGradeLevelsApproved_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolGradeLevelsApproved_RefGradeLevel]...';



ALTER TABLE [dbo].[K12SchoolGradeLevelsApproved] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolGradeLevelsApproved_RefGradeLevel] FOREIGN KEY ([RefGradeLevelId]) REFERENCES [dbo].[RefGradeLevel] ([RefGradeLevelId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolGradeOffered_K12School]...';



ALTER TABLE [dbo].[K12SchoolGradeOffered] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolGradeOffered_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolImprovement_K12School]...';



ALTER TABLE [dbo].[K12SchoolImprovement] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolImprovement_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolIndicatorStatus_K12School]...';



ALTER TABLE [dbo].[K12SchoolIndicatorStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolIndicatorStatus_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_K12School]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_K12School] FOREIGN KEY ([K12SchoolId]) REFERENCES [dbo].[K12School] ([K12SchoolId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefAlternativeSchoolFocus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefAlternativeSchoolFocus] FOREIGN KEY ([RefAlternativeSchoolFocusId]) REFERENCES [dbo].[RefAlternativeSchoolFocus] ([RefAlternativeSchoolFocusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefBlendedLearningModelType]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefBlendedLearningModelType] FOREIGN KEY ([RefBlendedLearningModelTypeId]) REFERENCES [dbo].[RefBlendedLearningModelType] ([RefBlendedLearningModelTypeId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport] FOREIGN KEY ([RefComprehensiveAndTargetedSupportId]) REFERENCES [dbo].[RefComprehensiveAndTargetedSupport] ([RefComprehensiveAndTargetedSupportId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefComprehensiveSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveSupport] FOREIGN KEY ([RefComprehensiveSupportId]) REFERENCES [dbo].[RefComprehensiveSupport] ([RefComprehensiveSupportId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefInternetAccess]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefInternetAccess] FOREIGN KEY ([RefInternetAccessId]) REFERENCES [dbo].[RefInternetAccess] ([RefInternetAccessId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefMagnetSpecialProgram]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefMagnetSpecialProgram] FOREIGN KEY ([RefMagnetSpecialProgramId]) REFERENCES [dbo].[RefMagnetSpecialProgram] ([RefMagnetSpecialProgramId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefNationalSchoolLunchProgramStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefNationalSchoolLunchProgramStatus] FOREIGN KEY ([RefNationalSchoolLunchProgramStatusId]) REFERENCES [dbo].[RefNationalSchoolLunchProgramStatus] ([RefNationalSchoolLunchProgramStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefNSLPStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefNSLPStatus] FOREIGN KEY ([RefNSLPStatusId]) REFERENCES [dbo].[RefNSLPStatus] ([RefNSLPStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] FOREIGN KEY ([RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]) REFERENCES [dbo].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] ([RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefRestructuringAction]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefRestructuringAction] FOREIGN KEY ([RefRestructuringActionId]) REFERENCES [dbo].[RefRestructuringAction] ([RefRestructuringActionId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefSchoolDangerousStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefSchoolDangerousStatus] FOREIGN KEY ([RefSchoolDangerousStatusId]) REFERENCES [dbo].[RefSchoolDangerousStatus] ([RefSchoolDangerousStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefSchoolImprovementStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefSchoolImprovementStatus] FOREIGN KEY ([RefSchoolImprovementStatusId]) REFERENCES [dbo].[RefSchoolImprovementStatus] ([RefSchoolImprovementStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefTargetedSupport]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefTargetedSupport] FOREIGN KEY ([RefTargetedSupportId]) REFERENCES [dbo].[RefTargetedSupport] ([RefTargetedSupportId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefTitle1SchoolStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefTitle1SchoolStatus] FOREIGN KEY ([RefTitleISchoolStatusId]) REFERENCES [dbo].[RefTitleISchoolStatus] ([RefTitleISchoolStatusId]) ;




PRINT N'Creating [dbo].[FK_K12SchoolStatus_RefVirtualSchoolStatus]...';



ALTER TABLE [dbo].[K12SchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SchoolStatus_RefVirtualSchoolStatus] FOREIGN KEY ([RefVirtualSchoolStatusId]) REFERENCES [dbo].[RefVirtualSchoolStatus] ([RefVirtualSchoolStatusId]) ;




PRINT N'Creating [dbo].[FK_K12Sea_Organization]...';



ALTER TABLE [dbo].[K12Sea] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Sea_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;



PRINT N'Creating [dbo].[FK_K12Sea_RefStateANSICode]...';



ALTER TABLE [dbo].[K12Sea] WITH NOCHECK
	ADD CONSTRAINT [FK_K12Sea_RefStateANSICode] FOREIGN KEY ([RefStateANSICodeId]) REFERENCES [dbo].[RefStateANSICode] ([RefStateANSICodeId]) ;
	





PRINT N'Creating [dbo].[FK_K12SeaFederalFunds_K12Sea]...';



ALTER TABLE [dbo].[K12SeaFederalFunds] WITH NOCHECK
	ADD CONSTRAINT [FK_K12SeaFederalFunds_K12Sea] FOREIGN KEY ([K12SeaId]) REFERENCES [dbo].[K12Sea] ([K12SeaId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_OrganizationPerson] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_OrganizationPersonRole] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefClassroomPositionType]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefClassroomPositionType] FOREIGN KEY ([RefClassroomPositionTypeId]) REFERENCES [dbo].[RefClassroomPositionType] ([RefClassroomPositionTypeId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus] FOREIGN KEY ([RefEmergencyOrProvisionalCredentialStatusId]) REFERENCES [dbo].[RefEmergencyOrProvisionalCredentialStatus] ([RefEmergencyOrProvisionalCredentialStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefEducationStaffClassification]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefEducationStaffClassification] FOREIGN KEY ([RefK12StaffClassificationId]) REFERENCES [dbo].[RefK12StaffClassification] ([RefK12StaffClassificationId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefMepStaffCategory]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefMepStaffCategory] FOREIGN KEY ([RefMepStaffCategoryId]) REFERENCES [dbo].[RefMepStaffCategory] ([RefMepStaffCategoryId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefOutOfFieldStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefOutOfFieldStatus] FOREIGN KEY ([RefOutOfFieldStatusId]) REFERENCES [dbo].[RefOutOfFieldStatus] ([RefOutOfFieldStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefProfessionalEducationJobClassification]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefProfessionalEducationJobClassification] FOREIGN KEY ([RefProfessionalEducationJobClassificationId]) REFERENCES [dbo].[RefProfessionalEducationJobClassification] ([RefProfessionalEducationJobClassificationId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught] FOREIGN KEY ([RefSpecialEducationAgeGroupTaughtId]) REFERENCES [dbo].[RefSpecialEducationAgeGroupTaught] ([RefSpecialEducationAgeGroupTaughtId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefSpecialEducationStaffCategory]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationStaffCategory] FOREIGN KEY ([RefSpecialEducationStaffCategoryId]) REFERENCES [dbo].[RefSpecialEducationStaffCategory] ([RefSpecialEducationStaffCategoryId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefTeachingAssignmentRole]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefTeachingAssignmentRole] FOREIGN KEY ([RefTeachingAssignmentRoleId]) REFERENCES [dbo].[RefTeachingAssignmentRole] ([RefTeachingAssignmentRoleId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefTitleIProgramStaffCategory]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefTitleIProgramStaffCategory] FOREIGN KEY ([RefTitleIProgramStaffCategoryId]) REFERENCES [dbo].[RefTitleIProgramStaffCategory] ([RefTitleIProgramStaffCategoryId]) ;




PRINT N'Creating [dbo].[FK_K12StaffAssignment_RefUnexperiencedStatus]...';



ALTER TABLE [dbo].[K12StaffAssignment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffAssignment_RefUnexperiencedStatus] FOREIGN KEY ([RefUnexperiencedStatusId]) REFERENCES [dbo].[RefUnexperiencedStatus] ([RefUnexperiencedStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StaffEmployment_RefEmploymentStatus]...';



ALTER TABLE [dbo].[K12StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffEmployment_RefEmploymentStatus] FOREIGN KEY ([RefEmploymentStatusId]) REFERENCES [dbo].[RefEmploymentStatus] ([RefEmploymentStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StaffEmployment_RefEduStaffClassification]...';



ALTER TABLE [dbo].[K12StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffEmployment_RefEduStaffClassification] FOREIGN KEY ([RefK12StaffClassificationId]) REFERENCES [dbo].[RefK12StaffClassification] ([RefK12StaffClassificationId]) ;




PRINT N'Creating [dbo].[FK_K12StaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[K12StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StaffEmployment_StaffEmployment] FOREIGN KEY ([StaffEmploymentId]) REFERENCES [dbo].[StaffEmployment] ([StaffEmploymentId]) ;




PRINT N'Creating [dbo].[FK_K12EnrollmentMember_OrganizationPerson]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12EnrollmentMember_OrganizationPerson] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) 
	ON UPDATE CASCADE
	ON DELETE CASCADE;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_OrganizationPersonRole] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus] FOREIGN KEY ([RefDirectoryInformationBlockStatusId]) REFERENCES [dbo].[RefDirectoryInformationBlockStatus] ([RefDirectoryInformationBlockStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefEndOfTermStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefEndOfTermStatus] FOREIGN KEY ([RefEndOfTermStatusId]) REFERENCES [dbo].[RefEndOfTermStatus] ([RefEndOfTermStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefEnrollmentStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefEnrollmentStatus] FOREIGN KEY ([RefEnrollmentStatusId]) REFERENCES [dbo].[RefEnrollmentStatus] ([RefEnrollmentStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefEntryType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefEntryType] FOREIGN KEY ([RefEntryType]) REFERENCES [dbo].[RefEntryType] ([RefEntryTypeId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefExitOrWithdrawalStatus]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalStatus] FOREIGN KEY ([RefExitOrWithdrawalStatusId]) REFERENCES [dbo].[RefExitOrWithdrawalStatus] ([RefExitOrWithdrawalStatusId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefExitOrWithdrawalType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalType] FOREIGN KEY ([RefExitOrWithdrawalTypeId]) REFERENCES [dbo].[RefExitOrWithdrawalType] ([RefExitOrWithdrawalTypeId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefFoodServiceEligibility]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefFoodServiceEligibility] FOREIGN KEY ([RefFoodServiceEligibilityId]) REFERENCES [dbo].[RefFoodServiceEligibility] ([RefFoodServiceEligibilityId]) ;




PRINT N'Creating [dbo].[FK_K12EnrollmentMember_RefGrade]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12EnrollmentMember_RefGrade] FOREIGN KEY ([RefEntryGradeLevelId]) REFERENCES [dbo].[RefGradeLevel] ([RefGradeLevelId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefGradeLevel]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefGradeLevel] FOREIGN KEY ([RefExitGradeLevelId]) REFERENCES [dbo].[RefGradeLevel] ([RefGradeLevelId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefNonPromotionReason]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefNonPromotionReason] FOREIGN KEY ([RefNonPromotionReasonId]) REFERENCES [dbo].[RefNonPromotionReason] ([RefNonPromotionReasonId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefPromotionReason]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefPromotionReason] FOREIGN KEY ([RefPromotionReasonId]) REFERENCES [dbo].[RefPromotionReason] ([RefPromotionReasonId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefPublicSchoolResidence]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefPublicSchoolResidence] FOREIGN KEY ([RefPublicSchoolResidence]) REFERENCES [dbo].[RefPublicSchoolResidence] ([RefPublicSchoolResidenceId]) ;




PRINT N'Creating [dbo].[FK_K12StudentEnrollment_RefStudentEnrollmentAccessType]...';



ALTER TABLE [dbo].[K12StudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentEnrollment_RefStudentEnrollmentAccessType] FOREIGN KEY ([RefStudentEnrollmentAccessTypeId]) REFERENCES [dbo].[RefStudentEnrollmentAccessType] ([RefStudentEnrollmentAccessTypeId]) ;




PRINT N'Creating [dbo].[FK_K12StudentGraduationPlan_K12Course]...';



ALTER TABLE [dbo].[K12StudentGraduationPlan] WITH NOCHECK
	ADD CONSTRAINT [FK_K12StudentGraduationPlan_K12Course] FOREIGN KEY ([K12CourseId]) REFERENCES [dbo].[K12Course] ([K12CourseId]) ;




PRINT N'Creating [dbo].[FK_OrganizationDetail_Organization]...';



ALTER TABLE [dbo].[OrganizationDetail] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationDetail_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_OrganizationDetail_RefOrganizationType]...';



ALTER TABLE [dbo].[OrganizationDetail] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationDetail_RefOrganizationType] FOREIGN KEY ([RefOrganizationTypeId]) REFERENCES [dbo].[RefOrganizationType] ([RefOrganizationTypeId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_Organization]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_Organization] FOREIGN KEY ([OrganizationId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefAdditionalTargetedSupportAndImprovementStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefAdditionalTargetedSupportAndImprovementStatus] FOREIGN KEY ([RefAdditionalTargetedSupportAndImprovementStatusId]) REFERENCES [dbo].[RefAdditionalTargetedSupportAndImprovementStatus] ([RefAdditionalTargetedSupportAndImprovementStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents] FOREIGN KEY ([AmaoAypProgressAttainmentLepStudents]) REFERENCES [dbo].[RefAmaoAttainmentStatus] ([RefAmaoAttainmentStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1] FOREIGN KEY ([AmaoProficiencyAttainmentLepStudents]) REFERENCES [dbo].[RefAmaoAttainmentStatus] ([RefAmaoAttainmentStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2] FOREIGN KEY ([AmaoProgressAttainmentLepStudents]) REFERENCES [dbo].[RefAmaoAttainmentStatus] ([RefAmaoAttainmentStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederaAccountability_RefAypStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederaAccountability_RefAypStatus] FOREIGN KEY ([RefAypStatusId]) REFERENCES [dbo].[RefAypStatus] ([RefAypStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefComprehensiveSupportAndImprovementStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefComprehensiveSupportAndImprovementStatus] FOREIGN KEY ([RefComprehensiveSupportAndImprovementStatusId]) REFERENCES [dbo].[RefComprehensiveSupportAndImprovementStatus] ([RefComprehensiveSupportAndImprovementStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefCteGraduationRateInclusion]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefCteGraduationRateInclusion] FOREIGN KEY ([RefCteGraduationRateInclusionId]) REFERENCES [dbo].[RefCteGraduationRateInclusion] ([RefCteGraduationRateInclusionId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefElementaryMiddleAdditional]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefElementaryMiddleAdditional] FOREIGN KEY ([RefElementaryMiddleAdditionalId]) REFERENCES [dbo].[RefElementaryMiddleAdditional] ([RefElementaryMiddleAdditionalId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus] FOREIGN KEY ([RefGunFreeSchoolsActReportingStatusId]) REFERENCES [dbo].[RefGunFreeSchoolsActReportingStatus] ([RefGunFreeSchoolsActReportingStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFedAccountability_RefHSGraduationRateIndicator]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFedAccountability_RefHSGraduationRateIndicator] FOREIGN KEY ([RefHighSchoolGraduationRateIndicatorId]) REFERENCES [dbo].[RefHighSchoolGraduationRateIndicator] ([RefHighSchoolGraduationRateIndicatorId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefParticipationStatusAyp2]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp2] FOREIGN KEY ([RefParticipationStatusMathId]) REFERENCES [dbo].[RefParticipationStatusAyp] ([RefParticipationStatusAypId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefParticipationStatusAyp3]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp3] FOREIGN KEY ([RefParticipationStatusRlaId]) REFERENCES [dbo].[RefParticipationStatusAyp] ([RefParticipationStatusAypId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefProficiencyTargetAyp]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAyp] FOREIGN KEY ([RefProficiencyTargetStatusMathId]) REFERENCES [dbo].[RefProficiencyTargetAyp] ([RefProficiencyTargetAypId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefProficiencyTargetAyp1]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAyp1] FOREIGN KEY ([RefProficiencyTargetStatusRLAId]) REFERENCES [dbo].[RefProficiencyTargetAyp] ([RefProficiencyTargetAypId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefReconstitutedStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefReconstitutedStatus] FOREIGN KEY ([RefReconstitutedStatusId]) REFERENCES [dbo].[RefReconstitutedStatus] ([RefReconstitutedStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationFederalAccountability_RefTargetedSupportAndImprovementStatus]...';



ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationFederalAccountability_RefTargetedSupportAndImprovementStatus] FOREIGN KEY ([RefTargetedSupportAndImprovementStatusId]) REFERENCES [dbo].[RefTargetedSupportAndImprovementStatus] ([RefTargetedSupportAndImprovementStatusId]) ;




PRINT N'Creating [dbo].[FK_OrganizationPersonRoleFTE_OrganizationPersonRole]...';



ALTER TABLE [dbo].[OrganizationPersonRoleFTE] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationPersonRoleFTE_OrganizationPersonRole] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) ;




PRINT N'Creating [dbo].[FK_OrganizationTelephone_RefTelephoneNumberListedStatus]...';



ALTER TABLE [dbo].[OrganizationTelephone] WITH NOCHECK
	ADD CONSTRAINT [FK_OrganizationTelephone_RefTelephoneNumberListedStatus] FOREIGN KEY ([RefTelephoneNumberListedStatusId]) REFERENCES [dbo].[RefTelephoneNumberListedStatus] ([RefTelephoneNumberListedStatusId]) ;




PRINT N'Creating [dbo].[FK_PDActivityEducationLevel_PDActivity]...';



ALTER TABLE [dbo].[PDActivityEducationLevel] WITH NOCHECK
	ADD CONSTRAINT [FK_PDActivityEducationLevel_PDActivity] FOREIGN KEY ([ProfessionalDevelopmentActivityId]) REFERENCES [dbo].[ProfessionalDevelopmentActivity] ([ProfessionalDevelopmentActivityId]) ;




PRINT N'Creating [dbo].[FK_PersonProgramParticipation_RefProgramEntryReason]...';



ALTER TABLE [dbo].[PersonProgramParticipation] WITH NOCHECK
	ADD CONSTRAINT [FK_PersonProgramParticipation_RefProgramEntryReason] FOREIGN KEY ([RefProgramEntryReasonId]) REFERENCES [dbo].[RefProgramEntryReason] ([RefProgramEntryReasonId]) ;




PRINT N'Creating [dbo].[FK_PersonRelationship_Person_Primary]...';



ALTER TABLE [dbo].[PersonRelationship] WITH NOCHECK
	ADD CONSTRAINT [FK_PersonRelationship_Person_Primary] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId]) ;




PRINT N'Creating [dbo].[FK_PersonRelationship_Person_Secondary]...';



ALTER TABLE [dbo].[PersonRelationship] WITH NOCHECK
	ADD CONSTRAINT [FK_PersonRelationship_Person_Secondary] FOREIGN KEY ([RelatedPersonId]) REFERENCES [dbo].[Person] ([PersonId]) ;




PRINT N'Creating [dbo].[FK_PersonRelationship_RefRelationship]...';



ALTER TABLE [dbo].[PersonRelationship] WITH NOCHECK
	ADD CONSTRAINT [FK_PersonRelationship_RefRelationship] FOREIGN KEY ([RefPersonRelationshipTypeId]) REFERENCES [dbo].[RefPersonRelationshipType] ([RefPersonRelationshipTypeId]) ;




PRINT N'Creating [dbo].[FK_PersonTelephone_RefTelephoneNumberListedStatus]...';



ALTER TABLE [dbo].[PersonTelephone] WITH NOCHECK
	ADD CONSTRAINT [FK_PersonTelephone_RefTelephoneNumberListedStatus] FOREIGN KEY ([RefTelephoneNumberListedStatusId]) REFERENCES [dbo].[RefTelephoneNumberListedStatus] ([RefTelephoneNumberListedStatusId]) ;




PRINT N'Creating [dbo].[FK_PDSession_Course]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_PDSession_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_PDSession_PDRequirement]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_PDSession_PDRequirement] FOREIGN KEY ([ProfessionalDevelopmentRequirementId]) REFERENCES [dbo].[ProfessionalDevelopmentRequirement] ([ProfessionalDevelopmentRequirementId]) ;




PRINT N'Creating [dbo].[FK_PDSession_RefCourseCreditUnit]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_PDSession_RefCourseCreditUnit] FOREIGN KEY ([RefCourseCreditUnitId]) REFERENCES [dbo].[RefCourseCreditUnit] ([RefCourseCreditUnitId]) ;




PRINT N'Creating [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor] FOREIGN KEY ([RefPDActivityApprovedPurposeId]) REFERENCES [dbo].[RefPDActivityApprovedPurpose] ([RefPDActivityApprovedPurposeId]) ;




PRINT N'Creating [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType] FOREIGN KEY ([RefPDActivityCreditTypeId]) REFERENCES [dbo].[RefPDActivityCreditType] ([RefPDActivityCreditTypeId]) ;




PRINT N'Creating [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityLevel]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityLevel] FOREIGN KEY ([RefPDActivityLevelId]) REFERENCES [dbo].[RefPDActivityLevel] ([RefPDActivityLevelId]) ;




PRINT N'Creating [dbo].[FK_ProfessionalDevelopmentActivity_RefPDActivityType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityType] FOREIGN KEY ([RefPDActivityTypeId]) REFERENCES [dbo].[RefPDActivityType] ([RefPDActivityTypeId]) ;




PRINT N'Creating [dbo].[FK_ProfessionalDevelopmentActivity_RefPDAudienceType]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDAudienceType] FOREIGN KEY ([RefPDAudienceTypeId]) REFERENCES [dbo].[RefPDAudienceType] ([RefPDAudienceTypeId]) ;




PRINT N'Creating [dbo].[FK_PDSession_RefProfDevFinancialSupport]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_PDSession_RefProfDevFinancialSupport] FOREIGN KEY ([RefProfessionalDevelopmentFinancialSupportId]) REFERENCES [dbo].[RefProfessionalDevelopmentFinancialSupport] ([RefProfessionalDevelopmentFinancialSupportId]) ;




PRINT N'Creating [dbo].[FK_PDSession_PDActivity]...';



ALTER TABLE [dbo].[ProfessionalDevelopmentSession] WITH NOCHECK
	ADD CONSTRAINT [FK_PDSession_PDActivity] FOREIGN KEY ([ProfessionalDevelopmentActivityId]) REFERENCES [dbo].[ProfessionalDevelopmentActivity] ([ProfessionalDevelopmentActivityId]) ;




PRINT N'Creating [dbo].[FK_ProgramParticipationSpecialEducation_PersonProgramParticipat]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH NOCHECK
	ADD CONSTRAINT [FK_ProgramParticipationSpecialEducation_PersonProgramParticipat] FOREIGN KEY ([PersonProgramParticipationId]) REFERENCES [dbo].[PersonProgramParticipation] ([PersonProgramParticipationId]) ;




PRINT N'Creating [dbo].[FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH NOCHECK
	ADD CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC] FOREIGN KEY ([RefIDEAEducationalEnvironmentECId]) REFERENCES [dbo].[RefIDEAEducationalEnvironmentEC] ([RefIDEAEducationalEnvironmentECId]) ;




PRINT N'Creating [dbo].[FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH NOCHECK
	ADD CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge] FOREIGN KEY ([RefIDEAEducationalEnvironmentSchoolAgeId]) REFERENCES [dbo].[RefIDEAEducationalEnvironmentSchoolAge] ([RefIDEAEducationalEnvironmentSchoolAgeId]) ;




PRINT N'Creating [dbo].[FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason]...';



ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH NOCHECK
	ADD CONSTRAINT [FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason] FOREIGN KEY ([RefSpecialEducationExitReasonId]) REFERENCES [dbo].[RefSpecialEducationExitReason] ([RefSpecialEducationExitReasonId]) ;




PRINT N'Creating [dbo].[FK_PsCourse_Course]...';



ALTER TABLE [dbo].[PsCourse] WITH NOCHECK
	ADD CONSTRAINT [FK_PsCourse_Course] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Course] ([CourseId]) ;




PRINT N'Creating [dbo].[FK_PsStaffEmployment_StaffEmployment]...';



ALTER TABLE [dbo].[PsStaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStaffEmployment_StaffEmployment] FOREIGN KEY ([StaffEmploymentId]) REFERENCES [dbo].[StaffEmployment] ([StaffEmploymentId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_OrganizationPersonRole] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus] FOREIGN KEY ([RefDevelopmentalEducationReferralStatusId]) REFERENCES [dbo].[RefDevelopmentalEducationReferralStatus] ([RefDevelopmentalEducationReferralStatusId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefDevelopmentalEducationType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationType] FOREIGN KEY ([RefDevelopmentalEducationTypeId]) REFERENCES [dbo].[RefDevelopmentalEducationType] ([RefDevelopmentalEducationTypeId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefDistanceEducationCourseEnr]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefDistanceEducationCourseEnr] FOREIGN KEY ([RefDistanceEducationCourseEnrollmentId]) REFERENCES [dbo].[RefDistanceEducationCourseEnrollment] ([RefDistanceEducationCourseEnrollmentId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode] FOREIGN KEY ([RefDoctoralExamsRequiredCodeId]) REFERENCES [dbo].[RefDoctoralExamsRequiredCode] ([RefDoctoralExamsRequiredCodeId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus] FOREIGN KEY ([RefGraduateOrDoctoralExamResultsStatusId]) REFERENCES [dbo].[RefGraduateOrDoctoralExamResultsStatus] ([RefGraduateOrDoctoralExamResultsStatusId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefInstructionalActivityHours]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefInstructionalActivityHours] FOREIGN KEY ([RefInstructionalActivityHoursId]) REFERENCES [dbo].[RefInstructionalActivityHours] ([RefInstructionalActivityHoursId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentAwardType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentAwardType] FOREIGN KEY ([RefPsEnrollmentAwardTypeId]) REFERENCES [dbo].[RefPsEnrollmentAwardType] ([RefPsEnrollmentAwardTypeId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentStatus]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentStatus] FOREIGN KEY ([RefPsEnrollmentStatusId]) REFERENCES [dbo].[RefPsEnrollmentStatus] ([RefPsEnrollmentStatusId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefPsEnrollmentType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentType] FOREIGN KEY ([RefPsEnrollmentTypeId]) REFERENCES [dbo].[RefPsEnrollmentType] ([RefPsEnrollmentTypeId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefPSExitOrWithdrawalType]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefPSExitOrWithdrawalType] FOREIGN KEY ([RefPSExitOrWithdrawalTypeId]) REFERENCES [dbo].[RefPSExitOrWithdrawalType] ([RefPSExitOrWithdrawalTypeId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefPsStudentLevel]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefPsStudentLevel] FOREIGN KEY ([RefPsStudentLevelId]) REFERENCES [dbo].[RefPsStudentLevel] ([RefPsStudentLevelId]) ;




PRINT N'Creating [dbo].[FK_PsStudentEnrollment_RefTransferReady]...';



ALTER TABLE [dbo].[PsStudentEnrollment] WITH NOCHECK
	ADD CONSTRAINT [FK_PsStudentEnrollment_RefTransferReady] FOREIGN KEY ([RefTransferReadyId]) REFERENCES [dbo].[RefTransferReady] ([RefTransferReadyId]) ;




PRINT N'Creating [dbo].[FK_RefAdditionalTargetedSupportAndImprovementStatus_Organization]...';



ALTER TABLE [dbo].[RefAdditionalTargetedSupportAndImprovementStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefAdditionalTargetedSupportAndImprovementStatus_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefCharterSchoolAuthorizerType_Organization]...';


 IF NOT EXISTS(SELECT 1 FROM sysconstraints WHERE OBJECT_NAME(constid) = 'FK_RefCharterSchoolAuthorizerType_Organization' 
	    AND OBJECT_NAME(id) = 'RefCharterSchoolAuthorizerType' )
ALTER TABLE [dbo].[RefCharterSchoolAuthorizerType] WITH NOCHECK
	ADD CONSTRAINT [FK_RefCharterSchoolAuthorizerType_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefComprehensiveSupportAndImprovementStatus_Organization]...';



ALTER TABLE [dbo].[RefComprehensiveSupportAndImprovementStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefComprehensiveSupportAndImprovementStatus_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefGradeLevelsApproved_Organization]...';



ALTER TABLE [dbo].[RefGradeLevelsApproved] WITH NOCHECK
	ADD CONSTRAINT [FK_RefGradeLevelsApproved_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefGunFreeSchoolsActStatus_Organization1]...';



ALTER TABLE [dbo].[RefGunFreeSchoolsActReportingStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefGunFreeSchoolsActStatus_Organization1] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefHSGraduationRateIndicator_Organization]...';



ALTER TABLE [dbo].[RefHighSchoolGraduationRateIndicator] WITH NOCHECK
	ADD CONSTRAINT [FK_RefHSGraduationRateIndicator_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefIdeaEdEnvironmentSchoolAge_Organization]...';



ALTER TABLE [dbo].[RefIDEAEducationalEnvironmentSchoolAge] WITH NOCHECK
	ADD CONSTRAINT [FK_RefIdeaEdEnvironmentSchoolAge_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefEducationStaffClassification_Organization]...';



ALTER TABLE [dbo].[RefK12StaffClassification] WITH NOCHECK
	ADD CONSTRAINT [FK_RefEducationStaffClassification_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefPDActivityApprovedFor_Organization]...';



ALTER TABLE [dbo].[RefPDActivityApprovedPurpose] WITH NOCHECK
	ADD CONSTRAINT [FK_RefPDActivityApprovedFor_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefRelationship_Organization]...';



ALTER TABLE [dbo].[RefPersonRelationshipType] WITH NOCHECK
	ADD CONSTRAINT [FK_RefRelationship_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefProgramEntryReason_Organization]...';



ALTER TABLE [dbo].[RefProgramEntryReason] WITH NOCHECK
	ADD CONSTRAINT [FK_RefProgramEntryReason_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefStateANSICode_Organization]...';



ALTER TABLE [dbo].[RefStateANSICode] WITH NOCHECK
	ADD CONSTRAINT [FK_RefStateANSICode_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefTargetedSupportAndImprovementStatus_Organization]...';



ALTER TABLE [dbo].[RefTargetedSupportAndImprovementStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefTargetedSupportAndImprovementStatus_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefTelephoneNumberListedStatus_Organization]...';



ALTER TABLE [dbo].[RefTelephoneNumberListedStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefTelephoneNumberListedStatus_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_RefTitle1SchoolStatus_Organization]...';



ALTER TABLE [dbo].[RefTitleISchoolStatus] WITH NOCHECK
	ADD CONSTRAINT [FK_RefTitle1SchoolStatus_Organization] FOREIGN KEY ([RefJurisdictionId]) REFERENCES [dbo].[Organization] ([OrganizationId]) ;




PRINT N'Creating [dbo].[FK_StaffEmployment_OrganizationPersonRole]...';



ALTER TABLE [dbo].[StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_StaffEmployment_OrganizationPersonRole] FOREIGN KEY ([OrganizationPersonRoleId]) REFERENCES [dbo].[OrganizationPersonRole] ([OrganizationPersonRoleId]) ;




PRINT N'Creating [dbo].[FK_StaffEmployment_RefEmploymentSeparationReason]...';



ALTER TABLE [dbo].[StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationReason] FOREIGN KEY ([RefEmploymentSeparationReasonId]) REFERENCES [dbo].[RefEmploymentSeparationReason] ([RefEmploymentSeparationReasonId]) ;




PRINT N'Creating [dbo].[FK_StaffEmployment_RefEmploymentSeparationType]...';



ALTER TABLE [dbo].[StaffEmployment] WITH NOCHECK
	ADD CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationType] FOREIGN KEY ([RefEmploymentSeparationTypeId]) REFERENCES [dbo].[RefEmploymentSeparationType] ([RefEmploymentSeparationTypeId]) ;




PRINT N'Creating [dbo].[FK_StaffPDActivity_PDActivity]...';



ALTER TABLE [dbo].[StaffProfessionalDevelopmentActivity] WITH NOCHECK
	ADD CONSTRAINT [FK_StaffPDActivity_PDActivity] FOREIGN KEY ([ProfessionalDevelopmentActivityId]) REFERENCES [dbo].[ProfessionalDevelopmentActivity] ([ProfessionalDevelopmentActivityId]) ;




PRINT N'Creating [dbo].[FK_TeacherStudentDataLinkExclusion_K12StaffAssignment]...';



ALTER TABLE [dbo].[TeacherStudentDataLinkExclusion] WITH NOCHECK
	ADD CONSTRAINT [FK_TeacherStudentDataLinkExclusion_K12StaffAssignment] FOREIGN KEY ([K12StaffAssignmentId]) REFERENCES [dbo].[K12StaffAssignment] ([K12StaffAssignmentId]) ;



PRINT N'Check existing data against newly created constraints';


ALTER TABLE [dbo].[AssessmentSubtest_CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_AssessmentSubtest_CompetencyDefinition_CompetencyDefinition];


ALTER TABLE [dbo].[CompetencyDefAssociation] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefAssociation_CompetencyDefinition];


ALTER TABLE [dbo].[CompetencyDefEducationLevel] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefEducationLevel_CompetencyDefinition];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_CompetencyDefinition];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_CompetencyFramework];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_RefBloomsTaxonomyDomain];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionNodeAccessibilityProfile];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_RefCompetencyDefinitionTestabilityType];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_RefLanguage];


ALTER TABLE [dbo].[CompetencyDefinition] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_RefMultipleIntelligenceType];


ALTER TABLE [dbo].[CompetencyDefinition_CompetencySet] WITH CHECK CHECK CONSTRAINT [FK_CompetencyDefinition_CompetencySet_CompetencyDefinition];


ALTER TABLE [dbo].[CompetencySet_Rubric] WITH CHECK CHECK CONSTRAINT [FK_CompetencySet_Rubric_CompetencySet];


ALTER TABLE [dbo].[CompetencySet_Rubric] WITH CHECK CHECK CONSTRAINT [FK_CompetencySet_Rubric_Rubric];


ALTER TABLE [dbo].[CompetencySet_RubricCriterion] WITH CHECK CHECK CONSTRAINT [FK_CompetencySet_RubricCriterion_CompetencySet];


ALTER TABLE [dbo].[CompetencySet_RubricCriterion] WITH CHECK CHECK CONSTRAINT [FK_CompetencySet_RubricCriterion_RubricCriterion];


ALTER TABLE [dbo].[Course] WITH CHECK CHECK CONSTRAINT [FK_Course_Organization];


ALTER TABLE [dbo].[Course] WITH CHECK CHECK CONSTRAINT [FK_Course_RefCourseApplicableEducationLevel];


ALTER TABLE [dbo].[Course] WITH CHECK CHECK CONSTRAINT [FK_Course_RefCourseCreditUnit];


ALTER TABLE [dbo].[Course] WITH CHECK CHECK CONSTRAINT [FK_Course_RefCourseLevelCharacteristic];


ALTER TABLE [dbo].[Course] WITH CHECK CHECK CONSTRAINT [FK_Course_RefLanguage];


ALTER TABLE [dbo].[CourseSection] WITH CHECK CHECK CONSTRAINT [FK_CourseSection_Course];


ALTER TABLE [dbo].[CredentialCriteriaCourse] WITH CHECK CHECK CONSTRAINT [FK_CredentialCriteriaCourse_Course];


ALTER TABLE [dbo].[CteCourse] WITH CHECK CHECK CONSTRAINT [FK_CteCourse_Course];


ALTER TABLE [dbo].[ELStaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_ELStaffEmployment_StaffEmployment];


ALTER TABLE [dbo].[K12CharterSchoolAuthorizerAgency] WITH CHECK CHECK CONSTRAINT [FK_K12CharterSchoolAuthorizerAgency_RefCharterSchoolAuthorizerType];


ALTER TABLE [dbo].[K12CharterSchoolAuthorizerAgency] WITH CHECK CHECK CONSTRAINT [FK_K12CharterSchoolAuthorizerAgency_Organization];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_Course];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefAdditionalCreditType];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefBlendedLearningModel];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefCareerCluster];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefCourseGpaApplicability];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefCourseInteractionMode];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefCreditTypeEarned];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefCurriculumFrameworkType];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefK12EndOfCourseRequirement];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefSCEDCourseLevel];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefSCEDCourseSubjectArea];


ALTER TABLE [dbo].[K12Course] WITH CHECK CHECK CONSTRAINT [FK_K12Course_RefWorkbasedLearningopportunityType];


ALTER TABLE [dbo].[K12LeaGradeLevelsApproved] WITH CHECK CHECK CONSTRAINT [FK_K12LeaGradeLevelsApproved_K12Lea];


ALTER TABLE [dbo].[K12LeaGradeLevelsApproved] WITH CHECK CHECK CONSTRAINT [FK_K12LeaGradeLevelsApproved_RefGradeLevel];


ALTER TABLE [dbo].[K12LeaGradeOffered] WITH CHECK CHECK CONSTRAINT [FK_K12LeaGradeOffered_K12Lea];


ALTER TABLE [dbo].[K12LeaGradeOffered] WITH CHECK CHECK CONSTRAINT [FK_K12LeaGradeOffered_RefGradeLevel];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_K12CharterSchoolAuthorizerAgency];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_K12CharterSchoolManagementOrganization];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_Organization];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefAdminFundingControl];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefCharterSchoolType];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefIncreasedLearningTimeType];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefSchoolLevel];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefSchoolType];


ALTER TABLE [dbo].[K12School] WITH CHECK CHECK CONSTRAINT [FK_K12School_RefStatePovertyDesignation];


ALTER TABLE [dbo].[K12SchoolCorrectiveAction] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolCorrectiveAction_K12School];


ALTER TABLE [dbo].[K12SchoolGradeLevelsApproved] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolGradeLevelsApproved_K12School];


ALTER TABLE [dbo].[K12SchoolGradeLevelsApproved] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolGradeLevelsApproved_RefGradeLevel];


ALTER TABLE [dbo].[K12SchoolGradeOffered] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolGradeOffered_K12School];


ALTER TABLE [dbo].[K12SchoolImprovement] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolImprovement_K12School];


ALTER TABLE [dbo].[K12SchoolIndicatorStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolIndicatorStatus_K12School];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_K12School];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefAlternativeSchoolFocus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefBlendedLearningModelType];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefComprehensiveSupport];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefInternetAccess];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefMagnetSpecialProgram];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefNationalSchoolLunchProgramStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefNSLPStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefRestructuringAction];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefSchoolDangerousStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefSchoolImprovementStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefTargetedSupport];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefTitle1SchoolStatus];


ALTER TABLE [dbo].[K12SchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_K12SchoolStatus_RefVirtualSchoolStatus];


ALTER TABLE [dbo].[K12Sea] WITH CHECK CHECK CONSTRAINT [FK_K12Sea_Organization];


ALTER TABLE [dbo].[K12Sea] WITH CHECK CHECK CONSTRAINT [FK_K12Sea_RefStateANSICode];


ALTER TABLE [dbo].[K12SeaFederalFunds] WITH CHECK CHECK CONSTRAINT [FK_K12SeaFederalFunds_K12Sea];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_OrganizationPerson];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_OrganizationPersonRole];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefClassroomPositionType];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefEducationStaffClassification];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefMepStaffCategory];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefOutOfFieldStatus];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefProfessionalEducationJobClassification];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefSpecialEducationStaffCategory];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefTeachingAssignmentRole];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefTitleIProgramStaffCategory];


ALTER TABLE [dbo].[K12StaffAssignment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffAssignment_RefUnexperiencedStatus];


ALTER TABLE [dbo].[K12StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffEmployment_RefEmploymentStatus];


ALTER TABLE [dbo].[K12StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffEmployment_RefEduStaffClassification];


ALTER TABLE [dbo].[K12StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_K12StaffEmployment_StaffEmployment];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12EnrollmentMember_OrganizationPerson];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_OrganizationPersonRole];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefEndOfTermStatus];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefEnrollmentStatus];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefEntryType];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalStatus];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefExitOrWithdrawalType];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefFoodServiceEligibility];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12EnrollmentMember_RefGrade];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefGradeLevel];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefNonPromotionReason];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefPromotionReason];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefPublicSchoolResidence];


ALTER TABLE [dbo].[K12StudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_K12StudentEnrollment_RefStudentEnrollmentAccessType];


ALTER TABLE [dbo].[K12StudentGraduationPlan] WITH CHECK CHECK CONSTRAINT [FK_K12StudentGraduationPlan_K12Course];


ALTER TABLE [dbo].[OrganizationDetail] WITH CHECK CHECK CONSTRAINT [FK_OrganizationDetail_Organization];


ALTER TABLE [dbo].[OrganizationDetail] WITH CHECK CHECK CONSTRAINT [FK_OrganizationDetail_RefOrganizationType];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_Organization];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefAdditionalTargetedSupportAndImprovementStatus];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederaAccountability_RefAypStatus];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefComprehensiveSupportAndImprovementStatus];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefCteGraduationRateInclusion];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefElementaryMiddleAdditional];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFedAccountability_RefHSGraduationRateIndicator];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp2];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefParticipationStatusAyp3];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAyp];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefProficiencyTargetAyp1];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefReconstitutedStatus];


ALTER TABLE [dbo].[OrganizationFederalAccountability] WITH CHECK CHECK CONSTRAINT [FK_OrganizationFederalAccountability_RefTargetedSupportAndImprovementStatus];


ALTER TABLE [dbo].[OrganizationPersonRoleFTE] WITH CHECK CHECK CONSTRAINT [FK_OrganizationPersonRoleFTE_OrganizationPersonRole];


ALTER TABLE [dbo].[OrganizationTelephone] WITH CHECK CHECK CONSTRAINT [FK_OrganizationTelephone_RefTelephoneNumberListedStatus];


ALTER TABLE [dbo].[PDActivityEducationLevel] WITH CHECK CHECK CONSTRAINT [FK_PDActivityEducationLevel_PDActivity];


ALTER TABLE [dbo].[PersonProgramParticipation] WITH CHECK CHECK CONSTRAINT [FK_PersonProgramParticipation_RefProgramEntryReason];


ALTER TABLE [dbo].[PersonRelationship] WITH CHECK CHECK CONSTRAINT [FK_PersonRelationship_Person_Primary];


ALTER TABLE [dbo].[PersonRelationship] WITH CHECK CHECK CONSTRAINT [FK_PersonRelationship_Person_Secondary];


ALTER TABLE [dbo].[PersonRelationship] WITH CHECK CHECK CONSTRAINT [FK_PersonRelationship_RefRelationship];


ALTER TABLE [dbo].[PersonTelephone] WITH CHECK CHECK CONSTRAINT [FK_PersonTelephone_RefTelephoneNumberListedStatus];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_PDSession_Course];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_PDSession_PDRequirement];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_PDSession_RefCourseCreditUnit];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityLevel];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDActivityType];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_ProfessionalDevelopmentActivity_RefPDAudienceType];


ALTER TABLE [dbo].[ProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_PDSession_RefProfDevFinancialSupport];


ALTER TABLE [dbo].[ProfessionalDevelopmentSession] WITH CHECK CHECK CONSTRAINT [FK_PDSession_PDActivity];


ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_ProgramParticipationSpecialEducation_PersonProgramParticipat];


ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC];


ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge];


ALTER TABLE [dbo].[ProgramParticipationSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason];


ALTER TABLE [dbo].[PsCourse] WITH CHECK CHECK CONSTRAINT [FK_PsCourse_Course];


ALTER TABLE [dbo].[PsStaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_PsStaffEmployment_StaffEmployment];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_OrganizationPersonRole];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefDevelopmentalEducationType];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefDistanceEducationCourseEnr];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefInstructionalActivityHours];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentAwardType];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentStatus];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefPsEnrollmentType];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefPSExitOrWithdrawalType];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefPsStudentLevel];


ALTER TABLE [dbo].[PsStudentEnrollment] WITH CHECK CHECK CONSTRAINT [FK_PsStudentEnrollment_RefTransferReady];


ALTER TABLE [dbo].[RefAdditionalTargetedSupportAndImprovementStatus] WITH CHECK CHECK CONSTRAINT [FK_RefAdditionalTargetedSupportAndImprovementStatus_Organization];


ALTER TABLE [dbo].[RefCharterSchoolAuthorizerType] WITH CHECK CHECK CONSTRAINT [FK_RefCharterSchoolAuthorizerType_Organization];


ALTER TABLE [dbo].[RefComprehensiveSupportAndImprovementStatus] WITH CHECK CHECK CONSTRAINT [FK_RefComprehensiveSupportAndImprovementStatus_Organization];


ALTER TABLE [dbo].[RefGradeLevelsApproved] WITH CHECK CHECK CONSTRAINT [FK_RefGradeLevelsApproved_Organization];


ALTER TABLE [dbo].[RefGunFreeSchoolsActReportingStatus] WITH CHECK CHECK CONSTRAINT [FK_RefGunFreeSchoolsActStatus_Organization1];


ALTER TABLE [dbo].[RefHighSchoolGraduationRateIndicator] WITH CHECK CHECK CONSTRAINT [FK_RefHSGraduationRateIndicator_Organization];


ALTER TABLE [dbo].[RefIDEAEducationalEnvironmentSchoolAge] WITH CHECK CHECK CONSTRAINT [FK_RefIdeaEdEnvironmentSchoolAge_Organization];


ALTER TABLE [dbo].[RefK12StaffClassification] WITH CHECK CHECK CONSTRAINT [FK_RefEducationStaffClassification_Organization];


ALTER TABLE [dbo].[RefPDActivityApprovedPurpose] WITH CHECK CHECK CONSTRAINT [FK_RefPDActivityApprovedFor_Organization];


ALTER TABLE [dbo].[RefPersonRelationshipType] WITH CHECK CHECK CONSTRAINT [FK_RefRelationship_Organization];


ALTER TABLE [dbo].[RefProgramEntryReason] WITH CHECK CHECK CONSTRAINT [FK_RefProgramEntryReason_Organization];


ALTER TABLE [dbo].[RefStateANSICode] WITH CHECK CHECK CONSTRAINT [FK_RefStateANSICode_Organization];


ALTER TABLE [dbo].[RefTargetedSupportAndImprovementStatus] WITH CHECK CHECK CONSTRAINT [FK_RefTargetedSupportAndImprovementStatus_Organization];


ALTER TABLE [dbo].[RefTelephoneNumberListedStatus] WITH CHECK CHECK CONSTRAINT [FK_RefTelephoneNumberListedStatus_Organization];


ALTER TABLE [dbo].[RefTitleISchoolStatus] WITH CHECK CHECK CONSTRAINT [FK_RefTitle1SchoolStatus_Organization];


ALTER TABLE [dbo].[StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_StaffEmployment_OrganizationPersonRole];


ALTER TABLE [dbo].[StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationReason];


ALTER TABLE [dbo].[StaffEmployment] WITH CHECK CHECK CONSTRAINT [FK_StaffEmployment_RefEmploymentSeparationType];


ALTER TABLE [dbo].[StaffProfessionalDevelopmentActivity] WITH CHECK CHECK CONSTRAINT [FK_StaffPDActivity_PDActivity];


ALTER TABLE [dbo].[TeacherStudentDataLinkExclusion] WITH CHECK CHECK CONSTRAINT [FK_TeacherStudentDataLinkExclusion_K12StaffAssignment];


PRINT N'Renaming Foreign Keys';

IF EXISTS(SELECT 1 FROM sys.objects WHERE type = 'PK' AND name = 'FK_ProgramParticipationTeacherPrepId' AND parent_object_id = OBJECT_ID ('ProgramParticipationTeacherPrep'))
	EXEC sp_rename @objname = N'FK_ProgramParticipationTeacherPrepId', @newname = N'PK_ProgramParticipationTeacherPrepId';


PRINT N'Update complete.';

END