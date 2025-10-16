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
using System.IO.Abstractions;
using Microsoft.Extensions.DependencyInjection;

namespace generate.infrastructure.Repositories.App
{

    public class AppRepository : RepositoryBase, IAppRepository, IDisposable
    {
        private CancellationTokenSource source;
        private ILogger logger;
        private readonly IServiceScopeFactory _scopeFactory;

        public AppRepository(AppDbContext context, ILogger<AppRepository> iLogger, IServiceScopeFactory scopeFactory)
            : base(context)
        {
            this.source = new CancellationTokenSource();
            this.logger = iLogger;
            this._scopeFactory = scopeFactory;

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

        private async Task StartMigrationAsync(string dataMigrationTypeCode, bool setToProcessing, AppDbContext context)
        {
            // Start time (UTC date)
            DateTime startDate = DateTime.UtcNow;

            // Get dataMigration for type
            var dataMigration = await context.Set<DataMigration>()
                .Include(d => d.DataMigrationStatus)
                .Include(d => d.DataMigrationType)
                .FirstOrDefaultAsync(m => m.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode);

            // Get statuses
            var dataMigrationStatuses = await context.Set<DataMigrationStatus>().ToListAsync();
            DataMigrationStatus pendingStatus = dataMigrationStatuses.FirstOrDefault(s => s.DataMigrationStatusCode == "pending");
            DataMigrationStatus processingStatus = dataMigrationStatuses.FirstOrDefault(s => s.DataMigrationStatusCode == "processing");

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
                await context.SaveChangesAsync();
            }

            await LogDataMigrationHistoryAsync(dataMigrationTypeCode, dataMigrationTypeCode.ToUpper() + " Migration Started", context);
        }

        public void CompleteReportMigrationIfReady()
        {
            // Make sure all report tasks are completed
            logger.LogInformation("Inside CompleteReportMigrationIfReady");
            var reportsPending = _context.Set<GenerateReport>().Any(x => x.IsLocked);
            logger.LogInformation("Is reportsPending :{reportPending}", reportsPending);
            if (!reportsPending)
            {
                this.CompleteMigration("report", "success");
            }

        }

        public void CompleteMigration(string dataMigrationTypeCode, string dataMigrationStatusCode)
        {
            logger.LogInformation($"Inside CompleteMigration dataMigrationTypeCode:{dataMigrationTypeCode},dataMigrationStatusCode:{dataMigrationStatusCode}", dataMigrationTypeCode, dataMigrationStatusCode);

            DataMigration dataMigration = _context.Set<DataMigration>().FirstOrDefault(x => x.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode);

            if (dataMigration != null)
            {
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

        private async Task CompleteMigrationWithSeparateContextAsync(string dataMigrationTypeCode, string dataMigrationStatusCode)
        {
            logger.LogInformation("[CompleteMigrationWithSeparateContextAsync] Completing migration for {dataMigrationTypeCode} with status {dataMigrationStatusCode}", dataMigrationTypeCode, dataMigrationStatusCode);
            
            try
            {
                // Use a completely separate scope to avoid any DataReader conflicts
                using var completionScope = _scopeFactory.CreateScope();
                var completionContext = completionScope.ServiceProvider.GetRequiredService<AppDbContext>();
                
                var dataMigration = await completionContext.Set<DataMigration>()
                    .Include(d => d.DataMigrationType)
                    .Include(d => d.DataMigrationStatus)
                    .FirstOrDefaultAsync(x => x.DataMigrationType.DataMigrationTypeCode == dataMigrationTypeCode);

                logger.LogInformation($"Found dataMigration:{dataMigration}");
                if (dataMigration != null)
                {
                    // Reload to get latest state
                    await completionContext.Entry(dataMigration).ReloadAsync();

                    var currentStatus = dataMigration.DataMigrationStatus?.DataMigrationStatusCode ?? "";

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

                        var newMigrationStatus = await completionContext.Set<DataMigrationStatus>()
                            .FirstOrDefaultAsync(x => x.DataMigrationStatusCode == dataMigrationStatusCode);

                        if (newMigrationStatus != null)
                        {
                            dataMigration.DataMigrationStatusId = newMigrationStatus.DataMigrationStatusId;
                        }

                        // Handle report completion logic if needed
                        var lockedReports = await completionContext.Set<GenerateReport>()
                            .Include(r => r.GenerateReport_FactTypes)
                            .Where(r => r.IsLocked)
                            .ToListAsync();

                        if (lockedReports.Any())
                        {
                            var factTypeId = lockedReports.First().GenerateReport_FactTypes?.FirstOrDefault()?.FactTypeId;
                            if (factTypeId.HasValue)
                            {
                                var dataMigrationTasks = await completionContext.Set<DataMigrationTask>()
                                    .Where(t => t.FactTypeId == factTypeId)
                                    .OrderBy(t => t.TaskSequence)
                                    .Select(t => t.DataMigrationTaskId.ToString())
                                    .ToListAsync();
                                dataMigration.DataMigrationTaskList = string.Join(",", dataMigrationTasks);
                            }
                        }

                        await completionContext.SaveChangesAsync();

                        // Log completion message
                        string logMessage = dataMigrationStatusCode == "error"
                            ? dataMigrationTypeCode.ToUpper() + " Migration Complete - either due to error or cancellation"
                            : dataMigrationTypeCode.ToUpper() + " Migration Complete - successful";

                        await LogDataMigrationHistoryAsync(dataMigrationTypeCode, logMessage, completionContext);
                        if (dataMigrationStatusCode.Contains("error") )
                        {
                            await MarkReportsAsCompleteAsync();
                        }

                    }
                    else
                    {
                        await LogDataMigrationHistoryAsync(dataMigrationTypeCode,
                            dataMigrationTypeCode.ToUpper() + " Migration Completed after Cancel/Error", completionContext);
                        await MarkReportsAsCompleteAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "[CompleteMigrationWithSeparateContextAsync] Error completing migration for {dataMigrationTypeCode}", dataMigrationTypeCode);
            }
            
        }

        public void MarkReportsAsComplete()
        {
            logger.LogInformation("Inside MarkReportAsComplete");
            var lockedReports = this.GetReports().Where(r => r.IsLocked);
            logger.LogInformation($"Found lockedReport size:{lockedReports.Count()}");
            foreach (var report in lockedReports)
            {
                this.MarkReportAsComplete(report.ReportCode);
            }
        }

        /// <summary>
        /// Async version of MarkReportsAsComplete that uses a separate scope to avoid DbContext conflicts.
        /// Marks all locked reports as complete by setting IsLocked = false.
        /// </summary>
        public async Task MarkReportsAsCompleteAsync()
        {
            logger.LogInformation("[MarkReportsAsCompleteAsync] Starting to mark locked reports as complete");
            
            try
            {
                // Use a separate scope to avoid any DbContext conflicts
                using var scope = _scopeFactory.CreateScope();
                var scopedContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                
                // Get all locked reports using the scoped context
                var lockedReports = await scopedContext.Set<GenerateReport>()
                    .Where(r => r.IsLocked && r.IsActive)
                    .ToListAsync();
                
                logger.LogInformation("[MarkReportsAsCompleteAsync] Found {count} locked reports to mark as complete", lockedReports.Count);
                
                foreach (var report in lockedReports)
                {
                    await MarkReportAsCompleteAsync(report.ReportCode);
                }
                
                logger.LogInformation("[MarkReportsAsCompleteAsync] Completed marking all reports as complete");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "[MarkReportsAsCompleteAsync] Error marking reports as complete");
            }
        }

        /// <summary>
        /// Async version of MarkReportAsComplete that uses a separate scope to avoid DbContext conflicts.
        /// Marks a specific report as complete by setting IsLocked = false and checks if migration is ready to complete.
        /// </summary>
        /// <param name="reportCode">The report code to mark as complete</param>
        public async Task MarkReportAsCompleteAsync(string reportCode)
        {
            logger.LogInformation("[MarkReportAsCompleteAsync] Marking report {reportCode} as complete", reportCode);
            
            try
            {
                // Use a separate scope to avoid any DbContext conflicts
                using var scope = _scopeFactory.CreateScope();
                var scopedContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                
                // Verify that all pending jobs have completed first
                var api = JobStorage.Current.GetMonitoringApi();
                var reportMigrationJobs = api.ProcessingJobs(0, (int)api.ProcessingCount())
                    .Where(x => x.Value.InProcessingState && x.Value.Job.Method.Name == "ExecuteReportMigrationByYearLevelAndCategorySet");
                
                logger.LogInformation("[MarkReportAsCompleteAsync] Found {count} report migration jobs still processing", reportMigrationJobs.Count());
                
                if (!reportMigrationJobs.Any())
                {
                    logger.LogInformation("[MarkReportAsCompleteAsync] No report migration jobs in progress, proceeding to unlock report");
                    
                    var report = await scopedContext.Set<GenerateReport>()
                        .FirstOrDefaultAsync(x => x.ReportCode == reportCode);
                    
                    if (report != null)
                    {
                        logger.LogInformation("[MarkReportAsCompleteAsync] Found report {reportCode}, setting IsLocked = false", reportCode);
                        report.IsLocked = false;
                        await scopedContext.SaveChangesAsync();
                        
                        // Check if migration is ready to complete using the async version
                        await CompleteReportMigrationIfReadyAsync();
                    }
                    else
                    {
                        logger.LogWarning("[MarkReportAsCompleteAsync] Report {reportCode} not found", reportCode);
                    }
                }
                else
                {
                    logger.LogInformation("[MarkReportAsCompleteAsync] Report migration jobs still in progress, not marking report as complete yet");
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "[MarkReportAsCompleteAsync] Error marking report {reportCode} as complete", reportCode);
            }
        }

        /// <summary>
        /// Async version of CompleteReportMigrationIfReady that uses a separate scope to avoid DbContext conflicts.
        /// Checks if all reports are unlocked and completes the migration if ready.
        /// </summary>
        public async Task CompleteReportMigrationIfReadyAsync()
        {
            logger.LogInformation("[CompleteReportMigrationIfReadyAsync] Checking if report migration is ready to complete");
            
            try
            {
                // Use a separate scope to avoid any DbContext conflicts
                using var scope = _scopeFactory.CreateScope();
                var scopedContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                
                // Check if any reports are still locked
                var reportsPending = await scopedContext.Set<GenerateReport>()
                    .AnyAsync(x => x.IsLocked);
                
                logger.LogInformation("[CompleteReportMigrationIfReadyAsync] Reports still pending: {reportsPending}", reportsPending);
                
                if (!reportsPending)
                {
                    logger.LogInformation("[CompleteReportMigrationIfReadyAsync] No reports pending, completing migration with success");
                    await CompleteMigrationWithSeparateContextAsync("report", "success");
                }
                else
                {
                    logger.LogInformation("[CompleteReportMigrationIfReadyAsync] Reports still pending, migration not ready to complete");
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "[CompleteReportMigrationIfReadyAsync] Error checking if report migration is ready to complete");
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

        private async Task LogDataMigrationHistoryAsync(string dataMigrationTypeCode, string dataMigrationHistoryMessage, AppDbContext context)
        {
            Console.WriteLine(DateTime.Now + " - " + dataMigrationTypeCode + " - " + dataMigrationHistoryMessage);

            var dataMigrationType = await context.Set<DataMigrationType>()
                .FirstOrDefaultAsync(s => s.DataMigrationTypeCode == dataMigrationTypeCode);

            if (dataMigrationType != null)
            {
                var historyRecord = new DataMigrationHistory
                {
                    DataMigrationHistoryDate = DateTime.UtcNow,
                    DataMigrationTypeId = dataMigrationType.DataMigrationTypeId,
                    DataMigrationHistoryMessage = dataMigrationHistoryMessage
                };
                
                context.Set<DataMigrationHistory>().Add(historyRecord);
                await context.SaveChangesAsync();
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

        // public async Task ExecuteSqlBasedMigrationAsync(int iterationCount, IJobCancellationToken token)
        // {
        //     try
        //     {
        //         for (var i = 1; i <= iterationCount; i++)
        //         {
        //             await Task.Delay(1000);
        //             Console.WriteLine("Performing step {0} of {1}...", i, iterationCount);

        //             token.ThrowIfCancellationRequested();
        //         }
        //     }
        //     catch (OperationCanceledException)
        //     {
        //         Console.WriteLine("Cancellation requested, exiting...");
        //         throw;
        //     }
        // }

        // public async Task ExecuteSqlBasedMigrationAsync(string dataMigrationTypeCode, IJobCancellationToken token)
        // {
        //     try
        //     {
        //         // Start migration
        //         StartMigration(dataMigrationTypeCode, false);

        //         int? oldTimeOut = _context.Database.GetCommandTimeout();
        //         _context.Database.SetCommandTimeout(30000);

        //         var dbTask = _context.Database.ExecuteSqlRawAsync("app.Migrate_Data", this.source.Token);
        //         await dbTask;

        //         _context.Database.SetCommandTimeout(oldTimeOut);
        //     }
        //     catch (OperationCanceledException)
        //     {
        //         Console.WriteLine("Cancellation requested, exiting...");
        //         this.LogException(dataMigrationTypeCode, new OperationCanceledException());
        //         this.CompleteMigration(dataMigrationTypeCode, "error");
        //         throw;
        //     }
        //     catch (Exception ex)
        //     {
        //         this.LogException(dataMigrationTypeCode, ex);
        //         this.CompleteMigration(dataMigrationTypeCode, "error");
        //         throw;
        //     }
        // }

        public void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken)
        {
            logger.LogInformation($"Inside ExecuteSqlBasedMigration dataMigrationTypeCode:{dataMigrationTypeCode}");

            // using (var transactionMigration = _context.Database.BeginTransaction())
            // {
            //     logger.LogInformation("Starting migration");
            //     StartMigration(dataMigrationTypeCode, false);
            //     transactionMigration.Commit();
            // }
            logger.LogInformation("Starting migration");
            StartMigration(dataMigrationTypeCode, false);


            Task runningTask = null;
            bool jobCancelled = false;
            using (var scope = _scopeFactory.CreateScope())
            {
                var localDbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                var transactionMigration = localDbContext.Database.BeginTransaction();
                // }
                //using (var transactionMigration = _context.Database.BeginTransaction())
                //{
                int? oldTimeOut = -1;
                try
                {

                    oldTimeOut = localDbContext.Database.GetCommandTimeout();
                    localDbContext.Database.SetCommandTimeout(30000);
                    // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
                    // https://github.com/HangfireIO/Hangfire/issues/211

                    //var source = new CancellationTokenSource();

                    if (jobCancellationToken != null)
                    {
                        logger.LogInformation("Scheduling check for cancellation");
                        runningTask = Task.Run(() =>
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
                                jobCancelled = true;
                                logger.LogError(">>>Exception caught for ThrowIfCancellationRequested");
                                this.source.Cancel();
                            }
                        }, this.source.Token);
                    }
                    logger.LogInformation("Starting ExecuteSqlRawAsync for migrate");
                    var dbTask = localDbContext.Database.ExecuteSqlRawAsync("app.Migrate_Data", this.source.Token);
                    dbTask.Wait();
                    transactionMigration.Commit();


                }
                catch (Exception ex)
                {
                    logger.LogError($">>>Rollback tranction because of {ex}");
                    try
                    {
                        transactionMigration.Rollback();

                    }
                    catch (Exception te)
                    {
                        logger.LogError(">>>Error on rollback:{err}", te);
                    }
                    this.LogException(dataMigrationTypeCode, ex);

                    //throw;
                }
                finally
                {
                    try
                    {
                        if (runningTask != null)
                        {
                            logger.LogInformation("Disposing the runningTask");
                            runningTask.Wait();
                            runningTask.Dispose();
                        }
                    }
                    catch (Exception ex)
                    {
                        logger.LogError(">>>Error disposing task {ex}", ex);
                    }
                    if (oldTimeOut != -1)
                    {
                        localDbContext.Database.SetCommandTimeout(oldTimeOut);

                    }
                    
                    if (jobCancelled)
                    {
                        logger.LogInformation("Job cancelleation requested so completing jobs with error");
                        this.CompleteMigration(dataMigrationTypeCode, "error");
                    }

                }



            }

        }


        /// <summary>
        /// Executes the stored procedure <c>app.Migrate_Data</c> inside a transaction as a Hangfire background job.
        /// Supports user cancellation via <see cref="IJobCancellationToken"/>. When cancelled, the transaction is rolled back
        /// and the scoped <see cref="AppDbContext"/> is disposed. This method is fully async and intended to be scheduled via Hangfire like:
        /// <code>
        /// BackgroundJob.Enqueue<IAppRepository>(r => r.ExecuteSqlBasedMigrationJobAsync("report", JobCancellationToken.Null));
        /// </code>
        /// </summary>
        /// <param name="dataMigrationTypeCode">The migration type code (e.g. "report").</param>
        /// <param name="jobCancellationToken">Hangfire job cancellation token.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        public async Task ExecuteSqlBasedMigrationJobAsync(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken)
        {
            logger.LogInformation("[ExecuteSqlBasedMigrationJobAsync] Starting migration for {dataMigrationTypeCode}", dataMigrationTypeCode);

            // Create an isolated scope & DbContext for all operations to avoid DataReader conflicts
            using var scope = _scopeFactory.CreateScope();
            var localDbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
            
            // Mark migration as started using the scoped context to avoid connection conflicts
            await StartMigrationAsync(dataMigrationTypeCode, false, localDbContext);
            
            // Ensure we're not tracking any entities from previous operations
            localDbContext.ChangeTracker.Clear();

            int? originalTimeout = null;
            var procName = "app.Migrate_Data"; // Stored procedure name

            // Local CTS we control; will be cancelled when Hangfire signals cancellation
            using var cts = new CancellationTokenSource();
            Task monitoringTask = null;
            var cancelled = false;

            try
            {
                // Begin monitoring for Hangfire cancellation (Hangfire does not expose a raw token)
                if (jobCancellationToken != null)
                {
                    monitoringTask = Task.Run(async () =>
                    {
                        try
                        {
                            while (!cts.IsCancellationRequested)
                            {
                                await Task.Delay(1000, cts.Token).ConfigureAwait(false);
                                try
                                {
                                    jobCancellationToken.ThrowIfCancellationRequested();
                                }
                                catch (Exception)
                                {
                                    // Any exception thrown here indicates cancellation
                                    cancelled = true;
                                    cts.Cancel();
                                    logger.LogWarning("[ExecuteSqlBasedMigrationJobAsync] Cancellation requested by user.");
                                }
                            }
                        }
                        catch (OperationCanceledException) { /* expected when cts cancelled */ }
                    });
                }

                // Adjust timeout for long-running migration
                originalTimeout = localDbContext.Database.GetCommandTimeout();
                localDbContext.Database.SetCommandTimeout(30000); // 30k seconds (~8h+) just like existing method

                // Check if the stored procedure manages its own transactions
                // Many migration stored procedures handle their own transaction management
                logger.LogInformation("[ExecuteSqlBasedMigrationJobAsync] Executing stored proc {procName} without external transaction", procName);
                
                try
                {
                    // Execute stored procedure without wrapping in our own transaction
                    // This allows the stored procedure to manage its own transaction scope
                    await localDbContext.Database.ExecuteSqlRawAsync(procName, cts.Token).ConfigureAwait(false);
                    logger.LogInformation("[ExecuteSqlBasedMigrationJobAsync] Migration stored proc {procName} executed successfully.", procName);
                }
                catch (Exception execEx)
                {
                    logger.LogError(execEx, "[ExecuteSqlBasedMigrationJobAsync] Error executing stored procedure {procName}", procName);
                    throw; // Re-throw to be handled by outer catch blocks
                }

                // Check if cancelled after execution
                if (cancelled)
                {
                    logger.LogWarning("[ExecuteSqlBasedMigrationJobAsync] Migration was cancelled after execution - stored proc manages its own rollback.");
                }
            }
            catch (OperationCanceledException oce)
            {
                cancelled = true;
                logger.LogWarning(oce, "[ExecuteSqlBasedMigrationJobAsync] OperationCanceledException caught during migration.");
                LogException(dataMigrationTypeCode, oce);
                // Mark migration as error using a separate scope to avoid DataReader conflicts
                await CompleteMigrationWithSeparateContextAsync(dataMigrationTypeCode, "error");
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "[ExecuteSqlBasedMigrationJobAsync] Exception during migration execution.");
                LogException(dataMigrationTypeCode, ex);
                // Mark migration as error using a separate scope to avoid DataReader conflicts
                await CompleteMigrationWithSeparateContextAsync(dataMigrationTypeCode, "error");
            }
            finally
            {
                // Signal monitoring loop to stop
                if (!cts.IsCancellationRequested)
                {
                    cts.Cancel();
                }

                if (monitoringTask != null)
                {
                    try { await monitoringTask.ConfigureAwait(false); } catch { /* swallow */ }
                    monitoringTask.Dispose();
                }

                if (originalTimeout.HasValue)
                {
                    try 
                    { 
                        if (localDbContext != null && localDbContext.Database != null)
                        {
                            localDbContext.Database.SetCommandTimeout(originalTimeout); 
                        }
                    } 
                    catch (Exception ex) 
                    { 
                        logger.LogError(ex, "[ExecuteSqlBasedMigrationJobAsync] Error restoring timeout.");
                    }
                }

                // No transaction cleanup needed as stored proc manages its own transactions

                // Clear any tracked entities to prevent iteration issues
                try
                {
                    if (localDbContext != null)
                    {
                        localDbContext.ChangeTracker.Clear();
                    }
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "[ExecuteSqlBasedMigrationJobAsync] Error clearing change tracker.");
                }

                // If not cancelled and no error occurred, mark migration success
                // Use a new scope to avoid any DbContext issues with the completion call
                if (!cancelled)
                {
                    logger.LogInformation("[ExecuteSqlBasedMigrationJobAsync] Completing migration with success status.");
                    await CompleteMigrationWithSeparateContextAsync(dataMigrationTypeCode, "success");
                }

                logger.LogInformation("[ExecuteSqlBasedMigrationJobAsync] Finishing job cleanup.");
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
            Console.WriteLine("Inside GetReports");   
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

            Console.WriteLine($"Returning results {results}");
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
            logger.LogInformation($"Inside MarkReportAsComplete for reportCode:{reportCode} as complete.");
            // Verify that all pending jobs have completed first

            var api = JobStorage.Current.GetMonitoringApi();
            var reportMigrationJobs = api.ProcessingJobs(0, (int)api.ProcessingCount()).Where(x => x.Value.InProcessingState && x.Value.Job.Method.Name == "ExecuteReportMigrationByYearLevelAndCategorySet");
            logger.LogInformation($"Any reportMigrationJobs:{reportMigrationJobs}");
            if (!reportMigrationJobs.Any())
            {
                logger.LogInformation("Ther are reporting jobs trying to change to unlocked");
                GenerateReport report = _context.Set<GenerateReport>().Where(x => x.ReportCode == reportCode).FirstOrDefault();
                logger.LogInformation($"Found report to be unlocked:{report}");
                if (report != null)
                {
                    report.IsLocked = false;
                    _context.SaveChanges();
                }

                this.CompleteReportMigrationIfReady();

            }
            else
            {
                logger.LogInformation("Ther are no reportin jobs inprocessed");
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
