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

        protected Program()
        {
        }


        private static void ConfigureServices(IServiceCollection services)
        {
            services.AddOptions();
            services.Configure<AppSettings>(Configuration.GetSection("AppSettings"));
            services.Configure<DataSettings>(Configuration.GetSection("Data"));

            services
               .AddDbContext<AppDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:AppDbContextConnection"]))
               .AddDbContext<StagingDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:StagingDbContextConnection"]))
               .AddDbContext<IDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:ODSDbContextConnection"]))
               .AddDbContext<RDSDbContext>(options =>
                    options.UseSqlServer(Configuration["Data:RDSDbContextConnection"]));

            services.AddLogging();

            AppConfiguration.ConfigureCoreServices(services);

        }

        public static void Main(string[] args)
        {

            var appDir = PlatformServices.Default.Application.ApplicationBasePath;

            var builder = new ConfigurationBuilder()
                .AddCommandLine(args)
                .AddEnvironmentVariables(e => e.Prefix = "Data")
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

            Configuration = builder.Build();
                        
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


            RunTask(commandLineArguments, environment);

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

            if (environment == "test" || environment == "stage")
            {
                updatePath = "D:\\apps\\generate.web." + environment;
            }

            Console.WriteLine("Update Path = " + updatePath);
            dbUpdaterService.Update(true, updatePath);
        }


    }
}
