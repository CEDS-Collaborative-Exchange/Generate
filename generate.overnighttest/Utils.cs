using System.CommandLine;
using System.Diagnostics;
using System.Text.Json;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Models.App;
using generate.core.Models.RDS;
using Microsoft.Extensions.DependencyInjection;

namespace generate.overnighttest
{


    public static class Utils
    {

        public enum EXIT_CODES
        {
            Start = 1,
            EnableOrDisableTests = 2,
            IsTestActiveForFileSpec = 3,
            ParseArgumentAndBuildCommand = 4,
            RunAllTests = 5,
            RunMigration = 6,
            RunPreDmc = 7,
            RunSqlCmdAndReadResult = 8,
            RunTasksBasedOnCommands = 9,
            RunTestByFactType = 10,
            RunTestByFileSpec = 11,
            ToggleReportLock = 12
        }


        public static void ExitWithCode(EXIT_CODES exitCode, Exception? ex = null)
        {
            try
            {
                var errorTime = DateTime.Now;

                int exitNum = (int)exitCode;
                //Console.Error.WriteLine($"Exiting with error exitcode:{exitCode}");
                Console.Error.WriteLine($"<ERROR-START ErrorTime=\"{errorTime}\">");
                Console.Error.WriteLine($"EXIT_CODES:{exitCode},with errorNum:{exitNum}");
                if (ex != null)
                {
                    Console.Error.WriteLine(ex);
                }
                Console.Error.WriteLine($"</ERROR-END/>");
                Environment.Exit(exitNum);
            }
            catch (Exception e)
            {
                Console.Error.WriteLine($"Grave error occured:{e}");
                Environment.Exit(100);
            }

        }

        /// <summary>
        /// enum to identify command types
        /// MIGRATE
        /// TEST_ALL_FACT
        /// TEST_FACT_BY_TYPE
        /// TEST_FACT_BY_SPEC
        /// ENABLE_TEST 
        /// DISABLE_TEST
        /// </summary>
        public enum CommandType
        {
            MIGRATE,
            TEST_ALL_FACT,
            TEST_FACT_BY_TYPE,
            TEST_FACT_BY_SPEC,
            ENABLE_TEST,
            DISABLE_TEST,
            //SCHOOL_YEAR
        }

        public static string EMPTY_STRING = "";
        public static string ALL_FACT = "ALL_FACT";

        public static Dictionary<string, string> BuildFactTypeToFileSpec()
        {
            Dictionary<string, string> v = new Dictionary<string, string>()
            {
                {"ASSESSMENT","050,113,125,126,137,138,139,175,178,179,185,188,189,224,225"},
                {"CHILDCOUNT","002,089"},
                // {"CHRONIC","195"},
                // {"COMPSUPPORT","212"},
                // {"CTE","082,083,154,155,156, 158,169"},
                // {"DATAPOPULATION","studentsex,studentswdtitle1,studentcount,studentdiscipline,studentdisability,studentsubpopulation,studentrace"},
                // {"Directory related reports","029,035,039,129,130,131,132,163, 170,190,193,196,197,198,205,206,207,223"},
                // {"DISCIPLINE","005,006,007,086,088,143,144"},
                // {"DROPOUT","032"},
                // {"EXITING","009"},
                // {"GRADUATESCOMPLETERS","040"},
                // {"GRADUATIONRATE","150,151"},
                // {"HOMELESS","118,194"},
                // {"HSGRADPSENROLL","160"},
                // //{"IMMIGRANT -"},
                // {"MEMBERSHIP","033,052,226"},
                // {"MIGRANTEDUCATIONPROGRAM","054,121,145, 165"},
                // {"NEGLECTEDORDELINQUENT","119,127,218,219,220,221"},
                // {"ORGANIZATIONSTATUS","199,200,201,202"},
                // {"OTHER","Other Miscellaneous Reports"},
                // {"SPPAPR","indicator4a,indicator4b,indicator9,indicator10"},
                // {"STAFF","059,067,070,099,112,203"},
                // {"TITLEI","037,134,222"},
                // {"TITLEIIIELOCT","141"},
                // {"TITLEIIIELSY","045,116,210,211"}

             };

            return v;
        }

        /// <summary>
        /// 
        /// Return Dicitionary with Key as ASSESSMENT and value as its reportCodes eg. 050,113,125,126,137,138,139,175,178,179,185,188,189,224,225
        /// </summary>
        /// <param name="serviceProvider"></param>
        /// <returns></returns>
        public static Dictionary<string, IList<string>> factTypeDescriptionToReportCodes(IServiceProvider serviceProvider)
        {
            IAppRepository appRepository = serviceProvider.GetService<IAppRepository>();
            IRDSRepository rDSRepository = serviceProvider.GetService<IRDSRepository>();

            List<DimFactType> factTypes = rDSRepository.GetAll<DimFactType>()
                                            .Where(t => t.DimFactTypeId > 0)
                                            .OrderBy(t => t.FactTypeCode)
                                            .ToList();

            Console.WriteLine($"factTypes:{TryToString(factTypes)}");

            // Create a dictionary with DimFactTypeId as key and value as DimFactType
            Dictionary<int, DimFactType> factIdToTrackDimFactType = factTypes
                    .ToDictionary(dimFactType => dimFactType.DimFactTypeId, dimFactType => dimFactType);//new Dictionary<int, DimFactType>();


            List<GenerateReport> reportLists = appRepository.GetReports(0, 0).ToList();
            Console.WriteLine($"reportLists:{TryToString(reportLists)}");

            Dictionary<string, IList<string>> factDescrToReportCodesList = new Dictionary<string, IList<string>>();
            foreach (GenerateReport report in reportLists)
            {
                IList<GenerateReport_FactType> gfacts = report.GenerateReport_FactTypes;
                if (gfacts == null)
                {
                    continue;
                }
                foreach (GenerateReport_FactType grf in gfacts)
                {
                    int factTypeId = grf.FactTypeId;
                    factIdToTrackDimFactType.TryGetValue(factTypeId, out DimFactType? dimFactType);
                    if (dimFactType == null)
                    {
                        continue;
                    }

                    string factTypeCode = dimFactType.FactTypeCode.ToUpper();

                    if (factDescrToReportCodesList.TryGetValue(factTypeCode, out IList<string>? array))
                    {
                        array.Add(report.ReportCode);
                    }
                    else
                    {
                        factDescrToReportCodesList[factTypeCode] = new List<string> { report.ReportCode };
                    }

                }
            }
            Console.WriteLine($"factDescrToReportCodesList values:{Utils.TryToString(factDescrToReportCodesList)}");
            return factDescrToReportCodesList;
        }

        /// <summary>
        /// Returns a Dictionary with key as fileSpecification reportCode and value as the the full stored func with arguments
        /// </summary>
        /// <param name="SchoolYear"></param>
        /// <returns></returns>
        public static Dictionary<string, string> buildFileSpecReportCodeToStoredProc(int SchoolYear)
        {
            Dictionary<string, string> fileSpecToTestStoredProcWithSchoolYear = new Dictionary<string, string>()
        {   
                // key is Students , value is the Full Stored Proc Execl call with Arguments
                { "Students",@"EXEC App.DimK12Students_TestCase"},
                {"029",$"EXEC App.FS029_TestCase     {SchoolYear}"},
                {"002",$"EXEC App.FS002_TestCase     {SchoolYear}"},
                {"089",$"EXEC App.FS089_TestCase     {SchoolYear}"},
                {"009",$"EXEC App.FS009_TestCase     {SchoolYear}"},
                {"005",$"EXEC App.FS005_TestCase     {SchoolYear}"},
                {"006",$"EXEC App.FS006_TestCase     {SchoolYear}"},
                {"007",$"EXEC App.FS007_TestCase     {SchoolYear}"},
                {"088",$"EXEC App.FS088_TestCase     {SchoolYear}"},
                {"143",$"EXEC App.FS143_TestCase     {SchoolYear}"},
                {"144",$"EXEC App.FS144_TestCase     {SchoolYear}"},
                {"070",$"EXEC App.FS070_TestCase     {SchoolYear}"},
                {"099",$"EXEC App.FS099_TestCase     {SchoolYear}"},
                {"112",$"EXEC App.FS112_TestCase     {SchoolYear}"},
                {"175",$"EXEC App.FS17x_TestCase     {SchoolYear}, 'FS175'"},
                {"178",$"EXEC App.FS17x_TestCase     {SchoolYear}, 'FS178'"},
                {"179",$"EXEC App.FS17x_TestCase     {SchoolYear}, 'FS179'"},
                {"185",$"EXEC App.FS18x_TestCase     {SchoolYear}, 'FS185'"},
                {"188",$"EXEC App.FS18x_TestCase     {SchoolYear}, 'FS188'"},
                {"189",$"EXEC App.FS18x_TestCase     {SchoolYear}, 'FS189'"},
                {"033",$"EXEC App.FS033_TestCase     {SchoolYear}"},
                {"052",$"EXEC App.FS052_TestCase     {SchoolYear}"},
                {"118",$"EXEC App.FS118_TestCase     {SchoolYear}"},
                {"141",$"EXEC App.FS141_TestCase     {SchoolYear}"},
                {"194",$"EXEC App.FS194_TestCase     {SchoolYear}"},
                {"210",$"EXEC Staging.RunEndToEndTest	 '210', {SchoolYear}, 'ReportEdFactsK12StudentAssessments', 'StudentIdentifierState', 'StudentCount', 1"},
                {"222",$"EXEC Staging.RunEndToEndTest	 '222', {SchoolYear}, 'ReportEdFactsK12StudentCounts', 'StudentIdentifierState', 'StudentCount', 1"},
                {"226",$"EXEC Staging.RunEndToEndTest	 '226', {SchoolYear}, 'ReportEdFactsK12StudentAssessments', 'StudentIdentifierState', 'StudentCount', 1"},


        };
            return fileSpecToTestStoredProcWithSchoolYear;
        }

        /// <summary>
        /// --migrate
        /// </summary>
        public static string ARG_MIGRATE = "--migrate";

        /// <summary>
        /// --testallfact
        /// </summary>
        public static string ARG_TEST_ALL_FACT = "--testallfact";
        /// <summary>
        /// --testfilespec
        /// </summary>
        public static string ARG_TEST_FILE_SPEC = "--testfilespec";
        /// <summary>
        /// -testfacttype
        /// </summary>
        public static string ARG_TEST_FACT_TYPE = "--testfacttype";
        /// <summary>
        /// --enabletest
        /// </summary>
        public static string ARG_ENABLE_TEST = "--enabletest";
        /// <summary>
        /// --disabletest
        /// </summary>
        public static string ARG_DISABLE_TEST = "--disabletest";

        /// <summary>
        /// --schoolyear
        /// </summary>
        public static string ARG_SCHOOL_YEAR = "--schoolyear";

        static String factTypeToFileSpecStringHelper = string.Join("\t\t", BuildFactTypeToFileSpec().Select(kvp => $"{kvp.Key}:{kvp.Value}\n"));

        public static string HELP_MESSAGE = @$"
                    Usage:
                    {ARG_MIGRATE}   ALL_FACT or 002,003                 Runs Migration with value required values are ALL_FACT or reportCode commaSeperated eg 005,002
                    {ARG_TEST_ALL_FACT}                                 Tests all facts if other test options are provided, they will  be skipped
                    {ARG_TEST_FILE_SPEC} 005,001,005                    Tests given file spec number multiple values can be passed seperated by comma
                    {ARG_TEST_FACT_TYPE} ASSESSMENT,CHILDCOUNT          Tests given fact type ,  multiple values can be passed seperated by comma 
                    {ARG_ENABLE_TEST} FS005,FS006                       Enables test cases for given file spec number , pass comma seperated value eg. FS005,FS006
                    {ARG_DISABLE_TEST} FS005,FS006                      Disable test cases for given file spec number  , pass comma seperated value eg. FS005,FS006
                    {ARG_SCHOOL_YEAR}                                   Pass a four digit year <Optional> if not passed will use current year
                    Example FACT-TYPE-TO-FILE-SPEC list
                    {factTypeToFileSpecStringHelper}
            ";

        /// <summary>
        /// --migrate argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<string> MIGRATION_OPTION = new Option<string>(ARG_MIGRATE)
        {
            Description = "Pass fact command seperated if needed to run migration",
            // DefaultValueFactory = parseResult => ALL_FACT,



        };

        /// <summary>
        /// --testallfact argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<bool> TEST_ALL_FACT_OPTION = new Option<bool>(ARG_TEST_ALL_FACT)
        {
            Description = "Pass true if needed to test all fact",
            DefaultValueFactory = parseResult => false
        };

        /// <summary>
        /// --testallfact argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<string> TEST_FILE_SPEC_OPTION = new Option<string>(ARG_TEST_FILE_SPEC)
        {
            Description = "Pass File Spec number eg. F005, or 005 etc.",
            //DefaultValueFactory = parseResult => EMPTY_STRING,
            //Required = true,

        };

        /// <summary>
        /// --testallfact argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<string> TEST_FACT_TYPE_OPTION = new Option<string>(ARG_TEST_FACT_TYPE)
        {
            Description = "Pass Fact Type assessment, childcount etc.",
            //DefaultValueFactory = parseResult => EMPTY_STRING,
            //Required = true
        };

        /// <summary>
        /// --enabletest argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<string> ENABLE_TEST_OPTION = new Option<string>(ARG_ENABLE_TEST)
        {
            Description = "Pass file spec numbers to enable eg. 002,005",
            //DefaultValueFactory = parseResult => EMPTY_STRING,
            //Required = true
        };

        /// <summary>
        /// --disabletest argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<string> DISABLE_TEST_OPTION = new Option<string>(ARG_DISABLE_TEST)
        {
            Description = "Pass file spec numbers to disable eg. 002,005",
            //DefaultValueFactory = parseResult => EMPTY_STRING,
            //Required = true
        };

        /// <summary>
        /// --schoolyear argument  System.CommandLine.Option 
        /// that has description and parser
        /// </summary>
        public static Option<int> SCHOOL_YEAR_OPTION = new Option<int>(ARG_SCHOOL_YEAR)
        {
            Description = "Pass School year needed",
            DefaultValueFactory = parseResult => DateTime.Now.Year,
        };


        /// <summary>
        /// Returns a json string , if Objects don't define ToString Method
        /// a convenient way to print info for debugging purposes
        /// </summary>
        /// <param name="anyObj"></param>
        /// <returns></returns>
        public static string TryToString(object anyObj)

        {
            if (anyObj != null)
            {
                var jsonStringDict = new Dictionary<object, object>
                {
                    {"toStringObj" ,anyObj}
                };
                return JsonSerializer.Serialize(jsonStringDict);
            }

            return EMPTY_STRING;


        }



    }




}