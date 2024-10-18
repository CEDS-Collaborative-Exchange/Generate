using generate.core.Config;
using generate.core.Models.App;
using generate.core.Models.IDS;
using generate.core.Interfaces.Services;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Interfaces.Repositories.IDS;
using generate.core.Interfaces.Repositories.App;
using generate.infrastructure.Contexts;
using System.IO.Abstractions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.EntityFrameworkCore;
using Hangfire;
using System.Threading;
using System.IO;

namespace generate.testdata
{
    public class TestDataInitializer : ITestDataInitializer
    {

        private IIdsTestDataGenerator _odsTestDataGenerator;
        private IStagingTestDataGenerator _stagingTestDataGenerator;
        private IAppRepository _appRepository;
        private IFileSystem _fileSystem;
        private ILoggerFactory _loggerFactory;
        private IOptions<DataSettings> _dataSettings;
        private IOptions<AppSettings> _appSettings;

        public TestDataInitializer(
            IIdsTestDataGenerator odsTestDataGenerator,
            IStagingTestDataGenerator stagingTestDataGenerator,
            IAppRepository appRepository,
            IFileSystem fileSystem,
            ILoggerFactory loggerFactory,
            IOptions<DataSettings> dataSettings,
            IOptions<AppSettings> appSettings
            )
        {
            _odsTestDataGenerator = odsTestDataGenerator;
            _stagingTestDataGenerator = stagingTestDataGenerator;
            _appRepository = appRepository;
            _fileSystem = fileSystem;
            _loggerFactory = loggerFactory;
            _dataSettings = dataSettings;
            _appSettings = appSettings;

        }

        public void PopulateOdsTestData(IJobCancellationToken jobCancellationToken)
        {
            _appRepository.LogDataMigrationHistory("ods", "Create Test Data - Start", true);

            // Get Configuration Settings
            ////////////////////////////////////

            List<GenerateConfiguration> generateConfigurations = _appRepository.FindReadOnly<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

            int studentCount = 100000;
            int.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "StudentCount").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out studentCount);

            int schoolYear = DateTime.Now.Year;
            int.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SchoolYear").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out schoolYear);

            int seed = 1000;
            int.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "Seed").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out seed);


            // Populate test data
            ////////////////////////////////////

            _appRepository.LogDataMigrationHistory("ods", "Creating data for " + studentCount + " students", true);

            var webAppPath = _appSettings.Value.WebAppPath;

            _appRepository.LogDataMigrationHistory("ods", "File Path = " + webAppPath + " / env = " + _appSettings.Value.Environment, true);

            _odsTestDataGenerator.GenerateTestData(seed, studentCount, schoolYear, "sql", "file", webAppPath);

            _appRepository.LogDataMigrationHistory("ods", "Create Test Data - End", true);
            
            this.ExecuteTestData("ods", jobCancellationToken, webAppPath);

        }

        public void PopulateStagingTestData(IJobCancellationToken jobCancellationToken, int? schoolYear)
        {
            _appRepository.LogDataMigrationHistory("staging", "Create Test Data - Start", true);

            // Get Configuration Settings
            ////////////////////////////////////

            List<GenerateConfiguration> generateConfigurations = _appRepository.FindReadOnly<GenerateConfiguration>(c => c.GenerateConfigurationCategory == "TestData", 0, 0).ToList();

            int studentCount = 100000;
            int.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "StudentCount").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out studentCount);

            if (!schoolYear.HasValue)
            {
                schoolYear = Convert.ToInt32(generateConfigurations.Where(c => c.GenerateConfigurationKey == "SchoolYear").Select(c => c.GenerateConfigurationValue).FirstOrDefault());
            }

            int seed = 1000;
            int.TryParse(generateConfigurations.Where(c => c.GenerateConfigurationKey == "Seed").Select(c => c.GenerateConfigurationValue).FirstOrDefault(), out seed);


            // Populate test data
            ////////////////////////////////////

            _appRepository.LogDataMigrationHistory("staging", "Creating data for " + studentCount + " students", true);

            var webAppPath = _appSettings.Value.WebAppPath;

            _appRepository.LogDataMigrationHistory("staging", "File Path = " + webAppPath + " / env = " + _appSettings.Value.Environment, true);

            _stagingTestDataGenerator.GenerateTestData(seed, studentCount, schoolYear.Value, 1, "sql", "file", "ceds", webAppPath, this);

            _appRepository.LogDataMigrationHistory("staging", "Create Test Data - End", true);
        }

        public void ExecuteTestData(string dataMigrationTypeCode, IJobCancellationToken jobCancellationToken, string appPath)
        {
            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "Execute Test Data - Start", true);

            int numberOfParallelTasks = 4;

            var properDataMigrationTypeCode = dataMigrationTypeCode.Substring(0, 1).ToUpper() + dataMigrationTypeCode.Substring(1);


            // Establish app contexts

            var appConnectionString = _dataSettings.Value.AppDbContextConnection;
            var appContextLogger = _loggerFactory.CreateLogger<AppDbContext>();

            DbContextOptions<AppDbContext> appDbOptions = new DbContextOptionsBuilder<AppDbContext>()
                .UseSqlServer(appConnectionString)
                .Options;

            AppDbContext[] appContexts = new AppDbContext[numberOfParallelTasks];
            for (int i = 0; i < numberOfParallelTasks; i++)
            {
                appContexts[i] = new AppDbContext(appDbOptions, appContextLogger, _appSettings);
            }

            IDSDbContext[] odsContexts = new IDSDbContext[numberOfParallelTasks];
            StagingDbContext[] stagingContexts = new StagingDbContext[numberOfParallelTasks];
            RDSDbContext[] rdsContexts = new RDSDbContext[numberOfParallelTasks];


            if (dataMigrationTypeCode == "ods")
            {

                // Establish ods contexts

                var odsConnectionString = _dataSettings.Value.ODSDbContextConnection;
                var odsContextLogger = _loggerFactory.CreateLogger<IDSDbContext>();

                DbContextOptions<IDSDbContext> odsDbOptions = new DbContextOptionsBuilder<IDSDbContext>()
                    .UseSqlServer(odsConnectionString)
                    .Options;

                for (int i = 0; i < numberOfParallelTasks; i++)
                {
                    odsContexts[i] = new IDSDbContext(odsDbOptions, odsContextLogger, _appSettings);
                }


            }
            else if (dataMigrationTypeCode == "staging")
            {

                // Establish ods contexts

                var stagingConnectionString = _dataSettings.Value.StagingDbContextConnection;

                DbContextOptions<StagingDbContext> stagingDbOptions = new DbContextOptionsBuilder<StagingDbContext>()
                    .UseSqlServer(stagingConnectionString)
                    .Options;

                for (int i = 0; i < numberOfParallelTasks; i++)
                {
                    stagingContexts[i] = new StagingDbContext(stagingDbOptions);
                }


            }
            //else if (dataMigrationTypeCode == "rds")
            //{
            //    // Establish rds contexts

            //    var rdsConnectionString = _dataSettings.Value.RDSDbContextConnection;
            //    var rdsContextLogger = _loggerFactory.CreateLogger<RDSDbContext>();

            //    DbContextOptions<RDSDbContext> rdsDbOptions = new DbContextOptionsBuilder<RDSDbContext>()
            //        .UseSqlServer(rdsConnectionString)
            //        .Options;

            //    for (int i = 0; i < numberOfParallelTasks; i++)
            //    {
            //        rdsContexts[i] = new RDSDbContext(rdsDbOptions, rdsContextLogger, _appSettings);
            //    }

            //}



            // Get scripts

            var allScripts = _fileSystem.Directory.GetFiles(appPath, "*.sql", System.IO.SearchOption.TopDirectoryOnly).OrderBy(x => x).ToList();
            var subsequentScripts = allScripts;

            if (dataMigrationTypeCode == "ods")
            {
                subsequentScripts = _fileSystem.Directory.GetFiles(appPath, "*_Persons.sql", System.IO.SearchOption.TopDirectoryOnly).OrderBy(x => x).ToList();
            }
            else if (dataMigrationTypeCode == "rds")
            {
                subsequentScripts = _fileSystem.Directory.GetFiles(appPath, "*_FactTables.sql", System.IO.SearchOption.TopDirectoryOnly).OrderBy(x => x).ToList();
            }

            var initialScripts = allScripts.Except(subsequentScripts).OrderBy(x => x).ToList();


            // Execute initial scripts

            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "SQL Script Path = " + appPath, true);
            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "Initial Scripts (" + initialScripts.Count + " files)", true);

            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

            foreach (var sqlScriptFile in initialScripts)
            {

                if (dataMigrationTypeCode == "ods")
                {
                    ExecuteIdsScript(jobCancellationToken, sqlScriptFile, _fileSystem, odsContexts[0], appContexts[0]);
                }
                //else if (dataMigrationTypeCode == "rds")
                //{
                //    ExecuteRdsScript(jobCancellationToken, sqlScriptFile, _fileSystem, rdsContexts[0], appContexts[0]);
                //}
            }

            // Execute subsequent scripts

            int numberOfBatches = (int)Math.Ceiling((decimal)subsequentScripts.Count / (decimal)numberOfParallelTasks);

            if (subsequentScripts.Count / numberOfParallelTasks < 1)
            {
                numberOfParallelTasks = 1;
            }

            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "Subsequent Scripts (" + subsequentScripts.Count + " files / " + numberOfBatches + " batches / " + numberOfParallelTasks + " parallel tasks)", true);

            int scriptsRemaining = subsequentScripts.Count;
            int scriptsProcessed = 0;

            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

            for (int batchNumber = 0; batchNumber < numberOfBatches; batchNumber++)
            {
                if (jobCancellationToken != null)
                {
                    jobCancellationToken.ThrowIfCancellationRequested();
                }

                if (scriptsRemaining < numberOfParallelTasks)
                {
                    numberOfParallelTasks = scriptsRemaining;
                }

                Task[] taskArray = new Task[numberOfParallelTasks];

                for (int taskNumber = 0; taskNumber < taskArray.Length; taskNumber++)
                {
                    var sqlScriptFile = subsequentScripts[scriptsProcessed + taskNumber];
                    var appContext = appContexts[taskNumber];

                    if (dataMigrationTypeCode == "ods")
                    {
                        var odsContext = odsContexts[taskNumber];
                        taskArray[taskNumber] = Task.Factory.StartNew(() =>
                           ExecuteIdsScript(jobCancellationToken, sqlScriptFile, _fileSystem, odsContext, appContext)
                        );

                    }
                    else if (dataMigrationTypeCode == "staging")
                    {
                        var stagingContext = stagingContexts[taskNumber];
                        taskArray[taskNumber] = Task.Factory.StartNew(() =>
                           ExecuteStagingScript(jobCancellationToken, sqlScriptFile, _fileSystem, stagingContext, appContext)
                        );
                    }
                    //else if (dataMigrationTypeCode == "rds")
                    //{
                    //    var rdsContext = rdsContexts[taskNumber];
                    //    taskArray[taskNumber] = Task.Factory.StartNew(() =>
                    //       ExecuteRdsScript(jobCancellationToken, sqlScriptFile, _fileSystem, rdsContext, appContext)
                    //    );

                    //}

                }

                Task.WaitAll(taskArray);

                scriptsRemaining -= numberOfParallelTasks;
                scriptsProcessed += numberOfParallelTasks;

                if (jobCancellationToken != null)
                {
                    jobCancellationToken.ThrowIfCancellationRequested();
                }

            }

            // Delete
            foreach (var sqlScriptFile in allScripts)
            {
                _fileSystem.File.Delete(sqlScriptFile);
            }

            _fileSystem.File.Delete(properDataMigrationTypeCode + "TestData.ps1");

            _appRepository.LogDataMigrationHistory(dataMigrationTypeCode, "Execute Test Data - End", true);

        }


        private void ExecuteIdsScript(IJobCancellationToken jobCancellationToken, string sqlScriptFile, IFileSystem fileSystem, IDSDbContext odsContext, AppDbContext appContext)
        {
            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

            LogDataMigrationHistory(appContext, "ods", "Executing " + sqlScriptFile);
            var testDataScript = fileSystem.File.ReadAllText(sqlScriptFile);

            int? oldTimeOut = odsContext.Database.GetCommandTimeout();
            odsContext.Database.SetCommandTimeout(11000);

            // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
            // https://github.com/HangfireIO/Hangfire/issues/211

            var source = new CancellationTokenSource();
            if (jobCancellationToken != null)
            {
                Task.Run(() =>
                {
                    try
                    {
                        while (true)
                        {
                            Thread.Sleep(1000);
                            jobCancellationToken.ThrowIfCancellationRequested();
                        }
                    }
                    catch (Exception)
                    {
                        source.Cancel();
                    }
                }, source.Token);
            }

            var dbTask = odsContext.Database.ExecuteSqlRawAsync(testDataScript, source.Token);
            dbTask.Wait();

            odsContext.Database.SetCommandTimeout(oldTimeOut);

            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

        }

        private void ExecuteStagingScript(IJobCancellationToken jobCancellationToken, string sqlScriptFile, IFileSystem fileSystem, StagingDbContext odsContext, AppDbContext appContext)
        {
            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

            LogDataMigrationHistory(appContext, "staging", "Executing " + sqlScriptFile);
            var testDataScript = fileSystem.File.ReadAllText(sqlScriptFile);

            int? oldTimeOut = odsContext.Database.GetCommandTimeout();
            odsContext.Database.SetCommandTimeout(11000);

            // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
            // https://github.com/HangfireIO/Hangfire/issues/211

            var source = new CancellationTokenSource();
            if (jobCancellationToken != null)
            {
                Task.Run(() =>
                {
                    try
                    {
                        while (true)
                        {
                            Thread.Sleep(1000);
                            jobCancellationToken.ThrowIfCancellationRequested();
                        }
                    }
                    catch (Exception)
                    {
                        source.Cancel();
                    }
                }, source.Token);
            }

            var dbTask = odsContext.Database.ExecuteSqlRawAsync(testDataScript, source.Token);
            dbTask.Wait();

            odsContext.Database.SetCommandTimeout(oldTimeOut);

            if (jobCancellationToken != null)
            {
                jobCancellationToken.ThrowIfCancellationRequested();
            }

        }

        //private void ExecuteRdsScript(IJobCancellationToken jobCancellationToken, string sqlScriptFile, IFileSystem fileSystem, RDSDbContext rdsContext, AppDbContext appContext)
        //{
        //    if (jobCancellationToken != null)
        //    {
        //        jobCancellationToken.ThrowIfCancellationRequested();
        //    }

        //    LogDataMigrationHistory(appContext, "rds", "Executing " + sqlScriptFile);
        //    var testDataScript = fileSystem.File.ReadAllText(sqlScriptFile);

        //    int? oldTimeOut = rdsContext.Database.GetCommandTimeout();
        //    rdsContext.Database.SetCommandTimeout(11000);

        //    // Workaround for the fact that ShutdownCancellationToken is not called when the job is deleted
        //    // https://github.com/HangfireIO/Hangfire/issues/211

        //    var source = new CancellationTokenSource();
        //    if (jobCancellationToken != null)
        //    {
        //        Task.Run(() =>
        //        {
        //            try
        //            {
        //                while (true)
        //                {
        //                    Thread.Sleep(1000);
        //                    jobCancellationToken.ThrowIfCancellationRequested();
        //                }
        //            }
        //            catch (Exception)
        //            {
        //                source.Cancel();
        //            }
        //        }, source.Token);
        //    }

        //    var dbTask = rdsContext.Database.ExecuteSqlCommandAsync(testDataScript, source.Token);
        //    dbTask.Wait();

        //    rdsContext.Database.SetCommandTimeout(oldTimeOut);

        //    if (jobCancellationToken != null)
        //    {
        //        jobCancellationToken.ThrowIfCancellationRequested();
        //    }

        //}
        private void LogDataMigrationHistory(AppDbContext context, string dataMigrationTypeCode, string dataMigrationHistoryMessage)
        {

            Console.WriteLine(DateTime.Now + " - " + dataMigrationTypeCode + " - " + dataMigrationHistoryMessage);

            DataMigrationType dataMigrationType = context.DataMigrationTypes.Single(x => x.DataMigrationTypeCode == dataMigrationTypeCode);

            DataMigrationHistory historyRecord = new DataMigrationHistory();
            historyRecord.DataMigrationHistoryDate = DateTime.UtcNow;
            historyRecord.DataMigrationTypeId = dataMigrationType.DataMigrationTypeId;
            historyRecord.DataMigrationHistoryMessage = dataMigrationHistoryMessage;

            context.DataMigrationHistories.Add(historyRecord);
            context.SaveChanges();
        }


    }
}