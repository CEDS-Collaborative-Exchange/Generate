/***************************************************
Generate V12
This script populates a new table named App.GenerateStagingColumns.
It uses INFORMATION_SCHEMA.COLUMNS to get the columns for each staging
table, and also joins to a temp table of SourceSystemReferenceData information
to populate all of the columns used in App.GenerateStagingColumns.

This should run AFTER creation of App.GenerateStagingColumns in VersionScripts.
****************************************************/

IF OBJECT_ID(N'App.GenerateStagingColumns') IS NULL return -- In case the table doesn't exist.  

IF OBJECT_ID(N'tempdb..#SSRD') IS NOT NULL DROP TABLE #SSRD

CREATE TABLE #SSRD (
	[StagingTableName] [varchar](100) NULL,
	[StagingColumnName] [varchar](100) NULL,
	[RefTableName] [varchar](100) NULL,
	[TableFilter] [varchar](100) NULL
) ON [PRIMARY]

insert into #SSRD (StagingTableName, StagingColumnName, RefTableName, TableFilter)
VALUES ('K12Organization','LEA_OperationalStatus','RefOperationalStatus','000174')
,('K12Organization','LEA_Type','RefLeaType','')
,('K12Organization','LEA_CharterLeaStatus','RefCharterLeaStatus','')
,('K12Organization','LEA_GunFreeSchoolsActReportingStatus','RefGunFreeSchoolsActReportingStatus','')
,('K12Organization','LEA_TitleIInstructionalService','RefTitleIInstructionalServices','')
,('K12Organization','LEA_TitleIProgramType','RefTitleIProgramType','')
,('K12Organization','LEA_K12LeaTitleISupportService','RefK12LeaTitleISupportService','')
,('K12Organization','LEA_MEPProjectType','RefMepProjectType','')
,('K12Organization','School_Type','RefSchoolType','')
,('K12Organization','School_OperationalStatus','RefOperationalStatus','000533')
,('K12Organization','School_MagnetOrSpecialProgramEmphasisSchool','RefMagnetSpecialProgram','')
,('K12Organization','School_VirtualSchoolStatus','RefVirtualSchoolStatus','')
,('K12Organization','School_NationalSchoolLunchProgramStatus','RefNSLPStatus','')
,('K12Organization','School_ReconstitutedStatus','RefReconstitutedStatus','')
,('K12Organization','School_GunFreeSchoolsActReportingStatus','RefGunFreeSchoolsActReportingStatus','')
,('K12Organization','School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus','RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus','')
,('K12Organization','School_SchoolDangerousStatus','RefSchoolDangerousStatus','')
,('K12Organization','School_ComprehensiveAndTargetedSupport','RefComprehensiveAndTargetedSupport','')
,('K12Organization','School_ComprehensiveSupport','RefComprehensiveSupport','')
,('K12Organization','School_TargetedSupport','RefTargetedSupport','')
,('OrganizationAddress','AddressTypeForOrganization','RefOrganizationLocationType','')
,('OrganizationAddress','OrganizationType','RefOrganizationType','001156')
,('OrganizationPhone','InstitutionTelephoneNumberType','RefInstitutionTelephoneType','')
,('OrganizationPhone','OrganizationType','RefOrganizationType','001156')
,('OrganizationGradeOffered','','RefGradeLevel','000131')
,('K12Enrollment','ExitOrWithdrawalType','RefExitOrWithdrawalType','')
,('K12Enrollment','FoodServiceEligibility','RefFoodServiceEligibility','')
,('K12Enrollment','GradeLevel','RefGradeLevel','000100')
,('K12Enrollment','HighSchoolDiplomaType','RefHighSchoolDiplomaType','')
,('K12Enrollment','Sex','RefSex','')
,('K12PersonRace','RaceType','RefRace','')
,('PersonStatus','EligibilityStatusForSchoolFoodServicePrograms','RefFoodServiceEligibility','')
,('PersonStatus','HomelessNightTimeResidence','RefHomelessNighttimeResidence','')
,('PersonStatus','ISO_639_2_HomeLanguage','RefLanguage','')
,('PersonStatus','ISO_639_2_NativeLanguage','RefLanguage','')
,('PersonStatus','MilitaryConnectedStudentIndicator','RefMilitaryConnectedStudentIndicator','')
,('ProgramParticipationSpecialEducation','IDEAEducationalEnvironmentForEarlyChildhood','RefIDEAEducationalEnvironmentEC','')
,('ProgramParticipationSpecialEducation','IDEAEducationalEnvironmentForSchoolAge','RefIDEAEducationalEnvironmentSchoolAge','')
,('ProgramParticipationSpecialEducation','SpecialEducationExitReason','RefSpecialEducationExitReason','')
,('IdeaDisabilityType','IdeaDisabilityTypeCode','RefIdeaDisabilityType','')
,('Discipline','DisciplinaryActionTaken','RefDisciplinaryActionTaken','')
,('Discipline','DisciplineMethodFirearm','RefDisciplineMethodFirearms','')
,('Discipline','IdeaDisciplineMethodFirearm','RefIDEADisciplineMethodFirearm','')
,('Discipline','DisciplineMethodOfCwd','RefDisciplineMethodOfCwd','')
,('Discipline','DisciplineReason','RefDisciplineReason','')
,('Discipline','FirearmType','RefFirearmType','')
,('Discipline','IDEADisciplineMethodFirearm','RefIDEADisciplineMethodFirearm','')
,('Discipline','IdeaInterimRemoval','RefIdeaInterimRemoval','')
,('Discipline','IdeaInterimRemovalReason','RefIDEAInterimRemovalReason','')
,('K12StaffAssignment','EdFactsCertificationStatus','RefEdFactsCertificationStatus','')
,('K12StaffAssignment','EdFactsTeacherInexperiencedStatus','RefEdFactsTeacherInexperiencedStatus','')
,('K12StaffAssignment','EDFactsTeacherOutOfFieldStatus','RefOutOfFieldStatus','')
,('K12StaffAssignment','K12StaffClassification','RefK12StaffClassification','')
,('K12StaffAssignment','ParaprofessionalQualificationStatus','RefParaprofessionalQualification','')
,('K12StaffAssignment','ProgramTypeCode','RefProgramType','')
,('K12StaffAssignment','SpecialEducationAgeGroupTaught','RefSpecialEducationAgeGroupTaught','')
,('K12StaffAssignment','SpecialEducationStaffCategory','RefSpecialEducationStaffCategory','')
,('K12StaffAssignment','SpecialEducationTeacherQualificationStatus','RefSpecialEducationTeacherQualificationStatus','')
,('K12StaffAssignment','TeachingCredentialType','RefTeachingCredentialType','')
,('K12StaffAssignment','TitleIProgramStaffCategory','RefTitleIProgramStaffCategory','')
,('Assessment','AssessmentAcademicSubject','RefAcademicSubject','')
,('Assessment','AssessmentFamilyShortName','RefAssessmentFamilyShortName','')
,('Assessment','AssessmentPerformanceLevelIdentifier','AssessmentPerformanceLevel_Identifier','')
,('Assessment','AssessmentPurpose','RefAssessmentPurpose','')
,('Assessment','AssessmentType','RefAssessmentType','')
,('Assessment','AssessmentTypeAdministered','RefAssessmentTypeAdministered','')
,('Assessment','AssessmentTypeAdministeredToEnglishLearners','RefAssessmentTypeAdministeredToEnglishLearners','')
,('AssessmentResult','AssessmentAcademicSubject','RefAcademicSubject','')
,('AssessmentResult','AssessmentPerformanceLevelIdentifier','AssessmentPerformanceLevel_Identifier','')
,('AssessmentResult','AssessmentPurpose','RefAssessmentPurpose','')
,('AssessmentResult','AssessmentType','RefAssessmentType','')
,('AssessmentResult','AssessmentRegistrationReasonNotCompleting','RefAssessmentReasonNotCompleting','')
,('AssessmentResult','AssessmentRegistrationReasonNotTested','RefAssessmentReasonNotTested','')
,('AssessmentResult','AssessmentTypeAdministered','RefAssessmentTypeAdministered','')
,('AssessmentResult','AssessmentTypeAdministeredToEnglishLearners','RefAssessmentTypeAdministeredToEnglishLearners','')
,('AssessmentResult','GradeLevelWhenAssessed','RefGradeLevel','000126')

update #SSRD set TableFilter = NULL where TableFilter = ''

truncate table App.GenerateStagingColumns

insert into App.GenerateStagingColumns
SELECT distinct
	agst.StagingTableId,
       COLUMN_NAME ,
       DATA_TYPE ,
       CHARACTER_MAXIMUM_LENGTH ,
		tempSSRD.RefTableName,
		tempSSRD.TableFilter
FROM   INFORMATION_SCHEMA.COLUMNS isc
inner join app.GenerateStagingTables agst
	on isc.table_name = agst.StagingTableName
left join #SSRD tempSSRD
	on isc.Table_Name = tempssrd.StagingTableName 
	and isc.COLUMN_NAME = tempssrd.StagingColumnName
left join app.SourceSystemReferenceMapping_DomainFile_XREF x 
	on x.StagingTableId = agst.StagingTableId
	and x.CEDSReferenceTable = tempssrd.RefTableName
where table_schema = 'Staging' and column_name <> 'Id'

