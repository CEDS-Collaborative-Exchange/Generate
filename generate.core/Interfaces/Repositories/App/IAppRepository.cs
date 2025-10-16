using System.Collections.Generic;
using generate.core.Models.App;
using System.Linq.Expressions;
using System;
using Microsoft.EntityFrameworkCore;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Linq;
using System.Threading;
using Hangfire;

namespace generate.core.Interfaces.Repositories.App
{
    public interface IAppRepository
    {
        // Helpers
        string GetPrimaryKey<T>(T entity) where T : class;
        string GetConnectionString();

        // Create
        T Create<T>(T entity) where T : class;
        IEnumerable<T> CreateRange<T>(IEnumerable<T> entities) where T : class;
        IEnumerable<T> CreateRangeSave<T>(IEnumerable<T> entities) where T : class;

        // Read
        IEnumerable<T> GetAllReadOnly<T>(int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad) where T : class;
        IEnumerable<T> GetAll<T>(int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad) where T : class;
        IEnumerable<T> FindReadOnly<T>(Expression<Func<T, bool>> criteria, int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad) where T : class;
        IEnumerable<T> Find<T>(Expression<Func<T, bool>> criteria, int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad) where T : class;
        int Count<T>(Expression<Func<T, bool>> criteria) where T : class;
        T GetById<T>(int id) where T : class;
        bool Any<T>(params Expression<Func<T, object>>[] eagerLoad) where T : class;
        bool Any<T>(Expression<Func<T, bool>> criteria, params Expression<Func<T, object>>[] eagerLoad) where T : class;

        // Update
        void Update<T>(T entity) where T : class;
        void UpdateRange<T>(IEnumerable<T> entities) where T : class;
        void UpdateRangeSave<T>(IEnumerable<T> entities) where T : class;

        // Delete
        void Delete<T>(int id) where T : class;
        void DeleteRange<T>(IEnumerable<T> entities) where T : class;


        // Save
        int Save();
        void SaveAsync();

        // Execute
        void ExecuteSql(string sql, params object[] parameters);




        // Extended Methods
        void StartMigration(string dataMigrationTypeCode, bool setToProcessing = false);
        void CompleteMigration(string dataMigrationTypeCode, string dataMigrationStatusCode);
        void LogException(string dataMigrationTypeCode, Exception ex);
        void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true);
        IEnumerable<DataMigrationHistory> GetMigrationHistory(string dataMigrationTypeCode, int skip = 0, int take = 1000);
        void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken);

        Task ExecuteSqlBasedMigrationJobAsync(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken);
        
        IEnumerable<GenerateReport> GetReports(string reportTypeCode, int skip = 0, int take = 50);
        IEnumerable<GenerateReport> GetReports(int skip = 0, int take = 50);
        IQueryable<CategorySet> GetCategorySets(string reportCode, string reportYear, string reportLevel);
        void MarkReportAsComplete(string reportCode);
        void MarkReportsAsComplete();
        void UpdateViewDefinitions();

        void CompleteReportMigrationIfReady();
    }
}