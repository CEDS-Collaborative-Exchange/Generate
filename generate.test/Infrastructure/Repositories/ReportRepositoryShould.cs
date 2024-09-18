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

namespace generate.test.Infrastructure.Repositories
{
    public class ReportRepositoryShould
    {

        private AppDbContext GetAppDbContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.AppDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            return context;
        }


        private RDSDbContext GetRdsDbContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.RDSDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<RDSDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new RDSDbContext(options, logger, appSettings);

            return context;
        }


        private void SetupReferenceData(AppDbContext appDbContext, RDSDbContext rdsDbContext, string reportCode)
        {
            var generateReports = GenerateReportHelper.GetData().Where(x => x.ReportCode == reportCode);
            int? generateReportId = null;
            if (generateReports.Any())
            {
                generateReportId = generateReports.FirstOrDefault().GenerateReportId;
            }

            appDbContext.DataMigrationTypes.AddRange(DataMigrationTypeHelper.GetData());
            appDbContext.OrganizationLevels.AddRange(OrganizationLevelHelper.GetData());
            appDbContext.GenerateReports.AddRange(GenerateReportHelper.GetData());
            appDbContext.Categories.AddRange(CategoryHelper.GetData());
            appDbContext.TableTypes.AddRange(TableTypeHelper.GetData());
            appDbContext.CategorySets.AddRange(CategorySetHelper.GetData(generateReportId));

            appDbContext.SaveChanges();

            rdsDbContext.DimDates.AddRange(DimDateHelper.GetData());
            rdsDbContext.DimAges.AddRange(DimAgeHelper.GetData());
            rdsDbContext.DimDemographics.AddRange(DimDemographicHelper.GetData());
            rdsDbContext.DimFactTypes.AddRange(DimFactTypeHelper.GetData());
            rdsDbContext.DimLanguages.AddRange(DimLanguageHelper.GetData());
            rdsDbContext.DimProgramStatuses.AddRange(DimProgramStatusHelper.GetData());

            rdsDbContext.SaveChanges();

        }

        private void SetupTestData(RDSDbContext rdsDbContext)
        {
            //rdsDbContext.DimSchools.AddRange(DimSchoolHelper.GetData());
            //rdsDbContext.FactStudentCounts.AddRange(FactStudentCountHelper.GetData());

            //rdsDbContext.SaveChanges();
        }

        // TODO - Should be moved into a FS045_Tests.cs class

        /*

        [Fact]
        public void CreateReport_S045_201718_SEA_CSA()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "sea";
            var categorySetCode = "CSA";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();

                Assert.NotEmpty(reports);

                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "LEP" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "NLEP" && x.TotalIndicator == "N");
                Assert.Equal(60, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(90, report.StudentCount);

            }

        }


        [Fact]
        public void CreateReport_S045_201718_LEA_CSA()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "lea";
            var categorySetCode = "CSA";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();
                Assert.NotEmpty(reports);

                // LEA 1
                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "LEP" && x.TotalIndicator == "N");
                Assert.Equal(20, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "NLEP" && x.TotalIndicator == "N");
                Assert.Equal(40, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LEPSTATUS == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(60, report.StudentCount);

                // LEA 2
                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LEPSTATUS == "LEP" && x.TotalIndicator == "N");
                Assert.Equal(10, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LEPSTATUS == "NLEP" && x.TotalIndicator == "N");
                Assert.Equal(20, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LEPSTATUS == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

            }

        }



        [Fact]
        public void CreateReport_S045_201718_SEA_CSB()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "sea";
            var categorySetCode = "CSB";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();

                Assert.NotEmpty(reports);

                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "eng" && x.TotalIndicator == "N");
                Assert.Equal(130, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "spa" && x.TotalIndicator == "N");
                Assert.Equal(20, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "fre" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

            }

        }



        [Fact]
        public void CreateReport_S045_201718_LEA_CSB()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "lea";
            var categorySetCode = "CSB";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();
                Assert.NotEmpty(reports);

                // LEA 1
                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "eng" && x.TotalIndicator == "N");
                Assert.Equal(100, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "spa" && x.TotalIndicator == "N");
                Assert.Equal(20, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.LANGUAGE == "fre" && x.TotalIndicator == "N");
                Assert.Null(report);

                // LEA 2
                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LANGUAGE == "eng" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LANGUAGE == "spa" && x.TotalIndicator == "N");
                Assert.Null(report);

                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.LANGUAGE == "fre" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

            }

        }




        [Fact]
        public void CreateReport_S045_201718_SEA_CSC()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "sea";
            var categorySetCode = "CSC";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();

                Assert.NotEmpty(reports);

                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TITLEIIIPROGRAMPARTICIPATION == "PART" && x.TotalIndicator == "N");
                Assert.Equal(130, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TITLEIIIPROGRAMPARTICIPATION == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(50, report.StudentCount);

            }

        }



        [Fact]
        public void CreateReport_S045_201718_LEA_CSC()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "lea";
            var categorySetCode = "CSC";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "N")
                    .ToList();
                Assert.NotEmpty(reports);

                // LEA 1
                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TITLEIIIPROGRAMPARTICIPATION == "PART" && x.TotalIndicator == "N");
                Assert.Equal(100, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TITLEIIIPROGRAMPARTICIPATION == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(20, report.StudentCount);

                // LEA 2
                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.TITLEIIIPROGRAMPARTICIPATION == "PART" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.TITLEIIIPROGRAMPARTICIPATION == "MISSING" && x.TotalIndicator == "N");
                Assert.Equal(30, report.StudentCount);

            }

        }


        [Fact]
        public void CreateReport_S045_201718_SEA_TOT()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "sea";
            var categorySetCode = "TOT";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "Y")
                    .ToList();

                Assert.NotEmpty(reports);

                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TotalIndicator == "Y");
                Assert.Equal(180, report.StudentCount);

            }

        }



        [Fact]
        public void CreateReport_S045_201718_LEA_TOT()
        {
            var reportCode = "c045";
            var reportYear = "2017-18";
            var reportLevel = "lea";
            var categorySetCode = "TOT";

            using (var appDbContext = GetAppDbContext())
            using (var rdsDbContext = GetRdsDbContext())
            {
                // Arrange
                SetupReferenceData(appDbContext, rdsDbContext, reportCode);
                SetupTestData(rdsDbContext);

                // Act
                var repository = new FactReportRepository(appDbContext, rdsDbContext);
                repository.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode);

                //Assert
                var reports = rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode && x.ReportYear == reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == "Y")
                    .ToList();
                Assert.NotEmpty(reports);

                // LEA 1
                var report = reports.SingleOrDefault(x => x.OrganizationId == 1 && x.TotalIndicator == "Y");
                Assert.Equal(120, report.StudentCount);


                // LEA 2
                report = reports.SingleOrDefault(x => x.OrganizationId == 2 && x.TotalIndicator == "Y");
                Assert.Equal(60, report.StudentCount);


            }

        }

        */

    }
}
