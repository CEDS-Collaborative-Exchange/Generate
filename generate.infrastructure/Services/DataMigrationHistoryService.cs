using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class DataMigrationHistoryService : IDataMigrationHistoryService
    {
        private readonly IAppRepository _appRepository;


        public DataMigrationHistoryService(
            IAppRepository appRepository
            )
        {
            _appRepository = appRepository;
        }


        public void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true)
        {
            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, dataMigrationHistoryMessage, logToDatabase);
        }
        

    }
}
