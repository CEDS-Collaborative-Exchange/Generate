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

namespace generate.overnighttest
{
    public class Worker
    {
        private string[] programArgs; 
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
            List<CommandType> trackCommands =[];
            // on error exit and log the reason
            if (parsedResult.Errors.Count > 0)
            {
                foreach (ParseError parseError in parsedResult.Errors)
                {
                    Console.Error.WriteLine(parseError.Message);
                }
                Environment.Exit(-1);

            }

            // if --migrate passed set value as true
            if (parsedResult.GetValue(MIGRATION_OPTION))
            {
                Console.WriteLine($"Adding option:{MIGRATION_OPTION}");
                commandToValue.Add(CommandType.MIGRATE, bool.TrueString);
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
                        Environment.Exit(-1);
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
                Environment.Exit(-1);
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
            var appDir = PlatformServices.Default.Application.ApplicationBasePath;

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

            InitializeAndConfigure();

            RunTasksBasedOnCommands();


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
            Dictionary<CommandType, string> commandToValueDict = ParseArgumentAndBuildCommand();

            // if --migrate was passed will allow to run migrate and also allow other command to execute
            // so in one inovaction --migrate --testallfact will migrate and run all test
            // --migrate --enabletest will migrate and enabletests
            if (commandToValueDict.ContainsKey(CommandType.MIGRATE))
            {
                RunMigration();
            }

            // --enabletest  was passed will enable or disable and allow other commands
            if (commandToValueDict.TryGetValue(CommandType.ENABLE_TEST, out string? enableTestVals))
            {
                EnableOrDisableTests(enableTestVals, true);
                //EnableOrDisableTests(commandToValueDict.GetValueOrDefault(CommandType.ENABLE_TEST, EMPTY_STRING), true);
            }

            // -- --disabltest was passed will enable or disable and allow other commands

            if (commandToValueDict.TryGetValue(CommandType.DISABLE_TEST, out string? disableTestVals))
            {
                EnableOrDisableTests(disableTestVals, false);
                //EnableOrDisableTests(commandToValueDict.GetValueOrDefault(CommandType.DISABLE_TEST, EMPTY_STRING), false);
            }

            // --testallfact was passed, will not run any other command
            if (commandToValueDict.ContainsKey(CommandType.TEST_ALL_FACT))
            {
                RunAllTests();
                return;
            }

            // --testbyfactspec was passed, will not run any other command
            if (commandToValueDict.TryGetValue(CommandType.TEST_FACT_BY_SPEC, out string? testFactBySpecVal))
            {
                RunTestByFileSpec(testFactBySpecVal);
                //RunTestByFileSpec(commandToValueDict.GetValueOrDefault(CommandType.TEST_FACT_BY_SPEC, EMPTY_STRING));
                return;
            }

            // --testbyfactype was passed will not run any other command
            if (commandToValueDict.TryGetValue(CommandType.TEST_FACT_BY_TYPE, out string? testFactByTypeVal))
            {
                RunTestByFactType(testFactByTypeVal);
                //RunTestByFactType(commandToValueDict.GetValueOrDefault(CommandType.TEST_FACT_BY_TYPE, EMPTY_STRING));
                return;
            }
        }


        private void RunMigration()
        {
            try
            {
                Console.Out.WriteLine("Inside RunMigration");
                IMigrationService migrationService = serviceProvider.GetService<IMigrationService>();
                Console.Out.WriteLine("migrationService is present:" + migrationService);
                migrationService.MigrateData("report");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Error in RunMigration");
                Console.Error.Write(ex);
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
            Console.WriteLine("Inside RunTestByFileSpec factSpecValuesSeperatedByComma:" + factSpecValuesSeperatedByComma);
            string[] factSpecArr = factSpecValuesSeperatedByComma.Split(",");
            Dictionary<string, string> fileSpecToTestStoredProcWithSchoolYear = Utils.buildFileSpecToStoredProc(schoolyear);
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
                    Console.Error.WriteLine(ex);
                }
                Console.WriteLine(">>>Done Running Test for spec::" + item);
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
                    Console.Error.WriteLine(ex);
                }
            }
        }




    }
}