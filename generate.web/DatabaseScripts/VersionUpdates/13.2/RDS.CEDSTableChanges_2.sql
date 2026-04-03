PRINT 'ADD DEFAULT ROWS TO DIMENSION TABLES'
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureAlternateResponseOptions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureAlternateResponseOptions] WHERE [DimAccessibilityFeatureAlternateResponseOptionId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureAlternateResponseOptions] ([DimAccessibilityFeatureAlternateResponseOptionId], [AlternateResponseOptionTypeCode], [AlternateResponseOptionTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureAlternateResponseOptions] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureAssessmentExtendedTimes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureAssessmentExtendedTimes] WHERE [DimAccessibilityFeatureAssessmentExtendedTimeId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureAssessmentExtendedTimes] ([DimAccessibilityFeatureAssessmentExtendedTimeId], [AssessmentExtendedTimeTypeCode], [AssessmentExtendedTimeTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureAssessmentExtendedTimes] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureBrailles] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureBrailles] WHERE [DimAccessibilityFeatureBrailleId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureBrailles] ([DimAccessibilityFeatureBrailleId], [BrailleAccessTypeCode], [BrailleAccessTypeDescription], [BrailleApplicationTypeCode], [BrailleApplicationTypeDescription], [BrailleCodeTypeCode], [BrailleCodeTypeDescription], [BrailleVersionTypeCode], [BrailleVersionTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureBrailles] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureBreaks] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureBreaks] WHERE [DimAccessibilityFeatureBreakId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureBreaks] ([DimAccessibilityFeatureBreakId], [BreakLocationTypeCode], [BreakLocationTypeDescription], [BreakTypeCode], [BreakTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureBreaks] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureCalculators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureCalculators] WHERE [DimAccessibilityFeatureCalculatorId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureCalculators] ([DimAccessibilityFeatureCalculatorId], [AdaptiveCalculatorTypeCode], [AdaptiveCalculatorTypeDescription], [CalculatorTypeCode], [CalculatorTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureCalculators] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureDisplayFormatAdjustments] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureDisplayFormatAdjustments] WHERE [DimAccessibilityFeatureDisplayFormatAdjustmentId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureDisplayFormatAdjustments] ([DimAccessibilityFeatureDisplayFormatAdjustmentId], [DisplayFormatAdjustmentTypeCode], [DisplayFormatAdjustmentTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureDisplayFormatAdjustments] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureGroupSizes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureGroupSizes] WHERE [DimAccessibilityFeatureGroupSizeId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureGroupSizes] ([DimAccessibilityFeatureGroupSizeId], [GroupSizeTypeCode], [GroupSizeTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureGroupSizes] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureMedicalSupports] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureMedicalSupports] WHERE [DimAccessibilityFeatureMedicalSupportId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureMedicalSupports] ([DimAccessibilityFeatureMedicalSupportId], [MedicalSupportTypeCode], [MedicalSupportTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureMedicalSupports] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureReadAlouds] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureReadAlouds] WHERE [DimAccessibilityFeatureReadAloudId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureReadAlouds] ([DimAccessibilityFeatureReadAloudId], [ReadAloudTypeCode], [ReadAloudTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureReadAlouds] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureReferenceSheets] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureReferenceSheets] WHERE [DimAccessibilityFeatureReferenceSheetId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureReferenceSheets] ([DimAccessibilityFeatureReferenceSheetId], [ReferenceSheetTypeCode], [ReferenceSheetTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureReferenceSheets] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatures] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatures] WHERE [DimAccessibilityFeatureId] = -1) INSERT INTO [rds].[DimAccessibilityFeatures] ([DimAccessibilityFeatureId], [AccessibilityFeatureTypeCode], [AccessibilityFeatureTypeDescription], [AccessibilityFeatureApplicationTypeCode], [AccessibilityFeatureApplicationTypeDescription], [AccessibilityFeatureCategoryCode], [AccessibilityFeatureCategoryDescription], [AccessibilityFeatureDeliveryMethodCode], [AccessibilityFeatureDeliveryMethodDescription], [AccessibilityFeatureEmbeddedIndicatorCode], [AccessibilityFeatureEmbeddedIndicatorDescription], [AccessibilityFeaturePausesTheClockIndicatorCode], [AccessibilityFeaturePausesTheClockIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatures] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureSettings] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureSettings] WHERE [DimAccessibilityFeatureSettingId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureSettings] ([DimAccessibilityFeatureSettingId], [SettingTypeCode], [SettingTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureSettings] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureSignedAdministrations] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureSignedAdministrations] WHERE [DimAccessibilityFeatureSignedAdministrationId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureSignedAdministrations] ([DimAccessibilityFeatureSignedAdministrationId], [SignedAdministrationDeliveryMethodCode], [SignedAdministrationDeliveryMethodDescription], [SignedAdministrationTypeCode], [SignedAdministrationTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureSignedAdministrations] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureTactileMediums] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureTactileMediums] WHERE [DimAccessibilityFeatureTactileMediumId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureTactileMediums] ([DimAccessibilityFeatureTactileMediumId], [TactileMediumTypeCode], [TactileMediumTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureTactileMediums] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureTranslationPresentations] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibilityFeatureTranslationPresentations] WHERE [DimAccessibilityFeatureTranslationPresentationId] = -1) INSERT INTO [rds].[DimAccessibilityFeatureTranslationPresentations] ([DimAccessibilityFeatureTranslationPresentationId], [TranslationPresentationTypeCode], [TranslationPresentationTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAccessibilityFeatureTranslationPresentations] OFF;
    SET IDENTITY_INSERT [rds].[DimAeEmploymentBarriers] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeEmploymentBarriers] WHERE [DimAeEmploymentBarrierId] = -1) INSERT INTO [rds].[DimAeEmploymentBarriers] ([DimAeEmploymentBarrierId], [WioaBarriersToEmploymentCode], [WioaBarriersToEmploymentDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeEmploymentBarriers] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramEmploymentIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramEmploymentIndicators] WHERE [DimAeProgramEmploymentIndicatorId] = -1) INSERT INTO [rds].[DimAeProgramEmploymentIndicators] ([DimAeProgramEmploymentIndicatorId], [EmployedAfterExitCode], [EmployedAfterExitDescription], [EmployedWhileEnrolledCode], [EmployedWhileEnrolledDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeProgramEmploymentIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramParticipantAssessmentIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramParticipantAssessmentIndicators] WHERE [DimAeProgramParticipantAssessmentIndicatorId] = -1) INSERT INTO [rds].[DimAeProgramParticipantAssessmentIndicators] ([DimAeProgramParticipantAssessmentIndicatorId], [AeFunctioningLevelAtIntakeCode], [AeFunctioningLevelAtIntakeDescription], [AeFunctioningLevelAtPosttestCode], [AeFunctioningLevelAtPosttestDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeProgramParticipantAssessmentIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramParticipantGoals] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramParticipantGoals] WHERE [DimAeProgramParticipantGoalId] = -1) INSERT INTO [rds].[DimAeProgramParticipantGoals] ([DimAeProgramParticipantGoalId], [GoalsForAttendingAdultEducationCode], [GoalsForAttendingAdultEducationDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeProgramParticipantGoals] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramParticipantIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramParticipantIndicators] WHERE [DimAeProgramParticipantIndicatorId] = -1) INSERT INTO [rds].[DimAeProgramParticipantIndicators] ([DimAeProgramParticipantIndicatorId], [CorrectionalEducationReentryServicesParticipationIndicatorCode], [CorrectionalEducationReentryServicesParticipationIndicatorDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeProgramParticipantIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramTransitionIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramTransitionIndicators] WHERE [DimAeProgramTransitionIndicatorId] = -1) INSERT INTO [rds].[DimAeProgramTransitionIndicators] ([DimAeProgramTransitionIndicatorId], [AePostsecondaryTransitionActionCode], [AePostsecondaryTransitionActionDescription], [AdultEducationCredentialAttainmentPostsecondaryEnrollmentIndicatorCode], [AdultEducationCredentialAttainmentPostsecondaryEnrollmentIndicatorDescription], [AdultEducationCredentialAttainmentEmployedIndicatorCode], [AdultEducationCredentialAttainmentEmployedIndicatorDescription], [AdultEducationCredentialAttainmentPostsecondaryCredentialIndicatorCode], [AdultEducationCredentialAttainmentPostsecondaryCredentialIndicatorDescription], [AdultEducationProgramExitReasonCode], [AdultEducationProgramExitReasonDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAeProgramTransitionIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimAlternativeSchoolStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAlternativeSchoolStatuses] WHERE [DimAlternativeSchoolStatusId] = -1) INSERT INTO [rds].[DimAlternativeSchoolStatuses] ([DimAlternativeSchoolStatusId], [AlternativeSchoolFocusTypeCode], [AlternativeSchoolFocusTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAlternativeSchoolStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimAssessmentComponents] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAssessmentComponents] WHERE [DimAssessmentComponentId] = -1) INSERT INTO [rds].[DimAssessmentComponents] ([DimAssessmentComponentId], [AssessmentComponentTypeCode], [AssessmentComponentTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimAssessmentComponents] OFF;
    SET IDENTITY_INSERT [rds].[DimAssessmentForms] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAssessmentForms] WHERE [DimAssessmentFormId] = -1) INSERT INTO [rds].[DimAssessmentForms] ([DimAssessmentFormId], [AssessmentFormNumber]) VALUES (-1, 'missing'); SET IDENTITY_INSERT [rds].[DimAssessmentForms] OFF;
    SET IDENTITY_INSERT [rds].[DimCalendarEventIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCalendarEventIndicators] WHERE [DimCalendarEventIndicatorId] = -1) INSERT INTO [rds].[DimCalendarEventIndicators] ([DimCalendarEventIndicatorId], [CalendarEventTypeCode], [CalendarEventTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCalendarEventIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimCalendarSessionIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCalendarSessionIndicators] WHERE [DimCalendarSessionIndicatorId] = -1) INSERT INTO [rds].[DimCalendarSessionIndicators] ([DimCalendarSessionIndicatorId], [SessionTypeCode], [SessionTypeDescription], [SessionMarkingTermIndicatorCode], [SessionMarkingTermIndicatorDescription], [SessionSchedulingTermIndicatorCode], [SessionSchedulingTermIndicatorDescription], [SessionAttendanceTermIndicatorCode], [SessionAttendanceTermIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCalendarSessionIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimChildOutcomeSummaries] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimChildOutcomeSummaries] WHERE [DimChildOutcomeSummaryId] = -1) INSERT INTO [rds].[DimChildOutcomeSummaries] ([DimChildOutcomeSummaryId], [CosRatingACode], [CosRatingADescription], [CosRatingBCode], [CosRatingBDescription], [CosRatingCCode], [CosRatingCDescription], [CosProgressAIndicatorCode], [CosProgressAIndicatorDescription], [CosProgressBIndicatorCode], [CosProgressBIndicatorDescription], [CosProgressCIndicatorCode], [CosProgressCIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimChildOutcomeSummaries] OFF;
    SET IDENTITY_INSERT [rds].[DimCipCodes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCipCodes] WHERE [DimCipCodeId] = -1) INSERT INTO [rds].[DimCipCodes] ([DimCipCodeId], [CipCode], [CipDescription], [CipUseCode], [CipUseDescription], [CipVersionCode], [CipVersionDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCipCodes] OFF;
    SET IDENTITY_INSERT [rds].[DimCohortExclusions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCohortExclusions] WHERE [DimCohortExclusionId] = -1) INSERT INTO [rds].[DimCohortExclusions] ([DimCohortExclusionId], [CohortExclusionCode], [CohortExclusionDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCohortExclusions] OFF;
    SET IDENTITY_INSERT [rds].[DimCohorts] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCohorts] WHERE [DimCohortId] = -1) INSERT INTO [rds].[DimCohorts] ([DimCohortId], [CohortDescription]) VALUES (-1, 'missing'); SET IDENTITY_INSERT [rds].[DimCohorts] OFF;
    SET IDENTITY_INSERT [rds].[DimContactIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimContactIndicators] WHERE [DimContactIndicatorId] = -1) INSERT INTO [rds].[DimContactIndicators] ([DimContactIndicatorId], [PrimaryContactIndicatorCode], [PrimaryContactIndicatorDescription], [EmergencyContactIndicatorCode], [EmergencyContactIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimContactIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimCourseGradePointAverageIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCourseGradePointAverageIndicators] WHERE [DimCourseGradePointAverageIndicatorId] = -1) INSERT INTO [rds].[DimCourseGradePointAverageIndicators] ([DimCourseGradePointAverageIndicatorId], [CourseGradePointAverageApplicabilityCode], [CourseGradePointAverageApplicabilityDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCourseGradePointAverageIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimCredentialAwardStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCredentialAwardStatuses] WHERE [DimCredentialAwardStatusId] = -1) INSERT INTO [rds].[DimCredentialAwardStatuses] ([DimCredentialAwardStatusId], [CredentialRevokedIndicatorCode], [CredentialRevokedIndicatorDescription], [CredentialRevokedReasonCode], [CredentialRevokedReasonDescription], [AdultEducationCertificationTypeCode], [AdultEducationCertificationTypeDescription], [CredentialSuspensionIndicatorCode], [CredentialSuspensionIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCredentialAwardStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimCredentials] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCredentials] WHERE [DimCredentialId] = -1) INSERT INTO [rds].[DimCredentials] ([DimCredentialId], [CredentialDefinitionTitle], [CredentialDefinitionDescription], [CredentialDefinitionAlternateName], [CredentialDefinitionCategorySystem], [CredentialDefinitionCategoryType], [CredentialDefinitionStatusTypeCode], [CredentialDefinitionStatusTypeDescription], [CredentialDefinitionIntendedPurposeTypeCode], [CredentialDefinitionIntendedPurposeTypeDescription], [CredentialDefinitionAssessmentMethodTypeCode], [CredentialDefinitionAssessmentMethodTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimCredentials] OFF;
    SET IDENTITY_INSERT [rds].[DimDisciplineReasons] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimDisciplineReasons] WHERE [DimDisciplineReasonId] = -1) INSERT INTO [rds].[DimDisciplineReasons] ([DimDisciplineReasonId], [DisciplineReasonCode], [DisciplineReasonDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimDisciplineReasons] OFF;
    SET IDENTITY_INSERT [rds].[DimEarlyChildhoolOrganizationStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEarlyChildhoolOrganizationStatuses] WHERE [DimEarlyChildhoodOrganizationStatusId] = -1) INSERT INTO [rds].[DimEarlyChildhoolOrganizationStatuses] ([DimEarlyChildhoodOrganizationStatusId], [EarlyChildhoodProgramEnrollmentTypeCode], [EarlyChildhoodProgramEnrollmentTypeDescription], [EarlyLearningOtherFederalFundingSourcesCode], [EarlyLearningOtherFederalFundingSourcesDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimEarlyChildhoolOrganizationStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimEmploymentLocations] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEmploymentLocations] WHERE [DimEmploymentLocationId] = -1) INSERT INTO [rds].[DimEmploymentLocations] ([DimEmploymentLocationId], [EmploymentLocationCode], [EmploymentLocationDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimEmploymentLocations] OFF;
    SET IDENTITY_INSERT [rds].[DimEmploymentRecordSources] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEmploymentRecordSources] WHERE [DimEmploymentRecordSourceId] = -1) INSERT INTO [rds].[DimEmploymentRecordSources] ([DimEmploymentRecordSourceId], [EmploymentRecordAdministrativeDataSourceCode], [EmploymentRecordAdministrativeDataSourceDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimEmploymentRecordSources] OFF;
    SET IDENTITY_INSERT [rds].[DimFacilitySpaceStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFacilitySpaceStatuses] WHERE [DimFacilitySpaceStatusId] = -1) INSERT INTO [rds].[DimFacilitySpaceStatuses] ([DimFacilitySpaceStatusId], [FacilitySpaceUseTypeCode], [FacilitySpaceUseTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFacilitySpaceStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimFacilityStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFacilityStatuses] WHERE [DimFacilityStatusId] = -1) INSERT INTO [rds].[DimFacilityStatuses] ([DimFacilityStatusId], [FacilityLeaseAmountCategoryCode], [FacilityLeaseAmountCategoryDescription], [FacilityLeaseTypeCode], [FacilityLeaseTypeDescription], [FacilityMortgageInterestTypeCode], [FacilityMortgageInterestTypeDescription], [FacilityMortgageTypeCode], [FacilityMortgageTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFacilityStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimFacilityUtilization] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFacilityUtilization] WHERE [DimFacilityUtilizationStatusId] = -1) INSERT INTO [rds].[DimFacilityUtilization] ([DimFacilityUtilizationStatusId], [BuildingUseTypeCode], [BuildingUseTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFacilityUtilization] OFF;
    SET IDENTITY_INSERT [rds].[DimFederalFinancialAccountBalances] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFederalFinancialAccountBalances] WHERE [DimFederalFinancialAccountBalanceId] = -1) INSERT INTO [rds].[DimFederalFinancialAccountBalances] ([DimFederalFinancialAccountBalanceId], [FinancialAccountBalanceSheetCodeCode], [FinancialAccountBalanceSheetCodeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFederalFinancialAccountBalances] OFF;
    SET IDENTITY_INSERT [rds].[DimFederalFinancialAccountClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFederalFinancialAccountClassifications] WHERE [DimFederalFinancialAccountClassificationId] = -1) INSERT INTO [rds].[DimFederalFinancialAccountClassifications] ([DimFederalFinancialAccountClassificationId], [FinancialAccountCategoryCode], [FinancialAccountCategoryDescription], [FinancialAccountProgramCodeCode], [FinancialAccountProgramCodeDescription], [FinancialAccountFundClassificationCode], [FinancialAccountFundClassificationDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFederalFinancialAccountClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimFederalFinancialExpenditureClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFederalFinancialExpenditureClassifications] WHERE [DimFederalFinancialExpenditureClassificationId] = -1) INSERT INTO [rds].[DimFederalFinancialExpenditureClassifications] ([DimFederalFinancialExpenditureClassificationId], [FinancialExpenditureFunctionCodeCode], [FinancialExpenditureFunctionCodeDescription], [FinancialExpenditureObjectCodeCode], [FinancialExpenditureObjectCodeDescription], [FinancialExpenditureLevelOfInstructionCodeCode], [FinancialExpenditureLevelOfInstructionCodeDescription], [FinancialExpenditureProjectReportingCodeCode], [FinancialExpenditureProjectReportingCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFederalFinancialExpenditureClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimFederalFinancialRevenueClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFederalFinancialRevenueClassifications] WHERE [DimFederalFinancialRevenueClassificationId] = -1) INSERT INTO [rds].[DimFederalFinancialRevenueClassifications] ([DimFederalFinancialRevenueClassificationId], [FinancialAccountRevenueCodeCode], [FinancialAccountRevenueCodeDescription], [FinancialAccountRevenueObjectCodeCode], [FinancialAccountRevenueObjectCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFederalFinancialRevenueClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimFederalProgramCodes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFederalProgramCodes] WHERE [DimFederalProgramCodeId] = -1) INSERT INTO [rds].[DimFederalProgramCodes] ([DimFederalProgramCodeId], [FederalProgramCode], [FederalProgramCodeDescription], [FederalProgramSubgrantCode], [FederalProgramSubgrantCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimFederalProgramCodes] OFF;
    SET IDENTITY_INSERT [rds].[DimGiftedAndTalentedStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimGiftedAndTalentedStatuses] WHERE [DimGiftedAndTalentedStatusId] = -1) INSERT INTO [rds].[DimGiftedAndTalentedStatuses] ([DimGiftedAndTalentedStatusId], [GiftedAndTalentedIndicatorCode], [GiftedAndTalentedIndicatorDescription], [ProgramGiftedEligibilityCriteriaCode], [ProgramGiftedEligibilityCriteriaDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimGiftedAndTalentedStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimIncidentBehaviors] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimIncidentBehaviors] WHERE [DimIncidentBehaviorId] = -1) INSERT INTO [rds].[DimIncidentBehaviors] ([DimIncidentBehaviorId], [IncidentBehaviorCode], [IncidentBehaviorDescription], [SecondaryIncidentBehaviorCode], [SecondaryIncidentBehaviorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimIncidentBehaviors] OFF;
    SET IDENTITY_INSERT [rds].[DimIncidents] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimIncidents] WHERE [DimIncidentId] = -1) INSERT INTO [rds].[DimIncidents] ([DimIncidentId], [IncidentIdentifier], [IncidentDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimIncidents] OFF;
    SET IDENTITY_INSERT [rds].[DimIncidentSettings] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimIncidentSettings] WHERE [DimIncidentSettingId] = -1) INSERT INTO [rds].[DimIncidentSettings] ([DimIncidentSettingId], [IncidentLocationCode], [IncidentLocationDescription], [IncidentActivityCode], [IncidentActivityDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimIncidentSettings] OFF;
    SET IDENTITY_INSERT [rds].[DimIncidentTimeIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimIncidentTimeIndicators] WHERE [DimIncidentTimeIndicatorId] = -1) INSERT INTO [rds].[DimIncidentTimeIndicators] ([DimIncidentTimeIndicatorId], [IncidentTimeDescriptionCodeCode], [IncidentTimeDescriptionCodeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimIncidentTimeIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimIndividualizedProgramStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimIndividualizedProgramStatuses] WHERE [DimIndividualizedProgramStatusId] = -1) INSERT INTO [rds].[DimIndividualizedProgramStatuses] ([DimIndividualizedProgramStatusId], [IndividualizedProgramTypeCode], [IndividualizedProgramTypeDescription], [StudentSupportServiceTypeCode], [StudentSupportServiceTypeDescription], [ConsentToEvaluationIndicatorCode], [ConsentToEvaluationIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimIndividualizedProgramStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12AcademicAwards] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12AcademicAwards] WHERE [DimK12AcademicAwardId] = -1) INSERT INTO [rds].[DimK12AcademicAwards] ([DimK12AcademicAwardId], [AcademicAwardTitle]) VALUES (-1, 'missing'); SET IDENTITY_INSERT [rds].[DimK12AcademicAwards] OFF;
    SET IDENTITY_INSERT [rds].[DimK12CourseFundings] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12CourseFundings] WHERE [DimK12CourseFundingId] = -1) INSERT INTO [rds].[DimK12CourseFundings] ([DimK12CourseFundingId], [CourseFundingProgram], [CourseFundingProgramAllowed]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12CourseFundings] OFF;
    SET IDENTITY_INSERT [rds].[DimK12CourseSectionEnrollmentStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12CourseSectionEnrollmentStatuses] WHERE [DimK12CourseSectionEnrollmentStatusId] = -1) INSERT INTO [rds].[DimK12CourseSectionEnrollmentStatuses] ([DimK12CourseSectionEnrollmentStatusId], [CourseSectionEnrollmentStatusTypeCode], [CourseSectionEnrollmentStatusTypeDescription], [CourseSectionEntryTypeCode], [CourseSectionEntryTypeDescription], [CourseSectionExitTypeCode], [CourseSectionExitTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12CourseSectionEnrollmentStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12CourseSections] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12CourseSections] WHERE [DimK12CourseSectionId] = -1) INSERT INTO [rds].[DimK12CourseSections] ([DimK12CourseSectionId], [CourseSectionIdentifier], [ClassPeriod], [ClassMeetingDays], [ClassroomIdentifier], [GradeValueQualifier], [CourseDescription], [TimetableDayIdentifier]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12CourseSections] OFF;
    SET IDENTITY_INSERT [rds].[DimK12CourseSectionStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12CourseSectionStatuses] WHERE [DimK12CourseSectionStatusId] = -1) INSERT INTO [rds].[DimK12CourseSectionStatuses] ([DimK12CourseSectionStatusId], [BlendedLearningModelTypeCode], [BlendedLearningModelTypeDescription], [CourseInteractionModeCode], [CourseInteractionModeDescription], [CourseSectionAssessmentReportingMethodCode], [CourseSectionAssessmentReportingMethodDescription], [CourseSectionInstructionalDeliveryModeCode], [CourseSectionInstructionalDeliveryModeDescription], [ReceivingLocationOfInstructionCode], [ReceivingLocationOfInstructionDescription], [VirtualIndicatorCode], [VirtualIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12CourseSectionStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12DropoutStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12DropoutStatuses] WHERE [DimK12DropoutStatusId] = -1) INSERT INTO [rds].[DimK12DropoutStatuses] ([DimK12DropoutStatusId], [StudentDropoutStatusCode], [StudentDropoutStatusDescription], [DropoutReasonTypeCode], [DropoutReasonTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12DropoutStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12EmploymentStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12EmploymentStatuses] WHERE [DimK12EmploymentStatusId] = -1) INSERT INTO [rds].[DimK12EmploymentStatuses] ([DimK12EmploymentStatusId], [EmploymentStatusCode], [EmploymentStatusDescription], [EmploymentSeparationReasonCode], [EmploymentSeparationReasonDescription], [EmploymentSeparationTypeCode], [EmploymentSeparationTypeDescription], [TitleITargetedAssistanceStaffFundedCode], [TitleITargetedAssistanceStaffFundedDescription], [MEPPersonnelIndicatorCode], [MEPPersonnelIndicatorDescription], [SalaryForTeachingAssignmentOnlyIndicatorCode], [SalaryForTeachingAssignmentOnlyIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12EmploymentStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12Jobs] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12Jobs] WHERE [DimK12JobId] = -1) INSERT INTO [rds].[DimK12Jobs] ([DimK12JobId], [JobIdentifierLea], [JobIdentifierSchool], [JobIdentifierSea], [JobTitle]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12Jobs] OFF;
    SET IDENTITY_INSERT [rds].[DimK12RetentionStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12RetentionStatuses] WHERE [DimK12RetentionStatusId] = -1) INSERT INTO [rds].[DimK12RetentionStatuses] ([DimK12RetentionStatusId], [RetentionExemptionReasonCode], [RetentionExemptionReasonDescription], [EndOfTermStatusCode], [EndOfTermStatusDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12RetentionStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimK12StaffAssignmentStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12StaffAssignmentStatuses] WHERE [DimK12StaffAssignmentStatusId] = -1) INSERT INTO [rds].[DimK12StaffAssignmentStatuses] ([DimK12StaffAssignmentStatusId], [ItinerantTeacherCode], [ItinerantTeacherDescription], [ClassroomPositionTypeCode], [ClassroomPositionTypeDescription], [PrimaryAssignmentIndicatorCode], [PrimaryAssignmentIndicatorDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimK12StaffAssignmentStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimLeaFinancialAccountBalances] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimLeaFinancialAccountBalances] WHERE [DimLeaFinancialAccountBalanceId] = -1) INSERT INTO [rds].[DimLeaFinancialAccountBalances] ([DimLeaFinancialAccountBalanceId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountLocalBalanceSheetCodeCode], [FinancialAccountLocalBalanceSheetCodeSeaCode], [FinancialAccountLocalBalanceSheetCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimLeaFinancialAccountBalances] OFF;
    SET IDENTITY_INSERT [rds].[DimLeaFinancialAccountClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimLeaFinancialAccountClassifications] WHERE [DimLeaFinancialAccountClassificationId] = -1) INSERT INTO [rds].[DimLeaFinancialAccountClassifications] ([DimLeaFinancialAccountClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountCategoryCode], [FinancialAccountCategorySeaCode], [FinancialAccountCategoryDescription], [FinancialAccountLocalProgramCodeCode], [FinancialAccountLocalProgramCodeSeaCode], [FinancialAccountLocalProgramCodeDescription], [FinancialAccountLocalFundClassificationCode], [FinancialAccountLocalFundClassificationSeaCode], [FinancialAccountLocalFundClassificationDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimLeaFinancialAccountClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimLeaFinancialExpenditureClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimLeaFinancialExpenditureClassifications] WHERE [DimLeaFinancialExpenditureClassificationId] = -1) INSERT INTO [rds].[DimLeaFinancialExpenditureClassifications] ([DimLeaFinancialExpenditureClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialExpenditureLocalFunctionCodeCode], [FinancialExpenditureLocalFunctionCodeSeaCode], [FinancialExpenditureLocalFunctionCodeDescription], [FinancialExpenditureLocalObjectCodeCode], [FinancialExpenditureLocalObjectCodeSeaCode], [FinancialExpenditureLocalObjectCodeDescription], [FinancialExpenditureLocalLevelOfInstructionCodeCode], [FinancialExpenditureLocalLevelOfInstructionCodeSeaCode], [FinancialExpenditureLocalLevelOfInstructionCodeDescription], [FinancialExpenditureProjectReportingCodeCode], [FinancialExpenditureProjectReportingCodeSeaCode], [FinancialExpenditureProjectReportingCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimLeaFinancialExpenditureClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimLeaFinancialRevenueClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimLeaFinancialRevenueClassifications] WHERE [DimLeaFinancialRevenueClassificationId] = -1) INSERT INTO [rds].[DimLeaFinancialRevenueClassifications] ([DimLeaFinancialRevenueClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountLocalRevenueCodeCode], [FinancialAccountLocalRevenueCodeSeaCode], [FinancialAccountLocalRevenueCodeDescription], [FinancialAccountLocalRevenueObjectCodeCode], [FinancialAccountLocalRevenueObjectCodeSeaCode], [FinancialAccountLocalRevenueObjectCodeDescription], [FinancialAccountRevenueObjectCodeCode], [FinancialAccountRevenueObjectCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimLeaFinancialRevenueClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimNaicsCodes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimNaicsCodes] WHERE [DimNaicsCodeId] = -1) INSERT INTO [rds].[DimNaicsCodes] ([DimNaicsCodeId], [NaicsSectorCode], [NaicsSectorDescription], [NaicsSubsectorCode], [NaicsSubsectorDescription], [NaicsIndustryGroupCode], [NaicsIndustryGroupDescription], [NaicsIndustryCode], [NaicsIndustryDescription], [NaicsNationalIndustryCode], [NaicsNationalIndustryDescription], [NaicsVersion]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimNaicsCodes] OFF;
    SET IDENTITY_INSERT [rds].[DimOnetSocOccupationTypes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimOnetSocOccupationTypes] WHERE [DimOnetSocOccupationTypeId] = -1) INSERT INTO [rds].[DimOnetSocOccupationTypes] ([DimOnetSocOccupationTypeId], [OnetSocOccupationTypeCode], [OnetSocOccupationTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimOnetSocOccupationTypes] OFF;
    SET IDENTITY_INSERT [rds].[DimParentOrGuardianIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimParentOrGuardianIndicators] WHERE [DimParentOrGuardianIndicatorId] = -1) INSERT INTO [rds].[DimParentOrGuardianIndicators] ([DimParentOrGuardianIndicatorId], [CustodialParentOrGuardianIndicatorCode], [CustodialParentOrGuardianIndicatorDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimParentOrGuardianIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimPersonAddresses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPersonAddresses] WHERE [DimPersonAddressId] = -1) INSERT INTO [rds].[DimPersonAddresses] ([DimPersonAddressId], [AddressTypeForLearnerOrFamilyCode], [AddressTypeForLearnerOrFamilyDescription], [AddressStreetNumberAndName], [AddressApartmentRoomOrSuiteNumber], [AddressCity], [StateAbbreviationCode], [StateAbbreviationDescription], [AddressPostalCode], [AddressCountyName], [CountryCodeCode], [CountryCodeDescription], [Latitude], [Longitude], [CountyAnsiCodeCode], [CountyAnsiCodeDescription], [DoNotPublishIndicator], [PersonalInformationVerificationCode], [PersonalInformationVerificationDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimPersonAddresses] OFF;
    SET IDENTITY_INSERT [rds].[DimPersonRelationships] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPersonRelationships] WHERE [DimPersonRelationshipId] = -1) INSERT INTO [rds].[DimPersonRelationships] ([DimPersonRelationshipId], [PersonRelationshipTypeCode], [PersonRelationshipTypeDescription], [LivesWithIndicatorCode], [LivesWithIndicatorCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimPersonRelationships] OFF;
    SET IDENTITY_INSERT [rds].[DimPsAcademicAwardTitles] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsAcademicAwardTitles] WHERE [DimPsAcademicAwardTitleId] = -1) INSERT INTO [rds].[DimPsAcademicAwardTitles] ([DimPsAcademicAwardTitleId], [AcademicAwardTitle]) VALUES (-1, 'missing'); SET IDENTITY_INSERT [rds].[DimPsAcademicAwardTitles] OFF;
    SET IDENTITY_INSERT [rds].[DimPsCitizenshipStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsCitizenshipStatuses] WHERE [DimPsCitizenshipStatusId] = -1) INSERT INTO [rds].[DimPsCitizenshipStatuses] ([DimPsCitizenshipStatusId], [UnitedStatesCitizenshipStatusCode], [UnitedStatesCitizenshipStatusDescription], [VisaTypeCode], [VisaTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimPsCitizenshipStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimPsCourseStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsCourseStatuses] WHERE [DimPsCourseStatusId] = -1) INSERT INTO [rds].[DimPsCourseStatuses] ([DimPsCourseStatusId], [CourseLevelTypeCode], [CourseLevelTypeDescription], [CourseHonorsTypeCode], [CourseHonorsTypeDescription], [CourseCreditBasisTypeCode], [CourseCreditBasisTypeDescription], [CourseCreditLevelTypeCode], [CourseCreditLevelTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimPsCourseStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimPsFamilyStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsFamilyStatuses] WHERE [DimPsFamilyStatusId] = -1) INSERT INTO [rds].[DimPsFamilyStatuses] ([DimPsFamilyStatusId], [DependencyStatusCode], [DependencyStatusDescription], [NumberOfDependentsTypeCode], [NumberOfDependentsTypeDescription], [SingleParentOrSinglePregnantWomanStatusCode], [SingleParentOrSinglePregnantWomanStatusDescription], [MaternalGuardianEducationCode], [MaternalGuardianEducationDescription], [PaternalGuardianEducationCode], [PaternalGuardianEducationDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimPsFamilyStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimRecordStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimRecordStatuses] WHERE [DimRecordStatusId] = -1) INSERT INTO [rds].[DimRecordStatuses] ([DimRecordStatusId], [RecordStatusTypeCode], [RecordStatusTypeDescription], [RecordStatusCreatorEntityCode], [RecordStatusCreatorEntityDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimRecordStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimResponsibleOrganizationTypes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimResponsibleOrganizationTypes] WHERE [DimResponsibleOrganizationTypeId] = -1) INSERT INTO [rds].[DimResponsibleOrganizationTypes] ([DimResponsibleOrganizationTypeId], [ResponsibleDistrictTypeCode], [ResponsibleDistrictTypeDescription], [ResponsibleSchoolTypeCode], [ResponsibleSchoolTypeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimResponsibleOrganizationTypes] OFF;
    SET IDENTITY_INSERT [rds].[DimSalaryScheduleCriteria] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSalaryScheduleCriteria] WHERE [DimSalaryScheduleCriteriaId] = -1) INSERT INTO [rds].[DimSalaryScheduleCriteria] ([DimSalaryScheduleCriteriaId], [SalaryScheduleCriterionName], [SalaryScheduleCriterionDescription], [SalaryScheduleCriterionValue]) VALUES (-1, 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSalaryScheduleCriteria] OFF;
    SET IDENTITY_INSERT [rds].[DimSchoolPerformanceIndicatorStateDefinedStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSchoolPerformanceIndicatorStateDefinedStatuses] WHERE [DimSchoolPerformanceIndicatorStateDefinedStatusId] = -1) INSERT INTO [rds].[DimSchoolPerformanceIndicatorStateDefinedStatuses] ([DimSchoolPerformanceIndicatorStateDefinedStatusId], [SchoolPerformanceIndicatorStateDefinedStatusCode], [SchoolPerformanceIndicatorStateDefinedStatusDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSchoolPerformanceIndicatorStateDefinedStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimSchoolQualityOrStudentSuccessIndicators] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSchoolQualityOrStudentSuccessIndicators] WHERE [DimSchoolQualityOrStudentSuccessIndicatorId] = -1) INSERT INTO [rds].[DimSchoolQualityOrStudentSuccessIndicators] ([DimSchoolQualityOrStudentSuccessIndicatorId], [SchoolQualityOrStudentSuccessIndicatorTypeCode], [SchoolQualityOrStudentSuccessIndicatorTypeDescription], [SchoolQualityOrStudentSuccessIndicatorTypeEdFactsCode]) VALUES (-1, 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSchoolQualityOrStudentSuccessIndicators] OFF;
    SET IDENTITY_INSERT [rds].[DimSeaFinancialAccountBalances] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSeaFinancialAccountBalances] WHERE [DimSeaFinancialAccountBalanceId] = -1) INSERT INTO [rds].[DimSeaFinancialAccountBalances] ([DimSeaFinancialAccountBalanceId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountLocalBalanceSheetCodeCode], [FinancialAccountLocalBalanceSheetCodeFederalCode], [FinancialAccountLocalBalanceSheetCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSeaFinancialAccountBalances] OFF;
    SET IDENTITY_INSERT [rds].[DimSeaFinancialAccountClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSeaFinancialAccountClassifications] WHERE [DimSeaFinancialAccountClassificationId] = -1) INSERT INTO [rds].[DimSeaFinancialAccountClassifications] ([DimSeaFinancialAccountClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountCategoryCode], [FinancialAccountCategoryFederalCode], [FinancialAccountCategoryDescription], [FinancialAccountLocalProgramCodeCode], [FinancialAccountLocalProgramCodeFederalCode], [FinancialAccountLocalProgramCodeDescription], [FinancialAccountLocalFundClassificationCode], [FinancialAccountLocalFundClassificationFederalCode], [FinancialAccountLocalFundClassificationDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSeaFinancialAccountClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimSeaFinancialExpenditureClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSeaFinancialExpenditureClassifications] WHERE [DimSeaFinancialExpenditureClassificationId] = -1) INSERT INTO [rds].[DimSeaFinancialExpenditureClassifications] ([DimSeaFinancialExpenditureClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialExpenditureLocalFunctionCodeCode], [FinancialExpenditureLocalFunctionCodeFederalCode], [FinancialExpenditureLocalFunctionCodeDescription], [FinancialExpenditureLocalObjectCodeCode], [FinancialExpenditureLocalObjectCodeFederalCode], [FinancialExpenditureLocalObjectCodeDescription], [FinancialExpenditureLocalLevelOfInstructionCodeCode], [FinancialExpenditureLocalLevelOfInstructionCodeFederalCode], [FinancialExpenditureLocalLevelOfInstructionCodeDescription], [FinancialExpenditureProjectReportingCodeCode], [FinancialExpenditureProjectReportingCodeFederalCode], [FinancialExpenditureProjectReportingCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSeaFinancialExpenditureClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimSeaFinancialRevenueClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSeaFinancialRevenueClassifications] WHERE [DimSeaFinancialRevenueClassificationId] = -1) INSERT INTO [rds].[DimSeaFinancialRevenueClassifications] ([DimSeaFinancialRevenueClassificationId], [FinancialAccountCodingSystemOrganizationTypeCode], [FinancialAccountCodingSystemOrganizationTypeDescription], [FinancialAccountLocalRevenueCodeCode], [FinancialAccountLocalRevenueCodeFederalCode], [FinancialAccountLocalRevenueCodeDescription], [FinancialAccountLocalRevenueObjectCodeCode], [FinancialAccountLocalRevenueObjectCodeSeaCode], [FinancialAccountLocalRevenueObjectCodeDescription]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimSeaFinancialRevenueClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimStaffCompensationTypes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimStaffCompensationTypes] WHERE [DimStaffCompensationTypeId] = -1) INSERT INTO [rds].[DimStaffCompensationTypes] ([DimStaffCompensationTypeId], [StaffCompensationTypeCode], [StaffCompensationTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimStaffCompensationTypes] OFF;
    SET IDENTITY_INSERT [rds].[DimStaffEvaluationPartStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimStaffEvaluationPartStatuses] WHERE [DimStaffEvaluationPartStatusId] = -1) INSERT INTO [rds].[DimStaffEvaluationPartStatuses] ([DimStaffEvaluationPartStatusId], [StaffEvaluationSystem], [FacultyAndAdministrationPerformanceLevelCode], [FacultyAndAdministrationPerformanceLevelDescription], [TechnologySkillsStandardsMetCode], [TechnologySkillsStandardsMetDescription], [StaffEvaluationPartName]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimStaffEvaluationPartStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimStandardOccupationalClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimStandardOccupationalClassifications] WHERE [DimStandardOccupationalClassificationId] = -1) INSERT INTO [rds].[DimStandardOccupationalClassifications] ([DimStandardOccupationalClassificationId], [StandardOccupationalClassificationCode], [StandardOccupationalClassificationDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimStandardOccupationalClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimStudentSupportServiceTypes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimStudentSupportServiceTypes] WHERE [DimStudentSupportServiceTypeId] = -1) INSERT INTO [rds].[DimStudentSupportServiceTypes] ([DimStudentSupportServiceTypeId], [StudentSupportServiceTypeCode], [StudentSupportServiceTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimStudentSupportServiceTypes] OFF;
    SET IDENTITY_INSERT [rds].[DimWeapons] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimWeapons] WHERE [DimWeaponId] = -1) INSERT INTO [rds].[DimWeapons] ([DimWeaponId], [WeaponTypeCode], [WeaponTypeDescription], [WeaponTypeEdFactsCode]) VALUES (-1, 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimWeapons] OFF;
    SET IDENTITY_INSERT [rds].[DimWorkBasedLearningStatuses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimWorkBasedLearningStatuses] WHERE [DimWorkBasedLearningStatusId] = -1) INSERT INTO [rds].[DimWorkBasedLearningStatuses] ([DimWorkBasedLearningStatusId], [WorkBasedLearningOpportunityTypeCode], [WorkBasedLearningOpportunityTypeDescription]) VALUES (-1, 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimWorkBasedLearningStatuses] OFF;
    SET IDENTITY_INSERT [rds].[DimContacts] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimContacts] WHERE [DimContactId] = -1) INSERT INTO [rds].[DimContacts] ([DimContactId], [PersonalTitleOrPrefix], [FirstName], [MiddleName], [LastOrSurname], [GenerationCodeOrSuffix], [PrimaryTelephoneNumberIndicator], [PositionTitle], [ElectronicMailAddressWork], [TelephoneNumberWork]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 0, 'missing', 'missing', 'missing'); SET IDENTITY_INSERT [rds].[DimContacts] OFF;
    SET IDENTITY_INSERT [rds].[DimAccessibleEducationMaterialProviders] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAccessibleEducationMaterialProviders] WHERE [DimAccessibleEducationMaterialProviderId] = -1) INSERT INTO [rds].[DimAccessibleEducationMaterialProviders] ([DimAccessibleEducationMaterialProviderId], [AccessibleEducationMaterialProviderOrganizationIdentifierSea], [AccessibleEducationMaterialProviderName], [StateAbbreviationCode], [StateAbbreviationDescription], [StateANSICode], [MailingAddressStreetNumberAndName], [MailingAddressApartmentRoomOrSuiteNumber], [MailingAddressCity], [MailingAddressPostalCode], [MailingAddressStateAbbreviation], [MailingAddressCountyAnsiCodeCode], [PhysicalAddressStreetNumberAndName], [PhysicalAddressApartmentRoomOrSuiteNumber], [PhysicalAddressCity], [PhysicalAddressPostalCode], [PhysicalAddressStateAbbreviation], [PhysicalAddressCountyAnsiCodeCode], [TelephoneNumber], [WebSiteAddress], [OutOfStateIndicator], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, 'missing', 'missing', '', 'missing', '', 'missing', 'missing', 'missing', 'missing', '', '', 'missing', 'missing', 'missing', 'missing', '', '', 'missing', 'missing', '', '', ''); SET IDENTITY_INSERT [rds].[DimAccessibleEducationMaterialProviders] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProgramYears] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProgramYears] WHERE [DimAeProgramYearId] = -1) INSERT INTO [rds].[DimAeProgramYears] ([DimAeProgramYearId], [AeProgramYear], [SessionBeginDate], [SessionEndDate]) VALUES (-1, '', '', ''); SET IDENTITY_INSERT [rds].[DimAeProgramYears] OFF;
    SET IDENTITY_INSERT [rds].[DimAeProviders] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimAeProviders] WHERE [DimAeProviderId] = -1) INSERT INTO [rds].[DimAeProviders] ([DimAeProviderId], [AdultEducationServiceProviderIdentifierSea], [NameOfInstitution], [ShortNameOfInstitution], [AdultEducationProviderTypeCode], [AdultEducationProviderTypeDescription], [LevelOfInstitutionCode], [LevelOfInstitutionDescription], [OrganizationOperationalStatusCode], [OrganizationOperationalStatusDescription], [OperationalStatusEffectiveDate], [TelephoneNumber], [WebSiteAddress], [MailingAddressStreetNumberAndName], [MailingAddressApartmentRoomOrSuiteNumber], [MailingAddressCity], [MailingAddressStateAbbreviation], [MailingAddressPostalCode], [MailingAddressCountyAnsiCodeCode], [PhysicalAddressStreetNumberAndName], [PhysicalAddressApartmentRoomOrSuiteNumber], [PhysicalAddressCity], [PhysicalAddressStateAbbreviation], [PhysicalAddressPostalCode], [PhysicalAddressCountyAnsiCodeCode], [Latitude], [Longitude], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', '', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', 'missing', '', ''); SET IDENTITY_INSERT [rds].[DimAeProviders] OFF;
    SET IDENTITY_INSERT [rds].[DimCalendarCrises] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCalendarCrises] WHERE [DimCalendarCrisisId] = -1) INSERT INTO [rds].[DimCalendarCrises] ([DimCalendarCrisisId], [CrisisCode], [CrisisName], [CrisisDescription], [CrisisStartDate], [CrisisEndDate], [CrisisType], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimCalendarCrises] OFF;
    SET IDENTITY_INSERT [rds].[DimCalendarEventDays] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCalendarEventDays] WHERE [DimCalendarEventDayId] = -1) INSERT INTO [rds].[DimCalendarEventDays] ([DimCalendarEventDayId], [CalendarEventDayName], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', ''); SET IDENTITY_INSERT [rds].[DimCalendarEventDays] OFF;
    SET IDENTITY_INSERT [rds].[DimCalendarSessions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCalendarSessions] WHERE [DimCalendarSessionId] = -1) INSERT INTO [rds].[DimCalendarSessions] ([DimCalendarSessionId], [CalendarCode], [CalendarDescription], [SessionBeginDate], [SessionEndDate], [SessionCode], [SessionDescription], [SessionSequenceNumber], [FirstInstructionDate], [LastInstructionDate], [DaysInSession], [SchoolYearMinutes], [InstructionalMinutes], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimCalendarSessions] OFF;
    SET IDENTITY_INSERT [rds].[DimCredentialAwards] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCredentialAwards] WHERE [DimCredentialAwardId] = -1) INSERT INTO [rds].[DimCredentialAwards] ([DimCredentialAwardId], [ProfessionalCertificateOrLicenseNumber], [CredentialAdvancedStandingDescription], [CredentialAdvancedStandingURL], [CredentialEvidenceStatement], [CredentialRevokedReason], [CredentialAwardStartDate], [CredentialAwardEndDate], [CredentialCompletionDate], [CredentialRevokedDate], [CredentialSuspensionStartDate], [CredentialSuspensionEndDate]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimCredentialAwards] OFF;
    SET IDENTITY_INSERT [rds].[DimCredentialDefinitions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCredentialDefinitions] WHERE [DimCredentialDefinitionId] = -1) INSERT INTO [rds].[DimCredentialDefinitions] ([DimCredentialDefinitionId], [CredentialDefinitionIdentifierCtid], [CredentialDefinitionIdentifierUri], [CredentialDefinitionIdentifierUrl], [CredentialDefinitionIdentifierUrn], [CredentialDefinitionIdentifierUuid], [CredentialDefinitionIdentifierArk], [CredentialDefinitionIdentifierDoi], [CredentialDefinitionIdentifierInfo], [CredentialDefinitionTitle], [CredentialDefinitionDescription], [CredentialTypeCode], [CredentialTypeDescription], [CredentialDefinitionCategorySystem], [CredentialDefinitionCategoryType], [CredentialDefinitionStatusTypeCode], [CredentialDefinitionStatusTypeDescription], [CredentialDefinitionIntendedPurposeTypeCode], [CredentialDefinitionIntendedPurposeTypeDescription], [CredentialDefinitionAssessmentMethodTypeCode], [CredentialDefinitionAssessmentMethodTypeDescription], [CredentialDefinitionCriteria], [CredentialDefinitionCriteriaURL], [CredentialDefinitionKeywords], [CredentialDefinitionValidationMethodDescription], [CredentialImageURL], [CredentialDefinitionDateEffective], [CredentialOfferedStartDate], [CredentialOfferedEndDate], [CoreAcademicCourseCode], [CoreAcademicCourseDescription], [CTDLAudienceLevelTypeCode], [CTDLAudienceLevelTypeDescription], [CredentialDefinitionTerminalDegreeIndicatorCode], [CredentialDefinitionTerminalDegreeIndicatorDescription], [CredentialDefinitionScedCode], [CredentialDefinitionLowGradeLevelCode], [CredentialDefinitionHighGradeLevelCode]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimCredentialDefinitions] OFF;
    SET IDENTITY_INSERT [rds].[DimEmployers] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEmployers] WHERE [DimEmployerId] = -1) INSERT INTO [rds].[DimEmployers] ([DimEmployerId], [EmployerOrganizationName], [EmployerOrganizationIdentifierSea], [SeaOrganizationName], [SeaOrganizationIdentifierSea], [StateAnsiCode], [StateAbbreviationCode], [StateAbbreviationDescription], [MailingAddressStreetNumberAndName], [MailingAddressApartmentRoomOrSuiteNumber], [MailingAddressCity], [MailingAddressStateAbbreviation], [MailingAddressPostalCode], [MailingAddressCountyAnsiCodeCode], [OutOfStateIndicator], [OrganizationOperationalStatus], [OperationalStatusEffectiveDate], [PhysicalAddressStreetNumberAndName], [PhysicalAddressApartmentRoomOrSuiteNumber], [PhysicalAddressCity], [PhysicalAddressPostalCode], [PhysicalAddressStateAbbreviation], [PhysicalAddressCountyAnsiCodeCode], [TelephoneNumber], [WebSiteAddress], [OrganizationRegionGeoJson], [Latitude], [Longitude], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimEmployers] OFF;
    SET IDENTITY_INSERT [rds].[DimCredentialIssuers] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimCredentialIssuers] WHERE [DimCredentialIssuerId] = -1) INSERT INTO [rds].[DimCredentialIssuers] ([DimCredentialIssuerId], [CredentialIssuerOrganizationName], [CredentialIssuerOrganizationIdentifierSea], [SeaOrganizationName], [SeaOrganizationIdentifierSea], [CTDLOrganizationTypeCode], [CTDLOrganizationTypeDescription], [StateAnsiCode], [StateAbbreviationCode], [StateAbbreviationDescription], [MailingAddressStreetNumberAndName], [MailingAddressApartmentRoomOrSuiteNumber], [MailingAddressCity], [MailingAddressStateAbbreviation], [MailingAddressPostalCode], [MailingAddressCountyAnsiCodeCode], [OutOfStateIndicator], [OrganizationOperationalStatus], [OperationalStatusEffectiveDate], [PhysicalAddressStreetNumberAndName], [PhysicalAddressApartmentRoomOrSuiteNumber], [PhysicalAddressCity], [PhysicalAddressPostalCode], [PhysicalAddressStateAbbreviation], [PhysicalAddressCountyAnsiCodeCode], [StateIssuingProfessionalCredentialOrLicenseCode], [StateIssuingProfessionalCredentialOrLicenseDescription], [TelephoneNumber], [WebSiteAddress], [OrganizationRegionGeoJson], [Latitude], [Longitude], [ProgramSponosorTypeCode], [ProgramSponosorTypeDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimCredentialIssuers] OFF;
    SET IDENTITY_INSERT [rds].[DimEarlyLearningOrganizations] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEarlyLearningOrganizations] WHERE [DimEarlyLearningOrganizationId] = -1) INSERT INTO [rds].[DimEarlyLearningOrganizations] ([DimEarlyLearningOrganizationId], [StateLicensedFacilityCapacity]) VALUES (-1, ''); SET IDENTITY_INSERT [rds].[DimEarlyLearningOrganizations] OFF;
    SET IDENTITY_INSERT [rds].[DimEducationOrganizationNetworks] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimEducationOrganizationNetworks] WHERE [DimEducationOrganizationNetworkId] = -1) INSERT INTO [rds].[DimEducationOrganizationNetworks] ([DimEducationOrganizationNetworkId], [OrganizationIdentifierSea], [OrganizationTypeCode], [OrganizationTypeDescription], [OrganizationName], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimEducationOrganizationNetworks] OFF;
    SET IDENTITY_INSERT [rds].[DimFacilities] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFacilities] WHERE [DimFacilityId] = -1) INSERT INTO [rds].[DimFacilities] ([DimFacilityId], [FacilitiesIdentifier], [FacilityBuildingName], [BuilidingSiteNumber], [BuildingArea], [TemperatureControlledBuildingArea], [BuildingNumberOfStories], [BuildingYearBuilt], [BuildingYearOfLastModernization], [FacilityBlockNumberArea], [FacilityCensusTract], [FacilityConstructionDate], [FacilityConstructionDateTypeCode], [FacilityConstructionDateTypeDescription], [FacilityConstructionYear], [FacilityExpectedLife], [FacilitySiteArea], [FacilitySiteIdentifier]) VALUES (-1, '', '', '', '', '', 0, 0, 0, '', '', '', '', '', 0, 0, 0, ''); SET IDENTITY_INSERT [rds].[DimFacilities] OFF;
    SET IDENTITY_INSERT [rds].[DimFinancialAccounts] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFinancialAccounts] WHERE [DimFinancialAccountId] = -1) INSERT INTO [rds].[DimFinancialAccounts] ([DimFinancialAccountId], [FinancialAccountNumber], [FinancialAccountName], [FinancialAccountDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimFinancialAccounts] OFF;
    SET IDENTITY_INSERT [rds].[DimFiscalPeriods] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFiscalPeriods] WHERE [DimFiscalPeriodId] = -1) INSERT INTO [rds].[DimFiscalPeriods] ([DimFiscalPeriodId], [FiscalPeriodBeginDate], [FiscalPeriodEndDate]) VALUES (-1, '', ''); SET IDENTITY_INSERT [rds].[DimFiscalPeriods] OFF;
    SET IDENTITY_INSERT [rds].[DimFiscalYears] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimFiscalYears] WHERE [DimFiscalYearId] = -1) INSERT INTO [rds].[DimFiscalYears] ([DimFiscalYearId], [FiscalPeriodBeginDate], [FiscalPeriodEndDate], [FiscalYear]) VALUES (-1, '', '', ''); SET IDENTITY_INSERT [rds].[DimFiscalYears] OFF;
    SET IDENTITY_INSERT [rds].[DimK12JobPositions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimK12JobPositions] WHERE [DimK12JobPositionId] = -1) INSERT INTO [rds].[DimK12JobPositions] ([DimK12JobPositionId], [JobPositionIdentifierSea], [JobPositionIdentifierLea], [JobPositionIdentifierSchool], [PositionTitle], [HourlyWage], [StaffCompensationBaseSalary]) VALUES (-1, '', '', '', '', 0, 0); SET IDENTITY_INSERT [rds].[DimK12JobPositions] OFF;
    SET IDENTITY_INSERT [rds].[DimLeaJobClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimLeaJobClassifications] WHERE [DimLeaJobClassificationId] = -1) INSERT INTO [rds].[DimLeaJobClassifications] ([DimLeaJobClassificationId], [LeaIdentifierSea], [CodingSystemOranizationTypeCode], [CodingSystemOrganizationTypeDescription], [EducationJobTypeCode], [EducationJobTypeDescription], [LocalJobFunctionCode], [LocalJobFunctionDescription], [LocalJobFunctionDefinition], [LocalJobCategoryCode], [LocalJobCategoryDescription], [LocalJobCategoryDefinition], [K12StaffClassificationCode], [K12StaffClassificationDescription], [TitleIProgramStaffCategoryCode], [TitleIProgramStaffCategoryDescription], [MigrantEducationProgramStaffCategoryCode], [MigrantEducationProgramStaffCategoryDescription], [SpecialEducationSupportServicesCategoryCode], [SpecialEducationSupportServicesCategoryDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimLeaJobClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimOrganizationAddresses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimOrganizationAddresses] WHERE [DimOrganizationAddressId] = -1) INSERT INTO [rds].[DimOrganizationAddresses] ([DimOrganizationAddressId], [AddressStreetNumberAndName], [AddressApartmentRoomOrSuiteNumber], [BuildingSiteNumber], [AddressCity], [AddressStateAbbreviation], [AddressPostalCode], [CountyAnsiCodeCode], [AddressCountyName], [Latitude], [Longitude], [AddressTypeForOrganizationCode], [AddressTypeForOrganizationDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimOrganizationAddresses] OFF;
    SET IDENTITY_INSERT [rds].[DimOrganizationCalendarSessions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimOrganizationCalendarSessions] WHERE [DimOrganizationCalendarSessionId] = -1) INSERT INTO [rds].[DimOrganizationCalendarSessions] ([DimOrganizationCalendarSessionId], [SessionBeginDate], [SessionEndDate], [SessionCode], [SessionDescription], [AcademicTermDesignatorCode], [AcademicTermDesignatorDescription]) VALUES (-1, '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimOrganizationCalendarSessions] OFF;
    SET IDENTITY_INSERT [rds].[DimOrganizations] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimOrganizations] WHERE [DimOrganizationId] = -1) INSERT INTO [rds].[DimOrganizations] ([DimOrganizationId], [OrganizationName], [ShortNameOfOrganization], [OrganizationIdentifierSea], [OrganizationIdentifierDuns], [OrganizationIdentifierFein], [OrganizationTypeCode], [OrganizationTypeDescription], [OrganizationOperationalStatusCode], [OrganizationOperationalStatusDescription], [OperationalStatusEffectiveDate], [StateAnsiCode], [StateAbbreviationCode], [StateAbbreviationDescription], [TelephoneNumberMain], [TelephoneNumberFax], [ElectronicMailAddress], [WebSiteAddress], [OutOfStateIndicator], [OrganizationRegionGeoJson], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimOrganizations] OFF;
    SET IDENTITY_INSERT [rds].[DimPersonRelationshipToLearnerContactInformation] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPersonRelationshipToLearnerContactInformation] WHERE [DimPersonRelationshipToLearnerContactInformationId] = -1) INSERT INTO [rds].[DimPersonRelationshipToLearnerContactInformation] ([DimPersonRelationshipToLearnerContactInformationId], [PersonRelationshipToLearnerContactPriorityNumber], [PersonRelationshipToLearnerContactRestrictionsDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', ''); SET IDENTITY_INSERT [rds].[DimPersonRelationshipToLearnerContactInformation] OFF;
    SET IDENTITY_INSERT [rds].[DimProfessionalDevelopmentActivities] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimProfessionalDevelopmentActivities] WHERE [DimProfessionalDevelopmentActivityId] = -1) INSERT INTO [rds].[DimProfessionalDevelopmentActivities] ([DimProfessionalDevelopmentActivityId], [ProfessionalDevelopmentActivityIdentifier], [ProfessionalDevelopmentActivityTitle], [SponsoringAgencyName], [ProfessionalDevelopmentActivityTypeCode], [ProfessionalDevelopmentActivityTypeDescription], [ProfessionalDevelopmentActivityDescription], [ProfessionalDevelopmentActivityEducationLevelsAddressedCode], [ProfessionalDevelopmentActivityEducationLevelsAddressedDescription], [ProfessionalDevelopmentActivityObjective], [ProfessionalDevelopmentActivityLevelCode], [ProfessionalDevelopmentActivityLevelDescription], [ProfessionalDevelopmentActivityCreditTypeCode], [ProfessionalDevelopmentActivityCreditTypeDescription], [ProfessionalDevelopmentActivityTargetAudienceCode], [ProfessionalDevelopmentActivityTargetAudienceDescription], [ProfessionalDevelopmentSessionLanguageCode], [ProfessionalDevelopmentSessionLanguageDescription], [ProfessionalDevelopmentActivityExpirationDate], [ProfessionalDevelopmentActivityApprovedPurposeCode], [ProfessionalDevelopmentActivityApprovedPurposeDescription], [ProfessionalDevelopmentActivityApprovalCode], [ProfessionalDevelopmentActivityCode], [ProfessionalDevelopmentActivityCost]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0); SET IDENTITY_INSERT [rds].[DimProfessionalDevelopmentActivities] OFF;
    SET IDENTITY_INSERT [rds].[DimProgramYears] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimProgramYears] WHERE [DimProgramYearId] = -1) INSERT INTO [rds].[DimProgramYears] ([DimProgramYearId], [ProgramYear], [SessionBeginDate], [SessionEndDate]) VALUES (-1, '', '', ''); SET IDENTITY_INSERT [rds].[DimProgramYears] OFF;
    SET IDENTITY_INSERT [rds].[DimPsCourses] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsCourses] WHERE [DimPsCourseId] = -1) INSERT INTO [rds].[DimPsCourses] ([DimPsCourseId], [CourseIdentifier], [CourseCodeSystemCode], [CourseCodeSystemDescription], [CourseSubjectAbbreviation], [CourseNumber], [CourseTitle], [CourseDescription], [CourseDepartmentName], [CourseCreditUnitsCode], [CourseCreditUnitsDescription], [CreditValue], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', 0, '', ''); SET IDENTITY_INSERT [rds].[DimPsCourses] OFF;
    SET IDENTITY_INSERT [rds].[DimPsInstitutions] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimPsInstitutions] WHERE [DimPsInstitutionId] = -1) INSERT INTO [rds].[DimPsInstitutions] ([DimPsInstitutionId], [NameOfInstitution], [ShortNameOfInstitution], [IPEDSIdentifier], [Opeid], [OrganizationOperationalStatus], [OperationalStatusEffectiveDate], [MostPrevalentLevelOfInstitutionCode], [MailingAddressStreetNumberAndName], [MailingAddressApartmentRoomOrSuiteNumber], [MailingAddressCity], [MailingAddressPostalCode], [MailingAddressStateAbbreviation], [PhysicalAddressStreetNumberAndName], [PhysicalAddressApartmentRoomOrSuiteNumber], [PhysicalAddressCity], [PhysicalAddressPostalCode], [PhysicalAddressStateAbbreviation], [TelephoneNumber], [WebSiteAddress], [Latitude], [Longitude], [RecordStartDateTime], [RecordEndDateTime], [MailingAddressCountyAnsiCodeCode], [PhysicalAddressCountyAnsiCodeCode]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimPsInstitutions] OFF;
    SET IDENTITY_INSERT [rds].[DimSeaJobClassifications] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimSeaJobClassifications] WHERE [DimSeaJobClassificationId] = -1) INSERT INTO [rds].[DimSeaJobClassifications] ([DimSeaJobClassificationId], [CodingSystemOrganizationTypeCode], [CodingSystemOrganizationTypeDescription], [EducationJobTypeCode], [EducationJobTypeDescription], [LocalJobFunctionCode], [LocalJobFunctionDescription], [LocalJobFunctionDefinition], [LocalJobCategoryCode], [LocalJobCategoryDescription], [LocalJobCategoryDefinition], [K12StaffClassificationCode], [K12StaffClassificationDescription], [TitleIProgramStaffCategoryCode], [TitleIProgramStaffCategoryDescription], [MigrantEducationProgramStaffCategoryCode], [MigrantEducationProgramStaffCategoryDescription], [SpecialEducationSupportServicesCategoryCode], [SpecialEducationSupportServicesCategoryDescription], [RecordStartDateTime], [RecordEndDateTime]) VALUES (-1, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''); SET IDENTITY_INSERT [rds].[DimSeaJobClassifications] OFF;
    SET IDENTITY_INSERT [rds].[DimTimes] ON; IF NOT EXISTS (SELECT 1 FROM [rds].[DimTimes] WHERE [DimTimeId] = -1) INSERT INTO [rds].[DimTimes] ([DimTimeId], [TimeTime], [TimeHour], [TimeMinute]) VALUES (-1, '', '', ''); SET IDENTITY_INSERT [rds].[DimTimes] OFF;

    IF (select count(*) from rds.DimIeus where DimIeuId = -1) = 0
    BEGIN

        SET IDENTITY_INSERT rds.DimIeus ON;

        insert into rds.DimIeus(
            DimIeuId
            ,[IeuOrganizationName]
            ,[IeuOrganizationIdentifierSea]
            ,[SeaOrganizationName]
            ,[SeaOrganizationIdentifierSea]
            ,[StateAnsiCode]
            ,[StateAbbreviationCode]
            ,[StateAbbreviationDescription]
            ,[MailingAddressStreetNumberAndName]
            ,[MailingAddressApartmentRoomOrSuiteNumber]
            ,[MailingAddressCity]
            ,[MailingAddressStateAbbreviation]
            ,[MailingAddressPostalCode]
            ,[MailingAddressCountyAnsiCodeCode]
            ,[MailingAddressCountyName]
            ,[OutOfStateIndicator]
            ,[OrganizationOperationalStatus]
            ,[OperationalStatusEffectiveDate]
            ,[PhysicalAddressStreetNumberAndName]
            ,[PhysicalAddressApartmentRoomOrSuiteNumber]
            ,[PhysicalAddressCity]
            ,[PhysicalAddressPostalCode]
            ,[PhysicalAddressStateAbbreviation]
            ,[PhysicalAddressCountyAnsiCodeCode]
            ,[PhysicalAddressCountyName]
            ,[TelephoneNumber]
            ,[WebSiteAddress]
            ,[OrganizationRegionGeoJson]
            ,[Latitude]
            ,[Longitude]
            ,[RecordStartDateTime]
            ,[RecordEndDateTime]
        )
        values (-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL
        ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2024-07-01',NULL)			

        SET IDENTITY_INSERT rds.DimIeus OFF;

	END

    IF (SELECT COUNT(*) FROM rds.DimPeople_Current WHERE DimPersonId = -1) = 0
    BEGIN

        set identity_insert rds.DimPeople_Current ON;

        insert into rds.DimPeople_Current (
            [DimPersonId]
            ,[FirstName]
            ,[MiddleName]
            ,[LastOrSurname]
            ,[Birthdate]
            ,[ELChildChildIdentifierState]
            ,[K12StudentStudentIdentifierState]
            ,[K12StudentStudentIdentifierDistrict]
            ,[K12StudentStudentIdentifierNationalMigrant]
            ,[PsStudentStudentIdentifierState]
            ,[AeStudentStudentIdentifierState]
            ,[WorkforceProgramParticipantPersonIdentifierState]
            ,[ELStaffStaffMemberIdentifierState]
            ,[K12StaffStaffMemberIdentifierState]
            ,[K12StaffStaffMemberIdentifierDistrict]
            ,[PsStaffStaffMemberIdentifierState]
            ,[PersonIdentifierDriversLicense]
            ,[PersonIdentifierSSN]
            ,[PersonIdentifierState]
            ,[StudentIdentifierState]
            ,[IsActiveELChild]
            ,[IsActiveK12Student]
            ,[IsActivePsStudent]
            ,[IsActiveAeStudent]
            ,[IsActiveWorkforceProgramParticipant]
            ,[IsActiveELStaff]
            ,[IsActiveK12Staff]
            ,[IsActivePsStaff]
            ,[ElectronicMailAddressHome]
            ,[ElectronicMailAddressOrganizational]
            ,[ElectronicMailAddressWork]
            ,[TelephoneNumberFax]
            ,[TelephoneNumberHome]
            ,[TelephoneNumberMobile]
            ,[TelephoneNumberWork]
            ,[PersonalTitleOrPrefix]
            ,[PositionTitle]
            ,[GenerationCodeOrSuffix]
            ,[HighestLevelOfEducationCompletedCode]
            ,[HighestLevelOfEducationCompletedDescription]
        )
        values
        (-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
        ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
        ,NULL,NULL)
        
        set identity_insert rds.DimPeople_Current OFF;

	END

    IF (SELECT COUNT(*) FROM rds.DimAssessmentSubtests WHERE DimAssessmentSubtestId = -1) = 0
    BEGIN

        set identity_insert RDS.DimAssessmentSubtests ON;

        insert into RDS.DimAssessmentSubtests (
            [DimAssessmentSubtestId]
            ,[AssessmentFormNumber]
            ,[AssessmentAcademicSubjectCode]
            ,[AssessmentAcademicSubjectDescription]
            ,[AssessmentSubtestIdentifierInternal]
            ,[AssessmentSubtestTitle]
            ,[AssessmentSubtestAbbreviation]
            ,[AssessmentSubtestDescription]
            ,[AssessmentSubtestVersion]
            ,[AssessmentLevelForWhichDesigned]
            ,[AssessmentEarlyLearningDevelopmentalDomain]
            ,[AssessmentSubtestPublishedDate]
            ,[AssessmentSubtestMinimumValue]
            ,[AssessmentSubtestMaximumValue]
            ,[AssessmentSubtestScaleOptimalValue]
            ,[AssessmentContentStandardType]
            ,[AssessmentPurpose]
            ,[AssessmentSubtestRules]
            ,[AssessmentFormSubtestTier]
            ,[AssessmentFormSubtestContainerOnly]
        )
        values (-1, NULL,-1,-1,-1,-1,-1,-1,-1,-1,-1,NULL,-1,-1,-1,-1,-1,-1,-1,-1)

        set identity_insert RDS.DimAssessmentSubtests OFF;

    END

    IF (SELECT COUNT(*) FROM rds.DimCompetencyDefinitions WHERE DimCompetencyDefinitionId = -1) = 0
    BEGIN

        set identity_insert RDS.DimCompetencyDefinitions ON;

        insert into RDS.DimCompetencyDefinitions (
            [DimCompetencyDefinitionId]
            ,[CompetencyDefinitionIdentifier]
            ,[CompetencyDefinitionCode]
            ,[CompetencyDefinitionShortName]
            ,[CompetencyDefinitionStatement]
            ,[CompetencyDefinitionType]
            ,[CompetencyDefinitionValidStartDate]
            ,[CompetencyDefinitionValidEndDate]
        )
        values (-1,NULL,NULL,NULL,NULL,NULL,-1,NULL) 

        set identity_insert RDS.DimCompetencyDefinitions OFF;

    END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimPsEnrollmentStatuses WHERE DimPsEnrollmentStatusId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses ON

		INSERT INTO [RDS].[DimPsEnrollmentStatuses]
           (DimPsEnrollmentStatusId
           ,[PostsecondaryExitOrWithdrawalTypeCode]
           ,[PostsecondaryExitOrWithdrawalTypeDescription]
           ,[PostsecondaryEnrollmentStatusCode]
           ,[PostsecondaryEnrollmentStatusDescription]
           ,[PostSecondaryEnrollmentStatusEdFactsCode]
           ,[PostSecondaryEnrollmentActionCode]
           ,[PostSecondaryEnrollmentActionDescription]
           ,[PostSecondaryEnrollmentActionEdFactsCode])
		VALUES (
			-1
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
	)

		SET IDENTITY_INSERT RDS.DimPsEnrollmentStatuses OFF
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentStatuses WHERE DimAssessmentStatusId = -1) BEGIN
		SET IDENTITY_INSERT RDS.DimAssessmentStatuses ON

		INSERT INTO [RDS].DimAssessmentStatuses (
			[DimAssessmentStatusId]
			, [ProgressLevelCode]
			, [ProgressLevelDescription]
			, [ProgressLevelEdFactsCode]
			, [AssessedFirstTimeCode]
			, [AssessedFirstTimeDescription]
			, [AssessedFirstTimeEdFactsCode]
		)
		VALUES (
			-1
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
			, 'MISSING'
		)

		SET IDENTITY_INSERT RDS.DimAssessmentStatuses OFF
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimK12StaffCategories d WHERE d.DimK12StaffCategoryId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimK12StaffCategories ON

		INSERT INTO [RDS].[DimK12StaffCategories]
           ([DimK12StaffCategoryId]
		   ,[K12StaffClassificationCode]
           ,[K12StaffClassificationDescription]
           ,[K12StaffClassificationEdFactsCode]
           ,[SpecialEducationSupportServicesCategoryCode]
           ,[SpecialEducationSupportServicesCategoryDescription]
           ,[SpecialEducationSupportServicesCategoryEdFactsCode]
           ,[TitleIProgramStaffCategoryCode]
           ,[TitleIProgramStaffCategoryDescription]
           ,[TitleIProgramStaffCategoryEdFactsCode]
		   ,[MigrantEducationProgramStaffCategoryCode]
		   ,[MigrantEducationProgramStaffCategoryDescription]
		   ,[ProfessionalEducationalJobClassificationCode]
		   ,[ProfessionalEducationalJobClassificationDescription]
		   ,[TitleIIILanguageInstructionIndicatorCode]
 		   ,[TitleIIILanguageInstructionIndicatorDescription]
		   )
		   VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

			SET IDENTITY_INSERT RDS.DimK12StaffCategories OFF
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimTeachingCredentialStatuses d WHERE d.DimTeachingCredentialStatusId = -1) 
	BEGIN
		SET IDENTITY_INSERT rds.DimTeachingCredentialStatuses ON

			INSERT INTO rds.DimTeachingCredentialStatuses (
						  DimTeachingCredentialStatusId
						, TeachingCredentialTypeCode
						, TeachingCredentialTypeDescription
						, TeachingCredentialTypeEdFactsCode
						, TeachingCredentialBasisCode
						, TeachingCredentialBasisDescription
					)
			VALUES (
					-1
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING')

		SET IDENTITY_INSERT rds.DimTeachingCredentialStatuses OFF
	END

	IF NOT EXISTS (
			SELECT 1 FROM RDS.DimK12StaffStatuses 
			WHERE DimK12StaffStatusId = -1
		) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimK12StaffStatuses ON

		INSERT INTO RDS.DimK12StaffStatuses (
			  DimK12StaffStatusId
			, SpecialEducationAgeGroupTaughtCode
			, SpecialEducationAgeGroupTaughtDescription
			, SpecialEducationAgeGroupTaughtEdFactsCode
			, EdFactsCertificationStatusCode
			, EdFactsCertificationStatusDescription
			, EdFactsCertificationStatusEdFactsCode
			, HighlyQualifiedTeacherIndicatorCode
			, HighlyQualifiedTeacherIndicatorDescription
			, HighlyQualifiedTeacherIndicatorEdFactsCode
			, EdFactsTeacherInexperiencedStatusCode
			, EdFactsTeacherInexperiencedStatusDescription
			, EdFactsTeacherInexperiencedStatusEdFactsCode
			, EdFactsTeacherOutOfFieldStatusCode
			, EdFactsTeacherOutOfFieldStatusDescription
			, EdFactsTeacherOutOfFieldStatusEdFactsCode
			, SpecialEducationTeacherQualificationStatusCode
			, SpecialEducationTeacherQualificationStatusDescription
			, SpecialEducationTeacherQualificationStatusEdFactsCode
			, ParaprofessionalQualificationStatusCode
			, ParaprofessionalQualificationStatusDescription
			, ParaprofessionalQualificationStatusEdFactsCode
			, SpecialEducationRelatedServicesPersonnelCode
			, SpecialEducationRelatedServicesPersonnelDescription
			, CTEInstructorIndustryCertificationCode
			, CTEInstructorIndustryCertificationDescription
			, SpecialEducationParaprofessionalCode
			, SpecialEducationParaprofessionalDescription
			, SpecialEducationTeacherCode
			, SpecialEducationTeacherDescription
		)
		VALUES (-1, 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING', 'MISSING')

		SET IDENTITY_INSERT RDS.DimK12StaffStatuses OFF
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimMilitaryStatuses d WHERE d.DimMilitaryStatusId = -1) BEGIN
		SET IDENTITY_INSERT rds.DimMilitaryStatuses ON

			INSERT INTO rds.DimMilitaryStatuses (
						  DimMilitaryStatusId
						, MilitaryConnectedStudentIndicatorCode       
						, MilitaryConnectedStudentIndicatorDescription
						, MilitaryConnectedStudentIndicatorEdFactsCode
						, ActiveMilitaryStatusIndicatorCode          
						, ActiveMilitaryStatusIndicatorDescription   
						, MilitaryBranchCode                          
						, MilitaryBranchDescription                   
						, MilitaryVeteranStatusIndicatorCode         
						, MilitaryVeteranStatusIndicatorDescription  
					)
			VALUES (
					-1
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING'
					, 'MISSING')

		SET IDENTITY_INSERT rds.DimMilitaryStatuses OFF
	END

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAttendances d WHERE d.DimAttendanceId = -1) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimAttendances ON

		INSERT INTO [RDS].[DimAttendances]
           ([DimAttendanceId]
           ,ChronicStudentAbsenteeismIndicatorCode
           ,ChronicStudentAbsenteeismIndicatorDescription
		   ,ChronicStudentAbsenteeismIndicatorEdFactsCode
		   ,AttendanceEventTypeCode
		   ,AttendanceEventTypeDescription
		   ,AttendanceStatusCode
		   ,AttendanceStatusDescription
		   ,PresentAttendanceCategoryCode
		   ,PresentAttendanceCategoryDescription
		   ,AbsentAttendanceCategoryCode
		   ,AbsentAttendanceCategoryDescription
		   )
			VALUES (
				  -1
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				, 'MISSING'
				)

		SET IDENTITY_INSERT RDS.DimAttendances OFF

	END

PRINT N'Check Check Constraints'



ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_K12Staff];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_FactK12StudentCourseSections];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionK12Staff] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionK12Staff_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProviderId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentAdministrationId];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_CipCodeId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IeuId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_IeuId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IeuId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IeuId];

ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCourseSections_IeuId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_IeuId];

ALTER TABLE [RDS].[FactK12SalarySchedules] WITH CHECK CHECK CONSTRAINT [FK_FactK12SalarySchedules_IeuId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_IeuId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_IeuId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12SchoolId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12SchoolId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12SchoolId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12SchoolId];

ALTER TABLE [RDS].[BridgeK12SchoolGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SchoolGradeLevels_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_K12SchoolId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_K12SchoolId];

ALTER TABLE [RDS].[FactK12SalarySchedules] WITH CHECK CHECK CONSTRAINT [FK_FactK12SalarySchedules_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_K12SchoolId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_LeaId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_LeaId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_LeaId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LeaId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaIEPServiceProviderId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaAccountabilityId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaAttendanceId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaFundingId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaGraduationId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_LeaIndividualizedEducationProgramId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_LeaId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_LeaId];

ALTER TABLE [RDS].[BridgeLeaGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeLeaGradeLevels_LeaId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_LeaId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_LeaAccountabilityId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_LeaAttendanceId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_LeaFundingId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_LeaGraduationId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_LeaIndividualizedEducationProgramId];

ALTER TABLE [RDS].[FactK12SalarySchedules] WITH CHECK CHECK CONSTRAINT [FK_FactK12SalarySchedules_LeaId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_LeaId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_LeaId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LeaAccountabilityId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LeaAttendanceId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LeaFundingId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LeaIndividualizedEducationProgramId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_GraduationLeaId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LeaMembershipResidentId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MilitaryStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_MilitaryStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_MilitaryStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_MilitaryStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_NOrDStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_NOrDStatusId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12StudentId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12StudentId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12StudentId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsStudentId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_K12StudentId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsStudentId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_PersonId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_PsStudentId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_K12StaffId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12StudentId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeStudentId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsEnrollmentStatusId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsInstitutionId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_PsInstitutionId];

ALTER TABLE [RDS].[BridgeAeStudentEnrollmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeAeStudentEnrollmentRaces_FactAeStudentEnrollmentId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeDemographicId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AePostsecondaryTransitionDateId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramTypeId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_ApplicationDateId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_DataCollectionId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_K12AcademicAwardStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_HomelessnessStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_MigrantStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_MilitaryStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_DisabilityStatusId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_ProgramYearId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeStudent_CurrentId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramParticipantIndicatorId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramParticipantAssessmentIndicatorId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramEmploymentIndicatorId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_AeProgramTransitionIndicatorId];

ALTER TABLE [RDS].[FactAeStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactAeStudentEnrollments_HighSchoolDiplomaDiplomaOrCredentialAwardDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AccessibleEducationMaterialProviderId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CountDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionEndDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_CourseSectionStartDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DataCollectionId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_AgeId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_DisabilityStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_EntryGradeLevelId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_IdeaStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ImmigrantStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12CourseId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12DemographicId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12EnrollmentStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceIssuedDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceOrderedDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_LearningResourceReceivedDateId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_MigrantStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RaceId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_RuralStatusId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_PrimaryIdeaDisabilityTypeId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_ScedCodeId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SchoolYearId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SeaId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_SecondaryIdeaDisabilityTypeId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEconomicallyDisadvantagedId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateHomelessnessId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateIdeaId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMigrantId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDateMilitaryId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusEndDatePerkinsEnglishLearnerId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEconomicallyDisadvantagedId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateHomelessnessId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateIdeaId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMigrantId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDateMilitaryId];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_StatusStartDatePerkinsEnglishLearnerId];

ALTER TABLE [RDS].[BridgeK12AccessibleEducationMaterialRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialRaces_FactK12AccessibleEducationMaterialAssignments];

ALTER TABLE [RDS].[BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes_FactK12AccessibleEducationMaterialAssignments];

ALTER TABLE [RDS].[FactK12AccessibleEducationMaterialAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12AccessibleEducationMaterialAssignments_K12Student_CurrentId];

ALTER TABLE [RDS].[BridgeK12ProgramParticipationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12ProgramParticipationRaces_FactK12ProgramParticipations];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_SeaId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_DataCollectionId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_IdeaStatusId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_K12Demographics];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_K12ProgramTypes];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationExitDateId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_ProgramParticipationStartDateId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_SchoolYearId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12ProgramParticipations] WITH CHECK CHECK CONSTRAINT [FK_FactK12ProgramParticipations_TitleIIIStatusId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_SeaId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_FactTypeId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_TitleIIIStatuses];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_CredentialIssuanceDateId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_CredentialExpirationDateId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCounts_TeachingCredentialStatusId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentRaces_FactK12StudentAssessments];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentAdministrationId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentParticipationSessionId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentPerformanceLevelId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentRegistrationId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentSubtestId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_CompetencyDefinitionId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_CountDateId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_CteStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_DemographicId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_FactTypeId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_GradeLevelId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_IdeaStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_IeuId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_LeaId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_NOrDStatuses];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_SeaId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_TitleIIIStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_ImmigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_MigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_MilitaryStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_TitleIStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessments_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SeaId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_AssessmentSubtestId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_CompetencyDefinitionId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_GradeLevelWhenAssessedId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_IdeaStatusId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_RaceId];

ALTER TABLE [RDS].[FactK12StudentAssessmentsResultAggregates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAssessmentsResultAggregates_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_AttendanceId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_FactTypeId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_SeaId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_GradeLevelId];

ALTER TABLE [RDS].[FactK12StudentAttendanceRates] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAttendanceRates_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_MigrantStudentQualifyingArrivalDateId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_SeaId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12AcademicAwardStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_AgeId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_AttendanceId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_CohortStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_CteStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_FactTypeId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_GradeLevelId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_IdeaStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_ImmigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12EnrollmentStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_CohortYearId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_LanguageId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_CohortGraduationYearId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_MigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_RaceId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_SpecialEducationServicesExitDateId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_TitleIIIStatusId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_EnglishLearnerStatusId];

--ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentCounts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCounts_NOrDStatusId];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionRace_FactK12StudentCourseSections];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionsCipCodes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionsCipCodes_FactK12StudentCourseSections];

ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCourseSections_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentCourseSections_K12CourseSectionId];

ALTER TABLE [RDS].[FactK12StudentCourseSections] WITH CHECK CHECK CONSTRAINT [FF_FactK12StudentCourseSections_RecordStatusId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_SeaId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_DataCollectionId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_AttendanceId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_AttendanceEventDateId];

ALTER TABLE [RDS].[FactK12StudentDailyAttendances] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDailyAttendances_Person_CurrentId];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineRaces_FactK12StudentDisciplines];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_SeaId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_AgeId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_CteStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_DisabilityStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionEndDateId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_DisciplinaryActionStartDateId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_DisciplineStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_FactTypeId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_FirearmId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_FirearmsDisciplineStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_GradeLevelId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_IdeaStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_ImmigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_IncidentDateId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_IncidentStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_MigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_SecondaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_TitleIIIStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_DataCollectionId];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineIdeaDisabilityTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineIdeaDisabilityTypes_FactK12StudentDisciplines];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineIncidentBehaviors] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineIncidentBehaviors_FactK12StudentDisciplines];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_IncidentId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_IeuID];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_NOrDStatusId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_RaceId];

ALTER TABLE [RDS].[FactK12StudentDisciplines] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentDisciplines_TitleIStatusId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SeaId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_CountDateId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_DataCollectionId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageBeginYearId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_NcesSideVintageEndYearId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_PersonAddressId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_SchoolYearId];

ALTER TABLE [RDS].[BridgeK12StudentEconomicDisadvantageRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentEconomicDisadvantageRaces_FactK12StudentEconomicDisadvantageId];

ALTER TABLE [RDS].[FactK12StudentEconomicDisadvantages] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEconomicDisadvantages_K12Student_CurrentId];

ALTER TABLE [RDS].[BridgeK12StudentEnrollmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentEnrollmentRaces_FactK12StudentEnrollments];

ALTER TABLE [RDS].[BridgeK12StudentEnrollmentPersonAddresses] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentEnrollmentPersonAddresses_FactK12StudentEnrollments];

ALTER TABLE [RDS].[BridgeK12StudentEnrollmentIdeaDisabilityTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_FactK12StudentEnrollmentId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_SeaId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_TitleIIIStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_CohortGraduationYearId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_CohortYearId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_CteStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_DataCollectionId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EducationOrganizationNetworkId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_EntryGradeLevelId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_ExitGradeLevelId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusEndDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_HomelessnessStatusStartDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_IdeaStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_ImmigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12EnrollmentStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LanguageHomeId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_LanguageNativeId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_MigrantStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_ProjectedGraduationDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_SecondaryDisabilityTypeId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEconomicallyDisadvantagedId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateIdeaId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMigrantId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateMilitaryConnectedStudentId ];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDatePerkinsEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusEndDateTitleIIIImmigrantId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEconomicallyDisadvantagedId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateIdeaId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMigrantId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateMilitaryConnectedStudentId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDatePerkinsEnglishLearnerId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_StatusStartDateTitleIIIImmigrantId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_CountDateId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_ResponsibleSchoolTypeId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_GiftedAndTalentedStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_DisabilityStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12DropoutStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12RetentionStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_PsEnrollmentStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_CteOutcomeIndicatorId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_RecordStatusId];

ALTER TABLE [RDS].[FactK12StudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentEnrollments_TitleIStatusId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_SeaId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_AuthorizingBodyCharterSchoolAuthorizerId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolManagementOrganizationId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_SecondaryAuthorizingBodyCharterSchoolAuthorizerId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_FactTypeId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12SchoolStatusId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_SchoolYearId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12OrganizationStatusId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12StaffId];

--ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolUpdatedManagementOrganizationId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_CharterSchoolStatusId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_ComprehensiveAndTargetedSupportId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_ReasonApplicabilityId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_K12SchoolStateStatusId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_SubgroupId];

ALTER TABLE [RDS].[FactOrganizationCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationCounts_TitleIStatusId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_AcademicAwardDateId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardStatuId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsAcademicAwardTitleId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_SchoolYearId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsDemographicId];

ALTER TABLE [RDS].[FactPsStudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicAwards_PsStudent_CurrentId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_SeaId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsDemographicId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_CountDateId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_DataCollectionId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsInstitutionStatusId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_SchoolYearId];

ALTER TABLE [RDS].[FactPsStudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentAcademicRecords_PsStudent_CurrentId];

ALTER TABLE [RDS].[BridgePsStudentEnrollmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgePsStudentEnrollmentRaces_FactPsStudentEnrollments];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_EntryDateIntoPostSecondaryId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_CountDateId];

ALTER TABLE [RDS].[FactPsStudentEnrollments] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentEnrollments_PsStudent_CurrentId];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimFactTypes];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimIdeaStatuses];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Demographics];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimRaces];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicators];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSchoolPerformanceIndicatorStateDefinedStatuses];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimSubgroups];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimK12Schools];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_CountDateId];

ALTER TABLE [RDS].[FactSchoolPerformanceIndicators] WITH CHECK CHECK CONSTRAINT [FK_FactSchoolPerformanceIndicators_DimEconomicallyDisadvantagedStatuses];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_CteStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_DataCollectionId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateInitialId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EligibilityEvaluationDateReevaluationId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EntryGradeLevelId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_FosterCareStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_HomelessnessStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IdeaStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ImmigrantStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanExitDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramServicePlanReevaluationDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_IndividualizedProgramStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_K12DemographicId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_K12EnrollmentStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_SeaId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_MigrantStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ProgramParticipationStartDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ProgramStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ResponsibleSchoolTypeId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_SchoolYearId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_SecondaryDisabilityTypeId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_SpecialEducationServicesExitDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_TitleIIIStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryAtExitId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryBaselineId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateAtExitId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ChildOutcomeSummaryDateBaselineId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_ConsentToEvaluationDateId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_CountDateId];

ALTER TABLE [RDS].[BridgeSpecialEducationIdeaDisabilityTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeSpecialEducationIdeaDisabilityTypes_FactSpecialEducationId];

ALTER TABLE [RDS].[BridgeSpecialEducationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeSpecialEducationRaces_FactSpecialEducationId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactSpecialEducation] WITH CHECK CHECK CONSTRAINT [FK_FactSpecialEducation_K12Student_CurrentId];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineIncidentBehaviors] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineIncidentBehaviors_DimIncidentBehaviors];

ALTER TABLE [RDS].[BridgeK12StudentEnrollmentIdeaDisabilityTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentEnrollmentIdeaDisabilityTypes_IdeaDisabilityTypeId];

ALTER TABLE [RDS].[BridgeAeStudentEnrollmentAeEmploymentBarriers] WITH CHECK CHECK CONSTRAINT [FK_BridgeAeStudentEnrollmentAeEmploymentBarriers_FactAeStudentEnrollmentId];

ALTER TABLE [RDS].[BridgeAeStudentEnrollmentAeEmploymentBarriers] WITH CHECK CHECK CONSTRAINT [FK_BridgeAeStudentEnrollmentAeEmploymentBarriers_AeEmploymentBarrierId];

ALTER TABLE [RDS].[BridgeAeStudentEnrollmentAeProgramParticipantGoals] WITH CHECK CHECK CONSTRAINT [FK_BridgeAeStudentEnrollmentAeProgramParticipantGoals_FactAeStudentEnrollmentId];

ALTER TABLE [RDS].[BridgeAeStudentEnrollmentAeProgramParticipantGoals] WITH CHECK CHECK CONSTRAINT [FK_BridgeAeStudentEnrollmentAeProgramParticipantGoals_AeProgramParticipantGoalId];

ALTER TABLE [RDS].[BridgeCredentialAwardCompetencyDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeCredentialAwardCompetencyDefinitions_CompetencyDefinitionId];

ALTER TABLE [RDS].[BridgeCredentialAwardCompetencyDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeCredentialAwardCompetencyDefinitions_FactCredentialAwards];

ALTER TABLE [RDS].[BridgeCredentialAwardRelatedCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_BridgeCredentialAwardRelatedCredentialAwards_FactCredentialAwards];

ALTER TABLE [RDS].[BridgeCredentialAwardRelatedCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_BridgeCredentialAwardRelatedCredentialAwards_RelatedFactCredentialAwardId];

ALTER TABLE [RDS].[BridgeDirectoryActivities] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryActivities_FactDirectory];

ALTER TABLE [RDS].[BridgeDirectoryActivities] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryActivities_DimProfessionalDevelopmentActivityId];

ALTER TABLE [RDS].[BridgeDirectoryContacts] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryContacts_ContactId];

ALTER TABLE [RDS].[BridgeDirectoryContacts] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryContacts_FactDirectoryId];

ALTER TABLE [RDS].[BridgeDirectoryOrganizationAddresses] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryOrganizationAddresses_FactDirectory];

ALTER TABLE [RDS].[BridgeDirectoryOrganizationAddresses] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryOrganizationAddresses_OrganizationAddressId];

ALTER TABLE [RDS].[BridgeDirectoryOrganizationRelationships] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryOrganizationRelationships_ObjectOrganizationId];

ALTER TABLE [RDS].[BridgeDirectoryOrganizationRelationships] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryOrganizationRelationships_SubjectOrganization];

ALTER TABLE [RDS].[BridgeDirectoryProgramTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryProgramTypes_FactDirectory];

ALTER TABLE [RDS].[BridgeDirectoryProgramTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryProgramTypes_ProgramTypeId];

ALTER TABLE [RDS].[BridgeDirectoryStudentSupportServiceTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryStudentSupportServiceTypes_FactDirectory];

ALTER TABLE [RDS].[BridgeDirectoryStudentSupportServiceTypes] WITH CHECK CHECK CONSTRAINT [FK_BridgeDirectoryStudentSupportServiceTypes_StudentSupportServiceTypeId];

ALTER TABLE [RDS].[BridgeFacilityOrganizationAddresses] WITH CHECK CHECK CONSTRAINT [FK_BridgeFacilityOrganizationAddresses_FacilityId];

ALTER TABLE [RDS].[BridgeFacilityOrganizationAddresses] WITH CHECK CHECK CONSTRAINT [FK_BridgeFacilityOrganizationAddresses_OrganizationAddressId];

ALTER TABLE [RDS].[BridgeK12AcademicCalendarEventGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AcademicCalendarEventGradeLevels_FactK12AcademicCalendarEventId];

ALTER TABLE [RDS].[BridgeK12AcademicCalendarEventGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AcademicCalendarEventGradeLevels_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12AcademicCalendarGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AcademicCalendarGradeLevels_FactK12AcademicCalendarId];

ALTER TABLE [RDS].[BridgeK12AcademicCalendarGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12AcademicCalendarGradeLevels_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12CourseEndorsementRequirementCredentialDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12CourseEndorsementRequirementCredentialDefinitions_FactK12CourseEndorsementRequirements];

ALTER TABLE [RDS].[BridgeK12CourseEndorsementRequirementCredentialDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12CourseEndorsementRequirementCredentialDefinitions_CredentialDefinitions];

ALTER TABLE [RDS].[BridgeK12IncidentFirearms] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentFirearms_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentFirearms] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentFirearms_FirearmId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentPerpetrators] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentPerpetrators_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentPerpetrators] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentPerpetrators_PersonId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentPerpetrators] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentPerpetrators_Person_CurrentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentReporters] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentReporters_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentReporters] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentReporters_PersonId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentReporters] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentReporters_Person_CurrentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentVictims] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentVictims_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentVictims] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentVictims_PersonId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentVictims] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentVictims_Person_CurrentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentWitnesses] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentWitnesses_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentWitnesses] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentWitnesses_PersonId];

ALTER TABLE [RDS].[BridgeK12IncidentIncidentWitnesses] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentIncidentWitnesses_Person_CurrentId];

ALTER TABLE [RDS].[BridgeK12IncidentsIncidentBehaviors] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentsIncidentBehaviors_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentsIncidentBehaviors] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentsIncidentBehaviors_IncidentBehaviorId];

ALTER TABLE [RDS].[BridgeK12IncidentWeapons] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentWeapons_FactK12IncidentId];

ALTER TABLE [RDS].[BridgeK12IncidentWeapons] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12IncidentWeapons_WeaponId];

ALTER TABLE [RDS].[BridgeK12SchoolGradeLevelsAuthorized] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SchoolGradeLevelsAuthorized_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12SchoolGradeLevelsAuthorized] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SchoolGradeLevelsAuthorized_K12SchoolId];

ALTER TABLE [RDS].[BridgeK12SchoolGradeLevelsOffered] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SchoolGradeLevelsOffered_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12SchoolGradeLevelsOffered] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SchoolGradeLevelsOffered_K12SchoolId];

ALTER TABLE [RDS].[BridgeK12SeaJobCatalogueSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SeaJobCatalogueSeaFinancialAccountClassifications_FactK12SeaJobCatalogueId];

ALTER TABLE [RDS].[BridgeK12SeaJobCatalogueSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SeaJobCatalogueSeaFinancialAccountClassifications_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[BridgeK12SeaJobClassificationEndorsementCredentialDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SeaJobClassificationEndorsementCredentialDefinitions_FactK12SeaJobClassificationEndorsementRequirements];

ALTER TABLE [RDS].[BridgeK12SeaJobClassificationEndorsementCredentialDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12SeaJobClassificationEndorsementCredentialDefinitions_CredentialDefinitions];

ALTER TABLE [RDS].[BridgeK12StaffAssessmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssessmentRaces_FactK12StaffAssignments];

ALTER TABLE [RDS].[BridgeK12StaffAssessmentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssessmentRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentCourseSections] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentCourseSections_FactK12StaffAssignmentId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentCourseSections] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentCourseSections_K12CourseId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentCredentialAwards_CredentialAwardId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentCredentialAwards_FactK12StaffAssignments];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentGradeLevels_FactK12StaffAssignmentId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentGradeLevels_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentsCompetencyDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentsCompetencyDefinitions_CompetencyDefinitionId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentsCompetencyDefinitions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentsCompetencyDefinitions_FactK12StaffAssignments];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentsRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentsRaces_FactK12StaffAssignmentId];

ALTER TABLE [RDS].[BridgeK12StaffAssignmentsRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffAssignmentsRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StaffCompensationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCompensationRaces_FactK12StaffCompensationId];

ALTER TABLE [RDS].[BridgeK12StaffCompensationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCompensationRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StaffCompensationSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCompensationSeaFinancialAccountClassifications_FactK12StaffCompensationId];

ALTER TABLE [RDS].[BridgeK12StaffCompensationSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCompensationSeaFinancialAccountClassifications_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionGradeLevels_FactK12StaffCourseSectionId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionGradeLevels_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionRaces_FactK12StaffCourseSectionId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionSeaFinancialAccountClassifications_FactK12StaffCourseSectionId];

ALTER TABLE [RDS].[BridgeK12StaffCourseSectionSeaFinancialAccountClassifications] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffCourseSectionSeaFinancialAccountClassifications_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[BridgeK12StaffEmploymentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEmploymentRaces_FactK12StaffEmploymentId];

ALTER TABLE [RDS].[BridgeK12StaffEmploymentRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEmploymentRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StaffEvaluationK12Positions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEvaluationK12Positions_FactK12StaffEvaluations];

ALTER TABLE [RDS].[BridgeK12StaffEvaluationK12Positions] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEvaluationK12Positions_K12JobPositionId];

ALTER TABLE [RDS].[BridgeK12StaffEvaluationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEvaluationRaces_FactK12StaffEvaluations];

ALTER TABLE [RDS].[BridgeK12StaffEvaluationRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StaffEvaluationRaces_RaceId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_FactK12StudentAssessmentId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureLanguageTypeId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AssessmentComponentId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureBrailleId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureCalculatorId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureBreakId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureSignedAdministrationId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureAlternateResponseOptionId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureAssessmentExtendedTimeId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureDisplayFormatAdjustmentId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureGroupSizeId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureMedicalSupportId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureReadAloudId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureReferenceSheetId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureSettingId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureTactileMediumId];

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccessibilityFeatures] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccessibilityFeatures_AccessibilityFeatureTranslationPresentationId];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionGradeLevels_FactK12StudentCourseSectionId];

ALTER TABLE [RDS].[BridgeK12StudentCourseSectionGradeLevels] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentCourseSectionGradeLevels_GradeLevelId];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDisciplineReasons] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineDisciplineReasons_DimDisciplineReasons];

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDisciplineReasons] WITH CHECK CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineDisciplineReasons_FactK12StudentDisciplines];

ALTER TABLE [RDS].[BridgeLeaGradeLevelsOffered] WITH CHECK CHECK CONSTRAINT [FK_BridgeLeaGradeLevelsOffered_GradeLevelId];

ALTER TABLE [RDS].[BridgeLeaGradeLevelsOffered] WITH CHECK CHECK CONSTRAINT [FK_BridgeLeaGradeLevelsOffered_LeaId];

ALTER TABLE [RDS].[BridgePsStudentAcademicAwardCipCodes] WITH CHECK CHECK CONSTRAINT [FK_BridgePsStudentAcademicAwardCipCodes_FactPsStudentAcademicAwardId];

ALTER TABLE [RDS].[BridgePsStudentAcademicAwardCipCodes] WITH CHECK CHECK CONSTRAINT [FK_BridgePsStudentAcademicAwardCipCodes_CipCodeId];

ALTER TABLE [RDS].[BridgePsStudentCourseTranscriptRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgePsStudentCourseTranscriptRaces_FactPsStudentCourseTranscriptId];

ALTER TABLE [RDS].[BridgePsStudentCourseTranscriptRaces] WITH CHECK CHECK CONSTRAINT [FK_BridgePsStudentCourseTranscriptRaces_RaceId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_AssessmentId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialAwardId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialAwardRecipientId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialAwardRecipient_CurrentId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialAwardStatusId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialDefinitionId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_CredentialIssuerId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_DataCollectionId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_K12DemographicId];

ALTER TABLE [RDS].[FactCredentialAwards] WITH CHECK CHECK CONSTRAINT [FK_FactCredentialAwards_SchoolYearId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_IeuId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_K12SchoolId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_K12SchoolStatusId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_LeaId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_OrganizationId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_PsInstitutionId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_SchoolYearId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_SeaId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_DimAeProviderId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_AlternativeSchoolStatusId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_CharterSchoolAuthorizerId ];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_CharterSchoolManagementOrganizationId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_CharterSchoolStatusId ];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_ComprehensiveAndTargetedSupportId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_DataCollectionId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_DimNOrDStatuses];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_EarlyChildhoodOrganizationStatusId];

ALTER TABLE [RDS].[FactDirectory] WITH CHECK CHECK CONSTRAINT [FK_FactDirectory_EarlyLearningOrganizationId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_CountDateId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_FacilityId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_FacilitySpaceStatusId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_FacilityStatusId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_FacilityUtilizationStatusId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_OrganizationId];

ALTER TABLE [RDS].[FactFacilities] WITH CHECK CHECK CONSTRAINT [FK_FactFacilities_SchoolYearId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_SchoolYearId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarEventDateId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_StartTimeId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_EndTimeId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_SeaId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_IeuId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_LeaId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_K12SchoolId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarEventIndicatorId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarSessionIndicatorId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarSessionId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_CalendarCrisisId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_DataCollectionId];

ALTER TABLE [RDS].[FactK12AcademicCalendarEvents] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendarEvents_RecordStatusId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_SchoolYearId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_DataCollectionId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_SeaId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_IeuId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_LeaId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_K12SchoolId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_CalendarSessionId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_CalendarSessionIndicatorId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactK12AcademicCalendars] WITH CHECK CHECK CONSTRAINT [FK_FactK12AcademicCalendars_CalendarCrisisId];

ALTER TABLE [RDS].[FactK12CourseEndorsementRequirements] WITH CHECK CHECK CONSTRAINT [FK_FactK12CourseEndorsementRequirements_K12Course];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_SeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_IeuId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_LeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_K12SchoolId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FinancialAccountingDateId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FiscalYearId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FederalFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_SeaFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_LeaFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FederalFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_LeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FederalFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_SeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_LeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBalances] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBalances_FederalProgramCodeId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_IeuId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_K12SchoolId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FinancialAccountingDateId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FiscalYearId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FiscalPeriodId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaFinancialAccountBalanceId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_SeaFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_LeaFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountBudgets] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountBudgets_FederalProgramCodeId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_SeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_LeaFinancialAccountId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FederalFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_SeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_LeaFinancialAccountClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FederalFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_SeaFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_LeaFinancialExpenditureClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FederalFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_SeaFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_LeaFinancialRevenueClassificationId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FederalProgramCodeId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_SeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_IeuId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_LeaId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_K12SchoolId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FinancialAccountingDateId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FiscalYearId];

ALTER TABLE [RDS].[FactK12FinancialAccountGeneralLedgers] WITH CHECK CHECK CONSTRAINT [FK_FactK12FinancialAccountGeneralLedgers_FederalFinancialAccountId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_SchoolYearId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_CohortYearId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_CohortGraduationYearId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_DiplomaOrCredentialAwardDateId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_CohortExclusionId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12AcademicAwardStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_SeaId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_IeuId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_LeaAccountabilityId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_LeaFundingId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_LeaGraduationId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_LeaInstructionId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_LeaResidentId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12SchoolId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12StudentId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12EnrollmentStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12DropoutStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_CohortId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_CohortStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_GradeLevelId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_K12DemographicId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_HomelessnessStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_MigrantStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_FosterCareStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_IdeaStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_DisabilityStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_MilitaryStatusId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_DataCollectionId];

ALTER TABLE [RDS].[FactK12GraduationCohorts] WITH CHECK CHECK CONSTRAINT [FK_FactK12GraduationCohorts_RecordStatusId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_SchoolYearId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_CountDateId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentDateId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentTimeId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_SeaId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IeuId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_LeaId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_K12SchoolId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_DataCollectionId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentSettingId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentTimeIndicatorId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_IncidentStatusId];

ALTER TABLE [RDS].[FactK12Incidents] WITH CHECK CHECK CONSTRAINT [FK_FactK12Incidents_RecordStatusId];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_SchoolYears];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_CountDateId];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_DataCollections];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_Seas];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_Ieus];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_Leas];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_Contacts];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_Contact_CurrentId];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_ContactIndicators];

ALTER TABLE [RDS].[FactK12OrganizationContacts] WITH CHECK CHECK CONSTRAINT [FK_FactK12OrganizationContacts_ContactPersonAddresses];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_SchoolYears];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_CountDateId];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_DataCollections];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_Seas];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_Ieus];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_Leas];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_K12Schools];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_K12Students];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_K12Students_Current];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_ParentOrGuardians];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_ParentOrGuardians_Current];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_PersonRelationshipToLearnerContactInformation];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_ContactIndicators];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_PersonRelationships];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_PersonOrGuardianPersonAddress];

ALTER TABLE [RDS].[FactK12ParentOrGuardians] WITH CHECK CHECK CONSTRAINT [FK_FactK12ParentOrGuardians_ParentOrGuardianIndicators];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_SchoolYearId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_CountDateId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_StandardOccupationalClassificationId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_K12JobId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_DataCollectionId];

ALTER TABLE [RDS].[FactK12SeaJobCatalogues] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobCatalogues_RecordStatusId];

ALTER TABLE [RDS].[FactK12SeaJobClassificationEndorsementRequirements] WITH CHECK CHECK CONSTRAINT [FK_FactK12SeaJobClassificationEndorsementRequirements_K12Course];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AccessibilityFeatureId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentAdministrationId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentFormId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentPerformanceLevelId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentRegistrationId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentRegistrationGradeLevelToBeAssessedId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentSubtestId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_CredentialAwardId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_CredentialAwardStatusId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_CredentialDefinitionId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_CredentialIssuerId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_AssessmentParticipationSessionId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_EmployerId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12JobId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12JobPositionId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12StaffAssignmentStatusId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12StaffPersonId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12StaffPerson_CurrentId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffAssessments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssessments_StandardOccupationalClassificationId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_DimScedCodes];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_EmployerId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_EmploymentEndDateId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_EmploymentStartDateId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_HireDateId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_InstructionLanguageId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12JobId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12PositionId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12StaffAssignmentStatusId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_Ieus];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12SchoolId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12StaffId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_LeaId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_SeaId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_IeuEmployerId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_LeaEmployerId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_AssignmentEndDateId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_AssignmentStartDateId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffAssignments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffAssignments_DimOnetSocOccupationTypes];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_CountDateId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_SeaId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_IeuId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_LeaId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_EmployerId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12StaffId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_StandardOccupationalClassificationId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_StaffCompensationTypeId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12JobPositionId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12JobId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_EmploymentStartDateId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_EmploymentEndDateId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_RecordStatusId];

ALTER TABLE [RDS].[FactK12StaffCompensations] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCompensations_FundingSourceFinancialAccountId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_CipCodeId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_CountDateId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_CourseApplicableEducationLevelId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_EmployerId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_IeuId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_InstructionLanguageId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_StateK12CourseId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_LeaK12CourseId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_ClassBeginningTimeId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_ClassEndingTimeId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12CourseSectionStatusId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12CourseStatusId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12JobId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12JobPositionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12SchoolId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12SchoolInstructionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12StaffMemberId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12StaffMember_CurrentId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_LeaId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_LeaInstructionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_CalendarSessionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_ScedCodeId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_SeaId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StffCourseSections_K12StaffAssignmentStartDateId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StffCourseSections_K12StaffAssignmentEndDateId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StffCourseSections_K12StaffAssignmentStatusId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12CourseSections_K12CourseSectionId];

ALTER TABLE [RDS].[FactK12StaffCourseSections] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffCourseSections_RecordStatusId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_CountDateId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_SeaId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_IeuId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_LeaId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_EmployerId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12StaffId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_StandardOccupationalClassificationId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12JobPositionId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12JobId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_EmploymentStartDateId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_EmploymentEndDateId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_HireDateId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEmployments_RecordStatusId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_EmployerId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_IeuId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12DemographicId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12JobId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12SchoolId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12StaffId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_LeaId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_SeaId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffEvaluationParts] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffEvaluationParts_StaffEvaluationPartStatusId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12EmploymentStatusId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12JobId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12JobPositionId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12SchoolId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12StaffAssignmentStatusId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12StaffCategoryId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12StaffId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12Staff_CurrentId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12StaffStatusId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_TeachingCredentialStatusId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_LeaId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_LeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_ProfessionalDevelopmentActivityId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_ProfessionalDevelopmentSessionEndDate];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_ProfessionalDevelopmentSessionStartDate];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_SchoolYearId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_SeaId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_SeaJobClassificationId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_DataCollectionId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_EmployerId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_IeuId];

ALTER TABLE [RDS].[FactK12StaffProfessionalDevelopmentSessions] WITH CHECK CHECK CONSTRAINT [FK_FactK12StaffProfessionalDevelopmentSessions_K12DemographicId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_DataCollectionId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_CountDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_SeaId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_LeaAccountabilityId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_LeaInstructionId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_RecordStatusId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_K12AcademicAwardStatusId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_AcademicAwardDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_DiplomaOrCredentialAwardDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicAwards] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicAwards_DimK12AcademicAwardId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_DataCollectionId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_K12StudentId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_K12Student_CurrentId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_SchoolYearId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_CountDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_ProjectedGraduationDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_EducationCareerEducationPlanDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_CareerCareerEducationPlanDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_EnrollmentEntryDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_EnrollmentExitDateId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_SeaId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_LeaAccountabilityId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_LeaInstructionId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_K12SchoolId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_RecordStatusId];

ALTER TABLE [RDS].[FactK12StudentAcademicRecords] WITH CHECK CHECK CONSTRAINT [FK_FactK12StudentAcademicRecords_K12AcademicAwardStatusId];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimFactTypes];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimIdeaStatuses];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimK12Demographics];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolYear];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimEconomicallyDisadvantagedStatuses];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimRaces];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorCategories];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicators];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolPerformanceIndicatorStateDefinedStatuses];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimSchoolQualityOrStudentSuccessIndicators];

ALTER TABLE [RDS].[FactOrganizationStatusCounts] WITH CHECK CHECK CONSTRAINT [FK_FactOrganizationStatusCounts_DimK12Schools];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_AcademicTermDesignatorId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_CipCodeId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_DataCollectionId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_DisabilityStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_EconomicallyDisadvantagedStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_HomelessnessStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_PrimaryDisabilityTypeId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_IdeaStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_ImmigrantStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_MilitaryStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_MigrantStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_EnglishLearnerStatusId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_StatePsCourseId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_UniversityPsCourseId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_PsDemographicId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_PsInstitutionId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_SchoolYearId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_PsStudentId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_PsStudent_CurrentId];

ALTER TABLE [RDS].[FactPsStudentCourseTranscripts] WITH CHECK CHECK CONSTRAINT [FK_FactPsStudentCourseTranscripts_CourseGradePointAverageIndicatorId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentRecordReferencePeriodStartDateId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentRecordReferencePeriodEndDateId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmployerId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_PersonId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_Person_CurrentId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_OnetSocOccupationTypeId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_StandardOccupationalClassificationId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_NaicsCodeId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentLocationId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentRecordSourceId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentStartDateId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_EmploymentEndDateId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_HireDateId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_DataCollectionId];

ALTER TABLE [RDS].[FactQuarterlyEmployments] WITH CHECK CHECK CONSTRAINT [FK_FactQuarterlyEmployments_RecordStatusId];

CREATE NONCLUSTERED INDEX [IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode]
    ON [RDS].[DimAssessmentAdministrations]([AssessmentIdentifier] ASC);

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_IeuId] FOREIGN KEY([IeuId])
REFERENCES [RDS].[DimIeus] ([DimIeuId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_IeuId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_IeuId] FOREIGN KEY([IeuId])
REFERENCES [RDS].[DimIeus] ([DimIeuId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_IeuId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_IeuId] FOREIGN KEY([IeuId])
REFERENCES [RDS].[DimIeus] ([DimIeuId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_IeuId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountBalanceId] FOREIGN KEY([LeaFinancialAccountBalanceId])
REFERENCES [RDS].[DimLeaFinancialAccountBalances] ([DimLeaFinancialAccountBalanceId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountBalanceId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountBalanceId] FOREIGN KEY([LeaFinancialAccountBalanceId])
REFERENCES [RDS].[DimLeaFinancialAccountBalances] ([DimLeaFinancialAccountBalanceId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountBalanceId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountClassificationId] FOREIGN KEY([LeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimLeaFinancialAccountClassifications] ([DimLeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountClassificationId] FOREIGN KEY([LeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimLeaFinancialAccountClassifications] ([DimLeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountId] FOREIGN KEY([LeaFinancialAccountId])
REFERENCES [RDS].[DimFinancialAccounts] ([DimFinancialAccountId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialAccountId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountId] FOREIGN KEY([LeaFinancialAccountId])
REFERENCES [RDS].[DimFinancialAccounts] ([DimFinancialAccountId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_LeaFinancialAccountId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialAccountClassificationId] FOREIGN KEY([LeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimLeaFinancialAccountClassifications] ([DimLeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialExpenditureClassificationId] FOREIGN KEY([LeaFinancialExpenditureClassificationId])
REFERENCES [RDS].[DimLeaFinancialExpenditureClassifications] ([DimLeaFinancialExpenditureClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialExpenditureClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialRevenueClassificationId] FOREIGN KEY([LeaFinancialRevenueClassificationId])
REFERENCES [RDS].[DimLeaFinancialRevenueClassifications] ([DimLeaFinancialRevenueClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaFinancialRevenueClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialExpenditureClassificationId] FOREIGN KEY([LeaFinancialExpenditureClassificationId])
REFERENCES [RDS].[DimLeaFinancialExpenditureClassifications] ([DimLeaFinancialExpenditureClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialExpenditureClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialRevenueClassificationId] FOREIGN KEY([LeaFinancialRevenueClassificationId])
REFERENCES [RDS].[DimLeaFinancialRevenueClassifications] ([DimLeaFinancialRevenueClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaFinancialRevenueClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaId] FOREIGN KEY([LeaId])
REFERENCES [RDS].[DimLeas] ([DimLeaID])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_LeaId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_LeaId] FOREIGN KEY([LeaId])
REFERENCES [RDS].[DimLeas] ([DimLeaID])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_LeaId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_LeaId] FOREIGN KEY([LeaId])
REFERENCES [RDS].[DimLeas] ([DimLeaID])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_LeaId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountBalanceId] FOREIGN KEY([SeaFinancialAccountBalanceId])
REFERENCES [RDS].[DimSeaFinancialAccountBalances] ([DimSeaFinancialAccountBalanceId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountBalanceId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountBalanceId] FOREIGN KEY([SeaFinancialAccountBalanceId])
REFERENCES [RDS].[DimSeaFinancialAccountBalances] ([DimSeaFinancialAccountBalanceId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountBalanceId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountClassificationId] FOREIGN KEY([SeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimSeaFinancialAccountClassifications] ([DimSeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountClassificationId] FOREIGN KEY([SeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimSeaFinancialAccountClassifications] ([DimSeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountId] FOREIGN KEY([SeaFinancialAccountId])
REFERENCES [RDS].[DimFinancialAccounts] ([DimFinancialAccountId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialAccountId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountId] FOREIGN KEY([SeaFinancialAccountId])
REFERENCES [RDS].[DimFinancialAccounts] ([DimFinancialAccountId])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_SeaFinancialAccountId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialAccountClassificationId] FOREIGN KEY([SeaFinancialAccountClassificationId])
REFERENCES [RDS].[DimSeaFinancialAccountClassifications] ([DimSeaFinancialAccountClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialAccountClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialExpenditureClassificationId] FOREIGN KEY([SeaFinancialExpenditureClassificationId])
REFERENCES [RDS].[DimSeaFinancialExpenditureClassifications] ([DimSeaFinancialExpenditureClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialExpenditureClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialRevenueClassificationId] FOREIGN KEY([SeaFinancialRevenueClassificationId])
REFERENCES [RDS].[DimSeaFinancialRevenueClassifications] ([DimSeaFinancialRevenueClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaFinancialRevenueClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialExpenditureClassificationId] FOREIGN KEY([SeaFinancialExpenditureClassificationId])
REFERENCES [RDS].[DimSeaFinancialExpenditureClassifications] ([DimSeaFinancialExpenditureClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialExpenditureClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialRevenueClassificationId] FOREIGN KEY([SeaFinancialRevenueClassificationId])
REFERENCES [RDS].[DimSeaFinancialRevenueClassifications] ([DimSeaFinancialRevenueClassificationId])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaFinancialRevenueClassificationId]

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaId] FOREIGN KEY([SeaId])
REFERENCES [RDS].[DimSeas] ([DimSeaID])

ALTER TABLE [RDS].[FactFinancialAccountGeneralLedgers] CHECK CONSTRAINT [FK_FactFinancialAccountGeneralLedgers_SeaId]

ALTER TABLE [RDS].[FactFinancialAccountBudgets]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBudgets_SeaId] FOREIGN KEY([SeaId])
REFERENCES [RDS].[DimSeas] ([DimSeaID])

ALTER TABLE [RDS].[FactFinancialAccountBudgets] CHECK CONSTRAINT [FK_FactFinancialAccountBudgets_SeaId]

ALTER TABLE [RDS].[FactFinancialAccountBalances]  WITH CHECK ADD  CONSTRAINT [FK_FactFinancialAccountBalances_SeaId] FOREIGN KEY([SeaId])
REFERENCES [RDS].[DimSeas] ([DimSeaID])

ALTER TABLE [RDS].[FactFinancialAccountBalances] CHECK CONSTRAINT [FK_FactFinancialAccountBalances_SeaId]

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations]  WITH CHECK ADD  CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId] FOREIGN KEY([FactK12StudentAssessmentId])
REFERENCES [RDS].[FactK12StudentAssessments] ([FactK12StudentAssessmentId])

ALTER TABLE [RDS].[BridgeK12StudentAssessmentAccommodations] CHECK CONSTRAINT [FK_BridgeK12StudentAssessmentAccommodations_FactK12StudentAssessmentId]

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons]  WITH CHECK ADD  CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_FactK12StudentDisciplines] FOREIGN KEY([FactK12StudentDisciplineId])
REFERENCES [RDS].[FactK12StudentDisciplines] ([FactK12StudentDisciplineId])

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons] CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_FactK12StudentDisciplines]

CREATE NONCLUSTERED INDEX [IX_FactStudentCountReports_CategorySetCode_DISABILITY_Report] ON [RDS].[ReportEDFactsK12StudentCounts]
(
	[CategorySetCode] ASC,
	[IDEADISABILITYTYPE] ASC,
	[ReportCode] ASC,
	[ReportLevel] ASC,
	[ReportYear] ASC
)
INCLUDE([CTEPARTICIPANT],[ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS],[PROGRAMPARTICIPATIONFOSTERCARE],[HOMELESSNESSSTATUS],[TITLEIIIIMMIGRANTPARTICIPATIONSTATUS],[ENGLISHLEARNERSTATUS],[MIGRANTSTATUS],[OrganizationName],[OrganizationIdentifierNces],[OrganizationIdentifierSea],[ParentOrganizationIdentifierSea],[SECTION504STATUS],[StateANSICode],[StateAbbreviationCode],[StateAbbreviationDescription],[StudentCount],[TITLEISCHOOLSTATUS]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons]  WITH CHECK ADD  CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_DimDisciplineReasons] FOREIGN KEY([DisciplineReasonId])
REFERENCES [RDS].[DimDisciplineReasons] ([DimDisciplineReasonId])

ALTER TABLE [RDS].[BridgeK12StudentDisciplineDiscplineReasons] CHECK CONSTRAINT [FK_BridgeK12StudentDisciplineDiscplineReasons_DimDisciplineReasons]

--CREATE NONCLUSTERED INDEX [IX_DimAssessmentAdministrations_AssessmentAdministrationSubjectEdFactsCode] ON [RDS].[DimAssessmentAdministrations]
--(
--	[AssessmentIdentifier] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

