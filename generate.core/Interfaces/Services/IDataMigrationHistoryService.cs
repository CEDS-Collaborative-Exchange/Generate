using System.Collections.Generic;
using generate.core.Models.App;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface IDataMigrationHistoryService
    {
        void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true);
        
    }
}