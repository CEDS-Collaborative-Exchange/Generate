using System;
using System.Linq;
using System.Collections.Generic;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Threading.Tasks;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using System.Threading;
using Hangfire;


namespace generate.infrastructure.Repositories.App
{

    public class AppRepository : RepositoryBase, IAppRepository, IDisposable
    {
        private CancellationTokenSource source;
        private readonly IServiceProvider _serviceProvider;

        // rdsRepository is no longer used inside AppRepository (its former consumer, toggleReportLock,
        // moved to IMigrationService) but stays as a constructor parameter for compatibility with existing
        // callers/tests that construct AppRepository directly.
        public AppRepository(AppDbContext context, IRDSRepository rdsRepository, IServiceProvider serviceProvider = null)
            : base(context)
        {
            this.source = new CancellationTokenSource();
            _serviceProvider = serviceProvider;
        }

        public void Dispose()
        {
            source?.Cancel();
            source?.Dispose();
            source = null;
            GC.SuppressFinalize(this);
        }

        // These three methods stay on IAppRepository only because Hangfire serializes a reference to this
        // interface and the method signature into its persistent job store (see HangfireHelper.cs). An
        // already-enqueued job needs the method to still resolve here. The real logic lives in
        // IMigrationService/MigrationService — resolved lazily (not via constructor injection) because
        // MigrationService itself depends on IAppRepository, and constructor-injecting it here would be
        // a circular dependency.
        public void CompleteMigration(string dataMigrationTypeCode, string dataMigrationStatusCode)
        {
            ResolveMigrationService().CompleteMigration(dataMigrationTypeCode, dataMigrationStatusCode);
        }

        public void ExecuteSqlBasedMigration(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken)
        {
            ResolveMigrationService().ExecuteSqlBasedMigration(dataMigrationTypeCode, jobCancellationToken);
        }

        public void MarkReportAsComplete(string reportCode)
        {
            ResolveMigrationService().MarkReportAsComplete(reportCode);
        }

        private IMigrationService ResolveMigrationService()
        {
            if (_serviceProvider == null)
            {
                throw new InvalidOperationException($"{nameof(AppRepository)} was constructed without an {nameof(IServiceProvider)}, so it cannot resolve {nameof(IMigrationService)} to fulfill this call.");
            }

            return (IMigrationService)_serviceProvider.GetService(typeof(IMigrationService))
                ?? throw new InvalidOperationException($"{nameof(IMigrationService)} is not registered in this application's service collection.");
        }


        public IEnumerable<GenerateReport> GetReports(string reportTypeCode, int skip = 0, int take = 50)
        {

            DbSet<GenerateReport> set = _context.Set<GenerateReport>();
            IQueryable<GenerateReport> results = set.AsQueryable();

            results = results.Include(r => r.GenerateReportControlType);
            results = results.Include(r => r.GenerateReport_FactTypes);
            results = results.Include(r => r.GenerateReport_OrganizationLevels)
                .ThenInclude((GenerateReport_OrganizationLevel p) => p.OrganizationLevel);
            results = results.Include(r => r.GenerateReportFilterOptions);
            results = results.Include(r => r.CedsConnection);
            results = results.Include(r => r.CategorySets)
                .ThenInclude((CategorySet p) => p.CategorySet_Categories)
                .ThenInclude((CategorySet_Category cs) => cs.Category);


            if (reportTypeCode != null)
            {
                results = results.Where(r => r.GenerateReportType.ReportTypeCode == reportTypeCode);
            }

            results = results.OrderBy(r => r.ReportSequence != null ? r.ReportSequence.ToString() : r.ReportShortName);

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

        public IEnumerable<GenerateReport> GetReports(int skip = 0, int take = 50)
        {

            DbSet<GenerateReport> set = _context.Set<GenerateReport>();
            IQueryable<GenerateReport> results = set.AsQueryable();

            results = results.Include(r => r.GenerateReport_FactTypes);

            results = results.Where(r => r.IsActive);
            results = results.OrderBy(r => r.ReportCode);

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

        public IQueryable<CategorySet> GetCategorySets(string reportCode, string reportYear, string reportLevel)
        {
            IQueryable<CategorySet> categorySets = _context.Set<CategorySet>()
            .Include(x => x.TableType)
            .Include(x => x.OrganizationLevel)
            .Where(x =>
                x.GenerateReport.ReportCode == reportCode &&
                x.SubmissionYear == reportYear                
            );
            
            if (reportLevel != null)
            {
                categorySets = categorySets.Where(x => x.OrganizationLevel.LevelCode == reportLevel);
            }

            return categorySets;
        }

    }
}
