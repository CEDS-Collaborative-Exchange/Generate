using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using generate.core.Models.IDS;
using System.IO;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using generate.core.Config;

namespace generate.infrastructure.Contexts
{
    public partial class IDSDbContext : DbContext
    {

        private readonly ILogger _logger;
        private readonly IOptions<AppSettings> _appSettings;

        public IDSDbContext(DbContextOptions<IDSDbContext> options, ILogger<IDSDbContext> logger, IOptions<AppSettings> appSettings) : base(options)
        {
            _logger = logger;
            _appSettings = appSettings;

        }


        public void ExecuteInitializeScripts(string scriptPath)
        {
            _logger.LogInformation("ODSDbContext - ExecuteInitializeScripts - " + scriptPath);

            //DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();

            scriptFiles.Add("generate-ceds-nds-v6.sql");
            scriptFiles.Add("generate-Populate-CEDS-V6-Ref-Tables.sql");

            if (_appSettings.Value.Environment.ToLower() != "development" && _appSettings.Value.Environment.ToLower() != "test")
            {
                scriptFiles.Add("ODS.Organization.seed.sql");
                scriptFiles.Add("ODS.Role.seed.sql");
            }

            scriptFiles.Add("ODS.AssessmentRegistration.alter.sql");
            scriptFiles.Add("ODS.StaffCredential.alter-drop.sql");
            scriptFiles.Add("ODS.StaffCredential.alter-add.sql");


            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("ODSDbContext - Executing (Start) - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);

                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

                _logger.LogInformation("ODSDbContext - Executing (End) - " + scriptFile);

            }

            _logger.LogInformation("ODSDbContext - ExecuteInitializeScripts - end");

        }

        public void ExecuteDatabaseScript(string script)
        {
            int? oldTimeout = Database.GetCommandTimeout();
            Database.SetCommandTimeout(8000);
            Database.ExecuteSqlRaw(script);
            Database.SetCommandTimeout(oldTimeout);
        }

        public virtual DbSet<Achievement> Achievement { get; set; }
        public virtual DbSet<AchievementEvidence> AchievementEvidence { get; set; }
        public virtual DbSet<Activity> Activity { get; set; }
        public virtual DbSet<ActivityRecognition> ActivityRecognition { get; set; }
        public virtual DbSet<AeCourse> AeCourse { get; set; }
        public virtual DbSet<AeProvider> AeProvider { get; set; }
        public virtual DbSet<AeStaff> AeStaff { get; set; }
        public virtual DbSet<AeStudentAcademicRecord> AeStudentAcademicRecord { get; set; }
        public virtual DbSet<AeStudentEmployment> AeStudentEmployment { get; set; }
        public virtual DbSet<ApipInteraction> ApipInteraction { get; set; }
        public virtual DbSet<Application> Application { get; set; }
        public virtual DbSet<Assessment> Assessment { get; set; }
        public virtual DbSet<AssessmentAdministration> AssessmentAdministration { get; set; }
        public virtual DbSet<AssessmentAdministrationOrganization> AssessmentAdministrationOrganization { get; set; }
        public virtual DbSet<AssessmentAssessmentAdministration> AssessmentAssessmentAdministration { get; set; }
        public virtual DbSet<AssessmentAsset> AssessmentAsset { get; set; }
        public virtual DbSet<AssessmentEldevelopmentalDomain> AssessmentEldevelopmentalDomain { get; set; }
        public virtual DbSet<AssessmentForm> AssessmentForm { get; set; }
        public virtual DbSet<AssessmentFormAssessmentAsset> AssessmentFormAssessmentAsset { get; set; }
        public virtual DbSet<AssessmentFormAssessmentFormSection> AssessmentFormAssessmentFormSection { get; set; }
        public virtual DbSet<AssessmentFormSection> AssessmentFormSection { get; set; }
        public virtual DbSet<AssessmentFormSectionAssessmentAsset> AssessmentFormSectionAssessmentAsset { get; set; }
        public virtual DbSet<AssessmentFormSectionAssessmentItem> AssessmentFormSectionAssessmentItem { get; set; }
        public virtual DbSet<AssessmentItem> AssessmentItem { get; set; }
        public virtual DbSet<AssessmentItemApip> AssessmentItemApip { get; set; }
        public virtual DbSet<AssessmentItemApipDescription> AssessmentItemApipDescription { get; set; }
        public virtual DbSet<AssessmentItemCharacteristic> AssessmentItemCharacteristic { get; set; }
        public virtual DbSet<AssessmentItemPossibleResponse> AssessmentItemPossibleResponse { get; set; }
        public virtual DbSet<AssessmentItemResponse> AssessmentItemResponse { get; set; }
        public virtual DbSet<AssessmentItemResponseTheory> AssessmentItemResponseTheory { get; set; }
        public virtual DbSet<AssessmentItemRubricCriterionResult> AssessmentItemRubricCriterionResult { get; set; }
        public virtual DbSet<AssessmentLanguage> AssessmentLanguage { get; set; }
        public virtual DbSet<AssessmentLevelsForWhichDesigned> AssessmentLevelsForWhichDesigned { get; set; }
        public virtual DbSet<AssessmentNeedApipContent> AssessmentNeedApipContent { get; set; }
        public virtual DbSet<AssessmentNeedApipControl> AssessmentNeedApipControl { get; set; }
        public virtual DbSet<AssessmentNeedApipDisplay> AssessmentNeedApipDisplay { get; set; }
        public virtual DbSet<AssessmentNeedBraille> AssessmentNeedBraille { get; set; }
        public virtual DbSet<AssessmentNeedScreenEnhancement> AssessmentNeedScreenEnhancement { get; set; }
        public virtual DbSet<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual DbSet<AssessmentParticipantSessionAccommodation> AssessmentParticipantSessionAccommodation { get; set; }
        public virtual DbSet<AssessmentPerformanceLevel> AssessmentPerformanceLevel { get; set; }
        public virtual DbSet<AssessmentPersonalNeedLanguageLearner> AssessmentPersonalNeedLanguageLearner { get; set; }
        public virtual DbSet<AssessmentPersonalNeedScreenReader> AssessmentPersonalNeedScreenReader { get; set; }
        public virtual DbSet<AssessmentPersonalNeedsProfile> AssessmentPersonalNeedsProfile { get; set; }
        public virtual DbSet<AssessmentPersonalNeedsProfileContent> AssessmentPersonalNeedsProfileContent { get; set; }
        public virtual DbSet<AssessmentPersonalNeedsProfileControl> AssessmentPersonalNeedsProfileControl { get; set; }
        public virtual DbSet<AssessmentPersonalNeedsProfileDisplay> AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual DbSet<AssessmentPersonalNeedsProfileScreenEnhancement> AssessmentPersonalNeedsProfileScreenEnhancement { get; set; }
        public virtual DbSet<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual DbSet<AssessmentRegistrationAccommodation> AssessmentRegistrationAccommodation { get; set; }
        public virtual DbSet<AssessmentResult> AssessmentResult { get; set; }
        public virtual DbSet<AssessmentResult_PerformanceLevel> AssessmentResultPerformanceLevel { get; set; }
        public virtual DbSet<AssessmentResultRubricCriterionResult> AssessmentResultRubricCriterionResult { get; set; }
        public virtual DbSet<AssessmentSession> AssessmentSession { get; set; }
        public virtual DbSet<AssessmentSessionStaffRole> AssessmentSessionStaffRole { get; set; }
        public virtual DbSet<AssessmentSubtest> AssessmentSubtest { get; set; }
        public virtual DbSet<AssessmentSubtestAssessmentItem> AssessmentSubtestAssessmentItem { get; set; }
        public virtual DbSet<AssessmentSubtestEldevelopmentalDomain> AssessmentSubtestEldevelopmentalDomain { get; set; }
        public virtual DbSet<AssessmentSubtestLearningStandardItem> AssessmentSubtestLearningStandardItem { get; set; }
        public virtual DbSet<AssessmentSubtestLevelsForWhichDesigned> AssessmentSubtestLevelsForWhichDesigned { get; set; }
        public virtual DbSet<Authentication> Authentication { get; set; }
        public virtual DbSet<Authorization> Authorization { get; set; }
        public virtual DbSet<Classroom> Classroom { get; set; }
        public virtual DbSet<CompetencyItemCompetencySet> CompetencyItemCompetencySet { get; set; }
        public virtual DbSet<CompetencySet> CompetencySet { get; set; }
        public virtual DbSet<CoreKnowledgeArea> CoreKnowledgeArea { get; set; }
        public virtual DbSet<Course> Course { get; set; }
        public virtual DbSet<CourseSection> CourseSection { get; set; }
        public virtual DbSet<CourseSectionAssessmentReporting> CourseSectionAssessmentReporting { get; set; }
        public virtual DbSet<CourseSectionLocation> CourseSectionLocation { get; set; }
        public virtual DbSet<CourseSectionSchedule> CourseSectionSchedule { get; set; }
        public virtual DbSet<CteCourse> CteCourse { get; set; }
        public virtual DbSet<CteStudentAcademicRecord> CteStudentAcademicRecord { get; set; }
        public virtual DbSet<EarlyChildhoodCredential> EarlyChildhoodCredential { get; set; }
        public virtual DbSet<EarlyChildhoodProgramTypeOffered> EarlyChildhoodProgramTypeOffered { get; set; }
        public virtual DbSet<ElchildDemographic> ElchildDemographic { get; set; }
        public virtual DbSet<ElchildDevelopmentalAssessment> ElchildDevelopmentalAssessment { get; set; }
        public virtual DbSet<ElchildHealth> ElchildHealth { get; set; }
        public virtual DbSet<ElchildIndividualizedProgram> ElchildIndividualizedProgram { get; set; }
        public virtual DbSet<ElchildOutcomeSummary> ElchildOutcomeSummary { get; set; }
        public virtual DbSet<ElchildProgramEligibility> ElchildProgramEligibility { get; set; }
        public virtual DbSet<ElchildService> ElchildService { get; set; }
        public virtual DbSet<ElchildServicesApplication> ElchildServicesApplication { get; set; }
        public virtual DbSet<ElchildTransitionPlan> ElchildTransitionPlan { get; set; }
        public virtual DbSet<ElclassSection> ElclassSection { get; set; }
        public virtual DbSet<ElclassSectionService> ElclassSectionService { get; set; }
        public virtual DbSet<Elenrollment> Elenrollment { get; set; }
        public virtual DbSet<ElenrollmentOtherFunding> ElenrollmentOtherFunding { get; set; }
        public virtual DbSet<ElfacilityLicensing> ElfacilityLicensing { get; set; }
        public virtual DbSet<ElorganizationAvailability> ElorganizationAvailability { get; set; }
        public virtual DbSet<ElorganizationFunds> ElorganizationFunds { get; set; }
        public virtual DbSet<ElorganizationMonitoring> ElorganizationMonitoring { get; set; }
        public virtual DbSet<ElprogramLicensing> ElprogramLicensing { get; set; }
        public virtual DbSet<ElqualityInitiative> ElqualityInitiative { get; set; }
        public virtual DbSet<ElqualityRatingImprovement> ElqualityRatingImprovement { get; set; }
        public virtual DbSet<ElservicePartner> ElservicePartner { get; set; }
        public virtual DbSet<Elstaff> Elstaff { get; set; }
        public virtual DbSet<ElstaffAssignment> ElstaffAssignment { get; set; }
        public virtual DbSet<ElstaffEducation> ElstaffEducation { get; set; }
        public virtual DbSet<ElstaffEmployment> ElstaffEmployment { get; set; }
        public virtual DbSet<Facility> Facility { get; set; }
        public virtual DbSet<FinancialAccount> FinancialAccount { get; set; }
        public virtual DbSet<FinancialAccountProgram> FinancialAccountProgram { get; set; }
        public virtual DbSet<FinancialAidApplication> FinancialAidApplication { get; set; }
        public virtual DbSet<FinancialAidAward> FinancialAidAward { get; set; }
        public virtual DbSet<Incident> Incident { get; set; }
        public virtual DbSet<IncidentPerson> IncidentPerson { get; set; }
        public virtual DbSet<IndividualizedProgram> IndividualizedProgram { get; set; }
        public virtual DbSet<IndividualizedProgramService> IndividualizedProgramService { get; set; }
        public virtual DbSet<K12course> K12course { get; set; }
        public virtual DbSet<K12lea> K12lea { get; set; }
        public virtual DbSet<K12LeaFederalFunds> K12leaFederalFunds { get; set; }
        public virtual DbSet<K12leaFederalReporting> K12leaFederalReporting { get; set; }
        public virtual DbSet<K12leaPreKeligibility> K12leaPreKeligibility { get; set; }
        public virtual DbSet<K12leaPreKeligibleAgesIdea> K12leaPreKeligibleAgesIdea { get; set; }
        public virtual DbSet<K12leaSafeDrugFree> K12leaSafeDrugFree { get; set; }
        public virtual DbSet<K12leaTitleIiiprofessionalDevelopment> K12leaTitleIiiprofessionalDevelopment { get; set; }
        public virtual DbSet<K12leaTitleIsupportService> K12leaTitleIsupportService { get; set; }
        public virtual DbSet<K12organizationStudentResponsibility> K12organizationStudentResponsibility { get; set; }
        public virtual DbSet<K12programOrService> K12programOrService { get; set; }
        public virtual DbSet<K12school> K12school { get; set; }
        public virtual DbSet<K12schoolCorrectiveAction> K12schoolCorrectiveAction { get; set; }
        public virtual DbSet<K12schoolGradeOffered> K12schoolGradeOffered { get; set; }
        public virtual DbSet<K12schoolImprovement> K12schoolImprovement { get; set; }
		public virtual DbSet<K12schoolIndicatorStatus> K12schoolIndicatorStatus { get; set; }
		public virtual DbSet<K12schoolStatus> K12schoolStatus { get; set; }
        public virtual DbSet<K12sea> K12sea { get; set; }
        public virtual DbSet<K12seaAlternateFundUse> K12seaAlternateFundUse { get; set; }

        //TODO - Remove K12seaFederalFundAllocation
        // public virtual DbSet<K12seaFederalFundAllocation> K12seaFederalFundAllocation { get; set; }

        public virtual DbSet<K12FederalFundAllocation> K12FederalFundAllocation { get; set; }


        public virtual DbSet<K12CharterSchoolAuthorizer> K12CharterSchoolAuthorizer { get; set; }
        public virtual DbSet<K12CharterSchoolManagementOrganization> K12CharterSchoolManagementOrganization { get; set; }
        public virtual DbSet<K12seaFederalFunds> K12seaFederalFunds { get; set; }
        public virtual DbSet<K12staffAssignment> K12staffAssignment { get; set; }
        public virtual DbSet<K12staffEmployment> K12staffEmployment { get; set; }
        public virtual DbSet<K12studentAcademicHonor> K12studentAcademicHonor { get; set; }
        public virtual DbSet<K12studentAcademicRecord> K12studentAcademicRecord { get; set; }
        public virtual DbSet<K12studentActivity> K12studentActivity { get; set; }
        public virtual DbSet<K12studentCohort> K12studentCohort { get; set; }
        public virtual DbSet<K12studentCourseSection> K12studentCourseSection { get; set; }
        public virtual DbSet<K12studentCourseSectionMark> K12studentCourseSectionMark { get; set; }
        public virtual DbSet<K12studentDiscipline> K12studentDiscipline { get; set; }
        public virtual DbSet<K12studentEmployment> K12studentEmployment { get; set; }
        public virtual DbSet<K12studentEnrollment> K12studentEnrollment { get; set; }
        public virtual DbSet<K12studentGraduationPlan> K12studentGraduationPlan { get; set; }
        public virtual DbSet<K12studentLiteracyAssessment> K12studentLiteracyAssessment { get; set; }
        public virtual DbSet<K12studentSession> K12studentSession { get; set; }
        public virtual DbSet<K12titleIiilanguageInstruction> K12titleIiilanguageInstruction { get; set; }
        public virtual DbSet<LearnerAction> LearnerAction { get; set; }
        public virtual DbSet<LearnerActivity> LearnerActivity { get; set; }
        public virtual DbSet<LearnerActivityLearningResource> LearnerActivityLearningResource { get; set; }
        public virtual DbSet<LearningGoal> LearningGoal { get; set; }
        public virtual DbSet<LearningResource> LearningResource { get; set; }
        public virtual DbSet<LearningResourceAdaptation> LearningResourceAdaptation { get; set; }
        public virtual DbSet<LearningResourceEducationLevel> LearningResourceEducationLevel { get; set; }
        public virtual DbSet<LearningResourceMediaFeature> LearningResourceMediaFeature { get; set; }
        public virtual DbSet<LearningResourcePeerRating> LearningResourcePeerRating { get; set; }
        public virtual DbSet<LearningResourcePhysicalMedia> LearningResourcePhysicalMedia { get; set; }
        public virtual DbSet<LearningStandardDocument> LearningStandardDocument { get; set; }
        public virtual DbSet<LearningStandardItem> LearningStandardItem { get; set; }
        public virtual DbSet<LearningStandardItemAssociation> LearningStandardItemAssociation { get; set; }
        public virtual DbSet<LearningStandardItemEducationLevel> LearningStandardItemEducationLevel { get; set; }
        public virtual DbSet<Location> Location { get; set; }
        public virtual DbSet<LocationAddress> LocationAddress { get; set; }
        public virtual DbSet<Organization> Organization { get; set; }
        public virtual DbSet<OrganizationAccreditation> OrganizationAccreditation { get; set; }
        public virtual DbSet<OrganizationCalendar> OrganizationCalendar { get; set; }
        public virtual DbSet<OrganizationCalendarCrisis> OrganizationCalendarCrisis { get; set; }
        public virtual DbSet<OrganizationCalendarDay> OrganizationCalendarDay { get; set; }
        public virtual DbSet<OrganizationCalendarEvent> OrganizationCalendarEvent { get; set; }
        public virtual DbSet<OrganizationCalendarSession> OrganizationCalendarSession { get; set; }
        public virtual DbSet<OrganizationDetail> OrganizationDetail { get; set; }
        public virtual DbSet<OrganizationEmail> OrganizationEmail { get; set; }
        public virtual DbSet<OrganizationFederalAccountability> OrganizationFederalAccountability { get; set; }
        public virtual DbSet<OrganizationFinancial> OrganizationFinancial { get; set; }
        public virtual DbSet<OrganizationIdentifier> OrganizationIdentifier { get; set; }
        public virtual DbSet<OrganizationIndicator> OrganizationIndicator { get; set; }
        public virtual DbSet<OrganizationLocation> OrganizationLocation { get; set; }
        public virtual DbSet<OrganizationOperationalStatus> OrganizationOperationalStatus { get; set; }
        public virtual DbSet<OrganizationPersonRole> OrganizationPersonRole { get; set; }
        public virtual DbSet<OrganizationPolicy> OrganizationPolicy { get; set; }
        public virtual DbSet<OrganizationProgramType> OrganizationProgramType { get; set; }
        public virtual DbSet<OrganizationRelationship> OrganizationRelationship { get; set; }
        public virtual DbSet<OrganizationTechnicalAssistance> OrganizationTechnicalAssistance { get; set; }
        public virtual DbSet<OrganizationTelephone> OrganizationTelephone { get; set; }
        public virtual DbSet<OrganizationWebsite> OrganizationWebsite { get; set; }
        public virtual DbSet<PdactivityEducationLevel> PdactivityEducationLevel { get; set; }
        public virtual DbSet<PeerRatingSystem> PeerRatingSystem { get; set; }
        public virtual DbSet<Person> Person { get; set; }
        public virtual DbSet<PersonAddress> PersonAddress { get; set; }
        public virtual DbSet<PersonAllergy> PersonAllergy { get; set; }
        public virtual DbSet<PersonAssessmentPersonalNeedsProfile> PersonAssessmentPersonalNeedsProfile { get; set; }
        public virtual DbSet<PersonBirthplace> PersonBirthplace { get; set; }
        public virtual DbSet<PersonCareerEducationPlan> PersonCareerEducationPlan { get; set; }
        public virtual DbSet<PersonCredential> PersonCredential { get; set; }
        public virtual DbSet<PersonDegreeOrCertificate> PersonDegreeOrCertificate { get; set; }
        public virtual DbSet<PersonDemographicRace> PersonDemographicRace { get; set; }
        public virtual DbSet<PersonDetail> PersonDetail { get; set; }
        public virtual DbSet<PersonDisability> PersonDisability { get; set; }
        public virtual DbSet<PersonEmailAddress> PersonEmailAddress { get; set; }
        public virtual DbSet<PersonFamily> PersonFamily { get; set; }
        public virtual DbSet<PersonHealth> PersonHealth { get; set; }
        public virtual DbSet<PersonHealthBirth> PersonHealthBirth { get; set; }
        public virtual DbSet<PersonHomelessness> PersonHomelessness { get; set; }
        public virtual DbSet<PersonIdentifier> PersonIdentifier { get; set; }
        public virtual DbSet<PersonImmunization> PersonImmunization { get; set; }
        public virtual DbSet<PersonLanguage> PersonLanguage { get; set; }
        public virtual DbSet<PersonMaster> PersonMaster { get; set; }
        public virtual DbSet<PersonMilitary> PersonMilitary { get; set; }
        public virtual DbSet<PersonOtherName> PersonOtherName { get; set; }
        public virtual DbSet<PersonProgramParticipation> PersonProgramParticipation { get; set; }
        public virtual DbSet<PersonReferral> PersonReferral { get; set; }
        public virtual DbSet<PersonRelationship> PersonRelationship { get; set; }
        public virtual DbSet<PersonStatus> PersonStatus { get; set; }
        public virtual DbSet<PersonTelephone> PersonTelephone { get; set; }
        public virtual DbSet<ProfessionalDevelopmentActivity> ProfessionalDevelopmentActivity { get; set; }
        public virtual DbSet<ProfessionalDevelopmentRequirement> ProfessionalDevelopmentRequirement { get; set; }
        public virtual DbSet<ProfessionalDevelopmentSession> ProfessionalDevelopmentSession { get; set; }
        public virtual DbSet<ProfessionalDevelopmentSessionInstructor> ProfessionalDevelopmentSessionInstructor { get; set; }
        public virtual DbSet<Program> Program { get; set; }
        public virtual DbSet<ProgramParticipationAe> ProgramParticipationAe { get; set; }
        public virtual DbSet<ProgramParticipationCte> ProgramParticipationCte { get; set; }
        public virtual DbSet<ProgramParticipationFoodService> ProgramParticipationFoodService { get; set; }
        public virtual DbSet<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual DbSet<ProgramParticipationNeglected> ProgramParticipationNeglected { get; set; }
        public virtual DbSet<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducation { get; set; }
        public virtual DbSet<ProgramParticipationTeacherPrep> ProgramParticipationTeacherPrep { get; set; }
        public virtual DbSet<ProgramParticipationTitleI> ProgramParticipationTitleI { get; set; }
        public virtual DbSet<ProgramParticipationTitleIiilep> ProgramParticipationTitleIiilep { get; set; }
        public virtual DbSet<PsCourse> PsCourse { get; set; }
        public virtual DbSet<PsInstitution> PsInstitution { get; set; }
        public virtual DbSet<PsPriceOfAttendance> PsPriceOfAttendance { get; set; }
        public virtual DbSet<PsProgram> PsProgram { get; set; }
        public virtual DbSet<PsSection> PsSection { get; set; }
        public virtual DbSet<PsSectionLocation> PsSectionLocation { get; set; }
        public virtual DbSet<PsStaffEmployment> PsStaffEmployment { get; set; }
        public virtual DbSet<PsStudentAcademicAward> PsStudentAcademicAward { get; set; }
        public virtual DbSet<PsStudentAcademicRecord> PsStudentAcademicRecord { get; set; }
        public virtual DbSet<PsStudentAdmissionTest> PsStudentAdmissionTest { get; set; }
        public virtual DbSet<PsStudentApplication> PsStudentApplication { get; set; }
        public virtual DbSet<PsStudentCohort> PsStudentCohort { get; set; }
        public virtual DbSet<PsStudentCourseSectionMark> PsStudentCourseSectionMark { get; set; }
        public virtual DbSet<PsStudentDemographic> PsStudentDemographic { get; set; }
        public virtual DbSet<PsStudentEmployment> PsStudentEmployment { get; set; }
        public virtual DbSet<PsStudentEnrollment> PsStudentEnrollment { get; set; }
        public virtual DbSet<PsStudentFinancialAid> PsStudentFinancialAid { get; set; }
        public virtual DbSet<PsStudentSection> PsStudentSection { get; set; }
        public virtual DbSet<PsstudentProgram> PsstudentProgram { get; set; }
        public virtual DbSet<QuarterlyEmploymentRecord> QuarterlyEmploymentRecord { get; set; }
        public virtual DbSet<RefAbsentAttendanceCategory> RefAbsentAttendanceCategory { get; set; }
        public virtual DbSet<RefAcademicAwardLevel> RefAcademicAwardLevel { get; set; }
        public virtual DbSet<RefAcademicHonorType> RefAcademicHonorType { get; set; }
        public virtual DbSet<RefAcademicRank> RefAcademicRank { get; set; }
        public virtual DbSet<RefAcademicSubject> RefAcademicSubject { get; set; }
        public virtual DbSet<RefAcademicTermDesignator> RefAcademicTermDesignator { get; set; }
        public virtual DbSet<RefAccommodationsNeededType> RefAccommodationsNeededType { get; set; }
        public virtual DbSet<RefAccreditationAgency> RefAccreditationAgency { get; set; }
        public virtual DbSet<RefActivityRecognitionType> RefActivityRecognitionType { get; set; }
        public virtual DbSet<RefActivityTimeMeasurementType> RefActivityTimeMeasurementType { get; set; }
        public virtual DbSet<RefAdditionalCreditType> RefAdditionalCreditType { get; set; }
        public virtual DbSet<RefAddressType> RefAddressType { get; set; }
        public virtual DbSet<RefAdministrativeFundingControl> RefAdministrativeFundingControl { get; set; }
        public virtual DbSet<RefAdmissionConsiderationLevel> RefAdmissionConsiderationLevel { get; set; }
        public virtual DbSet<RefAdmissionConsiderationType> RefAdmissionConsiderationType { get; set; }
        public virtual DbSet<RefAdmittedStudent> RefAdmittedStudent { get; set; }
        public virtual DbSet<RefAdvancedPlacementCourseCode> RefAdvancedPlacementCourseCode { get; set; }
        public virtual DbSet<RefAeCertificationType> RefAeCertificationType { get; set; }
        public virtual DbSet<RefAeFunctioningLevelAtIntake> RefAeFunctioningLevelAtIntake { get; set; }
        public virtual DbSet<RefAeFunctioningLevelAtPosttest> RefAeFunctioningLevelAtPosttest { get; set; }
        public virtual DbSet<RefAeInstructionalProgramType> RefAeInstructionalProgramType { get; set; }
        public virtual DbSet<RefAePostsecondaryTransitionAction> RefAePostsecondaryTransitionAction { get; set; }
        public virtual DbSet<RefAeSpecialProgramType> RefAeSpecialProgramType { get; set; }
        public virtual DbSet<RefAeStaffClassification> RefAeStaffClassification { get; set; }
        public virtual DbSet<RefAeStaffEmploymentStatus> RefAeStaffEmploymentStatus { get; set; }
        public virtual DbSet<RefAllergySeverity> RefAllergySeverity { get; set; }
        public virtual DbSet<RefAllergyType> RefAllergyType { get; set; }
        public virtual DbSet<RefAltRouteToCertificationOrLicensure> RefAltRouteToCertificationOrLicensure { get; set; }
        public virtual DbSet<RefAlternateFundUses> RefAlternateFundUses { get; set; }
        public virtual DbSet<RefAlternativeSchoolFocus> RefAlternativeSchoolFocus { get; set; }
        public virtual DbSet<RefAmaoAttainmentStatus> RefAmaoAttainmentStatus { get; set; }
        public virtual DbSet<RefApipInteractionType> RefApipInteractionType { get; set; }
        public virtual DbSet<RefAssessmentAccommodationCategory> RefAssessmentAccommodationCategory { get; set; }
        public virtual DbSet<RefAssessmentAccommodationType> RefAssessmentAccommodationType { get; set; }
        public virtual DbSet<RefAssessmentAssetIdentifierType> RefAssessmentAssetIdentifierType { get; set; }
        public virtual DbSet<RefAssessmentAssetType> RefAssessmentAssetType { get; set; }
        public virtual DbSet<RefAssessmentEldevelopmentalDomain> RefAssessmentEldevelopmentalDomain { get; set; }
        public virtual DbSet<RefAssessmentFormSectionIdentificationSystem> RefAssessmentFormSectionIdentificationSystem { get; set; }
        public virtual DbSet<RefAssessmentItemCharacteristicType> RefAssessmentItemCharacteristicType { get; set; }
        public virtual DbSet<RefAssessmentItemResponseScoreStatus> RefAssessmentItemResponseScoreStatus { get; set; }
        public virtual DbSet<RefAssessmentItemResponseStatus> RefAssessmentItemResponseStatus { get; set; }
        public virtual DbSet<RefAssessmentItemType> RefAssessmentItemType { get; set; }
        public virtual DbSet<RefAssessmentNeedAlternativeRepresentationType> RefAssessmentNeedAlternativeRepresentationType { get; set; }
        public virtual DbSet<RefAssessmentNeedBrailleGradeType> RefAssessmentNeedBrailleGradeType { get; set; }
        public virtual DbSet<RefAssessmentNeedBrailleMarkType> RefAssessmentNeedBrailleMarkType { get; set; }
        public virtual DbSet<RefAssessmentNeedBrailleStatusCellType> RefAssessmentNeedBrailleStatusCellType { get; set; }
        public virtual DbSet<RefAssessmentNeedHazardType> RefAssessmentNeedHazardType { get; set; }
        public virtual DbSet<RefAssessmentNeedIncreasedWhitespacingType> RefAssessmentNeedIncreasedWhitespacingType { get; set; }
        public virtual DbSet<RefAssessmentNeedLanguageLearnerType> RefAssessmentNeedLanguageLearnerType { get; set; }
        public virtual DbSet<RefAssessmentNeedMaskingType> RefAssessmentNeedMaskingType { get; set; }
        public virtual DbSet<RefAssessmentNeedNumberOfBrailleDots> RefAssessmentNeedNumberOfBrailleDots { get; set; }
        public virtual DbSet<RefAssessmentNeedSigningType> RefAssessmentNeedSigningType { get; set; }
        public virtual DbSet<RefAssessmentNeedSpokenSourcePreferenceType> RefAssessmentNeedSpokenSourcePreferenceType { get; set; }
        public virtual DbSet<RefAssessmentNeedSupportTool> RefAssessmentNeedSupportTool { get; set; }
        public virtual DbSet<RefAssessmentNeedUsageType> RefAssessmentNeedUsageType { get; set; }
        public virtual DbSet<RefAssessmentNeedUserSpokenPreferenceType> RefAssessmentNeedUserSpokenPreferenceType { get; set; }
        public virtual DbSet<RefAssessmentParticipationIndicator> RefAssessmentParticipationIndicator { get; set; }
        public virtual DbSet<RefAssessmentPlatformType> RefAssessmentPlatformType { get; set; }
        public virtual DbSet<RefAssessmentPretestOutcome> RefAssessmentPretestOutcome { get; set; }
        public virtual DbSet<RefAssessmentPurpose> RefAssessmentPurpose { get; set; }
        public virtual DbSet<RefAssessmentReasonNotCompleting> RefAssessmentReasonNotCompleting { get; set; }
        public virtual DbSet<RefAssessmentReasonNotTested> RefAssessmentReasonNotTested { get; set; }
        public virtual DbSet<RefAssessmentRegistrationCompletionStatus> RefAssessmentRegistrationCompletionStatus { get; set; }
        public virtual DbSet<RefAssessmentReportingMethod> RefAssessmentReportingMethod { get; set; }
        public virtual DbSet<RefAssessmentResultDataType> RefAssessmentResultDataType { get; set; }
        public virtual DbSet<RefAssessmentResultScoreType> RefAssessmentResultScoreType { get; set; }
        public virtual DbSet<RefAssessmentSessionSpecialCircumstanceType> RefAssessmentSessionSpecialCircumstanceType { get; set; }
        public virtual DbSet<RefAssessmentSessionStaffRoleType> RefAssessmentSessionStaffRoleType { get; set; }
        public virtual DbSet<RefAssessmentSessionType> RefAssessmentSessionType { get; set; }
        public virtual DbSet<RefAssessmentSubtestIdentifierType> RefAssessmentSubtestIdentifierType { get; set; }
        public virtual DbSet<RefAssessmentType> RefAssessmentType { get; set; }
        public virtual DbSet<RefAssessmentTypeChildrenWithDisabilities> RefAssessmentTypeChildrenWithDisabilities { get; set; }
        public virtual DbSet<RefAttendanceEventType> RefAttendanceEventType { get; set; }
        public virtual DbSet<RefAttendanceStatus> RefAttendanceStatus { get; set; }
        public virtual DbSet<RefAypStatus> RefAypStatus { get; set; }
        public virtual DbSet<RefBarrierToEducatingHomeless> RefBarrierToEducatingHomeless { get; set; }
        public virtual DbSet<RefBillableBasisType> RefBillableBasisType { get; set; }
        public virtual DbSet<RefBlendedLearningModelType> RefBlendedLearningModelType { get; set; }
        public virtual DbSet<RefBloomsTaxonomyDomain> RefBloomsTaxonomyDomain { get; set; }
        public virtual DbSet<RefBuildingUseType> RefBuildingUseType { get; set; }
        public virtual DbSet<RefCalendarEventType> RefCalendarEventType { get; set; }
        public virtual DbSet<RefCampusResidencyType> RefCampusResidencyType { get; set; }
        public virtual DbSet<RefCareerCluster> RefCareerCluster { get; set; }
        public virtual DbSet<RefCareerEducationPlanType> RefCareerEducationPlanType { get; set; }
        public virtual DbSet<RefCarnegieBasicClassification> RefCarnegieBasicClassification { get; set; }
        public virtual DbSet<RefCharterSchoolAuthorizerType> RefCharterSchoolAuthorizerType { get; set; }
        public virtual DbSet<RefCharterSchoolManagementOrganizationType> RefCharterSchoolManagementOrganizationType { get; set; }
        public virtual DbSet<RefCharterSchoolType> RefCharterSchoolType { get; set; }
        public virtual DbSet<RefChildDevelopmentAssociateType> RefChildDevelopmentAssociateType { get; set; }
        public virtual DbSet<RefChildDevelopmentalScreeningStatus> RefChildDevelopmentalScreeningStatus { get; set; }
        public virtual DbSet<RefChildOutcomesSummaryRating> RefChildOutcomesSummaryRating { get; set; }
        public virtual DbSet<RefCipCode> RefCipCode { get; set; }
        public virtual DbSet<RefCipUse> RefCipUse { get; set; }
        public virtual DbSet<RefCipVersion> RefCipVersion { get; set; }
        public virtual DbSet<RefClassroomPositionType> RefClassroomPositionType { get; set; }
        public virtual DbSet<RefCohortExclusion> RefCohortExclusion { get; set; }
        public virtual DbSet<RefCommunicationMethod> RefCommunicationMethod { get; set; }
        public virtual DbSet<RefCommunityBasedType> RefCommunityBasedType { get; set; }
        public virtual DbSet<RefCompetencySetCompletionCriteria> RefCompetencySetCompletionCriteria { get; set; }
		public virtual DbSet<RefComprehensiveSupport> RefComprehensiveSupport { get; set; }
		public virtual DbSet<RefComprehensiveAndTargetedSupport> RefComprehensiveAndTargetedSupport { get; set; }
        public virtual DbSet<RefComprehensiveSupportImprovement> RefComprehensiveSupportImprovement { get; set; }
        public virtual DbSet<RefTargetedSupportImprovement> RefTargetedSupportImprovement { get; set; }
        public virtual DbSet<RefAdditionalTargetedSupport> RefAdditionalTargetedSupport { get; set; }
        public virtual DbSet<RefContentStandardType> RefContentStandardType { get; set; }
        public virtual DbSet<RefContinuationOfServices> RefContinuationOfServices { get; set; }
        public virtual DbSet<RefControlOfInstitution> RefControlOfInstitution { get; set; }
        public virtual DbSet<RefCoreKnowledgeArea> RefCoreKnowledgeArea { get; set; }
        public virtual DbSet<RefCorrectionalEducationFacilityType> RefCorrectionalEducationFacilityType { get; set; }
        public virtual DbSet<RefCorrectiveActionType> RefCorrectiveActionType { get; set; }
        public virtual DbSet<RefCountry> RefCountry { get; set; }
        public virtual DbSet<RefCounty> RefCounty { get; set; }
        public virtual DbSet<RefCourseAcademicGradeStatusCode> RefCourseAcademicGradeStatusCode { get; set; }
        public virtual DbSet<RefCourseApplicableEducationLevel> RefCourseApplicableEducationLevel { get; set; }
        public virtual DbSet<RefCourseCreditBasisType> RefCourseCreditBasisType { get; set; }
        public virtual DbSet<RefCourseCreditLevelType> RefCourseCreditLevelType { get; set; }
        public virtual DbSet<RefCourseCreditUnit> RefCourseCreditUnit { get; set; }
        public virtual DbSet<RefCourseGpaApplicability> RefCourseGpaApplicability { get; set; }
        public virtual DbSet<RefCourseHonorsType> RefCourseHonorsType { get; set; }
        public virtual DbSet<RefCourseInstructionMethod> RefCourseInstructionMethod { get; set; }
        public virtual DbSet<RefCourseInstructionSiteType> RefCourseInstructionSiteType { get; set; }
        public virtual DbSet<RefCourseInteractionMode> RefCourseInteractionMode { get; set; }
        public virtual DbSet<RefCourseLevelCharacteristic> RefCourseLevelCharacteristic { get; set; }
        public virtual DbSet<RefCourseLevelType> RefCourseLevelType { get; set; }
        public virtual DbSet<RefCourseRepeatCode> RefCourseRepeatCode { get; set; }
        public virtual DbSet<RefCourseSectionAssessmentReportingMethod> RefCourseSectionAssessmentReportingMethod { get; set; }
        public virtual DbSet<RefCourseSectionDeliveryMode> RefCourseSectionDeliveryMode { get; set; }
        public virtual DbSet<RefCourseSectionEnrollmentStatusType> RefCourseSectionEnrollmentStatusType { get; set; }
        public virtual DbSet<RefCourseSectionEntryType> RefCourseSectionEntryType { get; set; }
        public virtual DbSet<RefCourseSectionExitType> RefCourseSectionExitType { get; set; }
        public virtual DbSet<RefCredentialType> RefCredentialType { get; set; }
        public virtual DbSet<RefCreditHoursAppliedOtherProgram> RefCreditHoursAppliedOtherProgram { get; set; }
        public virtual DbSet<RefCreditTypeEarned> RefCreditTypeEarned { get; set; }
        public virtual DbSet<RefCriticalTeacherShortageCandidate> RefCriticalTeacherShortageCandidate { get; set; }
        public virtual DbSet<RefCteGraduationRateInclusion> RefCteGraduationRateInclusion { get; set; }
        public virtual DbSet<RefCteNonTraditionalGenderStatus> RefCteNonTraditionalGenderStatus { get; set; }
        public virtual DbSet<RefCurriculumFrameworkType> RefCurriculumFrameworkType { get; set; }
        public virtual DbSet<RefDegreeOrCertificateType> RefDegreeOrCertificateType { get; set; }
        public virtual DbSet<RefDentalInsuranceCoverageType> RefDentalInsuranceCoverageType { get; set; }
        public virtual DbSet<RefDentalScreeningStatus> RefDentalScreeningStatus { get; set; }
        public virtual DbSet<RefDependencyStatus> RefDependencyStatus { get; set; }
        public virtual DbSet<RefDevelopmentalEducationReferralStatus> RefDevelopmentalEducationReferralStatus { get; set; }
        public virtual DbSet<RefDevelopmentalEducationType> RefDevelopmentalEducationType { get; set; }
        public virtual DbSet<RefDevelopmentalEvaluationFinding> RefDevelopmentalEvaluationFinding { get; set; }
        public virtual DbSet<RefDirectoryInformationBlockStatus> RefDirectoryInformationBlockStatus { get; set; }
        public virtual DbSet<RefDisabilityConditionStatusCode> RefDisabilityConditionStatusCode { get; set; }
        public virtual DbSet<RefDisabilityConditionType> RefDisabilityConditionType { get; set; }
        public virtual DbSet<RefDisabilityDeterminationSourceType> RefDisabilityDeterminationSourceType { get; set; }
        public virtual DbSet<RefDisabilityType> RefDisabilityType { get; set; }
        public virtual DbSet<RefDisciplinaryActionTaken> RefDisciplinaryActionTaken { get; set; }
        public virtual DbSet<RefDisciplineLengthDifferenceReason> RefDisciplineLengthDifferenceReason { get; set; }
        public virtual DbSet<RefDisciplineMethodFirearms> RefDisciplineMethodFirearms { get; set; }
        public virtual DbSet<RefDisciplineMethodOfCwd> RefDisciplineMethodOfCwd { get; set; }
        public virtual DbSet<RefDisciplineReason> RefDisciplineReason { get; set; }
        public virtual DbSet<RefDistanceEducationCourseEnrollment> RefDistanceEducationCourseEnrollment { get; set; }
        public virtual DbSet<RefDoctoralExamsRequiredCode> RefDoctoralExamsRequiredCode { get; set; }
        public virtual DbSet<RefDqpcategoriesOfLearning> RefDqpcategoriesOfLearning { get; set; }
        public virtual DbSet<RefEarlyChildhoodCredential> RefEarlyChildhoodCredential { get; set; }
        public virtual DbSet<RefEarlyChildhoodProgramEnrollmentType> RefEarlyChildhoodProgramEnrollmentType { get; set; }
        public virtual DbSet<RefEarlyChildhoodServices> RefEarlyChildhoodServices { get; set; }
        public virtual DbSet<RefEducationLevel> RefEducationLevel { get; set; }
        public virtual DbSet<RefEducationLevelType> RefEducationLevelType { get; set; }
        public virtual DbSet<RefEducationVerificationMethod> RefEducationVerificationMethod { get; set; }
        public virtual DbSet<RefEleducationStaffClassification> RefEleducationStaffClassification { get; set; }
        public virtual DbSet<RefElementaryMiddleAdditional> RefElementaryMiddleAdditional { get; set; }
        public virtual DbSet<RefElemploymentSeparationReason> RefElemploymentSeparationReason { get; set; }
        public virtual DbSet<RefElfacilityLicensingStatus> RefElfacilityLicensingStatus { get; set; }
        public virtual DbSet<RefElfederalFundingType> RefElfederalFundingType { get; set; }
        public virtual DbSet<RefElgroupSizeStandardMet> RefElgroupSizeStandardMet { get; set; }
        public virtual DbSet<RefEllevelOfSpecialization> RefEllevelOfSpecialization { get; set; }
        public virtual DbSet<RefEllocalRevenueSource> RefEllocalRevenueSource { get; set; }
        public virtual DbSet<RefElotherFederalFundingSources> RefElotherFederalFundingSources { get; set; }
        public virtual DbSet<RefEloutcomeMeasurementLevel> RefEloutcomeMeasurementLevel { get; set; }
        public virtual DbSet<RefElprofessionalDevelopmentTopicArea> RefElprofessionalDevelopmentTopicArea { get; set; }
        public virtual DbSet<RefElprogramEligibility> RefElprogramEligibility { get; set; }
        public virtual DbSet<RefElprogramEligibilityStatus> RefElprogramEligibilityStatus { get; set; }
        public virtual DbSet<RefElprogramLicenseStatus> RefElprogramLicenseStatus { get; set; }
        public virtual DbSet<RefElserviceProfessionalStaffClassification> RefElserviceProfessionalStaffClassification { get; set; }
        public virtual DbSet<RefElserviceType> RefElserviceType { get; set; }
        public virtual DbSet<RefElstateRevenueSource> RefElstateRevenueSource { get; set; }
        public virtual DbSet<RefEltrainerCoreKnowledgeArea> RefEltrainerCoreKnowledgeArea { get; set; }
        public virtual DbSet<RefEmailType> RefEmailType { get; set; }
		public virtual DbSet<RefEmergencyOrProvisionalCredentialStatus> RefEmergencyOrProvisionalCredentialStatus { get; set; }
		public virtual DbSet<RefEmployedAfterExit> RefEmployedAfterExit { get; set; }
        public virtual DbSet<RefEmployedPriorToEnrollment> RefEmployedPriorToEnrollment { get; set; }
        public virtual DbSet<RefEmployedWhileEnrolled> RefEmployedWhileEnrolled { get; set; }
        public virtual DbSet<RefEmploymentContractType> RefEmploymentContractType { get; set; }
        public virtual DbSet<RefEmploymentLocation> RefEmploymentLocation { get; set; }
        public virtual DbSet<RefEmploymentSeparationReason> RefEmploymentSeparationReason { get; set; }
        public virtual DbSet<RefEmploymentSeparationType> RefEmploymentSeparationType { get; set; }
        public virtual DbSet<RefEmploymentStatus> RefEmploymentStatus { get; set; }
        public virtual DbSet<RefEmploymentStatusWhileEnrolled> RefEmploymentStatusWhileEnrolled { get; set; }
        public virtual DbSet<RefEndOfTermStatus> RefEndOfTermStatus { get; set; }
        public virtual DbSet<RefEnrollmentStatus> RefEnrollmentStatus { get; set; }
        public virtual DbSet<RefEntityType> RefEntityType { get; set; }
        public virtual DbSet<RefEntryType> RefEntryType { get; set; }
        public virtual DbSet<RefEnvironmentSetting> RefEnvironmentSetting { get; set; }
        public virtual DbSet<RefEradministrativeDataSource> RefEradministrativeDataSource { get; set; }
        public virtual DbSet<RefErsruralUrbanContinuumCode> RefErsruralUrbanContinuumCode { get; set; }
        public virtual DbSet<RefExitOrWithdrawalStatus> RefExitOrWithdrawalStatus { get; set; }
        public virtual DbSet<RefExitOrWithdrawalType> RefExitOrWithdrawalType { get; set; }
        public virtual DbSet<RefFamilyIncomeSource> RefFamilyIncomeSource { get; set; }
        public virtual DbSet<RefFederalProgramFundingAllocationType> RefFederalProgramFundingAllocationType { get; set; }
        public virtual DbSet<RefFinancialAccountBalanceSheetCode> RefFinancialAccountBalanceSheetCode { get; set; }
        public virtual DbSet<RefFinancialAccountCategory> RefFinancialAccountCategory { get; set; }
        public virtual DbSet<RefFinancialAccountFundClassification> RefFinancialAccountFundClassification { get; set; }
        public virtual DbSet<RefFinancialAccountProgramCode> RefFinancialAccountProgramCode { get; set; }
        public virtual DbSet<RefFinancialAccountRevenueCode> RefFinancialAccountRevenueCode { get; set; }
        public virtual DbSet<RefFinancialAidApplicationType> RefFinancialAidApplicationType { get; set; }
        public virtual DbSet<RefFinancialAidAwardStatus> RefFinancialAidAwardStatus { get; set; }
        public virtual DbSet<RefFinancialAidAwardType> RefFinancialAidAwardType { get; set; }
        public virtual DbSet<RefFinancialAidVeteransBenefitStatus> RefFinancialAidVeteransBenefitStatus { get; set; }
        public virtual DbSet<RefFinancialAidVeteransBenefitType> RefFinancialAidVeteransBenefitType { get; set; }
        public virtual DbSet<RefFinancialExpenditureFunctionCode> RefFinancialExpenditureFunctionCode { get; set; }
        public virtual DbSet<RefFinancialExpenditureLevelOfInstructionCode> RefFinancialExpenditureLevelOfInstructionCode { get; set; }
        public virtual DbSet<RefFinancialExpenditureObjectCode> RefFinancialExpenditureObjectCode { get; set; }
        public virtual DbSet<RefFirearmType> RefFirearmType { get; set; }
        public virtual DbSet<RefFoodServiceEligibility> RefFoodServiceEligibility { get; set; }
        public virtual DbSet<RefFoodServiceParticipation> RefFoodServiceParticipation { get; set; }
        public virtual DbSet<RefFrequencyOfService> RefFrequencyOfService { get; set; }
        public virtual DbSet<RefFullTimeStatus> RefFullTimeStatus { get; set; }
        public virtual DbSet<RefGoalsForAttendingAdultEducation> RefGoalsForAttendingAdultEducation { get; set; }
        public virtual DbSet<RefGpaWeightedIndicator> RefGpaWeightedIndicator { get; set; }
        public virtual DbSet<RefGradeLevel> RefGradeLevel { get; set; }
        public virtual DbSet<RefGradeLevelType> RefGradeLevelType { get; set; }
        public virtual DbSet<RefGradePointAverageDomain> RefGradePointAverageDomain { get; set; }
        public virtual DbSet<RefGraduateAssistantIpedsCategory> RefGraduateAssistantIpedsCategory { get; set; }
        public virtual DbSet<RefGraduateOrDoctoralExamResultsStatus> RefGraduateOrDoctoralExamResultsStatus { get; set; }
        public virtual DbSet<RefGunFreeSchoolsActReportingStatus> RefGunFreeSchoolsActReportingStatus { get; set; }
        public virtual DbSet<RefHealthInsuranceCoverage> RefHealthInsuranceCoverage { get; set; }
        public virtual DbSet<RefHearingScreeningStatus> RefHearingScreeningStatus { get; set; }
        public virtual DbSet<RefHighSchoolDiplomaDistinctionType> RefHighSchoolDiplomaDistinctionType { get; set; }
        public virtual DbSet<RefHighSchoolDiplomaType> RefHighSchoolDiplomaType { get; set; }
        public virtual DbSet<RefHighSchoolGraduationRateIndicator> RefHighSchoolGraduationRateIndicator { get; set; }
        public virtual DbSet<RefHigherEducationInstitutionAccreditationStatus> RefHigherEducationInstitutionAccreditationStatus { get; set; }
        public virtual DbSet<RefHomelessNighttimeResidence> RefHomelessNighttimeResidence { get; set; }
        public virtual DbSet<RefIdeadisciplineMethodFirearm> RefIdeadisciplineMethodFirearm { get; set; }
        public virtual DbSet<RefIdeaeducationalEnvironmentEc> RefIdeaeducationalEnvironmentEc { get; set; }
        public virtual DbSet<RefIdeaeducationalEnvironmentSchoolAge> RefIdeaeducationalEnvironmentSchoolAge { get; set; }
        public virtual DbSet<RefIdeaenvironmentEl> RefIdeaenvironmentEl { get; set; }
        public virtual DbSet<RefIdeaiepstatus> RefIdeaiepstatus { get; set; }
        public virtual DbSet<RefIdeainterimRemoval> RefIdeainterimRemoval { get; set; }
        public virtual DbSet<RefIdeainterimRemovalReason> RefIdeainterimRemovalReason { get; set; }
        public virtual DbSet<RefIdeapartCeligibilityCategory> RefIdeapartCeligibilityCategory { get; set; }
        public virtual DbSet<RefImmunizationType> RefImmunizationType { get; set; }
        public virtual DbSet<RefIncidentBehavior> RefIncidentBehavior { get; set; }
        public virtual DbSet<RefIncidentBehaviorSecondary> RefIncidentBehaviorSecondary { get; set; }
        public virtual DbSet<RefIncidentInjuryType> RefIncidentInjuryType { get; set; }
        public virtual DbSet<RefIncidentLocation> RefIncidentLocation { get; set; }
        public virtual DbSet<RefIncidentMultipleOffenseType> RefIncidentMultipleOffenseType { get; set; }
        public virtual DbSet<RefIncidentPerpetratorInjuryType> RefIncidentPerpetratorInjuryType { get; set; }
        public virtual DbSet<RefIncidentPersonRoleType> RefIncidentPersonRoleType { get; set; }
        public virtual DbSet<RefIncidentPersonType> RefIncidentPersonType { get; set; }
        public virtual DbSet<RefIncidentReporterType> RefIncidentReporterType { get; set; }
        public virtual DbSet<RefIncidentTimeDescriptionCode> RefIncidentTimeDescriptionCode { get; set; }
        public virtual DbSet<RefIncomeCalculationMethod> RefIncomeCalculationMethod { get; set; }
        public virtual DbSet<RefIncreasedLearningTimeType> RefIncreasedLearningTimeType { get; set; }
		public virtual DbSet<RefIndicatorStateDefinedStatus> RefIndicatorStateDefinedStatus { get; set; }
		public virtual DbSet<RefIndicatorStatusSubgroupType> RefIndicatorStatusSubgroupType { get; set; }
		public virtual DbSet<RefIndicatorStatusType> RefIndicatorStatusType { get; set; }
		public virtual DbSet<RefIndicatorStatusCustomType> RefIndicatorStatusCustomType { get; set; }
		public virtual DbSet<RefIndividualizedProgramDateType> RefIndividualizedProgramDateType { get; set; }
        public virtual DbSet<RefIndividualizedProgramLocation> RefIndividualizedProgramLocation { get; set; }
        public virtual DbSet<RefIndividualizedProgramPlannedServiceType> RefIndividualizedProgramPlannedServiceType { get; set; }
        public virtual DbSet<RefIndividualizedProgramTransitionType> RefIndividualizedProgramTransitionType { get; set; }
        public virtual DbSet<RefIndividualizedProgramType> RefIndividualizedProgramType { get; set; }
        public virtual DbSet<RefInstitutionTelephoneType> RefInstitutionTelephoneType { get; set; }
        public virtual DbSet<RefInstructionCreditType> RefInstructionCreditType { get; set; }
        public virtual DbSet<RefInstructionLocationType> RefInstructionLocationType { get; set; }
        public virtual DbSet<RefInstructionalActivityHours> RefInstructionalActivityHours { get; set; }
        public virtual DbSet<RefInstructionalStaffContractLength> RefInstructionalStaffContractLength { get; set; }
        public virtual DbSet<RefInstructionalStaffFacultyTenure> RefInstructionalStaffFacultyTenure { get; set; }
        public virtual DbSet<RefIntegratedTechnologyStatus> RefIntegratedTechnologyStatus { get; set; }
        public virtual DbSet<RefInternetAccess> RefInternetAccess { get; set; }
        public virtual DbSet<RefIpedsOccupationalCategory> RefIpedsOccupationalCategory { get; set; }
        public virtual DbSet<RefIso6392language> RefIso6392language { get; set; }
        public virtual DbSet<RefIso6393language> RefIso6393language { get; set; }
        public virtual DbSet<RefIso6395languageFamily> RefIso6395languageFamily { get; set; }
        public virtual DbSet<RefItemResponseTheoryDifficultyCategory> RefItemResponseTheoryDifficultyCategory { get; set; }
        public virtual DbSet<RefItemResponseTheoryKappaAlgorithm> RefItemResponseTheoryKappaAlgorithm { get; set; }
        public virtual DbSet<RefK12endOfCourseRequirement> RefK12endOfCourseRequirement { get; set; }
        public virtual DbSet<RefK12leaTitleIsupportService> RefK12leaTitleIsupportService { get; set; }
        public virtual DbSet<RefK12responsibilityType> RefK12responsibilityType { get; set; }
        public virtual DbSet<RefK12staffClassification> RefK12staffClassification { get; set; }
        public virtual DbSet<RefLanguage> RefLanguage { get; set; }
        public virtual DbSet<RefLanguageUseType> RefLanguageUseType { get; set; }
        public virtual DbSet<RefLeaFundsTransferType> RefLeaFundsTransferType { get; set; }
        public virtual DbSet<RefLeaImprovementStatus> RefLeaImprovementStatus { get; set; }
        public virtual DbSet<RefLeaType> RefLeaType { get; set; }
        public virtual DbSet<RefLearnerActionType> RefLearnerActionType { get; set; }
        public virtual DbSet<RefLearnerActivityMaximumTimeAllowedUnits> RefLearnerActivityMaximumTimeAllowedUnits { get; set; }
        public virtual DbSet<RefLearnerActivityType> RefLearnerActivityType { get; set; }
        public virtual DbSet<RefLearningResourceAccessApitype> RefLearningResourceAccessApitype { get; set; }
        public virtual DbSet<RefLearningResourceAccessHazardType> RefLearningResourceAccessHazardType { get; set; }
        public virtual DbSet<RefLearningResourceAccessModeType> RefLearningResourceAccessModeType { get; set; }
        public virtual DbSet<RefLearningResourceAccessRightsUrl> RefLearningResourceAccessRightsUrl { get; set; }
        public virtual DbSet<RefLearningResourceAuthorType> RefLearningResourceAuthorType { get; set; }
        public virtual DbSet<RefLearningResourceBookFormatType> RefLearningResourceBookFormatType { get; set; }
        public virtual DbSet<RefLearningResourceCompetencyAlignmentType> RefLearningResourceCompetencyAlignmentType { get; set; }
        public virtual DbSet<RefLearningResourceControlFlexibilityType> RefLearningResourceControlFlexibilityType { get; set; }
        public virtual DbSet<RefLearningResourceDigitalMediaSubType> RefLearningResourceDigitalMediaSubType { get; set; }
        public virtual DbSet<RefLearningResourceDigitalMediaType> RefLearningResourceDigitalMediaType { get; set; }
        public virtual DbSet<RefLearningResourceEducationalUse> RefLearningResourceEducationalUse { get; set; }
        public virtual DbSet<RefLearningResourceIntendedEndUserRole> RefLearningResourceIntendedEndUserRole { get; set; }
        public virtual DbSet<RefLearningResourceInteractionMode> RefLearningResourceInteractionMode { get; set; }
        public virtual DbSet<RefLearningResourceInteractivityType> RefLearningResourceInteractivityType { get; set; }
        public virtual DbSet<RefLearningResourceMediaFeatureType> RefLearningResourceMediaFeatureType { get; set; }
        public virtual DbSet<RefLearningResourcePhysicalMediaType> RefLearningResourcePhysicalMediaType { get; set; }
        public virtual DbSet<RefLearningResourceType> RefLearningResourceType { get; set; }
        public virtual DbSet<RefLearningStandardDocumentPublicationStatus> RefLearningStandardDocumentPublicationStatus { get; set; }
        public virtual DbSet<RefLearningStandardItemAssociationType> RefLearningStandardItemAssociationType { get; set; }
        public virtual DbSet<RefLearningStandardItemNodeAccessibilityProfile> RefLearningStandardItemNodeAccessibilityProfile { get; set; }
        public virtual DbSet<RefLearningStandardItemTestabilityType> RefLearningStandardItemTestabilityType { get; set; }
        public virtual DbSet<RefLeaveEventType> RefLeaveEventType { get; set; }
        public virtual DbSet<RefLevelOfInstitution> RefLevelOfInstitution { get; set; }
        public virtual DbSet<RefLicenseExempt> RefLicenseExempt { get; set; }
        public virtual DbSet<RefLiteracyAssessment> RefLiteracyAssessment { get; set; }
        public virtual DbSet<RefMagnetSpecialProgram> RefMagnetSpecialProgram { get; set; }
        public virtual DbSet<RefMedicalAlertIndicator> RefMedicalAlertIndicator { get; set; }
        public virtual DbSet<RefMepEnrollmentType> RefMepEnrollmentType { get; set; }
        public virtual DbSet<RefMepProjectBased> RefMepProjectBased { get; set; }
        public virtual DbSet<RefMepProjectType> RefMepProjectType { get; set; }
        public virtual DbSet<RefMepServiceType> RefMepServiceType { get; set; }
        public virtual DbSet<RefMepSessionType> RefMepSessionType { get; set; }
        public virtual DbSet<RefMepStaffCategory> RefMepStaffCategory { get; set; }
        public virtual DbSet<RefMethodOfServiceDelivery> RefMethodOfServiceDelivery { get; set; }
        public virtual DbSet<RefMilitaryActiveStudentIndicator> RefMilitaryActiveStudentIndicator { get; set; }
        public virtual DbSet<RefMilitaryBranch> RefMilitaryBranch { get; set; }
        public virtual DbSet<RefMilitaryConnectedStudentIndicator> RefMilitaryConnectedStudentIndicator { get; set; }
        public virtual DbSet<RefMilitaryVeteranStudentIndicator> RefMilitaryVeteranStudentIndicator { get; set; }
        public virtual DbSet<RefMultipleIntelligenceType> RefMultipleIntelligenceType { get; set; }
        public virtual DbSet<RefNaepAspectsOfReading> RefNaepAspectsOfReading { get; set; }
        public virtual DbSet<RefNaepMathComplexityLevel> RefNaepMathComplexityLevel { get; set; }
        public virtual DbSet<RefNcescollegeCourseMapCode> RefNcescollegeCourseMapCode { get; set; }
        public virtual DbSet<RefNeedDeterminationMethod> RefNeedDeterminationMethod { get; set; }
        public virtual DbSet<RefNeglectedProgramType> RefNeglectedProgramType { get; set; }
        public virtual DbSet<RefNonPromotionReason> RefNonPromotionReason { get; set; }
        public virtual DbSet<RefNonTraditionalGenderStatus> RefNonTraditionalGenderStatus { get; set; }
        public virtual DbSet<RefNSLPStatus> RefNSLPStatus { get; set; }
        public virtual DbSet<RefOperationalStatus> RefOperationalStatus { get; set; }
        public virtual DbSet<RefOperationalStatusType> RefOperationalStatusType { get; set; }
        public virtual DbSet<RefOrganizationElementType> RefOrganizationElementType { get; set; }
        public virtual DbSet<RefOrganizationIdentificationSystem> RefOrganizationIdentificationSystem { get; set; }
        public virtual DbSet<RefOrganizationIdentifierType> RefOrganizationIdentifierType { get; set; }
        public virtual DbSet<RefOrganizationIndicator> RefOrganizationIndicator { get; set; }
        public virtual DbSet<RefOrganizationLocationType> RefOrganizationLocationType { get; set; }
        public virtual DbSet<RefOrganizationMonitoringNotifications> RefOrganizationMonitoringNotifications { get; set; }
        public virtual DbSet<RefOrganizationRelationship> RefOrganizationRelationship { get; set; }
        public virtual DbSet<RefOrganizationType> RefOrganizationType { get; set; }
        public virtual DbSet<RefOtherNameType> RefOtherNameType { get; set; }
        public virtual DbSet<RefOutcomeTimePoint> RefOutcomeTimePoint { get; set; }
		public virtual DbSet<RefOutOfFieldStatus> RefOutOfFieldStatus { get; set; }
		public virtual DbSet<RefParaprofessionalQualification> RefParaprofessionalQualification { get; set; }
        public virtual DbSet<RefParticipationStatusAyp> RefParticipationStatusAyp { get; set; }
        public virtual DbSet<RefParticipationType> RefParticipationType { get; set; }
        public virtual DbSet<RefPdactivityApprovedPurpose> RefPdactivityApprovedPurpose { get; set; }
        public virtual DbSet<RefPdactivityCreditType> RefPdactivityCreditType { get; set; }
        public virtual DbSet<RefPdactivityEducationLevelsAddressed> RefPdactivityEducationLevelsAddressed { get; set; }
        public virtual DbSet<RefPdactivityLevel> RefPdactivityLevel { get; set; }
        public virtual DbSet<RefPdactivityTargetAudience> RefPdactivityTargetAudience { get; set; }
        public virtual DbSet<RefPdactivityType> RefPdactivityType { get; set; }
        public virtual DbSet<RefPdaudienceType> RefPdaudienceType { get; set; }
        public virtual DbSet<RefPddeliveryMethod> RefPddeliveryMethod { get; set; }
        public virtual DbSet<RefPdinstructionalDeliveryMode> RefPdinstructionalDeliveryMode { get; set; }
        public virtual DbSet<RefPdsessionStatus> RefPdsessionStatus { get; set; }
        public virtual DbSet<RefPersonIdentificationSystem> RefPersonIdentificationSystem { get; set; }
        public virtual DbSet<RefPersonIdentifierType> RefPersonIdentifierType { get; set; }
        public virtual DbSet<RefPersonLocationType> RefPersonLocationType { get; set; }
        public virtual DbSet<RefPersonRelationship> RefPersonRelationship { get; set; }
        public virtual DbSet<RefPersonStatusType> RefPersonStatusType { get; set; }
        public virtual DbSet<RefPersonTelephoneNumberType> RefPersonTelephoneNumberType { get; set; }
        public virtual DbSet<RefPersonalInformationVerification> RefPersonalInformationVerification { get; set; }
        public virtual DbSet<RefPopulationServed> RefPopulationServed { get; set; }
        public virtual DbSet<RefPreAndPostTestIndicator> RefPreAndPostTestIndicator { get; set; }
        public virtual DbSet<RefPreKeligibleAgesNonIdea> RefPreKeligibleAgesNonIdea { get; set; }
        public virtual DbSet<RefPredominantCalendarSystem> RefPredominantCalendarSystem { get; set; }
        public virtual DbSet<RefPrekindergartenEligibility> RefPrekindergartenEligibility { get; set; }
        public virtual DbSet<RefPresentAttendanceCategory> RefPresentAttendanceCategory { get; set; }
        public virtual DbSet<RefProfessionalDevelopmentFinancialSupport> RefProfessionalDevelopmentFinancialSupport { get; set; }
        public virtual DbSet<RefProfessionalEducationJobClassification> RefProfessionalEducationJobClassification { get; set; }
        public virtual DbSet<RefProfessionalTechnicalCredentialType> RefProfessionalTechnicalCredentialType { get; set; }
        public virtual DbSet<RefProficiencyStatus> RefProficiencyStatus { get; set; }
        public virtual DbSet<RefProficiencyTargetAyp> RefProficiencyTargetAyp { get; set; }
        public virtual DbSet<RefProgramDayLength> RefProgramDayLength { get; set; }
        public virtual DbSet<RefProgramExitReason> RefProgramExitReason { get; set; }
        public virtual DbSet<RefProgramGiftedEligibility> RefProgramGiftedEligibility { get; set; }
        public virtual DbSet<RefProgramLengthHoursType> RefProgramLengthHoursType { get; set; }
        public virtual DbSet<RefProgramSponsorType> RefProgramSponsorType { get; set; }
        public virtual DbSet<RefProgramType> RefProgramType { get; set; }
        public virtual DbSet<RefProgressLevel> RefProgressLevel { get; set; }
        public virtual DbSet<RefPromotionReason> RefPromotionReason { get; set; }
        public virtual DbSet<RefProofOfResidencyType> RefProofOfResidencyType { get; set; }
        public virtual DbSet<RefPsEnrollmentAction> RefPsEnrollmentAction { get; set; }
        public virtual DbSet<RefPsEnrollmentAwardType> RefPsEnrollmentAwardType { get; set; }
        public virtual DbSet<RefPsEnrollmentStatus> RefPsEnrollmentStatus { get; set; }
        public virtual DbSet<RefPsEnrollmentType> RefPsEnrollmentType { get; set; }
        public virtual DbSet<RefPsLepType> RefPsLepType { get; set; }
        public virtual DbSet<RefPsStudentLevel> RefPsStudentLevel { get; set; }
        public virtual DbSet<RefPsexitOrWithdrawalType> RefPsexitOrWithdrawalType { get; set; }
        public virtual DbSet<RefPsprogramLevel> RefPsprogramLevel { get; set; }
        public virtual DbSet<RefPublicSchoolChoiceStatus> RefPublicSchoolChoiceStatus { get; set; }
        public virtual DbSet<RefPublicSchoolResidence> RefPublicSchoolResidence { get; set; }
        public virtual DbSet<RefPurposeOfMonitoringVisit> RefPurposeOfMonitoringVisit { get; set; }
        public virtual DbSet<RefQrisParticipation> RefQrisParticipation { get; set; }
        public virtual DbSet<RefRace> RefRace { get; set; }
        public virtual DbSet<RefReapAlternativeFundingStatus> RefReapAlternativeFundingStatus { get; set; }
        public virtual DbSet<RefReasonDelayTransitionConf> RefReasonDelayTransitionConf { get; set; }
        public virtual DbSet<RefReconstitutedStatus> RefReconstitutedStatus { get; set; }
        public virtual DbSet<RefReferralOutcome> RefReferralOutcome { get; set; }
        public virtual DbSet<RefReimbursementType> RefReimbursementType { get; set; }
        public virtual DbSet<RefRestructuringAction> RefRestructuringAction { get; set; }
        public virtual DbSet<RefRlisProgramUse> RefRlisProgramUse { get; set; }
        public virtual DbSet<RefRoleStatus> RefRoleStatus { get; set; }
        public virtual DbSet<RefRoleStatusType> RefRoleStatusType { get; set; }
        public virtual DbSet<RefScedcourseLevel> RefScedcourseLevel { get; set; }
        public virtual DbSet<RefScedcourseSubjectArea> RefScedcourseSubjectArea { get; set; }
        public virtual DbSet<RefScheduledWellChildScreening> RefScheduledWellChildScreening { get; set; }
        public virtual DbSet<RefSchoolFoodServiceProgram> RefSchoolFoodServiceProgram { get; set; }
        public virtual DbSet<RefSchoolImprovementFunds> RefSchoolImprovementFunds { get; set; }
        public virtual DbSet<RefSchoolImprovementStatus> RefSchoolImprovementStatus { get; set; }
        public virtual DbSet<RefSchoolDangerousStatus> RefSchoolDangerousStatus { get; set; }
        public virtual DbSet<RefTargetedSupport> RefTargetedSupport { get; set; }
        public virtual DbSet<RefSchoolLevel> RefSchoolLevel { get; set; }
        public virtual DbSet<RefSchoolType> RefSchoolType { get; set; }
        public virtual DbSet<RefScoreMetricType> RefScoreMetricType { get; set; }
        public virtual DbSet<RefServiceFrequency> RefServiceFrequency { get; set; }
        public virtual DbSet<RefServiceOption> RefServiceOption { get; set; }
        public virtual DbSet<RefServices> RefServices { get; set; }
        public virtual DbSet<RefSessionType> RefSessionType { get; set; }
        public virtual DbSet<RefSex> RefSex { get; set; }
        public virtual DbSet<RefSigInterventionType> RefSigInterventionType { get; set; }
        public virtual DbSet<RefSingleSexClassStatus> RefSingleSexClassStatus { get; set; }
        public virtual DbSet<RefSpaceUseType> RefSpaceUseType { get; set; }
        public virtual DbSet<RefSpecialEducationAgeGroupTaught> RefSpecialEducationAgeGroupTaught { get; set; }
        public virtual DbSet<RefSpecialEducationExitReason> RefSpecialEducationExitReason { get; set; }
        public virtual DbSet<RefSpecialEducationStaffCategory> RefSpecialEducationStaffCategory { get; set; }
        public virtual DbSet<RefStaffPerformanceLevel> RefStaffPerformanceLevel { get; set; }
        public virtual DbSet<RefStandardizedAdmissionTest> RefStandardizedAdmissionTest { get; set; }
        public virtual DbSet<RefState> RefState { get; set; }
        public virtual DbSet<RefStateAnsicode> RefStateAnsicode { get; set; }
        public virtual DbSet<RefStatePovertyDesignation> RefStatePovertyDesignation { get; set; }
        public virtual DbSet<RefStudentSupportServiceType> RefStudentSupportServiceType { get; set; }
        public virtual DbSet<RefSupervisedClinicalExperience> RefSupervisedClinicalExperience { get; set; }
        public virtual DbSet<RefTeacherEducationCredentialExam> RefTeacherEducationCredentialExam { get; set; }
        public virtual DbSet<RefTeacherEducationExamScoreType> RefTeacherEducationExamScoreType { get; set; }
        public virtual DbSet<RefTeacherEducationTestCompany> RefTeacherEducationTestCompany { get; set; }
        public virtual DbSet<RefTeacherPrepCompleterStatus> RefTeacherPrepCompleterStatus { get; set; }
        public virtual DbSet<RefTeacherPrepEnrollmentStatus> RefTeacherPrepEnrollmentStatus { get; set; }
        public virtual DbSet<RefTeachingAssignmentRole> RefTeachingAssignmentRole { get; set; }
        public virtual DbSet<RefTeachingCredentialBasis> RefTeachingCredentialBasis { get; set; }
        public virtual DbSet<RefTeachingCredentialType> RefTeachingCredentialType { get; set; }
        public virtual DbSet<RefTechnicalAssistanceDeliveryType> RefTechnicalAssistanceDeliveryType { get; set; }
        public virtual DbSet<RefTechnicalAssistanceType> RefTechnicalAssistanceType { get; set; }
        public virtual DbSet<RefTechnologyLiteracyStatus> RefTechnologyLiteracyStatus { get; set; }
        public virtual DbSet<RefTelephoneNumberType> RefTelephoneNumberType { get; set; }
        public virtual DbSet<RefTenureSystem> RefTenureSystem { get; set; }
        public virtual DbSet<RefTextComplexitySystem> RefTextComplexitySystem { get; set; }
        public virtual DbSet<RefTimeForCompletionUnits> RefTimeForCompletionUnits { get; set; }
        public virtual DbSet<RefTitleIiiaccountability> RefTitleIiiaccountability { get; set; }
        public virtual DbSet<RefTitleIiilanguageInstructionProgramType> RefTitleIiilanguageInstructionProgramType { get; set; }
        public virtual DbSet<RefTitleIiiprofessionalDevelopmentType> RefTitleIiiprofessionalDevelopmentType { get; set; }
        public virtual DbSet<RefTitleIindicator> RefTitleIindicator { get; set; }
        public virtual DbSet<RefTitleIinstructionalServices> RefTitleIinstructionalServices { get; set; }
        public virtual DbSet<RefTitleIprogramStaffCategory> RefTitleIprogramStaffCategory { get; set; }
        public virtual DbSet<RefTitleIprogramType> RefTitleIprogramType { get; set; }
        public virtual DbSet<RefTitleIschoolStatus> RefTitleIschoolStatus { get; set; }
        public virtual DbSet<RefTransferOutIndicator> RefTransferOutIndicator { get; set; }
        public virtual DbSet<RefTransferReady> RefTransferReady { get; set; }
        public virtual DbSet<RefTribalAffiliation> RefTribalAffiliation { get; set; }
        public virtual DbSet<RefTrimesterWhenPrenatalCareBegan> RefTrimesterWhenPrenatalCareBegan { get; set; }
        public virtual DbSet<RefTuitionResidencyType> RefTuitionResidencyType { get; set; }
        public virtual DbSet<RefTuitionUnit> RefTuitionUnit { get; set; }
		public virtual DbSet<RefUnexperiencedStatus> RefUnexperiencedStatus { get; set; }
		public virtual DbSet<RefUscitizenshipStatus> RefUscitizenshipStatus { get; set; }
        public virtual DbSet<RefVisaType> RefVisaType { get; set; }
        public virtual DbSet<RefVisionScreeningStatus> RefVisionScreeningStatus { get; set; }
        public virtual DbSet<RefWageCollectionMethod> RefWageCollectionMethod { get; set; }
        public virtual DbSet<RefWageVerification> RefWageVerification { get; set; }
        public virtual DbSet<RefWeaponType> RefWeaponType { get; set; }
        public virtual DbSet<RefWfProgramParticipation> RefWfProgramParticipation { get; set; }
        public virtual DbSet<RefWorkbasedLearningOpportunityType> RefWorkbasedLearningOpportunityType { get; set; }
        public virtual DbSet<RequiredImmunization> RequiredImmunization { get; set; }
        public virtual DbSet<Role> Role { get; set; }
        public virtual DbSet<RoleAttendance> RoleAttendance { get; set; }
        public virtual DbSet<RoleAttendanceEvent> RoleAttendanceEvent { get; set; }
        public virtual DbSet<RoleStatus> RoleStatus { get; set; }
        public virtual DbSet<Rubric> Rubric { get; set; }
        public virtual DbSet<RubricCriterion> RubricCriterion { get; set; }
        public virtual DbSet<RubricCriterionLevel> RubricCriterionLevel { get; set; }
        public virtual DbSet<ServicesReceived> ServicesReceived { get; set; }
        public virtual DbSet<StaffCredential> StaffCredential { get; set; }
        public virtual DbSet<StaffEmployment> StaffEmployment { get; set; }
        public virtual DbSet<StaffEvaluation> StaffEvaluation { get; set; }
        public virtual DbSet<StaffExperience> StaffExperience { get; set; }
        public virtual DbSet<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual DbSet<StaffTechnicalAssistance> StaffTechnicalAssistance { get; set; }
        public virtual DbSet<TeacherEducationCredentialExam> TeacherEducationCredentialExam { get; set; }
        public virtual DbSet<TeacherStudentDataLinkExclusion> TeacherStudentDataLinkExclusion { get; set; }
        public virtual DbSet<WorkforceEmploymentQuarterlyData> WorkforceEmploymentQuarterlyData { get; set; }
        public virtual DbSet<WorkforceProgramParticipation> WorkforceProgramParticipation { get; set; }
        public virtual DbSet<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus> RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Achievement>(entity =>
            {
                entity.ToTable("Achievement", "dbo");

                entity.Property(e => e.AwardIssuerName).HasMaxLength(128);

                entity.Property(e => e.AwardIssuerOriginUrl)
                    .HasColumnName("AwardIssuerOriginURL")
                    .HasMaxLength(300);

                entity.Property(e => e.Category).HasMaxLength(60);

                entity.Property(e => e.CategorySystem).HasMaxLength(50);

                entity.Property(e => e.Criteria).HasMaxLength(300);

                entity.Property(e => e.CriteriaUrl).HasMaxLength(300);

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.ImageUrl).HasMaxLength(300);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.Property(e => e.Title).HasMaxLength(300);

                entity.HasOne(d => d.CompetencySet)
                    .WithMany(p => p.Achievement)
                    .HasForeignKey(d => d.CompetencySetId)
                    .HasConstraintName("FK_Achievement_CompetencySet");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.Achievement)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Achievement_Person");
            });

            modelBuilder.Entity<AchievementEvidence>(entity =>
            {
                entity.ToTable("AchievementEvidence", "dbo");

                entity.Property(e => e.Statement).HasMaxLength(300);

                entity.HasOne(d => d.Achievement)
                    .WithMany(p => p.AchievementEvidence)
                    .HasForeignKey(d => d.AchievementId)
                    .HasConstraintName("FK_AchievementEvidence_Achievement");

                entity.HasOne(d => d.AssessmentSubtestResult)
                    .WithMany(p => p.AchievementEvidence)
                    .HasForeignKey(d => d.AssessmentSubtestResultId)
                    .HasConstraintName("FK_AchievementEvidence_AssessmentSubtestResult");
            });

            modelBuilder.Entity<Activity>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_Activity");

                entity.ToTable("Activity", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.ActivityDescription).HasMaxLength(300);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.Activity)
                    .HasForeignKey<Activity>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Activity_Organization");
            });

            modelBuilder.Entity<ActivityRecognition>(entity =>
            {
                entity.ToTable("ActivityRecognition", "dbo");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.ActivityRecognition)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ActivityRecognition_OrganizationPersonRole");

                entity.HasOne(d => d.RefActivityRecognitionType)
                    .WithMany(p => p.ActivityRecognition)
                    .HasForeignKey(d => d.RefActivityRecognitionTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ActivityRecognition_RefActivityRecognitionType");
            });

            modelBuilder.Entity<AeCourse>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_AeCourse");

                entity.ToTable("AeCourse", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.HasOne(d => d.RefCareerCluster)
                    .WithMany(p => p.AeCourse)
                    .HasForeignKey(d => d.RefCareerClusterId)
                    .HasConstraintName("FK_AeCourse_RefCareerCluster");
            });

            modelBuilder.Entity<AeProvider>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_AEProvider");

                entity.ToTable("AeProvider", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.AeProvider)
                    .HasForeignKey<AeProvider>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AeProvider_Organization");

                entity.HasOne(d => d.RefLevelOfInstitution)
                    .WithMany(p => p.AeProvider)
                    .HasForeignKey(d => d.RefLevelOfInstitutionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AeProvider_RefLevelOfInstitution");
            });

            modelBuilder.Entity<AeStaff>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_AEStaff");

                entity.ToTable("AeStaff", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.YearsOfPriorAeTeachingExperience).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.AeStaff)
                    .HasForeignKey<AeStaff>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AeStaff_OrganizationPersonRole");

                entity.HasOne(d => d.RefAeCertificationType)
                    .WithMany(p => p.AeStaff)
                    .HasForeignKey(d => d.RefAeCertificationTypeId)
                    .HasConstraintName("FK_AeStaff_RefAeCertificationType");

                entity.HasOne(d => d.RefAeStaffClassification)
                    .WithMany(p => p.AeStaff)
                    .HasForeignKey(d => d.RefAeStaffClassificationId)
                    .HasConstraintName("FK_AeStaff_RefAeStaffClassification");

                entity.HasOne(d => d.RefAeStaffEmploymentStatus)
                    .WithMany(p => p.AeStaff)
                    .HasForeignKey(d => d.RefAeStaffEmploymentStatusId)
                    .HasConstraintName("FK_AeStaff_RefAeStaffEmploymentStatus");
            });

            modelBuilder.Entity<AeStudentAcademicRecord>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_AeStudentAcademicRecord");

                entity.ToTable("AeStudentAcademicRecord", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("nchar(7)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.AeStudentAcademicRecord)
                    .HasForeignKey<AeStudentAcademicRecord>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AeStudentAcademicRecord_OrganizationPersonRole");

                entity.HasOne(d => d.RefHighSchoolDiplomaType)
                    .WithMany(p => p.AeStudentAcademicRecord)
                    .HasForeignKey(d => d.RefHighSchoolDiplomaTypeId)
                    .HasConstraintName("FK_AeStudentAcademicRecord_RefHighSchoolDiplomaType");

                entity.HasOne(d => d.RefProfessionalTechnicalCredentialType)
                    .WithMany(p => p.AeStudentAcademicRecord)
                    .HasForeignKey(d => d.RefProfessionalTechnicalCredentialTypeId)
                    .HasConstraintName("FK_AeStudentAcademicRecord_RefProfTechnicalCredentialType");
            });

            modelBuilder.Entity<AeStudentEmployment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_AeStudentEmployment");

                entity.ToTable("AeStudentEmployment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.EmploymentNaicsCode).HasColumnType("nchar(6)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.AeStudentEmployment)
                    .HasForeignKey<AeStudentEmployment>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AeStudentEmployment_OrganizationPersonRole");

                entity.HasOne(d => d.RefEmployedAfterExit)
                    .WithMany(p => p.AeStudentEmployment)
                    .HasForeignKey(d => d.RefEmployedAfterExitId)
                    .HasConstraintName("FK_AeStudentEmployment_RefEmployedAfterExit");

                entity.HasOne(d => d.RefEmployedWhileEnrolled)
                    .WithMany(p => p.AeStudentEmployment)
                    .HasForeignKey(d => d.RefEmployedWhileEnrolledId)
                    .HasConstraintName("FK_AeStudentEmployment_RefEmployedWhileEnrolled");
            });

            modelBuilder.Entity<ApipInteraction>(entity =>
            {
                entity.ToTable("ApipInteraction", "dbo");

                entity.Property(e => e.ApipinteractionSequenceNumber)
                    .HasColumnName("APIPInteractionSequenceNumber")
                    .HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.ApipInteraction)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ApipInteraction_AssessmentItemApip");

                entity.HasOne(d => d.RefApipInteractionType)
                    .WithMany(p => p.ApipInteraction)
                    .HasForeignKey(d => d.RefApipInteractionTypeId)
                    .HasConstraintName("FK_ApipInteraction_RefAPIPInteractionType");
            });

            modelBuilder.Entity<Application>(entity =>
            {
                entity.ToTable("Application", "dbo");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(120);

                entity.Property(e => e.Uri).HasMaxLength(300);
            });

            modelBuilder.Entity<Assessment>(entity =>
            {
                entity.ToTable("Assessment", "dbo");

                entity.Property(e => e.AssessmentFamilyShortName).HasMaxLength(30);

                entity.Property(e => e.AssessmentFamilyTitle)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.AssessmentRevisionDate).HasColumnType("date");

                entity.Property(e => e.Guid)
                    .HasColumnName("GUID")
                    .HasMaxLength(40);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.Objective).HasMaxLength(100);

                entity.Property(e => e.Provider).HasMaxLength(30);

                entity.Property(e => e.ShortName).HasMaxLength(30);

                entity.Property(e => e.Title).HasMaxLength(60);

                entity.HasOne(d => d.RefAcademicSubject)
                    .WithMany(p => p.Assessment)
                    .HasForeignKey(d => d.RefAcademicSubjectId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_RefRefAcademicSubject");

                entity.HasOne(d => d.RefAssessmentPurpose)
                    .WithMany(p => p.Assessment)
                    .HasForeignKey(d => d.RefAssessmentPurposeId)
                    .HasConstraintName("FK_Assessment_RefAssessmentPurpose");

                entity.HasOne(d => d.RefAssessmentTypeChildrenWithDisabilities)
                    .WithMany(p => p.Assessment)
                    .HasForeignKey(d => d.RefAssessmentTypeChildrenWithDisabilitiesId)
                    .HasConstraintName("FK_Assessment_RefAssessmentTypeChildrenWithDisabilities");

                entity.HasOne(d => d.RefAssessmentTypeAdministeredToEnglishLearners)
                    .WithMany(p => p.Assessment)
                    .HasForeignKey(d => d.RefAssessmentTypeAdministeredToEnglishLearnersId)
                    .HasConstraintName("FK_Assessment_RefAssessmentTypeAdministeredToEnglishLearners");

                entity.HasOne(d => d.RefAssessmentType)
                    .WithMany(p => p.Assessment)
                    .HasForeignKey(d => d.RefAssessmentTypeId)
                    .HasConstraintName("FK_Assessment_RefAssessmentType");
            });

            modelBuilder.Entity<AssessmentAdministration>(entity =>
            {
                entity.ToTable("AssessmentAdministration", "dbo");

                entity.Property(e => e.AssessmentAdministrationPeriodDescription).HasMaxLength(300);

                entity.Property(e => e.Code).HasMaxLength(30);

                entity.Property(e => e.FinishDate).HasColumnType("date");

                entity.Property(e => e.Name).HasMaxLength(30);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.HasOne(d => d.RefAssessmentReportingMethod)
                    .WithMany(p => p.AssessmentAdministration)
                    .HasForeignKey(d => d.RefAssessmentReportingMethodId)
                    .HasConstraintName("FK_AssessmentAdministration_RefAssessmentReportingMethod");
            });

            modelBuilder.Entity<AssessmentAdministrationOrganization>(entity =>
            {
                entity.ToTable("AssessmentAdministration_Organization", "dbo");


                entity.HasKey(e => new { e.AssessmentAdministrationId, e.OrganizationId })
                    .HasName("IX_AssessmentAdministration_Organization");

                entity.Property(e => e.AssessmentAdministration_OrganizationId).HasColumnName("AssessmentAdministration_OrganizationId");

                entity.HasOne(d => d.AssessmentAdministration)
                    .WithMany(p => p.AssessmentAdministrationOrganization)
                    .HasForeignKey(d => d.AssessmentAdministrationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentAdministration_Organization_AssessmentAdmin");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.AssessmentAdministrationOrganization)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentAdministration_Organization_Organization");
            });

            modelBuilder.Entity<AssessmentAssessmentAdministration>(entity =>
            {
                entity.ToTable("Assessment_AssessmentAdministration", "dbo");

                entity.HasIndex(e => new { e.AssessmentId, e.AssessmentAdministrationId })
                      .IsUnique();

                entity.Property(e => e.AssessmentAssessmentAdministrationId).HasColumnName("Assessment_AssessmentAdministrationId");

                entity.HasOne(d => d.AssessmentAdministration)
                    .WithMany(p => p.AssessmentAssessmentAdministration)
                    .HasForeignKey(d => d.AssessmentAdministrationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_AssessmentAdministration_AssessmentAdministration");

                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AssessmentAssessmentAdministration)
                    .HasForeignKey(d => d.AssessmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_AssessmentAdministration_Assessment");
            });

            modelBuilder.Entity<AssessmentAsset>(entity =>
            {
                entity.ToTable("AssessmentAsset", "dbo");

                entity.Property(e => e.ContentUrl).HasMaxLength(300);

                entity.Property(e => e.ContentXml).HasColumnName("ContentXML");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.Name).HasMaxLength(60);

                entity.Property(e => e.Owner).HasMaxLength(60);

                entity.Property(e => e.PublishedDate).HasColumnType("date");

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.AssessmentAsset)
                    .HasForeignKey(d => d.LearningResourceId)
                    .HasConstraintName("FK_AssessmentAsset_LearningResource");

                entity.HasOne(d => d.RefAssessmentAssestIdentifierTypeNavigation)
                    .WithMany(p => p.AssessmentAsset)
                    .HasForeignKey(d => d.RefAssessmentAssestIdentifierType)
                    .HasConstraintName("FK_AssessmentAsset_RefAssessAssetIDType");

                entity.HasOne(d => d.RefAssessmentAssetType)
                    .WithMany(p => p.AssessmentAsset)
                    .HasForeignKey(d => d.RefAssessmentAssetTypeId)
                    .HasConstraintName("FK_AssessmentAsset_RefAssessmentAssetType");

                entity.HasOne(d => d.RefAssessmentLanguage)
                    .WithMany(p => p.AssessmentAsset)
                    .HasForeignKey(d => d.RefAssessmentLanguageId)
                    .HasConstraintName("FK_AssessmentAsset_RefLanguage");
            });

            modelBuilder.Entity<AssessmentEldevelopmentalDomain>(entity =>
            {
                entity.ToTable("AssessmentELDevelopmentalDomain", "dbo");

                entity.HasIndex(e => new { e.AssessmentId, e.RefAssessmentEldevelopmentalDomainId })
                    .IsUnique();

                entity.Property(e => e.AssessmentEldevelopmentalDomainId).HasColumnName("AssessmentELDevelopmentalDomainId");

                entity.Property(e => e.RefAssessmentEldevelopmentalDomainId).HasColumnName("RefAssessmentELDevelopmentalDomainId");

                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AssessmentEldevelopmentalDomain)
                    .HasForeignKey(d => d.AssessmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_AssessmentELDevelopmentalDomain_Assessment");

                entity.HasOne(d => d.RefAssessmentEldevelopmentalDomain)
                    .WithMany(p => p.AssessmentEldevelopmentalDomain)
                    .HasForeignKey(d => d.RefAssessmentEldevelopmentalDomainId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_AssessmentELDevelopmentalDomain_RefAssessmentELDevelopmentalDomain");
            });

            modelBuilder.Entity<AssessmentForm>(entity =>
            {
                entity.ToTable("AssessmentForm", "dbo");

                entity.Property(e => e.AssessmentFormAlgorithmIdentifier).HasMaxLength(40);

                entity.Property(e => e.AssessmentFormAlgorithmVersion).HasMaxLength(40);

                entity.Property(e => e.AssessmentFormGuid)
                    .HasColumnName("AssessmentFormGUID")
                    .HasMaxLength(40);

                entity.Property(e => e.AssessmentItemBankIdentifier).HasMaxLength(40);

                entity.Property(e => e.AssessmentItemBankName).HasMaxLength(60);

                entity.Property(e => e.FormNumber).HasMaxLength(30);

                entity.Property(e => e.IntendedAdministrationEndDate).HasColumnType("date");

                entity.Property(e => e.IntendedAdministrationStartDate).HasColumnType("date");

                entity.Property(e => e.Name).HasMaxLength(40);

                entity.Property(e => e.PublishedDate).HasColumnType("date");

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AssessmentForm)
                    .HasForeignKey(d => d.AssessmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentForm_Assessment");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.AssessmentForm)
                    .HasForeignKey(d => d.LearningResourceId)
                    .HasConstraintName("FK_AssessmentForm_LearningResource");

                entity.HasOne(d => d.RefAssessmentLanguage)
                    .WithMany(p => p.AssessmentForm)
                    .HasForeignKey(d => d.RefAssessmentLanguageId)
                    .HasConstraintName("FK_AssessmentForm_RefLanguage");
            });

            modelBuilder.Entity<AssessmentFormAssessmentAsset>(entity =>
            {
                entity.ToTable("AssessmentForm_AssessmentAsset", "dbo");

                entity.HasIndex(e => new { e.AssessmentFormId, e.AssessmentAssetId })
                    .IsUnique();

                entity.Property(e => e.AssessmentFormAssessmentAssetId).HasColumnName("AssessmentForm_AssessmentAssetId");

                entity.HasOne(d => d.AssessmentAsset)
                    .WithMany(p => p.AssessmentFormAssessmentAsset)
                    .HasForeignKey(d => d.AssessmentAssetId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentForm_AssessmentAsset_AssessmentAsset");

                entity.HasOne(d => d.AssessmentForm)
                    .WithMany(p => p.AssessmentFormAssessmentAsset)
                    .HasForeignKey(d => d.AssessmentFormId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentForm_AssessmentAsset_AssessmentForm");
            });

            modelBuilder.Entity<AssessmentFormAssessmentFormSection>(entity =>
            {
                entity.ToTable("AssessmentForm_AssessmentFormSection", "dbo");

                entity.Property(e => e.AssessmentFormAssessmentFormSectionId).HasColumnName("AssessmentForm_AssessmentFormSectionId");

                entity.HasOne(d => d.AssessmentForm)
                    .WithMany(p => p.AssessmentFormAssessmentFormSection)
                    .HasForeignKey(d => d.AssessmentFormId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentForm_AssessmentFormSection_AssessmentForm");

                entity.HasOne(d => d.AssessmentFormSection)
                    .WithMany(p => p.AssessmentFormAssessmentFormSection)
                    .HasForeignKey(d => d.AssessmentFormSectionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentForm_AssessmentFormSection_FormSection");
            });

            modelBuilder.Entity<AssessmentFormSection>(entity =>
            {
                entity.ToTable("AssessmentFormSection", "dbo");

                entity.Property(e => e.AssessmentItemBankIdentifier).HasMaxLength(40);

                entity.Property(e => e.AssessmentItemBankName).HasMaxLength(60);

                entity.Property(e => e.ChildOfFormSectionId).HasColumnName("ChildOf_FormSectionId");

                entity.Property(e => e.Guid)
                    .HasColumnName("GUID")
                    .HasMaxLength(40);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.PublishedDate).HasColumnType("date");

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.ChildOfFormSection)
                    .WithMany(p => p.InverseChildOfFormSection)
                    .HasForeignKey(d => d.ChildOfFormSectionId)
                    .HasConstraintName("FK_FormSection_FormSection");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.AssessmentFormSection)
                    .HasForeignKey(d => d.LearningResourceId)
                    .HasConstraintName("FK_AssessmentFormSection_LearningResource");

                entity.HasOne(d => d.RefAssessmentFormSectionIdentificationSystem)
                    .WithMany(p => p.AssessmentFormSection)
                    .HasForeignKey(d => d.RefAssessmentFormSectionIdentificationSystemId)
                    .HasConstraintName("FK_AssessmentFormSection_RefAssessmentFormSectionIDType");
            });

            modelBuilder.Entity<AssessmentFormSectionAssessmentAsset>(entity =>
            {
                entity.ToTable("AssessmentFormSection_AssessmentAsset", "dbo");

                entity.HasIndex(e => new { e.AssessmentFormSectionId, e.AssessmentAssetId })
                    .IsUnique();

                entity.Property(e => e.AssessmentFormSectionAssessmentAssetId).HasColumnName("AssessmentFormSection_AssessmentAssetId");

                entity.HasOne(d => d.AssessmentAsset)
                    .WithMany(p => p.AssessmentFormSectionAssessmentAsset)
                    .HasForeignKey(d => d.AssessmentAssetId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentFormSection_AssessmentAsset_AssessmentAsset");

                entity.HasOne(d => d.AssessmentFormSection)
                    .WithMany(p => p.AssessmentFormSectionAssessmentAsset)
                    .HasForeignKey(d => d.AssessmentFormSectionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentFormSection_AssessmentAsset_AssessmentFormSection");
            });

            modelBuilder.Entity<AssessmentFormSectionAssessmentItem>(entity =>
            {
                entity.HasKey(e => e.AssessmentFormSectionItemId)
                    .HasName("PK_AssessmentFormSection_AssessmentItem");

                entity.ToTable("AssessmentFormSection_AssessmentItem", "dbo");

                entity.HasOne(d => d.AssessmentFormSection)
                    .WithMany(p => p.AssessmentFormSectionAssessmentItem)
                    .HasForeignKey(d => d.AssessmentFormSectionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentFormSection_AssessmentItem_FormSection");

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.AssessmentFormSectionAssessmentItem)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentFormSection_AssessmentItem_AssessmentItem");
            });

            modelBuilder.Entity<AssessmentItem>(entity =>
            {
                entity.ToTable("AssessmentItem", "dbo");

                entity.Property(e => e.AssessmentItemBankIdentifier).HasMaxLength(40);

                entity.Property(e => e.AssessmentItemBankName).HasMaxLength(60);

                entity.Property(e => e.Difficulty).HasColumnType("decimal");

                entity.Property(e => e.DistractorAnalysis).HasMaxLength(100);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.MaximumScore).HasMaxLength(300);

                entity.Property(e => e.MinimumScore).HasMaxLength(300);

                entity.Property(e => e.TextComplexityValue).HasMaxLength(30);

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.LearningResourceId)
                    .HasConstraintName("FK_AssessmentItem_LearningResource");

                entity.HasOne(d => d.RefAssessmentItemType)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.RefAssessmentItemTypeId)
                    .HasConstraintName("FK_AssessmentItem_RefAssessmentItemType");

                entity.HasOne(d => d.RefNaepAspectsOfReading)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.RefNaepAspectsOfReadingId)
                    .HasConstraintName("FK_AssessmentItem_RefNAEPAspectsOfReading");

                entity.HasOne(d => d.RefNaepMathComplexityLevel)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.RefNaepMathComplexityLevelId)
                    .HasConstraintName("FK_AssessmentItem_RefNAEPMathComplexityLevel");

                entity.HasOne(d => d.RefTextComplexitySystem)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.RefTextComplexitySystemId)
                    .HasConstraintName("FK_AssessmentItem_RefTextComplexitySystem");

                entity.HasOne(d => d.Rubric)
                    .WithMany(p => p.AssessmentItem)
                    .HasForeignKey(d => d.RubricId)
                    .HasConstraintName("FK_AssessmentItem_Rubric");
            });

            modelBuilder.Entity<AssessmentItemApip>(entity =>
            {
                entity.HasKey(e => e.AssessmentItemId)
                    .HasName("PK_AssessmentItemBody");

                entity.ToTable("AssessmentItemApip", "dbo");

                entity.Property(e => e.AssessmentItemId).ValueGeneratedNever();

                entity.Property(e => e.ResponseProcessingTemplateUrl).HasMaxLength(300);

                entity.HasOne(d => d.AssessmentItem)
                    .WithOne(p => p.AssessmentItemApip)
                    .HasForeignKey<AssessmentItemApip>(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemBody_AssessmentItem1");
            });

            modelBuilder.Entity<AssessmentItemApipDescription>(entity =>
            {
                entity.HasKey(e => e.AssessmentItemId)
                    .HasName("PK_AssessmentItemApipDescription");

                entity.ToTable("AssessmentItemApipDescription", "dbo");

                entity.Property(e => e.AssessmentItemId).ValueGeneratedNever();

                entity.HasOne(d => d.AssessmentItem)
                    .WithOne(p => p.AssessmentItemApipDescription)
                    .HasForeignKey<AssessmentItemApipDescription>(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemApipDescription_AssessmentItemApip");

                entity.HasOne(d => d.RefKeywordTranslationLanguage)
                    .WithMany(p => p.AssessmentItemApipDescription)
                    .HasForeignKey(d => d.RefKeywordTranslationLanguageId)
                    .HasConstraintName("FK_AssessmentItemApipDescription_RefLanguage");
            });

            modelBuilder.Entity<AssessmentItemCharacteristic>(entity =>
            {
                entity.ToTable("AssessmentItemCharacteristic", "dbo");

                entity.Property(e => e.ResponseChoicePattern).HasMaxLength(100);

                entity.Property(e => e.Value).HasMaxLength(30);

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.AssessmentItemCharacteristic)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ItemCharacteristic_Item");

                entity.HasOne(d => d.RefAssessmentItemCharacteristicType)
                    .WithMany(p => p.AssessmentItemCharacteristic)
                    .HasForeignKey(d => d.RefAssessmentItemCharacteristicTypeId)
                    .HasConstraintName("FK_AssessmentItemCharacteristic_RefAssessItemCharType");
            });

            modelBuilder.Entity<AssessmentItemPossibleResponse>(entity =>
            {
                entity.ToTable("AssessmentItemPossibleResponse", "dbo");

                entity.Property(e => e.FeedbackMessage).HasMaxLength(300);

                entity.Property(e => e.Value).HasMaxLength(300);

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.AssessmentItemPossibleResponse)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemPossibleResponse_AssessmentItem");
            });

            modelBuilder.Entity<AssessmentItemResponse>(entity =>
            {
                entity.ToTable("AssessmentItemResponse", "dbo");

                entity.Property(e => e.AidSetUsed).HasMaxLength(30);

                entity.Property(e => e.AssessmentItemResponseDescriptiveFeedbackDate).HasColumnType("datetime");

                entity.Property(e => e.DescriptiveFeedback).HasMaxLength(300);

                entity.Property(e => e.ResultXml).HasColumnName("ResultXML");

                entity.Property(e => e.ScoreValue).HasMaxLength(60);

                entity.Property(e => e.SecurityIssue).HasMaxLength(300);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.Property(e => e.Value).HasMaxLength(300);

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.AssessmentItemResponse)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemResponse_AssessmentItem");

                entity.HasOne(d => d.AssessmentParticipantSession)
                    .WithMany(p => p.AssessmentItemResponse)
                    .HasForeignKey(d => d.AssessmentParticipantSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemResponse_AssessmentParticipantSession");

                entity.HasOne(d => d.RefAssessItemResponseStatus)
                    .WithMany(p => p.AssessmentItemResponse)
                    .HasForeignKey(d => d.RefAssessItemResponseStatusId)
                    .HasConstraintName("FK_AssessmentItemResponse_RefAssessItemResponseStatus");

                entity.HasOne(d => d.RefAssessmentItemResponseScoreStatus)
                    .WithMany(p => p.AssessmentItemResponse)
                    .HasForeignKey(d => d.RefAssessmentItemResponseScoreStatusId)
                    .HasConstraintName("FK_AssessmentItemResponse_RefAssessmentItemResponseScoreStatus");

                entity.HasOne(d => d.RefProficiencyStatus)
                    .WithMany(p => p.AssessmentItemResponse)
                    .HasForeignKey(d => d.RefProficiencyStatusId)
                    .HasConstraintName("FK_AssessmentItemResponse_RefProficiencyStatus");
            });

            modelBuilder.Entity<AssessmentItemResponseTheory>(entity =>
            {
                entity.HasKey(e => e.AssessmentItemId)
                    .HasName("PK_AssessmentItemResponseTheory");

                entity.ToTable("AssessmentItemResponseTheory", "dbo");

                entity.Property(e => e.AssessmentItemId).ValueGeneratedNever();

                entity.Property(e => e.Difvalue).HasColumnName("DIFValue");

                entity.HasOne(d => d.AssessmentItem)
                    .WithOne(p => p.AssessmentItemResponseTheory)
                    .HasForeignKey<AssessmentItemResponseTheory>(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentItemResponseTheory_AssessmentItem");

                entity.HasOne(d => d.RefItemResponseTheoryDifficultyCategory)
                    .WithMany(p => p.AssessmentItemResponseTheory)
                    .HasForeignKey(d => d.RefItemResponseTheoryDifficultyCategoryId)
                    .HasConstraintName("FK_AssessmentItemResponseTheory_RefIRTDifficultyCategory");

                entity.HasOne(d => d.RefItemResponseTheoryKappaAlgorithm)
                    .WithMany(p => p.AssessmentItemResponseTheory)
                    .HasForeignKey(d => d.RefItemResponseTheoryKappaAlgorithmId)
                    .HasConstraintName("FK_AssessmentItemResponseTheory_RefIRTKappaAlgorithm");
            });

            modelBuilder.Entity<AssessmentItemRubricCriterionResult>(entity =>
            {
                entity.HasKey(e => new { e.AssessmentItemResponseId, e.RubricCriterionLevelId })
                    .HasName("PK_AssessmentItemRubricCriterionResult");

                entity.ToTable("AssessmentItemRubricCriterionResult", "dbo");

                entity.HasOne(d => d.AssessmentItemResponse)
                    .WithMany(p => p.AssessmentItemRubricCriterionResult)
                    .HasForeignKey(d => d.AssessmentItemResponseId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessItemRubricCriterionResult_AssessItemResponse");

                entity.HasOne(d => d.RubricCriterionLevel)
                    .WithMany(p => p.AssessmentItemRubricCriterionResult)
                    .HasForeignKey(d => d.RubricCriterionLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessItemRubricCriterionResult_RubricCriterionLevel");
            });

            modelBuilder.Entity<AssessmentLanguage>(entity =>
            {
                entity.ToTable("AssessmentLanguage", "dbo");

                entity.HasIndex(e => new { e.AssessmentId, e.RefLanguageId })
                    .IsUnique();

                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AssessmentLanguage)
                    .HasForeignKey(d => d.AssessmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentLanguage_Assessment");

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.AssessmentLanguage)
                    .HasForeignKey(d => d.RefLanguageId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentLanguage_RefLanguage");
            });

            modelBuilder.Entity<AssessmentLevelsForWhichDesigned>(entity =>
            {
                entity.ToTable("AssessmentLevelsForWhichDesigned", "dbo");

                entity.HasIndex(e => new { e.AssessmentId, e.RefGradeLevelId })
                    .IsUnique();

                entity.HasOne(d => d.Assessment)
                    .WithMany(p => p.AssessmentLevelsForWhichDesigned)
                    .HasForeignKey(d => d.AssessmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_LevelsForWhichDesigned_Assessment");

                entity.HasOne(d => d.RefGradeLevel)
                    .WithMany(p => p.AssessmentLevelsForWhichDesigned)
                    .HasForeignKey(d => d.RefGradeLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Assessment_LevelsForWhichDesigned_RefGrade");
            });

            modelBuilder.Entity<AssessmentNeedApipContent>(entity =>
            {
                entity.ToTable("AssessmentNeedApipContent", "dbo");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileContent)
                    .WithMany(p => p.AssessmentNeedApipContent)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileContentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessNeedApipContent_AssessmentPersonalNeedsProfileContent");

                entity.HasOne(d => d.ItemTranslationDisplayLanguageType)
                    .WithMany(p => p.AssessmentNeedApipContentItemTranslationDisplayLanguageType)
                    .HasForeignKey(d => d.ItemTranslationDisplayLanguageTypeId)
                    .HasConstraintName("FK_AssessmentNeedApipContent_RefLanguage");

                entity.HasOne(d => d.KeywordTranslationLanguageType)
                    .WithMany(p => p.AssessmentNeedApipContentKeywordTranslationLanguageType)
                    .HasForeignKey(d => d.KeywordTranslationLanguageTypeId)
                    .HasConstraintName("FK_AssessmentNeedApipContent_RefLanguage1");

                entity.HasOne(d => d.RefAssessmentNeedAlternativeRepresentationType)
                    .WithMany(p => p.AssessmentNeedApipContent)
                    .HasForeignKey(d => d.RefAssessmentNeedAlternativeRepresentationTypeId)
                    .HasConstraintName("FK_AssessNeedApipContent_RefAssessmentNeedAlternativeRepresent");

                entity.HasOne(d => d.RefAssessmentNeedSigningType)
                    .WithMany(p => p.AssessmentNeedApipContent)
                    .HasForeignKey(d => d.RefAssessmentNeedSigningTypeId)
                    .HasConstraintName("FK_AssessmentNeedApipContent_RefAssessmentNeedSigningType");

                entity.HasOne(d => d.RefAssessmentNeedSpokenSourcePreferenceType)
                    .WithMany(p => p.AssessmentNeedApipContent)
                    .HasForeignKey(d => d.RefAssessmentNeedSpokenSourcePreferenceTypeId)
                    .HasConstraintName("FK_AssessNeedApipContent_RefAssessmentNeedSpokenSourcePref");

                entity.HasOne(d => d.RefAssessmentNeedUserSpokenPreferenceType)
                    .WithMany(p => p.AssessmentNeedApipContent)
                    .HasForeignKey(d => d.RefAssessmentNeedUserSpokenPreferenceTypeId)
                    .HasConstraintName("FK_AssessNeedApipContent_RefAssessmentNeedUserSpokenPreference");
            });

            modelBuilder.Entity<AssessmentNeedApipControl>(entity =>
            {
                entity.ToTable("AssessmentNeedApipControl", "dbo");

                entity.Property(e => e.AssessmentNeedTimeMultiplier).HasMaxLength(9);

                entity.Property(e => e.BackgroundColor).HasColumnType("nchar(6)");

                entity.Property(e => e.LineReaderHighlightColor).HasColumnType("nchar(6)");

                entity.Property(e => e.OverlayColor).HasColumnType("nchar(6)");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileControl)
                    .WithMany(p => p.AssessmentNeedApipControl)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileControlId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessNeedApipControl_AssessmentPersonalNeedsProfileControl");

                entity.HasOne(d => d.RefAssessmentNeedIncreasedWhitespacingType)
                    .WithMany(p => p.AssessmentNeedApipControl)
                    .HasForeignKey(d => d.RefAssessmentNeedIncreasedWhitespacingTypeId)
                    .HasConstraintName("FK_AssessNeedApipControl_RefAssessmentNeedIncreasedWhitespacing");
            });

            modelBuilder.Entity<AssessmentNeedApipDisplay>(entity =>
            {
                entity.ToTable("AssessmentNeedApipDisplay", "dbo");

                entity.Property(e => e.EncouragementSoundFileUrl).HasMaxLength(300);

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileDisplay)
                    .WithMany(p => p.AssessmentNeedApipDisplay)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileDisplayId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessNeedApipDisplay_AssessmentPersonalNeedsProfileDisplay");

                entity.HasOne(d => d.RefAssessmentNeedMaskingType)
                    .WithMany(p => p.AssessmentNeedApipDisplay)
                    .HasForeignKey(d => d.RefAssessmentNeedMaskingTypeId)
                    .HasConstraintName("FK_AssessmentNeedApipDisplay_RefAssessmentNeedMaskingType");
            });

            modelBuilder.Entity<AssessmentNeedBraille>(entity =>
            {
                entity.ToTable("AssessmentNeedBraille", "dbo");

                entity.Property(e => e.BrailleDotPressure).HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileDisplay)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileDisplayId)
                    .HasConstraintName("FK_AssessmentNeedBraille_AssessmentPersonalNeedsProfileDisplay");

                entity.HasOne(d => d.RefAssessmentNeedBrailleGradeType)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.RefAssessmentNeedBrailleGradeTypeId)
                    .HasConstraintName("FK_AssessmentNeedBraille_AssessmentNeedBrailleGradeTypeId");

                entity.HasOne(d => d.RefAssessmentNeedBrailleMarkType)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.RefAssessmentNeedBrailleMarkTypeId)
                    .HasConstraintName("FK_AssessmentNeedBraille_RefAssessmentNeedBrailleMarkType");

                entity.HasOne(d => d.RefAssessmentNeedBrailleStatusCellType)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.RefAssessmentNeedBrailleStatusCellTypeId)
                    .HasConstraintName("FK_AssessmentNeedBraille_RefAssessmentNeedBrailleStatusCellType");

                entity.HasOne(d => d.RefAssessmentNeedNumberOfBrailleDots)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.RefAssessmentNeedNumberOfBrailleDotsId)
                    .HasConstraintName("FK_AssessmentNeedBraille_RefAssessmentNeedNumberOfBrailleDots");

                entity.HasOne(d => d.RefAssessmentNeedUsageType)
                    .WithMany(p => p.AssessmentNeedBraille)
                    .HasForeignKey(d => d.RefAssessmentNeedUsageTypeId)
                    .HasConstraintName("FK_AssessmentNeedBraille_RefAssessmentNeedUsageType");
            });

            modelBuilder.Entity<AssessmentNeedScreenEnhancement>(entity =>
            {
                entity.ToTable("AssessmentNeedScreenEnhancement", "dbo");

                entity.Property(e => e.ForegroundColor).HasColumnType("nchar(6)");

                entity.Property(e => e.Magnification).HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileDisplay)
                    .WithMany(p => p.AssessmentNeedScreenEnhancement)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileDisplayId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessNeedScreenEnhancement_AssessPersonalNeedProfileDisplay");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileScreenEnhancement)
                    .WithMany(p => p.AssessmentNeedScreenEnhancement)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileScreenEnhancementId)
                    .HasConstraintName("FK_AssessNeedScreenEnhancement_APNProfileScreenEnhancement");
            });

            modelBuilder.Entity<AssessmentParticipantSession>(entity =>
            {
                entity.ToTable("AssessmentParticipantSession", "dbo");

                entity.Property(e => e.ActualEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.ActualStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.AssessmentParticipantSessionDatabaseName).HasMaxLength(300);

                entity.Property(e => e.AssessmentParticipantSessionGuid)
                    .HasColumnName("AssessmentParticipantSessionGUID")
                    .HasMaxLength(40);

                entity.Property(e => e.DeliveryDeviceDetails).HasMaxLength(300);

                entity.Property(e => e.SecurityIssue).HasMaxLength(300);

                entity.Property(e => e.SpecialEventDescription).HasMaxLength(60);

                entity.Property(e => e.TimeAssessed).HasMaxLength(30);

                entity.HasOne(d => d.AssessmentFormSection)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.AssessmentFormSectionId)
                    .HasConstraintName("FK_AssessmentParticipantSession_AssessmentFormSection");

                entity.HasOne(d => d.AssessmentRegistration)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.AssessmentRegistrationId)
                    .HasConstraintName("FK_AssessmentParticipantSession_AssessmentRegistration");

                entity.HasOne(d => d.AssessmentSession)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.AssessmentSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentParticipantSession_AssessmentSession");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.LocationId)
                    .HasConstraintName("FK_AssessmentParticipantSession_Location");

                entity.HasOne(d => d.RefAssessmentPlatformType)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.RefAssessmentPlatformTypeId)
                    .HasConstraintName("FK_AssessParticipantSession_RefAssessmentParticipantSessionPlat");

                entity.HasOne(d => d.RefAssessmentSessionSpecialCircumstanceType)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.RefAssessmentSessionSpecialCircumstanceTypeId)
                    .HasConstraintName("FK_AssessParticipantSession_RefAssessmentSessionSpecialCircumst");

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.AssessmentParticipantSession)
                    .HasForeignKey(d => d.RefLanguageId)
                    .HasConstraintName("FK_AssessmentParticipantSession_RefLanguage");
            });

            modelBuilder.Entity<AssessmentParticipantSessionAccommodation>(entity =>
            {
                entity.ToTable("AssessmentParticipantSession_Accommodation", "dbo");

                entity.HasIndex(e => new { e.AssessmentParticipantSessionId, e.RefAssessmentAccommodationTypeId })
                    .IsUnique();

                entity.Property(e => e.AssessmentParticipantSessionAccommodationId).HasColumnName("AssessmentParticipantSession_AccommodationId");

                entity.HasOne(d => d.AssessmentParticipantSession)
                    .WithMany(p => p.AssessmentParticipantSessionAccommodation)
                    .HasForeignKey(d => d.AssessmentParticipantSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessParticSession_Accomodation_AssessParticipantSession");

                entity.HasOne(d => d.RefAssessmentAccommodationCategory)
                    .WithMany(p => p.AssessmentParticipantSessionAccommodation)
                    .HasForeignKey(d => d.RefAssessmentAccommodationCategoryId)
                    .HasConstraintName("FK_AssessPartSession_Accommodation _RefAssessmentAccommodationCategory");

                entity.HasOne(d => d.RefAssessmentAccommodationType)
                    .WithMany(p => p.AssessmentParticipantSessionAccommodation)
                    .HasForeignKey(d => d.RefAssessmentAccommodationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessParticipantSession_Accomodation_RefAssessmentAccommod");
            });

            modelBuilder.Entity<AssessmentPerformanceLevel>(entity =>
            {
                entity.ToTable("AssessmentPerformanceLevel", "dbo");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.Label).HasMaxLength(20);

                entity.Property(e => e.LowerCutScore).HasMaxLength(30);

                entity.Property(e => e.ScoreMetric).HasMaxLength(30);

                entity.Property(e => e.UpperCutScore).HasMaxLength(30);

                entity.HasOne(d => d.AssessmentSubtest)
                    .WithMany(p => p.AssessmentPerformanceLevel)
                    .HasForeignKey(d => d.AssessmentSubtestId)
                    .HasConstraintName("FK_PerformanceLevel_AssessmentSubTest");
            });

            modelBuilder.Entity<AssessmentPersonalNeedLanguageLearner>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedLanguageLearner", "dbo");

                entity.HasOne(d => d.AssessmentNeedsProfileContent)
                    .WithMany(p => p.AssessmentPersonalNeedLanguageLearner)
                    .HasForeignKey(d => d.AssessmentNeedsProfileContentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ANPContentLanguageLearner_AssessmentNeedsProfileContent");

                entity.HasOne(d => d.RefAssessmentNeedsProfileContentLanguageLearnerType)
                    .WithMany(p => p.AssessmentPersonalNeedLanguageLearner)
                    .HasForeignKey(d => d.RefAssessmentNeedsProfileContentLanguageLearnerTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ANPContentLanguageLearner_RefAssessNeedsProfileContentLang");
            });

            modelBuilder.Entity<AssessmentPersonalNeedScreenReader>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedScreenReader", "dbo");

                entity.Property(e => e.Pitch).HasColumnType("decimal");

                entity.Property(e => e.Volume).HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfileDisplay)
                    .WithMany(p => p.AssessmentPersonalNeedScreenReader)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileDisplayId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_APNScreenReader_AssessmentPersonalNeedsProfileDisplay");

                entity.HasOne(d => d.RefAssessmentNeedUsageType)
                    .WithMany(p => p.AssessmentPersonalNeedScreenReader)
                    .HasForeignKey(d => d.RefAssessmentNeedUsageTypeId)
                    .HasConstraintName("FK_AssessmentPersonalNeedScreenReader_RefAssessmentNeedUsage");
            });

            modelBuilder.Entity<AssessmentPersonalNeedsProfile>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedsProfile", "dbo");

                entity.Property(e => e.AssessmentNeedType).IsRequired();
            });

            modelBuilder.Entity<AssessmentPersonalNeedsProfileContent>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedsProfileContent", "dbo");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfile)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileContent)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentNeedsProfileContent_AssessmentNeedsProfile");

                entity.HasOne(d => d.RefAssessmentNeedHazardType)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileContent)
                    .HasForeignKey(d => d.RefAssessmentNeedHazardTypeId)
                    .HasConstraintName("FK_AssessmentPersonalNeedsProfileContent_RefAssessmentNeedHazrd");

                entity.HasOne(d => d.RefAssessmentNeedSupportTool)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileContent)
                    .HasForeignKey(d => d.RefAssessmentNeedSupportToolId)
                    .HasConstraintName("FK_ApnProfileContent_RefAssessmentNeedSupportTool");

                entity.HasOne(d => d.RefKeywordTranslationsLanguage)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileContent)
                    .HasForeignKey(d => d.RefKeywordTranslationsLanguageId)
                    .HasConstraintName("FK_AssessmentPersonalNeedsProfileContent_RefLanguage");
            });

            modelBuilder.Entity<AssessmentPersonalNeedsProfileControl>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedsProfileControl", "dbo");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfile)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileControl)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentNeedsProfileControl_AssessmentNeedsProfile");
            });

            modelBuilder.Entity<AssessmentPersonalNeedsProfileDisplay>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedsProfileDisplay", "dbo");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfile)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileDisplay)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentNeedsProfileDisplay_AssessmentNeedsProfile");
            });

            modelBuilder.Entity<AssessmentPersonalNeedsProfileScreenEnhancement>(entity =>
            {
                entity.ToTable("AssessmentPersonalNeedsProfileScreenEnhancement", "dbo");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfile)
                    .WithMany(p => p.AssessmentPersonalNeedsProfileScreenEnhancement)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AnpScreenEnhancement_AssessmentNeedsProfile");
            });

            modelBuilder.Entity<AssessmentRegistration>(entity =>
            {
                entity.ToTable("AssessmentRegistration", "dbo");

                entity.Property(e => e.AssessmentRegistrationCompletionStatusDateTime).HasColumnType("datetime");

                entity.Property(e => e.CreationDate).HasColumnType("datetime");

                entity.Property(e => e.LeafullAcademicYear).HasColumnName("LEAFullAcademicYear");

                entity.Property(e => e.ScorePublishDate).HasColumnType("date");

                entity.Property(e => e.TestAttemptIdentifier).HasMaxLength(40);

                entity.Property(e => e.TestingIndicator).HasMaxLength(300);

                entity.HasOne(d => d.AssessmentAdministration)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.AssessmentAdministrationId)
                    .HasConstraintName("FK_AssessmentRegistration_AssessmentAdministration");

                entity.HasOne(d => d.AssessmentForm)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.AssessmentFormId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentRegirstration_RefAssessmentForm");

                entity.HasOne(d => d.AssignedByPerson)
                    .WithMany(p => p.AssessmentRegistrationAssignedByPerson)
                    .HasForeignKey(d => d.AssignedByPersonId)
                    .HasConstraintName("FK_AssessmentRegistration_Person");

                entity.HasOne(d => d.CourseSection)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.CourseSectionId)
                    .HasConstraintName("FK_AssessmentRegistration_CourseSection");

                entity.HasOne(d => d.LeaOrganization)
                    .WithMany(p => p.AssessmentRegistrationLeaOrganization)
                    .HasForeignKey(d => d.LeaOrganizationId)
                    .HasConstraintName("FK_AssessmentRegistration_RefOrganization2");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.AssessmentRegistrationOrganization)
                    .HasForeignKey(d => d.OrganizationId)
                    .HasConstraintName("FK_AssessmentRegistration_Organization");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.AssessmentRegistrationPerson)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentRegistration_Person2");

                entity.HasOne(d => d.RefAssessmentParticipationIndicator)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.RefAssessmentParticipationIndicatorId)
                    .HasConstraintName("FK_AssessmentRegistration_RefAssessmentParticipationIndicator");

                entity.HasOne(d => d.RefAssessmentPurpose)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.RefAssessmentPurposeId)
                    .HasConstraintName("FK_AssessmentRegistration_RefAssessmentPurpose");

                entity.HasOne(d => d.RefAssessmentReasonNotCompleting)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.RefAssessmentReasonNotCompletingId)
                    .HasConstraintName("FK_AssessmentRegistration_RefAssessmentReasonNotCompleting");

                entity.HasOne(d => d.RefAssessmentReasonNotTested)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.RefAssessmentReasonNotTestedId)
                    .HasConstraintName("FK_AssessmentRegistration_RefAssessmentReasonNotTested");

                entity.HasOne(d => d.RefAssessmentRegistrationCompletionStatus)
                    .WithMany(p => p.AssessmentRegistration)
                    .HasForeignKey(d => d.RefAssessmentRegistrationCompletionStatusId)
                    .HasConstraintName("FK_AssessmentRegistration_RefAssessmentRegistrationCompletionStatus");

                entity.HasOne(d => d.RefGradeLevelToBeAssessed)
                    .WithMany(p => p.AssessmentRegistrationRefGradeLevelToBeAssessed)
                    .HasForeignKey(d => d.RefGradeLevelToBeAssessedId)
                    .HasConstraintName("FK_AssessmentRegistration_RefGradeLevel1");

                entity.HasOne(d => d.RefGradeLevelWhenAssessed)
                    .WithMany(p => p.AssessmentRegistrationRefGradeLevelWhenAssessed)
                    .HasForeignKey(d => d.RefGradeLevelWhenAssessedId)
                    .HasConstraintName("FK_AssessmentRegistration_RefGradeLevel");

                entity.HasOne(d => d.SchoolOrganization)
                    .WithMany(p => p.AssessmentRegistrationSchoolOrganization)
                    .HasForeignKey(d => d.SchoolOrganizationId)
                    .HasConstraintName("FK_AssessmentRegistration_RefOrganization1");
            });

            modelBuilder.Entity<AssessmentRegistrationAccommodation>(entity =>
            {
                entity.ToTable("AssessmentRegistration_Accommodation", "dbo");

                entity.HasIndex(e => new { e.AssessmentRegistrationId, e.RefAssessmentAccommodationTypeId })
                    .IsUnique();

                entity.Property(e => e.AssessmentRegistrationAccommodationId).HasColumnName("AssessmentRegistration_AccommodationId");

                entity.Property(e => e.OtherDescription).HasMaxLength(30);

                entity.HasOne(d => d.AssessmentRegistration)
                    .WithMany(p => p.AssessmentRegistrationAccommodation)
                    .HasForeignKey(d => d.AssessmentRegistrationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentRegistration_Registration");

                entity.HasOne(d => d.RefAssessmentAccommodationCategory)
                    .WithMany(p => p.AssessmentRegistrationAccommodation)
                    .HasForeignKey(d => d.RefAssessmentAccommodationCategoryId)
                    .HasConstraintName("FK_AssessReg_Accommodation _RefAssessmentAccommodationCategory");

                entity.HasOne(d => d.RefAssessmentAccommodationType)
                    .WithMany(p => p.AssessmentRegistrationAccommodation)
                    .HasForeignKey(d => d.RefAssessmentAccommodationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentRegistration_RefRefAssessmentAccommodation");
            });

            modelBuilder.Entity<AssessmentResult>(entity =>
            {
                entity.ToTable("AssessmentResult", "dbo");

                entity.Property(e => e.AssessmentResultDescriptiveFeedbackDateTime).HasColumnType("datetime");

                entity.Property(e => e.AssessmentResultScoreStandardError).HasColumnType("decimal");

                entity.Property(e => e.DateCreated).HasColumnType("date");

                entity.Property(e => e.DateUpdated).HasColumnType("date");

                entity.Property(e => e.DescriptiveFeedback).HasMaxLength(300);

                entity.Property(e => e.DescriptiveFeedbackSource).HasMaxLength(60);

                entity.Property(e => e.DiagnosticStatementSource).HasMaxLength(300);

                entity.Property(e => e.InstructionalRecommendation).HasMaxLength(100);

                entity.Property(e => e.RefEloutcomeMeasurementLevelId).HasColumnName("RefELOutcomeMeasurementLevelId");

                entity.Property(e => e.ScoreValue).HasMaxLength(35);

                entity.HasOne(d => d.AssessmentRegistration)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.AssessmentRegistrationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResult_AssessmentRegistration");

                entity.HasOne(d => d.AssessmentSubtest)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.AssessmentSubtestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResult_AssessmentSubTest");

                entity.HasOne(d => d.RefAssessmentPretestOutcome)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefAssessmentPretestOutcomeId)
                    .HasConstraintName("FK_AssessmentResult_RefAssessmentPretestOutcome");

                entity.HasOne(d => d.RefAssessmentResultDataType)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefAssessmentResultDataTypeId)
                    .HasConstraintName("FK_AssessmentResult_RefAssessmentResultDataType");

                entity.HasOne(d => d.RefAssessmentResultScoreType)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefAssessmentResultScoreTypeId)
                    .HasConstraintName("FK_AssessmentResult_RefAssessmentResultScoreType");

                entity.HasOne(d => d.RefEloutcomeMeasurementLevel)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefEloutcomeMeasurementLevelId)
                    .HasConstraintName("FK_AssessmentResult_RefELOutcomeMeasurement");

                entity.HasOne(d => d.RefOutcomeTimePoint)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefOutcomeTimePointId)
                    .HasConstraintName("FK_AssessmentResult_RefOutcomeTimePoint");

                entity.HasOne(d => d.RefScoreMetricType)
                    .WithMany(p => p.AssessmentResult)
                    .HasForeignKey(d => d.RefScoreMetricTypeId)
                    .HasConstraintName("FK_AssessmentResult_RefScoreMetricType");
            });

            modelBuilder.Entity<AssessmentResult_PerformanceLevel>(entity =>
            {
                entity.ToTable("AssessmentResult_PerformanceLevel", "dbo");

                entity.Property(e => e.AssessmentResult_PerformanceLevelId).HasColumnName("AssessmentResult_PerformanceLevelId");

                entity.HasOne(d => d.AssessmentPerformanceLevel)
                    .WithMany(p => p.AssessmentResultPerformanceLevel)
                    .HasForeignKey(d => d.AssessmentPerformanceLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResult_PerformanceLevel_AssessmentPerformanceLevel");

                entity.HasOne(d => d.AssessmentResult)
                    .WithMany(p => p.AssessmentResultPerformanceLevel)
                    .HasForeignKey(d => d.AssessmentResultId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResult_PerformanceLevel_AssessmentResult");
            });

            modelBuilder.Entity<AssessmentResultRubricCriterionResult>(entity =>
            {
                entity.ToTable("AssessmentResultRubricCriterionResult", "dbo");

                entity.HasIndex(e => new { e.AssessmentResultId, e.RubricCriterionLevelId })
                    .IsUnique();

                entity.HasOne(d => d.AssessmentResult)
                    .WithMany(p => p.AssessmentResultRubricCriterionResult)
                    .HasForeignKey(d => d.AssessmentResultId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResultRubricCriterionResult_AssessmentResult");

                entity.HasOne(d => d.RubricCriterionLevel)
                    .WithMany(p => p.AssessmentResultRubricCriterionResult)
                    .HasForeignKey(d => d.RubricCriterionLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentResultRubricCriterionResult_RubricCriterionLevel");
            });

            modelBuilder.Entity<AssessmentSession>(entity =>
            {
                entity.ToTable("AssessmentSession", "dbo");

                entity.Property(e => e.ActualEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.ActualStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.LeaOrganizationId).HasColumnName("Lea_OrganizationId");

                entity.Property(e => e.Location).HasMaxLength(45);

                entity.Property(e => e.ScheduledEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.ScheduledStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolOrganizationId).HasColumnName("School_OrganizationId");

                entity.Property(e => e.SecurityIssue).HasMaxLength(300);

                entity.Property(e => e.SpecialEventDescription).HasMaxLength(60);

                entity.HasOne(d => d.AssessmentAdministration)
                    .WithMany(p => p.AssessmentSession)
                    .HasForeignKey(d => d.AssessmentAdministrationId)
                    .HasConstraintName("FK_AssessmentSession_AssessmentAdministration");

                entity.HasOne(d => d.LeaOrganization)
                    .WithMany(p => p.AssessmentSessionLeaOrganization)
                    .HasForeignKey(d => d.LeaOrganizationId)
                    .HasConstraintName("FK_AssessmentSession_Organization");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.AssessmentSessionOrganization)
                    .HasForeignKey(d => d.OrganizationId)
                    .HasConstraintName("FK_AssessmentSession_Organization2");

                entity.HasOne(d => d.RefAssessmentSessionSpecialCircumstanceType)
                    .WithMany(p => p.AssessmentSession)
                    .HasForeignKey(d => d.RefAssessmentSessionSpecialCircumstanceTypeId)
                    .HasConstraintName("FK_AssessmentSession_RefAssessmentSessionSpecialCircumstance");

                entity.HasOne(d => d.RefAssessmentSessionType)
                    .WithMany(p => p.AssessmentSession)
                    .HasForeignKey(d => d.RefAssessmentSessionTypeId)
                    .HasConstraintName("FK_AssessmentSession_RefAssessmentSessionType");

                entity.HasOne(d => d.SchoolOrganization)
                    .WithMany(p => p.AssessmentSessionSchoolOrganization)
                    .HasForeignKey(d => d.SchoolOrganizationId)
                    .HasConstraintName("FK_AssessmentSession_Organization1");
            });

            modelBuilder.Entity<AssessmentSessionStaffRole>(entity =>
            {
                entity.ToTable("AssessmentSessionStaffRole", "dbo");

                entity.HasOne(d => d.AssessmentParticipantSession)
                    .WithMany(p => p.AssessmentSessionStaffRole)
                    .HasForeignKey(d => d.AssessmentParticipantSessionId)
                    .HasConstraintName("FK_AssessmentSessionStaffRole_AssessmentParticipantSession");

                entity.HasOne(d => d.AssessmentSession)
                    .WithMany(p => p.AssessmentSessionStaffRole)
                    .HasForeignKey(d => d.AssessmentSessionId)
                    .HasConstraintName("FK_AssessmentSessionStaffRole_AssessmentSession");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.AssessmentSessionStaffRole)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSessionStaffRole_Person");

                entity.HasOne(d => d.RefAssessmentSessionStaffRoleType)
                    .WithMany(p => p.AssessmentSessionStaffRole)
                    .HasForeignKey(d => d.RefAssessmentSessionStaffRoleTypeId)
                    .HasConstraintName("FK_AssessmentSessionStaffRole_RefAssessmentSessionStaffRoleType");
            });

            modelBuilder.Entity<AssessmentSubtest>(entity =>
            {
                entity.ToTable("AssessmentSubtest", "dbo");

                entity.Property(e => e.Abbreviation).HasMaxLength(30);

                entity.Property(e => e.ChildOf_AssessmentSubtestId).HasColumnName("ChildOf_AssessmentSubtestId");

                entity.Property(e => e.ContainerOnly).HasMaxLength(30);

                entity.Property(e => e.Description).HasMaxLength(60);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.MaximumValue).HasMaxLength(30);

                entity.Property(e => e.MinimumValue).HasMaxLength(30);

                entity.Property(e => e.OptimalValue).HasMaxLength(30);

                entity.Property(e => e.PublishedDate).HasColumnType("date");

                entity.Property(e => e.Title).HasMaxLength(60);

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.AssessmentForm)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.AssessmentFormId)
                    .HasConstraintName("FK_AssessmentSubTest_AssessmentForm");

                entity.HasOne(d => d.ChildOfAssessmentSubtest)
                    .WithMany(p => p.InverseChildOfAssessmentSubtest)
                    .HasForeignKey(d => d.ChildOf_AssessmentSubtestId)
                    .HasConstraintName("FK_AssessmentSubtest_AssessmentSubTest");

                entity.HasOne(d => d.RefAcademicSubject)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.RefAcademicSubjectId)
                    .HasConstraintName("FK_FormSubTest_RefAcademicSubject");

                entity.HasOne(d => d.RefAssessmentPurpose)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.RefAssessmentPurposeId)
                    .HasConstraintName("FK_AssessmentSubtest_RefAssessmentPurpose");

                entity.HasOne(d => d.RefAssessmentSubtestIdentifierType)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.RefAssessmentSubtestIdentifierTypeId)
                    .HasConstraintName("FK_AssessmentSubtest_RefAssessSubtestIdentifierType");

                entity.HasOne(d => d.RefContentStandardType)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.RefContentStandardTypeId)
                    .HasConstraintName("FK_AssessmentSubtest_RefContentStandardType");

                entity.HasOne(d => d.RefScoreMetricType)
                    .WithMany(p => p.AssessmentSubtest)
                    .HasForeignKey(d => d.RefScoreMetricTypeId)
                    .HasConstraintName("FK_AssessmentSubtest_RefScoreMetricType");
            });

            modelBuilder.Entity<AssessmentSubtestAssessmentItem>(entity =>
            {
                entity.HasKey(e => e.AssessmentSubtestItemId)
                    .HasName("PK_AssessmentSubtest_AssessmentItem");

                entity.ToTable("AssessmentSubtest_AssessmentItem", "dbo");

                entity.Property(e => e.ItemWeightCorrect).HasColumnType("decimal");

                entity.Property(e => e.ItemWeightIncorrect).HasColumnType("decimal");

                entity.Property(e => e.ItemWeightNotAttempted).HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentItem)
                    .WithMany(p => p.AssessmentSubtestAssessmentItem)
                    .HasForeignKey(d => d.AssessmentItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtestAI_AssessmentItem");

                entity.HasOne(d => d.AssessmentSubtest)
                    .WithMany(p => p.AssessmentSubtestAssessmentItem)
                    .HasForeignKey(d => d.AssessmentSubtestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtestItems_AssessmentSubTest");
            });

            modelBuilder.Entity<AssessmentSubtestEldevelopmentalDomain>(entity =>
            {
                entity.ToTable("AssessmentSubtestELDevelopmentalDomain", "dbo");

                entity.HasIndex(e => new { e.AssessmentSubtestId, e.RefAssessmentEldevelopmentalDomainId })
                    .IsUnique();

                entity.Property(e => e.AssessmentSubtestEldevelopmentalDomainId).HasColumnName("AssessmentSubtestELDevelopmentalDomainId");

                entity.Property(e => e.RefAssessmentEldevelopmentalDomainId).HasColumnName("RefAssessmentELDevelopmentalDomainId");

                entity.HasOne(d => d.AssessmentSubtest)
                    .WithMany(p => p.AssessmentSubtestEldevelopmentalDomain)
                    .HasForeignKey(d => d.AssessmentSubtestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtest_AssessmentELDevelopmentalDomain_AssessmentSubtest");

                entity.HasOne(d => d.RefAssessmentEldevelopmentalDomain)
                    .WithMany(p => p.AssessmentSubtestEldevelopmentalDomain)
                    .HasForeignKey(d => d.RefAssessmentEldevelopmentalDomainId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtest_AssessmentELDevelopmentalDomain_RefAssessmentELDevelopmentalDomain");
            });

            modelBuilder.Entity<AssessmentSubtestLearningStandardItem>(entity =>
            {
                entity.ToTable("AssessmentSubtest_LearningStandardItem", "dbo");

                entity.HasIndex(e => new { e.AssessmentSubtestId, e.LearningStandardItemId })
                    .IsUnique();

                entity.Property(e => e.AssessmentSubTestLearningStandardItemId).HasColumnName("AssessmentSubTest_LearningStandardItemId");

                entity.HasOne(d => d.AssessmentSubtest)
                    .WithMany(p => p.AssessmentSubtestLearningStandardItem)
                    .HasForeignKey(d => d.AssessmentSubtestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtestLearningStandardItem_AssessmentSubtest");

                entity.HasOne(d => d.LearningStandardItem)
                    .WithMany(p => p.AssessmentSubtestLearningStandardItem)
                    .HasForeignKey(d => d.LearningStandardItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubTestLearningStandardItem_LearningStandardItem");
            });

            modelBuilder.Entity<AssessmentSubtestLevelsForWhichDesigned>(entity =>
            {
                entity.ToTable("AssessmentSubtestLevelsForWhichDesigned", "dbo");

                entity.HasIndex(e => new { e.AssessmentSubTestId, e.RefGradeId })
                    .IsUnique();

                entity.HasOne(d => d.AssessmentSubTest)
                    .WithMany(p => p.AssessmentSubtestLevelsForWhichDesigned)
                    .HasForeignKey(d => d.AssessmentSubTestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtestLevelsForWhichDesigned_AssessmentSubtest");

                entity.HasOne(d => d.RefGrade)
                    .WithMany(p => p.AssessmentSubtestLevelsForWhichDesigned)
                    .HasForeignKey(d => d.RefGradeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_AssessmentSubtestLevelsForWhichDesigned_RefGrade");
            });

            modelBuilder.Entity<Authentication>(entity =>
            {
                entity.ToTable("Authentication", "dbo");

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.IdentityProviderName).HasMaxLength(60);

                entity.Property(e => e.IdentityProviderUri).HasMaxLength(300);

                entity.Property(e => e.LoginIdentifier).HasMaxLength(40);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.Authentication)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Authentication_OrganizationPersonRole");
            });

            modelBuilder.Entity<Authorization>(entity =>
            {
                entity.ToTable("Authorization", "dbo");

                entity.Property(e => e.ApplicationRoleName)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.HasOne(d => d.Application)
                    .WithMany(p => p.Authorization)
                    .HasForeignKey(d => d.ApplicationId)
                    .HasConstraintName("FK_Authorization_Application");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.Authorization)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Authorization_OrganizationPersonRole");
            });

            modelBuilder.Entity<Classroom>(entity =>
            {
                entity.HasKey(e => e.LocationId)
                    .HasName("PK_Classroom");

                entity.ToTable("Classroom", "dbo");

                entity.Property(e => e.LocationId).ValueGeneratedNever();

                entity.Property(e => e.ClassroomIdentifier).HasMaxLength(40);

                entity.HasOne(d => d.Location)
                    .WithOne(p => p.Classroom)
                    .HasForeignKey<Classroom>(d => d.LocationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Classroom_Location");
            });

            modelBuilder.Entity<CompetencyItemCompetencySet>(entity =>
            {
                entity.ToTable("CompetencyItem_CompetencySet", "dbo");

                entity.HasIndex(e => new { e.LearningStandardItemId, e.CompetencySetId })
                    .IsUnique();

                entity.Property(e => e.CompetencyItemCompetencySetId).HasColumnName("CompetencyItem_CompetencySetId");

                entity.HasOne(d => d.CompetencySet)
                    .WithMany(p => p.CompetencyItemCompetencySet)
                    .HasForeignKey(d => d.CompetencySetId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CompetencyItem_CompetencySet_CompetencySet");

                entity.HasOne(d => d.LearningStandardItem)
                    .WithMany(p => p.CompetencyItemCompetencySet)
                    .HasForeignKey(d => d.LearningStandardItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CompetencyItem_CompetencySet_LearningStandardItem");
            });

            modelBuilder.Entity<CompetencySet>(entity =>
            {
                entity.ToTable("CompetencySet", "dbo");

                entity.Property(e => e.ChildOfCompetencySet).HasColumnName("ChildOf_CompetencySet");

                entity.HasOne(d => d.ChildOfCompetencySetNavigation)
                    .WithMany(p => p.InverseChildOfCompetencySetNavigation)
                    .HasForeignKey(d => d.ChildOfCompetencySet)
                    .HasConstraintName("FK_CompetencySet_LearningStandardItemSet");

                entity.HasOne(d => d.RefCompletionCriteria)
                    .WithMany(p => p.CompetencySet)
                    .HasForeignKey(d => d.RefCompletionCriteriaId)
                    .HasConstraintName("FK_CompetencySet_RefCompetencySetCompletionCriteria");
            });

            modelBuilder.Entity<CoreKnowledgeArea>(entity =>
            {
                entity.ToTable("CoreKnowledgeArea", "dbo");

                entity.HasIndex(e => new { e.ProfessionalDevelopmentActivityId, e.RefCoreKnowledgeAreaId })
                    .IsUnique();

                entity.HasOne(d => d.ProfessionalDevelopmentActivity)
                    .WithMany(p => p.CoreKnowledgeArea)
                    .HasForeignKey(d => d.ProfessionalDevelopmentActivityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CoreKnowledgeArea_ProfessionalDevelopmentActivity");

                entity.HasOne(d => d.RefCoreKnowledgeArea)
                    .WithMany(p => p.CoreKnowledgeArea)
                    .HasForeignKey(d => d.RefCoreKnowledgeAreaId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CoreKnowledgeArea_RefCoreKnowledgeArea");
            });

            modelBuilder.Entity<Course>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_Course");

                entity.ToTable("Course", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.CertificationDescription).HasMaxLength(300);

                entity.Property(e => e.CreditValue).HasColumnType("decimal");

                entity.Property(e => e.Description).HasMaxLength(60);

                entity.Property(e => e.ScedsequenceOfCourse)
                    .HasColumnName("SCEDSequenceOfCourse")
                    .HasMaxLength(50);

                entity.Property(e => e.SubjectAbbreviation).HasMaxLength(50);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.Course)
                    .HasForeignKey<Course>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Course_Organization");

                entity.HasOne(d => d.RefCourseApplicableEducationLevel)
                    .WithMany(p => p.Course)
                    .HasForeignKey(d => d.RefCourseApplicableEducationLevelId)
                    .HasConstraintName("FK_Course_RefCourseApplicableEducationLevel");

                entity.HasOne(d => d.RefCourseCreditUnit)
                    .WithMany(p => p.Course)
                    .HasForeignKey(d => d.RefCourseCreditUnitId)
                    .HasConstraintName("FK_Course_RefCourseCreditUnit");

                entity.HasOne(d => d.RefCourseLevelCharacteristics)
                    .WithMany(p => p.Course)
                    .HasForeignKey(d => d.RefCourseLevelCharacteristicsId)
                    .HasConstraintName("FK_Course_RefCourseLevelCharacteristic");

                entity.HasOne(d => d.RefInstructionLanguageNavigation)
                    .WithMany(p => p.Course)
                    .HasForeignKey(d => d.RefInstructionLanguage)
                    .HasConstraintName("FK_Course_RefLanguage");
            });

            modelBuilder.Entity<CourseSection>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_CourseSection");

                entity.ToTable("CourseSection", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.AvailableCarnegieUnitCredit).HasColumnType("decimal");

                entity.Property(e => e.RelatedLearningStandards).HasMaxLength(60);

                entity.Property(e => e.TimeRequiredForCompletion).HasColumnType("decimal");

                entity.HasOne(d => d.Course)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CourseSection_Course");

                entity.HasOne(d => d.OrganizationCalendarSession)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.OrganizationCalendarSessionId)
                    .HasConstraintName("FK_CourseSection_OrganizationCalendarSession");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.CourseSection)
                    .HasForeignKey<CourseSection>(d => d.OrganizationId)
                    .HasConstraintName("FK_CourseSection_Organization");

                entity.HasOne(d => d.RefAdvancedPlacementCourseCode)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.RefAdvancedPlacementCourseCodeId)
                    .HasConstraintName("FK_CourseSection_RefAdvancedPlacementCourseCodeId");

                entity.HasOne(d => d.RefCourseSectionDeliveryMode)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.RefCourseSectionDeliveryModeId)
                    .HasConstraintName("FK_CourseSection_RefCourseSectionDeliveryMode");

                entity.HasOne(d => d.RefCreditTypeEarned)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.RefCreditTypeEarnedId)
                    .HasConstraintName("FK_CourseSection_RefCreditTypeEarned");

                entity.HasOne(d => d.RefInstructionLanguage)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.RefInstructionLanguageId)
                    .HasConstraintName("FK_CourseSection_RefLanguage");

                entity.HasOne(d => d.RefSingleSexClassStatus)
                    .WithMany(p => p.CourseSection)
                    .HasForeignKey(d => d.RefSingleSexClassStatusId)
                    .HasConstraintName("FK_CourseSection_RefCourseSectionSingleSexClassStatus");
            });

            modelBuilder.Entity<CourseSectionAssessmentReporting>(entity =>
            {
                entity.ToTable("CourseSectionAssessmentReporting", "dbo");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.CourseSectionAssessmentReporting)
                    .HasForeignKey(d => d.OrganizationId)
                    .HasConstraintName("FK_CourseSectionAssessmentReporting_CourseSection");

                entity.HasOne(d => d.RefCourseSectionAssessmentReportingMethod)
                    .WithMany(p => p.CourseSectionAssessmentReporting)
                    .HasForeignKey(d => d.RefCourseSectionAssessmentReportingMethodId)
                    .HasConstraintName("FK_CourseSectionAssessmentReporting_RefCSAssessmentReportMethod");
            });

            modelBuilder.Entity<CourseSectionLocation>(entity =>
            {
                entity.ToTable("CourseSectionLocation", "dbo");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.CourseSectionLocation)
                    .HasForeignKey(d => d.LocationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CourseSectionLocation_Classroom");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.CourseSectionLocation)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CourseSectionLocation_CourseSection");

                entity.HasOne(d => d.RefInstructionLocationType)
                    .WithMany(p => p.CourseSectionLocation)
                    .HasForeignKey(d => d.RefInstructionLocationTypeId)
                    .HasConstraintName("FK_CourseSectionLocation_RefInstructionLocationType");
            });

            modelBuilder.Entity<CourseSectionSchedule>(entity =>
            {
                entity.ToTable("CourseSectionSchedule", "dbo");

                entity.Property(e => e.ClassMeetingDays).HasMaxLength(60);

                entity.Property(e => e.ClassPeriod).HasMaxLength(30);

                entity.Property(e => e.TimeDayIdentifier).HasMaxLength(40);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.CourseSectionSchedule)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CourseSectionSchedule_CourseSection");
            });

            modelBuilder.Entity<CteCourse>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_CteCourse");

                entity.ToTable("CteCourse", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.AvailableCarnegieUnitCredit).HasColumnType("decimal");

                entity.Property(e => e.CourseDepartmentName).HasMaxLength(60);

                entity.Property(e => e.RefScedcourseLevelId).HasColumnName("RefSCEDCourseLevelId");

                entity.Property(e => e.RefScedcourseSubjectAreaId).HasColumnName("RefSCEDCourseSubjectAreaId");

                entity.Property(e => e.ScedcourseCode)
                    .HasColumnName("SCEDCourseCode")
                    .HasColumnType("nchar(5)");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.CteCourse)
                    .HasForeignKey<CteCourse>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CteCourse_Course");

                entity.HasOne(d => d.RefAdditionalCreditType)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefAdditionalCreditTypeId)
                    .HasConstraintName("FK_CteCourse_RefAdditionalCreditType");

                entity.HasOne(d => d.RefCareerCluster)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefCareerClusterId)
                    .HasConstraintName("FK_CteCourse_RefCareerCluster");

                entity.HasOne(d => d.RefCourseGpaApplicability)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefCourseGpaApplicabilityId)
                    .HasConstraintName("FK_CteCourse_RefCourseGpaApplicability");

                entity.HasOne(d => d.RefCreditTypeEarned)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefCreditTypeEarnedId)
                    .HasConstraintName("FK_CteCourse_RefCreditTypeEarned");

                entity.HasOne(d => d.RefCurriculumFrameworkType)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefCurriculumFrameworkTypeId)
                    .HasConstraintName("FK_CteCourse_RefCurriculumFrameworkType");

                entity.HasOne(d => d.RefScedcourseLevel)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefScedcourseLevelId)
                    .HasConstraintName("FK_CteCourse_RefSCEDCourseLevel");

                entity.HasOne(d => d.RefScedcourseSubjectArea)
                    .WithMany(p => p.CteCourse)
                    .HasForeignKey(d => d.RefScedcourseSubjectAreaId)
                    .HasConstraintName("FK_CteCourse_RefSCEDCourseSubjectArea");
            });

            modelBuilder.Entity<CteStudentAcademicRecord>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_CteStudentAcademicRecord");

                entity.ToTable("CteStudentAcademicRecord", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.CreditsAttemptedCumulative).HasColumnType("decimal");

                entity.Property(e => e.CreditsEarnedCumulative).HasColumnType("decimal");

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("nchar(7)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.CteStudentAcademicRecord)
                    .HasForeignKey<CteStudentAcademicRecord>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_CteStudentAcademicRecord_OrganizationPersonRole");

                entity.HasOne(d => d.RefProfessionalTechnicalCredentialType)
                    .WithMany(p => p.CteStudentAcademicRecord)
                    .HasForeignKey(d => d.RefProfessionalTechnicalCredentialTypeId)
                    .HasConstraintName("FK_CteStudentAcademicRecord_RefProfessionalTechnicalCredential");
            });

            modelBuilder.Entity<EarlyChildhoodCredential>(entity =>
            {
                entity.HasKey(e => e.PersonCredentialId)
                    .HasName("PK_EarlyChildhoodCredential");

                entity.ToTable("EarlyChildhoodCredential", "dbo");

                entity.Property(e => e.PersonCredentialId).ValueGeneratedNever();

                entity.HasOne(d => d.PersonCredential)
                    .WithOne(p => p.EarlyChildhoodCredential)
                    .HasForeignKey<EarlyChildhoodCredential>(d => d.PersonCredentialId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_EarlyChildhoodCredential_PersonCredential");

                entity.HasOne(d => d.RefEarlyChildhoodCredential)
                    .WithMany(p => p.EarlyChildhoodCredential)
                    .HasForeignKey(d => d.RefEarlyChildhoodCredentialId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_EarlyChildhoodCredential_RefEarlyChildhoodCredential");
            });

            modelBuilder.Entity<EarlyChildhoodProgramTypeOffered>(entity =>
            {
                entity.ToTable("EarlyChildhoodProgramTypeOffered", "dbo");

                entity.HasIndex(e => new { e.OrganizationId, e.RefEarlyChildhoodProgramEnrollmentTypeId })
                    .IsUnique();

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.EarlyChildhoodProgramTypeOffered)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_EarlyChildhoodProgramTypeOffered_Organization");

                entity.HasOne(d => d.RefCommunityBasedType)
                    .WithMany(p => p.EarlyChildhoodProgramTypeOffered)
                    .HasForeignKey(d => d.RefCommunityBasedTypeId)
                    .HasConstraintName("FK_EarlyChildhoodProgramTypeOffered_RefCommunityBasedType");

                entity.HasOne(d => d.RefEarlyChildhoodProgramEnrollmentType)
                    .WithMany(p => p.EarlyChildhoodProgramTypeOffered)
                    .HasForeignKey(d => d.RefEarlyChildhoodProgramEnrollmentTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ECProgramTypeOffered_RefEarlyChildhoodProgramType");
            });

            modelBuilder.Entity<ElchildDemographic>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildDemographic");

                entity.ToTable("ELChildDemographic", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.FosterCareEndDate).HasColumnType("date");

                entity.Property(e => e.FosterCareStartDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildDemographic)
                    .HasForeignKey<ElchildDemographic>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildDemographic_Person");
            });

            modelBuilder.Entity<ElchildDevelopmentalAssessment>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildDevelopmentalAssessment");

                entity.ToTable("ELChildDevelopmentalAssessment", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildDevelopmentalAssessment)
                    .HasForeignKey<ElchildDevelopmentalAssessment>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildDevelopmentalAssessment_Person");

                entity.HasOne(d => d.RefChildDevelopmentalScreeningStatus)
                    .WithMany(p => p.ElchildDevelopmentalAssessment)
                    .HasForeignKey(d => d.RefChildDevelopmentalScreeningStatusId)
                    .HasConstraintName("FK_ELChildDevelopmentalAssessment_RefChildDevelopmentalScreeningStatus");

                entity.HasOne(d => d.RefDevelopmentalEvaluationFinding)
                    .WithMany(p => p.ElchildDevelopmentalAssessment)
                    .HasForeignKey(d => d.RefDevelopmentalEvaluationFindingId)
                    .HasConstraintName("FK_ELChildDevelopmentalAssessment_RefDevelopmentalEvaluationFinding");
            });

            modelBuilder.Entity<ElchildHealth>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildHealth");

                entity.ToTable("ELChildHealth", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.WellChildScreeningReceivedDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildHealth)
                    .HasForeignKey<ElchildHealth>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildHealth_Person");

                entity.HasOne(d => d.RefScheduledWellChildScreening)
                    .WithMany(p => p.ElchildHealth)
                    .HasForeignKey(d => d.RefScheduledWellChildScreeningId)
                    .HasConstraintName("FK_ELChildHealth_RefScheduledWellChildScreening");
            });

            modelBuilder.Entity<ElchildIndividualizedProgram>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildIndividualizedProgram");

                entity.ToTable("ELChildIndividualizedProgram", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.RefIdeaiepstatusId).HasColumnName("RefIDEAIEPStatusId");

                entity.Property(e => e.RefIdeapartCeligibilityCategoryId).HasColumnName("RefIDEAPartCEligibilityCategoryId");

                entity.HasOne(d => d.IndividualizedProgram)
                    .WithMany(p => p.ElchildIndividualizedProgram)
                    .HasForeignKey(d => d.IndividualizedProgramId)
                    .HasConstraintName("FK_ELChildIndividualizedProgram_IndividualizedProgram");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildIndividualizedProgram)
                    .HasForeignKey<ElchildIndividualizedProgram>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildIndividualizedProgram_Person");

                entity.HasOne(d => d.RefIdeaiepstatus)
                    .WithMany(p => p.ElchildIndividualizedProgram)
                    .HasForeignKey(d => d.RefIdeaiepstatusId)
                    .HasConstraintName("FK_ELChildIndividualizedProgram_RefIDEAIEPStatus");

                entity.HasOne(d => d.RefIdeapartCeligibilityCategory)
                    .WithMany(p => p.ElchildIndividualizedProgram)
                    .HasForeignKey(d => d.RefIdeapartCeligibilityCategoryId)
                    .HasConstraintName("FK_ELChildIndividualizedProgram_RefIDEAPartCEligibilityCategory");
            });

            modelBuilder.Entity<ElchildOutcomeSummary>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildOutcomeSummary");

                entity.ToTable("ELChildOutcomeSummary", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.CosprogressAindicator).HasColumnName("COSProgressAIndicator");

                entity.Property(e => e.CosprogressBindicator).HasColumnName("COSProgressBIndicator");

                entity.Property(e => e.CosprogressCindicator).HasColumnName("COSProgressCIndicator");

                entity.Property(e => e.CosratingAid).HasColumnName("COSRatingAId");

                entity.Property(e => e.CosratingBid).HasColumnName("COSRatingBId");

                entity.Property(e => e.CosratingCid).HasColumnName("COSRatingCId");

                entity.HasOne(d => d.CosratingA)
                    .WithMany(p => p.ElchildOutcomeSummaryCosratingA)
                    .HasForeignKey(d => d.CosratingAid)
                    .HasConstraintName("FK_ELChildOutcomeSummary_COSRatingA");

                entity.HasOne(d => d.CosratingB)
                    .WithMany(p => p.ElchildOutcomeSummaryCosratingB)
                    .HasForeignKey(d => d.CosratingBid)
                    .HasConstraintName("FK_ELChildOutcomeSummary_COSRatingB");

                entity.HasOne(d => d.CosratingC)
                    .WithMany(p => p.ElchildOutcomeSummaryCosratingC)
                    .HasForeignKey(d => d.CosratingCid)
                    .HasConstraintName("FK_ELChildOutcomeSummary_COSRatingC");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildOutcomeSummary)
                    .HasForeignKey<ElchildOutcomeSummary>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildOutcomeSummary_Person");
            });

            modelBuilder.Entity<ElchildProgramEligibility>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELChildProgramEligibility");

                entity.ToTable("ELChildProgramEligibility", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.ExpirationDate).HasColumnType("date");

                entity.Property(e => e.RefElprogramEligibilityStatusId).HasColumnName("RefELProgramEligibilityStatusId");

                entity.Property(e => e.StatusDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.ElchildProgramEligibility)
                    .HasForeignKey<ElchildProgramEligibility>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildProgramEligibility_OrgPersonRole");
            });

            modelBuilder.Entity<ElchildService>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELChildService");

                entity.ToTable("ELChildService", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.Eceapeligibility).HasColumnName("ECEAPEligibility");

                entity.Property(e => e.EligibilityPriorityPoints).HasMaxLength(100);

                entity.Property(e => e.RefElserviceTypeId).HasColumnName("RefELServiceTypeId");

                entity.Property(e => e.ServiceDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.ElchildService)
                    .HasForeignKey<ElchildService>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildService_OrgPersonRole");

                entity.HasOne(d => d.RefEarlyChildhoodServicesOffered)
                    .WithMany(p => p.ElchildServiceRefEarlyChildhoodServicesOffered)
                    .HasForeignKey(d => d.RefEarlyChildhoodServicesOfferedId)
                    .HasConstraintName("FK_ELChildService_RefEarlyChildhoodServicesOffered");

                entity.HasOne(d => d.RefEarlyChildhoodServicesReceived)
                    .WithMany(p => p.ElchildServiceRefEarlyChildhoodServicesReceived)
                    .HasForeignKey(d => d.RefEarlyChildhoodServicesReceivedId)
                    .HasConstraintName("FK_ELChildService_RefEarlyChildhoodServicesReceived");

                entity.HasOne(d => d.RefElserviceType)
                    .WithMany(p => p.ElchildService)
                    .HasForeignKey(d => d.RefElserviceTypeId)
                    .HasConstraintName("FK_ELChildService_RefELServiceType");
            });

            modelBuilder.Entity<ElchildServicesApplication>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELChildServicesApplication");

                entity.ToTable("ELChildServicesApplication", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.ApplicationDate).HasColumnType("date");

                entity.Property(e => e.ElapplicationIdentifier)
                    .HasColumnName("ELApplicationIdentifier")
                    .HasMaxLength(40);

                entity.Property(e => e.ElapplicationRequiredDocument).HasColumnName("ELApplicationRequiredDocument");

                entity.Property(e => e.ElenrollmentApplicationDocumentIdentifier)
                    .HasColumnName("ELEnrollmentApplicationDocumentIdentifier")
                    .HasMaxLength(40);

                entity.Property(e => e.ElenrollmentApplicationDocumentName)
                    .HasColumnName("ELEnrollmentApplicationDocumentName")
                    .HasMaxLength(60);

                entity.Property(e => e.ElenrollmentApplicationDocumentType)
                    .HasColumnName("ELEnrollmentApplicationDocumentType")
                    .HasMaxLength(100);

                entity.Property(e => e.ElenrollmentApplicationVerificationDate)
                    .HasColumnName("ELEnrollmentApplicationVerificationDate")
                    .HasColumnType("date");

                entity.Property(e => e.ElenrollmentApplicationVerificationReasonType)
                    .HasColumnName("ELEnrollmentApplicationVerificationReasonType")
                    .HasMaxLength(100);

                entity.Property(e => e.SitePreferenceRank).HasMaxLength(300);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.ElchildServicesApplication)
                    .HasForeignKey<ElchildServicesApplication>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildServicesApplication_OrgPersonRole");
            });

            modelBuilder.Entity<ElchildTransitionPlan>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_ELChildIDEA");

                entity.ToTable("ELChildTransitionPlan", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.DateOfTransitionPlan).HasColumnType("date");

                entity.Property(e => e.IdeapartCtoPartBnotificationDate)
                    .HasColumnName("IDEAPartCToPartBNotificationDate")
                    .HasColumnType("date");

                entity.Property(e => e.IdeapartCtoPartBnotificationOptOutDate)
                    .HasColumnName("IDEAPartCToPartBNotificationOptOutDate")
                    .HasColumnType("date");

                entity.Property(e => e.IdeapartCtoPartBnotificationOptOutIndicator).HasColumnName("IDEAPartCToPartBNotificationOptOutIndicator");

                entity.Property(e => e.PartB619potentialEligibilityInd).HasColumnName("PartB619PotentialEligibilityInd");

                entity.Property(e => e.TransitionConferenceDate).HasColumnType("date");

                entity.Property(e => e.TransitionConferenceDeclineDate).HasColumnType("date");

                entity.HasOne(d => d.IndividualizedProgram)
                    .WithMany(p => p.ElchildTransitionPlan)
                    .HasForeignKey(d => d.IndividualizedProgramId)
                    .HasConstraintName("FK_ELChildIDEA_IndividualizedProgram");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.ElchildTransitionPlan)
                    .HasForeignKey<ElchildTransitionPlan>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELChildIDEA_Person");

                entity.HasOne(d => d.RefReasonDelayTransitionConf)
                    .WithMany(p => p.ElchildTransitionPlan)
                    .HasForeignKey(d => d.RefReasonDelayTransitionConfId)
                    .HasConstraintName("FK_ELChildIDEA_RefReasonDelayTransitionConf");
            });

            modelBuilder.Entity<ElclassSection>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_ELClassSection");

                entity.ToTable("ELClassSection", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.ElprogramAnnualOperatingWeeks).HasColumnName("ELProgramAnnualOperatingWeeks");

                entity.Property(e => e.HoursAvailablePerDay).HasColumnType("decimal");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.ElclassSection)
                    .HasForeignKey<ElclassSection>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELClassSection_Organization");

                entity.HasOne(d => d.RefEnvironmentSetting)
                    .WithMany(p => p.ElclassSection)
                    .HasForeignKey(d => d.RefEnvironmentSettingId)
                    .HasConstraintName("FK_ELClassSection_RefEnvironmentSetting");

                entity.HasOne(d => d.RefServiceOption)
                    .WithMany(p => p.ElclassSection)
                    .HasForeignKey(d => d.RefServiceOptionId)
                    .HasConstraintName("FK_ELClassSection_RefServiceOption");
            });

            modelBuilder.Entity<ElclassSectionService>(entity =>
            {
                entity.ToTable("ELClassSectionService", "dbo");

                entity.Property(e => e.ElclassSectionServiceId).HasColumnName("ELClassSectionServiceId");

                entity.Property(e => e.ElclassGroupCurriculumType)
                    .HasColumnName("ELClassGroupCurriculumType")
                    .HasMaxLength(60);

                entity.Property(e => e.RefElgroupSizeStandardMetId).HasColumnName("RefELGroupSizeStandardMetId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElclassSectionService)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELClassSectionService_ELClassSection");

                entity.HasOne(d => d.RefElgroupSizeStandardMet)
                    .WithMany(p => p.ElclassSectionService)
                    .HasForeignKey(d => d.RefElgroupSizeStandardMetId)
                    .HasConstraintName("FK_ELClassSectionService_RefELGroupSizeStandardMet");

                entity.HasOne(d => d.RefFrequencyOfService)
                    .WithMany(p => p.ElclassSectionService)
                    .HasForeignKey(d => d.RefFrequencyOfServiceId)
                    .HasConstraintName("FK_ELClassSectionService_RefFrequencyOfServiceId");
            });

            modelBuilder.Entity<Elenrollment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("XPKECEnrollment");

                entity.ToTable("ELEnrollment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.ApplicationDate).HasColumnType("date");

                entity.Property(e => e.ElclassSectionId).HasColumnName("ELClassSectionId");

                entity.Property(e => e.EnrollmentDate).HasColumnType("date");

                entity.Property(e => e.NumberOfDaysInAttendance).HasColumnType("decimal");

                entity.Property(e => e.RefElfederalFundingTypeId).HasColumnName("RefELFederalFundingTypeId");

                entity.Property(e => e.RefIdeaenvironmentElid).HasColumnName("RefIDEAEnvironmentELId");

                entity.HasOne(d => d.ElclassSection)
                    .WithMany(p => p.Elenrollment)
                    .HasForeignKey(d => d.ElclassSectionId)
                    .HasConstraintName("FK_ElEnrollment_ELClassSection");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.Elenrollment)
                    .HasForeignKey<Elenrollment>(d => d.OrganizationPersonRoleId)
                    .HasConstraintName("FK_EcProgramEnrollment_OrganizationPerson");

                entity.HasOne(d => d.RefElfederalFundingType)
                    .WithMany(p => p.Elenrollment)
                    .HasForeignKey(d => d.RefElfederalFundingTypeId)
                    .HasConstraintName("FK_ELEnrollment_RefELFederalFundingType");

                entity.HasOne(d => d.RefFoodServiceParticipation)
                    .WithMany(p => p.Elenrollment)
                    .HasForeignKey(d => d.RefFoodServiceParticipationId)
                    .HasConstraintName("FK_ElEnrollment_RefFoodServiceParticipation");

                entity.HasOne(d => d.RefIdeaenvironmentEl)
                    .WithMany(p => p.Elenrollment)
                    .HasForeignKey(d => d.RefIdeaenvironmentElid)
                    .HasConstraintName("FK_ElEnrollment_RefIDEAEnvironmentEL");

                entity.HasOne(d => d.RefServiceOption)
                    .WithMany(p => p.Elenrollment)
                    .HasForeignKey(d => d.RefServiceOptionId)
                    .HasConstraintName("FK_ELEnrollment_RefServiceOption");
            });

            modelBuilder.Entity<ElenrollmentOtherFunding>(entity =>
            {
                entity.ToTable("ELEnrollmentOtherFunding", "dbo");

                entity.Property(e => e.ElenrollmentOtherFundingId).HasColumnName("ELEnrollmentOtherFundingId");

                entity.Property(e => e.RefElotherFederalFundingSourcesId).HasColumnName("RefELOtherFederalFundingSourcesId");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.ElenrollmentOtherFunding)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELEnrollmentOtherFunding_Person");
            });

            modelBuilder.Entity<ElfacilityLicensing>(entity =>
            {
                entity.ToTable("ELFacilityLicensing", "dbo");

                entity.Property(e => e.ElfacilityLicensingId).HasColumnName("ELFacilityLicensingId");

                entity.Property(e => e.ContinuingLicenseDate).HasColumnType("date");

                entity.Property(e => e.InitialLicensingDate).HasColumnType("date");

                entity.Property(e => e.RefElfacilityLicensingStatusId).HasColumnName("RefELFacilityLicensingStatusId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElfacilityLicensing)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELFacilityLicensing_Organization");

                entity.HasOne(d => d.RefElfacilityLicensingStatus)
                    .WithMany(p => p.ElfacilityLicensing)
                    .HasForeignKey(d => d.RefElfacilityLicensingStatusId)
                    .HasConstraintName("FK_ELFacilityLicensing_RefELFacilityLicensingStatus");

                entity.HasOne(d => d.RefLicenseExempt)
                    .WithMany(p => p.ElfacilityLicensing)
                    .HasForeignKey(d => d.RefLicenseExemptId)
                    .HasConstraintName("FK_ELFacilityLicensing_RefLicenseExempt");
            });

            modelBuilder.Entity<ElorganizationAvailability>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_ELOrganizationAvailability");

                entity.ToTable("ELOrganizationAvailability", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.AgeUnit).HasMaxLength(10);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.ElorganizationAvailability)
                    .HasForeignKey<ElorganizationAvailability>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELOrganizationAvailability_Organization1");

                entity.HasOne(d => d.RefEnvironmentSetting)
                    .WithMany(p => p.ElorganizationAvailability)
                    .HasForeignKey(d => d.RefEnvironmentSettingId)
                    .HasConstraintName("FK_ELOrganizationAvailability_RefEnvironmentSetting");

                entity.HasOne(d => d.RefPopulationServed)
                    .WithMany(p => p.ElorganizationAvailability)
                    .HasForeignKey(d => d.RefPopulationServedId)
                    .HasConstraintName("FK_ELOrganizationAvailability_RefPopulationServed");

                entity.HasOne(d => d.RefServiceOption)
                    .WithMany(p => p.ElorganizationAvailability)
                    .HasForeignKey(d => d.RefServiceOptionId)
                    .HasConstraintName("FK_ELOrganizationAvailability_RefServiceOption");
            });

            modelBuilder.Entity<ElorganizationFunds>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_ELOrganizationFunds");

                entity.ToTable("ELOrganizationFunds", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.RefElfederalFundingTypeId).HasColumnName("RefELFederalFundingTypeId");

                entity.Property(e => e.RefEllocalRevenueSourceId).HasColumnName("RefELLocalRevenueSourceId");

                entity.Property(e => e.RefElotherFederalFundingSourcesId).HasColumnName("RefELOtherFederalFundingSourcesId");

                entity.Property(e => e.RefElstateRevenueSourceId).HasColumnName("RefELStateRevenueSourceId");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.ElorganizationFunds)
                    .HasForeignKey<ElorganizationFunds>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELOrganizationFunds_Organization");

                entity.HasOne(d => d.RefBillableBasisType)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefBillableBasisTypeId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefBillableBasisType");

                entity.HasOne(d => d.RefElfederalFundingType)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefElfederalFundingTypeId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefELFederalFundingType");

                entity.HasOne(d => d.RefEllocalRevenueSource)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefEllocalRevenueSourceId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefELLocalRevenueSource");

                entity.HasOne(d => d.RefElotherFederalFundingSources)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefElotherFederalFundingSourcesId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefELOtherFederalFundingSources");

                entity.HasOne(d => d.RefElstateRevenueSource)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefElstateRevenueSourceId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefELStateRevenueSource");

                entity.HasOne(d => d.RefReimbursementType)
                    .WithMany(p => p.ElorganizationFunds)
                    .HasForeignKey(d => d.RefReimbursementTypeId)
                    .HasConstraintName("FK_ELOrganizationFunds_RefReimbursementType");
            });

            modelBuilder.Entity<ElorganizationMonitoring>(entity =>
            {
                entity.ToTable("ELOrganizationMonitoring", "dbo");

                entity.Property(e => e.ElorganizationMonitoringId).HasColumnName("ELOrganizationMonitoringId");

                entity.Property(e => e.TypeOfMonitoring).HasMaxLength(300);

                entity.Property(e => e.VisitEndDate).HasColumnType("date");

                entity.Property(e => e.VisitStartDate).HasColumnType("date");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElorganizationMonitoring)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELOrganizationMonitoring_Organization");

                entity.HasOne(d => d.RefOrganizationMonitoringNotifications)
                    .WithMany(p => p.ElorganizationMonitoring)
                    .HasForeignKey(d => d.RefOrganizationMonitoringNotificationsId)
                    .HasConstraintName("FK_ELOrganizationMonitoring_RefOrganizationMonitoringNotifications");

                entity.HasOne(d => d.RefPurposeOfMonitoringVisit)
                    .WithMany(p => p.ElorganizationMonitoring)
                    .HasForeignKey(d => d.RefPurposeOfMonitoringVisitId)
                    .HasConstraintName("FK_ELOrganizationMonitoring_RefPurposeOfMonitoringVisit");
            });

            modelBuilder.Entity<ElprogramLicensing>(entity =>
            {
                entity.ToTable("ELProgramLicensing", "dbo");

                entity.Property(e => e.ElprogramLicensingId).HasColumnName("ELProgramLicensingId");

                entity.Property(e => e.ContinuingLicenseDate).HasColumnType("date");

                entity.Property(e => e.InitialLicenseDate).HasColumnType("date");

                entity.Property(e => e.RefElprogramLicenseStatusId).HasColumnName("RefELProgramLicenseStatusId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElprogramLicensing)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELProgramLicensing_Organization");

                entity.HasOne(d => d.RefElprogramLicenseStatus)
                    .WithMany(p => p.ElprogramLicensing)
                    .HasForeignKey(d => d.RefElprogramLicenseStatusId)
                    .HasConstraintName("FK_ELProgramLicensing_RefELProgramLicenseStatus");

                entity.HasOne(d => d.RefLicenseExempt)
                    .WithMany(p => p.ElprogramLicensing)
                    .HasForeignKey(d => d.RefLicenseExemptId)
                    .HasConstraintName("FK_ELProgramLicensing_RefLicenseExempt");
            });

            modelBuilder.Entity<ElqualityInitiative>(entity =>
            {
                entity.ToTable("ELQualityInitiative", "dbo");

                entity.Property(e => e.ElqualityInitiativeId).HasColumnName("ELQualityInitiativeId");

                entity.Property(e => e.MaximumScore).HasMaxLength(30);

                entity.Property(e => e.MinimumScore).HasMaxLength(30);

                entity.Property(e => e.ParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.ParticipationStartDate).HasColumnType("date");

                entity.Property(e => e.ScoreLevel).HasMaxLength(30);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElqualityInitiative)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELQualityInitiative_Organization");
            });

            modelBuilder.Entity<ElqualityRatingImprovement>(entity =>
            {
                entity.ToTable("ELQualityRatingImprovement", "dbo");

                entity.Property(e => e.ElqualityRatingImprovementId).HasColumnName("ELQualityRatingImprovementId");

                entity.Property(e => e.QrisAwardDate).HasColumnType("date");

                entity.Property(e => e.QrisScore).HasMaxLength(45);

                entity.Property(e => e.QrisexpirationDate)
                    .HasColumnName("QRISExpirationDate")
                    .HasColumnType("date");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.ElqualityRatingImprovement)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELQualityRatingImprovement_Organization");

                entity.HasOne(d => d.RefQrisParticipation)
                    .WithMany(p => p.ElqualityRatingImprovement)
                    .HasForeignKey(d => d.RefQrisParticipationId)
                    .HasConstraintName("FK_ELQualityRatingImprovement_RefQRISParticipation");
            });

            modelBuilder.Entity<ElservicePartner>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_ELServicePartner");

                entity.ToTable("ELServicePartner", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.MemorandumOfUnderstandingEndDate).HasColumnType("date");

                entity.Property(e => e.MemorandumOfUnderstandingStartDate).HasColumnType("date");

                entity.Property(e => e.ServicePartnerDescription).HasMaxLength(300);

                entity.Property(e => e.ServicePartnerName).HasMaxLength(100);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.ElservicePartner)
                    .HasForeignKey<ElservicePartner>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELServicePartner_Organization");
            });

            modelBuilder.Entity<Elstaff>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELStaff");

                entity.ToTable("ELStaff", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.Elstaff)
                    .HasForeignKey<Elstaff>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELStaff_OrganizationPersonRole");

                entity.HasOne(d => d.RefChildDevelopmentAssociateType)
                    .WithMany(p => p.Elstaff)
                    .HasForeignKey(d => d.RefChildDevelopmentAssociateTypeId)
                    .HasConstraintName("FK_ELStaff_RefChildDevAssociateType");
            });

            modelBuilder.Entity<ElstaffAssignment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELStaffAssignment");

                entity.ToTable("ELStaffAssignment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.ElstaffAssignment)
                    .HasForeignKey<ElstaffAssignment>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELStaffAssignment_OrgPersonRole");
            });

            modelBuilder.Entity<ElstaffEducation>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_ELStaffEducation");

                entity.ToTable("ELStaffEducation", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.EcdegreeOrCertificateHolder).HasColumnName("ECDegreeOrCertificateHolder");

                entity.Property(e => e.RefEllevelOfSpecializationId).HasColumnName("RefELLevelOfSpecializationId");

                entity.Property(e => e.RefElprofessionalDevelopmentTopicAreaId).HasColumnName("RefELProfessionalDevelopmentTopicAreaId");

                entity.Property(e => e.SchoolAgeEducationPscredits)
                    .HasColumnName("SchoolAgeEducationPSCredits")
                    .HasColumnType("decimal");

                entity.Property(e => e.TotalApprovedEccreditsEarned)
                    .HasColumnName("TotalApprovedECCreditsEarned")
                    .HasColumnType("decimal");

                entity.Property(e => e.TotalCollegeCreditsEarned).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.ElstaffEducation)
                    .HasForeignKey<ElstaffEducation>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELStaffEducation_ELStaff");

                entity.HasOne(d => d.RefEllevelOfSpecialization)
                    .WithMany(p => p.ElstaffEducation)
                    .HasForeignKey(d => d.RefEllevelOfSpecializationId)
                    .HasConstraintName("FK_ELStaff_RefELLevelOfSpecialization");

                entity.HasOne(d => d.RefElprofessionalDevelopmentTopicArea)
                    .WithMany(p => p.ElstaffEducation)
                    .HasForeignKey(d => d.RefElprofessionalDevelopmentTopicAreaId)
                    .HasConstraintName("FK_ELStaffEducation_RefELPDTopicArea");
            });

            modelBuilder.Entity<ElstaffEmployment>(entity =>
            {
                entity.HasKey(e => e.StaffEmploymentId)
                    .HasName("PK_ELStaffEmployment");

                entity.ToTable("ELStaffEmployment", "dbo");

                entity.Property(e => e.StaffEmploymentId).ValueGeneratedNever();

                entity.Property(e => e.HourlyWage).HasColumnType("decimal");

                entity.Property(e => e.HoursWorkedPerWeek).HasColumnType("decimal");

                entity.Property(e => e.RefEleducationStaffClassificationId).HasColumnName("RefELEducationStaffClassificationId");

                entity.Property(e => e.RefElemploymentSeparationReasonId).HasColumnName("RefELEmploymentSeparationReasonId");

                entity.Property(e => e.RefElserviceProfessionalStaffClassificationId).HasColumnName("RefELServiceProfessionalStaffClassificationId");

                entity.HasOne(d => d.RefEleducationStaffClassification)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefEleducationStaffClassificationId)
                    .HasConstraintName("FK_ELStaffEmployment_RefELEducationStaffClassification");

                entity.HasOne(d => d.RefElemploymentSeparationReason)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefElemploymentSeparationReasonId)
                    .HasConstraintName("FK_ELStaffEmployment_RefELEmploymentSeparationReason");

                entity.HasOne(d => d.RefElserviceProfessionalStaffClassification)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefElserviceProfessionalStaffClassificationId)
                    .HasConstraintName("FK_ELStaffEmployment_RefELServiceProfessionalStaffClassification");

                entity.HasOne(d => d.RefEmploymentStatus)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefEmploymentStatusId)
                    .HasConstraintName("FK_ELStaffEmployment_RefEmploymentStatus");

                entity.HasOne(d => d.RefWageCollectionMethod)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefWageCollectionMethodId)
                    .HasConstraintName("FK_ELStaffEmployment_RefWageCollectionMethod");

                entity.HasOne(d => d.RefWageVerification)
                    .WithMany(p => p.ElstaffEmployment)
                    .HasForeignKey(d => d.RefWageVerificationId)
                    .HasConstraintName("FK_ELStaffEmployment_RefWageVerification");

                entity.HasOne(d => d.StaffEmployment)
                    .WithOne(p => p.ElstaffEmployment)
                    .HasForeignKey<ElstaffEmployment>(d => d.StaffEmploymentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ELStaffEmployment_StaffEmployment");
            });

            modelBuilder.Entity<Facility>(entity =>
            {
                entity.HasKey(e => e.LocationId)
                    .HasName("PK_Facility");

                entity.ToTable("Facility", "dbo");

                entity.Property(e => e.LocationId).ValueGeneratedNever();

                entity.Property(e => e.BuildingName).HasMaxLength(60);

                entity.Property(e => e.BuildingSiteNumber).HasMaxLength(30);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.SpaceDescription).HasMaxLength(300);

                entity.HasOne(d => d.Location)
                    .WithOne(p => p.Facility)
                    .HasForeignKey<Facility>(d => d.LocationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Facility_Location");

                entity.HasOne(d => d.RefBuildingUseType)
                    .WithMany(p => p.Facility)
                    .HasForeignKey(d => d.RefBuildingUseTypeId)
                    .HasConstraintName("FK_Facility_RefBuildingUseType");

                entity.HasOne(d => d.RefSpaceUseType)
                    .WithMany(p => p.Facility)
                    .HasForeignKey(d => d.RefSpaceUseTypeId)
                    .HasConstraintName("FK_Facility_RefSpaceUseType");
            });

            modelBuilder.Entity<FinancialAccount>(entity =>
            {
                entity.ToTable("FinancialAccount", "dbo");

                entity.Property(e => e.AccountNumber).HasMaxLength(30);

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.FinancialAccountNumber).HasMaxLength(30);

                entity.Property(e => e.FinancialExpenditureProjectReportingCode).HasColumnType("decimal");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.HasOne(d => d.RefFinancialAccountBalanceSheetCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialAccountBalanceSheetCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialBalanceSheetAccountCode");

                entity.HasOne(d => d.RefFinancialAccountCategory)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialAccountCategoryId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialAccountCategory");

                entity.HasOne(d => d.RefFinancialAccountFundClassification)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialAccountFundClassificationId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialAccountFundClassification");

                entity.HasOne(d => d.RefFinancialAccountProgramCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialAccountProgramCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialAccountProgramCode");

                entity.HasOne(d => d.RefFinancialAccountRevenueCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialAccountRevenueCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialAccountRevenueCode");

                entity.HasOne(d => d.RefFinancialExpenditureFunctionCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialExpenditureFunctionCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialExpenditureFunctionCode");

                entity.HasOne(d => d.RefFinancialExpenditureLevelOfInstructionCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialExpenditureLevelOfInstructionCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialExpenditureLevelOfInstructionCode");

                entity.HasOne(d => d.RefFinancialExpenditureObjectCode)
                    .WithMany(p => p.FinancialAccount)
                    .HasForeignKey(d => d.RefFinancialExpenditureObjectCodeId)
                    .HasConstraintName("FK_FinancialAccount_RefFinancialExpenditureObjectCode");
            });

            modelBuilder.Entity<FinancialAccountProgram>(entity =>
            {
                entity.ToTable("FinancialAccountProgram", "dbo");

                entity.Property(e => e.Name).HasMaxLength(100);

                entity.Property(e => e.ProgramNumber).HasMaxLength(30);
            });

            modelBuilder.Entity<FinancialAidApplication>(entity =>
            {
                entity.ToTable("FinancialAidApplication", "dbo");

                entity.Property(e => e.FinancialAidYearDesignator).HasColumnType("nchar(9)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.FinancialAidApplication)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_FinancialAidApplication_OrganizationPersonRole");

                entity.HasOne(d => d.RefFinancialAidApplicationType)
                    .WithMany(p => p.FinancialAidApplication)
                    .HasForeignKey(d => d.RefFinancialAidApplicationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_FinancialAidApplication_RefFinancialAidApplType");
            });

            modelBuilder.Entity<FinancialAidAward>(entity =>
            {
                entity.ToTable("FinancialAidAward", "dbo");

                entity.Property(e => e.FinancialAidAwardAmount).HasColumnType("decimal");

                entity.Property(e => e.FinancialAidYearDesignator).HasColumnType("nchar(9)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.FinancialAidAward)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_FinancialAidAward_OrganizationPersonRole");

                entity.HasOne(d => d.RefFinancialAidAwardType)
                    .WithMany(p => p.FinancialAidAward)
                    .HasForeignKey(d => d.RefFinancialAidAwardTypeId)
                    .HasConstraintName("FK_FinancialAidAward_RefFinancialAidAwardType");

                entity.HasOne(d => d.RefFinancialAidStatus)
                    .WithMany(p => p.FinancialAidAward)
                    .HasForeignKey(d => d.RefFinancialAidStatusId)
                    .HasConstraintName("FK_FinancialAidAward_RefFinancialAidAwardStatus");
            });

            modelBuilder.Entity<Incident>(entity =>
            {
                entity.ToTable("Incident", "dbo");

                entity.Property(e => e.IncidentCost).HasMaxLength(30);

                entity.Property(e => e.IncidentDate).HasColumnType("date");

                entity.Property(e => e.IncidentIdentifier).HasMaxLength(40);

                entity.Property(e => e.RegulationViolatedDescription).HasMaxLength(100);

                entity.HasOne(d => d.IncidentReporter)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.IncidentReporterId)
                    .HasConstraintName("FK_Incident_Person");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .HasConstraintName("FK_Incident_OrganizationPerson");

                entity.HasOne(d => d.RefFirearmType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefFirearmTypeId)
                    .HasConstraintName("FK_Incident_RefFirearmType");

                entity.HasOne(d => d.RefIncidentBehavior)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentBehaviorId)
                    .HasConstraintName("FK_Incident_RefRefIncidentBehavior");

                entity.HasOne(d => d.RefIncidentBehaviorSecondary)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentBehaviorSecondaryId)
                    .HasConstraintName("FK_Incident_RefRefIncidentBehaviorSecondary");

                entity.HasOne(d => d.RefIncidentInjuryType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentInjuryTypeId)
                    .HasConstraintName("FK_Incident_RefIncidentInjuryType");

                entity.HasOne(d => d.RefIncidentLocation)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentLocationId)
                    .HasConstraintName("FK_Incident_RefIncidentLocation");

                entity.HasOne(d => d.RefIncidentMultipleOffenseType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentMultipleOffenseTypeId)
                    .HasConstraintName("FK_Incident_RefIncidentMultipleOffenseType");

                entity.HasOne(d => d.RefIncidentPerpetratorInjuryType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentPerpetratorInjuryTypeId)
                    .HasConstraintName("FK_Incident_RefIncidentPerpetratorInjuryType");

                entity.HasOne(d => d.RefIncidentReporterType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentReporterTypeId)
                    .HasConstraintName("FK_Incident_RefIncidentReporterType");

                entity.HasOne(d => d.RefIncidentTimeDescriptionCode)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefIncidentTimeDescriptionCodeId)
                    .HasConstraintName("FK_Incident_RefIncidentTimeDescriptionCode");

                entity.HasOne(d => d.RefWeaponType)
                    .WithMany(p => p.Incident)
                    .HasForeignKey(d => d.RefWeaponTypeId)
                    .HasConstraintName("FK_Incident_RefWeaponType");
            });

            modelBuilder.Entity<IncidentPerson>(entity =>
            {
                entity.HasKey(e => new { e.IncidentId, e.PersonId, e.RefIncidentPersonRoleTypeId })
                    .HasName("PK_IncidentPerson");

                entity.ToTable("IncidentPerson", "dbo");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.HasOne(d => d.Incident)
                    .WithMany(p => p.IncidentPerson)
                    .HasForeignKey(d => d.IncidentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_IncidentPerson_Incident");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.IncidentPerson)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_IncidentPerson_Person");

                entity.HasOne(d => d.RefIncidentPersonRoleType)
                    .WithMany(p => p.IncidentPerson)
                    .HasForeignKey(d => d.RefIncidentPersonRoleTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_IncidentPerson_RefIncidentPersonRoleType");

                entity.HasOne(d => d.RefIncidentPersonType)
                    .WithMany(p => p.IncidentPerson)
                    .HasForeignKey(d => d.RefIncidentPersonTypeId)
                    .HasConstraintName("FK_IncidentPerson_RefIncidentPersonType");
            });

            modelBuilder.Entity<IndividualizedProgram>(entity =>
            {
                entity.ToTable("IndividualizedProgram", "dbo");

                entity.Property(e => e.IndividualizedProgramDate).HasColumnType("date");

                entity.Property(e => e.ServicePlanDate).HasColumnType("date");

                entity.Property(e => e.ServicePlanReevaluationDate).HasColumnType("date");

                entity.Property(e => e.ServicePlanSignatureDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_IndividualizedProgram_OrganizationPersonRole");

                entity.HasOne(d => d.RefIndividualizedProgramDateTypeNavigation)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.RefIndividualizedProgramDateType)
                    .HasConstraintName("FK_IndividualizedProgram_RefIndivProgramDateType");

                entity.HasOne(d => d.RefIndividualizedProgramLocation)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.RefIndividualizedProgramLocationId)
                    .HasConstraintName("FK_IndividualizedProgram_RefIndivProgramLocation");

                entity.HasOne(d => d.RefIndividualizedProgramTransitionType)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.RefIndividualizedProgramTransitionTypeId)
                    .HasConstraintName("FK_IndividualizedProgram_RefIndivProgramTransitionType");

                entity.HasOne(d => d.RefIndividualizedProgramType)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.RefIndividualizedProgramTypeId)
                    .HasConstraintName("FK_IndividualizedProgram_RefIndividualizedProgramType");

                entity.HasOne(d => d.RefStudentSupportServiceType)
                    .WithMany(p => p.IndividualizedProgram)
                    .HasForeignKey(d => d.RefStudentSupportServiceTypeId)
                    .HasConstraintName("FK_IndividualizedProgram_RefStudentSupportServiceType");
            });

            modelBuilder.Entity<IndividualizedProgramService>(entity =>
            {
                entity.ToTable("IndividualizedProgramService", "dbo");

                entity.Property(e => e.PlannedServiceDuration).HasColumnType("decimal");

                entity.Property(e => e.PlannedServiceStartDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.IndividualizedProgramService)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_IndividualizedProgramService_Person");

                entity.HasOne(d => d.RefIndividualizedProgramPlannedServiceType)
                    .WithMany(p => p.IndividualizedProgramService)
                    .HasForeignKey(d => d.RefIndividualizedProgramPlannedServiceTypeId)
                    .HasConstraintName("FK_IndividualizedProgramService_RefIndividualizedProgramPlannedServiceType");

                entity.HasOne(d => d.RefMethodOfServiceDelivery)
                    .WithMany(p => p.IndividualizedProgramService)
                    .HasForeignKey(d => d.RefMethodOfServiceDeliveryId)
                    .HasConstraintName("FK_IndividualizedProgramService_RefMethodOfServiceDelivery");

                entity.HasOne(d => d.RefServiceFrequency)
                    .WithMany(p => p.IndividualizedProgramService)
                    .HasForeignKey(d => d.RefServiceFrequencyId)
                    .HasConstraintName("FK_IndividualizedProgramService_RefServiceFrequency");
            });

            modelBuilder.Entity<K12course>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_K12Course");

                entity.ToTable("K12Course", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.AvailableCarnegieUnitCredit).HasColumnType("decimal");

                entity.Property(e => e.CourseDepartmentName).HasMaxLength(60);

                entity.Property(e => e.FundingProgram).HasMaxLength(30);

                entity.Property(e => e.RefK12endOfCourseRequirementId).HasColumnName("RefK12EndOfCourseRequirementId");

                entity.Property(e => e.RefScedcourseLevelId).HasColumnName("RefSCEDCourseLevelId");

                entity.Property(e => e.RefScedcourseSubjectAreaId).HasColumnName("RefSCEDCourseSubjectAreaId");

                entity.Property(e => e.ScedcourseCode)
                    .HasColumnName("SCEDCourseCode")
                    .HasColumnType("nchar(5)");

                entity.Property(e => e.ScedgradeSpan)
                    .HasColumnName("SCEDGradeSpan")
                    .HasColumnType("nchar(4)");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12course)
                    .HasForeignKey<K12course>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12Course_Course");

                entity.HasOne(d => d.RefAdditionalCreditType)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefAdditionalCreditTypeId)
                    .HasConstraintName("FK_K12Course_RefAdditionalCreditType");

                entity.HasOne(d => d.RefBlendedLearningModelType)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefBlendedLearningModelTypeId)
                    .HasConstraintName("FK_K12Course_RefBlendedLearningModel");

                entity.HasOne(d => d.RefCareerCluster)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefCareerClusterId)
                    .HasConstraintName("FK_K12Course_RefCareerCluster");

                entity.HasOne(d => d.RefCourseGpaApplicability)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefCourseGpaApplicabilityId)
                    .HasConstraintName("FK_K12Course_RefCourseGPAApplicability");

                entity.HasOne(d => d.RefCourseInteractionMode)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefCourseInteractionModeId)
                    .HasConstraintName("FK_K12Course_RefCourseInteractionMode");

                entity.HasOne(d => d.RefCreditTypeEarned)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefCreditTypeEarnedId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12Course_RefCreditTypeEarned");

                entity.HasOne(d => d.RefCurriculumFrameworkType)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefCurriculumFrameworkTypeId)
                    .HasConstraintName("FK_K12Course_RefCurriculumFrameworkType");

                entity.HasOne(d => d.RefK12endOfCourseRequirement)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefK12endOfCourseRequirementId)
                    .HasConstraintName("FK_K12Course_RefK12EndOfCourseRequirement");

                entity.HasOne(d => d.RefScedcourseLevel)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefScedcourseLevelId)
                    .HasConstraintName("FK_K12Course_RefSCEDCourseLevel");

                entity.HasOne(d => d.RefScedcourseSubjectArea)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefScedcourseSubjectAreaId)
                    .HasConstraintName("FK_K12Course_RefSCEDCourseSubjectArea");

                entity.HasOne(d => d.RefWorkbasedLearningOpportunityType)
                    .WithMany(p => p.K12course)
                    .HasForeignKey(d => d.RefWorkbasedLearningOpportunityTypeId)
                    .HasConstraintName("FK_K12Course_RefWorkbasedLearningOpportunityType");
            });

            modelBuilder.Entity<K12lea>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("XPKK12Lea");

                entity.ToTable("K12Lea", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.RefLeaimprovementStatusId).HasColumnName("RefLEAImprovementStatusId");

                entity.Property(e => e.SupervisoryUnionIdentificationNumber).HasColumnType("nchar(3)");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12lea)
                    .HasForeignKey<K12lea>(d => d.OrganizationId)
                    .HasConstraintName("FK_K12Lea_Organization");

                entity.HasOne(d => d.RefLeaType)
                    .WithMany(p => p.K12lea)
                    .HasForeignKey(d => d.RefLeaTypeId)
                    .HasConstraintName("FK_K12Lea_RefLeaType");

                entity.HasOne(d => d.RefLeaimprovementStatus)
                    .WithMany(p => p.K12lea)
                    .HasForeignKey(d => d.RefLeaimprovementStatusId)
                    .HasConstraintName("FK_K12Lea_RefLEAImprovementStatus");

                entity.HasOne(d => d.RefPublicSchoolChoiceStatus)
                    .WithMany(p => p.K12lea)
                    .HasForeignKey(d => d.RefPublicSchoolChoiceStatusId)
                    .HasConstraintName("FK_K12Lea_RefPublicSchoolChoiceStatus");
            });

            modelBuilder.Entity<K12LeaFederalFunds>(entity =>
            {
                entity.HasKey(e => e.K12LeaFederalFundsId)
                    .HasName("PK_K12LEAFederalFunds");

                entity.ToTable("K12LeaFederalFunds", "dbo");

                entity.Property(e => e.OrganizationCalendarSessionId);

                entity.Property(e => e.InnovativeDollarsSpent).HasColumnType("numeric");

                entity.Property(e => e.InnovativeDollarsSpentOnStrategicPriorities).HasColumnType("numeric");

                entity.Property(e => e.InnovativeProgramsFundsReceived).HasColumnType("numeric");

                entity.Property(e => e.PublicSchoolChoiceFundsSpent).HasColumnType("numeric");

                entity.Property(e => e.SesFundsSpent).HasColumnType("numeric");

                entity.Property(e => e.ParentalInvolvementReservationFunds).HasColumnType("numeric(12,2)");
                entity.Property(e => e.SesSchoolChoice20PercentObligation).HasColumnType("numeric(12,2)");


                entity.HasOne(d => d.OrganizationCalendarSession)
                .WithMany(p => p.K12LeaFederalFunds)
                .HasForeignKey(d => d.OrganizationCalendarSessionId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("FK_K12LeaFederalFunds_OrgCalendarSession");

                entity.HasOne(d => d.RefRlisProgramUse)
                    .WithMany(p => p.K12LeaFederalFunds)
                    .HasForeignKey(d => d.RefRlisProgramUseId)
                    .HasConstraintName("FK_K12LEAFederalFunds_RefRLISProgramUse");
            });

            modelBuilder.Entity<K12leaFederalReporting>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_K12LEAFederalReporting");

                entity.ToTable("K12LeaFederalReporting", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.StateAssessStandardsFunding).HasColumnType("numeric");

                entity.Property(e => e.StateAssessmentAdminFunding).HasColumnType("numeric");

                entity.Property(e => e.TerminatedTitleIiiprogramFailure).HasColumnName("TerminatedTitleIIIProgramFailure");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12leaFederalReporting)
                    .HasForeignKey<K12leaFederalReporting>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEAFederalReporting_K12Lea");

                entity.HasOne(d => d.RefBarrierToEducatingHomeless)
                    .WithMany(p => p.K12leaFederalReporting)
                    .HasForeignKey(d => d.RefBarrierToEducatingHomelessId)
                    .HasConstraintName("FK_K12LEAFederalReporting_RefBarrierToEducatingHomeless");

                entity.HasOne(d => d.RefIntegratedTechnologyStatus)
                    .WithMany(p => p.K12leaFederalReporting)
                    .HasForeignKey(d => d.RefIntegratedTechnologyStatusId)
                    .HasConstraintName("FK_K12LEAFederalReporting_RefIntegratedTechnologyStatus");
            });

            modelBuilder.Entity<K12leaPreKeligibility>(entity =>
            {
                entity.ToTable("K12LeaPreKEligibility", "dbo");

                entity.HasIndex(e => new { e.OrganizationId, e.RefPrekindergartenEligibilityId })
                    .IsUnique();

                entity.Property(e => e.K12leapreKeligibilityId).HasColumnName("K12LEAPreKEligibilityId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.K12leaPreKeligibility)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LeaPreKEligibility_K12Lea");

                entity.HasOne(d => d.RefPrekindergartenEligibility)
                    .WithMany(p => p.K12leaPreKeligibility)
                    .HasForeignKey(d => d.RefPrekindergartenEligibilityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LeaPreKEligibility_RefPrekindergartenEligibility");
            });

            modelBuilder.Entity<K12leaPreKeligibleAgesIdea>(entity =>
            {
                entity.ToTable("K12LeaPreKEligibleAgesIDEA", "dbo");

                entity.Property(e => e.K12leapreKeligibleAgesIdeaid).HasColumnName("K12LEAPreKEligibleAgesIDEAId");

                entity.Property(e => e.RefPreKeligibleAgesNonIdeaid).HasColumnName("RefPreKEligibleAgesNonIDEAId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.K12leaPreKeligibleAgesIdea)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEAPreKEligibleAgesIDEA_K12Lea");

                entity.HasOne(d => d.RefPreKeligibleAgesNonIdea)
                    .WithMany(p => p.K12leaPreKeligibleAgesIdea)
                    .HasForeignKey(d => d.RefPreKeligibleAgesNonIdeaid)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEAPreKEligibleAgesIDEA_RefPreKEligibleAgesNonIDEA");
            });

            modelBuilder.Entity<K12leaSafeDrugFree>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("XPKK12SchoolSafeDrugFree");

                entity.ToTable("K12LeaSafeDrugFree", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.Baseline).HasMaxLength(60);

                entity.Property(e => e.BaselineYear).HasMaxLength(20);

                entity.Property(e => e.CollectionFrequency).HasMaxLength(60);

                entity.Property(e => e.IndicatorName).HasMaxLength(60);

                entity.Property(e => e.Instrument).HasMaxLength(100);

                entity.Property(e => e.MostRecentCollection).HasMaxLength(20);

                entity.Property(e => e.Performance).HasMaxLength(20);

                entity.Property(e => e.Target).HasMaxLength(20);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12leaSafeDrugFree)
                    .HasForeignKey<K12leaSafeDrugFree>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LeaSafeDrugFree_K12Lea");
            });

            modelBuilder.Entity<K12leaTitleIiiprofessionalDevelopment>(entity =>
            {
                entity.ToTable("K12LeaTitleIIIProfessionalDevelopment", "dbo");

                entity.HasIndex(e => new { e.OrganizationId, e.RefTitleIiiprofessionalDevelopmentTypeId })
                    .IsUnique();

                entity.Property(e => e.K12leatitleIiiprofessionalDevelopmentId).HasColumnName("K12LEATitleIIIProfessionalDevelopmentId");

                entity.Property(e => e.RefTitleIiiprofessionalDevelopmentTypeId).HasColumnName("RefTitleIIIProfessionalDevelopmentTypeId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.K12leaTitleIiiprofessionalDevelopment)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEATitleIIIProfessionalDev_K12Lea");

                entity.HasOne(d => d.RefTitleIiiprofessionalDevelopmentType)
                    .WithMany(p => p.K12leaTitleIiiprofessionalDevelopment)
                    .HasForeignKey(d => d.RefTitleIiiprofessionalDevelopmentTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEATitleIIIProfessionalDev_TitleIIIProfessionalDevType");
            });

            modelBuilder.Entity<K12leaTitleIsupportService>(entity =>
            {
                entity.ToTable("K12LeaTitleISupportService", "dbo");

                entity.Property(e => e.K12leaTitleIsupportServiceId).HasColumnName("K12LeaTitleISupportServiceId");

                entity.Property(e => e.RefK12leaTitleIsupportServiceId).HasColumnName("RefK12LeaTitleISupportServiceId");

                entity.HasOne(d => d.K12Lea)
                    .WithMany(p => p.K12leaTitleIsupportService)
                    .HasForeignKey(d => d.K12LeaId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEATitleISupportService_K12Lea");

                entity.HasOne(d => d.RefK12leaTitleIsupportService)
                    .WithMany(p => p.K12leaTitleIsupportService)
                    .HasForeignKey(d => d.RefK12leaTitleIsupportServiceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LEATitleISupportService_RefK12LEATitleISupportService");
            });

            modelBuilder.Entity<K12organizationStudentResponsibility>(entity =>
            {
                entity.ToTable("K12OrganizationStudentResponsibility", "dbo");

                entity.HasIndex(e => new { e.OrganizationPersonRoleId, e.RefK12responsibilityTypeId })
                    .IsUnique();

                entity.Property(e => e.K12organizationStudentResponsibilityId).HasColumnName("K12OrganizationStudentResponsibilityId");

                entity.Property(e => e.RefK12responsibilityTypeId).HasColumnName("RefK12ResponsibilityTypeId");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12organizationStudentResponsibility)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12OrgStudentResponsibility_OrganizationPersonRole");

                entity.HasOne(d => d.RefK12responsibilityType)
                    .WithMany(p => p.K12organizationStudentResponsibility)
                    .HasForeignKey(d => d.RefK12responsibilityTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12OrgStudentResponsibility_RefK12ResponsibilityType");
            });

            modelBuilder.Entity<K12programOrService>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_K12LEAProgram");

                entity.ToTable("K12ProgramOrService", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.RefTitleIinstructionalServicesId).HasColumnName("RefTitleIInstructionalServicesId");

                entity.Property(e => e.RefTitleIprogramTypeId).HasColumnName("RefTitleIProgramTypeId");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12programOrService)
                    .HasForeignKey<K12programOrService>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_K12LeaProgramOrService_Organization");

                entity.HasOne(d => d.RefKindergartenDailyLength)
                    .WithMany(p => p.K12programOrServiceRefKindergartenDailyLength)
                    .HasForeignKey(d => d.RefKindergartenDailyLengthId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefProgramDayLength1");

                entity.HasOne(d => d.RefMepProjectType)
                    .WithMany(p => p.K12programOrService)
                    .HasForeignKey(d => d.RefMepProjectTypeId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefMEPProjectType");

                entity.HasOne(d => d.RefMepSessionType)
                    .WithMany(p => p.K12programOrService)
                    .HasForeignKey(d => d.RefMepSessionTypeId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefMEPSessionType");

                entity.HasOne(d => d.RefPrekindergartenDailyLength)
                    .WithMany(p => p.K12programOrServiceRefPrekindergartenDailyLength)
                    .HasForeignKey(d => d.RefPrekindergartenDailyLengthId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefProgramDayLength");

                entity.HasOne(d => d.RefProgramGiftedEligibility)
                    .WithMany(p => p.K12programOrService)
                    .HasForeignKey(d => d.RefProgramGiftedEligibilityId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefProgramGiftedEligibility");

                entity.HasOne(d => d.RefTitleIinstructionalServices)
                    .WithMany(p => p.K12programOrService)
                    .HasForeignKey(d => d.RefTitleIinstructionalServicesId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefTitleIInstructServices");

                entity.HasOne(d => d.RefTitleIprogramType)
                    .WithMany(p => p.K12programOrService)
                    .HasForeignKey(d => d.RefTitleIprogramTypeId)
                    .HasConstraintName("FK_K12LEAProgramOrService_RefTitleIProgramType");
            });

            modelBuilder.Entity<K12school>(entity =>
            {
                entity.ToTable("K12School", "dbo");

                entity.Property(e => e.K12schoolId).HasColumnName("K12SchoolId");

                entity.Property(e => e.AccreditationAgencyName).HasMaxLength(300);

                entity.Property(e => e.CharterSchoolApprovalYear).HasMaxLength(9);

                entity.Property(e => e.CharterSchoolContractApprovalDate).HasColumnType("date");

                entity.Property(e => e.CharterSchoolContractIdNumber).HasMaxLength(30);

                entity.Property(e => e.CharterSchoolContractRenewalDate).HasColumnType("date");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12School_Organization");

                entity.HasOne(d => d.RefAdministrativeFundingControl)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefAdministrativeFundingControlId)
                    .HasConstraintName("FK_K12School_RefAdminFundingControl");


                entity.HasOne(d => d.RefCharterSchoolType)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefCharterSchoolTypeId)
                    .HasConstraintName("FK_K12School_RefCharterSchoolType");

                entity.HasOne(d => d.RefIncreasedLearningTimeType)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefIncreasedLearningTimeTypeId)
                    .HasConstraintName("FK_K12School_RefIncreasedLearningTimeType");

                entity.HasOne(d => d.RefSchoolLevel)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefSchoolLevelId)
                    .HasConstraintName("FK_K12School_RefSchoolLevel");

                entity.HasOne(d => d.RefSchoolType)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefSchoolTypeId)
                    .HasConstraintName("FK_K12School_RefSchoolType");

                entity.HasOne(d => d.RefStatePovertyDesignation)
                    .WithMany(p => p.K12school)
                    .HasForeignKey(d => d.RefStatePovertyDesignationId)
                    .HasConstraintName("FK_K12School_RefStatePovertyDesignation");
            });

            modelBuilder.Entity<K12schoolCorrectiveAction>(entity =>
            {
                entity.ToTable("K12SchoolCorrectiveAction", "dbo");

                entity.Property(e => e.K12schoolCorrectiveActionId).HasColumnName("K12SchoolCorrectiveActionId");

                entity.Property(e => e.K12schoolId).HasColumnName("K12SchoolId");

                entity.HasOne(d => d.K12school)
                    .WithMany(p => p.K12schoolCorrectiveAction)
                    .HasForeignKey(d => d.K12schoolId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolCorrectiveAction_K12School");

                entity.HasOne(d => d.RefCorrectiveActionType)
                    .WithMany(p => p.K12schoolCorrectiveAction)
                    .HasForeignKey(d => d.RefCorrectiveActionTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolCorrectiveAction_RefCorrectiveActionType");
            });

            modelBuilder.Entity<K12schoolGradeOffered>(entity =>
            {
                entity.ToTable("K12SchoolGradeOffered", "dbo");

                entity.Property(e => e.K12schoolGradeOfferedId).HasColumnName("K12SchoolGradeOfferedId");

                entity.Property(e => e.K12schoolId).HasColumnName("K12SchoolId");

                entity.HasOne(d => d.K12school)
                    .WithMany(p => p.K12schoolGradeOffered)
                    .HasForeignKey(d => d.K12schoolId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolGradeOffered_K12School");

                entity.HasOne(d => d.RefGradeLevel)
                    .WithMany(p => p.K12schoolGradeOffered)
                    .HasForeignKey(d => d.RefGradeLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolGradeOffered_RefGradeLevel");
            });

            modelBuilder.Entity<K12schoolImprovement>(entity =>
            {
                entity.ToTable("K12SchoolImprovement", "dbo");

                entity.Property(e => e.K12schoolImprovementId).HasColumnName("K12SchoolImprovementId");

                entity.Property(e => e.K12schoolId).HasColumnName("K12SchoolId");

                entity.Property(e => e.SchoolImprovementExitDate).HasColumnType("date");

                entity.HasOne(d => d.K12school)
                    .WithMany(p => p.K12schoolImprovement)
                    .HasForeignKey(d => d.K12schoolId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolImprovement_K12School");

                entity.HasOne(d => d.RefSchoolImprovementFunds)
                    .WithMany(p => p.K12schoolImprovement)
                    .HasForeignKey(d => d.RefSchoolImprovementFundsId)
                    .HasConstraintName("FK_K12SchoolImprovement_RefSchoolImprovementFunds");

                entity.HasOne(d => d.RefSchoolImprovementStatus)
                    .WithMany(p => p.K12schoolImprovement)
                    .HasForeignKey(d => d.RefSchoolImprovementStatusId)
                    .HasConstraintName("FK_K12SchoolImprovement_RefSchoolImprovementStatus");

                entity.HasOne(d => d.RefSigInterventionType)
                    .WithMany(p => p.K12schoolImprovement)
                    .HasForeignKey(d => d.RefSigInterventionTypeId)
                    .HasConstraintName("FK_K12SchoolImprovement_RefSIGInterventionType");
            });

			modelBuilder.Entity<K12schoolIndicatorStatus>(entity => 
			{
				entity.ToTable("K12SchoolIndicatorStatus", "dbo");
				entity.Property(e => e.K12SchoolIndicatorStatusId).HasColumnName("K12SchoolIndicatorStatusId");
				entity.Property(e => e.K12schoolId).HasColumnName("K12schoolId");
				entity.Property(e => e.RefIndicatorStatusTypeId).HasColumnName("RefIndicatorStatusTypeId");
				entity.Property(e => e.RefIndicatorStateDefinedStatusId).HasColumnName("RefIndicatorStateDefinedStatusId");
				entity.Property(e => e.RefIndicatorStatusSubgroupTypeId).HasColumnName("RefIndicatorStatusSubgroupTypeId");
				entity.Property(e => e.RefIndicatorStatusCustomTypeId).HasColumnName("RefIndicatorStatusCustomTypeId");

				entity.HasOne(d => d.K12school)
					.WithMany(p => p.K12schoolIndicatorStatus)
					.HasForeignKey(d => d.K12schoolId)
					.OnDelete(DeleteBehavior.Restrict)
					.HasConstraintName("FK_K12SchoolIndicatorStatus_K12School");

				entity.HasOne(d => d.RefIndicatorStatusType)
				   .WithMany(p => p.K12schoolIndicatorStatus)
				   .HasForeignKey(d => d.RefIndicatorStatusTypeId)
				   .HasConstraintName("FK_K12SchoolIndicatorStatus_RefIndicatorStatusType");

				entity.HasOne(d => d.RefIndicatorStateDefinedStatus)
				   .WithMany(p => p.K12schoolIndicatorStatus)
				   .HasForeignKey(d => d.RefIndicatorStateDefinedStatusId)
				   .HasConstraintName("FK_K12SchoolIndicatorStatus_RefIndicatorStateDefinedStatus");

				entity.HasOne(d => d.RefIndicatorStatusSubgroupType)
				   .WithMany(p => p.K12schoolIndicatorStatus)
				   .HasForeignKey(d => d.RefIndicatorStatusSubgroupTypeId)
				   .HasConstraintName("FK_K12SchoolIndicatorStatus_RefIndicatorStatusSubgroupType");

				entity.HasOne(d => d.RefIndicatorStatusCustomType)
				   .WithMany(p => p.K12schoolIndicatorStatus)
				   .HasForeignKey(d => d.RefIndicatorStatusCustomTypeId)
				   .HasConstraintName("FK_K12SchoolIndicatorStatus_RefIndicatorStatusCustomType");

			});

            modelBuilder.Entity<K12schoolStatus>(entity =>
            {
                entity.ToTable("K12SchoolStatus", "dbo");

                entity.Property(e => e.K12schoolStatusId).HasColumnName("K12SchoolStatusId");

                entity.Property(e => e.K12schoolId).HasColumnName("K12SchoolId");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.RefTitleIschoolStatusId).HasColumnName("RefTitleISchoolStatusId");

                entity.HasOne(d => d.K12school)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.K12schoolId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SchoolStatus_K12School");

                entity.HasOne(d => d.RefAlternativeSchoolFocus)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefAlternativeSchoolFocusId)
                    .HasConstraintName("FK_K12SchoolStatus_RefAlternativeSchoolFocus");

                entity.Property(e => e.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus)
                    .HasMaxLength(50);

                entity.HasOne(d => d.RefInternetAccess)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefInternetAccessId)
                    .HasConstraintName("FK_K12SchoolStatus_RefInternetAccess");

                entity.HasOne(d => d.RefMagnetSpecialProgram)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefMagnetSpecialProgramId)
                    .HasConstraintName("FK_K12SchoolStatus_RefMagnetSpecialProgram");

                entity.HasOne(d => d.RefRestructuringAction)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefRestructuringActionId)
                    .HasConstraintName("FK_K12SchoolStatus_RefRestructuringAction");

                entity.HasOne(d => d.RefTitleIschoolStatus)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefTitleIschoolStatusId)
                    .HasConstraintName("FK_K12SchoolStatus_RefTitle1SchoolStatus");

                entity.HasOne(d => d.RefSchoolDangerousStatus)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefSchoolDangerousStatusId)
                    .HasConstraintName("FK_K12SchoolStatus_RefSchoolDangerousStatus");

                entity.HasOne(d => d.RefComprehensiveAndTargetedSupport)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefComprehensiveAndTargetedSupportId)
                    .HasConstraintName("FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport");               

                entity.HasOne(d => d.RefComprehensiveSupport)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefComprehensiveSupportId)
                    .HasConstraintName("FK_K12SchoolStatus_RefComprehensiveSupport");

                entity.HasOne(d => d.RefTargetedSupport)
                    .WithMany(p => p.K12schoolStatus)
                    .HasForeignKey(d => d.RefTargetedSupportId)
                    .HasConstraintName("FK_K12SchoolStatus_RefTargetedSupport");

                entity.HasOne(d => d.RefNSLPStatus)
                  .WithMany(p => p.K12schoolStatus)
                  .HasForeignKey(d => d.RefNSLPStatusId)
                  .HasConstraintName("FK_K12SchoolStatus_RefNSLPStatus");

                entity.HasOne(d => d.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus)
				   .WithMany(p => p.K12schoolStatus)
				   .HasForeignKey(d => d.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId)
				   .HasConstraintName("FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus");

                //entity.HasOne(d => d.RefComprehensiveSupport)
                //	.WithMany(p => p.K12schoolStatus)
                //	.HasForeignKey(d => d.RefComprehensiveSupportId)
                //	.HasConstraintName("FK_K12SchoolStatus_RefComprehensiveSupport");

                //entity.HasOne(d => d.RefComprehensiveAndTargetedSupport)
                //	.WithMany(p => p.K12schoolStatus)
                //	.HasForeignKey(d => d.RefComprehensiveAndTargetedSupportId)
                //	.HasConstraintName("FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport");

                //entity.HasOne(d => d.RefTargetedSupport)
                //	.WithMany(p => p.K12schoolStatus)
                //	.HasForeignKey(d => d.RefTargetedSupportId)
                //	.HasConstraintName("FK_K12SchoolStatus_RefTargetedSupport");
            });

            modelBuilder.Entity<K12sea>(entity =>
            {
                entity.HasKey(e => e.K12SeaId).HasName("PK_K12Sea");

                entity.ToTable("K12Sea", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.RefStateAnsicodeId)
                    .HasColumnName("RefStateANSICodeId");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.K12sea)
                    .HasForeignKey<K12sea>(d => d.OrganizationId)
                    .HasConstraintName("FK_K12Sea_Organization");

                entity.HasOne(d => d.RefStateAnsicodeNavigation)
                    .WithMany(p => p.K12sea)
                    .HasForeignKey(d => d.RefStateAnsicodeId)
                    .HasConstraintName("FK_K12SEA_RefStateANSICode");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<K12seaAlternateFundUse>(entity =>
            {
                entity.HasKey(e => e.K12SEAlternateFundUseId).HasName("PK_K12SEAAlternateFundUse");

                entity.ToTable("K12SeaAlternateFundUse", "dbo");

                entity.Property(e => e.K12SEAlternateFundUseId).HasColumnName("K12SEAlternateFundUseId");

                entity.HasOne(d => d.K12seaFederalFunds)
                    .WithMany(p => p.K12seaAlternateFundUse)
                    .HasForeignKey(d => d.K12seaFederalFundsId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SEAAlternateFundUse_K12SEAFederalFunds");

                entity.HasOne(d => d.RefAlternateFundUses)
                    .WithMany(p => p.K12seaAlternateFundUse)
                    .HasForeignKey(d => d.RefAlternateFundUsesId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12SEAAlternateFundUse_RefAlternateFundUses");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");
            });




            modelBuilder.Entity<K12FederalFundAllocation>(entity =>
            {
                entity.ToTable("K12FederalFundAllocation", "dbo");

                entity.Property(e => e.FederalProgramCode)
                    .IsRequired()
                    .HasMaxLength(10);

                entity.Property(e => e.FederalProgramsFundingAllocation).HasColumnType("numeric");

                entity.Property(e => e.FundsTransferAmount).HasColumnType("decimal(18,2)");
                entity.Property(e => e.SchoolImprovementAllocation).HasColumnType("decimal(18,2)");
                entity.Property(e => e.SchoolImprovementReservedPercent).HasColumnType("decimal(18,2)");
                entity.Property(e => e.SesPerPupilExpenditure).HasColumnType("decimal(18,2)");

                entity.HasOne(d => d.OrganizationCalendarSession)
                    .WithMany(p => p.K12FederalFundAllocation)
                    .HasForeignKey(d => d.OrganizationCalendarSessionId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_K12FederalFundAllocation_OrgCalendarSession");

                entity.HasOne(d => d.RefFederalProgramFundingAllocationType)
                    .WithMany(p => p.K12FederalFundAllocation)
                    .HasForeignKey(d => d.RefFederalProgramFundingAllocationTypeId)
                    .HasConstraintName("FK_K12FederalFundAllocation_RefFederalFundingAllocation");

                entity.HasOne(d => d.RefFederalProgramFundingAllocationType)
                    .WithMany(p => p.K12FederalFundAllocation)
                    .HasForeignKey(d => d.RefFederalProgramFundingAllocationTypeId)
                    .HasConstraintName("FK_OrganizationFederalFunds_RefFederalFundingAllocation");

                entity.HasOne(d => d.RefLeaFundsTransferType)
                    .WithMany(p => p.K12FederalFundAllocation)
                    .HasForeignKey(d => d.RefLeaFundsTransferTypeId)
                    .HasConstraintName("FK_K12FederalFunds_RefLEAFundsTransferType");

                entity.HasOne(d => d.RefReapAlternativeFundingStatus)
                    .WithMany(p => p.K12FederalFundAllocation)
                    .HasForeignKey(d => d.RefReapAlternativeFundingStatusId)
                    .HasConstraintName("FK_K12FederalFunds_REAPAlternativeFundingStatus");


            });


            modelBuilder.Entity<K12seaFederalFunds>(entity =>
            {
                entity.HasKey(e => e.K12seaFederalFundsId)
                    .HasName("PK_K12SEAFederalFunds");

                entity.ToTable("K12SeaFederalFunds", "dbo");

                entity.Property(e => e.DateStateReceivedTitleIiiallocation)
                    .HasColumnName("DateStateReceivedTitleIIIAllocation")
                    .HasColumnType("date");

                entity.Property(e => e.DateTitleIiifundsAvailableToSubgrantees)
                    .HasColumnName("DateTitleIIIFundsAvailableToSubgrantees")
                    .HasColumnType("date");

                entity.Property(e => e.NumberOfDaysForTitleIiisubgrants)
                    .HasColumnName("NumberOfDaysForTitleIIISubgrants")
                    .HasColumnType("numeric");

                entity.HasOne(d => d.OrganizationCalendarSession)
                .WithMany(p => p.K12seaFederalFunds)
                .HasForeignKey(d => d.OrganizationCalendarSessionId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("FK_K12SEAFederalFunds_OrganizationCalendarSession");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<K12staffAssignment>(entity =>
            {
                entity.ToTable("K12StaffAssignment", "dbo");

                entity.Property(e => e.K12staffAssignmentId).HasColumnName("K12StaffAssignmentId");

                entity.Property(e => e.ContributionPercentage).HasColumnType("decimal");

                entity.Property(e => e.FullTimeEquivalency).HasColumnType("decimal");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.RefK12staffClassificationId).HasColumnName("RefK12StaffClassificationId");

                entity.Property(e => e.RefTitleIprogramStaffCategoryId).HasColumnName("RefTitleIProgramStaffCategoryId");
				entity.Property(e => e.RefUnexperiencedStatusId).HasColumnName("RefUnexperiencedStatusId");
				entity.Property(e => e.RefEmergencyOrProvisionalCredentialStatusId).HasColumnName("RefEmergencyOrProvisionalCredentialStatusId");
				entity.Property(e => e.RefOutOfFieldStatusId).HasColumnName("RefOutOfFieldStatusId");

				entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StaffAssignment_OrganizationPersonRole");

                entity.HasOne(d => d.RefClassroomPositionType)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefClassroomPositionTypeId)
                    .HasConstraintName("FK_K12StaffAssignment_RefClassroomPositionType");

                entity.HasOne(d => d.RefK12staffClassification)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefK12staffClassificationId)
                    .HasConstraintName("FK_K12StaffAssignment_RefEducationStaffClassification");

                entity.HasOne(d => d.RefMepStaffCategory)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefMepStaffCategoryId)
                    .HasConstraintName("FK_K12StaffAssignment_RefMepStaffCategory");

                entity.HasOne(d => d.RefProfessionalEducationJobClassification)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefProfessionalEducationJobClassificationId)
                    .HasConstraintName("FK_K12StaffAssignment_RefProfessionalEducationJobClassification");

                entity.HasOne(d => d.RefSpecialEducationAgeGroupTaught)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefSpecialEducationAgeGroupTaughtId)
                    .HasConstraintName("FK_K12StaffAssignment_RefSpecialEducationAgeGroupTaught");

                entity.HasOne(d => d.RefSpecialEducationStaffCategory)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefSpecialEducationStaffCategoryId)
                    .HasConstraintName("FK_K12StaffAssignment_RefSpecialEducationStaffCategory");

                entity.HasOne(d => d.RefTeachingAssignmentRole)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefTeachingAssignmentRoleId)
                    .HasConstraintName("FK_K12StaffAssignment_RefTeachingAssignmentRole");

                entity.HasOne(d => d.RefTitleIprogramStaffCategory)
                    .WithMany(p => p.K12staffAssignment)
                    .HasForeignKey(d => d.RefTitleIprogramStaffCategoryId)
                    .HasConstraintName("FK_K12StaffAssignment_RefTitleIProgramStaffCategory");

				entity.HasOne(d => d.RefUnexperiencedStatus)
					.WithMany(p => p.K12staffAssignment)
					.HasForeignKey(d => d.RefUnexperiencedStatusId)
					.HasConstraintName("FK_K12StaffAssignment_RefUnexperiencedStatus");

				entity.HasOne(d => d.RefEmergencyOrProvisionalCredentialStatus)
					.WithMany(p => p.K12staffAssignment)
					.HasForeignKey(d => d.RefEmergencyOrProvisionalCredentialStatusId)
					.HasConstraintName("FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus");

				entity.HasOne(d => d.RefOutOfFieldStatus)
					.WithMany(p => p.K12staffAssignment)
					.HasForeignKey(d => d.RefOutOfFieldStatusId)
					.HasConstraintName("FK_K12StaffAssignment_RefOutOfFieldStatus");


			});

            modelBuilder.Entity<K12staffEmployment>(entity =>
            {
                entity.HasKey(e => e.StaffEmploymentId)
                    .HasName("PK_K12StaffEmployment");

                entity.ToTable("K12StaffEmployment", "dbo");

                entity.Property(e => e.StaffEmploymentId).ValueGeneratedNever();

                entity.Property(e => e.ContractDaysOfServicePerYear).HasColumnType("decimal");

                entity.Property(e => e.RefK12staffClassificationId).HasColumnName("RefK12StaffClassificationId");

                entity.Property(e => e.StaffCompensationBaseSalary).HasColumnType("decimal");

                entity.Property(e => e.StaffCompensationHealthBenefits).HasColumnType("decimal");

                entity.Property(e => e.StaffCompensationOtherBenefits).HasColumnType("decimal");

                entity.Property(e => e.StaffCompensationRetirementBenefits).HasColumnType("decimal");

                entity.Property(e => e.StaffCompensationTotalBenefits).HasColumnType("decimal");

                entity.Property(e => e.StaffCompensationTotalSalary).HasColumnType("decimal");

                entity.Property(e => e.TitleItargetedAssistanceStaffFunded).HasColumnName("TitleITargetedAssistanceStaffFunded");

                entity.HasOne(d => d.RefEmploymentStatus)
                    .WithMany(p => p.K12staffEmployment)
                    .HasForeignKey(d => d.RefEmploymentStatusId)
                    .HasConstraintName("FK_K12StaffEmployment_RefEmploymentStatus");

                entity.HasOne(d => d.RefK12staffClassification)
                    .WithMany(p => p.K12staffEmployment)
                    .HasForeignKey(d => d.RefK12staffClassificationId)
                    .HasConstraintName("FK_K12StaffEmployment_RefEduStaffClassification");

                entity.HasOne(d => d.StaffEmployment)
                    .WithOne(p => p.K12staffEmployment)
                    .HasForeignKey<K12staffEmployment>(d => d.StaffEmploymentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StaffEmployment_StaffEmployment");
            });

            modelBuilder.Entity<K12studentAcademicHonor>(entity =>
            {
                entity.ToTable("K12StudentAcademicHonor", "dbo");

                entity.Property(e => e.K12studentAcademicHonorId).HasColumnName("K12StudentAcademicHonorId");

                entity.Property(e => e.HonorDescription).HasMaxLength(80);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12studentAcademicHonor)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentAcademicHonor_OrganizationPersonRole");

                entity.HasOne(d => d.RefAcademicHonorType)
                    .WithMany(p => p.K12studentAcademicHonor)
                    .HasForeignKey(d => d.RefAcademicHonorTypeId)
                    .HasConstraintName("FK_K12StudentAcademicHonor_RefAcademicHonorType");
            });

            modelBuilder.Entity<K12studentAcademicRecord>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentAcademicRecord");

                entity.ToTable("K12StudentAcademicRecord", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                // entity.Property(e => e.ClassRankingDate).HasMaxLength(10);
                entity.Property(e => e.ClassRankingDate).HasColumnType("date");

                entity.Property(e => e.CreditsAttemptedCumulative).HasColumnType("decimal");

                entity.Property(e => e.CreditsEarnedCumulative).HasColumnType("decimal");

                //entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("nchar(7)");

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("date");

                entity.Property(e => e.GradePointAverageCumulative).HasColumnType("decimal");

                entity.Property(e => e.GradePointsEarnedCumulative).HasColumnType("decimal");

                entity.Property(e => e.ProjectedGraduationDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentAcademicRecord)
                    .HasForeignKey<K12studentAcademicRecord>(d => d.OrganizationPersonRoleId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_OrganizationPerson");

                entity.HasOne(d => d.RefGpaWeightedIndicator)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefGpaWeightedIndicatorId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefGpaWeightedIndicator");

                entity.HasOne(d => d.RefHighSchoolDiplomaDistinctionType)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefHighSchoolDiplomaDistinctionTypeId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefHSDiplomaDistinctionType");

                entity.HasOne(d => d.RefHighSchoolDiplomaType)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefHighSchoolDiplomaTypeId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefHighSchoolDiplomaType");

                entity.HasOne(d => d.RefPreAndPostTestIndicator)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefPreAndPostTestIndicatorId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefPreAndPostTestIndicator");

                entity.HasOne(d => d.RefProfessionalTechnicalCredentialType)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefProfessionalTechnicalCredentialTypeId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefProfessionalTechnicalCredential");

                entity.HasOne(d => d.RefPsEnrollmentAction)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefPsEnrollmentActionId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefPSEnrollmentAction");

                entity.HasOne(d => d.RefTechnologyLiteracyStatus)
                    .WithMany(p => p.K12studentAcademicRecord)
                    .HasForeignKey(d => d.RefTechnologyLiteracyStatusId)
                    .HasConstraintName("FK_K12StudentAcademicRecord_RefTechnologyLiteracyStatus");
            });

            modelBuilder.Entity<K12studentActivity>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentActivity");

                entity.ToTable("K12StudentActivity", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.ActivityTimeInvolved).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentActivity)
                    .HasForeignKey<K12studentActivity>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentActivity_OrgPersonRole");

                entity.HasOne(d => d.RefActivityTimeMeasurementType)
                    .WithMany(p => p.K12studentActivity)
                    .HasForeignKey(d => d.RefActivityTimeMeasurementTypeId)
                    .HasConstraintName("FK_K12StudentActivity_RefActivityTimeMeasurementType");
            });

            modelBuilder.Entity<K12studentCohort>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentCohort");

                entity.ToTable("K12StudentCohort", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.CohortDescription).HasMaxLength(30);

                entity.Property(e => e.CohortGraduationYear).HasColumnType("nchar(4)");

                entity.Property(e => e.CohortYear).HasColumnType("nchar(4)");

                entity.Property(e => e.GraduationRateSurveyCohortYear).HasColumnType("nchar(4)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentCohort)
                    .HasForeignKey<K12studentCohort>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentCohort_OrganizationPersonRole");
            });

            modelBuilder.Entity<K12studentCourseSection>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentCourseSection");

                entity.ToTable("K12StudentCourseSection", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.GradeEarned).HasMaxLength(15);

                entity.Property(e => e.GradeValueQualifier).HasMaxLength(100);

                entity.Property(e => e.NumberOfCreditsAttempted).HasColumnType("decimal");

                entity.Property(e => e.NumberOfCreditsEarned).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentCourseSection)
                    .HasForeignKey<K12studentCourseSection>(d => d.OrganizationPersonRoleId)
                    .HasConstraintName("FK_K12StudentCourseSection_OrganizationPerson");

                entity.HasOne(d => d.RefAdditionalCreditType)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefAdditionalCreditTypeId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefAdditionalCreditType");

                entity.HasOne(d => d.RefCourseGpaApplicability)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCourseGpaApplicabilityId)
                    .HasConstraintName("FK_K12StudentCourseSection _RefCourseGpaApplicability");

                entity.HasOne(d => d.RefCourseRepeatCode)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCourseRepeatCodeId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefCourseRepeatCode");

                entity.HasOne(d => d.RefCourseSectionEnrollmentStatusType)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCourseSectionEnrollmentStatusTypeId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefCourseSectionEnrollmentStatusType");

                entity.HasOne(d => d.RefCourseSectionEntryType)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCourseSectionEntryTypeId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefCourseSectionEntryType");

                entity.HasOne(d => d.RefCourseSectionExitType)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCourseSectionExitTypeId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefCourseSectionExitType");

                entity.HasOne(d => d.RefCreditTypeEarned)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefCreditTypeEarnedId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefCreditTypeEarned");

                entity.HasOne(d => d.RefExitOrWithdrawalStatus)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefExitOrWithdrawalStatusId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefExitOrWithdrawalStatus");

                entity.HasOne(d => d.RefGradeLevelWhenCourseTaken)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefGradeLevelWhenCourseTakenId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefGradeLevel");

                entity.HasOne(d => d.RefPreAndPostTestIndicator)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefPreAndPostTestIndicatorId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefPreAndPostTestIndicator");

                entity.HasOne(d => d.RefProgressLevel)
                    .WithMany(p => p.K12studentCourseSection)
                    .HasForeignKey(d => d.RefProgressLevelId)
                    .HasConstraintName("FK_K12StudentCourseSection_RefProgressLevel");
            });

            modelBuilder.Entity<K12studentCourseSectionMark>(entity =>
            {
                entity.ToTable("K12StudentCourseSectionMark", "dbo");

                entity.Property(e => e.K12studentCourseSectionMarkId).HasColumnName("K12StudentCourseSectionMarkId");

                entity.Property(e => e.GradeEarned).HasMaxLength(15);

                entity.Property(e => e.GradeValueQualifier).HasMaxLength(100);

                entity.Property(e => e.MarkingPeriodName).HasMaxLength(30);

                entity.Property(e => e.MidTermMark).HasMaxLength(15);

                entity.Property(e => e.StudentCourseSectionGradeNarrative).HasMaxLength(300);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12studentCourseSectionMark)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentCourseSectionMark_K12StudentCourseSection");
            });

            modelBuilder.Entity<K12studentDiscipline>(entity =>
            {
                entity.ToTable("K12StudentDiscipline", "dbo");

                entity.Property(e => e.K12studentDisciplineId).HasColumnName("K12StudentDisciplineId");

                entity.Property(e => e.DisciplinaryActionEndDate).HasColumnType("date");

                entity.Property(e => e.DisciplinaryActionStartDate).HasColumnType("date");

                entity.Property(e => e.DurationOfDisciplinaryAction).HasColumnType("decimal");

                entity.Property(e => e.IepplacementMeetingIndicator).HasColumnName("IEPPlacementMeetingIndicator");

                entity.Property(e => e.RefIdeadisciplineMethodFirearmId).HasColumnName("RefIDEADisciplineMethodFirearmId");

                entity.HasOne(d => d.Incident)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.IncidentId)
                    .HasConstraintName("FK_K12StudentDiscipline_K12Incident");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .HasConstraintName("FK_K12StudentDiscipline_OrganizationPerson");

                entity.HasOne(d => d.RefDisciplinaryActionTaken)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefDisciplinaryActionTakenId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefDisciplinaryActionTaken");

                entity.HasOne(d => d.RefDisciplineLengthDifferenceReason)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefDisciplineLengthDifferenceReasonId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefDisciplineLengthDifference");

                entity.HasOne(d => d.RefDisciplineMethodFirearms)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefDisciplineMethodFirearmsId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefDisciplineMethodFirearms");

                entity.HasOne(d => d.RefDisciplineMethodOfCwd)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefDisciplineMethodOfCwdId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefDisciplineMethodOfCwd");

                entity.HasOne(d => d.RefDisciplineReason)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefDisciplineReasonId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefDisciplineReason1");

                entity.HasOne(d => d.RefIdeaInterimRemoval)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefIdeaInterimRemovalId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefIDEAInterimRemovalId");

                entity.HasOne(d => d.RefIdeaInterimRemovalReason)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefIdeaInterimRemovalReasonId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefIDESInterimRemovalReason");

                entity.HasOne(d => d.RefIdeadisciplineMethodFirearm)
                    .WithMany(p => p.K12studentDiscipline)
                    .HasForeignKey(d => d.RefIdeadisciplineMethodFirearmId)
                    .HasConstraintName("FK_K12StudentDiscipline_RefIDEADisciplineMethodFirearm");
            });

            modelBuilder.Entity<K12studentEmployment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentEmployment");

                entity.ToTable("K12StudentEmployment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.EmploymentNaicsCode).HasColumnType("nchar(6)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentEmployment)
                    .HasForeignKey<K12studentEmployment>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentEmployment_OrganizationPersonRole");

                entity.HasOne(d => d.RefEmployedAfterExit)
                    .WithMany(p => p.K12studentEmployment)
                    .HasForeignKey(d => d.RefEmployedAfterExitId)
                    .HasConstraintName("FK_K12StudentEmployment_RefEmployedAfterExit");

                entity.HasOne(d => d.RefEmployedWhileEnrolled)
                    .WithMany(p => p.K12studentEmployment)
                    .HasForeignKey(d => d.RefEmployedWhileEnrolledId)
                    .HasConstraintName("FK_K12StudentEmployment_RefEmployedWhileEnrolled");
            });

            modelBuilder.Entity<K12studentEnrollment>(entity =>
            {
                entity.ToTable("K12StudentEnrollment", "dbo");

                entity.Property(e => e.K12studentEnrollmentId).HasColumnName("K12StudentEnrollmentId");

                entity.Property(e => e.FirstEntryDateIntoUsschool)
                    .HasColumnName("FirstEntryDateIntoUSSchool")
                    .HasColumnType("date");

                entity.Property(e => e.NslpdirectCertificationIndicator).HasColumnName("NSLPDirectCertificationIndicator");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentEnrollment_OrganizationPersonRole");

                entity.HasOne(d => d.RefDirectoryInformationBlockStatus)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefDirectoryInformationBlockStatusId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefDirectoryInformationBlockStatus");

                entity.HasOne(d => d.RefEndOfTermStatus)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefEndOfTermStatusId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefEndOfTermStatus");

                entity.HasOne(d => d.RefEnrollmentStatus)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefEnrollmentStatusId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefEnrollmentStatus");

                entity.HasOne(d => d.RefEntryGradeLevel)
                    .WithMany(p => p.K12studentEnrollmentRefEntryGradeLevel)
                    .HasForeignKey(d => d.RefEntryGradeLevelId)
                    .HasConstraintName("FK_K12EnrollmentMember_RefGrade");

                entity.HasOne(d => d.RefEntryTypeNavigation)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefEntryType)
                    .HasConstraintName("FK_K12StudentEnrollment_RefEntryType");

                entity.HasOne(d => d.RefExitGradeLevelNavigation)
                    .WithMany(p => p.K12studentEnrollmentRefExitGradeLevelNavigation)
                    .HasForeignKey(d => d.RefExitGradeLevel)
                    .HasConstraintName("FK_K12StudentEnrollment_RefGradeLevel");

                entity.HasOne(d => d.RefExitOrWithdrawalStatus)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefExitOrWithdrawalStatusId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefExitOrWithdrawalStatus");

                entity.HasOne(d => d.RefExitOrWithdrawalType)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefExitOrWithdrawalTypeId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefExitOrWithdrawalType");

                entity.HasOne(d => d.RefFoodServiceEligibility)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefFoodServiceEligibilityId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefFoodServiceEligibility");

                entity.HasOne(d => d.RefNonPromotionReason)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefNonPromotionReasonId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefNonPromotionReason");

                entity.HasOne(d => d.RefPromotionReason)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefPromotionReasonId)
                    .HasConstraintName("FK_K12StudentEnrollment_RefPromotionReason");

                entity.HasOne(d => d.RefPublicSchoolResidenceNavigation)
                    .WithMany(p => p.K12studentEnrollment)
                    .HasForeignKey(d => d.RefPublicSchoolResidence)
                    .HasConstraintName("FK_K12StudentEnrollment_RefPublicSchoolResidence");
            });

            modelBuilder.Entity<K12studentGraduationPlan>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentGraduationPlan");

                entity.ToTable("K12StudentGraduationPlan", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.CreditsRequired).HasColumnType("decimal");

                entity.Property(e => e.K12courseId).HasColumnName("K12CourseId");

                entity.Property(e => e.RefScedcourseSubjectAreaId).HasColumnName("RefSCEDCourseSubjectAreaId");

                entity.HasOne(d => d.K12course)
                    .WithMany(p => p.K12studentGraduationPlan)
                    .HasForeignKey(d => d.K12courseId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentGraduationPlan_K12Course");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentGraduationPlan)
                    .HasForeignKey<K12studentGraduationPlan>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentGraduationPlan_OrganizationPerson");

                entity.HasOne(d => d.RefGradeLevelWhenCourseTaken)
                    .WithMany(p => p.K12studentGraduationPlan)
                    .HasForeignKey(d => d.RefGradeLevelWhenCourseTakenId)
                    .HasConstraintName("FK_K12StudentGraduationPlan_RefGradeLevel");

                entity.HasOne(d => d.RefScedcourseSubjectArea)
                    .WithMany(p => p.K12studentGraduationPlan)
                    .HasForeignKey(d => d.RefScedcourseSubjectAreaId)
                    .HasConstraintName("FK_K12StudentGraduationPlan_RefSCEDCourseSubjectArea");
            });

            modelBuilder.Entity<K12studentLiteracyAssessment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_K12StudentLiteracyAssessment");

                entity.ToTable("K12StudentLiteracyAssessment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.K12studentLiteracyAssessment)
                    .HasForeignKey<K12studentLiteracyAssessment>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentLiteracyAssessment_OrganizationPersonRole");

                entity.HasOne(d => d.RefLiteracyAssessment)
                    .WithMany(p => p.K12studentLiteracyAssessment)
                    .HasForeignKey(d => d.RefLiteracyAssessmentId)
                    .HasConstraintName("FK_K12StudentLiteracyAssessment_RefLiteracyAssessment");
            });

            modelBuilder.Entity<K12studentSession>(entity =>
            {
                entity.ToTable("K12StudentSession", "dbo");

                entity.Property(e => e.K12studentSessionId).HasColumnName("K12StudentSessionId");

                entity.Property(e => e.GradePointAverageGivenSession).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationCalendarSession)
                    .WithMany(p => p.K12studentSession)
                    .HasForeignKey(d => d.OrganizationCalendarSessionId)
                    .HasConstraintName("FK_K12StudentSession_OrganizationCalendarSession");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.K12studentSession)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12StudentSession_OrganizationPersonRole");
            });

            modelBuilder.Entity<K12titleIiilanguageInstruction>(entity =>
            {
                entity.ToTable("K12TitleIIILanguageInstruction", "dbo");

                entity.HasIndex(e => new { e.OrganizationId, e.RefTitleIiilanguageInstructionProgramTypeId })
                    .IsUnique();

                entity.Property(e => e.K12titleIiilanguageInstructionId).HasColumnName("K12TitleIIILanguageInstructionId");

                entity.Property(e => e.RefTitleIiilanguageInstructionProgramTypeId).HasColumnName("RefTitleIIILanguageInstructionProgramTypeId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.K12titleIiilanguageInstruction)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LeaTitleIIILanguageInstruction_Organization");

                entity.HasOne(d => d.RefTitleIiilanguageInstructionProgramType)
                    .WithMany(p => p.K12titleIiilanguageInstruction)
                    .HasForeignKey(d => d.RefTitleIiilanguageInstructionProgramTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_K12LeaTitleIIILangInstruction_RefTitleIIILangInstructionPrgm");
            });

            modelBuilder.Entity<LearnerAction>(entity =>
            {
                entity.ToTable("LearnerAction", "dbo");

                entity.Property(e => e.LearnerActionActorIdentifier).HasMaxLength(40);

                entity.Property(e => e.LearnerActionDateTime).HasColumnType("datetime");

                entity.Property(e => e.LearnerActionObjectDescription).HasMaxLength(300);

                entity.Property(e => e.LearnerActionObjectIdentifier).HasMaxLength(40);

                entity.Property(e => e.LearnerActionObjectType).HasMaxLength(60);

                entity.HasOne(d => d.AssessmentItemResponse)
                    .WithMany(p => p.LearnerAction)
                    .HasForeignKey(d => d.AssessmentItemResponseId)
                    .HasConstraintName("FK_AssessmentItemLearnerAction_AssessmentItemResponse");

                entity.HasOne(d => d.RefLearnerActionType)
                    .WithMany(p => p.LearnerAction)
                    .HasForeignKey(d => d.RefLearnerActionTypeId)
                    .HasConstraintName("FK_LearnerAction_RefLearnerActionType");
            });

            modelBuilder.Entity<LearnerActivity>(entity =>
            {
                entity.ToTable("LearnerActivity", "dbo");

                entity.Property(e => e.CreationDate).HasColumnType("date");

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.DueDate).HasColumnType("date");

                entity.Property(e => e.MaximumAttemptsAllowed).HasColumnType("decimal");

                entity.Property(e => e.MaximumTimeAllowed).HasColumnType("decimal");

                entity.Property(e => e.PossiblePoints).HasColumnType("decimal");

                entity.Property(e => e.Prerequisite).HasMaxLength(300);

                entity.Property(e => e.ReleaseDate).HasColumnType("date");

                entity.Property(e => e.RubricUrl).HasMaxLength(300);

                entity.Property(e => e.Title).HasMaxLength(30);

                entity.Property(e => e.Weight).HasColumnType("decimal");

                entity.HasOne(d => d.AssessmentRegistration)
                    .WithMany(p => p.LearnerActivity)
                    .HasForeignKey(d => d.AssessmentRegistrationId)
                    .HasConstraintName("FK_LearnerActivity_AssessmentRegistration");

                entity.HasOne(d => d.AssignedByPerson)
                    .WithMany(p => p.LearnerActivityAssignedByPerson)
                    .HasForeignKey(d => d.AssignedByPersonId)
                    .HasConstraintName("FK_LearnerActivity_Person1");

                entity.HasOne(d => d.CourseSection)
                    .WithMany(p => p.LearnerActivity)
                    .HasForeignKey(d => d.CourseSectionId)
                    .HasConstraintName("FK_LearnerActivity_CourseSection");

                entity.HasOne(d => d.LeaOrganization)
                    .WithMany(p => p.LearnerActivityLeaOrganization)
                    .HasForeignKey(d => d.LeaOrganizationId)
                    .HasConstraintName("FK_LearnerActivity_Organization1");

                entity.HasOne(d => d.OrganizationCalendarSession)
                    .WithMany(p => p.LearnerActivity)
                    .HasForeignKey(d => d.OrganizationCalendarSessionId)
                    .HasConstraintName("FK_LearnerActivity_OrganizationCalendarSession");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.LearnerActivityPerson)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearnerActivity_Person");

                entity.HasOne(d => d.RefLearnerActivityMaximumTimeAllowedUnits)
                    .WithMany(p => p.LearnerActivity)
                    .HasForeignKey(d => d.RefLearnerActivityMaximumTimeAllowedUnitsId)
                    .HasConstraintName("FK_LearnerActivity_RefLearnerActivityMaximumTimeAllowedUnits");

                entity.HasOne(d => d.RefLearnerActivityType)
                    .WithMany(p => p.LearnerActivity)
                    .HasForeignKey(d => d.RefLearnerActivityTypeId)
                    .HasConstraintName("FK_LearnerActivity_RefLearnerActivityType");

                entity.HasOne(d => d.SchoolOrganization)
                    .WithMany(p => p.LearnerActivitySchoolOrganization)
                    .HasForeignKey(d => d.SchoolOrganizationId)
                    .HasConstraintName("FK_LearnerActivity_Organization");
            });

            modelBuilder.Entity<LearnerActivityLearningResource>(entity =>
            {
                entity.ToTable("LearnerActivity_LearningResource", "dbo");

                entity.HasIndex(e => new { e.LearnerActivityId, e.LearningResourceId })
                    .IsUnique();

                entity.Property(e => e.LearnerActivityLearningResourceId).HasColumnName("LearnerActivity_LearningResourceId");

                entity.HasOne(d => d.LearnerActivity)
                    .WithMany(p => p.LearnerActivityLearningResource)
                    .HasForeignKey(d => d.LearnerActivityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearnerAssignment_LearningResource_LearnerAssignment");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearnerActivityLearningResource)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearnerAssignment_LearningResource_LearningResource");
            });

            modelBuilder.Entity<LearningGoal>(entity =>
            {
                entity.ToTable("LearningGoal", "dbo");

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.Property(e => e.SuccessCriteria).HasMaxLength(300);

                entity.HasOne(d => d.CompetencySet)
                    .WithMany(p => p.LearningGoal)
                    .HasForeignKey(d => d.CompetencySetId)
                    .HasConstraintName("FK_LearningGoal_CompetencySet");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.LearningGoal)
                    .HasForeignKey(d => d.PersonId)
                    .HasConstraintName("FK_LearningGoal_Person");
            });

            modelBuilder.Entity<LearningResource>(entity =>
            {
                entity.ToTable("LearningResource", "dbo");

                entity.Property(e => e.AdaptedFromUrl)
                    .HasColumnName("AdaptedFromURL")
                    .HasMaxLength(300);

                entity.Property(e => e.BasedOnUrl).HasMaxLength(300);

                entity.Property(e => e.ConceptKeyword).HasMaxLength(300);

                entity.Property(e => e.CopyrightHolderName).HasMaxLength(60);

                entity.Property(e => e.CopyrightYear).HasColumnType("nchar(4)");

                entity.Property(e => e.Creator).HasMaxLength(60);

                entity.Property(e => e.DateCreated).HasColumnType("date");

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.LearningResourceAuthorEmail).HasMaxLength(128);

                entity.Property(e => e.LearningResourceAuthorUrl)
                    .HasColumnName("LearningResourceAuthorURL")
                    .HasMaxLength(300);

                entity.Property(e => e.LearningResourceDateModified).HasColumnType("date");

                entity.Property(e => e.LearningResourceLicenseUrl)
                    .HasColumnName("LearningResourceLicenseURL")
                    .HasMaxLength(300);

                entity.Property(e => e.LearningResourcePublisherEmail).HasMaxLength(128);

                entity.Property(e => e.LearningResourcePublisherUrl)
                    .HasColumnName("LearningResourcePublisherURL")
                    .HasMaxLength(300);

                entity.Property(e => e.PublishedDate).HasColumnType("date");

                entity.Property(e => e.PublisherName).HasMaxLength(60);

                entity.Property(e => e.RefLearningResourceAccessApitypeId).HasColumnName("RefLearningResourceAccessAPITypeId");

                entity.Property(e => e.SubjectCode).HasMaxLength(30);

                entity.Property(e => e.SubjectCodeSystem).HasMaxLength(30);

                entity.Property(e => e.SubjectName).HasMaxLength(30);

                entity.Property(e => e.TextComplexitySystem).HasMaxLength(30);

                entity.Property(e => e.TextComplexityValue).HasMaxLength(30);

                entity.Property(e => e.TimeRequired).HasColumnType("decimal");

                entity.Property(e => e.Title).HasMaxLength(30);

                entity.Property(e => e.Url).HasMaxLength(300);

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLanguageId)
                    .HasConstraintName("FK_LearningResource_RefLanguage");

                entity.HasOne(d => d.RefLearningResourceAccessApitype)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceAccessApitypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceAccessAPIType");

                entity.HasOne(d => d.RefLearningResourceAccessHazardType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceAccessHazardTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceAccessHazardType");

                entity.HasOne(d => d.RefLearningResourceAccessModeType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceAccessModeTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceAccessModeType");

                entity.HasOne(d => d.RefLearningResourceAccessRightsUrl)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceAccessRightsUrlId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceAccessRightsUrl");

                entity.HasOne(d => d.RefLearningResourceAuthorType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceAuthorTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceAuthorType");

                entity.HasOne(d => d.RefLearningResourceBookFormatType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceBookFormatTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceBookFormatTypeId");

                entity.HasOne(d => d.RefLearningResourceControlFlexibilityType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceControlFlexibilityTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceControlFlexibilityType");

                entity.HasOne(d => d.RefLearningResourceDigitalMediaSubType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceDigitalMediaSubTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceDigitalMediaSubType");

                entity.HasOne(d => d.RefLearningResourceDigitalMediaType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceDigitalMediaTypeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceDigitalMediaType");

                entity.HasOne(d => d.RefLearningResourceEducationalUse)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceEducationalUseId)
                    .HasConstraintName("FK_LearningResource_RefLREducationalUse");

                entity.HasOne(d => d.RefLearningResourceIntendedEndUserRole)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceIntendedEndUserRoleId)
                    .HasConstraintName("FK_LearningResource_RefLRIntendedEndUserRole");

                entity.HasOne(d => d.RefLearningResourceInteractionMode)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceInteractionModeId)
                    .HasConstraintName("FK_LearningResource_RefLearningResourceInteractionMode");

                entity.HasOne(d => d.RefLearningResourceInteractivityType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceInteractivityTypeId)
                    .HasConstraintName("FK_LearningResource_RefLRInteractivityType");

                entity.HasOne(d => d.RefLearningResourceType)
                    .WithMany(p => p.LearningResource)
                    .HasForeignKey(d => d.RefLearningResourceTypeId)
                    .HasConstraintName("FK_LearningResource_RefLRType");
            });

            modelBuilder.Entity<LearningResourceAdaptation>(entity =>
            {
                entity.ToTable("LearningResourceAdaptation", "dbo");

                entity.Property(e => e.AdaptationUrl)
                    .IsRequired()
                    .HasColumnName("AdaptationURL")
                    .HasMaxLength(300);

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearningResourceAdaptation)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourceAdaptation_LR");
            });

            modelBuilder.Entity<LearningResourceEducationLevel>(entity =>
            {
                entity.ToTable("LearningResourceEducationLevel", "dbo");

                entity.HasIndex(e => new { e.LearningResourceId, e.RefEducationLevelId })
                    .IsUnique();

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearningResourceEducationLevel)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResource_GradeLevel_LearningResource");

                entity.HasOne(d => d.RefEducationLevel)
                    .WithMany(p => p.LearningResourceEducationLevel)
                    .HasForeignKey(d => d.RefEducationLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourceEducationLevel_RefEducationLevel");
            });

            modelBuilder.Entity<LearningResourceMediaFeature>(entity =>
            {
                entity.ToTable("LearningResourceMediaFeature", "dbo");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearningResourceMediaFeature)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourceMediaFeature_LearningResource");

                entity.HasOne(d => d.RefLearningResourceMediaFeatureType)
                    .WithMany(p => p.LearningResourceMediaFeature)
                    .HasForeignKey(d => d.RefLearningResourceMediaFeatureTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourceMediaFeature_RefLearningResourceMediaFeatureType");
            });

            modelBuilder.Entity<LearningResourcePeerRating>(entity =>
            {
                entity.ToTable("LearningResourcePeerRating", "dbo");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.Value).HasColumnType("numeric");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearningResourcePeerRating)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourcePeerRating_LearningResource");

                entity.HasOne(d => d.PeerRatingSystem)
                    .WithMany(p => p.LearningResourcePeerRating)
                    .HasForeignKey(d => d.PeerRatingSystemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourcePeerRating_PeerRatingSystem");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.LearningResourcePeerRating)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourcePeerRating_Person");
            });

            modelBuilder.Entity<LearningResourcePhysicalMedia>(entity =>
            {
                entity.ToTable("LearningResourcePhysicalMedia", "dbo");

                entity.HasOne(d => d.LearningResource)
                    .WithMany(p => p.LearningResourcePhysicalMedia)
                    .HasForeignKey(d => d.LearningResourceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourcePhysicalMedia_LearningResource");

                entity.HasOne(d => d.RefLearningResourcePhysicalMediaType)
                    .WithMany(p => p.LearningResourcePhysicalMedia)
                    .HasForeignKey(d => d.RefLearningResourcePhysicalMediaTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningResourcePhysicalMedia_RefLearningResourcePhysicalMediaType");
            });

            modelBuilder.Entity<LearningStandardDocument>(entity =>
            {
                entity.ToTable("LearningStandardDocument", "dbo");

                entity.Property(e => e.Creator).HasMaxLength(120);

                entity.Property(e => e.Description).HasMaxLength(300);

                entity.Property(e => e.Jurisdiction).HasMaxLength(120);

                entity.Property(e => e.LearningStandardDocumentPublicationDate).HasColumnType("date");

                entity.Property(e => e.License).HasMaxLength(300);

                entity.Property(e => e.Publisher).HasMaxLength(30);

                entity.Property(e => e.Rights).HasMaxLength(300);

                entity.Property(e => e.RightsHolder).HasMaxLength(30);

                entity.Property(e => e.Subject).HasMaxLength(30);

                entity.Property(e => e.Title).HasMaxLength(120);

                entity.Property(e => e.Uri)
                    .HasColumnName("URI")
                    .HasMaxLength(300);

                entity.Property(e => e.ValidEndDate).HasColumnType("date");

                entity.Property(e => e.ValidStartDate).HasColumnType("date");

                entity.Property(e => e.Version).HasMaxLength(30);

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.LearningStandardDocument)
                    .HasForeignKey(d => d.RefLanguageId)
                    .HasConstraintName("FK_LearningStandardDocument_RefLanguage");

                entity.HasOne(d => d.RefLearningStandardDocumentPublicationStatus)
                    .WithMany(p => p.LearningStandardDocument)
                    .HasForeignKey(d => d.RefLearningStandardDocumentPublicationStatusId)
                    .HasConstraintName("FK_LearningStandardDocument_RefLSDocumentPublicationStatus");
            });

            modelBuilder.Entity<LearningStandardItem>(entity =>
            {
                entity.ToTable("LearningStandardItem", "dbo");

                entity.Property(e => e.ChildOfLearningStandardItem).HasColumnName("ChildOf_LearningStandardItem");

                entity.Property(e => e.Code).HasMaxLength(30);

                entity.Property(e => e.ConceptKeyword).HasMaxLength(300);

                entity.Property(e => e.ConceptTerm).HasMaxLength(30);

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.LearningStandardItemParentCode).HasMaxLength(30);

                entity.Property(e => e.LearningStandardItemParentId).HasMaxLength(40);

                entity.Property(e => e.LearningStandardItemParentUrl)
                    .HasColumnName("LearningStandardItemParentURL")
                    .HasMaxLength(300);

                entity.Property(e => e.LearningStandardItemSequence).HasMaxLength(60);

                entity.Property(e => e.License).HasMaxLength(300);

                entity.Property(e => e.NodeName).HasMaxLength(30);

                entity.Property(e => e.PreviousVersionIdentifier).HasMaxLength(40);

                entity.Property(e => e.TextComplexityMaximumValue).HasColumnType("decimal");

                entity.Property(e => e.TextComplexityMinimumValue).HasColumnType("decimal");

                entity.Property(e => e.TextComplexitySystem).HasMaxLength(30);

                entity.Property(e => e.Type).HasMaxLength(60);

                entity.Property(e => e.TypicalAgeRange).HasMaxLength(20);

                entity.Property(e => e.Url)
                    .HasColumnName("URL")
                    .HasMaxLength(300);

                entity.Property(e => e.ValidEndDate).HasColumnType("date");

                entity.Property(e => e.ValidStartDate).HasColumnType("date");

                entity.HasOne(d => d.ChildOfLearningStandardItemNavigation)
                    .WithMany(p => p.InverseChildOfLearningStandardItemNavigation)
                    .HasForeignKey(d => d.ChildOfLearningStandardItem)
                    .HasConstraintName("FK_LearningStandardItem_LearningStandardItem");

                entity.HasOne(d => d.LearningStandardDocument)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.LearningStandardDocumentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningStandardItem_LearningStandardDocument");

                entity.HasOne(d => d.RefBloomsTaxonomyDomain)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.RefBloomsTaxonomyDomainId)
                    .HasConstraintName("FK_LearningStandardItem_RefBloomsTaxonomyDomain");

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.RefLanguageId)
                    .HasConstraintName("FK_LearningStandardItem_RefLanguage");

                entity.HasOne(d => d.RefLearningStandardItemNodeAccessibilityProfile)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.RefLearningStandardItemNodeAccessibilityProfileId)
                    .HasConstraintName("FK_LearningStandardItem_RefLearningStandardItemNodeAccessibilityProfile");

                entity.HasOne(d => d.RefLearningStandardItemTestabilityType)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.RefLearningStandardItemTestabilityTypeId)
                    .HasConstraintName("FK_LearningStandardItem_RefLearningStandardItemTestabilityType");

                entity.HasOne(d => d.RefMultipleIntelligenceType)
                    .WithMany(p => p.LearningStandardItem)
                    .HasForeignKey(d => d.RefMultipleIntelligenceTypeId)
                    .HasConstraintName("FK_LearningStandardItem_RefMultipleIntelligenceType");
            });

            modelBuilder.Entity<LearningStandardItemAssociation>(entity =>
            {
                entity.ToTable("LearningStandardItemAssociation", "dbo");

                entity.Property(e => e.ConnectionCitation).HasMaxLength(300);

                entity.Property(e => e.DestinationNodeName).HasMaxLength(30);

                entity.Property(e => e.DestinationNodeUri)
                    .HasColumnName("DestinationNodeURI")
                    .HasMaxLength(300);

                entity.Property(e => e.LearningStandardItemAssociationIdentifierUri)
                    .HasColumnName("LearningStandardItemAssociationIdentifierURI")
                    .HasMaxLength(300);

                entity.Property(e => e.OriginNodeName).HasMaxLength(30);

                entity.Property(e => e.OriginNodeUri)
                    .HasColumnName("OriginNodeURI")
                    .HasMaxLength(300);

                entity.Property(e => e.Weight).HasColumnType("decimal");

                entity.HasOne(d => d.LearningStandardItem)
                    .WithMany(p => p.LearningStandardItemAssociation)
                    .HasForeignKey(d => d.LearningStandardItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningStandardItemAssociation_LearningStandardItem");

                entity.HasOne(d => d.RefEntityType)
                    .WithMany(p => p.LearningStandardItemAssociation)
                    .HasForeignKey(d => d.RefEntityTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningStandardItemAssociation_RefAssociatedEntityType");

                entity.HasOne(d => d.RefLearningStandardItemAssociationType)
                    .WithMany(p => p.LearningStandardItemAssociation)
                    .HasForeignKey(d => d.RefLearningStandardItemAssociationTypeId)
                    .HasConstraintName("FK_LSItemAssociation_RefLearningStandardItemAssociation");
            });

            modelBuilder.Entity<LearningStandardItemEducationLevel>(entity =>
            {
                entity.ToTable("LearningStandardItemEducationLevel", "dbo");

                entity.HasIndex(e => new { e.LearningStandardsItemId, e.RefEducationLevelId })
                    .IsUnique();

                entity.HasOne(d => d.LearningStandardsItem)
                    .WithMany(p => p.LearningStandardItemEducationLevel)
                    .HasForeignKey(d => d.LearningStandardsItemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningStandardItemGradeLevels_LearningStandardItem");

                entity.HasOne(d => d.RefEducationLevel)
                    .WithMany(p => p.LearningStandardItemEducationLevel)
                    .HasForeignKey(d => d.RefEducationLevelId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_LearningStandardItemEduLevel_RefEducationLevel");
            });

            modelBuilder.Entity<Location>(entity =>
            {
                entity.ToTable("Location", "dbo");

                entity.HasKey(e => e.LocationId)
                    .HasName("PK_Location");
            });

            modelBuilder.Entity<LocationAddress>(entity =>
            {
                entity.HasKey(e => e.LocationId)
                    .HasName("PK_Address");

                entity.ToTable("LocationAddress", "dbo");

                entity.Property(e => e.LocationId).ValueGeneratedNever();

                entity.Property(e => e.ApartmentRoomOrSuiteNumber).HasMaxLength(30);

                entity.Property(e => e.BuildingSiteNumber).HasMaxLength(30);

                entity.Property(e => e.City).HasMaxLength(30);

                entity.Property(e => e.CountyName).HasMaxLength(30);

                entity.Property(e => e.Latitude).HasMaxLength(20);

                entity.Property(e => e.Longitude).HasMaxLength(20);

                entity.Property(e => e.PostalCode).HasMaxLength(17);

                entity.Property(e => e.RefErsruralUrbanContinuumCodeId).HasColumnName("RefERSRuralUrbanContinuumCodeId");

                entity.Property(e => e.StreetNumberAndName).HasMaxLength(40);

                entity.HasOne(d => d.Location)
                    .WithOne(p => p.LocationAddress)
                    .HasForeignKey<LocationAddress>(d => d.LocationId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_LocationAddress_Location");

                entity.HasOne(d => d.RefCountry)
                    .WithMany(p => p.LocationAddress)
                    .HasForeignKey(d => d.RefCountryId)
                    .HasConstraintName("FK_LocationAddress_RefCountry");

                entity.HasOne(d => d.RefCounty)
                    .WithMany(p => p.LocationAddress)
                    .HasForeignKey(d => d.RefCountyId)
                    .HasConstraintName("FK_LocationAddress_RefCounty");

                entity.HasOne(d => d.RefErsruralUrbanContinuumCode)
                    .WithMany(p => p.LocationAddress)
                    .HasForeignKey(d => d.RefErsruralUrbanContinuumCodeId)
                    .HasConstraintName("FK_LocationAddress_RefERSRuralUrbanContinuumCode");

                entity.HasOne(d => d.RefState)
                    .WithMany(p => p.LocationAddress)
                    .HasForeignKey(d => d.RefStateId)
                    .HasConstraintName("FK_LocationAddress_RefState");
            });

            modelBuilder.Entity<Organization>(entity =>
            {
                entity.ToTable("Organization", "dbo");
            });

            modelBuilder.Entity<OrganizationAccreditation>(entity =>
            {
                entity.ToTable("OrganizationAccreditation", "dbo");

                entity.Property(e => e.AccreditationAwardDate).HasColumnType("date");

                entity.Property(e => e.AccreditationExpirationDate).HasColumnType("date");

                entity.Property(e => e.SeekingAccreditationDate).HasColumnType("date");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationAccreditation)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationAccreditation_Organization");

                entity.HasOne(d => d.RefAccreditationAgency)
                    .WithMany(p => p.OrganizationAccreditation)
                    .HasForeignKey(d => d.RefAccreditationAgencyId)
                    .HasConstraintName("FK_OrganizationAccreditation_RefAccreditationAgency");
            });

            modelBuilder.Entity<OrganizationCalendar>(entity =>
            {
                entity.ToTable("OrganizationCalendar", "dbo");

                entity.Property(e => e.CalendarCode).HasMaxLength(30);

                entity.Property(e => e.CalendarDescription)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.CalendarYear).HasColumnType("nchar(4)");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationCalendar)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationCalendar_Organization");
            });

            modelBuilder.Entity<OrganizationCalendarCrisis>(entity =>
            {
                entity.ToTable("OrganizationCalendarCrisis", "dbo");

                entity.Property(e => e.Code).HasMaxLength(30);

                entity.Property(e => e.CrisisDescription).HasMaxLength(300);

                entity.Property(e => e.CrisisEndDate).HasColumnType("date");

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.Property(e => e.Type).HasMaxLength(50);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationCalendarCrisis)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationCalendarCrisis_Organization");
            });

            modelBuilder.Entity<OrganizationCalendarDay>(entity =>
            {
                entity.ToTable("OrganizationCalendarDay", "dbo");

                entity.Property(e => e.AlternateDayName).HasMaxLength(30);

                entity.Property(e => e.DayName)
                    .IsRequired()
                    .HasMaxLength(30);

                entity.HasOne(d => d.OrganizationCalendar)
                    .WithMany(p => p.OrganizationCalendarDay)
                    .HasForeignKey(d => d.OrganizationCalendarId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationCalendarDay_OrganizationCalendar1");
            });

            modelBuilder.Entity<OrganizationCalendarEvent>(entity =>
            {
                entity.ToTable("OrganizationCalendarEvent", "dbo");

                entity.Property(e => e.EventDate).HasColumnType("date");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(30);

                entity.HasOne(d => d.OrganizationCalendar)
                    .WithMany(p => p.OrganizationCalendarEvent)
                    .HasForeignKey(d => d.OrganizationCalendarId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationCalendarEvent_OrganizationCalendar");

                entity.HasOne(d => d.RefCalendarEventTypeNavigation)
                    .WithMany(p => p.OrganizationCalendarEvent)
                    .HasForeignKey(d => d.RefCalendarEventType)
                    .HasConstraintName("FK_OrganizationCalendarEvent_RefCalendarEventType");
            });

            modelBuilder.Entity<OrganizationCalendarSession>(entity =>
            {
                entity.ToTable("OrganizationCalendarSession", "dbo");

                entity.Property(e => e.BeginDate).HasColumnType("date");

                entity.Property(e => e.Code).HasMaxLength(30);

                entity.Property(e => e.Designator).HasMaxLength(7);

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.FirstInstructionDate).HasColumnType("date");

                entity.Property(e => e.InstructionalMinutes).HasColumnType("numeric");

                entity.Property(e => e.LastInstructionDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationCalendar)
                    .WithMany(p => p.OrganizationCalendarSession)
                    .HasForeignKey(d => d.OrganizationCalendarId)
                    .HasConstraintName("FK_OrganizationCalendarSession_OrganizationCalendar");

                entity.HasOne(d => d.RefSessionType)
                    .WithMany(p => p.OrganizationCalendarSession)
                    .HasForeignKey(d => d.RefSessionTypeId)
                    .HasConstraintName("FK_OrganizationCalendarSession_RefSessionType");
            });

            modelBuilder.Entity<OrganizationDetail>(entity =>
            {
                entity.ToTable("OrganizationDetail", "dbo");

                entity.Property(e => e.Name).HasMaxLength(60);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.ShortName).HasMaxLength(30);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationDetail)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationDetail_Organization");

                entity.HasOne(d => d.RefOrganizationType)
                    .WithMany(p => p.OrganizationDetail)
                    .HasForeignKey(d => d.RefOrganizationTypeId)
                    .HasConstraintName("FK_OrganizationDetail_RefOrganizationType");
            });

            modelBuilder.Entity<OrganizationEmail>(entity =>
            {
                entity.ToTable("OrganizationEmail", "dbo");

                entity.Property(e => e.ElectronicMailAddress).HasMaxLength(128);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationEmail)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Organization_Email_Organization");

                entity.HasOne(d => d.RefEmailType)
                    .WithMany(p => p.OrganizationEmail)
                    .HasForeignKey(d => d.RefEmailTypeId)
                    .HasConstraintName("FK_Organization_Email_RefEmailType");
            });

            modelBuilder.Entity<OrganizationFederalAccountability>(entity =>
            {
                entity.ToTable("OrganizationFederalAccountability", "dbo");

                entity.Property(e => e.AccountabilityReportTitle).HasMaxLength(80);

                entity.Property(e => e.AypAppealProcessDate).HasColumnType("date");

                entity.Property(e => e.RefProficiencyTargetStatusRlaid).HasColumnName("RefProficiencyTargetStatusRLAId");

                entity.HasOne(d => d.AmaoAypProgressAttainmentLepStudentsNavigation)
                    .WithMany(p => p.OrganizationFederalAccountabilityAmaoAypProgressAttainmentLepStudentsNavigation)
                    .HasForeignKey(d => d.AmaoAypProgressAttainmentLepStudents)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents");

                entity.HasOne(d => d.AmaoProficiencyAttainmentLepStudentsNavigation)
                    .WithMany(p => p.OrganizationFederalAccountabilityAmaoProficiencyAttainmentLepStudentsNavigation)
                    .HasForeignKey(d => d.AmaoProficiencyAttainmentLepStudents)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents1");

                entity.HasOne(d => d.AmaoProgressAttainmentLepStudentsNavigation)
                    .WithMany(p => p.OrganizationFederalAccountabilityAmaoProgressAttainmentLepStudentsNavigation)
                    .HasForeignKey(d => d.AmaoProgressAttainmentLepStudents)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefAMAOAttainmentLEPStudents2");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationFederalAccountability_Organization");

                entity.HasOne(d => d.RefAypStatus)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefAypStatusId)
                    .HasConstraintName("FK_OrganizationFederaAccountability_RefAypStatus");

                entity.HasOne(d => d.RefCteGraduationRateInclusion)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefCteGraduationRateInclusionId)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefCTEGraduationRateInclusion");

                entity.HasOne(d => d.RefElementaryMiddleAdditional)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefElementaryMiddleAdditionalId)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefElementaryMiddleAdditional");

                entity.HasOne(d => d.RefGunFreeSchoolsActStatusReporting)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefGunFreeSchoolsActReportingStatusId)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefGunFreeSchoolsActStatus");

                entity.HasOne(d => d.RefHighSchoolGraduationRateIndicatorNavigation)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefHighSchoolGraduationRateIndicatorId)
                    .HasConstraintName("FK_OrganizationFedAccountability_RefHSGraduationRateIndicator");

                entity.HasOne(d => d.RefParticipationStatusMath)
                    .WithMany(p => p.OrganizationFederalAccountabilityRefParticipationStatusMath)
                    .HasForeignKey(d => d.RefParticipationStatusMathId)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefParticipationStatusAyp2");

                entity.HasOne(d => d.RefParticipationStatusRla)
                    .WithMany(p => p.OrganizationFederalAccountabilityRefParticipationStatusRla)
                    .HasForeignKey(d => d.RefParticipationStatusRlaId)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefParticipationStatusAyp3");

                entity.HasOne(d => d.RefProficiencyTargetStatusMath)
                    .WithMany(p => p.OrganizationFederalAccountabilityRefProficiencyTargetStatusMath)
                    .HasForeignKey(d => d.RefProficiencyTargetStatusMathId)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefProficiencyTargetAYP");

                entity.HasOne(d => d.RefProficiencyTargetStatusRla)
                    .WithMany(p => p.OrganizationFederalAccountabilityRefProficiencyTargetStatusRla)
                    .HasForeignKey(d => d.RefProficiencyTargetStatusRlaid)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefProficiencyTargetAYP1");

                entity.HasOne(d => d.RefReconstitutedStatus)
                    .WithMany(p => p.OrganizationFederalAccountability)
                    .HasForeignKey(d => d.RefReconstitutedStatusId)
                    .HasConstraintName("FK_OrganizationFederalAccountability_RefReconstitutedStatus");
            });

            modelBuilder.Entity<OrganizationFinancial>(entity =>
            {
                entity.ToTable("OrganizationFinancial", "dbo");

                entity.Property(e => e.ActualValue).HasColumnType("decimal");

                entity.Property(e => e.BudgetedValue).HasColumnType("decimal");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.EncumberedValue).HasColumnType("decimal");

                entity.Property(e => e.FiscalPeriodBeginDate).HasColumnType("date");

                entity.Property(e => e.FiscalPeriodEndDate).HasColumnType("date");

                entity.Property(e => e.FiscalYear).HasColumnType("nchar(4)");

                entity.Property(e => e.Value).HasColumnType("decimal");

                entity.HasOne(d => d.FinancialAccount)
                    .WithMany(p => p.OrganizationFinancial)
                    .HasForeignKey(d => d.FinancialAccountId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationFinancial_FinancialAccount");

                entity.HasOne(d => d.FinancialAccountProgram)
                    .WithMany(p => p.OrganizationFinancial)
                    .HasForeignKey(d => d.FinancialAccountProgramId)
                    .HasConstraintName("FK_OrganizationFinancial_FinancialAccountProgram");

                entity.HasOne(d => d.OrganizationCalendarSession)
                    .WithMany(p => p.OrganizationFinancial)
                    .HasForeignKey(d => d.OrganizationCalendarSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationFinancial_OrgCalendarSession");
            });

            modelBuilder.Entity<OrganizationIdentifier>(entity =>
            {
                entity.ToTable("OrganizationIdentifier", "dbo");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationIdentifier)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationIdentifier_Organization");

                entity.HasOne(d => d.RefOrganizationIdentificationSystem)
                    .WithMany(p => p.OrganizationIdentifier)
                    .HasForeignKey(d => d.RefOrganizationIdentificationSystemId)
                    .HasConstraintName("FK_OrganizationIdentifier_RefIdentifierOrganization");

                entity.HasOne(d => d.RefOrganizationIdentifierType)
                    .WithMany(p => p.OrganizationIdentifier)
                    .HasForeignKey(d => d.RefOrganizationIdentifierTypeId)
                    .HasConstraintName("FK_OrganizationIdentifier_RefOrganizationIdentifierType");
            });

            modelBuilder.Entity<OrganizationIndicator>(entity =>
            {
                entity.ToTable("OrganizationIndicator", "dbo");

                entity.Property(e => e.IndicatorValue)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationIndicator)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_OrganizationIndicator_Organization");

                entity.HasOne(d => d.RefOrganizationIndicator)
                    .WithMany(p => p.OrganizationIndicator)
                    .HasForeignKey(d => d.RefOrganizationIndicatorId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationIndicator_RefOrganizationIndicator");
            });

            modelBuilder.Entity<OrganizationLocation>(entity =>
            {
                entity.ToTable("OrganizationLocation", "dbo");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.OrganizationLocation)
                    .HasForeignKey(d => d.LocationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationLocation_Location");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationLocation)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationLocation_Organization");

                entity.HasOne(d => d.RefOrganizationLocationType)
                    .WithMany(p => p.OrganizationLocation)
                    .HasForeignKey(d => d.RefOrganizationLocationTypeId)
                    .HasConstraintName("FK_OrganizationLocation_RefOrganizationLocationType");
            });

            modelBuilder.Entity<OrganizationOperationalStatus>(entity =>
            {
                entity.ToTable("OrganizationOperationalStatus", "dbo");

                entity.Property(e => e.OperationalStatusEffectiveDate).HasColumnType("date");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationOperationalStatus)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationOperationalStatus_Organization");

                entity.HasOne(d => d.RefOperationalStatus)
                    .WithMany(p => p.OrganizationOperationalStatus)
                    .HasForeignKey(d => d.RefOperationalStatusId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationOperationalStatus_RefOperationalStatus");
            });

            modelBuilder.Entity<OrganizationPersonRole>(entity =>
            {
                entity.ToTable("OrganizationPersonRole", "dbo");

                entity.HasKey(e => e.OrganizationPersonRoleId);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationPersonRole)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_OrganizationPersonRole_Organization");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.OrganizationPersonRole)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_OrganizationPersonRole_Person");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.OrganizationPersonRole)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrgranizationPersonRole_Role");
            });

            modelBuilder.Entity<OrganizationPolicy>(entity =>
            {
                entity.ToTable("OrganizationPolicy", "dbo");

                entity.Property(e => e.PolicyType)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.Value)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationPolicy)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationPolicy_Organization");
            });

            modelBuilder.Entity<OrganizationProgramType>(entity =>
            {
                entity.ToTable("OrganizationProgramType", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationProgramType)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationProgramType_Organization");

                entity.HasOne(d => d.RefProgramType)
                    .WithMany(p => p.OrganizationProgramType)
                    .HasForeignKey(d => d.RefProgramTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationProgramType_RefProgramType");
            });

            modelBuilder.Entity<OrganizationRelationship>(entity =>
            {
                entity.ToTable("OrganizationRelationship", "dbo");

                entity.Property(e => e.ParentOrganizationId).HasColumnName("Parent_OrganizationId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationRelationshipOrganization)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationRelationship_Organization_Child");

                entity.HasOne(d => d.ParentOrganization)
                    .WithMany(p => p.OrganizationRelationshipParentOrganization)
                    .HasForeignKey(d => d.ParentOrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizatinoRelationship_Organization_Parent");

                entity.HasOne(d => d.RefOrganizationRelationship)
                    .WithMany(p => p.OrganizationRelationship)
                    .HasForeignKey(d => d.RefOrganizationRelationshipId)
                    .HasConstraintName("FK_OrganizationRelationship_RefOrganizationRelationshipType");
            });

            modelBuilder.Entity<OrganizationTechnicalAssistance>(entity =>
            {
                entity.ToTable("OrganizationTechnicalAssistance", "dbo");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationTechnicalAssistance)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationTechnicalAssistance_Organization");

                entity.HasOne(d => d.RefTechnicalAssistanceDeliveryType)
                    .WithMany(p => p.OrganizationTechnicalAssistance)
                    .HasForeignKey(d => d.RefTechnicalAssistanceDeliveryTypeId)
                    .HasConstraintName("FK_OrganizationTechnicalAssistance_RefTechnicalAssistanceDeliveryType");

                entity.HasOne(d => d.RefTechnicalAssistanceType)
                    .WithMany(p => p.OrganizationTechnicalAssistance)
                    .HasForeignKey(d => d.RefTechnicalAssistanceTypeId)
                    .HasConstraintName("FK_OrganizationTechnicalAssistance_RefTechnicalAssistanceType");
            });

            modelBuilder.Entity<OrganizationTelephone>(entity =>
            {
                entity.ToTable("OrganizationTelephone", "dbo");

                entity.Property(e => e.TelephoneNumber)
                    .IsRequired()
                    .HasMaxLength(24);

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.OrganizationTelephone)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationTelephone_Organization");

                entity.HasOne(d => d.RefInstitutionTelephoneType)
                    .WithMany(p => p.OrganizationTelephone)
                    .HasForeignKey(d => d.RefInstitutionTelephoneTypeId)
                    .HasConstraintName("FK_LocationPhone_RefInstitutionTelephoneType");
            });

            modelBuilder.Entity<OrganizationWebsite>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_OrganizationWebsite");

                entity.ToTable("OrganizationWebsite", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.Website).HasMaxLength(300);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.OrganizationWebsite)
                    .HasForeignKey<OrganizationWebsite>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_OrganizationWebsite_Organization");
            });

            modelBuilder.Entity<PdactivityEducationLevel>(entity =>
            {
                entity.ToTable("PDActivityEducationLevel", "dbo");

                entity.Property(e => e.PdactivityEducationLevelId).HasColumnName("PDActivityEducationLevelId");

                entity.Property(e => e.RefPdactivityEducationLevelsAddressedId).HasColumnName("RefPDActivityEducationLevelsAddressedId");

                entity.HasOne(d => d.ProfessionalDevelopmentActivity)
                    .WithMany(p => p.PdactivityEducationLevel)
                    .HasForeignKey(d => d.ProfessionalDevelopmentActivityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDActivityEducationLevel_PDActivity");
            });

            modelBuilder.Entity<PeerRatingSystem>(entity =>
            {
                entity.ToTable("PeerRatingSystem", "dbo");

                entity.Property(e => e.MaximumValue).HasColumnType("numeric");

                entity.Property(e => e.MinimumValue).HasColumnType("numeric");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.OptimumValue).HasColumnType("numeric");
            });

            modelBuilder.Entity<Person>(entity =>
            {
                entity.ToTable("Person", "dbo");
            });

            modelBuilder.Entity<PersonAddress>(entity =>
            {
                entity.ToTable("PersonAddress", "dbo");

                entity.Property(e => e.AddressCountyName).HasMaxLength(30);

                entity.Property(e => e.ApartmentRoomOrSuiteNumber).HasMaxLength(30);

                entity.Property(e => e.City).HasMaxLength(30);

                entity.Property(e => e.Latitude).HasMaxLength(20);

                entity.Property(e => e.Longitude).HasMaxLength(20);

                entity.Property(e => e.PostalCode).HasMaxLength(17);

                entity.Property(e => e.StreetNumberAndName).HasMaxLength(40);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonAddress_Person");

                entity.HasOne(d => d.RefCountry)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.RefCountryId)
                    .HasConstraintName("FK_PersonAddress_RefCountry");

                entity.HasOne(d => d.RefCounty)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.RefCountyId)
                    .HasConstraintName("FK_PersonAddress_RefCounty");

                entity.HasOne(d => d.RefPersonLocationType)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.RefPersonLocationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonAddress_RefPersonLocationType");

                entity.HasOne(d => d.RefPersonalInformationVerification)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.RefPersonalInformationVerificationId)
                    .HasConstraintName("FK_PersonAddress_RefPersonalInformationVerification");

                entity.HasOne(d => d.RefState)
                    .WithMany(p => p.PersonAddress)
                    .HasForeignKey(d => d.RefStateId)
                    .HasConstraintName("FK_PersonAddress_RefState");
            });

            modelBuilder.Entity<PersonAllergy>(entity =>
            {
                entity.ToTable("PersonAllergy", "dbo");

                entity.Property(e => e.ReactionDescription).HasMaxLength(2000);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonAllergy)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonAllergy_Person");

                entity.HasOne(d => d.RefAllergySeverity)
                    .WithMany(p => p.PersonAllergy)
                    .HasForeignKey(d => d.RefAllergySeverityId)
                    .HasConstraintName("FK_PersonAllergy_RefAllergySeverity");

                entity.HasOne(d => d.RefAllergyType)
                    .WithMany(p => p.PersonAllergy)
                    .HasForeignKey(d => d.RefAllergyTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonAllergy_RefAllergyTypeId");
            });

            modelBuilder.Entity<PersonAssessmentPersonalNeedsProfile>(entity =>
            {
                entity.ToTable("Person_AssessmentPersonalNeedsProfile", "dbo");

                entity.HasIndex(e => new { e.PersonId, e.AssessmentPersonalNeedsProfileId })
                    .IsUnique();

                entity.Property(e => e.PersonAssessmentPersonalNeedsProfileId).HasColumnName("Person_AssessmentPersonalNeedsProfileId");

                entity.HasOne(d => d.AssessmentPersonalNeedsProfile)
                    .WithMany(p => p.PersonAssessmentPersonalNeedsProfile)
                    .HasForeignKey(d => d.AssessmentPersonalNeedsProfileId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Person_AssessmentPersonalNeedsProfile_AssessmentPersonalNeedsProfile");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonAssessmentPersonalNeedsProfile)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Person_AssessmentPersonalNeedsProfile_Person");
            });

            modelBuilder.Entity<PersonBirthplace>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("XPKPersonBirthplace");

                entity.ToTable("PersonBirthplace", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.City).HasMaxLength(30);

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.PersonBirthplace)
                    .HasForeignKey<PersonBirthplace>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonBirthplace_Person");

                entity.HasOne(d => d.RefCountry)
                    .WithMany(p => p.PersonBirthplace)
                    .HasForeignKey(d => d.RefCountryId)
                    .HasConstraintName("FK_PersonBirthplace_RefCountry");

                entity.HasOne(d => d.RefState)
                    .WithMany(p => p.PersonBirthplace)
                    .HasForeignKey(d => d.RefStateId)
                    .HasConstraintName("FK_PersonBirthplace_RefState");
            });

            modelBuilder.Entity<PersonCareerEducationPlan>(entity =>
            {
                entity.ToTable("PersonCareerEducationPlan", "dbo");

                entity.Property(e => e.LastUpdated).HasColumnType("date");

                entity.Property(e => e.ProfessionalDevelopmentPlanCompletion).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonCareerEducationPlan)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonCareerEducationPlan_Person");

                entity.HasOne(d => d.RefCareerEducationPlanType)
                    .WithMany(p => p.PersonCareerEducationPlan)
                    .HasForeignKey(d => d.RefCareerEducationPlanTypeId)
                    .HasConstraintName("FK_PersonCareerEducationPlan_RefCareerEduPlanType");
            });

            modelBuilder.Entity<PersonCredential>(entity =>
            {
                entity.ToTable("PersonCredential", "dbo");

                entity.Property(e => e.CredentialName).HasMaxLength(60);

                entity.Property(e => e.CredentialOrLicenseAwardEntity).HasMaxLength(60);

                entity.Property(e => e.ExpirationDate).HasColumnType("date");

                entity.Property(e => e.IssuanceDate).HasColumnType("date");

                entity.Property(e => e.ProfessionalCertificateOrLicenseNumber).HasMaxLength(30);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonCredential)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonCredential_Person");

                entity.HasOne(d => d.RefCredentialType)
                    .WithMany(p => p.PersonCredential)
                    .HasForeignKey(d => d.RefCredentialTypeId)
                    .HasConstraintName("FK_PersonCredential_RefCredentialType");

                entity.HasOne(d => d.RefIssuingState)
                    .WithMany(p => p.PersonCredential)
                    .HasForeignKey(d => d.RefIssuingStateId)
                    .HasConstraintName("FK_PersonCredential_RefState");
            });

            modelBuilder.Entity<PersonDegreeOrCertificate>(entity =>
            {
                entity.HasKey(e => e.PersonDegreeOrCertificateId);

                entity.ToTable("PersonDegreeOrCertificate", "dbo");

                entity.Property(e => e.AwardDate).HasColumnType("date");

                entity.Property(e => e.DegreeOrCertificateTitleOrSubject).HasMaxLength(45);

                entity.Property(e => e.NameOfInstitution).HasMaxLength(60);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonDegreeOrCertificate)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonDegreeOrCertificate_Person");

                entity.HasOne(d => d.RefDegreeOrCertificateType)
                    .WithMany(p => p.PersonDegreeOrCertificate)
                    .HasForeignKey(d => d.RefDegreeOrCertificateTypeId)
                    .HasConstraintName("FK_PersonDegreeOrCertificate_RefDegree");

                entity.HasOne(d => d.RefEducationVerificationMethod)
                    .WithMany(p => p.PersonDegreeOrCertificate)
                    .HasForeignKey(d => d.RefEducationVerificationMethodId)
                    .HasConstraintName("FK_PersonDegreeOrCertificate_RefEducationVerificationMethod");

                entity.HasOne(d => d.RefHigherEducationInstitutionAccreditationStatus)
                    .WithMany(p => p.PersonDegreeOrCertificate)
                    .HasForeignKey(d => d.RefHigherEducationInstitutionAccreditationStatusId)
                    .HasConstraintName("FK_PersonDegreeOrCertificate_RefHigherEdInstitutionAccredStatus");
            });

            modelBuilder.Entity<PersonDemographicRace>(entity =>
            {
                entity.HasKey(e => e.PersonDemographicRaceId);

                entity.ToTable("PersonDemographicRace", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonDemographicRace)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonDemographicRace_Person");

                entity.HasOne(d => d.RefRace)
                    .WithMany(p => p.PersonDemographicRace)
                    .HasForeignKey(d => d.RefRaceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_DemographicRace_RefRace");
            });

            modelBuilder.Entity<PersonDetail>(entity =>
            {
                entity.HasKey(e => e.PersonDetailId);

                entity.ToTable("PersonDetail", "dbo");

                entity.Property(e => e.Birthdate).HasColumnType("date");

                entity.Property(e => e.BirthdateVerification).HasMaxLength(60);

                entity.Property(e => e.FirstName).HasMaxLength(35);

                entity.Property(e => e.GenerationCode).HasMaxLength(10);

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(35);

                entity.Property(e => e.MiddleName).HasMaxLength(35);

                entity.Property(e => e.Prefix).HasMaxLength(30);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.RefUscitizenshipStatusId).HasColumnName("RefUSCitizenshipStatusId");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_PersonDetail_Person");

                entity.HasOne(d => d.RefHighestEducationLevelCompleted)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefHighestEducationLevelCompletedId)
                    .HasConstraintName("FK_PersonDetail_RefEducationLevel");

                entity.HasOne(d => d.RefPersonalInformationVerification)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefPersonalInformationVerificationId)
                    .HasConstraintName("FK_PersonDetail_RefPersonalInformationVerification");

                entity.HasOne(d => d.RefProofOfResidencyType)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefProofOfResidencyTypeId)
                    .HasConstraintName("FK_PersonDetail_RefProofOfResidencyType");

                entity.HasOne(d => d.RefSex)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefSexId)
                    .HasConstraintName("FK_PersonDetail_RefSex");

                entity.HasOne(d => d.RefStateOfResidence)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefStateOfResidenceId)
                    .HasConstraintName("FK_PersonDetail_RefState");

                entity.HasOne(d => d.RefTribalAffiliation)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefTribalAffiliationId)
                    .HasConstraintName("FK_PersonDetail_RefTribalAffiliation");

                entity.HasOne(d => d.RefUscitizenshipStatus)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefUscitizenshipStatusId)
                    .HasConstraintName("FK_PersonDetail_RefUSCitizenshipStatus");

                entity.HasOne(d => d.RefVisaType)
                    .WithMany(p => p.PersonDetail)
                    .HasForeignKey(d => d.RefVisaTypeId)
                    .HasConstraintName("FK_PersonDetail_RefVisaType");
            });

            modelBuilder.Entity<PersonDisability>(entity =>
            {
                entity.ToTable("PersonDisability", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_PersonDisability_Person");

                entity.HasOne(d => d.PrimaryDisabilityType)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.PrimaryDisabilityTypeId)
                    .HasConstraintName("FK_PersonDisability_RefDisabilityType");

                entity.HasOne(d => d.RefAccommodationsNeededType)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.RefAccommodationsNeededTypeId)
                    .HasConstraintName("FK_PersonDisability_RefAccommodationsNeededType");

                entity.HasOne(d => d.RefDisabilityConditionStatusCode)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.RefDisabilityConditionStatusCodeId)
                    .HasConstraintName("FK_PersonDisability_RefDisabilityConditionStatusCode");

                entity.HasOne(d => d.RefDisabilityConditionType)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.RefDisabilityConditionTypeId)
                    .HasConstraintName("FK_PersonDisability_RefDisabilityConditionType");

                entity.HasOne(d => d.RefDisabilityDeterminationSourceType)
                    .WithMany(p => p.PersonDisability)
                    .HasForeignKey(d => d.RefDisabilityDeterminationSourceTypeId)
                    .HasConstraintName("FK_PersonDisability_RefDisabilityDeterminationSourceType");
            });

            modelBuilder.Entity<PersonEmailAddress>(entity =>
            {
                entity.ToTable("PersonEmailAddress", "dbo");

                entity.Property(e => e.EmailAddress).HasMaxLength(128);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonEmailAddress)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_Person_Email_Person");

                entity.HasOne(d => d.RefEmailType)
                    .WithMany(p => p.PersonEmailAddress)
                    .HasForeignKey(d => d.RefEmailTypeId)
                    .HasConstraintName("FK_PersonEmailAddress_RefEmailType");
            });

            modelBuilder.Entity<PersonFamily>(entity =>
            {
                entity.ToTable("PersonFamily", "dbo");

                entity.Property(e => e.FamilyIdentifier).HasMaxLength(40);

                entity.Property(e => e.FamilyIncome).HasColumnType("decimal");

                entity.Property(e => e.RefElprogramEligibilityId).HasColumnName("RefELProgramEligibilityId");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonFamily_Person");

                entity.HasOne(d => d.RefCommunicationMethod)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefCommunicationMethodId)
                    .HasConstraintName("FK_PersonFamily_RefCommunicationMethod");

                entity.HasOne(d => d.RefElprogramEligibility)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefElprogramEligibilityId)
                    .HasConstraintName("FK_PersonFamily_RefELProgramEligibility");

                entity.HasOne(d => d.RefFamilyIncomeSource)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefFamilyIncomeSourceId)
                    .HasConstraintName("FK_PersonFamily_RefFamilyIncomeSource");

                entity.HasOne(d => d.RefHighestEducationLevelCompleted)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefHighestEducationLevelCompletedId)
                    .HasConstraintName("FK_PersonFamily_RefEducationLevel");

                entity.HasOne(d => d.RefIncomeCalculationMethod)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefIncomeCalculationMethodId)
                    .HasConstraintName("FK_PersonFamily_RefIncomeCalculation");

                entity.HasOne(d => d.RefProofOfResidencyType)
                    .WithMany(p => p.PersonFamily)
                    .HasForeignKey(d => d.RefProofOfResidencyTypeId)
                    .HasConstraintName("FK_PersonFamily_RefProofOfResidencyType");
            });

            modelBuilder.Entity<PersonHealth>(entity =>
            {
                entity.ToTable("PersonHealth", "dbo");

                entity.Property(e => e.DentalScreeningDate).HasColumnType("date");

                entity.Property(e => e.HealthScreeningEquipmentUsed).HasMaxLength(300);

                entity.Property(e => e.HearingScreeningDate).HasColumnType("date");

                entity.Property(e => e.VisionScreeningDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonHealth_Person");

                entity.HasOne(d => d.RefDentalInsuranceCoverageType)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefDentalInsuranceCoverageTypeId)
                    .HasConstraintName("FK_PersonHealth_RefDentalInsuraceCoverageType");

                entity.HasOne(d => d.RefDentalScreeningStatus)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefDentalScreeningStatusId)
                    .HasConstraintName("FK_PersonHealth_RefDentalScreeningStatus");

                entity.HasOne(d => d.RefHealthInsuranceCoverage)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefHealthInsuranceCoverageId)
                    .HasConstraintName("FK_PersonHealth_RefHealthInsuranceCoverage");

                entity.HasOne(d => d.RefHearingScreeningStatus)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefHearingScreeningStatusId)
                    .HasConstraintName("FK_PersonHealth_RefHearingScreeningStatus");

                entity.HasOne(d => d.RefMedicalAlertIndicator)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefMedicalAlertIndicatorId)
                    .HasConstraintName("FK_PersonHealth_RefMedicalAlertIndicator");

                entity.HasOne(d => d.RefVisionScreeningStatus)
                    .WithMany(p => p.PersonHealth)
                    .HasForeignKey(d => d.RefVisionScreeningStatusId)
                    .HasConstraintName("FK_PersonHealth_RefVisionScreeningStatus");
            });

            modelBuilder.Entity<PersonHealthBirth>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_PersonHealthBirth");

                entity.ToTable("PersonHealthBirth", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.WeightAtBirth).HasMaxLength(20);

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.PersonHealthBirth)
                    .HasForeignKey<PersonHealthBirth>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonHealthBirth_Person");

                entity.HasOne(d => d.RefTrimesterWhenPrenatalCareBegan)
                    .WithMany(p => p.PersonHealthBirth)
                    .HasForeignKey(d => d.RefTrimesterWhenPrenatalCareBeganId)
                    .HasConstraintName("FK_PersonHealthBirth_RefTrimesterWhenPrenatalCareBegan");
            });

            modelBuilder.Entity<PersonHomelessness>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_HomelessPrimaryNighttimeResidence");

                entity.ToTable("PersonHomelessness", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.PersonHomelessness)
                    .HasForeignKey<PersonHomelessness>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_HomelessPrimaryNighttimeResidence_Person");

                entity.HasOne(d => d.RefHomelessNighttimeResidence)
                    .WithMany(p => p.PersonHomelessness)
                    .HasForeignKey(d => d.RefHomelessNighttimeResidenceId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_HomelessPrimaryNighttimeResidence_RefHomelessNighttimeResid");
            });

            modelBuilder.Entity<PersonIdentifier>(entity =>
            {
                entity.ToTable("PersonIdentifier", "dbo");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonIdentifier)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonIdentifier_Person");

                entity.HasOne(d => d.RefPersonIdentificationSystem)
                    .WithMany(p => p.PersonIdentifier)
                    .HasForeignKey(d => d.RefPersonIdentificationSystemId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonIdentifier_RefIdentifierPerson");

                entity.HasOne(d => d.RefPersonalInformationVerification)
                    .WithMany(p => p.PersonIdentifier)
                    .HasForeignKey(d => d.RefPersonalInformationVerificationId)
                    .HasConstraintName("FK_PersonIdentifier_RefPersonInfoVerification");
            });

            modelBuilder.Entity<PersonImmunization>(entity =>
            {
                entity.ToTable("PersonImmunization", "dbo");

                entity.Property(e => e.ImmunizationDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonImmunization)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonImmunization_Person1");

                entity.HasOne(d => d.RefImmunizationType)
                    .WithMany(p => p.PersonImmunization)
                    .HasForeignKey(d => d.RefImmunizationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonImmunization_RefImmunization");
            });

            modelBuilder.Entity<PersonLanguage>(entity =>
            {
                entity.ToTable("PersonLanguage", "dbo");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonLanguage)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonLanguage_Person");

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.PersonLanguage)
                    .HasForeignKey(d => d.RefLanguageId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonLanguage_RefLanguage");

                entity.HasOne(d => d.RefLanguageUseType)
                    .WithMany(p => p.PersonLanguage)
                    .HasForeignKey(d => d.RefLanguageUseTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonLanguage_RefLanguageUseType");
            });

            modelBuilder.Entity<PersonMaster>(entity =>
            {
                entity.ToTable("PersonMaster", "dbo");

                entity.Property(e => e.PersonMasterId).ValueGeneratedNever();
            });

            modelBuilder.Entity<PersonMilitary>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_PersonMilitary");

                entity.ToTable("PersonMilitary", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.PersonMilitary)
                    .HasForeignKey<PersonMilitary>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonMilitary_Person");

                entity.HasOne(d => d.RefMilitaryActiveStudentIndicator)
                    .WithMany(p => p.PersonMilitary)
                    .HasForeignKey(d => d.RefMilitaryActiveStudentIndicatorId)
                    .HasConstraintName("FK_PersonMilitary_RefMilitaryActiveStudentIndicator");

                entity.HasOne(d => d.RefMilitaryBranch)
                    .WithMany(p => p.PersonMilitary)
                    .HasForeignKey(d => d.RefMilitaryBranchId)
                    .HasConstraintName("FK_PersonMilitary_RefMilitaryBranch");

                entity.HasOne(d => d.RefMilitaryConnectedStudentIndicator)
                    .WithMany(p => p.PersonMilitary)
                    .HasForeignKey(d => d.RefMilitaryConnectedStudentIndicatorId)
                    .HasConstraintName("FK_PersonMilitary_RefMilitaryConnectedStudentIndicator");

                entity.HasOne(d => d.RefMilitaryVeteranStudentIndicator)
                    .WithMany(p => p.PersonMilitary)
                    .HasForeignKey(d => d.RefMilitaryVeteranStudentIndicatorId)
                    .HasConstraintName("FK_PersonMilitary_RefMilitaryVeteranStudentIndicator");
            });

            modelBuilder.Entity<PersonOtherName>(entity =>
            {
                entity.ToTable("PersonOtherName", "dbo");

                entity.Property(e => e.FirstName).HasMaxLength(35);

                entity.Property(e => e.LastName).HasMaxLength(35);

                entity.Property(e => e.MiddleName).HasMaxLength(35);

                entity.Property(e => e.OtherName).HasMaxLength(40);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonOtherName)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonOtherName_Person");

                entity.HasOne(d => d.RefOtherNameType)
                    .WithMany(p => p.PersonOtherName)
                    .HasForeignKey(d => d.RefOtherNameTypeId)
                    .HasConstraintName("FK_PersonOtherName__RefOtherNameType");
            });

            modelBuilder.Entity<PersonProgramParticipation>(entity =>
            {
                entity.ToTable("PersonProgramParticipation", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PersonProgramParticipation)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_PersonProgramParticipation_OrganizationPersonRole");

                entity.HasOne(d => d.RefParticipationType)
                    .WithMany(p => p.PersonProgramParticipation)
                    .HasForeignKey(d => d.RefParticipationTypeId)
                    .HasConstraintName("FK_PersonProgramParticipation_RefParticipationType");

                entity.HasOne(d => d.RefProgramExitReason)
                    .WithMany(p => p.PersonProgramParticipation)
                    .HasForeignKey(d => d.RefProgramExitReasonId)
                    .HasConstraintName("FK_PersonProgramParticipation_RefProgramExitReason");
            });

            modelBuilder.Entity<PersonReferral>(entity =>
            {
                entity.ToTable("PersonReferral", "dbo");

                entity.Property(e => e.ReferralDate).HasColumnType("date");

                entity.Property(e => e.ReferralTypeReceived).HasMaxLength(60);

                entity.Property(e => e.ReferredTo).HasMaxLength(60);

                entity.Property(e => e.Source).HasMaxLength(60);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonReferral)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonReferral_Person");

                entity.HasOne(d => d.RefReferralOutcome)
                    .WithMany(p => p.PersonReferral)
                    .HasForeignKey(d => d.RefReferralOutcomeId)
                    .HasConstraintName("FK_PersonReferral_RefReferralOutcome");
            });

            modelBuilder.Entity<PersonRelationship>(entity =>
            {
                entity.ToTable("PersonRelationship", "dbo");

                entity.Property(e => e.ContactRestrictions).HasMaxLength(2000);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonRelationshipPerson)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonRelationship_Person_Primary");

                entity.HasOne(d => d.RefPersonRelationship)
                    .WithMany(p => p.PersonRelationship)
                    .HasForeignKey(d => d.RefPersonRelationshipId)
                    .HasConstraintName("FK_PersonRelationship_RefRelationship");

                entity.HasOne(d => d.RelatedPerson)
                    .WithMany(p => p.PersonRelationshipRelatedPerson)
                    .HasForeignKey(d => d.RelatedPersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonRelationship_Person_Secondary");
            });

            modelBuilder.Entity<PersonStatus>(entity =>
            {
                entity.ToTable("PersonStatus", "dbo");

                entity.Property(e => e.StatusEndDate).HasColumnType("date");

                entity.Property(e => e.StatusStartDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonStatus)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonStatus_Person");

                entity.HasOne(d => d.RefPersonStatusType)
                    .WithMany(p => p.PersonStatus)
                    .HasForeignKey(d => d.RefPersonStatusTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonStatus_RefPersonStatusType");
            });

            modelBuilder.Entity<PersonTelephone>(entity =>
            {
                entity.ToTable("PersonTelephone", "dbo");

                entity.Property(e => e.PrimaryTelephoneNumberIndicator);

                entity.Property(e => e.TelephoneNumber).HasMaxLength(24);

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.PersonTelephone)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PersonPhone_Person");

                entity.HasOne(d => d.RefPersonTelephoneNumberType)
                    .WithMany(p => p.PersonTelephone)
                    .HasForeignKey(d => d.RefPersonTelephoneNumberTypeId)
                    .HasConstraintName("FK_PersonPhone_RefPersonTelephoneType");
            });

            modelBuilder.Entity<ProfessionalDevelopmentActivity>(entity =>
            {
                entity.ToTable("ProfessionalDevelopmentActivity", "dbo");

                entity.Property(e => e.ActivityCode).HasMaxLength(30);

                entity.Property(e => e.ActivityIdentifier).HasMaxLength(40);

                entity.Property(e => e.ApprovalCode).HasMaxLength(30);

                entity.Property(e => e.Cost).HasColumnType("decimal");

                entity.Property(e => e.Credits).HasColumnType("decimal");

                entity.Property(e => e.Description).HasMaxLength(2000);

                entity.Property(e => e.Objective).HasMaxLength(2000);

                entity.Property(e => e.RefPdactivityApprovedPurposeId).HasColumnName("RefPDActivityApprovedPurposeId");

                entity.Property(e => e.RefPdactivityCreditTypeId).HasColumnName("RefPDActivityCreditTypeId");

                entity.Property(e => e.RefPdactivityLevelId).HasColumnName("RefPDActivityLevelId");

                entity.Property(e => e.RefPdactivityTypeId).HasColumnName("RefPDActivityTypeId");

                entity.Property(e => e.RefPdaudienceTypeId).HasColumnName("RefPDAudienceTypeId");

                entity.Property(e => e.Title).HasMaxLength(50);

                entity.HasOne(d => d.Course)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.CourseId)
                    .HasConstraintName("FK_PDSession_Course");

                entity.HasOne(d => d.ProfessionalDevelopmentRequirement)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.ProfessionalDevelopmentRequirementId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDSession_PDRequirement");

                entity.HasOne(d => d.RefCourseCreditUnit)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefCourseCreditUnitId)
                    .HasConstraintName("FK_PDSession_RefCourseCreditUnit");

                entity.HasOne(d => d.RefPdactivityApprovedPurpose)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefPdactivityApprovedPurposeId)
                    .HasConstraintName("FK_ProfessionalDevelopmentActivity_RefPDActivityApprovedFor");

                entity.HasOne(d => d.RefPdactivityCreditType)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefPdactivityCreditTypeId)
                    .HasConstraintName("FK_ProfessionalDevelopmentActivity_RefPDActivityCreditType");

                entity.HasOne(d => d.RefPdactivityLevel)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefPdactivityLevelId)
                    .HasConstraintName("FK_ProfessionalDevelopmentActivity_RefPDActivityLevel");

                entity.HasOne(d => d.RefPdactivityType)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefPdactivityTypeId)
                    .HasConstraintName("FK_ProfessionalDevelopmentActivity_RefPDActivityType");

                entity.HasOne(d => d.RefPdaudienceType)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefPdaudienceTypeId)
                    .HasConstraintName("FK_ProfessionalDevelopmentActivity_RefPDAudienceType");

                entity.HasOne(d => d.RefProfessionalDevelopmentFinancialSupport)
                    .WithMany(p => p.ProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefProfessionalDevelopmentFinancialSupportId)
                    .HasConstraintName("FK_PDSession_RefProfDevFinancialSupport");
            });

            modelBuilder.Entity<ProfessionalDevelopmentRequirement>(entity =>
            {
                entity.ToTable("ProfessionalDevelopmentRequirement", "dbo");

                entity.Property(e => e.RequiredTrainingClockHours).HasColumnType("decimal");

                entity.HasOne(d => d.CompetencySet)
                    .WithMany(p => p.ProfessionalDevelopmentRequirement)
                    .HasForeignKey(d => d.CompetencySetId)
                    .HasConstraintName("FK_ProfessionalDevelopmentRequirement_CompetencySet");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.ProfessionalDevelopmentRequirement)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProfessionalDevelopmentRequirement_OrganizationPersonRole");
            });

            modelBuilder.Entity<ProfessionalDevelopmentSession>(entity =>
            {
                entity.ToTable("ProfessionalDevelopmentSession", "dbo");

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.EndTime).HasMaxLength(15);

                entity.Property(e => e.EvaluationMethod).HasMaxLength(30);

                entity.Property(e => e.EvaluationScore).HasMaxLength(30);

                entity.Property(e => e.ExpirationDate).HasColumnType("date");

                entity.Property(e => e.FundingSource).HasMaxLength(30);

                entity.Property(e => e.LocationName).HasMaxLength(60);

                entity.Property(e => e.RefEltrainerCoreKnowledgeAreaId).HasColumnName("RefELTrainerCoreKnowledgeAreaId");

                entity.Property(e => e.RefPddeliveryMethodId).HasColumnName("RefPDDeliveryMethodId");

                entity.Property(e => e.RefPdinstructionalDeliveryModeId).HasColumnName("RefPDInstructionalDeliveryModeId");

                entity.Property(e => e.RefPdsessionStatusId).HasColumnName("RefPDSessionStatusId");

                entity.Property(e => e.SessionIdentifier).HasMaxLength(40);

                entity.Property(e => e.SponsoringAgencyName).HasMaxLength(60);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.Property(e => e.StartTime).HasMaxLength(15);

                entity.Property(e => e.TrainingAndTechnicalAssistanceLevel).HasMaxLength(100);

                entity.HasOne(d => d.ProfessionalDevelopmentActivity)
                    .WithMany(p => p.ProfessionalDevelopmentSession)
                    .HasForeignKey(d => d.ProfessionalDevelopmentActivityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDSession_PDActivity");

                entity.HasOne(d => d.RefEltrainerCoreKnowledgeArea)
                    .WithMany(p => p.ProfessionalDevelopmentSession)
                    .HasForeignKey(d => d.RefEltrainerCoreKnowledgeAreaId)
                    .HasConstraintName("FK_ProfessionalDevelopmentSession_RefELTrainerCoreKnowledgeArea");

                entity.HasOne(d => d.RefLanguage)
                    .WithMany(p => p.ProfessionalDevelopmentSession)
                    .HasForeignKey(d => d.RefLanguageId)
                    .HasConstraintName("FK_PDSession_RefLanguage");

                entity.HasOne(d => d.RefPdinstructionalDeliveryMode)
                    .WithMany(p => p.ProfessionalDevelopmentSession)
                    .HasForeignKey(d => d.RefPdinstructionalDeliveryModeId)
                    .HasConstraintName("FK_PDSession_RefPDInstructionalDeliveryMode");

                entity.HasOne(d => d.RefPdsessionStatus)
                    .WithMany(p => p.ProfessionalDevelopmentSession)
                    .HasForeignKey(d => d.RefPdsessionStatusId)
                    .HasConstraintName("FK_PDSession_RefPDSessionStatus");
            });

            modelBuilder.Entity<ProfessionalDevelopmentSessionInstructor>(entity =>
            {
                entity.ToTable("ProfessionalDevelopmentSessionInstructor", "dbo");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.ProfessionalDevelopmentSessionInstructor)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDSessionInstructor_OrgPersonRole");

                entity.HasOne(d => d.ProfessionalDevelopmentSession)
                    .WithMany(p => p.ProfessionalDevelopmentSessionInstructor)
                    .HasForeignKey(d => d.ProfessionalDevelopmentSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDSessionInstructor_PDSession");
            });

            modelBuilder.Entity<Program>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_Program");

                entity.ToTable("Program", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.CreditsRequired).HasColumnType("decimal");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.Program)
                    .HasForeignKey<Program>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Program_Organization");
            });

            modelBuilder.Entity<ProgramParticipationAe>(entity =>
            {
                entity.ToTable("ProgramParticipationAE", "dbo");

                entity.Property(e => e.ProgramParticipationAeid).HasColumnName("ProgramParticipationAEId");

                entity.Property(e => e.InstructionalActivityHoursCompleted).HasColumnType("decimal");

                entity.Property(e => e.PostsecondaryTransitionDate).HasColumnType("date");

                entity.Property(e => e.ProxyContactHours).HasColumnType("decimal");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationAE_PersonProgramParticipation");

                entity.HasOne(d => d.RefAeFunctioningLevelAtIntake)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefAeFunctioningLevelAtIntakeId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefAeFunctioningLevelAtIntake");

                entity.HasOne(d => d.RefAeFunctioningLevelAtPosttest)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefAeFunctioningLevelAtPosttestId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefAeFunctioningLevelAtPosttest");

                entity.HasOne(d => d.RefAeInstructionalProgramType)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefAeInstructionalProgramTypeId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefAeInstructionalProgramType");

                entity.HasOne(d => d.RefAePostsecondaryTransitionAction)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefAePostsecondaryTransitionActionId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefAePostsecondaryTransitionAction");

                entity.HasOne(d => d.RefAeSpecialProgramType)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefAeSpecialProgramTypeId)
                    .HasConstraintName("FK_ProgramParticipation_RefAeSpecialProgramType");

                entity.HasOne(d => d.RefCorrectionalEducationFacilityType)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefCorrectionalEducationFacilityTypeId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefCorrectionalEducationFacilityType");

                entity.HasOne(d => d.RefGoalsForAttendingAdultEducation)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefGoalsForAttendingAdultEducationId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefGoalsForAttendingAdultEducation");

                entity.HasOne(d => d.RefWorkbasedLearningOpportunityType)
                    .WithMany(p => p.ProgramParticipationAe)
                    .HasForeignKey(d => d.RefWorkbasedLearningOpportunityTypeId)
                    .HasConstraintName("FK_ProgramParticipationAE_RefWorkbasedLearningOpportunityType");
            });

            modelBuilder.Entity<ProgramParticipationCte>(entity =>
            {
                entity.ToTable("ProgramParticipationCte", "dbo");

                entity.Property(e => e.CareerPathwaysProgramParticipationExitDate).HasColumnType("date");

                entity.Property(e => e.CareerPathwaysProgramParticipationStartDate).HasColumnType("date");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationCte)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationCte_PersonProgramParticipation");

                entity.HasOne(d => d.RefNonTraditionalGenderStatus)
                    .WithMany(p => p.ProgramParticipationCte)
                    .HasForeignKey(d => d.RefNonTraditionalGenderStatusId)
                    .HasConstraintName("FK_ProgramParticipationCte_RefNonTraditionalGenderStatus");

                entity.HasOne(d => d.RefWorkbasedLearningOpportunityType)
                    .WithMany(p => p.ProgramParticipationCte)
                    .HasForeignKey(d => d.RefWorkbasedLearningOpportunityTypeId)
                    .HasConstraintName("FK_ProgramParticipationCte_RefWorkbasedLearningOpportunityType");
            });

            modelBuilder.Entity<ProgramParticipationFoodService>(entity =>
            {
                entity.ToTable("ProgramParticipationFoodService", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationFoodService)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationFoodSrvc_PersonProgramParticipation");

                entity.HasOne(d => d.RefSchoolFoodServiceProgram)
                    .WithMany(p => p.ProgramParticipationFoodService)
                    .HasForeignKey(d => d.RefSchoolFoodServiceProgramId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationFoodSrvc_RefSchoolFoodServiceProgram");
            });

            modelBuilder.Entity<ProgramParticipationMigrant>(entity =>
            {
                entity.ToTable("ProgramParticipationMigrant", "dbo");

                entity.Property(e => e.BirthdateVerification).HasMaxLength(60);

                entity.Property(e => e.LastQualifyingMoveDate).HasColumnType("date");

                entity.Property(e => e.MepEligibilityExpirationDate).HasColumnType("date");

                entity.Property(e => e.MigrantStudentQualifyingArrivalDate).HasColumnType("date");

                entity.Property(e => e.QualifyingMoveFromCity).HasMaxLength(30);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.DesignatedGraduationSchool)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.DesignatedGraduationSchoolId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_Organization");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationMigrant_PersonProgramParticipation");

                entity.HasOne(d => d.RefContinuationOfServicesReason)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefContinuationOfServicesReasonId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefContinuationOfServices");

                entity.HasOne(d => d.RefMepEnrollmentType)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefMepEnrollmentTypeId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefMEPEnrollmentType");

                entity.HasOne(d => d.RefMepProjectBased)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefMepProjectBasedId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefMEPProjectBased");

                entity.HasOne(d => d.RefMepServiceType)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefMepServiceTypeId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefMEPServiceType");

                entity.HasOne(d => d.RefQualifyingMoveFromCountry)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefQualifyingMoveFromCountryId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefCountry");

                entity.HasOne(d => d.RefQualifyingMoveFromState)
                    .WithMany(p => p.ProgramParticipationMigrant)
                    .HasForeignKey(d => d.RefQualifyingMoveFromStateId)
                    .HasConstraintName("FK_ProgramParticipationMigrant_RefState");
            });

            modelBuilder.Entity<ProgramParticipationNeglected>(entity =>
            {
                entity.ToTable("ProgramParticipationNeglected", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationNeglected)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationNeglected_PersonProgramParticipation");

                entity.HasOne(d => d.RefNeglectedProgramType)
                    .WithMany(p => p.ProgramParticipationNeglected)
                    .HasForeignKey(d => d.RefNeglectedProgramTypeId)
                    .HasConstraintName("FK_ProgramParticipationNeglected_RefNeglectedProgramType");
            });

            modelBuilder.Entity<ProgramParticipationSpecialEducation>(entity =>
            {
                entity.ToTable("ProgramParticipationSpecialEducation", "dbo");

                entity.Property(e => e.AwaitingInitialIdeaevaluationStatus).HasColumnName("AwaitingInitialIDEAEvaluationStatus");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.RefIdeaedEnvironmentSchoolAgeId).HasColumnName("RefIDEAEdEnvironmentSchoolAgeId");

                entity.Property(e => e.RefIdeaeducationalEnvironmentEcid).HasColumnName("RefIDEAEducationalEnvironmentECId");

                entity.Property(e => e.SpecialEducationFte)
                    .HasColumnName("SpecialEducationFTE")
                    .HasColumnType("decimal");

                entity.Property(e => e.SpecialEducationServicesExitDate).HasColumnType("date");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationSpecialEducation)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_ProgramParticipationSpecialEducation_PersonProgramParticipat");

                entity.HasOne(d => d.RefIdeaedEnvironmentSchoolAge)
                    .WithMany(p => p.ProgramParticipationSpecialEducation)
                    .HasForeignKey(d => d.RefIdeaedEnvironmentSchoolAgeId)
                    .HasConstraintName("FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentSchoolAge");

                entity.HasOne(d => d.RefIdeaeducationalEnvironmentEc)
                    .WithMany(p => p.ProgramParticipationSpecialEducation)
                    .HasForeignKey(d => d.RefIdeaeducationalEnvironmentEcid)
                    .HasConstraintName("FK_ProgramParticipationSpecialEd_RefIDEAEdEnvironmentForEC");

                entity.HasOne(d => d.RefSpecialEducationExitReason)
                    .WithMany(p => p.ProgramParticipationSpecialEducation)
                    .HasForeignKey(d => d.RefSpecialEducationExitReasonId)
                    .HasConstraintName("FK_ProgramParticipationSpecialEd_RefSpecialEducationExitReason");
            });

            modelBuilder.Entity<ProgramParticipationTeacherPrep>(entity =>
            {
                entity.ToTable("ProgramParticipationTeacherPrep", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_PersonProgramParticipation");

                entity.HasOne(d => d.RefAltRouteToCertificationOrLicensure)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefAltRouteToCertificationOrLicensureId)
                    .HasConstraintName("FK_ProgramParticipationTeacherPrep_RefAltRouteToCertificationOrLicensure");

                entity.HasOne(d => d.RefCriticalTeacherShortageCandidate)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefCriticalTeacherShortageCandidateId)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_RefCritTeachShortageCandidate");

                entity.HasOne(d => d.RefSupervisedClinicalExperience)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefSupervisedClinicalExperienceId)
                    .HasConstraintName("FK_ProgramParticipationTeacherPrep_RefSupervisedClinicalExper");

                entity.HasOne(d => d.RefTeacherPrepCompleterStatus)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefTeacherPrepCompleterStatusId)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_RefTeacherPrepCompleterStatus");

                entity.HasOne(d => d.RefTeacherPrepEnrollmentStatus)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefTeacherPrepEnrollmentStatusId)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_RefTeacherPrepEnrollStatus");

                entity.HasOne(d => d.RefTeachingCredentialBasis)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefTeachingCredentialBasisId)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_RefTeachingCredentialBasis");

                entity.HasOne(d => d.RefTeachingCredentialType)
                    .WithMany(p => p.ProgramParticipationTeacherPrep)
                    .HasForeignKey(d => d.RefTeachingCredentialTypeId)
                    .HasConstraintName("FK_PrgmParticipationTeacherPrep_RefTeachingCredentialType");
            });

            modelBuilder.Entity<ProgramParticipationTitleI>(entity =>
            {
                entity.HasKey(e => e.PersonProgramParticipationId)
                    .HasName("PK_ProgramParticipationTitleI");

                entity.ToTable("ProgramParticipationTitleI", "dbo");

                entity.Property(e => e.PersonProgramParticipationId).ValueGeneratedNever();

                entity.Property(e => e.RefTitleIindicatorId).HasColumnName("RefTitleIIndicatorId");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithOne(p => p.ProgramParticipationTitleI)
                    .HasForeignKey<ProgramParticipationTitleI>(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationTitleI_PersonProgramParticipation");

                entity.HasOne(d => d.RefTitleIindicator)
                    .WithMany(p => p.ProgramParticipationTitleI)
                    .HasForeignKey(d => d.RefTitleIindicatorId)
                    .HasConstraintName("FK_ProgramParticipationTitleI_RefTitleIIndicator");
            });

            modelBuilder.Entity<ProgramParticipationTitleIiilep>(entity =>
            {
                entity.ToTable("ProgramParticipationTitleIIILep", "dbo");

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.Property(e => e.RefTitleIiiaccountabilityId).HasColumnName("RefTitleIIIAccountabilityId");

                entity.Property(e => e.RefTitleIiilanguageInstructionProgramTypeId).HasColumnName("RefTitleIIILanguageInstructionProgramTypeId");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithMany(p => p.ProgramParticipationTitleIiilep)
                    .HasForeignKey(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ProgramParticipationTitleIII_PersonProgramParticipation");

                entity.HasOne(d => d.RefTitleIiiaccountability)
                    .WithMany(p => p.ProgramParticipationTitleIiilep)
                    .HasForeignKey(d => d.RefTitleIiiaccountabilityId)
                    .HasConstraintName("FK_ProgramParticipationTitleIIILep_RefTitleIIIAccountability");

                entity.HasOne(d => d.RefTitleIiilanguageInstructionProgramType)
                    .WithMany(p => p.ProgramParticipationTitleIiilep)
                    .HasForeignKey(d => d.RefTitleIiilanguageInstructionProgramTypeId)
                    .HasConstraintName("FK_ProgramParticipationTitleIIILEP_RefTitleIIILangInstrPrgm");
            });

            modelBuilder.Entity<PsCourse>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_PsCourse");

                entity.ToTable("PsCourse", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.CourseNumber).HasMaxLength(30);

                entity.Property(e => e.NcaaeligibilityInd).HasColumnName("NCAAEligibilityInd");

                entity.Property(e => e.OriginalCourseIdentifier).HasMaxLength(40);

                entity.Property(e => e.OverrideSchoolCourseNumber).HasMaxLength(30);

                entity.Property(e => e.RefNcescollegeCourseMapCodeId).HasColumnName("RefNCESCollegeCourseMapCodeId");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.PsCourse)
                    .HasForeignKey<PsCourse>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsCourse_Course");

                entity.HasOne(d => d.RefCipCode)
                    .WithMany(p => p.PsCourse)
                    .HasForeignKey(d => d.RefCipCodeId)
                    .HasConstraintName("FK_PsCourse_RefCipCode");

                entity.HasOne(d => d.RefCourseCreditBasisType)
                    .WithMany(p => p.PsCourse)
                    .HasForeignKey(d => d.RefCourseCreditBasisTypeId)
                    .HasConstraintName("FK_PsCourse_RefCourseCreditBasisType");

                entity.HasOne(d => d.RefCourseCreditLevelType)
                    .WithMany(p => p.PsCourse)
                    .HasForeignKey(d => d.RefCourseCreditLevelTypeId)
                    .HasConstraintName("FK_PsCourse_RefCourseCreditLevelType");

                entity.HasOne(d => d.RefNcescollegeCourseMapCode)
                    .WithMany(p => p.PsCourse)
                    .HasForeignKey(d => d.RefNcescollegeCourseMapCodeId)
                    .HasConstraintName("FK_PsCourse_RefNCESCollegeCourseMapCode");
            });

            modelBuilder.Entity<PsInstitution>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_PsInstitution");

                entity.ToTable("PsInstitution", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.PsInstitution)
                    .HasForeignKey<PsInstitution>(d => d.OrganizationId)
                    .HasConstraintName("FK_PsInstitution_Organization");

                entity.HasOne(d => d.RefAdmissionConsiderationLevel)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefAdmissionConsiderationLevelId)
                    .HasConstraintName("FK_PsInstitution_RefAdmissionConsiderationLevel");

                entity.HasOne(d => d.RefAdmissionConsiderationType)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefAdmissionConsiderationTypeId)
                    .HasConstraintName("FK_PsInstitution_RefAdmissionConsiderationType");

                entity.HasOne(d => d.RefCarnegieBasicClassification)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefCarnegieBasicClassificationId)
                    .HasConstraintName("FK_PsInstitution_RefClassification");

                entity.HasOne(d => d.RefControlOfInstitution)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefControlOfInstitutionId)
                    .HasConstraintName("FK_PsInstitution_RefControlOfInstitution");

                entity.HasOne(d => d.RefLevelOfInstitution)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefLevelOfInstitutionId)
                    .HasConstraintName("FK_PsInstitution_RefLevelOfInstitution");

                entity.HasOne(d => d.RefPredominantCalendarSystem)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefPredominantCalendarSystemId)
                    .HasConstraintName("FK_PsInstitution_RefPredominantCalendarSystem");

                entity.HasOne(d => d.RefTenureSystem)
                    .WithMany(p => p.PsInstitution)
                    .HasForeignKey(d => d.RefTenureSystemId)
                    .HasConstraintName("FK_PsInstitution_RefTenureSystem");
            });

            modelBuilder.Entity<PsPriceOfAttendance>(entity =>
            {
                entity.ToTable("PsPriceOfAttendance", "dbo");

                entity.Property(e => e.PspriceOfAttendanceId).HasColumnName("PSPriceOfAttendanceId");

                entity.Property(e => e.BoardCharges).HasColumnType("decimal");

                entity.Property(e => e.BooksAndSuppliesCosts).HasColumnType("decimal");

                entity.Property(e => e.ComprehensiveFee).HasColumnType("decimal");

                entity.Property(e => e.IpedscollectionYearDesignator)
                    .HasColumnName("IPEDSCollectionYearDesignator")
                    .HasColumnType("nchar(9)");

                entity.Property(e => e.OtherStudentExpenses).HasColumnType("decimal");

                entity.Property(e => e.PriceOfAttendance).HasColumnType("decimal");

                entity.Property(e => e.RequiredStudentFees).HasColumnType("decimal");

                entity.Property(e => e.RoomCharges).HasColumnType("decimal");

                entity.Property(e => e.SessionDesignator).HasColumnType("nchar(7)");

                entity.Property(e => e.TuitionPublished).HasColumnType("decimal");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.PsPriceOfAttendance)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PSPriceOfAttendance_PsInstitution");

                entity.HasOne(d => d.RefTuitionUnit)
                    .WithMany(p => p.PsPriceOfAttendance)
                    .HasForeignKey(d => d.RefTuitionUnitId)
                    .HasConstraintName("FK_PSPriceOfAttendance_RefTuitionUnit");
            });

            modelBuilder.Entity<PsProgram>(entity =>
            {
                entity.ToTable("PsProgram", "dbo");

                entity.Property(e => e.NormalLengthTimeForCompletion).HasMaxLength(60);

                entity.Property(e => e.ProgramLengthHours).HasColumnType("decimal");

                entity.Property(e => e.RefDqpcategoriesOfLearningId).HasColumnName("RefDQPCategoriesOfLearningId");

                entity.Property(e => e.RefPsexitOrWithdrawalTypeId).HasColumnName("RefPSExitOrWithdrawalTypeId");

                entity.Property(e => e.RefPsprogramLevelId).HasColumnName("RefPSProgramLevelId");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsProgram_Organization");

                entity.HasOne(d => d.RefCipCode)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefCipCodeId)
                    .HasConstraintName("FK_PsProgram_RefCipCode");

                entity.HasOne(d => d.RefCipVersion)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefCipVersionId)
                    .HasConstraintName("FK_PsProgram_RefCipVersion");

                entity.HasOne(d => d.RefDqpcategoriesOfLearning)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefDqpcategoriesOfLearningId)
                    .HasConstraintName("FK_PsProgram_RefDQPCategoriesOfLearning");

                entity.HasOne(d => d.RefProgramLengthHoursType)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefProgramLengthHoursTypeId)
                    .HasConstraintName("FK_PsProgram_RefProgramLengthHoursType");

                entity.HasOne(d => d.RefPsexitOrWithdrawalType)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefPsexitOrWithdrawalTypeId)
                    .HasConstraintName("FK_PSProgram_RefPSExitOrWithdrawalType");

                entity.HasOne(d => d.RefPsprogramLevel)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefPsprogramLevelId)
                    .HasConstraintName("FK_PSProgram_RefPSProgramLevel");

                entity.HasOne(d => d.RefTimeForCompletionUnits)
                    .WithMany(p => p.PsProgram)
                    .HasForeignKey(d => d.RefTimeForCompletionUnitsId)
                    .HasConstraintName("FK_PsProgram_RefTimeForCompletionUnits");
            });

            modelBuilder.Entity<PsSection>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_PsSection");

                entity.ToTable("PsSection", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.GradeValueQualifier).HasColumnType("nchar(2)");

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.PsSection)
                    .HasForeignKey<PsSection>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsSection_Organization");

                entity.HasOne(d => d.RefCipCode)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefCipCodeId)
                    .HasConstraintName("FK_PsSection_RefCipCode");

                entity.HasOne(d => d.RefCourseGpaApplicability)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefCourseGpaApplicabilityId)
                    .HasConstraintName("FK_PsSection _RefCourseGpaApplicability");

                entity.HasOne(d => d.RefCourseHonorsType)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefCourseHonorsTypeId)
                    .HasConstraintName("FK_PsSection _RefCourseHonorsType");

                entity.HasOne(d => d.RefCourseInstructionMethod)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefCourseInstructionMethodId)
                    .HasConstraintName("FK_PsSection _RefCourseInstructionMethod");

                entity.HasOne(d => d.RefCourseLevelType)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefCourseLevelTypeId)
                    .HasConstraintName("FK_PsSection _RefCourseLevelType");

                entity.HasOne(d => d.RefDevelopmentalEducationType)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefDevelopmentalEducationTypeId)
                    .HasConstraintName("FK_PsSection_RefDevelopmentalEducationType");

                entity.HasOne(d => d.RefWorkbasedLearningOpportunityType)
                    .WithMany(p => p.PsSection)
                    .HasForeignKey(d => d.RefWorkbasedLearningOpportunityTypeId)
                    .HasConstraintName("FK_PsSection_RefWorkbasedLearningOpportunityType");
            });

            modelBuilder.Entity<PsSectionLocation>(entity =>
            {
                entity.HasKey(e => e.OrganizationId)
                    .HasName("PK_PsSectionLocation");

                entity.ToTable("PsSectionLocation", "dbo");

                entity.Property(e => e.OrganizationId).ValueGeneratedNever();

                entity.Property(e => e.CourseInstructionSiteName).HasMaxLength(60);

                entity.HasOne(d => d.Organization)
                    .WithOne(p => p.PsSectionLocation)
                    .HasForeignKey<PsSectionLocation>(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsSectionLocation_PsSection");

                entity.HasOne(d => d.RefCourseInstructionSiteType)
                    .WithMany(p => p.PsSectionLocation)
                    .HasForeignKey(d => d.RefCourseInstructionSiteTypeId)
                    .HasConstraintName("FK_PsSectionLocation_RefCourseInstructionSiteType");
            });

            modelBuilder.Entity<PsStaffEmployment>(entity =>
            {
                entity.HasKey(e => e.StaffEmploymentId)
                    .HasName("PK_PsStaffEmployment");

                entity.ToTable("PsStaffEmployment", "dbo");

                entity.Property(e => e.StaffEmploymentId).ValueGeneratedNever();

                entity.Property(e => e.AnnualBaseContractualSalary).HasColumnType("decimal");

                entity.Property(e => e.StandardOccupationalClass).HasColumnType("nchar(7)");

                entity.HasOne(d => d.RefAcademicRank)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefAcademicRankId)
                    .HasConstraintName("FK_PsStaffEmployment_RefAcademicRank");

                entity.HasOne(d => d.RefEmploymentContractType)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefEmploymentContractTypeId)
                    .HasConstraintName("FK_PsStaffEmployment_RefEmploymentContractType");

                entity.HasOne(d => d.RefFullTimeStatus)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefFullTimeStatusId)
                    .HasConstraintName("FK_PsStaffEmployment_RefFullTimeStatus");

                entity.HasOne(d => d.RefGraduateAssistantIpedsCategory)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefGraduateAssistantIpedsCategoryId)
                    .HasConstraintName("FK_PsStaffEmployment_RefGraduateAssistIpedsCategory");

                entity.HasOne(d => d.RefInstructionCreditType)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefInstructionCreditTypeId)
                    .HasConstraintName("FK_PsStaffEmployment_InstructionCreditType");

                entity.HasOne(d => d.RefInstructionalStaffContractLength)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefInstructionalStaffContractLengthId)
                    .HasConstraintName("FK_PsStaffEmployment_RefInstructStaffContractLength");

                entity.HasOne(d => d.RefInstructionalStaffFacultyTenure)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefInstructionalStaffFacultyTenureId)
                    .HasConstraintName("FK_PsStaffEmployment_RefInstructStaffFacultyTenure");

                entity.HasOne(d => d.RefIpedsOccupationalCategory)
                    .WithMany(p => p.PsStaffEmployment)
                    .HasForeignKey(d => d.RefIpedsOccupationalCategoryId)
                    .HasConstraintName("FK_PsStaffEmployment_RefIPEDSOccupationalCategory");

                entity.HasOne(d => d.StaffEmployment)
                    .WithOne(p => p.PsStaffEmployment)
                    .HasForeignKey<PsStaffEmployment>(d => d.StaffEmploymentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStaffEmployment_StaffEmployment");
            });

            modelBuilder.Entity<PsStudentAcademicAward>(entity =>
            {
                entity.ToTable("PsStudentAcademicAward", "dbo");

                entity.Property(e => e.AcademicAwardDate).HasMaxLength(14);

                entity.Property(e => e.AcademicAwardTitle).HasMaxLength(80);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PsStudentAcademicAward)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentAcademicAward_OrganizationPersonRole");

                entity.HasOne(d => d.RefAcademicAwardLevel)
                    .WithMany(p => p.PsStudentAcademicAward)
                    .HasForeignKey(d => d.RefAcademicAwardLevelId)
                    .HasConstraintName("FK_PsAcademicAward_RefAcademicAwardLevel");
            });

            modelBuilder.Entity<PsStudentAcademicRecord>(entity =>
            {
                entity.ToTable("PsStudentAcademicRecord", "dbo");

                entity.Property(e => e.AcademicYearDesignator).HasColumnType("nchar(9)");

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("nchar(7)");

                entity.Property(e => e.DualCreditDualEnrollmentCredits).HasColumnType("decimal");

                entity.Property(e => e.EnteringTerm).HasMaxLength(30);

                entity.Property(e => e.GradePointAverage).HasColumnType("decimal");

                entity.Property(e => e.GradePointAverageCumulative).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PsStudentAcademicRecord)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentAcademicRecord_OrganizationPersonRole");

                entity.HasOne(d => d.RefAcademicTermDesignator)
                    .WithMany(p => p.PsStudentAcademicRecord)
                    .HasForeignKey(d => d.RefAcademicTermDesignatorId)
                    .HasConstraintName("FK_PsStudentAcademicRecord_RefAcademicTermDesignator");

                entity.HasOne(d => d.RefCreditHoursAppliedOtherProgram)
                    .WithMany(p => p.PsStudentAcademicRecord)
                    .HasForeignKey(d => d.RefCreditHoursAppliedOtherProgramId)
                    .HasConstraintName("FK_PsStudentAcademicRecord_RefCreditHours");

                entity.HasOne(d => d.RefProfessionalTechCredentialType)
                    .WithMany(p => p.PsStudentAcademicRecord)
                    .HasForeignKey(d => d.RefProfessionalTechCredentialTypeId)
                    .HasConstraintName("FK_PsStudentAcademicRecord_RefProfTechCredentialType");
            });

            modelBuilder.Entity<PsStudentAdmissionTest>(entity =>
            {
                entity.ToTable("PsStudentAdmissionTest", "dbo");

                entity.Property(e => e.StandardizedAdmissionTestScore).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PsStudentAdmissionTest)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsAdmissionTest_OrganizationPersonRole");

                entity.HasOne(d => d.RefStandardizedAdmissionTest)
                    .WithMany(p => p.PsStudentAdmissionTest)
                    .HasForeignKey(d => d.RefStandardizedAdmissionTestId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsAdmissionTest_RefStandardizedAdmissionTest");
            });

            modelBuilder.Entity<PsStudentApplication>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentApplication");

                entity.ToTable("PsStudentApplication", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.GradePointAverageCumulative).HasColumnType("decimal");

                entity.Property(e => e.HighSchoolPercentile).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentApplication)
                    .HasForeignKey<PsStudentApplication>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentApplication_OrganizationPersonRole");

                entity.HasOne(d => d.RefAdmittedStudent)
                    .WithMany(p => p.PsStudentApplication)
                    .HasForeignKey(d => d.RefAdmittedStudentId)
                    .HasConstraintName("FK_PsStudentApplication_RefAdmittedStudent");

                entity.HasOne(d => d.RefGpaWeightedIndicator)
                    .WithMany(p => p.PsStudentApplication)
                    .HasForeignKey(d => d.RefGpaWeightedIndicatorId)
                    .HasConstraintName("FK_PsStudentApplication_RefGpaWeightedIndicator");

                entity.HasOne(d => d.RefGradePointAverageDomain)
                    .WithMany(p => p.PsStudentApplication)
                    .HasForeignKey(d => d.RefGradePointAverageDomainId)
                    .HasConstraintName("FK_PsStudentApplication_RefGradePointAverageDomain");
            });

            modelBuilder.Entity<PsStudentCohort>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentCohort");

                entity.ToTable("PsStudentCohort", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.CohortGraduationYear).HasColumnType("nchar(4)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentCohort)
                    .HasForeignKey<PsStudentCohort>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentCohort_OrganizationPersonRole");
            });

            modelBuilder.Entity<PsStudentCourseSectionMark>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentCourseSectionMark");

                entity.ToTable("PsStudentCourseSectionMark", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.CourseNarrativeExplanationGrade).HasMaxLength(300);

                entity.Property(e => e.StudentCourseSectionGradeNarrative).HasMaxLength(300);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentCourseSectionMark)
                    .HasForeignKey<PsStudentCourseSectionMark>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentCourseSectionMark_StudentSection");
            });

            modelBuilder.Entity<PsStudentDemographic>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentDemographic");

                entity.ToTable("PsStudentDemographic", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentDemographic)
                    .HasForeignKey<PsStudentDemographic>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentDemographic_OrganizationPersonRole");

                entity.HasOne(d => d.RefCampusResidencyType)
                    .WithMany(p => p.PsStudentDemographic)
                    .HasForeignKey(d => d.RefCampusResidencyTypeId)
                    .HasConstraintName("FK_PsStudentDemographic_RefCampusResidencyType");

                entity.HasOne(d => d.RefCohortExclusion)
                    .WithMany(p => p.PsStudentDemographic)
                    .HasForeignKey(d => d.RefCohortExclusionId)
                    .HasConstraintName("FK_PsStudentDemographic_RefCohortExclusion");

                entity.HasOne(d => d.RefDependencyStatus)
                    .WithMany(p => p.PsStudentDemographic)
                    .HasForeignKey(d => d.RefDependencyStatusId)
                    .HasConstraintName("FK_PsStudentDemographic_RefDependencyStatus");

                entity.HasOne(d => d.RefMaternalEducationLevel)
                    .WithMany(p => p.PsStudentDemographicRefMaternalEducationLevel)
                    .HasForeignKey(d => d.RefMaternalEducationLevelId)
                    .HasConstraintName("FK_PsStudentDemographic_RefEducationLevel1");

                entity.HasOne(d => d.RefPaternalEducationLevel)
                    .WithMany(p => p.PsStudentDemographicRefPaternalEducationLevel)
                    .HasForeignKey(d => d.RefPaternalEducationLevelId)
                    .HasConstraintName("FK_PsStudentDemographic_RefEducationLevel");

                entity.HasOne(d => d.RefPsLepType)
                    .WithMany(p => p.PsStudentDemographic)
                    .HasForeignKey(d => d.RefPsLepTypeId)
                    .HasConstraintName("FK_PsStudentDemographic_RefPostsecondaryLEPType");

                entity.HasOne(d => d.RefTuitionResidencyType)
                    .WithMany(p => p.PsStudentDemographic)
                    .HasForeignKey(d => d.RefTuitionResidencyTypeId)
                    .HasConstraintName("FK_PsStudentDemographic_RefTuitionResidencyType");
            });

            modelBuilder.Entity<PsStudentEmployment>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentEmployment");

                entity.ToTable("PsStudentEmployment", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.EmploymentNaicsCode).HasColumnType("nchar(6)");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentEmployment)
                    .HasForeignKey<PsStudentEmployment>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentEmployment_OrganizationPersonRole");

                entity.HasOne(d => d.RefEmployedAfterExit)
                    .WithMany(p => p.PsStudentEmployment)
                    .HasForeignKey(d => d.RefEmployedAfterExitId)
                    .HasConstraintName("FK_PsStudentEmployment_RefEmployedAfterExit");

                entity.HasOne(d => d.RefEmployedWhileEnrolled)
                    .WithMany(p => p.PsStudentEmployment)
                    .HasForeignKey(d => d.RefEmployedWhileEnrolledId)
                    .HasConstraintName("FK_PsStudentEmployment_RefEmployedWhileEnrolled");

                entity.HasOne(d => d.RefEmploymentStatusWhileEnrolled)
                    .WithMany(p => p.PsStudentEmployment)
                    .HasForeignKey(d => d.RefEmploymentStatusWhileEnrolledId)
                    .HasConstraintName("FK_PsStudentEmployment_RefEmploymentStatusWhileEnrolled");
            });

            modelBuilder.Entity<PsStudentEnrollment>(entity =>
            {
                entity.ToTable("PsStudentEnrollment", "dbo");

                entity.Property(e => e.PsstudentEnrollmentId).HasColumnName("PSStudentEnrollmentId");

                entity.Property(e => e.DoctoralCandidacyDate).HasColumnType("date");

                entity.Property(e => e.DoctoralExamTakenDate).HasColumnType("date");

                entity.Property(e => e.EntryDateIntoPostsecondary).HasColumnType("date");

                entity.Property(e => e.InitialEnrollmentTerm).HasMaxLength(30);

                entity.Property(e => e.InstructionalActivityHoursAttempted).HasColumnType("decimal");

                entity.Property(e => e.InstructionalActivityHoursCompleted).HasColumnType("decimal");

                entity.Property(e => e.OralDefenseDate).HasColumnType("date");

                entity.Property(e => e.ThesisOrDissertationTitle).HasMaxLength(300);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentEnrollment_OrganizationPersonRole");

                entity.HasOne(d => d.RefDevelopmentalEducationReferralStatus)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefDevelopmentalEducationReferralStatusId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefDevelopmentalEducationReferralStatus");

                entity.HasOne(d => d.RefDevelopmentalEducationType)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefDevelopmentalEducationTypeId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefDevelopmentalEducationType");

                entity.HasOne(d => d.RefDistanceEducationCourseEnrollment)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefDistanceEducationCourseEnrollmentId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefDistanceEducationCourseEnr");

                entity.HasOne(d => d.RefDoctoralExamsRequiredCode)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefDoctoralExamsRequiredCodeId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefDoctoralExamsRequiredCode");

                entity.HasOne(d => d.RefGraduateOrDoctoralExamResultsStatus)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefGraduateOrDoctoralExamResultsStatusId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefGraduateOrDoctoralExamResultsStatus");

                entity.HasOne(d => d.RefInstructionalActivityHours)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefInstructionalActivityHoursId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefInstructionalActivityHours");

                entity.HasOne(d => d.RefPsEnrollmentAwardType)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefPsEnrollmentAwardTypeId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefPsEnrollmentAwardType");

                entity.HasOne(d => d.RefPsEnrollmentStatus)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefPsEnrollmentStatusId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefPsEnrollmentStatus");

                entity.HasOne(d => d.RefPsEnrollmentType)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefPsEnrollmentTypeId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefPsEnrollmentType");

                entity.HasOne(d => d.RefPsStudentLevel)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefPsStudentLevelId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefPsStudentLevel");

                entity.HasOne(d => d.RefTransferReady)
                    .WithMany(p => p.PsStudentEnrollment)
                    .HasForeignKey(d => d.RefTransferReadyId)
                    .HasConstraintName("FK_PsStudentEnrollment_RefTransferReady");
            });

            modelBuilder.Entity<PsStudentFinancialAid>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentFinancialAid");

                entity.ToTable("PsStudentFinancialAid", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.FinancialAidIncomeLevel).HasColumnType("decimal");

                entity.Property(e => e.FinancialNeed).HasColumnType("decimal");

                entity.Property(e => e.TitleIvparticipantAndRecipient).HasColumnName("TitleIVParticipantAndRecipient");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentFinancialAid)
                    .HasForeignKey<PsStudentFinancialAid>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentFinancialAid_OrganizationPersonRole");

                entity.HasOne(d => d.RefFinancialAidVeteransBenefitStatus)
                    .WithMany(p => p.PsStudentFinancialAid)
                    .HasForeignKey(d => d.RefFinancialAidVeteransBenefitStatusId)
                    .HasConstraintName("FK_PsStudentFinancialAid_RefFinancialAidVeteransBenefitStatus");

                entity.HasOne(d => d.RefFinancialAidVeteransBenefitType)
                    .WithMany(p => p.PsStudentFinancialAid)
                    .HasForeignKey(d => d.RefFinancialAidVeteransBenefitTypeId)
                    .HasConstraintName("FK_PsStudentFinancialAid_RefFinancialAidVeteransBenefitType");

                entity.HasOne(d => d.RefNeedDeterminationMethod)
                    .WithMany(p => p.PsStudentFinancialAid)
                    .HasForeignKey(d => d.RefNeedDeterminationMethodId)
                    .HasConstraintName("FK_PsStudentFinancialAid_RefNeedDeterminationMethod");
            });

            modelBuilder.Entity<PsStudentSection>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_PsStudentSection");

                entity.ToTable("PsStudentSection", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedOnAdd();

                entity.Property(e => e.AcademicGrade).HasMaxLength(15);

                entity.Property(e => e.CourseOverrideSchool).HasMaxLength(80);

                entity.Property(e => e.NumberOfCreditsEarned).HasColumnType("decimal");

                entity.Property(e => e.QualityPointsEarned).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.PsStudentSection)
                    .HasForeignKey<PsStudentSection>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PsStudentSection_OrganizationPersonRole");

                entity.HasOne(d => d.RefCourseAcademicGradeStatusCode)
                    .WithMany(p => p.PsStudentSection)
                    .HasForeignKey(d => d.RefCourseAcademicGradeStatusCodeId)
                    .HasConstraintName("FK_PsStudentSection_RefCourseAcademicGradeStatusCode");

                entity.HasOne(d => d.RefCourseRepeatCode)
                    .WithMany(p => p.PsStudentSection)
                    .HasForeignKey(d => d.RefCourseRepeatCodeId)
                    .HasConstraintName("FK_PsStudentSection_RefCourseRepeatCode");
            });

            modelBuilder.Entity<PsstudentProgram>(entity =>
            {
                entity.ToTable("PSStudentProgram", "dbo");

                entity.Property(e => e.PsstudentProgramId).HasColumnName("PSStudentProgramId");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.PsstudentProgram)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PSStudentProgram_OrganizationPersonRole");

                entity.HasOne(d => d.PsProgram)
                    .WithMany(p => p.PsstudentProgram)
                    .HasForeignKey(d => d.PsProgramId)
                    .HasConstraintName("FK_PSStudentProgram_PsProgram");

                entity.HasOne(d => d.RefCipUse)
                    .WithMany(p => p.PsstudentProgram)
                    .HasForeignKey(d => d.RefCipUseId)
                    .HasConstraintName("FK_PSStudentEnrollmentCIP_RefCipUse");

                entity.HasOne(d => d.RefTransferOutIndicator)
                    .WithMany(p => p.PsstudentProgram)
                    .HasForeignKey(d => d.RefTransferOutIndicatorId)
                    .HasConstraintName("FK_PSStudentProgram_RefTransferOutIndicator");

                entity.HasOne(d => d.RefWorkbasedLearningOpportunityType)
                    .WithMany(p => p.PsstudentProgram)
                    .HasForeignKey(d => d.RefWorkbasedLearningOpportunityTypeId)
                    .HasConstraintName("FK_PsStudentProgram_RefWorkbasedLearningOpportunityType");
            });

            modelBuilder.Entity<QuarterlyEmploymentRecord>(entity =>
            {
                entity.ToTable("QuarterlyEmploymentRecord", "dbo");

                entity.Property(e => e.Earnings).HasColumnType("decimal");

                entity.Property(e => e.EmploymentNaicscode)
                    .HasColumnName("EmploymentNAICSCode")
                    .HasMaxLength(50);

                entity.Property(e => e.RefEradministrativeDataSourceId).HasColumnName("RefERAdministrativeDataSourceId");

                entity.Property(e => e.ReferencePeriodEndDate).HasColumnType("date");

                entity.Property(e => e.ReferencePeriodStartDate).HasColumnType("date");

                entity.HasOne(d => d.Person)
                    .WithMany(p => p.QuarterlyEmploymentRecord)
                    .HasForeignKey(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_QuarterlyEmploymentRecord_Person");

                entity.HasOne(d => d.RefEmployedPriorToEnrollment)
                    .WithMany(p => p.QuarterlyEmploymentRecord)
                    .HasForeignKey(d => d.RefEmployedPriorToEnrollmentId)
                    .HasConstraintName("FK_QuarterlyEmploymentRecord_RefEmployedPriorToEnrollment");

                entity.HasOne(d => d.RefEmploymentLocation)
                    .WithMany(p => p.QuarterlyEmploymentRecord)
                    .HasForeignKey(d => d.RefEmploymentLocationId)
                    .HasConstraintName("FK_QuarterlyEmploymentRecord_RefEmploymentLocation");

                entity.HasOne(d => d.RefEradministrativeDataSource)
                    .WithMany(p => p.QuarterlyEmploymentRecord)
                    .HasForeignKey(d => d.RefEradministrativeDataSourceId)
                    .HasConstraintName("FK_QuarterlyEmploymentRecord_RefERAdministrativeDataSource");
            });

            modelBuilder.Entity<RefAbsentAttendanceCategory>(entity =>
            {
                entity.ToTable("RefAbsentAttendanceCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAbsentAttendanceCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAbsentAttendanceCategory_Organization");
            });

            modelBuilder.Entity<RefAcademicAwardLevel>(entity =>
            {
                entity.ToTable("RefAcademicAwardLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAcademicAwardLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAcademicAwardLevel_Organization");
            });

            modelBuilder.Entity<RefAcademicHonorType>(entity =>
            {
                entity.ToTable("RefAcademicHonorType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAcademicHonorType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAcademicHonorType_Organization");
            });

            modelBuilder.Entity<RefAcademicRank>(entity =>
            {
                entity.ToTable("RefAcademicRank", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAcademicRank)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAcademicRank_Organization");
            });

            modelBuilder.Entity<RefAcademicSubject>(entity =>
            {
                entity.ToTable("RefAcademicSubject", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAcademicSubject)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAcademicSubject_Organization");
            });

            modelBuilder.Entity<RefAcademicTermDesignator>(entity =>
            {
                entity.ToTable("RefAcademicTermDesignator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAcademicTermDesignator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAcademicTermDesignator_Organization");
            });

            modelBuilder.Entity<RefAccommodationsNeededType>(entity =>
            {
                entity.ToTable("RefAccommodationsNeededType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAccommodationsNeededType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAccommodationsNeededType_Organization");
            });

            modelBuilder.Entity<RefAccreditationAgency>(entity =>
            {
                entity.ToTable("RefAccreditationAgency", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAccreditationAgency)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAccreditationAgency_Organization");
            });

            modelBuilder.Entity<RefActivityRecognitionType>(entity =>
            {
                entity.ToTable("RefActivityRecognitionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefActivityRecognitionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefActivityRecognitionType_Organization");
            });

            modelBuilder.Entity<RefActivityTimeMeasurementType>(entity =>
            {
                entity.ToTable("RefActivityTimeMeasurementType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefActivityTimeMeasurementType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefActivityTimeMeasurementType_Organization");
            });

            modelBuilder.Entity<RefAdditionalCreditType>(entity =>
            {
                entity.ToTable("RefAdditionalCreditType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdditionalCreditType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdditionalCreditType_Organization");
            });

            modelBuilder.Entity<RefAdditionalTargetedSupport>(entity =>
            {
                entity.ToTable("RefAdditionalTargetedSupport", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdditionalTargetedSupport)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdditionalTargetedSupport_Org");
            });

            modelBuilder.Entity<RefAddressType>(entity =>
            {
                entity.ToTable("RefAddressType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAddressType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAddressType_Organization");
            });

            modelBuilder.Entity<RefAdministrativeFundingControl>(entity =>
            {
                entity.ToTable("RefAdministrativeFundingControl", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdministrativeFundingControl)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdminFundingControl_Organization");
            });

            modelBuilder.Entity<RefAdmissionConsiderationLevel>(entity =>
            {
                entity.ToTable("RefAdmissionConsiderationLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdmissionConsiderationLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdmissionConsiderationLevel_Organization");
            });

            modelBuilder.Entity<RefAdmissionConsiderationType>(entity =>
            {
                entity.ToTable("RefAdmissionConsiderationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(150);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdmissionConsiderationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdmissionConsiderationType_Organization");
            });

            modelBuilder.Entity<RefAdmittedStudent>(entity =>
            {
                entity.ToTable("RefAdmittedStudent", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdmittedStudent)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdmittedStudent_Organization");
            });

            modelBuilder.Entity<RefAdvancedPlacementCourseCode>(entity =>
            {
                entity.ToTable("RefAdvancedPlacementCourseCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAdvancedPlacementCourseCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAdvancedPlacementCourseCode_Organization");
            });

            modelBuilder.Entity<RefAeCertificationType>(entity =>
            {
                entity.ToTable("RefAeCertificationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeCertificationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAECertificationType_Organization");
            });

            modelBuilder.Entity<RefAeFunctioningLevelAtIntake>(entity =>
            {
                entity.ToTable("RefAeFunctioningLevelAtIntake", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeFunctioningLevelAtIntake)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAEFunctioningLevelAtIntake_Organization");
            });

            modelBuilder.Entity<RefAeFunctioningLevelAtPosttest>(entity =>
            {
                entity.ToTable("RefAeFunctioningLevelAtPosttest", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeFunctioningLevelAtPosttest)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAEFunctioningLevelAtPosttest_Organization");
            });

            modelBuilder.Entity<RefAeInstructionalProgramType>(entity =>
            {
                entity.ToTable("RefAeInstructionalProgramType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeInstructionalProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAEInstructionalProgramType_Organization");
            });

            modelBuilder.Entity<RefAePostsecondaryTransitionAction>(entity =>
            {
                entity.ToTable("RefAePostsecondaryTransitionAction", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAePostsecondaryTransitionAction)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAEPostsecondaryTransitionAction_Organization");
            });

            modelBuilder.Entity<RefAeSpecialProgramType>(entity =>
            {
                entity.ToTable("RefAeSpecialProgramType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeSpecialProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAeSpecialProgramType_Organization");
            });

            modelBuilder.Entity<RefAeStaffClassification>(entity =>
            {
                entity.ToTable("RefAeStaffClassification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeStaffClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAEStaffClassification_Organization");
            });

            modelBuilder.Entity<RefAeStaffEmploymentStatus>(entity =>
            {
                entity.ToTable("RefAeStaffEmploymentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAeStaffEmploymentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAeStaffEmploymentStatus_Organization");
            });

            modelBuilder.Entity<RefAllergySeverity>(entity =>
            {
                entity.ToTable("RefAllergySeverity", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAllergySeverity)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAllergySeverity_Organization");
            });

            modelBuilder.Entity<RefAllergyType>(entity =>
            {
                entity.ToTable("RefAllergyType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAllergyType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAllergyType_Organization");
            });

            modelBuilder.Entity<RefAltRouteToCertificationOrLicensure>(entity =>
            {
                entity.ToTable("RefAltRouteToCertificationOrLicensure", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAltRouteToCertificationOrLicensure)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAltRouteToCertificationOrLicensure_Organization");
            });

            modelBuilder.Entity<RefAlternateFundUses>(entity =>
            {
                entity.ToTable("RefAlternateFundUses", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAlternateFundUses)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAlternateFundUses_Organization");
            });

            modelBuilder.Entity<RefAlternativeSchoolFocus>(entity =>
            {
                entity.ToTable("RefAlternativeSchoolFocus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAlternativeSchoolFocus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAlternativeSchoolFocus_Organization");
            });

            modelBuilder.Entity<RefAmaoAttainmentStatus>(entity =>
            {
                entity.ToTable("RefAmaoAttainmentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAmaoAttainmentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAmaoAttainmentStatus_Organization");
            });

            modelBuilder.Entity<RefApipInteractionType>(entity =>
            {
                entity.ToTable("RefApipInteractionType", "dbo");

                entity.Property(e => e.RefApipinteractionTypeId).HasColumnName("RefAPIPInteractionTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefApipInteractionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAPIPInteractionType_Organization");
            });

            modelBuilder.Entity<RefAssessmentAccommodationCategory>(entity =>
            {
                entity.ToTable("RefAssessmentAccommodationCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");
            });

            modelBuilder.Entity<RefAssessmentAccommodationType>(entity =>
            {
                entity.ToTable("RefAssessmentAccommodationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentAccommodationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentAccommodationType_Organization");
            });

            modelBuilder.Entity<RefAssessmentAssetIdentifierType>(entity =>
            {
                entity.ToTable("RefAssessmentAssetIdentifierType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentAssetIdentifierType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentAssetIdentifierType_Organization");
            });

            modelBuilder.Entity<RefAssessmentAssetType>(entity =>
            {
                entity.ToTable("RefAssessmentAssetType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentAssetType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentAssetType_Organization");
            });

            modelBuilder.Entity<RefAssessmentEldevelopmentalDomain>(entity =>
            {
                entity.ToTable("RefAssessmentELDevelopmentalDomain", "dbo");

                entity.Property(e => e.RefAssessmentEldevelopmentalDomainId).HasColumnName("RefAssessmentELDevelopmentalDomainId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentEldevelopmentalDomain)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentELDevelopmentalDomain_Organization");
            });

            modelBuilder.Entity<RefAssessmentFormSectionIdentificationSystem>(entity =>
            {
                entity.ToTable("RefAssessmentFormSectionIdentificationSystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentFormSectionIdentificationSystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentFormSectionIDType_Organization");
            });

            modelBuilder.Entity<RefAssessmentItemCharacteristicType>(entity =>
            {
                entity.ToTable("RefAssessmentItemCharacteristicType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentItemCharacteristicType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessItemCharType_Organization");
            });

            modelBuilder.Entity<RefAssessmentItemResponseScoreStatus>(entity =>
            {
                entity.ToTable("RefAssessmentItemResponseScoreStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentItemResponseScoreStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentItemResponseScoreStatus_Organization");
            });

            modelBuilder.Entity<RefAssessmentItemResponseStatus>(entity =>
            {
                entity.ToTable("RefAssessmentItemResponseStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentItemResponseStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessItemResponseStatus_Organization");
            });

            modelBuilder.Entity<RefAssessmentItemType>(entity =>
            {
                entity.ToTable("RefAssessmentItemType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentItemType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentItemType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedAlternativeRepresentationType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedAlternativeRepresentationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedAlternativeRepresentationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedAlternativeRepresentationType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedBrailleGradeType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedBrailleGradeType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedBrailleGradeType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedBrailleGradeTypeId_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedBrailleMarkType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedBrailleMarkType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedBrailleMarkType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedBrailleMarkType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedBrailleStatusCellType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedBrailleStatusCellType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedBrailleStatusCellType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedBrailleStatusCellType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedHazardType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedHazardType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedHazardType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedHazardType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedIncreasedWhitespacingType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedIncreasedWhitespacingType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedIncreasedWhitespacingType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedIncreasedWhitespacingType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedLanguageLearnerType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedLanguageLearnerType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedLanguageLearnerType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedLanguageLearnerType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedMaskingType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedMaskingType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedMaskingType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedMaskingType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedNumberOfBrailleDots>(entity =>
            {
                entity.ToTable("RefAssessmentNeedNumberOfBrailleDots", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedNumberOfBrailleDots)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedNumberOfBrailleDots_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedSigningType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedSigningType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedSigningType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedSigningType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedSpokenSourcePreferenceType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedSpokenSourcePreferenceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedSpokenSourcePreferenceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedSpokenSourcePreferenceType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedSupportTool>(entity =>
            {
                entity.ToTable("RefAssessmentNeedSupportTool", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedSupportTool)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedSupportTool_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedUsageType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedUsageType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedUsageType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedUsageType_Organization");
            });

            modelBuilder.Entity<RefAssessmentNeedUserSpokenPreferenceType>(entity =>
            {
                entity.ToTable("RefAssessmentNeedUserSpokenPreferenceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentNeedUserSpokenPreferenceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentNeedUserSpokenPreferenceType_Organization");
            });

            modelBuilder.Entity<RefAssessmentParticipationIndicator>(entity =>
            {
                entity.ToTable("RefAssessmentParticipationIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentParticipationIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentParticipationIndicator_Organization");
            });

            modelBuilder.Entity<RefAssessmentPlatformType>(entity =>
            {
                entity.ToTable("RefAssessmentPlatformType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentPlatformType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentPlatformType_Organization");
            });

            modelBuilder.Entity<RefAssessmentPretestOutcome>(entity =>
            {
                entity.ToTable("RefAssessmentPretestOutcome", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentPretestOutcome)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentSubtestResultPretestOutcome_Organization");
            });

            modelBuilder.Entity<RefAssessmentPurpose>(entity =>
            {
                entity.ToTable("RefAssessmentPurpose", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentPurpose)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentPurpose_Organization");
            });

            modelBuilder.Entity<RefAssessmentReasonNotCompleting>(entity =>
            {
                entity.ToTable("RefAssessmentReasonNotCompleting", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentReasonNotCompleting)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentReasonNotCompleting_Organization");
            });

            modelBuilder.Entity<RefAssessmentReasonNotTested>(entity =>
            {
                entity.ToTable("RefAssessmentReasonNotTested", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentReasonNotTested)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentReasonNotTested_Organization");
            });

            modelBuilder.Entity<RefAssessmentRegistrationCompletionStatus>(entity =>
            {
                entity.ToTable("RefAssessmentRegistrationCompletionStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentRegistrationCompletionStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentRegistrationCompletionStatus_Organization");
            });

            modelBuilder.Entity<RefAssessmentReportingMethod>(entity =>
            {
                entity.ToTable("RefAssessmentReportingMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentReportingMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentReportingMethod_Organization");
            });

            modelBuilder.Entity<RefAssessmentResultDataType>(entity =>
            {
                entity.ToTable("RefAssessmentResultDataType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentResultDataType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentResultDataType_Organization");
            });

            modelBuilder.Entity<RefAssessmentResultScoreType>(entity =>
            {
                entity.ToTable("RefAssessmentResultScoreType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(150);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentResultScoreType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentResultScoreType_Organization");
            });

            modelBuilder.Entity<RefAssessmentSessionSpecialCircumstanceType>(entity =>
            {
                entity.ToTable("RefAssessmentSessionSpecialCircumstanceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentSessionSpecialCircumstanceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentSessionSpecialCircumstanceType_Organization");
            });

            modelBuilder.Entity<RefAssessmentSessionStaffRoleType>(entity =>
            {
                entity.ToTable("RefAssessmentSessionStaffRoleType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentSessionStaffRoleType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentSessionStaffRoleType_Organization");
            });

            modelBuilder.Entity<RefAssessmentSessionType>(entity =>
            {
                entity.ToTable("RefAssessmentSessionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentSessionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentSessionType_Organization");
            });

            modelBuilder.Entity<RefAssessmentSubtestIdentifierType>(entity =>
            {
                entity.ToTable("RefAssessmentSubtestIdentifierType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentSubtestIdentifierType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessSubtestIDType_Organization");
            });

            modelBuilder.Entity<RefAssessmentType>(entity =>
            {
                entity.ToTable("RefAssessmentType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentType_Organization");
            });

            modelBuilder.Entity<RefAssessmentTypeChildrenWithDisabilities>(entity =>
            {
                entity.ToTable("RefAssessmentTypeChildrenWithDisabilities", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAssessmentTypeChildrenWithDisabilities)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssessmentTypeChildrenWithDisabilities_Organization");
            });

            modelBuilder.Entity<RefAttendanceEventType>(entity =>
            {
                entity.ToTable("RefAttendanceEventType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAttendanceEventType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAttendanceEventType_Organization");
            });

            modelBuilder.Entity<RefAttendanceStatus>(entity =>
            {
                entity.ToTable("RefAttendanceStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAttendanceStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAttendanceStatus_Organization");
            });

            modelBuilder.Entity<RefAypStatus>(entity =>
            {
                entity.ToTable("RefAypStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefAypStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAYPStatus_Organization");
            });

            modelBuilder.Entity<RefBarrierToEducatingHomeless>(entity =>
            {
                entity.ToTable("RefBarrierToEducatingHomeless", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefBarrierToEducatingHomeless)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefBarrierToEducatingHomeless_Organization");
            });

            modelBuilder.Entity<RefBillableBasisType>(entity =>
            {
                entity.ToTable("RefBillableBasisType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefBillableBasisType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefBillableBasisType_Organization");
            });

            modelBuilder.Entity<RefBlendedLearningModelType>(entity =>
            {
                entity.ToTable("RefBlendedLearningModelType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefBlendedLearningModelType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefBlendedLearningModelType_Organization");
            });

            modelBuilder.Entity<RefBloomsTaxonomyDomain>(entity =>
            {
                entity.ToTable("RefBloomsTaxonomyDomain", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefBloomsTaxonomyDomain)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefBloomsTaxonomyDomain_Organization");
            });

            modelBuilder.Entity<RefBuildingUseType>(entity =>
            {
                entity.ToTable("RefBuildingUseType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefBuildingUseType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefBuildingUseType_Organization");
            });

            modelBuilder.Entity<RefCalendarEventType>(entity =>
            {
                entity.ToTable("RefCalendarEventType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCalendarEventType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCalendarEventType_Organization");
            });

            modelBuilder.Entity<RefCampusResidencyType>(entity =>
            {
                entity.ToTable("RefCampusResidencyType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCampusResidencyType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCampusResidencyType_Organization");
            });

            modelBuilder.Entity<RefCareerCluster>(entity =>
            {
                entity.ToTable("RefCareerCluster", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCareerCluster)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCareerCluster_Organization");
            });

            modelBuilder.Entity<RefCareerEducationPlanType>(entity =>
            {
                entity.ToTable("RefCareerEducationPlanType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCareerEducationPlanType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCareerEducationPlanType_Organization");
            });

            modelBuilder.Entity<RefCarnegieBasicClassification>(entity =>
            {
                entity.ToTable("RefCarnegieBasicClassification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCarnegieBasicClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCarnegieBasicClassification_Organization");
            });

            modelBuilder.Entity<RefCharterSchoolAuthorizerType>(entity =>
            {
                entity.ToTable("RefCharterSchoolAuthorizerType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCharterSchoolAuthorizerType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCharterSchoolAuthorizerType_Organization");
            });

            modelBuilder.Entity<RefCharterSchoolManagementOrganizationType>(entity =>
            {
                entity.ToTable("RefCharterSchoolManagementOrganizationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCharterSchoolManagementOrganizationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCharterSchoolManagementOrganizationType_Organization");

            });

            modelBuilder.Entity<K12CharterSchoolManagementOrganization>(entity =>
            {
                entity.HasKey(e => e.K12CharterSchoolManagementOrganizationId)
                  .HasName("PK_K12CharterSchoolManagementOrganization");
                entity.ToTable("K12CharterSchoolManagementOrganization", "dbo");

                entity.HasOne(a => a.RefCharterSchoolManagementOrganizationType)
                      .WithMany(a => a.K12CharterSchoolManagementOrganization)
                      .HasForeignKey(a => a.RefCharterSchoolManagementOrganizationTypeId)
                      .HasConstraintName("FK_K12CharterSchoolManagementOrganization_Organization");

                entity.HasOne(a => a.Organization)
                      .WithMany(a => a.K12CharterSchoolManagementOrganization)
                      .HasForeignKey(a => a.OrganizationId)
                      .HasConstraintName("FK_Organization_K12CharterSchoolManagementOrganization");

            });

            modelBuilder.Entity<K12CharterSchoolAuthorizer>(entity =>
            {
                entity.HasKey(e => e.K12CharterSchoolAuthorizerId)
                     .HasName("PK_K12CharterSchoolAuthorizer");

                entity.ToTable("K12CharterSchoolAuthorizer", "dbo");

                entity.HasOne(a => a.RefCharterSchoolAuthorizerType)
                      .WithMany(a => a.K12CharterSchoolAuthorizer)
                      .HasForeignKey(a => a.RefCharterSchoolAuthorizerTypeId)
                      .HasConstraintName("FK_K12CharterSchoolAuthorizer_Organization");

                entity.HasOne(a => a.Organization)
                    .WithMany(a => a.K12CharterSchoolAuthorizer)
                    .HasForeignKey(a => a.OrganizationId)
                    .HasConstraintName("FK_Organization_K12CharterSchoolAuthorizer");
            });

            modelBuilder.Entity<RefCharterSchoolType>(entity =>
            {
                entity.ToTable("RefCharterSchoolType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCharterSchoolType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCharterSchoolType_Organization");
            });

            modelBuilder.Entity<RefChildDevelopmentAssociateType>(entity =>
            {
                entity.ToTable("RefChildDevelopmentAssociateType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefChildDevelopmentAssociateType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefChildDevAssociateType_Organization");
            });

            modelBuilder.Entity<RefChildDevelopmentalScreeningStatus>(entity =>
            {
                entity.ToTable("RefChildDevelopmentalScreeningStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefChildDevelopmentalScreeningStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefChildDevelopmentalScreeningStatus_Organization");
            });

            modelBuilder.Entity<RefChildOutcomesSummaryRating>(entity =>
            {
                entity.ToTable("RefChildOutcomesSummaryRating", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefChildOutcomesSummaryRating)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefChildOutcomesSummaryRating_Organization");
            });

            modelBuilder.Entity<RefCipCode>(entity =>
            {
                entity.ToTable("RefCipCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCipCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCipCode_Organization");
            });

            modelBuilder.Entity<RefCipUse>(entity =>
            {
                entity.ToTable("RefCipUse", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCipUse)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCipUse_Organization");
            });

            modelBuilder.Entity<RefCipVersion>(entity =>
            {
                entity.ToTable("RefCipVersion", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCipVersion)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCipVersion_Organization");
            });

            modelBuilder.Entity<RefClassroomPositionType>(entity =>
            {
                entity.ToTable("RefClassroomPositionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefClassroomPositionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefClassroomPositionType_Organization");
            });

            modelBuilder.Entity<RefCohortExclusion>(entity =>
            {
                entity.ToTable("RefCohortExclusion", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCohortExclusion)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCohortExclusion_Organization");
            });

            modelBuilder.Entity<RefCommunicationMethod>(entity =>
            {
                entity.ToTable("RefCommunicationMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCommunicationMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCommunicationMethod_Organization");
            });

            modelBuilder.Entity<RefCommunityBasedType>(entity =>
            {
                entity.ToTable("RefCommunityBasedType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCommunityBasedType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCommunityBasedType_Organization");
            });

			modelBuilder.Entity<RefComprehensiveSupport>(entity =>
			{
				entity.ToTable("RefComprehensiveSupport", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefComprehensiveSupport)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefComprehensiveSupport_Org");
			});

			modelBuilder.Entity<RefComprehensiveAndTargetedSupport>(entity =>
			{
				entity.ToTable("RefComprehensiveAndTargetedSupport", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefComprehensiveAndTargetedSupport)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefComprehensiveAndTargetedSupport_Org");
			});

            modelBuilder.Entity<RefComprehensiveSupportImprovement>(entity =>
            {
                entity.ToTable("RefComprehensiveSupportImprovement", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefComprehensiveSupportImprovement)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefComprehensiveSupportImprovement_Org");
            });           

            modelBuilder.Entity<RefCompetencySetCompletionCriteria>(entity =>
            {
                entity.ToTable("RefCompetencySetCompletionCriteria", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCompetencySetCompletionCriteria)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCompetencySetCompletionCriteria_Organization");
            });

            modelBuilder.Entity<RefContentStandardType>(entity =>
            {
                entity.ToTable("RefContentStandardType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefContentStandardType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefContentStandardType_Organization");
            });

            modelBuilder.Entity<RefContinuationOfServices>(entity =>
            {
                entity.HasKey(e => e.RefContinuationOfServicesReasonId)
                    .HasName("PK_RefContinuationOfServices");

                entity.ToTable("RefContinuationOfServices", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefContinuationOfServices)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefContinuationOfServices_Organization");
            });

            modelBuilder.Entity<RefControlOfInstitution>(entity =>
            {
                entity.ToTable("RefControlOfInstitution", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefControlOfInstitution)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefControlOfInstitution_Organization");
            });

            modelBuilder.Entity<RefCoreKnowledgeArea>(entity =>
            {
                entity.ToTable("RefCoreKnowledgeArea", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCoreKnowledgeArea)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCoreKnowledgeArea_Organization");
            });

            modelBuilder.Entity<RefCorrectionalEducationFacilityType>(entity =>
            {
                entity.ToTable("RefCorrectionalEducationFacilityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCorrectionalEducationFacilityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCorrectionalEducationFacilityType_Organization");
            });

            modelBuilder.Entity<RefCorrectiveActionType>(entity =>
            {
                entity.HasKey(e => e.RefCorrectiveActionId)
                    .HasName("PK_RefCorrectiveAction");

                entity.ToTable("RefCorrectiveActionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCorrectiveActionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCorrectiveActionType_Organization");
            });

            modelBuilder.Entity<RefCountry>(entity =>
            {
                entity.ToTable("RefCountry", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCountry)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCountry_Org");
            });

            modelBuilder.Entity<RefCounty>(entity =>
            {
                entity.ToTable("RefCounty", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCounty)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCounty_Org");
            });

            modelBuilder.Entity<RefCourseAcademicGradeStatusCode>(entity =>
            {
                entity.ToTable("RefCourseAcademicGradeStatusCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseAcademicGradeStatusCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseAcademicGradeStatusCode_Organization");
            });

            modelBuilder.Entity<RefCourseApplicableEducationLevel>(entity =>
            {
                entity.ToTable("RefCourseApplicableEducationLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseApplicableEducationLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseApplicableEducationLevel_Organization");
            });

            modelBuilder.Entity<RefCourseCreditBasisType>(entity =>
            {
                entity.ToTable("RefCourseCreditBasisType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseCreditBasisType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseCreditBasisType_Organization");
            });

            modelBuilder.Entity<RefCourseCreditLevelType>(entity =>
            {
                entity.ToTable("RefCourseCreditLevelType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseCreditLevelType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseCreditLevelType_Organization");
            });

            modelBuilder.Entity<RefCourseCreditUnit>(entity =>
            {
                entity.ToTable("RefCourseCreditUnit", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseCreditUnit)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseCreditUnit_Organization");
            });

            modelBuilder.Entity<RefCourseGpaApplicability>(entity =>
            {
                entity.ToTable("RefCourseGpaApplicability", "dbo");

                entity.Property(e => e.RefCourseGpaapplicabilityId).HasColumnName("RefCourseGPAApplicabilityId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseGpaApplicability)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseGpaApplicability_Organization");
            });

            modelBuilder.Entity<RefCourseHonorsType>(entity =>
            {
                entity.ToTable("RefCourseHonorsType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseHonorsType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseHonorsType_Organization");
            });

            modelBuilder.Entity<RefCourseInstructionMethod>(entity =>
            {
                entity.ToTable("RefCourseInstructionMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseInstructionMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseInstructionMethod_Organization");
            });

            modelBuilder.Entity<RefCourseInstructionSiteType>(entity =>
            {
                entity.ToTable("RefCourseInstructionSiteType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseInstructionSiteType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseInstructionSiteType_Organization");
            });

            modelBuilder.Entity<RefCourseInteractionMode>(entity =>
            {
                entity.ToTable("RefCourseInteractionMode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseInteractionMode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseInteractionMode_Organization");
            });

            modelBuilder.Entity<RefCourseLevelCharacteristic>(entity =>
            {
                entity.ToTable("RefCourseLevelCharacteristic", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseLevelCharacteristic)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseLevelCharacteristic_Organization");
            });

            modelBuilder.Entity<RefCourseLevelType>(entity =>
            {
                entity.ToTable("RefCourseLevelType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseLevelType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseLevelType_Organization");
            });

            modelBuilder.Entity<RefCourseRepeatCode>(entity =>
            {
                entity.ToTable("RefCourseRepeatCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseRepeatCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseRepeatCode_Organization");
            });

            modelBuilder.Entity<RefCourseSectionAssessmentReportingMethod>(entity =>
            {
                entity.ToTable("RefCourseSectionAssessmentReportingMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseSectionAssessmentReportingMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseSectionAssessmentReportingMethod_Organization");
            });

            modelBuilder.Entity<RefCourseSectionDeliveryMode>(entity =>
            {
                entity.ToTable("RefCourseSectionDeliveryMode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseSectionDeliveryMode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseSectionDeliveryMode_Organization");
            });

            modelBuilder.Entity<RefCourseSectionEnrollmentStatusType>(entity =>
            {
                entity.ToTable("RefCourseSectionEnrollmentStatusType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseSectionEnrollmentStatusType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseSectionEnrollmentStatusType_Organization");
            });

            modelBuilder.Entity<RefCourseSectionEntryType>(entity =>
            {
                entity.ToTable("RefCourseSectionEntryType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseSectionEntryType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseSectionEntryType_Organization");
            });

            modelBuilder.Entity<RefCourseSectionExitType>(entity =>
            {
                entity.ToTable("RefCourseSectionExitType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCourseSectionExitType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCourseSectionExitType_Organization");
            });

            modelBuilder.Entity<RefCredentialType>(entity =>
            {
                entity.ToTable("RefCredentialType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCredentialType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCredentialType_Organization");
            });

            modelBuilder.Entity<RefCreditHoursAppliedOtherProgram>(entity =>
            {
                entity.ToTable("RefCreditHoursAppliedOtherProgram", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCreditHoursAppliedOtherProgram)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCreditHoursAppliedOtherProgram_Organization");
            });

            modelBuilder.Entity<RefCreditTypeEarned>(entity =>
            {
                entity.ToTable("RefCreditTypeEarned", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCreditTypeEarned)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCreditTypeEarned_Organization");
            });

            modelBuilder.Entity<RefCriticalTeacherShortageCandidate>(entity =>
            {
                entity.ToTable("RefCriticalTeacherShortageCandidate", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCriticalTeacherShortageCandidate)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCritTeachShortageCandidate_Organization");
            });

            modelBuilder.Entity<RefCteGraduationRateInclusion>(entity =>
            {
                entity.ToTable("RefCteGraduationRateInclusion", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCteGraduationRateInclusion)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCTEGraduationRateInclusion_Organization");
            });

            modelBuilder.Entity<RefCteNonTraditionalGenderStatus>(entity =>
            {
                entity.ToTable("RefCteNonTraditionalGenderStatus", "dbo");

                entity.Property(e => e.RefCtenonTraditionalGenderStatusId).HasColumnName("RefCTENonTraditionalGenderStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCteNonTraditionalGenderStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCteNonTraditionalGenderStatus_Organization");
            });

            modelBuilder.Entity<RefCurriculumFrameworkType>(entity =>
            {
                entity.ToTable("RefCurriculumFrameworkType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefCurriculumFrameworkType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefCurriculumFrameworkType_Organization");
            });

            modelBuilder.Entity<RefDegreeOrCertificateType>(entity =>
            {
                entity.ToTable("RefDegreeOrCertificateType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDegreeOrCertificateType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDegreeCertificateType_Organization");
            });

            modelBuilder.Entity<RefDentalInsuranceCoverageType>(entity =>
            {
                entity.ToTable("RefDentalInsuranceCoverageType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDentalInsuranceCoverageType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDentalInsuranceCoverageType_Organization");
            });

            modelBuilder.Entity<RefDentalScreeningStatus>(entity =>
            {
                entity.ToTable("RefDentalScreeningStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDentalScreeningStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDental_Org");
            });

            modelBuilder.Entity<RefDependencyStatus>(entity =>
            {
                entity.ToTable("RefDependencyStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDependencyStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDependencyStatus_Organization");
            });

            modelBuilder.Entity<RefDevelopmentalEducationReferralStatus>(entity =>
            {
                entity.ToTable("RefDevelopmentalEducationReferralStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDevelopmentalEducationReferralStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDevelopmentalEducationReferralStatus_Organization");
            });

            modelBuilder.Entity<RefDevelopmentalEducationType>(entity =>
            {
                entity.ToTable("RefDevelopmentalEducationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDevelopmentalEducationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDevelopmentalEducationType_Organization");
            });

            modelBuilder.Entity<RefDevelopmentalEvaluationFinding>(entity =>
            {
                entity.ToTable("RefDevelopmentalEvaluationFinding", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDevelopmentalEvaluationFinding)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDevelopmentalEvaluationFinding_Organization");
            });

            modelBuilder.Entity<RefDirectoryInformationBlockStatus>(entity =>
            {
                entity.ToTable("RefDirectoryInformationBlockStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDirectoryInformationBlockStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDirectoryInformationBlockStatus_Organization");
            });

            modelBuilder.Entity<RefDisabilityConditionStatusCode>(entity =>
            {
                entity.ToTable("RefDisabilityConditionStatusCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisabilityConditionStatusCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisabilityConditionStatusCode_Organization");
            });

            modelBuilder.Entity<RefDisabilityConditionType>(entity =>
            {
                entity.ToTable("RefDisabilityConditionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisabilityConditionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisabilityConditionType_Organization");
            });

            modelBuilder.Entity<RefDisabilityDeterminationSourceType>(entity =>
            {
                entity.ToTable("RefDisabilityDeterminationSourceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisabilityDeterminationSourceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisabilityDeterminationSourceType_Organization");
            });

            modelBuilder.Entity<RefDisabilityType>(entity =>
            {
                entity.ToTable("RefDisabilityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisabilityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisability_Organization");
            });

            modelBuilder.Entity<RefDisciplinaryActionTaken>(entity =>
            {
                entity.ToTable("RefDisciplinaryActionTaken", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisciplinaryActionTaken)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisciplinaryActionTaken_Organization");
            });

            modelBuilder.Entity<RefDisciplineLengthDifferenceReason>(entity =>
            {
                entity.ToTable("RefDisciplineLengthDifferenceReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisciplineLengthDifferenceReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisciplineLengthDifference_Organization");
            });

            modelBuilder.Entity<RefDisciplineMethodFirearms>(entity =>
            {
                entity.ToTable("RefDisciplineMethodFirearms", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisciplineMethodFirearms)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisciplineMethodFirearms_Organization");
            });

            modelBuilder.Entity<RefDisciplineMethodOfCwd>(entity =>
            {
                entity.ToTable("RefDisciplineMethodOfCwd", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisciplineMethodOfCwd)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisciplineMethodOfCWD_Organization");
            });

            modelBuilder.Entity<RefDisciplineReason>(entity =>
            {
                entity.ToTable("RefDisciplineReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDisciplineReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDisciplineReason_Organization");
            });

            modelBuilder.Entity<RefDistanceEducationCourseEnrollment>(entity =>
            {
                entity.ToTable("RefDistanceEducationCourseEnrollment", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDistanceEducationCourseEnrollment)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDistanceEducationCourseEnr_Organization");
            });

            modelBuilder.Entity<RefDoctoralExamsRequiredCode>(entity =>
            {
                entity.ToTable("RefDoctoralExamsRequiredCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDoctoralExamsRequiredCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDoctoralExamsRequiredCode_Organization");
            });

            modelBuilder.Entity<RefDqpcategoriesOfLearning>(entity =>
            {
                entity.ToTable("RefDQPCategoriesOfLearning", "dbo");

                entity.Property(e => e.RefDqpcategoriesOfLearningId).HasColumnName("RefDQPCategoriesOfLearningId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefDqpcategoriesOfLearning)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefDQPCategoriesOfLearning_Organization");
            });

            modelBuilder.Entity<RefEarlyChildhoodCredential>(entity =>
            {
                entity.ToTable("RefEarlyChildhoodCredential", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEarlyChildhoodCredential)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEarlyChildhoodCredential_Organization");
            });

            modelBuilder.Entity<RefEarlyChildhoodProgramEnrollmentType>(entity =>
            {
                entity.HasKey(e => e.RefEarlyChildhoodProgramTypeId)
                    .HasName("PK_RefEarlyLearningProgramType");

                entity.ToTable("RefEarlyChildhoodProgramEnrollmentType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEarlyChildhoodProgramEnrollmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEarlyChildhoodProgramType_Organization");
            });

            modelBuilder.Entity<RefEarlyChildhoodServices>(entity =>
            {
                entity.ToTable("RefEarlyChildhoodServices", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEarlyChildhoodServices)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEarlyChildhoodServices_Organization");
            });

            modelBuilder.Entity<RefEducationLevel>(entity =>
            {
                entity.ToTable("RefEducationLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefEducationLevelType)
                    .WithMany(p => p.RefEducationLevel)
                    .HasForeignKey(d => d.RefEducationLevelTypeId)
                    .HasConstraintName("FK_RefEducationLevel_RefEducationLevelType");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEducationLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEducationLevel_Organization");
            });

            modelBuilder.Entity<RefEducationLevelType>(entity =>
            {
                entity.ToTable("RefEducationLevelType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEducationLevelType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEducationLevelType_Organization");
            });

            modelBuilder.Entity<RefEducationVerificationMethod>(entity =>
            {
                entity.ToTable("RefEducationVerificationMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEducationVerificationMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEducationVerificationMethod_Organization");
            });

            modelBuilder.Entity<RefEleducationStaffClassification>(entity =>
            {
                entity.ToTable("RefELEducationStaffClassification", "dbo");

                entity.Property(e => e.RefEleducationStaffClassificationId).HasColumnName("RefELEducationStaffClassificationId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEleducationStaffClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELEducationStaffClassification_Organization");
            });

            modelBuilder.Entity<RefElementaryMiddleAdditional>(entity =>
            {
                entity.ToTable("RefElementaryMiddleAdditional", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElementaryMiddleAdditional)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefElementaryMiddleAdditional_Organization");
            });

            modelBuilder.Entity<RefElemploymentSeparationReason>(entity =>
            {
                entity.ToTable("RefELEmploymentSeparationReason", "dbo");

                entity.Property(e => e.RefElemploymentSeparationReasonId).HasColumnName("RefELEmploymentSeparationReasonId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElemploymentSeparationReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELEmploymentSeparationReason_Organization");
            });

            modelBuilder.Entity<RefElfacilityLicensingStatus>(entity =>
            {
                entity.ToTable("RefELFacilityLicensingStatus", "dbo");

                entity.Property(e => e.RefElfacilityLicensingStatusId).HasColumnName("RefELFacilityLicensingStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElfacilityLicensingStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELFacilityLicensingStatus_Organization");
            });

            modelBuilder.Entity<RefElfederalFundingType>(entity =>
            {
                entity.ToTable("RefELFederalFundingType", "dbo");

                entity.Property(e => e.RefElfederalFundingTypeId).HasColumnName("RefELFederalFundingTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElfederalFundingType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELFederalFundingType_Organization");
            });

            modelBuilder.Entity<RefElgroupSizeStandardMet>(entity =>
            {
                entity.ToTable("RefELGroupSizeStandardMet", "dbo");

                entity.Property(e => e.RefElgroupSizeStandardMetId).HasColumnName("RefELGroupSizeStandardMetId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElgroupSizeStandardMet)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELGroupSizeStandardMet_Organization");
            });

            modelBuilder.Entity<RefEllevelOfSpecialization>(entity =>
            {
                entity.ToTable("RefELLevelOfSpecialization", "dbo");

                entity.Property(e => e.RefEllevelOfSpecializationId).HasColumnName("RefELLevelOfSpecializationId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEllevelOfSpecialization)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELLevelOfSpecialization_Organization");
            });

            modelBuilder.Entity<RefEllocalRevenueSource>(entity =>
            {
                entity.ToTable("RefELLocalRevenueSource", "dbo");

                entity.Property(e => e.RefEllocalRevenueSourceId).HasColumnName("RefELLocalRevenueSourceId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEllocalRevenueSource)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELLocalRevenueSource_Organization");
            });

            modelBuilder.Entity<RefElotherFederalFundingSources>(entity =>
            {
                entity.ToTable("RefELOtherFederalFundingSources", "dbo");

                entity.Property(e => e.RefElotherFederalFundingSourcesId).HasColumnName("RefELOtherFederalFundingSourcesId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElotherFederalFundingSources)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELOtherFederalFundingSources_Organization");
            });

            modelBuilder.Entity<RefEloutcomeMeasurementLevel>(entity =>
            {
                entity.ToTable("RefELOutcomeMeasurementLevel", "dbo");

                entity.Property(e => e.RefEloutcomeMeasurementLevelId).HasColumnName("RefELOutcomeMeasurementLevelId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEloutcomeMeasurementLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELOutcomeMeasurementLevel_Organization");
            });

            modelBuilder.Entity<RefElprofessionalDevelopmentTopicArea>(entity =>
            {
                entity.ToTable("RefELProfessionalDevelopmentTopicArea", "dbo");

                entity.Property(e => e.RefElprofessionalDevelopmentTopicAreaId).HasColumnName("RefELProfessionalDevelopmentTopicAreaId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElprofessionalDevelopmentTopicArea)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELProfessionalDevelopmentTopicArea_Organization");
            });

            modelBuilder.Entity<RefElprogramEligibility>(entity =>
            {
                entity.ToTable("RefELProgramEligibility", "dbo");

                entity.Property(e => e.RefElprogramEligibilityId).HasColumnName("RefELProgramEligibilityId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElprogramEligibility)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELProgramEligibility_Organization");
            });

            modelBuilder.Entity<RefElprogramEligibilityStatus>(entity =>
            {
                entity.ToTable("RefELProgramEligibilityStatus", "dbo");

                entity.Property(e => e.RefElprogramEligibilityStatusId).HasColumnName("RefELProgramEligibilityStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElprogramEligibilityStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELProgramEligibilityStatus_Organization");
            });

            modelBuilder.Entity<RefElprogramLicenseStatus>(entity =>
            {
                entity.ToTable("RefELProgramLicenseStatus", "dbo");

                entity.Property(e => e.RefElprogramLicenseStatusId).HasColumnName("RefELProgramLicenseStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElprogramLicenseStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELProgramLicenseStatus_Organization");
            });

            modelBuilder.Entity<RefElserviceProfessionalStaffClassification>(entity =>
            {
                entity.ToTable("RefELServiceProfessionalStaffClassification", "dbo");

                entity.Property(e => e.RefElserviceProfessionalStaffClassificationId).HasColumnName("RefELServiceProfessionalStaffClassificationId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElserviceProfessionalStaffClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELServiceProfessionalStaffClassification_Organization");
            });

            modelBuilder.Entity<RefElserviceType>(entity =>
            {
                entity.ToTable("RefELServiceType", "dbo");

                entity.Property(e => e.RefElserviceTypeId).HasColumnName("RefELServiceTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElserviceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELServiceType_Organization");
            });

            modelBuilder.Entity<RefElstateRevenueSource>(entity =>
            {
                entity.ToTable("RefELStateRevenueSource", "dbo");

                entity.Property(e => e.RefElstateRevenueSourceId).HasColumnName("RefELStateRevenueSourceId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefElstateRevenueSource)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELStateRevenueSource_Organization");
            });

            modelBuilder.Entity<RefEltrainerCoreKnowledgeArea>(entity =>
            {
                entity.ToTable("RefELTrainerCoreKnowledgeArea", "dbo");

                entity.Property(e => e.RefEltrainerCoreKnowledgeAreaId).HasColumnName("RefELTrainerCoreKnowledgeAreaId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEltrainerCoreKnowledgeArea)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefELTrainerCoreKnowledgeArea_Organization");
            });

            modelBuilder.Entity<RefEmailType>(entity =>
            {
                entity.ToTable("RefEmailType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmailType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmailType_Organization");
            });

			modelBuilder.Entity<RefEmergencyOrProvisionalCredentialStatus>(entity =>
			{
				entity.ToTable("RefEmergencyOrProvisionalCredentialStatus", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefEmergencyOrProvisionalCredentialStatus)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefEmergencyOrProvisionalCredentialStatus_Org");
			});

			modelBuilder.Entity<RefEmployedAfterExit>(entity =>
            {
                entity.ToTable("RefEmployedAfterExit", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmployedAfterExit)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmployedAfterExit_Organization");
            });

            modelBuilder.Entity<RefEmployedPriorToEnrollment>(entity =>
            {
                entity.ToTable("RefEmployedPriorToEnrollment", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmployedPriorToEnrollment)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmployedPriorToEnrollment_Organization");
            });

            modelBuilder.Entity<RefEmployedWhileEnrolled>(entity =>
            {
                entity.ToTable("RefEmployedWhileEnrolled", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmployedWhileEnrolled)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmployedWhileEnrolled_Organization");
            });

            modelBuilder.Entity<RefEmploymentContractType>(entity =>
            {
                entity.ToTable("RefEmploymentContractType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmploymentContractType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmploymentContractType_Organization");
            });

            modelBuilder.Entity<RefEmploymentLocation>(entity =>
            {
                entity.ToTable("RefEmploymentLocation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");
            });

            modelBuilder.Entity<RefEmploymentSeparationReason>(entity =>
            {
                entity.ToTable("RefEmploymentSeparationReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmploymentSeparationReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmploymentSeparationReason_Organization");
            });

            modelBuilder.Entity<RefEmploymentSeparationType>(entity =>
            {
                entity.ToTable("RefEmploymentSeparationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmploymentSeparationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmploymentSeparationType_Organization");
            });

            modelBuilder.Entity<RefEmploymentStatus>(entity =>
            {
                entity.ToTable("RefEmploymentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmploymentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmploymentStatus_Organization");
            });

            modelBuilder.Entity<RefEmploymentStatusWhileEnrolled>(entity =>
            {
                entity.ToTable("RefEmploymentStatusWhileEnrolled", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmploymentStatusWhileEnrolled)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmploymentStatusWhileEnrolled_Organization");
            });

            modelBuilder.Entity<RefEndOfTermStatus>(entity =>
            {
                entity.ToTable("RefEndOfTermStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEndOfTermStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEndOfTermStatus_Organization");
            });

            modelBuilder.Entity<RefEnrollmentStatus>(entity =>
            {
                entity.ToTable("RefEnrollmentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEnrollmentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEnrollmentStatus_Organization");
            });

            modelBuilder.Entity<RefEntityType>(entity =>
            {
                entity.ToTable("RefEntityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEntityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefAssociatedEntityType_Organization");
            });

            modelBuilder.Entity<RefEntryType>(entity =>
            {
                entity.ToTable("RefEntryType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEntryType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEntryType_Organization");
            });

            modelBuilder.Entity<RefEnvironmentSetting>(entity =>
            {
                entity.ToTable("RefEnvironmentSetting", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEnvironmentSetting)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEnvironmentSetting_Organization");
            });

            modelBuilder.Entity<RefEradministrativeDataSource>(entity =>
            {
                entity.ToTable("RefERAdministrativeDataSource", "dbo");

                entity.Property(e => e.RefEradministrativeDataSourceId).HasColumnName("RefERAdministrativeDataSourceId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEradministrativeDataSource)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefERAdministrativeDataSource_Organization");
            });

            modelBuilder.Entity<RefErsruralUrbanContinuumCode>(entity =>
            {
                entity.ToTable("RefERSRuralUrbanContinuumCode", "dbo");

                entity.Property(e => e.RefErsruralUrbanContinuumCodeId).HasColumnName("RefERSRuralUrbanContinuumCodeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefErsruralUrbanContinuumCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefERSRuralUrbanContinuumCode_Organization");
            });

            modelBuilder.Entity<RefExitOrWithdrawalStatus>(entity =>
            {
                entity.ToTable("RefExitOrWithdrawalStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefExitOrWithdrawalStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefExitOrWithdrawalStatus_Organization");
            });

            modelBuilder.Entity<RefExitOrWithdrawalType>(entity =>
            {
                entity.ToTable("RefExitOrWithdrawalType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefExitOrWithdrawalType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefExitOrWithdrawalType_Organization");
            });

            modelBuilder.Entity<RefFamilyIncomeSource>(entity =>
            {
                entity.ToTable("RefFamilyIncomeSource", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFamilyIncomeSource)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFamilyIncomeSource_Org");
            });

            modelBuilder.Entity<RefFederalProgramFundingAllocationType>(entity =>
            {
                entity.ToTable("RefFederalProgramFundingAllocationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFederalProgramFundingAllocationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFederalFundingAllocation_Organization");
            });

            modelBuilder.Entity<RefFinancialAccountBalanceSheetCode>(entity =>
            {
                entity.HasKey(e => e.RefFinancialBalanceSheetAccountCodeId)
                    .HasName("PK_RefFinancialBalanceSheetAccountCode");

                entity.ToTable("RefFinancialAccountBalanceSheetCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAccountBalanceSheetCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialBalanceSheetAccountCode_Organization");
            });

            modelBuilder.Entity<RefFinancialAccountCategory>(entity =>
            {
                entity.ToTable("RefFinancialAccountCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAccountCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAccountCategory_Organization");
            });

            modelBuilder.Entity<RefFinancialAccountFundClassification>(entity =>
            {
                entity.ToTable("RefFinancialAccountFundClassification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAccountFundClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAccountFundClassification_Organization");
            });

            modelBuilder.Entity<RefFinancialAccountProgramCode>(entity =>
            {
                entity.ToTable("RefFinancialAccountProgramCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAccountProgramCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAccountProgramCode_Organization");
            });

            modelBuilder.Entity<RefFinancialAccountRevenueCode>(entity =>
            {
                entity.ToTable("RefFinancialAccountRevenueCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAccountRevenueCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialRevenueAccountCode_Organization");
            });

            modelBuilder.Entity<RefFinancialAidApplicationType>(entity =>
            {
                entity.ToTable("RefFinancialAidApplicationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAidApplicationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAidApplType_Organization");
            });

            modelBuilder.Entity<RefFinancialAidAwardStatus>(entity =>
            {
                entity.HasKey(e => e.RefFinancialAidStatusId)
                    .HasName("PK_FinancialAidAwardStatus");

                entity.ToTable("RefFinancialAidAwardStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAidAwardStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAidAwardStatus_Organization");
            });

            modelBuilder.Entity<RefFinancialAidAwardType>(entity =>
            {
                entity.ToTable("RefFinancialAidAwardType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAidAwardType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAidAwardType_Organization");
            });

            modelBuilder.Entity<RefFinancialAidVeteransBenefitStatus>(entity =>
            {
                entity.ToTable("RefFinancialAidVeteransBenefitStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAidVeteransBenefitStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAidVeteransBenefitStatus_Organization");
            });

            modelBuilder.Entity<RefFinancialAidVeteransBenefitType>(entity =>
            {
                entity.ToTable("RefFinancialAidVeteransBenefitType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialAidVeteransBenefitType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialAidVeteransBenefitType_Organization");
            });

            modelBuilder.Entity<RefFinancialExpenditureFunctionCode>(entity =>
            {
                entity.ToTable("RefFinancialExpenditureFunctionCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialExpenditureFunctionCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialExpenditureFunctionCode_Organization");
            });

            modelBuilder.Entity<RefFinancialExpenditureLevelOfInstructionCode>(entity =>
            {
                entity.ToTable("RefFinancialExpenditureLevelOfInstructionCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialExpenditureLevelOfInstructionCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialExpenditureLevelOfInstructionCode_Organization");
            });

            modelBuilder.Entity<RefFinancialExpenditureObjectCode>(entity =>
            {
                entity.ToTable("RefFinancialExpenditureObjectCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFinancialExpenditureObjectCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFinancialExpenditureObjectCode_Organization");
            });

            modelBuilder.Entity<RefFirearmType>(entity =>
            {
                entity.ToTable("RefFirearmType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFirearmType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFirearmType_Organization");
            });

            modelBuilder.Entity<RefFoodServiceEligibility>(entity =>
            {
                entity.ToTable("RefFoodServiceEligibility", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdictionNavigation)
                    .WithMany(p => p.RefFoodServiceEligibility)
                    .HasForeignKey(d => d.RefJurisdiction)
                    .HasConstraintName("FK_RefFoodServiceEligibility_Organization");
            });

            modelBuilder.Entity<RefFoodServiceParticipation>(entity =>
            {
                entity.ToTable("RefFoodServiceParticipation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFoodServiceParticipation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFoodServiceParticipation_Organization");
            });

            modelBuilder.Entity<RefFrequencyOfService>(entity =>
            {
                entity.ToTable("RefFrequencyOfService", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFrequencyOfService)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFrequencyOfService_Organization");
            });

            modelBuilder.Entity<RefFullTimeStatus>(entity =>
            {
                entity.ToTable("RefFullTimeStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefFullTimeStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefFullTimeStatus_Organization");
            });

            modelBuilder.Entity<RefGoalsForAttendingAdultEducation>(entity =>
            {
                entity.ToTable("RefGoalsForAttendingAdultEducation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGoalsForAttendingAdultEducation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGoalsForAttendingAdultEducation_Organization");
            });

            modelBuilder.Entity<RefGpaWeightedIndicator>(entity =>
            {
                entity.ToTable("RefGpaWeightedIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGpaWeightedIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGpaWeightedIndicator_Organization");
            });

            modelBuilder.Entity<RefGradeLevel>(entity =>
            {
                entity.ToTable("RefGradeLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefGradeLevelType)
                    .WithMany(p => p.RefGradeLevel)
                    .HasForeignKey(d => d.RefGradeLevelTypeId)
                    .HasConstraintName("FK_RefGradeLevel_RefGradeLevelType");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGradeLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGradeLevel_Organization");
            });

            modelBuilder.Entity<RefGradeLevelType>(entity =>
            {
                entity.ToTable("RefGradeLevelType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGradeLevelType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGradeLevelType_Organization");
            });

            modelBuilder.Entity<RefGradePointAverageDomain>(entity =>
            {
                entity.ToTable("RefGradePointAverageDomain", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGradePointAverageDomain)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGradePointAverageDomain_Organization");
            });

            modelBuilder.Entity<RefGraduateAssistantIpedsCategory>(entity =>
            {
                entity.ToTable("RefGraduateAssistantIpedsCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGraduateAssistantIpedsCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGraduateAssistIpedsCategory_Organization");
            });

            modelBuilder.Entity<RefGraduateOrDoctoralExamResultsStatus>(entity =>
            {
                entity.ToTable("RefGraduateOrDoctoralExamResultsStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGraduateOrDoctoralExamResultsStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGraduateOrDoctoralExamResultsStatus_Organization");
            });

            modelBuilder.Entity<RefGunFreeSchoolsActReportingStatus>(entity =>
            {
                entity.HasKey(e => e.RefGunFreeSchoolsActStatusReportingId)
                    .HasName("PK_RefGunFreeSchoolsActStatusReporting");

                entity.ToTable("RefGunFreeSchoolsActReportingStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefGunFreeSchoolsActReportingStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefGunFreeSchoolsActStatus_Organization1");
            });

            modelBuilder.Entity<RefHealthInsuranceCoverage>(entity =>
            {
                entity.ToTable("RefHealthInsuranceCoverage", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHealthInsuranceCoverage)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInsuranceType_Org");
            });

            modelBuilder.Entity<RefHearingScreeningStatus>(entity =>
            {
                entity.ToTable("RefHearingScreeningStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHearingScreeningStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHearingScreeningStatus_Organization");
            });

            modelBuilder.Entity<RefHighSchoolDiplomaDistinctionType>(entity =>
            {
                entity.ToTable("RefHighSchoolDiplomaDistinctionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHighSchoolDiplomaDistinctionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHsDiplomaDistinctionType_Organization");
            });

            modelBuilder.Entity<RefHighSchoolDiplomaType>(entity =>
            {
                entity.ToTable("RefHighSchoolDiplomaType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHighSchoolDiplomaType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHighSchoolDiplomaType_Organization");
            });

            modelBuilder.Entity<RefHighSchoolGraduationRateIndicator>(entity =>
            {
                entity.HasKey(e => e.RefHsgraduationRateIndicatorId)
                    .HasName("PK_RefHSGraduationRateIndicator");

                entity.ToTable("RefHighSchoolGraduationRateIndicator", "dbo");

                entity.Property(e => e.RefHsgraduationRateIndicatorId).HasColumnName("RefHSGraduationRateIndicatorId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHighSchoolGraduationRateIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHSGraduationRateIndicator_Organization");
            });

            modelBuilder.Entity<RefHigherEducationInstitutionAccreditationStatus>(entity =>
            {
                entity.ToTable("RefHigherEducationInstitutionAccreditationStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHigherEducationInstitutionAccreditationStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHigherEdInstitutionAccreditationStatus_Organization");
            });

            modelBuilder.Entity<RefHomelessNighttimeResidence>(entity =>
            {
                entity.ToTable("RefHomelessNighttimeResidence", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefHomelessNighttimeResidence)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefHomelessNighttimeResidence_Organization");
            });

            modelBuilder.Entity<RefIdeadisciplineMethodFirearm>(entity =>
            {
                entity.ToTable("RefIDEADisciplineMethodFirearm", "dbo");

                entity.Property(e => e.RefIdeadisciplineMethodFirearmId).HasColumnName("RefIDEADisciplineMethodFirearmId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeadisciplineMethodFirearm)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdeaDisciplineMethodFirearm_Organization");
            });

            modelBuilder.Entity<RefIdeaeducationalEnvironmentEc>(entity =>
            {
                entity.ToTable("RefIDEAEducationalEnvironmentEC", "dbo");

                entity.Property(e => e.RefIdeaeducationalEnvironmentEcid).HasColumnName("RefIDEAEducationalEnvironmentECId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeaeducationalEnvironmentEc)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdeaEdEnvironmentForEC_Organization");
            });

            modelBuilder.Entity<RefIdeaeducationalEnvironmentSchoolAge>(entity =>
            {
                entity.HasKey(e => e.RefIdeaEducationalEnvironmentSchoolAge)
                    .HasName("PK_RefIDEAEducationalEnvironmentSchoolAge");

                entity.ToTable("RefIDEAEducationalEnvironmentSchoolAge", "dbo");

                entity.Property(e => e.RefIdeaEducationalEnvironmentSchoolAge).HasColumnName("RefIdeaEducationalEnvironmentSchoolAge");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeaeducationalEnvironmentSchoolAge)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdeaEdEnvironmentSchoolAge_Organization");
            });

            modelBuilder.Entity<RefIdeaenvironmentEl>(entity =>
            {
                entity.ToTable("RefIDEAEnvironmentEL", "dbo");

                entity.Property(e => e.RefIdeaenvironmentElid).HasColumnName("RefIDEAEnvironmentELId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeaenvironmentEl)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIDEAEnvironmentEL_Organization");
            });

            modelBuilder.Entity<RefIdeaiepstatus>(entity =>
            {
                entity.ToTable("RefIDEAIEPStatus", "dbo");

                entity.Property(e => e.RefIdeaiepstatusId).HasColumnName("RefIDEAIEPStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeaiepstatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIDEAIEPStatus_Organization");
            });

            modelBuilder.Entity<RefIdeainterimRemoval>(entity =>
            {
                entity.ToTable("RefIDEAInterimRemoval", "dbo");

                entity.Property(e => e.RefIdeainterimRemovalId).HasColumnName("RefIDEAInterimRemovalId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeainterimRemoval)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdeaInterimRemovalId_Organization");
            });

            modelBuilder.Entity<RefIdeainterimRemovalReason>(entity =>
            {
                entity.ToTable("RefIDEAInterimRemovalReason", "dbo");

                entity.Property(e => e.RefIdeainterimRemovalReasonId).HasColumnName("RefIDEAInterimRemovalReasonId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeainterimRemovalReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdeaInterimRemovalReason_Organization");
            });

            modelBuilder.Entity<RefIdeapartCeligibilityCategory>(entity =>
            {
                entity.ToTable("RefIDEAPartCEligibilityCategory", "dbo");

                entity.Property(e => e.RefIdeapartCeligibilityCategoryId).HasColumnName("RefIDEAPartCEligibilityCategoryId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIdeapartCeligibilityCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIDEAPartCEligibilityCategory_Organization");
            });

            modelBuilder.Entity<RefImmunizationType>(entity =>
            {
                entity.ToTable("RefImmunizationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefImmunizationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefImmunization_Organization");
            });

            modelBuilder.Entity<RefIncidentBehavior>(entity =>
            {
                entity.ToTable("RefIncidentBehavior", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentBehavior)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentBehavior_Organization");
            });

            modelBuilder.Entity<RefIncidentBehaviorSecondary>(entity =>
            {
                entity.ToTable("RefIncidentBehaviorSecondary", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentBehaviorSecondary)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentBehaviorSecondary_Organization");
            });

            modelBuilder.Entity<RefIncidentInjuryType>(entity =>
            {
                entity.ToTable("RefIncidentInjuryType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentInjuryType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentInjuryType_Organization");
            });

            modelBuilder.Entity<RefIncidentLocation>(entity =>
            {
                entity.ToTable("RefIncidentLocation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentLocation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentLocation_Organization");
            });

            modelBuilder.Entity<RefIncidentMultipleOffenseType>(entity =>
            {
                entity.ToTable("RefIncidentMultipleOffenseType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentMultipleOffenseType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentMultipleOffenseType_Organization");
            });

            modelBuilder.Entity<RefIncidentPerpetratorInjuryType>(entity =>
            {
                entity.ToTable("RefIncidentPerpetratorInjuryType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentPerpetratorInjuryType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentPerpetratorInjuryType_Organization");
            });

            modelBuilder.Entity<RefIncidentPersonRoleType>(entity =>
            {
                entity.ToTable("RefIncidentPersonRoleType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentPersonRoleType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentPersonRoleType_Organization");
            });

            modelBuilder.Entity<RefIncidentPersonType>(entity =>
            {
                entity.ToTable("RefIncidentPersonType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentPersonType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentPersonType_Organization");
            });

            modelBuilder.Entity<RefIncidentReporterType>(entity =>
            {
                entity.ToTable("RefIncidentReporterType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentReporterType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentReporterType_Organization");
            });

            modelBuilder.Entity<RefIncidentTimeDescriptionCode>(entity =>
            {
                entity.ToTable("RefIncidentTimeDescriptionCode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncidentTimeDescriptionCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncidentTimeDescCode_Organization");
            });

            modelBuilder.Entity<RefIncomeCalculationMethod>(entity =>
            {
                entity.ToTable("RefIncomeCalculationMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncomeCalculationMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncomeCalculation_Organization");
            });

            modelBuilder.Entity<RefIncreasedLearningTimeType>(entity =>
            {
                entity.ToTable("RefIncreasedLearningTimeType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIncreasedLearningTimeType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIncreasedLearningTimeType_Organization");
            });

			modelBuilder.Entity<RefIndicatorStateDefinedStatus>(entity =>
			{
				entity.ToTable("RefIndicatorStateDefinedStatus", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefIndicatorStateDefinedStatus)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefIndicatorStateDefinedStatus_Org");
			});

			modelBuilder.Entity<RefIndicatorStatusSubgroupType>(entity =>
			{
				entity.ToTable("RefIndicatorStatusSubgroupType", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefIndicatorStatusSubgroupType)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefIndicatorStatusSubgroupType_Org");
			});

			modelBuilder.Entity<RefIndicatorStatusType>(entity =>
			{
				entity.ToTable("RefIndicatorStatusType", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefIndicatorStatusType)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefIndicatorStatusType_Org");
			});

			modelBuilder.Entity<RefIndicatorStatusCustomType>(entity =>
			{
				entity.ToTable("RefIndicatorStatusCustomType", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefIndicatorStatusCustomType)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefIndicatorStatusCustomType_Org");
			});

			modelBuilder.Entity<RefIndividualizedProgramDateType>(entity =>
            {
                entity.ToTable("RefIndividualizedProgramDateType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIndividualizedProgramDateType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIndividualizedProgramDateType_Org");
            });

            modelBuilder.Entity<RefIndividualizedProgramLocation>(entity =>
            {
                entity.ToTable("RefIndividualizedProgramLocation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIndividualizedProgramLocation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIndividualizedProgramLocation_Org");
            });

            modelBuilder.Entity<RefIndividualizedProgramPlannedServiceType>(entity =>
            {
                entity.ToTable("RefIndividualizedProgramPlannedServiceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIndividualizedProgramPlannedServiceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIndividualizedProgramPlannedServiceType_Organization");
            });

            modelBuilder.Entity<RefIndividualizedProgramTransitionType>(entity =>
            {
                entity.ToTable("RefIndividualizedProgramTransitionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIndividualizedProgramTransitionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIndividualizedProgramTransitionType_Org");
            });

            modelBuilder.Entity<RefIndividualizedProgramType>(entity =>
            {
                entity.ToTable("RefIndividualizedProgramType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIndividualizedProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIndivProgramType_Org");
            });

            modelBuilder.Entity<RefInstitutionTelephoneType>(entity =>
            {
                entity.ToTable("RefInstitutionTelephoneType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstitutionTelephoneType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstitutionTelephone_Org");
            });

            modelBuilder.Entity<RefInstructionCreditType>(entity =>
            {
                entity.ToTable("RefInstructionCreditType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstructionCreditType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstructionCreditType_Organization");
            });

            modelBuilder.Entity<RefInstructionLocationType>(entity =>
            {
                entity.ToTable("RefInstructionLocationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstructionLocationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstructionLocationType_Organization");
            });

            modelBuilder.Entity<RefInstructionalActivityHours>(entity =>
            {
                entity.ToTable("RefInstructionalActivityHours", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstructionalActivityHours)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstructionalActivityHours_Organization");
            });

            modelBuilder.Entity<RefInstructionalStaffContractLength>(entity =>
            {
                entity.ToTable("RefInstructionalStaffContractLength", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstructionalStaffContractLength)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstructStaffContractLength_Organization");
            });

            modelBuilder.Entity<RefInstructionalStaffFacultyTenure>(entity =>
            {
                entity.ToTable("RefInstructionalStaffFacultyTenure", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInstructionalStaffFacultyTenure)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInstructStaffFacultyTenure_Organization");
            });

            modelBuilder.Entity<RefIntegratedTechnologyStatus>(entity =>
            {
                entity.ToTable("RefIntegratedTechnologyStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIntegratedTechnologyStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIntegratedTechnologyStatus_Organization");
            });

            modelBuilder.Entity<RefInternetAccess>(entity =>
            {
                entity.ToTable("RefInternetAccess", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefInternetAccess)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefInternetAccess_Organization");
            });

            modelBuilder.Entity<RefIpedsOccupationalCategory>(entity =>
            {
                entity.ToTable("RefIpedsOccupationalCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIpedsOccupationalCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIpedsOccupationalCategory_Organization");
            });

            modelBuilder.Entity<RefIso6392language>(entity =>
            {
                entity.ToTable("RefISO6392Language", "dbo");

                entity.Property(e => e.RefIso6392languageId).HasColumnName("RefISO6392LanguageId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIso6392language)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefISO6392Language_Organization");
            });

            modelBuilder.Entity<RefIso6393language>(entity =>
            {
                entity.ToTable("RefISO6393Language", "dbo");

                entity.Property(e => e.RefIso6393languageId).HasColumnName("RefISO6393LanguageId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIso6393language)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefISO6393Language_Organization");
            });

            modelBuilder.Entity<RefIso6395languageFamily>(entity =>
            {
                entity.ToTable("RefISO6395LanguageFamily", "dbo");

                entity.Property(e => e.RefIso6395languageFamilyId).HasColumnName("RefISO6395LanguageFamilyId");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefIso6395languageFamily)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefISO6395LanguageFamily_Organization");
            });

            modelBuilder.Entity<RefItemResponseTheoryDifficultyCategory>(entity =>
            {
                entity.ToTable("RefItemResponseTheoryDifficultyCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefItemResponseTheoryDifficultyCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIRtDifficultyCategory_Organization");
            });

            modelBuilder.Entity<RefItemResponseTheoryKappaAlgorithm>(entity =>
            {
                entity.ToTable("RefItemResponseTheoryKappaAlgorithm", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefItemResponseTheoryKappaAlgorithm)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIRtKappaAlgorithm_Organization");
            });

            modelBuilder.Entity<RefK12endOfCourseRequirement>(entity =>
            {
                entity.ToTable("RefK12EndOfCourseRequirement", "dbo");

                entity.Property(e => e.RefK12endOfCourseRequirementId).HasColumnName("RefK12EndOfCourseRequirementId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefK12endOfCourseRequirement)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefK12EndOfCourseRequirement_Organization");
            });

            modelBuilder.Entity<RefK12leaTitleIsupportService>(entity =>
            {
                entity.ToTable("RefK12LeaTitleISupportService", "dbo");

                entity.Property(e => e.RefK12leatitleIsupportServiceId).HasColumnName("RefK12LEATitleISupportServiceId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefK12leaTitleIsupportService)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefK12LEATitleISupportService_Organization");
            });

            modelBuilder.Entity<RefK12responsibilityType>(entity =>
            {
                entity.ToTable("RefK12ResponsibilityType", "dbo");

                entity.Property(e => e.RefK12responsibilityTypeId).HasColumnName("RefK12ResponsibilityTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefK12responsibilityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefK12ResponsibilityType_Organization");
            });

            modelBuilder.Entity<RefK12staffClassification>(entity =>
            {
                entity.HasKey(e => e.RefEducationStaffClassificationId)
                    .HasName("PK_RefEducationStaffClassification");

                entity.ToTable("RefK12StaffClassification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefK12staffClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEducationStaffClassification_Organization");
            });

            modelBuilder.Entity<RefLanguage>(entity =>
            {
                entity.ToTable("RefLanguage", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLanguage)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLanguage_Organization");
            });

            modelBuilder.Entity<RefLanguageUseType>(entity =>
            {
                entity.ToTable("RefLanguageUseType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLanguageUseType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLanguageUseType_Organization");
            });

            modelBuilder.Entity<RefLeaFundsTransferType>(entity =>
            {
                entity.ToTable("RefLeaFundsTransferType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLeaFundsTransferType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLEAFundsTransferType_Organization");
            });

            modelBuilder.Entity<RefLeaImprovementStatus>(entity =>
            {
                entity.ToTable("RefLeaImprovementStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLeaImprovementStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLEAImprovementStatus_Organization");
            });

            modelBuilder.Entity<RefLeaType>(entity =>
            {
                entity.ToTable("RefLeaType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLeaType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLeaType_Organization");
            });

            modelBuilder.Entity<RefLearnerActionType>(entity =>
            {
                entity.ToTable("RefLearnerActionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(150);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearnerActionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearnerActionType_Organization");
            });

            modelBuilder.Entity<RefLearnerActivityMaximumTimeAllowedUnits>(entity =>
            {
                entity.ToTable("RefLearnerActivityMaximumTimeAllowedUnits", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearnerActivityMaximumTimeAllowedUnits)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMaxTimeAllowedUnits_Organization");
            });

            modelBuilder.Entity<RefLearnerActivityType>(entity =>
            {
                entity.ToTable("RefLearnerActivityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearnerActivityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearnerActivityType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceAccessApitype>(entity =>
            {
                entity.ToTable("RefLearningResourceAccessAPIType", "dbo");

                entity.Property(e => e.RefLearningResourceAccessApitypeId).HasColumnName("RefLearningResourceAccessAPITypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceAccessApitype)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceAccessAPIType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceAccessHazardType>(entity =>
            {
                entity.ToTable("RefLearningResourceAccessHazardType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceAccessHazardType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceAccessHazardType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceAccessModeType>(entity =>
            {
                entity.ToTable("RefLearningResourceAccessModeType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceAccessModeType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceAccessModeType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceAccessRightsUrl>(entity =>
            {
                entity.ToTable("RefLearningResourceAccessRightsUrl", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceAccessRightsUrl)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceAccessRightsUrl_Organization");
            });

            modelBuilder.Entity<RefLearningResourceAuthorType>(entity =>
            {
                entity.ToTable("RefLearningResourceAuthorType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceAuthorType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceAuthorType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceBookFormatType>(entity =>
            {
                entity.ToTable("RefLearningResourceBookFormatType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceBookFormatType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceBookFormatType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceCompetencyAlignmentType>(entity =>
            {
                entity.ToTable("RefLearningResourceCompetencyAlignmentType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceCompetencyAlignmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceCompetencyAlignmentType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceControlFlexibilityType>(entity =>
            {
                entity.ToTable("RefLearningResourceControlFlexibilityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceControlFlexibilityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceControlFlexibilityType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceDigitalMediaSubType>(entity =>
            {
                entity.ToTable("RefLearningResourceDigitalMediaSubType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceDigitalMediaSubType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceDigitalMediaSubType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceDigitalMediaType>(entity =>
            {
                entity.ToTable("RefLearningResourceDigitalMediaType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceDigitalMediaType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceDigitalMediaType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceEducationalUse>(entity =>
            {
                entity.ToTable("RefLearningResourceEducationalUse", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceEducationalUse)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLREducationalUse_Organization");
            });

            modelBuilder.Entity<RefLearningResourceIntendedEndUserRole>(entity =>
            {
                entity.ToTable("RefLearningResourceIntendedEndUserRole", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceIntendedEndUserRole)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLRIntendedEndUserRole_Organization");
            });

            modelBuilder.Entity<RefLearningResourceInteractionMode>(entity =>
            {
                entity.ToTable("RefLearningResourceInteractionMode", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(150);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceInteractionMode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceInteractionMode_Organization");
            });

            modelBuilder.Entity<RefLearningResourceInteractivityType>(entity =>
            {
                entity.ToTable("RefLearningResourceInteractivityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceInteractivityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLRInteractivityType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceMediaFeatureType>(entity =>
            {
                entity.ToTable("RefLearningResourceMediaFeatureType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceMediaFeatureType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourceMediaFeatureType_Organization");
            });

            modelBuilder.Entity<RefLearningResourcePhysicalMediaType>(entity =>
            {
                entity.ToTable("RefLearningResourcePhysicalMediaType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourcePhysicalMediaType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningResourcePhysicalMediaType_Organization");
            });

            modelBuilder.Entity<RefLearningResourceType>(entity =>
            {
                entity.ToTable("RefLearningResourceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningResourceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLRType_Organization");
            });

            modelBuilder.Entity<RefLearningStandardDocumentPublicationStatus>(entity =>
            {
                entity.ToTable("RefLearningStandardDocumentPublicationStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningStandardDocumentPublicationStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLSDocumentPublicationStatus_Organization");
            });

            modelBuilder.Entity<RefLearningStandardItemAssociationType>(entity =>
            {
                entity.ToTable("RefLearningStandardItemAssociationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningStandardItemAssociationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningStandardItemAssociationType_Organization");
            });

            modelBuilder.Entity<RefLearningStandardItemNodeAccessibilityProfile>(entity =>
            {
                entity.ToTable("RefLearningStandardItemNodeAccessibilityProfile", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningStandardItemNodeAccessibilityProfile)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningStandardItemNodeAccessibilityProfile_Organization");
            });

            modelBuilder.Entity<RefLearningStandardItemTestabilityType>(entity =>
            {
                entity.ToTable("RefLearningStandardItemTestabilityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLearningStandardItemTestabilityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLearningStandardItemTestabilityType_Organization");
            });

            modelBuilder.Entity<RefLeaveEventType>(entity =>
            {
                entity.ToTable("RefLeaveEventType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLeaveEventType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLeaveEventType_Organization");
            });

            modelBuilder.Entity<RefLevelOfInstitution>(entity =>
            {
                entity.ToTable("RefLevelOfInstitution", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLevelOfInstitution)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLevelOfInstitution_Organization");
            });

            modelBuilder.Entity<RefLicenseExempt>(entity =>
            {
                entity.ToTable("RefLicenseExempt", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLicenseExempt)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLicenseExempt_Organization");
            });

            modelBuilder.Entity<RefLiteracyAssessment>(entity =>
            {
                entity.ToTable("RefLiteracyAssessment", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefLiteracyAssessment)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLiteracyAssessment_Organization");
            });

            modelBuilder.Entity<RefMagnetSpecialProgram>(entity =>
            {
                entity.ToTable("RefMagnetSpecialProgram", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMagnetSpecialProgram)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMagnetSpecialProgram_Organization");
            });

            modelBuilder.Entity<RefMedicalAlertIndicator>(entity =>
            {
                entity.ToTable("RefMedicalAlertIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMedicalAlertIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMedAlert_Org");
            });

            modelBuilder.Entity<RefMepEnrollmentType>(entity =>
            {
                entity.ToTable("RefMepEnrollmentType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepEnrollmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMEPEnrollmentType_Organization");
            });

            modelBuilder.Entity<RefMepProjectBased>(entity =>
            {
                entity.ToTable("RefMepProjectBased", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepProjectBased)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMEPProjectBased_Organization");
            });

            modelBuilder.Entity<RefMepProjectType>(entity =>
            {
                entity.ToTable("RefMepProjectType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepProjectType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMepProjectType_Organization");
            });

            modelBuilder.Entity<RefMepServiceType>(entity =>
            {
                entity.ToTable("RefMepServiceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepServiceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMEPServiceType_Organization");
            });

            modelBuilder.Entity<RefMepSessionType>(entity =>
            {
                entity.ToTable("RefMepSessionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepSessionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMEPSessionType_Organization");
            });

            modelBuilder.Entity<RefMepStaffCategory>(entity =>
            {
                entity.ToTable("RefMepStaffCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMepStaffCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMepStaffCategory_Organization");
            });

            modelBuilder.Entity<RefMethodOfServiceDelivery>(entity =>
            {
                entity.ToTable("RefMethodOfServiceDelivery", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMethodOfServiceDelivery)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMethodOfServiceDelivery_Organization");
            });

            modelBuilder.Entity<RefMilitaryActiveStudentIndicator>(entity =>
            {
                entity.ToTable("RefMilitaryActiveStudentIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMilitaryActiveStudentIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMilitaryActiveStudentIndicator_Organization");
            });

            modelBuilder.Entity<RefMilitaryBranch>(entity =>
            {
                entity.ToTable("RefMilitaryBranch", "dbo");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMilitaryBranch)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMilitaryBranch_Organization");
            });

            modelBuilder.Entity<RefMilitaryConnectedStudentIndicator>(entity =>
            {
                entity.ToTable("RefMilitaryConnectedStudentIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMilitaryConnectedStudentIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMilitaryConnectedStudentIndicator_Organization");
            });

            modelBuilder.Entity<RefMilitaryVeteranStudentIndicator>(entity =>
            {
                entity.ToTable("RefMilitaryVeteranStudentIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMilitaryVeteranStudentIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMilitaryVeteranStudentIndicator_Organization");
            });

            modelBuilder.Entity<RefMultipleIntelligenceType>(entity =>
            {
                entity.ToTable("RefMultipleIntelligenceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefMultipleIntelligenceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefMultipleIntelligenceType_Organization");
            });

            modelBuilder.Entity<RefNaepAspectsOfReading>(entity =>
            {
                entity.ToTable("RefNaepAspectsOfReading", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNaepAspectsOfReading)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNAEPAspectsOfReading_Organization");
            });

            modelBuilder.Entity<RefNaepMathComplexityLevel>(entity =>
            {
                entity.ToTable("RefNaepMathComplexityLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNaepMathComplexityLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNAEPMathComplexityLevel_Organization");
            });

            modelBuilder.Entity<RefNcescollegeCourseMapCode>(entity =>
            {
                entity.ToTable("RefNCESCollegeCourseMapCode", "dbo");

                entity.Property(e => e.RefNcescollegeCourseMapCodeId).HasColumnName("RefNCESCollegeCourseMapCodeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNcescollegeCourseMapCode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNCESCollegeCourseMapCode_Organization");
            });

            modelBuilder.Entity<RefNeedDeterminationMethod>(entity =>
            {
                entity.ToTable("RefNeedDeterminationMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNeedDeterminationMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNeedDeterminationMethod_Organization");
            });

            modelBuilder.Entity<RefNeglectedProgramType>(entity =>
            {
                entity.ToTable("RefNeglectedProgramType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNeglectedProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNeglectedProgramType_Organization");
            });

            modelBuilder.Entity<RefNonPromotionReason>(entity =>
            {
                entity.ToTable("RefNonPromotionReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNonPromotionReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNonPromotionReason_Organization");
            });

            modelBuilder.Entity<RefNonTraditionalGenderStatus>(entity =>
            {
                entity.ToTable("RefNonTraditionalGenderStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNonTraditionalGenderStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNonTraditionalGenderStatus_Organization");
            });


            modelBuilder.Entity<RefNSLPStatus>(entity =>
            {
                entity.HasKey(e => e.RefNSLPStatusId)
                    .HasName("XPKRefNSLPStatus");

                entity.ToTable("RefNSLPStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Definition).HasMaxLength(400);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefNSLPStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefNSLPStatus_Organization");
            });

            modelBuilder.Entity<RefOperationalStatus>(entity =>
            {
                entity.ToTable("RefOperationalStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOperationalStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOperationalStatus_Organization");

                entity.HasOne(d => d.RefOperationalStatusType)
                    .WithMany(p => p.RefOperationalStatus)
                    .HasForeignKey(d => d.RefOperationalStatusTypeId)
                    .HasConstraintName("FK_RefOperationalStatus_RefOperationalStatusType");
            });

            modelBuilder.Entity<RefOperationalStatusType>(entity =>
            {
                entity.ToTable("RefOperationalStatusType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOperationalStatusType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOperationalStatusType_Organization");
            });

            modelBuilder.Entity<RefOrganizationElementType>(entity =>
            {
                entity.ToTable("RefOrganizationElementType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationElementType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationElementType_Organization");
            });

            modelBuilder.Entity<RefOrganizationIdentificationSystem>(entity =>
            {
                entity.ToTable("RefOrganizationIdentificationSystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationIdentificationSystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdentifierOrg_Org");

                entity.HasOne(d => d.RefOrganizationIdentifierType)
                    .WithMany(p => p.RefOrganizationIdentificationSystem)
                    .HasForeignKey(d => d.RefOrganizationIdentifierTypeId)
                    .HasConstraintName("FK_RefOrgIdentificationSystem _RefOrganizationIdentifierType");
            });

            modelBuilder.Entity<RefOrganizationIdentifierType>(entity =>
            {
                entity.ToTable("RefOrganizationIdentifierType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationIdentifierType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationIdentifierType_Organization");
            });

            modelBuilder.Entity<RefOrganizationIndicator>(entity =>
            {
                entity.ToTable("RefOrganizationIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationIndicator_Organization");

                entity.HasOne(d => d.RefOrganizationType)
                    .WithMany(p => p.RefOrganizationIndicator)
                    .HasForeignKey(d => d.RefOrganizationTypeId)
                    .HasConstraintName("FK_RefOrganizationIndicator_RefOrganizationType");
            });

            modelBuilder.Entity<RefOrganizationLocationType>(entity =>
            {
                entity.ToTable("RefOrganizationLocationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationLocationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationLoc_Org");
            });

            modelBuilder.Entity<RefOrganizationMonitoringNotifications>(entity =>
            {
                entity.ToTable("RefOrganizationMonitoringNotifications", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationMonitoringNotifications)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationMonitoringNotifications_Organization");
            });

            modelBuilder.Entity<RefOrganizationRelationship>(entity =>
            {
                entity.ToTable("RefOrganizationRelationship", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationRelationship)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationRelationship_Organization");
            });

            modelBuilder.Entity<RefOrganizationType>(entity =>
            {
                entity.ToTable("RefOrganizationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOrganizationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOrganizationType_Organization");

                entity.HasOne(d => d.RefOrganizationElementType)
                    .WithMany(p => p.RefOrganizationType)
                    .HasForeignKey(d => d.RefOrganizationElementTypeId)
                    .HasConstraintName("FK_RefOrganizationType_RefOrganizationElementType");
            });

            modelBuilder.Entity<RefOtherNameType>(entity =>
            {
                entity.ToTable("RefOtherNameType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOtherNameType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOtherName_Organization");
            });

            modelBuilder.Entity<RefOutcomeTimePoint>(entity =>
            {
                entity.ToTable("RefOutcomeTimePoint", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOutcomeTimePoint)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOutcomeTimePoint_Organization");
            });

			modelBuilder.Entity<RefOutOfFieldStatus>(entity =>
			{
				entity.ToTable("RefOutOfFieldStatus", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefOutOfFieldStatus)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefOutOfFieldStatus_Org");
			});

			modelBuilder.Entity<RefParaprofessionalQualification>(entity =>
            {
                entity.ToTable("RefParaprofessionalQualification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefParaprofessionalQualification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefParaprofessionalQualification_Organization");
            });

            modelBuilder.Entity<RefParticipationStatusAyp>(entity =>
            {
                entity.ToTable("RefParticipationStatusAyp", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefParticipationStatusAyp)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefParticipationStatusAYP_Organization");
            });

            modelBuilder.Entity<RefParticipationType>(entity =>
            {
                entity.ToTable("RefParticipationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.RefParticipationType)
                    .HasForeignKey(d => d.OrganizationId)
                    .HasConstraintName("FK_RefParticipationType_Organization");
            });

            modelBuilder.Entity<RefPdactivityApprovedPurpose>(entity =>
            {
                entity.HasKey(e => e.RefPdactivityApprovedForId)
                    .HasName("PK_RefPDActivityApprovedFor");

                entity.ToTable("RefPDActivityApprovedPurpose", "dbo");

                entity.Property(e => e.RefPdactivityApprovedForId).HasColumnName("RefPDActivityApprovedForId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityApprovedPurpose)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityApprovedFor_Organization");
            });

            modelBuilder.Entity<RefPdactivityCreditType>(entity =>
            {
                entity.ToTable("RefPDActivityCreditType", "dbo");

                entity.Property(e => e.RefPdactivityCreditTypeId).HasColumnName("RefPDActivityCreditTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityCreditType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityCreditType_Organization");
            });

            modelBuilder.Entity<RefPdactivityEducationLevelsAddressed>(entity =>
            {
                entity.ToTable("RefPDActivityEducationLevelsAddressed", "dbo");

                entity.Property(e => e.RefPdactivityEducationLevelsAddressedId).HasColumnName("RefPDActivityEducationLevelsAddressedId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityEducationLevelsAddressed)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityEducationLevelsAddressed_Organization");
            });

            modelBuilder.Entity<RefPdactivityLevel>(entity =>
            {
                entity.ToTable("RefPDActivityLevel", "dbo");

                entity.Property(e => e.RefPdactivityLevelId).HasColumnName("RefPDActivityLevelId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityLevel_Organization");
            });

            modelBuilder.Entity<RefPdactivityTargetAudience>(entity =>
            {
                entity.ToTable("RefPDActivityTargetAudience", "dbo");

                entity.Property(e => e.RefPdactivityTargetAudienceId).HasColumnName("RefPDActivityTargetAudienceId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityTargetAudience)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityTargetAudience_Organization");
            });

            modelBuilder.Entity<RefPdactivityType>(entity =>
            {
                entity.ToTable("RefPDActivityType", "dbo");

                entity.Property(e => e.RefPdactivityTypeId).HasColumnName("RefPDActivityTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdactivityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDActivityType_Organization");
            });

            modelBuilder.Entity<RefPdaudienceType>(entity =>
            {
                entity.ToTable("RefPDAudienceType", "dbo");

                entity.Property(e => e.RefPdaudienceTypeId).HasColumnName("RefPDAudienceTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdaudienceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDAudienceType_Organization");
            });

            modelBuilder.Entity<RefPddeliveryMethod>(entity =>
            {
                entity.ToTable("RefPDDeliveryMethod", "dbo");

                entity.Property(e => e.RefPddeliveryMethodId).HasColumnName("RefPDDeliveryMethodId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPddeliveryMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDDeliveryMethod_Organization");
            });

            modelBuilder.Entity<RefPdinstructionalDeliveryMode>(entity =>
            {
                entity.ToTable("RefPDInstructionalDeliveryMode", "dbo");

                entity.Property(e => e.RefPdinstructionalDeliveryModeId).HasColumnName("RefPDInstructionalDeliveryModeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdinstructionalDeliveryMode)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDInstructionalDeliveryMode_Organization");
            });

            modelBuilder.Entity<RefPdsessionStatus>(entity =>
            {
                entity.ToTable("RefPDSessionStatus", "dbo");

                entity.Property(e => e.RefPdsessionStatusId).HasColumnName("RefPDSessionStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPdsessionStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPDSessionStatus_Organization");
            });

            modelBuilder.Entity<RefPersonIdentificationSystem>(entity =>
            {
                entity.ToTable("RefPersonIdentificationSystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonIdentificationSystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefIdentifierPerson_Organization");

                entity.HasOne(d => d.RefPersonIdentifierType)
                    .WithMany(p => p.RefPersonIdentificationSystem)
                    .HasForeignKey(d => d.RefPersonIdentifierTypeId)
                    .HasConstraintName("FK_RefPersonIdentificationSystem _RefPersonIdentifierType");
            });

            modelBuilder.Entity<RefPersonIdentifierType>(entity =>
            {
                entity.ToTable("RefPersonIdentifierType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonIdentifierType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPersonIdentifierType_Organization");
            });

            modelBuilder.Entity<RefPersonLocationType>(entity =>
            {
                entity.ToTable("RefPersonLocationType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefAddressType)
                    .WithMany(p => p.RefPersonLocationType)
                    .HasForeignKey(d => d.RefAddressTypeId)
                    .HasConstraintName("FK_RefPersonLocationType_RefAddressType");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonLocationType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPersonLocationType_Organization");
            });

            modelBuilder.Entity<RefPersonRelationship>(entity =>
            {
                entity.ToTable("RefPersonRelationship", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonRelationship)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRelationship_Organization");
            });

            modelBuilder.Entity<RefPersonStatusType>(entity =>
            {
                entity.ToTable("RefPersonStatusType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonStatusType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPersonStatusType_Organization");
            });

            modelBuilder.Entity<RefPersonTelephoneNumberType>(entity =>
            {
                entity.ToTable("RefPersonTelephoneNumberType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonTelephoneNumberType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPersonTelephoneType_Organization");
            });

            modelBuilder.Entity<RefPersonalInformationVerification>(entity =>
            {
                entity.ToTable("RefPersonalInformationVerification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPersonalInformationVerification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPersonalInfoVerification_Organization");
            });

            modelBuilder.Entity<RefPopulationServed>(entity =>
            {
                entity.ToTable("RefPopulationServed", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPopulationServed)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPopulationServed_Organization");
            });

            modelBuilder.Entity<RefPreAndPostTestIndicator>(entity =>
            {
                entity.ToTable("RefPreAndPostTestIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPreAndPostTestIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPreAndPostTestIndicator_Organization");
            });

            modelBuilder.Entity<RefPreKeligibleAgesNonIdea>(entity =>
            {
                entity.ToTable("RefPreKEligibleAgesNonIDEA", "dbo");

                entity.Property(e => e.RefPreKeligibleAgesNonIdeaid).HasColumnName("RefPreKEligibleAgesNonIDEAId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPreKeligibleAgesNonIdea)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPreKEligibleAgesNonIDEA_Organization");
            });

            modelBuilder.Entity<RefPredominantCalendarSystem>(entity =>
            {
                entity.ToTable("RefPredominantCalendarSystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPredominantCalendarSystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPredominantCalendarSystem_Organization");
            });

            modelBuilder.Entity<RefPrekindergartenEligibility>(entity =>
            {
                entity.ToTable("RefPrekindergartenEligibility", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPrekindergartenEligibility)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPrekindergartenEligibility_Organization");
            });

            modelBuilder.Entity<RefPresentAttendanceCategory>(entity =>
            {
                entity.ToTable("RefPresentAttendanceCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPresentAttendanceCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPresentAttendanceCategory_Organization");
            });

            modelBuilder.Entity<RefProfessionalDevelopmentFinancialSupport>(entity =>
            {
                entity.ToTable("RefProfessionalDevelopmentFinancialSupport", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProfessionalDevelopmentFinancialSupport)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProfDevFinancialSupport_Organization");
            });

            modelBuilder.Entity<RefProfessionalEducationJobClassification>(entity =>
            {
                entity.ToTable("RefProfessionalEducationJobClassification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProfessionalEducationJobClassification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProfessionalEducationJobClassification_Organization");
            });

            modelBuilder.Entity<RefProfessionalTechnicalCredentialType>(entity =>
            {
                entity.ToTable("RefProfessionalTechnicalCredentialType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProfessionalTechnicalCredentialType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProfTechCredentialType_Organization");
            });

            modelBuilder.Entity<RefProficiencyStatus>(entity =>
            {
                entity.ToTable("RefProficiencyStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProficiencyStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProficiencyStatus_Organization");
            });

            modelBuilder.Entity<RefProficiencyTargetAyp>(entity =>
            {
                entity.ToTable("RefProficiencyTargetAyp", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProficiencyTargetAyp)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProficiencyTargetAYP_Organization");
            });

            modelBuilder.Entity<RefProgramDayLength>(entity =>
            {
                entity.ToTable("RefProgramDayLength", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgramDayLength)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgramDayLength_Organization");
            });

            modelBuilder.Entity<RefProgramExitReason>(entity =>
            {
                entity.ToTable("RefProgramExitReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgramExitReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgramExitReason_Organization");
            });

            modelBuilder.Entity<RefProgramGiftedEligibility>(entity =>
            {
                entity.ToTable("RefProgramGiftedEligibility", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgramGiftedEligibility)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgramGiftedEligibility_Organization");
            });

            modelBuilder.Entity<RefProgramLengthHoursType>(entity =>
            {
                entity.ToTable("RefProgramLengthHoursType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgramLengthHoursType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgramLengthHoursType_Organization");
            });

            modelBuilder.Entity<RefProgramSponsorType>(entity =>
            {
                entity.ToTable("RefProgramSponsorType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdictionNavigation)
                    .WithMany(p => p.RefProgramSponsorType)
                    .HasForeignKey(d => d.RefJurisdiction)
                    .HasConstraintName("FK_RefProgramSponsorType_Organization");
            });

            modelBuilder.Entity<RefProgramType>(entity =>
            {
                entity.ToTable("RefProgramType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgramType_Organization");
            });

            modelBuilder.Entity<RefProgressLevel>(entity =>
            {
                entity.ToTable("RefProgressLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProgressLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProgressLevel_Organization");
            });

            modelBuilder.Entity<RefPromotionReason>(entity =>
            {
                entity.ToTable("RefPromotionReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPromotionReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPromotionReason_Organization");
            });

            modelBuilder.Entity<RefProofOfResidencyType>(entity =>
            {
                entity.ToTable("RefProofOfResidencyType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefProofOfResidencyType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefProofOfResidencyType_Organization");
            });

            modelBuilder.Entity<RefPsEnrollmentAction>(entity =>
            {
                entity.ToTable("RefPsEnrollmentAction", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdictionNavigation)
                    .WithMany(p => p.RefPsEnrollmentAction)
                    .HasForeignKey(d => d.RefJurisdiction)
                    .HasConstraintName("FK_RefPSEnrollmentAction_Organization");
            });

            modelBuilder.Entity<RefPsEnrollmentAwardType>(entity =>
            {
                entity.ToTable("RefPsEnrollmentAwardType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsEnrollmentAwardType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPsEnrollmentAwardType_Organization");
            });

            modelBuilder.Entity<RefPsEnrollmentStatus>(entity =>
            {
                entity.ToTable("RefPsEnrollmentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsEnrollmentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPsEnrollmentStatus_Organization");
            });

            modelBuilder.Entity<RefPsEnrollmentType>(entity =>
            {
                entity.ToTable("RefPsEnrollmentType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsEnrollmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPsEnrollmentType_Organization");
            });

            modelBuilder.Entity<RefPsLepType>(entity =>
            {
                entity.ToTable("RefPsLepType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsLepType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPostsecondaryLEPType_Organization");
            });

            modelBuilder.Entity<RefPsStudentLevel>(entity =>
            {
                entity.ToTable("RefPsStudentLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsStudentLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPsStudentLevel_Organization");
            });

            modelBuilder.Entity<RefPsexitOrWithdrawalType>(entity =>
            {
                entity.ToTable("RefPSExitOrWithdrawalType", "dbo");

                entity.Property(e => e.RefPsexitOrWithdrawalTypeId).HasColumnName("RefPSExitOrWithdrawalTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsexitOrWithdrawalType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPSExitOrWithdrawalType_Organization");
            });

            modelBuilder.Entity<RefPsprogramLevel>(entity =>
            {
                entity.ToTable("RefPSProgramLevel", "dbo");

                entity.Property(e => e.RefPsprogramLevelId).HasColumnName("RefPSProgramLevelId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPsprogramLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPSProgramLevel_Organization");
            });

            modelBuilder.Entity<RefPublicSchoolChoiceStatus>(entity =>
            {
                entity.ToTable("RefPublicSchoolChoiceStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPublicSchoolChoiceStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPublicSchoolChoiceStatus_Organization");
            });

            modelBuilder.Entity<RefPublicSchoolResidence>(entity =>
            {
                entity.ToTable("RefPublicSchoolResidence", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPublicSchoolResidence)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPublicSchoolResidence_Organization");
            });

            modelBuilder.Entity<RefPurposeOfMonitoringVisit>(entity =>
            {
                entity.ToTable("RefPurposeOfMonitoringVisit", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefPurposeOfMonitoringVisit)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefPurposeOfMonitoringVisit_Organization");
            });

            modelBuilder.Entity<RefQrisParticipation>(entity =>
            {
                entity.ToTable("RefQrisParticipation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefQrisParticipation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefQRISParticipation_Organization");
            });

            modelBuilder.Entity<RefRace>(entity =>
            {
                entity.ToTable("RefRace", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefRace)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRace_Organization");
            });

            modelBuilder.Entity<RefReapAlternativeFundingStatus>(entity =>
            {
                entity.ToTable("RefReapAlternativeFundingStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefReapAlternativeFundingStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefREAPAlternativeFundingStatus_Organization");
            });

            modelBuilder.Entity<RefReasonDelayTransitionConf>(entity =>
            {
                entity.ToTable("RefReasonDelayTransitionConf", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefReasonDelayTransitionConf)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefReasonDelayTransitionConf_Organization");
            });

            modelBuilder.Entity<RefReconstitutedStatus>(entity =>
            {
                entity.ToTable("RefReconstitutedStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefReconstitutedStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefReconstitutedStatus_Organization");
            });

            modelBuilder.Entity<RefReferralOutcome>(entity =>
            {
                entity.ToTable("RefReferralOutcome", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefReferralOutcome)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefReferralOutcome_Organization");
            });

            modelBuilder.Entity<RefReimbursementType>(entity =>
            {
                entity.ToTable("RefReimbursementType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefReimbursementType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefReimbursementType_Organization");
            });

            modelBuilder.Entity<RefRestructuringAction>(entity =>
            {
                entity.ToTable("RefRestructuringAction", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefRestructuringAction)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRestructuringAction_Organization");
            });

            modelBuilder.Entity<RefRlisProgramUse>(entity =>
            {
                entity.ToTable("RefRlisProgramUse", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefRlisProgramUse)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRLISProgramUse_Organization");
            });

            modelBuilder.Entity<RefRoleStatus>(entity =>
            {
                entity.ToTable("RefRoleStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefRoleStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRoleStatus_Organization");

                entity.HasOne(d => d.RefRoleStatusType)
                    .WithMany(p => p.RefRoleStatus)
                    .HasForeignKey(d => d.RefRoleStatusTypeId)
                    .HasConstraintName("FK_RefRoleStatus_RefRoleStatusType");
            });

            modelBuilder.Entity<RefRoleStatusType>(entity =>
            {
                entity.ToTable("RefRoleStatusType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefRoleStatusType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRoleStatusType_Organization");
            });

            modelBuilder.Entity<RefScedcourseLevel>(entity =>
            {
                entity.ToTable("RefSCEDCourseLevel", "dbo");

                entity.Property(e => e.RefScedcourseLevelId).HasColumnName("RefSCEDCourseLevelId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefScedcourseLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSCEDCourseLevel_Organization");
            });

            modelBuilder.Entity<RefScedcourseSubjectArea>(entity =>
            {
                entity.ToTable("RefSCEDCourseSubjectArea", "dbo");

                entity.Property(e => e.RefScedcourseSubjectAreaId).HasColumnName("RefSCEDCourseSubjectAreaId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefScedcourseSubjectArea)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSCEDCourseSubjectArea_Organization");
            });

            modelBuilder.Entity<RefScheduledWellChildScreening>(entity =>
            {
                entity.ToTable("RefScheduledWellChildScreening", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefScheduledWellChildScreening)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefScheduledWellChildScreening_Organization");
            });

            modelBuilder.Entity<RefSchoolFoodServiceProgram>(entity =>
            {
                entity.ToTable("RefSchoolFoodServiceProgram", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdictionNavigation)
                    .WithMany(p => p.RefSchoolFoodServiceProgram)
                    .HasForeignKey(d => d.RefJurisdiction)
                    .HasConstraintName("FK_RefSchoolFoodServiceProgram_Organization");
            });

            modelBuilder.Entity<RefSchoolImprovementFunds>(entity =>
            {
                entity.ToTable("RefSchoolImprovementFunds", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSchoolImprovementFunds)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSchoolImprovementFunds_Organization1");
            });

            modelBuilder.Entity<RefSchoolImprovementStatus>(entity =>
            {
                entity.ToTable("RefSchoolImprovementStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSchoolImprovementStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSchoolImprovementStatus_Organization");
            });


            modelBuilder.Entity<RefSchoolDangerousStatus>(entity =>
            {
                entity.ToTable("RefSchoolDangerousStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSchoolDangerousStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSchoolDangerousStatus_Organization");
            });

            modelBuilder.Entity<RefComprehensiveAndTargetedSupport>(entity =>
            {
                entity.ToTable("RefComprehensiveAndTargetedSupport", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefComprehensiveAndTargetedSupport)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefComprehensiveAndTargetedSupport_Organization");
            });

            modelBuilder.Entity<RefComprehensiveSupport>(entity =>
            {
                entity.ToTable("RefComprehensiveSupport", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefComprehensiveSupport)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefComprehensiveSupport_Organization");
            });

            modelBuilder.Entity<RefTargetedSupport>(entity =>
            {
                entity.ToTable("RefTargetedSupport", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTargetedSupport)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTargetedSupport_Organization");
            });

            modelBuilder.Entity<RefTargetedSupportImprovement>(entity =>
            {
                entity.ToTable("RefTargetedSupportImprovement", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTargetedSupportImprovement)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTargetedSupportImprovement_Org");
            });

            modelBuilder.Entity<RefSchoolLevel>(entity =>
            {
                entity.ToTable("RefSchoolLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSchoolLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSchoolLevel_Organization");
            });

            modelBuilder.Entity<RefSchoolType>(entity =>
            {
                entity.ToTable("RefSchoolType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSchoolType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSchoolType_Organization");
            });

            modelBuilder.Entity<RefScoreMetricType>(entity =>
            {
                entity.ToTable("RefScoreMetricType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefScoreMetricType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefScoreMetricType_Organization");
            });

            modelBuilder.Entity<RefServiceFrequency>(entity =>
            {
                entity.ToTable("RefServiceFrequency", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefServiceFrequency)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefServiceFrequency_Organization");
            });

            modelBuilder.Entity<RefServiceOption>(entity =>
            {
                entity.ToTable("RefServiceOption", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefServiceOption)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefServiceOption_Organization");
            });

            modelBuilder.Entity<RefServices>(entity =>
            {
                entity.ToTable("RefServices", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefServices)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefServices_Organization");
            });

            modelBuilder.Entity<RefSessionType>(entity =>
            {
                entity.ToTable("RefSessionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSessionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSessionType_Organization");
            });

            modelBuilder.Entity<RefSex>(entity =>
            {
                entity.ToTable("RefSex", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSex)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSex_Organization");
            });

            modelBuilder.Entity<RefSigInterventionType>(entity =>
            {
                entity.ToTable("RefSigInterventionType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSigInterventionType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSigInterventionType_Organization");
            });

            modelBuilder.Entity<RefSingleSexClassStatus>(entity =>
            {
                entity.ToTable("RefSingleSexClassStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSingleSexClassStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSingleSexClassStatus_Organization");
            });

            modelBuilder.Entity<RefSpaceUseType>(entity =>
            {
                entity.ToTable("RefSpaceUseType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSpaceUseType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSpaceUseType_Organization");
            });

            modelBuilder.Entity<RefSpecialEducationAgeGroupTaught>(entity =>
            {
                entity.ToTable("RefSpecialEducationAgeGroupTaught", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSpecialEducationAgeGroupTaught)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSpecialEducationAgeGroupTaught_Organization");
            });

            modelBuilder.Entity<RefSpecialEducationExitReason>(entity =>
            {
                entity.ToTable("RefSpecialEducationExitReason", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSpecialEducationExitReason)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSpecialEducationExitReason_Organization");
            });

            modelBuilder.Entity<RefSpecialEducationStaffCategory>(entity =>
            {
                entity.ToTable("RefSpecialEducationStaffCategory", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSpecialEducationStaffCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSpecialEducationStaffCategory_Organization");
            });

            modelBuilder.Entity<RefStaffPerformanceLevel>(entity =>
            {
                entity.ToTable("RefStaffPerformanceLevel", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefStaffPerformanceLevel)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefStaffPerformanceLevel_Organization");
            });

            modelBuilder.Entity<RefStandardizedAdmissionTest>(entity =>
            {
                entity.ToTable("RefStandardizedAdmissionTest", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefStandardizedAdmissionTest)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefStandardizedAdmissionTest_Organization");
            });

            modelBuilder.Entity<RefState>(entity =>
            {
                entity.ToTable("RefState", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefState)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefState_Organization");
            });

            modelBuilder.Entity<RefStateAnsicode>(entity =>
            {
                entity.HasKey(e => e.Code)
                    .HasName("PK_RefStateANSICode");

                entity.ToTable("RefStateANSICode", "dbo");

                entity.Property(e => e.Code).HasColumnType("char(2)");

                entity.Property(e => e.StateName).HasMaxLength(100);
            });

            modelBuilder.Entity<RefStatePovertyDesignation>(entity =>
            {
                entity.ToTable("RefStatePovertyDesignation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefStatePovertyDesignation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefStatePovertyDesignation_Organization");
            });

            modelBuilder.Entity<RefStudentSupportServiceType>(entity =>
            {
                entity.ToTable("RefStudentSupportServiceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefStudentSupportServiceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefStudentSupportServiceType_Organization");
            });

            modelBuilder.Entity<RefSupervisedClinicalExperience>(entity =>
            {
                entity.ToTable("RefSupervisedClinicalExperience", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefSupervisedClinicalExperience)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefSupervisedClinicalExper_Organization");
            });

			modelBuilder.Entity<RefTargetedSupport>(entity =>
			{
				entity.ToTable("RefTargetedSupport", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefTargetedSupport)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefTargetedSupport_Org");
			});

			modelBuilder.Entity<RefTeacherEducationCredentialExam>(entity =>
            {
                entity.ToTable("RefTeacherEducationCredentialExam", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeacherEducationCredentialExam)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeacherEduCredentialExam_Organization");
            });

            modelBuilder.Entity<RefTeacherEducationExamScoreType>(entity =>
            {
                entity.ToTable("RefTeacherEducationExamScoreType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeacherEducationExamScoreType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeacherEduExamScoreType_Organization");
            });

            modelBuilder.Entity<RefTeacherEducationTestCompany>(entity =>
            {
                entity.ToTable("RefTeacherEducationTestCompany", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeacherEducationTestCompany)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeacherEduTestCompany_Organization");
            });

            modelBuilder.Entity<RefTeacherPrepCompleterStatus>(entity =>
            {
                entity.ToTable("RefTeacherPrepCompleterStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeacherPrepCompleterStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeacherPrepCompleterStatus_Organization");
            });

            modelBuilder.Entity<RefTeacherPrepEnrollmentStatus>(entity =>
            {
                entity.ToTable("RefTeacherPrepEnrollmentStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeacherPrepEnrollmentStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeacherPrepEnrollStatus_Organization");
            });

            modelBuilder.Entity<RefTeachingAssignmentRole>(entity =>
            {
                entity.ToTable("RefTeachingAssignmentRole", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeachingAssignmentRole)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeachingAssignmentRole_Organization");
            });

            modelBuilder.Entity<RefTeachingCredentialBasis>(entity =>
            {
                entity.ToTable("RefTeachingCredentialBasis", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeachingCredentialBasis)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeachingCredentialBasis_Organization");
            });

            modelBuilder.Entity<RefTeachingCredentialType>(entity =>
            {
                entity.ToTable("RefTeachingCredentialType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTeachingCredentialType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTeachingCredentialType_Organization");
            });

            modelBuilder.Entity<RefTechnicalAssistanceDeliveryType>(entity =>
            {
                entity.ToTable("RefTechnicalAssistanceDeliveryType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTechnicalAssistanceDeliveryType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTechnicalAssistanceDeliveryType_Organization");
            });

            modelBuilder.Entity<RefTechnicalAssistanceType>(entity =>
            {
                entity.ToTable("RefTechnicalAssistanceType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTechnicalAssistanceType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTechnicalAssistanceType_Organization");
            });

            modelBuilder.Entity<RefTechnologyLiteracyStatus>(entity =>
            {
                entity.ToTable("RefTechnologyLiteracyStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTechnologyLiteracyStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTechnologyLiteracyStatus_Organization");
            });

            modelBuilder.Entity<RefTelephoneNumberType>(entity =>
            {
                entity.ToTable("RefTelephoneNumberType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTelephoneNumberType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTelephoneNumberType_Organization");
            });

            modelBuilder.Entity<RefTenureSystem>(entity =>
            {
                entity.ToTable("RefTenureSystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTenureSystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTenureSystem_Organization");
            });

            modelBuilder.Entity<RefTextComplexitySystem>(entity =>
            {
                entity.ToTable("RefTextComplexitySystem", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTextComplexitySystem)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTextComplexitySystem_Organization");
            });

            modelBuilder.Entity<RefTimeForCompletionUnits>(entity =>
            {
                entity.ToTable("RefTimeForCompletionUnits", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTimeForCompletionUnits)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTimeForCompletionUnits_Organization");
            });

            modelBuilder.Entity<RefTitleIiiaccountability>(entity =>
            {
                entity.ToTable("RefTitleIIIAccountability", "dbo");

                entity.Property(e => e.RefTitleIiiaccountabilityId).HasColumnName("RefTitleIIIAccountabilityId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIiiaccountability)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIIIAccountability_Organization");
            });

            modelBuilder.Entity<RefTitleIiilanguageInstructionProgramType>(entity =>
            {
                entity.ToTable("RefTitleIIILanguageInstructionProgramType", "dbo");

                entity.Property(e => e.RefTitleIiilanguageInstructionProgramTypeId).HasColumnName("RefTitleIIILanguageInstructionProgramTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIiilanguageInstructionProgramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefLanguageInstruction_Organization");
            });

            modelBuilder.Entity<RefTitleIiiprofessionalDevelopmentType>(entity =>
            {
                entity.ToTable("RefTitleIIIProfessionalDevelopmentType", "dbo");

                entity.Property(e => e.RefTitleIiiprofessionalDevelopmentTypeId).HasColumnName("RefTitleIIIProfessionalDevelopmentTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIiiprofessionalDevelopmentType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIIIProfessionalDevType_Organization");
            });

            modelBuilder.Entity<RefTitleIindicator>(entity =>
            {
                entity.ToTable("RefTitleIIndicator", "dbo");

                entity.Property(e => e.RefTitleIindicatorId).HasColumnName("RefTitleIIndicatorId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIindicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIIndicator_Organization");
            });

            modelBuilder.Entity<RefTitleIinstructionalServices>(entity =>
            {
                entity.ToTable("RefTitleIInstructionalServices", "dbo");

                entity.Property(e => e.RefTitleIinstructionalServicesId).HasColumnName("RefTitleIInstructionalServicesId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIinstructionalServices)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIInstructionalServices_Organization");
            });

            modelBuilder.Entity<RefTitleIprogramStaffCategory>(entity =>
            {
                entity.ToTable("RefTitleIProgramStaffCategory", "dbo");

                entity.Property(e => e.RefTitleIprogramStaffCategoryId).HasColumnName("RefTitleIProgramStaffCategoryId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIprogramStaffCategory)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIProgramStaffCategory_Organization");
            });

            modelBuilder.Entity<RefUnexperiencedStatus>(entity =>
            {
                entity.ToTable("RefUnexperiencedStatus", "dbo");

                entity.Property(e => e.RefUnexperiencedStatusId).HasColumnName("RefUnexperiencedStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefUnexperiencedStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefUnexperiencedStatus_Organization");
            });

            modelBuilder.Entity<RefOutOfFieldStatus>(entity =>
            {
                entity.ToTable("RefOutOfFieldStatus", "dbo");

                entity.Property(e => e.RefOutOfFieldStatusId).HasColumnName("RefOutOfFieldStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefOutOfFieldStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefOutOfFieldStatus_Organization");
            });

            modelBuilder.Entity<RefEmergencyOrProvisionalCredentialStatus>(entity =>
            {
                entity.ToTable("RefEmergencyOrProvisionalCredentialStatus", "dbo");

                entity.Property(e => e.RefEmergencyOrProvisionalCredentialStatusId).HasColumnName("RefEmergencyOrProvisionalCredentialStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefEmergencyOrProvisionalCredentialStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefEmergencyOrProvisionalCredentialStatus_Organization");
            });

            modelBuilder.Entity<RefTitleIprogramType>(entity =>
            {
                entity.ToTable("RefTitleIProgramType", "dbo");

                entity.Property(e => e.RefTitleIprogramTypeId).HasColumnName("RefTitleIProgramTypeId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIprogramType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitleIProgramType_Organization");
            });

            modelBuilder.Entity<RefTitleIschoolStatus>(entity =>
            {
                entity.HasKey(e => e.RefTitle1SchoolStatusId)
                    .HasName("XPKRefTitle1Status");

                entity.ToTable("RefTitleISchoolStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Definition).HasMaxLength(400);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTitleIschoolStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTitle1SchoolStatus_Organization");
            });

            modelBuilder.Entity<RefTransferOutIndicator>(entity =>
            {
                entity.ToTable("RefTransferOutIndicator", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTransferOutIndicator)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTransferOutIndicator_Organization");
            });

            modelBuilder.Entity<RefTransferReady>(entity =>
            {
                entity.ToTable("RefTransferReady", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTransferReady)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTransferReady_Organization");
            });

            modelBuilder.Entity<RefTribalAffiliation>(entity =>
            {
                entity.ToTable("RefTribalAffiliation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(60);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTribalAffiliation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTribalAffiliation_Organization");
            });

            modelBuilder.Entity<RefTrimesterWhenPrenatalCareBegan>(entity =>
            {
                entity.ToTable("RefTrimesterWhenPrenatalCareBegan", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTrimesterWhenPrenatalCareBegan)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTrimesterWhenPrenatalCareBegan_Organization");
            });

            modelBuilder.Entity<RefTuitionResidencyType>(entity =>
            {
                entity.ToTable("RefTuitionResidencyType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTuitionResidencyType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTuitionResidencyType_Organization");
            });

            modelBuilder.Entity<RefTuitionUnit>(entity =>
            {
                entity.ToTable("RefTuitionUnit", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefTuitionUnit)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefTuitionUnit_Organization");
            });

			modelBuilder.Entity<RefUnexperiencedStatus>(entity =>
			{
				entity.ToTable("RefUnexperiencedStatus", "dbo");

				entity.Property(e => e.Code).HasMaxLength(50);

				entity.Property(e => e.Description)
					.IsRequired()
					.HasMaxLength(100);

				entity.Property(e => e.SortOrder).HasColumnType("decimal");

				entity.HasOne(d => d.RefJurisdiction)
					.WithMany(p => p.RefUnexperiencedStatus)
					.HasForeignKey(d => d.RefJurisdictionId)
					.HasConstraintName("FK_RefUnexperiencedStatus_Org");
			});

			modelBuilder.Entity<RefUscitizenshipStatus>(entity =>
            {
                entity.ToTable("RefUSCitizenshipStatus", "dbo");

                entity.Property(e => e.RefUscitizenshipStatusId).HasColumnName("RefUSCitizenshipStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefUscitizenshipStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefUSCitizenshipStatus_Organization");
            });

            modelBuilder.Entity<RefVisaType>(entity =>
            {
                entity.ToTable("RefVisaType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefVisaType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefVisaType_Organization");
            });

            modelBuilder.Entity<RefVisionScreeningStatus>(entity =>
            {
                entity.ToTable("RefVisionScreeningStatus", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefVisionScreeningStatus)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefVision_Org");
            });

            modelBuilder.Entity<RefWageCollectionMethod>(entity =>
            {
                entity.ToTable("RefWageCollectionMethod", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefWageCollectionMethod)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefWageCollectionMethod_Organization");
            });

            modelBuilder.Entity<RefWageVerification>(entity =>
            {
                entity.ToTable("RefWageVerification", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefWageVerification)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefWageVerification_Organization");
            });

            modelBuilder.Entity<RefWeaponType>(entity =>
            {
                entity.ToTable("RefWeaponType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefWeaponType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefWeaponType_Organization");
            });

            modelBuilder.Entity<RefWfProgramParticipation>(entity =>
            {
                entity.ToTable("RefWfProgramParticipation", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefWfProgramParticipation)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefWFProgramParticipation_Organization");
            });

            modelBuilder.Entity<RefWorkbasedLearningOpportunityType>(entity =>
            {
                entity.ToTable("RefWorkbasedLearningOpportunityType", "dbo");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.RefWorkbasedLearningOpportunityType)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefWorkbasedLearningOpportunityType_Organization");
            });

            modelBuilder.Entity<RequiredImmunization>(entity =>
            {
                entity.ToTable("RequiredImmunization", "dbo");

                entity.HasIndex(e => new { e.OrganizationId, e.RefImmunizationTypeId })
                    .IsUnique();

                entity.HasOne(d => d.Organization)
                    .WithMany(p => p.RequiredImmunization)
                    .HasForeignKey(d => d.OrganizationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RequiredImmunization_Organization");

                entity.HasOne(d => d.RefImmunizationType)
                    .WithMany(p => p.RequiredImmunization)
                    .HasForeignKey(d => d.RefImmunizationTypeId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RequiredImmunization_RefImmunization");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("Role", "dbo");

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.HasOne(d => d.RefJurisdiction)
                    .WithMany(p => p.Role)
                    .HasForeignKey(d => d.RefJurisdictionId)
                    .HasConstraintName("FK_RefRole_Org");
            });

            modelBuilder.Entity<RoleAttendance>(entity =>
            {
                entity.ToTable("RoleAttendance", "dbo");

                entity.Property(e => e.AttendanceRate).HasColumnType("decimal");

                entity.Property(e => e.NumberOfDaysAbsent).HasColumnType("decimal");

                entity.Property(e => e.NumberOfDaysInAttendance).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.RoleAttendance)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RoleAttendance_OrganizationPersonRole");
            });

            modelBuilder.Entity<RoleAttendanceEvent>(entity =>
            {
                entity.ToTable("RoleAttendanceEvent", "dbo");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefOrganizationPersonRole");

                entity.HasOne(d => d.RefAbsentAttendanceCategory)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.RefAbsentAttendanceCategoryId)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefAbsentAttendanceCategory");

                entity.HasOne(d => d.RefAttendanceEventType)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.RefAttendanceEventTypeId)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefAttendanceEventType");

                entity.HasOne(d => d.RefAttendanceStatus)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.RefAttendanceStatusId)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefAttendanceStatus");

                entity.HasOne(d => d.RefLeaveEventType)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.RefLeaveEventTypeId)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefLeaveEventType");

                entity.HasOne(d => d.RefPresentAttendanceCategory)
                    .WithMany(p => p.RoleAttendanceEvent)
                    .HasForeignKey(d => d.RefPresentAttendanceCategoryId)
                    .HasConstraintName("FK_RoleAttendanceEvent_RefPresentAttendanceCategory");
            });

            modelBuilder.Entity<RoleStatus>(entity =>
            {
                entity.ToTable("RoleStatus", "dbo");

                entity.Property(e => e.StatusEndDate).HasColumnType("datetime");

                entity.Property(e => e.StatusStartDate).HasColumnType("date");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.RoleStatus)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RoleStatus_OrganizationPersonRole");

                entity.HasOne(d => d.RefRoleStatus)
                    .WithMany(p => p.RoleStatus)
                    .HasForeignKey(d => d.RefRoleStatusId)
                    .HasConstraintName("FK_RoleStatus_RefRefRoleStatus");
            });

            modelBuilder.Entity<Rubric>(entity =>
            {
                entity.ToTable("Rubric", "dbo");

                entity.Property(e => e.Identifier).HasMaxLength(40);

                entity.Property(e => e.Title).HasMaxLength(30);

                entity.Property(e => e.UrlReference).HasMaxLength(300);
            });

            modelBuilder.Entity<RubricCriterion>(entity =>
            {
                entity.ToTable("RubricCriterion", "dbo");

                entity.Property(e => e.Category).HasMaxLength(30);

                entity.Property(e => e.Title).HasMaxLength(30);

                entity.Property(e => e.Weight).HasColumnType("decimal");

                entity.HasOne(d => d.Rubric)
                    .WithMany(p => p.RubricCriterion)
                    .HasForeignKey(d => d.RubricId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RubricCriterion_Rubric");
            });

            modelBuilder.Entity<RubricCriterionLevel>(entity =>
            {
                entity.ToTable("RubricCriterionLevel", "dbo");

                entity.Property(e => e.Score).HasColumnType("decimal");

                entity.HasOne(d => d.RubricCriterion)
                    .WithMany(p => p.RubricCriterionLevel)
                    .HasForeignKey(d => d.RubricCriterionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_RubricCriterionLevel_RubricCriterion");
            });

            modelBuilder.Entity<ServicesReceived>(entity =>
            {
                entity.ToTable("ServicesReceived", "dbo");

                entity.Property(e => e.FullTimeEquivalency).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.ServicesReceived)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ServicesReceived_OrganizationPersonRole");

                entity.HasOne(d => d.RefServices)
                    .WithMany(p => p.ServicesReceived)
                    .HasForeignKey(d => d.RefServicesId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_ServicesReceived_RefServices");
            });

            modelBuilder.Entity<StaffCredential>(entity =>
            {
                entity.ToTable("StaffCredential", "dbo");

                entity.Property(e => e.CteinstructorIndustryCertification).HasColumnName("CTEInstructorIndustryCertification");

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasMaxLength(7);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime)
                    .HasColumnType("datetime");

                entity.HasOne(d => d.PersonCredential)
                    .WithMany(p => p.StaffCredential)
                    .HasForeignKey(d => d.PersonCredentialId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffCredential_PersonCredential");

                entity.HasOne(d => d.RefParaprofessionalQualification)
                    .WithMany(p => p.StaffCredential)
                    .HasForeignKey(d => d.RefParaprofessionalQualificationId)
                    .HasConstraintName("FK_StaffCredential_RefParaprofessionalQualification");

                entity.HasOne(d => d.RefProgramSponsorType)
                    .WithMany(p => p.StaffCredential)
                    .HasForeignKey(d => d.RefProgramSponsorTypeId)
                    .HasConstraintName("FK_StaffCredential_RefProgramSponsorType");

                entity.HasOne(d => d.RefTeachingCredentialBasis)
                    .WithMany(p => p.StaffCredential)
                    .HasForeignKey(d => d.RefTeachingCredentialBasisId)
                    .HasConstraintName("FK_StaffCredential_RefTeachingCredentialBasis");

                entity.HasOne(d => d.RefTeachingCredentialType)
                    .WithMany(p => p.StaffCredential)
                    .HasForeignKey(d => d.RefTeachingCredentialTypeId)
                    .HasConstraintName("FK_StaffCredential_RefTeachingCredentialType");
            });

            modelBuilder.Entity<StaffEmployment>(entity =>
            {
                entity.ToTable("StaffEmployment", "dbo");

                entity.Property(e => e.HireDate).HasColumnType("date");

                entity.Property(e => e.PositionTitle).HasMaxLength(45);

                entity.Property(e => e.UnionMembershipName).HasMaxLength(200);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.StaffEmployment)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffEmployment_OrganizationPersonRole");

                entity.HasOne(d => d.RefEmploymentSeparationReason)
                    .WithMany(p => p.StaffEmployment)
                    .HasForeignKey(d => d.RefEmploymentSeparationReasonId)
                    .HasConstraintName("FK_StaffEmployment_RefEmploymentSeparationReason");

                entity.HasOne(d => d.RefEmploymentSeparationType)
                    .WithMany(p => p.StaffEmployment)
                    .HasForeignKey(d => d.RefEmploymentSeparationTypeId)
                    .HasConstraintName("FK_StaffEmployment_RefEmploymentSeparationType");
            });

            modelBuilder.Entity<StaffEvaluation>(entity =>
            {
                entity.ToTable("StaffEvaluation", "dbo");

                entity.Property(e => e.Outcome).HasMaxLength(80);

                entity.Property(e => e.Scale).HasMaxLength(80);

                entity.Property(e => e.ScoreOrRating).HasMaxLength(60);

                entity.Property(e => e.System).HasMaxLength(60);

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.StaffEvaluation)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffEvaluation_OrganizationPersonRole");

                entity.HasOne(d => d.RefStaffPerformanceLevel)
                    .WithMany(p => p.StaffEvaluation)
                    .HasForeignKey(d => d.RefStaffPerformanceLevelId)
                    .HasConstraintName("FK_StaffEvaluation_RefStaffPerformanceLevel");
            });

            modelBuilder.Entity<StaffExperience>(entity =>
            {
                entity.HasKey(e => e.PersonId)
                    .HasName("PK_StaffExperience");

                entity.ToTable("StaffExperience", "dbo");

                entity.Property(e => e.PersonId).ValueGeneratedNever();

                entity.Property(e => e.YearsOfPriorAeteachingExperience)
                    .HasColumnName("YearsOfPriorAETeachingExperience")
                    .HasColumnType("decimal");

                entity.Property(e => e.YearsOfPriorTeachingExperience).HasColumnType("decimal");

                entity.HasOne(d => d.Person)
                    .WithOne(p => p.StaffExperience)
                    .HasForeignKey<StaffExperience>(d => d.PersonId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffExperience_Person");
            });

            modelBuilder.Entity<StaffProfessionalDevelopmentActivity>(entity =>
            {
                entity.ToTable("StaffProfessionalDevelopmentActivity", "dbo");

                entity.Property(e => e.ActivityCompletionDate).HasColumnType("date");

                entity.Property(e => e.ActivityIdentifier).HasMaxLength(40);

                entity.Property(e => e.ActivityStartDate).HasColumnType("date");

                entity.Property(e => e.ActivityTitle).HasMaxLength(50);

                entity.Property(e => e.NumberOfCreditsEarned).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffPDActivity_OrgPersonRole");

                entity.HasOne(d => d.ProfessionalDevelopmentActivity)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.ProfessionalDevelopmentActivityId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffPDActivity_PDActivity");

                entity.HasOne(d => d.ProfessionalDevelopmentRequirement)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.ProfessionalDevelopmentRequirementId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_PDActivity_PDRequirement");

                entity.HasOne(d => d.ProfessionalDevelopmentSession)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.ProfessionalDevelopmentSessionId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffPDActivity_PDSession");

                entity.HasOne(d => d.RefCourseCreditUnit)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefCourseCreditUnitId)
                    .HasConstraintName("FK_PDActivity_RefCourseCreditUnit");

                entity.HasOne(d => d.RefProfessionalDevelopmentFinancialSupport)
                    .WithMany(p => p.StaffProfessionalDevelopmentActivity)
                    .HasForeignKey(d => d.RefProfessionalDevelopmentFinancialSupportId)
                    .HasConstraintName("FK_PDActivity_RefProfDevFinancialSupport");
            });

            modelBuilder.Entity<StaffTechnicalAssistance>(entity =>
            {
                entity.ToTable("StaffTechnicalAssistance", "dbo");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithMany(p => p.StaffTechnicalAssistance)
                    .HasForeignKey(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_StaffTechnicalAssistance_OrgPersonRole");

                entity.HasOne(d => d.RefTechnicalAssistanceDeliveryType)
                    .WithMany(p => p.StaffTechnicalAssistance)
                    .HasForeignKey(d => d.RefTechnicalAssistanceDeliveryTypeId)
                    .HasConstraintName("FK_StaffTechnicalAssistance_RefTechnicalAssistanceDeliveryType");

                entity.HasOne(d => d.RefTechnicalAssistanceType)
                    .WithMany(p => p.StaffTechnicalAssistance)
                    .HasForeignKey(d => d.RefTechnicalAssistanceTypeId)
                    .HasConstraintName("FK_StaffTechnicalAssistance_RefTechnicalAssistanceType");
            });

            modelBuilder.Entity<TeacherEducationCredentialExam>(entity =>
            {
                entity.ToTable("TeacherEducationCredentialExam", "dbo");

                entity.HasOne(d => d.ProgramParticipationTeacherPrep)
                    .WithMany(p => p.TeacherEducationCredentialExam)
                    .HasForeignKey(d => d.ProgramParticipationTeacherPrepId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_TeacherEducationCredentialExam_PrgmParticipationTeacherPrep");

                entity.HasOne(d => d.RefTeacherEducationCredentialExam)
                    .WithMany(p => p.TeacherEducationCredentialExam)
                    .HasForeignKey(d => d.RefTeacherEducationCredentialExamId)
                    .HasConstraintName("FK_TeacherEduCredentialExam_RefTeacherEduCredentialExam");

                entity.HasOne(d => d.RefTeacherEducationExamScoreType)
                    .WithMany(p => p.TeacherEducationCredentialExam)
                    .HasForeignKey(d => d.RefTeacherEducationExamScoreTypeId)
                    .HasConstraintName("FK_TeacherEduCredentialExam_RefTeacherEduExamScoreType");

                entity.HasOne(d => d.RefTeacherEducationTestCompany)
                    .WithMany(p => p.TeacherEducationCredentialExam)
                    .HasForeignKey(d => d.RefTeacherEducationTestCompanyId)
                    .HasConstraintName("FK_TeacherEducationCredentialExam_RefTeacherEducationTestCompny");
            });

            modelBuilder.Entity<TeacherStudentDataLinkExclusion>(entity =>
            {
                entity.ToTable("TeacherStudentDataLinkExclusion", "dbo");

                entity.Property(e => e.K12staffAssignmentId).HasColumnName("K12StaffAssignmentId");

                entity.HasOne(d => d.K12staffAssignment)
                    .WithMany(p => p.TeacherStudentDataLinkExclusion)
                    .HasForeignKey(d => d.K12staffAssignmentId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_TeacherStudentDataLinkExclusion_K12StaffAssignment");

                entity.HasOne(d => d.StudentOrganizationPersonRole)
                    .WithMany(p => p.TeacherStudentDataLinkExclusion)
                    .HasForeignKey(d => d.StudentOrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_TeacherStudentDataLinkExclusion_K12StudentCourseSection");
            });

            modelBuilder.Entity<WorkforceEmploymentQuarterlyData>(entity =>
            {
                entity.HasKey(e => e.OrganizationPersonRoleId)
                    .HasName("PK_WorkforceEmploymentQuarterlyData");

                entity.ToTable("WorkforceEmploymentQuarterlyData", "dbo");

                entity.Property(e => e.OrganizationPersonRoleId).ValueGeneratedNever();

                entity.Property(e => e.EmployedInMultipleJobsCount).HasColumnType("decimal");

                entity.HasOne(d => d.OrganizationPersonRole)
                    .WithOne(p => p.WorkforceEmploymentQuarterlyData)
                    .HasForeignKey<WorkforceEmploymentQuarterlyData>(d => d.OrganizationPersonRoleId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_WorkforceEmploymentQuarterlyData_OrganizationPersonRole");
            });

            modelBuilder.Entity<WorkforceProgramParticipation>(entity =>
            {
                entity.HasKey(e => e.PersonProgramParticipationId)
                    .HasName("PK_WorkforceProgramParticipation");

                entity.ToTable("WorkforceProgramParticipation", "dbo");

                entity.Property(e => e.PersonProgramParticipationId).ValueGeneratedNever();

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("nchar(7)");

                entity.HasOne(d => d.PersonProgramParticipation)
                    .WithOne(p => p.WorkforceProgramParticipation)
                    .HasForeignKey<WorkforceProgramParticipation>(d => d.PersonProgramParticipationId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_WorkforceProgramParticipation_PersonProgramParticipation");

                entity.HasOne(d => d.RefProfessionalTechnicalCredentialType)
                    .WithMany(p => p.WorkforceProgramParticipation)
                    .HasForeignKey(d => d.RefProfessionalTechnicalCredentialTypeId)
                    .HasConstraintName("FK_WorkforceProgramPartic_RefProfessionalTechnicalCredential");

                entity.HasOne(d => d.RefWfProgramParticipation)
                    .WithMany(p => p.WorkforceProgramParticipation)
                    .HasForeignKey(d => d.RefWfProgramParticipationId)
                    .HasConstraintName("FK_WorkforceProgramPartic_RefWfProgramParticipation");
            });

            modelBuilder.Entity<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus>(entity =>
            {
                entity.ToTable("RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus", "dbo");

                entity.Property(e => e.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId).HasColumnName("RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SortOrder).HasColumnType("decimal");  

                entity.HasOne(d => d.RefJurisdiction)
                  .WithMany(p => p.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus)
                  .HasForeignKey(d => d.RefJurisdictionId)
                  .HasConstraintName("FK_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus_Organization");

                           
            });
        }
    }
}