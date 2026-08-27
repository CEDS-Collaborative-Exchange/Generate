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
using Microsoft.EntityFrameworkCore;

namespace generate.infrastructure.Services
{
    public class DataMigrationHistoryService : IDataMigrationHistoryService
    {
        private readonly AppDbContext _context;

        public DataMigrationHistoryService(
            AppDbContext context
            )
        {
            _context = context;
        }

        public void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true)
        {
            Console.WriteLine(DateTime.Now + " - " + dataMigrationTypeCode + " - " + dataMigrationHistoryMessage);

            if (logToDatabase)
            {
                DataMigrationType dataMigrationType = _context.Set<DataMigrationType>().FirstOrDefault(s => s.DataMigrationTypeCode == dataMigrationTypeCode);

                if (dataMigrationType != null)
                {
                    DataMigrationHistory historyRecord = new DataMigrationHistory();
                    historyRecord.DataMigrationHistoryDate = DateTime.UtcNow;
                    historyRecord.DataMigrationTypeId = dataMigrationType.DataMigrationTypeId;
                    historyRecord.DataMigrationHistoryMessage = dataMigrationHistoryMessage;
                    _context.Add(historyRecord);
                    _context.SaveChanges();
                }
            }
        }

        public IEnumerable<DataMigrationHistory> GetMigrationHistory(string dataMigrationTypeCode, int skip = 0, int take = 1000)
        {
            DbSet<DataMigrationHistory> set = _context.Set<DataMigrationHistory>();
            IQueryable<DataMigrationHistory> results = set.AsQueryable();

            results = results.Include(r => r.DataMigrationType);

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
    }
}
