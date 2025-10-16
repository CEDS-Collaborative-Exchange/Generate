using generate.core.Config;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.infrastructure.Services;
using Hangfire;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;

namespace generate.infrastructure.Helpers
{
    public class HangfireHelper : IHangfireHelper
    {

        private readonly IFSMetadataUpdateService _fsMetadataUpdateService;
        private readonly ILogger log;
        public HangfireHelper(
            IFSMetadataUpdateService fsMetadataUpdateService,ILogger<HangfireHelper> iLogger
        )
        {
            log = iLogger;
            _fsMetadataUpdateService = fsMetadataUpdateService ?? throw new ArgumentNullException(nameof(fsMetadataUpdateService));
        }

        public void CancelMigration(string dataMigrationTypeCode)
        {
            BackgroundJob.Enqueue<IAppRepository>(x =>
                x.CompleteMigration(dataMigrationTypeCode, "error")
            );            
        }

        public void TriggerOdsTestData()
        {

            BackgroundJob.Enqueue<IMigrationService>(x =>
                    x.CreateOdsTestData(JobCancellationToken.Null)
                );
        }

        public string TriggerStagingTestData(int? schoolYear)
        {
            return BackgroundJob.Enqueue<IMigrationService>(x =>
                    x.CreateStagingTestData(JobCancellationToken.Null, schoolYear)
                );
        }

        public void TriggerSqlBasedMigration(string dataMigrationTypeCode, string parentJobId)
        {
            // SQL Based Migration - State ODS migration and legacy RDS/Report migration
            if(string.IsNullOrEmpty(parentJobId))
            {
                log.LogInformation($"TriggerSqlBasedMigration enque for dataMigrationTypeCode:{dataMigrationTypeCode},parentJobId:{dataMigrationTypeCode} ");
                BackgroundJob.Enqueue<IAppRepository>(x =>
                    x.ExecuteSqlBasedMigrationJobAsync(dataMigrationTypeCode, JobCancellationToken.Null)
                );
                log.LogInformation("Coming back after queuing");

            }
            else
            {
                BackgroundJob.ContinueJobWith<IAppRepository>(parentJobId, x =>
                    x.ExecuteSqlBasedMigrationJobAsync(dataMigrationTypeCode, JobCancellationToken.Null)
                );
            }
        }

        public void TriggerReportMigrationByYearLevelAndCategorySet(string reportCode, string reportYear, string reportLevel, string categorySetCode)
        {
            var migrationJobId = BackgroundJob.Enqueue<IFactReportRepository>(x =>
                x.ExecuteReportMigrationByYearLevelAndCategorySet(reportCode, reportYear, reportLevel, categorySetCode, null, null)
               );

            BackgroundJob.ContinueJobWith<IAppRepository>(migrationJobId, x => x.MarkReportAsComplete(reportCode));

        }

        public void TriggerRdsMigrationByYear(string taskName, string reportYear)
        {
            switch (taskName)
            {
                case "StudentCount - Submission":
                    BackgroundJob.Enqueue<IFactStudentCountRepository>(x =>
                        x.Migrate_FactStudentCounts(reportYear, "submission")
                       );

                    break;

                case "StudentCount - CTE":
                    BackgroundJob.Enqueue<IFactStudentCountRepository>(x =>
                        x.Migrate_FactStudentCounts(reportYear, "cte")
                       );

                    break;


                default:
                    break;
            }

        }

        public void TriggerSiteUpdate(string sourcePath, string destinationPath)
        {
            BackgroundJob.Enqueue<IAppUpdateService>(x =>
                x.ExecuteSiteUpdate(sourcePath, destinationPath)
            );
        }

        public void StartFSRecurringJobs(bool _useWSforFSMetaUpd, string _fsWSURL, string _fsMetaFileLoc, string _fsMetaESSDetailFileName, string _fsMetaCHRDetailFileName, string _fsMetaESSLayoutFileName, string _fsMetaCHRLayoutFileName, string _bkfsMetaFileLoc, bool _reloadFromBackUp, string cronExpr)
        {
            
            TimeZoneInfo est = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
            RecurringJob.AddOrUpdate("FSmetaServc", () => fsMetaRefresh(_useWSforFSMetaUpd, _fsWSURL, _fsMetaFileLoc, _fsMetaESSDetailFileName, _fsMetaCHRDetailFileName, _fsMetaESSLayoutFileName, _fsMetaCHRLayoutFileName, _bkfsMetaFileLoc, _reloadFromBackUp), cronExpr, est);

            //var currentTZ = TimeZoneInfo.Local;            
            //var c = Cron.Daily(23, 50);
            //RecurringJob.AddOrUpdate("FSmetaServc", () => fsMetaRefresh(_useWSforFSMetaUpd, _fsWSURL, _fsMetaFileLoc, _fsMetaESSDetailFileName, _fsMetaCHRDetailFileName, _fsMetaESSLayoutFileName, _fsMetaCHRLayoutFileName), Cron.Daily(23, 50)) ;            
            //RecurringJob.AddOrUpdate("FSmetaServc", () => fsMetaRefresh(_useWSforFSMetaUpd, _fsWSURL, _fsMetaFileLoc, _fsMetaESSDetailFileName, _fsMetaCHRDetailFileName, _fsMetaESSLayoutFileName, _fsMetaCHRLayoutFileName), "*/3 * * * *", est);

        }

        public void fsMetaRefresh(bool _useWSforFSMetaUpd, string _fsWSURL, string _fsMetaFileLoc, string _fsMetaESSDetailFileName, string _fsMetaCHRDetailFileName, string _fsMetaESSLayoutFileName, string _fsMetaCHRLayoutFileName, string _bkfsMetaFileLoc, bool _reloadFromBackUp)
        {

            _fsMetadataUpdateService.useWSforFSMetaUpd = _useWSforFSMetaUpd;
            _fsMetadataUpdateService.fsWSURL = _fsWSURL;
            _fsMetadataUpdateService.fsMetaFileLoc = _fsMetaFileLoc;
            _fsMetadataUpdateService.fsMetaESSDetailFileName = _fsMetaESSDetailFileName;
            _fsMetadataUpdateService.fsMetaCHRDetailFileName = _fsMetaCHRDetailFileName;
            _fsMetadataUpdateService.fsMetaESSLayoutFileName = _fsMetaESSLayoutFileName;
            _fsMetadataUpdateService.fsMetaCHRLayoutFileName = _fsMetaCHRLayoutFileName;
            _fsMetadataUpdateService.reloadFromBackUp = _reloadFromBackUp;
            _fsMetadataUpdateService.bkfsMetaFileLoc = _bkfsMetaFileLoc;

            _fsMetadataUpdateService.callInitFSmetaServc();

        }

    }
}
