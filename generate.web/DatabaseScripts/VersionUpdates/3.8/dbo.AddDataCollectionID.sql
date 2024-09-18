set nocount on
begin try
	begin transaction

    IF NOT EXISTS(SELECT 1 
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'dbo' and TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'RefDataCollectionStatus' )
		BEGIN

            /****** Object:  Table [dbo].[DataCollection]    Script Date: 12/14/2020 10:20:46 AM ******/
            set ansi_nulls on
    
            set quoted_identifier on

            create table [dbo].[RefDataCollectionStatus](
                [RefDataCollectionStatusId] [int] identity(1,1) not null,
                [Description] [nvarchar](200) null,
                [Code] [nvarchar](50) null,
                [Definition] [nvarchar](300) null,
                [RefJurisdictionId] [int] null,
                [SortOrder] [int] null,
                constraint [PK_RefDataCollectionStatus] primary key clustered 
            (
                [RefDataCollectionStatusId] asc
            )with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
            ) on [PRIMARY]


            insert into dbo.RefDataCollectionStatus (Description, Code, Definition, RefJurisdictionId, SortOrder) VALUES( '', 'Published', '', NULL, NULL)
            insert into dbo.RefDataCollectionStatus (Description, Code, Definition, RefJurisdictionId, SortOrder) VALUES( '', 'In Process', '', NULL, NULL)
            insert into dbo.RefDataCollectionStatus (Description, Code, Definition, RefJurisdictionId, SortOrder) VALUES( '', 'Retired', '', NULL, NULL)
      
      END

       IF NOT EXISTS(SELECT 1 
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'dbo' and TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'DataCollection' )
		BEGIN

            create table [dbo].[DataCollection](
                [DataCollectionId] [int] identity(1,1) not null,
                [SourceSystemDataCollectionIdentifier] [nvarchar](36) null,
                [SourceSystemName] [nvarchar](100) null,
                [DataCollectionName] [nvarchar](100) null,
                [DataCollectionDescription] [nvarchar](max) null,
                [DataCollectionOpenDate] [datetime] null,
                [DataCollectionCloseDate] [datetime] null,
                [DataCollectionAcademicSchoolYear] [nvarchar](4) null,
                [DataCollectionSchoolYear] [nvarchar](4) null,
                [RefDataCollectionStatusId] [int] null,
                constraint [PK_DataCollection] primary key clustered 
            (
                [DataCollectionId] asc
            )with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [PRIMARY]
            ) on [PRIMARY] textimage_on [PRIMARY]

    
            alter table [dbo].[DataCollection]  with nocheck add  constraint [FK_DataCollection_RefDataCollectionStatus] foreign key([RefDataCollectionStatusId])
            references [dbo].[RefDataCollectionStatus] ([RefDataCollectionStatusId])

    
            alter table [dbo].[DataCollection] check constraint [FK_DataCollection_RefDataCollectionStatus]

    END


    IF NOT EXISTS(select 1 from sys.columns where name = 'DataCollectionId' AND Object_ID = Object_ID(N'dbo.OrganizationDetail'))
    BEGIN

ALTER TABLE dbo.Activity ADD DataCollectionId INT NULL
ALTER TABLE dbo.ActivityRecognition ADD DataCollectionId INT NULL
ALTER TABLE dbo.AeCourse ADD DataCollectionId INT NULL
ALTER TABLE dbo.AeProvider ADD DataCollectionId INT NULL
ALTER TABLE dbo.AeStaff ADD DataCollectionId INT NULL
ALTER TABLE dbo.AeStudentAcademicRecord ADD DataCollectionId INT NULL
ALTER TABLE dbo.AeStudentEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.ApipInteraction ADD DataCollectionId INT NULL
ALTER TABLE dbo.Application ADD DataCollectionId INT NULL
ALTER TABLE dbo.Assessment ADD DataCollectionId INT NULL
ALTER TABLE dbo.Assessment_AssessmentAdministration ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentAccommodation ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentAdministration ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentAdministration_Organization ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentAsset ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentELDevelopmentalDomain ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentForm ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentForm_AssessmentAsset ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentForm_AssessmentFormSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentFormSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentFormSection_AssessmentAsset ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentFormSection_AssessmentItem ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItem ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemApip ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemApipDescription ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemCharacteristic ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemPossibleResponse ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemResponse ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemResponseTheory ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentItemRubricCriterionResult ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentLanguage ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentLevelsForWhichDesigned ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentNeedApipContent ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentNeedApipControl ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentNeedApipDisplay ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentNeedBraille ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentNeedScreenEnhancement ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentParticipantSession ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentParticipantSession_Accommodation ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPerformanceLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedLanguageLearner ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedScreenReader ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedsProfile ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedsProfileContent ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedsProfileControl ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedsProfileDisplay ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentPersonalNeedsProfileScreenEnhancement ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentRegistration ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentRegistration_Accommodation ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentResult ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentResult_PerformanceLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentResultRubricCriterionResult ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSession ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSessionStaffRole ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSubtest ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSubtest_AssessmentItem ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSubtest_CompetencyDefinition ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSubtestELDevelopmentalDomain ADD DataCollectionId INT NULL
ALTER TABLE dbo.AssessmentSubtestLevelsForWhichDesigned ADD DataCollectionId INT NULL
ALTER TABLE dbo.Authentication ADD DataCollectionId INT NULL
ALTER TABLE dbo.[Authorization] ADD DataCollectionId INT NULL
ALTER TABLE dbo.AuthorizationDocument ADD DataCollectionId INT NULL
ALTER TABLE dbo.BuildingSpace ADD DataCollectionId INT NULL
ALTER TABLE dbo.BuildingSpaceUtilization ADD DataCollectionId INT NULL
ALTER TABLE dbo.BuildingSystemCategory ADD DataCollectionId INT NULL
ALTER TABLE dbo.BuildingSystemComponent ADD DataCollectionId INT NULL
ALTER TABLE dbo.BuildingSystemComponentService ADD DataCollectionId INT NULL
--ALTER TABLE dbo.CharterSchoolApprovalAgency ADD DataCollectionId INT NULL
ALTER TABLE dbo.Classroom ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencyFramework ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencyDefAssociation ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencyDefinition ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencyDefEducationLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencyDefinition_CompetencySet ADD DataCollectionId INT NULL
ALTER TABLE dbo.CompetencySet ADD DataCollectionId INT NULL
ALTER TABLE dbo.CoreKnowledgeArea ADD DataCollectionId INT NULL
ALTER TABLE dbo.Course ADD DataCollectionId INT NULL
ALTER TABLE dbo.CourseSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.CourseSectionAssessmentReporting ADD DataCollectionId INT NULL
ALTER TABLE dbo.CourseSectionLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.CourseSectionLocation ADD DataCollectionId INT NULL
ALTER TABLE dbo.CourseSectionSchedule ADD DataCollectionId INT NULL
--ALTER TABLE dbo.Credential ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialAward ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialAwardCredit ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialAwardEvidence ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefAgent ADD DataCollectionId INT NULL
--ALTER TABLE dbo.CredentialCreator ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefAgentCredential ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefCategory ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefCriteria ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialCriteriaCourse ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefIdentifier ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialDefinition ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialIssuer ADD DataCollectionId INT NULL
ALTER TABLE dbo.CredentialOffered ADD DataCollectionId INT NULL
ALTER TABLE dbo.CteCourse ADD DataCollectionId INT NULL
ALTER TABLE dbo.CteStudentAcademicRecord ADD DataCollectionId INT NULL
ALTER TABLE dbo.EarlyChildhoodCredential ADD DataCollectionId INT NULL
ALTER TABLE dbo.EarlyChildhoodProgramTypeOffered ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildDemographic ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildDevelopmentalAssessment ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildHealth ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildIndividualizedProgram ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildOutcomeSummary ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildProgramEligibility ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildService ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildServicesApplication ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELChildTransitionPlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELClassSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELClassSectionService ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELEnrollmentOtherFunding ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELFacilityLicensing ADD DataCollectionId INT NULL
ALTER TABLE dbo.EligibilityEvaluation ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELOrganization ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELOrganizationAvailability ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELOrganizationFunds ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELOrganizationMonitoring ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELProgramLicensing ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELQualityInitiative ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELQualityRatingImprovement ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELServicePartner ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELStaff ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELStaffAssignment ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELStaffEducation ADD DataCollectionId INT NULL
ALTER TABLE dbo.ELStaffEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.Facility ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityAudit ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityCompliance ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityDesign ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityDesignConstruction ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityEnergy ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityFinance ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityFinancial ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityHazard ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityJointUse ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityLease ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityLocation ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityManagement ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityManagementPlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityMandate ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityMortgage ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityMortgageFee ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityRelationship ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilitySchoolDesign ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilitySite ADD DataCollectionId INT NULL
ALTER TABLE dbo.FacilityUtilization ADD DataCollectionId INT NULL
ALTER TABLE dbo.FinancialAccount ADD DataCollectionId INT NULL
ALTER TABLE dbo.FinancialAccountProgram ADD DataCollectionId INT NULL
ALTER TABLE dbo.FinancialAidApplication ADD DataCollectionId INT NULL
ALTER TABLE dbo.FinancialAidAward ADD DataCollectionId INT NULL
ALTER TABLE dbo.Goal ADD DataCollectionId INT NULL
ALTER TABLE dbo.GoalMeasurement ADD DataCollectionId INT NULL
ALTER TABLE dbo.GoalMeasurementCriterion ADD DataCollectionId INT NULL
ALTER TABLE dbo.GoalPerformance ADD DataCollectionId INT NULL
ALTER TABLE dbo.IDEAEligibilityEvaluationCategory ADD DataCollectionId INT NULL
ALTER TABLE dbo.IEPAuthorization ADD DataCollectionId INT NULL
ALTER TABLE dbo.IEPAuthorizationRejected ADD DataCollectionId INT NULL
ALTER TABLE dbo.IEPPresentLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.Incident ADD DataCollectionId INT NULL
ALTER TABLE dbo.IncidentPerson ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgram ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramAccommodation ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramAccommodationSubject ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramAmendment ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramAssessment ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramAssessmentAccommodation ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramEligibility ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramEligibilityEvaluation ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramGoal ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramMeeting ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramMeetingAttendee ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramProgressGoal ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramProgressReport ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramProgressReportPlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramService ADD DataCollectionId INT NULL
ALTER TABLE dbo.IndividualizedProgramServicesReceived ADD DataCollectionId INT NULL
ALTER TABLE dbo.IPEDSFinance ADD DataCollectionId INT NULL
--ALTER TABLE dbo.K12CharterSchoolApprovalAgency ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12CharterSchoolManagementOrganization ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12Course ADD DataCollectionId INT NULL
--ALTER TABLE dbo.K12Enrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12FederalFundAllocation ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12Lea ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaFederalFunds ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaFederalReporting ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaPreKEligibility ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaPreKEligibleAgesIDEA ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaSafeDrugFree ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaTitleIIIProfessionalDevelopment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12LeaTitleISupportService ADD DataCollectionId INT NULL
--ALTER TABLE dbo.K12Organization ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12OrganizationStudentResponsibility ADD DataCollectionId INT NULL
--ALTER TABLE dbo.K12ProgramEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12ProgramOrService ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12School ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SchoolCorrectiveAction ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SchoolGradeOffered ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SchoolImprovement ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SchoolIndicatorStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SchoolStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12Sea ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SeaAlternateFundUse ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12SeaFederalFunds ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StaffAssignment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StaffEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentAcademicHonor ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentAcademicRecord ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentActivity ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentCohort ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentCourseSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentCourseSectionMark ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentDiscipline ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentGraduationPlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentLiteracyAssessment ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12StudentSession ADD DataCollectionId INT NULL
ALTER TABLE dbo.K12TitleIIILanguageInstruction ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearnerAction ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearnerActivity ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearnerActivity_LearningResource ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResource ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResourceAdaptation ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResourceEducationLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResourceMediaFeature ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResourcePeerRating ADD DataCollectionId INT NULL
ALTER TABLE dbo.LearningResourcePhysicalMedia ADD DataCollectionId INT NULL
ALTER TABLE dbo.Location ADD DataCollectionId INT NULL
ALTER TABLE dbo.LocationAddress ADD DataCollectionId INT NULL
--ALTER TABLE dbo.MiK12StudentHsGraduationStatus ADD DataCollectionId INT NULL
--ALTER TABLE dbo.MiPsTermEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.Organization ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationAccreditation ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationAddress ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationCalendar ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationCalendarCrisis ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationCalendarDay ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationCalendarEvent ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationCalendarSession ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationCustomSchoolIndicatorStatusType ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationDetail ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationEmail ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationEmployeeBenefit ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationFederalAccountability ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationFederalFunding ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationFinancial ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationGradeOffered ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationIdentifier ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationImage ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationIndicator ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationLocation ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationOperationalStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationPersonRole ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationTelePhone ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationPolicy ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationProgramType ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationRelationship ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationSchoolComprehensiveAndTargetedSupport ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationSchoolIndicatorStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationService ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationTechnicalAssistance ADD DataCollectionId INT NULL
--ALTER TABLE dbo.OrganizationTelephone ADD DataCollectionId INT NULL
ALTER TABLE dbo.OrganizationWebsite ADD DataCollectionId INT NULL
ALTER TABLE dbo.PDActivityEducationLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.PeerRatingSystem ADD DataCollectionId INT NULL
ALTER TABLE dbo.Person ADD DataCollectionId INT NULL
ALTER TABLE dbo.Person_AssessmentPersonalNeedsProfile ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonAddress ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonAllergy ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonBirthplace ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonCareerEducationPlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonCredential ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonDegreeOrCertificate ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonDemographicRace ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonDetail ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonDisability ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonEmailAddress ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonFamily ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonHealth ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonHealthBirth ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonHomelessness ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonIdentifier ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonImmunization ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonLanguage ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonMaster ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonMilitary ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonOtherName ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonProgramParticipation ADD DataCollectionId INT NULL
--ALTER TABLE dbo.PersonRace ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonReferral ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonRelationship ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonStatus ADD DataCollectionId INT NULL
--ALTER TABLE dbo.PersonStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.PersonTelephone ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProfessionalDevelopmentActivity ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProfessionalDevelopmentRequirement ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProfessionalDevelopmentSession ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProfessionalDevelopmentSessionInstructor ADD DataCollectionId INT NULL
ALTER TABLE dbo.Program ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationAE ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationCte ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationFoodService ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationMigrant ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationNeglected ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationSpecialEducation ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationTeacherPrep ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationTitleI ADD DataCollectionId INT NULL
ALTER TABLE dbo.ProgramParticipationTitleIIILep ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsCourse ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsInstitution ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsPriceOfAttendance ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsProgram ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsSection ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsSectionLocation ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStaffEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentAcademicAward ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentAcademicRecord ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentAdmissionTest ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentApplication ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentCohort ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentCourseSectionMark ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentDemographic ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentFinancialAid ADD DataCollectionId INT NULL
ALTER TABLE dbo.PSStudentProgram ADD DataCollectionId INT NULL
ALTER TABLE dbo.PsStudentSection ADD DataCollectionId INT NULL
--ALTER TABLE dbo.PsTermEnrollment ADD DataCollectionId INT NULL
ALTER TABLE dbo.QuarterlyEmploymentRecord ADD DataCollectionId INT NULL
ALTER TABLE dbo.RequiredImmunization ADD DataCollectionId INT NULL
ALTER TABLE dbo.RoleAttendance ADD DataCollectionId INT NULL
ALTER TABLE dbo.RoleAttendanceEvent ADD DataCollectionId INT NULL
ALTER TABLE dbo.RoleStatus ADD DataCollectionId INT NULL
ALTER TABLE dbo.Rubric ADD DataCollectionId INT NULL
ALTER TABLE dbo.RubricCriterion ADD DataCollectionId INT NULL
ALTER TABLE dbo.RubricCriterionLevel ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServiceFrequency ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServicePlan ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServiceProvided ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServiceProvider ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServicesReceived ADD DataCollectionId INT NULL
ALTER TABLE dbo.ServiceStaff ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffCredential ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffEmployment ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffEvaluation ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffExperience ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffProfessionalDevelopmentActivity ADD DataCollectionId INT NULL
ALTER TABLE dbo.StaffTechnicalAssistance ADD DataCollectionId INT NULL
--ALTER TABLE dbo.StateDetail ADD DataCollectionId INT NULL
ALTER TABLE dbo.TeacherEducationCredentialExam ADD DataCollectionId INT NULL
ALTER TABLE dbo.TeacherStudentDataLinkExclusion ADD DataCollectionId INT NULL
ALTER TABLE dbo.WorkforceEmploymentQuarterlyData ADD DataCollectionId INT NULL
ALTER TABLE dbo.WorkforceProgramParticipation ADD DataCollectionId INT null
ALTER TABLE dbo.K12CharterSchoolAuthorizer ADD DataCollectionId INT null
ALTER TABLE dbo.OrganizationPersonRoleRelationship ADD DataCollectionId INT null
ALTER TABLE dbo.ProgramParticipationNeglectedProgressLevel ADD DataCollectionId INT null



ALTER TABLE dbo.Activity ADD CONSTRAINT FK_Activity_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ActivityRecognition ADD CONSTRAINT FK_ActivityRecognition_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AeCourse ADD CONSTRAINT FK_AeCourse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AeProvider ADD CONSTRAINT FK_AeProvider_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AeStaff ADD CONSTRAINT FK_AeStaff_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AeStudentAcademicRecord ADD CONSTRAINT FK_AeStudentAcademicRecord_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AeStudentEmployment ADD CONSTRAINT FK_AeStudentEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ApipInteraction ADD CONSTRAINT FK_ApipInteraction_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Application ADD CONSTRAINT FK_Application_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Assessment ADD CONSTRAINT FK_Assessment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Assessment_AssessmentAdministration ADD CONSTRAINT FK_Assessment_AssessmentAdministration_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentAccommodation ADD CONSTRAINT FK_AssessmentAccommodation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentAdministration ADD CONSTRAINT FK_AssessmentAdministration_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentAdministration_Organization ADD CONSTRAINT FK_AssessmentAdministration_Organization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentAsset ADD CONSTRAINT FK_AssessmentAsset_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentELDevelopmentalDomain ADD CONSTRAINT FK_AssessmentELDevelopmentalDomain_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentForm ADD CONSTRAINT FK_AssessmentForm_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentForm_AssessmentAsset ADD CONSTRAINT FK_AssessmentForm_AssessmentAsset_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentForm_AssessmentFormSection ADD CONSTRAINT FK_AssessmentForm_AssessmentFormSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentFormSection ADD CONSTRAINT FK_AssessmentFormSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentFormSection_AssessmentAsset ADD CONSTRAINT FK_AssessmentFormSection_AssessmentAsset_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentFormSection_AssessmentItem ADD CONSTRAINT FK_AssessmentFormSection_AssessmentItem_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItem ADD CONSTRAINT FK_AssessmentItem_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemApip ADD CONSTRAINT FK_AssessmentItemApip_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemApipDescription ADD CONSTRAINT FK_AssessmentItemApipDescription_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemCharacteristic ADD CONSTRAINT FK_AssessmentItemCharacteristic_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemPossibleResponse ADD CONSTRAINT FK_AssessmentItemPossibleResponse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemResponse ADD CONSTRAINT FK_AssessmentItemResponse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemResponseTheory ADD CONSTRAINT FK_AssessmentItemResponseTheory_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentItemRubricCriterionResult ADD CONSTRAINT FK_AssessmentItemRubricCriterionResult_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentLanguage ADD CONSTRAINT FK_AssessmentLanguage_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentLevelsForWhichDesigned ADD CONSTRAINT FK_AssessmentLevelsForWhichDesigned_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentNeedApipContent ADD CONSTRAINT FK_AssessmentNeedApipContent_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentNeedApipControl ADD CONSTRAINT FK_AssessmentNeedApipControl_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentNeedApipDisplay ADD CONSTRAINT FK_AssessmentNeedApipDisplay_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentNeedBraille ADD CONSTRAINT FK_AssessmentNeedBraille_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentNeedScreenEnhancement ADD CONSTRAINT FK_AssessmentNeedScreenEnhancement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentParticipantSession ADD CONSTRAINT FK_AssessmentParticipantSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentParticipantSession_Accommodation ADD CONSTRAINT FK_AssessmentParticipantSession_Accommodation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPerformanceLevel ADD CONSTRAINT FK_AssessmentPerformanceLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedLanguageLearner ADD CONSTRAINT FK_AssessmentPersonalNeedLanguageLearner_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedScreenReader ADD CONSTRAINT FK_AssessmentPersonalNeedScreenReader_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedsProfile ADD CONSTRAINT FK_AssessmentPersonalNeedsProfile_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedsProfileContent ADD CONSTRAINT FK_AssessmentPersonalNeedsProfileContent_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedsProfileControl ADD CONSTRAINT FK_AssessmentPersonalNeedsProfileControl_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedsProfileDisplay ADD CONSTRAINT FK_AssessmentPersonalNeedsProfileDisplay_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentPersonalNeedsProfileScreenEnhancement ADD CONSTRAINT FK_AssessmentPersonalNeedsProfileScreenEnhancement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentRegistration ADD CONSTRAINT FK_AssessmentRegistration_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentRegistration_Accommodation ADD CONSTRAINT FK_AssessmentRegistration_Accommodation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentResult ADD CONSTRAINT FK_AssessmentResult_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentResult_PerformanceLevel ADD CONSTRAINT FK_AssessmentResult_PerformanceLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentResultRubricCriterionResult ADD CONSTRAINT FK_AssessmentResultRubricCriterionResult_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSession ADD CONSTRAINT FK_AssessmentSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSessionStaffRole ADD CONSTRAINT FK_AssessmentSessionStaffRole_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSubtest ADD CONSTRAINT FK_AssessmentSubtest_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSubtest_AssessmentItem ADD CONSTRAINT FK_AssessmentSubtest_AssessmentItem_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSubtest_CompetencyDefinition ADD CONSTRAINT FK_AssessmentSubtest_CompetencyDefinition_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSubtestELDevelopmentalDomain ADD CONSTRAINT FK_AssessmentSubtestELDevelopmentalDomain_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AssessmentSubtestLevelsForWhichDesigned ADD CONSTRAINT FK_AssessmentSubtestLevelsForWhichDesigned_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Authentication ADD CONSTRAINT FK_Authentication_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.[Authorization] ADD CONSTRAINT FK_Authorization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.AuthorizationDocument ADD CONSTRAINT FK_AuthorizationDocument_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.BuildingSpace ADD CONSTRAINT FK_BuildingSpace_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.BuildingSpaceUtilization ADD CONSTRAINT FK_BuildingSpaceUtilization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.BuildingSystemCategory ADD CONSTRAINT FK_BuildingSystemCategory_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.BuildingSystemComponent ADD CONSTRAINT FK_BuildingSystemComponent_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.BuildingSystemComponentService ADD CONSTRAINT FK_BuildingSystemComponentService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CharterSchoolApprovalAgency ADD CONSTRAINT FK_CharterSchoolApprovalAgency_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Classroom ADD CONSTRAINT FK_Classroom_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CompetencyFramework ADD CONSTRAINT FK_CompetencyFramework_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CompetencyFrameworkItem ADD CONSTRAINT FK_CompetencyFrameworkItem_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CompetencyFrameworkItemAssociation ADD CONSTRAINT FK_CompetencyFrameworkItemAssociation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CompetencyFrameworkItemEducationLevel ADD CONSTRAINT FK_CompetencyFrameworkItemEducationLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CompetencyItem_CompetencySet ADD CONSTRAINT FK_CompetencyItem_CompetencySet_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CompetencySet ADD CONSTRAINT FK_CompetencySet_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CoreKnowledgeArea ADD CONSTRAINT FK_CoreKnowledgeArea_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Course ADD CONSTRAINT FK_Course_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CourseSection ADD CONSTRAINT FK_CourseSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CourseSectionAssessmentReporting ADD CONSTRAINT FK_CourseSectionAssessmentReporting_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CourseSectionLevel ADD CONSTRAINT FK_CourseSectionLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CourseSectionLocation ADD CONSTRAINT FK_CourseSectionLocation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CourseSectionSchedule ADD CONSTRAINT FK_CourseSectionSchedule_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.Credential ADD CONSTRAINT FK_Credential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CredentialAward ADD CONSTRAINT FK_CredentialAward_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CredentialAwardCredit ADD CONSTRAINT FK_CredentialAwardCredit_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CredentialAwardEvidence ADD CONSTRAINT FK_CredentialAwardEvidence_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialCategory ADD CONSTRAINT FK_CredentialCategory_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialCreator ADD CONSTRAINT FK_CredentialCreator_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialCreatorCredential ADD CONSTRAINT FK_CredentialCreatorCredential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialCriteria ADD CONSTRAINT FK_CredentialCriteria_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CredentialCriteriaCourse ADD CONSTRAINT FK_CredentialCriteriaCourse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialIdentifier ADD CONSTRAINT FK_CredentialIdentifier_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CredentialIssuer ADD CONSTRAINT FK_CredentialIssuer_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.CredentialIssuerCredential ADD CONSTRAINT FK_CredentialIssuerCredential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CteCourse ADD CONSTRAINT FK_CteCourse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.CteStudentAcademicRecord ADD CONSTRAINT FK_CteStudentAcademicRecord_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.DataCollection ADD CONSTRAINT FK_DataCollection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.EarlyChildhoodCredential ADD CONSTRAINT FK_EarlyChildhoodCredential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.EarlyChildhoodProgramTypeOffered ADD CONSTRAINT FK_EarlyChildhoodProgramTypeOffered_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildDemographic ADD CONSTRAINT FK_ELChildDemographic_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildDevelopmentalAssessment ADD CONSTRAINT FK_ELChildDevelopmentalAssessment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildHealth ADD CONSTRAINT FK_ELChildHealth_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildIndividualizedProgram ADD CONSTRAINT FK_ELChildIndividualizedProgram_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildOutcomeSummary ADD CONSTRAINT FK_ELChildOutcomeSummary_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildProgramEligibility ADD CONSTRAINT FK_ELChildProgramEligibility_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildService ADD CONSTRAINT FK_ELChildService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildServicesApplication ADD CONSTRAINT FK_ELChildServicesApplication_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELChildTransitionPlan ADD CONSTRAINT FK_ELChildTransitionPlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELClassSection ADD CONSTRAINT FK_ELClassSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELClassSectionService ADD CONSTRAINT FK_ELClassSectionService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELEnrollment ADD CONSTRAINT FK_ELEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELEnrollmentOtherFunding ADD CONSTRAINT FK_ELEnrollmentOtherFunding_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELFacilityLicensing ADD CONSTRAINT FK_ELFacilityLicensing_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.EligibilityEvaluation ADD CONSTRAINT FK_EligibilityEvaluation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELOrganization ADD CONSTRAINT FK_ELOrganization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELOrganizationAvailability ADD CONSTRAINT FK_ELOrganizationAvailability_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELOrganizationFunds ADD CONSTRAINT FK_ELOrganizationFunds_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELOrganizationMonitoring ADD CONSTRAINT FK_ELOrganizationMonitoring_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELProgramLicensing ADD CONSTRAINT FK_ELProgramLicensing_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELQualityInitiative ADD CONSTRAINT FK_ELQualityInitiative_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELQualityRatingImprovement ADD CONSTRAINT FK_ELQualityRatingImprovement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELServicePartner ADD CONSTRAINT FK_ELServicePartner_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELStaff ADD CONSTRAINT FK_ELStaff_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELStaffAssignment ADD CONSTRAINT FK_ELStaffAssignment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELStaffEducation ADD CONSTRAINT FK_ELStaffEducation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ELStaffEmployment ADD CONSTRAINT FK_ELStaffEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Facility ADD CONSTRAINT FK_Facility_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityAudit ADD CONSTRAINT FK_FacilityAudit_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityCompliance ADD CONSTRAINT FK_FacilityCompliance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityDesign ADD CONSTRAINT FK_FacilityDesign_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityDesignConstruction ADD CONSTRAINT FK_FacilityDesignConstruction_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityEnergy ADD CONSTRAINT FK_FacilityEnergy_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityFinance ADD CONSTRAINT FK_FacilityFinance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityFinancial ADD CONSTRAINT FK_FacilityFinancial_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityHazard ADD CONSTRAINT FK_FacilityHazard_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityJointUse ADD CONSTRAINT FK_FacilityJointUse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityLease ADD CONSTRAINT FK_FacilityLease_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityLocation ADD CONSTRAINT FK_FacilityLocation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityManagement ADD CONSTRAINT FK_FacilityManagement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityManagementPlan ADD CONSTRAINT FK_FacilityManagementPlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityMandate ADD CONSTRAINT FK_FacilityMandate_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityMortgage ADD CONSTRAINT FK_FacilityMortgage_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityMortgageFee ADD CONSTRAINT FK_FacilityMortgageFee_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityRelationship ADD CONSTRAINT FK_FacilityRelationship_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilitySchoolDesign ADD CONSTRAINT FK_FacilitySchoolDesign_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilitySite ADD CONSTRAINT FK_FacilitySite_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FacilityUtilization ADD CONSTRAINT FK_FacilityUtilization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FinancialAccount ADD CONSTRAINT FK_FinancialAccount_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FinancialAccountProgram ADD CONSTRAINT FK_FinancialAccountProgram_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FinancialAidApplication ADD CONSTRAINT FK_FinancialAidApplication_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.FinancialAidAward ADD CONSTRAINT FK_FinancialAidAward_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Goal ADD CONSTRAINT FK_Goal_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.GoalMeasurement ADD CONSTRAINT FK_GoalMeasurement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.GoalMeasurementCriterion ADD CONSTRAINT FK_GoalMeasurementCriterion_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.GoalPerformance ADD CONSTRAINT FK_GoalPerformance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IDEAEligibilityEvaluationCategory ADD CONSTRAINT FK_IDEAEligibilityEvaluationCategory_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IEPAuthorization ADD CONSTRAINT FK_IEPAuthorization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IEPAuthorizationRejected ADD CONSTRAINT FK_IEPAuthorizationRejected_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IEPPresentLevel ADD CONSTRAINT FK_IEPPresentLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Incident ADD CONSTRAINT FK_Incident_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IncidentPerson ADD CONSTRAINT FK_IncidentPerson_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgram ADD CONSTRAINT FK_IndividualizedProgram_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramAccommodation ADD CONSTRAINT FK_IndividualizedProgramAccommodation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramAccommodationSubject ADD CONSTRAINT FK_IndividualizedProgramAccommodationSubject_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramAmendment ADD CONSTRAINT FK_IndividualizedProgramAmendment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramAssessment ADD CONSTRAINT FK_IndividualizedProgramAssessment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramAssessmentAccommodation ADD CONSTRAINT FK_IndividualizedProgramAssessmentAccommodation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramEligibility ADD CONSTRAINT FK_IndividualizedProgramEligibility_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramEligibilityEvaluation ADD CONSTRAINT FK_IndividualizedProgramEligibilityEvaluation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramGoal ADD CONSTRAINT FK_IndividualizedProgramGoal_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramMeeting ADD CONSTRAINT FK_IndividualizedProgramMeeting_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramMeetingAttendee ADD CONSTRAINT FK_IndividualizedProgramMeetingAttendee_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramProgressGoal ADD CONSTRAINT FK_IndividualizedProgramProgressGoal_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramProgressReport ADD CONSTRAINT FK_IndividualizedProgramProgressReport_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramProgressReportPlan ADD CONSTRAINT FK_IndividualizedProgramProgressReportPlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramService ADD CONSTRAINT FK_IndividualizedProgramService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IndividualizedProgramServicesReceived ADD CONSTRAINT FK_IndividualizedProgramServicesReceived_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.IPEDSFinance ADD CONSTRAINT FK_IPEDSFinance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.K12CharterSchoolApprovalAgency ADD CONSTRAINT FK_K12CharterSchoolApprovalAgency_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12CharterSchoolManagementOrganization ADD CONSTRAINT FK_K12CharterSchoolManagementOrganization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12Course ADD CONSTRAINT FK_K12Course_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.K12Enrollment ADD CONSTRAINT FK_K12Enrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12FederalFundAllocation ADD CONSTRAINT FK_K12FederalFundAllocation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12Lea ADD CONSTRAINT FK_K12Lea_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaFederalFunds ADD CONSTRAINT FK_K12LeaFederalFunds_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaFederalReporting ADD CONSTRAINT FK_K12LeaFederalReporting_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaPreKEligibility ADD CONSTRAINT FK_K12LeaPreKEligibility_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaPreKEligibleAgesIDEA ADD CONSTRAINT FK_K12LeaPreKEligibleAgesIDEA_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaSafeDrugFree ADD CONSTRAINT FK_K12LeaSafeDrugFree_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaTitleIIIProfessionalDevelopment ADD CONSTRAINT FK_K12LeaTitleIIIProfessionalDevelopment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12LeaTitleISupportService ADD CONSTRAINT FK_K12LeaTitleISupportService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.K12Organization ADD CONSTRAINT FK_K12Organization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12OrganizationStudentResponsibility ADD CONSTRAINT FK_K12OrganizationStudentResponsibility_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.K12ProgramEnrollment ADD CONSTRAINT FK_K12ProgramEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12ProgramOrService ADD CONSTRAINT FK_K12ProgramOrService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12School ADD CONSTRAINT FK_K12School_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SchoolCorrectiveAction ADD CONSTRAINT FK_K12SchoolCorrectiveAction_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SchoolGradeOffered ADD CONSTRAINT FK_K12SchoolGradeOffered_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SchoolImprovement ADD CONSTRAINT FK_K12SchoolImprovement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SchoolIndicatorStatus ADD CONSTRAINT FK_K12SchoolIndicatorStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SchoolStatus ADD CONSTRAINT FK_K12SchoolStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12Sea ADD CONSTRAINT FK_K12Sea_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SeaAlternateFundUse ADD CONSTRAINT FK_K12SeaAlternateFundUse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12SeaFederalFunds ADD CONSTRAINT FK_K12SeaFederalFunds_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StaffAssignment ADD CONSTRAINT FK_K12StaffAssignment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StaffEmployment ADD CONSTRAINT FK_K12StaffEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentAcademicHonor ADD CONSTRAINT FK_K12StudentAcademicHonor_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentAcademicRecord ADD CONSTRAINT FK_K12StudentAcademicRecord_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentActivity ADD CONSTRAINT FK_K12StudentActivity_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentCohort ADD CONSTRAINT FK_K12StudentCohort_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentCourseSection ADD CONSTRAINT FK_K12StudentCourseSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentCourseSectionMark ADD CONSTRAINT FK_K12StudentCourseSectionMark_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentDiscipline ADD CONSTRAINT FK_K12StudentDiscipline_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentEmployment ADD CONSTRAINT FK_K12StudentEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentEnrollment ADD CONSTRAINT FK_K12StudentEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentGraduationPlan ADD CONSTRAINT FK_K12StudentGraduationPlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentLiteracyAssessment ADD CONSTRAINT FK_K12StudentLiteracyAssessment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12StudentSession ADD CONSTRAINT FK_K12StudentSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12TitleIIILanguageInstruction ADD CONSTRAINT FK_K12TitleIIILanguageInstruction_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearnerAction ADD CONSTRAINT FK_LearnerAction_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearnerActivity ADD CONSTRAINT FK_LearnerActivity_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearnerActivity_LearningResource ADD CONSTRAINT FK_LearnerActivity_LearningResource_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResource ADD CONSTRAINT FK_LearningResource_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResourceAdaptation ADD CONSTRAINT FK_LearningResourceAdaptation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResourceEducationLevel ADD CONSTRAINT FK_LearningResourceEducationLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResourceMediaFeature ADD CONSTRAINT FK_LearningResourceMediaFeature_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResourcePeerRating ADD CONSTRAINT FK_LearningResourcePeerRating_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LearningResourcePhysicalMedia ADD CONSTRAINT FK_LearningResourcePhysicalMedia_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Location ADD CONSTRAINT FK_Location_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.LocationAddress ADD CONSTRAINT FK_LocationAddress_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.MiK12StudentHsGraduationStatus ADD CONSTRAINT FK_MiK12StudentHsGraduationStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.MiPsTermEnrollment ADD CONSTRAINT FK_MiPsTermEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Organization ADD CONSTRAINT FK_Organization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationAccreditation ADD CONSTRAINT FK_OrganizationAccreditation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationAddress ADD CONSTRAINT FK_OrganizationAddress_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationCalendar ADD CONSTRAINT FK_OrganizationCalendar_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationCalendarCrisis ADD CONSTRAINT FK_OrganizationCalendarCrisis_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationCalendarDay ADD CONSTRAINT FK_OrganizationCalendarDay_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationCalendarEvent ADD CONSTRAINT FK_OrganizationCalendarEvent_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationCalendarSession ADD CONSTRAINT FK_OrganizationCalendarSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationCalendarSession ADD CONSTRAINT FK_OrganizationCalendarSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationCustomSchoolIndicatorStatusType ADD CONSTRAINT FK_OrganizationCustomSchoolIndicatorStatusType_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationDetail ADD CONSTRAINT FK_OrganizationDetail_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationEmail ADD CONSTRAINT FK_OrganizationEmail_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationEmployeeBenefit ADD CONSTRAINT FK_OrganizationEmployeeBenefit_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationFederalAccountability ADD CONSTRAINT FK_OrganizationFederalAccountability_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationFederalFunding ADD CONSTRAINT FK_OrganizationFederalFunding_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationFinancial ADD CONSTRAINT FK_OrganizationFinancial_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationGradeOffered ADD CONSTRAINT FK_OrganizationGradeOffered_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationIdentifier ADD CONSTRAINT FK_OrganizationIdentifier_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationImage ADD CONSTRAINT FK_OrganizationImage_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationIndicator ADD CONSTRAINT FK_OrganizationIndicator_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationLocation ADD CONSTRAINT FK_OrganizationLocation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationOperationalStatus ADD CONSTRAINT FK_OrganizationOperationalStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationPersonRole ADD CONSTRAINT FK_OrganizationPersonRole_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationTelePhone ADD CONSTRAINT FK_OrganizationTelePhone_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationPolicy ADD CONSTRAINT FK_OrganizationPolicy_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationProgramType ADD CONSTRAINT FK_OrganizationProgramType_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationRelationship ADD CONSTRAINT FK_OrganizationRelationship_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationSchoolComprehensiveAndTargetedSupport ADD CONSTRAINT FK_OrganizationSchoolComprehensiveAndTargetedSupport_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationSchoolIndicatorStatus ADD CONSTRAINT FK_OrganizationSchoolIndicatorStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationService ADD CONSTRAINT FK_OrganizationService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationTechnicalAssistance ADD CONSTRAINT FK_OrganizationTechnicalAssistance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.OrganizationTelephone ADD CONSTRAINT FK_OrganizationTelephone_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationWebsite ADD CONSTRAINT FK_OrganizationWebsite_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PDActivityEducationLevel ADD CONSTRAINT FK_PDActivityEducationLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PeerRatingSystem ADD CONSTRAINT FK_PeerRatingSystem_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Person ADD CONSTRAINT FK_Person_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.Person ADD CONSTRAINT FK_Person_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Person_AssessmentPersonalNeedsProfile ADD CONSTRAINT FK_Person_AssessmentPersonalNeedsProfile_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonAddress ADD CONSTRAINT FK_PersonAddress_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonAllergy ADD CONSTRAINT FK_PersonAllergy_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonBirthplace ADD CONSTRAINT FK_PersonBirthplace_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonCareerEducationPlan ADD CONSTRAINT FK_PersonCareerEducationPlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonCredential ADD CONSTRAINT FK_PersonCredential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonDegreeOrCertificate ADD CONSTRAINT FK_PersonDegreeOrCertificate_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonDemographicRace ADD CONSTRAINT FK_PersonDemographicRace_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonDetail ADD CONSTRAINT FK_PersonDetail_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonDisability ADD CONSTRAINT FK_PersonDisability_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonEmailAddress ADD CONSTRAINT FK_PersonEmailAddress_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonFamily ADD CONSTRAINT FK_PersonFamily_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonHealth ADD CONSTRAINT FK_PersonHealth_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonHealthBirth ADD CONSTRAINT FK_PersonHealthBirth_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonHomelessness ADD CONSTRAINT FK_PersonHomelessness_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonIdentifier ADD CONSTRAINT FK_PersonIdentifier_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonImmunization ADD CONSTRAINT FK_PersonImmunization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonLanguage ADD CONSTRAINT FK_PersonLanguage_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonMaster ADD CONSTRAINT FK_PersonMaster_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonMilitary ADD CONSTRAINT FK_PersonMilitary_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonOtherName ADD CONSTRAINT FK_PersonOtherName_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonProgramParticipation ADD CONSTRAINT FK_PersonProgramParticipation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.PersonRace ADD CONSTRAINT FK_PersonRace_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonReferral ADD CONSTRAINT FK_PersonReferral_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonRelationship ADD CONSTRAINT FK_PersonRelationship_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonStatus ADD CONSTRAINT FK_PersonStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.PersonStatus ADD CONSTRAINT FK_PersonStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PersonTelephone ADD CONSTRAINT FK_PersonTelephone_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProfessionalDevelopmentActivity ADD CONSTRAINT FK_ProfessionalDevelopmentActivity_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProfessionalDevelopmentRequirement ADD CONSTRAINT FK_ProfessionalDevelopmentRequirement_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProfessionalDevelopmentSession ADD CONSTRAINT FK_ProfessionalDevelopmentSession_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProfessionalDevelopmentSessionInstructor ADD CONSTRAINT FK_ProfessionalDevelopmentSessionInstructor_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Program ADD CONSTRAINT FK_Program_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationAE ADD CONSTRAINT FK_ProgramParticipationAE_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationCte ADD CONSTRAINT FK_ProgramParticipationCte_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationFoodService ADD CONSTRAINT FK_ProgramParticipationFoodService_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationMigrant ADD CONSTRAINT FK_ProgramParticipationMigrant_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationNeglected ADD CONSTRAINT FK_ProgramParticipationNeglected_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationSpecialEducation ADD CONSTRAINT FK_ProgramParticipationSpecialEducation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationTeacherPrep ADD CONSTRAINT FK_ProgramParticipationTeacherPrep_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationTitleI ADD CONSTRAINT FK_ProgramParticipationTitleI_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationTitleIIILep ADD CONSTRAINT FK_ProgramParticipationTitleIIILep_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsCourse ADD CONSTRAINT FK_PsCourse_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsInstitution ADD CONSTRAINT FK_PsInstitution_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsPriceOfAttendance ADD CONSTRAINT FK_PsPriceOfAttendance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsProgram ADD CONSTRAINT FK_PsProgram_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsSection ADD CONSTRAINT FK_PsSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsSectionLocation ADD CONSTRAINT FK_PsSectionLocation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStaffEmployment ADD CONSTRAINT FK_PsStaffEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentAcademicAward ADD CONSTRAINT FK_PsStudentAcademicAward_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentAcademicRecord ADD CONSTRAINT FK_PsStudentAcademicRecord_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentAdmissionTest ADD CONSTRAINT FK_PsStudentAdmissionTest_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentApplication ADD CONSTRAINT FK_PsStudentApplication_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentCohort ADD CONSTRAINT FK_PsStudentCohort_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentCourseSectionMark ADD CONSTRAINT FK_PsStudentCourseSectionMark_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentDemographic ADD CONSTRAINT FK_PsStudentDemographic_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentEmployment ADD CONSTRAINT FK_PsStudentEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentEnrollment ADD CONSTRAINT FK_PsStudentEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentFinancialAid ADD CONSTRAINT FK_PsStudentFinancialAid_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PSStudentProgram ADD CONSTRAINT FK_PSStudentProgram_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.PsStudentSection ADD CONSTRAINT FK_PsStudentSection_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.PsTermEnrollment ADD CONSTRAINT FK_PsTermEnrollment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.QuarterlyEmploymentRecord ADD CONSTRAINT FK_QuarterlyEmploymentRecord_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RequiredImmunization ADD CONSTRAINT FK_RequiredImmunization_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RoleAttendance ADD CONSTRAINT FK_RoleAttendance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RoleAttendanceEvent ADD CONSTRAINT FK_RoleAttendanceEvent_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RoleStatus ADD CONSTRAINT FK_RoleStatus_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.Rubric ADD CONSTRAINT FK_Rubric_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RubricCriterion ADD CONSTRAINT FK_RubricCriterion_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.RubricCriterionLevel ADD CONSTRAINT FK_RubricCriterionLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServiceFrequency ADD CONSTRAINT FK_ServiceFrequency_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServicePlan ADD CONSTRAINT FK_ServicePlan_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServiceProvided ADD CONSTRAINT FK_ServiceProvided_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServiceProvider ADD CONSTRAINT FK_ServiceProvider_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServicesReceived ADD CONSTRAINT FK_ServicesReceived_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ServiceStaff ADD CONSTRAINT FK_ServiceStaff_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffCredential ADD CONSTRAINT FK_StaffCredential_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffEmployment ADD CONSTRAINT FK_StaffEmployment_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffEvaluation ADD CONSTRAINT FK_StaffEvaluation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffExperience ADD CONSTRAINT FK_StaffExperience_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffProfessionalDevelopmentActivity ADD CONSTRAINT FK_StaffProfessionalDevelopmentActivity_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.StaffTechnicalAssistance ADD CONSTRAINT FK_StaffTechnicalAssistance_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
--ALTER TABLE dbo.StateDetail ADD CONSTRAINT FK_StateDetail_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.TeacherEducationCredentialExam ADD CONSTRAINT FK_TeacherEducationCredentialExam_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.TeacherStudentDataLinkExclusion ADD CONSTRAINT FK_TeacherStudentDataLinkExclusion_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.WorkforceEmploymentQuarterlyData ADD CONSTRAINT FK_WorkforceEmploymentQuarterlyData_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.WorkforceProgramParticipation ADD CONSTRAINT FK_WorkforceProgramParticipation_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.K12CharterSchoolAuthorizer ADD CONSTRAINT FK_K12CharterSchoolAuthorizer_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.OrganizationPersonRoleRelationship ADD CONSTRAINT FK_OrganizationPersonRoleRelationship_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);
ALTER TABLE dbo.ProgramParticipationNeglectedProgressLevel ADD CONSTRAINT FK_ProgramParticipationNeglectedProgressLevel_DataCollection FOREIGN KEY (DataCollectionId) REFERENCES dbo.DataCollection(DataCollectionId);

CREATE NONCLUSTERED INDEX IX_Activity_DataCollectionId ON dbo.Activity(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ActivityRecognition_DataCollectionId ON dbo.ActivityRecognition(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AeCourse_DataCollectionId ON dbo.AeCourse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AeProvider_DataCollectionId ON dbo.AeProvider(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AeStaff_DataCollectionId ON dbo.AeStaff(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AeStudentAcademicRecord_DataCollectionId ON dbo.AeStudentAcademicRecord(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AeStudentEmployment_DataCollectionId ON dbo.AeStudentEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ApipInteraction_DataCollectionId ON dbo.ApipInteraction(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Application_DataCollectionId ON dbo.Application(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Assessment_DataCollectionId ON dbo.Assessment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Assessment_AssessmentAdministration_DataCollectionId ON dbo.Assessment_AssessmentAdministration(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentAccommodation_DataCollectionId ON dbo.AssessmentAccommodation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentAdministration_DataCollectionId ON dbo.AssessmentAdministration(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentAdministration_Organization_DataCollectionId ON dbo.AssessmentAdministration_Organization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentAsset_DataCollectionId ON dbo.AssessmentAsset(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentELDevelopmentalDomain_DataCollectionId ON dbo.AssessmentELDevelopmentalDomain(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentForm_DataCollectionId ON dbo.AssessmentForm(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentForm_AssessmentAsset_DataCollectionId ON dbo.AssessmentForm_AssessmentAsset(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentForm_AssessmentFormSection_DataCollectionId ON dbo.AssessmentForm_AssessmentFormSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentFormSection_DataCollectionId ON dbo.AssessmentFormSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentFormSection_AssessmentAsset_DataCollectionId ON dbo.AssessmentFormSection_AssessmentAsset(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentFormSection_AssessmentItem_DataCollectionId ON dbo.AssessmentFormSection_AssessmentItem(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItem_DataCollectionId ON dbo.AssessmentItem(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemApip_DataCollectionId ON dbo.AssessmentItemApip(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemApipDescription_DataCollectionId ON dbo.AssessmentItemApipDescription(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemCharacteristic_DataCollectionId ON dbo.AssessmentItemCharacteristic(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemPossibleResponse_DataCollectionId ON dbo.AssessmentItemPossibleResponse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemResponse_DataCollectionId ON dbo.AssessmentItemResponse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemResponseTheory_DataCollectionId ON dbo.AssessmentItemResponseTheory(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentItemRubricCriterionResult_DataCollectionId ON dbo.AssessmentItemRubricCriterionResult(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentLanguage_DataCollectionId ON dbo.AssessmentLanguage(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentLevelsForWhichDesigned_DataCollectionId ON dbo.AssessmentLevelsForWhichDesigned(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentNeedApipContent_DataCollectionId ON dbo.AssessmentNeedApipContent(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentNeedApipControl_DataCollectionId ON dbo.AssessmentNeedApipControl(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentNeedApipDisplay_DataCollectionId ON dbo.AssessmentNeedApipDisplay(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentNeedBraille_DataCollectionId ON dbo.AssessmentNeedBraille(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentNeedScreenEnhancement_DataCollectionId ON dbo.AssessmentNeedScreenEnhancement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentParticipantSession_DataCollectionId ON dbo.AssessmentParticipantSession(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentParticipantSession_Accommodation_DataCollectionId ON dbo.AssessmentParticipantSession_Accommodation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPerformanceLevel_DataCollectionId ON dbo.AssessmentPerformanceLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedLanguageLearner_DataCollectionId ON dbo.AssessmentPersonalNeedLanguageLearner(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedScreenReader_DataCollectionId ON dbo.AssessmentPersonalNeedScreenReader(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedsProfile_DataCollectionId ON dbo.AssessmentPersonalNeedsProfile(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedsProfileContent_DataCollectionId ON dbo.AssessmentPersonalNeedsProfileContent(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedsProfileControl_DataCollectionId ON dbo.AssessmentPersonalNeedsProfileControl(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedsProfileDisplay_DataCollectionId ON dbo.AssessmentPersonalNeedsProfileDisplay(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentPersonalNeedsProfileScreenEnhancement_DataCollectionId ON dbo.AssessmentPersonalNeedsProfileScreenEnhancement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentRegistration_DataCollectionId ON dbo.AssessmentRegistration(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentRegistration_Accommodation_DataCollectionId ON dbo.AssessmentRegistration_Accommodation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentResult_DataCollectionId ON dbo.AssessmentResult(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentResult_PerformanceLevel_DataCollectionId ON dbo.AssessmentResult_PerformanceLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentResultRubricCriterionResult_DataCollectionId ON dbo.AssessmentResultRubricCriterionResult(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSession_DataCollectionId ON dbo.AssessmentSession(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSessionStaffRole_DataCollectionId ON dbo.AssessmentSessionStaffRole(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSubtest_DataCollectionId ON dbo.AssessmentSubtest(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSubtest_AssessmentItem_DataCollectionId ON dbo.AssessmentSubtest_AssessmentItem(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSubtest_CompetencyDefinition_DataCollectionId ON dbo.AssessmentSubtest_CompetencyDefinition(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSubtestELDevelopmentalDomain_DataCollectionId ON dbo.AssessmentSubtestELDevelopmentalDomain(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AssessmentSubtestLevelsForWhichDesigned_DataCollectionId ON dbo.AssessmentSubtestLevelsForWhichDesigned(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Authentication_DataCollectionId ON dbo.Authentication(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Authorization_DataCollectionId ON [dbo].[Authorization](DataCollectionId)
CREATE NONCLUSTERED INDEX IX_AuthorizationDocument_DataCollectionId ON dbo.AuthorizationDocument(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_BuildingSpace_DataCollectionId ON dbo.BuildingSpace(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_BuildingSpaceUtilization_DataCollectionId ON dbo.BuildingSpaceUtilization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_BuildingSystemCategory_DataCollectionId ON dbo.BuildingSystemCategory(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_BuildingSystemComponent_DataCollectionId ON dbo.BuildingSystemComponent(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_BuildingSystemComponentService_DataCollectionId ON dbo.BuildingSystemComponentService(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CharterSchoolApprovalAgency_DataCollectionId ON dbo.CharterSchoolApprovalAgency(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Classroom_DataCollectionId ON dbo.Classroom(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CompetencyFramework_DataCollectionId ON dbo.CompetencyFramework(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CompetencyFrameworkItem_DataCollectionId ON dbo.CompetencyFrameworkItem(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CompetencyFrameworkItemAssociation_DataCollectionId ON dbo.CompetencyFrameworkItemAssociation(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CompetencyFrameworkItemEducationLevel_DataCollectionId ON dbo.CompetencyFrameworkItemEducationLevel(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CompetencyItem_CompetencySet_DataCollectionId ON dbo.CompetencyItem_CompetencySet(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CompetencySet_DataCollectionId ON dbo.CompetencySet(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CoreKnowledgeArea_DataCollectionId ON dbo.CoreKnowledgeArea(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Course_DataCollectionId ON dbo.Course(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CourseSection_DataCollectionId ON dbo.CourseSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CourseSectionAssessmentReporting_DataCollectionId ON dbo.CourseSectionAssessmentReporting(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CourseSectionLevel_DataCollectionId ON dbo.CourseSectionLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CourseSectionLocation_DataCollectionId ON dbo.CourseSectionLocation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CourseSectionSchedule_DataCollectionId ON dbo.CourseSectionSchedule(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_Credential_DataCollectionId ON dbo.Credential(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CredentialAward_DataCollectionId ON dbo.CredentialAward(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CredentialAwardCredit_DataCollectionId ON dbo.CredentialAwardCredit(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CredentialAwardEvidence_DataCollectionId ON dbo.CredentialAwardEvidence(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialCategory_DataCollectionId ON dbo.CredentialCategory(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialCreator_DataCollectionId ON dbo.CredentialCreator(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialCreatorCredential_DataCollectionId ON dbo.CredentialCreatorCredential(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialCriteria_DataCollectionId ON dbo.CredentialCriteria(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CredentialCriteriaCourse_DataCollectionId ON dbo.CredentialCriteriaCourse(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialIdentifier_DataCollectionId ON dbo.CredentialIdentifier(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CredentialIssuer_DataCollectionId ON dbo.CredentialIssuer(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_CredentialIssuerCredential_DataCollectionId ON dbo.CredentialIssuerCredential(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CteCourse_DataCollectionId ON dbo.CteCourse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_CteStudentAcademicRecord_DataCollectionId ON dbo.CteStudentAcademicRecord(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_DataCollection_DataCollectionId ON dbo.DataCollection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_EarlyChildhoodCredential_DataCollectionId ON dbo.EarlyChildhoodCredential(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_EarlyChildhoodProgramTypeOffered_DataCollectionId ON dbo.EarlyChildhoodProgramTypeOffered(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildDemographic_DataCollectionId ON dbo.ELChildDemographic(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildDevelopmentalAssessment_DataCollectionId ON dbo.ELChildDevelopmentalAssessment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildHealth_DataCollectionId ON dbo.ELChildHealth(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildIndividualizedProgram_DataCollectionId ON dbo.ELChildIndividualizedProgram(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildOutcomeSummary_DataCollectionId ON dbo.ELChildOutcomeSummary(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildProgramEligibility_DataCollectionId ON dbo.ELChildProgramEligibility(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildService_DataCollectionId ON dbo.ELChildService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildServicesApplication_DataCollectionId ON dbo.ELChildServicesApplication(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELChildTransitionPlan_DataCollectionId ON dbo.ELChildTransitionPlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELClassSection_DataCollectionId ON dbo.ELClassSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELClassSectionService_DataCollectionId ON dbo.ELClassSectionService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELEnrollment_DataCollectionId ON dbo.ELEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELEnrollmentOtherFunding_DataCollectionId ON dbo.ELEnrollmentOtherFunding(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELFacilityLicensing_DataCollectionId ON dbo.ELFacilityLicensing(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_EligibilityEvaluation_DataCollectionId ON dbo.EligibilityEvaluation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELOrganization_DataCollectionId ON dbo.ELOrganization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELOrganizationAvailability_DataCollectionId ON dbo.ELOrganizationAvailability(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELOrganizationFunds_DataCollectionId ON dbo.ELOrganizationFunds(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELOrganizationMonitoring_DataCollectionId ON dbo.ELOrganizationMonitoring(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELProgramLicensing_DataCollectionId ON dbo.ELProgramLicensing(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELQualityInitiative_DataCollectionId ON dbo.ELQualityInitiative(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELQualityRatingImprovement_DataCollectionId ON dbo.ELQualityRatingImprovement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELServicePartner_DataCollectionId ON dbo.ELServicePartner(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELStaff_DataCollectionId ON dbo.ELStaff(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELStaffAssignment_DataCollectionId ON dbo.ELStaffAssignment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELStaffEducation_DataCollectionId ON dbo.ELStaffEducation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ELStaffEmployment_DataCollectionId ON dbo.ELStaffEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Facility_DataCollectionId ON dbo.Facility(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityAudit_DataCollectionId ON dbo.FacilityAudit(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityCompliance_DataCollectionId ON dbo.FacilityCompliance(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityDesign_DataCollectionId ON dbo.FacilityDesign(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityDesignConstruction_DataCollectionId ON dbo.FacilityDesignConstruction(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityEnergy_DataCollectionId ON dbo.FacilityEnergy(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityFinance_DataCollectionId ON dbo.FacilityFinance(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityFinancial_DataCollectionId ON dbo.FacilityFinancial(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityHazard_DataCollectionId ON dbo.FacilityHazard(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityJointUse_DataCollectionId ON dbo.FacilityJointUse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityLease_DataCollectionId ON dbo.FacilityLease(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityLocation_DataCollectionId ON dbo.FacilityLocation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityManagement_DataCollectionId ON dbo.FacilityManagement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityManagementPlan_DataCollectionId ON dbo.FacilityManagementPlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityMandate_DataCollectionId ON dbo.FacilityMandate(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityMortgage_DataCollectionId ON dbo.FacilityMortgage(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityMortgageFee_DataCollectionId ON dbo.FacilityMortgageFee(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityRelationship_DataCollectionId ON dbo.FacilityRelationship(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilitySchoolDesign_DataCollectionId ON dbo.FacilitySchoolDesign(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilitySite_DataCollectionId ON dbo.FacilitySite(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FacilityUtilization_DataCollectionId ON dbo.FacilityUtilization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FinancialAccount_DataCollectionId ON dbo.FinancialAccount(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FinancialAccountProgram_DataCollectionId ON dbo.FinancialAccountProgram(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FinancialAidApplication_DataCollectionId ON dbo.FinancialAidApplication(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_FinancialAidAward_DataCollectionId ON dbo.FinancialAidAward(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Goal_DataCollectionId ON dbo.Goal(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_GoalMeasurement_DataCollectionId ON dbo.GoalMeasurement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_GoalMeasurementCriterion_DataCollectionId ON dbo.GoalMeasurementCriterion(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_GoalPerformance_DataCollectionId ON dbo.GoalPerformance(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IDEAEligibilityEvaluationCategory_DataCollectionId ON dbo.IDEAEligibilityEvaluationCategory(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IEPAuthorization_DataCollectionId ON dbo.IEPAuthorization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IEPAuthorizationRejected_DataCollectionId ON dbo.IEPAuthorizationRejected(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IEPPresentLevel_DataCollectionId ON dbo.IEPPresentLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Incident_DataCollectionId ON dbo.Incident(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IncidentPerson_DataCollectionId ON dbo.IncidentPerson(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgram_DataCollectionId ON dbo.IndividualizedProgram(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramAccommodation_DataCollectionId ON dbo.IndividualizedProgramAccommodation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramAccommodationSubject_DataCollectionId ON dbo.IndividualizedProgramAccommodationSubject(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramAmendment_DataCollectionId ON dbo.IndividualizedProgramAmendment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramAssessment_DataCollectionId ON dbo.IndividualizedProgramAssessment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramAssessmentAccommodation_DataCollectionId ON dbo.IndividualizedProgramAssessmentAccommodation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramEligibility_DataCollectionId ON dbo.IndividualizedProgramEligibility(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramEligibilityEvaluation_DataCollectionId ON dbo.IndividualizedProgramEligibilityEvaluation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramGoal_DataCollectionId ON dbo.IndividualizedProgramGoal(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramMeeting_DataCollectionId ON dbo.IndividualizedProgramMeeting(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramMeetingAttendee_DataCollectionId ON dbo.IndividualizedProgramMeetingAttendee(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramProgressGoal_DataCollectionId ON dbo.IndividualizedProgramProgressGoal(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramProgressReport_DataCollectionId ON dbo.IndividualizedProgramProgressReport(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramProgressReportPlan_DataCollectionId ON dbo.IndividualizedProgramProgressReportPlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramService_DataCollectionId ON dbo.IndividualizedProgramService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IndividualizedProgramServicesReceived_DataCollectionId ON dbo.IndividualizedProgramServicesReceived(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_IPEDSFinance_DataCollectionId ON dbo.IPEDSFinance(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_K12CharterSchoolApprovalAgency_DataCollectionId ON dbo.K12CharterSchoolApprovalAgency(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12CharterSchoolManagementOrganization_DataCollectionId ON dbo.K12CharterSchoolManagementOrganization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12Course_DataCollectionId ON dbo.K12Course(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_K12Enrollment_DataCollectionId ON dbo.K12Enrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12FederalFundAllocation_DataCollectionId ON dbo.K12FederalFundAllocation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12Lea_DataCollectionId ON dbo.K12Lea(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaFederalFunds_DataCollectionId ON dbo.K12LeaFederalFunds(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaFederalReporting_DataCollectionId ON dbo.K12LeaFederalReporting(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaPreKEligibility_DataCollectionId ON dbo.K12LeaPreKEligibility(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaPreKEligibleAgesIDEA_DataCollectionId ON dbo.K12LeaPreKEligibleAgesIDEA(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaSafeDrugFree_DataCollectionId ON dbo.K12LeaSafeDrugFree(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaTitleIIIProfessionalDevelopment_DataCollectionId ON dbo.K12LeaTitleIIIProfessionalDevelopment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12LeaTitleISupportService_DataCollectionId ON dbo.K12LeaTitleISupportService(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_K12Organization_DataCollectionId ON dbo.K12Organization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12OrganizationStudentResponsibility_DataCollectionId ON dbo.K12OrganizationStudentResponsibility(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_K12ProgramEnrollment_DataCollectionId ON dbo.K12ProgramEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12ProgramOrService_DataCollectionId ON dbo.K12ProgramOrService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12School_DataCollectionId ON dbo.K12School(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SchoolCorrectiveAction_DataCollectionId ON dbo.K12SchoolCorrectiveAction(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SchoolGradeOffered_DataCollectionId ON dbo.K12SchoolGradeOffered(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SchoolImprovement_DataCollectionId ON dbo.K12SchoolImprovement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SchoolIndicatorStatus_DataCollectionId ON dbo.K12SchoolIndicatorStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SchoolStatus_DataCollectionId ON dbo.K12SchoolStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12Sea_DataCollectionId ON dbo.K12Sea(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SeaAlternateFundUse_DataCollectionId ON dbo.K12SeaAlternateFundUse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12SeaFederalFunds_DataCollectionId ON dbo.K12SeaFederalFunds(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StaffAssignment_DataCollectionId ON dbo.K12StaffAssignment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StaffEmployment_DataCollectionId ON dbo.K12StaffEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentAcademicHonor_DataCollectionId ON dbo.K12StudentAcademicHonor(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentAcademicRecord_DataCollectionId ON dbo.K12StudentAcademicRecord(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentActivity_DataCollectionId ON dbo.K12StudentActivity(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentCohort_DataCollectionId ON dbo.K12StudentCohort(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentCourseSection_DataCollectionId ON dbo.K12StudentCourseSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentCourseSectionMark_DataCollectionId ON dbo.K12StudentCourseSectionMark(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentDiscipline_DataCollectionId ON dbo.K12StudentDiscipline(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentEmployment_DataCollectionId ON dbo.K12StudentEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentEnrollment_DataCollectionId ON dbo.K12StudentEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentGraduationPlan_DataCollectionId ON dbo.K12StudentGraduationPlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentLiteracyAssessment_DataCollectionId ON dbo.K12StudentLiteracyAssessment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12StudentSession_DataCollectionId ON dbo.K12StudentSession(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12TitleIIILanguageInstruction_DataCollectionId ON dbo.K12TitleIIILanguageInstruction(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearnerAction_DataCollectionId ON dbo.LearnerAction(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearnerActivity_DataCollectionId ON dbo.LearnerActivity(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearnerActivity_LearningResource_DataCollectionId ON dbo.LearnerActivity_LearningResource(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResource_DataCollectionId ON dbo.LearningResource(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResourceAdaptation_DataCollectionId ON dbo.LearningResourceAdaptation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResourceEducationLevel_DataCollectionId ON dbo.LearningResourceEducationLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResourceMediaFeature_DataCollectionId ON dbo.LearningResourceMediaFeature(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResourcePeerRating_DataCollectionId ON dbo.LearningResourcePeerRating(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LearningResourcePhysicalMedia_DataCollectionId ON dbo.LearningResourcePhysicalMedia(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Location_DataCollectionId ON dbo.Location(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_LocationAddress_DataCollectionId ON dbo.LocationAddress(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_MiK12StudentHsGraduationStatus_DataCollectionId ON dbo.MiK12StudentHsGraduationStatus(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_MiPsTermEnrollment_DataCollectionId ON dbo.MiPsTermEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Organization_DataCollectionId ON dbo.Organization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationAccreditation_DataCollectionId ON dbo.OrganizationAccreditation(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationAddress_DataCollectionId ON dbo.OrganizationAddress(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationCalendar_DataCollectionId ON dbo.OrganizationCalendar(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationCalendarCrisis_DataCollectionId ON dbo.OrganizationCalendarCrisis(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationCalendarDay_DataCollectionId ON dbo.OrganizationCalendarDay(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationCalendarEvent_DataCollectionId ON dbo.OrganizationCalendarEvent(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationCalendarSession_DataCollectionId ON dbo.OrganizationCalendarSession(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationCalendarSession_DataCollectionId ON dbo.OrganizationCalendarSession(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationCustomSchoolIndicatorStatusType_DataCollectionId ON dbo.OrganizationCustomSchoolIndicatorStatusType(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationDetail_DataCollectionId ON dbo.OrganizationDetail(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationEmail_DataCollectionId ON dbo.OrganizationEmail(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationEmployeeBenefit_DataCollectionId ON dbo.OrganizationEmployeeBenefit(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationFederalAccountability_DataCollectionId ON dbo.OrganizationFederalAccountability(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationFederalFunding_DataCollectionId ON dbo.OrganizationFederalFunding(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationFinancial_DataCollectionId ON dbo.OrganizationFinancial(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationGradeOffered_DataCollectionId ON dbo.OrganizationGradeOffered(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationIdentifier_DataCollectionId ON dbo.OrganizationIdentifier(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationImage_DataCollectionId ON dbo.OrganizationImage(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationIndicator_DataCollectionId ON dbo.OrganizationIndicator(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationLocation_DataCollectionId ON dbo.OrganizationLocation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationOperationalStatus_DataCollectionId ON dbo.OrganizationOperationalStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationPersonRole_DataCollectionId ON dbo.OrganizationPersonRole(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationTelePhone_DataCollectionId ON dbo.OrganizationTelePhone(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationPolicy_DataCollectionId ON dbo.OrganizationPolicy(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationProgramType_DataCollectionId ON dbo.OrganizationProgramType(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationRelationship_DataCollectionId ON dbo.OrganizationRelationship(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationSchoolComprehensiveAndTargetedSupport_DataCollectionId ON dbo.OrganizationSchoolComprehensiveAndTargetedSupport(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationSchoolIndicatorStatus_DataCollectionId ON dbo.OrganizationSchoolIndicatorStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationService_DataCollectionId ON dbo.OrganizationService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationTechnicalAssistance_DataCollectionId ON dbo.OrganizationTechnicalAssistance(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_OrganizationTelephone_DataCollectionId ON dbo.OrganizationTelephone(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationWebsite_DataCollectionId ON dbo.OrganizationWebsite(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PDActivityEducationLevel_DataCollectionId ON dbo.PDActivityEducationLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PeerRatingSystem_DataCollectionId ON dbo.PeerRatingSystem(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Person_DataCollectionId ON dbo.Person(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_Person_DataCollectionId ON dbo.Person(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Person_AssessmentPersonalNeedsProfile_DataCollectionId ON dbo.Person_AssessmentPersonalNeedsProfile(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonAddress_DataCollectionId ON dbo.PersonAddress(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonAllergy_DataCollectionId ON dbo.PersonAllergy(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonBirthplace_DataCollectionId ON dbo.PersonBirthplace(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonCareerEducationPlan_DataCollectionId ON dbo.PersonCareerEducationPlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonCredential_DataCollectionId ON dbo.PersonCredential(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonDegreeOrCertificate_DataCollectionId ON dbo.PersonDegreeOrCertificate(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonDemographicRace_DataCollectionId ON dbo.PersonDemographicRace(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonDetail_DataCollectionId ON dbo.PersonDetail(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonDisability_DataCollectionId ON dbo.PersonDisability(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonEmailAddress_DataCollectionId ON dbo.PersonEmailAddress(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonFamily_DataCollectionId ON dbo.PersonFamily(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonHealth_DataCollectionId ON dbo.PersonHealth(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonHealthBirth_DataCollectionId ON dbo.PersonHealthBirth(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonHomelessness_DataCollectionId ON dbo.PersonHomelessness(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonIdentifier_DataCollectionId ON dbo.PersonIdentifier(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonImmunization_DataCollectionId ON dbo.PersonImmunization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonLanguage_DataCollectionId ON dbo.PersonLanguage(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonMaster_DataCollectionId ON dbo.PersonMaster(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonMilitary_DataCollectionId ON dbo.PersonMilitary(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonOtherName_DataCollectionId ON dbo.PersonOtherName(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonProgramParticipation_DataCollectionId ON dbo.PersonProgramParticipation(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_PersonRace_DataCollectionId ON dbo.PersonRace(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonReferral_DataCollectionId ON dbo.PersonReferral(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonRelationship_DataCollectionId ON dbo.PersonRelationship(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonStatus_DataCollectionId ON dbo.PersonStatus(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_PersonStatus_DataCollectionId ON dbo.PersonStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PersonTelephone_DataCollectionId ON dbo.PersonTelephone(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProfessionalDevelopmentActivity_DataCollectionId ON dbo.ProfessionalDevelopmentActivity(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProfessionalDevelopmentRequirement_DataCollectionId ON dbo.ProfessionalDevelopmentRequirement(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProfessionalDevelopmentSession_DataCollectionId ON dbo.ProfessionalDevelopmentSession(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProfessionalDevelopmentSessionInstructor_DataCollectionId ON dbo.ProfessionalDevelopmentSessionInstructor(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Program_DataCollectionId ON dbo.Program(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationAE_DataCollectionId ON dbo.ProgramParticipationAE(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationCte_DataCollectionId ON dbo.ProgramParticipationCte(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationFoodService_DataCollectionId ON dbo.ProgramParticipationFoodService(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationMigrant_DataCollectionId ON dbo.ProgramParticipationMigrant(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationNeglected_DataCollectionId ON dbo.ProgramParticipationNeglected(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationSpecialEducation_DataCollectionId ON dbo.ProgramParticipationSpecialEducation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationTeacherPrep_DataCollectionId ON dbo.ProgramParticipationTeacherPrep(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationTitleI_DataCollectionId ON dbo.ProgramParticipationTitleI(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationTitleIIILep_DataCollectionId ON dbo.ProgramParticipationTitleIIILep(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsCourse_DataCollectionId ON dbo.PsCourse(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsInstitution_DataCollectionId ON dbo.PsInstitution(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsPriceOfAttendance_DataCollectionId ON dbo.PsPriceOfAttendance(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsProgram_DataCollectionId ON dbo.PsProgram(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsSection_DataCollectionId ON dbo.PsSection(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsSectionLocation_DataCollectionId ON dbo.PsSectionLocation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStaffEmployment_DataCollectionId ON dbo.PsStaffEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentAcademicAward_DataCollectionId ON dbo.PsStudentAcademicAward(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentAcademicRecord_DataCollectionId ON dbo.PsStudentAcademicRecord(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentAdmissionTest_DataCollectionId ON dbo.PsStudentAdmissionTest(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentApplication_DataCollectionId ON dbo.PsStudentApplication(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentCohort_DataCollectionId ON dbo.PsStudentCohort(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentCourseSectionMark_DataCollectionId ON dbo.PsStudentCourseSectionMark(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentDemographic_DataCollectionId ON dbo.PsStudentDemographic(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentEmployment_DataCollectionId ON dbo.PsStudentEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentEnrollment_DataCollectionId ON dbo.PsStudentEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentFinancialAid_DataCollectionId ON dbo.PsStudentFinancialAid(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PSStudentProgram_DataCollectionId ON dbo.PSStudentProgram(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_PsStudentSection_DataCollectionId ON dbo.PsStudentSection(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_PsTermEnrollment_DataCollectionId ON dbo.PsTermEnrollment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_QuarterlyEmploymentRecord_DataCollectionId ON dbo.QuarterlyEmploymentRecord(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RequiredImmunization_DataCollectionId ON dbo.RequiredImmunization(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RoleAttendance_DataCollectionId ON dbo.RoleAttendance(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RoleAttendanceEvent_DataCollectionId ON dbo.RoleAttendanceEvent(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RoleStatus_DataCollectionId ON dbo.RoleStatus(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_Rubric_DataCollectionId ON dbo.Rubric(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RubricCriterion_DataCollectionId ON dbo.RubricCriterion(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_RubricCriterionLevel_DataCollectionId ON dbo.RubricCriterionLevel(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServiceFrequency_DataCollectionId ON dbo.ServiceFrequency(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServicePlan_DataCollectionId ON dbo.ServicePlan(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServiceProvided_DataCollectionId ON dbo.ServiceProvided(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServiceProvider_DataCollectionId ON dbo.ServiceProvider(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServicesReceived_DataCollectionId ON dbo.ServicesReceived(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ServiceStaff_DataCollectionId ON dbo.ServiceStaff(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffCredential_DataCollectionId ON dbo.StaffCredential(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffEmployment_DataCollectionId ON dbo.StaffEmployment(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffEvaluation_DataCollectionId ON dbo.StaffEvaluation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffExperience_DataCollectionId ON dbo.StaffExperience(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffProfessionalDevelopmentActivity_DataCollectionId ON dbo.StaffProfessionalDevelopmentActivity(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_StaffTechnicalAssistance_DataCollectionId ON dbo.StaffTechnicalAssistance(DataCollectionId)
--CREATE NONCLUSTERED INDEX IX_StateDetail_DataCollectionId ON dbo.StateDetail(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_TeacherEducationCredentialExam_DataCollectionId ON dbo.TeacherEducationCredentialExam(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_TeacherStudentDataLinkExclusion_DataCollectionId ON dbo.TeacherStudentDataLinkExclusion(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_WorkforceEmploymentQuarterlyData_DataCollectionId ON dbo.WorkforceEmploymentQuarterlyData(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_WorkforceProgramParticipation_DataCollectionId ON dbo.WorkforceProgramParticipation(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_K12CharterSchoolAuthorizer_DataCollectionId ON dbo.K12CharterSchoolAuthorizer(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_OrganizationPersonRoleRelationship_DataCollectionId ON dbo.OrganizationPersonRoleRelationship(DataCollectionId)
CREATE NONCLUSTERED INDEX IX_ProgramParticipationNeglectedProgressLevel_DataCollectionId ON dbo.ProgramParticipationNeglectedProgressLevel(DataCollectionId)

END


commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off