using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface IDataMigrationHistoryService
    {
        void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true);
        IEnumerable<DataMigrationHistory> GetMigrationHistory(string dataMigrationTypeCode, int skip = 0, int take = 1000);
    }
}