using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using System.Threading;
using Microsoft.Extensions.Options;
using generate.core.Config;
//using Microsoft.Extensions..Hosting;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class DataMigrationService : IDataMigrationService
    {
        private IOptions<AppSettings> _appSettings;

        private readonly IAppRepository _appRepository;

        private IDataMigrationHistoryService _dataMigrationHistoryService;
        private IRDSDataMigrationService _rdsDataMigrationService;

        public DataMigrationService(
            IOptions<AppSettings> appSettings,
            IAppRepository appRepository,
            IDataMigrationHistoryService dataMigrationHistoryService,
            IRDSDataMigrationService rdsDataMigrationService
            )
        {
            _appSettings = appSettings;
            _appRepository = appRepository;
            _dataMigrationHistoryService = dataMigrationHistoryService;
            _rdsDataMigrationService = rdsDataMigrationService;
        }
               
        public CurrentMigrationStatus CurrentMigrationStatus()
        {

            CurrentMigrationStatus viewModel = new CurrentMigrationStatus();

            List<DataMigrationType> migrationTypes = _appRepository.GetAll<DataMigrationType>(0, 0).ToList();
            int reportMigrationTypeId = migrationTypes.Where(m => m.DataMigrationTypeCode == "report").Select(m => m.DataMigrationTypeId).FirstOrDefault();
            int rdsMigrationTypeId = migrationTypes.Where(m => m.DataMigrationTypeCode == "rds").Select(m => m.DataMigrationTypeId).FirstOrDefault();

            // Get all migrations
            DataMigration migration = _appRepository.GetAll<DataMigration>(0, 0, m => m.DataMigrationStatus)
                                                           .Where(t => t.DataMigrationTypeId == reportMigrationTypeId).ToList()[0];

            viewModel.ReportMigrationStatusCode = migration.DataMigrationStatus.DataMigrationStatusCode;
            viewModel.ReportLastMigrationTriggerDate = migration.LastTriggerDate;
            viewModel.ReportLastMigrationDurationInSeconds = migration.LastDurationInSeconds;
            viewModel.UserName = migration.UserName;

           
            // Get last history messages

            IEnumerable<DataMigrationHistory> reportHistory = _appRepository
              .Find<DataMigrationHistory>(s => s.DataMigrationTypeId == reportMigrationTypeId || s.DataMigrationTypeId == rdsMigrationTypeId, 0, 0);

            if (viewModel.ReportLastMigrationTriggerDate != null)
            {
                reportHistory = reportHistory.Where(s => s.DataMigrationHistoryDate >= viewModel.ReportLastMigrationTriggerDate);
            }

            if (reportHistory.Any())
            {
                DataMigrationHistory reportLastHistory = reportHistory.OrderBy(a => a.DataMigrationHistoryDate).LastOrDefault();
                if (reportLastHistory != null)
                {
                    viewModel.ReportLastMigrationHistoryMessage = reportLastHistory.DataMigrationHistoryMessage;
                    viewModel.ReportLastMigrationHistoryDate = reportLastHistory.DataMigrationHistoryDate;
                }
            }

            return viewModel;
        }


    }
}
