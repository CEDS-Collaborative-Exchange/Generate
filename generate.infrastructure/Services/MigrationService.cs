using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using Hangfire;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace generate.infrastructure.Services
{
    public class MigrationService : IMigrationService, IDisposable
    {
        private readonly IAppRepository _appRepository;
        private readonly IRDSRepository _rdsRepository;
        private readonly ITestDataInitializer _testDataInitializer;
        private readonly IHangfireHelper _hangfireHelper;
        private readonly IDataMigrationHistoryService _dataMigrationHistoryService;
        private readonly AppDbContext _context;
        private CancellationTokenSource _executeSqlCancellationSource;

        public MigrationService(
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            ITestDataInitializer testDataInitializer,
            IHangfireHelper hangfireHelper,
            IDataMigrationHistoryService dataMigrationHistoryService,
            AppDbContext context
            )
        {

            _appRepository = appRepository ?? throw new ArgumentNullException(nameof(appRepository));
            _rdsRepository = rdsRepository ?? throw new ArgumentNullException(nameof(rdsRepository));
            _testDataInitializer = testDataInitializer ?? throw new ArgumentNullException(nameof(testDataInitializer));
            _hangfireHelper = hangfireHelper ?? throw new ArgumentNullException(nameof(hangfireHelper));
            _dataMigrationHistoryService = dataMigrationHistoryService ?? throw new ArgumentNullException(nameof(dataMigrationHistoryService));
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public void CancelMigration(string dataMigrationTypeCode)
        {

            _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, "Canceling migration", true);

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

            this.CompleteMigration(dataMigrationTypeCode, "error");

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

                //List<string> tasksUsingNewETL = new List<string>();

                //var tasksToRun = _appRepository.FindReadOnly<DataMigrationTask>(x => x.IsSelected.HasValue && x.IsSelected == true && x.DataMigrationType.DataMigrationTypeCode == "rds", 0, 0);
                //var yearsToRun = _rdsRepository.FindReadOnly<DimSchoolYearDataMigrationType>(x => x.IsSelected && x.DimDataMigrationType.DataMigrationTypeCode == "rds", 0, 0, y => y.DimSchoolYear);

                //if (tasksToRun != null && yearsToRun != null)
                //{
                //    foreach (var datamigrationTask in tasksToRun)
                //    {
                //        if (datamigrationTask.TaskName != null && tasksUsingNewETL.Contains(datamigrationTask.TaskName))
                //        {
                //            foreach (var yearToRun in yearsToRun)
                //            {
                //                this.ExecuteRdsTaskByYear(datamigrationTask.StoredProcedureName, yearToRun.DimSchoolYear.SchoolYear.ToString());
                //            }

                //        }
                //    }
                //}

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
                this.StartMigration("ods", true);

                // Get configuration data
                List<GenerateConfiguration> generateConfigurations = _appRepository.Find<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

                // Check if test data generation has been disabled
                bool skipTestDataGenerationFromConfig = true;
                bool.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SkipTestDataGeneration").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out skipTestDataGenerationFromConfig);

                if (!skipTestDataGenerationFromConfig)
                {
                    _testDataInitializer.PopulateStagingTestData(jobCancellationToken, schoolYear);
                }

                this.CompleteMigration("ods", "success");
            }
            catch (Exception ex)
            {

                this.LogException("ods", ex);
                this.CompleteMigration("ods", "error");

                throw;
            }

        }
        public void CreateOdsTestData(IJobCancellationToken jobCancellationToken)
        {
            try
            {

                // Start migration
                this.StartMigration("ods", true);

                // Get configuration data
                List<GenerateConfiguration> generateConfigurations = _appRepository.Find<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

                // Check if test data generation has been disabled
                bool skipTestDataGenerationFromConfig = true;
                bool.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SkipTestDataGeneration").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out skipTestDataGenerationFromConfig);

                if (!skipTestDataGenerationFromConfig)
                {
                    _testDataInitializer.PopulateOdsTestData(jobCancellationToken);
                }

                this.CompleteMigration("ods", "success");
            }
            catch (Exception ex)
            {

                this.LogException("ods", ex);
                this.CompleteMigration("ods", "error");

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

        public void Dispose()
        {
            _executeSqlCancellationSource?.Cancel();
            _executeSqlCancellationSource?.Dispose();
            _executeSqlCancellationSource = null;
            GC.SuppressFinalize(this);
        }

        public void StartMigration(string dataMigrationTypeCode, bool setToProcessing = false)
        {
            // Start time (UTC date)
            DateTime startDate = DateTime.UtcNow;

            // Get dataMigration for type
            DataMigration dataMigration = _appRepository.Find<DataMigration>(m => m.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode, 0, 0, d => d.DataMigrationStatus).FirstOrDefault();

            // Get statuses
            List<DataMigrationStatus> dataMigrationStatuses = _appRepository.GetAllReadOnly<DataMigrationStatus>(0, 0).ToList();
            DataMigrationStatus pendingStatus = null;
            DataMigrationStatus processingStatus = null;

            if (dataMigrationStatuses != null)
            {
                pendingStatus = dataMigrationStatuses.FirstOrDefault(s => s.DataMigrationStatusCode == "pending");
                processingStatus = dataMigrationStatuses.FirstOrDefault(s => s.DataMigrationStatusCode == "processing");
            }

            if (dataMigration != null)
            {
                // Set Migration Status to pending, set last trigger date
                if (setToProcessing && processingStatus != null)
                {
                    dataMigration.DataMigrationStatusId = processingStatus.DataMigrationStatusId;
                }
                else if (pendingStatus != null)
                {
                    dataMigration.DataMigrationStatusId = pendingStatus.DataMigrationStatusId;
                }
                dataMigration.LastTriggerDate = startDate;
                _appRepository.Save();
            }


            _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Started", true);

        }

        public void CompleteReportMigrationIfReady()
        {
            // Make sure all report tasks are completed

            var reportsPending = _context.Set<GenerateReport>().Any(x => x.IsLocked);

            if (!reportsPending)
            {
                this.CompleteMigration("report", "success");
            }

        }

        public void CompleteMigration(string dataMigrationTypeCode, string dataMigrationStatusCode)
        {
            DataMigration dataMigration = _context.Set<DataMigration>().FirstOrDefault(x => x.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode);

            if (dataMigration == null) return;

            // Make sure we get latest from database in case data was updated by Hangfire
            _context.Entry<DataMigration>(dataMigration).Reload();

            var migrationStatus = _context.Set<DataMigrationStatus>().FirstOrDefault(x => x.DataMigrationStatusId == dataMigration.DataMigrationStatusId);
            var currentStatus = "";

            if (migrationStatus != null)
            {
                currentStatus = migrationStatus.DataMigrationStatusCode;
            }

            if (dataMigration.DataMigrationStatus != null)
            {
                currentStatus = dataMigration.DataMigrationStatus.DataMigrationStatusCode;
            }

            // Do not complete if status is already error
            if (currentStatus != "error")
            {
                // Set duration if not error/canceled
                if (dataMigrationStatusCode != "error")
                {
                    var startTime = dataMigration.LastTriggerDate;
                    var endTime = DateTime.UtcNow;
                    var duration = endTime.Subtract(startTime.Value);
                    dataMigration.LastDurationInSeconds = (int)duration.TotalSeconds;
                }

                var dataMigrationStatus = _context.Set<DataMigrationStatus>().FirstOrDefault(x => x.DataMigrationStatusCode == dataMigrationStatusCode);
                dataMigration.DataMigrationStatusId = dataMigrationStatus.DataMigrationStatusId;

                var lockedReports = _appRepository.GetReports().Where(r => r.IsLocked);
                if (lockedReports.Any())
                {
                    var factTypeId = lockedReports.ToList()[0].GenerateReport_FactTypes[0].FactTypeId;
                    var dataMigrtionTasks = _context.Set<DataMigrationTask>().OrderBy(t => t.TaskSequence).Where(t => t.FactTypeId == factTypeId).Select(t => t.DataMigrationTaskId.ToString()).ToList();
                    dataMigration.DataMigrationTaskList = string.Join(",", dataMigrtionTasks);
                    _context.SaveChanges();
                }

                // Log migration complete message
                if (dataMigrationStatusCode == "error")
                {
                    _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Complete - either due to error or cancellation", true);
                    this.MarkReportsAsComplete();
                }
                else
                {
                    _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Complete - successful", true);
                }
            }
            else
            {
                _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Completed after Cancel/Error", true);
                this.MarkReportsAsComplete();
            }
        }

        public void MarkReportsAsComplete()
        {
            var lockedReports = _appRepository.GetReports().Where(r => r.IsLocked);
            foreach (var report in lockedReports)
            {
                this.MarkReportAsComplete(report.ReportCode);
            }
        }

        public void LogException(string dataMigrationTypeCode, Exception ex)
        {
            _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, "Error Occurred - " + ex.Message, true);
            _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, "Error Stack Trace = " + ex.StackTrace, true);

            if (ex.InnerException != null)
            {
                _dataMigrationHistoryService.LogDataMigrationHistory(dataMigrationTypeCode, "Error Inner Exception Message = " + ex.InnerException.Message, true);
            }
        }

        public void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken)
        {
            _executeSqlCancellationSource ??= new CancellationTokenSource();

            try
            {
                // Start migration
                this.StartMigration(dataMigrationTypeCode, false);

                // Run migration

                // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
                // https://github.com/HangfireIO/Hangfire/issues/211

                var connection = _context.Database.GetDbConnection();

                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                using (var command = connection.CreateCommand())
                {

                    Action cancelWithGrace = () =>
                    {
                        try
                        {
                            command.Cancel();
                            _executeSqlCancellationSource.Cancel();
                        }
                        catch (System.Exception ex)
                        {
                            Console.Error.WriteLine($"Exception called canceWithGrace:{ex}");
                        }

                    };

                    if (jobCancellationToken != null)
                    {
                        Task.Run(() =>
                        {
                            try
                            {
                                while (true)
                                {
                                    Thread.Sleep(1000);
                                    jobCancellationToken.ThrowIfCancellationRequested();
                                }
                            }
                            catch (Exception ex)
                            {
                                Console.Error.WriteLine($"Cancellation called :{ex}");
                                cancelWithGrace();
                            }
                        }, _executeSqlCancellationSource.Token);
                    }
                    command.CommandTimeout = 300000;
                    command.CommandText = "EXEC app.Migrate_Data";
                    command.ExecuteNonQueryAsync().GetAwaiter().GetResult();

                }
            }
            catch (Exception ex)
            {
                this.LogException(dataMigrationTypeCode, ex);
                this.CompleteMigration(dataMigrationTypeCode, "error");
                throw;
            }

        }

        public void MarkReportAsComplete(string reportCode)
        {

            // Verify that all pending jobs have completed first

            var api = JobStorage.Current.GetMonitoringApi();
            var reportMigrationJobs = api.ProcessingJobs(0, (int)api.ProcessingCount()).Where(x => x.Value.InProcessingState && x.Value.Job.Method.Name == "ExecuteReportMigrationByYearLevelAndCategorySet");

            if (!reportMigrationJobs.Any())
            {
                GenerateReport report = _context.Set<GenerateReport>().Where(x => x.ReportCode == reportCode).FirstOrDefault();
                if (report != null)
                {
                    report.IsLocked = false;
                    _context.SaveChanges();
                }

                this.CompleteReportMigrationIfReady();

            }

        }

        public void toggleReportLock(string factTypeCode, string reportCode, bool isLocked)
        {

            if (reportCode != "")
            {
                var report = _context.Set<GenerateReport>().FirstOrDefault(x => x.ReportCode == reportCode);
                report.IsLocked = isLocked;
                _context.SaveChanges();
            }
            else if (factTypeCode != "")
            {
                var factType = _rdsRepository.GetFactType(factTypeCode);
                var reports = _appRepository.Find<GenerateReport>(t => t.GenerateReport_FactTypes.Any(t => t.FactTypeId == factType.DimFactTypeId)).ToList();
                foreach (var report in reports)
                {
                    report.IsLocked = isLocked;
                    _context.SaveChanges();
                }
            }
            else
            {
                var reportList = "029,002,005,006,007,009,032,033,040,052,088,089,116,118,141,143,144,175,178,179,185,188,189,194";
                string[] reportCodes = reportList.Split(',');
                var reports = _appRepository.Find<GenerateReport>(t => reportCodes.Contains(t.ReportCode) && t.IsActive).ToList();
                foreach (var report in reports)
                {
                    report.IsLocked = isLocked;
                    _context.SaveChanges();
                }
            }

        }

    }
}
