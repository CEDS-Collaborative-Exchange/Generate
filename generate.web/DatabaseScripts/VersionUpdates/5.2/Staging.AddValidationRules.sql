/****** Object:  Table [Staging].[StagingValidationConfig]    Script Date: 11/28/2022 12:57:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[StagingValidationRules]') AND type in (N'U'))
BEGIN

TRUNCATE TABLE [Staging].[StagingValidationRules]

--additions
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment',N'Generate',N'K12Enrollment',N'GradeLevel',N'Null Value',NULL,NULL,NULL,NULL,N'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment',N'Generate',N'PersonRace',N'OrganizationIdentifier',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment',N'Generate',N'PersonRace',N'OrganizationType',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment',N'Generate',N'PersonRace',N'OrganizationType',N'Bad Value',NULL,NULL,N'where OrganizationType not in (''SEA'',''LEA'', ''K12School'')',N'The Organization Type provided for the Race record in not valid',N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment',N'Generate',N'PersonStatus',N'EnglishLearnerStatus',N'Bad Value',NULL,NULL,N'where isnull(EnglishLearnerStatus,0) = 1 and EnglishLearner_StatusStartDate is null',N'The EnglishLearnerStatus is 1 but EnglishLearner_StatusStartDate is NULL','Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment',N'Generate',N'K12Organization',N'LEA_RecordStartDateTime',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment',N'Generate',N'K12Organization',N'LEA_IsReportedFederally',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment',N'Generate',N'K12Organization',N'School_RecordStartDateTime',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment',N'Generate',N'K12Organization',N'School_IsReportedFederally',N'Null Value',NULL,NULL,NULL,NULL,N'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C002',N'Generate',N'ProgramParticipationSpecialEducation',N'IDEAEducationalEnvironmentForSchoolAge',N'Null Value',NULL,NULL,NULL,NULL,N'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C089',N'Generate',N'ProgramParticipationSpecialEducation',N'IDEAEducationalEnvironmentForEarlyChildhood',N'Null Value',NULL,NULL,NULL,NULL,N'Warning')

INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'EnrollmentEntryDate', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'GradeLevel', N'Option Not Mapped', N'RefGradeLevel', N'000100', NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'HispanicLatinoEthnicity', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'LEA_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'Sex', N'Option Not Mapped', N'RefSex', NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'Student_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'LEA_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'LEA_OperationalStatus', N'Option Not Mapped', N'RefOperationalStatus', N'000174', NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'LEA_Type', N'Option Not Mapped', N'RefLEAType', NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'School_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'School_OperationalStatus', N'Option Not Mapped', N'RefOperationalStatus', N'000533', NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'School_Type', N'Option Not Mapped', N'RefSchoolType', NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonRace', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonRace', N'RaceType', N'Option Not Mapped', N'RefRace', NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonRace', N'SchoolYear', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonRace', N'Student_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'IDEAIndicator', N'Bad Value', NULL, NULL, N'where isnull(IDEAIndicator,0) = 0 and PrimaryDisabilityType is not null', N'Value is 0 or NULL but student has a PrimaryDisabilityType', 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'LEA_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'School_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'Student_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'ProgramParticipationSpecialEducation', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'ProgramParticipationSpecialEducation', N'LEA_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'ProgramParticipationSpecialEducation', N'ProgramParticipationBeginDate', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'ProgramParticipationSpecialEducation', N'School_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'ProgramParticipationSpecialEducation', N'Student_Identifier_State', N'Null Value', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'K12Organization', N'LEA_OperationalStatusEffectiveDate', N'Bad Value', NULL, NULL, N'where LEA_OperationalStatusEffectiveDate not between ''6/30/'' + convert(varchar, SchoolYear-1) and ''7/1/'' + convert(varchar, SchoolYear)', N'Operational Status Effective Date is not between dates of school year', 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'IDEAIndicator', N'Bad Value', NULL, NULL, N'where isnull(IDEAIndicator,0) = 1 and (IDEA_StatusStartDate is null or PrimaryDisabilityType is null)', N'Value is 1 but IDEA_StatusStartDate or PrimaryDisabilityType is NULL', 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'K12Enrollment', N'SchoolYear', N'Bad Value', NULL, NULL, N'where EnrollmentEntryDate > cast(''6/30/'' + convert(varchar, SchoolYear) as date)', N'Enrollment Entry Date does not match the School Year', 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'ChildCount, Exiting, Discipline, Assessment', N'Generate', N'PersonStatus', N'IDEAIndicator', N'Null Value', NULL, NULL, NULL, NULL, 'Warning')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Assessment', N'Generate', N'Assessment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Assessment', N'Generate', N'AssessmentResult', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Discipline', N'Generate', N'Discipline', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C190', N'Generate', N'CharterSchoolAuthorizer', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Personnel', N'Generate', N'K12StaffAssignment', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory', N'Generate', N'OrganizationAddress', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C029', N'Generate', N'OrganizationFederalFunding', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C190', N'Generate', N'OrganizationFederalFunding', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C039', N'Generate', N'OrganizationGradeOffered', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory', N'Generate', N'OrganizationProgramType', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'C029', N'Generate', N'OrganizationPhone', NULL, N'No Records', NULL, NULL, NULL, NULL, 'Error')
INSERT [Staging].[StagingValidationRules] ([ReportGroupOrCodes], [RuleDscr], [StagingTableName], [ColumnName], [ValidationType], [RefTableName], [TableFilter], [Condition], [ValidationMessage], [Severity]) VALUES (N'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment', N'Generate', N'StateDetail', NULL, N'No Records', NULL, NULL, NULL, NULL, N'Critical')

END