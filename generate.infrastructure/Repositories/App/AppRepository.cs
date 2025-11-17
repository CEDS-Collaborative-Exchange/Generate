using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using generate.core.Config;
using generate.core.Interfaces.Repositories.App;
using System.Threading;
using Hangfire;
using System.IO;

namespace generate.infrastructure.Repositories.App
{

    public class AppRepository : RepositoryBase, IAppRepository, IDisposable
    {
        private CancellationTokenSource source;
        public AppRepository(AppDbContext context)
            : base(context)
        {
            this.source = new CancellationTokenSource();
        }

        public void Dispose()
        {
            GC.SuppressFinalize(this);
        }
        
        public void StartMigration(string dataMigrationTypeCode, bool setToProcessing = false)
        {
            // Start time (UTC date)
            DateTime startDate = DateTime.UtcNow;

            // Get dataMigration for type
            DataMigration dataMigration = Find<DataMigration>(m => m.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode, 0, 0, d => d.DataMigrationStatus).FirstOrDefault();

            // Get statuses
            List<DataMigrationStatus> dataMigrationStatuses = GetAllReadOnly<DataMigrationStatus>(0, 0).ToList();
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
                Save();
            }

           
            LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Started", true);

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

            if (dataMigration != null) {
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

                    var lockedReports = this.GetReports().Where(r => r.IsLocked);
                    var factTypeId = lockedReports.ToList()[0].GenerateReport_FactTypes[0].FactTypeId;
                    var dataMigrtionTasks = _context.Set<DataMigrationTask>().OrderBy(t => t.TaskSequence).Where(t => t.FactTypeId == factTypeId).Select(t => t.DataMigrationTaskId.ToString()).ToList();
                    dataMigration.DataMigrationTaskList = string.Join(",", dataMigrtionTasks);
                    _context.SaveChanges();

                    // Log migration complete message

                    if (dataMigrationStatusCode == "error")
                    {
                        LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Complete - either due to error or cancellation", true);
                        this.MarkReportsAsComplete();
                    }
                    else
                    {
                        LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Complete - successful", true);
                    }

                }
                else
                {
                    LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Completed after Cancel/Error", true);
                    this.MarkReportsAsComplete();
                }
            }
        }

        public void MarkReportsAsComplete()
        {
            var lockedReports = this.GetReports().Where(r => r.IsLocked);
            foreach (var report in lockedReports)
            {
                this.MarkReportAsComplete(report.ReportCode);
            }
        }

        public void LogException(string dataMigrationTypeCode, Exception ex)
        {
            LogDataMigrationHistory(dataMigrationTypeCode, "Error Occurred - " + ex.Message, true);
            LogDataMigrationHistory(dataMigrationTypeCode, "Error Stack Trace = " + ex.StackTrace, true);

            if (ex.InnerException != null)
            {
                LogDataMigrationHistory(dataMigrationTypeCode, "Error Inner Exception Message = " + ex.InnerException.Message, true);
            }
        }

        public void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true)
        {

            Console.WriteLine(DateTime.Now + " - " + dataMigrationTypeCode + " - " + dataMigrationHistoryMessage);

            if (logToDatabase)
            {
                DataMigrationHistory historyRecord = new DataMigrationHistory();
                DataMigrationType dataMigrationType = Find<DataMigrationType>(s => s.DataMigrationTypeCode == dataMigrationTypeCode).FirstOrDefault();

                if (dataMigrationType != null)
                {
                    historyRecord = new DataMigrationHistory();
                    historyRecord.DataMigrationHistoryDate = DateTime.UtcNow;
                    historyRecord.DataMigrationTypeId = dataMigrationType.DataMigrationTypeId;
                    historyRecord.DataMigrationHistoryMessage = dataMigrationHistoryMessage;
                    Create(historyRecord);
                    Save();
                }

            }

        }

        public IEnumerable<DataMigrationHistory> GetMigrationHistory(string dataMigrationTypeCode, int skip = 0, int take = 1000)
        {
            DbSet<DataMigrationHistory> set = _context.Set<DataMigrationHistory>();
            IQueryable<DataMigrationHistory> results = set.AsQueryable();

            results = results.Include(r => r.DataMigrationType);

            //if (dataMigrationTypeCode != null)
            //{
            //    results = results.Where(r => r.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode);
            //}

            results = results.OrderByDescending(r => r.DataMigrationHistoryDate);

            if (skip != 0)
            {
                results = results.Skip(skip);
            }

            if (take != 0)
            {
                results = results.Take(take);
            }

            return results;
        }

        public void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken)
        {
            try
            {
                // Start migration
                StartMigration(dataMigrationTypeCode, false);

                // Run migration

                int? oldTimeOut = _context.Database.GetCommandTimeout();
                _context.Database.SetCommandTimeout(30000);

                // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
                // https://github.com/HangfireIO/Hangfire/issues/211

                //var source = new CancellationTokenSource();

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
                        catch (Exception)
                        {
                            this.source.Cancel(); 
                            this.source.Dispose();
                        }
                    }, this.source.Token);
                }

                var dbTask = _context.Database.ExecuteSqlRawAsync("app.Migrate_Data", this.source.Token);
                dbTask.Wait();

                _context.Database.SetCommandTimeout(oldTimeOut);
            }
            catch (Exception ex)
            {
                this.LogException(dataMigrationTypeCode, ex);
                this.CompleteMigration(dataMigrationTypeCode, "error");
                throw;
            }



        }


        public IEnumerable<GenerateReport> GetReports(string reportTypeCode, int skip = 0, int take = 50)
        {

            DbSet<GenerateReport> set = _context.Set<GenerateReport>();
            IQueryable<GenerateReport> results = set.AsQueryable();

            results = results.Include(r => r.GenerateReportControlType);
            results = results.Include(r => r.GenerateReport_FactTypes);
            results = results.Include(r => r.GenerateReport_OrganizationLevels)
                .ThenInclude((GenerateReport_OrganizationLevel p) => p.OrganizationLevel);
            results = results.Include(r => r.GenerateReportFilterOptions);
            results = results.Include(r => r.CedsConnection);
            results = results.Include(r => r.CategorySets)
                .ThenInclude((CategorySet p) => p.CategorySet_Categories)
                .ThenInclude((CategorySet_Category cs) => cs.Category);


            if (reportTypeCode != null)
            {
                results = results.Where(r => r.GenerateReportType.ReportTypeCode == reportTypeCode);
            }

            results = results.OrderBy(r => r.ReportSequence != null ? r.ReportSequence.ToString() : r.ReportShortName);

            if (skip != 0)
            {
                results = results.Skip(skip);
            }

            if (take != 0)
            {
                results = results.Take(take);
            }

            return results;
        }

        public IEnumerable<GenerateReport> GetReports(int skip = 0, int take = 50)
        {

            DbSet<GenerateReport> set = _context.Set<GenerateReport>();
            IQueryable<GenerateReport> results = set.AsQueryable();

            results = results.Include(r => r.GenerateReport_FactTypes);

            results = results.Where(r => r.IsActive);
            results = results.OrderBy(r => r.ReportCode);

            if (skip != 0)
            {
                results = results.Skip(skip);
            }

            if (take != 0)
            {
                results = results.Take(take);
            }

            return results;
        }

        public IQueryable<CategorySet> GetCategorySets(string reportCode, string reportYear, string reportLevel)
        {
            IQueryable<CategorySet> categorySets = _context.Set<CategorySet>()
            .Include(x => x.TableType)
            .Include(x => x.OrganizationLevel)
            .Where(x =>
                x.GenerateReport.ReportCode == reportCode &&
                x.SubmissionYear == reportYear                
            );
            
            if (reportLevel != null)
            {
                categorySets = categorySets.Where(x => x.OrganizationLevel.LevelCode == reportLevel);
            }

            return categorySets;
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

        public void UpdateViewDefinitions()
        {

            int? oldTimeOut = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(11000);
            _context.Database.ExecuteSqlRaw("app.UpdateViewDefinitions");
            _context.Database.SetCommandTimeout(oldTimeOut);


        }
    }

}
