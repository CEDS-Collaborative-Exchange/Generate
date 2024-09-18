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

--Add rules to the staging Validation table 
insert into staging.StagingValidationRules
values 
('ChildCount, Exiting, Discipline','Generate','K12Enrollment','Birthdate','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c033','Generate','PersonStatus','EligibilityStatusForSchoolFoodServicePrograms','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c033','Generate','PersonStatus','NationalSchoolLunchProgramDirectCertificationIndicator','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','DisciplineMethodFirearm','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','DisciplineMethodFirearm','Option Not Mapped','RefDisciplineMethodFirearms',NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','IDEADisciplineMethodFirearm','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','IDEADisciplineMethodFirearm','Option Not Mapped','RefIDEADisciplineMethodFirearm',NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','FirearmType','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','FirearmType','Option Not Mapped','RefFirearmType',NULL,NULL,NULL,'Warning')

--update the existing group rules that apply to Membership
update staging.StagingValidationRules
set ReportGroupOrCodes = concat(ReportGroupOrCodes, ', Membership')
where StagingValidationRuleId in (1,2,3,4,6,7,8,9,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,42,44,57)


-- Add Staging Validation Rules ------------------------------------------
-- LEAs with conflicting values in some columns
insert into staging.StagingValidationRules
select 'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership', 'Generate', 'K12Organization', NULL, 'Bad Value', NULL, NULL, 
'where LEA_Identifier_State in (
select LEA_Identifier_State from (
		SELECT DISTINCT	
			LEA_Name
			, LEA_Identifier_NCES 
			, LEA_Identifier_State 
			, Prior_LEA_Identifier_State 
			, LEA_IsReportedFederally AS ReportedFederally
			, LEA_CharterLeaStatus
			, LEA_CharterSchoolIndicator
		FROM Staging.K12Organization) A
group by LEA_Identifier_State
having count(*) > 1)
',
'An LEA with different values in some columns will cause the RDS Migration to fail',
'Critical'

-- Conflicting Organization Phones
insert into staging.StagingValidationRules
select 'Directory',
'Generate', 
'OrganizationPhone', NULL, 'Bad Value', NULL, NULL, 
'where OrganizationIdentifier in (
select OrganizationIdentifier from (
		SELECT	
			OrganizationIdentifier
			, OrganizationType
			, InstitutionTelephoneNumberType 
			, RecordStartDateTime
		FROM Staging.OrganizationPhone) A
group by OrganizationIdentifier
having count(*) > 1
)
',
'An organization with multiple phone numbers of the same type will cause a merge error in the RDS migration',
'Critical'

-- PersonStatus should have an LEA and School Identifier that Exists in K12Organization
insert into staging.StagingValidationRules
select 'ChildCount, Exiting, Discipline, Assessment, Membership',
'Generate', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps 
left join Staging.K12Organization sko
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
where sko.LEA_Identifier_State is null and sko.School_Identifier_State is null
',
'One or more records in PersonStatus are associated with an LEA/School that does not exist in K12Enrollment',
'Warning'

-- PersonStatus student should exist in K12Enrollment
insert into staging.StagingValidationRules
select 'ChildCount, Exiting, Discipline, Assessment, Membership',
'Generate', 
'PersonStatus', NULL, 'Bad Value', NULL, NULL, 
' sps
left join Staging.K12Enrollment ske
	on isnull(sps.LEA_Identifier_State,'') = isnull(sko.LEA_Identifier_State,'')
	and isnull(sps.School_Identifier_State,'') = isnull(sko.School_Identifier_State,'')
	and sps.Student_Identifier_State = ske.Student_Identifier_State
where ske.Student_Identifier_State is null
',
'One or more records in PersonStatus do not have a student record in K12Enrollment',
'Warning'

-- StateDetail must have SchoolYear
insert into staging.StagingValidationRules
select 
	'Directory, ChildCount, Exiting, Discipline, Personnel, Assessment, Membership',
	'Generate',
	'StateDetail',
	'SchoolYear',
	'Null Value',
	NULL,
	NULL,
	NULL,
	'SchoolYear is missing',
	'Critical'


