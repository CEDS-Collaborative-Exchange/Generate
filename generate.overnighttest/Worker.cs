using System.CommandLine;
using System.CommandLine.Parsing;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Reflection;
using generate.core.Config;
using generate.core.Interfaces.Services;
using generate.infrastructure.Contexts;
using generate.infrastructure.Services;
using generate.web.Config;
using Hangfire;
using Hangfire.SqlServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.PlatformAbstractions;
using static generate.overnighttest.Utils;
using System.Collections.Generic;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Logging;
using System;
using Hangfire.Logging;
namespace generate.overnighttest
{
    public class Worker
    {
        
        // Directory where this application is running
        private string appDir;
        private string[] programArgs;
        /// <summary>
        /// Only run pre dmc once if testing only
        /// when --migrate or --testallfact or --testfilespec --testfacttype
        /// 
        /// </summary>
        private bool runPreDmc = true;
        public Worker(string[] args)
        {
            this.programArgs = args;
        }
        private IServiceProvider? serviceProvider;
        private int schoolyear = DateTime.Now.Year;

        /// <summary>
        /// Intiliazes and Register Service with Dependency Injections
        /// Such as DbContext and Services
        /// </summary>
        /// <param name="configuration"></param>
        /// <param name="services"></param>
        private void ConfigureServices(IConfigurationRoot configuration, IServiceCollection services)
        {
            services.AddOptions();
            services.Configure<AppSettings>(configuration.GetSection("AppSettings"));
            services.Configure<DataSettings>(configuration.GetSection("Data"));

            services
               .AddDbContext<AppDbContext>(options =>
                    options.UseSqlServer(configuration["Data:AppDbContextConnection"]))
               .AddDbContext<StagingDbContext>(options =>
                    options.UseSqlServer(configuration["Data:StagingDbContextConnection"]))
               .AddDbContext<IDSDbContext>(options =>
                    options.UseSqlServer(configuration["Data:ODSDbContextConnection"]))
               .AddDbContext<RDSDbContext>(options =>
                    options.UseSqlServer(configuration["Data:RDSDbContextConnection"]));

            services.AddLogging();



            AppConfiguration.ConfigureCoreServices(services);
            services.AddScoped<IMigrationService, MigrationService>();

        }

        /// <summary>
        /// Parses argument  and returns Dictionary with
        ///   Util.CommandType as key and value associated with argument
        /// 
        /// <param name="args"></param>
        /// <returns>Dictionary key as CommandType and value of the argument
        /// --testallfact 123 , will be key TEST_FACT_TYPE_OPTION and value as 123
        /// </returns>
        /// </summary>
        private Dictionary<CommandType, string> ParseArgumentAndBuildCommand()
        {
            RootCommand rootCommand = new("Program to run over night test");
            rootCommand.Options.Add(MIGRATION_OPTION);
            rootCommand.Options.Add(TEST_ALL_FACT_OPTION);
            rootCommand.Options.Add(TEST_FILE_SPEC_OPTION);
            rootCommand.Options.Add(TEST_FACT_TYPE_OPTION);
            rootCommand.Options.Add(ENABLE_TEST_OPTION);
            rootCommand.Options.Add(DISABLE_TEST_OPTION);

            rootCommand.Options.Add(SCHOOL_YEAR_OPTION);
            var commandToValue = new Dictionary<CommandType, string>();

            //RootCommand rootCommand = BuildRootCommand(commandToValue);
            ParseResult parsedResult = rootCommand.Parse(programArgs);

            //This dictionary will have track what commandOption type came in the argument and value for it
            // eg. -testfilespec should have 002,005
            // eg. -enabletest should have FS002,FS005 so on
            Console.Out.WriteLine("ParseResultValue:" + parsedResult);
            Console.Out.WriteLine("ParseResultValue Errors:" + parsedResult.Errors.Count);
            List<CommandType> trackCommands = [];
            // on error exit and log the reason
            if (parsedResult.Errors.Count > 0)
            {
                foreach (ParseError parseError in parsedResult.Errors)
                {
                    Console.Error.WriteLine(parseError.Message);
                }
                ExitWithCode(EXIT_CODES.ParseArgumentAndBuildCommand);

            }

            // if --migrate passed set value 
            string? migrateFactsValue = parsedResult.GetValue(MIGRATION_OPTION);
            if (migrateFactsValue != null)
            {
                migrateFactsValue = migrateFactsValue.ToUpper();
                Console.WriteLine($"Adding option:{MIGRATION_OPTION}");
                commandToValue.Add(CommandType.MIGRATE, migrateFactsValue);

                trackCommands.Add(CommandType.MIGRATE);
            }
            else
            {
                Console.WriteLine($"Not Adding option:{MIGRATION_OPTION}");
            }

            // if --testallfact passed set value as true    
            if (parsedResult.GetValue(TEST_ALL_FACT_OPTION))
            {
                Console.WriteLine($"Adding option:{TEST_ALL_FACT_OPTION}");
                commandToValue.Add(CommandType.TEST_ALL_FACT, bool.TrueString);
                trackCommands.Add(CommandType.MIGRATE);
            }
            else
            {
                Console.WriteLine($"Not Adding option:{TEST_ALL_FACT_OPTION}");
            }

            // --schoolyear 2025 is just an argument , does not translate command
            if (parsedResult.GetValue(SCHOOL_YEAR_OPTION) > 0)
            {
                schoolyear = parsedResult.GetValue(SCHOOL_YEAR_OPTION);
                Console.Out.WriteLine($"School year option came as value:{schoolyear}");

            }

            // only parse command options that return string , 
            var optionToCommandType = new Dictionary<Option<string>, CommandType>
            {
                {TEST_FILE_SPEC_OPTION,CommandType.TEST_FACT_BY_SPEC },
                {TEST_FACT_TYPE_OPTION,CommandType.TEST_FACT_BY_TYPE },
                {ENABLE_TEST_OPTION,CommandType.ENABLE_TEST },
                {DISABLE_TEST_OPTION,CommandType.DISABLE_TEST }
            };

            // building each command option type to value that was provided
            foreach (var (option, commandType) in optionToCommandType)
            {
                Console.WriteLine($"Processing option:{option} => commandType:{commandType}");
                string? optionValue = parsedResult.GetValue(option);
                if (optionValue != null && !EMPTY_STRING.Equals(optionValue))
                {
                    if (commandToValue.Count > 0)
                    {
                        Console.Error.WriteLine($"{commandType} is not allowed with this combination of argumens: [{string.Join(", ", programArgs)}]");
                        ExitWithCode(EXIT_CODES.ParseArgumentAndBuildCommand);
                    }
                    Console.WriteLine($"Current commandToValue size: {commandToValue.Count}");
                    Console.WriteLine($"Adding option:{option} => {commandType},with value:{optionValue}");
                    commandToValue.Add(commandType, optionValue);

                }
                else
                {
                    Console.WriteLine($"Not Adding option:{option} value not correct");
                }

            }


            Console.WriteLine($"commandToValue.Count:{commandToValue.Count}");
            if (commandToValue.Count == 0)
            {
                Console.Out.WriteLine(HELP_MESSAGE);
                ExitWithCode(EXIT_CODES.ParseArgumentAndBuildCommand);
            }

            return commandToValue;
        }

        /// <summary>
        /// Initalizes Application Environment and Configuration
        /// Setups Services and DbContext
        /// </summary>
        /// <param name="args"></param>
        private void InitializeAndConfigure()
        {
            appDir = PlatformServices.Default.Application.ApplicationBasePath;

            var builder = new ConfigurationBuilder()
                .AddCommandLine(programArgs)
                .AddEnvironmentVariables(e => e.Prefix = "Data__")
                .AddUserSecrets(Assembly.GetExecutingAssembly(), true);


            string environment = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT") ?? "Production";


            if (environment == "")
            {
                environment = "development";
            }

            environment = environment.ToLower();

            if (environment == "development")
            {
                appDir = Directory.GetCurrentDirectory();
            }

            builder.SetBasePath(appDir + "/Config/");
            builder.AddJsonFile("appsettings.json", optional: true)
                .AddJsonFile($"appsettings.{environment.ToLower()}.json", optional: true);

            IConfigurationRoot configuration = builder.Build();

            var services = new ServiceCollection();
            ConfigureServices(configuration, services);
            serviceProvider = services.BuildServiceProvider();




            GlobalConfiguration.Configuration.UseSqlServerStorage(configuration.GetValue<string>("Data:HangfireConnection"), new SqlServerStorageOptions { CommandTimeout = TimeSpan.FromHours(8) });



        }
        public void Start()
        {
            try
            {
                InitializeAndConfigure();

                RunTasksBasedOnCommands();
            }
            catch (Exception ex)
            {
                Console.WriteLine("There was an error Running this job");
                // Console.Error.WriteLine(ex.ToString());
                ExitWithCode(EXIT_CODES.Start,ex);
            }



        }

        /// <summary>
        /// Based on arguments passed invokes Different functions
        /// eg. for migrate --migrate ///
        /// for testallfacts --testallfact///
        /// --testfilespec ///
        /// --testfacttype ///
        /// --enabletest  005,001//
        /// --disabletest 005,004//
        /// --schoolyear 2025
        /// </summary>
        /// <param name="args"></param>
        private void RunTasksBasedOnCommands()
        {
            Dictionary<CommandType, string> commandTypeToValueDict = ParseArgumentAndBuildCommand();

            // if --migrate was passed will allow to run migrate and also allow other command to execute
            // so in one inovaction --migrate --testallfact will migrate and run all test
            // --migrate --enabletest will migrate and enabletests
            if (commandTypeToValueDict.ContainsKey(CommandType.MIGRATE))
            {
                RunPreDmc();
                RunMigration(commandTypeToValueDict.GetValueOrDefault(CommandType.MIGRATE, EMPTY_STRING));
            }

            // --enabletest  was passed will enable or disable and allow other commands
            if (commandTypeToValueDict.TryGetValue(CommandType.ENABLE_TEST, out string? enableTestVals))
            {
                EnableOrDisableTests(enableTestVals, true);
                //EnableOrDisableTests(commandToValueDict.GetValueOrDefault(CommandType.ENABLE_TEST, EMPTY_STRING), true);
            }

            // -- --disabltest was passed will enable or disable and allow other commands

            if (commandTypeToValueDict.TryGetValue(CommandType.DISABLE_TEST, out string? disableTestVals))
            {
                EnableOrDisableTests(disableTestVals, false);
                //EnableOrDisableTests(commandToValueDict.GetValueOrDefault(CommandType.DISABLE_TEST, EMPTY_STRING), false);
            }

            // --testallfact was passed, will not run any other command
            if (commandTypeToValueDict.ContainsKey(CommandType.TEST_ALL_FACT))
            {

                RunAllTests();
                return;
            }

            // --testbyfactspec was passed, will not run any other command
            if (commandTypeToValueDict.TryGetValue(CommandType.TEST_FACT_BY_SPEC, out string? testFactBySpecVal))
            {

                RunTestByFileSpec(testFactBySpecVal);
                //RunTestByFileSpec(commandToValueDict.GetValueOrDefault(CommandType.TEST_FACT_BY_SPEC, EMPTY_STRING));
                return;
            }

            // --testbyfactype was passed will not run any other command
            if (commandTypeToValueDict.TryGetValue(CommandType.TEST_FACT_BY_TYPE, out string? testFactByTypeVal))
            {

                RunTestByFactType(testFactByTypeVal);
                //RunTestByFactType(commandToValueDict.GetValueOrDefault(CommandType.TEST_FACT_BY_TYPE, EMPTY_STRING));
                return;
            }
        }

        /// <summary>
        /// updates the GenerateReports.isLocked for given or all report codes
        /// If reportCodeArr is present toogle isLocked only for them
        /// If reportCodeArr ALL that means toggle isLocked for all 
        /// update all or certain reportCode for table GenerateReports.isLocked to 1 or 0 
        /// </summary>
        /// <param name="value">1 means lock, 0 means unlock</param>
        /// <param name="reportCodeArr"> A comma seperated name of reports such as 002,003</param>
        private void toggleReportLock(int value, string[]? reportCodeArr)
        {
            Console.Out.WriteLine($"Inside toggleReportLock with value:{value},and reportCodeArr:{reportCodeArr}");
            try
            {
                if (reportCodeArr.IsNullOrEmpty())
                {
                    Console.WriteLine("Not running toggleReportLock as reportCodeArr is empty");
                    return;

                }
                Action<string, DbContext> process = (reportCode, dbContext) =>
                {
                    string whereClause = reportCode.Equals(ALL_FACT) ? "" : $" and ReportCode = '{reportCode}'";
                    string sqlUpdateStr = $@"
                            update app.GenerateReports
                            set IsLocked = {value}
                            where 1 = 1 {whereClause}
                        ";
                    Console.WriteLine($"sqlUpdateStr:{sqlUpdateStr}");
                    int rowsUpdated = dbContext.Database.ExecuteSqlRaw(sqlUpdateStr);
                    Console.WriteLine($"Rows Updated for reportCode:{reportCode} toggleReportLock:{rowsUpdated}");
                }

                ;
                using var scope = serviceProvider.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                if (!reportCodeArr.Contains(ALL_FACT) && reportCodeArr.Length > 0)
                {
                    foreach (var reportCode in reportCodeArr)
                    {
                        process(reportCode, dbContext);
                    }
                    return;
                }
                else
                {
                    process(ALL_FACT, dbContext);
                }

            }
            catch (Exception ex)
            {
                Console.Error.Write("Error running toggleReportLock");
                // Console.Error.Write(ex);
                ExitWithCode(EXIT_CODES.ToggleReportLock,ex);
            }
        }
        private void RunMigration(string? migrateFactRecords)
        {
            try
            {

                Console.WriteLine($"Inside RunMigration with migrateFactRecords:{migrateFactRecords}");
                string[]? factsToMigrate = [ALL_FACT];
                // all the fact  report codes to array
                if (migrateFactRecords != null && !migrateFactRecords.Contains(ALL_FACT))
                {
                    factsToMigrate = migrateFactRecords.Split(",");
                }


                // unlock all GenerateReports.isLocked to 0 
                toggleReportLock(0, []);
                // Only report that came in to be locked or if all report everthing to be locked, GenerateReports.isLocked = 1 
                toggleReportLock(1, factsToMigrate);
                Console.Out.WriteLine("Inside RunMigration");
                IMigrationService migrationService = serviceProvider.GetService<IMigrationService>();
                Console.Out.WriteLine("migrationService is present:" + migrationService);
                migrationService.MigrateData("report");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Error in RunMigration");
                // Console.Error.Write(ex);
                ExitWithCode(EXIT_CODES.RunMigration,ex);
            }
            finally
            {
                Console.WriteLine("Done running migration");

            }

        }

        /// <summary>
        /// Run certain database work before running migration
        /// 1.  update ToggleResponses table.ResponseValue 
        /// 2.  update [RDS].[DimSchoolYearDataMigrationTypes] isSelected to 0
        /// 3.  UPDATE [RDS].[DimSchoolYearDataMigrationTypes]  SET IsSelected = 1 for DimSchoolYearId for selected school year
        /// 4.  updates ToggleResponses table field ResponseValue with schoolYear
        /// 5.  Runs a fresh insert to ToggleAssessments
        /// </summary>
        private void RunPreDmc()
        {
            Console.WriteLine("Inside RunPreDmc");
            try
            {
                if (!runPreDmc)
                {
                    Console.WriteLine("PreDmc already ran");
                    return;
                }
                using var scope = serviceProvider.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();


                // updates ToggleResponses table.ResponseValue with schoolYear
                int rowsUpdated = dbContext.Database.ExecuteSql($"update App.ToggleResponses set ResponseValue = '10/01/' + CAST({schoolyear} - 1 AS VARCHAR) where ToggleResponseId = 1");

                Console.WriteLine($"Rows Updated from ToggleResponses:{rowsUpdated}");
                // updates DimSchoolYearDataMigrationTypes.isSelected to 0 , all migration to selected 0 
                rowsUpdated = dbContext.Database.ExecuteSqlRaw($"UPDATE [RDS].[DimSchoolYearDataMigrationTypes] SET IsSelected = 0 ");
                Console.WriteLine($"Rows Updated from DimSchoolYearDataMigrationTypes isselected:{rowsUpdated}");

                // updates DimSchoolYearDataMigrationTypes for current schoolYear IsSelected to 1
                List<Dictionary<string, object>> results = RunSqlCmdAndReadResult($"select DimSchoolYearId FROM [RDS].[DimSchoolYears] WHERE SchoolYear = {schoolyear}");
                Console.WriteLine($"Found results from query:{results}");
                if (results.Count > 0)
                {
                    Dictionary<string, object> firstItem = results[0];
                    var DimSchoolYearId = firstItem.GetValueOrDefault("DimSchoolYearId", -1);
                    Console.WriteLine($"Found DimSchoolYearId:{DimSchoolYearId}");
                    rowsUpdated = dbContext.Database.ExecuteSql($@"UPDATE [RDS].[DimSchoolYearDataMigrationTypes]  SET IsSelected = 1 WHERE DimSchoolYearId = {DimSchoolYearId}");
                    Console.WriteLine($"Rows Updated from DimSchoolYearDataMigrationTypes isselected to 1:{rowsUpdated}");

                }

                string sqlUpdateStr = $@"
                        update tr
                        set ResponseValue = '10/21/' + CAST({schoolyear} - 1 AS VARCHAR)
                        from App.ToggleResponses tr 
                        inner join app.ToggleQuestions tq
                        on tr.ToggleQuestionId = tq.ToggleQuestionId	
                        and tq.EmapsQuestionAbbrv = 'MEMBERDTE'                    
                    ";
                //string sqlUpdateStr = $"update a set a.IsActive = {(enable ? 1 : 0)} from App.SqlUnitTest a where a.TestScope='{fileSpecNum}'";
                Console.WriteLine($"sqlUpdateStr:{sqlUpdateStr}");
                rowsUpdated = dbContext.Database.ExecuteSqlRaw(sqlUpdateStr);
                Console.WriteLine($"Rows Updated from predmc:{rowsUpdated}");

                string toggleSqlFilePath = Path.Combine(appDir, "DatabaseScripts", "InsertToggleAssessments.sql");
                Console.WriteLine($"toggleSqlFilePath:{toggleSqlFilePath}");
                string script = File.ReadAllText(toggleSqlFilePath);
                // Console.WriteLine($"toggleScript:{script}");
                dbContext.Database.ExecuteSqlRaw(script);

            }
            catch (Exception ex)
            {
                Console.Error.Write($"Error Running PreDmc");
                // Console.Error.WriteLine(ex);
                ExitWithCode(EXIT_CODES.RunPreDmc,ex);
            }
            finally
            {
                runPreDmc = false;
            }

        }
        private void RunAllTests()
        {
            Console.WriteLine("Inside RullAllTests");

            Dictionary<string, string> allTestStoredProcs = buildFileSpecToStoredProc(schoolyear);
            string factSpecValuesSeperatedByComma = string.Join(",", allTestStoredProcs.Keys);
            Console.WriteLine($"All factSpecValuesSeperatedByComma for test all :{factSpecValuesSeperatedByComma}");

            RunTestByFileSpec(factSpecValuesSeperatedByComma);

        }

        private void RunTestByFactType(string factTypeValuesSeperatedByComma)
        {
            Dictionary<string, string> dict = Utils.BuildFactTypeToFileSpec();
            Console.WriteLine("Inside RunTestByFactType factTypeValuesSeperatedByComma:" + factTypeValuesSeperatedByComma);
            string[] factTypeArr = factTypeValuesSeperatedByComma.Split(",");

            foreach (var item in factTypeArr)
            {
                Console.WriteLine("factType came:" + item);
                if (dict.TryGetValue(item, out string fileSpec))
                {
                    Console.WriteLine($"Found fileSpec:{fileSpec}");
                    RunTestByFileSpec(fileSpec);
                }
                else
                {
                    Console.WriteLine($"No fileSpec found for factType: {item}");
                }

            }

        }



        /// <summary>
        /// Executes the given SQL query and returns the result as a list of dictionaries.
        /// Each dictionary represents a row, mapping column names to their values.
        /// </summary>
        /// <param name="sqlQuery">The SQL query to execute.</param>
        /// <returns>List of rows, each as a Dictionary&lt;string, object&gt;.</returns>
        private List<Dictionary<string, object>> RunSqlCmdAndReadResult(string sqlQuery)
        {
            Console.WriteLine($"Executing RunSqlCmdAndReadResult with sqlQuery:{sqlQuery}");
            var results = new List<Dictionary<string, object>>();
            try
            {
                using var scope = serviceProvider.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                string connectionString = dbContext.Database.GetDbConnection().ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(sqlQuery, conn))
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        int fieldCount = reader.FieldCount;
                        while (reader.Read())
                        {
                            var row = new Dictionary<string, object>(fieldCount);
                            for (int i = 0; i < fieldCount; i++)
                            {
                                row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
                            }
                            results.Add(row);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error executing SQL command: {ex.Message}");
                //Console.Error.WriteLine(ex);
                ExitWithCode(EXIT_CODES.RunSqlCmdAndReadResult,ex);
            }
            return results;
        }

        private bool IsTestActiveForFileSpec(string fileSpecNum)
        {
            Console.WriteLine($"Inside IsTestActiveForFileSpec with:{fileSpecNum}");
            try
            {
                if (!fileSpecNum.StartsWith("FS"))
                {
                    fileSpecNum = "FS" + fileSpecNum;
                }
                using var scope = serviceProvider.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                string connectionString = dbContext.Database.GetDbConnection().ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string sql = $"select a.IsActive from App.SqlUnitTest a where a.TestScope='{fileSpecNum}'";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        object isActiveTest = cmd.ExecuteScalar();

                        Console.WriteLine($"isActiveTest : {isActiveTest}");
                        return true.Equals(isActiveTest);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Error.Write("Error in IsTestActiveForFileSpect for file spec:" + fileSpecNum);
                //Console.WriteLine(ex.StackTrace);
                Console.Error.WriteLine(ex);
                return false;
            }
        }
        private void RunTestByFileSpec(string factSpecValuesSeperatedByComma)
        {
            Console.WriteLine($"Inside RunTestByFileSpec factSpecValuesSeperatedByComma:{factSpecValuesSeperatedByComma},runPreDmc:{runPreDmc}");
            string[] factSpecArr = factSpecValuesSeperatedByComma.Split(",");
            Dictionary<string, string> fileSpecToTestStoredProcWithSchoolYear = Utils.buildFileSpecToStoredProc(schoolyear);
            try
            {

                foreach (var item in factSpecArr)
                {
                    Console.WriteLine("----------------------------------");
                    Console.WriteLine(">>>Running Test for spec::" + item);
                    if (!IsTestActiveForFileSpec(item))
                    {
                        Console.WriteLine($"Test for spec:{item} is not active");
                        continue;
                    }
                    var storedProc = fileSpecToTestStoredProcWithSchoolYear.GetValueOrDefault(item, Utils.EMPTY_STRING);
                    using var scope = serviceProvider.CreateScope();
                    try
                    {
                        var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                        Console.WriteLine($"Running storedProc with this command:: {storedProc}");
                        int result = dbContext.Database.ExecuteSqlRaw(
                            storedProc
                        );

                        Console.WriteLine($"Return Code for stored proc {storedProc} is :::{result}");
                    }
                    catch (Exception ex)
                    {
                        Console.Error.Write("Error in RunTestByFileSpec for file spec:" + item);
                        // Console.Error.WriteLine(ex);
                        ExitWithCode(EXIT_CODES.RunTestByFileSpec,ex);
                    }
                    Console.WriteLine(">>>Done Running Test for spec::" + item);
                }
            }
            catch (Exception ex)
            {
                Console.Error.Write($"Error in RunTestByFileSpec for file spec:{factSpecValuesSeperatedByComma}");
                //Console.Error.WriteLine(ex.ToString());
                 ExitWithCode(EXIT_CODES.RunTestByFileSpec,ex);

            }



        }

        private void EnableOrDisableTests(string fileSpecNumbers, bool enable = true)
        {
            Console.WriteLine($"Inside EnableOrDisableTests enable:{enable} fileSpecNumbers:{fileSpecNumbers}, ");
            string[] fileSpecArr = fileSpecNumbers.Split(",");
            foreach (var fileSpecNum in fileSpecArr)
            {
                try
                {
                    using var scope = serviceProvider.CreateScope();
                    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
                    string sqlUpdateStr = $"update a set a.IsActive = {(enable ? 1 : 0)} from App.SqlUnitTest a where a.TestScope='{fileSpecNum}'";
                    Console.WriteLine($"sqlUpdateStr:{sqlUpdateStr}");
                    int rowsUpdated = dbContext.Database.ExecuteSqlRaw(sqlUpdateStr);
                    Console.WriteLine($"fileSpecNum :{fileSpecNum} updated rows:{rowsUpdated}");
                }
                catch (Exception ex)
                {
                    Console.Error.Write($"Error update SqlUnitTest for spec:{fileSpecNum} when enable is :{enable},message:{ex.Message}");
                    // Console.Error.WriteLine(ex);
                    ExitWithCode(EXIT_CODES.EnableOrDisableTests,ex);
                }
            }
        }




    }
}