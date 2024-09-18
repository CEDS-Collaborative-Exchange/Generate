using Hangfire;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface ITestDataInitializer
    {
        void PopulateOdsTestData(IJobCancellationToken jobCancellationToken);
        void PopulateStagingTestData(IJobCancellationToken jobCancellationToken, int? schoolYear);
        void ExecuteTestData(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken, string appPath);
    }
}
