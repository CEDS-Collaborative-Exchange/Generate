using System;
using generate.core.Config;
using generate.core.Models.Staging;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace generate.infrastructure.Contexts
{
    public partial class StagingDbContext : DbContext
    {
        public StagingDbContext(DbContextOptions<StagingDbContext> options) : base(options)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            // Not Configuring anything
        }

        public virtual DbSet<Assessment> Assessment { get; set; }
        public virtual DbSet<AssessmentResult> AssessmentResult { get; set; }
        public virtual DbSet<CharterSchoolAuthorizer> CharterSchoolAuthorizer { get; set; }
        public virtual DbSet<CharterSchoolManagementOrganization> CharterSchoolManagementOrganization { get; set; }
        public virtual DbSet<DataCollection> DataCollection { get; set; }
        public virtual DbSet<Discipline> Discipline { get; set; }
        public virtual DbSet<Disability> Disabilities { get; set; }
        public virtual DbSet<IndicatorStatusCustomType> IndicatorStatusCustomType { get; set; }
        public virtual DbSet<K12Enrollment> K12Enrollment { get; set; }
        public virtual DbSet<K12Organization> K12Organization { get; set; }
        public virtual DbSet<K12ProgramEnrollment> K12ProgramParticipation { get; set; }
        public virtual DbSet<K12SchoolComprehensiveSupportIdentificationType> K12SchoolComprehensiveSupportIdentificationType { get; set; }
        public virtual DbSet<K12SchoolTargetedSupportIdentificationType> K12SchoolTargetedSupportIdentificationType { get; set; }
        public virtual DbSet<K12StaffAssignment> K12StaffAssignment { get; set; }
        public virtual DbSet<K12StudentCourseSection> K12StudentCourseSection { get; set; }
        public virtual DbSet<Migrant> Migrant { get; set; }
        public virtual DbSet<OrganizationAddress> OrganizationAddress { get; set; }
        public virtual DbSet<OrganizationCalendarSession> OrganizationCalendarSession { get; set; }
        public virtual DbSet<OrganizationCustomSchoolIndicatorStatusType> OrganizationCustomSchoolIndicatorStatusType { get; set; }
        public virtual DbSet<OrganizationFederalFunding> OrganizationFederalFunding { get; set; }
        public virtual DbSet<OrganizationGradeOffered> OrganizationGradeOffered { get; set; }
        public virtual DbSet<OrganizationPhone> OrganizationPhone { get; set; }
        public virtual DbSet<OrganizationProgramType> OrganizationProgramType { get; set; }
        public virtual DbSet<OrganizationSchoolComprehensiveAndTargetedSupport> OrganizationSchoolComprehensiveAndTargetedSupport { get; set; }
        public virtual DbSet<OrganizationSchoolIndicatorStatus> OrganizationSchoolIndicatorStatus { get; set; }
        public virtual DbSet<K12PersonRace> PersonRace { get; set; }
        public virtual DbSet<PersonStatus> PersonStatus { get; set; }
        public virtual DbSet<ProgramParticipationCte> ProgramParticipationCte { get; set; }
        public virtual DbSet<ProgramParticipationNorDClass> ProgramParticipationNorD { get; set; }
        public virtual DbSet<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducation { get; set; }
        public virtual DbSet<IdeaDisabilityType> IdeaDisbilityType { get; set; }
        public virtual DbSet<ProgramParticipationTitleI> ProgramParticipationTitleI { get; set; }
        public virtual DbSet<ProgramParticipationTitleIII> ProgramParticipationTitleIII { get; set; }
        public virtual DbSet<PsInstitution> PsInstitution { get; set; }
        public virtual DbSet<PsStudentAcademicAward> PsStudentAcademicAward { get; set; }
        public virtual DbSet<PsStudentAcademicRecord> PsStudentAcademicRecord { get; set; }
        public virtual DbSet<PsStudentEnrollment> PsStudentEnrollment { get; set; }
        public virtual DbSet<SourceSystemReferenceData> SourceSystemReferenceData { get; set; }
        public virtual DbSet<StateDefinedCustomIndicator> StateDefinedCustomIndicator { get; set; }
        public virtual DbSet<StateDetail> StateDetail { get; set; }
        public virtual DbSet<StagingValidationResult> StagingValidationResult { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.6-servicing-10079");

            modelBuilder.Entity<Assessment>(entity =>
            {
                entity.ToTable("Assessment", "Staging");

                entity.Property(e => e.AssessmentAcademicSubject)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentAdministrationFinishDate).HasColumnType("date");

                entity.Property(e => e.AssessmentAdministrationStartDate).HasColumnType("date");

                entity.Property(e => e.AssessmentFamilyShortName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentFamilyTitle)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentIdentifier)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentPerformanceLevelIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentPerformanceLevelLabel)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentPurpose)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentShortName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentTitle)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentTypeAdministered)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentTypeAdministeredToEnglishLearners)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<AssessmentResult>(entity =>
            {
                entity.ToTable("AssessmentResult", "Staging");

                entity.Property(e => e.AssessmentAcademicSubject)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentAdministrationFinishDate).HasColumnType("date");

                entity.Property(e => e.AssessmentAdministrationStartDate).HasColumnType("date");

                entity.Property(e => e.AssessmentPerformanceLevelIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentPerformanceLevelLabel)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentPurpose)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentRegistrationReasonNotCompleting)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentRegistrationReasonNotTested)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentScoreMetricType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentIdentifier)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentTitle)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.AssessmentTypeAdministered)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.GradeLevelWhenAssessed)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEAFullAcademicYear)
                    .HasColumnName("LEAFullAcademicYear")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolFullAcademicYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ScoreValue)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.StateFullAcademicYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<CharterSchoolAuthorizer>(entity =>
            {
                entity.ToTable("CharterSchoolAuthorizer", "Staging");

                entity.Property(e => e.CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea)
                    .HasColumnName("CharterSchoolAuthorizer_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CharterSchoolAuthorizingOrganizationOrganizationName)
                    .HasColumnName("CharterSchoolAuthorizer_Name")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CharterSchoolAuthorizerType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<CharterSchoolManagementOrganization>(entity =>
            {
                entity.ToTable("CharterSchoolManagementOrganization", "Staging");

                entity.Property(e => e.CharterSchoolManagementOrganization_Identifier_EIN)
                    .HasColumnName("CharterSchoolManagementOrganization_Identifier_EIN")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CharterSchoolManagementOrganization_Name)
                    .HasColumnName("CharterSchoolManagementOrganization_Name")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CharterSchoolManagementOrganization_Type)
                    .HasColumnName("CharterSchoolManagementOrganization_Type")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.OrganizationIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<DataCollection>(entity =>
            {
                entity.ToTable("DataCollection", "Staging");

                entity.Property(e => e.DataCollectionAcademicSchoolYear)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionCloseDate).HasColumnType("datetime");

                entity.Property(e => e.DataCollectionDescription)
                    .HasMaxLength(800)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionOpenDate).HasColumnType("datetime");

                entity.Property(e => e.DataCollectionSchoolYear)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.SourceSystemName)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Discipline>(entity =>
            {
                entity.ToTable("Discipline", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.DisciplinaryActionEndDate).HasColumnType("date");

                entity.Property(e => e.DisciplinaryActionStartDate).HasColumnType("date");

                entity.Property(e => e.DisciplinaryActionTaken)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DisciplineActionIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DisciplineMethodFirearm)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DisciplineMethodOfCwd)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DisciplineReason)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DurationOfDisciplinaryAction)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FirearmType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IdeaInterimRemoval)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IdeaInterimRemovalReason)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IDEADisciplineMethodFirearm)
                    .HasColumnName("IDEADisciplineMethodFirearm")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IncidentDate).HasColumnType("date");

                entity.Property(e => e.IncidentIdentifier)
                    .HasMaxLength(40)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.WeaponType)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Disability>(entity =>
            {
                entity.ToTable("Disability", "Staging");

                entity.Property(e => e.StudentIdentifierState).HasMaxLength(80);
                entity.Property(e => e.LeaIdentifierSeaAccountability).HasMaxLength(100);
                entity.Property(e => e.LeaIdentifierSeaAttendance).HasMaxLength(100);
                entity.Property(e => e.LeaIdentifierSeaFunding).HasMaxLength(100);
                entity.Property(e => e.LeaIdentifierSeaGraduation).HasMaxLength(100);
                entity.Property(e => e.LeaIdentifierSeaIndividualizedEducationProgram).HasMaxLength(100);
                entity.Property(e => e.SchoolIdentifierSea).HasMaxLength(100);
            });

            modelBuilder.Entity<IndicatorStatusCustomType>(entity =>
            {
                entity.ToTable("IndicatorStatusCustomType", "Staging");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.Description).HasMaxLength(100);
            });

            modelBuilder.Entity<K12Enrollment>(entity =>
            {
                entity.ToTable("K12Enrollment", "Staging");

                entity.Property(e => e.AttendanceRate).HasColumnType("decimal(5, 4)");

                entity.Property(e => e.Birthdate).HasColumnType("date");

                entity.Property(e => e.CohortDescription).HasMaxLength(1024);

                entity.Property(e => e.CohortGraduationYear).HasMaxLength(4);

                entity.Property(e => e.CohortYear).HasMaxLength(4);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("date");

                entity.Property(e => e.EnrollmentEntryDate).HasColumnType("date");

                entity.Property(e => e.EnrollmentExitDate).HasColumnType("date");

                entity.Property(e => e.ExitOrWithdrawalType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FirstName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FoodServiceEligibility)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.GradeLevel)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.HighSchoolDiplomaType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LastOrSurname)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MiddleName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.NumberOfDaysAbsent).HasColumnType("decimal(9, 2)");

                entity.Property(e => e.NumberOfSchoolDays).HasColumnType("decimal(9, 2)");

                entity.Property(e => e.ProjectedGraduationDate)
                    .HasMaxLength(8)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Sex)
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12Organization>(entity =>
            {
                entity.ToTable("K12Organization", "Staging");

                entity.Property(e => e.School_AdministrativeFundingControl).HasMaxLength(100);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.IeuIdentifierSea)
                    .HasColumnName("IeuIdentifierSea")
                    .HasMaxLength(100);

                entity.Property(e => e.IEU_OrganizationName)
                    .HasColumnName("IEU_Name")
                    .HasMaxLength(256);

                entity.Property(e => e.IEU_OrganizationOperationalStatus)
                    .HasColumnName("IEU_OrganizationOperationalStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);


                entity.Property(e => e.IEU_OperationalStatusEffectiveDate)
                    .HasColumnName("IEU_OperationalStatusEffectiveDate")
                    .HasColumnType("datetime");

                entity.Property(e => e.IEU_RecordEndDateTime)
                    .HasColumnName("IEU_RecordEndDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.IEU_RecordStartDateTime)
                    .HasColumnName("IEU_RecordStartDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.IEU_WebSiteAddress)
                    .HasColumnName("IEU_WebSiteAddress")
                    .HasMaxLength(300);

                entity.Property(e => e.LEA_CharterLeaStatus)
                    .HasColumnName("LEA_CharterLeaStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_CharterSchoolIndicator).HasColumnName("LEA_CharterSchoolIndicator");

                entity.Property(e => e.LEA_GunFreeSchoolsActReportingStatus)
                    .HasColumnName("LEA_GunFreeSchoolsActReportingStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierNCES)
                    .HasColumnName("LEA_Identifier_NCES")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSea)
                    .HasColumnName("LEA_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_IsReportedFederally).HasColumnName("LEA_IsReportedFederally");

                entity.Property(e => e.LEA_K12LeaTitleISupportService)
                    .HasColumnName("LEA_K12LeaTitleISupportService")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_McKinneyVentoSubgrantRecipient).HasColumnName("LEA_McKinneyVentoSubgrantRecipient");

                entity.Property(e => e.LEA_MepProjectType)
                    .HasColumnName("LEA_MepProjectType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaOrganizationName)
                    .HasColumnName("LEA_Name")
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_OperationalStatus)
                    .HasColumnName("LEA_OperationalStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_OperationalStatusEffectiveDate)
                    .HasColumnName("LEA_OperationalStatusEffectiveDate")
                    .HasColumnType("datetime");

                entity.Property(e => e.LEA_RecordEndDateTime)
                    .HasColumnName("LEA_RecordEndDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.LEA_RecordStartDateTime)
                    .HasColumnName("LEA_RecordStartDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.LEA_SupervisoryUnionIdentificationNumber)
                    .HasColumnName("LEA_SupervisoryUnionIdentificationNumber")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_TitleIinstructionalService)
                    .HasColumnName("LEA_TitleIinstructionalService")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_TitleIProgramType)
                    .HasColumnName("LEA_TitleIProgramType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_Type)
                    .HasColumnName("LEA_Type")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LEA_WebSiteAddress)
                    .HasColumnName("LEA_WebSiteAddress")
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.NewIEU).HasColumnName("NewIEU");

                entity.Property(e => e.NewLEA).HasColumnName("NewLEA");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.School_CharterContractApprovalDate)
                    .HasColumnName("School_CharterContractApprovalDate")
                    .HasColumnType("datetime");

                entity.Property(e => e.School_CharterContractIDNumber)
                    .HasColumnName("School_CharterContractIDNumber")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_CharterContractRenewalDate)
                    .HasColumnName("School_CharterContractRenewalDate")
                    .HasColumnType("datetime");

                entity.Property(e => e.School_CharterPrimaryAuthorizer)
                    .HasColumnName("School_CharterPrimaryAuthorizer")
                    .HasMaxLength(100)
                    .IsUnicode(false);


                entity.Property(e => e.School_CharterSchoolFEIN)
                    .HasColumnName("School_CharterSchoolFEIN")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_CharterSchoolFEIN_Update)
                    .HasColumnName("School_CharterSchoolFEIN_Update")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_CharterSchoolIndicator).HasColumnName("School_CharterSchoolIndicator");

                entity.Property(e => e.School_CharterSchoolOpenEnrollmentIndicator).HasColumnName("School_CharterSchoolOpenEnrollmentIndicator");

                entity.Property(e => e.School_CharterSecondaryAuthorizer)
                    .HasColumnName("School_CharterSecondaryAuthorizer")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_ComprehensiveAndTargetedSupport)
                    .HasColumnName("School_ComprehensiveAndTargetedSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_ComprehensiveSupport)
                    .HasColumnName("School_ComprehensiveSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_GunFreeSchoolsActReportingStatus)
                    .HasColumnName("School_GunFreeSchoolsActReportingStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierNCES)
                    .HasColumnName("School_Identifier_NCES")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("School_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_SchoolImprovementAllocation).HasColumnType("money");

                entity.Property(e => e.School_IndicatorStatusType)
                    .HasColumnName("School_IndicatorStatusType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_IsReportedFederally).HasColumnName("School_IsReportedFederally");

                entity.Property(e => e.School_MagnetOrSpecialProgramEmphasisSchool)
                    .HasColumnName("School_MagnetOrSpecialProgramEmphasisSchool")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_MigrantEducationProgramProjectType)
                    .HasColumnName("School_MepProjectType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolOrganizationName)
                    .HasColumnName("School_Name")
                    .HasMaxLength(256)
                    .IsUnicode(false);

                entity.Property(e => e.School_NationalSchoolLunchProgramStatus)
                    .HasColumnName("School_NationalSchoolLunchProgramStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_OperationalStatus)
                    .HasColumnName("School_OperationalStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_OperationalStatusEffectiveDate)
                    .HasColumnName("School_OperationalStatusEffectiveDate")
                    .HasColumnType("datetime");

                entity.Property(e => e.School_ProgressAchievingEnglishLanguageProficiencyIndicatorType)
                    .HasColumnName("School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus)
                    .HasColumnName("School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_ReconstitutedStatus)
                    .HasColumnName("School_ReconstitutedStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_RecordEndDateTime)
                    .HasColumnName("School_RecordEndDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.School_RecordStartDateTime)
                    .HasColumnName("School_RecordStartDateTime")
                    .HasColumnType("datetime");

                entity.Property(e => e.School_SchoolDangerousStatus)
                    .HasColumnName("School_SchoolDangerousStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_SharedTimeIndicator)
                    .HasColumnName("School_SharedTimeIndicator")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_StatePovertyDesignation)
                    .HasColumnName("School_StatePovertyDesignation")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_TargetedSupport)
                    .HasColumnName("School_TargetedSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_Type)
                    .HasColumnName("School_Type")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_VirtualSchoolStatus)
                    .HasColumnName("School_VirtualSchoolStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_WebSiteAddress)
                    .HasColumnName("School_WebSiteAddress")
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.School_TitleISchoolStatus)
                    .HasColumnName("TitleIPartASchoolDesignation")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12ProgramEnrollment>(entity =>
            {
                entity.ToTable("K12ProgramParticipation", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.Property(e => e.OrganizationIdentifier)
                    .IsRequired()
                    .HasMaxLength(60);

                entity.Property(e => e.OrganizationType).HasMaxLength(100);

                entity.Property(e => e.ProgramType).HasMaxLength(100);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("Student_Identifier_State")
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<K12SchoolComprehensiveSupportIdentificationType>(entity =>
            {
                entity.ToTable("K12SchoolComprehensiveSupportIdentificationType", "Staging");

                entity.Property(e => e.ComprehensiveSupport)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.ComprehensiveSupportReasonApplicability)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.LEAIdentifierSea)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(4)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12SchoolTargetedSupportIdentificationType>(entity =>
            {
                entity.ToTable("K12SchoolTargetedSupportIdentificationType", "Staging");

                entity.Property(e => e.ComprehensiveSupportReasonApplicability)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.LEAIdentifierState)
                    .HasColumnName("LEA_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierState)
                    .HasColumnName("School_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(4)
                    .IsUnicode(false);

                entity.Property(e => e.Subgroup)
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12StaffAssignment>(entity =>
            {
                entity.ToTable("K12StaffAssignment", "Staging");

                entity.Property(e => e.AssignmentEndDate).HasColumnType("date");

                entity.Property(e => e.AssignmentStartDate).HasColumnType("date");

                entity.Property(e => e.CredentialExpirationDate).HasColumnType("date");

                entity.Property(e => e.CredentialIssuanceDate).HasColumnType("date");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.FullTimeEquivalency).HasColumnType("decimal(5, 4)");

                entity.Property(e => e.EdFactsTeacherInexperiencedStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.K12StaffClassification)
                    .HasColumnName("K12StaffClassification")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSea)
                    .HasColumnName("LeaIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.EDFactsTeacherOutOfFieldStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ParaprofessionalQualificationStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StaffMemberIdentifierState)
                    .HasColumnName("Personnel_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgramTypeCode)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("date");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("date");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SpecialEducationAgeGroupTaught)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SpecialEducationStaffCategory)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TitleIProgramStaffCategory)
                    .HasColumnName("TitleIProgramStaffCategory")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12StudentCourseSection>(entity =>
            {
                entity.ToTable("K12StudentCourseSection", "Staging");

                entity.Property(e => e.CourseGradeLevel)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.CourseLevelCharacteristic).HasMaxLength(50);

                entity.Property(e => e.CourseRecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.ScedCourseCode).HasMaxLength(50);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("Student_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Migrant>(entity =>
            {
                entity.ToTable("Migrant", "Staging");

                entity.Property(e => e.ContinuationOfServicesReason)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.LastQualifyingMoveDate).HasColumnType("date");

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MigrantEducationProgramEnrollmentType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MigrantEducationProgramServicesType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MigrantStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MigrantStudentQualifyingArrivalDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationExitDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationStartDate).HasColumnType("date");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationAddress>(entity =>
            {
                entity.ToTable("OrganizationAddress", "Staging");

                entity.Property(e => e.AddressApartmentRoomOrSuiteNumber)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.AddressCity)
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.AddressCountyAnsiCodeCode).HasMaxLength(7);

                entity.Property(e => e.AddressPostalCode)
                    .HasMaxLength(17)
                    .IsUnicode(false);

                entity.Property(e => e.AddressStreetNumberAndName)
                    .HasMaxLength(150)
                    .IsUnicode(false);

                entity.Property(e => e.AddressTypeForOrganization)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.Latitude).HasMaxLength(100);

                entity.Property(e => e.Longitude).HasMaxLength(100);

                entity.Property(e => e.OrganizationIdentifier)
                    .HasMaxLength(60)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StateAbbreviation)
                    .HasMaxLength(2)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationCalendarSession>(entity =>
            {
                entity.ToTable("OrganizationCalendarSession", "Staging");

                entity.Property(e => e.AcademicTermDesignator).HasMaxLength(100);

                entity.Property(e => e.BeginDate).HasColumnType("datetime");

                entity.Property(e => e.CalendarYear).HasMaxLength(50);

                entity.Property(e => e.DataCollectionName).HasMaxLength(50);

                entity.Property(e => e.EndDate).HasColumnType("datetime");

                entity.Property(e => e.OrganizationIdentifier).HasMaxLength(100);

                entity.Property(e => e.OrganizationType).HasMaxLength(50);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SessionType).HasMaxLength(100);
            });

            modelBuilder.Entity<OrganizationCustomSchoolIndicatorStatusType>(entity =>
            {
                entity.ToTable("OrganizationCustomSchoolIndicatorStatusType", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.IndicatorStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusSubgroup)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusSubgroupType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("date");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("date");

                entity.Property(e => e.SchoolIdentifierSea)
                    .IsRequired()
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StatedDefinedCustomIndicatorStatusType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StatedDefinedIndicatorStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationFederalFunding>(entity =>
            {
                entity.ToTable("OrganizationFederalFunding", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.FederalProgramCode)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.FederalProgramFundingAllocationType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FederalProgramsFundingAllocation).HasColumnType("numeric(12, 2)");

                entity.Property(e => e.OrganizationIdentifier)
                    .HasMaxLength(60)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ParentalInvolvementReservationFunds).HasColumnType("numeric(12, 2)");

                entity.Property(e => e.REAPAlternativeFundingStatusCode)
                    .HasColumnName("REAPAlternativeFundingStatusCode")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationGradeOffered>(entity =>
            {
                entity.ToTable("OrganizationGradeOffered", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.GradeOffered)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationPhone>(entity =>
            {
                entity.ToTable("OrganizationPhone", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.InstitutionTelephoneNumberType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationIdentifier)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TelephoneNumber)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationProgramType>(entity =>
            {
                entity.ToTable("OrganizationProgramType", "Staging");

                entity.Property(e => e.DataCollectionName)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationIdentifier).HasMaxLength(60);

                entity.Property(e => e.OrganizationType).HasMaxLength(100);

                entity.Property(e => e.ProgramType).HasMaxLength(50);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationSchoolComprehensiveAndTargetedSupport>(entity =>
            {
                entity.ToTable("OrganizationSchoolComprehensiveAndTargetedSupport", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolComprehensiveAndTargetedSupport)
                    .HasColumnName("School_ComprehensiveAndTargetedSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolComprehensiveSupport)
                    .HasColumnName("School_ComprehensiveSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierState)
                    .IsRequired()
                    .HasColumnName("School_Identifier_State")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolTargetedSupport)
                    .HasColumnName("School_TargetedSupport")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<OrganizationSchoolIndicatorStatus>(entity =>
            {
                entity.ToTable("OrganizationSchoolIndicatorStatus", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.IndicatorStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusSubgroup)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusSubgroupType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IndicatorStatusType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .IsRequired()
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StatedDefinedIndicatorStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<K12PersonRace>(entity =>
            {
                entity.ToTable("K12PersonRace", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.RaceType)
                      .HasMaxLength(100)
                      .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<PersonStatus>(entity =>
            {
                entity.ToTable("PersonStatus", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.EconomicDisadvantage_StatusEndDate)
                    .HasColumnName("EconomicDisadvantage_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.EconomicDisadvantage_StatusStartDate)
                    .HasColumnName("EconomicDisadvantage_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.EligibilityStatusForSchoolFoodServicePrograms)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.EnglishLearner_StatusEndDate)
                    .HasColumnName("EnglishLearner_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.EnglishLearner_StatusStartDate)
                    .HasColumnName("EnglishLearner_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.FosterCare_ProgramParticipationEndDate)
                    .HasColumnName("FosterCare_ProgramParticipationEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.FosterCare_ProgramParticipationStartDate)
                    .HasColumnName("FosterCare_ProgramParticipationStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.HomelessNightTimeResidence)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.HomelessNightTimeResidence_EndDate)
                    .HasColumnName("HomelessNightTimeResidence_EndDate")
                    .HasColumnType("date");

                entity.Property(e => e.HomelessNightTimeResidence_StartDate)
                    .HasColumnName("HomelessNightTimeResidence_StartDate")
                    .HasColumnType("date");

                entity.Property(e => e.Homelessness_StatusEndDate)
                    .HasColumnName("Homelessness_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.Homelessness_StatusStartDate)
                    .HasColumnName("Homelessness_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.Immigrant_ProgramParticipationEndDate)
                    .HasColumnName("Immigrant_ProgramParticipationEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.Immigrant_ProgramParticipationStartDate)
                    .HasColumnName("Immigrant_ProgramParticipationStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.ISO_639_2_NativeLanguage)
                    .HasColumnName("ISO_639_2_NativeLanguage")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Migrant_StatusEndDate)
                    .HasColumnName("Migrant_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.Migrant_StatusStartDate)
                    .HasColumnName("Migrant_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.MilitaryConnected_StatusEndDate)
                    .HasColumnName("MilitaryConnected_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.MilitaryConnected_StatusStartDate)
                    .HasColumnName("MilitaryConnected_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.MilitaryConnectedStudentIndicator)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PerkinsEnglishLearnerStatus)
                    .HasColumnName("PerkinsLEPStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PerkinsEnglishLearnerStatus_StatusEndDate)
                    .HasColumnName("PerkinsLEPStatus_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.PerkinsEnglishLearnerStatus_StatusStartDate)
                    .HasColumnName("PerkinsLEPStatus_StatusStartDate")
                    .HasColumnType("date");


                entity.Property(e => e.ProgramType_FosterCare).HasColumnName("ProgramType_FosterCare");

                entity.Property(e => e.ProgramType_Immigrant).HasColumnName("ProgramType_Immigrant");

                entity.Property(e => e.ProgramType_Section504).HasColumnName("ProgramType_Section504");


                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Section504_ProgramParticipationEndDate)
                    .HasColumnName("Section504_ProgramParticipationEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.Section504_ProgramParticipationStartDate)
                    .HasColumnName("Section504_ProgramParticipationStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ProgramParticipationCte>(entity =>
            {
                entity.ToTable("ProgramParticipationCTE", "Staging");

                entity.Property(e => e.AdvancedTrainingEnrollmentDate).HasColumnType("date");

                entity.Property(e => e.CteExitReason)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.DiplomaCredentialAwardDate).HasColumnType("date");

                entity.Property(e => e.DisplacedHomeMaker_StatusEndDate)
                    .HasColumnName("DisplacedHomeMaker_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.DisplacedHomeMaker_StatusStartDate)
                    .HasColumnName("DisplacedHomeMaker_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PlacementType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgramParticipationBeginDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SingleParent_StatusEndDate)
                    .HasColumnName("SingleParent_StatusEndDate")
                    .HasColumnType("date");

                entity.Property(e => e.SingleParent_StatusStartDate)
                    .HasColumnName("SingleParent_StatusStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TechnicalSkillsAssessmentType)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ProgramParticipationNorDClass>(entity =>
            {
                entity.ToTable("ProgramParticipationNorD", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.DiplomaCredentialAwardDate).HasColumnType("date");

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.NeglectedOrDelinquentAcademicOutcomeIndicator)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgramParticipationBeginDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.NeglectedOrDelinquentProgramType)
                   .HasColumnName("NeglectedOrDelinquentProgramType")
                   .HasMaxLength(100)
                   .IsUnicode(false);

                entity.Property(e => e.NeglectedProgramType)
                    .HasColumnName("NeglectedProgramType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.DelinquentProgramType)
                    .HasColumnName("DelinquentProgramType")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgressLevel_Math)
                    .HasColumnName("ProgressLevel_Math")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgressLevel_Reading)
                    .HasColumnName("ProgressLevel_Reading")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                //entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ProgramParticipationSpecialEducation>(entity =>
            {
                entity.ToTable("ProgramParticipationSpecialEducation", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.IDEAIndicator).HasColumnName("IDEAIndicator");

                entity.Property(e => e.IDEAEducationalEnvironmentForEarlyChildhood)
                    .HasColumnName("IDEAEducationalEnvironmentForEarlyChildhood")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.IDEAEducationalEnvironmentForSchoolAge)
                    .HasColumnName("IDEAEducationalEnvironmentForSchoolAge")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgramParticipationBeginDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SpecialEducationExitReason)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<IdeaDisabilityType>(entity =>
            {
                entity.ToTable("IdeaDisabilityType", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.IdeaDisabilityTypeCode)
                    .HasColumnName("IdeaDisabilityTypeCode")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ProgramParticipationTitleI>(entity =>
            {
                entity.ToTable("ProgramParticipationTitleI", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.ProgramParticipationBeginDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TitleIIndicator)
                    .HasColumnName("TitleIIndicator")
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ProgramParticipationTitleIII>(entity =>
            {
                entity.ToTable("ProgramParticipationTitleIII", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.TitleIIILanguageInstructionProgramType)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.LeaIdentifierSeaAccountability)
                    .HasColumnName("LeaIdentifierSeaAccountability")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Proficiency_TitleIII)
                    .HasColumnName("Proficiency_TitleIII")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.ProgramParticipationBeginDate).HasColumnType("date");

                entity.Property(e => e.ProgramParticipationEndDate).HasColumnType("date");

                entity.Property(e => e.TitleIIIAccountabilityProgressStatus)
                    .HasColumnName("TitleIIIAccountabilityProgressStatus")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolIdentifierSea)
                    .HasColumnName("SchoolIdentifierSea")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("StudentIdentifierState")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TitleIIIImmigrantStatus_EndDate)
                    .HasColumnName("TitleIIIImmigrantStatus_EndDate")
                    .HasColumnType("date");

                entity.Property(e => e.TitleIIIImmigrantStatus_StartDate)
                    .HasColumnName("TitleIIIImmigrantStatus_StartDate")
                    .HasColumnType("date");
            });

            modelBuilder.Entity<PsInstitution>(entity =>
            {
                entity.ToTable("PsInstitution", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.InstitutionIpedsUnitId).HasMaxLength(50);

                entity.Property(e => e.MostPrevalentLevelOfInstitutionCode).HasMaxLength(50);

                entity.Property(e => e.OperationalStatusEffectiveDate).HasColumnType("datetime");

                entity.Property(e => e.OrganizationName)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.OrganizationOperationalStatus)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PredominantCalendarSystem)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Website)
                    .HasMaxLength(300)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<PsStudentAcademicAward>(entity =>
            {
                entity.ToTable("PsStudentAcademicAward", "Staging");

                entity.Property(e => e.AcademicAwardDate).HasColumnType("datetime");

                entity.Property(e => e.AcademicAwardTitle).HasMaxLength(200);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.Property(e => e.InstitutionIpedsUnitId)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.PescAwardLevelType).HasMaxLength(200);

                entity.Property(e => e.ProfessionalOrTechnicalCredentialConferred).HasMaxLength(50);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("Student_Identifier_State")
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<PsStudentAcademicRecord>(entity =>
            {
                entity.ToTable("PsStudentAcademicRecord", "Staging");

                entity.Property(e => e.AcademicTermDesignator).HasMaxLength(50);

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.DiplomaOrCredentialAwardDate).HasColumnType("datetime");

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.Property(e => e.InstitutionIpedsUnitId)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.ProfessionalOrTechnicalCredentialConferred)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("Student_Identifier_State")
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<PsStudentEnrollment>(entity =>
            {
                entity.ToTable("PsStudentEnrollment", "Staging");

                entity.Property(e => e.AcademicTermDesignator)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Birthdate).HasColumnType("date");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.EntryDateIntoPostsecondary).HasColumnType("datetime");

                entity.Property(e => e.ExitDate).HasColumnType("datetime");

                entity.Property(e => e.FirstName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.InstitutionIpedsUnitId).HasMaxLength(100);

                entity.Property(e => e.LastName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.MiddleName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.PostsecondaryExitOrWithdrawalType).HasMaxLength(100);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.Sex)
                    .HasMaxLength(30)
                    .IsUnicode(false);

                entity.Property(e => e.StudentIdentifierState)
                    .HasColumnName("Student_Identifier_State")
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<SourceSystemReferenceData>(entity =>
            {
                entity.ToTable("SourceSystemReferenceData", "Staging");

                entity.Property(e => e.InputCode).HasMaxLength(200);

                entity.Property(e => e.OutputCode).HasMaxLength(200);

                entity.Property(e => e.TableFilter)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.TableName)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<StateDefinedCustomIndicator>(entity =>
            {
                entity.ToTable("StateDefinedCustomIndicator", "Staging");

                entity.Property(e => e.Code).HasMaxLength(50);

                entity.Property(e => e.Description).HasMaxLength(100);

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");
            });

            modelBuilder.Entity<StateDetail>(entity =>
            {
                entity.ToTable("StateDetail", "Staging");

                entity.Property(e => e.DataCollectionName).HasMaxLength(100);

                entity.Property(e => e.RecordEndDateTime).HasColumnType("datetime");

                entity.Property(e => e.RecordStartDateTime).HasColumnType("datetime");

                entity.Property(e => e.RunDateTime).HasColumnType("datetime");

                entity.Property(e => e.SchoolYear)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_ElectronicMailAddress)
                    .HasColumnName("SeaContact_ElectronicMailAddress")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_FirstName)
                    .HasColumnName("SeaContact_FirstName")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_Identifier)
                    .HasColumnName("SeaContact_Identifier")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_LastOrSurname)
                    .HasColumnName("SeaContact_LastOrSurname")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_PersonalTitleOrPrefix)
                    .HasColumnName("SeaContact_PersonalTitleOrPrefix")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_PhoneNumber)
                    .HasColumnName("SeaContact_PhoneNumber")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaContact_PositionTitle)
                    .HasColumnName("SeaContact_PositionTitle")
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.SeaOrganizationName)
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.SeaOrganizationShortName)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.SeaOrganizationIdentifierSea)
                    .HasMaxLength(7)
                    .IsUnicode(false);

                entity.Property(e => e.Sea_WebSiteAddress)
                    .HasColumnName("Sea_WebSiteAddress")
                    .HasMaxLength(300)
                    .IsUnicode(false);

                entity.Property(e => e.StateAbbreviationCode)
                    .HasMaxLength(2)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<StagingValidationResult>(entity =>
            {
                entity.ToTable("StagingValidationResults", "Staging");

                entity.HasKey(e => e.Id);

                entity.Property(e => e.StagingValidationRuleId);

                entity.Property(e => e.SchoolYear);

                entity.Property(e => e.FactTypeOrReportCode)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.ColumnName)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.StagingTableName)
                    .HasMaxLength(200)
                    .IsUnicode(false);

                entity.Property(e => e.Severity)
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.ValidationMessage)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.RecordCount);

            });
        }
    }
}
