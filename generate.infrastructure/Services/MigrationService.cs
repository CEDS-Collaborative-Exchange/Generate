using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.core.Models.RDS;
using Hangfire;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace generate.infrastructure.Services
{
    public class MigrationService : IMigrationService
    {
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IAppRepository _appRepository;
        private readonly IRDSRepository _rdsRepository;
        private readonly ITestDataInitializer _testDataInitializer;
        private readonly IHangfireHelper _hangfireHelper;

        public MigrationService(
            IOptions<AppSettings> appSettings,
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            ITestDataInitializer testDataInitializer,
            IHangfireHelper hangfireHelper
            )
        {
            _appSettings = appSettings ?? throw new ArgumentNullException(nameof(appSettings));
            _appRepository = appRepository ?? throw new ArgumentNullException(nameof(appRepository));
            _rdsRepository = rdsRepository ?? throw new ArgumentNullException(nameof(rdsRepository));
            _testDataInitializer = testDataInitializer ?? throw new ArgumentNullException(nameof(testDataInitializer));
            _hangfireHelper = hangfireHelper ?? throw new ArgumentNullException(nameof(hangfireHelper));
        }

        public void CancelMigration(string dataMigrationTypeCode)
        {

            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "Canceling migration", true);

            var api = JobStorage.Current.GetMonitoringApi();

            var processingJobs = api.ProcessingJobs(0, 1);

            while (processingJobs.Any())
            {

                foreach (var job in processingJobs)
                {
                    BackgroundJob.Delete(job.Key);
                }

                processingJobs = api.ProcessingJobs(0, 1);

            }

            _appRepository.CompleteMigration(dataMigrationTypeCode, "error");

        }

        public void MigrateData(string dataMigrationTypeCode)
        {
            
            if (dataMigrationTypeCode == "ods")
            {

                //// If ODS and Development, Test, or Stage, then generate test data
                //string hydrateJobId = null;
                //if ((_appSettings.Value.Environment.ToLower() == "development" || _appSettings.Value.Environment.ToLower() == "test" || _appSettings.Value.Environment.ToLower() == "stage"))
                //{
                //    var yearToRun = _rdsRepository.FindReadOnly<DimSchoolYearDataMigrationType>(x => x.IsSelected && x.DataMigrationType.DataMigrationTypeCode == "ods", 0, 0, y => y.DimSchoolYear).First();

                //    //If ODS and Development, Test, or Stage, then generate test data
                //    hydrateJobId = _hangfireHelper.TriggerStagingTestData(yearToRun != null ? Convert.ToInt32(yearToRun.DimSchoolYear.SchoolYear) : DateTime.Today.Year);
                //}

                // Migrate data via sql scripts from state system
                _hangfireHelper.TriggerSqlBasedMigration(dataMigrationTypeCode, null);

            }
            else if (dataMigrationTypeCode == "rds")
            {
                // Use new method of ETL when appropriate

                List<string> tasksUsingNewETL = new List<string>();

                var tasksToRun = _appRepository.FindReadOnly<DataMigrationTask>(x => x.IsSelected.HasValue && x.IsSelected == true && x.DataMigrationType.DataMigrationTypeCode == "rds", 0, 0);
                var yearsToRun = _rdsRepository.FindReadOnly<DimSchoolYearDataMigrationType>(x => x.IsSelected && x.DimDataMigrationType.DataMigrationTypeCode == "rds", 0, 0, y => y.DimSchoolYear);

                if (tasksToRun != null && yearsToRun != null)
                {
                    foreach (var datamigrationTask in tasksToRun)
                    {
                        if (datamigrationTask.TaskName != null && tasksUsingNewETL.Contains(datamigrationTask.TaskName))
                        {
                            foreach (var yearToRun in yearsToRun)
                            {
                                this.ExecuteRdsTaskByYear(datamigrationTask.StoredProcedureName, yearToRun.DimSchoolYear.SchoolYear.ToString());
                            }

                        }
                    }
                }

                // Execute legacy method of migrating data
                _hangfireHelper.TriggerSqlBasedMigration(dataMigrationTypeCode, null);

            }
            else if (dataMigrationTypeCode == "report")
            {
                // Use new method of ETL when appropriate

                IEnumerable<GenerateReport> reportsUsingNewEtl = _appRepository.FindReadOnly<GenerateReport>(x => x.IsLocked && !x.UseLegacyReportMigration, 0, 0);

                var yearsToRun = _rdsRepository.FindReadOnly<DimSchoolYearDataMigrationType>(x => x.IsSelected && x.DimDataMigrationType.DataMigrationTypeCode == "report", 0, 0, y => y.DimSchoolYear);

                if (reportsUsingNewEtl != null && yearsToRun != null)
                {
                    foreach (var generateReport in reportsUsingNewEtl)
                    {
                        foreach (var yearToRun in yearsToRun)
                        {
                            this.CreateReportByYear(generateReport.ReportCode, yearToRun.DimSchoolYear.SchoolYear.ToString());
                        }
                    }
                }

                // Execute legacy method of migrating data (which will migrate all other reports)
                _hangfireHelper.TriggerSqlBasedMigration(dataMigrationTypeCode, null);

            }
            
        }

        public void CreateStagingTestData(IJobCancellationToken jobCancellationToken, int? schoolYear)
        {
            try
            {

                // Start migration
                _appRepository.StartMigration("ods", true);

                // Get configuration data
                List<GenerateConfiguration> generateConfigurations = _appRepository.Find<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

                // Check if test data generation has been disabled
                bool skipTestDataGenerationFromConfig = true;
                bool.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SkipTestDataGeneration").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out skipTestDataGenerationFromConfig);

                if (!skipTestDataGenerationFromConfig)
                {
                    _testDataInitializer.PopulateStagingTestData(jobCancellationToken, schoolYear);
                }

                _appRepository.CompleteMigration("ods", "success");
            }
            catch (Exception ex)
            {

                _appRepository.LogException("ods", ex);
                _appRepository.CompleteMigration("ods", "error");

                throw;
            }

        }
        public void CreateOdsTestData(IJobCancellationToken jobCancellationToken)
        {
            try
            {

                // Start migration
                _appRepository.StartMigration("ods", true);

                // Get configuration data
                List<GenerateConfiguration> generateConfigurations = _appRepository.Find<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

                // Check if test data generation has been disabled
                bool skipTestDataGenerationFromConfig = true;
                bool.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SkipTestDataGeneration").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out skipTestDataGenerationFromConfig);

                if (!skipTestDataGenerationFromConfig)
                {
                    _testDataInitializer.PopulateOdsTestData(jobCancellationToken);
                }

                _appRepository.CompleteMigration("ods", "success");
            }
            catch (Exception ex)
            {

                _appRepository.LogException("ods", ex);
                _appRepository.CompleteMigration("ods", "error");

                throw;
            }

        }

        public void ExecuteRdsTaskByYear(string taskName, string reportYear)
        {
            // Method intentionally left empty.
        }

        public void CreateReportByYear(string reportCode, string reportYear)
        {
            // Get category sets

            IQueryable<CategorySet> categorySets = _appRepository.GetCategorySets(reportCode, reportYear, null);
            var categorySetList = categorySets.ToList();

            if (categorySetList != null)
            {
                foreach (var categorySet in categorySets)
                {
                    _hangfireHelper.TriggerReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, categorySet.OrganizationLevel.LevelCode, categorySet.CategorySetCode);
                }
            }        
            
        }



    }
}
