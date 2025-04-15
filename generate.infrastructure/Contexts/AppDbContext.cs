using System;
using Microsoft.EntityFrameworkCore;
using generate.core.Models.App;
using System.IO;
using System.Text;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Options;
using generate.core.Config;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore.Migrations;

namespace generate.infrastructure.Contexts
{
    public class AppDbContext : DbContext
    {

        private readonly ILogger _logger;
        private readonly IOptions<AppSettings> _appSettings;
        private string _schemaName = "App";

        public AppDbContext(DbContextOptions<AppDbContext> options, ILogger<AppDbContext> logger, IOptions<AppSettings> appSettings) : base(options)
        {
            _logger = logger;
            _appSettings = appSettings;

        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            // Not configuring anything here
        }

        public void ExecuteEFMigration(string migrationName)
        {
            var migrator = this.GetInfrastructure().GetRequiredService<IMigrator>();
            migrator.Migrate(migrationName);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema(_schemaName);

            #region Generate

            // GenerateConfiguration

            modelBuilder.Entity<GenerateConfiguration>(entity =>
            {

                entity
                   .Property(x => x.GenerateConfigurationId)
                   .IsRequired();

                entity
                    .Property(x => x.GenerateConfigurationCategory)
                    .IsRequired()
                    .HasMaxLength(500);

                entity
                    .Property(x => x.GenerateConfigurationKey)
                    .IsRequired()
                    .HasMaxLength(500);

                entity
                .Property(x => x.GenerateConfigurationKey)
                .IsRequired()
                .HasMaxLength(2000);

            });


            // GenerateReportType

            modelBuilder.Entity<GenerateReportType>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportTypeId)
                   .IsRequired();

                entity
                    .Property(x => x.ReportTypeName)
                    .IsRequired()
                    .HasMaxLength(500);

                entity
                    .Property(x => x.ReportTypeCode)
                    .IsRequired()
                    .HasMaxLength(100);

            });

            // GenerateReportControlType

            modelBuilder.Entity<GenerateReportControlType>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportControlTypeId)
                   .IsRequired();

                entity
                    .Property(x => x.ControlTypeName)
                    .IsRequired()
                    .HasMaxLength(200);


            });


            // OrganizationLevel

            modelBuilder.Entity<OrganizationLevel>(entity =>
            {

                entity
                   .Property(x => x.OrganizationLevelId)
                   .IsRequired();

                entity
                   .Property(x => x.LevelName)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.LevelCode)
                   .IsRequired()
                   .HasMaxLength(100);

            });


            // GenerateReport_OrganizationLevel

            modelBuilder.Entity<GenerateReport_OrganizationLevel>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                   .Property(x => x.OrganizationLevelId)
                   .IsRequired();
                
                entity
                   .HasKey(t => new { t.GenerateReportId, t.OrganizationLevelId });

                entity
                     .HasOne(pt => pt.OrganizationLevel)
                     .WithMany(t => t.GenerateReport_OrganizationLevels)
                     .HasForeignKey(pt => pt.OrganizationLevelId);

                entity
                    .HasOne(pt => pt.GenerateReport)
                    .WithMany(t => t.GenerateReport_OrganizationLevels)
                    .HasForeignKey(pt => pt.GenerateReportId);

            });

            modelBuilder.Entity<GenerateReport_FactType>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                   .Property(x => x.FactTypeId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.GenerateReportId, t.FactTypeId });


            });


            // GenerateReport

            modelBuilder.Entity<GenerateReport>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                   .Property(x => x.GenerateReportTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.GenerateReportControlTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsConnectionId)
                   .IsRequired(false);

                entity
                   .Property(x => x.ReportName)
                   .HasMaxLength(500);

                entity
                   .Property(x => x.ReportShortName)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.ReportTypeAbbreviation)
                   .HasMaxLength(100);

                entity
                   .Property(x => x.ReportCode)
                   .HasMaxLength(500);

                entity
                   .Property(x => x.CategorySetControlCaption)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.ShowCategorySetControl)
                   .IsRequired();

                entity
                  .Property(x => x.CategorySetControlLabel)
                  .HasMaxLength(250);

                entity
                   .Property(x => x.ShowFilterControl)
                   .HasDefaultValue(false);

                entity
                  .Property(x => x.FilterControlLabel)
                  .HasMaxLength(250);

                entity
                   .Property(x => x.ShowSubFilterControl)
                   .HasDefaultValue(false);

                entity
                 .Property(x => x.SubFilterControlLabel)
                 .HasMaxLength(250);

                entity
                  .Property(x => x.ShowData);
                entity
                 .Property(x => x.ShowGraph);

                entity
                   .Property(x => x.IsActive)
                   .IsRequired();

                entity
                   .Property(x => x.IsLocked);

                entity
                   .Property(x => x.UseLegacyReportMigration)
                   .IsRequired();

                entity
                      .HasOne(pt => pt.FactTable)
                      .WithMany(t => t.GenerateReports)
                      .HasForeignKey(pt => pt.FactTableId);
                

            });

            // GenerateReportTopic

            modelBuilder.Entity<GenerateReportTopic>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportTopicId)
                   .IsRequired();

                entity
                    .Property(x => x.GenerateReportTopicName)
                    .IsRequired()
                    .HasMaxLength(200);

                entity
                    .Property(x => x.UserName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity
                    .Property(x => x.IsActive)
                    .IsRequired();


            });

            // GenerateReportTopic_GenerateReport

            modelBuilder.Entity<GenerateReportTopic_GenerateReport>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportTopicId)
                   .IsRequired();

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.GenerateReportTopicId, t.GenerateReportId });

                entity
                     .HasOne(pt => pt.GenerateReportTopic)
                     .WithMany(t => t.GenerateReportTopic_GenerateReports)
                     .HasForeignKey(pt => pt.GenerateReportTopicId);

                entity
                    .HasOne(pt => pt.GenerateReport)
                    .WithMany(t => t.GenerateReportTopic_GenerateReports)
                    .HasForeignKey(pt => pt.GenerateReportId);

            });

            // GenerateReportFilterOption

            modelBuilder.Entity<GenerateReportFilterOption>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportFilterOptionId)
                   .IsRequired();

                entity.HasKey(x => x.GenerateReportFilterOptionId);

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                  .Property(x => x.IsSubFilter)
                  .HasDefaultValue(false);

                entity
                  .Property(x => x.IsDefaultOption)
                  .HasDefaultValue(false);

                entity
                   .Property(x => x.FilterCode)
                   .HasMaxLength(50);

                entity
                   .Property(x => x.FilterName)
                   .HasMaxLength(250);

                entity.Property(x => x.FilterSequence);

                entity
                    .HasOne(pt => pt.GenerateReport);
                    

            });

            #endregion

            #region CategorySet


            // CategorySet

            modelBuilder.Entity<CategorySet>(entity =>
            {

                entity
                   .Property(x => x.CategorySetId)
                   .IsRequired();


                entity
                    .Property(x => x.GenerateReportId)
                    .IsRequired();

                entity
                    .Property(x => x.OrganizationLevelId)
                    .IsRequired();

                entity
                    .Property(x => x.SubmissionYear)
                    .IsRequired()
                    .HasMaxLength(50);


                entity
                    .Property(x => x.EdFactsTableTypeGroupId)
                    .IsRequired();

                entity
                    .Property(x => x.CategorySetCode)
                    .IsRequired()
                    .HasMaxLength(50);

                entity
                    .Property(x => x.CategorySetName)
                    .IsRequired()
                    .HasMaxLength(500);

                entity
                    .Property(x => x.ExcludeOnFilter)
                    .HasMaxLength(50);

                entity
                    .Property(x => x.IncludeOnFilter)
                    .HasMaxLength(50);


                entity
                    .HasOne(pt => pt.GenerateReport)
                    .WithMany(t => t.CategorySets)
                    .HasForeignKey(pt => pt.GenerateReportId);


            });
            


            // Category

            modelBuilder.Entity<Category>(entity =>
            {

                entity
                   .Property(x => x.CategoryId)
                   .IsRequired();

                entity
                    .Property(x => x.EdFactsCategoryId)
                    .IsRequired();

                entity
                    .Property(x => x.CategoryCode)
                    .IsRequired()
                    .HasMaxLength(50);

                entity
                    .Property(x => x.CategoryName)
                    .IsRequired()
                    .HasMaxLength(500);
                
                entity
                    .HasMany(pt => pt.CategoryOptions);




            });



            // CategoryOption

            modelBuilder.Entity<CategoryOption>(entity =>
            {

                entity
                   .Property(x => x.CategoryOptionId)
                   .IsRequired();

                entity
                   .Property(x => x.CategoryId)
                   .IsRequired();

                entity
                   .Property(x => x.EdFactsCategoryCodeId)
                   .IsRequired();

                entity
                    .Property(x => x.CategoryOptionCode)
                    .IsRequired()
                    .HasMaxLength(50);

                entity
                    .Property(x => x.CategoryOptionName)
                    .IsRequired()
                    .HasMaxLength(500);
            });

            

            // CategorySet_Category

            modelBuilder.Entity<CategorySet_Category>(entity =>
            {

                entity
                   .Property(x => x.CategorySetId)
                   .IsRequired();

                entity
                   .Property(x => x.CategoryId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.CategorySetId, t.CategoryId });

                entity
                    .HasOne(pt => pt.CategorySet)
                    .WithMany(t => t.CategorySet_Categories)
                    .HasForeignKey(pt => pt.CategorySetId);

                entity
                    .HasOne(pt => pt.Category)
                    .WithMany(t => t.CategorySet_Categories)
                    .HasForeignKey(pt => pt.CategoryId);

            });


            #endregion

            #region CEDS

            // CedsConnection

            modelBuilder.Entity<CedsConnection>(entity =>
            {

                entity
                   .Property(x => x.CedsConnectionId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsConnectionName)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.CedsConnectionDescription)
                   .IsRequired();

                entity
                   .Property(x => x.CedsConnectionSource)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.CedsUseCaseId)
                   .IsRequired();

            });

            // CedsElement

            modelBuilder.Entity<CedsElement>(entity =>
            {

                entity
                   .Property(x => x.CedsElementId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsElementName)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.CedsElementDefinition)
                   .IsRequired();

                entity
                   .Property(x => x.CedsTermId)
                   .IsRequired();

            });

            // CedsConnection_CedsElement

            modelBuilder.Entity<CedsConnection_CedsElement>(entity =>
            {

                entity
                   .Property(x => x.CedsConnectionId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsElementId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsDesElement)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.CedsConnectionId, t.CedsElementId, t.CedsDesElement });

                entity
                     .HasOne(pt => pt.CedsConnection)
                     .WithMany(t => t.CedsConnection_CedsElements)
                     .HasForeignKey(pt => pt.CedsConnectionId);

                entity
                    .HasOne(pt => pt.CedsElement)
                    .WithMany(t => t.CedsConnection_CedsElements)
                    .HasForeignKey(pt => pt.CedsElementId);

            });

            modelBuilder.Entity<ODSElement>(entity =>
            {

                entity
                   .Property(x => x.ODSElementId)
                   .IsRequired();

                entity
                   .Property(x => x.CedsNdsElementId)
                   .IsRequired();

                entity
                   .Property(x => x.ODSElementTable)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.ODSElementColumn)
                   .HasMaxLength(500);

            });

            #endregion

            #region DataMigration

            // DataMigrationType

            modelBuilder.Entity<DataMigrationType>(entity =>
            {

                entity
                   .Property(x => x.DataMigrationTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.DataMigrationTypeCode)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DataMigrationTypeName)
                   .IsRequired()
                   .HasMaxLength(500);

            });

            // DataMigrationStatus

            modelBuilder.Entity<DataMigrationStatus>(entity =>
            {

                entity
                   .Property(x => x.DataMigrationStatusId)
                   .IsRequired();
                
                entity
                   .Property(x => x.DataMigrationStatusCode)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.DataMigrationStatusName)
                   .IsRequired()
                   .HasMaxLength(500);

            });

            // DataMigration

            modelBuilder.Entity<DataMigration>(entity =>
            {

                entity
                   .Property(x => x.DataMigrationId)
                   .IsRequired();

                entity
                   .Property(x => x.DataMigrationTypeId)
                   .IsRequired();

                entity
                    .Property(x => x.DataMigrationStatusId)
                    .IsRequired();

            });
            

            // DataMigrationHistory

            modelBuilder.Entity<DataMigrationHistory>(entity =>
            {

                entity
                .Property(x => x.DataMigrationHistoryId)
               .IsRequired();

                entity
                   .Property(x => x.DataMigrationTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.DataMigrationHistoryMessage)
                   .IsRequired();

                entity
                   .Property(x => x.DataMigrationHistoryDate)
                   .HasColumnType("datetime")
                   .IsRequired();

            });

            // DataMigrationTask

            modelBuilder.Entity<DataMigrationTask>(entity =>
            {

                entity
                    .Property(x => x.DataMigrationTaskId)
                    .IsRequired();

                entity.HasKey(x => x.DataMigrationTaskId);

                entity
                    .Property(x => x.DataMigrationTypeId)
                    .IsRequired();

                entity
                    .Property(x => x.IsActive)
                    .IsRequired();

                entity
                    .Property(x => x.TaskSequence)
                    .IsRequired();

                entity
                    .Property(x => x.TaskName)
                    .HasMaxLength(150);

                entity
                    .Property(x => x.StoredProcedureName)
                    .IsRequired()
                    .HasMaxLength(500);

                entity
                    .Property(x => x.RunBeforeGenerateMigration)
                    .IsRequired();

                entity
                    .Property(x => x.RunAfterGenerateMigration)
                    .IsRequired();

            });




            #endregion

            #region Toggle


            modelBuilder.Entity<ToggleSectionType>(entity =>
            {

                entity
                   .Property(x => x.ToggleSectionTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.EmapsSurveyTypeAbbrv)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SectionTypeName)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                   .Property(x => x.SectionTypeShortName)
                   .IsRequired()
                   .HasMaxLength(100);

                entity
                   .Property(x => x.SectionTypeSequence)
                   .IsRequired();

            });


            modelBuilder.Entity<ToggleSection>(entity =>
            {

                entity
                   .Property(x => x.ToggleSectionId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleSectionTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.EmapsSurveySectionAbbrv)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SectionTitle)
                   .IsRequired()
                   .HasMaxLength(500);

                entity
                    .Property(x => x.SectionName)
                    .IsRequired()
                    .HasMaxLength(2000);

                entity
                    .Property(x => x.SectionSequence)
                    .IsRequired();

                entity
                    .Property(x => x.EmapsParentSurveySectionAbbrv)
                    .IsRequired(false)
                    .HasMaxLength(50);

            });

            modelBuilder.Entity<ToggleQuestionType>(entity =>
            {

                entity
                   .Property(x => x.ToggleQuestionTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleQuestionTypeCode)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.ToggleQuestionTypeName)
                   .IsRequired()
                   .HasMaxLength(500);

            });

            modelBuilder.Entity<ToggleQuestion>(entity =>
            {

                entity
                   .Property(x => x.ToggleQuestionId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleQuestionTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleSectionId)
                   .IsRequired();


                entity
                   .Property(x => x.EmapsQuestionAbbrv)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.QuestionText)
                   .IsRequired();
                
                entity
                   .Property(x => x.QuestionSequence)
                   .IsRequired();

            });


            modelBuilder.Entity<ToggleQuestionOption>(entity =>
            {

                entity
                   .Property(x => x.ToggleQuestionOptionId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleQuestionId)
                   .IsRequired();

                entity
                   .Property(x => x.OptionText)
                   .IsRequired();

                entity
                   .Property(x => x.OptionSequence)
                   .IsRequired();

            });


            modelBuilder.Entity<ToggleResponse>(entity =>
            {

                entity
                   .Property(x => x.ToggleResponseId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleQuestionId)
                   .IsRequired();

                entity
                   .Property(x => x.ToggleQuestionOptionId)
                   .IsRequired(false);

                entity
                   .Property(x => x.ResponseValue)
                   .IsRequired();
               
            });

            modelBuilder.Entity<ToggleAssessment>(entity =>
            {
                entity
                   .Property(x => x.ToggleAssessmentId)
                   .IsRequired();

                entity
                   .Property(x => x.AssessmentTypeCode)
                   .IsRequired()
                   .HasMaxLength(100);

                entity
                 .Property(x => x.AssessmentType)
                 .IsRequired()
                 .HasMaxLength(200);

                entity
                   .Property(x => x.AssessmentName)
                   .IsRequired()
                   .HasMaxLength(100);

                entity
                   .Property(x => x.PerformanceLevels)
                   .IsRequired()
                   .HasMaxLength(2);

                entity
                   .Property(x => x.ProficientOrAboveLevel)
                   .IsRequired()
                   .HasMaxLength(2);

                entity
                   .Property(x => x.Grade)
                   .IsRequired()
                   .HasMaxLength(2);

                entity
                   .Property(x => x.Subject)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.EOG)
                   .IsRequired()
                   .HasMaxLength(50);

            });

            #endregion

            #region FileSubmission

            // FileColumn

            modelBuilder.Entity<FileColumn>(entity =>
            {

                entity
                   .Property(x => x.FileColumnId)
                   .IsRequired();

                entity
                   .Property(x => x.ColumnName)
                   .IsRequired()
                   .HasMaxLength(50);
                

                entity
                   .Property(x => x.XMLElementName)
                   .IsRequired(false)
                   .HasMaxLength(200);

                entity
                   .Property(x => x.DisplayName)
                   .IsRequired(false)
                   .HasMaxLength(100);

                entity
                  .Property(x => x.ColumnLength)
                  .IsRequired();

                entity
                  .Property(x => x.DataType)
                  .IsRequired()
                  .HasMaxLength(50);

            });




            // FileSubmission_FileColumn

            modelBuilder.Entity<FileSubmission_FileColumn>(entity =>
            {

                entity
                   .Property(x => x.FileSubmissionId)
                   .IsRequired();

                entity
                   .Property(x => x.FileColumnId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.FileSubmissionId, t.FileColumnId });

                entity
                     .HasOne(pt => pt.FileColumn)
                     .WithMany(t => t.FileSubmission_FileColumns)
                     .HasForeignKey(pt => pt.FileColumnId);
                
                entity
                    .HasOne(pt => pt.FileSubmission)
                    .WithMany(t => t.FileSubmission_FileColumns)
                    .HasForeignKey(pt => pt.FileSubmissionId);

            });

            // FileSubmission

            modelBuilder.Entity<FileSubmission>(entity =>
            {

                entity
                   .Property(x => x.FileSubmissionId)
                   .IsRequired();

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired(false);

                entity
                   .Property(x => x.OrganizationLevelId)
                   .IsRequired(false);

                entity
                   .Property(x => x.FileSubmissionDescription)
                   .IsRequired()
                   .HasMaxLength(50);

                entity
                   .Property(x => x.SubmissionYear)
                   .IsRequired(false)
                   .HasMaxLength(50);


            });

            modelBuilder.Entity<TableType>(entity =>
            {

                entity
                   .Property(x => x.TableTypeId)
                   .IsRequired();

                entity
                   .Property(x => x.TableTypeName)
                   .IsRequired()
                   .HasMaxLength(200);

                entity
                   .Property(x => x.TableTypeAbbrv)
                   .IsRequired(false)
                   .HasMaxLength(20);

                entity
                  .Property(x => x.EdFactsTableTypeId)
                  .IsRequired();

            });

            modelBuilder.Entity<GenerateReport_TableType>(entity =>
            {

                entity
                   .Property(x => x.GenerateReportId)
                   .IsRequired();

                entity
                   .Property(x => x.TableTypeId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.GenerateReportId, t.TableTypeId });

                entity
                     .HasOne(pt => pt.GenerateReport)
                     .WithMany(t => t.GenerateReport_TableTypes)
                     .HasForeignKey(pt => pt.GenerateReportId);

                entity
                    .HasOne(pt => pt.TableType)
                    .WithMany(t => t.GenerateReport_TableTypes)
                    .HasForeignKey(pt => pt.TableTypeId);

            });


            #endregion

            #region FactTable

            modelBuilder.Entity<FactTable>(entity =>
            {

                entity
                   .Property(x => x.FactTableId)
                   .IsRequired();

                entity
                    .Property(x => x.FactTableName)
                    .IsRequired()
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactTableIdName)
                    .IsRequired()
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactFieldName)
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactReportTableName)
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactReportTableIdName)
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactReportDtoName)
                    .HasMaxLength(100);

                entity
                    .Property(x => x.FactReportDtoIdName)
                    .HasMaxLength(100);

                
            });

            modelBuilder.Entity<DimensionTable>(entity =>
            {

                entity
                   .Property(x => x.DimensionTableId)
                   .IsRequired();

                entity
                   .Property(x => x.DimensionTableName)
                   .IsRequired()
                   .HasMaxLength(100);

                entity
                   .Property(x => x.IsReportingDimension)
                   .IsRequired();

            });

            modelBuilder.Entity<Dimension>(entity =>
            {

                entity
                   .Property(x => x.DimensionId)
                   .IsRequired();

                entity
                   .Property(x => x.DimensionTableId)
                   .IsRequired();

                entity
                    .Property(x => x.DimensionFieldName)
                    .IsRequired()
                    .HasMaxLength(100);

                entity
                   .Property(x => x.IsCalculated)
                   .IsRequired();

                entity
                   .Property(x => x.IsOrganizationLevelSpecific)
                   .IsRequired();

            });

            modelBuilder.Entity<FactTable_DimensionTable>(entity =>
            {

                entity
                   .Property(x => x.FactTableId)
                   .IsRequired();

                entity
                   .Property(x => x.DimensionTableId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.FactTableId, t.DimensionTableId });

                entity
                    .HasOne(pt => pt.FactTable)
                    .WithMany(t => t.FactTable_DimensionTables)
                    .HasForeignKey(pt => pt.FactTableId);

                entity
                    .HasOne(pt => pt.DimensionTable)
                    .WithMany(t => t.FactTable_DimensionTables)
                    .HasForeignKey(pt => pt.DimensionTableId);

            });

            modelBuilder.Entity<Category_Dimension>(entity =>
            {

                entity
                   .Property(x => x.CategoryId)
                   .IsRequired();

                entity
                   .Property(x => x.DimensionId)
                   .IsRequired();

                entity
                   .HasKey(t => new { t.CategoryId, t.DimensionId });

                entity
                    .HasOne(pt => pt.Category)
                    .WithMany(t => t.Category_Dimensions)
                    .HasForeignKey(pt => pt.CategoryId);

                entity
                    .HasOne(pt => pt.Dimension)
                    .WithMany(t => t.Category_Dimensions)
                    .HasForeignKey(pt => pt.DimensionId);

            });

            #endregion

        }

        #region DbSets

        public DbSet<GenerateConfiguration> GenerateConfigurations { get; set; }
        public DbSet<GenerateReportType> GenerateReportTypes { get; set; }
        public DbSet<CategorySet> CategorySets { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<CategoryOption> CategoryOptions { get; set; }
        public DbSet<GenerateReport> GenerateReports { get; set; }
        public DbSet<GenerateReportTopic> GenerateReportTopics { get; set; }
        public DbSet<GenerateReportTopic_GenerateReport> GenerateReportTopic_GenerateReports { get; set; }
        public DbSet<OrganizationLevel> OrganizationLevels { get; set; }
        public DbSet<GenerateReport_OrganizationLevel> GenerateReport_OrganizationLevels { get; set; }

        public DbSet<CedsConnection> CedsConnections { get; set; }
        public DbSet<CedsElement> CedsElements { get; set; }
        public DbSet<CedsConnection_CedsElement> CedsConnection_CedsElements { get; set; }

        public DbSet<ODSElement> ODSElements { get; set; }

        public DbSet<DataMigrationType> DataMigrationTypes { get; set; }
        public DbSet<DataMigrationStatus> DataMigrationStatuses { get; set; }
        public DbSet<DataMigration> DataMigrations { get; set; }
        public DbSet<DataMigrationHistory> DataMigrationHistories { get; set; }
        public DbSet<DataMigrationTask> DataMigrationTasks { get; set; }

        public DbSet<ToggleSectionType> ToggleSectionTypes { get; set; }
        public DbSet<ToggleSection> ToggleSections { get; set; }
        public DbSet<ToggleQuestionType> ToggleQuestionTypes { get; set; }
        public DbSet<ToggleQuestion> ToggleQuestions { get; set; }
        public DbSet<ToggleQuestionOption> ToggleQuestionOptions { get; set; }
        public DbSet<ToggleResponse> ToggleResponses { get; set; }
        public DbSet<ToggleAssessment> ToggleAssessments { get; set; }
        public DbSet<TableType> TableTypes { get; set; }

        public DbSet<FileSubmission> FileSubmissions { get; set; }
        public DbSet<FileColumn> FileColumns { get; set; }
        public DbSet<FileSubmission_FileColumn> FileSubmission_FileColumns { get; set; }

        public DbSet<CategorySet_Category> CategorySet_Categories { get; set; }


        public DbSet<FactTable> FactTables { get; set; }
        public DbSet<DimensionTable> DimensionTables { get; set; }
        public DbSet<Dimension> Dimensions { get; set; }
        public DbSet<FactTable_DimensionTable> FactTable_DimensionTables { get; set; }
        public DbSet<Category_Dimension> Category_Dimensions { get; set; }
        public DbSet<GenerateReportFilterOption> GenerateReportFilterOptions { get; set; }

        #endregion

        public void ExecuteInitializeScripts(string scriptPath)
        {
            _logger.LogInformation("AppDbContext - ExecuteInitializeScripts - " + scriptPath);


            DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();

            scriptFiles.Add("App.Split.Drop.sql");
            scriptFiles.Add("App.Split.Create.sql");

            scriptFiles.Add("App.Get_CategoriesByCategorySet.Drop.sql");
            scriptFiles.Add("App.Get_CategoriesByCategorySet.Create.sql");

            scriptFiles.Add("App.Migrate_Data.Drop.sql");
            scriptFiles.Add("App.Migrate_Data.Create.sql");
            
            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("AppDbContext - Executing - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);
                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

            }

            _logger.LogInformation("AppDbContext - ExecuteInitializeScripts - end");

        }


        public void ExecuteJobScripts(string scriptPath, bool disableOnly)
        {
            _logger.LogInformation("AppDbContext - ExecuteJobScripts - " + scriptPath);


            DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();
            
            if (_appSettings.Value.Environment.ToLower() == "development" || _appSettings.Value.Environment.ToLower() == "test")
            {
                scriptFiles.Add("MigrateData.Job-Test.Drop.sql");
                if (! disableOnly)
                {
                    scriptFiles.Add("MigrateData.Job-Test.Create.sql");
                }
            }
            else
            {
                scriptFiles.Add("MigrateData.Job.Drop.sql");
                if (!disableOnly)
                {
                    scriptFiles.Add("MigrateData.Job.Create.sql");
                }
            }

            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("AppDbContext - Executing - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);
                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

            }

            _logger.LogInformation("AppDbContext - ExecuteJobScripts - end");

        }


        public void ExecuteSeedDataScripts(string scriptPath)
        {
            _logger.LogInformation("AppDbContext - ExecuteSeedDataScripts - " + scriptPath);

            DirectoryInfo di = new DirectoryInfo(scriptPath);

            List<string> scriptFiles = new List<string>();

            scriptFiles.Add("App.CategorySets.Seed.sql");
            scriptFiles.Add("App.CategorySet_Categories.Seed.sql");
            scriptFiles.Add("App.FileColumns.Seed.sql");
            scriptFiles.Add("App.DataMigrationTasks.Seed.sql");
            scriptFiles.Add("App.CategoryOptions.Seed.sql");

            foreach (string scriptFile in scriptFiles)
            {
                _logger.LogInformation("AppDbContext - Executing - " + scriptFile);

                FileInfo fileInfo = new FileInfo(scriptPath + "\\" + scriptFile);
                string script = fileInfo.OpenText().ReadToEnd();

                ExecuteDatabaseScript(script);

            }

            _logger.LogInformation("AppDbContext - ExecuteSeedDataScripts - end");

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