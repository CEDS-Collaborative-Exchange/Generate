using Hangfire;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface IMigrationService
    {
        void CancelMigration(string dataMigrationTypeCode);
        void MigrateData(string dataMigrationTypeCode);
        void CreateOdsTestData(IJobCancellationToken jobCancellationToken);
        void CreateStagingTestData(IJobCancellationToken jobCancellationToken, int? schoolYear);
        void CreateReportByYear(string reportCode, string reportYear);
        void ExecuteRdsTaskByYear(string taskName, string reportYear);

        // Migration lifecycle and report-locking (moved from IAppRepository's "Extended Methods")
        void StartMigration(string dataMigrationTypeCode, bool setToProcessing = false);
        void CompleteMigration(string dataMigrationTypeCode, string dataMigrationStatusCode);
        void LogException(string dataMigrationTypeCode, Exception ex);
        void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken);
        void MarkReportAsComplete(string reportCode);
        void MarkReportsAsComplete();
        void CompleteReportMigrationIfReady();
        void toggleReportLock(string factTypeCode, string reportCode, bool isLocked);
    }
}
