using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.RDS;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using generate.core.Helpers.TestDataHelper.Rds;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Data.Sqlite;

namespace generate.test.Infrastructure.Fixtures
{

    public class ReportMigrationFixture : IDisposable
    {
        public readonly AppDbContext appDbContext;
        public readonly RDSDbContext rdsDbContext;


        public ReportMigrationFixture()
        {
            this.rdsDbContext = this.SetupRdsDbContext();


            this.SetupRdsReferenceData(this.rdsDbContext);
            this.SetupTestData(this.rdsDbContext);

            this.appDbContext = this.SetupAppDbContext();

            this.SetupAppReferenceData(this.appDbContext);


        }

        public void Dispose()
        {
            this.appDbContext.Database.CloseConnection();
            this.rdsDbContext.Database.CloseConnection();
        }

        private AppDbContext SetupAppDbContext()
        {

            var options = new DbContextOptionsBuilder<AppDbContext>()
                              .UseSqlite("DataSource=:memory:")
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            context.Database.OpenConnection();

            context.Database.EnsureDeleted();
            context.Database.EnsureCreated();


            return context;
        }
        
        private RDSDbContext SetupRdsDbContext()
        {

            var options = new DbContextOptionsBuilder<RDSDbContext>()
                              .UseSqlite("DataSource=:memory:")
                              .Options;

            var logger = Mock.Of<ILogger<RDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new RDSDbContext(options, logger);

            context.Database.OpenConnection();

            context.Database.EnsureDeleted();
            context.Database.EnsureCreated();

            return context;
        }
        
        public void SetupAppReferenceData(AppDbContext appDbContext)
        {
            appDbContext.FactTables.AddRange(FactTableHelper.GetData());
            appDbContext.DataMigrationTypes.AddRange(DataMigrationTypeHelper.GetData());
            appDbContext.OrganizationLevels.AddRange(OrganizationLevelHelper.GetData());
            appDbContext.GenerateReports.AddRange(GenerateReportHelper.GetData());
            appDbContext.TableTypes.AddRange(TableTypeHelper.GetData());

            appDbContext.SaveChanges();

        }


        public void SetupRdsReferenceData(RDSDbContext rdsDbContext)
        {
            rdsDbContext.DimDates.AddRange(DimDateHelper.GetData());
            rdsDbContext.DimDemographics.AddRange(DimDemographicHelper.GetData());
            rdsDbContext.DimIdeaStatuses.AddRange(DimIdeaStatusHelper.GetData());
            rdsDbContext.DimDisciplines.AddRange(DimDisciplineHelper_1.GetData());
            rdsDbContext.DimDisciplines.AddRange(DimDisciplineHelper_2.GetData());
            rdsDbContext.DimDisciplines.AddRange(DimDisciplineHelper_3.GetData());
            rdsDbContext.DimFactTypes.AddRange(DimFactTypeHelper.GetData());
            rdsDbContext.DimLanguages.AddRange(DimLanguageHelper.GetData());
            rdsDbContext.DimProgramStatuses.AddRange(DimProgramStatusHelper.GetData());
            rdsDbContext.DimRaces.AddRange(DimRaceHelper.GetData());
            rdsDbContext.DimFirearms.AddRange(DimFirearmsHelper.GetData());
            rdsDbContext.DimFirearmsDisciplines.AddRange(DimFirearmsDisciplineHelper.GetData());
            rdsDbContext.DimGradeLevels.AddRange(DimGradeLevelHelper.GetData());
            rdsDbContext.DimTitle1Statuses.AddRange(DimTitle1StatusHelper.GetData());
            rdsDbContext.DimOrganizationStatus.AddRange(DimOrganizationStatusHelper.GetData());
            rdsDbContext.DimSchoolStateStatuses.AddRange(DimSchoolStateStatusHelper.GetData());
            rdsDbContext.DimComprehensiveAndTargetedSupports.AddRange(DimComprehensiveAndTargetedSupportHelper.GetData());

            rdsDbContext.DimAssessmentStatuses.AddRange(DimAssessmentStatusHelper.GetData());
            rdsDbContext.DimTitleIIIStatuses.AddRange(DimTitleIIIStatusHelper.GetData());
            rdsDbContext.DimStudentStatuses.AddRange(DimStudentStatusHelper.GetData());
            rdsDbContext.DimNorDProgramStatuses.AddRange(DimNorDProgramStatusHelper.GetData());
            rdsDbContext.DimEnrollmentStatuses.AddRange(DimEnrollmentStatusHelper.GetData());
            rdsDbContext.DimCteStatuses.AddRange(DimCteStatusHelper.GetData());

            rdsDbContext.SaveChanges();

        }

        public void SetupTestData(RDSDbContext rdsDbContext)
        {
            RdsTestDataObject dimSeasLeasSchools = RdsTestDataHelper.GetRdsTestData_DimSeasLeasSchools();

            rdsDbContext.DimSeas.AddRange(dimSeasLeasSchools.DimSeas);
            rdsDbContext.DimLeas.AddRange(dimSeasLeasSchools.DimLeas);
            rdsDbContext.DimSchools.AddRange(dimSeasLeasSchools.DimSchools);

            RdsTestDataObject dimStudents = RdsTestDataHelper.GetRdsTestData_DimStudents();
            rdsDbContext.DimStudents.AddRange(dimStudents.DimStudents);

            RdsTestDataObject dimPersonnel = RdsTestDataHelper.GetRdsTestData_DimPersonnel();
            rdsDbContext.DimK12Staff.AddRange(dimPersonnel.DimPersonnel);

            RdsTestDataObject dimCharterSchoolAuthorizers = RdsTestDataHelper.GetRdsTestData_DimCharterSchoolAuthorizers();
            rdsDbContext.DimCharterSchoolAuthorizer.AddRange(dimCharterSchoolAuthorizers.DimCharterSchoolAuthorizers);

            RdsTestDataObject factOrganizationCounts = RdsTestDataHelper.GetRdsTestData_FactOrganizationCounts();
            rdsDbContext.FactOrganizationCounts.AddRange(factOrganizationCounts.FactOrganizationCounts);

            RdsTestDataObject factStudentDisciplines_01 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_01();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_01.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_02 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_02();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_02.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_03 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_03();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_03.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_04 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_04();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_04.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_05 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_05();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_05.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_06 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_06();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_06.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_07 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_07();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_07.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_08 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_08();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_08.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_09 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_09();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_09.FactStudentDisciplines);

            RdsTestDataObject factStudentDisciplines_10 = RdsTestDataHelper.GetRdsTestData_FactStudentDisciplines_10();
            rdsDbContext.FactStudentDisciplines.AddRange(factStudentDisciplines_10.FactStudentDisciplines);

            ///Assessments

            RdsTestDataObject factStudentAssessments_01 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_01();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_01.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_02 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_02();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_02.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_03 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_03();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_03.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_04 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_04();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_04.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_05 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_05();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_05.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_06 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_06();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_06.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_07 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_07();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_07.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_08 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_08();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_08.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_09 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_09();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_09.FactStudentAssessments);

            RdsTestDataObject factStudentAssessments_10 = RdsTestDataHelper.GetRdsTestData_FactStudentAssessments_10();
            rdsDbContext.FactStudentAssessments.AddRange(factStudentAssessments_10.FactStudentAssessments);

            rdsDbContext.SaveChanges();
        }

        #region Boilerplate Tests

        public void CategorySet_Categories_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator, string categoryList)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                    .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified categories should exist
                Assert.Contains(reports, x => x.Categories == categoryList);

                // Records with any other categories should not exist
                Assert.DoesNotContain(reports, x => x.Categories != categoryList);

            }
            else if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                    .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified categories should exist
                Assert.Contains(reports, x => x.Categories == categoryList);

                // Records with any other categories should not exist
                Assert.DoesNotContain(reports, x => x.Categories != categoryList);

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_TotalIndicator_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                    .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified total indicator should exist
                Assert.Contains(reports, x => x.TotalIndicator == totalIndicator);

                // Records with any other total indicator should not exist
                Assert.DoesNotContain(reports, x => x.TotalIndicator != totalIndicator);

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void Core_Toggle_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator, string emapsQuestionAbbrv, string toggleResponseValue, string optionCode)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            var toggleQuestion = this.appDbContext.ToggleQuestions.Single(x => x.EmapsQuestionAbbrv == emapsQuestionAbbrv);
            var toggleQuestionOption = this.appDbContext.ToggleQuestionOptions.Single(x => x.OptionText == toggleResponseValue);

            var toggleResponse = new ToggleResponse() { ToggleResponseId = 1, ToggleQuestionId = toggleQuestion.ToggleQuestionId, ResponseValue = toggleResponseValue, ToggleQuestionOptionId = toggleQuestionOption.ToggleQuestionOptionId };
            this.appDbContext.ToggleResponses.Add(toggleResponse);
            this.appDbContext.SaveChanges();

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {

                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                if (emapsQuestionAbbrv == "CHDCTDISCAT")
                {
                    // Records with specified option should exist
                    Assert.Contains(reports, x => x.IDEADISABILITYTYPE == optionCode);

                    // Records with any other option should not exist
                    Assert.DoesNotContain(reports, x => x.IDEADISABILITYTYPE != optionCode);
                }
                else
                {
                    // No valid Emaps Question
                    Assert.True(false);
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

            // Tear Down
            this.appDbContext.ToggleResponses.Remove(toggleResponse);
            this.appDbContext.SaveChanges();
        }

        public void CategorySet_InterimRemoval_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.IDEAINTERIMREMOVAL == "MISSING" ||
                x.IDEAINTERIMREMOVAL == "REMDW" ||
                x.IDEAINTERIMREMOVAL == "REMHO"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.IDEAINTERIMREMOVAL != "MISSING" &&
                x.IDEAINTERIMREMOVAL != "REMDW" &&
                x.IDEAINTERIMREMOVAL != "REMHO"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }


        public void CategorySet_Disability_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {

                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.IDEADISABILITYTYPE == "MISSING" ||
                x.IDEADISABILITYTYPE == "AUT" ||
                x.IDEADISABILITYTYPE == "DB" ||
                x.IDEADISABILITYTYPE == "DD" ||
                x.IDEADISABILITYTYPE == "EMN" ||
                x.IDEADISABILITYTYPE == "HI" ||
                x.IDEADISABILITYTYPE == "MR" ||
                x.IDEADISABILITYTYPE == "MD" ||
                x.IDEADISABILITYTYPE == "OI" ||
                x.IDEADISABILITYTYPE == "SLD" ||
                x.IDEADISABILITYTYPE == "SLI" ||
                x.IDEADISABILITYTYPE == "TBI" ||
                x.IDEADISABILITYTYPE == "VI" ||
                x.IDEADISABILITYTYPE == "OHI"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.IDEADISABILITYTYPE != "MISSING" &&
                x.IDEADISABILITYTYPE != "AUT" &&
                x.IDEADISABILITYTYPE != "DB" &&
                x.IDEADISABILITYTYPE != "DD" &&
                x.IDEADISABILITYTYPE != "EMN" &&
                x.IDEADISABILITYTYPE != "HI" &&
                x.IDEADISABILITYTYPE != "MR" &&
                x.IDEADISABILITYTYPE != "MD" &&
                x.IDEADISABILITYTYPE != "OI" &&
                x.IDEADISABILITYTYPE != "SLD" &&
                x.IDEADISABILITYTYPE != "SLI" &&
                x.IDEADISABILITYTYPE != "TBI" &&
                x.IDEADISABILITYTYPE != "VI" &&
                x.IDEADISABILITYTYPE != "OHI"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }


        public void CategorySet_RacialEthnic_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.RACE == "MISSING" ||
                x.RACE == "AM7" ||
                x.RACE == "AS7" ||
                x.RACE == "BL7" ||
                x.RACE == "HI7" ||
                x.RACE == "PI7" ||
                x.RACE == "WH7" ||
                x.RACE == "MU7"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.RACE != "MISSING" &&
                x.RACE != "AM7" &&
                x.RACE != "AS7" &&
                x.RACE != "BL7" &&
                x.RACE != "HI7" &&
                x.RACE != "PI7" &&
                x.RACE != "WH7" &&
                x.RACE != "MU7"
                );

            }
            else if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.RACE == "MISSING" ||
                x.RACE == "AM7" ||
                x.RACE == "AS7" ||
                x.RACE == "BL7" ||
                x.RACE == "HI7" ||
                x.RACE == "PI7" ||
                x.RACE == "WH7" ||
                x.RACE == "MU7"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.RACE != "MISSING" &&
                x.RACE != "AM7" &&
                x.RACE != "AS7" &&
                x.RACE != "BL7" &&
                x.RACE != "HI7" &&
                x.RACE != "PI7" &&
                x.RACE != "WH7" &&
                x.RACE != "MU7"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }


        public void CategorySet_Sex_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.SEX == "MISSING" ||
                x.SEX == "M" ||
                x.SEX == "F"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.SEX != "MISSING" &&
                x.SEX != "M" &&
                x.SEX != "F"
                );

            }
            else if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.SEX == "MISSING" ||
                x.SEX == "M" ||
                x.SEX == "F"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                 x.SEX != "MISSING" &&
                x.SEX != "M" &&
                x.SEX != "F"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }


        public void CategorySet_EnglishLearner_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.ENGLISHLEARNERSTATUS == "MISSING" ||
                x.ENGLISHLEARNERSTATUS == "LEP" ||
                x.ENGLISHLEARNERSTATUS == "NLEP"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.ENGLISHLEARNERSTATUS != "MISSING" &&
                x.ENGLISHLEARNERSTATUS != "LEP" &&
                x.ENGLISHLEARNERSTATUS != "NLEP"
                );

            }
            else if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.LEPSTATUS == "MISSING" ||
                x.LEPSTATUS == "LEP" ||
                x.LEPSTATUS == "LEPP" ||
                x.LEPSTATUS == "NLEP"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.LEPSTATUS != "MISSING" &&
                x.LEPSTATUS != "LEP" &&
                x.LEPSTATUS != "LEPP" &&
                x.LEPSTATUS != "NLEP"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_AssessmentSubject_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.ASSESSMENTSUBJECT == "MATH" ||
                x.ASSESSMENTSUBJECT == "RLA"  ||
                x.ASSESSMENTSUBJECT == "SCIENCE"  ||
                x.ASSESSMENTSUBJECT == "CTE" ||
                x.ASSESSMENTSUBJECT == "ESL" ||
                x.ASSESSMENTSUBJECT == "English as a second language" ||
                x.ASSESSMENTSUBJECT == "MISSING"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                   x.ASSESSMENTSUBJECT != "MATH" &&
                   x.ASSESSMENTSUBJECT != "RLA"  &&
                   x.ASSESSMENTSUBJECT != "SCIENCE" &&
                   x.ASSESSMENTSUBJECT != "CTE"  &&
                   x.ASSESSMENTSUBJECT == "ESL" &&
                   x.ASSESSMENTSUBJECT == "English as a second language" &&
                   x.ASSESSMENTSUBJECT != "MISSING"
                   );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_GradeLevel_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.GRADELEVEL == "01" ||
                x.GRADELEVEL == "02" ||
                x.GRADELEVEL == "03" ||
                x.GRADELEVEL == "04" ||
                x.GRADELEVEL == "05" ||
                x.GRADELEVEL == "06" ||
                x.GRADELEVEL == "07" ||
                x.GRADELEVEL == "08" ||
                x.GRADELEVEL == "09" ||
                x.GRADELEVEL == "10" ||
                x.GRADELEVEL == "11" ||
                x.GRADELEVEL == "12" ||
                x.GRADELEVEL == "AE" ||
                x.GRADELEVEL == "KG" ||
                x.GRADELEVEL == "PK" ||
                x.GRADELEVEL == "UG" ||
                x.GRADELEVEL == "MISSING" ||
                x.GRADELEVEL == "HS"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.GRADELEVEL != "01" &&
                x.GRADELEVEL != "02" &&
                x.GRADELEVEL != "03" &&
                x.GRADELEVEL != "04" &&
                x.GRADELEVEL != "05" &&
                x.GRADELEVEL != "06" &&
                x.GRADELEVEL != "07" &&
                x.GRADELEVEL != "08" &&
                x.GRADELEVEL != "09" &&
                x.GRADELEVEL != "10" &&
                x.GRADELEVEL != "11" &&
                x.GRADELEVEL != "12" &&
                x.GRADELEVEL != "AE" &&
                x.GRADELEVEL != "KG" &&
                x.GRADELEVEL != "PK" &&
                x.GRADELEVEL != "UG" &&
                x.GRADELEVEL != "MISSING" &&
                x.GRADELEVEL != "HS"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_ProficiencyStatus_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.PROFICIENCYSTATUS == "PROFICIENT" ||
                x.PROFICIENCYSTATUS == "BELOWPROFICIENT"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                   x.PROFICIENCYSTATUS != "PROFICIENT" &&
                   x.PROFICIENCYSTATUS != "BELOWPROFICIENT"
                   );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_EconomicallyDisadvanted_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {
            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.ECODISSTATUS == "ECODIS" || x.ECODISSTATUS == "MISSING"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                    x.ECODISSTATUS != "ECODIS" && x.ECODISSTATUS != "MISSING"
                   );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_MigrantStatus_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {
            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.MIGRANTSTATUS == "MS" || x.MIGRANTSTATUS == "MISSING"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                    x.MIGRANTSTATUS != "MS" && x.MIGRANTSTATUS != "MISSING"
                   );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_Ideaindicator_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {
            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.IDEAINDICATOR == "IDEA"
                || x.IDEAINDICATOR == "MISSING"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                    x.IDEAINDICATOR != "IDEA"
                    && x.IDEAINDICATOR != "MISSING"
                   );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_Title1Status_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {
            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);


            // Assert
            if (reportTable == "FactStudentAssessmentReports")
            {
                var reports = this.rdsDbContext.FactStudentAssessmentReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
                .ToList();

                Assert.NotEmpty(reports);

                // Records with the specified category codes should exist
                Assert.Contains(reports, x =>
                x.TITLEISCHOOLSTATUS == "SWELIGNOPROG" ||
                x.TITLEISCHOOLSTATUS == "SWELIGSWPROG" ||
                x.TITLEISCHOOLSTATUS == "SWELIGTGPROG" ||
                x.TITLEISCHOOLSTATUS == "TGELGBNOPROG" ||
                x.TITLEISCHOOLSTATUS == "TGELGBTGPROG" ||
                x.TITLEISCHOOLSTATUS == "NOTTITLE1ELIG" ||
                x.TITLEISCHOOLSTATUS == "MISSING"
                );

                // Records with any other category codes should not exist
                Assert.DoesNotContain(reports, x =>
                x.TITLEISCHOOLSTATUS != "SWELIGNOPROG" &&
                x.TITLEISCHOOLSTATUS != "SWELIGSWPROG" &&
                x.TITLEISCHOOLSTATUS != "SWELIGTGPROG" &&
                x.TITLEISCHOOLSTATUS != "TGELGBNOPROG" &&
                x.TITLEISCHOOLSTATUS != "TGELGBTGPROG" &&
                x.TITLEISCHOOLSTATUS != "NOTTITLE1ELIG" &&
                x.TITLEISCHOOLSTATUS != "MISSING"
                );

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }

        }

        public void CategorySet_InterimRemoval_Missing_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {

                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                var containsMissing = reports.Any(x => x.IDEAINTERIMREMOVAL == "MISSING");

                // If MISSING exists, no other values should exist
                if (containsMissing)
                {
                    Assert.DoesNotContain(reports, x =>
                    x.IDEAINTERIMREMOVAL != "MISSING"
                    );
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }
        }

        public void CategorySet_Disability_Missing_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                var containsMissing = reports.Any(x => x.IDEADISABILITYTYPE == "MISSING");

                // If MISSING exists, no other values should exist
                if (containsMissing)
                {
                    Assert.DoesNotContain(reports, x =>
                    x.IDEADISABILITYTYPE != "MISSING"
                    );
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }
        }


        public void CategorySet_RacialEthnic_Missing_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                var containsMissing = reports.Any(x => x.RACE == "MISSING");

                // If MISSING exists, no other values should exist
                if (containsMissing)
                {
                    Assert.DoesNotContain(reports, x =>
                    x.RACE != "MISSING"
                    );
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }
        }


        public void CategorySet_Sex_Missing_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                var containsMissing = reports.Any(x => x.SEX == "MISSING");

                // If MISSING exists, no other values should exist
                if (containsMissing)
                {
                    Assert.DoesNotContain(reports, x =>
                    x.SEX != "MISSING"
                    );
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }
        }


        public void CategorySet_EnglishLearner_Missing_Should(string reportTable, string reportCode, string reportYear, string reportLevel, string categorySetCode, string totalIndicator)
        {

            // Arrange
            var repository = new FactReportRepository(this.appDbContext, this.rdsDbContext);

            // Act
            repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null);

            // Assert
            if (reportTable == "FactStudentDisciplineReports")
            {
                var reports = this.rdsDbContext.FactStudentDisciplineReports
                .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
                .ToList();

                Assert.NotEmpty(reports);

                var containsMissing = reports.Any(x => x.ENGLISHLEARNERSTATUS == "MISSING");

                // If MISSING exists, no other values should exist
                if (containsMissing)
                {
                    Assert.DoesNotContain(reports, x =>
                    x.ENGLISHLEARNERSTATUS != "MISSING"
                    );
                }

            }
            else
            {
                // No valid report table
                Assert.True(false);
            }
        }

        #endregion
    }
}
