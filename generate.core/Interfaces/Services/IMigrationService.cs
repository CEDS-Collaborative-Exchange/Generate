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

    }
}
