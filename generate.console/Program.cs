using System;
using generate.infrastructure.Contexts;
using generate.core.Interfaces.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.Config;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Builder;
using System.IO;
using generate.web.Config;
using generate.testdata.Interfaces;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using generate.core.Interfaces.Repositories.App;
using System.IO.Abstractions;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using Hangfire;
using System.Reflection;


namespace generate.console
{
    public class Program
    {
        private static IServiceProvider serviceProvider;
        private static IConfigurationRoot Configuration;
        private static readonly string[] RequiredDataConnectionNames = [
            "AppDbContextConnection",
            "StagingDbContextConnection",
            "ODSDbContextConnection",
            "RDSDbContextConnection"
        ];

        protected Program()
        {
        }


        private static void ConfigureServices(IServiceCollection services)
        {
            var appDbContextConnection = GetRequiredDataConnection("AppDbContextConnection");
            var stagingDbContextConnection = GetRequiredDataConnection("StagingDbContextConnection");
            var odsDbContextConnection = GetRequiredDataConnection("ODSDbContextConnection");
            var rdsDbContextConnection = GetRequiredDataConnection("RDSDbContextConnection");

            services.AddOptions();
            services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));
            services.Configure<DataSettings>(Configuration.GetSection("Data"));

            services
               .AddDbContext<AppDbContext>(options =>
                    options.UseSqlServer(appDbContextConnection))
               .AddDbContext<StagingDbContext>(options =>
                    options.UseSqlServer(stagingDbContextConnection))
               .AddDbContext<IDSDbContext>(options =>
                    options.UseSqlServer(odsDbContextConnection))
               .AddDbContext<RDSDbContext>(options =>
                    options.UseSqlServer(rdsDbContextConnection));

            services.AddLogging();

            AppConfiguration.ConfigureCoreServices(services);

        }

        public static void Main(string[] args)
        {
            var appDir = PlatformServices.Default.Application.ApplicationBasePath;
            var environment = ResolveEnvironment();
            var configBasePath = ResolveConfigBasePath(appDir);

            var builder = new ConfigurationBuilder()
                .SetBasePath(configBasePath)
                .AddJsonFile("appsettings.json", optional: true)
                .AddJsonFile($"appsettings.{environment}.json", optional: true)
                .AddJsonFile($"appsettings.{environment.ToLowerInvariant()}.json", optional: true)
                .AddUserSecrets(Assembly.GetExecutingAssembly(), true)
                .AddEnvironmentVariables()
                .AddCommandLine(args);

            Configuration = builder.Build();
            ValidateRequiredDataConnections();
                        
            var services = new ServiceCollection();
            ConfigureServices(services);
            serviceProvider = services.BuildServiceProvider();

            // Get arguments

            List<string> commandLineArguments = new List<string>();
            if (args != null && args.Length > 0)
            {
                for (int i = 0; i < args.Length; i++)
                {
                    commandLineArguments.Add(args[i]);
                }
            }

            if (commandLineArguments.Count <= 0)
            {
                Console.WriteLine(GetHelpText());
                return;
            }


            RunTask(commandLineArguments, environment.ToLowerInvariant());

        }

        public static string GetHelpText()
        {

            var helpText = new StringBuilder();
            helpText.AppendLine("generate.console - command line utility");
            helpText.AppendLine();
            helpText.AppendLine("Usage (from within project directory): dotnet run [taskToRun] [task-options]");
            helpText.AppendLine("Usage (using compiled exe): generate.console.exe [taskToRun] [task-options]");
            helpText.AppendLine();
            helpText.AppendLine("Tasks To Run:");
            helpText.AppendLine("  help                 Display this information");
            helpText.AppendLine("  update               Update database");
            helpText.AppendLine("  testdata             Generate test data");
            helpText.AppendLine();
            helpText.AppendLine("help task-options:");
            helpText.AppendLine("  None available");
            helpText.AppendLine();
            helpText.AppendLine("update task-options:");
            helpText.AppendLine("  None available");
            helpText.AppendLine();
            helpText.AppendLine("testdata task-options:");
            helpText.AppendLine();
            helpText.AppendLine("  Example: testdata ids 1000 50 c# 2024 ceds file");
            helpText.AppendLine();
            helpText.AppendLine("  ids|rds|staging        Type of test data");
            helpText.AppendLine("  <int>                  Randomizer seed value (use 0 for a random seed)");
            helpText.AppendLine("  <int>                  Quantity of test data (# of students)");
            helpText.AppendLine("  sql|c#|json            Format");
            helpText.AppendLine("  YYYY                   School Year");
            helpText.AppendLine("  <int>                  Number of Years");
            helpText.AppendLine("  ceds|non-ceds          Format of test data");
            helpText.AppendLine("  console|file|execute   Output");
            
            helpText.AppendLine();
            helpText.AppendLine("  Usage Notes:");
            helpText.AppendLine();
            helpText.AppendLine("  The 'execute' output type requires a 'sql' format type");

            return helpText.ToString();
        }

        public static void RunTask(List<string> commandLineArguments, string environment)
        {
            DateTime startTime = DateTime.UtcNow;

            string[] validTasks = ["help", "update", "testdata"];
            string taskToRun = commandLineArguments[0].ToLower();
            const string invalidString = "Invalid Arguments";
            const string spacer = "-----------------------";

            if (validTasks.Length <= 0)
            {
                Console.WriteLine(invalidString);
                Console.WriteLine(spacer);
                Console.WriteLine(GetHelpText());
                return;
            }

            Console.WriteLine(spacer);
            Console.WriteLine("-- Task = " + taskToRun);
            Console.WriteLine(spacer);

            switch (taskToRun)
            {
                case "help":
                    Console.WriteLine(GetHelpText());
                    break;

                case "update":
                    Update(environment);
                    break;

                case "testdata":
                    // Get additional arguments
                    int seed;
                    int quantityOfStudents;
                    int schoolYear;
                    int numberOfYears;
                    string dataStandardType;
                    string testDataType;
                    string formatType;
                    string outputType;

                    if (commandLineArguments.Count < 9)
                    {
                        Console.WriteLine("Insufficient Arguments");
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }

                    string[] validTypes = ["ids", "rds", "staging"];
                    testDataType = commandLineArguments[1].ToLower();

                    if (!validTypes.Contains(testDataType))
                    {
                        Console.WriteLine(invalidString);
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }

                    int.TryParse(commandLineArguments[2], out seed);
                    int.TryParse(commandLineArguments[3], out quantityOfStudents);

                    string[] validFormatTypes = ["json", "sql", "c#"];
                    formatType = commandLineArguments[4].ToLower();

                    if (!validFormatTypes.Contains(formatType))
                    {
                        Console.WriteLine(invalidString);
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }
                    
                    try
                    {
                        schoolYear = Convert.ToInt32(commandLineArguments[5]);
                    }
                    catch (Exception)
                    {
                        Console.WriteLine(invalidString);
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }


                    numberOfYears = Convert.ToInt32(commandLineArguments[6]);
                    

                    dataStandardType = commandLineArguments[7].ToLower();
                    string[] validDataStandardTypes = ["ceds", "non-ceds"];

                    if (!validDataStandardTypes.Contains(dataStandardType))
                    {
                        Console.WriteLine(invalidString);
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }

                    outputType = commandLineArguments[8].ToLower();
                    string[] validOutputTypes = ["console", "file", "execute"];
                    if (!validOutputTypes.Contains(outputType))
                    {
                        Console.WriteLine(invalidString);
                        Console.WriteLine(spacer);
                        Console.WriteLine(GetHelpText());
                        return;
                    }

                    GenerateTestData(testDataType, seed, quantityOfStudents, schoolYear, numberOfYears, formatType, outputType, dataStandardType);

                    break;

                default:
                    Console.WriteLine(GetHelpText());
                    break;
            }

            var duration = DateTime.UtcNow.Subtract(startTime);

            Console.WriteLine("Duration = " + duration.ToString());


        }

        public static void GenerateTestData(string testDataType, int seed, int quantityOfStudents, int schoolYear, int numberOfYears, string formatType, string outputType, string dataStandardType)
        {
            string outputTypeToGenerate = outputType;
            const string invalidString = "Invalid Arguments";
            const string spacer = "-----------------------";

            if (numberOfYears > 4) { numberOfYears = 4; }

            if (numberOfYears < 1)
            {
                Console.WriteLine(invalidString);
                Console.WriteLine(spacer);
                Console.WriteLine(GetHelpText());
                return;
            }

            if (outputType == "execute")
            {
                outputTypeToGenerate = "file";

                if(formatType != "sql") {
                    Console.WriteLine(invalidString);
                    Console.WriteLine(spacer);
                    Console.WriteLine(GetHelpText());
                    return;
                }
            }

            if (testDataType == "staging")
            {
                ITestDataInitializer testDataInitializer = serviceProvider.GetService<ITestDataInitializer>();
                IStagingTestDataGenerator stagingTestDataGenerator = serviceProvider.GetService<IStagingTestDataGenerator>();
                stagingTestDataGenerator.GenerateTestData(seed, quantityOfStudents, schoolYear, numberOfYears, formatType, outputTypeToGenerate, dataStandardType, Directory.GetCurrentDirectory(), testDataInitializer);
            }
            else if (testDataType == "ids")
            {
                IIdsTestDataGenerator idsTestDataGenerator = serviceProvider.GetService<IIdsTestDataGenerator>();
                idsTestDataGenerator.GenerateTestData(seed, quantityOfStudents, schoolYear, formatType, outputTypeToGenerate, Directory.GetCurrentDirectory());
            }
            else if (testDataType == "rds")
            {
                IRdsTestDataGenerator rdsTestDataGenerator = serviceProvider.GetService<IRdsTestDataGenerator>();
                rdsTestDataGenerator.GenerateTestData(seed, quantityOfStudents, formatType, outputTypeToGenerate, Directory.GetCurrentDirectory());
            }

            if (outputType == "execute")
            {
                ITestDataInitializer testDataInitializer = serviceProvider.GetService<ITestDataInitializer>();
                testDataInitializer.ExecuteTestData(testDataType, JobCancellationToken.Null, Directory.GetCurrentDirectory());
            }
        }

        public static void Update(string environment)
        {
            IDbUpdaterService dbUpdaterService = serviceProvider.GetService<IDbUpdaterService>();
            DirectoryInfo di = new DirectoryInfo(Directory.GetCurrentDirectory());
            string rootDir = di.Parent.FullName;
            string updatePath = rootDir + "\\generate.web";

            if (string.Equals(environment, "test", StringComparison.OrdinalIgnoreCase) || string.Equals(environment, "stage", StringComparison.OrdinalIgnoreCase))
            {
                updatePath = "D:\\apps\\generate.web." + environment;
            }

            Console.WriteLine("Update Path = " + updatePath);
            dbUpdaterService.Update(true, updatePath);
        }

        private static string ResolveEnvironment()
        {
            var environment = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT");

            if (string.IsNullOrWhiteSpace(environment))
            {
                environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
            }

            if (string.IsNullOrWhiteSpace(environment))
            {
                environment = "Production";
            }

            return environment.Trim();
        }

        private static string ResolveConfigBasePath(string appDir)
        {
            var currentDirectoryConfigPath = Path.Combine(Directory.GetCurrentDirectory(), "Config");
            if (Directory.Exists(currentDirectoryConfigPath))
            {
                return currentDirectoryConfigPath;
            }

            var appDirectoryConfigPath = Path.Combine(appDir, "Config");
            if (Directory.Exists(appDirectoryConfigPath))
            {
                return appDirectoryConfigPath;
            }

            return appDirectoryConfigPath;
        }

        private static void ValidateRequiredDataConnections()
        {
            var missingConnectionNames = RequiredDataConnectionNames
                .Where(connectionName => string.IsNullOrWhiteSpace(GetDataConnection(connectionName)))
                .ToList();

            if (missingConnectionNames.Count == 0)
            {
                return;
            }

            var missingKeys = string.Join(", ", missingConnectionNames.Select(connectionName => $"Data:{connectionName}"));
            var envKeys = string.Join(", ", missingConnectionNames.Select(connectionName => $"Data__{connectionName}"));

            throw new InvalidOperationException(
                $"Missing required database connection settings: {missingKeys}. Provide these in Config/appsettings*.json under Data or as environment variables: {envKeys}.");
        }

        private static string GetRequiredDataConnection(string connectionName)
        {
            var connectionValue = GetDataConnection(connectionName);

            if (!string.IsNullOrWhiteSpace(connectionValue))
            {
                return connectionValue;
            }

            throw new InvalidOperationException($"Missing required database connection setting: Data:{connectionName}.");
        }

        private static string GetDataConnection(string connectionName)
        {
            return Configuration[$"Data:{connectionName}"] ?? Configuration[connectionName];
        }


    }
}
