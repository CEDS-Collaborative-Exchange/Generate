using Microsoft.EntityFrameworkCore;
using generate.core.Models.RDS;
using generate.core.Dtos.ODS;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Logging;
using System.IO;
using System.Collections.Generic;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace generate.infrastructure.Contexts
{
    public class RDSDbContext : DbContext
    {
        private readonly ILogger _logger;
        private string _schemaName = "RDS";

        public RDSDbContext(DbContextOptions<RDSDbContext> options, ILogger<RDSDbContext> logger) : base(options)
        {
            _logger = logger;

        }

        public void ExecuteEFMigration(string migrationName)
        {
            var migrator = this.GetInfrastructure().GetRequiredService<IMigrator>();
            migrator.Migrate(migrationName);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            // Not Configuring anything
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema(_schemaName);


			#region Dimensions
			
			// DimCohortStatuses
			modelBuilder.Entity<DimCohortStatus>(entity =>
			{
				entity.HasKey(x => x.DimCohortStatusId);
			});

            // DimIndicatorStatuses
            modelBuilder.Entity<DimIndicatorStatus>(entity => {
				entity.ToTable("DimIndicatorStatuses");
				entity.HasKey(x => x.DimIndicatorStatusId);
			});

			// DimIndicatorStatusTypes
			modelBuilder.Entity<DimIndicatorStatusType>(entity => {
				entity.ToTable("DimIndicatorStatusTypes");
				entity.HasKey(x => x.DimIndicatorStatusTypeId);
			});

			// DimStateDefinedStatuses
			modelBuilder.Entity<DimStateDefinedStatus>(entity => {
				entity.ToTable("DimStateDefinedStatuses");
				entity.HasKey(x => x.DimStateDefinedStatusId);
			});

			// DimStateDefinedCustomStatuses
			modelBuilder.Entity<DimStateDefinedCustomIndicator>(entity => {
				entity.ToTable("DimStateDefinedCustomIndicators");
				entity.HasKey(x => x.DimStateDefinedCustomIndicatorId);
			});

            // DimSchoolStateStatuses
            modelBuilder.Entity<DimK12SchoolStateStatus>(entity => {
                entity.ToTable("DimSchoolStateStatuses");
                entity.HasKey(x => x.DimK12SchoolStateStatusId);
            });

            // DimFactType
            modelBuilder.Entity<DimFactType>(entity =>
            {
                entity.HasKey(x => x.DimFactTypeId);

                entity
                   .Property(x => x.DimFactTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.FactTypeCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .HasIndex(p => new { p.FactTypeCode });

                entity
                   .Property(x => x.FactTypeDescription)
                   .HasMaxLength(200)
                   .IsRequired();

                entity
                   .HasIndex(p => new { p.FactTypeCode });


            });

            // DimDate
            modelBuilder.Entity<DimDate>(entity =>
            {

                entity.HasKey(x => x.DimDateId);

                entity
                   .Property(x => x.DimDateId)
                   .IsRequired();

                entity
                   .Property(x => x.MonthName)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DayOfWeek)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SubmissionYear)
                   .HasMaxLength(50);

                entity
                   .HasIndex(p => new { p.SubmissionYear });

                entity
                   .HasIndex(p => new { p.DateValue });


            });

            // DimSchoolYear
            modelBuilder.Entity<DimSchoolYear>(entity =>
            {

                entity.HasKey(x => x.DimSchoolYearId);

                entity
                   .Property(x => x.DimSchoolYearId)
                   .IsRequired();

                entity
                   .Property(x => x.SchoolYear)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SessionBeginDate)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SessionEndDate)
                   .HasMaxLength(50);

                entity
                   .HasIndex(p => new { p.SchoolYear });


            });

            // DimSchool
            modelBuilder.Entity<DimK12School>(entity =>
            {

                entity.HasKey(x => x.DimK12SchoolId);

                entity
                   .Property(x => x.DimK12SchoolId)
                   .IsRequired();


                // School

                entity
                   .Property(x => x.NameOfInstitution)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.SchoolIdentifierState)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.PriorSchoolIdentifierState)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SchoolIdentifierNces)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.CharterSchoolContractIdNumber)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.CharterSchoolIndicator);


                entity
                   .Property(x => x.CharterSchoolAuthorizerIdPrimary)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.CharterSchoolAuthorizerIdSecondary)
                  .HasMaxLength(50);


                // LEA

                entity
                   .Property(x => x.LeaName)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.LeaIdentifierState)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.PriorLeaIdentifierState)
                    .HasMaxLength(50);

                entity
                   .Property(x => x.LeaIdentifierNces)
                   .HasMaxLength(50);

                // SEA

                entity
                   .Property(x => x.SeaName)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.SeaIdentifierState)
                   .HasMaxLength(50);

                // State

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(10);

                entity
                   .Property(x => x.StateAnsiCode)
                   .HasMaxLength(10);

                entity
               .Property(x => x.Telephone)
               .HasMaxLength(24);

                entity
               .Property(x => x.Website)
               .HasMaxLength(300);

                entity.Property(x => x.PhysicalAddressStreet).HasMaxLength(40);
                entity.Property(x => x.PhysicalAddressCity).HasMaxLength(30);
                entity.Property(x => x.PhysicalAddressState).HasMaxLength(50);
                entity.Property(x => x.PhysicalAddressPostalCode).HasMaxLength(17);

                entity.Property(x => x.MailingAddressStreet).HasMaxLength(40);
                entity.Property(x => x.MailingAddressCity).HasMaxLength(30);
                entity.Property(x => x.MailingAddressState).HasMaxLength(50);
                entity.Property(x => x.MailingAddressPostalCode).HasMaxLength(17);

                entity.Property(x => x.SchoolTypeCode).HasMaxLength(50);
                entity.Property(x => x.SchoolTypeDescription).HasMaxLength(100);
                entity.Property(x => x.SchoolTypeEdFactsCode).HasMaxLength(50);

                // Indexes

                entity
                   .HasIndex(p => new { p.StateAnsiCode });

                entity
                   .HasIndex(p => new { p.StateAbbreviationCode });
            });

            // DimLea
            modelBuilder.Entity<DimLea>(entity =>
            {
                entity
                .Property(x => x.DimLeaID)
                .IsRequired();

                // LEA

                entity
                 .Property(x => x.LeaName)
                .HasMaxLength(1000);

                entity
                 .Property(x => x.LeaIdentifierState)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.PriorLeaIdentifierState)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.LeaIdentifierNces)
                 .HasMaxLength(50);

                entity
                    .Property(e => e.LeaSupervisoryUnionIdentificationNumber)
                    .HasColumnType("nchar(3)");

                // SEA

                entity
                   .Property(x => x.SeaName)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.SeaIdentifierState)
                   .HasMaxLength(50);

                // State

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(10);

                entity
                   .Property(x => x.StateAnsiCode)
                   .HasMaxLength(10);

                entity
               .Property(x => x.Telephone)
               .HasMaxLength(24);

                entity
               .Property(x => x.Website)
               .HasMaxLength(300);

                entity.Property(x => x.PhysicalAddressStreet).HasMaxLength(40);
                entity.Property(x => x.PhysicalAddressCity).HasMaxLength(30);
                entity.Property(x => x.PhysicalAddressState).HasMaxLength(50);
                entity.Property(x => x.PhysicalAddressPostalCode).HasMaxLength(17);

                entity.Property(x => x.MailingAddressStreet).HasMaxLength(40);
                entity.Property(x => x.MailingAddressCity).HasMaxLength(30);
                entity.Property(x => x.MailingAddressState).HasMaxLength(50);
                entity.Property(x => x.MailingAddressPostalCode).HasMaxLength(17);

                entity.Property(x => x.LeaTypeCode).HasMaxLength(50);
                entity.Property(x => x.LeaTypeDescription).HasMaxLength(100);
                entity.Property(x => x.LeaTypeEdFactsCode).HasMaxLength(50);

                // Indexes

                entity
                   .HasIndex(p => new { p.StateAbbreviationCode });

            });

            // DimSea
            modelBuilder.Entity<DimSea>(entity =>
            {
                entity
                .Property(x => x.DimSeaId)
                .IsRequired();

                // SEA

                entity
                   .Property(x => x.SeaName)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.SeaIdentifierState)
                   .HasMaxLength(50);

                // State

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000);

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(10);

                entity
                   .Property(x => x.StateAnsiCode)
                   .HasMaxLength(10);

                entity
               .Property(x => x.Telephone)
               .HasMaxLength(24);

                entity
               .Property(x => x.Website)
               .HasMaxLength(300);

                entity.Property(x => x.PhysicalAddressStreet).HasMaxLength(40);
                entity.Property(x => x.PhysicalAddressCity).HasMaxLength(30);
                entity.Property(x => x.PhysicalAddressState).HasMaxLength(50);
                entity.Property(x => x.PhysicalAddressPostalCode).HasMaxLength(17);

                entity.Property(x => x.MailingAddressStreet).HasMaxLength(40);
                entity.Property(x => x.MailingAddressCity).HasMaxLength(30);
                entity.Property(x => x.MailingAddressState).HasMaxLength(50);
                entity.Property(x => x.MailingAddressPostalCode).HasMaxLength(17);


                // Indexes

                entity
                   .HasIndex(p => new { p.StateAbbreviationCode });

                entity
                    .HasIndex(p => new { p.SeaOrganizationId });

            });
         
            // DimDemographic
            modelBuilder.Entity<DimK12Demographic>(entity =>
            {
                entity.HasKey(d => d.DimK12DemographicId);

                entity
                   .Property(x => x.DimK12DemographicId)
                   .IsRequired();

               
                entity
                   .Property(x => x.EnglishLearnerStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.EnglishLearnerStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.EnglishLearnerStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.MigrantStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.MigrantStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MigrantStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.EconomicDisadvantageStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.EconomicDisadvantageStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.EconomicDisadvantageStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.HomelessnessStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.HomelessnessStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.HomelessnessStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.MilitaryConnectedStudentIndicatorCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.MilitaryConnectedStudentIndicatorDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MilitaryConnectedStudentIndicatorEdFactsCode)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.HomelessUnaccompaniedYouthStatusCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.HomelessUnaccompaniedYouthStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.HomelessUnaccompaniedYouthStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.HomelessPrimaryNighttimeResidenceCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.HomelessPrimaryNighttimeResidenceDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.HomelessPrimaryNighttimeResidenceEdFactsCode)
                   .HasMaxLength(50);




            });

            // DimIdeaStatus
            modelBuilder.Entity<DimIdeaStatus>(entity =>
            {

                entity.HasKey(d => d.DimIdeaStatusId);


                entity
                   .Property(x => x.DimIdeaStatusId)
                   .IsRequired();



                entity
                   .Property(x => x.PrimaryDisabilityTypeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.PrimaryDisabilityTypeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.PrimaryDisabilityTypeEdFactsCode)
                   .HasMaxLength(50);



                entity
                   .Property(x => x.IdeaEducationalEnvironmentCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IdeaEducationalEnvironmentDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.IdeaEducationalEnvironmentEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SpecialEducationExitReasonCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SpecialEducationExitReasonDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.SpecialEducationExitReasonEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IdeaIndicatorCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IdeaIndicatorDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.IdeaIndicatorEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .HasIndex(p => new { p.PrimaryDisabilityTypeCode, p.IdeaEducationalEnvironmentCode, p.SpecialEducationExitReasonCode, p.IdeaIndicatorCode });

                entity
                   .HasIndex(p => new { p.PrimaryDisabilityTypeEdFactsCode });

                entity
                   .HasIndex(p => new { p.IdeaEducationalEnvironmentEdFactsCode });

                entity
                   .HasIndex(p => new { p.SpecialEducationExitReasonEdFactsCode });

                entity
                  .HasIndex(p => new { p.IdeaIndicatorEdFactsCode });



            });

            // DimAge
            modelBuilder.Entity<DimAge>(entity =>
            {
                entity.HasKey(x => x.DimAgeId);

                entity
                   .Property(x => x.DimAgeId)
                   .IsRequired();


                entity
                   .Property(x => x.AgeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AgeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AgeEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .HasIndex(p => new { p.AgeCode });

                entity
                   .HasIndex(p => new { p.AgeValue });


            });

            // DimDiscipline
            modelBuilder.Entity<DimDiscipline>(entity =>
            {

                entity.HasKey(x => x.DimDisciplineId);

                entity
                   .Property(x => x.DimDisciplineId)
                   .IsRequired();



                entity
                   .Property(x => x.DisciplinaryActionTakenCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DisciplinaryActionTakenDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.DisciplinaryActionTakenEdFactsCode)
                   .HasMaxLength(50);



                entity
                   .Property(x => x.DisciplineMethodOfChildrenWithDisabilitiesCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DisciplineMethodOfChildrenWithDisabilitiesDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode)
                   .HasMaxLength(50);



                entity
                   .Property(x => x.EducationalServicesAfterRemovalCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.EducationalServicesAfterRemovalDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.EducationalServicesAfterRemovalEdFactsCode)
                   .HasMaxLength(50);



                entity
                   .Property(x => x.IdeaInterimRemovalReasonCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IdeaInterimRemovalReasonDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.IdeaInterimRemovalReasonEdFactsCode)
                   .HasMaxLength(50);




                entity
                   .Property(x => x.IdeaInterimRemovalCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IdeaInterimRemovalDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.IdeaInterimRemovalEdFactsCode)
                   .HasMaxLength(50);

                entity.HasIndex(p => new { p.DisciplinaryActionTakenCode, p.DisciplineMethodOfChildrenWithDisabilitiesCode, p.EducationalServicesAfterRemovalCode, p.IdeaInterimRemovalReasonCode, p.IdeaInterimRemovalCode });

                entity
                   .HasIndex(p => new { p.DisciplinaryActionTakenEdFactsCode });
                entity
                   .HasIndex(p => new { p.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode });
                entity
                   .HasIndex(p => new { p.EducationalServicesAfterRemovalEdFactsCode });
                entity
                   .HasIndex(p => new { p.IdeaInterimRemovalReasonEdFactsCode });
                entity
                   .HasIndex(p => new { p.IdeaInterimRemovalEdFactsCode });



            });

            // DimRace
            modelBuilder.Entity<DimRace>(entity =>
            {
                entity.HasKey(x => x.DimRaceId);

                entity
                   .Property(x => x.DimRaceId)
                   .IsRequired();

                entity
                   .Property(x => x.RaceCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.RaceDescription)
                   .HasMaxLength(200);


                entity
                   .HasIndex(p => new { p.RaceCode });

            });

            // DimStudent
            modelBuilder.Entity<DimK12Student>(entity =>
            {
                entity.HasKey(x => x.DimK12StudentId);

                entity
                   .Property(x => x.DimK12StudentId)
                   .IsRequired();

                entity
                   .Property(x => x.StateStudentIdentifier)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.FirstName)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.MiddleName)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.LastName)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.Cohort)
                    .HasMaxLength(50);

               
                entity
                   .HasIndex(p => new { p.StateStudentIdentifier });


            });

            // DimK12Staff
            modelBuilder.Entity<DimK12Staff>(entity =>
            {

                entity
                   .Property(x => x.DimK12StaffId)
                   .IsRequired();

                entity
                   .Property(x => x.StaffMemberIdentifierState)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.FirstName)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.MiddleName)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.LastOrSurname)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.TelephoneNumber)
                    .HasMaxLength(24);

                entity
                    .Property(x => x.ElectronicMailAddress)
                    .HasMaxLength(124);

                entity
                    .Property(x => x.PositionTitle)
                    .HasMaxLength(50);

                entity
                   .Property(x => x.K12StaffRole)
                   .HasMaxLength(50);

                entity
                   .HasIndex(p => new { p.StaffMemberIdentifierState });


            });

            // DimK12StaffStatus
            modelBuilder.Entity<DimK12StaffStatus>(entity =>
            {

                entity
                   .Property(x => x.DimK12StaffStatusId)
                   .IsRequired();


                entity
                   .Property(x => x.K12StaffClassificationCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.K12StaffClassificationDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.K12StaffClassificationEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.QualificationStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.QualificationStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.QualificationStatusEdFactsCode)
                   .HasMaxLength(50);



                entity
                   .Property(x => x.CertificationStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.CertificationStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.CertificationStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SpecialEducationAgeGroupTaughtCode)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SpecialEducationAgeGroupTaughtDescription)
                   .HasMaxLength(200);
                entity
                   .Property(x => x.SpecialEducationAgeGroupTaughtEdFactsCode)
                   .HasMaxLength(50);

				entity
				   .Property(x => x.UnexperiencedStatusCode)
				   .HasMaxLength(50);
				entity
				   .Property(x => x.UnexperiencedStatusDescription)
				   .HasMaxLength(200);
				entity
				   .Property(x => x.UnexperiencedStatusEdFactsCode)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.EmergencyOrProvisionalCredentialStatusCode)
				   .HasMaxLength(50);
				entity
				   .Property(x => x.EmergencyOrProvisionalCredentialStatusDescription)
				   .HasMaxLength(200);
				entity
				   .Property(x => x.EmergencyOrProvisionalCredentialStatusEdFactsCode)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.OutOfFieldStatusCode)
				   .HasMaxLength(50);
				entity
				   .Property(x => x.OutOfFieldStatusDescription)
				   .HasMaxLength(200);
				entity
				   .Property(x => x.OutOfFieldStatusEdFactsCode)
				   .HasMaxLength(50);

				entity
                    .HasIndex(p => new { p.K12StaffClassificationCode, p.QualificationStatusCode, p.CertificationStatusCode, p.SpecialEducationAgeGroupTaughtCode });

                entity
                   .HasIndex(p => new { p.K12StaffClassificationCode });
                entity
                   .HasIndex(p => new { p.QualificationStatusEdFactsCode });
                entity
                   .HasIndex(p => new { p.CertificationStatusEdFactsCode });
                entity
                   .HasIndex(p => new { p.SpecialEducationAgeGroupTaughtCode });

				entity
				   .HasIndex(p => new { p.UnexperiencedStatusEdFactsCode });
				entity
				   .HasIndex(p => new { p.EmergencyOrProvisionalCredentialStatusEdFactsCode });
				entity
				   .HasIndex(p => new { p.OutOfFieldStatusEdFactsCode });


			});

            // DimAssessment
            modelBuilder.Entity<DimAssessment>(entity =>
            {

                entity
                   .Property(x => x.DimAssessmentId)
                   .IsRequired();


                entity
                   .Property(x => x.AssessmentSubjectCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentSubjectDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AssessmentSubjectEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentTypeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentTypeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AssessmentTypeEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.SeaFullYearStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SeaFullYearStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.SeaFullYearStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.LeaFullYearStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.LeaFullYearStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.LeaFullYearStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.SchFullYearStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SchFullYearStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.SchFullYearStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.PerformanceLevelCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.PerformanceLevelDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.PerformanceLevelEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ParticipationStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ParticipationStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.ParticipationStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentTypeAdministeredToEnglishLearnersCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentTypeAdministeredToEnglishLearnersDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AssessmentTypeAdministeredToEnglishLearnersEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .HasIndex(p => new { p.AssessmentSubjectCode, p.AssessmentTypeCode, p.SeaFullYearStatusCode, p.SchFullYearStatusCode, p.PerformanceLevelCode, p.ParticipationStatusCode });

                entity
                   .HasIndex(p => new { p.AssessmentSubjectEdFactsCode });
                entity
                   .HasIndex(p => new { p.AssessmentTypeEdFactsCode });
                entity
                   .HasIndex(p => new { p.SeaFullYearStatusEdFactsCode });
                entity
                   .HasIndex(p => new { p.LeaFullYearStatusEdFactsCode });
                entity
                   .HasIndex(p => new { p.SchFullYearStatusEdFactsCode });
                entity
                   .HasIndex(p => new { p.PerformanceLevelEdFactsCode });
                entity
                   .HasIndex(p => new { p.ParticipationStatusEdFactsCode });

                entity
                  .HasIndex(p => new { p.AssessmentTypeAdministeredToEnglishLearnersCode });
                entity
                   .HasIndex(p => new { p.AssessmentTypeAdministeredToEnglishLearnersEdFactsCode });
                
            });

            // DimGradeLevel
            modelBuilder.Entity<DimGradeLevel>(entity =>
            {

                entity
                   .Property(x => x.DimGradeLevelId)
                   .IsRequired();


                entity
               .Property(x => x.GradeLevelCode)
               .HasMaxLength(50);

                entity
                   .Property(x => x.GradeLevelDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.GradeLevelEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .HasIndex(p => new { p.GradeLevelCode });

                entity
                   .HasIndex(p => new { p.GradeLevelEdFactsCode });

            });

            //DimSchoolStatus
            modelBuilder.Entity<DimK12SchoolStatus>(entity =>
            {
                entity
                  .Property(x => x.DimK12SchoolStatusId)
                  .IsRequired();



                entity
                   .Property(x => x.SharedTimeIndicatorCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SharedTimeIndicatorDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.SharedTimeIndicatorEdFactsCode)
                   .HasMaxLength(50);


                entity
                      .Property(x => x.MagnetOrSpecialProgramEmphasisSchoolCode)
                      .HasMaxLength(50);

                entity
                   .Property(x => x.MagnetOrSpecialProgramEmphasisSchoolDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MagnetOrSpecialProgramEmphasisSchoolEdFactsCode)
                   .HasMaxLength(50);

                entity
                .Property(x => x.NslpStatusCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.NslpStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.NslpStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                .Property(x => x.VirtualSchoolStatusCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.VirtualSchoolStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.VirtualSchoolStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                .Property(x => x.StatePovertyDesignationCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.StatePovertyDesignationDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.StatePovertyDesignationEdFactsCode)
                   .HasMaxLength(50);

				entity
				   .Property(x => x.ProgressAchievingEnglishLanguageCode)
				   .HasMaxLength(50);
				entity
				   .Property(x => x.ProgressAchievingEnglishLanguageDescription)
				   .HasMaxLength(200);
				entity
				   .Property(x => x.ProgressAchievingEnglishLanguageEdFactsCode)
				   .HasMaxLength(50);
                				

            });
           
            //DimLanguage
            modelBuilder.Entity<DimLanguage>(entity =>
            {
                entity
                   .Property(x => x.DimLanguageId)
                   .IsRequired();

                entity
                  .Property(x => x.Iso6392LanguageCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.Iso6392LanguageDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.Iso6392LanguageEdFactsCode)
                   .HasMaxLength(50);


                // Indexes
                entity.HasIndex(p => new { p.Iso6392LanguageCode });

                entity.HasIndex(p => new { p.Iso6392LanguageEdFactsCode });

            });


            //DimStudentStatus
            modelBuilder.Entity<DimK12StudentStatus>(entity =>
            {

                entity
                   .Property(x => x.DimK12StudentStatusId)
                   .IsRequired();

                entity
                  .Property(x => x.HighSchoolDiplomaTypeCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.HighSchoolDiplomaTypeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.HighSchoolDiplomaTypeEdFactsCode)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.MobilityStatus12moCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.MobilityStatus12moDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MobilityStatus12moEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.MobilityStatus36moCode)
                    .HasMaxLength(50);

                entity
                   .Property(x => x.MobilityStatus36moDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MobilityStatus36moEdFactsCode)
                   .HasMaxLength(50);


                entity
                 .Property(x => x.MobilityStatusSYCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.MobilityStatusSYDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.MobilityStatusSYEdFactsCode)
                   .HasMaxLength(50);



                entity
                 .Property(x => x.ReferralStatusCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.ReferralStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.ReferralStatusEdFactsCode)
                   .HasMaxLength(50);



               entity
               .Property(x => x.PlacementStatusCode)
               .HasMaxLength(50);

                entity
                   .Property(x => x.PlacementStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.PlacementStatusEdFactsCode)
                   .HasMaxLength(50);



                entity
               .Property(x => x.PlacementTypeCode)
               .HasMaxLength(50);

                entity
                   .Property(x => x.PlacementTypeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.PlacementTypeEdFactsCode)
                   .HasMaxLength(50);



              
                // Indexes
                entity.HasIndex(p => new { p.HighSchoolDiplomaTypeCode, p.MobilityStatus12moCode, p.MobilityStatus36moCode, p.MobilityStatusSYCode, p.ReferralStatusCode });

                entity.HasIndex(p => new { p.HighSchoolDiplomaTypeEdFactsCode });
                entity.HasIndex(p => new { p.MobilityStatus12moEdFactsCode });
                entity.HasIndex(p => new { p.MobilityStatus36moEdFactsCode });
                entity.HasIndex(p => new { p.MobilityStatusSYEdFactsCode });
                entity.HasIndex(p => new { p.ReferralStatusEdFactsCode });
                entity.HasIndex(p => new { p.PlacementStatusCode });
                entity.HasIndex(p => new { p.PlacementTypeCode });

            });

            //DimTitleIStatus
            modelBuilder.Entity<DimTitleIStatus>(entity =>
            {


                entity
                   .Property(x => x.DimTitleIStatusId)
                   .IsRequired();

                entity
                 .Property(x => x.TitleISchoolStatusCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.TitleISchoolStatusDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleISchoolStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                  .Property(x => x.TitleIInstructionalServicesCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.TitleIInstructionalServicesDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleIInstructionalServicesEdFactsCode)
                   .HasMaxLength(50);

                entity
                .Property(x => x.TitleISupportServicesCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.TitleISupportServicesDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleISupportServicesEdFactsCode)
                   .HasMaxLength(50);

                entity
                .Property(x => x.TitleIProgramTypeCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.TitleIProgramTypeDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleIProgramTypeEdFactsCode)
                   .HasMaxLength(50);

                // Indexes
                entity.HasIndex(p => new { p.TitleISchoolStatusCode, p.TitleIInstructionalServicesCode, p.TitleISupportServicesCode, p.TitleIProgramTypeCode });

                entity.HasIndex(p => new { p.TitleISchoolStatusEdFactsCode });
                entity.HasIndex(p => new { p.TitleIInstructionalServicesEdFactsCode });
                entity.HasIndex(p => new { p.TitleISupportServicesEdFactsCode });
                entity.HasIndex(p => new { p.TitleIProgramTypeEdFactsCode });



            });

            //DimMigrant
            modelBuilder.Entity<DimMigrant>(entity =>
            {

                entity
                   .Property(x => x.DimMigrantId)
                   .IsRequired();

                entity
              .Property(x => x.ContinuationOfServicesReasonCode)
              .HasMaxLength(50);

                entity
                   .Property(x => x.ContinuationOfServicesReasonDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.ContinuationOfServicesReasonEdFactsCode)
                   .HasMaxLength(50);


                entity
            .Property(x => x.MigrantPrioritizedForServicesCode)
            .HasMaxLength(50);

                entity
                   .Property(x => x.MigrantPrioritizedForServicesDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.MigrantPrioritizedForServicesEdFactsCode)
                   .HasMaxLength(50);


                entity
            .Property(x => x.MepServicesTypeCode)
            .HasMaxLength(50);

                entity
                   .Property(x => x.MepServicesTypeDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.MepServicesTypeEdFactsCode)
                   .HasMaxLength(50);



                entity
                .Property(x => x.ConsolidatedMepFundsStatusCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.ConsolidatedMepFundsStatusDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.ConsolidatedMepFundsStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.MepEnrollmentTypeCode)
                    .HasMaxLength(50);

                entity
                   .Property(x => x.MepEnrollmentTypeDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.MepEnrollmentTypeEdFactsCode)
                   .HasMaxLength(50);




            });

            //DimTitleIIIStatuses
            modelBuilder.Entity<DimTitleIIIStatus>(entity =>
            {


                entity
                   .Property(x => x.DimTitleIIIStatusId)
                   .IsRequired();

                entity
                  .Property(x => x.FormerEnglishLearnerYearStatusCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.FormerEnglishLearnerYearStatusDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.FormerEnglishLearnerYearStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                .Property(x => x.TitleIIIAccountabilityProgressStatusCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.TitleIIIAccountabilityProgressStatusDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleIIIAccountabilityProgressStatusEdFactsCode)
                   .HasMaxLength(50);

                entity
                .Property(x => x.TitleIIILanguageInstructionCode)
                .HasMaxLength(50);

                entity
                   .Property(x => x.TitleIIILanguageInstructionDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleIIILanguageInstructionEdFactsCode)
                   .HasMaxLength(50);


                entity
               .Property(x => x.ProficiencyStatusCode)
               .HasMaxLength(50);

                entity
                   .Property(x => x.ProficiencyStatusDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.ProficiencyStatusEdFactsCode)
                   .HasMaxLength(50);




            });

            //DimAssessmentStatus
            modelBuilder.Entity<DimAssessmentStatus>(entity =>
            {
                entity
                .Property(x => x.DimAssessmentStatusId)
                .IsRequired();

                entity
                 .Property(x => x.AssessedFirstTimeCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.AssessedFirstTimeDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.AssessedFirstTimeEdFactsCode)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.AssessmentProgressLevelCode)
                    .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentProgressLevelDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.AssessmentProgressLevelEdFactsCode)
                   .HasMaxLength(50);
            });

            //DimK12StaffCategory
            modelBuilder.Entity<DimK12StaffCategory>(entity =>
            {
                entity
                   .Property(x => x.DimK12StaffCategoryId)
                   .IsRequired();

                entity
                  .Property(x => x.SpecialEducationSupportServicesCategoryCode)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.SpecialEducationSupportServicesCategoryDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.SpecialEducationSupportServicesCategoryEdFactsCode)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.K12StaffClassificationCode)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.K12StaffClassificationDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.K12StaffClassificationEdFactsCode)
                   .HasMaxLength(50);

                entity
               .Property(x => x.TitleIProgramStaffCategoryCode)
               .HasMaxLength(50);

                entity
                   .Property(x => x.TitleIProgramStaffCategoryDescription)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.TitleIProgramStaffCategoryEdFactsCode)
                   .HasMaxLength(50);


                // Indexes
                entity.HasIndex(p => new { p.K12StaffClassificationCode, p.SpecialEducationSupportServicesCategoryCode, p.TitleIProgramStaffCategoryCode });

                entity.HasIndex(p => new { p.SpecialEducationSupportServicesCategoryEdFactsCode });
                entity.HasIndex(p => new { p.K12StaffClassificationEdFactsCode });
                entity.HasIndex(p => new { p.TitleIProgramStaffCategoryEdFactsCode });



            });

            //DimOrganizationStatuses
            modelBuilder.Entity<DimK12OrganizationStatus>(entity =>
            {

                entity
                   .Property(x => x.DimK12OrganizationStatusId)
                   .IsRequired();

                entity.Property(x => x.ReapAlternativeFundingStatusCode).HasMaxLength(50);
                entity.Property(x => x.ReapAlternativeFundingStatusDescription).HasMaxLength(200);
                entity.Property(x => x.ReapAlternativeFundingStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.GunFreeSchoolsActReportingStatusCode).HasMaxLength(50);
                entity.Property(x => x.GunFreeSchoolsActReportingStatusDescription).HasMaxLength(200);
                entity.Property(x => x.GunFreeSchoolsActReportingStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusCode).HasMaxLength(50);
                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusDescription).HasMaxLength(200);
                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusEdFactsCode).HasMaxLength(50);

                // Indexes
                entity.HasIndex(p => new { p.ReapAlternativeFundingStatusCode, p.GunFreeSchoolsActReportingStatusCode, p.HighSchoolGraduationRateIndicatorStatusCode });

                entity.HasIndex(p => new { p.ReapAlternativeFundingStatusCode });
                entity.HasIndex(p => new { p.GunFreeSchoolsActReportingStatusCode });
                entity.HasIndex(p => new { p.HighSchoolGraduationRateIndicatorStatusCode });

            });

            //DimFirearms
            modelBuilder.Entity<DimFirearms>(entity =>
            {

                entity
                   .Property(x => x.DimFirearmsId)
                   .IsRequired();

                entity.Property(x => x.FirearmTypeCode).HasMaxLength(50);
                entity.Property(x => x.FirearmTypeDescription).HasMaxLength(200);
                entity.Property(x => x.FirearmTypeEdFactsCode).HasMaxLength(50);

                // Indexes

            });

            //DimFirearmsDiscipline
            modelBuilder.Entity<DimFirearmDiscipline>(entity =>
            {

                entity
                   .Property(x => x.DimFirearmDisciplineId)
                   .IsRequired();

                entity.Property(x => x.DisciplineMethodForFirearmsIncidentsCode).HasMaxLength(50);
                entity.Property(x => x.DisciplineMethodForFirearmsIncidentsDescription).HasMaxLength(200);
                entity.Property(x => x.DisciplineMethodForFirearmsIncidentsEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.IdeaDisciplineMethodForFirearmsIncidentsCode).HasMaxLength(50);
                entity.Property(x => x.IdeaDisciplineMethodForFirearmsIncidentsDescription).HasMaxLength(200);
                entity.Property(x => x.IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode).HasMaxLength(50);

                // Indexes

            });

            //DimComprehensiveAndTargetedSupport
            modelBuilder.Entity<DimComprehensiveAndTargetedSupport> (entity =>
            {

                entity
                   .Property(x => x.DimComprehensiveAndTargetedSupportId)
                   .IsRequired();

                entity.Property(x => x.ComprehensiveAndTargetedSupportCode).HasMaxLength(50);
                entity.Property(x => x.ComprehensiveAndTargetedSupportDescription).HasMaxLength(200);
                entity.Property(x => x.ComprehensiveAndTargetedSupportEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.ComprehensiveSupportCode).HasMaxLength(50);
                entity.Property(x => x.ComprehensiveSupportDescription).HasMaxLength(200);
                entity.Property(x => x.ComprehensiveSupportEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.TargetedSupportCode).HasMaxLength(50);
                entity.Property(x => x.TargetedSupportDescription).HasMaxLength(200);
                entity.Property(x => x.TargetedSupportEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.AdditionalTargetedSupportandImprovementCode).HasMaxLength(50);
                entity.Property(x => x.AdditionalTargetedSupportandImprovementDescription).HasMaxLength(200);
                entity.Property(x => x.AdditionalTargetedSupportandImprovementEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.ComprehensiveSupportImprovementCode).HasMaxLength(50);
                entity.Property(x => x.ComprehensiveSupportImprovementDescription).HasMaxLength(200);
                entity.Property(x => x.ComprehensiveSupportImprovementEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.TargetedSupportImprovementCode).HasMaxLength(50);
                entity.Property(x => x.TargetedSupportImprovementDescription).HasMaxLength(200);
                entity.Property(x => x.TargetedSupportImprovementEdFactsCode).HasMaxLength(50);

                // Indexes

            });

            //DimSchoolStateStatus
            modelBuilder.Entity<DimK12SchoolStateStatus>(entity =>
            {

                entity
                   .Property(x => x.DimK12SchoolStateStatusId)
                   .IsRequired();

                entity.Property(x => x.SchoolStateStatusCode).HasMaxLength(50);
                entity.Property(x => x.SchoolStateStatusDescription).HasMaxLength(200);
                entity.Property(x => x.SchoolStateStatusEdFactsCode).HasMaxLength(50);

                // Indexes

            });

            //DimOrganizationStatus
            modelBuilder.Entity<DimK12OrganizationStatus>(entity =>
            {

                entity
                   .Property(x => x.DimK12OrganizationStatusId)
                   .IsRequired();

                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusCode).HasMaxLength(50);
                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusDescription).HasMaxLength(200);
                entity.Property(x => x.HighSchoolGraduationRateIndicatorStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.GunFreeSchoolsActReportingStatusCode).HasMaxLength(50);
                entity.Property(x => x.GunFreeSchoolsActReportingStatusDescription).HasMaxLength(200);
                entity.Property(x => x.GunFreeSchoolsActReportingStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.ReapAlternativeFundingStatusCode).HasMaxLength(50);
                entity.Property(x => x.ReapAlternativeFundingStatusDescription).HasMaxLength(200);
                entity.Property(x => x.ReapAlternativeFundingStatusEdFactsCode).HasMaxLength(50);

                // Indexes

            });


            //DimCteStatus
            modelBuilder.Entity<DimCteStatus>(entity =>
            {

                entity
                    .Property(x => x.DimCteStatusId)
                    .IsRequired();

                entity.Property(x => x.CteProgramCode).HasMaxLength(50);
                entity.Property(x => x.CteProgramDescription).HasMaxLength(200);
                entity.Property(x => x.CteProgramEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.CteAeDisplacedHomemakerIndicatorCode).HasMaxLength(50);
                entity.Property(x => x.CteAeDisplacedHomemakerIndicatorDescription).HasMaxLength(200);
                entity.Property(x => x.CteAeDisplacedHomemakerIndicatorEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.CteNontraditionalGenderStatusCode).HasMaxLength(50);
                entity.Property(x => x.CteNontraditionalGenderStatusDescription).HasMaxLength(200);
                entity.Property(x => x.CteNontraditionalGenderStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.CteGraduationRateInclusionCode).HasMaxLength(50);
                entity.Property(x => x.CteGraduationRateInclusionDescription).HasMaxLength(200);
                entity.Property(x => x.CteGraduationRateInclusionEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.RepresentationStatusCode).HasMaxLength(50);
                entity.Property(x => x.RepresentationStatusDescription).HasMaxLength(200);
                entity.Property(x => x.RepresentationStatusEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.SingleParentOrSinglePregnantWomanCode).HasMaxLength(50);
                entity.Property(x => x.SingleParentOrSinglePregnantWomanDescription).HasMaxLength(200);
                entity.Property(x => x.SingleParentOrSinglePregnantWomanEdFactsCode).HasMaxLength(50);

                entity.Property(x => x.LepPerkinsStatusCode).HasMaxLength(50);
                entity.Property(x => x.LepPerkinsStatusDescription).HasMaxLength(200);
                entity.Property(x => x.LepPerkinsStatusEdFactsCode).HasMaxLength(50);


            });

            //DimEnrollmentStatus
            modelBuilder.Entity<DimK12EnrollmentStatus>(entity =>
            {

                entity
                    .Property(x => x.DimK12EnrollmentStatusId)
                    .IsRequired();

                entity.Property(x => x.ExitOrWithdrawalTypeCode).HasMaxLength(50);
                entity.Property(x => x.ExitOrWithdrawalTypeDescription).HasMaxLength(200);

                entity.Property(x => x.PostSecondaryEnrollmentStatusCode).HasMaxLength(50);
                entity.Property(x => x.PostSecondaryEnrollmentStatusDescription).HasMaxLength(200);
                entity.Property(x => x.PostSecondaryEnrollmentStatusEdFactsCode).HasMaxLength(50);

                entity
                   .Property(x => x.AcademicOrVocationalOutcomeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AcademicOrVocationalOutcomeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AcademicOrVocationalOutcomeEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.AcademicOrVocationalExitOutcomeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.AcademicOrVocationalExitOutcomeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.AcademicOrVocationalExitOutcomeEdFactsCode)
                   .HasMaxLength(50);



            });

            // DimNorDProgramStatus
            modelBuilder.Entity<DimNorDProgramStatus>(entity =>
            {
                entity.HasKey(d => d.DimNorDProgramStatusId);

                entity
                   .Property(x => x.DimNorDProgramStatusId)
                   .IsRequired();

                entity
                   .Property(x => x.LongTermStatusCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.LongTermStatusDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.LongTermStatusEdFactsCode)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.NeglectedProgramTypeCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.NeglectedProgramTypeDescription)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.NeglectedProgramTypeEdFactsCode)
                   .HasMaxLength(50);


                

            });

            //DimCharterSchoolStatus
            modelBuilder.Entity<DimCharterSchoolStatus>(entity =>
            {
                entity.Property(x => x.DimCharterSchoolStatusId).IsRequired();

                entity.Property(x => x.AppropriationMethodCode).HasMaxLength(50);
                entity.Property(x => x.AppropriationMethodDescription).HasMaxLength(200);
                entity.Property(x => x.AppropriationMethodEdFactsCode).HasMaxLength(50);
            });

            #endregion

            #region Bridge Tables


            modelBuilder.Entity<BridgeLeaGradeLevel>(entity =>
            {
                entity
              .Property(x => x.LeaId)
              .IsRequired();

                entity
                   .Property(x => x.GradeLevelId)
                   .IsRequired();

                entity
                    .HasKey(u => new
                    {
                        u.LeaId,
                        u.GradeLevelId
                    });

                entity
                   .HasOne(x => x.DimLea)
                   .WithMany(c => c.BridgeLeaGradeLevel)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(x => x.DimGradeLevel)
                    .WithMany(c => c.BridgeLeaGradeLevel)
                    .OnDelete(DeleteBehavior.Restrict);
            });


            modelBuilder.Entity<DimSchoolYearDataMigrationType>(entity =>
            {
                entity.HasKey(u => new
                {
                    u.DimSchoolYearId,
                    u.DataMigrationTypeId
                }).HasName("PK_DimSchoolYear_DimDataMigrationTypes");
                entity.ToTable("DimSchoolYearDataMigrationTypes", "RDS");
                entity.Property(x => x.DimSchoolYearId).IsRequired();
                entity.Property(x => x.DataMigrationTypeId).IsRequired();
                entity
                     .HasOne(pt => pt.DimDataMigrationType)
                     .WithMany(t => t.DimSchoolYearDataMigration).OnDelete(DeleteBehavior.Restrict)
                     .HasForeignKey(d => d.DataMigrationTypeId)
                    .HasConstraintName("FK_DimSchoolYear_DimDataMigrationTypes_DimDataMigrationTypes_DimDataMigrationTypeId");
                entity
                    .HasOne(pt => pt.DimSchoolYear)
                     .WithMany(t => t.DimSchoolYearDataMigration)
                     .OnDelete(DeleteBehavior.Restrict)
                     .HasForeignKey(d => d.DimSchoolYearId)
                    .HasConstraintName("FK_DimSchoolYear_DataMigrationTypes_DimSchoolYears_DimSchoolYearId"); ;



            });

            // DataMigrationType

            modelBuilder.Entity<DimDataMigrationTypes>(entity =>
            {

                entity.HasKey(u => new
                {
                    u.DimDataMigrationTypeId
                }).HasName("PK_DimDataMigrationTypes");

                entity
                   .HasKey(x => x.DimDataMigrationTypeId);


                entity
                   .Property(x => x.DataMigrationTypeCode)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DataMigrationTypeName)
                   .IsRequired()
                   .HasMaxLength(500);

            });

            #endregion

            #region Facts

            // FactStudentCount
            modelBuilder.Entity<FactK12StudentCount>(entity =>
            {

                entity
                   .Property(x => x.FactK12StudentCountId)
                   .IsRequired();

                // Facts

                entity
                   .Property(x => x.StudentCount)
                   .IsRequired();

                // Dimensions

                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.CountDateId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.StudentCountFacts)
                    .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12StudentId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimStudent)
                   .WithMany(c => c.FactK12StudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12SchoolId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimSchool)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.LeaId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimLea)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12DemographicId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimDemographic)
                   .WithMany(c => c.FactK12StudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.IdeaStatusId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimIdeaStatus)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.AgeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimAge)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                  .Property(x => x.GradeLevelId)
                  .IsRequired();
                entity
                   .HasOne(x => x.DimGradeLevel)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                 .Property(x => x.ProgramStatusId)
                 .IsRequired();
                entity
                   .HasOne(x => x.DimProgramStatus)
                   .WithMany(c => c.FactStudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                 .Property(x => x.TitleIStatusId)
                 .IsRequired();
                entity
                   .HasOne(x => x.DimTitle1Status)
                   .WithMany(c => c.FactK12StudentCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
				   .Property(x => x.LanguageId)
				   .IsRequired();
					entity
					   .HasOne(x => x.DimLanguage)
					   .WithMany(c => c.FactK12StudentCounts)
					   .OnDelete(DeleteBehavior.Restrict);

                entity
					.Property(x => x.MigrantId)
					.IsRequired();
					entity
						.HasOne(x => x.DimMigrant)
						.WithMany(c => c.FactK12StudentCounts)
						.OnDelete(DeleteBehavior.Restrict);

                entity
					.Property(x => x.StudentStatusId)
					.IsRequired();
					entity
						.HasOne(x => x.DimStudentStatus)
						.WithMany(c => c.FactStudentCounts)
						.OnDelete(DeleteBehavior.Restrict);

				entity
					.Property(x => x.TitleIIIStatusId)
					.IsRequired();
					entity
						.HasOne(x => x.DimTitleIIIStatus)
						.WithMany(c => c.FactK12StudentCounts)
						.OnDelete(DeleteBehavior.Restrict);

                entity
                 .Property(x => x.RaceId)
                 .IsRequired();
                entity
                        .HasOne(x => x.DimRace)
                        .WithMany(c => c.FactStudentCounts)
                        .OnDelete(DeleteBehavior.Restrict);

               

                // DimCohortStatus
                entity
                    .Property(x => x.CohortStatusId)
					.IsRequired();
				entity
					.HasOne(x => x.DimCohortStatuses)
					.WithMany(c => c.FactStudentCounts)
					.OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.NorDProgramStatusId)
                    .IsRequired();
                entity
                    .HasOne(x => x.DimNorDProgramStatus)
                    .WithMany(c => c.FactK12StudentCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.CteStatusId)
                    .IsRequired();
                entity
                    .HasOne(x => x.DimCteStatus)
                    .WithMany(c => c.FactStudentCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.EnrollmentStatusId)
                    .IsRequired();
                entity
                    .HasOne(x => x.DimEnrollmentStatus)
                    .WithMany(c => c.FactK12StudentCounts)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // FactOrganizationStatusCounts
            modelBuilder.Entity<FactOrganizationStatusCount>(entity => {
				entity.ToTable("FactOrganizationStatusCounts");
				entity.HasKey(x => x.FactOrganizationStatusCountId);

				// Dimensions
				entity
				   .Property(x => x.FactTypeId)
				   .IsRequired();
				entity
				   .HasOne(x => x.DimFactType)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p=>p.FactTypeId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimFactTypes");

				entity
				   .Property(x => x.CountDateId)
				   .IsRequired();
				entity
				   .HasOne(x => x.DimCountDate)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.CountDateId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimDates");

				entity
				   .Property(x => x.K12SchoolId)
				   .IsRequired();
				entity
				   .HasOne(x => x.DimSchool)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.K12SchoolId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimSchools");

				entity
				   .HasOne(x => x.DimRace)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.RaceId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimRaces");

				entity
				   .HasOne(x => x.DimIdeaStatus)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.IdeaStatusId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimIdeaStatuses");

				entity
				   .HasOne(x => x.DimDemographic)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.K12DemographicId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimDemographics");

				entity
				   .HasOne(x => x.DimIndicatorStatus)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.IndicatorStatusId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimIndicatorStatuses");

				entity
				   .HasOne(x => x.DimStateDefinedStatus)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.StateDefinedStatusId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimStateDefinedStatuses");

				entity
				   .HasOne(x => x.DimStateDefinedCustomIndicator)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.StateDefinedCustomIndicatorId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators");

				entity
				   .HasOne(x => x.DimIndicatorStatusType)
				   .WithMany(c => c.FactOrganizationStatusCount)
				   .HasForeignKey(p => p.IndicatorStatusTypeId)
				   .OnDelete(DeleteBehavior.Restrict)
				   .HasConstraintName("FK_FactOrganizationStatusCounts_DimIndicatorStatusTypes");

			});

			// FactStudentDiscipline
			modelBuilder.Entity<FactK12StudentDiscipline>(entity =>
            {

                entity
                   .Property(x => x.FactK12StudentDisciplineId)
                   .IsRequired();

                // Facts

                entity
                   .Property(x => x.DisciplineCount)
                   .IsRequired();

                entity
                   .Property(x => x.DisciplineDuration)
                   .HasColumnType("decimal(18,2)")
                   .IsRequired();

                entity
                   .Property(x => x.DisciplinaryActionStartDate)
                   .IsRequired();


                // Dimensions

                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.CountDateId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.FactStudentDisciplines)
                    .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12StudentId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimStudent)
                   .WithMany(c => c.FactK12StudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.DisciplineId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimDiscipline)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12SchoolId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimSchool)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.LeaId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimLea)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12DemographicId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimDemographic)
                   .WithMany(c => c.FactK12StudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.IdeaStatusId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimIdeaStatus)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.AgeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimAge)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                 .Property(x => x.ProgramStatusId)
                 .IsRequired();
                entity
                   .HasOne(x => x.DimProgramStatus)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.RaceId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimRace)
                   .WithMany(c => c.FactStudentDisciplines)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.CteStatusId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCteStatus)
                    .WithMany(c => c.FactStudentDisciplines)
                    .OnDelete(DeleteBehavior.Restrict);


            });

            // FactStudentAssessment
            modelBuilder.Entity<FactK12StudentAssessment>(entity =>
            {

                entity
                   .Property(x => x.FactK12StudentAssessmentId)
                   .IsRequired();

                // Facts
                entity
                   .Property(x => x.AssessmentCount)
                   .IsRequired();

                // Dimensions
                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.CountDateId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.FactStudentAssessments)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.K12StudentId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimStudent)
                   .WithMany(c => c.FactK12StudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.AssessmentId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimAssessment)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.GradeLevelId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimGradeLevel)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.K12SchoolId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimSchool)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                  .Property(x => x.LeaId)
                  .IsRequired();
                entity
                   .HasOne(x => x.DimLea)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.K12DemographicId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimDemographic)
                   .WithMany(c => c.FactK12StudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.IdeaStatusId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimIdeaStatus)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.ProgramStatusId)
                    .IsRequired();
                entity
                   .HasOne(x => x.DimProgramStatus)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.TitleIStatusId)
                    .IsRequired();
                entity
                   .HasOne(x => x.DimTitle1Status)
                   .WithMany(c => c.FactK12StudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.TitleIIIStatusId)
                    .IsRequired();
                entity
                   .HasOne(x => x.DimTitleIIIStatus)
                   .WithMany(c => c.FactK12StudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
					.Property(x => x.StudentStatusId)
					.IsRequired();
                entity
                   .HasOne(x => x.DimStudentStatus)
                   .WithMany(c => c.FactStudentAssessments)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.AssessmentStatusId)
                   .IsRequired();
                entity
                  .HasOne(x => x.DimAssessmentStatus)
                  .WithMany(c => c.FactStudentAssessments)
                  .OnDelete(DeleteBehavior.Restrict);

				entity
				   .Property(x => x.NorDProgramStatusId)
				   .IsRequired();
				entity
				  .HasOne(x => x.DimNorDProgramStatuses)
				  .WithMany(c => c.FactK12StudentAssessments)
				  .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.RaceId)
                   .IsRequired();
                entity
                  .HasOne(x => x.DimRace)
                  .WithMany(c => c.FactStudentAssessments)
                  .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.CteStatusId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCteStatus)
                    .WithMany(c => c.FactStudentAssessments)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.EnrollmentStatusId)
                    .IsRequired();
                entity
                    .HasOne(x => x.DimEnrollmentStatus)
                    .WithMany(c => c.FactK12StudentAssessments)
                    .OnDelete(DeleteBehavior.Restrict);

            });

            // FactK12StaffCount
            modelBuilder.Entity<FactK12StaffCount>(entity =>
            {

                entity
                   .Property(x => x.FactK12StaffCountId)
                   .IsRequired();

                entity
                   .Property(x => x.StaffFTE)
                   .HasColumnType("decimal(18,2)")
                   .IsRequired();
                

                // Facts

                entity
                   .Property(x => x.StaffCount)
                   .IsRequired();



                // Dimensions

                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactPersonnelCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.CountDateId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.FactPersonnelCounts)
                    .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12StaffId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimPersonnel)
                   .WithMany(c => c.FactPersonnelCounts)
                   .OnDelete(DeleteBehavior.Restrict);




                entity
                   .Property(x => x.K12SchoolId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimSchool)
                   .WithMany(c => c.FactPersonnelCounts)
                   .OnDelete(DeleteBehavior.Restrict);




                entity
                   .Property(x => x.K12StaffStatusId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimPersonnelStatus)
                   .WithMany(c => c.FactPersonnelCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                  .Property(x => x.K12StaffCategoryId)
                  .IsRequired();
                entity
                   .HasOne(x => x.DimPersonnelCategory)
                   .WithMany(c => c.FactK12StaffCounts)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.TitleIIIStatusId)
                    .IsRequired();
                entity
                   .HasOne(x => x.DimTitleIIIStatus)
                   .WithMany(c => c.FactK12StaffCounts)
                   .OnDelete(DeleteBehavior.Restrict);
            });

            //FactOrganizationCount
            modelBuilder.Entity<FactOrganizationCount>(entity =>
            {
                entity
                 .Property(x => x.FactOrganizationCountId)
                 .IsRequired();

                // Facts

                entity
                   .Property(x => x.OrganizationCount)
                   .IsRequired();

                entity
                    .Property(x => x.TitleIParentalInvolveRes)
                    .IsRequired();

                entity.
                    Property(x => x.TitleIPartAAllocations)
                    .IsRequired();


                entity
                 .Property(x => x.FactTypeId)
                 .IsRequired();

                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactOrganizationCounts)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.SchoolYearId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);


                entity
                 .Property(x => x.SeaId)
                 .IsRequired();

                entity
                .Property(x => x.FederalFundAllocated)
                .IsRequired();

                entity
                    .HasOne(x => x.DimSea)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                .Property(x => x.LeaId)
                .IsRequired();
                entity
                    .HasOne(x => x.DimLea)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
              .Property(x => x.K12SchoolId)
              .IsRequired();
                entity
                    .HasOne(x => x.DimSchool)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
            .Property(x => x.K12StaffId)
            .IsRequired();
                entity
                    .HasOne(x => x.DimPersonnel)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);


              
                entity
                  .Property(x => x.SchoolStatusId)
                  .IsRequired();

                entity
                    .HasOne(x => x.DimSchoolStatus)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.TitleIStatusId)
                   .IsRequired();

                entity
                    .HasOne(x => x.DimTitle1Status)
                    .WithMany(c => c.FactOrganizationCounts)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(x => x.DimCharterSchoolAuthorizer)
                    .WithMany(c => c.FactOrganizationCounts_CharterAuthorizer)
                    .HasForeignKey(x => x.CharterSchoolApproverAgencyId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(x => x.DimCharterSchoolManagementOrganization)
                    .WithMany(c => c.FactOrganizationCounts_CharterSchoolManagementOrganization)
                    .HasForeignKey(x => x.CharterSchoolManagerOrganizationId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(x => x.DimCharterSchoolSecondaryAuthorizer)
                    .WithMany(c => c.FactOrganizationCounts_SecondaryCharterAuthorizer)
                    .HasForeignKey(x => x.CharterSchoolSecondaryApproverAgencyId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .HasOne(x => x.DimCharterSchoolUpdatedManagementOrganization)
                    .WithMany(c => c.FactOrganizationCounts_CharterSchoolUpdatedManagementOrganization)
                    .HasForeignKey(x => x.CharterSchoolUpdatedManagerOrganizationId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                    .Property(x => x.ComprehensiveAndTargetedSupportId)
                    .IsRequired();


                entity
                    .HasOne(x => x.DimSchoolStateStatus)
                    .WithMany(c => c.FactOrganizationCounts)
                    .HasForeignKey(x => x.SchoolStateStatusId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity
                   .HasOne(x => x.DimCharterSchoolStatus)
                   .WithMany(c => c.FactOrganizationCounts)
                   .HasForeignKey(x => x.CharterSchoolStatusId)
                   .OnDelete(DeleteBehavior.Restrict);

            });

            //FactK12StudentAttendance
            modelBuilder.Entity<FactK12StudentAttendance>(entity =>
            {

                entity
                   .Property(x => x.FactK12StudentAttendanceId)
                   .IsRequired();

                // Facts

                entity
                   .Property(x => x.StudentAttendanceRate)
                   .IsRequired();

                // Dimensions

                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimFactType)
                   .WithMany(c => c.FactK12StudentAttendance)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.CountDateId)
                   .IsRequired();
                entity
                    .HasOne(x => x.DimCountDate)
                    .WithMany(c => c.FactK12StudentAttendance)
                    .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12StudentId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimStudent)
                   .WithMany(c => c.FactK12StudentAttendance)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12SchoolId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimSchool)
                   .WithMany(c => c.FactK12StudentAttendance)
                   .OnDelete(DeleteBehavior.Restrict);

                entity
                   .Property(x => x.LeaId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimLea)
                   .WithMany(c => c.FactK12StudentAttendance)
                   .OnDelete(DeleteBehavior.Restrict);


                entity
                   .Property(x => x.K12DemographicId)
                   .IsRequired();
                entity
                   .HasOne(x => x.DimDemographic)
                   .WithMany(c => c.FactK12StudentAttendance)
                   .OnDelete(DeleteBehavior.Restrict);

              
            });

            #endregion

            #region Reports
            // FactOrganizationIndicatorStatusReport
            modelBuilder.Entity<ReportEDFactsOrganizationStatusCount>(entity => 
			{
				entity
				   .Property(x => x.ReportEDFactsOrganizationStatusCountId)
				   .IsRequired();

				entity
					.HasKey(u => new
					{
						u.ReportEDFactsOrganizationStatusCountId
                    });

				entity
				   .Property(x => x.Categories)
				   .HasMaxLength(300);

				entity
				   .Property(x => x.CategorySetCode)
				   .HasMaxLength(40)
				   .IsRequired();

				entity
				   .Property(x => x.ReportCode)
				   .HasMaxLength(40)
				   .IsRequired();

				entity
				   .Property(x => x.ReportLevel)
				   .HasMaxLength(40)
				   .IsRequired();

				entity
				   .Property(x => x.ReportYear)
				   .HasMaxLength(40)
				   .IsRequired();

				entity
				   .Property(x => x.StateANSICode)
				   .HasMaxLength(100)
				   .IsRequired();

				entity
				   .Property(x => x.StateCode)
				   .HasMaxLength(100)
				   .IsRequired();

				entity
				   .Property(x => x.StateName)
				   .HasMaxLength(500)
				   .IsRequired();

				entity
				   .Property(x => x.OrganizationName)
				   .HasMaxLength(1000)
				   .IsRequired();

				entity
				   .Property(x => x.OrganizationNcesId)
				   .HasMaxLength(100);

				entity
				   .Property(x => x.OrganizationStateId)
				   .HasMaxLength(100)
				   .IsRequired();

				entity
				   .Property(x => x.ParentOrganizationStateId)
				   .HasMaxLength(100);

				entity
				   .Property(x => x.RACE)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.DISABILITY)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.LEPSTATUS)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.ECODISSTATUS)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.INDICATORSTATUS)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.STATEDEFINEDSTATUSCODE)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.STATEDEFINEDCUSTOMINDICATORCODE)
				   .HasMaxLength(50);

				entity
				   .Property(x => x.INDICATORSTATUSTYPECODE)
				   .HasMaxLength(50);

				// Indices
				entity
				   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });
			});

			// FactCustomCount
			modelBuilder.Entity<FactCustomCount>(entity =>
            {
                entity
                   .Property(x => x.FactCustomCountId)
                   .IsRequired();

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(500)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationNcesId)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.OrganizationStateId)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.ParentOrganizationStateId)
                   .HasMaxLength(100);

                entity
                  .Property(x => x.Category1)
                  .HasMaxLength(100);

                entity
                 .Property(x => x.Category2)
                 .HasMaxLength(100);

                entity
                 .Property(x => x.Category3)
                 .HasMaxLength(100);

                entity
                 .Property(x => x.Category4)
                 .HasMaxLength(100);

                entity
                  .Property(x => x.Col_1)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_10)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_10a)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_10b)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11a)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11b)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11c)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11d)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_11e)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_12)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_12a)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_12b)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_13)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_14)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_14a)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_14b)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_14c)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_14d)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_15)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_16)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_17)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18a)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18b)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18c)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18d)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18e)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18f)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18g)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18h)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_18i)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_2)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_3)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_4)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_5)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_6)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_7)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_8)
                  .HasColumnType("decimal(18,2)");
                entity
                  .Property(x => x.Col_9)
                  .HasColumnType("decimal(18,2)");



                // Indices

                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });

            });

        
            modelBuilder.Entity<DimCharterSchoolAuthorizer>(entity =>
            {
                entity
                   .Property(x => x.DimCharterSchoolAuthorizerId)
                   .IsRequired();
               
                entity
                 .Property(x => x.StateIdentifier)
                 .HasMaxLength(100);

                entity
                .Property(x => x.State)
                .HasMaxLength(50);

                entity
                .Property(x => x.StateCode)
                .HasMaxLength(10);

                entity
                .Property(x => x.StateANSICode);

            });

            // FactStudentCountReport
            modelBuilder.Entity<ReportEDFactsK12StudentCount>(entity =>
            {
                entity
                   .Property(x => x.ReportEDFactsK12StudentCountId)
                   .IsRequired();

                entity
                   .Property(x => x.ADJUSTEDCOHORTGRADUATIONRATE)
                   .HasColumnType("decimal(9,2)");


                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.Categories)
                   .HasMaxLength(300);

                entity
                   .Property(x => x.TableTypeAbbrv)
                   .HasMaxLength(100);
                entity
                   .Property(x => x.TotalIndicator)
                   .HasMaxLength(5);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(500)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationIdentifierNces)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.OrganizationIdentifierSea)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.ParentOrganizationIdentifierSea)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.AGE)
                   .HasMaxLength(50);
                entity
                  .Property(x => x.GRADELEVEL)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.ECONOMICDISADVANTAGESTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.HOMELESSNESSSTATUS)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ENGLISHLEARNERSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.MIGRANTSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SEX)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.MILITARYCONNECTEDSTUDENTINDICATOR)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSUNACCOMPANIEDYOUTHSTATUS)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSPRIMARYNIGHTTIMERESIDENCE)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.SPECIALEDUCATIONEXITREASON)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.IDEADISABILITYTYPE)
                   .HasMaxLength(50);
                entity
                  .Property(x => x.IDEAINDICATOR)
                  .HasMaxLength(50);
                entity
                   .Property(x => x.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD)
                   .HasMaxLength(50);
                entity
                  .Property(x => x.TITLEISCHOOLSTATUS)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.SECTION504STATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.CTEPARTICIPANT)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS)
                   .HasMaxLength(50);
                entity
                  .Property(x => x.TITLEIIIIMMIGRANTPARTICIPATIONSTATUS)
                  .HasMaxLength(50);
                entity
                 .Property(x => x.PROGRAMPARTICIPATIONFOSTERCARE)
                 .HasMaxLength(50);

                entity
                .Property(x => x.TITLEIIIIMMIGRANTSTATUS)
                .HasMaxLength(50);

                entity
                .Property(x => x.HOMELESSSERVICEDINDICATOR)
                .HasMaxLength(50);

                entity
                   .Property(x => x.RACE)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.ISO6392LANGUAGECODE)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.HIGHSCHOOLDIPLOMATYPE)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.TITLEIINSTRUCTIONALSERVICES)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.TITLEISUPPORTSERVICES)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.MIGRANTPRIORITIZEDFORSERVICES)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.CONTINUATIONOFSERVICESREASON)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.MOBILITYSTATUS12MO)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.MOBILITYSTATUSSY)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.REFERRALSTATUS)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.TITLEIINDICATOR)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.MIGRANTEDUCATIONPROGRAMSERVICESTYPE)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.CONSOLIDATEDMEPFUNDSSTATUS)
                  .HasMaxLength(50);

                entity
                 .Property(x => x.MIGRANTEDUCATIONPROGRAMENROLLMENTTYPE)
                 .HasMaxLength(50);

                entity
               .Property(x => x.TITLEIIIACCOUNTABILITYPROGRESSSTATUS)
               .HasMaxLength(50);

                entity
               .Property(x => x.TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE)
               .HasMaxLength(50);

                entity
               .Property(x => x.PROFICIENCYSTATUS)
               .HasMaxLength(50);

                entity
               .Property(x => x.FORMERENGLISHLEARNERYEARSTATUS)
               .HasMaxLength(50);

                entity
               .Property(x => x.REPRESENTATIONSTATUS)
               .HasMaxLength(50);

                entity
              .Property(x => x.NEGLECTEDORDELINQUENTLONGTERMSTATUS)
              .HasMaxLength(50);

                entity
              .Property(x => x.NEGLECTEDORDELINQUENTPROGRAMTYPE)
              .HasMaxLength(50);

                entity
                .Property(x => x.EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE)
                .HasMaxLength(50);

                entity
               .Property(x => x.EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE)
               .HasMaxLength(50);

                entity
                 .Property(x => x.CTEAEDISPLACEDHOMEMAKERINDICATOR)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.CTEGRADUATIONRATEINCLUSION)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.CTENONTRADITIONALGENDERSTATUS)
                 .HasMaxLength(50);

                entity
                .Property(x => x.PERKINSENGLISHLEARNERSTATUS)
                .HasMaxLength(50);

                entity
                   .Property(x => x.StudentCount)
                   .IsRequired();

                entity
                  .Property(x => x.ADJUSTEDCOHORTGRADUATIONRATE);

                // Indices

                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });

            });


            // FactStudentDisciplineReport
            modelBuilder.Entity<ReportEDFactsK12StudentDiscipline>(entity =>
            {
                entity
                   .Property(x => x.ReportEDFactsK12StudentDisciplineId)
                   .IsRequired();

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.Categories)
                   .HasMaxLength(300);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000)
                   .IsRequired();               

                entity
                   .Property(x => x.OrganizationIdentifierNces)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.OrganizationIdentifierSea)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.AGE)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ECONOMICDISADVANTAGESTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.HOMELESSNESSSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ENGLISHLEARNERSTATUS)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SEX)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.MILITARYCONNECTEDSTUDENTINDICATOR)
                    .HasMaxLength(50);

                entity
                 .Property(x => x.HOMELESSUNACCOMPANIEDYOUTHSTATUS)
                 .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSPRIMARYNIGHTTIMERESIDENCE)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.SPECIALEDUCATIONEXITREASON)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.IDEADISABILITYTYPE)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.IDEAINDICATOR)
                 .HasMaxLength(50);
                entity
                   .Property(x => x.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD)
                   .HasMaxLength(50);
                
                entity
                    .Property(x => x.SECTION504STATUS)
                    .HasMaxLength(50);
                entity
                   .Property(x => x.CTEPARTICIPANT)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS)
                   .HasMaxLength(50);
                entity
                  .Property(x => x.TITLEIIIIMMIGRANTPARTICIPATIONSTATUS)
                  .HasMaxLength(50);
                entity
                 .Property(x => x.PROGRAMPARTICIPATIONFOSTERCARE)
                 .HasMaxLength(50);
                entity
                 .Property(x => x.TITLEIIIIMMIGRANTSTATUS)
                 .HasMaxLength(50);

                entity
               .Property(x => x.HOMELESSSERVICEDINDICATOR)
               .HasMaxLength(50);


                entity
                   .Property(x => x.DISCIPLINARYACTIONTAKEN)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.DISCIPLINEMETHODOFCHILDRENWITHDISABILITIES)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.EDUCATIONALSERVICESAFTERREMOVAL)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.IDEAINTERIMREMOVALREASON)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.IDEAINTERIMREMOVAL)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.REMOVALLENGTH)
                   .HasMaxLength(50);

                entity
               .Property(x => x.CTEAEDISPLACEDHOMEMAKERINDICATOR)
               .HasMaxLength(50);

                entity
                 .Property(x => x.CTEGRADUATIONRATEINCLUSION)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.CTENONTRADITIONALGENDERSTATUS)
                 .HasMaxLength(50);

                entity
                .Property(x => x.REPRESENTATIONSTATUS)
                .HasMaxLength(50);

                entity
               .Property(x => x.ENGLISHLEARNERSTATUS)
               .HasMaxLength(50);



                entity
                   .Property(x => x.RACE)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.DisciplineCount)
                   .IsRequired();

                // Indices

                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });

            });

            // FactStudentAssessmentReport
            modelBuilder.Entity<ReportEDFactsK12StudentAssessment>(entity =>
            {
                entity
                   .Property(x => x.ReportEDFactsK12StudentAssessmentId)
                   .IsRequired();

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.Categories)
                   .HasMaxLength(300);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000)
                   .IsRequired();                          

                entity
                   .Property(x => x.OrganizationIdentifierNces)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.OrganizationIdentifierSea)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.ECONOMICDISADVANTAGESTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.HOMELESSNESSSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ENGLISHLEARNERSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.MIGRANTSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SEX)
                   .HasMaxLength(50);

                entity.Property(x => x.MILITARYCONNECTEDSTUDENTINDICATOR).HasMaxLength(50);

                entity
                 .Property(x => x.HOMELESSUNACCOMPANIEDYOUTHSTATUS)
                 .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSPRIMARYNIGHTTIMERESIDENCE)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentAcademicSubject)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ASSESSMENTTYPE)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.NEGLECTEDORDELINQUENTPROGRAMTYPE)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.PROGRESSLEVEL)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.FULLYEARSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.GRADELEVEL)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ASSESSMENTPERFORMANCELEVELIDENTIFIER)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SPECIALEDUCATIONEXITREASON)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.IDEAINDICATOR)
                 .HasMaxLength(50);
                entity
                   .Property(x => x.IDEAEDUCATIONALENVIRONMENTFOREARLYCHILDHOOD)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.IDEAEDUCATIONALENVIRONMENTFORSCHOOLAGE)
                   .HasMaxLength(50);


                entity
                   .Property(x => x.CTEPARTICIPANT)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.ELIGIBILITYSTATUSFORSCHOOLFOODSERVICEPROGRAMS)
                   .HasMaxLength(50);

                entity
               .Property(x => x.HOMELESSSERVICEDINDICATOR)
               .HasMaxLength(50);

                entity
                 .Property(x => x.PROGRAMPARTICIPATIONFOSTERCARE)
                 .HasMaxLength(50);

                entity
                   .Property(x => x.RACE)
                   .HasMaxLength(50);

                entity
                .Property(x => x.TITLEIIIACCOUNTABILITYPROGRESSSTATUS)
                .HasMaxLength(50);

                entity
                 .Property(x => x.TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE)
                 .HasMaxLength(50);

                entity
                .Property(x => x.PROFICIENCYSTATUS)
                .HasMaxLength(50);

                entity
                 .Property(x => x.FORMERENGLISHLEARNERYEARSTATUS)
                .HasMaxLength(50);

                entity
                   .Property(x => x.ASSESSEDFIRSTTIME)
                   .HasMaxLength(50);

                entity
                 .Property(x => x.HIGHSCHOOLDIPLOMATYPE)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.MOBILITYSTATUS12MO)
                 .HasMaxLength(50);

                entity
                  .Property(x => x.MOBILITYSTATUSSY)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.REFERRALSTATUS)
                  .HasMaxLength(50);


                entity
               .Property(x => x.REPRESENTATIONSTATUS)
               .HasMaxLength(50);

                entity
               .Property(x => x.CTEAEDISPLACEDHOMEMAKERINDICATOR)
               .HasMaxLength(50);

                entity
                 .Property(x => x.CTEGRADUATIONRATEINCLUSION)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.SINGLEPARENTORSINGLEPREGNANTWOMANSTATUS)
                 .HasMaxLength(50);

                entity
                 .Property(x => x.CTENONTRADITIONALGENDERSTATUS)
                 .HasMaxLength(50);

                entity
               .Property(x => x.PERKINSENGLISHLEARNERSTATUS)
               .HasMaxLength(50);


                entity
               .Property(x => x.TESTRESULT)
               .HasMaxLength(50);

                entity
               .Property(x => x.EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMETYPE)
               .HasMaxLength(50);

                entity
               .Property(x => x.EDFACTSACADEMICORCAREERANDTECHNICALOUTCOMEEXITTYPE)
               .HasMaxLength(50);

                entity
                 .Property(x => x.TITLEISCHOOLSTATUS)
                 .HasMaxLength(50);

                entity
               .Property(x => x.TITLEIPROGRAMTYPE)
               .HasMaxLength(50);

                entity
               .Property(x => x.TITLEIINSTRUCTIONALSERVICES)
               .HasMaxLength(50);

                entity
                  .Property(x => x.TITLEISUPPORTSERVICES)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.ASSESSMENTTYPEADMINISTERED)
                  .HasMaxLength(50);

                entity
                   .Property(x => x.AssessmentCount)
                   .IsRequired();

                // Index
                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });
            });

            // FactStudentAssessmentReportDto
            modelBuilder.Entity<FactStudentAssessmentReportDto>(entity =>
            {
                entity
                   .Property(x => x.FactStudentAssessmentReportDtoId)
                   .IsRequired();

                entity
                    .HasKey(u => new
                    {
                        u.FactStudentAssessmentReportDtoId
                    });
            });

            // FactPersonnelCountReport
            modelBuilder.Entity<ReportEDFactsK12StaffCount>(entity =>
            {
                entity
                   .Property(x => x.ReportEDFactsK12StaffCountId)
                   .IsRequired();

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.Categories)
                   .HasMaxLength(300);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateAbbreviationDescription)
                   .HasMaxLength(1000)
                   .IsRequired();


                entity
                   .Property(x => x.OrganizationIdentifierNces)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.OrganizationIdentifierSea)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.SPECIALEDUCATIONAGEGROUPTAUGHT)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.EDFACTSCERTIFICATIONSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.K12STAFFCLASSIFICATION)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SPECIALEDUCATIONTEACHERQUALIFICATIONSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SPECIALEDUCATIONSUPPORTSERVICESCATEGORY)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.TITLEIPROGRAMSTAFFCATEGORY)
                 .HasMaxLength(50);

                entity
              .Property(x => x.TITLEIIIACCOUNTABILITYPROGRESSSTATUS)
              .HasMaxLength(50);

                entity
               .Property(x => x.TITLEIIILANGUAGEINSTRUCTIONPROGRAMTYPE)
               .HasMaxLength(50);

                entity
               .Property(x => x.PROFICIENCYSTATUS)
               .HasMaxLength(50);

                entity
               .Property(x => x.FORMERENGLISHLEARNERYEARSTATUS)
               .HasMaxLength(50);

                entity
                   .Property(x => x.StaffCount)
                   .IsRequired();

                entity
                   .Property(x => x.StaffFullTimeEquivalency)
                   .HasColumnType("decimal(18,2)")
                   .IsRequired();

                // Indices
                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });
            });

            // FactOrganizationCountReport
            modelBuilder.Entity<ReportEDFactsOrganizationCount>(entity =>
            {
                entity
               .Property(x => x.ReportEDFactsOrganizationCountId)
               .IsRequired();

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                .Property(x => x.TableTypeAbbrv)
                .HasMaxLength(100);

                entity
                   .Property(x => x.TotalIndicator)
                   .HasMaxLength(5);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationNcesId)
                   .HasMaxLength(100);


                entity
                   .Property(x => x.OrganizationStateId)
                   .HasMaxLength(100);


                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.ParentOrganizationNcesId)
                   .HasMaxLength(100);


                entity
                   .Property(x => x.ParentOrganizationStateId)
                   .HasMaxLength(100);


                entity
                 .Property(x => x.CSSOFirstName)
                 .HasMaxLength(100);

                entity
                .Property(x => x.CSSOLastOrSurname)
                .HasMaxLength(100);

                entity
                .Property(x => x.CSSOTitle)
                .HasMaxLength(100);

                entity
                .Property(x => x.CSSOTelephone)
                .HasMaxLength(24);

                entity
                .Property(x => x.CSSOEmail)
                .HasMaxLength(100);

                entity
                .Property(x => x.Website)
                .HasMaxLength(100);

                entity
                .Property(x => x.Telephone)
                .HasMaxLength(24);

                entity
                .Property(x => x.MailingAddressStreet)
                .HasMaxLength(100);

                entity
                .Property(x => x.MailingAddressCity)
                .HasMaxLength(50);

                entity
                .Property(x => x.MailingAddressState)
                .HasMaxLength(50);

                entity
                .Property(x => x.MailingAddressPostalCode)
                .HasMaxLength(17);

                entity
               .Property(x => x.MailingAddressPostalCode2)
               .HasMaxLength(17);

                entity
                .Property(x => x.PhysicalAddressStreet)
                .HasMaxLength(100);

                entity
                .Property(x => x.PhysicalAddressCity)
                .HasMaxLength(50);

                entity
                .Property(x => x.PhysicalAddressState)
                .HasMaxLength(50);

                entity
                .Property(x => x.PhysicalAddressPostalCode)
                .HasMaxLength(17);

                entity
               .Property(x => x.PhysicalAddressPostalCode2)
               .HasMaxLength(17);

                entity.
                Property(e => e.SupervisoryUnionIdentificationNumber).HasColumnType("nchar(3)");


                entity
                .Property(x => x.OperationalStatus)
                .HasMaxLength(50);

                entity
                .Property(x => x.OperationalStatusId);

                entity
                .Property(x => x.UpdatedOperationalStatus)
                .HasMaxLength(50);

                entity
                .Property(x => x.UpdatedOperationalStatusId);

                entity
                .Property(x => x.LEAType)
                .HasMaxLength(50);

                entity
               .Property(x => x.LEATypeDescription);


                entity
                .Property(x => x.SchoolType)
                .HasMaxLength(50);

                entity
                .Property(x => x.SchoolTypeDescription);


                entity
               .Property(x => x.OutOfStateIndicator)
               .HasDefaultValue(0);

                entity
                .Property(x => x.ReconstitutedStatus)
                .HasMaxLength(100);

                entity
                .Property(x => x.CharterSchoolStatus)
                .HasMaxLength(100);

                entity
                .Property(x => x.CharterLeaStatus)
                .HasMaxLength(100);

                entity
                .Property(x => x.CharterSchoolAuthorizerIdPrimary)
                .HasMaxLength(50);

                entity
                .Property(x => x.CharterSchoolAuthorizerIdSecondary)
                .HasMaxLength(50);

                entity
                .Property(x => x.GRADELEVEL)
                .HasMaxLength(50);

                entity
                .Property(x => x.EffectiveDate)
                .HasMaxLength(50);

                entity
                .Property(x => x.PriorLeaStateIdentifier)
                .HasMaxLength(50);

                entity
                .Property(x => x.PriorSchoolStateIdentifier)
                .HasMaxLength(50);

                entity
                 .Property(x => x.TitleiParentalInvolveRes)
                 .IsRequired();

                entity.
                    Property(x => x.TitleiPartaAllocations)
                    .IsRequired();

                entity
                   .Property(x => x.PROGRESSACHIEVINGENGLISHLANGUAGE)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.EconomicallyDisadvantagedStudentCount);

                entity
                 .Property(x => x.SCHOOLIMPROVEMENTFUNDS);

                entity
               .Property(x => x.STATEPOVERTYDESIGNATION);

                entity
                .Property(x => x.CharterSchoolContractIdNumber);

                entity
                .Property(x => x.CharterContractApprovalDate);

                entity
               .Property(x => x.CharterContractRenewalDate);

                entity
                .Property(x => x.CharterSchoolManagementOrganization);

                entity.Property(x => x.ManagementOrganizationType);

                entity
                    .Property(x => x.FederalFundAllocationType);


                entity
                    .Property(x => x.FederalProgramCode);

                entity
                  .Property(x => x.FederalFundAllocated);
                // Indices

                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });

                entity
               .Property(x => x.ComprehensiveAndTargetedSupportCode);

                entity
               .Property(x => x.ComprehensiveSupportCode);

                entity
               .Property(x => x.TargetedSupportCode);

                entity
                .Property(x => x.AdditionalTargetedSupportandImprovementCode);

                entity
                    .Property(x => x.AppropriationMethodCode);

            });

            // FactK12StudentAttendanceReport
            modelBuilder.Entity<FactK12StudentAttendanceReport>(entity =>
            {
                entity
                   .Property(x => x.FactK12StudentAttendanceReportId)
                   .IsRequired();

                entity
                   .Property(x => x.StudentAttendanceRate)
                   .HasColumnType("decimal(18,3)");


                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportLevel)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.ReportYear)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.CategorySetCode)
                   .HasMaxLength(40)
                   .IsRequired();

                entity
                   .Property(x => x.Categories)
                   .HasMaxLength(300);

                entity
                   .Property(x => x.TableTypeAbbrv)
                   .HasMaxLength(100);
                entity
                   .Property(x => x.TotalIndicator)
                   .HasMaxLength(5);

                entity
                   .Property(x => x.StateANSICode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateCode)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.StateName)
                   .HasMaxLength(500)
                   .IsRequired();

                //entity
                //   .Property(x => x.OrganizationId)
                //   .IsRequired();

                entity
                   .Property(x => x.OrganizationNcesId)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationStateId)
                   .HasMaxLength(100)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationName)
                   .HasMaxLength(1000)
                   .IsRequired();

                entity
                   .Property(x => x.ParentOrganizationStateId)
                   .HasMaxLength(100);

               
                entity
                   .Property(x => x.ECODISSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.HOMELESSSTATUS)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.LEPSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.MIGRANTSTATUS)
                   .HasMaxLength(50);
                entity
                   .Property(x => x.SEX)
                   .HasMaxLength(50);

                entity
                  .Property(x => x.MILITARYCONNECTEDSTATUS)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSUNACCOMPANIEDYOUTHSTATUS)
                  .HasMaxLength(50);

                entity
                  .Property(x => x.HOMELESSNIGHTTIMERESIDENCE)
                  .HasMaxLength(50);

               
                entity
                   .Property(x => x.RACE)
                   .HasMaxLength(50);

                entity
                    .Property(x => x.ATTENDANCE)
                    .HasMaxLength(50);

                // Indices

                entity
                   .HasIndex(p => new { p.ReportCode, p.ReportYear, p.ReportLevel, p.CategorySetCode });

            });

            // FactK12StudentAttendanceReportDto
            modelBuilder.Entity<FactK12StudentAttendanceReportDto>(entity =>
            {
                entity
                   .Property(x => x.FactK12StudentAttendanceReportDtoId)
                   .IsRequired();


                entity
                    .HasKey(u => new
                    {
                        u.FactK12StudentAttendanceReportDtoId
                    });

            });

            modelBuilder.Entity<OrganizationDto>(entity =>
            {
                entity
                   .Property(x => x.OrganizationId)
                   .IsRequired();

                entity
                    .HasKey(u => new
                    {
                        u.OrganizationId
                    });

            });

            modelBuilder.Entity<GradeLevelDto>(entity =>
            {
                entity
                   .Property(x => x.RefGradeLevelId)
                   .IsRequired();

                entity
                    .HasKey(u => new
                    {
                        u.RefGradeLevelId
                    });

            });

            modelBuilder.Entity<AssessmentTypeChildrenWithDisabilitiesDto>(entity =>
            {
                entity
                   .Property(x => x.RefAssessmentTypeChildrenWithDisabilitiesId)
                   .IsRequired();

                entity
                    .HasKey(u => new
                    {
                        u.RefAssessmentTypeChildrenWithDisabilitiesId
                    });

            });

            #endregion
        }

        #region DbSets

        // Dimensions      
        public DbSet<DimAge> DimAges { get; set; }
        public DbSet<DimAssessment> DimAssessments { get; set; }
        public DbSet<DimGradeLevel> DimGradeLevels { get; set; }
        public DbSet<DimDate> DimDates { get; set; }
        public DbSet<DimSchoolYear> DimSchoolYears { get; set; }
        public DbSet<DimK12Demographic> DimDemographics { get; set; }
        public DbSet<DimDiscipline> DimDisciplines { get; set; }
        public DbSet<DimFactType> DimFactTypes { get; set; }
        public DbSet<DimIdeaStatus> DimIdeaStatuses { get; set; }
        public DbSet<DimK12Staff> DimK12Staff { get; set; }
        public DbSet<DimK12StaffStatus> DimK12StaffStatuses { get; set; }
        public DbSet<DimRace> DimRaces { get; set; }
        public DbSet<DimK12School> DimSchools { get; set; }
        public DbSet<DimLea> DimLeas { get; set; }
        public DbSet<DimSea> DimSeas { get; set; }
        public DbSet<DimK12Student> DimStudents { get; set; }
        public DbSet<DimProgramStatus> DimProgramStatuses { get; set; }
        public DbSet<DimK12SchoolStatus> DimSchoolStatuses { get; set; }
        public DbSet<DimK12SchoolStateStatus> DimSchoolStateStatuses { get; set; }
        public DbSet<DimNorDProgramStatus> DimNorDProgramStatuses { get; set; }
        public DbSet<DimK12EnrollmentStatus> DimEnrollmentStatuses { get; set; }

        public DbSet<DimLanguage> DimLanguages { get; set; }
        public DbSet<DimK12StudentStatus> DimStudentStatuses { get; set; }
        public DbSet<DimTitleIIIStatus> DimTitleIIIStatuses { get; set; }
        public DbSet<DimAssessmentStatus> DimAssessmentStatuses { get; set; }

        public DbSet<DimTitleIStatus> DimTitle1Statuses { get; set; }
        public DbSet<DimMigrant> DimMigrants { get; set; }
        public DbSet<DimK12StaffCategory> DimK12StaffCategories { get; set; }
        public DbSet<DimCharterSchoolAuthorizer> DimCharterSchoolAuthorizer { get; set; }

        public DbSet<DimIndicatorStatus> DimIndicatorStatuses { get; set; }
        public DbSet<DimIndicatorStatusType> DimIndicatorStatusTypes { get; set; }
        public DbSet<DimStateDefinedStatus> DimStateDefinedStatuses { get; set; }
        public DbSet<DimStateDefinedCustomIndicator> DimStateDefinedCustomIndicators { get; set; }
        public DbSet<DimFirearms> DimFirearms { get; set; }
        public DbSet<DimFirearmDiscipline> DimFirearmsDisciplines { get; set; }
        public DbSet<DimK12OrganizationStatus> DimOrganizationStatus { get; set; }

        public DbSet<DimComprehensiveAndTargetedSupport> DimComprehensiveAndTargetedSupports { get; set; }
        public DbSet<DimCteStatus> DimCteStatuses { get; set; }
        public DbSet<DimCharterSchoolStatus> DimCharterSchoolStatus { get; set; }

        // Bridges
        public DbSet<BridgeLeaGradeLevel> BridgeLeaGradeLevels { get; set; }


        // Facts
        public DbSet<FactK12StaffCount> FactPersonnelCounts { get; set; }
        public DbSet<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public DbSet<FactK12StudentCount> FactStudentCounts { get; set; }
        public DbSet<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

                
        public DbSet<FactOrganizationCount> FactOrganizationCounts { get; set; }
        public DbSet<FactOrganizationStatusCount> FactOrganizationStatusCounts { get; set; }
        public DbSet<FactCustomCount> FactCustomCounts { get; set; }

        // Reports
        public DbSet<ReportEDFactsK12StaffCount> FactPersonnelCountReports { get; set; }
        public DbSet<FactK12StudentAssessmentReport> FactStudentAssessmentReports { get; set; }
        public DbSet<ReportEDFactsK12StudentCount> FactStudentCountReports { get; set; }
        public DbSet<ReportEDFactsK12StudentDiscipline> FactStudentDisciplineReports { get; set; }
        public DbSet<ReportEDFactsOrganizationCount> FactOrganizationCountReports { get; set; }
        public DbSet<ReportEDFactsGradesOffered> GradesOfferedReports { get; set; }
        public DbSet<ReportEDFactsPersistentlyDangerous> PersistentlyDangerousReports { get; set; }
        public DbSet<ReportEDFactsOrganizationStatusCount> FactOrganizationStatusCountReports { get; set; }

        // Stored Procedure Entities (not real entities - should be removed from all migrations)
        //public DbSet<FactPersonnelCountReportDto> FactPersonnelCountReportDtos { get; set; }
        //public DbSet<FactStudentAssessmentReportDto> FactStudentAssessmentReportDtos { get; set; }
        //public DbSet<FactStudentCountReportDto> FactStudentCountReportDtos { get; set; }
        //public DbSet<FactStudentDisciplineReportDto> FactStudentDisciplineReportDtos { get; set; }
        //public DbSet<FactOrganizationCountReportDto> FactOrganizationCountReportDtos { get; set; }
        //public DbSet<FactOrganizationStatusCountReportDto> FactOrganizationStatusCountReportDtos { get; set; }
        public DbSet<OrganizationDto> Organizations { get; set; }

        #endregion

        public void ExecuteInitializeScripts(string scriptPath)
        {
            _logger.LogInformation("RDSDbContext - ExecuteInitializeScripts - " + scriptPath);


            DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();

            // TODO: version these scripts and only run those that have not been run before (get version from GenerateConfigureation)

            // Drop stored procedures
            scriptFiles.Add("RDS.Empty_RDS.Drop.sql");

            scriptFiles.Add("RDS.Seed_DimStudents.Drop.sql");
            scriptFiles.Add("RDS.Seed_DimPersonnel.Drop.sql");
            scriptFiles.Add("RDS.Seed_DimSchools.Drop.sql");
            scriptFiles.Add("RDS.Seed_BridgeStudentRaces.Drop.sql");

            scriptFiles.Add("RDS.Migrate_DimDates_Students.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimDates_Personnel.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimAges.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimDemographics.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimIdeaStatuses.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimPersonnelStatuses.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimAssessments.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimDisciplines.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimSchools_Students.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimSchools_Personnel.Drop.sql");
            scriptFiles.Add("RDS.Migrate_DimGradeLevels.Drop.sql");

            scriptFiles.Add("RDS.Migrate_StudentCounts.Drop.sql");
            scriptFiles.Add("RDS.Migrate_StudentDisciplines.Drop.sql");
            scriptFiles.Add("RDS.Migrate_StudentAssessments.Drop.sql");
            scriptFiles.Add("RDS.Migrate_PersonnelCounts.Drop.sql");

            scriptFiles.Add("RDS.Create_ReportData.Drop.sql");
            scriptFiles.Add("RDS.Create_CustomReportData.Drop.sql");
            scriptFiles.Add("RDS.Get_ReportData.Drop.sql");
            scriptFiles.Add("RDS.Get_ReportDimension_Sql.Drop.sql");

            // Table Types
            scriptFiles.Add("RDS.StudentDateTableType.Drop.sql");
            scriptFiles.Add("RDS.StudentDateTableType.Create.sql");
            scriptFiles.Add("RDS.PersonnelDateTableType.Drop.sql");
            scriptFiles.Add("RDS.PersonnelDateTableType.Create.sql");

            // Create stored procedures
            scriptFiles.Add("RDS.Empty_RDS.Create.sql");

            scriptFiles.Add("RDS.Seed_DimStudents.Create.sql");
            scriptFiles.Add("RDS.Seed_DimPersonnel.Create.sql");
            scriptFiles.Add("RDS.Seed_DimSchools.Create.sql");
            scriptFiles.Add("RDS.Seed_BridgeStudentRaces.Create.sql");

            scriptFiles.Add("RDS.Migrate_DimDates_Students.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimDates_Personnel.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimAges.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimDemographics.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimIdeaStatuses.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimPersonnelStatuses.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimAssessments.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimDisciplines.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimSchools_Students.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimSchools_Personnel.Create.sql");
            scriptFiles.Add("RDS.Migrate_DimGradeLevels.Create.sql");

            scriptFiles.Add("RDS.Migrate_StudentCounts.Create.sql");
            scriptFiles.Add("RDS.Migrate_StudentDisciplines.Create.sql");
            scriptFiles.Add("RDS.Migrate_StudentAssessments.Create.sql");
            scriptFiles.Add("RDS.Migrate_PersonnelCounts.Create.sql");

            scriptFiles.Add("RDS.Get_ReportData.Create.sql");

            scriptFiles.Add("RDS.Get_ReportDimension_Sql.Create.sql");
            scriptFiles.Add("RDS.Create_ReportData.Create.sql");
            scriptFiles.Add("RDS.Create_CustomReportData.Create.sql");


            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("RDSDbContext - Executing - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);
                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

            }

            _logger.LogInformation("RDSDbContext - ExecuteInitializeScripts - end");

        }

        public void ExecuteSeedDataScripts(string scriptPath)
        {
            _logger.LogInformation("RDSDbContext - ExecuteSeedDataScripts - " + scriptPath);

            DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();

            scriptFiles.Add("RDS.DimAges.Seed.sql");
            scriptFiles.Add("RDS.DimAssessments.Seed.sql");
            scriptFiles.Add("RDS.DimGradeLevels.Seed.sql");
            scriptFiles.Add("RDS.DimDates.Seed.sql");
            scriptFiles.Add("RDS.DimDemographics.Seed.sql");
            scriptFiles.Add("RDS.DimDisciplines.Seed.sql");
            scriptFiles.Add("RDS.DimFactTypes.Seed.sql");
            scriptFiles.Add("RDS.DimIdeaStatuses.Seed.sql");
            scriptFiles.Add("RDS.DimPersonnelStatuses.Seed.sql");
            scriptFiles.Add("RDS.DimRaces.Seed.sql");
            scriptFiles.Add("RDS.DimSchools.Seed.sql");
            scriptFiles.Add("RDS.DimStudents.Seed.sql");
            scriptFiles.Add("RDS.DimPersonnel.Seed.sql");

            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("RDSDbContext - Executing - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);
                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

            }

            _logger.LogInformation("RDSDbContext - ExecuteSeedDataScripts - end");

        }

        public void ExecuteDatabaseScript(string script)
        {
            int? oldTimeout = Database.GetCommandTimeout();
            Database.SetCommandTimeout(8000);
            Database.ExecuteSqlRaw(script);
            Database.SetCommandTimeout(oldTimeout);
        }

    }


}